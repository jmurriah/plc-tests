/*! \file BRSE_MBT_Server.c */

#include "BRSE_MBT.h"
#include "BRSE_MBT_Main.h"

#ifdef _SG4
	#define SWAPUINT	swapUINT
	#define SWAPINT		swapINT
#else
	#define SWAPUINT	
	#define SWAPINT
#endif

#define	BUSY			65535
#define DISABLED		65534

/* B&R Modbus TCP Server */
/* (spec: http://www.rtaautomation.com/modbustcp/files/Open_ModbusTCP_Standard.pdf)
 * 
 * Listens to port 502 for connecting clients. Responds to tcp requests according to specification. 
 * 
 * byte 0:  transaction identifier - copied by server - usually 0
 * byte 1:  transaction identifier - copied by server - usually 0
 * byte 2:  protocol identifier = 0
 * byte 3:  protocol identifier = 0
 * byte 4:  length field (upper byte) = 0 (since all messages are smaller than 256)
 * byte 5:  length field (lower byte) = number of bytes following
 * byte 6: 	unit identifier (previously 'slave address')
 *
 * byte 7: 	MODBUS function code
 * byte 8 	on:         data as needed
*/

BRSE_MBT_Internal_typ BRSE_MBT_ServerInternal;

UDINT MBT_GetServerInternalStructAddr()
{
	return (UDINT) &BRSE_MBT_ServerInternal;
}

