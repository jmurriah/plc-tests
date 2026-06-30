
ACTION BlockParameters:
	

	//Cleaning offset limits.(antes en securities)
	Block.parSw.rOffsetCleanMtrAdjust	:= LIMIT(Block.parameters.Motor.rMinCleanOffsetTech, Block.parSw.rOffsetCleanMtrAdjust, Block.parameters.Motor.rMaxCleanOffsetTech);
	Block.parSw.rOffsetCleanMtrOperatr := LIMIT(-1, Block.parSw.rOffsetCleanMtrOperatr, 1);

	// Clean offset 
	rOffseCleanMtr:=Block.parSw.rOffsetCleanMtrAdjust+Block.parSw.rOffsetCleanMtrOperatr;

	//Minimum position of the Motor to allow moving the Icla in Manual mode
	rSafeBarPosToCarrier := Block.parameters.Motor.rSafePositionCleanCarrier; //Block.parameters.Motor.rCleanPosition + rOffseCleanMtr;
	
	// rWaterSpurtPosition always has to be higher than rCleanPosition
	IF Block.parameters.Motor.rWaterSpurtPosition <= Block.parameters.Motor.rCleanPosition + 0.5 THEN
		Block.parameters.Motor.rWaterSpurtPosition := Block.parameters.Motor.rCleanPosition + 0.5;
	END_IF
	
	// Print motor offset
	IF NOT Block.parameters.xMotorOffsetAllowed THEN 
		Block.parSw.rOffsetPrintMotor := 0;
	ELSE
		Block.parSw.rOffsetPrintMotor := MAX(Block.parSw.rOffsetPrintMotor,GC_MIN_OFFSET_BLOCK);
	END_IF

	// Clean motor speed limits
	Block.parameters.Icla.iCleanMotorSpeedFwd:= LIMIT(Block.parameters.Icla.iMinSpeedCleanMotorFwd,
														Block.parameters.Icla.iCleanMotorSpeedFwd,
														Block.parameters.Icla.iMaxSpeedCleanMotorFwd);

	Block.parameters.Icla.iCleanMotorSpeedBwd:= LIMIT(Block.parameters.Icla.iMinSpeedCleanMotorBwd,
														Block.parameters.Icla.iCleanMotorSpeedBwd,
														Block.parameters.Icla.iMaxSpeedCleanMotorBwd);	
	
	//Assign the direction of the vertical motor
	IF Block.parameters.Motor.VerticalDirection=MOTOR_NEGATIVE THEN
		AxisBK.Parameter.Direction:=MOTOR_NEGATIVE_AXIS;
	ELSE
		AxisBK.Parameter.Direction:=MOTOR_POSITIVE_AXIS;
	END_IF
	
	Block.parameters.Inks.iMaxMachinePrintBars := MIN(Block.parameters.Inks.iMaxMachinePrintBars, MAX_LAST_INK);
	
END_ACTION
