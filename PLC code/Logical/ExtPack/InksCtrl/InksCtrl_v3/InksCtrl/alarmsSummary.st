
ACTION alarmsSummary:
	
	//FILL AlarmSummary data
	
	//Inks critical alarm used to stop the ink sistem
	iReasonCritical.0 := inks.Al.xAlrTankEmpty;
	iReasonCritical.1 := inks.Al.xAlrStopRecircNoInk;
	iReasonCritical.2 := inks.Al.xAlrIncoherTempHeat;
	iReasonCritical.3 := inks.Al.xAlrVacuum1;
	iReasonCritical.4 := inks.Al.xAlrVacuum2;
	iReasonCritical.5 := inks.Al.xAlrVacuumSensor1;
	iReasonCritical.6 := inks.Al.xAlrVacuumSensor2;
	iReasonCritical.7 := inks.Al.xAlrTempSensor;
	iReasonCritical.8 := inks.Al.xAlrBrokenMeniscus;
	iReasonCritical.9 := inks.Al.xAlrOverPressure;
	iReasonCritical.10 := inks.Al.xAlrLevelSensorError;
	iReasonCritical.11 := inks.Al.xAlrTankDigitalSensorsError;
	iReasonCritical.12 := inks.Al.xAlrPumpsDCError;
	iReasonCritical.13 := FALSE;
	iReasonCritical.14 := FALSE;
	
	inks.AlSummary.xAlarmCritical :=  iReasonCritical > 0;
	//Register the reason of the Critical Alarm
	IF inks.status.iInkState <> INKS_STOPPED  AND EDGEPOS(inks.AlSummary.xAlarmCritical) THEN
		inks.AlSummary.iReasonCritical := iReasonCritical;
		LogCriticalAlarm;
	ELSIF EDGEPOS(inks.status.iInkState = INKS_STARTED AND NOT inks.AlSummary.xAlarmCritical) THEN
		inks.AlSummary.iReasonCritical := 0;
	END_IF
	
	iReasonWarning.0 := inks.Al.xAlrTankToFillIn;
	iReasonWarning.1 := inks.Al.xAlrDiffInCtrlTempTank;
	iReasonWarning.2 := inks.Al.xAlrDiffInCtrlTemp;
	iReasonWarning.3 := inks.Al.xAlrNoInkNoCleanManif;
	iReasonWarning.4 := inks.Al.xAlrKlixonTriggered;
	iReasonWarning.5 := inks.Al.xAlrTempTankSensor;
	iReasonWarning.6 := inks.Al.xAlrNoRecirculation;
	iReasonWarning.7 := inks.Al.xAlrHeaterReachsMaxTemp;
	iReasonWarning.8 := inks.Al.xAlrIncoherTempTank;
	iReasonWarning.9 := inks.Al.xAlrHeaterTankReachsMaxTemp;
	iReasonWarning.10 := inks.Al.xAlrMaintenanceModeActive;
	iReasonWarning.11 := inks.Al.xHeaterOff; // NOZOMITWO-1410
	iReasonWarning.12 := inks.Al.xAlrDiffVacuum;
	
	
	//Warning alarms (used in sound alarms).	
	inks.AlSummary.xAnyWarning:= iReasonWarning > 0;
											
	// Ink Stop Alarms are used to stop of printing state
	iReasonStop.0 := iReasonCritical > 0;
	iReasonStop.1 := inks.Al.xAlrHeaterOutFault;
	iReasonStop.2 := inks.Al.xAlrPrintHeadPsuFailure;
	iReasonStop.3 := inks.Al.xAlrDifCtrlTempExcessive;
	iReasonStop.4 := EDGENEG(inks.ordersSw.xStartInks) AND NOT (iReasonCritical > 0);
	iReasonStop.5 := inks.parSw.Config.iInkType = 0;
	iReasonStop.6 := inks.parSw.Config.iPrintHeadType = 0;
	iReasonStop.7 := inks.Al.xAlrNoRecircStop;
	iReasonStop.8 := inks.Al.xAlrTankCloseToEmpty;
	iReasonStop.9 := inks.Al.xAlrPrintHeadsChillerStopped;
		
	IF iReasonStop > 0 AND inks.status.xEnabledBarToPrint THEN 
		inks.AlSummary.xAlarmStop:= TRUE;
	ELSIF inks.commands.xErrorRst THEN 
		inks.AlSummary.xAlarmStop:= FALSE;
	END_IF
	
	//Register the reason of the Stop Alarm
	IF inks.status.iInkState <> INKS_STOPPED  AND EDGEPOS(inks.AlSummary.xAlarmStop) THEN
		//Register the reason of the Stop Alarm
		LogStopAlarm;
		inks.AlSummary.iReasonStop[0] := iReasonStop;
	ELSIF EDGEPOS(inks.status.iInkState = INKS_STARTING AND NOT inks.AlSummary.xAlarmStop) THEN
		inks.AlSummary.iReasonStop[0] := 0;
	END_IF
	
	inks.AlSummary.xAnyAlarm:= inks.AlSummary.xAlarmCritical OR inks.AlSummary.xAlarmStop OR inks.AlSummary.xAnyWarning;
	
END_ACTION
