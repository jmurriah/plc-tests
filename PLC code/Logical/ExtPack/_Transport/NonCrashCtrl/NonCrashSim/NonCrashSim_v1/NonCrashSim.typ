
TYPE
	SimNonCrashCommands_typ : 	STRUCT 
		xRaiseAlrComsDrive : BOOL;
		xRaiseAlrDriveError : BOOL;
		xRaiseAlrOvertorque : BOOL;
		xRaiseAlrDiffContact : BOOL;
		xRaiseControllerNotReady : BOOL;
	END_STRUCT;
	SimNonCrashParameters_typ : 	STRUCT 
		iParameter : UINT;
	END_STRUCT;
	SimNonCrash_typ : 	STRUCT 
		Commands : SimNonCrashCommands_typ;
		Parameters : SimNonCrashParameters_typ;
	END_STRUCT;
END_TYPE
