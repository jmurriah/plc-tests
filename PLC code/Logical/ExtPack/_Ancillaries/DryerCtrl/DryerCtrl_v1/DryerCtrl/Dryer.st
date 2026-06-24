
PROGRAM _CYCLIC
	
	Dryer ACCESS ADR(gDryerAnc);
	 
//	Dryer.Status.Version.iVersion0 := ;
//	Dryer.Status.Version.iVersion1 := ;
//	Dryer.Status.Version.iVersion2 := ;
//	Dryer.Status.Version.iVersion3 := ;
	
	//Model evaluation
	iDryerModel.0 := Dryer.Inputs.xModelInput[0];
	iDryerModel.1 := Dryer.Inputs.xModelInput[1];
	iDryerModel.2 := Dryer.Inputs.xModelInput[2];
	
	Dryer.Parameters.xInstalled := iDryerModel>0;
	
	//Specify Type of primer Model
	Dryer.Status.iModel := iDryerModel;
	CASE iDryerModel OF
		1: Dryer.Status.DryerType := DRYERTY_EFI;
		ELSE Dryer.Status.DryerType := DRYERTY_UNDEFINED;
	END_CASE
	
	IF NOT Dryer.Parameters.xInstalled OR NOT Dryer.ParSw.xEnabled THEN
		ResetAlarms;
		Dryer.Outputs := OutputsReset;
		Dryer.Commands:=CommandsReseted;
		Dryer.Status.DeviceStatus:= DRYER_TURNED_OFF;
		UpdateStatus;
		RETURN;
	END_IF
	
	IF Dryer.Commands.xResetAlarms THEN ResetAlarms; END_IF
	
	Configuration;
	
	Status;
	
	Alarms;	
	
	IF Dryer.Status.Device.xFaulted OR Dryer.Status.Device.xTurnedOff OR NOT Dryer.Parameters.xLineInAuto THEN
		Dryer.Status.CtrlStatus:=DRYERCTRL_STOPPED;
	END_IF
	
	CASE Dryer.Status.CtrlStatus OF
		DRYERCTRL_STOPPED:
			Dryer.Outputs := OutputsReset;
			
			IF Dryer.Status.DeviceStatus=DRYER_INIT AND (Dryer.Commands.xStartTransport OR Dryer.Commands.xPrepare) THEN
				IF Dryer.Commands.xPrepare THEN
					xStartTransportAndPrepare := TRUE;
				END_IF
				Dryer.Status.CtrlStatus:=DRYERCTRL_PREPARINGTOMOVE;
			END_IF
			
			IF  Dryer.Status.DeviceStatus=DRYER_INIT AND Dryer.Commands.xBelEmpty THEN
				Dryer.Status.CtrlStatus := DRYERCTRL_PREPARINGEMPTYBELT;
			END_IF
			
		DRYERCTRL_PREPARINGEMPTYBELT:
			Dryer.Outputs.xPrepareToEmptyBelt := TRUE;
			IF Dryer.Inputs.xReadyToEmptyBelt THEN
				Dryer.Status.CtrlStatus := DRYERCTRL_PREPARINGTOMOVE;
			END_IF
			
			
		DRYERCTRL_STOPPING:
			//Actions
			Dryer.Outputs := OutputsReset;
			
			//Transition
			IF Dryer.Status.DeviceStatus=DRYER_TURNED_OFF OR Dryer.Status.DeviceStatus=DRYER_INIT THEN
				Dryer.Status.CtrlStatus:=DRYERCTRL_STOPPED;
			END_IF
		
		DRYERCTRL_CONTROLSTOPPING:
			//Wait to have the belt empty and send the Stop order
			IF Dryer.Status.xBeltEmpty OR NOT Dryer.Inputs.xTransportMoving THEN
				Dryer.Status.CtrlStatus:=DRYERCTRL_STOPPING;
			END_IF
			
		DRYERCTRL_PREPARINGTOMOVE:
			Dryer.Outputs.xPrepareToEmptyBelt := FALSE;
			Dryer.Outputs.xRunTransport:=TRUE;
			IF Dryer.Status.DeviceStatus=DRYER_BELTRUNNING THEN
				Dryer.Status.CtrlStatus:=DRYERCTRL_MOVING;
			END_IF
		
		DRYERCTRL_MOVING:
			IF Dryer.Commands.xPrepare OR xStartTransportAndPrepare THEN
				xStartTransportAndPrepare := FALSE;
				Dryer.Status.CtrlStatus:=DRYERCTRL_PREPARING;
			END_IF
			
		DRYERCTRL_PREPARING:
			Dryer.Outputs.xPrepareToDry:=TRUE;
			IF Dryer.Status.DeviceStatus=DRYER_READY THEN
				Dryer.Status.CtrlStatus:=DRYERCTRL_PREPARED;
			END_IF
			
		DRYERCTRL_PAUSED,
		DRYERCTRL_PREPARED:
			IF Dryer.Commands.xStart THEN
				Dryer.Status.CtrlStatus:=DRYERCTRL_STARTING;
			END_IF
			
		DRYERCTRL_STARTING:
			//Actions
			Dryer.Outputs.xStartDrying:=TRUE;
			//Transition
			IF Dryer.Status.DeviceStatus=DRYER_DRYING THEN
				Dryer.Status.CtrlStatus:=DRYERCTRL_DRYING;
			END_IF
			//Transition
			IF Dryer.Commands.xPause THEN
				Dryer.Status.CtrlStatus:=DRYERCTRL_PAUSING;
			END_IF
			
		DRYERCTRL_DRYING:
			IF Dryer.Commands.xPause THEN
				Dryer.Status.CtrlStatus:=DRYERCTRL_PAUSING;
			END_IF
			
		DRYERCTRL_PAUSING:
			//Wait to empty the Belt to avoid media inside
			IF Dryer.Status.xBeltEmpty THEN
				Dryer.Outputs.xStartDrying:=FALSE;
				//Transition
				IF Dryer.Status.DeviceStatus=DRYER_READY THEN
					Dryer.Status.CtrlStatus:=DRYERCTRL_PAUSED;
				END_IF
			END_IF
	
			IF Dryer.Commands.xStart THEN
				Dryer.Status.CtrlStatus:=DRYERCTRL_STARTING;
			END_IF
		
	END_CASE
	
	IF Dryer.Commands.xStop THEN
		Dryer.Status.CtrlStatus:=DRYERCTRL_STOPPING;
	ELSIF Dryer.Commands.xControlStop THEN
		Dryer.Status.CtrlStatus:=DRYERCTRL_CONTROLSTOPPING;	
	END_IF

	//Store the history of the status to easy the debug
	IF Dryer.Status.CtrlStatus<>StateHistory[0] THEN
		FOR iIndexHistory:=iHistoryLines TO 1 BY -1 DO 
			StateHistory[iIndexHistory]:=StateHistory[iIndexHistory-1];
		END_FOR;
		StateHistory[0]:=Dryer.Status.CtrlStatus;
	END_IF
	
	//Reset all commands
	Dryer.Commands:=CommandsReseted;
	
END_PROGRAM