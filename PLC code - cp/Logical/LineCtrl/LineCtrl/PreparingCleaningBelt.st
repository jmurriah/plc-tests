
ACTION PreparingCleaningBelt: 
	
	IF xStatusChanged THEN
		iLineStatus:=700;
	END_IF

	CASE iLineStatus OF
		700:
			IF gBeltClean.Status.State = BCLEAN_FAULT THEN
				xLineReady := TRUE;
			ELSE //IF gThicknessCtrl.status.Belt.xBeltEmpty THEN
				IF xPreviousIdle AND gThicknessCtrl.status.Belt.xBeltEmpty THEN
					gMachine.commands.xRunBelt := TRUE;
				END_IF
				IF gBelt.states.xRuningBelt THEN
					gMachine.commands.CleanBelt.xStart := TRUE;
					xLineReady:=TRUE;
				END_IF
			END_IF
		
	END_CASE

END_ACTION
