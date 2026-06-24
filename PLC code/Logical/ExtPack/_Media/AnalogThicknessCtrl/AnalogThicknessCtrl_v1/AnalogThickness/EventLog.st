
ACTION LogOrderReceivedOK: 
	stEventLog.Source := ELOG_TYPE_DETECTION;
	stEventLog.Severity:= ELOG_SEVERITY_INFO;
	stEventLog.Facility:= 0;
	stEventLog.ErrorCode:=0;
	stEventLog.Text := 'Analog Thickness sensor order received';
	gEventLogLoader(EventData := ADR(stEventLog));
END_ACTION

ACTION LogOrderReceivedNOK: 
	stEventLog.Source := ELOG_TYPE_DETECTION;
	stEventLog.Severity:= ELOG_SEVERITY_INFO;
	stEventLog.Facility:= 0;
	stEventLog.ErrorCode:=0;
	stEventLog.Text := 'Analog Thickness sensor order received but not Media in sensor. Action cancelled';
	gEventLogLoader(EventData:=ADR(stEventLog));
END_ACTION

ACTION LogCalibrationOK: 
	stEventLogCal.Source := ELOG_TYPE_DETECTION;
	stEventLogCal.Severity:= ELOG_SEVERITY_INFO;
	stEventLogCal.Facility:= 0;
	stEventLogCal.ErrorCode:=0;
	stEventLogCal.Text := 'Analog Thickness sensor calibrated with offset: ';
	brsftoa(gDing.State.rOffsetCalibration, ADR(strAux));
	brsstrcat(ADR(stEventLogCal.Text), ADR(strAux));
	brsstrcat(ADR(stEventLogCal.Text), ADR('mm'));
	gEventLogLoader(EventData:=ADR(stEventLogCal));
END_ACTION

ACTION LogRejectDetected: 
	stEventLogReject.Source := ELOG_TYPE_DETECTION;
	stEventLogReject.Severity:= ELOG_SEVERITY_INFO;
	stEventLogReject.Facility:= 0;
	stEventLogReject.ErrorCode:=0;
	stEventLogReject.Text := 'Analog. Rejected Media Detected';
	gEventLogLoader(EventData := ADR(stEventLogReject));
END_ACTION

ACTION LogRejectEnded: 
	stEventLogEndReject.Source := ELOG_TYPE_DETECTION;
	stEventLogEndReject.Severity:= ELOG_SEVERITY_INFO;
	stEventLogEndReject.Facility:= 0;
	stEventLogEndReject.ErrorCode:=0;
	stEventLogEndReject.Text := 'Analog. End Rejected Media Detection';
	gEventLogLoader(EventData := ADR(stEventLogEndReject));
END_ACTION
