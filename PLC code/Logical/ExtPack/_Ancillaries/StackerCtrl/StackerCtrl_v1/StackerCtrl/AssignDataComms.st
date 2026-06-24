
ACTION AssignDataComms:
	
	
	//Active modbus slave diagnosis when ancillary is enabled. This parameter must remain to TRUE from then on.
	//Just would be set to FALSE via UaExpert, to reset historic errors when ancillary is disabled
	Stacker.Parameters.xActiveSlaveDiagnosis := TRUE;
	
	/////////////////
	//Pre bits treatment
	Stacker.Comms.iControl.0 := Stacker.Comms.xEndCycle;
	Stacker.Comms.iControl.1 := Stacker.Comms.xCleanBelts := Stacker.Outputs.xCleanBelts;
	Stacker.Comms.iControl.2 := Stacker.Comms.xResetAlarms;
	Stacker.Comms.iControl.3 := Stacker.ParSw.xStackMode;
	Stacker.Comms.iControl.4 := Stacker.Comms.xLastBox;
	Stacker.Comms.iControl.5 := Stacker.Orders.xHoldReject;
	Stacker.Comms.iControl.6 := Stacker.Parameters.xDoubleLine;

	
	//Write Registers
	gToWriteDataModbStacker[1] := Stacker.Comms.iControl; 
	gToWriteDataModbStacker[2] := REAL_TO_UINT(Stacker.Parameters.Media.rLength*10);
	gToWriteDataModbStacker[3] := REAL_TO_UINT(Stacker.Parameters.Media.rWidth*10);
	gToWriteDataModbStacker[4] := REAL_TO_UINT(Stacker.Parameters.Media.rThickness*10);
	gToWriteDataModbStacker[5] := REAL_TO_UINT(Stacker.Parameters.Media.rGap*10);
	gToWriteDataModbStacker[6] := Stacker.ParSw.iStackBoardsNum;
	gToWriteDataModbStacker[7] := Stacker.ParSw.iStackHeight;
	gToWriteDataModbStacker[8] := REAL_TO_UINT(Stacker.Parameters.rSpeedSetPoint*10);
	(*gToWriteDataModbStacker[9] := ;
	gToWriteDataModbStacker[10] := ;
	gToWriteDataModbStacker[11] := ;
	
	gToWriteDataModbStacker[12] := ;
	gToWriteDataModbStacker[13] := ;
	gToWriteDataModbStacker[14] := ;
	gToWriteDataModbStacker[15] := ;
	gToWriteDataModbStacker[16] := ;
	gToWriteDataModbStacker[17] := ;
	gToWriteDataModbStacker[18] := ;
	gToWriteDataModbStacker[19] := ;
	gToWriteDataModbStacker[20] := ;
	gToWriteDataModbStacker[21] := ;
	gToWriteDataModbStacker[22] := ;
	gToWriteDataModbStacker[23] := ;
	gToWriteDataModbStacker[24] := ;
	gToWriteDataModbStacker[25] := ;
	*)
	
	
	//Disabling writting after some time active. To test
	tonDisableWrittingOfData.IN:= NOT xDisableWriteData;
	tonDisableWrittingOfData.PT:= T#1000ms;
	tonDisableWrittingOfData();
	
	IF tonDisableWrittingOfData.Q THEN
		xDisableWriteData := TRUE; 
	END_IF
	
	FOR iIndex:=1 TO 25 DO
		IF gToWriteDataModbStacker[iIndex]<>CopyOfWriteData[iIndex] THEN
			xDisableWriteData := FALSE;
		END_IF
	END_FOR
	
	Stacker.Orders.xDisableWriteBlock := xDisableWriteData;
		
	//Copying previous data
	CopyOfWriteData := gToWriteDataModbStacker;
	
	
	////////////////
	//Read Registers
	IF Stacker.Status.Comms.xModuleOk THEN
		Stacker.Inputs.Comms.iStatus := gReceivedDataModbStacker[1];
		Stacker.Inputs.Comms.uiNumBoardsInCurrentPile := gReceivedDataModbStacker[2];
		Stacker.Inputs.Comms.uiCurrentPileHeigh := gReceivedDataModbStacker[3];
		Stacker.Inputs.Comms.uiTransportSpeed := gReceivedDataModbStacker[4];
		Stacker.Inputs.Comms.iAlarmWord1 := gReceivedDataModbStacker[5];
		Stacker.Inputs.Comms.iAlarmWord2 := gReceivedDataModbStacker[6];
		Stacker.Inputs.Comms.iAlarmWord3 := gReceivedDataModbStacker[7];
		Stacker.Inputs.Comms.iAlarmWord4 := gReceivedDataModbStacker[8];
		Stacker.Inputs.Comms.iAlarmWord5 := gReceivedDataModbStacker[9];
		Stacker.Inputs.Comms.iAlarmWord6 := gReceivedDataModbStacker[10];
		Stacker.Inputs.Comms.iAlarmWord7 := gReceivedDataModbStacker[11];
		Stacker.Inputs.Comms.iAlarmWord8:= gReceivedDataModbStacker[12];
		Stacker.Inputs.Comms.iAlarmWord9:= gReceivedDataModbStacker[13];
		Stacker.Inputs.Comms.iAlarmWord10:= gReceivedDataModbStacker[14];
		// := gReceivedDataModbStacker[15];
		// := gReceivedDataModbStacker[16];
		// := gReceivedDataModbStacker[17];
		// := gReceivedDataModbStacker[18];
		
		//:= gReceivedDataModbStacker[19];
		//:= gReceivedDataModbStacker[20];
		
		// := gReceivedDataModbStacker[21];
		Stacker.Inputs.Comms.iVersion1 := gReceivedDataModbStacker[22];
		Stacker.Inputs.Comms.iVersion2 := gReceivedDataModbStacker[23];
		Stacker.Inputs.Comms.iVersion3 := gReceivedDataModbStacker[24];
		Stacker.Inputs.Comms.iVersion4 := gReceivedDataModbStacker[25];
		
	END_IF
	
	//Post bit treatment
	
	Stacker.Inputs.Comms.xRemote := Stacker.Inputs.Comms.iStatus.0;
	Stacker.Inputs.Comms.xErrorActive := Stacker.Inputs.Comms.iStatus.1;
	Stacker.Inputs.Comms.xInWorkingPosition := Stacker.Inputs.Comms.iStatus.2;
	Stacker.Inputs.Comms.xStackReady := Stacker.Inputs.Comms.iStatus.3;
	Stacker.Inputs.Comms.xStackExit := Stacker.Inputs.Comms.iStatus.4;
	Stacker.Inputs.Comms.xStopDemand := Stacker.Inputs.Comms.iStatus.5;
	Stacker.Inputs.Comms.xStackerEmpty := Stacker.Inputs.Comms.iStatus.6;
	Stacker.Inputs.Comms.xBeltsEmpty := Stacker.Inputs.Comms.iStatus.7;
	Stacker.Inputs.Comms.xNewFormat := Stacker.Inputs.Comms.iStatus.8;
	Stacker.Inputs.Comms.xOnline := Stacker.Inputs.Comms.iStatus.9;
	Stacker.Inputs.Comms.xSerie := Stacker.Inputs.Comms.iStatus.10; //Serie A or B. Just make sense for full stacker
	Stacker.Inputs.Comms.xWarningActive := Stacker.Inputs.Comms.iStatus.11;
	Stacker.Inputs.Comms.xEmergencyStopNotAcknowledged := Stacker.Inputs.Comms.iStatus.12;
	Stacker.Inputs.Comms.xRejectAvailable := Stacker.Inputs.Comms.iStatus.13;


END_ACTION