/*!
	\interface BRSE_MBT_Server
	\brief Server: Create a connection to a physical Ethernet Port and open port 502 and starts	listen for incoming modbus messages.
	
	\param[in]	Enable	Enables execution of the function.
	\param[in]	ClientFormat	Set the format of 4 byte variables to Intel or Motorola. BRSE_MB_INTEL / BRSE_MB_MOTOROLA
	\param[in]	SocketTimeout	Time in seconds that the system keeps the socket alive after closing it (linger time). This can be used as the opposite station still has some data to send. If the input is zero the socket is closed immediately.
	\param[out] Status	Return status. 
	
*/
void BRSE_MBT_Server(struct BRSE_MBT_Server* inst)
{
	UINT clientIdx;
	
	switch (inst->Step)
	{
		case  0 : /* init */
			inst->FB_TcpOpen.pIfAddr = 0;
			inst->FB_TcpOpen.port = inst->Port;
			inst->FB_TcpOpen.options = tcpOPT_REUSEADDR;
			inst->Error = 0;
			if (inst->Enable)
			{
				inst->Step = 10;	
			}
			break;
		
		case 10: /* Open port */
			inst->FB_TcpOpen.enable = 1;
			TcpOpen(&inst->FB_TcpOpen);
			if (inst->FB_TcpOpen.status == 0)
			{
				inst->FB_TcpServer.enable = 1;
				inst->FB_TcpServer.ident = inst->FB_TcpOpen.ident;
				inst->FB_TcpServer.backlog = 0;
				inst->FB_TcpServer.pIpAddr = (UDINT)inst->NewClient.IpAddr;
				BRSE_MBT_ServerInternal.TcpOpenIdent = inst->FB_TcpOpen.ident;
				inst->Step = 15; /* wait for request */
			}
			else if (inst->FB_TcpOpen.status != BUSY)
			{
				/*inst->Step = 70;*/
			}
			break;
				
		case 15: /* Disabled */
			if (inst->Enable)
			{
				inst->Step = 20;	
			}
			break;
		
		case 20: /* Read requests and respond */
			inst->IsBusy = 0;
			
			/* Check if any connections are to be closed */
			if (inst->NewClient.CloseIdent != 0) /* Close an old client connection (client has reconnected) */
			{
				inst->FB_TcpCloseOld.enable = 1;
				inst->FB_TcpCloseOld.ident	= inst->NewClient.CloseIdent;
				inst->FB_TcpCloseOld.how = 0; /*tcpSHUT_RD | tcpSHUT_WR;*/
				TcpClose(&inst->FB_TcpCloseOld);
				if(inst->FB_TcpCloseOld.status != BUSY) /* Nevermind errors here */
				{
					inst->NewClient.CloseIdent = 0;
					
					if(inst->FB_TcpCloseOld.status)
					{
						strcpy(inst->Log[inst->LogIndex], "Close1 error: ");
						itoa(inst->FB_TcpCloseOld.status, (UDINT)inst->TmpStr);
						strcat(inst->Log[inst->LogIndex], inst->TmpStr);
						strcat(inst->Log[inst->LogIndex], " id: ");
						itoa(inst->FB_TcpCloseOld.ident, (UDINT)inst->TmpStr);
						strcat(inst->Log[inst->LogIndex], inst->TmpStr);
						inst->LogIndex++;
					}
					
				}
				inst->IsBusy = inst->IsBusy || inst->FB_TcpCloseOld.status == BUSY;
			}
			else
			{
				for(clientIdx = 0; clientIdx<BRSE_MBT_MAX_CLIENT; clientIdx++) /* Loop through clients and see if they are to be closed */
				{
					if (inst->Clients[clientIdx].State == 99)
					{
						inst->FB_TcpClose[clientIdx].enable = 1;
						inst->FB_TcpClose[clientIdx].ident	= inst->Clients[clientIdx].Info.Ident;
						inst->FB_TcpClose[clientIdx].how = 0;/* tcpSHUT_RD | tcpSHUT_WR;*/
						TcpClose(&inst->FB_TcpClose[clientIdx]);
						if(inst->FB_TcpClose[clientIdx].status != BUSY) /* Nevermind errors here */
						{
							if(inst->FB_TcpClose[clientIdx].status)
							{
								strcpy(inst->Log[inst->LogIndex], "Close2 error: ");
								itoa(inst->FB_TcpClose[clientIdx].status, (UDINT)inst->TmpStr);
								strcat(inst->Log[inst->LogIndex], inst->TmpStr);
								strcat(inst->Log[inst->LogIndex], " id: ");
								itoa(inst->FB_TcpClose[clientIdx].ident, (UDINT)inst->TmpStr);
								strcat(inst->Log[inst->LogIndex], inst->TmpStr);
								inst->LogIndex++;
							}
							
							BRSE_MBT_RemoveClient(inst, clientIdx);
							
						}
						inst->IsBusy = inst->IsBusy || inst->FB_TcpClose[clientIdx].status == BUSY;
						break; /* break for-loop; can only run TcpClose on one client at a time */
					}
				}
			}
			
			/* Check for new clients if maximum nbr of clients has not been reached */
			if (inst->ClientNr < BRSE_MBT_MAX_CLIENT && (inst->Error==0 || inst->FB_TcpServer.status == BUSY))
			{
				TcpServer(&inst->FB_TcpServer);
				if (inst->FB_TcpServer.status == 0) /* client connected */
				{
					BRSE_MBT_AddClient(inst);
				}
				else if (inst->FB_TcpServer.status == tcpERR_INVALID_IDENT ||
						inst->FB_TcpServer.status == tcpERR_SOCKET_LISTEN)
				{
					inst->Error = inst->FB_TcpServer.status;
					if (inst->LogIndex < BRSE_MBT_LOG_MAX)
					{
						strcpy(inst->Log[inst->LogIndex], "Server error: ");
						itoa(inst->FB_TcpServer.status, (UDINT)inst->TmpStr);
						strcat(inst->Log[inst->LogIndex], inst->TmpStr);
						strcat(inst->Log[inst->LogIndex], " ");
						inst->LogIndex++;
					}
				}/* inst->FB_TcpServer.status == tcpERR_SOCKET_ACCEPT inst->FB_TcpServer.status == tcpERR_NOMORE_IDENTS ||*/
				inst->IsBusy = inst->IsBusy || (inst->FB_TcpServer.status == BUSY);
			}
			
			/* Loop through clients, respond to any requests */
			for(clientIdx = 0; clientIdx < BRSE_MBT_MAX_CLIENT; clientIdx++)
			{
				switch(inst->Clients[clientIdx].State)
				{
					case 0: /* No client initialized */
						break;
				
					case 1:
						inst->Clients[clientIdx].State = 10;
						break;
						
					case 10: /* Set linger options */
						inst->LingerOptions.lOnOff = 1;
						inst->LingerOptions.lLinger = inst->SocketTimeout;
						inst->Clients[clientIdx].FB_TcpIoctl.enable = 1;
						inst->Clients[clientIdx].FB_TcpIoctl.ident = inst->Clients[clientIdx].Info.Ident;
						inst->Clients[clientIdx].FB_TcpIoctl.pData = (UDINT)&inst->LingerOptions;
						inst->Clients[clientIdx].FB_TcpIoctl.datalen = sizeof(inst->LingerOptions);
						inst->Clients[clientIdx].FB_TcpIoctl.ioctl = tcpSO_LINGER_SET;
						TcpIoctl(&inst->Clients[clientIdx].FB_TcpIoctl);
						if (inst->Clients[clientIdx].FB_TcpIoctl.status != BUSY)
						{
							inst->Clients[clientIdx].State = 11;
						}
						break;
						
					case 11: /* catch errors */
						if (inst->Error == 0 && inst->Enable)
							inst->Clients[clientIdx].State = 2;
						else
							break;
						
					case 2: /* Receive */
						TcpRecv(&inst->Clients[clientIdx].FB_TcpRecv);
						if (inst->Clients[clientIdx].FB_TcpRecv.status == BUSY ||
						inst->Clients[clientIdx].FB_TcpRecv.status == DISABLED ||
						inst->Clients[clientIdx].FB_TcpRecv.status == tcpERR_NO_DATA)
						{
							; /* No data received */
						}
						else if (inst->Clients[clientIdx].FB_TcpRecv.status == tcpERR_NOT_CONNECTED ||
							inst->Clients[clientIdx].FB_TcpRecv.status != 0) /* If any error, typically if client disconnected, remove client */
						{
							inst->Clients[clientIdx].State = 99; /* Disconnect client */
						}
						else if (inst->Clients[clientIdx].FB_TcpRecv.status == 0) /* Frame received */
						{
							inst->Clients[clientIdx].ResponseByteSize = BRSE_MBT_AnalyzeReqFromClient(inst, clientIdx);
							if (inst->Clients[clientIdx].ResponseByteSize > 0)
							{
								inst->Clients[clientIdx].FB_TcpSend.datalen = inst->Clients[clientIdx].ResponseByteSize;
								inst->Clients[clientIdx].State = 3; /* Send response */
							}
							else /* Client has disconnected */
 							{
								inst->Clients[clientIdx].State = 99;
							}
							/* Fall through! */
						}
						inst->IsBusy = inst->IsBusy || inst->Clients[clientIdx].FB_TcpRecv.status == BUSY;
						if (inst->Clients[clientIdx].State != 3)
							break;
						/* Beware! Fall through if state is 3 */
				
					case 3: /* Send response */
						TcpSend(&inst->Clients[clientIdx].FB_TcpSend);
						if( (inst->Clients[clientIdx].FB_TcpSend.status == BUSY	) 	||
							(inst->Clients[clientIdx].FB_TcpSend.status == DISABLED)||
							(inst->Clients[clientIdx].FB_TcpSend.status == tcpERR_SENTLEN)	)
						{
							;
						}
						else if(inst->Clients[clientIdx].FB_TcpSend.status != 0) /* Disconnect client */
						{
							if (inst->LogIndex < BRSE_MBT_LOG_MAX)
							{
								strcpy(inst->Log[inst->LogIndex], "TcpSend error: ");
								itoa(inst->Clients[clientIdx].FB_TcpSend.status, (UDINT)inst->TmpStr);
								strcat(inst->Log[inst->LogIndex], inst->TmpStr);
								strcat(inst->Log[inst->LogIndex], " ");
								strcat(inst->Log[inst->LogIndex], inst->Clients[clientIdx].Info.IpAddr);
								inst->LogIndex++;
							}
							inst->Clients[clientIdx].State = 99;
						}
						else /* Back to receive */
						{
							memset(inst->Clients[clientIdx].RecvBuffer, 0, sizeof(inst->Clients[clientIdx].RecvBuffer));
							memset(inst->Clients[clientIdx].SendBuffer, 0, sizeof(inst->Clients[clientIdx].SendBuffer));
							inst->Clients[clientIdx].State = 2;
						}
						inst->IsBusy = inst->IsBusy || inst->Clients[clientIdx].FB_TcpSend.status == BUSY;
						break;
				}
			}
			
			if (!inst->IsBusy && inst->Error != 0)
			{
				inst->Step = 70;
			}
			else if (!inst->Enable && !inst->IsBusy) /* If disabled, move to idle */
			{
				if (inst->LogIndex < BRSE_MBT_LOG_MAX && inst->Step != 15)
				{
					strcpy(inst->Log[inst->LogIndex], "FUB Disabled. Go to idle");
					inst->LogIndex++;
				}	
				inst->Step = 15; /* idle */
			}
			break;
			
		case 70:	/* Error: close server connection */
			inst->FB_TcpCloseServer.enable = 1;
			inst->FB_TcpCloseServer.ident	= BRSE_MBT_ServerInternal.TcpOpenIdent;
			inst->FB_TcpCloseServer.how = 0; /*tcpSHUT_RD | tcpSHUT_WR;*/
			TcpClose(&inst->FB_TcpCloseServer);
			if(inst->FB_TcpCloseServer.status != BUSY)
			{
				/* Remove all clients */
				for (clientIdx = 0 ; clientIdx<BRSE_MBT_MAX_CLIENT ; clientIdx++)
				{
					BRSE_MBT_RemoveClient(inst, clientIdx);
				}
				inst->ClientNr = 0;
				inst->Step = 0;
				BRSE_MBT_ServerInternal.TcpOpenIdent = 0;
				if (inst->LogIndex < BRSE_MBT_LOG_MAX)
				{
					strcpy(inst->Log[inst->LogIndex], "Disconnect server: ");
					itoa(inst->FB_TcpCloseServer.status, (UDINT)inst->TmpStr);
					strcat(inst->Log[inst->LogIndex], inst->TmpStr);
					strcat(inst->Log[inst->LogIndex], " ");
					inst->LogIndex++;
				}
			}
			break;
		
	}
	if (inst->LogIndex == BRSE_MBT_LOG_MAX)
	{
		inst->LogIndex = 0;
	}
	strcpy(inst->Log[inst->LogIndex], "");
	
	//Disconnect old inactive clients                                                                                                                          
	for(clientIdx = 0; clientIdx<BRSE_MBT_MAX_CLIENT; clientIdx++) /* Loop through clients and see if they are to be closed */
	{
		inst->Clients[clientIdx].TON_Disconnect.PT = BRSE_DISCONNECT_TIMEOUT;
		if (inst->Clients[clientIdx].State == 2 )
		{
			inst->Clients[clientIdx].TON_Disconnect.IN = 1;
		}
		else
		{
			 inst->Clients[clientIdx].TON_Disconnect.IN = 0;
		}
		if (inst->Clients[clientIdx].TON_Disconnect.Q)	//Close client
		{
			inst->Clients[clientIdx].TON_Disconnect.IN = 0;
			inst->Clients[clientIdx].State = 99;
		}
		TON(&inst->Clients[clientIdx].TON_Disconnect);
	}
}

