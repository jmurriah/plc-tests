PROGRAM _INIT
    
	RTInfo_0(enable :=TRUE );
	rPeriode:= UDINT_TO_REAL (RTInfo_0.cycle_time)/1000;  // Cycle time in microseconds
	gThicknessCtrl.Internal.rCycleFast := rPeriode;
	
END_PROGRAM

PROGRAM _CYCLIC

	IF gDing.State.xDingInstalled THEN
		
		ShiftArrayForward(ADR(gThicknessCtrl.Internal.AnalogHeightValues), SIZEOF(gThicknessCtrl.Internal.AnalogHeightValues), SIZEOF(gThicknessCtrl.Internal.AnalogHeightValues[0]), 1, THICK_MAX_UPDATE_VALUES);
		
		// Ding laser position to heigh detection ctrl
		gThicknessCtrl.Internal.AnalogHeightValues[0] := REAL_TO_UINT(MAX(gDing.State.rBarsPosition,
																		gThicknessCtrl.status.Heigh.rMediaThicknessMargin)*100);
			
		//Load array of data to avoid loosing information -----------------------------------------
		//Move the array one position
		ShiftArrayForward(ADR(gThicknessCtrl.Internal.MediaAnalogValues), SIZEOF(gThicknessCtrl.Internal.MediaAnalogValues), SIZEOF(gThicknessCtrl.Internal.MediaAnalogValues[0]), 1, THICK_MAX_UPDATE_VALUES);
		//Load the first position with new data
		gThicknessCtrl.Internal.MediaAnalogValues[0] := gDing.State.xDingLowPieceDetect;
	
		// If detected in nSensor fast, activate and wait untill slow program to deal with
		IF gDing.State.xMediaToRejectDetected THEN
			gThicknessCtrl.status.Detection.xMediaToRejectDetected := TRUE;
			// Just when the slow program has readed the status.xMediaToReject variable, we can reset the status
		ELSIF gThicknessCtrl.Internal.xMediaToRejectTreated THEN
			gThicknessCtrl.status.Detection.xMediaToRejectDetected := FALSE;
			gThicknessCtrl.Internal.xMediaToRejectTreated := FALSE;
		END_IF
		
	END_IF
	
	IF gPhotoCells.status.xInstalled THEN
		
		ShiftArrayForward(ADR(gThicknessCtrl.Internal.ArrayHeightValues), SIZEOF(gThicknessCtrl.Internal.ArrayHeightValues), SIZEOF(gThicknessCtrl.Internal.ArrayHeightValues[0]), 1, THICK_MAX_UPDATE_VALUES);
		
		// Photo Cells laser position to heigh detection ctrl
		IF gThicknessCtrl.parameters.xMarginForBendTile THEN
			gThicknessCtrl.Internal.ArrayHeightValues[0] := REAL_TO_UINT(MAX(gPhotoCells.status.rBarsPosition + gThicknessCtrl.Internal.rMarginSafePrintChecked,
														gThicknessCtrl.status.Heigh.rMediaThicknessMargin)*100);
			
		ELSE
			gThicknessCtrl.Internal.ArrayHeightValues[0] := REAL_TO_UINT(MAX(gPhotoCells.status.rBarsPosition,
														gThicknessCtrl.status.Heigh.rMediaThicknessMargin)*100);
		END_IF
		
		//Load array of data to avoid loosing information -----------------------------------------
		//Move the array one position
		ShiftArrayForward(ADR(gThicknessCtrl.Internal.MediaArraySensorValues), SIZEOF(gThicknessCtrl.Internal.MediaArraySensorValues), SIZEOF(gThicknessCtrl.Internal.MediaArraySensorValues[0]), 1, THICK_MAX_UPDATE_VALUES);
		//Load the first position with new data
		IF gPhotoCells.status.xTrustPhotocellASignal THEN
			gThicknessCtrl.Internal.MediaArraySensorValues[0] := gPhotoCells.status.xLowPieceDetect;

		ELSE
			gThicknessCtrl.Internal.MediaArraySensorValues[0] := FALSE;
		END_IF
		
		// If detected in nSensor fast, activate and wait untill slow program to deal with
		IF gPhotoCells.status.xMediaToRejectDetected  THEN
			gThicknessCtrl.status.Detection.xMediaToRejectDetected := TRUE;
			// Just when the slow program has readed the status.xMediaToReject variable, we can reset the status
		ELSIF gThicknessCtrl.Internal.xMediaToRejectTreated THEN
			gThicknessCtrl.status.Detection.xMediaToRejectDetected := FALSE;
			gThicknessCtrl.Internal.xMediaToRejectTreated := FALSE;
		END_IF
		
	END_IF
	
	IF gBasicDetectMedia.Status.xInstalled THEN
		// Consider Detection media as an AnalogMedia
		ShiftArrayForward(ADR(gThicknessCtrl.Internal.AnalogHeightValues), SIZEOF(gThicknessCtrl.Internal.AnalogHeightValues), SIZEOF(gThicknessCtrl.Internal.AnalogHeightValues[0]), 1, THICK_MAX_UPDATE_VALUES);
		gThicknessCtrl.Internal.AnalogHeightValues[0] := REAL_TO_UINT(gBasicDetectMedia.Status.rMediaHeigh * 100);
		
		ShiftArrayForward(ADR(gThicknessCtrl.Internal.MediaDetectionValues), SIZEOF(gThicknessCtrl.Internal.MediaDetectionValues), SIZEOF(gThicknessCtrl.Internal.MediaDetectionValues[0]), 1, THICK_MAX_UPDATE_VALUES);
		//Load the first position with new data
		gThicknessCtrl.Internal.MediaDetectionValues[0] := gBasicDetectMedia.Status.xMediaPresent;		
		// TOREVIEW. Need an array per line
		//gThicknessCtrl.Internal.MediaDetectionValuesL1[0] := gBasicDetectMedia.Inputs.xMediaPresentL1;
		//gThicknessCtrl.Internal.MediaDetectionValuesL2[0] := gBasicDetectMedia.Inputs.xMediaPresentL2;
		gThicknessCtrl.Internal.MediaDetectionValuesL1 := gThicknessCtrl.Internal.MediaDetectionValues;
	
	END_IF
	
	IF NOT gDing.State.xDingInstalled AND NOT gPhotoCells.status.xInstalled AND NOT gBasicDetectMedia.Status.xInstalled THEN
		//TODO: Here an error should be raised and avoid enter in AutoMode
		gThicknessCtrl.status.Heigh.rMediaHeigh := 0;
	END_IF
	
	//Load array of data to avoid loosing information -----------------------------------------
	//Move the array one position
	ShiftArrayForward(ADR(xProductDetectValuesL1), SIZEOF(xProductDetectValuesL1), SIZEOF(xProductDetectValuesL1[0]), 1, THICK_MAX_UPDATE_VALUES);
	ShiftArrayForward(ADR(xProductDetectValuesL2), SIZEOF(xProductDetectValuesL2), SIZEOF(xProductDetectValuesL2[0]), 1, THICK_MAX_UPDATE_VALUES);
	
	// Protection against not assigned pointers
	IF gThicknessCtrl.parameters.Detection.ProductDetect.pMediaInProductDetectL1 = 0 OR 
		gThicknessCtrl.parameters.Detection.ProductDetect.pMediaInProductDetectL2 = 0 THEN
		RETURN;
	END_IF

	//Load the first position with new data
	xMediaInProductDetectL1 ACCESS gThicknessCtrl.parameters.Detection.ProductDetect.pMediaInProductDetectL1;
	xMediaInProductDetectL2 ACCESS gThicknessCtrl.parameters.Detection.ProductDetect.pMediaInProductDetectL2;
	
	iReasonForMediaInProductDetect.0 := xMediaInProductDetectL1;
	iReasonForMediaInProductDetect.1 := xMediaInProductDetectL2;
	gThicknessCtrl.status.Detection.xMediaInProductDetect := iReasonForMediaInProductDetect > 0;

	xProductDetectValuesL1[0] := xMediaInProductDetectL1;
	xProductDetectValuesL2[0] := xMediaInProductDetectL2;
	
	gThicknessCtrl.Internal.ProductDetectValuesL1 := xProductDetectValuesL1;
	gThicknessCtrl.Internal.ProductDetectValuesL2 := xProductDetectValuesL2;
	
	
	//////////////////
	xMountedMedia := gPhotoCells.Alarms.xMountedTile OR gDing.Alarms.xMountedTile;
	IF EDGEPOS(xMountedMedia) THEN
		gThicknessCtrl.status.Belt.rBeltPositionMmInit := gAxis[gBelt.parameters.IndexAxis].Status.ActPosition;
		gThicknessCtrl.status.Belt.rBeltSpeed := gAxis[gBelt.parameters.IndexAxis].Status.ActVelocity;
	END_IF
	
	IF xMountedMedia AND EDGENEG(gAxis[gBelt.parameters.IndexAxis].Status.PLCopenState.ContinuousMotion) THEN
		gThicknessCtrl.status.Belt.rBeltPositionMmFinal := gAxis[gBelt.parameters.IndexAxis].Status.ActPosition;
	END_IF
	
	
	
END_PROGRAM
