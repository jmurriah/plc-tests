
TYPE
	OPVCtrlStatus_enum : 
		(
		OPVCTRL_STOPPED,
		OPVCTRL_STOPPING,
		OPVCTRL_PREPARING,
		OPVCTRL_PREPARED,
		OPVCTRL_PAUSING,
		OPVCTRL_PAUSED,
		OPVCTRL_STARTING,
		OPVCTRL_WORKING,
		OPVCTRL_CONTROLSTOPPING
		);
	OPVStatus_enum : 
		(
		OPV_TURNED_OFF,
		OPV_INIT,
		OPV_PREPARING,
		OPV_READY,
		OPV_DRYING,
		OPV_FAULTED,
		OPV_PRIMING,
		OPV_BELT_RUNNING
		);
	OpvType_enum : 
		(
		OPVTY_UNDEFINED,
		OPVTY_GIARDINA,
		OPVTY_DMS,
		OPVTY_TECLIGHTING
		);
	OPVCommsInputs_typ : 	STRUCT 
		xCommsOK : BOOL; (*Modbus communications are working properly*)
		uiTransportSpeed : UINT;
		uiCoaterRollerSpeed : UINT;
		xRemote : BOOL;
		xBeltEmpty : BOOL; (*Belt empty in the device*)
		iVersion1 : INT; (*Machine platform (Nozomi = 1)*)
		iVersion2 : INT; (*Machine project (C18000 = 0 / C14000 = 1)*)
		iVersion3 : INT; (*Hardware version*)
		iVersion4 : INT; (*Sotfware version*)
		iStatus : INT; (*Status word*)
		xStopButtonPressed : BOOL;
	END_STRUCT;
	OPVInputs_typ : 	STRUCT 
		xOPVPresent : BOOL;
		xReadyToPrime : BOOL;
		xCoating : BOOL;
		xError : BOOL;
		xCoatingLevelLow : BOOL;
		xTransportMoving : BOOL;
		xDryerInRun : BOOL;
		xCriticalAlarm : BOOL;
		iCoaterModel : INT;
		xModelInput : ARRAY[0..2]OF BOOL;
		xNoPowered : BOOL;
		Comms : OPVCommsInputs_typ;
	END_STRUCT;
	OPVOutputs_typ : 	STRUCT 
		Physical : OPVPhysicalOutputs_typ;
		Comms : OPVCommsOutputs_typ;
	END_STRUCT;
	OPVAlarms_typ : 	STRUCT 
		xError : BOOL;
		xNoOPVPresent : BOOL;
		xCoatingLevelLow : BOOL;
		xAnyAlarm : BOOL;
		xNotRemote : BOOL;
		xCoatingRecircNotEnabled : BOOL;
		xNoPowered : BOOL;
		xCriticalAlarm : BOOL;
		xWarningAlarm : BOOL;
		xCommsError : BOOL;
		xStopRequest : BOOL; (*Stop request from Dryer when physical stop button is pressed*)
	END_STRUCT;
	OPVParametersSw_typ : 	STRUCT 
		xEnabled : BOOL; (*This variable replaces the previous "xThereIs". Activated by SW*)
		xEnablePriming : BOOL; (*Priming enabled from SW*)
	END_STRUCT;
	OPVParametersHw_typ : 	STRUCT 
		iMaxMediaWidth : UINT; (*Maximum media width allowed in mm*)
		iMinMediaWidth : UINT; (*Minimum media width allowed in mm*)
		iMaxMediaLength : UINT; (*Maximum media length allowed in mm*)
		iMinMediaLength : UINT; (*Minimum media length allowed in mm*)
		rOPVLength : REAL; (*Length in mm*)
		rMaxSpeed : REAL := 100.0; (*Maximum speed allowed in m/min*)
		iMinMediaThickness : UINT; (*Minimum media height allowed in tenth of mm*)
		iMaxMediaThickness : UINT; (*Maximum media height allowed in tenth of mm*)
		xDoubleLineAllowed : BOOL; (*Active when allows double line printing*)
	END_STRUCT;
	OPVParameters_typ : 	STRUCT 
		xInstalled : BOOL;
		xSimulationMode : BOOL; (*Defined by the configuration in Automation Studio*)
		xAlrPresent : BOOL;
		xLineInAuto : BOOL;
		xPreviousDeviceStopped : BOOL; (*Length in mm*)
		rMediaLength : REAL; (*Length in mm*)
		Media : OPVMediaParameters;
		rLineAccelRate : REAL := 2; (*mm/s2 (2.5m/s2*60=150mpm/s)*)
		rLineDecelRate : REAL := 2; (*mm/s2 (2.5m/s2*60=150mpm/s)*)
		xDoubleLine : BOOL;
		LineState : LineStatus_enum;
		LineStatusSummary : LineControlStatusSummarized;
		Hw : OPVParametersHw_typ;
		xActiveSlaveDiagnosis : BOOL;
		rSpeedSetPoint : REAL;
	END_STRUCT;
	OPVCommands_typ : 	STRUCT 
		xStart : BOOL; (*Edge commands. Reseted when managed*)
		xPrepare : BOOL; (*Edge commands. Reseted when managed*)
		xPause : BOOL; (*Edge commands. Reseted when managed*)
		xBelEmpty : BOOL; (*Edge commands. Reseted when managed*)
		xControlStop : BOOL; (*Edge commands. Reseted when managed*)
		xStop : BOOL; (*Edge commands. Reseted when managed*)
		xThereIsOPV : BOOL;
		xResetAlarms : BOOL;
		xEnteringMedia : BOOL;
		xNewBoardParameters : BOOL; (*Pulse to let know board paramters have changed*)
	END_STRUCT;
	OPVDeviceStatus_typ : 	STRUCT 
		xTurnedOff : BOOL;
		xInit : BOOL;
		xPreparing : BOOL;
		xEmpty : BOOL;
		xReady : BOOL;
		xPriming : BOOL;
		xDrying : BOOL;
		xFaulted : BOOL;
	END_STRUCT;
	OPVStatus_typ : 	STRUCT 
		iModel : USINT; (*Model of the Device. 0:Retroflex*)
		Version : EFI_version_typ;
		CtrlStatus : OPVCtrlStatus_enum;
		DeviceStatus : OPVStatus_enum;
		Device : OPVDeviceStatus_typ;
		xBeltEmpty : BOOL;
		OpvType : OpvType_enum;
		Comms : OPVCommsStatus_typ;
	END_STRUCT;
	Opv_typ : 	STRUCT 
		Inputs : OPVInputs_typ;
		Outputs : OPVOutputs_typ;
		Alarms : OPVAlarms_typ;
		ParSw : OPVParametersSw_typ;
		Parameters : OPVParameters_typ;
		Commands : OPVCommands_typ;
		Status : OPVStatus_typ;
		Orders : OpvOrders_typ;
	END_STRUCT;
	OPVPhysicalOutputs_typ : 	STRUCT 
		xPrepareToPrime : BOOL;
		xRunPriming : BOOL;
		xRunTransport : BOOL;
		xRunDryer : BOOL;
		xEnabledNormalDecel : BOOL;
	END_STRUCT;
	OPVCommsOutputs_typ : 	STRUCT 
		iControl : INT; (*Status word*)
		iControl2 : INT; (*Status word*)
	END_STRUCT;
	OPVMediaParameters : 	STRUCT 
		rThickness : REAL; (*Tile thickness to print from gui in mm*)
		rWidth : REAL; (*Board's width in mm*)
		rGap : REAL; (*Gap between boards in mm*)
		rLength : REAL; (*Board's length in mm*)
		rOffsetRegisterL1 : REAL; (*Board's width in mm*)
		rOffsetRegisterL2 : REAL; (*Board's width in mm*)
	END_STRUCT;
	OPVCommsStatus_typ : 	STRUCT 
		xModuleOk : BOOL;
		ModSlaveState : UINT;
		LastError : UINT;
		LastErrorBlockNum : UINT;
		xStopButtonPressed : BOOL;
		ActOverloadError : BOOL;
		ActModbusError : BOOL;
		ActSlvConError : BOOL;
		ActRefreshError : BOOL;
		ActInternalError : BOOL;
		ActConfError : BOOL;
		HistOverloadError : BOOL;
		HistModbusError : BOOL;
		HistSlvConError : BOOL;
		HistRefreshError : BOOL;
		HistInternalError : BOOL;
		HistConfError : BOOL;
		ModbusErrorCnt : UINT;
		ModbusConErrorCnt : UINT;
		ModbusPktRefreshTimeoutCnt : UINT;
		ModbusPktPendPerSec : UINT;
		ModbusMeanResponseTime : UINT;
	END_STRUCT;
	OpvOrders_typ : 	STRUCT 
		xDisableWriteBlock : BOOL;
		xDisableReadBlock : BOOL;
		xEnablePriming : BOOL; (*Priming enabled from printer/line*)
	END_STRUCT;
END_TYPE
