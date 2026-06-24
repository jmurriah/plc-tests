
ACTION State: 

	xCurrentStateChanged := CurrentState_copy <> CurrentState;
	IF xCurrentStateChanged THEN iStatusChanges := iStatusChanges + 1; END_IF
	CurrentState_copy := CurrentState;
	
	CASE CurrentState OF
		NIRADPEW_NOT_INITIALIZED:
			ResetSignals;
			IF TRUE THEN
				CurrentState := NIRADPEW_INIT;
			END_IF
			
		NIRADPEW_COMMS_ERROR:
			IF NOT data.Alarms.xCommsError THEN
				CurrentState := NIRADPEW_NOT_INITIALIZED;
			END_IF
			
		NIRADPEW_INIT:
			IF data.Signals.In.xSafetyOK THEN
				CurrentState := NIRADPEW_IDLE;
			END_IF
			
		NIRADPEW_IDLE:
			IF data.Commands.xPrepare THEN
				data.Commands.xPrepare := FALSE;
				CurrentState := NIRADPEW_POWER_ON;
			END_IF
			data.Commands.xStart := FALSE;
			data.Commands.xStop := FALSE;
			
		NIRADPEW_POWER_ON:
			data.Signals.Out.xPowerOn := TRUE;
			
			xAllPowered.0 := NOT data.Parameters.Comms.Modules[1].EnableMod OR data.Status.Comms.Modules[1].xPowered;
			xAllPowered.1 := NOT data.Parameters.Comms.Modules[2].EnableMod OR data.Status.Comms.Modules[2].xPowered;
			IF xAllPowered = 16#0003 THEN
				CurrentState := NIRADPEW_POWERED;
			END_IF
			
		NIRADPEW_POWERED:
			IF data.Status.Comms.xBeltRunning THEN
				CurrentState := NIRADPEW_RUNNING_BELT;
			END_IF
			
		NIRADPEW_RUNNING_BELT:
			IF data.Signals.In.xReady THEN
				CurrentState := NIRADPEW_READY;
			END_IF
			IF data.Commands.xStop THEN
				data.Commands.xStop := FALSE;
				CurrentState := NIRADPEW_IDLE;
			END_IF
			
			
		NIRADPEW_READY:
			IF data.Commands.xStop THEN
				data.Commands.xStop := FALSE;
				CurrentState := NIRADPEW_IDLE;
			ELSIF data.Commands.xStart THEN
				data.Commands.xStart := FALSE;
				CurrentState := NIRADPEW_STARTING;
			END_IF
						
		NIRADPEW_STARTING:
			IF data.Signals.In.xInProcess THEN
				CurrentState := NIRADPEW_RUNNING;
			END_IF
			IF data.Commands.xStop OR NOT gBelt.states.xRuningBelt THEN
				data.Commands.xStop := FALSE;
				CurrentState := NIRADPEW_IDLE;
			END_IF
			
		NIRADPEW_RUNNING:
			IF data.Commands.xStop THEN
				data.Commands.xStop := FALSE;
				CurrentState := NIRADPEW_IDLE;
			END_IF
			
		NIRADPEW_ERROR:
			IF NOT data.Signals.In.xFault THEN 
				CurrentState := NIRADPEW_IDLE;
			END_IF
		
	END_CASE

	IF data.Alarms.xCommsError THEN
		CurrentState := NIRADPEW_COMMS_ERROR;
	END_IF
	
	IF data.Signals.In.xFault OR NOT data.Parameters.xEnableNir OR data.Parameters.StateMode = PRINTERGEN_ZERO THEN
		CurrentState := NIRADPEW_NOT_INITIALIZED;//NIRADPEW_ERROR
	END_IF

	//Store the history of the status to easy the debug
	IF CurrentState<>StateHistory[0] THEN
		FOR iIndexHistory:=iHistoryLines TO 1 BY -1 DO 
			StateHistory[iIndexHistory]:=StateHistory[iIndexHistory-1];
		END_FOR
		StateHistory[0]:=CurrentState;
	END_IF	
	
	data.State := CurrentState;
	
	
	//Modules status	
	xAnyModuleEnabled := FALSE;
	FOR iIndexModule:=1 TO data.Parameters.iTotalModules DO
		IF data.Parameters.Comms.Modules[iIndexModule].EnableMod THEN
			xAnyModuleEnabled := TRUE;
		END_IF
	END_FOR
	data.Status.xAnyModuleEnabled := xAnyModuleEnabled;

	
END_ACTION

ACTION ResetSignals:

	data.Signals.Out := SignalsOutReseted;
	
END_ACTION
