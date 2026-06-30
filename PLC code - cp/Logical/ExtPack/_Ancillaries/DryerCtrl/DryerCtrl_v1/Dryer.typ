
TYPE
	DryerCtrlStatus_enum : 
		(
		DRYERCTRL_STOPPED,
		DRYERCTRL_STOPPING,
		DRYERCTRL_PREPARING,
		DRYERCTRL_PREPARED,
		DRYERCTRL_PAUSING,
		DRYERCTRL_PAUSED,
		DRYERCTRL_STARTING,
		DRYERCTRL_DRYING,
		DRYERCTRL_CONTROLSTOPPING,
		DRYERCTRL_PREPARINGTOMOVE,
		DRYERCTRL_MOVING,
		DRYERCTRL_PREPARINGEMPTYBELT
		);
	DryerStatus_enum : 
		(
		DRYER_TURNED_OFF,
		DRYER_INIT,
		DRYER_PREPARING,
		DRYER_READY,
		DRYER_DRYING,
		DRYER_FAULTED,
		DRYER_DRYING_ARC_LAMP,
		DRYER_BELTRUNNING
		);
	DryerType_enum : 
		(
		DRYERTY_UNDEFINED,
		DRYERTY_EFI (*EFI manufacturer.*)
		);
	DryerInputs_typ : 	STRUCT 
		xError : BOOL;
		xDrying : BOOL;
		xReadyToDry : BOOL;
		xJamDetection : BOOL;
		xTransportMoving : BOOL;
		xInRemote : BOOL;
		xModelInput : ARRAY[0..2]OF BOOL;
		xMediaPresent : BOOL;
		xCommsOK : BOOL; (*Modbus communications are working properly*)
		xBeltEmpty : BOOL; (*Belt empty in the device*)
		xReadyToEmptyBelt : BOOL; (*Dryer ready to perform empty belt*)
		xStopButtonPressed : BOOL; (*Red button pressed. Stop Required*)
	END_STRUCT;
	DryerOutputs_typ : 	STRUCT 
		xPrepareToDry : BOOL;
		xStartDrying : BOOL;
		xRunTransport : BOOL;
		xPrepareToEmptyBelt : BOOL;
	END_STRUCT;
	DryerAlarms_typ : 	STRUCT 
		xError : BOOL;
		xStopRequest : BOOL; (*Stop request from Dryer when physical stop button is pressed*)
		xNotRemote : BOOL;
		xNoDryerPresent : BOOL;
		xAnyAlarm : BOOL;
		xCriticalAlarm : BOOL;
		xWarningAlarm : BOOL;
		xCommsError : BOOL;
	END_STRUCT;
	DryerParametersHw_typ : 	STRUCT 
		iMaxMediaWidth : UINT; (*Maximum media width allowed in mm*)
		iMinMediaWidth : UINT; (*Minimum media width allowed in mm*)
		iMaxMediaLength : UINT; (*Maximum media length allowed in mm*)
		iMinMediaLength : UINT; (*Minimum media length allowed in mm*)
		rDryerLength : REAL; (*Length in mm*)
		rMaxSpeed : REAL := 100.0; (*Maximum speed allowed in m/min*)
		xDoubleLineAllowed : BOOL; (*Active when printer allows double line printing*)
	END_STRUCT;
	DryerParametersSw_typ : 	STRUCT 
		xEnabled : BOOL;
		xEnableNIR : BOOL;
		xEnableDDC : BOOL; (*Enable DDC behavior in Dryer*)
		xEnableArcLamp : BOOL;
		rSubstratePowerReduction : REAL := 1.0; (*Substrate power reduction. From 1.0 (default) to 0.3 is allowed*)
	END_STRUCT;
	DryerParameters_typ : 	STRUCT 
		xInstalled : BOOL;
		xSimulationMode : BOOL; (*Defined by the configuration in Automation Studio*)
		xCommsOK : BOOL;
		xAlrPresent : BOOL;
		LineState : LineStatus_enum;
		xLineInAuto : BOOL;
		xInRemote : BOOL;
		xSecurityOK : BOOL;
		rSpeedSetPoint : REAL; (*Speed in m/min*)
		rMediaLength : REAL; (*Length in mm*)
		rMediaWidth : REAL; (*Length in mm*)
		rMediaThickness : REAL; (*Length in mm*)
		rMediaGap : REAL; (*Length in mm*)
		xPreviousDeviceStopped : BOOL;
		LineStatusSummary : LineControlStatusSummarized;
		rDocumentWidth : REAL; (*Length in mm*)
		rDocumentLength : REAL; (*Length in mm*)
		rDocumentOffsetL1 : REAL; (*Job's document offset L1 in mm*)
		rDocumentOffsetL2 : REAL; (*Job's document offset L2 in mm*)
		Hw : DryerParametersHw_typ;
		xDoubleLine : BOOL;
	END_STRUCT;
	DryerCommands_typ : 	STRUCT 
		xBelEmpty : BOOL; (*Edge commands. Reseted when managed*)
		xStart : BOOL; (*Edge commands. Reseted when managed*)
		xPrepare : BOOL; (*Edge commands. Reseted when managed*)
		xPause : BOOL; (*Edge commands. Reseted when managed*)
		xStop : BOOL; (*Edge commands. Reseted when managed*)
		xControlStop : BOOL; (*Edge commands. Reseted when managed*)
		xStartTransport : BOOL; (*Edge commands. Reseted when managed*)
		xThereIsDryer : BOOL;
		xResetAlarms : BOOL;
	END_STRUCT;
	DryerDeviceStatus_typ : 	STRUCT 
		xTurnedOff : BOOL;
		xInit : BOOL;
		xPreparing : BOOL;
		xBeltRunning : BOOL;
		xReadyToDry : BOOL;
		xDrying : BOOL;
		xFaulted : BOOL;
	END_STRUCT;
	DryerStatus_typ : 	STRUCT 
		iModel : USINT := 1; (*Model of the Device. 0:BDT 1:Serra*)
		Version : EFI_version_typ;
		CtrlStatus : DryerCtrlStatus_enum;
		DeviceStatus : DryerStatus_enum;
		Device : DryerDeviceStatus_typ;
		xBeltEmpty : BOOL;
		DryerType : DryerType_enum;
	END_STRUCT;
	DryerAnc_typ : 	STRUCT 
		Inputs : DryerInputs_typ;
		Outputs : DryerOutputs_typ;
		Alarms : DryerAlarms_typ;
		ParSw : DryerParametersSw_typ;
		Parameters : DryerParameters_typ;
		Commands : DryerCommands_typ;
		Status : DryerStatus_typ;
	END_STRUCT;
END_TYPE
