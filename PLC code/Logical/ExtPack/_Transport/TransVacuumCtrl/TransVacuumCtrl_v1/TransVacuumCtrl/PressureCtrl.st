
ACTION PressureCtrl: 

	//Send the data from the configuration to the PID structure
	LoadPIDparam(ADR(pidParPressure), ADR(dataVacc.Parameters.parPID));
	
	xEnablePID := StatusCtrl=TRANSVAC_WAITING OR StatusCtrl=TRANSVAC_CONTROLLING; 
	
	//**********************************************************************************
	// PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID 
	//**********************************************************************************
	fbPIDPressure.Enable:=xEnablePID;
	fbPIDPressure.PIDParameters:=pidParPressure;
	fbPIDPressure.MinOut:=0.0;
	fbPIDPressure.MaxOut:= dataVacc.Parameters.rMaxPIDOut;
	fbPIDPressure.Update:= xUpdatePID;
	fbPIDPressure.EnableTracking := StatusCtrl=TRANSVAC_WAITING; //This is the manual mode
	fbPIDPressure.TrackingValue := dataVacc.Parameters.rStartUpDutyCycle; //The StartUp value is defined as Manual
	fbPIDPressure.SetValue:=dataVacc.Parameters.rVacPressureSetPointPerc;
	fbPIDPressure.ActValue:=rVacPressurePerc;
	fbPIDPressure();
	
	//Assignation of the SetPoint of the Blower
	CASE StatusCtrl OF
		
		TRANSVAC_OFF:
			dataVacc.Status.Blower.rDutyCycle:=0.0;
		
		TRANSVAC_WAITING,
		TRANSVAC_CONTROLLING:
			dataVacc.Status.Blower.rDutyCycle:=MAX(dataVacc.Parameters.rMinDutyCycle, fbPIDPressure.Out);
			
		TRANSVAC_MAN:
			dataVacc.Status.Blower.rDutyCycle:=MAX(dataVacc.Parameters.rMinDutyCycle, dataVacc.parSw.rManSetPoint);

	END_CASE
	
	ValveControl;
	
END_ACTION

ACTION ValveControl:

	IF StatusCtrl = TRANSVAC_OFF OR NOT dataVacc.Parameters.Hw.xSystemWithJoints THEN
		//When machine is in 0 all valves should be open --> no vacuum	
		dataVacc.Outputs.VacuumValves := 0;
	ELSE
		//When working, open the valves received from Sw in the command. If a Mask of minimum vaccum is desired, applied here
		dataVacc.Outputs.VacuumValves := NOT (dataVacc.parSw.ValvMask OR dataVacc.Parameters.MinValvMask) ;
	END_IF
	
	//Set the status the same as the physical outputs
	dataVacc.Status.VacuumValves := dataVacc.Outputs.VacuumValves;

END_ACTION
