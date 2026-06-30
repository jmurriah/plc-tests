
ACTION BlockAlarms:

	// Alarm: Reference incoherence  (NEW: Add To Software)
	T_DelayAlarmRef.IN:=Block.In.xReferenceDI <> AxisBK.Status.DigitalInputs.RefSwitch;
	T_DelayAlarmRef.PT:=T#1000ms;
	T_DelayAlarmRef();
	
	Block.Al.xAlrReferenceIncoherence:= T_DelayAlarmRef.Q;

	// Alarm: Drive protection
	IF NOT Block.In.xDriveProtectionOK THEN
		Block.Al.xAlrDriveProtection:= TRUE;
	END_IF
						
	// Alarm: Temp Vertical Motor
	IF AxisBK.Status.ActTempMot > (AxisBK.Status.MaxTempMotor - 5.0) THEN
		IF AxisBK.Status.MaxTempMotor > 0 THEN Block.Al.xBarMotorTemp := TRUE; END_IF
	ELSIF AxisBK.Status.ActTempMot < (AxisBK.Status.MaxTempMotor - 7.0) THEN
		Block.Al.xBarMotorTemp := FALSE;
	END_IF

	// Alarm: Temp Vertical Driver
	IF AxisBK.Status.ActTempDrv > (AxisBK.Status.MaxTempDrv - 5.0) THEN
		IF AxisBK.Status.MaxTempDrv > 0 THEN Block.Al.xBarDriverTemp := TRUE; END_IF
	ELSIF AxisBK.Status.ActTempDrv < (AxisBK.Status.MaxTempDrv - 7.0) THEN
		Block.Al.xBarDriverTemp := FALSE;
	END_IF
		
	
	//Not homed bar motor.
	Block.Al.xAlrBarMtrNoRef:= NOT Block.Status.Motor.xBarsHomed;	

	
	//DRIVE ALARMS	
	//Comms error in bar motor
	// Pass codes to ennum type 32189
	Block.Al.xAlrComBarMtr:= (AxisBK.Status.ErrorID= 29265)OR (AxisBK.Status.ErrorID= 32189);
	
	// Alarm: Any drive Alarm
	//Silvia: if there machine is in zero, we don't activate the alarms.
	TON_DelayAnyDriveAlarm.IN:= AxisBK.Status.ErrorID<>0 AND NOT Block.AlSummary.xAlrSafetySystemGeneral AND NOT Block.commands.Mode.xZero AND NOT Block.commands.AutoMode.xBypass;
	TON_DelayAnyDriveAlarm.PT:=t#200ms;
	TON_DelayAnyDriveAlarm();
	Block.Al.xAnyDriveAlarm:= TON_DelayAnyDriveAlarm.Q;
		
	// Alarm: Power Error
	//Silvia: this alarm was not well assotiated. 
	Block.Al.xAlBarMotorPowerOff:= NOT Block.In.xDriveProtectionOK;//AxisBK.Status.ErrorID=5012;

	//Warning: Check Homing Sensor Broken
	IF Block.Al.xAnyDriveAlarm AND (Block.Status.PositionState = BLOCKP_HOMING_BAR) THEN
		Block.Al.xAlrCheckHomingSensor:=TRUE;
	END_IF
		
	//Maxium bars lifting alarm
	IF rMotorCurrentPos >= Block.parameters.Motor.rSafePosition THEN
		Block.Al.xAlrBlockReachedMaxPosition := TRUE;
	END_IF

	TNotPrinterZero.IN:=NOT Block.commands.Mode.xZero;
	TNotPrinterZero.PT:=T#500ms;
	TNotPrinterZero();

	//########################## ALARMS SUMMARY ########################################
	AlarmsSummary;	
	
END_ACTION

