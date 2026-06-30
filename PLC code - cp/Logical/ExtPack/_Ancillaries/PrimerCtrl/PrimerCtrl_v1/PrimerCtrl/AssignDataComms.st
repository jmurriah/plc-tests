
ACTION AssignDataComms:
	
	//Active modbus slave diagnosis when ancillary is enabled. This parameter must remain to TRUE from then on.
	//Just would be set to FALSE via UaExpert, to reset historic errors when ancillary is disabled
	Primer.Parameters.xActiveSlaveDiagnosis := TRUE;

	
	xBoardParametersChanged := 	(Primer.Parameters.Media.rWidth<>rPrevWidth) OR
								(Primer.Parameters.Media.rLength<>rPrevLength) OR
								(Primer.Parameters.Media.rThickness<>rPrevThickness) OR
								(Primer.Parameters.Media.rGap<>rPrevGap);
	
	rPrevWidth:=Primer.Parameters.Media.rWidth;
	rPrevLength:=Primer.Parameters.Media.rLength;
	rPrevThickness:=Primer.Parameters.Media.rThickness;
	rPrevGap:=Primer.Parameters.Media.rGap;
	
	tof_BoardParametersChanged.IN:=xBoardParametersChanged;
	tof_BoardParametersChanged.PT:=t#1s;
	tof_BoardParametersChanged();
	
	
	IF Primer.Status.PrimerType = PRIMERTY_DMS THEN
		DmsComms;
		
	ELSE
		DefaultPrimerComms;
	END_IF
	
	
	//Disabling writting after some time active. To test
	tonDisableWrittingOfData.IN:= NOT xDisableWriteData;
	tonDisableWrittingOfData.PT:= T#1000ms;
	tonDisableWrittingOfData();
	
	IF tonDisableWrittingOfData.Q THEN
		xDisableWriteData := TRUE; 
	END_IF
	
	FOR iIndex:=1 TO 25 DO
		IF gToWriteDataModbPrimer[iIndex]<>CopyOfWriteData[iIndex] THEN
			xDisableWriteData := FALSE;
		END_IF
	END_FOR
	
	Primer.Orders.xDisableWriteBlock := xDisableWriteData;
		
	//Copying previous data
	CopyOfWriteData := gToWriteDataModbPrimer;
	
END_ACTION

