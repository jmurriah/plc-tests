
PROGRAM _CYCLIC
	 
	// Permanents Vars
	IF brsstrlen(ADR(gMachine.St.HwData.SerialNumber)) > 0 THEN
		gPermanentSN := gMachine.St.HwData.SerialNumber;
	END_IF
	gPermanentMachine:=gMachine.parSw;
	gPermanentSwBelt:= gBelt.parSw;
	gPermanentBlock[1]:=gBlock[1].parSw;
	gPermanentBlock[2]:=gBlock[2].parSw;	
	gPermanentTrVacuum[1] := gTransVacuum[1].parSw;
	gPermanentTrVacuum[2] := gTransVacuum[2].parSw;
	gPermanentAnalogSensor := gDing.State.Permanent;

	
	FOR iInksIndex:=1 TO MAX_LAST_INK DO
		gPermanentInksParSw[iInksIndex] := gInks[iInksIndex].parSw;
	END_FOR

	gPermanentSimMachinePar:=gSimMachine.Parameters;
	
	gPermanentVersion.iVersion0 := gPLC.iVersion0;
	gPermanentVersion.iVersion1 := gPLC.iVersion1;
	gPermanentVersion.iVersion2 := gPLC.iVersion2;
	gPermanentVersion.iVersion3 := gPLC.iVersion3;
		
END_PROGRAM

