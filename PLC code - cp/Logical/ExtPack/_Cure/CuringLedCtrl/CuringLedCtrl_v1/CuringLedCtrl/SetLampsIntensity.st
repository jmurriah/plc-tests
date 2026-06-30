
ACTION SetLampsIntensity: 

	//Assign the enable and intensity value to the output signals
	xCuringOrder := (StatusCtrl = CURINGLED_EMITTING);
	FOR iIndexCuring:=1 TO iLampsQuantity DO
		//To enable lamp
		dataLed.Lamp[iIndexCuring].Outputs.EnableLamp := xCuringOrder AND dataLed.Lamp[iIndexCuring].Parameters.EnabledByPosition AND dataLed.Parameters.xEnabled;
		
		IF dataLed.Parameters.xPhysicalTempFeedback THEN
			dataLed.Lamp[iIndexCuring].Outputs.rTemperature := (dataLed.Lamp[iIndexCuring].Inputs.TemperatureRaw/327.7);
		END_IF
		
		//To set lamp's intensity depending on state mode
		//Auto = Intensity set on the UI
		IF (dataLed.Parameters.rBeltCurrentSpeed<=iMinSpeedWhenBlockAtSafePosition) THEN
			iIntensityWhileAtSafePosition:=30;
		ELSE
			iIntensityWhileAtSafePosition:=40;
		END_IF
		
		IF dataLed.Parameters.Mode.xAuto THEN
			IF dataLed.Commands.xDropPower THEN
				dataLed.Lamp[iIndexCuring].Outputs.IntensityLampRaw := REAL_TO_INT(iIntensityWhileAtSafePosition * rLampIntensitySlope); //10V correspond to 32766
				
			ELSIF dataLed.Parameters.xCureBySpeed THEN
				iIntensityCureBySpeed := REAL_TO_USINT((rCureBySpeedSlope * dataLed.Parameters.rBeltCurrentSpeed) + rCureBySpeedIntercept);
				iIntensityCureBySpeed := LIMIT(MinIntensityCuringBySpeed, iIntensityCureBySpeed, MaxIntensityCuringBySpeed);
				dataLed.Lamp[iIndexCuring].Outputs.IntensityLampRaw := REAL_TO_INT(iIntensityCureBySpeed * rLampIntensitySlope); //10V correspond to 32766
				
			ELSE
				dataLed.Lamp[iIndexCuring].Outputs.IntensityLampRaw := REAL_TO_INT(dataLed.parSw.IntensitySetPoint * rLampIntensitySlope); //10V correspond to 32766
			END_IF
		
			//Manual = Intensity set by PLC in case of detect lamps process is going on
		ELSIF dataLed.Parameters.Mode.xManual THEN
			IF 	(DetectStep = DETECTION_READ_INTENSITY) OR
				(DetectStep = DETECTION_ASSIGN_POSITION) THEN
				//To multiply by 11 so in case of analogic intensity output is a bit low than desired, we get the number correctly. 
				//Example: 1*11=11, will read either 010, 011 or 012. 1 is always the second number. If using 1*10, may get a 009 and no "1" will be found
				dataLed.Lamp[iIndexCuring].Outputs.IntensityLampRaw := REAL_TO_INT(iIndexCuring*11 * rLampIntensitySlope);
			END_IF
			
			//Zero = Intensity set to zero as a safety redundancy
		ELSE
			dataLed.Lamp[iIndexCuring].Outputs.IntensityLampRaw := 0;
		END_IF
		
		//Convert raw data to percentage
		dataLed.Lamp[iIndexCuring].Outputs.IntensityLampApplied := REAL_TO_USINT(dataLed.Lamp[iIndexCuring].Outputs.IntensityLampRaw/rLampIntensitySlope);
	END_FOR
	
END_ACTION


ACTION ResetOutputs:
	dataLed.Signals.Outputs := OutputsReset;
END_ACTION