
ACTION AssignDataMecano: 

	//Just writing the fixed configuration once per each 5s
	IF gMachine.Pt.ConfigNameID <> GC_CONFIG_PLCDIAGNOSIS_ID AND NOT (EDGEPOS(gPLC.xBlk_5s) OR gPLC.xFirst_Scan OR xChangedSimMachine) THEN
		RETURN;
	END_IF
	
	////////////////////////////////////////////////////////////
	/////GENERAL	GENERAL		GENERAL		GENERAL	////////////
	////////////////////////////////////////////////////////////
	gMachine.Pt.xControlledRemotely := FALSE;
	gMachine.Pt.xDisableStartHoldingGreenButton := TRUE;
	
	gMachine.Pt.CT.rMountedMediaLevelInBypassMode		:= 145.0;
	gMachine.Pt.CT.rMaxTicknessMedia		:= 30.0;
	gMachine.Pt.CT.rMinTicknessMedia		:= 0.3;
	gMachine.Pt.CT.iNumSAIInstalled			:= 2;
	gMachine.Pt.CT.rDistanceThicknesToPD	:= 203.8;
	gMachine.Pt.CT.rDistanceBeltInitToPd	:= 2400; //To review
	
	gMachine.Pt.rMaxPrintHeadPos			:= 1900.0;
	gMachine.Pt.rMinPrintHeadPos			:= 10;
	gMachine.Pt.CT.rMinMarginPrinting		:= 1.7;
	gMachine.Pt.rBeltSpeedWhileEmptyBelt	:= 20.0; //m/min

	gMachine.Pt.iMediaFilter 				:= 20;
	
	gMachine.parSw.rFirstHeadPosition 		:= 30.0; //[RGP] This parameter should not be written here. To remove after SW release
	gMachine.parSw.rLastHeadPosition 		:= 1870; //[RGP] This parameter should not be written here. To remove after SW release
	gMachine.parSw.xJamDetectEnable			:= TRUE; //DELOREAN-1031 //[RGP] To discuss internally with plc team why is optional for BM machines and not for Nz2
	
	gMachine.Pt.PDSignalTpe 						:= PDCFG_SENSOR;
	gMachine.Pt.xProtectPHWithStoppedMediaBended	:= FALSE;
	gMachine.Pt.xProtectPHForBlowersRunning			:= TRUE;
	gMachine.Pt.Clean.xCleanBeltTopInstall 			:= FALSE;
	gMachine.Pt.xAllowLaboratory	 				:= FALSE;
	gMachine.Pt.xAllowJamRecovery	 				:= FALSE;
	gMachine.Pt.xDynamicPrePrintingPos				:= TRUE;
	gMachine.Pt.xJobNotReadyIsCritical	 			:= TRUE;
	gMachine.Pt.Clean.xCleanBeltForUv 				:= FALSE; //Set to FALSE due to DELOREAN-3204 //gMachine.Pt.MachineModel <> Type_NOZ_2_AQ;
	gMachine.Pt.CommsType							:= Type_OpcUa;
	
	gMachine.Pt.Cure.xCuringByStretchAllowed := TRUE;
	
	gMachine.Pt.Hw.iWidth					:= 1700;
	gMachine.Pt.Hw.rMinPrintPosition		:= 2.0; //To review regarding SD requirements. Min thickness 0.3 and minimum jetting gap is 1.7, but may be changed in the future 
	gMachine.Pt.Hw.xDoubleLineAllowed		:= FALSE;
	gMachine.Pt.Hw.xSuctionModeAllowed		:= TRUE;
	
	gMachine.St.HwData.xIsPlatform5			:= FALSE;
	gMachine.St.HwData.xIsWater				:= gMachine.Pt.MachineModel=Type_NOZ_2_AQ;
	gMachine.St.HwData.xIsCubik				:= FALSE;
	gMachine.St.HwData.xUpsOutOfPrinter		:= Pdc_X20DIF371_040.ModuleOk; //Codified card used when UPS are installed inside the PDC
	
	gMachine.St.White.xInstalled := FALSE;
	gMachine.St.Color.xInstalled := FALSE;
	gMachine.St.Clear.xInstalled := FALSE;
	FOR iIndexCuringLedLamps:=1 TO MAX_LAST_CURING_LED DO
		IF gCuringLed[iIndexCuringLedLamps].Parameters.CuringApplicationType = CURING_APP_WHITE THEN
			gMachine.St.White.xInstalled := TRUE;
		ELSIF gCuringLed[iIndexCuringLedLamps].Parameters.CuringApplicationType = CURING_APP_PRIMER THEN
			gMachine.St.Clear.xInstalled := TRUE;
		ELSIF gCuringLed[iIndexCuringLedLamps].Parameters.CuringApplicationType = CURING_APP_COLOR THEN
			gMachine.St.Color.xInstalled := TRUE;
		END_IF
	END_FOR
	
	
	//Belt
	gBelt.parameters.xRemoteAcceleration := FALSE;
	gBelt.parameters.xRemoteDeceleration := FALSE;
	gBelt.parameters.rAcceleration := 1050; 
	gBelt.parameters.rDeceleration := 2400;
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
	
	gMachine.parSw.xMachineDirection := TRUE; //Machine from left //[RGP] This parameter should not be written here. To remove after SW release
	
	////////////////////////////////////////////////////////////
	/////BLOCK	BLOCK	BLOCK	BLOCK	BLOCK	BLOCK///////////
	////////////////////////////////////////////////////////////
	FOR iIndexBlock:=1 TO gMachine.Pt.CT.iNumBlocks DO
					
		//Position parameters (mm)
		gBlock[iIndexBlock].parameters.Motor.rSafePosition				:= 356.0;	//Max heigh
		gBlock[iIndexBlock].parameters.Motor.rMinSafePosition			:= 2.0;		//Min heigh
		gBlock[iIndexBlock].parameters.Motor.rCapPosition				:= 344.0;	//CAP
		gBlock[iIndexBlock].parameters.Motor.rCappingPosition			:= 251.0; 	//CAPPING
		gBlock[iIndexBlock].parameters.Motor.rSafePositionCleanCarrier	:= 329.0;	//Carrier out Safe
		gBlock[iIndexBlock].parameters.Motor.rDripBarsPosition			:= 279.0;	//Drip
		gBlock[iIndexBlock].parameters.Motor.rCleanPosition				:= 335.0; 	//Clean
		gBlock[iIndexBlock].parameters.Motor.rWaterSpurtPosition		:= 342.0;	//Water Spurt
			
		gBlock[iIndexBlock].parameters.Motor.rAutoSpeedMoveDown	:=30.0;
		gBlock[iIndexBlock].parameters.Motor.rAutoSpeedMoveUp	:=30.0;
		IF gMachine.Pt.ConfigNameID <> GC_CONFIG_SIMTEST_ID THEN
			gBlock[iIndexBlock].parameters.Motor.rAutoSpeedMoveUpFast	:= 50.0;
		ELSE
			gBlock[iIndexBlock].parameters.Motor.rAutoSpeedMoveUpFast	:= gBlock[iIndexBlock].parameters.Motor.rAutoSpeedMoveUp + 1; //Modifying value in sim just for testing purposes
		END_IF
		gBlock[iIndexBlock].parameters.Motor.xFastSpeedAllowed	:= TRUE;
		gBlock[iIndexBlock].parameters.Motor.xOversized	:= TRUE;
		gBlock[iIndexBlock].parameters.Motor.rOperationTorque	:= 10.0;
		gBlock[iIndexBlock].parameters.Motor.DriveUnit.TransmissionType := TRANS_SCREW_PITCH;
		gBlock[iIndexBlock].parameters.Motor.DriveUnit.ScrewPitch.PulsesPerTurn := GC_UNITS_BY_REV_DRIVE;
		gBlock[iIndexBlock].parameters.Motor.DriveUnit.ScrewPitch.GearBox := 5.2;
		gBlock[iIndexBlock].parameters.Motor.DriveUnit.ScrewPitch.Pitch := 5.0;
		
		gBlock[iIndexBlock].parameters.Motor.rReferencePosition			:= 15.5;
		
		//Current Parameters
		gBlock[iIndexBlock].parameters.Motor.uiMaxCurrentBarsUp			:= 3;
		gBlock[iIndexBlock].parameters.Motor.uiMaxCurrentBarsDown		:= 1;

		gBlock[iIndexBlock].parameters.Motor.VerticalDirection:= MOTOR_POSITIVE;
		
		gBlock[iIndexBlock].parameters.Motor.rAcceleration				:= 260; 
		gBlock[iIndexBlock].parameters.Motor.rDeceleration				:= 260;
		
		gBlock[iIndexBlock].parameters.Icla.DriveUnit.TransmissionType:=TRANS_LINEAL_PERIMETER;
		gBlock[iIndexBlock].parameters.Icla.DriveUnit.LinealPerimeter.GearBox:=92;
		gBlock[iIndexBlock].parameters.Icla.DriveUnit.LinealPerimeter.Perimeter:=180;
		gBlock[iIndexBlock].parameters.Icla.DriveUnit.LinealPerimeter.PulsesPerTurn:=12;

		gBlock[iIndexBlock].parameters.Inks.iMaxMachinePrintBars	:= 7;
		gBlock[iIndexBlock].parameters.Inks.iMaxBlockPrintBars		:= 7;
		gBlock[iIndexBlock].parameters.Inks.iMaxPSUwattsForBars		:= 3000;
		
		gBlock[iIndexBlock].parameters.xCappingProcess := FALSE; // Capping hardware removed from 14000LED Bill of materials. Not removed from code, just disabled (Nozomi-2150) //Machine.Pt.MachineModel=Type_NOZ_2_AQ;
		gBlock[iIndexBlock].parameters.xWastedInkTankProcess := TRUE;

		gBlock[iIndexBlock].parameters.iFirstBarPosition := 50; //512mm measured in 3D model by mechanical team
		gBlock[iIndexBlock].parameters.iLastBarPosition := 480; //2462mm measured in 3D model by mechanical team for eight bar position. This parameters consider distance till end of bars block
		
		gBlock[iIndexBlock].parameters.Hw.SafetySignals := SAFETY_ESTOP_CONNECTED;
		
		//[RGP] Due to issue SUSTPLATF-236
		gBlock[iIndexBlock].parameters.xMotorOffsetAllowed := FALSE;
		
		gBlock[iIndexBlock].parameters.iApplicationBars := 9;
	END_FOR
	
	FOR iIndexInks:=1 TO MAX_LAST_INK DO		
		//If not in debug mode, assign values because in this machine they have not UI interface
		IF NOT gInks[iIndexInks].parameters.xDebugMode THEN
			gInks[iIndexInks].parSw.NegPump.rUpperLimMeniscusCritical := 60.0;
			gInks[iIndexInks].parSw.NegPump.rLowerLimMeniscusCritical := -30.0; //0.0;
			gInks[iIndexInks].parSw.NegPump.rLimitMeniscusDiffWarning := 5.0;
		END_IF
	END_FOR
	
	
	///////////////////////////////////////////////////
	/////PHOTOCELLS		PHOTOCELLS		PHOTOCELLS/////
	///////////////////////////////////////////////////
	
	gPhotoCells.parameters.xInstall := TRUE;
	gMachine.parSw.Hw.xInstallnSensor := FALSE;
	gPhotoCells.parameters.xSensorsPosHybridBehaviour := TRUE;
	
	gPhotoCells.parameters.MotorType := STP_ICLA;
	gPhotoCells.parameters.AlignmentProcess := STP_ALIGNMENT_REQUIRED;
	
	gPhotoCells.parSw.rMechOffset := 0.0; //Forced here because this parameter is not allowed in this machine
	gPhotoCells.parameters.rDistanceBetweenSensors := 25;
	gPhotoCells.parameters.rSensorMechPositionMax := 75;
	gPhotoCells.parameters.rSensorTeoMechPositionAlignment := 68.4; //DELOREAN-3539
	gPhotoCells.parameters.rSensorMechPositionAlignmentMax := gPhotoCells.parameters.rSensorTeoMechPositionAlignment + gPhotoCells.parameters.rSensorMechToleranceAlignment;
	gPhotoCells.parameters.rSensorMechPositionAlignmentMin := gPhotoCells.parameters.rSensorTeoMechPositionAlignment - gPhotoCells.parameters.rSensorMechToleranceAlignment;
	
	gPhotoCells.parameters.Speed:=10;
	gPhotoCells.parameters.JogSpeed:= 10;
	gPhotoCells.parameters.Acceleration:=5;
	
	gPhotoCells.parameters.DriveUnit.TransmissionType := TRANS_SCREW_PITCH;
	gPhotoCells.parameters.DriveUnit.ScrewPitch.PulsesPerTurn := 12;
	gPhotoCells.parameters.DriveUnit.ScrewPitch.GearBox := 92;
	gPhotoCells.parameters.DriveUnit.ScrewPitch.Pitch := 4;
	
	IF gMachine.Pt.ConfigNameID = GC_CONFIG_SIMTEST_ID THEN
		// In Simulation 
		gPhotoCells.parameters.IndexIcla:=3;
	ELSE
		gPhotoCells.parameters.IndexIcla:=2;
	END_IF
	
	gPhotoCells.parameters.iSensorQuantity := 6;
	gPhotoCells.parameters.iSensorToReference := 1;
	gPhotoCells.parameters.rOffsetPosition := -0.5;
	gPhotoCells.parameters.rOffsetRelToBar := 0.5;
	gPhotoCells.parameters.rSensorMechPositionByPass := 65;
	gPhotoCells.parameters.Sensors[2].rDistanceRelativeToFirstSensor := 1.5;
	gPhotoCells.parameters.Sensors[3].rDistanceRelativeToFirstSensor := 3;
	gPhotoCells.parameters.Sensors[4].rDistanceRelativeToFirstSensor := 4.5;
	gPhotoCells.parameters.Sensors[5].rDistanceRelativeToFirstSensor := 6;
	gPhotoCells.parSw.Sensors[5].xToRejectMedia := TRUE;
	gPhotoCells.parameters.Sensors[6].rDistanceRelativeToFirstSensor := 21;
	gPhotoCells.parameters.xEnableMountedAlrByPass := FALSE;
	
	
	///////////////////////////////////////////////////
	/////DING		DING		DING		DING  /////
	///////////////////////////////////////////////////
	gDing.Parameters.xDingInstalled := FALSE;
	
	///////////////////////////////////////////////////
	/////THICKNESS		THICKNESS		 THICKNESS/////
	///////////////////////////////////////////////////
	
	//Configuring machine transport because some values are different in two blocks
	gThicknessCtrl.parameters.xMarginForBendTile := FALSE;
	
	gThicknessCtrl.parameters.iTotalBlocksLengh := 305;
	gThicknessCtrl.parameters.Belt.iDistanceEmptyBeltIni := 470; //This distance is mechanical. Not related with Reject. Reject MUST not be eadjusted with this
	gThicknessCtrl.parameters.Belt.iBeltPerimeterLength := 1275;

	gThicknessCtrl.parameters.sections[1].xEnabled	:= TRUE;
	gThicknessCtrl.parameters.sections[1].iStart	:= 1;
	gThicknessCtrl.parameters.sections[1].iEnd		:= 500;
	
	gThicknessCtrl.parameters.Detection.ProductDetect.xLoadMedia := TRUE;
	gThicknessCtrl.parameters.Detection.ProductDetect.iSensorPosition := 20;
	gThicknessCtrl.parameters.Detection.Analog.xLoadMedia := FALSE;
	gThicknessCtrl.parameters.Detection.Analog.iSensorPosition := 0;
	gThicknessCtrl.parameters.Detection.Array.xLoadMedia := FALSE;
	gThicknessCtrl.parameters.Detection.Array.iSensorPosition := 0;

	gThicknessCtrl.parameters.Reject.xRejectTracking := TRUE;
	
	/////////////////////////////////////////////////////
	/////   TRANSPORT_VACUUM  TRANSPORT_VACUUM   ////////
	/////////////////////////////////////////////////////
	gMachine.Pt.Vacuum.xTransVacuumIndependenParams:=FALSE;
	
	gTransVacuum[1].Parameters.xInstalled := TRUE;
	gTransVacuum[1].Parameters.Hw.xSystemWithJoints := TRUE;
	gTransVacuum[1].Parameters.Hw.uiNumBlowers := 2;
	gTransVacuum[1].Parameters.Hw.BlowerData[1].iIndex := 1;
	gTransVacuum[1].Parameters.Hw.BlowerData[2].iIndex := 4;
	
	gTransVacuum[1].Parameters.Hw.BlowerData[1].Direction := MOTOR_NEGATIVE;
	gTransVacuum[1].Parameters.Hw.BlowerData[2].Direction := MOTOR_POSITIVE;
	
	gTransVacuum[1].Parameters.xStartUpEnable := FALSE;
	gTransVacuum[1].Parameters.rMinVacPressureSetPointPerc := 4.0;
	gTransVacuum[1].Parameters.rMinDutyCycle := 20.0;
	
	gTransVacuum[2].Parameters.xInstalled := TRUE;
	gTransVacuum[2].Parameters.Hw.xSystemWithJoints := TRUE;
	gTransVacuum[2].Parameters.Hw.uiNumBlowers := 2;
	gTransVacuum[2].Parameters.Hw.BlowerData[1].iIndex := 2;
	gTransVacuum[2].Parameters.Hw.BlowerData[2].iIndex := 3;
	gTransVacuum[2].Parameters.Hw.BlowerData[1].Direction := MOTOR_POSITIVE;
	gTransVacuum[2].Parameters.Hw.BlowerData[2].Direction := MOTOR_NEGATIVE;
	gTransVacuum[2].Parameters.xStartUpEnable := FALSE;
	gTransVacuum[2].Parameters.rMinVacPressureSetPointPerc := 4.0;
	gTransVacuum[2].Parameters.rMinDutyCycle := 20.0;
	
	FOR iIndexTrVacc := 1 TO MAX_LAST_TRANS_VACUUM DO
		gTransVacuum[iIndexTrVacc].Parameters.parPID.rKp := 0.4; //0.5;
		gTransVacuum[iIndexTrVacc].Parameters.parPID.rTi := 1.5;
		gTransVacuum[iIndexTrVacc].Parameters.parPID.rKd := 0.0;
		gTransVacuum[iIndexTrVacc].Parameters.parPID.rTd := 0.0;
		
		gTransVacuum[iIndexTrVacc].Parameters.rMaxSystemVacuum := 31.2; //DELOREAN-2860: Modified from 2400Pa to 3120Pa
		gTransVacuum[iIndexTrVacc].Parameters.rMaxSpeed := 3000;
		gTransVacuum[iIndexTrVacc].Parameters.rMaxPIDOut := 100.0;
	END_FOR
	
	// The rule for this parameter is (iTotalAreas -1) x rAreaWidth + rCentralAreaWithoutVacuum = vaccum width -> 17 x 68 + 495 = 1.651 distance from simetric max width slots
	gTransVacuum[1].Parameters.Hw.iTotalAreas := 18;
	gTransVacuum[1].Parameters.Hw.rAreaWidth := 68;
	gTransVacuum[1].Parameters.Hw.rCentralAreaWithoutVacuum := 495;
	
	
	/////////// CURING LED BARS ///////////
	iIndexWhiteCuringLedBar := 0;
	iIndexColorCuringLedBar := 0;
	iIndexPrimerCuringLedBar := 0;
	
	CASE gMachine.Pt.MachineModel OF

		Type_MECANO_UV_WHITE:
			gMachine.Pt.Hw.iMaxCuringLedBars := 2;
			IF gMachine.Pt.ConfigNameID <> GC_CONFIG_SIMTEST_ID THEN
				IF X20CS1030_180.ModuleOk THEN
					iIndexWhiteCuringLedBar := 1;
					iIndexColorCuringLedBar := 2;
				ELSE
					iIndexColorCuringLedBar := 1;
				END_IF
				
			ELSE
				iIndexWhiteCuringLedBar := 1;
				iIndexColorCuringLedBar := 2;
			END_IF
			
		Type_MECANO_UV_OPV:
			gMachine.Pt.Hw.iMaxCuringLedBars := 2;
			iIndexColorCuringLedBar := 1;
			IF X20CS1030_181.ModuleOk THEN
				iIndexPrimerCuringLedBar := 2;
			END_IF
			
			
		Type_MECANO_UV_WHITE_OPV:
			gMachine.Pt.Hw.iMaxCuringLedBars := 3;
			IF gMachine.Pt.ConfigNameID <> GC_CONFIG_SIMTEST_ID THEN
				IF X20CS1030_180.ModuleOk THEN
					iIndexWhiteCuringLedBar := 1;
					iIndexColorCuringLedBar := 2;
					IF X20CS1030_181.ModuleOk THEN
						iIndexPrimerCuringLedBar := 3;
					END_IF
				ELSE
					iIndexColorCuringLedBar := 1;
					IF X20CS1030_181.ModuleOk THEN
						iIndexPrimerCuringLedBar := 2;
					END_IF
				END_IF
				
			ELSE
				iIndexWhiteCuringLedBar := 1;
				iIndexColorCuringLedBar := 2;
				iIndexPrimerCuringLedBar := 3;
			END_IF
		
		END_CASE	
	
	//Curing leds
	IF gMachine.Pt.ConfigNameID <> GC_CONFIG_SIMTEST_ID THEN
		gCuringLed[iIndexWhiteCuringLedBar].Parameters.xInstalled := X20CS1030_180.ModuleOk;
	ELSE
		gCuringLed[iIndexWhiteCuringLedBar].Parameters.xInstalled := (gMachine.Pt.MachineModel=Type_MECANO_UV_WHITE OR gMachine.Pt.MachineModel=Type_MECANO_UV_WHITE_OPV);
	END_IF	
	gCuringLed[iIndexWhiteCuringLedBar].Parameters.iPowerSuppliesQuantity := 4;
	gCuringLed[iIndexWhiteCuringLedBar].Parameters.iLampsQuantity := 5;
	gCuringLed[iIndexWhiteCuringLedBar].Parameters.iCuringWindow := 40;
	gCuringLed[iIndexWhiteCuringLedBar].Parameters.rMinCureSpeed := 1;
	gCuringLed[iIndexWhiteCuringLedBar].Lamp[1].Parameters.iCuringLength := 350;
	gCuringLed[iIndexWhiteCuringLedBar].Lamp[2].Parameters.iCuringLength := 350;
	gCuringLed[iIndexWhiteCuringLedBar].Lamp[3].Parameters.iCuringLength := 350;
	gCuringLed[iIndexWhiteCuringLedBar].Lamp[4].Parameters.iCuringLength := 350;
	gCuringLed[iIndexWhiteCuringLedBar].Lamp[5].Parameters.iCuringLength := 350;
	gCuringLed[iIndexWhiteCuringLedBar].Parameters.iCuringPosition := 55;
	gCuringLed[iIndexWhiteCuringLedBar].Parameters.iChillerIndex := 2;
	gCuringLed[iIndexWhiteCuringLedBar].Parameters.CuringApplicationType := CURING_APP_WHITE;
	gCuringLed[iIndexWhiteCuringLedBar].Parameters.iMappingBar := 9;
	gCuringLed[iIndexWhiteCuringLedBar].Parameters.xPhysicalTempFeedback := FALSE;
	gCuringLed[iIndexWhiteCuringLedBar].Comms.Device.DeviceName := 'IF3.ST131.IF1.ST80.IF1';
	
	
	//OVCMYK curing led
	gCuringLed[iIndexColorCuringLedBar].Parameters.xInstalled := TRUE;
	gCuringLed[iIndexColorCuringLedBar].Parameters.iPowerSuppliesQuantity := 6;
	gCuringLed[iIndexColorCuringLedBar].Parameters.iLampsQuantity := 5;
	gCuringLed[iIndexColorCuringLedBar].Parameters.iCuringWindow := 80;
	gCuringLed[iIndexColorCuringLedBar].Parameters.rMinCureSpeed := 1;
	gCuringLed[iIndexColorCuringLedBar].Lamp[1].Parameters.iCuringLength := 350;
	gCuringLed[iIndexColorCuringLedBar].Lamp[2].Parameters.iCuringLength := 350;
	gCuringLed[iIndexColorCuringLedBar].Lamp[3].Parameters.iCuringLength := 350;
	gCuringLed[iIndexColorCuringLedBar].Lamp[4].Parameters.iCuringLength := 350;
	gCuringLed[iIndexColorCuringLedBar].Lamp[5].Parameters.iCuringLength := 350;
	gCuringLed[iIndexColorCuringLedBar].Parameters.iCuringPosition := 230;
	gCuringLed[iIndexColorCuringLedBar].Parameters.iChillerIndex := 1;
	gCuringLed[iIndexColorCuringLedBar].Parameters.CuringApplicationType := CURING_APP_COLOR;
	IF gMachine.Pt.MachineModel = Type_MECANO_UV_WHITE THEN
		gCuringLed[iIndexColorCuringLedBar].Parameters.iMappingBar := 2;
	ELSE
		gCuringLed[iIndexColorCuringLedBar].Parameters.iMappingBar := 4;
	END_IF
	gCuringLed[iIndexColorCuringLedBar].Parameters.xPhysicalTempFeedback := FALSE;
	gCuringLed[iIndexColorCuringLedBar].Comms.Device.DeviceName := 'IF3.ST131.IF1.ST62.IF1';
	
	
	//Primer curing led
	IF gMachine.Pt.ConfigNameID <> GC_CONFIG_SIMTEST_ID THEN
		gCuringLed[iIndexPrimerCuringLedBar].Parameters.xInstalled := X20CS1030_181.ModuleOk;
	ELSE
		gCuringLed[iIndexPrimerCuringLedBar].Parameters.xInstalled := FALSE; //(gMachine.Pt.MachineModel=Type_MECANO_UV_OPV OR gMachine.Pt.MachineModel=Type_MECANO_UV_WHITE_OPV);
	END_IF
	gCuringLed[iIndexPrimerCuringLedBar].Parameters.iPowerSuppliesQuantity := 6;
	gCuringLed[iIndexPrimerCuringLedBar].Parameters.iLampsQuantity := 5;
	gCuringLed[iIndexPrimerCuringLedBar].Parameters.iCuringWindow := 80;
	gCuringLed[iIndexPrimerCuringLedBar].Parameters.rMinCureSpeed := 1;
	gCuringLed[iIndexPrimerCuringLedBar].Lamp[1].Parameters.iCuringLength := 350;
	gCuringLed[iIndexPrimerCuringLedBar].Lamp[2].Parameters.iCuringLength := 350;
	gCuringLed[iIndexPrimerCuringLedBar].Lamp[3].Parameters.iCuringLength := 350;
	gCuringLed[iIndexPrimerCuringLedBar].Lamp[4].Parameters.iCuringLength := 350;
	gCuringLed[iIndexPrimerCuringLedBar].Lamp[5].Parameters.iCuringLength := 350;
	gCuringLed[iIndexPrimerCuringLedBar].Parameters.iCuringPosition := 290;
	gCuringLed[iIndexPrimerCuringLedBar].Parameters.iChillerIndex := 2;
	gCuringLed[iIndexPrimerCuringLedBar].Parameters.CuringApplicationType := CURING_APP_PRIMER;
	gCuringLed[iIndexPrimerCuringLedBar].Parameters.iMappingBar := 2;
	gCuringLed[iIndexPrimerCuringLedBar].Parameters.xPhysicalTempFeedback := FALSE;
	gCuringLed[iIndexPrimerCuringLedBar].Comms.Device.DeviceName := 'IF3.ST131.IF1.ST81.IF1';
	
	
	//CHILLER 
	FOR iIndexInks:=1 TO MAX_LAST_INK DO		
		gInks[iIndexInks].parameters.PrintheadsChiller.iIndex:=1; //Chiller is just for printheads, not inks.
	END_FOR
	
	
	//In case there were more than one curing led bar, two chiller are required
	IF iIndexWhiteCuringLedBar>1 OR iIndexColorCuringLedBar>1 OR iIndexPrimerCuringLedBar>1 THEN
		gMachine.Pt.Hw.iMaxNumChillers:=2;
	ELSE
		gMachine.Pt.Hw.iMaxNumChillers:=1;
	END_IF
	
	//Same type for all chillers
	FOR iChillerIndex:=1 TO gMachine.Pt.Hw.iMaxNumChillers DO
		gChiller[iChillerIndex].Parameters.xInstalled := TRUE;
		gChiller[iChillerIndex].Parameters.xEnable := TRUE;
		gChiller[iChillerIndex].Parameters.SystemType := CHILLERSYS_DIRECT;
	END_FOR
		
	
	
	//Camera
	gCamera.Parameters.xInstalled := TRUE; //Camera wont be considered as installed in water's machine type till hardware will be installed on those already manufactured machines
	gCamera.Parameters.iMappingBar := 10; //Located outside the block, after all printing and curing bars. So 9 index for mapping.
	
	// Powermeter
	gPowermeters[1].Parameters.xInstalled := TRUE;
	
	//Edge hold down
	gEdgeHoldDown.parameters.iAdjustmentSystemsNumber := 2; //1: Elevation, 2: Width fitting
	
	//Paired icla motors
	IF gMachine.Pt.ConfigNameID <> GC_CONFIG_SIMTEST_ID THEN
		gEdgeHoldDown.parameters.xInstalled := X20DIF371_180.ModuleOk;
		gPairedMotors[1].parameters.IndexIclaMaster :=3;
		gPairedMotors[1].parameters.IndexIclaGear :=5;
		gPairedMotors[2].parameters.IndexIclaMaster :=4;
		gPairedMotors[2].parameters.IndexIclaGear :=6;
	ELSE
		gEdgeHoldDown.parameters.xInstalled := TRUE;
		gPairedMotors[1].parameters.IndexIclaMaster :=4;
		gPairedMotors[1].parameters.IndexIclaGear :=5;
		gPairedMotors[2].parameters.IndexIclaMaster :=6;
		gPairedMotors[2].parameters.IndexIclaGear :=7;
	END_IF
	
	gPairedMotors[1].parameters.rMechPositionMin := 15;
	gPairedMotors[1].parameters.rMechPositionMax := 57;
	gPairedMotors[1].parameters.xPositionSensorInstalled := FALSE;
	gPairedMotors[1].parameters.JogSpeed:= 5;
	gPairedMotors[1].Motor[1].iDirection := -1;
	gPairedMotors[1].Motor[1].rHomePosition := (-1)*gPairedMotors[1].parameters.rMechPositionMin;
	gPairedMotors[1].Motor[2].iDirection := -1;
	gPairedMotors[1].Motor[2].rHomePosition := (-1)*gPairedMotors[1].parameters.rMechPositionMin;
	
	gPairedMotors[2].parameters.rMechPositionMin := 435;
	gPairedMotors[2].parameters.rMechPositionMax := 1430;
	gPairedMotors[2].parameters.xPositionSensorInstalled := TRUE;
	gPairedMotors[2].parameters.JogSpeed:= 3;
	gPairedMotors[2].Motor[1].iDirection := -1;
	gPairedMotors[2].Motor[1].rHomePosition := (-1)*gPairedMotors[2].parameters.rMechPositionMax;
	gPairedMotors[2].Motor[2].iDirection := 1;
	gPairedMotors[2].Motor[2].rHomePosition := gPairedMotors[2].parameters.rMechPositionMax;
	
	//Assgigning parameters to all adjustment systems
	FOR iIndexEhdSubsystems:=1 TO gEdgeHoldDown.parameters.iAdjustmentSystemsNumber DO
		gPairedMotors[iIndexEhdSubsystems].parameters.xInstalled := gEdgeHoldDown.status.xInstalled;
		gPairedMotors[iIndexEhdSubsystems].parameters.xEnabled := gEdgeHoldDown.status.xEnabled;
		
		gPairedMotors[iIndexEhdSubsystems].parameters.Acceleration:=5;
		gPairedMotors[iIndexEhdSubsystems].parameters.iNumIclaMotors := 2;
		
		gPairedMotors[iIndexEhdSubsystems].parameters.DriveUnit.ScrewPitch.PulsesPerTurn := 12;
		gPairedMotors[iIndexEhdSubsystems].parameters.DriveUnit.ScrewPitch.GearBox := 92;
	END_FOR
	
	gPairedMotors[1].parameters.Speed:=10;
	gPairedMotors[1].parameters.DriveUnit.ScrewPitch.Pitch := 4;
	gPairedMotors[1].parameters.DriveUnit.TransmissionType := TRANS_SCREW_PITCH;
	
	gPairedMotors[2].parameters.Speed:=300;
	gPairedMotors[2].parameters.DriveUnit.ScrewPitch.Pitch := 355;
	gPairedMotors[2].parameters.DriveUnit.TransmissionType := TRANS_LINEAL_PERIMETER;
	
	
	//LINE
	IF gMachine.Pt.ConfigNameID <> GC_CONFIG_SIMTEST_ID THEN
		gSarm.Parameters.xInstalled := Pdc_X20DIF371_050.ModuleOk;
	END_IF
	
	//External devices power managed from line's cabinet (PDC)
	gLine.Parameters.ExternalDevices[0].xIsEngine:=FALSE; 	//Printer
	gLine.Parameters.ExternalDevices[0].tiDelay := t#3s;
	gLine.Parameters.ExternalDevices[1].xIsEngine:=TRUE;	//Primer
	gLine.Parameters.ExternalDevices[1].tiDelay := t#60s;
	gLine.Parameters.ExternalDevices[2].xIsEngine:=FALSE;	//Feeder
	gLine.Parameters.ExternalDevices[2].tiDelay := t#3s;
	gLine.Parameters.ExternalDevices[3].xIsEngine:=TRUE;	//Dryer - IR1
	gLine.Parameters.ExternalDevices[3].tiDelay := t#3s;
	gLine.Parameters.ExternalDevices[4].xIsEngine:=TRUE;	//Dryer - IR2
	gLine.Parameters.ExternalDevices[4].tiDelay := t#3s;
	gLine.Parameters.ExternalDevices[5].xIsEngine:=FALSE; 	//Dryer controls
	gLine.Parameters.ExternalDevices[5].tiDelay := t#3s;
	gLine.Parameters.ExternalDevices[6].xIsEngine:=FALSE; 	//Stacker
	gLine.Parameters.ExternalDevices[6].tiDelay := t#3s;
	gLine.Parameters.ExternalDevices[7].xIsEngine:=FALSE; 	//UV
	gLine.Parameters.ExternalDevices[7].tiDelay := t#3s;
	gLine.Parameters.ExternalDevices[8].xIsEngine:=FALSE;	//Chiller
	gLine.Parameters.ExternalDevices[8].tiDelay := t#3s;
	gLine.Parameters.ExternalDevices[9].xIsEngine:=FALSE;	//Hoopers
	gLine.Parameters.ExternalDevices[9].tiDelay := t#3s;
	gLine.Parameters.ExternalDevices[10].xIsEngine:=TRUE;	//OPV
	gLine.Parameters.ExternalDevices[10].tiDelay := t#3s;
	gLine.Parameters.ExternalDevices[11].xIsEngine:=FALSE;	//Sarm
	gLine.Parameters.ExternalDevices[11].tiDelay := t#3s;
	
	// Assign total Devices
	gLine.Parameters.iNumExternalDevices := 11; //This is the trigger to start. Set the value once all others are properly assigned
	
	//SafetyController
	gSafetyController.Parameters.xInstalled := TRUE;
	
	/////////////////////////////////////////////////////
	/////   PLC CARDS	PLC CARDS	PLC CARDS	 ////////
	/////////////////////////////////////////////////////
	IF gPlcCards[0].Type <> CARD_UNDEFINED THEN
		RETURN;
	END_IF
	
	//Force "ModuleOk" in cards without it
	X20CPUData.ModuleOk := TRUE;
	
	//AsignCardsNozomi2;
	
END_ACTION
