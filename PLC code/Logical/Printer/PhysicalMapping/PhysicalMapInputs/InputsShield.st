
ACTION InputsShield:
	
(* CABINET 01 *)

	//X1 PLC

	// Those variables are not mapped. Are fast and assigned with pointer
	//	gPhotoCells.Inputs.Signals.xPhotoCells[1]	:= NOT X1.DInput[1];
	//	gPhotoCells.Inputs.Signals.xPhotoCells[2]	:= NOT X1.DInput[2];
	//	gPhotoCells.Inputs.Signals.xPhotoCells[3]	:= NOT X1.DInput[3];

	gBlockInputs[1].xReferenceDI			:= X1.DInput[4];

	//X2 PLC
	gBelt.parameters.xDriveProtectionOK			:= X2.DInput[1];
	gBlockInputs[1].xDriveProtectionOK			:= X2.DInput[2];
	gBlockInputs[1].xDifferentialOK				:= X2.DInput[3];
	gMachine.In.xCoolingPCSensorAlrm			:= X2.DInput[4];
	gMachine.In.ProductDetect.pPDSignalSensorL1	:= ADR(X2.DInput[5]);
	gMachine.In.ProductDetect.pPDSignalSensorL2	:= ADR(X2.DInput[6]);
	gMachine.In.UPSs[1].xSystemFault			:= NOT X2.DInput[7];
	gMachine.In.UPSs[1].xPowerFault				:= NOT X2.DInput[8];
	gMachine.In.UPSs[1].xLowBattery					:= NOT X2.DInput[9];
	gMachine.In.UPSs[1].xByPass					:= NOT X2.DInput[10];
	
	// X20DIF371_001
	gInksInputs[1].xKlixonTriggered		:= X20DIF371_001.DInput[1];
	gInksInputs[2].xKlixonTriggered		:= X20DIF371_001.DInput[2];
	gInksInputs[1].xMinLevel			:= X20DIF371_001.DInput[3];
	gInksInputs[2].xMinLevel			:= X20DIF371_001.DInput[4];
	gInksInputs[1].xMaxLevel			:= X20DIF371_001.DInput[5];
	gInksInputs[2].xMaxLevel			:= X20DIF371_001.DInput[6];
	gInksInputs[1].xOverpressure 		:= NOT X20DIF371_001.DInput[7];
	gInksInputs[2].xOverpressure 		:= NOT X20DIF371_001.DInput[8];
	//Reserve01.DInput[1]					:= X20DIF371_001.DInput[9];
	//Reserve01.DInput[1]					:= X20DIF371_001.DInput[10];
	//Reserve01.DInput[1]					:= X20DIF371_001.DInput[11];
	//Reserve01.DInput[1]					:= X20DIF371_001.DInput[12];
	//Reserve01.DInput[1]					:= X20DIF371_001.DInput[13];
	gBlockInputs[1].xHeaterDcOkBusBar1	:= X20DIF371_001.DInput[14];
	gInksInputs[1].xPrintHeadsPsuOK		:= X20DIF371_001.DInput[15];
	gInksInputs[2].xPrintHeadsPsuOK		:= X20DIF371_001.DInput[16];



	// X20DIF371_002
	gMachine.In.xConsentL1Ok			:= X20DIF371_002.DInput[1];
	gMachine.In.xConsentL2Ok			:= X20DIF371_002.DInput[2];
	gMachine.In.xExternalCleaningOrder	:= X20DIF371_002.DInput[3];
	//Reserve01.DInput[1]					:= X20DIF371_002.DInput[4];
	gMachine.In.Buttons.xStart					:= X20DIF371_002.DInput[5];
	gMachine.In.Buttons.xStop					:= NOT X20DIF371_002.DInput[6];
	gMachine.In.Buttons.xAuto					:= X20DIF371_002.DInput[7];
	gMachine.In.Buttons.xZero					:= NOT X20DIF371_002.DInput[8];
	gMachine.In.Buttons.xManual					:= X20DIF371_002.DInput[9];
	//gMachine.In.Buttons.xReset					:= X20DIF371_002.DInput[10];
	
	// gMachine.In.iMachineModelCode assigned in an specific Action

	//Reserve01.DInput[1] 				:= X20DIF371_002.DInput[15];
	//Reserve01.DInput[1] 				:= X20DIF371_002.DInput[16];
	
	// Reset and Mute with the same digital signal
	T_Reset.IN := X20DIF371_002.DInput[10];
	T_Reset.PT := t#250ms;
	T_Reset();
	
	T_Mute.IN := X20DIF371_002.DInput[10];
	T_Mute.PT := t#100ms;
	T_Mute();
	
	gMachine.In.Buttons.xReset:= T_Reset.Q;
	gMachine.In.Buttons.xMute:= T_Mute.Q;
	

	// X20DIF371_003
	gMachine.In.ProductDetect.pPDCarriageSignalL1 := ADR(X20DIF371_003.DInput[1]);
	gMachine.In.ProductDetect.pPDCarriageSignalL2 := ADR(X20DIF371_003.DInput[2]);
	Reserve01.DInput[3] 				:= X20DIF371_003.DInput[3];
	gMachine.In.xPC2Ok 					:= X20DIF371_003.DInput[4];
	//Reserve01.DInput[1] 				:= X20DIF371_003.DInput[5];
	//Reserve01.DInput[1] 				:= X20DIF371_003.DInput[6];
	//Reserve01.DInput[1]					:= X20DIF371_003.DInput[7];
	gMachine.In.xPbfCardOK 				:= X20DIF371_003.ModuleOk;
	gMachine.In.iRelieve1.0 			:= X20DIF371_003.DInput[8];
	gMachine.In.iRelieve1.1 			:= X20DIF371_003.DInput[9];
	gMachine.In.iRelieve1.2 			:= X20DIF371_003.DInput[10];
	gMachine.In.iRelieve1.3 			:= X20DIF371_003.DInput[11];
	gMachine.In.iRelieve1.4 			:= X20DIF371_003.DInput[12];
	gMachine.In.iRelieve1.5 			:= X20DIF371_003.DInput[13];
	gMachine.In.iRelieve1.6 			:= X20DIF371_003.DInput[14];
	gMachine.In.iRelieve1.7 			:= X20DIF371_003.DInput[15];
	gMachine.In.iRelieve1.8 			:= X20DIF371_003.DInput[16];

	

	// X20DIF371_004
	gChiller[1].In.xPowered				:= X20DIF371_004.DInput[1];
	gChiller[1].In.xCooling 			:= X20DIF371_004.DInput[1]; //xCooling input was asked in Nz2AQ but Shield's chiller has no cooling output. So assuming "Powered"="Running"
	gChiller[1].In.xAlarm	 			:= NOT X20DIF371_004.DInput[2];
	gBlockInputs[1].xWaterLevelSensor 	:= X20DIF371_004.DInput[3];
	gBlockInputs[1].xWaterPresureSensor	:= X20DIF371_004.DInput[4];
	//Reserve01.DInput[1] 				:= X20DIF371_004.DInput[5];
	//Reserve01.DInput[1] 				:= X20DIF371_004.DInput[6];
	//Reserve01.DInput[1] 				:= X20DIF371_004.DInput[7];
	//Reserve01.DInput[1] 				:= X20DIF371_004.DInput[8];
	gBlockInputs[1].Safety.xSafetyOK	  		:= X20DIF371_004.DInput[9];
	gBlockInputs[1].Safety.xFrontSafetyOK 		:= X20DIF371_004.DInput[10];
	gBlockInputs[1].Safety.xRearSafetyOK 		:= X20DIF371_004.DInput[11];
	//Reserve01.DInput[1] 				:= X20DIF371_004.DInput[12];
	//Reserve01.DInput[1] 				:= X20DIF371_004.DInput[13];
	//Reserve01.DInput[1] 				:= X20DIF371_004.DInput[14];
	//Reserve01.DInput[1] 				:= X20DIF371_004.DInput[15];
	//Reserve01.DInput[1] 				:= X20DIF371_004.DInput[16];
	
	// X20AI4322_008	(* BAR A *)		(* BAR B *)
	gInksInputs[1].iVacuum1Raw			:= X20AI4322_008.AInput[1];
	gInksInputs[1].xVacuum1SensorError	:= StatusAnalogInputBroken( X20AI4322_008.ModuleOk, X20AI4322_008.Status01, 0, 1);
	gInksInputs[2].iVacuum1Raw			:= X20AI4322_008.AInput[2];
	gInksInputs[2].xVacuum1SensorError	:= StatusAnalogInputBroken( X20AI4322_008.ModuleOk, X20AI4322_008.Status01, 0, 2);
	gInksInputs[1].iVacuum2Raw			:= X20AI4322_008.AInput[3];
	gInksInputs[1].xVacuum2SensorError	:= StatusAnalogInputBroken( X20AI4322_008.ModuleOk, X20AI4322_008.Status01, 0, 3);
	gInksInputs[2].iVacuum2Raw			:= X20AI4322_008.AInput[4];
	gInksInputs[2].xVacuum2SensorError	:= StatusAnalogInputBroken( X20AI4322_008.ModuleOk, X20AI4322_008.Status01, 0, 4);
	
	// X20AT4222_010
	gBlockInputs[1].xModuleTemp01Ok		:= X20AT4222_010.ModuleOk;
	gInksInputs[1].iTemperatureRaw		:= X20AT4222_010.TempInput[1];
	gInksInputs[1].xTempSensorError		:= StatusTemperatureInput(X20AT4222_010.Status01, 1);
	gInksInputs[2].iTemperatureRaw		:= X20AT4222_010.TempInput[2];
	gInksInputs[2].xTempSensorError		:= StatusTemperatureInput(X20AT4222_010.Status01, 2);
	gChiller[1].In.WaterManifold.iEnvironmentTempRaw	:= X20AT4222_010.TempInput[3];
	gChiller[1].In.WaterManifold.xTempEnvSensError	:= StatusTemperatureInput(X20AT4222_010.Status01, 3);
	gChiller[1].In.WaterManifold.iWaterManifoldTempRaw	:= X20AT4222_010.TempInput[4];
	gChiller[1].In.WaterManifold.xTempWatSensError	:= StatusTemperatureInput(X20AT4222_010.Status01, 4);
	
	// X20SM1436_11
	gPhotoCells.status.xBackModuleOk := X20SM1436_011.ModuleOk;
	
	// X20SM1436_12
	gPhotoCells.status.xFrontModuleOk := X20SM1436_012.ModuleOk;
	
	// SI UNIT BK1	
	gBlockInputs[1].xSiUnitModuleOk		:= SiUnitBK1.ModuleOk;  // Filter if it's necesary
	gMachine.In.xAirSupply				:= SiUnitBK1.Input01_08.0;
	gBlockInputs[1].xAirVenturiOK		:= SiUnitBK1.Input01_08.1;
	gBlockInputs[1].xTrayOut			:= SiUnitBK1.Input01_08.2;
	gBlockInputs[1].xIclaSensor			:= SiUnitBK1.Input01_08.3;   
	gBlockInputs[1].xBarsIn := TRUE;

	//Signals Forced by Configuration
	gMachine.In.UPSs[2].xPowerFault		:= FALSE;
	gMachine.In.UPSs[2].xByPass			:= FALSE;
	gMachine.In.UPSs[2].xLowBattery			:= FALSE;
	gMachine.In.UPSs[2].xSystemFault	:= FALSE;	
	gMachine.In.xPC1Ok				:= TRUE;
	gMachine.In.x24Vdc				:= TRUE;
	
	FOR iIndexBlock := 1 TO gMachine.Pt.CT.iNumBlocks DO
		
		gBlockInputs[iIndexBlock].Safety.xCurtainEnable01:= TRUE;
		gBlockInputs[iIndexBlock].Safety.xCurtainEnable02:= TRUE;
		gBlockInputs[iIndexBlock].Safety.xFrontEStopOK := TRUE;
		gBlockInputs[iIndexBlock].Safety.xRearEStopOK	:= TRUE;

		gBlockInputs[iIndexBlock].xModuleTemp02Ok	:= TRUE;
		gBlockInputs[iIndexBlock].xModuleTemp03Ok := TRUE;
		gBlockInputs[iIndexBlock].xModuleTemp04Ok := TRUE;
		
		gBlockInputs[iIndexBlock].xHeaterDcOkBusBar2 := TRUE;

		gBlock[iIndexBlock].parameters.Hw.iNumPrintheadsPSU := 0;
		gBlock[iIndexBlock].parameters.Hw.iNumHeaterPSU := 0;
		
	END_FOR
		

END_ACTION
