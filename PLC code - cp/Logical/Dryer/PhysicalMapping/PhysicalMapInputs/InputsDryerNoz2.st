
ACTION InputsDryerNoz2:

	//REMOTE SIGNALS
	gDryer.In.Safety := gDryerRemoteData.Signals.Safety;
	tonNoCommsPrinter.IN := NOT gDryerRemoteData.xCommsOK;
	tonNoCommsPrinter.PT := t#1s;
	tonNoCommsPrinter();
	IF gDryerRemoteData.xCommsOK THEN
		gAxisInverter[1].ElecSignals.In.xBreakerOK := gDryerRemoteData.Signals.xBreakerOKBlowerInput; //NOT Line_X20DIF371_003.DInput[15];
	ELSIF tonNoCommsPrinter.Q THEN
		gAxisInverter[1].ElecSignals.In.xBreakerOK := FALSE;
	END_IF
		
	gAxisInverter[2].ElecSignals.In.xBreakerOK := gDryerRemoteData.Signals.xBreakerOKBlowerOutput; //NOT Line_X20DIF371_003.DInput[16];
	
	// X20DIF371_201 DIGITAL INPUTS
	gBasicDetectMedia.Inputs.xMountedMedia := NOT X20DIF371_201.DInput[1];
	gDryer.In.Buttons.xStop := NOT X20DIF371_201.DInput[2];
	gDryer.In.Buttons.xReset := X20DIF371_201.DInput[3];
	gDryer.In.xFanBreakersOK := X20DIF371_201.DInput[4];
	gDryer.In.xFanBreakersWarning := X20DIF371_201.DInput[5];
	gDryer.In.xOpenDoorsKey := X20DIF371_201.DInput[6];
	gSimpleBlock[1].In.xReferenceDI := X20DIF371_201.DInput[7];
	//gBasicDetectMedia.Inputs.xCorrection := NOT X20DIF371_201.DInput[8];
	gDryer.In.xFan24VdcOK := X20DIF371_201.DInput[9];
	gDryer.In.xMain24VdcOK := X20DIF371_201.DInput[10];
	
	gDryer.In.iMachineModelCode.0 := X20DIF371_201.DInput[13];
	gDryer.In.iMachineModelCode.1 := X20DIF371_201.DInput[14];
	gDryer.In.iMachineModelCode.2 := X20DIF371_201.DInput[15];
	gDryer.In.iMachineModelCode.3 := X20DIF371_201.DInput[16];

	
	// X20DIF371_202 DIGITAL INPUTS
	gNirAdphos.Signals.In.xReady:= X20DIF371_202.DInput[1];
	gNirAdphos.Signals.In.xInProcess := X20DIF371_202.DInput[2];
	gNirAdphos.Signals.In.xFault := X20DIF371_202.DInput[3];
	gDryerRemoteData.Commands.xRunTransport := X20DIF371_202.DInput[4];
	gDryer.In.Buttons.xAuto := gDryer.In.xAuto_GI := X20DIF371_202.DInput[5];
	gDryer.In.Buttons.xZero := gDryer.In.xZero_GI := NOT X20DIF371_202.DInput[6];
	gDryer.In.Buttons.xManual := gDryer.In.xManual_GI := X20DIF371_202.DInput[7];
	gDryer.In.Buttons.xStopBlowers := X20DIF371_202.DInput[8];
	gNirAdphos.Signals.In.Jam[2].xMechCross := NOT X20DIF371_202.DInput[9] OR NOT X20DIF371_202.DInput[10];
	gBasicDetectMedia.Inputs.xMediaPresentL1 := X20DIF371_202.DInput[13] AND (NOT gDryer.St.AutoLocation.xRemote OR gDryerRemoteData.Parameters.xPrinterBeltRuning); //NOZOMITWO-2512
	gThicknessCtrl.Inputs.CheckMedia[1].xCheckFail := X20DIF371_202.DInput[14];
	gBasicDetectMedia.Inputs.xMediaPresentL2 := X20DIF371_202.DInput[15];
	gThicknessCtrl.Inputs.CheckMedia[2].xCheckFail := X20DIF371_202.DInput[16];
	
	// X20DIF371_203 DIGITAL INPUTS
	gNirAdphos.Signals.In.BlockedFans[1].Fan[1]	:= X20DIF371_203.DInput[1];
	gNirAdphos.Signals.In.BlockedFans[1].Fan[2]	:= X20DIF371_203.DInput[2];
	gNirAdphos.Signals.In.BlockedFans[1].Fan[3]	:= X20DIF371_203.DInput[3];
	gNirAdphos.Signals.In.BlockedFans[1].Fan[4]	:= X20DIF371_203.DInput[4];
	
	gNirAdphos.Signals.In.BlockedFans[2].Fan[1]	:= X20DIF371_203.DInput[5];
	gNirAdphos.Signals.In.BlockedFans[2].Fan[2]	:= X20DIF371_203.DInput[6];
	gNirAdphos.Signals.In.BlockedFans[2].Fan[3]	:= X20DIF371_203.DInput[7];
	gNirAdphos.Signals.In.BlockedFans[2].Fan[4]	:= X20DIF371_203.DInput[8];
	
	gJamDetect[1].Inputs.xJamCrash[1] := X20DIF371_203.DInput[9];
	gJamDetect[1].Inputs.xJamCrash[2] := X20DIF371_203.DInput[10];
	gJamDetect[1].Inputs.xJamCrash[3] := X20DIF371_203.DInput[11];
	gJamDetect[1].Inputs.xJamCrash[4] := X20DIF371_203.DInput[12];
	gJamDetect[1].Inputs.xJamLowCrash := X20DIF371_203.DInput[13];
	gJamDetect[1].Inputs.xJamTestOk := X20DIF371_203.DInput[14];
	
	gNirAdphos.Signals.In.Jam[1].xMechCross := NOT X20DIF371_203.DInput[15] OR NOT X20DIF371_203.DInput[16];
		
	
	// X20AI8321_207 ANALOG INPUTS
	gDryer.In.Temp.iBoardInRaw := X20AI8321_207.AInput[1];
	gDryer.In.Temp.iBoardOutRaw := X20AI8321_207.AInput[2];
	gDryer.In.Temp.iBeltRaw := X20AI8321_207.AInput[3];
	gNirAdphos.Signals.In.iInletHumidityRaw := X20AI8321_207.AInput[4];
	gNirAdphos.Signals.In.iInletTempRaw := X20AI8321_207.AInput[5];
	gTransVacuum[1].Inputs.iPressureRaw := X20AI8321_207.AInput[6];
	gDryer.In.Temp.iAirBlowerInputRaw := X20AI8321_207.AInput[7];
	gDryer.In.Temp.iAirBlowerOutputRaw := X20AI8321_207.AInput[8];

	gDryer.In.Temp.xBoardInSensorError := StatusAnalogInputBroken( X20AI8321_207.ModuleOk, X20AI8321_207.Status01, X20AI8321_207.Status02, 1);
	gDryer.In.Temp.xBoardOutSensorError := StatusAnalogInputBroken( X20AI8321_207.ModuleOk, X20AI8321_207.Status01, X20AI8321_207.Status02, 2);
	gDryer.In.Temp.xBeltSensorError := StatusAnalogInputBroken( X20AI8321_207.ModuleOk, X20AI8321_207.Status01, X20AI8321_207.Status02, 3);
	gNirAdphos.Signals.In.xInletHumiditySensorError := StatusAnalogInputBroken( X20AI8321_207.ModuleOk, X20AI8321_207.Status01, X20AI8321_207.Status02, 4);
	gNirAdphos.Signals.In.xInletTempSensorError := StatusAnalogInputBroken( X20AI8321_207.ModuleOk, X20AI8321_207.Status01, X20AI8321_207.Status02, 5);
	gTransVacuum[1].Inputs.xPressureSensorError	:= StatusAnalogInputBroken(X20AI8321_207.ModuleOk, X20AI8321_207.Status01, X20AI8321_207.Status02, 6);
	gDryer.In.Temp.xAirBlowerInputSensorError := StatusAnalogInputBroken( X20AI8321_207.ModuleOk, X20AI8321_207.Status01, X20AI8321_207.Status02, 7);
	gDryer.In.Temp.xAirBlowerOutputSensorError := StatusAnalogInputBroken( X20AI8321_207.ModuleOk, X20AI8321_207.Status01, X20AI8321_207.Status02, 8);

	// X20AT4222_209 TEMPERATURE INPUTS	
	gNirAdphos.Signals.In.iSurfaceTempModuleRaw[1] := X20AT4222_209.TempInput[1];
	gNirAdphos.Signals.In.iSurfaceTempModuleRaw[2] := X20AT4222_209.TempInput[2];
	
	gNirAdphos.Signals.In.xSurfaceTempModuleSensorError[1] := StatusAnalogInputBroken( X20AT4222_209.ModuleOk, X20AT4222_209.Status01, X20AT4222_209.Status02, 1);
	gNirAdphos.Signals.In.xSurfaceTempModuleSensorError[2] := StatusAnalogInputBroken( X20AT4222_209.ModuleOk, X20AT4222_209.Status01, X20AT4222_209.Status02, 2);
	
END_ACTION
