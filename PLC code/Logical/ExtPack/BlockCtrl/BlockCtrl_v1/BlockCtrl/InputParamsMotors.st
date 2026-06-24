
ACTION InputParamsMotors: 
	
	
	//ICLA   ICLA   ICLA   ICLA   ICLA   ICLA   ICLA   ICLA   ICLA   ICLA   ICLA   ICLA   
	//ICLA   ICLA   ICLA   ICLA   ICLA   ICLA   ICLA   ICLA   ICLA   ICLA   ICLA   ICLA   
	//ICLA   ICLA   ICLA   ICLA   ICLA   ICLA   ICLA   ICLA   ICLA   ICLA   ICLA   ICLA   
	
	// PowerOn Command
	IclaBK.Command.Enable:= IclaBK.Status.iDriveStatus <> ICLAST_ERROR AND NOT Block.Al.xAlrSafetySystemInBlock;
	
	//Just to avoid resetting the Icla when has to move in Automatic mode
	xEnableResetIcla:= Block.Status.PositionState <> BLOCKP_CLEANING;
	
	// It avoids enables in Icla when Icla is in error state	
	IclaBK.Command.Reset:=  NOT Block.Al.xAlrSafetySystemInBlock AND
                            Block.commands.xReset AND
							NOT xIclaMoving AND 
							xEnableResetIcla;  

	// Block sets Icla Speed in Jog movement
	IclaBK.Parameter.Jog.VeloFast:= 500; 
	IclaBK.Parameter.Jog.VeloSlow:= 500;
	
	// Block sets Icla Speed and positino in Abs movement	
	IclaDriveUnit.TransmissionData:=Block.parameters.Icla.DriveUnit;
	IclaDriveUnit.PositionDesired:=rIclaAbsPosDesired;
	IclaDriveUnit.Calculation:=CALC_POS_PULSES;
	IclaDriveUnit();
	IclaBK.Parameter.MoveAbsolute.Position:= REAL_TO_DINT(IclaDriveUnit.pulsesPositionDesired);

	//Just send the information when change
	IF EDGEPOS(xIclaAbsMovOrder) OR EDGENEG(xIclaAbsMovOrder) THEN 
		IclaBK.Command.MoveAbsolute:= xIclaAbsMovOrder;
	END_IF
	IF EDGEPOS(xIclaAbsMovOrder) THEN 
		LogIclaMovementOrder;
	END_IF
	
	IclaDriveUnit.pulsesDevice:=DINT_TO_REAL(IclaBK.Status.iActualPosition);
	IclaDriveUnit.Calculation:=CALC_POS_MM;
	IclaDriveUnit();
	Block.Status.Icla.rCurrentPosition:=IclaDriveUnit.PositionDevice;
	rIclaCurrentPos:=IclaDriveUnit.PositionDevice;
	
	// To Sw: 
	xIclaMoving:=ABS(IclaBK.Status.iActualVelocity)>50;
	xIclaAbsMovDone:=EDGEPOS(IclaBK.Status.xInPosition);
	IF xIclaAbsMovDone THEN
		LogIclaInPosition;
	END_IF
	
	Block.Status.Icla.iSpeed := IclaBK.Status.iActualVelocity;
	Block.Status.Icla.xIsMoving:=IclaBK.Status.iActualVelocity<>0;

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
	MotorDriveUnit.AccelerationDesired := Block.parameters.Motor.rAcceleration;
	MotorDriveUnit.Calculation := CALC_ACC_PULSES;
	MotorDriveUnit();
	AxisBK.Parameter.Acceleration := MotorDriveUnit.pulsesAccelerationDesired;
	
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
	
	// Speed parameter for auto movements
	MotorDriveUnit.SpeedDesired := Block.parameters.Motor.rDriveAutoSpeed;
	MotorDriveUnit.Calculation := CALC_SPEED_PULSES;
	MotorDriveUnit();
	AxisBK.Parameter.Speed := MotorDriveUnit.pulsesSpeedDesired;

	// Homing: Reference Position
	MotorDriveUnit.HomePositionDesired := Block.parameters.Motor.rReferencePosition;
	MotorDriveUnit.Calculation := CALC_HOMEPOS_PULSES;
	MotorDriveUnit();
	AxisBK.Parameter.HomePosition := MotorDriveUnit.pulsesHomePositionDesired ; // Transfer in parameter structure 
	
	// Detected incoherency with Halt and MoveAbsolute order
	IF AxisBK.Command.Move.Halt THEN
		IF xMotorAbsMovOrder THEN
			xMotorAbsMovOrder:=FALSE;
			LogMotorOrderIncoherencyHaltAndMoveAbsolute;
		END_IF
	//Removed the edgepos. It is possible because Block is executed more than x2 lower than axis		
	ELSIF xMotorAbsMovOrder AND AxisBK.Status.HomeOK THEN 
		AxisBK.Command.Move.Absolute:= TRUE;
		xMotorAbsMovOrder := FALSE;

		// Move absolute counter	
		Block.Lg.diMoveAbsCounter:= Block.Lg.diMoveAbsCounter+1;	
		//xLoggingVerMovingOrder := VerMotorOrderEventLog.Status<>ELOG_STATUS_QUEUED OR VerMotorOrderEventLog.Status<>ELOG_STATUS_LOGGING;
		//IF NOT xLoggingVerMovingOrder THEN
		//	LogVertMovementOrder;
		//END_IF
	END_IF

	IF EDGEPOS(AxisBK.Command.Move.Absolute) THEN
		LogVertMovementOrder;
	END_IF
	
	// Home order
	AxisBK.Command.Home:= EDGEPOS(xMotorHomeOrder);	

	AxisBK.Command.Reset:= ((AxisBK.Status.ErrorID<>0) OR AxisBK.Status.PLCopenState.ErrorStop) AND Block.commands.xReset;
	AxisBK.Command.ErrorAcknowledge:= ((AxisBK.Status.ErrorID<>0) AND Block.commands.xReset) OR
										(AxisBK.Status.ErrorID=6023) OR 
										(AxisBK.Status.ErrorID=29216) OR 
										(AxisBK.Status.ErrorID=5001) OR 
										(AxisBK.Status.ErrorID=29207) ;
	

	
END_ACTION
