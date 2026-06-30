
ACTION startUp:

	IF EDGEPOS(inks.parameters.StartUp.xActive) THEN
		inks._Internal.Startup.rSetPointMeniscus := inks.parameters.parBar.StartUp.rMeniscus;
		//inks._Internal.Startup.rSetPointPositive := inks.parameters.parBar.StartUp.rPositive;
		SetStartUpStarting;
	END_IF
	
	//Exit if not active
	IF NOT inks.parameters.StartUp.xActive THEN
		RETURN;
	END_IF

	// Running each inks system timer
	IF ABS(inks.status.rMeniscus - inks._Internal.Startup.rSetPointMeniscus) <= inks.parameters.parBar.StartUp.rMarginToStable THEN
		xStabMeniscus:= TRUE;
	ELSIF tonNotStabInkStartUp.Q THEN
		xStabMeniscus:= FALSE;
	END_IF
	
	tonStabInkStartUp.IN := xStabMeniscus;
	tonStabInkStartUp.PT := UINT_TO_TIME(inks.parameters.parBar.StartUp.iSecondsStable * 1000);
	tonStabInkStartUp();

	tonUstabInkStartUp.IN := ABS(inks.status.rMeniscus - inks._Internal.Startup.rSetPointMeniscus) > inks.parameters.parBar.StartUp.rMarginToStable;
	tonUstabInkStartUp.PT := t#5m;
	tonUstabInkStartUp();

	tonNotStabInkStartUp.IN := ABS(inks.status.rMeniscus - inks._Internal.Startup.rSetPointMeniscus) > inks.parameters.parBar.StartUp.rMarginToStable;
	tonNotStabInkStartUp.PT := UINT_TO_TIME(inks.parameters.parBar.StartUp.iSecondsUnstable * 1000);
	tonNotStabInkStartUp();
	
	// Calculate the step
	rMeniscusStartUpStep := (inks.parSw.NegPump.rSetPointMeniscus - inks.parameters.parBar.StartUp.rMeniscus) / inks.parameters.parBar.StartUp.iSteps;
	
	// Change setpoints if needed
	IF tonStabInkStartUp.Q THEN
		
		IF ABS(inks.parSw.NegPump.rSetPointMeniscus - inks._Internal.Startup.rSetPointMeniscus) > 0.1 THEN
			// The system still not in final values
			inks._Internal.Startup.rSetPointMeniscus := inks._Internal.Startup.rSetPointMeniscus + rMeniscusStartUpStep;
			tonStabInkStartUp(IN := FALSE); //Resetting the timer
			xStabMeniscus:= FALSE;
		ELSE
			// The system has arrived
			SetStartUpStarted;
			inks.parameters.StartUp.xActive := FALSE;
		END_IF
	END_IF
	
	IF tonUstabInkStartUp.Q THEN
		// If detected a long unstability, change the set point to avoid stopping or dripping and raise the signal to go to error
		inks.parSw.NegPump.rSetPointMeniscus := inks.parSw.NegPump.rSetPointMeniscus - rMeniscusStartUpStep;
		SetStartUpCancelled;
		inks.parameters.StartUp.xActive := FALSE;
	END_IF
	
	// If the system is stopped, mark as cancelled
	IF  NOT inks.status.xInksRunning THEN
		SetStartUpCancelled;
		inks.parameters.StartUp.xActive := FALSE;
	END_IF
	
END_ACTION

ACTION SetStartUpStarting:
	inks.status.AutoStartUp.xStarting := TRUE;
	inks.status.AutoStartUp.xStarted := FALSE;
	inks.status.AutoStartUp.xCancelled := FALSE;
END_ACTION

ACTION SetStartUpStarted:
	inks.status.AutoStartUp.xStarting := FALSE;
	inks.status.AutoStartUp.xStarted := TRUE;
	inks.status.AutoStartUp.xCancelled := FALSE;
END_ACTION

ACTION SetStartUpCancelled:
	inks.status.AutoStartUp.xStarting := FALSE;
	inks.status.AutoStartUp.xStarted := FALSE;
	inks.status.AutoStartUp.xCancelled := TRUE;
END_ACTION
