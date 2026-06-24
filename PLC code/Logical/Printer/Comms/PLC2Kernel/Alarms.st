
ACTION AlarmKernelPLCComms:
	
	//Current implementation. Like this to avoid the "not used" messages during compiling
	IF FALSE THEN
		AlarmKernelPLCCommsSocket;
	END_IF

END_ACTION

ACTION AlarmKernelPLCCommsSocket:

	//status_adr := PV_xgetadr(ADR('FB_BRSE_MBT_Server'), ADR(pv_adr), ADR(data_len));(* get the address and the length of PV *)
	
	status_adr := PV_xgetadr(ADR(nameVar), ADR(pv_adr), ADR(data_len));(* get the address and the length of PV *)
	memcpy(ADR(theValue), pv_adr, data_len);

	
	iClientsConnected := 0;
	FOR iClient:=0 TO BRSE_MBT_MAX_CLIENT DO
		nameVar := '::FB_BRSE_MBT_Server.Clients[';
		brsitoa(iClient, ADR(strAux));
		strcat(ADR(nameVar), ADR(strAux));
		strcat(ADR(nameVar), ADR('].State'));
		status_adr := PV_xgetadr(ADR(nameVar), ADR(pv_adr), ADR(data_len));(* get the address and the length of PV *)
		memcpy(ADR(theValue), pv_adr, data_len);

		//0=no client, 1=receiving, 2=sending, 9=disconnecting
		IF theValue=2 OR theValue=3 THEN
			iClientsConnected := iClientsConnected + 1;
		END_IF

	END_FOR;

	T_AlarmComPcPlc.IN:= iClientsConnected > 0;
	T_AlarmComPcPlc.PT:= T#10S;	//This is changed to 45secs 
	T_AlarmComPcPlc();
	
	IF EDGEPOS (T_AlarmComPcPlc.Q) THEN	
		gMachine.Al.Alarm.xAlarmComPcPLC:= TRUE;	
	END_IF;


END_ACTION
