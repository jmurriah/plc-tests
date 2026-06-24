
ACTION AssignDataComms:
	
	//Active modbus slave diagnosis when ancillary is enabled. This parameter must remain to TRUE from then on.
	//Just would be set to FALSE via UaExpert, to reset historic errors when ancillary is disabled
	OverVarnish.Parameters.xActiveSlaveDiagnosis := TRUE;
	
	xBoardParametersChanged := 	(OverVarnish.Parameters.Media.rWidth<>rPrevWidth) OR
								(OverVarnish.Parameters.Media.rLength<>rPrevLength) OR
								(OverVarnish.Parameters.Media.rThickness<>rPrevThickness) OR
								(OverVarnish.Parameters.Media.rGap<>rPrevGap);
	
	rPrevWidth:=OverVarnish.Parameters.Media.rWidth;
	rPrevLength:=OverVarnish.Parameters.Media.rLength;
	rPrevThickness:=OverVarnish.Parameters.Media.rThickness;
	rPrevGap:=OverVarnish.Parameters.Media.rGap;
	
	tof_BoardParametersChanged.IN:=xBoardParametersChanged;
	tof_BoardParametersChanged.PT:=t#1s;
	tof_BoardParametersChanged();
	
	
	IF OverVarnish.Status.OpvType = OPVTY_DMS THEN
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
		IF gToWriteDataModbOpv[iIndex]<>CopyOfWriteData[iIndex] THEN
			xDisableWriteData := FALSE;
		END_IF
	END_FOR
	
	OverVarnish.Orders.xDisableWriteBlock := xDisableWriteData;
	
	//Copying previous data
	CopyOfWriteData := gToWriteDataModbOpv;
	
END_ACTION


