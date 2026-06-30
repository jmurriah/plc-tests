
TYPE
	NirAdphosSimParameters_typ : 	STRUCT 
		CurrentSpeed : REAL; (*Current speed of the Belt in m/min*)
	END_STRUCT;
	NirAdphosSimCommands_typ : 	STRUCT 
		CreateError : BOOL;
	END_STRUCT;
	NirAdphosSim_typ : 	STRUCT 
		Parameters : NirAdphosSimParameters_typ;
		Commands : NirAdphosSimCommands_typ;
	END_STRUCT;
END_TYPE
