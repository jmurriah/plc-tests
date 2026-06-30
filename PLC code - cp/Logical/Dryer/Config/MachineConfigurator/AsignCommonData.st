
ACTION AsignCommonData:

	//Just writing the fixed configuration once per each 5s
	IF NOT (EDGEPOS(gPLC.xBlk_5s) OR gPLC.xFirst_Scan OR xChangedSimMachine) THEN
		RETURN;
	END_IF
	
	////////////////////////////////////////////////////////////
	/////GENERAL	GENERAL		GENERAL		GENERAL	////////////
	////////////////////////////////////////////////////////////

	gDryer.Pt.CT.rMaxMargin		:= 25.0;
	gDryer.Pt.CT.rMinMargin		:= 5.0;
	gDryer.Pt.CT.rMinThicknessMedia		:= 1.0;
	gDryer.Pt.CT.rMaxThicknessMedia		:= 12.0;
	gDryer.Pt.CT.rDistanceThicknesToPD	:= 187.0;
	
	/////////////////////////////////////////////////////
	/////BELT	BELT	BELT	BELT	BELT	BELT/////
	/////////////////////////////////////////////////////

	gBelt.parameters.IndexAxis:=1;
	gBelt.parameters.rAcceleration := 1050;
	gBelt.parameters.rSoftDeceleration := 1000; 
	gBelt.parameters.rDeceleration := 2200;
	gBelt.parameters.rMaxAcceleration := 1500.0;
	gBelt.parameters.rMaxDeceleration := 2500.0;
	gBelt.parameters.rMaxSpeed := gBelt.states.Hw.rMaxSpeed;
	
	// From Units measure to meters per minute
	gBelt.parameters.DriveUnit.TransmissionType := TRANS_LINEAL_PERIMETER;
	gBelt.parameters.DriveUnit.LinealPerimeter.PulsesPerTurn := GC_UNITS_BY_REV_DRIVE;
	gBelt.parameters.DriveUnit.LinealPerimeter.GearBox := gBelt.parSw.rGearBox;
	gBelt.parameters.DriveUnit.LinealPerimeter.Perimeter := gBelt.parSw.rAxisLength;

	gBelt.parameters.xExistBelt := TRUE;

	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// TRANSPORT VACUUM
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	FOR iIndexTrVacc := 1 TO MAX_LAST_TRANS_VACUUM DO
		gTransVacuum[iIndexTrVacc].Parameters.xInstalled := iIndexTrVacc <= gDryer.Pt.CT.iNumTransVacuum;
		
		gTransVacuum[iIndexTrVacc].Parameters.parPID.rKp := 0.4;
		gTransVacuum[iIndexTrVacc].Parameters.parPID.rTi := 1.5;
		gTransVacuum[iIndexTrVacc].Parameters.parPID.rKd := 0.0;
		gTransVacuum[iIndexTrVacc].Parameters.parPID.rTd := 0.0;
		
		gTransVacuum[iIndexTrVacc].Parameters.rMaxSystemVacuum := 18.0;
		gTransVacuum[iIndexTrVacc].Parameters.rMaxSpeed := 3000;
		IF gTransVacuum[iIndexTrVacc].Parameters.rMaxPIDOut = 0 THEN
			gTransVacuum[iIndexTrVacc].Parameters.rMaxPIDOut := 55.0;
		END_IF
	END_FOR
	/////////////////////////////////////////////////////
	/////MODEL	MODEL	MODEL	MODEL	MODEL	MODEL////
	/////////////////////////////////////////////////////
	
	gThicknessCtrl.parameters.sections[1].xEnabled := TRUE;
	gThicknessCtrl.parameters.iSections := 1;

	gThicknessCtrl.parameters.Detection.ProductDetect.pMediaInProductDetectL1 := gDryer.In.ProductDetect.pPDSignalSensorL1;
	gThicknessCtrl.parameters.Detection.ProductDetect.pMediaInProductDetectL2 := gDryer.In.ProductDetect.pPDSignalSensorL2;
	
	gThicknessCtrl.parameters.rMountedMediaHeigh := 75.0;
	
	gThicknessCtrl.parameters.pExtContMedia := ADR(gDryer.Pt.SW.Media);
	
	// JAM DETECTION DEVICES
	gDryer.Pt.CT.iNumSensorsPerJamDevice := 4;
	
END_ACTION
