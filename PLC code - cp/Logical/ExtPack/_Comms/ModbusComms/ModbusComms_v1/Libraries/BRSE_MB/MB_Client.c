/*! \file MB_Client.c */

#include <bur/plctypes.h>
#include "BRSE_MB.h"
#include "BRSE_MB_Main.h"

/***************************/
/* Necessary byte swapping */
/***************************/
#ifdef _SG4
	#define SWAPUINT	swapUINT
	#define SWAPINT		swapINT
#else
	#define SWAPUINT	
	#define SWAPINT
#endif

#define	BUSY				65535

MB_ClientStruct_typ gMB_ClientInternal;

UDINT MB_GetClient(USINT ClientID)
{
	return gMB_ClientInternal.pClients[ClientID];
}

/*! \interface MB_AllocClient
	\brief Client: Allocate memory for internal data (request queue etc.)
	\param ClientID Client ID to allocate.
	\retval DataAddress DataAddress to internal structure. Used for debug purposes. Same value as MB_GetClient returns.
*/
UDINT MB_AllocClient(unsigned char ClientID)
{
	UINT status = 0;
	if (gMB_ClientInternal.pClients[ClientID] != 0)
	{
		return gMB_ClientInternal.pClients[ClientID];
	}
	status = TMP_alloc(sizeof(MB_Client_typ) , (void **)&(gMB_ClientInternal.pClients[ClientID]));
	if (status == 0)
	{
		memset((void *)gMB_ClientInternal.pClients[ClientID], 0, sizeof(MB_Client_typ));
	}
	else
	{
		ERRxwarning(status,(UDINT)gMB_ClientInternal.pClients[ClientID],(void *)"MBClient: No memory!");
		gMB_ClientInternal.pClients[ClientID] = 0;
	}
	return gMB_ClientInternal.pClients[ClientID];
}

void MB_CreateClientRequest(struct MB_CreateClientRequest* inst)
{
	MB_Client_typ *pQueue;
	MB_ClientQueueItem_typ *pQueueItem;
	USINT *pByteBuffer = (USINT *)inst->AdrByteBuffer;
	UINT uintSwapped;
	
	if (gMB_ClientInternal.pClients[inst->ClientID] == 0)
	{
		inst->Status = MB_ERR_CLIENT_NOT_ALLOCATED;
		inst->RequestBufferLen = 0;
		return;
	}
	pQueue = (MB_Client_typ *)gMB_ClientInternal.pClients[inst->ClientID];
	pQueueItem = &((*pQueue).Queue[(*pQueue).IndexExec]);
	if ((*pQueue).IndexExec == (*pQueue).IndexInsert && ((*pQueueItem).VariableAddr == 0)) /* No request in queue */
	{
		inst->Status = 0;
		inst->RequestBufferLen = 0;
		return;
	}
	else if (inst->ByteBufferLen < 5 || inst->AdrByteBuffer == 0)
	{
		inst->Status = MB_ERR_BUFFER;
		inst->RequestBufferLen = 0;
		return;
	}
	pByteBuffer[0] = (*pQueueItem).Request.Type; 					/* function code */
	uintSwapped = SWAPUINT((*pQueueItem).Request.StartAddr); 			
	memcpy(&(pByteBuffer[1]), &uintSwapped, 2);						/* reference number = start address */
	
	if(
		(*pQueueItem).Request.Type == BRSE_MB_READ_HOLDING_REG_4BYTE )
			/* 4 byte register */
	{
		pByteBuffer[0] = BRSE_MB_READ_HOLDING_REGISTERS; 					/* function code */
		uintSwapped = SWAPUINT(((*pQueueItem).Request.Quantity*2)); 		/* quantity*2 */
		memcpy(&(pByteBuffer[3]), &uintSwapped, 2);
		inst->RequestBufferLen = 5;
	}
	else if(
		(*pQueueItem).Request.Type == BRSE_MB_READ_HOLDING_REGISTERS ||
		(*pQueueItem).Request.Type == BRSE_MB_READ_COILS ||
		(*pQueueItem).Request.Type == BRSE_MB_READ_DISCRETE_INPUTS ||
		(*pQueueItem).Request.Type == BRSE_MB_READ_INPUT_REGISTERS
	)
	{
		uintSwapped = SWAPUINT((*pQueueItem).Request.Quantity); 				/* quantity */
		memcpy(&(pByteBuffer[3]), &uintSwapped, 2);
		inst->RequestBufferLen = 5;
	}
	else if ((*pQueueItem).Request.Type == BRSE_MB_WRITE_MULTIPLE_REG_4BYTE)
	{
		pByteBuffer[0] = BRSE_MB_WRITE_MULTIPLE_REGISTERS;
		uintSwapped = SWAPUINT((*pQueueItem).Request.Quantity*2); 				/* quantity *2 */
		memcpy(&(pByteBuffer[3]), &uintSwapped, 2);
		pByteBuffer[5] = (USINT) ((*pQueueItem).Request.Quantity * 4);			/* byte count *4 */
		MB_FillRegisterValues4Byte(inst->ServerFormat, pByteBuffer, pQueueItem);
		inst->RequestBufferLen = 6+4*((*pQueueItem).Request.Quantity);
	}
	else if ((*pQueueItem).Request.Type == BRSE_MB_WRITE_MULTIPLE_REGISTERS)
	{
		uintSwapped = SWAPUINT((*pQueueItem).Request.Quantity); 				/* quantity */
		memcpy(&(pByteBuffer[3]), &uintSwapped, 2);
		pByteBuffer[5] = (USINT) ((*pQueueItem).Request.Quantity * 2);			/* byte count */
		MB_FillRegisterValues(pByteBuffer, pQueueItem);
		inst->RequestBufferLen = 6+2*((*pQueueItem).Request.Quantity);
	}
	else if ((*pQueueItem).Request.Type == BRSE_MB_WRITE_SINGLE_COIL)
	{
		if(*((BOOL *)((*pQueueItem).VariableAddr)))
			pByteBuffer[3] = 0xFF;
		else
			pByteBuffer[3] = 0x00;
		pByteBuffer[4] = 0x00;
		inst->RequestBufferLen = 5;
	}
	else if ((*pQueueItem).Request.Type == BRSE_MB_WRITE_SINGLE_REGISTER)
	{
		uintSwapped = SWAPUINT(*( (INT *)((*pQueueItem).VariableAddr) )); 
		memcpy(&(pByteBuffer[3]), &uintSwapped, 2);
		inst->RequestBufferLen = 5;
	}
	else if ((*pQueueItem).Request.Type == BRSE_MB_WRITE_MULTIPLE_COILS)
	{
		uintSwapped = SWAPUINT((*pQueueItem).Request.Quantity); 				/* quantity */
		memcpy(&(pByteBuffer[3]), &uintSwapped, 2);
		if (((*pQueueItem).Request.Quantity % 8) > 0)	
			pByteBuffer[5] = ((*pQueueItem).Request.Quantity / 8) + 1;
		else									
			pByteBuffer[5] = ((*pQueueItem).Request.Quantity / 8);
		MB_FillCoilValues(pByteBuffer, pQueueItem);
		inst->RequestBufferLen =  6+pByteBuffer[5];
	}
	inst->Unit = (*pQueueItem).Request.Unit;
}

