
ACTION FastReviewReject: 
	
	iIndexPositionToReviewMedia:= iRejectLengthAdjustment - MAX(1, iPositionsToRunArray + 2); //Increasing the quantity of data to avoid not checking any position during accelerations
		
	IF dataHeigh.parameters.Reject.RejectBoardEdge = REJECT_REAR THEN
		
		//Full stacker requires to set reject order (digital output) when boards "tail" is just about to exit printer's belt
		FOR iIndexMediaPresent := iRejectLengthAdjustment TO iIndexPositionToReviewMedia BY -1 DO
			IF xMediaTracking[iIndexMediaPresent+1] > 0 AND xMediaTracking[iIndexMediaPresent] = 0 THEN
				IF ValidMedia[iIndexMediaPresent] = MEDIATRACKING_INVALID THEN 
					xReject:=TRUE;
					//DELOREAN-981: Counting reject orders executed while printing
					dataHeigh.status.Reject.iBoardsRejected := dataHeigh.status.Reject.iBoardsRejected + 1;
					EXIT;
				END_IF
			END_IF
		END_FOR
	
	ELSIF dataHeigh.parameters.Reject.RejectBoardEdge = REJECT_FRONT THEN

		//Bundle stacker requires to set reject order (digital output) when boards "head" is just about to exit printer's belt
		FOR iIndexMediaPresent := iRejectLengthAdjustment TO iIndexPositionToReviewMedia BY -1 DO
			IF xMediaTracking[iIndexMediaPresent] > 0 AND xMediaTracking[iIndexMediaPresent+1] = 0 THEN
				IF ValidMedia[iIndexMediaPresent] = MEDIATRACKING_INVALID THEN 
					xReject:=TRUE;
					//DELOREAN-981: Counting reject orders executed while printing
					dataHeigh.status.Reject.iBoardsRejected := dataHeigh.status.Reject.iBoardsRejected + 1;
					EXIT;
				END_IF
			END_IF
		END_FOR
	
	END_IF
		
	
	//[RGP] We defined during tests with AVT (Zeev and Jordi) that camera gives us the signal whenever we want,
	// so has to be configured with the distance from camera to end of belt. 
	//These lines are useful whether Noam camera's reject signals works the same way
	tp_Reject(IN:=(dataHeigh.Commands.xCameraDefectDetected OR xReject), PT:=T#20MS); //Stacker requires a 20ms pulse to active the reject
	tp_RejectLongTime(IN:=((dataHeigh.Commands.xCameraDefectDetected AND dataHeigh.parameters.xBlockInPrint) OR xReject), PT:=T#1500ms); // This variable is to monitorize it more easily
	xReject:=FALSE; //Reset var after using it in the TP

	dataHeigh.Outputs.xReject := tp_Reject.Q;
	dataHeigh.status.Reject.xRejecting := tp_RejectLongTime.Q;
			
END_ACTION

