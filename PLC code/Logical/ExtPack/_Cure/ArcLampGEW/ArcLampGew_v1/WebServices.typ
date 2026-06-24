
TYPE
	CommsCommands : 	STRUCT 
		xReadAlerts : BOOL;
		xReadLamps : BOOL;
		xReadLampsUv : BOOL;
		xReadSystem : BOOL;
		xResetAll : BOOL;
		xSelectLamp : BOOL;
		xDeSelectLamp : BOOL;
		xStopSelected : BOOL;
		xStartSelected : BOOL;
		xDeselectAll : BOOL;
		xSetPower : BOOL;
	END_STRUCT;
	AlertDetailsResp : 	STRUCT 
		AlertCode : STRING[80];
		AlertNumber : UDINT;
		IsFault : BOOL;
		IsWarning : BOOL;
	END_STRUCT;
	LampAlertsResp : 	STRUCT 
		NodeAddress : UINT;
		Alerts : ARRAY[0..8]OF AlertDetailsResp;
		AlertCount : USINT;
	END_STRUCT;
	AlertsLampResp : 	STRUCT 
		Lamp1 : LampAlertsResp;
		Lamp2 : LampAlertsResp;
	END_STRUCT;
	LampResp : 	STRUCT 
		NodeAddress : UINT;
		UnitInternalState : STRING[80];
		LampPowerPercent : UINT;
		LampPower : UINT;
		PressImpression : BOOL;
		PressSpeed : UINT;
		IsSelected : BOOL;
		AlertCount : USINT;
	END_STRUCT;
	AllLampsResp : 	STRUCT 
		Success : BOOL;
		Lamp1 : LampResp;
		Lamp2 : LampResp;
	END_STRUCT;
	UvLampResp : 	STRUCT 
		NodeAddress : UINT;
		UnitInternalState : STRING[80];
		LampPowerPercent : UINT;
		LampPower : UINT; (*Watts*)
		PressImpression : BOOL;
		PressSpeed : UINT; (*%*)
		IsSelected : BOOL;
		AlertCount : USINT;
		Sensor1Raw : USINT; (*100x mW/cm2*)
		Sensor2Raw : USINT; (*100x mW/cm2*)
		Sensor3Raw : USINT; (*100x mW/cm2*)
		Sensor4Raw : USINT; (*100x mW/cm2*)
		Sensor5Raw : USINT; (*100x mW/cm2*)
		Sensor6Raw : USINT; (*100x mW/cm2*)
		Sensor7Raw : USINT; (*100x mW/cm2*)
		Sensor8Raw : USINT; (*100x mW/cm2*)
	END_STRUCT;
	UvStatusResp : 	STRUCT 
		Lamp1 : UvLampResp;
		Lamp2 : UvLampResp;
	END_STRUCT;
	SystemResp : 	STRUCT 
		RequestURL : STRING[80];
		CurrentDateTime : STRING[80];
		ResponseID : UDINT;
		Success : BOOL;
		ExecutionTime : UDINT;
		SystemSerial : STRING[80];
		SystemDescription : STRING[80];
		CurrentSoftware : STRING[80];
	END_STRUCT;
	HTTP_CLIENT_ERROR_SOURCE : 
		(
		HTTPERROR_UNDEFINED,
		HTTPERROR_FUNCTION,
		HTTPERROR_RESPONSE_NODATA,
		HTTPERROR_EMPTYDATA,
		HTTPERROR_TIMEOUT,
		HTTPERROR_PARSINGERROR
		);
	ErrorWebServiceData : 	STRUCT 
		Status : UINT;
		HttpStatus : UINT;
		Phase : UINT;
		Response : STRING[6000];
		Source : HTTP_CLIENT_ERROR_SOURCE;
		Time : TIME;
	END_STRUCT;
END_TYPE
