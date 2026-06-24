
ACTION InputsCube:
	
	//These signals must come from X5?
	gMachine.In.xConsentL1Ok := gSafetyController.Outputs.xPrinterToX5;
	gMachine.In.xConsentL2Ok := gSafetyController.Outputs.xPrinterToX5;
	
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xFrontDoorClosed := gSafetyController.Inputs.xPrinterFrontDoorSwitch;
	
	//////////
	//PDC
	//////////
	//PDC X20DIF371_002
	//These inputs are read in MachineConfigurator>InputsMachineModel
	//	:= Pdc_X20DIF371_002.DInput[1];
	//	:= Pdc_X20DIF371_002.DInput[2];
	//	:= Pdc_X20DIF371_002.DInput[3];
	//	:= Pdc_X20DIF371_002.DInput[4];
	//	:= Pdc_X20DIF371_002.DInput[5];
	//	:= Pdc_X20DIF371_002.DInput[6];
	gAxisInverter[1].ElecSignals.In.xBreakerOK	:= Pdc_X20DIF371_002.DInput[7];
	gAxisInverter[2].ElecSignals.In.xBreakerOK	:= Pdc_X20DIF371_002.DInput[8];
	gMachine.In.xOvervoltage  := NOT Pdc_X20DIF371_002.DInput[9];
	//24vdc psu IDS Power alarm	:= Pdc_X20DIF371_002.DInput[10];
	gMachine.In.x24Vdc	:= Pdc_X20DIF371_002.DInput[11];
	//Printer maniobra power supply OK	:= Pdc_X20DIF371_002.DInput[12];
	gMachine.In.xPowerSwitch	:= Pdc_X20DIF371_002.DInput[13];
	gMachine.In.xSafetyEnabled	:= Pdc_X20DIF371_002.DInput[14]; //Enable printer coming direct from safety controller
	// := NOT Pdc_X20DIF371_002.DInput[15];
	// := NOT Pdc_X20DIF371_002.DInput[16]; 
	
	
	//PDC X20DIF371_003
	//Reserved for Ultra(¿?)
	//X5 - 3ph power supply OK := Pdc_X20DIF371_003.DInput[1];
	//X5 - 1ph+n power supply OK	:= Pdc_X20DIF371_003.DInput[2];
	gMachine.In.xRemoteReset	:= Pdc_X20DIF371_003.DInput[3];
	gMachine.In.xRemoteJog	:= Pdc_X20DIF371_003.DInput[4];
	//X5 - MI1	:= Pdc_X20DIF371_003.DInput[5];
	//X5 - MI2	:= Pdc_X20DIF371_003.DInput[6];
	//X5 - MI3	:= Pdc_X20DIF371_003.DInput[7];
	//SPARE	:= Pdc_X20DIF371_003.DInput[8];  ////////// Here goes the CheckMedia signal
	//SPARE	:= Pdc_X20DIF371_003.DInput[9];
	//SPARE	:= Pdc_X20DIF371_003.DInput[10];
	//SPARE := Pdc_X20DIF371_003.DInput[11];
	//SPARE := Pdc_X20DIF371_003.DInput[12];
	//SPARE := Pdc_X20DIF371_003.DInput[13];
	//SPARE := Pdc_X20DIF371_003.DInput[14];	

	
	//PDC X20DIF371_004
	gInksInputs[1].xPrintHeadsPsuOK := Pdc_X20DIF371_004.DInput[1];
	gInksInputs[2].xPrintHeadsPsuOK := Pdc_X20DIF371_004.DInput[2];
	gInksInputs[3].xPrintHeadsPsuOK := Pdc_X20DIF371_004.DInput[3];
	gInksInputs[4].xPrintHeadsPsuOK := Pdc_X20DIF371_004.DInput[4];
	gInksInputs[5].xPrintHeadsPsuOK := Pdc_X20DIF371_004.DInput[5];
	gChiller[gCuringLed[iIndexColorCuringLedBar].Parameters.iChillerIndex].In.xPowered := Pdc_X20DIF371_004.DInput[6];
	gChiller[gCuringLed[iIndexColorCuringLedBar].Parameters.iChillerIndex].In.xCooling := Pdc_X20DIF371_004.DInput[6] AND gChiller[gCuringLed[iIndexColorCuringLedBar].Parameters.iChillerIndex].Out.xStart;
	gChiller[gCuringLed[iIndexColorCuringLedBar].Parameters.iChillerIndex].In.xAlarm := NOT Pdc_X20DIF371_004.DInput[7];
	
	
	//PDC X20DIF371_030
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuDcOk[1] := Pdc_X20DIF371_030.DInput[1];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuAcOk[1] := Pdc_X20DIF371_030.DInput[2];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuDcOk[2] := Pdc_X20DIF371_030.DInput[3];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuAcOk[2] := Pdc_X20DIF371_030.DInput[4];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuDcOk[3] := Pdc_X20DIF371_030.DInput[5];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuAcOk[3] := Pdc_X20DIF371_030.DInput[6];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuDcOk[4] := Pdc_X20DIF371_030.DInput[7];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xPsuAcOk[4] := Pdc_X20DIF371_030.DInput[8];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xSafetyEnable := gMachine.In.xSafetyEnabled; // NOTE: Check the order of assignation. This one after the machine one
	gBlockInputs[1].xPrintHeadPSU[1] := Pdc_X20DIF371_030.DInput[9] (*DcOk*) AND Pdc_X20DIF371_030.DInput[10] (*DcOk*);
	gBlockInputs[1].xHeaterDcOkPsu[1] := Pdc_X20DIF371_030.DInput[11];
	gBlockInputs[1].xHeaterAcOkPsu[1] := Pdc_X20DIF371_030.DInput[12];
	
	//PDC X20DIF371_060
	gMachine.In.UPSs[1].LoadOnUtility := Pdc_X20DIF371_060.DInput[1];
	gMachine.In.UPSs[1].LoadOnBattery 	:= gMachine.In.UPSs[1].xPowerFault := Pdc_X20DIF371_060.DInput[2];
	gMachine.In.UPSs[1].xLowBattery 	:= Pdc_X20DIF371_060.DInput[3];
	gMachine.In.UPSs[1].xByPass 		:= Pdc_X20DIF371_060.DInput[4];
	// := Pdc_X20DIF371_030.DInput[5];
	// := Pdc_X20DIF371_030.DInput[6];
	gMachine.In.UPSs[2].LoadOnUtility	:= Pdc_X20DIF371_060.DInput[7];
	gMachine.In.UPSs[2].LoadOnBattery 	:= gMachine.In.UPSs[2].xPowerFault := Pdc_X20DIF371_060.DInput[8];
	gMachine.In.UPSs[2].xLowBattery 	:= Pdc_X20DIF371_060.DInput[9];
	gMachine.In.UPSs[2].xByPass 		:= Pdc_X20DIF371_060.DInput[10];
	
		
	//PDC X20DIF371_060
	gAxisInverter[3].ElecSignals.In.xBreakerOK := Pdc_X20DIF371_070.DInput[1];
	
	
	//////////
	//PRINTER
	//////////
	
	//101
	gMachine.In.Buttons.xAuto := X20DIF371_101.DInput[1];
	gMachine.In.Buttons.xZero := NOT X20DIF371_101.DInput[2];
	gMachine.In.Buttons.xManual := X20DIF371_101.DInput[3];
	gMachine.In.Buttons.xReset := X20DIF371_101.DInput[4];

	gMachine.In.ProductDetect.pPDCarriageSignalL1 := ADR(X20DIF371_101.DInput[5]);
	gMachine.In.ProductDetect.pPDCarriageSignalL2	:= ADR(FakeBoolInput);
	gBlockInputs[1].xReferenceDI := X20DIF371_101.DInput[6];
	gMachine.In.ProductDetect.pPDSignalSensorL1	:= ADR(X20DIF371_101.DInput[7]);
	gMachine.In.ProductDetect.pPDSignalSensorL2	:= ADR(FakeBoolInput);
	gDing.In.xDingLow:= X20DIF371_101.DInput[8];					
	gDing.In.xDingHigh:= X20DIF371_101.DInput[9];	
	gThicknessCtrl.Inputs.CheckMedia[1].xCheckFail := X20DIF371_101.DInput[11] OR NOT Pdc_X20DIF371_003.DInput[8];
	gDing.In.xModuleOK := Pdc_X20AI2636_050.ModuleOk;
	gDing.In.xDingChannelFault := Pdc_X20AI2636_050.DInput[1];
  
	//102
	gJamInputs[1].xJamCrash[1] := X20DIF371_102.DInput[1];
	gJamInputs[1].xJamCrash[2] := X20DIF371_102.DInput[2];
	gJamInputs[1].xJamCrash[3] := X20DIF371_102.DInput[3];
	gJamInputs[1].xJamCrash[4] := X20DIF371_102.DInput[4];
	gJamInputs[2].xJamCrash[1] := X20DIF371_102.DInput[5];
	gJamInputs[2].xJamCrash[2] := X20DIF371_102.DInput[6];
	gJamInputs[2].xJamCrash[3] := X20DIF371_102.DInput[7];
	gJamInputs[1].xJamLowCrash := X20DIF371_102.DInput[8];
	gJamInputs[1].xJamTestOk := X20DIF371_102.DInput[9];
	gJamInputs[2].xJamLowCrash := X20DIF371_102.DInput[10];
	gJamInputs[2].xJamTestOk := X20DIF371_102.DInput[11];

	//103	
	gInksInputs[1].xOverpressure  := NOT X20DIF371_103.DInput[1];
	gInksInputs[2].xOverpressure  := NOT X20DIF371_103.DInput[2];
	gInksInputs[3].xOverpressure  := NOT X20DIF371_103.DInput[3];
	gInksInputs[4].xOverpressure  := NOT X20DIF371_103.DInput[4];
	gInksInputs[5].xOverpressure  := NOT X20DIF371_103.DInput[5];
	//  := X20DIF371_103.DInput[6];
	//  := X20DIF371_103.DInput[7];
	//  := X20DIF371_103.DInput[8];
	// := X20DIF371_103.DInput[9];
	// := X20DIF371_105.DInput[10];
	gInksInputs[1].xKlixonTriggered := NOT X20DIF371_103.DInput[11];
	gInksInputs[2].xKlixonTriggered := NOT X20DIF371_103.DInput[12];
	gInksInputs[3].xKlixonTriggered := NOT X20DIF371_103.DInput[13];
	gInksInputs[4].xKlixonTriggered := NOT X20DIF371_103.DInput[14];
	gInksInputs[5].xKlixonTriggered := NOT X20DIF371_103.DInput[15];
	

	//104
	//UV Curing leds related
	gCuringLed[iIndexColorCuringLedBar].Lamp[1].Inputs.ThermalFault	:= NOT X20DIF371_104.DInput[1];
	gCuringLed[iIndexColorCuringLedBar].Lamp[1].Inputs.SLMFault		:= NOT X20DIF371_104.DInput[2];
	gCuringLed[iIndexColorCuringLedBar].Lamp[2].Inputs.ThermalFault	:= NOT X20DIF371_104.DInput[3];
	gCuringLed[iIndexColorCuringLedBar].Lamp[2].Inputs.SLMFault		:= NOT X20DIF371_104.DInput[4];
	gCuringLed[iIndexColorCuringLedBar].Lamp[3].Inputs.ThermalFault	:= NOT X20DIF371_104.DInput[5];
	gCuringLed[iIndexColorCuringLedBar].Lamp[3].Inputs.SLMFault		:= NOT X20DIF371_104.DInput[6];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xN2LowFlow	:= NOT X20DIF371_104.DInput[7];
	gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xN2HighFlow	:= NOT X20DIF371_104.DInput[8];
	
	
	//Analog inputs
	//X20AI8321_111
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
	
	//X20AI8321_112
	gInksInputs[5].iVacuum1Raw := X20AI8321_112.AInput[1];
	gInksInputs[5].xVacuum1SensorError 	:= StatusAnalogInputBroken( X20AI8321_112.ModuleOk, X20AI8321_112.Status01, X20AI8321_112.Status02, 1);
	gInksInputs[5].iVacuum2Raw := X20AI8321_112.AInput[2];
	gInksInputs[5].xVacuum2SensorError 	:= StatusAnalogInputBroken( X20AI8321_112.ModuleOk, X20AI8321_112.Status01, X20AI8321_112.Status02, 2);
	gBlockInputs[1].iHumidityRaw := X20AI8321_112.AInput[3];
	gBlockInputs[1].xHumiditySensorError 	:= StatusAnalogInputBroken( X20AI8321_112.ModuleOk, X20AI8321_112.Status01, X20AI8321_112.Status02, 3);
	gBlockInputs[1].iTemperatureRaw := X20AI8321_112.AInput[4];
	gBlockInputs[1].xTemperatureSensorError	:= StatusAnalogInputBroken( X20AI8321_112.ModuleOk, X20AI8321_112.Status01, X20AI8321_112.Status02, 4);
	
	
	//X20AI8321_113
	gTransVacuum[1].Inputs.iPressureRaw := X20AI8321_113.AInput[1];
	gTransVacuum[1].Inputs.xPressureSensorError := StatusAnalogInputBroken( X20AI8321_113.ModuleOk, X20AI8321_113.Status01, X20AI8321_113.Status02, 1);
	gMachine.In.ProductDetect.iAnalogSignal := X20AI8321_113.AInput[2]; //-2mm = 4mA, 10mm = 20mA
	gMachine.In.ProductDetect.xAnalogSignalError := StatusAnalogInputBroken( X20AI8321_113.ModuleOk, X20AI8321_113.Status01, X20AI8321_113.Status02, 2);
	
	gInksInputs[1].iInTankLevel := X20AI8321_113.AInput[3];
	gInksInputs[1].xInkLevelTankSensorError := StatusAnalogInputBroken( X20AI8321_113.ModuleOk, X20AI8321_113.Status01, X20AI8321_113.Status02, 3);
	gInksInputs[2].iInTankLevel := X20AI8321_113.AInput[4];
	gInksInputs[2].xInkLevelTankSensorError := StatusAnalogInputBroken( X20AI8321_113.ModuleOk, X20AI8321_113.Status01, X20AI8321_113.Status02, 4);
	gInksInputs[3].iInTankLevel := X20AI8321_113.AInput[5];
	gInksInputs[3].xInkLevelTankSensorError := StatusAnalogInputBroken( X20AI8321_113.ModuleOk, X20AI8321_113.Status01, X20AI8321_113.Status02, 5);
	gInksInputs[4].iInTankLevel := X20AI8321_113.AInput[6];
	gInksInputs[4].xInkLevelTankSensorError := StatusAnalogInputBroken( X20AI8321_113.ModuleOk, X20AI8321_113.Status01, X20AI8321_113.Status02, 6);
	gInksInputs[5].iInTankLevel := X20AI8321_113.AInput[7];
	gInksInputs[5].xInkLevelTankSensorError := StatusAnalogInputBroken( X20AI8321_113.ModuleOk, X20AI8321_113.Status01, X20AI8321_113.Status02, 7);
 

	//PT100
	gBlockInputs[1].xModuleTemp01Ok	:= X20AT4222_119.ModuleOk;
	gInksInputs[1].iTemperatureRaw := X20AT4222_119.TempInput[1];
	gInksInputs[1].xTempSensorError	:= StatusTemperatureInput(X20AT4222_119.Status01, 1) OR NOT X20AT4222_119.ModuleOk;
	gInksInputs[2].iTemperatureRaw := X20AT4222_119.TempInput[2];
	gInksInputs[2].xTempSensorError	:= StatusTemperatureInput(X20AT4222_119.Status01, 2) OR NOT X20AT4222_119.ModuleOk;
	gInksInputs[3].iTemperatureRaw := X20AT4222_119.TempInput[3];
	gInksInputs[3].xTempSensorError	:= StatusTemperatureInput(X20AT4222_119.Status01, 3) OR NOT X20AT4222_119.ModuleOk;
	gInksInputs[4].iTemperatureRaw := X20AT4222_119.TempInput[4];
	gInksInputs[4].xTempSensorError	:= StatusTemperatureInput(X20AT4222_119.Status01, 4) OR NOT X20AT4222_119.ModuleOk;
	
	gBlockInputs[1].xModuleTemp02Ok	:= X20AT4222_120.ModuleOk;
	gInksInputs[5].iTemperatureRaw := X20AT4222_120.TempInput[1];
	gInksInputs[5].xTempSensorError	:= StatusTemperatureInput(X20AT4222_120.Status01, 1)  OR NOT X20AT4222_120.ModuleOk;

	
	// SI UNIT BK1	
	gBlockInputs[1].xSiUnitModuleOk		:= SiUnitPwrLnkBK1.ModuleOk;
	gMachine.In.xAirSupply				:= SiUnitPwrLnkBK1.Input01_16.0;
	gBlockInputs[1].xAirVenturiOK		:= SiUnitPwrLnkBK1.Input01_16.1;
	gBlockInputs[1].xTrayOut			:= SiUnitPwrLnkBK1.Input01_16.2;
	gBlockInputs[1].xIclaSensor			:= SiUnitPwrLnkBK1.Input01_16.3;
	gTransVacuum[1].Inputs.xVaccAirFlow	:= SiUnitPwrLnkBK1.Input01_16.4;
	//SPARE 							:= SiUnitPwrLnkBK1.Input01_16.5;
	gBlockInputs[1].xBarsIn 			:= SiUnitPwrLnkBK1.Input01_16.6;
	
	gTransVacuum[1].Inputs.xSafetyEnable := gMachine.In.xSafetyEnabled; // NOTE: Check the order of assignation. This one after the machine one
	// := SiUnitPwrLnkBK1.Input01_16.7;
	
	//Signals Forced by Configuration
	gBlockInputs[1].Safety.xFrontEStopOK := TRUE;
	gBlockInputs[1].Safety.xRearEStopOK := TRUE;
	
	gBlockInputs[1].Safety.xFrontSafetyOK	:= TRUE;
	gBlockInputs[1].Safety.xRearSafetyOK	:= TRUE;
	gBlockInputs[1].Safety.xSafetyOK 		:= gMachine.In.xSafetyEnabled;
	
	//There are no light curtains so assigning the only safety outputs by safety controller
	gBlockInputs[1].Safety.xCurtainEnable01 := gBlockInputs[1].Safety.xCurtainEnable02 := TRUE;
	
	//Signals Forced by Configuration
	FOR iIndexVac := 1 TO MAX_LAST_TRANS_VACUUM DO gTransVacuum[iIndexVac].Inputs.xBlowersAnyCB := FALSE; END_FOR
	
	//Forcing some variable to TRUE so hardware required is not installed in this machine
	gBelt.parameters.xDriveProtectionOK := TRUE; //This machine has no feedback wired from electrical protection. An alternative is to check axis belt information about power supply
	gBlockInputs[1].xDriveProtectionOK := gBlockInputs[1].xDifferentialOK := TRUE;

	
	//Signals Forced by Configuration
	FOR iIndexBlock := 1 TO gMachine.Pt.CT.iNumBlocks DO
		gBlockInputs[iIndexBlock].xHeaterDcOkBusBar1 := TRUE;
		gBlockInputs[iIndexBlock].xHeaterDcOkBusBar2 := TRUE;
		
		gBlock[iIndexBlock].parameters.Hw.iNumPrintheadsPSU := 1;
		gBlock[iIndexBlock].parameters.Hw.iNumHeaterPSU := 1;
	END_FOR	
	
END_ACTION
