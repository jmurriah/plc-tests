
PROGRAM _CYCLIC
	
	//References of the program
	dataVacc ACCESS ADR (gTransVacuum[iIndexTransVacuum]);
	
	dataVacc.Status.xInstalled := dataVacc.Parameters.xInstalled;

	//Check if there is any blower enabled. If all blowers disabled, consider it as not installed
	xAllBlowerDisabled := TRUE;
	FOR uiIndex := 1 TO dataVacc.Parameters.Hw.uiNumBlowers BY 1 DO
		IF NOT xDisableBlower[uiIndex] THEN
			xAllBlowerDisabled := FALSE;
		END_IF
	END_FOR
	
	IF NOT dataVacc.Status.xInstalled OR xAllBlowerDisabled THEN
		ResetAlarms;
		ResetCommands;
		iIndexTransVacuum:= iIndexTransVacuum +1;
		RETURN;
	END_IF

	//Reset alarms
	IF dataVacc.Commands.xReset THEN
		ResetAlarms;
	END_IF
	
	// Variables Summary
	xProductionOrJamRecovery := dataVacc.Parameters.AutoMode.xProduction OR dataVacc.Parameters.AutoMode.xJamRecovery;
	
	
	//Limit of the configured blowers used. It must be inside the array size
	dataVacc.Parameters.Hw.uiNumBlowers := LIMIT(1, dataVacc.Parameters.Hw.uiNumBlowers, MAX_LAST_MOTOR_BLOWER);
	dataVacc.Parameters.rMaxPIDOut := LIMIT(30, dataVacc.Parameters.rMaxPIDOut, 100); // Limit to 30 to avoid the blowers not starting
	
	// INPUTS
	//PRESURE SENSOR FILTER LOW PASS
	FLP_PresFilterPasLow.CutOffFrequency := 0.2;
	FLP_PresFilterPasLow.Order := 3;
	FLP_PresFilterPasLow.Type := mtFILTER_BESSEL;
	FLP_PresFilterPasLow.Enable := TRUE;
	
	FLP_PresFilterPasLow.In := INT_TO_REAL(dataVacc.Inputs.iPressureRaw);
	FLP_PresFilterPasLow();
	FLP_PresFilterPasLow.Update := FALSE;

	rVacPressure := -1*(FLP_PresFilterPasLow.Out -16384.0)/16384.0*150.0;

	rVacPressurePerc := 100 * ABS(rVacPressure/dataVacc.Parameters.rMaxSystemVacuum);

	StateManager;
	
	PressureCtrl;

	//////////////////////////////////////////////////////////////////
	// BLOWERS BLOWERS BLOWERS BLOWERS BLOWERS BLOWERS BLOWERS BLOWERS
	/////////////////////////////////////////////////////////////////
	xAllBlowersRunning := TRUE;
	xAllBlowersAtSpeed := TRUE;
	FOR uiIndex := 1 TO dataVacc.Parameters.Hw.uiNumBlowers BY 1 DO
		//Reference to the motor of the blower
		Blower ACCESS ADR(gAxisInverter[dataVacc.Parameters.Hw.BlowerData[uiIndex].iIndex]);
		BlowerDirection := dataVacc.Parameters.Hw.BlowerData[uiIndex].Direction;
		ConditionStart_copy := ConditionsStart_copy[uiIndex];
		
		//Show data in Status
		dataVacc.Status.Inverters[uiIndex] := Blower.Status;
		
		//Copy working element to watch it
		BlowersWatch[uiIndex] := Blower;
		BlowerDirectionsWatch[uiIndex] := BlowerDirection;

		//Give the option to disable one of the blowers if it is damaged
		IF NOT xDisableBlower[uiIndex] THEN
			BlowerAlarms;
			BlowerControl;
		END_IF

		//Store the values from Blower Control to use edges
		ConditionsStart_copy[uiIndex] := ConditionStart;
	END_FOR
	
	//Delaying the signal to be sure we have vaccuum in the system when activating the signal
	tonBlowersRunning.IN := xAllBlowersRunning;
	tonBlowersRunning.PT := t#2s;
	tonBlowersRunning();
	dataVacc.Status.Blower.xMoving := tonBlowersRunning.Q;
	
	Alarms; 
	
	//Define the status of the Structure
	dataVacc.Status.State	:= StatusCtrl;
	dataVacc.Status.rVacPressure := rVacPressure;
	dataVacc.Status.rPressurePerc := 100 * ABS(rVacPressure/dataVacc.Parameters.rMaxSystemVacuum);
	dataVacc.Status.xAtSpeed := xAllBlowersAtSpeed; 
	
	//Evacuate ink inside vacuum's table
	tpEvEvacuateInk.IN := EDGEPOS(StatusCtrl=TRANSVAC_OFF);
	tpEvEvacuateInk.PT := T#1h;
	tpEvEvacuateInk();
	dataVacc.Outputs.xActiveEvToEvacuateInk := StatusCtrl=TRANSVAC_OFF; // AND tpEvEvacuateInk.Q; //Mechanical team wants this ev active as long as vacuum is stopped
	
	
	dataVacc.Commands.xReset := FALSE;
	StatusCtrl_copy := StatusCtrl;
	
	iIndexTransVacuum := iIndexTransVacuum + 1;
	
END_PROGRAM
