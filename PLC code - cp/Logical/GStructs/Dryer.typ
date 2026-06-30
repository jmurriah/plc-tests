
TYPE
	DryerModel_enum : 
		(
		DryerNoType,
		DryerType_NOZ2_NIR_ARCLAMP,
		DryerType_NOZ2_NIR
		);
	DryerMachineStatus_enum : 
		(
		DRYERMACH_STOPPED,
		DRYERMACH_PREPARINGTOMOVE,
		DRYERMACH_MOVING,
		DRYERMACH_PREPARING,
		DRYERMACH_PREPARED,
		DRYERMACH_STARTING,
		DRYERMACH_DRYING,
		DRYERMACH_STOPPING_DRYING,
		DRYERMACH_STOPPING_TRANSPORT,
		DRYERMACH_PREPARINGEMPTYBELT, (*Only vaccum transport on*)
		DRYERMACH_ERROR
		);
	Dryer_ProductDetectInputs : 	STRUCT 
		pPDSignalSensorL1 : UDINT; (*Pointer to ProductDetect Signal coming directly from the sensor*)
		pPDSignalSensorL2 : UDINT; (*Pointer to ProductDetect Signal coming directly from the sensor*)
	END_STRUCT;
	Dryer_TempInputs : 	STRUCT 
		iBoardInRaw : INT;
		iBoardOutRaw : INT;
		iBeltRaw : INT;
		iAirBlowerInputRaw : INT; (*45214336. -50C to +200C. 4-20mA*)
		iAirBlowerOutputRaw : INT; (*45214336. -50C to +200C. 4-20mA*)
		xBoardInSensorError : BOOL; (*Sensor Error*)
		xBoardOutSensorError : BOOL; (*Sensor Error*)
		xBeltSensorError : BOOL; (*Sensor Error*)
		xAirBlowerInputSensorError : BOOL; (*45214336. -50C to +200C. 4-20mA. Sensor Error*)
		xAirBlowerOutputSensorError : BOOL; (*45214336. -50C to +200C. 4-20mA. Sensor Error*)
	END_STRUCT;
	Dryer_InputsButtons : 	STRUCT 
		xStopBlowers : BOOL;
		xManual : BOOL;
		xZero : BOOL;
		xAuto : BOOL;
		xStop : BOOL; (*EDGE*)
		xReset : BOOL;
	END_STRUCT;
	Dryer_SafetyInputs : 	STRUCT 
		xMovementsEnabled : BOOL;
		xRemoteEStopOK : BOOL; (*Remote Emergency Stop*)
		xEStopFrontOK : BOOL;
		xEStopRearOK : BOOL;
		xClosedFrontInput : BOOL; (*Closed door detection*)
		xClosedFrontOutput : BOOL; (*Closed door detection*)
		xClosedRearInput : BOOL; (*Closed door detection*)
		xClosedRearOutput : BOOL; (*Closed door detection*)
	END_STRUCT;
	Dryer_Inputs : 	STRUCT 
		Sw : Dryer_Inputs_Sw;
		Safety : Dryer_SafetyInputs;
		xStart : {REDUND_UNREPLICABLE} BOOL; (*EDGE*)
		xManual_GI : BOOL;
		xZero_GI : BOOL;
		xAuto_GI : BOOL;
		xMute : BOOL;
		xMain24VdcOK : BOOL;
		xFan24VdcOK : BOOL;
		xFanBreakersOK : BOOL;
		xFanBreakersWarning : BOOL; (*Power higher than 80% for all fans*)
		xConsentOk : BOOL;
		xExternalCleaningOrder : BOOL;
		iMachineModelCode : INT;
		xOpenDoorsKey : BOOL; (*Enable open doors with ArcLamp hot*)
		Temp : Dryer_TempInputs;
		ProductDetect : Dryer_ProductDetectInputs;
		Buttons : Dryer_InputsButtons;
	END_STRUCT;
	Dryer_HwData : 	STRUCT 
		Family : USINT;
		Name : STRING[20];
		SerialNumber : STRING[80]; (*Serial number of the machine*)
	END_STRUCT;
	Dryer_Excutions : 	STRUCT 
		slow : UDINT;
		fast : UDINT;
	END_STRUCT;
	Dryer_States_Position : 	STRUCT 
		xGoingToPrint : BOOL; (*Internal bool used on printer to set state NOT CAP/NOT PRINT in printer*)
		xInPrint : BOOL; (*Internal bool used on printer to set state PRINTING in printer*)
		xCleaning : BOOL; (*Internal bool used on printer to set state CLEANING in printer*)
		xGoingToCap : BOOL; (*Internal bool used on printer to set state NOT CAP/NOT PRINT in printer*)
		xInCap : BOOL; (*Internal bool used on printer to set state CAPPED in printer*)
	END_STRUCT;
	Dryer_States_AutoLocation : 	STRUCT 
		xLocalORManual : BOOL; (*Local settings and orders*)
		xLocal : BOOL; (*Local settings and orders*)
		xRemote : BOOL; (*Remote settings and orders*)
	END_STRUCT;
	Dryer_States_Mode : 	STRUCT 
		xManual : {REDUND_UNREPLICABLE} BOOL; (*State to define Manual Mode*)
		xZero : BOOL; (*State to define Zero Mode*)
		xAuto : BOOL; (*State to define Auto Mode*)
		xStartUp : BOOL; (*State to define StartUp Mode*)
	END_STRUCT;
	Dryer_States_Out : 	STRUCT 
		xOnline : BOOL;
		xError : BOOL;
		xDrying : BOOL;
		xDryerPresent : BOOL;
		xReadyToDry : BOOL;
		xJamDetection : BOOL;
		xTransportMoving : BOOL;
		xInRemote : BOOL;
		iModelVersion1 : UINT;
		iModelVersion2 : UINT;
		xMediaPresent : BOOL;
		xReadyToEmptyBelt : BOOL;
		xBeltEmpty : BOOL; (*Belt empty in the device*)
	END_STRUCT;
	Dryer_States_Temp : 	STRUCT 
		rBoardIn : REAL;
		rBoardOut : REAL;
		rBelt : REAL;
		rAirBlowerInput : REAL;
		rAirBlowerOutput : REAL;
	END_STRUCT;
	Dryer_States_HMI : 	STRUCT 
		xDryerLocalStopped : BOOL;
		xDryerStopped : BOOL;
		xShowThickness : BOOL; (*Thickness and Gap is used in the program and can be adjusted*)
		xVirtualMedia : BOOL;
		xShowEnableNIR : BOOL; (*Variable to let NIR enabling*)
	END_STRUCT;
	Dryer_States : 	STRUCT 
		Position : Dryer_States_Position;
		Mode : Dryer_States_Mode;
		AutoLocation : Dryer_States_AutoLocation;
		LocationControl : MachineAutoLocation_enum;
		Out : Dryer_States_Out;
		DryerState : DryerMachineStatus_enum;
		Temp : Dryer_States_Temp;
		xConsent : BOOL; (*Internal bool used on printer to set state in CONSENT printer*)
		iAutoModeSW : INT; (*Printer State to sw *)
		iMachineModelCodeSW : INT; (*Printer model to Sw, in function of HW ID code*)
		xNotAutoPossible : BOOL; (*Some condition is preventing to entering auto*)
		StateMode : enumEFI_GenMachineState; (*states*)
		AutoMode : stEFI_MachineAutoModes; (*commands*)
		uiLicenseCounter : UINT;
		exec : Dryer_Excutions;
		HwData : Dryer_HwData;
		xAnyProductDetect : BOOL; (*Any product detect. In any line and coming from Carriage or Sensor directly. It means that a media has been printed*)
		xProductDetectL1 : BOOL; (*Any product detect in L1. In any line and coming from Carriage or Sensor directly. It means that a media has been printed*)
		xProductDetectL2 : BOOL; (*Any product detect in L2. In any line and coming from Carriage or Sensor directly. It means that a media has been printed*)
		xMediaDetected : BOOL; (*Media detected before product detect. Detected in Analog or in 3sensors*)
		iJamDevices : USINT := 0; (*Quantity of Jam Devices installed in the machine*)
		xStarted : BOOL; (*TRUE if the PLC is running*)
		HMI : Dryer_States_HMI;
	END_STRUCT;
	Dryer_ConstantParameters : 	STRUCT 
		rMinThicknessMedia : REAL; (*mm*)
		rMaxThicknessMedia : REAL; (*mm*)
		rMountedMediaLevelInBypassMode : REAL; (*mm*)
		rMinMargin : REAL; (*mm*)
		rMaxMargin : REAL; (*mm*)
		rDistanceThicknesToPD : REAL; (*Distance Between Thicknes Detection To PD Sensor (mm)*)
		iNumBlocks : USINT; (*For writting the number of blocks in a machine*)
		iNumTransVacuum : USINT; (*For writting the number of TransportVacuum in a machine*)
		iNumJamModules : USINT; (*DEPRECATED!!. //TODELETE For writing the number of Jam Detection modules in a machine*)
		iNumSensorsPerJamDevice : USINT := 4; (*For writing the number of Sensors in each Jam Device*)
		rMaxBeltTorque : REAL := 25; (*Max torque supported by the Belt, independently of the motor itself in N·m*)
		rMaxBeltTempSlow : REAL := 180; (*Max temperature supported by the Belt during 30sec, in ºC*)
		rMaxBeltTempFast : REAL := 190; (*Max temperature supported by the Belt during 2sec, in ºC*)
	END_STRUCT;
	Dryer_CleanBeltParameters : 	STRUCT 
		xCleanBeltContinue : BOOL; (*Input software parameter from Sw*)
		xCleanBeltByTiles : BOOL; (*Input software parameter from Sw*)
		xCleanBeltByTime : BOOL; (*Input sw param using time param iCleaningBeltByTime*)
		tiCleaningBeltDuration : TIME; (*Time in seconds. Input software parameter from Sw*)
		iCleaningBeltByTime : UINT; (*Time in Minutes. Input software parameter from Sw*)
		xCleanBeltForced : BOOL; (*Edge Command. Input software parameter from Sw*)
		iSPTilesToCleanBelt : UINT; (*Input software parameter from Sw*)
	END_STRUCT;
	Dryer_SuctionParameters : 	STRUCT 
		iBlowerMode : INT; (*Suction mode functionality. It can be configured by GUI with Ventrui when is 1 or Turbine when is 2. Parameters received from GUI*)
		tiBlowerDelayOff : TIME; (*Delay time before turning off the turbine in auto mode*)
	END_STRUCT;
	Dryer_SafetyParameters : 	STRUCT 
		rMarginSafePrint : REAL; (*SoftwareInput. Fix offset to bent tile. The heads go to the thickness measured + this value. Value in mm*)
		rMaxBeltSpeedSetPoint : REAL := 70.0; (*Max speed received from gui in m/min*)
	END_STRUCT;
	Dryer_DocumentParameters : 	STRUCT 
		rWidth : REAL; (*Board's width in mm*)
		rLength : REAL; (*Board's length in mm*)
		rOffsetL1 : REAL;
		rOffsetL2 : REAL;
	END_STRUCT;
	Dryer_ThermalInertiaReduction : 	STRUCT 
		iBoardsToStartReducing : USINT; (*Total boards detected to start reducing the power*)
		iBoardsToMaxPowerReduction : USINT; (*Total boards detected to form maximum power reduction*)
		rMaxPowerReduction : REAL; (*Maximum power reduction for thermal inertia*)
	END_STRUCT;
	Dryer_MediaParameters : 	STRUCT 
		rThickness : REAL; (*Tile thickness to print from gui in mm*)
		rWidth : REAL; (*Board's width in mm*)
		rGap : REAL; (*Gap between boards in mm*)
		rLength : REAL; (*Board's length in mm*)
		rMargin : REAL; (*SoftwareInput, dry margin in mm*)
		rOffsetRegisterL1 : REAL;
	END_STRUCT;
	Dryer_SwParameters : 	STRUCT 
		CleanBelt : Dryer_CleanBeltParameters;
		Suction : Dryer_SuctionParameters;
		Safety : Dryer_SafetyParameters;
		Media : stThicknessCtrl_MediaConfig;
		xDoubleLine : BOOL; (*0: Derecha 1: Izquierda*)
		xMachineDirection : BOOL; (*0: Derecha 1: Izquierda*)
		xEnableNir : BOOL;
		xEnableDDC : BOOL; (*Enable DDC in Dryer*)
		xEnableArcLamp : BOOL;
		rSubstratePowerReduction : REAL := 1.0; (*Substrate power reduction. From 1.0 (default) to 0.3 is allowed*)
		tiDelayConsent : TIME; (*Used on kernel to PLC. Time in seconds*)
		rBeltSpeedSetPoint : REAL := 20.0; (*Speed in m/min. Input parameter from SW*)
		xLineEmptyingBelt : BOOL; (*Line in emptying belt*)
		xPrinterBeltRuning : BOOL; (*Printer belt runing status*)
	END_STRUCT;
	Dryer_Parameters : 	STRUCT 
		SW : Dryer_SwParameters; (*Software input params*)
		CT : Dryer_ConstantParameters; (*Printer input constants params*)
		ThermalInertia : Dryer_ThermalInertiaReduction;
		ConfigName : STRING[80];
		ConfigNameID : USINT := 0; (*Identification of the Configuration been executed*)
		xTransVacuumIndependenParams : BOOL; (*TRUE: Each TransVacuum with different parameters. FALSE: TransVacuum[1] copied to the rest of elements*)
		MachineModel : DryerModel_enum; (*HW ID codes are defined here*)
		PDSignalTpe : ProductDetectSignal_enum;
		xLeftHandMachine : BOOL; (*Software Output*)
		xRightHandMachine : BOOL; (*Software Output*)
		xLocalDisableDDC : BOOL;
		xEnableDryDocWidth : BOOL; (*Enable drying width by image instead of media, only in remote mode.*)
	END_STRUCT;
	Dryer_commands_Auto : 	STRUCT 
		xPrepareToDry : BOOL;
		xStartDrying : BOOL;
		xRunTransport : BOOL;
		xPrepareToEmptyBelt : BOOL;
	END_STRUCT;
	Dryer_commands : 	STRUCT 
		xAllToCap : BOOL; (*Use as EDGE*)
		xAllToPrint : BOOL; (*Use as EDGE*)
		xToLocal : BOOL; (*Command to go in Local mode*)
		xToRemote : BOOL; (*Command to go in Remote mode*)
		xResetSwitch : BOOL;
		xResetHub : BOOL;
		xResetFanBreaker : BOOL;
		xUnlockDoors : BOOL; (*Use as EDGE*)
		SerialNumber : stGeneral_SerialNumberCommands;
	END_STRUCT;
	Dryer_Inputs_Sw : 	STRUCT 
		xStart_GI : BOOL; (*EDGE*)
		xStop_GI : BOOL; (*Edge command*)
		xMute_GI : BOOL; (*EDGE*)
		xPause_GI : BOOL; (*EDGE*)
		xReset_GI : BOOL; (*EDGE*)
		xToStop_GI : BOOL; (*Edge commandBool to Stop Mode*)
		xToNormal_GI : {REDUND_UNREPLICABLE} BOOL; (*Edge commandBool to start AutoRun Mode*)
		xToByPass_GI : BOOL; (*Edge commandBool to start Bypass Mode*)
		xStopBlowers_GI : BOOL; (*To stop blowers after keep them off to avoid cardboard fire*)
	END_STRUCT;
	Dryer_AutoCommands : 	STRUCT 
		iAutoMode : enumEFI_MachineAutoStatesMode; (*Internal variable to manage AUTOMATIC modes in printer RU,BUPASS, LAB AND STOP*)
		xMuteAlarms : BOOL; (*Edge commandBool used to mute all alarms*)
		xToCap : BOOL; (*Edge commandBool used to send all block to cap*)
		xToPrint : BOOL; (*Edge commandBool used to send all block to print*)
		xReset : BOOL; (*Internal bool used on printer to set state RESET in printer*)
		xStart : BOOL; (*Edge Command to Start the Machine. By button or an specific order from Sw*)
		xStop : BOOL; (*Edge Command to Stop the Machine. By button or an specific order from Sw*)
	END_STRUCT;
	Dryer_AlarmsSafety : 	STRUCT 
		xMaintenanceKey : BOOL; (*Maintenance Key active. Enables without safety guard closed*)
		xRemoteEStop : BOOL; (*Remote Emergency Stop*)
		xEStopFront : BOOL; (*Emergency Stop*)
		xEStopRear : BOOL; (*Emergency Stop*)
		xOpenedFrontInput : BOOL; (*Door*)
		xOpenedFrontOutput : BOOL; (*Door*)
		xOpenedRearInput : BOOL; (*Door*)
		xOpenedRearOutput : BOOL; (*Door*)
	END_STRUCT;
	Dryer_AlarmsList : 	STRUCT 
		Safety : Dryer_AlarmsSafety;
		xAlarmPlarformInc : BOOL; (*AlarmCritical*)
		xAlarmComPcPLC : BOOL; (*AlarmStop*)
		xAlarmMountedMedia : BOOL;
		xAlarmMountedPieceBypassMode : BOOL; (*AlarmStop*)
		xUpNotConsent : BOOL; (*Resume alarms*)
		xNoActionDangerCollision : BOOL; (*Resume alarms*)
		xNoActionAlarmExist : BOOL; (*Resume alarms*)
		xPDBrokenSensorL1 : BOOL; (*Product Detect Line 1 Broken or Desconected*)
		xPDBrokenSensorL2 : BOOL; (*Product Detect Line 2 Broken or Desconected*)
		xMain24Vdc : BOOL; (*Main 24VDC Power Supply switched off*)
		xFan24Vdc : BOOL; (*Fan 24VDC Power Supply switched off*)
		xFanBreakers : BOOL; (*Fan breakers error*)
		xAlrBeltOvertorque : BOOL; (*Alarm Critical: Overtorque in Belt. Risk to break the belt itself*)
		xAlrBeltOverTempSlow : BOOL; (*Alarm Critical: OverTemperature in Belt. Risk to break the belt itself*)
		xAlrBeltOverTempFast : BOOL; (*Alarm Critical: OverTemperature in Belt. Risk to break the belt itself*)
		xAlrJam : BOOL; (*Alarm Critical: Any jam is triggered*)
		xAlrWrongPhysConf : BOOL; (*Alarm Critical: Wrong physical configuration or some tarjet are disconected*)
	END_STRUCT;
	Dryer_WarningsList : 	STRUCT 
		xNotEnabledMovement : BOOL;
		xKeyMantenanceActive : BOOL; (*Key mantenance is active. No movements*)
		xValidConfiguration : BOOL; (*Review*)
		xMaxMovsBentTile : BOOL;
		xBentMedia : BOOL;
		xFanBreakersHighLoad : BOOL; (*Fan breakers High Load*)
		xMountedMediaInside : BOOL;
		xMediaStoppedInside : BOOL;
		xBoardInSensorError : BOOL; (*Sensor Error*)
		xBoardOutSensorError : BOOL; (*Sensor Error*)
		xBeltSensorError : BOOL; (*Sensor Error*)
		xAirBlowerInputSensorError : BOOL; (*45214336. -50C to +200C. 4-20mA. Sensor Error*)
		xAirBlowerOutputSensorError : BOOL; (*45214336. -50C to +200C. 4-20mA. Sensor Error*)
		xFrontDoorOpened : BOOL;
		xJamLowCrash : BOOL; (*Low level jam detected by the jam device*)
		xRearDoorOpened : BOOL;
	END_STRUCT;
	Dryer_Alarms : 	STRUCT 
		Warning : Dryer_WarningsList;
		Alarm : Dryer_AlarmsList;
		xAlrStopDrying : BOOL;
		iReasonStopDrying : UINT;
		xAlrDisableGoToProduction : BOOL;
		xAlrSafetySystemEStop : BOOL; (*SLX DI 10 is enable transport from safety progam*)
		xAlarmSound : BOOL;
	END_STRUCT;
	Dryer_Log : 	STRUCT 
		ManualChg : DINT;
		AutoChg : DINT;
		ManualHrs : DINT;
		AutoHrs : DINT;
		VdcHrs : DINT;
		DateStart : DINT;
		iPieceCounterBtwCleaningsL2 : INT;
		iPieceCounterBtwCleaningsL1 : INT;
		udiBentTilesCounter : UDINT;
		udiPiecesCounterErrorL1 : UDINT; (*PD Detection Counter Failed L1*)
		udiPiecesCounterErrorL2 : UDINT; (*PD Detection Counter Failed L2*)
		udiPiecesCounterL1 : UDINT;
		udiPiecesCounterL2 : UDINT;
		udiTileCounterBalluffLaser : UDINT; (*Program in mode active..end*)
		udiTileCounterTriggerLaser : UDINT; (*Program in mode active..end*)
		udiDifCounters : UDINT; (*Program in mode active..end*)
		iTilesCounterToClean : UINT;
	END_STRUCT;
	Dryer_Outputs : 	STRUCT 
		xResetSwitch : BOOL;
		xResetHub : BOOL;
		xResetFanBreaker : BOOL;
		xLockFrontDoor : BOOL;
		xLockRearDoor : BOOL;
		xBuzzer : BOOL;
		xRedLight : BOOL;
		xYellowLight : BOOL;
		xBlueLight : BOOL;
		xWhiteLight : BOOL;
		xResetBlueLight : BOOL;
		xConsentL1 : BOOL;
		xConsentL2 : BOOL;
		xSuctionTurbine : BOOL;
		xLightReset : BOOL;
		xCoolingPCStart : BOOL;
		xKeepSafetyNIR : BOOL;
	END_STRUCT;
	DryerMachine : 	STRUCT 
		In : Dryer_Inputs;
		St : Dryer_States;
		Pt : Dryer_Parameters;
		commands : Dryer_commands;
		AutoCmd : Dryer_AutoCommands;
		AlSummary : stEFI_AlarmSummary;
		Al : Dryer_Alarms;
		Lg : Dryer_Log;
		Out : Dryer_Outputs;
	END_STRUCT;
	DryerRemoteSignals : 	STRUCT 
		xMediaPresent : BOOL; (*Media present at the entrance of the machine*)
		xBreakerOKBlowerInput : BOOL;
		xBreakerOKBlowerOutput : BOOL;
		Safety : Dryer_SafetyInputs;
	END_STRUCT;
	DryerRemoteData : 	STRUCT 
		xCommsOK : BOOL; (*The comunications are working fine. Data can be trusted*)
		Parameters : Dryer_SwParameters;
		Commands : Dryer_commands_Auto; (*From Line to Dryer*)
		Signals : DryerRemoteSignals;
	END_STRUCT;
END_TYPE
