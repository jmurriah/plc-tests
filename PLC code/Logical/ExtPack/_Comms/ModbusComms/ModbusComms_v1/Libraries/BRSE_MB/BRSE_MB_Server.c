/*! \file BRSE_MB_Server.c */
 
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

extern BRSE_MB_ServerCfg_typ gBRSE_MB_Internal; /* declared in BRSE_MB_Config.c */

 /*!
	\interface BRSE_MB_Server
	\brief Server: Interprets a byte buffer and creates a response to it according to modbus specification.
	Units and variables are configured with other BRSE_MB-functions.
	
	\param[in] Unit			The unit identifier (0-254)
	\param[in]	ClientFormat	Set the format of 4 byte variables to Intel or Motorola. BRSE_MB_INTEL / BRSE_MB_MOTOROLA
	
	\param[in] InputBuffer	The modbus byte buffer to respond to. 
		Byte 0 is the function code.
		Byte 1-2 is the reference number (offset within unit where to start reading/writing).
	
	\param[out] OutputBuffer	The response buffer
	\param[out] BufferLength	The total number of bytes in the output buffer
	\param[out] Status			Return status. 
	
*/
void BRSE_MB_Server(struct BRSE_MB_Server* inst)
{
	UINT	uintVar;
	/*****************************************/
	/* Check inputs and reset function block */
	/*****************************************/
	if (
		 (	!gBRSE_MB_Internal.Unit[inst->Unit].pCoils && !gBRSE_MB_Internal.Unit[inst->Unit].pDiscreteInputs &&
			!gBRSE_MB_Internal.Unit[inst->Unit].pInputRegisters && !gBRSE_MB_Internal.Unit[inst->Unit].pHoldingRegisters)
		)/* Unit not allocated */	
	{
		inst->Status = BRSE_MB_ERR_ILLEGAL_FUNCTION; /* Unit is unconfigured and cannot process any request */	
		return;
	}
	
	memset(&inst->OutputBuffer, 0, sizeof(inst->OutputBuffer));
	memset(&inst->Request, 0, sizeof(inst->Request));
	
	/*****************************/
	/* Parse request information */
	/*****************************/
	
	/* Function code (byte 0) */
	inst->Request.Type = inst->InputBuffer[0]; 
	if (inst->Request.Type == 0) /* FC 0 does not exist */
	{
		inst->Status = BRSE_MB_ERR_ILLEGAL_FUNCTION;
		return;
	}
	/* Reference number (byte 1,2) */
	memcpy(&uintVar, &inst->InputBuffer[1], sizeof(uintVar));
	inst->Request.StartAddr = SWAPUINT(uintVar);
	
	if(inst->Request.Type == BRSE_MB_WRITE_SINGLE_COIL || inst->Request.Type == BRSE_MB_WRITE_SINGLE_REGISTER)
	{
		inst->Request.Quantity = 1;
	}
	else /* Word/bit count (byte 3,4) */
	{
		memcpy(&uintVar, &inst->InputBuffer[3], sizeof(uintVar));
		inst->Request.Quantity = SWAPUINT(uintVar);
	}
	if (inst->Request.Quantity == 0)
	{
		inst->Status = BRSE_MB_ERR_ILLEGAL_DATA_ADDRESS;
		return;
	}
	
	/**************************************/
	/* Analyze request and build response */
	/**************************************/
	inst->OutputBuffer[0] = inst->Request.Type; /* Echo function code */
	
	switch(inst->Request.Type)
	{
		case BRSE_MB_READ_COILS:					/* 0x01 */
			inst->Status = BRSE_MB_ReadCoils(inst);
			break;
			
		case BRSE_MB_READ_DISCRETE_INPUTS:			/* 0x02 */
			inst->Status = BRSE_MB_ReadDiscreteInputs(inst);
			break;
			
		case BRSE_MB_READ_HOLDING_REGISTERS:		/* 0x03 */
			inst->Status = BRSE_MB_ReadHoldingRegisters(inst);	
			break;
			
		case BRSE_MB_READ_INPUT_REGISTERS:			/* 0x04 */
			inst->Status = BRSE_MB_ReadInputRegisters(inst);	
			break;
			
		case BRSE_MB_WRITE_SINGLE_COIL:				/* 0x05 */
			inst->Status = BRSE_MB_WriteSingleCoil(inst);
			break;
			
		case BRSE_MB_WRITE_SINGLE_REGISTER:			/* 0x06 */
			inst->Status = BRSE_MB_WriteSingleRegister(inst);
			break;
			
		case BRSE_MB_WRITE_MULTIPLE_COILS:			/* 0x0F */
			inst->Status = BRSE_MB_WriteMultipleCoils(inst);
			break;
			
		case BRSE_MB_WRITE_MULTIPLE_REGISTERS:		/* 0x10 */
			inst->Status = BRSE_MB_WriteMultipleRegisters(inst);
			break;
			
		default:
			inst->Status = BRSE_MB_ERR_ILLEGAL_FUNCTION;
			break;
	}
	if (inst->Status != 0) /* Reset outputs */
		memset(&inst->OutputBuffer, 0, sizeof(inst->OutputBuffer));
	
}

