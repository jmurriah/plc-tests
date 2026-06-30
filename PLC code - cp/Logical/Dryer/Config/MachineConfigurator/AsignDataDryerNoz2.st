
ACTION AsignDataDryerNoz2: 

	//Just writing the fixed configuration once per each 5s
	IF NOT (EDGEPOS(gPLC.xBlk_5s) OR gPLC.xFirst_Scan OR xChangedSimMachine) THEN
		RETURN;
	END_IF
	
	////////////////////////////////////////////////////////////
	/////GENERAL	GENERAL		GENERAL		GENERAL	////////////
	////////////////////////////////////////////////////////////
	gDryer.Pt.CT.rMountedMediaLevelInBypassMode	:= 145.0;
	gDryer.Pt.CT.rMaxBeltTorque 		:= 25.0;
	gDryer.Pt.CT.rMaxBeltTempFast 		:= 190.0;
	gDryer.Pt.CT.rMaxBeltTempSlow 		:= 180.0;
	gDryer.Pt.SW.Safety.rMaxBeltSpeedSetPoint := 100.0;
	gDryer.Pt.PDSignalTpe 				:= PDCFG_CARRIAGE;
	gDryer.St.iJamDevices				:= 1;
	
	gBelt.parameters.xDriveProtectionOK := TRUE; //This machine doesn't have this signal connected to the PLC
	
	//Here are configured blocks in function of the machine direction
	//When machine is block then we need use correction as block physical 2 because PD is at the same distance than Block 1, for that is change process in function of machine 2 Blcoks or machine 1 block
	gSimpleBlock[1].parameters.iMotorAxisIndex := 2;
	
	////////////////////////////////////////////////////////////
	/////BLOCK	BLOCK	BLOCK	BLOCK	BLOCK	BLOCK///////////
	////////////////////////////////////////////////////////////
	FOR iIndexBlock:=1 TO gDryer.Pt.CT.iNumBlocks DO
		
		gSimpleBlock[iIndexBlock].In.xDifferentialOK := TRUE;
		gSimpleBlock[iIndexBlock].In.xDriveProtectionOK := TRUE;
		gSimpleBlock[iIndexBlock].In.xSafetyOK := TRUE;

		gSimpleBlock[iIndexBlock].parameters.Hw.xExistBlock := gDryer.Pt.MachineModel = DryerType_NOZ2_NIR_ARCLAMP;
		
		gSimpleBlock[iIndexBlock].parSw.xEnableToMovements := TRUE;
		gSimpleBlock[iIndexBlock].parSw.xEnableToPrint := TRUE;
		
		gSimpleBlock[iIndexBlock].parameters.Motor.rDriveManSpeed		:=10.0;
		gSimpleBlock[iIndexBlock].parameters.Motor.rDriveAutoSpeed		:=30.0;
		gSimpleBlock[iIndexBlock].parameters.Motor.rMinThicknessMedia:= gDryer.Pt.CT.rMinThicknessMedia;
		gSimpleBlock[iIndexBlock].parameters.Motor.rReduceSpeedDistance :=6.0;
		gSimpleBlock[iIndexBlock].parameters.Motor.rAcceleration		:= 172.5;
		gSimpleBlock[iIndexBlock].parameters.Motor.rDeceleration		:= 172.5;
		
		//Position parameters (mm)
		gSimpleBlock[iIndexBlock].parameters.Motor.rSafePosition	:= 85.0;//Max heigh (theoretically 100)
		gSimpleBlock[iIndexBlock].parameters.Motor.rMinSafePosition	:= 10.0;	//Min heigh
		gSimpleBlock[iIndexBlock].parameters.Motor.rCapPosition		:= 80.0;//CAP 
		
		gSimpleBlock[iIndexBlock].parameters.Motor.DriveUnit.TransmissionType := TRANS_SCREW_PITCH;
		gSimpleBlock[iIndexBlock].parameters.Motor.DriveUnit.ScrewPitch.PulsesPerTurn := GC_UNITS_BY_REV_DRIVE;
		gSimpleBlock[iIndexBlock].parameters.Motor.DriveUnit.ScrewPitch.GearBox := 7.25;
		gSimpleBlock[iIndexBlock].parameters.Motor.DriveUnit.ScrewPitch.Pitch := 5.0;
		
		gSimpleBlock[iIndexBlock].parameters.Motor.rReferencePosition		:= 20.0;
		
		//Current Parameters
		gSimpleBlock[iIndexBlock].parameters.Motor.uiMaxCurrentBarsUp		:= 3;
		gSimpleBlock[iIndexBlock].parameters.Motor.uiMaxCurrentBarsDown		:= 1;

		gSimpleBlock[iIndexBlock].parameters.Motor.VerticalDirection:= MOTOR_POSITIVE;
		
	END_FOR

	///////////////////////////////////////////////////
	/////DING		DING		DING		DING  /////
	///////////////////////////////////////////////////	
	gDing.Parameters.xDingInstalled := FALSE;
	
	///////////////////////////////////////////////////
	//////// DETECTION  DETECTION  DETECTION  /////////
	///////////////////////////////////////////////////	

	gBasicDetectMedia.Parameters.xInstalled := TRUE;
	gBasicDetectMedia.Parameters.rCorrection := 12;

	
	/////////////////////////////////////////////////////
	/////   TRANSPORT_VACUUM  TRANSPORT_VACUUM   ////////
	/////////////////////////////////////////////////////
	gTransVacuum[1].Parameters.xInstalled := TRUE;
	gTransVacuum[1].Parameters.Hw.xSystemWithJoints := FALSE;
	gTransVacuum[1].Parameters.Hw.uiNumBlowers := 2;
	gTransVacuum[1].Parameters.Hw.BlowerData[1].iIndex := 1;
	gTransVacuum[1].Parameters.Hw.BlowerData[1].Direction := MOTOR_NEGATIVE;
	gTransVacuum[1].Parameters.Hw.BlowerData[2].iIndex := 2;
	gTransVacuum[1].Parameters.Hw.BlowerData[2].Direction := MOTOR_NEGATIVE;
	gTransVacuum[1].Parameters.xStartUpEnable := FALSE;
	gAxisInverter[gTransVacuum[1].Parameters.Hw.BlowerData[1].iIndex].Parameters.Hardware.CpuFamily := gDryer.St.HwData.Family;
	gAxisInverter[gTransVacuum[1].Parameters.Hw.BlowerData[2].iIndex].Parameters.Hardware.CpuFamily := gDryer.St.HwData.Family;

	
	/////////////////////////////////////////////////////
	///// ARCLAMP ARCLAMP ARCLAMP ARCLAMP ARCLAMP ///////
	/////////////////////////////////////////////////////
	
	gArcLampGew.Parameters.xInstalled := gDryer.Pt.MachineModel = DryerType_NOZ2_NIR_ARCLAMP;
	
	gArcLampGew.Parameters.CpuFamily := gDryer.St.HwData.Family;
	gArcLampGew.Parameters.iLampQuantity := 2;

	//With real machine, communications cannot be disabled
	IF gDryer.Pt.ConfigNameID <> GC_CONFIG_SIMDRYER_NOZ2_ID THEN
		gArcLampGew.Parameters.xDisableComms := FALSE;
	END_IF

	/////////////////////////////////////////////////////
	///// NIR NIR NIR NIR NIR NIR NIR NIR NIR NIR ///////
	/////////////////////////////////////////////////////
	gNirAdphos.Parameters.xInstalled := gDryer.Pt.MachineModel <> DryerNoType;
	
	gNirAdphos.Parameters.iTotalModules := 2;
	gNirAdphos.Parameters.CpuFamily := gDryer.St.HwData.Family;
	gNirAdphos.Parameters.rMaxSurfaceTemp := 50;
	
	gNirAdphos.Parameters.DDC.iLamps := 48;
	gNirAdphos.Parameters.DDC.pIntensityNir1 := ADR(gThicknessCtrl.status.Dry[1].Intensity);
	gNirAdphos.Parameters.DDC.pIntensityNir2 := ADR(gThicknessCtrl.status.Dry[2].Intensity);
	gNirAdphos.Parameters.DDC.rMinIntensityPercentage := 8.0;

	// Thermal inertia configuration
	// Assigning data just if no data to allow setting the data during research
	IF gDryer.Pt.ThermalInertia.iBoardsToStartReducing = 0 THEN
		gDryer.Pt.ThermalInertia.iBoardsToStartReducing := 60;
	END_IF
	IF gDryer.Pt.ThermalInertia.iBoardsToMaxPowerReduction = 0 THEN
		gDryer.Pt.ThermalInertia.iBoardsToMaxPowerReduction := 90;
	END_IF
	IF gDryer.Pt.ThermalInertia.rMaxPowerReduction = 0 THEN
		gDryer.Pt.ThermalInertia.rMaxPowerReduction := 0.85;
	END_IF
	
	
	
	/////////////////////////////////////////////////////
	/////MODEL	MODEL	MODEL	MODEL	MODEL	MODEL////
	/////////////////////////////////////////////////////
	
	//Configuring machine transport because some values are different in two blocks
	CASE gDryer.Pt.MachineModel OF
		DryerType_NOZ2_NIR,
		DryerType_NOZ2_NIR_ARCLAMP:
			gThicknessCtrl.parameters.iTotalBlocksLengh := 625;
			gThicknessCtrl.parameters.Belt.iDistanceEmptyBeltIni := 685;
	END_CASE;
	
	gThicknessCtrl.parameters.sections[1].xEnabled	:= TRUE;
	gThicknessCtrl.parameters.sections[1].iStart	:= 1;
	gThicknessCtrl.parameters.sections[1].iEnd		:= 250;
	
	gThicknessCtrl.parameters.Detection.Basic.xLoadMedia := TRUE;
	gThicknessCtrl.parameters.Detection.Basic.xEnableMediaTracking := TRUE;
	gThicknessCtrl.parameters.Detection.Basic.iMediaFilter := 1; // To avoid adding a 0 in the Tail section
	
	gThicknessCtrl.parameters.Dry.xEnableMediaTracking := TRUE;
	
	gThicknessCtrl.parameters.Dry.iLamps := 48;
	gThicknessCtrl.parameters.Dry.rLampOffset := -1435/2;
	gThicknessCtrl.parameters.Dry.rLampWidth := 1435.0/48.0;
	IF gThicknessCtrl.parameters.Dry.rThermalDelay = 0 THEN
		gThicknessCtrl.parameters.Dry.rThermalDelay := 500;
		gThicknessCtrl.parameters.Dry.rCommsDelay := 200;
	END_IF
	
	gThicknessCtrl.parameters.Dry.Dryers[1].iPosition := 290;
	gThicknessCtrl.parameters.Dry.Dryers[2].iPosition := 415;
	
	//gThicknessCtrl.parameters.CheckMedia[1].xActive := FALSE; // Deactivated due to sensor reading problems till new sensors will be implemented NOZDRYER-450
	gThicknessCtrl.parameters.CheckMedia[1].CheckPosition := 578;
	gThicknessCtrl.parameters.CheckMedia[1].CheckDelayPosition := 15;
	gThicknessCtrl.parameters.CheckMedia[2].CheckPosition := 578;
	gThicknessCtrl.parameters.CheckMedia[2].CheckDelayPosition := 15;
	gThicknessCtrl.parameters.CheckMedia[2].xActive := gDryer.Pt.SW.xDoubleLine;
	
	
	//Jam
	gJamDetect[1].Parameters.iSensorsQuantity := gDryer.Pt.CT.iNumSensorsPerJamDevice;
	gJamDetect[1].Parameters.xJamEnabled	:= TRUE;
	//There are no bars in the dryer, but to use this jam package, designed to be used one jam sensor per bar, we active 4 bars because we have 4 sensors. 2 per NIR module
	gJamDetect[1].Parameters.xBarInstalled[1]:= gNirAdphos.Parameters.xInstalled;
	gJamDetect[1].Parameters.xBarInstalled[2]:= gNirAdphos.Parameters.xInstalled;
	gJamDetect[1].Parameters.xBarInstalled[3]:= gNirAdphos.Parameters.xInstalled;
	gJamDetect[1].Parameters.xBarInstalled[4]:= gNirAdphos.Parameters.xInstalled;
	gJamDetect[1].Parameters.iLowJamCheckDuration[0] := T#1m;
	gJamDetect[1].Parameters.iLowJamTimes[0] := 3;
	gJamDetect[1].Parameters.iLowJamCheckDuration[1] := T#30m;
	gJamDetect[1].Parameters.iLowJamTimes[1] := 10;
	
END_ACTION
