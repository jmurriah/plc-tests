
TYPE
	FeederCtrlStatus_enum : 
		(
		FEEDERCTRL_STOPPED,
		FEEDERCTRL_STOPPING,
		FEEDERCTRL_PREPARING,
		FEEDERCTRL_PREPARED,
		FEEDERCTRL_PAUSING,
		FEEDERCTRL_PAUSED,
		FEEDERCTRL_STARTING,
		FEEDERCTRL_FEEDING,
		FEEDERCTRL_CONTROLSTOPPING
		);
	FeederStatus_enum : 
		(
		FEEDER_TURNED_OFF,
		FEEDER_INIT,
		FEEDER_PREPARING,
		FEEDER_READY,
		FEEDER_FEEDING,
		FEEDER_FAULTED
		);
	FeederType_enum : 
		(
		FEEDERTY_UNDEFINED,
		FEEDERTY_BOTTOM_14, (*Bottom feeder. Serra manufacturer. 1400mm width*)
		FEEDERTY_BOTTOM_18, (*Bottom feeder. Serra manufacturer. 1800mm width*)
		FEEDERTY_TOP (*Top feeder. BDT manufacturer. 1800mm width*)
		);
	FeederInputs_typ : 	STRUCT 
		xOnline : BOOL;
		xError : BOOL;
		xFeeding : BOOL;
		xMultiPick : BOOL; (*BDT Feeder specifi signal*)
		xTrayEmpty : BOOL;
		xFeederPresent : BOOL;
		xMediaThickness : BOOL;
		xReadyToFeed : BOOL;
		xMediaLowL1 : BOOL;
		xMediaLowL2 : BOOL;
		xJamDetection : BOOL; (*SerraFeeder specific signal.*)
		xTrayEmptyL1 : BOOL;
		xTrayEmptyL2 : BOOL;
		xModelInput : ARRAY[0..2]OF BOOL;
		xNoPowered : BOOL;
		Comms : FeederCommsInputs_typ;
	END_STRUCT;
	FeederOutputs_typ : 	STRUCT 
		Physical : FeederPhysicalOutputs_typ;
		Comms : FeederCommsOutputs_typ;
	END_STRUCT;
	FeederAlarms_typ : 	STRUCT 
		xError : BOOL;
		xNotOnline : BOOL;
		xNotRemote : BOOL;
		xNoFeederPresent : BOOL;
		xAnyAlarm : BOOL;
		xMediaLowL1 : BOOL;
		xMediaLowL2 : BOOL;
		xTrayEmptyL1 : BOOL;
		xTrayEmptyL2 : BOOL;
		xNoPowered : BOOL;
		xCriticalAlarm : BOOL;
		xWarningAlarm : BOOL;
		xCommsError : BOOL;
		xStopRequest : BOOL; (*Stop request from Dryer when physical stop button is pressed*)
	END_STRUCT;
	FeederParametersSw_typ : 	STRUCT 
		xEnabled : BOOL;
		xBatchFeeding : BOOL; (*1:Batch feeding mode; 0: continuous feeding.*)
		iCentralOffset : INT; (*Offset value received from SW for feeders with Parameters.Hw.xOffsetAvailable = TRUE;*)
	END_STRUCT;
	FeederParametersHw_typ : 	STRUCT 
		iMaxMediaWidth : UINT; (*Maximum media width allowed in mm*)
		iMinMediaWidth : UINT; (*Minimum media width allowed in mm*)
		iMinMediaLength : UINT; (*Minimum media length allowed in mm*)
		iMaxMediaLength : UINT; (*Maximum media length allowed in mm*)
		xOffsetAvailable : BOOL; (*Offset line alignment parameter available*)
		iMaxOffset : UINT; (*Upper limit for line alignment offset value [mm]*)
		iMinOffset : INT; (*Lower limit for line alignment offset value [mm]*)
		iMinMediaThickness : UINT; (*Minimum media height allowed in tenth of mm*)
		iMaxMediaThickness : UINT; (*Maximum media height allowed in tenth of mm*)
		rMaxSpeed : REAL := 100.0; (*Maximum speed allowed in m/min*)
		xDoubleLineAllowed : BOOL; (*Active when printer allows double line printing*)
	END_STRUCT;
	FeederParameters_typ : 	STRUCT 
		xInstalled : BOOL;
		xSimulationMode : BOOL; (*Defined by the configuration in Automation Studio*)
		xCommsOK : BOOL;
		xAlrPresent : BOOL;
		LineState : LineStatus_enum;
		iRegisterType : UINT := 1; (*0:lateral; 1:central*)
		iLineConfig : UINT;
		xLineInAuto : BOOL;
		Media : FeederMediaParameters;
		rBeltSpeedSetPoint : REAL;
		xDoubleLine : BOOL;
		iCentralOffset : INT; (*(-500, 500) Limis*)
		iCounterSetPointL1 : INT;
		iCounterSetPointL2 : INT;
		LineStatusSummary : LineControlStatusSummarized;
		Hw : FeederParametersHw_typ;
		xActiveSlaveDiagnosis : BOOL;
	END_STRUCT;
	FeederCommands_typ : 	STRUCT 
		xBelEmpty : BOOL; (*Edge commands. Reseted when managed*)
		xStart : BOOL; (*Edge commands. Reseted when managed*)
		xPrepare : BOOL; (*Edge commands. Reseted when managed*)
		xPause : BOOL; (*Edge commands. Reseted when managed*)
		xControlStop : BOOL; (*Edge commands. Reseted when managed*)
		xStop : BOOL; (*Edge commands. Reseted when managed*)
		xStartTransport : BOOL; (*Edge commands. Reseted when managed*)
		xThereIsFeeder : BOOL;
		xResetAlarms : BOOL;
		xNewBoardParameters : BOOL; (*Set 1 when there is sent a new configuration.*)
		xNewOrder : BOOL; (*New batch. Set when there is sent a new job. This signal reset the current counter*)
		xSheetFeeding : BOOL;
		xStopFeeding : BOOL; (*This signal just stop the feeding, not stop the machine*)
	END_STRUCT;
	FeederDeviceStatus_typ : 	STRUCT 
		xTurnedOff : BOOL;
		xInit : BOOL;
		xPreparing : BOOL;
		xReadyToFeed : BOOL;
		xFeeding : BOOL;
		xFaulted : BOOL;
	END_STRUCT;
	FeederStatus_typ : 	STRUCT 
		iModel : USINT := 1; (*Model of the Device*)
		Version : EFI_version_typ;
		CtrlStatus : FeederCtrlStatus_enum;
		DeviceStatus : FeederStatus_enum;
		Device : FeederDeviceStatus_typ;
		FeederType : FeederType_enum;
		Comms : FeederCommsStatus_typ;
	END_STRUCT;
	Feeder_typ : 	STRUCT 
		Inputs : FeederInputs_typ;
		Outputs : FeederOutputs_typ;
		Alarms : FeederAlarms_typ;
		ParSw : FeederParametersSw_typ;
		Parameters : FeederParameters_typ;
		Commands : FeederCommands_typ;
		Status : FeederStatus_typ;
		Orders : FeederOrders_typ;
	END_STRUCT;
	FeederPhysicalOutputs_typ : 	STRUCT 
		xPrepareToFeed : BOOL;
		xFastStop : BOOL;
		xStartFeeding : BOOL;
	END_STRUCT;
	FeederCommsOutputs_typ : 	STRUCT 
		iControl : INT; (*Status word*)
	END_STRUCT;
	FeederCommsInputs_typ : 	STRUCT 
		iNumBoardsRemainingL1 : INT; (*Recirculation of the primer enabled in the device*)
		iNumBoardsRemainingL2 : INT; (*Recirculation of the primer enabled in the device*)
		iNumFedBoards : INT;
		xOnline : BOOL; (*Recirculation of the primer enabled in the device*)
		xEnableFeeding : BOOL; (*Recirculation of the primer enabled in the device*)
		xMinimumStackLevelL1 : BOOL; (*Recirculation of the primer enabled in the device*)
		xMinimumStackLevelL2 : BOOL; (*Recirculation of the primer enabled in the device*)
		xOrderEnd : BOOL; (*Recirculation of the primer enabled in the device*)
		xPositionReady : BOOL; (*Recirculation of the primer enabled in the device*)
		xAlarmPresent : BOOL; (*Recirculation of the primer enabled in the device*)
		xRemote : BOOL; (*Recirculation of the primer enabled in the device*)
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
		iAlarmWord11 : INT; (*Status word*)
		iAlarmWord12 : INT; (*Status word*)
		iAlarmWord13 : INT; (*Status word*)
		iAlarmWord14 : INT; (*Status word*)
		iAlarmWord15 : INT; (*Status word*)
	END_STRUCT;
	FeederMediaParameters : 	STRUCT 
		rThickness : REAL; (*Tile thickness to print from gui in mm*)
		rWidth : REAL; (*Board's width in mm*)
		rGap : REAL; (*Gap between boards in mm*)
		rLength : REAL; (*Board's length in mm*)
		rOffsetRegisterL1 : REAL; (*Board's width in mm*)
		rOffsetRegisterL2 : REAL; (*Board's width in mm*)
	END_STRUCT;
	FeederCommsStatus_typ : 	STRUCT 
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
	FeederOrders_typ : 	STRUCT 
		xDisableReadBlock : BOOL;
		xDisableWriteBlock : BOOL;
	END_STRUCT;
END_TYPE
