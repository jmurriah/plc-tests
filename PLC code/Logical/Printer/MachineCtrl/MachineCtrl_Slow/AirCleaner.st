
ACTION AirCleaner:

	IF NOT gAirCleaner.Parameters.xInstalled THEN
		gAxisInverter[gAirCleaner.Parameters.iIndex].Orders.PowerOn := FALSE;
		gAxisInverter[gAirCleaner.Parameters.iIndex].Parameters.Velocity := 0;
		gAirCleaner.Alarms := ResetAlarms;
		RETURN;
	ELSE
		gAxisInverter[gAirCleaner.Parameters.iIndex].Orders.PowerOn := NOT gMachine.St.Mode.xZero;
		gAxisInverter[gAirCleaner.Parameters.iIndex].Parameters.Velocity := REAL_TO_UINT(MAX(354.0, (gAirCleaner.ParSw.rDutyCycle * gAirCleaner.Parameters.rMaxSpeed / 100)));	
	
	
		//Manual
		IF gMachine.St.Mode.xManual THEN
			xRunAirCleaner := gAirCleaner.OrdersSw.xRun;
		//Auto
		ELSIF gMachine.St.Mode.xAuto THEN
			xRunAirCleaner := (gAirCleaner.OrdersSw.xRun) AND (gBelt.states.xRuningBelt);
		ELSE
			xRunAirCleaner := FALSE;
		END_IF
		
		//Setting commands with the edge of xRun signal
		gAxisInverter[gAirCleaner.Parameters.iIndex].Commands.MovePositive := EDGEPOS(xRunAirCleaner) AND gAirCleaner.Parameters.Direction = MOTOR_POSITIVE;
		gAxisInverter[gAirCleaner.Parameters.iIndex].Commands.MoveNegative := EDGEPOS(xRunAirCleaner) AND gAirCleaner.Parameters.Direction = MOTOR_NEGATIVE;
	
		
		//Stop
		gAxisInverter[gAirCleaner.Parameters.iIndex].Commands.Stop := EDGENEG(xRunAirCleaner);
		
		
		//Alarms
		IF gAxisInverter[gAirCleaner.Parameters.iIndex].Status.ErrorComms THEN
			gAirCleaner.Alarms.xDriveComms := TRUE;
		END_IF
		
		tonCheckAlarms.IN := gMachine.In.xSafetyEnabled;
		tonCheckAlarms.PT := T#3000ms;
		tonCheckAlarms();	
		
		//Driver Blower Error
		IF tonCheckAlarms.Q AND NOT gAirCleaner.Alarms.xDriveComms THEN 
			IF ((gAxisInverter[gAirCleaner.Parameters.iIndex].Status.ErrorID <> 0) AND (gAxisInverter[gAirCleaner.Parameters.iIndex].Status.ErrorID <> 20625)) OR gAxisInverter[gAirCleaner.Parameters.iIndex].Status.StatusErrorStop THEN
				gAirCleaner.Alarms.xDriveError := TRUE;
			END_IF
	
			IF NOT gAxisInverter[gAirCleaner.Parameters.iIndex].ElecSignals.In.xBreakerOK THEN
				gAirCleaner.Alarms.xInverterPowerFault := TRUE;
			END_IF
		END_IF
		
		//Using Orders.PowerOn because Commands.MovePositive and Commands.MoveNegative are just edges
		tonBlowerNotRunning.IN := xRunAirCleaner AND gAxisInverter[gAirCleaner.Parameters.iIndex].Parameters.Velocity > 300.0 AND ABS(gAxisInverter[gAirCleaner.Parameters.iIndex].Status.ActVelocity) < 300.0;
		tonBlowerNotRunning.PT := T#5s;
		tonBlowerNotRunning();
		IF tonBlowerNotRunning.Q THEN
			gAirCleaner.Alarms.xBlowerNotRunning := TRUE;
		END_IF
	
		//Reset
		IF gMachine.AutoCmd.xReset OR EDGEPOS(gMachine.St.Mode.xZero) THEN
			gAxisInverter[gAirCleaner.Parameters.iIndex].Commands.Reset := TRUE;
			gAirCleaner.Alarms := ResetAlarms;
		END_IF
	END_IF
	
END_ACTION

