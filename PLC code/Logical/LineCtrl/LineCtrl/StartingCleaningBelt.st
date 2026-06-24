
ACTION StartingCleaningBelt:

	IF xStatusChanged THEN
		iLineStatus:=710;
	END_IF
	
	CASE iLineStatus OF	
		710:
			IF BeltClean.Status.xCleaning OR gBeltClean.Status.State = BCLEAN_FAULT THEN
				gMachine.commands.CleanBelt.xStart := FALSE;
				xCleanBeltToBeExecuted := FALSE;
				xLineReady:=TRUE;
			END_IF
	END_CASE
	
END_ACTION
