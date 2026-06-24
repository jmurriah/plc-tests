PROGRAM _INIT
  
	//Define a transmision data to do the first calculations and be receptive to next calculations	
	BeltDriveUnit.TransmissionData.TransmissionType := TRANS_LINEAL_PERIMETER;
	BeltDriveUnit.TransmissionData.LinealPerimeter.PulsesPerTurn := GC_UNITS_BY_REV_DRIVE;
	BeltDriveUnit.TransmissionData.LinealPerimeter.GearBox := 10.0;
	BeltDriveUnit.TransmissionData.LinealPerimeter.Perimeter := 500.0;
	
	//
	BeltDriveUnit.AccelerationDesired := 10;
	BeltDriveUnit.Calculation := CALC_ACC_PULSES;
	BeltDriveUnit();

	BeltDriveUnit.DecelerationDesired := 10;
	BeltDriveUnit.Calculation := CALC_DEC_PULSES;
	BeltDriveUnit();	

END_PROGRAM
      

PROGRAM _CYCLIC

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN			MAIN			MAIN			MAIN			MAIN			MAIN			MAIN			MAIN			MAIN			MAIN
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Main program is calling all program actions
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	// Reference AxisCtrl
	Belt ACCESS ADR (gBelt); //[RGP] This must point to an gBelt[iIndexBelt] in v2. FOR v1 stays as gBelt TO NOT modify the rest OF the PROGRAM were gBelt is being used
	AxisBelt ACCESS ADR (gAxis[Belt.parameters.IndexAxis]);
	
	// Reset action
	IF NOT Belt.parameters.xExistBelt THEN
		ResetAlarms;
		RETURN;
	END_IF
	
	// Reset Alarms
	IF Belt.commands.xReset THEN
		ResetAlarms;
	END_IF	

	// Alarms action	
	Alarms;
	
	// Critical alarms not allowing to do nothing
	IF Belt.Al.xAxisLengthNotDefined OR Belt.Al.xGearBoxNotDefined THEN
		RETURN;
	END_IF
		
	Belt.states.xOrderRuning := iBeltState=BELT_PREPARING_START OR iBeltState=BELT_RUN_ORDER OR iBeltState=BELT_RUNNING;
	
	///////////////////////////////////
	// In progress
	///////////////////////////////////
	
	BeltStates; // States Belt
	
	//Limits
	Belt.parameters.rSetPointSpeed := LIMIT(5.0, Belt.parameters.rSetPointSpeed, Belt.states.rMaxSpeed);
	IF Belt.parameters.xRemoteAcceleration AND Belt.commands.xUseJogAccDecc THEN
		Belt.states.rAcceleration := Belt.parSw.rAcceleration;
	ELSE
		Belt.states.rAcceleration := Belt.parameters.rAcceleration;
	END_IF
	Belt.states.rAcceleration := LIMIT(5.0, Belt.states.rAcceleration, Belt.parameters.rMaxAcceleration);
	
	IF Belt.parameters.xRemoteDeceleration AND Belt.commands.xUseJogAccDecc THEN
		Belt.states.rDeceleration := Belt.parSw.rDeceleration;
		
	ELSIF Belt.commands.xUseSoftDeceleration THEN
		Belt.states.rDeceleration := Belt.parameters.rSoftDeceleration;
		
	ELSE
		Belt.states.rDeceleration := Belt.parameters.rDeceleration;
	END_IF
	
	Belt.states.rDeceleration := LIMIT(500.0, Belt.states.rDeceleration, Belt.parameters.rMaxDeceleration);

	
	AxisBelt.Parameter.Direction:= Belt.parameters.Direction;

	
	xRunningState := iBeltState=BELT_RUNNING OR iBeltState=BELT_RUN_ORDER OR iBeltState=BELT_JOGGING;
	
	//Set velocity. Calculate speed in pulses with DriveUnit
	BeltDriveUnit.TransmissionData := Belt.parameters.DriveUnit;
	BeltDriveUnit.SpeedMminDesired := MAX(Belt.parameters.rSetPointSpeed, 0.5); 	//It avoids a 0 speed and do not see a Continuous Movement state
	BeltDriveUnit.Calculation := CALC_SPEED_MMIN_PULSES;
	BeltDriveUnit();
	
	//Definet the Status of the BELT with the Status of the Axis
	BeltDriveUnit.PulsesSpeedDevice := AxisBelt.Status.ActVelocity;
	BeltDriveUnit.Calculation := CALC_SPEED_MMIN;
	BeltDriveUnit();
	
	Belt.states.rCurrentSpeed	:= ABS(BeltDriveUnit.SpeedMminDevice);
	Belt.states.rCurrentSpeedUnits := ABS(AxisBelt.Status.ActVelocity);
	
	Belt.states.rMaxTemperature := ABS(AxisBelt.Status.MaxTempMotor);
	
	BeltDriveUnit.RevMinSpeedDevice := AxisBelt.Status.MaxSpeed;
	BeltDriveUnit.Calculation := CALC_SPEED_REVMIN_MMIN;
	BeltDriveUnit();
	Belt.states.Hw.rMaxSpeed := ABS(BeltDriveUnit.SpeedRpmToMmin);
	
	BeltDriveUnit.AccelerationDesired := Belt.states.rAcceleration;
	BeltDriveUnit.Calculation := CALC_ACC_PULSES;
	BeltDriveUnit();
	AxisBelt.Parameter.Acceleration := BeltDriveUnit.pulsesAccelerationDesired;

	
	BeltDriveUnit.DecelerationDesired := Belt.states.rDeceleration;
	BeltDriveUnit.Calculation := CALC_DEC_PULSES;
	BeltDriveUnit();
	AxisBelt.Parameter.Deceleration := BeltDriveUnit.pulsesDecelerationDesired;
	
	Belt.states.rActualCurrent := AxisBelt.Status.ActCurrent;
	
	Belt.states.rMaxTorque := ABS(MAX(AxisBelt.Status.MaxTorque, 0.001)); //rMaxTorque cannot be negative and cannot be 0
	
	IF Belt.states.rCurrentSpeed = 0 THEN
		Belt.states.rCurrentTorque	:= 0;
	ELSE
		Belt.states.rCurrentTorque	:= AxisBelt.Status.ActTorque;
	END_IF
	Belt.states.rCurrentTorque := ABS(Belt.states.rCurrentTorque);
	
	IF AxisBelt.Status.RatedTorque <> 0 THEN
		Belt.states.rTorquePerc		:= ABS(Belt.states.rCurrentTorque*100/AxisBelt.Status.RatedTorque);
	END_IF
	
	IF AxisBelt.Status.MaxAccelerationPos <> 0 THEN
		BeltDriveUnit.PulsesAccelerationDevice := AxisBelt.Status.MaxAccelerationPos;
		BeltDriveUnit.Calculation := CALC_ACC_MM;
		BeltDriveUnit();
		
		Belt.states.MaxPosAcceleration	:= ABS(BeltDriveUnit.mmAcceleration);
	END_IF
	
	IF AxisBelt.Status.MaxDecelerationPos <> 0 THEN
		BeltDriveUnit.PulsesDecelerationDevice := AxisBelt.Status.MaxDecelerationPos;
		BeltDriveUnit.Calculation := CALC_DEC_MM;
		BeltDriveUnit();
		
		Belt.states.MaxPosDeceleration	:= ABS(BeltDriveUnit.mmDeceleration);
	END_IF
	
	IF AxisBelt.Status.MaxAccelerationNeg <> 0 THEN
		BeltDriveUnit.PulsesAccelerationDevice := AxisBelt.Status.MaxAccelerationNeg;
		BeltDriveUnit.Calculation := CALC_ACC_MM;
		BeltDriveUnit();
		
		Belt.states.MaxNegAcceleration	:= ABS(BeltDriveUnit.mmAcceleration);
	END_IF
	
	IF AxisBelt.Status.MaxDecelerationNeg <> 0 THEN
		BeltDriveUnit.PulsesDecelerationDevice := AxisBelt.Status.MaxDecelerationNeg;
		BeltDriveUnit.Calculation := CALC_DEC_MM;
		BeltDriveUnit();
		
		Belt.states.MaxNegDeceleration	:= ABS(BeltDriveUnit.mmDeceleration);
	END_IF
	
	Belt.states.ErrorId 		:= AxisBelt.Status.ErrorID;
	
	
	//Just activating the signal with the order, so when stopping, the signal is lowered faster
	Belt.states.xRuningBelt		:= AxisBelt.Status.PLCopenState.ContinuousMotion AND (Belt.commands.xRunBelt OR Belt.commands.xJogBelt); 
	
	//Calculation of belt's motor position
	BeltDriveUnit.pulsesDevice := AxisBelt.Status.ActPosition;
	BeltDriveUnit.Calculation := CALC_POS_MM;
	BeltDriveUnit();
	Belt.states.rMotorPosition := BeltDriveUnit.PositionDevice;
	
	
	// Sending axis motion orders
	AxisBelt.Command.Move.Halt     := AxisBelt.Status.PLCopenState.ContinuousMotion AND NOT xRunningState;
	AxisBelt.Command.Move.Velocity := EDGEPOS(xRunningState) OR (xRunningState AND AxisBelt.Parameter.Speed <> BeltDriveUnit.pulsesSpeedDesired); // JMH: It is important the order of these two lines
	AxisBelt.Parameter.Speed       := BeltDriveUnit.pulsesSpeedDesired; // JMH: It is important the order of these two lines
	
	
	Belt.states.rMaxSpeed := MIN(Belt.parameters.rMaxSpeed, Belt.states.Hw.rMaxSpeed);
	
	
	iTimesExecuted:=iTimesExecuted+1;
	
END_PROGRAM



