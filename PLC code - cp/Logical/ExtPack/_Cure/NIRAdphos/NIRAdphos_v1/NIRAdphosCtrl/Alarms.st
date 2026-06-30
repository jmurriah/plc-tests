
ACTION Alarms: 

	//////////////////////////
	////// RESET ALARMS //////
	IF data.Commands.xReset THEN
		data.Alarms := resetedAlarms;
		data.AlSummary := resetedAlarmsSummary;
	END_IF
	
	IF NOT data.Status.xCommsOK THEN
		data.Alarms.xCommsError := TRUE;
	END_IF
	
	IF data.Signals.In.xFault THEN
		data.Alarms.xFault := TRUE;
	END_IF
	
	IF NOT data.Signals.In.xSafetyOK THEN
		data.Alarms.xSafetyError := TRUE;
	END_IF

	//Module alarms
	xAnyBlockedFan := FALSE;
	xAnyJam := FALSE;
	FOR iIndexModule := 1 TO data.Parameters.iTotalModules DO
		
		//Temperatures
		IF data.Status.rSurfaceTempModule[iIndexModule] > data.Parameters.rMaxSurfaceTemp THEN
			data.Alarms.xMaxSurfaceTempModule[iIndexModule] := TRUE;
		END_IF
		IF data.Signals.In.xSurfaceTempModuleSensorError[iIndexModule] THEN
			data.Alarms.xSurfaceTempModuleSensorError[iIndexModule] := TRUE;
		END_IF
		
		IF data.Signals.In.Jam[iIndexModule].xMechCross AND data.Orders.xCheckJam THEN
			data.Alarms.Jam[iIndexModule].xMechCross:=TRUE;
		END_IF
		
		//Jams. Check anyJam
		IF data.Alarms.Jam[iIndexModule].xMechCross THEN
			xAnyJam := TRUE;
		END_IF
		
		//Blocked Fans
		FOR iIndexFan := 1 TO 4 DO
			IF data.Signals.In.BlockedFans[iIndexModule].Fan[iIndexFan] THEN
				data.Alarms.BlockedFansModule[iIndexModule].Fan[iIndexFan] := TRUE;
				xAnyBlockedFan := TRUE;
			END_IF
		END_FOR
		
	END_FOR
	
	data.Alarms.xAnyJam := xAnyJam;
	
	IF data.Signals.In.xInletHumiditySensorError THEN
		data.Alarms.xInletHumiditySensorError := TRUE;
	END_IF
	IF data.Signals.In.xInletTempSensorError THEN
		data.Alarms.xInletTempSensorError := TRUE;
	END_IF
	
	/////////////////////////////////////////////////////////////////
	//  SOUND  SOUND  SOUND  SOUND  SOUND  SOUND  SOUND  
	/////////////////////////////////////////////////////////////////
	
	arFault(xAlarm:= data.Alarms.xFault, xSilence:=data.Commands.xMute);
	arSafety(xAlarm:= data.Alarms.xSafetyError, xSilence:=data.Commands.xMute);
	arSurfaceTemp1(xAlarm:= data.Alarms.xMaxSurfaceTempModule[1], xSilence:=data.Commands.xMute);
	arSurfaceTemp2(xAlarm:= data.Alarms.xMaxSurfaceTempModule[2], xSilence:=data.Commands.xMute);
	arSurfaceTempSensorError1(xAlarm:= data.Alarms.xSurfaceTempModuleSensorError[1], xSilence:=data.Commands.xMute);
	arSurfaceTempSensorError2(xAlarm:= data.Alarms.xSurfaceTempModuleSensorError[2], xSilence:=data.Commands.xMute);
	arAnyBlockedFan(xAlarm:= xAnyBlockedFan, xSilence:=data.Commands.xMute);
	arAnyJam(xAlarm:= xAnyJam, xSilence:=data.Commands.xMute);

	reasonSound.0 := arFault.xAlarmSound;
	reasonSound.1 := arSafety.xAlarmSound;
	reasonSound.2 := arSurfaceTemp1.xAlarmSound;
	reasonSound.3 := arSurfaceTemp2.xAlarmSound;
	reasonSound.4 := arSurfaceTempSensorError1.xAlarmSound;
	reasonSound.5 := arSurfaceTempSensorError2.xAlarmSound;
	reasonSound.6 := arAnyBlockedFan.xAlarmSound;
	reasonSound.7 := arAnyJam.xAlarmSound;
	
	data.AlSummary.xAlarmSound := reasonSound>0;
	
END_ACTION
