(********************************************************************
 * COPYRIGHT - B&R Spain
 ********************************************************************
 * Program: AxisCtrl
 * File: AxisCtrl.typ
 * Author: B&R Spain
 * Created: September 19, 2013
 ********************************************************************
 * Local data types of program AxisCtrl
 ********************************************************************)

TYPE
	AxisState_typ : 
		(
		AX_STATE_DISABLED := 0,
		AX_STATE_HOMING_NO_POWER := 1,
		AX_STATE_SWITCHING_OFF := 2,
		AX_STATE_STANDSTILL := 10,
		AX_STATE_SWITCHING_ON := 11,
		AX_STATE_STOPPING := 12,
		AX_STATE_HOMING := 13,
		AX_STATE_MOVING_ABSOLUTE_0 := 20,
		AX_STATE_MOVING_ABSOLUTE_1 := 21,
		AX_STATE_MOVING_ADDITIVE_0 := 22,
		AX_STATE_MOVING_ADDITIVE_1 := 23,
		AX_STATE_MOVING_VELOCITY_0 := 24,
		AX_STATE_MOVING_VELOCITY_1 := 25,
		AX_STATE_MOVING_GEAR_0 := 40,
		AX_STATE_MOVING_GEAR_1 := 41,
		AX_STATE_HALTING_0 := 26,
		AX_STATE_HALTING_1 := 27,
		AX_STATE_JOGGING_POS := 30,
		AX_STATE_JOGGING_NEG := 31,
		AX_STATE_JOGGING_SS_POS := 32,
		AX_STATE_JOGGING_SS_NEG := 33,
		AX_STATE_JOG_SS_HALTED := 34,
		AX_STATE_HALTING_JOG := 35,
		AX_STATE_UNKNOWN := 200,
		AX_STATE_UK_DISABLED := 201,
		AX_STATE_UK_STANDSTILL := 202,
		AX_STATE_UK_HOMING := 203,
		AX_STATE_UK_DISCRETE_MOTION := 204,
		AX_STATE_UK_CONTINUOUS_MOTION := 205,
		AX_STATE_UK_SYNCHRONIZED_MOTION := 206,
		AX_STATE_UK_STOPPING := 207,
		AX_STATE_UK_ERROR_STOP := 208
		);
	AxisErrorState_typ : 
		(
		AX_ERR_STATE_WAIT := 100, (*constant for the waiting error step*)
		AX_ERR_STATE_APP_ERROR := 101, (*constant for the application error step*)
		AX_ERR_STATE_AXIS_ERROR := 102, (*constant for the axis error step*)
		AX_ERR_STATE_ENCODER_RESET := 103 (*constant for the step where the encoder error is reset*)
		);
END_TYPE
