
(* TODO: Add your comment here *)
FUNCTION timeToStartPWM
	
//	iItemNumber	INT	FALSE	VAR_INPUT
//	iTotalItems	INT	FALSE	VAR_INPUT
//	iTaskCycle	UINT	FALSE	VAR_INPUT
//	iMsInCycle	UINT		VAR_IN_OUT
	
	iMsInCycle := UDINT_TO_UINT(TIME_TO_UDINT(clock_ms()) MOD (REAL_TO_UDINT(lc_rCyclePwm) * 1000) );
	
	IF iTotalItems = 1 THEN
		timeToStartPWM := TRUE;
	ELSIF iTotalItems = 0 THEN
		timeToStartPWM := FALSE;
	ELSE
		timeToStartPWM := 	iMsInCycle >= REAL_TO_UINT(INT_TO_REAL(iItemNumber) * (lc_rCyclePwm * 1000 / INT_TO_REAL(iTotalItems)))  AND
							iMsInCycle<= REAL_TO_UINT(INT_TO_REAL(iItemNumber) * (lc_rCyclePwm * 1000 / INT_TO_REAL(iTotalItems)) + UINT_TO_REAL(iTaskCycle));
	END_IF

END_FUNCTION
