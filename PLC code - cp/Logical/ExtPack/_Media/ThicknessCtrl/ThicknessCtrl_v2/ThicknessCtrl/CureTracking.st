
ACTION RunCureArray:
	
	//Need to run the matrix through iLastPosition, the max position of the LED
	ShiftArrayForward(ADR(xCuringTracking), SIZEOF(xCuringTracking), SIZEOF(xCuringTracking[0]), iPositionsToRunArray, iLastPosition);
	
	//Load data depending on the source of the media
	LoadCureMediaFromTrackingMedia;
	
END_ACTION

ACTION LoadCureMediaFromTrackingMedia:
	
	IF dataHeigh.status.xNewMediaStackEnabled THEN
		LoadCureMediaFromTrackingMediaStack;
	ELSE
		LoadCureMediaFromTrackingMediaContinuous;
	END_IF

END_ACTION

ACTION LoadCureMediaFromTrackingMediaContinuous:
	
	// Fill-in moved spaces with data from TrackingMedia.
	// The clean area of Tracking media filtered starts in iSensorPosition + iMediaFilter  + iPositionsToRunArray
	//to be sure that the Tracking media has been cleaned after a end of board slower than the filter
	iProdDetectFilterStartIndex := iProductDetectSensorPosition + dataHeigh.parameters.Detection.ProductDetect.iMediaFilter + iPositionsToRunArray;
	FOR iIndexArray := iProdDetectFilterStartIndex TO iProdDetectFilterStartIndex + iPositionsToRunArray DO //Adding extra values to check
		// Line L1
		xCuringTracking[iIndexArray].INDEXCURING_L1_COLOR := xMediaTracking[iIndexArray].INDEXTRACKING_L1;
		xCuringTracking[iIndexArray].INDEXCURING_L1_WHITE := xMediaTracking[iIndexArray].INDEXTRACKING_L1 AND EnteringMediaContinuous.Media.xHasWhite;
		xCuringTracking[iIndexArray].INDEXCURING_L1_PRIMER := xMediaTracking[iIndexArray].INDEXTRACKING_L1 AND EnteringMediaContinuous.Media.xHasClear;
	END_FOR

	IF NOT dataHeigh.parameters.xDoubleLine THEN
		RETURN;
	END_IF
	FOR iIndexArray := iProdDetectFilterStartIndex TO iProdDetectFilterStartIndex + iPositionsToRunArray DO //Adding extra values to check
		// Line L2
		xCuringTracking[iIndexArray].INDEXCURING_L2_COLOR := xMediaTracking[iIndexArray].INDEXTRACKING_L2;
		xCuringTracking[iIndexArray].INDEXCURING_L2_WHITE := xMediaTracking[iIndexArray].INDEXTRACKING_L2 AND EnteringMediaContinuous.Media.xHasWhite;
		xCuringTracking[iIndexArray].INDEXCURING_L2_PRIMER := xMediaTracking[iIndexArray].INDEXTRACKING_L2 AND EnteringMediaContinuous.Media.xHasClear;
	END_FOR
	
END_ACTION

ACTION LoadCureMediaFromTrackingMediaStack:

	LoadCureMediaFromTrackingMediaL1;
	IF dataHeigh.parameters.xDoubleLine THEN
		LoadCureMediaFromTrackingMediaL2;
	END_IF

END_ACTION

