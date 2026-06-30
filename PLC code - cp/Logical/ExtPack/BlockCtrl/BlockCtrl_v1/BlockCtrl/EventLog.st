
ACTION LogCriticalAlarm:

//	iReasonCritical.0 := (Block.Al.xAlrSafetySystemInBlock AND Block.Status.xEnabledMovements);
//	iReasonCritical.1 := Block.Al.xAlrDif;
//	iReasonCritical.2 := Block.Al.xAlrDriveProtection;

	stEventLogCritical.Source := ELOG_TYPE_BLOCK;
	stEventLogCritical.Severity:= ELOG_SEVERITY_ERROR;
	stEventLogCritical.Facility:= gIndexBlock;
	stEventLogCritical.ErrorCode:=0;
	
	stEventLogCritical.Text := 'Block.LogCriticalAlarm';
	
	IF 		iReasonCritical.0 THEN stEventLogCritical.Text := 'Block. xAlrSafetySystemInBlock';
	ELSIF 	iReasonCritical.1 THEN stEventLogCritical.Text := 'Block. xAlrDif';
	ELSIF 	iReasonCritical.2 THEN stEventLogCritical.Text := 'Block. xAlrDriveProtection';
	END_IF
		
	gEventLogLoader(EventData := ADR(stEventLogCritical));
	
END_ACTION

ACTION LogStopAlarm:


	stEventLogStop.Source := ELOG_TYPE_BLOCK;
	stEventLogStop.Severity:= ELOG_SEVERITY_ERROR;
	stEventLogStop.Facility:= gIndexBlock;
	stEventLogStop.ErrorCode:=0;
	
	stEventLogStop.Text := 'Block.LogStopAlarm';
	
	IF 		iReasonStop.0 THEN stEventLogStop.Text := 'Block. xAlrCleanMtrNoRef';
	ELSIF 	iReasonStop.1 THEN stEventLogStop.Text := 'Block. xAlAirVenturi';
	ELSIF 	iReasonStop.2 THEN stEventLogStop.Text := 'Block. xAnyDriveAlarm';
	ELSIF 	iReasonStop.3 THEN stEventLogStop.Text := 'Block. xAlrBarMtrNoRef';
	ELSIF 	iReasonStop.4 THEN stEventLogStop.Text := 'Block. xSiUnitPowerOff';
	ELSIF 	iReasonStop.5 THEN stEventLogStop.Text := 'Block. xAlrComSiUnit';
	ELSIF 	iReasonStop.6 THEN stEventLogStop.Text := 'Block. xAlrComBarMtr';
	ELSIF 	iReasonStop.7 THEN stEventLogStop.Text := 'Block. xAlrCleanMotor';
	ELSIF 	iReasonStop.8 THEN stEventLogStop.Text := 'Block. xAlrComCleanMtr';
	ELSIF 	iReasonStop.9 THEN stEventLogStop.Text := 'Block. xAlrEnabCleanMtrDiffLvL';
	ELSIF 	iReasonStop.10 THEN stEventLogStop.Text := 'Block. xAlrIncoherPositCleanMtr';
	ELSIF 	iReasonStop.11 THEN stEventLogStop.Text := 'Block. xAlCleanInterrupt';
	ELSIF 	iReasonStop.12 THEN stEventLogStop.Text := 'Block. xAlrTrayCleanSensor';
	ELSIF 	iReasonStop.13 THEN stEventLogStop.Text := 'Block. xNoActionDangerCollision';
	ELSIF 	iReasonStop.14 THEN stEventLogStop.Text := 'Block. xAlrControllerNotReady';
	ELSIF 	iReasonStop.15 THEN stEventLogStop.Text := 'Block. xAlrOverTorque';
	END_IF
	
	//Adding nState data to log
	strAuxEventDesc := '. nSt= ';
	brsstrcat(ADR(stEventLogStop.Text), ADR(strAuxEventDesc));
	brsitoa(nState, ADR(strAuxEventDesc));
	brsstrcat(ADR(stEventLogStop.Text), ADR(strAuxEventDesc));
	strAuxEventDesc := '. nDg= ';
	brsstrcat(ADR(stEventLogStop.Text), ADR(strAuxEventDesc));
	brsitoa(nStateDanger, ADR(strAuxEventDesc));
	brsstrcat(ADR(stEventLogStop.Text), ADR(strAuxEventDesc));
	
	gEventLogLoader(EventData := ADR(stEventLogStop));
	
