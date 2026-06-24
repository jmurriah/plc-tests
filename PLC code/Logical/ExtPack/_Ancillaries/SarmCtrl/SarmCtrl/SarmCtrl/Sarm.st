
PROGRAM _CYCLIC
	
	Sarm ACCESS ADR(gSarm);
	
	//Version
	Sarm.Status.Version.iVersion0 := Sarm.Inputs.Comms.iVersion1;
	Sarm.Status.Version.iVersion1 := Sarm.Inputs.Comms.iVersion2;
	Sarm.Status.Version.iVersion2 := Sarm.Inputs.Comms.iVersion3;
	Sarm.Status.Version.iVersion3 := Sarm.Inputs.Comms.iVersion4;
	
	//Model evaluation
	iSarmModel.0 := Sarm.Inputs.xModelInput[0];
	iSarmModel.1 := Sarm.Inputs.xModelInput[1];
	iSarmModel.2 := Sarm.Inputs.xModelInput[2];
	
	Sarm.Status.xInstalled := Sarm.Parameters.xInstalled AND iSarmModel>0;
	
	//Specify Type of Sarm Model
	Sarm.Status.iModel := iSarmModel;
	CASE iSarmModel OF
		1: Sarm.Status.SarmType := SARMTY_V1;
		ELSE Sarm.Status.SarmType := SARMTY_UNDEFINED;
	END_CASE
	
	IF NOT Sarm.Status.xInstalled OR NOT Sarm.ParSw.xEnabled THEN
		ResetAlarms;
		Sarm.Outputs := OutputsReset;
		Sarm.Commands:=ResetCommands;
		Sarm.Status.DeviceStatus:=Sarm_TURNED_OFF;
		CopyOfWriteData := EraseWriteData;
		UpdateStatus;
		RETURN;
	END_IF
	
	IF Sarm.Commands.xResetAlarms THEN ResetAlarms; END_IF
	
	Configuration;
	
	Status;
	
	IF NOT Sarm.Parameters.xSimulationMode THEN 
		AssignDataComms; 
	END_IF
	
	//Erasing data when ancillary not in remote
	IF NOT Sarm.Inputs.Comms.xRemote THEN
		CopyOfWriteData := EraseWriteData;
	END_IF
	
	Alarms;	
	
	IF Sarm.Status.Device.xFaulted OR Sarm.Status.Device.xTurnedOff OR NOT Sarm.Parameters.xLineInAuto THEN
		Sarm.Status.CtrlStatus:=SARMCTRL_STOPPED;
	END_IF
	
	CASE Sarm.Status.CtrlStatus OF
		SARMCTRL_STOPPED:
			Sarm.Outputs := OutputsReset;
			IF Sarm.Status.DeviceStatus=Sarm_INIT AND Sarm.Commands.xStart THEN
				Sarm.Status.CtrlStatus:=SARMCTRL_STARTING;
			END_IF
			
		SARMCTRL_STOPPING:
			//Actions
			Sarm.Outputs := OutputsReset;
			
			Sarm.Outputs.xFastStop := TRUE;
			
			//Transition
			IF Sarm.Status.DeviceStatus=Sarm_TURNED_OFF OR Sarm.Status.DeviceStatus=Sarm_INIT OR Sarm.Status.DeviceStatus=Sarm_READY THEN
				Sarm.Status.CtrlStatus:=SARMCTRL_STOPPED;
			END_IF
		
		SARMCTRL_CONTROLSTOPPING:
			//Wait to have the belt empty and send the Stop order
			IF (Sarm.Status.xBeltEmpty AND EDGEPOS(Sarm.Orders.xDisableReadBlock)) OR NOT Sarm.Inputs.xRunning THEN
				Sarm.Status.CtrlStatus:=SARMCTRL_STOPPING;
			END_IF
			
		SARMCTRL_STARTING:
			//Actions
			Sarm.Outputs.xStartTransport:=TRUE;
			
			//Transition
			IF Sarm.Status.DeviceStatus=Sarm_READY THEN
				Sarm.Status.CtrlStatus:=SARMCTRL_RUNNING;
			END_IF

			
		SARMCTRL_RUNNING:
			IF Sarm.Commands.xPause THEN
				Sarm.Status.CtrlStatus:=SARMCTRL_PAUSING;
			END_IF
			
		
		SARMCTRL_PAUSING:
			IF Sarm.Status.xBeltEmpty THEN
				//Transition
				Sarm.Status.CtrlStatus:=SARMCTRL_PAUSED;
			END_IF
		
		SARMCTRL_PAUSED:		
			IF Sarm.Commands.xStart THEN
				Sarm.Status.CtrlStatus:=SARMCTRL_STARTING;
			END_IF

	END_CASE
	
	IF Sarm.Commands.xStop THEN
		Sarm.Status.CtrlStatus:=SARMCTRL_STOPPING;
	ELSIF Sarm.Commands.xControlStop THEN
		Sarm.Status.CtrlStatus:=SARMCTRL_CONTROLSTOPPING;
	END_IF

	//Store the history of the status to easy the debug
	IF Sarm.Status.CtrlStatus<>StateHistory[0] THEN
		FOR iIndexHistory:=iHistoryLines TO 1 BY -1 DO 
			StateHistory[iIndexHistory]:=StateHistory[iIndexHistory-1];
		END_FOR
		StateHistory[0]:=Sarm.Status.CtrlStatus;
	END_IF
	
	Sarm.Commands:=ResetCommands;
	
END_PROGRAM