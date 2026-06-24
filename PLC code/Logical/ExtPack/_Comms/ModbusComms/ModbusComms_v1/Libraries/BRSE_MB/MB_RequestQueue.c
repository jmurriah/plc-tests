/*! \file MB_RequestQueue.c */

#include <bur/plctypes.h>
#include "BRSE_MB.h"
#include "BRSE_MB_Main.h"

#define	BUSY				65535

extern MB_ClientStruct_typ gMB_ClientInternal;

UINT MB_AckClientRequest(USINT ClientID, UINT ReturnStatus)
{
	MB_Client_typ *pQueue;
	MB_ClientQueueItem_typ *pQueueItem;
	UINT status = 0;
	
	if (gMB_ClientInternal.pClients[ClientID] == 0)
		return MB_ERR_CLIENT_NOT_ALLOCATED;
	
	pQueue = (MB_Client_typ *)gMB_ClientInternal.pClients[ClientID];
	if ((*pQueue).Lock)
	{
		status = BUSY;
		return status;
	}
	
	/* -- Begin synchronized block -- */
	(*pQueue).Lock = 1; /* prevent others from reading from / writing to queue */
	pQueueItem = &((*pQueue).Queue[(*pQueue).IndexExec]);
	(*((UINT *) ((*pQueueItem).StatusAddr))) = ReturnStatus;
	(*pQueue).IndexExec++;
	(*pQueue).IndexExec %= (MB_QUEUE_SIZE+1);
	memset(pQueueItem, 0, sizeof(*pQueueItem));
	(*pQueue).Lock = 0;
	/* -- End synchronized block -- */
	return status;
}

UINT MB_AddToRequestQueue(USINT clientID, USINT fc, UINT quantity, UINT startAddress, UDINT variableAddress, UDINT statusAddress, USINT Unit)
{
	MB_Client_typ *pQueue;
	MB_ClientQueueItem_typ *pQueueItem;
	UINT status = 0;
	
	if (gMB_ClientInternal.pClients[clientID] == 0)
		return MB_ERR_CLIENT_NOT_ALLOCATED;
	
	pQueue = (MB_Client_typ *)gMB_ClientInternal.pClients[clientID];
	if ((*pQueue).Lock)
	{
		status = BUSY;
		return status;
	}
	
	/* -- Begin synchronized block -- */
	(*pQueue).Lock = 1; /* prevent others from reading from / writing to queue */	
	pQueueItem = &((*pQueue).Queue[(*pQueue).IndexInsert]);
	if (((*pQueue).IndexExec == (*pQueue).IndexInsert) && ((*pQueueItem).VariableAddr != 0))
	{	
		status = MB_ERR_QUEUE_FULL;
	}
	else
	{
		(*((UINT *)statusAddress)) = BUSY;
		(*pQueueItem).Request.Unit = Unit;			
		(*pQueueItem).Request.Quantity = quantity;
		(*pQueueItem).Request.Type = fc;
		(*pQueueItem).Request.StartAddr = startAddress;
		(*pQueueItem).VariableAddr = variableAddress;
		(*pQueueItem).StatusAddr = statusAddress;
		(*pQueue).IndexInsert++;
		(*pQueue).IndexInsert %= (MB_QUEUE_SIZE+1);			
	}
	(*pQueue).Lock = 0;
	/* -- End synchronized block -- */	
	return status;
}

USINT MB_QueueStatus(USINT ClientID)
{
	MB_Client_typ *pQueue;
	USINT status = 0;
	
	if (gMB_ClientInternal.pClients[ClientID] == 0)
		return 0;
	
	pQueue = (MB_Client_typ *)gMB_ClientInternal.pClients[ClientID];
	if ((*pQueue).Lock)
	{
		return 1;
	}
	/* Synchronized block */
	(*pQueue).Lock = 1;
	if ((*pQueue).IndexExec == (*pQueue).IndexInsert) /* queue empty */
		status = 0;
	else
		status = 1;
	(*pQueue).Lock = 0;
	/* Synchronized end */
	return status;
}
