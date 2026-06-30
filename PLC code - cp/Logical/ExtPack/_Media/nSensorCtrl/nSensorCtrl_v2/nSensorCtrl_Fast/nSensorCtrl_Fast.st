PROGRAM _CYCLIC

	//Main data assignation
	data 	ACCESS ADR (gPhotoCells);
	
	//Not execute the code if the nSensor system is not installed
	IF NOT data.status.xInstalled THEN	RETURN;	END_IF
	
	//If in not Simulation check the pointers and assign data
	IF gMachine.St.HwData.Family <> FAMILY_BRAUTOMATIONRUNTIME THEN
		
		// Check value for all sensors considered
		FOR iIndexCheckSensor := 1 TO data.parameters.iSensorQuantity DO
			IF (data.Inputs.Signals.pInput[iIndexCheckSensor] <> 0) THEN
				pointerValue ACCESS (data.Inputs.Signals.pInput[iIndexCheckSensor]);
				data.Inputs.Signals.xPhotoCells[iIndexCheckSensor] := NOT pointerValue;
			ELSE
				RETURN;
			END_IF
		END_FOR

	END_IF
	
	
	xRecordMaxPosition := data.commands.xRecordMaxPosition;
	IF xRecordMaxPosition THEN
		rMaxPosition := MAX(data.parameters.rMediaThickness, data.status.rPositionWithOffset);
		rBarPosition := rMaxPosition;
	END_IF
	
	IF data.status.xSensorsPositionedRelativeToBar THEN
		iFirstSensorToCheck:=data.status.iSensorToApplyOffset;
	ELSE
		iFirstSensorToCheck:=data.parameters.iSensorToReference;
	END_IF
	
	xMountedMediaDetected := FALSE;
	xMediaToRejectDetected := FALSE;
	
	// Checking Mounted data if machine is in conditions to Check
	IF data.commands.xCheckMounted THEN
		//Just above the Sensor for reference. Sensors below not used. Just to know if media inside (parameters.iSensorToReference)
		//Running photocells from the one assemblied closest to printer's entry and highest located. In case mountedTile alarm, will be active at first iterations
		FOR iIndexSensor:=iFirstSensorToCheck TO data.parameters.iSensorQuantity DO
			IF data.Inputs.Signals.xPhotoCells[iIndexSensor] THEN
				//Define the position of the bars
				IF iIndexSensor<>data.parameters.iSensorQuantity THEN 
					IF data.status.xSensorsPositionedRelativeToBar THEN
						rBarPosition := data.status.rOffsetToApplyToBarsPosition + data.parameters.rOffsetRelToBar + data.parameters.Sensors[iIndexSensor+1].rDistanceRelativeToFirstSensor + data.parameters.Sensors[iIndexSensor+1].rSafetyOffset;
					ELSE
						rBarPosition := data.parameters.rMediaThickness + data.parameters.Sensors[iIndexSensor+1].rDistanceRelativeToFirstSensor + data.parameters.rOffsetPosition + data.parameters.Sensors[iIndexSensor+1].rSafetyOffset;
					END_IF
				END_IF
				
				// Define the States to raise Mounted Alarms
				iStatusCheckMounted.0 := data.status.iSystemState = STP_AUTO;
				iStatusCheckMounted.1 := data.status.iSystemState = STP_RUNING;
				
				IF iStatusCheckMounted > 0 THEN
					//Raise the Mounted alarm if sensor active and it is configured to raise mounted.
					IF data.parameters.xRaiseMountedJustBelowPrePrint THEN
						// This is the case for Cube_Alpha, where was important add more safety to do not raise the alarm in the wrong position and with nonsense
						IF data.parameters.Sensors[iIndexSensor].xMountedMedia AND data.status.rPositionMotor < data.parameters.rPrePrintPosition + 0.5 THEN
							// This alarm has to be raised here to avoid resetting it and move out the mounted media
							IF NOT data.commands.xMountedMediaInside THEN
								data.Alarms.xMountedTile:= TRUE;
							END_IF
							xMountedMediaDetected := TRUE;
							EXIT;
						END_IF
					ELSE
						// Previous behavior not tacking into account Cube machines
						IF data.parameters.Sensors[iIndexSensor].xMountedMedia THEN
							// This alarm has to be raised here to avoid resetting it and move out the mounted media
							IF NOT data.commands.xMountedMediaInside THEN
								data.Alarms.xMountedTile:= TRUE;
							END_IF
							xMountedMediaDetected := TRUE;
							EXIT;
						END_IF
					END_IF
				END_IF
			
				//Marking media to be rejected when any laser configured to do that. Due to low quality printing when bars moving up upper of sensor's height
				IF data.parSw.Sensors[iIndexSensor].xToRejectMedia THEN
					xMediaToRejectDetected := TRUE;
				END_IF
				
			END_IF

		END_FOR
	
	ELSE
		//data.status.xMediaToRejectDetected := FALSE;		
	END_IF
	
	// Data has to be treated in the slow program to be sure to read the information in all fast programs
	IF xMountedMediaDetected (*AND NOT data._Internal.xMountedMediaTreated*) THEN
		data.status.xMountedMediaDetected := TRUE;
	ELSIF NOT xMountedMediaDetected AND data._Internal.xMountedMediaTreated THEN
		data.status.xMountedMediaDetected := FALSE;
	END_IF
	
	// Data has to be treated in the slow program to be sure to read the information in all fast programs
	IF xMediaToRejectDetected (*AND NOT data._Internal.xMediaToRejectTreated*) THEN
		data.status.xMediaToRejectDetected := TRUE;
	ELSIF NOT xMediaToRejectDetected AND data._Internal.xMediaToRejectTreated THEN
		data.status.xMediaToRejectDetected := FALSE;
	END_IF
	
	
	data.status.rBarsPosition := rBarPosition;
	data.status.xLowPieceDetect := data.Inputs.Signals.xPhotoCells[1];

	// If the bars are in high position, do not register photocelles activation/deactivation
	IF data.status.rPositionMotor > (data.parameters.rPrePrintPosition + 0.5) THEN
		RETURN;
	END_IF
	
	IF EDGEPOS(data.Inputs.Signals.xPhotoCells[2]) THEN LogRaiseSensor2; END_IF
	IF EDGEPOS(data.Inputs.Signals.xPhotoCells[3]) THEN LogRaiseSensor3; END_IF
	IF EDGEPOS(data.Inputs.Signals.xPhotoCells[4]) THEN LogRaiseSensor4; END_IF
	IF EDGEPOS(data.Inputs.Signals.xPhotoCells[5]) THEN LogRaiseSensor5; END_IF
	IF EDGEPOS(data.Inputs.Signals.xPhotoCells[6]) THEN LogRaiseSensor6; END_IF

	IF EDGENEG(data.Inputs.Signals.xPhotoCells[2]) THEN LogLowerSensor2; END_IF
	IF EDGENEG(data.Inputs.Signals.xPhotoCells[3]) THEN LogLowerSensor3; END_IF
	IF EDGENEG(data.Inputs.Signals.xPhotoCells[4]) THEN LogLowerSensor4; END_IF
	IF EDGENEG(data.Inputs.Signals.xPhotoCells[5]) THEN LogLowerSensor5; END_IF
	IF EDGENEG(data.Inputs.Signals.xPhotoCells[6]) THEN LogLowerSensor6; END_IF
	
END_PROGRAM
