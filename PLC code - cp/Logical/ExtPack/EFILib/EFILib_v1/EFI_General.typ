
TYPE
	stEFI_AlarmSummary : 	STRUCT 
		xAlrSafetySystemGeneral : BOOL;
		xAnyWarning : BOOL;
		xAnyAlarm : BOOL;
		xAlarmCritical : BOOL; (*Out of Auotmatic Mode*)
		xAlarmStop : BOOL;
		xAlarmNonReseteable : BOOL;
		xAlarmReseteable : BOOL;
		xAlarmSound : BOOL;
		iReasonStop : ARRAY[0..1]OF UDINT; (*The reason to move the machine to stop*)
		iReasonWarning : UDINT;
		iReasonCritical : UDINT; (*The reason to move the machine out of auto mode*)
		CurrentReasonStop : ARRAY[0..1]OF UDINT; (*The reason to move the machine to stop*)
		CurrentReasonCritical : UDINT; (*The reason to move the machine out of auto mode*)
		xAlrSafetyCutAir : BOOL; (*Summary alarms to cut the air*)
	END_STRUCT;
	enumEFI_GenMachineState : 
		(
		PRINTERGEN_MANUAL,
		PRINTERGEN_ZERO,
		PRINTERGEN_AUTO,
		PRINTERGEN_STARTUP
		);
	enumEFI_MachineState : 
		(
		PRINTER_NOT_CLEANING,
		PRINTER_PRINTING,
		PRINTER_CAPPED,
		PRINTER_GOING_TO_CAP,
		PRINTER_GOING_TO_PRINT,
		PRINTER_CLEANING
		);
	enumEFI_MachineAutoStatesMode : 
		(
		AUTO_NOT_VALID,
		AUTO_PRODUCTION,
		AUTO_BYPASS,
		AUTO_STOP,
		AUTO_LABORATORY,
		AUTO_JAMRECOVERY
		);
	enumEFI_SafetySignals : 
		(
		SAFETY_ESTOP_CONNECTED,
		SAFETY_ESTOP_CALCULATED
		);
	stEFI_MachineAutoModes : 	STRUCT 
		xLaboratory : BOOL; (*Laboratory Mode*)
		xStop : BOOL; (*Stop Mode*)
		xProduction : BOOL; (*Production/AutoRun Mode*)
		xBypass : BOOL; (*Bypass Mode*)
		xPause : BOOL; (*Pause Mode*)
		xJamRecovery : BOOL; (*JamRecovery Mode*)
		xProdORByPass : BOOL; (*Combined BOOL to better reading. Production OR ByPass Mode*)
		xProdORLab : BOOL; (*Combined BOOL to better reading. Production OR Laboratory Mode*)
	END_STRUCT;
	MotorDirection_enum : 
		(
		MOTOR_POSITIVE := 0, (*This is the value expected in AxisCtrl. 0 for Postive*)
		MOTOR_NEGATIVE := 1 (*This is the value expected in AxisCtrl. 1 for Negative*)
		);
	LineStatus_enum : 
		(
		LINE_NOT_POWERED, (*This is the starting state when starting to allow StatusChange to be receptive*)
		LINE_ERROR,
		LINE_PREPARING_EMPTYBELT,
		LINE_PREPARING_PRINT,
		LINE_PREPARING_CLEANPH,
		LINE_PREPARING_CLEANBELT,
		LINE_STARTING_PRINTING,
		LINE_STARTING_CLEANINGPH,
		LINE_STARTING_CLEANINGBELT,
		LINE_BELT_EMPTYING,
		LINE_CLEANED,
		LINE_STARTING_EMPTYBELT,
		LINE_IDLE,
		LINE_PRINTING,
		LINE_PAUSING,
		LINE_PAUSED,
		LINE_CLEANINGPH,
		LINE_CLEANINGBELT,
		LINE_CONTROLLED_STOP,
		LINE_STOPPED,
		LINE_NOT_INITIALIZED,
		LINE_INITIALIZING,
		LINE_POWERING_OFF
		);
	EFI_version_typ : 	STRUCT 
		iVersion0 : INT;
		iVersion1 : INT;
		iVersion2 : INT;
		iVersion3 : INT;
	END_STRUCT;
	CommsNetworkType_enum : 
		(
		COMMS_UNDEFINED,
		COMMS_POWERLINK,
		COMMS_CANOPEN
		);
	CanOpenResetCommsState_enum : 
		(
		COCOMSR_UNDEFINED,
		COCOMSR_COMMUNICATING,
		COCOMSR_COMMSERROR,
		COCOMSR_RESETTING,
		COCOMSR_WAITINGTOBERESETTED,
		COCOMSR_RESETTING_ERROR
		);
	StGeneral_States_Mode : 	STRUCT 
		xManual : {REDUND_UNREPLICABLE} BOOL; (*State to define Manual Mode*)
		xZero : BOOL; (*State to define Zero Mode*)
		xAuto : BOOL; (*State to define Auto Mode*)
		xStartUp : BOOL; (*State to define StartUp Mode*)
	END_STRUCT;
	LineControlStatusSummarized : 	STRUCT 
		xLineEmpty : BOOL;
		xIdle : BOOL;
		xStopped : BOOL;
		xControlStopping : BOOL;
		xErrorStopping : BOOL;
		xCleaning : BOOL;
		xEmptyingBelts : BOOL;
		xPausing : BOOL;
		xCleaningBelt : BOOL;
		xPrinting : BOOL;
	END_STRUCT;
	InvType_enum : 
		(
		INV_BR,
		INV_ABB
		);
	OpcUaCommsState : 
		(
		OPCUA_IDLE,
		OPCUA_CONNECTING,
		OPCUA_GETTING_NAMESPACE,
		OPCUA_GETTING_HANDLE,
		OPCUA_EXECUTING,
		OPCUA_PAUSED,
		OPCUA_RELEASINSG_HANDLE,
		OPCUA_DISCONNECTING,
		OPCUA_FAULTED
		);
	SimDryerType : 
		(
		SIM_DRYER_NOZ2_NIR_ARCLAMP := 1,
		SIM_DRYER_NOZ2_NIR := 2
		);
	ChillerStatus_enum : 
		(
		CHILLER_OFF,
		CHILLER_STARTING,
		CHILLER_RUNNING,
		CHILLER_STOPPING,
		CHILLER_FAULT
		);
END_TYPE
