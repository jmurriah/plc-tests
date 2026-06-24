
ACTION CleaningBelt: 
	IF xStatusChanged THEN
		iLineStatus:=720;
	END_IF
	
	CASE iLineStatus OF	
		720:
			gMachine.commands.CleanBelt.xStart := FALSE;
			xCleanBeltToBeExecuted := FALSE;
			IF gBeltClean.Status.State = BCLEAN_FAULT OR NOT gMachine.St.Position.xCleaning AND NOT BeltClean.Status.xCleaning THEN
				IF xPreviousIdle THEN
					gMachine.commands.xRunBelt := FALSE;
				END_IF
				xLineReady:=TRUE;
			END_IF
	END_CASE

END_ACTION
