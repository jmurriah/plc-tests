
PROGRAM _CYCLIC

	//Calculations required previous to execute any action
	Precalculations;
	
	//Inputs to the machine
	MachineInputs;
	
	// ACTIONS
	MachineStates;
	
	// Update status and send more commands
	OrdersPrinter;	
	
	// Reset general alarms	
	IF gMachine.AutoCmd.xReset THEN
		
		//Enable resetting the alarm
		IF gMachine.Al.Alarm.xPDBrokenSensorL1 THEN
			gMachine.Lg.udiPiecesCounterErrorL1 := 0;
		END_IF
		IF gMachine.Al.Alarm.xPDBrokenSensorL2 THEN
			gMachine.Lg.udiPiecesCounterErrorL2 := 0;
		END_IF	

		ResetAlarms;		
	END_IF
		
	Alarms;
	AlarmsSummary;
	
	//Reset Edge commands received from Sw
	gMachine.commandsSw := InputsSwReseted;
	
	gMachine.St.exec.fast := gMachine.St.exec.fast +1;
	
END_PROGRAM


