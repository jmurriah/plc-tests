
PROGRAM _INIT

	versionPLC;
	
	IF gPLC.iVersion0<>gPermanentVersion.iVersion0 OR gPLC.iVersion1<>gPermanentVersion.iVersion1 OR gPLC.iVersion2<>gPermanentVersion.iVersion2 THEN
		gMachine.AutoCmd.xCleanModbus := TRUE;	
	END_IF
	
	PLC_Init(ADR(gPLC));

END_PROGRAM


PROGRAM _CYCLIC

	
	// ACTIONS
	InternalPLC;
	
	VarsVersion;
	
	// Manage resetting PLC
	resetPLC;
	
	//Setting Serial Name of the PLC
	setSerialNumber;
	
	GeneralMachineData;
	
	//Devices parameters assignation not required to be executed in fast cycle
	OrdersPrinterSlow;
	
	// It allows CleanBelt action integrated on BeltManager
	IF gMachine.Pt.Clean.xCleanBeltWater THEN
		CleanBeltWater; //NOZOMITWO-1912
	ELSIF NOT gMachine.Pt.Clean.xCleanBeltForUv THEN
		CleanBelt;
	ELSE
		IF gMachine.Pt.MachineModel<>Type_CUBE AND gMachine.Pt.MachineModel<>Type_CUBE_GULLIVER AND gMachine.Pt.MachineModel<>Type_CUBE_INSPECTION AND gMachine.Pt.MachineModel<>Type_CUBE_GULLIVER_INSPECTION  THEN
			CleanBeltUv;
		END_IF
	END_IF
	
	// 
	CleanBeltTop;
	
	// It allows to have consent line in belt orders
	//[RGP] Execute "ConsentsLine" always. It was previously called if "gBelt.parameters.xExistConsentLine" was active and always was
	ConsentsLine;

	
	// TOJMH: Review loop
	CleanSystem;
	
	BeltShot;
	
	PowerCtrl;
	SuctionBlower;
	ResetRouterAndCB;
	
	AirCleaner;
	
	AlarmsSlow;
	
	IF gMachine.Pt.MachineLights = MACHINE_LIGHTS_RGB THEN
		RgbLigths;
	ELSE
		LightBeacon;
	END_IF
	
	//[RGP] Execution of this action not conditioned to "xControlledByLine" so line has not to manage buzzer conditions defined inside printer as referencing block, starting belt...
	SoundBeacon;  
	Air;
	JamSensors;
	
	ProgramsManager;
	
	Remote;
	
	// Check coherency of values and log possible mismatches
	CheckValues;
	
	//  Hw activation. Always sending the information from Sw
	// now added a parameter indicating if it is dynamically allowed to enable the system or not
	gDing.Parameters.xEnable := gMachine.parSw.Hw.xInstallThicknessSensor;
	gPhotoCells.parameters.xEnable := gMachine.parSw.Hw.xInstallnSensor;
	
	Startup;
	
	gMachine.St.xStarted := TRUE;
	gMachine.St.exec.slow := gMachine.St.exec.slow +1;
	
	//Powermeter assignation
	gPowermeters[1].Inputs.Comms.ReceivedDataModPowerMeter := gReceivedDataModPowerMeter1;
	gPowermeters[2].Inputs.Comms.ReceivedDataModPowerMeter := gReceivedDataModPowerMeter2;
	
END_PROGRAM
