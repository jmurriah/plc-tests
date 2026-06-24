
ACTION dataToMotors: 		
	rJogSpeedSetPoint:=data.parameters.JogSpeed;
	
	//Drive Unit data Managment
	MotorDriveUnit.TransmissionData := data.parameters.DriveUnit;
	
	MotorDriveUnit.HomePositionDesired:=data.Motor[iIndexIclaMotor].rHomePosition;;
	MotorDriveUnit.Calculation:=CALC_HOMEPOS_PULSES;
	MotorDriveUnit();
	
	MotorDriveUnit.SpeedDesired:=data.parameters.Speed;
	MotorDriveUnit.Calculation:=CALC_SPEED_PULSES;
	MotorDriveUnit();
	
	MotorDriveUnit.JogSpeedDesired:=rJogSpeedSetPoint;
	MotorDriveUnit.Calculation:=CALC_JOGSPEED_PULSES;
	MotorDriveUnit();
	
	MotorDriveUnit.AccelerationDesired:=data.parameters.Acceleration;
	MotorDriveUnit.Calculation:=CALC_ACC_PULSES;
	MotorDriveUnit();
	
	AssignDataToMotors;
END_ACTION


ACTION AssignDataToMotors: 
	
	//Position
	//IclaMotors[iIndexIclaMotor].Parameter.MoveAbsolute.Position := REAL_TO_DINT(MotorDriveUnit.pulsesPositionDesired);

	//Speed
	IclaMotors[iIndexIclaMotor].Parameter.MoveAbsolute.Velocity := REAL_TO_UINT(MotorDriveUnit.pulsesSpeedDesired);
	
	//Jog Speed
	IclaMotors[iIndexIclaMotor].Parameter.Jog.VeloSlow 			:= REAL_TO_UINT(MotorDriveUnit.pulsesJogSpeedDesired);
	IclaMotors[iIndexIclaMotor].Command.JogFastSpeed 			:= FALSE;
	
	//Acceleration
	IclaMotors[iIndexIclaMotor].Parameter.iAcceleration 		:= REAL_TO_UINT(MotorDriveUnit.pulsesAccelerationDesired);
	
	//Home
	IclaMotors[iIndexIclaMotor].Parameter.Home.Position 		:= REAL_TO_DINT(MotorDriveUnit.pulsesHomePositionDesired);

	
	//Reset
	IclaMotors[iIndexIclaMotor].Command.Reset 					:= 	data.commands.xResetMotor OR (data.commands.xErrorRst AND 
																	IclaMotors[iIndexIclaMotor].Status.IclaStatus <> AXISILE_MOVE_ABSOLUTE AND
																	IclaMotors[iIndexIclaMotor].Status.IclaStatus <> AXISILE_JOG AND
																	IclaMotors[iIndexIclaMotor].Status.IclaStatus <> AXISILE_HOMING);

END_ACTION


ACTION dataFromMotors: 

	xAnyManualMovement:= (IclaMotors[iIndexIclaMotor].Status.IclaStatus = AXISILE_JOG);
	
	MotorDriveUnit.pulsesDevice 	:= DINT_TO_REAL(IclaMotors[iIndexIclaMotor].Status.iActualPosition);
	MotorDriveUnit.PulsesSpeedDevice:=IclaMotors[iIndexIclaMotor].Status.iActualVelocity;

	// Conversions
	MotorDriveUnit.Calculation:= CALC_POS_MM;
	MotorDriveUnit();
	rPositionMotorMm := data.Motor[iIndexIclaMotor].iDirection * MotorDriveUnit.PositionDevice;

	data.Motor[iIndexIclaMotor].rPositionMotor := rPositionMotorMm;
	data.Motor[iIndexIclaMotor].rMetalStrapPos := ABS(rPositionMotorMm)*2 + gEdgeHoldDown.Hw.rMinWidthAdjustment;
	
	MotorDriveUnit.Calculation:= CALC_SPEED_MM;
	MotorDriveUnit();

END_ACTION



