
TYPE
	CuringLedCheck_enum : 
		(
		CHECK_INIT,
		CHECK_READ_CONFIG,
		CHECK_UPDATE_STATUS,
		CHECK_READY,
		CHECK_ERROR
		);
	CuringLedReadingLampUvTime_enum : 
		(
		READINGUVTIME_NOT_INIT,
		READINGUVTIME_INIT,
		READINGUVTIME_READING,
		READINGUVTIME_READY,
		READINGUVTIME_ERROR
		);
	CuringLedReadingLampTemp_enum : 
		(
		READINGTEMP_NOT_INIT,
		READINGTEMP_INIT,
		READINGTEMP_READING,
		READINGTEMP_READY,
		READINGTEMP_ERROR
		);
	CuringLedDetect_enum : 
		(
		DETECTION_NOT_INIT,
		DETECTION_INIT,
		DETECTION_POLLING,
		DETECTION_SAVE_SERIAL_NUMBERS,
		DETECTION_FINISHING_POLLING,
		DETECTION_READ_INTENSITY,
		DETECTION_ASSIGN_POSITION,
		DETECTION_READY,
		DETECTION_ERROR
		);
	CuringLedConfig_enum : 
		(
		CONFIGURATION_NOT_INIT,
		CONFIGURATION_INIT,
		CONFIGURATION_PREPARE_LAMP,
		CONFIGURATION_PREPARE_SLM,
		CONFIGURATION_SEND,
		CONFIGURATION_SENDING,
		CONFIGURATION_SENT,
		CONFIGURATION_READ,
		CONFIGURATION_READY
		);
	CuringLedStatus_enum : 
		(
		CURINGLED_OFF,
		CURINGLED_INIT,
		CURINGLED_PREPARING,
		CURINGLED_READY,
		CURINGLED_EMITTING,
		CURINGLED_FAULTED
		);
	CuringLed_NitrogenStatus_enum : 
		(
		CURINGNITRO_OFF,
		CURINGNITRO_INIT,
		CURINGNITRO_READY,
		CURINGNITRO_FAULT
		);
	CuringLed_ApplicationType_enum : 
		( (*Defines application purpose of curing led. May be use to cure ink (white, color) or primer*)
		CURING_APP_UNDEFINED,
		CURING_APP_WHITE, (*White ink*)
		CURING_APP_COLOR, (*Any ink apart from white*)
		CURING_APP_PRIMER (*Varnish*)
		);
	CuringLed_Alarms_typ : 	STRUCT 
		xChillerFaulted : BOOL;
		xN2HighFlow : BOOL;
		xN2LowFlow : BOOL;
		xCureSystemFaulted : BOOL; (*gui_q_xAlrOverallCureSystFaulted*)
		xLampsSlmNotConfigured : BOOL;
		xFrontDoorOpened : BOOL; (*Front door is opened. UV light is dangerous*)
		xPowerFailure : BOOL; (*Any power suppliy dc voltage has failed*)
		xSerialNumbersRepeated : BOOL; (*Some lamps has same serial number*)
		xSerialNumbersNotAssigned : BOOL; (*Any lamp has no serial number assigned*)
		xDetectionProcessFailed : BOOL; (*Serial number detection process has failed*)
		Lamps : ARRAY[0..MAX_LAST_CURING_LED_LAMP]OF CuringLed_Lamp_Alarms_typ;
	END_STRUCT;
	CuringLed_Lamp_Alarms_typ : 	STRUCT 
		SLMFault : BOOL; (*SLM fault present on LED cure lamp*)
		ThermalFault : BOOL; (*Thermal fault present on LED cure lamp*)
		AnyWarning : BOOL; (*Warning if there is any not needed lamp in error.*)
		StatusFeedbackFault : BOOL; (*Slm status feedback from lamp missing in system status message*)
		xSlmWrongConfiguration : ARRAY[0..20]OF BOOL; (*SLM not configured properly*)
	END_STRUCT;
	CuringLed_Signals_In_typ : 	STRUCT 
		xN2HighFlow : BOOL;
		xN2LowFlow : BOOL;
		xPsuDcOk : ARRAY[0..10]OF BOOL;
		xPsuAcOk : ARRAY[0..10]OF BOOL;
		xFrontDoorClosed : BOOL;
		xSafetyEnable : BOOL; (*The Enable signals are active. Do not show alarms related to this if not active*)
	END_STRUCT;
	CuringLed_Signals_Out_typ : 	STRUCT 
		xPowerOnLamps : BOOL;
		xRunChiller : BOOL; (*Chiller has just one input named "Run"*)
		xPowerOnNitrogen : BOOL;
	END_STRUCT;
	CuringLed_Signals_typ : 	STRUCT 
		Inputs : CuringLed_Signals_In_typ;
		Outputs : CuringLed_Signals_Out_typ;
	END_STRUCT;
	CuringLed_Comms_typ : 	STRUCT 
		Ready : BOOL; (*To show the status of the startup process.*)
		ConfigOK : BOOL; (*Lamps SLMs configured*)
		Command : Comms_command_typ;
		Device : DeviceComms_typ;
	END_STRUCT;
	CuringLed_Status_typ : 	STRUCT 
		xInstalled : BOOL;
		xEmitting : BOOL;
		DetectionState : CuringLedDetect_enum; (*State of the control*)
		Config : CuringLedConfig_enum; (*State of the control*)
		State : CuringLedStatus_enum; (*Status of the curing led: 0=off, 1=init, 2=ready, 3=emitting, 4=faulted*)
		NitroState : CuringLed_NitrogenStatus_enum;
		ChillerState : ChillerStatus_enum;
		iTotalNumSlms : UINT; (*Total number of slm of the curing bar*)
		xOptimizeCuring : BOOL; (*To cure just the document not the entire board*)
		xCureByStretch : BOOL; (*To configure lamps to cure by stretches*)
		xLampsDetected : BOOL; (*Active when all lamps installed have a serial number associated*)
		xLampsChecked : BOOL; (*Active when check of lamps current configuration match desired configuration*)
		xLampsConfigured : BOOL; (*Active when all lamps have been configured*)
		ManualCommands : CuringLed_ManualCommands_typ;
		iCuringAreaWidth : UINT;
		iCuringAreaOffsetL1 : INT;
		iCuringAreaOffsetL2 : INT;
	END_STRUCT;
	CuringLed_Parameters_typ : 	STRUCT 
		xInstalled : BOOL;
		xEnabled : BOOL;
		iLampsQuantity : USINT; (*Total lamps in the CuringLed system. Max 16*)
		Mode : StGeneral_States_Mode;
		AutoMode : stEFI_MachineAutoModes;
		iChillerIndex : INT; (*Index of chiller used by the curing led lamp*)
		iCuringPosition : INT; (*Position of the led lamps bar in cm*)
		iCuringWindow : INT; (*Led lamps width in process direction (in mm). Depends on lamp's model. Alll lamps on same led bar have the same*)
		iDocumentWidth : UINT;
		iDocumentOffsetL1 : INT;
		iDocumentOffsetL2 : INT;
		iMaxCuringAreaWidth : UINT;
		iMaxCuringAreaOffsetL1 : INT;
		iMaxCuringAreaOffsetL2 : INT;
		iMediaWidth : UINT;
		iMediaOffsetL1 : INT;
		iMediaOffsetL2 : INT;
		xDoubleLine : BOOL;
		rBeltCurrentSpeed : REAL;
		rMinCureSpeed : REAL := 1;
		iPowerSuppliesQuantity : USINT; (*Total power supplies used to power all lamps in the curing led bar. Max 10*)
		xWhiteLedBar : BOOL; (*To set this variable to TRUE when curing led bar is used for white color*)
		xCureBySpeed : BOOL; (*Intensity of lamps set depending on machine speed*)
		xSimulationMode : BOOL;
		xOptimizeCuring : BOOL; (*Curing optimitzation required*)
		xCureByStretch : BOOL; (*Curing by stretch mode required*)
		xPhysicalTempFeedback : BOOL; (*When a plc card is installed to read temp from lamp using an AI*)
		iMappingBar : USINT;
		iSlmWidth : USINT := 25;
		CuringApplicationType : CuringLed_ApplicationType_enum;
	END_STRUCT;
	CuringLed_ManualCommands_typ : 	STRUCT 
		xNitrogen : BOOL;
		DetectLamps : BOOL;
		ResetPSU : BOOL; (*Reset the PSU to power the Lamps*)
	END_STRUCT;
	CuringLed_Commands_typ : 	STRUCT 
		PowerOn : BOOL;
		xDropPower : BOOL; (*Command to set lamps to a lower intensity than defined by curing mode or setpoint written by SW*)
		xRunNitrogenFlow : BOOL; (*Command to active nitrogen flow*)
		xUpdateTempValues : BOOL; (*Update temp values*)
		RunCuring : BOOL; (*When the media to cure is below the lamps*)
		Mute : BOOL; (*command xMute *)
		Reset : BOOL; (*command xReset*)
		Manual : CuringLed_ManualCommands_typ;
	END_STRUCT;
	CuringLed_typ : 	STRUCT 
		Signals : CuringLed_Signals_typ;
		Commands : CuringLed_Commands_typ;
		Parameters : CuringLed_Parameters_typ;
		Status : CuringLed_Status_typ;
		Alarms : CuringLed_Alarms_typ;
		AlSummary : stEFI_AlarmSummary; (*Alarms Summary*)
		Comms : CuringLed_Comms_typ;
		Lamp : ARRAY[0..MAX_LAST_CURING_LED_LAMP]OF CuringLed_Lamp_typ;
		parSw : CuringLed_Sw_Parameters_typ;
	END_STRUCT;
	enComms_STEPS : 
		(
		FRM_WAIT := 0, (*Defines the wait step*)
		FRM_OPEN := 10, (*Defines Step for FRM_xopen() *)
		FRM_CLEAR_BUFFER := 20, (*Defines Step for FRM_rbuf()*)
		FRM_PREPARE_SENDDATA := 21, (*Defines Step for preparing send data*)
		FRM_WRITE := 22, (*Defines Step for FRM_write()*)
		FRM_RELEASE_SEND_BUFFER := 23, (*Defines Step for FRM_robuf()*)
		FRM_READ := 30, (*Defines Step for FRM_read()*)
		FRM_COPY_RD_DATA := 31, (*Defines Step for storing read data*)
		FRM_RELEASE_READ_BUFFER := 32, (*Defines Step for FRM_rbuf()*)
		FRM_CLOSE := 40, (*Defines Step for FRM_close()*)
		FRM_ERROR := 255 (*Defines Step for Errorhandling*)
		);
	Comms_command_typ : 	STRUCT 
		Open : BOOL; (*Open serial port and receive data*)
		Send : BOOL; (*Close serial port*)
		Receive : BOOL; (*Receive data from device*)
		Close : BOOL; (*Close serial port*)
	END_STRUCT;
	DeviceComms_typ : 	STRUCT 
		step : enComms_STEPS := (0); (*Step of the Statemachine*)
		receive_data : STRING[800]; (*receive data*)
		send_data : STRING[80]; (*Send data*)
		FRM_xopen_0 : FRM_xopen; (*Functionblock FRM_xopen()*)
		xopenConfig : XOPENCONFIG; (*Configuration Type for FRM_xopen()*)
		FRM_gbuf_0 : FRM_gbuf; (*Functionblock FRM_gbuf()*)
		FRM_robuf_0 : FRM_robuf; (*Functionblock FRM_robuf()*)
		FRM_read_0 : FRM_read; (*Functionblock FRM_read()*)
		FRM_rbuf_0 : FRM_rbuf; (*Functionblock FRM_rbuf()*)
		FRM_write_0 : FRM_write; (*Functionblock FRM_write)*)
		FRM_close_0 : FRM_close; (*Functionblock FRM_close()*)
		DeviceName : STRING[22]; (*Devicename --> serial interface properties*)
	END_STRUCT;
	CuringLed_Lamp_typ : 	STRUCT 
		Inputs : CuringLed_Lamp_Inputs_typ;
		Outputs : CuringLed_Lamp_Outputs_typ;
		Parameters : CuringLed_Lamp_Parameters_typ;
		Status : CuringLed_Lamp_Status_typ;
	END_STRUCT;
	CuringLed_Lamp_Status_typ : 	STRUCT 
		stUvOnTimeRaw : STRING[10]; (*Total number of minutes that DC power has been applied*)
		rUvOnTime : REAL; (*Total number of minutes that DC power has been applied*)
		rTemp : REAL;
		stSerialNumber : STRING[6];
	END_STRUCT;
	CuringLed_Lamp_Parameters_typ : 	STRUCT 
		xInstalled : BOOL := FALSE;
		EnabledByPosition : BOOL := TRUE; (*Enable lamp to be ready for curing depending on its position, board width and offsets*)
		iNumSLM : UINT; (*Number of stretches (slm) in this lamp*)
		iCuringLength : UINT; (*Length of lamp in mm. Per position in lamp's bar (length = cross direction)*)
		xSlmEnable : ARRAY[0..20]OF BOOL; (*SLM to be enabled for each lamp. 1:Must cure, 0: Must not cure*)
		xFullActive : BOOL;
		sSystemStatusFeedback : STRING[300];
		iFirstSlm : INT;
		iLastSlm : INT;
	END_STRUCT;
	CuringLed_Sw_Parameters_typ : 	STRUCT 
		IntensitySetPoint : INT; (*Value of the Intensity in percentage. Minimum 10%. gui_i_iUvIntensitySetPointLed1*)
		xEnableDDC : BOOL; (*Enable the DDC functionality*)
		iPreCuringOffset : INT := 0; (*Pre curing offset set by SW in cm*)
		iPostCuringOffset : INT := 0; (*Post curing offset set by SW in cm*)
	END_STRUCT;
	CuringLed_Lamp_Inputs_typ : 	STRUCT 
		TemperatureRaw : INT; (*Led temperature value in C.*)
		SLMFault : BOOL; (*SLM fault present on LED cure lamp 1*)
		ThermalFault : BOOL; (*Thermal fault present on LED cure lamp 1*)
	END_STRUCT;
	CuringLed_Lamp_Outputs_typ : 	STRUCT 
		IntensityLampApplied : USINT; (*Value of the real intensity setpoint applied to lamp by the PLC*)
		IntensityLampRaw : INT; (*Value of the Intensity in Analog units*)
		EnableLamp : BOOL; (*Enable for each lamp of the curing LED*)
		rTemperature : REAL; (*Lamp  temperature value in C*)
		LampErrorCode : USINT;
		xSlmStatus : ARRAY[0..20]OF BOOL; (*SLM status. Shows SLM is active to cure: 1:On, 0:Off*)
	END_STRUCT;
END_TYPE
