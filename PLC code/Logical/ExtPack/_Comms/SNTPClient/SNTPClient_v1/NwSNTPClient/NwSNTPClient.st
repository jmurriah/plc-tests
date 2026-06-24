(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: NwSNTPClient
 * File: NwSNTPClient.st
 * Author: Bernecker + Rainer
 * Created: April 21, 2009
 ********************************************************************
 * Implementation of program NwSNTPClient
 ********************************************************************)

PROGRAM _INIT

	Time ACCESS ADR(gTime);
	
	(* Init values *)
	strcpy(ADR(Network.Data.SNTPServerAddress),ADR('192.168.127.50'));  (* IP address of the SNTP server *)
	
	Network.Data.SNTPInterval := 1;
	Network.Data.RTCInterval := 2;
	
	Network.Data.TimeZoneYear := 2022;


END_PROGRAM


PROGRAM _CYCLIC

	//Define the proper TimeZoneId with the UTC TimeZone and the 
	TimeStateMachine;
	

	CASE Network.Data.Step OF
		
		0:	IF Network.Command.bCfgGetSntpcData = 1 THEN
  				Network.Data.Step := 10;
			ELSIF Network.Command.bCfgSetSntpClient = 1 THEN
				Network.Data.Step := 20;
			ELSIF Network.Command.bGetTimeData = 1 THEN
				Network.Data.Step := 30;
			ELSIF Network.Command.bCfgSetTimeOffset = 1 THEN
				Network.Data.Step := 70;
			ELSIF Network.Command.bCfgSetDst = 1 THEN
				Network.Data.Step := 80;
			ELSIF Network.Command.bCfgSetTimeZone = 1 THEN
				Network.Data.Step := 90;
			END_IF
					
		10:  (* Get the parameters relevant for the SNTP client *)
			Network.Functionblocks.CfgGetSntpcData_0.enable := 1;  (* Enable the function block *)
			Network.Functionblocks.CfgGetSntpcData_0.pServerAddr := ADR(Network.Data.SNTPServerAddress);  (* IP address of the SNTP server *)
			Network.Functionblocks.CfgGetSntpcData_0.Len := SIZEOF(Network.Data.SNTPServerAddress);  (* Length of the SNTP server address string *)			
		
			Network.Functionblocks.CfgGetSntpcData_0;  (* Function Call *)
			
			IF Network.Functionblocks.CfgGetSntpcData_0.status = 0 THEN  (* CfgGetSntpcData successfull *)
				Network.Data.SNTPStatus := Network.Functionblocks.CfgGetSntpcData_0.run;
				Network.Data.SNTPInterval := Network.Functionblocks.CfgGetSntpcData_0.sntpcInterval;
				Network.Data.RTCInterval := Network.Functionblocks.CfgGetSntpcData_0.rtcInterval;
				Network.Command.bCfgGetSntpcData := 0;
				Network.Data.Step := 0;
			ELSIF Network.Functionblocks.CfgGetSntpcData_0.status = ERR_FUB_BUSY THEN  (* CfgGetSntpcData not finished -> redo *)
				(* Busy *)
			ELSE  (* Goto Error Step *)
				Network.Data.Step := 255;
			END_IF  
		
		20:  (* Configure, start, or stop the SNTP client *)
			Network.Functionblocks.CfgSetSntpClient_0.enable := 1;  (* Enable the function block *)
			Network.Functionblocks.CfgSetSntpClient_0.run := 1;  (* Start the SNTP client *)
			Network.Functionblocks.CfgSetSntpClient_0.pServerAddr := ADR(Network.Data.SNTPServerAddress);  (* IP address of the SNTP server *)
			Network.Functionblocks.CfgSetSntpClient_0.sntpcInterval := Network.Data.SNTPInterval;  (* Interval for the SNTP client to synchronize the time with the server *)
			Network.Functionblocks.CfgSetSntpClient_0.rtcInterval := Network.Data.RTCInterval;  (* Interval for the RTC and software time synchronization *)
			Network.Functionblocks.CfgSetSntpClient_0.option := cfgOPTION_VOLATILE;  (*  Temporarily set the parameter *)
			
			Network.Functionblocks.CfgSetSntpClient_0;  (* Function Call *)
		
			IF Network.Functionblocks.CfgSetSntpClient_0.status = 0 THEN  (* CfgSetSntpClient successfull *)
			
				Network.Data.SyncStatus := Network.Functionblocks.CfgSetSntpClient_0.syncStatus;
				
				IF Network.Functionblocks.CfgSetSntpClient_0.syncStatus = 2 THEN  (* Client active and time received at least once from server *)
					Network.Command.bCfgSetSntpClient := 0;
					Network.Data.Step := 0;
				ELSIF Network.Functionblocks.CfgSetSntpClient_0.syncStatus = 1 THEN  (* Client already active, but time not received from server *)
					Network.Command.bCfgSetSntpClient := 0;
					Network.Data.Step := 0;
				ELSE  (* Client not active *)
					Network.Data.Step := 255;
				END_IF
													
			ELSIF Network.Functionblocks.CfgSetSntpClient_0.status = ERR_FUB_BUSY THEN  (* CfgSetSntpClient not finished -> redo *)
				(* Busy *)
			ELSE  (* Goto Error Step *)
				Network.Data.Step := 255;
			END_IF
			
		30:  (* Get the configured time offset *)
			Network.Functionblocks.CfgGetTimeOffset_0.enable := 1;  (* Enable the function block *)
			
			Network.Functionblocks.CfgGetTimeOffset_0;  (* Function Call *)
			
			IF Network.Functionblocks.CfgGetTimeOffset_0.status = 0 THEN  (* CfgGetTimeOffset successfull *)
				Network.Data.TimeOffset := Network.Functionblocks.CfgGetTimeOffset_0.timeoffset;
				Network.Data.Step := 40;
			ELSIF Network.Functionblocks.CfgGetTimeOffset_0.status = ERR_FUB_BUSY THEN  (* CfgGetTimeOffset not finished -> redo *)
				(* Busy *)
			ELSE  (* Goto Error Step *)
				Network.Data.Step := 255;
			END_IF 
						
		40:  (* Get the ID of the currently active timezone *)
			Network.Functionblocks.CfgGetTimeZone_0.enable := 1;  (* Enable the function block *)
		
			Network.Functionblocks.CfgGetTimeZone_0;  (* Function Call *)
			
			IF Network.Functionblocks.CfgGetTimeZone_0.status = 0 THEN  (* CfgGetTimeZone successfull *)
				Network.Data.TimeZoneID := Network.Functionblocks.CfgGetTimeZone_0.timezoneID;
				Network.Data.Step := 50;
			ELSIF Network.Functionblocks.CfgGetTimeZone_0.status = ERR_FUB_BUSY THEN  (* CfgGetTimeZone not finished -> redo *)
				(* Busy *)
			ELSE  (* Goto Error Step *)
				Network.Data.Step := 255;
			END_IF 	
				
		50:  (* Get the times when the time switches for a particular timezone in a specified year *)
			Network.Functionblocks.CfgGetTimeZoneEntry_0.enable := 1;  (* Enable the function block *)
			Network.Functionblocks.CfgGetTimeZoneEntry_0.timezoneID := Network.Data.TimeZoneID;
			Network.Functionblocks.CfgGetTimeZoneEntry_0.year := Network.Data.TimeZoneYear;	
		
			Network.Functionblocks.CfgGetTimeZoneEntry_0;  (* Function Call *)
			
			IF Network.Functionblocks.CfgGetTimeZoneEntry_0.status = 0 THEN  (* CfgGetTimeZoneEntry successfull *)
				Network.Data.DateSummerTime := Network.Functionblocks.CfgGetTimeZoneEntry_0.dateDst;
				Network.Data.DateNormalTime := Network.Functionblocks.CfgGetTimeZoneEntry_0.dateNormal;
				Network.Data.Step := 60;
			ELSIF Network.Functionblocks.CfgGetTimeZoneEntry_0.status = ERR_FUB_BUSY THEN  (* CfgGetTimeZoneEntry not finished -> redo *)
				(* Busy *)
			ELSE  (* Goto Error Step *)
				Network.Data.Step := 255;
				Network.Functionblocks.CfgGetTimeZoneEntry_0.enable := 0;  (* Disanble the function block *)
				Network.Functionblocks.CfgGetTimeZoneEntry_0;  (* Function Call *)
			END_IF 	

		60:  (* Get the time offset between a timezone and GMT during normal time (gmt) and during summer time (gmtDst) *)
			Network.Functionblocks.CfgGetTimeZoneInfo_0.enable := 1;  (* Enable the function block *)
			Network.Functionblocks.CfgGetTimeZoneInfo_0.timezoneID := Network.Data.TimeZoneID;
			
			Network.Functionblocks.CfgGetTimeZoneInfo_0;  (* Function Call *)
			
			IF Network.Functionblocks.CfgGetTimeZoneInfo_0.status = 0 THEN  (* CfgGetTimeZoneInfo successfull *)
				Network.Data.DeviationGMT := Network.Functionblocks.CfgGetTimeZoneInfo_0.gmt;
				Network.Data.DeviationGMTDst := Network.Functionblocks.CfgGetTimeZoneInfo_0.gmtDst;
				Network.Command.bGetTimeData := 0;
				Network.Data.Step := 0;
			ELSIF Network.Functionblocks.CfgGetTimeZoneInfo_0.status = ERR_FUB_BUSY THEN  (* CfgGetTimeZoneInfo not finished -> redo *)
				(* Busy *)
			ELSE  (* Goto Error Step *)
				Network.Data.Step := 255;
				Network.Functionblocks.CfgGetTimeZoneInfo_0.enable := 0;  (* Disanble the function block *)
				Network.Functionblocks.CfgGetTimeZoneInfo_0;  (* Function Call *)
			END_IF
			
		70:  (* Set a time offset *)
			Network.Functionblocks.CfgSetTimeOffset_0.enable := 1;  (* Enable the function block *)
			Network.Functionblocks.CfgSetTimeOffset_0.timeoffset := Network.Data.TimeOffset;  (* Time offset to be configured [minutes] *)
			Network.Functionblocks.CfgSetTimeOffset_0.option := cfgOPTION_VOLATILE;  (*  Temporarily set the parameter *)
			
			Network.Functionblocks.CfgSetTimeOffset_0;  (* Function Call *)
			
			IF Network.Functionblocks.CfgSetTimeOffset_0.status = 0 THEN  (* CfgSetTimeOffset successfull *)
				Network.Command.bCfgSetTimeOffset := 0;
				Network.Data.Step := 0;
			ELSIF Network.Functionblocks.CfgSetTimeOffset_0.status = ERR_FUB_BUSY THEN  (* CfgSetTimeOffset not finished -> redo *)
				(* Busy *)
			ELSE  (* Goto Error Step *)
				Network.Data.Step := 255;
				Network.Functionblocks.CfgSetTimeOffset_0.enable := 0;  (* Disaable the function block *)
				Network.Functionblocks.CfgSetTimeOffset_0;  (* Function Call *)
			END_IF
			
		80:  (* Enable or disable automatic daylight savings time *)
			Network.Functionblocks.CfgSetDst_0.enable := 1;  (* Enable the function block *)
			Network.Functionblocks.CfgSetDst_0.dst := 1;  (* enables automatic daylight savings time *)
			Network.Functionblocks.CfgSetDst_0.option := cfgOPTION_VOLATILE;  (*  Temporarily set the parameter *)
			
			Network.Functionblocks.CfgSetDst_0;  (* Function Call *)
			
			IF Network.Functionblocks.CfgSetDst_0.status = 0 THEN  (* CfgSetDst successfull *)
				Network.Command.bCfgSetDst := 0;
				Network.Data.Step := 0;
			ELSIF Network.Functionblocks.CfgSetDst_0.status = ERR_FUB_BUSY THEN  (* CfgSetDst not finished -> redo *)
				(* Busy *)
			ELSE  (* Goto Error Step *)
				Network.Data.Step := 255;
			END_IF
			
		90:  (* Set the time zone *)
			Network.Functionblocks.CfgSetTimeZone_0.enable := 1;  (* Enable the function block *)
			Network.Functionblocks.CfgSetTimeZone_0.timezoneID := Network.Data.TimeZoneID;  (* ID of the timezone you would like to set *)
			Network.Functionblocks.CfgSetTimeZone_0.option := cfgOPTION_VOLATILE;  (*  Temporarily set the parameter *)
			
			Network.Functionblocks.CfgSetTimeZone_0;  (* Function Call *)
			
			IF Network.Functionblocks.CfgSetTimeZone_0.status = 0 THEN  (* CfgSetTimeZone successfull *)
				Network.Command.bCfgSetTimeZone := 0;
				Network.Data.Step := 0;
			ELSIF Network.Functionblocks.CfgSetTimeZone_0.status = ERR_FUB_BUSY THEN  (* CfgSetTimeZone not finished -> redo *)
				(* Busy *)
			ELSE  (* Goto Error Step *)
				Network.Data.Step := 255;
			END_IF
			
	END_CASE
	
END_PROGRAM
