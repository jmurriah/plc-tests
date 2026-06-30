
PROGRAM _CYCLIC
	
	Feeder ACCESS ADR(gFeeder);
	
	//Version
	Feeder.Status.Version.iVersion0 := Feeder.Inputs.Comms.iVersion1;
	Feeder.Status.Version.iVersion1 := Feeder.Inputs.Comms.iVersion2;
	Feeder.Status.Version.iVersion2 := Feeder.Inputs.Comms.iVersion3;
	Feeder.Status.Version.iVersion3 := Feeder.Inputs.Comms.iVersion4;
	
	//Model evaluation
	iFeederModel.0 := Feeder.Inputs.xModelInput[0];
	iFeederModel.1 := Feeder.Inputs.xModelInput[1];
	iFeederModel.2 := Feeder.Inputs.xModelInput[2];
	
	Feeder.Parameters.xInstalled := iFeederModel>0;
	
	//Specify Type of Feeder Model
	Feeder.Status.iModel := iFeederModel;
	CASE iFeederModel OF
		1: Feeder.Status.FeederType := FEEDERTY_BOTTOM_14;
		2: Feeder.Status.FeederType := FEEDERTY_BOTTOM_18;
		3: Feeder.Status.FeederType := FEEDERTY_TOP;
		ELSE Feeder.Status.FeederType := FEEDERTY_UNDEFINED;
	END_CASE
	
	IF NOT Feeder.Parameters.xInstalled OR NOT Feeder.ParSw.xEnabled THEN
		ResetAlarms;
		Feeder.Outputs := OutputsReset;
		Feeder.Commands:=ResetCommands;
		Feeder.Status.DeviceStatus:=FEEDER_TURNED_OFF;
		CopyOfWriteData := EraseWriteData;
		UpdateStatus;
		RETURN;
	END_IF
	
	IF Feeder.Commands.xResetAlarms THEN ResetAlarms; END_IF
	
	Configuration;
	
	Status;
	
	IF NOT Feeder.Parameters.xSimulationMode THEN 
		AssignDataComms; 
	END_IF
	
	//Erasing data when ancillary not in remote
	IF NOT Feeder.Inputs.Comms.xRemote THEN
		CopyOfWriteData := EraseWriteData;
	END_IF
	
	Alarms;	
	
	IF Feeder.Status.Device.xFaulted OR Feeder.Status.Device.xTurnedOff OR NOT Feeder.Parameters.xLineInAuto THEN
		Feeder.Status.CtrlStatus:=FEEDERCTRL_STOPPED;
	END_IF
	
	CASE Feeder.Status.CtrlStatus OF
		FEEDERCTRL_STOPPED:
			Feeder.Outputs.Physical := PhysicalOutputsReset;
			IF Feeder.Status.DeviceStatus=FEEDER_INIT AND Feeder.Commands.xPrepare THEN
				Feeder.Status.CtrlStatus:=FEEDERCTRL_PREPARING;
			END_IF
			
		FEEDERCTRL_STOPPING:
			//Actions
			Feeder.Outputs.Physical := PhysicalOutputsReset;
			
			//Transition
			IF Feeder.Status.DeviceStatus=FEEDER_TURNED_OFF OR Feeder.Status.DeviceStatus=FEEDER_INIT OR Feeder.Status.DeviceStatus=FEEDER_READY THEN
				Feeder.Status.CtrlStatus:=FEEDERCTRL_STOPPED;
			END_IF
		
		FEEDERCTRL_CONTROLSTOPPING:
			
			
		FEEDERCTRL_PREPARING:
			Feeder.Outputs.Physical.xPrepareToFeed:=TRUE;
			IF Feeder.Status.DeviceStatus=FEEDER_READY THEN
				Feeder.Status.CtrlStatus:=FEEDERCTRL_PREPARED;
			END_IF
			
		FEEDERCTRL_PAUSED,
		FEEDERCTRL_PREPARED:
			IF Feeder.Commands.xStart THEN
				Feeder.Status.CtrlStatus:=FEEDERCTRL_STARTING;
			END_IF
			
		FEEDERCTRL_STARTING:
			//Actions
			Feeder.Outputs.Physical.xStartFeeding:=TRUE;
			
			//Transition
			IF Feeder.Status.DeviceStatus=FEEDER_FEEDING THEN
				Feeder.Status.CtrlStatus:=FEEDERCTRL_FEEDING;
			END_IF

			//Transition
			IF Feeder.Commands.xPause THEN
				Feeder.Status.CtrlStatus:=FEEDERCTRL_PAUSING;
			END_IF
			
		FEEDERCTRL_FEEDING:
			IF Feeder.Commands.xPause THEN
				Feeder.Status.CtrlStatus:=FEEDERCTRL_PAUSING;
			END_IF
			
		FEEDERCTRL_PAUSING:
			Feeder.Outputs.Physical.xStartFeeding:=FALSE;
			//Transition
			IF Feeder.Status.DeviceStatus=FEEDER_READY THEN
				Feeder.Status.CtrlStatus:=FEEDERCTRL_PAUSED;
			END_IF

	END_CASE
	
	IF Feeder.Commands.xStop THEN
		Feeder.Status.CtrlStatus:=FEEDERCTRL_STOPPING;
	ELSIF Feeder.Commands.xControlStop THEN
		Feeder.Status.CtrlStatus:=FEEDERCTRL_CONTROLSTOPPING;
	END_IF

	//Store the history of the status to easy the debug
	IF Feeder.Status.CtrlStatus<>StateHistory[0] THEN
		FOR iIndexHistory:=iHistoryLines TO 1 BY -1 DO 
			StateHistory[iIndexHistory]:=StateHistory[iIndexHistory-1];
		END_FOR;
		StateHistory[0]:=Feeder.Status.CtrlStatus;
	END_IF
	
	Feeder.Commands:=ResetCommands;
	
END_PROGRAM