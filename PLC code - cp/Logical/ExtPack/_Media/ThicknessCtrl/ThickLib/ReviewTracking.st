
(* Review if any element in the array is inside de window *)
FUNCTION ReviewMediaTrackingInPosition

	// If no elements inside, return
	IF TotalElementsInside = 0 THEN
		ReviewMediaTrackingInPosition := FALSE;
		RETURN;
	END_IF

	xMediaInPosition := FALSE;
	FOR iIndexArray := 0 TO TotalElementsInside - 1 DO
		IF NOT xIsWhite OR ArrayOfMedia[iIndexArray].Media.xHasWhite THEN
			IF ArrayOfMedia[iIndexArray].HeadPosition < iStartWindow THEN
				// Waiting the media
			ELSIF ArrayOfMedia[iIndexArray].HeadPosition >= iStartWindow AND ArrayOfMedia[iIndexArray].HeadPosition <= iEndWindow THEN
				xMediaInPosition := TRUE;
			ELSIF ArrayOfMedia[iIndexArray].HeadPosition > iEndWindow THEN
				xMediaInPosition := ArrayOfMedia[iIndexArray].TailPosition <= iEndWindow;
			END_IF
		END_IF
	END_FOR
	ReviewMediaTrackingInPosition := xMediaInPosition;
	
END_FUNCTION


(* Review if any element in the array is inside de window and calculate the Energy needed *)
FUNCTION RevMediaTrackingEnergyInPos

	// If no elements inside, return
	IF TotalElementsInside = 0 THEN
		RevMediaTrackingEnergyInPos := FALSE;
		RETURN;
	END_IF
	
	// If more lamps than configured, return
	IF iTotalLamps > THICKENERGY_MAX_LAMPS THEN
		RevMediaTrackingEnergyInPos := FALSE;
		RETURN;
	END_IF	
	
	// Reset Energy Values
	FOR iIndexArray := 0 TO iTotalLamps - 1 DO
		Intensity[iIndexArray] := 0;
	END_FOR
	
	FOR iIndexArray := 0 TO TotalElementsInside - 1 DO
		
		diPosStartMedia := ArrayOfMedia[iIndexArray].HeadPosition;
		diPosEndMedia := UDINT_TO_DINT(ArrayOfMedia[iIndexArray].HeadPosition) - REAL_TO_DINT(ArrayOfMedia[iIndexArray].Media.rLength/10);
		
		IF diPosStartMedia >= INT_TO_DINT(iStartWindow) AND diPosEndMedia <= INT_TO_DINT(iEndWindow) THEN
			
			// If no proper pointer, return to avoid a crash
			IF ArrayOfMedia[iIndexArray].pMediaEnery = 0 THEN
				RevMediaTrackingEnergyInPos := FALSE;
				RETURN;
			END_IF
			
			RevMediaTrackingEnergyInPosItem(ADR(ArrayOfMedia[iIndexArray]), ArrayOfMedia[iIndexArray].pMediaEnery ,iStartWindow, iEndWindow, rLampWidth, rLampOffset, rLampOverlap, Intensity);

		END_IF
		
	END_FOR

	// Asign data to received array. iIntensity starsts in 1
	FOR iIndexArray := 1 TO iTotalLamps DO
		iIntensity[iIndexArray] := MAX(Intensity[iTotalLamps - iIndexArray], iMinIntensity);
	END_FOR
	
	RevMediaTrackingEnergyInPos := TRUE;
	
	Intensity; // INTERNAL variable. To monitor
	iIntensity; // IN_OUT variable. To monitor
	
END_FUNCTION


(* Review if any element in the array is inside de window and calculate the Energy needed *)
FUNCTION RevMediaTrackingEnergyInPosItem

	//   The first LAMP is in the operator side, but for easier calculations, in this point the arrays will have the
	// same order as the information in the document. Later, the array will be swapped to send it to Dryer
	
	
	rOffsetStartDocument := MediaData.Media.rCrossOffset;
	
	iFirstLamp := INT_TO_UINT(MAX(0,TRUNC((rOffsetStartDocument - rLampOffset)/rLampWidth)));
	iLastLamp := INT_TO_UINT(LIMIT(0,TRUNC((rOffsetStartDocument + MediaData.Media.rWidth - rLampOffset)/rLampWidth), THICKENERGY_MAX_LAMPS-1));
	
	(* Calculus explanation to get First and Last section to avoid loop a for over the array
	
		iFirstCrossSection is where: PosEndSection_i > PosIniLamp_j
		iLastCrossSection is where: PosIniSection_i < PosEndLamp_j
	*)	

	iFirstProcessSection := LIMIT(0,REAL_TO_INT(TRUNC(UDINT_TO_REAL(MediaData.HeadPosition - iEndWindow))/THICKENERGY_PROCESS_STEP), THICKENERGY_MAX_PROCESS_ITEMS);
	iLastProcessSection := LIMIT(0,REAL_TO_INT(TRUNC(UDINT_TO_REAL(MediaData.HeadPosition - iStartWindow))/THICKENERGY_PROCESS_STEP),THICKENERGY_MAX_PROCESS_ITEMS);

	FOR iIndexLamp := iFirstLamp TO iLastLamp DO
		iLampIntensity := 0;
		
		(* Calculus explanation to get First and Last section to avoid loop a for over the array
		
		PosIniSection_i = rOffsetStartDocument + THICKENERGY_CROSS_STEP * i
		PosEndSection_i = rOffsetStartDocument + THICKENERGY_CROSS_STEP * (i +1)
		PosIniLamp_j = rLampOffset + rLampWidth * j
		PosEndLamp_j = rLampOffset + rLampWidth * (j +1)
		
		*)

		iFirstCrossSection := LIMIT(0, REAL_TO_INT(MAX(0,brmceil(((rLampOffset + rLampWidth * iIndexLamp - rOffsetStartDocument - rLampOverlap)/ THICKENERGY_CROSS_STEP)-1))), THICKENERGY_MAX_CROSS_ITEMS);
		iLastCrossSection := LIMIT(0, REAL_TO_INT(TRUNC(((rLampOffset + rLampWidth * (iIndexLamp + 1) - rOffsetStartDocument + rLampOverlap)/ THICKENERGY_CROSS_STEP))), THICKENERGY_MAX_CROSS_ITEMS);
		
		FOR iIndexCross := iFirstCrossSection TO iLastCrossSection DO

			FOR iIndexProcess := iFirstProcessSection TO iLastProcessSection DO
				iLampIntensity := MAX(iLampIntensity, EnergyData.iPower[iIndexProcess,iIndexCross]);
			END_FOR
			
		END_FOR
		iIntensity[iIndexLamp] := MAX(iIntensity[iIndexLamp], iLampIntensity);
		
	END_FOR
	
	RevMediaTrackingEnergyInPosItem := TRUE;
	
END_FUNCTION