
ACTION AsignDataP5: 

	//Just writing the fixed configuration once per each 5s
	IF NOT (EDGEPOS(gPLC.xBlk_5s) OR gPLC.xFirst_Scan OR xChangedSimMachine) THEN
		RETURN;
	END_IF
	
	////////////////////////////////////////////////////////////
	/////GENERAL	GENERAL		GENERAL		GENERAL	////////////
	////////////////////////////////////////////////////////////
	
	gMachine.Pt.xControlledRemotely := FALSE;

	gMachine.Pt.CT.rMountedMediaLevelInBypassMode		:= 120.0; 
	gMachine.Pt.CT.rMaxTicknessMedia		:= 120.0;
	gMachine.Pt.CT.rMinTicknessMedia		:= 2.0;
	gMachine.Pt.CT.iNumSAIInstalled			:= 2;
	
	gMachine.Pt.rMaxPrintHeadPos			:= 1668.0;
	gMachine.Pt.rMinPrintHeadPos			:= 10;
	gMachine.Pt.CT.rMinMarginPrinting		:= 1.0;
	
	gMachine.Pt.iMediaFilter 				:= 0;
	
	gMachine.Pt.PDSignalTpe 				:= PDCFG_SENSOR_AND_CARRIAGE;
	gMachine.Pt.xProtectPHWithStoppedMediaBended:= TRUE;
	gMachine.Pt.xProtectPHForBlowersRunning		:= FALSE;
	gMachine.Pt.Clean.xCleanBeltTopInstall 		:= FALSE;
	gMachine.Pt.xAllowLaboratory	 			:= TRUE;
	gMachine.Pt.xAllowJamRecovery	 			:= FALSE;
	gMachine.Pt.xJobNotReadyIsCritical	 		:= FALSE;
	gMachine.Pt.Clean.xCleanBeltForUv			:= FALSE;
	gMachine.Pt.CommsType						:= Type_ModbusTcp;
	
	gMachine.Pt.Hw.iWidth					:= 1440;
	gMachine.Pt.Hw.rMinPrintPosition		:= 2.0;
	gMachine.Pt.Hw.iMaxCuringLedBars		:= 0;
	gMachine.Pt.Hw.xDoubleLineAllowed		:= TRUE;
	gMachine.Pt.Hw.xSuctionModeAllowed		:= FALSE;
	
	gMachine.St.HwData.xIsPlatform5			:= TRUE;
	gMachine.St.HwData.xIsWater				:= gMachine.Pt.MachineModel=Type_P5_WTR;
	gMachine.St.HwData.xIsCubik				:= FALSE;

	//Belt
	gBelt.parameters.xRemoteAcceleration := FALSE;
	gBelt.parameters.xRemoteDeceleration := FALSE;
	gBelt.parameters.rAcceleration := 1050; 
	gBelt.parameters.rDeceleration := 1050;
	gBelt.parameters.rMaxAcceleration := 1500.0;
	gBelt.parameters.rMaxDeceleration := 2500.0;
	
	//Here are configured blocks in function of the machine direction
	//When machine is block then we need use correction as block physical 2 because PD is at the same distance than Block 1, for that is change process in function of machine 2 Blcoks or machine 1 block
	gBlock[1].parameters.iMotorAxisIndex := 2;
	gBlock[1].parameters.iMappingBlock := 1;
	gBlock[1].parameters.iIclaAxisIndex := 1;
	gBlock[1].parameters.Hw.ValvesCommsType := COMMS_POWERLINK;


	/////////////////////////////////////////////////////
	// Temperature Modules Check
	////////////////////////////////////////////////////
	IF	NOT(gInks[1].parSw.Temp.xTankHeaterEnabled OR
		gInks[2].parSw.Temp.xTankHeaterEnabled OR
		gInks[3].parSw.Temp.xTankHeaterEnabled OR
		gInks[4].parSw.Temp.xTankHeaterEnabled) THEN
		
		gBlock[1].parameters.Inks.xTankHeatEnabled1 := FALSE;
	ELSE
		gBlock[1].parameters.Inks.xTankHeatEnabled1 := TRUE;
	END_IF
	
	IF	NOT(gInks[5].parSw.Temp.xTankHeaterEnabled OR
		gInks[6].parSw.Temp.xTankHeaterEnabled OR
		gInks[7].parSw.Temp.xTankHeaterEnabled OR
		gInks[8].parSw.Temp.xTankHeaterEnabled) THEN
		
		gBlock[1].parameters.Inks.xTankHeatEnabled2 := FALSE;
	ELSE
		gBlock[1].parameters.Inks.xTankHeatEnabled2 := TRUE;
	END_IF
	
	/////////////////////////////////////////////////////
	/////BELT	BELT	BELT	BELT	BELT	BELT/////
	/////////////////////////////////////////////////////

	
	////////////////////////////////////////////////////////////
	/////BLOCK	BLOCK	BLOCK	BLOCK	BLOCK	BLOCK///////////
	////////////////////////////////////////////////////////////
	FOR iIndexBlock:=1 TO gMachine.Pt.CT.iNumBlocks DO
					
		//Position parameters (mm)
		gBlock[iIndexBlock].parameters.Motor.rSafePosition				:= 356.0;//Max heigh
		gBlock[iIndexBlock].parameters.Motor.rMinSafePosition			:= 5.0;	 //Min heigh
		gBlock[iIndexBlock].parameters.Motor.rCapPosition				:= 344.0;//CAP
		gBlock[iIndexBlock].parameters.Motor.rSafePositionCleanCarrier	:= 329.0;//Carrier out Safe
		gBlock[iIndexBlock].parameters.Motor.rDripBarsPosition			:= 279.0;//Drip
		gBlock[iIndexBlock].parameters.Motor.rCleanPosition				:= 335.0;//Clean
		gBlock[iIndexBlock].parameters.Motor.rWaterSpurtPosition		:= 342.0;//Water Spurt
		gBlock[iIndexBlock].parameters.rPrePrintingPos					:= 75.0;  //PrePrinting Position
		
		gBlock[iIndexBlock].parameters.Motor.rAutoSpeedMoveDown	:=15.0;
		gBlock[iIndexBlock].parameters.Motor.rAutoSpeedMoveUp	:=30.0;
		gBlock[iIndexBlock].parameters.Motor.xFastSpeedAllowed	:= FALSE;
		
		gBlock[iIndexBlock].parameters.Motor.DriveUnit.TransmissionType := TRANS_SCREW_PITCH;
		gBlock[iIndexBlock].parameters.Motor.DriveUnit.ScrewPitch.PulsesPerTurn := GC_UNITS_BY_REV_DRIVE;
		gBlock[iIndexBlock].parameters.Motor.DriveUnit.ScrewPitch.GearBox := 7.25;
		gBlock[iIndexBlock].parameters.Motor.DriveUnit.ScrewPitch.Pitch := 5.0;
		
		gBlock[iIndexBlock].parameters.Motor.rReferencePosition		:= 15.5;
		
		//Current Parameters
		gBlock[iIndexBlock].parameters.Motor.uiMaxCurrentBarsUp			:= 3;
		gBlock[iIndexBlock].parameters.Motor.uiMaxCurrentBarsDown		:= 1;

		gBlock[iIndexBlock].parameters.Motor.VerticalDirection:= MOTOR_POSITIVE;
		
		gBlock[iIndexBlock].parameters.Motor.rAcceleration		:= 172.5;
		gBlock[iIndexBlock].parameters.Motor.rDeceleration		:= 172.5;

		gBlock[iIndexBlock].parameters.Icla.DriveUnit.TransmissionType:=TRANS_LINEAL_PERIMETER;
		gBlock[iIndexBlock].parameters.Icla.DriveUnit.LinealPerimeter.GearBox:=92;
		gBlock[iIndexBlock].parameters.Icla.DriveUnit.LinealPerimeter.Perimeter:=180;
		gBlock[iIndexBlock].parameters.Icla.DriveUnit.LinealPerimeter.PulsesPerTurn:=12;

		gBlock[iIndexBlock].parameters.Inks.iMaxMachinePrintBars	:= 8;
		gBlock[iIndexBlock].parameters.Inks.iMaxBlockPrintBars		:= 8;
		gBlock[iIndexBlock].parameters.Inks.iMaxPSUwattsForBars		:= 3000;
				
		gBlock[iIndexBlock].parameters.xCappingProcess := FALSE;
		
		gBlock[iIndexBlock].parameters.Hw.SafetySignals := SAFETY_ESTOP_CALCULATED;

		//[RGP] Due to issue SUSTPLATF-236
		gBlock[iIndexBlock].parameters.xMotorOffsetAllowed := FALSE;
		
		gBlock[iIndexBlock].parameters.iApplicationBars := 8;
	END_FOR
	
	
	///////////////////////////////////////////////////
	/////PHOTOCELLS		PHOTOCELLS		PHOTOCELLS/////
	///////////////////////////////////////////////////
	
	gPhotoCells.parameters.xInstall := TRUE;
	gMachine.parSw.Hw.xInstallnSensor := FALSE;
	gPhotoCells.parameters.xSensorsPosHybridBehaviour := FALSE;
	
	gPhotoCells.parameters.MotorType := STP_STEPPER;
	gPhotoCells.parameters.AlignmentProcess := STP_ALIGNMENT_NO_REQUIRED;
		
	gPhotoCells.parameters.Speed:=2.5;
	gPhotoCells.parameters.JogSpeed:=1;
	gPhotoCells.parameters.Acceleration:=5;
		
	gPhotoCells.parameters.DriveUnit.TransmissionType := TRANS_SCREW_PITCH;
	gPhotoCells.parameters.DriveUnit.ScrewPitch.PulsesPerTurn := GC_UNITS_BY_REV_DRIVE;
	gPhotoCells.parameters.DriveUnit.ScrewPitch.GearBox := 1;
	gPhotoCells.parameters.DriveUnit.ScrewPitch.Pitch := 2.5;
	
	IF gMachine.Pt.ConfigNameID = GC_CONFIG_SIMTEST_ID THEN
		// In Simulation 
		gPhotoCells.parameters.IndexDriveMaster:=4;
		gPhotoCells.parameters.IndexDriveSecondary:=5;
	ELSE
		gPhotoCells.parameters.IndexDriveMaster:=3;
		gPhotoCells.parameters.IndexDriveSecondary:=4;
	END_IF
		
	gPhotoCells.parameters.iSensorQuantity := 3;
	gPhotoCells.parameters.iSensorToReference := 2;
	gPhotoCells.parameters.rOffsetPosition := 0.0;
	gPhotoCells.parameters.rSensorMechPositionByPass := 60.0;//110.0; //ALX -> ToReview
	gPhotoCells.parameters.Sensors[2].rDistanceRelativeToFirstSensor := 4;
	gPhotoCells.parameters.Sensors[3].rDistanceRelativeToFirstSensor := 8;
	gPhotoCells.parameters.xEnableMountedAlrByPass := TRUE;
	
	//Digital Inputs
	gPhotoCells.Inputs.Signals.pInput[1] := ADR(X20DIF371_003.DInput[13]);
	gPhotoCells.Inputs.Signals.pInput[2] := ADR(X20DIF371_003.DInput[14]);
	gPhotoCells.Inputs.Signals.pInput[3] := ADR(X20DIF371_003.DInput[15]);
	gPhotoCells.Inputs.Signals.xSafetyEnable := gMachine.In.xSafetyEnabled;

	stepperMotor ACCESS ADR (gAxis[gPhotoCells.parameters.IndexDriveMaster]);
	stepperMotor.Parameter.Direction:= MOTOR_NEGATIVE_AXIS;

	///////////////////////////////////////////////////
	/////DING		DING		DING		DING  /////
	///////////////////////////////////////////////////
	gDing.Parameters.xDingInstalled := FALSE;
	
	/////////////////////////////////////////////////////
	/////THICKNESS		THICKNESS		 THICKNESS///////
	/////////////////////////////////////////////////////

	gThicknessCtrl.parameters.iTotalBlocksLengh := 305;
	gThicknessCtrl.parameters.Belt.iDistanceEmptyBeltIni := 455; //The difference between Long and NotLong machine is 1350mm by side [700-135=615]
	
	gThicknessCtrl.parameters.xMarginForBendTile := TRUE;
	gThicknessCtrl.parameters.rSafetyMarginToHeight := 3.0;
	
	gThicknessCtrl.parameters.sections[1].xEnabled	:= TRUE;
	gThicknessCtrl.parameters.sections[1].iStart	:= 1;
	gThicknessCtrl.parameters.sections[1].iEnd		:= 305;

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

	/////////////////////////////////////////////////////
	/////   PLC CARDS	PLC CARDS	PLC CARDS	 ////////
	/////////////////////////////////////////////////////
	IF gPlcCards[0].Type <> CARD_UNDEFINED THEN
		RETURN;
	END_IF
	
	//Force "ModuleOk" in cards without it
	X20CPUData.ModuleOk := TRUE;
	
	AsignCardsP5;
	

	
