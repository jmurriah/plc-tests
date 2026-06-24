
(* TODO: Add your comment here *)
FUNCTION_BLOCK Blink
	
	
	T_ON.PT:= T_Blink;
	T_ON.IN:= NOT T_OFF.Q;
	T_ON();
	
	T_OFF.IN:= T_ON.Q;
	T_OFF.PT:= T_Blink;
	T_OFF();
	
	Out:= T_ON.Q;
	
	VAR1:= TRUE;
	
END_FUNCTION_BLOCK
