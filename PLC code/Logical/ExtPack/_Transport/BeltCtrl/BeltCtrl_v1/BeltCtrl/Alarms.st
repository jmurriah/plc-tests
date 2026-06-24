
ACTION Alarms:
	
	///////////////
	// BELT ALARMS
	///////////////
	// Timer Drive Protection
	T_AlrProtDrive.IN := (NOT Belt.parameters.xDriveProtectionOK);
	T_AlrProtDrive.PT :=T#2s;
	T_AlrProtDrive();
	IF T_AlrProtDrive.Q THEN
		Belt.Al.xAlrProtDrive := TRUE;
	END_IF
	
	// Alarm: Power Error AND Alarm Drive Protection
	IF AxisBelt.Status.ErrorID=5012 THEN
		Belt.Al.xAlrPowerBeltError := TRUE;
	END_IF
	
	// Alarm: Comms Error
	IF (AxisBelt.Status.ErrorID=32189) OR (AxisBelt.Status.ErrorID=29265) THEN
		Belt.Al.xAlrComDrive := TRUE;
	END_IF
	
	//Warning Over Torque
	TON_OvertorqueWarning.IN := ABS(AxisBelt.Status.ActTorque) > AxisBelt.Status.RatedTorque;
	TON_OvertorqueWarning.PT := T#30s;
	TON_OvertorqueWarning();
	
	IF TON_OvertorqueWarning.Q THEN
		Belt.Al.xWrnOverTorq := TRUE;
	END_IF
	
	// Alarm: Over Torque
	tonOvertorqueAlarm.IN := ABS(AxisBelt.Status.ActTorque) > AxisBelt.Status.RatedTorque;
	tonOvertorqueAlarm.PT := T#2m;
	tonOvertorqueAlarm();
	IF tonOvertorqueAlarm.Q THEN
		Belt.Al.xAlrOverTorque := TRUE;
	END_IF
	
	//Alarm: Any error
	iReasonAnyError.0 := AxisBelt.Status.ErrorID<>0 AND (iBeltState<>BELT_NOT_INITIALIZED); 
	iReasonAnyError.1 := Belt.Al.xControllerNotReady;
	xAnyDriveError := iReasonAnyError>0;
	
	Belt.Al.xAnyDriveAlarm := 	xAnyDriveError AND 
								NOT Belt.AlSummary.xAlrSafetySystemGeneral AND
								NOT (Belt.commands.Mode.xZero);

	// Alarm: Temp Belt Motor
	Belt.states.rCurrentTemperature := AxisBelt.Status.ActTempMot;
	IF AxisBelt.Status.ActTempMot > (AxisBelt.Status.MaxTempMotor - 5.0) THEN
		IF AxisBelt.Status.MaxTempMotor > 0 THEN Belt.Al.xBeltMotorTemp := TRUE; END_IF
	ELSIF AxisBelt.Status.ActTempMot < (AxisBelt.Status.MaxTempMotor - 7.0) THEN
		Belt.Al.xBeltMotorTemp := FALSE;
	END_IF
	
	// Alarm: Temp Belt Driver
	IF AxisBelt.Status.ActTempDrv > (AxisBelt.Status.MaxTempDrv - 5.0) THEN
		IF AxisBelt.Status.MaxTempDrv > 0 THEN Belt.Al.xBeltDriverTemp := TRUE; END_IF
	ELSIF AxisBelt.Status.ActTempDrv < (AxisBelt.Status.MaxTempDrv - 7.0) THEN
		Belt.Al.xBeltDriverTemp := FALSE;
	END_IF
	
	//Alarm: motor parameters from SW
	IF (Belt.parSw.rAxisLength <= 0.0) THEN
		Belt.Al.xAxisLengthNotDefined := TRUE;
	ELSE
		Belt.Al.xAxisLengthNotDefined := FALSE;
	END_IF
	
	IF (Belt.parSw.rGearBox <= 0.0) THEN
		Belt.Al.xGearBoxNotDefined := TRUE;
	ELSE
		Belt.Al.xGearBoxNotDefined := FALSE;
	END_IF
	
	tonControllerReady.IN :=	(NOT AxisBelt.Status.ControllerReady OR AxisBelt.Status.ErrorID=29216) AND // ErrorID 29216 3phase input wires disconnected
								NOT Belt.commands.Mode.xZero AND
								NOT Belt.AlSummary.xAlrSafetySystemGeneral;
	
	tonControllerReady.PT := t#2s;
	tonControllerReady();
	IF tonControllerReady.Q THEN
		Belt.Al.xControllerNotReady := TRUE;
	END_IF
	
	tonEnableVoltageSag.IN := (AxisBelt.Status.ErrorID=6058 OR AxisBelt.Status.ErrorID=6059) AND NOT Belt.commands.Mode.xZero; // ErrorID 6058 enable1 voltage sag. ErrorID 6059 enable2 voltage sag
	tonEnableVoltageSag.PT := t#300ms;
	tonEnableVoltageSag();
	IF tonEnableVoltageSag.Q THEN
		Belt.Al.xEnableVoltageSag := TRUE;
	END_IF
	
	
	//########################## ALARMS SUMMARY ########################################
	AlarmsSummary;	
END_ACTION
