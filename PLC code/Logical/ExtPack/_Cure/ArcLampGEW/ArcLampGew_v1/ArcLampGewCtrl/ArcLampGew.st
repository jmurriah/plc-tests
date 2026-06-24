
PROGRAM _INIT

	IF gDryer.St.HwData.Family = FAMILY_BRAUTOMATIONRUNTIME THEN
		Host := '127.0.0.1';
	ELSE
		Host := '192.168.125.39';
	END_IF

	data ACCESS ADR(gArcLampGew);
	InitialiceCommsObjects;
	
END_PROGRAM

PROGRAM _CYCLIC
	
	data ACCESS ADR(gArcLampGew);
	
	//If ArcLamp is not installed, avoid entering in the code
	IF NOT data.Parameters.xInstalled THEN
		data.Status := resetedStatus;
		data.Signals.Out := resetedOuts;
		data.Alarms := resetedAlarms;
		data.AlSummary := resetedAlarmsSummary;		
		RETURN;
	END_IF
	data.Status.xInstalled := TRUE; //It is reseted if it is not installed
	
	//////////////////////////
	////// RESET ALARMS //////
	IF data.Commands.xReset THEN
		
		//Send reset to reset alarms by comms if any alarm in selected lamp
		xResetNeeded.0 := data.Status.Lamps[1].InAlarm AND data.Parameters.Lamps[1].Enable;
		xResetNeeded.1 := data.Status.Lamps[2].InAlarm AND data.Parameters.Lamps[2].Enable;
		IF xResetNeeded > 0 THEN
			data.Commands.InternalComms.xResetAll := TRUE;
		END_IF
		
		data.Alarms := resetedAlarms;
		data.AlSummary := resetedAlarmsSummary;
		
	END_IF
	
	IF data.State = ARCLGEW_NOT_INITIALIZED OR data.State = ARCLGEW_IDLE THEN
		data.Status.xEnabledArcLamp := data.Parameters.xEnableArcLamp;
	END_IF
	State;
	
	Comms;
		
	Alarms;

	AlarmsSummary;
	
	Calculations;
	
	Outputs;
	
END_PROGRAM

PROGRAM _EXIT
	// Release Client instances
	Client(enable := 0, send := 0);
	ClientPost(enable := 0, send := 0);
END_PROGRAM

