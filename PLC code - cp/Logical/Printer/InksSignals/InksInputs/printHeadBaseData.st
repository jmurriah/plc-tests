
ACTION printHeadBaseData: 

	// PID MENISCUS values defined by default
	dataInksInParams.parBar.paramsPidMeniscus.rKp:=1.5;
	dataInksInParams.parBar.paramsPidMeniscus.rTi:=10.0;
	dataInksInParams.parBar.paramsPidMeniscus.rKd:=0.01;
	dataInksInParams.parBar.paramsPidMeniscus.rTd:=100;
	
	//Initial PID POSITIVE values defined by default
	dataInksInParams.parBar.paramsPidPositive.rKp:=0.8;
	dataInksInParams.parBar.paramsPidPositive.rTi:=12;
	dataInksInParams.parBar.paramsPidPositive.rKd:=0.01;
	dataInksInParams.parBar.paramsPidPositive.rTd:=100;

	//Initial PID TEMPERATURE values defined by default	
	dataInksInParams.parBar.paramsPidTemp.rKp:=4.0;
	dataInksInParams.parBar.paramsPidTemp.rTi:=250.0;
	dataInksInParams.parBar.paramsPidTemp.rKd:=40.0;
	dataInksInParams.parBar.paramsPidTemp.rTd:=30.0;
	
	//Initial PID TEMPERATURE values defined by default 
	dataInksInParams.parBar.paramsPidTankTemp.rKp:=0.3;
	dataInksInParams.parBar.paramsPidTankTemp.rTi:=32;
	dataInksInParams.parBar.paramsPidTankTemp.rKd:=0;	
	dataInksInParams.parBar.paramsPidTankTemp.rTd:=0;
	
	// Initial PID MENISCUS IN RESERV MODE values defined by default
	dataInksInParams.parBar.paramsPidMeniscusReservoir.rKp:=2.25;
	dataInksInParams.parBar.paramsPidMeniscusReservoir.rTi:=15;
	dataInksInParams.parBar.paramsPidMeniscusReservoir.rKd:=0.01;
	dataInksInParams.parBar.paramsPidMeniscusReservoir.rTd:=100;
	
	// Initial PID POSITIVE IN RESERV MODE values defined by default
	dataInksInParams.parBar.paramsPidPositiveReservoir.rKp:=0.35;
	dataInksInParams.parBar.paramsPidPositiveReservoir.rTi:=7;
	dataInksInParams.parBar.paramsPidPositiveReservoir.rKd:=0.01;
	dataInksInParams.parBar.paramsPidPositiveReservoir.rTd:=100;
	
	//Initial PID accelerator temperature params
	dataInksInParams.Temp.rk1Temp := 0.0;
	dataInksInParams.Temp.rk2Temp := 6.0;
	dataInksInParams.Temp.rk3Temp := 2.0;
	dataInksInParams.Temp.rk4Temp := 4.0;
	
	// It is used in xReservoirModeActivated
	dataInksInParams.parBar.rHighPumpLimitNeg:=5;
	dataInksInParams.parBar.rHighPumpLimitPos:=5;
	dataInksInParams.parBar.rLowPumpLimitNeg:=0;
	dataInksInParams.parBar.rLowPumpLimitPos:=0;
	
	dataInksInParams.parBar.rAccelerationFillingPump:=1;
	dataInksInParams.parBar.rSPfillingPumpStarting:=30.0;

	// NOZOMITWO-2541 For advance team testing on Alpha
	IF (gMachine.Pt.MachineModel <> Type_NOZ_2_AQ) THEN
		dataInksInParams.parBar.iStabSole:=500;
		dataInksInParams.parBar.iDesahPid:=800;
		dataInksInParams.parBar.iCloseSole:=0;
	END_IF
	dataInksInParams.parBar.xTypeTankSensorAnalog:=FALSE;
	dataInksInParams.parBar.xTypeTankSensorDigital:=TRUE;
	dataInksInParams.parBar.iPowerTempWatt	:=800; //Total Watts of the heater installed
	dataInksInParams.parBar.rVacuumSensorSpan := 300;
	dataInksInParams.parBar.rVacuumSensorOffset := -150;
	dataInksInParams.parBar.iTimeToActiveDcErrorAlarm := T#10s; //10000; //in ms
	
	dataInksInParams.xReservoirMode := FALSE;
	dataInksInParams.xEnabledTachoSignals := FALSE;
	dataInksInParams.Priming.xSystemNeedsPriming:=FALSE;
	
	dataInksInParams.parBar.Default.rTemp := 45;
	dataInksInParams.parBar.Default.rMeniscus := 35;
	dataInksInParams.parBar.Default.rPositive := -10;
	
	dataInksInParams.parBar.StartUp.rMeniscus := 25; // Value when starting
	//dataInksInParams.parBar.StartUp.rPositive := -10; // Value when starting
	dataInksInParams.parBar.StartUp.iSteps := 5; //Step to final value
	dataInksInParams.parBar.StartUp.iSecondsStable := 20; // Time to change
	dataInksInParams.parBar.StartUp.iSecondsUnstable := 3; // Time to change
	dataInksInParams.parBar.StartUp.rMarginToStable := 2;
	
	
