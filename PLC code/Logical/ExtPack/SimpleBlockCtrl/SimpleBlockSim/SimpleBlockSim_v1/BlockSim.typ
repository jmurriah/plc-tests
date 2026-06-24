
TYPE
	SimSimpleBlockCommands_typ : 	STRUCT 
		DelayHomingBar : BOOL; (*With this activated, the SimBlock waits to home the bars until this signal is released*)
	END_STRUCT;
	SimSimpleBlockParameters_typ : 	STRUCT 
		New_Member : BOOL;
	END_STRUCT;
	SimSimpleBlock_typ : 	STRUCT 
		Commands : SimSimpleBlockCommands_typ;
		Parameters : SimSimpleBlockParameters_typ;
	END_STRUCT;
END_TYPE
