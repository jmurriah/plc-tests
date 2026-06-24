
(* TODO: Add your comment here *)
FUNCTION_BLOCK SimAnalogProcess
	
	//Start with the initial value
	IF NOT xStarted THEN
		rPresentValue:=rInitialValue;
		xStarted:=TRUE;
	END_IF
	
	IF EDGEPOS(xUseNewValue) THEN
		xUseNewValue:=FALSE;
		rPresentValue:=rNewPresentValue;
	END_IF
	
	CASE AnalogType OF
		ANALOGSIM_LINEAR_POS, ANALOGSIM_EXPONENTIAL_POS:
			rSignalPerct := ABS(rMaxValue-rPresentValue)/ABS(rMaxValue-rMinValue);	 
		ANALOGSIM_LINEAR_NEG, ANALOGSIM_EXPONENTIAL_NEG:
			rSignalPerct := ABS(rPresentValue-rMinValue)/ABS(rMaxValue-rMinValue);	 
	END_CASE;
	
	//Calculate the next value
	CASE AnalogType OF
		
		ANALOGSIM_LINEAR_NEG, ANALOGSIM_LINEAR_POS:
			rPresentValue := rPresentValue - rA + rB * rActionControl;

		ANALOGSIM_EXPONENTIAL_POS:
			rPresentValue := rPresentValue + ABS(rA) * EXPT(rSignalPerct,2) - ABS(rB) * rActionControl;

		ANALOGSIM_EXPONENTIAL_NEG:
			rPresentValue := rPresentValue - ABS(rA) * EXPT(rSignalPerct,2) + ABS(rB) * rActionControl;
		
	END_CASE;
	
	
	//Limit the PV
	rPresentValue := LIMIT( rMinValue, rPresentValue, rMaxValue);
	
END_FUNCTION_BLOCK
