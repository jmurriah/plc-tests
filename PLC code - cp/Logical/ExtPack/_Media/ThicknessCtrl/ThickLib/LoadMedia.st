
(* Loading Fast data in an array to an array of tracking data. Using USINT array to load differente lines *)
FUNCTION LoadMediaFromFastDataLine

	//Creating mask with bit active in the right position
	bitLine:=1;
	bitLine := SHL(bitLine,indexLine);

	IF REAL_TO_UINT(fastValues) >= positionsToRunArray THEN
		// More values than holes to fill-in. Distribution of data. If there is a gap in the Fast Data, the gap has to appear in the slow data
		rValuesPerPosition :=  fastValues / UINT_TO_REAL(positionsToRunArray);
		FOR iIndexArray:=0 TO positionsToRunArray -1 DO
			//Activate the bit
			valuesTracking[iIndexArray + sensorPosition] := valuesTracking[iIndexArray + sensorPosition] OR bitLine;
			// If MOD is 0, no need to wonder about TRUNC or CEIL
			IF brmfmod(fastValues, UINT_TO_REAL(positionsToRunArray)) = 0 THEN
				iFirstIndex := REAL_TO_UINT(UINT_TO_REAL(iIndexArray) * rValuesPerPosition);
				FOR iIndexNewMediaArray := iFirstIndex TO iFirstIndex + REAL_TO_UINT(rValuesPerPosition) -1 DO
					IF NOT newValues[iIndexNewMediaArray] THEN 
						//Resetting the bit
						valuesTracking[iIndexArray + sensorPosition] := valuesTracking[iIndexArray + sensorPosition] AND NOT(bitLine);
					END_IF
				END_FOR				
			ELSE
				FOR iIndexNewMediaArray := INT_TO_UINT(TRUNC(UINT_TO_REAL(iIndexArray) * rValuesPerPosition)) TO MIN(INT_TO_UINT(TRUNC(UINT_TO_REAL(iIndexArray + 1) * rValuesPerPosition )), REAL_TO_UINT(fastValues -1)) DO
					IF NOT newValues[iIndexNewMediaArray] THEN
						//Resetting the bit
						valuesTracking[iIndexArray + sensorPosition] := valuesTracking[iIndexArray + sensorPosition] AND NOT(bitLine);
					END_IF
				END_FOR
			END_IF
		END_FOR
	ELSE
		// More holes than data. Ampliation of data
		rValuesPerPosition :=  fastValues / UINT_TO_REAL(positionsToRunArray);
		FOR iIndexArray :=0 TO positionsToRunArray -1 DO
			iFirstIndex := INT_TO_UINT(TRUNC(UINT_TO_REAL(iIndexArray) * rValuesPerPosition));
			iLastIndex := MIN(INT_TO_UINT(TRUNC(UINT_TO_REAL(iIndexArray +1 ) * rValuesPerPosition )), REAL_TO_UINT(fastValues-1));
			FOR iIndexNewMediaArray := iFirstIndex TO iLastIndex DO
				IF newValues[iIndexNewMediaArray] THEN
					//Activate the bit
					valuesTracking[iIndexArray + sensorPosition] := valuesTracking[iIndexArray + sensorPosition] OR bitLine;
				ELSE
					//Reset the bit
					valuesTracking[iIndexArray + sensorPosition] := valuesTracking[iIndexArray + sensorPosition] AND NOT(bitLine);
				END_IF
			END_FOR
		END_FOR
	END_IF
	
	LoadMediaFromFastDataLine := TRUE;
	valuesTracking; // To monitor while debugging
	
END_FUNCTION

(* Loading Fast data in an array to an array of tracking data. Using BOOL array to load individual data *)
FUNCTION LoadMediaFromFastDataBool

	IF REAL_TO_UINT(fastValues) >= positionsToRunArray THEN
		// More values than holes to fill-in. Distribution of data. If there is a gap in the Fast Data, the gap has to appear in the slow data
		rValuesPerPosition :=  fastValues / UINT_TO_REAL(positionsToRunArray);
		FOR iIndexArray:=0 TO positionsToRunArray -1 DO
			//Activate the bit
			valuesTracking[iIndexArray + sensorPosition] := TRUE;
			// If MOD is 0, no need to wonder about TRUNC or CEIL
			IF brmfmod(fastValues, UINT_TO_REAL(positionsToRunArray)) = 0 THEN
				iFirstIndex := REAL_TO_UINT(UINT_TO_REAL(iIndexArray) * rValuesPerPosition);
				FOR iIndexNewMediaArray := iFirstIndex TO iFirstIndex + REAL_TO_UINT(rValuesPerPosition) -1 DO
					IF NOT newValues[iIndexNewMediaArray] THEN 
						//Resetting the bit
						valuesTracking[iIndexArray + sensorPosition] := FALSE;
					END_IF
				END_FOR				
			ELSE
				FOR iIndexNewMediaArray := INT_TO_UINT(TRUNC(UINT_TO_REAL(iIndexArray) * rValuesPerPosition)) TO MIN(INT_TO_UINT(TRUNC(UINT_TO_REAL(iIndexArray + 1) * rValuesPerPosition )), REAL_TO_UINT(fastValues -1)) DO
					IF NOT newValues[iIndexNewMediaArray] THEN
						//Resetting the bit
						valuesTracking[iIndexArray + sensorPosition] := FALSE;
					END_IF
				END_FOR
			END_IF
		END_FOR
	ELSE
		// More holes than data. Ampliation of data
		rValuesPerPosition :=  fastValues / UINT_TO_REAL(positionsToRunArray);
		FOR iIndexArray :=0 TO positionsToRunArray -1 DO
			iFirstIndex := INT_TO_UINT(TRUNC(UINT_TO_REAL(iIndexArray) * rValuesPerPosition));
			iLastIndex := MIN(INT_TO_UINT(TRUNC(UINT_TO_REAL(iIndexArray +1 ) * rValuesPerPosition )), REAL_TO_UINT(fastValues-1));
			FOR iIndexNewMediaArray := iFirstIndex TO iLastIndex DO
				valuesTracking[iIndexArray + sensorPosition] := newValues[iIndexNewMediaArray];
			END_FOR
		END_FOR
	END_IF
	LoadMediaFromFastDataBool := TRUE;
	
END_FUNCTION