END_ACTION

ACTION LogToCapOrder:

	stEventLogToCap.Source := ELOG_TYPE_BLOCK;
	stEventLogToCap.Severity:= ELOG_SEVERITY_INFO;
	stEventLogToCap.Facility:= gIndexBlock;
	stEventLogToCap.ErrorCode:=0;
	
	stEventLogToCap.Text := 'Order to Cap BK: ';
	brsitoa(gIndexBlock, ADR(strAuxEventDesc));
	brsstrcat(ADR(stEventLogToCap.Text), ADR(strAuxEventDesc));

	gEventLogLoader(EventData := ADR(stEventLogToCap));
	
END_ACTION

ACTION LogToPrintOrder:

	stEventLogToPrint.Source := ELOG_TYPE_BLOCK;
	stEventLogToPrint.Severity:= ELOG_SEVERITY_INFO;
	stEventLogToPrint.Facility:= gIndexBlock;
	stEventLogToPrint.ErrorCode:=0;
	
	stEventLogToPrint.Text := 'Order to Print BK: ';
	brsitoa(gIndexBlock, ADR(strAuxEventDesc));
	brsstrcat(ADR(stEventLogToPrint.Text), ADR(strAuxEventDesc));

	gEventLogLoader(EventData := ADR(stEventLogToPrint));
	
END_ACTION

ACTION LogToCleanOrder:

	stEventLogToClean.Source := ELOG_TYPE_BLOCK;
	stEventLogToClean.Severity:= ELOG_SEVERITY_INFO;
	stEventLogToClean.Facility:= gIndexBlock;
	stEventLogToClean.ErrorCode:=0;
	
	stEventLogToClean.Text := 'Order to Clean BK: ';
	brsitoa(gIndexBlock, ADR(strAuxEventDesc));
	brsstrcat(ADR(stEventLogToClean.Text), ADR(strAuxEventDesc));

	gEventLogLoader(EventData := ADR(stEventLogToClean));
	
END_ACTION

ACTION LogVertMovementOrder:

	VerMotorEventLog.Source := ELOG_TYPE_BLOCK;
	VerMotorEventLog.Severity:= ELOG_SEVERITY_INFO;
	VerMotorEventLog.Facility:= gIndexBlock;
	VerMotorEventLog.ErrorCode:=0;
	
	VerMotorEventLog.Text := 'BK:';
	brsitoa(gIndexBlock, ADR(strAuxEventDesc));
	brsstrcat(ADR(VerMotorEventLog.Text), ADR(strAuxEventDesc));
	
	brsstrcat(ADR(VerMotorEventLog.Text), ADR(' from '));
	brsftoa(MotorDriveUnit.PositionDevice, ADR(strAuxEventDesc));
	brsstrcat(ADR(VerMotorEventLog.Text), ADR(strAuxEventDesc));
	
	brsstrcat(ADR(VerMotorEventLog.Text), ADR('mm to '));
	brsftoa(MotorDriveUnit.PositionDesired, ADR(strAuxEventDesc));
	brsstrcat(ADR(VerMotorEventLog.Text), ADR(strAuxEventDesc));
	
	brsstrcat(ADR(VerMotorEventLog.Text), ADR('mm at '));
	brsftoa(MotorDriveUnit.SpeedDesired, ADR(strAuxEventDesc));
	brsstrcat(ADR(VerMotorEventLog.Text), ADR(strAuxEventDesc));
		
	brsstrcat(ADR(VerMotorEventLog.Text), ADR('mm/s. St: '));
	brsitoa(nState, ADR(strAuxEventDesc));
	brsstrcat(ADR(VerMotorEventLog.Text), ADR(strAuxEventDesc));
	
	gEventLogLoader(EventData := ADR(VerMotorEventLog));
	
END_ACTION

