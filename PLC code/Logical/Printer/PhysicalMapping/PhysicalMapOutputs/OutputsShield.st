
ACTION OutputsShield:

	//X3 PLC	
	X3.DOutput[1]:= FALSE;
	X3.DOutput[2]:= gMachine.Out.xPC2Start;
	X3.DOutput[3]:= gMachine.Out.xResetCB1;
	X3.DOutput[4]:= gMachine.Out.xResetRouter;
	
	// X20DOF322_005	
	X20DOF322_005.DOutput[1]	:= gInksOutputs[1].xOutPowPrintHead;
	X20DOF322_005.DOutput[2]	:= gInksOutputs[2].xOutPowPrintHead;
	X20DOF322_005.DOutput[3]	:= gInksOutputs[1].xOutBarResistance;
	X20DOF322_005.DOutput[4]	:= gInksOutputs[2].xOutBarResistance;
	X20DOF322_005.DOutput[5]	:= gInksOutputs[1].xSolenoid1;
	X20DOF322_005.DOutput[6]	:= gInksOutputs[2].xSolenoid1;
	X20DOF322_005.DOutput[7]	:= gInksOutputs[1].xSolenoid2;
	X20DOF322_005.DOutput[8]	:= gInksOutputs[2].xSolenoid2;
	X20DOF322_005.DOutput[9]	:= gInksOutputs[1].xReliefValve;
	X20DOF322_005.DOutput[10]	:= gInksOutputs[2].xReliefValve;
	X20DOF322_005.DOutput[11]	:= FALSE;
	X20DOF322_005.DOutput[12]	:= gChiller[1].Out.xStart;
	X20DOF322_005.DOutput[13]	:= gMachine.Out.xCoolingPCStart;//Implement
	X20DOF322_005.DOutput[14]	:= gBlock[1].Out.xEnableDobleShot;
	X20DOF322_005.DOutput[15]	:= gBlock[1].Out.xShotLine1;
	X20DOF322_005.DOutput[16]	:= gBlock[1].Out.xShotLine2;

	// X20DOF322_006
	X20DOF322_006.DOutput[1]	:= gMachine.Out.xConsentL1;
	X20DOF322_006.DOutput[2]	:= gMachine.Out.xConsentL2;
	X20DOF322_006.DOutput[3]	:= gMachine.Out.xCompenserLine1;
	X20DOF322_006.DOutput[4]	:= gMachine.Out.xCompenserLine2;
	X20DOF322_006.DOutput[5]	:= gMachine.Out.xYellowLight;
	X20DOF322_006.DOutput[6]	:= gMachine.Out.xRedLight;
	X20DOF322_006.DOutput[7]	:= gMachine.Out.xLine1ReadyToClean;
	X20DOF322_006.DOutput[8]	:= gMachine.Out.xLine2ReadyToClean;
	X20DOF322_006.DOutput[9]	:= gMachine.Out.xSuctionTurbine;
	X20DOF322_006.DOutput[10]	:= FALSE;
	X20DOF322_006.DOutput[11]	:= FALSE;
	X20DOF322_006.DOutput[12]	:= TRUE; 
	X20DOF322_006.DOutput[13]	:= gMachine.Out.xAirSupply;
	X20DOF322_006.DOutput[14]	:= gMachine.Out.xGreenLight;
	X20DOF322_006.DOutput[15]	:= gMachine.Out.xLightReset;
	X20DOF322_006.DOutput[16]	:= gMachine.Out.xBuzzerButtonPanel;
	
	// SI UNIT BK1	
	SiUnitBK1.Output01_08.0		:= gBlockOutputs[1].xTrayIn;
	SiUnitBK1.Output01_08.1		:= gBlockOutputs[1].xTrayOut;
	SiUnitBK1.Output01_08.2		:= gMachine.commands.CleanBelt.xCleanBeltPump;
	SiUnitBK1.Output01_08.3		:= gBlockOutputs[1].xVenturi;
	SiUnitBK1.Output01_08.4		:= gMachine.commands.CleanBelt.xPistonFlojet;
	SiUnitBK1.Output01_08.5		:= gBlockOutputs[1].xCleaningWaterPump;
	
	// X20AO4622_009	 (*  BAR A *)	 (*  BAR B *)
	X20AO4622_009.AOutput[1]:= gInksOutputs[1].iDutyCycleNegative;
	X20AO4622_009.AOutput[2]:= gInksOutputs[2].iDutyCycleNegative;
	X20AO4622_009.AOutput[3]:= gInksOutputs[1].iDutyCycleFilling;
	X20AO4622_009.AOutput[4]:= gInksOutputs[2].iDutyCycleFilling;
	
END_ACTION