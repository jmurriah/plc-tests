
ACTION AsignDataP4: 

	//Just writing the fixed configuration once per each 5s
	IF NOT (EDGEPOS(gPLC.xBlk_5s) OR gPLC.xFirst_Scan OR xChangedSimMachine) THEN
		RETURN;
	END_IF
	
	////////////////////////////////////////////////////////////
	/////GENERAL	GENERAL		GENERAL		GENERAL	////////////
	////////////////////////////////////////////////////////////
	
	gMachine.Pt.CT.rMinMountedPieceOverThick	:= 1.0;
	gMachine.Pt.CT.rMaxMountedPieceOverThick	:= 5.0;
	gMachine.Pt.CT.rMinMarginPrinting		:= 1.0;
	
	gMachine.Pt.xControlledRemotely := FALSE;

	gMachine.Pt.CT.rMountedMediaLevelInBypassMode		:= 140.0;
	gMachine.Pt.CT.rMaxTicknessMedia		:= 120.0;
	gMachine.Pt.CT.rMinTicknessMedia		:= 4.0;
	gMachine.Pt.CT.iNumSAIInstalled			:= gMachine.Pt.CT.iNumBlocks;
	
	gMachine.Pt.rMaxPrintHeadPos			:= 1623.0;
	gMachine.Pt.rMinPrintHeadPos			:= 10;
	
	gMachine.Pt.iMediaFilter 				:= 0;
	
	gMachine.Pt.PDSignalTpe 						:= PDCFG_CARRIAGE;
	gMachine.Pt.xProtectPHWithStoppedMediaBended	:= TRUE;
	gMachine.Pt.xProtectPHForBlowersRunning			:= FALSE;
	gMachine.Pt.Clean.xCleanBeltTopInstall 			:= FALSE;
	gMachine.Pt.xAllowLaboratory	 				:= TRUE;
	gMachine.Pt.xAllowJamRecovery	 				:= FALSE;
	gMachine.Pt.xJobNotReadyIsCritical	 			:= FALSE;
	gMachine.Pt.Clean.xCleanBeltForUv				:= FALSE;
	gMachine.Pt.CommsType							:= Type_ModbusTcp;
	
	gMachine.Pt.Hw.iWidth					:= 1440;
	gMachine.Pt.Hw.rMinPrintPosition		:= 2.0;
	gMachine.Pt.Hw.iMaxCuringLedBars		:= 0;
	gMachine.Pt.Hw.xDoubleLineAllowed		:= TRUE;
	gMachine.Pt.Hw.xSuctionModeAllowed		:= FALSE;
	
	gMachine.St.HwData.xIsPlatform5			:= gMachine.Pt.MachineModel=Type_P4_CBK;
	gMachine.St.HwData.xIsWater				:= gMachine.Pt.MachineModel=Type_P4_CBK;
	gMachine.St.HwData.xIsCubik				:= gMachine.Pt.MachineModel=Type_P4_CBK;
	
	//Belt
	gBelt.parameters.xRemoteAcceleration := FALSE;
	gBelt.parameters.xRemoteDeceleration := FALSE;
	gBelt.parameters.rAcceleration := 1050; 
	gBelt.parameters.rDeceleration := 1050;
	gBelt.parameters.rMaxAcceleration := 1500.0;
	gBelt.parameters.rMaxDeceleration := 2500.0;
	
	//Here are configured blocks in function of the machine direction
	//When machine is block then we need use correction as block physical 2 because PD is at the same distance than Block 1, for that is change process in function of machine 2 Blcoks or machine 1 block
	IF gMachine.Pt.xLeftHandMachine OR gMachine.Pt.CT.iNumBlocks=1 THEN
		gBlock[1].parameters.iMotorAxisIndex := 2;
		gBlock[1].parameters.iMappingBlock := 1;
		gBlock[1].parameters.iIclaAxisIndex := 1;
		gBlock[1].parameters.Hw.ValvesCommsType := COMMS_CANOPEN;
		gBlock[1].parameters.Hw.ValvesNode := 6;
		
		gBlock[2].parameters.iMotorAxisIndex := 3;
		gBlock[2].parameters.iMappingBlock := 2;
		gBlock[2].parameters.iIclaAxisIndex := 2;
		gBlock[2].parameters.Hw.ValvesCommsType := COMMS_CANOPEN;
		gBlock[2].parameters.Hw.ValvesNode := 8;
		
	ELSE
		gBlock[1].parameters.iMotorAxisIndex := 3;
		gBlock[1].parameters.iMappingBlock := 2;
		gBlock[1].parameters.iIclaAxisIndex := 2;
		gBlock[1].parameters.Hw.ValvesCommsType := COMMS_CANOPEN;
		gBlock[1].parameters.Hw.ValvesNode := 8;

		gBlock[2].parameters.iMotorAxisIndex := 2;	 
		gBlock[2].parameters.iMappingBlock := 1;
		gBlock[2].parameters.iIclaAxisIndex := 1;
		gBlock[2].parameters.Hw.ValvesCommsType := COMMS_CANOPEN;
		gBlock[2].parameters.Hw.ValvesNode := 6;

	END_IF
	
	////////////////////////////////////////////////////////////
	/////BLOCK	BLOCK	BLOCK	BLOCK	BLOCK	BLOCK///////////
	////////////////////////////////////////////////////////////
	FOR iIndexBlock:=1 TO gMachine.Pt.CT.iNumBlocks DO
					
		//Position parameters (mm)
		gBlock[iIndexBlock].parameters.Motor.rSafePosition				:= 343.0;//Max heigh
		gBlock[iIndexBlock].parameters.Motor.rMinSafePosition			:= 5.0;	//Min heigh
		gBlock[iIndexBlock].parameters.Motor.rCapPosition				:= 341.0;//CAP
		gBlock[iIndexBlock].parameters.Motor.rSafePositionCleanCarrier	:= 332.0;//Carrier out Safe
		gBlock[iIndexBlock].parameters.Motor.rDripBarsPosition			:= 279.0;//Drip
		gBlock[iIndexBlock].parameters.Motor.rCleanPosition				:= 337.0;//Clean
		gBlock[iIndexBlock].parameters.Motor.rWaterSpurtPosition		:= 341.0;//Water Spurt
		gBlock[iIndexBlock].parameters.rPrePrintingPos					:= 75.0;  //PrePrinting Position

		gBlock[iIndexBlock].parameters.Motor.rAutoSpeedMoveDown	:=30.0;
		gBlock[iIndexBlock].parameters.Motor.rAutoSpeedMoveUp	:=30.0;
		gBlock[iIndexBlock].parameters.Motor.xFastSpeedAllowed	:= FALSE;
		
		gBlock[iIndexBlock].parameters.Motor.DriveUnit.TransmissionType := TRANS_SCREW_PITCH;
		gBlock[iIndexBlock].parameters.Motor.DriveUnit.ScrewPitch.PulsesPerTurn := GC_UNITS_BY_REV_DRIVE;
		gBlock[iIndexBlock].parameters.Motor.DriveUnit.ScrewPitch.GearBox := 7.25;
		gBlock[iIndexBlock].parameters.Motor.DriveUnit.ScrewPitch.Pitch := 5.0;
		
		gBlock[iIndexBlock].parameters.Motor.rReferencePosition		:= 15.5;
		
		//Current Parameters
		gBlock[iIndexBlock].parameters.Motor.uiMaxCurrentBarsUp		:= 3;
		gBlock[iIndexBlock].parameters.Motor.uiMaxCurrentBarsDown		:= 1;

		gBlock[iIndexBlock].parameters.Motor.VerticalDirection:= MOTOR_POSITIVE;
		
		gBlock[iIndexBlock].parameters.Motor.rAcceleration		:= 172.5;
		gBlock[iIndexBlock].parameters.Motor.rDeceleration		:= 172.5;

		gBlock[iIndexBlock].parameters.Icla.DriveUnit.TransmissionType:=TRANS_LINEAL_PERIMETER;
		gBlock[iIndexBlock].parameters.Icla.DriveUnit.LinealPerimeter.GearBox:=92;
		gBlock[iIndexBlock].parameters.Icla.DriveUnit.LinealPerimeter.Perimeter:=180;
		gBlock[iIndexBlock].parameters.Icla.DriveUnit.LinealPerimeter.PulsesPerTurn:=12;

		gBlock[iIndexBlock].parameters.Inks.iMaxMachinePrintBars	:= 12;
		gBlock[iIndexBlock].parameters.Inks.iMaxBlockPrintBars		:= 6;
		gBlock[iIndexBlock].parameters.Inks.iMaxPSUwattsForBars		:= 3000;
		
		gBlock[iIndexBlock].parameters.xCappingProcess := FALSE;
		
		gBlock[iIndexBlock].parameters.Hw.SafetySignals := SAFETY_ESTOP_CONNECTED;

		//[RGP] Due to issue SUSTPLATF-236
		gBlock[iIndexBlock].parameters.xMotorOffsetAllowed := FALSE;
		
		gBlock[iIndexBlock].parameters.iApplicationBars := 6;
	END_FOR
	
	///////////////////////////////////////////////////
	/////PHOTOCELLS		PHOTOCELLS		PHOTOCELLS/////
	///////////////////////////////////////////////////
	gPhotoCells.parameters.xInstall := TRUE;
	gPhotoCells.parameters.xAllowDynamicEnable := TRUE;
	
	gPhotoCells.parameters.MotorType := STP_STEPPER;
	gPhotoCells.parameters.AlignmentProcess := STP_ALIGNMENT_NO_REQUIRED;
	
	gPhotoCells.parameters.Speed:=2.5;
	gPhotoCells.parameters.JogSpeed:=1;
	gPhotoCells.parameters.Acceleration:=5;
	
	gPhotoCells.parameters.DriveUnit.TransmissionType := TRANS_SCREW_PITCH;
	gPhotoCells.parameters.DriveUnit.ScrewPitch.PulsesPerTurn := GC_UNITS_BY_REV_DRIVE;
	gPhotoCells.parameters.DriveUnit.ScrewPitch.GearBox := 1;
	gPhotoCells.parameters.DriveUnit.ScrewPitch.Pitch := 2.5;
	
	gPhotoCells.parameters.IndexDriveMaster:=4;
	gPhotoCells.parameters.IndexDriveSecondary:=5;
	
	gPhotoCells.parameters.xSensorsPosHybridBehaviour := FALSE;
	gPhotoCells.parameters.iSensorQuantity := 3;
	gPhotoCells.parameters.iSensorToReference := 2;
	gPhotoCells.parameters.rOffsetPosition := 0.0;
	gPhotoCells.parameters.rSensorMechPositionByPass := 65.0;//130.0; //ALX -> ToReview
	gPhotoCells.parameters.Sensors[2].rDistanceRelativeToFirstSensor := 4;
	gPhotoCells.parameters.Sensors[3].rDistanceRelativeToFirstSensor := 8;
	
	gPhotoCells.parameters.xEnableMountedAlrByPass := TRUE;
	
	//Digital Inputs
	gPhotoCells.Inputs.Signals.pInput[1]	:= ADR (X2.DInput[11]);
	gPhotoCells.Inputs.Signals.pInput[2]	:= ADR (X2.DInput[12]);
	gPhotoCells.Inputs.Signals.pInput[3]	:= ADR (X2.DInput[13]);
	gPhotoCells.Inputs.Signals.xSafetyEnable := gMachine.In.xSafetyEnabled;
	
	stepperMotor ACCESS ADR (gAxis[gPhotoCells.parameters.IndexDriveMaster]);
	stepperMotor.Parameter.Direction:= MOTOR_NEGATIVE_AXIS;
	
	///////////////////////////////////////////////////
	/////DING		DING		DING		DING  /////
	///////////////////////////////////////////////////
	gDing.Parameters.xDingInstalled := TRUE;
	gDing.Parameters.xAllowDynamicEnable := TRUE;
	gDing.Parameters.SensorType := ANSENS_BALLUF_48;
	gDing.Parameters.iAnalogSamples := 13;
	gDing.In.pInputCard := ADR(X20AI2636_005);
	gDing.Parameters.rOverThicknessToReject := 10;
	gDing.Parameters.MountedDetectionType := THICKMOUNT_THICKNESS_RELATIVE;
	
	/////////////////////////////////////////////////////
	/////THICKNESS		THICKNESS		 THICKNESS///////
	/////////////////////////////////////////////////////
	
	//Configuring machine transport because some values are different in two blocks
	CASE gMachine.Pt.MachineModel OF
		Type_P4_12B_L:
			gThicknessCtrl.parameters.iTotalBlocksLengh := 485;
			gThicknessCtrl.parameters.Belt.iDistanceEmptyBeltIni := 750;
		Type_P4_12B:
			gThicknessCtrl.parameters.iTotalBlocksLengh := 485;
			gThicknessCtrl.parameters.Belt.iDistanceEmptyBeltIni := 615; //The difference between Long and NotLong machine is 1350mm by side [700-135=615]
			Type_P4_6B_L,
		Type_P4_CBK:
			gThicknessCtrl.parameters.iTotalBlocksLengh := 255;
			gThicknessCtrl.parameters.Belt.iDistanceEmptyBeltIni := 520;
		Type_P4_6B:
			gThicknessCtrl.parameters.iTotalBlocksLengh := 255;
		gThicknessCtrl.parameters.Belt.iDistanceEmptyBeltIni := 385; //The difference between Long and NotLong machine is 1350mm by side [520-135=385]
	END_CASE
	
	gThicknessCtrl.parameters.sections[1].xEnabled	:= TRUE;
	gThicknessCtrl.parameters.sections[1].iStart	:= 1;
	gThicknessCtrl.parameters.sections[1].iEnd		:= 250;
	
	gThicknessCtrl.parameters.xMarginForBendTile := TRUE;
	gThicknessCtrl.parameters.rSafetyMarginToHeight := 3.0;

	//Define the lengths of each section related to block distance
	gThicknessCtrl.parameters.sections[2].iStart:=231;
	gThicknessCtrl.parameters.sections[2].iEnd:=481;
	
	gThicknessCtrl.parameters.Detection.ProductDetect.xLoadMedia := FALSE;
	gThicknessCtrl.parameters.Detection.ProductDetect.iSensorPosition := 25;
	gThicknessCtrl.parameters.Detection.Array.xLoadMedia := TRUE;
	gThicknessCtrl.parameters.Detection.Analog.iSensorPosition := 0;
	gThicknessCtrl.parameters.Detection.Analog.xLoadMedia := TRUE;
	gThicknessCtrl.parameters.Detection.Array.iSensorPosition := 0;
	
	
	/////////////////////////////////////////////////////
	/////   TRANSPORT_VACUUM  TRANSPORT_VACUUM   ////////
	/////////////////////////////////////////////////////
	gTransVacuum[1].Parameters.xInstalled := FALSE;
	gTransVacuum[2].Parameters.xInstalled := FALSE;

	
	/////////////////////////////////////////////////////
	/////   NON_CRASH    NON_CRASH    NON_CRASH  ////////
	/////////////////////////////////////////////////////
	gNonCrash[1].Parameters.xInstalled := FALSE;
	
	
	// Always the last BLOCK of code
	//
	/////////////////////////////////////////////////////
	/////   PLC CARDS	PLC CARDS	PLC CARDS	 ////////
	/////////////////////////////////////////////////////
	IF gPlcCards[0].Type <> CARD_UNDEFINED THEN
		RETURN;
	END_IF
	
	//Force "ModuleOk" in cards without it
	X20CPUData.ModuleOk := TRUE;
	X1.ModuleOk := TRUE;
	X2.ModuleOk := TRUE;
	X3.ModuleOk := TRUE;
	
	CASE gMachine.Pt.MachineModel OF									
		Type_P4_6B,
		Type_P4_6B_L:							//P4 1 BLOCK
			AsignCardsP4_6Bar;
								
		Type_P4_12B,
		Type_P4_12B_L:							// P4 2 BLOCK
			AsignCardsP4_12Bar;
	END_CASE
	
