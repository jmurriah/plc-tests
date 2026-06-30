PROGRAM _INIT

	dataArcLamp ACCESS ADR(gArcLampGew);

	dataArcLamp.Parameters.iPowerPerc:= 60;

	IF gDryer.St.HwData.Family = FAMILY_BRAUTOMATIONRUNTIME THEN
		dataArcLamp.Parameters.SerialNumber := 'S11111';
		dataArcLamp.Parameters.PIN 			:= '366390';
	END_IF

END_PROGRAM


PROGRAM _CYCLIC
	(* Insert code here *)
	dataArcLamp ACCESS ADR(gArcLampGew);
	SimArcLamp ACCESS ADR(gSimArcLamp);
	

//	ARCLG_IDLE:
//		IF data.Commands.InternalComms.xReadLamps THEN
//			commsStatus:=ARCLG_GET_LAMPS;
//		ELSIF data.Commands.InternalComms.xReadAlerts THEN
//			commsStatus:=ARCLG_GET_ALERTS;
//		ELSIF data.Commands.InternalComms.xResetAll THEN
//			commsStatus:=ARCLG_RESET_ALL;
//		ELSIF data.Commands.InternalComms.xSelectLamp THEN
//			commsStatus:=ARCLG_SELEC_LAMP;
//		ELSIF data.Commands.InternalComms.xDeSelectLamp THEN
//			commsStatus:=ARCLG_DESELEC_LAMP;
//		ELSIF data.Commands.InternalComms.xStopSelected THEN
//			commsStatus:=ARCLG_STOP_SELECTED;
//		ELSIF data.Commands.InternalComms.xStartSelected THEN
//			commsStatus:=ARCLG_START_SELECTED;
//		ELSIF data.Commands.InternalComms.xDeselectAll THEN
//			commsStatus:=ARCLG_DESELEC_ALL;
//		ELSIF data.Commands.InternalComms.xSetPower THEN
//			commsStatus:=ARCLG_SET_POWER;
//		ELSIF data.Commands.InternalComms.xReadSystem THEN
//			commsStatus:=ARCLG_GET_SYSTEM;
//		END_IF
	
	FOR iIndexLamp := 1 TO dataArcLamp.Parameters.iLampQuantity DO
	 
		dataArcLamp.Status.Lamps[iIndexLamp].Enabled := dataArcLamp.Parameters.Lamps[iIndexLamp].Enable;
		IF dataArcLamp.State = ARCLGEW_RUNNING THEN
			IF REAL_TO_USINT(dataArcLamp.Status.Lamps[iIndexLamp].LampPowerPercent) < dataArcLamp.Parameters.iPowerPerc THEN
				dataArcLamp.Status.Lamps[iIndexLamp].LampPowerPercent := MIN(dataArcLamp.Status.Lamps[iIndexLamp].LampPowerPercent + 0.5, dataArcLamp.Parameters.iPowerPerc);
			ELSE
				dataArcLamp.Status.Lamps[iIndexLamp].LampPowerPercent := MAX(dataArcLamp.Status.Lamps[iIndexLamp].LampPowerPercent - 0.5, dataArcLamp.Parameters.iPowerPerc);
			END_IF
		ELSE
			dataArcLamp.Status.Lamps[iIndexLamp].LampPowerPercent := MAX(dataArcLamp.Status.Lamps[iIndexLamp].LampPowerPercent - 0.5, 0);
		END_IF
		//dataArcLamp.Status.Lamps[iIndexLamp].xDrying := dataArcLamp.State = ARCLGEW_RUNNING AND dataArcLamp.Status.Lamps[iIndexLamp].Enabled;
	END_FOR;
	
	
	IF dataArcLamp.Commands.InternalComms.xDeselectAll THEN
		IF EDGEPOS(dataArcLamp.Commands.InternalComms.xDeselectAll AND dataArcLamp.Status.CommsStatus = ARCLG_IDLE) THEN
			dataArcLamp.Status.CommsStatus := ARCLG_DESELEC_ALL;
			dataArcLamp.Status.Lamps[1].IsSelected := FALSE;
			dataArcLamp.Status.Lamps[2].IsSelected := FALSE;
		END_IF
		EndComms;
	ELSIF dataArcLamp.Commands.InternalComms.xDeSelectLamp THEN
		IF EDGEPOS(dataArcLamp.Commands.InternalComms.xDeSelectLamp AND dataArcLamp.Status.CommsStatus = ARCLG_IDLE) THEN
			dataArcLamp.Status.CommsStatus := ARCLG_DESELEC_LAMP;
			dataArcLamp.Status.Lamps[1].IsSelected := FALSE;
			dataArcLamp.Status.Lamps[2].IsSelected := FALSE;
		END_IF
		EndComms;
	ELSIF dataArcLamp.Commands.InternalComms.xReadAlerts THEN
		IF EDGEPOS(dataArcLamp.Commands.InternalComms.xReadAlerts AND dataArcLamp.Status.CommsStatus = ARCLG_IDLE) THEN
			dataArcLamp.Status.CommsStatus := ARCLG_GET_ALERTS;
		END_IF
		EndComms;
	ELSIF dataArcLamp.Commands.InternalComms.xReadLamps THEN
		IF EDGEPOS(dataArcLamp.Commands.InternalComms.xReadLamps AND dataArcLamp.Status.CommsStatus = ARCLG_IDLE) THEN
			dataArcLamp.Status.CommsStatus := ARCLG_GET_LAMPS;
		END_IF
		EndComms;
	ELSIF dataArcLamp.Commands.InternalComms.xReadSystem THEN
		IF EDGEPOS(dataArcLamp.Commands.InternalComms.xReadSystem AND dataArcLamp.Status.CommsStatus = ARCLG_IDLE) THEN
			dataArcLamp.Status.CommsStatus := ARCLG_GET_SYSTEM;
		END_IF
		EndComms;
	ELSIF dataArcLamp.Commands.InternalComms.xResetAll THEN
		IF EDGEPOS(dataArcLamp.Commands.InternalComms.xResetAll AND dataArcLamp.Status.CommsStatus = ARCLG_IDLE) THEN
			dataArcLamp.Status.CommsStatus := ARCLG_RESET_ALL;
		END_IF
		EndComms;
	ELSIF dataArcLamp.Commands.InternalComms.xSelectLamp THEN
		IF EDGEPOS(dataArcLamp.Commands.InternalComms.xSelectLamp AND dataArcLamp.Status.CommsStatus = ARCLG_IDLE) THEN
			dataArcLamp.Status.CommsStatus := ARCLG_SELEC_LAMP;
			dataArcLamp.Status.Lamps[1].IsSelected := dataArcLamp.Parameters.Lamps[1].Enable;
			dataArcLamp.Status.Lamps[2].IsSelected := dataArcLamp.Parameters.Lamps[2].Enable;
			iSetLampTimes := iSetLampTimes +1;
		END_IF
		EndComms;
	ELSIF dataArcLamp.Commands.InternalComms.xSetPower THEN
		IF EDGEPOS(dataArcLamp.Commands.InternalComms.xSetPower AND dataArcLamp.Status.CommsStatus = ARCLG_IDLE) THEN
			dataArcLamp.Status.CommsStatus := ARCLG_SET_POWER;
		END_IF
		EndComms;
	ELSIF dataArcLamp.Commands.InternalComms.xStartSelected THEN
		IF EDGEPOS(dataArcLamp.Commands.InternalComms.xStartSelected AND dataArcLamp.Status.CommsStatus = ARCLG_IDLE) THEN
			dataArcLamp.Status.CommsStatus := ARCLG_START_SELECTED;
		END_IF
		EndComms;
	ELSIF dataArcLamp.Commands.InternalComms.xStopSelected THEN
		IF EDGEPOS(dataArcLamp.Commands.InternalComms.xStopSelected AND dataArcLamp.Status.CommsStatus = ARCLG_IDLE) THEN
			dataArcLamp.Status.CommsStatus := ARCLG_STOP_SELECTED;
		END_IF
		EndComms;
		IF tonCommand.Q THEN
			dataArcLamp.Signals.In.xReady := FALSE;
		END_IF
	END_IF
	
	xSimulatingCommand.0 := dataArcLamp.Commands.InternalComms.xDeselectAll ;
	xSimulatingCommand.1 := dataArcLamp.Commands.InternalComms.xDeSelectLamp ;
	xSimulatingCommand.2 := dataArcLamp.Commands.InternalComms.xReadAlerts ;
	xSimulatingCommand.3 := dataArcLamp.Commands.InternalComms.xReadLamps ;
	xSimulatingCommand.4 := dataArcLamp.Commands.InternalComms.xReadSystem ;
	xSimulatingCommand.5 := dataArcLamp.Commands.InternalComms.xResetAll ;
	xSimulatingCommand.6 := dataArcLamp.Commands.InternalComms.xSelectLamp ;
	xSimulatingCommand.7 := dataArcLamp.Commands.InternalComms.xSetPower ;
	xSimulatingCommand.8 := dataArcLamp.Commands.InternalComms.xStartSelected ;
	xSimulatingCommand.9 := dataArcLamp.Commands.InternalComms.xStopSelected ;
	
	tonCommand.IN := xSimulatingCommand > 0;
	tonCommand.PT := t#300ms;
	tonCommand();
	
	tonReady.IN := dataArcLamp.State = ARCLGEW_STARTING;
	tonReady.PT:= T#3s;
	tonReady();
	IF tonReady.Q THEN
		dataArcLamp.Signals.In.xReady := TRUE;
	END_IF
	

//	tonTransport.IN:= dataArcLamp.Outputs.xRunTransport;
//	tonTransport.PT:= T#1s;
//	tonTransport();
//	dataArcLamp.Inputs.xTransportMoving:=tonTransport.Q;
//	
//	tonDry.IN:= dataArcLamp.Inputs.xReadyToDry AND dataArcLamp.Outputs.xStartDrying;
//	tonDry.PT:= T#1s;
//	tonDry();
//	dataArcLamp.Inputs.xDrying:=tonDry.Q;
//	
//	dataArcLamp.Signals.In.xReady :=TRUE;
//	dataArcLamp.Signals.In.xFault :=FALSE;
	
END_PROGRAM