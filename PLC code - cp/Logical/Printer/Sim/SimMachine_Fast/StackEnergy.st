
ACTION StackEnergy: 
	
	(* UA_MethodCall - call methode *)
	InputArguments_Energy[0].Name := 'MediaData';
	InputArguments_Energy[0].Value := '::SimMachFst:NewMediaData_Energy';
	OutputArguments_Energy[0].Name := 'Result';
	OutputArguments_Energy[0].Value := '::SimMachFst:MethodResult_Energy';
	UA_MethodCall_Energy(Execute := ExecuteMethodCall_Energy,
		ConnectionHdl := ConnectionHdl_Energy,
		MethodHdl := MethodHdl_Energy,
		Timeout := T#10s,
		InputArguments := InputArguments_Energy,
		OutputArguments := OutputArguments_Energy);
	IF NOT UA_MethodCall_Energy.Busy THEN
		ExecuteMethodCall_Energy := FALSE;
		IF UA_MethodCall_Energy.Done THEN
			NewMediaData_Energy.MediaData.rLength := NewMediaData_Energy.MediaData.rLength + 1;
		END_IF
		IF UA_MethodCall_Energy.Error THEN
			NewMediaData_Energy.MediaData.rDocLength := NewMediaData_Energy.MediaData.rDocLength + 1;
		END_IF
	END_IF

	// Managing the automatic sending. Just Energy when enabled to Dry
	IF NOT gThicknessCtrl.status.xNewMediaStackEnabled OR NOT gThicknessCtrl.parameters.Dry.xDryStack THEN
		RETURN;
	END_IF
		
	IF (gSimMachine.Parameters.Stack.iMediaQuantityToKeepLoaded <= gThicknessCtrl.status.Stack.iNewMediaLoadedL1 + gThicknessCtrl.status.Stack.iNewMediaLoadedL2) THEN
		RETURN;
	END_IF
	
	// Adding a timer to avoid not working the method
	tonNotCallingMethod_Energy.IN := NOT UA_MethodCall_Energy.Busy;
	tonNotCallingMethod_Energy.PT := t#500ms;
	tonNotCallingMethod_Energy();
	IF EDGEPOS(tonNotCallingMethod_Energy.Q) THEN
		ExecuteMethodCall_Energy := TRUE;
	END_IF
	
END_ACTION

ACTION InitialDataForMediaEnergy:
	
	NewMediaData_Energy.MediaData.iLine := 1;
	NewMediaData_Energy.MediaData.xHasWhite := FALSE;
	NewMediaData_Energy.MediaData.rThickness := 3;
	NewMediaData_Energy.MediaData.rMargin := 2;
	NewMediaData_Energy.MediaData.rWidth := 1400;
	NewMediaData_Energy.MediaData.rLength := 1000;
	NewMediaData_Energy.MediaData.rCrossOffset := -700;
	NewMediaData_Energy.MediaData.rDocWidth := 1400;
	NewMediaData_Energy.MediaData.rDocLength := 950;
	NewMediaData_Energy.MediaData.rDocCrossOffset := -700;
	NewMediaData_Energy.MediaData.rDocProcessOffset := 0;
	
	//Just to see some data
	NewMediaData_Energy.Energy.iPower[0,0] := 50;
	NewMediaData_Energy.Energy.iPower[1,0] := 50;
	NewMediaData_Energy.Energy.iPower[0,1] := 50;

END_ACTION

ACTION PreparingMethodEnergyComms: 

	ExecuteConnect_Energy := TRUE;
	
	(* UA_Connect - establish connection to OPC UA Server *)
	SessionConnectInfo_Energy.SecurityMsgMode := UASecurityMsgMode_None;
	SessionConnectInfo_Energy.SecurityPolicy := UASecurityPolicy_None;
	SessionConnectInfo_Energy.TransportProfile := UATP_UATcp;
	SessionConnectInfo_Energy.UserIdentityToken.UserIdentityTokenType := UAUITT_Username;
	SessionConnectInfo_Energy.UserIdentityToken.TokenParam1 := 'PressCore';
	SessionConnectInfo_Energy.UserIdentityToken.TokenParam2 := 'h98o76';
	SessionConnectInfo_Energy.SessionTimeout := T#1m;
	SessionConnectInfo_Energy.MonitorConnection := T#10s;
           
	UA_Connect_Energy(Execute := ExecuteConnect_Energy,
		ServerEndpointUrl := 'opc.tcp://localhost:4840',
		SessionConnectInfo := SessionConnectInfo_Energy,
		Timeout := T#10s);
	IF NOT UA_Connect_Energy.Busy THEN
		ExecuteConnect_Energy := FALSE;
		IF UA_Connect_Energy.Done THEN
			ConnectionHdl_Energy := UA_Connect_Energy.ConnectionHdl;
			////// NEXT
			ExecuteGetnamespaceindex_Energy := TRUE;
		END_IF
		IF UA_Connect_Energy.Error THEN
			ConnectionHdl_Energy := 0;
		END_IF
	END_IF
	
	(* UA_GetNamespaceIndex - read index of required namespace for PVs *) 
	UA_GetNamespaceIndex_Energy(Execute := ExecuteGetnamespaceindex_Energy,
		ConnectionHdl := ConnectionHdl_Energy,
		NamespaceUri := 'http://br-automation.com/OpcUa/PLC/PV/',
	Timeout := T#5s);
	IF NOT UA_GetNamespaceIndex_Energy.Busy THEN
		ExecuteGetnamespaceindex_Energy := FALSE;
		IF UA_GetNamespaceIndex_Energy.Done THEN
			NamespaceIndex_Energy := UA_GetNamespaceIndex_Energy.NamespaceIndex;
			////// NEXT
			ExecuteMethodGetHandle_Energy := TRUE;
		END_IF
		IF UA_GetNamespaceIndex_Energy.Error THEN
			NamespaceIndex_Energy := 0;
		END_IF
	END_IF 	
	
	
	(* UA_MethodGetHandle - get a handle for required methode *)
	ObjectNodeID_Energy.NamespaceIndex := NamespaceIndex_Energy;
	ObjectNodeID_Energy.Identifier := '::ThickPos';
	ObjectNodeID_Energy.IdentifierType := UAIdentifierType_String;
	MethodNodeID_Energy.NamespaceIndex := NamespaceIndex_Energy;
	MethodNodeID_Energy.Identifier := '::ThickPos:LoadNewMediaEnergy';
	MethodNodeID_Energy.IdentifierType := UAIdentifierType_String;
	UA_MethodGetHandle_Energy(Execute := ExecuteMethodGetHandle_Energy,
		ConnectionHdl := ConnectionHdl_Energy,
		ObjectNodeID := ObjectNodeID_Energy,
		MethodNodeID := MethodNodeID_Energy,
		Timeout := T#10s);
	IF NOT UA_MethodGetHandle_Energy.Busy THEN
		ExecuteMethodGetHandle_Energy := FALSE;
		IF UA_MethodGetHandle_Energy.Done THEN
			MethodHdl_Energy := UA_MethodGetHandle_Energy.MethodHdl;
			////// NEXT
			// READY TO COMMUNICATE
		END_IF
		IF UA_MethodGetHandle_Energy.Error THEN
			MethodHdl_Energy := 0;
		END_IF
	END_IF
	
END_ACTION
