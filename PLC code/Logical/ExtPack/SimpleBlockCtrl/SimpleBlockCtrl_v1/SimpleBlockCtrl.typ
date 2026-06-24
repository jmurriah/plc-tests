
TYPE
	SimpleBlock_Outputs : 	STRUCT 
		xEnableDrive : BOOL;
	END_STRUCT;
	SimpleBlock_Log : 	STRUCT 
		diMoveARelCounter : DINT;
		diMoveAbsCounter : DINT;
		diHomingsNumber : DINT;
	END_STRUCT;
	SimpleBlock_Alarms : 	STRUCT 
		xAlrSafetySystemInBlock : BOOL; (*CriticalAlarm*)
		xAlrReferenceIncoherence : BOOL; (*CriticalAlarm*)
		xAlrDriveProtection : BOOL; (*CriticalAlarm*)
		xAlrBarMtrNoRef : BOOL; (*CriticalAlarm *)
		xAlrComBarMtr : BOOL; (*CriticalAlarm *)
		xAnyDriveAlarm : BOOL; (*CriticalAlarm *)
		xAlBarMotorPowerOff : BOOL;
		xAlrBlockReachedMaxPosition : BOOL;
		xBarMotorTemp : BOOL; (*Warning: Bar Motor Temperature Too Hot*)
		xBarDriverTemp : BOOL; (*Warning: Bar Driver Temperature Too Hot*)
		xAlrCheckHomingSensor : BOOL; (*Warning: Bar Homing Sensor Maybe Broken*)
		xAlrEmergencyStop : BOOL; (*Emergency button pushed without diferenciating front or rear*)
	END_STRUCT;
	SimpleBlock_commandsManual : 	STRUCT 
		xManBarsUp : BOOL; (*Command just in manual mode*)
		xManBarsDown : BOOL; (*Command just in manual mode*)
	END_STRUCT;
	SimpleBlock_commands : 	STRUCT 
		Mode : StGeneral_States_Mode;
		StateMode : enumEFI_GenMachineState; (*commands to block*)
		AutoMode : stEFI_MachineAutoModes; (*commands to inform belt*)
		Manual : SimpleBlock_commandsManual;
		xBarHomeOrder : BOOL; (*State Command just in manual mode*)
		xToPrint : BOOL; (*Command just in AUTO mode*)
		xToCap : BOOL; (*Command just in AUTO mode*)
		xToPrintLab : BOOL; (*EDGE Command. Reseted manually in Block*)
		xToCapLab : BOOL; (*EDGE Command. Reseted manually in Block*)
		xMute : BOOL; (*Command Bool mute sound*)
		xReset : BOOL; (*Command Bool Reset*)
	END_STRUCT;
	SimpleBlock_Parameters_Motor : 	STRUCT 
		DriveUnit : MC_DriveUnitManager;
		rPrintPosition : REAL; (*Input from LC Band. Value in mm*)
		rDriveManSpeed : REAL; (*Vertical motor manual speed. Value in mm/s*)
		rDriveAutoSpeed : REAL; (*Vertical motor automatic speed. Value in mm/s*)
		rCapPosition : REAL; (*Capped position in mm*)
		rSafePosition : REAL; (*Position in mm*)
		rMinSafePosition : REAL; (*Position in mm*)
		rReferencePosition : REAL; (*Reference Position in mm*)
		rMinThicknessMedia : REAL; (*Minimum media thickness in mm*)
		VerticalDirection : MotorDirection_enum; (*To indicate that the motor must spin in reverse*)
		uiMaxCurrentBarsUp : UINT;
		uiMaxCurrentBarsDown : UINT;
		uiColisionCurrentUp : UINT;
		uiColisionCurrentDown : UINT;
		rReduceSpeedDistance : REAL; (*Distance to the limit to reduce manual speed*)
		rAcceleration : REAL;
		rDeceleration : REAL;
		xOversized : BOOL; (*Variable to define motor's operation torque is much lower than the rated torque*)
		rOperationTorque : REAL; (*Motor's operation torque*)
	END_STRUCT;
	SimpleBlock_SwParameters : 	STRUCT 
		xEnableToMovements : BOOL; (*Block is enalbed to movements and doesnt go to print if order is received,  Cleaning? *)
		xEnableToPrint : BOOL; (*Block is enalbed to print and it goes to print if order is received,*)
		rOffsetPrintMotor : REAL; (*Software Input. Printer description, advanced (adjust the motor block position)*)
		rOffsetCappingMtr : REAL;
	END_STRUCT;
	SimpleBlock_Parameters_Hw : 	STRUCT 
		xExistBlock : BOOL;
	END_STRUCT;
	SimpleBlock_Parameters : 	STRUCT 
		Motor : SimpleBlock_Parameters_Motor;
		Hw : SimpleBlock_Parameters_Hw;
		iMotorAxisIndex : INT; (*Index of the vertical motor to assign it*)
		xBeltIsEmpty : BOOL; (*The machine send the information that the belt is empty*)
		xLeftHandMachine : BOOL; (*To indicate that the machine is left hand.*)
		xRightHandMachine : BOOL; (*To indicate that the machine is right hand.*)
	END_STRUCT;
	SimpleBlock_MotorStatus : 	STRUCT 
		xBarsHomed : BOOL;
		xBarsHoming : BOOL;
		rActPosition : REAL; (*Actual Position of the motor in Motor units*)
		rIntensty : REAL; (*Intensity in Amperes (A)*)
		rSpeed : REAL; (*Actual Speed of the axis in mm/s*)
		rOperationTorque : REAL; (*Motor's operation torque*)
		rTorque : REAL; (*Actual Torque of the axis in Nm*)
		xEnableUp : BOOL;
		xEnableDown : BOOL;
		ErrorID : UINT; (*ErrorID of any occurred error*)
	END_STRUCT;
	SimpleBlock_StatusPosition : 	STRUCT 
		xUndefined : BOOL;
		xInCap : BOOL;
		xInPrint : BOOL;
		xGoingToCap : BOOL;
		xGoingToPrint : BOOL;
		xReadyToPrint : BOOL; (*In print postion without safe offsets position*)
	END_STRUCT;
	SimpleBlock_Status : 	STRUCT 
		iBlockCaseLogicControl : INT; (*nState logic control*)
		iBlockState : INT; (*Value to send to Sw: 0=NO_AUTO, 1=IN_CAP, 2=IN_PRINT, 3=CLEANING, 4=GOING_TO_CAP, 5=GOING_TO_PRINT*)
		xEnabledMovements : BOOL;
		xAnyManualMovement : BOOL;
		BlockState : Block_States_enum := BLOCK_STOPPING;
		PositionState : Block_Position_enum := BLOCKP_UNDEFINED;
		Position : SimpleBlock_StatusPosition;
		xCleaningDone : BOOL; (*EDGE*)
		xGoingUpWithNoConsent : BOOL;
		xEnabledToPrint : BOOL;
		xAlarmToEmptyBelt : BOOL; (*This Block has an alarm that requires to empy the belt*)
		rMotorPosition : REAL; (*To Software. Value in mm*)
		execTimes : UDINT;
		Motor : SimpleBlock_MotorStatus;
	END_STRUCT;
	SimpleBlock_Inputs : 	STRUCT 
		xReferenceDI : BOOL;
		xSafetyOK : BOOL; (*Bar Safety Is Ok*)
		xVertTopLimit : BOOL;
		xDifferentialOK : BOOL;
		xDriveProtectionOK : BOOL;
		xEmergencyStop : BOOL; (*Emergency button pushed without diferenciating front or rear*)
	END_STRUCT;
	SimpleBlock : 	STRUCT 
		In : SimpleBlock_Inputs;
		Status : SimpleBlock_Status;
		parameters : SimpleBlock_Parameters;
		parSw : SimpleBlock_SwParameters;
		commands : SimpleBlock_commands; (*all block commands*)
		AlSummary : stEFI_AlarmSummary;
		Al : SimpleBlock_Alarms;
		Lg : SimpleBlock_Log;
		Out : SimpleBlock_Outputs;
	END_STRUCT;
END_TYPE
