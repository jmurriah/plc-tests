/*! \file BRSE_MB_Main.h */

/*! \mainpage BRSE_MB 

	\section Introduction
	
	This library is used for setting up a modbus server and a modbus client. 
	It contains functions for allocating units and bind registers and coils to variables.
	
	The Modbus data model has a simple structure that differentiates
	between four basic data types:
	
	\arg Discrete Inputs (BOOL Read-Only)
	\arg Coils (BOOL Read-Write)
	\arg Input Registers (INT Read-Only)
	\arg Holding Registers (INT Read-Write)
	
	(The expression "Input" is seen from the Client side).
	
	\section Server
	
	The server is represented as a function block for responding to modbus messages, by processing an input buffer 
	and create an output buffer. This buffer may then be "framed" for the desired communication protocol.
	The server block is used in BRSE_MBR (rtu) and BRSE_MBT (tcp). These libraries (MBT, MBR) create the
	connection to a physical interface such as the Ethernet Port or the Serial port.



	\image html y:\Application\Libraries\BRSE_MB\Documentation\BRSE_MB_Server.jpg
	


	\par Server Side functions
	
	BRSE_MB_Alloc  - Allocates space for a unit with the specified number of coils, holding registers, discrete inputs
	and input registers.
	
	BRSE_MB_Coil - Binds a unit coil reference with a boolean variable.
	
	BRSE_MB_HoldingRegister - Binds a unit holding register reference with an integer variable.
	
	BRSE_MB_InputRegister - Binds a unit input register reference with an integer variable.
	
	BRSE_MB_DiscreteInput - Binds a unit discrete input reference with a boolean variable.
	
	BRSE_MB_4ByteHoldingRegister - Binds a 4 byte variable to 2 holding registers

	BRSE_MB_Server - Responds to modbus messages by creating the output buffer containing the response. It is used by BRSE_MBR 
	and BRSE_MBT and is not usually not implemented directly by the user.
	
	For an example on how to use this library, see BRSE_MBR or BRSE_MBT.

	\section Client
	
	The client is represented as a function block for creating modbus messages, by generate a request queue buffer 
	and listen for response from the server. This buffer may then be "framed" for the desired communication protocol.
	The client block is used in BRSE_MBR (rtu) and BRSE_MBT (tcp). These libraries (MBT, MBR) create the
	connection to a physical interface such as the Ethernet Port or the Serial port.



	\image html y:\Application\Libraries\BRSE_MB\Documentation\BRSE_MB_Client.jpg
	


	\par Client Side Functions
	
	MB_AllocClient - Allocates space for a client request queue.
	
	MB_ReadDiscreteInputs - Read event triggered from a discreate input.
	
	MB_ReadCoils - Read event triggered from a coil.
	
	MB_ReadInputRegisters - Read event triggered from a input register.
	
	MB_ReadHoldingRegisters - Read event triggered from a holding register.
	
	MB_PollDiscreteInputs - Read cyclic from a discreate input.
	
	MB_PollCoils - Read cyclic from a coil.
	
	MB_PollInputRegisters - Read cyclic from a input register.
	
	MB_PollHoldingRegisters - Read cyclic from a holding register.
	
	MB_WriteCoils - Write event triggered to a coil.

	MB_WriteHoldingRegisters - Write event triggered to a holding register.
	
	MB_PushCoils - Write cyclic to a coil.
	
	MB_PushHoldingRegisters - Write cyclic to a holding register.

	MB_Poll4ByteHoldingRegisters - Read cyclic from a 4 byte register
	
	MB_Push4ByteHoldingRegisters - Write cyclic to a 4 byte register

	MB_Write4ByteHoldingRegisters - Write event triggered to a 4 byte register

	MB_Read4ByteHoldingRegisters - Read event triggered from a 4 byte register

	\par Internal Functions

	MB_CreateClientRequest - Create request as a modbus message. It is used by BRSE_MBR and BRSE_MBT and is not usually not implemented directly by the user.

	MB_PutClientResponse - Create respons as a modbus message. It is used by BRSE_MBR and BRSE_MBT and is not usually not implemented directly by the user.
	
	\par Example

	For an example on how to use this library, see BRSE_MBR or BRSE_MBT.
	
	When reading and writeing many variables it is convenient to use arrays.
	Just set the address to the first element in the array (FB_MB_WriteCoils.VariablesAddress := ADR(startMotor[0]))
	and set the number of element in the array (FB_MB_WriteCoils.Quantity := 3;)
*/

