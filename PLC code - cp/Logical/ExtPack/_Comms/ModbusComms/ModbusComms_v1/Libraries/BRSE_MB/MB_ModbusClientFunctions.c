/*! \file MB_ModbusClientFunctions.c */

#include <bur/plctypes.h>
#include "BRSE_MB.h"
#include "BRSE_MB_Main.h"

#define	BUSY				65535

extern MB_ClientStruct_typ gMB_ClientInternal;

UINT MB_AddToRequestQueue(USINT clientID, USINT fc, UINT quantity, UINT startAddress, UDINT variableAddress, UDINT statusAddress, USINT Unit);

/***
 * This macro is the code basis for all non-cyclic modbus function calls from the application. 
 * The only thing that differs is the function code.
 */ 
#define EXEC_MODBUS_FUNCTION_MACRO(functionCode)	\
		switch(inst->Step)							\
		{											\
			case 0: /* idle */						\
				if (inst->Done || inst->Error)		\
				{	/*reset out signals */			\
					inst->Done = inst->Execute;		\
					inst->Error = inst->Execute;	\
				}									\
				else if (inst->Execute)				\
				{									\
					inst->Step = 1;					\
				}									\
				inst->Busy = 0;						\
				break;								\
													\
			case 1:	/* add req to queue */			\
				inst->InternalStatus = MB_AddToRequestQueue(inst->ClientID, functionCode, inst->Quantity, inst->StartAddress, inst->VariablesAddress, (UDINT)&(inst->RequestStatus), inst->Unit); \
				if (inst->InternalStatus == 0)		\
				{									\
					inst->Status = BUSY;			\
					inst->Step = 2;					\
				}									\
				else								\
				{									\
					inst->Status = inst->InternalStatus; \
				}									\
				inst->Error = 0;					\
				inst->Done = 0;						\
				inst->Busy = 1;						\
				break;								\
													\
			case 2:									\
				if (inst->RequestStatus == 0) 		\
				{									\
					inst->Status = 0;				\
					inst->Done = 1;					\
					inst->Error = 0;				\
					inst->Busy = 0;					\
					inst->Step = 0;					\
				}									\
				else if (inst->RequestStatus != BUSY) 	\
				{									\
					inst->Status = inst->RequestStatus; \
					inst->Done = 0;					\
					inst->Error = 1;				\
					inst->Busy = 0;					\
					inst->Step = 0;					\
				}									\
				else if (MB_QueueStatus(inst->ClientID) == 0)	\
				{									\
					inst->Status = MB_ERR_CLIENT;	\
					ERRxwarning(58001,inst->ClientID,(void *)"MB_Client_Fub: No client queue!");\
					inst->Done = 0;					\
					inst->Error = 1;				\
					inst->Busy = 0;					\
					inst->Step = 0;					\
				}									\
				break;								\
		}											

/*
 * This macro is the code basis for all cyclic modbus function calls from the application.
 * The only thing that differs is the function code.
 *
 * The functions places the request in queue and waits for the request to be executed.
 * When the function has been executed, the resulting status is set in the inst->RequestStatus variable.
 * 0 if successful.
 */
