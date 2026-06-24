
ACTION OutputsMecano:
	
	
	//////////
	//PRINTER
	//////////
	X20DOF322_108.DOutput[1] := gLine.Outputs.xGreenLight;
	X20DOF322_108.DOutput[2] := gLine.Outputs.xLightReset; 
	X20DOF322_108.DOutput[3] := gLine.Outputs.xSound OR gMachine.Out.xBuzzerButtonPanel;
	X20DOF322_108.DOutput[4] := gMachine.Out.xAirSupply;
	X20DOF322_108.DOutput[5] := gLine.Outputs.xSound OR gMachine.Out.xBuzzerButtonPanel;
	X20DOF322_108.DOutput[6] := gLine.Outputs.xYellowLight;
	X20DOF322_108.DOutput[7] := gLine.Outputs.xBlueLight;
	X20DOF322_108.DOutput[8] := gLine.Outputs.xRedLight;
	X20DOF322_108.DOutput[9] := gLine.Outputs.xWhiteLight;
	//X20DOF322_108.DOutput[10] := ;
	X20DOF322_108.DOutput[11] := gJamDetect[1].Outputs.xJamTestSignal[1] OR
								gJamDetect[2].Outputs.xJamTestSignal[1] OR
								gJamDetect[3].Outputs.xJamTestSignal[1];
	X20DOF322_108.DOutput[12] := gJamDetect[1].Outputs.xJamTestSignal[2] OR
								gJamDetect[2].Outputs.xJamTestSignal[2] OR
								gJamDetect[3].Outputs.xJamTestSignal[2];
	X20DOF322_108.DOutput[13] := gJamDetect[1].Outputs.xJamTestSignal[3] OR
								gJamDetect[2].Outputs.xJamTestSignal[3] OR
								gJamDetect[3].Outputs.xJamTestSignal[3];
	X20DOF322_108.DOutput[14] := gJamDetect[1].Outputs.xJamTestSignal[4] OR
								gJamDetect[2].Outputs.xJamTestSignal[4] OR
								gJamDetect[3].Outputs.xJamTestSignal[4];

 
	X20DOF322_109.DOutput[1] := gMachine.Out.xRemoteTeachL1;
	X20DOF322_109.DOutput[2] := gMachine.Out.xRemoteTeachL2;
	X20DOF322_109.DOutput[3] := gThicknessCtrl.Outputs.xEnableMediaSignalToCb;
	//X20DOF322_109.DOutput[4] := ;
	X20DOF322_109.DOutput[5] := gMachine.Out.xResetCB1 OR gMachine.Out.xResetCB2;
	X20DOF322_109.DOutput[6] := gMachine.Out.xResetRouter;
	
	
		
	X20DOF322_110.DOutput[1] := gInksOutputs[3].xOutPowPrintHead;
	X20DOF322_110.DOutput[2] := gInksOutputs[4].xOutPowPrintHead;
	X20DOF322_110.DOutput[3] := gInksOutputs[5].xOutPowPrintHead;
	X20DOF322_110.DOutput[4] := gInksOutputs[6].xOutPowPrintHead;
	X20DOF322_110.DOutput[5] := gInksOutputs[7].xOutPowPrintHead;
	X20DOF322_110.DOutput[6] := gInksOutputs[8].xOutPowPrintHead;
	X20DOF322_110.DOutput[7] := gInksOutputs[9].xOutPowPrintHead;
	X20DOF322_110.DOutput[8] := gInksOutputs[10].xOutPowPrintHead;
	X20DOF322_110.DOutput[9] := gInksOutputs[3].xOutBarResistance;
	X20DOF322_110.DOutput[10] := gInksOutputs[4].xOutBarResistance;
	X20DOF322_110.DOutput[11] := gInksOutputs[5].xOutBarResistance;
	X20DOF322_110.DOutput[12] := gInksOutputs[6].xOutBarResistance;
	X20DOF322_110.DOutput[13] := gInksOutputs[7].xOutBarResistance;
	X20DOF322_110.DOutput[14] := gInksOutputs[8].xOutBarResistance;
	X20DOF322_110.DOutput[15] := gInksOutputs[9].xOutBarResistance;
	X20DOF322_110.DOutput[16] := gInksOutputs[10].xOutBarResistance;
	

	
	//Analog outputs
	X20AO4622_116.AOutput[1] := gInksOutputs[3].iDutyCycleFilling;
	X20AO4622_116.AOutput[2] := gInksOutputs[4].iDutyCycleFilling;
 	X20AO4622_116.AOutput[3] := gInksOutputs[3].iDutyCycleNegative;
	X20AO4622_116.AOutput[4] := gInksOutputs[4].iDutyCycleNegative;
 	X20AO4622_117.AOutput[1] := gInksOutputs[5].iDutyCycleFilling;
	X20AO4622_117.AOutput[2] := gInksOutputs[6].iDutyCycleFilling;
 	X20AO4622_117.AOutput[3] := gInksOutputs[5].iDutyCycleNegative;
	X20AO4622_117.AOutput[4] := gInksOutputs[6].iDutyCycleNegative;
	X20AO4622_118.AOutput[1] := gInksOutputs[7].iDutyCycleFilling;
	X20AO4622_118.AOutput[2] := gInksOutputs[8].iDutyCycleFilling;
	X20AO4622_118.AOutput[3] := gInksOutputs[7].iDutyCycleNegative;
	X20AO4622_118.AOutput[4] := gInksOutputs[8].iDutyCycleNegative;
	X20AO4622_119.AOutput[1] := gInksOutputs[9].iDutyCycleFilling;
	X20AO4622_119.AOutput[2] := gInksOutputs[10].iDutyCycleFilling;
	X20AO4622_119.AOutput[3] := gInksOutputs[9].iDutyCycleNegative;
	X20AO4622_119.AOutput[4] := gInksOutputs[10].iDutyCycleNegative;

	X20DOF322_155.DOutput[1] := gCuringLed[iIndexColorCuringLedBar].Lamp[1].Outputs.EnableLamp;
	X20DOF322_155.DOutput[2] := gCuringLed[iIndexColorCuringLedBar].Lamp[2].Outputs.EnableLamp;
	X20DOF322_155.DOutput[3] := gCuringLed[iIndexColorCuringLedBar].Lamp[3].Outputs.EnableLamp;
	X20DOF322_155.DOutput[4] := gCuringLed[iIndexColorCuringLedBar].Lamp[4].Outputs.EnableLamp;
	X20DOF322_155.DOutput[5] := gCuringLed[iIndexColorCuringLedBar].Lamp[5].Outputs.EnableLamp;
	//X20DOF322_155.DOutput[6] := ;
	X20DOF322_155.DOutput[7] := gCuringLed[iIndexWhiteCuringLedBar].Lamp[1].Outputs.EnableLamp;
	X20DOF322_155.DOutput[8] := gCuringLed[iIndexWhiteCuringLedBar].Lamp[2].Outputs.EnableLamp;
	X20DOF322_155.DOutput[9] := gCuringLed[iIndexWhiteCuringLedBar].Lamp[3].Outputs.EnableLamp;
	X20DOF322_155.DOutput[10] := gCuringLed[iIndexWhiteCuringLedBar].Lamp[4].Outputs.EnableLamp;
	X20DOF322_155.DOutput[11] := gCuringLed[iIndexWhiteCuringLedBar].Lamp[5].Outputs.EnableLamp;
	
	X20DOF322_156.DOutput[1] := gCuringLed[iIndexPrimerCuringLedBar].Lamp[1].Outputs.EnableLamp;
	X20DOF322_156.DOutput[2] := gCuringLed[iIndexPrimerCuringLedBar].Lamp[2].Outputs.EnableLamp;
	X20DOF322_156.DOutput[3] := gCuringLed[iIndexPrimerCuringLedBar].Lamp[3].Outputs.EnableLamp;
	X20DOF322_156.DOutput[4] := gCuringLed[iIndexPrimerCuringLedBar].Lamp[4].Outputs.EnableLamp;
	X20DOF322_156.DOutput[5] := gCuringLed[iIndexPrimerCuringLedBar].Lamp[5].Outputs.EnableLamp;
	
	X20DOF322_156.DOutput[12] := gMachine.Out.xAntiStaticPOn;
	X20DOF322_156.DOutput[13] := gMachine.commands.CleanBelt.xCleanBeltMoveFwd;
	X20DOF322_156.DOutput[14] := gMachine.commands.CleanBelt.xCleanBeltMoveBwd;
	X20DOF322_156.DOutput[15] := gMachine.commands.CleanBelt.xCleanBeltResetRelay;
	
	//Analog outputs
	X20AO4622_158.AOutput[1] := gCuringLed[iIndexColorCuringLedBar].Lamp[1].Outputs.IntensityLampRaw;
	X20AO4622_158.AOutput[2] := gCuringLed[iIndexColorCuringLedBar].Lamp[2].Outputs.IntensityLampRaw;
	X20AO4622_158.AOutput[3] := gCuringLed[iIndexColorCuringLedBar].Lamp[3].Outputs.IntensityLampRaw;
	X20AO4622_158.AOutput[4] := gCuringLed[iIndexColorCuringLedBar].Lamp[4].Outputs.IntensityLampRaw;
	
	X20AO4622_159.AOutput[1] := gCuringLed[iIndexColorCuringLedBar].Lamp[5].Outputs.IntensityLampRaw;
	//X20AO4622_159.AOutput[2] := ;
	X20AO4622_159.AOutput[3] := gCuringLed[iIndexWhiteCuringLedBar].Lamp[1].Outputs.IntensityLampRaw;
	X20AO4622_159.AOutput[4] := gCuringLed[iIndexWhiteCuringLedBar].Lamp[2].Outputs.IntensityLampRaw;
	
	X20AO4622_160.AOutput[1] := gCuringLed[iIndexWhiteCuringLedBar].Lamp[3].Outputs.IntensityLampRaw;
	X20AO4622_160.AOutput[2] := gCuringLed[iIndexWhiteCuringLedBar].Lamp[4].Outputs.IntensityLampRaw;
	X20AO4622_160.AOutput[3] := gCuringLed[iIndexWhiteCuringLedBar].Lamp[5].Outputs.IntensityLampRaw;
	X20AO4622_160.AOutput[4] := gCuringLed[iIndexPrimerCuringLedBar].Lamp[1].Outputs.IntensityLampRaw;
	
	X20AO4622_161.AOutput[1] := gCuringLed[iIndexPrimerCuringLedBar].Lamp[2].Outputs.IntensityLampRaw;
	X20AO4622_161.AOutput[2] := gCuringLed[iIndexPrimerCuringLedBar].Lamp[3].Outputs.IntensityLampRaw;
	X20AO4622_161.AOutput[3] := gCuringLed[iIndexPrimerCuringLedBar].Lamp[4].Outputs.IntensityLampRaw;
	X20AO4622_161.AOutput[4] := gCuringLed[iIndexPrimerCuringLedBar].Lamp[5].Outputs.IntensityLampRaw;
	
	

	//////////
	//PDC
	//////////	
	Pdc_X20DOF322_009.DOutput[1] := gMachine.In.xPowerSwitch;
	Pdc_X20DOF322_009.DOutput[2] := gLine.Outputs.ExternalDevices[10].xClose; //Primer
	Pdc_X20DOF322_009.DOutput[3] := gLine.Outputs.ExternalDevices[10].xOpen;
	Pdc_X20DOF322_009.DOutput[4] := gOverVarnish.Outputs.Physical.xRunDryer;
	Pdc_X20DOF322_009.DOutput[5] := gOverVarnish.Outputs.Physical.xRunTransport;
	Pdc_X20DOF322_009.DOutput[6] := gOverVarnish.Outputs.Physical.xRunPriming;
	Pdc_X20DOF322_009.DOutput[7] := gOverVarnish.Outputs.Physical.xPrepareToPrime;
	//Pdc_X20DOF322_009.DOutput[8] := ;
	//Pdc_X20DOF322_009.DOutput[9] := ;
	Pdc_X20DOF322_009.DOutput[10] := gLine.Outputs.ExternalDevices[1].xClose; //Opv
	Pdc_X20DOF322_009.DOutput[11] := gLine.Outputs.ExternalDevices[1].xOpen;
	Pdc_X20DOF322_009.DOutput[12] := gPrimer.Outputs.Physical.xRunDryer;
	Pdc_X20DOF322_009.DOutput[13] := gPrimer.Outputs.Physical.xRunTransport;
	Pdc_X20DOF322_009.DOutput[14] := gPrimer.Outputs.Physical.xRunPriming; 
	Pdc_X20DOF322_009.DOutput[15] := gPrimer.Outputs.Physical.xPrepareToPrime;
	//Pdc_X20DOF322_009.DOutput[16] := ;

	
	//Pdc_X20DOF322_010
	Pdc_X20DOF322_010.DOutput[1] := gLine.Outputs.ExternalDevices[0].xClose; //Feeder
	Pdc_X20DOF322_010.DOutput[2] := gFeeder.Outputs.Physical.xPrepareToFeed;
	Pdc_X20DOF322_010.DOutput[3] := gFeeder.Outputs.Physical.xStartFeeding;
	Pdc_X20DOF322_010.DOutput[4] := gFeeder.Outputs.Physical.xFastStop;
	Pdc_X20DOF322_010.DOutput[5] := gLine.Outputs.ExternalDevices[11].xClose; //Sarm
	Pdc_X20DOF322_010.DOutput[6] := gSarm.Outputs.xStartTransport;
	Pdc_X20DOF322_010.DOutput[7] := gSarm.Outputs.xFastStop;
	Pdc_X20DOF322_010.DOutput[8] := gLine.Outputs.ExternalDevices[6].xClose; //Stacker
	Pdc_X20DOF322_010.DOutput[9] := gStacker.Outputs.xRun;
	Pdc_X20DOF322_010.DOutput[10] := gThicknessCtrl.Outputs.xReject; //gStacker.Outputs.xRejectSheet;
	Pdc_X20DOF322_010.DOutput[11] := gStacker.Outputs.xPrepareToStack;
	Pdc_X20DOF322_010.DOutput[12] := gStacker.Outputs.xEjectRejectStack;
	Pdc_X20DOF322_010.DOutput[13] := gStacker.Outputs.xStackEject;
	Pdc_X20DOF322_010.DOutput[14] := FALSE;
	Pdc_X20DOF322_010.DOutput[15] := FALSE;
	Pdc_X20DOF322_010.DOutput[16] := FALSE;
	
	
	Pdc_X20DOF322_011.DOutput[1] := gMachine.Out.xResetHub;
	Pdc_X20DOF322_011.DOutput[2] := gMachine.Out.xResetSwitch;
	Pdc_X20DOF322_011.DOutput[3] := gMachine.Out.xResetSwitch;
	Pdc_X20DOF322_011.DOutput[4] := gMachine.Out.xSuctionTurbine;
