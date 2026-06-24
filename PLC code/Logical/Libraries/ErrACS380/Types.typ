
TYPE
	Errors_type : 	STRUCT 
		ErrorID : UINT;
		ErrorText : STRING[80];
	END_STRUCT;
	Internal_type : 	STRUCT 
		Step : USINT;
		ErrNotFound : BOOL;
		StatusError : BOOL;
		Counter : UINT;
	END_STRUCT;
	Status_enum : 
		(
		DISABLED := 0,
		STATUS_OK := 1,
		ACS380_BUSY := 2,
		DONE := 3,
		ERR := 9
		);
END_TYPE
