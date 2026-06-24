
ACTION RunHeightArray: 

	// ------------------------------------------------------------------
	// Matrix advance and calculate the maximum
	
	//Move the values of the array
	ShiftArrayForward(ADR(iHeightArray), SIZEOF(iHeightArray), SIZEOF(iHeightArray[0]), iPositionsToRunArray, iTotalBlocksLengh);
	
	// High Ctrl data to Matrix
	// Loading data from sensors to 
	IF gPhotoCells.status.xInstalled THEN
		LoadHeightFromArraySensor;
	END_IF
	IF gDing.State.xDingInstalled OR gBasicDetectMedia.Status.xInstalled THEN
		LoadHeightFromAnalogSensor;
	END_IF

	// Analyze height data and assign maximum height per section
	ResetMaxHeigh;
	FOR iIndexArray:= iTotalBlocksLengh TO iPositionsToRunArray BY -1 DO
		//Update te value of the thickness in the matrix
		AssignMaxHeighIndex;
	END_FOR
	
END_ACTION

ACTION ResetMaxHeigh: 

	// It allows changes on height block correction when It changes Hand Printer
	FOR iIndexSection:=1 TO iTotalSections DO
		iMaxHeigh[iIndexSection]:=0;
	END_FOR

END_ACTION

ACTION AssignMaxHeighIndex: 

	//Calculate the maximum of each section
	FOR iIndexSection:=1 TO iTotalSections DO
		//If the section is not enabled, do not calculate any Max
		IF dataHeigh.parameters.sections[iIndexSection].xEnabled THEN

			//If the Section does not correspond with the Index in Matrix, do not calculate Max
			IF iIndexArray > dataHeigh.parameters.sections[iIndexSection].iStart AND 
				iIndexArray <= dataHeigh.parameters.sections[iIndexSection].iEnd 	 THEN
					
				iMaxHeigh[iIndexSection]:= MAX(iHeightArray[iIndexArray], iMaxHeigh[iIndexSection]);
			END_IF
		END_IF
				
	END_FOR

END_ACTION

ACTION AssignMaxHeight: 

	//Calculate the maximum of each section
	FOR iIndexSection:=1 TO iTotalSections DO
		//If the section is not enabled, do not calculate any Max
		IF dataHeigh.parameters.sections[iIndexSection].xEnabled THEN
			FOR iIndexArray:= dataHeigh.parameters.sections[iIndexSection].iStart TO dataHeigh.parameters.sections[iIndexSection].iEnd DO
				iMaxHeigh[iIndexSection]:= MAX(iHeightArray[iIndexArray], iMaxHeigh[iIndexSection]);
			END_FOR
		END_IF		
	END_FOR

END_ACTION

ACTION LoadHeightFromAnalogSensor: 
	//TODO. convert in a FUNCTION to use 3 times
	
	// Fill-in moved spaces with new data
	iCurrentMediaHeight := 0;
	IF dataHeigh.Internal.iFastValues >= iPositionsToRunArray THEN
		// More values than holes to fill-in. Distribution of data
		rValuesPerPosition :=  dataHeigh.Internal.rFastValues / UINT_TO_REAL(iPositionsToRunArray);
		FOR iIndexArray:=0 TO iPositionsToRunArray -1 DO
			iHeightArray[iIndexArray + iAnalogSensorPosition] := 0;
			FOR iIndexNewMediaArray := INT_TO_UINT( TRUNC(UINT_TO_REAL(iIndexArray) * rValuesPerPosition )) TO INT_TO_UINT(TRUNC(UINT_TO_REAL(iIndexArray) * rValuesPerPosition )) DO
				iHeightArray[iIndexArray + iAnalogSensorPosition] := MAX(iHeightArray[iIndexArray + iAnalogSensorPosition], dataHeigh.Internal.AnalogHeightValues[iIndexNewMediaArray]);
				iCurrentMediaHeight := MAX(iCurrentMediaHeight, dataHeigh.Internal.AnalogHeightValues[iIndexNewMediaArray]);
			END_FOR
		END_FOR
	ELSE
		// More holes than data. Ampliation of data
		rValuesPerPosition :=  UINT_TO_REAL(iPositionsToRunArray) / dataHeigh.Internal.rFastValues;
		FOR iIndexNewMediaArray:=0 TO REAL_TO_UINT(dataHeigh.Internal.rFastValues) -1 DO
			FOR iIndexArray := INT_TO_UINT(TRUNC(UINT_TO_REAL(iIndexNewMediaArray) * rValuesPerPosition )) TO INT_TO_UINT(TRUNC(UINT_TO_REAL(iIndexNewMediaArray) * rValuesPerPosition )) DO
				iHeightArray[iIndexArray + iAnalogSensorPosition] :=dataHeigh.Internal.AnalogHeightValues[iIndexNewMediaArray];
				iCurrentMediaHeight := MAX(iCurrentMediaHeight, dataHeigh.Internal.AnalogHeightValues[iIndexNewMediaArray]);
			END_FOR
		END_FOR
	END_IF
	gThicknessCtrl.status.Heigh.iMediaHeigh := iCurrentMediaHeight;

END_ACTION

ACTION LoadHeightFromArraySensor: 
	//TODO. convert in a FUNCTION to use 3 times
	
	// Fill-in moved spaces with new data
	iCurrentMediaHeight := 0;
	IF dataHeigh.Internal.iFastValues >= iPositionsToRunArray THEN
		// More values than holes to fill-in. Distribution of data
		rValuesPerPosition :=  dataHeigh.Internal.rFastValues / UINT_TO_REAL(iPositionsToRunArray);
		FOR iIndexArray:=0 TO iPositionsToRunArray -1 DO
			iHeightArray[iIndexArray + iArraySensorPosition] := 0;	
			FOR iIndexNewMediaArray := INT_TO_UINT(TRUNC(UINT_TO_REAL(iIndexArray) * rValuesPerPosition )) TO INT_TO_UINT(TRUNC(UINT_TO_REAL(iIndexArray) * rValuesPerPosition )) DO
				iHeightArray[iIndexArray + iArraySensorPosition] := MAX(iHeightArray[iIndexArray + iArraySensorPosition], dataHeigh.Internal.ArrayHeightValues[iIndexNewMediaArray]);
				iCurrentMediaHeight := MAX(iCurrentMediaHeight, dataHeigh.Internal.ArrayHeightValues[iIndexNewMediaArray]);
			END_FOR
		END_FOR
	ELSE
		// More holes than data. Ampliation of data
		rValuesPerPosition :=  UINT_TO_REAL(iPositionsToRunArray) / dataHeigh.Internal.rFastValues;
		FOR iIndexNewMediaArray:=0 TO REAL_TO_UINT(dataHeigh.Internal.rFastValues) -1 DO
			FOR iIndexArray := INT_TO_UINT(TRUNC(UINT_TO_REAL(iIndexNewMediaArray) * rValuesPerPosition )) TO INT_TO_UINT(TRUNC(UINT_TO_REAL(iIndexNewMediaArray) * rValuesPerPosition )) DO
				iHeightArray[iIndexArray + iArraySensorPosition] :=dataHeigh.Internal.ArrayHeightValues[iIndexNewMediaArray];
				iCurrentMediaHeight := MAX(iCurrentMediaHeight, dataHeigh.Internal.ArrayHeightValues[iIndexNewMediaArray]);
			END_FOR
		END_FOR
	END_IF
	gThicknessCtrl.status.Heigh.iMediaHeigh := iCurrentMediaHeight;
	
END_ACTION