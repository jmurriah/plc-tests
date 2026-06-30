
TYPE
	JamVibrationStatus_enum : 
		(
		JAMVIB_NOT_INSTALLED,
		JAMVIB_NOT_INIT,
		JAMVIB_TESTING,
		JAMVIB_WORKING,
		JAMVIB_WAITING
		);
	JamTestingStatus_enum : 
		(
		JAMVIBT_INIT,
		JAMVIBT_ACTIVATE_SIGNAL,
		JAMVIBT_WAITING_TO_CHECK,
		JAMVIBT_CHECKING,
		JAMVIBT_GO_NEXT
		);
	JamDetectInputs_typ : 	STRUCT 
		xJamCrash : ARRAY[0..4]OF BOOL; (*Crash Bar Signal*)
		xJamTestOk : BOOL; (*Jam detection test has failed signal*)
		xJamLowCrash : BOOL; (*Low level crash device signal*)
	END_STRUCT;
	JamDetectOutputs_typ : 	STRUCT 
		xJamTestSignal : ARRAY[0..4]OF BOOL; (*Jam test output signal*)
	END_STRUCT;
	JamDetectAlarms_typ : 	STRUCT 
		xAlrJamCrash : ARRAY[0..4]OF BOOL; (*Alarm Stop, Crash in bar has detected*)
		xAlrJamTest : ARRAY[0..4]OF BOOL; (*Alarm Stop, Test has failed*)
		xAlrJamLowCrash : BOOL; (*Alarm Warning, low level crash detected in unknow bar*)
	END_STRUCT;
	JamDetectParameters_typ : 	STRUCT 
		xJamEnabled : BOOL; (*Jam detection has enabled*)
		iMappingJam : INT; (*Physical mapping of the JamDevice*)
		iBlock : USINT; (*Block where the JamDevice is installed*)
		iMappingBarPos : ARRAY[0..MAX_LAST_JAMSENSOR]OF USINT; (*Physical Mapping Bar Position of the sensor*)
		xBarInstalled : ARRAY[0..MAX_LAST_JAMSENSOR]OF BOOL; (*Bar Installed*)
		iSensorsQuantity : USINT; (*Number of bars controlled by module*)
		xDisableTest : BOOL; (*Disables the JAMVIB_TESTING step*)
		iLowJamTimes : ARRAY[0..1]OF USINT; (*Number of rise edges of xJamLowCrash to show alarm*)
		iLowJamCheckDuration : ARRAY[0..1]OF TIME; (*Period of time to check consecutive xJamLowCrash rise edges to show alarm*)
		xDisableLowJamAlarm : BOOL; (*Low level jam detection alarm disabled*)
	END_STRUCT;
	JamDetectCommands_typ : 	STRUCT 
		xReset : BOOL; (*Reset signal*)
		xMuteAlarms : BOOL; (*Mute alarms signal*)
		xStart : BOOL; (*Do the test and check*)
		xPause : BOOL; (*Jam pause comand, belt stop, bars in print and block in auto*)
	END_STRUCT;
	JamDetect_typ : 	STRUCT 
		Inputs : JamDetectInputs_typ;
		Outputs : JamDetectOutputs_typ;
		Alarms : JamDetectAlarms_typ;
		Status : JamVibrationStatus_enum;
		Parameters : JamDetectParameters_typ;
		Commands : JamDetectCommands_typ;
		AlSummary : stEFI_AlarmSummary;
	END_STRUCT;
	JamPerBar_typ : 	STRUCT 
		iJamDevice : USINT;
		iJamSensor : USINT;
		xAlrJamCrash : BOOL;
		xAlrJamTest : BOOL;
		xAlrLowJamCrash : BOOL; (*Low level jam detection from jam device*)
	END_STRUCT;
END_TYPE
