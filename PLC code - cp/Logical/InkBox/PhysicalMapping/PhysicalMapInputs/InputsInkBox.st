
ACTION InputsInkBox:
	
	// GROUP _10x
	gInks[1].signals.in.xPrintHeadsPsuOK := NOT X20DIF371_101.DInput[1];
	gInks[1].signals.in.xKlixonTriggered := X20DIF371_101.DInput[3];
	gInks[1].signals.in.xOverpressure := NOT X20DIF371_101.DInput[5];
	gInks[1].signals.in.xMaxLevel := X20DIF371_101.DInput[7];
	gInks[1].signals.in.xMinLevel := X20DIF371_101.DInput[9];
	
	gInks[2].signals.in.xPrintHeadsPsuOK := NOT X20DIF371_101.DInput[2];
	gInks[2].signals.in.xKlixonTriggered := X20DIF371_101.DInput[4];
	gInks[2].signals.in.xOverpressure := NOT X20DIF371_101.DInput[6];
	gInks[2].signals.in.xMaxLevel := X20DIF371_101.DInput[8];
	gInks[2].signals.in.xMinLevel := X20DIF371_101.DInput[10];
	
	
	gInks[1].signals.in.iVacuum1Raw := X20AI4322_102.AInput[1];
	gInks[1].signals.in.xVacuum1SensorError := StatusAnalogInputBroken( X20AI4322_102.ModuleOk, X20AI4322_102.Status01, X20AI4322_102.Status02, 1);
	gInks[1].signals.in.iVacuum2Raw := X20AI4322_102.AInput[3];
	gInks[1].signals.in.xVacuum2SensorError := StatusAnalogInputBroken( X20AI4322_102.ModuleOk, X20AI4322_102.Status01, X20AI4322_102.Status02, 3);

	gInks[2].signals.in.iVacuum1Raw := X20AI4322_102.AInput[2];
	gInks[2].signals.in.xVacuum1SensorError := StatusAnalogInputBroken( X20AI4322_102.ModuleOk, X20AI4322_102.Status01, X20AI4322_102.Status02, 2);
	gInks[2].signals.in.iVacuum2Raw := X20AI4322_102.AInput[4];
	gInks[2].signals.in.xVacuum2SensorError := StatusAnalogInputBroken( X20AI4322_102.ModuleOk, X20AI4322_102.Status01, X20AI4322_102.Status02, 4);

	
	gInks[1].signals.in.iTemperatureRaw := X20AT2222_103.TempInput[1];
	gInks[1].signals.in.xTempSensorError := StatusTemperatureInput(X20AT2222_103.Status01, 1);
	gInks[1].signals.in.iTemperatureTankRaw := X20AT2222_103.TempInput[3];
	gInks[1].signals.in.xTempTankSensorError := StatusTemperatureInput(X20AT2222_103.Status01, 3);

	gInks[2].signals.in.iTemperatureRaw := X20AT2222_103.TempInput[2];
	gInks[2].signals.in.xTempSensorError := StatusTemperatureInput(X20AT2222_103.Status01, 2);
	gInks[2].signals.in.iTemperatureTankRaw := X20AT2222_103.TempInput[4];
	gInks[2].signals.in.xTempTankSensorError := StatusTemperatureInput(X20AT2222_103.Status01, 4);


	// GROUP _20x
	gInks[3].signals.in.xPrintHeadsPsuOK := NOT X20DIF371_201.DInput[1];
	gInks[3].signals.in.xKlixonTriggered := X20DIF371_201.DInput[3];
	gInks[3].signals.in.xOverpressure := NOT X20DIF371_201.DInput[5];
	gInks[3].signals.in.xMaxLevel := X20DIF371_201.DInput[7];
	gInks[3].signals.in.xMinLevel := X20DIF371_201.DInput[9];
	
	gInks[4].signals.in.xPrintHeadsPsuOK := NOT X20DIF371_201.DInput[2];
	gInks[4].signals.in.xKlixonTriggered := X20DIF371_201.DInput[4];
	gInks[4].signals.in.xOverpressure := NOT X20DIF371_201.DInput[6];
	gInks[4].signals.in.xMaxLevel := X20DIF371_201.DInput[8];
	gInks[4].signals.in.xMinLevel := X20DIF371_201.DInput[10];

	
	gInks[3].signals.in.iVacuum1Raw := X20AI4322_202.AInput[1];
	gInks[3].signals.in.xVacuum1SensorError := StatusAnalogInputBroken( X20AI4322_202.ModuleOk, X20AI4322_202.Status01, X20AI4322_202.Status02, 1);
	gInks[3].signals.in.iVacuum2Raw := X20AI4322_202.AInput[3];
	gInks[3].signals.in.xVacuum2SensorError := StatusAnalogInputBroken( X20AI4322_202.ModuleOk, X20AI4322_202.Status01, X20AI4322_202.Status02, 3);

	gInks[4].signals.in.iVacuum1Raw := X20AI4322_202.AInput[2];
	gInks[4].signals.in.xVacuum1SensorError := StatusAnalogInputBroken( X20AI4322_202.ModuleOk, X20AI4322_202.Status01, X20AI4322_202.Status02, 2);
	gInks[4].signals.in.iVacuum2Raw := X20AI4322_202.AInput[4];
	gInks[4].signals.in.xVacuum2SensorError := StatusAnalogInputBroken( X20AI4322_202.ModuleOk, X20AI4322_202.Status01, X20AI4322_202.Status02, 4);

	
	gInks[3].signals.in.iTemperatureRaw := X20AT2222_203.TempInput[1];
	gInks[3].signals.in.xTempSensorError := StatusTemperatureInput(X20AT2222_203.Status01, 1);
	gInks[3].signals.in.iTemperatureTankRaw := X20AT2222_203.TempInput[3];
	gInks[3].signals.in.xTempTankSensorError := StatusTemperatureInput(X20AT2222_203.Status01, 3);

	gInks[4].signals.in.iTemperatureRaw := X20AT2222_203.TempInput[2];
	gInks[4].signals.in.xTempSensorError := StatusTemperatureInput(X20AT2222_203.Status01, 2);
	gInks[4].signals.in.iTemperatureTankRaw := X20AT2222_203.TempInput[4];
	gInks[4].signals.in.xTempTankSensorError := StatusTemperatureInput(X20AT2222_203.Status01, 4);
	
		
	// GROUP _30x
	gInks[5].signals.in.xPrintHeadsPsuOK := NOT X20DIF371_301.DInput[1];
	gInks[5].signals.in.xKlixonTriggered := X20DIF371_301.DInput[3];
	gInks[5].signals.in.xOverpressure := NOT X20DIF371_301.DInput[5];
	gInks[5].signals.in.xMaxLevel := X20DIF371_301.DInput[7];
	gInks[5].signals.in.xMinLevel := X20DIF371_301.DInput[9];
	
	gInks[6].signals.in.xPrintHeadsPsuOK := NOT X20DIF371_301.DInput[2];
	gInks[6].signals.in.xKlixonTriggered := X20DIF371_301.DInput[4];
	gInks[6].signals.in.xOverpressure := NOT X20DIF371_301.DInput[6];
	gInks[6].signals.in.xMaxLevel := X20DIF371_301.DInput[8];
	gInks[6].signals.in.xMinLevel := X20DIF371_301.DInput[10];
	
	
	gInks[5].signals.in.iVacuum1Raw := X20AI4322_302.DInput[1];
	gInks[5].signals.in.xVacuum1SensorError := StatusAnalogInputBroken( X20AI4322_302.ModuleOk, X20AI4322_302.Status01, X20AI4322_302.Status02, 1);
	gInks[5].signals.in.iVacuum2Raw := X20AI4322_302.DInput[3];
	gInks[5].signals.in.xVacuum2SensorError := StatusAnalogInputBroken( X20AI4322_302.ModuleOk, X20AI4322_302.Status01, X20AI4322_302.Status02, 3);

	gInks[6].signals.in.iVacuum1Raw := X20AI4322_302.DInput[2];
	gInks[6].signals.in.xVacuum1SensorError := StatusAnalogInputBroken( X20AI4322_302.ModuleOk, X20AI4322_302.Status01, X20AI4322_302.Status02, 2);
	gInks[6].signals.in.iVacuum2Raw := X20AI4322_302.DInput[4];
	gInks[6].signals.in.xVacuum2SensorError := StatusAnalogInputBroken( X20AI4322_302.ModuleOk, X20AI4322_302.Status01, X20AI4322_302.Status02, 4);

	
	gInks[5].signals.in.iTemperatureRaw := X20AT2222_303.TempInput[1];
	gInks[5].signals.in.xTempSensorError := StatusTemperatureInput(X20AT2222_303.Status01, 1);
	gInks[5].signals.in.iTemperatureTankRaw := X20AT2222_303.TempInput[3];
	gInks[5].signals.in.xTempTankSensorError := StatusTemperatureInput(X20AT2222_303.Status01, 3);

	gInks[6].signals.in.iTemperatureRaw := X20AT2222_303.TempInput[2];
	gInks[6].signals.in.xTempSensorError := StatusTemperatureInput(X20AT2222_303.Status01, 2);
	gInks[6].signals.in.iTemperatureTankRaw := X20AT2222_303.TempInput[4];
	gInks[6].signals.in.xTempTankSensorError := StatusTemperatureInput(X20AT2222_303.Status01, 4);
	
END_ACTION

