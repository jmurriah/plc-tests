
ACTION OutputsInkBox:

	// GROUP _10x
	//X20DOF322_104.DOutput[1] := gInks[1].signals.out.xOutBarResistance;
	X20DOF322_104.DOutput[3] := gInks[1].signals.out.xOutBarResistance;
	X20DOF322_104.DOutput[5] := gInks[1].signals.out.xOutPowPrintHead;
	X20DOF322_104.DOutput[7] := gInks[1].signals.out.xReliefValve;

	//X20DOF322_104.DOutput[2] := gInks[2].signals.out.xOutBarResistance;
	X20DOF322_104.DOutput[4] := gInks[2].signals.out.xOutBarResistance;
	X20DOF322_104.DOutput[6] := gInks[2].signals.out.xOutPowPrintHead;
	X20DOF322_104.DOutput[8] := gInks[2].signals.out.xReliefValve;

	X20AO4622_105.AOutput[1] := gInks[1].signals.out.iDutyCycleNegative;
	X20AO4622_105.AOutput[3] := gInks[1].signals.out.iDutyCycleFilling;
	
	X20AO4622_105.AOutput[2] := gInks[2].signals.out.iDutyCycleNegative;
	X20AO4622_105.AOutput[4] := gInks[2].signals.out.iDutyCycleFilling;

	
	// GROUP _20x
	//X20DOF322_204.DOutput[1] := gInks[3].signals.out.xOutBarResistance;
	X20DOF322_204.DOutput[3] := gInks[3].signals.out.xOutBarResistance;
	X20DOF322_204.DOutput[5] := gInks[3].signals.out.xOutPowPrintHead;
	X20DOF322_204.DOutput[7] := gInks[3].signals.out.xReliefValve;

	//X20DOF322_204.DOutput[2] := gInks[4].signals.out.xOutBarResistance;
	X20DOF322_204.DOutput[4] := gInks[4].signals.out.xOutBarResistance;
	X20DOF322_204.DOutput[6] := gInks[4].signals.out.xOutPowPrintHead;
	X20DOF322_204.DOutput[8] := gInks[4].signals.out.xReliefValve;

	X20AO4622_205.AOutput[1] := gInks[3].signals.out.iDutyCycleNegative;
	X20AO4622_205.AOutput[3] := gInks[3].signals.out.iDutyCycleFilling;
	
	X20AO4622_205.AOutput[2] := gInks[4].signals.out.iDutyCycleNegative;
	X20AO4622_205.AOutput[4] := gInks[4].signals.out.iDutyCycleFilling;


	// GROUP _30x
	//X20DOF322_304.DOutput[1] := gInks[5].signals.out.xOutBarResistance;
	X20DOF322_304.DOutput[3] := gInks[5].signals.out.xOutBarResistance;
	X20DOF322_304.DOutput[5] := gInks[5].signals.out.xOutPowPrintHead;
	X20DOF322_304.DOutput[7] := gInks[5].signals.out.xReliefValve;

	//X20DOF322_304.DOutput[2] := gInks[6].signals.out.xOutBarResistance;
	X20DOF322_304.DOutput[4] := gInks[6].signals.out.xOutBarResistance;
	X20DOF322_304.DOutput[6] := gInks[6].signals.out.xOutPowPrintHead;
	X20DOF322_304.DOutput[8] := gInks[6].signals.out.xReliefValve;

	X20AO4622_305.AOutput[1] := gInks[5].signals.out.iDutyCycleNegative;
	X20AO4622_305.AOutput[3] := gInks[5].signals.out.iDutyCycleFilling;
	
	X20AO4622_305.AOutput[2] := gInks[6].signals.out.iDutyCycleNegative;
	X20AO4622_305.AOutput[4] := gInks[6].signals.out.iDutyCycleFilling;

END_ACTION
