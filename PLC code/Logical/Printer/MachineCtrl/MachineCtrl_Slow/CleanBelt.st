
ACTION CleanBelt: 
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// General conditions to clean belt	when machine is in AUTOMATIC OR MANUAL MODES
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	//Cleaning Belt by time. When cleaning, the time is reseted
	tonCleaningByTime.IN:= gBelt.states.xRuningBelt AND gMachine.parSw.CleanBelt.xCleanBeltByTime AND NOT tonCleaningByTime.Q AND NOT xCleanBeltOrder AND gMachine.St.Mode.xAuto;
	tonCleaningByTime.PT := MAX(gMachine.parSw.CleanBelt.tiCleaningBeltByTime, MIN_TIME_FOR_CLEANING_BELT); // Time converted from minutes to miliseconds
	tonCleaningByTime();
	
	//Delay falling the tray to be sure no water is poured inside the machine
	tofCleaningTrayBelt.IN:=xCleanBeltOrder;
	tofCleaningTrayBelt.PT:=T#200MS;
	tofCleaningTrayBelt();
		

	//Delay pneumatic pump to avoid pouring water inside the machine
	tonCleanBelt.IN:= xCleanBeltOrder;
	tonCleanBelt.PT:=T#900ms;
	tonCleanBelt();
	
	//If the belt is not running, it is not possible to clean it
	IF NOT gBelt.states.xRuningBelt THEN
		gMachine.commands.CleanBelt := ResetCleanBeltCommands;
		xCleanBeltOrder := FALSE;
		RETURN;
	END_IF
	
	
	
	// Tiles counter
	IF gMachine.parSw.CleanBelt.xCleanBeltByTiles AND (EDGEPOS (gMachine.St.ProductDetect.xProductDetectL1) OR EDGEPOS(gMachine.St.ProductDetect.xProductDetectL2)) THEN
		gMachine.Lg.iTilesCounterToClean:= gMachine.Lg.iTilesCounterToClean+1;	
	END_IF	
	
	//Cleaning by tiles. When cleaning, number of tiles is reseted
	IF (gMachine.parSw.CleanBelt.xCleanBeltByTiles AND (gMachine.Lg.iTilesCounterToClean >= INT_TO_UINT(iSPTilesToCleanBelt)) AND gMachine.St.Mode.xAuto) THEN
		xCleaningBeltByTiles:= TRUE;
	END_IF
	

	// Force cleaning applying delay. Why clean continuous is same that condition than force clean?
	IF gMachine.parSw.CleanBelt.xCleanBeltForced THEN
		xCleanBeltForced:= TRUE;
		gMachine.parSw.CleanBelt.xCleanBeltForced := FALSE;
	END_IF

	IF tonCleaningByTime.Q THEN			
		xCleaningBeltByTime:=TRUE;
	END_IF
	
	IF (gMachine.parSw.CleanBelt.xCleanBeltContinue AND gMachine.St.Mode.xAuto) THEN
		xCleanBeltContinue := TRUE;
	ELSE
		xCleanBeltContinue := FALSE;
	END_IF
	
	IF xCleaningBeltByTiles OR xCleaningBeltByTime OR xCleanBeltForced OR xCleanBeltContinue THEN
		xCleanBeltOrder:=TRUE;

		//Removed orders when cleaning
		xCleaningBeltByTiles:=FALSE;
		gMachine.Lg.iTilesCounterToClean:=0;
		xCleaningBeltByTime:=FALSE;
		xCleanBeltForced := FALSE;
	END_IF

	
	// Managing the duration of the belt cleaning
	tonCleaningBelt.IN:= xCleanBeltOrder;
	tonCleaningBelt.PT := MAX(gMachine.parSw.CleanBelt.tiCleaningBeltDuration, MIN_DURATION_CLEANING_BELT);
	tonCleaningBelt();
	
	IF (tonCleaningBelt.Q AND NOT(xCleanBeltContinue)) OR EDGENEG(xCleanBeltContinue) THEN		
		xCleanBeltOrder:=FALSE;
	END_IF
	
	//////////////////////
	// OUTPUT management
	//////////////////////	
	//Clean belt

	
	//Pneumatic
	gMachine.commands.CleanBelt.xPistonFlojet := tofCleaningTrayBelt.Q;
	gMachine.commands.CleanBelt.xCleanBeltPump := tonCleanBelt.Q;
			
