
ACTION AsignDataShld: 

	//Just writing the fixed configuration once per each 5s
	IF NOT (EDGEPOS(gPLC.xBlk_5s) OR gPLC.xFirst_Scan OR xChangedSimMachine) THEN
		RETURN;
	END_IF
	
	////////////////////////////////////////////////////////////
	/////GENERAL	GENERAL		GENERAL		GENERAL	////////////
	////////////////////////////////////////////////////////////
	
	gMachine.Pt.xControlledRemotely := FALSE;

	gMachine.Pt.CT.rMountedMediaLevelInBypassMode		:= 60.0; 
	gMachine.Pt.CT.rMaxTicknessMedia		:= 60.0;
	gMachine.Pt.CT.rMinTicknessMedia		:= 2.0;
	gMachine.Pt.CT.iNumSAIInstalled			:= 1;
	
	gMachine.Pt.rMaxPrintHeadPos			:= 1623.0;
	gMachine.Pt.rMinPrintHeadPos			:= 10;
	gMachine.Pt.CT.rMinMarginPrinting		:= 1.0;
	
	gMachine.Pt.iMediaFilter 				:= 0;
	
	gMachine.Pt.PDSignalTpe 						:= PDCFG_SENSOR_AND_CARRIAGE;
	gMachine.Pt.xProtectPHWithStoppedMediaBended	:= TRUE;
	gMachine.Pt.xProtectPHForBlowersRunning			:= FALSE;
	gMachine.Pt.Clean.xCleanBeltTopInstall 				:= FALSE;
	gMachine.Pt.xAllowLaboratory	 				:= TRUE;
	gMachine.Pt.xAllowJamRecovery	 				:= FALSE;
	gMachine.Pt.xJobNotReadyIsCritical	 			:= FALSE;
	gMachine.Pt.Clean.xCleanBeltForUv						:= FALSE;
	gMachine.Pt.CommsType							:= Type_ModbusTcp;
	
	
	gMachine.Pt.Hw.iWidth					:= 1440;
	gMachine.Pt.Hw.rMinPrintPosition		:= 2.0;
	gMachine.Pt.Hw.iMaxCuringLedBars		:= 0;
	gMachine.Pt.Hw.xDoubleLineAllowed		:= TRUE;
	gMachine.Pt.Hw.xSuctionModeAllowed		:= FALSE;
	
	gMachine.St.HwData.xIsPlatform5			:= TRUE;
	gMachine.St.HwData.xIsWater				:= TRUE;
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
	gBlock[1].parameters.Hw.ValvesCommsType := COMMS_CANOPEN;
	gBlock[1].parameters.Hw.ValvesNode := 6;

	
	////////////////////////////////////////////////////////////
	/////BLOCK	BLOCK	BLOCK	BLOCK	BLOCK	BLOCK///////////
	////////////////////////////////////////////////////////////
	FOR iIndexBlock:=1 TO gMachine.Pt.CT.iNumBlocks DO
					
		//Position parameters (mm)
		gBlock[iIndexBlock].parameters.Motor.rSafePosition				:= 287.0;//3330;//Max heigh
		gBlock[iIndexBlock].parameters.Motor.rMinSafePosition			:= 5.0;	 //Min heigh
		gBlock[iIndexBlock].parameters.Motor.rCapPosition				:= 282.0;//3280;//CAP
		gBlock[iIndexBlock].parameters.Motor.rSafePositionCleanCarrier	:= 267.0;//Carrier out Safe
		gBlock[iIndexBlock].parameters.Motor.rDripBarsPosition			:= 218.0;//Drip
		gBlock[iIndexBlock].parameters.Motor.rCleanPosition				:= 273.0;//Clean
		gBlock[iIndexBlock].parameters.Motor.rWaterSpurtPosition		:= 281.0;//Water Spurt
		gBlock[iIndexBlock].parameters.rPrePrintingPos					:= 75.0;  //PrePrinting Position

		gBlock[iIndexBlock].parameters.Motor.rAutoSpeedMoveDown	:=30.0;
		gBlock[iIndexBlock].parameters.Motor.rAutoSpeedMoveUp	:=30.0;
		gBlock[iIndexBlock].parameters.Motor.xFastSpeedAllowed	:= FALSE;
		
		gBlock[iIndexBlock].parameters.Motor.DriveUnit.TransmissionType := TRANS_SCREW_PITCH;
		gBlock[iIndexBlock].parameters.Motor.DriveUnit.ScrewPitch.PulsesPerTurn := GC_UNITS_BY_REV_DRIVE;
		gBlock[iIndexBlock].parameters.Motor.DriveUnit.ScrewPitch.GearBox := 10.0;
		gBlock[iIndexBlock].parameters.Motor.DriveUnit.ScrewPitch.Pitch := 5.0;
		
		gBlock[iIndexBlock].parameters.Motor.rReferencePosition		:= 11.5;
		
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

		gBlock[iIndexBlock].parameters.Inks.iMaxMachinePrintBars	:= 2;
		gBlock[iIndexBlock].parameters.Inks.iMaxBlockPrintBars		:= 2;
		gBlock[iIndexBlock].parameters.Inks.iMaxPSUwattsForBars		:= 3000;
				
		gBlock[iIndexBlock].parameters.xCappingProcess := FALSE;
		
		gBlock[iIndexBlock].parameters.Hw.SafetySignals := SAFETY_ESTOP_CALCULATED;

		//[RGP] Due to issue SUSTPLATF-236
		gBlock[iIndexBlock].parameters.xMotorOffsetAllowed := FALSE;
		
		gBlock[iIndexBlock].parameters.iApplicationBars := 2;
	END_FOR


	
	///////////////////////////////////////////////////
	/////PHOTOCELLS		PHOTOCELLS		 PHOTOCELLS////
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
	gPhotoCells.parameters.rSensorMechPositionByPass := 65.0; //ALX -> ToReview
	gPhotoCells.parameters.Sensors[2].rDistanceRelativeToFirstSensor := 4;
	gPhotoCells.parameters.Sensors[3].rDistanceRelativeToFirstSensor := 8;
	gPhotoCells.parameters.xEnableMountedAlrByPass := TRUE;

	//Digital Inputs
	gPhotoCells.Inputs.Signals.pInput[1]	:= ADR (X1.DInput[1]);
	gPhotoCells.Inputs.Signals.pInput[2]	:= ADR (X1.DInput[2]);
	gPhotoCells.Inputs.Signals.pInput[3]	:= ADR (X1.DInput[3]);
	gPhotoCells.Inputs.Signals.xSafetyEnable := gMachine.In.xSafetyEnabled;
	
	stepperMotor ACCESS ADR (gAxis[gPhotoCells.parameters.IndexDriveMaster]);
	stepperMotor.Parameter.Direction:= MOTOR_NEGATIVE_AXIS;
	
	///////////////////////////////////////////////////
	/////DING			DING		DING	  DING/////
	///////////////////////////////////////////////////
	gDing.Parameters.xDingInstalled := FALSE;
	
	///////////////////////////////////////////////////
	/////THICKNESS		THICKNESS		 THICKNESS/////
	///////////////////////////////////////////////////
	
	//Configuring machine transport because some values are different in two blocks
	CASE gMachine.Pt.MachineModel OF
		Type_SHLD:
			gThicknessCtrl.parameters.iTotalBlocksLengh := 130;
			gThicknessCtrl.parameters.Belt.iDistanceEmptyBeltIni := 240;
		Type_SHLD_L:
			gThicknessCtrl.parameters.iTotalBlocksLengh := 130;
			gThicknessCtrl.parameters.Belt.iDistanceEmptyBeltIni := 390;
	END_CASE
	
	gThicknessCtrl.parameters.xMarginForBendTile := TRUE;
	gThicknessCtrl.parameters.rSafetyMarginToHeight := 3.0;
	
	gThicknessCtrl.parameters.sections[1].xEnabled	:= TRUE;
	gThicknessCtrl.parameters.sections[1].iStart	:= 1;
	gThicknessCtrl.parameters.sections[1].iEnd		:= 130;
	
	gThicknessCtrl.parameters.Detection.ProductDetect.xLoadMedia := FALSE;
	gThicknessCtrl.parameters.Detection.ProductDetect.iSensorPosition := 25;
	gThicknessCtrl.parameters.Detection.Analog.xLoadMedia := TRUE;
	gThicknessCtrl.parameters.Detection.Analog.iSensorPosition := 0;
	gThicknessCtrl.parameters.Detection.Array.xLoadMedia := TRUE;
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
	/////   CHILLER 	CHILLER 	CHILLER 	/////////
	/////////////////////////////////////////////////////
	gMachine.Pt.Hw.iMaxNumChillers:=1;
	gChiller[1].Parameters.xInstalled := TRUE;
	gChiller[1].Parameters.SystemType := CHILLERSYS_WATERMANIFOLD;
			
	FOR iIndexInks:=1 TO MAX_LAST_INK DO		
		gInks[iIndexInks].parameters.InksChiller.iIndex:=1;
	END_FOR
	
	
	// Always the last BLOCK of code
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
	
	AsignCardsSHLD;

