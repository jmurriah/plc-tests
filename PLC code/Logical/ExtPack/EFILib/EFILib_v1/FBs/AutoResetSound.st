
(* TODO: Add your comment here *)
FUNCTION_BLOCK AutoResetSound
	
		
	fbRiseUpAlarm(CLK:=xAlarm);
	IF fbRiseUpAlarm.Q THEN xAlarmSound:=TRUE; END_IF
	IF xSilence OR NOT xAlarm THEN xAlarmSound:=FALSE; END_IF
	
END_FUNCTION_BLOCK
