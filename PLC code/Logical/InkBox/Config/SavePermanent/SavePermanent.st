
PROGRAM _CYCLIC
	 
	// Permanents Vars
	gPermanentMachine:=gMachine.parSw;
	
	FOR iInksIndex:=1 TO MAX_LAST_INK DO
		gPermanentInksParSw[iInksIndex] := gInks[iInksIndex].parSw;
		gInksPermanentParBar[iInksIndex] := gInks[iInksIndex].parameters.parBar;
	END_FOR
	
	gPermanentInkBox := gInkBox.Parameters;
	gPermanentSwBelt := gBelt.parSw;
	gPermanentTrVacuum[1] := gTransVacuum[1].parSw;
	
	gPermanentVersion.iVersion0 := gPLC.iVersion0;
	gPermanentVersion.iVersion1 := gPLC.iVersion1;
	gPermanentVersion.iVersion2 := gPLC.iVersion2;
	gPermanentVersion.iVersion3 := gPLC.iVersion3;
		
END_PROGRAM

