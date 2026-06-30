
PROGRAM _CYCLIC

	gToWriteDataModbTransport[1] := REAL_TO_UINT(gMachine.parSw.rBeltSpeedSetPoint*10);
	gToWriteDataModbTransport[2] := REAL_TO_UINT(gTransVacuum[1].parSw.rManSetPoint);
	gToWriteDataModbTransport[3] := REAL_TO_UINT(gBelt.parSw.rGearBox*10);
	gToWriteDataModbTransport[4] := REAL_TO_UINT(gBelt.parSw.rAxisLength);
	
	IF gInkBox.Commands.xReset THEN
		gToWriteDataModbTransport[5] := 1;
	ELSE
		gToWriteDataModbTransport[5] := 0;
	END_IF
	
	IF EDGEPOS(gBelt.commands.xRunBelt) THEN
		gToWriteDataModbTransport[6] := 1;
	ELSIF EDGENEG(gBelt.commands.xRunBelt) THEN
		gToWriteDataModbTransport[6] := 0;
	ELSIF gToWriteDataModbTransport[6] = 1 OR gToWriteDataModbTransport[6] = 0 THEN
		gToWriteDataModbTransport[6] := -1;		
	END_IF
	
	IF EDGEPOS(gTransVacuum[1].OrdersSw.xRunManual) THEN
		gToWriteDataModbTransport[7] := 1;
	ELSIF EDGENEG(gTransVacuum[1].OrdersSw.xRunManual) THEN
		gToWriteDataModbTransport[7] := 0;
	ELSIF gToWriteDataModbTransport[7] = 1 OR gToWriteDataModbTransport[7] = 0 THEN
		gToWriteDataModbTransport[7] := -1;		
	END_IF
	
	//Remove order of Belt when receiving a falling in the Status signal
	IF EDGEPOS(gReceivedDataModbTransport[5]=0 OR gReceivedDataModbTransport[5]=2) THEN
		gBelt.commands.xRunBelt := FALSE;
	END_IF
	 
	//Remove order of Belt when receiving a falling in the Status signal
	IF EDGEPOS(gReceivedDataModbTransport[6]=0 OR gReceivedDataModbTransport[6]=2) THEN
		gTransVacuum[1].OrdersSw.xRunManual := FALSE;
	END_IF
	
	gBelt.Al.xAnyDriveAlarm := gReceivedDataModbTransport[5]=2;
	gTransVacuum[1].Alarms.xAlrBlowerError[1] := gReceivedDataModbTransport[6]=2;
	
END_PROGRAM