void MB_FillRegisterValues(USINT *pByteBuffer, MB_ClientQueueItem_typ *pQueueItem)
{
	INT *pRegisterArray = (INT *)((*pQueueItem).VariableAddr);
	UINT i;
	INT intSwapped;;
	
	for(i=0; i<(*pQueueItem).Request.Quantity; i++)
	{
		intSwapped = SWAPINT(pRegisterArray[i]);
		memcpy(&(pByteBuffer[6 + i*2]), &intSwapped, 2);
	}
}

void MB_FillRegisterValues4Byte(USINT ServerFormat, USINT *pByteBuffer, MB_ClientQueueItem_typ *pQueueItem)
{
	INT *pRegisterArray = (INT *)((*pQueueItem).VariableAddr);
	UINT i;
	INT intSwapped;;
	if(ServerFormat == BRSE_MB_INTEL)
	{
		#ifdef _SG4
		for(i=0; i<(*pQueueItem).Request.Quantity; i++)
		{
			intSwapped = SWAPINT(pRegisterArray[i]);
			memcpy(&(pByteBuffer[6 + i*4]), &intSwapped, 2);
			intSwapped = SWAPINT(pRegisterArray[i+1]);
			memcpy(&(pByteBuffer[8 + i*4]), &intSwapped, 2);
		}
		#else
		for(i=0; i<(*pQueueItem).Request.Quantity; i++)
		{
			intSwapped = SWAPINT(pRegisterArray[i+1]);
			memcpy(&(pByteBuffer[6 + i*4]), &intSwapped, 2);
			intSwapped = SWAPINT(pRegisterArray[i]);
			memcpy(&(pByteBuffer[8 + i*4]), &intSwapped, 2);
		}
		#endif
	}
	else
	{
		#ifdef _SG4
		for(i=0; i<(*pQueueItem).Request.Quantity; i++)
		{
			intSwapped = SWAPINT(pRegisterArray[i+1]);
			memcpy(&(pByteBuffer[6 + i*4]), &intSwapped, 2);
			intSwapped = SWAPINT(pRegisterArray[i]);
			memcpy(&(pByteBuffer[8 + i*4]), &intSwapped, 2);
		}
		#else
		for(i=0; i<(*pQueueItem).Request.Quantity; i++)
		{
			intSwapped = SWAPINT(pRegisterArray[i]);
			memcpy(&(pByteBuffer[6 + i*4]), &intSwapped, 2);
			intSwapped = SWAPINT(pRegisterArray[i+1]);
			memcpy(&(pByteBuffer[8 + i*4]), &intSwapped, 2);
		}
		#endif
	}
}

