
ACTION AsignDataNozomi2: 

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
	
	gMachine.Pt.rMaxPrintHeadPos			:= 1668.0;
	gMachine.Pt.rMinPrintHeadPos			:= 10;
	gMachine.Pt.CT.rMinMarginPrinting		:= 1.7;
	gMachine.Pt.rBeltSpeedWhileEmptyBelt	:= 30.0; //m/min

	gMachine.Pt.iMediaFilter 				:= 20;
	gMachine.Pt.MachineLights 				:= MACHINE_LIGHTS_BEACON;
	
	gMachine.parSw.rFirstHeadPosition 		:= 30.0; //[RGP] This parameter should not be written here. To remove after SW release
	gMachine.parSw.rLastHeadPosition 		:= 1640.0; //1580 //[RGP] This parameter should not be written here. To remove after SW release
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
	
	gMachine.Pt.Hw.iWidth					:= 1400;
	gMachine.Pt.Hw.rMinPrintPosition		:= 2.0; //To review regarding SD requirements. Min thickness 0.3 and minimum jetting gap is 1.7, but may be changed in the future 
	gMachine.Pt.Hw.iMaxCuringLedBars		:= 2;
	gMachine.Pt.Hw.xDoubleLineAllowed		:= TRUE;
	gMachine.Pt.Hw.xSuctionModeAllowed		:= TRUE;
	
	gMachine.St.HwData.xIsPlatform5			:= FALSE;
	gMachine.St.HwData.xIsWater				:= gMachine.Pt.MachineModel=Type_NOZ_2_AQ;
	gMachine.St.HwData.xIsCubik				:= FALSE;
	gMachine.St.HwData.xUpsOutOfPrinter		:= Pdc_X20DIF371_040.ModuleOk; //Codified card used when UPS are installed inside the PDC
	FOR iIndexCuringLedLamps:=1 TO MAX_LAST_CURING_LED DO
		IF gCuringLed[iIndexCuringLedLamps].Parameters.CuringApplicationType = CURING_APP_WHITE THEN
			gMachine.St.White.xInstalled := TRUE;
		END_IF
	END_FOR
	
	
	//Belt
	gBelt.parameters.xRemoteAcceleration := FALSE;
	gBelt.parameters.xRemoteDeceleration := FALSE;
	gBelt.parameters.rAcceleration := 1050; 
	gBelt.parameters.rDeceleration := 2400; //Decceleration used for customer visits. Tested with Manolo at 75m/min.
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
		IF gMachine.Pt.MachineModel = Type_NOZ_2_AQ THEN
			gBlock[iIndexBlock].parameters.Motor.rCleanPosition			:= 340.0;
			gBlock[iIndexBlock].parameters.Motor.rMinCleanOffsetTech	:= -10.0;
		ELSE
			gBlock[iIndexBlock].parameters.Motor.rCleanPosition			:= 335.0; 	//Clean
		END_IF
		gBlock[iIndexBlock].parameters.Motor.rWaterSpurtPosition		:= 342.0;	//Water Spurt
			
		gBlock[iIndexBlock].parameters.Motor.rAutoSpeedMoveDown	:=30.0;
		gBlock[iIndexBlock].parameters.Motor.rAutoSpeedMoveUp	:=30.0;
		IF gMachine.Pt.ConfigNameID <> GC_CONFIG_SIMTEST_ID THEN
			gBlock[iIndexBlock].parameters.Motor.rAutoSpeedMoveUpFast	:= 50.0;
		ELSE
			gBlock[iIndexBlock].parameters.Motor.rAutoSpeedMoveUpFast	:= gBlock[iIndexBlock].parameters.Motor.rAutoSpeedMoveUp + 1; //Modifying value in sim just for testing purposes
		END_IF
		gBlock[iIndexBlock].parameters.Motor.xFastSpeedAllowed	:= TRUE;
		gBlock[iIndexBlock].parameters.Motor.DriveUnit.TransmissionType := TRANS_SCREW_PITCH;
		gBlock[iIndexBlock].parameters.Motor.DriveUnit.ScrewPitch.PulsesPerTurn := GC_UNITS_BY_REV_DRIVE;
		gBlock[iIndexBlock].parameters.Motor.DriveUnit.ScrewPitch.GearBox := 7.25;
		gBlock[iIndexBlock].parameters.Motor.DriveUnit.ScrewPitch.Pitch := 5.0;
		
		gBlock[iIndexBlock].parameters.Motor.rReferencePosition			:= 15.5;
		
		//Current Parameters
		gBlock[iIndexBlock].parameters.Motor.uiMaxCurrentBarsUp			:= 3;
		gBlock[iIndexBlock].parameters.Motor.uiMaxCurrentBarsDown		:= 1;

		gBlock[iIndexBlock].parameters.Motor.VerticalDirection:= MOTOR_POSITIVE;
		
		gBlock[iIndexBlock].parameters.Motor.rAcceleration				:= 260; //Theorical acceleration required for "7th laser mode". 260: Works fine till 50m/min. Original in BM: 172.5
		gBlock[iIndexBlock].parameters.Motor.rDeceleration				:= 260;
		
		gBlock[iIndexBlock].parameters.Icla.DriveUnit.TransmissionType:=TRANS_LINEAL_PERIMETER;
		gBlock[iIndexBlock].parameters.Icla.DriveUnit.LinealPerimeter.GearBox:=92;
		gBlock[iIndexBlock].parameters.Icla.DriveUnit.LinealPerimeter.Perimeter:=180;
		gBlock[iIndexBlock].parameters.Icla.DriveUnit.LinealPerimeter.PulsesPerTurn:=12;

		gBlock[iIndexBlock].parameters.Inks.iMaxMachinePrintBars	:= 8;
		gBlock[iIndexBlock].parameters.Inks.iMaxBlockPrintBars		:= 8;
		gBlock[iIndexBlock].parameters.Inks.iMaxPSUwattsForBars		:= 3000;
		
		gBlock[iIndexBlock].parameters.xCappingProcess := FALSE; // Capping hardware removed from 14000LED Bill of materials. Not removed from code, just disabled (Nozomi-2150) //Machine.Pt.MachineModel=Type_NOZ_2_AQ;
		gBlock[iIndexBlock].parameters.xWastedInkTankProcess := TRUE;

		gBlock[iIndexBlock].parameters.iFirstBarPosition := 50; //512mm measured in 3D model by mechanical team
		gBlock[iIndexBlock].parameters.iLastBarPosition := 480; //2462mm measured in 3D model by mechanical team for eight bar position. This parameters consider distance till end of bars block
		
		gBlock[iIndexBlock].parameters.Hw.SafetySignals := SAFETY_ESTOP_CONNECTED;
		
		gBlock[iIndexBlock].commands.xEnableCleaningWithWater := FALSE;

		//[RGP] Due to issue SUSTPLATF-236
		gBlock[iIndexBlock].parameters.xMotorOffsetAllowed := FALSE;
		
		gBlock[iIndexBlock].parameters.iApplicationBars := 8;
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
	gPhotoCells.parameters.xSensorsPosHybridBehaviour := gMachine.Pt.MachineModel<>Type_NOZ_2_AQ;
	
	gPhotoCells.parameters.MotorType := STP_ICLA;
	gPhotoCells.parameters.AlignmentProcess := STP_ALIGNMENT_REQUIRED;
	
	
	gPhotoCells.parSw.rMechOffset := 0.0;
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
	gPhotoCells.parameters.Sensors[1].xEnabled := TRUE;
	gPhotoCells.parameters.Sensors[2].rDistanceRelativeToFirstSensor := 1.5;
	gPhotoCells.parameters.Sensors[2].xEnabled := TRUE;
	gPhotoCells.parameters.Sensors[3].rDistanceRelativeToFirstSensor := 3;
	gPhotoCells.parameters.Sensors[3].xEnabled := TRUE;
	gPhotoCells.parameters.Sensors[4].rDistanceRelativeToFirstSensor := 4.5;
	gPhotoCells.parameters.Sensors[4].xEnabled := TRUE;
	gPhotoCells.parameters.Sensors[5].rDistanceRelativeToFirstSensor := 6;
	gPhotoCells.parSw.Sensors[5].xToRejectMedia := TRUE;
	gPhotoCells.parameters.Sensors[5].xEnabled := TRUE;
	gPhotoCells.parameters.Sensors[6].rDistanceRelativeToFirstSensor := 21;
	//gPhotoCells.parameters.Sensors[6].rSafetyOffset := 3;
	gPhotoCells.parameters.Sensors[6].xEnabled := TRUE;
	gPhotoCells.parameters.xEnableMountedAlrByPass := FALSE;
	
	//Digital Inputs
	gPhotoCells.Inputs.Signals.pInput[1] := ADR(X20DIF371_103.DInput[11]);
	gPhotoCells.Inputs.Signals.pInput[2] := ADR(X20DIF371_103.DInput[12]);
	gPhotoCells.Inputs.Signals.pInput[3] := ADR(X20DIF371_103.DInput[13]);
	gPhotoCells.Inputs.Signals.pInput[4] := ADR(X20DIF371_103.DInput[14]);
	gPhotoCells.Inputs.Signals.pInput[5] := ADR(X20DIF371_103.DInput[15]);
	gPhotoCells.Inputs.Signals.pInput[6] := ADR(X20DIF371_103.DInput[16]);
	gPhotoCells.Inputs.Signals.xSafetyEnable := gMachine.In.xSafetyEnabled;
	
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
	//Due to issue DELOREAN-433 blowers for UV and water moves in different directions
	IF (gMachine.Pt.MachineModel = Type_NOZ_2_AQ) THEN
		gTransVacuum[1].Parameters.Hw.BlowerData[1].Direction := MOTOR_NEGATIVE;
		gTransVacuum[1].Parameters.Hw.BlowerData[2].Direction := MOTOR_POSITIVE;
	ELSE
		gTransVacuum[1].Parameters.Hw.BlowerData[1].Direction := MOTOR_POSITIVE;
		gTransVacuum[1].Parameters.Hw.BlowerData[2].Direction := MOTOR_NEGATIVE;
	END_IF
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
	
	// The rule for this parameter is (iTotalAreas -1) x rAreaWidth + rCentralAreaWithoutVacuum = vaccum width
	gTransVacuum[1].Parameters.Hw.iTotalAreas := 20;
	gTransVacuum[1].Parameters.Hw.rAreaWidth := 68;
	gTransVacuum[1].Parameters.Hw.rCentralAreaWithoutVacuum := 87;
	
	
	/////////////////////////////////////////////////////
	/////   NON_CRASH    NON_CRASH    NON_CRASH  ////////
	/////////////////////////////////////////////////////
	gNonCrash[1].Parameters.xInstalled:= FALSE;
	
	IF gMachine.Pt.ConfigNameID = GC_CONFIG_SIMTEST_ID THEN
		// In Simulation 
		gNonCrash[1].Parameters.iIndexMotor:=6;
	ELSE
		gNonCrash[1].Parameters.iIndexMotor:=3;
	END_IF
	
	gNonCrash[1].Parameters.DriveUnit.TransmissionType:=TRANS_LINEAL_PERIMETER;
	gNonCrash[1].Parameters.DriveUnit.LinealPerimeter.GearBox:=30;
	//gNonCrash[1].Parameters.DriveUnit.LinealPerimeter.Perimeter:=500;
	gNonCrash[1].Parameters.DriveUnit.LinealPerimeter.PulsesPerTurn:=GC_UNITS_BY_REV_DRIVE;
	
	gNonCrash[1].Parameters.tiTorqueFilter := T#5s;
	
	gNonCrash[1].Parameters.rAcceleration := gBelt.parameters.rAcceleration;
	gNonCrash[1].Parameters.rDeceleration := gBelt.parameters.rDeceleration;
	
	gNonCrash[1].Parameters.MotorDirection := MOTOR_NEGATIVE;
	
	
	/////////////////////////////////////////////////////
	/////   CHILLER 	CHILLER 	CHILLER 	/////////
	/////////////////////////////////////////////////////
	CASE gMachine.Pt.MachineModel OF
		Type_NOZ_2_AQ:
			gMachine.Pt.Hw.iMaxNumChillers:=1;
			gChiller[1].Parameters.xInstalled := TRUE;
			gChiller[1].parSw.xEnable := TRUE; 
			gChiller[1].Parameters.SystemType := CHILLERSYS_DIRECT;
			
			FOR iIndexInks:=1 TO MAX_LAST_INK DO		
				gInks[iIndexInks].parameters.InksChiller.iIndex:=1;
				gInks[iIndexInks].parameters.PrintheadsChiller.iIndex:=1;
			END_FOR
			
		Type_NOZ_2_UV:
			gMachine.Pt.Hw.iMaxNumChillers:=1;
			gChiller[1].Parameters.xInstalled := TRUE;
			gChiller[1].Parameters.xEnable := gCuringLed[iIndexColorCuringLedBar].Parameters.xEnabled;
			gChiller[1].Parameters.SystemType := CHILLERSYS_DIRECT;
			
		Type_NOZ_2_UV_White:
			gMachine.Pt.Hw.iMaxNumChillers:=2;
			gChiller[1].Parameters.xInstalled := TRUE;
			gChiller[1].Parameters.xEnable := gCuringLed[iIndexColorCuringLedBar].Parameters.xEnabled;
			gChiller[1].Parameters.SystemType := CHILLERSYS_DIRECT;
			gChiller[2].Parameters.xInstalled := TRUE;
			gChiller[2].Parameters.xEnable := gCuringLed[iIndexWhiteCuringLedBar].Parameters.xEnabled;
			gChiller[2].Parameters.SystemType := CHILLERSYS_DIRECT;
		
		
	END_CASE
	
	/////////// CURING LED BARS ///////////
	iIndexWhiteCuringLedBar := 0;
	iIndexColorCuringLedBar := 0;
	
	CASE gMachine.Pt.MachineModel OF
		Type_NOZ_2_AQ:
			gMachine.Pt.Hw.iMaxCuringLedBars := 0;
			
		Type_NOZ_2_UV:
			gMachine.Pt.Hw.iMaxCuringLedBars := 1;
			iIndexColorCuringLedBar := 1;
			gCuringLed[iIndexColorCuringLedBar].Parameters.iChillerIndex := 1;
			
		Type_NOZ_2_UV_White:
			gMachine.Pt.Hw.iMaxCuringLedBars := 2;
			iIndexWhiteCuringLedBar := 1;
			gCuringLed[iIndexWhiteCuringLedBar].Parameters.iChillerIndex := 2;
			iIndexColorCuringLedBar := 2;
			gCuringLed[iIndexColorCuringLedBar].Parameters.iChillerIndex := 1;
			
	END_CASE	
	
	//White curing led
	gCuringLed[iIndexWhiteCuringLedBar].Parameters.xInstalled := gMachine.Pt.MachineModel=Type_NOZ_2_UV_White;	
	gCuringLed[iIndexWhiteCuringLedBar].Parameters.iPowerSuppliesQuantity := 4;
	gCuringLed[iIndexWhiteCuringLedBar].Parameters.iLampsQuantity := 4;
	gCuringLed[iIndexWhiteCuringLedBar].Parameters.iCuringWindow := 40;
	gCuringLed[iIndexWhiteCuringLedBar].Parameters.rMinCureSpeed := 1;
	gCuringLed[iIndexWhiteCuringLedBar].Lamp[1].Parameters.iCuringLength := 350;
	gCuringLed[iIndexWhiteCuringLedBar].Lamp[2].Parameters.iCuringLength := 350;
	gCuringLed[iIndexWhiteCuringLedBar].Lamp[3].Parameters.iCuringLength := 350;
	gCuringLed[iIndexWhiteCuringLedBar].Lamp[4].Parameters.iCuringLength := 350;
	gCuringLed[iIndexWhiteCuringLedBar].Parameters.iCuringPosition := 80;
	gCuringLed[iIndexWhiteCuringLedBar].Parameters.CuringApplicationType := CURING_APP_WHITE;
	gCuringLed[iIndexWhiteCuringLedBar].Parameters.iMappingBar := 7;
	gCuringLed[iIndexWhiteCuringLedBar].Parameters.xPhysicalTempFeedback := TRUE;
	gCuringLed[iIndexWhiteCuringLedBar].Comms.Device.DeviceName := 'IF3.ST131.IF1.ST51.IF1';
	
	//OVCMYK curing led
	gCuringLed[iIndexColorCuringLedBar].Parameters.xInstalled := (gMachine.Pt.MachineModel=Type_NOZ_2_UV OR gMachine.Pt.MachineModel=Type_NOZ_2_UV_White);
	gCuringLed[iIndexColorCuringLedBar].Parameters.iPowerSuppliesQuantity := 6;
	gCuringLed[iIndexColorCuringLedBar].Parameters.iLampsQuantity := 4;
	gCuringLed[iIndexColorCuringLedBar].Parameters.iCuringWindow := 80;
	gCuringLed[iIndexColorCuringLedBar].Parameters.rMinCureSpeed := 1;
	gCuringLed[iIndexColorCuringLedBar].Lamp[1].Parameters.iCuringLength := 350;
	gCuringLed[iIndexColorCuringLedBar].Lamp[2].Parameters.iCuringLength := 350;
	gCuringLed[iIndexColorCuringLedBar].Lamp[3].Parameters.iCuringLength := 350;
	gCuringLed[iIndexColorCuringLedBar].Lamp[4].Parameters.iCuringLength := 350;	
	gCuringLed[iIndexColorCuringLedBar].Parameters.iCuringPosition := 265;
	gCuringLed[iIndexColorCuringLedBar].Parameters.CuringApplicationType := CURING_APP_COLOR;
	gCuringLed[iIndexColorCuringLedBar].Parameters.iMappingBar := 1;
	gCuringLed[iIndexColorCuringLedBar].Parameters.xPhysicalTempFeedback := TRUE;
	gCuringLed[iIndexColorCuringLedBar].Comms.Device.DeviceName := 'IF3.ST131.IF1.ST50.IF1';
	
	
	//Camera
	gCamera.Parameters.xInstalled := TRUE; // Installed in Water Alpha and Beta, pending to confirmation if mandatory at any case
	gCamera.Parameters.iMappingBar := 9; //Located outside the block, after all printing and curing bars. So 9 index for mapping.
	
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
	
	gPairedMotors[1].parameters.iNumIclaMotors := 2;
	gPairedMotors[1].parameters.xInstalled := gEdgeHoldDown.status.xEnabled;
	gPairedMotors[1].parameters.rMechPositionMin := 10;
	gPairedMotors[1].parameters.rMechPositionMax := 57;
	gPairedMotors[1].parameters.xPositionSensorInstalled := FALSE;
	gPairedMotors[1].parameters.JogSpeed:= 5;
	gPairedMotors[1].parameters.Acceleration:=5;
	gPairedMotors[1].Motor[1].iDirection := -1;
	gPairedMotors[1].Motor[1].rHomePosition := (-1)*gPairedMotors[1].parameters.rMechPositionMin;
	gPairedMotors[1].Motor[1].rMotorResolution := 0.25;
	gPairedMotors[1].Motor[2].iDirection := -1;
	gPairedMotors[1].Motor[2].rHomePosition := (-1)*gPairedMotors[1].parameters.rMechPositionMin;
	gPairedMotors[1].Motor[2].rMotorResolution := 0.25;
	
	gPairedMotors[2].parameters.iNumIclaMotors := 2;
	gPairedMotors[2].parameters.xInstalled := gEdgeHoldDown.status.xEnabled;
	gPairedMotors[2].parameters.rMechPositionMin := 0; //Distance between belt's center and the inner part of the metal strap/band
	gPairedMotors[2].parameters.rMechPositionMax := 528; //Distance between belt's center and the inner part of the metal strap/band
	gPairedMotors[2].parameters.xPositionSensorInstalled := TRUE;
	gPairedMotors[2].parameters.JogSpeed:= 100;
	gPairedMotors[2].parameters.Acceleration:=500;
	gPairedMotors[2].Motor[1].iDirection := -1;
	gPairedMotors[2].Motor[1].rHomePosition := (-1)*(gPairedMotors[2].parameters.rMechPositionMax);
	gPairedMotors[2].Motor[1].rMotorResolution := 0.25;
	gPairedMotors[2].Motor[2].iDirection := 1;
	gPairedMotors[2].Motor[2].rHomePosition :=  gPairedMotors[2].parameters.rMechPositionMax;
	gPairedMotors[2].Motor[2].rMotorResolution := 0.25;
	
	
	//Motor's transmission parameters
	gPairedMotors[1].parameters.Speed:=10;
	gPairedMotors[1].parameters.DriveUnit.ScrewPitch.Pitch := 4;
	gPairedMotors[1].parameters.DriveUnit.ScrewPitch.PulsesPerTurn := 12;
	gPairedMotors[1].parameters.DriveUnit.ScrewPitch.GearBox := 92;
	gPairedMotors[1].parameters.DriveUnit.TransmissionType := TRANS_SCREW_PITCH;
	
	gPairedMotors[2].parameters.Speed:=300;
	//Pulley perimeter: 180.013 mm. Position setpoint will be distance between metal straps.
	//As there are two slides which moves simetrically, we need to 
	gPairedMotors[2].parameters.DriveUnit.LinealPerimeter.Perimeter := 180.0131;
	gPairedMotors[2].parameters.DriveUnit.LinealPerimeter.PulsesPerTurn := 12;
	gPairedMotors[2].parameters.DriveUnit.LinealPerimeter.GearBox := 91.875;
	gPairedMotors[2].parameters.DriveUnit.TransmissionType := TRANS_LINEAL_PERIMETER;
	
	
	// Belt Clean water
	IF gMachine.Pt.MachineModel=Type_NOZ_2_AQ THEN
		gMachine.Pt.Clean.xCleanBeltWater := TRUE;
		gBeltClean.Parameters.xInstalled := TRUE;
	END_IF
	
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
	
	AsignCardsNozomi2;
	
