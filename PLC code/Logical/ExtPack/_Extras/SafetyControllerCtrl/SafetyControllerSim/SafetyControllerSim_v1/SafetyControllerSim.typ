
TYPE
	SafetyControllerSim_typ : 	STRUCT 
		Commands : SafetyControllerSimCommands_typ;
		Inputs : SafetyControllerInputs_typ;
		Outputs : SafetyControllerOutputs_typ;
	END_STRUCT;
	SafetyControllerSimCommands_typ : 	STRUCT 
		xSafetyToDefault : BOOL; (*To set in simulation all the inputs to have the Safety OK*)
	END_STRUCT;
	SafetyControllerSimOutputs_typ : 	STRUCT 
		xEnablePrinter1 : BOOL; (*OSSD*)
		xEnablePrinter2 : BOOL; (*OSSD*)
		xEnablePrinterBlowers1 : BOOL; (*OSSD*)
		xEnablePrinterBlowers2 : BOOL; (*OSSD*)
		xEnableDryer1 : BOOL; (*OSSD*)
		xEnableDryer2 : BOOL; (*OSSD*)
		xEnableDryerBlowers1 : BOOL; (*OSSD*)
		xEnableDryerBlowers2 : BOOL; (*OSSD*)
		xFeederToLine1 : BOOL; (*Relay*)
		xFeederToLine2 : BOOL; (*Relay*)
		xLineToFeeder1 : BOOL; (*Relay*)
		xLineToFeeder2 : BOOL; (*Relay*)
		xPrimerToLine1 : BOOL; (*Relay*)
		xPrimerToLine2 : BOOL; (*Relay*)
		xLineToPrimer1 : BOOL; (*Relay*)
		xLineToPrimer2 : BOOL; (*Relay*)
		xStackerToLine1 : BOOL; (*Relay*)
		xStackerToLine2 : BOOL; (*Relay*)
		xLineToStacker1 : BOOL; (*Relay*)
		xLineToStacker2 : BOOL; (*Relay*)
		xIRToLine1 : BOOL; (*Relay*)
		xIRToLine2 : BOOL; (*Relay*)
		xLineToIR1 : BOOL; (*Relay*)
		xLineToIR2 : BOOL; (*Relay*)
		xUVToLine1 : BOOL; (*Relay*)
		xUVToLine2 : BOOL; (*Relay*)
		xLineToUV1 : BOOL; (*Relay*)
		xLineToUV2 : BOOL; (*Relay*)
		xPrinterToX5 : BOOL; (*Relay*)
	END_STRUCT;
END_TYPE
