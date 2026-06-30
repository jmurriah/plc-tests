
ACTION Belt_Tracking: 

	// -----    TRACKING NOTES ----------------------------
	//  In the story OF the code, some tests can be review:
	//
	// 1.- Testing with PAPER tryint TO scale AND MOVE one square:
	//    Not really smooth. Problems tryint to return to the original scale.
	//    Probles with timing. Difficult to update properly
	//    DISCARDED
	//
	// 2.- Creating different shapes for different lengths in media. Showing each one
	//    and when the media with tail, move it:
	//    Not really smooth.
	//    DISCARDED
	//
	// 3.- Defining small squares and showing them if media below:
	//    Mucho more better
	//    USING IT
		
	Belt_MediaPresentAux := Belt_MediaPresentReseted;
	Belt_iStartPosition := gThicknessCtrl.parameters.Detection.ProductDetect.iSensorPosition + gThicknessCtrl.parameters.Detection.ProductDetect.iMediaFilter + 2;
	Belt_iLastPosition := gThicknessCtrl.parameters.iTotalBlocksLengh;
	Belt_rResolution := UINT_TO_REAL(gThicknessCtrl.parameters.iTotalBlocksLengh - Belt_iStartPosition)/100;
	FOR Belt_iIndexMediaTracking := 0 TO THICK_MEDIATRACKING_MAX_MEDIA DO
		FOR Belt_iIndexTracking :=0 TO 99 DO
			TrackingIndex;
		END_FOR
	END_FOR
	Belt_MediaPresent := Belt_MediaPresentAux;
	
	
	// Curing information
	Belt_MediaCuring := Belt_MediaPresentReseted;
	
	Belt_iCureStart := TRUNC( UINT_TO_REAL(gThicknessCtrl.parameters.Cure.White.iStartWindow - Belt_iStartPosition)/Belt_rResolution);;
	Belt_iCureEnd := TRUNC( UINT_TO_REAL(gThicknessCtrl.parameters.Cure.White.iEndWindow - Belt_iStartPosition)/Belt_rResolution) + 1;
	IF gCuringLed[iIndexWhiteCuringLedBar].Status.xEmitting THEN
		FOR Belt_iIndexTracking := Belt_iCureStart TO Belt_iCureEnd DO
			CuringIndex;
		END_FOR
	END_IF
	
	Belt_iCureStart := TRUNC( UINT_TO_REAL(gThicknessCtrl.parameters.Cure.Color.iStartWindow - Belt_iStartPosition)/Belt_rResolution);;
	Belt_iCureEnd := TRUNC( UINT_TO_REAL(gThicknessCtrl.parameters.Cure.Color.iEndWindow - Belt_iStartPosition)/Belt_rResolution) + 1;
	IF gCuringLed[iIndexColorCuringLedBar].Status.xEmitting THEN
		FOR Belt_iIndexTracking := Belt_iCureStart TO Belt_iCureEnd DO
			CuringIndex;
		END_FOR
	END_IF	
	
	
	
END_ACTION


ACTION TrackingIndex:
	
	//If the media is not netering, return
	IF gThicknessCtrl.status.MediaPosition.L1.InsideMedia[Belt_iIndexMediaTracking].HeadPosition = 0 THEN
		RETURN;
	END_IF

	// Media entering
	IF gThicknessCtrl.status.MediaPosition.L1.InsideMedia[Belt_iIndexMediaTracking].TailPosition = 0 THEN
		IF Belt_iIndexTracking < REAL_TO_UINT( UDINT_TO_REAL(gThicknessCtrl.status.MediaPosition.L1.InsideMedia[Belt_iIndexMediaTracking].HeadPosition - Belt_iStartPosition)/Belt_rResolution ) THEN
			Belt_MediaPresentAux[Belt_iIndexTracking] := TRUE;
		END_IF

		// Values in head and tail
	ELSE
		IF (Belt_iIndexTracking < REAL_TO_UINT( UDINT_TO_REAL(gThicknessCtrl.status.MediaPosition.L1.InsideMedia[Belt_iIndexMediaTracking].HeadPosition - Belt_iStartPosition)/Belt_rResolution ) AND 
			Belt_iIndexTracking > REAL_TO_UINT( UDINT_TO_REAL(gThicknessCtrl.status.MediaPosition.L1.InsideMedia[Belt_iIndexMediaTracking].TailPosition - Belt_iStartPosition)/Belt_rResolution ) )		THEN
			Belt_MediaPresentAux[Belt_iIndexTracking] := TRUE;
		END_IF		
	END_IF
	
END_ACTION



ACTION CuringIndex:
	
	//If the media index is not correct, return
	IF Belt_iIndexTracking > 99 THEN
		RETURN;
	END_IF

	Belt_MediaCuring[Belt_iIndexTracking] := TRUE;
	
END_ACTION