ACTION LoadCureMediaFromTrackingMediaL1:
	
	IF MediaTracking_iTotalInsideL1 = 0 THEN
		RETURN;
	END_IF
	
	// Fill-in moved spaces with data from TrackingMedia.
	// The clean area of Tracking media filtered starts in iSensorPosition + iMediaFilter  + iPositionsToRunArray
	//to be sure that the Tracking media has been cleaned after a end of board slower than the filter
	iProdDetectFilterStartIndex := iProductDetectSensorPosition + dataHeigh.parameters.Detection.ProductDetect.iMediaFilter  + THICK_MAX_UPDATE_VALUES + iPositionsToRunArray;
	xDetectedGap_L1 := FALSE;
	FOR iIndexArray := iProdDetectFilterStartIndex TO iProdDetectFilterStartIndex + iPositionsToRunArray DO //Adding extra values to check
		
		// Line L1
		IF NOT xDetectedGap_L1 THEN
			xCuringTracking[iIndexArray].INDEXCURING_L1_COLOR := xMediaTracking[iIndexArray].INDEXTRACKING_L1;
			xCuringTracking[iIndexArray].INDEXCURING_L1_WHITE := xMediaTracking[iIndexArray].INDEXTRACKING_L1 AND EnteringMediaL1.Media.xHasWhite;
			xCuringTracking[iIndexArray].INDEXCURING_L1_PRIMER := xMediaTracking[iIndexArray].INDEXTRACKING_L1 AND EnteringMediaContinuous.Media.xHasClear;
		ELSE
			IF MediaTracking_iTotalInsideL1 >= 2 THEN
				xCuringTracking[iIndexArray].INDEXCURING_L1_COLOR := xMediaTracking[iIndexArray].INDEXTRACKING_L1;
				xCuringTracking[iIndexArray].INDEXCURING_L1_WHITE := xMediaTracking[iIndexArray].INDEXTRACKING_L1 AND MediaTrackingInsideL1[MediaTracking_iTotalInsideL1-2].Media.xHasWhite;
				xCuringTracking[iIndexArray].INDEXCURING_L1_PRIMER := xMediaTracking[iIndexArray].INDEXTRACKING_L1 AND MediaTrackingInsideL1[MediaTracking_iTotalInsideL1-2].Media.xHasClear;
			END_IF
		END_IF

		//Detecting the gap inside the positions to tun
		IF xMediaTracking[iIndexArray].INDEXTRACKING_L1 AND NOT xMediaTracking[iIndexArray+1].INDEXTRACKING_L1 THEN xDetectedGap_L1 := TRUE; END_IF
		
	END_FOR

END_ACTION

ACTION LoadCureMediaFromTrackingMediaL2:
	
	IF MediaTracking_iTotalInsideL2 = 0 THEN
		RETURN;
	END_IF
	
	// Fill-in moved spaces with data from TrackingMedia.
	// The clean area of Tracking media filtered starts in iSensorPosition + iMediaFilter  + iPositionsToRunArray
	//to be sure that the Tracking media has been cleaned after a end of board slower than the filter
	iProdDetectFilterStartIndex := iProductDetectSensorPosition + dataHeigh.parameters.Detection.ProductDetect.iMediaFilter + iPositionsToRunArray;
	xDetectedGap_L2 := FALSE;
	FOR iIndexArray := iProdDetectFilterStartIndex TO iProdDetectFilterStartIndex + iPositionsToRunArray DO //Adding extra values to check
		
		// Line L2
		IF NOT xDetectedGap_L2 THEN
			xCuringTracking[iIndexArray].INDEXCURING_L2_COLOR := xMediaTracking[iIndexArray].INDEXTRACKING_L2;
			xCuringTracking[iIndexArray].INDEXCURING_L2_WHITE := xMediaTracking[iIndexArray].INDEXTRACKING_L2 AND EnteringMediaL2.Media.xHasWhite;
			xCuringTracking[iIndexArray].INDEXCURING_L2_PRIMER := xMediaTracking[iIndexArray].INDEXTRACKING_L2 AND EnteringMediaL2.Media.xHasClear;
		ELSE
			IF MediaTracking_iTotalInsideL2 >= 2 THEN
				xCuringTracking[iIndexArray].INDEXCURING_L2_COLOR := xMediaTracking[iIndexArray].INDEXTRACKING_L2;
				xCuringTracking[iIndexArray].INDEXCURING_L2_WHITE := xMediaTracking[iIndexArray].INDEXTRACKING_L2 AND MediaTrackingInsideL2[MediaTracking_iTotalInsideL2-2].Media.xHasWhite;
				xCuringTracking[iIndexArray].INDEXCURING_L2_PRIMER := xMediaTracking[iIndexArray].INDEXTRACKING_L2 AND MediaTrackingInsideL2[MediaTracking_iTotalInsideL2-2].Media.xHasClear;
			END_IF
		END_IF

		//Detecting the gap inside the positions to tun
		IF xMediaTracking[iIndexArray].INDEXTRACKING_L2 AND NOT xMediaTracking[iIndexArray+1].INDEXTRACKING_L2 THEN xDetectedGap_L2 := TRUE; END_IF
		
	END_FOR