#define EXEC_MODBUS_CYCLIC_FUNCTION_MACRO(functionCode, interval) 	\
		if (!inst->Enable)									\
		{													\
			inst->Active = 0;								\
			inst->Busy = 0;									\
			inst->UpdateDone = 0;							\
			inst->Status = 0;								\
			return;											\
		}													\
		inst->ElapsedTime += inst->CycleTimeMs;				\
		switch(inst->Step)									\
		{													\
			case 0: /* init cycle time */					\
				inst->Status = 0;							\
				inst->RTInfo_0.enable = 1;					\
				RTInfo(&inst->RTInfo_0);					\
				if (inst->RTInfo_0.status == 0)				\
				{											\
					inst->CycleTimeMs = inst->RTInfo_0.cycle_time/1000;\
					inst->Step = 2; /* go directly to first push/poll */\
				}											\
				break;										\
															\
			case 1: /* idle */								\
				if (inst->ElapsedTime >= interval) 			\
				{											\
					inst->Step = 2;							\
					inst->ElapsedTime = 0; /*reset*/		\
				}											\
				else										\
					break;									\
															\
			case 2:	 /* put request in queue */				\
				inst->UpdateDone = 0;						\
				inst->InternalStatus = MB_AddToRequestQueue(inst->ClientID, functionCode, inst->Quantity, inst->StartAddress, inst->VariablesAddress, (UDINT)&(inst->RequestStatus), inst->Unit); \
				if (inst->InternalStatus == 0)				\
				{											\
					inst->Step = 3;							\
					inst->Status = BUSY;					\
				}											\
				else										\
				{											\
					inst->Status = inst->InternalStatus;	\
				}											\
				break;										\
															\
			case 3: /* await request finished */			\
				inst->Status = BUSY;						\
				if (inst->RequestStatus == 0) /* finished */\
				{											\
					inst->UpdateDone = 1;					\
					inst->Status = 0;						\
					inst->Step = 1;							\
				}											\
				else if (inst->RequestStatus != BUSY) /* finished with errors */\
				{											\
					inst->Status = inst->RequestStatus;		\
					inst->Step = 1;							\
				}											\
				else if (MB_QueueStatus(inst->ClientID) == 0)\
				{											\
					inst->Status = MB_ERR_CLIENT;			\
					ERRxwarning(58002,inst->ClientID,(void *)"MB_Client_Fub: No client queue!");\
					inst->Step = 1;							\
				}											\
				break;										\
		}													\
		inst->Active = (inst->Enable && inst->Step != 0) ? 1 : 0; \
		inst->Error = (inst->Status != 0 && inst->Status != BUSY) ? 1 : 0; \
		inst->ErrorID = (inst->Status < 5) ? inst->Status : 0; /* only modbus protocol errors */\
		inst->Busy = (inst->Status == BUSY) ? 1 : 0;				

#define CHECK_INPUT_QUANTITY_MACRO(maxQuantity) 										\
		if(inst->Quantity > maxQuantity || inst->Quantity == 0) 						\
		{																				\
			inst->Status = MB_ERR_QUANTITY;												\
			inst->Done = 0;																\
			inst->Error = 1;															\
			inst->ErrorID = 0; 															\
			inst->Busy = 0;																\
			return;																		\
		}

#define CHECK_INPUT_QUANTITY_CYCLIC_MACRO(maxQuantity) 									\
		if(inst->Quantity > maxQuantity || inst->Quantity == 0) 						\
		{																				\
			inst->Status = MB_ERR_QUANTITY;												\
			inst->Active = 0;															\
			inst->Error = 1;															\
			inst->ErrorID = 0; 															\
			inst->Busy = 0;																\
			inst->UpdateDone = 0;														\
			return;																		\
		}

/*
 * 
 */

/*! \interface MB_WriteHoldingRegisters
	\brief Client: Write event triggered to a holding register
	
	\param[in] 	ClientID	Identity created in AllocClient.
	\param[in]	Execute	Enables execution.
	\param[in]	Quantity	Number of register to write to.
	\param[in]	VariablesAddress	Address of the integer variable.
	\param[in]	StartAddress	Address in the server to write to.
	\param[in] 	Unit	Identity of the unit (0-255) in the server.
	\param[out] Busy	Set to TRUE when function are busy.
	\param[out] Done	When the function has completed succesfully, this value is set to TRUE.
	\param[out] Error	If an error occurs while exeuting the function, this output is set to TRUE.
	\param[out] ErrorID	Error number from the function block.
	\param[out] Status	Normally set to zero otherwise something is wrong or function are waiting to get completed.
*/
void MB_WriteHoldingRegisters(struct MB_WriteHoldingRegisters* inst)
{
	CHECK_INPUT_QUANTITY_MACRO(BRSE_MB_MAX_HOLDING_REG_WRITE)
	EXEC_MODBUS_FUNCTION_MACRO(inst->Quantity == 1 ? BRSE_MB_WRITE_SINGLE_REGISTER : BRSE_MB_WRITE_MULTIPLE_REGISTERS)
}

