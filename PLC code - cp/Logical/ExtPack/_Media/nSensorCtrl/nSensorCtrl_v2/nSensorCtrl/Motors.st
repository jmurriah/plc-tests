
ACTION DataToMotors: 

	data.parSw.rMechOffset:=LIMIT(-1,data.parSw.rMechOffset, 1);

	IF data.parameters.MotorType = STP_STEPPER THEN
		StepperGear.Parameter.Direction	:= Stepper.Parameter.Direction; 	(* Step for a StepByStep movement *) (*Take carewith relative movements!!!!*)
	END_IF
		
	rJogSpeedSetPoint:=data.parameters.JogSpeed;
	
	//Drive Unit Data Managment
	MotorDriveUnit.TransmissionData := data.parameters.DriveUnit;
	
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

	CASE data.parameters.MotorType OF
		STP_STEPPER:
			
			//Speed
			Stepper.Parameter.Speed:=MotorDriveUnit.pulsesSpeedDesired;
			StepperGear.Parameter.Speed := Stepper.Parameter.Speed;
			
			//Jog Speed
			Stepper.Parameter.JogSpeed:=MotorDriveUnit.pulsesJogSpeedDesired;
			StepperGear.Parameter.JogSpeed:=Stepper.Parameter.JogSpeed;
			
			//Acceleration
			Stepper.Parameter.Acceleration := MotorDriveUnit.pulsesAccelerationDesired;
			Stepper.Parameter.Deceleration := Stepper.Parameter.Acceleration;
			StepperGear.Parameter.Acceleration := Stepper.Parameter.Acceleration;
			StepperGear.Parameter.Deceleration := Stepper.Parameter.Deceleration;
			
			//Reset
			Stepper.Command.ErrorAcknowledge:= Stepper.Status.ErrorID=31221 OR (Stepper.Status.ErrorID = 29207) OR (Stepper.Status.ErrorID = 29205); // Disturbance in cables?
			StepperGear.Command.ErrorAcknowledge:= StepperGear.Status.ErrorID=31221 OR (Stepper.Status.ErrorID = 29207) OR (Stepper.Status.ErrorID = 29205);
			
			//Enable Permanent Encoder Data
			Stepper.Parameter.Init.xEnabledPermEncData:=TRUE;
			StepperGear.Parameter.Init.xEnabledPermEncData:=TRUE;
			
		STP_ICLA:
		
			//Enable
			Icla.Command.Enable:= Icla.Status.iDriveStatus <> ICLAST_ERROR;
			
			//Speed
			Icla.Parameter.MoveAbsolute.Velocity := REAL_TO_UINT(MotorDriveUnit.pulsesSpeedDesired);
			
			//Jog Speed
			Icla.Parameter.Jog.VeloSlow := REAL_TO_UINT(MotorDriveUnit.pulsesJogSpeedDesired);
			Icla.Command.JogFastSpeed := FALSE;
			
			//Acceleration
			Icla.Parameter.iAcceleration := REAL_TO_UINT(MotorDriveUnit.pulsesAccelerationDesired);
			
			//Reset
			Icla.Command.Reset := 	data.commands.xResetMotor OR 	(data.commands.xErrorRst AND 
																	Icla.Status.IclaStatus <> AXISILE_MOVE_ABSOLUTE AND
																	Icla.Status.IclaStatus <> AXISILE_JOG AND
																	Icla.Status.IclaStatus <> AXISILE_HOMING);

			data.status.Icla.xIsMoving := Icla.Status.iActualVelocity<>0;
		
	END_CASE

END_ACTION


ACTION DataFromMotors: 

	CASE data.parameters.MotorType OF
		STP_STEPPER:
			// All manual movements are done with Jog, Photocells.status.xReferencing is done by Jog, could be it done by trigger?
			xAnyManualMovement:= Stepper.Status.PLCopenState.ContinuousMotion OR StepperGear.Status.PLCopenState.ContinuousMotion;
			
			MotorDriveUnit.pulsesDevice:=Stepper.Status.ActPosition;
			
			//Conversions
			MotorDriveUnit.Calculation:= CALC_POS_MM;
			MotorDriveUnit();
			rPositionMotorMm := MotorDriveUnit.PositionDevice;
	
			data.status.rPositionMotor := rPositionMotorMm;
			
			// Errrors assumed ?
			xAnyErrorStepper:=	(Stepper.Status.ErrorID<>0) OR (StepperGear.Status.ErrorID<>0);
			data.status.xMotorError:= xAnyErrorStepper AND (((Stepper.Status.ErrorID<>31221)AND (Stepper.Status.ErrorID<>29207) AND (Stepper.Status.ErrorID<>29205)) OR // It avoids data.status.xZero
															((StepperGear.Status.ErrorID<>31221)AND (StepperGear.Status.ErrorID<>29207) AND (StepperGear.Status.ErrorID<>29205)));
			data.status.iErrorId:=Stepper.Status.ErrorID;
			xMotorStopped := Stepper.Status.ActVelocity = 0;
			
			IF (Stepper.Status.ErrorID = 29205) OR (StepperGear.Status.ErrorID = 29205) THEN
				data.status.xReferenced := FALSE;
			END_IF

		STP_ICLA:
			xAnyManualMovement:= (Icla.Status.IclaStatus = AXISILE_JOG);
			
			MotorDriveUnit.pulsesDevice := DINT_TO_REAL(Icla.Status.iActualPosition);
			MotorDriveUnit.PulsesSpeedDevice:=Icla.Status.iActualVelocity;

			// Conversions
			MotorDriveUnit.Calculation:= CALC_POS_MM;
			MotorDriveUnit();
			rPositionMotorMm := (-1)*MotorDriveUnit.PositionDevice;
	
			data.status.rPositionMotor := rPositionMotorMm;
			
			// Errors	
			data.status.xMotorError:= Icla.Status.Error.Communication OR Icla.Status.Error.ErrorNumber<>0; // It avoids data.status.xZero
			data.status.Icla.iErrorId:= Icla.Status.Error.ErrorNumber;
			
			data.status.Icla.rCurrentPosition:= Icla.Status.iActualPosition;
			data.status.Icla.rCurrentVel:= Icla.Status.iActualVelocity;
			
			xMotorStopped := Icla.Status.iActualVelocity = 0;

	END_CASE
	
	//Sending upwards the information of the location of the sensors
	data.status.xInPosition := ABS(rPositionMotorMm - rSensorPositionDesired) < 0.10;
	data.status.xAboveSetPoint := rPositionMotorMm >= rSensorPositionDesired + 0.10;
	data.status.xBelowSetPoint := rPositionMotorMm <= rSensorPositionDesired - 0.10;
	
	//To avoid change rBarsPosition value while motor is being positioned to new position setpoint. Issue discovered while changing thickness from 2 to 10mm at 90m/min 
	//Bars were going down executing little steps because "rMaxPosition" was written every scan cycle with a new value coming due to this "rPositionWithOffset"
	IF data.status.xInPosition THEN
		data.status.rPositionWithOffset := rPositionMotorMm - data.parSw.rMechOffset;
	END_IF
		
	MotorDriveUnit.Calculation:= CALC_SPEED_MM;
	MotorDriveUnit();


END_ACTION


