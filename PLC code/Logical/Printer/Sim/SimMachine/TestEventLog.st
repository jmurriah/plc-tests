
ACTION LogTests:

	IF NOT gSimMachine.Commands.LogTests.xCommand THEN
		RETURN;
	END_IF
	gSimMachine.Commands.LogTests.xCommand := FALSE;
	
	stEventLogTests.Source := ELOG_TYPE_GENERAL;
	stEventLogTests.Severity:= ELOG_SEVERITY_INFO;
	stEventLogTests.Facility:= 0;
	stEventLogTests.ErrorCode:=0;
	
	stEventLogTests.Text := 'TEST >>>> ';
	brsstrcat(ADR(stEventLogTests.Text),ADR(gSimMachine.Commands.LogTests.Text));
	
	gEventLogLoader(EventData := ADR(stEventLogTests));
	
END_ACTION