/*! \interface MB_Write4ByteHoldingRegisters
	\brief Client: Write event triggered to a 4 byte register using 2 holding registers
	
	\param[in] 	ClientID	Identity created in AllocClient.
	\param[in]	Execute	Enables execution.
	\param[in]	Quantity	Number of 4-byte variables to write to. Corresponds to the double amount of holding registers.
	\param[in]	VariablesAddress	Address of the 4 byte variable.
	\param[in]	StartAddress	Address in the server to write to.
	\param[in] 	Unit	Identity of the unit (0-255) in the server.
	\param[out] Busy	Set to TRUE when function are busy.
	\param[out] Done	When the function has completed succesfully, this value is set to TRUE.
	\param[out] Error	If an error occurs while exeuting the function, this output is set to TRUE.
	\param[out] ErrorID	Error number from the function block.
	\param[out] Status	Normally set to zero otherwise something is wrong or function are waiting to get completed.
*/
void MB_Write4ByteHoldingRegisters(struct MB_Write4ByteHoldingRegisters* inst)
{
	CHECK_INPUT_QUANTITY_MACRO(BRSE_MB_MAX_HOLDING_REG_WRITE)
	EXEC_MODBUS_FUNCTION_MACRO(BRSE_MB_WRITE_MULTIPLE_REG_4BYTE)
}

/*! \interface MB_WriteCoils
	\brief Client: Write event triggered to a coil
	
	\param[in] 	ClientID	Identity created in AllocClient.
	\param[in]	Execute	Enables execution.
	\param[in]	Quantity	Number of register to write to.
	\param[in]	VariablesAddress	Address of the bool variable.
	\param[in]	StartAddress	Address in the server to write to.
	\param[in] 	Unit	Identity of the unit (0-255) in the server.
	\param[out] Busy	Set to TRUE when function are busy.
	\param[out] Done	When the function has completed succesfully, this value is set to TRUE.
	\param[out] Error	If an error occurs while exeuting the function, this output is set to TRUE.
	\param[out] ErrorID	Error number from the function block.
	\param[out] Status	Normally set to zero otherwise something is wrong or function are waiting to get completed.
*/
void MB_WriteCoils(struct MB_WriteCoils* inst)
{
	CHECK_INPUT_QUANTITY_MACRO(BRSE_MB_MAX_COILS_WRITE)
	EXEC_MODBUS_FUNCTION_MACRO(inst->Quantity == 1 ? BRSE_MB_WRITE_SINGLE_COIL : BRSE_MB_WRITE_MULTIPLE_COILS)
}

/*! \interface MB_ReadHoldingRegisters
	\brief Client: Read event triggered from a holding register
	
	\param[in] 	ClientID	Identity created in AllocClient.
	\param[in]	Execute	Enables execution.
	\param[in]	Quantity	Number of register to read from.
	\param[in]	VariablesAddress	Address of the integer variable.
	\param[in]	StartAddress	Address in the server to read from.
	\param[in] 	Unit	Identity of the unit (0-255) in the server.
	\param[out] Busy	Set to TRUE when function are busy.
	\param[out] Done	When the function has completed succesfully, this value is set to TRUE.
	\param[out] Error	If an error occurs while exeuting the function, this output is set to TRUE.
	\param[out] ErrorID	Error number from the function block.
	\param[out] Status	Normally set to zero otherwise something is wrong or function are waiting to get completed.
*/
void MB_ReadHoldingRegisters(struct MB_ReadHoldingRegisters* inst)
{
	CHECK_INPUT_QUANTITY_MACRO(BRSE_MB_MAX_HOLDING_REG_READ)
	EXEC_MODBUS_FUNCTION_MACRO(BRSE_MB_READ_HOLDING_REGISTERS)
}

