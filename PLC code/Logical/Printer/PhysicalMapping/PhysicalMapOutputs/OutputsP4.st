
ACTION OutputsP4:

(*CABINET 01*)		
	// X3 PLC	
	X3.DOutput[1]:= gMachine.Out.xAirSupply;
	X3.DOutput[2]:= FALSE;
	X3.DOutput[3]:= FALSE;
	X3.DOutput[4]:= FALSE;
	
	X3.DOutput[8]:= FALSE;
	X3.DOutput[9]:= FALSE;
	X3.DOutput[10]:= FALSE;
	X3.DOutput[11]:= FALSE;
	X3.DOutput[12]:= FALSE;
	
	
	
	// X20DOF322_001	
	X20DOF322_001.DOutput[1]:= gMachine.Out.xPC1Start;	
	X20DOF322_001.DOutput[2]:= gMachine.Out.xPC2Start;	
	X20DOF322_001.DOutput[3]:= gMachine.Out.xGreenLight;
	X20DOF322_001.DOutput[4]:= gMachine.Out.xBuzzerButtonPanel;
	X20DOF322_001.DOutput[5]:= gMachine.Out.xResetRouter;	
	X20DOF322_001.DOutput[6]:= gMachine.Out.xResetCB1;		
	X20DOF322_001.DOutput[7]:= gMachine.Out.xResetCB2;		
	X20DOF322_001.DOutput[8]:= gMachine.Out.xConsentL1;
	X20DOF322_001.DOutput[9]:= gMachine.Out.xConsentL2;
	X20DOF322_001.DOutput[10]:= gMachine.Out.xCompenserLine1;
	X20DOF322_001.DOutput[11]:= gMachine.Out.xCompenserLine2;	
	X20DOF322_001.DOutput[12]:= gMachine.Out.xYellowLight; 
	X20DOF322_001.DOutput[13]:= gMachine.Out.xRedLight;	
	X20DOF322_001.DOutput[14]:= gMachine.Out.xLine1ReadyToClean;	
	X20DOF322_001.DOutput[15]:= gMachine.Out.xLine2ReadyToClean;	
	X20DOF322_001.DOutput[16]:= gMachine.Out.xSuctionTurbine;
	
	
	// X20DOF322_004	
	X20DOF322_004.DOutput[1]:= gMachine.Out.xLightReset;
	X20DOF322_004.DOutput[2]:= FALSE;	
	X20DOF322_004.DOutput[3]:= FALSE;
	X20DOF322_004.DOutput[4]:= FALSE;
	X20DOF322_004.DOutput[5]:= FALSE;	
	X20DOF322_004.DOutput[6]:= FALSE;	
	X20DOF322_004.DOutput[7]:= FALSE;		
	X20DOF322_004.DOutput[8]:= FALSE;
	X20DOF322_004.DOutput[9]:= FALSE;
	X20DOF322_004.DOutput[10]:= FALSE;
	X20DOF322_004.DOutput[11]:= FALSE;	
	X20DOF322_004.DOutput[12]:= FALSE;
	X20DOF322_004.DOutput[13]:= FALSE;
	//02-23-2018 changed these outputs a common, Electrical changes in common to work with it
	X20DOF322_004.DOutput[14]:= gBlockOutputs[1].xEnableDobleShot OR gBlockOutputs[2].xEnableDobleShot;
	X20DOF322_004.DOutput[15]:= gBlockOutputs[1].xShotLine1 OR gBlockOutputs[2].xShotLine1;
	X20DOF322_004.DOutput[16]:= gBlockOutputs[1].xShotLine2 OR gBlockOutputs[2].xShotLine2;

	
	// X20AI2636_005
	X20AI2636_005.DOutput[1] := gDing.Out.xReset;;  // Reset the target fault
	
	
	// X20SLX402_006
	// Enable safety transport
	X20SLX402_006.DOutput[1]:= (NOT gMachine.In.Buttons.xZero) OR (gMachine.St.Mode.xAuto OR gMachine.St.Mode.xManual); 
	
	(*CABINET 02*)
	
	// X20DOF322_106	 PRINTHEAD  AND RESISTORS POWER from 1 to 6 bars
	X20DOF322_106.DOutput[1]:= gInksOutputs[6].xOutPowPrintHead;
	X20DOF322_106.DOutput[2]:= gInksOutputs[5].xOutPowPrintHead;
	X20DOF322_106.DOutput[3]:= gInksOutputs[4].xOutPowPrintHead;
	X20DOF322_106.DOutput[4]:= gInksOutputs[3].xOutPowPrintHead;
	X20DOF322_106.DOutput[5]:= gInksOutputs[2].xOutPowPrintHead;
	X20DOF322_106.DOutput[6]:= gInksOutputs[1].xOutPowPrintHead;
	X20DOF322_106.DOutput[7]:= gInksOutputs[6].xOutBarResistance;	
	X20DOF322_106.DOutput[8]:= gInksOutputs[5].xOutBarResistance;
	X20DOF322_106.DOutput[9]:= gInksOutputs[4].xOutBarResistance;
	X20DOF322_106.DOutput[10]:= gInksOutputs[3].xOutBarResistance;
	X20DOF322_106.DOutput[11]:= gInksOutputs[2].xOutBarResistance;
	X20DOF322_106.DOutput[12]:= gInksOutputs[1].xOutBarResistance;
	X20DOF322_106.DOutput[13]:= gInksOutputs[6].xOutResistanceTank;
	X20DOF322_106.DOutput[14]:= gInksOutputs[5].xOutResistanceTank;	
	X20DOF322_106.DOutput[15]:= gInksOutputs[4].xOutResistanceTank;	
	X20DOF322_106.DOutput[16]:= FALSE;
					

	
	// X20DOF322_107 	xSolenoid1 and xSolenoid2 from 1 to 6 bars
	X20DOF322_107.DOutput[1]:=  gInksOutputs[6].xSolenoid1;
	X20DOF322_107.DOutput[2]:=  gInksOutputs[6].xSolenoid2;	
	X20DOF322_107.DOutput[3]:=  gInksOutputs[5].xSolenoid1;
	X20DOF322_107.DOutput[4]:=  gInksOutputs[5].xSolenoid2;
	X20DOF322_107.DOutput[5]:=  gInksOutputs[4].xSolenoid1;	
	X20DOF322_107.DOutput[6]:=  gInksOutputs[4].xSolenoid2;	
	X20DOF322_107.DOutput[7]:=  gInksOutputs[3].xSolenoid1;		
	X20DOF322_107.DOutput[8]:=  gInksOutputs[3].xSolenoid2;
	X20DOF322_107.DOutput[9]:=  gInksOutputs[2].xSolenoid1;
	X20DOF322_107.DOutput[10]:= gInksOutputs[2].xSolenoid2;
	X20DOF322_107.DOutput[11]:= gInksOutputs[1].xSolenoid1;	
	X20DOF322_107.DOutput[12]:= gInksOutputs[1].xSolenoid2;
	X20DOF322_107.DOutput[13]:= gInksOutputs[3].xOutResistanceTank;
	X20DOF322_107.DOutput[14]:= gInksOutputs[2].xOutResistanceTank;	
	X20DOF322_107.DOutput[15]:= gInksOutputs[1].xOutResistanceTank;	
	X20DOF322_107.DOutput[16]:= FALSE;
	
		
	// X20DOF322_108						// Enable curtain is not connected here because was changed by EE team
	X20DOF322_108.DOutput[1]:= FALSE; 	//gBlockOutputs[1].xEnableCurtain; 
	X20DOF322_108.DOutput[2]:= FALSE;
	X20DOF322_108.DOutput[3]:= gInksOutputs[6].xReliefValve; // SEIKO L relief valve BAR A
	X20DOF322_108.DOutput[4]:= gInksOutputs[5].xReliefValve; // SEIKO L relief valve BAR B XXXXXXXXXXXXXXXXXXXXXXXXX
	X20DOF322_108.DOutput[5]:= gInksOutputs[4].xReliefValve; // SEIKO L relief valve BAR C
	X20DOF322_108.DOutput[6]:= gInksOutputs[3].xReliefValve; // SEIKO L relief valve BAR D
	X20DOF322_108.DOutput[7]:= gInksOutputs[2].xReliefValve; // SEIKO L relief valve BAR E OOOOOOOOOOOOOOOOOOOOOOOOOO
	X20DOF322_108.DOutput[8]:= gInksOutputs[1].xReliefValve; // SEIKO L relief valve BAR F
	X20DOF322_108.DOutput[9]:= FALSE;
	X20DOF322_108.DOutput[10]:= FALSE;
	X20DOF322_108.DOutput[11]:= FALSE;	
	X20DOF322_108.DOutput[12]:= FALSE;
	X20DOF322_108.DOutput[13]:= FALSE;
	//02-23-2018 changed these outputs a common, for that now are these outputs are always false in block
	//	X20DOF322_108.DOutput[14]:= gBlockOutputs[1].xShotLine1;		
	//	X20DOF322_108.DOutput[15]:= gBlockOutputs[1].xShotLine2;	
	//	X20DOF322_108.DOutput[16]:= gBlockOutputs[1].xEnableDobleShot;
	X20DOF322_108.DOutput[14]:= FALSE;
	X20DOF322_108.DOutput[15]:= FALSE;
	X20DOF322_108.DOutput[16]:= FALSE;
		
				
	// X20AO4622_111 	(*  BAR F *) 	(*  BAR E *)
	X20AO4622_111.AOutput[1]:= gInksOutputs[6].iDutyCycleNegative;
	X20AO4622_111.AOutput[2]:= gInksOutputs[6].iDutyCycleFilling;
	X20AO4622_111.AOutput[3]:= gInksOutputs[5].iDutyCycleNegative;
	X20AO4622_111.AOutput[4]:= gInksOutputs[5].iDutyCycleFilling;


	// X20AO4622_112	 (*  BAR D *)	 (*  BAR C *)
	X20AO4622_112.AOutput[1]:= gInksOutputs[4].iDutyCycleNegative;
	X20AO4622_112.AOutput[2]:= gInksOutputs[4].iDutyCycleFilling;
	X20AO4622_112.AOutput[3]:= gInksOutputs[3].iDutyCycleNegative;
	X20AO4622_112.AOutput[4]:= gInksOutputs[3].iDutyCycleFilling;
	
	// X20AO4622_113	 (*  BAR B *)	 (*  BAR A *)
	X20AO4622_113.AOutput[1]:= gInksOutputs[2].iDutyCycleNegative;
	X20AO4622_113.AOutput[2]:= gInksOutputs[2].iDutyCycleFilling;
	X20AO4622_113.AOutput[3]:= gInksOutputs[1].iDutyCycleNegative;
	X20AO4622_113.AOutput[4]:= gInksOutputs[1].iDutyCycleFilling;		

	// X20SO2110_118
	X20SO2110_118.DOutput[1]:=gBlockOutputs[1].xEnableDrive;
	X20SO2110_118.DOutput[2]:=gBlockOutputs[1].xEnableIclaSI;
	
	// SI UNIT BK1	
	SiUnitBK1.Output01_08.0	:= gBlockOutputs[1].xTrayIn;
	SiUnitBK1.Output01_08.1	:= gBlockOutputs[1].xTrayOut;
	SiUnitBK1.Output01_08.2	:= gMachine.commands.CleanBelt.xCleanBeltPump;
	SiUnitBK1.Output01_08.3	:= gBlockOutputs[1].xVenturi;
	SiUnitBK1.Output01_08.4	:= gMachine.commands.CleanBelt.xPistonFlojet;
	SiUnitBK1.Output01_08.5	:= gBlockOutputs[1].xCleaningWaterPump;
	
	
	
	
	(*CABINET 03*)
	
	// X20DOF322_206 PRINTHEAD  AND RESISTORS POWER from 7 to 12 bars
	X20DOF322_206.DOutput[1]:= gInksOutputs[12].xOutPowPrintHead;
	X20DOF322_206.DOutput[2]:= gInksOutputs[11].xOutPowPrintHead;
	X20DOF322_206.DOutput[3]:= gInksOutputs[10].xOutPowPrintHead;
	X20DOF322_206.DOutput[4]:= gInksOutputs[9].xOutPowPrintHead;
	X20DOF322_206.DOutput[5]:= gInksOutputs[8].xOutPowPrintHead;
	X20DOF322_206.DOutput[6]:= gInksOutputs[7].xOutPowPrintHead;
	X20DOF322_206.DOutput[7]:= gInksOutputs[12].xOutBarResistance;	
	X20DOF322_206.DOutput[8]:= gInksOutputs[11].xOutBarResistance;
	X20DOF322_206.DOutput[9]:= gInksOutputs[10].xOutBarResistance;
	X20DOF322_206.DOutput[10]:= gInksOutputs[9].xOutBarResistance;
	X20DOF322_206.DOutput[11]:= gInksOutputs[8].xOutBarResistance;
	X20DOF322_206.DOutput[12]:= gInksOutputs[7].xOutBarResistance;
	X20DOF322_206.DOutput[13]:= gInksOutputs[12].xOutResistanceTank;
	X20DOF322_206.DOutput[14]:= gInksOutputs[11].xOutResistanceTank;	
	X20DOF322_206.DOutput[15]:= gInksOutputs[10].xOutResistanceTank;	
	X20DOF322_206.DOutput[16]:= FALSE;				


	
	// X20DOF322_207	
	X20DOF322_207.DOutput[1]:= gInksOutputs[12].xSolenoid1;
	X20DOF322_207.DOutput[2]:= gInksOutputs[12].xSolenoid2;	
	X20DOF322_207.DOutput[3]:= gInksOutputs[11].xSolenoid1;
	X20DOF322_207.DOutput[4]:= gInksOutputs[11].xSolenoid2;
	X20DOF322_207.DOutput[5]:= gInksOutputs[10].xSolenoid1;	
	X20DOF322_207.DOutput[6]:= gInksOutputs[10].xSolenoid2;	
	X20DOF322_207.DOutput[7]:= gInksOutputs[9].xSolenoid1;		
	X20DOF322_207.DOutput[8]:= gInksOutputs[9].xSolenoid2;
	X20DOF322_207.DOutput[9]:= gInksOutputs[8].xSolenoid1;
	X20DOF322_207.DOutput[10]:= gInksOutputs[8].xSolenoid2;
	X20DOF322_207.DOutput[11]:= gInksOutputs[7].xSolenoid1;
	X20DOF322_207.DOutput[12]:= gInksOutputs[7].xSolenoid2;
	X20DOF322_207.DOutput[13]:= gInksOutputs[9].xOutResistanceTank;
	X20DOF322_207.DOutput[14]:= gInksOutputs[8].xOutResistanceTank;	
	X20DOF322_207.DOutput[15]:= gInksOutputs[7].xOutResistanceTank;	
	X20DOF322_207.DOutput[16]:= FALSE;
	
	// X20DOF322_208						// Enable curtain is not connected here because was changed by EE team
	X20DOF322_208.DOutput[1]:= FALSE; 	//gBlockOutputs[2].xEnableCurtain; 
	X20DOF322_208.DOutput[2]:= FALSE;
	X20DOF322_208.DOutput[3]:= gInksOutputs[12].xReliefValve; // SEIKO L relief valve BAR G
	X20DOF322_208.DOutput[4]:= gInksOutputs[11].xReliefValve; // SEIKO L relief valve BAR H
	X20DOF322_208.DOutput[5]:= gInksOutputs[10].xReliefValve; // SEIKO L relief valve BAR I
	X20DOF322_208.DOutput[6]:= gInksOutputs[9].xReliefValve;  // SEIKO L relief valve BAR K
	X20DOF322_208.DOutput[7]:= gInksOutputs[8].xReliefValve;  // SEIKO L relief valve BAR K
	X20DOF322_208.DOutput[8]:= gInksOutputs[7].xReliefValve;  // SEIKO L relief valve BAR L
	X20DOF322_208.DOutput[9]:= FALSE;
	X20DOF322_208.DOutput[10]:= FALSE;
	X20DOF322_208.DOutput[11]:= FALSE;	
	X20DOF322_208.DOutput[12]:= FALSE;
	X20DOF322_208.DOutput[13]:= FALSE;
	//02-23-2018 changed these outputs a common, for that now are these outputs are always false in block
	//	X20DOF322_208.DOutput[14]:= gBlockOutputs[2].xShotLine1;		
	//	X20DOF322_208.DOutput[15]:= gBlockOutputs[2].xShotLine2;	
	//	X20DOF322_208.DOutput[16]:= gBlockOutputs[2].xEnableDobleShot;
	X20DOF322_208.DOutput[14]:= FALSE;
	X20DOF322_208.DOutput[15]:= FALSE;
	X20DOF322_208.DOutput[16]:= FALSE;
		
	
	// X20AO4622_211
	X20AO4622_211.AOutput[1] 	:= gInksOutputs[12].iDutyCycleNegative;
	X20AO4622_211.AOutput[2] 	:= gInksOutputs[12].iDutyCycleFilling;	
	X20AO4622_211.AOutput[3] 	:= gInksOutputs[11].iDutyCycleNegative;
	X20AO4622_211.AOutput[4] 	:= gInksOutputs[11].iDutyCycleFilling;
	//BAR PUMP
	
	
	// X20AO4622_212	
	X20AO4622_212.AOutput[1] 	:= gInksOutputs[10].iDutyCycleNegative;
	X20AO4622_212.AOutput[2] 	:= gInksOutputs[10].iDutyCycleFilling;
	X20AO4622_212.AOutput[3] 	:= gInksOutputs[9].iDutyCycleNegative;
	X20AO4622_212.AOutput[4] 	:= gInksOutputs[9].iDutyCycleFilling;
	
	// X20AO4622_213
	X20AO4622_213.AOutput[1] 	:= gInksOutputs[8].iDutyCycleNegative;
	X20AO4622_213.AOutput[2] 	:= gInksOutputs[8].iDutyCycleFilling;
	X20AO4622_213.AOutput[3] 	:= gInksOutputs[7].iDutyCycleNegative;
	X20AO4622_213.AOutput[4] 	:= gInksOutputs[7].iDutyCycleFilling;
	
	// X20SO2110_218
	X20SO2110_218.DOutput[1]:=gBlockOutputs[2].xEnableDrive;
	X20SO2110_218.DOutput[2]:=gBlockOutputs[2].xEnableIclaSI;
	
	// SI UNIT BK2	
	SiUnitBK2.Output01_08.0:= gBlockOutputs[2].xTrayIn;
	SiUnitBK2.Output01_08.1:= gBlockOutputs[2].xTrayOut;
	SiUnitBK2.Output01_08.2:= gMachine.commands.CleanBelt.xCleanBeltPump;
	SiUnitBK2.Output01_08.3:= gBlockOutputs[2].xVenturi;
	SiUnitBK2.Output01_08.4:= gMachine.commands.CleanBelt.xPistonFlojet;
	SiUnitBK2.Output01_08.5	:= gBlockOutputs[2].xCleaningWaterPump;

END_ACTION
