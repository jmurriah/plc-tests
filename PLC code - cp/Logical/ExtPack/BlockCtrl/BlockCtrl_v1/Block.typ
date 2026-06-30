
TYPE
	Block_States_enum : 
		(
		BLOCK_STOPPED,
		BLOCK_STOPPING,
		BLOCK_MANUAL,
		BLOCK_AUTO
		);
	Block_Position_enum : 
		(
		BLOCKP_UNDEFINED,
		BLOCKP_IN_CAP,
		BLOCKP_IN_PRINT,
		BLOCKP_IN_CLEAN,
		BLOCKP_CLEANING,
		BLOCKP_GOING_TO_CAP,
		BLOCKP_GOING_TO_PRINT,
		BLOCKP_GOING_TO_CLEAN,
		BLOCKP_HOMING_ICLA,
		BLOCKP_HOMING_BAR
		);
	StBlock_Outputs : 	STRUCT 
		xTrayOut : BOOL;
		xTrayIn : BOOL;
		xVenturi : BOOL;
		xShotLine1 : BOOL; (*Output For InstantPrint/ContinuousPrint signal from PLC to Carriage*)
		xShotLine2 : BOOL; (*Output For InstantPrint/ContinuousPrint signal from PLC to Carriage*)
		xEnableDobleShot : BOOL; (*Review*)
		xEnableDrive : BOOL;
		xEnableIclaSI : BOOL;
		xEnableCurtain : BOOL;
		xCleaningWaterPump : BOOL; (*Water Pump to Celaning PrintHeads*)
		xWastedInkTankPump : BOOL; (*Pump to remove wasted ink from wasted ink's tank*)
		xCappingWaterPump : BOOL; (*Water Pump to Celaning PrintHeads*)
		xDegasser : BOOL;
		xTurbine : BOOL; (*Cleanning by turbine order*)
	END_STRUCT;
	StBlock_Log : 	STRUCT 
		diMoveARelCounter : DINT;
		diMoveAbsCounter : DINT;
		diHomingsNumber : DINT;
	END_STRUCT;
	StBlock_Alarms : 	STRUCT 
		xAlrSafetySystemInBlock : BOOL; (*CriticalAlarm*)
		xAlrDif : BOOL; (*CriticalAlarm*)
		xAlrTempPowerSupply : BOOL; (*Warning:Heater Power Supply Failure*)
		xAlrPHPowerSupply : BOOL; (*Warning:Print Head Power Supply Failure*)
		xAlrDriveProtection : BOOL; (*CriticalAlarm*)
		xAlAirVenturi : BOOL; (*StopAlarm*)
		xModuleTemp01 : BOOL; (*CriticalAlarm*)
		xModuleTemp02 : BOOL; (*CriticalAlarm*)
		xModuleTemp03 : BOOL; (*CriticalAlarm*)
		xModuleTemp04 : BOOL; (*Critical Alarm*)
		xSiUnitPowerOff : BOOL; (*CriticalAlarm*)
		xAlrComSiUnit : BOOL; (*CriticalAlarm*)
		xAlCleanInterrupt : BOOL; (*StopAlarm*)
		xAlrCleanMotor : BOOL; (*CriticalAlarm *)
		xAlrCleanMtrNoRef : BOOL; (*CriticalAlarm *)
		xAlrComCleanMtr : BOOL; (*CriticalAlarm *)
		xAlrDecreaseCleanOffset : BOOL; (*Warning*)
		xAlrIncoherPositCleanMtr : BOOL; (*CriticalAlarm *)
		xAlrEnabCleanMtrDiffLvL : BOOL; (*CriticalAlarm *)
		xAlrTraySensor : BOOL; (*CriticalAlarm *)
		xAnyDriveAlarmLimitMax : BOOL; (*CriticalAlarm *)
		xAlrBarMtrNoRef : BOOL; (*CriticalAlarm *)
		xAlrCleanSensor : BOOL; (*CriticalAlarm                 L59,LC Barras*)
		xAlrComBarMtr : BOOL; (*CriticalAlarm *)
		xExitCleaningCycle : BOOL; (*Silvia*)
		xAnyVerticalDriveAlarm : BOOL; (*CriticalAlarm *)
		xAnyIclaAlarm : BOOL; (*CriticalAlarm *)
		xAlrNoTrayInServoNoHomed : BOOL; (*Warning. Derived alarm*)
		xAlrRearSafety : BOOL; (*Rear Door Open Alarm*)
		xAlrFrontSafety : BOOL; (*Front Door Open Alarm*)
		xAlrFrontEmergencyStop : BOOL;
		xAlrRearEmergencyStop : BOOL;
		xAlrFrontCurtain : BOOL;
		xAlrCrossSensorDetectBottom : BOOL;
		xAlBarMotorPowerOff : BOOL;
		xAlrReferenceIncoherence : BOOL; (*CriticalAlarm*)
		xAlrRearSafetyCircuit : BOOL;
		xAlrFrontSafetyCircuit : BOOL;
		xAlrBlockReachedMaxPosition : BOOL;
		xNoActionDangerCollision : BOOL; (*Some sensor signal not  OK, so no movement allowed*)
		xAlrWaterPumpPresure : BOOL; (*Pump working but not pressure measured. Alarm non Autoreset*)
		xAlrEmptyWaterTank : BOOL;
		xAlrWtrPresSensBroken : BOOL;
		xAlrBarsOut : BOOL;
		xBarMotorTemp : BOOL; (*Warning: Bar Motor Temperature Too Hot*)
		xBarDriverTemp : BOOL; (*Warning: Bar Driver Temperature Too Hot*)
		xAlrCheckHomingSensor : BOOL; (*Warning: Bar Homing Sensor Maybe Broken*)
		xAlrLogicEmergencyStop : BOOL; (*Emergency button pushed without diferenciating front or rear. Calculated from NOT SafetyOK and everything ready (doors and lightCourtains)*)
		xAlrEmergencyStop : BOOL; (*Any Emergency button pushed. Aggregated alarm*)
		xAlrCappingWaterTankEmpty : BOOL;
		xAlrCappingWaterNotRecirc : BOOL; (*Emergency button pushed without diferenciating front or rear*)
		xAlrControllerNotReady : BOOL; (*Critical: Controller of the Drive not Ready. Usually motor not conected to drive*)
		xAlrOverTorque : BOOL;
		xWrnOverTorq : BOOL; (*Warning: Belt Over Torque*)
		xCleanMotorControllerNotReady : BOOL; (*Waiting for enable input (STO_A, STO_B)*)
	END_STRUCT;
	stBlock_commandsManual : 	STRUCT 
		xManBarsUp : BOOL; (*Command just in manual mode*)
		xManBarsDown : BOOL; (*Command just in manual mode*)
		xManIclaForward : BOOL; (*Command just in manual mode*)
		xManIclaBack : BOOL; (*Command just in manual mode*)
		xManTrayOut : BOOL; (*Command just in manual mode*)
		xManTrayIn : BOOL; (*Command just in manual mode*)
		xManVenturi : BOOL; (*Command just in manual mode*)
		xManWaterSpurt : BOOL; (*Command just in manual mode*)
		xManCappingWaterPump : BOOL; (*Command just in manual mode*)
		xManWastePump : BOOL; (*Command just in manual mode*)
		xToPrintPosition : BOOL; (*EDGE Command just in Man mode. Sends the block to PrintPosition if previously in Cap*)
	END_STRUCT;
	stBlock_commands : 	STRUCT 
		Mode : StGeneral_States_Mode;
		StateMode : enumEFI_GenMachineState; (*commands to block*)
		AutoMode : stEFI_MachineAutoModes; (*commands to inform belt*)
		Manual : stBlock_commandsManual;
		xDripControl : BOOL; (*internal orders in structure? Tthat sould be internal variables as orders. TOJMH: when? *)
		xBarHomeOrder : BOOL; (*State Command just in manual mode*)
		xIclaHomeOrder : BOOL; (*Command just in manual mode*)
		xIclaHomeOrderInterrupt : BOOL; (*Command just in manual mode*)
		xToPrint : BOOL; (*Command just in AUTO mode*)
		xToCap : BOOL; (*Command just in AUTO mode*)
		xToCleanPosition : BOOL; (*EDGE Command just in Man mode. Sends the block to CleanPosition if previously in Cap*)
		xToPrintLab : BOOL; (*EDGE Command. Reseted manually in Block*)
		xToCapLab : BOOL; (*EDGE Command. Reseted manually in Block*)
		xStartToCleanOrder : BOOL; (*EDGE. Reseted by Block. Command just in AUTO mode: The machine raises*)
		xInksOrderCleaning : BOOL; (*Command just in AUTO mode: to activate reverse flow in cap position (automatic before drip and every 30 min)*)
		xMute : BOOL; (*Command Bool mute sound*)
		xReset : BOOL; (*Command Bool Reset*)
		xEnableCleaningWithWater : BOOL; (*Command Bool Enable Cleaning Water Proces*)
		xCleanStop : BOOL; (*Comand to Stop Clean*)
		xForcePreprintingPos : BOOL; (*Comand to Force preprinting position*)
		xForceCleanDelay : BOOL; (*Comand to Clean Block With Delay*)
		xForceCleanNoDelay : BOOL; (*Comand to Clean Block Without Delay*)
	END_STRUCT;
	StBlock_Parameters_Inks : 	STRUCT 
		iMaxPSUwattsForBars : UINT := 200; (*This parameter allows changes on PSU max to calculate different factor redutor. Value in watts*)
		iMaxBlockPrintBars : USINT := 6; (*To allow indentify if the bars belongs to the block*)
		iMaxMachinePrintBars : USINT := 12; (*Interger is compared with integers, it avoids warning. This var is used but is pending to implement limits.... take care!!*)
		xTankHeatEnabled1 : BOOL := FALSE; (*Bar 1, 2, 3 or 4 have tank heater enabled*)
		xTankHeatEnabled2 : BOOL := FALSE; (*Bar 5, 6, 7, or 8 have tank heater enabled*)
	END_STRUCT;
	StBlock_Parameters_Icla : 	STRUCT 
		DriveUnit : MC_DriveUnitManager;
		rPositionCleanMotorBwd : REAL; (*Position in mm*)
		rPositionCleanMotorFwd : REAL; (*Position in mm*)
		iMaxSpeedCleanMotorBwd : INT;
		iMaxSpeedCleanMotorFwd : INT;
		iMinSpeedCleanMotorBwd : INT;
		iMinSpeedCleanMotorFwd : INT;
		iCleanMotorSpeedBwd : INT; (*Software Input from a machine value*)
		iCleanMotorSpeedFwd : INT; (*Software Input from a machine value*)
		rMinPrintHeadPos : REAL; (*Minium Print Head Position. Configuration of the machine in mm*)
		rFirstHeadPosition : REAL; (*Software Input. Position of first printhead in mm. Input from a machine value*)
		rLastHeadPosition : REAL; (*Software Input. Position of first printhead in mm. Input from a machine value*)
	END_STRUCT;
	StBlock_Parameters_Motor : 	STRUCT 
		DriveUnit : MC_DriveUnitManager;
		rPrintPosition : REAL; (*Input from LC Band. Value in mm*)
		rDriveManSpeed : REAL; (*Vertical motor manual speed. Value in mm/s*)
		rDriveAutoSpeed : REAL; (*Vertical motor automatic speed. Value in mm/s*)
		rCappingPosition : REAL; (*Capped position in mm*)
		rCapPosition : REAL; (*Capped position in mm*)
		rCleanPosition : REAL; (*Clean position in mm*)
		rSafePosition : REAL; (*Position in mm*)
		rMinSafePosition : REAL; (*Position in mm*)
		rWaterSpurtPosition : REAL; (*Position in mm*)
		rSafeMarginForwardTray : REAL; (*Offset para la posicion de seguridad del carro de limpieza. Value in mm*)
		rSafePositionCleanCarrier : REAL; (*Position in mm*)
		rDripBarsPosition : REAL; (*Position in mm*)
		rReferencePosition : REAL; (*Reference Position in mm*)
		rMinThicknessMedia : REAL; (*Minimum media thickness in mm*)
		VerticalDirection : MotorDirection_enum; (*To indicate that the motor must spin in reverse*)
		uiMaxCurrentBarsUp : UINT;
		uiMaxCurrentBarsDown : UINT;
		rReduceSpeedDistance : REAL; (*Distance to the limit to reduce manual speed*)
		rMinCleanOffsetTech : REAL; (*Minimum Cleaning offset by the Technician in mm*)
		rMaxCleanOffsetTech : REAL; (*Maximum Cleaning offset by the Technician in mm*)
		rAcceleration : REAL;
		rDeceleration : REAL;
		xFastSpeedAllowed : BOOL; (*Use of fast speed is allowed*)
		rAutoSpeedMoveUpFast : REAL; (*Bars motor speed to move up fast. Used while in printing to raise position quickly*)
		rAutoSpeedMoveUp : REAL := 50; (*Bars motor speed to move up*)
		rAutoSpeedMoveDown : REAL := 15; (*Bars motor speed to move down*)
		xOversized : BOOL; (*Variable to define motor's operation torque is much lower than the rated torque*)
		rOperationTorque : REAL; (*Motor's operation torque in Nm*)
	END_STRUCT;
	StBlock_SwParameters : 	STRUCT 
		xEnableToMovements : BOOL; (*Block is enalbed to movements and doesnt go to print if order is received,  Cleaning? *)
		xEnableToPrint : BOOL; (*Block is enalbed to print and it goes to print if order is received,*)
		rOffsetPrintMotor : REAL; (*Software Input. Printer description, advanced (adjust the motor block position)*)
		rOffsetCleanMtrAdjust : REAL; (*SoftwareInput. Value in mm*)
		rOffsetCleanMtrOperatr : REAL; (*SoftwareInput. Value in mm*)
	END_STRUCT;
	StBlock_Parameters_Hw : 	STRUCT 
		xExistBlock : BOOL;
		xThereIsInTraySensor : BOOL;
		xIsWater : BOOL;
		SafetySignals : enumEFI_SafetySignals;
		ValvesNode : USINT;
		ValvesCommsType : CommsNetworkType_enum;
		iNumHeaterPSU : USINT;
		iNumPrintheadsPSU : USINT;
	END_STRUCT;
	StBlock_Parameters : 	STRUCT 
		Motor : StBlock_Parameters_Motor;
		Icla : StBlock_Parameters_Icla;
		Inks : StBlock_Parameters_Inks;
		Hw : StBlock_Parameters_Hw;
		tiTimeWaitTrayOutAlarm : TIME; (*Time to position beside headers*)
		tiTimeWaitTrayOut : TIME; (*Time to position beside headers*)
		tiTimeWaitTrayInAlarm : TIME; (*Time to position under headers*)
		tiTimeWaitTrayIn : TIME; (*Time to position under headers*)
		iIclaAxisIndex : USINT; (*Index of the Icla motor to assign it*)
		iMotorAxisIndex : INT; (*Index of the vertical motor to assign it*)
		xPrinterKeyMaintenanceActivated : BOOL; (*Maintenance key activated*)
		xMediaBelow : BOOL; (*The machine send the information that there are media below block*)
		iMappingBlock : INT; (*Defining the physical position of the block. 1= BlockA 2=BlockB*)
		xLeftHandMachine : BOOL; (*To indicate that the machine is left hand.*)
		xRightHandMachine : BOOL; (*To indicate that the machine is right hand.*)
		iFirstBlock : USINT := 1; (*The first block is the number 1 by default*)
		iLastBlock : USINT := 2; (*The second block is the number 2 by default*)
		rManPrintingPos : REAL := 10.0; (*Printing position for manual operation*)
		rPrePrintingPos : REAL; (*Safe printing position in machines with vacuum to protect printheads*)
		iFirstBarPosition : UINT;
		iLastBarPosition : UINT;
		xMotorOffsetAllowed : BOOL; (*Printing position may be modified by using Block.parSw.rOffsetPrintMotor when this variable is activated*)
		xWastedInkTankProcess : BOOL;
		xCappingProcess : BOOL;
		uiCleaningType : USINT; (*0: Undefined  1: Venturi   2: Turbin*)
		iApplicationBars : USINT; (*Number of physical bars that can work for application purposes (inks, curing, ...)*)
	END_STRUCT;
	StBlock_IclaStatus : 	STRUCT 
		iIclaState : INT; (*Drive status state machine Icla*)
		xInError : BOOL;
		xHomed : BOOL;
		xIsMoving : BOOL;
		xHoming : BOOL;
		rCurrentPosition : REAL; (*Current position in mm*)
		iSpeed : INT; (*//TODO: Define the units of the speed*)
		iMaxSpeed : INT;
		iIntensityCleanMotor : INT;
		ErrorNumber : UINT;
		rActTemp : REAL; (*Actual temperature*)
		rMaxTemp : REAL;
		rActTorque : REAL;
		rMaxTorque : REAL;
	END_STRUCT;
	StBlock_MotorStatus : 	STRUCT 
		xBarsHomed : BOOL;
		xBarsHoming : BOOL;
		ActPosition : UDINT; (*Actual Position of the motor in Motor units*)
		iIntensityVertMotor : INT;
		rMotorAbsPosDesired : REAL;
		rActTemp : REAL; (*Actual temperature*)
		rSpeed : REAL;
		rMaxTemp : REAL;
		iActTorque : INT;
		rRatedTorque : REAL;
		rActTorque : REAL;
		rMaxTorque : REAL;
		rActVelocity : REAL;
		rMaxVelocity : REAL;
		xEnableUp : BOOL;
		xEnableDown : BOOL;
		ErrorID : UINT; (*ErrorID of any occurred error*)
		rOperationTorque : REAL; (*Motor's operation torque*)
	END_STRUCT;
	StBlock_StatusPosition : 	STRUCT 
		xUndefined : BOOL;
		xInCap : BOOL;
		xInPrint : BOOL;
		xInClean : BOOL; (*In Clean position. Arrived in Manual*)
		xCleaning : BOOL;
		xGoingToCap : BOOL;
		xGoingToPrint : BOOL;
		xGoingToClean : BOOL;
		xReadyToPrint : BOOL; (*In print postion without safe offsets position*)
	END_STRUCT;
	StBlock_Status : 	STRUCT 
		iBlockCaseLogicControl : INT; (*nState logic control*)
		iBlockState : INT; (*Value to send to Sw: 0=NO_AUTO, 1=IN_CAP, 2=IN_PRINT, 3=CLEANING, 4=GOING_TO_CAP, 5=GOING_TO_PRINT*)
		xEnabledMovements : BOOL;
		xAnyManualMovement : BOOL;
		BlockState : Block_States_enum := BLOCK_STOPPING;
		PositionState : Block_Position_enum := BLOCKP_UNDEFINED;
		Position : StBlock_StatusPosition;
		xCleaningDone : BOOL; (*EDGE*)
		xCapOrderDuringCleaning : BOOL;
		xEnabledToPrint : BOOL;
		xEnabledToClean : BOOL;
		xIsWaterBlock : BOOL; (*This Block Is Water*)
		xAlarmToEmptyBelt : BOOL; (*This Block has an alarm that requires to empy the belt*)
		iBarsReadyToPrint : INT;
		rMotorPosition : REAL; (*To Software. Value in mm*)
		execTimes : UDINT;
		Motor : StBlock_MotorStatus;
		Icla : StBlock_IclaStatus;
		ManualCommands : StBlock_Outputs;
		iTemperature : INT; (*Ambient temperature measured (-40..60 ºC)*)
		iHumidity : INT; (*Ambient humidity measured (0..100%)*)
	END_STRUCT;
	StBlock_SafetyInputs : 	STRUCT 
		xSafetyOK : BOOL; (*Bar Safety Is Ok*)
		xRearSafetyOK : BOOL; (*Rear Door is OK with Preventa OR LightCourtain is OK in P4*)
		xFrontSafetyOK : BOOL; (*Front Door is Open*)
		xCurtainEnable01 : BOOL;
		xCurtainEnable02 : BOOL;
		xFrontEStopOK : BOOL;
		xRearEStopOK : BOOL;
	END_STRUCT;
	StBlock_Inputs : 	STRUCT 
		Safety : StBlock_SafetyInputs;
		xReferenceDI : BOOL;
		xModuleTemp01Ok : BOOL;
		xModuleTemp02Ok : BOOL;
		xModuleTemp03Ok : BOOL;
		xModuleTemp04Ok : BOOL;
		xIclaSensor : BOOL;
		xVertTopLimit : BOOL;
		xTrayIn : BOOL; (*Tray below the bars. Ready to get any drip of the printheads*)
		xTrayOut : BOOL; (*Tray in safe position to move bars to print*)
		xDifferentialOK : BOOL;
		xDriveProtectionOK : BOOL;
		xSiUnitModuleOk : BOOL;
		xIclaModuleOk : BOOL;
		xAirVenturiOK : BOOL;
		xWaterLevelSensor : BOOL; (*Water Tank Minium Level Sensor*)
		xWaterPresureSensor : BOOL; (*Water Presure Sensor*)
		xHeaterDcOkBusBar1 : BOOL; (*Bar Heater Power Supply Work Ok. Signal from a Relay with the coil in the BusBar to confirm voltage*)
		xHeaterDcOkBusBar2 : BOOL; (*Bar Heater Power Supply Work Ok. Signal from a Relay with the coil in the BusBar to confirm voltage*)
		xHeaterDcOkPsu : ARRAY[0..MAX_LAST_HEATER_PSU_DC_OK]OF BOOL; (*Heater Power Supply Work Ok. Signal DC OK from the PSU*)
		xHeaterAcOkPsu : ARRAY[0..MAX_LAST_HEATER_PSU_AC_OK]OF BOOL; (*Heater Power Supply Work Ok. Signal AC  OK from the PSU*)
		xPrintHeadPSU : ARRAY[0..MAX_LAST_PH_PSU]OF BOOL; (*Interconected PrintHead Power Supply Number 1 Work Ok*)
		xCappingWaterLevelSensor : BOOL; (*Sensor checking capping water tank's minimum level*)
		xCappingWaterFlowmeter : BOOL; (*Sensor checking capping water circuit flow*)
		xDegasserPressure : BOOL; (*Pressure switch for degasser pressure control*)
		xFrontDoorClosed : BOOL;
		iTemperatureRaw : INT;
		xTemperatureSensorError : BOOL;
		iHumidityRaw : INT;
		xHumiditySensorError : BOOL;
		xBarsIn : BOOL;
	END_STRUCT;
	StBlock : 	STRUCT 
		In : StBlock_Inputs;
		Status : StBlock_Status;
		parameters : StBlock_Parameters;
		parSw : StBlock_SwParameters;
		commands : stBlock_commands; (*all block commands*)
		AlSummary : stEFI_AlarmSummary;
		Al : StBlock_Alarms;
		Lg : StBlock_Log;
		Out : StBlock_Outputs;
	END_STRUCT;
END_TYPE
