
ACTION BlockParameters:
	
	// Print motor offset
	Block.parSw.rOffsetPrintMotor		:= MAX(Block.parSw.rOffsetPrintMotor,GC_MIN_OFFSET_BLOCK);

	//Assign the direction of the vertical motor
	IF Block.parameters.Motor.VerticalDirection=MOTOR_NEGATIVE THEN
		AxisBK.Parameter.Direction:=MOTOR_NEGATIVE_AXIS;
	ELSE
		AxisBK.Parameter.Direction:=MOTOR_POSITIVE_AXIS;
	END_IF

END_ACTION
