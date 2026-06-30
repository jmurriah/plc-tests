
PROGRAM _CYCLIC
	
	Stacker ACCESS ADR(gStacker);
	
	//Version
	Stacker.Status.Version.iVersion0 := Stacker.Inputs.Comms.iVersion1;
	Stacker.Status.Version.iVersion1 := Stacker.Inputs.Comms.iVersion2;
	Stacker.Status.Version.iVersion2 := Stacker.Inputs.Comms.iVersion3;
	Stacker.Status.Version.iVersion3 := Stacker.Inputs.Comms.iVersion4;
	
	//Model evaluation
	iStackerModel.0 := Stacker.Inputs.xModelInput[0];
	iStackerModel.1 := Stacker.Inputs.xModelInput[1];
	iStackerModel.2 := Stacker.Inputs.xModelInput[2];
	
	Stacker.Parameters.xInstalled := iStackerModel>0;

	//Specify Type of Stacker Model
	Stacker.Status.iModel := iStackerModel;
	CASE iStackerModel OF
		1: Stacker.Status.StackerType := STACKERTY_FULL_S;
		2: Stacker.Status.StackerType := STACKERTY_BUNDLE_S;
		ELSE Stacker.Status.StackerType := STACKERTY_UNDEFINED;
	END_CASE
	
	IF NOT Stacker.Parameters.xInstalled OR NOT Stacker.ParSw.xEnabled THEN
		ResetAlarms;
		Stacker.Outputs := OutputsReset;
		Stacker.Commands:=ResetCommands;
		Stacker.Status.DeviceStatus:=STACKER_TURNED_OFF;
		CopyOfWriteData := EraseWriteData;
		UpdateStatus;
		RETURN;
	END_IF
	
	IF Stacker.Commands.xResetAlarms THEN ResetAlarms; END_IF
	
	Configuration;
	
	Status;
	
	IF NOT Stacker.Parameters.xSimulationMode THEN 
		AssignDataComms; 
	END_IF
	
	//Erasing data when ancillary not in remote
	IF NOT Stacker.Inputs.Comms.xRemote THEN
		CopyOfWriteData := EraseWriteData;
	END_IF
	
	Alarms;	
	
	IF Stacker.Status.Device.xFaulted OR Stacker.Status.Device.xTurnedOff OR NOT Stacker.Parameters.xLineInAuto THEN
		Stacker.Status.CtrlStatus:=STACKERCTRL_STOPPED;
		Stacker.Outputs := OutputsReset; //To reset outputs in this conditions instead of when stacker is stopped. So outputs as ejectstack, stackeject
	END_IF
	
	ton_ControlStopping.IN := Stacker.Status.CtrlStatus = STACKERCTRL_CONTROLSTOPPING;
	ton_ControlStopping.PT := T#1s;
	ton_ControlStopping();
	
	CASE Stacker.Status.CtrlStatus OF
		STACKERCTRL_STOPPED:
			//Actions
			Stacker.Outputs := OutputsReset;
			
			IF Stacker.Status.DeviceStatus=STACKER_INIT AND Stacker.Commands.xPrepare THEN
				Stacker.Status.CtrlStatus:=STACKERCTRL_PREPARING;
			END_IF

		STACKERCTRL_STOPPING:
			//Actions
			Stacker.Outputs := OutputsReset;
			
			//Transition
			IF Stacker.Status.DeviceStatus=STACKER_TURNED_OFF OR Stacker.Status.DeviceStatus=STACKER_INIT THEN
				Stacker.Status.CtrlStatus:=STACKERCTRL_STOPPED;
			END_IF
		
		STACKERCTRL_CONTROLSTOPPING:
			//Wait to have the belt empty and send the Stop order
			tonEmptyBelt.IN := Stacker.Parameters.xPreviousDeviceStopped;
			IF (Stacker.Status.xBeltEmpty AND ton_ControlStopping.Q AND EDGEPOS(Stacker.Orders.xDisableReadBlock)) OR NOT Stacker.Inputs.xRunning THEN
				Stacker.Status.CtrlStatus:=STACKERCTRL_STOPPING;
			END_IF
		
		STACKERCTRL_PREPARING:
			Stacker.Outputs.xPrepareToStack:=TRUE;
			IF Stacker.Status.DeviceStatus=STACKER_READY THEN
				Stacker.Status.CtrlStatus:=STACKERCTRL_PREPARED;
			END_IF
		
		STACKERCTRL_PAUSED,
		STACKERCTRL_PREPARED:
			IF Stacker.Commands.xStart THEN
				Stacker.Status.CtrlStatus:=STACKERCTRL_STARTING;
			END_IF
		
		STACKERCTRL_STARTING:
			Stacker.Outputs.xRun:=TRUE;
			IF Stacker.Status.DeviceStatus=STACKER_WORKING THEN
				Stacker.Status.CtrlStatus:=STACKERCTRL_WORKING;
			END_IF
			
		STACKERCTRL_WORKING:
			Stacker.Outputs.xRejectSheet := Stacker.Orders.xRejectSheet;
			IF Stacker.Commands.xPause THEN
				Stacker.Status.CtrlStatus:=STACKERCTRL_PAUSING;
			END_IF
		
		STACKERCTRL_PAUSING:			
			//Wait to empty the Belt to avoid media inside
			IF Stacker.Status.xBeltEmpty THEN
				Stacker.Status.CtrlStatus:=STACKERCTRL_PAUSED;
			END_IF

	END_CASE

	IF Stacker.Commands.xStop THEN
		Stacker.Status.CtrlStatus:=STACKERCTRL_STOPPING;
	ELSIF Stacker.Commands.xControlStop THEN
		Stacker.Status.CtrlStatus:=STACKERCTRL_CONTROLSTOPPING;
	END_IF

	//Store the history of the status to easy the debug
	IF Stacker.Status.CtrlStatus<>StateHistory[0] THEN
		FOR iIndexHistory:=iHistoryLines TO 1 BY -1 DO 
			StateHistory[iIndexHistory]:=StateHistory[iIndexHistory-1];
		END_FOR;
		StateHistory[0]:=Stacker.Status.CtrlStatus;
	END_IF
	
	//Commands sent by SW
	tp_CleanBelts(IN:=Stacker.Commands.xCleanBelts, PT:=T#2S);
	tp_EjectPileStack(IN:=Stacker.Commands.xEjectPileStack, PT:=T#2S);
	tp_EjectRejectStack(IN:=Stacker.Commands.xEjectRejectStack, PT:=T#2S);
	
	IF Stacker.Parameters.LineStatusSummary.xEmptyingBelts OR tp_CleanBelts.Q THEN Stacker.Outputs.xCleanBelts := TRUE; END_IF //Not using "tp_CleanBelts.Q"This output must be active all the time since command is received. Disabled when stop button pressed
	IF tp_EjectPileStack.Q THEN Stacker.Outputs.xStackEject := TRUE; END_IF
	IF tp_EjectRejectStack.Q AND Stacker.Parameters.Hw.xRejectEjectionAvailable THEN Stacker.Outputs.xEjectRejectStack := TRUE; END_IF
	
	//Fall down the commands
	Stacker.Commands:=ResetCommands;	
	
END_PROGRAM