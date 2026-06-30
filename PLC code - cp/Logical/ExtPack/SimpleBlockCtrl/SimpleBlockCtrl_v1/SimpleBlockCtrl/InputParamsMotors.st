
ACTION InputParamsMotors: 
	
	//MOTOR   MOTOR   MOTOR   MOTOR   MOTOR   MOTOR   MOTOR   MOTOR   MOTOR   MOTOR
	//MOTOR   MOTOR   MOTOR   MOTOR   MOTOR   MOTOR   MOTOR   MOTOR   MOTOR   MOTOR
	//MOTOR   MOTOR   MOTOR   MOTOR   MOTOR   MOTOR   MOTOR   MOTOR   MOTOR   MOTOR

	MotorDriveUnit.TransmissionData:=Block.parameters.Motor.DriveUnit;
	
	// PowerOn Command
	AxisBK.Command.Power:= 	NOT Block.Al.xAlrSafetySystemInBlock AND
							AxisBK.Status.ControllerReady AND
							AxisBK.Status.InitDone;
		
	// In (mm *10)
	IF AxisBK.Status.HomeOK THEN MotorDriveUnit.pulsesDevice := AxisBK.Status.ActPosition; END_IF //TODO: Remove the HomeOK condition. Now to avoid the NotANumer error
	MotorDriveUnit.Calculation := CALC_POS_MM;
	MotorDriveUnit();
	rMotorCurrentPos:=MotorDriveUnit.PositionDevice;
	Block.Status.rMotorPosition:=rMotorCurrentPos; //Use internal var to assign it
		
	//Log the Position after to be in position
	IF EDGEPOS(AxisBK.Status.InPosition) THEN
		LogVertInPosition;
	END_IF
	
	// Position for absolute movement order	// In (mm *10)			
	// Move Absolute
	MotorDriveUnit.PositionDesired := rMotorAbsPosDesired;
	MotorDriveUnit.Calculation := CALC_POS_PULSES;
	MotorDriveUnit();
	AxisBK.Parameter.Position:= MotorDriveUnit.pulsesPositionDesired;
	
	// Auto Acceleration, Velocity Movements		
	//AxisBK.Parameter.Acceleration:=	250000;
	MotorDriveUnit.AccelerationDesired := Block.parameters.Motor.rAcceleration;
	MotorDriveUnit.Calculation := CALC_ACC_PULSES;
	MotorDriveUnit();
	AxisBK.Parameter.Acceleration := MotorDriveUnit.pulsesAccelerationDesired;
	
	//AxisBK.Parameter.Deceleration:=	250000;
	MotorDriveUnit.DecelerationDesired := Block.parameters.Motor.rDeceleration;
	MotorDriveUnit.Calculation := CALC_DEC_PULSES;
	MotorDriveUnit();
	AxisBK.Parameter.Deceleration := MotorDriveUnit.pulsesDecelerationDesired;
	
	
	//Change manual Speed
	IF xChangeMotorSpeedUp OR xChangeMotorSpeedDown THEN
		MotorDriveUnit.JogSpeedDesired := 2.0;
	ELSE
		MotorDriveUnit.JogSpeedDesired := Block.parameters.Motor.rDriveManSpeed;
	END_IF
	
	MotorDriveUnit.Calculation := CALC_JOGSPEED_PULSES;
	MotorDriveUnit();
	AxisBK.Parameter.JogSpeed := MotorDriveUnit.pulsesJogSpeedDesired;
	
	// Speed paramter for auto movements
	MotorDriveUnit.SpeedDesired := Block.parameters.Motor.rDriveAutoSpeed;
	MotorDriveUnit.Calculation := CALC_SPEED_PULSES;
	MotorDriveUnit();
	AxisBK.Parameter.Speed := MotorDriveUnit.pulsesSpeedDesired;

	// Homing: Reference Position
	MotorDriveUnit.HomePositionDesired := Block.parameters.Motor.rReferencePosition;
	MotorDriveUnit.Calculation := CALC_HOMEPOS_PULSES;
	MotorDriveUnit();
	AxisBK.Parameter.HomePosition := MotorDriveUnit.pulsesHomePositionDesired ; // Tranfer in parameter structure 
	
	//Removed the edgepos. It is possible because Block is executed more than x2 lower than axis
	IF xMotorAbsMovOrder AND AxisBK.Status.HomeOK THEN
		AxisBK.Command.Move.Absolute:= TRUE;
		xMotorAbsMovOrder := FALSE;

		// Move absolute counter	
		Block.Lg.diMoveAbsCounter:= Block.Lg.diMoveAbsCounter+1;	
		LogVertMovementOrder;
	END_IF

	// Block.commands.xBarHomeOrder comes from kernel2Sw and directo to axis
	// Home order
	AxisBK.Command.Home:= EDGEPOS(xMotorHomeOrder);	

	AxisBK.Command.Reset:= ((AxisBK.Status.ErrorID<>0) OR AxisBK.Status.PLCopenState.ErrorStop) AND Block.commands.xReset;
	AxisBK.Command.ErrorAcknowledge:= ((AxisBK.Status.ErrorID<>0) AND Block.commands.xReset) OR
										(AxisBK.Status.ErrorID=6023) OR 
										(AxisBK.Status.ErrorID=29216) OR 
										(AxisBK.Status.ErrorID=5001) OR 
										(AxisBK.Status.ErrorID=29207) ;
	
END_ACTION