UINT BRSE_MB_ReadCoils(struct BRSE_MB_Server* inst)
{
	UDINT 				*coils;
	if(inst->Request.StartAddr + inst->Request.Quantity <= gBRSE_MB_Internal.Unit[inst->Unit].MaxCoils 
		&& inst->Request.Quantity <= BRSE_MB_MAX_COILS
		&& gBRSE_MB_Internal.Unit[inst->Unit].pCoils)
	{
		coils = (UDINT *)gBRSE_MB_Internal.Unit[inst->Unit].pCoils; /* use as dynamic UDINT[] */
		return BRSE_MB_FillDigitalBuffer(inst, coils);
	}
	else
	{
		return BRSE_MB_ERR_ILLEGAL_DATA_ADDRESS;
	}
}

UINT BRSE_MB_ReadDiscreteInputs(struct BRSE_MB_Server* inst)
{
	UDINT 				*discreteInputs;
	if(inst->Request.StartAddr + inst->Request.Quantity <= gBRSE_MB_Internal.Unit[inst->Unit].MaxDiscreteInputs 
		&& inst->Request.Quantity <= BRSE_MB_MAX_DISCRETE_INPUTS
		&& gBRSE_MB_Internal.Unit[inst->Unit].pDiscreteInputs)
	{
		discreteInputs = (UDINT *)gBRSE_MB_Internal.Unit[inst->Unit].pDiscreteInputs; /* use as dynamic UDINT[] */
		return BRSE_MB_FillDigitalBuffer(inst, discreteInputs);
	}
	else
	{
		return BRSE_MB_ERR_ILLEGAL_DATA_ADDRESS;
	}
}

UINT BRSE_MB_ReadHoldingRegisters(struct BRSE_MB_Server* inst)
{
	UDINT *holdingRegisters;
	if (inst->Request.StartAddr + inst->Request.Quantity <= gBRSE_MB_Internal.Unit[inst->Unit].MaxHoldingRegisters
		&& inst->Request.Quantity <= BRSE_MB_MAX_HOLDING_REG_READ 
		&& gBRSE_MB_Internal.Unit[inst->Unit].pHoldingRegisters)
	{
		holdingRegisters = (UDINT *)gBRSE_MB_Internal.Unit[inst->Unit].pHoldingRegisters; /* use as dynamic UDINT[] */
		return BRSE_MB_FillRegisterBuffer(inst, holdingRegisters);
	}
	else
	{
		return BRSE_MB_ERR_ILLEGAL_DATA_ADDRESS;
	}
}

UINT BRSE_MB_ReadInputRegisters(struct BRSE_MB_Server* inst)
{
	UDINT *inputRegisters;
	if (inst->Request.StartAddr + inst->Request.Quantity <= gBRSE_MB_Internal.Unit[inst->Unit].MaxInputRegisters
		&& inst->Request.Quantity <= BRSE_MB_MAX_INPUT_REG_READ 
		&& gBRSE_MB_Internal.Unit[inst->Unit].pInputRegisters)
	{
		inputRegisters = (UDINT *)gBRSE_MB_Internal.Unit[inst->Unit].pInputRegisters; /* use as dynamic UDINT[] */
		return BRSE_MB_FillRegisterBuffer(inst, inputRegisters);
	}
	else
	{
		return BRSE_MB_ERR_ILLEGAL_DATA_ADDRESS;
	}
}

