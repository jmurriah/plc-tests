
ACTION RunMediaArray:

	//Need to run the matrix through all belts
	ShiftArrayForward(ADR(xMediaTracking), SIZEOF(xMediaTracking), SIZEOF(xMediaTracking[0]), iPositionsToRunArray, iMaxTrackingPosition + THICK_MAX_UPDATE_VALUES); //Ading extra values to allow view the edges for exiting
	
	//Load data depending on the source of the media
	IF dataHeigh.parameters.Detection.ProductDetect.xLoadMedia THEN
		LoadAndCheckMediaFromProductDetectL1;
		IF dataHeigh.parameters.xDoubleLine THEN
			LoadAndCheckMediaFromProductDetectL2;
		END_IF
		// Using the Inside arrays just if Curing or Drying is enabled in tracking
		IF dataHeigh.status.xMediaTrackingEnabled THEN
			iSensorFilterStartIndex := iProductDetectSensorPosition + dataHeigh.parameters.Detection.ProductDetect.iMediaFilter;
			CheckFinishEnteringMedia;
			iSensorFilterStartIndex := iProductDetectSensorPosition + dataHeigh.parameters.Detection.ProductDetect.iMediaFilter;
			CheckEnteringMedia;
		END_IF
	END_IF
	
	// Allow the detection from the arraySensors independent of if it is used to load main data
	IF gPhotoCells.status.xInstalled THEN
		//Calculating number of positions to be updated
		iNumberOfPositionsToBeUpdated := dataHeigh.parameters.Detection.Array.iMediaFilter + THICK_MAX_UPDATE_VALUES;
		IF dataHeigh.Commands.xReviewIncoherenceArrayAndPd THEN
			iNumberOfPositionsToBeUpdated := iNumberOfPositionsToBeUpdated + dataHeigh.parameters.iDistanceFromArrayToPd;
		END_IF
		ShiftArrayForward(ADR(xMediaPresentArray), SIZEOF(xMediaPresentArray), SIZEOF(xMediaPresentArray[0]), iPositionsToRunArray, iNumberOfPositionsToBeUpdated);

		LoadMediaFromArraySensor;

		IF dataHeigh.parameters.Detection.Array.xLoadMedia THEN
			CheckFilteredArraySensorMedia;
		END_IF
		
		IF dataHeigh.parameters.Detection.Array.xEnableSensorIncoherAlarm THEN
			SensorsArrayAndProductDetectIncoherence;
		END_IF
	END_IF
	
	IF dataHeigh.parameters.Detection.Analog.xLoadMedia AND gDing.State.xDingInstalled THEN
		//Calculating number of positions to be updated
		iNumberOfPositionsToBeUpdated := dataHeigh.parameters.Detection.Analog.iMediaFilter + THICK_MAX_UPDATE_VALUES;
		
		ShiftArrayForward(ADR(xMediaPresentAnalog), SIZEOF(xMediaPresentAnalog), SIZEOF(xMediaPresentAnalog[0]), iPositionsToRunArray, iNumberOfPositionsToBeUpdated);
		LoadMediaFromAnalogSensor;
		CheckFilteredAnalogSensorMedia;
	END_IF
	
	IF dataHeigh.parameters.Detection.Basic.xLoadMedia AND gBasicDetectMedia.Status.xInstalled THEN
		//Calculating number of positions to be updated
		iNumberOfPositionsToBeUpdated := dataHeigh.parameters.Detection.Basic.iMediaFilter + THICK_MAX_UPDATE_VALUES;
		
		ShiftArrayForward(ADR(xMediaPresentBasic), SIZEOF(xMediaPresentBasic), SIZEOF(xMediaPresentBasic[0]), iPositionsToRunArray, iNumberOfPositionsToBeUpdated);
		LoadMediaFromBasicDetectMedia;
		
		// MediaTracking can just be loaded from one source data
		IF dataHeigh.parameters.Detection.Basic.xEnableMediaTracking AND NOT dataHeigh.parameters.Detection.ProductDetect.xLoadMedia THEN
			// Load the data from Basic into MediaTracking to allow working with internal arrays of media inside the machine
			LoadMediaFromFastDataLine(ADR(dataHeigh.Internal.MediaDetectionValuesL1), dataHeigh.Internal.rFastValues, INDEXTRACKING_L1, iPositionsToRunArray, dataHeigh.parameters.Detection.Basic.iSensorPosition, ADR(xMediaTracking));
			IF dataHeigh.parameters.xDoubleLine THEN
				LoadMediaFromFastDataLine(ADR(dataHeigh.Internal.MediaDetectionValuesL2), dataHeigh.Internal.rFastValues, INDEXTRACKING_L2, iPositionsToRunArray, dataHeigh.parameters.Detection.Basic.iSensorPosition, ADR(xMediaTracking));
			END_IF
			// Loading media with Basic just if there is no ProductDetec (mainly in Dryer)
			IF dataHeigh.status.xMediaTrackingEnabled THEN
				iSensorFilterStartIndex := dataHeigh.parameters.Detection.Basic.iSensorPosition + dataHeigh.parameters.Detection.Basic.iMediaFilter;
				CheckFinishEnteringMedia;
				iSensorFilterStartIndex := dataHeigh.parameters.Detection.Basic.iSensorPosition + dataHeigh.parameters.Detection.Basic.iMediaFilter;
				CheckEnteringMedia;
			END_IF
		END_IF
		CheckFilteredBasicDetectionMedia;
	END_IF
	
	
	dataHeigh.Outputs.xMediaFiltered := xFilteredProductDetectMediaL1 OR xFilteredProductDetectMediaL2 OR xFilteredArraySensorMedia OR xFilteredAnalogSensorMedia OR xFilteredBasicDetectionMedia;
	
	// In case any tracking active, RUN and check exiting
	IF dataHeigh.status.xMediaTrackingEnabled THEN
		RunMediaInsidePositions;
		CheckExitingMedia;
	END_IF
	
	MediaTracking_xEnteringMachineL1 := MediaTracking_iTotalInsideL1>MediaTracking_iTotalInsideL1_cp;
	MediaTracking_xEnteringMachineL2 := MediaTracking_iTotalInsideL2>MediaTracking_iTotalInsideL2_cp;
	MediaTracking_iTotalInsideL1_cp := MediaTracking_iTotalInsideL1;
	MediaTracking_iTotalInsideL2_cp := MediaTracking_iTotalInsideL2;