ACTION LogVertInPosition:

	VerMotorEventLog.Source := ELOG_TYPE_BLOCK;
	VerMotorEventLog.Severity:= ELOG_SEVERITY_INFO;
	VerMotorEventLog.Facility:= gIndexBlock;
	VerMotorEventLog.ErrorCode:=0;
	
	VerMotorEventLog.Text := 'In Position BK ';
	brsitoa(gIndexBlock, ADR(strAuxEventDesc));
	brsstrcat(ADR(VerMotorEventLog.Text), ADR(strAuxEventDesc));
	brsstrcat(ADR(VerMotorEventLog.Text), ADR(': '));
	brsftoa(MotorDriveUnit.PositionDevice, ADR(strAuxEventDesc));
	brsstrcat(ADR(VerMotorEventLog.Text), ADR(strAuxEventDesc));
	brsstrcat(ADR(VerMotorEventLog.Text), ADR('mm. St: '));
	brsitoa(nState, ADR(strAuxEventDesc));
	brsstrcat(ADR(VerMotorEventLog.Text), ADR(strAuxEventDesc));
		
	gEventLogLoader(EventData := ADR(VerMotorEventLog));
	
END_ACTION

ACTION LogIclaMovementOrder:

	stIclaOrderEventLog.Source := ELOG_TYPE_BLOCK;
	stIclaOrderEventLog.Severity:= ELOG_SEVERITY_INFO;
	stIclaOrderEventLog.Facility:= gIndexBlock;
	stIclaOrderEventLog.ErrorCode:=0;
	
	stIclaOrderEventLog.Text := 'Icla Order BK: ';
	brsitoa(gIndexBlock, ADR(strAuxEventDesc));
	brsstrcat(ADR(stIclaOrderEventLog.Text), ADR(strAuxEventDesc));
	brsstrcat(ADR(stIclaOrderEventLog.Text), ADR(': '));
	brsftoa(IclaDriveUnit.PositionDesired, ADR(strAuxEventDesc));
	brsstrcat(ADR(stIclaOrderEventLog.Text), ADR(strAuxEventDesc));
	brsstrcat(ADR(stIclaOrderEventLog.Text), ADR('mm. St: '));
	brsitoa(nState, ADR(strAuxEventDesc));
	brsstrcat(ADR(stIclaOrderEventLog.Text), ADR(strAuxEventDesc));

	gEventLogLoader(EventData := ADR(stIclaOrderEventLog));
	
END_ACTION

ACTION LogIclaInPosition:

	stIclaEventLog.Source := ELOG_TYPE_BLOCK;
	stIclaEventLog.Severity:= ELOG_SEVERITY_INFO;
	stIclaEventLog.Facility:= gIndexBlock;
	stIclaEventLog.ErrorCode:=0;
	
	stIclaEventLog.Text := 'Icla In Position BK: ';
	brsitoa(gIndexBlock, ADR(strAuxEventDesc));
	brsstrcat(ADR(stIclaEventLog.Text), ADR(strAuxEventDesc));
	brsstrcat(ADR(stIclaEventLog.Text), ADR(': '));
	brsftoa(IclaDriveUnit.PositionDevice, ADR(strAuxEventDesc));
	brsstrcat(ADR(stIclaEventLog.Text), ADR(strAuxEventDesc));
	brsstrcat(ADR(stIclaEventLog.Text), ADR('mm. St: '));
	brsitoa(nState, ADR(strAuxEventDesc));
	brsstrcat(ADR(stIclaEventLog.Text), ADR(strAuxEventDesc));
		
	gEventLogLoader(EventData := ADR(stIclaEventLog));
	
END_ACTION

ACTION LogHomingOrderBar:

	VerMotorEventLog.Source := ELOG_TYPE_BLOCK;
	VerMotorEventLog.Severity:= ELOG_SEVERITY_INFO;
	VerMotorEventLog.Facility:= gIndexBlock;
	VerMotorEventLog.ErrorCode:=0;
	
	VerMotorEventLog.Text := 'Homing order Vert BK: ';
	brsitoa(gIndexBlock, ADR(strAuxEventDesc));
	brsstrcat(ADR(VerMotorEventLog.Text), ADR(strAuxEventDesc));
		
	gEventLogLoader(EventData := ADR(VerMotorEventLog));
	
END_ACTION

ACTION LogHomedBar:

	VerMotorEventLog.Source := ELOG_TYPE_BLOCK;
	VerMotorEventLog.Severity:= ELOG_SEVERITY_INFO;
	VerMotorEventLog.Facility:= gIndexBlock;
	VerMotorEventLog.ErrorCode:=0;
	
	VerMotorEventLog.Text := 'Vert Motor Homed BK: ';
	brsitoa(gIndexBlock, ADR(strAuxEventDesc));
	brsstrcat(ADR(VerMotorEventLog.Text), ADR(strAuxEventDesc));
		
	gEventLogLoader(EventData := ADR(VerMotorEventLog));
	