/*! \interface MB_Read4ByteHoldingRegisters
	\brief Client: Read event triggered from a 4 byte register using 2 holding registers
	
	\param[in] 	ClientID	Identity created in AllocClient.
	\param[in]	Execute	Enables execution.
	\param[in]	Quantity	Number of 4-byte variables to read. Corresponds to the double amount of holding registers.
	\param[in]	VariablesAddress	Address of the 4 byte variable.
	\param[in]	StartAddress	Address in the server to read from.
	\param[in] 	Unit	Identity of the unit (0-255) in the server.
	\param[out] Busy	Set to TRUE when function are busy.
	\param[out] Done	When the function has completed succesfully, this value is set to TRUE.
	\param[out] Error	If an error occurs while exeuting the function, this output is set to TRUE.
	\param[out] ErrorID	Error number from the function block.
	\param[out] Status	Normally set to zero otherwise something is wrong or function are waiting to get completed.
*/
void MB_Read4ByteHoldingRegisters(struct MB_Read4ByteHoldingRegisters* inst)
{
	CHECK_INPUT_QUANTITY_MACRO(BRSE_MB_MAX_HOLDING_REG_READ)
	EXEC_MODBUS_FUNCTION_MACRO(BRSE_MB_READ_HOLDING_REG_4BYTE)
}

/*! \interface MB_ReadCoils
	\brief Client: Read event triggered from a coil
	
	\param[in] 	ClientID	Identity created in AllocClient.
	\param[in]	Execute	Enables execution.
	\param[in]	Quantity	Number of register to read from.
	\param[in]	VariablesAddress	Address of the bool variable.
	\param[in]	StartAddress	Address in the server to read from.
	\param[in] 	Unit	Identity of the unit (0-255) in the server.
	\param[out] Busy	Set to TRUE when function are busy.
	\param[out] Done	When the function has completed succesfully, this value is set to TRUE.
	\param[out] Error	If an error occurs while exeuting the function, this output is set to TRUE.
	\param[out] ErrorID	Error number from the function block.
	\param[out] Status	Normally set to zero otherwise something is wrong or function are waiting to get completed.
*/
void MB_ReadCoils(struct MB_ReadCoils* inst)
{
	CHECK_INPUT_QUANTITY_MACRO(BRSE_MB_MAX_COILS)
	EXEC_MODBUS_FUNCTION_MACRO(BRSE_MB_READ_COILS)
}

/*! \interface MB_ReadInputRegisters
	\brief Client: Read event triggered from a input register
	
	\param[in] 	ClientID	Identity created in AllocClient.
	\param[in]	Execute	Enables execution.
	\param[in]	Quantity	Number of register to read from.
	\param[in]	VariablesAddress	Address of the integer variable.
	\param[in]	StartAddress	Address in the server to read from.
	\param[in] 	Unit	Identity of the unit (0-255) in the server.
	\param[out] Busy	Set to TRUE when function are busy.
	\param[out] Done	When the function has completed succesfully, this value is set to TRUE.
	\param[out] Error	If an error occurs while exeuting the function, this output is set to TRUE.
	\param[out] ErrorID	Error number from the function block.
	\param[out] Status	Normally set to zero otherwise something is wrong or function are waiting to get completed.
*/
void MB_ReadInputRegisters(struct MB_ReadInputRegisters* inst)
{
	CHECK_INPUT_QUANTITY_MACRO(BRSE_MB_MAX_INPUT_REG_READ)
	EXEC_MODBUS_FUNCTION_MACRO(BRSE_MB_READ_INPUT_REGISTERS)
}

