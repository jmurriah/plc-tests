
ACTION SubstracDistances: 

	(*Less 10 mm to calculate empty belt distance*)
	iDistanceWorkEmptyBelt := UINT_SUB( iDistanceWorkEmptyBelt, iPositionsToRunArray);
			
	(*Less 10mm to calculate mounted tile out of machine*)	
	iDistanceMountPieceOut := UINT_SUB(iDistanceMountPieceOut,iPositionsToRunArray);
			
	(*Less 10mm to calculate mounted tile out of machine*)	
	iDistanceMediaInside := UINT_SUB(iDistanceMediaInside,iPositionsToRunArray);
	iDistanceVirtualMediaInside := UINT_SUB(iDistanceVirtualMediaInside,iPositionsToRunArray);
	iDistanceMediaToRejectInside := UINT_SUB(iDistanceMediaToRejectInside,iPositionsToRunArray);
	iDistanceTrackingEmpty := UINT_SUB(iDistanceTrackingEmpty, iPositionsToRunArray);
	
	iDistanceBeltTurn := UINT_SUB(iDistanceBeltTurn,iPositionsToRunArray);
	
	diTotalCmBelt := diTotalCmBelt + iPositionsToRunArray;
	
END_ACTION

ACTION LoadDistancesBeltRunning:

	// Load Empty belt distance & Media Inside distance
	IF dataHeigh.Inputs.xVirtualMedia THEN
		iDistanceWorkEmptyBelt := dataHeigh.parameters.Belt.iDistanceEmptyBeltIni;
		// Not considering virtual media with Stack enabled
		iDistanceVirtualMediaInside := dataHeigh.parameters.Belt.iDistanceEmptyBeltIni + REAL_TO_UINT(dataHeigh.parameters.ContinuousMedia.MediaData.rLength);
	END_IF
	IF dataHeigh.status.Detection.xFilteredProductDetectMediaL1 OR  dataHeigh.status.Detection.xFilteredProductDetectMediaL2 THEN
		iPositionAdjusted := iProductDetectSensorPosition + dataHeigh.parameters.Detection.ProductDetect.iMediaFilter;
		iDistanceWorkEmptyBelt := MAX(dataHeigh.parameters.Belt.iDistanceEmptyBeltIni - iPositionAdjusted, iDistanceWorkEmptyBelt);
		iDistanceMediaInside := MAX(dataHeigh.parameters.iTotalBlocksLengh - iPositionAdjusted, iDistanceMediaInside);
		iDistanceTrackingEmpty := MAX(iMaxTrackingPosition - iPositionAdjusted, iDistanceTrackingEmpty);
	END_IF
	IF dataHeigh.status.Detection.xFilteredAnalogSensorMedia THEN
		iPositionAdjusted := dataHeigh.parameters.Detection.Analog.iSensorPosition + dataHeigh.parameters.Detection.Analog.iMediaFilter;
		iDistanceWorkEmptyBelt := MAX(dataHeigh.parameters.Belt.iDistanceEmptyBeltIni - iPositionAdjusted, iDistanceWorkEmptyBelt);
		iDistanceMediaInside := MAX(dataHeigh.parameters.iTotalBlocksLengh - iPositionAdjusted, iDistanceMediaInside);
		iDistanceTrackingEmpty := MAX(iMaxTrackingPosition - iPositionAdjusted, iDistanceTrackingEmpty);
	END_IF
	IF dataHeigh.status.Detection.xFilteredArraySensorMedia THEN
		iPositionAdjusted := dataHeigh.parameters.Detection.Array.iSensorPosition + dataHeigh.parameters.Detection.Array.iMediaFilter;
		iDistanceWorkEmptyBelt := MAX(dataHeigh.parameters.Belt.iDistanceEmptyBeltIni - iPositionAdjusted, iDistanceWorkEmptyBelt);
		iDistanceMediaInside := MAX(dataHeigh.parameters.iTotalBlocksLengh - iPositionAdjusted, iDistanceMediaInside);
		iDistanceTrackingEmpty := MAX(iMaxTrackingPosition - iPositionAdjusted, iDistanceTrackingEmpty);
	END_IF
	IF dataHeigh.status.Detection.xFilteredBasicDetectionMedia THEN
		iPositionAdjusted := dataHeigh.parameters.Detection.Basic.iSensorPosition + dataHeigh.parameters.Detection.Basic.iMediaFilter;
		iDistanceWorkEmptyBelt := MAX(dataHeigh.parameters.Belt.iDistanceEmptyBeltIni - iPositionAdjusted, iDistanceWorkEmptyBelt);
		iDistanceMediaInside := MAX(dataHeigh.parameters.iTotalBlocksLengh - iPositionAdjusted, iDistanceMediaInside);
		iDistanceTrackingEmpty := MAX(iMaxTrackingPosition - iPositionAdjusted, iDistanceTrackingEmpty);
	END_IF
	
	IF dataHeigh.status.Detection.xMediaToRejectDetected THEN
		dataHeigh.Internal.xMediaToRejectTreated := TRUE;
		iDistanceMediaToRejectInside := dataHeigh.parameters.iTotalBlocksLengh;
	END_IF
	
	//DELOREAN-668
	IF iDistanceBeltTurn = 0 THEN
		dataHeigh.status.Belt.iBeltTurns := dataHeigh.status.Belt.iBeltTurns + 1;
		iDistanceBeltTurn := dataHeigh.parameters.Belt.iBeltPerimeterLength;
	END_IF
	
END_ACTION

ACTION LoadDistancesAlways:

	//Mounted media evaluation
	IF xMountedMedia THEN 	
		iDistanceMountPieceOut:= iTotalBlocksLengh;  // Updated iDistanceMountPieceOut to 500;	
	END_IF
	
END_ACTION

ACTION BoardsBelowBlockManagement: 

	dataHeigh.status.MediaPosition.iBoardsBelowBlock := 0; //iBoardsBelowBlockL1 + iBoardsBelowBlockL2;  //Just 0 because Sw is not managing properly
	dataHeigh.status.MediaPosition.L1.iBoardsBelowBlock := iBoardsBelowBlockL1;
	dataHeigh.status.MediaPosition.L2.iBoardsBelowBlock := iBoardsBelowBlockL2;
	
END_ACTION