
TYPE
	SimMachineType : 
		(
		SIM_MACHINE_REAL,
		SIM_MACHINE_2B12BAR,
		SIM_MACHINE_1B6BAR,
		SIM_MACHINE_1B2BAR,
		SIM_MACHINE_P5_WAT,
		SIM_MACHINE_P4_CBK,
		SIM_MACHINE_S1400_VAC_PWRLNK,
		SIM_MACHINE_S1400_VAC_CAN,
		SIM_MACHINE_NZ2,
		SIM_MACHINE_NZ2_UV,
		SIM_MACHINE_NZ2_UV_WHITE,
		SIM_MACHINE_CUBE,
		SIM_MACHINE_CUBE_GULLIVER,
		SIM_MACHINE_MECANO_UV_WHITE,
		SIM_MACHINE_MECANO_UV_OPV,
		SIM_MACHINE_MECANO_UV_WHITE_OPV
		);
	SimMachineConsent_typ : 	STRUCT 
		xRaiseUpWithNoConsent : BOOL;
	END_STRUCT;
	SimMachineMedia_typ : 	STRUCT 
		rMediaThickness : REAL := 15.0; (*Value in mm*)
		xMediaPresent : BOOL; (*To enter one media*)
		xRushProof : BOOL;
		xContinuousMediaPresent : BOOL; (*To constantly entering media in printer*)
		xMediaIfFeederFeeding : BOOL;
	END_STRUCT;
	SimMachineUPSCommand : 	STRUCT 
		xRaiseLowBat : BOOL;
		xRaisePowerFault : BOOL;
	END_STRUCT;
	SimMachineLogTest : 	STRUCT 
		xCommand : BOOL;
		Text : STRING[80];
	END_STRUCT;
	SimMachineCommand_typ : 	STRUCT 
		xToAuto : BOOL; (*Edge command*)
		xToManual : BOOL; (*Edge command*)
		xToZero : BOOL; (*Edge command*)
		xToProduction : BOOL; (*Edge command*)
		Media : SimMachineMedia_typ;
		UPS : SimMachineUPSCommand;
		Consent : SimMachineConsent_typ;
		xStain : BOOL;
		LogTests : SimMachineLogTest;
	END_STRUCT;
	SimMachineSignals_typ : 	STRUCT 
		xProductDetectL1 : BOOL; (*Variable to simulate the Product Detect in Simulation*)
		xProductDetectL2 : BOOL; (*Variable to simulate the Product Detect in Simulation*)
		xPDCarriageSignalL1 : BOOL; (*ProductDetect Signal coming from the Carriage Board*)
		xPDCarriageSignalL2 : BOOL; (*ProductDetect Signal coming from the Carriage Board*)
	END_STRUCT;
	SimMachineStackParameters_typ : 	STRUCT 
		xLoadNewMedia : BOOL;
		xLoadNewMediaEnergy : BOOL;
		iMediaQuantityToKeepLoaded : USINT;
	END_STRUCT;
	SimMachineParameters_typ : 	STRUCT 
		xRunWithKernel : BOOL;
		MachineType : SimMachineType := SIM_MACHINE_REAL;
		DryerType : SimDryerType := SIM_DRYER_NOZ2_NIR;
		xAutoMediaPresent : BOOL;
		Stack : SimMachineStackParameters_typ;
		rStainGap : REAL;
		rStainLength : REAL;
	END_STRUCT;
	SimMachine_typ : 	STRUCT 
		Commands : SimMachineCommand_typ;
		Parameters : SimMachineParameters_typ;
		Signals : SimMachineSignals_typ;
	END_STRUCT;
END_TYPE