/*! \interface MB_ReadDiscreteInputs
	\brief Client: Read event triggered from a discreate input
	
	\param[in] 	ClientID	Identity created in AllocClient.
	\param[in]	Execute	Enables execution.
	\param[in]	Quantity	Number of register to read from.
	\param[in]	VariablesAddress	Address of the bool variable.
	\param[in]	StartAddress	Address in the server to read from.
	\param[in] 	Unit	Identity of the unit (0-255) in the server.
	\param[out] Busy	Set to TRUE when function are busy.
	\param[out] Done	When the function has completed succesfully, this value is set to TRUE.
	\param[out] Error	If an error occurs while exeuting the function, this output is set to TRUE.
	\param[out] ErrorID	Error number from the function block.
	\param[out] Status	Normally set to zero otherwise something is wrong or function are waiting to get completed.
*/
void MB_ReadDiscreteInputs(struct MB_ReadDiscreteInputs* inst)
{
	CHECK_INPUT_QUANTITY_MACRO(BRSE_MB_MAX_DISCRETE_INPUTS)
	EXEC_MODBUS_FUNCTION_MACRO(BRSE_MB_READ_DISCRETE_INPUTS)
}

/*! \interface MB_PushHoldingRegisters
	\brief Client: Write cyclic to a holding register
	
	\param[in] 	ClientID	Identity created in AllocClient.
	\param[in]	Enable	Enables execution.
	\param[in]	Quantity	Number of register to write to.
	\param[in]	PushInterval	Interval in ms between the Write requests.
	\param[in]	VariablesAddress	Address of the integer variable.
	\param[in]	StartAddress	Address in the server to write to.
	\param[in] 	Unit	Identity of the unit (0-255) in the server.
	\param[out] UpdateDone	When the function has completed succesfully, this value is set to TRUE.
	\param[out] Active	Set to TRUE when function is active.
	\param[out] Busy	Set to TRUE when function is accessing the server.
	\param[out] Error	If an error occurs while exeuting the function, this output is set to TRUE.
	\param[out] ErrorID	Error number from the function block.
	\param[out] Status	Normally set to zero otherwise something is wrong or function are waiting to get completed.
*/
void MB_PushHoldingRegisters(struct MB_PushHoldingRegisters* inst)
{
	CHECK_INPUT_QUANTITY_CYCLIC_MACRO(BRSE_MB_MAX_HOLDING_REG_WRITE)	
	EXEC_MODBUS_CYCLIC_FUNCTION_MACRO((inst->Quantity == 1) ? BRSE_MB_WRITE_SINGLE_REGISTER : BRSE_MB_WRITE_MULTIPLE_REGISTERS, inst->PushInterval)
}

/*! \interface MB_Push4ByteHoldingRegisters
	\brief Client: Write cyclic to a 4 byte register using 2 holding registers
	
	\param[in] 	ClientID	Identity created in AllocClient.
	\param[in]	Enable	Enables execution.
	\param[in]	Quantity	Number of 4-byte variables to write to. Corresponds to the double amount of holding registers.
	\param[in]	PushInterval	Interval in ms between the Write requests.
	\param[in]	VariablesAddress	Address of the 4 byte variable.
	\param[in]	StartAddress	Address in the server to write to.
	\param[in] 	Unit	Identity of the unit (0-255) in the server.
	\param[out] UpdateDone	When the function has completed succesfully, this value is set to TRUE.
	\param[out] Active	Set to TRUE when function is active.
	\param[out] Busy	Set to TRUE when function is accessing the server.
	\param[out] Error	If an error occurs while exeuting the function, this output is set to TRUE.
	\param[out] ErrorID	Error number from the function block.
	\param[out] Status	Normally set to zero otherwise something is wrong or function are waiting to get completed.
*/
void MB_Push4ByteHoldingRegisters(struct MB_Push4ByteHoldingRegisters* inst)
{
	CHECK_INPUT_QUANTITY_CYCLIC_MACRO(BRSE_MB_MAX_HOLDING_REG_WRITE)
	EXEC_MODBUS_CYCLIC_FUNCTION_MACRO(BRSE_MB_WRITE_MULTIPLE_REG_4BYTE, inst->PushInterval)
}

