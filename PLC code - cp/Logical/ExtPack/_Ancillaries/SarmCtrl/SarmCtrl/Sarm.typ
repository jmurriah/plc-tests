
TYPE
	SarmCtrlStatus_enum : 
		(
		SARMCTRL_STOPPED,
		SARMCTRL_STOPPING,
		SARMCTRL_STARTING,
		SARMCTRL_RUNNING,
		SARMCTRL_PAUSING,
		SARMCTRL_PAUSED,
		SARMCTRL_CONTROLSTOPPING
		);
	SarmStatus_enum : 
		(
		Sarm_TURNED_OFF,
		Sarm_INIT,
		Sarm_PREPARING,
		Sarm_READY,
		Sarm_FAKESTATE,
		Sarm_FAULTED
		);
	SarmType_enum : 
		(
		SARMTY_UNDEFINED,
		SARMTY_V1
		);
	SarmInputs_typ : 	STRUCT 
		xRunning : BOOL;
		xError : BOOL;
		xModelInput : ARRAY[0..2]OF BOOL;
		xPowered : BOOL;
		xSarmPresent : BOOL;
		Comms : SarmCommsInputs_typ;
	END_STRUCT;
	SarmOutputs_typ : 	STRUCT 
		xFastStop : BOOL;
		xStartTransport : BOOL;
		Comms : SarmCommsOutputs_typ;
	END_STRUCT;
	SarmAlarms_typ : 	STRUCT 
		xError : BOOL;
		xNotRemote : BOOL;
		xAnyAlarm : BOOL;
		xNoPowered : BOOL;
		xCriticalAlarm : BOOL;
		xWarningAlarm : BOOL;
		xCommsError : BOOL;
	END_STRUCT;
	SarmParametersSw_typ : 	STRUCT 
		xEnabled : BOOL;
		xBatchFeeding : BOOL; (*1:Batch feeding mode; 0: continuous feeding.*)
		iCentralOffset : INT; (*Offset value received from SW for Sarms with Parameters.Hw.xOffsetAvailable = TRUE;*)
	END_STRUCT;
	SarmParametersHw_typ : 	STRUCT 
		iMaxMediaWidth : UINT; (*Maximum media width allowed in mm*)
		iMinMediaWidth : UINT; (*Minimum media width allowed in mm*)
		iMinMediaLength : UINT; (*Minimum media length allowed in mm*)
		iMaxMediaLength : UINT; (*Maximum media length allowed in mm*)
		iMaxOffset : UINT; (*Upper limit for line alignment offset value [mm]*)
		iMinOffset : INT; (*Lower limit for line alignment offset value [mm]*)
		iMinMediaThickness : UINT; (*Minimum media height allowed in tenth of mm*)
		iMaxMediaThickness : UINT; (*Maximum media height allowed in tenth of mm*)
		rSarmLength : REAL; (*Length in mm*)
		rMaxSpeed : REAL := 60.0; (*Maximum speed allowed in m/min*)
		xDoubleLineAllowed : BOOL; (*Active when allows double line printing*)
	END_STRUCT;
	SarmParameters_typ : 	STRUCT 
		xInstalled : BOOL;
		xSimulationMode : BOOL; (*Defined by the configuration in Automation Studio*)
		xCommsOK : BOOL;
		LineState : LineStatus_enum;
		xLineInAuto : BOOL;
		Media : SarmMediaParameters;
		xDoubleLine : BOOL;
		Hw : SarmParametersHw_typ;
		xActiveSlaveDiagnosis : BOOL;
		xPreviousDeviceEmpty : BOOL;
		rMediaLength : REAL; (*Length in mm*)
		rSpeedSetPoint : REAL; (*Speed in m/min*)
		iLineConfig : UINT;
	END_STRUCT;
	SarmCommands_typ : 	STRUCT 
		xBelEmpty : BOOL; (*Edge commands. Reseted when managed*)
		xStart : BOOL; (*Edge commands. Reseted when managed*)
		xPause : BOOL; (*Edge commands. Reseted when managed*)
		xControlStop : BOOL; (*Edge commands. Reseted when managed*)
		xStop : BOOL; (*Edge commands. Reseted when managed*)
		xResetAlarms : BOOL;
		xNewBoardParameters : BOOL; (*Set 1 when there is sent a new configuration.*)
		xNewOrder : BOOL; (*New batch. Set when there is sent a new job. This signal reset the current counter*)
	END_STRUCT;
	SarmDeviceStatus_typ : 	STRUCT 
		xTurnedOff : BOOL;
		xInit : BOOL;
		xPreparing : BOOL;
		xReady : BOOL;
		xFaulted : BOOL;
	END_STRUCT;
	SarmStatus_typ : 	STRUCT 
		iModel : USINT := 1; (*Model of the Device*)
		Version : EFI_version_typ;
		CtrlStatus : SarmCtrlStatus_enum;
		DeviceStatus : SarmStatus_enum;
		Device : SarmDeviceStatus_typ;
		SarmType : SarmType_enum;
		Comms : SarmCommsStatus_typ;
		xInstalled : BOOL;
		xBeltEmpty : BOOL;
	END_STRUCT;
	Sarm_typ : 	STRUCT 
		Inputs : SarmInputs_typ;
		Outputs : SarmOutputs_typ;
		Alarms : SarmAlarms_typ;
		ParSw : SarmParametersSw_typ;
		Parameters : SarmParameters_typ;
		Commands : SarmCommands_typ;
		Status : SarmStatus_typ;
		Orders : SarmOrders_typ;
	END_STRUCT;
	SarmCommsOutputs_typ : 	STRUCT 
		iControl : INT; (*Status word*)
	END_STRUCT;
	SarmCommsInputs_typ : 	STRUCT 
		xSafetyOnline : BOOL;
		xOnline : BOOL; (*Recirculation of the Sarm enabled in the device*)
		xPositionReady : BOOL; (*Recirculation of the Sarm enabled in the device*)
		xWarningPresent : BOOL; (*Recirculation of the Sarm enabled in the device*)
		xAlarmPresent : BOOL; (*Recirculation of the Sarm enabled in the device*)
		xRemote : BOOL; (*Recirculation of the Sarm enabled in the device*)
		xBeltEmpty : BOOL;
		iVersion1 : INT; (*Machine platform (Nozomi = 1)*)
		iVersion2 : INT; (*Machine project (C18000 = 0 / C14000 = 1)*)
		iVersion3 : INT; (*Hardware version*)
		iVersion4 : INT; (*Sotfware version*)
		iStatus : INT; (*Status word*)
		iAlarmWord1 : INT; (*Status word*)
		iAlarmWord2 : INT; (*Status word*)
		iAlarmWord3 : INT; (*Status word*)
	END_STRUCT;
	SarmMediaParameters : 	STRUCT 
		rThickness : REAL; (*Tile thickness to print from gui in mm*)
		rWidth : REAL; (*Board's width in mm*)
		rGap : REAL; (*Gap between boards in mm*)
		rLength : REAL; (*Board's length in mm*)
		rOffsetRegisterL1 : REAL; (*Board's width in mm*)
		rOffsetRegisterL2 : REAL; (*Board's width in mm*)
	END_STRUCT;
	SarmCommsStatus_typ : 	STRUCT 
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
		xBeltEmpty : BOOL;
	END_STRUCT;
	SarmOrders_typ : 	STRUCT 
		xDisableReadBlock : BOOL;
		xDisableWriteBlock : BOOL;
	END_STRUCT;
END_TYPE
