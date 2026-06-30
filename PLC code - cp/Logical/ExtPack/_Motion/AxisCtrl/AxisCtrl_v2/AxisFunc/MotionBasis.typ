(********************************************************************
 * COPYRIGHT - B&R Spain
 ********************************************************************
 * Package: MotionBasis
 * File: MotionBasis.typ
 * Author: B&R Spain
 * Created: September 19, 2013
 ********************************************************************
 * Data types of package MotionBasis
 ********************************************************************)
(*********************************************************************
* AxisCtrl structures
*********************************************************************)

TYPE
	AxisCtrl_typ : 	STRUCT  (*control structure*)
		Command : AxisCtrl_cmd_typ; (*command structure*)
		Parameter : AxisCtrl_parameter_typ; (*parameter structure*)
		Status : AxisCtrl_status_typ; (*status structure*)
	END_STRUCT;
	AxisCtrl_cmd_typ : 	STRUCT  (*command structure*)
		Power : BOOL; (*switch on the controller*)
		HomeDirect : BOOL; (*reference the axis to a specified position*)
		HomeAbsEncoder : BOOL; (*reference the axis recovering the position from an absolute encoder*)
		Home : BOOL; (*reference the axis (reference switch, stall...)*)
		Move : AxisCtrl_cmd_move_typ; (*movement commands*)
		Jog : AxisCtrl_cmd_jog_typ; (*manual movement commands*)
		QuickStop : BOOL; (*stop every active movement*)
		Reset : BOOL; (*reset axis*)
		ErrorAcknowledge : BOOL; (*reset active errors*)
	END_STRUCT;
	AxisCtrl_cmd_jog_typ : 	STRUCT  (*manual movement structure*)
		StepByStepPos : BOOL; (*move a defiened distance in positive direction*)
		StepByStepNeg : BOOL; (*move a defiened distance in negative direction*)
		ContinuousPos : BOOL; (*start a continuous movement in positive direction*)
		ContinuousNeg : BOOL; (*start a continuous movement in negative direction*)
	END_STRUCT;
	AxisCtrl_cmd_move_typ : 	STRUCT  (*movement structure*)
		Absolute : BOOL; (*move to an absolute position*)
		Additive : BOOL; (*move a defiened distance*)
		Velocity : BOOL; (*EDGE. Start a movement with a defiened velocity*)
		Halt : BOOL; (*EDGE. Halts the movement*)
		GearIn : BOOL; (*Engages to the master*)
		GearOut : BOOL; (*Disengages from the master (continues with actual speed!)*)
	END_STRUCT;
	AxisCtrl_parameter_coms_typ : 	STRUCT 
		DisableReadingTemp : BOOL;
		DisableReadingCurrent : BOOL;
		DisableReadingLagError : BOOL;
		DisableReadingTorque : BOOL;
		ReadRatedTorque : BOOL;
		ReadMaxTorque : BOOL;
	END_STRUCT;
	AxisCtrl_parameter_typ : 	STRUCT  (*parameter structure*)
		HomePosition : REAL; (*reference position*)
		Position : REAL; (*target position for Move.Absolute command*)
		Direction : USINT; (*direction for commanded movements. 0=Positive 1=Negative*)
		Distance : REAL; (*distance for Move.Additive command*)
		Speed : REAL := 1000; (*speed for commanded movements*)
		Acceleration : REAL := 5000; (*acceleration for commanded movements*)
		Deceleration : REAL := 5000; (*deceleration for commanded movements*)
		JogStep : REAL := 10; (*distance for StepByStep command*)
		JogSpeed : REAL := 100; (*speed for manual commanded movements*)
		GearRatioNum : INT := 1000; (*Numerator for gear ratio (The axis will move GearRationNum units for every GearRatioDen units of the master)*)
		GearRationDen : UINT := 1000; (*Denominator for gear ratio (The axis will move GearRationNum units for every GearRatioDen units of the master)*)
		Coms : AxisCtrl_parameter_coms_typ;
		Override : AxisCtrl_parameter_override_typ; (*factors for override*)
		Init : AxisCtrl_parameter_Init_typ;
	END_STRUCT;
	AxisCtrl_parameter_override_typ : 	STRUCT  (*parameter structure*)
		Speed : REAL := 1.0; (*factor for override of speed*)
		Acceleration : REAL := 1.0; (*factor for override of acceleration*)
	END_STRUCT;
	AxisCtrl_parameter_Init_typ : 	STRUCT  (*parameter structure*)
		AxisObjectName : STRING[12]; (*Name of the axis in the NC Mapping Table*)
		MasterGearObjectName : STRING[12]; (*Name of the axis in the NC Mapping Table. Just if GEAR needed in the Axis*)
		rLimitTorquePos : REAL; (*Maximum acceleration/deceleration torque in positive direction [Nm]*)
		rLimitTorqueNeg : REAL; (*Maximum acceleration/deceleration torque in negative direction [Nm]*)
		diLimitNegSwEnd : DINT; (*Limit values: Negative SW end position [Units]*)
		diLimitPosSwEnd : DINT; (*Limit values: Positive SW end position [Units]*)
		rLimitAccStop : REAL; (*Limit acceleration Emergency Stop*)
		rLimitAccNeg : REAL; (*Maximum acceleration in negative direction [Units/s²]*)
		rLimitAccPos : REAL; (*Maximum acceleration in positive direction [Units/s²]*)
		rLimitVelNeg : REAL; (*Maximum speed in negative direction [Units/s]*)
		rLimitVelPos : REAL; (*Maximum speed in positive direction [Units/s]*)
		rHomingAcc : REAL; (*Acceleration for homing procedure [Units/s²]*)
		rHomingVTrigger : REAL; (*Trigger speed [Units/s]*)
		rHomingVSwitch : REAL; (*Speed for searching the reference switch [Units/s]*)
		xEnabledPermEncData : BOOL; (*Enabled permanent Encoder data*)
		xSendAccEmergStopParams : BOOL := FALSE;
		xSendSwEndParams : BOOL := FALSE;
		xSendVelParams : BOOL := FALSE;
		xSendAccParams : BOOL := FALSE;
		xSendHomingParams : BOOL := FALSE;
		xSendTorqueParams : BOOL := FALSE;
	END_STRUCT;
	AxisCtrl_status_typ : 	STRUCT  (*status structure*)
		InitDone : BOOL; (*is set once the initialization has finished*)
		ActPosition : REAL; (*actual position of the axis*)
		ActVelocity : REAL; (*actual velocity of the axis*)
		ActCurrent : REAL; (*Current in Amperes. ICTRL_ISQ_ACT. CTRL Current controller: Actual stator current direct component. Value is PEAK*)
		ActLagError : REAL; (*Actual Torque of the axis in Nm*)
		RatedTorque : REAL; (*Rated Torque of the motor in Nm*)
		ActTorque : REAL; (*Actual Torque of the axis in Nm*)
		PowerOn : BOOL; (*Shows whether the axis is powered or not*)
		HomeOK : BOOL; (*shows whether the home is valid or not*)
		ControllerReady : BOOL; (*shows if controller is ready to switch on*)
		InPosition : BOOL; (*shows whether the axis has reached the target position or not*)
		InGear : BOOL; (*shows whether the axis has finished engaging to the master*)
		DigitalInputs : AxisCtrl_status_DI_typ; (*Logical status of the ACOPOS digital inputs*)
		PLCopenState : AxisCtrl_PLCopenState_typ; (*PLCopen axis state structure*)
		ErrorSource : AxisCtrl_errorSource_enu; (*Source of the reported error*)
		ErrorID : UINT; (*ErrorID of any occurred error*)
		ErrorText : ARRAY[0..3]OF STRING[79]; (*Error description*)
		ActTempDrv : REAL; (*Actual Driver Temperature*)
		ActTempMot : REAL; (*Actual Motor Temperature*)
		MaxTempDrv : REAL; (*Maximum Driver Temperature*)
		MaxTempMotor : REAL; (*Maximum Motor Temperature*)
		MaxAccelerationPos : REAL; (*Maxium Motor Acceleration in Positive Direction*)
		MaxDecelerationPos : REAL; (*Maxium Motor Deceleration in Positive Direction*)
		MaxAccelerationNeg : REAL; (*Maxium Motor Acceleration in Negative Direction*)
		MaxDecelerationNeg : REAL; (*Maxium Motor Deceleration in Negative Direction*)
		MaxSpeed : REAL; (*Motor Max Speed. MOTOR_SPEED_MAX. Value in revs/min*)
		MaxTorque : REAL; (*Max Torque. MOTOR_TORQ_MAX. Values in Nm*)
	END_STRUCT;
	AxisCtrl_status_DI_typ : 	STRUCT  (*Logical status of the ACOPOS digital inputs*)
		Enable : BOOL; (*Enable input*)
		NegLimSwitch : BOOL; (*Negative limit switch input*)
		PosLimSwitch : BOOL; (*Positive  limit switch input*)
		RefSwitch : BOOL; (*Reference switch input*)
		Trigger1 : BOOL; (*Trigger1 input*)
		Trigger2 : BOOL; (*Quickstop/Trigger2 input*)
	END_STRUCT;
	AxisCtrl_PLCopenState_typ : 	STRUCT  (*PLCopen axis state structure*)
		Disabled : BOOL; (*if set, axis is in state Disabled*)
		StandStill : BOOL; (*if set, axis is in state StandsStill*)
		Homing : BOOL; (*if set, axis is in state Homing*)
		Stopping : BOOL; (*if set, axis is in state Stopping*)
		DiscreteMotion : BOOL; (*if set, axis is in state DiscreteMotion*)
		ContinuousMotion : BOOL; (*if set, axis is in state ContinousMotion*)
		SynchronizedMotion : BOOL; (*if set, axis is in state SynchronizedMotion*)
		ErrorStop : BOOL; (*if set, axis is in state ErrorStop*)
	END_STRUCT;
	AxisCtrl_errorSource_enu : 
		(
		ERR_SRC_NO_ERROR,
		ERR_SRC_TASK,
		ERR_SRC_PLC_OPEN,
		ERR_SRC_ACP10
		);
