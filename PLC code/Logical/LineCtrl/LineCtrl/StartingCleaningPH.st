
ACTION StartingCleaningPH:

	IF xStatusChanged THEN
		iLineStatus:=410;
	END_IF
	
	CASE iLineStatus OF
		410:
			xBarsInCleaningPosition := BarPositionCleaning(ADR(Machine));
			IF xBarsInCleaningPosition THEN
				gMachine.commands.xClean:=FALSE;
				iLineStatus:=0;
				xLineReady:=TRUE;
			END_IF
	END_CASE
	
END_ACTION