/*! \interface MB_PushCoils
	\brief Client: Write cyclic to a coil
	
	\param[in] 	ClientID	Identity created in AllocClient.
	\param[in]	Enable	Enables execution.
	\param[in]	Quantity	Number of register to write to.
	\param[in]	PushInterval	Interval in ms between the Write requests.
	\param[in]	VariablesAddress	Address of the bool variable.
	\param[in]	StartAddress	Address in the server to write to.
	\param[in] 	Unit	Identity of the unit (0-255) in the server.
	\param[out] UpdateDone	When the function has completed succesfully, this value is set to TRUE.
	\param[out] Active	Set to TRUE when function is active.
	\param[out] Busy	Set to TRUE when function is accessing the server.
	\param[out] Error	If an error occurs while exeuting the function, this output is set to TRUE.
	\param[out] ErrorID	Error number from the function block.
	\param[out] Status	Normally set to zero otherwise something is wrong or function are waiting to get completed.
*/
void MB_PushCoils(struct MB_PushCoils* inst)
{
	CHECK_INPUT_QUANTITY_CYCLIC_MACRO(BRSE_MB_MAX_COILS_WRITE)
	EXEC_MODBUS_CYCLIC_FUNCTION_MACRO(inst->Quantity == 1 ? BRSE_MB_WRITE_SINGLE_COIL : BRSE_MB_WRITE_MULTIPLE_COILS, inst->PushInterval)	
}

/*! \interface MB_PollHoldingRegisters
	\brief Client: Read cyclic from a holding register
	
	\param[in] 	ClientID	Identity created in AllocClient.
	\param[in]	Enable	Enables execution.
	\param[in]	Quantity	Number of register to read from.
	\param[in]	PollInterval	Interval in ms between the Read requests.
	\param[in]	VariablesAddress	Address of the integer variable.
	\param[in]	StartAddress	Address in the server to read from.
	\param[in] 	Unit	Identity of the unit (0-255) in the server.
	\param[out] UpdateDone	When the function has completed succesfully, this value is set to TRUE.
	\param[out] Active	Set to TRUE when function is active.
	\param[out] Busy	Set to TRUE when function is accessing the server.
	\param[out] Error	If an error occurs while exeuting the function, this output is set to TRUE.
	\param[out] ErrorID	Error number from the function block.
	\param[out] Status	Normally set to zero otherwise something is wrong or function are waiting to get completed.
*/
void MB_PollHoldingRegisters(struct MB_PollHoldingRegisters* inst)
{
	CHECK_INPUT_QUANTITY_CYCLIC_MACRO(BRSE_MB_MAX_HOLDING_REG_READ)
	EXEC_MODBUS_CYCLIC_FUNCTION_MACRO(BRSE_MB_READ_HOLDING_REGISTERS, inst->PollInterval)
}

/*! \interface MB_Poll4ByteHoldingRegisters
	\brief Client: Read cyclic from a 4 byte register using 2 holding registers
	
	\param[in] 	ClientID	Identity created in AllocClient.
	\param[in]	Enable	Enables execution.
	\param[in]	Quantity	Number of 4-byte variables to read. Corresponds to the double amount of holding registers.
	\param[in]	PollInterval	Interval in ms between the Read requests.
	\param[in]	VariablesAddress	Address of the 4 byte variable.
	\param[in]	StartAddress	Address in the server to read from.
	\param[in] 	Unit	Identity of the unit (0-255) in the server.
	\param[out] UpdateDone	When the function has completed succesfully, this value is set to TRUE.
	\param[out] Active	Set to TRUE when function is active.
	\param[out] Busy	Set to TRUE when function is accessing the server.
	\param[out] Error	If an error occurs while exeuting the function, this output is set to TRUE.
	\param[out] ErrorID	Error number from the function block.
	\param[out] Status	Normally set to zero otherwise something is wrong or function are waiting to get completed.
*/
void MB_Poll4ByteHoldingRegisters(struct MB_Poll4ByteHoldingRegisters* inst)
{
	CHECK_INPUT_QUANTITY_CYCLIC_MACRO(BRSE_MB_MAX_HOLDING_REG_READ)
	EXEC_MODBUS_CYCLIC_FUNCTION_MACRO(BRSE_MB_READ_HOLDING_REG_4BYTE, inst->PollInterval)
}

