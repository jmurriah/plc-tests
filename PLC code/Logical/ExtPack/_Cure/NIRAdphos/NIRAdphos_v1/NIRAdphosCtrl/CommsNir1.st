
ACTION CommsNir1: 

	IF data.Parameters.DDC.pIntensityNir1 = 0 THEN RETURN; END_IF

	// Assigning data to enable send it to the NIR
	Intensity_Nir1 ACCESS data.Parameters.DDC.pIntensityNir1;
	FOR iIndex_Nir1:=0 TO MIN(THICKENERGY_MAX_LAMPS, data.Parameters.DDC.iLamps -1) DO
		iValues_Nir1[iIndex_Nir1] := MAX(Intensity_Nir1[iIndex_Nir1], data.Status.iMinPower);
		data.Status.DDC[1].Intensity[iIndex_Nir1 + 1] := iValues_Nir1[iIndex_Nir1];
	END_FOR	
	
	CASE CommsState_Nir1  OF
		
		OPCUA_IDLE:
		
			xAnyCommsError_Nir1 := FALSE;
			IF CurrentState = NIRADPEW_POWER_ON OR CurrentState = NIRADPEW_POWERED OR CurrentState = NIRADPEW_RUNNING_BELT THEN
				CommsState_Nir1 := OPCUA_CONNECTING;
				ExecuteConnect_Nir1 := TRUE;
			END_IF
			
		
		OPCUA_CONNECTING: //Connectting
		
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
				Timeout := T#10s
			);

			IF NOT UA_Connect_Nir1.Busy THEN
				ExecuteConnect_Nir1 := FALSE;
				IF UA_Connect_Nir1.Done THEN
					ConnectionHdl_Nir1 := UA_Connect_Nir1.ConnectionHdl;
					////// NEXT
					CommsState_Nir1 := OPCUA_GETTING_NAMESPACE;
					ExecuteGetnamespaceindex_Nir1 := TRUE;
					iTimes_Nir1 := 0;
				END_IF
				IF UA_Connect_Nir1.Error THEN
					ConnectionHdl_Nir1 := 0;
					xAnyCommsError_Nir1 := TRUE;
					ExecuteNodeReleaseHandle_Nir1 := TRUE;
					CommsState_Nir1 := OPCUA_RELEASINSG_HANDLE;
				END_IF
				UA_Connect_Nir1(Execute := ExecuteConnect_Nir1);
			END_IF
		
			iTimes_Nir1 := iTimes_Nir1 + 1;
		
		
		OPCUA_GETTING_NAMESPACE:
		
			(* UA_GetNamespaceIndex - read index of required namespace for PVs *) 
			UA_GetNamespaceIndex_Nir1(Execute := ExecuteGetnamespaceindex_Nir1,
				ConnectionHdl := ConnectionHdl_Nir1,
				NamespaceUri := 'http://RecData',
				Timeout := T#5s
			);
			
			IF NOT UA_GetNamespaceIndex_Nir1.Busy THEN
				ExecuteGetnamespaceindex_Nir1 := FALSE;
				IF UA_GetNamespaceIndex_Nir1.Done THEN
					NamespaceIndex_Nir1 := UA_GetNamespaceIndex_Nir1.NamespaceIndex;
					////// NEXT
					CommsState_Nir1 := OPCUA_GETTING_HANDLE;
					ExecuteMethodGetHandle_Nir1 := TRUE;
					iTimes_Nir1 := 0;
				END_IF
				IF UA_GetNamespaceIndex_Nir1.Error THEN
					NamespaceIndex_Nir1 := 0;
					xAnyCommsError_Nir1 := TRUE;
					ExecuteNodeReleaseHandle_Nir1 := TRUE;
					CommsState_Nir1 := OPCUA_RELEASINSG_HANDLE;
				END_IF
				UA_GetNamespaceIndex_Nir1(Execute := ExecuteGetnamespaceindex_Nir1);
			END_IF 				
		
			iTimes_Nir1 := iTimes_Nir1 + 1;
		
		
		OPCUA_GETTING_HANDLE:

			(* UA_NodeGetHandle - get a handle for required methode *)
			ObjectNodeID_Nir1.NamespaceIndex := NamespaceIndex_Nir1;
			ObjectNodeID_Nir1.Identifier := '27';
			ObjectNodeID_Nir1.IdentifierType := UAIdentifierType_Numeric;

			UA_NodeGetHandle_Nir1(Execute := ExecuteMethodGetHandle_Nir1,
				ConnectionHdl := ConnectionHdl_Nir1,
				NodeID := ObjectNodeID_Nir1,
				Timeout := T#10s
			);
			
			IF NOT UA_NodeGetHandle_Nir1.Busy THEN
				ExecuteMethodGetHandle_Nir1 := FALSE;
				IF UA_NodeGetHandle_Nir1.Done THEN
					NodeHdl_Nir1 := UA_NodeGetHandle_Nir1.NodeHdl;
					////// NEXT
					CommsState_Nir1 := OPCUA_EXECUTING;
					iTimes_Nir1 := 0;
					// READY TO COMMUNICATE
				END_IF
				IF UA_NodeGetHandle_Nir1.Error THEN
					NodeHdl_Nir1 := 0;
					xAnyCommsError_Nir1 := TRUE;
					ExecuteNodeReleaseHandle_Nir1 := TRUE;
					CommsState_Nir1 := OPCUA_RELEASINSG_HANDLE;
				END_IF
				UA_NodeGetHandle_Nir1(Execute := ExecuteMethodGetHandle_Nir1);
			END_IF
	
			iTimes_Nir1 := iTimes_Nir1 + 1;
		
		
		OPCUA_EXECUTING:
		  
			(* UA_Write - call methode *)
			IndexRange_Nir1.StartIndex := 0;
			IndexRange_Nir1.EndIndex := 0;
			NodeAddInfo_Nir1.AttributeId := UAAI_Value;
			NodeAddInfo_Nir1.IndexRangeCount := 0;
			NodeAddInfo_Nir1.IndexRange[0] := IndexRange_Nir1;
			
			UA_Write_Nir1(Execute := ExecuteMethodCall_Nir1,
				ConnectionHdl := ConnectionHdl_Nir1,
				NodeHdl := NodeHdl_Nir1,
				NodeAddInfo := NodeAddInfo_Nir1,
				Timeout := T#10s,
				Variable := '::NIRAdphos:iValues_Nir1'
			);
			
			IF NOT UA_Write_Nir1.Busy THEN
				ExecuteMethodCall_Nir1 := FALSE;

				IF UA_Write_Nir1.Done THEN
					iGoodComms_Nir1 := iGoodComms_Nir1 + 1;
					iPartialGoodTimes_Nir1 := iPartialGoodTimes_Nir1 + 1;
				END_IF

				IF UA_Write_Nir1.Error THEN
					xAnyCommsError_Nir1 := TRUE;
					ExecuteNodeReleaseHandle_Nir1 := TRUE;
					CommsState_Nir1 := OPCUA_RELEASINSG_HANDLE;
				END_IF

				// Exiting from Executing when no communicating
				IF CurrentState = NIRADPEW_IDLE THEN
					ExecuteNodeReleaseHandle_Nir1 := TRUE;
					CommsState_Nir1 := OPCUA_RELEASINSG_HANDLE;
					iTimes_Nir1 := 0;
				END_IF
				UA_Write_Nir1(Execute := ExecuteMethodCall_Nir1, Variable := '::NIRAdphos:iValues_Nir1');

			END_IF
			
			tonNextComms_Nir1.IN := NOT ExecuteMethodCall_Nir1;
			IF tonNextComms_Nir1.PT = 0 THEN
				tonNextComms_Nir1.PT := T#20ms;
			END_IF
			tonNextComms_Nir1();
			IF tonNextComms_Nir1.Q THEN
				ExecuteMethodCall_Nir1 := TRUE;
				// Update values in simulation just for comms
				IF gDryer.St.HwData.Family = FAMILY_BRAUTOMATIONRUNTIME THEN
					UpdateSimDataForMediaNir1;
				END_IF
			END_IF
			
			iTimes_Nir1 := iTimes_Nir1 + 1;
		
		
		OPCUA_PAUSED:
			
		
		OPCUA_RELEASINSG_HANDLE:
		
			UA_NodeReleaseHandle_Nir1(Execute := ExecuteNodeReleaseHandle_Nir1, 
				ConnectionHdl := ConnectionHdl_Nir1, 
				NodeHdl := NodeHdl_Nir1, 
				Timeout := T#10s
			); 
			
			IF NOT UA_NodeReleaseHandle_Nir1.Busy THEN
				ExecuteNodeReleaseHandle_Nir1 := FALSE;
				
				IF UA_NodeReleaseHandle_Nir1.Done THEN
					////// NEXT
					NodeHdl_Nir1 := 0;
					ExecuteDisconnect_Nir1 := TRUE;
					CommsState_Nir1 := OPCUA_DISCONNECTING;
					iTimes_Nir1 := 0;
				END_IF
				IF UA_NodeReleaseHandle_Nir1.Error THEN
					NodeHdl_Nir1 := 0;
					xAnyCommsError_Nir1 := TRUE;
					ExecuteDisconnect_Nir1 := TRUE;
					CommsState_Nir1 := OPCUA_DISCONNECTING;
				END_IF
				
				UA_NodeReleaseHandle_Nir1(Execute := ExecuteNodeReleaseHandle_Nir1);
			END_IF
			
			iTimes_Nir1 := iTimes_Nir1 + 1;
			
		
		OPCUA_DISCONNECTING:
		
			UA_Disconnect_Nir1(Execute := ExecuteDisconnect_Nir1,
				ConnectionHdl := ConnectionHdl_Nir1,
				Timeout := T#10s
			);
			
			IF NOT UA_Disconnect_Nir1.Busy THEN
				ExecuteDisconnect_Nir1 := FALSE;
				
				IF UA_Disconnect_Nir1.Done THEN
					////// NEXT
					ConnectionHdl_Nir1 := 0;
					// If arriving here after any error, go to error before going to Idle
					IF xAnyCommsError_Nir1 THEN
						CommsState_Nir1 := OPCUA_FAULTED;
					ELSE
						CommsState_Nir1 := OPCUA_IDLE;
					END_IF
				END_IF
				IF UA_Disconnect_Nir1.Error THEN
					ConnectionHdl_Nir1 := 0;
					CommsState_Nir1 := OPCUA_FAULTED;
				END_IF

				UA_Disconnect_Nir1(Execute := ExecuteDisconnect_Nir1);
			END_IF
		
		
		OPCUA_FAULTED:
		
			tonWaitExitFault_Nir1.IN := TRUE;
			tonWaitExitFault_Nir1.PT := T#2s;
			tonWaitExitFault_Nir1();
			IF tonWaitExitFault_Nir1.Q THEN
				tonWaitExitFault_Nir1(IN:=FALSE); //This is neccessary to allow the timer working in the second time entering here
				CommsState_Nir1 := OPCUA_IDLE;
			END_IF
		
	END_CASE
	
	// If an error is detected, raise the alarm. Wait to free resouces before allow reseting alarm
	IF xAnyCommsError_Nir1 THEN
		data.Alarms.xOpcUaWriteError[iIndexConstant_Nir1] := TRUE;
	END_IF
	
	
	// Update ratio calculation
	IF tonCalculateUpdate_Nir1.Q THEN
		IF iPartialGoodTimes_Nir1 > 0 THEN
			rUpdateRatio_Nir1 := 1000 * 10.0 / UINT_TO_REAL(iPartialGoodTimes_Nir1);
		ELSE
			rUpdateRatio_Nir1 := 0;
		END_IF
		iPartialGoodTimes_Nir1 := 0;
	END_IF
	tonCalculateUpdate_Nir1.IN := NOT tonCalculateUpdate_Nir1.Q;
	tonCalculateUpdate_Nir1.PT := t#10s;
	tonCalculateUpdate_Nir1();
		
	// Manage History of status
	IF CommsState_Nir1<>StateHistory_Nir1[0] THEN
		FOR iIndexHistory:=iHistoryLines TO 1 BY -1 DO
			StateHistory_Nir1[iIndexHistory] := StateHistory_Nir1[iIndexHistory-1];
		END_FOR
		StateHistory_Nir1[0]:=CommsState_Nir1;
	END_IF	
	
END_ACTION

ACTION InitialDataForMediaNir1:
	
	FOR iIndexValue_Nir1 := 0 TO 47 DO
		iValues_Nir1[iIndexValue_Nir1] := iIndexValue_Nir1;
	END_FOR

END_ACTION

ACTION UpdateSimDataForMediaNir1:
	
	FOR iIndexValue_Nir1 := 0 TO 47 DO
		iValues_Nir1[iIndexValue_Nir1] := iValues_Nir1[iIndexValue_Nir1] + 1;
		IF iValues_Nir1[iIndexValue_Nir1] > 100 THEN
			iValues_Nir1[iIndexValue_Nir1] := 0;
		END_IF
	END_FOR

END_ACTION

ACTION PreparingMethodCommsNir1: 

END_ACTION
