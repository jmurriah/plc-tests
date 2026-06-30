
ACTION calculations: 


	IF NOT xIAmInReverse THEN
		rPressureCollectorPos1:= rVacuum1B ;
		rPressureCollectorPos2:= rVacuum2B;
	ELSE
		rPressureCollectorPos1:= rVacuum2B;
		rPressureCollectorPos2:= rVacuum1B;
	END_IF
	inks.status.rMeniscus:= (-1)*((rPressureCollectorPos1 + rPressureCollectorPos2)/2);
    
	inks.status.rDeltaPressure:= ABS (rPressureCollectorPos1 - rPressureCollectorPos2);
	rSPfillingPump:=inks.parSw.PosPump.rSetPoint;

	rMeniscusPV:=			inks.status.rMeniscus;
	
	//DELOREAN-1961
	IF NOT inks.parSw.xActMaintenanceMode THEN
		rSPtemp:= inks.parSw.Temp.rSetPointTemp;
	ELSE
		rSPtemp:= inks.parSw.Temp.rSetPointTempMaintenance;
	END_IF
	
	// Ink Heater Tank works at the same set point than Ink Heater Bar. For this reason, they use same values from GUI
	rSPTempTank:=			inks.parSw.Temp.rSetPointTemp;
	rMeniscusError:=		ABS(rMeniscusSp - rMeniscusPV);
	
	//Call the tachometer calculation of the pump
	tachoCalculations;
	
	
END_ACTION


ACTION tachoCalculations:
	IF NOT inks.parameters.xEnabledTachoSignals THEN
		RETURN;
	END_IF
	
	// Speedometer  Speedometer  Speedometer  Speedometer  Speedometer  Speedometer  Speedometer Speedometer  Speedometer  Speedometer Speedometer Speedometer  Speedometer
	//
	//Change units from pulses per rev to rpm (The digital counter is configured as event counter so if the ink pump has 2 PULSES per rev, is measuring 4 EVENTS per rev)
	iDiffPulseTachoNeg:= SAFE_UINTDIFF(uiLastValue:= inks.signals.in.iTachNegative, uiPrevValue:= uiNegTachoCounterPrev);
	rSpeedNegCalc:= UINT_TO_REAL(iDiffPulseTachoNeg) * 1000 * 60 / TIME_TO_REAL(clock_ms() - tiTimePreviousExec) / 4;

	iDiffPulseTachoPos:= SAFE_UINTDIFF(uiLastValue:= inks.signals.in.iTachFilling, uiPrevValue:= uiPosTachoCounterPrev);
	rSpeedPosCalc:= UINT_TO_REAL(iDiffPulseTachoPos) * 1000 * 60 / TIME_TO_REAL(clock_ms() - tiTimePreviousExec) / 4;
	
	//Filters to remove tach signal sensibility
	fbFilterSpeedNeg(Enable:=TRUE,
		In:=rSpeedNegCalc,
		WindowLength:=30 , //20*48:=1second
		);
	inks.status.NegPump.rSpeedNeg := fbFilterSpeedNeg.Out;		

	fbFilterSpeedPos(Enable:=TRUE , 
		In:=rSpeedPosCalc,
		WindowLength:=30 , //20*48:=1second
		);
	inks.status.PosPump.rSpeedPos := fbFilterSpeedPos.Out;		
	
	uiNegTachoCounterPrev := inks.signals.in.iTachNegative;
	uiPosTachoCounterPrev := inks.signals.in.iTachFilling;
	tiTimePreviousExec := clock_ms();

END_ACTION
