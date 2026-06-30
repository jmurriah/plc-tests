
(* TODO: Add your comment here *)
FUNCTION UDINT_SUB
	
	//Protection of values to avoid infinite values
	IF Minuend >= Subtrahend THEN
		UDINT_SUB := Minuend - Subtrahend;
	ELSE
		UDINT_SUB := 0;
	END_IF

END_FUNCTION
