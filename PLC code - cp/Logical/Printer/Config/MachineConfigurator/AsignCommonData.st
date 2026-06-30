
ACTION AsignCommonData:

	//Just writing the fixed configuration once per each 5s
	IF NOT (EDGEPOS(gPLC.xBlk_5s) OR gPLC.xFirst_Scan OR xChangedSimMachine) THEN
		RETURN;
	END_IF
	
	////////////////////////////////////////////////////////////
	/////GENERAL	GENERAL		GENERAL		GENERAL	////////////
	////////////////////////////////////////////////////////////
	gMachine.Pt.CT.rMaxMarginPrinting		:= 5.0;
	gMachine.Pt.CT.rDistanceThicknesToPD	:= 187.0;
	
	/////////////////////////////////////////////////////
	/////BELT	BELT	BELT	BELT	BELT	BELT/////
	/////////////////////////////////////////////////////

	gBelt.parameters.IndexAxis:=1;
	gBelt.parameters.rSoftDeceleration := 1000;
	
	// From Units measure to meters per minute
	// Issue: CRETAPRINT LEGOCRETALEGO-964
	//These parameters only may be changed while belt is stopped for safety reasons
	IF NOT gBelt.states.xRuningBelt THEN
		gBelt.parameters.DriveUnit.TransmissionType := TRANS_LINEAL_PERIMETER;
		gBelt.parameters.DriveUnit.LinealPerimeter.PulsesPerTurn := GC_UNITS_BY_REV_DRIVE;
		gBelt.parameters.DriveUnit.LinealPerimeter.GearBox := LIMIT(1, gBelt.parSw.rGearBox, gBelt.parameters.rMaxGearBox);
		gBelt.parameters.DriveUnit.LinealPerimeter.Perimeter := LIMIT(500, gBelt.parSw.rAxisLength, gBelt.parameters.rMaxAxisLength);
	END_IF
	
	gBelt.parameters.xExistBelt := TRUE;

	// This changes are done because when we have changed the reductor stops are harder than before
	// Changed from 60000 to 45000 because is not working properly in MarcoPolo (SN1).
	//29/01/2018: Dev1 with new reduction factor (15) is needed with 30000. Come back to 45000 because reductor is 35 again
	
	////////////////////////////////////////////////////////////
	/////BLOCK	BLOCK	BLOCK	BLOCK	BLOCK	BLOCK///////////
	////////////////////////////////////////////////////////////
	FOR iIndexBlock:=1 TO gMachine.Pt.CT.iNumBlocks DO
				
		gBlock[iIndexBlock].parameters.Motor.rDriveManSpeed		:=10.0;
		gBlock[iIndexBlock].parameters.Motor.rSafeMarginForwardTray:= 5.0;
		gBlock[iIndexBlock].parameters.Motor.rMinThicknessMedia:= gMachine.Pt.CT.rMinTicknessMedia;
		gBlock[iIndexBlock].parameters.Motor.rReduceSpeedDistance :=6.0;
		gBlock[iIndexBlock].parameters.Motor.rMinCleanOffsetTech := -5.0;
		gBlock[iIndexBlock].parameters.Motor.rMaxCleanOffsetTech := 0.0;
		//gBlock[iIndexBlock].parameters.Motor.rDeceleration		:= 172.5;
		
		gBlock[iIndexBlock].parameters.Icla.iMaxSpeedCleanMotorBwd	:=5000;
		gBlock[iIndexBlock].parameters.Icla.iMaxSpeedCleanMotorFwd	:=5000;
		gBlock[iIndexBlock].parameters.Icla.iMinSpeedCleanMotorBwd	:=300;	
		gBlock[iIndexBlock].parameters.Icla.iMinSpeedCleanMotorFwd	:=300;
					
		gBlock[iIndexBlock].parameters.Icla.rPositionCleanMotorBwd	:= -0.5;
							
		gBlock[iIndexBlock].parameters.Hw.xThereIsInTraySensor	:= FALSE;
		gBlock[iIndexBlock].parameters.Hw.xIsWater	:= gMachine.St.HwData.xIsWater;
		
		//Time Parameters
		gBlock[iIndexBlock].parameters.tiTimeWaitTrayIn			:= T#2S;
		gBlock[iIndexBlock].parameters.tiTimeWaitTrayInAlarm 	:= T#2500ms;
		IF NOT gBlock[iIndexBlock].parameters.Hw.xIsWater THEN
			gBlock[iIndexBlock].parameters.tiTimeWaitTrayOut	:= T#5S;
			gBlock[iIndexBlock].parameters.tiTimeWaitTrayOutAlarm := T#2500ms;
		ELSE
			gBlock[iIndexBlock].parameters.tiTimeWaitTrayOut	:= T#7S;
			gBlock[iIndexBlock].parameters.tiTimeWaitTrayOutAlarm := T#7500ms;
		END_IF		
		gBlock[iIndexBlock].parameters.iLastBlock:=gMachine.Pt.CT.iNumBlocks;
		gBlock[iIndexBlock].parameters.iFirstBlock:=GC_FIRST_BLOCK;

	END_FOR
	
	/////////////////////////////////////////////////////
	/////MODEL	MODEL	MODEL	MODEL	MODEL	MODEL////
	/////////////////////////////////////////////////////
	
	//By default, enable the first Block. Never a machine without a block
	gBlock[1].parameters.Hw.xExistBlock :=TRUE;

	
	gThicknessCtrl.parameters.sections[1].xEnabled := TRUE;
	gThicknessCtrl.parameters.iSections := gMachine.Pt.CT.iNumBlocks;
	
	gThicknessCtrl.parameters.Detection.ProductDetect.pMediaInProductDetectL1 := gMachine.In.ProductDetect.pPDSignalSensorL1;
	gThicknessCtrl.parameters.Detection.ProductDetect.pMediaInProductDetectL2 := gMachine.In.ProductDetect.pPDSignalSensorL2;
	
	// Loop all the posible blocks and assign to the block if it exists or not
	FOR iIndexBlock:=2 TO MAX_LAST_BLOCK DO

		xExistsLoopBlock := iIndexBlock <= gMachine.Pt.CT.iNumBlocks;
		
		//Enabling the different blocks
		gThicknessCtrl.parameters.sections[iIndexBlock].xEnabled:=xExistsLoopBlock;

		gBlock[iIndexBlock].parameters.Hw.xExistBlock:=xExistsLoopBlock;
		
	END_FOR	
	
	gThicknessCtrl.parameters.rMountedMediaHeigh := 100.0;
	
	//Define as installed the vacuum depending on the quantity of transport vacuum of the machine
	FOR iIndexTrVacc := 1 TO MAX_LAST_TRANS_VACUUM DO
		gTransVacuum[iIndexTrVacc].Parameters.xInstalled := iIndexTrVacc <= gMachine.Pt.CT.iNumTransVacuum;
	END_FOR		
	
	// JAM DETECTION DEVICES
	gMachine.Pt.CT.iNumSensorsPerJamDevice := 4;		

END_ACTION
