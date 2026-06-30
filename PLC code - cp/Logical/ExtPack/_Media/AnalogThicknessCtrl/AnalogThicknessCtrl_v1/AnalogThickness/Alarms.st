
ACTION alarms: 

	//////////////////////////
	//ALARMS
	//////////////////////////	
	
	// Alarm: Incoherence Ding detect	
	
	// Alarm: Fault Ding detection signal, it comes from mapping inputs
	data.Alarms.xAlNoDingDetect:=data.In.xDingChannelFault OR NOT data.In.xModuleOK;
	
	
	// Alarm: Ding is not referenced- 
	data.Alarms.xAlDingNotReferenced:= NOT data.State.xDingReferenced;
		
	// Reference issue CRETALEGO-909/911: Alarm: tile thickness read too low after bars is positioned in print.
	data.Alarms.xAlDingIncoherenceValue:= gBelt.states.xRuningBelt AND (data.State.rCurrentHigh < data.Parameters.rMachineMinTicknessMedia) AND EDGEPOS (data.In.xAnyCarriageProductDetect) AND data.In.xDingLow;
	
	// Alarm: No digital Ding Detect		
	T_NoDigDingDetect.IN:= (data.State.rCurrentHigh < data.Parameters.rMachineMinTicknessMedia) AND data.In.xDingLow AND NOT data.In.xDingChannelFault;
	T_NoDigDingDetect.PT:= T#200ms;
	T_NoDigDingDetect();
	
	// TILE THICKNESS READ  IS TOO LOW. CHECK THE SETTINGS OF THE TILE DETECTION LASER.
	IF T_NoDigDingDetect.Q OR data.Alarms.xAlDingIncoherenceValue THEN
		data.Alarms.xAlDingNoDigLaserSensor:= TRUE;
	END_IF

END_ACTION