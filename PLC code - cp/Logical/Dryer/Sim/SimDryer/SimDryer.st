
PROGRAM _INIT
	
	gDryer.In.xMain24VdcOK:=TRUE;
	gDryer.In.xFan24VdcOK:=TRUE;
	gDryer.In.xFanBreakersOK:=TRUE;
	gDryer.In.xFanBreakersWarning:=TRUE;
	
	gNirAdphos.Signals.In.iInletHumidityRaw := 20000;
	gNirAdphos.Signals.In.iInletTempRaw := 25000;
	
	gDryer.In.Temp.iBeltRaw := 10500;
	gDryer.In.Temp.iBoardInRaw := 10000;
	gDryer.In.Temp.iBoardOutRaw := 11000;
	gDryer.In.Temp.iAirBlowerInputRaw := 12000;
	gDryer.In.Temp.iAirBlowerOutputRaw := 12500;

	gDryer.In.Safety.xClosedFrontInput := TRUE;
	gDryer.In.Safety.xClosedFrontOutput := TRUE;
	gDryer.In.Safety.xClosedRearInput := TRUE;
	gDryer.In.Safety.xClosedRearOutput := TRUE;
	gDryer.In.Safety.xEStopFrontOK := TRUE;
	gDryer.In.Safety.xEStopRearOK := TRUE;
	gDryer.In.Safety.xMovementsEnabled := TRUE;
	gDryer.In.Safety.xRemoteEStopOK := TRUE;
	
	gDryerRemoteData.Signals.Safety.xClosedFrontInput := TRUE;
	gDryerRemoteData.Signals.Safety.xClosedFrontOutput := TRUE;
	gDryerRemoteData.Signals.Safety.xClosedRearInput := TRUE;
	gDryerRemoteData.Signals.Safety.xClosedRearOutput := TRUE;
	gDryerRemoteData.Signals.Safety.xEStopFrontOK := TRUE;
	gDryerRemoteData.Signals.Safety.xEStopRearOK := TRUE;
	gDryerRemoteData.Signals.Safety.xMovementsEnabled := TRUE;
	gDryerRemoteData.Signals.Safety.xRemoteEStopOK := TRUE;
	
	gDryerRemoteData.Signals.xBreakerOKBlowerInput := TRUE;
	gDryerRemoteData.Signals.xBreakerOKBlowerOutput := TRUE;
	
	//We need to write over the permanent var because is loaded during machine init
	//gPermanentBelt.xDriveProtectionOK:=TRUE;
	gBelt.parameters.xDriveProtectionOK:=TRUE;
	
	gAxisInverter[1].ElecSignals.In.xBreakerOK := TRUE;
	gAxisInverter[2].ElecSignals.In.xBreakerOK := TRUE;
	
	URLHost := '127.0.0.1';
	
	webClient.option := httpOPTION_HTTP_11;
	webClient.pHost := ADR(URLHost);
	webClient.pUri := ADR(URIHost);
	webClient.hostPort := 83;
	webClient.method := httpMETHOD_GET;
	
	webClient.pResponseHeader := ADR(ResponseHeader);
	webClient.pResponseData := ADR(ResponseData);
	webClient.responseDataSize := SIZEOF(ResponseData);
	webClient.pRequestData := ADR(RequestData);
	webClient.requestDataLen := SIZEOF(RequestData);

	gSimMachine.Parameters.DryerType := SIM_DRYER_NOZ2_NIR;
	gSimMachine.Parameters.xAutoMediaPresent := TRUE;
	
	gDryer.Pt.SW.Media.rThickness := 3.2;
	gDryer.Pt.SW.Media.rWidth := 1400;
	gDryer.Pt.SW.Media.rLength := 2500;
	gDryer.Pt.SW.Media.rCrossOffset := -700;
	gDryer.Pt.SW.Media.rDocWidth := 1400;
	gDryer.Pt.SW.Media.rDocLength := 2500;
	gDryer.Pt.SW.Media.rDocCrossOffset := -700;

	gSimDryer.Parameters.rGap := 400; //To simulate entering media	
	
	// ###################################
	// END OF INIT CODE

END_PROGRAM

