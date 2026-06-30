
ACTION Comms: 

	//It is here to allow the simulation writing directly over data.Status.CommsStatus and working all properly
	xComsStatusChanged := data.Status.CommsStatus<>commsStatus_copy;
	commsStatus_copy:=data.Status.CommsStatus;
	
	//Not execute communications if in Simulation and comms disabled
	//In this case, the comms structure will be filled in Simulator
	IF data.Parameters.xDisableComms THEN
		RETURN;
	END_IF;
	
	//Comms Error definition
	tonErrorComms.IN := commsStatus<>ARCLG_IDLE;
	tonErrorComms.PT := T#4s;
	tonErrorComms();

	tonSendReadSystem.IN := commsStatus=ARCLG_IDLE;
	IF NOT data.Alarms.xCommsError THEN
		tonSendReadSystem.PT := T#2s;
	ELSE
		tonSendReadSystem.PT := T#15s;
	END_IF
	tonSendReadSystem();
	
	tonDelaySendReadSystem.IN := xReadSystemDelay;
	tonDelaySendReadSystem.PT := t#200ms;
	tonDelaySendReadSystem();
	
	IF tonSendReadSystem.Q OR tonDelaySendReadSystem.Q THEN
		data.Commands.InternalComms.xReadLampsUv := TRUE;
		xReadSystemDelay := FALSE;
	END_IF
	
	CASE commsStatus OF
		
		ARCLG_IDLE:
			IF data.Commands.InternalComms.xReadLamps THEN
				commsStatus:=ARCLG_GET_LAMPS;
				iTimesReadLamps := iTimesReadLamps + 1; 
			ELSIF data.Commands.InternalComms.xReadAlerts THEN
				commsStatus:=ARCLG_GET_ALERTS;
				iTimesReadAlerts := iTimesReadAlerts + 1; 
			ELSIF data.Commands.InternalComms.xSelectLamp THEN
				commsStatus:=ARCLG_SELEC_LAMP;
				iTimesSelectLamp := iTimesSelectLamp + 1; 
			ELSIF data.Commands.InternalComms.xDeSelectLamp THEN
				commsStatus:=ARCLG_DESELEC_LAMP;
				iTimesDeselectLamp := iTimesDeselectLamp + 1; 
			ELSIF data.Commands.InternalComms.xStopSelected THEN
				commsStatus:=ARCLG_STOP_SELECTED;
				iTimesStopSelected := iTimesStopSelected + 1; 
			ELSIF data.Commands.InternalComms.xStartSelected THEN
				commsStatus:=ARCLG_START_SELECTED;
				iTimesStartSelected := iTimesStartSelected + 1; 
			ELSIF data.Commands.InternalComms.xDeselectAll THEN
				commsStatus:=ARCLG_DESELEC_ALL;
				iTimesDeselectAll := iTimesDeselectAll + 1; 
			ELSIF data.Commands.InternalComms.xSetPower THEN
				commsStatus:=ARCLG_SET_POWER;
				iTimesSetPower := iTimesSetPower + 1; 
			ELSIF data.Commands.InternalComms.xResetAll THEN
				commsStatus:=ARCLG_RESET_ALL;
				iTimesResetAll := iTimesResetAll + 1; 
			ELSIF data.Commands.InternalComms.xReadLampsUv THEN
				commsStatus:=ARCLG_GET_LAMPS_UV;
				iTimesReadLampsUv := iTimesReadLampsUv + 1; 
			ELSIF data.Commands.InternalComms.xReadSystem THEN
				commsStatus:=ARCLG_GET_SYSTEM;
				iTimesReadSystem := iTimesReadSystem + 1; 
			END_IF
			data.Commands.InternalComms := CommsCmdReseted;
			
		ARCLG_GET_SYSTEM,
		ARCLG_GET_LAMPS,
		ARCLG_GET_LAMPS_UV,
		ARCLG_GET_ALERTS:
			
			CASE commsSubStatus OF
				
				ARCLGS_IDLE:
					Responsedata := '';
					LoadRequest;
					commsSubStatus:=ARCLGS_SEND_GET_DATA;
				
				ARCLGS_SEND_GET_DATA:
					AnalyzeSendGetData;
					
					// If Comms OK, , comms state is reseted 
					// If Comms Error, comms state is reseted when registered
					
				ARCLGS_PARSE_DATA:
				
					tonParsingError.IN := JSON_Parse_0.Status = 2;
					tonParsingError.PT := t#500ms;
					tonParsingError();
					
					JSON_Parse_0();
					IF JSON_Parse_0.Status = 1 THEN
						//Done parsing string.
						LoadReceivedData;
						RegisterGoodComms;

					END_IF
					
					//Error parsing data.
					IF tonParsingError.Q THEN

						ResetJsonParser;
						
						lastCommsError.Source := HTTPERROR_PARSINGERROR;
						RegisterErrorComms;

					END_IF
				
			END_CASE
		
		ARCLG_RESET_ALL,
		ARCLG_STOP_SELECTED,
		ARCLG_START_SELECTED,
		ARCLG_SELEC_LAMP,
		ARCLG_DESELEC_LAMP,
		ARCLG_DESELEC_ALL,
		ARCLG_SET_POWER:

			CASE commsSubStatus OF
				
				ARCLGS_IDLE:
					Responsedata := '';
					LoadRequest;
					commsSubStatus:=ARCLGS_SEND_POST_DATA;
				
				ARCLGS_SEND_POST_DATA:
					IF ClientPost.status = 0 AND ClientPost.httpStatus = HTTPSTATUS_OK AND ClientPost.phase = httpPHASE_RECEIVED THEN
						RegisterGoodComms;
					END_IF
				
			END_CASE		
	END_CASE
	
	IF tonErrorComms.Q THEN
		//Raise a TimeOut Error
		lastCommsError.Source := HTTPERROR_TIMEOUT;
		RegisterErrorComms;
	END_IF
	
	//Reassign data when trying to communicate
	IF data.Alarms.xCommsError AND EDGEPOS(commsSubStatus=ARCLGS_SEND_GET_DATA) THEN
		InitialiceCommsObjects;
	END_IF
	
	Client.send := EDGEPOS(Client.enable);
	Client.enable := commsSubStatus=ARCLGS_SEND_GET_DATA;
	Client();
	IF EDGEPOS(commsSubStatus=ARCLGS_SEND_GET_DATA) THEN iSendClient := iSendClient +1; END_IF 
	
	ClientPost.send := EDGEPOS(ClientPost.enable);
	ClientPost.enable := commsSubStatus=ARCLGS_SEND_POST_DATA;
	ClientPost();
	IF EDGEPOS(commsSubStatus=ARCLGS_SEND_POST_DATA) THEN iSendPost := iSendPost +1; END_IF 

	data.Status.CommsStatus := commsStatus;
	
	sysResp;
	LampsResp;
	UvLampsResp;
	
	//Store the history of the status to easy the debug
	IF EDGEPOS(data.Alarms.xCommsError) THEN
		FOR iIndexHistory:=iHistoryLines TO 1 BY -1 DO 
			ErrorCommsHistory[iIndexHistory]:=ErrorCommsHistory[iIndexHistory-1];
		END_FOR;
		ErrorCommsHistory[0]:= lastCommsError;
	END_IF
	
