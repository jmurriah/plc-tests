
ACTION InputsMecano:
	
	
	//////////
	//PRINTER
	//////////
	
	// Machine controlled by line. Always with consent
	gMachine.In.xConsentL1Ok := TRUE;
	gMachine.In.xConsentL2Ok := TRUE;
	
	//Digital Inputs
	gMachine.In.Buttons.xStart := X20DIF371_101.DInput[1];
	gMachine.In.Buttons.xStop := NOT X20DIF371_101.DInput[2];
	gMachine.In.Buttons.xAuto := X20DIF371_101.DInput[3];
	gMachine.In.Buttons.xZero := NOT X20DIF371_101.DInput[4];
	gMachine.In.Buttons.xManual := X20DIF371_101.DInput[5];
	gMachine.In.Buttons.xReset := X20DIF371_101.DInput[6];
	//Back Safety Key unlock - PRINTER := X20DIF371_101.DInput[7];
	gBlockInputs[1].xReferenceDI := X20DIF371_101.DInput[8];
	gJamInputs[1].xJamLowCrash := X20DIF371_101.DInput[9];
	gJamInputs[2].xJamLowCrash := X20DIF371_101.DInput[10];
	gJamInputs[3].xJamLowCrash := X20DIF371_101.DInput[11];
	gJamInputs[1].xJamTestOk := X20DIF371_101.DInput[13];
	gJamInputs[2].xJamTestOk := X20DIF371_101.DInput[14];
	gJamInputs[3].xJamTestOk := X20DIF371_101.DInput[15];
	
	
	gBlockInputs[1].xPrintHeadPSU[1] := X20DIF371_102.DInput[1];
	gBlockInputs[1].xPrintHeadPSU[2] := X20DIF371_102.DInput[2];
	gBlockInputs[1].xPrintHeadPSU[3] := X20DIF371_102.DInput[3];
	gBlockInputs[1].xHeaterDcOkPsu[1] := gBlockInputs[1].xHeaterAcOkPsu[1] := X20DIF371_102.DInput[4];
	gInksInputs[3].xPrintHeadsPsuOK := X20DIF371_102.DInput[5];
	gInksInputs[4].xPrintHeadsPsuOK := X20DIF371_102.DInput[6];
	gInksInputs[5].xPrintHeadsPsuOK := X20DIF371_102.DInput[7];
	gInksInputs[6].xPrintHeadsPsuOK := X20DIF371_102.DInput[8];
	gInksInputs[7].xPrintHeadsPsuOK := X20DIF371_102.DInput[9];
	gInksInputs[8].xPrintHeadsPsuOK := X20DIF371_102.DInput[10];
	gInksInputs[9].xPrintHeadsPsuOK := X20DIF371_102.DInput[11];
	gInksInputs[10].xPrintHeadsPsuOK := X20DIF371_102.DInput[12];
	gMachine.In.x24Vdc := X20DIF371_102.DInput[13];
	gBelt.parameters.xDriveProtectionOK := X20DIF371_102.DInput[14];
	gBlockInputs[1].xDriveProtectionOK := gBlockInputs[1].xDifferentialOK := X20DIF371_102.DInput[15];
	FOR iIndexCuringLed:=1 TO MAX_LAST_CURING_LED DO
		gCuringLed[iIndexCuringLed].Signals.Inputs.xFrontDoorClosed := X20DIF371_102.DInput[16];
	END_FOR
	
	
	gMachine.In.ProductDetect.pPDSignalSensorL1	:= ADR(X20DIF371_103.DInput[1]);
	gMachine.In.ProductDetect.pPDSignalSensorL2	:= ADR(X20DIF371_103.DInput[2]);
	gPhotoCells.Inputs.Signals.pInput[1] := ADR(X20DIF371_103.DInput[3]);
	gPhotoCells.Inputs.Signals.pInput[2] := ADR(X20DIF371_103.DInput[4]);
	gPhotoCells.Inputs.Signals.pInput[3] := ADR(X20DIF371_103.DInput[5]);
	gPhotoCells.Inputs.Signals.pInput[4] := ADR(X20DIF371_103.DInput[6]);
	gPhotoCells.Inputs.Signals.pInput[5] := ADR(X20DIF371_103.DInput[7]);
	gPhotoCells.Inputs.Signals.pInput[6] := ADR(X20DIF371_103.DInput[8]);
	gPhotoCells.Inputs.Signals.xSafetyEnable := gMachine.In.xSafetyEnabled;
	

	gJamInputs[1].xJamCrash[1] := X20DIF371_104.DInput[1];
	gJamInputs[1].xJamCrash[2] := X20DIF371_104.DInput[2];
	gJamInputs[1].xJamCrash[3] := X20DIF371_104.DInput[3];
	gJamInputs[1].xJamCrash[4] := X20DIF371_104.DInput[4];
	gJamInputs[2].xJamCrash[1] := X20DIF371_104.DInput[5];
	gJamInputs[2].xJamCrash[2] := X20DIF371_104.DInput[6];
	gJamInputs[2].xJamCrash[3] := X20DIF371_104.DInput[7];
	gJamInputs[2].xJamCrash[4] := X20DIF371_104.DInput[8];
	gJamInputs[3].xJamCrash[1] := X20DIF371_104.DInput[9];
	gJamInputs[3].xJamCrash[2] := X20DIF371_104.DInput[10];
	
	
	gInksInputs[3].xKlixonTriggered := X20DIF371_105.DInput[1];
	gInksInputs[4].xKlixonTriggered := X20DIF371_105.DInput[2];
	gInksInputs[5].xKlixonTriggered := X20DIF371_105.DInput[3];
	gInksInputs[6].xKlixonTriggered := X20DIF371_105.DInput[4];
	gInksInputs[7].xKlixonTriggered := X20DIF371_105.DInput[5];
	gInksInputs[8].xKlixonTriggered := X20DIF371_105.DInput[6];
	gInksInputs[9].xKlixonTriggered := X20DIF371_105.DInput[7];
	gInksInputs[10].xKlixonTriggered := X20DIF371_105.DInput[8];
	
	gInksInputs[3].xOverpressure  := NOT X20DIF371_105.DInput[9];
	gInksInputs[4].xOverpressure  := NOT X20DIF371_105.DInput[10];
	gInksInputs[5].xOverpressure  := NOT X20DIF371_105.DInput[11];
	gInksInputs[6].xOverpressure  := NOT X20DIF371_105.DInput[12];
	gInksInputs[7].xOverpressure  := NOT X20DIF371_105.DInput[13];
	gInksInputs[8].xOverpressure  := NOT X20DIF371_105.DInput[14];
	gInksInputs[9].xOverpressure  := NOT X20DIF371_105.DInput[15];
	gInksInputs[10].xOverpressure  := NOT X20DIF371_105.DInput[16];
	
	gInksInputs[3].xConnected := X20DIF371_106.DInput[1];
	gInksInputs[4].xConnected := X20DIF371_106.DInput[2];
	gInksInputs[5].xConnected := X20DIF371_106.DInput[3];
	gInksInputs[6].xConnected := X20DIF371_106.DInput[4];
	gInksInputs[7].xConnected := X20DIF371_106.DInput[5];
	gInksInputs[8].xConnected := X20DIF371_106.DInput[6];
	gInksInputs[9].xConnected := X20DIF371_106.DInput[7];
	gInksInputs[10].xConnected := X20DIF371_106.DInput[8];
	
	
	//Analog inputs
	gTransVacuum[1].Inputs.iPressureRaw := X20AI8321_111.AInput[1];
	gTransVacuum[1].Inputs.xPressureSensorError := StatusAnalogInputBroken( X20AI8321_111.ModuleOk, X20AI8321_111.Status01, X20AI8321_111.Status02, 1);
	gTransVacuum[2].Inputs.iPressureRaw := X20AI8321_111.AInput[2];
	gTransVacuum[2].Inputs.xPressureSensorError := StatusAnalogInputBroken( X20AI8321_111.ModuleOk, X20AI8321_111.Status01, X20AI8321_111.Status02, 2);
	
	gInksInputs[3].iVacuum1Raw := X20AI8321_112.AInput[1];
	gInksInputs[3].xVacuum1SensorError 	:= StatusAnalogInputBroken( X20AI8321_112.ModuleOk, X20AI8321_112.Status01, X20AI8321_112.Status02, 1);
	gInksInputs[3].iVacuum2Raw := X20AI8321_112.AInput[2];
	gInksInputs[3].xVacuum2SensorError 	:= StatusAnalogInputBroken( X20AI8321_112.ModuleOk, X20AI8321_112.Status01, X20AI8321_112.Status02, 2);
	gInksInputs[4].iVacuum1Raw := X20AI8321_112.AInput[3];
	gInksInputs[4].xVacuum1SensorError 	:= StatusAnalogInputBroken( X20AI8321_112.ModuleOk, X20AI8321_112.Status01, X20AI8321_112.Status02, 3);
	gInksInputs[4].iVacuum2Raw := X20AI8321_112.AInput[4];
	gInksInputs[4].xVacuum2SensorError 	:= StatusAnalogInputBroken( X20AI8321_112.ModuleOk, X20AI8321_112.Status01, X20AI8321_112.Status02, 4);
	gInksInputs[5].iVacuum1Raw := X20AI8321_112.AInput[5];
	gInksInputs[5].xVacuum1SensorError 	:= StatusAnalogInputBroken( X20AI8321_112.ModuleOk, X20AI8321_112.Status01, X20AI8321_112.Status02, 5);
	gInksInputs[5].iVacuum2Raw := X20AI8321_112.AInput[6];
	gInksInputs[5].xVacuum2SensorError 	:= StatusAnalogInputBroken( X20AI8321_112.ModuleOk, X20AI8321_112.Status01, X20AI8321_112.Status02, 6);
	gInksInputs[6].iVacuum1Raw := X20AI8321_112.AInput[7];
	gInksInputs[6].xVacuum1SensorError 	:= StatusAnalogInputBroken( X20AI8321_112.ModuleOk, X20AI8321_112.Status01, X20AI8321_112.Status02, 7);
	gInksInputs[6].iVacuum2Raw := X20AI8321_112.AInput[8];
	gInksInputs[6].xVacuum2SensorError 	:= StatusAnalogInputBroken( X20AI8321_112.ModuleOk, X20AI8321_112.Status01, X20AI8321_112.Status02, 8);
	
	gInksInputs[7].iVacuum1Raw := X20AI8321_113.AInput[1];
	gInksInputs[7].xVacuum1SensorError 	:= StatusAnalogInputBroken( X20AI8321_113.ModuleOk, X20AI8321_113.Status01, X20AI8321_113.Status02, 1);
	gInksInputs[7].iVacuum2Raw := X20AI8321_113.AInput[2];
	gInksInputs[7].xVacuum2SensorError 	:= StatusAnalogInputBroken( X20AI8321_113.ModuleOk, X20AI8321_113.Status01, X20AI8321_113.Status02, 2);
	gInksInputs[8].iVacuum1Raw := X20AI8321_113.AInput[3];
	gInksInputs[8].xVacuum1SensorError 	:= StatusAnalogInputBroken( X20AI8321_113.ModuleOk, X20AI8321_113.Status01, X20AI8321_113.Status02, 3);
	gInksInputs[8].iVacuum2Raw := X20AI8321_113.AInput[4];
	gInksInputs[8].xVacuum2SensorError 	:= StatusAnalogInputBroken( X20AI8321_113.ModuleOk, X20AI8321_113.Status01, X20AI8321_113.Status02, 4);
	gInksInputs[9].iVacuum1Raw := X20AI8321_113.AInput[5];
	gInksInputs[9].xVacuum1SensorError 	:= StatusAnalogInputBroken( X20AI8321_113.ModuleOk, X20AI8321_113.Status01, X20AI8321_113.Status02, 5);
	gInksInputs[9].iVacuum2Raw := X20AI8321_113.AInput[6];
	gInksInputs[9].xVacuum2SensorError 	:= StatusAnalogInputBroken( X20AI8321_113.ModuleOk, X20AI8321_113.Status01, X20AI8321_113.Status02, 6);
	gInksInputs[10].iVacuum1Raw := X20AI8321_113.AInput[7];
	gInksInputs[10].xVacuum1SensorError 	:= StatusAnalogInputBroken( X20AI8321_113.ModuleOk, X20AI8321_113.Status01, X20AI8321_113.Status02, 7);
	gInksInputs[10].iVacuum2Raw := X20AI8321_113.AInput[8];
	gInksInputs[10].xVacuum2SensorError 	:= StatusAnalogInputBroken( X20AI8321_113.ModuleOk, X20AI8321_113.Status01, X20AI8321_113.Status02, 8);
	
	gInksInputs[3].iInTankLevel := X20AI8321_114.AInput[1];
	gInksInputs[3].xInkLevelTankSensorError := StatusAnalogInputBroken( X20AI8321_114.ModuleOk, X20AI8321_114.Status01, X20AI8321_114.Status02, 1);
	gInksInputs[4].iInTankLevel := X20AI8321_114.AInput[2];
	gInksInputs[4].xInkLevelTankSensorError := StatusAnalogInputBroken( X20AI8321_114.ModuleOk, X20AI8321_114.Status01, X20AI8321_114.Status02, 2);
	gInksInputs[5].iInTankLevel := X20AI8321_114.AInput[3];
	gInksInputs[5].xInkLevelTankSensorError := StatusAnalogInputBroken( X20AI8321_114.ModuleOk, X20AI8321_114.Status01, X20AI8321_114.Status02, 3);
	gInksInputs[6].iInTankLevel := X20AI8321_114.AInput[4];
	gInksInputs[6].xInkLevelTankSensorError := StatusAnalogInputBroken( X20AI8321_114.ModuleOk, X20AI8321_114.Status01, X20AI8321_114.Status02, 4);
	gInksInputs[7].iInTankLevel := X20AI8321_114.AInput[5];
	gInksInputs[7].xInkLevelTankSensorError := StatusAnalogInputBroken( X20AI8321_114.ModuleOk, X20AI8321_114.Status01, X20AI8321_114.Status02, 5);
	gInksInputs[8].iInTankLevel := X20AI8321_114.AInput[6];
	gInksInputs[8].xInkLevelTankSensorError := StatusAnalogInputBroken( X20AI8321_114.ModuleOk, X20AI8321_114.Status01, X20AI8321_114.Status02, 6);
	gInksInputs[9].iInTankLevel := X20AI8321_114.AInput[7];
	gInksInputs[9].xInkLevelTankSensorError := StatusAnalogInputBroken( X20AI8321_114.ModuleOk, X20AI8321_114.Status01, X20AI8321_114.Status02, 7);
	gInksInputs[10].iInTankLevel := X20AI8321_114.AInput[8];
	gInksInputs[10].xInkLevelTankSensorError := StatusAnalogInputBroken( X20AI8321_114.ModuleOk, X20AI8321_114.Status01, X20AI8321_114.Status02, 8);
	
 

	//PT100
	gBlockInputs[1].xModuleTemp01Ok	:= X20AT4222_120.ModuleOk;
	gInksInputs[3].iTemperatureRaw := X20AT4222_120.TempInput[1];
	gInksInputs[3].xTempSensorError	:= StatusTemperatureInput(X20AT4222_120.Status01, 1);
	gInksInputs[4].iTemperatureRaw := X20AT4222_120.TempInput[2];
	gInksInputs[4].xTempSensorError	:= StatusTemperatureInput(X20AT4222_120.Status01, 2);
	gInksInputs[5].iTemperatureRaw := X20AT4222_120.TempInput[3];
	gInksInputs[5].xTempSensorError	:= StatusTemperatureInput(X20AT4222_120.Status01, 3);
	gInksInputs[6].iTemperatureRaw := X20AT4222_120.TempInput[4];
	gInksInputs[6].xTempSensorError	:= StatusTemperatureInput(X20AT4222_120.Status01, 4);
	
	gBlockInputs[1].xModuleTemp02Ok	:= X20AT4222_121.ModuleOk;
	gInksInputs[7].iTemperatureRaw := X20AT4222_121.TempInput[1];
	gInksInputs[7].xTempSensorError	:= StatusTemperatureInput(X20AT4222_121.Status01, 1);
	gInksInputs[8].iTemperatureRaw := X20AT4222_121.TempInput[2];
	gInksInputs[8].xTempSensorError	:= StatusTemperatureInput(X20AT4222_121.Status01, 2);
	gInksInputs[9].iTemperatureRaw := X20AT4222_121.TempInput[3];
	gInksInputs[9].xTempSensorError	:= StatusTemperatureInput(X20AT4222_121.Status01, 3);
	gInksInputs[10].iTemperatureRaw := X20AT4222_121.TempInput[4];
	gInksInputs[10].xTempSensorError	:= StatusTemperatureInput(X20AT4222_121.Status01, 4);

	
	// SI UNIT BK1	
	gBlockInputs[1].xSiUnitModuleOk		:= SiUnitPwrLnkBK1.ModuleOk;
	gMachine.In.xAirSupply				:= SiUnitPwrLnkBK1.Input01_16.0;
	gBlockInputs[1].xAirVenturiOK		:= SiUnitPwrLnkBK1.Input01_16.1;
	gBlockInputs[1].xTrayOut			:= SiUnitPwrLnkBK1.Input01_16.2;
	gBlockInputs[1].xIclaSensor			:= SiUnitPwrLnkBK1.Input01_16.3;
	gTransVacuum[1].Inputs.xVaccAirFlow	:= gTransVacuum[2].Inputs.xVaccAirFlow := SiUnitPwrLnkBK1.Input01_16.4; //No estamos haciendo nada con esto en el package de TransVacuum!
	gTransVacuum[1].Inputs.xJointSystemPressure:= gTransVacuum[2].Inputs.xJointSystemPressure := SiUnitPwrLnkBK1.Input01_16.5;
	gMachine.In.CleanBelt.xLowPosition 	:= SiUnitPwrLnkBK1.Input01_16.6;
	gMachine.In.CleanBelt.xHighPosition := SiUnitPwrLnkBK1.Input01_16.7;
	gBlockInputs[1].xBarsIn := TRUE;
	gTransVacuum[1].Inputs.xSafetyEnable := gTransVacuum[2].Inputs.xSafetyEnable := gMachine.In.xSafetyEnabled;
	
	//Signals Forced by Configuration
	gBlockInputs[1].Safety.xFrontEStopOK := gSafetyController.Inputs.xPrinterFrontsideEstop;
	gBlockInputs[1].Safety.xRearEStopOK := gSafetyController.Inputs.xPrinterBacksideEstop;
	
	gBlockInputs[1].Safety.xFrontSafetyOK	:= gSafetyController.Inputs.xPrinterFrontsideEstop AND gSafetyController.Inputs.xPrinterLightCurtain;
	gBlockInputs[1].Safety.xRearSafetyOK	:= gSafetyController.Inputs.xPrinterBacksideEstop AND gSafetyController.Inputs.xPrinterDoorLock;
	gBlockInputs[1].Safety.xSafetyOK 		:= gMachine.In.xSafetyEnabled;
	
	//There are no specific enables for light curtains. So we mapp PrinterLightCurtain status to these inputs to acknowledge that curtain is crossed
	gBlockInputs[1].Safety.xCurtainEnable01 := gBlockInputs[1].Safety.xCurtainEnable02 := gSafetyController.Inputs.xPrinterLightCurtain;
	
	//Signals Forced by Configuration
	FOR iIndexVac := 1 TO MAX_LAST_TRANS_VACUUM DO gTransVacuum[iIndexVac].Inputs.xBlowersAnyCB := FALSE; END_FOR
	
	
	///////////////////////////
	//UV Curing leds related
	
	//Digital inputs
	gCuringLed[iIndexColorCuringLedBar].Lamp[1].Inputs.ThermalFault	:= NOT X20DIF371_151.DInput[1];
	gCuringLed[iIndexColorCuringLedBar].Lamp[1].Inputs.SLMFault		:= NOT X20DIF371_151.DInput[2];
	gCuringLed[iIndexColorCuringLedBar].Lamp[2].Inputs.ThermalFault	:= NOT X20DIF371_151.DInput[3];
	gCuringLed[iIndexColorCuringLedBar].Lamp[2].Inputs.SLMFault		:= NOT X20DIF371_151.DInput[4];
	gCuringLed[iIndexColorCuringLedBar].Lamp[3].Inputs.ThermalFault	:= NOT X20DIF371_151.DInput[5];
	gCuringLed[iIndexColorCuringLedBar].Lamp[3].Inputs.SLMFault		:= NOT X20DIF371_151.DInput[6];
	gCuringLed[iIndexColorCuringLedBar].Lamp[4].Inputs.ThermalFault	:= NOT X20DIF371_151.DInput[7];
	gCuringLed[iIndexColorCuringLedBar].Lamp[4].Inputs.SLMFault		:= NOT X20DIF371_151.DInput[8];
	gCuringLed[iIndexColorCuringLedBar].Lamp[5].Inputs.ThermalFault	:= NOT X20DIF371_151.DInput[9];
	gCuringLed[iIndexColorCuringLedBar].Lamp[5].Inputs.SLMFault		:= NOT X20DIF371_151.DInput[10];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xN2HighFlow	:= NOT X20DIF371_151.DInput[13];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xN2LowFlow	:= NOT X20DIF371_151.DInput[14];

	gCuringLed[iIndexWhiteCuringLedBar].Lamp[1].Inputs.ThermalFault	:= NOT X20DIF371_152.DInput[1];
	gCuringLed[iIndexWhiteCuringLedBar].Lamp[1].Inputs.SLMFault		:= NOT X20DIF371_152.DInput[2];
	gCuringLed[iIndexWhiteCuringLedBar].Lamp[2].Inputs.ThermalFault	:= NOT X20DIF371_152.DInput[3];
	gCuringLed[iIndexWhiteCuringLedBar].Lamp[2].Inputs.SLMFault		:= NOT X20DIF371_152.DInput[4];
	gCuringLed[iIndexWhiteCuringLedBar].Lamp[3].Inputs.ThermalFault	:= NOT X20DIF371_152.DInput[5];
	gCuringLed[iIndexWhiteCuringLedBar].Lamp[3].Inputs.SLMFault		:= NOT X20DIF371_152.DInput[6];
	gCuringLed[iIndexWhiteCuringLedBar].Lamp[4].Inputs.ThermalFault	:= NOT X20DIF371_152.DInput[7];
	gCuringLed[iIndexWhiteCuringLedBar].Lamp[4].Inputs.SLMFault		:= NOT X20DIF371_152.DInput[8];
	gCuringLed[iIndexWhiteCuringLedBar].Lamp[5].Inputs.ThermalFault	:= NOT X20DIF371_152.DInput[9];
	gCuringLed[iIndexWhiteCuringLedBar].Lamp[5].Inputs.SLMFault		:= NOT X20DIF371_152.DInput[10];
	gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xN2HighFlow	:= NOT X20DIF371_152.DInput[13];
	gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xN2LowFlow	:= NOT X20DIF371_152.DInput[14];
	
	gCuringLed[iIndexPrimerCuringLedBar].Lamp[1].Inputs.ThermalFault	:= NOT X20DIF371_153.DInput[1];
	gCuringLed[iIndexPrimerCuringLedBar].Lamp[1].Inputs.SLMFault		:= NOT X20DIF371_153.DInput[2];
	gCuringLed[iIndexPrimerCuringLedBar].Lamp[2].Inputs.ThermalFault	:= NOT X20DIF371_153.DInput[3];
	gCuringLed[iIndexPrimerCuringLedBar].Lamp[2].Inputs.SLMFault		:= NOT X20DIF371_153.DInput[4];
	gCuringLed[iIndexPrimerCuringLedBar].Lamp[3].Inputs.ThermalFault	:= NOT X20DIF371_153.DInput[5];
	gCuringLed[iIndexPrimerCuringLedBar].Lamp[3].Inputs.SLMFault		:= NOT X20DIF371_153.DInput[6];
	gCuringLed[iIndexPrimerCuringLedBar].Lamp[4].Inputs.ThermalFault	:= NOT X20DIF371_153.DInput[7];
	gCuringLed[iIndexPrimerCuringLedBar].Lamp[4].Inputs.SLMFault		:= NOT X20DIF371_153.DInput[8];
	gCuringLed[iIndexPrimerCuringLedBar].Lamp[5].Inputs.ThermalFault	:= NOT X20DIF371_153.DInput[9];
	gCuringLed[iIndexPrimerCuringLedBar].Lamp[5].Inputs.SLMFault		:= NOT X20DIF371_153.DInput[10];
	gCuringLed[iIndexPrimerCuringLedBar].Signals.Inputs.xN2HighFlow		:= NOT X20DIF371_153.DInput[13];
	gCuringLed[iIndexPrimerCuringLedBar].Signals.Inputs.xN2LowFlow		:= NOT X20DIF371_153.DInput[14];
	
	gMachine.In.CleanBelt.xError 						:= X20DIF371_154.DInput[1];
	gMachine.In.CleanBelt.xOpenGuide 					:= X20DIF371_154.DInput[2];
	gMachine.In.AntiStatic.xGenAlarm 					:= X20DIF371_154.DInput[3];
	gMachine.In.AntiStatic.xIonLevelAlarm				:= X20DIF371_154.DInput[4];
	
	
	
	//////////
	//PDC
	//////////
	//Line X20DIF371_002
	//These inputs are read in MachineConfigurator>InputsMachineModel
	//	:= Pdc_X20DIF371_002.DInput[1];
	//	:= Pdc_X20DIF371_002.DInput[2];
	//	:= Pdc_X20DIF371_002.DInput[3];
	//	:= Pdc_X20DIF371_002.DInput[4];
	//	:= Pdc_X20DIF371_002.DInput[5];
	//	:= Pdc_X20DIF371_002.DInput[6];
	gFeeder.Inputs.xNoPowered 					:= NOT Pdc_X20DIF371_002.DInput[7];
	gSarm.Inputs.xPowered						:= Pdc_X20DIF371_002.DInput[8];
	gPrimer.Inputs.xNoPowered 					:= NOT Pdc_X20DIF371_002.DInput[9];
	gLine.Inputs.xPrinterPowered				:= Pdc_X20DIF371_002.DInput[10];
	gOverVarnish.Inputs.xNoPowered  			:= NOT Pdc_X20DIF371_002.DInput[11];
	gStacker.Inputs.xNoPowered 					:= NOT Pdc_X20DIF371_002.DInput[12];
	gLine.Inputs.xOvervoltageProtectionOk 		:= NOT Pdc_X20DIF371_002.DInput[13]; //Inverse logic
	gMachine.In.xSafetyEnabled 					:= Pdc_X20DIF371_002.DInput[14];
	
	//Line X20DIF371_003
	gAxisInverter[1].ElecSignals.In.xBreakerOK 	:= Pdc_X20DIF371_003.DInput[1];
	gAxisInverter[2].ElecSignals.In.xBreakerOK 	:= Pdc_X20DIF371_003.DInput[2];
	gAxisInverter[3].ElecSignals.In.xBreakerOK 	:= Pdc_X20DIF371_003.DInput[3];
	gAxisInverter[4].ElecSignals.In.xBreakerOK 	:= Pdc_X20DIF371_003.DInput[4];
	gMachine.In.xHoppersSoftStarterFault	:= Pdc_X20DIF371_003.DInput[5];
	gLine.Inputs.UPSs[1].LoadOnUtility		:= Pdc_X20DIF371_003.DInput[6];
	gLine.Inputs.UPSs[1].LoadOnBattery 		:= gLine.Inputs.UPSs[1].xPowerFault := Pdc_X20DIF371_003.DInput[7];
	gLine.Inputs.UPSs[1].xLowBattery 		:= Pdc_X20DIF371_003.DInput[8];
	gLine.Inputs.UPSs[1].xByPass			:= Pdc_X20DIF371_003.DInput[9];
	gLine.Inputs.x24VdcStartSeqNoPowered	:= NOT Pdc_X20DIF371_003.DInput[10];	

	
	//Line X20DIF371_004
	gFeeder.Inputs.xModelInput[0] 		:= Pdc_X20DIF371_004.DInput[1];
	gFeeder.Inputs.xModelInput[1] 		:= Pdc_X20DIF371_004.DInput[2];
	gFeeder.Inputs.xModelInput[2] 		:= Pdc_X20DIF371_004.DInput[3];
	gFeeder.Inputs.xOnline 				:= Pdc_X20DIF371_004.DInput[4];
	gFeeder.Inputs.xError 				:= Pdc_X20DIF371_004.DInput[5];
	gFeeder.Inputs.xFeeding 			:= Pdc_X20DIF371_004.DInput[6];
	gFeeder.Inputs.xMultiPick 			:= Pdc_X20DIF371_004.DInput[7];
	gFeeder.Inputs.xTrayEmpty 			:= Pdc_X20DIF371_004.DInput[8];
	gFeeder.Inputs.xMediaLowL1 			:= Pdc_X20DIF371_004.DInput[9];
	gFeeder.Inputs.xMediaThickness 		:= Pdc_X20DIF371_004.DInput[10];
	gFeeder.Inputs.xReadyToFeed 		:= Pdc_X20DIF371_004.DInput[11];
	gSarm.Inputs.xModelInput[0] 		:= Pdc_X20DIF371_050.DInput[12];
	gSarm.Inputs.xModelInput[1] 		:= Pdc_X20DIF371_050.DInput[13];
	gSarm.Inputs.xModelInput[2] 		:= Pdc_X20DIF371_050.DInput[14];
	gSarm.Inputs.xError 				:= Pdc_X20DIF371_050.DInput[15];
	gSarm.Inputs.xRunning 				:= Pdc_X20DIF371_050.DInput[16];
	
	
	//Line X20DIF371_005
	gPrimer.Inputs.xModelInput[0] 		:= Pdc_X20DIF371_005.DInput[1];
	gPrimer.Inputs.xModelInput[1] 		:= Pdc_X20DIF371_005.DInput[2];
	gPrimer.Inputs.xModelInput[2] 		:= Pdc_X20DIF371_005.DInput[3];
	gPrimer.Inputs.xReadyToPrime 		:= Pdc_X20DIF371_004.DInput[4];
	gPrimer.Inputs.xCoating 			:= Pdc_X20DIF371_004.DInput[5];
	gPrimer.Inputs.xError 				:= Pdc_X20DIF371_004.DInput[6];
	gPrimer.Inputs.xDryerInRun 			:= Pdc_X20DIF371_005.DInput[7];
	gPrimer.Inputs.xTransportMoving 	:= Pdc_X20DIF371_005.DInput[8];
	gOverVarnish.Inputs.xModelInput[0] 	:= Pdc_X20DIF371_005.DInput[9];
	gOverVarnish.Inputs.xModelInput[1] 	:= Pdc_X20DIF371_005.DInput[10];
	gOverVarnish.Inputs.xModelInput[2] 	:= Pdc_X20DIF371_005.DInput[11];
	gOverVarnish.Inputs.xReadyToPrime 	:= Pdc_X20DIF371_005.DInput[12];
	gOverVarnish.Inputs.xCoating 		:= Pdc_X20DIF371_005.DInput[13];
	gOverVarnish.Inputs.xError 			:= Pdc_X20DIF371_005.DInput[14];
	gOverVarnish.Inputs.xDryerInRun 	:= Pdc_X20DIF371_005.DInput[15];
	gOverVarnish.Inputs.xTransportMoving := Pdc_X20DIF371_005.DInput[16];

	
	//Line X20DIF371_006
	gStacker.Inputs.xModelInput[0] 		:= Pdc_X20DIF371_006.DInput[1];
	gStacker.Inputs.xModelInput[1] 		:= Pdc_X20DIF371_006.DInput[2];
	gStacker.Inputs.xModelInput[2] 		:= Pdc_X20DIF371_006.DInput[3];
	gStacker.Inputs.xError 				:= Pdc_X20DIF371_006.DInput[4];
	gStacker.Inputs.xReadyToStack 		:= Pdc_X20DIF371_006.DInput[5];
	gStacker.Inputs.xFeedInterrupt 		:= Pdc_X20DIF371_006.DInput[6];
	gStacker.Inputs.xRunning 			:= Pdc_X20DIF371_006.DInput[7];
	gStacker.Inputs.xRejectSuccess 		:= Pdc_X20DIF371_006.DInput[8]; //En la excel de señales lo tienen al revés (aparece stacksucces), pero es porque creo que lo tienen mal en el cableado, así está bien.
	gStacker.Inputs.xStackSuccess 		:= Pdc_X20DIF371_006.DInput[9]; //En la excel de señales lo tienen al revés (aparece rejectsucces), pero es porque creo que lo tienen mal en el cableado, así está bien.

	
	
	//Line X20DIF371_020
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuDcOk[1] := Pdc_X20DIF371_021.DInput[1];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuDcOk[2] := Pdc_X20DIF371_021.DInput[2];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuDcOk[3] := Pdc_X20DIF371_021.DInput[3];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuDcOk[4] := Pdc_X20DIF371_021.DInput[4];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuDcOk[5] := Pdc_X20DIF371_021.DInput[5];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuDcOk[6] := Pdc_X20DIF371_021.DInput[6];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuDcOk[7] := Pdc_X20DIF371_021.DInput[7];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuAcOk[1] := Pdc_X20DIF371_021.DInput[8];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuAcOk[2] := Pdc_X20DIF371_021.DInput[9];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuAcOk[3] := Pdc_X20DIF371_021.DInput[10];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuAcOk[4] := Pdc_X20DIF371_021.DInput[11];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuAcOk[5] := Pdc_X20DIF371_021.DInput[12];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuAcOk[6] := Pdc_X20DIF371_021.DInput[13];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuAcOk[7] := Pdc_X20DIF371_021.DInput[14];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xSafetyEnable := gMachine.In.xSafetyEnabled;
	
	
	//Line X20DIF371_021
	gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xPsuDcOk[1] := Pdc_X20DIF371_022.DInput[1];
	gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xPsuDcOk[2] := Pdc_X20DIF371_022.DInput[2];
	gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xPsuDcOk[3] := Pdc_X20DIF371_022.DInput[3];
	gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xPsuDcOk[4] := Pdc_X20DIF371_022.DInput[4];
	gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xPsuDcOk[5] := Pdc_X20DIF371_022.DInput[5];
	gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xPsuDcOk[6] := Pdc_X20DIF371_022.DInput[6];
	gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xPsuDcOk[7] := Pdc_X20DIF371_022.DInput[7];
	gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xPsuAcOk[1] := Pdc_X20DIF371_022.DInput[8];
	gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xPsuAcOk[2] := Pdc_X20DIF371_022.DInput[9];
	gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xPsuAcOk[3] := Pdc_X20DIF371_022.DInput[10];
	gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xPsuAcOk[4] := Pdc_X20DIF371_022.DInput[11];
	gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xPsuAcOk[5] := Pdc_X20DIF371_022.DInput[12];
	gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xPsuAcOk[6] := Pdc_X20DIF371_022.DInput[13];
	gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xPsuAcOk[7] := Pdc_X20DIF371_022.DInput[14];
	gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xSafetyEnable := gMachine.In.xSafetyEnabled;
	
	//Line X20DIF371_023
	gCuringLed[iIndexPrimerCuringLedBar].Signals.Inputs.xPsuDcOk[1] := Pdc_X20DIF371_023.DInput[1];
	gCuringLed[iIndexPrimerCuringLedBar].Signals.Inputs.xPsuDcOk[2] := Pdc_X20DIF371_023.DInput[2];
	gCuringLed[iIndexPrimerCuringLedBar].Signals.Inputs.xPsuDcOk[3] := Pdc_X20DIF371_023.DInput[3];
	gCuringLed[iIndexPrimerCuringLedBar].Signals.Inputs.xPsuDcOk[4] := Pdc_X20DIF371_023.DInput[4];
	gCuringLed[iIndexPrimerCuringLedBar].Signals.Inputs.xPsuDcOk[5] := Pdc_X20DIF371_023.DInput[5];
	gCuringLed[iIndexPrimerCuringLedBar].Signals.Inputs.xPsuDcOk[6] := Pdc_X20DIF371_023.DInput[6];
	gCuringLed[iIndexPrimerCuringLedBar].Signals.Inputs.xPsuDcOk[7] := Pdc_X20DIF371_023.DInput[7];
	gCuringLed[iIndexPrimerCuringLedBar].Signals.Inputs.xPsuAcOk[1] := Pdc_X20DIF371_023.DInput[8];
	gCuringLed[iIndexPrimerCuringLedBar].Signals.Inputs.xPsuAcOk[2] := Pdc_X20DIF371_023.DInput[9];
	gCuringLed[iIndexPrimerCuringLedBar].Signals.Inputs.xPsuAcOk[3] := Pdc_X20DIF371_023.DInput[10];
	gCuringLed[iIndexPrimerCuringLedBar].Signals.Inputs.xPsuAcOk[4] := Pdc_X20DIF371_023.DInput[11];
	gCuringLed[iIndexPrimerCuringLedBar].Signals.Inputs.xPsuAcOk[5] := Pdc_X20DIF371_023.DInput[12];
	gCuringLed[iIndexPrimerCuringLedBar].Signals.Inputs.xPsuAcOk[6] := Pdc_X20DIF371_023.DInput[13];
	gCuringLed[iIndexPrimerCuringLedBar].Signals.Inputs.xPsuAcOk[7] := Pdc_X20DIF371_023.DInput[14];
	gCuringLed[iIndexPrimerCuringLedBar].Signals.Inputs.xSafetyEnable := gMachine.In.xSafetyEnabled;
	
	//Pdc_X20DIF371_023
	gChiller[gCuringLed[iIndexColorCuringLedBar].Parameters.iChillerIndex].In.xAlarm := Pdc_X20DIF371_024.DInput[1];
	gChiller[iIndexColorCuringLedBar].In.xCooling := Pdc_X20DIF371_024.DInput[2];
	gChiller[gCuringLed[iIndexWhiteCuringLedBar].Parameters.iChillerIndex].In.xAlarm := gChiller[gCuringLed[iIndexPrimerCuringLedBar].Parameters.iChillerIndex].In.xAlarm := Pdc_X20DIF371_024.DInput[3];
	gChiller[iIndexWhiteCuringLedBar].In.xCooling := gChiller[iIndexPrimerCuringLedBar].In.xCooling := Pdc_X20DIF371_024.DInput[4];
	
	//Signals Forced by Configuration
	FOR iIndexBlock := 1 TO gMachine.Pt.CT.iNumBlocks DO
		gBlockInputs[iIndexBlock].xHeaterDcOkBusBar1 := TRUE;
		gBlockInputs[iIndexBlock].xHeaterDcOkBusBar2 := TRUE;
		gBlock[iIndexBlock].parameters.Hw.iNumPrintheadsPSU := 3;
		gBlock[iIndexBlock].parameters.Hw.iNumHeaterPSU := 1;
	END_FOR
	
	//To review with electrical team how to get these signals from chiller
	gChiller[1].In.xPowered	:= TRUE;
	gChiller[2].In.xPowered	:= TRUE;
	
END_ACTION
