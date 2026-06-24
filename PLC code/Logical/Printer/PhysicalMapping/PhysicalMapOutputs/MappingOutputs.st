
PROGRAM _CYCLIC
	
	//If in automation runtime, do not assign physical mapping
	IF gMachine.St.HwData.Family = FAMILY_BRAUTOMATIONRUNTIME THEN
		RETURN;
	END_IF

	CASE gMachine.Pt.MachineModel OF
		Type_P4_12B,
		Type_P4_12B_L,
		Type_P4_6B,
		Type_P4_CBK,
		Type_P4_6B_L:
			OutputsP4;
			
		Type_SHLD,
		Type_SHLD_L:
			OutputsShield;
		
		Type_S1400, 
		Type_S1400_VAC_PWRLNK,
		Type_S1400_VAC_CAN:
			OutputsS1400;
		
		Type_P5_OIL, 
		Type_P5_WTR:
			OutputsP5;

		Type_NOZ_2_AQ,
		Type_NOZ_2_UV,
		Type_NOZ_2_UV_White:
			OutputsNozomi2;

		Type_CUBE,
		Type_CUBE_INSPECTION,
		Type_CUBE_GULLIVER,
		Type_CUBE_GULLIVER_INSPECTION:
			OutputsCube;
		
		Type_MECANO_UV_WHITE,
		Type_MECANO_UV_OPV,
		Type_MECANO_UV_WHITE_OPV:
			OutputsMecano;
		
	END_CASE
	
	
END_PROGRAM