END_ACTION

ACTION AnalyzeSendGetData:

	IF Client.status = ERR_FUB_ENABLE_FALSE OR Client.status = ERR_FUB_BUSY OR Client.httpStatus = 0 THEN
		//Waiting the function to finish
		RETURN;
	END_IF

	IF Client.status <> ERR_OK THEN
		//FUB error
		lastCommsError.Source := HTTPERROR_FUNCTION;
		RegisterErrorComms;
		RETURN;
	END_IF
	
	IF Client.httpStatus <> HTTPSTATUS_OK THEN
		//Get response successful but no response data
		lastCommsError.Source := HTTPERROR_RESPONSE_NODATA;
		RegisterErrorComms;
		RETURN;
	END_IF

	IF Responsedata = '' AND Client.phase = httpPHASE_RECEIVED THEN
		lastCommsError.Source := HTTPERROR_EMPTYDATA;
		RegisterErrorComms;
		RETURN;
	END_IF
	
	LoadVarInJson;
	ResetJsonParser;
	commsSubStatus:=ARCLGS_PARSE_DATA;
	
END_ACTION

ACTION RegisterGoodComms:
	
	ResetCommsStatus;
	
	data.Alarms.xCommsError := FALSE;
	data.Alarms.Comms := resetedComsAlarms;

END_ACTION

ACTION RegisterErrorComms:
	
	//Register data just with new errors
	IF NOT data.Alarms.xCommsError THEN 
		SaveClientInformation;
	END_IF
	
	ResetCommsStatus;
	ResetLampsStatus;

	data.Alarms.xCommsError := TRUE;

END_ACTION