ACTION DmsComms:
	
			/////////////////
			//Pre bits treatment
			OverVarnish.Outputs.Comms.iControl.1 := OverVarnish.Commands.xEnteringMedia;
			OverVarnish.Outputs.Comms.iControl.2 := OverVarnish.Commands.xNewBoardParameters:=tof_BoardParametersChanged.Q;
			//OverVarnish.Outputs.Comms.iControl.3 := ;
			OverVarnish.Outputs.Comms.iControl.4 := TRUE; //OverVarnish.Outputs.Comms.xLineAirSupply;
			OverVarnish.Outputs.Comms.iControl.5 := OverVarnish.Parameters.LineState = LINE_PREPARING_EMPTYBELT OR 
													OverVarnish.Parameters.LineState = LINE_STARTING_EMPTYBELT OR 
													OverVarnish.Parameters.LineState = LINE_BELT_EMPTYING;
	
			OverVarnish.Outputs.Comms.iControl2.13 := FALSE; //Single line:0, Double line: 1
			OverVarnish.Outputs.Comms.iControl2.15 := TRUE; //Edge:0, Center: 1
				
			//Write Registers
			gToWriteDataModbOpv[1] := REAL_TO_UINT(OverVarnish.Parameters.Media.rWidth*10); 
			gToWriteDataModbOpv[2] := REAL_TO_UINT(OverVarnish.Parameters.Media.rLength*10);
			gToWriteDataModbOpv[3] := REAL_TO_UINT(OverVarnish.Parameters.Media.rThickness*10);
			gToWriteDataModbOpv[4] := REAL_TO_UINT(OverVarnish.Parameters.Media.rGap*10);
			//gToWriteDataModbOpv[5] := ;
			gToWriteDataModbPrimer[6] := REAL_TO_UINT(OverVarnish.Parameters.rLineAccelRate*60); //150;
			gToWriteDataModbPrimer[7] := REAL_TO_UINT(OverVarnish.Parameters.rLineDecelRate*60); //150;
			gToWriteDataModbOpv[8] := REAL_TO_UINT(OverVarnish.Parameters.rSpeedSetPoint*100);
			gToWriteDataModbOpv[9] := OverVarnish.Outputs.Comms.iControl;
			gToWriteDataModbOpv[10] := OverVarnish.Outputs.Comms.iControl2;
			//gToWriteDataModbOpv[11] := ;
			//gToWriteDataModbOpv[12] := ;
			//gToWriteDataModbOpv[13] := ;
			gToWriteDataModbOpv[14] := REAL_TO_UINT(OverVarnish.Parameters.rLineAccelRate*60); //150;
			gToWriteDataModbOpv[15] := REAL_TO_UINT(OverVarnish.Parameters.rLineDecelRate*60); //150;
			(*
			gToWriteDataModbOpv[16] := ;
			gToWriteDataModbOpv[17] := ;
			gToWriteDataModbOpv[18] := ;
			gToWriteDataModbOpv[19] := ;
			gToWriteDataModbOpv[20] := ;
			gToWriteDataModbOpv[21] := ;
			gToWriteDataModbOpv[22] := ;
			gToWriteDataModbOpv[23] := ;
			gToWriteDataModbOpv[24] := ;
			gToWriteDataModbOpv[25] := ;
			*)
		
		
		
		////////////////
		//Read Registers
		IF OverVarnish.Status.Comms.xModuleOk THEN
			OverVarnish.Inputs.Comms.iStatus := gReceivedDataModbOpv[1];
			//OverVarnish.Inputs.Comms. := gReceivedDataModbOpv[2];
			OverVarnish.Inputs.Comms.uiCoaterRollerSpeed := gReceivedDataModbOpv[3];
			OverVarnish.Inputs.Comms.uiTransportSpeed := gReceivedDataModbOpv[4];
			(*
			:= gReceivedDataModbOpv[5];
			:= gReceivedDataModbOpv[6];
			:= gReceivedDataModbOpv[7];
			:= gReceivedDataModbOpv[8];
			:= gReceivedDataModbOpv[9];
			:= gReceivedDataModbOpv[10];
			:= gReceivedDataModbOpv[11];
			:= gReceivedDataModbOpv[12];
			:= gReceivedDataModbOpv[13];
			:= gReceivedDataModbOpv[14];
			:= gReceivedDataModbOpv[15];
			*)
			OverVarnish.Inputs.Comms.iVersion1 := gReceivedDataModbOpv[16];
			OverVarnish.Inputs.Comms.iVersion2 := gReceivedDataModbOpv[17];
			OverVarnish.Inputs.Comms.iVersion3 := gReceivedDataModbOpv[18];
			OverVarnish.Inputs.Comms.iVersion4 := gReceivedDataModbOpv[19];
			(*
			:= gReceivedDataModbOpv[20];
			:= gReceivedDataModbOpv[21];
			:= gReceivedDataModbOpv[22];
			:= gReceivedDataModbOpv[23];
			:= gReceivedDataModbOpv[24];
			:= gReceivedDataModbOpv[25];
			*)
			
	END_IF
		
		//Post bit treatment
		OverVarnish.Inputs.Comms.xRemote := OverVarnish.Inputs.Comms.iStatus.1;
		OverVarnish.Inputs.Comms.xBeltEmpty := OverVarnish.Inputs.Comms.iStatus.3;
		OverVarnish.Inputs.Comms.xStopButtonPressed := OverVarnish.Inputs.Comms.iStatus.10;
	
END_ACTION

