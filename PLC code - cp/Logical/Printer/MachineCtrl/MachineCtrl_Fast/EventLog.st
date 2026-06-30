
ACTION LogCriticalAlarm:

//	iReasonCritical.0 := gMachine.AlSummary.xAlrSafetySystemGeneral;
//	iReasonCritical.1 := gMachine.Al.Alarm.xAlarmSAIPowerOff;
//	iReasonCritical.2 := gBelt.AlSummary.xAlarmCritical;
//	iReasonCritical.3 := gBlock[1].AlSummary.xAlarmCritical;
//	iReasonCritical.4 := gBlock[2].AlSummary.xAlarmCritical;
//	iReasonCritical.5 := gMachine.Al.Alarm.xAlrWrongPhysConf;	

	stEventLogCritical.Source := ELOG_TYPE_GENERAL;
	stEventLogCritical.Severity:= ELOG_SEVERITY_ERROR;
	stEventLogCritical.Facility:= 0;
	stEventLogCritical.ErrorCode:=0;
	
	stEventLogCritical.Text := 'Gen.LogCriticalAlarm';
	
	IF 		iReasonCritical.0 THEN stEventLogCritical.Text := 'Gen Critical. xAlrSafetySystemGeneral';
	ELSIF 	iReasonCritical.1 THEN stEventLogCritical.Text := 'Gen Critical. xAlarmSAIPowerOff';
	ELSIF 	iReasonCritical.2 THEN stEventLogCritical.Text := 'Gen Critical. Belt Crical Alarm';
	ELSIF 	iReasonCritical.3 THEN stEventLogCritical.Text := 'Gen Critical. Block 1 Critical Alarm';
	ELSIF 	iReasonCritical.4 THEN stEventLogCritical.Text := 'Gen Critical. Block 2 Critical Alarm';
	ELSIF 	iReasonCritical.5 THEN stEventLogCritical.Text := 'Gen Critical. xAlrWrongPhysConf';
	ELSIF 	iReasonCritical.6 THEN stEventLogCritical.Text := 'Gen Critical. Machine no powered';
	END_IF
		
	gEventLogLoader(EventData := ADR(stEventLogCritical));
	
END_ACTION


ACTION LogStopAlarm:

//	//Alarms stop//

//	//General 1
	stEventLog.Source := ELOG_TYPE_GENERAL;
	stEventLog.Severity:= ELOG_SEVERITY_ERROR;
	stEventLog.Facility:= 0;
	stEventLog.ErrorCode:=0;
	
	stEventLog.Text := 'Gen.LogStopAlarm';
	
	IF 		iReasonStopGen.0 THEN stEventLog.Text := 'Gen Stop. xAlarmAir1';
	ELSIF 	iReasonStopGen.1 THEN stEventLog.Text := 'Gen Stop. xAlarmComPcPLC';
	ELSIF 	iReasonStopGen.2 THEN stEventLog.Text := 'Gen Stop. xAlarmEnableWithoutBarsOn';
	ELSIF 	iReasonStopGen.3 THEN stEventLog.Text := 'Gen Stop. xAlarmMountedPiece';
	ELSIF 	iReasonStopGen.4 THEN stEventLog.Text := 'Gen Stop. xAlarmSAIPowerFault';
	ELSIF 	iReasonStopGen.5 THEN stEventLog.Text := 'Gen Stop. xAlrSafetySystemEStop';
	ELSIF 	iReasonStopGen.6 THEN stEventLog.Text := 'Gen Stop. xAlrThicknSystemNotSelected';
	ELSIF 	iReasonStopGen.7 THEN stEventLog.Text := 'Gen Stop. BK1 xAlarmStop';
	ELSIF 	iReasonStopGen.8 THEN stEventLog.Text := 'Gen Stop. BK2 xAlarmStop';
	ELSIF 	iReasonStopGen.9 THEN stEventLog.Text := 'Gen Stop. Belt xAlarmStop';
	ELSIF 	iReasonStopGen.10 THEN stEventLog.Text := 'Gen Stop. Ding xAlarmStop';
	ELSIF 	iReasonStopGen.11 THEN stEventLog.Text := 'Gen Stop. Photocell xAlarmStop';
	ELSIF 	iReasonStopGen.12 THEN stEventLog.Text := 'Gen Stop. TrVac1 xAlarmStop';
	ELSIF 	iReasonStopGen.13 THEN stEventLog.Text := 'Gen Stop. TrVac2 xAlarmStop';
	ELSIF 	iReasonStopGen.14 THEN stEventLog.Text := 'Gen Stop. xPDBrokenSensorL1';
	ELSIF 	iReasonStopGen.15 THEN stEventLog.Text := 'Gen Stop. xPDBrokenSensorL2';
	ELSIF 	iReasonStopGen.16 THEN stEventLog.Text := 'Gen Stop. Jam1 xAlarmStop';
	ELSIF 	iReasonStopGen.17 THEN stEventLog.Text := 'Gen Stop. Jam2 xAlarmStop';
	ELSIF 	iReasonStopGen.18 THEN stEventLog.Text := 'Gen Stop. NC1 xAlarmStop';
	ELSIF 	iReasonStopGen.19 THEN stEventLog.Text := 'Gen Stop. NC2 xAlarmStop';
	ELSIF 	iReasonStopGen.20 THEN stEventLog.Text := 'Gen Stop. xAlr24Vdc';
	ELSIF 	iReasonStopGen.21 THEN stEventLog.Text := 'Gen Stop. Led1 xAlarmStop';
	ELSIF 	iReasonStopGen.22 THEN stEventLog.Text := 'Gen Stop. Led2 xAlarmStop';
	ELSIF 	iReasonStopGen.23 THEN stEventLog.Text := 'Gen Stop. xAlrDingWrongPosition';
	ELSIF 	iReasonStopGen.24 THEN stEventLog.Text := 'Gen Stop. xSwCriticalCondition';
	ELSIF	iReasonStopGen.25 THEN stEventLog.Text := 'Gen Stop. Jam3 xAlarmStop';
	ELSIF	iReasonStopGen.26 THEN stEventLog.Text := 'Gen Stop. xNotLoadedImage;';
	ELSIF	iReasonStopGen.27 THEN stEventLog.Text := 'Gen Stop. CheckMedia. Possible jam';
	ELSIF	iReasonStopGen.28 THEN stEventLog.Text := 'Gen Stop. Media thickness out of limits';
	ELSIF	iReasonStopGen.29 THEN stEventLog.Text := 'Gen Stop. Media length out of limits';
	ELSIF 	iReasonStopGen.30 THEN stEventLog.Text := 'Gen Stop. Media width out of limits';
	ELSIF 	iReasonStopInks > 0 THEN stEventLog.Text := 'Gen Stop. Inks Alarm';
	END_IF
		
	gEventLogLoader(EventData := ADR(stEventLog));
	