END_ACTION

ACTION LoadAndCheckMediaFromProductDetectL1:
	LoadMediaFromProductDetectL1;
	CheckAndCleanProductDetectMediaFilterL1;
	CheckFilteredProductDetectMediaL1;
END_ACTION

ACTION LoadAndCheckMediaFromProductDetectL2:
	LoadMediaFromProductDetectL2;
	CheckAndCleanProductDetectMediaFilterL2;
	CheckFilteredProductDetectMediaL2;
END_ACTION

ACTION LoadMediaFromProductDetectL1: 

	LoadMediaFromFastDataLine(ADR(dataHeigh.Internal.ProductDetectValuesL1), dataHeigh.Internal.rFastValues, INDEXTRACKING_L1, iPositionsToRunArray, iProductDetectSensorPosition, ADR(xMediaTracking));
	
END_ACTION

ACTION LoadMediaFromProductDetectL2:
	
	LoadMediaFromFastDataLine(ADR(dataHeigh.Internal.ProductDetectValuesL2), dataHeigh.Internal.rFastValues, INDEXTRACKING_L2, iPositionsToRunArray, iProductDetectSensorPosition, ADR(xMediaTracking));

END_ACTION

ACTION LoadMediaFromAnalogSensor: 
	
	LoadMediaFromFastDataBool(ADR(dataHeigh.Internal.MediaAnalogValues), dataHeigh.Internal.rFastValues, iPositionsToRunArray, 0, ADR(xMediaPresentAnalog));

END_ACTION

ACTION LoadMediaFromArraySensor: 

	LoadMediaFromFastDataBool(ADR(dataHeigh.Internal.MediaArraySensorValues), dataHeigh.Internal.rFastValues, iPositionsToRunArray, 0, ADR(xMediaPresentArray));

END_ACTION


ACTION LoadMediaFromBasicDetectMedia: 
	
	LoadMediaFromFastDataBool(ADR(dataHeigh.Internal.MediaDetectionValues), dataHeigh.Internal.rFastValues, iPositionsToRunArray, 0, ADR(xMediaPresentBasic));

END_ACTION

ACTION CheckFilteredProductDetectMediaL1: 
	
	xFilteredProductDetectMediaL1 := CheckFilteredMediaLine(ADR(xMediaTracking), INDEXTRACKING_L1, iProductDetectSensorPosition, dataHeigh.parameters.Detection.ProductDetect.iMediaFilter);
	dataHeigh.status.Detection.xFilteredProductDetectMediaL1 := xFilteredProductDetectMediaL1;

