
ACTION reservoirMode: 

	//Determine if system is stable or not >= 2  and <= 14
	TON_PressureReservoirStable.IN:= mode4 AND //INKS_STARTED
									xReservoirModeActivated AND NOT inks.commands.xCloseReliefValve AND
									rPressureCollectorPos1 >= lc_rLowPresEnterStable AND 
									rPressureCollectorPos1 <= lc_rHighPresEnterStable;
	TON_PressureReservoirStable.PT:= T#1S;
	TON_PressureReservoirStable();
	
	IF TON_PressureReservoirStable.Q THEN
		xPressureReservoirStable := TRUE;
	END_IF

	IF 	NOT mode4 OR //INKS_STARTED
		rPressureCollectorPos1 > lc_rHighPresExitStable OR 
		rPressureCollectorPos1 <= lc_rLowPresExitStable OR
		inks.commands.xCloseReliefValve 						THEN
			xPressureReservoirStable := FALSE;
	END_IF

	//Take care about be sure to have the system stabilized with the valve closed
	TON_TimeAfterCloseReliefValve.IN := NOT xPressureReservoirStable;
	TON_TimeAfterCloseReliefValve.PT := T#2S;
	TON_TimeAfterCloseReliefValve();
	
	inks.signals.out.xReliefValve:= xPressureReservoirStable AND NOT inks.commands.xCloseReliefValve;
	inks.status.xReservoirMode := xReservoirModeActivated;	
	
END_ACTION
