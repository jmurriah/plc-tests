
PROGRAM _INIT
	(* Insert code here *)
	FOR iChillerSimIndex:=1 TO MAX_LAST_CHILLER DO
		// Referencing chiller
		dataChill ACCESS ADR(gChiller[iChillerSimIndex]);
		
		// Initial values
		dataChill.In.xAlarm := FALSE;
		dataChill.In.WaterManifold.xTempEnvSensError := FALSE;
		dataChill.In.WaterManifold.xTempWatSensError := FALSE;
	END_FOR
	
	simTemp.rA:= -0.0002;
	simTemp.rB:= -0.01;
	simTemp.rInitialValue:= 210;
	simTemp.rMinValue:= 160;
	simTemp.rMaxValue:= 320;
	
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	dataChill ACCESS ADR(gChiller[iChillerSimIndex]);
	SimChiller ACCESS ADR(gSimChiller[iChillerSimIndex]);
	
	
	
	IF EDGEPOS(SimChiller.Commands.StopRunning) THEN
		SimChiller.Commands.StopRunning := FALSE;
		xChillerStopped := TRUE;
		dataChill.In.xPowered := FALSE;
	ELSE
		IF EDGEPOS(dataChill.Out.xStart) THEN
			xChillerStopped := FALSE;
		END_IF
		tonSignalRun.IN := dataChill.Out.xStart AND NOT xChillerStopped;
		tonSignalRun.PT := T#3s;
		tonSignalRun();
		dataChill.In.xPowered := tonSignalRun.Q;
		dataChill.In.xCooling := tonSignalRun.Q;
		
	END_IF
	
	dataChill.In.xAlarm := SimChiller.Commands.GenerateAlarm;
	
	IF dataChill.Out.xStart AND NOT dataChill.In.xAlarm THEN
		simTemp.rActionControl := 0.05;
	ELSE
		simTemp.rActionControl := 0;
	END_IF
	simTemp();
	dataChill.In.WaterManifold.iWaterManifoldTempRaw := REAL_TO_INT(simTemp.rPresentValue);
	
	
	dataChill.In.WaterManifold.iEnvironmentTempRaw := REAL_TO_INT(280);
	
	
	iChillerSimIndex := iChillerSimIndex + 1;
	
END_PROGRAM
