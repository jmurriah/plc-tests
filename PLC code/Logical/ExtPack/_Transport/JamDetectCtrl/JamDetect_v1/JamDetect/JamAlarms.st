
ACTION JamAlarms: 
	

	
	(**CRASH ALARMS**)
	FOR iIndexSensor:=1 TO JamDetect.Parameters.iSensorsQuantity BY 1 DO
		//Jam Alarms if Enabled
		IF JamDetect.Parameters.xBarInstalled[iIndexSensor] THEN
			IF NOT JamDetect.Inputs.xJamCrash[iIndexSensor] THEN JamDetect.Alarms.xAlrJamCrash[iIndexSensor] := TRUE; END_IF
		END_IF
	END_FOR
	
	(** Low jam detection DELOREAN-2694 **)
	IF NOT JamDetect.Parameters.xDisableLowJamAlarm THEN
		tofConsecutiveLowJamDetected[0].IN := JamDetect.Inputs.xJamLowCrash;
		tofConsecutiveLowJamDetected[0].PT := JamDetect.Parameters.iLowJamCheckDuration[0];
		tofConsecutiveLowJamDetected[0]();
		
		ctuConsecutiveLowJamDetected[0].CU := JamDetect.Inputs.xJamLowCrash AND tofConsecutiveLowJamDetected[0].Q;
		ctuConsecutiveLowJamDetected[0].PV := JamDetect.Parameters.iLowJamTimes[0];
		ctuConsecutiveLowJamDetected[0].RESET := NOT tofConsecutiveLowJamDetected[0].Q;
		ctuConsecutiveLowJamDetected[0]();
		
		tofConsecutiveLowJamDetected[1].IN := JamDetect.Inputs.xJamLowCrash;
		tofConsecutiveLowJamDetected[1].PT := JamDetect.Parameters.iLowJamCheckDuration[1];
		tofConsecutiveLowJamDetected[1]();
		
		ctuConsecutiveLowJamDetected[1].CU := JamDetect.Inputs.xJamLowCrash AND tofConsecutiveLowJamDetected[1].Q;
		ctuConsecutiveLowJamDetected[1].PV := JamDetect.Parameters.iLowJamTimes[1];
		ctuConsecutiveLowJamDetected[1].RESET := NOT tofConsecutiveLowJamDetected[1].Q;
		ctuConsecutiveLowJamDetected[1]();
		
		IF ctuConsecutiveLowJamDetected[0].Q OR ctuConsecutiveLowJamDetected[1].Q THEN
			JamDetect.Alarms.xAlrJamLowCrash := TRUE;
			LogWarningAlarm;
		END_IF
	END_IF
	
END_ACTION
