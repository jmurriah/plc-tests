
ACTION OutputsP5:
	
(*CABINET 01*)		
	
	
	//X20DOF322_009
	X20DOF322_009.DOutput[1]:=gBlockOutputs[1].xShotLine1;
	X20DOF322_009.DOutput[2]:=gBlockOutputs[1].xShotLine2;
	X20DOF322_009.DOutput[3]:=gBlockOutputs[1].xEnableDobleShot;
	X20DOF322_009.DOutput[4]:=gMachine.Out.xResetCB1;
	X20DOF322_009.DOutput[5]:=gMachine.Out.xResetRouter;
	X20DOF322_009.DOutput[6]:= FALSE;								//SPARE
	X20DOF322_009.DOutput[7]:=gMachine.Out.xAirSupply;
	X20DOF322_009.DOutput[8]:=gMachine.Out.xGreenLight;
	X20DOF322_009.DOutput[9]:=gMachine.Out.xLightReset;
	X20DOF322_009.DOutput[10]:=gMachine.Out.xBuzzerButtonPanel;
	X20DOF322_009.DOutput[11]:= TRUE;
	X20DOF322_009.DOutput[12]:= FALSE;								//SPARE
	X20DOF322_009.DOutput[13]:= FALSE;								//SPARE
	X20DOF322_009.DOutput[14]:= FALSE;								//SPARE
	X20DOF322_009.DOutput[15]:= FALSE;								//SPARE
	X20DOF322_009.DOutput[16]:= FALSE;								//SPARE
	
	// X20DOF322_010
	X20DOF322_010.DOutput[1]:= gInksOutputs[1].xOutPowPrintHead;
	X20DOF322_010.DOutput[2]:= gInksOutputs[2].xOutPowPrintHead;
	X20DOF322_010.DOutput[3]:= gInksOutputs[3].xOutPowPrintHead;
	X20DOF322_010.DOutput[4]:= gInksOutputs[4].xOutPowPrintHead;
	X20DOF322_010.DOutput[5]:= gInksOutputs[5].xOutPowPrintHead;
	X20DOF322_010.DOutput[6]:= gInksOutputs[6].xOutPowPrintHead;
	X20DOF322_010.DOutput[7]:= gInksOutputs[7].xOutPowPrintHead;
	X20DOF322_010.DOutput[8]:= gInksOutputs[8].xOutPowPrintHead;
	X20DOF322_010.DOutput[9]:= gInksOutputs[1].xOutBarResistance;
	X20DOF322_010.DOutput[10]:= gInksOutputs[2].xOutBarResistance;
	X20DOF322_010.DOutput[11]:= gInksOutputs[3].xOutBarResistance;
	X20DOF322_010.DOutput[12]:= gInksOutputs[4].xOutBarResistance;
	X20DOF322_010.DOutput[13]:= gInksOutputs[5].xOutBarResistance;
	X20DOF322_010.DOutput[14]:= gInksOutputs[6].xOutBarResistance;
	X20DOF322_010.DOutput[15]:= gInksOutputs[7].xOutBarResistance;
	X20DOF322_010.DOutput[16]:= gInksOutputs[8].xOutBarResistance;
	
	//X20DOF322_011
	X20DOF322_011.DOutput[1] := gInksOutputs[1].xSolenoid1;
	X20DOF322_011.DOutput[2] := gInksOutputs[2].xSolenoid1;
	X20DOF322_011.DOutput[3] := gInksOutputs[1].xSolenoid2;
	X20DOF322_011.DOutput[4] := gInksOutputs[2].xSolenoid2;
	X20DOF322_011.DOutput[5] := gInksOutputs[3].xSolenoid1;
	X20DOF322_011.DOutput[6] := gInksOutputs[4].xSolenoid1;
	X20DOF322_011.DOutput[7] := gInksOutputs[3].xSolenoid2;
	X20DOF322_011.DOutput[8] := gInksOutputs[4].xSolenoid2;
	X20DOF322_011.DOutput[9] := gInksOutputs[5].xSolenoid1;
	X20DOF322_011.DOutput[10] := gInksOutputs[6].xSolenoid1;
	X20DOF322_011.DOutput[11] := gInksOutputs[5].xSolenoid2;
	X20DOF322_011.DOutput[12] := gInksOutputs[6].xSolenoid2;
	X20DOF322_011.DOutput[13] := gInksOutputs[7].xSolenoid1;
	X20DOF322_011.DOutput[14] := gInksOutputs[8].xSolenoid1;
	X20DOF322_011.DOutput[15] := gInksOutputs[7].xSolenoid2;
	X20DOF322_011.DOutput[16] := gInksOutputs[8].xSolenoid2;

	//X20DOF322_012
	X20DOF322_012.DOutput[1]:=gInksOutputs[1].xReliefValve;
	X20DOF322_012.DOutput[2]:=gInksOutputs[2].xReliefValve;
	X20DOF322_012.DOutput[3]:=gInksOutputs[3].xReliefValve;
	X20DOF322_012.DOutput[4]:=gInksOutputs[4].xReliefValve;
	X20DOF322_012.DOutput[5]:=gInksOutputs[5].xReliefValve;
	X20DOF322_012.DOutput[6]:=gInksOutputs[6].xReliefValve;
	X20DOF322_012.DOutput[7]:=gInksOutputs[7].xReliefValve;
	X20DOF322_012.DOutput[8]:=gInksOutputs[8].xReliefValve;
	X20DOF322_012.DOutput[9]:= FALSE;								//SPARE
	X20DOF322_012.DOutput[10]:=FALSE;								//SPARE
	X20DOF322_012.DOutput[11]:=FALSE;								//SPARE
	X20DOF322_012.DOutput[12]:=FALSE;								//SPARE
	X20DOF322_012.DOutput[13]:=FALSE;								//SPARE
	X20DOF322_012.DOutput[14]:=FALSE;								//SPARE
	X20DOF322_012.DOutput[15]:=FALSE;								//SPARE
	X20DOF322_012.DOutput[16]:=FALSE;								//SPARE
	
	//X20DOF322_013
	X20DOF322_013.DOutput[1]:=gMachine.Out.xConsentL1;
	X20DOF322_013.DOutput[2]:=gMachine.Out.xConsentL2;
	X20DOF322_013.DOutput[3]:=gMachine.Out.xCompenserLine1;
	X20DOF322_013.DOutput[4]:=gMachine.Out.xCompenserLine2;
	X20DOF322_013.DOutput[5]:=gMachine.Out.xYellowLight;
	X20DOF322_013.DOutput[6]:=gMachine.Out.xRedLight;
	X20DOF322_013.DOutput[7]:=gMachine.Out.xLine1ReadyToClean;
	X20DOF322_013.DOutput[8]:=gMachine.Out.xLine2ReadyToClean;
	X20DOF322_013.DOutput[9]:=gMachine.Out.xSuctionTurbine;
	X20DOF322_013.DOutput[10]:= gJamDetect[1].Outputs.xJamTestSignal[1] OR gJamDetect[2].Outputs.xJamTestSignal[1];
	X20DOF322_013.DOutput[11]:=gJamDetect[1].Outputs.xJamTestSignal[2] OR gJamDetect[2].Outputs.xJamTestSignal[2];
	X20DOF322_013.DOutput[12]:=gJamDetect[1].Outputs.xJamTestSignal[3] OR gJamDetect[2].Outputs.xJamTestSignal[3];
	X20DOF322_013.DOutput[13]:=gJamDetect[1].Outputs.xJamTestSignal[4] OR gJamDetect[2].Outputs.xJamTestSignal[4];
	X20DOF322_013.DOutput[14]:= FALSE;								//SPARE
	X20DOF322_013.DOutput[15]:= FALSE;								//SPARE
	X20DOF322_013.DOutput[16]:= FALSE;								//SPARE

	// X20AO4622_017 	(*  BAR A *) 	(*  BAR B *)
	X20AO4622_017.AOutput[1]:= gInksOutputs[1].iDutyCycleNegative;
	X20AO4622_017.AOutput[2]:= gInksOutputs[2].iDutyCycleNegative;
	X20AO4622_017.AOutput[3]:= gInksOutputs[1].iDutyCycleFilling;
	X20AO4622_017.AOutput[4]:= gInksOutputs[2].iDutyCycleFilling;
	
	// X20AO4622_018 	(*  BAR C *) 	(*  BAR D *)
	X20AO4622_018.AOutput[1]:= gInksOutputs[3].iDutyCycleNegative;
	X20AO4622_018.AOutput[2]:= gInksOutputs[4].iDutyCycleNegative;
	X20AO4622_018.AOutput[3]:= gInksOutputs[3].iDutyCycleFilling;
	X20AO4622_018.AOutput[4]:= gInksOutputs[4].iDutyCycleFilling;
	
	// X20AO4622_019 	(*  BAR E *) 	(*  BAR F *)
	X20AO4622_019.AOutput[1]:= gInksOutputs[5].iDutyCycleNegative;
	X20AO4622_019.AOutput[2]:= gInksOutputs[6].iDutyCycleNegative;
	X20AO4622_019.AOutput[3]:= gInksOutputs[5].iDutyCycleFilling;
	X20AO4622_019.AOutput[4]:= gInksOutputs[6].iDutyCycleFilling;
	
	// X20AO4622_020 	(*  BAR G *) 	(*  BAR H *)
	X20AO4622_020.AOutput[1]:= gInksOutputs[7].iDutyCycleNegative;
	X20AO4622_020.AOutput[2]:= gInksOutputs[8].iDutyCycleNegative;
	X20AO4622_020.AOutput[3]:= gInksOutputs[7].iDutyCycleFilling;
	X20AO4622_020.AOutput[4]:= gInksOutputs[8].iDutyCycleFilling;
	
	// X20AO4622_100 THICKNESS SENSOR RESET
	X20AI2636_100.DOutput[1] := gDing.Out.xReset;;  // Reset the target fault

	// SI UNIT BK1	
	SiUnitPwrLnkBK1.Output01_16.0 := gBlockOutputs[1].xTrayIn;
	SiUnitPwrLnkBK1.Output01_16.1 := gBlockOutputs[1].xTrayOut;
	SiUnitPwrLnkBK1.Output01_16.2 := gMachine.commands.CleanBelt.xCleanBeltPump;
	SiUnitPwrLnkBK1.Output01_16.3 := gBlockOutputs[1].xVenturi;
	SiUnitPwrLnkBK1.Output01_16.4 := gBlockOutputs[1].xCleaningWaterPump;
	SiUnitPwrLnkBK1.Output01_16.5 := gMachine.commands.CleanBelt.xPistonFlojet;
	SiUnitPwrLnkBK1.Output01_16.6 := FALSE;
	SiUnitPwrLnkBK1.Output01_16.7 := FALSE;
	SiUnitPwrLnkBK1.Output01_16.8 := FALSE;
	SiUnitPwrLnkBK1.Output01_16.9 := FALSE;
	SiUnitPwrLnkBK1.Output01_16.10 := FALSE;
	SiUnitPwrLnkBK1.Output01_16.11 := FALSE;
	SiUnitPwrLnkBK1.Output01_16.12 := FALSE;
	SiUnitPwrLnkBK1.Output01_16.13 := FALSE;
	SiUnitPwrLnkBK1.Output01_16.14 := FALSE;
	SiUnitPwrLnkBK1.Output01_16.15 := FALSE;
	


END_ACTION