END_ACTION
	
ACTION CheckFilteredProductDetectMediaL2:	
		
	xFilteredProductDetectMediaL2 := CheckFilteredMediaLine(ADR(xMediaTracking), INDEXTRACKING_L2, iProductDetectSensorPosition, dataHeigh.parameters.Detection.ProductDetect.iMediaFilter);
	dataHeigh.status.Detection.xFilteredProductDetectMediaL2 := xFilteredProductDetectMediaL2;

END_ACTION

ACTION CheckFilteredAnalogSensorMedia: 

	xFilteredAnalogSensorMedia := CheckFilteredMediaBool(ADR(xMediaPresentAnalog), 0, dataHeigh.parameters.Detection.Analog.iMediaFilter);
	dataHeigh.status.Detection.xFilteredAnalogSensorMedia := xFilteredAnalogSensorMedia;
	
END_ACTION

ACTION CheckFilteredArraySensorMedia: 
	
	xFilteredArraySensorMedia := CheckFilteredMediaBool(ADR(xMediaPresentArray), 0, dataHeigh.parameters.Detection.Array.iMediaFilter);
	dataHeigh.status.Detection.xFilteredArraySensorMedia := xFilteredArraySensorMedia;

END_ACTION

ACTION CheckFilteredBasicDetectionMedia: 
	
	xFilteredBasicDetectionMedia := CheckFilteredMediaBool(ADR(xMediaPresentBasic), 0, dataHeigh.parameters.Detection.Basic.iMediaFilter);
	dataHeigh.status.Detection.xFilteredBasicDetectionMedia := xFilteredBasicDetectionMedia;
	
END_ACTION

ACTION CheckAndCleanProductDetectMediaFilterL1:
	
	// With a 0, filter is disabled
	IF dataHeigh.parameters.Detection.ProductDetect.iMediaFilter = 0 THEN
		RETURN;
	END_IF
	
	//Starting from the sensor position and reviewing for each end of board if the new board in consistent enough
	iProdDetectFilterStartIndex := iProductDetectSensorPosition;
	
	FOR iIndexArray := iProdDetectFilterStartIndex TO iProdDetectFilterStartIndex + iPositionsToRunArray + 1 DO
		
		// Detecting the end of a board.
		// If using the Filter while detecting the start of a board, the end of previous board with small gap can be "cleaned" and would be an error
		IF NOT xMediaTracking[iIndexArray].INDEXTRACKING_L1 AND xMediaTracking[iIndexArray + 1].INDEXTRACKING_L1 THEN
			// Going for the end of the filter. All data has to be true
			// Starting in (iIndexArray + 1) to start checking in TRUE values
			FOR iIndexNewMediaArray := iIndexArray + 1 TO iIndexArray + dataHeigh.parameters.Detection.ProductDetect.iMediaFilter + 1 DO
				//If reading a 0 is because signal is not robust
				IF NOT xMediaTracking[iIndexNewMediaArray].INDEXTRACKING_L1 THEN
					//Clean al data for the false pulse
					FOR iIndexCleanMediaArray := iIndexNewMediaArray TO iIndexArray BY -1 DO
						xMediaTracking[iIndexCleanMediaArray].INDEXTRACKING_L1 := FALSE;
					END_FOR
					EXIT; //The filter has not been validated, so not keep on searching for FALSEs
				END_IF
			END_FOR
		END_IF
	END_FOR
		
END_ACTION

ACTION CheckAndCleanProductDetectMediaFilterL2:
	
	// With a 0, filter is disabled
	IF dataHeigh.parameters.Detection.ProductDetect.iMediaFilter = 0 THEN
		RETURN;
	END_IF
	
	//Starting from the sensor position and reviewing for each end of board if the new board in consistent enough
	iProdDetectFilterStartIndex := iProductDetectSensorPosition;
	
	FOR iIndexArray := iProdDetectFilterStartIndex TO iProdDetectFilterStartIndex + iPositionsToRunArray + 1 DO
		
		// Detecting the end of a board.
		// If using the Filter while detecting the start of a board, the end of previos board with small gap can be "cleaned" and would be an error
		IF NOT xMediaTracking[iIndexArray].INDEXTRACKING_L2 AND xMediaTracking[iIndexArray + 1].INDEXTRACKING_L2 THEN
			// Going for the end of the filter. All data has to be true
			// Starting in (iIndexArray + 1) to start checking in TRUE values
			FOR iIndexNewMediaArray := iIndexArray + 1 TO iIndexArray + dataHeigh.parameters.Detection.ProductDetect.iMediaFilter + 1 DO
				//If reading a 0 is because signal is not robust
				IF NOT xMediaTracking[iIndexNewMediaArray].INDEXTRACKING_L2 THEN
					//Clean al data for the false pulse
					FOR iIndexCleanMediaArray := iIndexNewMediaArray TO iIndexArray BY -1 DO
						xMediaTracking[iIndexCleanMediaArray].INDEXTRACKING_L2 := FALSE;
					END_FOR
					EXIT; //The filter has not been validated, so not keep on searching for FALSEs
				END_IF
			END_FOR
		END_IF
	END_FOR
		
