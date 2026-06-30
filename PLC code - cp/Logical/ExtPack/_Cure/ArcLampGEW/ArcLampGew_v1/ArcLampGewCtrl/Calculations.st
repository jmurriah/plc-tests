
ACTION Calculations: 

	FOR iLamp:=1 TO data.Parameters.iLampQuantity DO
		data.Status.Lamps[iLamp].xDrying := data.Status.Lamps[iLamp].LampPowerPercent > 3;
	END_FOR;
	
	data.Status.xDrying := data.Status.xAnyLampSelected AND data.State = ARCLGEW_RUNNING;
END_ACTION
