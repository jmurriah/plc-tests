
ACTION Alarms: 

	//Reset Alarms with an external order to reset
	IF dataNC.Commands.xReset THEN
		ResetAlarms;
	END_IF
	
	//Comms error
	IF (AxisMotor.Status.ErrorID=32189) OR (AxisMotor.Status.ErrorID=29265) THEN
		dataNC.Alarms.xAlrComsDrive := TRUE;
	END_IF
	
	//If error and not Comms error, defined as Drive Error
	tonAlarmDelay.IN :=  NOT dataNC.Alarms.xAlrComsDrive AND AxisMotor.Status.ErrorID<>0 AND StatusCtrl <> NONCRASH_NOT_INITIALIZED AND NOT dataNC.AlSummary.xAlrSafetySystemGeneral;
	tonAlarmDelay.PT := T#100ms;
	tonAlarmDelay();
	IF tonAlarmDelay.Q THEN
		dataNC.Alarms.xAlrDriveError := TRUE;
	END_IF
	
	tonOvertorque.IN := AxisMotor.Status.ActTorque > AxisMotor.Status.RatedTorque;
	tonOvertorque.PT := dataNC.Parameters.tiTorqueFilter;
	tonOvertorque();
	IF tonOvertorque.Q THEN
		dataNC.Alarms.xAlrOvertorque := TRUE;
	END_IF
	
	//Diferential Breaker Alarm
	IF NOT dataNC.Inputs.xDiffContacOk THEN
		dataNC.Alarms.xAlrDiffContact := TRUE;
	END_IF
	
	//Alarm: motor parameters from SW
	IF (dataNC.parSw.rPerimeter <= 0.0) THEN
		dataNC.Alarms.xPerimeterNotDefined := TRUE;
	ELSE
		dataNC.Alarms.xPerimeterNotDefined := FALSE;
	END_IF
	
	IF (dataNC.parSw.rGearBox <= 0.0) THEN
		dataNC.Alarms.xGearBoxNotDefined := TRUE;
	ELSE
		dataNC.Alarms.xGearBoxNotDefined := FALSE;
	END_IF
	
	tonControllerReady.IN := (NOT AxisMotor.Status.ControllerReady OR AxisMotor.Status.ErrorID=29216) AND NOT dataNC.Parameters.Mode.xZero;	//ErrorID 29216 to desconect only power wires
	tonControllerReady.PT := t#300ms;
	tonControllerReady();
	IF tonControllerReady.Q THEN
		dataNC.Alarms.xControllerNotReady := TRUE;
	END_IF
	
	
	// SUMMARY SUMMARY SUMMARY SUMMARY SUMMARY SUMMARY SUMMARY SUMMARY 
	// SUMMARY SUMMARY SUMMARY SUMMARY SUMMARY SUMMARY SUMMARY SUMMARY 
	
	iReasonStop.0 := dataNC.Alarms.xAlrComsDrive;
	iReasonStop.1 := dataNC.Alarms.xAlrDriveError;
	iReasonStop.2 := dataNC.Alarms.xAlrOvertorque;
	iReasonStop.3 := dataNC.Alarms.xAlrDiffContact;
	iReasonStop.4 := dataNC.Alarms.xControllerNotReady;
	iReasonStop.5 := dataNC.Alarms.xPerimeterNotDefined;
	iReasonStop.6 := dataNC.Alarms.xGearBoxNotDefined;
	
	dataNC.AlSummary.xAlarmStop:=	iReasonStop > 0;
	IF EDGEPOS(dataNC.AlSummary.xAlarmStop) THEN
		dataNC.AlSummary.iReasonStop[0] := iReasonStop;
		LogStopAlarm;
	ELSIF EDGEPOS(NOT dataNC.Parameters.AutoMode.xStop AND NOT dataNC.AlSummary.xAlarmStop) THEN
		dataNC.AlSummary.iReasonStop[0] := 0;
	END_IF		
	
	dataNC.AlSummary.xAlarmCritical := iReasonCritical > 0;
	IF EDGEPOS(dataNC.AlSummary.xAlarmCritical) THEN
		dataNC.AlSummary.iReasonCritical := iReasonCritical;
	ELSIF EDGEPOS(dataNC.Parameters.Mode.xAuto AND NOT dataNC.AlSummary.xAlarmCritical) THEN
		dataNC.AlSummary.iReasonCritical := 0;
	END_IF		
	
	dataNC.AlSummary.xAlrSafetySystemGeneral := dataNC.Commands.xExternalSafetyStop;
	
	// SOUND SOUND SOUND SOUND SOUND SOUND SOUND SOUND SOUND SOUND 
	// SOUND SOUND SOUND SOUND SOUND SOUND SOUND SOUND SOUND SOUND 
	
	// Reseteable alarms
	arxAlrComsDrive.xAlarm		:= dataNC.Alarms.xAlrComsDrive;
	arxAlrComsDrive.xSilence	:= dataNC.Commands.xMute;	
	arxAlrComsDrive();
	
	arxAlrDriveError.xAlarm		:= dataNC.Alarms.xAlrDriveError;
	arxAlrDriveError.xSilence	:= dataNC.Commands.xMute;	
	arxAlrDriveError();
	
	arxAlrOvertorque.xAlarm		:= dataNC.Alarms.xAlrOvertorque;
	arxAlrOvertorque.xSilence	:= dataNC.Commands.xMute;	
	arxAlrOvertorque();
	
	arxAlrDiffContact.xAlarm	:= dataNC.Alarms.xAlrDiffContact;
	arxAlrDiffContact.xSilence	:= dataNC.Commands.xMute;	
	arxAlrDiffContact();
	
	arxAlrControllerNotReady.xAlarm	:= dataNC.Alarms.xControllerNotReady;
	arxAlrControllerNotReady.xSilence	:= dataNC.Commands.xMute;	
	arxAlrControllerNotReady();
	
	arxAlrPerimeterNotDefined.xAlarm	:= dataNC.Alarms.xPerimeterNotDefined;
	arxAlrPerimeterNotDefined.xSilence	:= dataNC.Commands.xMute;	
	arxAlrPerimeterNotDefined();
	
	arxAlrGearBoxNotDefined.xAlarm	:= dataNC.Alarms.xGearBoxNotDefined;
	arxAlrGearBoxNotDefined.xSilence	:= dataNC.Commands.xMute;	
	arxAlrGearBoxNotDefined();
	
	iReasonSound.0 := arxAlrComsDrive.xAlarmSound;
	iReasonSound.1 := arxAlrDriveError.xAlarmSound;
	iReasonSound.2 := arxAlrOvertorque.xAlarmSound;
	iReasonSound.3 := arxAlrDiffContact.xAlarmSound;
	iReasonSound.4 := arxAlrControllerNotReady.xAlarmSound;
	iReasonSound.5 := arxAlrPerimeterNotDefined.xAlarmSound;
	iReasonSound.6 := arxAlrGearBoxNotDefined.xAlarmSound;
	dataNC.AlSummary.xAlarmSound := iReasonSound > 0;

	// Mute sound in belt alarms
	IF dataNC.Commands.xMute OR dataNC.Commands.xReset THEN
		dataNC.AlSummary.xAlarmSound:= FALSE;
	END_IF
	
	
END_ACTION


ACTION ResetAlarms:
	dataNC.Alarms := AlarmsReseted;
	dataNC.AlSummary := AlarmsSummaryReseted;
END_ACTION
