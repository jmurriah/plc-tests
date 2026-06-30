
PROGRAM _INIT
	
	InitialDataForMedia;
	PreparingMethodComms;
	
	InitialDataForMediaEnergy;
	PreparingMethodEnergyComms;
	
	
END_PROGRAM

PROGRAM _CYCLIC
	
	Media;
	
	// Sending information to the new boards
	Stack;
	StackEnergy;
	
END_PROGRAM

