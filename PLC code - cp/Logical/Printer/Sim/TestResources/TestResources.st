
PROGRAM _CYCLIC

	rVal := 0.6; //Complex value. Just a starting value
	FOR iIndex:=0 TO iMax DO
		rVal := rVal * SQRT(rVal);
	END_FOR;
		
END_PROGRAM