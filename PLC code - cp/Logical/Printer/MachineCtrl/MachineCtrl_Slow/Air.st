
ACTION Air: 

	////////////////////////////////////////////////////////////////////////////////////
	// ZERO MODE
	////////////////////////////////////////////////////////////////////////////////////
	TNotZero.IN:=NOT gMachine.St.Mode.xZero;
	TNotZero.PT:=T#500ms;
	TNotZero();
	gMachine.Out.xAirSupply:= TNotZero.Q AND (NOT gMachine.AlSummary.xAlrSafetyCutAir OR gSafetyController.Inputs.xPrinterMaintenanceKey);
	
END_ACTION
