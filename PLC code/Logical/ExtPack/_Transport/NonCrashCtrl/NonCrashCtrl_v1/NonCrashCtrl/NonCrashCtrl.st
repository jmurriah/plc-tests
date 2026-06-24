
PROGRAM _CYCLIC
	
	//References of the program
	dataNC ACCESS ADR (gNonCrash[iIndexNonCrash]);
	
	dataNC.Status.xInstalled := dataNC.Parameters.xInstalled;
	
	//Just defined as not installed when the NonCrash is stopped
	IF dataNC.Status.xInstalled THEN
		//Managing when not enabled the start or the error status. Not exiting while moving
		IF dataNC.parSw.xEnable THEN
			dataNC.Status.xEnabled := TRUE;
		ELSIF NOT dataNC.parSw.xEnable AND (StatusCtrl=NONCRASH_NOT_INITIALIZED OR StatusCtrl=NONCRASH_ERROR) THEN
			dataNC.Status.xEnabled := FALSE;
		END_IF
	END_IF
	
	IF NOT dataNC.Status.xInstalled OR NOT dataNC.Status.xEnabled THEN
		ResetAlarms;
		iIndexNonCrash:= iIndexNonCrash +1;
		RETURN;
	END_IF
	
	//Reference to the motor of the blower
	AxisMotor ACCESS ADR(gAxis[dataNC.Parameters.iIndexMotor]);
	
	//Limits of the movement data
	
	// Initial values in S1400
	//gNonCrash[1].Parameters.DriveUnit.LinealPerimeter.GearBox:=30;
	//gNonCrash[1].Parameters.DriveUnit.LinealPerimeter.Perimeter:=500;
	
	dataNC.Parameters.DriveUnit.LinealPerimeter.GearBox := MAX(dataNC.parSw.rGearBox, 0.001);
	dataNC.Parameters.DriveUnit.LinealPerimeter.Perimeter := MAX(dataNC.parSw.rPerimeter, 100);
	
	dataNC.parSw.rSpeedOffset := LIMIT(-1.0, dataNC.parSw.rSpeedOffset, 1.0);
	
	StateManager;
	
	Alarms;
	
	xRunningState := StatusCtrl=NONCRASH_RUNNING OR StatusCtrl=NONCRASH_RUN_ORDER;
	
	IF dataNC.Parameters.MotorDirection = MOTOR_NEGATIVE THEN
		AxisMotor.Parameter.Direction := MOTOR_NEGATIVE_AXIS;
	ELSE
		AxisMotor.Parameter.Direction := MOTOR_POSITIVE_AXIS;
	END_IF
	
	//Drive unit Managment
	DriveUnitManager.TransmissionData := dataNC.Parameters.DriveUnit;
	
	// Define the Status of the Motor with the Status of the Axis
	DriveUnitManager.PulsesSpeedDevice := AxisMotor.Status.ActVelocity;
	DriveUnitManager.Calculation := CALC_SPEED_MMIN;
	DriveUnitManager();
	dataNC.Status.Motor.rCurrentSpeed	:= ABS(DriveUnitManager.SpeedMminDevice);
	dataNC.Status.Motor.rCurrentSpeedUnits := ABS(AxisMotor.Status.ActVelocity);
	
	DriveUnitManager.AccelerationDesired := dataNC.Parameters.rAcceleration;
	DriveUnitManager.Calculation := CALC_ACC_PULSES;
	DriveUnitManager();
	AxisMotor.Parameter.Acceleration := MIN(DriveUnitManager.pulsesAccelerationDesired, AxisMotor.Status.MaxAccelerationNeg, AxisMotor.Status.MaxAccelerationPos);

	DriveUnitManager.DecelerationDesired := dataNC.Parameters.rDeceleration;
	DriveUnitManager.Calculation := CALC_DEC_PULSES;
	DriveUnitManager();
	AxisMotor.Parameter.Deceleration := MIN(DriveUnitManager.pulsesDecelerationDesired, AxisMotor.Status.MaxDecelerationNeg, AxisMotor.Status.MaxDecelerationPos);	
	
	// Set velocity. Calculate speed in pulses with DriveUnit
	DriveUnitManager.SpeedMminDesired := MAX(dataNC.Parameters.rSpeedSetPoint + dataNC.parSw.rSpeedOffset,0.5); 	//It avoids a 0 speed and do not see a Continuous Movement state
	DriveUnitManager.Calculation := CALC_SPEED_MMIN_PULSES;
	DriveUnitManager();	
	
	// Sending axis motion orders
	AxisMotor.Command.Move.Halt     := AxisMotor.Status.PLCopenState.ContinuousMotion AND NOT xRunningState;
	AxisMotor.Command.Move.Velocity := EDGEPOS(xRunningState) OR AxisMotor.Parameter.Speed <> DriveUnitManager.pulsesSpeedDesired; // JMH: It is important the order of these two lines
	AxisMotor.Parameter.Speed       := DriveUnitManager.pulsesSpeedDesired; // JMH: It is important the order of these two lines	
	
	//Define the outputs of the Structure
	dataNC.Status.State := StatusCtrl;

	dataNC.Status.Motor.xRunning := AxisMotor.Status.PLCopenState.ContinuousMotion;
	dataNC.Status.Motor.rTorque := AxisMotor.Status.ActTorque;
	dataNC.Status.Motor.ErrorId := AxisMotor.Status.ErrorID;
	
	iIndexNonCrash := iIndexNonCrash + 1;
	
END_PROGRAM
