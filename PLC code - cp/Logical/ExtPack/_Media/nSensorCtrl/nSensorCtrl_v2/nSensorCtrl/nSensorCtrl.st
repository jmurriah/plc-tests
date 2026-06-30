PROGRAM _INIT
	FOR iIndexHistory:=0  TO iHistoryLines DO 
		StateHistory[iIndexHistory]:=STP_NOT_USED;
	END_FOR;
END_PROGRAM
	
PROGRAM _CYCLIC

	//////////////////////////////
	////// ASIGN LOCAL VARS //////
	//////////////////////////////
	
	//Main data assignation
	data 	ACCESS ADR (gPhotoCells); 
	// Assign Stepper Motor reference
	Stepper 	ACCESS ADR (gAxis[data.parameters.IndexDriveMaster]);
	StepperGear ACCESS ADR (gAxis[data.parameters.IndexDriveSecondary]);
	Icla 		ACCESS ADR (gIcla[data.parameters.IndexIcla]);

	// Assigning status.xInstalled considering dynamic enable
	IF data.parameters.xInstall THEN
		IF data.parameters.xAllowDynamicEnable THEN
			data.status.xInstalled:= data.parameters.xEnable;
		ELSE
			data.status.xInstalled:= TRUE;
		END_IF
	ELSE
		data.status.xInstalled:= FALSE;
	END_IF
	
	//To reset status when motor type is modified. Not likely to occur in field. Discovered while simulating several platforms in a row.
	xMotorChanged := PreviousMotorType <> data.parameters.MotorType; 
	PreviousMotorType := data.parameters.MotorType;
	
	IF NOT data.status.xInstalled OR xMotorChanged THEN
		
		// Reset alarms 3L
		data.Alarms:=stnSensorsAlarmsReseted ;
		data.AlSummary := stnSensorsAlarmSummaryReseted;
		data.AlSummary.xAlarmSound:=FALSE;

		data.status.xReferenced:=FALSE;
		data.status.xSensorValidAlignPos := FALSE;
		data.status.xLowPieceDetect := FALSE;
		
		RETURN;
	END_IF


	data.parameters.iSensorQuantity := LIMIT(2, data.parameters.iSensorQuantity, MAX_LAST_NSENSOR);
	data.parameters.iSensorToReference := LIMIT(1, data.parameters.iSensorToReference, MAX_LAST_NSENSOR);

		
	/////////////////////////
	// MOTOR PARAMETERS /////
	/////////////////////////
	
	DataToMotors;

	// 3 Photocells position to machine ctrl
	// Photocells are not moving when when photocells is detecting tile, In auto it goes to referenced position
	IF data.commands.AutoMode.xBypass AND gPhotoCells.parameters.xEnableMountedAlrByPass THEN
		rSensorPositionDesired:= data.parameters.rSensorMechPositionByPass;
	ELSE
		IF data.status.xSensorsPositionedRelativeToBar THEN
			rSensorPositionDesired:= data.status.rOffsetToApplyToBarsPosition;
		ELSE
			rSensorPositionDesired:= data.parameters.rMediaThickness + data.parSw.rMechOffset + data.parameters.rOffsetPosition;
		END_IF
		
	END_IF
		
	DataFromMotors;	
	
	
	
	xAllSensorInactive := TRUE;
	xAllSensorActive := TRUE;
	FOR iIndexSensor:=1 TO data.parameters.iSensorQuantity DO
		IF data.Inputs.Signals.xPhotoCells[iIndexSensor] THEN
			xAllSensorInactive:= FALSE;
		ELSE
			xAllSensorActive:= FALSE;
		END_IF
		
		IF data.parameters.Sensors[iIndexSensor].xEnabled THEN
			IF iIndexSensor<>1 AND iIndexSensor<>data.parameters.iSensorQuantity THEN
				IF data.status.xSensorsPositionedRelativeToBar THEN
					data.parameters.Sensors[iIndexSensor].xMoveBarsUp := iIndexSensor>=data.status.iSensorToApplyOffset;
				ELSE
					data.parameters.Sensors[iIndexSensor].xMoveBarsUp := TRUE;
				END_IF
			END_IF			
		ELSE
			data.parameters.Sensors[iIndexSensor].xMoveBarsUp := FALSE;
			data.parameters.Sensors[iIndexSensor].xMountedMedia := FALSE;
		END_IF
		
		//Always, for all machine models, the only photocell enabled to active mounted media alarm is the last one (highest positioned)
		IF iIndexSensor=data.parameters.iSensorQuantity THEN
			data.parameters.Sensors[iIndexSensor].xMountedMedia := TRUE;
		END_IF
		
		//Writting distance to belt surface for each sensor
		data.parameters.Sensors[iIndexSensor].rDistanceToBase := data.parameters.Sensors[iIndexSensor].rDistanceRelativeToFirstSensor + data.status.rPositionMotor;
		
		//NOZOMITWO-2066: Checking that all sensors positioned above one selected to reject media, are defined to reject media too.
		IF iIndexSensor<data.parameters.iSensorQuantity THEN
			IF data.parSw.Sensors[iIndexSensor].xToRejectMedia THEN
				data.parSw.Sensors[iIndexSensor+1].xToRejectMedia := TRUE;
			END_IF
		END_IF
				
			
	END_FOR

	
	//Defining sensors behaviour
	IF data.parameters.xSensorsPosHybridBehaviour THEN
		xSensorsPositionedRelativeToBar := FALSE;
		data.status.xSensorsPositionedRelativeToBar := FALSE;

		FOR iIndexSensorToPositionBelowBars:=2 TO (data.parameters.iSensorQuantity-1) DO
			rOffsetPositionCalc := data.parameters.rMediaThickness + data.parameters.rMarginPrint - data.parameters.Sensors[iIndexSensorToPositionBelowBars].rDistanceRelativeToFirstSensor - data.parameters.rOffsetRelToBar;
			IF (rOffsetPositionCalc<=data.parameters.rMediaThickness-0.5) THEN
				IF (rOffsetPositionCalc>=0.5) THEN
					//Save index of the sensor positioned below bars
					data.status.iSensorToApplyOffset:=iIndexSensorToPositionBelowBars;
					
					//To set first photocell position
					rOffsetPosition:=rOffsetPositionCalc;
					
					//Photocell A must be positioned above the belt
					xSensorsPositionedRelativeToBar := TRUE;
					EXIT;
				END_IF
			END_IF
		END_FOR
		data.status.xSensorsPositionedRelativeToBar := xSensorsPositionedRelativeToBar;
	ELSE
		data.status.xSensorsPositionedRelativeToBar := FALSE;
	END_IF
	
	data.status.rOffsetToApplyToBarsPosition := rOffsetPosition;
	

	data.status.xAllPhotoInactive:= xAllSensorInactive;
	data.status.xTrustPhotocellASignal := data.status.rPositionMotor>0.5; //Sensor light beam diameter is 1mm
	
	
	///////////////////////////////////////////////
	////// nSensorCtrl MachineState  //////////////
	///////////////////////////////////////////////
	MachineState;
	
	
	/////////////////////////
	////// ALARMS ///////////
	/////////////////////////
	AlarmsSummary;

	
	///////////////////////
	//Alarm Sound
	AlarmSounds;
	
	
	///////////////////////////
	// Mounted media management. ThicknessCtrl MUST be executed in the slow cycle before this program
	IF data.status.xMountedMediaDetected AND NOT data._Internal.xMountedMediaTreated THEN
		data._Internal.xMountedMediaTreated := TRUE;
	END_IF
	IF NOT data.status.xMountedMediaDetected THEN
		data._Internal.xMountedMediaTreated := FALSE;
	END_IF
	
	///////////////////////////
	// Media To Reject management. ThicknessCtrl MUST be executed in the slow cycle before this program
	IF data.status.xMediaToRejectDetected AND NOT data._Internal.xMediaToRejectTreated THEN
		data._Internal.xMediaToRejectTreated := TRUE;
	END_IF
	IF NOT data.status.xMediaToRejectDetected THEN
		data._Internal.xMediaToRejectTreated := FALSE;
	END_IF
	
	data.status.rOffsetToReject := data.parameters.Sensors[iWarpMediaSensor].rDistanceRelativeToFirstSensor;
	data.status.rOffsetToMounted := data.parameters.Sensors[data.parameters.iSensorQuantity].rDistanceRelativeToFirstSensor;
	
	xPhotoInputsPrev := data.Inputs.Signals.xPhotoCells;
	
	//Resetting commands coming from sw
	data.commandsSw := ResetCommandsSw;
	
END_PROGRAM
