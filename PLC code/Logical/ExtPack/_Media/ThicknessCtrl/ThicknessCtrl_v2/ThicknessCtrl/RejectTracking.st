
ACTION RunRejectArray:

	//Need to run the matrix through all belts
	ShiftArrayForward(ADR(ValidMedia), SIZEOF(ValidMedia), SIZEOF(ValidMedia[0]), iPositionsToRunArray, iMaxTrackingPosition + 5);
	
	// To Clarify if Command for 1 or Order for all till contrary order
	IF EDGEPOS(dataHeigh.Commands.xRushProof) THEN
		xRushProof:=TRUE;
		iRushProofCounter := iRushProofCounter + 1; //To be shown on UI. Useful for users and debugging
		LogRushProof;
		
		MarkBoardAsRejectedToTheFrontEdge;
	END_IF
	
	// When receiving the signal of media detected to Reject, run the matrix and mark all boards as ToReject
	// This will ocurr the next scan cycle of the detection, but it is no a problem in this case
	IF EDGENEG(dataHeigh.parameters.xBlockInProperPrintingPosition) OR dataHeigh.status.Detection.xMediaToRejectDetected THEN
		IF gMachine.St.AutoMode.xProduction THEN
			MarkAllBoardsBelowMachineAsRejected;
		END_IF
		xReturningFromReject := TRUE;
	END_IF
	
	
	//To write the matrix
	IF dataHeigh.parameters.xBlockInProperPrintingPosition AND NOT dataHeigh.Orders.xDiscardAllMedia THEN
		IF NOT xRushProof THEN
			
			IF NOT xReturningFromReject THEN
				// This is the standard behaviour. MOST OF TIMES THROUGH HERE
				iNewValidMedia := MEDIATRACKING_VALID;
				LoadNewValidMediaData;
			ELSE
				//   This is the behaviourr while finishing the Reject state,
				// and searching for a gap in the media entering to considering finished
				IF dataHeigh.parameters.Detection.ProductDetect.xFixedSensor THEN
					iNewValidMedia := MEDIATRACKING_INVALID;
				ELSE
					iNewValidMedia := MEDIATRACKING_UNKNOWN;
				END_IF
				LoadNewValidMediaData;
				DetectGapEnteringTheMachine;
			END_IF
		ELSE
			// Review Rear Edge. Invalid if not Edge. Valid after the edge
			CheckRearEdgeofRejectedBoard;
		END_IF
	ELSE
		IF dataHeigh.parameters.Detection.ProductDetect.xFixedSensor THEN
			iNewValidMedia := MEDIATRACKING_INVALID;
		ELSE
			iNewValidMedia := MEDIATRACKING_UNKNOWN;
		END_IF
		LoadNewValidMediaData;
		
		xRushProof:=FALSE;
	END_IF
	
	
	// Just update if the new data is written in the positions moved previously
	
END_ACTION

ACTION LoadNewValidMediaData:
	FOR iIndexArray := 0 TO iPositionsToRunArray -1 DO
		ValidMedia[iIndexArray + iProductDetectSensorPosition] := iNewValidMedia;
	END_FOR
END_ACTION

