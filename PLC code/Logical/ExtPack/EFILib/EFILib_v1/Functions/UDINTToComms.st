
(* Insert a UDINT value in an array for comms *)
FUNCTION UDINTToComms

	//	value	UDINT	FALSE	VAR_INPUT
	//	indexLSB	UINT	FALSE	VAR_INPUT
	//	comsArray	INT[0..9999]	TRUE	VAR_INPUT
	
	comsArray[indexLSB] :=	UDINT_TO_INT(value AND 16#0000FFFF);
	comsArray[indexLSB+1] :=UDINT_TO_INT(SHR(value AND 16#FFFF0000,16));

	UDINTToComms:=TRUE;
	
END_FUNCTION
