
TYPE
	NonCrashStatusCtrl : 
		(
		NONCRASH_NOT_INITIALIZED,
		NONCRASH_SWITCH_ON,
		NONCRASH_HOMING,
		NONCRASH_INITIALIZED,
		NONCRASH_IDLE,
		NONCRASH_RUN_ORDER,
		NONCRASH_RUNNING,
		NONCRASH_ERROR (*dataNC on error*)
		);
	NonCrashCommands_typ : 	STRUCT 
		xRun : BOOL; (*Signal to RUN. Signal to be keep while the running is wanted*)
		xExternalSafetyStop : BOOL; (*External Safety Stop order*)
		xMute : BOOL; (*command xMute *)
		xReset : BOOL; (*command xReset*)
	END_STRUCT;
	NonCrashParametersSw_typ : 	STRUCT 
		rSpeedOffset : REAL := 0; (*In m/min. Modification of the speed desired. Fine adjust in commissioning in m/min. gui_i_iNonCrashSpeedOffset*)
		rGearBox : REAL := 0; (*GearBox of the NonCrash axis to allow proper speed calculation*)
		rPerimeter : REAL := 0; (*Perimeter of the NonCrash axis to allow proper speed calculation*)
		xEnable : BOOL; (*Enable the NonCrash in the machines where it can be installed*)
	END_STRUCT;
	NonCrashParameters_typ : 	STRUCT 
		xInstalled : BOOL;
		iIndexMotor : USINT; (*Index of the motor in the gAxis[] array*)
		DriveUnit : MC_DriveUnitManager;
		Mode : StGeneral_States_Mode;
		AutoMode : stEFI_MachineAutoModes;
		MotorDirection : MotorDirection_enum; (*To indicate if the motor must spin in reverse*)
		rSpeedSetPoint : REAL := 50.0; (*In m/min Speed SetPoint of the Transport. *)
		rAcceleration : REAL; (*ramp ACC in mm/s^2 movements*)
		rDeceleration : REAL; (*ramp DeACC in mm/s^2  movements*)
		tiTorqueFilter : TIME; (*Time to define the Overtorque if the torque value is higher that the nominal*)
	END_STRUCT;
	NonCrashAlarms_typ : 	STRUCT 
		xAlrComsDrive : BOOL; (*Not communication with the Drive of the motor*)
		xAlrDriveError : BOOL; (*Error in the Drive managing the motor*)
		xWrnOvertorque : BOOL; (*Warning. Overtorque in the motor*)
		xAlrOvertorque : BOOL; (*Alarm. Overtorque in the motor*)
		xAlrDiffContact : BOOL; (*Alarm. Diferential contact dripped*)
		xPerimeterNotDefined : BOOL; (*Critical: Motor transmission data not defined*)
		xGearBoxNotDefined : BOOL; (*Critical: Motor transmission data not defined*)
		xControllerNotReady : BOOL; (*Critical: Controller of the Drive not Ready. Usually motor not connected to drive*)
	END_STRUCT;
	NonCrashStatusMotor_typ : 	STRUCT 
		xRunning : BOOL; (*The motor is running*)
		rTorque : REAL := 1.0; (*Current torque N·m*)
		rCurrentSpeedUnits : REAL; (*Speed in drive units*)
		rCurrentSpeed : REAL; (*Speed in m/min*)
		ErrorId : UINT; (*Error in the Motor*)
	END_STRUCT;
	NonCrashStatus_typ : 	STRUCT 
		State : NonCrashStatusCtrl; (*State of the control*)
		Motor : NonCrashStatusMotor_typ;
		xInstalled : BOOL; (*The system is or can be installed*)
		xEnabled : BOOL; (*The NonCrash in enabled and raises alarms*)
	END_STRUCT;
	NonCrashInputs_typ : 	STRUCT 
		xDiffContacOk : BOOL;
	END_STRUCT;
	NonCrash_typ : 	STRUCT 
		Commands : NonCrashCommands_typ;
		Parameters : NonCrashParameters_typ;
		parSw : NonCrashParametersSw_typ;
		Status : NonCrashStatus_typ;
		Alarms : NonCrashAlarms_typ; (*Alarms*)
		AlSummary : stEFI_AlarmSummary; (*Alarms Summary*)
		Inputs : NonCrashInputs_typ;
	END_STRUCT;
END_TYPE
