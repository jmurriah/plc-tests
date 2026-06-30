
PROGRAM _INIT
    
	HWInfoCpu.pName := ADR(gMachine.St.HwData.Name);
	HWInfoCpu.first := TRUE;
	HWInfoCpu.enable := TRUE;
	HWInfoCpu();
	gMachine.St.HwData.Family := HWInfoCpu.family;	
	
	// Tranfer permanent vars when PLC is starting	
	gMachine.parSw:= gPermanentMachine;
	
	FOR iInksIndex:=1 TO MAX_LAST_INK DO
		gInks[iInksIndex].parSw := gPermanentInksParSw[iInksIndex];
		gInks[iInksIndex].parameters.parBar := gInksPermanentParBar[iInksIndex];
	END_FOR
	
	gInkBox.Parameters := gPermanentInkBox;
	gBelt.parSw := gPermanentSwBelt;
	gTransVacuum[1].parSw := gPermanentTrVacuum[1];
	
END_PROGRAM


PROGRAM _CYCLIC
	
	//Assign the ConfigurationID been executed
	projectInfo(Execute:=gMachine.Pt.ConfigNameID=0); //Just to execute if still the configuration has not been read
	IF projectInfo.Done AND NOT projectInfo.Error THEN
		IF brsstrcmp(ADR(GC_CONFIG_INKBOX),ADR(projectInfo.ConfigurationID))=0 THEN
			
			IF gMachine.In.x230V THEN //This var is assigned to a ModuleOk just for simulation. Never in a real cabinet
				gMachine.Pt.ConfigNameID:=GC_CONFIG_INKBOX_SIM_ID;
			ELSE
				gMachine.Pt.ConfigNameID:=GC_CONFIG_INKBOX_ID;
			END_IF
		ELSE
			gMachine.Pt.ConfigNameID:=0;
		END_IF
		strcpy(ADR(gMachine.Pt.ConfigName),ADR(projectInfo.ConfigurationID));
	END_IF
		
END_PROGRAM
