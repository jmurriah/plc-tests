
ACTION initComms:
	
	(* UA_Connect - establish connection to OPC UA Server *)

	IF NOT UA_Connect_PLC.Done THEN
	
		SessionConnectInfo_PLC.SecurityMsgMode := UASecurityMsgMode_None;
		SessionConnectInfo_PLC.SecurityPolicy := UASecurityPolicy_None;
		SessionConnectInfo_PLC.TransportProfile := UATP_UATcp;
		SessionConnectInfo_PLC.UserIdentityToken.UserIdentityTokenType := UAUITT_Username;
		SessionConnectInfo_PLC.UserIdentityToken.TokenParam1 := 'PressCore';
		SessionConnectInfo_PLC.UserIdentityToken.TokenParam2 := 'h98o76';
		SessionConnectInfo_PLC.SessionTimeout := T#1m;
		SessionConnectInfo_PLC.MonitorConnection := T#10s;
	          
		UA_Connect_PLC(Execute := NOT UA_Connect_PLC.Error ,
			ServerEndpointUrl := 'opc.tcp://192.168.127.10:4840',
		SessionConnectInfo := SessionConnectInfo_PLC,
		Timeout := T#10s);
		IF NOT UA_Connect_PLC.Busy THEN
			ExecuteConnect_PLC := FALSE;
			IF UA_Connect_PLC.Done THEN
				ConnectionHdl_PLC := UA_Connect_PLC.ConnectionHdl;
				////// NEXT
				ExecuteGetnamespaceindex_PLC := TRUE;
			END_IF
			IF UA_Connect_PLC.Error THEN
				ConnectionHdl_PLC := 0;
			END_IF
		END_IF
	END_IF

	(* UA_GetNamespaceIndex - read index of required namespace for PVs *)
	
	IF NOT UA_GetNamespaceIndex_PLC.Done THEN
		
		UA_GetNamespaceIndex_PLC(Execute := ExecuteGetnamespaceindex_PLC,
			ConnectionHdl := ConnectionHdl_PLC,
			NamespaceUri := 'http://br-automation.com/OpcUa/PLC/PV/',
		Timeout := T#5s);
		IF NOT UA_GetNamespaceIndex_PLC.Busy THEN
			IF UA_GetNamespaceIndex_PLC.Done THEN
				NamespaceIndex_PLC := UA_GetNamespaceIndex_PLC.NamespaceIndex;
				////// NEXT
				ExecuteMethodGetHandle_PLC := TRUE;
			END_IF
			IF UA_GetNamespaceIndex_PLC.Error THEN
				NamespaceIndex_PLC := 0;
			END_IF
		END_IF 	
		
		ObjectNodeID_PLC.NamespaceIndex := NamespaceIndex_PLC;
		ObjectNodeID_PLC.Identifier := '::PlcDiagnos';
		ObjectNodeID_PLC.IdentifierType := UAIdentifierType_String;
	END_IF
		
END_ACTION 

ACTION getMethodHandles:

	(* UA_MethodGetHandle - get a handle for required methode *)//PLCopen status code

	// getMachineConfiguration
	IF NOT UA_MethodGetHandle_getMachConf.Done THEN
		
		MethodNodeID_getMachConf.NamespaceIndex := NamespaceIndex_PLC;
		MethodNodeID_getMachConf.Identifier := '::PlcDiagnos:getMachineConfigPars';
		MethodNodeID_getMachConf.IdentifierType := UAIdentifierType_String;
		UA_MethodGetHandle_getMachConf(Execute := NOT UA_MethodGetHandle_getMachConf.Error,
		ConnectionHdl := ConnectionHdl_PLC,
		ObjectNodeID := ObjectNodeID_PLC,
		MethodNodeID := MethodNodeID_getMachConf,
		Timeout := T#10s);
		IF NOT UA_MethodGetHandle_getMachConf.Busy THEN
			ExecuteMethodGetHandle_PLC := FALSE;
			IF UA_MethodGetHandle_getMachConf.Done THEN
				MethodHdl_getMachConf := UA_MethodGetHandle_getMachConf.MethodHdl;
				////// NEXT
				// READY TO COMMUNICATE
			END_IF
			IF UA_MethodGetHandle_getMachConf.Error THEN
				MethodHdl_getMachConf := 0;
			END_IF
		END_IF
	END_IF
	
	//getModuleOk
	IF NOT UA_MethodGetHandle_getModuleOk.Done THEN 
		
		MethodNodeID_getModuleOk.NamespaceIndex := NamespaceIndex_PLC;
		MethodNodeID_getModuleOk.Identifier := '::PlcDiagnos:getCardModuleOk';
		MethodNodeID_getModuleOk.IdentifierType := UAIdentifierType_String;
		UA_MethodGetHandle_getModuleOk(Execute := NOT UA_MethodGetHandle_getModuleOk.Error,
		ConnectionHdl := ConnectionHdl_PLC,
		ObjectNodeID := ObjectNodeID_PLC,
		MethodNodeID := MethodNodeID_getModuleOk,
		Timeout := T#10s);
		IF NOT UA_MethodGetHandle_getModuleOk.Busy THEN
			IF UA_MethodGetHandle_getModuleOk.Done THEN
				MethodHdl_getModuleOk := UA_MethodGetHandle_getModuleOk.MethodHdl;
				////// NEXT
				// READY TO COMMUNICATE
			END_IF
			IF UA_MethodGetHandle_getModuleOk.Error THEN
				MethodHdl_getModuleOk := 0;
			END_IF
		END_IF
	END_IF
	
	//getDI_1
	IF NOT UA_MethodGetHandle_getDI_1.Done THEN 
		
		MethodNodeID_getDI_1.NamespaceIndex := NamespaceIndex_PLC;
		MethodNodeID_getDI_1.Identifier := '::PlcDiagnos:getDigitalInputs_1';
		MethodNodeID_getDI_1.IdentifierType := UAIdentifierType_String;
		UA_MethodGetHandle_getDI_1(Execute := NOT UA_MethodGetHandle_getDI_1.Error,
		ConnectionHdl := ConnectionHdl_PLC,
		ObjectNodeID := ObjectNodeID_PLC,
		MethodNodeID := MethodNodeID_getDI_1,
		Timeout := T#10s);
		IF NOT UA_MethodGetHandle_getDI_1.Busy THEN
			IF UA_MethodGetHandle_getDI_1.Done THEN
				MethodHdl_getDI_1 := UA_MethodGetHandle_getDI_1.MethodHdl;
				////// NEXT
				// READY TO COMMUNICATE
			END_IF
			IF UA_MethodGetHandle_getDI_1.Error THEN
				MethodHdl_getDI_1 := 0;
			END_IF
		END_IF
	END_IF
	
	//getDO_1
	IF NOT UA_MethodGetHandle_getDO_1.Done THEN 
		
		MethodNodeID_getDO_1.NamespaceIndex := NamespaceIndex_PLC;
		MethodNodeID_getDO_1.Identifier := '::PlcDiagnos:getDigitalOutputs_1';
		MethodNodeID_getDO_1.IdentifierType := UAIdentifierType_String;
		UA_MethodGetHandle_getDO_1(Execute := NOT UA_MethodGetHandle_getDO_1.Error,
		ConnectionHdl := ConnectionHdl_PLC,
		ObjectNodeID := ObjectNodeID_PLC,
		MethodNodeID := MethodNodeID_getDO_1,
		Timeout := T#10s);
		IF NOT UA_MethodGetHandle_getDO_1.Busy THEN
			IF UA_MethodGetHandle_getDO_1.Done THEN
				MethodHdl_getDO_1 := UA_MethodGetHandle_getDO_1.MethodHdl;
				////// NEXT
				// READY TO COMMUNICATE
			END_IF
			IF UA_MethodGetHandle_getDO_1.Error THEN
				MethodHdl_getDO_1 := 0;
			END_IF
		END_IF
	END_IF
	
	//getAI_1
	IF NOT UA_MethodGetHandle_getAI_1.Done THEN 
		
		MethodNodeID_getAI_1.NamespaceIndex := NamespaceIndex_PLC;
		MethodNodeID_getAI_1.Identifier := '::PlcDiagnos:getAnalogInputs_1';
		MethodNodeID_getAI_1.IdentifierType := UAIdentifierType_String;
		UA_MethodGetHandle_getAI_1(Execute := NOT UA_MethodGetHandle_getAI_1.Error,
		ConnectionHdl := ConnectionHdl_PLC,
		ObjectNodeID := ObjectNodeID_PLC,
		MethodNodeID := MethodNodeID_getAI_1,
		Timeout := T#10s);
		IF NOT UA_MethodGetHandle_getAI_1.Busy THEN
			IF UA_MethodGetHandle_getAI_1.Done THEN
				MethodHdl_getAI_1 := UA_MethodGetHandle_getAI_1.MethodHdl;
				////// NEXT
				// READY TO COMMUNICATE
			END_IF
			IF UA_MethodGetHandle_getAI_1.Error THEN
				MethodHdl_getAI_1 := 0;
			END_IF
		END_IF
	END_IF
	
	//getAO_1
	IF NOT UA_MethodGetHandle_getAO_1.Done THEN 
		
		MethodNodeID_getAO_1.NamespaceIndex := NamespaceIndex_PLC;
		MethodNodeID_getAO_1.Identifier := '::PlcDiagnos:getAnalogOutputs_1';
		MethodNodeID_getAO_1.IdentifierType := UAIdentifierType_String;
		UA_MethodGetHandle_getAO_1(Execute := NOT UA_MethodGetHandle_getAO_1.Error,
		ConnectionHdl := ConnectionHdl_PLC,
		ObjectNodeID := ObjectNodeID_PLC,
		MethodNodeID := MethodNodeID_getAO_1,
		Timeout := T#10s);
		IF NOT UA_MethodGetHandle_getAO_1.Busy THEN
			IF UA_MethodGetHandle_getAO_1.Done THEN
				MethodHdl_getAO_1 := UA_MethodGetHandle_getAO_1.MethodHdl;
				////// NEXT
				// READY TO COMMUNICATE
			END_IF
			IF UA_MethodGetHandle_getAO_1.Error THEN
				MethodHdl_getAO_1 := 0;
			END_IF
		END_IF
	END_IF
	
	//getAT_1
	IF NOT UA_MethodGetHandle_getAT_1.Done THEN 
		
		MethodNodeID_getAT_1.NamespaceIndex := NamespaceIndex_PLC;
		MethodNodeID_getAT_1.Identifier := '::PlcDiagnos:getTemp_1';
		MethodNodeID_getAT_1.IdentifierType := UAIdentifierType_String;
		UA_MethodGetHandle_getAT_1(Execute := NOT UA_MethodGetHandle_getAT_1.Error,
		ConnectionHdl := ConnectionHdl_PLC,
		ObjectNodeID := ObjectNodeID_PLC,
		MethodNodeID := MethodNodeID_getAT_1,
		Timeout := T#10s);
		IF NOT UA_MethodGetHandle_getAT_1.Busy THEN
			IF UA_MethodGetHandle_getAT_1.Done THEN
				MethodHdl_getAT_1 := UA_MethodGetHandle_getAT_1.MethodHdl;
				////// NEXT
				// READY TO COMMUNICATE
			END_IF
			IF UA_MethodGetHandle_getAT_1.Error THEN
				MethodHdl_getAT_1 := 0;
			END_IF
		END_IF
	END_IF
	
	//getDI_2
	IF NOT UA_MethodGetHandle_getDI_2.Done THEN 
		
		MethodNodeID_getDI_2.NamespaceIndex := NamespaceIndex_PLC;
		MethodNodeID_getDI_2.Identifier := '::PlcDiagnos:getDigitalInputs_2';
		MethodNodeID_getDI_2.IdentifierType := UAIdentifierType_String;
		UA_MethodGetHandle_getDI_2(Execute := NOT UA_MethodGetHandle_getDI_2.Error,
		ConnectionHdl := ConnectionHdl_PLC,
		ObjectNodeID := ObjectNodeID_PLC,
		MethodNodeID := MethodNodeID_getDI_2,
		Timeout := T#10s);
		IF NOT UA_MethodGetHandle_getDI_2.Busy THEN
			IF UA_MethodGetHandle_getDI_2.Done THEN
				MethodHdl_getDI_2 := UA_MethodGetHandle_getDI_2.MethodHdl;
				////// NEXT
				// READY TO COMMUNICATE
			END_IF
			IF UA_MethodGetHandle_getDI_2.Error THEN
				MethodHdl_getDI_2 := 0;
			END_IF
		END_IF
	END_IF
	
	//getDO_2
	IF NOT UA_MethodGetHandle_getDO_2.Done THEN 
		
		MethodNodeID_getDO_2.NamespaceIndex := NamespaceIndex_PLC;
		MethodNodeID_getDO_2.Identifier := '::PlcDiagnos:getDigitalOutputs_2';
		MethodNodeID_getDO_2.IdentifierType := UAIdentifierType_String;
		UA_MethodGetHandle_getDO_2(Execute := NOT UA_MethodGetHandle_getDO_2.Error,
		ConnectionHdl := ConnectionHdl_PLC,
		ObjectNodeID := ObjectNodeID_PLC,
		MethodNodeID := MethodNodeID_getDO_2,
		Timeout := T#10s);
		IF NOT UA_MethodGetHandle_getDO_2.Busy THEN
			IF UA_MethodGetHandle_getDO_2.Done THEN
				MethodHdl_getDO_2 := UA_MethodGetHandle_getDO_2.MethodHdl;
				////// NEXT
				// READY TO COMMUNICATE
			END_IF
			IF UA_MethodGetHandle_getDO_2.Error THEN
				MethodHdl_getDO_2 := 0;
			END_IF
		END_IF
	END_IF
	
	//getAI_2
	IF NOT UA_MethodGetHandle_getAI_2.Done THEN 
		
		MethodNodeID_getAI_2.NamespaceIndex := NamespaceIndex_PLC;
		MethodNodeID_getAI_2.Identifier := '::PlcDiagnos:getAnalogInputs_2';
		MethodNodeID_getAI_2.IdentifierType := UAIdentifierType_String;
		UA_MethodGetHandle_getAI_2(Execute := NOT UA_MethodGetHandle_getAI_2.Error,
		ConnectionHdl := ConnectionHdl_PLC,
		ObjectNodeID := ObjectNodeID_PLC,
		MethodNodeID := MethodNodeID_getAI_2,
		Timeout := T#10s);
		IF NOT UA_MethodGetHandle_getAI_2.Busy THEN
			IF UA_MethodGetHandle_getAI_2.Done THEN
				MethodHdl_getAI_2 := UA_MethodGetHandle_getAI_2.MethodHdl;
				////// NEXT
				// READY TO COMMUNICATE
			END_IF
			IF UA_MethodGetHandle_getAI_2.Error THEN
				MethodHdl_getAI_2 := 0;
			END_IF
		END_IF
	END_IF
	
	//getAO_2
	IF NOT UA_MethodGetHandle_getAO_2.Done THEN 
		
		MethodNodeID_getAO_2.NamespaceIndex := NamespaceIndex_PLC;
		MethodNodeID_getAO_2.Identifier := '::PlcDiagnos:getAnalogOutputs_2';
		MethodNodeID_getAO_2.IdentifierType := UAIdentifierType_String;
		UA_MethodGetHandle_getAO_2(Execute := NOT UA_MethodGetHandle_getAO_2.Error,
		ConnectionHdl := ConnectionHdl_PLC,
		ObjectNodeID := ObjectNodeID_PLC,
		MethodNodeID := MethodNodeID_getAO_2,
		Timeout := T#10s);
		IF NOT UA_MethodGetHandle_getAO_2.Busy THEN
			IF UA_MethodGetHandle_getAO_2.Done THEN
				MethodHdl_getAO_2 := UA_MethodGetHandle_getAO_2.MethodHdl;
				////// NEXT
				// READY TO COMMUNICATE
			END_IF
			IF UA_MethodGetHandle_getAO_2.Error THEN
				MethodHdl_getAO_2 := 0;
			END_IF
		END_IF
	END_IF
	
	//getAT_2
	IF NOT UA_MethodGetHandle_getAT_2.Done THEN 
		
		MethodNodeID_getAT_2.NamespaceIndex := NamespaceIndex_PLC;
		MethodNodeID_getAT_2.Identifier := '::PlcDiagnos:getTemp_2';
		MethodNodeID_getAT_2.IdentifierType := UAIdentifierType_String;
		UA_MethodGetHandle_getAT_2(Execute := NOT UA_MethodGetHandle_getAT_2.Error,
		ConnectionHdl := ConnectionHdl_PLC,
		ObjectNodeID := ObjectNodeID_PLC,
		MethodNodeID := MethodNodeID_getAT_2,
		Timeout := T#10s);
		IF NOT UA_MethodGetHandle_getAT_2.Busy THEN
			IF UA_MethodGetHandle_getAT_2.Done THEN
				MethodHdl_getAT_2 := UA_MethodGetHandle_getAT_2.MethodHdl;
				////// NEXT
				// READY TO COMMUNICATE
			END_IF
			IF UA_MethodGetHandle_getAT_2.Error THEN
				MethodHdl_getAT_2 := 0;
			END_IF
		END_IF
	END_IF
	
	//getPhotoCells
	IF NOT UA_MethodGetHandle_getPhotoCells.Done THEN 
		
		MethodNodeID_getPhotoCells.NamespaceIndex := NamespaceIndex_PLC;
		MethodNodeID_getPhotoCells.Identifier := '::PlcDiagnos:getPhotoCells';
		MethodNodeID_getPhotoCells.IdentifierType := UAIdentifierType_String;
		UA_MethodGetHandle_getPhotoCells(Execute := NOT UA_MethodGetHandle_getPhotoCells.Error ,
		ConnectionHdl := ConnectionHdl_PLC,
		ObjectNodeID := ObjectNodeID_PLC,
		MethodNodeID := MethodNodeID_getPhotoCells,
		Timeout := T#15s);
		IF NOT UA_MethodGetHandle_getPhotoCells.Busy THEN
			IF UA_MethodGetHandle_getPhotoCells.Done THEN
				MethodHdl_getPhotoCells := UA_MethodGetHandle_getPhotoCells.MethodHdl;
				////// NEXT
				// READY TO COMMUNICATE
			END_IF
			IF UA_MethodGetHandle_getPhotoCells.Error THEN
				MethodHdl_getPhotoCells := 0;
			END_IF
		END_IF
	END_IF
	
	//getCuringBar
	
	IF NOT UA_MethodGetHandle_getCuringBar.Done THEN 
		
		MethodNodeID_getCuringBar.NamespaceIndex := NamespaceIndex_PLC;
		MethodNodeID_getCuringBar.Identifier := '::PlcDiagnos:getCuringBar';
		MethodNodeID_getCuringBar.IdentifierType := UAIdentifierType_String;
		UA_MethodGetHandle_getCuringBar(Execute := NOT UA_MethodGetHandle_getCuringBar.Error,
		ConnectionHdl := ConnectionHdl_PLC,
		ObjectNodeID := ObjectNodeID_PLC,
		MethodNodeID := MethodNodeID_getCuringBar,
		Timeout := T#15s);
		IF NOT UA_MethodGetHandle_getCuringBar.Busy THEN
			IF UA_MethodGetHandle_getCuringBar.Done THEN
				MethodHdl_getCuringBar := UA_MethodGetHandle_getCuringBar.MethodHdl;
				////// NEXT
				// READY TO COMMUNICATE
			END_IF
			IF UA_MethodGetHandle_getCuringBar.Error THEN
				MethodHdl_getCuringBar := 0;
			END_IF
		END_IF
	END_IF
	
	//getBlock
	
	IF NOT UA_MethodGetHandle_getBlock.Done THEN 
		
		MethodNodeID_getBlock.NamespaceIndex := NamespaceIndex_PLC;
		MethodNodeID_getBlock.Identifier := '::PlcDiagnos:getBlock';
		MethodNodeID_getBlock.IdentifierType := UAIdentifierType_String;
		UA_MethodGetHandle_getBlock(Execute := NOT UA_MethodGetHandle_getBlock.Error,
		ConnectionHdl := ConnectionHdl_PLC,
		ObjectNodeID := ObjectNodeID_PLC,
		MethodNodeID := MethodNodeID_getBlock,
		Timeout := T#15s);
		IF NOT UA_MethodGetHandle_getBlock.Busy THEN
			IF UA_MethodGetHandle_getBlock.Done THEN
				MethodHdl_getBlock := UA_MethodGetHandle_getBlock.MethodHdl;
				////// NEXT
				// READY TO COMMUNICATE
			END_IF
			IF UA_MethodGetHandle_getBlock.Error THEN
				MethodHdl_getBlock := 0;
			END_IF
		END_IF
	END_IF
	
	
	//getTransVacuum
	
	IF NOT UA_MethodGetHandle_getTransV.Done THEN 
		
		MethodNodeID_getTransV.NamespaceIndex := NamespaceIndex_PLC;
		MethodNodeID_getTransV.Identifier := '::PlcDiagnos:getTransVacuum';
		MethodNodeID_getTransV.IdentifierType := UAIdentifierType_String;
		UA_MethodGetHandle_getTransV(Execute := NOT UA_MethodGetHandle_getTransV.Error,
		ConnectionHdl := ConnectionHdl_PLC,
		ObjectNodeID := ObjectNodeID_PLC,
		MethodNodeID := MethodNodeID_getTransV,
		Timeout := T#15s);
		IF NOT UA_MethodGetHandle_getTransV.Busy THEN
			IF UA_MethodGetHandle_getTransV.Done THEN
				MethodHdl_getTransV := UA_MethodGetHandle_getTransV.MethodHdl;
				////// NEXT
				// READY TO COMMUNICATE
			END_IF
			IF UA_MethodGetHandle_getTransV.Error THEN
				MethodHdl_getTransV := 0;
			END_IF
		END_IF
	END_IF
	
END_ACTION

	
ACTION getMachineConfiguration:

IF UA_MethodGetHandle_getMachConf.Done THEN
		
		InputArguments_getMachConf[0].Name := 'Input';
		InputArguments_getMachConf[0].Value := '::SimDiagnos:genericMethodInput';
		OutputArguments_getMachConf[0].Name := 'MachinePt';
		OutputArguments_getMachConf[0].Value := '::SimDiagnos:Cards_MachinePt';
		UA_MethodCall_getMachConf(Execute := ExecuteMethodCall_getMachConf,
			ConnectionHdl := ConnectionHdl_PLC,
			MethodHdl := MethodHdl_getMachConf,
			Timeout := T#10s,
		InputArguments := InputArguments_getMachConf,
		OutputArguments := OutputArguments_getMachConf);
		
		IF NOT UA_MethodCall_getMachConf.Busy AND NOT UA_MethodCall_getMachConf.Done THEN
			ExecuteMethodCall_getMachConf := TRUE;		
		END_IF
		
		IF UA_MethodCall_getMachConf.Done OR UA_MethodCall_getMachConf.Error THEN
			ExecuteMethodCall_getMachConf := FALSE;
		END_IF
	END_IF
	
	gPlcDiagMC_Pt := Cards_MachinePt;	
	
END_ACTION

ACTION getModuleOk:
	
	IF UA_MethodGetHandle_getModuleOk.Done THEN 
		
		InputArguments_getModuleOk[0].Name := 'Input';
		InputArguments_getModuleOk[0].Value := '::SimDiagnos:genericMethodInput';
		OutputArguments_getModuleOk[0].Name := 'CardsModuleOK';
		OutputArguments_getModuleOk[0].Value := '::SimDiagnos:Cards_ModuleOk';
		UA_MethodCall_getModuleOk(Execute := ExecuteMethodCall_getModuleOk,
			ConnectionHdl := ConnectionHdl_PLC,
			MethodHdl := MethodHdl_getModuleOk,
			Timeout := T#10s,
		InputArguments := InputArguments_getModuleOk,
		OutputArguments := OutputArguments_getModuleOk);
		
		IF NOT UA_MethodCall_getModuleOk.Busy AND NOT UA_MethodCall_getModuleOk.Done THEN
			ExecuteMethodCall_getModuleOk := TRUE;		
		END_IF
		
		IF UA_MethodCall_getModuleOk.Done OR UA_MethodCall_getModuleOk.Error THEN
			ExecuteMethodCall_getModuleOk := FALSE;
		END_IF
		
	END_IF
	
END_ACTION 

ACTION getDI_1:
	
	IF UA_MethodGetHandle_getDI_1.Done THEN 
		
		InputArguments_getDI_1[0].Name := 'iCardIndexDI';
		InputArguments_getDI_1[0].Value := '::SimDiagnos:Card_iCardIndex_1';
		OutputArguments_getDI_1[0].Name := 'DIArray';
		OutputArguments_getDI_1[0].Value := '::SimDiagnos:Cards_aDI_1';
		UA_MethodCall_getDI_1(Execute := ExecuteMethodCall_getDI_1,
			ConnectionHdl := ConnectionHdl_PLC,
			MethodHdl := MethodHdl_getDI_1,
			Timeout := T#10s,
		InputArguments := InputArguments_getDI_1,
		OutputArguments := OutputArguments_getDI_1);
		
		IF NOT UA_MethodCall_getDI_1.Busy AND NOT UA_MethodCall_getDI_1.Done THEN
			ExecuteMethodCall_getDI_1 := TRUE;		
		END_IF
		
		IF UA_MethodCall_getDI_1.Done OR UA_MethodCall_getDI_1.Error THEN
			ExecuteMethodCall_getDI_1 := FALSE;
		END_IF
		
		Cards_Mapping[Card_iCardIndex_1].DInput := Cards_aDI_1;
		
	END_IF
	
END_ACTION 

ACTION getDO_1:
	
	IF UA_MethodGetHandle_getDO_1.Done THEN 
		
		InputArguments_getDO_1[0].Name := 'iCardIndexDO';
		InputArguments_getDO_1[0].Value := '::SimDiagnos:Card_iCardIndex_1';
		OutputArguments_getDO_1[0].Name := 'DOArray';
		OutputArguments_getDO_1[0].Value := '::SimDiagnos:Cards_aDO_1';
		UA_MethodCall_getDO_1(Execute := ExecuteMethodCall_getDO_1,
			ConnectionHdl := ConnectionHdl_PLC,
			MethodHdl := MethodHdl_getDO_1,
			Timeout := T#10s,
		InputArguments := InputArguments_getDO_1,
		OutputArguments := OutputArguments_getDO_1);
		
		IF NOT UA_MethodCall_getDO_1.Busy AND NOT UA_MethodCall_getDO_1.Done THEN
			ExecuteMethodCall_getDO_1 := TRUE;		
		END_IF
		
		IF UA_MethodCall_getDO_1.Done OR UA_MethodCall_getDO_1.Error THEN
			ExecuteMethodCall_getDO_1 := FALSE;
		END_IF
		
		Cards_Mapping[Card_iCardIndex_1].AOutput := Cards_aAO_1;
		
	END_IF
	
END_ACTION 

ACTION getAI_1:
	
	IF UA_MethodGetHandle_getAI_1.Done THEN 
		
		InputArguments_getAI_1[0].Name := 'iCardIndexAI';
		InputArguments_getAI_1[0].Value := '::SimDiagnos:Card_iCardIndex_1';
		OutputArguments_getAI_1[0].Name := 'AIArray';
		OutputArguments_getAI_1[0].Value := '::SimDiagnos:Cards_aAI_1';
		UA_MethodCall_getAI_1(Execute := ExecuteMethodCall_getAI_1,
			ConnectionHdl := ConnectionHdl_PLC,
			MethodHdl := MethodHdl_getAI_1,
			Timeout := T#10s,
		InputArguments := InputArguments_getAI_1,
		OutputArguments := OutputArguments_getAI_1);
		
		IF NOT UA_MethodCall_getAI_1.Busy AND NOT UA_MethodCall_getAI_1.Done THEN
			ExecuteMethodCall_getAI_1 := TRUE;		
		END_IF
		
		IF UA_MethodCall_getAI_1.Done OR UA_MethodCall_getAI_1.Error THEN
			ExecuteMethodCall_getAI_1 := FALSE;
		END_IF
		
		Cards_Mapping[Card_iCardIndex_1].AInput := Cards_aAI_1;
		
	END_IF
	
END_ACTION 

ACTION getAO_1:
	
	IF UA_MethodGetHandle_getAO_1.Done THEN 
		
		InputArguments_getAO_1[0].Name := 'iCardIndexAO';
		InputArguments_getAO_1[0].Value := '::SimDiagnos:Card_iCardIndex_1';
		OutputArguments_getAO_1[0].Name := 'AOArray';
		OutputArguments_getAO_1[0].Value := '::SimDiagnos:Cards_aAO_1';
		UA_MethodCall_getAO_1(Execute := ExecuteMethodCall_getAO_1,
			ConnectionHdl := ConnectionHdl_PLC,
			MethodHdl := MethodHdl_getAO_1,
			Timeout := T#10s,
		InputArguments := InputArguments_getAO_1,
		OutputArguments := OutputArguments_getAO_1);
		
		IF NOT UA_MethodCall_getAO_1.Busy AND NOT UA_MethodCall_getAO_1.Done THEN
			ExecuteMethodCall_getAO_1 := TRUE;		
		END_IF
		
		IF UA_MethodCall_getAO_1.Done OR UA_MethodCall_getAO_1.Error THEN
			ExecuteMethodCall_getAO_1 := FALSE;
		END_IF
		
		Cards_Mapping[Card_iCardIndex_1].AOutput := Cards_aAO_1;
		
	END_IF
	
END_ACTION 

ACTION getAT_1:
	
	IF UA_MethodGetHandle_getAT_1.Done THEN 
		
		InputArguments_getAT_1[0].Name := 'iCardIndexAT';
		InputArguments_getAT_1[0].Value := '::SimDiagnos:Card_iCardIndex_1';
		OutputArguments_getAT_1[0].Name := 'ATArray';
		OutputArguments_getAT_1[0].Value := '::SimDiagnos:Cards_aAT_1';
		UA_MethodCall_getAT_1(Execute := ExecuteMethodCall_getAT_1,
			ConnectionHdl := ConnectionHdl_PLC,
			MethodHdl := MethodHdl_getAT_1,
			Timeout := T#10s,
		InputArguments := InputArguments_getAT_1,
		OutputArguments := OutputArguments_getAT_1);
		
		IF NOT UA_MethodCall_getAT_1.Busy AND NOT UA_MethodCall_getAT_1.Done THEN
			ExecuteMethodCall_getAT_1 := TRUE;		
		END_IF
		
		IF UA_MethodCall_getAT_1.Done OR UA_MethodCall_getAT_1.Error THEN
			ExecuteMethodCall_getAT_1 := FALSE;
		END_IF
		
		Cards_Mapping[Card_iCardIndex_1].TempInput := Cards_aAT_1;
		
	END_IF
	
END_ACTION 

ACTION getDI_2:
	
	IF UA_MethodGetHandle_getDI_2.Done THEN 
		
		InputArguments_getDI_2[0].Name := 'iCardIndexDI';
		InputArguments_getDI_2[0].Value := '::SimDiagnos:Card_iCardIndex_2';
		OutputArguments_getDI_2[0].Name := 'DIArray';
		OutputArguments_getDI_2[0].Value := '::SimDiagnos:Cards_aDI_2';
		UA_MethodCall_getDI_2(Execute := ExecuteMethodCall_getDI_2,
			ConnectionHdl := ConnectionHdl_PLC,
			MethodHdl := MethodHdl_getDI_2,
			Timeout := T#10s,
		InputArguments := InputArguments_getDI_2,
		OutputArguments := OutputArguments_getDI_2);
		
		IF NOT UA_MethodCall_getDI_2.Busy AND NOT UA_MethodCall_getDI_2.Done THEN
			ExecuteMethodCall_getDI_2 := TRUE;		
		END_IF
		
		IF UA_MethodCall_getDI_2.Done OR UA_MethodCall_getDI_2.Error THEN
			ExecuteMethodCall_getDI_2 := FALSE;
		END_IF
		
		Cards_Mapping[Card_iCardIndex_2].DInput := Cards_aDI_2;
		
	END_IF
	
END_ACTION 

ACTION getDO_2:
	
	IF UA_MethodGetHandle_getDO_2.Done THEN 
		
		InputArguments_getDO_2[0].Name := 'iCardIndexDO';
		InputArguments_getDO_2[0].Value := '::SimDiagnos:Card_iCardIndex_2';
		OutputArguments_getDO_2[0].Name := 'DOArray';
		OutputArguments_getDO_2[0].Value := '::SimDiagnos:Cards_aDO_2';
		UA_MethodCall_getDO_2(Execute := ExecuteMethodCall_getDO_2,
			ConnectionHdl := ConnectionHdl_PLC,
			MethodHdl := MethodHdl_getDO_2,
			Timeout := T#10s,
		InputArguments := InputArguments_getDO_2,
		OutputArguments := OutputArguments_getDO_2);
		
		IF NOT UA_MethodCall_getDO_2.Busy AND NOT UA_MethodCall_getDO_2.Done THEN
			ExecuteMethodCall_getDO_2 := TRUE;		
		END_IF
		
		IF UA_MethodCall_getDO_2.Done OR UA_MethodCall_getDO_2.Error THEN
			ExecuteMethodCall_getDO_2 := FALSE;
		END_IF
		
		Cards_Mapping[Card_iCardIndex_2].DOutput := Cards_aDO_2;
		
	END_IF
	
END_ACTION 

ACTION getAI_2:
	
	IF UA_MethodGetHandle_getAI_2.Done THEN 
		
		InputArguments_getAI_2[0].Name := 'iCardIndexAI';
		InputArguments_getAI_2[0].Value := '::SimDiagnos:Card_iCardIndex_2';
		OutputArguments_getAI_2[0].Name := 'AIArray';
		OutputArguments_getAI_2[0].Value := '::SimDiagnos:Cards_aAI_2';
		UA_MethodCall_getAI_2(Execute := ExecuteMethodCall_getAI_2,
			ConnectionHdl := ConnectionHdl_PLC,
			MethodHdl := MethodHdl_getAI_2,
			Timeout := T#10s,
		InputArguments := InputArguments_getAI_2,
		OutputArguments := OutputArguments_getAI_2);
		
		IF NOT UA_MethodCall_getAI_2.Busy AND NOT UA_MethodCall_getAI_2.Done THEN
			ExecuteMethodCall_getAI_2 := TRUE;		
		END_IF
		
		IF UA_MethodCall_getAI_2.Done OR UA_MethodCall_getAI_2.Error THEN
			ExecuteMethodCall_getAI_2 := FALSE;
		END_IF
		
		Cards_Mapping[Card_iCardIndex_2].AInput := Cards_aAI_2;
		
	END_IF
	
END_ACTION 

ACTION getAO_2:
	
	IF UA_MethodGetHandle_getAO_2.Done THEN 
		
		InputArguments_getAO_2[0].Name := 'iCardIndexAO';
		InputArguments_getAO_2[0].Value := '::SimDiagnos:Card_iCardIndex_2';
		OutputArguments_getAO_2[0].Name := 'AOArray';
		OutputArguments_getAO_2[0].Value := '::SimDiagnos:Cards_aAO_2';
		UA_MethodCall_getAO_2(Execute := ExecuteMethodCall_getAO_2,
			ConnectionHdl := ConnectionHdl_PLC,
			MethodHdl := MethodHdl_getAO_2,
			Timeout := T#10s,
		InputArguments := InputArguments_getAO_2,
		OutputArguments := OutputArguments_getAO_2);
		
		IF NOT UA_MethodCall_getAO_2.Busy AND NOT UA_MethodCall_getAO_2.Done THEN
			ExecuteMethodCall_getAO_2 := TRUE;		
		END_IF
		
		IF UA_MethodCall_getAO_2.Done OR UA_MethodCall_getAO_2.Error THEN
			ExecuteMethodCall_getAO_2 := FALSE;
		END_IF
		
		Cards_Mapping[Card_iCardIndex_2].AOutput := Cards_aAO_2;
		
	END_IF
	
END_ACTION 

ACTION getAT_2:
	
	IF UA_MethodGetHandle_getAT_2.Done THEN 
		
		InputArguments_getAT_2[0].Name := 'iCardIndexAT';
		InputArguments_getAT_2[0].Value := '::SimDiagnos:Card_iCardIndex_2';
		OutputArguments_getAT_2[0].Name := 'ATArray';
		OutputArguments_getAT_2[0].Value := '::SimDiagnos:Cards_aAT_2';
		UA_MethodCall_getAT_2(Execute := ExecuteMethodCall_getAT_2,
			ConnectionHdl := ConnectionHdl_PLC,
			MethodHdl := MethodHdl_getAT_2,
			Timeout := T#10s,
		InputArguments := InputArguments_getAT_2,
		OutputArguments := OutputArguments_getAT_2);
		
		IF NOT UA_MethodCall_getAT_2.Busy AND NOT UA_MethodCall_getAT_2.Done THEN
			ExecuteMethodCall_getAT_2 := TRUE;		
		END_IF
		
		IF UA_MethodCall_getAT_2.Done OR UA_MethodCall_getAT_2.Error THEN
			ExecuteMethodCall_getAT_2 := FALSE;
		END_IF
		
		Cards_Mapping[Card_iCardIndex_2].TempInput := Cards_aAT_2;
		
	END_IF
	
END_ACTION

ACTION getCardMapping:

	CASE gPlcCards[LIMIT(0,Card_iCardIndex_1, 100)].Type OF
		
		//DIGITAL INPUT
		CARD_DI16:			
			getDI_1;
		
		//DIGITAL OUTPUT
		CARD_DO16:			
			getDO_1;
		
		//ANALOG INPUT
		CARD_AI2, CARD_AI4, CARD_AI8:
			getAI_1;
		
		//ANALOG OUTPUT
		CARD_AO2, CARD_AO4,	CARD_AO8:
			getAO_1;
		
		//TEMP
		CARD_AT2,CARD_AT4:
			getAT_1;
		
	END_CASE

	CASE gPlcCards[LIMIT(0,Card_iCardIndex_2,100)].Type OF
		
		//DIGITAL INPUT
		CARD_DI16:			
			getDI_2;
		
		//DIGITAL OUTPUT
		CARD_DO16:						
			getDO_2;
		
		//ANALOG INPUT
		CARD_AI2, CARD_AI4,	CARD_AI8:			
			getAI_2;
		
		//ANALOG OUTPUT
		CARD_AO2, CARD_AO4,	CARD_AO8:			
			getAO_2;
		
		//TEMP
		CARD_AT2,CARD_AT4:
			getAT_2;
	
	END_CASE
			
END_ACTION 

ACTION getPhotoCells:
	
	IF UA_MethodGetHandle_getPhotoCells.Done THEN 
		
		InputArguments_getPhotoCells[0].Name := 'xStartCount';
		InputArguments_getPhotoCells[0].Value := '::SimDiagnos:Detect_xStartCount';
		OutputArguments_getPhotoCells[0].Name := 'PhotoCells';
		OutputArguments_getPhotoCells[0].Value := '::SimDiagnos:Detect_PhotoCells';
		OutputArguments_getPhotoCells[1].Name := 'PrintDir';
		OutputArguments_getPhotoCells[1].Value := '::SimDiagnos:Detect_PrintDir';
		UA_MethodCall_getPhotoCells(Execute := ExecuteMethodCall_getPhotoCells,
			ConnectionHdl := ConnectionHdl_PLC,
			MethodHdl := MethodHdl_getPhotoCells,
			Timeout := T#10s,
		InputArguments := InputArguments_getPhotoCells,
		OutputArguments := OutputArguments_getPhotoCells);
		
		IF NOT UA_MethodCall_getPhotoCells.Busy AND NOT UA_MethodCall_getPhotoCells.Done THEN
			ExecuteMethodCall_getPhotoCells := TRUE;		
		END_IF
		
		IF UA_MethodCall_getPhotoCells.Done OR UA_MethodCall_getPhotoCells.Error THEN
			ExecuteMethodCall_getPhotoCells := FALSE;
		END_IF
		
	END_IF
	
	
END_ACTION

ACTION getCuringBar:
	
	IF UA_MethodGetHandle_getCuringBar.Done THEN 
		
		InputArguments_getCuringBar[0].Name := 'Index';
		InputArguments_getCuringBar[0].Value := '::SimDiagnos:CuringBar_BarIndex';
		OutputArguments_getCuringBar[0].Name := 'CuringBar';
		OutputArguments_getCuringBar[0].Value := '::SimDiagnos:CuringBar_VisuBar';
		UA_MethodCall_getCuringBar(Execute := ExecuteMethodCall_getCuringBar,
			ConnectionHdl := ConnectionHdl_PLC,
			MethodHdl := MethodHdl_getCuringBar,
			Timeout := T#10s,
		InputArguments := InputArguments_getCuringBar,
		OutputArguments := OutputArguments_getCuringBar);
		
		IF NOT UA_MethodCall_getCuringBar.Busy AND NOT UA_MethodCall_getCuringBar.Done THEN
			ExecuteMethodCall_getCuringBar := TRUE;		
		END_IF
		
		IF UA_MethodCall_getCuringBar.Done OR UA_MethodCall_getCuringBar.Error THEN
			ExecuteMethodCall_getCuringBar := FALSE;
		END_IF
		
	END_IF
	
END_ACTION

ACTION getTransV:
	
	IF UA_MethodGetHandle_getTransV.Done THEN 
		
		InputArguments_getTransV[0].Name := 'TVIdx';
		InputArguments_getTransV[0].Value := '::SimDiagnos:Vacuum_iTVIdx';
		InputArguments_getTransV[1].Name := 'BlowerIdx';
		InputArguments_getTransV[1].Value := '::SimDiagnos:Vacuum_iBlowerIdx';
		OutputArguments_getTransV[0].Name := 'BlowerSelected';
		OutputArguments_getTransV[0].Value := '::SimDiagnos:Vacuum_BlowerSelected';
		OutputArguments_getTransV[1].Name := 'TVSelected';
		OutputArguments_getTransV[1].Value := '::SimDiagnos:Vacuum_TVSelected';
		UA_MethodCall_getTransV(Execute := ExecuteMethodCall_getTransV,
			ConnectionHdl := ConnectionHdl_PLC,
			MethodHdl := MethodHdl_getTransV,
			Timeout := T#10s,
		InputArguments := InputArguments_getTransV,
		OutputArguments := OutputArguments_getTransV);
		
		IF NOT UA_MethodCall_getTransV.Busy AND NOT UA_MethodCall_getTransV.Done THEN
			ExecuteMethodCall_getTransV := TRUE;		
		END_IF
		
		IF UA_MethodCall_getTransV.Done OR UA_MethodCall_getTransV.Error THEN
			ExecuteMethodCall_getTransV := FALSE;
		END_IF
		
	END_IF
	
END_ACTION

ACTION getBlock:
	
	IF UA_MethodGetHandle_getBlock.Done THEN 
		
		InputArguments_getBlock[0].Name := 'Slot1Idx';
		InputArguments_getBlock[0].Value := '::SimDiagnos:Block_iSlotIdx1';
		InputArguments_getBlock[1].Name := 'BlockIdx';
		InputArguments_getBlock[1].Value := '::SimDiagnos:Block_iBlockIdx';
		InputArguments_getBlock[2].Name := 'Slot2Idx';
		InputArguments_getBlock[2].Value := '::SimDiagnos:Block_iSlotIdx2';
		OutputArguments_getBlock[0].Name := 'BlockSel';
		OutputArguments_getBlock[0].Value := '::SimDiagnos:Block_SelBlock';
		OutputArguments_getBlock[1].Name := 'BlockInputSel';
		OutputArguments_getBlock[1].Value := '::SimDiagnos:Block_SelBlockInp';
		OutputArguments_getBlock[2].Name := 'InkSel';
		OutputArguments_getBlock[2].Value := '::SimDiagnos:Block_SelInk';
		
		UA_MethodCall_getBlock(Execute := ExecuteMethodCall_getBlock,
			ConnectionHdl := ConnectionHdl_PLC,
			MethodHdl := MethodHdl_getBlock,
			Timeout := T#10s,
		InputArguments := InputArguments_getBlock,
		OutputArguments := OutputArguments_getBlock);
		
		IF NOT UA_MethodCall_getBlock.Busy AND NOT UA_MethodCall_getBlock.Done THEN
			ExecuteMethodCall_getBlock := TRUE;		
		END_IF
		
		IF UA_MethodCall_getBlock.Done OR UA_MethodCall_getBlock.Error THEN
			ExecuteMethodCall_getBlock := FALSE;
		END_IF
		
	END_IF
	
END_ACTION