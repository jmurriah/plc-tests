
PROGRAM _INIT

	//Default values
	gDryerLocalParams.Media.rThickness := 2;
	gDryerLocalParams.Media.rMargin 	:= 10;
	gDryerLocalParams.Media.rLength := 1500;
	gDryerLocalParams.Media.rWidth := 600;
	
	gThicknessCtrl.parameters.CheckMedia[1].xActive := TRUE;


	//By default, working with comms simulation
	gArcLampGew.Parameters.xDisableComms := TRUE;

END_PROGRAM

PROGRAM _CYCLIC
	
	//Determine number of last block
	CASE gDryer.Pt.MachineModel OF

		DryerType_NOZ2_NIR,
		DryerType_NOZ2_NIR_ARCLAMP:
			gDryer.Pt.CT.iNumBlocks:=1;
			gDryer.Pt.CT.iNumTransVacuum := 1;
			gDryer.Pt.SW.xMachineDirection := 1; //Machine from left
		
	END_CASE;
	

	//Determine machine direction
	// RIGHT: gDryer.Pt.SW.xMachineDirection is 0 or FALSE
	// LEFT:  gDryer.Pt.SW.xMachineDirection is 1 or TRUE
	gDryer.Pt.xLeftHandMachine := gDryer.Pt.SW.xMachineDirection;
	gDryer.Pt.xRightHandMachine:= NOT gDryer.Pt.xLeftHandMachine;

		
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// GENERAL
	////////////////////////////////////////////////////////////////////////////////////////////////////////////

	MachineModel;
	
	AsignCommonData;
	
	CASE gDryer.Pt.ConfigNameID OF
			
		GC_CONFIG_DRYER_NOZ2_ID:
			CASE gDryer.Pt.MachineModel OF
				DryerType_NOZ2_NIR,
				DryerType_NOZ2_NIR_ARCLAMP:
					AsignDataDryerNoz2;
			END_CASE
			
		GC_CONFIG_SIMDRYER_NOZ2_ID:
			CASE gSimMachine.Parameters.DryerType OF
				SIM_DRYER_NOZ2_NIR,
				SIM_DRYER_NOZ2_NIR_ARCLAMP:
					AsignDataDryerNoz2;
			END_CASE			
	END_CASE
	
	DryerModelCopy := gDryer.Pt.MachineModel;
	
END_PROGRAM
