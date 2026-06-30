
(* TODO: Add your comment here *)
FUNCTION ComandBoolEdge0
	
	IF Com = 0 OR Com = -1 THEN
		In := FALSE;
	END_IF
	
	IF Com = 1 THEN
		In := TRUE;
	END_IF

	Com := -1;
	ComandBoolEdge0 := In;	
	
END_FUNCTION
