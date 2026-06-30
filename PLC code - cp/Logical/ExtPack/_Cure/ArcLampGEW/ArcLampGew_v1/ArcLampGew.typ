
TYPE
	ArcLampGew_SubComms : 
		(
		ARCLGS_IDLE,
		ARCLGS_SEND_GET_DATA,
		ARCLGS_SEND_POST_DATA,
		ARCLGS_PARSE_DATA
		);
	ArcLampGew_Comms : 
		(
		ARCLG_IDLE,
		ARCLG_GET_SYSTEM,
		ARCLG_GET_LAMPS,
		ARCLG_GET_LAMPS_UV,
		ARCLG_GET_ALERTS,
		ARCLG_RESET_ALL,
		ARCLG_STOP_SELECTED,
		ARCLG_START_SELECTED,
		ARCLG_SELEC_LAMP,
		ARCLG_DESELEC_LAMP,
		ARCLG_DESELEC_ALL,
		ARCLG_SET_POWER
		);
	ArcLampGew_State : 
		(
		ARCLGEW_NOT_INITIALIZED,
		ARCLGEW_INITIALIZING,
		ARCLGEW_IDLE,
		ARCLGEW_SELECTING,
		ARCLGEW_SET_PARAMS,
		ARCLGEW_SEND_START,
		ARCLGEW_STARTING,
		ARCLGEW_READY,
		ARCLGEW_RUNNING,
		ARCLGEW_SEND_STOP,
		ARCLGEW_DESELEC,
		ARCLGEW_ERROR,
		ARCLGEW_COMMS_ERROR
		);
	ArcLampGew_LampStatus : 	STRUCT 
		NodeAddress : UINT;
		UnitInternalState : STRING[80];
		LampPowerPercent : REAL;
		LampPower : REAL; (*Watts*)
		PressImpression : BOOL;
		PressSpeed : UINT; (*%*)
		IsSelected : BOOL;
		AlertCount : USINT;
		xDrying : BOOL;
		InAlarm : BOOL;
		SensorEmission : ARRAY[0..8]OF UINT; (*0 not used. W/cm2*)
		Enabled : BOOL;
	END_STRUCT;
	ArcLampGew_LampParameters : 	STRUCT 
		Enable : BOOL;
	END_STRUCT;
	ArcLampGew_Parameters : 	STRUCT 
		StateMode : enumEFI_GenMachineState; (*commands to block*)
		AutoMode : stEFI_MachineAutoModes;
		xInstalled : BOOL;
		xEnableArcLamp : BOOL;
		xDisableComms : BOOL; (*Just for Simulation. Comms can be desabled just in Simulation. Always running in machine*)
		CpuFamily : USINT;
		iLampQuantity : USINT; (*Total quantity of lamps installed in the machine*)
		iPowerPerc : USINT; (*Power in Percentage*)
		rBeltSpeed : REAL; (*Current speed of the belt*)
		xBeltRunning : BOOL; (*Belt is running and starting is allowed*)
		Lamps : ARRAY[0..MAX_LAST_GEW_ARCLAMPS]OF ArcLampGew_LampParameters;
		SerialNumber : STRING[80]; (*Serial number of the Rhino*)
		PIN : STRING[80]; (*Pin to communicate with the API*)
	END_STRUCT;
	ArcLampGew_CommsAlarms : 	STRUCT 
		xServerError : BOOL;
		xCredentialsError : BOOL;
	END_STRUCT;
	ArcLampGew_Alarms : 	STRUCT 
		xCommsError : BOOL;
		xJam : BOOL; (*EFI Sensor*)
		Comms : ArcLampGew_CommsAlarms;
	END_STRUCT;
	ArcLampGew_Commands : 	STRUCT 
		xPrepare : BOOL; (*EDGE*)
		xStart : BOOL; (*EDGE*)
		xStop : BOOL; (*EDGE*)
		xMediaInside : BOOL;
		xReset : BOOL;
		xMute : BOOL;
		xExternalSafetyStop : BOOL; (*External Safety Stop order*)
		InternalComms : CommsCommands;
	END_STRUCT;
	ArcLampGew_SignalsIn : 	STRUCT 
		xReady : BOOL;
		xFault : BOOL; (*Any error in the enabled alarms*)
		xJam : BOOL; (*EFI sensor*)
	END_STRUCT;
	ArcLampGew_SignalsOut : 	STRUCT 
		xImpression : BOOL;
		xSafetyStop : BOOL; (*Any error in the enabled alarms*)
		iBeltSpeed : INT; (*Current speed of the belt*)
	END_STRUCT;
	ArcLampGew_Signals : 	STRUCT 
		In : ArcLampGew_SignalsIn;
		Out : ArcLampGew_SignalsOut; (*Any error in the enabled alarms*)
	END_STRUCT;
	ArcLampGew_Status : 	STRUCT 
		xInstalled : BOOL; (*The system is or can be installed*)
		xDrying : BOOL; (*Summary information. State == RUNNING*)
		xEnabledArcLamp : BOOL;
		xAnyLampSelected : BOOL;
		xAnyLampInError : BOOL; (*Any error in the enabled alarms*)
		Lamps : ARRAY[0..MAX_LAST_GEW_ARCLAMPS]OF ArcLampGew_LampStatus;
		CommsStatus : ArcLampGew_Comms;
	END_STRUCT;
	ArcLampGew : 	STRUCT 
		Parameters : ArcLampGew_Parameters;
		State : ArcLampGew_State := ARCLGEW_NOT_INITIALIZED;
		Alarms : ArcLampGew_Alarms;
		AlSummary : stEFI_AlarmSummary;
		Commands : ArcLampGew_Commands;
		Signals : ArcLampGew_Signals;
		Status : ArcLampGew_Status;
	END_STRUCT;
END_TYPE
