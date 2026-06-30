
ACTION Calculations: 
	
	//Avoid access out of the array
	data.Parameters.iTotalModules := MIN(data.Parameters.iTotalModules, MAX_LAST_NIR_MODULES);
	data.Parameters.DDC.iLampsExtend := MIN(data.Parameters.DDC.iLampsExtend, 3); //Limit to 3 as make no sense allow higher values
	
	data.Status.Comms.xBeltRunning := data.Status.Comms.Speed > 1;
	
	//Calculation of Modules data
	FOR iIndexModule := 1 TO data.Parameters.iTotalModules DO
		data.Status.rSurfaceTempModule[iIndexModule] := INT_TO_REAL(data.Signals.In.iSurfaceTempModuleRaw[iIndexModule])/10.0;
		data.Status.Comms.Modules[iIndexModule].xPowered := data.Status.Comms.Modules[iIndexModule].Power > 1;
		data.Status.Comms.Modules[iIndexModule].NirStatus := ModuleStatus(data.Status.Comms.Modules[iIndexModule].iNirStatus);
		
		//Limitation of wrong data in parameters
		data.Parameters.Comms.Modules[iIndexModule].Adjust := LIMIT(-100, data.Parameters.Comms.Modules[iIndexModule].Adjust, 100);
	END_FOR;

	data.Status.xDrying := data.State = NIRADPEW_RUNNING;
	
	// -40C to +60C Probe. 100C Range
	data.Status.rInletTemperature := ((INT_TO_REAL(data.Signals.In.iInletTempRaw)* 100.0)/32767.0)-40.0;
	data.Status.rInletHumidity := ((INT_TO_REAL(data.Signals.In.iInletHumidityRaw)* 100.0)/32767.0)-0.0;
	
	
	//Limitations of values to remain consistent
	data.Parameters.Comms.Pstart := MAX(data.Parameters.Comms.Pstart, 0);
	data.Parameters.Comms.Pend := MIN(data.Parameters.Comms.Pend, 100);
	
	data.Parameters.Comms.Pstart := MIN(data.Parameters.Comms.Pend,data.Parameters.Comms.Pstart);
	data.Parameters.Comms.Pend := MAX(data.Parameters.Comms.Pend,data.Parameters.Comms.Pstart);
	data.Parameters.Comms.Vstart := MIN(data.Parameters.Comms.Vend,data.Parameters.Comms.Vstart);
	data.Parameters.Comms.Vend := MAX(data.Parameters.Comms.Vend,data.Parameters.Comms.Vstart);
	
	IF data.Parameters.rBeltSpeed > data.Parameters.Comms.Vstart THEN
		data.Status.rPowerSetPoint := data.Parameters.Comms.Pstart +
								(data.Parameters.rBeltSpeed-data.Parameters.Comms.Vstart) * 
								(data.Parameters.Comms.Pend-data.Parameters.Comms.Pstart) /
								(data.Parameters.Comms.Vend-data.Parameters.Comms.Vstart);
		
		IF data.Parameters.xLineEmptyingBelt THEN
			data.Status.rPowerSetPoint := data.Status.rPowerSetPoint * 0.5;
		END_IF
	ELSE
		data.Status.rPowerSetPoint := 0;
	END_IF
		
END_ACTION