END_ACTION

ACTION AsignCardsP4_6Bar:
	
	gPlcCards[0].Type := CARD_CPU1382;
	gPlcCards[0].pCard := ADR(X20CPUData);
	gPlcCards[0].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[0].stCardName := 'X20CP1382_000';
	gPlcCards[0].Location := CardInPrinter;
	
	iIndexPlcCar := 1;
	// CARD 1 X1
	gPlcCards[iIndexPlcCar].Type := CARD_X1;
	gPlcCards[iIndexPlcCar].pCard := ADR(X1);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X2CP1382-X1';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[2].Details := '';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[4].Details := '';
	gPlcCards[iIndexPlcCar].Texts[5].Details := '';
	gPlcCards[iIndexPlcCar].Texts[6].Details := '';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'ConsentL1Ok';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'ConsentL2Ok';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'ExternalCleaningOrder';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'CAN H';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'RS232 TXD';
	gPlcCards[iIndexPlcCar].Texts[13].Details := 'CAN L';
	gPlcCards[iIndexPlcCar].Texts[14].Details := 'RS232 RXD';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'GND';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'GND';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	
	//CARD 2 X2
	gPlcCards[iIndexPlcCar].Type := CARD_X2;
	gPlcCards[iIndexPlcCar].pCard := ADR(X2);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X2CP1382-X2';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'Drive Protection';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'Photocell.1';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'Photocell.2';
	gPlcCards[iIndexPlcCar].Texts[13].Details := 'Photocell.3';
	gPlcCards[iIndexPlcCar].Texts[14].Details := 'Photocell spare';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'GND';
	gPlcCards[iIndexPlcCar].Texts[16].Details := '+24VDC';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 3 X3
	gPlcCards[iIndexPlcCar].Type := CARD_X3;
	gPlcCards[iIndexPlcCar].pCard := ADR(X3);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X2CP1382-X3';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'ZeroMode';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'In Ding Low';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'In Ding High';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[13].Details := '+24VDC CPU/X2X';
	gPlcCards[iIndexPlcCar].Texts[14].Details := '+24VDC I/O';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'GND';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'GND';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 4 Digital Output
	gPlcCards[iIndexPlcCar].Type := CARD_DO16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DOF322_001);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DOF322_001';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'PC 1 Start';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'PC 2 Start';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'Green Light';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'Buzzer Button Panel';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'Reset Router';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'Reset CB1';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'Reset CB2';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'Consent Line 1';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'Consent Line 2';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'Compenser Line 1';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'Compenser Line 2';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'Yellow Light';
	gPlcCards[iIndexPlcCar].Texts[13].Details := 'Red Light';
	gPlcCards[iIndexPlcCar].Texts[14].Details := 'Line 1 Ready to Clean';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'Line 2 Ready to Clean';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'Suction Turbine';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 5 Digital Input
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DIF371_002);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371_002';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'SAI1 Power Fault';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'SAI1 ByPass';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'SAI1 Low Battery';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'SAI1 System Fault';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'SAI2 Power Fault';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'SAI2 ByPass';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'SAI2 Low Battery';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'SAI2 System Fault';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'PC1 OK';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'PC2 OK';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'Start';
	gPlcCards[iIndexPlcCar].Texts[13].Details := 'Stop';
	gPlcCards[iIndexPlcCar].Texts[14].Details := 'Automatic';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'Manual';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'Reset';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 6 Digital Input
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DIF371_003);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371_003';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'Zero';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'Machine confg.-Bit 1';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'Machine confg.-Bit 2';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'Machine confg.-Bit 3';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'Machine confg.-Bit 4';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'Machine confg.-Bit 5';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'Machine confg.-Bit 6';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[13].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[14].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'Tank Heater PsuOK';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 7 Digital Output
	gPlcCards[iIndexPlcCar].Type := CARD_DO16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DOF322_004);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DOF322_004';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'Light Reset';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[13].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[14].Details := 'Enable Doble Shot';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'Shot Line 1';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'Shot Line 2';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 8 Analog Input
	gPlcCards[iIndexPlcCar].Type := CARD_AI4;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AI2636_005);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AI2636_005';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'Analog +';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'Analog -';
	gPlcCards[iIndexPlcCar].Texts[3].Details := '';
	gPlcCards[iIndexPlcCar].Texts[4].Details := '';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 9 Safety module
	gPlcCards[iIndexPlcCar].Type := CARD_SC;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20SLX402_006);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20SLX402_006';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 10 Stepper Driver
	IF gPhotoCells.status.xInstalled THEN
		gPlcCards[iIndexPlcCar].Type := CARD_SM;
		gPlcCards[iIndexPlcCar].pCard := ADR(X20SM1436_007);
		gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_SENSOR_THICK;
		gPlcCards[iIndexPlcCar].stCardName := 'X20SM1436_007';
		gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
		iIndexPlcCar := iIndexPlcCar + 1;
	END_IF
	
		
	//CARD 11 Stepper Driver
	IF gPhotoCells.status.xInstalled THEN
		gPlcCards[iIndexPlcCar].Type := CARD_SM;
		gPlcCards[iIndexPlcCar].pCard := ADR(X20SM1436_008);
		gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_SENSOR_THICK;
		gPlcCards[iIndexPlcCar].stCardName := 'X20SM1436_008';
		gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
		iIndexPlcCar := iIndexPlcCar + 1;
	END_IF
	
	//CARD 12 X20DIF371 PBF
	IF gMachine.St.xWorkingAsPBF THEN
		gPlcCards[iIndexPlcCar].Type := CARD_DI16;
		gPlcCards[iIndexPlcCar].pCard := ADR(X20DIF371_003);
		gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_PBF;
		gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371_030';
		gPlcCards[iIndexPlcCar].Texts[1].Details := 'Relieve 1.0';
		gPlcCards[iIndexPlcCar].Texts[2].Details := 'Relieve 2.0';
		gPlcCards[iIndexPlcCar].Texts[3].Details := 'Relieve 3.0';
		gPlcCards[iIndexPlcCar].Texts[4].Details := 'Relieve 4.0';
		gPlcCards[iIndexPlcCar].Texts[5].Details := 'Relieve 5.0';
		gPlcCards[iIndexPlcCar].Texts[6].Details := 'Relieve 6.0';
		gPlcCards[iIndexPlcCar].Texts[7].Details := 'Relieve 7.0';
		gPlcCards[iIndexPlcCar].Texts[8].Details := 'Strobe';
		gPlcCards[iIndexPlcCar].Texts[9].Details := 'Spare';
		gPlcCards[iIndexPlcCar].Texts[10].Details := 'Spare';
		gPlcCards[iIndexPlcCar].Texts[11].Details := 'Spare';
		gPlcCards[iIndexPlcCar].Texts[12].Details := 'Spare';
		gPlcCards[iIndexPlcCar].Texts[13].Details := 'Spare';
		gPlcCards[iIndexPlcCar].Texts[14].Details := 'Spare';
		gPlcCards[iIndexPlcCar].Texts[15].Details := 'Spare';
		gPlcCards[iIndexPlcCar].Texts[16].Details := 'Spare';
		gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
		iIndexPlcCar := iIndexPlcCar + 1;
	END_IF
	
	
	
	////BLOCK 1////
	//CARD 13 X20DIF371
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DIF371_101);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371_101';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'Tank F Minimum Level';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'Tank F Maximum Level';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'Tank E Minimum Level';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'Tank E Maximum Level';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'Tank D Minimum Level';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'Tank D Maximum Level';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'Tank C Minimum Level0';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'Tank C Maximum Level';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'Tank B Minimum Level';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'Tank B Maximum Level';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'Tank A Minimum Level';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'Tank A Maximum Level';
	gPlcCards[iIndexPlcCar].Texts[13].Details := 'Tank F Over Pressure';
	gPlcCards[iIndexPlcCar].Texts[14].Details := 'Tank E Over Pressure';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'Tank D Over Pressure';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'Tank C Over Pressure';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 14 X20DIF371
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DIF371_102);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371_102';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'Tank B Over Pressure';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'Tank A Over Pressure';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'Block 1 48V PH';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'Block 1 Drive Protect.';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'Bar F PH PSU OK';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'Bar E PH PSU OK';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'Bar D PH PSU OK';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'Bar C PH PSU OK';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'Bar B PH PSU OK';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'Bar A PH PSU OK';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'Bar F Klixon Triggered';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'Bar E Klixon Triggered';
	gPlcCards[iIndexPlcCar].Texts[13].Details := 'Bar D Klixon Triggered';
	gPlcCards[iIndexPlcCar].Texts[14].Details := 'Bar C Klixon Triggered';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'Bar B Klixon Triggered';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'Bar A Klixon Triggered';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 15 X20DIF371
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DIF371_103);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371_103';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'Block 1 Input 48VDC';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'Block 1 PNP Laser Down';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[13].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[14].Details := 'Product Detect L1';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'Product Detect L2';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'Band Counter';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 16 X20DC4395 -> NOT USED

	//CARD 17 X20DC4395 -> NOT USED
	
	//CARD 18 X20DOF322
	gPlcCards[iIndexPlcCar].Type := CARD_DO16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DOF322_106);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DOF322_106';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'BarF-OutPowCabezal';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'BarE-OutPowCabezal';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'BarD-OutPowCabezal';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'BarC-OutPowCabezal';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'BarB-OutPowCabezal';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'BarA-OutPowCabezal';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'BarF-Resistance';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'BarE-Resistance';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'BarD-Resistance';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'BarC-Resistance';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'BarB-Resistance';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'BarA-Resistance';
	gPlcCards[iIndexPlcCar].Texts[13].Details := 'BarF-Tankheater ON';
	gPlcCards[iIndexPlcCar].Texts[14].Details := 'BarE-Tankheater ON';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'BarD-Tankheater ON';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 19 X20DOF322
	gPlcCards[iIndexPlcCar].Type := CARD_DO16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DOF322_107);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DOF322_107';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'BarF-Solenoid 1';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'BarF-Solenoid 2';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'BarE-Solenoid 1';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'BarE-Solenoid 2';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'BarD-Solenoid 1';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'BarD-Solenoid 2';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'BarC-Solenoid 1';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'BarC-Solenoid 2';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'BarB-Solenoid 1';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'BarB-Solenoid 2';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'BarA-Solenoid 1';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'BarA-Solenoid 2';
	gPlcCards[iIndexPlcCar].Texts[13].Details := 'BarC-Tankheater ON';
	gPlcCards[iIndexPlcCar].Texts[14].Details := 'BarB-Tankheater ON';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'BarA-Tankheater ON';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 20 X20DOF322
	gPlcCards[iIndexPlcCar].Type := CARD_DO16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DOF322_108);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DOF322_108';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'BarF-Optional Tank EV';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'BarE-Optional Tank EV';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'BarD-Optional Tank EV';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'BarC-Optional Tank EV';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'BarB-Optional Tank EV';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'BarA-Optional Tank EV';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[13].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[14].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 21 X20AI8321
	gPlcCards[iIndexPlcCar].Type := CARD_AI8;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AI8321_109);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AI8321_109';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'BarF-Vacuum1 Raw';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'BarF-Vacuum2 Raw';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'BarE-Vacuum1 Raw';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'BarE-Vacuum2 Raw';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'BarD-Vacuum1 Raw';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'BarD-Vacuum2 Raw';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'BarC-Vacuum1 Raw';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'BarC-Vacuum2 Raw';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 22 X20AI8321
	gPlcCards[iIndexPlcCar].Type := CARD_AI8;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AI8321_110);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AI8321_110';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'BarB-Vacuum1 Raw';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'BarB-Vacuum2 Raw';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'BarA-Vacuum1 Raw';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'BarA-Vacuum2 Raw';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 22 X20AO4622
	gPlcCards[iIndexPlcCar].Type := CARD_AO4;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AO4622_111);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AO4622_111';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'BarF-DutyCycle Neg.';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'BarF-DutyCycle Fill.';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'BarE-DutyCycle Neg.';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'BarE-DutyCycle Fill.';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 23 X20AO4622
	gPlcCards[iIndexPlcCar].Type := CARD_AO4;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AO4622_112);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AO4622_112';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'BarD-DutyCycle Neg.';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'BarD-DutyCycle Fill.';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'BarC-DutyCycle Neg.';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'BarC-DutyCycle Fill.';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 24 X20AO4622
	gPlcCards[iIndexPlcCar].Type := CARD_AO4;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AO4622_113);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AO4622_113';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'BarB-DutyCycle Neg.';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'BarB-DutyCycle Fill.';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'BarA-DutyCycle Neg.';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'BarA-DutyCycle Fill.';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 25 X20AT4222
	gPlcCards[iIndexPlcCar].Type := CARD_AT4;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AT4222_114);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AT4222_114';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'BarF-Temperature Raw';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'BarE-Temperature Raw';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'BarD-Temperature Raw';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'BarC-Temperature Raw';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 26 X20AT4222
	gPlcCards[iIndexPlcCar].Type := CARD_AT4;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AT4222_115);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AT4222_115';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'BarB-Temperature Raw';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'BarA-Temperature Raw';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'BarF-Temp. Heater Raw';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'BarE-Temp. HEater Raw';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 27 X20AT4222
	gPlcCards[iIndexPlcCar].Type := CARD_AT4;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AT4222_116);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AT4222_116';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'BarD-Temp. Heater Raw';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'BarC-Temp. Heater Raw';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'BarB-Temp. Heater Raw';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'BarA-Temp. HEater Raw';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 28 X20SI8110
	gPlcCards[iIndexPlcCar].Type := CARD_SI;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20SI8110_117);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20SI8110_117';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'Rear Emergency Stop 1_Pulse';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'Rear Emergency Stop 2_Pulse';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'Rear Emergency Stop 1_SI';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'Rear Emergency Stop 2_SI';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'Front Emergency Stop 1_Pulse';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'Front Emergency Stop 2_Pulse';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'Front Emergency Stop 1_SI';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'Front Emergency Stop 2_SI';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'Courtain Enable O1';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'Rear Safety Ok';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'Courtain Enable O2';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 29 X20SO8110
	gPlcCards[iIndexPlcCar].Type := CARD_SO;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20SO2110_118);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20SO2110_118';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'Enable 1';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'ICLA & EV';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//END CARDS
	
	gPlcCards[iIndexPlcCar].Type := CARD_UNDEFINED;
	
