
ACTION AnalogInputs: 

	//If in simulation, do not assign physical mapping
	IF gDing.Parameters.xSimulationMode THEN
		RETURN;
	END_IF
	
	//If not installed, clear alarms and exit
	IF NOT gDing.Parameters.xDingInstalled THEN
		gDing.State.xDingLowPieceDetect := FALSE;
		RETURN;
	END_IF
	
	// If the pointer of the card is not assigned by machine, 
	//return to avoid lost pointer access
	IF gDing.In.pInputCard = 0 THEN
		RETURN;
	END_IF
	
	dingCard ACCESS gDing.In.pInputCard;
	
	// Analog Input
	IF dingCard.AInput[1] < 5 OR gDing.In.xDingChannelFault THEN
		gDing.In.iHighDingRaw:=0;
		gDing.In.rHighDingMm:=0;		
	ELSIF dingCard.AInput[1] > 6543 THEN // Rename Analog Input
		//Taking the maximum because the AnalogInputCard

		// Calculating and checking MaxSamples
		iMaxSamples := MIN(MAX_LAST_SIGNAL, gDing.Parameters.iAnalogSamples);

		// Calculating the Max from the samples
		iHighDingRaw := dingCard.AInput[1];
		FOR iIndexSamples := 2 TO iMaxSamples DO
			iHighDingRaw := MAX(iHighDingRaw, dingCard.AInput[iIndexSamples]);
		END_FOR
		gDing.In.iHighDingRaw := iHighDingRaw;

		gDing.State.xSensorCovered:= gDing.In.iHighDingRaw > 32700;
		
		CASE gDing.Parameters.SensorType OF
			ANSENS_BALLUF_48:
				gDing.In.rHighDingMm:=INT_TO_REAL(gDing.In.iHighDingRaw - 6543) * ((48.76 / (32767.0- 6543.0))  );

			ANSENS_BALLUF_97:
				gDing.In.rHighDingMm:=INT_TO_REAL(gDing.In.iHighDingRaw - 6543) * ((97.53 / (32767.0- 6543.0))  );

		END_CASE
		
	END_IF
	
END_ACTION