END_ACTION

ACTION LogHomingOrderIcla:

	stIclaEventLog.Source := ELOG_TYPE_BLOCK;
	stIclaEventLog.Severity:= ELOG_SEVERITY_INFO;
	stIclaEventLog.Facility:= gIndexBlock;
	stIclaEventLog.ErrorCode:=0;
	
	stIclaEventLog.Text := 'Homing order Icla BK: ';
	brsitoa(gIndexBlock, ADR(strAuxEventDesc));
	brsstrcat(ADR(stIclaEventLog.Text), ADR(strAuxEventDesc));
		
	gEventLogLoader(EventData := ADR(stIclaEventLog));
	
END_ACTION

ACTION LogHomedIcla:

	stIclaEventLog.Source := ELOG_TYPE_BLOCK;
	stIclaEventLog.Severity:= ELOG_SEVERITY_INFO;
	stIclaEventLog.Facility:= gIndexBlock;
	stIclaEventLog.ErrorCode:=0;
	
	stIclaEventLog.Text := 'Icla Homed BK: ';
	brsitoa(gIndexBlock, ADR(strAuxEventDesc));
	brsstrcat(ADR(stIclaEventLog.Text), ADR(strAuxEventDesc));
		
	gEventLogLoader(EventData := ADR(stIclaEventLog));
	
END_ACTION

ACTION LogMotorOrderIncoherencyHaltAndMoveAbsolute:

	stEventLogIncoherence.Source := ELOG_TYPE_BLOCK;
	stEventLogIncoherence.Severity:= ELOG_SEVERITY_INFO;
	stEventLogIncoherence.Facility:= gIndexBlock;
	stEventLogIncoherence.ErrorCode:=0;
	
	stEventLogIncoherence.Text := 'Incoherency orders. Halt and MoveAbsolute BK: ';
	brsitoa(gIndexBlock, ADR(strAuxEventDesc));
	brsstrcat(ADR(stEventLogIncoherence.Text), ADR(strAuxEventDesc));
		
	gEventLogLoader(EventData := ADR(stEventLogIncoherence));
	
END_ACTION

ACTION LogErrorxHeaterDcOkBusBar1:

	stEventLogxHeaterDcOkBusBar1.Source := ELOG_TYPE_BLOCK;
	stEventLogxHeaterDcOkBusBar1.Severity:= ELOG_SEVERITY_INFO;
	stEventLogxHeaterDcOkBusBar1.Facility:= gIndexBlock;
	stEventLogxHeaterDcOkBusBar1.ErrorCode:=0;
	
	stEventLogxHeaterDcOkBusBar1.Text := 'Error in xHeaterDcOkBusBar1 BK: ';
	brsitoa(gIndexBlock, ADR(strAuxEventDesc));
	brsstrcat(ADR(stIclaEventLog.Text), ADR(strAuxEventDesc));
		
	gEventLogLoader(EventData := ADR(stIclaEventLog));
	
END_ACTION

ACTION LogErrorxHeaterDcOkBusBar2:

	stEventLogxHeaterDcOkBusBar2.Source := ELOG_TYPE_BLOCK;
	stEventLogxHeaterDcOkBusBar2.Severity:= ELOG_SEVERITY_INFO;
	stEventLogxHeaterDcOkBusBar2.Facility:= gIndexBlock;
	stEventLogxHeaterDcOkBusBar2.ErrorCode:=0;
	
	stEventLogxHeaterDcOkBusBar2.Text := 'Error in xHeaterDcOkBusBar2 BK: ';
	brsitoa(gIndexBlock, ADR(strAuxEventDesc));
	brsstrcat(ADR(stIclaEventLog.Text), ADR(strAuxEventDesc));
		
	gEventLogLoader(EventData := ADR(stIclaEventLog));
	
END_ACTION

ACTION LogErrorxHeaterDcOkPsu1:

	stEventLogxHeaterDcOkPsu1.Source := ELOG_TYPE_BLOCK;
	stEventLogxHeaterDcOkPsu1.Severity:= ELOG_SEVERITY_INFO;
	stEventLogxHeaterDcOkPsu1.Facility:= gIndexBlock;
	stEventLogxHeaterDcOkPsu1.ErrorCode:=0;
	
	stEventLogxHeaterDcOkPsu1.Text := 'Error in xHeaterDcOkPsu1 BK: ';
	brsitoa(gIndexBlock, ADR(strAuxEventDesc));
	brsstrcat(ADR(stIclaEventLog.Text), ADR(strAuxEventDesc));
		
	gEventLogLoader(EventData := ADR(stIclaEventLog));
	
