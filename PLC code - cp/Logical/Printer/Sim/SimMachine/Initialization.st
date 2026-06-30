
ACTION Initialization: 

	gMachine.In.ProductDetect.pPDSignalSensorL1 := ADR(gSimMachine.Signals.xProductDetectL1);
	gMachine.In.ProductDetect.pPDSignalSensorL2 := ADR(gSimMachine.Signals.xProductDetectL2);
	gMachine.In.ProductDetect.pPDCarriageSignalL1 := ADR(gSimMachine.Signals.xPDCarriageSignalL1);
	gMachine.In.ProductDetect.pPDCarriageSignalL2 := ADR(gSimMachine.Signals.xPDCarriageSignalL2);
	
	FOR iSimIndex:=1 TO MAX_LAST_BLOCK DO
		gBlock[iSimIndex].In.xAirVenturiOK:=TRUE;
		gBlock[iSimIndex].In.xSiUnitModuleOk:=TRUE;
		gBlock[iSimIndex].In.xDriveProtectionOK:=TRUE;
		gBlock[iSimIndex].In.xDifferentialOK:=TRUE;
		gBlock[iSimIndex].In.Safety.xRearSafetyOK:=TRUE;
		gBlock[iSimIndex].In.Safety.xSafetyOK:=TRUE;
		gBlock[iSimIndex].In.xModuleTemp01Ok:=TRUE;
		gBlock[iSimIndex].In.xModuleTemp02Ok:=TRUE;
		gBlock[iSimIndex].In.xModuleTemp03Ok:=TRUE;
		gBlock[iSimIndex].In.xTrayIn:=TRUE;
		gBlock[iSimIndex].In.Safety.xCurtainEnable01:=TRUE;
		gBlock[iSimIndex].In.Safety.xCurtainEnable02:=TRUE;
		gBlock[iSimIndex].In.Safety.xFrontEStopOK:=TRUE;
		gBlock[iSimIndex].In.Safety.xRearEStopOK:=TRUE;
		gBlock[iSimIndex].In.Safety.xFrontSafetyOK:=TRUE;
		gBlock[iSimIndex].In.xHeaterDcOkBusBar1:=TRUE;
		gBlock[iSimIndex].In.xHeaterDcOkBusBar2:=TRUE;
		FOR iIndexPsu:=1 TO gBlock[iSimIndex].parameters.Hw.iNumHeaterPSU DO 
			gBlock[iSimIndex].In.xHeaterDcOkPsu[iIndexPsu]:=TRUE;
			gBlock[iSimIndex].In.xHeaterAcOkPsu[iIndexPsu]:=TRUE;
		END_FOR
		
		FOR iIndexPsu:=1 TO gBlock[iSimIndex].parameters.Hw.iNumPrintheadsPSU DO 
			gBlock[iSimIndex].In.xPrintHeadPSU[iIndexPsu]:=TRUE;
		END_FOR
	END_FOR

	FOR iSimIndex:=1 TO MAX_LAST_BLOCK DO
		gIcla[iSimIndex].Status.xModuleOK:=TRUE;
	END_FOR	
	
	gPhotoCells.status.xBackModuleOk := TRUE;
	gPhotoCells.status.xFrontModuleOk := TRUE;
	
	gMachine.In.xAirSupply:=TRUE;
	gMachine.In.x24Vdc:=TRUE;
	
	//We need to write over the permanent var because is loaded during machine init
	//gPermanentBelt.xDriveProtectionOK:=TRUE;
	gBelt.parameters.xDriveProtectionOK:=TRUE;
	
	webClient.option := httpOPTION_HTTP_11;
	webClient.pHost := ADR(URLHost);
	webClient.pUri := ADR(URIHost);
	webClient.hostPort := 82;
	webClient.method := httpMETHOD_GET;
	
	webClient.pResponseHeader := ADR(ResponseHeader);
	webClient.pResponseData := ADR(ResponseData);
	webClient.responseDataSize := SIZEOF(ResponseData);
	webClient.pRequestData := ADR(RequestData);
	webClient.requestDataLen := SIZEOF(RequestData);

	gInverterSignalsPowerLink[1].In.ModuleOk := TRUE;
	gInverterSignalsPowerLink[2].In.ModuleOk := TRUE;
	gInverterSignalsPowerLink[3].In.ModuleOk := TRUE;
	gInverterSignalsPowerLink[4].In.ModuleOk := TRUE;
	gInverterSignalsCanOpen[1].In.ModuleOk := TRUE;
	gInverterSignalsCanOpen[2].In.ModuleOk := TRUE;
	gInverterSignalsCanOpen[3].In.ModuleOk := TRUE;
	gInverterSignalsCanOpen[4].In.ModuleOk := TRUE;
	gInverterSignalsPowerLinkABB[1].In.ModuleOk := TRUE;
	gInverterSignalsPowerLinkABB[2].In.ModuleOk := TRUE;
	gInverterSignalsPowerLinkABB[3].In.ModuleOk := TRUE;
	gInverterSignalsPowerLinkABB[4].In.ModuleOk := TRUE;
	
	gAxisInverter[1].ElecSignals.In.xBreakerOK := TRUE;
	gAxisInverter[2].ElecSignals.In.xBreakerOK := TRUE;
	gAxisInverter[3].ElecSignals.In.xBreakerOK := TRUE;
	gAxisInverter[4].ElecSignals.In.xBreakerOK := TRUE;
	
	gNonCrash[1].Inputs.xDiffContacOk := TRUE;
	gNonCrash[1].Parameters.DriveUnit.LinealPerimeter.Perimeter:=500;
	gNonCrash[2].Inputs.xDiffContacOk := TRUE;
	gNonCrash[2].Parameters.DriveUnit.LinealPerimeter.Perimeter:=500;
	
	// ###################################
	// END OF INIT CODE

END_ACTION