ACTION DefaultPrimerComms:
	
		/////////////////
		//Pre bits treatment
		//OverVarnish.Outputs.Comms.iControl.0 := ;
		//OverVarnish.Outputs.Comms.iControl.1 := ;
		OverVarnish.Outputs.Comms.iControl.2 := OverVarnish.Commands.xNewBoardParameters := tof_BoardParametersChanged.Q;
		//Primer.Outputs.Comms.iControl.3 := ;
		//Primer.Outputs.Comms.iControl.4 := ;
		OverVarnish.Outputs.Comms.iControl.5 := OverVarnish.Parameters.LineState = LINE_PREPARING_EMPTYBELT OR 
												OverVarnish.Parameters.LineState = LINE_STARTING_EMPTYBELT OR 
												OverVarnish.Parameters.LineState = LINE_BELT_EMPTYING;

	
		//Write Registers
		gToWriteDataModbOpv[1] := OverVarnish.Outputs.Comms.iControl; 
		gToWriteDataModbOpv[2] := REAL_TO_UINT(OverVarnish.Parameters.Media.rLength*10);
		gToWriteDataModbOpv[3] := REAL_TO_UINT(OverVarnish.Parameters.Media.rWidth*10);
		gToWriteDataModbOpv[4] := REAL_TO_UINT(OverVarnish.Parameters.Media.rThickness*10);
		gToWriteDataModbOpv[5] := REAL_TO_UINT(OverVarnish.Parameters.Media.rGap*10);
		gToWriteDataModbPrimer[6] := REAL_TO_UINT(OverVarnish.Parameters.rLineAccelRate*60); //150;
		gToWriteDataModbPrimer[7] := REAL_TO_UINT(OverVarnish.Parameters.rLineDecelRate*60); //150;
		gToWriteDataModbOpv[8] := REAL_TO_UINT(OverVarnish.Parameters.rSpeedSetPoint*10);
		(*
		gToWriteDataModbOpv[9] := ;
		gToWriteDataModbOpv[10] := ;
		gToWriteDataModbOpv[11] := ;
	
		gToWriteDataModbOpv[12] := ;
		gToWriteDataModbOpv[13] := ;
		gToWriteDataModbOpv[14] := ;
		gToWriteDataModbOpv[15] := ;
		gToWriteDataModbOpv[16] := ;
		gToWriteDataModbOpv[17] := ;
		gToWriteDataModbOpv[18] := ;
		gToWriteDataModbOpv[19] := ;
		gToWriteDataModbOpv[20] := ;
		gToWriteDataModbOpv[21] := ;
		gToWriteDataModbOpv[22] := ;
		gToWriteDataModbOpv[23] := ;
		gToWriteDataModbOpv[24] := ;
		gToWriteDataModbOpv[25] := ;
		*)
		
		
		
		////////////////
		//Read Registers
		IF OverVarnish.Status.Comms.xModuleOk THEN
			OverVarnish.Inputs.Comms.iStatus := gReceivedDataModbOpv[1];
			//Primer.Inputs.Comms. := gReceivedDataModbOpv[2];
			OverVarnish.Inputs.Comms.uiCoaterRollerSpeed := gReceivedDataModbOpv[3];
			OverVarnish.Inputs.Comms.uiTransportSpeed := gReceivedDataModbOpv[4];
			(*
			:= gReceivedDataModbOpv[5];
			:= gReceivedDataModbOpv[6];
			:= gReceivedDataModbOpv[7];
			:= gReceivedDataModbOpv[8];
			:= gReceivedDataModbOpv[9];
			:= gReceivedDataModbOpv[10];
			:= gReceivedDataModbOpv[11];
			:= gReceivedDataModbOpv[12];
			:= gReceivedDataModbOpv[13];
			:= gReceivedDataModbOpv[14];
			:= gReceivedDataModbOpv[15];
			*)
			OverVarnish.Inputs.Comms.iVersion1 := gReceivedDataModbOpv[16];
			OverVarnish.Inputs.Comms.iVersion2 := gReceivedDataModbOpv[17];
			OverVarnish.Inputs.Comms.iVersion3 := gReceivedDataModbOpv[18];
			OverVarnish.Inputs.Comms.iVersion4 := gReceivedDataModbOpv[19];
			(*
			:= gReceivedDataModbOpv[20];
			:= gReceivedDataModbOpv[21];
			:= gReceivedDataModbOpv[22];
			:= gReceivedDataModbOpv[23];
			:= gReceivedDataModbOpv[24];
			:= gReceivedDataModbOpv[25];
			*)
		END_IF
	
		//Post bit treatment
		// := OverVarnish.Inputs.Comms.iStatus.0;
		// := OverVarnish.Inputs.Comms.iStatus.1;
		// := OverVarnish.Inputs.Comms.iStatus.2;
		// := OverVarnish.Inputs.Comms.iStatus.3;
		// := OverVarnish.Inputs.Comms.iStatus.4;
		// := OverVarnish.Inputs.Comms.iStatus.5;
		// := OverVarnish.Inputs.Comms.iStatus.6;
		// := OverVarnish.Inputs.Comms.iStatus.7;
		OverVarnish.Inputs.Comms.xRemote := OverVarnish.Inputs.Comms.iStatus.8;
		OverVarnish.Inputs.Comms.xBeltEmpty := OverVarnish.Inputs.Comms.iStatus.9;
		// := OverVarnish.Inputs.Comms.iStatus.10;
	

END_ACTION