ACTION ReviewRejectActivation:

	//[RGP] This part must be located in code executed much faster: less than (MinGap/MaxBeltSpeed)
	//We need TO force gaps TO be written with a PDsignal filter, TO avoid "iPositionsToRunArray" TO mask them
	//we can check previous index (iRejectLengthAdjustment-X). X: Positions in matrix forced to be 0, as a gap
	
	FastReviewReject;

	//Overwritting valid media array to mark boards below bars when block raises to safe position
	//[RGP] 15274: Overwritting matrix position to know which boards are below block's bars when empty belt mode.
	IF EDGEPOS(dataHeigh.Orders.xDiscardAllMedia) THEN 
		FOR iIndex := dataHeigh.parameters.Detection.ProductDetect.iSensorPosition TO dataHeigh.parameters.iTotalBlocksLengh DO
			IF dataHeigh.parameters.Detection.ProductDetect.xFixedSensor THEN
				ValidMedia[iIndex] := MEDIATRACKING_INVALID;
			ELSE
				ValidMedia[iIndex] := MEDIATRACKING_UNKNOWN;
			END_IF
		END_FOR
	END_IF
	
	ton_PhysicalHoldReject(IN:=gMachine.In.Buttons.xReset, PT:=T#2S);
	xHoldReject := ValidMedia[iHoldRejectLengthAdjustment] = MEDIATRACKING_UNKNOWN;
	
	IF EDGEPOS(xHoldReject) THEN
		AddMediaTrackingEvents(diTotalCmBelt + iHoldRejectLengthAdjustment, START_HOLDREJEC, ADR(TrackingEventsArray));
	END_IF
	IF EDGENEG(xHoldReject) THEN
		AddMediaTrackingEvents(diTotalCmBelt + iHoldRejectLengthAdjustment, END_HOLDREJECT, ADR(TrackingEventsArray));
	END_IF
	
	// Out signals
	dataHeigh.Outputs.xHoldReject := ton_PhysicalHoldReject.Q OR xHoldReject;
	
END_ACTION

ACTION MarkBoardAsRejectedToTheFrontEdge:

	// Searching for the gap in xMediaTracking
	FOR iIndex:=iProductDetectSensorPosition TO iMAXTRACKINGARRAY DO
		// Searching for the gap in xMediaTracking to Stop
		IF xMediaTracking[iIndex] = 0  THEN
			EXIT;
		END_IF
		ValidMedia[iIndex] := MEDIATRACKING_INVALID;
	END_FOR
	
END_ACTION

ACTION DetectGapEnteringTheMachine:

	// Searching for the gap in xMediaTracking
	FOR iIndex:=iProductDetectSensorPosition + iPositionsToRunArray TO iProductDetectSensorPosition BY -1 DO
		// Searching for the gap in xMediaTracking to Stop
		IF xMediaTracking[iIndex] = 0  THEN
			xReturningFromReject := FALSE;
			EXIT;
		END_IF
	END_FOR
	
END_ACTION

ACTION CheckRearEdgeofRejectedBoard:

	// Searching for the gap in xMediaTracking
	FOR iIndex:=iProductDetectSensorPosition + iPositionsToRunArray TO iProductDetectSensorPosition BY -1 DO
		
		IF xMediaTracking[iIndex] = 0  AND xRushProof THEN
			// Detected the Rear Edge of the board. Now not in RushProof
			ValidMedia[iIndex] := MEDIATRACKING_INVALID;
			xRushProof:=FALSE;
		ELSIF NOT xRushProof THEN
			ValidMedia[iIndex] := MEDIATRACKING_VALID;
		ELSE
			ValidMedia[iIndex] := MEDIATRACKING_INVALID;
		END_IF
		
	END_FOR
	
END_ACTION


ACTION MarkAllBoardsBelowMachineAsRejected:

	// Marking all positions below machine as Invalid
	xMarkLastBoardBelowBlock := TRUE; //To avoid mark a board half unknown - half invalid, in case of using full stacker is not sent using reject sheet, and the holdreject signal is sent too late
	FOR iIndex := dataHeigh.parameters.Detection.ProductDetect.iSensorPosition + iPositionsToRunArray TO dataHeigh.parameters.iTotalBlocksLengh DO
		IF xMediaTracking[iIndex] = 1 AND xMarkLastBoardBelowBlock THEN
			IF dataHeigh.parameters.Detection.ProductDetect.xFixedSensor THEN
				ValidMedia[iIndex] := MEDIATRACKING_INVALID;
			ELSE
				ValidMedia[iIndex] := MEDIATRACKING_UNKNOWN;
			END_IF
		ELSE
			xMarkLastBoardBelowBlock := FALSE;
			IF ValidMedia[iIndex] <> MEDIATRACKING_UNKNOWN THEN
				ValidMedia[iIndex] := MEDIATRACKING_INVALID;
			END_IF
		END_IF
	END_FOR
	
	//  If there is a board inside the machine, but with the head outside the machine,
	// mark all that board as ToReject. The rear side won't be properly printed
	FOR iIndex:=dataHeigh.parameters.iTotalBlocksLengh TO iMAXTRACKINGARRAY DO
		// Searching for the gap in xMediaTracking to Stop
		IF xMediaTracking[iIndex] = 0 THEN
			EXIT;
		END_IF
		IF ValidMedia[iIndex] <> MEDIATRACKING_UNKNOWN THEN
			ValidMedia[iIndex] := MEDIATRACKING_INVALID;
		END_IF
	END_FOR	
	
END_ACTION