END_ACTION

ACTION AsignCardsSHLD:
	
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
	gPlcCards[iIndexPlcCar].stCardName := 'X2CP1382-X1_5N1';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[2].Details := '';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[4].Details := '';
	gPlcCards[iIndexPlcCar].Texts[5].Details := '';
	gPlcCards[iIndexPlcCar].Texts[6].Details := '';
	gPlcCards[iIndexPlcCar].Texts[7].Details := '3L-Detected tile(Phtcll 1)';
	gPlcCards[iIndexPlcCar].Texts[8].Details := '3L-Belt tile(Phtcll 2)';
	gPlcCards[iIndexPlcCar].Texts[9].Details := '3L-Mounted tile(Phtcll 3)';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'Bars ref. sensor-ON signa';
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
	gPlcCards[iIndexPlcCar].stCardName := 'X2CP1382-X2_5N1';
	gPlcCards[iIndexPlcCar].Texts[1].Details := '0Q21-Alarm(Transp. Driver)';
	gPlcCards[iIndexPlcCar].Texts[2].Details := '2Q35-Alarm(Elev. Driver)';
	gPlcCards[iIndexPlcCar].Texts[3].Details := '0D10-Alarm(48 VDC PH PSU)';
	gPlcCards[iIndexPlcCar].Texts[4].Details := '3T1-Thermostat alarm';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'PD-Broken sensor alarm';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'DPT-Broken sensor alarm';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'UPS-Failure UPS';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'UPS-Utility Failure';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'UPS-Low Battery';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'UPS-Inverter Failure';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[13].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[14].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 3 X3
	gPlcCards[iIndexPlcCar].Type := CARD_X3;
	gPlcCards[iIndexPlcCar].pCard := ADR(X3);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X2CP1382-X3_5N1';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'PC start from PLC';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'Reset Carriage Board';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'Reset Route';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'Spare';
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
	
	//CARD 4 Digital Input
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DIF371_001);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371_001';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'Bar A Klixon';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'Bar B Klixon';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'Tank A - Empty Level';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'Tank B - Empty Level';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'Tank A - Full Level';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'Tank B - Full Level';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'Tank A - Presure Switch';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'Tank B - Presure Switch';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[13].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[14].Details := 'Bars heater - 48VDC PSU OK';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'Bar A - 48VDC PSU OK';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'Bar B - 48VDC PSU OK';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 5 Digital Input
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DIF371_002);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371_002';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'Consents Line - Machine 1';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'Consents Line - Machine 2';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'Printhead External Cleaning';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'Start';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'Stop';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'Automatic';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'Zero';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'Manual';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'Validation to PLC';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'Machine confg. - Bit 1';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'Machine config. - Bit 2';
	gPlcCards[iIndexPlcCar].Texts[13].Details := 'Machine config. - Bit 3';
	gPlcCards[iIndexPlcCar].Texts[14].Details := 'Machine config. - Bit 4';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	
	//CARD 6 Digital Input
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DIF371_003);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371_003';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'CB to PLC - Print trigger L2';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'CB to PLC - Print trigger L1';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'PC2 OK';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'Spare';
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
	
	//CARD 7 Digital Input
	gPlcCards[iIndexPlcCar].Type := CARD_DI16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DIF371_004);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DIF371_004';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'Chiller - Run OK';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'Chiller - General alarm';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'Water clean-Level sensor';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'Water clean-Pressure sensor';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'Safety module OK';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'Front Safety Switch-Alarm';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'Back Safety Switch-Alarm';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[13].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[14].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 8 Digital Output
	gPlcCards[iIndexPlcCar].Type := CARD_DO16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DOF322_005);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DOF322_005';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'Bar A - 48 VDC PH PSU ON';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'Bar B - 48 VDC PH PSU ON';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'Bar A - Heating ON';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'Bar B - Heating ON';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'Bar A - Reverse _Solenoid 1 - 4';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'Bar B - Reverse _Solenoid 1 - 4';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'Bar A - Reverse _Solenoid 2 - 3';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'Bar B - Reverse _Solenoid 2 - 3';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'Bar A - Manifold tank EV';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'Bar B - Manifold tank EV';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'Chiller - Start';
	gPlcCards[iIndexPlcCar].Texts[13].Details := 'Cooling unit - Start';
	gPlcCards[iIndexPlcCar].Texts[14].Details := 'DTP Enable';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'PLC to CB - Simulation PD1';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'PLC to CB - Simulation PD2';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 9 Digital Output
	gPlcCards[iIndexPlcCar].Type := CARD_DO16;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20DOF322_006);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20DOF322_006';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'Consent - Line 1';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'Consent - Line 2';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'Compenser Line 1';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'Compenser Line 2';
	gPlcCards[iIndexPlcCar].Texts[5].Details := 'Warning Machine(Yellow)';
	gPlcCards[iIndexPlcCar].Texts[6].Details := 'Emergency Status(Red)';
	gPlcCards[iIndexPlcCar].Texts[7].Details := 'Line 1 - Ready Clean Up';
	gPlcCards[iIndexPlcCar].Texts[8].Details := 'Line 2 - Ready Clean Up';
	gPlcCards[iIndexPlcCar].Texts[9].Details := 'Suction Turbine';
	gPlcCards[iIndexPlcCar].Texts[10].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[11].Details := 'Spare';
	gPlcCards[iIndexPlcCar].Texts[12].Details := 'Status PLC-Run';
	gPlcCards[iIndexPlcCar].Texts[13].Details := 'Zero mode-Air supply off';
	gPlcCards[iIndexPlcCar].Texts[14].Details := 'Start Green Light ON';
	gPlcCards[iIndexPlcCar].Texts[15].Details := 'Reset blue light ON';
	gPlcCards[iIndexPlcCar].Texts[16].Details := 'Buzzer';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 10 Power Supply
	gPlcCards[iIndexPlcCar].Type := CARD_PS33;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20PS3300_007);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20PS3300_007';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 11 Analog Input
	gPlcCards[iIndexPlcCar].Type := CARD_AI4;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AI4322_008);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AI4322_008';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'BarA-Pos Manifold Pres. Sensor';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'BarB-Pos Manifold Pres. Sensor';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'BarA-Neg Manifold Pres. Sensor';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'BarB-Neg Manifold Pres. Sensor';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 12 Analog Output
	gPlcCards[iIndexPlcCar].Type := CARD_AO4;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AO4622_009);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AO4622_009';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'BarA - Pump';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'BarB - Pump';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'TankA - Pump';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'TankB - Pump';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 13 Analog Input
	gPlcCards[iIndexPlcCar].Type := CARD_AT4;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20AT4222_010);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20AT4222_010';
	gPlcCards[iIndexPlcCar].Texts[1].Details := 'BarA - Temp Probe (Manifold)';
	gPlcCards[iIndexPlcCar].Texts[2].Details := 'BarB - Temp Probe (Manifold)';
	gPlcCards[iIndexPlcCar].Texts[3].Details := 'Chiller - Tank cabinet temp PT100';
	gPlcCards[iIndexPlcCar].Texts[4].Details := 'Chiller - In water temp PT100';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 14 Stepper Driver
	gPlcCards[iIndexPlcCar].Type := CARD_SM;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20SM1436_011);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20SM1436_011';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//CARD 15 Stepper Driver
	gPlcCards[iIndexPlcCar].Type := CARD_SM;
	gPlcCards[iIndexPlcCar].pCard := ADR(X20SM1436_012);
	gPlcCards[iIndexPlcCar].RequiredForFunctions[0] := CARDREQUIRED_ALWAYS;
	gPlcCards[iIndexPlcCar].stCardName := 'X20SM1436_012';
	gPlcCards[iIndexPlcCar].Location := CardInPrinter; 
	iIndexPlcCar := iIndexPlcCar + 1;
	
	//END CARDS
	
	gPlcCards[iIndexPlcCar].Type := CARD_UNDEFINED;
	
END_ACTION