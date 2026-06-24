
TYPE
	PrimerCtrlStatus_enum : 
		(
		PRIMERCTRL_STOPPED,
		PRIMERCTRL_STOPPING,
		PRIMERCTRL_PREPARING,
		PRIMERCTRL_PREPARED,
		PRIMERCTRL_PAUSING,
		PRIMERCTRL_PAUSED,
		PRIMERCTRL_STARTING,
		PRIMERCTRL_WORKING,
		PRIMERCTRL_CONTROLSTOPPING
		);
	PrimerStatus_enum : 
		(
		PRIMER_TURNED_OFF,
		PRIMER_INIT,
		PRIMER_PREPARING,
		PRIMER_READY,
		PRIMER_DRYING,
		PRIMER_FAULTED,
		PRIMER_PRIMING,
		PRIMER_BELT_RUNNING
		);
	PrimerType_enum : 
		(
		PRIMERTY_UNDEFINED,
		PRIMERTY_GIARDINA,
		PRIMERTY_DMS,
		PRIMERTY_TECLIGHTNING
		);
	PrimerCommsInputs_typ : 	STRUCT 
		xCommsOK : BOOL; (*Modbus communications are working properly*)
		uiTransportSpeed : UINT;
		uiCoaterRollerSpeed : UINT;
		xRemote : BOOL;
		xSpeedMode : BOOL; (*Belt empty in the device*)
		xBeltEmpty : BOOL; (*Belt empty in the device*)
		iVersion1 : INT; (*Machine platform (Nozomi = 1)*)
		iVersion2 : INT; (*Machine project (C18000 = 0 / C14000 = 1)*)
		iVersion3 : INT; (*Hardware version*)
		iVersion4 : INT; (*Sotfware version*)
		iStatus : INT; (*Status word*)
		xStopButtonPressed : BOOL;
	END_STRUCT;
	PrimerInputs_typ : 	STRUCT 
		xPrimerPresent : BOOL;
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
		Comms : PrimerCommsInputs_typ;
		xIrPowered : BOOL;
		xUvPowered : BOOL;
	END_STRUCT;
	PrimerOutputs_typ : 	STRUCT 
		Physical : PrimerPhysicalOutputs_typ;
		Comms : PrimerCommsOutputs_typ;
	END_STRUCT;
	PrimerAlarms_typ : 	STRUCT 
		xError : BOOL;
		xNoPrimerPresent : BOOL;
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
	PrimerParametersSw_typ : 	STRUCT 
		xEnabled : BOOL; (*This variable replaces the previous "xThereIs". Activated by SW*)
		xEnablePriming : BOOL; (*Priming enabled from SW*)
	END_STRUCT;
	PrimerParametersHw_typ : 	STRUCT 
		iMaxMediaWidth : UINT; (*Maximum media width allowed in mm*)
		iMinMediaWidth : UINT; (*Minimum media width allowed in mm*)
		iMaxMediaLength : UINT; (*Maximum media length allowed in mm*)
		iMinMediaLength : UINT; (*Minimum media length allowed in mm*)
		rPrimerLength : REAL; (*Length in mm*)
		rMaxSpeed : REAL := 100.0; (*Maximum speed allowed in m/min*)
		iMinMediaThickness : UINT; (*Minimum media height allowed in tenth of mm*)
		iMaxMediaThickness : UINT; (*Maximum media height allowed in tenth of mm*)
		xDoubleLineAllowed : BOOL; (*Active when printer allows double line printing*)
	END_STRUCT;
	PrimerParameters_typ : 	STRUCT 
		xInstalled : BOOL;
		xSimulationMode : BOOL; (*Defined by the configuration in Automation Studio*)
		xAlrPresent : BOOL;
		xLineInAuto : BOOL;
		xPreviousDeviceStopped : BOOL; (*Length in mm*)
		rMediaLength : REAL; (*Length in mm*)
		rSpeedSetPoint : REAL; (*Speed in m/min*)
		Media : PrimerMediaParameters;
		rLineAccelRate : REAL := 2; (*mm/s2 (2.5m/s2*60=150mpm/s)*)
		rLineDecelRate : REAL := 2; (*mm/s2 (2.5m/s2*60=150mpm/s)*)
		rBeltSpeedSetPoint : REAL;
		xDoubleLine : BOOL;
		LineState : LineStatus_enum;
		LineStatusSummary : LineControlStatusSummarized;
		Hw : PrimerParametersHw_typ;
		xActiveSlaveDiagnosis : BOOL;
	END_STRUCT;
	PrimerCommands_typ : 	STRUCT 
		xStart : BOOL; (*Edge commands. Reseted when managed*)
		xPrepare : BOOL; (*Edge commands. Reseted when managed*)
		xPause : BOOL; (*Edge commands. Reseted when managed*)
		xBelEmpty : BOOL; (*Edge commands. Reseted when managed*)
		xControlStop : BOOL; (*Edge commands. Reseted when managed*)
		xStop : BOOL; (*Edge commands. Reseted when managed*)
		xThereIsPrimer : BOOL;
		xResetAlarms : BOOL;
		xEnteringMedia : BOOL;
		xNewBoardParameters : BOOL; (*Pulse to let know board paramters have changed*)
	END_STRUCT;
	PrimerDeviceStatus_typ : 	STRUCT 
		xTurnedOff : BOOL;
		xInit : BOOL;
		xPreparing : BOOL;
		xEmpty : BOOL;
		xReady : BOOL;
		xPriming : BOOL;
		xDrying : BOOL;
		xFaulted : BOOL;
	END_STRUCT;
	PrimerStatus_typ : 	STRUCT 
		iModel : USINT; (*Model of the Device. 0:Retroflex*)
		Version : EFI_version_typ;
		CtrlStatus : PrimerCtrlStatus_enum;
		DeviceStatus : PrimerStatus_enum;
		Device : PrimerDeviceStatus_typ;
		xBeltEmpty : BOOL;
		PrimerType : PrimerType_enum;
		Comms : PrimerCommsStatus_typ;
	END_STRUCT;
	Primer_typ : 	STRUCT 
		Inputs : PrimerInputs_typ;
		Outputs : PrimerOutputs_typ;
		Alarms : PrimerAlarms_typ;
		ParSw : PrimerParametersSw_typ;
		Parameters : PrimerParameters_typ;
		Commands : PrimerCommands_typ;
		Status : PrimerStatus_typ;
		Orders : PrimerOrders_typ;
	END_STRUCT;
	PrimerPhysicalOutputs_typ : 	STRUCT 
		xPrepareToPrime : BOOL;
		xRunPriming : BOOL;
		xRunTransport : BOOL;
		xRunDryer : BOOL;
	END_STRUCT;
	PrimerCommsOutputs_typ : 	STRUCT 
		iControl : UINT; (*Status word*)
		iControl2 : UINT; (*Status word*)
	END_STRUCT;
	PrimerMediaParameters : 	STRUCT 
		rThickness : REAL; (*Tile thickness to print from gui in mm*)
		rWidth : REAL; (*Board's width in mm*)
		rGap : REAL; (*Gap between boards in mm*)
		rLength : REAL; (*Board's length in mm*)
		rOffsetRegisterL1 : REAL; (*Board's width in mm*)
		rOffsetRegisterL2 : REAL; (*Board's width in mm*)
	END_STRUCT;
	PrimerCommsStatus_typ : 	STRUCT 
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
	PrimerOrders_typ : 	STRUCT 
		xDisableWriteBlock : BOOL;
		xDisableReadBlock : BOOL;
		xEnablePriming : BOOL; (*Priming enabled from printer/line*)
	END_STRUCT;
END_TYPE
