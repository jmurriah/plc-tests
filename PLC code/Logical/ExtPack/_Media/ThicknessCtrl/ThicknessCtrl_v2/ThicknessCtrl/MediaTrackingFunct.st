
ACTION MoveMediaFromNewToInsideL1:

	IF MediaTracking_iTotalInsideL1 = THICK_MEDIATRACKING_MAX_MEDIA THEN
		// TODO: Raise alarm of received media without free space
		RETURN;
	END_IF
	
	// Moving from New to Inside
	IF dataHeigh.status.xNewMediaStackEnabled THEN
		// Managing Media and Energy
		MediaTrackingInsideL1[MediaTracking_iTotalInsideL1] := NewMediaStackL1[0];
	ELSE
		// Manage Energy information
		MediaEnergyRackL1[EnergyRack_iIndexL1] := dataHeigh.parameters.ContinuousMedia.Energy;
		MediaTrackingInsideL1[MediaTracking_iTotalInsideL1].iIndexMediaEnergy := EnergyRack_iIndexL1;
		MediaTrackingInsideL1[MediaTracking_iTotalInsideL1].pMediaEnery := ADR(MediaEnergyRackL1[EnergyRack_iIndexL1]);
		EnergyRack_iIndexL1 := EnergyRack_iIndexL1 + 1;
		IF EnergyRack_iIndexL1 > THICK_MEDIATRACKING_MAX_MEDIA_x2 THEN
			EnergyRack_iIndexL1 := 0;
		END_IF
		// Managing media
		MediaTrackingInsideL1[MediaTracking_iTotalInsideL1].Media := dataHeigh.parameters.ContinuousMedia.MediaData;
	END_IF

	MediaTrackingInsideL1[MediaTracking_iTotalInsideL1].HeadPosition := iIndexEnteringMedia;
	MediaTracking_iTotalInsideL1 := MediaTracking_iTotalInsideL1 + 1;
	AssignEnteringMediaL1;
	
	// Removing from New overwriting the array
	IF dataHeigh.status.xNewMediaStackEnabled THEN
		ShiftArrayBackward(ADR(NewMediaStackL1), SIZEOF(NewMediaStackL1), SIZEOF(NewMediaStackL1[0]), 1, Stack_iTotalNewMediaL1);
		Stack_iTotalNewMediaL1 := UINT_SUB(Stack_iTotalNewMediaL1, 1);
	END_IF
	
	AddMediaTrackingEvents(diTotalCmBelt, HEAD_DETECTED, ADR(TrackingEventsArray));

END_ACTION

ACTION MoveMediaFromNewToInsideL2:

	IF MediaTracking_iTotalInsideL2 = THICK_MEDIATRACKING_MAX_MEDIA THEN
		// TODO: Raise alarm of received media without free space
		RETURN;
	END_IF
	
	// Moving from New to Inside
	IF dataHeigh.status.xNewMediaStackEnabled THEN
		// Managing Media and Energy
		MediaTrackingInsideL2[MediaTracking_iTotalInsideL2] := NewMediaStackL2[0];
	ELSE
		// Manage Energy information
		MediaEnergyRackL2[EnergyRack_iIndexL2] := dataHeigh.parameters.ContinuousMedia.Energy;
		MediaTrackingInsideL2[MediaTracking_iTotalInsideL2].iIndexMediaEnergy := EnergyRack_iIndexL2;
		MediaTrackingInsideL2[MediaTracking_iTotalInsideL2].pMediaEnery := ADR(MediaEnergyRackL2[EnergyRack_iIndexL2]);
		EnergyRack_iIndexL2 := EnergyRack_iIndexL2 + 1;
		IF EnergyRack_iIndexL2 > THICK_MEDIATRACKING_MAX_MEDIA_x2 THEN
			EnergyRack_iIndexL2 := 0;
		END_IF
		// Managing media
		MediaTrackingInsideL2[MediaTracking_iTotalInsideL2].Media := dataHeigh.parameters.ContinuousMedia.MediaData;
	END_IF	

	MediaTrackingInsideL2[MediaTracking_iTotalInsideL2].HeadPosition := iIndexEnteringMedia;
	MediaTracking_iTotalInsideL2 := MediaTracking_iTotalInsideL2 + 1;
	AssignEnteringMediaL2;
	
	// Removing from New overwriting the array
	IF dataHeigh.status.xNewMediaStackEnabled THEN
		ShiftArrayBackward(ADR(NewMediaStackL2), SIZEOF(NewMediaStackL2), SIZEOF(NewMediaStackL2[0]), 1, Stack_iTotalNewMediaL2);
		Stack_iTotalNewMediaL2 := UINT_SUB(Stack_iTotalNewMediaL2, 1);
	END_IF

	AddMediaTrackingEvents(diTotalCmBelt, HEAD_DETECTED, ADR(TrackingEventsArray));
	
