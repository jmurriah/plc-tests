
ACTION InputsNozomi2:
	
	
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

	gMachine.In.ProductDetect.pPDCarriageSignalL1 := ADR(X20DIF371_101.DInput[7]);
	gMachine.In.ProductDetect.pPDCarriageSignalL2 := ADR(X20DIF371_101.DInput[8]);
	gMachine.In.ProductDetect.pPDCarriage2SignalL1 := ADR(X20DIF371_101.DInput[9]);
	gMachine.In.ProductDetect.pPDCarriage2SignalL2 := ADR(X20DIF371_101.DInput[10]);
 
	//Jam device N3
	gJamInputs[3].xJamLowCrash := X20DIF371_101.DInput[11];
	gJamInputs[3].xJamTestOk := X20DIF371_101.DInput[12];
	gJamInputs[3].xJamCrash[1] := X20DIF371_101.DInput[13];
	
  
	gInksInputs[1].xPrintHeadsPsuOK := X20DIF371_102.DInput[1];
	gInksInputs[2].xPrintHeadsPsuOK := X20DIF371_102.DInput[2];
	gInksInputs[3].xPrintHeadsPsuOK := X20DIF371_102.DInput[3];
	gInksInputs[4].xPrintHeadsPsuOK := X20DIF371_102.DInput[4];
	gInksInputs[5].xPrintHeadsPsuOK := X20DIF371_102.DInput[5];
	gInksInputs[6].xPrintHeadsPsuOK := X20DIF371_102.DInput[6];
	gInksInputs[7].xPrintHeadsPsuOK := X20DIF371_102.DInput[7];
	gInksInputs[8].xPrintHeadsPsuOK := X20DIF371_102.DInput[8];
	//SPARE := NOT X20DIF371_102.DInput[9];
	gBelt.parameters.xDriveProtectionOK := X20DIF371_102.DInput[10];
	gBlockInputs[1].xDriveProtectionOK := gBlockInputs[1].xDifferentialOK := X20DIF371_102.DInput[11];
	//Non-crash - CB contact alarm := X20DIF371_102.DInput[12];
	gMachine.In.x24Vdc := X20DIF371_102.DInput[13];
	gBlockInputs[1].xReferenceDI := X20DIF371_102.DInput[14];
	//Back Safety Key unlock - PRINTER := X20DIF371_102.DInput[15];
	gMachine.In.xCameraDefectDetected := X20DIF371_102.DInput[16];
 
	IF NOT gMachine.St.HwData.xUpsOutOfPrinter THEN
		gMachine.In.UPSs[1].LoadOnUtility	:= X20DIF371_103.DInput[1];
		gMachine.In.UPSs[1].LoadOnBattery 	:= gMachine.In.UPSs[1].xPowerFault := X20DIF371_103.DInput[2]; //To review why name of signal is different for S1400 than Nz2. Signal coming from ups has same behaviour
		gMachine.In.UPSs[1].xLowBattery 	:= X20DIF371_103.DInput[3];
		gMachine.In.UPSs[1].xByPass 		:= X20DIF371_103.DInput[4];
		gMachine.In.UPSs[2].LoadOnUtility	:= X20DIF371_103.DInput[5];
		gMachine.In.UPSs[2].LoadOnBattery 	:= gMachine.In.UPSs[2].xPowerFault := X20DIF371_103.DInput[6]; //To review why name of signal is different for S1400 than Nz2. Signal coming from ups has same behaviour
		gMachine.In.UPSs[2].xLowBattery 	:= X20DIF371_103.DInput[7];
		gMachine.In.UPSs[2].xByPass 		:= X20DIF371_103.DInput[8];
	END_IF
	
	gMachine.In.ProductDetect.pPDSignalSensorL1	:= ADR(X20DIF371_103.DInput[9]);
	gMachine.In.ProductDetect.pPDSignalSensorL2	:= ADR(X20DIF371_103.DInput[10]);
