
TYPE
	PowerMeterInputs_typ : 	STRUCT 
		Comms : PowerMeterCommsInputs_typ;
	END_STRUCT;
	stPowerMeter : 	STRUCT 
		Inputs : PowerMeterInputs_typ;
		Alarms : PowerMeterAlarms_typ;
		Status : PowerMeterStatus_typ;
		Parameters : PowerMeterParameters_typ;
		Commands : PowerMeterCommands_typ;
	END_STRUCT;
	PowerMeterCommsInputs_typ : 	STRUCT 
		EffectiveCurrentPhaseA : UINT;
		EffectiveCurrentPhaseB : UINT;
		EffectiveCurrentPhaseC : UINT;
		EffectiveCurrentNeutral : UINT;
		MaxCurrentAllPhases : UINT;
		IgEarthDefectiveCurrent : UINT;
		CurrentDifferential : UINT;
		MaxEffectiveCurrentPhaseA : UINT;
		MaxEffectiveCurrentPhaseB : UINT;
		MaxEffectiveCurrentPhaseC : UINT;
		MaxEffectiveCurrentNeutral : UINT;
		MaxIgEarthDefectiveCurrent : UINT;
		MaxCurrentDifferential : UINT;
		EffectiveVoltagePhasesAB : UINT;
		EffectiveVoltagePhasesBC : UINT;
		EffectiveVoltagePhasesCA : UINT;
		EffectiveVoltagePhasesAN : UINT;
		EffectiveVoltagePhasesBN : UINT;
		EffectiveVoltagePhasesCN : UINT;
		Frequency : UINT;
		FrequencyMax : UINT;
		ActivePowerPhaseA : INT;
		ActivePowerPhaseB : INT;
		ActivePowerPhaseC : INT;
		TotalActivePower : INT;
		ApparentPowerPhaseA : INT;
		ApparentPowerPhaseB : INT;
		ApparentPowerPhaseC : INT;
		TotalApparentPower : UINT;
		ReactivePowerPhaseA : UINT;
		ReactivePowerPhaseB : UINT;
		ReactivePowerPhaseC : UINT;
		TotalReactivePower : UINT;
		THDVoltageAB : UINT;
		THDVoltageBC : UINT;
		THDVoltageCA : UINT;
		THDVoltageAN : UINT;
		THDVoltageBN : UINT;
		THDVoltageCN : UINT;
		THDCurrentA : UINT;
		THDCurrentB : UINT;
		THDCurrentC : UINT;
		TotalTHDCurrent : UINT;
		ReceivedDataModPowerMeter : ARRAY[0..120]OF UINT;
	END_STRUCT;
	PowerMeterAlarms_typ : 	STRUCT 
		xCriticalAlarm : BOOL;
		xWarningAlarm : BOOL;
		xAnyAlarm : BOOL;
		xCommsError : BOOL;
	END_STRUCT;
	PowerMeterCommsStatus_typ : 	STRUCT 
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
	PowerMeterStatus_typ : 	STRUCT 
		Comms : PowerMeterCommsStatus_typ;
	END_STRUCT;
	PowerMeterParameters_typ : 	STRUCT 
		xInstalled : BOOL; (*The powermeter is installed in the machine*)
		xActiveSlaveDiagnosis : BOOL;
	END_STRUCT;
	PowerMeterCommands_typ : 	STRUCT 
		xMute : BOOL;
		xReset : BOOL;
	END_STRUCT;
END_TYPE
