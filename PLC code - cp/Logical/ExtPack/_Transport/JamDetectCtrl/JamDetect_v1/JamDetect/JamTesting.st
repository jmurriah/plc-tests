
ACTION JamTesting: 
	
	IF xStatusChanged THEN
		TestingStatus := JAMVIBT_INIT;
	END_IF
	
	(**TESTS ALARMS**)
	//All jam devices share the DO from PLC to test the sensors, 1 PLC DigitalOutput will activate the test of 1 sensor in all jam devices. So, never perform 2 tests simultaneously
		
	//Time to consider the test is wrong without an OK signal of the test
	tonTestTimeOut.IN := TestingStatus=JAMVIBT_CHECKING;
	tonTestTimeOut.PT := t#2s;
	tonTestTimeOut();

	//Time to Start checking the result of the test
	tonTestsWaitAnswer.IN := TestingStatus=JAMVIBT_WAITING_TO_CHECK;
	tonTestsWaitAnswer.PT := t#5s;
	tonTestsWaitAnswer();
	
	tonNextTest.IN := TestingStatus=JAMVIBT_GO_NEXT;
	tonNextTest.PT := t#300ms;
	tonNextTest();

	
	CASE TestingStatus OF
		
		JAMVIBT_INIT:
			usiTestNum := 1;
			TestingStatus := JAMVIBT_ACTIVATE_SIGNAL;
		
		JAMVIBT_ACTIVATE_SIGNAL:
			xTestFinished := FALSE;
			JamDetect.Outputs.xJamTestSignal[usiTestNum]:= JamDetect.Parameters.xBarInstalled[usiTestNum];
			TestingStatus := JAMVIBT_WAITING_TO_CHECK;

		JAMVIBT_WAITING_TO_CHECK:
			IF tonTestsWaitAnswer.Q THEN
				TestingStatus := JAMVIBT_CHECKING;
			END_IF
		
		JAMVIBT_CHECKING:
			IF NOT JamDetect.Inputs.xJamTestOk AND JamDetect.Parameters.xBarInstalled[usiTestNum] THEN
				JamDetect.Alarms.xAlrJamTest[usiTestNum] := TRUE;
			END_IF
			IF tonTestTimeOut.Q THEN
				JamDetect.Outputs.xJamTestSignal[usiTestNum]:= FALSE;
				TestingStatus := JAMVIBT_GO_NEXT;
			END_IF
				
		JAMVIBT_GO_NEXT:
			IF usiTestNum < JamDetect.Parameters.iSensorsQuantity THEN
				IF tonNextTest.Q THEN
					usiTestNum := usiTestNum + 1;
					TestingStatus := JAMVIBT_ACTIVATE_SIGNAL;
				END_IF
			ELSE
				xTestFinished := TRUE;
				TestingStatus := JAMVIBT_INIT;
			END_IF
		
	END_CASE

	
	//Saving state history
	IF TestingStatus<>TestingStateHistory[0] THEN
		FOR iTestingIndexHistory:=iTestingHistoryLines TO 1 BY -1 DO 
			TestingStateHistory[iTestingIndexHistory]:=TestingStateHistory[iTestingIndexHistory-1];
		END_FOR
		TestingStateHistory[0]:=TestingStatus;
	END_IF
	
END_ACTION

ACTION ResetTestingOrders:

	xTestFinished := FALSE;
	
	FOR iIndexSensor:=1 TO JamDetect.Parameters.iSensorsQuantity BY 1 DO
		JamDetect.Outputs.xJamTestSignal[iIndexSensor]	:= FALSE;
	END_FOR

END_ACTION