END_TYPE

(*********************************************************************
* GearCtrl structures
*********************************************************************)

TYPE
	GearCtrl_typ : 	STRUCT  (*control structure*)
		Command : GearCtrl_cmd_typ; (*command structure*)
		Parameter : GearCtrl_parameter_typ; (*parameter structure*)
		Status : GearCtrl_status_typ; (*status structure*)
	END_STRUCT;
	GearCtrl_cmd_typ : 	STRUCT  (*command structure*)
		Power : BOOL; (*switch on the controller*)
		HomeDirect : BOOL; (*reference the axis to a specified position*)
		HomeAbsEncoder : BOOL; (*reference the axis recovering the position from an absolute encoder*)
		Home : BOOL; (*reference the axis (reference switch, stall...)*)
		Move : GearCtrl_cmd_move_typ; (*movement commands*)
		Jog : GearCtrl_cmd_jog_typ; (*manual movement commands*)
		QuickStop : BOOL; (*stop every active movement*)
		Reset : BOOL; (*reset axis*)
		ErrorAcknowledge : BOOL; (*reset active errors*)
	END_STRUCT;
	GearCtrl_cmd_jog_typ : 	STRUCT  (*manual movement structure*)
		StepByStepPos : BOOL; (*move a defiened distance in positive direction*)
		StepByStepNeg : BOOL; (*move a defiened distance in negative direction*)
		ContinuousPos : BOOL; (*start a continuous movement in positive direction*)
		ContinuousNeg : BOOL; (*start a continuous movement in negative direction*)
	END_STRUCT;
	GearCtrl_cmd_move_typ : 	STRUCT  (*movement structure*)
		Absolute : BOOL; (*move to an absolute position*)
		Additive : BOOL; (*move a defiened distance*)
		Velocity : BOOL; (*start a movement with a defiened velocity*)
		Halt : BOOL; (*Halts the movement*)
		GearIn : BOOL; (*Engages to the master*)
		GearOut : BOOL; (*Disengages from the master (continues with actual speed!)*)
	END_STRUCT;
	GearCtrl_parameter_Init_typ : 	STRUCT  (*parameter structure*)
		GearObjectName : STRING[12]; (*Name of the axis in the NC Mapping Table*)
	END_STRUCT;
	GearCtrl_parameter_typ : 	STRUCT  (*parameter structure*)
		Init : GearCtrl_parameter_Init_typ;
		HomePosition : REAL; (*reference position*)
		Position : REAL; (*target position for Move.Absolute command*)
		Direction : USINT; (*direction for commanded movements*)
		Distance : REAL; (*distance for Move.Additive command*)
		Speed : REAL; (*speed for commanded movements*)
		Acceleration : REAL; (*acceleration for commanded movements*)
		Deceleration : REAL; (*deceleration for commanded movements*)
		JogStep : REAL; (*distance for StepByStep command*)
		JogSpeed : REAL; (*speed for manual commanded movements*)
		Override : GearCtrl_parameter_override_typ; (*factors for override*)
		GearRatioNum : INT; (*Numerator for gear ratio (The axis will move GearRationNum units for every GearRatioDen units of the master)*)
		GearRationDen : UINT; (*Denominator for gear ratio (The axis will move GearRationNum units for every GearRatioDen units of the master)*)
	END_STRUCT;
	GearCtrl_parameter_override_typ : 	STRUCT  (*parameter structure*)
		Speed : REAL; (*factor for override of speed*)
		Acceleration : REAL; (*factor for override of acceleration*)
	END_STRUCT;
	GearCtrl_status_typ : 	STRUCT  (*status structure*)
		PowerOn : BOOL; (*shows whether the power is on or not*)
		InitDone : BOOL; (*is set once the initialization has finished*)
		ActPosition : REAL; (*actual position of the axis*)
		ActVelocity : REAL; (*actual velocity of the axis*)
		HomeOK : BOOL; (*shows whether the home is valid or not*)
		ControllerReady : BOOL; (*shows if controller is ready to switch on*)
		InPosition : BOOL; (*shows whether the axis has reached the target position or not*)
		InGear : BOOL; (*shows whether the axis has finished engaging to the master*)
		DigitalInputs : GearCtrl_status_DI_typ; (*Logical status of the ACOPOS digital inputs*)
		PLCopenState : GearCtrl_PLCopenState_typ; (*PLCopen axis state structure*)
		ErrorSource : AxisCtrl_errorSource_enu; (*Source of the reported error*)
		ErrorID : UINT; (*ErrorID of any occurred error*)
		ErrorText : ARRAY[0..3]OF STRING[79]; (*Error description*)
	END_STRUCT;
	GearCtrl_status_DI_typ : 	STRUCT  (*Logical status of the ACOPOS digital inputs*)
		Enable : BOOL; (*Enable input*)
		NegLimSwitch : BOOL; (*Negative limit switch input*)
		PosLimSwitch : BOOL; (*Positive  limit switch input*)
		RefSwitch : BOOL; (*Reference switch input*)
		Trigger1 : BOOL; (*Trigger1 input*)
		Trigger2 : BOOL; (*Quickstop/Trigger2 input*)
	END_STRUCT;
	GearCtrl_PLCopenState_typ : 	STRUCT  (*PLCopen axis state structure*)
		Disabled : BOOL; (*if set, axis is in state Disabled*)
		StandStill : BOOL; (*if set, axis is in state StandsStill*)
		Homing : BOOL; (*if set, axis is in state Homing*)
		Stopping : BOOL; (*if set, axis is in state Stopping*)
		DiscreteMotion : BOOL; (*if set, axis is in state DiscreteMotion*)
		ContinuousMotion : BOOL; (*if set, axis is in state ContinousMotion*)
		SynchronizedMotion : BOOL; (*if set, axis is in state SynchronizedMotion*)
		ErrorStop : BOOL; (*if set, axis is in state ErrorStop*)
	END_STRUCT;
