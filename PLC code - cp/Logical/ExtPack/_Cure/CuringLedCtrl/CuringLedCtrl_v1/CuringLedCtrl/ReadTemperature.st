ACTION ReadTemperature:
	
	IF NOT dataLed.Status.xLampsDetected OR (dataLed.Status.xCureByStretch AND NOT dataLed.Status.xLampsChecked) THEN
		ReadingTemperatureStep := READINGTEMP_NOT_INIT;
	END_IF
	
	
	CASE ReadingTemperatureStep OF
					
		READINGTEMP_NOT_INIT:
			iIndexReadTempLamps := 1;
			IF (ReadingUvOnTimeStep = READINGUVTIME_NOT_INIT) THEN
				ReadingTemperatureStep := READINGTEMP_INIT;
			END_IF
			
		READINGTEMP_INIT:
			dataLed.Comms.Command.Close := TRUE;
			dataLed.Comms.Device.receive_data := '';
			
			ReadingTemperatureStep := READINGTEMP_READING;
		
		READINGTEMP_READING:
			
			ReadLampTemperature;
			StAnswer := MID(dataLed.Comms.Device.receive_data, iAnswerStringLength, iAnswerStringPosition);
			IF (StAnswer<>'') THEN // AND (StAnswerAux<>'') THEN
				ReadingTemperatureStep := READINGTEMP_READY;
				
			ELSIF (dataLed.Comms.Device.step = FRM_WAIT)THEN
				//To send command to lamp
				dataLed.Comms.Command.Send := TRUE;
			END_IF
				
		READINGTEMP_READY:
			
			dataLed.Lamp[iIndexReadTempLamps].Status.rTemp := brsatof(ADR(StAnswer));
			
			// Assigning value to value assigned if there is an analog card 
			dataLed.Lamp[iIndexReadTempLamps].Outputs.rTemperature := dataLed.Lamp[iIndexReadTempLamps].Status.rTemp;
			
			ReadNextLampTemp;
		
	END_CASE

	dataLed.Comms.Device.send_data := StMessage;
	
	
END_ACTION

//Telegrams to be sent to curing led devices//
//To read lamp's intensity setpoint
ACTION ReadLampTemperature:
	//To define the string to be sent to the lamp
	StMessage := StCmdRead;
	//strcat: Used to link (concat) several strings
	strcat(ADR(StMessage), ADR(dataLed.Lamp[iIndexReadTempLamps].Status.stSerialNumber));
	strcat(ADR(StMessage), ADR(StMl));
	strcat(ADR(StMessage), ADR(StTemperature));
	
	iAnswerStringLength := 4;
	iAnswerStringPosition := 1;
	
END_ACTION

ACTION ReadNextLampTemp:

	//Erasing buffer and going to next lamp
	iIndexReadTempLamps := iIndexReadTempLamps + 1;
	IF iIndexReadTempLamps <= iLampsQuantity THEN
		ReadingTemperatureStep := READINGTEMP_INIT;
	ELSE
		ReadingTemperatureStep := READINGTEMP_NOT_INIT;
	END_IF
	
END_ACTION
