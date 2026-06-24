
PROGRAM _INIT
	(* Insert code here *)
	simTemp.rA:= 0.2;
	simTemp.rB:= 0.01;
	simTemp.rInitialValue:= 200;
	simTemp.rMinValue:= 150;
	simTemp.rMaxValue:= 600;

	simPresPos.rA:= 1.8;
	simPresPos.rB:= 0.008;
	simPresPos.rInitialValue:= 16383;
	simPresPos.rMinValue:= 13000;
	simPresPos.rMaxValue:= 25000;
	
	simPresNeg.rA:= -20;
	simPresNeg.rB:= -0.1;
	simPresNeg.rInitialValue:= 16383;
	simPresNeg.rMinValue:= 8000;
	simPresNeg.rMaxValue:= 25000;
	
	FOR iInksSimIndex:= 1 TO MAX_LAST_INK DO
		SimInks ACCESS ADR(gSimInks[iInksSimIndex]);
		SimInks.Parameters.TankValuePercent := 50.0;
	END_FOR
	
END_PROGRAM

PROGRAM _CYCLIC

	Inks ACCESS ADR(gInks[iInksSimIndex]);
	SimInks ACCESS ADR(gSimInks[iInksSimIndex]);
	
	//Define here the parameters modified at the first execution
	IF NOT xStarted THEN
		//Inks.parSw.Temp.rSetPointTemp:=30.0;
		xStarted:=TRUE;
	END_IF
	
	IF EDGEPOS(Inks.status.iInkState = INKS_STARTING) THEN
		IF gMachine.St.Mode.xStartUp THEN
			simPresPos.rNewPresentValue:=14500;
			simPresNeg.rNewPresentValue:=13000;
		ELSE
			simPresPos.rNewPresentValue:=16500;
			simPresNeg.rNewPresentValue:=13000;			
		END_IF
		simPresPos.xUseNewValue:=TRUE;
		simPresNeg.xUseNewValue:=TRUE;
	END_IF
	
	tonNotHeating.IN := NOT Inks.signals.out.xOutBarResistance;
	tonNotHeating.PT := T#2500ms;
	tonNotHeating();
	//If not really heating, not increase temperature in simulation
	IF tonNotHeating.Q THEN
		simTemp.rActionControl:=0;
	ELSE
		simTemp.rActionControl:=Inks.status.Temp.rDutyCycleTemp;
	END_IF
	simTemp();
	Inks.signals.in.iTemperatureRaw := REAL_TO_INT(simTemp.rPresentValue);
	
	simPresPos.rActionControl:= Inks.status.PosPump.rDutyCycleFilling * 10;
	simPresPos();
	Inks.signals.in.iVacuum1Raw := REAL_TO_INT(simPresPos.rPresentValue);
	
	simPresNeg.rActionControl:= Inks.status.NegPump.rDutyCycleNegative * 10;
	simPresNeg();
	Inks.signals.in.iVacuum2Raw := REAL_TO_INT(simPresNeg.rPresentValue);
	
	// Code in Inks
	// fbFilterLevelSensor.In:=(((INT_TO_REAL(inks.signals.in.iInTankLevel-16383)*1500)/16384.0)),	WindowLength:=60);
	// rTankLevelmm:= fbFilterLevelSensor.Out;
	// rTankLevelPercent:= LIMIT(0, (rTankLevelmm/2.35), 100);
	Inks.signals.in.iInTankLevel := REAL_TO_INT((SimInks.Parameters.TankValuePercent * 2.35 * 16384 / 1500) + 16383);
	
	//Go to the next element
	iInksSimIndex := iInksSimIndex +1;
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

