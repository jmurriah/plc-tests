
ACTION LogCriticalAlarm:

//	iReasonCritical.0 := (Block.Al.xAlrSafetySystemInBlock AND Block.Status.xEnabledMovements);
//	iReasonCritical.1 := Block.Al.xAlrDriveProtection;

	stEventLog.Source := ELOG_TYPE_SIMPLEBLOCK;
	stEventLog.Severity:= ELOG_SEVERITY_ERROR;
	stEventLog.Facility:= gIndexSimpleBlock;
	stEventLog.ErrorCode:=0;
	
	stEventLog.Text := 'SBlock.LogCriticalAlarm';
	
	IF 		iReasonCritical.0 THEN stEventLog.Text := 'SBlock. xAlrSafetySystemInBlock';
	ELSIF 	iReasonCritical.1 THEN stEventLog.Text := 'SBlock. xAlrDriveProtection';
	END_IF
		
	gEventLogLoader(EventData := ADR(stEventLog));
	
END_ACTION

ACTION LogStopAlarm:

//	// Stop Alarms. The machine goes to Automatic-Stop.
//	iReasonStop.0 := Block.Al.xAnyDriveAlarm;
//	iReasonStop.1 := Block.Al.xAlrBarMtrNoRef;
//	iReasonStop.2 := Block.Al.xAlrComBarMtr;

	stEventLog.Source := ELOG_TYPE_SIMPLEBLOCK;
	stEventLog.Severity:= ELOG_SEVERITY_ERROR;
	stEventLog.Facility:= gIndexSimpleBlock;
	stEventLog.ErrorCode:=0;
	
	stEventLog.Text := 'SBlock.LogStopAlarm';
	
	IF 		iReasonStop.0 THEN stEventLog.Text := 'SBlock. xAnyDriveAlarm';
	ELSIF 	iReasonStop.1 THEN stEventLog.Text := 'SBlock. xAlrBarMtrNoRef';
	ELSIF 	iReasonStop.2 THEN stEventLog.Text := 'SBlock. xAlrComBarMtr';
	END_IF
		
	gEventLogLoader(EventData := ADR(stEventLog));
	
END_ACTION

ACTION LogToCapOrder:

	stEventLog.Source := ELOG_TYPE_SIMPLEBLOCK;
	stEventLog.Severity:= ELOG_SEVERITY_INFO;
	stEventLog.Facility:= gIndexSimpleBlock;
	stEventLog.ErrorCode:=0;
	
	stEventLog.Text := 'Order to Cap BK: ';
	brsitoa(gIndexSimpleBlock, ADR(strAuxEventDesc));
	brsstrcat(ADR(stEventLog.Text), ADR(strAuxEventDesc));

	gEventLogLoader(EventData := ADR(stEventLog));
	
END_ACTION

ACTION LogToPrintOrder:

	stEventLog.Source := ELOG_TYPE_SIMPLEBLOCK;
	stEventLog.Severity:= ELOG_SEVERITY_INFO;
	stEventLog.Facility:= gIndexSimpleBlock;
	stEventLog.ErrorCode:=0;
	
	stEventLog.Text := 'Order to Print BK: ';
	brsitoa(gIndexSimpleBlock, ADR(strAuxEventDesc));
	brsstrcat(ADR(stEventLog.Text), ADR(strAuxEventDesc));

	gEventLogLoader(EventData := ADR(stEventLog));
	
END_ACTION

ACTION LogVertMovementOrder:

	VerMotorEventLog.Source := ELOG_TYPE_SIMPLEBLOCK;
	VerMotorEventLog.Severity:= ELOG_SEVERITY_INFO;
	VerMotorEventLog.Facility:= gIndexSimpleBlock;
	VerMotorEventLog.ErrorCode:=0;
	
	VerMotorEventLog.Text := 'Vert Mov Order BK: ';
	brsitoa(gIndexSimpleBlock, ADR(strAuxEventDesc));
	brsstrcat(ADR(VerMotorEventLog.Text), ADR(strAuxEventDesc));
	brsstrcat(ADR(VerMotorEventLog.Text), ADR(': '));
	brsftoa(MotorDriveUnit.PositionDesired, ADR(strAuxEventDesc));
	brsstrcat(ADR(VerMotorEventLog.Text), ADR(strAuxEventDesc));
	brsstrcat(ADR(VerMotorEventLog.Text), ADR('mm. St: '));
	brsitoa(nState, ADR(strAuxEventDesc));
	brsstrcat(ADR(VerMotorEventLog.Text), ADR(strAuxEventDesc));
		
	gEventLogLoader(EventData := ADR(VerMotorEventLog));
	
END_ACTION

ACTION LogVertInPosition:

	VerMotorEventLog.Source := ELOG_TYPE_SIMPLEBLOCK;
	VerMotorEventLog.Severity:= ELOG_SEVERITY_INFO;
	VerMotorEventLog.Facility:= gIndexSimpleBlock;
	VerMotorEventLog.ErrorCode:=0;
	
	VerMotorEventLog.Text := 'Vert Mov In Position BK: ';
	brsitoa(gIndexSimpleBlock, ADR(strAuxEventDesc));
	brsstrcat(ADR(VerMotorEventLog.Text), ADR(strAuxEventDesc));
	brsstrcat(ADR(VerMotorEventLog.Text), ADR(': '));
	brsftoa(MotorDriveUnit.PositionDevice, ADR(strAuxEventDesc));
	brsstrcat(ADR(VerMotorEventLog.Text), ADR(strAuxEventDesc));
	brsstrcat(ADR(VerMotorEventLog.Text), ADR('mm. St: '));
	brsitoa(nState, ADR(strAuxEventDesc));
	brsstrcat(ADR(VerMotorEventLog.Text), ADR(strAuxEventDesc));
		
	gEventLogLoader(EventData := ADR(VerMotorEventLog));
	
END_ACTION

ACTION LogHomingOrderBar:

	VerMotorEventLog.Source := ELOG_TYPE_SIMPLEBLOCK;
	VerMotorEventLog.Severity:= ELOG_SEVERITY_INFO;
	VerMotorEventLog.Facility:= gIndexSimpleBlock;
	VerMotorEventLog.ErrorCode:=0;
	
	VerMotorEventLog.Text := 'Homing order Vert BK: ';
	brsitoa(gIndexSimpleBlock, ADR(strAuxEventDesc));
	brsstrcat(ADR(VerMotorEventLog.Text), ADR(strAuxEventDesc));
		
	gEventLogLoader(EventData := ADR(VerMotorEventLog));
	
END_ACTION

ACTION LogHomedBar:

	VerMotorEventLog.Source := ELOG_TYPE_SIMPLEBLOCK;
	VerMotorEventLog.Severity:= ELOG_SEVERITY_INFO;
	VerMotorEventLog.Facility:= gIndexSimpleBlock;
	VerMotorEventLog.ErrorCode:=0;
	
	VerMotorEventLog.Text := 'Vert Motor Homed BK: ';
	brsitoa(gIndexSimpleBlock, ADR(strAuxEventDesc));
	brsstrcat(ADR(VerMotorEventLog.Text), ADR(strAuxEventDesc));
		
	gEventLogLoader(EventData := ADR(VerMotorEventLog));
	
END_ACTION
