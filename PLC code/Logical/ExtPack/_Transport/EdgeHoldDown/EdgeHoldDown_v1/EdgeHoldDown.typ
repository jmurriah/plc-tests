
TYPE
	EdgeHoldDown_typ : 	STRUCT 
		ordersSw : EdgeHoldDownOrdersSw; (*Orders from sw*)
		commandsSw : EdgeHoldDownCommandsSw; (*Commands gui*)
		commands : EdgeHoldDownCommands; (*Commands gui*)
		orders : EdgeHoldDownOrders;
		parameters : EdgeHoldDownParameters; (*Parameters gui*)
		parSw : EdgeHoldDownParametersSw;
		status : EdgeHoldDownStatus; (*States potocell system*)
		Alarms : EdgeHoldDownAlarms; (*Alarms*)
		AlSummary : stEFI_AlarmSummary; (*Alarms Summary*)
		inputs : EdgeHoldDownInputs;
		Hw : EdgeHoldDownParametersHw_typ;
	END_STRUCT;
	EdgeHoldDownCommands : 	STRUCT 
		xErrorRst : BOOL;
		xMute : BOOL;
		xStop : BOOL;
		AutoMode : stEFI_MachineAutoModes;
		Mode : StGeneral_States_Mode;
	END_STRUCT;
	EdgeHoldDownOrdersSw : 	STRUCT 
		xMoveForward : BOOL;
		xMoveBackward : BOOL;
		xMoveUp : BOOL;
		xMoveDown : BOOL;
	END_STRUCT;
	EdgeHoldDownCommandsSw : 	STRUCT 
		xReference : BOOL;
	END_STRUCT;
	EdgeHoldDownOrders : 	STRUCT 
		xResetPosition : BOOL; (*Order to move adjustment systems to resting position*)
		xAdjustToMedia : BOOL; (*Order to move adjustment system to working position*)
	END_STRUCT;
	EdgeHoldDownParametersSw : 	STRUCT 
		rBarsOffset : REAL := 15; (*Offset desired between metal bands height and bars position (mm)*)
		iOverlap : INT := 10; (*Overlap between metal bands and media (mm)*)
		xEnable : BOOL;
	END_STRUCT;
	EdgeHoldDownParameters : 	STRUCT 
		xInstalled : BOOL; (*This variable is activated when this functionality is intalled and ready to be enabled*)
		xEnableMovements : BOOL; (*Movements are enabled. Safe to move the adjustment systems and not damage the bars*)
		rDistanceMetalBandToSki : REAL := 20; (*Distance between ski and metal band*)
		rWidthSp : REAL; (*Metal bands width position setpoint*)
		rBarsOffset : REAL; (*Offset desired between metal bands and printing bars height*)
		rBarsHeighSp : REAL; (*Bars heigh setpoint*)
		rBlockPosition : REAL; (*Block over ehd system position*)
		iAdjustmentSystemsNumber : USINT; (*Number of adjustment systems used by the edge hold down. Adjust system is composed by two motors*)
	END_STRUCT;
	EdgeHoldDownStatus : 	STRUCT 
		xInstalled : BOOL;
		xEnabled : BOOL;
		xReferencing : BOOL;
		xReferenced : BOOL;
		xInRestingPosition : BOOL;
		xAdjustedToMedia : BOOL;
		xMoving : BOOL;
		xReady : BOOL;
		xInPosition : BOOL;
		iSystemState : EdgeHoldDownState := EHD_STOPPED;
		EdgeHoldDownType : EdgeHoldDownType_enum;
		rSkiPosition : REAL;
		xGoingRestPosition : BOOL;
		xAdjusting : BOOL;
		rBlockPrePrintingPosition : REAL := 40; (*Distance between ski and metal band*)
	END_STRUCT;
	EdgeHoldDownAlarms : 	STRUCT 
		xParametersOutOfRange : BOOL; (*Active when order to adjust media received and parameters are out of requirements*)
		xMovementsNotEnabled : BOOL; (*Active when order to adjust to media received when movements are not enabled*)
		xJam : BOOL; (*Jam sensor has detect media while ehd is adjusted to media*)
		xNotReferenced : BOOL; (*System not referenced*)
	END_STRUCT;
	EdgeHoldDownState : 
		(
		EHD_STOPPED,
		EHD_MANUAL,
		EHD_IDLE,
		EHD_ERROR
		);
	EdgeHoldDownAutoState : 
		(
		EHD_OUT_OF_AUTO,
		EHD_MOVEMENTS_NOT_ENABLED,
		EHD_READY,
		EHD_ADJUSTING_STEP_1,
		EHD_ADJUSTING_STEP_2,
		EHD_ADJUSTING_STEP_3,
		EHD_RESTING_STEP_1,
		EHD_RESTING_STEP_2,
		EHD_RESTING_STEP_3
		);
	EdgeHoldDownPositionStates : 
		(
		UNDEFINED,
		HOMING,
		RESTING_POSITION,
		GOING_TO_WORKING_POSITION,
		WORKING_POSITION,
		GOING_TO_RESTING_POSITION
		);
	EdgeHoldDownOutputs : 	STRUCT 
	END_STRUCT;
	EdgeHoldDownInputs : 	STRUCT 
		xJam : BOOL;
	END_STRUCT;
	EdgeHoldDownType_enum : 
		(
		EHDTY_UNDEFINED,
		EHDTY_V1,
		EHDTY_V2
		);
	EdgeHoldDownParametersHw_typ : 	STRUCT 
		iMinBarsOffset : UINT := 10;
		iMaxBarsOffset : UINT := 15;
		iMinOverlap : INT := 8;
		iMaxOverlap : INT := 15;
		rMinWidthAdjustment : REAL := 424; (*Distance between sliders when inductive sensor for minimum position is active*)
		rMaxDistanceMetalBandToBelt : REAL := 60; (*Limited height where ehd can be moved vertically when postioned wider than belt's widht to avoid crash with 6l chassis*)
	END_STRUCT;
END_TYPE
