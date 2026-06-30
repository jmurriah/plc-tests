
ACTION Outputs: 

	data.Signals.Out.xImpression := CurrentState = ARCLGEW_RUNNING AND data.Commands.xMediaInside;

	iReasonToStop.0 := data.Alarms.xJam;
	iReasonToStop.1 := data.Commands.xExternalSafetyStop;
	iReasonToStop.2 := CurrentState = ARCLGEW_RUNNING AND NOT data.Parameters.xBeltRunning;
	data.Signals.Out.xSafetyStop := iReasonToStop=0; //FALSE to Stop
	
	// 100m/min correspond to 10v
	data.Signals.Out.iBeltSpeed:=REAL_TO_INT(data.Parameters.rBeltSpeed * 32766 / 100.0 ); //10V correspond to 32766units
	
END_ACTION
