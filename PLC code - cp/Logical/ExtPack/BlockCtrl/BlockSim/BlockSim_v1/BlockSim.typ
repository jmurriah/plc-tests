
TYPE
	SimBlockCommands_typ : 	STRUCT 
		DelayHomingIcla : BOOL; (*With this activated, the SimBlock waits to home the bars until this signal is released*)
		DelayHomingBar : BOOL; (*With this activated, the SimBlock waits to home the bars until this signal is released*)
	END_STRUCT;
	SimBlockParameters_typ : 	STRUCT 
		New_Member : BOOL;
	END_STRUCT;
	SimBlock_typ : 	STRUCT 
		Commands : SimBlockCommands_typ;
		Parameters : SimBlockParameters_typ;
	END_STRUCT;
END_TYPE
