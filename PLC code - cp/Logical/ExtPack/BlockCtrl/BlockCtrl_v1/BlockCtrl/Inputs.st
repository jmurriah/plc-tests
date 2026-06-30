
ACTION Inputs: 

	IF NOT Block.parameters.Hw.xThereIsInTraySensor THEN
		TON_TrayInSensor.IN:= NOT Block.In.xTrayOut;
		TON_TrayInSensor.PT:= Block.parameters.tiTimeWaitTrayIn;
		TON_TrayInSensor();
		Block.In.xTrayIn := TON_TrayInSensor.Q;
	END_IF
	
	//Block's temperature and humidity
	Block.Status.iTemperature :=  REAL_TO_INT((Block.In.iTemperatureRaw/327.67)-40);
	Block.Status.iHumidity :=  REAL_TO_INT(Block.In.iHumidityRaw/327.67);
	
END_ACTION
