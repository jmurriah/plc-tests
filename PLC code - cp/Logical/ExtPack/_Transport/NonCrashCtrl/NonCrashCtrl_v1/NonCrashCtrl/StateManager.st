
ACTION StateManager: 

		// ####################################################################
	// ####################################################################
	//
	// Check dataNCStates.graphml to understand better this implementation

	// Here will be implemented a belt states controller,
	CASE StatusCtrl OF
		
		NONCRASH_NOT_INITIALIZED:
			// PowerOn Command
			IF AxisMotor.Status.ControllerReady THEN
				// Switched on
				AxisMotor.Command.Power:=TRUE;	
				StatusCtrl:=NONCRASH_SWITCH_ON;
				AxisMotor.Command.ErrorAcknowledge:= TRUE;
			END_IF

		NONCRASH_SWITCH_ON:			

			IF (NOT AxisMotor.Status.HomeOK) AND AxisMotor.Status.PowerOn THEN
				//Doing Home Direct
				StatusCtrl:=NONCRASH_HOMING;
				AxisMotor.Command.HomeDirect :=TRUE;
			ELSIF AxisMotor.Status.HomeOK THEN
				// All is initialized
				StatusCtrl:=NONCRASH_INITIALIZED;
			END_IF;

		NONCRASH_HOMING:
			//Done Home Direct
			IF AxisMotor.Status.HomeOK THEN
				StatusCtrl:=NONCRASH_INITIALIZED;
			END_IF
			
		NONCRASH_INITIALIZED:
			// dataNC is initialized when axis state is StandStill
			// Waiting for enabled to run state	
			IF AxisMotor.Status.PLCopenState.StandStill THEN
				// Ready for movements
				StatusCtrl:=NONCRASH_IDLE;
			ELSIF AxisMotor.Status.PLCopenState.ErrorStop OR AxisMotor.Status.PLCopenState.Disabled THEN	
				// Some was wrong!!!
				StatusCtrl:=NONCRASH_ERROR;
			END_IF
			 

		NONCRASH_IDLE:
			// Waiting for movements
			// Command start belt movement
			IF dataNC.Commands.xRun THEN
				StatusCtrl:=NONCRASH_RUN_ORDER;
			END_IF

	
		NONCRASH_RUN_ORDER:
			//Launched movement
			IF NOT dataNC.Commands.xRun THEN
				StatusCtrl:=NONCRASH_IDLE;	

			ELSIF AxisMotor.Status.PLCopenState.ContinuousMotion THEN	
				// Waiting for movements
				StatusCtrl:=NONCRASH_RUNNING;
			END_IF			


		NONCRASH_RUNNING:	
			IF NOT dataNC.Commands.xRun THEN
				StatusCtrl:=NONCRASH_IDLE;	
			END_IF
			
			
		NONCRASH_ERROR:
		
			iTimesExecutedErrorState:=iTimesExecutedErrorState+1;
			
			// Power off		
			AxisMotor.Command.Power:=FALSE;
	
			// Manual recovery:
			AxisMotor.Command.Reset:= dataNC.Commands.xReset AND NOT AxisMotor.Status.ControllerReady;
		
			//TOREVIEW: Why just acknowledge "known" errors????
			//TOREMOVE: AxisMotor.Command.ErrorAcknowledge:=(AxisMotor.Status.ErrorID = 29209) OR (AxisMotor.Status.ErrorID = 29207);
			
//			regErrors.0 := AxisMotor.Status.ErrorID = 73;
//			regErrors.1 := AxisMotor.Status.ErrorID = 4005;
//			regErrors.2 := AxisMotor.Status.ErrorID = 5005;
//			regErrors.3 := AxisMotor.Status.ErrorID = 6021;
//			regErrors.4 := AxisMotor.Status.ErrorID = 6023;
//			regErrors.5 := AxisMotor.Status.ErrorID = 6038;
//			regErrors.6 := AxisMotor.Status.ErrorID = 7100;
//			regErrors.7 := AxisMotor.Status.ErrorID = 7215;
//			regErrors.8 := AxisMotor.Status.ErrorID = 29203;
//			regErrors.9 := AxisMotor.Status.ErrorID = 29205;
//			regErrors.10 := AxisMotor.Status.ErrorID = 29206;
//			regErrors.11 := AxisMotor.Status.ErrorID = 29207;
//			regErrors.12 := AxisMotor.Status.ErrorID = 29209;
//			regErrors.13 := AxisMotor.Status.ErrorID = 29216;
//			regErrors.14 := AxisMotor.Status.ErrorID = 29217;
//			regErrors.15 := AxisMotor.Status.ErrorID = 29238;
//			regErrors.16 := AxisMotor.Status.ErrorID = 29226;
//			regErrors.17 := AxisMotor.Status.ErrorID = 32144;
//			regErrors.18 := AxisMotor.Status.ErrorID = 50000;

			AxisMotor.Command.ErrorAcknowledge:= dataNC.Commands.xReset AND AxisMotor.Status.ErrorID<>0;
		
			IF AxisMotor.Status.ErrorID = 0  THEN 
				StatusCtrl:= NONCRASH_NOT_INITIALIZED;
			END_IF

	END_CASE
	
	/////////////////////////////////
	// Update belt states
	/////////////////////////////////
	
	// xZero state changes dataNC state to not initialized
	// It avoids transport belt errors
	IF (dataNC.Parameters.Mode.xZero OR NOT dataNC.parSw.xEnable) THEN
		StatusCtrl:=NONCRASH_NOT_INITIALIZED;
		// Error state changes dataNC state
	ELSIF AxisMotor.Status.ErrorID <> 0 OR dataNC.Alarms.xControllerNotReady THEN
		StatusCtrl:=NONCRASH_ERROR;
	END_IF	
	
	dataNC.Status.State := StatusCtrl;

	
END_ACTION
