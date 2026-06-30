
TYPE
	stTrayCmd : 	STRUCT 
		ToOut : BOOL;
		ToIn : BOOL;
		ReboundToOut : BOOL; (*The signal appears at the end but desappears just after appear*)
		ReboundToIn : BOOL; (*The signal appears at the end but desappears just after appear*)
		UnplugInSensor : BOOL; (*Command to unplug IN sensor*)
		UnplugOutSensor : BOOL; (*Command to unplug OUT sensor*)
		ResetOut : BOOL; (*EDGE Command to reset the signal. Reseted in the element*)
		ResetIn : BOOL; (*EDGE Command to reset the signal. Reseted in the element*)
	END_STRUCT;
	stTrayState : 	STRUCT 
		OutPosition : BOOL;
		InPosition : BOOL;
	END_STRUCT;
	stTraySim : 	STRUCT 
		State : stTrayState;
		Commands : stTrayCmd;
	END_STRUCT;
END_TYPE