ACTION ResetCommsStatus:
	
	commsStatus:=ARCLG_IDLE;
	commsSubStatus:=ARCLGS_IDLE;

END_ACTION

ACTION ResetLampsStatus:
	
	FOR iLamp:=1 TO data.Parameters.iLampQuantity DO
		data.Status.Lamps[iLamp].UnitInternalState := 'ErrorComms';
		data.Status.Lamps[iLamp].InAlarm := TRUE;
	END_FOR;

END_ACTION
	
ACTION SaveClientInformation:
	
	lastCommsError.HttpStatus := Client.httpStatus;
	lastCommsError.Phase := Client.phase;
	lastCommsError.Response := Responsedata;
	lastCommsError.Status := Client.status;
	lastCommsError.Time := TIME();
	
	iTimesCommsError := iTimesCommsError + 1; 
	
END_ACTION

ACTION LoadRequest: 
	
	CASE commsStatus OF
		ARCLG_GET_SYSTEM:
			Ressource := 'api/system';
			dataToParse := '{"ArcLampGew:sysRespWrk":';
			memset(ADR(sysRespWrk),0,SIZEOF(sysRespWrk));
			
		ARCLG_GET_LAMPS:
			Ressource := 'api/lamps/0';
			dataToParse := '{"ArcLampGew:LampsRespWrk":';
			memset(ADR(LampsRespWrk),0,SIZEOF(LampsRespWrk));
		
		ARCLG_GET_LAMPS_UV:
			Ressource := 'api/lamps/0/uv';
			dataToParse := '{"ArcLampGew:UvLampsRespWrk":';
			memset(ADR(UvLampsRespWrk),0,SIZEOF(UvLampsRespWrk));			
			
		ARCLG_GET_ALERTS:
			Ressource := 'api/lamps/0/alerts';
			dataToParse := '{"ArcLampGew:alertsRespWrk":';
			memset(ADR(alertsRespWrk),0,SIZEOF(alertsRespWrk));
			
		ARCLG_RESET_ALL:
			Ressource := 'api/lamps/0/reset';
			CleanRequestDataPost;
			
		ARCLG_STOP_SELECTED:
			Ressource := 'api/lamps/0/stop';
			CleanRequestDataPost;
			
		ARCLG_START_SELECTED:
			Ressource := 'api/lamps/0/start';
			CleanRequestDataPost;
			
		ARCLG_SELEC_LAMP:
			//Ressource := 'api/lamps/xx/select';
			Ressource := 'api/lamps/';
			brsitoa(iLampComs, ADR(strAux));
			strcat(ADR(Ressource),ADR(strAux));
			strAux := '/select';
			strcat(ADR(Ressource),ADR(strAux));
			CleanRequestDataPost;
			
		ARCLG_DESELEC_LAMP:
			//Ressource := 'api/lamps/xx/deselect';
			Ressource := 'api/lamps/';
			brsitoa(iLampComs, ADR(strAux));
			strcat(ADR(Ressource),ADR(strAux));
			strAux := '/deselect';
			strcat(ADR(Ressource),ADR(strAux));
			CleanRequestDataPost;
			
		ARCLG_DESELEC_ALL:
			Ressource := 'api/lamps/0/deselect';
			CleanRequestDataPost;
			
		ARCLG_SET_POWER:
			Ressource := 'api/lamps/0/powerramping';
			
			RequestDataPost := '';
			strAux := '';
			paramURL.enable := TRUE;
			paramURL.pParam := ADR('power');
			brsitoa(data.Parameters.iPowerPerc, ADR(strAux));
			paramURL.pValue := ADR(strAux);
			paramURL.pDest := ADR(RequestDataPost);
			paramURL.destSize := SIZEOF(RequestDataPost);
			paramURL();

			strAux := '';
			paramURL.enable := TRUE;
			paramURL.pParam := ADR('speed');
			brsitoa(100, ADR(strAux));
			paramURL.pValue := ADR(strAux);
			paramURL.pDest := ADR(RequestDataPost);
			paramURL.destSize := SIZEOF(RequestDataPost);
			paramURL();
			
			ClientPost.requestDataLen := LEN(RequestDataPost);
			brsitoa(LEN(RequestDataPost), ADR(RequestHeaderPost.userLine[5].value));

	END_CASE

END_ACTION