END_ACTION

(* Needs to be called updating the value of iSensorFilterStartIndex in the form: iSensorFilterStartIndex := iXXXXSensorPosition + dataHeigh.parameters.Detection.XXXXX.iMediaFilter  *)
ACTION CheckEnteringMedia:
	
	// Old code. This assignation has to be done before calling the ACTION
	//iSensorFilterStartIndex := iProductDetectSensorPosition + dataHeigh.parameters.Detection.ProductDetect.iMediaFilter + THICK_MAX_UPDATE_VALUES;
	// Adding THICK_MAX_UPDATE_VALUES has been removed because it has no sense. Here the index is cm and THICK_MAX_UPDATE_VALUES is data from Fast into Slow
	
	// Run the exact positions moved to avoid detecting the begining of a board more than once
	FOR iIndexEnteringMedia := iSensorFilterStartIndex TO iSensorFilterStartIndex + iPositionsToRunArray - 1 DO
		// Detecting the start of a board once the filter is full with media
		IF xMediaTracking[iIndexEnteringMedia].INDEXTRACKING_L1 AND NOT xMediaTracking[iIndexEnteringMedia + 1].INDEXTRACKING_L1 THEN
			NewMediaEnteringL1;
			EXIT; //The new board has been detected, so not keep on searching for FALSEs
		END_IF
	END_FOR

	// Run the exact positions moved to avoid detecting the begining of a board more than once
	IF NOT dataHeigh.parameters.xDoubleLine THEN
		RETURN;
	END_IF	
	FOR iIndexArray := iSensorFilterStartIndex TO iSensorFilterStartIndex + iPositionsToRunArray -1 DO
		// Detecting the start of a board once the filter is full with media
		IF xMediaTracking[iIndexArray].INDEXTRACKING_L2 AND NOT xMediaTracking[iIndexArray + 1].INDEXTRACKING_L2 THEN
			NewMediaEnteringL2;
			EXIT; //The new board has been detected, so not keep on searching for FALSEs
		END_IF
	END_FOR
		
END_ACTION

(* Needs to be called updating the value of iSensorFilterStartIndex in the form: iSensorFilterStartIndex := iXXXXSensorPosition + dataHeigh.parameters.Detection.XXXXX.iMediaFilter  *)
ACTION CheckFinishEnteringMedia:
	
	// Old code. This assignation has to be done before calling the ACTION
	//iSensorFilterStartIndex := iProductDetectSensorPosition + dataHeigh.parameters.Detection.ProductDetect.iMediaFilter + THICK_MAX_UPDATE_VALUES;
	// Adding THICK_MAX_UPDATE_VALUES has been removed because it has no sense. Here the index is cm and THICK_MAX_UPDATE_VALUES is data from Fast into Slow
	
	// Run the exact positions moved to avoid detecting the begining of a board more than once
	FOR iIndexFinishEnteringMedia := iSensorFilterStartIndex TO iSensorFilterStartIndex + iPositionsToRunArray - 1 DO
		// Detecting the start of a board once the filter is full with media
		IF NOT xMediaTracking[iIndexFinishEnteringMedia].INDEXTRACKING_L1 AND xMediaTracking[iIndexFinishEnteringMedia + 1].INDEXTRACKING_L1 THEN
			FinishEnteringMediaL1;
			EXIT; //The new board has been detected, so not keep on searching for FALSEs
		END_IF
	END_FOR

	// Run the exact positions moved to avoid detecting the begining of a board more than once
	IF NOT dataHeigh.parameters.xDoubleLine THEN
		RETURN;
	END_IF	
	FOR iIndexArray := iSensorFilterStartIndex TO iSensorFilterStartIndex + iPositionsToRunArray -1 DO
		// Detecting the start of a board once the filter is full with media
		IF NOT xMediaTracking[iIndexArray].INDEXTRACKING_L2 AND xMediaTracking[iIndexArray + 1].INDEXTRACKING_L2 THEN
			FinishEnteringMediaL2;
			EXIT; //The new board has been detected, so not keep on searching for FALSEs
		END_IF
	END_FOR
		
