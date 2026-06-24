
TYPE
	DetectionMedia_Parameters : 	STRUCT 
		xInstalled : BOOL;
		xBeltMoving : BOOL; (*The belt is moving*)
		rCorrection : REAL;
		rDesiredHeigh : REAL; (*Value in mm*)
	END_STRUCT;
	DetectionMedia_Inputs : 	STRUCT 
		xMountedMedia : BOOL;
		xMediaPresentL1 : BOOL;
		xMediaPresentL2 : BOOL;
		xCorrection : BOOL;
	END_STRUCT;
	DetectionMedia_Alarms : 	STRUCT 
		xMountedMedia : BOOL;
	END_STRUCT;
	DetectionMedia_Status : 	STRUCT 
		xInstalled : BOOL;
		xMediaPresent : BOOL;
		rMediaHeigh : REAL; (*Value in mm*)
	END_STRUCT;
	DetectionMedia_Commands : 	STRUCT 
		xReset : BOOL; (*Order to reset Alarms*)
		xMute : BOOL; (*Mute Order*)
		StateMode : enumEFI_GenMachineState; (*commands to inform belt*)
		AutoMode : stEFI_MachineAutoModes; (*commands to inform belt*)
	END_STRUCT;
	DetectionMedia : 	STRUCT 
		Inputs : DetectionMedia_Inputs;
		Parameters : DetectionMedia_Parameters;
		Commands : DetectionMedia_Commands;
		Status : DetectionMedia_Status;
		Alarms : DetectionMedia_Alarms;
		AlSummary : stEFI_AlarmSummary;
	END_STRUCT;
END_TYPE
