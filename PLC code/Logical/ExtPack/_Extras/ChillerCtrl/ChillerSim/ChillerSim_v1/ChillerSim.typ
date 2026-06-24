
TYPE
	stChillerSimCommands : 	STRUCT 
		StopRunning : BOOL;
		GenerateAlarm : BOOL;
	END_STRUCT;
	stChillerSim : 	STRUCT 
		Commands : stChillerSimCommands;
	END_STRUCT;
END_TYPE
