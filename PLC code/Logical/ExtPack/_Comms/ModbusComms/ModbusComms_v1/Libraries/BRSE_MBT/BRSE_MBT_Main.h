/*! \file BRSE_MBT_Main.h */
	
/*!	\mainpage BRSE_MBT

	\section Introduction

	This library is used for setting up a modbus server and a modbus client. 

	The Modbus data model has a simple structure that differentiates
	between four basic data types:
	
	\arg Discrete Inputs (BOOL Read-Only)
	\arg Coils (BOOL Read-Write)
	\arg Input Registers (INT Read-Only)
	\arg Holding Registers (INT Read-Write)
	
	(The expression "Input" is seen from the Client side).
	\anchor tasks
	\section Example_tasks Example tasks 

	The source code to the example tasks can be found
	<a href="y:\Application\Libraries\BRSE_MBT\Documentation\MBT_example_tasks.zip">here</a>.
	
	\section Server
	
	The BRSE_MBT_Server function block acts as a modbus server. When enabled, it opens the tcp port 502 and starts
	listen for incoming modbus messages.

	Requests from each client are responded to in the same cycle. 
	
	That brings the execution time to depend very much on the server load, i.e. frequency of client requests. 
	
	Therefore, the program executing BRSE_MBT_Server needs to be put in a task class with high tolerance.
	
	It is recommended that the program is put in a fast (10-20ms), low priority task with high tolerance.
	
	\image html y:\Application\Libraries\BRSE_MBT\Documentation\BRSE_MBT_Server.jpg

	Units must be allocated with the BRSE_MB_Alloc function in the BRSE_MB library.
	
	MBT_ServerExit closes open tcp ports and should be called in the exit routine of the program.

	
	\section Client
	
	The MBT_Client is used together with the master/client functions of the BRSE_MB library.
	When a request (for example "Read 100 coils on unit 2 starting on address 5") has been placed in queue,
	this function block creates a modbus message, sends it to the server/slave and awaits a response.
	If no response is given, it resends the message after a certain time.
	
	\image html y:\Application\Libraries\BRSE_MBT\Documentation\BRSE_MBT_Client.jpg

	The client must be allocated with the MB_AllocClient function in the BRSE_MB library. A certain client ID 
	is passed to the alloc function and the same ID is passed to the MBT_Client function.

	MBT_ExitClient closes open tcp ports and should be called in the exit routine of the program.

*/



/*! \page Error_Numbers Error Numbers
	\section Error_Numbers Error Numbers
	
	\b 0 	BRSE_MBT_INTEL: The server/client uses the Intel format
	
	\b 1 	BRSE_MBT_MOTOROLA: The server/client uses the Motorola format

	\b 30001 BRSE_MBT_ERR_TOO_MANY_CLIENTS: Too many clients.
		
*/
#ifndef _BRSE_MBT_MAIN_
#define _BRSE_MBT_MAIN_

#include <bur/plctypes.h>
#include "BRSE_MBT.h"
#include <string.h>

#endif

/* Common functions */
UINT BRSE_MBT_AddClient(struct BRSE_MBT_Server* inst);
void BRSE_MBT_RemoveClient(struct BRSE_MBT_Server* inst, UINT clientIdx);
UINT BRSE_MBT_AnalyzeReqFromClient(struct BRSE_MBT_Server* inst, UINT clientIdx);
UINT BRSE_MBT_CreateErrorMessage(struct BRSE_MBT_Server* inst, UINT errorCode, UINT clientIdx);

