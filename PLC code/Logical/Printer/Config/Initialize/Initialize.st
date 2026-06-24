
PROGRAM _INIT
    
	HWInfoCpu.pName := ADR(gMachine.St.HwData.Name);
	HWInfoCpu.first := TRUE;
	HWInfoCpu.enable := TRUE;
	HWInfoCpu();
	gMachine.St.HwData.Family := HWInfoCpu.family;
	gMachine.St.HwData.xSimulation := gMachine.St.HwData.Family = FAMILY_BRAUTOMATIONRUNTIME;
	
	
	// Tranfer permanent vars when PLC is starting	
	
	//Recover just if there is SN in the machine
	//In the first upgrade, a character can be identified as the previous PLC version. Because of that, len>=4
	IF brsstrlen(ADR(gPermanentSN)) >= 4 OR TRUE THEN
		gMachine.St.HwData.SerialNumber := gPermanentSN;
	
		gMachine.parSw:= gPermanentMachine;
		gBelt.parSw:= gPermanentSwBelt;
		gBlock[1].parSw:=gPermanentBlock[1];
		gBlock[2].parSw:= gPermanentBlock[2];
		
		gDing.State.Permanent := gPermanentAnalogSensor;
		
		gSimMachine.Parameters.MachineType := gPermanentSimMachinePar.MachineType;
		
		FOR iInksIndex:=1 TO MAX_LAST_INK DO
			gInks[iInksIndex].parSw := gPermanentInksParSw[iInksIndex];
		END_FOR
		
	END_IF

END_PROGRAM


PROGRAM _CYCLIC
	
	//Assign the ConfigurationID been executed
	projectInfo(Execute:=gMachine.Pt.ConfigNameID=0); //Just to execute if still the configuration has not been read
	IF projectInfo.Done AND NOT projectInfo.Error THEN
		IF brsstrcmp(ADR(GC_CONFIG_2BK12BAR),ADR(projectInfo.ConfigurationID))=0 THEN
			gMachine.Pt.ConfigNameID:=GC_CONFIG_2BK12BAR_ID;
			gSimMachine.Parameters.MachineType := SIM_MACHINE_REAL;
			
		ELSIF brsstrcmp(ADR(GC_CONFIG_1BK2BAR),ADR(projectInfo.ConfigurationID))=0 THEN
			gMachine.Pt.ConfigNameID:=GC_CONFIG_1BK2BAR_ID;
			gSimMachine.Parameters.MachineType := SIM_MACHINE_REAL;
			
		ELSIF brsstrcmp(ADR(GC_CONFIG_BM_1BK8BAR),ADR(projectInfo.ConfigurationID))=0 THEN
			gMachine.Pt.ConfigNameID:=GC_CONFIG_BM_1BK8BAR_ID;
			gSimMachine.Parameters.MachineType := SIM_MACHINE_REAL;
		
		ELSIF brsstrcmp(ADR(GC_CONFIG_1BK8BAR_NOZ2),ADR(projectInfo.ConfigurationID))=0 THEN
			gMachine.Pt.ConfigNameID:=GC_CONFIG_1BK8BAR_NOZ2_ID;
			gSimMachine.Parameters.MachineType := SIM_MACHINE_REAL;
		
		ELSIF brsstrcmp(ADR(GC_CONFIG_1BK7BAR_CUBE),ADR(projectInfo.ConfigurationID))=0 THEN
			gMachine.Pt.ConfigNameID:=GC_CONFIG_1BK7BAR_CUBE_ID;
			gSimMachine.Parameters.MachineType := SIM_MACHINE_REAL;
		
		ELSIF brsstrcmp(ADR(GC_CONFIG_1BK10BAR_MECANO),ADR(projectInfo.ConfigurationID))=0 THEN
			gMachine.Pt.ConfigNameID:=GC_CONFIG_1BK10BAR_MECANO_ID;
			gSimMachine.Parameters.MachineType := SIM_MACHINE_REAL;
			
		ELSIF brsstrcmp(ADR(GC_CONFIG_1BK8BAR_NOZ2_AQ),ADR(projectInfo.ConfigurationID))=0 THEN
			gMachine.Pt.ConfigNameID:=GC_CONFIG_1BK8BAR_NOZ2_AQ_ID;
			gSimMachine.Parameters.MachineType := SIM_MACHINE_REAL;
			
		
		ELSIF brsstrcmp(ADR(GC_CONFIG_SIMTEST),ADR(projectInfo.ConfigurationID))=0 THEN
			gMachine.Pt.ConfigNameID:=GC_CONFIG_SIMTEST_ID;
		
		ELSIF brsstrcmp(ADR(GC_CONFIG_PLCDIAGNOSIS),ADR(projectInfo.ConfigurationID))=0 THEN
			gMachine.Pt.ConfigNameID:=GC_CONFIG_PLCDIAGNOSIS_ID;
		ELSE
			gMachine.Pt.ConfigNameID:=0;
		END_IF
		strcpy(ADR(gMachine.Pt.ConfigName),ADR(projectInfo.ConfigurationID));
	END_IF
	
END_PROGRAM
