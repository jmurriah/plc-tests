
(* Load Default configuration for Servodrives *)
FUNCTION LoadDefaultServoConfig
	
	axisServo.Parameter.Coms.ReadRatedTorque := TRUE;
	axisServo.Parameter.Coms.ReadMaxTorque := TRUE;
	
	LoadDefaultServoConfig := TRUE;
	
END_FUNCTION

(* Load Default configuration for Steppers *)
FUNCTION LoadDefaultStepperConfig
	
	axisStepper.Parameter.Init.xSendTorqueParams:=FALSE;
	axisStepper.Parameter.Coms.DisableReadingCurrent:=TRUE;
	axisStepper.Parameter.Coms.DisableReadingLagError:=TRUE;
	axisStepper.Parameter.Coms.DisableReadingTorque:=TRUE;
	axisStepper.Parameter.Coms.DisableReadingTemp:=TRUE;
	axisStepper.Parameter.Coms.ReadRatedTorque := FALSE;
	axisStepper.Parameter.Coms.ReadMaxTorque := FALSE;

	LoadDefaultStepperConfig := TRUE;
	
END_FUNCTION
