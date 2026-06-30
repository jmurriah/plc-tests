ACTION ReadUvOnTime:
	
	IF NOT dataLed.Status.xLampsDetected OR (dataLed.Status.xCureByStretch AND NOT dataLed.Status.xLampsChecked) OR ReadingTemperatureStep <> READINGTEMP_NOT_INIT THEN
		ReadingUvOnTimeStep := READINGUVTIME_NOT_INIT;
	END_IF
	
	
	CASE ReadingUvOnTimeStep OF
					
		READINGUVTIME_NOT_INIT:
			iIndexReadUvOnTimeLamps := 1;
			IF (NOT dataLed.Parameters.xPhysicalTempFeedback AND EDGEPOS(ReadingTemperatureStep = READINGTEMP_NOT_INIT) OR 
				dataLed.Parameters.xPhysicalTempFeedback)
				THEN
				ReadingUvOnTimeStep := READINGUVTIME_INIT;
			END_IF
			
			
		READINGUVTIME_INIT:
			dataLed.Comms.Command.Close := TRUE;
			dataLed.Comms.Device.receive_data := '';
			
			ReadingUvOnTimeStep := READINGUVTIME_READING;
		
		READINGUVTIME_READING:
			
			ReadLampUvOnTime;
			StAnswer := MID(dataLed.Comms.Device.receive_data, iAnswerStringLength, iAnswerStringPosition);
			IF (StAnswer<>'') THEN
				ReadingUvOnTimeStep := READINGUVTIME_READY;
				
			ELSIF (dataLed.Comms.Device.step = FRM_WAIT)THEN
				//To send command to lamp
				dataLed.Comms.Command.Send := TRUE;
			END_IF
				
		READINGUVTIME_READY:
			
			dataLed.Lamp[iIndexReadUvOnTimeLamps].Status.rUvOnTime := brsatof(ADR(StAnswer));
			dataLed.Lamp[iIndexReadUvOnTimeLamps].Status.stUvOnTimeRaw := StAnswer;
			ReadNextLampUvOnTime;
		
	END_CASE

	dataLed.Comms.Device.send_data := StMessage;
	
	
END_ACTION

//Telegrams to be sent to curing led devices//
//To read lamp's intensity setpoint
ACTION ReadLampUvOnTime:
	//To define the string to be sent to the lamp
	StMessage := StCmdRead;
	//strcat: Used to link (concat) several strings
	strcat(ADR(StMessage), ADR(dataLed.Lamp[iIndexReadUvOnTimeLamps].Status.stSerialNumber));
	strcat(ADR(StMessage), ADR(StMl));
	strcat(ADR(StMessage), ADR(' uvt'));
	
	iAnswerStringLength := 10;
	iAnswerStringPosition := 1;
	
END_ACTION

ACTION ReadNextLampUvOnTime:

	//Erasing buffer and going to next lamp
	iIndexReadUvOnTimeLamps := iIndexReadUvOnTimeLamps + 1;
	IF iIndexReadUvOnTimeLamps <= iLampsQuantity THEN
		ReadingUvOnTimeStep := READINGUVTIME_INIT;
	ELSE
		ReadingUvOnTimeStep := READINGUVTIME_NOT_INIT;
	END_IF
	
END_ACTION