END_ACTION

ACTION AsignCardsNozomi2:
	
	gPlcCards[0].Type := CARD_CPU0484;
	gPlcCards[0].pCard := ADR(X20CPUData);
	gPlcCards[0].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[0].stCardName := 'X20CP0484_000';
	gPlcCards[0].Location := CardInPDC;
	
	iIndexPlcCar := 1;
	// PDC - CARD 02 X20DIF371
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(Pdc_X20DIF371_002);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371-002';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'Machine Config-Bit 0';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'Machine Config-Bit 1';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'Machine Config-Bit 2';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'Machine Config-Bit 3';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'Machine Config-Bit 4';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'Machine Config-Bit 5';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'Feeder PS OK';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'Coater PS OK';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'Coater2 PS OK';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'Blower 1 printer PS OK';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'Blower 2 printer PS OK';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'Blower 3 printer PS OK';
	gPlcCards[iIndexPlcCar].Texts[13].Details := 'Blower 4 printer PS OK';
	gPlcCards[iIndexPlcCar].Texts[14].Details := 'Printer PS OK';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'Stacker PS OK';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'Overvoltage Protection';
	gPlcCards[iIndexPlcCar].Location := CardInPDC; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	// PDC - CARD 03 X20DIF371
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(Pdc_X20DIF371_003);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371-003';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'Hoopers feedback';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'PS 24V Start secuence OK)';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'UPS 3 -Utility Failure';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'UPS 3 -Inverter Failure';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'UPS 3 -Low Battery';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'UPS 3 -General Alarm';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'Main Fake Switch -Printer';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'Chiller Alarm 1';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'Chiller alarm 2';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'Chiller alarm 3';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'UV Curing PS OK';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'IR PS OK';
	gPlcCards[iIndexPlcCar].Texts[13].Details := 'IR2 PS OK';
	gPlcCards[iIndexPlcCar].Texts[14].Details := 'Dryer controls PS OK';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'Blower 1 dryer PS OK';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'Blower 2 dryer PS OK';
	gPlcCards[iIndexPlcCar].Location := CardInPDC; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	
	// PDC - CARD 04 X20DIF371
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(Pdc_X20DIF371_004);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371-004';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='Main Fake Switch -Dryer';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='Dryer critical error';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='Online Feeder';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='Error (abnormal condition) Feeder';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='Feeding Feeder';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='Multipick Feeder';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='Tray Empty Feeder';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='Media Low Feeder';
	gPlcCards[iIndexPlcCar].Texts[9].Details :='Media Thickness Feeder';
	gPlcCards[iIndexPlcCar].Texts[10].Details :='Ready to Feed Feeder';
	gPlcCards[iIndexPlcCar].Texts[11].Details :='ModelInput1 Feeder';
	gPlcCards[iIndexPlcCar].Texts[12].Details :='ModelInput2 Feeder';
	gPlcCards[iIndexPlcCar].Texts[13].Details :='ModelInput3 Feeder';
	gPlcCards[iIndexPlcCar].Texts[14].Details :='Ready to coat Primer';
	gPlcCards[iIndexPlcCar].Texts[15].Details :='Coating Primer';
	gPlcCards[iIndexPlcCar].Texts[16].Details :='Error Primer';
	gPlcCards[iIndexPlcCar].Location := CardInPDC; 
	iIndexPlcCar := iIndexPlcCar + 1;


	
	// PDC - CARD 05 X20DIF371
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(Pdc_X20DIF371_005);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371-005';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='Dryer in Run Mode Primer';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='Transport Moving Primer';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='ModelInput1 Primer';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='ModelInput2 Primer';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='ModelInput3 Primer';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='Ready to coat OPV';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='Coating OPV';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='Error OPV';
	gPlcCards[iIndexPlcCar].Texts[9].Details :='Dryer in Run Mode OPV';
	gPlcCards[iIndexPlcCar].Texts[10].Details :='Transport Moving OPV';
	gPlcCards[iIndexPlcCar].Texts[11].Details :='ModelInput1 OPV';
	gPlcCards[iIndexPlcCar].Texts[12].Details :='ModelInput2 OPV';
	gPlcCards[iIndexPlcCar].Texts[13].Details :='ModelInput3 OPV';
	gPlcCards[iIndexPlcCar].Texts[14].Details :='ModelInput1 Dryer';
	gPlcCards[iIndexPlcCar].Texts[15].Details :='ModelInput2 Dryer';
	gPlcCards[iIndexPlcCar].Texts[16].Details :='ModelInput3 Dryer';
	gPlcCards[iIndexPlcCar].Location := CardInPDC; 
	iIndexPlcCar := iIndexPlcCar + 1;

	
	// PDC - CARD 06 X20DIF371
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(Pdc_X20DIF371_006);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371-006';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='Error stacker';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='Ready to stack stacker';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='Feed Interrupt stacker';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='Running stacker';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='ModelInput1 Stacker';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='ModelInput2 Stacker';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='ModelInput3 Stacker';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='Stacker - Reject Success';
	gPlcCards[iIndexPlcCar].Texts[9].Details :='Stacker - Stack Success';
	gPlcCards[iIndexPlcCar].Texts[10].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[11].Details :='Cliente ';
	gPlcCards[iIndexPlcCar].Texts[12].Details :='Cliente';
	gPlcCards[iIndexPlcCar].Texts[13].Details :='Cliente';
	gPlcCards[iIndexPlcCar].Texts[14].Details :='Cliente';
	gPlcCards[iIndexPlcCar].Texts[15].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[16].Details :='Spare';
	gPlcCards[iIndexPlcCar].Location := CardInPDC; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	
	// PDC - CARD 07 PS
	gPlcCards[iIndexPlcCar].Type := CARD_PS33;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20PS3300_007);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20PS3300-007';
	gPlcCards[iIndexPlcCar].Location := CardInPDC; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	// PDC - CARD 08 X20DOF322
	gPlcCards[iIndexPlcCar].Type := CARD_DO16;
	gPlcCards[iIndexPlcCar].pCard := ADR(Pdc_X20DOF322_008);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DOF322-008';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='Feeder contactor';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='Coater start';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='Coater stop';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='Coater 2 start';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='Coater 2 stop';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='Printer contactor';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='Stacker contactor';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='Hoppers run -Soft starter';
	gPlcCards[iIndexPlcCar].Texts[9].Details :='Chiller  run';
	gPlcCards[iIndexPlcCar].Texts[10].Details :='UV contactor';
	gPlcCards[iIndexPlcCar].Texts[11].Details :='IR  start';
	gPlcCards[iIndexPlcCar].Texts[12].Details :='IR stop';
	gPlcCards[iIndexPlcCar].Texts[13].Details :='IR 2 start';
	gPlcCards[iIndexPlcCar].Texts[14].Details :='IR 2 stop';
	gPlcCards[iIndexPlcCar].Texts[15].Details :='Dryer controls contactor';
	gPlcCards[iIndexPlcCar].Texts[16].Details :='Reset Switch PDC';
	gPlcCards[iIndexPlcCar].Location := CardInPDC; 
	iIndexPlcCar := iIndexPlcCar + 1;

	
	// PDC - CARD 09 X20DOF322
	gPlcCards[iIndexPlcCar].Type := CARD_DO16;
	gPlcCards[iIndexPlcCar].pCard := ADR(Pdc_X20DOF322_009);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DOF322-009';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='Reset Hub Powerlink PDC';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='Cliente ';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='Cliente';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='Cliente';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='Cliente';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='Prepare to Feed Feeder';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='Start Feeding Feeder';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='Fast stop Feeder';
	gPlcCards[iIndexPlcCar].Texts[9].Details :='Start dryer Primer';
	gPlcCards[iIndexPlcCar].Texts[10].Details :='Start Transport Primer';
	gPlcCards[iIndexPlcCar].Texts[11].Details :='Start Coating Primer';
	gPlcCards[iIndexPlcCar].Texts[12].Details :='Prepare to coat Primer';
	gPlcCards[iIndexPlcCar].Texts[13].Details :='Run stacker';
	gPlcCards[iIndexPlcCar].Texts[14].Details :='Reject Sheet stacker';
	gPlcCards[iIndexPlcCar].Texts[15].Details :='Prepare to Stack stacker';
	gPlcCards[iIndexPlcCar].Texts[16].Details :='Eject reject pile stacker';
	gPlcCards[iIndexPlcCar].Location := CardInPDC; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	// PDC - CARD 10 X20DOF322
	gPlcCards[iIndexPlcCar].Type := CARD_DO16;
	gPlcCards[iIndexPlcCar].pCard := ADR(Pdc_X20DOF322_010);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DOF322-010';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='Eject pile stacker';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='Dryer UPS contactor';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='Start dryer OPV';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='Start Transport OPV';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='Start Coating OPV';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='Prepare to coat OPV';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='Transformer to printer power ON';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='UPS 1 to printer power ON';
	gPlcCards[iIndexPlcCar].Texts[9].Details :='UPS 2 to printer power ON';
	gPlcCards[iIndexPlcCar].Texts[10].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[11].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[12].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[13].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[14].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[15].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[16].Details :='Spare';
	gPlcCards[iIndexPlcCar].Location := CardInPDC; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	
	// PDC - CARD 11 X20DIF371
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(Pdc_X20DIF371_020);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_LED_WHITE;
	gPlcCards[iIndexPlcCar].RequiredForFunctions[1] := CARDREQUIRED_LED_COLOR;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371-020';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='96 VDC PSU 1 - DC OK';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='96 VDC PSU 1 - AC OK';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='96 VDC PSU 2 - DC OK';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='96 VDC PSU 2 - AC OK';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='96 VDC PSU 3 - DC OK';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='96 VDC PSU 3 - AC OK';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='96 VDC PSU 4 - DC OK';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='96 VDC PSU 4 - AC OK';
	gPlcCards[iIndexPlcCar].Texts[9].Details :='96 VDC PSU 5 - DC OK';
	gPlcCards[iIndexPlcCar].Texts[10].Details :='96 VDC PSU 5 - AC OK';
	gPlcCards[iIndexPlcCar].Texts[11].Details :='96 VDC PSU 6 - DC OK';
	gPlcCards[iIndexPlcCar].Texts[12].Details :='96 VDC PSU 6 - AC OK';
	gPlcCards[iIndexPlcCar].Texts[13].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[14].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[15].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[16].Details :='Color Chiller Alarm';
	gPlcCards[iIndexPlcCar].Location := CardInPDC; 
	iIndexPlcCar := iIndexPlcCar + 1;


	// PDC - CARD 12 X20DIF371
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(Pdc_X20DIF371_021);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_LED_WHITE;
	gPlcCards[iIndexPlcCar].RequiredForFunctions[1] := CARDREQUIRED_LED_COLOR;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371-021';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='96 VDC PSU 7 - DC OK';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='96 VDC PSU 7 - AC OK';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='96 VDC PSU 8 - DC OK';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='96 VDC PSU 8 - AC OK';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='96 VDC PSU 9 - DC OK';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='96 VDC PSU 9 - AC OK';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='96 VDC PSU 10 - DC OK';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='96 VDC PSU 10 - AC OK';
	gPlcCards[iIndexPlcCar].Texts[9].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[10].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[11].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[12].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[13].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[14].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[15].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[16].Details :='White Chiller Alarm';
	gPlcCards[iIndexPlcCar].Location := CardInPDC; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
		
	// PDC - CARD 13 PS
	gPlcCards[iIndexPlcCar].Type := CARD_PS33;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20PS3300_022);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_LED_WHITE;
	gPlcCards[iIndexPlcCar].RequiredForFunctions[1] := CARDREQUIRED_LED_COLOR;
	gPlcCards[iIndexPlcCar].stCardName := 'X20PS3300-022';
	gPlcCards[iIndexPlcCar].Location := CardInPDC; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	
	// PDC - CARD 14 X20DOF322
	gPlcCards[iIndexPlcCar].Type := CARD_DO16;
	gPlcCards[iIndexPlcCar].pCard := ADR(Pdc_X20DOF322_023);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_LED_WHITE;
	gPlcCards[iIndexPlcCar].RequiredForFunctions[1] := CARDREQUIRED_LED_COLOR;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DOF322-023';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='Color chiller ON';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='White chiller ON ';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='Control UV Color Power';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='Control UV White Power';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='Color Chiller power ON';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='White chiller power ON';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[9].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[10].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[11].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[12].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[13].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[14].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[15].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[16].Details :='Spare';
	gPlcCards[iIndexPlcCar].Location := CardInPDC; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	// PDC - CARD 15 X20DIF371
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(Pdc_X20DIF371_040);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371_040';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='Transformer to printer power OK';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='UPS 2 - Load on utility';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='UPS 2 - Load on battery';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='UPS 2 - Low battery';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='';
	gPlcCards[iIndexPlcCar].Texts[9].Details :='';
	gPlcCards[iIndexPlcCar].Texts[10].Details :='';
	gPlcCards[iIndexPlcCar].Texts[11].Details :='';
	gPlcCards[iIndexPlcCar].Texts[12].Details :='';
	gPlcCards[iIndexPlcCar].Texts[13].Details :='';
	gPlcCards[iIndexPlcCar].Texts[14].Details :='';
	gPlcCards[iIndexPlcCar].Texts[15].Details :='';
	gPlcCards[iIndexPlcCar].Texts[16].Details :='';
	gPlcCards[iIndexPlcCar].Location := CardInPDC; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	// PDC - CARD 16 X20DIF371
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(Pdc_X20DIF371_050);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371_050';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='SARM configuration - Bit 0';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='SARM configuration - Bit 1';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='SARM configuration - Bit 2';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='SARM- Error';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='SARM- Running';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='';
	gPlcCards[iIndexPlcCar].Texts[9].Details :='';
	gPlcCards[iIndexPlcCar].Texts[10].Details :='';
	gPlcCards[iIndexPlcCar].Texts[11].Details :='';
	gPlcCards[iIndexPlcCar].Texts[12].Details :='';
	gPlcCards[iIndexPlcCar].Texts[13].Details :='SARM-Power supply OK';
	gPlcCards[iIndexPlcCar].Texts[14].Details :='Coater IR-Power supply OK';
	gPlcCards[iIndexPlcCar].Texts[15].Details :='';
	gPlcCards[iIndexPlcCar].Texts[16].Details :='';
	gPlcCards[iIndexPlcCar].Location := CardInPDC; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	// PDC - CARD 17 X20D0F322
	gPlcCards[iIndexPlcCar].Type := CARD_DO16;
	gPlcCards[iIndexPlcCar].pCard := ADR(Pdc_X20DOF322_051);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20D0F322_051';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='SARM- Prepare';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='SARM- Fast stop';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='SARM-Power on';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='Coater IR-Power on';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='';
	gPlcCards[iIndexPlcCar].Texts[9].Details :='';
	gPlcCards[iIndexPlcCar].Texts[10].Details :='';
	gPlcCards[iIndexPlcCar].Texts[11].Details :='';
	gPlcCards[iIndexPlcCar].Texts[12].Details :='';
	gPlcCards[iIndexPlcCar].Texts[13].Details :='';
	gPlcCards[iIndexPlcCar].Texts[14].Details :='';
	gPlcCards[iIndexPlcCar].Texts[15].Details :='';
	gPlcCards[iIndexPlcCar].Texts[16].Details :='';
	gPlcCards[iIndexPlcCar].Location := CardInPDC; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	
	
	///////////////PRINTER///////////////
	
	// PRINTER - CARD 1 COMUNICATION
	gPlcCards[iIndexPlcCar].Type := CARD_BC;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20BC0083);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20BC0083';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	// PDC - CARD 2 Power Supply
	gPlcCards[iIndexPlcCar].Type := CARD_PS33;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20PS9400);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20PS9400';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//PRINTER - CARD 1 X20DIF371
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DIF371_101);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371_101';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='Start';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='Stop';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='Automatic';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='Zero';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='Manual';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='Validation to PLC';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='CB1 to PLC -Print trigger L1';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='CB1 to PLC -Print trigger L2';
	gPlcCards[iIndexPlcCar].Texts[9].Details :='CB2 to PLC -Print trigger L1';
	gPlcCards[iIndexPlcCar].Texts[10].Details :='CB2 to PLC -Print trigger L2';
	gPlcCards[iIndexPlcCar].Texts[11].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[12].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[13].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[14].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[15].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[16].Details :='Spare';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;

	
	//PRINTER - CARD 2 X20DIF371
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DIF371_102);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371_102';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='BarA -48 VDC POWER OK';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='BarB -48 VDC POWER OK';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='BarC -48 VDC POWER OK';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='BarD -48 VDC POWER OK';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='BarE -48 VDC POWER OK';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='BarF -48 VDC POWER OK';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='BarG -48 VDC POWER OK';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='BarH -48 VDC POWER OK';
	gPlcCards[iIndexPlcCar].Texts[9].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[10].Details :='Tranp. drvr-CB alarm';
	gPlcCards[iIndexPlcCar].Texts[11].Details :='Elev. drvr-CB alarm';
	gPlcCards[iIndexPlcCar].Texts[12].Details :='NonCrash-CB alarm';
	gPlcCards[iIndexPlcCar].Texts[13].Details :='24VDC PSUs -IDS alarm';
	gPlcCards[iIndexPlcCar].Texts[14].Details :='Bars ref. sensor-ON signal';
	gPlcCards[iIndexPlcCar].Texts[15].Details :='Bck Safty Key unlck-PRINTER';
	gPlcCards[iIndexPlcCar].Texts[16].Details :='Spare';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;

	
	//PRINTER - CARD 3 X20DIF371
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DIF371_103);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371_103';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='UPS 1 -Load on Utility';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='UPS 1 -Load on Battery';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='UPS 1 -Low Battery';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='UPS 1 -Load on Bypass';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='UPS 2 -Load on Utility';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='UPS 2 -Load on Battery';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='UPS 2 -Low Battery';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='UPS 2 -Load on Bypass';
	gPlcCards[iIndexPlcCar].Texts[9].Details :='PD -Detection signal';
	gPlcCards[iIndexPlcCar].Texts[10].Details :='2Up -Detection signal';
	gPlcCards[iIndexPlcCar].Texts[11].Details :='6L:POS 1';
	gPlcCards[iIndexPlcCar].Texts[12].Details :='6L:POS 2';
	gPlcCards[iIndexPlcCar].Texts[13].Details :='6L:POS 3';
	gPlcCards[iIndexPlcCar].Texts[14].Details :='6L:POS 4';
	gPlcCards[iIndexPlcCar].Texts[15].Details :='6L:POS 5';
	gPlcCards[iIndexPlcCar].Texts[16].Details :='6L:POS 6';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//PRINTER - CARD 4 X20DIF371
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DIF371_104);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371_104';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='BarA -Klixon';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='BarB -Klixon';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='BarC -Klixon';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='BarD -Klixon';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='BarE -Klixon';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='BarF -Klixon';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='BarG -Klixon';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='BarH -Klixon';
	gPlcCards[iIndexPlcCar].Texts[9].Details :='BarA -Jam detection';
	gPlcCards[iIndexPlcCar].Texts[10].Details :='BarB -Jam detection';
	gPlcCards[iIndexPlcCar].Texts[11].Details :='BarC -Jam detection';
	gPlcCards[iIndexPlcCar].Texts[12].Details :='BarD -Jam detection';
	gPlcCards[iIndexPlcCar].Texts[13].Details :='BarE -Jam detection';
	gPlcCards[iIndexPlcCar].Texts[14].Details :='BarF -Jam detection';
	gPlcCards[iIndexPlcCar].Texts[15].Details :='BarG -Jam detection';
	gPlcCards[iIndexPlcCar].Texts[16].Details :='BarH -Jam detection';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//PRINTER - CARD 5 X20DIF371
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DIF371_105);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371_105';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='Tank A -Pressure Switch';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='Tank B -Pressure Switch';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='Tank C -Pressure Switch';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='Tank D -Pressure Switch';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='Tank E -Pressure Switch';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='Tank F -Pressure Switch';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='Tank G -Pressure Switch';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='Tank H -Pressure Switch';
	gPlcCards[iIndexPlcCar].Texts[9].Details :='Water clean -Level sensor';
	gPlcCards[iIndexPlcCar].Texts[10].Details :='Water clean -Pressure sensor';
	gPlcCards[iIndexPlcCar].Texts[11].Details :='Degasser system -Pressure switch';
	gPlcCards[iIndexPlcCar].Texts[12].Details :='Jam-Crash N1';
	gPlcCards[iIndexPlcCar].Texts[13].Details :='Jam-Crash N2';
	gPlcCards[iIndexPlcCar].Texts[14].Details :='Jam-Malfunction N1';
	gPlcCards[iIndexPlcCar].Texts[15].Details :='Jam-Malfunction N2';
	gPlcCards[iIndexPlcCar].Texts[16].Details :='Front Door Switch';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;

	// PRINTER - CARD 6 Power Supply
	gPlcCards[iIndexPlcCar].Type := CARD_PS33;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20PS3300_106);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20PS3300_106';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//PRINTER - CARD 7 X20DI9372
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DI9372_107);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DI9372_107';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='48VDC PSU 1 (PH) -48 V OK';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='48VDC PSU 2 (PH) -48 V OK';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='48VDC PSU 3 (PH) -48 V OK';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='48VDC PSU 4 (PH) -48 V OK';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='48VDC PSU 5 (PH) -48 V OK';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='48VDC PSU 6 (PH) -48 V OK';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='48VDC PSU 7 (Heat) -48 V OK';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='48VDC PSU 8 (Heat) -48 V OK';
	gPlcCards[iIndexPlcCar].Texts[9].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[10].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[11].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[12].Details :='Spare';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;

	// PRINTER - CARD 8 X20DOF322
	gPlcCards[iIndexPlcCar].Type := CARD_DO16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DOF322_108);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DOF322_108';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='PLC to CB-Simulation PD1';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='PLC to CB-Simulation PD2';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='PLC to CB-DTP Enable';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='Reset Carriage Board 1&2';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='Reset Router';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='Zero mode - Air supply off';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='Start Green Light ON';
	gPlcCards[iIndexPlcCar].Texts[9].Details :='Reset blue light ON';
	gPlcCards[iIndexPlcCar].Texts[10].Details :='Buzzer';
	gPlcCards[iIndexPlcCar].Texts[11].Details :='TowerLigth Prntr-Audible';
	gPlcCards[iIndexPlcCar].Texts[12].Details :='TowerLigth Prntr-Amber/yellow';
	gPlcCards[iIndexPlcCar].Texts[13].Details :='TowerLigth Prntr-Blue';
	gPlcCards[iIndexPlcCar].Texts[14].Details :='TowerLigth Prntr-Red';
	gPlcCards[iIndexPlcCar].Texts[15].Details :='TowerLigth Prntr-White';
	gPlcCards[iIndexPlcCar].Texts[16].Details :='Spare';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	// PRINTER - CARD 9 X20DOF322
	gPlcCards[iIndexPlcCar].Type := CARD_DO16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DOF322_109);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DOF322_109';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='BarA -PH power ON';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='BarB -PH power ON';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='BarC -PH power ON';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='BarD -PH power ON';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='BarE -PH power ON';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='BarF -PH power ON';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='BarG -PH power ON';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='BarH -PH power ON';
	gPlcCards[iIndexPlcCar].Texts[9].Details :='BarA -Heating ON';
	gPlcCards[iIndexPlcCar].Texts[10].Details :='BarB -Heating ON';
	gPlcCards[iIndexPlcCar].Texts[11].Details :='BarC -Heating ON';
	gPlcCards[iIndexPlcCar].Texts[12].Details :='BarD -Heating ON';
	gPlcCards[iIndexPlcCar].Texts[13].Details :='BarE -Heating ON';
	gPlcCards[iIndexPlcCar].Texts[14].Details :='BarF -Heating ON';
	gPlcCards[iIndexPlcCar].Texts[15].Details :='BarG -Heating ON';
	gPlcCards[iIndexPlcCar].Texts[16].Details :='BarH -Heating ON';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;

	// PRINTER - CARD 10 X20DOF322
	gPlcCards[iIndexPlcCar].Type := CARD_DO16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DOF322_110);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DOF322_110';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='Jam- Test sensors 1&5&9';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='Jam- Test sensors 2&6&10';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='Jam- Test sensors 3&7&11';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='Jam- Test sensors 4&8&12';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='PD1-Remote teaching';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='PD2-Remote teaching';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='Degasser system-Pump ON';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[9].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[10].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[11].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[12].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[13].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[14].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[15].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[16].Details :='Spare';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;

	// PRINTER - CARD 11 X20AI8321
	gPlcCards[iIndexPlcCar].Type := CARD_AI8;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AI8321_111);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AI8321_111';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='BarA-Pos. Manif. Press. Sensor';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='BarA-Neg. Manif. Press. Sensor';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='BarB-Pos. Manif. Press. Sensor';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='BarB-Neg. Manif. Press. Sensor';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='BarC-Pos. Manif. Press. Sensor';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='BarC-Neg. Manif. Press. Sensor';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='BarD-Pos. Manif. Press. Sensor';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='BarD-Neg. Manif. Press. Sensor';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	// PRINTER - CARD 11 X20AI8321
	gPlcCards[iIndexPlcCar].Type := CARD_AI8;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AI8321_112);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AI8321_112';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='BarE-Pos. Manif. Press. Sensor';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='BarE-Neg. Manif. Press. Sensor';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='BarF-Pos. Manif. Press. Sensor';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='BarF-Neg. Manif. Press. Sensor';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='BarG-Pos. Manif. Press. Sensor';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='BarG-Neg. Manif. Press. Sensor';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='BarH-Pos. Manif. Press. Sensor';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='BarH-Neg. Manif. Press. Sensor';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	// PRINTER - CARD 12 X20AI8321
	gPlcCards[iIndexPlcCar].Type := CARD_AI8;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AI8321_113);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AI8321_113';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='Vacuum pressure section 1';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='Vacuum pressure section 2';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='TankB- Analog level sensor';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='TankC- Analog level sensor';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='TankD- Analog level sensor';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='TankE- Analog level sensor';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='TankF- Analog level sensor';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='TankG- Analog level sensor';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;

	// PRINTER - CARD 13 PS
	gPlcCards[iIndexPlcCar].Type := CARD_PS33;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20PS3300_114);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20PS3300_114';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	// PRINTER - CARD 14 X20AO4622
	gPlcCards[iIndexPlcCar].Type := CARD_AO4;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AO4622_115);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AO4622_115';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='Tank B - Pump Negative';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='Tank C - Pump Negative';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='Tank B - Pump Positive';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='Tank C - Pump Positive';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	// PRINTER - CARD 15 X20AO4622
	gPlcCards[iIndexPlcCar].Type := CARD_AO4;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AO4622_116);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AO4622_116';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='Tank D - Pump Negative';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='Tank E - Pump Negative';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='Tank D - Pump Positive';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='Tank E - Pump Positive';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	// PRINTER - CARD 16 X20AO4622
	gPlcCards[iIndexPlcCar].Type := CARD_AO4;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AO4622_117);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AO4622_117';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='Tank F - Pump Negative';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='Tank G - Pump Negative';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='Tank F - Pump Positive';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='Tank G - Pump Positive';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	// PRINTER - CARD 17 X20AT4222
	gPlcCards[iIndexPlcCar].Type := CARD_AT4;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AT4222_118);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AT4222_118';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='BarA - Temp. Probe (Manifold)';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='BarB - Temp. Probe (Manifold)';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='BarC - Temp. Probe (Manifold)';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='BarD - Temp. Probe (Manifold)';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	// PRINTER - CARD 18 X20AT4222
	gPlcCards[iIndexPlcCar].Type := CARD_AT4;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AT4222_119);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AT4222_119';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='BarE - Temp. Probe (Manifold)';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='BarF - Temp. Probe (Manifold)';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='BarG - Temp. Probe (Manifold)';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='BarH - Temp. Probe (Manifold)';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	// PRINTER - CARD 18 Interf.Module RS232/RS485
	gPlcCards[iIndexPlcCar].Type := CARD_PS33;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20CS1030_150);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_LED_WHITE;
	gPlcCards[iIndexPlcCar].RequiredForFunctions[1] := CARDREQUIRED_LED_COLOR;
	gPlcCards[iIndexPlcCar].stCardName := 'X20CS1030_150';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	// PRINTER - CARD 19 Interf.Module RS232/RS485
	gPlcCards[iIndexPlcCar].Type := CARD_PS33;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20CS1030_151);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_LED_WHITE;
	gPlcCards[iIndexPlcCar].RequiredForFunctions[1] := CARDREQUIRED_LED_COLOR;
	gPlcCards[iIndexPlcCar].stCardName := 'X20CS1030_151';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	// PRINTER - CARD 20 PS
	gPlcCards[iIndexPlcCar].Type := CARD_PS33;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20PS3300_152);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_LED_WHITE;
	gPlcCards[iIndexPlcCar].RequiredForFunctions[1] := CARDREQUIRED_LED_COLOR;
	gPlcCards[iIndexPlcCar].stCardName := 'X20PS3300_152';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;

	
	// PRINTER - CARD 21 X20DIF371
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DIF371_153);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_LED_WHITE;
	gPlcCards[iIndexPlcCar].RequiredForFunctions[1] := CARDREQUIRED_LED_COLOR;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371_153';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='LAMP 1 COLOR - Thermal Fault';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='LAMP 1 COLOR - Fault';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='LAMP 2 COLOR - Thermal Fault';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='LAMP 2 COLOR - Fault';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='LAMP 3 COLOR - Thermal Fault';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='LAMP 3 COLOR - Fault';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='LAMP 4 COLOR - Thermal Fault';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='LAMP 4 COLOR - Fault';
	gPlcCards[iIndexPlcCar].Texts[9].Details :='NITROGEN COLOR - High';
	gPlcCards[iIndexPlcCar].Texts[10].Details :='NITROGEN COLOR - Low';
	gPlcCards[iIndexPlcCar].Texts[11].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[12].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[13].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[14].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[15].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[16].Details :='Spare';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	// PRINTER - CARD 22 PS
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DIF371_154);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_LED_WHITE;
	gPlcCards[iIndexPlcCar].RequiredForFunctions[1] := CARDREQUIRED_LED_COLOR;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371_154';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='LAMP 1 WHITE - Thermal Fault';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='LAMP 1 WHITE - Fault';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='LAMP 2 WHITE - Thermal Fault';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='LAMP 2 WHITE - Fault';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='LAMP 3 WHITE - Thermal Fault';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='LAMP 3 WHITE - Fault';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='LAMP 4 WHITE - Thermal Fault';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='LAMP 4 WHITE - Fault';
	gPlcCards[iIndexPlcCar].Texts[9].Details :='NITROGEN WHITE - High';
	gPlcCards[iIndexPlcCar].Texts[10].Details :='NITROGEN WHITE - Low';
	gPlcCards[iIndexPlcCar].Texts[11].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[12].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[13].Details :='Clean Belt - Relay Error';
	gPlcCards[iIndexPlcCar].Texts[14].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[15].Details :='Clean Belt - Open Guide';
	gPlcCards[iIndexPlcCar].Texts[16].Details :='Spare';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	// PRINTER - CARD 23 X20DOF322
	gPlcCards[iIndexPlcCar].Type := CARD_DO16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DOF322_155);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_LED_WHITE;
	gPlcCards[iIndexPlcCar].RequiredForFunctions[1] := CARDREQUIRED_LED_COLOR;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DOF322_155';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='Belt Clean - Direction 1';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='Belt Clean - Direction 2';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='Belt clean - Reset Relay';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='LAMP 1 COLOR - Enable';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='LAMP 2 COLOR - Enable';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='LAMP 3 COLOR - Enable';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='LAMP 4 COLOR - Enable';
	gPlcCards[iIndexPlcCar].Texts[9].Details :='LAMP 1 WHITE - Enable';
	gPlcCards[iIndexPlcCar].Texts[10].Details :='LAMP 2 WHITE - Enable';
	gPlcCards[iIndexPlcCar].Texts[11].Details :='LAMP 3 WHITE - Enable';
	gPlcCards[iIndexPlcCar].Texts[12].Details :='LAMP 4 WHITE - Enable';
	gPlcCards[iIndexPlcCar].Texts[13].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[14].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[15].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[16].Details :='Spare';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter;
	iIndexPlcCar := iIndexPlcCar + 1;
	
	// PRINTER - CARD 24 X20AI8221
	gPlcCards[iIndexPlcCar].Type := CARD_AI8;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AI8221_156);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_LED_WHITE;
	gPlcCards[iIndexPlcCar].RequiredForFunctions[1] := CARDREQUIRED_LED_COLOR;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AI8221_156';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='LAMP1 COLOR - Temp. Monitor';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='LAMP2 COLOR - Temp. Monitor';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='LAMP3 COLOR - Temp. Monitor';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='LAMP4 COLOR - Temp. Monitor';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='LAMP1 WHITE - Temp. Monitor';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='LAMP2 WHITE - Temp. Monitor';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='LAMP3 WHITE - Temp. Monitor';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='LAMP4 WHITE - Temp. Monitor';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	// PRINTER - CARD 25 X20AO4622
	gPlcCards[iIndexPlcCar].Type := CARD_AO4;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AO4622_157);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_LED_WHITE;
	gPlcCards[iIndexPlcCar].RequiredForFunctions[1] := CARDREQUIRED_LED_COLOR;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AO4622_157';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='LAMP1 COLOR - Intensity control';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='LAMP1 COLOR - Intensity control';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='LAMP1 COLOR - Intensity control';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='LAMP1 COLOR - Intensity control';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	// PRINTER - CARD 26 X20AO4622
	gPlcCards[iIndexPlcCar].Type := CARD_AO4;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AO4622_158);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_LED_WHITE;
	gPlcCards[iIndexPlcCar].RequiredForFunctions[1] := CARDREQUIRED_LED_COLOR;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AO4622_158';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='LAMP1 WHITE - Intensity control';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='LAMP2 WHITE - Intensity control';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='LAMP3 WHITE - Intensity control';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='LAMP4 WHITE - Intensity control';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	// PRINTER - CARD 27 X20DIF371
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DIF371_180);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371_180';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='Inductive sensor 1 EHD';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='Inductive sensor 2 EHD';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='Inductive sensor 3 EHD';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='Inductive sensor 4 EHD';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='Inductive sensor 5 EHD';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='Inductive sensor 6 EHD';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='Inductive sensor 7 EHD';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='Inductive sensor 8 EHD';
	gPlcCards[iIndexPlcCar].Texts[9].Details :='Jam sensor EHD';
	gPlcCards[iIndexPlcCar].Texts[10].Details :='';
	gPlcCards[iIndexPlcCar].Texts[11].Details :='';
	gPlcCards[iIndexPlcCar].Texts[12].Details :='';
	gPlcCards[iIndexPlcCar].Texts[13].Details :='';
	gPlcCards[iIndexPlcCar].Texts[14].Details :='';
	gPlcCards[iIndexPlcCar].Texts[15].Details :='';
	gPlcCards[iIndexPlcCar].Texts[16].Details :='';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;

	// PRINTER - CARD 28 X20AI8321
	gPlcCards[iIndexPlcCar].Type := CARD_AI8;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AI8321_181);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AI8321_181';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='Distance sensor 1 EHD';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='Distance sensor 2 EHD';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='Distance sensor 3 EHD';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='Distance sensor 4 EHD';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//END CARDS
	
	gPlcCards[iIndexPlcCar].Type := CARD_UNDEFINED;
	
END_ACTION
