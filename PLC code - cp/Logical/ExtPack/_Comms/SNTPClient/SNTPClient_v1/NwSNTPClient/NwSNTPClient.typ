(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: NwSNTPClient
 * File: NwSNTPClient.typ
 * Author: Bernecker + Rainer
 * Created: April 21, 2009
 ********************************************************************
 * Local data types of program NwSNTPClient
 ********************************************************************)

TYPE
	SNTP_Network_typ : 	STRUCT 
		Command : SNTP_Network_Command_typ; (*Structure Command (contains all command elements)*)
		Data : SNTP_Network_Data_typ; (*Structure Data (contains all data informations)*)
		Functionblocks : SNTP_Network_Functionblocks_typ; (*Structure Functionblocks (contains all FuBs)*)
	END_STRUCT;
	SNTP_Network_Command_typ : 	STRUCT 
		bCfgGetSntpcData : BOOL; (*Command: Get SNTP client data*)
		bGetTimeData : BOOL; (*Command: Get several time data*)
		bCfgSetSntpClient : BOOL; (*Command: Start SNTP client*)
		bCfgSetTimeOffset : BOOL; (*Command: Set the configured time offset*)
		bCfgSetDst : BOOL; (*Command: Enable the automatic daylight savings time*)
		bCfgSetTimeZone : BOOL; (*Command: Set the configured time zone*)
	END_STRUCT;
	SNTP_Network_Data_typ : 	STRUCT 
		SNTPServerAddress : STRING[16]; (*Data variable for CfgGetSntpcData() and CfgSetSntpClient()*)
		SNTPStatus : UDINT; (*Data variable for CfgGetSntpcData()*)
		SNTPInterval : UINT; (*Data variable for CfgGetSntpcData() and CfgSetSntpClient()*)
		RTCInterval : UINT; (*Data variable for CfgGetSntpcData() and CfgSetSntpClient()*)
		SyncStatus : USINT; (*Data variable for CfgSetSntpClient()*)
		TimeOffset : UINT; (*Data variable for CfgGetTimeOffset() and CfgSetTimeOffset()*)
		TimeZoneID : UINT; (*Data variable for CfgGetTimeZone(), CfgGetTimeZoneEntry(), CfgGetTimeZoneInfo() and CfgSetTimeZone()*)
		TimeZoneYear : UINT; (*Data variable for CfgGetTimeZoneEntry()*)
		DateSummerTime : DATE_AND_TIME; (*Data variable for CfgGetTimeZoneEntry()*)
		DateNormalTime : DATE_AND_TIME; (*Data variable for CfgGetTimeZoneEntry()*)
		DeviationGMT : UINT; (*Data variable for CfgGetTimeZoneInfo()*)
		DeviationGMTDst : UINT; (*Data variable for CfgGetTimeZoneInfo()*)
		Step : USINT; (*Step variable*)
	END_STRUCT;
	SNTP_Network_Functionblocks_typ : 	STRUCT 
		CfgGetSntpcData_0 : CfgGetSntpcData; (*Functionblock CfgGetSntpcData()*)
		CfgSetSntpClient_0 : CfgSetSntpClient; (*Functionblock CfgSetSntpClient()*)
		CfgGetTimeOffset_0 : CfgGetTimeOffset; (*Functionblock CfgGetTimeOffset()*)
		CfgGetTimeZone_0 : CfgGetTimeZone; (*Functionblock CfgGetTimeZone()*)
		CfgGetTimeZoneEntry_0 : CfgGetTimeZoneEntry; (*Functionblock CfgGetTimeZoneEntry()*)
		CfgGetTimeZoneInfo_0 : CfgGetTimeZoneInfo; (*Functionblock CfgGetTimeZoneInfo()*)
		CfgSetTimeOffset_0 : CfgSetTimeOffset; (*Functionblock CfgSetTimeOffset()*)
		CfgSetDst_0 : CfgSetDst; (*Functionblock CfgSetDst()*)
		CfgSetTimeZone_0 : CfgSetTimeZone; (*Functionblock CfgSetTimeZone()*)
	END_STRUCT;
END_TYPE