END_ACTION

ACTION LogErrorxHeaterDcOkPsu2:

	stEventLogxHeaterDcOkPsu2.Source := ELOG_TYPE_BLOCK;
	stEventLogxHeaterDcOkPsu2.Severity:= ELOG_SEVERITY_INFO;
	stEventLogxHeaterDcOkPsu2.Facility:= gIndexBlock;
	stEventLogxHeaterDcOkPsu2.ErrorCode:=0;
	
	stEventLogxHeaterDcOkPsu2.Text := 'Error in xHeaterDcOkPsu2 BK: ';
	brsitoa(gIndexBlock, ADR(strAuxEventDesc));
	brsstrcat(ADR(stIclaEventLog.Text), ADR(strAuxEventDesc));
		
	gEventLogLoader(EventData := ADR(stIclaEventLog));
	
END_ACTION

ACTION LogErrorxHeaterDcOkPsu3:

	stEventLogxHeaterDcOkPsu3.Source := ELOG_TYPE_BLOCK;
	stEventLogxHeaterDcOkPsu3.Severity:= ELOG_SEVERITY_INFO;
	stEventLogxHeaterDcOkPsu3.Facility:= gIndexBlock;
	stEventLogxHeaterDcOkPsu3.ErrorCode:=0;
	
	stEventLogxHeaterDcOkPsu3.Text := 'Error in xHeaterDcOkPsu3 BK: ';
	brsitoa(gIndexBlock, ADR(strAuxEventDesc));
	brsstrcat(ADR(stIclaEventLog.Text), ADR(strAuxEventDesc));
		
	gEventLogLoader(EventData := ADR(stIclaEventLog));
	
END_ACTION

ACTION LogErrorxHeaterAcOkPsu1:

	stEventLogxHeaterAcOkPsu1.Source := ELOG_TYPE_BLOCK;
	stEventLogxHeaterAcOkPsu1.Severity:= ELOG_SEVERITY_INFO;
	stEventLogxHeaterAcOkPsu1.Facility:= gIndexBlock;
	stEventLogxHeaterAcOkPsu1.ErrorCode:=0;
	
	stEventLogxHeaterAcOkPsu1.Text := 'Error in xHeaterAcOkPsu1 BK: ';
	brsitoa(gIndexBlock, ADR(strAuxEventDesc));
	brsstrcat(ADR(stIclaEventLog.Text), ADR(strAuxEventDesc));
		
	gEventLogLoader(EventData := ADR(stIclaEventLog));
	
END_ACTION

ACTION LogErrorxHeaterAcOkPsu2:

	stEventLogxHeaterAcOkPsu2.Source := ELOG_TYPE_BLOCK;
	stEventLogxHeaterAcOkPsu2.Severity:= ELOG_SEVERITY_INFO;
	stEventLogxHeaterAcOkPsu2.Facility:= gIndexBlock;
	stEventLogxHeaterAcOkPsu2.ErrorCode:=0;
	
	stEventLogxHeaterAcOkPsu2.Text := 'Error in xHeaterAcOkPsu2 BK: ';
	brsitoa(gIndexBlock, ADR(strAuxEventDesc));
	brsstrcat(ADR(stIclaEventLog.Text), ADR(strAuxEventDesc));
		
	gEventLogLoader(EventData := ADR(stIclaEventLog));
	
END_ACTION

ACTION LogErrorxHeaterAcOkPsu3:

	stEventLogxHeaterAcOkPsu3.Source := ELOG_TYPE_BLOCK;
	stEventLogxHeaterAcOkPsu3.Severity:= ELOG_SEVERITY_INFO;
	stEventLogxHeaterAcOkPsu3.Facility:= gIndexBlock;
	stEventLogxHeaterAcOkPsu3.ErrorCode:=0;
	
	stEventLogxHeaterAcOkPsu3.Text := 'Error in xHeaterAcOkPsu3 BK: ';
	brsitoa(gIndexBlock, ADR(strAuxEventDesc));
	brsstrcat(ADR(stIclaEventLog.Text), ADR(strAuxEventDesc));
		
	gEventLogLoader(EventData := ADR(stIclaEventLog));
	
END_ACTION