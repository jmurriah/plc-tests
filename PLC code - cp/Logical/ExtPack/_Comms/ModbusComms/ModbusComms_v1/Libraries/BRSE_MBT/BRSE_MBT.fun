
FUNCTION_BLOCK BRSE_MBT_Server
	VAR_INPUT
		Enable : BOOL; (*Add your parameter comment*)
		ClientFormat : USINT;
		Port : UINT;
		SocketTimeout : UDINT; (*Linger time for incoming sockets*)
	END_VAR
	VAR_OUTPUT
		Status : UINT;
	END_VAR
	VAR
		FB_TcpOpen : TcpOpen;
		FB_TcpServer : TcpServer;
		FB_TcpCloseOld : TcpClose;
		FB_TcpCloseServer : TcpClose;
		FB_TcpClose : ARRAY[0..BRSE_MBT_MAX_CLIENT] OF TcpClose;
		Clients : ARRAY[0..BRSE_MBT_MAX_CLIENT] OF BRSE_MBT_Client_typ;
		Step : UINT;
		ClientNr : USINT;
		FB_BRSE_MB_Server : BRSE_MB_Server;
		Log : ARRAY[0..BRSE_MBT_LOG_MAX] OF STRING[100];
		LogIndex : UINT;
		TmpUINT : UINT;
		NewClient : BRSE_MBT_NewClient_typ;
		Error : UINT; (*Indicator to leave state when all fubs are done*)
		IsBusy : UINT; (*Indicates that one or more fubs are not ready to leave state*)
		TmpStr : STRING[10];
		LingerOptions : tcpLINGER_typ;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION MBT_GetServerInternalStructAddr : UDINT (*Returns the allocated server struct address, i.e. a pointer to a BRSE_MBT_Internal_typ. Used only for debug purposes.*)
END_FUNCTION

FUNCTION MBT_GetClientInternalStructAddr : UDINT (*Returns the allocated client internal struct address, i.e. a pointer to a MBT_ClientInternal_typ. Used only for debug purposes.*)
END_FUNCTION

FUNCTION_BLOCK MBT_ServerExit (*Closes any open tcp port.*)
	VAR_OUTPUT
		Status : UINT;
	END_VAR
	VAR
		FB_TcpClose : TcpClose;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MBT_Client
	VAR_INPUT
		Enable : BOOL;
		ServerFormat : USINT;
		ClientID : USINT;
		IpAddr : STRING[18];
		Port : UINT;
		ConnectionTimeout : UDINT; (*Time in ms the client waits for new requests (from queue) before closing down the socket connection*)
		SocketTimeout : UDINT; (*Linger time for outgoing sockets*)
	END_VAR
	VAR_OUTPUT
		Status : UINT;
	END_VAR
	VAR
		Step : UINT;
		FB_MB_CreateClientRequest : MB_CreateClientRequest;
		FB_MB_PutClientResponse : MB_PutClientResponse;
		FB_TcpOpen : TcpOpen;
		FB_TcpClient : TcpClient;
		FB_TcpSend : TcpSend;
		FB_TcpRecive : TcpRecv;
		FB_TcpClose : TcpClose;
		FB_RTInfo : RTInfo;
		FB_TcpIoctl : TcpIoctl;
		RecvLen : UINT;
		SendBuffer : ARRAY[0..BRSE_MBT_MAX_BUFFER] OF USINT;
		ReceiveBuffer : ARRAY[0..BRSE_MBT_MAX_BUFFER] OF USINT;
		TransactionId : UINT;
		Timeout : UDINT;
		RecvTransactionId : UINT;
		ErrorStatus : UINT;
		ResendCounter : UINT;
		CycleTimeMs : UDINT; (*Task cycle time in ms*)
		ElapsedTime : UDINT;
		LingerOptions : tcpLINGER_typ;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MBT_ExitClient (*Closes any open tcp port.*)
	VAR_INPUT
		ClientID : USINT; (*Add your parameter comment*)
	END_VAR
	VAR_OUTPUT
		Status : UINT;
	END_VAR
	VAR
		FB_TcpClose : TcpClose;
	END_VAR
END_FUNCTION_BLOCK
