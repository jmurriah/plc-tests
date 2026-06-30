
TYPE
	ChillerSystemType_enum : 
		(
		CHILLERSYS_UNDEFINED,
		CHILLERSYS_DIRECT,
		CHILLERSYS_WATERMANIFOLD
		);
	StChillerAlarms : 	STRUCT 
		xNotRunning : BOOL; (*If we start chillerand dont recive the feedback*)
		xInAlarm : BOOL; (*ALarm directly from chiller*)
		xCheckChiller : BOOL; (*Alarm inform user to check chiller SP*)
		xAlrTempSensBrokn : BOOL; (*Chiller Heater Exchanger Sensor PT100 Borken or DIsconnected*)
		xAlrEnvTempSensBrokn : BOOL; (*Chiller Enviorenment Sensor PT100 Borken or DIsconnected*)
	END_STRUCT;
	StChillerOrders : 	STRUCT 
		xRun : BOOL; (*Order to Start the Chiller*)
	END_STRUCT;
	StChillerComands : 	STRUCT 
		xReset : BOOL; (*Reset Signal*)
		xMute : BOOL; (*Mute alarms sound*)
	END_STRUCT;
	StChillerStatusWaterManifold : 	STRUCT 
		rEnviromentTemp : REAL;
		rManifoldTemp : REAL;
	END_STRUCT;
	StChillerStates : 	STRUCT 
		xInstalled : BOOL; (*The system is or can be installed*)
		xEnabled : BOOL; (*The Chiller is enabled and raises alarms*)
		Status : ChillerStatus_enum;
		WaterManifold : StChillerStatusWaterManifold;
		xRunning : BOOL;
	END_STRUCT;
	StChillerSignalsOut : 	STRUCT 
		xStart : BOOL; (*Start Chiller Out*)
	END_STRUCT;
	StChillerSignalsInWaterManifold : 	STRUCT 
		iEnvironmentTempRaw : INT;
		iWaterManifoldTempRaw : INT;
		xTempEnvSensError : BOOL; (*Temperature enviorement sensor error*)
		xTempWatSensError : BOOL; (*Temperature water collector sensor error*)
	END_STRUCT;
	StChillerSignalsIn : 	STRUCT 
		xCooling : BOOL; (*Chiller is cooling/running*)
		xPowered : BOOL; (*Chiller is powered on*)
		xAlarm : BOOL; (*Chiller is in alarm*)
		rSystemTemp : REAL; (*Temeperature of the system controlled by Chiller*)
		WaterManifold : StChillerSignalsInWaterManifold;
	END_STRUCT;
	StChillerParSw : 	STRUCT 
		xEnable : BOOL; (*Enable the NonCrash in the machines where it can be installed*)
	END_STRUCT;
	StChillerParametersWaterManifold : 	STRUCT 
		xSystemRunning : BOOL; (*The system to cool with the Chiller is started*)
	END_STRUCT;
	StChillerParameters : 	STRUCT 
		xEnable : BOOL;
		xInstalled : BOOL; (*The system is or can be installed*)
		SystemType : ChillerSystemType_enum := CHILLERSYS_UNDEFINED;
		WaterManifold : StChillerParametersWaterManifold;
		rTempSetPoint : REAL; (*SetPoint Temperature*)
	END_STRUCT;
	StChiller : 	STRUCT 
		AlSummary : stEFI_AlarmSummary;
		Alarm : StChillerAlarms;
		Orders : StChillerOrders;
		commands : StChillerComands;
		In : StChillerSignalsIn;
		Out : StChillerSignalsOut;
		St : StChillerStates;
		parSw : StChillerParSw;
		Parameters : StChillerParameters;
	END_STRUCT;
END_TYPE
