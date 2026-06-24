
TYPE
	BeltCleanState_enum : 
		(
		BCLEAN_NOT_INSTALLED, (*Belt clean system not installed*)
		BCLEAN_FAULT, (*Belt clean system in fault*)
		BCLEAN_DISABLED, (*Belt clean system disabled*)
		BCLEAN_ENABLED, (*Belt clean system enabled*)
		BCLEAN_WAITING_SW_CONF, (*Waiting SW confirmation to clean*)
		BCLEAN_WAITING_TO_CLEAN, (*Beltl Clean system waiting accept request to clean*)
		BCLEAN_CLEANING, (*Belt Clean system cleaning with water and air if enabled*)
		BCLEAN_DRYING (*Belt Clean system drying only*)
		);
	BeltCleanParam_typ : 	STRUCT 
		Mode : StGeneral_States_Mode;
		xBeltRunning : BOOL; (*Belt is runing*)
		rBeltSpeed : REAL; (*Belt speed*)
		xBeltEmpty : BOOL; (*Belt is empty*)
		xInstalled : BOOL; (*Water belt clean system installed*)
	END_STRUCT;
	BeltCleanCommandsSw_typ : 	STRUCT 
		xResetCounters : BOOL; (*Command to reset counters*)
		xClean : BOOL; (*To directly request a clean from UI*)
		xRefuseRequest : BOOL; (*UI command to refuse the request to clean*)
		xAcceptRequest : BOOL; (*UI command to accept the request to clean*)
	END_STRUCT;
	BeltCleanCommands_typ : 	STRUCT 
		xReset : BOOL; (*Alarm reset*)
		xMute : BOOL; (*Mute alarm*)
		xAcceptRequest : BOOL; (*Accepted request to clean*)
	END_STRUCT;
	BeltCleanOrders_typ : 	STRUCT 
		Manual : BeltCleanOrdersManual_typ; (*Manual movements*)
	END_STRUCT;
	BeltCleanOrdersManual_typ : 	STRUCT 
		xRunPump : BOOL; (*Run pump in manual mode*)
		xRunAirTurbine : BOOL; (*Run air turbine in manual mode*)
		xToCleanPosition : BOOL; (*Move cleaning system to cleaning position*)
	END_STRUCT;
	BeltCleanOutputs_typ : 	STRUCT 
		xAirTurbineVSDReset : BOOL; (*Air turbine VSD reset*)
		xAirTurbineOn : BOOL; (*Start air turbine*)
		xPumpOn : BOOL; (*Start pump*)
		xRiseCleaningSystem : BOOL; (*Rise cleaning system to cleaning position*)
	END_STRUCT;
	BeltCleanStatus_typ : 	STRUCT 
		State : BeltCleanState_enum;
		xEnabled : BOOL;
		xCleaning : BOOL; (*Cleaning or drying is being performed*)
		iPiecesToClean : UDINT; (*Number of pieces left to next clean*)
		iTimeToClean : UDINT; (*Time left to next clean*)
		xCleanReqByTime : BOOL; (*Cleaning required by time*)
		xCleanReqByPieces : BOOL; (*Cleaning required by pieces*)
		xCleanForced : BOOL; (*Cleaning required by UI*)
		xCleanRequestedSw : BOOL; (*Cleaning request to UI*)
		xCleanRequested : BOOL; (*Clean requested to machine*)
	END_STRUCT;
	BeltCleanAlarm_typ : 	STRUCT 
		xAirTurbDisabled : BOOL; (*Air turbine disabled from UI*)
		xAirTurbDisVSDFault : BOOL; (*Air turbine disabled from UI and VSD in fault*)
		xAirTurbEnVSDFault : BOOL; (*Air turbine enabled from UI and VSD in fault*)
		xBeltIsNotRuning : BOOL; (*Belt not running while cleaning or drying*)
		xWaitingToCleanState : BOOL; (*Waiting to accept request for more than 5 minutes*)
		xBeltIsNotEmpty : BOOL; (*Belt is not empty while belt cleaning*)
		xBeltNotEmptyToClean : BOOL; (*Belt not empty when start belt cleaning was requested*)
	END_STRUCT;
	BeltCleanInputs_typ : 	STRUCT 
		xEnteringMedia : BOOL; (*Media entering into machine*)
		xAirTurbVSDAvailable : BOOL; (*Air turbine VSD available*)
	END_STRUCT;
	BeltCleanParSw_typ : 	STRUCT 
		xAirTurbineEnabled : BOOL; (*Air turbine drying enabled*)
		xEnabledByTime : BOOL; (*Cleaning by time enabled*)
		xEnabledByPieces : BOOL; (*Cleaning by pieces enabled*)
		rCleanBeltSpeed : REAL := 20.0; (*Belt speed while cleaning*)
		iTimeToClean : UDINT; (*Number of seconds between cleanings*)
		iPiecesToClean : UDINT; (*Number of pieces between cleanings*)
		tiCleaning : TIME := T#120s; (*Duration of cleaning step*)
		tiDrying : TIME := T#60s; (*Duration of drying step*)
	END_STRUCT;
	BeltClean_typ : 	STRUCT 
		Commands : BeltCleanCommands_typ;
		CommandsSw : BeltCleanCommandsSw_typ;
		Orders : BeltCleanOrders_typ;
		Inputs : BeltCleanInputs_typ;
		Parameters : BeltCleanParam_typ;
		ParSw : BeltCleanParSw_typ;
		Status : BeltCleanStatus_typ;
		AlSummary : stEFI_AlarmSummary;
		Alarm : BeltCleanAlarm_typ;
		Outputs : BeltCleanOutputs_typ;
	END_STRUCT;
END_TYPE
