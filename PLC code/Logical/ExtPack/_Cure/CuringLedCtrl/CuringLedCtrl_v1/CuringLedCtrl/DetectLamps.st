ACTION DetectLamps:
	
	//Command to look for serial numbers
	IF EDGEPOS (dataLed.Commands.Manual.DetectLamps) THEN
		DetectStep := DETECTION_INIT;
		dataLed.Commands.Manual.DetectLamps := FALSE;
		dataLed.Comms.Command.Close := TRUE;
	END_IF
	
	//Timer to end FinishPolling step as a redundancy
	tonFinishPolling.IN := DetectStep = DETECTION_FINISHING_POLLING;
	tonFinishPolling.PT := T#30s;
	tonFinishPolling();
	
	
	CASE DetectStep OF
		
		DETECTION_NOT_INIT:
			//dataLed.Comms.Command.Close := TRUE; //[RGP]DELOREAN-1136. Close command executed in error state
			
		DETECTION_INIT:
			iIndexDetectLamps := 0;
			iIndexPreSerialNumbers := 1;
			
			//To reset lamp's serial numbers
			FOR iIndexDetectLamps:=1 TO iLampsQuantity DO
				dataLed.Lamp[iIndexDetectLamps].Status.stSerialNumber := '';
			END_FOR
			
			//To reset array of PreSerial numbers
			FOR i:=1 TO 15 DO
				aPreSerialNumbers[i] := '';
			END_FOR
			
			dataLed.Comms.Device.receive_data := '';
			DetectStep := DETECTION_POLLING;
		
		
		DETECTION_POLLING:
			Poll;
			
			IF (StAnswer<>'') THEN
				DetectStep := DETECTION_SAVE_SERIAL_NUMBERS;
			ELSIF dataLed.Comms.Device.step = FRM_WAIT THEN
				//To send command to lamp
				dataLed.Comms.Command.Send := TRUE;
			END_IF
		
			
		DETECTION_SAVE_SERIAL_NUMBERS:
			IF iIndexPreSerialNumbers <= iLampsQuantity THEN
				//Every time a poll message is sent, device writes one serial number
				//[RGP] 'Custom' is a message that lamps sends every x seconds so sometimes was being save as a valid serial number.
				IF (StAnswer <> '') AND (StAnswer <> 'Custom') THEN
					StMessage:='';
					xRepeated := FALSE;
					FOR iIndexDetectLamps:=1 TO iLampsQuantity DO
						IF (StAnswer = aPreSerialNumbers[iIndexDetectLamps]) THEN xRepeated := TRUE; END_IF
					END_FOR
						
					IF NOT xRepeated THEN
						aPreSerialNumbers[iIndexPreSerialNumbers] := StAnswer;
						iIndexPreSerialNumbers := iIndexPreSerialNumbers + 1;
					ELSE
						dataLed.Comms.Device.receive_data := '';
					END_IF
				
				ELSIF (dataLed.Comms.Device.step = FRM_WAIT)THEN
					//To send command to lamp
					dataLed.Comms.Command.Send := TRUE;
				END_IF
			ELSE
				dataLed.Comms.Device.receive_data := '';
				iIndexPreSerialNumbers := 1;
				DetectStep := DETECTION_FINISHING_POLLING; //DETECTION_READ_INTENSITY;
			END_IF
			
		
		DETECTION_FINISHING_POLLING:
			//StMessage:='';
			ReadFinishPolling;
			IF (StAnswer=StGoodAnswer OR tonFinishPolling.Q) THEN
				dataLed.Comms.Command.Close := TRUE;
				dataLed.Comms.Device.receive_data := '';
				DetectStep := DETECTION_READ_INTENSITY;
			ELSIF (dataLed.Comms.Device.step = FRM_WAIT) THEN
				//To send command to lamp
				dataLed.Comms.Command.Send := TRUE;
			END_IF
			
			
		DETECTION_READ_INTENSITY:
			ReadLampIntensity;
			
			IF (StAnswerAux='0') THEN
				DetectStep := DETECTION_ASSIGN_POSITION;
			ELSIF (dataLed.Comms.Device.step = FRM_WAIT)THEN
				//To send command to lamp
				dataLed.Comms.Command.Send := TRUE;
			END_IF
			
		
		DETECTION_ASSIGN_POSITION:
			IF iIndexPreSerialNumbers <= iLampsQuantity THEN
			
				//To assign a pre serial number saved to its lamp
				iDetectedLamp := STRING_TO_INT(StAnswer); //Convert number extracted from intensity, which match lamp position, to an INT to do the assignation
				IF (iDetectedLamp <= iLampsQuantity) THEN
					IF (dataLed.Lamp[iDetectedLamp].Status.stSerialNumber = '') THEN
						dataLed.Lamp[iDetectedLamp].Status.stSerialNumber := aPreSerialNumbers[iIndexPreSerialNumbers];
					END_IF
				END_IF
				
				//To know whether all lamps have a serial number assigned
				xKeepFilling := FALSE;
				FOR iIndexDetectLamps:=1 TO iLampsQuantity DO
					IF (dataLed.Lamp[iIndexDetectLamps].Status.stSerialNumber = '') THEN
						xKeepFilling := TRUE;
					END_IF
				END_FOR
				
				
				//All lamps have a SN assigned
				IF NOT xKeepFilling THEN
					iDetectLampAttempts := 0;
					DetectStep := DETECTION_READY;
				
				//Exceeded max number of attempts to find as serial numbers as quantity of lamps installed. To review RS485 wiring
				ELSIF iDetectLampAttempts >= iMaxNumAttempts OR iIndexPreSerialNum>iLampsQuantity THEN
					iDetectLampAttempts := 0;
					iIndexPreSerialNum := 1;
					dataLed.Comms.Device.receive_data := '';
					
				//To check next preSN saved
				ELSE
					iIndexPreSerialNumbers := iIndexPreSerialNumbers + 1;
					dataLed.Comms.Device.receive_data := '';
					DetectStep := DETECTION_READ_INTENSITY;
				END_IF
			END_IF
				
		DETECTION_READY:
			
		DETECTION_ERROR:
			dataLed.Comms.Command.Close := TRUE;
			IF dataLed.Commands.Reset THEN DetectStep := DETECTION_NOT_INIT; END_IF
		
	END_CASE
	
	//Process is cancelled in case machine mode goes out of manual and process were not finished or in error
	IF (NOT dataLed.Parameters.Mode.xManual) AND (DetectStep <> DETECTION_READY) AND (DetectStep <> DETECTION_ERROR) THEN
		DetectStep := DETECTION_ERROR; //[RGP]DELOREAN-1136: To set ERROR state when this conditions occur and then when reset command is received, go to NOT_INIT
	END_IF
	
	dataLed.Comms.Device.send_data := StMessage; //To assign Message to dataled comms struct
	StAnswer := MID(dataLed.Comms.Device.receive_data, iAnswerStringLength, iAnswerStringPosition);
	StAnswerAux := MID(dataLed.Comms.Device.receive_data, iAnswerStringLength, 1);
	dataLed.Status.DetectionState := DetectStep;
	
	xDetectionLampsProcessOn := (DetectStep <> DETECTION_NOT_INIT) AND
								(DetectStep <> DETECTION_READY) AND
								(DetectStep <> DETECTION_ERROR);
	
