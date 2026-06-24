PROGRAM _INIT
	data ACCESS ADR(gNirAdphos);
	//Activate this signal because it not exist physically
	data.Signals.In.xSafetyOK := TRUE;
	
	InitialDataForMediaNir1;
	//PreparingMethodCommsNir1;
	data.Parameters.DDC.pIntensityNir1 := 0;
	data.Parameters.DDC.pIntensityNir2 := 0;
	
END_PROGRAM

PROGRAM _CYCLIC
	
	data ACCESS ADR(gNirAdphos);

	Calculations;
	
	//Consider the parametrization to use NIR or not when ready
	IF (data.State = NIRADPEW_NOT_INITIALIZED OR data.State = NIRADPEW_IDLE) THEN
		data.Status.xEnabledNir := data.Parameters.xEnableNir AND data.Status.xAnyModuleEnabled;
		data.Status.xEnabledDDC := data.Parameters.DDC.xEnableDDC AND data.Status.xAnyModuleEnabled;		
	END_IF
	
	State;
	
	Alarms;
	
	AlarmsSummary;
	
	Outputs;
	
	CommsNir1;
	CommsNir2;

END_PROGRAM