void MB_PutRegisterValues(USINT *pByteBuffer, MB_ClientQueueItem_typ *pQueueItem)
{
	INT *pRegisterArray = (INT *)((*pQueueItem).VariableAddr);
	UINT i;
	INT intSwapped;
	

	for(i=0; i<(*pQueueItem).Request.Quantity; i++)
	{
		memcpy(&(intSwapped), &(pByteBuffer[2 + i*2]), 2);
		pRegisterArray[i] = SWAPINT(intSwapped);
	}
	
}

void MB_PutRegisterValues4Byte(USINT ServerFormat,USINT *pByteBuffer, MB_ClientQueueItem_typ *pQueueItem)
{
	INT *pRegisterArray = (INT *)((*pQueueItem).VariableAddr);
	UINT i;
	INT intSwapped;
	
	if(ServerFormat == BRSE_MB_INTEL)
	{
		#ifdef _SG4
		for(i=0; i<(*pQueueItem).Request.Quantity; i++)
		{
			memcpy(&(intSwapped), &(pByteBuffer[2 + i*4]), 2);
			pRegisterArray[i*2] = SWAPINT(intSwapped);
			memcpy(&(intSwapped), &(pByteBuffer[4 + i*4]), 2);
			pRegisterArray[i*2+1] = SWAPINT(intSwapped);
		}
		#else
		for(i=0; i<(*pQueueItem).Request.Quantity; i++)
		{
			memcpy(&(intSwapped), &(pByteBuffer[2 + i*4]), 2);
			pRegisterArray[i*2+1] = SWAPINT(intSwapped);
			memcpy(&(intSwapped), &(pByteBuffer[4 + i*4]), 2);
			pRegisterArray[i*2] = SWAPINT(intSwapped);
		}
		#endif
	}
	else
	{
		#ifdef _SG4
		for(i=0; i<(*pQueueItem).Request.Quantity; i++)
		{
			memcpy(&(intSwapped), &(pByteBuffer[2 + i*4]), 2);
			pRegisterArray[i*2+1] = SWAPINT(intSwapped);
			memcpy(&(intSwapped), &(pByteBuffer[4 + i*4]), 2);
			pRegisterArray[i*2] = SWAPINT(intSwapped);
		}
		#else
		for(i=0; i<(*pQueueItem).Request.Quantity; i++)
		{
			memcpy(&(intSwapped), &(pByteBuffer[2 + i*4]), 2);
			pRegisterArray[i*2] = SWAPINT(intSwapped);
			memcpy(&(intSwapped), &(pByteBuffer[4 + i*4]), 2);
			pRegisterArray[i*2+1] = SWAPINT(intSwapped);
		}
		#endif
	}
	

}

void MB_FillCoilValues(USINT *pByteBuffer, MB_ClientQueueItem_typ *pQueueItem)
{
	BOOL *pCoilArray = (BOOL *)((*pQueueItem).VariableAddr);
	UINT i;
	
	for(i=0; i<(*pQueueItem).Request.Quantity; i++)
	{
		if(pCoilArray[i])
			pByteBuffer[6 + (i/8)] = pByteBuffer[6 + (i/8)] | (USINT)(0x01 << (i%8));
		else
			pByteBuffer[6 + (i/8)] = pByteBuffer[6 + (i/8)] & (USINT)~(0x01 << (i%8));
	}
}

void MB_PutCoilValues(USINT *pByteBuffer, MB_ClientQueueItem_typ *pQueueItem)
{
	BOOL *pCoilArray = (BOOL *)((*pQueueItem).VariableAddr);
	UINT i;
	
	for(i=0; i < (*pQueueItem).Request.Quantity; i++)
	{
		if ((pByteBuffer[2 + (i/8)] & (USINT)(0x01 << (i%8))))
			pCoilArray[i] = 1;
		else
			pCoilArray[i] = 0;		
	}	
}

