
TYPE
	nSensors_typ : 	STRUCT 
		ordersSw : nSensorsOrdersSw; (*Orders from sw*)
		commandsSw : nSensorsCommandsSw; (*Commands gui*)
		commands : nSensorsCommands; (*Commands gui*)
		parameters : nSensorsParameters; (*Parameters gui*)
		parSw : nSensorsParametersSw;
		status : nSensorsStatus; (*States potocell system*)
		Alarms : nSensorsAlarms; (*Alarms*)
		AlSummary : stEFI_AlarmSummary; (*Alarms Summary*)
		Inputs : nSensorsInputs;
		_Internal : nSensorsInternal;
	END_STRUCT;
	nSensorsOrdersSw : 	STRUCT 
		xMoveUp : BOOL;
		xMoveDown : BOOL;
	END_STRUCT;
	nSensorsCommandsSw : 	STRUCT 
		xReference : BOOL;
	END_STRUCT;
	nSensorsCommands : 	STRUCT 
		xOrderQuickStop : BOOL;
		xOrderCap : BOOL;
		xErrorRst : BOOL;
		xMute : BOOL;
		xRecordMaxPosition : BOOL; (*To save bars position only when this command is active*)
		xCheckMounted : BOOL;
		xCancelAlignmentCheck : BOOL;
		AutoMode : stEFI_MachineAutoModes;
		Mode : StGeneral_States_Mode;
		xResetMotor : BOOL;
		LineStatusSummary : LineControlStatusSummarized;
		xMountedMediaInside : BOOL; (*Mounted Media inside*)
		xStartCount : BOOL;
	END_STRUCT;
	nSensorsSensorParSw : 	STRUCT 
		xToRejectMedia : BOOL; (*The sensor marks media to be rejected due to low printing quality once bars will move up due to its detection*)
	END_STRUCT;
	nSensorsSensorParameters : 	STRUCT 
		rSafetyOffset : REAL;
		rDistanceRelativeToFirstSensor : REAL; (*Distance between Sensor and first sensor in mm*)
		rDistanceToBase : REAL; (*Distance to belt surface*)
		xMountedMedia : BOOL; (*The sensor actives mounted media alarm*)
		xEnabled : BOOL; (*The sensor changes print bar position to next photocell's position*)
		xMoveBarsUp : BOOL; (*The sensor changes print bar position to next photocell's position*)
	END_STRUCT;
	nSensorsParametersSw : 	STRUCT 
		rMechOffset : REAL := 0.0; (*Offset in mm*)
		rThicknessReference : REAL := 10; (*Thickness of the media while referencing in mm*)
		Sensors : ARRAY[0..MAX_LAST_NSENSOR]OF nSensorsSensorParSw; (*Sensors 0 and 1 invalid. Using from 2 to limit*)
	END_STRUCT;
	nSensorsParameters : 	STRUCT 
		xInstall : BOOL;
		xEnable : BOOL; (*Configured depending on the machine. Is installed or it can be installed*)
		xAllowDynamicEnable : BOOL; (*The machine allows dynamic enabling or disabling the funcionality*)
		MotorType : nSensorsMotorsType;
		DriveUnit : MC_DriveUnitManager;
		Sensors : ARRAY[0..MAX_LAST_NSENSOR]OF nSensorsSensorParameters; (*Sensors 0 and 1 invalid. Using from 2 to limit*)
		AlignmentProcess : nSensorsAlignmentProcess;
		IndexDriveMaster : USINT; (*Index of the primary (master) motor in gAxis array*)
		IndexDriveSecondary : USINT; (*Index of the secondary (gear) motor in gAxis array*)
		iSensorQuantity : USINT; (*Quantity of the sensors used*)
		IndexIcla : USINT; (*Index of the Icla in Icla array*)
		iSensorToReference : USINT; (*Sensor to define the position at homing*)
		rSensorMechToleranceAlignment : REAL := 5; (*Teorical alignment position tolerance as mechanical specification*)
		rSensorTeoMechPositionAlignment : REAL; (*Teorical alignment position as mechanical specification*)
		rSensorMechPositionAlignmentMin : REAL; (*Minimum alignment position allowed*)
		rSensorMechPositionAlignmentMax : REAL; (*Maximum alignment position allowed*)
		rSensorMechPositionMin : REAL := -3; (*Mechanical max position allowed is -15mm. Value get from Andres Mantilla after reviewing nSensor mechanical assembly*)
		rSensorMechPositionMax : REAL := 75; (*Mechanical max position allowed*)
		rSensorPositionSearchAlignment : REAL := 50; (*Position to avoid false gauge detections*)
		rOffsetRelToBar : REAL := 0.0; (*Media Offset position in mm. Distance to position third or fourth laser below the print bar. Testing purposes DELOREAN-2572*)
		rOffsetPosition : REAL := 0.0; (*Media Offset position in mm. The offset in position to placed the sensors*)
		rMarginPrint : REAL; (*Value in mm*)
		rMediaThickness : REAL := 5; (*Media Thickness in mm*)
		Acceleration : REAL := 500; (*Acc SP mm/ s2*)
		JogSpeed : REAL := 10; (*Jog Speed SP mm/s*)
		Speed : REAL := 100; (*Speed SP mm/s*)
		rDistanceBetweenSensors : REAL; (*Distance between Sensors in mm*)
		rSensorMechPositionByPass : REAL := 50; (*Static position for ByPass mode*)
		xEnableMountedAlrByPass : BOOL; (*Enable Mounted Part In By Pass Mode*)
		xSensorsPosHybridBehaviour : BOOL;
		xRaiseMountedJustBelowPrePrint : BOOL; (*The RaiseMounted alarm is just raised if Motor Below PrePrintPosition*)
		rPrePrintPosition : REAL; (*PrePrintPosition of the first block*)
		xHomingEnabled : BOOL; (*Transvacuums are activated. Used to start homing movements*)
	END_STRUCT;
	nSensorsStatus : 	STRUCT 
		iErrorId : UINT;
		xMotorError : BOOL;
		xInstalled : BOOL;
		xReferencing : BOOL;
		xReferenced : BOOL;
		xFrontModuleOk : BOOL;
		xBackModuleOk : BOOL;
		xAllPhotoInactive : BOOL;
		xSensorsSeparatedInProcessDir : BOOL; (*Active when photocell are not assemble over the same vertical axis. That means there is a distance<>0  between them in process direction*)
		xTrustPhotocellASignal : BOOL; (*Active when photocell is over the belt and its signal can be trusted*)
		iSystemState : nSensorsStateMotors := STP_NOT_INITIALIZED;
		iBlocksPositionDesired : INT;
		rSensorPositionAlignment : REAL; (*Position of motor to check alignment of sensors*)
		rBarsPosition : REAL; (*Minimum position of the bar to avoid a crash. Value in mm*)
		rPositionWithOffset : REAL; (*Position in mm of the motors considering the offset. This is equal to the MediaThickness set point*)
		rPositionMotor : REAL; (*Position in mm of the motors*)
		rOffsetToReject : REAL; (*Position to reject the media. Just the second sensor from top*)
		rOffsetToMounted : REAL; (*Position to consider mounted media. Just the first sensor from top*)
		rOffsetToApplyToBarsPosition : REAL;
		xSensorsPositionedRelativeToBar : BOOL; (*Variable to define position desired mode*)
		iSensorToApplyOffset : USINT; (*Index of sensor used to be positioned below bars a distance = rOffsetRelToBar*)
		xInPosition : BOOL; (*Sensors are in the right position depending on the media thickness*)
		xBelowSetPoint : BOOL; (*Sensors are Below the right position depending on the media thickness*)
		xAboveSetPoint : BOOL; (*Sensors are Above the right position depending on the media thickness*)
		xAlignmentChecked : BOOL;
		xCheckingAlignment : BOOL; (*TRUE if in any of the states checking alignement*)
		xSensorValidAlignPos : BOOL;
		xLowPieceDetect : BOOL; (*Low Sensor Detectect*)
		iDetectCount : ARRAY[0..MAX_LAST_NSENSOR]OF UINT; (*Variable to save number of detetions of each sensor*)
		xPhotoCellsNotAligned : ARRAY[0..MAX_LAST_NSENSOR]OF BOOL; (*Signal is TRUE when photocell is not aligned*)
		xMediaToRejectDetected : BOOL; (*Media to be rejected has beed detected*)
		xMountedMediaDetected : BOOL; (*Mounted media has been detected*)
		Icla : nSensors_IclaStatus;
	END_STRUCT;
	nSensorsAlarms : 	STRUCT 
		xNotReferenced : BOOL; (*Phocell system not homed*)
		xNotInstalled : BOOL;
		xComsMotorError : BOOL;
		xMountedTile : BOOL; (*Sensor configured as Mounted Media activated*)
		xControllerNotReady : BOOL; (*Waiting for enable input (STO_A, STO_B)*)
		xMotorError : BOOL; (*Error Id != 0*)
		xNoDigSignalLaserSensor : BOOL; (*Pending to remove in 4.3.6*)
		xContinuousActPDPhcell : BOOL; (*Pending to remove in 4.3.6*)
		xIncoherPhotocellSystem : BOOL; (*Pending to remove in 4.3.6*)
		xAlrCriticalPhotocellNotAligned : BOOL; (*There is an operative photocell not aligned*)
		xPositionOutOfRange : BOOL; (*Maximum sensor position allowed*)
		xAlrWarpMedia : BOOL;
		xAlrInvalidAlignmentPosition : BOOL; (*Alignment position is out of allowed range*)
		xPhotoCellsNotAlignedWarning : ARRAY[0..MAX_LAST_NSENSOR]OF BOOL; (*Warning, not operative photocell*)
		xPhotoCellsNotAlignedError : ARRAY[0..MAX_LAST_NSENSOR]OF BOOL; (*Critical, operative photocell*)
		xPhotoCellsDetectionIncoherence : ARRAY[0..MAX_LAST_NSENSOR]OF BOOL; (*Critical, operative photocell*)
	END_STRUCT;
	nSensorsSignalsIn : 	STRUCT 
		xPhotoCells : ARRAY[0..MAX_LAST_NSENSOR]OF BOOL; (*Signal 0 not valid. Needed for definition. Starts with 1. This cannot be assigned in mapping. It is intenally assign with the pointers. SOMETHING CROSSING, value 0*)
		pInput : ARRAY[0..MAX_LAST_NSENSOR]OF UDINT; (*Pointers to the input card of the photocells signal*)
		xSafetyEnable : BOOL;
	END_STRUCT;
	nSensorsStateMotors : 
		(
		STP_NOT_USED,
		STP_NOT_INITIALIZED,
		STP_POWER_ON,
		STP_HOME_DIR,
		STP_GEARING,
		STP_GEARED,
		STP_HOMING_STEP_1,
		STP_HOMING_STEP_2,
		STP_HOMING_STEP_3,
		STP_HOMING_STEP_4,
		STP_SEARCH_ALIGNMENT_POS_STEP_1,
		STP_SEARCH_ALIGNMENT_POS_STEP_2,
		STP_SEARCH_ALIGNMENT_POS_STEP_3,
		STP_SEARCH_ALIGNMENT_POS_STEP_4,
		STP_CHECK_ALIGNMENT_STEP_1,
		STP_CHECK_ALIGNMENT_STEP_2,
		STP_CHECK_ALIGNMENT_STEP_3,
		STP_CHECK_ALIGNMENT_STEP_4,
		STP_CHECK_ALIGNMENT_STEP_5,
		STP_CHECK_ALIGNMENT_STEP_6,
		STP_STANDSTILL,
		STP_JOGGING,
		STP_AUTO,
		STP_SET_POS,
		STP_RUNING,
		STP_ERROR
		);
	nSensorsAlignmentProcess : 
		(
		STP_ALIGNMENT_NO_REQUIRED,
		STP_ALIGNMENT_REQUIRED
		);
	nSensorsMotorsType : 
		(
		STP_STEPPER,
		STP_ICLA
		);
	nSensorsInputs : 	STRUCT 
		Signals : nSensorsSignalsIn; (*Signal 0 not valid. Needed for definition. Starts with 1*)
	END_STRUCT;
	nSensorsInternal : 	STRUCT 
		xMediaToRejectTreated : BOOL; (*Media to Reject has been treated and can be reseted if the sensor is not detecting*)
		xMountedMediaTreated : BOOL; (*Mounted media has been treated and can be reseted if the sensor is not detecting*)
		rMarginSafePrintChecked : REAL; (*Fix offset to bent tile. The heads go to the thickness measured + this value. Value in mm. Checked minimum value*)
	END_STRUCT;
	nSensors_IclaStatus : 	STRUCT 
		iIclaState : INT; (*Drive status state machine Icla*)
		xHomed : BOOL;
		xIsMoving : BOOL;
		xHoming : BOOL;
		rCurrentVel : REAL; (*Current position in mm*)
		rMaxTorque : REAL; (*Current position in mm*)
		rCurrentTorque : REAL; (*Current position in mm*)
		rCurrentPosition : REAL; (*Current position in mm*)
		iErrorId : UINT;
	END_STRUCT;
END_TYPE