/*! \interface MB_PollCoils
	\brief Client: Read cyclic from a coil
	
	\param[in] 	ClientID	Identity created in AllocClient.
	\param[in]	Enable	Enables execution.
	\param[in]	Quantity	Number of register to read from.
	\param[in]	PollInterval	Interval in ms between the Read requests.
	\param[in]	VariablesAddress	Address of the bool variable.
	\param[in]	StartAddress	Address in the server to read from.
	\param[in] 	Unit	Identity of the unit (0-255) in the server.
	\param[out] UpdateDone	When the function has completed succesfully, this value is set to TRUE.
	\param[out] Active	Set to TRUE when function is active.
	\param[out] Busy	Set to TRUE when function is accessing the server.
	\param[out] Error	If an error occurs while exeuting the function, this output is set to TRUE.
	\param[out] ErrorID	Error number from the function block.
	\param[out] Status	Normally set to zero otherwise something is wrong or function are waiting to get completed.
*/
void MB_PollCoils(struct MB_PollCoils* inst)
{
	CHECK_INPUT_QUANTITY_CYCLIC_MACRO(BRSE_MB_MAX_COILS)
	EXEC_MODBUS_CYCLIC_FUNCTION_MACRO(BRSE_MB_READ_COILS, inst->PollInterval)
}

/*! \interface MB_PollInputRegisters
	\brief Client: Read cyclic from a input register
	
	\param[in] 	ClientID	Identity created in AllocClient.
	\param[in]	Enable	Enables execution.
	\param[in]	Quantity	Number of register to read from.
	\param[in]	PollInterval	Interval in ms between the Read requests.
	\param[in]	VariablesAddress	Address of the integer variable.
	\param[in]	StartAddress	Address in the server to read from.
	\param[in] 	Unit	Identity of the unit (0-255) in the server.
	\param[out] UpdateDone	When the function has completed succesfully, this value is set to TRUE.
	\param[out] Active	Set to TRUE when function is active.
	\param[out] Busy	Set to TRUE when function is accessing the server.
	\param[out] Error	If an error occurs while exeuting the function, this output is set to TRUE.
	\param[out] ErrorID	Error number from the function block.
	\param[out] Status	Normally set to zero otherwise something is wrong or function are waiting to get completed.
*/
void MB_PollInputRegisters(struct MB_PollInputRegisters* inst)
{
	CHECK_INPUT_QUANTITY_CYCLIC_MACRO(BRSE_MB_MAX_INPUT_REG_READ)
	EXEC_MODBUS_CYCLIC_FUNCTION_MACRO(BRSE_MB_READ_INPUT_REGISTERS, inst->PollInterval)
}

/*! \interface MB_PollDiscreteInputs
	\brief Client: Read cyclic from a discreate input
	
	\param[in] 	ClientID	Identity created in AllocClient.
	\param[in]	Enable	Enables execution.
	\param[in]	Quantity	Number of register to read from.
	\param[in]	PollInterval	Interval in ms between the Read requests.
	\param[in]	VariablesAddress	Address of the bool variable.
	\param[in]	StartAddress	Address in the server to read from.
	\param[in] 	Unit	Identity of the unit (0-255) in the server.
	\param[out] UpdateDone	When the function has completed succesfully, this value is set to TRUE.
	\param[out] Active	Set to TRUE when function is active.
	\param[out] Busy	Set to TRUE when function is accessing the server.
	\param[out] Error	If an error occurs while exeuting the function, this output is set to TRUE.
	\param[out] ErrorID	Error number from the function block.
	\param[out] Status	Normally set to zero otherwise something is wrong or function are waiting to get completed.
*/
void MB_PollDiscreteInputs(struct MB_PollDiscreteInputs* inst)
{
	CHECK_INPUT_QUANTITY_CYCLIC_MACRO(BRSE_MB_MAX_DISCRETE_INPUTS)
	EXEC_MODBUS_CYCLIC_FUNCTION_MACRO(BRSE_MB_READ_DISCRETE_INPUTS, inst->PollInterval)
}
