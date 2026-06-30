
ACTION safetyPre: 
	
//	//Limits of the analog control signal are 0V and 5V
//	IF parBar.rLowPumpLimitNeg < 0 	THEN parBar.rLowPumpLimitNeg := 0; END_IF
//	IF parBar.rLowPumpLimitPos < 0 	THEN parBar.rLowPumpLimitPos := 0; END_IF
//	IF parBar.rHighPumpLimitNeg > 5 	THEN parBar.rHighPumpLimitNeg := 5; END_IF
//	IF parBar.rHighPumpLimitPos > 5 	THEN parBar.rHighPumpLimitPos := 5; END_IF
//	
//	//If the Max value is too low, we assign the minimum value
//	IF parBar.rHighPumpLimitNeg < gc_rMinDiffMinMaxCtrlVoltage THEN parBar.rHighPumpLimitNeg := gc_rMinDiffMinMaxCtrlVoltage; END_IF
//	IF parBar.rHighPumpLimitPos < gc_rMinDiffMinMaxCtrlVoltage THEN parBar.rHighPumpLimitPos := gc_rMinDiffMinMaxCtrlVoltage; END_IF
//	
	inks.parameters.Temp.iBarsWithSameBlock:=MAX(inks.parameters.Temp.iBarsWithSameBlock,1);
	
	
END_ACTION