ACTION DmsComms:
	
		/////////////////
		//Pre bits treatment
		Primer.Outputs.Comms.iControl.1 := Primer.Commands.xEnteringMedia;
		Primer.Outputs.Comms.iControl.2 := Primer.Commands.xNewBoardParameters:=tof_BoardParametersChanged.Q;
		//Primer.Outputs.Comms.iControl.3 := ;
		Primer.Outputs.Comms.iControl.4 := TRUE; //Primer.Outputs.Comms.xLineAirSupply;
		Primer.Outputs.Comms.iControl.5 := 	Primer.Parameters.LineState = LINE_PREPARING_EMPTYBELT OR 
											Primer.Parameters.LineState = LINE_STARTING_EMPTYBELT OR 
											Primer.Parameters.LineState = LINE_BELT_EMPTYING;

		Primer.Outputs.Comms.iControl2.13 := FALSE; //Single line:0, Double line: 1
		Primer.Outputs.Comms.iControl2.15 := TRUE; //Edge:0, Center: 1
	
		//Write Registers
		gToWriteDataModbPrimer[1] := REAL_TO_UINT(Primer.Parameters.Media.rWidth*10); 
		gToWriteDataModbPrimer[2] := REAL_TO_UINT(Primer.Parameters.Media.rLength*10);
		gToWriteDataModbPrimer[3] := REAL_TO_UINT(Primer.Parameters.Media.rThickness*10);
		gToWriteDataModbPrimer[4] := REAL_TO_UINT(Primer.Parameters.Media.rGap*10);
		//gToWriteDataModbPrimer[5] := ;
		gToWriteDataModbPrimer[6] := REAL_TO_UINT(Primer.Parameters.rLineAccelRate*60); //150;
		gToWriteDataModbPrimer[7] := REAL_TO_UINT(Primer.Parameters.rLineDecelRate*60); //150;
		gToWriteDataModbPrimer[8] := REAL_TO_UINT(Primer.Parameters.rBeltSpeedSetPoint*100);
		gToWriteDataModbPrimer[9] := Primer.Outputs.Comms.iControl;;
		gToWriteDataModbPrimer[10] := Primer.Outputs.Comms.iControl2;
		(*
		gToWriteDataModbPrimer[11] := ;
		gToWriteDataModbPrimer[12] := ;
		gToWriteDataModbPrimer[13] := ;
		gToWriteDataModbPrimer[14] := ;
		gToWriteDataModbPrimer[15] := ;
		
		gToWriteDataModbPrimer[16] := ;
		gToWriteDataModbPrimer[17] := ;
	
		gToWriteDataModbPrimer[18] := ;
		gToWriteDataModbPrimer[19] := ;
		gToWriteDataModbPrimer[20] := ;
		
		gToWriteDataModbPrimer[21] := ;
		gToWriteDataModbPrimer[22] := ;
		gToWriteDataModbPrimer[23] := ;
		gToWriteDataModbPrimer[24] := ;
		gToWriteDataModbPrimer[25] := ;
		*)
	
	
	
		////////////////
		//Read Registers
		IF Primer.Status.Comms.xModuleOk THEN
			Primer.Inputs.Comms.iStatus := gReceivedDataModbPrimer[1];
			//Primer.Inputs.Comms. := gReceivedDataModbPrimer[2];
			Primer.Inputs.Comms.uiCoaterRollerSpeed := gReceivedDataModbPrimer[3];
			Primer.Inputs.Comms.uiTransportSpeed := gReceivedDataModbPrimer[4];
			(*
			:= gReceivedDataModbPrimer[5];
			:= gReceivedDataModbPrimer[6];
			:= gReceivedDataModbPrimer[7];
			:= gReceivedDataModbPrimer[8];
			:= gReceivedDataModbPrimer[9];
			:= gReceivedDataModbPrimer[10];
			
			:= gReceivedDataModbPrimer[11];
			:= gReceivedDataModbPrimer[12];
			:= gReceivedDataModbPrimer[13];
			:= gReceivedDataModbPrimer[14];
			:= gReceivedDataModbPrimer[15];
			*)
			Primer.Inputs.Comms.iVersion1 := gReceivedDataModbPrimer[16];
			Primer.Inputs.Comms.iVersion2 := gReceivedDataModbPrimer[17];
			Primer.Inputs.Comms.iVersion3 := gReceivedDataModbPrimer[18];
			Primer.Inputs.Comms.iVersion4 := gReceivedDataModbPrimer[19];
			(*
			:= gReceivedDataModbPrimer[20];
			:= gReceivedDataModbPrimer[21];
			:= gReceivedDataModbPrimer[22];
			:= gReceivedDataModbPrimer[23];
			:= gReceivedDataModbPrimer[24];
			:= gReceivedDataModbPrimer[25];
			*)
	END_IF
	
		//Post bit treatment
		Primer.Inputs.Comms.xRemote := Primer.Inputs.Comms.iStatus.1;
		Primer.Inputs.Comms.xBeltEmpty := Primer.Inputs.Comms.iStatus.3;
		Primer.Inputs.Comms.xStopButtonPressed := Primer.Inputs.Comms.iStatus.10;
		
END_ACTION

