
ACTION OutputsNozomi2:
	
	
	//////////
	//PRINTER
	//////////
	X20DOF322_108.DOutput[1] := gBlockOutputs[1].xShotLine1;
	X20DOF322_108.DOutput[2] := gBlockOutputs[1].xShotLine2;
	X20DOF322_108.DOutput[3] := gBlockOutputs[1].xEnableDobleShot;
	X20DOF322_108.DOutput[4] := gMachine.Out.xResetCB1;
	X20DOF322_108.DOutput[5] := gMachine.Out.xResetRouter;
	X20DOF322_108.DOutput[6] := gThicknessCtrl.Outputs.xEnableMediaSignalToCb;
	X20DOF322_108.DOutput[7] := gMachine.Out.xAirSupply;
	X20DOF322_108.DOutput[8] := gLine.Outputs.xGreenLight;
	X20DOF322_108.DOutput[9] := gLine.Outputs.xLightReset OR gMachine.Out.xLightReset;;
	X20DOF322_108.DOutput[10] := gLine.Outputs.xSound OR gMachine.Out.xBuzzerButtonPanel;
	X20DOF322_108.DOutput[11] := gLine.Outputs.xSound OR gMachine.Out.xBuzzerButtonPanel;
	X20DOF322_108.DOutput[12] := gLine.Outputs.xYellowLight;
	X20DOF322_108.DOutput[13] := gLine.Outputs.xBlueLight;
	X20DOF322_108.DOutput[14] := gLine.Outputs.xRedLight;
	X20DOF322_108.DOutput[15] := gLine.Outputs.xWhiteLight;
	
 
	X20DOF322_109.DOutput[1] := gInksOutputs[1].xOutPowPrintHead;
	X20DOF322_109.DOutput[2] := gInksOutputs[2].xOutPowPrintHead;
	X20DOF322_109.DOutput[3] := gInksOutputs[3].xOutPowPrintHead;
	X20DOF322_109.DOutput[4] := gInksOutputs[4].xOutPowPrintHead;
	X20DOF322_109.DOutput[5] := gInksOutputs[5].xOutPowPrintHead;
	X20DOF322_109.DOutput[6] := gInksOutputs[6].xOutPowPrintHead;
	X20DOF322_109.DOutput[7] := gInksOutputs[7].xOutPowPrintHead;
	X20DOF322_109.DOutput[8] := gInksOutputs[8].xOutPowPrintHead;
	X20DOF322_109.DOutput[9] := gInksOutputs[1].xOutBarResistance;
	X20DOF322_109.DOutput[10] := gInksOutputs[2].xOutBarResistance;
	X20DOF322_109.DOutput[11] := gInksOutputs[3].xOutBarResistance;
	X20DOF322_109.DOutput[12] := gInksOutputs[4].xOutBarResistance;
	X20DOF322_109.DOutput[13] := gInksOutputs[5].xOutBarResistance;
	X20DOF322_109.DOutput[14] := gInksOutputs[6].xOutBarResistance;
	X20DOF322_109.DOutput[15] := gInksOutputs[7].xOutBarResistance;
	X20DOF322_109.DOutput[16] := gInksOutputs[8].xOutBarResistance;
	
	X20DOF322_110.DOutput[1] := gJamDetect[1].Outputs.xJamTestSignal[1] OR
								gJamDetect[2].Outputs.xJamTestSignal[1] OR
								gJamDetect[3].Outputs.xJamTestSignal[1];
	X20DOF322_110.DOutput[2] := gJamDetect[1].Outputs.xJamTestSignal[2] OR
								gJamDetect[2].Outputs.xJamTestSignal[2] OR
								gJamDetect[3].Outputs.xJamTestSignal[2];
	X20DOF322_110.DOutput[3] := gJamDetect[1].Outputs.xJamTestSignal[3] OR
								gJamDetect[2].Outputs.xJamTestSignal[3] OR
								gJamDetect[3].Outputs.xJamTestSignal[3];
	X20DOF322_110.DOutput[4] := gJamDetect[1].Outputs.xJamTestSignal[4] OR
								gJamDetect[2].Outputs.xJamTestSignal[4] OR
								gJamDetect[3].Outputs.xJamTestSignal[4];
	X20DOF322_110.DOutput[5] := gMachine.Out.xRemoteTeachL1;
	X20DOF322_110.DOutput[6] := gMachine.Out.xRemoteTeachL2;
	X20DOF322_110.DOutput[7] := gMachine.Out.xDegasser;

	// NOZOMITWO-2541 For advance team testing on Alpha
	IF (gMachine.Pt.MachineModel = Type_NOZ_2_AQ) THEN
		X20DOF322_110.DOutput[9] := gInks[2].signals.out.xSolenoid1;
		X20DOF322_110.DOutput[10] := gInks[2].signals.out.xSolenoid2;
		X20DOF322_110.DOutput[11] := gInks[2].signals.out.xSolenoid3;
		X20DOF322_110.DOutput[12] := gInks[2].signals.out.xSolenoid4;
	END_IF
	
	//Analog outputs
	X20AO4622_115.AOutput[1] := gInksOutputs[2].iDutyCycleNegative;
	X20AO4622_115.AOutput[2] := gInksOutputs[3].iDutyCycleNegative;
 	X20AO4622_115.AOutput[3] := gInksOutputs[2].iDutyCycleFilling;
	X20AO4622_115.AOutput[4] := gInksOutputs[3].iDutyCycleFilling;
 	X20AO4622_116.AOutput[1] := gInksOutputs[4].iDutyCycleNegative;
	X20AO4622_116.AOutput[2] := gInksOutputs[5].iDutyCycleNegative;
 	X20AO4622_116.AOutput[3] := gInksOutputs[4].iDutyCycleFilling;
	X20AO4622_116.AOutput[4] := gInksOutputs[5].iDutyCycleFilling;
	X20AO4622_117.AOutput[1] := gInksOutputs[6].iDutyCycleNegative;
	
	IF (gMachine.Pt.MachineModel = Type_NOZ_2_AQ) THEN
		X20AO4622_117.AOutput[2] := gInksOutputs[7].iDutyCycleNegative;
	ELSE
		X20AO4622_117.AOutput[2] := gInksOutputs[8].iDutyCycleNegative;
	END_IF

	X20AO4622_117.AOutput[3] := gInksOutputs[6].iDutyCycleFilling;
	
	IF (gMachine.Pt.MachineModel = Type_NOZ_2_AQ) THEN 
		X20AO4622_117.AOutput[4] := gInksOutputs[7].iDutyCycleFilling;
	ELSE
		X20AO4622_117.AOutput[4] := gInksOutputs[8].iDutyCycleFilling;
	END_IF

	
	///////////////////////////
	//UV Curing leds related
	
	//Digital outputs
	X20DOF322_155.DOutput[1] := gMachine.commands.CleanBelt.xCleanBeltMoveFwd;
	X20DOF322_155.DOutput[2] := gMachine.commands.CleanBelt.xCleanBeltMoveBwd;
	X20DOF322_155.DOutput[3] := gMachine.commands.CleanBelt.xCleanBeltResetRelay;
	X20DOF322_155.DOutput[5] := gCuringLed[iIndexColorCuringLedBar].Lamp[1].Outputs.EnableLamp;
	X20DOF322_155.DOutput[6] := gCuringLed[iIndexColorCuringLedBar].Lamp[2].Outputs.EnableLamp;
	X20DOF322_155.DOutput[7] := gCuringLed[iIndexColorCuringLedBar].Lamp[3].Outputs.EnableLamp;
	X20DOF322_155.DOutput[8] := gCuringLed[iIndexColorCuringLedBar].Lamp[4].Outputs.EnableLamp;
	X20DOF322_155.DOutput[9] := gCuringLed[iIndexWhiteCuringLedBar].Lamp[1].Outputs.EnableLamp;
	X20DOF322_155.DOutput[10] := gCuringLed[iIndexWhiteCuringLedBar].Lamp[2].Outputs.EnableLamp;
	X20DOF322_155.DOutput[11] := gCuringLed[iIndexWhiteCuringLedBar].Lamp[3].Outputs.EnableLamp;
	X20DOF322_155.DOutput[12] := gCuringLed[iIndexWhiteCuringLedBar].Lamp[4].Outputs.EnableLamp;
	X20DOF322_155.DOutput[15] := gMachine.Out.xAntiStaticPOn;
	
	//Analog outputs
	X20AO4622_157.AOutput[1] := gCuringLed[iIndexColorCuringLedBar].Lamp[1].Outputs.IntensityLampRaw;
	X20AO4622_157.AOutput[2] := gCuringLed[iIndexColorCuringLedBar].Lamp[2].Outputs.IntensityLampRaw;
	X20AO4622_157.AOutput[3] := gCuringLed[iIndexColorCuringLedBar].Lamp[3].Outputs.IntensityLampRaw;
	X20AO4622_157.AOutput[4] := gCuringLed[iIndexColorCuringLedBar].Lamp[4].Outputs.IntensityLampRaw;
	
	X20AO4622_158.AOutput[1] := gCuringLed[iIndexWhiteCuringLedBar].Lamp[1].Outputs.IntensityLampRaw;
	X20AO4622_158.AOutput[2] := gCuringLed[iIndexWhiteCuringLedBar].Lamp[2].Outputs.IntensityLampRaw;
	X20AO4622_158.AOutput[3] := gCuringLed[iIndexWhiteCuringLedBar].Lamp[3].Outputs.IntensityLampRaw;
	X20AO4622_158.AOutput[4] := gCuringLed[iIndexWhiteCuringLedBar].Lamp[4].Outputs.IntensityLampRaw;
	
	

	//////////
	//PDC
	//////////
	//Pdc_X20DOF322_008.DOutput
	Pdc_X20DOF322_008.DOutput[1] := gLine.Outputs.ExternalDevices[2].xClose;
	Pdc_X20DOF322_008.DOutput[2] := gLine.Outputs.ExternalDevices[1].xClose;
	Pdc_X20DOF322_008.DOutput[3] := gLine.Outputs.ExternalDevices[1].xOpen;
	Pdc_X20DOF322_008.DOutput[4] := gLine.Outputs.ExternalDevices[10].xClose;
	Pdc_X20DOF322_008.DOutput[5] := gLine.Outputs.ExternalDevices[10].xOpen;
	Pdc_X20DOF322_008.DOutput[6] := gLine.Outputs.ExternalDevices[0].xClose AND gMachine.In.xPowerSwitch;
	Pdc_X20DOF322_008.DOutput[7] := gLine.Outputs.ExternalDevices[6].xClose;
	Pdc_X20DOF322_008.DOutput[8] := gMachine.Out.xSuctionTurbine; //gLine.Outputs.ExternalDevices[9].xClose;
	Pdc_X20DOF322_008.DOutput[9] := gLine.Outputs.ExternalDevices[8].xClose;
	Pdc_X20DOF322_008.DOutput[10] := gLine.Outputs.ExternalDevices[7].xClose;
	Pdc_X20DOF322_008.DOutput[11] := gLine.Outputs.ExternalDevices[3].xClose;
	Pdc_X20DOF322_008.DOutput[12] := gLine.Outputs.ExternalDevices[3].xOpen;
	Pdc_X20DOF322_008.DOutput[13] := gLine.Outputs.ExternalDevices[4].xClose;
	Pdc_X20DOF322_008.DOutput[14] := gLine.Outputs.ExternalDevices[4].xOpen;
	Pdc_X20DOF322_008.DOutput[15] := gLine.Outputs.ExternalDevices[5].xClose;
	Pdc_X20DOF322_008.DOutput[16] := gMachine.Out.xResetRouter;

	
	//Pdc_X20DOF322_009
	//Pdc_X20DOF322_009.DOutput[1] := Reset Hub Powerlink PDC;
	Pdc_X20DOF322_009.DOutput[2] := gMachine.St.Remote.xSafetyReadyToReset;
	Pdc_X20DOF322_009.DOutput[3] := gLine.Outputs.Customer[1];
	Pdc_X20DOF322_009.DOutput[4] := gLine.Outputs.Customer[2];
	Pdc_X20DOF322_009.DOutput[5] := gLine.Outputs.Customer[3];
	Pdc_X20DOF322_009.DOutput[6] := gFeeder.Outputs.Physical.xPrepareToFeed;
	Pdc_X20DOF322_009.DOutput[7] := gFeeder.Outputs.Physical.xStartFeeding;
	Pdc_X20DOF322_009.DOutput[8] := gFeeder.Outputs.Physical.xFastStop;
	Pdc_X20DOF322_009.DOutput[9] := gPrimer.Outputs.Physical.xRunDryer;
	Pdc_X20DOF322_009.DOutput[10] := gPrimer.Outputs.Physical.xRunTransport;
	Pdc_X20DOF322_009.DOutput[11] := gPrimer.Outputs.Physical.xRunPriming;
	Pdc_X20DOF322_009.DOutput[12] := gPrimer.Outputs.Physical.xPrepareToPrime;
	Pdc_X20DOF322_009.DOutput[13] := gStacker.Outputs.xRun;
	Pdc_X20DOF322_009.DOutput[14] := gThicknessCtrl.Outputs.xReject; 
	Pdc_X20DOF322_009.DOutput[15] := gStacker.Outputs.xPrepareToStack;
	Pdc_X20DOF322_009.DOutput[16] := gStacker.Outputs.xEjectRejectStack;

	
	//Pdc_X20DOF322_010
	Pdc_X20DOF322_010.DOutput[1] := gStacker.Outputs.xStackEject;
	Pdc_X20DOF322_010.DOutput[2] := gLine.Outputs.ExternalDevices[5].xClose; //To review how UPS for dryer should be activated
	Pdc_X20DOF322_010.DOutput[3] := gOverVarnish.Outputs.Physical.xRunDryer;
	Pdc_X20DOF322_010.DOutput[4] := gOverVarnish.Outputs.Physical.xRunTransport;
	Pdc_X20DOF322_010.DOutput[5] := gOverVarnish.Outputs.Physical.xRunPriming;
	Pdc_X20DOF322_010.DOutput[6] := gOverVarnish.Outputs.Physical.xPrepareToPrime;
	Pdc_X20DOF322_010.DOutput[7] := gLine.Outputs.ExternalDevices[0].xClose AND gMachine.In.xPowerSwitch; 
	Pdc_X20DOF322_010.DOutput[8] := gLine.Outputs.ExternalDevices[0].xClose;
	Pdc_X20DOF322_010.DOutput[9] := gLine.Outputs.ExternalDevices[0].xClose;
	Pdc_X20DOF322_010.DOutput[10] := gBeltClean.Outputs.xAirTurbineOn; // NOZOMITWO-1912
	Pdc_X20DOF322_010.DOutput[11] := gBeltClean.Outputs.xAirTurbineVSDReset; // NOZOMITWO-1912
	Pdc_X20DOF322_010.DOutput[12] := gDryerAnc.Outputs.xRunTransport;
	(*
	Pdc_X20DOF322_010.DOutput[13] := ;
	Pdc_X20DOF322_010.DOutput[14] := ;
	Pdc_X20DOF322_010.DOutput[15] := ;
	*)
	Pdc_X20DOF322_010.DOutput[16] := gChiller[1].Out.xStart; // NOZOMITWO-2428 Only for Noz2 water, normally the start signal is a feedback of the Chiller PowerOn CB or is not needed
	
	//Line X20DOF322_023
	Pdc_X20DOF322_023.DOutput[1] := gChiller[gCuringLed[iIndexColorCuringLedBar].Parameters.iChillerIndex].Out.xStart; //gCuringLed[iIndexColorCuringLedBar].Signals.Outputs.xRunChiller;
	Pdc_X20DOF322_023.DOutput[2] := gChiller[gCuringLed[iIndexWhiteCuringLedBar].Parameters.iChillerIndex].Out.xStart; //gCuringLed[iIndexWhiteCuringLedBar].Signals.Outputs.xRunChiller;
	Pdc_X20DOF322_023.DOutput[3] := gLine.Outputs.ExternalDevices[7].xClose AND gCuringLed[iIndexColorCuringLedBar].Signals.Outputs.xPowerOnLamps AND NOT gSafetyController.Alarms.xAlrPrinter AND gLine.Inputs.xPrinterPowered; //UV leds color power
	Pdc_X20DOF322_023.DOutput[4] := gLine.Outputs.ExternalDevices[7].xClose AND gCuringLed[iIndexWhiteCuringLedBar].Signals.Outputs.xPowerOnLamps AND NOT gSafetyController.Alarms.xAlrPrinter AND gLine.Inputs.xPrinterPowered; //UV leds white power
	Pdc_X20DOF322_023.DOutput[5] := gLine.Outputs.ExternalDevices[8].xClose AND NOT gSafetyController.Alarms.xAlrPrinter; //Chiller color power
	Pdc_X20DOF322_023.DOutput[6] := gLine.Outputs.ExternalDevices[8].xClose AND NOT gSafetyController.Alarms.xAlrPrinter; //Chiller white power
	
	
	//Line X20DOF322_051
	//Pdc_X20DOF322_051.DOutput[1] := ;
	Pdc_X20DOF322_051.DOutput[1] := gSarm.Outputs.xStartTransport;
	Pdc_X20DOF322_051.DOutput[2] := gSarm.Outputs.xFastStop;
	Pdc_X20DOF322_051.DOutput[4] := gLine.Outputs.ExternalDevices[11].xClose; // DG SARM
	Pdc_X20DOF322_051.DOutput[5] := gLine.Outputs.ExternalDevices[1].xClose; // DG InfraRed Primer TecLighting
	
	// SI UNIT BK1	
	SiUnitPwrLnkBK1.Output01_16.0 := 	gBlockOutputs[1].xTrayIn; //1A
	SiUnitPwrLnkBK1.Output01_16.1 := 	gBlockOutputs[1].xTrayOut; //1B
	SiUnitPwrLnkBK1.Output01_16.2 := 	gMachine.commands.CleanBelt.xCleanBeltPump OR
										gCuringLed[1].Signals.Outputs.xPowerOnNitrogen OR
										gCuringLed[2].Signals.Outputs.xPowerOnNitrogen OR
										gBeltClean.Outputs.xPumpOn;  //2A //[RGP] This EV has different purposes in UV and Water // NOZOMITWO-1912
	SiUnitPwrLnkBK1.Output01_16.3 := 	gBlockOutputs[1].xVenturi; //2B
	//SiUnitPwrLnkBK1.Output01_16.4 :=  //3A
	SiUnitPwrLnkBK1.Output01_16.5 := 	gMachine.commands.CleanBelt.xPistonFlojet OR gBeltClean.Outputs.xRiseCleaningSystem;  //4A // NOZOMITWO-1912
	SiUnitPwrLnkBK1.Output01_16.6 := 	FALSE; //5A
	SiUnitPwrLnkBK1.Output01_16.7 := 	gBlockOutputs[1].xWastedInkTankPump; //6A
	
	//Vacuum 
	SiUnitPwrLnkBK1.Output01_16.8 := gTransVacuum[1].Outputs.VacuumValves.0;	//10A
	SiUnitPwrLnkBK1.Output01_16.9 := gTransVacuum[1].Outputs.VacuumValves.1;	//10B
	SiUnitPwrLnkBK1.Output01_16.10 := gTransVacuum[1].Outputs.VacuumValves.2;	//11A
	SiUnitPwrLnkBK1.Output01_16.11 := gTransVacuum[1].Outputs.VacuumValves.3;	//11B
	SiUnitPwrLnkBK1.Output01_16.12 := gTransVacuum[1].Outputs.VacuumValves.4;	//12A
	SiUnitPwrLnkBK1.Output01_16.13 := gTransVacuum[1].Outputs.VacuumValves.5;	//12B
	SiUnitPwrLnkBK1.Output01_16.14 := gTransVacuum[1].Outputs.VacuumValves.6;	//13A
	SiUnitPwrLnkBK1.Output01_16.15 := gTransVacuum[1].Outputs.VacuumValves.7;	//13B
	SiUnitPwrLnkBK1.Output17_32.0 := gTransVacuum[1].Outputs.VacuumValves.8;	//14A
	SiUnitPwrLnkBK1.Output17_32.1 := gTransVacuum[1].Outputs.VacuumValves.9;	//14B
	SiUnitPwrLnkBK1.Output17_32.2 := gTransVacuum[1].Outputs.VacuumValves.10;	//15A
	SiUnitPwrLnkBK1.Output17_32.3 := gTransVacuum[1].Outputs.VacuumValves.11;	//15B
	SiUnitPwrLnkBK1.Output17_32.4 := gTransVacuum[1].Outputs.VacuumValves.12;	//16A
	SiUnitPwrLnkBK1.Output17_32.5 := gTransVacuum[1].Outputs.VacuumValves.13;	//16B
	SiUnitPwrLnkBK1.Output17_32.6 := gTransVacuum[1].Outputs.VacuumValves.14;	//17A From 17A to 19B: removed, but not in old machines.
	SiUnitPwrLnkBK1.Output17_32.7 := gTransVacuum[1].Outputs.VacuumValves.15;	//17B
	SiUnitPwrLnkBK1.Output17_32.8 := gTransVacuum[1].Outputs.VacuumValves.16;	//18A
	SiUnitPwrLnkBK1.Output17_32.9 := gTransVacuum[1].Outputs.VacuumValves.17;	//18B
	SiUnitPwrLnkBK1.Output17_32.10 := gTransVacuum[1].Outputs.VacuumValves.18;	//19A
	SiUnitPwrLnkBK1.Output17_32.11 := gTransVacuum[1].Outputs.VacuumValves.19;	//19B
	
END_ACTION
