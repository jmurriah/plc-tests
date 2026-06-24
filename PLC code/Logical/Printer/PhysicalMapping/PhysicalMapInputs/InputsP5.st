
ACTION InputsP5:
	
(* CABINET 01 *)
	
	
	// X20DIF371_001	        

	// gMachine.In.iMachineModelCode assigned in an specific Action

	gMachine.In.Buttons.xStart			:= X20DIF371_001.DInput[7];
	gMachine.In.Buttons.xStop			:= NOT X20DIF371_001.DInput[8];
	gMachine.In.Buttons.xAuto			:= X20DIF371_001.DInput[9];
	gMachine.In.Buttons.xZero			:= NOT X20DIF371_001.DInput[10];
	gMachine.In.Buttons.xManual			:= X20DIF371_001.DInput[11];
	//gMachine.In.Buttons.xReset		:= X20DIF371_001.DInput[12];
	gMachine.In.ProductDetect.pPDCarriageSignalL1 := ADR(X20DIF371_001.DInput[13]);
	gMachine.In.ProductDetect.pPDCarriageSignalL2 := ADR(X20DIF371_001.DInput[14]);
	//Reserve01.DInput[1]			:= X20DIF371_001.DInput[15];
	//Reserve01.DInput[1]	:= X20DIF371_001.DInput[16];
	
	// Reset and Mute with the same digital signal
	T_Reset.IN := X20DIF371_001.DInput[12];
	T_Reset.PT := t#250ms;
	T_Reset();
	
	T_Mute.IN := X20DIF371_001.DInput[12];
	T_Mute.PT := t#100ms;
	T_Mute();
	
	gMachine.In.Buttons.xReset:= T_Reset.Q;
	gMachine.In.Buttons.xMute:= T_Mute.Q;
	
	// X20DIF371_002
	gInksInputs[1].xPrintHeadsPsuOK		:= X20DIF371_002.DInput[1];
	gInksInputs[2].xPrintHeadsPsuOK		:= X20DIF371_002.DInput[2];
	gInksInputs[3].xPrintHeadsPsuOK		:= X20DIF371_002.DInput[3];
	gInksInputs[4].xPrintHeadsPsuOK		:= X20DIF371_002.DInput[4];
	gInksInputs[5].xPrintHeadsPsuOK		:= X20DIF371_002.DInput[5];
	gInksInputs[6].xPrintHeadsPsuOK		:= X20DIF371_002.DInput[6];	
	gInksInputs[7].xPrintHeadsPsuOK		:= X20DIF371_002.DInput[7];
	gInksInputs[8].xPrintHeadsPsuOK		:= X20DIF371_002.DInput[8];
	gBlockInputs[1].xHeaterDcOkBusBar1	:= X20DIF371_002.DInput[9];
	gBelt.parameters.xDriveProtectionOK	:= X20DIF371_002.DInput[10];
	gBlockInputs[1].xDriveProtectionOK	:= X20DIF371_002.DInput[11];
	gBlockInputs[1].xDifferentialOK		:= X20DIF371_002.DInput[12];
	gMachine.In.x24Vdc					:= X20DIF371_002.DInput[13];
	gBlockInputs[1].Safety.xCurtainEnable01	:= X20DIF371_002.DInput[14];//Same Input
	gBlockInputs[1].Safety.xCurtainEnable02	:= X20DIF371_002.DInput[14];//Same Input
	gBlockInputs[1].Safety.xRearSafetyOK	:= X20DIF371_002.DInput[15];
	gBlockInputs[1].Safety.xSafetyOK			:= X20DIF371_002.DInput[16];	
		
	// X20DIF371_003
	gMachine.In.UPSs[1].xSystemFault			:= NOT X20DIF371_003.DInput[1];
	gMachine.In.UPSs[1].xPowerFault				:= NOT X20DIF371_003.DInput[2];
	gMachine.In.UPSs[1].xLowBattery					:= NOT X20DIF371_003.DInput[3];
	gMachine.In.UPSs[1].xByPass					:= NOT X20DIF371_003.DInput[4];
	gMachine.In.UPSs[2].xSystemFault			:= NOT X20DIF371_003.DInput[5];
	gMachine.In.UPSs[2].xPowerFault				:= NOT X20DIF371_003.DInput[6];
	gMachine.In.UPSs[2].xLowBattery					:= NOT X20DIF371_003.DInput[7];
	gMachine.In.UPSs[2].xByPass					:= NOT X20DIF371_003.DInput[8];
	gBlockInputs[1].xReferenceDI				:= X20DIF371_003.DInput[9];
	gMachine.In.ProductDetect.pPDSignalSensorL1	:= ADR(X20DIF371_003.DInput[11]);
	gMachine.In.ProductDetect.pPDSignalSensorL2	:= ADR(X20DIF371_003.DInput[12]);

	// Those variables are not mapped. Are fast and assigned with pointer
	//gPhotoCells.Inputs.Signals.xPhotoCells[1]		:= NOT X20DIF371_003.DInput[13];//Same Input
	gDing.In.xDingLow							:= X20DIF371_003.DInput[13];//Same Input
	//gPhotoCells.Inputs.Signals.xPhotoCells[2]		:= NOT X20DIF371_003.DInput[14];
	//gPhotoCells.Inputs.Signals.xPhotoCells[3]		:= NOT X20DIF371_003.DInput[15];//Same Input
	gDing.In.xDingHigh							:= X20DIF371_003.DInput[15];//Same Input
	//Reserve01.DInput[1]						:= X20DIF371_003.DInput[16];

	// X20DIF371_004
	gInksInputs[1].xKlixonTriggered		:=X20DIF371_004.DInput[1];
	gInksInputs[2].xKlixonTriggered		:=X20DIF371_004.DInput[2];
	gInksInputs[3].xKlixonTriggered		:=X20DIF371_004.DInput[3];
	gInksInputs[4].xKlixonTriggered		:=X20DIF371_004.DInput[4];
	gInksInputs[5].xKlixonTriggered		:=X20DIF371_004.DInput[5];
	gInksInputs[6].xKlixonTriggered		:=X20DIF371_004.DInput[6];
	gInksInputs[7].xKlixonTriggered		:=X20DIF371_004.DInput[7];
	gInksInputs[8].xKlixonTriggered		:=X20DIF371_004.DInput[8];
	gInksInputs[1].xMinLevel			:=X20DIF371_004.DInput[9];
	gInksInputs[2].xMinLevel			:=X20DIF371_004.DInput[10];
	gInksInputs[3].xMinLevel			:=X20DIF371_004.DInput[11];
	gInksInputs[4].xMinLevel			:=X20DIF371_004.DInput[12];
	gInksInputs[5].xMinLevel			:=X20DIF371_004.DInput[13];
	gInksInputs[6].xMinLevel			:=X20DIF371_004.DInput[14];
	gInksInputs[7].xMinLevel			:=X20DIF371_004.DInput[15];
	gInksInputs[8].xMinLevel			:=X20DIF371_004.DInput[16];
	
	// X20DIF371_005
	gInksInputs[1].xMaxLevel		:= X20DIF371_005.DInput[1];
	gInksInputs[2].xMaxLevel		:= X20DIF371_005.DInput[2];
	gInksInputs[3].xMaxLevel		:= X20DIF371_005.DInput[3];
	gInksInputs[4].xMaxLevel		:= X20DIF371_005.DInput[4];
	gInksInputs[5].xMaxLevel		:= X20DIF371_005.DInput[5];
	gInksInputs[6].xMaxLevel		:= X20DIF371_005.DInput[6];
	gInksInputs[7].xMaxLevel		:= X20DIF371_005.DInput[7];
	gInksInputs[8].xMaxLevel		:= X20DIF371_005.DInput[8];
	gInksInputs[1].xOverpressure	:= NOT X20DIF371_005.DInput[9];
	gInksInputs[2].xOverpressure 	:= NOT X20DIF371_005.DInput[10];
	gInksInputs[3].xOverpressure 	:= NOT X20DIF371_005.DInput[11];
	gInksInputs[4].xOverpressure	:= NOT X20DIF371_005.DInput[12];
	gInksInputs[5].xOverpressure 	:= NOT X20DIF371_005.DInput[13];
	gInksInputs[6].xOverpressure 	:= NOT X20DIF371_005.DInput[14];
	gInksInputs[7].xOverpressure 	:= NOT X20DIF371_005.DInput[15];
	gInksInputs[8].xOverpressure 	:= NOT X20DIF371_005.DInput[16];

	// X20DIF371_006
	gMachine.In.xPbfCardOK 				:= X20DIF371_006.ModuleOk;
	gMachine.In.iRelieve1.0				:= X20DIF371_006.DInput[1];
	gMachine.In.iRelieve1.1				:= X20DIF371_006.DInput[2];
	gMachine.In.iRelieve1.2				:= X20DIF371_006.DInput[3];
	gMachine.In.iRelieve1.3				:= X20DIF371_006.DInput[4];
	gMachine.In.iRelieve1.4				:= X20DIF371_006.DInput[5];
	gMachine.In.iRelieve1.5				:= X20DIF371_006.DInput[6];
	gMachine.In.iRelieve1.6				:= X20DIF371_006.DInput[7];
	gMachine.In.iRelieve1.7				:= X20DIF371_006.DInput[8];
	gMachine.In.iRelieve1.8				:= X20DIF371_006.DInput[9];
	gMachine.In.xConsentL1Ok			:= X20DIF371_006.DInput[10];
	gMachine.In.xConsentL2Ok			:= X20DIF371_006.DInput[11];
	gMachine.In.xExternalCleaningOrder	:= X20DIF371_006.DInput[12];
	gBlockInputs[1].xWaterLevelSensor	:= X20DIF371_006.DInput[13];
	gBlockInputs[1].xWaterPresureSensor	:= X20DIF371_006.DInput[14];
	//Reserve01.DInput[0]				:= X20DIF371_006.DInput[15];
	//Reserve01.DInput[0]				:= X20DIF371_006.DInput[16];

	
	// X20DI9372_008
	gBlockInputs[1].xPrintHeadPSU[1]		:= X20DI9372_008.DInput[1];
	gBlockInputs[1].xPrintHeadPSU[2]		:= X20DI9372_008.DInput[2];
	gBlockInputs[1].xPrintHeadPSU[3]		:= X20DI9372_008.DInput[3];
	gBlockInputs[1].xPrintHeadPSU[4]		:= X20DI9372_008.DInput[4];
	gBlockInputs[1].xPrintHeadPSU[5]		:= X20DI9372_008.DInput[5];
	gBlockInputs[1].xPrintHeadPSU[6]		:= X20DI9372_008.DInput[6];
	gBlockInputs[1].xHeaterDcOkPsu[1]	:= X20DI9372_008.DInput[7];
	gBlockInputs[1].xHeaterDcOkPsu[2]	:= X20DI9372_008.DInput[8];
	gBlockInputs[1].xHeaterDcOkPsu[3]	:= X20DI9372_008.DInput[9];
	//Reserve01.DInput[0]			:=X20DI9372_008.DInput[10];
	//Reserve01.DInput[0]			:=X20DI9372_008.DInput[11];
	//Reserve01.DInput[0]			:=X20DI9372_008.DInput[12];

	// X20AI8321_015		(*  BAR A *) (*  BAR B *) (*  BAR C *) (*  BAR D *)
	gInksInputs[1].iVacuum1Raw			:= X20AI8321_015.AInput[1];
	gInksInputs[1].xVacuum1SensorError	:= StatusAnalogInputBroken(X20AI8321_015.ModuleOk, X20AI8321_015.Status01, X20AI8321_015.Status02, 1);
	gInksInputs[1].iVacuum2Raw			:= X20AI8321_015.AInput[2];
	gInksInputs[1].xVacuum2SensorError	:= StatusAnalogInputBroken(X20AI8321_015.ModuleOk, X20AI8321_015.Status01, X20AI8321_015.Status02, 2);
	gInksInputs[2].iVacuum1Raw			:= X20AI8321_015.AInput[3];
	gInksInputs[2].xVacuum1SensorError	:= StatusAnalogInputBroken(X20AI8321_015.ModuleOk, X20AI8321_015.Status01, X20AI8321_015.Status02, 3);
	gInksInputs[2].iVacuum2Raw			:= X20AI8321_015.AInput[4];
	gInksInputs[2].xVacuum2SensorError	:= StatusAnalogInputBroken(X20AI8321_015.ModuleOk, X20AI8321_015.Status01, X20AI8321_015.Status02, 4);
	gInksInputs[3].iVacuum1Raw			:= X20AI8321_015.AInput[5];
	gInksInputs[3].xVacuum1SensorError	:= StatusAnalogInputBroken(X20AI8321_015.ModuleOk, X20AI8321_015.Status01, X20AI8321_015.Status02, 5);
	gInksInputs[3].iVacuum2Raw			:= X20AI8321_015.AInput[6];
	gInksInputs[3].xVacuum2SensorError	:= StatusAnalogInputBroken(X20AI8321_015.ModuleOk, X20AI8321_015.Status01, X20AI8321_015.Status02, 6);
	gInksInputs[4].iVacuum1Raw			:= X20AI8321_015.AInput[7];
	gInksInputs[4].xVacuum1SensorError	:= StatusAnalogInputBroken(X20AI8321_015.ModuleOk, X20AI8321_015.Status01, X20AI8321_015.Status02, 7);
	gInksInputs[4].iVacuum2Raw			:= X20AI8321_015.AInput[8];
	gInksInputs[4].xVacuum2SensorError	:= StatusAnalogInputBroken(X20AI8321_015.ModuleOk, X20AI8321_015.Status01, X20AI8321_015.Status02, 8);
	
	// X20AI8321_016		(* BAR E *) (* BAR F *) (* BAR G *) (* BAR H *)
	gInksInputs[5].iVacuum1Raw			:= X20AI8321_016.AInput[1];
	gInksInputs[5].xVacuum1SensorError	:= StatusAnalogInputBroken(X20AI8321_016.ModuleOk, X20AI8321_016.Status01, X20AI8321_016.Status02, 1);
	gInksInputs[5].iVacuum2Raw			:= X20AI8321_016.AInput[2];
	gInksInputs[5].xVacuum2SensorError	:= StatusAnalogInputBroken(X20AI8321_016.ModuleOk, X20AI8321_016.Status01, X20AI8321_016.Status02, 2);
	gInksInputs[6].iVacuum1Raw			:= X20AI8321_016.AInput[3];
	gInksInputs[6].xVacuum1SensorError	:= StatusAnalogInputBroken(X20AI8321_016.ModuleOk, X20AI8321_016.Status01, X20AI8321_016.Status02, 3);
	gInksInputs[6].iVacuum2Raw			:= X20AI8321_016.AInput[4];
	gInksInputs[6].xVacuum2SensorError	:= StatusAnalogInputBroken(X20AI8321_016.ModuleOk, X20AI8321_016.Status01, X20AI8321_016.Status02, 4);
	gInksInputs[7].iVacuum1Raw			:= X20AI8321_016.AInput[5];
	gInksInputs[7].xVacuum1SensorError	:= StatusAnalogInputBroken(X20AI8321_016.ModuleOk, X20AI8321_016.Status01, X20AI8321_016.Status02, 5);
	gInksInputs[7].iVacuum2Raw			:= X20AI8321_016.AInput[6];
	gInksInputs[7].xVacuum2SensorError	:= StatusAnalogInputBroken(X20AI8321_016.ModuleOk, X20AI8321_016.Status01, X20AI8321_016.Status02, 6);
	gInksInputs[8].iVacuum1Raw			:= X20AI8321_016.AInput[7];
	gInksInputs[8].xVacuum1SensorError	:= StatusAnalogInputBroken(X20AI8321_016.ModuleOk, X20AI8321_016.Status01, X20AI8321_016.Status02, 7);
	gInksInputs[8].iVacuum2Raw			:= X20AI8321_016.AInput[8];
	gInksInputs[8].xVacuum2SensorError	:= StatusAnalogInputBroken(X20AI8321_016.ModuleOk, X20AI8321_016.Status01, X20AI8321_016.Status02, 8);
	
	// X20AT4222_22
	gBlockInputs[1].xModuleTemp01Ok		:= X20AT4222_022.ModuleOk;
	gInksInputs[1].iTemperatureRaw		:= X20AT4222_022.TempInput[1];
	gInksInputs[1].xTempSensorError		:= StatusTemperatureInput(X20AT4222_022.Status01, 1);
	gInksInputs[2].iTemperatureRaw		:= X20AT4222_022.TempInput[2];
	gInksInputs[2].xTempSensorError		:= StatusTemperatureInput(X20AT4222_022.Status01, 2);
	gInksInputs[3].iTemperatureRaw		:= X20AT4222_022.TempInput[3];
	gInksInputs[3].xTempSensorError		:= StatusTemperatureInput(X20AT4222_022.Status01, 3);
	gInksInputs[4].iTemperatureRaw		:= X20AT4222_022.TempInput[4];
	gInksInputs[4].xTempSensorError		:= StatusTemperatureInput(X20AT4222_022.Status01, 4);
	
	
	// X20AT4222_23
	gBlockInputs[1].xModuleTemp02Ok		:= X20AT4222_023.ModuleOk;
	gInksInputs[5].iTemperatureRaw		:= X20AT4222_023.TempInput[1];
	gInksInputs[5].xTempSensorError		:= StatusTemperatureInput(X20AT4222_023.Status01, 1);
	gInksInputs[6].iTemperatureRaw		:= X20AT4222_023.TempInput[2];
	gInksInputs[6].xTempSensorError		:= StatusTemperatureInput(X20AT4222_023.Status01, 2);
	gInksInputs[7].iTemperatureRaw		:= X20AT4222_023.TempInput[3];
	gInksInputs[7].xTempSensorError		:= StatusTemperatureInput(X20AT4222_023.Status01, 3);
	gInksInputs[8].iTemperatureRaw		:= X20AT4222_023.TempInput[4];
	gInksInputs[8].xTempSensorError		:= StatusTemperatureInput(X20AT4222_023.Status01, 4);
	
	// X20AI2636_024
	gDing.In.xModuleOK := X20AI2636_100.ModuleOk;
	gDing.In.xDingChannelFault := X20AI2636_100.DInput[1];
	
	// X20SM1436_024 & X20SM1436_025
	gPhotoCells.status.xBackModuleOk := X20SM1436_111.ModuleOk;
	gPhotoCells.status.xFrontModuleOk := X20SM1436_112.ModuleOk;
	
	// X20AT4222_027
	gBlockInputs[1].xModuleTemp03Ok		:= X20AT4222_027.ModuleOk;
	gInksInputs[1].iTemperatureTankRaw	:= X20AT4222_027.TempInput[1];
	gInksInputs[1].xTempTankSensorError	:= StatusTemperatureInput(X20AT4222_027.Status01, 1);
	gInksInputs[2].iTemperatureTankRaw	:= X20AT4222_027.TempInput[2];
	gInksInputs[2].xTempTankSensorError	:= StatusTemperatureInput(X20AT4222_027.Status01, 2);
	gInksInputs[3].iTemperatureTankRaw	:= X20AT4222_027.TempInput[3];
	gInksInputs[3].xTempTankSensorError	:= StatusTemperatureInput(X20AT4222_027.Status01, 3);
	gInksInputs[4].iTemperatureTankRaw	:= X20AT4222_027.TempInput[4];
	gInksInputs[4].xTempTankSensorError	:= StatusTemperatureInput(X20AT4222_027.Status01, 4);
	
	
	// X20AT4222_028
	gBlockInputs[1].xModuleTemp04Ok		:= X20AT4222_028.ModuleOk;
	gInksInputs[5].iTemperatureTankRaw	:= X20AT4222_028.TempInput[1];
	gInksInputs[5].xTempTankSensorError	:= StatusTemperatureInput(X20AT4222_028.Status01, 1);
	gInksInputs[6].iTemperatureTankRaw	:= X20AT4222_028.TempInput[2];
	gInksInputs[6].xTempTankSensorError	:= StatusTemperatureInput(X20AT4222_028.Status01, 2);
	gInksInputs[7].iTemperatureTankRaw	:= X20AT4222_028.TempInput[3];
	gInksInputs[7].xTempTankSensorError	:= StatusTemperatureInput(X20AT4222_028.Status01, 3);
	gInksInputs[8].iTemperatureTankRaw	:= X20AT4222_028.TempInput[4];
	gInksInputs[8].xTempTankSensorError	:= StatusTemperatureInput(X20AT4222_028.Status01, 4);
	

	// SI UNIT BK1	
	gBlockInputs[1].xSiUnitModuleOk		:= SiUnitPwrLnkBK1.ModuleOk;
	gMachine.In.xAirSupply				:= SiUnitPwrLnkBK1.Input01_16.0;
	gBlockInputs[1].xAirVenturiOK		:= SiUnitPwrLnkBK1.Input01_16.1;
	gBlockInputs[1].xTrayOut			:= SiUnitPwrLnkBK1.Input01_16.2;
	gBlockInputs[1].xIclaSensor			:= SiUnitPwrLnkBK1.Input01_16.3;
	gTransVacuum[1].Inputs.xVaccAirFlow	:= SiUnitPwrLnkBK1.Input01_16.4;
	gTransVacuum[1].Inputs.xJointSystemPressure:= SiUnitPwrLnkBK1.Input01_16.5;
	gBlockInputs[1].xBarsIn := TRUE;
	gTransVacuum[1].Inputs.xSafetyEnable := gTransVacuum[2].Inputs.xSafetyEnable := TRUE; //gMachine.In.xSafetyEnabled;
		
	gTransVacuum[2].Inputs.xJointSystemPressure := gTransVacuum[1].Inputs.xJointSystemPressure; //Repeat inputs
	gTransVacuum[2].Inputs.xVaccAirFlow	:= gTransVacuum[1].Inputs.xVaccAirFlow;
		
	//Signals Forced by Configuration
	gBlockInputs[1].Safety.xFrontSafetyOK	:= TRUE;
	gBlockInputs[2].Safety.xFrontSafetyOK	:= TRUE;
	
	gBlockInputs[1].Safety.xFrontEStopOK := TRUE;
	gBlockInputs[2].Safety.xFrontEStopOK := TRUE;	
	
	FOR iIndexBlock := 1 TO gMachine.Pt.CT.iNumBlocks DO
		
		gBlockInputs[iIndexBlock].xHeaterDcOkBusBar2 := TRUE;
		gBlockInputs[iIndexBlock].xHeaterAcOkPsu[1] := TRUE;
		gBlockInputs[iIndexBlock].xHeaterAcOkPsu[2] := TRUE;
		gBlockInputs[iIndexBlock].xHeaterAcOkPsu[3] := TRUE;
		
		gBlock[iIndexBlock].parameters.Hw.iNumPrintheadsPSU := 6;
		gBlock[iIndexBlock].parameters.Hw.iNumHeaterPSU := 3;
				
	END_FOR	
		
END_ACTION
