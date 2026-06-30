
PROGRAM _INIT
	// Safety Visu named Panel needs this variable. It is showing has is configured
	//SAFETY g_xInputSelectMachine;
	g_xInputSelectMachine;

END_PROGRAM

PROGRAM _CYCLIC
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// GENERAL
	////////////////////////////////////////////////////////////////////////////////////////////////////////////

	MachineModel;
	
	//Determine number of last block
	CASE gMachine.Pt.MachineModel OF
			
		Type_P4_12B_L,
		Type_P4_12B:
			gMachine.Pt.CT.iNumBlocks:=2;
			gMachine.Pt.CT.iNumTransVacuum := 0;
			gMachine.Pt.xControlledByLine := FALSE;

		Type_P4_6B_L,
		Type_P4_6B,
		Type_P4_CBK,	
		Type_SHLD,
		Type_S1400,
		Type_P5_OIL,
		Type_P5_WTR:
			gMachine.Pt.CT.iNumBlocks:=1;
			gMachine.Pt.CT.iNumTransVacuum := 0;
			gMachine.Pt.xControlledByLine := FALSE;
		
		Type_S1400_VAC_PWRLNK,
		Type_S1400_VAC_CAN:
			gMachine.Pt.CT.iNumBlocks:=1;
			gMachine.Pt.CT.iNumTransVacuum := 2;
			gMachine.Pt.xControlledByLine := FALSE;
		
		Type_NOZ_2_AQ,
		Type_NOZ_2_UV,
		Type_NOZ_2_UV_White,
		Type_MECANO_UV_WHITE,
		Type_MECANO_UV_OPV,
		Type_MECANO_UV_WHITE_OPV:
			gMachine.Pt.CT.iNumBlocks:=1;
			gMachine.Pt.CT.iNumTransVacuum := 2;
			gMachine.Pt.xControlledByLine := TRUE;
		
		Type_CUBE,
		Type_CUBE_INSPECTION,
		Type_CUBE_GULLIVER,
		Type_CUBE_GULLIVER_INSPECTION:
			gMachine.Pt.CT.iNumBlocks:=1;
			gMachine.Pt.CT.iNumTransVacuum := 1;
			gMachine.Pt.xControlledByLine := FALSE;
		
	END_CASE
	
	
	//Determine machine direction
	// RIGHT: gMachine.parSw.xMachineDirection is 0 or FALSE
	// LEFT:  gMachine.parSw.xMachineDirection is 1 or TRUE
	gMachine.Pt.xLeftHandMachine := gMachine.parSw.xMachineDirection;
	gMachine.Pt.xRightHandMachine:= NOT gMachine.Pt.xLeftHandMachine;
	
	
	AsignCommonData;
	
	CASE gMachine.Pt.ConfigNameID OF
			
		GC_CONFIG_2BK12BAR_ID:
			AsignDataP4;				
			
		GC_CONFIG_1BK2BAR_ID:
			AsignDataShld;

		GC_CONFIG_BM_1BK8BAR_ID:
			CASE gMachine.Pt.MachineModel OF
				Type_S1400,
				Type_P5_OIL,
				Type_P5_WTR:
					AsignDataP5;
					Type_S1400_VAC_PWRLNK,
				Type_S1400_VAC_CAN:
					AsignDataS1400;
			END_CASE
			
		GC_CONFIG_1BK8BAR_NOZ2_ID:
			CASE gMachine.Pt.MachineModel OF
				Type_NOZ_2_AQ,
				Type_NOZ_2_UV,
				Type_NOZ_2_UV_White:
					AsignDataNozomi2;
			END_CASE
		
		GC_CONFIG_1BK8BAR_NOZ2_AQ_ID:
			CASE gMachine.Pt.MachineModel OF
				Type_NOZ_2_AQ:
				AsignDataNozomi2;
			END_CASE
			
		GC_CONFIG_1BK7BAR_CUBE_ID:
			CASE gMachine.Pt.MachineModel OF
				Type_CUBE,
				Type_CUBE_INSPECTION,
				Type_CUBE_GULLIVER,
				Type_CUBE_GULLIVER_INSPECTION:
					AsignDataCube;
			END_CASE			
			
		GC_CONFIG_1BK10BAR_MECANO_ID:
			CASE gMachine.Pt.MachineModel OF
				Type_MECANO_UV_WHITE,
				Type_MECANO_UV_OPV,
				Type_MECANO_UV_WHITE_OPV:
					AssignDataMecano;
			END_CASE
		
		GC_CONFIG_PLCDIAGNOSIS_ID:
			AsignDataPlcDiagnosis;
			
		GC_CONFIG_SIMTEST_ID:
			
			CASE gSimMachine.Parameters.MachineType OF
				SIM_MACHINE_2B12BAR,
				SIM_MACHINE_1B6BAR,
				SIM_MACHINE_P4_CBK:
					AsignDataP4;
				
				SIM_MACHINE_1B2BAR:
					AsignDataShld;
				
				SIM_MACHINE_S1400_VAC_PWRLNK,
				SIM_MACHINE_S1400_VAC_CAN:
					AsignDataS1400;
				
				SIM_MACHINE_P5_WAT:
					AsignDataP5;
				
				SIM_MACHINE_NZ2,
				SIM_MACHINE_NZ2_UV,
				SIM_MACHINE_NZ2_UV_WHITE:
					AsignDataNozomi2;
					
				SIM_MACHINE_CUBE,
				SIM_MACHINE_CUBE_GULLIVER:
					AsignDataCube;

				SIM_MACHINE_MECANO_UV_WHITE,
				SIM_MACHINE_MECANO_UV_OPV,
				SIM_MACHINE_MECANO_UV_WHITE_OPV:
					AssignDataMecano;
				
			END_CASE
	END_CASE
	
	
	JamVibrationConfiguration;

	
	FOR iBlockIndex:=GC_FIRST_BLOCK TO gMachine.Pt.CT.iNumBlocks DO
		
		IF gMachine.In.Buttons.xReset THEN 
			gBlock[iBlockIndex].Out.xEnableDrive:= TRUE;
			gBlock[iBlockIndex].Out.xEnableIclaSI:= TRUE;
		END_IF		
		
	
		// Enable Drive AND Icla_SI BK
		IF gMachine.In.Buttons.xZero OR 
			(NOT gBlock[iBlockIndex].parSw.xEnableToMovements) THEN	
			gBlock[iBlockIndex].Out.xEnableDrive:= FALSE;
			gBlock[iBlockIndex].Out.xEnableIclaSI:= FALSE;
		END_IF		
		
	END_FOR	
	
	MachineModelCopy := gMachine.Pt.MachineModel;
	
END_PROGRAM