/* 
 Response looks like 
   Byte
	0:			FC
	1-2:		Reference
	3:			FF=0N, 00=OFF
	4:			0
	
	sets BufferLength = 5
 */
UINT BRSE_MB_WriteSingleCoil(struct BRSE_MB_Server* inst)
{
	UINT uintVar;
	UINT value;
	UDINT *coils;
	
	inst->BufferLength = 5;
	if(inst->Request.StartAddr < gBRSE_MB_Internal.Unit[inst->Unit].MaxCoils && gBRSE_MB_Internal.Unit[inst->Unit].pCoils)
	{
		coils = (UDINT *)gBRSE_MB_Internal.Unit[inst->Unit].pCoils; /* use as dynamic UDINT[] */		
		memcpy(&uintVar, &inst->InputBuffer[3], sizeof(uintVar)); /* value */
		value = SWAPUINT(uintVar);
			
		memcpy(&inst->OutputBuffer[1], &inst->InputBuffer[1], 2); /* Reference: 2 byte */		
		memcpy(&inst->OutputBuffer[3], &inst->InputBuffer[3], 2); /* Value: 2 byte */
		
		if (coils[inst->Request.StartAddr])
		{
			if(value == BRSE_MB_ON)
				*((BOOL*)(coils[inst->Request.StartAddr])) = 1;
			else
				*((BOOL*)(coils[inst->Request.StartAddr])) = 0;
		}
	}
	else
	{
		return BRSE_MB_ERR_ILLEGAL_DATA_ADDRESS;
	}
	return 0;
}

/* 
 Response looks like 
   Byte
	0:			FC
	1-2:		Reference
	3-4:		Register value
	
	sets BufferLength = 5
 */
UINT BRSE_MB_WriteSingleRegister(struct BRSE_MB_Server* inst)
{
	INT intVar;
	INT value;
	UDINT *holdingRegisters;
	
	inst->BufferLength = 5;

	if(inst->Request.StartAddr < gBRSE_MB_Internal.Unit[inst->Unit].MaxHoldingRegisters && gBRSE_MB_Internal.Unit[inst->Unit].pHoldingRegisters)
	{
		holdingRegisters = (UDINT *)gBRSE_MB_Internal.Unit[inst->Unit].pHoldingRegisters; /* use as dynamic UDINT[] */		
		memcpy(&intVar, &(inst->InputBuffer[3]), sizeof(intVar)); /* value */
		value = SWAPUINT(intVar);
	
		memcpy(&inst->OutputBuffer[1], &inst->InputBuffer[1], 2); /* Reference: 2 byte */		
		memcpy(&inst->OutputBuffer[3], &inst->InputBuffer[3], 2); /* Value: 2 byte */

		if (holdingRegisters[inst->Request.StartAddr] > 1) /*check that its not a 4-byte holding!*/
			*((INT*)(holdingRegisters[inst->Request.StartAddr])) = value;
		else
			return BRSE_MB_ERR_ILLEGAL_DATA_ADDRESS;
	}
	else
	{
		return BRSE_MB_ERR_ILLEGAL_DATA_ADDRESS;
	}
	
	return 0;
}

/* 
 Response looks like 
   Byte
	0:			FC
	1-2:		Reference
	3-4:		Bit count
	
	sets BufferLength = 5
 */
UINT BRSE_MB_WriteMultipleCoils(struct BRSE_MB_Server* inst)
{
	UINT i;
	UDINT *coils;
	
	inst->BufferLength = 5;
	if(inst->Request.StartAddr + inst->Request.Quantity <= gBRSE_MB_Internal.Unit[inst->Unit].MaxCoils 
		&& inst->Request.Quantity <= BRSE_MB_MAX_COILS_WRITE
		&& gBRSE_MB_Internal.Unit[inst->Unit].pCoils)
	{		
		coils = (UDINT *)gBRSE_MB_Internal.Unit[inst->Unit].pCoils; /* use as dynamic UDINT[] */
		memcpy(&inst->OutputBuffer[1], &inst->InputBuffer[1], 2);		/* Reference: 2 byte */
		memcpy(&inst->OutputBuffer[3], &inst->InputBuffer[3], 2);  	/* Bit count: 2 byte */
		
		for(i=0; i < inst->Request.Quantity; i++)
		{
			if (coils[inst->Request.StartAddr+i])
			{
				if ((inst->InputBuffer[6 + (i/8)] & (USINT)(0x01 << (i%8))) && (coils[inst->Request.StartAddr+i]))
					*((BOOL*)(coils[inst->Request.StartAddr+i])) = 1;
				else
					*((BOOL*)(coils[inst->Request.StartAddr+i])) = 0;
			}
		}		
		return 0;				
	}
	else
	{
		return BRSE_MB_ERR_ILLEGAL_DATA_ADDRESS;
	}
	
}
/* 
 Response looks like 
   Byte
	0:			FC
	1-2:		Reference
	3-4:		Word count
	
	sets BufferLength = 5
 */
