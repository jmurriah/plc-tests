PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	data ACCESS ADR(gPhotoCells);

	rGaugeHeightTillHole := 10.0;
	
	IF (data.parameters.AlignmentProcess = STP_ALIGNMENT_REQUIRED AND NOT gLine.StatusSummary.xEmptyingBelts) THEN
		//Simulation of the sensors related to the alignement
		IF EDGEPOS(data.status.rPositionMotor > (data.parameters.rSensorMechPositionAlignmentMin - rGaugeHeightTillHole)) THEN
			SetAllSensors;
		ELSIF EDGEPOS(data.status.rPositionMotor > data.parameters.rSensorMechPositionAlignmentMin) THEN
			ResetAllSensors;
		ELSIF EDGEPOS(data.status.rPositionMotor > data.parameters.rSensorMechPositionAlignmentMax) THEN
			SetAllSensors;
		ELSIF EDGEPOS(data.status.rPositionMotor < (data.parameters.rSensorMechPositionAlignmentMin - rGaugeHeightTillHole)) THEN
			ResetAllSensors;
		ELSIF EDGEPOS(ABS(data.status.rPositionMotor-data.status.rSensorPositionAlignment)<0.25) AND data.status.xSensorValidAlignPos THEN
			ResetAllSensors;
		END_IF
		
		IF 	(data.status.rPositionMotor > data.parameters.rSensorMechPositionMax) OR
			(data.status.rPositionMotor < data.parameters.rSensorMechPositionMin) THEN
			ResetAllSensors;
		END_IF
	END_IF
	
	IF EDGEPOS(data.commandsSw.xReference) THEN
		ResetAllSensors;
	END_IF
	
	tonHomingDown.IN := data.status.iSystemState = STP_HOMING_STEP_1;
	tonHomingDown.PT := t#1s;
	tonHomingDown();
	IF tonHomingDown.Q THEN
		data.Inputs.Signals.xPhotoCells[data.parameters.iSensorToReference] := TRUE;
	END_IF

	tonHomingUp.IN := data.status.iSystemState = STP_HOMING_STEP_2;
	tonHomingUp.PT := t#500ms;
	tonHomingUp();
	IF tonHomingUp.Q THEN
		data.Inputs.Signals.xPhotoCells[data.parameters.iSensorToReference] := FALSE;
	END_IF
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

