
ACTION AssignDataComms:
	
	//Active modbus slave diagnosis when ancillary is enabled. This parameter must remain to TRUE from then on.
	//Just would be set to FALSE via UaExpert, to reset historic errors when ancillary is disabled
	Feeder.Parameters.xActiveSlaveDiagnosis := TRUE;
	
	FOR iIndexMedia:=1 TO 4 DO
		iMedia := iMedia + gToWriteDataModbFeeder[iIndexMedia];
	END_FOR
	
	IF iPreviousMedia <> iMedia THEN
		xNewMediaParameters := TRUE;
		iPreviousMedia := iMedia;
	ELSIF ton_NexMediaParamaters.Q THEN
		xNewMediaParameters := FALSE;
	END_IF
	
	ton_NexMediaParamaters(IN:=xNewMediaParameters, PT:=T#200MS);
	
	/////////////////
	//Pre bits treatment
	Feeder.Outputs.Comms.iControl.0 := Feeder.ParSw.xBatchFeeding;
	Feeder.Outputs.Comms.iControl.1 := xNewMediaParameters;
	//Feeder.Outputs.Comms.iControl.2 := ;
	Feeder.Outputs.Comms.iControl.3 := Feeder.Commands.xNewOrder;
	Feeder.Outputs.Comms.iControl.4 := Feeder.Commands.xResetAlarms;
	Feeder.Outputs.Comms.iControl.5 := Feeder.Commands.xSheetFeeding;
	Feeder.Outputs.Comms.iControl.6 := Feeder.Commands.xStopFeeding;
	
	//Write Registers
	gToWriteDataModbFeeder[1] := REAL_TO_UINT(Feeder.Parameters.Media.rLength*10);
	gToWriteDataModbFeeder[2] := REAL_TO_UINT(Feeder.Parameters.Media.rWidth*10);
	gToWriteDataModbFeeder[3] := REAL_TO_UINT(Feeder.Parameters.Media.rThickness*10);
	gToWriteDataModbFeeder[4] := REAL_TO_UINT(Feeder.Parameters.Media.rGap*10);
	//gToWriteDataModbFeeder[5] := ;
	gToWriteDataModbFeeder[6] := Feeder.Parameters.iLineConfig;
	gToWriteDataModbFeeder[7] := Feeder.Parameters.iRegisterType;
	gToWriteDataModbFeeder[8] := REAL_TO_UINT(Feeder.Parameters.Media.rOffsetRegisterL1);
	gToWriteDataModbFeeder[9] := Feeder.Outputs.Comms.iControl;
	gToWriteDataModbFeeder[10] := REAL_TO_UINT(Feeder.Parameters.Media.rOffsetRegisterL2);
	gToWriteDataModbFeeder[11] := REAL_TO_UINT(Feeder.Parameters.rBeltSpeedSetPoint*10);
	//gToWriteDataModbFeeder[12] := ;
	gToWriteDataModbFeeder[13] := Feeder.Parameters.iCentralOffset;
	gToWriteDataModbFeeder[14] := Feeder.Parameters.iCounterSetPointL1;
	gToWriteDataModbFeeder[15] := Feeder.Parameters.iCounterSetPointL2;
	(*
	gToWriteDataModbFeeder[16] := ;
	gToWriteDataModbFeeder[17] := ;
	gToWriteDataModbFeeder[18] := ;
	gToWriteDataModbFeeder[19] := ;
	gToWriteDataModbFeeder[20] := ;
	gToWriteDataModbFeeder[21] := ;
	gToWriteDataModbFeeder[22] := ;
	gToWriteDataModbFeeder[23] := ;
	gToWriteDataModbFeeder[24] := ;
	gToWriteDataModbFeeder[25] := ;
	*)
	
	
	//Disabling writting after some time active. To test
	tonDisableWrittingOfData.IN:= NOT xDisableWriteData;
	tonDisableWrittingOfData.PT:= T#1000ms;
	tonDisableWrittingOfData();
	
	IF tonDisableWrittingOfData.Q THEN
		xDisableWriteData := TRUE; 
	END_IF
	
	FOR iIndex:=1 TO 25 DO
		IF gToWriteDataModbFeeder[iIndex]<>CopyOfWriteData[iIndex] THEN
			xDisableWriteData := FALSE;
		END_IF
	END_FOR
	
	Feeder.Orders.xDisableWriteBlock := xDisableWriteData;
	
	//Copying previous data
	CopyOfWriteData := gToWriteDataModbFeeder;
	
	////////////////
	//Read Registers
	IF Feeder.Status.Comms.xModuleOk THEN
		Feeder.Inputs.Comms.iNumBoardsRemainingL1 := gReceivedDataModbFeeder[1];
		Feeder.Inputs.Comms.iNumBoardsRemainingL2 := gReceivedDataModbFeeder[2];
		Feeder.Inputs.Comms.iAlarmWord1 := gReceivedDataModbFeeder[3];
		Feeder.Inputs.Comms.iAlarmWord2 := gReceivedDataModbFeeder[4];
		Feeder.Inputs.Comms.iAlarmWord3 := gReceivedDataModbFeeder[5];
		Feeder.Inputs.Comms.iAlarmWord4 := gReceivedDataModbFeeder[6];
		Feeder.Inputs.Comms.iAlarmWord5 := gReceivedDataModbFeeder[7];
		Feeder.Inputs.Comms.iAlarmWord6 := gReceivedDataModbFeeder[8];
		Feeder.Inputs.Comms.iStatus := gReceivedDataModbFeeder[9];
		Feeder.Inputs.Comms.iAlarmWord7 := gReceivedDataModbFeeder[10];
		Feeder.Inputs.Comms.iAlarmWord8 := gReceivedDataModbFeeder[11];
		Feeder.Inputs.Comms.iAlarmWord9 := gReceivedDataModbFeeder[12];
		Feeder.Inputs.Comms.iAlarmWord10 := gReceivedDataModbFeeder[13];
		Feeder.Inputs.Comms.iAlarmWord11 := gReceivedDataModbFeeder[14];
		Feeder.Inputs.Comms.iAlarmWord12 := gReceivedDataModbFeeder[15];
		Feeder.Inputs.Comms.iNumFedBoards := gReceivedDataModbFeeder[16];
		Feeder.Inputs.Comms.iAlarmWord13 := gReceivedDataModbFeeder[17];
		Feeder.Inputs.Comms.iAlarmWord14 := gReceivedDataModbFeeder[18];
		Feeder.Inputs.Comms.iAlarmWord15 := gReceivedDataModbFeeder[19];
		Feeder.Inputs.Comms.iVersion1 := gReceivedDataModbFeeder[20];
		Feeder.Inputs.Comms.iVersion2 := gReceivedDataModbFeeder[21];
		Feeder.Inputs.Comms.iVersion3 := gReceivedDataModbFeeder[22];
		Feeder.Inputs.Comms.iVersion4 := gReceivedDataModbFeeder[23];
		//:= gReceivedDataModbFeeder[24];
		//:= gReceivedDataModbFeeder[25];
	END_IF
	
	//Post bit treatment
	Feeder.Inputs.Comms.xRemote := Feeder.Inputs.Comms.iStatus.0;
	Feeder.Inputs.Comms.xAlarmPresent := Feeder.Inputs.Comms.iStatus.1;
	Feeder.Inputs.Comms.xPositionReady := Feeder.Inputs.Comms.iStatus.2;
	Feeder.Inputs.Comms.xOrderEnd := Feeder.Inputs.Comms.iStatus.3;
	Feeder.Inputs.Comms.xMinimumStackLevelL1 := Feeder.Inputs.Comms.iStatus.4;
	Feeder.Inputs.Comms.xMinimumStackLevelL2 := Feeder.Inputs.Comms.iStatus.5;
	Feeder.Inputs.Comms.xEnableFeeding := Feeder.Inputs.Comms.iStatus.6;
	Feeder.Inputs.Comms.xOnline := Feeder.Inputs.Comms.iStatus.7;

END_ACTION
