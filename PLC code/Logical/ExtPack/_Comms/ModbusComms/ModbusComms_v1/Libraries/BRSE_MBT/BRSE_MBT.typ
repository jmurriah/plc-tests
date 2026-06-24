
TYPE
	BRSE_MBT_ReceiveBuff_typ : 	STRUCT 
		Byte : ARRAY[0..BRSE_MBT_MAX_BUFFER]OF USINT;
	END_STRUCT;
	BRSE_MBT_ClientInfo_typ : 	STRUCT 
		Ident : UDINT;
		Port : UINT;
		IpAddr : ARRAY[0..17]OF USINT;
	END_STRUCT;
	BRSE_MBT_ClientRequest_typ : 	STRUCT 
		TransactionId : UINT;
		ProtocolId : UINT;
		Length : UINT;
	END_STRUCT;
	BRSE_MBT_Internal_typ : 	STRUCT 
		TcpOpenIdent : UDINT;
	END_STRUCT;
	MBT_ClientInternal_typ : 	STRUCT 
		TcpOpenIdent : ARRAY[0..MB_MAX_CLIENTS]OF UDINT;
	END_STRUCT;
	BRSE_MBT_Client_typ : 	STRUCT 
		Info : BRSE_MBT_ClientInfo_typ;
		Request : BRSE_MBT_ClientRequest_typ;
		RecvBuffer : ARRAY[0..BRSE_MBT_MAX_BUFFER]OF USINT;
		SendBuffer : ARRAY[0..BRSE_MBT_MAX_BUFFER]OF USINT;
		FB_TcpRecv : TcpRecv;
		FB_TcpSend : TcpSend;
		FB_TcpIoctl : TcpIoctl;
		ResponseByteSize : UINT;
		State : USINT; (*0=no client, 1=receiving, 2=sending, 9=disconnecting*)
		TON_Disconnect : TON;
	END_STRUCT;
	BRSE_MBT_NewClient_typ : 	STRUCT 
		IpAddr : ARRAY[0..17]OF USINT;
		CloseIdent : UDINT;
		ReconnectClientIdx : UINT;
		ReconnectClient : BOOL;
	END_STRUCT;
END_TYPE