ACTION DefaultPrimerComms:

		/////////////////
		//Pre bits treatment
		//Primer.Outputs.Comms.iControl.0 := ;
		//Primer.Outputs.Comms.iControl.1 := ;
		Primer.Outputs.Comms.iControl.2 := Primer.Commands.xNewBoardParameters := tof_BoardParametersChanged.Q;
		//Primer.Outputs.Comms.iControl.3 := ;
		//Primer.Outputs.Comms.iControl.4 := Primer.Outputs.Comms.xLineAirSupply;
		Primer.Outputs.Comms.iControl.5 := 	Primer.Parameters.LineState = LINE_PREPARING_EMPTYBELT OR 
											Primer.Parameters.LineState = LINE_STARTING_EMPTYBELT OR 
											Primer.Parameters.LineState = LINE_BELT_EMPTYING;
	
		Primer.Outputs.Comms.iControl.6 := Primer.Parameters.xDoubleLine;
		
		//Write Registers
		gToWriteDataModbPrimer[1] := Primer.Outputs.Comms.iControl; 
		gToWriteDataModbPrimer[2] := REAL_TO_UINT(Primer.Parameters.Media.rLength*10);
		gToWriteDataModbPrimer[3] := REAL_TO_UINT(Primer.Parameters.Media.rWidth*10);
		gToWriteDataModbPrimer[4] := REAL_TO_UINT(Primer.Parameters.Media.rThickness*10);
		gToWriteDataModbPrimer[5] := REAL_TO_UINT(Primer.Parameters.Media.rGap*10);
		gToWriteDataModbPrimer[6] := REAL_TO_UINT(Primer.Parameters.rLineAccelRate*60); //150;
		gToWriteDataModbPrimer[7] := REAL_TO_UINT(Primer.Parameters.rLineDecelRate*60); //150;
		gToWriteDataModbPrimer[8] := REAL_TO_UINT(Primer.Parameters.rBeltSpeedSetPoint*10);
		(*gToWriteDataModbPrimer[9] := ;
		gToWriteDataModbPrimer[10] := ;
		gToWriteDataModbPrimer[11] := ;
	
		gToWriteDataModbPrimer[12] := ;
		gToWriteDataModbPrimer[13] := ;
		gToWriteDataModbPrimer[14] := ;
		gToWriteDataModbPrimer[15] := ;
		gToWriteDataModbPrimer[16] := ;
		gToWriteDataModbPrimer[17] := ;
		gToWriteDataModbPrimer[18] := ;
		gToWriteDataModbPrimer[19] := ;
		gToWriteDataModbPrimer[20] := ;
		gToWriteDataModbPrimer[21] := ;
		gToWriteDataModbPrimer[22] := ;
		gToWriteDataModbPrimer[23] := ;
		gToWriteDataModbPrimer[24] := ;
		gToWriteDataModbPrimer[25] := ;
		*)
		
		
		////////////////
		//Read Registers
		IF Primer.Status.Comms.xModuleOk THEN
			Primer.Inputs.Comms.iStatus := gReceivedDataModbPrimer[1];
			//Primer.Inputs.Comms. := gReceivedDataModbPrimer[2];
			Primer.Inputs.Comms.uiCoaterRollerSpeed := gReceivedDataModbPrimer[3];
			Primer.Inputs.Comms.uiTransportSpeed := gReceivedDataModbPrimer[4];
			(*
			:= gReceivedDataModbPrimer[5];
			:= gReceivedDataModbPrimer[6];
			:= gReceivedDataModbPrimer[7];
			:= gReceivedDataModbPrimer[8];
			:= gReceivedDataModbPrimer[9];
			:= gReceivedDataModbPrimer[10];
			
			:= gReceivedDataModbPrimer[11];
			:= gReceivedDataModbPrimer[12];
			:= gReceivedDataModbPrimer[13];
			:= gReceivedDataModbPrimer[14];
			:= gReceivedDataModbPrimer[15];
			*)
			Primer.Inputs.Comms.iVersion1 := gReceivedDataModbPrimer[16];
			Primer.Inputs.Comms.iVersion2 := gReceivedDataModbPrimer[17];
			Primer.Inputs.Comms.iVersion3 := gReceivedDataModbPrimer[18];
			Primer.Inputs.Comms.iVersion4 := gReceivedDataModbPrimer[19];
			(*
			:= gReceivedDataModbPrimer[20];
			:= gReceivedDataModbPrimer[21];
			:= gReceivedDataModbPrimer[22];
			:= gReceivedDataModbPrimer[23];
			:= gReceivedDataModbPrimer[24];
			:= gReceivedDataModbPrimer[25];
			*)
	END_IF
		
		//Post bit treatment
		Primer.Inputs.Comms.xRemote := Primer.Inputs.Comms.iStatus.8;
		Primer.Inputs.Comms.xBeltEmpty := Primer.Inputs.Comms.iStatus.9;

		
END_ACTION