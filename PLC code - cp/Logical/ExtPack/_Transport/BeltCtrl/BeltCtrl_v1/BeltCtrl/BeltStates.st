
ACTION BeltStates: 
	
	// ####################################################################
	// ####################################################################
	//
	// Check BeltStates.graphml to understand better this implementation

	// Here will be implemented a belt states controller,
CASE iBeltState OF
		
	BELT_NOT_INITIALIZED:
		// PowerOn Command
		IF AxisBelt.Status.ControllerReady AND NOT Belt.commands.Mode.xZero THEN
			// Switched on
			AxisBelt.Command.Power:=TRUE;	
			iBeltState:=BELT_SWITCH_ON;
			AxisBelt.Command.ErrorAcknowledge:= TRUE;
				
		END_IF
		ResetKnownSafetyErrors;
			

	BELT_SWITCH_ON:			

		IF (NOT AxisBelt.Status.HomeOK) AND AxisBelt.Status.PowerOn THEN
			//Doing Home Direct
			iBeltState:=BELT_HOMING;
			AxisBelt.Command.HomeDirect :=TRUE;
		ELSIF AxisBelt.Status.HomeOK THEN
			// All is initialized
	    	iBeltState:=BELT_INITIALIZED;
		END_IF;


	BELT_HOMING:
		IF AxisBelt.Status.HomeOK THEN
			//Doneg Home Direct
			iBeltState:=BELT_INITIALIZED;
		END_IF


	BELT_INITIALIZED:
		// Belt is initialized when axis state is StandStill
		// Waiting for enabled to run state	
		IF AxisBelt.Status.PLCopenState.StandStill THEN
			// Ready for movements
			iBeltState:=BELT_IDLE;
		ELSIF AxisBelt.Status.PLCopenState.ErrorStop OR AxisBelt.Status.PLCopenState.Disabled THEN	
			// Some was wrong!!!
			iBeltState:=BELT_ERROR;
		END_IF


	BELT_IDLE:
		// Waiting for movements
		// Command start belt movement
		IF Belt.commands.xRunBelt THEN
			iBeltState:=BELT_PREPARING_START;
		END_IF
		
		IF Belt.commands.xJogBelt THEN
			iBeltState:=BELT_JOGGING;
		END_IF


	BELT_PREPARING_START:
		IF NOT Belt.commands.xRunBelt THEN
			iBeltState:=BELT_IDLE;	

		ELSIF (Belt.commands.Mode.xAuto) AND NOT Belt.commands.xConsentBelt THEN
			// Waiting for consent
			iBeltState:=BELT_NOT_CONSENT;

		ELSIF xRunBeltOrderAfterSound THEN	
			// Waiting for movements
			iBeltState:=BELT_RUN_ORDER;
		END_IF			
			
	
	BELT_RUN_ORDER:
		//Launched movement
		IF NOT Belt.commands.xRunBelt THEN
			iBeltState:=BELT_IDLE;	

		ELSIF (Belt.commands.Mode.xAuto) AND NOT Belt.commands.xConsentBelt THEN
			// Waiting for consent
			iBeltState:=BELT_NOT_CONSENT;

		ELSIF Belt.states.xRuningBelt THEN	
			// Waiting for movements
			iBeltState:=BELT_RUNNING;
		END_IF			


	BELT_RUNNING:	
		IF NOT Belt.commands.xRunBelt THEN
			iBeltState:=BELT_IDLE;	

		ELSIF (Belt.commands.Mode.xAuto) AND NOT Belt.commands.xConsentBelt THEN
			// Waiting for consent
			iBeltState:=BELT_NOT_CONSENT;
		END_IF	
		

	BELT_JOGGING:	
		IF NOT Belt.commands.xJogBelt THEN
			iBeltState:=BELT_IDLE;
		END_IF
			
		
	BELT_NOT_CONSENT:
		IF NOT Belt.commands.xRunBelt THEN
			iBeltState:=BELT_IDLE;	

		ELSIF Belt.commands.xConsentBelt THEN
			// Consent received
			iBeltState:=BELT_PREPARING_START;
		END_IF	

			
	BELT_ERROR:
		
		iTimesExecutedErrorState:=iTimesExecutedErrorState+1;
			
		// Reset & ERRROR MANAGEMENT
		//		
		// Power off		
		AxisBelt.Command.Power:=FALSE;
	
		// Manual recovery:
		AxisBelt.Command.Reset:= (NOT AxisBelt.Status.ControllerReady AND Belt.commands.xReset); // OR
								//tpResetAnyDriveAlarm.Q;

		// Auto reseteable Id code as fast recovery:
		// Error Id 6023: Voltage sag at controller enable input
		// Error If 29209: MC_Power
		// Error if 29207: MC_Home	
		// Error if 29206: MC_MoveVelocity ? gives this error because controller is off
		// Error if 29216: MC_MoveVelocity ? gives this error because continuous movement is not possible
		// Error if 29217: Invalid input parameter
		
		ResetKnownSafetyErrors;
			
		//TOREVIEW: Why just acknowledge "known" errors????
		//TOREMOVE: AxisBelt.Command.ErrorAcknowledge:=(AxisBelt.Status.ErrorID = 29209) OR (AxisBelt.Status.ErrorID = 29207);
		AxisBelt.Command.ErrorAcknowledge:= Belt.commands.xReset;
		
		IF NOT Belt.Al.xAnyDriveAlarm THEN 
			iBeltState:= BELT_NOT_INITIALIZED;
		END_IF

	END_CASE
	
	/////////////////////////////////
	// Update belt states
	/////////////////////////////////
	
	// xZero state changes Belt state to not initialized
	// It avoids transport belt errors
	IF (Belt.commands.Mode.xZero) THEN
		iBeltState:=BELT_NOT_INITIALIZED;
		// Error state changes Belt state
	ELSIF Belt.Al.xAnyDriveAlarm THEN
		iBeltState:=BELT_ERROR; 
	END_IF	
	
	
	//Saving state history
	IF iBeltState<>StateHistory[0] THEN
		FOR iIndexHistory:=iHistoryLines TO 1 BY -1 DO 
			StateHistory[iIndexHistory]:=StateHistory[iIndexHistory-1];
		END_FOR
		StateHistory[0]:=iBeltState;
	END_IF
	
	
	Belt.states.State:=	iBeltState;

	///////////////////////
	// Timer management
	///////////////////////
	
	// Timer sounds Belt starting
	T_SoundBelt.IN:= iBeltState=BELT_PREPARING_START;
	// If time beeping not configured, use default value
	IF Belt.parameters.tiTimeBeepBeforeMove = 0 THEN
		T_SoundBelt.PT:= T#3s;
	ELSE
		T_SoundBelt.PT:= Belt.parameters.tiTimeBeepBeforeMove;
	END_IF		
	T_SoundBelt();	
	xRunBeltOrderAfterSound:=T_SoundBelt.Q;	
	
	//Pulse to set a command reset to drive when in error state
	tpResetAnyDriveAlarm(IN:=Belt.Al.xAnyDriveAlarm, PT:=T#500ms);
	
END_ACTION


ACTION ResetKnownSafetyErrors:
	
	IF xAvoidResettingSafetyErrors THEN
		RETURN;
	END_IF

	iReasonAutoAcknowledge.0 := AxisBelt.Status.ErrorID = 29209;
	iReasonAutoAcknowledge.1 := AxisBelt.Status.ErrorID = 6058; // Not signal in Enable 1
	iReasonAutoAcknowledge.2 := AxisBelt.Status.ErrorID = 6059; // Not signal in Enable 2
	iReasonAutoAcknowledge.3 := AxisBelt.Status.ErrorID = 6023;
	iReasonAutoAcknowledge.4 := AxisBelt.Status.ErrorID = 4005;
	iReasonAutoAcknowledge.5 := AxisBelt.Status.ErrorID = 29203; //Not possible to start controller
	
			
	// If the drive has Enable errors but we know we have a Safety problem, auto acknowledge the errors
	IF (*Belt.commands.xExternalSafetyStop AND*) iReasonAutoAcknowledge > 0 THEN
		AxisBelt.Command.ErrorAcknowledge := TRUE;		
	END_IF	

END_ACTION