END_ACTION

ACTION MoveMediaFromInsideToOutL1:
	
	// Removing from New overwriting the array
	ShiftArrayBackward(ADR(MediaTrackingInsideL1), SIZEOF(MediaTrackingInsideL1), SIZEOF(MediaTrackingInsideL1[0]), 1, MediaTracking_iTotalInsideL1);
	MediaTracking_iTotalInsideL1 := UINT_SUB(MediaTracking_iTotalInsideL1, 1);
	AssignEnteringMediaL1;
	xExitingMediaL1 := TRUE;

END_ACTION

ACTION MoveMediaFromInsideToOutL2:
	
	// Removing from New overwriting the array
	ShiftArrayBackward(ADR(MediaTrackingInsideL2), SIZEOF(MediaTrackingInsideL2), SIZEOF(MediaTrackingInsideL2[0]), 1, MediaTracking_iTotalInsideL2);
	MediaTracking_iTotalInsideL2 := UINT_SUB(MediaTracking_iTotalInsideL2, 1);
	AssignEnteringMediaL2;
	xExitingMediaL2 := TRUE;

END_ACTION

ACTION AssignEnteringMediaL1:
	
	// Need to protect the case when exiting one media and no other media inside. In this case pointing to an empty location, but no errors
	IF MediaTracking_iTotalInsideL1 > 0 THEN
		EnteringMediaL1 ACCESS ADR(MediaTrackingInsideL1[MediaTracking_iTotalInsideL1-1].Media);
	ELSE
		EnteringMediaL1 ACCESS ADR(MediaTrackingInsideL1[0].Media);
	END_IF

END_ACTION

ACTION AssignEnteringMediaL2:
	
	// Need to protect the case when exiting one media and no other media inside. In this case pointing to an empty location, but no errors
	IF MediaTracking_iTotalInsideL2 > 0 THEN
		EnteringMediaL2 ACCESS ADR(MediaTrackingInsideL2[MediaTracking_iTotalInsideL2-1].Media);
	ELSE
		EnteringMediaL2 ACCESS ADR(MediaTrackingInsideL2[0].Media);
	END_IF

END_ACTION

ACTION RunMediaInsidePositions:
	
	RunMediaInsidePositionsL1;
	IF dataHeigh.parameters.xDoubleLine THEN
		RunMediaInsidePositionsL2;
	END_IF
		
END_ACTION

ACTION RunMediaInsidePositionsL1:
	
	IF MediaTracking_iTotalInsideL1 = 0 THEN
		RETURN;
	END_IF
	
	FOR iIndexArray := 0 TO MediaTracking_iTotalInsideL1 -1 DO
		MediaTrackingInsideL1[iIndexArray].HeadPosition := MediaTrackingInsideL1[iIndexArray].HeadPosition + iPositionsToRunArray;
		// If tail position is <>0 is because it has been asigned
		IF MediaTrackingInsideL1[iIndexArray].TailPosition <> 0 THEN
			MediaTrackingInsideL1[iIndexArray].TailPosition := MediaTrackingInsideL1[iIndexArray].TailPosition + iPositionsToRunArray;
		END_IF
	END_FOR
		
END_ACTION

ACTION RunMediaInsidePositionsL2:
	
	IF MediaTracking_iTotalInsideL2 = 0 THEN
		RETURN;
	END_IF
	
	FOR iIndexArray := 0 TO MediaTracking_iTotalInsideL2 -1 DO
		MediaTrackingInsideL2[iIndexArray].HeadPosition := MediaTrackingInsideL2[iIndexArray].HeadPosition + iPositionsToRunArray;
		// If tail position is <>0 is because it has been asigned
		IF MediaTrackingInsideL2[iIndexArray].TailPosition <> 0 THEN
			MediaTrackingInsideL2[iIndexArray].TailPosition := MediaTrackingInsideL2[iIndexArray].TailPosition + iPositionsToRunArray;
		END_IF
	END_FOR
		
END_ACTION