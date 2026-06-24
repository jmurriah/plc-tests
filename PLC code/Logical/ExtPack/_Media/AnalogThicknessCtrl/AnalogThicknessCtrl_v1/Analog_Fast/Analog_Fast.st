PROGRAM _CYCLIC

	//Access to the Physical inputs
	AnalogInputs;
	
	///////////////////////
	(*STATES*)
	//////////////////////
	
	// Getting current high	
	gDing.State.rCurrentHigh:= MAX(0, gDing.In.rHighDingMm + gDing.State.rOffsetCalibration);
	
	// Piece Detect
	gDing.State.xDingLowPieceDetect:= (gDing.State.rCurrentHigh >= gDing.Parameters.rMachineMinTicknessMedia) AND gDing.In.xDingLow; 
	
	xMountedMediaDetected := FALSE;
	xMediaToRejectDetected := FALSE;
	
	// Alarm: Mounted Tile gui_q_xAlrParoExesoAlturaSet
	// SYSTEM STOPPED DUE TO INPUT SENSORS EXCESSIVE THICKNESS. TO RESET: REMOVE THE TILE FROM THE MACHINE INPUT [12B4]
	IF gDing.Commands.AutoMode.xBypass THEN
		IF gDing.State.xSensorCovered OR gDing.State.rCurrentHigh > gDing.Parameters.rMountedMediaLevelInBypassMode THEN
			xMountedMediaDetected := TRUE;
		END_IF
		
		IF xMountedMediaDetected AND NOT gDing.Commands.xMountedMediaInside THEN
			gDing.Alarms.xMountedTile:= TRUE;
		END_IF
				
	ELSIF gDing.Commands.AutoMode.xProdORLab THEN
				
		// Required to safe printheads installed
		CASE gDing.Parameters.MountedDetectionType OF
			THICKMOUNT_THICKNESS_RELATIVE:
				rThicknessToMounted := gDing.Parameters.rMediaThickness + gDing.Parameters.rOverThicknessToMounted;  
			THICKMOUNT_ABSOLUTE:
				rThicknessToMounted := gDing.Parameters.rThicknessToMounted;
		END_CASE
		
		IF gDing.State.rCurrentHigh > rThicknessToMounted THEN
			xMountedMediaDetected := TRUE;
		END_IF
		
		// This alarm has to be raised here to avoid resetting it and move out the mounted media
		IF xMountedMediaDetected AND NOT gDing.Commands.xMountedMediaInside THEN
			gDing.Alarms.xMountedTile:= TRUE;
		END_IF
		
		// MediaToReject
		IF gDing.State.rCurrentHigh > gDing.Parameters.rMediaThickness + gDing.Parameters.rOverThicknessToReject THEN
			xMediaToRejectDetected := TRUE;
		END_IF
		
	END_IF
	
	IF xMediaToRejectDetected THEN
		rBarsPosition := gDing.State.rCurrentHigh + gDing.Parameters.rMarginSafeRejectForAnalog;
	ELSE
		IF gDing.Parameters.xDiscreteBehavior THEN
			rBarsPosition := gDing.Parameters.rMediaThickness + gDing.Parameters.rMarginPrint;
			rVirtualDiscretePosition := gDing.Parameters.rMediaThickness + gDing.Parameters.rMarginPrint - gDing.Parameters.Discrete.rOffsetRelToBar;
			FOR iIndexVirtualSensor := 0 TO gDing.Parameters.Discrete.iVirtualSensors -1 DO
				IF gDing.State.rCurrentHigh > rVirtualDiscretePosition + iIndexVirtualSensor * gDing.Parameters.Discrete.rDistanceBetweenSensors - gDing.Parameters.Discrete.rOffsetRelToBar THEN
					rBarsPosition := rVirtualDiscretePosition + ((iIndexVirtualSensor + 1) * gDing.Parameters.Discrete.rDistanceBetweenSensors );
				END_IF
			END_FOR
		ELSE
			rBarsPosition := gDing.State.rCurrentHigh + gDing._Internal.rMarginSafePrintChecked;
		END_IF
	END_IF
	
	gDing.State.rBarsPosition := rBarsPosition;
	
	// Data has to be treated in the slow program to be sure to read the information in all fast programs
	IF xMountedMediaDetected (*AND NOT gDing._Internal.xMountedMediaTreated*) THEN
		gDing.State.xMountedMediaDetected := TRUE;
	ELSIF NOT xMountedMediaDetected AND gDing._Internal.xMountedMediaTreated THEN
		gDing.State.xMountedMediaDetected := FALSE;
	END_IF
	
	// Data has to be treated in the slow program to be sure to read the information in all fast programs
	IF xMediaToRejectDetected (*AND NOT gDing._Internal.xMediaToRejectTreated*) THEN
		gDing.State.xMediaToRejectDetected := TRUE;
	ELSIF NOT xMediaToRejectDetected AND gDing._Internal.xMediaToRejectTreated THEN
		gDing.State.xMediaToRejectDetected := FALSE;
	END_IF
	
END_PROGRAM