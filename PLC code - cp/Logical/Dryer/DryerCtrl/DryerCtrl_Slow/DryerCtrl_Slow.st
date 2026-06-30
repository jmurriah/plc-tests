PROGRAM _INIT

	versionPLC;

	PLC_Init(ADR(gPLC));

END_PROGRAM


PROGRAM _CYCLIC

	
	InternalPLC;
	
	VarsVersion;

	GeneralMachineData;
	
	// It allows CleanBelt action integrated on BeltManager
	CleanBelt;
	
	//Doors;
	
	// It allows to have consent lone in belt orders
	//[RGP] Execute "ConsentsLine" always. It was previously called if "gBelt.parameters.xExistConsentLine" was active and always was
	ConsentsLine;

	
	SuctionBlower;
	ResetRouterAndHub;
	
	AlarmsSlow;
	
	// Slow orders sent to the elements
	OrdersSlow;
	
	SoundBeacon;
	LightBeacon;
	
	gDryer.St.xStarted := TRUE;
	gDryer.St.exec.slow := gDryer.St.exec.slow +1;
	
END_PROGRAM
