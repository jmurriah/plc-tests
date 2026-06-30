
ACTION PreparingCleaningPH:
	
	IF xStatusChanged THEN
		iLineStatus:=400;
	END_IF

	CASE iLineStatus OF
		400:
			gMachine.commands.xClean:=TRUE;
			xLineReady:=TRUE;
		
	END_CASE
	
	
END_ACTION



