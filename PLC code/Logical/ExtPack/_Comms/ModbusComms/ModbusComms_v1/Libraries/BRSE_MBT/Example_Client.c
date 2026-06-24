/*! 

 \page Example_client Example Client
 \section Example_client Example Client
 
 \par Description
	This program set up an TCP modbus client on the ethernet port of the system.
	The client can use both event driven and cyclic operation, in this example both are used.
	To send and recive the event driven variables startMotor and motorRunning the variable sendToServer need to be forced to TRUE.
	The variables setSpeed and actSpeed are automaticly updated every 200 taskcycle.

 \par Example
  Example \ref tasks can be found here.


\par MBclient.var
\code
VAR
	FB_MB_WriteCoils : MB_WriteCoils := (0);
	FB_MB_ReadDiscreteInputs : MB_ReadDiscreteInputs := (0);
	FB_MB_PushHoldingRegisters : MB_PushHoldingRegisters := (0);
	FB_MB_PollInputRegisters : MB_PollInputRegisters := (0);
	FB_MB_Poll4ByteHoldingRegisters : MB_Poll4ByteHoldingRegisters := (0);
	FB_MBT_Client : MBT_Client := (0);
	FB_MBT_ExitClient : MBT_ExitClient := (0);
	startMotor : ARRAY[0..2] OF BOOL := [3(FALSE)];
	motorRunning : ARRAY[0..2] OF BOOL := [3(FALSE)];
	setSpeed : ARRAY[0..2] OF INT := [3(0)];
	actSpeed : ARRAY[0..2] OF INT := [3(0)];
	actTemp : ARRAY[0..3] OF REAL := [4(0.0)];
	sendToServer : BOOL := FALSE;
	state : USINT := 0;
END_VAR
\endcode

\par MBclient.st
\code
PROGRAM _INIT

	MB_AllocClient(1);								(* Create a Modbus client with identity = 1 *)

	FB_MB_WriteCoils.ClientID			:= 1;				(* Identity created in AllocClient *)
	FB_MB_WriteCoils.Execute			:= 0;				(* Do not execute function block yet *)
	FB_MB_WriteCoils.Quantity			:= 3;				(* Number of register to write *)
	FB_MB_WriteCoils.VariablesAddress		:= ADR(startMotor[0]);		(* Address of the BOOL variable *)
	FB_MB_WriteCoils.StartAddress			:= 0;				(* Address in the server to write to *)
	FB_MB_WriteCoils.Unit				:= 0;				(* Unit identity in the server *)

	FB_MB_ReadDiscreteInputs.ClientID		:= 1;				(* Identity created in AllocClient *)
	FB_MB_ReadDiscreteInputs.Execute		:= 0;				(* Do not execute function block yet *)
	FB_MB_ReadDiscreteInputs.Quantity		:= 3;				(* Number of register to read *)
	FB_MB_ReadDiscreteInputs.VariablesAddress	:= ADR(motorRunning[0]);	(* Address of the BOOL variable *)
	FB_MB_ReadDiscreteInputs.StartAddress		:= 0;				(* Address in the server to read from *)
	FB_MB_ReadDiscreteInputs.Unit			:= 0;				(* Unit identity in the server *)

	FB_MB_PushHoldingRegisters.ClientID		:= 1;				(* Identity created in AllocClient *)
	FB_MB_PushHoldingRegisters.Enable		:= 0;				(* Do not enable function block yet *)
	FB_MB_PushHoldingRegisters.Quantity		:= 3;				(* Number of register to write *)
	FB_MB_PushHoldingRegisters.PushCycles		:= 200;				(* Number of cycles between write requests *)
	FB_MB_PushHoldingRegisters.VariablesAddress	:= ADR(setSpeed[0]);		(* Address of the INT variable *)
	FB_MB_PushHoldingRegisters.StartAddress		:= 0;				(* Address in the server to write to *)
	FB_MB_PushHoldingRegisters.Unit			:= 0;				(* Unit identity in the server *)

	FB_MB_PollInputRegisters.ClientID		:= 1;				(* Identity created in AllocClient *)
	FB_MB_PollInputRegisters.Enable			:= 0;				(* Do not enable function block yet *)
	FB_MB_PollInputRegisters.Quantity		:= 3;				(* Number of register to read *)
	FB_MB_PollInputRegisters.PushCycles		:= 200;				(* Number of cycles between read requests *)
	FB_MB_PollInputRegisters.VariablesAddress	:= ADR(actSpeed[0]);		(* Address of the INT variable *)
	FB_MB_PollInputRegisters.StartAddress		:= 0;				(* Address in the server to read from *)
	FB_MB_PollInputRegisters.Unit			:= 0;				(* Unit identity in the server *)

	FB_MB_Poll4ByteHoldingRegisters.ClientID		:= 1;				(* Identity created in AllocClient *)
	FB_MB_Poll4ByteHoldingRegisters.Enable			:= 0;				(* Do not enable function block yet *)
	FB_MB_Poll4ByteHoldingRegisters.Quantity		:= 4;				(* Number of REAL values to read *)
	FB_MB_Poll4ByteHoldingRegisters.PushCycles		:= 200;				(* Number of cycles between read requests *)
	FB_MB_Poll4ByteHoldingRegisters.VariablesAddress:= ADR(actTemp[0]);	(* Address of the REAL variable *)
	FB_MB_Poll4ByteHoldingRegisters.StartAddress	:= 10;				(* Address in the server to read from *)
	FB_MB_Poll4ByteHoldingRegisters.Unit			:= 0;				(* Unit identity in the server *)

	FB_MBT_Client.ClientID				:= 1;				(* Identity created in AllocClient *)
	FB_MBT_Client.IpAddr				:= '10.46.10.153';		(* Ip address to the modbus server *)
	FB_MBT_Client.Port				:= 502;				(* Port on the modbus server *)
	FB_MBT_Client.CycleTime				:= 10;				(* The cycletime of the task in ms *)
	FB_MBT_Client.ServerFormat		:= BRSE_MB_INTEL; (* real values from server are in INTEL format *)

END_PROGRAM

PROGRAM _CYCLIC

	CASE state OF
		0 : (* Init step *)
			IF sendToServer = TRUE THEN
   				state := 10;
			END_IF
			
		10: (* Send coils to server and wait for response *)
			FB_MB_WriteCoils.Execute := TRUE;
			IF FB_MB_WriteCoils.Done OR FB_MB_WriteCoils.Error THEN
				FB_MB_WriteCoils.Execute := FALSE;
   				state := 20;
			END_IF
			
		20: (* Read the discreate inputs from server and wait for response *)
			FB_MB_ReadDiscreteInputs.Execute := TRUE;
   			IF FB_MB_ReadDiscreteInputs.Done OR FB_MB_ReadDiscreteInputs.Error THEN			
				FB_MB_ReadDiscreteInputs.Execute := FALSE;
				state := 30;
			END_IF
			   
		30: (* Start over again *)
			sendToServer := FALSE;
			state := 0;
	
	END_CASE;

	FB_MB_PollInputRegisters.Enable		:= 1;	(* Enable function block *)
	FB_MB_PushHoldingRegisters.Enable	:= 1;	(* Enable function block *)
	FB_MBT_Client.Enable			:= 1;	(* Enable function block *)

	FB_MB_WriteCoils();				(* Call function block *)
	FB_MB_ReadDiscreteInputs();			(* Call function block *)
	FB_MB_PollInputRegisters();			(* Call function block *)
	FB_MB_PushHoldingRegisters();			(* Call function block *)
	FB_MB_Poll4ByteHoldingRegisters();	(* Call function block *)

	FB_MBT_Client();				(* Call function block *)

END_PROGRAM

PROGRAM _EXIT

	(* Close the open tcp port *)
	FB_MBT_ExitClient(ClientID := 1);

END_PROGRAM

\endcode
*/
 
 
 
