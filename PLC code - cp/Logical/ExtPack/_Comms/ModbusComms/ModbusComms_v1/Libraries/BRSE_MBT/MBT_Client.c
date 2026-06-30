/*! \file MBT_Client.c */

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
#define DISABLE		65534

MBT_ClientInternal_typ BRSE_MBT_ClientInternal;

UDINT MBT_GetClientInternalStructAddr()
{
	return (UDINT)&BRSE_MBT_ClientInternal;
}

/*!
	\interface MBT_Client
	\brief Client: Create a connection to a physical Ethernet Port and open port 502 and starts	send requests and listen to response according to internal queue.

	\param[in]	Enable	Enables execution of the function.
	\param[in]	ServerFormat	Set the format of 4 byte variables to Intel or Motorola. BRSE_MB_INTEL / BRSE_MB_MOTOROLA
	\param[in]	ClientID	Identity created in AllocClient.
	\param[in]	IpAddr	Ip address to the modbus server.
	\param[in]	Port	Port on the modbus server.
	\param[in]	ConnectionTimeout	This input specifies the time in milliseconds that the client waits for new requests before closing the connection. If the input is zero, the connection is left open to the server until next request.
	\param[in]	SocketTimeout	Time in seconds that the system keeps the socket alive after closing it. This can be used as the oposite station still has some data to send. If the input is zero, the socket is closed immediately.
	\param[out] Status	Return status. 
*/
void MBT_Client(struct MBT_Client* inst)
{
	UINT uintSwapped;
	inst->Status = BUSY;
	switch(inst->Step)
	{
		case 0: /* init */
			inst->FB_TcpSend.enable = 1;
			inst->FB_TcpSend.pData = (UDINT)&(inst->SendBuffer[0]);
			inst->FB_TcpRecive.enable = 1;
			inst->FB_TcpRecive.pData = (UDINT)&(inst->ReceiveBuffer[0]);
			inst->FB_TcpRecive.datamax = sizeof(inst->ReceiveBuffer);
			inst->FB_TcpOpen.options = 0;
			inst->FB_TcpOpen.enable = 1;
			inst->FB_TcpOpen.port = 0;
			inst->FB_TcpClient.enable = 1;
			inst->FB_TcpClose.enable = 1;
			inst->FB_RTInfo.enable = 1;
			inst->FB_TcpIoctl.enable = 1;
			inst->ElapsedTime = 0;
			inst->Step = 1;
			
			/* beware: fall-through */
		
		case 1: /* Get cycle time */
			RTInfo(&inst->FB_RTInfo);
			if (inst->FB_RTInfo.status == 0)
			{	
				inst->CycleTimeMs = inst->FB_RTInfo.cycle_time/1000; /* Convert to millis from micros */
				inst->Step = 10;
			}
			else if (inst->FB_RTInfo.status != ERR_FUB_BUSY) 
			{
				inst->Status = inst->FB_RTInfo.status;
				break;
			}
			/* beware: fall-through */
			
		case 10: /* enable/disable */
			inst->ErrorStatus = 0;
			if (inst->Enable)
				inst->Step = 20;
			else
				break;
			/* beware: fall-through if enabled */
		
		case 20: /* Get request from queue */
			memset(&(inst->SendBuffer[0]), 0, sizeof(inst->SendBuffer));
			memset(&(inst->ReceiveBuffer[0]), 0, sizeof(inst->ReceiveBuffer));
			inst->ElapsedTime = 0;
			inst->ResendCounter = 0;
			inst->Step = 21;
			/* beware: fall-through */
		
		case 21:	
			inst->ElapsedTime += inst->CycleTimeMs;
			inst->FB_MB_CreateClientRequest.AdrByteBuffer = (UDINT)&inst->SendBuffer[7];
			inst->FB_MB_CreateClientRequest.ByteBufferLen = BRSE_MBT_MAX_BUFFER-7;
			inst->FB_MB_CreateClientRequest.ClientID = inst->ClientID;
			inst->FB_MB_CreateClientRequest.ServerFormat = inst->ServerFormat;
			MB_CreateClientRequest(&inst->FB_MB_CreateClientRequest);
			if (inst->FB_MB_CreateClientRequest.Status == 0 && inst->FB_MB_CreateClientRequest.RequestBufferLen > 0)
			{
				/* Fill tcp-specifics */
				uintSwapped = SWAPUINT(inst->TransactionId);
				memcpy(&(inst->SendBuffer[0]), &uintSwapped, 2); 								/* Transaction ID: 2 byte */
				uintSwapped = 0;
				memcpy(&(inst->SendBuffer[2]), &uintSwapped, 2); 								/* Protocol id: 2 byte */
				uintSwapped = SWAPUINT(inst->FB_MB_CreateClientRequest.RequestBufferLen + 1);
				memcpy(&inst->SendBuffer[4], &uintSwapped, 2); 									/* Length: 2 bytes */
				inst->SendBuffer[6] = inst->FB_MB_CreateClientRequest.Unit;						/* Unit: 1 byte */
				/* 7... Modbus message */
				/* Filled in by FB_MB_CreateClientRequest */
				inst->FB_TcpSend.datalen = 7 + inst->FB_MB_CreateClientRequest.RequestBufferLen;
				inst->Step = 30;
				
				if (!inst->Enable)
					inst->Step = 10;
			}
			else if (inst->FB_MB_CreateClientRequest.Status == 0 && inst->ConnectionTimeout > 0 && inst->ElapsedTime >= inst->ConnectionTimeout && BRSE_MBT_ClientInternal.TcpOpenIdent[inst->ClientID] != 0) /* queue empty disconnect client at timeout */
			{
				inst->Step = 70; /* close inactive client connection */
				inst->ElapsedTime = 0;
			}
			else
			{
				inst->Status = inst->FB_MB_CreateClientRequest.Status;
				if (!inst->Enable)
					inst->Step = 10;				
			}
			if (inst->Step != 30)
				break;
		
		case 30:
			if (BRSE_MBT_ClientInternal.TcpOpenIdent[inst->ClientID] == 0) /* port not open */
				inst->Step = 31;
			else
				inst->Step = 40;
			
			if (inst->Step != 31)
				break;	
			/* beware: fall-through on state 31 */
			
		case 31: /* open port */
			TcpOpen(&inst->FB_TcpOpen);
			if (inst->FB_TcpOpen.status == 0)
			{
				BRSE_MBT_ClientInternal.TcpOpenIdent[inst->ClientID] = inst->FB_TcpOpen.ident;
				inst->FB_TcpClient.ident = BRSE_MBT_ClientInternal.TcpOpenIdent[inst->ClientID];
				inst->FB_TcpClient.pServer = (UDINT)inst->IpAddr;
				inst->FB_TcpClient.portserv = inst->Port;
				inst->FB_TcpRecive.ident = BRSE_MBT_ClientInternal.TcpOpenIdent[inst->ClientID];
				inst->FB_TcpSend.ident = BRSE_MBT_ClientInternal.TcpOpenIdent[inst->ClientID];
				inst->Step = 32;
			}
			else if (inst->FB_TcpOpen.status == tcpERR_SOCKET_CREATE)  /* just wait for a socket */
			{
				;
			}
			else if (inst->FB_TcpOpen.status != BUSY) /* error, close down and return error on request */
			{
				inst->ErrorStatus = inst->FB_TcpOpen.status;
				inst->Step = 90;
				inst->Timeout = 0;
			}
			break;
		
		case 32: /* linger options */
			inst->LingerOptions.lOnOff = 1;
			inst->LingerOptions.lLinger = inst->SocketTimeout;
			inst->FB_TcpIoctl.ident = BRSE_MBT_ClientInternal.TcpOpenIdent[inst->ClientID];
			inst->FB_TcpIoctl.ioctl = tcpSO_LINGER_SET;
			inst->FB_TcpIoctl.pData = (UDINT)&inst->LingerOptions;
			inst->FB_TcpIoctl.datalen = sizeof(inst->LingerOptions);
			TcpIoctl(&inst->FB_TcpIoctl);
			if (inst->FB_TcpIoctl.status != BUSY)
			{
				inst->Step = 33;
			}
			break;
			
		case 33: /* client */
			TcpClient(&inst->FB_TcpClient);
			if(inst->FB_TcpClient.status == 0)
			{
				inst->Step = 40;
			}
			else if (inst->FB_TcpClient.status != BUSY) /* error, close down and return error on request */
			{
				inst->ErrorStatus = inst->FB_TcpClient.status;
				inst->Step = 90;
			}
			break;
			
		case 40: /* Send request */
			inst->FB_TcpSend.enable = 1;
			TcpSend(&inst->FB_TcpSend);
			if ( (inst->FB_TcpSend.status == BUSY) || 
					(inst->FB_TcpSend.status == tcpERR_WOULDBLOCK) ||
					(inst->FB_TcpSend.status == tcpERR_SENTLEN))
			{
				;
			}
			else if (inst->FB_TcpSend.status == 0)
			{
				inst->Step = 41;
				inst->ElapsedTime = 0;
			}
			else /* Error sending request */
			{
				inst->ErrorStatus = inst->FB_TcpSend.status;
				inst->Step = 90;
			}
			break;
		
		case 41: /* Receive response */
			inst->ElapsedTime += inst->CycleTimeMs;
			TcpRecv(&inst->FB_TcpRecive);
			if( (inst->FB_TcpRecive.status == BUSY				) 	||
				(inst->FB_TcpRecive.status == DISABLE			)	)
			{
				;
			}
			else if (inst->FB_TcpRecive.status == tcpERR_NO_DATA) /* send timeout */
			{
				if (inst->ElapsedTime > MBT_RECEIVE_TIMEOUT && inst->ResendCounter <= BRSE_MBT_RESEND_LIMIT)
				{
					inst->ResendCounter++;
					inst->Step = 40; /* re-send */
				}
				else if (inst->ElapsedTime > MBT_RECEIVE_TIMEOUT)
				{
					inst->Step = 90; /* failed, no response */
				}				
			}
			else if(inst->FB_TcpRecive.status == 0)
			{
				if(inst->FB_TcpRecive.recvlen > 8 && inst->FB_TcpRecive.recvlen < (BRSE_MBT_MAX_BUFFER+1))
				{
					memcpy(&uintSwapped, &(inst->ReceiveBuffer[0]), sizeof(uintSwapped));
					inst->RecvTransactionId = SWAPUINT(uintSwapped);
					if (inst->RecvTransactionId == inst->TransactionId)
					{
						if (inst->ReceiveBuffer[2] != 0 || inst->ReceiveBuffer[3] != 0 || (inst->ReceiveBuffer[4] == 0 && inst->ReceiveBuffer[5] == 0) )
						{
							inst->Step = 51; /* Illegal response */
						}
						else
						{
							memcpy(&uintSwapped, &(inst->ReceiveBuffer[4]), 2);
							inst->RecvLen = SWAPUINT(uintSwapped);
							inst->Step = 50; /* Put answer */
						}
					}
				}
				else if (inst->FB_TcpRecive.recvlen == 0) /* other side performed a tcp close. return error on request */
				{
					inst->Step = 90;
				}
				else
				{ 
					inst->Step = 51;	
				}
			}
			else
			{
				inst->ErrorStatus = inst->FB_TcpRecive.status;
				inst->Step = 90;
			}
			break;
			
		case 50: /* put response */
			inst->FB_MB_PutClientResponse.AdrByteBuffer = (UDINT)&(inst->ReceiveBuffer[7]);
			inst->FB_MB_PutClientResponse.ByteBufferLen = inst->RecvLen -1 ;
			inst->FB_MB_PutClientResponse.ClientID = inst->ClientID;
			inst->FB_MB_PutClientResponse.ServerFormat = inst->ServerFormat;
			MB_PutClientResponse(&inst->FB_MB_PutClientResponse);
			if (inst->FB_MB_PutClientResponse.Status != BUSY) /* ok, done. does not matter if error or not. */
			{
				memset(&(inst->SendBuffer[0]), 0, sizeof(inst->SendBuffer));
				inst->Step = 10;
				inst->TransactionId++;
			}
			break;
		
		case 51: /* put error response */
			memset(&(inst->SendBuffer[0]), 0, sizeof(inst->SendBuffer));
			inst->Status = MB_AckClientRequest(inst->ClientID, MB_ERR_PROTOCOL);
			if (inst->Status != BUSY)
			{
				inst->Step = 10;
				inst->TransactionId++;
			}
			break;
		
		case 70: /* disconnect inactive client connection */
			inst->FB_TcpClose.ident	= BRSE_MBT_ClientInternal.TcpOpenIdent[inst->ClientID];
			inst->FB_TcpClose.how = 0;
			TcpClose(&inst->FB_TcpClose);
			if(inst->FB_TcpClose.status != BUSY)
			{
				BRSE_MBT_ClientInternal.TcpOpenIdent[inst->ClientID] = 0;
				inst->Step = 10;
			}
			break;
		
		case 90: /* Error */
			if (BRSE_MBT_ClientInternal.TcpOpenIdent[inst->ClientID] == 0)
			{
				inst->Step = 91;
			}
			else
			{
				inst->FB_TcpClose.ident	= BRSE_MBT_ClientInternal.TcpOpenIdent[inst->ClientID];
				inst->FB_TcpClose.how = 0;
				TcpClose(&inst->FB_TcpClose);
				if(inst->FB_TcpClose.status != BUSY)
				{
					BRSE_MBT_ClientInternal.TcpOpenIdent[inst->ClientID] = 0;
					inst->Step = 91;
				}
			}
			break;
		
		case 91:
			memset(&(inst->SendBuffer[0]), 0, sizeof(inst->SendBuffer));
			inst->Status = MB_AckClientRequest(inst->ClientID, MB_ERR_CONNECTION);
			if (inst->Status != BUSY)
			{
				inst->Step = 10;
				inst->TransactionId++;
			}
			break;		
	}
}

/*!
	\interface MBT_ExitClient
	\brief Client: Closes open tcp ports. Use this in the exit routine of the program.
	
	\param[in] 	ClientID	Identity created in AllocClient.
	\param[out] Status	Return status. 
	
*/
void MBT_ExitClient(struct MBT_ExitClient* inst)
{
	if (BRSE_MBT_ClientInternal.TcpOpenIdent[inst->ClientID] != 0)
	{
		inst->FB_TcpClose.enable = 1;
		inst->FB_TcpClose.ident	= BRSE_MBT_ClientInternal.TcpOpenIdent[inst->ClientID];
		inst->FB_TcpClose.how = tcpSHUT_RD | tcpSHUT_WR;
		TcpClose(&inst->FB_TcpClose);
		if(inst->FB_TcpClose.status != BUSY)
		{
			BRSE_MBT_ClientInternal.TcpOpenIdent[inst->ClientID] = 0;
		}
	}
}
