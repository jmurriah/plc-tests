
ACTION StateManager: 
	
	xAnyErrorReason.0 := dataChiller.St.Status = CHILLER_FAULT;
	xAnyErrorReason.1 := NitroState = CURINGNITRO_FAULT;
	xAnyErrorReason.2 := errorLampsSLM > 0;
	xAnyErrorReason.3 := errorLampsThermal > 0;
	xAnyError := xAnyErrorReason > 0;

	
	CASE StatusCtrl OF
		
		CURINGLED_OFF:
			IF dataLed.Commands.PowerOn THEN
				StatusCtrl := CURINGLED_INIT;
			END_IF
			
		CURINGLED_INIT:
			IF dataChiller.St.xRunning AND NitroState = CURINGNITRO_READY THEN
				StatusCtrl := CURINGLED_PREPARING;
			END_IF
			
		CURINGLED_PREPARING:
			IF (dataLed.Status.xCureByStretch AND dataLed.Status.xLampsConfigured) OR NOT dataLed.Status.xCureByStretch THEN
				StatusCtrl := CURINGLED_READY;
			END_IF
			
		CURINGLED_READY:
			IF dataLed.Commands.RunCuring AND dataLed.Parameters.xEnabled THEN
				StatusCtrl := CURINGLED_EMITTING;
			END_IF
			
		CURINGLED_EMITTING:
			IF NOT dataLed.Commands.RunCuring OR NOT dataLed.Parameters.xEnabled THEN
				StatusCtrl := CURINGLED_READY;
			END_IF
			
		CURINGLED_FAULTED:
			IF NOT xAnyError THEN
				StatusCtrl := CURINGLED_INIT;
			END_IF
		
	END_CASE
	
	//The enabled lamps with any fault, send the System to fault
	IF xAnyError THEN
		StatusCtrl := CURINGLED_FAULTED;
	END_IF
	
	IF NOT dataLed.Commands.PowerOn THEN
		StatusCtrl := CURINGLED_OFF;
	END_IF
	
	dataLed.Status.State:=StatusCtrl;
	
	//Visu purpose
	dataLed.Status.xEmitting := StatusCtrl = CURINGLED_EMITTING;
	
END_ACTION
