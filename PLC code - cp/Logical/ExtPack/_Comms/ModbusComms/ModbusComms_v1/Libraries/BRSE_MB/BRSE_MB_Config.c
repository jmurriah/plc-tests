/*! \file BRSE_MB_Config.c */

#include "BRSE_MB_Main.h"

BRSE_MB_ServerCfg_typ gBRSE_MB_Internal;

/*! \interface BRSE_MB_Alloc
	\brief Server: Function for allocating a modbus server unit.
		
	\param[in] 	Unit	Identity of the unit (0-255)
	\param[in]	MaxCoils	The maximum number of coils (references) used in this unit.
	\param[in]	MaxHoldingRegisters	The maximum number of holding registers used in this unit.
	\param[in] MaxDiscreteInputs	The maximum number of discrete inputs used in this unit.
	\param[in] MaxInputRegisters	The maximum number of input registers used in this unit.
	\param[out] Returns a pointer to the internal structure. Can be used for debug purposes.
	
*/
unsigned long BRSE_MB_Alloc(unsigned char Unit, unsigned short MaxCoils, unsigned short MaxHoldingRegisters, unsigned short MaxDiscreteInputs, unsigned short MaxInputRegisters)
{
	UINT status = 0;
	if (gBRSE_MB_Internal.Unit[Unit].pCoils || gBRSE_MB_Internal.Unit[Unit].pDiscreteInputs || 
		gBRSE_MB_Internal.Unit[Unit].pInputRegisters || gBRSE_MB_Internal.Unit[Unit].pHoldingRegisters)
		return BRSE_MB_ERR_UNIT_ALLOCATED; /* Unit can only be allocated once */
	
	memset(&gBRSE_MB_Internal.Unit[Unit], 0, sizeof(gBRSE_MB_Internal.Unit[Unit]));
	gBRSE_MB_Internal.Unit[Unit].MaxCoils = MaxCoils;
	gBRSE_MB_Internal.Unit[Unit].MaxDiscreteInputs = MaxDiscreteInputs;
	gBRSE_MB_Internal.Unit[Unit].MaxHoldingRegisters = MaxHoldingRegisters;
	gBRSE_MB_Internal.Unit[Unit].MaxInputRegisters = MaxInputRegisters;		
	    
	if (MaxCoils > 0)
	{
		status = TMP_alloc(MaxCoils*sizeof(UDINT) , (void **)&(gBRSE_MB_Internal.Unit[Unit].pCoils));
		if (status == 0)
			memset((void *)gBRSE_MB_Internal.Unit[Unit].pCoils, 0, MaxCoils*sizeof(UDINT));
		else
			ERRxwarning(status,(UDINT)gBRSE_MB_Internal.Unit[Unit].pCoils,(void *)"Coils: No memory!");
	}
	
	if (status != 0) /* reset unit */
	{
		memset(&gBRSE_MB_Internal.Unit[Unit], 0, sizeof(gBRSE_MB_Internal.Unit[Unit]));
		return status;
	}
	
	if (MaxDiscreteInputs > 0)
	{
		status = TMP_alloc(MaxDiscreteInputs*sizeof(UDINT) , (void **)&(gBRSE_MB_Internal.Unit[Unit].pDiscreteInputs));
		if (status == 0)
			memset((void *)gBRSE_MB_Internal.Unit[Unit].pDiscreteInputs, 0, MaxDiscreteInputs*sizeof(UDINT));
		else
			ERRxwarning(status,(UDINT)gBRSE_MB_Internal.Unit[Unit].pDiscreteInputs,(void *)"DiscreteI: No memory!");
	}
	
	if (status != 0) /* reset unit */
	{
		memset(&gBRSE_MB_Internal.Unit[Unit], 0, sizeof(gBRSE_MB_Internal.Unit[Unit]));
		return status;
	}
	
	if (MaxHoldingRegisters > 0)
	{
		status = TMP_alloc(MaxHoldingRegisters*sizeof(UDINT) , (void **)&(gBRSE_MB_Internal.Unit[Unit].pHoldingRegisters));
		if (status == 0)
			memset((void *)gBRSE_MB_Internal.Unit[Unit].pHoldingRegisters, 0, MaxHoldingRegisters*sizeof(UDINT));
		else
			ERRxwarning(status,(UDINT)gBRSE_MB_Internal.Unit[Unit].pHoldingRegisters,(void *)"HoldingR: No memory!");
	}
	
	if (status != 0) /* reset unit */
	{
		memset(&gBRSE_MB_Internal.Unit[Unit], 0, sizeof(gBRSE_MB_Internal.Unit[Unit]));
		return status;
	}
	
	if (MaxInputRegisters > 0)
	{
		status = TMP_alloc(MaxInputRegisters*sizeof(UDINT) , (void **)&(gBRSE_MB_Internal.Unit[Unit].pInputRegisters));
		if (status == 0)
			memset((void *)gBRSE_MB_Internal.Unit[Unit].pInputRegisters, 0, MaxInputRegisters*sizeof(UDINT));
		else
			ERRxwarning(status,(UDINT)gBRSE_MB_Internal.Unit[Unit].pInputRegisters,(void *)"InputReg:  No memory!");
	}
	
	if (status != 0) /* reset unit */
	{
		memset(&gBRSE_MB_Internal.Unit[Unit], 0, sizeof(gBRSE_MB_Internal.Unit[Unit]));
	}
	
	return (unsigned long)&gBRSE_MB_Internal;
}

