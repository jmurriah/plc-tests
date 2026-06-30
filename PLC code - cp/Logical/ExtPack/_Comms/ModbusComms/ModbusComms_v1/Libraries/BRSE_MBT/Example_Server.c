/*! 

 \page Example_server Example Server
 \section Example_server Example Server
 
 \par Description
	This program set up an TCP modbus server on the ethernet port of the system

 \par Example
  Example \ref tasks can be found here.

\par MBserv.var
\code
VAR
	FB_BRSE_MBT_Server : BRSE_MBT_Server := (0);
	FB_MBT_ServerExit : MBT_ServerExit := (0);
	discreteInput : ARRAY[0..9] OF BOOL := [9(FALSE)];
	coil : ARRAY[0..10] OF BOOL := [10(FALSE)];
	inputRegister : ARRAY[0..11] OF INT := [11(0)];
	holdingRegister : ARRAY[0..9] OF INT := [9(0)];
	realValue : ARRAY[0..5] OF REAL :=[5(0.0)];
	i : USINT := 0;
END_VAR
\endcode

\par MBserv.st
\code
PROGRAM _INIT
	
	(* Create a Modbus server with unit identity = 0, Coil = 10, HoldingRegister = 20, DiscreteInputs = 9, InputRegister = 11 *)
	BRSE_MB_Alloc(0,10,20,9,11);

	(* Bind the coils *)
	FOR i:=0 TO 10 DO
		BRSE_MB_Coil(0,i,ADR(coil[i]));
	END_FOR;
	(* Bind the discrete inputs *)
	FOR i:=0 TO 9 DO
		BRSE_MB_DiscreteInput(0,i,ADR(discreteInput[i]));
	END_FOR;
	(* Bind the holdning registers *)
	FOR i:=0 TO 9 DO
		BRSE_MB_HoldingRegister(0,i,ADR(holdingRegister[i]));
	END_FOR;
	(* Bind the input registers *)
	FOR i:=0 TO 11 DO
		BRSE_MB_InputRegister(0,i,ADR(inputRegister[i]));
	END_FOR;
	
	(* Bind 4 byte holdning registers to REAL values*)
	FOR i:=0 TO 5 DO
		BRSE_MB_4ByteHoldingRegister(0, 10 + i*2,ADR(realValue[i]));
	END_FOR;
	

END_PROGRAM
	
PROGRAM _CYCLIC
	
	(* Enable the server, use INTEL alignment (little endian) for real Values *)
	FB_BRSE_MBT_Server(Enable := 1, ClientFormat := BRSE_MB_INTEL);
	
END_PROGRAM
	
PROGRAM _EXIT
	
	(* Close the open tcp port *)
	FB_MBT_ServerExit();
	
END_PROGRAM

\endcode
*/
 
 
 
/*
 
 Example on how to use the BRSE_MBT Library as a modbus server in C

#include <bur/plctypes.h>

#ifdef _DEFAULT_INCLUDES
 #include <AsDefault.h>
#endif

void _INIT MBRTestINIT( void )
{
	UINT i;
	
	BRSE_MB_Alloc(1, NbrCoils, NbrHoldingRegisters, NbrDiscreteInputs, NbrInputRegisters);
	
	for (i=0; i<NbrCoils; i++)
	{
		BRSE_MB_Coil(1, i, (UDINT)&Coils[i]);
	}
	for (i=0; i<NbrHoldingRegisters; i++)
	{
		BRSE_MB_HoldingRegister(1, i, (UDINT)&HoldingRegisters[i]);
	}
	for (i=0; i<NbrDiscreteInputs; i++)
	{
		BRSE_MB_DiscreteInput(1, i, (UDINT)&DiscreteInputs[i]);
	}
	for (i=0; i<NbrInputRegisters; i++)
	{
		BRSE_MB_InputRegister(1, i, (UDINT)&InputRegisters[i]);
	}
	
	FB_BRSE_MBT_Server.Enable = 1;
}

void _CYCLIC MBRTestCYCLIC( void )
{		
	BRSE_MBT_Server(&FB_BRSE_MBR_Server);
}

*/

