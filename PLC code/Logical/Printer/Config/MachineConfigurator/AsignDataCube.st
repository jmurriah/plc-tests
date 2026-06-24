
ACTION AsignDataCube: 

	//Just writing the fixed configuration once per each 5s
	IF NOT (EDGEPOS(gPLC.xBlk_5s) OR gPLC.xFirst_Scan OR xChangedSimMachine) THEN
		RETURN;
	END_IF
	
	////////////////////////////////////////////////////////////
	/////GENERAL	GENERAL		GENERAL		GENERAL	////////////
	////////////////////////////////////////////////////////////
	
	gMachine.Pt.CT.rMinMountedPieceOverThick	:= gDing.Parameters.rOverThicknessToReject + 2;
	gMachine.Pt.CT.rMaxMountedPieceOverThick	:= 45.0;
	
	gMachine.Pt.xControlledRemotely := TRUE;
	gMachine.Pt.xDisableStartHoldingGreenButton := TRUE;
	gMachine.Pt.Clean.xEnabledCleanTotalTime := TRUE;
	
	gMachine.Pt.CT.rMountedMediaLevelInBypassMode		:= 145.0;
	gMachine.Pt.CT.rMaxTicknessMedia		:= 30.0;
	gMachine.Pt.CT.rMinTicknessMedia		:= 0.5;	
	gMachine.Pt.CT.iNumSAIInstalled			:= 1;
	
	gMachine.Pt.rMaxPrintHeadPos			:= 1318.0; //TOREVIEW
	gMachine.Pt.rMinPrintHeadPos			:= 10;
	gMachine.Pt.CT.rMinMarginPrinting		:= 1.7;
	gMachine.Pt.rBeltSpeedWhileEmptyBelt	:= 20.0; //m/min

	gMachine.Pt.iMediaFilter 				:= 20;
	gMachine.Pt.MachineLights 				:= MACHINE_LIGHTS_RGB;
	
	gMachine.parSw.rFirstHeadPosition 		:= 30.0; //[RGP] This parameter should not be written here. To remove after SW release
	gMachine.parSw.rLastHeadPosition 		:= 1290.0; //1580 //[RGP] This parameter should not be written here. To remove after SW release
	gMachine.parSw.xJamDetectEnable			:= TRUE;
	
	gMachine.Pt.PDSignalTpe 						:= PDCFG_SENSOR;
	gMachine.Pt.xProtectPHWithStoppedMediaBended	:= FALSE;
	gMachine.Pt.xProtectPHForBlowersRunning			:= TRUE;
	gMachine.Pt.Clean.xCleanBeltTopInstall 			:= FALSE;
	gMachine.Pt.xAllowLaboratory	 				:= FALSE;
	gMachine.Pt.xAllowJamRecovery	 				:= TRUE;
	gMachine.Pt.xAllowAutoStartUp					:= TRUE;
	gMachine.Pt.xDynamicPrePrintingPos				:= TRUE;
	gMachine.Pt.xJobNotReadyIsCritical	 			:= TRUE;
	gMachine.Pt.Clean.xCleanBeltForUv 				:= FALSE;
	gMachine.Pt.CommsType							:= Type_OpcUa;
	gMachine.Pt.MountedMedia.Type					:= THICKMOUNT_THICKNESS_RELATIVE;
	gMachine.Pt.MountedMedia.xDynamicMountedMedia	:= TRUE;
	gMachine.Pt.MountedMedia.Dynamic.rSpeedMinMounted := 20;
	gMachine.Pt.MountedMedia.Dynamic.rSpeedMaxMounted := 45;
	gMachine.Pt.MountedMedia.Dynamic.rMinOverThickMounted := 20;
	gMachine.Pt.MountedMedia.Dynamic.rMaxOverThickMounted := 40;
	
	gMachine.Pt.Cure.xForceMaxWidth	:= TRUE;
	gMachine.Pt.Cure.xCuringByStretchAllowed := FALSE;
	
	gMachine.Pt.Hw.iWidth					:= 1050;
	gMachine.Pt.Hw.rMinPrintPosition		:= 3.0;
	gMachine.Pt.Hw.iMaxCuringLedBars		:= 1;
	gMachine.Pt.Hw.xDoubleLineAllowed		:= FALSE;
	gMachine.Pt.Hw.xSuctionModeAllowed		:= FALSE;
	
	gMachine.St.HwData.xIsPlatform5			:= FALSE;
	gMachine.St.HwData.xIsWater				:= FALSE;
	gMachine.St.HwData.xIsCubik				:= FALSE;
	gMachine.St.HwData.xUpsOutOfPrinter		:= TRUE;
	FOR iIndexCuringLedLamps:=1 TO MAX_LAST_CURING_LED DO
		IF gCuringLed[iIndexCuringLedLamps].Parameters.CuringApplicationType = CURING_APP_WHITE THEN
			gMachine.St.White.xInstalled := TRUE;
		END_IF
	END_FOR
	
	//Belt. Just initial values if values are 0. Those values will be modified from Sw
	gBelt.parameters.xRemoteAcceleration := TRUE;
	gBelt.parameters.xRemoteDeceleration := TRUE;
	IF gBelt.parameters.rAcceleration = 0 THEN gBelt.parameters.rAcceleration := 1050; END_IF
	IF gBelt.parameters.rDeceleration = 0 THEN gBelt.parameters.rDeceleration := 2400; END_IF
	gBelt.parameters.tiTimeBeepBeforeMove := T#100ms;
	gBelt.parameters.rMaxAcceleration := 1500.0;
	gBelt.parameters.rMaxDeceleration := 2500.0;
	
	//Here are configured blocks in function of the machine direction
	//When machine is block then we need use correction as block physical 2 because PD is at the same distance than Block 1, for that is change process in function of machine 2 Blcoks or machine 1 block
	gBlock[1].parameters.iMotorAxisIndex := 2;
	gBlock[1].parameters.iMappingBlock := 1;
	gBlock[1].parameters.iIclaAxisIndex := 1;
	gBlock[1].parameters.Hw.ValvesCommsType := COMMS_POWERLINK;
	gBlock[1].parSw.xEnableToMovements := TRUE; //[RGP] This parameter should not be written here. To remove after SW release
	gBlock[1].parSw.xEnableToPrint := TRUE; //[RGP] This parameter should not be written here. To remove after SW release
	
	gMachine.parSw.xMachineDirection := FALSE; //Machine right hand //[RGP] This parameter should not be written here. To remove after SW release
	
	////////////////////////////////////////////////////////////
	/////BLOCK	BLOCK	BLOCK	BLOCK	BLOCK	BLOCK///////////
	////////////////////////////////////////////////////////////
	FOR iIndexBlock:=1 TO gMachine.Pt.CT.iNumBlocks DO
					
		//Position parameters (mm)
		gBlock[iIndexBlock].parameters.Motor.rSafePosition				:= 254.0; //Max heigh
		gBlock[iIndexBlock].parameters.Motor.rMinSafePosition			:= 2.0;	  //Min heigh
		gBlock[iIndexBlock].parameters.Motor.rCapPosition				:= 252.0; //CAP
		gBlock[iIndexBlock].parameters.Motor.rSafePositionCleanCarrier	:= 247.0; //Carrier out Safe
		gBlock[iIndexBlock].parameters.Motor.rDripBarsPosition			:= 200.0; //Drip
		gBlock[iIndexBlock].parameters.Motor.rCleanPosition				:= 251.0; //Clean
		gBlock[iIndexBlock].parameters.Motor.rWaterSpurtPosition		:= 250.0; //Water Spurt
		gBlock[iIndexBlock].parameters.rPrePrintingPos					:= 20.0;  //To be discussed with mechanical team
		
		gBlock[iIndexBlock].parameters.Motor.rAutoSpeedMoveDown	:= 30.0;
		gBlock[iIndexBlock].parameters.Motor.rAutoSpeedMoveUp	:= 30.0;
		IF gMachine.Pt.ConfigNameID <> GC_CONFIG_SIMTEST_ID THEN
			gBlock[iIndexBlock].parameters.Motor.rAutoSpeedMoveUpFast	:= 50.0;
		ELSE
			gBlock[iIndexBlock].parameters.Motor.rAutoSpeedMoveUpFast	:= gBlock[iIndexBlock].parameters.Motor.rAutoSpeedMoveUp + 1; //Modifying value in sim just for testing purposes
		END_IF
		gBlock[iIndexBlock].parameters.Motor.xFastSpeedAllowed	:= TRUE;
		gBlock[iIndexBlock].parameters.Motor.xOversized	:= TRUE;
		gBlock[iIndexBlock].parameters.Motor.rOperationTorque	:= 25.0; //Nm //To review
		
		gBlock[iIndexBlock].parameters.Motor.DriveUnit.TransmissionType := TRANS_SCREW_PITCH;
		gBlock[iIndexBlock].parameters.Motor.DriveUnit.ScrewPitch.PulsesPerTurn := GC_UNITS_BY_REV_DRIVE;
		gBlock[iIndexBlock].parameters.Motor.DriveUnit.ScrewPitch.GearBox := 7.25;
		gBlock[iIndexBlock].parameters.Motor.DriveUnit.ScrewPitch.Pitch := 5.0;
		
		gBlock[iIndexBlock].parameters.Motor.rReferencePosition			:= 15.5;
		
		//Current Parameters
		gBlock[iIndexBlock].parameters.Motor.uiMaxCurrentBarsUp			:= 3;
		gBlock[iIndexBlock].parameters.Motor.uiMaxCurrentBarsDown		:= 1;

		gBlock[iIndexBlock].parameters.Motor.VerticalDirection:= MOTOR_POSITIVE;
		
		gBlock[iIndexBlock].parameters.Motor.rAcceleration				:= 400; //To be discussed with mechanical team
		gBlock[iIndexBlock].parameters.Motor.rDeceleration				:= 172.5;

		gBlock[iIndexBlock].parameters.Icla.DriveUnit.TransmissionType:=TRANS_LINEAL_PERIMETER;
		gBlock[iIndexBlock].parameters.Icla.DriveUnit.LinealPerimeter.GearBox:=92;
		gBlock[iIndexBlock].parameters.Icla.DriveUnit.LinealPerimeter.Perimeter:=180;
		gBlock[iIndexBlock].parameters.Icla.DriveUnit.LinealPerimeter.PulsesPerTurn:=12;

		gBlock[iIndexBlock].parameters.Inks.iMaxMachinePrintBars	:= 5;
		gBlock[iIndexBlock].parameters.Inks.iMaxBlockPrintBars		:= 5;
		gBlock[iIndexBlock].parameters.Inks.iMaxPSUwattsForBars		:= 3000;
		
		gBlock[iIndexBlock].parameters.xCappingProcess := FALSE;
		gBlock[iIndexBlock].parameters.xWastedInkTankProcess := TRUE;

		gBlock[iIndexBlock].parameters.iFirstBarPosition := 23; //235mm
		gBlock[iIndexBlock].parameters.iLastBarPosition := 123; //1225mm
		
		gBlock[iIndexBlock].parameters.Hw.SafetySignals := SAFETY_ESTOP_CONNECTED;

		//[RGP] Due to issue SUSTPLATF-236
		gBlock[iIndexBlock].parameters.xMotorOffsetAllowed := FALSE;
		
		gBlock[iIndexBlock].parameters.iApplicationBars := 6;
	END_FOR
	
	FOR iIndexInks:=1 TO MAX_LAST_INK DO
		
		//assign values because in this machine they have not UI interface
		//TOREVIEW: Do we stop machine if enabled to print and not working????
		gInks[iIndexInks].parSw.xEnabledBarToPrint := TRUE;
		
		//If not in debug mode, assign values because in this machine they have not UI interface
		IF NOT gInks[iIndexInks].parameters.xDebugMode THEN
			gInks[iIndexInks].parSw.NegPump.rUpperLimMeniscusCritical := 60.0;
			gInks[iIndexInks].parSw.NegPump.rLowerLimMeniscusCritical := 0.0;
			gInks[iIndexInks].parSw.NegPump.rLimitMeniscusDiffWarning := 5.0;
		END_IF
		
	END_FOR
	
	
	///////////////////////////////////////////////////
	/////PHOTOCELLS		PHOTOCELLS		PHOTOCELLS/////
	///////////////////////////////////////////////////
	
	gPhotoCells.parameters.xInstall := FALSE;
	gMachine.parSw.Hw.xInstallnSensor := FALSE;
	
	///////////////////////////////////////////////////
	/////DING		DING		DING		DING  /////
	///////////////////////////////////////////////////
	gDing.Parameters.xDingInstalled := TRUE;
	gDing.Parameters.SensorType := ANSENS_BALLUF_48;

	gDing.Parameters.xRaiseDigitalIncoherency := FALSE;
	gDing.In.pInputCard := ADR(Pdc_X20AI2636_050);
	gDing.Parameters.rOverThicknessToReject := 5;
	gDing.Parameters.iAnalogSamples := 9;
	gDing.Parameters.xKeepHoming := TRUE;
	
	gDing.Parameters.rMarginSafeRejectForAnalog := 5;
	
	gDing.Parameters.xDiscreteBehavior := TRUE;
	gDing.Parameters.Discrete.rOffsetRelToBar := 0.5;
	gDing.Parameters.Discrete.rDistanceBetweenSensors := 1.5;
	gDing.Parameters.Discrete.iVirtualSensors := 30; // 45mm to mounted / 1.5mm between sensors is 30
	
	gDing.Parameters.MountedDetectionType := gMachine.Pt.MountedMedia.Type;
	
	gMachine.parSw.Hw.xInstallnSensor := FALSE;
	
	
	///////////////////////////////////////////////////
	/////THICKNESS		THICKNESS		 THICKNESS/////
	///////////////////////////////////////////////////
	
	//Configuring machine transport because some values are different in two blocks
	gThicknessCtrl.parameters.xMarginForBendTile := FALSE;
	
	gThicknessCtrl.parameters.iTotalBlocksLengh := 238; //Measured in first cube
	gThicknessCtrl.parameters.Belt.iDistanceEmptyBeltIni := 280; //Measured in first cube
	gThicknessCtrl.parameters.Belt.iBeltPerimeterLength := 638; //6377.72mm. Measured in first cube

	gThicknessCtrl.parameters.sections[1].xEnabled	:= TRUE;
	gThicknessCtrl.parameters.sections[1].iStart	:= 1;
	gThicknessCtrl.parameters.sections[1].iEnd		:= 250; //To review
	
	gThicknessCtrl.parameters.Detection.ProductDetect.xLoadMedia := TRUE;
	gThicknessCtrl.parameters.Detection.ProductDetect.iSensorPosition := 3; //35mm. Measured in first cube
	gThicknessCtrl.parameters.Detection.ProductDetect.xFixedSensor := TRUE;
	gThicknessCtrl.parameters.Detection.Analog.xLoadMedia := FALSE;
	gThicknessCtrl.parameters.Detection.Analog.iSensorPosition := 0; 
	gThicknessCtrl.parameters.Detection.Analog.iMediaFilter := 10;
	gThicknessCtrl.parameters.Detection.Array.xLoadMedia := FALSE;
	gThicknessCtrl.parameters.Detection.Array.iSensorPosition := 0;
	
	gThicknessCtrl.parameters.Detection.xEnabledStack := FALSE; //TRUE;
	gThicknessCtrl.parameters.Cure.xEnableMediaTracking := TRUE;
	gThicknessCtrl.parameters.Reject.xRejectTracking := TRUE;
	//gThicknessCtrl.parameters.Reject.iRejectDistance := 100; // This is to allow have traking longer than the machine and allow the ckeckMedia
	//gThicknessCtrl.parameters.Reject.iHoldRejectDistance := gThicknessCtrl.parameters.Reject.iRejectDistance;
	gStacker.Parameters.Hw.iRejectAdjustmentDistance := 70; // Vika is considered for Reject as an Stacker. So done directly here

	// Currently just installed in Gulliver, in their frame
	IF gMachine.Pt.MachineModel = Type_CUBE_GULLIVER OR gMachine.Pt.MachineModel = Type_CUBE_GULLIVER_INSPECTION THEN
		gThicknessCtrl.parameters.CheckMedia[1].xActive := TRUE;
		gThicknessCtrl.parameters.CheckMedia[1].xCheckGap := TRUE;
		gThicknessCtrl.parameters.CheckMedia[1].CheckPosition := 320;
		gThicknessCtrl.parameters.CheckMedia[1].CheckDelayPosition := 25;
		gThicknessCtrl.parameters.CheckMedia[1].iSensorFilter := 75; // Value in mm
	END_IF
	
	/////////////////////////////////////////////////////
	/////   TRANSPORT_VACUUM  TRANSPORT_VACUUM   ////////
	/////////////////////////////////////////////////////
	gMachine.Pt.Vacuum.xTransVacuumIndependenParams:=FALSE;
	gMachine.Pt.Vacuum.xStartBlowerGoingToPrint := TRUE;
	
	gTransVacuum[1].Parameters.xInstalled := TRUE;
	gTransVacuum[1].Parameters.Hw.xSystemWithJoints := FALSE;
	gTransVacuum[1].Parameters.Hw.uiNumBlowers := 2;
	gTransVacuum[1].Parameters.Hw.BlowerData[1].iIndex := 1;
	gTransVacuum[1].Parameters.Hw.BlowerData[1].Direction := MOTOR_NEGATIVE;
	gTransVacuum[1].Parameters.Hw.BlowerData[2].iIndex := 2;
	gTransVacuum[1].Parameters.Hw.BlowerData[2].Direction := MOTOR_POSITIVE;
	gTransVacuum[1].Parameters.xStartUpEnable := FALSE;
	gTransVacuum[1].Parameters.rMinVacPressureSetPointPerc := 4.0;
	gTransVacuum[1].Parameters.rMinDutyCycle := 10.0; // Increased to 100% to avoid reducing the desired speed so with so when entering a board, the inertia is so big we are getting overspeed 27/10/2023 Value requested by Eduardo
	gTransVacuum[1].Parameters.MinValvMask := 16#00007FFF;
	
	FOR iIndexTrVacc := 1 TO MAX_LAST_TRANS_VACUUM DO
		IF gTransVacuum[iIndexTrVacc].Parameters.parPID.rKp = 0 THEN 
			gTransVacuum[iIndexTrVacc].Parameters.parPID.rKp := 0.4;
			gTransVacuum[iIndexTrVacc].Parameters.parPID.rTi := 4.0;
			gTransVacuum[iIndexTrVacc].Parameters.parPID.rKd := 0.0;
			gTransVacuum[iIndexTrVacc].Parameters.parPID.rTd := 0.0;
		END_IF
		
		gTransVacuum[iIndexTrVacc].Parameters.rMaxSystemVacuum := 24.96; // 31.2; //3120Pa. //To review
		gTransVacuum[iIndexTrVacc].Parameters.rMaxSpeed := 2955;
		gTransVacuum[iIndexTrVacc].Parameters.rMaxPIDOut := 100.0;
	END_FOR
	
	gTransVacuum[1].Parameters.Hw.iTotalAreas := 0;
	gTransVacuum[1].Parameters.Hw.rAreaWidth := 0;
	gTransVacuum[1].Parameters.Hw.rCentralAreaWithoutVacuum := 0;

	
	/////////// CURING LED BARS ///////////
	iIndexWhiteCuringLedBar := 0;
	iIndexColorCuringLedBar := 0;
	
	CASE gMachine.Pt.MachineModel OF
		Type_CUBE,
		Type_CUBE_INSPECTION,
		Type_CUBE_GULLIVER,
		Type_CUBE_GULLIVER_INSPECTION:
			gMachine.Pt.Hw.iMaxCuringLedBars := 1;
			iIndexColorCuringLedBar := 1;
	END_CASE
	
	gCuringLed[iIndexColorCuringLedBar].Parameters.xInstalled := TRUE;
	gCuringLed[iIndexColorCuringLedBar].Parameters.iPowerSuppliesQuantity := 4;
	gCuringLed[iIndexColorCuringLedBar].Parameters.iLampsQuantity := 3;
	gCuringLed[iIndexColorCuringLedBar].Parameters.iCuringWindow := 80;
	gCuringLed[iIndexColorCuringLedBar].Parameters.rMinCureSpeed := 1;
	gCuringLed[iIndexColorCuringLedBar].Lamp[1].Parameters.iCuringLength := 350;
	gCuringLed[iIndexColorCuringLedBar].Lamp[2].Parameters.iCuringLength := 350;
	gCuringLed[iIndexColorCuringLedBar].Lamp[3].Parameters.iCuringLength := 350;	
	gCuringLed[iIndexColorCuringLedBar].Parameters.iCuringPosition := 183; //1852.5mm. Measured in first cube
	gCuringLed[iIndexColorCuringLedBar].Parameters.iChillerIndex := 1;
	gCuringLed[iIndexColorCuringLedBar].Parameters.CuringApplicationType := CURING_APP_COLOR;
	gCuringLed[iIndexColorCuringLedBar].Parameters.iMappingBar := 6;
	gCuringLed[iIndexColorCuringLedBar].Parameters.xPhysicalTempFeedback := FALSE;
	gCuringLed[iIndexColorCuringLedBar].Comms.Device.DeviceName := 'IF3.ST131.IF1.ST19.IF1';
	
	//CHILLER 
	gMachine.Pt.Hw.iMaxNumChillers:=1;	
	FOR iChillerIndex:=1 TO gMachine.Pt.Hw.iMaxNumChillers DO
		gChiller[iChillerIndex].Parameters.xInstalled := TRUE;
		gChiller[iChillerIndex].Parameters.xEnable := TRUE;
		gChiller[iChillerIndex].Parameters.SystemType := CHILLERSYS_DIRECT;
	END_FOR
	
	//Camera
	IF gMachine.Pt.MachineModel = Type_CUBE_INSPECTION OR gMachine.Pt.MachineModel = Type_CUBE_GULLIVER_INSPECTION THEN
		gCamera.Parameters.xInstalled := TRUE;
		gCamera.Parameters.iMappingBar := 7;
	END_IF
	// Powermeter
	gPowermeters[1].Parameters.xInstalled := TRUE;
	gPowermeters[2].Parameters.xInstalled := TRUE;
	
	//SafetyController
	gSafetyController.Parameters.xInstalled := TRUE;
	
	//AirCleaner
	gAirCleaner.Parameters.xInstalled := Pdc_X20DIF371_070.ModuleOk;
	gAirCleaner.Parameters.iIndex := 3;
	gAirCleaner.Parameters.Direction := MOTOR_POSITIVE; //Pending to test.
	gAirCleaner.Parameters.rMaxSpeed := 3543;
	
	
END_ACTION
