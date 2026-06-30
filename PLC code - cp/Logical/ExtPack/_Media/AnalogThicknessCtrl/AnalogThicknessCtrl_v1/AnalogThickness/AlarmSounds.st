
ACTION AlarmSounds: 
	
	ars_AlMountedTile.xAlarm:= data.Alarms.xMountedTile;
	ars_AlMountedTile.xSilence:= data.Commands.xMute;
	ars_AlMountedTile();

	ars_AlDingConexionError.xAlarm:= data.Alarms.xAlDingConexionError;
	ars_AlDingConexionError.xSilence:= data.Commands.xMute;
	ars_AlDingConexionError();
	
	ars_AlDingNotReferenced.xAlarm:= data.Alarms.xAlDingNotReferenced;
	ars_AlDingNotReferenced.xSilence:= data.Commands.xMute;
	ars_AlDingNotReferenced();
	
	ars_AlNoDingDetect.xAlarm:= data.Alarms.xAlNoDingDetect;
	ars_AlNoDingDetect.xSilence:= data.Commands.xMute;
	ars_AlNoDingDetect();
	
	ars_AlDingDetect.xAlarm:= data.Alarms.xAlDingDetect;
	ars_AlDingDetect.xSilence:= data.Commands.xMute;
	ars_AlDingDetect();
	
	ars_AlDingIncoherenceValue.xAlarm:= data.Alarms.xAlDingIncoherenceValue;
	ars_AlDingIncoherenceValue.xSilence:= data.Commands.xMute;
	ars_AlDingIncoherenceValue();
	
	ars_AlDingNoDigLaserSensor.xAlarm:= data.Alarms.xAlDingNoDigLaserSensor;
	ars_AlDingNoDigLaserSensor.xSilence:= data.Commands.xMute;
	ars_AlDingNoDigLaserSensor();
	
	data.AlSummary.xAlarmSound:=	ars_AlDingConexionError.xAlarmSound OR
									ars_AlDingNotReferenced.xAlarmSound OR
									ars_AlNoDingDetect.xAlarmSound OR
									ars_AlDingDetect.xAlarmSound OR
									ars_AlDingIncoherenceValue.xAlarmSound OR
									ars_AlDingNoDigLaserSensor.xAlarmSound OR
									ars_AlMountedTile.xAlarmSound;

END_ACTION
