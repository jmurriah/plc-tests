ACTION Alarms:

	IF EDGEPOS(gInks[1].Al.xAlrTankDigitalSensorsError) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.DigSensError_B01');
	ELSIF EDGENEG(gInks[1].Al.xAlrTankDigitalSensorsError) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.DigSensError_B01');
	END_IF

	IF EDGEPOS(gInks[1].Al.xAlrVacuum1) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.xAlrVacuum1_B01');
	ELSIF EDGENEG(gInks[1].Al.xAlrVacuum1) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.xAlrVacuum1_B01');
	END_IF

	IF EDGEPOS(gInks[1].Al.xAlrVacuum2) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.xAlrVacuum2_B01');
	ELSIF EDGENEG(gInks[1].Al.xAlrVacuum2) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.xAlrVacuum2_B01');
	END_IF

	IF EDGEPOS(gInks[1].Al.xAlrVacuumSensor1) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrVacuumSensor1_B01');
	ELSIF EDGENEG(gInks[1].Al.xAlrVacuumSensor1) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrVacuumSensor1_B01');
	END_IF

	IF EDGEPOS(gInks[1].Al.xAlrVacuumSensor2) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrVacuumSensor2_B01');
	ELSIF EDGENEG(gInks[1].Al.xAlrVacuumSensor2) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrVacuumSensor2_B01');
	END_IF

	IF EDGEPOS(gInks[1].Al.xAlrDiffVacuum) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrDiffVacuum_B01');
	ELSIF EDGENEG(gInks[1].Al.xAlrDiffVacuum) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrDiffVacuum_B01');
	END_IF

	IF EDGEPOS(gInks[1].Al.xAlrIncoherTempHeat) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrIncoherTempHeat_B01');
	ELSIF EDGENEG(gInks[1].Al.xAlrIncoherTempHeat) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrIncoherTempHeat_B01');
	END_IF

	IF EDGEPOS(gInks[1].Al.xAlrHeaterReachsMaxTemp) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrHeaterReachsMaxTemp_B01');
	ELSIF EDGENEG(gInks[1].Al.xAlrHeaterReachsMaxTemp) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrHeaterReachsMaxTemp_B01');
	END_IF

	IF EDGEPOS(gInks[1].Al.xAlrTempSensor) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrTempSensor_B01');
	ELSIF EDGENEG(gInks[1].Al.xAlrTempSensor) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrTempSensor_B01');
	END_IF

	IF EDGEPOS(gInks[1].Al.xAlrDiffInCtrlTemp) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrDiffInCtrlTemp_B01');
	ELSIF EDGENEG(gInks[1].Al.xAlrDiffInCtrlTemp) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrDiffInCtrlTemp_B01');
	END_IF

	IF EDGEPOS(gInks[1].Al.xAlrDifCtrlTempExcessive) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrDifCtrlTempExcessive_B01');
	ELSIF EDGENEG(gInks[1].Al.xAlrDifCtrlTempExcessive) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrDifCtrlTempExcessive_B01');
	END_IF

	IF EDGEPOS(gInks[1].Al.xAlrHeaterOutFault) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrHeaterOutFault_B01');
	ELSIF EDGENEG(gInks[1].Al.xAlrHeaterOutFault) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrHeaterOutFault_B01');
	END_IF

	IF EDGEPOS(gInks[1].Al.xAlrOverPressure) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrOverPressure_B01');
	ELSIF EDGENEG(gInks[1].Al.xAlrOverPressure) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrOverPressure_B01');
	END_IF

	IF EDGEPOS(gInks[1].Al.xAlrStopRecircNoInk) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrStopRecircNoInk_B01');
	ELSIF EDGENEG(gInks[1].Al.xAlrStopRecircNoInk) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrStopRecircNoInk_B01');
	END_IF

	IF EDGEPOS(gInks[1].Al.xAlrBrokenMeniscus) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrBrokenMeniscus_B01');
	ELSIF EDGENEG(gInks[1].Al.xAlrBrokenMeniscus) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrBrokenMeniscus_B01');
	END_IF

	IF EDGEPOS(gInks[1].Al.xAlrLevelSensorError) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrLevelSensorError_B01');
	ELSIF EDGENEG(gInks[1].Al.xAlrLevelSensorError) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrLevelSensorError_B01');
	END_IF

	IF EDGEPOS(gInks[1].Al.xAlrTankEmpty) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrTankEmpty_B01');
	ELSIF EDGENEG(gInks[1].Al.xAlrTankEmpty) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrTankEmpty_B01');
	END_IF

	IF EDGEPOS(gInks[1].Al.xAlrTankToFillIn) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrTankToFillIn_B01');
	ELSIF EDGENEG(gInks[1].Al.xAlrTankToFillIn) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrTankToFillIn_B01');
	END_IF

	IF EDGEPOS(gInks[1].Al.xAlrPumpsDCError) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrPumpsDCError_B01');
	ELSIF EDGENEG(gInks[1].Al.xAlrPumpsDCError) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrPumpsDCError_B01');
	END_IF

	IF EDGEPOS(gInks[1].Al.xAlrKlixonTriggered) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrKlixonTriggered_B01');
	ELSIF EDGENEG(gInks[1].Al.xAlrKlixonTriggered) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrKlixonTriggered_B01');
	END_IF

	IF EDGEPOS(gInks[1].Al.xAlrPrintHeadPsuFailure) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrPrintHeadPsuFailure_B01');
	ELSIF EDGENEG(gInks[1].Al.xAlrPrintHeadPsuFailure) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrPrintHeadPsuFailure_B01');
	END_IF

	IF EDGEPOS(gInks[2].Al.xAlrTankDigitalSensorsError) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.DigSensError_B02');
	ELSIF EDGENEG(gInks[2].Al.xAlrTankDigitalSensorsError) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.DigSensError_B02');
	END_IF

	IF EDGEPOS(gInks[2].Al.xAlrVacuum1) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.xAlrVacuum1_B02');
	ELSIF EDGENEG(gInks[2].Al.xAlrVacuum1) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.xAlrVacuum1_B02');
	END_IF

	IF EDGEPOS(gInks[2].Al.xAlrVacuum2) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.xAlrVacuum2_B02');
	ELSIF EDGENEG(gInks[2].Al.xAlrVacuum2) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.xAlrVacuum2_B02');
	END_IF

	IF EDGEPOS(gInks[2].Al.xAlrVacuumSensor1) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrVacuumSensor1_B02');
	ELSIF EDGENEG(gInks[2].Al.xAlrVacuumSensor1) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrVacuumSensor1_B02');
	END_IF

	IF EDGEPOS(gInks[2].Al.xAlrVacuumSensor2) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrVacuumSensor2_B02');
	ELSIF EDGENEG(gInks[2].Al.xAlrVacuumSensor2) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrVacuumSensor2_B02');
	END_IF

	IF EDGEPOS(gInks[2].Al.xAlrDiffVacuum) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrDiffVacuum_B02');
	ELSIF EDGENEG(gInks[2].Al.xAlrDiffVacuum) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrDiffVacuum_B02');
	END_IF

	IF EDGEPOS(gInks[2].Al.xAlrIncoherTempHeat) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrIncoherTempHeat_B02');
	ELSIF EDGENEG(gInks[2].Al.xAlrIncoherTempHeat) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrIncoherTempHeat_B02');
	END_IF

	IF EDGEPOS(gInks[2].Al.xAlrHeaterReachsMaxTemp) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrHeaterReachsMaxTemp_B02');
	ELSIF EDGENEG(gInks[2].Al.xAlrHeaterReachsMaxTemp) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrHeaterReachsMaxTemp_B02');
	END_IF

	IF EDGEPOS(gInks[2].Al.xAlrTempSensor) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrTempSensor_B02');
	ELSIF EDGENEG(gInks[2].Al.xAlrTempSensor) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrTempSensor_B02');
	END_IF

	IF EDGEPOS(gInks[2].Al.xAlrDiffInCtrlTemp) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrDiffInCtrlTemp_B02');
	ELSIF EDGENEG(gInks[2].Al.xAlrDiffInCtrlTemp) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrDiffInCtrlTemp_B02');
	END_IF

	IF EDGEPOS(gInks[2].Al.xAlrDifCtrlTempExcessive) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrDifCtrlTempExcessive_B02');
	ELSIF EDGENEG(gInks[2].Al.xAlrDifCtrlTempExcessive) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrDifCtrlTempExcessive_B02');
	END_IF

	IF EDGEPOS(gInks[2].Al.xAlrHeaterOutFault) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrHeaterOutFault_B02');
	ELSIF EDGENEG(gInks[2].Al.xAlrHeaterOutFault) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrHeaterOutFault_B02');
	END_IF

	IF EDGEPOS(gInks[2].Al.xAlrOverPressure) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrOverPressure_B02');
	ELSIF EDGENEG(gInks[2].Al.xAlrOverPressure) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrOverPressure_B02');
	END_IF

	IF EDGEPOS(gInks[2].Al.xAlrStopRecircNoInk) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrStopRecircNoInk_B02');
	ELSIF EDGENEG(gInks[2].Al.xAlrStopRecircNoInk) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrStopRecircNoInk_B02');
	END_IF

	IF EDGEPOS(gInks[2].Al.xAlrBrokenMeniscus) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrBrokenMeniscus_B02');
	ELSIF EDGENEG(gInks[2].Al.xAlrBrokenMeniscus) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrBrokenMeniscus_B02');
	END_IF

	IF EDGEPOS(gInks[2].Al.xAlrLevelSensorError) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrLevelSensorError_B02');
	ELSIF EDGENEG(gInks[2].Al.xAlrLevelSensorError) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrLevelSensorError_B02');
	END_IF

	IF EDGEPOS(gInks[2].Al.xAlrTankEmpty) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrTankEmpty_B02');
	ELSIF EDGENEG(gInks[2].Al.xAlrTankEmpty) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrTankEmpty_B02');
	END_IF

	IF EDGEPOS(gInks[2].Al.xAlrTankToFillIn) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrTankToFillIn_B02');
	ELSIF EDGENEG(gInks[2].Al.xAlrTankToFillIn) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrTankToFillIn_B02');
	END_IF

	IF EDGEPOS(gInks[2].Al.xAlrPumpsDCError) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrPumpsDCError_B02');
	ELSIF EDGENEG(gInks[2].Al.xAlrPumpsDCError) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrPumpsDCError_B02');
	END_IF

	IF EDGEPOS(gInks[2].Al.xAlrKlixonTriggered) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrKlixonTriggered_B02');
	ELSIF EDGENEG(gInks[2].Al.xAlrKlixonTriggered) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrKlixonTriggered_B02');
	END_IF

	IF EDGEPOS(gInks[2].Al.xAlrPrintHeadPsuFailure) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrPrintHeadPsuFailure_B02');
	ELSIF EDGENEG(gInks[2].Al.xAlrPrintHeadPsuFailure) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrPrintHeadPsuFailure_B02');
	END_IF

	IF EDGEPOS(gInks[3].Al.xAlrTankDigitalSensorsError) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.DigSensError_B03');
	ELSIF EDGENEG(gInks[3].Al.xAlrTankDigitalSensorsError) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.DigSensError_B03');
	END_IF

	IF EDGEPOS(gInks[3].Al.xAlrVacuum1) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.xAlrVacuum1_B03');
	ELSIF EDGENEG(gInks[3].Al.xAlrVacuum1) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.xAlrVacuum1_B03');
	END_IF

	IF EDGEPOS(gInks[3].Al.xAlrVacuum2) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.xAlrVacuum2_B03');
	ELSIF EDGENEG(gInks[3].Al.xAlrVacuum2) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.xAlrVacuum2_B03');
	END_IF

	IF EDGEPOS(gInks[3].Al.xAlrVacuumSensor1) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrVacuumSensor1_B03');
	ELSIF EDGENEG(gInks[3].Al.xAlrVacuumSensor1) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrVacuumSensor1_B03');
	END_IF

	IF EDGEPOS(gInks[3].Al.xAlrVacuumSensor2) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrVacuumSensor2_B03');
	ELSIF EDGENEG(gInks[3].Al.xAlrVacuumSensor2) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrVacuumSensor2_B03');
	END_IF

	IF EDGEPOS(gInks[3].Al.xAlrDiffVacuum) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrDiffVacuum_B03');
	ELSIF EDGENEG(gInks[3].Al.xAlrDiffVacuum) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrDiffVacuum_B03');
	END_IF

	IF EDGEPOS(gInks[3].Al.xAlrIncoherTempHeat) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrIncoherTempHeat_B03');
	ELSIF EDGENEG(gInks[3].Al.xAlrIncoherTempHeat) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrIncoherTempHeat_B03');
	END_IF

	IF EDGEPOS(gInks[3].Al.xAlrHeaterReachsMaxTemp) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrHeaterReachsMaxTemp_B03');
	ELSIF EDGENEG(gInks[3].Al.xAlrHeaterReachsMaxTemp) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrHeaterReachsMaxTemp_B03');
	END_IF

	IF EDGEPOS(gInks[3].Al.xAlrTempSensor) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrTempSensor_B03');
	ELSIF EDGENEG(gInks[3].Al.xAlrTempSensor) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrTempSensor_B03');
	END_IF

	IF EDGEPOS(gInks[3].Al.xAlrDiffInCtrlTemp) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrDiffInCtrlTemp_B03');
	ELSIF EDGENEG(gInks[3].Al.xAlrDiffInCtrlTemp) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrDiffInCtrlTemp_B03');
	END_IF

	IF EDGEPOS(gInks[3].Al.xAlrDifCtrlTempExcessive) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrDifCtrlTempExcessive_B03');
	ELSIF EDGENEG(gInks[3].Al.xAlrDifCtrlTempExcessive) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrDifCtrlTempExcessive_B03');
	END_IF

	IF EDGEPOS(gInks[3].Al.xAlrHeaterOutFault) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrHeaterOutFault_B03');
	ELSIF EDGENEG(gInks[3].Al.xAlrHeaterOutFault) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrHeaterOutFault_B03');
	END_IF

	IF EDGEPOS(gInks[3].Al.xAlrOverPressure) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrOverPressure_B03');
	ELSIF EDGENEG(gInks[3].Al.xAlrOverPressure) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrOverPressure_B03');
	END_IF

	IF EDGEPOS(gInks[3].Al.xAlrStopRecircNoInk) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrStopRecircNoInk_B03');
	ELSIF EDGENEG(gInks[3].Al.xAlrStopRecircNoInk) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrStopRecircNoInk_B03');
	END_IF

	IF EDGEPOS(gInks[3].Al.xAlrBrokenMeniscus) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrBrokenMeniscus_B03');
	ELSIF EDGENEG(gInks[3].Al.xAlrBrokenMeniscus) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrBrokenMeniscus_B03');
	END_IF

	IF EDGEPOS(gInks[3].Al.xAlrLevelSensorError) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrLevelSensorError_B03');
	ELSIF EDGENEG(gInks[3].Al.xAlrLevelSensorError) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrLevelSensorError_B03');
	END_IF

	IF EDGEPOS(gInks[3].Al.xAlrTankEmpty) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrTankEmpty_B03');
	ELSIF EDGENEG(gInks[3].Al.xAlrTankEmpty) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrTankEmpty_B03');
	END_IF

	IF EDGEPOS(gInks[3].Al.xAlrTankToFillIn) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrTankToFillIn_B03');
	ELSIF EDGENEG(gInks[3].Al.xAlrTankToFillIn) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrTankToFillIn_B03');
	END_IF

	IF EDGEPOS(gInks[3].Al.xAlrPumpsDCError) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrPumpsDCError_B03');
	ELSIF EDGENEG(gInks[3].Al.xAlrPumpsDCError) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrPumpsDCError_B03');
	END_IF

	IF EDGEPOS(gInks[3].Al.xAlrKlixonTriggered) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrKlixonTriggered_B03');
	ELSIF EDGENEG(gInks[3].Al.xAlrKlixonTriggered) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrKlixonTriggered_B03');
	END_IF

	IF EDGEPOS(gInks[3].Al.xAlrPrintHeadPsuFailure) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrPrintHeadPsuFailure_B03');
	ELSIF EDGENEG(gInks[3].Al.xAlrPrintHeadPsuFailure) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrPrintHeadPsuFailure_B03');
	END_IF

	IF EDGEPOS(gInks[4].Al.xAlrTankDigitalSensorsError) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.DigSensError_B04');
	ELSIF EDGENEG(gInks[4].Al.xAlrTankDigitalSensorsError) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.DigSensError_B04');
	END_IF

	IF EDGEPOS(gInks[4].Al.xAlrVacuum1) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.xAlrVacuum1_B04');
	ELSIF EDGENEG(gInks[4].Al.xAlrVacuum1) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.xAlrVacuum1_B04');
	END_IF

	IF EDGEPOS(gInks[4].Al.xAlrVacuum2) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.xAlrVacuum2_B04');
	ELSIF EDGENEG(gInks[4].Al.xAlrVacuum2) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.xAlrVacuum2_B04');
	END_IF

	IF EDGEPOS(gInks[4].Al.xAlrVacuumSensor1) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrVacuumSensor1_B04');
	ELSIF EDGENEG(gInks[4].Al.xAlrVacuumSensor1) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrVacuumSensor1_B04');
	END_IF

	IF EDGEPOS(gInks[4].Al.xAlrVacuumSensor2) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrVacuumSensor2_B04');
	ELSIF EDGENEG(gInks[4].Al.xAlrVacuumSensor2) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrVacuumSensor2_B04');
	END_IF

	IF EDGEPOS(gInks[4].Al.xAlrDiffVacuum) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrDiffVacuum_B04');
	ELSIF EDGENEG(gInks[4].Al.xAlrDiffVacuum) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrDiffVacuum_B04');
	END_IF

	IF EDGEPOS(gInks[4].Al.xAlrIncoherTempHeat) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrIncoherTempHeat_B04');
	ELSIF EDGENEG(gInks[4].Al.xAlrIncoherTempHeat) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrIncoherTempHeat_B04');
	END_IF

	IF EDGEPOS(gInks[4].Al.xAlrHeaterReachsMaxTemp) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrHeaterReachsMaxTemp_B04');
	ELSIF EDGENEG(gInks[4].Al.xAlrHeaterReachsMaxTemp) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrHeaterReachsMaxTemp_B04');
	END_IF

	IF EDGEPOS(gInks[4].Al.xAlrTempSensor) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrTempSensor_B04');
	ELSIF EDGENEG(gInks[4].Al.xAlrTempSensor) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrTempSensor_B04');
	END_IF

	IF EDGEPOS(gInks[4].Al.xAlrDiffInCtrlTemp) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrDiffInCtrlTemp_B04');
	ELSIF EDGENEG(gInks[4].Al.xAlrDiffInCtrlTemp) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrDiffInCtrlTemp_B04');
	END_IF

	IF EDGEPOS(gInks[4].Al.xAlrDifCtrlTempExcessive) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrDifCtrlTempExcessive_B04');
	ELSIF EDGENEG(gInks[4].Al.xAlrDifCtrlTempExcessive) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrDifCtrlTempExcessive_B04');
	END_IF

	IF EDGEPOS(gInks[4].Al.xAlrHeaterOutFault) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrHeaterOutFault_B04');
	ELSIF EDGENEG(gInks[4].Al.xAlrHeaterOutFault) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrHeaterOutFault_B04');
	END_IF

	IF EDGEPOS(gInks[4].Al.xAlrOverPressure) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrOverPressure_B04');
	ELSIF EDGENEG(gInks[4].Al.xAlrOverPressure) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrOverPressure_B04');
	END_IF

	IF EDGEPOS(gInks[4].Al.xAlrStopRecircNoInk) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrStopRecircNoInk_B04');
	ELSIF EDGENEG(gInks[4].Al.xAlrStopRecircNoInk) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrStopRecircNoInk_B04');
	END_IF

	IF EDGEPOS(gInks[4].Al.xAlrBrokenMeniscus) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrBrokenMeniscus_B04');
	ELSIF EDGENEG(gInks[4].Al.xAlrBrokenMeniscus) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrBrokenMeniscus_B04');
	END_IF

	IF EDGEPOS(gInks[4].Al.xAlrLevelSensorError) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrLevelSensorError_B04');
	ELSIF EDGENEG(gInks[4].Al.xAlrLevelSensorError) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrLevelSensorError_B04');
	END_IF

	IF EDGEPOS(gInks[4].Al.xAlrTankEmpty) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrTankEmpty_B04');
	ELSIF EDGENEG(gInks[4].Al.xAlrTankEmpty) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrTankEmpty_B04');
	END_IF

	IF EDGEPOS(gInks[4].Al.xAlrTankToFillIn) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrTankToFillIn_B04');
	ELSIF EDGENEG(gInks[4].Al.xAlrTankToFillIn) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrTankToFillIn_B04');
	END_IF

	IF EDGEPOS(gInks[4].Al.xAlrPumpsDCError) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrPumpsDCError_B04');
	ELSIF EDGENEG(gInks[4].Al.xAlrPumpsDCError) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrPumpsDCError_B04');
	END_IF

	IF EDGEPOS(gInks[4].Al.xAlrKlixonTriggered) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrKlixonTriggered_B04');
	ELSIF EDGENEG(gInks[4].Al.xAlrKlixonTriggered) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrKlixonTriggered_B04');
	END_IF

	IF EDGEPOS(gInks[4].Al.xAlrPrintHeadPsuFailure) THEN
		MpAlarmXSet(gAlrCore, 'Inks.Alarm.inks.Al.xAlrPrintHeadPsuFailure_B04');
	ELSIF EDGENEG(gInks[4].Al.xAlrPrintHeadPsuFailure) THEN
		MpAlarmXReset(gAlrCore, 'Inks.Alarm.inks.Al.xAlrPrintHeadPsuFailure_B04');
	END_IF

END_ACTION
