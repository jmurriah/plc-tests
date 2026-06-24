
TYPE
	CommsType_enum : 
		(
		NoCommsType,
		Type_OpcUa,
		Type_ModbusTcp
		);
	MachineModel_enum : 
		(
		NoType,
		Type_P4_12B,
		Type_P4_6B,
		Type_P4_12B_L,
		Type_P4_6B_L,
		Type_SHLD,
		Type_SHLD_L,
		Type_S1400,
		Type_S1400_VAC_PWRLNK,
		Type_S1400_VAC_CAN,
		Type_NOZ_2_AQ,
		Type_P5_OIL,
		Type_P5_WTR,
		Type_P4_CBK,
		Type_NOZ_2_UV,
		Type_NOZ_2_UV_White,
		Type_CUBE_INSPECTION,
		Type_CUBE,
		Type_CUBE_GULLIVER_INSPECTION,
		Type_CUBE_GULLIVER,
		Type_MECANO_UV_WHITE,
		Type_MECANO_UV_OPV,
		Type_MECANO_UV_WHITE_OPV
		);
	CleaningBeltState_enum : 
		(
		CLN_BELT_NOT_READY := 0, (*System not ready to execute a clean belt process*)
		CLN_BELT_READY_TO_CLEAN := 1, (*System ready to execute a clean belt process*)
		CLN_BELT_CLEANING_START := 2, (*Starting printer's belt movement at clean belt speed defined by Sw*)
		CLN_BELT_CLEAN_CLOKWISE := 3, (*Start brushes to move clockwise*)
		CLN_BELT_CLEAN_COUNTERCLOCKWISE := 4, (*Start brushes to move counterclockwise*)
		CLN_BELT_CLEANED := 5,
		CLN_BELT_ERROR := 6
		);
	CleaningState_enum : 
		(
		CLN_NOT_CLEANING := 1,
		CLN_LINEDELAYING_GAP := 2,
		CLN_READY_TO_CLEAN := 3,
		CLN_CLEANING_ALL_START := 4,
		CLN_CLEANING_ALL_CLEANING := 5,
		CLN_CLEANING_1_START := 6,
		CLN_CLEANING_1_CLEANING := 7,
		CLN_CLEANING_BTW_BLOCKS := 8,
		CLN_CLEANING_2_START := 9,
		CLN_CLEANING_2_CLEANING := 10,
		CLN_CLEANING_JUST1_START := 11,
		CLN_CLEANING_JUST1_CLEANING := 12,
		CLN_CLEANING_JUST2_START := 13,
		CLN_CLEANING_JUST2_CLEANING := 14
		);
	MachineLights_enum : 
		(
		MACHINE_LIGHTS_NOT_DEFINED,
		MACHINE_LIGHTS_BEACON,
		MACHINE_LIGHTS_RGB
		);
	ProductDetectSignal_enum : 
		(
		PDCFG_NOT_DEFINED,
		PDCFG_SENSOR,
		PDCFG_CARRIAGE,
		PDCFG_SENSOR_AND_CARRIAGE
		);
	StartUpStatus_enum : 
		(
		STRUP_DISABLED,
		STRUP_NOT_STARTED,
		STRUP_RESETTING_MOTORS,
		STRUP_HOME_ICLA_ORDER,
		STRUP_HOMING_ICLA,
		STRUP_MOVING_TRAY_OUT,
		STRUP_HOMING_BLOCK,
		STRUP_BLOCK_GOING_TO_CAP,
		STRUP_STARTING_INKS,
		STRUP_WAIT_INKS_STARTED,
		STRUP_REVIEWING_INKS,
		STRUP_POWER_UP_PRINTHEADS,
		STRUP_REVIEWING_PRINTHEADS,
		STRUP_ERROR,
		STRUP_READY,
		STRUP_CANCELLED
		);
	StGeneral_CleanBeltInputs : 	STRUCT 
		xLowPosition : BOOL; (*This sensor is active when cylinder is fully in low position.*)
		xHighPosition : BOOL; (*This sensor is active when brush is in place*)
		xError : BOOL; (*The motor relay controls the voltage and current of the motor. If relay is in fault state, this signal will be active*)
		xOpenGuide : BOOL; (*TRUE when clean belt system is not in position*)
	END_STRUCT;
	StGeneral_ProductDetectInputs : 	STRUCT 
		pPDCarriageSignalL1 : UDINT; (*Pointer to ProductDetect Signal coming from the Carriage Board*)
		pPDCarriageSignalL2 : UDINT; (*Pointer to ProductDetect Signal coming from the Carriage Board*)
		pPDCarriage2SignalL1 : UDINT; (*Pointer to ProductDetect Signal coming from the Carriage Board 2*)
		pPDCarriage2SignalL2 : UDINT; (*Pointer to ProductDetect Signal coming from the Carriage Board 2*)
		pPDSignalSensorL1 : UDINT; (*Pointer to ProductDetect Signal coming directly from the sensor*)
		pPDSignalSensorL2 : UDINT; (*Pointer to ProductDetect Signal coming directly from the sensor*)
		xAnalogSignalError : BOOL;
		iAnalogSignal : INT;
	END_STRUCT;
	stGeneral_Inputs_Sw : 	STRUCT  (*All this commands are Edge commands*)
		xStart_GI : BOOL; (*EDGE*)
		xStop_GI : BOOL; (*Edge command*)
		xMute_GI : BOOL; (*EDGE*)
		xPause_GI : BOOL; (*EDGE*)
		xReset_GI : BOOL; (*EDGE*)
		xToStop_GI : BOOL; (*Edge commandBool to Stop Mode*)
		xToNormal_GI : {REDUND_UNREPLICABLE} BOOL; (*Edge commandBool to start AutoRun Mode*)
		xToLaboratory_GI : BOOL; (*Edge commandBool to Laboratory Mode*)
		xToByPass_GI : BOOL; (*Edge commandBool to start Bypass Mode*)
		xToJamRecovery : BOOL; (*Edge commandBool to start JamRecovery Mode*)
		xRushProof : BOOL; (*SW marks media to be rejected*)
		xCleanBelt : BOOL; (*SW will active this command when asking a belt cleaning*)
		xCancelStartUp : BOOL; (*SW will active this command when asking to cancel StartUp*)
	END_STRUCT;
	StGeneral_Inputs_Buttons : 	STRUCT  (*Buttons and selectors*)
		xStart : BOOL; (*EDGE*)
		xStop : BOOL; (*EDGE*)
		xManual : BOOL;
		xZero : BOOL;
		xAuto : BOOL;
		xReset : BOOL;
		xMute : BOOL;
	END_STRUCT;
	StGeneral_Inputs : 	STRUCT 
		Buttons : StGeneral_Inputs_Buttons;
		x24Vdc : BOOL;
		x230V : BOOL;
		UPSs : ARRAY[0..2]OF UPS_Inputs; (*Element 0 is not used*)
		xConsentL1Ok : BOOL;
		xConsentL2Ok : BOOL;
		xExternalCleaningOrder : BOOL;
		xPC1Ok : BOOL;
		xPC2Ok : BOOL;
		xAirSupply : BOOL; (*General air supply pressure  (ok = TRUE)*)
		iMachineModelCode : INT;
		xSafetyEnabled : BOOL; (*From Safety program*)
		xPbfCardOK : BOOL;
		iRelieve1 : UINT;
		iRelieve2 : UINT;
		xTankHeaterPsuOK : BOOL; (*Signal when Just 1 PSU for TankHeating in the machine*)
		xCoolingPCSensorAlrm : BOOL;
		xCameraDefectDetected : BOOL;
		xRemoteReset : BOOL; (*Reset order in machine remotely controlled*)
		xRemoteJog : BOOL; (*Jog order in machine remotely controlled*)
		CleanBelt : StGeneral_CleanBeltInputs;
		ProductDetect : StGeneral_ProductDetectInputs;
		xDegasserPressure : BOOL;
		xHoppersSoftStarterFault : BOOL;
		xOvervoltage : BOOL;
		xPowerSwitch : BOOL := TRUE; (*Power switch located on printer's cabinet door*)
		xWasteInkTankMaxLevelReached : BOOL;
		AntiStatic : StGeneral_AntiStatictInputs;
	END_STRUCT;
	StGeneral_AntiStatictInputs : 	STRUCT 
		xIonLevelAlarm : BOOL; (*Wastage of the antistatic device electrodes*)
		xGenAlarm : BOOL; (*General malfunction alarm of the antistatic device*)
	END_STRUCT;
	StGeneral_Camera_Params : 	STRUCT 
		xInstalled : BOOL;
		iMappingBar : USINT;
	END_STRUCT;
	StGeneral_Camera_OrdersSw : 	STRUCT 
		xCalibration : BOOL; (*Camera's calibrations process activated*)
	END_STRUCT;
	StGeneral_Camera : 	STRUCT 
		Parameters : StGeneral_Camera_Params;
		OrdersSw : StGeneral_Camera_OrdersSw;
	END_STRUCT;
	StGeneral_AirCleaner : 	STRUCT 
		Parameters : StGeneral_AirCleaner_Parameters;
		OrdersSw : StGeneral_AirCleaner_SwOrders;
		ParSw : StGeneral_AirCleaner_ParSw;
		Alarms : StGeneral_AirCleaner_Alarms;
	END_STRUCT;
	StGeneral_AirCleaner_Alarms : 	STRUCT 
		xDriveComms : BOOL;
		xInverterPowerFault : BOOL;
		xBlowerNotRunning : BOOL;
		xDriveError : BOOL;
	END_STRUCT;
	StGeneral_AirCleaner_SwOrders : 	STRUCT 
		xRun : BOOL; (*Delay time before turning off the turbine in auto mode*)
	END_STRUCT;
	StGeneral_AirCleaner_ParSw : 	STRUCT 
		rDutyCycle : REAL; (*Speed in %*)
	END_STRUCT;
	StGeneral_AirCleaner_Parameters : 	STRUCT 
		iIndex : USINT;
		Direction : MotorDirection_enum;
		xInstalled : BOOL;
		rMaxSpeed : REAL;
	END_STRUCT;
	StGeneral_ApplicationBar : 	STRUCT 
		xInstalled : BOOL;
		xDebugMode : BOOL;
		xEnableToPrint : BOOL;
	END_STRUCT;
	StGeneral_HwData : 	STRUCT 
		xSimulation : BOOL; (*Defines if the machine is a Simulator*)
		Family : USINT;
		Name : STRING[20];
		SerialNumber : STRING[80]; (*Serial number of the machine*)
		xIsWater : BOOL;
		xIsCubik : BOOL;
		xIsPlatform5 : BOOL; (*Is machine platform 5 to software*)
		xUpsOutOfPrinter : BOOL; (*This printer has no UPS in its cabinet*)
	END_STRUCT;
	StGeneral_Excutions : 	STRUCT 
		slow : UDINT;
		fast : UDINT;
	END_STRUCT;
	StGeneral_States_Inks : 	STRUCT 
		xAnyStarted : BOOL; (*Any Ink System started*)
		rMaxTempSetPoint : REAL; (*Maximum SetPoint for Started systems*)
		rMinTempSetPoint : REAL; (*Minimum SetPoint for Started systems*)
		rMaxTemp : REAL; (*Maximum Temperature for Started Systems*)
		rMinTemp : REAL; (*Minimum Temperature for Started Systems*)
	END_STRUCT;
	StGeneral_States_Consent : 	STRUCT 
		xConsent : BOOL; (*Internal bool used on printer to set state in CONSENT printer*)
		xLackOfConsent : BOOL; (*Machine has order to move the Belt but it is stooped because there is no consent in the line*)
		xUpWithNoConsent : BOOL;
		xUpWithNoConsentCountingTime : BOOL; (*The timer for xUpWithNoConsent is counting*)
		xOrderToEmpyBelt : BOOL; (*The  Belt has to be emptyed, so started the belt without consent*)
	END_STRUCT;
	StGeneral_States_Position : 	STRUCT 
		xGoingToPrint : BOOL; (*Internal bool used on printer to set state NOT CAP/NOT PRINT in printer*)
		xInPrint : BOOL; (*Internal bool used on printer to set state PRINTING in printer*)
		xCleaning : BOOL; (*Internal bool used on printer to set state CLEANING in printer*)
		xGoingToCap : BOOL; (*Internal bool used on printer to set state NOT CAP/NOT PRINT in printer*)
		xInCap : BOOL; (*Internal bool used on printer to set state CAPPED in printer*)
	END_STRUCT;
	StGeneral_States_ProductDetect : 	STRUCT 
		xProductDetectL1 : BOOL; (*Any product detect in L1. In any line and coming from Carriage or Sensor directly. It means that a media has been printed*)
		xProductDetectL2 : BOOL; (*Any product detect in L2. In any line and coming from Carriage or Sensor directly. It means that a media has been printed*)
		xAnyProductDetect : BOOL; (*Any product detect. In any line and coming from Carriage or Sensor directly. It means that a media has been printed*)
		xAnyProductDetectDtpStricted : BOOL; (*Any product detect. In any line and coming from Carriage or Sensor directly. Refused L2 if not in DTP*)
	END_STRUCT;
	StGeneral_States_Remote : 	STRUCT 
		xMachineReady : BOOL; (*Machine in Print position with Blowers and Belt ready*)
		xReadyToJogInJamRecovery : BOOL; (*Bars in safety print position and ready to receive the jog order*)
		xSafetyReadyToReset : BOOL; (*Safety ready to be reseted*)
		xBeltNotStopped : BOOL; (*The signal is always TRUE, and when the belt stops, it is reseted during a second*)
	END_STRUCT;
	StGeneral_States_CleaningBelt : 	STRUCT 
		enState : CleaningBeltState_enum;
		xCleaningProcessOnGoing : BOOL; (*Clean belt process is being executed*)
		TimeDelaySwapDirBeltCleanMotor : TIME; (*Time to wait before swap belt clean motor direction*)
		xCleanRequired : BOOL; (*Clean belt process must be executed*)
		iTimeToCleanBelt : INT;
	END_STRUCT;
	StGeneral_States_Cleaning : 	STRUCT 
		enCleaningState : CleaningState_enum;
		iCleaningState : UINT; (*Cleaning State value to Sw*)
		xCleanRequestToLine : BOOL; (*When an internal cleaning request is set and machine is controlled by line*)
		xCleanRequired : BOOL; (*The printer will clean automatically in less than 10' when this signal is activated*)
		xCleanInminent : BOOL; (*The printer will clean automatically in 30" after this signal is activated. SendJob should be lowered and not raised*)
		MinutesInStopForClean : UDINT; (*Software Output*)
		MinutesInProdForClean : UDINT; (*Software Output*)
		MinutesForClean : UDINT; (*Software Output*)
		MinutesTotalTimeForClean : UDINT; (*Software Output*)
		iPieceCounterBtwCleaningsL1 : INT;
		iPieceCounterBtwCleaningsL2 : INT;
	END_STRUCT;
	StGeneral_States_Blocks : 	STRUCT 
		xBlockAlarmToEmpyBelt : BOOL; (*An alarm in a block is detected asking to Empty Belt*)
		xAnyPrintheadPowered : BOOL; (*Internal state to heater tanks used on alarm PSU*)
		xAnyTankHeaterEnabled : BOOL; (*Internal state to heater tanks used on alarm PSU*)
		xAnyBlockToPrint : BOOL;
		xAnyBarAndBlockReadyToPrint : BOOL;
	END_STRUCT;
	StGeneral_States_StartUp : 	STRUCT 
		Status : StartUpStatus_enum;
		xReadyToAuto : BOOL; (*The startup process has finish and the machine is ready to Auto*)
		xInProgress : BOOL;
	END_STRUCT;
	StGeneral_States_MountedMedia : 	STRUCT 
		rOverThicknessToMounted : REAL; (*The value to consider Mounted media depending on the speed*)
	END_STRUCT;
	StGeneral_States : 	STRUCT 
		Position : StGeneral_States_Position;
		Mode : StGeneral_States_Mode;
		Consent : StGeneral_States_Consent;
		ProductDetect : StGeneral_States_ProductDetect;
		Remote : StGeneral_States_Remote;
		Cleaning : StGeneral_States_Cleaning;
		CleaningBelt : StGeneral_States_CleaningBelt;
		Inks : StGeneral_States_Inks;
		Blocks : StGeneral_States_Blocks;
		Clear : StGeneral_ApplicationBar;
		Color : StGeneral_ApplicationBar;
		White : StGeneral_ApplicationBar;
		StartUp : StGeneral_States_StartUp;
		MountedMedia : StGeneral_States_MountedMedia;
		xBeltRunPrevToClean : BOOL; (*Internal state in printer used on gap and delay line*)
		iAutoModeSW : INT; (*Printer State to sw *)
		iMachineModelCodeSW : INT; (*Printer model to Sw, in function of HW ID code*)
		StateMode : enumEFI_GenMachineState; (*states*)
		AutoMode : stEFI_MachineAutoModes; (*commands*)
		uiLicenseCounter : UINT;
		xStarted : BOOL; (*TRUE if the PLC is running*)
		exec : StGeneral_Excutions;
		HwData : StGeneral_HwData;
		iFaultRunPlc : INT; (*Software Output ??*)
		xMediaDetected : BOOL; (*Media detected before product detect. Detected in Analog or in 3sensors*)
		xRobotReadyToPrint : BOOL;
		xWorkingAsPBF : BOOL; (*An indication of working as PBF is received*)
		iJamDevices : USINT := 0; (*Quantity of Jam Devices installed in the machine*)
		xAbortJobRequest : BOOL;
		xProtectBendedWithPause : BOOL; (*Increase the height of the media inside the machine to protect the printheads*)
		xDoubleLineAllowed : BOOL; (*Machine allows double line printing (depending on objects enabled and line configuration)*)
	END_STRUCT;
	StMachine_ConstantParameters : 	STRUCT 
		rMinTicknessMedia : REAL; (*mm*)
		rMaxTicknessMedia : REAL; (*mm*)
		rMountedMediaLevelInBypassMode : REAL; (*mm*)
		rMaxMountedPieceOverThick : REAL; (*Max value in mm to consider a piece as mounted piece*)
		rMinMountedPieceOverThick : REAL; (*Minimum value in mm to consider a piece as mounted piece*)
		rMinMarginPrinting : REAL; (*mm*)
		rMaxMarginPrinting : REAL; (*mm*)
		rDistanceBeltInitToPd : REAL; (*Distance Between belt init to PD Sensor (mm)*)
		rDistanceThicknesToPD : REAL; (*Distance Between Thicknes Detection To PD Sensor (mm)*)
		iNumBlocks : USINT; (*For writting the number of blocks in a machine*)
		iNumTransVacuum : USINT; (*For writting the number of TransportVacuum in a machine*)
		iNumCuringLeds : USINT; (*Total curing modules in machine*)
		iNumSensorsPerJamDevice : USINT := 4; (*For writing the number of Sensors in each Jam Device*)
		iNumSAIInstalled : USINT; (*Number of SAI installed in machine*)
	END_STRUCT;
	StGeneral_CleanBeltTopPar : 	STRUCT 
		xCleanBeltContinue : BOOL; (*Input software parameter from Sw*)
		xCleanBeltByTiles : BOOL; (*Input software parameter from Sw*)
		xCleanBeltByTime : BOOL; (*Input sw param using time param iCleaningBeltByTime*)
		tiCleaningBeltDuration : TIME; (*Time in seconds. Input software parameter from Sw*)
		tiCleaningBeltByTime : TIME; (*Time in Minutes. Input software parameter from Sw*)
		xCleanBeltForced : BOOL; (*Edge Command. Input software parameter from Sw*)
		iSPTilesToCleanBelt : UINT; (*Input software parameter from Sw*)
	END_STRUCT;
	StGeneral_CleanBeltParameters : 	STRUCT 
		xCleanBeltContinue : BOOL; (*Input software parameter from Sw*)
		xCleanBeltByTiles : BOOL; (*Input software parameter from Sw*)
		xCleanBeltByTime : BOOL; (*Input sw param using time param iCleaningBeltByTime*)
		tiCleaningBeltDuration : TIME; (*Time in seconds. Input software parameter from Sw*)
		tiCleaningBeltByTime : TIME; (*Time in Minutes. Input software parameter from Sw*)
		xCleanBeltForced : BOOL; (*Edge Command. Input software parameter from Sw*)
		iSPTilesToCleanBelt : UINT; (*Input software parameter from Sw*)
		xMoveBackward : BOOL;
		xMoveForward : BOOL;
		iBeltTurns : UINT; (*Number of belt turns cleaning the belt. Just used in UV scenario*)
		xTurbineEnabled : BOOL;
		iBeltSpeed : UINT; (*Speed used to clean the belt. Just used in UV scenario*)
	END_STRUCT;
	StGeneral_CleanParameters : 	STRUCT 
		iCleaningType : INT; (*0: Undefined, 1:Venturi, 2:Turbine    Is not implemented in Control, pending to get from Schneider this functionality*)
		xCleaningBlocksInSeq : BOOL; (*SoftwareInput New Var*)
		xCleanSystemByTime : BOOL; (*Software Input*)
		xEnableCleaningInStopMode : BOOL;
		iPiecesNumberToCleanL1 : INT; (*SoftwareInput*)
		iPiecesNumberToCleanL2 : INT; (*SoftwareInput*)
		xCleanSystemByPieces : BOOL; (*SoftwareInput *)
		tiTimeDelayToCleanL1 : TIME; (*SoftwareInput*)
		tiTimeDelayToCleanL2 : TIME; (*SoftwareInput*)
		tiTimeDelayGapToClean : TIME; (*SoftwareInput*)
		tiCleaningByTime : TIME; (*SoftwareInput*)
		tiToCleanWhenPrinterStopped : TIME; (*Time in minutes*)
		tiBetweenCleaningBlocks : TIME;
		iCleanMotorSpeedBwd : INT; (*Software Input. *)
		iCleanMotorSpeedFwd : INT; (*Software Input. *)
	END_STRUCT;
	StGeneral_ShotParameters : 	STRUCT 
		xShotLine1 : BOOL; (*Edge command bool*)
		xShotLine2 : BOOL; (*Edge command bool*)
		xRepetitionShotLine1 : BOOL; (*State command bool*)
		xRepetitionShotLine2 : BOOL; (*State command bool*)
		tiShotL1 : TIME; (*Input software parameter from Sw*)
		tiShotL2 : TIME; (*Input software parameter from Sw*)
	END_STRUCT;
	StGeneral_CleanBelt : 	STRUCT 
		xCleanBeltMoveFwd : BOOL; (*While this signal is active the motor turns clockwise*)
		xCleanBeltMoveBwd : BOOL; (*While this signal is active the motor turns counter-clockwise*)
		xCleanBeltResetRelay : BOOL; (*Reset belt clean motor relay*)
		xCleanBeltPump : BOOL; (* Set pneumatic pump*)
		xCleanBeltTopScraper : BOOL;
		xStart : BOOL; (*To start clean belt*)
		xPistonFlojet : BOOL; (* Set pneumatic piston*)
	END_STRUCT;
	StGeneral_DtpParameters : 	STRUCT 
		xDoubleLine : BOOL; (*SoftwareInput*)
		iModeLine1 : INT; (*SoftwareInput. 0=RUN 1=BYPASS 2=STOP*)
		iModeLine2 : INT; (*SoftwareInput. 0=RUN 1=BYPASS 2=STOP*)
	END_STRUCT;
	StGeneral_SuctionParameters : 	STRUCT 
		iBlowerMode : INT; (*Suction mode functionality. It can be configured by GUI with Ventrui when is 1 or Turbine when is 2. Parameters received from GUI*)
		tiBlowerDelayOff : TIME; (*Delay time before turning off the turbine in auto mode*)
	END_STRUCT;
	StGeneral_PCsParameters : 	STRUCT 
		xExistPC1 : BOOL; (*Software Input Cmd*)
		xExistPC2 : BOOL; (*Software Input Cmd*)
		xKeepPcsOn : BOOL;
	END_STRUCT;
	StGeneral_UI_Parameters : 	STRUCT 
		xCriticalCondition : BOOL; (*Sw has a critical alarm not controlled by plc*)
		xWarningCondition : BOOL; (*Sw has a warning alarm not acknowledged by plc*)
		xStartPrintButtonActive : BOOL; (*UI main button displays start print option*)
	END_STRUCT;
	StGeneral_ElectronicsParameters : 	STRUCT 
		xPrintServerOK : BOOL; (*Software Input State*)
		xRobotReadyL1 : BOOL; (*SoftwareInput *)
		xRobotReadyL2 : BOOL; (*SoftwareInput*)
		xIsPBF : BOOL;
	END_STRUCT;
	StGeneral_SafetyParameters : 	STRUCT 
		rMountedPieceOverthickness : REAL; (*Software Input. Value in mm*)
		rMarginSafePrint : REAL; (*SoftwareInput. Fix offset to bent tile. The heads go to the thickness measured + this value. Value in mm*)
		rMaxBeltSpeedSetPoint : REAL := 70.0; (*Max speed received from gui in m/min*)
	END_STRUCT;
	StGeneral_CuringParameters : 	STRUCT 
		xCureBySpeed : BOOL; (*Intensity of lamps set depending on machine speed*)
		xOptimizeCuring : BOOL; (*Curing optmitzation mode required*)
		xCureByStretch : BOOL; (*Curing by stretch mode required*)
	END_STRUCT;
	StGeneral_DocumentParameters : 	STRUCT 
		rWidth : REAL; (*Job's document width in mm*)
		rLength : REAL; (*Job's document  length in mm*)
		rOffsetL1 : REAL; (*Job's document offset L1 in mm*)
		rOffsetL2 : REAL; (*Job's document offset L2 in mm*)
	END_STRUCT;
	StGeneral_MediaParameters : 	STRUCT 
		rThickness : REAL; (*Tile thickness to print from gui in mm*)
		rWidth : REAL; (*Board's width in mm*)
		rGap : REAL; (*Gap between boards in mm*)
		rLength : REAL; (*Board's length in mm*)
		rOffsetRegisterL1 : REAL; (*Board's offset L1 in mm*)
		rOffsetRegisterL2 : REAL; (*Board's offset L2 in mm*)
	END_STRUCT;
	StGeneral_LampParameters : 	STRUCT 
		stSerialNumber : STRING[6];
	END_STRUCT;
	StGeneral_CuringLedParameters : 	STRUCT 
		Lamp : ARRAY[0..16]OF StGeneral_LampParameters;
		rPreCuringOffset : REAL := 0.0; (*Pre curing offset set by SW in cm*)
		rPostCuringOffset : REAL := 0.0; (*Post curing offset set by SW in cm*)
	END_STRUCT;
	StGeneral_HwParameters : 	STRUCT 
		iMaxNumPowerMeters : USINT := 2; (*Number of chillers allowed by the printer*)
		iMaxNumChillers : USINT; (*Number of chillers allowed by the printer*)
		iMaxCuringLedBars : UINT; (*Number of curing led bars slots allowed by the printer*)
		rMinPrintPosition : REAL; (*Minimum printing position allowed*)
		iWidth : UINT; (*Machine's printing width in mm*)
		xSuctionModeAllowed : BOOL; (*Machine has a mist collector turbine (suction)*)
		xDoubleLineAllowed : BOOL; (*Active when printer allows double line printing*)
	END_STRUCT;
	StGeneral_HwAncillariesParams : 	STRUCT 
		xInstallFeeder : BOOL;
		xInstallPrimer : BOOL;
		xInstallDryer : BOOL;
		xInstallOverbarnish : BOOL;
		xInstallStacker : BOOL;
	END_STRUCT;
	StGeneral_HwSetBySwParameters : 	STRUCT 
		xInstallThicknessSensor : BOOL; (*Install analog thickness detection system. Active while needed installed*)
		xInstallnSensor : BOOL;
		Ancillaries : StGeneral_HwAncillariesParams;
		iMaxMediaLength : UINT; (*Maximum media length allowed to be loaded in job. In mm*)
	END_STRUCT;
	StGeneral_RemoteParameters : 	STRUCT 
		xSendingJob : BOOL; (*A job is been sent by the previous machine. Bars can go to final position*)
	END_STRUCT;
	StGeneral_SwParameters : 	STRUCT 
		CleanBelt : StGeneral_CleanBeltParameters;
		CleanBeltTop : StGeneral_CleanBeltTopPar;
		Clean : StGeneral_CleanParameters;
		Shot : StGeneral_ShotParameters;
		Dtp : StGeneral_DtpParameters;
		Suction : StGeneral_SuctionParameters;
		PCs : StGeneral_PCsParameters;
		UI : StGeneral_UI_Parameters;
		Electronics : StGeneral_ElectronicsParameters;
		Safety : StGeneral_SafetyParameters;
		Document : StGeneral_DocumentParameters;
		Media : StGeneral_MediaParameters;
		Hw : StGeneral_HwSetBySwParameters;
		Remote : StGeneral_RemoteParameters;
		Curing : StGeneral_CuringParameters;
		xAutoStartEnabled : BOOL; (*The autostart process is enabled*)
		iFaultComPcPlc : INT; (*Software Input State*)
		rMarginPrint : REAL; (*SoftwareInput, jetting gap in mm*)
		xMachineDirection : BOOL; (*0: Derecha 1: Izquierda*)
		rFirstHeadPosition : REAL;
		rLastHeadPosition : REAL;
		tiDelayConsent : TIME; (*Used on kernel to PLC. Time in seconds*)
		iNumCopies : UDINT; (*Number of boards in a job. Can be changed on the fly.*)
		rBeltSpeedSetPoint : REAL := 20.0; (*Speed in m/min. Input parameter from SW*)
		xDegasser : BOOL;
		xJamDetectEnable : BOOL; (*Jam Detection Enabled*)
	END_STRUCT;
	StGeneral_MediaParams : 	STRUCT 
		iMaxMediaWidth : UINT; (*Maximum media width allowed in mm*)
		iMinMediaWidth : UINT; (*Minimum media width allowed in mm*)
		iMaxMediaLength : UINT := 3000; (*Maximum media length allowed in mm*)
		iMinMediaLength : UINT; (*Minimum media length allowed in mm*)
		rMaxMediaThickness : REAL; (*Maximum media thickness allowed in tenths of mm*)
		rMinMediaThickness : REAL; (*Minimum media thickness allowed in tenths of mm*)
	END_STRUCT;
	StGeneral_CleanParams : 	STRUCT 
		xEnabledCleanTotalTime : BOOL := FALSE; (*Enabled cleaning machine if total time counted without cleaning. Currently 24h*)
		xCleanBeltTopInstall : BOOL := FALSE; (*Cleanning Belt Scrapper System Installed*)
		xCleanBeltWater : BOOL; (*Cleaning belt system for Noz2 water*)
		xCleanBeltForUv : BOOL := FALSE;
	END_STRUCT;
	StGeneral_VacuumParams : 	STRUCT 
		xStartBlowerGoingToPrint : BOOL; (*Start the blowers when in production and going to print*)
		xTransVacuumIndependenParams : BOOL; (*TRUE: Each TransVacuum with different parameters. FALSE: TransVacuum[1] copied to the rest of elements*)
	END_STRUCT;
	StGeneral_CureParams : 	STRUCT 
		xCuringByStretchAllowed : BOOL; (*CuringByStretch functionality IS allowed in this machine*)
		xForceMaxWidth : BOOL; (*Force to cure with max width instead of using data from media coming from Sw*)
	END_STRUCT;
	StGeneral_DynMountedMedia : 	STRUCT 
		rSpeedMaxMounted : REAL; (*Value in m/min*)
		rSpeedMinMounted : REAL; (*Value in m/min*)
		rMaxOverThickMounted : REAL; (*Value in mm*)
		rMinOverThickMounted : REAL; (*Value in mm*)
	END_STRUCT;
	StGeneral_MountedMedia : 	STRUCT 
		Type : ThicknessMountedDetectionType; (*Mounted Type in machine*)
		Dynamic : StGeneral_DynMountedMedia;
		xDynamicMountedMedia : BOOL; (*Configured Dynamic mounted media*)
	END_STRUCT;
	StGeneral_ProductDetectParams : 	STRUCT 
		xDisableBrokenSensor : BOOL;
	END_STRUCT;
	StGeneral_Parameters : 	STRUCT 
		CT : StMachine_ConstantParameters; (*Printer input constants params*)
		ConfigName : STRING[80];
		ConfigNameID : USINT := 0; (*Identification of the Configuration been executed*)
		CommsType : CommsType_enum; (*Comms protocol used to communicate with kernel*)
		MachineModel : MachineModel_enum; (*HW ID codes are defined here*)
		PDSignalTpe : ProductDetectSignal_enum;
		Media : StGeneral_MediaParams;
		Clean : StGeneral_CleanParams;
		ProductDetect : StGeneral_ProductDetectParams;
		Vacuum : StGeneral_VacuumParams;
		Cure : StGeneral_CureParams;
		MountedMedia : StGeneral_MountedMedia;
		xControlledByLine : BOOL; (*Define if the machine is controlled by a LineManager*)
		xControlledRemotely : BOOL; (*Define if the machine is controlled by an external device. eCommerce*)
		xAllowLaboratory : BOOL; (*Define if the machine allows laboratory behabior or not*)
		xAllowAutoStartUp : BOOL; (*The autostart process is allowed in the machine*)
		xDynamicPrePrintingPos : BOOL; (*The preprinting position is assigned in orders, not in assign data*)
		xJobNotReadyIsCritical : BOOL; (*Active whether machine have to stop when detecting media but no job is ready to be printed*)
		xAllowJamRecovery : BOOL; (*Define if the machine allows JamRecovery behabior or not*)
		xDisableStartHoldingGreenButton : BOOL; (*Disable start production with a long press of Green Button in machine*)
		xLeftHandMachine : BOOL; (*Software Output*)
		xRightHandMachine : BOOL; (*Software Output*)
		rMaxPrintHeadPos : REAL; (*Maxium Print HEad Position to SW in mm*)
		rMinPrintHeadPos : REAL; (*Minium Print HEad Position to SW in mm*)
		xProtectPHForBlowersRunning : BOOL; (*Required to protect the print heads from vacuum drying*)
		tiTimeToRaiseBars : TIME := T#5m; (*Required to protect the print heads from tile bending*)
		xProtectPHWithStoppedMediaBended : BOOL; (*Required to protect the print heads from tile bending*)
		rBeltSpeedWhileEmptyBelt : REAL;
		iMediaFilter : UINT; (*Filter to be used to consider real media detected by PD sensor (Cm)*)
		MachineLights : MachineLights_enum;
		Hw : StGeneral_HwParameters;
	END_STRUCT;
	stGeneral_SerialNumberCommands : 	STRUCT 
		xExecute : BOOL; (*EDGE*)
		SerialNumber : STRING[80]; (*Serial number of the machine*)
	END_STRUCT;
	stGeneral_ResetCpuCommands : 	STRUCT 
		xExecuteReset : BOOL; (*EDGE*)
		AutorizationCode : STRING[80]; (*Autorization code. h98o76. Deleted after reset*)
	END_STRUCT;
	stGeneral_commandsRemote : 	STRUCT 
		xStartBlowers : BOOL; (*Order to Start the blowers. Received from RemoteMachine. It will be falled when out of Auto.Stop*)
	END_STRUCT;
	stGeneral_commands : 	STRUCT 
		xAllToCap : BOOL; (*Use as EDGE CommandBool used to send all block to cap. Reseted in program. Line can use it*)
		xAllToPrint : BOOL; (*Use as EDGE CommandBool used to send all block to print. Reseted in program. Line can use it*)
		xResetRouter : BOOL;
		xResetCB : BOOL;
		xResetStrobePdDiff : BOOL; (*Use as EDGE CommandBool. Reseted in program*)
		xCompenserLine1 : BOOL;
		xCompenserLine2 : BOOL;
		xStop : BOOL;
		xRunBelt : BOOL;
		xClean : BOOL;
		ResetCpu : stGeneral_ResetCpuCommands;
		SerialNumber : stGeneral_SerialNumberCommands;
		CleanBelt : StGeneral_CleanBelt;
		Remote : stGeneral_commandsRemote;
	END_STRUCT;
	StGeneral_AutoCommands : 	STRUCT  (*COMMANDS GENERATED INTERNALLY BY CODE, NOT EXTERNALLY*)
		iAutoMode : enumEFI_MachineAutoStatesMode; (*Internal variable to manage AUTOMATIC modes in printer RU,BUPASS, LAB AND STOP*)
		xCleanningByPiecesL1 : BOOL; (*CommandBool state to set cleaning cycle in L1*)
		xCleanningByPiecesL2 : BOOL; (*CommandBool state to set cleaning cycle in L2*)
		xCleanningByExtOrder : BOOL; (*Internal command from external input state to set/enable a cleaning cycle by external order input*)
		xCleanningByTimeProd : BOOL; (*CommandBool state to set cleaning cycle L1 or L2 by time in Production*)
		xCleanningByTotalTime : BOOL; (*CommandBool state to set cleaning cycle by total time after no cleaning*)
		xCleanningByTimeInStopMode : BOOL; (*CommandBool state to set cleaning cycle L1 or L2 by time when block is in cap position*)
		xMuteAlarms : BOOL; (*Edge commandBool used to mute all alarms*)
		xToCap : BOOL; (*Edge commandBool used to send all block to cap*)
		xToPrint : BOOL; (*Edge commandBool used to send all block to print*)
		xReset : BOOL; (*Internal bool used on printer to set state RESET in printer*)
		xStart : BOOL; (*Edge Command to Start the Machine. By button or an specific order from Sw*)
		xStop : BOOL; (*Edge Command to Stop the Machine. By button or an specific order from Sw*)
		xToSafePosition : BOOL; (*ComandBool state to move bars to Safe postion near of print to protect printheads from bended parts or vacuum drying*)
		xCleanModbus : BOOL; (*Order to clean Modbus registers. Usually when a PLC version is detected*)
		xCleanBelt : BOOL; (*Order to clean Modbus registers. Usually when a PLC version is detected*)
	END_STRUCT;
	StGeneral_AlarmsList : 	STRUCT 
		xAlrTurbinForCleaning : BOOL; (*Pending to remove in 4.3.6*)
		xAlarmPlarformInc : BOOL; (*AlarmCritical*)
		xAlarmSAIPowerOff : BOOL; (*AlarmCritical - SAI is near to power off*)
		xAlarmAir1 : BOOL; (*AlarmStop*)
		xAlarmComPcPLC : BOOL; (*AlarmStop*)
		xAlarmMountedPiece : BOOL; (*Resume next *)
		xAlarmMountedPieceBypassMode : BOOL; (*AlarmStop*)
		xAlarmNotInPrintPosition : BOOL;
		xAlarmEnableWithoutBarsOn : BOOL;
		xNoActionDangerCollision : BOOL; (*Resume alarms*)
		xNoActionAlarmExist : BOOL; (*Resume alarms*)
		xHeaterTankPsu : BOOL; (*Resume alarms*)
		xPDBrokenSensorL1 : BOOL; (*Product Detect Line 1 Broken or Desconected*)
		xPDBrokenSensorL2 : BOOL; (*Product Detect Line 2 Broken or Desconected*)
		xAlrThicknSystemNotSelected : BOOL; (*Thickness detection system not selected.*)
		xAlarmSAIPowerFault : BOOL; (*Power main suply switch off*)
		xAlr24Vdc : BOOL; (*24VDC Power IDS supply switc off*)
		xAlrWrongPhysConf : BOOL; (*Alarm Critical: Wrong physical configuration or some tarjet are disconected*)
		xAlrDingWrongPosition : BOOL; (*StopAlarm: with product detectt signal without previuos ding signal*)
		xSwCriticalCondition : BOOL; (*Sw is in a critical condition to execute printing process*)
		xNotLoadedImage : BOOL; (*This alarms is an Stop alarm in machines without line. In machines with line, it is a critical alarm for the line*)
		xNoPowered : BOOL; (*This alarm is raised when machine's power switch is not active*)
		xAlrWidthOutLimits : BOOL; (*Parsw media width out of limits*)
		xAlrLengthOutLimits : BOOL; (*Parsw media length out of limits*)
		xAlrThickOutLimits : BOOL; (*Parsw media thickness out of limits*)
		xAlrSafetyNotEnabled : BOOL; (*Printer safety enables nok*)
	END_STRUCT;
	StGeneral_WarningsList : 	STRUCT 
		xStopInAuto : BOOL; (*Review*)
		xValidConfiguration : BOOL; (*Review*)
		xSAIFault : BOOL;
		xSAILowBat : BOOL;
		xSAIBypass : BOOL;
		xExternalCleanActive : BOOL;
		xMaxMovsBentTile : BOOL;
		xNotLoadedImage : BOOL; (*Just stopping the belt. Used in ceramics, where we can load image with the belt stopped and restart production*)
		xBentTile : BOOL;
		xPCCabineSensAlrm : BOOL;
		xMountedMediaInside : BOOL;
		xMediaStoppedInside : BOOL;
		xCleanCylinderNotInHighPosition : BOOL;
		xCleanBeltRelayFaulted : BOOL;
		xBeltCleanRequired : BOOL;
		xCleanBeltSystemNotInPosition : BOOL;
		xPbfCardNotOK : BOOL;
		xUpNotConsent : BOOL; (*Resume alarms*)
		xNoCleaningModeEnabled : BOOL; (*Warning: No pressure on degasser circuit*)
		xAlrDegasserPressure : BOOL; (*Warning: No pressure on degasser circuit*)
		xMediaIncoherenceDetectedL1 : BOOL; (*Active when product detect sensor detects media but detection system has not. L1*)
		xMediaIncoherenceDetectedL2 : BOOL; (*Active when product detect sensor detects media but detection system has not. L1*)
		xBeltCleanTurbNotAvail : BOOL; (*VSD ACS380 ok feedback signal not present NOZOMITWO-1912*)
		xWasteInkTankMaxLevelReached : BOOL;
		xOvervoltage : BOOL; (*Warning alarm*)
		xImageLoadedButNoInkBarRelated : BOOL; (*This alarm is raised when image is loaded but no bar has been assigned to that job. Related to status "ColorLoadedInJob"*)
		xErrorAntiStatic : BOOL; (*Antistatic device in error*)
		xIonAntiStatic : BOOL; (*Wastage of the antistatic device electrodes*)
		xAlrHoopersSoftStarterFault : BOOL; (*Warning alarm*)
	END_STRUCT;
	StGeneral_Alarms : 	STRUCT 
		Warning : StGeneral_WarningsList;
		Alarm : StGeneral_AlarmsList;
		xAlrDisableGoToProduction : BOOL;
		xAlrSafetySystemEStop : BOOL; (*SLX DI 10 is enable transport from safety progam*)
		xAlarmSound : BOOL;
	END_STRUCT;
	StGeneral_Log : 	STRUCT 
		ManualChg : DINT;
		AutoChg : DINT;
		ManualHrs : DINT;
		AutoHrs : DINT;
		VdcHrs : DINT;
		DateStart : DINT;
		udiPiecesCounterErrorL1 : UDINT; (*PD Detection Counter Failed L1*)
		udiPiecesCounterErrorL2 : UDINT; (*PD Detection Counter Failed L2*)
		udiPiecesCounterL1 : UDINT;
		udiPiecesCounterL2 : UDINT;
		diPiecesCounterStrobe : DINT;
		iDiffPiecesStrobeProductDetect : INT; (*Difference of quantity in Product detect signals minus the strobe signals*)
		udiTileCounterBalluffLaser : UDINT; (*Program in mode active..end*)
		udiTileCounterTriggerLaser : UDINT; (*Program in mode active..end*)
		udiDifCounters : UDINT; (*Program in mode active..end*)
		iTilesCounterToClean : UINT;
		iTilesCounterToCleanBeltTop : UINT;
	END_STRUCT;
	StGeneral_Outputs_CleanBelt : 	STRUCT  (*Outputs for cleanbelt*)
		xAirTurbineVSDReset : BOOL; (*Output signal to reset the VSD of the air turbine NOZOMITWO-1912*)
		xAirTurbine : BOOL; (*Output signal to start the air turbine NOZOMITWO-1912*)
	END_STRUCT;
	StGeneral_Outputs : 	STRUCT 
		xResetHub : BOOL;
		xResetSwitch : BOOL;
		xResetRouter : BOOL;
		xResetCB1 : BOOL;
		xResetCB2 : BOOL;
		xPC1Start : BOOL;
		xPC2Start : BOOL;
		xRedLight : BOOL;
		xYellowLight : BOOL;
		xWhiteLight : BOOL;
		xBlueLight : BOOL;
		xGreenLight : BOOL;
		xBuzzerButtonPanel : BOOL;
		xConsentL1 : BOOL;
		xConsentL2 : BOOL;
		xCompenserLine1 : BOOL;
		xCompenserLine2 : BOOL;
		xLine1ReadyToClean : BOOL;
		xLine2ReadyToClean : BOOL;
		xSuctionTurbine : BOOL;
		xLightReset : BOOL;
		xAirSupply : BOOL;
		xCoolingPCStart : BOOL;
		iRelief1 : UINT; (*Signal of the Relief readed in line 1*)
		iRelief2 : UINT; (*Signal of the Relief readed in line 2*)
		xShotLine1 : BOOL; (*Output For InstantPrint/ContinuousPrint signal from PLC to Carriage*)
		xShotLine2 : BOOL; (*Output For InstantPrint/ContinuousPrint signal from PLC to Carriage*)
		xRemoteTeachL1 : BOOL;
		xRemoteTeachL2 : BOOL;
		xDegasser : BOOL;
		CleanBelt : StGeneral_Outputs_CleanBelt;
		iTimeBlockAtSafePosition : UINT; (*Counter to acknowledge how many times block has been lifted to safe position*)
		xAntiStaticPOn : BOOL; (*Power on the antistatic device*)
	END_STRUCT;
	StGeneral : 	STRUCT 
		In : StGeneral_Inputs;
		St : StGeneral_States;
		Pt : StGeneral_Parameters;
		parSw : StGeneral_SwParameters; (*Software params*)
		commands : stGeneral_commands;
		commandsSw : stGeneral_Inputs_Sw; (*All this commands are Edge commands. Reseted at the end of Machine_Fast*)
		AutoCmd : StGeneral_AutoCommands;
		AlSummary : stEFI_AlarmSummary;
		Al : StGeneral_Alarms;
		Lg : StGeneral_Log;
		Out : StGeneral_Outputs;
	END_STRUCT;
END_TYPE