PROGRAM _CYCLIC
	
	//Define the inputs of the Machine depending the machine to Simulate
	CASE gSimMachine.Parameters.DryerType OF
		SIM_DRYER_NOZ2_NIR_ARCLAMP:
			gDryer.In.iMachineModelCode:=3;
		SIM_DRYER_NOZ2_NIR:
			gDryer.In.iMachineModelCode:=2;
	END_CASE
	
	gDryer.In.Buttons.xManual := gDryer.In.xManual_GI;
	gDryer.In.Buttons.xZero := gDryer.In.xZero_GI;
	gDryer.In.Buttons.xAuto := gDryer.In.xAuto_GI;
	gDryer.In.Buttons.xStopBlowers := gDryer.In.Sw.xStopBlowers_GI;
	
	//Signal from the selector
	IF EDGEPOS(gDryer.In.Buttons.xManual) THEN
		gDryer.In.Buttons.xZero:=FALSE;
		gDryer.In.Buttons.xAuto:=FALSE;
	END_IF
	IF EDGEPOS(gDryer.In.Buttons.xZero) THEN
		gDryer.In.Buttons.xManual:=FALSE;
		gDryer.In.Buttons.xAuto:=FALSE;
	END_IF
	IF EDGEPOS(gDryer.In.Buttons.xAuto) THEN
		gDryer.In.Buttons.xManual:=FALSE;
		gDryer.In.Buttons.xZero:=FALSE;
	END_IF
	
	IF EDGE(gDryer.In.Sw.xReset_GI) THEN
		gDryer.In.Buttons.xReset:=gDryer.In.Sw.xReset_GI;
	END_IF
	
	IF EDGEPOS(gSimMachine.Commands.xToZero) THEN
		gDryer.In.Buttons.xZero:=TRUE;
		gDryer.In.Buttons.xManual:=FALSE;
		gDryer.In.Buttons.xAuto:=FALSE;
		
		simEventLog.Source := ELOG_TYPE_GENERAL;
		simEventLog.Severity:= ELOG_SEVERITY_INFO;
		simEventLog.Facility:= 0;
		simEventLog.ErrorCode:=0;
		simEventLog.Text := 'Machine going to Zero in Simulation';
		gEventLogLoader(EventData:=ADR(simEventLog));
	
	END_IF
	IF gSimMachine.Commands.xToZero AND gDryer.St.Mode.xZero THEN
		gSimMachine.Commands.xToZero:=FALSE;
	END_IF

	IF EDGEPOS(gSimMachine.Commands.xToManual) AND gDryer.St.Mode.xManual THEN
		gSimMachine.Commands.xToManual:=FALSE;
	END_IF
	IF EDGEPOS(gSimMachine.Commands.xToManual) THEN
		gDryer.In.Buttons.xZero:=FALSE;
		gDryer.In.Buttons.xManual:=TRUE;
		gDryer.In.Buttons.xAuto:=FALSE;
		gDryer.In.Buttons.xReset:=TRUE;
	END_IF
	IF gSimMachine.Commands.xToManual AND gDryer.St.Mode.xManual THEN
		gSimMachine.Commands.xToManual:=FALSE;
		gDryer.In.Buttons.xReset:=FALSE;
	END_IF
	
	IF EDGEPOS(gSimMachine.Commands.xToAuto) AND gDryer.St.Mode.xAuto THEN
		gSimMachine.Commands.xToAuto:=FALSE;
	END_IF
	IF EDGEPOS(gSimMachine.Commands.xToAuto) THEN
		gDryer.In.Buttons.xZero:=FALSE;
		gDryer.In.Buttons.xManual:=FALSE;
		gDryer.In.Buttons.xAuto:=TRUE;
		gDryer.In.Buttons.xReset:=TRUE;
	END_IF
	IF gSimMachine.Commands.xToAuto AND gDryer.St.Mode.xAuto THEN
		gSimMachine.Commands.xToAuto:=FALSE;
		gDryer.In.Buttons.xReset:=FALSE;
	END_IF
	
	IF EDGEPOS(gSimMachine.Commands.Media.xMediaPresent) THEN
		//TOBEIMPLEMENTED
	END_IF
	IF EDGENEG(gSimMachine.Commands.Media.xMediaPresent) THEN
		//TOBEIMPLEMENTED
	END_IF
	
	tonSimMediaAuto.IN := gSimMachine.Parameters.xAutoMediaPresent AND gDryer.St.Mode.xAuto AND (gDryer.St.DryerState = DRYERMACH_DRYING OR gDryer.St.DryerState = DRYERMACH_STARTING);
	IF gBelt.states.rCurrentSpeed > 1 THEN
		tonSimMediaAuto.PT := REAL_TO_TIME(60 * (gDryer.Pt.SW.Media.rLength + gSimDryer.Parameters.rGap) / gBelt.states.rCurrentSpeed);
	ELSE
		tonSimMediaAuto.PT := t#3s; // default and previous value
	END_IF
	tonSimMediaAuto();
	
	IF gDryer.St.Mode.xAuto THEN
		//Starting system
		IF EDGEPOS(gDryer.St.DryerState = DRYERMACH_DRYING) OR EDGEPOS(tonSimMediaAuto.Q) THEN
			xSimulateMedia := TRUE;
		ELSIF EDGENEG(gDryer.St.DryerState = DRYERMACH_DRYING) THEN
			xSimulateMedia := FALSE;
		END_IF
	ELSE
		xSimulateMedia := FALSE;
	END_IF
	
	tonSimMedia.IN := xSimulateMedia AND NOT tonSimMedia.Q;
	IF gBelt.states.rCurrentSpeed = 0 THEN
		tonSimMedia.PT := t#3s;
	ELSE
		tonSimMedia.PT := REAL_TO_TIME(60 * (gDryer.Pt.SW.Media.rLength + gSimDryer.Parameters.rGap) / gBelt.states.rCurrentSpeed);
	END_IF
	tonSimMedia();
	
	IF EDGEPOS(tonSimMedia.Q) THEN
		gDryerLocalSignals.Signals.xMediaPresent := NOT gDryerLocalSignals.Signals.xMediaPresent;
		gBasicDetectMedia.Inputs.xMediaPresentL1 := NOT gBasicDetectMedia.Inputs.xMediaPresentL1;
	END_IF
	IF EDGENEG(xSimulateMedia) THEN
		gDryerLocalSignals.Signals.xMediaPresent := FALSE;
		gBasicDetectMedia.Inputs.xMediaPresentL1 := FALSE;
	END_IF
	
	// Not the best way to simulate the behaviour, maybe in the future we will need something more accurate
	gThicknessCtrl.Inputs.CheckMedia[1].xCheckFail := gThicknessCtrl.status.MediaPosition.xMediaInside;
	gThicknessCtrl.Inputs.CheckMedia[2].xCheckFail := gThicknessCtrl.status.MediaPosition.xMediaInside;
	
	//Configuration of the calling to the TestExecution

	IF xTestPrepareDryer THEN
		URIHost := '/WsTest/PrepareDryer';
	ELSIF xTestBeltTests THEN
		URIHost := '/WsTest/BeltTests';
	ELSIF xTestConsents THEN
		URIHost := '/WsTest/ConsentTests';
	ELSIF xTestCleaning THEN
		URIHost := '/WsTest/CleaningTests';
	ELSIF xTestLine THEN
		URIHost := '/WsTest/LineTests';
	END_IF
	
	webClient.enable:=TRUE;
	webClient.send:= xTestPrepareDryer OR xTestBeltTests OR xTestConsents OR xTestCleaning OR xTestLine;
	webClient();
	
	testMonitor.Enable:=TRUE;
	testMonitor();
	gTestsExec.testPassedAsserts := testMonitor.Informational.PassedAssertCounter;
	gTestsExec.testFailedAsserts := testMonitor.Informational.FailedAssertCounter;
	gTestsExec.xSometestFailedAsserts := testFailedAsserts > 0;
	gTestsExec.xAnyTestActive := testMonitor.TestActive;
	gTestsExec.xSimMachine := gDryer.St.HwData.Family = FAMILY_BRAUTOMATIONRUNTIME;
	
	gSimNirAdphos.Parameters.CurrentSpeed := gBelt.states.rCurrentSpeed;
	
	
	IF simMachineTypeEnumCopy<>gSimMachine.Parameters.MachineType THEN
		simMachineType := DINT_TO_INT(gSimMachine.Parameters.MachineType);
	END_IF
	IF simMachineType<>simMachineTypeCopy THEN
		gSimMachine.Parameters.MachineType := simMachineType;
	END_IF

	simMachineTypeCopy := simMachineType;
	simMachineTypeEnumCopy := gSimMachine.Parameters.MachineType;
	
	gDryer.In.xManual_GI := gDryer.In.Buttons.xManual;
	gDryer.In.xZero_GI := gDryer.In.Buttons.xZero;
	gDryer.In.xAuto_GI := gDryer.In.Buttons.xAuto;
	gDryer.In.Sw.xStopBlowers_GI := gDryer.In.Buttons.xStopBlowers;
	
END_PROGRAM

PROGRAM _EXIT
	gBelt; //Just to allow to watch it ;-)
	gEventLogManager; //Just here to be able to watch this var
END_PROGRAM

