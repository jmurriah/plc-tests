
ACTION JamDetectCtrl: 
	
	xStatusChanged := StatusPrevious <> JamDetect.Status ;
	StatusPrevious := JamDetect.Status;
	
	CASE JamDetect.Status OF
		JAMVIB_NOT_INSTALLED:
			JamDetect.Status := JAMVIB_NOT_INIT;
		
		JAMVIB_NOT_INIT:
			ResetTestingOrders;
			IF JamDetect.Commands.xStart THEN
				IF JamDetect.Parameters.xDisableTest THEN
					JamDetect.Status := JAMVIB_WORKING;
				ELSIF NOT xAnyTestAlarm THEN
					JamDetect.Status := JAMVIB_TESTING;
				END_IF
			END_IF
		
		JAMVIB_TESTING:
			
			JamTesting;
			
			IF xTestFinished THEN
				IF JamDetect.Commands.xStart AND NOT xAnyTestAlarm THEN
					xTestFinished := FALSE;
					JamDetect.Status := JAMVIB_WORKING;
				ELSE
					JamDetect.Status := JAMVIB_NOT_INIT;
				END_IF
			END_IF
			
		
		JAMVIB_WORKING:
			
			JamAlarms;
			
			IF JamDetect.Commands.xPause THEN
				JamDetect.Status := JAMVIB_WAITING;
			END_IF

			IF NOT JamDetect.Commands.xStart THEN
				JamDetect.Status := JAMVIB_NOT_INIT;
			END_IF
			
		JAMVIB_WAITING:
			
			IF NOT JamDetect.Commands.xPause THEN
				IF JamDetect.Commands.xStart THEN
					JamDetect.Status := JAMVIB_WORKING;
				ELSE
					JamDetect.Status := JAMVIB_NOT_INIT;
				END_IF
			END_IF
		

	END_CASE
	
	//Saving state history
	IF JamDetect.Status<>StateHistory[0] THEN
		FOR iIndexHistory:=iHistoryLines TO 1 BY -1 DO 
			StateHistory[iIndexHistory]:=StateHistory[iIndexHistory-1];
		END_FOR;
		StateHistory[0]:=JamDetect.Status;
	END_IF
	
	
	//Alarm Summary
	xAnyCrashAlarm	:= FALSE;
	IF JamDetect.Status <> JAMVIB_TESTING THEN xAnyTestAlarm := FALSE; END_IF
	
	FOR iIndexSensor:=1 TO JamDetect.Parameters.iSensorsQuantity BY 1 DO 
		IF JamDetect.Alarms.xAlrJamCrash[iIndexSensor] THEN xAnyCrashAlarm := TRUE; END_IF
		IF JamDetect.Alarms.xAlrJamTest[iIndexSensor] THEN	xAnyTestAlarm := TRUE; END_IF
	END_FOR
	JamDetect.AlSummary.xAlarmStop := xAnyCrashAlarm OR xAnyTestAlarm;

	JamDetect.AlSummary.xAnyWarning := JamDetect.Alarms.xAlrJamLowCrash;
	
END_ACTION
