
TYPE
	stBelt : 	STRUCT 
		commands : stBelt_Commands;
		parameters : stBelt_Parameters;
		parSw : stBelt_SwParameters;
		states : stBelt_States;
		AlSummary : stEFI_AlarmSummary;
		Al : stBelt_Alarms;
		Log : stBelt_Log;
	END_STRUCT;
	stBelt_States : 	STRUCT 
		xRuningBelt : BOOL;
		xOrderRuning : BOOL; (*Active when BELT_PREPARING_START OR BELT_RUN_ORDER OR BELT_RUNNING*)
		rCurrentSpeedUnits : REAL; (*Speed in drive units*)
		rCurrentSpeed : REAL; (*Speed in m/min*)
		rMaxTorque : REAL; (*Max Torque of the motor installed to allow sending the Torque as percentage*)
		rTorquePerc : REAL; (*Belt Torque in % over Max torque. gui_q_iCurrentTorque*)
		rCurrentTemperature : REAL; (*Belt temperature in Cº*)
		rMotorPosition : REAL;
		rCurrentTorque : REAL; (*Belt Torque in Newton*meter*)
		rActualCurrent : REAL; (*Current from the Drive in Amps. value Max/Peak*)
		ErrorId : UINT; (*Error in the BeltMotor*)
		State : BeltStates_enum;
		Hw : stBelt_StatusHw;
		rMaxSpeed : REAL; (*Max speed*)
		rMaxTemperature : REAL; (*Motor temp max working temperature*)
		rAcceleration : REAL := 0; (*ramp ACC in mm/s^2 movements. Just working if machine allows it*)
		rDeceleration : REAL := 0; (*ramp DeACC in mm/s^2  movements Just working if machine allows it*)
		MaxNegDeceleration : REAL; (*Rated Torque of the motor in Nm*)
		MaxPosDeceleration : REAL; (*Rated Torque of the motor in Nm*)
		MaxNegAcceleration : REAL; (*Rated Torque of the motor in Nm*)
		MaxPosAcceleration : REAL; (*Rated Torque of the motor in Nm*)
	END_STRUCT;
	stBelt_StatusHw : 	STRUCT 
		rMaxSpeed : REAL := 50.0; (*Speed setpoint in m/min*)
	END_STRUCT;
	stBelt_Parameters : 	STRUCT 
		IndexAxis : USINT; (*The index of the axis corresponding to the Belt Axis in the machine*)
		DriveUnit : MC_DriveUnitManager;
		xExistBelt : BOOL;
		Direction : USINT; (*direction for commanded movements. 0=Positive 1=Negative*)
		rMaxSpeed : REAL; (*Max speed in m/min depending on the configuration of the machine*)
		rSetPointSpeed : REAL := 20.0; (*Speed setpoint in m/min*)
		xRemoteAcceleration : BOOL; (*Acceleration is configured by Sw*)
		rAcceleration : REAL := 0; (*ramp ACC in mm/s^2 movements*)
		xRemoteDeceleration : BOOL; (*Deceleration is configured by Sw*)
		rSoftDeceleration : REAL := 0; (*ramp DeACC in mm/s^2  movements*)
		rDeceleration : REAL := 0; (*ramp DeACC in mm/s^2  movements*)
		xDriveProtectionOK : BOOL;
		tiTimeBeepBeforeMove : TIME; (*Time beeping before starting the movement*)
		rMaxAcceleration : REAL; (*Max acceleration*)
		rMaxDeceleration : REAL; (*Max deceleration*)
		rMaxGearBox : REAL := 50; (*Max gearbox*)
		rMaxAxisLength : REAL := 1000; (*Max axis length*)
	END_STRUCT;
	stBelt_SwParameters : 	STRUCT 
		rAxisLength : REAL := 605.0; (*Roll diameter in mm*)
		rGearBox : REAL := 35.0; (*Reductor received from gui (x:1)*)
		rAcceleration : REAL := 0; (*ramp ACC in mm/s^2 movements. Just working if machine allows it*)
		rDeceleration : REAL := 0; (*ramp DeACC in mm/s^2  movements Just working if machine allows it*)
	END_STRUCT;
	stBelt_Alarms : 	STRUCT 
		xAnyDriveAlarm : BOOL; (*ErrorID is different to 0 is generic drive alarm*)
		xAlrPowerBeltError : BOOL; (*gAxisBelt.Status.ErrorID=5012*)
		xAlrComDrive : BOOL; (*gAxisBelt.Status.ErrorID=32189 OR gAxisBelt.Status.ErrorID=29265*)
		xAlrProtDrive : BOOL;
		xAlrOverTorque : BOOL;
		xBeltMotorTemp : BOOL; (*Warning: Belt Motor Temperature Too Hot*)
		xBeltDriverTemp : BOOL; (*Warning: Belt Driver Temperature Too Hot*)
		xWrnOverTorq : BOOL; (*Warning: Belt Over Torque*)
		xAxisLengthNotDefined : BOOL; (*Critical: Motor transmission data not defined*)
		xGearBoxNotDefined : BOOL; (*Critical: Motor transmission data not defined*)
		xControllerNotReady : BOOL; (*Critical: Controller of the Drive not Ready. Usually motor not connected to drive*)
		xEnableVoltageSag : BOOL; (*Critical: Drive enables disabled*)
	END_STRUCT;
	stBelt_Log : 	STRUCT 
		iNumberStartStop : BOOL;
		udiKmBand : UDINT;
		iHoursRunning : BOOL;
		diBentTilesBL2 : DINT;
		diBentTilesBL1 : DINT;
	END_STRUCT;
	stBelt_Commands : 	STRUCT 
		xRunBelt : BOOL; (*command xRunBelt*)
		xJogBelt : BOOL; (*command xJogBelt. Movement direct without sound*)
		xUseSoftDeceleration : BOOL; (*Command to apply a lower value of deceleration for cases where stop is not critical*)
		xUseJogAccDecc : BOOL; (*Use Jog acceleration and deceleration parameters*)
		xConsentBelt : BOOL; (*Belt Consent state*)
		xExternalSafetyStop : BOOL; (*External Safety Stop order*)
		Mode : StGeneral_States_Mode;
		AutoMode : stEFI_MachineAutoModes; (*commands to inform belt*)
		xMute : BOOL; (*command xMute *)
		xReset : BOOL; (*command xReset*)
	END_STRUCT;
	BeltStates_enum : 
		(
		BELT_NOT_INITIALIZED,
		BELT_SWITCH_ON,
		BELT_HOMING,
		BELT_INITIALIZED,
		BELT_IDLE,
		BELT_PREPARING_START,
		BELT_RUN_ORDER,
		BELT_RUNNING,
		BELT_NOT_CONSENT, (*xConsentPrinting,xConsentBypass,xConsentLaboratory and xConsentLine*)
		BELT_ERROR, (*Belt on error*)
		BELT_JOGGING (*Belt been jogged (remotely). No sound. Direct movement*)
		);
END_TYPE
