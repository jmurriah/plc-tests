
ACTION printHeadData: 
	
	IF dataInksInput.parameters.xDebugMode THEN
		dataInksInParams.parBar := gInksPermanentParBar[iIndexInksSlow];
		RETURN;
	END_IF
	
	CASE gMachine.Pt.MachineModel OF
		Type_P4_6B_L,
		Type_P4_12B_L,
		Type_P4_6B,
		Type_P4_12B,
		Type_P5_OIL,
		Type_P5_WTR,
		Type_P4_CBK,
		Type_S1400,
		Type_S1400_VAC_PWRLNK,
		Type_S1400_VAC_CAN:
			printHeadData_P4;
			
		Type_SHLD,
		Type_SHLD_L:
			printHeadData_SHLD;
		
		Type_NOZ_2_AQ,
		Type_NOZ_2_UV,
		Type_NOZ_2_UV_White,
		Type_CUBE,
		Type_CUBE_INSPECTION,
		Type_CUBE_GULLIVER,
		Type_CUBE_GULLIVER_INSPECTION,
		Type_MECANO_UV_WHITE,
		Type_MECANO_UV_OPV,
		Type_MECANO_UV_WHITE_OPV:
			printHeadData_Nozomi2;
		
	END_CASE

END_ACTION


