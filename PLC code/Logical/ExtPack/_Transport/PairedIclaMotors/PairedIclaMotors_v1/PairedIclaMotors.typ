
TYPE
	PairedIclaMotors_typ : 	STRUCT 
		commands : PairedIclaMotorsCommands; (*Commands gui*)
		parameters : PairedIclaMotorsParameters; (*Parameters gui*)
		status : PairedIclaMotorsStatus; (*States potocell system*)
		Alarms : PairedIclaMotorsAlarms; (*Alarms*)
		AlSummary : stEFI_AlarmSummary; (*Alarms Summary*)
		Motor : ARRAY[0..2]OF PairedIclaMotors_Motor;
		Inputs : PairedIclaInputs;
	END_STRUCT;
	PairedIclaMotors_Motor : 	STRUCT 
		Inputs : PairedIclaMotorsInputs;
		Icla : stIcla;
		Alarms : MotorAlarms;
		iDirection : INT; (*1= Clockwise, -1=Conterclockwise*)
		rHomePosition : REAL;
		rMotorResolution : REAL;
		rDistanceFromSensorTargetToStrap : REAL := 10; (*Distance From Sensor Target To metal Strap*)
		rDistanceBetweenSensors : REAL;
		rMeasuredDistanceMetalStraps : REAL;
		rMeasuredPositionFrontSide : REAL; (*Position in mm of the motors on front/user side*)
		rMeasuredPositionBackSide : REAL; (*Position in mm of the motors on back/electrical cabinet side*)
		rPositionMotor : REAL; (*Position in mm of the motors*)
		rMetalStrapPos : REAL; (*Position in mm of the metal straps using motor information*)
	END_STRUCT;
	PairedIclaMotorsCommands : 	STRUCT 
		xMoveForward : BOOL;
		xMoveBackward : BOOL;
		xReference : BOOL;
		xErrorRst : BOOL;
		xMute : BOOL;
		AutoMode : stEFI_MachineAutoModes;
		Mode : StGeneral_States_Mode;
		xStop : BOOL;
		xResetMotor : BOOL;
	END_STRUCT;
	PairedIclaMotorsParameters : 	STRUCT 
		xEnabled : BOOL;
		xMovementsEnabled : BOOL;
		xInstalled : BOOL; (*This variable is activated when this functionality is intalled and ready to be enabled*)
		xPositionSensorInstalled : BOOL; (*This variable is activated when motors positions are measured in addition to internal encoder position calculation*)
		DriveUnit : MC_DriveUnitManager;
		IndexIclaMaster : USINT; (*Index of the motor in gAxis array*)
		IndexIclaGear : USINT; (*Index of the motor in gAxis array*)
		rPositionDesired : REAL;
		rMechPositionMin : REAL; (*Mechanical max position allowed*)
		rMechPositionMax : REAL; (*Mechanical max position allowed*)
		Acceleration : REAL := 5; (*Acc SP mm/ s2*)
		JogSpeed : REAL := 10; (*Jog Speed SP mm/s*)
		Speed : REAL := 100; (*Speed SP mm/s*)
		iNumIclaMotors : USINT := 2; (*Number of motors used in this adjustment system*)
		rDistanceFromSensorToBeltsCenter : REAL := 116; (*rDistance From Sensor To Belts Center. Same value for both entry and exit side*)
		rMaxPositionMeasured : REAL := 600; (*Max position measured by sensor*)
		iPositionResolution : REAL := 2; (*Position resolution in mm*)
		iMisalignmentTolerance : USINT;
	END_STRUCT;
	PairedIclaMotorsStatus : 	STRUCT 
		xEnabled : BOOL;
		xInstalled : BOOL;
		xReferencing : BOOL;
		xReferenced : BOOL;
		xMoving : BOOL; (*Motors are moving*)
		xInPosition : BOOL; (*Motors are positioned on desired position*)
		iSystemState : PairedIclaMotorsState := NOT_INITIALIZED;
	END_STRUCT;
	PairedIclaMotorsAlarms : 	STRUCT 
		xNotReferenced : BOOL; (*Phocell system not homed*)
		xNotInstalled : BOOL;
		xCommsMotorError : BOOL;
		xMotorError : BOOL; (*Error Id != 0*)
		xNotAligned : BOOL; (*Motors are not at the same position*)
		xPositionMeasuredInconsistency : BOOL; (*Inconsistency between position measured (analogic input) and motor position information (motors encoder)*)
		xPositionOutOfRange : BOOL; (*Motor is positioned out of mechanical range allowed*)
		xControllerNotReady : BOOL; (*Waiting for enable input (STO_A, STO_B)*)
	END_STRUCT;
	PairedIclaMotorsState : 
		(
		NOT_USED,
		NOT_INITIALIZED,
		POWER_ON,
		HOME_DIR,
		POWERED,
		HOMING_STEP_1,
		HOMING_STEP_2,
		HOMING_STEP_3,
		STANDSTILL,
		MANUAL,
		JOGGING,
		AUTO,
		RUNNING,
		ERROR
		);
	PairedIclaMotorsInputs : 	STRUCT 
		xMaxPositionReached : BOOL; (*Maximum position feedback received from an inductive sensor*)
		xMinPositionReached : BOOL; (*Minimum position feedback received from an inductive sensor*)
		xMeasuredPositionFrontSideError : BOOL; (*analogic sensor error*)
		iMeasuredPositionFrontSide : INT; (*Position feedback receive from an analogic sensor*)
		xMeasuredPositionBackSideError : BOOL; (*analogic sensor error*)
		iMeasuredPositionBackSide : INT; (*Position feedback receive from an analogic sensor*)
	END_STRUCT;
	MotorAlarms : 	STRUCT 
		xCommsMotorError : BOOL;
		xMotorError : BOOL; (*Error Id != 0*)
		xControllerNotReady : BOOL; (*Waiting for enable input (STO_A, STO_B)*)
	END_STRUCT;
	PairedIclaInputs : 	STRUCT 
		xSafetyEnable : BOOL;
	END_STRUCT;
END_TYPE
