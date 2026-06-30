
TYPE
	NIRAdphos_State : 
		(
		NIRADPEW_NOT_INITIALIZED,
		NIRADPEW_INIT,
		NIRADPEW_IDLE,
		NIRADPEW_POWER_ON,
		NIRADPEW_POWERED,
		NIRADPEW_RUNNING_BELT,
		NIRADPEW_READY,
		NIRADPEW_STARTING,
		NIRADPEW_RUNNING,
		NIRADPEW_ERROR,
		NIRADPEW_SAFETY_ERROR,
		NIRADPEW_COMMS_ERROR
		);
	NIRAdphos_ModuleState : 
		(
		NIRADPM_UNDEFINED, (*Wrong value*)
		NIRADPM_OFF, (*0*)
		NIRADPM_STARTUP, (*1*)
		NIRADPM_READY, (*2*)
		NIRADPM_STANDBY, (*3*)
		NIRADPM_PROCESS, (*4*)
		NIRADPM_SHUTDOWN (*5*)
		);
	NIRAdphos_CommsInModule : 	STRUCT  (*From Dryer to Adphos*)
		NirStatus : NIRAdphos_ModuleState := NIRADPM_UNDEFINED; (*Value transformed from iNirStatus, directly received from comms*)
		iNirStatus : INT; (*NIR Status: 0=Off, 1=StartUp, 2=Ready, 3=StandBy, 4=Process, 5=Shutdown*)
		Watchdog : BOOL; (*1Hz blink with communication*)
		error : BOOL;
		message : BOOL; (*There is at least one message*)
		closed : BOOL; (*Module closed in docking station*)
		SuppAirRunning : BOOL; (*Support air blower running*)
		ExtAirRunning : BOOL; (*Exhaust air blower running*)
		TotalInFail : USINT; (*EmFailNo. Number of emmiters with defect*)
		AirPressIn : REAL; (*Aire pressure support air [Pa]*)
		AirPressOut : REAL; (*Aire pressure exhaust air [Pa]*)
		AirFilter : INT; (*Aire pressure Filter monitoring [Pa]*)
		SpeedIn : INT; (*Speed In [%]*)
		SpeedOut : INT; (*Speed Out [%]*)
		xPowered : BOOL; (*Calculated from other info received*)
		Power : INT; (*Power [%]*)
	END_STRUCT;
	NIRAdphos_CommsInVersion : 	STRUCT  (*From Dryer to Adphos*)
		Software : INT; (*Software version*)
		Hardware : INT; (*Hardware version*)
		Interface : INT; (*Interface version*)
		HMI : INT; (*HMI version*)
	END_STRUCT;
	NIRAdphos_CommsInCalc_Spare : 	STRUCT 
		xPowered : BOOL; (*Calculated from other info received*)
		xBeltRunning : BOOL; (*Calculated from other info received*)
	END_STRUCT;
	NIRAdphos_CommsIn : 	STRUCT  (*From Adphos to Dryer*)
		Version : NIRAdphos_CommsInVersion;
		Speed : REAL; (*Current speed [m/min]*)
		CalPower : INT; (*Calculated power [%]*)
		NirWidth : INT; (*Current NIR Width [mm]*)
		NirTotalActive : INT; (*Number of active emiters*)
		xBeltRunning : BOOL; (*Calculated from other info received*)
		Modules : ARRAY[0..2]OF NIRAdphos_CommsInModule; (*Module 0 not used*)
		Zones : ARRAY[0..48]OF BOOL; (*Current active zones. Zone 0 not used*)
	END_STRUCT;
	NIRAdphos_CommsOutModule : 	STRUCT  (*From Dryer to Adphos*)
		Adjust : INT; (*Adjust heatihng power [0 to 100 %]*)
		EnableMod : BOOL; (*Enable module*)
	END_STRUCT;
	NIRAdphos_CommsOut : 	STRUCT  (*From Dryer to Adphos*)
		Vstart : REAL; (*Start speed [m/min]*)
		Vend : REAL; (*Final speed [m/min]*)
		Pstart : REAL; (*Start Power [%]*)
		Pend : REAL; (*Final Power [%]*)
		WebWidth : INT; (*WebWidth [360 to 1440mm]. DO NOT WRITE DIRECTLY FROM OUTSIDE NIR CODE*)
		AdjPos : INT; (*Adjust heatihng area [+ or - xx mm]*)
		Modules : ARRAY[0..2]OF NIRAdphos_CommsOutModule; (*Module 0 not used*)
	END_STRUCT;
	NIRAdphos_Comms : 	STRUCT  (*DEPRECATED. USED INSIDE STRUCTURE IN PARAMS AND STATUS*)
		In : NIRAdphos_CommsIn; (*From Adphos to Dryer*)
		Out : NIRAdphos_CommsOut; (*From Dryer to Adphos*)
	END_STRUCT;
	NIRAdphos_DDC : 	STRUCT  (*DEPRECATED. USED INSIDE STRUCTURE IN PARAMS AND STATUS*)
		xEnableDDC : BOOL; (*Enable Dynamic Dryer Control *)
		iLamps : USINT; (*Total quantity of Lamps in the machine*)
		iLampsExtend : USINT := 0; (*Quantity of lamps to extend the value of each lamp*)
		rMinIntensityPercentage : REAL; (*Minimum value of Drying during DDC. With the speed and the curve, the value to send to the Dryer is modifyed and increased if needed. 10 expected for 10%*)
		pIntensityNir1 : {REDUND_UNREPLICABLE} UDINT;
		pIntensityNir2 : {REDUND_UNREPLICABLE} UDINT;
	END_STRUCT;
	NIRAdphos_Parameters : 	STRUCT 
		StateMode : enumEFI_GenMachineState; (*commands to block*)
		AutoMode : stEFI_MachineAutoModes;
		xEnableNir : BOOL;
		DDC : NIRAdphos_DDC;
		CpuFamily : USINT;
		rBeltSpeed : REAL; (*Current speed of the belt*)
		xBeltRunning : BOOL; (*External information about the belt moving*)
		rMaxSurfaceTemp : REAL; (*Maximum allowed surface temperature*)
		iTotalModules : USINT; (*Total NIR modules*)
		Comms : NIRAdphos_CommsOut;
		xLineEmptyingBelt : BOOL; (*Line in empty belt mode*)
		MediaWidth : INT; (*MediaWidth. WebWidth [360 to 1440mm]*)
		iExtraDryingWidh : INT := 0; (*Extra drying width in mm. Value added to allow more lamps turnend on than the theoretical. Just positive values*)
		xInstalled : BOOL;
	END_STRUCT;
	NIRAdphos_AlarmsJam : 	STRUCT 
		xFront : BOOL; (*Detection with first corner Front*)
		xRear : BOOL; (*Detection with first corner Rear*)
		xCross : BOOL; (*Detecction across NIR*)
		xMechCross : BOOL; (*Mechanical detectin across NIR*)
	END_STRUCT;
	NIRAdphos_AlarmsBlockedFans : 	STRUCT  (*EFI Signal*)
		Fan : ARRAY[0..4]OF BOOL; (*0 not used*)
	END_STRUCT;
	NIRAdphos_Alarms : 	STRUCT 
		xCommsError : BOOL; (*EDGE*)
		xMaxSurfaceTempModule : ARRAY[0..MAX_LAST_NIR_MODULES]OF BOOL; (*Max Surface temperature achieved. 0 is not used*)
		xSurfaceTempModuleSensorError : ARRAY[0..MAX_LAST_NIR_MODULES]OF BOOL; (*Sensor error. 0 is not used*)
		BlockedFansModule : ARRAY[0..MAX_LAST_NIR_MODULES]OF NIRAdphos_AlarmsBlockedFans;
		Jam : ARRAY[0..MAX_LAST_NIR_MODULES]OF NIRAdphos_AlarmsJam;
		xOpcUaWriteError : ARRAY[0..MAX_LAST_NIR_MODULES]OF BOOL; (*Comms error in the OpcUa Write comms*)
		xAnyJam : BOOL; (*Summary signal of any of the jams in the modules*)
		xSafetyError : BOOL; (*Safety error in the Dryer*)
		xFault : BOOL; (*Fault detected in the Dryer*)
		xInletTempSensorError : BOOL; (*EFI signal from Inlet Temperature. Sensor Error*)
		xInletHumiditySensorError : BOOL; (*EFI signal from Inlet Humidity. Sensor Error*)
	END_STRUCT;
	NIRAdphos_CommandsComms : 	STRUCT 
		xSpare : BOOL;
	END_STRUCT;
	NIRAdphos_Commands : 	STRUCT 
		xPrepare : BOOL; (*EDGE*)
		xStart : BOOL; (*EDGE*)
		xStop : BOOL; (*EDGE*)
		xReset : BOOL;
		xMute : BOOL;
		xMediaInside : BOOL;
		xExternalSafetyStop : BOOL; (*External Safety Stop order*)
		Comms : NIRAdphos_CommandsComms;
	END_STRUCT;
	NIRAdphos_JamInputs : 	STRUCT 
		xMechCross : BOOL; (*Mechanical detectin across NIR*)
	END_STRUCT;
	NIRAdphos_BlockedFansSignalsIn : 	STRUCT  (*EFI Signal*)
		Fan : ARRAY[0..4]OF BOOL; (*0 not used. 1 Is the first in the operator side*)
	END_STRUCT;
	NIRAdphos_SignalsIn : 	STRUCT 
		xReady : BOOL;
		xFault : BOOL; (*Any error in the enabled alarms*)
		xInProcess : BOOL;
		xSafetyOK : BOOL; (*Safety in the NIR Dryer is OK*)
		iInletTempRaw : INT; (*EFI signal from Inlet Temperature*)
		iInletHumidityRaw : INT; (*EFI signal from Inlet Humidity*)
		xInletTempSensorError : BOOL; (*EFI signal from Inlet Temperature. Sensor Error*)
		xInletHumiditySensorError : BOOL; (*EFI signal from Inlet Humidity. Sensor Error*)
		iSurfaceTempModuleRaw : ARRAY[0..MAX_LAST_NIR_MODULES]OF INT; (*EFI signal from Surface Temperature of the modules directly from the Input Card. 0 is not used*)
		xSurfaceTempModuleSensorError : ARRAY[0..MAX_LAST_NIR_MODULES]OF BOOL; (*EFI signal from Surface Temperature of the modules directly from the Input Card. 0 is not used*)
		Jam : ARRAY[0..MAX_LAST_NIR_MODULES]OF NIRAdphos_JamInputs; (*EFI signal from Surface Temperature of the modules directly from the Input Card. 0 is not used*)
		BlockedFans : ARRAY[0..MAX_LAST_NIR_MODULES]OF NIRAdphos_BlockedFansSignalsIn; (*EFI signal. 0 not used*)
	END_STRUCT;
	NIRAdphos_SignalsOut : 	STRUCT 
		xPowerOn : BOOL;
		xProcess : BOOL;
		xSafetyStop : BOOL; (*Any error in the enabled alarms*)
		iBeltSpeed : INT; (*Current speed of the belt*)
		xWatchDog : BOOL; (*1Hz blinking data*)
	END_STRUCT;
	NIRAdphos_Signals : 	STRUCT 
		In : NIRAdphos_SignalsIn;
		Out : NIRAdphos_SignalsOut; (*Any error in the enabled alarms*)
	END_STRUCT;
	NIRAdphos_DDCIntensityStatus : 	STRUCT 
		Intensity : ARRAY[0..THICKENERGY_MAX_LAMPS]OF INT; (*Data starting in index 1*)
	END_STRUCT;
	NIRAdphos_Status : 	STRUCT 
		xAnyModuleEnabled : BOOL;
		xAnyModuleInError : BOOL; (*Any error in the enabled alarms*)
		xEnabledNir : BOOL;
		xEnabledDDC : BOOL;
		DDC : ARRAY[0..MAX_LAST_NIR_MODULES]OF NIRAdphos_DDCIntensityStatus;
		rPowerSetPoint : REAL; (*Power SetPoint calculated from Speed and Power/Speed curve*)
		iMinPower : INT; (*Minimum power calculated with the curves and the spped*)
		rInletTemperature : REAL;
		rInletHumidity : REAL;
		rSurfaceTempModule : ARRAY[0..MAX_LAST_NIR_MODULES]OF REAL; (*Surface Temperature of the modules in degree Celsius. 0 is not used*)
		xDrying : BOOL; (*Summary information. State == RUNNING*)
		xCommsOK : BOOL;
		Comms : NIRAdphos_CommsIn;
	END_STRUCT;
	NIRAdphos_Orders : 	STRUCT 
		xCheckJam : BOOL; (*Order active when dryer conditions require to check jam sensors*)
	END_STRUCT;
	NIRAdphos : 	STRUCT 
		Parameters : NIRAdphos_Parameters;
		State : NIRAdphos_State := NIRADPEW_NOT_INITIALIZED;
		Alarms : NIRAdphos_Alarms;
		AlSummary : stEFI_AlarmSummary;
		Commands : NIRAdphos_Commands;
		Signals : NIRAdphos_Signals;
		Status : NIRAdphos_Status;
		Orders : NIRAdphos_Orders;
	END_STRUCT;
END_TYPE