END_ACTION

ACTION ReviewCuringActivation:
	
	//White
	CureLampParams ACCESS ADR(dataHeigh.parameters.Cure.White);
	IF CureLampParams.xEnabled THEN
		iStartCuringWindow := LIMIT(1, CureLampParams.iStartWindow, iMAXTRACKINGARRAY);
		iEndCuringWindow := LIMIT(1, CureLampParams.iEndWindow, iMAXTRACKINGARRAY);
		IF NOT dataHeigh.parameters.Cure.xEnableMediaTracking THEN
			ReviewCuringActivationWhite;
		ELSE
			dataHeigh.status.MediaPosition.L1.White.xMediaInLedPosition := ReviewMediaTrackingInPosition(ADR(MediaTrackingInsideL1), MediaTracking_iTotalInsideL1, iStartCuringWindow, iEndCuringWindow, TRUE);
			IF dataHeigh.parameters.xDoubleLine THEN
				dataHeigh.status.MediaPosition.L2.White.xMediaInLedPosition := ReviewMediaTrackingInPosition(ADR(MediaTrackingInsideL2), MediaTracking_iTotalInsideL2, iStartCuringWindow, iEndCuringWindow, TRUE);
			END_IF
			
		END_IF
	END_IF
	
	//Color
	CureLampParams ACCESS ADR(dataHeigh.parameters.Cure.Color);
	IF CureLampParams.xEnabled THEN
		iStartCuringWindow := LIMIT(1, CureLampParams.iStartWindow, iMAXTRACKINGARRAY);
		iEndCuringWindow := LIMIT(1, CureLampParams.iEndWindow, iMAXTRACKINGARRAY);
		IF NOT dataHeigh.parameters.Cure.xEnableMediaTracking THEN
			ReviewCuringActivationColor;
		ELSE
			dataHeigh.status.MediaPosition.L1.Color.xMediaInLedPosition := ReviewMediaTrackingInPosition(ADR(MediaTrackingInsideL1), MediaTracking_iTotalInsideL1, iStartCuringWindow, iEndCuringWindow, FALSE);
			IF dataHeigh.parameters.xDoubleLine THEN
				dataHeigh.status.MediaPosition.L2.Color.xMediaInLedPosition := ReviewMediaTrackingInPosition(ADR(MediaTrackingInsideL2), MediaTracking_iTotalInsideL2, iStartCuringWindow, iEndCuringWindow, FALSE);
			END_IF
		END_IF
	END_IF	
	
	//Primer
	CureLampParams ACCESS ADR(dataHeigh.parameters.Cure.Primer);
	IF CureLampParams.xEnabled THEN
		iStartCuringWindow := LIMIT(1, CureLampParams.iStartWindow, iMAXTRACKINGARRAY);
		iEndCuringWindow := LIMIT(1, CureLampParams.iEndWindow, iMAXTRACKINGARRAY);
		IF NOT dataHeigh.parameters.Cure.xEnableMediaTracking THEN
			ReviewCuringActivationPrimer;
		ELSE
			dataHeigh.status.MediaPosition.L1.Primer.xMediaInLedPosition := ReviewMediaTrackingInPosition(ADR(MediaTrackingInsideL1), MediaTracking_iTotalInsideL1, iStartCuringWindow, iEndCuringWindow, FALSE);
			IF dataHeigh.parameters.xDoubleLine THEN
				dataHeigh.status.MediaPosition.L2.Primer.xMediaInLedPosition := ReviewMediaTrackingInPosition(ADR(MediaTrackingInsideL2), MediaTracking_iTotalInsideL2, iStartCuringWindow, iEndCuringWindow, FALSE);
			END_IF
		END_IF
	END_IF
END_ACTION