END_ACTION

ACTION AsignCardsP5:
	
	gPlcCards[0].Type := CARD_CPU0484;
	gPlcCards[0].pCard := ADR(X20CPUData);
	gPlcCards[0].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[0].stCardName := 'X20CP0483_000';
	gPlcCards[0].Location := CardInPrinter;
	iIndexPlcCar := 1;

	//CARD 01 X20DIF371
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DIF371_001);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371-001';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'Machine Config-Bit 0';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'Machine Config-Bit 1';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'Machine Config-Bit 2';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'Machine Config-Bit 3';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'Machine Config-Bit 4';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'Machine Config-Bit 5';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'Start';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'Stop';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'Automatic';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'Zero';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'Manual';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'Validation to PLC';
	gPlcCards[iIndexPlcCar].Texts[13].Details := 'CB to PLC - Print Trigger L1';
	gPlcCards[iIndexPlcCar].Texts[14].Details := 'CB to PLC - Print Trigger L2';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	
	//CARD 02 X20DIF371
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DIF371_002);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371-002';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'Bar A-48 VDC POWER OK';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'Bar B-48 VDC POWER OK';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'Bar C-48 VDC POWER OK';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'Bar D-48 VDC POWER OK';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'Bar E-48 VDC POWER OK';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'Bar F-48 VDC POWER OK';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'Bar G-48 VDC POWER OK';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'Bar H-48 VDC POWER OK';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'Bars heater - 48 VDC POWER OK';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'Transp driver-Diff contact alarm';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'Elev. driver-CB contact alarm';
	gPlcCards[iIndexPlcCar].Texts[12].Details := '48 VDC PSUs-Diff contact alarm';
	gPlcCards[iIndexPlcCar].Texts[13].Details := '24 VDC PSUs-IDS power alarm';
	gPlcCards[iIndexPlcCar].Texts[14].Details := 'Front light curtain-Alarm';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'Back Safety Switch-Alarm';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'Safety module status-Safety OK';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 03 X20DIF371
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DIF371_003);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371-003';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'UPS 1 - Failure UPS';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'UPS 1 - Utility Failure';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'UPS 1 - Low Battery';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'UPS 1 - Inverter Failure';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'UPS 2 - Failure UPS';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'UPS 2 - Utility Failure';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'UPS 2 - Low Battery';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'UPS 2 - Inverter Failure';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'Bars ref. sensor - ON signal';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'PD - Broken sensor alarm';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'DPT - Broken sensor alarm';
	gPlcCards[iIndexPlcCar].Texts[13].Details := '3L - Detected tile (Photocell 1)';
	gPlcCards[iIndexPlcCar].Texts[14].Details := '3L - Bent tile (Photocell 2)';
	gPlcCards[iIndexPlcCar].Texts[15].Details := '3L - Mounted tile (Photocell 3)';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 04 X20DIF371
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DIF371_004);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371-004';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'Bar A - Klixon';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'Bar B - Klixon';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'Bar C - Klixon';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'Bar D - Klixon';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'Bar E - Klixon';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'Bar F - Klixon';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'Bar G - Klixon';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'Bar H - Klixon';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'Tank A - Empty Level';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'Tank B - Empty Level';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'Tank C - Empty Level';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'Tank D - Empty Level';
	gPlcCards[iIndexPlcCar].Texts[13].Details := 'Tank E - Empty Level';
	gPlcCards[iIndexPlcCar].Texts[14].Details := 'Tank F - Empty Level';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'Tank G - Empty Level';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'Tank H - Empty Level';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;

	//CARD 05 X20DIF371
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DIF371_005);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371-005';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'Tank A - Full Level';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'Tank B - Full Level';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'Tank C - Full Level';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'Tank D - Full Level';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'Tank E - Full Level';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'Tank F - Full Level';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'Tank G - Full Level';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'Tank H - Full Level';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'Tank A - Pressure Switch';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'Tank B - Pressure Switch';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'Tank C - Pressure Switch';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'Tank D - Pressure Switch';
	gPlcCards[iIndexPlcCar].Texts[13].Details := 'Tank E - Pressure Switch';
	gPlcCards[iIndexPlcCar].Texts[14].Details := 'Tank F - Pressure Switch';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'Tank G - Pressure Switch';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'Tank H - Pressure Switch';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 06 X20DIF371
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DIF371_006);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371-006';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'PBF - Bit 0';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'PBF - Bit 1';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'PBF - Bit 2';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'PBF - Bit 3';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'PBF - Bit 4';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'PBF - Bit 5';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'PBF - Bit 6';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'PBF - Bit 7';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'PBF - Strobe';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'Consent Line-Machine 1';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'Consent Line-Machine 2';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'PH External Cleaning';
	gPlcCards[iIndexPlcCar].Texts[13].Details := 'RESERVED';
	gPlcCards[iIndexPlcCar].Texts[14].Details := 'RESERVED';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 07 PS
	gPlcCards[iIndexPlcCar].Type := CARD_PS33;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20PS3300_007);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20PS3300-007';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 8 X20DI9372
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DI9372_008);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DI9372_008';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='48VDC PSU 1 (PH) -48 V OK';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='48VDC PSU 2 (PH) -48 V OK';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='48VDC PSU 3 (PH) -48 V OK';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='48VDC PSU 4 (PH) -48 V OK';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='48VDC PSU 5 (PH) -48 V OK';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='48VDC PSU 6 (PH) -48 V OK';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='48VDC PSU 7 (Heat) -48 V OK';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='48VDC PSU 8 (Heat) -48 V OK';
	gPlcCards[iIndexPlcCar].Texts[9].Details :='48VDC PSU 9 (Heat) -48 V OK';
	gPlcCards[iIndexPlcCar].Texts[10].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[11].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[12].Details :='Spare';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 9 X20DOF322
	gPlcCards[iIndexPlcCar].Type := CARD_DO16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DOF322_009);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DOF322_009';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='PLC to CB-Simulation PD1';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='PLC to CB-Simulation PD2';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='DTP Enable';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='Reset Carriage Board 1&2';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='Reset Router';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='Zero mode - Air supply off';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='Start Green Light ON';
	gPlcCards[iIndexPlcCar].Texts[9].Details :='Reset blue light ON';
	gPlcCards[iIndexPlcCar].Texts[10].Details :='Buzzer';
	gPlcCards[iIndexPlcCar].Texts[11].Details :='Status PLC-Run';
	gPlcCards[iIndexPlcCar].Texts[12].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[13].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[14].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[15].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[16].Details :='Spare';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 10 X20DOF322
	gPlcCards[iIndexPlcCar].Type := CARD_DO16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DOF322_010);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DOF322_010';
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
	
	//CARD 11 X20DOF322
	gPlcCards[iIndexPlcCar].Type := CARD_DO16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DOF322_011);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DOF322_011';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='BarA-Rev.Flow Solen.1-4';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='BarB-Rev.Flow Solen.1-4';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='BarA-Rev.Flow Solen.2-3';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='BarB-Rev.Flow Solen.2-3';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='BarC-Rev.Flow Solen.1-4';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='BarD-Rev.Flow Solen.1-4';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='BarC-Rev.Flow Solen.2-3';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='BarD-Rev.Flow Solen.2-3';
	gPlcCards[iIndexPlcCar].Texts[9].Details :='BarE-Rev.Flow Solen.1-4';
	gPlcCards[iIndexPlcCar].Texts[10].Details :='BarF-Rev.Flow Solen.1-4';
	gPlcCards[iIndexPlcCar].Texts[11].Details :='BarE-Rev.Flow Solen.2-3';
	gPlcCards[iIndexPlcCar].Texts[12].Details :='BarF-Rev.Flow Solen.2-3';
	gPlcCards[iIndexPlcCar].Texts[13].Details :='BarG-Rev.Flow Solen.1-4';
	gPlcCards[iIndexPlcCar].Texts[14].Details :='BarH-Rev.Flow Solen.1-4';
	gPlcCards[iIndexPlcCar].Texts[15].Details :='BarG-Rev.Flow Solen.2-3';
	gPlcCards[iIndexPlcCar].Texts[16].Details :='BarH-Rev.Flow Solen.2-3';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 12 X20DOF322
	gPlcCards[iIndexPlcCar].Type := CARD_DO16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DOF322_012);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DOF322_012';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='BarA-Minifold tank EV';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='BarB-Minifold tank EV';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='BarC-Minifold tank EV';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='BarD-Minifold tank EV';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='BarE-Minifold tank EV';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='BarF-Minifold tank EV';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='BarG-Minifold tank EV';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='BarH-Minifold tank EV';
	gPlcCards[iIndexPlcCar].Texts[9].Details :='BarA-Preheat power ON';
	gPlcCards[iIndexPlcCar].Texts[10].Details :='BarB-Preheat power ON';
	gPlcCards[iIndexPlcCar].Texts[11].Details :='BarC-Preheat power ON';
	gPlcCards[iIndexPlcCar].Texts[12].Details :='BarD-Preheat power ON';
	gPlcCards[iIndexPlcCar].Texts[13].Details :='BarE-Preheat power ON';
	gPlcCards[iIndexPlcCar].Texts[14].Details :='BarF-Preheat power ON';
	gPlcCards[iIndexPlcCar].Texts[15].Details :='BarG-Preheat power ON';
	gPlcCards[iIndexPlcCar].Texts[16].Details :='BarH-Preheat power ON';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 13 X20DOF322
	gPlcCards[iIndexPlcCar].Type := CARD_DO16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DOF322_013);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DOF322_013';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='Consent Machine-Line1';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='Consent Machine-Line2';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='Compenser Line 1';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='Compenser Line 2';
	gPlcCards[iIndexPlcCar].Texts[5].Details :='Warning Machine (Yellow)';
	gPlcCards[iIndexPlcCar].Texts[6].Details :='Emergency Machine (Red)';
	gPlcCards[iIndexPlcCar].Texts[7].Details :='Line 1 - Ready Clean Up';
	gPlcCards[iIndexPlcCar].Texts[8].Details :='Line 2 - Ready Clean Up';
	gPlcCards[iIndexPlcCar].Texts[9].Details :='Suction Tutbine';
	gPlcCards[iIndexPlcCar].Texts[10].Details :='Jam detection - Test sensors 1&5';
	gPlcCards[iIndexPlcCar].Texts[11].Details :='Jam detection - Test sensors 2&6';
	gPlcCards[iIndexPlcCar].Texts[12].Details :='Jam detection - Test sensors 3&7';
	gPlcCards[iIndexPlcCar].Texts[13].Details :='Jam detection - Test sensors 4&8';
	gPlcCards[iIndexPlcCar].Texts[14].Details :='Spare';
	gPlcCards[iIndexPlcCar].Texts[15].Details :='Sapre';
	gPlcCards[iIndexPlcCar].Texts[16].Details :='Spare';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 14 PS
	gPlcCards[iIndexPlcCar].Type := CARD_PS33;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20PS3300_014);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20PS3300-014';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 15 X20AI8321
	gPlcCards[iIndexPlcCar].Type := CARD_AI8;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AI8321_015);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AI8321_015';
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
	
	//CARD 16 X20AI8321
	gPlcCards[iIndexPlcCar].Type := CARD_AI8;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AI8321_016);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AI8321_016';
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
	
	//CARD 17 X20AO4622
	gPlcCards[iIndexPlcCar].Type := CARD_AO4;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AO4622_017);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AO4622_017';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='Tank A - Pump Negative';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='Tank B - Pump Negative';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='Tank A - Pump Positive';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='Tank B - Pump Positive';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 18 X20AO4622
	gPlcCards[iIndexPlcCar].Type := CARD_AO4;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AO4622_018);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AO4622_018';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='Tank C - Pump Negative';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='Tank D - Pump Negative';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='Tank C - Pump Positive';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='Tank D - Pump Positive';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 19 X20AO4622
	gPlcCards[iIndexPlcCar].Type := CARD_AO4;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AO4622_019);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AO4622_019';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='Tank E - Pump Negative';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='Tank F - Pump Negative';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='Tank E - Pump Positive';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='Tank F - Pump Positive';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 20 X20AO4622
	gPlcCards[iIndexPlcCar].Type := CARD_AO4;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AO4622_020);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AO4622_020';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='Tank G - Pump Negative';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='Tank H - Pump Negative';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='Tank G - Pump Positive';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='Tank H - Pump Positive';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 21 PS
	gPlcCards[iIndexPlcCar].Type := CARD_PS33;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20PS3300_021);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20PS3300-021';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 22 X20AT4222
	gPlcCards[iIndexPlcCar].Type := CARD_AT4;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AT4222_022);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AT4222_022';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='BarA - Temp. Probe (Manifold)';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='BarB - Temp. Probe (Manifold)';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='BarC - Temp. Probe (Manifold)';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='BarD - Temp. Probe (Manifold)';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 23 X20AT4222
	gPlcCards[iIndexPlcCar].Type := CARD_AT4;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AT4222_023);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AT4222_023';
	gPlcCards[iIndexPlcCar].Texts[1].Details :='BarE - Temp. Probe (Manifold)';
	gPlcCards[iIndexPlcCar].Texts[2].Details :='BarF - Temp. Probe (Manifold)';
	gPlcCards[iIndexPlcCar].Texts[3].Details :='BarG - Temp. Probe (Manifold)';
	gPlcCards[iIndexPlcCar].Texts[4].Details :='BarH - Temp. Probe (Manifold)';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 24 Stepper Driver
	gPlcCards[iIndexPlcCar].Type := CARD_SM;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20SM1436_111);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_SENSOR_THICK;
	gPlcCards[iIndexPlcCar].stCardName := 'X20SM1436_111';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
		
	//CARD 25 Stepper Driver
	gPlcCards[iIndexPlcCar].Type := CARD_SM;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20SM1436_112);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_SENSOR_THICK;
	gPlcCards[iIndexPlcCar].stCardName := 'X20SM1436_112';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 26 X20AT4222
	IF X20AT4222_120.ModuleOk THEN
		gPlcCards[iIndexPlcCar].Type := CARD_AT4;
		gPlcCards[iIndexPlcCar].pCard := ADR(X20AT4222_120);
		gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
		gPlcCards[iIndexPlcCar].stCardName := 'X20AT4222_120';
		gPlcCards[iIndexPlcCar].Texts[1].Details :='TankA - Preheat. Temp. Probe';
		gPlcCards[iIndexPlcCar].Texts[2].Details :='TankB - Preheat. Temp. Probe';
		gPlcCards[iIndexPlcCar].Texts[3].Details :='TankC - Preheat. Temp. Probe';
		gPlcCards[iIndexPlcCar].Texts[4].Details :='TankD - Preheat. Temp. Probe';
		gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
		iIndexPlcCar := iIndexPlcCar + 1;
	END_IF
	
	//CARD 27 X20AT4222
	IF X20AT4222_121.ModuleOk THEN
		gPlcCards[iIndexPlcCar].Type := CARD_AT4;
		gPlcCards[iIndexPlcCar].pCard := ADR(X20AT4222_121);
		gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
		gPlcCards[iIndexPlcCar].stCardName := 'X20AT4222_121';
		gPlcCards[iIndexPlcCar].Texts[1].Details :='TankE - Preheat. Temp. Probe';
		gPlcCards[iIndexPlcCar].Texts[2].Details :='TankF - Preheat. Temp. Probe';
		gPlcCards[iIndexPlcCar].Texts[3].Details :='TankG - Preheat. Temp. Probe';
		gPlcCards[iIndexPlcCar].Texts[4].Details :='TankH - Preheat. Temp. Probe';
		gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
		iIndexPlcCar := iIndexPlcCar + 1;
	END_IF
	
	//END CARDS
	
	gPlcCards[iIndexPlcCar].Type := CARD_UNDEFINED;
	
END_ACTION