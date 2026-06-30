
ACTION LineOutputs:
	
	//Ancillaries present inputs
	Feeder.Inputs.xFeederPresent := Line.Outputs.ExternalDevices[0].xClose;
	Primer.Inputs.xPrimerPresent := Line.Outputs.ExternalDevices[1].xClose;
	OverVarnish.Inputs.xOPVPresent := Line.Outputs.ExternalDevices[10].xClose;
	Stacker.Inputs.xStackerPresent := Line.Outputs.ExternalDevices[6].xClose;
	Sarm.Inputs.xSarmPresent := Line.Outputs.ExternalDevices[11].xClose;
	
	//DryerRemoteData
	
	//Commands
	DryerData.Commands.xPrepareToDry := Dryer.Outputs.xPrepareToDry;
	DryerData.Commands.xStartDrying := Dryer.Outputs.xStartDrying;
	DryerData.Commands.xPrepareToEmptyBelt := Dryer.Outputs.xPrepareToEmptyBelt;
	
	DryerData.Parameters.xEnableNir := Dryer.ParSw.xEnableNIR;
	DryerData.Parameters.xEnableArcLamp := Dryer.ParSw.xEnableArcLamp;
	DryerData.Parameters.xEnableDDC := Dryer.ParSw.xEnableDDC;

	//Parameters
	DryerData.Parameters.rBeltSpeedSetPoint := Dryer.Parameters.rSpeedSetPoint;
	DryerData.Parameters.Media.rThickness := Dryer.Parameters.rMediaThickness;
	DryerData.Parameters.Media.rWidth := Dryer.Parameters.rMediaWidth;
	DryerData.Parameters.Media.rLength := Dryer.Parameters.rMediaLength;
	DryerData.Parameters.Media.rCrossOffset := gMachine.parSw.Media.rOffsetRegisterL1;
	
	DryerData.Parameters.Media.rDocWidth := Dryer.Parameters.rDocumentWidth;
	DryerData.Parameters.Media.rDocLength := Dryer.Parameters.rDocumentLength;
	DryerData.Parameters.Media.rDocCrossOffset := Dryer.Parameters.rDocumentOffsetL1; //NOZDRYER-467
	//DryerData.Parameters.Document.rOffsetL2 := Dryer.Parameters.rDocumentOffsetL2; //NOZDRYER-467
	DryerData.Parameters.xDoubleLine := Dryer.Parameters.xDoubleLine;
	DryerData.Parameters.xLineEmptyingBelt := Line.StatusSummary.xEmptyingBelts;
	DryerData.Parameters.xPrinterBeltRuning := Belt.states.xRuningBelt;
	DryerData.Parameters.rSubstratePowerReduction := Dryer.ParSw.rSubstratePowerReduction;
	
	//Signals
	DryerData.Signals.xMediaPresent := ThickCtrl.status.MediaPosition.xMediaAtPrinterExit; //Dryer.Inputs.xMediaPresent
	//DryerData.Signals.xBreakerOKBlowerInput := Line_X20DIF371_003.DInput[15];  //Mapping done directly in plc card assignation
	//DryerData.Signals.xBreakerOKBlowerOutput := Line_X20DIF371_003.DInput[16];  //Mapping done directly in plc card assignation
	
	DryerData.Signals.Safety.xMovementsEnabled := SafetyController.Outputs.xEnableDryer1; // AND SafetyController.Outputs.xEnableDryer2;
	DryerData.Signals.Safety.xRemoteEStopOK := NOT SafetyController.Alarms.xCriticalAlarm;
	DryerData.Signals.Safety.xEStopFrontOK := SafetyController.Inputs.xDryerFrontsideEstop;
	DryerData.Signals.Safety.xEStopRearOK := SafetyController.Inputs.xDryerBacksideEstop;
	DryerData.Signals.Safety.xClosedFrontInput := SafetyController.Inputs.xDryerFrontDoorSwitch1;
	DryerData.Signals.Safety.xClosedFrontOutput := SafetyController.Inputs.xDryerFrontDoorSwitch2;
	DryerData.Signals.Safety.xClosedRearInput := SafetyController.Inputs.xDryerBackDoorSwitch1;
	DryerData.Signals.Safety.xClosedRearOutput := SafetyController.Inputs.xDryerBackDoorSwitch2;
	
	IF EDGENEG(ThickCtrl.parameters.xBlockInProperPrintingPosition) AND (Line.Status=LINE_PRINTING) THEN
		Line.Outputs.Sw.iTimesBlockAtSafePosition := Line.Outputs.Sw.iTimesBlockAtSafePosition + 1;
	ELSIF Line.Status=LINE_STOPPED THEN
		Line.Outputs.Sw.iTimesBlockAtSafePosition := 0;
	END_IF
		
	//DELOREAN-830: To ask sw to execute a cleaning command when curing has been active when block is at safe position
	xCuringSystemStarted := CuringSystemsStarted(ADR(CuringLed[1])) OR CuringSystemsStarted(ADR(CuringLed[2]));
	IF NOT ThickCtrl.parameters.xBlockInProperPrintingPosition AND xCuringSystemStarted THEN
		xToCleanAfterBlockAtSafePosition := TRUE;
	END_IF

	//DELOREAN-830: Request SW to execute a cleaning
	//To active this output just when line is receptive to "Line.Commands.Clean" 
	Line.Outputs.Sw.xCleanOrderRequestToSw := xToCleanAfterBlockAtSafePosition AND (Line.Status=LINE_IDLE);
	IF Line.StatusSummary.xCleaning OR 
		EDGEPOS(Line.StatusSummary.xPrinting) OR
		EDGEPOS(Line.StatusSummary.xEmptyingBelts) THEN
	 	
		xToCleanAfterBlockAtSafePosition:=FALSE;
	END_IF
	
	Line.Outputs.Sw.xPrintOrderRequestToSw:=xLineRequestToPrintToSw;
	
END_ACTION