END_ACTION

ACTION NewMediaEnteringL1:
	
	iBoardsBelowBlockL1 := iBoardsBelowBlockL1 + 1;
	dataHeigh.status.Detection.iBoardsFromStartL1 := dataHeigh.status.Detection.iBoardsFromStartL1 + 1;
	dataHeigh.status.Detection.iTotalBoardsL1 := dataHeigh.status.Detection.iTotalBoardsL1 + 1;
	MoveMediaFromNewToInsideL1;
	MediaTracking_iTotalInsideL1; //Just to enable monitor it

END_ACTION

ACTION NewMediaEnteringL2:
	
	iBoardsBelowBlockL2 := iBoardsBelowBlockL2 + 1;
	dataHeigh.status.Detection.iBoardsFromStartL2 := dataHeigh.status.Detection.iBoardsFromStartL2 + 1;
	dataHeigh.status.Detection.iTotalBoardsL2 := dataHeigh.status.Detection.iTotalBoardsL2 + 1;
	MoveMediaFromNewToInsideL2;
	MediaTracking_iTotalInsideL2; //Just to enable monitor it

END_ACTION

(* Assigning the value of the Tail position of the media   *)
ACTION FinishEnteringMediaL1:
	
	// Protection if not media inside
	IF MediaTracking_iTotalInsideL1 = 0 THEN
		RETURN;
	END_IF
	
	IF dataHeigh.parameters.Detection.ProductDetect.xLoadMedia THEN
		MediaTrackingInsideL1[MediaTracking_iTotalInsideL1 - 1].TailPosition := iIndexFinishEnteringMedia;
	ELSIF dataHeigh.parameters.Detection.Basic.xEnableMediaTracking THEN
		MediaTrackingInsideL1[MediaTracking_iTotalInsideL1 - 1].TailPosition := dataHeigh.parameters.Detection.Basic.iSensorPosition + dataHeigh.parameters.Detection.Basic.iMediaFilter;
	END_IF
	
	AddMediaTrackingEvents(diTotalCmBelt, TAIL_DETECTED, ADR(TrackingEventsArray));

END_ACTION

ACTION FinishEnteringMediaL2:
	
	// Protection if not media inside
	IF MediaTracking_iTotalInsideL2 = 0 THEN
		RETURN;
	END_IF

	IF dataHeigh.parameters.Detection.ProductDetect.xLoadMedia THEN
		MediaTrackingInsideL1[MediaTracking_iTotalInsideL2 - 1].TailPosition := iProductDetectSensorPosition + dataHeigh.parameters.Detection.ProductDetect.iMediaFilter;
	ELSIF dataHeigh.parameters.Detection.Basic.xEnableMediaTracking THEN
		MediaTrackingInsideL1[MediaTracking_iTotalInsideL2 - 1].TailPosition := dataHeigh.parameters.Detection.Basic.iSensorPosition + dataHeigh.parameters.Detection.Basic.iMediaFilter;
	END_IF

	AddMediaTrackingEvents(diTotalCmBelt, TAIL_DETECTED, ADR(TrackingEventsArray));
	
END_ACTION

