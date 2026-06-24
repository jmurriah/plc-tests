ACTION ConfigureLamps:
	
	IF dataLed.Alarms.xPowerFailure OR NOT dataLed.Commands.PowerOn THEN ConfigCtrl := CONFIGURATION_NOT_INIT; END_IF
	IF xBoardPositionChanged OR EDGEPOS(xConfigurationFailed) THEN ConfigCtrl := CONFIGURATION_INIT; END_IF
	
	CASE ConfigCtrl OF
		
		CONFIGURATION_NOT_INIT:
			
			
		CONFIGURATION_INIT:
			iIndexConfigLamps := 1;
			iIndexConfigSlm := 0;
			ConfigCtrl := CONFIGURATION_PREPARE_LAMP;
		
		
		CONFIGURATION_PREPARE_LAMP:
			//To evaluate only lamps that are going to be active (EnabledByPosition)
			IF NOT dataLed.Lamp[iIndexConfigLamps].Parameters.EnabledByPosition THEN
				DisableAllSlm;
			ELSE
				//To enable all SLM by default
				EnableAllSlm;
			END_IF
			ConfigCtrl := CONFIGURATION_SEND;
		
			
		CONFIGURATION_PREPARE_SLM:
			iNumLampSLM := dataLed.Lamp[iIndexConfigLamps].Parameters.iNumSLM; //Number of lamp's SLMs
			IF iIndexConfigSlm<=iNumLampSLM THEN
				//An active lamp might be full used or just use some SLMs
				IF (NOT dataLed.Lamp[iIndexConfigLamps].Parameters.xSlmEnable[iIndexConfigSlm]) THEN
					StIndex := INT_TO_STRING(iIndexConfigSlm);
					DisableSlm;
				END_IF
				ConfigCtrl := CONFIGURATION_SEND;
			ELSE
				iIndexConfigSlm := 0; //1;
				ConfigCtrl := CONFIGURATION_SENT;
			END_IF
		
			
		CONFIGURATION_SEND:
			dataLed.Comms.Command.Send := TRUE;
			ConfigCtrl := CONFIGURATION_SENDING;
		
			
		CONFIGURATION_SENDING:
			IF (StAnswer = StGoodAnswer) THEN
				IF (dataLed.Lamp[iIndexConfigLamps].Parameters.xFullActive OR NOT dataLed.Lamp[iIndexConfigLamps].Parameters.EnabledByPosition) THEN
					ConfigCtrl := CONFIGURATION_SENT;
				ELSE
					ConfigCtrl := CONFIGURATION_PREPARE_SLM;
					iIndexConfigSlm := iIndexConfigSlm + 1;
				END_IF
				dataLed.Comms.Device.receive_data := '';
			ELSIF dataLed.Comms.Device.step = FRM_WAIT THEN
				ConfigCtrl := CONFIGURATION_SEND;
			END_IF
		
		
		CONFIGURATION_SENT:
			iIndexConfigLamps := iIndexConfigLamps + 1;
			IF iIndexConfigLamps > iLampsQuantity THEN
				ConfigCtrl := CONFIGURATION_READY;
			ELSE
				ConfigCtrl := CONFIGURATION_PREPARE_LAMP;
			END_IF
		
		
		CONFIGURATION_READY:
			
		
	END_CASE
	
	
	dataLed.Comms.Device.send_data := StMessage; //To assign Message to dataled comms struct
	StAnswer := MID(dataLed.Comms.Device.receive_data, iAnswerStringLength, iAnswerStringPosition);
	dataLed.Status.xLampsConfigured := ConfigCtrl = CONFIGURATION_READY;
	dataLed.Status.Config := ConfigCtrl;
	
END_ACTION


//Telegrams to be sent to curing led devices//
//To enable all slm in the lamp
ACTION EnableAllSlm:
	//To define the string to be sent to the lamp
	StMessage := StCmdWrite;
	//strcat: Used to link (concat) several strings
	strcat(ADR(StMessage), ADR(dataLed.Lamp[iIndexConfigLamps].Status.stSerialNumber));
	strcat(ADR(StMessage), ADR(StMl));
	strcat(ADR(StMessage), ADR(StCmdEnableAll));
	
	//Devices answers "ok"
	StGoodAnswer := StOk;
	iAnswerStringPosition := 1;
	iAnswerStringLength := 2;
END_ACTION

//To disable all slm in the lamp
ACTION DisableAllSlm:
	//To define the string to be sent to the lamp
	StMessage := StCmdWrite;
	//strcat: Used to link (concat) several strings
	strcat(ADR(StMessage), ADR(dataLed.Lamp[iIndexConfigLamps].Status.stSerialNumber));
	strcat(ADR(StMessage), ADR(StMl));
	strcat(ADR(StMessage), ADR(StCmdDisableAll));
	
	//Devices answers "ok"
	StGoodAnswer := StOk;
	iAnswerStringPosition := 1;
	iAnswerStringLength := 2;
END_ACTION

//To enable an specific slm in the lamp
ACTION EnableSlm:
	//To define the string to be sent to the lamp
	StMessage := StCmdWrite;
	//strcat: Used to link (concat) several strings
	strcat(ADR(StMessage), ADR(dataLed.Lamp[iIndexConfigLamps].Status.stSerialNumber));
	strcat(ADR(StMessage), ADR(StMl));
	strcat(ADR(StMessage), ADR(StCmdEnableSlm));
	strcat(ADR(StMessage), ADR(StIndex));
	strcat(ADR(StMessage), ADR(StValueEnableSlm));
		
	//Device answers "SLMxx=On" when DisableSlm command is sent, where xx is SLM Index, so:
	StGoodAnswer := StOn;
	IF iIndexConfigSlm<10 THEN iAnswerStringPosition := 6; ELSE iAnswerStringPosition := 7; END_IF
	iAnswerStringLength := 2;
END_ACTION

//To disable an specific slm in the lamp
ACTION DisableSlm:
	//To define the string to be sent to the lamp
	StMessage := StCmdWrite;
	//strcat: Used to link (concat) several strings
	strcat(ADR(StMessage), ADR(dataLed.Lamp[iIndexConfigLamps].Status.stSerialNumber));
	strcat(ADR(StMessage), ADR(StMl));
	strcat(ADR(StMessage), ADR(StCmdEnableSlm));
	strcat(ADR(StMessage), ADR(StIndex));
	strcat(ADR(StMessage), ADR(StValueDisableSlm));
	
	//Device answers "SLMxx=Off" when DisableSlm command is sent, where xx is SLM Index, so:
	StGoodAnswer := StOff;
	IF iIndexConfigSlm<10 THEN iAnswerStringPosition := 6; ELSE iAnswerStringPosition := 7; END_IF
	iAnswerStringLength := 2;
END_ACTION