END_TYPE

(*********************************************************************
	* CamCtrl structures
	*********************************************************************)

TYPE
	CamCtrl_typ : 	STRUCT  (*control structure*)
		Command : CamCtrl_cmd_typ; (*command structure*)
		Parameter : CamCtrl_parameter_typ; (*parameter structure*)
		Status : CamCtrl_status_typ; (*status structure*)
	END_STRUCT;
	CamCtrl_cmd_typ : 	STRUCT  (*command structure*)
		Power : BOOL; (*switch on the controller*)
		HomeDirect : BOOL; (*reference the axis to a specified position*)
		HomeAbsEncoder : BOOL; (*reference the axis recovering the position from an absolute encoder*)
		Home : BOOL; (*reference the axis (reference switch, stall...)*)
		Move : CamCtrl_cmd_move_typ; (*movement commands*)
		Jog : CamCtrl_cmd_jog_typ; (*manual movement commands*)
		QuickStop : BOOL; (*stop every active movement*)
		Reset : BOOL; (*reset axis*)
		ErrorAcknowledge : BOOL; (*reset active errors*)
	END_STRUCT;
	CamCtrl_cmd_jog_typ : 	STRUCT  (*manual movement structure*)
		StepByStepPos : BOOL; (*move a defiened distance in positive direction*)
		StepByStepNeg : BOOL; (*move a defiened distance in negative direction*)
		ContinuousPos : BOOL; (*start a continuous movement in positive direction*)
		ContinuousNeg : BOOL; (*start a continuous movement in negative direction*)
	END_STRUCT;
	CamCtrl_cmd_move_typ : 	STRUCT  (*movement structure*)
		Absolute : BOOL; (*move to an absolute position*)
		Additive : BOOL; (*move a defiened distance*)
		Velocity : BOOL; (*start a movement with a defiened velocity*)
		Halt : BOOL; (*Halts the movement*)
		CamIn : BOOL; (*Engages to the master (cannot be commanded if the axis is in SynchronizedMotion)*)
		CamOut : BOOL; (*Disengages from the master (continues with actual speed!)*)
	END_STRUCT;
	CamCtrl_parameter_typ : 	STRUCT  (*parameter structure*)
		HomePosition : REAL; (*reference position*)
		Position : REAL; (*target position for Move.Absolute command*)
		Direction : USINT; (*direction for commanded movements*)
		Distance : REAL; (*distance for Move.Additive command*)
		Speed : REAL; (*speed for commanded movements*)
		Acceleration : REAL; (*acceleration for commanded movements*)
		Deceleration : REAL; (*deceleration for commanded movements*)
		JogStep : REAL; (*distance for StepByStep command*)
		JogSpeed : REAL; (*speed for manual commanded movements*)
		Override : CamCtrl_parameter_override_typ; (*factors for override*)
		CamSlaveScaling : INT; (*Factor for the master profile*)
		CamMasterScaling : UINT; (*Factor for the slave profile*)
	END_STRUCT;
	CamCtrl_parameter_override_typ : 	STRUCT  (*parameter structure*)
		Speed : REAL := 1.0; (*factor for override of speed*)
		Acceleration : REAL := 1.0; (*factor for override of acceleration*)
	END_STRUCT;
	CamCtrl_status_typ : 	STRUCT  (*status structure*)
		InitDone : BOOL; (*is set once the initialization has finished*)
		ActPosition : REAL; (*actual position of the axis*)
		ActVelocity : REAL; (*actual velocity of the axis*)
		HomeOK : BOOL; (*shows whether the home is valid or not*)
		ControllerReady : BOOL; (*shows if controller is ready to switch on*)
		InPosition : BOOL; (*shows whether the axis has reached the target position or not*)
		InSync : BOOL; (*shows whether the axis has finished engaging to the master*)
		DigitalInputs : CamCtrl_status_DI_typ; (*Logical status of the ACOPOS digital inputs*)
		PLCopenState : CamCtrl_PLCopenState_typ; (*PLCopen axis state structure*)
		ErrorID : UINT; (*ErrorID of any occurred error*)
		ErrorText : ARRAY[0..3]OF STRING[79]; (*Error description*)
	END_STRUCT;
	CamCtrl_status_DI_typ : 	STRUCT  (*Logical status of the ACOPOS digital inputs*)
		Enable : BOOL; (*Enable input*)
		NegLimSwitch : BOOL; (*Negative limit switch input*)
		PosLimSwitch : BOOL; (*Positive  limit switch input*)
		RefSwitch : BOOL; (*Reference switch input*)
		Trigger1 : BOOL; (*Trigger1 input*)
		Trigger2 : BOOL; (*Quickstop/Trigger2 input*)
	END_STRUCT;
	CamCtrl_PLCopenState_typ : 	STRUCT  (*PLCopen axis state structure*)
		Disabled : BOOL; (*if set, axis is in state Disabled*)
		StandStill : BOOL; (*if set, axis is in state StandsStill*)
		Homing : BOOL; (*if set, axis is in state Homing*)
		Stopping : BOOL; (*if set, axis is in state Stopping*)
		DiscreteMotion : BOOL; (*if set, axis is in state DiscreteMotion*)
		ContinuousMotion : BOOL; (*if set, axis is in state ContinousMotion*)
		SynchronizedMotion : BOOL; (*if set, axis is in state SynchronizedMotion*)
		ErrorStop : BOOL; (*if set, axis is in state ErrorStop*)
	END_STRUCT;