ACTION CheckExitingMedia:
	
	//Move out media that hasn't been properly detected
	IF dataHeigh.parameters.Detection.Basic.xEnableMediaTracking THEN
		// If the tail is 50cm far away from the exiting position, move it out
		IF MediaTrackingInsideL1[0].TailPosition > iRejectLengthAdjustment + 50 THEN
			NewMediaExitingL1;
			iForcedMovedOutMediaL1 := iForcedMovedOutMediaL1 + 1;
		END_IF
		// If the tail is 50cm far away from the exiting position, move it out
		IF MediaTrackingInsideL2[0].TailPosition > iRejectLengthAdjustment + 50 THEN
			NewMediaExitingL2;
			iForcedMovedOutMediaL2 := iForcedMovedOutMediaL2 + 1;
		END_IF		
	END_IF
	
	// Run the exact positions moved to avoid detecting the begining of a board more than once
	FOR iIndexExitingMedia := iRejectLengthAdjustment TO iRejectLengthAdjustment + iPositionsToRunArray - 1 DO
		// Detecting the end of a board
		IF NOT xMediaTracking[iIndexExitingMedia].INDEXTRACKING_L1 AND xMediaTracking[iIndexExitingMedia + 1].INDEXTRACKING_L1 THEN
			NewMediaExitingL1;
			EXIT; //The new board has been detected, so not keep on searching for FALSEs
		END_IF
	END_FOR

	// Run the exact positions moved to avoid detecting the begining of a board more than once
	IF NOT dataHeigh.parameters.xDoubleLine THEN
		RETURN;
	END_IF
	FOR iIndexExitingMedia := iRejectLengthAdjustment TO iRejectLengthAdjustment + iPositionsToRunArray -1 DO
		// Detecting the end of a board
		IF NOT xMediaTracking[iIndexExitingMedia].INDEXTRACKING_L2 AND xMediaTracking[iIndexExitingMedia + 1].INDEXTRACKING_L2 THEN
			NewMediaExitingL2;
			EXIT; //The new board has been detected, so not keep on searching for FALSEs
		END_IF
	END_FOR
		
END_ACTION

ACTION NewMediaExitingL1:
	
	iBoardsBelowBlockL1 := UINT_SUB(iBoardsBelowBlockL1,1);
	MoveMediaFromInsideToOutL1;

END_ACTION

ACTION NewMediaExitingL2:
	
	iBoardsBelowBlockL2 := UINT_SUB(iBoardsBelowBlockL2,1);
	MoveMediaFromInsideToOutL2;

END_ACTION

ACTION SensorsArrayAndProductDetectIncoherence:
	//L1
	//Define review range
	IF iProductDetectSensorPosition >= iPositionsToRunArray THEN
		// Not used max because substracting two UINT, instead of negative can be a maximum value
		iFirstIndex := iProductDetectSensorPosition - iPositionsToRunArray;
	ELSE
		iFirstIndex := 0;
	END_IF
	iLastIndex := iProductDetectSensorPosition + dataHeigh.parameters.Detection.ProductDetect.iMediaFilter + iPositionsToRunArray;
	
	//Review MediaPresentArray
	IF EDGEPOS(xMediaTracking[iProductDetectSensorPosition + dataHeigh.parameters.Detection.ProductDetect.iMediaFilter].INDEXTRACKING_L1) THEN
		xDetectionSystemIncoherenceL1:=TRUE;
		FOR iIndexReviewArray:=iFirstIndex TO iLastIndex DO
			IF xMediaPresentArray[iIndexReviewArray] THEN
				xDetectionSystemIncoherenceL1:=FALSE;
				EXIT;
			END_IF
		END_FOR
	END_IF
	
	IF NOT (xMediaTracking[iProductDetectSensorPosition].INDEXTRACKING_L1) THEN
		xDetectionSystemIncoherenceL1:=FALSE;
	END_IF
		
	dataHeigh.status.MediaPosition.L1.xDetectionSystemIncoherence := xDetectionSystemIncoherenceL1;
	
	
	//L2
	IF NOT dataHeigh.parameters.xDoubleLine THEN
		RETURN;
	END_IF

	//Define review range
	IF iProductDetectSensorPosition >= iPositionsToRunArray THEN
		// Not used max because substracting two UINT, instead of negative can be a maximum value
		iFirstIndex := iProductDetectSensorPosition - iPositionsToRunArray;
	ELSE
		iFirstIndex := 0;
	END_IF
	iLastIndex := iProductDetectSensorPosition + iPositionsToRunArray;
	
	//Review MediaPresentArray
	IF EDGEPOS(xMediaTracking[iProductDetectSensorPosition].INDEXTRACKING_L2) THEN
		xDetectionSystemIncoherenceL2:=TRUE;
		FOR iIndexReviewArray:=iFirstIndex TO iLastIndex DO
			IF xMediaPresentArray[iIndexReviewArray] THEN
				xDetectionSystemIncoherenceL2:=FALSE;
				EXIT;
			END_IF
		END_FOR
	END_IF
	
	IF NOT (xMediaTracking[iProductDetectSensorPosition].INDEXTRACKING_L2) THEN
		xDetectionSystemIncoherenceL2:=FALSE;
	END_IF
	
	dataHeigh.status.MediaPosition.L2.xDetectionSystemIncoherence := xDetectionSystemIncoherenceL2;
	
END_ACTION
