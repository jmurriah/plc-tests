
PROGRAM _INIT
	(* Insert code here *)
	BeltClean ACCESS ADR (gBeltClean);
	
	BeltClean.Inputs.xAirTurbVSDAvailable := TRUE;
	BeltClean.ParSw.tiCleaning := T#30s;
	BeltClean.ParSw.tiDrying := T#15s;
	 
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	IF BeltClean.Outputs.xAirTurbineVSDReset THEN
		BeltClean.Inputs.xAirTurbVSDAvailable := TRUE;
	END_IF	 
END_PROGRAM

