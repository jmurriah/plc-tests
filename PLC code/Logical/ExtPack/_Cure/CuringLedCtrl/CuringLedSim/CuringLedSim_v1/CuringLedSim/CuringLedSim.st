
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	dataLed ACCESS ADR (gCuringLed[iIndexCuringLedSim]);
	
	IF NOT dataLed.Parameters.xInstalled THEN
		iIndexCuringLedSim := iIndexCuringLedSim + 1;
		RETURN;	
	END_IF

	iIndexCuringLedSim := iIndexCuringLedSim + 1;
	
END_PROGRAM