UINT BRSE_MB_WriteMultipleRegisters(struct BRSE_MB_Server* inst)
{
	INT							int_var1, int_var2;
	UINT						i;
	UDINT *holdingRegisters;
	
	inst->BufferLength = 5;
	

	if (inst->Request.StartAddr + inst->Request.Quantity <= gBRSE_MB_Internal.Unit[inst->Unit].MaxHoldingRegisters
		&& inst->Request.Quantity <= BRSE_MB_MAX_HOLDING_REG_WRITE
		&& gBRSE_MB_Internal.Unit[inst->Unit].pHoldingRegisters)
	{

			holdingRegisters = (UDINT *)gBRSE_MB_Internal.Unit[inst->Unit].pHoldingRegisters; /* use as dynamic UDINT[] */
			memcpy(&inst->OutputBuffer[1], &inst->InputBuffer[1], 2);	/* 	Reference: 2 byte */
			memcpy(&inst->OutputBuffer[3], &inst->InputBuffer[3], 2); 	/* Value: 2 byte */
		
			for(i=0; i < inst->Request.Quantity; i++)
			{
				if (holdingRegisters[inst->Request.StartAddr+i] == 0)
				{
					return BRSE_MB_ERR_ILLEGAL_DATA_ADDRESS;
				}

				if (holdingRegisters[inst->Request.StartAddr+i] == 1 && holdingRegisters[inst->Request.StartAddr+i+1]) /* 4 byte variable */
				{
					memcpy(&int_var1, &inst->InputBuffer[6+(i*2)], sizeof(int_var1));
					memcpy(&int_var2, &inst->InputBuffer[6+(i*2)+2], sizeof(int_var2));
					if (inst->ClientFormat == BRSE_MB_INTEL )
					{
						#ifdef _SG4
						*((INT*)(holdingRegisters[inst->Request.StartAddr+i+1])) = SWAPINT(int_var1);
						*((INT*)(holdingRegisters[inst->Request.StartAddr+i+1]+2)) = SWAPINT(int_var2);
						#else
						*((INT*)(holdingRegisters[inst->Request.StartAddr+i+1])) = SWAPINT(int_var2);
						*((INT*)(holdingRegisters[inst->Request.StartAddr+i+1]+2)) = SWAPINT(int_var1);
						#endif
					}
					else
					{
						#ifdef _SG4
						*((INT*)(holdingRegisters[inst->Request.StartAddr+i+1])) = SWAPINT(int_var2);
						*((INT*)(holdingRegisters[inst->Request.StartAddr+i+1]+2)) = SWAPINT(int_var1);
						#else
						*((INT*)(holdingRegisters[inst->Request.StartAddr+i+1])) = SWAPINT(int_var1);
						*((INT*)(holdingRegisters[inst->Request.StartAddr+i+1]+2)) = SWAPINT(int_var2);
						#endif
					}

					i++;
				}
				else if (holdingRegisters[inst->Request.StartAddr+i] > 1) /* Normal 2 byte register */
				{
					memcpy(&int_var1, &inst->InputBuffer[6+(i*2)], sizeof(int_var1));
					*((INT*)(holdingRegisters[inst->Request.StartAddr+i])) = SWAPINT(int_var1);
				}
			}
	
			return 0;
	}
	else
	{
		return BRSE_MB_ERR_ILLEGAL_DATA_ADDRESS;
	}
}

