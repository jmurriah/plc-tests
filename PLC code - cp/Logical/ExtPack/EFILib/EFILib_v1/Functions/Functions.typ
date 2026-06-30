
TYPE
	stPIDParam : 	STRUCT 
		rKp : REAL;
		rTi : REAL;
		rKd : REAL;
		rTd : REAL;
		zFree : ARRAY[0..4]OF USINT;
	END_STRUCT;
	StPLC_Internal : 	STRUCT 
		Blink_1s : Blink;
		Blink_2s : Blink;
		Blink_5s : Blink;
		Blink_10s : Blink;
		Blink_100ms : Blink;
		Blink_200ms : Blink;
		Blink_500ms : Blink;
		RestartInfo : RTInfo;
	END_STRUCT;
	StPLC : 	STRUCT 
		xBlk_100ms : BOOL;
		xBlk_200ms : BOOL;
		xBlk_500ms : BOOL;
		xBlk_1s : BOOL;
		xBlk_2s : BOOL;
		xBlk_5s : BOOL;
		xBlk_10s : BOOL;
		xColdRestart : BOOL;
		xWarmRestart : BOOL;
		xDownloadRestart : BOOL;
		xFirst_Scan : BOOL;
		iZero : USINT;
		diCycleTime : UDINT := 0; (*Cycle time in microseconds*)
		iVarsVersion0 : UINT;
		iVarsVersion1 : UINT;
		iVarsVersion2 : UINT;
		iVarsVersion3 : UINT;
		iVersion0 : UINT;
		iVersion1 : UINT;
		iVersion2 : UINT;
		iVersion3 : UINT;
		sVersion : STRING[20];
		sLastPlcProgrammer : STRING[20];
		Internal : StPLC_Internal;
	END_STRUCT;
END_TYPE
