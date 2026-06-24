
(* TODO: Add your comment here *)
FUNCTION_BLOCK ComandBoolT
	
		
	IF Com = 1 THEN
		In := TRUE;
	END_IF

	IF Com = 0 THEN
		In := FALSE;
	END_IF

	IF In THEN
		Contador := Contador + 1;
	END_IF

	IF Contador >= 2 THEN
		In := FALSE;
		Contador := 0;
	END_IF

	Com := -1;
END_FUNCTION_BLOCK