/**/
void MB_PutClientResponse(struct MB_PutClientResponse* inst)
{
	USINT *pByteBuffer = (USINT *)inst->AdrByteBuffer;
	UINT uintSwapped;
	UINT returnStatus;
	MB_Client_typ *pQueue;
	MB_ClientQueueItem_typ *pQueueItem;
	
	/*****************************/
	/* Parse response information */
	/*****************************/
	if (gMB_ClientInternal.pClients[inst->ClientID] == 0)
	{
		inst->Status = MB_ERR_CLIENT_NOT_ALLOCATED;
		return;
	}
	
	pQueue = (MB_Client_typ *)gMB_ClientInternal.pClients[inst->ClientID];
	pQueueItem = &((*pQueue).Queue[(*pQueue).IndexExec]);
	
	inst->Status = BUSY;
	
	inst->ResponseInfo.Type = pByteBuffer[0]; 	/* Function code (byte 0) */
	
	/*special case using 4 byte holding registers*/
	if
	(
		( 
			(inst->ResponseInfo.Type == BRSE_MB_READ_HOLDING_REGISTERS)
			&&
			((*pQueueItem).Request.Type == BRSE_MB_READ_HOLDING_REG_4BYTE)
		)
		||
		(
			(inst->ResponseInfo.Type == BRSE_MB_WRITE_MULTIPLE_REGISTERS)
			&&
			((*pQueueItem).Request.Type == BRSE_MB_WRITE_MULTIPLE_REG_4BYTE)
		)
	)
	{
		inst->ResponseInfo.Type = (*pQueueItem).Request.Type;
	}
	
	if (inst->ResponseInfo.Type >= 0x80)		/* Modbus error */
	{
		returnStatus = pByteBuffer[1];
	}
	else if (inst->ResponseInfo.Type != (*pQueueItem).Request.Type)
	{
		returnStatus = MB_ERR_PROTOCOL;
	}
	else if (inst->ResponseInfo.Type == 0) /* FC 0 does not exist */
	{
		returnStatus = MB_ERR_PROTOCOL;
	}
	else
	{
		if (inst->ResponseInfo.Type == BRSE_MB_WRITE_MULTIPLE_REG_4BYTE || 
			inst->ResponseInfo.Type == BRSE_MB_WRITE_MULTIPLE_REGISTERS || 
			inst->ResponseInfo.Type == BRSE_MB_WRITE_MULTIPLE_COILS)
		{
			memcpy(&uintSwapped, &pByteBuffer[1], 2);				/* Reference number (byte 1,2) */
			inst->ResponseInfo.StartAddr = SWAPUINT(uintSwapped);
			memcpy(&uintSwapped, &pByteBuffer[3], 2);				
			inst->ResponseInfo.Quantity = SWAPUINT(uintSwapped);	/* Quantity */
			returnStatus = 0;
		}
		else if (inst->ResponseInfo.Type == BRSE_MB_READ_HOLDING_REG_4BYTE)
		{
			inst->ResponseInfo.Quantity = pByteBuffer[1]/4; /* byte count */
			MB_PutRegisterValues4Byte(inst->ServerFormat, pByteBuffer, pQueueItem);
			returnStatus = 0;
		}
		else if (inst->ResponseInfo.Type == BRSE_MB_READ_HOLDING_REGISTERS || 
			inst->ResponseInfo.Type == BRSE_MB_READ_INPUT_REGISTERS)
		{
			inst->ResponseInfo.Quantity = pByteBuffer[1]/2; /* byte count / 2 */
			MB_PutRegisterValues(pByteBuffer, pQueueItem);
			returnStatus = 0;
		}
		else if (inst->ResponseInfo.Type == BRSE_MB_READ_COILS || 
			inst->ResponseInfo.Type == BRSE_MB_READ_DISCRETE_INPUTS)
		{
			inst->ResponseInfo.Quantity = (*pQueueItem).Request.Quantity; /* number of coils / inputs */
			MB_PutCoilValues(pByteBuffer, pQueueItem);
			returnStatus = 0;
		}
		else if (inst->ResponseInfo.Type == BRSE_MB_WRITE_SINGLE_COIL || 
			inst->ResponseInfo.Type == BRSE_MB_WRITE_SINGLE_REGISTER)
		{
			memcpy(&uintSwapped, &pByteBuffer[1], 2);				/* Reference number (byte 1,2) */
			inst->ResponseInfo.StartAddr = SWAPUINT(uintSwapped);
			returnStatus = 0;
		}
		else
		{
			returnStatus = MB_ERR_PROTOCOL;
		}
	}
	MB_AckClientRequest(inst->ClientID, returnStatus);
	inst->Status = returnStatus;
}

