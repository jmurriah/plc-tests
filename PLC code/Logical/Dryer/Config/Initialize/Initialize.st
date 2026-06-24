
PROGRAM _INIT
    
	HWInfoCpu.pName := ADR(gDryer.St.HwData.Name);
	HWInfoCpu.first := TRUE;
	HWInfoCpu.enable := TRUE;
	HWInfoCpu();
	gDryer.St.HwData.Family := HWInfoCpu.family;	
	
	// Tranfer permanent vars when PLC is starting
	gMachine.St.HwData.SerialNumber := gPermanentSN;
	
	gDryer.Pt:= gPermanentDryer;
	gBelt.parSw := gPermanentSwBelt;
	gSimpleBlock[1].parSw := gPermanentSimpleBlock;
	gTransVacuum[1].parSw := gPermanentTrVacuum[1];
	gTransVacuum[2].parSw := gPermanentTrVacuum[2];
	gNirAdphos.Parameters := gPermanentNirAdphos;
	gArcLampGew.Parameters := gPermanentArcLampGew;

	gSimMachine.Parameters.MachineType := gPermanentSimMachinePar.MachineType;
	
END_PROGRAM


PROGRAM _CYCLIC
	
	//Assign the ConfigurationID been executed
	projectInfo(Execute:=gDryer.Pt.ConfigNameID=0); //Just to execute if still the configuration has not been read
	IF projectInfo.Done AND NOT projectInfo.Error THEN
		IF brsstrcmp(ADR(GC_CONFIG_DRYER_NOZ2),ADR(projectInfo.ConfigurationID))=0 THEN
			gDryer.Pt.ConfigNameID:=GC_CONFIG_DRYER_NOZ2_ID;
			gSimMachine.Parameters.MachineType := SIM_MACHINE_REAL;
		ELSIF brsstrcmp(ADR(GC_CONFIG_SIMDRYER_NOZ2),ADR(projectInfo.ConfigurationID))=0 THEN
			gDryer.Pt.ConfigNameID:=GC_CONFIG_SIMDRYER_NOZ2_ID;
		ELSE
			gDryer.Pt.ConfigNameID:=0;
		END_IF
		strcpy(ADR(gDryer.Pt.ConfigName),ADR(projectInfo.ConfigurationID));
	END_IF
	
END_PROGRAM
