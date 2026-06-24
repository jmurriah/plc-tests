
ACTION ValvesUnit:

	//If comms is not CanOpen, just go out
	IF Block.parameters.Hw.ValvesCommsType <> COMMS_CANOPEN THEN
		RETURN;
	END_IF
	
	CanGetState.enable := TRUE;
	CanGetState.node := Block.parameters.Hw.ValvesNode;
	CanGetState.pDevice := ADR('IF7');
	CanGetState();
	
	iReasonNotValveComms.0 := CanGetState.state = coPREOPERATIONAL;
	iReasonNotValveComms.1 := CanGetState.state = coUNKNOWN;
	iReasonNotValveComms.2 := CanGetState.state = coNOTAVAIL;
	
	tonNotValveComms.IN := iReasonNotValveComms > 0;
	tonNotValveComms.PT := t#3s;
	tonNotValveComms();
	
	
	xChangedValvesState := ValvesCanResetState_copy <> ValvesCanResetState;
	ValvesCanResetState_copy := ValvesCanResetState;

	CASE ValvesCanResetState OF

		COCOMSR_UNDEFINED,
		COCOMSR_COMMUNICATING:
			
			iTimesTryToReset := 0;
			
			//If time in error, define an error comms
			IF tonNotValveComms.Q THEN
				ValvesCanResetState := COCOMSR_COMMSERROR;
			END_IF
		
			
		COCOMSR_COMMSERROR:
			
			//Start the resetting process
			IF Block.commands.xReset THEN
				ValvesCanResetState := COCOMSR_RESETTING;
			END_IF
			
			//Communication has returned to work
			IF CanGetState.state = coOPERATIONAL THEN
				ValvesCanResetState := COCOMSR_COMMUNICATING;
			END_IF
			
			
		COCOMSR_RESETTING:
			
			CANopenResetValves.enable := TRUE;
			CANopenResetValves.node := Block.parameters.Hw.ValvesNode;
			CANopenResetValves.pDevice := ADR('IF7');
			CANopenResetValves.state := coRESET_NODE;
			CANopenResetValves();
			
			IF CANopenResetValves.status = ERR_OK THEN
				lastCanOpenResetError := CANopenResetValves.error;
				CANopenResetValves(enable := FALSE);
				ValvesCanResetState := COCOMSR_WAITINGTOBERESETTED;
			END_IF
			
			tonValveCommsErrorResetting.IN := NOT xChangedValvesState;
			tonValveCommsErrorResetting.PT := t#10s;
			tonValveCommsErrorResetting();

			IF tonValveCommsErrorResetting.Q THEN
				lastResetingState := CanGetState.state;
				lastFbResetStatus := CANopenResetValves.status;
				tonValveCommsErrorResetting(IN:=FALSE);
				CANopenResetValves(enable:=FALSE);
				ValvesCanResetState := COCOMSR_RESETTING_ERROR;
			END_IF
			
			
		COCOMSR_WAITINGTOBERESETTED:
			
			//Communication has returned to work
			IF CanGetState.state = coOPERATIONAL THEN
				ValvesCanResetState := COCOMSR_COMMUNICATING;
			END_IF

			tonValveCommsErrorResetting.IN := NOT xChangedValvesState;
			tonValveCommsErrorResetting.PT := t#4s;
			tonValveCommsErrorResetting();

			IF tonValveCommsErrorResetting.Q THEN
				lastResetingState := CanGetState.state;
				lastFbResetStatus := CANopenResetValves.status;
				tonValveCommsErrorResetting(IN:=FALSE);
				ValvesCanResetState := COCOMSR_RESETTING_ERROR;
			END_IF
			
			
		COCOMSR_RESETTING_ERROR:

			//After an error, wait to try again
			tonValveCommsErrorResetting.IN := NOT xChangedValvesState;
			tonValveCommsErrorResetting.PT := t#500ms;
			tonValveCommsErrorResetting();

			IF tonValveCommsErrorResetting.Q  AND iTimesTryToReset < 6 THEN
				iTimesTryToReset := iTimesTryToReset + 1;
				ValvesCanResetState := COCOMSR_RESETTING;
			ELSIF tonValveCommsErrorResetting.Q THEN
				ValvesCanResetState := COCOMSR_COMMSERROR;
			END_IF
	 
	END_CASE

	
END_ACTION
