
ACTION CommsNir2: 

	IF data.Parameters.DDC.pIntensityNir2 = 0 THEN RETURN; END_IF

	// Assigning data to enable send it to the NIR
	Intensity_Nir2 ACCESS data.Parameters.DDC.pIntensityNir2;
	FOR iIndex_Nir2:=0 TO MIN(THICKENERGY_MAX_LAMPS, data.Parameters.DDC.iLamps -1) DO
		iValues_Nir2[iIndex_Nir2] := MAX(Intensity_Nir2[iIndex_Nir2], data.Status.iMinPower);
		data.Status.DDC[2].Intensity[iIndex_Nir2 + 1] := iValues_Nir2[iIndex_Nir2];
	END_FOR
	
	CASE CommsState_Nir2  OF
		
		OPCUA_IDLE:
		
			xAnyCommsError_Nir2 := FALSE;
			IF CurrentState = NIRADPEW_POWER_ON OR CurrentState = NIRADPEW_POWERED OR CurrentState = NIRADPEW_RUNNING_BELT THEN
				CommsState_Nir2 := OPCUA_CONNECTING;
				ExecuteConnect_Nir2 := TRUE;
			END_IF
			
		
		OPCUA_CONNECTING: //Connectting
		
			(* UA_Connect - establish connection to OPC UA Server *)
			SessionConnectInfo_Nir2.SecurityMsgMode := UASecurityMsgMode_None;
			SessionConnectInfo_Nir2.SecurityPolicy := UASecurityPolicy_None;
			SessionConnectInfo_Nir2.TransportProfile := UATP_UATcp;
			SessionConnectInfo_Nir2.UserIdentityToken.UserIdentityTokenType := UAUITT_Anonymous;
			//SessionConnectInfo_Nir2.UserIdentityToken.TokenParam1 := 'PressCore';
			//SessionConnectInfo_Nir2.UserIdentityToken.TokenParam2 := 'h98o76';
			SessionConnectInfo_Nir2.SessionTimeout := T#1m;
			SessionConnectInfo_Nir2.MonitorConnection := T#10s;
           
			UA_Connect_Nir2(Execute := ExecuteConnect_Nir2,
				ServerEndpointUrl := 'opc.tcp://192.168.125.92:4840',
				SessionConnectInfo := SessionConnectInfo_Nir2,
				Timeout := T#10s
			);

			IF NOT UA_Connect_Nir2.Busy THEN
				ExecuteConnect_Nir2 := FALSE;
				IF UA_Connect_Nir2.Done THEN
					ConnectionHdl_Nir2 := UA_Connect_Nir2.ConnectionHdl;
					////// NEXT
					CommsState_Nir2 := OPCUA_GETTING_NAMESPACE;
					ExecuteGetnamespaceindex_Nir2 := TRUE;
					iTimes_Nir2 := 0;
				END_IF
				IF UA_Connect_Nir2.Error THEN
					ConnectionHdl_Nir2 := 0;
					xAnyCommsError_Nir2 := TRUE;
					ExecuteNodeReleaseHandle_Nir2 := TRUE;
					CommsState_Nir2 := OPCUA_RELEASINSG_HANDLE;
				END_IF
				UA_Connect_Nir2(Execute := ExecuteConnect_Nir2);
			END_IF
		
			iTimes_Nir2 := iTimes_Nir2 + 1;
		
		
		OPCUA_GETTING_NAMESPACE:
		
			(* UA_GetNamespaceIndex - read index of required namespace for PVs *) 
			UA_GetNamespaceIndex_Nir2(Execute := ExecuteGetnamespaceindex_Nir2,
				ConnectionHdl := ConnectionHdl_Nir2,
				NamespaceUri := 'http://RecData',
				Timeout := T#5s
			);
			
			IF NOT UA_GetNamespaceIndex_Nir2.Busy THEN
				ExecuteGetnamespaceindex_Nir2 := FALSE;
				IF UA_GetNamespaceIndex_Nir2.Done THEN
					NamespaceIndex_Nir2 := UA_GetNamespaceIndex_Nir2.NamespaceIndex;
					////// NEXT
					CommsState_Nir2 := OPCUA_GETTING_HANDLE;
					ExecuteMethodGetHandle_Nir2 := TRUE;
					iTimes_Nir2 := 0;
				END_IF
				IF UA_GetNamespaceIndex_Nir2.Error THEN
					NamespaceIndex_Nir2 := 0;
					xAnyCommsError_Nir2 := TRUE;
					ExecuteNodeReleaseHandle_Nir2 := TRUE;
					CommsState_Nir2 := OPCUA_RELEASINSG_HANDLE;
				END_IF
				UA_GetNamespaceIndex_Nir2(Execute := ExecuteGetnamespaceindex_Nir2);
			END_IF 				
		
			iTimes_Nir2 := iTimes_Nir2 + 1;
		
		
		OPCUA_GETTING_HANDLE:

			(* UA_NodeGetHandle - get a handle for required methode *)
			ObjectNodeID_Nir2.NamespaceIndex := NamespaceIndex_Nir2;
			ObjectNodeID_Nir2.Identifier := '6';
			ObjectNodeID_Nir2.IdentifierType := UAIdentifierType_Numeric;

			UA_NodeGetHandle_Nir2(Execute := ExecuteMethodGetHandle_Nir2,
				ConnectionHdl := ConnectionHdl_Nir2,
				NodeID := ObjectNodeID_Nir2,
				Timeout := T#10s
			);
			
			IF NOT UA_NodeGetHandle_Nir2.Busy THEN
				ExecuteMethodGetHandle_Nir2 := FALSE;
				IF UA_NodeGetHandle_Nir2.Done THEN
					NodeHdl_Nir2 := UA_NodeGetHandle_Nir2.NodeHdl;
					////// NEXT
					CommsState_Nir2 := OPCUA_EXECUTING;
					iTimes_Nir2 := 0;
					// READY TO COMMUNICATE
				END_IF
				IF UA_NodeGetHandle_Nir2.Error THEN
					NodeHdl_Nir2 := 0;
					xAnyCommsError_Nir2 := TRUE;
					ExecuteNodeReleaseHandle_Nir2 := TRUE;
					CommsState_Nir2 := OPCUA_RELEASINSG_HANDLE;
				END_IF
				UA_NodeGetHandle_Nir2(Execute := ExecuteMethodGetHandle_Nir2);
			END_IF
	
			iTimes_Nir2 := iTimes_Nir2 + 1;
		
		
		OPCUA_EXECUTING:
		  
			(* UA_Write - call methode *)
			IndexRange_Nir2.StartIndex := 0;
			IndexRange_Nir2.EndIndex := 0;
			NodeAddInfo_Nir2.AttributeId := UAAI_Value;
			NodeAddInfo_Nir2.IndexRangeCount := 0;
			NodeAddInfo_Nir2.IndexRange[0] := IndexRange_Nir2;
			
			UA_Write_Nir2(Execute := ExecuteMethodCall_Nir2,
				ConnectionHdl := ConnectionHdl_Nir2,
				NodeHdl := NodeHdl_Nir2,
				NodeAddInfo := NodeAddInfo_Nir2,
				Timeout := T#10s,
				Variable := '::NIRAdphos:iValues_Nir2'
			);
			
			IF NOT UA_Write_Nir2.Busy THEN
				ExecuteMethodCall_Nir2 := FALSE;

				IF UA_Write_Nir2.Done THEN
					iGoodComms_Nir2 := iGoodComms_Nir2 + 1;
					iPartialGoodTimes_Nir2 := iPartialGoodTimes_Nir2 + 1;
				END_IF

				IF UA_Write_Nir2.Error THEN
					xAnyCommsError_Nir2 := TRUE;
					ExecuteNodeReleaseHandle_Nir2 := TRUE;
					CommsState_Nir2 := OPCUA_RELEASINSG_HANDLE;
				END_IF

				// Exiting from Executing when no communicating
				IF CurrentState = NIRADPEW_IDLE THEN
					ExecuteNodeReleaseHandle_Nir2 := TRUE;
					CommsState_Nir2 := OPCUA_RELEASINSG_HANDLE;
					iTimes_Nir2 := 0;
				END_IF
				UA_Write_Nir2(Execute := ExecuteMethodCall_Nir2, Variable := '::NIRAdphos:iValues_Nir2');

			END_IF
			
			tonNextComms_Nir2.IN := NOT ExecuteMethodCall_Nir2;
			IF tonNextComms_Nir2.PT = 0 THEN
				tonNextComms_Nir2.PT := T#20ms;
			END_IF
			tonNextComms_Nir2();
			IF tonNextComms_Nir2.Q THEN
				ExecuteMethodCall_Nir2 := TRUE;
				// Update values in simulation just for comms
				IF gDryer.St.HwData.Family = FAMILY_BRAUTOMATIONRUNTIME THEN
					UpdateSimDataForMediaNir2;
				END_IF
			END_IF
			
			iTimes_Nir2 := iTimes_Nir2 + 1;
		
		
		OPCUA_PAUSED:
			
		
		OPCUA_RELEASINSG_HANDLE:
		
			UA_NodeReleaseHandle_Nir2(Execute := ExecuteNodeReleaseHandle_Nir2, 
				ConnectionHdl := ConnectionHdl_Nir2, 
				NodeHdl := NodeHdl_Nir2, 
				Timeout := T#10s
			); 
			
			IF NOT UA_NodeReleaseHandle_Nir2.Busy THEN
				ExecuteNodeReleaseHandle_Nir2 := FALSE;
				
				IF UA_NodeReleaseHandle_Nir2.Done THEN
					////// NEXT
					NodeHdl_Nir2 := 0;
					ExecuteDisconnect_Nir2 := TRUE;
					CommsState_Nir2 := OPCUA_DISCONNECTING;
					iTimes_Nir2 := 0;
				END_IF
				IF UA_NodeReleaseHandle_Nir2.Error THEN
					NodeHdl_Nir2 := 0;
					xAnyCommsError_Nir2 := TRUE;
					ExecuteDisconnect_Nir2 := TRUE;
					CommsState_Nir2 := OPCUA_DISCONNECTING;
				END_IF
				
				UA_NodeReleaseHandle_Nir2(Execute := ExecuteNodeReleaseHandle_Nir2);
			END_IF
			
			iTimes_Nir2 := iTimes_Nir2 + 1;
			
		
		OPCUA_DISCONNECTING:
		
			UA_Disconnect_Nir2(Execute := ExecuteDisconnect_Nir2,
				ConnectionHdl := ConnectionHdl_Nir2,
				Timeout := T#10s
			);
			
			IF NOT UA_Disconnect_Nir2.Busy THEN
				ExecuteDisconnect_Nir2 := FALSE;
				
				IF UA_Disconnect_Nir2.Done THEN
					////// NEXT
					ConnectionHdl_Nir2 := 0;
					// If arriving here after any error, go to error before going to Idle
					IF xAnyCommsError_Nir2 THEN
						CommsState_Nir2 := OPCUA_FAULTED;
					ELSE
						CommsState_Nir2 := OPCUA_IDLE;
					END_IF
				END_IF
				IF UA_Disconnect_Nir2.Error THEN
					ConnectionHdl_Nir2 := 0;
					CommsState_Nir2 := OPCUA_FAULTED;
				END_IF

				UA_Disconnect_Nir2(Execute := ExecuteDisconnect_Nir2);
			END_IF
		
		
		OPCUA_FAULTED:
		
			tonWaitExitFault_Nir2.IN := TRUE;
			tonWaitExitFault_Nir2.PT := T#2s;
			tonWaitExitFault_Nir2();
			IF tonWaitExitFault_Nir2.Q THEN
				tonWaitExitFault_Nir2(IN:=FALSE); //This is neccessary to allow the timer working in the second time entering here
				CommsState_Nir2 := OPCUA_IDLE;
			END_IF
		
	END_CASE
	
	// If an error is detected, raise the alarm. Wait to free resouces before allow reseting alarm
	IF xAnyCommsError_Nir2 THEN
		data.Alarms.xOpcUaWriteError[iIndexConstant_Nir2] := TRUE;
	END_IF
	
	
	// Update ratio calculation
	IF tonCalculateUpdate_Nir2.Q THEN
		IF iPartialGoodTimes_Nir2 > 0 THEN
			rUpdateRatio_Nir2 := 1000 * 10.0 / UINT_TO_REAL(iPartialGoodTimes_Nir2);
		ELSE
			rUpdateRatio_Nir2 := 0;
		END_IF
		iPartialGoodTimes_Nir2 := 0;
	END_IF
	tonCalculateUpdate_Nir2.IN := NOT tonCalculateUpdate_Nir2.Q;
	tonCalculateUpdate_Nir2.PT := t#10s;
	tonCalculateUpdate_Nir2();
		
	// Manage History of status
	IF CommsState_Nir2<>StateHistory_Nir2[0] THEN
		FOR iIndexHistory:=iHistoryLines TO 1 BY -1 DO
			StateHistory_Nir2[iIndexHistory] := StateHistory_Nir2[iIndexHistory-1];
		END_FOR
		StateHistory_Nir2[0]:=CommsState_Nir2;
	END_IF	
	
END_ACTION

ACTION InitialDataForMediaNir2:
	
	FOR iIndexValue_Nir2 := 0 TO 47 DO
		iValues_Nir2[iIndexValue_Nir2] := iIndexValue_Nir2;
	END_FOR

END_ACTION

ACTION UpdateSimDataForMediaNir2:
	
	FOR iIndexValue_Nir2 := 0 TO 47 DO
		iValues_Nir2[iIndexValue_Nir2] := iValues_Nir2[iIndexValue_Nir2] + 1;
		IF iValues_Nir2[iIndexValue_Nir2] > 100 THEN
			iValues_Nir2[iIndexValue_Nir2] := 0;
		END_IF
	END_FOR

END_ACTION

ACTION PreparingMethodCommsNir2: 

END_ACTION
