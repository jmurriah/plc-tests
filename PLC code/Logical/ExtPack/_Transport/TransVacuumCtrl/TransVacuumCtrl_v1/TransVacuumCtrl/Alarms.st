
ACTION Alarms: 

	
	IF dataVacc.Inputs.xPressureSensorError AND (xProductionOrJamRecovery OR xRunOutOfProduction) THEN
		dataVacc.Alarms.xAlrVacuumSensor := TRUE;
	END_IF
	
	IF dataVacc.Parameters.Hw.xSystemWithJoints THEN
		tonJunctionAlarm.IN:= NOT dataVacc.Inputs.xJointSystemPressure AND StatusCtrl<>TRANSVAC_OFF;
		tonJunctionAlarm.PT:= T#500ms;
		tonJunctionAlarm();
	END_IF
		
	IF tonJunctionAlarm.Q  THEN
		dataVacc.Alarms.xAlrJointSystemPressure := TRUE;
	END_IF
	
	IF dataVacc.Inputs.xBlowersAnyCB THEN
		dataVacc.Alarms.xAlrBlowersAnyCB := TRUE;
	END_IF
	
	//////////////////////////////////////////////////////////////
	// ALARMS SUMMARY    ALARMS SUMMARY    ALARMS SUMMARY    
	
	iReasonStop.0 := dataVacc.Alarms.xAlrVacuumSensor; //To enable go to ByPass with a sensor error
	iReasonStop.1 := dataVacc.Alarms.xAlrComsBlower;
	iReasonStop.2 := dataVacc.Alarms.xAlrDriveBlowerError;
	iReasonStop.3 := dataVacc.Alarms.xAlrOvertorque;
	iReasonStop.4 := dataVacc.Alarms.xAlrJointSystemPressure AND NOT dataVacc.Parameters.AutoMode.xBypass;
	iReasonStop.5 := dataVacc.Alarms.xAlrBlowersAnyCB;
	iReasonStop.6 := dataVacc.Alarms.xAlrBlowerCB[1];
	iReasonStop.7 := dataVacc.Alarms.xAlrBlowerCB[2];
	iReasonStop.8 := dataVacc.Alarms.xAlrBlowerNotRunning[1];
	iReasonStop.9 := dataVacc.Alarms.xAlrBlowerNotRunning[2];
	
	IF (dataVacc.Parameters.AutoMode.xProduction OR (dataVacc.parSw.xActiveOutOfProduction AND (dataVacc.Parameters.AutoMode.xLaboratory OR dataVacc.Parameters.AutoMode.xBypass))) THEN
		dataVacc.AlSummary.xAlarmStop:=	iReasonStop > 0;
		IF EDGEPOS(dataVacc.AlSummary.xAlarmStop) THEN
			dataVacc.AlSummary.iReasonStop[0] := iReasonStop;
			LogStopAlarm;
		ELSIF EDGEPOS(NOT dataVacc.Parameters.AutoMode.xStop AND NOT dataVacc.AlSummary.xAlarmStop) THEN
			dataVacc.AlSummary.iReasonStop[0] := 0;
		END_IF
	END_IF
	
	dataVacc.AlSummary.xAlarmCritical := iReasonCritical > 0;
	IF EDGEPOS(dataVacc.AlSummary.xAlarmCritical) THEN
		dataVacc.AlSummary.iReasonCritical := iReasonCritical;
	ELSIF EDGEPOS(dataVacc.Parameters.Mode.xAuto AND NOT dataVacc.AlSummary.xAlarmCritical) THEN
		dataVacc.AlSummary.iReasonCritical := 0;
	END_IF
	
	//Warning
	// It is just used for drive alarms
	iAnyWarning.0 := dataVacc.Alarms.xAlrBlowerNotRunning[1];
	iAnyWarning.1 := dataVacc.Alarms.xAlrBlowerNotRunning[2];
	dataVacc.AlSummary.xAnyWarning:= iAnyWarning > 0;
	
	IF EDGEPOS(dataVacc.AlSummary.xAnyWarning) THEN
		dataVacc.AlSummary.iReasonWarning := iAnyWarning;
		//LogWarningAlarm;
	ELSIF EDGENEG(dataVacc.AlSummary.xAnyWarning) THEN
		dataVacc.AlSummary.iReasonWarning := 0;
	END_IF

	// Reseteable alarms
	arxAlrVacuumSensor.xAlarm   := dataVacc.Alarms.xAlrVacuumSensor;
	arxAlrVacuumSensor.xSilence := dataVacc.Commands.xMute;	
	arxAlrVacuumSensor();
	
	arxAlrComsBlower.xAlarm   := dataVacc.Alarms.xAlrComsBlower;
	arxAlrComsBlower.xSilence := dataVacc.Commands.xMute;	
	arxAlrComsBlower();
	
	arxAlrDriveBlowerError.xAlarm   := dataVacc.Alarms.xAlrDriveBlowerError;
	arxAlrDriveBlowerError.xSilence := dataVacc.Commands.xMute;	
	arxAlrDriveBlowerError();
	
	arxAlrJointSystemPressure.xAlarm   := dataVacc.Alarms.xAlrJointSystemPressure;
	arxAlrJointSystemPressure.xSilence := dataVacc.Commands.xMute;	
	arxAlrJointSystemPressure();
	
	arxAlrBlowerCB.xAlarm	:=	dataVacc.Alarms.xAlrBlowersAnyCB OR 
								dataVacc.Alarms.xAlrBlowerCB[1] OR
								dataVacc.Alarms.xAlrBlowerCB[2];
	
	arxAlrBlowerCB.xSilence	:= dataVacc.Commands.xMute;
	arxAlrBlowerCB();
	
	
	iReasonSound.0 := arxAlrVacuumSensor.xAlarmSound;
	iReasonSound.1 := arxAlrComsBlower.xAlarmSound;
	iReasonSound.2 := arxAlrDriveBlowerError.xAlarmSound;
	iReasonSound.3 := arxAlrJointSystemPressure.xAlarmSound;
	iReasonSound.4 := arxAlrBlowerCB.xAlarmSound;
	dataVacc.AlSummary.xAlarmSound:= iReasonSound > 0;

	// Mute sound in belt alarms
	IF dataVacc.Commands.xMute OR dataVacc.Commands.xReset THEN
		dataVacc.AlSummary.xAlarmSound:= FALSE;
	END_IF
	
	
END_ACTION


ACTION ResetAlarms:
	dataVacc.Alarms := AlarmsReseted;
	dataVacc.AlSummary := AlarmsSummaryReseted;
END_ACTION
