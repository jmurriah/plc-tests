
PROGRAM _CYCLIC
	
	OverVarnish ACCESS ADR(gOverVarnish);
	
	//Version
	OverVarnish.Status.Version.iVersion0 := OverVarnish.Inputs.Comms.iVersion1;
	OverVarnish.Status.Version.iVersion1 := OverVarnish.Inputs.Comms.iVersion2;
	OverVarnish.Status.Version.iVersion2 := OverVarnish.Inputs.Comms.iVersion3;
	OverVarnish.Status.Version.iVersion3 := OverVarnish.Inputs.Comms.iVersion4;
	
	//Model evaluation
	iOpvModel.0 := OverVarnish.Inputs.xModelInput[0];
	iOpvModel.1 := OverVarnish.Inputs.xModelInput[1];
	iOpvModel.2 := OverVarnish.Inputs.xModelInput[2];
	
	OverVarnish.Parameters.xInstalled := iOpvModel>0;
	
	//Specify Type of Opv Model
	OverVarnish.Status.iModel := iOpvModel;
	CASE iOpvModel OF
		1: OverVarnish.Status.OpvType := OPVTY_GIARDINA;
		2: OverVarnish.Status.OpvType := OPVTY_DMS;
		3: OverVarnish.Status.OpvType := OPVTY_TECLIGHTING;
		ELSE OverVarnish.Status.OpvType := OPVTY_UNDEFINED;
	END_CASE
	
	IF NOT OverVarnish.Parameters.xInstalled OR NOT OverVarnish.ParSw.xEnabled THEN
		ResetAlarms;
		OverVarnish.Outputs := OutputsReset;
		OverVarnish.Commands:=ResetCommands;
		OverVarnish.Status.DeviceStatus:=OPV_TURNED_OFF;
		CopyOfWriteData := EraseWriteData;
		UpdateStatus;
		RETURN;
	END_IF
	
	IF OverVarnish.Commands.xResetAlarms THEN ResetAlarms; END_IF
	
	Configuration;
	
	IF NOT OverVarnish.Parameters.xSimulationMode THEN 
		AssignDataComms; 
	END_IF
	
	Status;
	
	//Erasing data when ancillary not in remote
	IF NOT OverVarnish.Inputs.Comms.xRemote THEN
		CopyOfWriteData := EraseWriteData;
	END_IF
	
	Alarms;	
	
	IF OverVarnish.Status.Device.xFaulted OR OverVarnish.Status.Device.xTurnedOff OR NOT OverVarnish.Parameters.xLineInAuto THEN
		OverVarnish.Status.CtrlStatus:=OPVCTRL_STOPPED;
	END_IF
	
	CASE OverVarnish.Status.CtrlStatus OF
		OPVCTRL_STOPPED:
			//Actions
			OverVarnish.Outputs.Physical := PhysicalOutputsReset;
			
			//Transition
			IF OverVarnish.Commands.xPrepare THEN
				xEnablePriming:= OverVarnish.ParSw.xEnablePriming AND OverVarnish.Orders.xEnablePriming;
				OverVarnish.Status.CtrlStatus:=OPVCTRL_PREPARING;
			END_IF
		
		OPVCTRL_STOPPING:
			//Actions
			OverVarnish.Outputs.Physical := PhysicalOutputsReset;
			
			//Transition
			IF OverVarnish.Status.DeviceStatus=OPV_TURNED_OFF OR OverVarnish.Status.DeviceStatus=OPV_INIT THEN
				OverVarnish.Status.CtrlStatus:=OPVCTRL_STOPPED;
			END_IF
			
		OPVCTRL_CONTROLSTOPPING:
			//Wait to have the belt empty and send the Stop order
			IF OverVarnish.Status.xBeltEmpty AND EDGEPOS(OverVarnish.Orders.xDisableReadBlock) OR NOT OverVarnish.Inputs.xTransportMoving THEN
				OverVarnish.Status.CtrlStatus:=OPVCTRL_STOPPING;
			END_IF
			
		OPVCTRL_PREPARING:
			//Actions
			
			IF xEnablePriming THEN
				OverVarnish.Outputs.Physical.xRunTransport:=TRUE;
				OverVarnish.Outputs.Physical.xPrepareToPrime:=TRUE;
				//Transition
				IF OverVarnish.Status.DeviceStatus=OPV_READY THEN
					OverVarnish.Status.CtrlStatus:=OPVCTRL_PREPARED;
				END_IF

			ELSE
				OverVarnish.Outputs.Physical.xRunTransport:=TRUE;
				//Transition
				IF OverVarnish.Status.DeviceStatus=OPV_BELT_RUNNING THEN
					OverVarnish.Status.CtrlStatus:=OPVCTRL_PREPARED;
				END_IF

			END_IF
			
		OPVCTRL_PAUSED,
		OPVCTRL_PREPARED:
			//Actions
			IF OverVarnish.Commands.xStart THEN
				OverVarnish.Status.CtrlStatus:=OPVCTRL_STARTING;
			END_IF
			
			
		OPVCTRL_STARTING:
			//Actions
			IF xEnablePriming THEN
				OverVarnish.Outputs.Physical.xRunPriming:=TRUE;
				IF OverVarnish.Status.DeviceStatus=OPV_PRIMING THEN
					OverVarnish.Outputs.Physical.xRunDryer:=TRUE;
				END_IF
				//Transition
				IF OverVarnish.Status.DeviceStatus=OPV_DRYING THEN
					OverVarnish.Status.CtrlStatus:=OPVCTRL_WORKING;
				END_IF

			ELSE
				OverVarnish.Outputs.Physical.xRunTransport:=TRUE;
				IF OverVarnish.Status.DeviceStatus=OPV_BELT_RUNNING THEN
					OverVarnish.Status.CtrlStatus:=OPVCTRL_WORKING;
				END_IF

			END_IF			
			
			//Transition
			IF OverVarnish.Commands.xPause THEN
				OverVarnish.Status.CtrlStatus:=OPVCTRL_PAUSING;
			END_IF
			
		OPVCTRL_WORKING:
			IF OverVarnish.Commands.xPause THEN
				OverVarnish.Status.CtrlStatus:=OPVCTRL_PAUSING;
			END_IF
			
		OPVCTRL_PAUSING:
			//Wait to empty the Belt to avoid media inside
			IF OverVarnish.Status.xBeltEmpty THEN
				IF xEnablePriming THEN
					OverVarnish.Outputs.Physical.xRunDryer:=FALSE;
					//Transition
					IF OverVarnish.Status.DeviceStatus=OPV_PRIMING THEN
						OverVarnish.Status.CtrlStatus:=OPVCTRL_PAUSED;
					END_IF
	
				ELSE
					IF OverVarnish.Status.DeviceStatus=OPV_INIT OR OverVarnish.Status.DeviceStatus=OPV_BELT_RUNNING THEN
						OverVarnish.Status.CtrlStatus:=OPVCTRL_PAUSED;
					END_IF
				END_IF				
			END_IF

	END_CASE

	IF OverVarnish.Commands.xStop THEN
		OverVarnish.Status.CtrlStatus:=OPVCTRL_STOPPING;
	ELSIF OverVarnish.Commands.xControlStop THEN
		OverVarnish.Status.CtrlStatus:=OPVCTRL_CONTROLSTOPPING;	
	END_IF
			
	//Store the history of the status to easy the debug
	IF OverVarnish.Status.CtrlStatus<>StateHistory[0] THEN
		FOR iIndexHistory:=iHistoryLines TO 1 BY -1 DO 
			StateHistory[iIndexHistory]:=StateHistory[iIndexHistory-1];
		END_FOR;
		StateHistory[0]:=OverVarnish.Status.CtrlStatus;
	END_IF
	
	//Fall down the commands
	OverVarnish.Commands:=ResetCommands;
	
END_PROGRAM