ACTION CheckLampsConfig:
	
	IF (xBoardPositionChanged OR dataLed.Alarms.xPowerFailure OR NOT dataLed.Commands.PowerOn OR EDGEPOS(xConfigurationFailed)) THEN
		CheckStep := CHECK_INIT;
	END_IF
	
	CASE CheckStep OF
		
		CHECK_INIT:
			IF dataLed.Status.xLampsConfigured THEN
				iIndexConfigLamps := 1;
				dataLed.Comms.Device.receive_data := '';
				FOR iIndexEraseReceivedData:=1 TO iLampsQuantity DO
					dataLed.Lamp[iIndexConfigLamps].Parameters.sSystemStatusFeedback := '';
				END_FOR
				CheckStep := CHECK_READ_CONFIG;
			END_IF
					
		
		CHECK_READ_CONFIG:			
			//To set the message string
			ReadLampStatus;
			
			//To send command to lamp
			dataLed.Comms.Command.Send := TRUE;

			IF (dataLed.Comms.Device.receive_data <> '') THEN
				iSupplySide := 0;
				CheckStep := CHECK_UPDATE_STATUS;
			END_IF
			
		
		CHECK_UPDATE_STATUS:
			iNumLampSLM := dataLed.Lamp[iIndexConfigLamps].Parameters.iNumSLM; //Number of lamp's SLMs
			iMinBufferLength := 436 + iNumLampSLM*5; //DELOREAN-1923: Minimum buffer length when lamp gives all slm feedback is: 436+iNumLampSLM*5 (f.e: "1=On ")
			
			iSupplySide := FIND(dataLed.Comms.Device.receive_data, 'Supply Side');
			xValidStatusReading := iSupplySide>0;
			//IF dataLed.Comms.Device.FRM_read_0.buflng > 500(*iMinBufferLength*) THEN
			IF xValidStatusReading THEN
				iCheckStatusAttempts := 0;
				xSLMStatusRead := TRUE;
				
				//Saving slms status as lamp parameter
				FindInString := INT_TO_STRING(1);
				strcat(ADR(FindInString),ADR('='));
				iAnswerStringPosition := FIND(dataLed.Comms.Device.receive_data, FindInString);
				dataLed.Lamp[iIndexConfigLamps].Parameters.sSystemStatusFeedback := MID(dataLed.Comms.Device.receive_data, 280, iAnswerStringPosition);
				
				FOR iIndexConfigSlm:=1 TO iNumLampSLM DO
					CheckSlmStatus;
				END_FOR
				
				IF xSLMStatusRead THEN
					NextLamp;
				ELSE
					dataLed.Comms.Device.receive_data := '';
					CheckStep := CHECK_READ_CONFIG;
				END_IF
			
			ELSIF (iCheckStatusAttempts >= iMaxNumAttempts) THEN
				dataLed.Alarms.Lamps[iIndexConfigLamps].StatusFeedbackFault := TRUE;
				NextLamp;
				
			ELSIF dataLed.Comms.Device.step = FRM_WAIT THEN
				iCheckStatusAttempts := iCheckStatusAttempts + 1;
				dataLed.Comms.Device.receive_data := '';
				CheckStep := CHECK_READ_CONFIG;
			END_IF
			
		
		CHECK_READY:

		
	END_CASE
	
	dataLed.Comms.Device.send_data := StMessage; //To assign Message to dataled comms struct
	dataLed.Status.xLampsChecked := CheckStep = CHECK_READY;
		
END_ACTION


//Telegrams to be sent to curing led devices//
//To enable all slm in the lamp
ACTION ReadLampStatus:
	//To define the string to be sent to the lamp
	StMessage := StCmdRead;
	//strcat: Used to link (concat) several strings
	strcat(ADR(StMessage), ADR(dataLed.Lamp[iIndexConfigLamps].Status.stSerialNumber));
	strcat(ADR(StMessage), ADR(StMl));
	strcat(ADR(StMessage), ADR(StDs));
	//dataLed.Comms.Device.send_data := StMessage; //To assign Message to dataled comms struct
	
	iAnswerStringLength := 2;
	
	//This is the data received when reading status of a led. SLM status shown for a lamp with all SLM disabled:
	(*
	Product..........: Fire_Line_400_300, s/n 414086m1
	Firmware Ver.....: 01.02
	Log Entries......: 1020
	SLM Enables......:
	Supply Side 1=Off 2=Off 3=Off 4=Off 5=Off 6=Off 7=Off 8=Off 9=Off 10=Off 11=Off 12=Off Return Side
	SW-Disable Low.....: High
	SW-Enable High...: Low
	Global Control...: DB15
	Intensity........: 100
	Temperature......: 36.4
	Inputvolt........: 49.8
	Thermal Switch...: Enabled
	*)
END_ACTION

ACTION NextLamp:

	//Erasing buffer and going to next lamp
	iIndexConfigLamps := iIndexConfigLamps + 1;
	IF iIndexConfigLamps <= iLampsQuantity THEN
		dataLed.Comms.Device.receive_data := '';
		CheckStep := CHECK_READ_CONFIG;
	ELSE
		CheckStep := CHECK_READY;
	END_IF
END_ACTION

ACTION CheckSlmStatus:
	FindInString := INT_TO_STRING(iIndexConfigSlm);
	strcat(ADR(FindInString),ADR('='));
	iAnswerStringPosition := FIND(dataLed.Comms.Device.receive_data, FindInString);
	IF iIndexConfigSlm<10 THEN iAnswerStringPosition := iAnswerStringPosition+2; ELSE iAnswerStringPosition := iAnswerStringPosition+3; END_IF //X=On/Off
	StAnswer := MID(dataLed.Comms.Device.receive_data, iAnswerStringLength, iAnswerStringPosition);
					
	IF (StAnswer = StOn) THEN
		dataLed.Lamp[iIndexConfigLamps].Outputs.xSlmStatus[iIndexConfigSlm]:=TRUE;
	ELSIF (StAnswer = StOff) THEN
		dataLed.Lamp[iIndexConfigLamps].Outputs.xSlmStatus[iIndexConfigSlm]:=FALSE;
	ELSE
		xSLMStatusRead := FALSE;
	END_IF
END_ACTION


