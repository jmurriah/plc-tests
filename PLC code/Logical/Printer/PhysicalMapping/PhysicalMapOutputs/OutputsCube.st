
ACTION OutputsCube:
	//////////
	//PDC
	//////////
	//KE008
	Pdc_X20DOF322_005.DOutput[1] := gMachine.In.xPowerSwitch; //Belt power circuit
	Pdc_X20DOF322_005.DOutput[2] := gMachine.In.xPowerSwitch; //Block power circuit
	Pdc_X20DOF322_005.DOutput[3] := gMachine.In.xPowerSwitch; //Fans activation
	Pdc_X20DOF322_005.DOutput[4] := gMachine.In.xPowerSwitch; //Control 24Vdc
	Pdc_X20DOF322_005.DOutput[5] := gMachine.In.xPowerSwitch; //IDS 24Vdc
	Pdc_X20DOF322_005.DOutput[6] := gMachine.In.xPowerSwitch; //Load 24Vdc
	Pdc_X20DOF322_005.DOutput[7] :=  gMachine.St.Remote.xSafetyReadyToReset;
	Pdc_X20DOF322_005.DOutput[8] :=  gMachine.St.Remote.xBeltNotStopped;
	Pdc_X20DOF322_005.DOutput[9] :=  gThicknessCtrl.Outputs.xReject;
	Pdc_X20DOF322_005.DOutput[10] := gThicknessCtrl.status.Reject.xRejecting; 
	//Pdc_X20DOF322_005.DOutput[11] := ;
	//Pdc_X20DOF322_005.DOutput[12] := ;
	//Pdc_X20DOF322_005.DOutput[13] := ;
	//Pdc_X20DOF322_005.DOutput[14] := ;
	//Pdc_X20DOF322_005.DOutput[15] := ;
	//Pdc_X20DOF322_005.DOutput[16] := ;

	
	////KE010
	Pdc_X20DOF322_007.DOutput[1] := gMachine.Out.xResetHub;
	Pdc_X20DOF322_007.DOutput[2] := gMachine.Out.xResetSwitch;
	Pdc_X20DOF322_007.DOutput[3] := NOT gSafetyController.Inputs.xPrinterDoorLock; //Internal lights. ¿How shoud be controlled this?
	Pdc_X20DOF322_007.DOutput[4] := gMachine.Out.xWhiteLight;
	Pdc_X20DOF322_007.DOutput[5] := gMachine.Out.xRedLight;
	Pdc_X20DOF322_007.DOutput[6] := gMachine.Out.xGreenLight;
	Pdc_X20DOF322_007.DOutput[7] := gMachine.Out.xBlueLight;
	
	
	////KE011
	Pdc_X20DOF322_008.DOutput[1] := gInksOutputs[1].xOutPowPrintHead;
	Pdc_X20DOF322_008.DOutput[2] := gInksOutputs[2].xOutPowPrintHead;
	Pdc_X20DOF322_008.DOutput[3] := gInksOutputs[3].xOutPowPrintHead;
	Pdc_X20DOF322_008.DOutput[4] := gInksOutputs[4].xOutPowPrintHead;
	Pdc_X20DOF322_008.DOutput[5] := gInksOutputs[5].xOutPowPrintHead;
	Pdc_X20DOF322_008.DOutput[6] := gBlock[1].parSw.xEnableToPrint AND gMachine.In.xPowerSwitch;
	Pdc_X20DOF322_008.DOutput[7] := gInksOutputs[1].xOutBarResistance;
	Pdc_X20DOF322_008.DOutput[8] := gInksOutputs[2].xOutBarResistance;
	Pdc_X20DOF322_008.DOutput[9] := gInksOutputs[3].xOutBarResistance;
	Pdc_X20DOF322_008.DOutput[10] := gInksOutputs[4].xOutBarResistance;
	Pdc_X20DOF322_008.DOutput[11] := gInksOutputs[5].xOutBarResistance;
	Pdc_X20DOF322_008.DOutput[12] := gBlock[1].parSw.xEnableToPrint AND gMachine.In.xPowerSwitch;
	Pdc_X20DOF322_008.DOutput[13] := gMachine.In.xPowerSwitch;
	Pdc_X20DOF322_008.DOutput[14] := gChiller[gCuringLed[iIndexColorCuringLedBar].Parameters.iChillerIndex].Out.xStart; //gChiller[gCuringLed[iIndexColorCuringLedBar].Parameters.iChillerIndex].Out.xStart; //gCuringLed[iIndexColorCuringLedBar].Signals.Outputs.xRunChiller;
	Pdc_X20DOF322_008.DOutput[15] := gCuringLed[iIndexColorCuringLedBar].Signals.Outputs.xPowerOnLamps AND gBlockInputs[1].Safety.xSafetyOK AND gMachine.In.xPowerSwitch;
	//Pdc_X20DOF322_008.DOutput[16] := ;
	
	// Pdc_X20AI2636_050 THICKNESS SENSOR RESET
	Pdc_X20AI2636_050.DOutput[1] := gDing.Out.xReset;;  // Reset the target fault
	
	//////////
	//PRINTER
	//////////

	//gMachine.Out.xBuzzerButtonPanel ¿Donde está cableado?
	//109