/* Returns number of bytes in possible response message */
UINT BRSE_MBT_AnalyzeReqFromClient(struct BRSE_MBT_Server* inst, UINT clientIdx)
{
	UINT uintVar;
	UINT length;
	
	/* Check for tcp length errors */
	if (inst->Clients[clientIdx].FB_TcpRecv.recvlen == 0) /* client closed the connection */
	{
		return 0;
	}
	else if (inst->Clients[clientIdx].FB_TcpRecv.recvlen < 8)
	{
		return BRSE_MBT_CreateErrorMessage(inst, BRSE_MB_ERR_ILLEGAL_DATA_VALUE, clientIdx);
	}
	else if (inst->Clients[clientIdx].FB_TcpRecv.recvlen > BRSE_MBT_MAX_BUFFER)
	{
		return BRSE_MBT_CreateErrorMessage(inst, BRSE_MB_ERR_ILLEGAL_RESPONSE_LEN, clientIdx);
	}
	
	/* Parse tcp message information. Byte 0-5 */
	memcpy(&uintVar, &(inst->Clients[clientIdx].RecvBuffer[0]), sizeof(uintVar));
	inst->Clients[clientIdx].Request.TransactionId = SWAPUINT(uintVar);
	memcpy(&uintVar, &(inst->Clients[clientIdx].RecvBuffer[2]), sizeof(uintVar));
	inst->Clients[clientIdx].Request.ProtocolId = SWAPUINT(uintVar);
	memcpy(&uintVar,&(inst->Clients[clientIdx].RecvBuffer[4]), sizeof(uintVar));
	inst->Clients[clientIdx].Request.Length = SWAPUINT(uintVar);
	
	/* Validate tcp message information */
	if(	(inst->Clients[clientIdx].Request.ProtocolId	!= 0) || (inst->Clients[clientIdx].Request.Length == 0)) 
	{
		return BRSE_MBT_CreateErrorMessage(inst, BRSE_MB_ERR_ILLEGAL_DATA_VALUE, clientIdx);
	}
	
	/* Run message through MB_Server. Byte 6 is unit id. */
	inst->FB_BRSE_MB_Server.Unit = inst->Clients[clientIdx].RecvBuffer[6];
	inst->FB_BRSE_MB_Server.ClientFormat = inst->ClientFormat;
	memcpy(inst->FB_BRSE_MB_Server.InputBuffer, &(inst->Clients[clientIdx].RecvBuffer[7]), 254); /* 254 is sizeof input buffer */
	BRSE_MB_Server(&inst->FB_BRSE_MB_Server);
	
	/* Check for message errors */
	if (inst->FB_BRSE_MB_Server.Status == BRSE_MB_ERR_ILLEGAL_FUNCTION)
		return BRSE_MBT_CreateErrorMessage(inst, BRSE_MB_ERR_ILLEGAL_FUNCTION, clientIdx);
	else if (inst->FB_BRSE_MB_Server.Status == BRSE_MB_ERR_ILLEGAL_DATA_ADDRESS)
		return BRSE_MBT_CreateErrorMessage(inst, BRSE_MB_ERR_ILLEGAL_DATA_ADDRESS, clientIdx);
	else if (inst->FB_BRSE_MB_Server.Status == BRSE_MB_ERR_ILLEGAL_DATA_VALUE)
		return BRSE_MBT_CreateErrorMessage(inst, BRSE_MB_ERR_ILLEGAL_DATA_VALUE, clientIdx);
	else if (inst->FB_BRSE_MB_Server.Status == BRSE_MB_ERR_ILLEGAL_RESPONSE_LEN)
		return BRSE_MBT_CreateErrorMessage(inst, BRSE_MB_ERR_ILLEGAL_RESPONSE_LEN, clientIdx);
	else if (inst->FB_BRSE_MB_Server.Status != 0)
		return BRSE_MBT_CreateErrorMessage(inst, BRSE_MB_ERR_ILLEGAL_DATA_VALUE, clientIdx);
	
	/* Message ok. Create response */
	/* Transaction id: 2 byte */
	memcpy(&inst->Clients[clientIdx].SendBuffer[0], &inst->Clients[clientIdx].RecvBuffer[0], sizeof(uintVar));
	/* Protocol id: 2 byte */
	memcpy(&inst->Clients[clientIdx].SendBuffer[2], &inst->Clients[clientIdx].RecvBuffer[2], sizeof(uintVar));
	/* Length: 2 byte */
	length = 1 + inst->FB_BRSE_MB_Server.BufferLength; /* The extra byte is the unit identifier */
	uintVar = SWAPUINT(length);
	memcpy(&inst->Clients[clientIdx].SendBuffer[4], &uintVar, sizeof(uintVar));
	/* Unit: 1 byte */
	inst->Clients[clientIdx].SendBuffer[6] = inst->Clients[clientIdx].RecvBuffer[6];
	/* Message response */
	memcpy(&inst->Clients[clientIdx].SendBuffer[7], &inst->FB_BRSE_MB_Server.OutputBuffer[0], 254);
	return 7 + inst->FB_BRSE_MB_Server.BufferLength; /* Number of bytes to be sent */
}

