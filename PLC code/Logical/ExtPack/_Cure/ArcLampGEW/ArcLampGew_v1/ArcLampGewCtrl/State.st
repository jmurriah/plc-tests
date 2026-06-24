
ACTION State: 

	xCurrentStateChanged := CurrentState_copy <> CurrentState;
	IF xCurrentStateChanged THEN iStatusChanges := iStatusChanges + 1; END_IF
	CurrentState_copy := CurrentState;

	tonRetryCommand.IN := NOT xCurrentStateChanged AND NOT tonRetryCommand.Q;
	tonRetryCommand.PT := t#400ms;
	tonRetryCommand();
	
	CASE CurrentState OF
		ARCLGEW_NOT_INITIALIZED:
			IF NOT data.Alarms.xCommsError THEN
				CurrentState := ARCLGEW_INITIALIZING;
			END_IF
			
		ARCLGEW_COMMS_ERROR:
			IF NOT data.Alarms.xCommsError THEN
				CurrentState := ARCLGEW_INITIALIZING;
			END_IF
			
		ARCLGEW_INITIALIZING:
			IF NOT data.Status.xAnyLampInError THEN
				CurrentState := ARCLGEW_IDLE;
			END_IF
			
		ARCLGEW_IDLE:
			IF data.Commands.xPrepare AND data.Status.xAnyLampSelected THEN
				data.Commands.xPrepare := FALSE;
				CurrentState := ARCLGEW_DESELEC;
			END_IF
			data.Commands.xStart := FALSE;
			data.Commands.xStop := FALSE;
			
		ARCLGEW_DESELEC:
			IF xCurrentStateChanged OR tonRetryCommand.Q THEN 
				data.Commands.InternalComms.xDeselectAll := TRUE;
			END_IF
			
			//After sending a deselec, send a read to read if lamps have beed deselected
			IF data.Status.CommsStatus=ARCLG_IDLE AND commsStatus_copy=ARCLG_DESELEC_ALL THEN
				//data.Commands.InternalComms.xReadLampsUv;
				xReadSystemDelay := TRUE;
			END_IF
			
			//Go ahead when really deselected
			IF NOT data.Status.Lamps[1].IsSelected AND NOT data.Status.Lamps[2].IsSelected THEN
				CurrentState := ARCLGEW_SELECTING;				
			END_IF
			
					
		ARCLGEW_SELECTING:
			IF xCurrentStateChanged THEN 
				iLampComs:=1; 
				PrepareNextEnabledLamp;
			END_IF
			
			IF tonRetryCommand.Q THEN 
				data.Commands.InternalComms.xSelectLamp := TRUE;
			END_IF
			
			//After a communication, review next steps
			IF data.Status.CommsStatus=ARCLG_IDLE AND commsStatus_copy=ARCLG_SELEC_LAMP THEN
				//If finish communication with the last lamp, ask to review status
				data.Commands.InternalComms.xReadLampsUv := TRUE;
				
				IF data.Status.Lamps[iLampComs].IsSelected THEN
					IF (iLampComs = iMaxLampSelected) THEN
						CurrentState := ARCLGEW_SET_PARAMS;
					ELSE
						iLampComs := iLampComs + 1; 
						PrepareNextEnabledLamp;
					END_IF
				END_IF
			END_IF
				
		ARCLGEW_SET_PARAMS:
			IF xCurrentStateChanged OR tonRetryCommand.Q THEN 
				data.Commands.InternalComms.xSetPower := TRUE;
			END_IF
			IF data.Status.CommsStatus=ARCLG_IDLE AND commsStatus_copy=ARCLG_SET_POWER THEN
				CurrentState := ARCLGEW_SEND_START;
			END_IF			
			
		ARCLGEW_SEND_START:
			IF xCurrentStateChanged OR tonRetryCommand.Q THEN 
				data.Commands.InternalComms.xStartSelected := TRUE;
			END_IF
			IF data.Status.CommsStatus=ARCLG_IDLE AND commsStatus_copy=ARCLG_START_SELECTED THEN
				CurrentState := ARCLGEW_STARTING;
			END_IF			
			
		ARCLGEW_STARTING:	
			
			tonInputReady.IN := NOT xCurrentStateChanged AND data.Signals.In.xReady;
			tonInputReady.PT := t#500ms;
			tonInputReady();
			
			IF data.Commands.xStop THEN
				data.Commands.xStop := FALSE;
				CurrentState := ARCLGEW_SEND_STOP;
			ELSIF tonInputReady.Q THEN
				CurrentState := ARCLGEW_READY;
			END_IF

		ARCLGEW_READY:
			IF data.Commands.xStop THEN
				data.Commands.xStop := FALSE;
				CurrentState := ARCLGEW_SEND_STOP;
			ELSIF data.Commands.xStart THEN
				data.Commands.xStart := FALSE;
				CurrentState := ARCLGEW_RUNNING;
			END_IF
						
		ARCLGEW_RUNNING:
			IF data.Commands.xStop THEN
				data.Commands.xStop := FALSE;
				CurrentState := ARCLGEW_SEND_STOP;
			END_IF
			
		ARCLGEW_SEND_STOP:
			IF xCurrentStateChanged OR tonRetryCommand.Q THEN 
				data.Commands.InternalComms.xStopSelected := TRUE;
			END_IF

			tonInputReady.IN := NOT xCurrentStateChanged AND NOT data.Signals.In.xReady;
			tonInputReady.PT := t#500ms;
			tonInputReady();

			IF tonInputReady.Q THEN
				CurrentState := ARCLGEW_IDLE;
			END_IF
			
		ARCLGEW_ERROR:
			IF NOT data.Signals.In.xFault THEN 
				CurrentState := ARCLGEW_IDLE;
			END_IF
		
	END_CASE

	IF data.Alarms.xCommsError THEN
		CurrentState := ARCLGEW_COMMS_ERROR;
	END_IF
	
	IF data.Signals.In.xFault OR NOT data.Status.xEnabledArcLamp OR data.Parameters.StateMode = PRINTERGEN_ZERO THEN
		CurrentState := ARCLGEW_NOT_INITIALIZED;
	END_IF


	//Store the history of the status to easy the debug
	IF CurrentState<>StateHistory[0] THEN
		FOR iIndexHistory:=iHistoryLines TO 1 BY -1 DO 
			StateHistory[iIndexHistory]:=StateHistory[iIndexHistory-1];
		END_FOR;
		StateHistory[0]:=CurrentState;
	END_IF	
	
	data.State := CurrentState;
	
	
	//////////////////////////////////////////
	///// AUXILIARY DATA FOR THE TRANSITIONS
	xAnyLampSelected := FALSE;
	iMaxLampSelected := 0;
	FOR iLamp:=1 TO data.Parameters.iLampQuantity DO
		data.Status.Lamps[iLamp].Enabled := data.Parameters.Lamps[iLamp].Enable;
		IF data.Parameters.Lamps[iLamp].Enable THEN
			xAnyLampSelected := TRUE;
			iMaxLampSelected := iLamp;
		END_IF
	END_FOR;
	data.Status.xAnyLampSelected := xAnyLampSelected;
	
END_ACTION

ACTION PrepareNextEnabledLamp:
	
	FOR iLamp:=iLampComs TO data.Parameters.iLampQuantity DO
		IF data.Parameters.Lamps[iLamp].Enable THEN
			iLampComs := iLamp;
			EXIT;
		END_IF
	END_FOR;
	data.Commands.InternalComms.xSelectLamp := TRUE;

END_ACTION