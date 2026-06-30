
ACTION Outputs: 
	
	IF dataBeltClean.Parameters.Mode.xZero THEN
		dataBeltClean.Outputs := ResetOutputs;
		
	ELSIF dataBeltClean.Parameters.Mode.xManual THEN
		dataBeltClean.Outputs.xRiseCleaningSystem := dataBeltClean.Orders.Manual.xToCleanPosition;
		dataBeltClean.Outputs.xPumpOn := dataBeltClean.Orders.Manual.xRunPump;
		dataBeltClean.Outputs.xAirTurbineOn := dataBeltClean.Orders.Manual.xRunAirTurbine AND dataBeltClean.ParSw.xAirTurbineEnabled;
		
	ELSIF dataBeltClean.Parameters.Mode.xAuto THEN
		dataBeltClean.Outputs.xRiseCleaningSystem := dataBeltClean.Status.State = BCLEAN_CLEANING AND tofCleaningSystemRise.Q;
		dataBeltClean.Outputs.xPumpOn := dataBeltClean.Status.State = BCLEAN_CLEANING AND tonCleanBeltPump.Q;
		dataBeltClean.Outputs.xAirTurbineOn := (dataBeltClean.Status.State = BCLEAN_CLEANING OR dataBeltClean.Status.State = BCLEAN_DRYING) AND dataBeltClean.ParSw.xAirTurbineEnabled;
		
	END_IF
		
	dataBeltClean.Outputs.xAirTurbineVSDReset := dataBeltClean.ParSw.xAirTurbineEnabled AND dataBeltClean.Commands.xReset;
	
END_ACTION
