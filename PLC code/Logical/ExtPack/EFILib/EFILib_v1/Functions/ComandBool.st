
(* TODO: Add your comment here *)
FUNCTION ComandBoolReset
	
	IF Com = 1 THEN
		In := FALSE;
	END_IF

	Com := -1;
	ComandBoolReset := In;
	
END_FUNCTION