ACTION LoadReceivedData: 
	
	CASE commsStatus OF
		ARCLG_GET_SYSTEM:
			sysResp := sysRespWrk;
		ARCLG_GET_LAMPS:
			LampsResp := LampsRespWrk;
		ARCLG_GET_LAMPS_UV:
			UvLampsResp := UvLampsRespWrk;
			LoadReceivedUvData;
		ARCLG_GET_ALERTS:
			alertsResp := alertsRespWrk;
			LoadStatusWithAlerts;
	END_CASE

END_ACTION

ACTION LoadReceivedUvData: 
	
	iLamp:=1;
	UvLampRespAssigWrk ACCESS ADR(UvLampsResp.Lamp1);
	LoadReceivedUvDataLamp;
	
	iLamp:=2;
	UvLampRespAssigWrk ACCESS ADR(UvLampsResp.Lamp2);
	LoadReceivedUvDataLamp;
	
END_ACTION

ACTION LoadReceivedUvDataLamp: 
	
	data.Status.Lamps[iLamp].NodeAddress := UvLampRespAssigWrk.NodeAddress;
	data.Status.Lamps[iLamp].UnitInternalState := UvLampRespAssigWrk.UnitInternalState;
	data.Status.Lamps[iLamp].LampPowerPercent := UvLampRespAssigWrk.LampPowerPercent;
	data.Status.Lamps[iLamp].LampPower := UvLampRespAssigWrk.LampPower;
	data.Status.Lamps[iLamp].PressImpression := UvLampRespAssigWrk.PressImpression;
	data.Status.Lamps[iLamp].PressSpeed := UvLampRespAssigWrk.PressSpeed;
	data.Status.Lamps[iLamp].IsSelected := UvLampRespAssigWrk.IsSelected;
	data.Status.Lamps[iLamp].AlertCount := UvLampRespAssigWrk.AlertCount;
	data.Status.Lamps[iLamp].InAlarm := UvLampRespAssigWrk.AlertCount > 0;	
	data.Status.Lamps[iLamp].SensorEmission[1] := UvLampRespAssigWrk.Sensor1Raw;
	data.Status.Lamps[iLamp].SensorEmission[2] := UvLampRespAssigWrk.Sensor2Raw;
	data.Status.Lamps[iLamp].SensorEmission[3] := UvLampRespAssigWrk.Sensor3Raw;
	data.Status.Lamps[iLamp].SensorEmission[4] := UvLampRespAssigWrk.Sensor4Raw;
	data.Status.Lamps[iLamp].SensorEmission[5] := UvLampRespAssigWrk.Sensor5Raw;
	data.Status.Lamps[iLamp].SensorEmission[6] := UvLampRespAssigWrk.Sensor6Raw;
	data.Status.Lamps[iLamp].SensorEmission[7] := UvLampRespAssigWrk.Sensor7Raw;
	data.Status.Lamps[iLamp].SensorEmission[8] := UvLampRespAssigWrk.Sensor8Raw;

END_ACTION

ACTION LoadVarInJson:
	
	strcat(ADR(dataToParse),ADR(Responsedata));
	strAux := '}';
	strcat(ADR(dataToParse),ADR(strAux));

END_ACTION

ACTION ResetJsonParser:
	
	//Reset Memory
	memset(ADR(JSON_Parse_0),0,SIZEOF(JSON_Parse_0));
	dataDebug := '';
	dataNotFound := '';
	
	//Reassign
	JSON_Parse_0.pMessage := ADR(dataToParse);
	JSON_Parse_0.pDebug := ADR(dataDebug);
	JSON_Parse_0.SizeDebug := SIZEOF(dataDebug);
	JSON_Parse_0.pVariablesNotFound := ADR(dataNotFound);
	JSON_Parse_0.SizeVariablesNotFound := SIZEOF(dataNotFound);
	
END_ACTION

ACTION LoadStatusWithAlerts:
	
	FOR iLamp:=1 TO data.Parameters.iLampQuantity DO
		IF data.Parameters.Lamps[iLamp].Enable THEN
			xAuxVar := FALSE;
			FOR iAlert:=1 TO MAXIMUM_QUANTITY_ALERTS DO
				//TOREVIEW: Do it in reflection
			END_FOR;
		END_IF
	END_FOR;
	
END_ACTION

ACTION CleanRequestDataPost:
	
	RequestDataPost := '';
	ClientPost.requestDataLen := 0;
	brsitoa(0, ADR(RequestHeaderPost.userLine[5].value));
	
END_ACTION

