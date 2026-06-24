
ACTION Alarms: 
	
	
	xAnyLampInError := FALSE;
	FOR iLamp:=1 TO data.Parameters.iLampQuantity DO
		IF data.Status.Lamps[iLamp].InAlarm AND data.Parameters.Lamps[iLamp].Enable THEN
			xAnyLampInError := TRUE;
		END_IF
	END_FOR;
	data.Status.xAnyLampInError := xAnyLampInError;
	
	IF Client.httpStatus = HTTPSTATUS_UNAUTORIZED THEN
		data.Alarms.Comms.xCredentialsError := TRUE;
	END_IF
	
	IF Client.httpStatus = HTTPSTATUS_INTERNALSERVERERROR THEN
		data.Alarms.Comms.xServerError := TRUE;
	END_IF
	
	IF data.Signals.In.xJam THEN
		data.Alarms.xJam := TRUE;
	END_IF
	
	/////////////////////////////////////////////////////////////////
	//  SOUND  SOUND  SOUND  SOUND  SOUND  SOUND  SOUND  
	/////////////////////////////////////////////////////////////////
	
	arCommsError(xAlarm:= data.Alarms.xCommsError, xSilence:=data.Commands.xMute);
	arLampInError1(xAlarm:= data.Status.Lamps[1].InAlarm, xSilence:=data.Commands.xMute);
	arLampInError2(xAlarm:= data.Status.Lamps[2].InAlarm, xSilence:=data.Commands.xMute);
	arJam(xAlarm:= data.Alarms.xJam, xSilence:=data.Commands.xMute);

	reasonSound.0 := arCommsError.xAlarmSound;
	reasonSound.1 := arLampInError1.xAlarmSound;
	reasonSound.2 := arLampInError2.xAlarmSound;
	reasonSound.7 := arJam.xAlarmSound;
	
	data.AlSummary.xAlarmSound := reasonSound>0;
	
END_ACTION
