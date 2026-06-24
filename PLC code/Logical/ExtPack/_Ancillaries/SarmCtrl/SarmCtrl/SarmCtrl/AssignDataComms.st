
ACTION AssignDataComms:
	//Active modbus slave diagnosis when ancillary is enabled. This parameter must remain to TRUE from then on.
	//Just would be set to FALSE via UaExpert, to reset historic errors when ancillary is disabled
	Sarm.Parameters.xActiveSlaveDiagnosis := TRUE;
	
	/////////////////
	//Pre bits treatment
	Sarm.Outputs.Comms.iControl.0 := 	Sarm.Parameters.LineState = LINE_PREPARING_EMPTYBELT OR 
										Sarm.Parameters.LineState = LINE_STARTING_EMPTYBELT OR 
										Sarm.Parameters.LineState = LINE_BELT_EMPTYING;;
	
	//Write Registers
	gToWriteDataModbSarm[1] := REAL_TO_UINT(Sarm.Parameters.Media.rLength*10);
	gToWriteDataModbSarm[2] := REAL_TO_UINT(Sarm.Parameters.Media.rWidth*10);
	gToWriteDataModbSarm[3] := REAL_TO_UINT(Sarm.Parameters.Media.rThickness*10);
	gToWriteDataModbSarm[4] := Sarm.Parameters.iLineConfig; //REAL_TO_UINT(Sarm.Parameters.Media.rGap*10);
//	gToWriteDataModbSarm[5] := ;
//	gToWriteDataModbSarm[6] := ;
	gToWriteDataModbSarm[7] := REAL_TO_UINT(Sarm.Parameters.rSpeedSetPoint*10);
	gToWriteDataModbSarm[8] := Sarm.Outputs.Comms.iControl;
	
	
	//Disabling writting after some time active. To test
	tonDisableWrittingOfData.IN:= NOT xDisableWriteData;
	tonDisableWrittingOfData.PT:= T#1000ms;
	tonDisableWrittingOfData();
	
	IF tonDisableWrittingOfData.Q THEN
		xDisableWriteData := TRUE; 
	END_IF
	
	FOR iIndex:=1 TO 25 DO
		IF gToWriteDataModbSarm[iIndex]<>CopyOfWriteData[iIndex] THEN
			xDisableWriteData := FALSE;
		END_IF
	END_FOR
	
	Sarm.Orders.xDisableWriteBlock := xDisableWriteData;

	//Copying previous data
	CopyOfWriteData := gToWriteDataModbSarm;
	
	////////////////
	//Read Registers
	IF Sarm.Status.Comms.xModuleOk THEN
		Sarm.Inputs.Comms.iStatus := gReceivedDataModbSarm[1]; // Status Word
		Sarm.Inputs.Comms.iAlarmWord1 := gReceivedDataModbSarm[2]; // Alarm word 1 - Critical alarms
		Sarm.Inputs.Comms.iAlarmWord2 := gReceivedDataModbSarm[3]; // Alarm word 2
		Sarm.Inputs.Comms.iAlarmWord3 := gReceivedDataModbSarm[4]; // Alarm word 3
		//		Sarm.Inputs.Comms. := gReceivedDataModbSarm[5]; //Review SARM code to understand what information is being shared
		//		 := gReceivedDataModbSarm[6];
		//		 := gReceivedDataModbSarm[7];
		//		:= gReceivedDataModbSarm[8];
		//		:= gReceivedDataModbSarm[9];
		Sarm.Inputs.Comms.iVersion1 := gReceivedDataModbSarm[10];
		Sarm.Inputs.Comms.iVersion2 := gReceivedDataModbSarm[11];
		Sarm.Inputs.Comms.iVersion3 := gReceivedDataModbSarm[12];
		Sarm.Inputs.Comms.iVersion4 := gReceivedDataModbSarm[13];
		//		 := gReceivedDataModbSarm[14];
		//		 := gReceivedDataModbSarm[15];

	END_IF
	
	//Post bit treatment
	Sarm.Inputs.Comms.xRemote := Sarm.Inputs.Comms.iStatus.0;
	Sarm.Inputs.Comms.xAlarmPresent := Sarm.Inputs.Comms.iStatus.1;
	Sarm.Inputs.Comms.xBeltEmpty := Sarm.Inputs.Comms.iStatus.2; //Not being written on SARM code (FALSE assignation in that code)
	Sarm.Inputs.Comms.xWarningPresent := Sarm.Inputs.Comms.iStatus.3;
	Sarm.Inputs.Comms.xOnline := Sarm.Inputs.Comms.iStatus.4;
	Sarm.Inputs.Comms.xSafetyOnline := Sarm.Inputs.Comms.iStatus.5;

END_ACTION
