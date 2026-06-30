
ACTION StateNitrogen: 

	CASE NitroState OF
		
		CURINGNITRO_OFF:
			IF StatusCtrl <> CURINGLED_OFF THEN
				NitroState := CURINGNITRO_INIT;
			END_IF
			
		CURINGNITRO_INIT:
			IF dataLed.Signals.Outputs.xPowerOnNitrogen THEN
				NitroState := CURINGNITRO_READY;
			END_IF
		
		CURINGNITRO_FAULT:
			IF NOT dataLed.Alarms.xN2LowFlow THEN
				NitroState := CURINGNITRO_READY;
			END_IF

		CURINGNITRO_READY:
			//[RGP] Line status considered due to issue NOZOMI-16649. Nitrogen low flow alarm will execute a controlled stop, but curing wont stop till line has stopped
			IF dataLed.Alarms.xN2LowFlow AND NOT dataLed.Commands.xRunNitrogenFlow THEN
				NitroState := CURINGNITRO_FAULT;
			END_IF
		
	END_CASE
	
	
	IF StatusCtrl = CURINGLED_OFF  THEN
		NitroState := CURINGNITRO_OFF;
	END_IF
	
	dataLed.Status.NitroState:=NitroState;
	
END_ACTION
