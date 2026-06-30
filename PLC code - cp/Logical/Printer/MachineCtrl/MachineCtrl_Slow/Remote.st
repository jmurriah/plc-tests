
ACTION Remote: 

	gMachine.St.Remote.xMachineReady := gBelt.states.xRuningBelt AND gTransVacuum[1].Status.Blower.xMoving AND NOT gMachine.In.xRemoteJog;
	gMachine.St.Remote.xReadyToJogInJamRecovery := gMachine.St.AutoMode.xJamRecovery AND gBlock[1].Status.Position.xInPrint AND gTransVacuum[1].Status.Blower.xMoving;
	
	iReasonReadyToReset := 16#FFFF;
	iReasonReadyToReset.0 := gSafetyController.Inputs.xPrinterBacksideEstop;
	iReasonReadyToReset.1 := gSafetyController.Inputs.xPrinterFrontsideEstop;
	iReasonReadyToReset.2 := gSafetyController.Inputs.xFeederEstop;
	iReasonReadyToReset.3 := gSafetyController.Inputs.xPrimerEstop;
	iReasonReadyToReset.4 := gSafetyController.Inputs.xOvervarnishEstop;
	iReasonReadyToReset.5 := gSafetyController.Inputs.xStackerEstop;
	iReasonReadyToReset.6 := gSafetyController.Inputs.xPrinterLightCurtain;
	iReasonReadyToReset.7 := gSafetyController.Inputs.xPrinterDoorLock;
	
	gMachine.St.Remote.xSafetyReadyToReset := iReasonReadyToReset = 16#FFFF;
	
END_ACTION
