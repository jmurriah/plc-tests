
ACTION conversionsPre:

	//Individual DripTime of the bar
	tiDripTime:= MIN(inks.parSw.tiDripTime, INKS_DRIP_TIME_MAX);
	
	//Maximum DripTime of all the "brother" bars. And to be sure DripTimeMax is not smaller than DripTime
	tiDripTimeMax:= MAX( MIN(inks.parameters.tiDripTimeMax, INKS_DRIP_TIME_MAX), tiDripTime);
	
	//Level
	IF parBar.xTypeTankSensorAnalog THEN
		//tests level sensor.
		fbFilterLevelSensor(Enable:=TRUE, 
							In:=(((INT_TO_REAL(inks.signals.in.iInTankLevel-16383)*1500)/16384.0)),
							WindowLength:=60);
		
		rTankLevelmm:= fbFilterLevelSensor.Out;
		
		rTankLevelPercent:= LIMIT(0, (rTankLevelmm/2.35), 100);

	END_IF


	//filters
	inks.status.Temp.rTemp:= INT_TO_REAL(inks.signals.in.iTemperatureRaw)/10.0;
	inks.status.Temp.rTempTank:= INT_TO_REAL(inks.signals.in.iTemperatureTankRaw)/10.0;
	
	
	//Vacuum gauge inputs
	//
	//4-20mA Input Current loop
	// iVacuumXRaw: It is an integer value from 0 to 32767.
	// It is configured in current loop, 4mA is assigned TO 6553,
	// lower than 1000 are reported as 0 by GUI
	// and lower than -8000 are reported as pressure gauge disconnected
	// Checked with M4 
	
	//
	// fbFilterMovingPressure1
	//	iSamplesVacuum1: 60 samples
	IF inks.signals.in.iVacuum1Raw > 1000 THEN 
		rInputFilterVacuum1:= ((INT_TO_REAL(inks.signals.in.iVacuum1Raw)* inks.parameters.parBar.rVacuumSensorSpan)/32767.0)+inks.parameters.parBar.rVacuumSensorOffset;
		fbFilterMovingPressure1(Enable:=TRUE , 
			In:=rInputFilterVacuum1,
			WindowLength:=iSamplesVacuum1 , 
			);
		rVacuum1B:= fbFilterMovingPressure1.Out;

	ELSE
		rVacuum1B:=0;
		//When simulators or printheads are not installed, this value is reported to GUI
		//For that, GUI shows zeros because PLC vaues lower than 1000
		// xAlrVacuum1 has to be activated
	END_IF

	// Filter average of the input pressure sensor
	(*La entrada tiene valores de 0 a 32767, los 4mA corresponden a 6553*)
	IF inks.signals.in.iVacuum2Raw > 1000 THEN  
		rInputFilterVacuum2:= ((INT_TO_REAL(inks.signals.in.iVacuum2Raw)* inks.parameters.parBar.rVacuumSensorSpan)/32767.0)+inks.parameters.parBar.rVacuumSensorOffset;
		fbFilterMovingPressure2(	
			Enable:=TRUE , 
			In:=rInputFilterVacuum2,
			WindowLength:=iSamplesVacuum2 , 
			);
		rVacuum2B:= fbFilterMovingPressure2.Out;

	ELSE
		rVacuum2B:=0;
		//When simulators or printheads are not installed, this value is reported to GUI
		//For that, GUI shows zeros because PLC values lower than 1000
		// xAlrVacuum2 has to be activated
	END_IF

	//Assign vacuum data to status for external viewing
	inks.status.rVacuum1 := rVacuum1B;
	inks.status.rVacuum2 := rVacuum2B;
	
	
	////Out DC Pumps treatment SetPoints
	rLowPumpLimitNeg 	:=parBar.rLowPumpLimitNeg;
	rHighPumpLimitNeg 	:=parBar.rHighPumpLimitNeg;
	IF (rHighPumpLimitNeg - rLowPumpLimitNeg) < Ic_rMinDiffMinMaxCtrlVoltage THEN
		rLowPumpLimitNeg 	:=parBar.rHighPumpLimitNeg - Ic_rMinDiffMinMaxCtrlVoltage;
	END_IF
	rSlopePumpNeg 		:=(rHighPumpLimitNeg-rLowPumpLimitNeg)/100;
		
	rLowPumpLimitPos 	:=parBar.rLowPumpLimitPos;
	rHighPumpLimitPos 	:=parBar.rHighPumpLimitPos;
	IF (rHighPumpLimitPos - rLowPumpLimitPos) < Ic_rMinDiffMinMaxCtrlVoltage THEN
		rLowPumpLimitPos 	:=parBar.rHighPumpLimitPos - Ic_rMinDiffMinMaxCtrlVoltage;
	END_IF
	rSlopePumpPos 		:=(rHighPumpLimitPos-rLowPumpLimitPos)/100;		
	
	// Bar number installed in block from Mapping
	iBarNumberInBlock := (inks.parSw.Config.iMappingBar -1) MOD inks.parameters.Temp.iBarsWithSameBlock;
	
	rVacuumSensorMax := inks.parameters.parBar.rVacuumSensorSpan + inks.parameters.parBar.rVacuumSensorOffset;
	
END_ACTION
