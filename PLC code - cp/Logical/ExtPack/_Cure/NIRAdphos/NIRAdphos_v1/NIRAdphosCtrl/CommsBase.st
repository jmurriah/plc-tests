
ACTION CommsNir1base: 
	
	(* UA_Write - call methode *)
	IndexRange_Nir1.StartIndex := 0;
	IndexRange_Nir1.EndIndex := 47;
	NodeAddInfo_Nir1.AttributeId := UAAI_Value;
	NodeAddInfo_Nir1.IndexRangeCount := 1;
	NodeAddInfo_Nir1.IndexRange[0] := IndexRange_Nir1;
	UA_Write_Nir1(Execute := ExecuteMethodCall_Nir1,
		ConnectionHdl := ConnectionHdl_Nir1,
		NodeHdl := NodeHdl_Nir1,
		NodeAddInfo := NodeAddInfo_Nir1,
		Timeout := T#10s,
		Variable := '::NIRAdphosC.iValues_Nir1'
	);
	IF NOT UA_Write_Nir1.Busy THEN
		ExecuteMethodCall_Nir1 := FALSE;
		IF UA_Write_Nir1.Done THEN
			NewMediaData_Nir1.rLength := NewMediaData_Nir1.rLength + 1;
		END_IF
		IF UA_Write_Nir1.Error THEN
			NewMediaData_Nir1.rDocLength := NewMediaData_Nir1.rDocLength + 1;
		END_IF
	END_IF

//	// Managing the automatic sending. Not sending if enable drying. Sendign Energy then
//	IF NOT gThicknessCtrl.status.xNewMediaStackEnabled OR gThicknessCtrl.parameters.Dry.xDryStack THEN
//		RETURN;
//	END_IF
//		
//	IF (gSimMachine.Parameters.Stack.iMediaQuantityToKeepLoaded <= gThicknessCtrl.status.Stack.iNewMediaLoadedL1 + gThicknessCtrl.status.Stack.iNewMediaLoadedL2) THEN
//		RETURN;
//	END_IF
	
	// Adding a timer to avoid not working the method
//	tonNotCallingMethod_Nir1.IN := NOT UA_Write_Nir1.Busy;
//	tonNotCallingMethod_Nir1.PT := t#4500ms;
//	tonNotCallingMethod_Nir1();
//	IF EDGEPOS(tonNotCallingMethod_Nir1.Q) THEN
//		ExecuteMethodCall_Nir1 := TRUE;
//	END_IF
	
	IF xReConnect THEN
		PreparingMethodCommsNir1base;
	END_IF
	
END_ACTION

ACTION InitialDataForMediaNir1base:
	


END_ACTION

ACTION PreparingMethodCommsNir1base: 

	ExecuteConnect_Nir1 := TRUE;
	
	(* UA_Connect - establish connection to OPC UA Server *)
	SessionConnectInfo_Nir1.SecurityMsgMode := UASecurityMsgMode_None;
	SessionConnectInfo_Nir1.SecurityPolicy := UASecurityPolicy_None;
	SessionConnectInfo_Nir1.TransportProfile := UATP_UATcp;
	SessionConnectInfo_Nir1.UserIdentityToken.UserIdentityTokenType := UAUITT_Anonymous;
	//SessionConnectInfo_Nir1.UserIdentityToken.TokenParam1 := 'PressCore';
	//SessionConnectInfo_Nir1.UserIdentityToken.TokenParam2 := 'h98o76';
	SessionConnectInfo_Nir1.SessionTimeout := T#1m;
	SessionConnectInfo_Nir1.MonitorConnection := T#10s;
           
	UA_Connect_Nir1(Execute := ExecuteConnect_Nir1,
		ServerEndpointUrl := 'opc.tcp://192.168.125.91:4840',
	SessionConnectInfo := SessionConnectInfo_Nir1,
	Timeout := T#10s);
	IF NOT UA_Connect_Nir1.Busy THEN
		ExecuteConnect_Nir1 := FALSE;
		IF UA_Connect_Nir1.Done THEN
			ConnectionHdl_Nir1 := UA_Connect_Nir1.ConnectionHdl;
			////// NEXT
			ExecuteGetnamespaceindex_Nir1 := TRUE;
		END_IF
		IF UA_Connect_Nir1.Error THEN
			ConnectionHdl_Nir1 := 0;
		END_IF
	END_IF
	
	(* UA_GetNamespaceIndex - read index of required namespace for PVs *) 
	UA_GetNamespaceIndex_Nir1(Execute := ExecuteGetnamespaceindex_Nir1,
		ConnectionHdl := ConnectionHdl_Nir1,
		NamespaceUri := 'http://opcfoundation.org/UA/',
		Timeout := T#5s);
	IF NOT UA_GetNamespaceIndex_Nir1.Busy THEN
		ExecuteGetnamespaceindex_Nir1 := FALSE;
		IF UA_GetNamespaceIndex_Nir1.Done THEN
			NamespaceIndex_Nir1 := UA_GetNamespaceIndex_Nir1.NamespaceIndex;
			////// NEXT
			ExecuteMethodGetHandle_Nir1 := TRUE;
		END_IF
		IF UA_GetNamespaceIndex_Nir1.Error THEN
			NamespaceIndex_Nir1 := 0;
		END_IF
	END_IF 	
	
	
	(* UA_NodeGetHandle - get a handle for required methode *)
	ObjectNodeID_Nir1.NamespaceIndex := NamespaceIndex_Nir1;
	IF NodeHdl_Nir1 = 0 THEN
		ObjectNodeID_Nir1.Identifier := '26';
		ObjectNodeID_Nir1.IdentifierType := UAIdentifierType_Numeric;
	END_IF


	//MethodNodeID_Nir1.NamespaceIndex := NamespaceIndex_Nir1;
	//MethodNodeID_Nir1.Identifier := '::ThickPos:LoadNewMedia';
	//MethodNodeID_Nir1.IdentifierType := UAIdentifierType_String;
	UA_NodeGetHandle_Nir1(Execute := ExecuteMethodGetHandle_Nir1,
		ConnectionHdl := ConnectionHdl_Nir1,
		NodeID := ObjectNodeID_Nir1,
		//MethodNodeID := MethodNodeID_Nir1,
		Timeout := T#10s);
	IF NOT UA_NodeGetHandle_Nir1.Busy THEN
		ExecuteMethodGetHandle_Nir1 := FALSE;
		IF UA_NodeGetHandle_Nir1.Done THEN
			NodeHdl_Nir1 := UA_NodeGetHandle_Nir1.NodeHdl;
			xReConnect := FALSE;
			////// NEXT
			// READY TO COMMUNICATE
		END_IF
		IF UA_NodeGetHandle_Nir1.Error THEN
			NodeHdl_Nir1 := 0;
			xReConnect := FALSE;
		END_IF
	END_IF
	
	iTimes := iTimes + 1;
	
END_ACTION