UINT BRSE_MBT_AddClient(struct BRSE_MBT_Server* inst)
{
	INT index = -1;
	UINT i = 0;
	
	if (inst->ClientNr < BRSE_MBT_MAX_CLIENT)
	{
		/* Check if client has already connedted before */
		for (i=0; i < BRSE_MBT_MAX_CLIENT; i++)
		{
			/* Check if client was already connected, in that case: reconnect that client */
			if (inst->Clients[i].Info.Ident != 0 && !memcmp(inst->Clients[i].Info.IpAddr, inst->NewClient.IpAddr, sizeof(inst->NewClient.IpAddr)) && inst->FB_TcpServer.identclnt == inst->Clients[i].Info.Ident )
			{
				inst->NewClient.CloseIdent = inst->Clients[i].Info.Ident; /* Make sure the old client handle gets closed */
				BRSE_MBT_RemoveClient(inst, i);
				index = i;
			}
		}
		/* New client */
		if (index < 0)
		{
			/* Find first avilable index */
			for (i=0; i < BRSE_MBT_MAX_CLIENT; i++)
			{
				if (index<0 && inst->Clients[i].Info.Ident == 0)
				{
					index=i;					
				}
			}
		}
		if (index<0) /* No more clients allowed */
			return BRSE_MBT_ERR_TOO_MANY_CLIENTS;
		
		/* Save client info */
		inst->Clients[index].Info.Ident = inst->FB_TcpServer.identclnt;
		inst->Clients[index].Info.Port = inst->FB_TcpServer.portclnt;
		memcpy(inst->Clients[index].Info.IpAddr, inst->NewClient.IpAddr, sizeof(inst->NewClient.IpAddr));
		
		/* Initialize TcpRecv */
		inst->Clients[index].FB_TcpRecv.enable = 1;
		inst->Clients[index].FB_TcpRecv.ident = (UDINT)inst->FB_TcpServer.identclnt;
		inst->Clients[index].FB_TcpRecv.pData = (UDINT)inst->Clients[index].RecvBuffer;
		inst->Clients[index].FB_TcpRecv.datamax = BRSE_MBT_MAX_BUFFER+1;
		inst->Clients[index].FB_TcpRecv.flags = 0;
		
		/* Initialize TcpSend */
		inst->Clients[index].FB_TcpSend.enable = 1;
		inst->Clients[index].FB_TcpSend.flags = 0;
		inst->Clients[index].FB_TcpSend.ident = (UDINT)inst->FB_TcpServer.identclnt;
		inst->Clients[index].FB_TcpSend.pData = (UDINT)inst->Clients[index].SendBuffer;
		
		/* Client counter */
		inst->ClientNr++;
		
		/* Start receiving data */
		inst->Clients[index].State = 1;
		
		/* Write log message */
		if (inst->LogIndex < BRSE_MBT_LOG_MAX)
		{
			memset(inst->Log[inst->LogIndex], 0, sizeof(inst->Log[inst->LogIndex]));
			memcpy(inst->Log[inst->LogIndex], inst->NewClient.IpAddr, sizeof(inst->NewClient.IpAddr));
			strcat(inst->Log[inst->LogIndex], " connected on id:");
			itoa(inst->FB_TcpServer.identclnt, (UDINT)inst->TmpStr);
			strcat(inst->Log[inst->LogIndex], inst->TmpStr);
			inst->LogIndex++;
		}
		return 0;
	}
	else
	{
		return BRSE_MBT_ERR_TOO_MANY_CLIENTS;
	}
	return 0;
}

