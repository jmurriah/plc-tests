 
ACTION ControlState:
	
	// General states
	Block.Status.Motor.xBarsHoming:= AxisBK.Status.PLCopenState.Homing; //  States for Homing block
	Block.Status.Motor.rTorque := AxisBK.Status.ActTorque;
	Block.Status.Motor.ErrorID := AxisBK.Status.ErrorID;
	Block.Status.Motor.rActPosition := AxisBK.Status.ActPosition;
	Block.Status.Motor.rSpeed := AxisBK.Status.ActVelocity;
	Block.Status.Motor.rActPosition := AxisBK.Status.ActPosition;
	
	// Speed paramter for auto movements
	MotorDriveUnit.PulsesSpeedDevice := AxisBK.Status.ActVelocity;
	MotorDriveUnit.Calculation := CALC_SPEED_MM;
	MotorDriveUnit();
	Block.Status.Motor.rSpeed := MotorDriveUnit.SpeedDevice;

	xAnyManualMovement := AxisBK.Status.PLCopenState.ContinuousMotion AND Block.commands.Mode.xManual;
	Block.Status.xAnyManualMovement:=xAnyManualMovement;

END_ACTION
