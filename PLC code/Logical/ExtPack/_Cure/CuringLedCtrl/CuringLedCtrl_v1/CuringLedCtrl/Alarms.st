
ACTION Alarms: 
	
	IF dataLed.Status.State = CURINGLED_FAULTED THEN
		dataLed.Alarms.xCureSystemFaulted := TRUE;
	END_IF

	dataLed.Alarms.xChillerFaulted := dataChiller.St.Status = CHILLER_FAULT;
	
	IF dataLed.Signals.Inputs.xN2HighFlow AND dataLed.Signals.Outputs.xPowerOnNitrogen THEN
		dataLed.Alarms.xN2HighFlow := TRUE;
	END_IF

	tonNitroAlrLowFlow.IN := dataLed.Signals.Inputs.xN2LowFlow AND dataLed.Signals.Outputs.xPowerOnNitrogen;
	tonNitroAlrLowFlow.PT := T#4s;
	tonNitroAlrLowFlow();
	IF tonNitroAlrLowFlow.Q THEN
		dataLed.Alarms.xN2LowFlow := TRUE;
	END_IF

	//Assign alarms and create the words with all the alarm bits
	errorLampsSLM:=0;
	errorLampsThermal:=0;
	
	tonCheckAlarms.IN := dataLed.Signals.Inputs.xSafetyEnable;
	tonCheckAlarms.PT := T#3000ms;
	tonCheckAlarms();

	IF tonCheckAlarms.Q THEN
		FOR iIndexCuring:=1 TO iLampsQuantity DO
			//SLM faults are only critical when led is enabled to cure
			IF dataLed.Lamp[iIndexCuring].Parameters.EnabledByPosition THEN
				dataLed.Alarms.Lamps[iIndexCuring].SLMFault := dataLed.Lamp[iIndexCuring].Inputs.SLMFault;
			ELSE
				dataLed.Alarms.Lamps[iIndexCuring].AnyWarning := dataLed.Lamp[iIndexCuring].Inputs.SLMFault;
			END_IF
			IF dataLed.Alarms.Lamps[iIndexCuring].SLMFault THEN
				errorLampsSLM := errorLampsSLM OR SHL(1,iIndexCuring-1);
			END_IF
			
			//Thermal faults are always evaluated, either the led is enabled to cure or not
			dataLed.Alarms.Lamps[iIndexCuring].ThermalFault := dataLed.Lamp[iIndexCuring].Inputs.ThermalFault;
			IF dataLed.Alarms.Lamps[iIndexCuring].ThermalFault THEN
				errorLampsThermal := errorLampsThermal OR SHL(1,iIndexCuring-1);
			END_IF
		END_FOR	
	END_IF
	
	//Power supplies
	xPowerOnLamps := TRUE;
	FOR iIndexPowerSupply:=1 TO iPowerSuppliesQuantity DO
		tonStabPsuFailure[iIndexPowerSupply].IN := NOT dataLed.Signals.Inputs.xPsuDcOk[iIndexPowerSupply] OR NOT dataLed.Signals.Inputs.xPsuAcOk[iIndexPowerSupply];
		tonStabPsuFailure[iIndexPowerSupply].PT := T#300ms;
		tonStabPsuFailure[iIndexPowerSupply]();
		IF tonStabPsuFailure[iIndexPowerSupply].Q AND tonCheckAlarms.Q THEN
			IF NOT dataLed.Alarms.xPowerFailure THEN
				LogPsuFailure;
			END_IF
			dataLed.Alarms.xPowerFailure := TRUE;
		END_IF
		IF NOT dataLed.Signals.Inputs.xPsuAcOk[iIndexPowerSupply] THEN
			xPowerOnLamps := FALSE;
		END_IF
	END_FOR
	
	
	//Timer to launch lamps configuration after voltage recovery
	tonLampsVoltageRecovery.IN := NOT dataLed.Alarms.xPowerFailure;
	tonLampsVoltageRecovery.PT := T#5s;
	tonLampsVoltageRecovery();
	
	
	//Front door opened
	IF NOT dataLed.Signals.Inputs.xFrontDoorClosed AND dataLed.Status.xEmitting THEN
		dataLed.Alarms.xFrontDoorOpened := TRUE;
	END_IF
	
	//Curing by stretch related
	IF dataLed.Status.xCureByStretch AND NOT dataLed.Parameters.xSimulationMode THEN
		
		IF EDGEPOS(dataLed.Status.xLampsChecked) THEN //DELOREAN-1814: In case configuration process fails, lamps may be power cycled and then full width is set by job, to not raise this alarm
			xConfigurationFailed := FALSE;
			//Lamp's stretches not configured
			FOR iIndexCheckLamps:=1 TO iLampsQuantity DO
				iNumLampSLM := dataLed.Lamp[iIndexCheckLamps].Parameters.iNumSLM;
				FOR iIndexCheckSlm:=1 TO iNumLampSLM DO
					//To check that SLM activated matches with slms calculated to be enabled
					IF dataLed.Lamp[iIndexCheckLamps].Outputs.xSlmStatus[iIndexCheckSlm] <> dataLed.Lamp[iIndexCheckLamps].Parameters.xSlmEnable[iIndexCheckSlm] THEN
						xConfigurationFailed := TRUE;
						dataLed.Alarms.Lamps[iIndexCheckLamps].xSlmWrongConfiguration[iIndexCheckSlm]:=TRUE;
					ELSE
						dataLed.Alarms.Lamps[iIndexCheckLamps].xSlmWrongConfiguration[iIndexCheckSlm]:=FALSE;
					END_IF
				END_FOR
				
				//Lamp status feedback error
				//IF dataLed.Alarms.Lamps[iIndexCheckLamps].StatusFeedbackFault THEN xConfigurationFailed := TRUE; END_IF
			END_FOR
			
		END_IF
		
		
		//SlmNotConfigured. Autoreset
		IF xConfigurationFailed THEN
			dataLed.Alarms.xLampsSlmNotConfigured := TRUE; // OR NOT dataLed.Status.xLampsConfigured;
		END_IF
		
		
		//Lamps serial number not assigned
		FOR iIndexCuring:=1 TO iLampsQuantity DO
			IF (dataLed.Lamp[iIndexCuring].Status.stSerialNumber = '') THEN
				dataLed.Alarms.xSerialNumbersNotAssigned := TRUE;
			END_IF
			
			IF dataLed.Status.xLampsDetected THEN
				FOR iIndexCuringAux:=1 TO iLampsQuantity DO
					IF (iIndexCuringAux<>iIndexCuring) AND (dataLed.Lamp[iIndexCuringAux].Status.stSerialNumber = dataLed.Lamp[iIndexCuring].Status.stSerialNumber) THEN
						dataLed.Alarms.xSerialNumbersRepeated := TRUE;
					END_IF
				END_FOR
			ELSE
				dataLed.Alarms.xSerialNumbersRepeated := FALSE;
			END_IF
		END_FOR
		
		//Detection process has failed
		IF dataLed.Status.DetectionState = DETECTION_ERROR THEN
			dataLed.Alarms.xDetectionProcessFailed := TRUE;
		ELSE
			dataLed.Alarms.xDetectionProcessFailed := FALSE;
		END_IF
	ELSE
		dataLed.Alarms.xLampsSlmNotConfigured := FALSE;
		dataLed.Alarms.xSerialNumbersNotAssigned := FALSE;
		dataLed.Alarms.xDetectionProcessFailed := FALSE;
	END_IF
	
	// ALARMS SUMMARY
	AlarmsSummary;	
	
END_ACTION


ACTION ResetAlarms:
	dataLed.Alarms := AlarmsReseted;
	dataLed.AlSummary := AlarmsSummaryReseted;
END_ACTION