END_ACTION


ACTION LogOutOfAuto:

//	iReasonOut.0 := gMachine.In.Buttons.xZero;
//	iReasonOut.1 := NOT gMachine.In.Buttons.xAuto AND NOT gMachine.In.Buttons.xManual; // It avoids manual state when safety is NOT ready
//	iReasonOut.2 := gMachine.AlSummary.xAlarmCritical AND (enPrinterState = PRINTERGEN_AUTO) AND NOT gMachine.St.AutoMode.xBypass;
//  iReasonOut.3 := gMachine.AlSummary.xAlrSafetySystemGeneral AND gMachine.St.Mode.xManual; //Going out of Manual just for Safety alarms

	stEventLogState.Source := ELOG_TYPE_GENERAL;
	stEventLogState.Severity:= ELOG_SEVERITY_INFO;
	stEventLogState.Facility:= 0;
	stEventLogState.ErrorCode:=0;
	
	stEventLogState.Text := 'Gen.OutOfMan';
	
	IF 		iReasonOut.0 AND gMachine.St.Mode.xManual THEN
		stEventLogState.Text := 'OutOfMan. Selector to Zero';
	ELSIF 	iReasonOut.0 AND gMachine.St.Mode.xAuto THEN
		stEventLogState.Text := 'OutOfAuto. Selector to Zero';
	ELSIF 	iReasonOut.1 AND gMachine.St.Mode.xManual THEN
		stEventLogState.Text := 'OutOfMan. Selector NOT Manual and NOT Auto';
	ELSIF 	iReasonOut.1 AND gMachine.St.Mode.xAuto THEN
		stEventLogState.Text := 'OutOfAuto. Selector NOT Manual and NOT Auto';
	ELSIF 	iReasonOut.2 THEN
		stEventLogState.Text := 'OutOfAuto. Critical Alarm';
	ELSIF 	iReasonOut.3 THEN
		stEventLogState.Text := 'OutOfMan. xAlrSafetySystemGeneral';
	END_IF
		
	gEventLogLoader(EventData := ADR(stEventLogState));
	
END_ACTION

ACTION LogAutoInProduction:

	stEventLogAutoProduction.Source := ELOG_TYPE_GENERAL;
	stEventLogAutoProduction.Severity:= ELOG_SEVERITY_INFO;
	stEventLogAutoProduction.Facility:= 0;
	stEventLogAutoProduction.ErrorCode:=0;
	
	stEventLogAutoProduction.Text := 'Auto in Production';
		
	gEventLogLoader(EventData := ADR(stEventLogAutoProduction));
	
