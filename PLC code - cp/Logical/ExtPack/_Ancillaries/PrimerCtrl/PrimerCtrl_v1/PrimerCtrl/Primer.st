
PROGRAM _CYCLIC
	
	Primer ACCESS ADR(gPrimer);
	
	//Version
	Primer.Status.Version.iVersion0 := Primer.Inputs.Comms.iVersion1;
	Primer.Status.Version.iVersion1 := Primer.Inputs.Comms.iVersion2;
	Primer.Status.Version.iVersion2 := Primer.Inputs.Comms.iVersion3;
	Primer.Status.Version.iVersion3 := Primer.Inputs.Comms.iVersion4;
	
	//Model evaluation
	iPrimerModel.0 := Primer.Inputs.xModelInput[0];
	iPrimerModel.1 := Primer.Inputs.xModelInput[1];
	iPrimerModel.2 := Primer.Inputs.xModelInput[2];
	
	Primer.Parameters.xInstalled := iPrimerModel>0;
	
	//Specify Type of primer Model
	Primer.Status.iModel := iPrimerModel;
	CASE iPrimerModel OF
		1: Primer.Status.PrimerType := PRIMERTY_GIARDINA;
		2: Primer.Status.PrimerType := PRIMERTY_DMS;
		3: Primer.Status.PrimerType := PRIMERTY_TECLIGHTNING;
		ELSE Primer.Status.PrimerType := PRIMERTY_UNDEFINED;
	END_CASE

	
	IF NOT Primer.Parameters.xInstalled OR NOT Primer.ParSw.xEnabled THEN
		ResetAlarms;
		Primer.Outputs.Physical := PhysicalOutputsReset;
		Primer.Commands:=ResetCommands;
		Primer.Status.DeviceStatus:=PRIMER_TURNED_OFF;
		CopyOfWriteData := EraseWriteData;
		Primer.Status.xBeltEmpty := TRUE;
		UpdateStatus;
		RETURN;
	END_IF
	

	IF Primer.Commands.xResetAlarms THEN ResetAlarms; END_IF
	
	Configuration;
	
	Status;
	
	IF NOT Primer.Parameters.xSimulationMode THEN 
		AssignDataComms; 
	END_IF
	
	//Erasing data when ancillary not in remote
	IF NOT Primer.Inputs.Comms.xRemote THEN
		CopyOfWriteData := EraseWriteData;
	END_IF
	
	Alarms;	
	
	IF Primer.Status.Device.xFaulted OR Primer.Status.Device.xTurnedOff OR NOT Primer.Parameters.xLineInAuto THEN
		Primer.Status.CtrlStatus:=PRIMERCTRL_STOPPED;
	END_IF
	
	CASE Primer.Status.CtrlStatus OF
		PRIMERCTRL_STOPPED:
			//Actions
			Primer.Outputs.Physical := PhysicalOutputsReset;
			
			//Transition
			IF Primer.Commands.xPrepare THEN
				xEnablePriming:= Primer.ParSw.xEnablePriming AND Primer.Orders.xEnablePriming;
				Primer.Status.CtrlStatus:=PRIMERCTRL_PREPARING;
			END_IF
		
		PRIMERCTRL_STOPPING:
			//Actions
			Primer.Outputs.Physical := PhysicalOutputsReset;
			
			//Transition
			IF Primer.Status.DeviceStatus=PRIMER_TURNED_OFF OR Primer.Status.DeviceStatus=PRIMER_INIT THEN
				Primer.Status.CtrlStatus:=PRIMERCTRL_STOPPED;
			END_IF
			
		PRIMERCTRL_CONTROLSTOPPING:
			//Wait to have the belt empty and send the Stop order
			IF (Primer.Status.xBeltEmpty AND EDGEPOS(Primer.Orders.xDisableReadBlock)) OR NOT Primer.Inputs.xTransportMoving THEN
				Primer.Status.CtrlStatus:=PRIMERCTRL_STOPPING;
			END_IF
			
		PRIMERCTRL_PREPARING:
			//Actions
			
			IF xEnablePriming THEN
				Primer.Outputs.Physical.xRunTransport:=TRUE;
				Primer.Outputs.Physical.xPrepareToPrime:=TRUE;
				//Transition
				IF Primer.Status.DeviceStatus=PRIMER_READY THEN
					Primer.Status.CtrlStatus:=PRIMERCTRL_PREPARED;
				END_IF

			ELSE
				Primer.Outputs.Physical.xRunTransport:=TRUE;
				//Transition
				IF Primer.Status.DeviceStatus=PRIMER_BELT_RUNNING THEN
					Primer.Status.CtrlStatus:=PRIMERCTRL_PREPARED;
				END_IF

			END_IF
			
		PRIMERCTRL_PAUSED,
		PRIMERCTRL_PREPARED:
			//Actions
			IF Primer.Commands.xStart THEN
				Primer.Status.CtrlStatus:=PRIMERCTRL_STARTING;
			END_IF
			
			
		PRIMERCTRL_STARTING:
			//Actions
			IF xEnablePriming THEN
				Primer.Outputs.Physical.xRunPriming:=TRUE;
				IF Primer.Status.DeviceStatus=PRIMER_PRIMING THEN
					Primer.Outputs.Physical.xRunDryer:=TRUE;
				END_IF
				//Transition
				IF Primer.Status.DeviceStatus=PRIMER_DRYING THEN
					Primer.Status.CtrlStatus:=PRIMERCTRL_WORKING;
				END_IF
			ELSE
				Primer.Outputs.Physical.xRunTransport:=TRUE;
				IF Primer.Status.DeviceStatus=PRIMER_BELT_RUNNING THEN
					Primer.Status.CtrlStatus:=PRIMERCTRL_WORKING;
				END_IF
			END_IF			
			
			//Transition
			IF Primer.Commands.xPause THEN
				Primer.Status.CtrlStatus:=PRIMERCTRL_PAUSING;
			END_IF
			
		PRIMERCTRL_WORKING:
			IF Primer.Commands.xPause THEN
				Primer.Status.CtrlStatus:=PRIMERCTRL_PAUSING;
			END_IF
			
		PRIMERCTRL_PAUSING:
			//Wait to empty the Belt to avoid media inside
			IF Primer.Status.xBeltEmpty THEN
				IF xEnablePriming THEN
					Primer.Outputs.Physical.xRunDryer:=FALSE;
					//Transition
					IF Primer.Status.DeviceStatus=PRIMER_PRIMING THEN
						Primer.Status.CtrlStatus:=PRIMERCTRL_PAUSED;
					END_IF
				ELSE
					IF Primer.Status.DeviceStatus=PRIMER_INIT OR Primer.Status.DeviceStatus=PRIMER_BELT_RUNNING THEN
						Primer.Status.CtrlStatus:=PRIMERCTRL_PAUSED;
					END_IF
				END_IF				
			END_IF

	END_CASE

	
	IF Primer.Commands.xStop THEN
		Primer.Status.CtrlStatus:=PRIMERCTRL_STOPPING;
	ELSIF Primer.Commands.xControlStop THEN
		Primer.Status.CtrlStatus:=PRIMERCTRL_CONTROLSTOPPING;	
	END_IF
			
	//Store the history of the status to easy the debug
	IF Primer.Status.CtrlStatus<>StateHistory[0] THEN
		FOR iIndexHistory:=iHistoryLines TO 1 BY -1 DO 
			StateHistory[iIndexHistory]:=StateHistory[iIndexHistory-1];
		END_FOR
		StateHistory[0]:=Primer.Status.CtrlStatus;
	END_IF
	
	//Fall down the commands
	Primer.Commands:=ResetCommands;
	
END_PROGRAM