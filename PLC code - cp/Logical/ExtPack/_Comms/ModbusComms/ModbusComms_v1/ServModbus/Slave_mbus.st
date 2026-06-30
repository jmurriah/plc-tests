(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: Slave_mbus
 * File: Slave_mbus.st
 * Author: gimeneza
 * Created: March 07, 2017
 ********************************************************************
 * Implementation of program Slave_mbus
 ********************************************************************)

PROGRAM _INIT
	ident := 1; 
	(* Create a Modbus server with unit identity = 1, Coil = 0, HoldingRegister = 9000, DiscreteInputs = 0, InputRegister = 0 *)
	BRSE_MB_Alloc(ident,1000,9000,0,0);
	
	(* Bind the holding registers *)
	FOR i:=0 TO 8999 DO
		BRSE_MB_HoldingRegister(ident,i,ADR(HoldingRegister[i]));
	END_FOR;
	
END_PROGRAM
        
PROGRAM _CYCLIC
        
    (* Enable the server, use INTEL alignment (little endian) for real Values *)
	FB_BRSE_MBT_Server(Enable := 1, ClientFormat := BRSE_MB_INTEL, Port := 502, SocketTimeout:=5000);
	
END_PROGRAM
        
PROGRAM _EXIT
        
    (* Close the open tcp port *)
	FB_MBT_ServerExit();
        
END_PROGRAM