END_ACTION

ACTION CleanBeltTop:
	
	IF NOT gMachine.Pt.Clean.xCleanBeltTopInstall OR NOT gBelt.states.xRuningBelt THEN
		xCleanBeltTopOrder						:= FALSE;		
		RETURN;
	END_IF
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// General conditions to clean belt	when machine is in AUTOMATIC OR MANUAL MODES
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	//Cleaning Belt by time. When cleaning, the time is reseted
	tonCleanBeltTopByTime.IN := gMachine.parSw.CleanBeltTop.xCleanBeltByTime AND NOT tonCleanBeltTopByTime.Q AND NOT xCleanBeltTopOrder AND gMachine.St.Mode.xAuto;
	tonCleanBeltTopByTime.PT := MAX(gMachine.parSw.CleanBeltTop.tiCleaningBeltByTime, MIN_TIME_FOR_CLEANING_TOP_BELT);
	tonCleanBeltTopByTime();
	
	
	
	// Tiles counter
	IF gMachine.parSw.CleanBeltTop.xCleanBeltByTiles AND (EDGEPOS (gMachine.St.ProductDetect.xProductDetectL1) OR EDGEPOS(gMachine.St.ProductDetect.xProductDetectL2)) THEN
		gMachine.Lg.iTilesCounterToCleanBeltTop:= gMachine.Lg.iTilesCounterToCleanBeltTop + 1;
	END_IF	
	
	//Cleaning by tiles. When cleaning, number of tiles is reseted
	IF (gMachine.parSw.CleanBeltTop.xCleanBeltByTiles AND (gMachine.Lg.iTilesCounterToCleanBeltTop >= INT_TO_UINT(iSPTilesToCleanBeltTop)) AND gMachine.St.Mode.xAuto) THEN
		xCleaningBeltTopByTiles:= TRUE;
	END_IF
	

	// Force cleaning applying delay. Why clean continuous is same that condition than force clean?
	IF gMachine.parSw.CleanBeltTop.xCleanBeltForced THEN
		xCleanBeltTopForced:= TRUE;
		gMachine.parSw.CleanBeltTop.xCleanBeltForced := FALSE;
	END_IF

	IF tonCleanBeltTopByTime.Q THEN			
		xCleaningBeltTopByTime:=TRUE;
	END_IF
	
	IF (gMachine.parSw.CleanBeltTop.xCleanBeltContinue AND gMachine.St.Mode.xAuto) THEN
		xCleanBeltTopContinue := TRUE;
	ELSE
		xCleanBeltTopContinue := FALSE;
	END_IF
	
	IF xCleaningBeltTopByTiles OR xCleaningBeltTopByTime OR xCleanBeltTopForced OR xCleanBeltTopContinue THEN
		xCleanBeltTopOrder:=TRUE;

		//Removed orders when cleaning
		xCleaningBeltTopByTiles:=FALSE;
		gMachine.Lg.iTilesCounterToCleanBeltTop:=0;
		xCleaningBeltTopByTime:=FALSE;
		xCleanBeltTopForced := FALSE;
	END_IF

	
	// Managing the duration of the belt cleaning
	tonCleaningBeltTop.IN:= xCleanBeltTopOrder;
	tonCleaningBeltTop.PT := MAX(gMachine.parSw.CleanBeltTop.tiCleaningBeltDuration, MIN_DURATION_CLEANING_BELT_TOP);
	tonCleaningBeltTop();
	
	IF (tonCleaningBeltTop.Q AND NOT(gMachine.parSw.CleanBeltTop.xCleanBeltContinue)) OR EDGENEG(gMachine.parSw.CleanBeltTop.xCleanBeltContinue) THEN		
		xCleanBeltTopOrder:=FALSE;
	END_IF


	
	//////////////////////
	// OUTPUT management
	//////////////////////
	
	gMachine.commands.CleanBelt.xCleanBeltTopScraper:=xCleanBeltTopOrder AND NOT gMachine.Pt.Clean.xCleanBeltForUv;

		
END_ACTION
