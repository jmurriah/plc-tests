 
ACTION ControlState:
	
	// General states
	Block.Status.Motor.xBarsHoming:= AxisBK.Status.PLCopenState.Homing; //  States for Homing block
	Block.Status.Motor.ErrorID := AxisBK.Status.ErrorID;
	Block.Status.Motor.ActPosition := REAL_TO_UDINT(AxisBK.Status.ActPosition);
	
	//Motor status read from drives
	//Torque
	Block.Status.Motor.rActTorque	:= ABS(AxisBK.Status.ActTorque);
	Block.Status.Motor.rMaxTorque	:= ABS(AxisBK.Status.MaxTorque);
	Block.Status.Motor.rRatedTorque	:= ABS(AxisBK.Status.RatedTorque);
	
	IF NOT Block.parameters.Motor.xOversized THEN
		Block.Status.Motor.rOperationTorque := Block.Status.Motor.rRatedTorque;
	ELSE
		Block.Status.Motor.rOperationTorque := Block.parameters.Motor.rOperationTorque;
	END_IF
	
	
	//Temp
	Block.Status.Motor.rActTemp	:= AxisBK.Status.ActTempMot;
	Block.Status.Motor.rMaxTemp	:= AxisBK.Status.MaxTempMotor;
	Block.Status.Motor.rSpeed	:= AxisBK.Status.ActVelocity;
	
	//Velocity
	MotorDriveUnit.PulsesSpeedDevice := AxisBK.Status.ActVelocity;
	MotorDriveUnit.Calculation := CALC_SPEED_MM;
	MotorDriveUnit();
	Block.Status.Motor.rActVelocity := MotorDriveUnit.SpeedDevice;
	
	MotorDriveUnit.PulsesSpeedDevice := AxisBK.Status.MaxSpeed;
	MotorDriveUnit.Calculation := CALC_SPEED_MM;
	MotorDriveUnit();
	Block.Status.Motor.rMaxVelocity := MotorDriveUnit.SpeedDevice;
	
	
	
	//Icla	
	Block.Status.Icla.xHomed:= Block.Status.Icla.xHomed;
	Block.Status.Icla.xHoming := Block.Status.PositionState = BLOCKP_HOMING_ICLA; //Those are the states for Homing
	Block.Status.Icla.ErrorNumber:=IclaBK.Status.Error.ErrorNumber;
	Block.Status.Icla.xInError := IclaBK.Status.xInError;
	
	
	//Torque
//	Block.Status.Icla.rActTorque	:= IclaBK.Status.iActualVelocity;
//	Block.Status.Icla.rMaxTorque	:= IclaBK.Status.iActualVelocity;
	
	//Temp
//	Block.Status.Icla.rActTemp	:= IclaBK.Status.iActualVelocity;
//	Block.Status.Icla.rMaxTemp	:= IclaBK.Status.iActualVelocity;
	
	//Velocity
	Block.Status.Icla.iSpeed := IclaBK.Status.iActualVelocity;
//	Block.Status.Icla.iMaxSpeed := IclaBK.Status.iActualVelocity;
	
	
	xAnyManualMovement:=(AxisBK.Status.PLCopenState.ContinuousMotion OR xIclaMoving OR Block.Status.Icla.xHoming) AND (Block.commands.Mode.xManual);
	Block.Status.xAnyManualMovement:=xAnyManualMovement;

END_ACTION
