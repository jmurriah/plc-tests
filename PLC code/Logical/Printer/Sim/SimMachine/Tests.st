
ACTION Tests: 

	//Configuration of the calling to the TestExecution
	IF xTestPrepareMachine THEN
		URIHost := '/WsTest/PrepareMachine';
	ELSIF xTestPrePrepare THEN
		URIHost := '/WsTest/PrePrepare';
	ELSIF xTestBeltTests THEN
		URIHost := '/WsTest/BeltTests';
	ELSIF xTestConsents THEN
		URIHost := '/WsTest/ConsentTests';
	ELSIF xTestCleaning THEN
		URIHost := '/WsTest/CleaningTests';
	ELSIF xTestLine THEN
		URIHost := '/WsTest/LineTests';
	ELSIF xTestBlock THEN
		URIHost := '/WsTest/BlockTests';
	ELSIF xTestTrVacuum THEN
		URIHost := '/WsTest/TrVacuumTests';
	END_IF
	
	webClient.enable:=TRUE;
	webClient.send:= xTestPrepareMachine OR xTestPrePrepare OR xTestBeltTests OR xTestConsents OR xTestCleaning OR xTestLine OR xTestBlock OR xTestTrVacuum;
	webClient();
	
	//Clear Failed and Asserts when starting a new test
	IF EDGEPOS(webClient.send) THEN
		testPassedAsserts:=0;
		testFailedAsserts:=0;
	END_IF
	
	testMonitor.Enable:=TRUE;
	testMonitor();
	testPassedAsserts:=testMonitor.Informational.PassedAssertCounter;
	testFailedAsserts:=testMonitor.Informational.FailedAssertCounter;
	xSometestFailedAsserts:= testFailedAsserts > 0;
	
END_ACTION
