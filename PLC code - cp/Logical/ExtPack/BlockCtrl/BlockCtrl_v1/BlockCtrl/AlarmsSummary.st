
ACTION AlarmsSummary: 
	
	// Stop Alarms. The machine goes to Automatic-Stop.
	iReasonStop.0 := Block.Al.xAlrCleanMtrNoRef;
	iReasonStop.1 := Block.Al.xAlAirVenturi AND Block.Status.PositionState = BLOCKP_CLEANING;
	iReasonStop.2 := Block.Al.xAnyVerticalDriveAlarm;
	iReasonStop.3 := Block.Al.xAlrBarMtrNoRef;
	iReasonStop.4 := Block.Al.xSiUnitPowerOff;
	iReasonStop.5 := Block.Al.xAlrComSiUnit;
	iReasonStop.6 := Block.Al.xAlrComBarMtr;
	iReasonStop.7 := Block.Al.xAlrCleanMotor;
	iReasonStop.8 := Block.Al.xAlrComCleanMtr;
	iReasonStop.9 := Block.Al.xAlrEnabCleanMtrDiffLvL;
	iReasonStop.10 := Block.Al.xAlrIncoherPositCleanMtr;
	iReasonStop.11 := Block.Al.xAlCleanInterrupt AND Block.commands.AutoMode.xProdORLab;
	iReasonStop.12 := (Block.Al.xAlrTraySensor OR Block.Al.xAlrCleanSensor) AND Block.commands.AutoMode.xProdORLab;
	iReasonStop.13 := Block.Al.xNoActionDangerCollision;
	iReasonStop.14 := Block.Al.xAlrControllerNotReady;
	iReasonStop.15 := Block.Al.xAlrOverTorque;
	
	Block.AlSummary.xAlarmStop:= iReasonStop > 0;
	IF EDGEPOS(Block.AlSummary.xAlarmStop) THEN
		Block.AlSummary.iReasonStop[0] := iReasonStop;
		LogStopAlarm;
	ELSIF EDGEPOS(NOT Block.commands.AutoMode.xStop AND NOT Block.AlSummary.xAlarmStop) THEN
		Block.AlSummary.iReasonStop[0] := 0;
	END_IF
	
	
	// Out of Automatic Alarms. The machine goes to Standby mode.
	iReasonCritical.0 := (Block.Al.xAlrSafetySystemInBlock AND Block.Status.xEnabledMovements);
	iReasonCritical.1 := Block.Al.xAlrDif;
	iReasonCritical.2 := Block.Al.xAlrDriveProtection;
	Block.AlSummary.xAlarmCritical:= iReasonCritical > 0;
	
	//Register the reason of the Critical Alarm
	IF Block.commands.Mode.xAuto AND EDGEPOS(Block.AlSummary.xAlarmCritical) THEN
		Block.AlSummary.iReasonCritical := iReasonCritical;
		LogCriticalAlarm;
	ELSIF EDGEPOS(Block.commands.Mode.xAuto AND NOT Block.AlSummary.xAlarmCritical) THEN
		Block.AlSummary.iReasonCritical := 0;
	END_IF
	
									 
	// Any alarm	
	Block.AlSummary.xAnyAlarm:= Block.AlSummary.xAlarmStop OR Block.AlSummary.xAlarmCritical;

	// Warning alarms (used in AlarmaAvisoExterno)
	iReasonAnyWarning.0 := Block.Al.xAlrNoTrayInServoNoHomed;
	iReasonAnyWarning.1 := Block.Al.xModuleTemp01;
	iReasonAnyWarning.2 := Block.Al.xModuleTemp02;
	iReasonAnyWarning.3 := Block.Al.xModuleTemp03;
	iReasonAnyWarning.4 := Block.Al.xModuleTemp04;
	iReasonAnyWarning.5 := Block.Al.xBarDriverTemp;
	iReasonAnyWarning.6 := Block.Al.xBarMotorTemp;
	iReasonAnyWarning.7 := Block.Al.xAlrCheckHomingSensor;
	iReasonAnyWarning.8 := Block.Al.xAlrBlockReachedMaxPosition;
	iReasonAnyWarning.9 := Block.Al.xAlrTempPowerSupply;
	iReasonAnyWarning.10 := Block.Al.xAlrDecreaseCleanOffset;
	iReasonAnyWarning.11 := Block.Al.xAlrCappingWaterTankEmpty;
	iReasonAnyWarning.12 := Block.Al.xAlrCappingWaterNotRecirc;
	iReasonAnyWarning.13 := Block.Al.xAlrReferenceIncoherence;
	iReasonAnyWarning.14 := Block.Al.xAlrWtrPresSensBroken;
	iReasonAnyWarning.15 := Block.Al.xAlrWaterPumpPresure;
	iReasonAnyWarning.16 := Block.Al.xAlrEmptyWaterTank;
	iReasonAnyWarning.17 := Block.Al.xWrnOverTorq;
	
	Block.AlSummary.xAnyWarning:= iReasonAnyWarning > 0 ;
	
	//Alarm Safety System General
	iReasonSafetyGeneral.1 := Block.Al.xAlrSafetySystemInBlock;
	iReasonSafetyGeneral.2 := Block.Al.xAlrFrontEmergencyStop;
	iReasonSafetyGeneral.3 := Block.Al.xAlrRearEmergencyStop;
	iReasonSafetyGeneral.4 := Block.Al.xAlrLogicEmergencyStop;
	iReasonSafetyGeneral.5 := xAnyUpperSafety AND Block.commands.AutoMode.xProdORLab;
	iReasonSafetyGeneral.6 := NOT Block.In.Safety.xSafetyOK;	
	Block.AlSummary.xAlrSafetySystemGeneral:= iReasonSafetyGeneral > 0;

	iReasonSafetyCutAir.0 := Block.Al.xAlrSafetySystemInBlock;
	iReasonSafetyCutAir.1 := Block.Al.xAlrFrontEmergencyStop;
	iReasonSafetyCutAir.2 := Block.Al.xAlrRearEmergencyStop;
	iReasonSafetyCutAir.3 := Block.Al.xAlrLogicEmergencyStop;
	iReasonSafetyCutAir.4 := xAnyUpperSafety;
	Block.AlSummary.xAlrSafetyCutAir:= iReasonSafetyCutAir > 0;
	
END_ACTION
