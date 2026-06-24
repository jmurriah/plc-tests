
(* Assignation of a UDINT Double value from an array *)
FUNCTION UDINTFromComms
//	indexLSB	UINT	FALSE	VAR_INPUT					 	 	 	 	69
//	comsArray	INT[0..9999]	TRUE	VAR_INPUT					 	 	 	 	70
	UDINTFromComms := INT_TO_UINT(comsArray[indexLSB]) + 16#10000 * INT_TO_UINT(comsArray[indexLSB+1]);
END_FUNCTION
