
ACTION AlarmsCheckMedia:

	FilterCheckMediaInputs;
	
	FOR iIndexCheck:=1 TO 1 DO
	//FOR iIndexCheck:=1 TO MAX_LAST_CHECKMEDIA DO
		CheckMediaIndex;
	END_FOR	
	
	IF EDGEPOS(dataHeigh.Inputs.CheckMedia[1].xCheckFail) THEN
		iTotalCheckMediaBoards := iTotalCheckMediaBoards +1;
	END_IF
	
END_ACTION


ACTION CheckMediaIndex:

	IF NOT dataHeigh.parameters.CheckMedia[iIndexCheck].xActive THEN
		RETURN;
	END_IF

	CheckMediaWork ACCESS ADR(dataHeigh.parameters.CheckMedia[iIndexCheck]);
	
	CheckMediaFrontEdgeBoardSearch;
	
	IF xFrontEdgeBoardInChekMedia AND NOT tofNewCheckBoardTracking.Q THEN
		iTotalCheckMediaTrackingBoards := iTotalCheckMediaTrackingBoards + 1;
	END_IF
	tofNewCheckBoardTracking.IN := xFrontEdgeBoardInChekMedia;
	tofNewCheckBoardTracking.PT := t#500ms;
	tofNewCheckBoardTracking();
	
	IF xFrontEdgeBoardInChekMedia AND NOT dataHeigh.Internal.CheckMediaFilteredSensors[1] THEN
		dataHeigh.Alarms.CheckMediaHead[iIndexCheck] := TRUE;
	END_IF
	
	IF CheckMediaWork.xCheckGap THEN
		CheckMediaTailEdgeBoardSearch;
		IF xRearEdgeBoardInChekMedia AND dataHeigh.Internal.CheckMediaFilteredSensors[1] THEN
			dataHeigh.Alarms.CheckMediaTail[iIndexCheck] := TRUE;
		END_IF
	END_IF

	// Assigning the summary alarm
	IF dataHeigh.Alarms.CheckMediaHead[iIndexCheck] OR dataHeigh.Alarms.CheckMediaTail[iIndexCheck] THEN
		dataHeigh.Alarms.CheckMedia[iIndexCheck] := TRUE;
	END_IF


END_ACTION

ACTION CheckMediaFrontEdgeBoardSearch:

	iIndexPositionToReviewMedia:= CheckMediaWork.CheckPosition + CheckMediaWork.CheckDelayPosition - MAX(1, iPositionsToRunArray + 2); //Increasing the quantity of data to avoid not checking any position during accelerations

	xFrontEdgeBoardInChekMedia := FALSE;
	// Search for the boards "head" in Sensor position
	FOR iIndexMediaPresent := CheckMediaWork.CheckPosition + CheckMediaWork.CheckDelayPosition TO iIndexPositionToReviewMedia BY -1 DO
		IF xMediaTracking[iIndexMediaPresent] > 0 AND xMediaTracking[iIndexMediaPresent+1] = 0 THEN
			xFrontEdgeBoardInChekMedia:=TRUE;
		END_IF
	END_FOR

END_ACTION

ACTION CheckMediaTailEdgeBoardSearch:

	iIndexPositionToReviewMedia:= CheckMediaWork.CheckPosition + CheckMediaWork.CheckDelayPosition - MAX(1, iPositionsToRunArray + 2); //Increasing the quantity of data to avoid not checking any position during accelerations

	xRearEdgeBoardInChekMedia := FALSE;
	// Search for the boards "head" in Sensor position
	FOR iIndexMediaPresent := CheckMediaWork.CheckPosition + CheckMediaWork.CheckDelayPosition TO iIndexPositionToReviewMedia BY -1 DO
		IF xMediaTracking[iIndexMediaPresent] = 0 AND xMediaTracking[iIndexMediaPresent+1] > 0 THEN
			xRearEdgeBoardInChekMedia:=TRUE;
		END_IF
	END_FOR

END_ACTION

// This action is called before checking the alarms
ACTION FilterCheckMediaInputs:

	tonFilterCheckMediaSensor[1].IN := NOT EDGE(dataHeigh.Inputs.CheckMedia[1].xCheckFail);
	tonFilterCheckMediaSensor[1].PT := TimeFromMmAndMmin(dataHeigh.parameters.CheckMedia[1].iSensorFilter, dataHeigh.parameters.Belt.rBeltSpeed) ;
	tonFilterCheckMediaSensor[1]();
	
	// Just with the signal stable raises the timer
	IF EDGEPOS(tonFilterCheckMediaSensor[1].Q) THEN
		dataHeigh.Internal.CheckMediaFilteredSensors[1] := dataHeigh.Inputs.CheckMedia[1].xCheckFail;
		IF dataHeigh.Inputs.CheckMedia[1].xCheckFail THEN
			iTotalCheckMediaTrackBoardsFilt := iTotalCheckMediaTrackBoardsFilt + 1;
		END_IF
	END_IF
	
	
END_ACTION