ACTION ReviewCuringActivationWhite:
	
	ReviewCuringActivationWhiteL1;
	IF dataHeigh.parameters.xDoubleLine THEN
		ReviewCuringActivationWhiteL2;
	END_IF	
	
END_ACTION

ACTION ReviewCuringActivationWhiteL1:
	
	xMediaInLedPositionWhiteL1 := FALSE;
	FOR iIndexWindow := iStartCuringWindow TO iEndCuringWindow DO
		IF xCuringTracking[iIndexWindow].INDEXCURING_L1_WHITE THEN 
			xMediaInLedPositionWhiteL1 := TRUE;
			EXIT;
		END_IF
	END_FOR
	dataHeigh.status.MediaPosition.L1.White.xMediaInLedPosition := xMediaInLedPositionWhiteL1;
	
END_ACTION

ACTION ReviewCuringActivationWhiteL2:
	
	xMediaInLedPositionWhiteL2 := FALSE;
	FOR iIndexWindow := iStartCuringWindow TO iEndCuringWindow DO
		IF xCuringTracking[iIndexWindow].INDEXCURING_L2_WHITE THEN 
			xMediaInLedPositionWhiteL2 := TRUE;
			EXIT;
		END_IF
	END_FOR
	dataHeigh.status.MediaPosition.L2.White.xMediaInLedPosition := xMediaInLedPositionWhiteL2;
	
END_ACTION

ACTION ReviewCuringActivationColor:
	
	ReviewCuringActivationColorL1;
	IF dataHeigh.parameters.xDoubleLine THEN
		ReviewCuringActivationColorL2;
	END_IF	
	
END_ACTION

ACTION ReviewCuringActivationColorL1:
	
	xMediaInLedPositionColorL1 := FALSE;
	FOR iIndexWindow := iStartCuringWindow TO iEndCuringWindow DO
		IF xCuringTracking[iIndexWindow].INDEXCURING_L1_COLOR THEN 
			xMediaInLedPositionColorL1 := TRUE;
			EXIT;
		END_IF
	END_FOR
	dataHeigh.status.MediaPosition.L1.Color.xMediaInLedPosition := xMediaInLedPositionColorL1;
	
END_ACTION

ACTION ReviewCuringActivationColorL2:
	
	xMediaInLedPositionColorL2 := FALSE;
	FOR iIndexWindow := iStartCuringWindow TO iEndCuringWindow DO
		IF xCuringTracking[iIndexWindow].INDEXCURING_L2_COLOR THEN 
			xMediaInLedPositionColorL2 := TRUE;
			EXIT;
		END_IF
	END_FOR
	dataHeigh.status.MediaPosition.L2.Color.xMediaInLedPosition := xMediaInLedPositionColorL2;
	
END_ACTION

ACTION ReviewCuringActivationPrimer:
	
	ReviewCuringActivationPrimerL1;
	IF dataHeigh.parameters.xDoubleLine THEN
		ReviewCuringActivationPrimerL2;
	END_IF	
	
END_ACTION

ACTION ReviewCuringActivationPrimerL1:
	
	xMediaInLedPositionPrimerL1 := FALSE;
	FOR iIndexWindow := iStartCuringWindow TO iEndCuringWindow DO
		IF xCuringTracking[iIndexWindow].INDEXCURING_L1_PRIMER THEN 
			xMediaInLedPositionPrimerL1 := TRUE;
			EXIT;
		END_IF
	END_FOR
	dataHeigh.status.MediaPosition.L1.Primer.xMediaInLedPosition := xMediaInLedPositionPrimerL1;
	
END_ACTION

ACTION ReviewCuringActivationPrimerL2:
	
	xMediaInLedPositionPrimerL2 := FALSE;
	FOR iIndexWindow := iStartCuringWindow TO iEndCuringWindow DO
		IF xCuringTracking[iIndexWindow].INDEXCURING_L2_PRIMER THEN 
			xMediaInLedPositionPrimerL2 := TRUE;
			EXIT;
		END_IF
	END_FOR
	dataHeigh.status.MediaPosition.L2.Primer.xMediaInLedPosition := xMediaInLedPositionPrimerL2;
	
END_ACTION