//	Pdc_X20DOF322_011.DOutput[5] := ;
//	Pdc_X20DOF322_011.DOutput[6] := ;
//	Pdc_X20DOF322_011.DOutput[7] := ;
	
	
	//Line X20DOF322_023
	Pdc_X20DOF322_025.DOutput[1] := gChiller[1].St.xInstalled;
	Pdc_X20DOF322_025.DOutput[2] := gChiller[1].Out.xStart;
	Pdc_X20DOF322_025.DOutput[3] := gChiller[2].St.xInstalled;
	Pdc_X20DOF322_025.DOutput[4] := gChiller[2].Out.xStart;
//	Pdc_X20DOF322_025.DOutput[5] := NOT gSafetyController.Alarms.xAlrPrinter;
//	Pdc_X20DOF322_025.DOutput[6] := gChiller[3].Out.xStart;
//	Pdc_X20DOF322_025.DOutput[7] := Chiller de printheads?;
//	Pdc_X20DOF322_025.DOutput[8] := Chiller de printheads?;
	Pdc_X20DOF322_025.DOutput[9] := NOT (gLine.Outputs.ExternalDevices[7].xClose AND gCuringLed[iIndexColorCuringLedBar].Signals.Outputs.xPowerOnLamps AND NOT gSafetyController.Alarms.xAlrPrinter AND gLine.Inputs.xPrinterPowered); //96VDC Powersupplies inhibit signal
	Pdc_X20DOF322_025.DOutput[10] := NOT (gLine.Outputs.ExternalDevices[7].xClose AND gCuringLed[iIndexWhiteCuringLedBar].Signals.Outputs.xPowerOnLamps AND NOT gSafetyController.Alarms.xAlrPrinter AND gLine.Inputs.xPrinterPowered); //96VDC Powersupplies inhibit signal
	Pdc_X20DOF322_025.DOutput[11] := NOT (gLine.Outputs.ExternalDevices[7].xClose AND gCuringLed[iIndexPrimerCuringLedBar].Signals.Outputs.xPowerOnLamps AND NOT gSafetyController.Alarms.xAlrPrinter AND gLine.Inputs.xPrinterPowered); //96VDC Powersupplies inhibit signal
	

	
	// SI UNIT BK1 PNEUMATIC DIAGRAM V03	
	SiUnitPwrLnkBK1.Output01_16.0 := 	gBlockOutputs[1].xTrayIn; //1A
	SiUnitPwrLnkBK1.Output01_16.1 := 	gBlockOutputs[1].xTrayOut; //1B
	SiUnitPwrLnkBK1.Output01_16.2 := 	gMachine.commands.CleanBelt.xCleanBeltPump OR
										gCuringLed[iIndexWhiteCuringLedBar].Signals.Outputs.xPowerOnNitrogen OR
										gCuringLed[iIndexColorCuringLedBar].Signals.Outputs.xPowerOnNitrogen OR
										gCuringLed[iIndexPrimerCuringLedBar].Signals.Outputs.xPowerOnNitrogen; //2A //[RGP] This EV has different purposes in UV and Water
	SiUnitPwrLnkBK1.Output01_16.3 := 	gBlockOutputs[1].xVenturi; //2B
	SiUnitPwrLnkBK1.Output01_16.4 := 	gBlockOutputs[1].xCleaningWaterPump; //3A
	SiUnitPwrLnkBK1.Output01_16.5 := 	gMachine.commands.CleanBelt.xPistonFlojet;  //4A
	SiUnitPwrLnkBK1.Output01_16.6 := 	FALSE; //5A
	SiUnitPwrLnkBK1.Output01_16.7 := 	gBlockOutputs[1].xCappingWaterPump OR gBlockOutputs[1].xWastedInkTankPump; //6A
	
	//Vacuum
	SiUnitPwrLnkBK1.Output01_16.10 := gTransVacuum[1].Outputs.VacuumValves.0; //8A
	SiUnitPwrLnkBK1.Output01_16.11 := gTransVacuum[1].Outputs.VacuumValves.1; //8B
	SiUnitPwrLnkBK1.Output01_16.12 := gTransVacuum[1].Outputs.VacuumValves.2; //9A
	SiUnitPwrLnkBK1.Output01_16.13 := gTransVacuum[1].Outputs.VacuumValves.3; //9B
	SiUnitPwrLnkBK1.Output01_16.14 := gTransVacuum[1].Outputs.VacuumValves.4; //10A
	SiUnitPwrLnkBK1.Output01_16.15 := gTransVacuum[1].Outputs.VacuumValves.5; //10B	
	SiUnitPwrLnkBK1.Output17_32.0 := gTransVacuum[1].Outputs.VacuumValves.6; //11A
	SiUnitPwrLnkBK1.Output17_32.1 := gTransVacuum[1].Outputs.VacuumValves.7; //11B
	SiUnitPwrLnkBK1.Output17_32.2 := gTransVacuum[1].Outputs.VacuumValves.8; //12A
	SiUnitPwrLnkBK1.Output17_32.3 := gTransVacuum[1].Outputs.VacuumValves.9; //12B
	SiUnitPwrLnkBK1.Output17_32.4 := gTransVacuum[1].Outputs.VacuumValves.10; //13A
	SiUnitPwrLnkBK1.Output17_32.5 := gTransVacuum[1].Outputs.VacuumValves.11; //13B
	SiUnitPwrLnkBK1.Output17_32.6 := gTransVacuum[1].Outputs.VacuumValves.12; //14A
	SiUnitPwrLnkBK1.Output17_32.7 := gTransVacuum[1].Outputs.VacuumValves.13; //14B
	SiUnitPwrLnkBK1.Output17_32.8 := gTransVacuum[1].Outputs.VacuumValves.14; //15A
	SiUnitPwrLnkBK1.Output17_32.9 := gTransVacuum[1].Outputs.VacuumValves.15; //15B
	SiUnitPwrLnkBK1.Output17_32.10 := gTransVacuum[1].Outputs.VacuumValves.16; //16A
	SiUnitPwrLnkBK1.Output17_32.11 := gTransVacuum[1].Outputs.VacuumValves.17; //16B
	
END_ACTION
