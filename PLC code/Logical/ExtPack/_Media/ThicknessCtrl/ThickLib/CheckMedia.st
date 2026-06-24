
(* Review if the values in a trackignArray is consistent. Using USINT array to load differente lines *)
FUNCTION CheckFilteredMediaLine

	xFilteredData := TRUE;
	//Creating mask with bit active in the right position and invert
	bitLine:=1;
	bitLine := SHL(bitLine,indexLine);
	FOR iIndexArray := sensorPosition TO sensorPosition + mediaFilter DO
		// If the corresponding bit is false, the filter is not matched
		IF (valuesTracking[iIndexArray] AND bitLine) = 0 THEN
			xFilteredData := FALSE;
			EXIT;
		END_IF		
	END_FOR
	CheckFilteredMediaLine := xFilteredData;
	
END_FUNCTION

(* Review if the values in a trackignArray is consistent. Using BOOL array to load individual data *)
FUNCTION CheckFilteredMediaBool

	xFilteredData := TRUE;
	FOR iIndexArray := sensorPosition TO sensorPosition + mediaFilter DO
		// If the corresponding bit is false, the filter is not matched
		IF NOT valuesTracking[iIndexArray] THEN
			xFilteredData := FALSE;
			EXIT;
		END_IF
	END_FOR
	CheckFilteredMediaBool := xFilteredData;
	
END_FUNCTION