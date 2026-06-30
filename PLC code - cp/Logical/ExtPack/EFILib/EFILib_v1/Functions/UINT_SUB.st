
(* TODO: Add your comment here *)
FUNCTION UINT_SUB
	
	//Protection of values to avoid infinite values
	IF Minuend >= Subtrahend THEN
		UINT_SUB := Minuend - Subtrahend;
	ELSE
		UINT_SUB := 0;
	END_IF

END_FUNCTION