/*
 

Example on how to use the BRSE_MBT Library as a modbus client in C

#include <bur/plctypes.h>

#ifdef _DEFAULT_INCLUDES
 #include <AsDefault.h>
#endif

void _INIT MBRTestINIT( void )
{
	MB_AllocClient(4); // 4 is the client id
	
	MBT_Client_0.Enable = 1;
	MBT_Client_0.ClientID = 4;
	strcpy(MBT_Client_0.IpAddr, "192.168.0.1");
	MBT_Client_0.Port = 502;
	MBT_Client_0.Unit = 1;
	MBT_Client_0.CycleTime = 50;
	
	// Prepare to call any of the modbus master functions from the BRSE_MB library
	FB_MB_PushHoldingRegisters.ClientID = 2;
	FB_MB_PushHoldingRegisters.Enable = 1;
	FB_MB_PushHoldingRegisters.PushCycles = 300;
	FB_MB_PushHoldingRegisters.Quantity = 4;
	FB_MB_PushHoldingRegisters.StartAddress = 3;
	FB_MB_PushHoldingRegisters.VariablesAddress = (UDINT)&(IntArr[0]);
}

void _CYCLIC MBRTestCYCLIC( void )
{		
	MB_PushHoldingRegisters(&MB_PushHoldingRegisters_0);
	MBT_Client(&MBT_Client_0);
}

*/
