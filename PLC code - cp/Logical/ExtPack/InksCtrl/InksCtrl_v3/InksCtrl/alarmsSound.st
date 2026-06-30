
ACTION alarmsSound: 

	///Auto reset sound management. All alarms need to work with mute option
	ars_1000(xAlarm:=inks.Al.xAlrTankCloseToEmpty,		xSilence:=inks.commands.xMute);
	ars_1001(xAlarm:=inks.Al.xAlrTankEmpty,				xSilence:=inks.commands.xMute);
	ars_1002(xAlarm:=inks.Al.xAlrLevelSensorError,		xSilence:=inks.commands.xMute);
	ars_1003(xAlarm:=inks.Al.xAlrIncoherTempHeat,		xSilence:=inks.commands.xMute);
	ars_1004(xAlarm:=inks.Al.xAlrNoInkNoCleanManif,		xSilence:=inks.commands.xMute);
	ars_1005(xAlarm:=inks.Al.xAlrNoRecircStop,			xSilence:=inks.commands.xMute);
	ars_1006(xAlarm:=inks.Al.xAlrStopRecircNoInk,		xSilence:=inks.commands.xMute);
	ars_1007(xAlarm:=inks.Al.xAlrNoInkNoCleanManif,		xSilence:=inks.commands.xMute);
	ars_1008(xAlarm:=inks.Al.xAlrOverPressure,			xSilence:=inks.commands.xMute);
	//ars_1009(xAlarm:=,			xSilence:=);
	ars_1010(xAlarm:=inks.Al.xAlrVacuumSensor1,			xSilence:=inks.commands.xMute);
	ars_1011(xAlarm:=inks.Al.xAlrVacuumSensor2,			xSilence:=inks.commands.xMute);
	ars_1012(xAlarm:=inks.Al.xAlrTempSensor,			xSilence:=inks.commands.xMute);
	ars_1013(xAlarm:=inks.Al.xAlrPrintHeadPsuFailure,	xSilence:=inks.commands.xMute);
	//ars_1014(xAlarm:=inks.Al.xAlrNoRecirculation,		xSilence:=inks.commands.xMute);
	ars_1015(xAlarm:=inks.Al.xAlrPumpsDCError,			xSilence:=inks.commands.xMute);
	ars_1016(xAlarm:=inks.Al.xAlrBrokenMeniscus,		xSilence:=inks.commands.xMute);
	ars_1017(xAlarm:=inks.Al.xAlrHeaterTankReachsMaxTemp,xSilence:=inks.commands.xMute);
	ars_1018(xAlarm:=inks.Al.xAlrKlixonTriggered,		xSilence:=inks.commands.xMute);
	ars_1019(xAlarm:=inks.Al.xAlrTankToFillIn,			xSilence:=inks.commands.xMute);
	ars_1020(xAlarm:=inks.Al.xAlrVacuum1,				xSilence:=inks.commands.xMute);
	ars_1021(xAlarm:=inks.Al.xAlrVacuum2,				xSilence:=inks.commands.xMute);
	ars_1022(xAlarm:=inks.Al.xAlrTempTankSensor,		xSilence:=inks.commands.xMute);
	ars_1023(xAlarm:=inks.Al.xAlrHeaterReachsMaxTemp,	xSilence:=inks.commands.xMute);
	ars_1024(xAlarm:=inks.Al.xAlrIncoherTempTank,		xSilence:=inks.commands.xMute);
	ars_1025(xAlarm:=inks.Al.xAlrHeaterOutFault,		xSilence:=inks.commands.xMute);
	ars_1026(xAlarm:=inks.Al.xAlrDifCtrlTempExcessive,	xSilence:=inks.commands.xMute);
	ars_1027(xAlarm:=inks.Al.xAlrMaintenanceModeActive,	xSilence:=inks.commands.xMute);
	
		
	//The alarms to make sound due to the Inks
	iReasonToSound.0 := ars_1000.xAlarmSound;
	iReasonToSound.1 := ars_1001.xAlarmSound;
	iReasonToSound.2 := ars_1002.xAlarmSound;
	iReasonToSound.3 := ars_1003.xAlarmSound;
	iReasonToSound.4 := ars_1004.xAlarmSound;
	iReasonToSound.5 := ars_1005.xAlarmSound;
	iReasonToSound.6 := ars_1006.xAlarmSound;
	iReasonToSound.7 := ars_1007.xAlarmSound;
	iReasonToSound.8 := ars_1008.xAlarmSound;
	iReasonToSound.9 := ars_1009.xAlarmSound;
	iReasonToSound.10 := ars_1010.xAlarmSound;
	iReasonToSound.11 := ars_1011.xAlarmSound;
	iReasonToSound.12 := ars_1012.xAlarmSound;
	iReasonToSound.13 := ars_1013.xAlarmSound;
	//iReasonToSound.14 := ars_1014.xAlarmSound;
	iReasonToSound.15 := ars_1015.xAlarmSound;
	iReasonToSound.16 := ars_1016.xAlarmSound;
	iReasonToSound.17 := ars_1017.xAlarmSound;
	iReasonToSound.18 := ars_1018.xAlarmSound;
	iReasonToSound.19 := ars_1019.xAlarmSound;
	iReasonToSound.20 := ars_1020.xAlarmSound;
	iReasonToSound.21 := ars_1021.xAlarmSound;
	iReasonToSound.22 := ars_1022.xAlarmSound;
	iReasonToSound.23 := ars_1023.xAlarmSound;
	iReasonToSound.24 := ars_1024.xAlarmSound;
	iReasonToSound.25 := ars_1025.xAlarmSound;
	iReasonToSound.26 := ars_1026.xAlarmSound;
	iReasonToSound.27 := ars_1027.xAlarmSound;
	
	inks.AlSummary.xAlarmSound:=iReasonToSound > 0;
	
END_ACTION
