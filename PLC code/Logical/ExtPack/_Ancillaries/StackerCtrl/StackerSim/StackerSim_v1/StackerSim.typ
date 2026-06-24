
TYPE
	StackerSimCommands_typ : 	STRUCT 
		StopBelts : BOOL;
		CreateError : BOOL;
	END_STRUCT;
	StackerSim_typ : 	STRUCT 
		Commands : StackerSimCommands_typ;
	END_STRUCT;
END_TYPE
