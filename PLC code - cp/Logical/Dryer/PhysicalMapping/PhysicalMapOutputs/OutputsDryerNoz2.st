
ACTION OutputsDryerNoz2:
	
	// X20DOF322_205 DIGITAL OUTPUTS
	X20DOF322_205.DOutput[1] := gNirAdphos.Signals.Out.xPowerOn;
	X20DOF322_205.DOutput[2] := gNirAdphos.Signals.Out.xProcess;
	X20DOF322_205.DOutput[3] := gNirAdphos.Signals.Out.xSafetyStop;
	X20DOF322_205.DOutput[4] := NOT gDryer.Out.xKeepSafetyNIR; //gArcLampGew.Signals.Out.xImpression;
	X20DOF322_205.DOutput[5] := gJamDetect[1].Outputs.xJamTestSignal[1];
	X20DOF322_205.DOutput[6] := gJamDetect[1].Outputs.xJamTestSignal[2];
	X20DOF322_205.DOutput[7] := gJamDetect[1].Outputs.xJamTestSignal[3];
	X20DOF322_205.DOutput[8] := gJamDetect[1].Outputs.xJamTestSignal[4];
 

	// X20DOF322_206 DIGITAL OUTPUTS
	X20DOF322_206.DOutput[1] := gDryer.Out.xLockFrontDoor;
	X20DOF322_206.DOutput[2] := gDryer.Out.xLockRearDoor;
	X20DOF322_206.DOutput[3] := gDryer.Out.xResetFanBreaker;
	X20DOF322_206.DOutput[4] := gDryer.Out.xResetHub;
	X20DOF322_206.DOutput[5] := gDryer.Out.xResetSwitch;
	X20DOF322_206.DOutput[6] := gDryer.AlSummary.xAlarmCritical OR gDryer.AlSummary.xAlarmStop;
	X20DOF322_206.DOutput[7] := FALSE;
	X20DOF322_206.DOutput[8] := FALSE;
	X20DOF322_206.DOutput[9] := FALSE;
	X20DOF322_206.DOutput[10] := FALSE;
	X20DOF322_206.DOutput[11] := gDryer.Out.xBuzzer;
	X20DOF322_206.DOutput[12] := gDryer.Out.xYellowLight;
	X20DOF322_206.DOutput[13] := gDryer.Out.xBlueLight;
	X20DOF322_206.DOutput[14] := gDryer.Out.xRedLight;
	X20DOF322_206.DOutput[15] := gDryer.Out.xWhiteLight;
	X20DOF322_206.DOutput[16] := gDryer.Out.xResetBlueLight;
	
	
	// X20AO4622_208 ANALOG OUTPUTS
	X20AO4622_208.AOutput[1] := gNirAdphos.Signals.Out.iBeltSpeed;
	X20AO4622_208.AOutput[2] := gArcLampGew.Signals.Out.iBeltSpeed;
	
END_ACTION
