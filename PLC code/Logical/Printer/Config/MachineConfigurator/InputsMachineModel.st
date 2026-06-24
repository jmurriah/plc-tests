
ACTION InputsMachineModel: 

	CASE gMachine.Pt.ConfigNameID OF
		
		GC_CONFIG_2BK12BAR_ID:
			gMachine.In.iMachineModelCode.5:= X20DIF371_003.DInput[2]; (*DI1*)
			gMachine.In.iMachineModelCode.4:= X20DIF371_003.DInput[3]; (*DI2*)
			gMachine.In.iMachineModelCode.3:= X20DIF371_003.DInput[4]; (*DI3*)
			gMachine.In.iMachineModelCode.2:= X20DIF371_003.DInput[5]; (*DI4*)
			gMachine.In.iMachineModelCode.1:= X20DIF371_003.DInput[6]; (*DI6*)
			gMachine.In.iMachineModelCode.0:= X20DIF371_003.DInput[7]; (*DI6*)
		
		GC_CONFIG_1BK2BAR_ID:
			gMachine.In.iMachineModelCode.3 	:= X20DIF371_002.DInput[11];
			gMachine.In.iMachineModelCode.2 	:= X20DIF371_002.DInput[12];
			gMachine.In.iMachineModelCode.1 	:= X20DIF371_002.DInput[13];
			gMachine.In.iMachineModelCode.0 	:= X20DIF371_002.DInput[14];
		
		GC_CONFIG_BM_1BK8BAR_ID:
			gMachine.In.iMachineModelCode.0		:= X20DIF371_001.DInput[1];
			gMachine.In.iMachineModelCode.1		:= X20DIF371_001.DInput[2];
			gMachine.In.iMachineModelCode.2		:= X20DIF371_001.DInput[3];
			gMachine.In.iMachineModelCode.3		:= X20DIF371_001.DInput[4];
			gMachine.In.iMachineModelCode.4		:= X20DIF371_001.DInput[5];
			gMachine.In.iMachineModelCode.5		:= X20DIF371_001.DInput[6];
		
		GC_CONFIG_1BK8BAR_NOZ2_ID,
		GC_CONFIG_1BK8BAR_NOZ2_AQ_ID,
		GC_CONFIG_1BK7BAR_CUBE_ID,
		GC_CONFIG_1BK10BAR_MECANO_ID:
			gMachine.In.iMachineModelCode.0			:= Pdc_X20DIF371_002.DInput[1];
			gMachine.In.iMachineModelCode.1			:= Pdc_X20DIF371_002.DInput[2];
			gMachine.In.iMachineModelCode.2			:= Pdc_X20DIF371_002.DInput[3];
			gMachine.In.iMachineModelCode.3			:= Pdc_X20DIF371_002.DInput[4];
			gMachine.In.iMachineModelCode.4			:= Pdc_X20DIF371_002.DInput[5];
			gMachine.In.iMachineModelCode.5			:= Pdc_X20DIF371_002.DInput[6];

	END_CASE	
	
END_ACTION