//	gPhotoCells.Inputs.Signals.xPhotoCells[1] := NOT X20DIF371_103.DInput[11]; //Signal moved to FastInputs program
//	gPhotoCells.Inputs.Signals.xPhotoCells[2] := NOT X20DIF371_103.DInput[12]; //Signal moved to FastInputs program
//	gPhotoCells.Inputs.Signals.xPhotoCells[3] := NOT X20DIF371_103.DInput[13]; //Signal moved to FastInputs program
//	gPhotoCells.Inputs.Signals.xPhotoCells[4] := NOT X20DIF371_103.DInput[14]; //Signal moved to FastInputs program
//	gPhotoCells.Inputs.Signals.xPhotoCells[5] := NOT X20DIF371_103.DInput[15]; //Signal moved to FastInputs program
//	gPhotoCells.Inputs.Signals.xPhotoCells[6] := NOT X20DIF371_103.DInput[16]; //Signal moved to FastInputs program
	
	gInksInputs[1].xKlixonTriggered := X20DIF371_104.DInput[1];
	gInksInputs[2].xKlixonTriggered := X20DIF371_104.DInput[2];
	gInksInputs[3].xKlixonTriggered := X20DIF371_104.DInput[3];
	gInksInputs[4].xKlixonTriggered := X20DIF371_104.DInput[4];
	gInksInputs[5].xKlixonTriggered := X20DIF371_104.DInput[5];
	gInksInputs[6].xKlixonTriggered := X20DIF371_104.DInput[6];
	gInksInputs[7].xKlixonTriggered := X20DIF371_104.DInput[7];
	gInksInputs[8].xKlixonTriggered := X20DIF371_104.DInput[8];
	gJamInputs[1].xJamCrash[1] := X20DIF371_104.DInput[9];
	gJamInputs[1].xJamCrash[2] := X20DIF371_104.DInput[10];
	gJamInputs[1].xJamCrash[3] := X20DIF371_104.DInput[11];
	gJamInputs[1].xJamCrash[4] := X20DIF371_104.DInput[12];
	gJamInputs[2].xJamCrash[1] := X20DIF371_104.DInput[13];
	gJamInputs[2].xJamCrash[2] := X20DIF371_104.DInput[14];
	gJamInputs[2].xJamCrash[3] := X20DIF371_104.DInput[15];
	gJamInputs[2].xJamCrash[4] := X20DIF371_104.DInput[16];
	
	gInksInputs[1].xOverpressure  := NOT X20DIF371_105.DInput[1];
	gInksInputs[2].xOverpressure  := NOT X20DIF371_105.DInput[2];
	gInksInputs[3].xOverpressure  := NOT X20DIF371_105.DInput[3];
	gInksInputs[4].xOverpressure  := NOT X20DIF371_105.DInput[4];
	gInksInputs[5].xOverpressure  := NOT X20DIF371_105.DInput[5];
	gInksInputs[6].xOverpressure  := NOT X20DIF371_105.DInput[6];
	gInksInputs[7].xOverpressure  := NOT X20DIF371_105.DInput[7];
	gInksInputs[8].xOverpressure  := NOT X20DIF371_105.DInput[8];
	//Spare := X20DIF371_105.DInput[9];
	//Spare := X20DIF371_105.DInput[10];
	gMachine.In.xDegasserPressure := X20DIF371_105.DInput[11];
	gJamInputs[1].xJamLowCrash := X20DIF371_105.DInput[12];
	gJamInputs[2].xJamLowCrash := X20DIF371_105.DInput[13];
	gJamInputs[1].xJamTestOk := X20DIF371_105.DInput[14];
	gJamInputs[2].xJamTestOk := X20DIF371_105.DInput[15];
	FOR iIndexCuringLed:=1 TO MAX_LAST_CURING_LED DO
		gCuringLed[iIndexCuringLed].Signals.Inputs.xFrontDoorClosed := X20DIF371_105.DInput[16];
	END_FOR
	gBlockInputs[1].xFrontDoorClosed := X20DIF371_105.DInput[16];
	
	gBlockInputs[1].xPrintHeadPSU[1] := X20DI9372_107.DInput[1];
	gBlockInputs[1].xPrintHeadPSU[2] := X20DI9372_107.DInput[2];
	gBlockInputs[1].xPrintHeadPSU[3] := X20DI9372_107.DInput[3];
	gBlockInputs[1].xPrintHeadPSU[4] := X20DI9372_107.DInput[4];
	gBlockInputs[1].xPrintHeadPSU[5] := X20DI9372_107.DInput[5];
	gBlockInputs[1].xPrintHeadPSU[6] := X20DI9372_107.DInput[6];
	gBlockInputs[1].xHeaterDcOkBusBar1 := X20DI9372_107.DInput[7];
	gBlockInputs[1].xHeaterDcOkBusBar2 := X20DI9372_107.DInput[8];
	gMachine.In.xWasteInkTankMaxLevelReached := X20DI9372_107.DInput[9];
	
	
	//Analog inputs
	gInksInputs[1].iVacuum1Raw := X20AI8321_111.AInput[1];
	gInksInputs[1].xVacuum1SensorError 	:= StatusAnalogInputBroken( X20AI8321_111.ModuleOk, X20AI8321_111.Status01, X20AI8321_111.Status02, 1);
	gInksInputs[1].iVacuum2Raw := X20AI8321_111.AInput[2];
	gInksInputs[1].xVacuum2SensorError 	:= StatusAnalogInputBroken( X20AI8321_111.ModuleOk, X20AI8321_111.Status01, X20AI8321_111.Status02, 2);
	gInksInputs[2].iVacuum1Raw := X20AI8321_111.AInput[3];
	gInksInputs[2].xVacuum1SensorError 	:= StatusAnalogInputBroken( X20AI8321_111.ModuleOk, X20AI8321_111.Status01, X20AI8321_111.Status02, 3);
	gInksInputs[2].iVacuum2Raw := X20AI8321_111.AInput[4];
	gInksInputs[2].xVacuum2SensorError 	:= StatusAnalogInputBroken( X20AI8321_111.ModuleOk, X20AI8321_111.Status01, X20AI8321_111.Status02, 4);
	gInksInputs[3].iVacuum1Raw := X20AI8321_111.AInput[5];
	gInksInputs[3].xVacuum1SensorError 	:= StatusAnalogInputBroken( X20AI8321_111.ModuleOk, X20AI8321_111.Status01, X20AI8321_111.Status02, 5);
	gInksInputs[3].iVacuum2Raw := X20AI8321_111.AInput[6];
	gInksInputs[3].xVacuum2SensorError 	:= StatusAnalogInputBroken( X20AI8321_111.ModuleOk, X20AI8321_111.Status01, X20AI8321_111.Status02, 6);
	gInksInputs[4].iVacuum1Raw := X20AI8321_111.AInput[7];
	gInksInputs[4].xVacuum1SensorError 	:= StatusAnalogInputBroken( X20AI8321_111.ModuleOk, X20AI8321_111.Status01, X20AI8321_111.Status02, 7);
	gInksInputs[4].iVacuum2Raw := X20AI8321_111.AInput[8];
	gInksInputs[4].xVacuum2SensorError 	:= StatusAnalogInputBroken( X20AI8321_111.ModuleOk, X20AI8321_111.Status01, X20AI8321_111.Status02, 8);
	
	gInksInputs[5].iVacuum1Raw := X20AI8321_112.AInput[1];
	gInksInputs[5].xVacuum1SensorError 	:= StatusAnalogInputBroken( X20AI8321_112.ModuleOk, X20AI8321_112.Status01, X20AI8321_112.Status02, 1);
	gInksInputs[5].iVacuum2Raw := X20AI8321_112.AInput[2];
	gInksInputs[5].xVacuum2SensorError 	:= StatusAnalogInputBroken( X20AI8321_112.ModuleOk, X20AI8321_112.Status01, X20AI8321_112.Status02, 2);
	gInksInputs[6].iVacuum1Raw := X20AI8321_112.AInput[3];
	gInksInputs[6].xVacuum1SensorError 	:= StatusAnalogInputBroken( X20AI8321_112.ModuleOk, X20AI8321_112.Status01, X20AI8321_112.Status02, 3);
	gInksInputs[6].iVacuum2Raw := X20AI8321_112.AInput[4];
	gInksInputs[6].xVacuum2SensorError 	:= StatusAnalogInputBroken( X20AI8321_112.ModuleOk, X20AI8321_112.Status01, X20AI8321_112.Status02, 4);
	gInksInputs[7].iVacuum1Raw := X20AI8321_112.AInput[5];
	gInksInputs[7].xVacuum1SensorError 	:= StatusAnalogInputBroken( X20AI8321_112.ModuleOk, X20AI8321_112.Status01, X20AI8321_112.Status02, 5);
	gInksInputs[7].iVacuum2Raw := X20AI8321_112.AInput[6];
	gInksInputs[7].xVacuum2SensorError 	:= StatusAnalogInputBroken( X20AI8321_112.ModuleOk, X20AI8321_112.Status01, X20AI8321_112.Status02, 6);
	gInksInputs[8].iVacuum1Raw := X20AI8321_112.AInput[7];
	gInksInputs[8].xVacuum1SensorError 	:= StatusAnalogInputBroken( X20AI8321_112.ModuleOk, X20AI8321_112.Status01, X20AI8321_112.Status02, 7);
	gInksInputs[8].iVacuum2Raw := X20AI8321_112.AInput[8];
	gInksInputs[8].xVacuum2SensorError 	:= StatusAnalogInputBroken( X20AI8321_112.ModuleOk, X20AI8321_112.Status01, X20AI8321_112.Status02, 8);
	
	gTransVacuum[1].Inputs.iPressureRaw := X20AI8321_113.AInput[1];
	gTransVacuum[1].Inputs.xPressureSensorError := StatusAnalogInputBroken( X20AI8321_113.ModuleOk, X20AI8321_113.Status01, X20AI8321_113.Status02, 1);
	gTransVacuum[2].Inputs.iPressureRaw := X20AI8321_113.AInput[2];
	gTransVacuum[2].Inputs.xPressureSensorError := StatusAnalogInputBroken( X20AI8321_113.ModuleOk, X20AI8321_113.Status01, X20AI8321_113.Status02, 2);
	
	gInksInputs[2].iInTankLevel := X20AI8321_113.AInput[3];
	gInksInputs[2].xInkLevelTankSensorError := StatusAnalogInputBroken( X20AI8321_113.ModuleOk, X20AI8321_113.Status01, X20AI8321_113.Status02, 3);
	gInksInputs[3].iInTankLevel := X20AI8321_113.AInput[4];
	gInksInputs[3].xInkLevelTankSensorError := StatusAnalogInputBroken( X20AI8321_113.ModuleOk, X20AI8321_113.Status01, X20AI8321_113.Status02, 4);
	gInksInputs[4].iInTankLevel := X20AI8321_113.AInput[5];
	gInksInputs[4].xInkLevelTankSensorError := StatusAnalogInputBroken( X20AI8321_113.ModuleOk, X20AI8321_113.Status01, X20AI8321_113.Status02, 5);
	gInksInputs[5].iInTankLevel := X20AI8321_113.AInput[6];
	gInksInputs[5].xInkLevelTankSensorError := StatusAnalogInputBroken( X20AI8321_113.ModuleOk, X20AI8321_113.Status01, X20AI8321_113.Status02, 6);
	gInksInputs[6].iInTankLevel := X20AI8321_113.AInput[7];
	gInksInputs[6].xInkLevelTankSensorError := StatusAnalogInputBroken( X20AI8321_113.ModuleOk, X20AI8321_113.Status01, X20AI8321_113.Status02, 7);
	IF (gMachine.Pt.MachineModel = Type_NOZ_2_AQ) THEN
		gInksInputs[7].iInTankLevel := X20AI8321_113.AInput[8];
		gInksInputs[7].xInkLevelTankSensorError := StatusAnalogInputBroken( X20AI8321_113.ModuleOk, X20AI8321_113.Status01, X20AI8321_113.Status02, 8);
	ELSE
		gInksInputs[8].iInTankLevel := X20AI8321_113.AInput[8];
		gInksInputs[8].xInkLevelTankSensorError := StatusAnalogInputBroken( X20AI8321_113.ModuleOk, X20AI8321_113.Status01, X20AI8321_113.Status02, 8);
	END_IF
	
 

	//PT100
	gBlockInputs[1].xModuleTemp01Ok	:= X20AT4222_118.ModuleOk;
	gInksInputs[1].iTemperatureRaw := X20AT4222_118.TempInput[1];
	gInksInputs[1].xTempSensorError	:= StatusTemperatureInput(X20AT4222_118.Status01, 1);
	gInksInputs[2].iTemperatureRaw := X20AT4222_118.TempInput[2];
	gInksInputs[2].xTempSensorError	:= StatusTemperatureInput(X20AT4222_118.Status01, 2);
	gInksInputs[3].iTemperatureRaw := X20AT4222_118.TempInput[3];
	gInksInputs[3].xTempSensorError	:= StatusTemperatureInput(X20AT4222_118.Status01, 3);
	gInksInputs[4].iTemperatureRaw := X20AT4222_118.TempInput[4];
	gInksInputs[4].xTempSensorError	:= StatusTemperatureInput(X20AT4222_118.Status01, 4);
	
	gBlockInputs[1].xModuleTemp02Ok	:= X20AT4222_119.ModuleOk;
	gInksInputs[5].iTemperatureRaw := X20AT4222_119.TempInput[1];
	gInksInputs[5].xTempSensorError	:= StatusTemperatureInput(X20AT4222_119.Status01, 1);
	gInksInputs[6].iTemperatureRaw := X20AT4222_119.TempInput[2];
	gInksInputs[6].xTempSensorError	:= StatusTemperatureInput(X20AT4222_119.Status01, 2);
	gInksInputs[7].iTemperatureRaw := X20AT4222_119.TempInput[3];
	gInksInputs[7].xTempSensorError	:= StatusTemperatureInput(X20AT4222_119.Status01, 3);
	gInksInputs[8].iTemperatureRaw := X20AT4222_119.TempInput[4];
	gInksInputs[8].xTempSensorError	:= StatusTemperatureInput(X20AT4222_119.Status01, 4);

	
	// SI UNIT BK1	
	gBlockInputs[1].xSiUnitModuleOk		:= SiUnitPwrLnkBK1.ModuleOk;
	gMachine.In.xAirSupply				:= SiUnitPwrLnkBK1.Input01_16.0;
	gBlockInputs[1].xAirVenturiOK		:= SiUnitPwrLnkBK1.Input01_16.1;
	gBlockInputs[1].xTrayOut			:= SiUnitPwrLnkBK1.Input01_16.2;
	gBlockInputs[1].xIclaSensor			:= SiUnitPwrLnkBK1.Input01_16.3;
	gTransVacuum[1].Inputs.xVaccAirFlow	:= gTransVacuum[2].Inputs.xVaccAirFlow := SiUnitPwrLnkBK1.Input01_16.4;
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
	gCuringLed[iIndexColorCuringLedBar].Lamp[1].Inputs.ThermalFault	:= NOT X20DIF371_153.DInput[1];
	gCuringLed[iIndexColorCuringLedBar].Lamp[1].Inputs.SLMFault		:= NOT X20DIF371_153.DInput[2];
	gCuringLed[iIndexColorCuringLedBar].Lamp[2].Inputs.ThermalFault	:= NOT X20DIF371_153.DInput[3];
	gCuringLed[iIndexColorCuringLedBar].Lamp[2].Inputs.SLMFault		:= NOT X20DIF371_153.DInput[4];
	gCuringLed[iIndexColorCuringLedBar].Lamp[3].Inputs.ThermalFault	:= NOT X20DIF371_153.DInput[5];
	gCuringLed[iIndexColorCuringLedBar].Lamp[3].Inputs.SLMFault		:= NOT X20DIF371_153.DInput[6];
	gCuringLed[iIndexColorCuringLedBar].Lamp[4].Inputs.ThermalFault	:= NOT X20DIF371_153.DInput[7];
	gCuringLed[iIndexColorCuringLedBar].Lamp[4].Inputs.SLMFault		:= NOT X20DIF371_153.DInput[8];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xN2HighFlow	:= NOT X20DIF371_153.DInput[9];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xN2LowFlow		:= NOT X20DIF371_153.DInput[10];
	gMachine.In.AntiStatic.xGenAlarm								:= X20DIF371_153.DInput[13];
	gMachine.In.AntiStatic.xIonLevelAlarm							:= X20DIF371_153.DInput[14];

	gCuringLed[iIndexWhiteCuringLedBar].Lamp[1].Inputs.ThermalFault	:= NOT X20DIF371_154.DInput[1];
	gCuringLed[iIndexWhiteCuringLedBar].Lamp[1].Inputs.SLMFault		:= NOT X20DIF371_154.DInput[2];
	gCuringLed[iIndexWhiteCuringLedBar].Lamp[2].Inputs.ThermalFault	:= NOT X20DIF371_154.DInput[3];
	gCuringLed[iIndexWhiteCuringLedBar].Lamp[2].Inputs.SLMFault		:= NOT X20DIF371_154.DInput[4];
	gCuringLed[iIndexWhiteCuringLedBar].Lamp[3].Inputs.ThermalFault	:= NOT X20DIF371_154.DInput[5];
	gCuringLed[iIndexWhiteCuringLedBar].Lamp[3].Inputs.SLMFault		:= NOT X20DIF371_154.DInput[6];
	gCuringLed[iIndexWhiteCuringLedBar].Lamp[4].Inputs.ThermalFault	:= NOT X20DIF371_154.DInput[7];
	gCuringLed[iIndexWhiteCuringLedBar].Lamp[4].Inputs.SLMFault		:= NOT X20DIF371_154.DInput[8];
	gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xN2HighFlow	:= NOT X20DIF371_154.DInput[9];
	gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xN2LowFlow		:= NOT X20DIF371_154.DInput[10];
	
	gMachine.In.CleanBelt.xError := X20DIF371_154.DInput[13];
		
	gMachine.In.CleanBelt.xOpenGuide := X20DIF371_154.DInput[15]; //Clean Belt - Open Guide
	
	//Analog inputs
	gCuringLed[iIndexColorCuringLedBar].Lamp[1].Inputs.TemperatureRaw := X20AI8221_156.AInput[1];
	gCuringLed[iIndexColorCuringLedBar].Lamp[2].Inputs.TemperatureRaw := X20AI8221_156.AInput[2];
	gCuringLed[iIndexColorCuringLedBar].Lamp[3].Inputs.TemperatureRaw := X20AI8221_156.AInput[3];
	gCuringLed[iIndexColorCuringLedBar].Lamp[4].Inputs.TemperatureRaw := X20AI8221_156.AInput[4];
	gCuringLed[iIndexWhiteCuringLedBar].Lamp[1].Inputs.TemperatureRaw := X20AI8221_156.AInput[5];
	gCuringLed[iIndexWhiteCuringLedBar].Lamp[2].Inputs.TemperatureRaw := X20AI8221_156.AInput[6];
	gCuringLed[iIndexWhiteCuringLedBar].Lamp[3].Inputs.TemperatureRaw := X20AI8221_156.AInput[7];
	gCuringLed[iIndexWhiteCuringLedBar].Lamp[4].Inputs.TemperatureRaw := X20AI8221_156.AInput[8];
	
	//Edge hold down
	//Inductive sensors
	gPairedMotors[1].Motor[1].Inputs.xMinPositionReached := X20DIF371_180.DInput[1]; //Elevation motor. Entry side
	gPairedMotors[1].Motor[1].Inputs.xMaxPositionReached := X20DIF371_180.DInput[2]; //Elevation motor. Entry side
	gPairedMotors[2].Motor[1].Inputs.xMaxPositionReached := X20DIF371_180.DInput[3]; //Width fitting motor. Entry side
	gPairedMotors[2].Motor[1].Inputs.xMinPositionReached := X20DIF371_180.DInput[4]; //Width fitting motor. Entry side
	gPairedMotors[1].Motor[2].Inputs.xMinPositionReached := X20DIF371_180.DInput[5]; //Elevation motor. Exit side
	gPairedMotors[1].Motor[2].Inputs.xMaxPositionReached := X20DIF371_180.DInput[6]; //Elevation motor. Exit side
	gPairedMotors[2].Motor[2].Inputs.xMaxPositionReached := X20DIF371_180.DInput[7]; //Width fitting motor. Exit side
	gPairedMotors[2].Motor[2].Inputs.xMinPositionReached := X20DIF371_180.DInput[8]; //Width fitting motor. Exit side
	gEdgeHoldDown.inputs.xJam := NOT X20DIF371_180.DInput[9];
	gPairedMotors[1].Inputs.xSafetyEnable := gPairedMotors[2].Inputs.xSafetyEnable := gMachine.In.xSafetyEnabled;
	
	//Analog sensors
	gPairedMotors[2].Motor[1].Inputs.iMeasuredPositionFrontSide := X20AI8321_181.AInput[1];
	gPairedMotors[2].Motor[1].Inputs.xMeasuredPositionFrontSideError := StatusAnalogInputBroken( X20AI8321_181.ModuleOk, X20AI8321_181.Status01, X20AI8321_181.Status02, 1);
	gPairedMotors[2].Motor[1].Inputs.iMeasuredPositionBackSide := X20AI8321_181.AInput[2];
	gPairedMotors[2].Motor[1].Inputs.xMeasuredPositionBackSideError := StatusAnalogInputBroken( X20AI8321_181.ModuleOk, X20AI8321_181.Status01, X20AI8321_181.Status02, 2);
	gPairedMotors[2].Motor[2].Inputs.iMeasuredPositionFrontSide := X20AI8321_181.AInput[3];
	gPairedMotors[2].Motor[2].Inputs.xMeasuredPositionFrontSideError := StatusAnalogInputBroken( X20AI8321_181.ModuleOk, X20AI8321_181.Status01, X20AI8321_181.Status02, 3);
	gPairedMotors[2].Motor[2].Inputs.iMeasuredPositionBackSide := X20AI8321_181.AInput[4];
	gPairedMotors[2].Motor[2].Inputs.xMeasuredPositionBackSideError := StatusAnalogInputBroken( X20AI8321_181.ModuleOk, X20AI8321_181.Status01, X20AI8321_181.Status02, 4);

		
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
	gPrimer.Inputs.xNoPowered 					:= NOT Pdc_X20DIF371_002.DInput[8];
	gOverVarnish.Inputs.xNoPowered  			:= NOT Pdc_X20DIF371_002.DInput[9];
	gAxisInverter[1].ElecSignals.In.xBreakerOK 	:= Pdc_X20DIF371_002.DInput[10];
	gAxisInverter[2].ElecSignals.In.xBreakerOK 	:= Pdc_X20DIF371_002.DInput[11];
	gAxisInverter[3].ElecSignals.In.xBreakerOK 	:= Pdc_X20DIF371_002.DInput[12];
	gAxisInverter[4].ElecSignals.In.xBreakerOK 	:= Pdc_X20DIF371_002.DInput[13];
	gLine.Inputs.xPrinterPowered				:= Pdc_X20DIF371_002.DInput[14];
	gStacker.Inputs.xNoPowered 					:= NOT Pdc_X20DIF371_002.DInput[15];
	gLine.Inputs.xOvervoltageProtectionOk 		:= NOT Pdc_X20DIF371_002.DInput[16]; 
	
	
	//Line X20DIF371_003
	gMachine.In.xHoppersSoftStarterFault	:= Pdc_X20DIF371_003.DInput[1];
	gLine.Inputs.x24VdcStartSeqNoPowered	:= NOT Pdc_X20DIF371_003.DInput[2];
	gLine.Inputs.UPSs[1].LoadOnUtility		:= Pdc_X20DIF371_003.DInput[3];
	gLine.Inputs.UPSs[1].LoadOnBattery 		:= gLine.Inputs.UPSs[1].xPowerFault := Pdc_X20DIF371_003.DInput[4];
	gLine.Inputs.UPSs[1].xLowBattery 		:= Pdc_X20DIF371_003.DInput[5];
	gLine.Inputs.UPSs[1].xByPass			:= Pdc_X20DIF371_003.DInput[6];
	//Maneta printer accionada				:= Pdc_X20DIF371_003.DInput[7];		**To be check with HW team
	gChiller[1].In.xCooling					:= Pdc_X20DIF371_003.DInput[8]; // NOZOMITWO-1410
	gChiller[1].In.xPowered					:= Pdc_X20DIF371_003.DInput[9]; // NOZOMITWO-1410
	gChiller[1].In.xAlarm					:= NOT Pdc_X20DIF371_003.DInput[10]; // NOZOMITWO-1410
	//SPARE := Pdc_X20DIF371_003.DInput[11];
	//SPARE := Pdc_X20DIF371_003.DInput[12];
	//SPARE := Pdc_X20DIF371_003.DInput[13];
	//SPARE := Pdc_X20DIF371_003.DInput[14];	

	
	//Line X20DIF371_004
	//Main Switch Accionado - Dryer 	:= Pdc_X20DIF371_004.DInput[1];	**To be check with HW team
	gDryerAnc.Inputs.xError 			:= Pdc_X20DIF371_004.DInput[2];
	gFeeder.Inputs.xOnline 				:= Pdc_X20DIF371_004.DInput[3];
	gFeeder.Inputs.xError 				:= Pdc_X20DIF371_004.DInput[4];
	gFeeder.Inputs.xFeeding 			:= Pdc_X20DIF371_004.DInput[5];
	gFeeder.Inputs.xMultiPick 			:= Pdc_X20DIF371_004.DInput[6];
	gFeeder.Inputs.xTrayEmpty 			:= Pdc_X20DIF371_004.DInput[7];
	gFeeder.Inputs.xMediaLowL1 			:= Pdc_X20DIF371_004.DInput[8];
	gFeeder.Inputs.xMediaThickness 		:= Pdc_X20DIF371_004.DInput[9];
	gFeeder.Inputs.xReadyToFeed 		:= Pdc_X20DIF371_004.DInput[10];
	gFeeder.Inputs.xModelInput[0] 		:= Pdc_X20DIF371_004.DInput[11];
	gFeeder.Inputs.xModelInput[1] 		:= Pdc_X20DIF371_004.DInput[12];
	gFeeder.Inputs.xModelInput[2] 		:= Pdc_X20DIF371_004.DInput[13];
	gPrimer.Inputs.xReadyToPrime 		:= Pdc_X20DIF371_004.DInput[14];
	gPrimer.Inputs.xCoating 			:= Pdc_X20DIF371_004.DInput[15];
	gPrimer.Inputs.xError 				:= Pdc_X20DIF371_004.DInput[16];
	
	
	//Line X20DIF371_005
	gPrimer.Inputs.xDryerInRun 			:= Pdc_X20DIF371_005.DInput[1];
	gPrimer.Inputs.xTransportMoving 	:= Pdc_X20DIF371_005.DInput[2];
	gPrimer.Inputs.xModelInput[0] 		:= Pdc_X20DIF371_005.DInput[3];
	gPrimer.Inputs.xModelInput[1] 		:= Pdc_X20DIF371_005.DInput[4];
	gPrimer.Inputs.xModelInput[2] 		:= Pdc_X20DIF371_005.DInput[5];
	gOverVarnish.Inputs.xReadyToPrime 	:= Pdc_X20DIF371_005.DInput[6];
	gOverVarnish.Inputs.xCoating 		:= Pdc_X20DIF371_005.DInput[7];
	gOverVarnish.Inputs.xError 			:= Pdc_X20DIF371_005.DInput[8];
	gOverVarnish.Inputs.xDryerInRun 	:= Pdc_X20DIF371_005.DInput[9];
	gOverVarnish.Inputs.xTransportMoving := Pdc_X20DIF371_005.DInput[10];
	gOverVarnish.Inputs.xModelInput[0] 	:= Pdc_X20DIF371_005.DInput[11];
	gOverVarnish.Inputs.xModelInput[1] 	:= Pdc_X20DIF371_005.DInput[12];
	gOverVarnish.Inputs.xModelInput[2] 	:= Pdc_X20DIF371_005.DInput[13];
	gDryerAnc.Inputs.xModelInput[0] 	:= Pdc_X20DIF371_005.DInput[14];
	gDryerAnc.Inputs.xModelInput[1] 	:= Pdc_X20DIF371_005.DInput[15];
	gDryerAnc.Inputs.xModelInput[2] 	:= Pdc_X20DIF371_005.DInput[16];

	
	//Line X20DIF371_006
	gStacker.Inputs.xError 				:= Pdc_X20DIF371_006.DInput[1];
	gStacker.Inputs.xReadyToStack 		:= Pdc_X20DIF371_006.DInput[2];
	gStacker.Inputs.xFeedInterrupt 		:= Pdc_X20DIF371_006.DInput[3];
	gStacker.Inputs.xRunning 			:= Pdc_X20DIF371_006.DInput[4];
	gStacker.Inputs.xModelInput[0] 		:= Pdc_X20DIF371_006.DInput[5];
	gStacker.Inputs.xModelInput[1] 		:= Pdc_X20DIF371_006.DInput[6];
	gStacker.Inputs.xModelInput[2] 		:= Pdc_X20DIF371_006.DInput[7];
	gStacker.Inputs.xRejectSuccess 		:= Pdc_X20DIF371_006.DInput[8];
	gStacker.Inputs.xStackSuccess 		:= Pdc_X20DIF371_006.DInput[9];

	gMachine.In.xRemoteJog 				:= Pdc_X20DIF371_006.DInput[11];

	//SPARE := Pdc_X20DIF371_006.DInput[10];
	//SPARE := Pdc_X20DIF371_006.DInput[11];
	//SPARE := Pdc_X20DIF371_006.DInput[12];
	//SPARE := Pdc_X20DIF371_006.DInput[13];
	//SPARE := Pdc_X20DIF371_006.DInput[14];
	gBeltClean.Inputs.xAirTurbVSDAvailable	:= Pdc_X20DIF371_006.DInput[15]; // NOZOMITWO-1912 New cleaning system for Noz2 water
	gMachine.In.xSafetyEnabled := Pdc_X20DIF371_006.DInput[16];
	
	
	//Line X20DIF371_020
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuDcOk[1] := Pdc_X20DIF371_020.DInput[1];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuAcOk[1] := Pdc_X20DIF371_020.DInput[2];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuDcOk[2] := Pdc_X20DIF371_020.DInput[3];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuAcOk[2] := Pdc_X20DIF371_020.DInput[4];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuDcOk[3] := Pdc_X20DIF371_020.DInput[5];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuAcOk[3] := Pdc_X20DIF371_020.DInput[6];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuDcOk[4] := Pdc_X20DIF371_020.DInput[7];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuAcOk[4] := Pdc_X20DIF371_020.DInput[8];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuDcOk[5] := Pdc_X20DIF371_020.DInput[9];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuAcOk[5] := Pdc_X20DIF371_020.DInput[10];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuDcOk[6] := Pdc_X20DIF371_020.DInput[11];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuAcOk[6] := Pdc_X20DIF371_020.DInput[12];	
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xSafetyEnable := gMachine.In.xSafetyEnabled;
	gChiller[gCuringLed[iIndexColorCuringLedBar].Parameters.iChillerIndex].In.xAlarm := Pdc_X20DIF371_020.DInput[16];
	
	//Line X20DIF371_021
	gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xPsuDcOk[1] := Pdc_X20DIF371_021.DInput[1];
	gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xPsuAcOk[1] := Pdc_X20DIF371_021.DInput[2];
	gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xPsuDcOk[2] := Pdc_X20DIF371_021.DInput[3];
	gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xPsuAcOk[2] := Pdc_X20DIF371_021.DInput[4];
	gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xPsuDcOk[3] := Pdc_X20DIF371_021.DInput[5];
	gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xPsuAcOk[3] := Pdc_X20DIF371_021.DInput[6];
	gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xPsuDcOk[4] := Pdc_X20DIF371_021.DInput[7];
	gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xPsuAcOk[4] := Pdc_X20DIF371_021.DInput[8];
	//Enable cleaning belt := Pdc_X20DIF371_021.DInput[9];
	gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xSafetyEnable := gMachine.In.xSafetyEnabled;
	gChiller[gCuringLed[iIndexWhiteCuringLedBar].Parameters.iChillerIndex].In.xAlarm := Pdc_X20DIF371_021.DInput[16];

	
	//Line X20DIF371_040
	gLine.Inputs.UPSs[2].LoadOnUtility			:= Pdc_X20DIF371_040.DInput[3];
	gLine.Inputs.UPSs[2].LoadOnBattery 			:= gLine.Inputs.UPSs[2].xPowerFault := Pdc_X20DIF371_040.DInput[4];
	gLine.Inputs.UPSs[2].xLowBattery 			:= Pdc_X20DIF371_040.DInput[5];
	gLine.Inputs.UPSs[2].xByPass				:= Pdc_X20DIF371_040.DInput[6];
	
	//Line X20DIF371_050 (Sarm related)
	gSarm.Inputs.xModelInput[0] := Pdc_X20DIF371_050.DInput[1];
	gSarm.Inputs.xModelInput[1] := Pdc_X20DIF371_050.DInput[2];
	gSarm.Inputs.xModelInput[2] := Pdc_X20DIF371_050.DInput[3];
	gSarm.Inputs.xError := Pdc_X20DIF371_050.DInput[4];
	gSarm.Inputs.xRunning := Pdc_X20DIF371_050.DInput[5];
	// := Pdc_X20DIF371_050.DInput[6];
	// := Pdc_X20DIF371_050.DInput[7];
	// := Pdc_X20DIF371_050.DInput[8];
	// := Pdc_X20DIF371_050.DInput[9];
	// := Pdc_X20DIF371_050.DInput[10];
	// := Pdc_X20DIF371_050.DInput[11];
	// := Pdc_X20DIF371_050.DInput[12];
	gSarm.Inputs.xPowered		:= Pdc_X20DIF371_050.DInput[13];
	//Primer "xNoPowered" input must be wired to the same input used for other ancillaries.
	gPrimer.Inputs.xIrPowered 	:= Pdc_X20DIF371_050.DInput[14]; //Mapped in case we would want raise alarm related to this power branch.
	gPrimer.Inputs.xUvPowered 	:= Pdc_X20DIF371_050.DInput[15]; //Mapped in case we would want raise alarm related to this power branch.
	//OverVarnish "xNoPowered" input must be wired to the same input used for other ancillaries.
	//gOverVarnish.Inputs.xNoPowered := NOT Pdc_X20DIF371_050.DInput[16];
	
	
	//Signals Forced by Configuration
	FOR iIndexBlock := 1 TO gMachine.Pt.CT.iNumBlocks DO
		gBlock[iIndexBlock].parameters.Hw.iNumPrintheadsPSU := 6;
		gBlock[iIndexBlock].parameters.Hw.iNumHeaterPSU := 0;
	END_FOR
	
	//To review with electrical team how to get these signals from chiller
	gChiller[1].In.xPowered	:= TRUE;
	gChiller[2].In.xPowered	:= TRUE;
	
END_ACTION
