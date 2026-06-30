
PROGRAM _CYCLIC
	
	//If in simulation, do not assign physical mapping
	IF gMachine.Pt.ConfigNameID = GC_CONFIG_INKBOX_SIM_ID THEN
		RETURN;
	END_IF

	InputsInkBox;

END_PROGRAM