void BRSE_MBT_RemoveClient(struct BRSE_MBT_Server* inst, UINT clientIdx)
{
	if (inst->ClientNr > 0)
	{
		if (inst->LogIndex < BRSE_MBT_LOG_MAX)
		{
			memset(inst->Log[inst->LogIndex], 0, sizeof(inst->Log[inst->LogIndex]));
			memcpy(inst->Log[inst->LogIndex], inst->Clients[clientIdx].Info.IpAddr, sizeof(inst->Clients[clientIdx].Info.IpAddr));
			strcat(inst->Log[inst->LogIndex], " removed");
			inst->LogIndex++;
		}
		inst->Clients[clientIdx].FB_TcpRecv.enable = 0;
		inst->Clients[clientIdx].FB_TcpSend.enable = 0;
		inst->Clients[clientIdx].State = 0;
		inst->Clients[clientIdx].Info.Ident = 0;
		memset(inst->Clients[clientIdx].Info.IpAddr, 0, sizeof(inst->Clients[clientIdx].Info.IpAddr));
		inst->Clients[clientIdx].Info.Port = 0;
		memset(inst->Clients[clientIdx].SendBuffer, 0, sizeof(inst->Clients[clientIdx].SendBuffer));
		memset(inst->Clients[clientIdx].RecvBuffer, 0, sizeof(inst->Clients[clientIdx].RecvBuffer));
		inst->ClientNr--;
	}
}

