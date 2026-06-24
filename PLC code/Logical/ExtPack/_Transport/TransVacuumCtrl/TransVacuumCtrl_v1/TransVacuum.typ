
TYPE
	TransVacuumStatusCtrl : 
		(
		TRANSVAC_OFF, (*Blower turned Off*)
		TRANSVAC_WAITING, (*The blower running at StartUp Duty cycle. IDLE state in previous programs*)
		TRANSVAC_CONTROLLING, (*Pressure beeing controlled by PID*)
		TRANSVAC_MAN,
		TRANSVAC_MAXIMUM (*Blowers working at 100% duty cycle*)
		);
	TransVacuumInputs_typ : 	STRUCT 
		xPressureSensorError : BOOL;
		iPressureRaw : INT; (*Value from the input card*)
		xJointSystemPressure : BOOL; (*Digital vaccuum sensor signal . There is pressure enough in the system to close the joints*)
		xBlowersAnyCB : BOOL; (*Any Blower Circuit Breaker Nok*)
		xVaccAirFlow : BOOL; (*Flowmeter vacuum signal*)
		xSafetyEnable : BOOL; (*The Enable signals are active. Do not show alarms related to this if not active*)
	END_STRUCT;
	TransVacuumCommands_typ : 	STRUCT 
		xRunProduction : BOOL; (*Signal to RUN in Auto Production mode. Signal to be keep while the running is wanted*)
		xRunJamRecovery : BOOL; (*Signal to RUN in Auto Jam Recovery mode. Signal to be keep while the running is wanted*)
		xRunByLine : BOOL; (*Signal to RUN in Auto mode. By LINE. Not production needed. Signal to be keep while the running is wanted*)
		xRunByRemote : BOOL; (*Signal to RUN in Auto mode. By REMOTE. Not production needed. Signal to be keep while the running is wanted*)
		xRunMaxDutyCycle : BOOL; (*Signal to RUN in Auto mode. Not production needed. Signal to be keep while the running is wanted. Set DutyCycle to 100%*)
		xMute : BOOL; (*command xMute *)
		xReset : BOOL; (*command xReset*)
	END_STRUCT;
	TransVacuumBlowerData_typ : 	STRUCT 
		iIndex : USINT; (*Index of Inverters to control with this TransVacuum*)
		Direction : MotorDirection_enum; (*Direction of the motor to be run*)
	END_STRUCT;
	TransVacuumParamHw_typ : 	STRUCT 
		uiNumBlowers : USINT := 1; (*Number of blowers in vacuum system*)
		xSystemWithJoints : BOOL; (*Define the system with joints and valves or without*)
		BlowerData : ARRAY[0..MAX_LAST_MOTOR_BLOWER]OF TransVacuumBlowerData_typ;
		iTotalAreas : USINT := 1; (*Total Number of areas in vacuum system*)
		rAreaWidth : REAL; (*The width of each area in mm*)
		rCentralAreaWithoutVacuum : REAL; (*Width of the central area with a pair of valves active, measured from the external tangent of the holes*)
	END_STRUCT;
	TransVacuumParameters_typ : 	STRUCT 
		xInstalled : BOOL;
		rMaxSpeed : REAL; (*Maximum speed in the motor in rpm*)
		rMaxSystemVacuum : REAL; (*Maximum vacuum in mBar of the system to define the vacuum as Percentage*)
		Mode : StGeneral_States_Mode;
		AutoMode : stEFI_MachineAutoModes;
		parPID : stPIDParam;
		Hw : TransVacuumParamHw_typ;
		xExternalSafetyStop : BOOL; (*External Safety Stop order*)
		rStartUpDutyCycle : REAL := 60.0; (*Startup value of the Duty Cycle of the Blowers to Start if xStartUpEnable is active. GUI_I_ISTARTUPBLOWERDC*)
		xStartUpEnable : BOOL := FALSE; (*Start up state need in system*)
		xBeltRunning : BOOL; (*The belt in the machine is running. Used in Laboratory and ActiveOutOfProduction*)
		rMinDutyCycle : REAL;
		rMinVacPressureSetPointPerc : REAL; (*Maximum speed in the motor in rpm*)
		rVacPressureSetPointPerc : REAL := 50.0; (*SetPoint value of the desired pressure in the system in %. gui_i_iBlowerPressureSP*)
		rMaxPIDOut : REAL; (*Transvacuum pressure PID upper manipulated variable limit (upper modulation limit of the subsequent actuator)*)
		MinValvMask : UDINT; (*Minimum Vacuum valve mask open when working*)
	END_STRUCT;
	TransVacuumParametersSw_typ : 	STRUCT 
		xActiveOutOfProduction : BOOL; (*Active the vacuum while in Automatic mode but not in Production*)
		rManSetPoint : REAL := 50.0; (*SetPoint value of working in manual. Value in %. Duty Cycle. gui_i_iManualBlowersPressureSP*)
		rVacPressureSetPointPerc : REAL := 50.0; (*SetPoint value of the desired pressure in the system in %. gui_i_iBlowerPressureSP*)
		ValvMask : UDINT; (*Vacuum valve mask from SW*)
	END_STRUCT;
	TransVacuumAlarms_typ : 	STRUCT 
		xAlrVacuumSensor : BOOL; (*Error in the Vacuum sensor*)
		xAlrDriveBlowerError : BOOL; (*Error in the Drive managing the blower*)
		xWrnOvertorque : BOOL; (*Warning. Overtorque in the blower*)
		xAlrOvertorque : BOOL; (*Alarm. Overtorque in the blower*)
		xAlrComsBlower : BOOL; (*Not communication with the Drive of the blower*)
		xAlrJointSystemPressure : BOOL; (*Warning: Joint system underpressure*)
		xAlrBlowersAnyCB : BOOL; (*Warning: Blowers General Circuit Breaker*)
		xAlrBlowerCB : ARRAY[0..MAX_LAST_MOTOR_BLOWER]OF BOOL; (*Warning: Blowers Separate Circuit Breaker*)
		xAlrCommsBlower : ARRAY[0..MAX_LAST_MOTOR_BLOWER]OF BOOL; (*Alarm Comms Blower*)
		xAlrBlowerError : ARRAY[0..MAX_LAST_MOTOR_BLOWER]OF BOOL; (*Alarm Blower Error*)
		xAlrBlowerNotRunning : ARRAY[0..MAX_LAST_MOTOR_BLOWER]OF BOOL; (*Alarm Blower Not Running with Running order*)
	END_STRUCT;
	TransVacuumStatusBlower_typ : 	STRUCT 
		rTorque : REAL := 1.0; (*Current torque N·m. gui_q_iCurrentTorque*)
		rDutyCycle : REAL; (*Current duty cycle %*)
		xMoving : BOOL; (*Started or Stopped*)
	END_STRUCT;
	TransVacuumStatus_typ : 	STRUCT 
		State : TransVacuumStatusCtrl; (*State of the control*)
		Blower : TransVacuumStatusBlower_typ;
		Inverters : ARRAY[0..MAX_LAST_MOTOR_BLOWER]OF AxisP66_Status_typ;
		xInstalled : BOOL;
		rPressurePerc : REAL; (*Real pressure in %. Gui_q_iVacuumPressure*)
		rVacPressure : REAL; (*Real pressure in mbar*)
		xAtSpeed : BOOL;
		xStartedMan : BOOL;
		VacuumValves : UDINT; (*Active valves mask status*)
	END_STRUCT;
	TransVacuumOutputs_typ : 	STRUCT 
		xActiveEvToEvacuateInk : BOOL; (*To active an Ev to evacuate the Ink inside the vacuum table*)
		VacuumValves : UDINT; (*2 integer var to control 20 valves; Least significative bits are in centring vacuum areas and most are in external areas.*)
	END_STRUCT;
	TransVacuum_typ : 	STRUCT 
		Commands : TransVacuumCommands_typ;
		OrdersSw : TransVacuumOrdersSw_typ;
		Inputs : TransVacuumInputs_typ;
		Parameters : TransVacuumParameters_typ;
		parSw : TransVacuumParametersSw_typ;
		Status : TransVacuumStatus_typ;
		Alarms : TransVacuumAlarms_typ; (*Alarms*)
		AlSummary : stEFI_AlarmSummary; (*Alarms Summary*)
		Outputs : TransVacuumOutputs_typ;
	END_STRUCT;
	TransVacuumOrdersSw_typ : 	STRUCT 
		xRunManual : BOOL; (*Signal to RUN in Manual mode. Signal to be keep while the running is wanted*)
	END_STRUCT;
END_TYPE
