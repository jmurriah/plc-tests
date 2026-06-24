
TYPE
	SafetyControllerOutputs_typ : 	STRUCT 
		xEnablePrinter1 : BOOL; (*OSSD*)
		xEnablePrinter2 : BOOL; (*OSSD*)
		xEnablePrinterBlowers1 : BOOL; (*OSSD*)
		xEnablePrinterBlowers2 : BOOL; (*OSSD*)
		xEnableDryer1 : BOOL; (*OSSD*)
		xEnableDryer2 : BOOL; (*OSSD*)
		xFeederToLine1 : BOOL; (*Relay*)
		xFeederToLine2 : BOOL; (*Relay*)
		xLineToFeeder1 : BOOL; (*Relay*)
		xLineToFeeder2 : BOOL; (*Relay*)
		xPrimerToLine1 : BOOL; (*Relay*)
		xPrimerToLine2 : BOOL; (*Relay*)
		xLineToPrimer1 : BOOL; (*Relay*)
		xLineToPrimer2 : BOOL; (*Relay*)
		xStackerToLine1 : BOOL; (*Relay*)
		xStackerToLine2 : BOOL; (*Relay*)
		xLineToStacker1 : BOOL; (*Relay*)
		xLineToStacker2 : BOOL; (*Relay*)
		xIRToLine1 : BOOL; (*Relay*)
		xIRToLine2 : BOOL; (*Relay*)
		xLineToIR1 : BOOL; (*Relay*)
		xLineToIR2 : BOOL; (*Relay*)
		xUVToLine1 : BOOL; (*Relay*)
		xUVToLine2 : BOOL; (*Relay*)
		xLineToUV1 : BOOL; (*Relay*)
		xLineToUV2 : BOOL; (*Relay*)
		xPrinterToX5 : BOOL; (*Relay*)
	END_STRUCT;
	SafetyControllerInputs_typ : 	STRUCT 
		Comms : SafetyControllerCommsInputs_typ;
		xPrinterLightCurtain : BOOL; (*Printer's front side light curtain feedback*)
		xPrinterRearDoorSwitch : BOOL;
		xPrinterFrontDoorSwitch : BOOL;
		xPrinterDoorLock : BOOL; (*Printer's rear side magnetic sensor feedback*)
		xPrinterBacksideEstop : BOOL;
		xPrinterFrontsideEstop : BOOL;
		xPrinterBlowersSwitch : BOOL; (*Switch to cut off blowers drive enables located inside blowers enclusure feedback*)
		xPrinterBlowersEnable : BOOL;
		xPrinterMaintenanceKey : BOOL; (*Maintenance key located in printer's rear side feedback*)
		xDryerBackDoorSwitch1 : BOOL;
		xDryerBackDoorSwitch2 : BOOL;
		xDryerFrontDoorSwitch1 : BOOL;
		xDryerFrontDoorSwitch2 : BOOL;
		xDryerMaintenanceKey : BOOL;
		xIR_SafetyAlarm : BOOL;
		xDryerBlowersEnable : BOOL;
		xDryerBacksideEstop : BOOL;
		xDryerFrontsideEstop : BOOL;
		xFeederEstop : BOOL;
		xPrimerEstop : BOOL;
		xOvervarnishEstop : BOOL;
		xStackerEstop : BOOL;
		xSarmEstop : BOOL;
		xFanDoorSwitch : BOOL;
		xHmiSwitch : BOOL;
		xX5Consent2 : BOOL;
		xX5Consent : BOOL;
	END_STRUCT;
	stSafetyController : 	STRUCT 
		Inputs : SafetyControllerInputs_typ;
		Alarms : SafetyControllerAlarms_typ;
		Outputs : SafetyControllerOutputs_typ;
		Status : SafetyControllerStatus_typ;
		Parameters : SafetyParameters_typ;
		Orders : SafetyOrders_typ;
		Commands : SafetyCommands_typ;
	END_STRUCT;
	SafetyControllerCommsInputs_typ : 	STRUCT 
		SystemStatus : USINT;
		ExpansionModule : ARRAY[0..15]OF USINT; (*Each expansion module bit is assigned to its input status at that pin*)
		FieldbusInputs : USINT;
		FieldbusProbeStatus : UINT;
		OSSDStatus : UINT;
		DiagnosticCode : UINT;
	END_STRUCT;
	SafetyControllerAlarms_typ : 	STRUCT 
		xAlrPrinterEStops : BOOL;
		xAlrPrinter : BOOL;
		xAlrDryer : BOOL;
		xAlrFeeder : BOOL;
		xAlrPrimer : BOOL;
		xAlrOverVarnish : BOOL;
		xAlrStacker : BOOL;
		xAlrSarm : BOOL;
		xCriticalAlarm : BOOL;
		xWarningAlarm : BOOL;
		xAnyAlarm : BOOL;
		xCommsError : BOOL;
		xAlrPrinterLightCurtain : BOOL;
		xAlrBlowersEnclosureSwitchOff : BOOL;
		xAlrPrinterDoorLockKeyActivated : BOOL;
		xAlrPrinterDoorLock : BOOL;
		xAlrPrinterRearDoorSwitch : BOOL;
		xAlrHmiSwitch : BOOL;
		xAlrPrinterFanDoorSwitch : BOOL;
		xAlrPrinterFrontDoorSwitch : BOOL;
		xAlrPrinterFrontEstop : BOOL;
		xAlrPrinterRearEstop : BOOL;
	END_STRUCT;
	SafetyControllerStatus_typ : 	STRUCT 
		Version : USINT;
		Comms : SafetyCommsStatus_typ;
		Type : SafetyControllerType_enum;
	END_STRUCT;
	SafetyCommsStatus_typ : 	STRUCT 
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
	SafetyParameters_typ : 	STRUCT 
		xActiveSlaveDiagnosis : BOOL;
		xInstalled : BOOL;
		xSimulationMode : BOOL; (*Defined by the configuration in Automation Studio*)
	END_STRUCT;
	SafetyOrders_typ : 	STRUCT 
		xDisableReadBlock : BOOL;
	END_STRUCT;
	SafetyCommands_typ : 	STRUCT 
		xReset : BOOL;
	END_STRUCT;
	SafetyControllerType_enum : 
		(
		SAFETYCONTROLLERTY_UNDEFINED,
		SAFETYCONTROLLERTY_DEFAULT, (*Default version installed*)
		SAFETYCONTROLLERTY_CUBE_ALPHA, (*Version for Nozomi 2 in Gulliver (first Nz2 manufactured ever) installed*)
		SAFETYCONTROLLERTY_SD, (*Version for display graphics installed*)
		SAFETYCONTROLLERTY_CUBE, (*Version for cube machine model*)
		SAFETYCONTROLLERTY_MECANO, (*Version for Mecano machine model*)
		SAFETYCONTROLLERTY_NOZ2_AQ (*Version for Nozomi 2 water*)
		);
END_TYPE
