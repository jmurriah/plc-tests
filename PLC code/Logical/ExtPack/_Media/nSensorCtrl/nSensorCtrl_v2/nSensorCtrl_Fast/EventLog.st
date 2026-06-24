ACTION LogRaiseSensor2:

	stRaiseSensor2.Source := ELOG_TYPE_DETECTION;
	stRaiseSensor2.Severity:= ELOG_SEVERITY_INFO;
	stRaiseSensor2.Facility:= 2;
	stRaiseSensor2.ErrorCode:=0;
	
	stRaiseSensor2.Text := 'nSensor. Raised Sensor2';
		
	gEventLogLoader(EventData := ADR(stRaiseSensor2));
	
END_ACTION

ACTION LogLowerSensor2:

	stLowerSensor2.Source := ELOG_TYPE_DETECTION;
	stLowerSensor2.Severity:= ELOG_SEVERITY_INFO;
	stLowerSensor2.Facility:= 2;
	stLowerSensor2.ErrorCode:=0;
	
	stLowerSensor2.Text := 'nSensor. Lowered Sensor2';
		
	gEventLogLoader(EventData := ADR(stLowerSensor2));
	
END_ACTION

ACTION LogRaiseSensor3:

	stRaiseSensor3.Source := ELOG_TYPE_DETECTION;
	stRaiseSensor3.Severity:= ELOG_SEVERITY_INFO;
	stRaiseSensor3.Facility:= 3;
	stRaiseSensor3.ErrorCode:=0;
	
	stRaiseSensor3.Text := 'nSensor. Raised Sensor3';
		
	gEventLogLoader(EventData := ADR(stRaiseSensor3));
	
END_ACTION

ACTION LogLowerSensor3:

	stLowerSensor3.Source := ELOG_TYPE_DETECTION;
	stLowerSensor3.Severity:= ELOG_SEVERITY_INFO;
	stLowerSensor3.Facility:= 3;
	stLowerSensor3.ErrorCode:=0;
	
	stLowerSensor3.Text := 'nSensor. Lowered Sensor3';
		
	gEventLogLoader(EventData := ADR(stLowerSensor3));
	
END_ACTION

ACTION LogRaiseSensor4:

	stRaiseSensor4.Source := ELOG_TYPE_DETECTION;
	stRaiseSensor4.Severity:= ELOG_SEVERITY_INFO;
	stRaiseSensor4.Facility:= 4;
	stRaiseSensor4.ErrorCode:=0;
	
	stRaiseSensor4.Text := 'nSensor. Raised Sensor4';
		
	gEventLogLoader(EventData := ADR(stRaiseSensor4));
	
END_ACTION

ACTION LogLowerSensor4:

	stLowerSensor4.Source := ELOG_TYPE_DETECTION;
	stLowerSensor4.Severity:= ELOG_SEVERITY_INFO;
	stLowerSensor4.Facility:= 4;
	stLowerSensor4.ErrorCode:=0;
	
	stLowerSensor4.Text := 'nSensor. Lowered Sensor4';
		
	gEventLogLoader(EventData := ADR(stLowerSensor4));
	
END_ACTION

ACTION LogRaiseSensor5:

	stRaiseSensor5.Source := ELOG_TYPE_DETECTION;
	stRaiseSensor5.Severity:= ELOG_SEVERITY_INFO;
	stRaiseSensor5.Facility:= 5;
	stRaiseSensor5.ErrorCode:=0;
	
	stRaiseSensor5.Text := 'nSensor. Raised Sensor5';
		
	gEventLogLoader(EventData := ADR(stRaiseSensor5));
	
END_ACTION

ACTION LogLowerSensor5:

	stLowerSensor5.Source := ELOG_TYPE_DETECTION;
	stLowerSensor5.Severity:= ELOG_SEVERITY_INFO;
	stLowerSensor5.Facility:= 5;
	stLowerSensor5.ErrorCode:=0;
	
	stLowerSensor5.Text := 'nSensor. Lowered Sensor5';
		
	gEventLogLoader(EventData := ADR(stLowerSensor5));
	
END_ACTION

ACTION LogRaiseSensor6:

	stRaiseSensor6.Source := ELOG_TYPE_DETECTION;
	stRaiseSensor6.Severity:= ELOG_SEVERITY_INFO;
	stRaiseSensor6.Facility:= 6;
	stRaiseSensor6.ErrorCode:=0;
	
	stRaiseSensor6.Text := 'nSensor. Raised Sensor6';
		
	gEventLogLoader(EventData := ADR(stRaiseSensor6));
	
END_ACTION

ACTION LogLowerSensor6:

	stLowerSensor6.Source := ELOG_TYPE_DETECTION;
	stLowerSensor6.Severity:= ELOG_SEVERITY_INFO;
	stLowerSensor6.Facility:= 6;
	stLowerSensor6.ErrorCode:=0;
	
	stLowerSensor6.Text := 'nSensor. Lowered Sensor6';
		
	gEventLogLoader(EventData := ADR(stLowerSensor6));
	
END_ACTION


