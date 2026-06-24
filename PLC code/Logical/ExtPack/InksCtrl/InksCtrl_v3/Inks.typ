
TYPE
	inksDirections : 
		(
		INKSDIR_DIRECT := 1,
		INKSDIR_REVERSE := 2,
		INKSDIR_STOP := 3
		);
	inksStateModes : 
		(
		INKS_STOPPED := 1,
		INKS_STARTING := 3,
		INKS_STARTED := 4,
		INKS_MANUAL_REVERSEFLOW := 5,
		INKS_AUTO_REVERSEFLOW := 6,
		INKS_STOPPING := 9,
		INKS_RUNNING_MANUAL := 10,
		INKS_PRIMING := 13,
		INKS_UNDEFINED := 255
		);
	stInksCommands : 	STRUCT 
		xOrderCleaning : BOOL; (*Command coming from the Block*)
		xOrderDrip : BOOL; (*This signal must be maintained during the dripping. If the order is falled down, the dripping is finished. Command coming from the Block*)
		xCloseReliefValve : BOOL; (*Command coming from the Block*)
		xErrorRst : BOOL;
		xMute : BOOL;
	END_STRUCT;
	stInksStartUpParams : 	STRUCT 
		iSteps : USINT;
		iSecondsStable : UINT; (*Seconds in the window and ready for next step*)
		iSecondsUnstable : UINT; (*Seconds to consider we are out of window*)
		rMeniscus : REAL; (*Valuen in mbar*)
		rMarginToStable : REAL; (*Valuen in mbar. Margin to consider Stable*)
	END_STRUCT;
	stInksDefaultBarParams : 	STRUCT 
		rMeniscus : REAL;
		rPositive : REAL;
		rTemp : REAL;
	END_STRUCT;
	stInksOrdersSw : 	STRUCT 
		xStartInks : BOOL;
		xPowPrintHead : BOOL;
		xStartManual : BOOL;
		xOrderReverseMan : BOOL;
	END_STRUCT;
	stInksBarParams : 	STRUCT 
		paramsPidMeniscus : stPIDParam;
		paramsPidPositive : stPIDParam;
		paramsPidTemp : stPIDParam;
		paramsPidTankTemp : stPIDParam;
		paramsPidMeniscusReservoir : stPIDParam;
		paramsPidPositiveReservoir : stPIDParam;
		rHighPumpLimitNeg : REAL;
		rHighPumpLimitPos : REAL;
		rLowPumpLimitNeg : REAL;
		rLowPumpLimitPos : REAL;
		rAccelerationFillingPump : REAL;
		rSPfillingPumpStarting : REAL;
		iStabSole : INT;
		iDesahPid : INT;
		iCloseSole : INT;
		xTypeTankSensorAnalog : BOOL;
		xTypeTankSensorDigital : BOOL;
		iPowerTempWatt : UINT; (*Power of the main heater in the bar*)
		rVacuumSensorSpan : REAL; (*Span of the sensor in mBar*)
		rVacuumSensorOffset : REAL; (*Value in mBar of the minimum value of the sensor*)
		iTimeToActiveDcErrorAlarm : TIME;
		Default : stInksDefaultBarParams;
		StartUp : stInksStartUpParams;
		zFree : ARRAY[0..3]OF USINT;
	END_STRUCT;
	stInksConstantsToSw : 	STRUCT 
		tiDripTimeMin : TIME;
		tiDripTimeMax : TIME;
	END_STRUCT;
	stInksParametersSwNegPump : 	STRUCT 
		rSetPointMeniscus : REAL; (*Meniscus SetPoint in mbar*)
		rSetPointManual : REAL;
		rLimitMeniscusDiffWarning : REAL;
		rUpperLimMeniscusCritical : REAL;
		rLowerLimMeniscusCritical : REAL;
	END_STRUCT;
	stInksParametersSwPosPump : 	STRUCT 
		rSetPoint : REAL; (*Value in mbar*)
		rSetPointManual : REAL;
	END_STRUCT;
	stInksParametersSwTemp : 	STRUCT 
		rSetPointTemp : REAL; (*Value in ºC*)
		rSetPointTempMaintenance : REAL; (*Value in ºC. Temp SP to be used when maintenance mode activated*)
		xTankHeaterEnabled : BOOL := FALSE;
	END_STRUCT;
	stInksParametersSwConfig : 	STRUCT 
		iMappingBar : UINT;
		iInkType : INT := 1; (*Default value is 1, *)
		iPrintHeadType : INT; (*Printhead type xBar (0=ERROR, 1=TTEC, 2=Seiko, 3=XAAR, 4=Dimatix, 5=TTEC_XL, 6=X_GS40, 7=XAAR2001, 8=XAAR2001GS40, 9=SEIKOW, 10=SeikoL)*)
	END_STRUCT;
	stInksParametersSw : 	STRUCT 
		xActMaintenanceMode : BOOL; (*Active when bar is in maintenance mode. To read parSw "rSetPointTempMaintenance" instead of "rSetPointTemp"*)
		xActTestMode : BOOL;
		xEnabledBarToPrint : BOOL;
		xOnReverseCapped : BOOL;
		xOnReverseCleaning : BOOL;
		xReverseOnManual : BOOL := FALSE; (*Activate reverser Flow in Manual activation of the Inks*)
		xColorLoadedInJob : BOOL; (*Active when bar is enabled to print and is used by current loaded job*)
		tiReverseManual : TIME;
		tiDripTime : TIME; (*Time dripping the Bar*)
		iInkEnabledPrintHeads : INT; (*Quantity of printheads enabled*)
		iInkConsumption : INT; (*Picoliters/m2*)
		Config : stInksParametersSwConfig;
		NegPump : stInksParametersSwNegPump;
		PosPump : stInksParametersSwPosPump;
		Temp : stInksParametersSwTemp;
	END_STRUCT;
	stInksParametersNegPump : 	STRUCT 
		rSetPointPrimingStarting : REAL := 30; (*DC thres in Positive pump to change SP applied to PID in PrimingSystems*)
		rDCPriming : REAL := 10;
	END_STRUCT;
	stInksParametersPosPump : 	STRUCT 
		rSetPointPrimingStarting : REAL := 10; (*DC thres in Positive pump to change SP applied to PID in PrimingSystems*)
		rDCThresholdPriming : REAL := 30.0; (*DC thres in Positive pump to change SP applied to PID in PrimingSystems*)
		rDCPriming : REAL := 50;
	END_STRUCT;
	stInksParametersTemp : 	STRUCT 
		rReductionTempPower : REAL := 1.0; (*Not reducing power by default.*)
		rk1Temp : REAL := 0; (*Coefficient k1 applied to PID*)
		rk2Temp : REAL := 6; (*Coefficient k2 applied to PID*)
		rk3Temp : REAL := 2; (*Coefficient k3 applied to PID*)
		rk4Temp : REAL := 4; (*Coefficient k4 applied to PID*)
		iBarsWithSameBlock : UINT;
		iBarsWithSamePsu : UINT;
	END_STRUCT;
	stInksParametersPriming : 	STRUCT 
		xSystemNeedsPriming : BOOL;
		rThresholdPressure : REAL := 2; (*DC thres in Positive pump to change SP applied to PID in PrimingSystems*)
	END_STRUCT;
	stInksParametersChiller : 	STRUCT 
		Status : ChillerStatus_enum; (*Chiller status*)
		iIndex : USINT;
	END_STRUCT;
	stInksParametersStartUp : 	STRUCT 
		xActive : BOOL; (*StartUp is active. This is activated remotely, and reseted remotely if cancelled, or reseted internally if finished*)
	END_STRUCT;
	stInksParameters : 	STRUCT 
		parBar : {REDUND_UNREPLICABLE} stInksBarParams;
		StartUp : stInksParametersStartUp;
		tiDripTimeMax : TIME; (*Max dripping time of the started bars in the same block*)
		iTimeStopping : INT;
		xDebugMode : BOOL := FALSE;
		xReservoirMode : BOOL;
		iTimeChangeSPInRev : UINT := 6; (*Delay to change SP applied to PID of negative pump*)
		NegPump : stInksParametersNegPump;
		PosPump : stInksParametersPosPump;
		Temp : stInksParametersTemp;
		Priming : stInksParametersPriming;
		xEnabledTachoSignals : BOOL; (*Define if the system has Tacho signal in the pumps*)
		xBlockInCap : BOOL := FALSE; (*Ink has to know when block is capped to apply reverse Idle (60 sec of revese every 30 min) when Idle checkbos is enabled from GUI*)
		xBlockInPrint : BOOL := FALSE; (*Ink has to know when block is print to check the excesive diferential temperature to print. Only in print and automatic state.*)
		InksChiller : stInksParametersChiller;
		PrintheadsChiller : stInksParametersChiller;
	END_STRUCT;
	stInksStatusTemp : 	STRUCT 
		xEnabledPid : BOOL; (*Enable the Pid FB*)
		xEnabledPwm : BOOL; (*Enable the Pwm FB*)
		xEnabledTunning : BOOL; (*Enable the Tunning FB*)
		rDutyCyclePwm : REAL; (*Duty Cycle for Temperature control directly to the PWM FB*)
		rDutyCycleTempPowerRed : REAL; (*Duty Cycle for Temperature control with the Power Reduction due to less power in PSU than in heaters*)
		xEnabledTankHeater : BOOL; (*It informs about tank heater status*)
		rDutyCycleTempPowerRedTank : REAL; (*Dutty Cycle Heater Tank. Added this status. It informs to datalogger.*)
		rDutyCycleTempTank : REAL; (*Dutty Cycle Heater Tank*)
		rDutyCycleTemp : REAL;
		rPresetValue : REAL; (*Temperature value when PID is agressive*)
		rTemp : REAL;
		rTempTank : REAL;
	END_STRUCT;
	stInksStatusNegPump : 	STRUCT 
		rDutyCycleNegative : REAL;
		rSpeedNeg : REAL; (*Speed in rpm*)
		rCurrent : REAL; (*Current consumption measured by PLC*)
	END_STRUCT;
	stInksStatusPosPump : 	STRUCT 
		rDutyCycleFilling : REAL;
		rSpeedPos : REAL; (*Speed in rpm*)
		rSetPointPos : REAL;
		rCurrent : REAL; (*Current consumption measured by PLC*)
	END_STRUCT;
	stInksStatusReverse : 	STRUCT 
		xOnReverseAuto : BOOL;
		xOnReverseCleaning : BOOL := FALSE;
		xOnReverseCapped : BOOL := FALSE;
		xReverseOnManual : BOOL;
		xReverseMan : BOOL := FALSE;
		xReverseManFinished : BOOL := FALSE;
		xStartOnReverseCapped : BOOL := FALSE;
		xStartOnReverseCappedCycle : BOOL := FALSE;
	END_STRUCT;
	stInksStatusTank : 	STRUCT 
		iStatusTankDigital : INT;
		iDipositLevel : INT;
		xMaxLevel : BOOL; (*There is more ink than the MAXIMUM sensor level. The MAXIMUM sensor level is active*)
		xCloseToMinLevel : BOOL; (*There is more ink than the MINIMUM sensor level. The MINIMUM sensor level is active but unstable*)
		xMinLevel : BOOL; (*There is more ink than the MINIMUM sensor level. The MINIMUM sensor level is active*)
	END_STRUCT;
	stInksStatusAutoStartUp : 	STRUCT 
		xStarting : BOOL;
		xCancelled : BOOL;
		xStarted : BOOL;
	END_STRUCT;
	stInksStatus : 	STRUCT 
		Temp : stInksStatusTemp;
		NegPump : stInksStatusNegPump;
		PosPump : stInksStatusPosPump;
		Tank : stInksStatusTank;
		iDirection : inksDirections;
		AutoStartUp : stInksStatusAutoStartUp;
		tiDriptime : TIME;
		xDripping : BOOL;
		iInkStateSw : INT;
		iInkState : inksStateModes;
		tiInReverseManual : TIME; (*Time in reverse Manual*)
		rVacuum1 : REAL; (*Vacuum at Positive in mbar*)
		rVacuum2 : REAL; (*Vacuum at Negative  in mbar*)
		rMeniscus : REAL;
		rDeltaPressure : REAL;
		xInkAndPreheatingRunning : BOOL;
		xInksRunning : BOOL;
		xReservoirMode : BOOL := FALSE;
		Reverse : stInksStatusReverse;
		xUnstableInkState : BOOL;
		startChangeSPInDelta : BOOL;
		xColorLoadedInJob : BOOL;
		xEnabledBarToPrint : BOOL;
		xActTestMode : BOOL;
		xActMaintenanceMode : BOOL;
		xBarInstalled : BOOL;
	END_STRUCT;
	stInksAlarmsList : 	STRUCT 
		xAlrBrokenMeniscus : BOOL;
		xAlrDiffInCtrlTemp : BOOL;
		xAlrDiffVacuum : BOOL;
		xAlrInksRunnig : BOOL;
		xAlrLevelSensorError : BOOL;
		xAlrNoInkNoCleanManif : BOOL;
		xAlrNoRecircStop : BOOL;
		xAlrNoRecirculation : BOOL;
		xAlrOverPressure : BOOL;
		xAlrPumpsDCError : BOOL;
		xAlrStopRecircNoInk : BOOL;
		xAlrTankDigitalSensorsError : BOOL;
		xAlrTankEmpty : BOOL;
		xAlrTankCloseToEmpty : BOOL;
		xAlrTankToFillIn : BOOL;
		xAlrIncoherTempHeat : BOOL;
		xAlrTempSensor : BOOL;
		xAlrTempTankSensor : BOOL;
		xAlrDifCtrlTempExcessive : BOOL;
		xAlrDiffInCtrlTempTank : BOOL;
		xAlrIncoherTempTank : BOOL;
		xAlrVacuum1 : BOOL;
		xAlrVacuum2 : BOOL;
		xAlrVacuumSensor1 : BOOL;
		xAlrVacuumSensor2 : BOOL;
		xAlrKlixonTriggered : BOOL;
		xAlrPrintHeadPsuFailure : BOOL := FALSE;
		xAlrHeaterTankPsu : BOOL;
		xAlrHeaterTankReachsMaxTemp : BOOL;
		xAlrHeaterReachsMaxTemp : BOOL;
		xAlrHeaterOutFault : BOOL; (*Alarm to report PLC output to bar heater*)
		xAlrMaintenanceModeActive : BOOL;
		xHeaterOff : BOOL; (*Chiller is on and heater DC of the bar is 0% for > 120s NOZOMITWO-1410*)
		xAlrPrintHeadsChillerStopped : BOOL; (*The chiller for Printheads is stopped and the printheads with power. Power to Printheads is removed automatically*)
	END_STRUCT;
	stInksSignalsOut : 	STRUCT 
		xSolenoid1 : BOOL;
		xSolenoid2 : BOOL;
		xSolenoid3 : BOOL;
		xSolenoid4 : BOOL;
		iDutyCycleNegative : INT;
		iDutyCycleFilling : INT;
		xOutPowPrintHead : BOOL;
		xOutBarResistance : BOOL;
		xOutResistanceTank : BOOL;
		xHeatingActive : BOOL;
		xReliefValve : BOOL;
	END_STRUCT;
	stInksSignalsIn : 	STRUCT 
		iInTankLevel : INT;
		xMinLevel : BOOL;
		xMaxLevel : BOOL;
		xOverpressure : BOOL;
		xTempSensorError : BOOL;
		xVacuum1SensorError : BOOL;
		xVacuum2SensorError : BOOL;
		xTempTankSensorError : BOOL;
		xInkLevelTankSensorError : BOOL;
		iTemperatureRaw : INT;
		iTemperatureTankRaw : INT;
		iVacuum1Raw : INT;
		iVacuum2Raw : INT;
		iTachNegative : UINT;
		iTachFilling : UINT;
		xKlixonTriggered : BOOL;
		xConnected : BOOL; (*Feedback signal of electrical connection. Bar terminal strp connected*)
		xPrintHeadsPsuOK : BOOL := FALSE;
	END_STRUCT;
	stInksInternal : 	STRUCT 
		Startup : stInksInternalStartup;
	END_STRUCT;
	stInksInternalStartup : 	STRUCT 
		rSetPointMeniscus : REAL; (*Meniscus SetPoint in mbar*)
	END_STRUCT;
	stInksSignals : 	STRUCT 
		in : stInksSignalsIn;
		out : stInksSignalsOut;
	END_STRUCT;
	stInks : 	STRUCT 
		commands : stInksCommands;
		ordersSw : stInksOrdersSw;
		parameters : stInksParameters;
		parSw : stInksParametersSw;
		status : stInksStatus;
		signals : stInksSignals;
		Al : stInksAlarmsList;
		AlSummary : stEFI_AlarmSummary;
		_Internal : stInksInternal;
	END_STRUCT;
END_TYPE
