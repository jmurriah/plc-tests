
TYPE
	LineControlAlarms_typ : 	STRUCT 
		xAlrOvervoltage : BOOL; (*Warning alarm*)
		xAlrPrinterNoPowered : BOOL; (*Warning alarm*)
		xAlr24VdcStartSeqNoPowered : BOOL; (*Warning alarm*)
		xResetCondition : BOOL;
		xStopAlarm : BOOL;
		xCriticalAlarm : BOOL;
		xWarningAlarm : BOOL;
		xAlarmNonReseteable : BOOL;
		xAlarmReseteable : BOOL;
		xAlarmSound : BOOL;
		iReasonStop : UDINT; (*The reason to move the machine to stop*)
		iReasonWarning : UDINT;
		iReasonResetCondition : UDINT; (*The reason to active light tower's blue light*)
		iReasonCritical : UDINT; (*The reason to move the machine out of auto mode*)
	END_STRUCT;
	LineControlCommands_typ : 	STRUCT 
		CalibrateCamera : BOOL;
		Print : BOOL; (*Edge commands. Reseted when managed*)
		Pause : BOOL; (*Edge commands. Reseted when managed*)
		ControlStop : BOOL; (*Edge commands. Reseted when managed*)
		Stop : BOOL; (*Edge commands. Reseted when managed*)
		Clean : BOOL; (*Edge commands. Reseted when managed*)
		EmptyBelt : BOOL; (*Edge commands. Reseted when managed*)
		PowerOff : BOOL;
		StartUp : StartUpCommands_typ;
	END_STRUCT;
	LineControlParameters_typ : 	STRUCT 
		ExternalDevices : ARRAY[0..MAX_EXTERNAL_DEVICES]OF StartUpParameters_typ; (*0:Feeder||1:Primer||2:Printer||3:Dryer1||4:Dryer2||5:DryerCtrl||6:Stacker||7:UV||8:Chiller||9:Hoopers||10:OPV*)
		iNumExternalDevices : INT := 0;
		iLightTowerMode : INT; (*0: IEC Standard, 1: Customer1 request, 2: Customer2 request*)
		xBatchFeeding : BOOL; (*1: Batch feeding, 0: Continous feeding*)
		Hw : LineControlHwParameters_typ;
	END_STRUCT;
	LineControlInputs_typ : 	STRUCT 
		xOvervoltageProtectionOk : BOOL;
		xPrinterPowered : BOOL;
		x24VdcStartSeqNoPowered : BOOL;
		UPSs : ARRAY[0..2]OF UPS_Inputs;
		Customer : ARRAY[0..3]OF BOOL;
	END_STRUCT;
	StartUpInputs_typ : 	STRUCT 
		xPowered : BOOL; (*Some devices power management needs a second signal to switch off its branch*)
	END_STRUCT;
	StartUpOutputs_typ : 	STRUCT 
		xClose : BOOL; (*Signal to active contactor coil of device's power branch*)
		xOpen : BOOL; (*Before activating the Close signal, the Open output has to be activated. A NC signal through a relay is sent as Open, so just sending close both signals are electrically sent*)
	END_STRUCT;
	LineControlOutputs_typ : 	STRUCT 
		ExternalDevices : ARRAY[0..MAX_EXTERNAL_DEVICES]OF StartUpOutputs_typ; (*Signal to active contactor coil of device's power branch*)
		xRedLight : BOOL;
		xYellowLight : BOOL;
		xGreenLight : BOOL;
		xWhiteLight : BOOL;
		xBlueLight : BOOL;
		xLightReset : BOOL;
		xSound : BOOL;
		Customer : ARRAY[0..3]OF BOOL;
		Sw : LineControlOutputsForSw;
	END_STRUCT;
	StartUpCommands_typ : 	STRUCT 
		xPowerOff : ARRAY[0..MAX_EXTERNAL_DEVICES]OF BOOL; (*0:Feeder||1:Primer||2:Printer||3:Dryer1||4:Dryer2||5:DryerCtrl||6:Stacker||7:UV||8:Chiller||9:Hoopers||10:OPV*)
		xPowerUp : ARRAY[0..MAX_EXTERNAL_DEVICES]OF BOOL; (*0:Feeder||1:Primer||2:Printer||3:Dryer1||4:Dryer2||5:DryerCtrl||6:Stacker||7:UV||8:Chiller||9:Hoopers||10:OPV*)
		xStartAll : BOOL;
	END_STRUCT;
	StartUpParameters_typ : 	STRUCT 
		tiDelay : TIME; (*Delay to activate from the previous device*)
		xIsEngine : BOOL; (*Activate if the Power is set to de Device through a Motorized contactor*)
	END_STRUCT;
	LineControl_typ : 	STRUCT 
		Commands : LineControlCommands_typ;
		Status : LineStatus_enum := LINE_NOT_POWERED;
		StatusSw : UINT := 0; (*Copy for Sw*)
		Alarms : LineControlAlarms_typ;
		Parameters : LineControlParameters_typ;
		Outputs : LineControlOutputs_typ;
		Inputs : LineControlInputs_typ;
		SubStatus : UINT; (*Substatus of Line.Status. Info useful for reports and debug*)
		StatusSummary : LineControlStatusSummarized; (*Struct to summarize different states that belongs to same process*)
		OrdersSw : LineControlOrdersSw_typ;
		Orders : LineControlOrders_typ;
	END_STRUCT;
	LineControlOutputsForSw : 	STRUCT 
		xPrintOrderRequestToSw : BOOL;
		xCleanOrderRequestToSw : BOOL;
		iTimesBlockAtSafePosition : UINT; (*Counter to acknowledge how many times block has been lifted to safe position*)
	END_STRUCT;
	LineControlOrders_typ : 	STRUCT 
		Preprinting : BOOL; (*Order to the printer to go to preprint position*)
	END_STRUCT;
	LineControlOrdersSw_typ : 	STRUCT 
		Shutdown : BOOL;
	END_STRUCT;
	LineControlHwParameters_typ : 	STRUCT 
		rMaxSpeed : REAL; (*Speed in mm/min*)
		xDoubleLineAllowed : BOOL; (*Active when allows double line printing*)
	END_STRUCT;
END_TYPE
