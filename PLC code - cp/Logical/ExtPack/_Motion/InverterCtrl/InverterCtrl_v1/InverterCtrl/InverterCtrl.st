(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: I66Ctrl
 * File: I66Ctrl.st
 * Author: tresensa
 * Created: May 09, 2014
 ********************************************************************
 * Implementation of program InvCtrl
 ********************************************************************)

PROGRAM _INIT
	
	ErrorTable;	(* Writes the error table *)
	
	ErrorTableACS380;	(* Writes the error table *)

	ErrMessage_FUB.Enable	:= TRUE;
	ErrMessage_FUB.ErrList	:= Error;
	
	RTInfo_0(enable:=TRUE); (* Get cycle time *)
	SimCycleTime := UDINT_TO_REAL(RTInfo_0.cycle_time) / 1000000; (* Conversion to seconds *)
	
END_PROGRAM


PROGRAM _CYCLIC

	dataInv ACCESS ADR (gAxisInverter[iIndexInverter]);
	
	CASE dataInv.Parameters.CommsType OF
		COMMS_POWERLINK:	
			CASE dataInv.Parameters.Type OF
				INV_BR:
					ioMap ACCESS ADR (gInverterSignalsPowerLink[iIndexInverter]);
				INV_ABB:
					ioMap ACCESS ADR (gInverterSignalsPowerLinkABB[iIndexInverter]);
			END_CASE;
			
		COMMS_CANOPEN: 		ioMap ACCESS ADR (gInverterSignalsCanOpen[iIndexInverter]);
			
		ELSE
			//If comms type is not configured, go to next inverter
			//Prepare the index for the next Inverter
			dataInv.Status.ErrorComms := TRUE;
			iIndexInverter := iIndexInverter + 1;
			RETURN;
	END_CASE

	ResetComms;
	
	GenInverterCtrl;
	
	//Prepare the index for the next Inverter
	iIndexInverter := iIndexInverter + 1;
	
END_PROGRAM
