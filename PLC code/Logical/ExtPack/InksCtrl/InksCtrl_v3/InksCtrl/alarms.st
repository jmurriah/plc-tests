
ACTION alarms: 
	//Ink level alarm
	inks.Al.xAlrTankDigitalSensorsError := NOT inks.status.xActTestMode AND NOT inks.status.Tank.xMinLevel AND inks.status.Tank.xMaxLevel;
	
	//Temperature and Vacuum probe alarms
	TON_Reset(IN:= NOT xIAmInReverse AND inks.status.xInksRunning, PT:= T#1S);
	t_reset := TON_Reset.Q;

	//Silvia: added an equal symbol in the comparison, because it's impossible to have more than 150mbar.
	TON_AlrVacuum1.IN	:=	t_reset AND (rPressureCollectorPos1 >= rVacuumSensorMax) AND (inks.signals.out.iDutyCycleNegative<>0);
	TON_AlrVacuum1.PT	:=	T#1S; //T#2S; //SUSTPLATF-266
	TON_AlrVacuum1();
	
	IF TON_AlrVacuum1.Q THEN
		inks.Al.xAlrVacuum1 := TRUE;
	END_IF

	TON_AlrVacuum2.IN	:=	t_reset AND (rPressureCollectorPos2 >= rVacuumSensorMax) AND (inks.signals.out.iDutyCycleFilling<>0);
	TON_AlrVacuum2.PT	:=	T#1S; //T#2S; //SUSTPLATF-266
	TON_AlrVacuum2();
	
	IF TON_AlrVacuum2.Q THEN
		inks.Al.xAlrVacuum2 := TRUE;
	END_IF

	// Alarm Error in Vacuum gauge means that analog input status is lower than -8000
	TON_DelayVacuum1Gauge.IN	:=	inks.signals.in.xVacuum1SensorError;
	TON_DelayVacuum1Gauge.PT	:=	T#2S;
	TON_DelayVacuum1Gauge();
	
	IF TON_DelayVacuum1Gauge.Q THEN
		inks.Al.xAlrVacuumSensor1 := TRUE;
	END_IF

	// Alarm Error in Vacuum gauge means that analog input status is lower than -8000
	TON_DelayVacuum2Gauge.IN	:=	inks.signals.in.xVacuum2SensorError;
	TON_DelayVacuum2Gauge.PT	:=	T#2S;
	TON_DelayVacuum2Gauge();
	
	IF TON_DelayVacuum2Gauge.Q THEN
		inks.Al.xAlrVacuumSensor2 := TRUE;
	END_IF

	TON_AlrVacuumDiff(IN:=t_reset AND ABS(inks.status.rMeniscus-rMeniscusSp) > inks.parSw.NegPump.rLimitMeniscusDiffWarning AND
					NOT inks.Al.xAlrVacuum1 AND	NOT inks.Al.xAlrVacuum2 AND	NOT inks.commands.xErrorRst,
					PT:= T#1S);
	
	TON_AlrVacuumDiff2(	IN:=mode4 AND ABS(inks.status.rMeniscus-rMeniscusSp) < inks.parSw.NegPump.rLimitMeniscusDiffWarning,
						PT:= T#5S);
	
	IF TON_AlrVacuumDiff2.Q OR NOT inks.status.xInksRunning THEN
		inks.Al.xAlrDiffVacuum := FALSE;
	// xOrderOnReverseCapped when is cleaning while 50 secs, from start reverse to be finished
	ELSIF TON_AlrVacuumDiff.Q AND NOT xIgnoreAlarmsInCleaning AND NOT inks.status.Reverse.xOnReverseAuto THEN
		inks.Al.xAlrDiffVacuum := TRUE;
	END_IF

	//Temperature alarms management
	
	//Alarm in the Manifold temperature gauge. (Out of range)
	TON_AlrIncoherTempHeat.IN	:=	t_reset AND ( inks.status.Temp.rTemp < 0.0 OR inks.status.Temp.rTemp > 100.0 );
	TON_AlrIncoherTempHeat.PT	:=	T#2S;
	TON_AlrIncoherTempHeat();
	
	IF TON_AlrIncoherTempHeat.Q THEN
		inks.Al.xAlrIncoherTempHeat := TRUE;
	END_IF
	
	//Alarm in Bar Heater temperature gauge. (Out of range)
	TON_AlrTempHeaterMax.IN	:=	(inks.status.Temp.rTemp > 80.0);
	TON_AlrTempHeaterMax.PT	:=	T#2S;
	TON_AlrTempHeaterMax();
	
	IF TON_AlrTempHeaterMax.Q THEN
		inks.Al.xAlrHeaterReachsMaxTemp := TRUE;
	END_IF
		
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Alarm of temperature gauge broken temperature gauge in collector. Error detected by the plc
	// COLLECTOR
	// Alarm Error in Vacuum gauge means that analog input status is lower than -8000
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	TON_AlrTempGauge.IN	:=	(inks.signals.in.xTempSensorError);
	TON_AlrTempGauge.PT	:=	T#2S;
	TON_AlrTempGauge();
	
	IF TON_AlrTempGauge.Q THEN
		inks.Al.xAlrTempSensor := TRUE;
	END_IF

	alarmsTankHeater;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	// Alarm differential temperature	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	//WARNING
	
	TON_AlrDifTemp.IN := ABS(inks.status.Temp.rTemp - rSPtemp) > MAX_DIFFCTRLTEMP_WRNG;
	TON_AlrDifTemp.PT := T#2S;
	TON_AlrDifTemp();
	
	TON_AlrNotDifTemp.IN :=	ABS(inks.status.Temp.rTemp-rSPtemp) < MAX_DIFFCTRLTEMP_WRNG;
	TON_AlrNotDifTemp.PT :=	T#5S;
	TON_AlrNotDifTemp();
	
	IF NOT inks.status.xInksRunning OR TON_AlrNotDifTemp.Q THEN
		inks.Al.xAlrDiffInCtrlTemp := FALSE;
	ELSIF TON_AlrDifTemp.Q THEN
		inks.Al.xAlrDiffInCtrlTemp := TRUE;
	END_IF
	
	
	//ALARM
		
	IF NOT inks.status.xInksRunning OR NOT inks.status.xEnabledBarToPrint OR TON_AlrNotDifTempExcessiv.Q THEN
		inks.Al.xAlrDifCtrlTempExcessive := FALSE;
	ELSIF TON_AlrDifTempExcessiv.Q THEN
		inks.Al.xAlrDifCtrlTempExcessive := TRUE;
	END_IF
	
	TON_AlrDifTempExcessiv.IN := ABS(inks.status.Temp.rTemp - rSPtemp) > MAX_DIFFCTRLTEMPHIGH_ALR;
	TON_AlrDifTempExcessiv.PT := T#20s;
	TON_AlrDifTempExcessiv();
	
	TON_AlrNotDifTempExcessiv.IN := ABS(inks.status.Temp.rTemp - rSPtemp) < MAX_DIFFCTRLTEMPHIGH_ALR;
	TON_AlrNotDifTempExcessiv.PT := T#20s;
	TON_AlrNotDifTempExcessiv();
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	// Alarm PLC not heating bar	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	tonAlrNotHeating.IN := inks.status.xInksRunning AND NOT mode10 AND
						(rSPtemp - inks.status.Temp.rTemp > MAX_DIFFCTRLTEMP_ALR) AND 
						NOT inks.signals.out.xOutBarResistance;
	tonAlrNotHeating.PT := T#1m;
	tonAlrNotHeating();
	IF tonAlrNotHeating.Q THEN
		IF NOT inks.Al.xAlrHeaterOutFault THEN
			//Added into the IF to avoid a double register while stopping
			LogNotHeating;
		END_IF
		inks.Al.xAlrHeaterOutFault := TRUE;
	END_IF
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	//Overpressure alarm management
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	TON_OverPressureDelay.IN := NOT mode1 AND inks.signals.in.xOverpressure;
	TON_OverPressureDelay.PT := T#100ms;
	TON_OverPressureDelay();
	
	IF TON_OverPressureDelay.Q THEN
		inks.Al.xAlrOverPressure := TRUE;
	END_IF

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	//Stop Recirculation because there is not ink inn tank
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	IF (mode3 OR mode13 OR mode4) AND NOT inks.status.Tank.xMinLevel AND NOT inks.status.xActTestMode THEN
		inks.Al.xAlrStopRecircNoInk:=TRUE;
	ELSIF inks.status.Tank.xMinLevel THEN
		inks.Al.xAlrStopRecircNoInk:=FALSE;
	END_IF	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	// It is defined in controlMode.str_start_inks(CLK:= inks.ordersSw.xStartInks);	
	// RECIRCULATION CANNOT START, INK TANK EMPTY
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	IF NOT inks.status.xActTestMode AND NOT inks.status.Tank.xMinLevel AND r_start_inks.Q THEN
		inks.Al.xAlrInksRunnig:=TRUE; //To review with Jorge, this alarm is not shared in VarsVersion but exists in PLC2Kernel
	END_IF
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Implemented 09/19/2017
	// Here, an alarm No Recirculation in the Bar is reported when is Ink system is stopped with bar installed
	// RECIRCULATION STOPPED / UNSTABLE INK SYSTEM
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	inks.Al.xAlrNoRecirculation :=  NOT inks.status.xInksRunning;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//INK SYSTEM STOPED WITH BAR ENABLE TO PRINT
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	IF NOT inks.status.xInksRunning AND inks.status.xEnabledBarToPrint THEN
		inks.Al.xAlrNoRecircStop := TRUE;
	END_IF
	

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Alarm to indicate that we don't allow to enter in the  manifold cleaning mode if there is no ink.
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	IF NOT inks.status.xActTestMode AND NOT inks.status.Tank.xMinLevel AND EDGEPOS(inks.ordersSw.xStartManual) THEN
		inks.Al.xAlrNoInkNoCleanManif := TRUE;
	END_IF
	
	// rSPfillingPump is POS PRESSURE SP from GUI 
	// rSP_PressurePos_PID current positive pressure sensor
	// rMeniscusSp is Meniscus SP from GUI
	// rSP_Meniscus_PID current meniscus pressure
	xOutOfCriticalRange := 	mode4 AND (rSPfillingPump = rSP_PressurePos_PID) AND (rMeniscusSp = rSP_Meniscus_PID) AND
				( rMeniscusPV > inks.parSw.NegPump.rUpperLimMeniscusCritical  OR  rMeniscusPV < inks.parSw.NegPump.rLowerLimMeniscusCritical ); 
	
	TON_AlrCriticalMeniscus2.IN:=t_reset AND mode4 AND NOT xIgnoreAlarmsInCleaning AND xOutOfCriticalRange;
	TON_AlrCriticalMeniscus2.PT:=T#5S;
	TON_AlrCriticalMeniscus2();
	
	IF TON_AlrCriticalMeniscus2.Q THEN
		inks.Al.xAlrBrokenMeniscus := TRUE;
	END_IF
	
	IF inks.status.xActTestMode THEN
		inks.Al.xAlrLevelSensorError := FALSE;
	ELSIF inks.status.Tank.xMaxLevel AND NOT inks.status.Tank.xMinLevel THEN
		inks.Al.xAlrLevelSensorError := TRUE;
	END_IF

	// It is not a stop alarm just warning					
	inks.Al.xAlrTankToFillIn := NOT inks.status.xActTestMode AND NOT inks.status.Tank.xMaxLevel;

	// It has been improved to avoid zero state in the machine when this alarm is activated. Added condition status is different to mode1
	// 22-10-1017: Changed for commissioning SN1 at Marco Polo: It is alarm stop when inkState is different to INKS_STOPPED	
	inks.Al.xAlrTankEmpty := NOT inks.status.xActTestMode AND NOT mode1 AND NOT inks.status.Tank.xMinLevel;										
										
	// The ink level is close to Empty. Raising an alarm to allow the Machine or the line to stop production without stopping the inkSystem
	inks.Al.xAlrTankCloseToEmpty := NOT inks.status.xActTestMode AND NOT mode1 AND NOT inks.status.Tank.xCloseToMinLevel;										

	TON_TimeAlrDCStarting(IN:=mode3, PT:= T#60S);  //After start, delay 60seconds taking care of this alarm

	xModesAlrDC:=TON_TimeAlrDCStarting.Q OR (mode4 AND NOT xIgnoreAlarmsInCleaning );
	
	TON_AlrDCDiff.IN:= xModesAlrDC AND ABS(inks.status.PosPump.rDutyCycleFilling - inks.status.NegPump.rDutyCycleNegative) > lc_rDiffBetweenPumpsDCLimit;
	TON_AlrDCDiff.PT:= inks.parameters.parBar.iTimeToActiveDcErrorAlarm;
	TON_AlrDCDiff();
	
	TON_AlrNegDiff.IN:= xModesAlrDC AND ( (inks.status.NegPump.rDutyCycleNegative>99) OR (inks.status.NegPump.rDutyCycleNegative < 1 ));
	TON_AlrNegDiff.PT:= inks.parameters.parBar.iTimeToActiveDcErrorAlarm;
	TON_AlrNegDiff();

	TON_AlrPosDiff.IN:= xModesAlrDC AND ( (inks.status.PosPump.rDutyCycleFilling>99) OR (inks.status.PosPump.rDutyCycleFilling < 1 ));
	TON_AlrPosDiff.PT:= inks.parameters.parBar.iTimeToActiveDcErrorAlarm;
	TON_AlrPosDiff();
	
	IF TON_AlrDCDiff.Q OR TON_AlrNegDiff.Q OR TON_AlrPosDiff.Q THEN
		inks.Al.xAlrPumpsDCError := TRUE;
		LogPumpDCError; //Logging the source of the Pump DC Error
	END_IF										
										

	IF inks.signals.in.xKlixonTriggered THEN
		inks.Al.xAlrKlixonTriggered:=TRUE;
	// This ELSE must be reviewed with Dani Moya, added during Cube start up.
	ELSE
		inks.Al.xAlrKlixonTriggered:=FALSE;
	END_IF

	// It allows detection because PsuOk is delayed when is in failure	
	TON_StabPsuOk.IN:=(inks.ordersSw.xPowPrintHead AND inks.signals.out.xOutPowPrintHead AND NOT inks.signals.in.xPrintHeadsPsuOK);
	TON_StabPsuOk.PT:=lc_tiTimeStoppingPsu;
	TON_StabPsuOk();
	
	IF TON_StabPsuOk.Q THEN
		inks.Al.xAlrPrintHeadPsuFailure:=TRUE;	
	END_IF

	
	//DELOREAN-1961: Warning when bar enabled to print and maintenance mode active
	IF inks.status.xActMaintenanceMode AND inks.status.xEnabledBarToPrint THEN
		inks.Al.xAlrMaintenanceModeActive := TRUE;
	END_IF
	
	// NOZOMITWO-1410 Chiller alarms
	TON_AlrHeaterOFF.IN := inks.status.xInksRunning AND inks.parameters.InksChiller.Status=CHILLER_RUNNING AND inks.signals.out.xHeatingActive AND inks.status.Temp.rDutyCycleTemp = 0 AND (inks.parSw.Temp.rSetPointTemp + 1) < inks.status.Temp.rTemp;
	TON_AlrHeaterOFF.PT := T#120s;
	TON_AlrHeaterOFF();
	
	inks.Al.xHeaterOff := TON_AlrHeaterOFF.Q;
	
	
	// NOZOMITWO-1410 Chiller warnings and NOZOMITWO-2353
	TON_AlrChillerPrintheadsOFF.IN := inks.parameters.PrintheadsChiller.iIndex > 0 AND
									inks.parameters.PrintheadsChiller.Status <> CHILLER_RUNNING AND
									inks.parameters.PrintheadsChiller.Status <> CHILLER_STOPPING AND
									inks.signals.out.xOutPowPrintHead;
	TON_AlrChillerPrintheadsOFF.PT := T#30s;
	TON_AlrChillerPrintheadsOFF();
	
	IF TON_AlrChillerPrintheadsOFF.Q THEN
		inks.Al.xAlrPrintHeadsChillerStopped := TRUE;
	END_IF
	
END_ACTION


ACTION alarmsTankHeater: 

	IF NOT inks.parSw.Temp.xTankHeaterEnabled THEN
		inks.Al.xAlrTempTankSensor			:= FALSE;
		inks.Al.xAlrHeaterTankReachsMaxTemp	:= FALSE;
		inks.Al.xAlrDiffInCtrlTempTank		:= FALSE;
		inks.Al.xAlrIncoherTempTank			:= FALSE;
		RETURN;
	END_IF
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Alarm temperature gauge broken in heater or temperature gauge broken HEATER TANK. Error detected by the plc.
	// xTempTankSensorError --> It has not I/O mapping. Pending to define in P4	by EEteam
	//HEATER TANK
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	TON_AlrTempTankTempSensorError.IN	:=	inks.signals.in.xTempTankSensorError;
	TON_AlrTempTankTempSensorError.PT	:=	T#2S;
	TON_AlrTempTankTempSensorError();
	
	// If not installed bar en It is not an alarm
	IF TON_AlrTempTankTempSensorError.Q THEN
		inks.Al.xAlrTempTankSensor := TRUE;
	END_IF
	
	//Alarm in Heater Tank temperature gauge. (Out of range)
	TON_AlrTempTankMax.IN	:=	(inks.status.Temp.rTempTank > 70.0);
	TON_AlrTempTankMax.PT	:=	T#2S;
	TON_AlrTempTankMax();
	
	IF TON_AlrTempTankMax.Q THEN
		inks.Al.xAlrHeaterTankReachsMaxTemp := TRUE;
	END_IF
		
	//Alarm differential temperature in tank	
	TON_AlrDifTempTank.IN	:=	t_reset AND ( ABS(inks.status.Temp.rTempTank - rSPTempTank) > MAX_DIFFCTRLTEMP_WRNG);
	TON_AlrDifTempTank.PT	:=	T#2S;
	TON_AlrDifTempTank();
	
	TON_AlrDifTempTank2.IN	:=	inks.status.xInksRunning AND (ABS(inks.status.Temp.rTempTank-rSPTempTank) < MAX_DIFFCTRLTEMP_WRNG);
	TON_AlrDifTempTank2.PT	:=	T#5S;
	TON_AlrDifTempTank2();
	
	IF NOT inks.status.xInksRunning OR TON_AlrDifTempTank2.Q THEN
		inks.Al.xAlrDiffInCtrlTempTank := FALSE;
	ELSIF TON_AlrDifTempTank.Q THEN
		inks.Al.xAlrDiffInCtrlTempTank := TRUE;
	END_IF
			
	//Alarm in the heater tank temperature gauge. (Out of range)
	TON_AlrIncoherTempTank.IN	:=	t_reset AND ( inks.status.Temp.rTempTank < 0.0 OR inks.status.Temp.rTempTank > 100.0 );
	TON_AlrIncoherTempTank.PT	:=	T#2S;
	TON_AlrIncoherTempTank();
	
	IF TON_AlrIncoherTempTank.Q THEN
		inks.Al.xAlrIncoherTempTank := TRUE;
	END_IF	
END_ACTION

ACTION LogPumpDCError:
	
	IF inks.status.NegPump.rDutyCycleNegative>99 THEN
		stEventLogNeg.Source := ELOG_TYPE_BAR;
		stEventLogNeg.Severity:= ELOG_SEVERITY_ERROR;
		stEventLogNeg.Facility:= gIndexInks;
		stEventLogNeg.ErrorCode:=0;
		stEventLogNeg.Text := 'Negative Pump in Max Value. Bar ';
		brsftoa(gIndexInks, ADR(strAux));
		brsstrcat(ADR(stEventLogNeg.Text), ADR(strAux));
		gEventLogLoader(EventData := ADR(stEventLogNeg));				
	END_IF
	IF inks.status.NegPump.rDutyCycleNegative<1 THEN
		stEventLogNeg.Source := ELOG_TYPE_BAR;
		stEventLogNeg.Severity:= ELOG_SEVERITY_ERROR;
		stEventLogNeg.Facility:= gIndexInks;
		stEventLogNeg.ErrorCode:=0;
		stEventLogNeg.Text := 'Negative Pump in Min Value. Bar ';
		brsftoa(gIndexInks, ADR(strAux));
		brsstrcat(ADR(stEventLogNeg.Text), ADR(strAux));
		gEventLogLoader(EventData := ADR(stEventLogNeg));				
	END_IF
	IF inks.status.PosPump.rDutyCycleFilling>99 THEN
		stEventLogPos.Source := ELOG_TYPE_BAR;
		stEventLogPos.Severity:= ELOG_SEVERITY_ERROR;
		stEventLogPos.Facility:= gIndexInks;
		stEventLogPos.ErrorCode:=0;
		stEventLogPos.Text := 'Filling Pump in Max Value. Bar ';
		brsftoa(gIndexInks, ADR(strAux));
		brsstrcat(ADR(stEventLogPos.Text), ADR(strAux));
		gEventLogLoader(EventData := ADR(stEventLogPos));				
	END_IF
	IF inks.status.PosPump.rDutyCycleFilling<1 THEN
		stEventLogPos.Source := ELOG_TYPE_BAR;
		stEventLogPos.Severity:= ELOG_SEVERITY_ERROR;
		stEventLogPos.Facility:= gIndexInks;
		stEventLogPos.ErrorCode:=0;
		stEventLogPos.Text := 'Filling Pump in Min Value. Bar ';
		brsftoa(gIndexInks, ADR(strAux));
		brsstrcat(ADR(stEventLogPos.Text), ADR(strAux));
		gEventLogLoader(EventData := ADR(stEventLogPos));				
	END_IF

END_ACTION

ACTION LogNotHeating:
	
	stEventLog.Source := ELOG_TYPE_BAR;
	stEventLog.Severity:= ELOG_SEVERITY_ERROR;
	stEventLog.Facility:= gIndexInks;
	stEventLog.ErrorCode:=0;
	stEventLog.Text := 'Not Heating Error. Bar ';
	brsftoa(gIndexInks, ADR(strAux));
	brsstrcat(ADR(stEventLog.Text), ADR(strAux));
	gEventLogLoader(EventData := ADR(stEventLog));				

END_ACTION