//	X20DOF322_108.DOutput[1] := ;
	X20DOF322_108.DOutput[2] := gMachine.Out.xResetCB1;
	X20DOF322_108.DOutput[3] := gThicknessCtrl.Outputs.xEnableMediaSignalToCb;
	X20DOF322_108.DOutput[4] := gMachine.Out.xAirSupply;
	X20DOF322_108.DOutput[5] := gMachine.Out.xLightReset OR (gThicknessCtrl.status.MediaPosition.xMediaBelowMachine AND NOT gBelt.states.xRuningBelt AND gPLC.xBlk_100ms);

	//109
	X20DOF322_109.DOutput[1] := gJamDetect[1].Outputs.xJamTestSignal[1] OR
								gJamDetect[2].Outputs.xJamTestSignal[1];
	X20DOF322_109.DOutput[2] := gJamDetect[1].Outputs.xJamTestSignal[2] OR
								gJamDetect[2].Outputs.xJamTestSignal[2];
	X20DOF322_109.DOutput[3] := gJamDetect[1].Outputs.xJamTestSignal[3] OR
								gJamDetect[2].Outputs.xJamTestSignal[3];
	X20DOF322_109.DOutput[4] := gJamDetect[1].Outputs.xJamTestSignal[4];
	
	X20DOF322_109.DOutput[5] := gMachine.Out.xRemoteTeachL1;
	X20DOF322_109.DOutput[6] := gCuringLed[iIndexColorCuringLedBar].Lamp[1].Outputs.EnableLamp;
	X20DOF322_109.DOutput[7] := gCuringLed[iIndexColorCuringLedBar].Lamp[2].Outputs.EnableLamp;
	X20DOF322_109.DOutput[8] := gCuringLed[iIndexColorCuringLedBar].Lamp[3].Outputs.EnableLamp;


	//Analog outputs
	//115
	X20AO4622_115.AOutput[1] := gInksOutputs[1].iDutyCycleNegative;
	X20AO4622_115.AOutput[2] := gInksOutputs[2].iDutyCycleNegative;
	X20AO4622_115.AOutput[3] := gInksOutputs[1].iDutyCycleFilling;
	X20AO4622_115.AOutput[4] := gInksOutputs[2].iDutyCycleFilling;
	
	//116
	X20AO4622_116.AOutput[1] := gInksOutputs[3].iDutyCycleNegative;
	X20AO4622_116.AOutput[2] := gInksOutputs[4].iDutyCycleNegative;
	X20AO4622_116.AOutput[3] := gInksOutputs[3].iDutyCycleFilling;
	X20AO4622_116.AOutput[4] := gInksOutputs[4].iDutyCycleFilling;
	
	//117
	X20AO4622_117.AOutput[1] := gInksOutputs[5].iDutyCycleNegative;
	//X20AO4622_117.AOutput[2] := ;
	X20AO4622_117.AOutput[3] := gInksOutputs[5].iDutyCycleFilling;
	//X20AO4622_117.AOutput[4] := ;
	
	//118
	X20AO4622_118.AOutput[1] := gCuringLed[iIndexColorCuringLedBar].Lamp[1].Outputs.IntensityLampRaw;
	X20AO4622_118.AOutput[2] := gCuringLed[iIndexColorCuringLedBar].Lamp[2].Outputs.IntensityLampRaw;
	X20AO4622_118.AOutput[3] := gCuringLed[iIndexColorCuringLedBar].Lamp[3].Outputs.IntensityLampRaw;
	//X20AO4622_118.AOutput[4] := ;
	
	
	
	// SI UNIT BK1	
	SiUnitPwrLnkBK1.Output01_16.0 := 	gBlockOutputs[1].xTrayOut; //1A
	SiUnitPwrLnkBK1.Output01_16.1 := 	gBlockOutputs[1].xTrayIn; //1B
	SiUnitPwrLnkBK1.Output01_16.2 := 	gCuringLed[iIndexColorCuringLedBar].Signals.Outputs.xPowerOnNitrogen;  //2A //[RGP] This EV has different purposes in UV and Water
	SiUnitPwrLnkBK1.Output01_16.3 := 	gBlockOutputs[1].xVenturi; //2B
	SiUnitPwrLnkBK1.Output01_16.4 := 	gTransVacuum[1].Outputs.xActiveEvToEvacuateInk; //3A
	SiUnitPwrLnkBK1.Output01_16.5 := 	gBlockOutputs[1].xWastedInkTankPump;  //4A
	SiUnitPwrLnkBK1.Output01_16.6 := 	FALSE; //5A
	SiUnitPwrLnkBK1.Output01_16.7 := 	gBlockOutputs[1].xWastedInkTankPump; //6A
	
	
	//Vacuum 
