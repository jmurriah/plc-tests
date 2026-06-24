
ACTION ResetComms: 

	CanGetState.enable := TRUE;
	CanGetState.node := Icla.Parameter.Node;
	CanGetState.pDevice := ADR(Icla.Parameter.Network);
	CanGetState();
	
	iReasonNotComms.0 := CanGetState.state = coPREOPERATIONAL;
	iReasonNotComms.1 := CanGetState.state = coUNKNOWN;
	iReasonNotComms.2 := CanGetState.state = coNOTAVAIL;
	iReasonNotComms.3 := NOT Icla.Status.xModuleOK;
	
	tonNotComms.IN := iReasonNotComms > 0;
	tonNotComms.PT := t#3s;
	tonNotComms();
	
	
	xChangedResetCommsState := CanResetState_copy <> CanResetState;
	CanResetState_copy := CanResetState;

	CASE CanResetState OF

		COCOMSR_UNDEFINED,
		COCOMSR_COMMUNICATING:
			
			iTimesTryToReset := 0;
			
			//If time in error, define an error comms
			IF tonNotComms.Q THEN
				CanResetState := COCOMSR_COMMSERROR;
			END_IF
		
			
		COCOMSR_COMMSERROR:
			
			//Start the resetting process
			IF Icla.Command.Reset AND Icla.Parameter.xAutoresetComms THEN
				CanResetState := COCOMSR_RESETTING;
			END_IF
			
			//Communication has returned to work
			IF CanGetState.state = coOPERATIONAL THEN
				CanResetState := COCOMSR_COMMUNICATING;
			END_IF
			
			
		COCOMSR_RESETTING:
			
			CANopenReset.enable := TRUE;
			CANopenReset.node := Icla.Parameter.Node;
			CANopenReset.pDevice := ADR(Icla.Parameter.Network);
			CANopenReset.state := coRESET_NODE;
			CANopenReset();
			
			IF CANopenReset.status = ERR_OK THEN
				lastCanOpenResetError := CANopenReset.error;
				CANopenReset(enable := FALSE);
				CanResetState := COCOMSR_WAITINGTOBERESETTED;
			END_IF
			
			tonCommsErrorResetting.IN := NOT xChangedResetCommsState;
			tonCommsErrorResetting.PT := t#10s;
			tonCommsErrorResetting();

			IF tonCommsErrorResetting.Q THEN
				lastResetingState := CanGetState.state;
				lastFbResetStatus := CANopenReset.status;
				tonCommsErrorResetting(IN:=FALSE);
				CANopenReset(enable:=FALSE);
				CanResetState := COCOMSR_RESETTING_ERROR;
			END_IF
			
			
		COCOMSR_WAITINGTOBERESETTED:
			
			//Communication has returned to work
			IF CanGetState.state = coOPERATIONAL THEN
				CanResetState := COCOMSR_COMMUNICATING;
			END_IF

			tonCommsErrorResetting.IN := NOT xChangedResetCommsState;
			tonCommsErrorResetting.PT := t#4s;
			tonCommsErrorResetting();

			IF tonCommsErrorResetting.Q THEN
				lastResetingState := CanGetState.state;
				lastFbResetStatus := CANopenReset.status;
				tonCommsErrorResetting(IN:=FALSE);
				CanResetState := COCOMSR_RESETTING_ERROR;
			END_IF
			
			
		COCOMSR_RESETTING_ERROR:

			//After an error, wait to try again
			tonCommsErrorResetting.IN := NOT xChangedResetCommsState;
			tonCommsErrorResetting.PT := t#500ms;
			tonCommsErrorResetting();

			IF tonCommsErrorResetting.Q  AND iTimesTryToReset < 6 THEN
				iTimesTryToReset := iTimesTryToReset + 1;
				CanResetState := COCOMSR_RESETTING;
			ELSIF tonCommsErrorResetting.Q THEN
				CanResetState := COCOMSR_COMMSERROR;
			END_IF
		
	 
	END_CASE;
	
END_ACTION
