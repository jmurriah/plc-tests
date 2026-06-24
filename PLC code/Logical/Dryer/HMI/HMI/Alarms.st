ACTION Alarms:

	IF EDGEPOS(gDryer.AlSummary.xAlarmCritical) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.GenCritical');
	ELSIF EDGENEG(gDryer.AlSummary.xAlarmCritical) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.GenCritical');
	END_IF

	IF EDGEPOS(gDryer.AlSummary.xAlarmStop) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.GenStop');
	ELSIF EDGENEG(gDryer.AlSummary.xAlarmStop) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.GenStop');
	END_IF

	IF EDGEPOS(gDryer.Al.xAlrStopDrying) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.GenStopDrying');
	ELSIF EDGENEG(gDryer.Al.xAlrStopDrying) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.GenStopDrying');
	END_IF

	IF EDGEPOS(gDryer.Al.Alarm.xFanBreakers) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.FanBreakers');
	ELSIF EDGENEG(gDryer.Al.Alarm.xFanBreakers) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.FanBreakers');
	END_IF

	IF EDGEPOS(gDryer.Al.Alarm.xFan24Vdc) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.FansPsu');
	ELSIF EDGENEG(gDryer.Al.Alarm.xFan24Vdc) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.FansPsu');
	END_IF

	IF EDGEPOS(gDryer.Al.Alarm.xMain24Vdc) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.MainPsu');
	ELSIF EDGENEG(gDryer.Al.Alarm.xMain24Vdc) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.MainPsu');
	END_IF

	IF EDGEPOS(gDryer.Al.Alarm.xAlarmMountedMedia) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.MountedMedia');
	ELSIF EDGENEG(gDryer.Al.Alarm.xAlarmMountedMedia) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.MountedMedia');
	END_IF

	IF EDGEPOS(gDryer.Al.Alarm.Safety.xEStopFront) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.EstopFront');
	ELSIF EDGENEG(gDryer.Al.Alarm.Safety.xEStopFront) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.EstopFront');
	END_IF

	IF EDGEPOS(gDryer.Al.Alarm.Safety.xEStopRear) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.EstopRear');
	ELSIF EDGENEG(gDryer.Al.Alarm.Safety.xEStopRear) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.EstopRear');
	END_IF

	IF EDGEPOS(gDryer.Al.Alarm.Safety.xRemoteEStop) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.EstopRemote');
	ELSIF EDGENEG(gDryer.Al.Alarm.Safety.xRemoteEStop) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.EstopRemote');
	END_IF

	IF EDGEPOS(gDryer.Al.Alarm.xAlrWrongPhysConf) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.WrongPhysConfig');
	ELSIF EDGENEG(gDryer.Al.Alarm.xAlrWrongPhysConf) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.WrongPhysConfig');
	END_IF

	IF EDGEPOS(gDryer.Al.Alarm.xAlrBeltOvertorque) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.OvertorqueBelt');
	ELSIF EDGENEG(gDryer.Al.Alarm.xAlrBeltOvertorque) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.OvertorqueBelt');
	END_IF

	IF EDGEPOS(gDryer.Al.Alarm.xAlrBeltOverTempFast) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.OverTempBeltFast');
	ELSIF EDGENEG(gDryer.Al.Alarm.xAlrBeltOverTempFast) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.OverTempBeltFast');
	END_IF

	IF EDGEPOS(gDryer.Al.Alarm.xAlrBeltOverTempSlow) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.OverTempBeltSlow');
	ELSIF EDGENEG(gDryer.Al.Alarm.xAlrBeltOverTempSlow) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.OverTempBeltSlow');
	END_IF

	IF EDGEPOS(gDryer.Al.Warning.xFanBreakersHighLoad) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.FansPsu80');
	ELSIF EDGENEG(gDryer.Al.Warning.xFanBreakersHighLoad) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.FansPsu80');
	END_IF

	IF EDGEPOS(gDryer.Al.Warning.xMountedMediaInside) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Warning.MountedMediaInside');
	ELSIF EDGENEG(gDryer.Al.Warning.xMountedMediaInside) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Warning.MountedMediaInside');
	END_IF

	IF EDGEPOS(gDryer.Al.Warning.xBeltSensorError) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Warning.BeltTempSensError');
	ELSIF EDGENEG(gDryer.Al.Warning.xBeltSensorError) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Warning.BeltTempSensError');
	END_IF

	IF EDGEPOS(gDryer.Al.Warning.xBoardInSensorError) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Warning.BoardInTempSensError');
	ELSIF EDGENEG(gDryer.Al.Warning.xBoardInSensorError) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Warning.BoardInTempSensError');
	END_IF

	IF EDGEPOS(gDryer.Al.Warning.xBoardOutSensorError) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Warning.BoardOutTempSensError');
	ELSIF EDGENEG(gDryer.Al.Warning.xBoardOutSensorError) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Warning.BoardOutTempSensError');
	END_IF

	IF EDGEPOS(gDryer.Al.Warning.xAirBlowerInputSensorError) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Warning.AirBlowerInTempSensError');
	ELSIF EDGENEG(gDryer.Al.Warning.xAirBlowerInputSensorError) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Warning.AirBlowerInTempSensError');
	END_IF

	IF EDGEPOS(gDryer.Al.Warning.xAirBlowerOutputSensorError) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Warning.AirBlowerOutTempSensError');
	ELSIF EDGENEG(gDryer.Al.Warning.xAirBlowerOutputSensorError) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Warning.AirBlowerOutTempSensError');
	END_IF

	IF EDGEPOS(gDryer.Al.Warning.xFrontDoorOpened) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Warning.FrontDoorOpened');
	ELSIF EDGENEG(gDryer.Al.Warning.xFrontDoorOpened) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Warning.FrontDoorOpened');
	END_IF

	IF EDGEPOS(gDryer.Al.Warning.xRearDoorOpened) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Warning.RearDoorOpened');
	ELSIF EDGENEG(gDryer.Al.Warning.xRearDoorOpened) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Warning.RearDoorOpened');
	END_IF

	IF EDGEPOS(gDryer.Al.Warning.xBentMedia) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Warning.BentMedia');
	ELSIF EDGENEG(gDryer.Al.Warning.xBentMedia) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Warning.BentMedia');
	END_IF

	IF EDGEPOS(gDryer.Al.Warning.xNotEnabledMovement) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Warning.NotMovementEnabled');
	ELSIF EDGENEG(gDryer.Al.Warning.xNotEnabledMovement) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Warning.NotMovementEnabled');
	END_IF

	IF EDGEPOS(gDryer.Al.Warning.xKeyMantenanceActive) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Warning.KeyMantenance');
	ELSIF EDGENEG(gDryer.Al.Warning.xKeyMantenanceActive) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Warning.KeyMantenance');
	END_IF

	IF EDGEPOS(gDryer.Al.Warning.xJamLowCrash) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Warning.JamLowCrash');
	ELSIF EDGENEG(gDryer.Al.Warning.xJamLowCrash) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Warning.JamLowCrash');
	END_IF

	IF EDGEPOS(gBelt.Al.xAnyDriveAlarm) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.BeltAnyDriveAlarm');
	ELSIF EDGENEG(gBelt.Al.xAnyDriveAlarm) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.BeltAnyDriveAlarm');
	END_IF

	IF EDGEPOS(gBelt.Al.xAlrPowerBeltError) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.BeltAlrPowerBeltError');
	ELSIF EDGENEG(gBelt.Al.xAlrPowerBeltError) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.BeltAlrPowerBeltError');
	END_IF

	IF EDGEPOS(gBelt.Al.xAlrComDrive) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.BeltAlrComDrive');
	ELSIF EDGENEG(gBelt.Al.xAlrComDrive) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.BeltAlrComDrive');
	END_IF

	IF EDGEPOS(gBelt.Al.xAlrProtDrive) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.BeltAlrProtDrive');
	ELSIF EDGENEG(gBelt.Al.xAlrProtDrive) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.BeltAlrProtDrive');
	END_IF

	IF EDGEPOS(gBelt.Al.xAlrOverTorque) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.BeltAlrOverTorque');
	ELSIF EDGENEG(gBelt.Al.xAlrOverTorque) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.BeltAlrOverTorque');
	END_IF

	IF EDGEPOS(gBelt.Al.xBeltMotorTemp) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.BeltBeltMotorTemp');
	ELSIF EDGENEG(gBelt.Al.xBeltMotorTemp) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.BeltBeltMotorTemp');
	END_IF

	IF EDGEPOS(gBelt.Al.xBeltDriverTemp) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.BeltBeltDriverTemp');
	ELSIF EDGENEG(gBelt.Al.xBeltDriverTemp) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.BeltBeltDriverTemp');
	END_IF

	IF EDGEPOS(gBelt.Al.xAxisLengthNotDefined) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.BeltNoPerimeter');
	ELSIF EDGENEG(gBelt.Al.xAxisLengthNotDefined) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.BeltNoPerimeter');
	END_IF

	IF EDGEPOS(gBelt.Al.xGearBoxNotDefined) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.BeltNoGearBox');
	ELSIF EDGENEG(gBelt.Al.xGearBoxNotDefined) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.BeltNoGearBox');
	END_IF

	IF EDGEPOS(gBelt.Al.xWrnOverTorq) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.xWarningOvertoque');
	ELSIF EDGENEG(gBelt.Al.xWrnOverTorq) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.xWarningOvertoque');
	END_IF

	IF EDGEPOS(gSimpleBlock[1].Al.xAlrBarMtrNoRef) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.SblockNotReferenced');
	ELSIF EDGENEG(gSimpleBlock[1].Al.xAlrBarMtrNoRef) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.SblockNotReferenced');
	END_IF

	IF EDGEPOS(gSimpleBlock[1].Al.xAlrComBarMtr) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.SblockNotCommsDrive');
	ELSIF EDGENEG(gSimpleBlock[1].Al.xAlrComBarMtr) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.SblockNotCommsDrive');
	END_IF

	IF EDGEPOS(gSimpleBlock[1].Al.xAlrDriveProtection) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.SblockDriveBreaker');
	ELSIF EDGENEG(gSimpleBlock[1].Al.xAlrDriveProtection) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.SblockDriveBreaker');
	END_IF

	IF EDGEPOS(gSimpleBlock[1].Al.xAlrReferenceIncoherence) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.SblockHomeSensorError');
	ELSIF EDGENEG(gSimpleBlock[1].Al.xAlrReferenceIncoherence) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.SblockHomeSensorError');
	END_IF

	IF EDGEPOS(gSimpleBlock[1].Al.xAlrCheckHomingSensor) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.SblockCheckHomeSensor');
	ELSIF EDGENEG(gSimpleBlock[1].Al.xAlrCheckHomingSensor) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.SblockCheckHomeSensor');
	END_IF

	IF EDGEPOS(gSimpleBlock[1].Al.xBarMotorTemp) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.SblockMotorTemp');
	ELSIF EDGENEG(gSimpleBlock[1].Al.xBarMotorTemp) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.SblockMotorTemp');
	END_IF

	IF EDGEPOS(gSimpleBlock[1].Al.xBarDriverTemp) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.SblockDriveTemp');
	ELSIF EDGENEG(gSimpleBlock[1].Al.xBarDriverTemp) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.SblockDriveTemp');
	END_IF

	IF EDGEPOS(gTransVacuum[1].Alarms.xAlrVacuumSensor) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.VaccSensor');
	ELSIF EDGENEG(gTransVacuum[1].Alarms.xAlrVacuumSensor) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.VaccSensor');
	END_IF

	IF EDGEPOS(gTransVacuum[1].Alarms.xAlrCommsBlower[1]) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.VaccBlowerComsInput');
	ELSIF EDGENEG(gTransVacuum[1].Alarms.xAlrCommsBlower[1]) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.VaccBlowerComsInput');
	END_IF

	IF EDGEPOS(gTransVacuum[1].Alarms.xAlrCommsBlower[2]) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.VaccBlowerComsOutput');
	ELSIF EDGENEG(gTransVacuum[1].Alarms.xAlrCommsBlower[2]) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.VaccBlowerComsOutput');
	END_IF

	IF EDGEPOS(gTransVacuum[1].Alarms.xAlrBlowerCB[1]) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.VaccBlowerProtInput');
	ELSIF EDGENEG(gTransVacuum[1].Alarms.xAlrBlowerCB[1]) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.VaccBlowerProtInput');
	END_IF

	IF EDGEPOS(gTransVacuum[1].Alarms.xAlrBlowerCB[2]) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.VaccBlowerProtOutput');
	ELSIF EDGENEG(gTransVacuum[1].Alarms.xAlrBlowerCB[2]) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.VaccBlowerProtOutput');
	END_IF

	IF EDGEPOS(gTransVacuum[1].Alarms.xAlrBlowerError[1]) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.VaccBlowerErrorInput');
	ELSIF EDGENEG(gTransVacuum[1].Alarms.xAlrBlowerError[1]) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.VaccBlowerErrorInput');
	END_IF

	IF EDGEPOS(gTransVacuum[1].Alarms.xAlrBlowerError[2]) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.VaccBlowerErrorOutput');
	ELSIF EDGENEG(gTransVacuum[1].Alarms.xAlrBlowerError[2]) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.VaccBlowerErrorOutput');
	END_IF

	IF EDGEPOS(gTransVacuum[1].Alarms.xAlrBlowerNotRunning[1]) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.VaccBlowerNotRunningInput');
	ELSIF EDGENEG(gTransVacuum[1].Alarms.xAlrBlowerNotRunning[1]) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.VaccBlowerNotRunningInput');
	END_IF

	IF EDGEPOS(gTransVacuum[1].Alarms.xAlrBlowerNotRunning[2]) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.VaccBlowerNotRunningOutput');
	ELSIF EDGENEG(gTransVacuum[1].Alarms.xAlrBlowerNotRunning[2]) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.VaccBlowerNotRunningOutput');
	END_IF

	IF EDGEPOS(gNirAdphos.Alarms.xSafetyError) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.NIRSafetyError');
	ELSIF EDGENEG(gNirAdphos.Alarms.xSafetyError) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.NIRSafetyError');
	END_IF

	IF EDGEPOS(gNirAdphos.Alarms.xFault) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.NIRFault');
	ELSIF EDGENEG(gNirAdphos.Alarms.xFault) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.NIRFault');
	END_IF

	IF EDGEPOS(gNirAdphos.Alarms.xCommsError) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.NIRComsError');
	ELSIF EDGENEG(gNirAdphos.Alarms.xCommsError) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.NIRComsError');
	END_IF

	IF EDGEPOS(gNirAdphos.Alarms.xInletHumiditySensorError) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.NIRInletHumiditySensError');
	ELSIF EDGENEG(gNirAdphos.Alarms.xInletHumiditySensorError) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.NIRInletHumiditySensError');
	END_IF

	IF EDGEPOS(gNirAdphos.Alarms.xInletTempSensorError) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.NIRInletTempSensError');
	ELSIF EDGENEG(gNirAdphos.Alarms.xInletTempSensorError) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.NIRInletTempSensError');
	END_IF

	IF EDGEPOS(gJamDetect[1].Alarms.xAlrJamCrash[1]) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.JamInputNIR1');
	ELSIF EDGENEG(gJamDetect[1].Alarms.xAlrJamCrash[1]) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.JamInputNIR1');
	END_IF

	IF EDGEPOS(gJamDetect[1].Alarms.xAlrJamCrash[2]) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.JamOutputNIR1');
	ELSIF EDGENEG(gJamDetect[1].Alarms.xAlrJamCrash[2]) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.JamOutputNIR1');
	END_IF

	IF EDGEPOS(gJamDetect[1].Alarms.xAlrJamCrash[3]) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.JamInputNIR2');
	ELSIF EDGENEG(gJamDetect[1].Alarms.xAlrJamCrash[3]) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.JamInputNIR2');
	END_IF

	IF EDGEPOS(gJamDetect[1].Alarms.xAlrJamCrash[4]) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.JamOutputNIR2');
	ELSIF EDGENEG(gJamDetect[1].Alarms.xAlrJamCrash[4]) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.JamOutputNIR2');
	END_IF

	IF EDGEPOS(gNirAdphos.Alarms.Jam[1].xRear) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.JamRearNIR1');
	ELSIF EDGENEG(gNirAdphos.Alarms.Jam[1].xRear) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.JamRearNIR1');
	END_IF

	IF EDGEPOS(gNirAdphos.Alarms.Jam[2].xRear) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.JamRearNIR2');
	ELSIF EDGENEG(gNirAdphos.Alarms.Jam[2].xRear) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.JamRearNIR2');
	END_IF

	IF EDGEPOS(gNirAdphos.Alarms.Jam[1].xMechCross) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.JamMechCrossNIR1');
	ELSIF EDGENEG(gNirAdphos.Alarms.Jam[1].xMechCross) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.JamMechCrossNIR1');
	END_IF

	IF EDGEPOS(gNirAdphos.Alarms.Jam[2].xMechCross) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.JamMechCrossNIR2');
	ELSIF EDGENEG(gNirAdphos.Alarms.Jam[2].xMechCross) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.JamMechCrossNIR2');
	END_IF

	IF EDGEPOS(gNirAdphos.Alarms.xMaxSurfaceTempModule[1]) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.NIRSurfaceTemp1');
	ELSIF EDGENEG(gNirAdphos.Alarms.xMaxSurfaceTempModule[1]) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.NIRSurfaceTemp1');
	END_IF

	IF EDGEPOS(gNirAdphos.Alarms.xMaxSurfaceTempModule[2]) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.NIRSurfaceTemp2');
	ELSIF EDGENEG(gNirAdphos.Alarms.xMaxSurfaceTempModule[2]) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.NIRSurfaceTemp2');
	END_IF

	IF EDGEPOS(gNirAdphos.Alarms.xSurfaceTempModuleSensorError[1]) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.NIRSurfaceTempSensErr1');
	ELSIF EDGENEG(gNirAdphos.Alarms.xSurfaceTempModuleSensorError[1]) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.NIRSurfaceTempSensErr1');
	END_IF

	IF EDGEPOS(gNirAdphos.Alarms.xSurfaceTempModuleSensorError[2]) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.NIRSurfaceTempSensErr2');
	ELSIF EDGENEG(gNirAdphos.Alarms.xSurfaceTempModuleSensorError[2]) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.NIRSurfaceTempSensErr2');
	END_IF

	IF EDGEPOS(gNirAdphos.Alarms.BlockedFansModule[1].Fan[1]) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.BlockedFan1Nir1');
	ELSIF EDGENEG(gNirAdphos.Alarms.BlockedFansModule[1].Fan[1]) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.BlockedFan1Nir1');
	END_IF

	IF EDGEPOS(gNirAdphos.Alarms.BlockedFansModule[1].Fan[2]) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.BlockedFan2Nir1');
	ELSIF EDGENEG(gNirAdphos.Alarms.BlockedFansModule[1].Fan[2]) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.BlockedFan2Nir1');
	END_IF

	IF EDGEPOS(gNirAdphos.Alarms.BlockedFansModule[1].Fan[3]) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.BlockedFan3Nir1');
	ELSIF EDGENEG(gNirAdphos.Alarms.BlockedFansModule[1].Fan[3]) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.BlockedFan3Nir1');
	END_IF

	IF EDGEPOS(gNirAdphos.Alarms.BlockedFansModule[1].Fan[4]) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.BlockedFan4Nir1');
	ELSIF EDGENEG(gNirAdphos.Alarms.BlockedFansModule[1].Fan[4]) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.BlockedFan4Nir1');
	END_IF

	IF EDGEPOS(gNirAdphos.Alarms.BlockedFansModule[2].Fan[2]) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.BlockedFan1Nir2');
	ELSIF EDGENEG(gNirAdphos.Alarms.BlockedFansModule[2].Fan[2]) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.BlockedFan1Nir2');
	END_IF

	IF EDGEPOS(gNirAdphos.Alarms.BlockedFansModule[2].Fan[2]) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.BlockedFan2Nir2');
	ELSIF EDGENEG(gNirAdphos.Alarms.BlockedFansModule[2].Fan[2]) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.BlockedFan2Nir2');
	END_IF

	IF EDGEPOS(gNirAdphos.Alarms.BlockedFansModule[2].Fan[3]) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.BlockedFan3Nir2');
	ELSIF EDGENEG(gNirAdphos.Alarms.BlockedFansModule[2].Fan[3]) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.BlockedFan3Nir2');
	END_IF

	IF EDGEPOS(gNirAdphos.Alarms.BlockedFansModule[2].Fan[4]) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.BlockedFan4Nir2');
	ELSIF EDGENEG(gNirAdphos.Alarms.BlockedFansModule[2].Fan[4]) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.BlockedFan4Nir2');
	END_IF

	IF EDGEPOS(gArcLampGew.Alarms.xCommsError) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.ArcLampComsError');
	ELSIF EDGENEG(gArcLampGew.Alarms.xCommsError) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.ArcLampComsError');
	END_IF

	IF EDGEPOS(gArcLampGew.Alarms.Comms.xCredentialsError) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.ArcLampCredentialsError');
	ELSIF EDGENEG(gArcLampGew.Alarms.Comms.xCredentialsError) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.ArcLampCredentialsError');
	END_IF

	IF EDGEPOS(gArcLampGew.Alarms.Comms.xServerError) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.ArcLampInternalError');
	ELSIF EDGENEG(gArcLampGew.Alarms.Comms.xServerError) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.ArcLampInternalError');
	END_IF

	IF EDGEPOS(gArcLampGew.Alarms.xJam) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.ArcLampJam');
	ELSIF EDGENEG(gArcLampGew.Alarms.xJam) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.ArcLampJam');
	END_IF

	IF EDGEPOS(gArcLampGew.Status.Lamps[1].InAlarm) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.ArcLampAlarmLamp1');
	ELSIF EDGENEG(gArcLampGew.Status.Lamps[1].InAlarm) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.ArcLampAlarmLamp1');
	END_IF

	IF EDGEPOS(gArcLampGew.Status.Lamps[2].InAlarm) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.ArcLampAlarmLamp2');
	ELSIF EDGENEG(gArcLampGew.Status.Lamps[2].InAlarm) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.ArcLampAlarmLamp2');
	END_IF

	IF EDGEPOS(gThicknessCtrl.Alarms.CheckMedia[1]) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.CheckMediaExit1');
	ELSIF EDGENEG(gThicknessCtrl.Alarms.CheckMedia[1]) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.CheckMediaExit1');
	END_IF

	IF EDGEPOS(gThicknessCtrl.Alarms.CheckMedia[2]) THEN
		MpAlarmXSet(gAlrCore, 'Dryer.Alarm.CheckMediaExit2');
	ELSIF EDGENEG(gThicknessCtrl.Alarms.CheckMedia[2]) THEN
		MpAlarmXReset(gAlrCore, 'Dryer.Alarm.CheckMediaExit2');
	END_IF

END_ACTION