END_ACTION

ACTION LogAutoInByPass:

	stEventLogAuto.Source := ELOG_TYPE_GENERAL;
	stEventLogAuto.Severity:= ELOG_SEVERITY_INFO;
	stEventLogAuto.Facility:= 0;
	stEventLogAuto.ErrorCode:=0;
	
	stEventLogAuto.Text := 'Auto in ByPass';
		
	gEventLogLoader(EventData := ADR(stEventLogAuto));
	
END_ACTION

ACTION LogAutoInStop:

	stEventLogAutoStop.Source := ELOG_TYPE_GENERAL;
	stEventLogAutoStop.Severity:= ELOG_SEVERITY_INFO;
	stEventLogAutoStop.Facility:= 0;
	stEventLogAutoStop.ErrorCode:=0;
	
	stEventLogAutoStop.Text := 'Gen.LogAutoInStop';
	
	IF iReasonAutoStop.0 THEN stEventLogAutoStop.Text := 'Auto in Stop: Stop signal';
	ELSIF iReasonAutoStop.1 THEN stEventLogAutoStop.Text := 'Auto in Stop: Stop by invalid automode';
	ELSIF iReasonAutoStop.2 THEN stEventLogAutoStop.Text := 'Auto in Stop: Stop without ByPass with any stop alarm';
	ELSIF iReasonAutoStop.3 THEN stEventLogAutoStop.Text := 'Auto in Stop: Stop in ByPass with thicknes sensor alarms';
	ELSIF iReasonAutoStop.4 THEN stEventLogAutoStop.Text := 'Auto in Stop: Stop in ByPass with TRansVacum stop alarm';
	ELSIF iReasonAutoStop.5 THEN stEventLogAutoStop.Text := 'Auto in Stop: Stop in ByPass with non reference vertical motor alarm';
	ELSIF iReasonAutoStop.6 THEN stEventLogAutoStop.Text := 'Auto in Stop: Stop in JamRecovery. Yimeout no action';
	ELSE stEventLogAuto.Text := 'Entgering in Auto in Stop';
	END_IF
		
	gEventLogLoader(EventData := ADR(stEventLogAutoStop));
	
END_ACTION

ACTION LogAutoInJamRecovery:

	stEventLogAutoJamRec.Source := ELOG_TYPE_GENERAL;
	stEventLogAutoJamRec.Severity:= ELOG_SEVERITY_INFO;
	stEventLogAutoJamRec.Facility:= 0;
	stEventLogAutoJamRec.ErrorCode:=0;
	
	stEventLogAutoJamRec.Text := 'Auto in Jam Recovery';
		
	gEventLogLoader(EventData := ADR(stEventLogAutoJamRec));
	
END_ACTION

ACTION LogAutoStart:

	stEventLogStart.Source := ELOG_TYPE_GENERAL;
	stEventLogStart.Severity:= ELOG_SEVERITY_INFO;
	stEventLogStart.Facility:= 0;
	stEventLogStart.ErrorCode:=0;
	
	stEventLogStart.Text := 'Auto Start Order';
		
	gEventLogLoader(EventData := ADR(stEventLogStart));
	
END_ACTION

ACTION LogAutoStop:

	stEventLogStop.Source := ELOG_TYPE_GENERAL;
	stEventLogStop.Severity:= ELOG_SEVERITY_INFO;
	stEventLogStop.Facility:= 0;
	stEventLogStop.ErrorCode:=0;
	
	stEventLogStop.Text := 'Auto Stop Order';
		
	gEventLogLoader(EventData := ADR(stEventLogStop));
	
END_ACTION

ACTION LogPrePrintingPos:

	stEventLogPrePrint.Source := ELOG_TYPE_GENERAL;
	stEventLogPrePrint.Severity:= ELOG_SEVERITY_INFO;
	stEventLogPrePrint.Facility:= 0;
	stEventLogPrePrint.ErrorCode:=0;
	
	IF iReasonForcePreprintingPos = 0 THEN
		stEventLogPrePrint.Text := 'PrePrintPos RESETED';
	ELSE
		stEventLogPrePrint.Text := 'PrePrintPos SET. Reason:';
		// Adding Reasong data to log
		brsitoa(iReasonForcePreprintingPos, ADR(strAuxEventDesc));
		brsstrcat(ADR(stEventLogPrePrint.Text), ADR(strAuxEventDesc));
	END_IF
		
	gEventLogLoader(EventData := ADR(stEventLogPrePrint));
	
END_ACTION