UINT BRSE_MBT_CreateErrorMessage(struct BRSE_MBT_Server* inst, UINT errorCode, UINT clientIdx)
{
	UINT	length;
	UINT	uintVar;
	
	memset(inst->Clients[clientIdx].SendBuffer, 0, sizeof(inst->Clients[clientIdx].SendBuffer));
	/* Transaction id: 2 byte */
	uintVar = SWAPUINT(inst->Clients[clientIdx].Request.TransactionId);
	memcpy(&inst->Clients[clientIdx].SendBuffer[0], &inst->Clients[clientIdx].RecvBuffer[0], sizeof(uintVar));
	/* Protocol id: 2 byte */
	uintVar = SWAPUINT(inst->Clients[clientIdx].Request.ProtocolId);
	memcpy(&inst->Clients[clientIdx].SendBuffer[2], &inst->Clients[clientIdx].RecvBuffer[2], sizeof(uintVar));
	/* Length: 2 byte */
	length = 3;
	uintVar = SWAPUINT(length);
	memcpy(&inst->Clients[clientIdx].SendBuffer[4], &uintVar, sizeof(uintVar));
	/* Unit: 1 byte */
	inst->Clients[clientIdx].SendBuffer[6] = inst->Clients[clientIdx].RecvBuffer[6];
	/* Function code: 1 byte */
	inst->Clients[clientIdx].SendBuffer[7] = inst->Clients[clientIdx].RecvBuffer[7] +  0x80;
	/* Exception code: 1 byte */
	inst->Clients[clientIdx].SendBuffer[8] = errorCode;
	return 9;
}

/*!
	\interface MBT_ServerExit
	\brief Server: Closes open tcp ports. Use this in the exit routine of the program.
	
	\param[out] Status	Return status. 
	
*/
void MBT_ServerExit(struct MBT_ServerExit* inst)
{
	if (BRSE_MBT_ServerInternal.TcpOpenIdent != 0)
	{
		inst->FB_TcpClose.enable = 1;
		inst->FB_TcpClose.ident	= BRSE_MBT_ServerInternal.TcpOpenIdent;
		inst->FB_TcpClose.how = tcpSHUT_RD | tcpSHUT_WR;
		TcpClose(&inst->FB_TcpClose);
		if(inst->FB_TcpClose.status != BUSY)
		{
			BRSE_MBT_ServerInternal.TcpOpenIdent = 0;
		}
	}
}
