
ACTION StateCtrl: 
		
	CASE ChillerState OF
		
		CHILLER_OFF:
			IF xRunOrder THEN
				ChillerState := CHILLER_STARTING;
			END_IF
			
		CHILLER_STARTING:
			IF dataChill.In.xPowered THEN
				ChillerState := CHILLER_RUNNING;
			END_IF
			
			IF NOT xRunOrder THEN
				ChillerState := CHILLER_STOPPING;
			END_IF

		CHILLER_RUNNING:
			IF NOT xRunOrder THEN
				ChillerState := CHILLER_STOPPING;
			END_IF

		CHILLER_STOPPING:
			IF TON_DelayChillerStopped.Q THEN
				ChillerState := CHILLER_OFF;
			END_IF
		
			
		CHILLER_FAULT:
			ResetRunCommands;
			IF NOT dataChill.In.xAlarm THEN
				ChillerState := CHILLER_STARTING;
			END_IF
		
	END_CASE
	
	//Timer chiller stopping
	CASE dataChill.Parameters.SystemType OF
		CHILLERSYS_DIRECT:
			TON_DelayChillerStopped.PT:= T#1h;
		CHILLERSYS_WATERMANIFOLD:
			TON_DelayChillerStopped.PT:= T#30s;
		ELSE
			TON_DelayChillerStopped.PT:= T#300s;
	END_CASE
	
	TON_DelayChillerStopped.IN := (ChillerState = CHILLER_STOPPING);
	TON_DelayChillerStopped();
	
	iReasonRunning.0 := ChillerState = CHILLER_RUNNING;
	iReasonRunning.1 := ChillerState = CHILLER_STARTING;
	iReasonRunning.2 := ChillerState = CHILLER_STOPPING;
	tonChillerRunning.IN := iReasonRunning > 0 ;
	tonChillerRunning.PT := T#15s;
	tonChillerRunning();
	
	IF tonChillerRunning.Q AND dataChill.Alarm.xInAlarm THEN
		ChillerState := CHILLER_FAULT;
	END_IF

	// Define the particular RUN signal
	CASE dataChill.Parameters.SystemType OF
		CHILLERSYS_DIRECT:
			xRunOrder := dataChill.Orders.xRun;
		CHILLERSYS_WATERMANIFOLD:
			WaterManifoldCtrl;
			xRunOrder := dataChill.Orders.xRun OR xManifoldRunOrder;
	END_CASE
		
	dataChill.St.xRunning := iReasonRunning > 0;
	dataChill.Out.xStart := dataChill.St.xRunning;
	dataChill.St.Status := ChillerState;

END_ACTION

ACTION WaterManifoldCtrl:
	
	//ON conditions//
	xNeedCold := dataChill.St.WaterManifold.rManifoldTemp > (dataChill.Parameters.rTempSetPoint-LC_OFFSET_TEMP_TO_START_STOP);
	
	tonChillerON.IN:= xNeedCold AND dataChill.Orders.xRun;
	tonChillerON.PT:= t#20s;
	tonChillerON();
	
	
	//OFF conditions//
	xEnoughCold := dataChill.St.WaterManifold.rManifoldTemp < (dataChill.Parameters.rTempSetPoint-LC_OFFSET_TEMP_TO_START_STOP);	
	
	tonChillerOFF.IN:= xEnoughCold OR NOT dataChill.Orders.xRun;
	tonChillerOFF.PT:=t#20s;
	tonChillerOFF();
	
	//Revisar si esto ha funcionado alguna vez, porque la antigua orden de xAnyRunOrder estaba supeditada a la orden de run que viene de machinectrlslow (basicamente cuando cualquier sistema de tintas esta en marcha
	//y en paralelo, a esta de Run que se activa a continuación si es watermanifold, pero es que el rTempSetPoint salta a 100ºC si no hay ninguna barra encendida, así que esto de watermanifold no sirve de nada.
	IF tonChillerON.Q THEN
		xManifoldRunOrder := TRUE;
	ELSIF tonChillerOFF.Q THEN
		xManifoldRunOrder := FALSE;
	END_IF
	
END_ACTION

ACTION ResetRunCommands:
	
	xManifoldRunOrder := FALSE;
	
END_ACTION