/*! \interface BRSE_MB_Coil
	\brief Server: Function binding a coil to a variable
	
	Note that this function uses relative modbus adressing. Reference 0 corresponds to Modbus adress 1.
		
	\param[in] 	Unit	Identity of the unit (0-255)
	\param[in]	Reference	Coil address within unit (0..MaxCoils-1 in Alloc)
	\param[in]	VariableAddress	Address of the boolean variable.
	\param[out] Returns 0 or an error code.
*/
unsigned short BRSE_MB_Coil(unsigned char Unit, unsigned short Reference, unsigned long PvAddress)
{
	UDINT *coils;
	if (Reference >= gBRSE_MB_Internal.Unit[Unit].MaxCoils || PvAddress == 0)
		return BRSE_MB_ERR_REFERENCE;
	coils = (UDINT *)gBRSE_MB_Internal.Unit[Unit].pCoils; /* use as dynamic UDINT[] */
	coils[Reference] = PvAddress;
	return 0;
}

/*! \interface BRSE_MB_HoldingRegister
	\brief Server: Function binding a holding register to a variable
	
	Note that this function uses relative modbus adressing. Reference 0 corresponds to Modbus adress 40001.
		
	\param[in] 	Unit	Identity of the unit (0-255)
	\param[in]	Reference	Holding register address within unit (0..MaxHoldingRegisters-1 in Alloc)
	\param[in]	VariableAddress	Address of the integer variable.
	\param[out] Returns 0 or an error code.
*/
unsigned short BRSE_MB_HoldingRegister(unsigned char Unit, unsigned short Reference, unsigned long PvAddress)
{
	UDINT *holdingRegisters;
	if (Reference >= gBRSE_MB_Internal.Unit[Unit].MaxHoldingRegisters || PvAddress == 0)
		return BRSE_MB_ERR_REFERENCE; 
	holdingRegisters = (UDINT *)gBRSE_MB_Internal.Unit[Unit].pHoldingRegisters; /* use as dynamic UDINT[] */
	holdingRegisters[Reference] = PvAddress;
	return 0;
}

/*! \interface BRSE_MB_4ByteHoldingRegister
	\brief Server: Function binding a 4 byte variable to 2 holding registers
	
	Note that this function uses relative modbus adressing. Reference 0 corresponds to Modbus adress 40001.
		
	\param[in] 	Unit	Identity of the unit (0-255)
	\param[in]	Reference	Holding register address within unit (0..MaxHoldingRegisters-1 in Alloc). Next free modbus address will be Reference+2 as the function assumes that you bind a 4-byte variable.
	\param[in]	VariableAddress	Address of the 4 byte variable.
	\param[out] Returns 0 or an error code.
*/
unsigned short BRSE_MB_4ByteHoldingRegister(unsigned char Unit, unsigned short Reference, unsigned long PvAddress)
{
	UDINT *holdingRegisters;
	if (Reference + 1 >= gBRSE_MB_Internal.Unit[Unit].MaxHoldingRegisters || PvAddress == 0)
		return BRSE_MB_ERR_REFERENCE; 
	holdingRegisters = (UDINT *)gBRSE_MB_Internal.Unit[Unit].pHoldingRegisters; /* use as dynamic UDINT[] */
	holdingRegisters[Reference] = 1;
	holdingRegisters[Reference + 1] = PvAddress;
	return 0;
}
/*! \interface BRSE_MB_InputRegister
	\brief Server: Function binding a input register to a variable
	
	Note that this function uses relative modbus adressing. Reference 0 corresponds to Modbus adress 30001
	
	\param[in] 	Unit	Identity of the unit (0-255)
	\param[in]	Reference	Input register address within unit (0..MaxInputRegister-1 in Alloc)
	\param[in]	VariableAddress	Address of the integer variable.
	\param[out] Returns 0 or an error code.
*/
unsigned short BRSE_MB_InputRegister(unsigned char Unit, unsigned short Reference, unsigned long PvAddress)
{
	UDINT *inputRegisters;
	if (Reference >= gBRSE_MB_Internal.Unit[Unit].MaxInputRegisters || PvAddress == 0)
		return BRSE_MB_ERR_REFERENCE; 
	inputRegisters = (UDINT *)gBRSE_MB_Internal.Unit[Unit].pInputRegisters; /* use as dynamic UDINT[] */
	inputRegisters[Reference] = PvAddress;
	return 0;
}

/*! \interface BRSE_MB_DiscreteInput
	\brief Server: Function binding a coil to a variable
	
	Note that this function uses relative modbus adressing. Reference 0 corresponds to Modbus adress 10001.
		
	\param[in] 	Unit	Identity of the unit (0-255)
	\param[in]	Reference	Coil address within unit (0..MaxDiscreteInputs-1 in Alloc)
	\param[in]	VariableAddress	Address of the boolean variable.
	\param[out] Returns 0 or an error code.
*/
unsigned short BRSE_MB_DiscreteInput(unsigned char Unit, unsigned short Reference, unsigned long PvAddress)
{
	UDINT *discreteInputs;
	if (Reference >= gBRSE_MB_Internal.Unit[Unit].MaxDiscreteInputs || PvAddress == 0)
		return BRSE_MB_ERR_REFERENCE;
	discreteInputs = (UDINT *)gBRSE_MB_Internal.Unit[Unit].pDiscreteInputs; /* use as dynamic UDINT[] */
	discreteInputs[Reference] = PvAddress;
	return 0;
}
