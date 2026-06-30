
ACTION tempControl: 

		//heating resistor management	
	TON_HeaterStarts.IN := inks.status.iInkState = INKS_STARTING OR inks.status.iInkState = INKS_PRIMING ;
	TON_HeaterStarts.PT := T#20S;
	TON_HeaterStarts();
	
	// (20secs) gc_tiTiempoRetardoActTemp is the delay when InkSystem is starting
	xStartHeating := TON_HeaterStarts.Q OR inks.status.iInkState = INKS_STARTED OR xStateReverseFlow;
	inks.signals.out.xHeatingActive:=xStartHeating;

	//heating resistor tank management
	xStartTankHeating := TON_HeaterStarts.Q OR inks.status.iInkState = INKS_STARTED OR xStateReverseFlow;
	
	
	//Automatic Update ParPID
	parPidTemp:=stPIDParamId(parBar.paramsPidTemp);
	xUpdatePidTemp:= parPidTempCopy <> parPidTemp;
	parPidTempCopy:=parPidTemp;
	IF xUpdatePidTemp THEN 
		stPIDParamToMTPIDParameters(ADR(parBar.paramsPidTemp), ADR(pidParTemp));
		stPIDParamToMTPIDParameters(ADR(parBar.paramsPidTankTemp), ADR(pidParTempTank));
		
		iQuantityUpdatePidTemp:=iQuantityUpdatePidTemp+1;	
	END_IF;	

	//Changing PID for ink heating when is lower than Set Point Temperature
	IF inks.status.Temp.rTemp < rSPtemp - 1.5 THEN
		inks.status.Temp.rPresetValue:= inks.status.Temp.rTemp - ( (rSPtemp - inks.status.Temp.rTemp) * inks.parameters.Temp.rk1Temp);
	
	ELSIF inks.status.Temp.rTemp > rSPtemp - 1.5 AND inks.status.Temp.rTemp < rSPtemp THEN
		inks.status.Temp.rPresetValue:= inks.status.Temp.rTemp - ( (rSPtemp - inks.status.Temp.rTemp) * inks.parameters.Temp.rk2Temp);
		
	ELSIF inks.status.Temp.rTemp > rSPtemp AND inks.status.Temp.rTemp < rSPtemp + 1.5 THEN
		inks.status.Temp.rPresetValue:= inks.status.Temp.rTemp - ( (rSPtemp - inks.status.Temp.rTemp) * inks.parameters.Temp.rk3Temp);
		
	ELSIF inks.status.Temp.rTemp > rSPtemp + 1.5 THEN
		inks.status.Temp.rPresetValue:= inks.status.Temp.rTemp - ( (rSPtemp - inks.status.Temp.rTemp) * inks.parameters.Temp.rk4Temp);
					
	END_IF
	
	
	// PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID
	fb_PID_Temp(Enable:= xStartHeating AND NOT xPidTempTunning,
				PIDParameters:=pidParTemp,
				HoldOut:= inks.status.iDirection = INKSDIR_REVERSE OR inks.Al.xAlrKlixonTriggered,
				MinOut:=0.0,
				MaxOut:=100.0, 
				Update:= xUpdatePidTemp,
				SetValue:=rSPtemp,
				ActValue:=inks.status.Temp.rPresetValue
	);
	inks.status.Temp.rDutyCycleTemp:=fb_PID_Temp.Out;
	inks.status.Temp.xEnabledPid := fb_PID_Temp.Enable;
	
	
	//When DuctyCyleTemp is upper than supported by Psu then is applied ReductionTempPower factor in all bars
	inks.status.Temp.rDutyCycleTempPowerRed:= inks.status.Temp.rDutyCycleTemp * inks.parameters.Temp.rReductionTempPower;

	IF xStartHeating THEN
		rDutyCycleTempAux:=   inks.status.Temp.rDutyCycleTempPowerRed;
	ELSE
		rDutyCycleTempAux:= 0;
	END_IF
	
	IF xPidTempTunning AND xStartHeating THEN
		rDutyCycleTempAux:= rDutyCyclePreTune + fbTempTunning.Out;
	END_IF	
	
	fbTempTunning.Enable := xPidTempTunning;
	fbTempTunning();
	fbTempTunning.ActValue:=inks.status.Temp.rTemp;
	inks.status.Temp.xEnabledTunning := xPidTempTunning;
	
	// Starting the PWM signal in the right moment to avoid all the bars starting at same time
	xStartTempPwm:= timeToStartPWM(iItemNumber:=iBarNumberInBlock, iTotalItems:= inks.parameters.Temp.iBarsWithSamePsu , iTaskCycle:=iPeriode, iMsInCycle:=iMs);
	xEnablePwmTemp:= xStartHeating  AND ( xStartTempPwm OR xEnablePwmTemp) ;
	
	// PWM PWM PWM PWM PWM PWM PWM PWM PWM PWM PWM PWM PWM PWM PWM PWM PWM PWM PWM PWM PWM PWM PWM PWM
	fb_PWM_Temp(Enable:= xEnablePwmTemp,
				Mode:=mtBASICS_PULSE_BEGINNING,
				DutyCycle:=rDutyCycleTempAux,
				Period:=lc_rCyclePwm,
	);
	inks.signals.out.xOutBarResistance:=fb_PWM_Temp.Out;
	inks.status.Temp.xEnabledPwm := xEnablePwmTemp;
	inks.status.Temp.rDutyCyclePwm := rDutyCycleTempAux;
	

	//if I'm not working, the relay exit is off.
	IF	NOT xStartHeating OR fb_PID_Temp.HoldOut THEN
		inks.signals.out.xOutBarResistance:= FALSE;
	END_IF

	/////////////////////////TANK HEATER CONTROL////////////////////////////////////////
	tempTankControl;

END_ACTION



ACTION tempTankControl:
	
	IF NOT inks.parSw.Temp.xTankHeaterEnabled THEN
		inks.status.Temp.xEnabledTankHeater := FALSE;
		inks.signals.out.xOutResistanceTank:=FALSE;
		RETURN;
	END_IF

	IF NOT inks.status.Tank.xMinLevel OR NOT inks.status.xInksRunning OR NOT inks.parSw.Temp.xTankHeaterEnabled OR inks.Al.xAlrHeaterTankPsu OR inks.Al.xAlrHeaterTankReachsMaxTemp THEN
		inks.status.Temp.xEnabledTankHeater := FALSE;
	ELSIF xStartTankHeating THEN
		inks.status.Temp.xEnabledTankHeater := TRUE;
	END_IF	


	// PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID
	fb_PID_Tank_Temp(Enable:= inks.status.Temp.xEnabledTankHeater,
					PIDParameters:=pidParTempTank,
					MinOut:=0.0,
					MaxOut:=100.0, 
					SetValue:=rSPTempTank,
					ActValue:=inks.status.Temp.rTempTank);	
	inks.status.Temp.rDutyCycleTempTank:=fb_PID_Tank_Temp.Out;	
	
	// PWM PWM PWM PWM PWM PWM PWM PWM PWM PWM PWM PWM PWM PWM PWM PWM PWM PWM PWM PWM PWM PWM PWM PWM
	fb_PWM_Temp_Tank(Enable:= fb_PID_Tank_Temp.Enable,
					DutyCycle:=inks.status.Temp.rDutyCycleTempTank, Period:=2.0);
	
	inks.status.xInkAndPreheatingRunning:= fb_PID_Tank_Temp.Enable;
	inks.signals.out.xOutResistanceTank:=fb_PWM_Temp_Tank.Out;
	
	
END_ACTION
