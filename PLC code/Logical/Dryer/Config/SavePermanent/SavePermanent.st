
PROGRAM _CYCLIC
	 
	// Permanents Vars
	IF brsstrlen(ADR(gDryer.St.HwData.SerialNumber)) > 0 THEN
		gPermanentSN := gDryer.St.HwData.SerialNumber;
	END_IF
	gPermanentDryer:=gDryer.Pt;
	gPermanentSwBelt := gBelt.parSw;
	gPermanentSimpleBlock := gSimpleBlock[1].parSw;
	gPermanentTrVacuum[1] := gTransVacuum[1].parSw;
	gPermanentNirAdphos  := gNirAdphos.Parameters;
	gPermanentArcLampGew  := gArcLampGew.Parameters;
	
	gPermanentVersion.iVersion0 := gPLC.iVersion0;
	gPermanentVersion.iVersion1 := gPLC.iVersion1;
	gPermanentVersion.iVersion2 := gPLC.iVersion2;
	gPermanentVersion.iVersion3 := gPLC.iVersion3;
	
	gPermanentSimMachinePar:=gSimMachine.Parameters;
		
END_PROGRAM

