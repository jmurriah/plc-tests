
TYPE
	SimInkCommands_typ : 	STRUCT 
		xCommand : BOOL; (*New command to implement*)
	END_STRUCT;
	SimInkParameters_typ : 	STRUCT 
		TankValuePercent : REAL; (*Tank Value percent desired*)
	END_STRUCT;
	SimInk_typ : 	STRUCT 
		Commands : SimInkCommands_typ;
		Parameters : SimInkParameters_typ;
	END_STRUCT;
END_TYPE