END_TYPE

(*********************************************************************
	* AutCtrl structures
	*********************************************************************)

TYPE
	AutCtrl_typ : 	STRUCT  (*control structure*)
		Command : AutCtrl_cmd_typ; (*command structure*)
		Parameter : AutCtrl_parameter_typ; (*parameter structure*)
		Status : AutCtrl_status_typ; (*status structure*)
	END_STRUCT;
	AutCtrl_cmd_typ : 	STRUCT  (*command structure*)
		Power : BOOL; (*switch on the controller*)
		HomeDirect : BOOL; (*reference the axis to a specified position*)
		HomeAbsEncoder : BOOL; (*reference the axis recovering the position from an absolute encoder*)
		Home : BOOL; (*reference the axis (reference switch, stall...)*)
		Move : AutCtrl_cmd_move_typ; (*movement commands*)
		Jog : AutCtrl_cmd_jog_typ; (*manual movement commands*)
		AutSignals : AutCtrl_cmd_autSignals_typ;
		QuickStop : BOOL; (*stop every active movement*)
		Reset : BOOL; (*reset axis*)
		ErrorAcknowledge : BOOL; (*reset active errors*)
	END_STRUCT;
	AutCtrl_cmd_jog_typ : 	STRUCT  (*manual movement structure*)
		StepByStepPos : BOOL; (*move a defiened distance in positive direction*)
		StepByStepNeg : BOOL; (*move a defiened distance in negative direction*)
		ContinuousPos : BOOL; (*start a continuous movement in positive direction*)
		ContinuousNeg : BOOL; (*start a continuous movement in negative direction*)
	END_STRUCT;
	AutCtrl_cmd_move_typ : 	STRUCT  (*movement structure*)
		Absolute : BOOL; (*move to an absolute position*)
		Additive : BOOL; (*move a defiened distance*)
		Velocity : BOOL; (*start a movement with a defiened velocity*)
		Halt : BOOL; (*Halts the movement*)
		StartAutomat : BOOL; (*Engages to the master / updates the Automat*)
	END_STRUCT;
	AutCtrl_cmd_autSignals_typ : 	STRUCT  (*movement structure*)
		Signal1 : BOOL; (*Automat's signal 1*)
		Signal2 : BOOL; (*Automat's signal 2*)
		Signal3 : BOOL; (*Automat's signal 3*)
		Signal4 : BOOL; (*Automat's signal 4*)
	END_STRUCT;
	AutCtrl_parameter_typ : 	STRUCT  (*parameter structure*)
		HomePosition : REAL; (*reference position*)
		Position : REAL; (*target position for Move.Absolute command*)
		Direction : USINT; (*direction for commanded movements*)
		Distance : REAL; (*distance for Move.Additive command*)
		Speed : REAL; (*speed for commanded movements*)
		Acceleration : REAL; (*acceleration for commanded movements*)
		Deceleration : REAL; (*deceleration for commanded movements*)
		JogStep : REAL; (*distance for StepByStep command*)
		JogSpeed : REAL; (*speed for manual commanded movements*)
		Override : AutCtrl_parameter_override_typ; (*factors for override*)
	END_STRUCT;
	AutCtrl_parameter_override_typ : 	STRUCT  (*parameter structure*)
		Speed : REAL; (*factor for override of speed*)
		Acceleration : REAL; (*factor for override of acceleration*)
	END_STRUCT;
	AutCtrl_status_CamType_typ : 
		( (*cam type*)
		CAM := 0,
		COMPENSATION := 1
		);
	AutCtrl_status_typ : 	STRUCT  (*status structure*)
		InitDone : BOOL; (*is set once the initialization has finished*)
		ActPosition : REAL; (*actual position of the axis*)
		ActVelocity : REAL; (*actual velocity of the axis*)
		HomeOK : BOOL; (*shows whether the home is valid or not*)
		ControllerReady : BOOL; (*shows if controller is ready to switch on*)
		InPosition : BOOL; (*shows whether the axis has reached the target position or not*)
		InSync : BOOL; (*shows whether the axis has finished engaging to the master*)
		AutActualState : USINT; (*shows the actual state of the Automat*)
		AutActualCamType : AutCtrl_status_CamType_typ; (*shows the actual state of the Automat*)
		DigitalInputs : AutCtrl_status_DI_typ; (*Logical status of the ACOPOS digital inputs*)
		PLCopenState : AutCtrl_PLCopenState_typ; (*PLCopen axis state structure*)
		ErrorID : UINT; (*ErrorID of any occurred error*)
		ErrorText : ARRAY[0..3]OF STRING[79]; (*Error description*)
	END_STRUCT;
	AutCtrl_status_DI_typ : 	STRUCT  (*Logical status of the ACOPOS digital inputs*)
		Enable : BOOL; (*Enable input*)
		NegLimSwitch : BOOL; (*Negative limit switch input*)
		PosLimSwitch : BOOL; (*Positive  limit switch input*)
		RefSwitch : BOOL; (*Reference switch input*)
		Trigger1 : BOOL; (*Trigger1 input*)
		Trigger2 : BOOL; (*Quickstop/Trigger2 input*)
	END_STRUCT;
	AutCtrl_PLCopenState_typ : 	STRUCT  (*PLCopen axis state structure*)
		Disabled : BOOL; (*if set, axis is in state Disabled*)
		StandStill : BOOL; (*if set, axis is in state StandsStill*)
		Homing : BOOL; (*if set, axis is in state Homing*)
		Stopping : BOOL; (*if set, axis is in state Stopping*)
		DiscreteMotion : BOOL; (*if set, axis is in state DiscreteMotion*)
		ContinuousMotion : BOOL; (*if set, axis is in state ContinousMotion*)
		SynchronizedMotion : BOOL; (*if set, axis is in state SynchronizedMotion*)
		ErrorStop : BOOL; (*if set, axis is in state ErrorStop*)
	END_STRUCT;
END_TYPE

(*********************************************************************
	* Stepper X2X Ctrl structures
	*********************************************************************)

TYPE
	StepperCtrlX2X_typ : 	STRUCT 
		gAxis : ACP10AXIS_typ;
		HW : SdcHwCfg_typ;
		DrvIf : SdcDrvIf16_typ;
		EncIf1 : SdcEncIf16_typ;
		DiDoIf : SdcDiDoIf_typ;
		MotorStep0 : INT;
	END_STRUCT;
END_TYPE

(*********************************************************************

	* ISQ Ripple data structures

	*********************************************************************)

TYPE
	MC_ISQ_RippleData_typ : 	STRUCT 
		xDataOK : BOOL := FALSE;
		singleData : ARRAY[0..9]OF MC_ISQ_RippleSingleData_typ;
	END_STRUCT;
	MC_ISQ_RippleSingleData_typ : 	STRUCT  (*p*)
		Phi : REAL := 0; (*Phase of the data*)
		Amp : REAL := 0; (*Amplitude of the data*)
		Freq : REAL := 0; (*Frequency of the data*)
	END_STRUCT;
END_TYPE
