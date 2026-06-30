
ACTION JamSensors: 

	IF NOT gMachine.parSw.xJamDetectEnable THEN
		RETURN;
	END_IF
	
	FOR iIndexInks :=1 TO MAX_LAST_INK DO
		gJamPerInk[iIndexInks].xAlrJamCrash	:= gJamDetect[gJamPerInk[iIndexInks].iJamDevice].Alarms.xAlrJamCrash[gJamPerInk[iIndexInks].iJamSensor];
		gJamPerInk[iIndexInks].xAlrJamTest	:= gJamDetect[gJamPerInk[iIndexInks].iJamDevice].Alarms.xAlrJamTest[gJamPerInk[iIndexInks].iJamSensor];
		gJamPerInk[iIndexInks].xAlrLowJamCrash	:= gJamDetect[gJamPerInk[iIndexInks].iJamDevice].Alarms.xAlrJamLowCrash;
	END_FOR

	FOR iIndexCuringLedLamps :=1 TO MAX_LAST_CURING_LED DO
		gJamPerCuringLed[iIndexCuringLedLamps].xAlrJamCrash	:= gJamDetect[gJamPerCuringLed[iIndexCuringLedLamps].iJamDevice].Alarms.xAlrJamCrash[gJamPerCuringLed[iIndexCuringLedLamps].iJamSensor];
		gJamPerCuringLed[iIndexCuringLedLamps].xAlrJamTest	:= gJamDetect[gJamPerCuringLed[iIndexCuringLedLamps].iJamDevice].Alarms.xAlrJamTest[gJamPerCuringLed[iIndexCuringLedLamps].iJamSensor];
		gJamPerCuringLed[iIndexCuringLedLamps].xAlrLowJamCrash	:= gJamDetect[gJamPerCuringLed[iIndexCuringLedLamps].iJamDevice].Alarms.xAlrJamLowCrash;
	END_FOR
	
	gJamCamera.xAlrJamCrash	:= gJamDetect[gJamCamera.iJamDevice].Alarms.xAlrJamCrash[gJamCamera.iJamSensor];
	gJamCamera.xAlrJamTest	:= gJamDetect[gJamCamera.iJamDevice].Alarms.xAlrJamTest[gJamCamera.iJamSensor];
	gJamCamera.xAlrLowJamCrash := gJamDetect[gJamCamera.iJamDevice].Alarms.xAlrJamLowCrash;

END_ACTION
