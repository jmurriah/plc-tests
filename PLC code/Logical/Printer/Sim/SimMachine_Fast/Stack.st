
ACTION Stack: 
	
	(* UA_MethodCall - call methode *)
	InputArguments_0[0].Name := 'MediaData';
	InputArguments_0[0].Value := '::SimMachFst:NewMediaData_0';
	OutputArguments_0[0].Name := 'Result';
	OutputArguments_0[0].Value := '::SimMachFst:MethodResult_0';
	UA_MethodCall_0(Execute := ExecuteMethodCall_0,
		ConnectionHdl := ConnectionHdl_0,
		MethodHdl := MethodHdl_0,
		Timeout := T#10s,
		InputArguments := InputArguments_0,
		OutputArguments := OutputArguments_0);
	IF NOT UA_MethodCall_0.Busy THEN
		ExecuteMethodCall_0 := FALSE;
		IF UA_MethodCall_0.Done THEN
			NewMediaData_0.rLength := NewMediaData_0.rLength + 1;
		END_IF
		IF UA_MethodCall_0.Error THEN
			NewMediaData_0.rDocLength := NewMediaData_0.rDocLength + 1;
		END_IF
	END_IF

	// Managing the automatic sending. Not sending if enable drying. Sendign Energy then
	IF NOT gThicknessCtrl.status.xNewMediaStackEnabled OR gThicknessCtrl.parameters.Dry.xDryStack THEN
		RETURN;
	END_IF
		
	IF (gSimMachine.Parameters.Stack.iMediaQuantityToKeepLoaded <= gThicknessCtrl.status.Stack.iNewMediaLoadedL1 + gThicknessCtrl.status.Stack.iNewMediaLoadedL2) THEN
		RETURN;
	END_IF
	
	// Adding a timer to avoid not working the method
	tonNotCallingMethod_0.IN := NOT UA_MethodCall_0.Busy;
	tonNotCallingMethod_0.PT := t#500ms;
	tonNotCallingMethod_0();
	IF EDGEPOS(tonNotCallingMethod_0.Q) THEN
		ExecuteMethodCall_0 := TRUE;
	END_IF
	
END_ACTION

ACTION InitialDataForMedia:
	
	NewMediaData_0.iLine := 1;
	NewMediaData_0.xHasWhite := FALSE;
	NewMediaData_0.rThickness := 3;
	NewMediaData_0.rWidth := 1400;
	NewMediaData_0.rLength := 1000;
	NewMediaData_0.rCrossOffset := 0;
	NewMediaData_0.rDocWidth := 1400;
	NewMediaData_0.rDocLength := 950;
	NewMediaData_0.rDocCrossOffset := 0;
	NewMediaData_0.rDocProcessOffset := 0;

END_ACTION

ACTION PreparingMethodComms: 

	ExecuteConnect_0 := TRUE;
	
	(* UA_Connect - establish connection to OPC UA Server *)
	SessionConnectInfo_0.SecurityMsgMode := UASecurityMsgMode_None;
	SessionConnectInfo_0.SecurityPolicy := UASecurityPolicy_None;
	SessionConnectInfo_0.TransportProfile := UATP_UATcp;
	SessionConnectInfo_0.UserIdentityToken.UserIdentityTokenType := UAUITT_Username;
	SessionConnectInfo_0.UserIdentityToken.TokenParam1 := 'PressCore';
	SessionConnectInfo_0.UserIdentityToken.TokenParam2 := 'h98o76';
	SessionConnectInfo_0.SessionTimeout := T#1m;
	SessionConnectInfo_0.MonitorConnection := T#10s;
           
	UA_Connect_0(Execute := ExecuteConnect_0,
		ServerEndpointUrl := 'opc.tcp://localhost:4840',
	SessionConnectInfo := SessionConnectInfo_0,
	Timeout := T#10s);
	IF NOT UA_Connect_0.Busy THEN
		ExecuteConnect_0 := FALSE;
		IF UA_Connect_0.Done THEN
			ConnectionHdl_0 := UA_Connect_0.ConnectionHdl;
			////// NEXT
			ExecuteGetnamespaceindex_0 := TRUE;
		END_IF
		IF UA_Connect_0.Error THEN
			ConnectionHdl_0 := 0;
		END_IF
	END_IF
	
	(* UA_GetNamespaceIndex - read index of required namespace for PVs *) 
	UA_GetNamespaceIndex_0(Execute := ExecuteGetnamespaceindex_0,
		ConnectionHdl := ConnectionHdl_0,
		NamespaceUri := 'http://br-automation.com/OpcUa/PLC/PV/',
	Timeout := T#5s);
	IF NOT UA_GetNamespaceIndex_0.Busy THEN
		ExecuteGetnamespaceindex_0 := FALSE;
		IF UA_GetNamespaceIndex_0.Done THEN
			NamespaceIndex_0 := UA_GetNamespaceIndex_0.NamespaceIndex;
			////// NEXT
			ExecuteMethodGetHandle_0 := TRUE;
		END_IF
		IF UA_GetNamespaceIndex_0.Error THEN
			NamespaceIndex_0 := 0;
		END_IF
	END_IF 	
	
	
	(* UA_MethodGetHandle - get a handle for required methode *)
	ObjectNodeID_0.NamespaceIndex := NamespaceIndex_0;
	ObjectNodeID_0.Identifier := '::ThickPos';
	ObjectNodeID_0.IdentifierType := UAIdentifierType_String;
	MethodNodeID_0.NamespaceIndex := NamespaceIndex_0;
	MethodNodeID_0.Identifier := '::ThickPos:LoadNewMedia';
	MethodNodeID_0.IdentifierType := UAIdentifierType_String;
	UA_MethodGetHandle_0(Execute := ExecuteMethodGetHandle_0,
		ConnectionHdl := ConnectionHdl_0,
		ObjectNodeID := ObjectNodeID_0,
		MethodNodeID := MethodNodeID_0,
		Timeout := T#10s);
	IF NOT UA_MethodGetHandle_0.Busy THEN
		ExecuteMethodGetHandle_0 := FALSE;
		IF UA_MethodGetHandle_0.Done THEN
			MethodHdl_0 := UA_MethodGetHandle_0.MethodHdl;
			////// NEXT
			// READY TO COMMUNICATE
		END_IF
		IF UA_MethodGetHandle_0.Error THEN
			MethodHdl_0 := 0;
		END_IF
	END_IF
	
END_ACTION