END_ACTION


ACTION Poll:
	//To define the string to be sent to the lamp
	StMessage := StPoll;
	iAnswerStringPosition := 1;
	iAnswerStringLength := 6;
END_ACTION
	
//Telegrams to be sent to curing led devices//
//To read lamp's intensity setpoint
ACTION ReadLampIntensity:
	//To define the string to be sent to the lamp
	StMessage := StCmdRead;
	//strcat: Used to link (concat) several strings
	strcat(ADR(StMessage), ADR(aPreSerialNumbers[iIndexPreSerialNumbers]));
	strcat(ADR(StMessage), ADR(StMl));
	strcat(ADR(StMessage), ADR(StIntensity));
	
	//Devices answers a number
	StGoodAnswer := INT_TO_STRING(iIndexDetectLamps); 
	
	iAnswerStringPosition := 2;
	iAnswerStringLength := 1;
	//This is the data received when reading lamp's intensity: 10% = 010; 25%=025; 99%=099

END_ACTION

ACTION ReadFinishPolling:
	//To define the string to be sent to the lamp
	StMessage := '';

	//Devices answers a number
	StGoodAnswer := 'Custom'; 

	iAnswerStringPosition := 1;
	iAnswerStringLength := 6;
	//This is the data received when reading lamp's intensity: 10% = 010; 25%=025; 99%=099

END_ACTION
