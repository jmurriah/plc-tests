
// Analog Input state
FUNCTION StatusAnalogInputBroken

	//If Module is NOT OK, directly It returns an error in the input, xVacuum1SensorError or xVacuum2SensorError
	IF NOT xModuleOK THEN
		StatusAnalogInputBroken:=TRUE; 
		RETURN;
	END_IF
	
	//Channels 1 to 4 in StatusInput01
	IF iInputNumber>=1 AND iInputNumber<=4 THEN
		iStatusInput:= SHR(iStatus01,(iInputNumber-1)*2) AND 16#01;
	END_IF
	
	//Channels 5 to 8 in StatusInput02
	IF iInputNumber>=5 AND iInputNumber<=8 THEN
		iStatusInput:= SHR(iStatus02,(iInputNumber-5)*2) AND 16#01;
	END_IF
	
	StatusAnalogInputBroken:= iStatusInput > 0;
	
END_FUNCTION