/*********************/
/* Utility functions */
/*********************/
/* 
 Response looks like 
   Byte
	0:			FC
	1:			Byte count of response (B=(bit count +7)/8)
	2-(B+1):	Bit values
	
	sets BufferLength = 2+B
 */
UINT BRSE_MB_FillDigitalBuffer(struct BRSE_MB_Server* inst, UDINT *boolPtrArray)
{
	UINT				i;
	USINT				byte_nr;
	/* Number of bytes in response (1) */
	if ((inst->Request.Quantity % 8) > 0)	byte_nr = (inst->Request.Quantity / 8) + 1;
	else									byte_nr = (inst->Request.Quantity / 8);
	inst->OutputBuffer[1] = byte_nr;
	
	/* Value of boolean boolPtrArray (2->byte_nr) */
	for(i = 0; i < inst->Request.Quantity; i++)
	{
		/* if pv assigned and true */
		if( boolPtrArray[inst->Request.StartAddr+i] && (*((BOOL *)boolPtrArray[inst->Request.StartAddr+i])))
			inst->OutputBuffer[2 + (i/8)] = inst->OutputBuffer[2 + (i/8)] | (USINT)(0x01 << (i%8));
		else
			inst->OutputBuffer[2 + (i/8)] = inst->OutputBuffer[2 + (i/8)] & (USINT)~(0x01 << (i%8));			
	
	}
	inst->BufferLength = 2+byte_nr;
	return 0;
}

/* 
 Response looks like 
   Byte
	0:			FC
	1:			Byte count of response (B=2*word count)
	2-(B+1):	Register values (1-125)
	
	returns BufferLength = 2+2*(word count)
 */
UINT BRSE_MB_FillRegisterBuffer(struct BRSE_MB_Server* inst, UDINT *intPtrArray)
{
	INT				int_var1, int_var2;
	UINT			i;
	
	inst->OutputBuffer[1] = inst->Request.Quantity * 2; /* nbr data bytes */
	
	for(i = 0; i < inst->Request.Quantity; i++)
	{
		if(intPtrArray[inst->Request.StartAddr + i])
		{
			if(intPtrArray[inst->Request.StartAddr + i] == 1 && intPtrArray[inst->Request.StartAddr + i + 1]) /*4-byte*/
			{
				int_var1 = SWAPINT(*((INT*)(intPtrArray[inst->Request.StartAddr + i + 1])));
				int_var2 = SWAPINT(*((INT*)(intPtrArray[inst->Request.StartAddr + i + 1]+2)));
				
				if(inst->ClientFormat == BRSE_MB_INTEL)
				{
					#ifdef _SG4
						memcpy(&inst->OutputBuffer[2 + (i*2)], &int_var1, sizeof(int_var1));
						memcpy(&inst->OutputBuffer[2 + ((i+1)*2)], &int_var2, sizeof(int_var2));
					#else
						memcpy(&inst->OutputBuffer[2 + (i*2)], &int_var2, sizeof(int_var2));
						memcpy(&inst->OutputBuffer[2 + ((i+1)*2)], &int_var1, sizeof(int_var1));
					#endif
				}
				else
				{
					#ifdef _SG4
						memcpy(&inst->OutputBuffer[2 + (i*2)], &int_var2, sizeof(int_var2));
						memcpy(&inst->OutputBuffer[2 + ((i+1)*2)], &int_var1, sizeof(int_var1));	
					#else
						memcpy(&inst->OutputBuffer[2 + (i*2)], &int_var1, sizeof(int_var1));
						memcpy(&inst->OutputBuffer[2 + ((i+1)*2)], &int_var2, sizeof(int_var2));
					#endif					
				}
				
				i++;
			}
			else if(intPtrArray[inst->Request.StartAddr + i] > 1) /*just in case, normally it shouldnt be 1 here anyhow*/
			{
				int_var1 = SWAPINT(*((INT*)(intPtrArray[inst->Request.StartAddr + i])));
				memcpy(&inst->OutputBuffer[2 + (i*2)], &int_var1, sizeof(int_var1));
			}
		}
		else /*bad pointer*/
		{
			int_var1 = 0;
			memcpy(&inst->OutputBuffer[2 + (i*2)], &int_var1, sizeof(int_var1));
		}
	}
	inst->BufferLength = 2+2*inst->Request.Quantity;
	return 0;
}
