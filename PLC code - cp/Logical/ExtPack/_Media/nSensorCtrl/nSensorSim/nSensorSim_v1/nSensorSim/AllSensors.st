
ACTION SetAllSensors: 
	FOR iIndexSensor:=1 TO data.parameters.iSensorQuantity DO
		data.Inputs.Signals.xPhotoCells[iIndexSensor] := TRUE;
	END_FOR
END_ACTION

ACTION ResetAllSensors: 
	FOR iIndexSensor:=1 TO data.parameters.iSensorQuantity DO
		data.Inputs.Signals.xPhotoCells[iIndexSensor] := FALSE;
	END_FOR
END_ACTION
