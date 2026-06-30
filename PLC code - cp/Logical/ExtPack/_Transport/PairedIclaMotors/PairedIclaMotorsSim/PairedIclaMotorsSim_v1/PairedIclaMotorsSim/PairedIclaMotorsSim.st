PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	data ACCESS ADR (gPairedMotors[iPairedIclaMotorSimIndex]);

	tonHoming.IN := data.status.iSystemState = HOMING_STEP_1;
	tonHoming.PT := t#1s;
	tonHoming();
	IF tonHoming.Q THEN
		data.Motor[1].Inputs.xMinPositionReached := TRUE;
		data.Motor[2].Inputs.xMinPositionReached := TRUE;
	
	ELSIF data.status.xReferenced THEN
		//Min position sensors
		data.Motor[1].Inputs.xMinPositionReached := (data.Motor[1].rPositionMotor<data.parameters.rMechPositionMin);
		data.Motor[2].Inputs.xMinPositionReached := (data.Motor[2].rPositionMotor<data.parameters.rMechPositionMin);
		
		//Max position sensors
		data.Motor[1].Inputs.xMaxPositionReached := (data.Motor[1].rPositionMotor>data.parameters.rMechPositionMax);
		data.Motor[2].Inputs.xMaxPositionReached := (data.Motor[2].rPositionMotor>data.parameters.rMechPositionMax);
		
		IF data.parameters.xPositionSensorInstalled THEN			
			data.Motor[1].Inputs.iMeasuredPositionFrontSide := data.Motor[1].Inputs.iMeasuredPositionBackSide := REAL_TO_INT((data.Motor[1].rPositionMotor * 16384 / 600) + 16383);
			data.Motor[2].Inputs.iMeasuredPositionFrontSide := data.Motor[2].Inputs.iMeasuredPositionBackSide := REAL_TO_INT((data.Motor[2].rPositionMotor * 16384 / 600) + 16383);
		END_IF
		
	END_IF
	
	iPairedIclaMotorSimIndex := iPairedIclaMotorSimIndex + 1;
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