//	SiUnitPwrLnkBK1.Output01_16.8 := gTransVacuum[1].Outputs.VacuumValves.0;	
//	SiUnitPwrLnkBK1.Output01_16.9 := gTransVacuum[1].Outputs.VacuumValves.1;
//	SiUnitPwrLnkBK1.Output01_16.10 := gTransVacuum[1].Outputs.VacuumValves.2;	
//	SiUnitPwrLnkBK1.Output01_16.11 := gTransVacuum[1].Outputs.VacuumValves.3;	
//	SiUnitPwrLnkBK1.Output01_16.12 := gTransVacuum[1].Outputs.VacuumValves.4;	
//	SiUnitPwrLnkBK1.Output01_16.13 := gTransVacuum[1].Outputs.VacuumValves.5;	
//	SiUnitPwrLnkBK1.Output01_16.14 := gTransVacuum[1].Outputs.VacuumValves.6;	
//	SiUnitPwrLnkBK1.Output01_16.15 := gTransVacuum[1].Outputs.VacuumValves.7;	
//	SiUnitPwrLnkBK1.Output17_32.0 := gTransVacuum[1].Outputs.VacuumValves.8;	
//	SiUnitPwrLnkBK1.Output17_32.1 := gTransVacuum[1].Outputs.VacuumValves.9;
//	SiUnitPwrLnkBK1.Output17_32.2 := gTransVacuum[1].Outputs.VacuumValves.10;
//	SiUnitPwrLnkBK1.Output17_32.3 := gTransVacuum[1].Outputs.VacuumValves.11;
//	SiUnitPwrLnkBK1.Output17_32.4 := gTransVacuum[1].Outputs.VacuumValves.12;
//	SiUnitPwrLnkBK1.Output17_32.5 := gTransVacuum[1].Outputs.VacuumValves.13;
//	SiUnitPwrLnkBK1.Output17_32.6 := gTransVacuum[1].Outputs.VacuumValves.14;
//	SiUnitPwrLnkBK1.Output17_32.7 := gTransVacuum[1].Outputs.VacuumValves.15;
//	SiUnitPwrLnkBK1.Output17_32.8 := gTransVacuum[1].Outputs.VacuumValves.16;
//	SiUnitPwrLnkBK1.Output17_32.9 := gTransVacuum[1].Outputs.VacuumValves.17;
//	SiUnitPwrLnkBK1.Output17_32.10 := gTransVacuum[1].Outputs.VacuumValves.18;
//	SiUnitPwrLnkBK1.Output17_32.11 := gTransVacuum[1].Outputs.VacuumValves.19;
	
	
	SiUnitPwrLnkBK1.Output01_16.8 := FALSE;	
	SiUnitPwrLnkBK1.Output01_16.9 := FALSE;
	SiUnitPwrLnkBK1.Output01_16.10 := FALSE;	
	SiUnitPwrLnkBK1.Output01_16.11 := FALSE;	
	SiUnitPwrLnkBK1.Output01_16.12 := FALSE;
	
	SiUnitPwrLnkBK1.Output01_16.13 := gTransVacuum[1].Outputs.VacuumValves.0; 	
	SiUnitPwrLnkBK1.Output01_16.14 := gTransVacuum[1].Outputs.VacuumValves.1;	
	SiUnitPwrLnkBK1.Output01_16.15 := gTransVacuum[1].Outputs.VacuumValves.2;	
	SiUnitPwrLnkBK1.Output17_32.0 := gTransVacuum[1].Outputs.VacuumValves.3;	
	SiUnitPwrLnkBK1.Output17_32.1 := gTransVacuum[1].Outputs.VacuumValves.4;
	SiUnitPwrLnkBK1.Output17_32.2 := gTransVacuum[1].Outputs.VacuumValves.5;
	SiUnitPwrLnkBK1.Output17_32.3 := gTransVacuum[1].Outputs.VacuumValves.6;
	SiUnitPwrLnkBK1.Output17_32.4 := gTransVacuum[1].Outputs.VacuumValves.7;
	SiUnitPwrLnkBK1.Output17_32.5 := gTransVacuum[1].Outputs.VacuumValves.8;
	SiUnitPwrLnkBK1.Output17_32.6 := gTransVacuum[1].Outputs.VacuumValves.9;
	SiUnitPwrLnkBK1.Output17_32.7 := gTransVacuum[1].Outputs.VacuumValves.10;
	SiUnitPwrLnkBK1.Output17_32.8 := gTransVacuum[1].Outputs.VacuumValves.11;
	SiUnitPwrLnkBK1.Output17_32.9 := gTransVacuum[1].Outputs.VacuumValves.12;
	SiUnitPwrLnkBK1.Output17_32.10 := gTransVacuum[1].Outputs.VacuumValves.13;
	SiUnitPwrLnkBK1.Output17_32.11 := gTransVacuum[1].Outputs.VacuumValves.14;
END_ACTION
