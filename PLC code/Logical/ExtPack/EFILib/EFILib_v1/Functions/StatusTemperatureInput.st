// Temperature Input state
FUNCTION StatusTemperatureInput

	//If Module is NOT OK, directly It returns an alarm, Block.Al.xModuleTemp0X
	
	//Channels iInputTemperatureNumber from 1 to 4 in iStatusInputTemp01
	iStatusTemperatureInput:= SHR(iStatusTempInput01,(iTemperatureInputNumber-1)*2) AND 16#03;
	// Ouput bolean, value 3 means that there is an opencircuit in PT100
	IF iStatusTemperatureInput > 2 THEN
		StatusTemperatureInput:= TRUE;
	ELSE 
		StatusTemperatureInput:= FALSE;
	END_IF	
	
END_FUNCTION
