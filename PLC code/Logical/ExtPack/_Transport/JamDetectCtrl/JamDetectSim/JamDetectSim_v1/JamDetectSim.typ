
TYPE
	JamDetectCommandsSim_typ : 	STRUCT 
		ErrorInTest : ARRAY[0..4]OF BOOL;
		CreateCrash : ARRAY[0..4]OF BOOL;
	END_STRUCT;
	JamDetectSim_typ : 	STRUCT 
		Commands : JamDetectCommandsSim_typ;
	END_STRUCT;
END_TYPE
