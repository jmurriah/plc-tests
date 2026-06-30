
TYPE
	TimeStatus_enum : 
		(
		TIME_NOT_INITIALIZED,
		TIME_SETTING_TIMEZONE,
		TIME_SETTING_CLIENT,
		TIME_GETTING_TIMEDATA,
		TIME_RECEIVING_DATA,
		TIME_IDLE
		);
	CardType_enum : 
		(
		CARD_UNDEFINED,
		CARD_X1, (*First embebed card in CPU 1382*)
		CARD_X2, (*Second embebed card in CPU 1382*)
		CARD_X3, (*Third embebed card in CPU 1382*)
		CARD_CPU1382,
		CARD_CPU0483,
		CARD_CPU0484,
		CARD_DI16,
		CARD_DO16,
		CARD_AI2,
		CARD_AI4,
		CARD_AI8,
		CARD_AO2,
		CARD_AO4,
		CARD_AO8,
		CARD_AT2,
		CARD_AT4,
		CARD_PS33, (*Power Supply Card*)
		CARD_SM, (*Stepper Motor Card*)
		CARD_SC, (*Safety Card SC*)
		CARD_SL, (*Safety Card SL*)
		CARD_SI, (*Safety Input Card*)
		CARD_SO, (*Safety Output Card*)
		CARD_BC (*Coms Card*)
		);
	CardRequiredType_enum : 
		(
		CARDREQUIRED_UNDEFINED, (*Defaul value. Used to determine the end of the list*)
		CARDREQUIRED_ALWAYS,
		CARDREQUIRED_ANALOG_THICK,
		CARDREQUIRED_SENSOR_THICK,
		CARDREQUIRED_VACUUM,
		CARDREQUIRED_LED_WHITE,
		CARDREQUIRED_LED_COLOR,
		CARDREQUIRED_HEATED_TANKS,
		CARDREQUIRED_PBF
		);
	PlcCardMapping : 	STRUCT 
		Status01 : USINT;
		Status02 : USINT;
		ModuleOk : BOOL;
		DInput : ARRAY[1..MAX_LAST_SIGNAL]OF BOOL;
		DOutput : ARRAY[1..MAX_LAST_SIGNAL]OF BOOL;
		AInput : ARRAY[1..MAX_LAST_SIGNAL]OF INT;
		TempInput : ARRAY[1..MAX_LAST_SIGNAL]OF INT;
		AOutput : ARRAY[1..MAX_LAST_SIGNAL]OF INT;
		CountInput : ARRAY[1..MAX_LAST_SIGNAL]OF UINT;
		ShowTexts : BOOL;
	END_STRUCT;
	StSiUnit : 	STRUCT 
		ModuleOk : BOOL;
		NodeStatus : UINT;
		Input01_08 : USINT;
		Input09_16 : USINT;
		Input17_24 : USINT;
		Input25_32 : USINT;
		Output01_08 : USINT;
		Output09_16 : USINT;
		Output17_24 : USINT;
		Output25_32 : USINT;
	END_STRUCT;
	StSiUnitPwrLnk : 	STRUCT 
		ModuleOk : BOOL;
		NodeStatus : UINT;
		Input01_16 : UINT;
		Input17_32 : UINT;
		Input33_48 : UINT;
		Input49_64 : UINT;
		Output01_16 : UINT;
		Output17_32 : UINT;
		Output33_48 : UINT;
		Output49_64 : UINT;
	END_STRUCT;
	MachineAutoLocation_enum : 
		(
		MACHLOC_UNDEFINED,
		MACHLOC_LOCAL,
		MACHLOC_REMOTE
		);
	UPS_Inputs : 	STRUCT 
		xPowerFault : BOOL;
		xByPass : BOOL;
		xLowBattery : BOOL;
		xSystemFault : BOOL;
		xInverterFailure : BOOL;
		xGeneralAlarm : BOOL;
		xUtilityFailure : BOOL;
		LoadOnUtility : BOOL;
		LoadOnBattery : BOOL;
	END_STRUCT;
	plcVersion : 	STRUCT 
		iVersion0 : UINT;
		iVersion1 : UINT;
		iVersion2 : UINT;
		iVersion3 : UINT;
	END_STRUCT;
	TestExecution : 	STRUCT 
		xSimMachine : BOOL; (*Active if the current machine is simulated and tests are enabled*)
		xAnyTestActive : BOOL;
		TestName : STRING[80];
		iTestState : USINT;
		TestStateDesctiption : STRING[80];
		testPassedAsserts : UDINT;
		testFailedAsserts : UDINT;
		xSometestFailedAsserts : BOOL;
	END_STRUCT;
	TimeMachineParameters : 	STRUCT 
		UTCTimeZone : INT; (*Define the UTC time zone of the allocation*)
		DayLightSavingsTime : BOOL; (*Define if the DayLight saving time is active in the allocation*)
	END_STRUCT;
	TimeMachineStatus : 	STRUCT 
		LastError : UINT;
		SwState : UINT;
		TimeUpdated : BOOL; (*Time updated by the NtpServer*)
	END_STRUCT;
	TimeMachine : 	STRUCT 
		Params : TimeMachineParameters;
		State : TimeStatus_enum;
		Status : TimeMachineStatus;
	END_STRUCT;
	PLCCardDataTexts : 	STRUCT 
		Details : STRING[80]; (*Content related*)
	END_STRUCT;
	PLCCardDataStatus : 	STRUCT 
		ViewTexts : ARRAY[0..16]OF BOOL; (*Active if there are text assigned*)
		Content : STRING[80]; (*Content related*)
	END_STRUCT;
	PLCCardData : 	STRUCT 
		pCard : UDINT; (*Pointer to the card*)
		stCardName : STRING[80]; (*Caed name to show in diagnostic*)
		Type : CardType_enum := CARD_UNDEFINED; (*PLC Card Type*)
		RequiredForFunctions : ARRAY[0..MAX_LAST_REQUIRED_FUNCTION_CARD]OF CardRequiredType_enum := [4(CARDREQUIRED_UNDEFINED)];
		Texts : ARRAY[0..16]OF PLCCardDataTexts; (*Element 0 is not used*)
		Status : PLCCardDataStatus;
		Location : PLCCardLocation;
	END_STRUCT;
	PLCCardLocation : 
		(
		CardInPDC,
		CardInPrinter
		);
END_TYPE
