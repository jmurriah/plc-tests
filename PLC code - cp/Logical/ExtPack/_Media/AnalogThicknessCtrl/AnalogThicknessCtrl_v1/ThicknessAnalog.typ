
TYPE
	AnalogSensorType : 
		(
		ANSENS_BALLUF_48,
		ANSENS_BALLUF_97
		);
	ThicknessAnalogInternal : 	STRUCT 
		xMediaToRejectTreated : BOOL; (*Media to Reject has been treated and can be reseted if the sensor is not detecting*)
		xMountedMediaTreated : BOOL; (*Mounted media has been treated and can be reseted if the sensor is not detecting*)
	END_STRUCT;
	stThicknessAnalogAlarms : 	STRUCT 
		xMountedTile : BOOL; (*Mlounted Tile Detect*)
		xAlDingDetect : BOOL; (*Stop Alarm*)
		xAlNoDingDetect : BOOL; (*Stop Alarm*)
		xAlDingNotReferenced : BOOL; (*Critical Alarm*)
		xAlDingIncoherenceValue : BOOL; (*Stop Alarm. NOT USING, NOT IN SOFTWARE INTERFACE*)
		xAlDingConexionError : BOOL; (*Stop Alarm*)
		xAlDingNoMediaToCalibrate : BOOL; (*NOT IN ALARM SUMMARY*)
		xAlDingNoDigLaserSensor : BOOL; (*NOT IN ALARM SUMMARY*)
	END_STRUCT;
	stThicknessAnalogIn : 	STRUCT 
		pInputCard : UDINT; (*Pointer to the input card of the analog signal*)
		xModuleOK : BOOL; (*PLC card properly connected to X2X*)
		xDingChannelFault : BOOL; (*SoftwareInput*)
		rHighDingMm : REAL; (*AnalogInputCalculate. Value in mm*)
		iHighDingRaw : INT; (*AnalogInput. Direct from the Analog card*)
		xDingHigh : BOOL; (*DI*)
		xDingLow : BOOL; (*DI*)
		xAnyCarriageProductDetect : BOOL; (*Any Product Detect signal coming from Carriage is activated*)
	END_STRUCT;
	stThicknessAnalogOut : 	STRUCT 
		xReset : BOOL; (*DO*)
	END_STRUCT;
	stThicknessAnalogState : 	STRUCT 
		xDingLowPieceDetect : BOOL; (*DI+Analog value*)
		rCurrentHigh : REAL; (*Current High with offsets. Value in mm*)
		rCurrentThicknessStable : REAL; (*Current High with offsets. Value in mm  Delayed maximum to able to watch it*)
		xDingReferenced : BOOL := FALSE; (*State*)
		xDingInstalled : BOOL; (*State*)
		xSensorCovered : BOOL; (*DI*)
		diLgLowPieceCounter : DINT; (*Log*)
		rOffsetCalibration : REAL; (*Offset to consider the real value of the substrate*)
		rBarsPosition : REAL; (*Minimum position of the bar to avoid a crash. Value in mm*)
		xMediaToRejectDetected : BOOL; (*Media to be rejected has beed detected*)
		xMountedMediaDetected : BOOL; (*Mounted media has been detected*)
		Permanent : stThicknessAnalogPermanent; (*Permanent values stored in flash memory*)
	END_STRUCT;
	stThicknessAnalogPermanent : 	STRUCT 
		xDingReferenced : BOOL := FALSE; (*State*)
		rOffsetCalibration : REAL; (*Offset to consider the real value of the substrate*)
	END_STRUCT;
	stThicknessAnalogParametersSw : 	STRUCT 
		rCalibrationValue : REAL; (*Software Input. Value of the media in the sensor to adjust the reading*)
	END_STRUCT;
	stThicknessAnalogDiscreteParam : 	STRUCT 
		rDistanceBetweenSensors : REAL; (*Distance between the virtual sensors*)
		rOffsetRelToBar : REAL := 0.5; (*Media Offset position in mm. Distance to consider the virtual first digital sensor*)
		iVirtualSensors : USINT; (*Quantity of virtual sensors*)
	END_STRUCT;
	stThicknessAnalogParameters : 	STRUCT 
		xDingInstalled : BOOL; (*Configured depending on the machine. Is installed or it can be installed*)
		xEnable : BOOL; (*Configured depending on the machine. Is installed or it can be installed*)
		xAllowDynamicEnable : BOOL; (*The machine allows dynamic enabling or disabling the funcionality*)
		SensorType : AnalogSensorType;
		Discrete : stThicknessAnalogDiscreteParam;
		xKeepHoming : BOOL; (*The system has to keep the homing after a reboot in the PLC*)
		xDiscreteBehavior : BOOL; (*Consider a discrete behavior similar to digital sensors to avoid a lot of movements*)
		xSimulationMode : BOOL; (*Defined by the configuration in Automation Studio*)
		xRaiseDigitalIncoherency : BOOL; (*Raise digital incoherency when receiving Product Detect but not AnalogDetection.Low. Managed in gMachine.Alarms*)
		rMediaThickness : REAL := 5; (*Media Thickness in mm*)
		rMarginPrint : REAL; (*Value in mm*)
		rMachineMinTicknessMedia : REAL; (*Value in mm*)
		MountedDetectionType : ThicknessMountedDetectionType;
		rOverThicknessToMounted : REAL; (*Value in mm over the configured thickness*)
		rThicknessToMounted : REAL; (*Absolute valure in mm to consider mounted*)
		rMountedMediaLevelInBypassMode : REAL; (*mm*)
		rMarginSafePrint : REAL; (*Coming from Sw (indirectly). Fix offset to bent tile. The heads go to the thickness measured + this value. Value in mm*)
		rOverThicknessToReject : REAL; (*mm. Value of the media detected to consider it bad and need to be rejected*)
		rMarginSafeRejectForAnalog : REAL; (*Offset while boards to reject. The heads go to the thickness measured + this value. Value in mm*)
		iAnalogSamples : USINT; (*mm. Value of the media detected to consider it bad and need to be rejected*)
	END_STRUCT;
	stThickessAnalogCommands : 	STRUCT 
		xErrorRst : BOOL; (*Order to reset Alarms*)
		xCalibrateThickness : BOOL; (*Software Input*)
		xMute : BOOL; (*Mute Order*)
		AutoMode : stEFI_MachineAutoModes; (*commands to inform belt*)
		Mode : StGeneral_States_Mode;
		xMountedMediaInside : BOOL; (*Mounted Media Inside*)
	END_STRUCT;
	stThicknessAnalog_typ : 	STRUCT 
		Alarms : stThicknessAnalogAlarms;
		AlSummary : stEFI_AlarmSummary;
		In : stThicknessAnalogIn;
		Out : stThicknessAnalogOut;
		State : stThicknessAnalogState;
		Parameters : stThicknessAnalogParameters;
		parSw : stThicknessAnalogParametersSw;
		Commands : stThickessAnalogCommands;
		_Internal : nSensorsInternal;
	END_STRUCT;
END_TYPE
