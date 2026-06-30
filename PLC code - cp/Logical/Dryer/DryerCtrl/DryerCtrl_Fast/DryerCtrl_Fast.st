PROGRAM _INIT
	//Avoid starting without an AutoLocation defined
	AutoLocationPrevious := MACHLOC_LOCAL;
END_PROGRAM

PROGRAM _CYCLIC

	//Inputs to the machine
	MachineInputs;

	// Reset general alarms	
	IF gDryer.AutoCmd.xReset THEN
		
		//Enable resetting the alarm
		IF gDryer.Al.Alarm.xPDBrokenSensorL1 THEN
			gDryer.Lg.udiPiecesCounterErrorL1 := 0;
		END_IF
		IF gDryer.Al.Alarm.xPDBrokenSensorL2 THEN
			gDryer.Lg.udiPiecesCounterErrorL2 := 0;
		END_IF	

		ResetAlarms;		
	END_IF
		
	Alarms;
	AlarmsSummary;
	
	// ACTIONS
	MachineStates;
	
	DryerState;
	
	IF gDryer.St.AutoLocation.xLocal OR gDryer.St.AutoLocation.xLocalORManual THEN
		AutoLocal;
	END_IF
	
	// Update status and send more commands
	OrdersPrinter;	
	
	//Reset Edge commands received from Sw
	gDryer.In.Sw := InputsSwReseted;

	gDryer.St.exec.fast := gDryer.St.exec.fast +1;
	
END_PROGRAM


