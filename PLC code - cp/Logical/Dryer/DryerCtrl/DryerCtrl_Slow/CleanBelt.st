
ACTION CleanBelt: 
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// General conditions to clean belt	when machine is in AUTOMATIC OR MANUAL MODES
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	//Cleaning Belt by time. When cleaning, the time is reseted
	tonCleaningByTime.IN:= gBelt.states.xRuningBelt AND gDryer.Pt.SW.CleanBelt.xCleanBeltByTime AND NOT tonCleaningByTime.Q AND NOT xCleanBeltOrder;
	tonCleaningByTime.PT := MAX(tiCleaningBeltByTime, MIN_TIME_FOR_CLEANING_BELT); // Time converted from minutes to miliseconds
	tonCleaningByTime();
	
	
	//If the belt is not running, it is not possible to clean it
	IF NOT gBelt.states.xRuningBelt THEN
		RETURN;
	END_IF
	
	
	
	// Tiles counter
	IF gDryer.Pt.SW.CleanBelt.xCleanBeltByTiles AND (EDGEPOS (gDryer.St.xProductDetectL1) OR EDGEPOS(gDryer.St.xProductDetectL2)) THEN
		gDryer.Lg.iTilesCounterToClean:= gDryer.Lg.iTilesCounterToClean+1;	
	END_IF	
	
	//Cleaning by tiles. When cleaning, number of tiles is reseted
	IF gDryer.Pt.SW.CleanBelt.xCleanBeltByTiles AND (gDryer.Lg.iTilesCounterToClean >= INT_TO_UINT(iSPTilesToCleanBelt)) THEN
		xCleaningBeltByTiles:= TRUE;
	END_IF
	

	// Force cleaning applying delay. Why clean continuous is same that condition than force clean?
	IF gDryer.Pt.SW.CleanBelt.xCleanBeltForced THEN
		xCleanBeltForced:= TRUE;
		gDryer.Pt.SW.CleanBelt.xCleanBeltForced := FALSE;
	END_IF

	IF tonCleaningByTime.Q THEN			
		xCleaningBeltByTime:=TRUE;
	END_IF
	
	
	IF xCleaningBeltByTiles OR xCleaningBeltByTime OR xCleanBeltForced OR gDryer.Pt.SW.CleanBelt.xCleanBeltContinue THEN
		xCleanBeltOrder:=TRUE;

		//Removed orders when cleaning
		xCleaningBeltByTiles:=FALSE;
		gDryer.Lg.iTilesCounterToClean:=0;
		xCleaningBeltByTime:=FALSE;
		xCleanBeltForced := FALSE;

	END_IF	
	

	// Managing the duration of the belt cleaning
	tonCleaningBelt.IN:= xCleanBeltOrder;
	tonCleaningBelt.PT := MAX(gDryer.Pt.SW.CleanBelt.tiCleaningBeltDuration, MIN_DURATION_CLEANING_BELT);
	tonCleaningBelt();
	
	IF (tonCleaningBelt.Q AND NOT(gDryer.Pt.SW.CleanBelt.xCleanBeltContinue)) OR EDGENEG(gDryer.Pt.SW.CleanBelt.xCleanBeltContinue) THEN		
		xCleanBeltOrder:=FALSE;
	END_IF

		
END_ACTION
