
TYPE
	StackerCtrlStatus_enum : 
		(
		STACKERCTRL_STOPPED,
		STACKERCTRL_STOPPING,
		STACKERCTRL_PREPARING,
		STACKERCTRL_PREPARED,
		STACKERCTRL_PAUSING,
		STACKERCTRL_PAUSED,
		STACKERCTRL_STARTING,
		STACKERCTRL_WORKING,
		STACKERCTRL_CONTROLSTOPPING
		);
	StackerStatus_enum : 
		(
		STACKER_TURNED_OFF,
		STACKER_INIT,
		STACKER_PREPARING,
		STACKER_READY,
		STACKER_WORKING,
		STACKER_FAULTED
		);
	StackerType_enum : 
		(
		STACKERTY_UNDEFINED,
		STACKERTY_FULL_S,
		STACKERTY_BUNDLE_S
		);
	StackerInputs_typ : 	STRUCT 
		xError : BOOL;
		xRunning : BOOL;
		xReadyToStack : BOOL;
		xFeedInterrupt : BOOL;
		xStackSuccess : BOOL;
		xRejectSuccess : BOOL;
		xModelInput : ARRAY[0..2]OF BOOL;
		Comms : StackerCommsInputs_typ;
		xStackerPresent : BOOL;
		xNoPowered : BOOL;
	END_STRUCT;
	StackerOutputs_typ : 	STRUCT 
		xRun : BOOL;
		xStackEject : BOOL;
		xEjectRejectStack : BOOL;
		xPrepareToStack : BOOL;
		xRejectSheet : BOOL;
		xCleanBelts : BOOL; (*Command to empty stacker's belts*)
	END_STRUCT;
	StackerAlarms_typ : 	STRUCT 
		xError : BOOL;
		xFeedInterrupt : BOOL;
		xAlrOutAutomatic : BOOL;
		xAnyAlarm : BOOL;
		xNotRemote : BOOL;
		xCriticalAlarm : BOOL;
		xWarningAlarm : BOOL;
		xNoStackerPresent : BOOL;
		xCommsError : BOOL;
		xNoPowered : BOOL;
		xBeltsStopped : BOOL;
		xRejectNoAvailable : BOOL;
		xStopRequest : BOOL; (*Stop request from Dryer when physical stop button is pressed*)
	END_STRUCT;
	StackerParametersSw_typ : 	STRUCT 
		xEnabled : BOOL;
		iStackHeight : UINT;
		iStackBoardsNum : UINT;
		xStackMode : BOOL; (*(0 - Stack per number of boards, 1 - Stack per height)*)
	END_STRUCT;
	StackerParametersHw_typ : 	STRUCT 
		xRejectEjectionAvailable : BOOL; (*stacker has the possibility to eject rejected boards automatically*)
		xThereIsReject : BOOL; (*Stacker has reject device*)
		rMaxSpeed : REAL := 100.0; (*Maximum speed allowed in m/min*)
		iMaxMediaWidth : UINT; (*Maximum media width allowed in mm*)
		iMinMediaWidth : UINT; (*Minimum media width allowed in mm*)
		iMinMediaThickness : UINT; (*Maximum media length allowed in mm*)
		iMaxMediaThickness : UINT; (*Minimum media length allowed in mm*)
		iMaxMediaLength : UINT; (*Maximum media length allowed in mm*)
		iMinMediaLength : UINT; (*Minimum media length allowed in mm*)
		iRejectAdjustmentDistance : INT; (*Distance in cm from beginning of the Stacker to Reject Position. Positive inside Stacker. Negative previous to Stacker*)
		iDistanceToReject : INT; (*Distance measured from "iRejectAdjusmentDistance" to reject belt start of the stacker. Physically from sensor at stacker's entry to the reject belt*)
		iMinStackHeight : UINT;
		iMaxStackHeight : UINT;
		iMinStackBoards : UINT;
		iMaxStackBoards : UINT;
		rStackerLength : REAL;
		xDoubleLineAllowed : BOOL; (*Active when allows double line printing*)
	END_STRUCT;
	StackerParameters_typ : 	STRUCT 
		xInstalled : BOOL;
		xSimulationMode : BOOL; (*Defined by the configuration in Automation Studio*)
		xCommsOK : BOOL;
		xAlrPresent : BOOL;
		LineState : LineStatus_enum;
		xLineInAuto : BOOL;
		xInRemote : BOOL;
		Media : StackerMediaParameters;
		rSpeedSetPoint : REAL;
		rMediaLength : REAL;
		xPreviousDeviceStopped : BOOL;
		xDoubleLine : BOOL;
		LineStatusSummary : LineControlStatusSummarized;
		Hw : StackerParametersHw_typ;
		xActiveSlaveDiagnosis : BOOL;
	END_STRUCT;
	StackerCommands_typ : 	STRUCT 
		xStart : BOOL; (*Edge commands. Reseted when managed*)
		xPrepare : BOOL; (*Edge commands. Reseted when managed*)
		xPause : BOOL; (*Edge commands. Reseted when managed*)
		xControlStop : BOOL; (*Edge commands. Reseted when managed*)
		xStop : BOOL; (*Edge commands. Reseted when managed*)
		xStartTransport : BOOL; (*Edge commands. Reseted when managed*)
		xResetAlarms : BOOL; (*Edge commands. Reseted when managed*)
		xRejectSheet : BOOL;
		xEjectPileStack : BOOL; (*Edge commands. Reseted when managed*)
		xCleanBelts : BOOL; (*Edge commands. Reseted when managed*)
		xEjectRejectStack : BOOL; (*Edge commands. Reseted when managed*)
	END_STRUCT;
	StackerOrders_typ : 	STRUCT 
		xHoldReject : BOOL; (*While the signal is 1, the reject remains activated.*)
		xRejectSheet : BOOL;
		xDisableWriteBlock : BOOL; (*No read/write of channels of block (Modbus)*)
		xDisableReadBlock : BOOL;
	END_STRUCT;
	StackerDeviceStatus_typ : 	STRUCT 
		xTurnedOff : BOOL;
		xInit : BOOL;
		xPreparing : BOOL;
		xReadyToStack : BOOL;
		xStacking : BOOL;
		xStackEjecting : BOOL;
		xFaulted : BOOL;
		xNotRemote : BOOL;
	END_STRUCT;
	StackerStatus_typ : 	STRUCT 
		iModel : UINT; (*Model of the Device*)
		Version : EFI_version_typ;
		CtrlStatus : StackerCtrlStatus_enum;
		DeviceStatus : StackerStatus_enum;
		Device : StackerDeviceStatus_typ;
		xBeltEmpty : BOOL;
		StackerType : StackerType_enum;
		Comms : StackerCommsStatus_typ;
	END_STRUCT;
	Stacker_typ : 	STRUCT 
		Inputs : StackerInputs_typ;
		Outputs : StackerOutputs_typ;
		Alarms : StackerAlarms_typ;
		ParSw : StackerParametersSw_typ;
		Parameters : StackerParameters_typ;
		Commands : StackerCommands_typ; (*Just Edge commands*)
		Orders : StackerOrders_typ;
		Status : StackerStatus_typ;
		Comms : StackerCommsOutputs_typ;
	END_STRUCT;
	StackerCommsInputs_typ : 	STRUCT 
		xCommsOK : BOOL; (*Modbus communications are working properly*)
		xRemote : BOOL; (*(0: local; 1: remote)*)
		xErrorActive : BOOL; (*Any critical alarm activated*)
		xWarningActive : BOOL; (*Any warning alarm activated*)
		xOnline : BOOL; (*Modbus communications OK in stacker's side*)
		xNewFormat : BOOL; (*New box format. Please, empty stack*)
		xSerie : BOOL; (*Machine serie, SerA = 1 / SerB =0*)
		xBeltsEmpty : BOOL; (*Belts with no boards*)
		xRejectAvailable : BOOL; (*(1 = Reject Available; 0 = Reject not available)*)
		xEmergencyStopNotAcknowledged : BOOL; (*Safety alarm not acknowledge on stacker's HMI*)
		xInWorkingPosition : BOOL; (*Stacker positioned*)
		xStackExit : BOOL; (*Pile leaving*)
		xStopDemand : BOOL; (*Boards sending request*)
		xStackerEmpty : BOOL; (*Stacker and belt with no boards*)
		xStackReady : BOOL; (*Pile ready to be extracted*)
		iVersion1 : INT; (*Machine platform (Nozomi = 1)*)
		iVersion2 : INT; (*Machine project (C18000 = 0 / C14000 = 1)*)
		iVersion3 : INT; (*Hardware version*)
		iVersion4 : INT; (*Sotfware version*)
		iStatus : INT; (*Status word*)
		iAlarmWord1 : INT; (*Status word*)
		iAlarmWord2 : INT; (*Status word*)
		iAlarmWord3 : INT; (*Status word*)
		iAlarmWord4 : INT; (*Status word*)
		iAlarmWord5 : INT; (*Status word*)
		iAlarmWord6 : INT; (*Status word*)
		iAlarmWord7 : INT; (*Status word*)
		iAlarmWord8 : INT; (*Status word*)
		iAlarmWord9 : INT; (*Status word*)
		iAlarmWord10 : INT; (*Status word*)
		uiTransportSpeed : UINT;
		uiNumBoardsInCurrentPile : INT;
		uiCurrentPileHeigh : INT;
	END_STRUCT;
	StackerCommsOutputs_typ : 	STRUCT 
		iControl : INT; (*Status word*)
		xBelEmpty : BOOL; (*Edge commands. Reseted when managed*)
		xResetAlarms : BOOL;
		xNewBoardParameters : BOOL; (*Pulse to let know board paramters have changed*)
		xCleanBelts : BOOL; (*Command to empty stacker's belts*)
		xEndCycle : BOOL; (*Controlled stop with pile stacked output*)
		xLastBox : BOOL; (*Signal for indicate the last box of the current pile*)
	END_STRUCT;
	StackerMediaParameters : 	STRUCT 
		rThickness : REAL; (*Tile thickness to print from gui in mm*)
		rWidth : REAL; (*Board's width in mm*)
		rGap : REAL; (*Gap between boards in mm*)
		rLength : REAL; (*Board's length in mm*)
		rOffsetRegisterL1 : REAL; (*Board's width in mm*)
		rOffsetRegisterL2 : REAL; (*Board's width in mm*)
	END_STRUCT;
	StackerCommsStatus_typ : 	STRUCT 
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
END_TYPE
