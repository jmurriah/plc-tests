PROGRAM _CYCLIC
	(* Insert code here *)
	SafetyController ACCESS ADR(gSafetyController);
	SimSafetyController ACCESS ADR(gSimSafetyController);
	
	
	IF EDGEPOS(SimSafetyController.Commands.xSafetyToDefault) THEN
		SafetyController.Status.Comms.xModuleOk := TRUE;
		//Modules physical inputs
		//Ancillaries
		SimSafetyController.Inputs.xFeederEstop				:= TRUE;
		SimSafetyController.Inputs.xPrimerEstop 			:= TRUE;
		SimSafetyController.Inputs.xOvervarnishEstop 		:= TRUE;
		SimSafetyController.Inputs.xStackerEstop 			:= TRUE;
		SimSafetyController.Inputs.xSarmEstop				:= TRUE;
		
		//Dryer
		SimSafetyController.Inputs.xDryerBacksideEstop 		:= TRUE;
		SimSafetyController.Inputs.xDryerFrontsideEstop 	:= TRUE;
		SimSafetyController.Inputs.xDryerFrontDoorSwitch1	:= TRUE;
		SimSafetyController.Inputs.xDryerFrontDoorSwitch2	:= TRUE;
		SimSafetyController.Inputs.xDryerBackDoorSwitch1	:= TRUE;
		SimSafetyController.Inputs.xDryerBackDoorSwitch2	:= TRUE;
		SimSafetyController.Inputs.xDryerMaintenanceKey		:= FALSE;
		SimSafetyController.Inputs.xDryerBlowersEnable		:= TRUE;
		
		//Printer
		SimSafetyController.Inputs.xPrinterMaintenanceKey 	:= FALSE;
		SimSafetyController.Inputs.xPrinterBlowersEnable	:= TRUE;
		SimSafetyController.Inputs.xPrinterBlowersSwitch	:= TRUE;
		SimSafetyController.Inputs.xPrinterLightCurtain 	:= TRUE;
		SimSafetyController.Inputs.xPrinterDoorLock 		:= TRUE;
		SimSafetyController.Inputs.xPrinterBacksideEstop 	:= TRUE;
		SimSafetyController.Inputs.xPrinterFrontsideEstop 	:= TRUE;
		
		//OSSD Outputs
		SimSafetyController.Outputs.xEnablePrinter1 		:= TRUE;
		SimSafetyController.Outputs.xEnablePrinterBlowers1 	:= TRUE;
		SimSafetyController.Outputs.xEnableDryer1			:= TRUE;
	
		SafetyController.Status.Comms.xModuleOk 			:= TRUE;
		
		//Fieldbus probe
		//Inputs
		SimSafetyController.Inputs.xPrinterRearDoorSwitch 	:= TRUE;
		SimSafetyController.Inputs.xHmiSwitch 				:= TRUE;
		SimSafetyController.Inputs.xPrinterFrontDoorSwitch 	:= TRUE; 
		SimSafetyController.Inputs.xX5Consent 				:= TRUE;
		SimSafetyController.Inputs.xFanDoorSwitch	 		:= TRUE;
		
		//Outputs				
		SimSafetyController.Outputs.xEnablePrinter1 		:= TRUE;
		SimSafetyController.Outputs.xPrinterToX5 			:= TRUE;
				
		//Resetting command
		SimSafetyController.Commands.xSafetyToDefault		:= FALSE;
	END_IF
			
	SafetyController.Inputs := SimSafetyController.Inputs;
	
END_PROGRAM
