
ACTION AsignDataPlcDiagnosis: 

	CASE gPlcDiagMC_Pt.ConfigNameID OF
			
		GC_CONFIG_2BK12BAR_ID:
			AsignDataP4;				
			
		GC_CONFIG_1BK2BAR_ID:
			AsignDataShld;

		GC_CONFIG_BM_1BK8BAR_ID:
			CASE gPlcDiagMC_Pt.MachineModel OF
				Type_S1400,
				Type_P5_OIL,
				Type_P5_WTR:
					AsignDataP5;
					Type_S1400_VAC_PWRLNK,
				Type_S1400_VAC_CAN:
					AsignDataS1400;
			END_CASE
			
		GC_CONFIG_1BK8BAR_NOZ2_ID:
			CASE gPlcDiagMC_Pt.MachineModel OF
				Type_NOZ_2_AQ,
				Type_NOZ_2_UV,
				Type_NOZ_2_UV_White:
					AsignDataNozomi2;
			END_CASE
			
		GC_CONFIG_1BK8BAR_NOZ2_AQ_ID:
			CASE gPlcDiagMC_Pt.MachineModel OF
				Type_NOZ_2_AQ:
					AsignDataNozomi2;
			END_CASE
			
		GC_CONFIG_1BK7BAR_CUBE_ID:
			CASE gPlcDiagMC_Pt.MachineModel OF
				Type_CUBE,
				Type_CUBE_INSPECTION,
				Type_CUBE_GULLIVER,
				Type_CUBE_GULLIVER_INSPECTION:
					AsignDataCube;
			END_CASE			
		
		GC_CONFIG_1BK10BAR_MECANO_ID:
			CASE gPlcDiagMC_Pt.MachineModel OF
				Type_MECANO_UV_WHITE,
				Type_MECANO_UV_OPV,
				Type_MECANO_UV_WHITE_OPV:
					AssignDataMecano;
			END_CASE
			
	END_CASE
	
	
END_ACTION