END_ACTION


ACTION parBaseMineral_SK1536_L:

	printHeadBaseData;
	
	// PID MENISCUS values defined by default in P4 because it has been worked in C4,D4 and M4
	dataInksInParams.parBar.paramsPidMeniscus.rKp:=2.25;
	dataInksInParams.parBar.paramsPidMeniscus.rTi:=15;
	dataInksInParams.parBar.paramsPidMeniscus.rKd:=0.01;
	dataInksInParams.parBar.paramsPidMeniscus.rTd:=100;
	
	//Initial PID POSITIVE values defined by default in P4 because it has been worked in C4,D4 and M4
	dataInksInParams.parBar.paramsPidPositive.rKp:=0.4;
	dataInksInParams.parBar.paramsPidPositive.rTi:=7;
	dataInksInParams.parBar.paramsPidPositive.rKd:=0.01;
	dataInksInParams.parBar.paramsPidPositive.rTd:=100;
	
	//Initial PID TEMPERATURE values defined by default in SHIELD
	dataInksInParams.parBar.paramsPidTemp.rKp:=3.2;
	dataInksInParams.parBar.paramsPidTemp.rTi:=280.0;
	dataInksInParams.parBar.paramsPidTemp.rKd:=45.0;
	dataInksInParams.parBar.paramsPidTemp.rTd:=30.0;
	
	//Initial PID accelerator temperature params SHIELD
	dataInksInParams.Temp.rk1Temp := 0.0;
	dataInksInParams.Temp.rk2Temp := 4.5;
	dataInksInParams.Temp.rk3Temp := 2.0;
	dataInksInParams.Temp.rk4Temp := 5.0;
		
	dataInksInParams.xReservoirMode := TRUE;

END_ACTION


ACTION parBaseMineral_Xaar:

	printHeadBaseData;

	//Initial PID TEMPERATURE values defined by default in P4	
	dataInksInParams.parBar.paramsPidTemp.rKp:=1.5; // 4.0;
	dataInksInParams.parBar.paramsPidTemp.rTi:=50; //250.0;
	dataInksInParams.parBar.paramsPidTemp.rKd:=40.0;
	dataInksInParams.parBar.paramsPidTemp.rTd:=30.0;
	
	dataInksInParams.Priming.xSystemNeedsPriming :=TRUE;
	dataInksInParams.PosPump.rSetPointPrimingStarting	:=10;
	dataInksInParams.NegPump.rSetPointPrimingStarting	:=30;
	dataInksInParams.Priming.rThresholdPressure			:=2;
	dataInksInParams.PosPump.rDCThresholdPriming 		:=30.0;

END_ACTION
