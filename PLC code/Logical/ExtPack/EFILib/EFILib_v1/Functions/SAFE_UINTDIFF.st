
(* TODO: Add your comment here *)
FUNCTION SAFE_UINTDIFF
	IF uiLastValue >= uiPrevValue THEN
		SAFE_UINTDIFF:= uiLastValue - uiPrevValue;
	ELSE
		SAFE_UINTDIFF:= 65535 - uiPrevValue  + uiLastValue + 1;
	END_IF

(*	
	IF data.signals.in.iTachNegative > uiNegTachoCounterPrev THEN
		iDiffPulseTachoNeg:= data.signals.in.iTachNegative - uiNegTachoCounterPrev;
	ELSE
		iDiffPulseTachoNeg:= 65535 + data.signals.in.iTachNegative - uiNegTachoCounterPrev;
	END_IF
*)	
END_FUNCTION