END_ACTION

ACTION AsignCardsP4_12Bar:
	
	AsignCardsP4_6Bar;
	
	////BLOCK 1////
	//CARD 32 X20DIF371
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DIF371_201);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371_201';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'Tank L Minimum Level';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'Tank L Maximum Level';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'Tank K Minimum Level';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'Tank K Maximum Level';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'Tank J Minimum Level';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'Tank J Maximum Level';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'Tank I Minimum Level0';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'Tank I Maximum Level';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'Tank H Minimum Level';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'Tank H Maximum Level';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'Tank G Minimum Level';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'Tank G Maximum Level';
	gPlcCards[iIndexPlcCar].Texts[13].Details := 'Tank L Over Pressure';
	gPlcCards[iIndexPlcCar].Texts[14].Details := 'Tank K Over Pressure';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'Tank J Over Pressure';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'Tank I Over Pressure';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 33 X20DIF371
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DIF371_202);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371_202';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'Tank H Over Pressure';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'Tank G Over Pressure';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'Block 2 48V PH';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'Block 2 Drive Protect.';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'Bar L PH PSU OK';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'Bar K PH PSU OK';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'Bar J PH PSU OK';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'Bar I PH PSU OK';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'Bar H PH PSU OK';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'Bar G PH PSU OK';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'Bar L Klixon Triggered';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'Bar K Klixon Triggered';
	gPlcCards[iIndexPlcCar].Texts[13].Details := 'Bar J Klixon Triggered';
	gPlcCards[iIndexPlcCar].Texts[14].Details := 'Bar I Klixon Triggered';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'Bar H Klixon Triggered';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'Bar G Klixon Triggered';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 34 X20DIF371
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DIF371_203);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371_203';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'Block 2 Input 48VDC';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'Block 2 PNP Laser Down';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[13].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[14].Details := 'Product Detect L1';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'Product Detect L2';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'Band Counter';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 34 X20DC4395 -> NOT USED

	//CARD 35 X20DC4395 -> NOT USED
	
	//CARD 36 X20DOF322
	gPlcCards[iIndexPlcCar].Type := CARD_DO16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DOF322_206);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DOF322_206';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'BarL-OutPowCabezal';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'BarK-OutPowCabezal';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'BarJ-OutPowCabezal';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'BarI-OutPowCabezal';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'BarH-OutPowCabezal';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'BarG-OutPowCabezal';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'BarL-Resistance';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'BarK-Resistance';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'BarJ-Resistance';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'BarI-Resistance';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'BarH-Resistance';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'BarG-Resistance';
	gPlcCards[iIndexPlcCar].Texts[13].Details := 'BarL-Tankheater ON';
	gPlcCards[iIndexPlcCar].Texts[14].Details := 'BarK-Tankheater ON';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'BarJ-Tankheater ON';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 37 X20DOF322
	gPlcCards[iIndexPlcCar].Type := CARD_DO16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DOF322_207);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DOF322_207';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'BarL-Solenoid 1';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'BarL-Solenoid 2';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'BarK-Solenoid 1';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'BarK-Solenoid 2';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'BarJ-Solenoid 1';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'BarJ-Solenoid 2';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'BarI-Solenoid 1';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'BarI-Solenoid 2';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'BarH-Solenoid 1';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'BarH-Solenoid 2';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'BarG-Solenoid 1';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'BarG-Solenoid 2';
	gPlcCards[iIndexPlcCar].Texts[13].Details := 'BarI-Tankheater ON';
	gPlcCards[iIndexPlcCar].Texts[14].Details := 'BarH-Tankheater ON';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'BarG-Tankheater ON';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 38 X20DOF322
	gPlcCards[iIndexPlcCar].Type := CARD_DO16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DOF322_208);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DOF322_208';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'BarL-Optional Tank EV';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'BarK-Optional Tank EV';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'BarJ-Optional Tank EV';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'BarI-Optional Tank EV';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'BarH-Optional Tank EV';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'BarG-Optional Tank EV';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[13].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[14].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 39 X20AI8321
	gPlcCards[iIndexPlcCar].Type := CARD_AI8;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AI8321_209);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AI8321_209';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'BarL-Vacuum1 Raw';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'BarL-Vacuum2 Raw';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'BarK-Vacuum1 Raw';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'BarK-Vacuum2 Raw';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'BarJ-Vacuum1 Raw';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'BarJ-Vacuum2 Raw';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'BarI-Vacuum1 Raw';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'BarI-Vacuum2 Raw';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 40 X20AI8321
	gPlcCards[iIndexPlcCar].Type := CARD_AI8;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AI8321_210);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AI8321_210';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'BarH-Vacuum1 Raw';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'BarH-Vacuum2 Raw';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'BarG-Vacuum1 Raw';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'BarG-Vacuum2 Raw';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 41 X20AO4622
	gPlcCards[iIndexPlcCar].Type := CARD_AO4;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AO4622_211);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AO4622_211';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'BarL-DutyCycle Neg.';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'BarL-DutyCycle Fill.';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'BarK-DutyCycle Neg.';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'BarK-DutyCycle Fill.';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 42 X20AO4622
	gPlcCards[iIndexPlcCar].Type := CARD_AO4;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AO4622_212);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AO4622_212';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'BarJ-DutyCycle Neg.';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'BarJ-DutyCycle Fill.';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'BarI-DutyCycle Neg.';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'BarI-DutyCycle Fill.';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 43 X20AO4622
	gPlcCards[iIndexPlcCar].Type := CARD_AO4;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AO4622_213);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AO4622_213';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'BarH-DutyCycle Neg.';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'BarH-DutyCycle Fill.';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'BarG-DutyCycle Neg.';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'BarG-DutyCycle Fill.';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 44 X20AT4222
	gPlcCards[iIndexPlcCar].Type := CARD_AT4;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AT4222_214);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AT4222_214';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'BarL-Temperature Raw';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'BarK-Temperature Raw';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'BarJ-Temperature Raw';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'BarI-Temperature Raw';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 45 X20AT4222
	gPlcCards[iIndexPlcCar].Type := CARD_AT4;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AT4222_215);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AT4222_215';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'BarH-Temperature Raw';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'BarG-Temperature Raw';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'BarL-Temp. Heater Raw';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'BarK-Temp. HEater Raw';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 46 X20AT4222
	gPlcCards[iIndexPlcCar].Type := CARD_AT4;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AT4222_216);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AT4222_216';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'BarJ-Temp. Heater Raw';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'BarI-Temp. Heater Raw';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'BarH-Temp. Heater Raw';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'BarG-Temp. HEater Raw';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 47 X20SI8110
	gPlcCards[iIndexPlcCar].Type := CARD_SI;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20SI8110_217);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20SI8110_217';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'Rear Emergency Stop 1_Pulse';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'Rear Emergency Stop 2_Pulse';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'Rear Emergency Stop 1_SI';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'Rear Emergency Stop 2_SI';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'Front Emergency Stop 1_Pulse';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'Front Emergency Stop 2_Pulse';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'Front Emergency Stop 1_SI';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'Front Emergency Stop 2_SI';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'Courtain Enable O1';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'Rear Safety Ok';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'Courtain Enable O2';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 48 X20SO8110
	gPlcCards[iIndexPlcCar].Type := CARD_SO;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20SO2110_218);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20SO2110_218';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'Enable 1';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'ICLA & EV';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//END CARDS
	
	gPlcCards[iIndexPlcCar].Type := CARD_UNDEFINED;
	
END_ACTION