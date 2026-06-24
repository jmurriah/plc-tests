
TYPE
	InkboxCabinetParameters : 	STRUCT 
		MaxTempPowerPsu : UINT; (*Power in Watts*)
		TotalInksPerPsu : USINT;
		TotalInkSystems : USINT;
	END_STRUCT;
	InkboxParameters : 	STRUCT 
		TotalCabinets : USINT;
		Cabinets : ARRAY[0..MAX_LAST_INK_CABINET]OF InkboxCabinetParameters;
	END_STRUCT;
	InkboxCabinetStatus : 	STRUCT 
		xExists : BOOL; (*The cabinet exists*)
		rPowerReduction : REAL; (*Power reduction calculated*)
		rTotalAskedPower : REAL; (*The total power calculated by the Inks*)
	END_STRUCT;
	InkboxCommands : 	STRUCT  (*Just Edge commands*)
		xReset : BOOL;
		xMute : BOOL;
	END_STRUCT;
	InkboxStatus : 	STRUCT 
		iTotalInks : USINT; (*Total possible Inks by cabinets configuration*)
		ExistingInks : ARRAY[0..MAX_LAST_INK]OF BOOL;
		Cabinets : ARRAY[0..MAX_LAST_INK_CABINET]OF InkboxCabinetStatus;
	END_STRUCT;
	InkBox : 	STRUCT 
		Status : InkboxStatus;
		Parameters : InkboxParameters;
		Commands : InkboxCommands; (*Just Edge Commands*)
	END_STRUCT;
END_TYPE