ACTION InitialiceCommsObjects:
	
	//Host					:= '192.168.125.39'; //Assigned in the init
	//Ressource 			:= 'api/system'; //Assigned before sending the frame
	
	Client.method 			:= httpMETHOD_GET;
	Client.option 			:= httpOPTION_HTTP_11;
	
	Client.pHost 			:= ADR(Host);
	Client.hostPort			:= 9910;
	Client.pUri 			:= ADR(Ressource);
	Client.pResponseData 	:= ADR(Responsedata);
	Client.responseDataSize := SIZEOF(Responsedata);
	Client.pRequestHeader	:= ADR(RequestHeader);
	
	//credentialsFlat	:='S20143:425520'; //Code of the first machine
	//credentialsFlat	:='S1111:366390'; //Code of the simulator
	brsstrcpy(ADR(credentialsUserInternal),ADR(data.Parameters.SerialNumber));
	strAuxCredentials := ':';
	brsstrcat(ADR(credentialsUserInternal), ADR(strAuxCredentials));
	brsstrcat(ADR(credentialsUserInternal), ADR(data.Parameters.PIN));
	brsstrcpy(ADR(credentialsFlat),ADR(credentialsUserInternal));
	
	authenticationBase		:='Basic ';

	CredentialsEncoder.enable := TRUE;
	CredentialsEncoder.pSrc := ADR(credentialsFlat);
	CredentialsEncoder.srcLen := LEN(credentialsFlat);
	CredentialsEncoder.pDest := ADR(credentialsBase64);
	CredentialsEncoder.destSize := SIZEOF(credentialsBase64);
	CredentialsEncoder();
	
	RequestHeader.connection := 'keep-alive';
	
	RequestHeader.userLine[0].name := 'Authorization';
	RequestHeader.userLine[0].value := authenticationBase;
	strcat(ADR(RequestHeader.userLine[0].value),ADR(credentialsBase64));

	RequestHeader.userLine[1].name := 'Content-Type';
	RequestHeader.userLine[1].value := 'text/json';

	RequestHeader.userLine[2].name := 'Accept-Encoding';
	RequestHeader.userLine[2].value := 'gzip, deflate, br';

	RequestHeader.userLine[3].name := 'Host';
	RequestHeader.userLine[3].value := Host;
	strAux := ':';
	strcat(ADR(RequestHeader.userLine[3].value),ADR(strAux));
	itoa(Client.hostPort, ADR(strAux));    
	strcat(ADR(RequestHeader.userLine[3].value),ADR(strAux));

	ClientPost.method 			:= httpMETHOD_POST;
	ClientPost.option 			:= httpOPTION_HTTP_11;
	
	ClientPost.pHost 			:= ADR(Host);
	ClientPost.hostPort			:= 9910;
	ClientPost.pUri 			:= ADR(Ressource);
	ClientPost.pResponseData 	:= ADR(Responsedata);
	ClientPost.responseDataSize := SIZEOF(Responsedata);
	ClientPost.pRequestHeader	:= ADR(RequestHeaderPost);
	ClientPost.pRequestData		:= ADR(RequestDataPost);
	
	RequestHeaderPost.connection := 'keep-alive';
	
	RequestHeaderPost.userLine[0].name := 'Authorization';
	RequestHeaderPost.userLine[0].value := authenticationBase;
	strcat(ADR(RequestHeaderPost.userLine[0].value),ADR(credentialsBase64));

	RequestHeaderPost.userLine[1].name := 'Content-Type';
	RequestHeaderPost.userLine[1].value := 'text/json';

	RequestHeaderPost.userLine[2].name := 'Accept-Encoding';
	RequestHeaderPost.userLine[2].value := 'gzip, deflate, br';

	RequestHeaderPost.userLine[3].name := 'Host';
	RequestHeaderPost.userLine[3].value := Host;
	strAux := ':';
	strcat(ADR(RequestHeaderPost.userLine[3].value),ADR(strAux));
	itoa(Client.hostPort, ADR(strAux));    
	strcat(ADR(RequestHeaderPost.userLine[3].value),ADR(strAux));
	
	RequestHeaderPost.userLine[4].name := 'Accept';
	RequestHeaderPost.userLine[4].value := '*/*';
	
	RequestHeaderPost.userLine[5].name := 'Content-Length';
	//brsitoa(0, ADR(RequestHeaderPost.userLine[5].value)); //Assigned later
	
	data.Parameters.Lamps[1].Enable := TRUE;
	data.Parameters.Lamps[2].Enable := TRUE;
	data.Parameters.iLampQuantity := 2;
	
END_ACTION
