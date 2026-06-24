
FUNCTION CheckMediaToStack
	
	CheckMediaToStack := 0;
	
	IF CheckEnabledStack(xStackEnabled) > 0 THEN
		CheckMediaToStack := CheckEnabledStack(xStackEnabled);
		RETURN;
	END_IF
	
	IF CheckLineToStack(NewMedia.iLine, xStackEnabled, xDtpEnabled) > 0 THEN
		CheckMediaToStack := CheckLineToStack(NewMedia.iLine, xStackEnabled, xDtpEnabled);
		RETURN;
	END_IF	

	IF NewMedia.rThickness < 0.1 OR NewMedia.rThickness > rMaxThickness THEN
		CheckMediaToStack := 160; // Thickness error
		RETURN;
	END_IF

	IF NewMedia.rWidth < rMinWidth OR NewMedia.rWidth > rMaxWidth THEN
		CheckMediaToStack := 170; // Width error
		RETURN;
	END_IF

	IF NewMedia.rLength < rMinLength OR NewMedia.rLength > rMaxLength THEN
		CheckMediaToStack := 180; // Length error
		RETURN;
	END_IF

	//	IF NewMedia.rGap < 10 THEN
	//		CheckMediaToStack := 190; // Gap error
	//		RETURN;
	//	END_IF

	IF NewMedia.rCrossOffset < -NewMedia.rWidth/2 OR (NewMedia.rWidth + NewMedia.rCrossOffset) > rMaxWidth/2 THEN
		CheckMediaToStack := 200; // Offset error
		RETURN;
	END_IF

	IF NewMedia.rDocWidth < 0 OR NewMedia.rDocWidth > NewMedia.rWidth THEN
		CheckMediaToStack := 210; // DocWidth error
		RETURN;
	END_IF

	IF NewMedia.rDocLength < 0 OR NewMedia.rDocLength > NewMedia.rLength THEN
		CheckMediaToStack := 220; // DocLength error
		RETURN;
	END_IF

	IF NewMedia.rDocCrossOffset < -NewMedia.rWidth/2 OR (NewMedia.rDocWidth + NewMedia.rDocCrossOffset) > rMaxWidth/2 THEN
		CheckMediaToStack := 230; // DocCrossOffset error
		RETURN;
	END_IF

	IF NewMedia.rDocProcessOffset < 0 OR (NewMedia.rDocLength + NewMedia.rDocProcessOffset) > NewMedia.rDocLength THEN
		CheckMediaToStack := 240; // DocProcessOffset error
		RETURN;
	END_IF

	IF NewMedia.iLine = 1 AND xStackLine1Full THEN
		CheckMediaToStack := 500; // Array full
		RETURN;
	END_IF
	
	IF NewMedia.iLine = 2 AND xStackLine2Full THEN
		CheckMediaToStack := 501; // Array full
		RETURN;
	END_IF

	
END_FUNCTION


FUNCTION CheckLineToStack
	
	CheckLineToStack := 0;
	
	IF CheckEnabledStack(xStackEnabled) > 0 THEN
		CheckLineToStack := CheckEnabledStack(xStackEnabled);
		RETURN;
	END_IF
	
	IF NOT xDtpEnabled THEN
		IF iLine <> 1 THEN
			CheckLineToStack := 150; // Line error
			RETURN;
		END_IF
	ELSE
		IF iLine < 1 OR iLine > 2 THEN
			CheckLineToStack := 150; // Line error
			RETURN;
		END_IF
	END_IF

END_FUNCTION


FUNCTION CheckEnabledStack
	
	CheckEnabledStack := 0;
	
	IF NOT xStackEnabled THEN
		CheckEnabledStack := 140; // Stack not enabled
		RETURN;	
	END_IF
	
END_FUNCTION


FUNCTION CheckItemInStack
	
	CheckItemInStack := 0;
	
	// Check if the Id is valid
	IF Id < 0 THEN
		CheckItemInStack := 1500; // Id negative. Not in Array
		RETURN;	
	END_IF
	
	// If not elements, the Id is not in list
	IF TotalElements = 0 THEN
		CheckItemInStack := 1510; // Id Not found in Array
		RETURN;
	END_IF
	
	// Check if the id is in the array
	FOR iIndex := 0 TO TotalElements - 1 DO
		IF Id = StackArray[iIndex].Media.id THEN
			CheckItemInStack := 0; // Id Found
			PositionFound := iIndex; // Returning the position where Id is
			RETURN;	
		END_IF
	END_FOR
	
	// The id has not been found. Raise an error
	CheckItemInStack := 1510; // Id Not found in Array
	RETURN;	

END_FUNCTION


FUNCTION CheckNotItemInStack
	
	CheckNotItemInStack := 0;
	
	// Check if the Id is valid
	IF Id < 0 THEN
		CheckNotItemInStack := 1500; // Id negative. Not in Array
		RETURN;	
	END_IF
	
	// If not elements, the Id is not in list
	IF TotalElements = 0 THEN
		CheckNotItemInStack := 0; // Id Not found in Array
		RETURN;	
	END_IF
	
	// Check if the id is in the array
	FOR iIndex := 0 TO TotalElements - 1 DO
		IF Id = StackArray[iIndex].Media.id THEN
			CheckNotItemInStack := 1520; // Id FOUND in Array
			PositionFound := iIndex; // Returning the position where Id is
			RETURN;	
		END_IF
	END_FOR
	
END_FUNCTION
