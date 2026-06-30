
(* TODO: Add your comment here *)
FUNCTION ComandBool
	
	IF Com = 1 THEN
		In := TRUE;
	END_IF

	IF Com = 0 THEN
		In := FALSE;
	END_IF

	Com := -1;
	ComandBool := In;	
END_FUNCTION