/*! \page Error_Number Error Numbers and Constants

	\section internal_err Internal Error Numbers
	
	These error numbers can be set on the Status output of the respective BRSE_MB function block.
	
	\b 20004 MB_ERR_CLIENT_NOT_ALLOCATED: A request was requested from a client which hasn't been allocated
	
	\b 20005 MB_ERR_BUFFER: Buffer is too small for request or buffer address is 0 
	
	\b 20006 MB_ERR_QUEUE_FULL: The queue is full
	
	\b 20007 MB_ERR_INTERNAL: Internal error
	
	\b 20008 MB_ERR_PROTOCOL: Error in protocol
	
	\b 20009 MB_ERR_QUANTITY: The quantity is too big or 0

	
	\section modbus_err Modbus Error Numbers
	
	These error numbers can be set on the Status output of the respective BRSE_MB function block.
	
	\b 1 ERROR_ILLEGAL_FUNCTlON
	The function code received in the query is not an allowable action for the slave. This may be
	because the function code is only applicable to newer controllers, and was not implemented in the
	unit selected. It could also indicate that the slave is in the wrong state to process a request of this
	type, for example because it is unconfigured and is being asked to return register values.

	\b 2 ERROR_ILLEGAL_DATA_ADDRESS
	The data address received in the query is not an allowable address for the slave. More specifically,
	the combination of reference number and transfer length is invalid. For a controller with 100
	registers, a request with offset 96 and length 4 would succeed, a request with offset 96 and length
	5 will generate exception 02.

	\b 3 ERROR_ILLEGAL_DATA_VALUE
	A value contained in the query data field is not an allowable value for the slave. This indicates a
	fault in the structure of the remainder of a complex request, such as that the implied length is
	incorrect. It specifically does NOT mean that a data item submitted for storage in a register has a
	value outside the expectation of the application program, since the MODBUS protocol is unaware
	of the significance of any particular value of any particular register.
	
	\b 4 ERROR_ILLEGAL_RESPONSE_LENGTH
	Indicates that the request as framed would generate a response whose size exceeds the available
	MODBUS data size. Used only by functions generating a multi-part response, such as functions 20 and 21


	\section consts Constants

	These Constants are set to the ServerFormat or ClientFormat inputs to define which Byte-alignment
	that is in use on the opposite station.

	\b 0 	BRSE_MB_INTEL: The server/client on the other side uses the Intel format

	\b 1 	BRSE_MB_MOTOROLA: The server/client on the other side uses the Motorola format

	
*/



#ifndef _BRSE_MB_MAIN_
#define _BRSE_MB_MAIN_

#include <bur/plctypes.h>
#include "BRSE_MB.h"
#include <string.h>
#include <AsIecCon.h>
#endif


/* internal functions in library */

/* implemented in BRSE_MB_Server.c */
UINT BRSE_MB_ReadCoils(struct BRSE_MB_Server* inst);
UINT BRSE_MB_ReadDiscreteInputs(struct BRSE_MB_Server* inst);
UINT BRSE_MB_ReadHoldingRegisters(struct BRSE_MB_Server* inst);
UINT BRSE_MB_ReadInputRegisters(struct BRSE_MB_Server* inst);
UINT BRSE_MB_WriteSingleCoil(struct BRSE_MB_Server* inst);
UINT BRSE_MB_WriteSingleRegister(struct BRSE_MB_Server* inst);
UINT BRSE_MB_WriteMultipleCoils(struct BRSE_MB_Server* inst);
UINT BRSE_MB_WriteMultipleRegisters(struct BRSE_MB_Server* inst);
UINT BRSE_MB_FillDigitalBuffer(struct BRSE_MB_Server* inst, UDINT *boolPtrArray);
UINT BRSE_MB_FillRegisterBuffer(struct BRSE_MB_Server* inst, UDINT *intPtrArray);

UINT BRSE_MB_FillRegisterBuffer4Byte(USINT ServerFormat, struct BRSE_MB_Server* inst, UDINT *intPtrArray);
void MB_FillRegisterValues4Byte(USINT ServerFormat, USINT *pByteBuffer, MB_ClientQueueItem_typ *pQueueItem);

/* implemented in BRSE_MB_Client.c */
void MB_FillRegisterValues(USINT *pByteBuffer, MB_ClientQueueItem_typ *pQueueItem); /* implemented in this file */
void MB_FillCoilValues(USINT *pByteBuffer, MB_ClientQueueItem_typ *pQueueItem);

/* implemented in MB_RequestQueue.c*/
UINT MB_AddToRequestQueue(USINT clientID, USINT fc, UINT quantity, UINT startAddress, UDINT variableAddress, UDINT statusAddress, USINT Unit);
/* Checking if the queue is presumably alive or dead. 0=dead, 1=alive */
USINT MB_QueueStatus(USINT ClientID);
