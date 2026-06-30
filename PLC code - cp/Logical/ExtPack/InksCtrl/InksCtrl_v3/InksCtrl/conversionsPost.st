
ACTION conversionsPost: 

	IF  inks.status.xInksRunning THEN
		
		//Negative Pump
		IF inks.status.NegPump.rDutyCycleNegative=0.0 THEN
			inks.signals.out.iDutyCycleNegative:=0;
		ELSE
			rVoltageNegPump:= (inks.status.NegPump.rDutyCycleNegative * rSlopePumpNeg) + rLowPumpLimitNeg;
			inks.signals.out.iDutyCycleNegative:=REAL_TO_INT(rVoltageNegPump * 32766 / 10); //10V correspond to 32766
		END_IF;
		
		//Positive Pump
		IF inks.status.PosPump.rDutyCycleFilling=0.0 THEN 
			inks.signals.out.iDutyCycleFilling:=0;
		ELSE
			rVoltagePosPump:= (inks.status.PosPump.rDutyCycleFilling * rSlopePumpPos) + rLowPumpLimitPos;
			inks.signals.out.iDutyCycleFilling:=REAL_TO_INT(rVoltagePosPump * 32766 / 10); //10V correspond to 32766
		END_IF;

	ELSE
		inks.signals.out.iDutyCycleNegative:=0;
		inks.signals.out.iDutyCycleFilling:=0;
	
	END_IF;

	///vars to show in GUI
	inks.status.Tank.iDipositLevel:=REAL_TO_INT(rTankLevelPercent); 
	inks.status.tiDriptime:=inks.parSw.tiDripTime;
	inks.status.PosPump.rSetPointPos:=rSP_PressurePos_PID;
	
	// Duty cycle Heater Tank in Percentage
	inks.status.Temp.rDutyCycleTempPowerRedTank:= inks.status.Temp.rDutyCycleTempTank;   //TOREVIEW: It doesn't seems to be OK (JMH)
	
END_ACTION
