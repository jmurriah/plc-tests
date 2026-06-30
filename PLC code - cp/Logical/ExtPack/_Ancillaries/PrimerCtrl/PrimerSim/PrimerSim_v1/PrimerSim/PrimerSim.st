PROGRAM _INIT

	Primer ACCESS ADR(gPrimer);
	SimPrimer ACCESS ADR(gSimPrimer);

	Primer.Status.Comms.xModuleOk := TRUE;

END_PROGRAM
	
PROGRAM _CYCLIC
	(* Insert code here *)
	Primer ACCESS ADR(gPrimer);
	SimPrimer ACCESS ADR(gSimPrimer);
	
	IF NOT Primer.Parameters.xInstalled THEN
		Primer.Inputs := PrimerInputsReseted;
		RETURN;
	END_IF
	
	Primer.Inputs.xPrimerPresent:=TRUE;
	Primer.Inputs.Comms.xRemote := TRUE;
	Primer.Inputs.xError:=SimPrimer.Commands.CreateError;
	
	tonTransport.IN:= Primer.Outputs.Physical.xRunTransport;
	tonTransport.PT:= T#1s;
	tonTransport();
	Primer.Inputs.xTransportMoving:=tonTransport.Q;
	
	tonReady.IN:= Primer.Inputs.xTransportMoving AND Primer.Outputs.Physical.xPrepareToPrime;
	tonReady.PT:= T#2s;
	tonReady();
	Primer.Inputs.xReadyToPrime:=tonReady.Q;
	
	tonPrime.IN:= Primer.Inputs.xReadyToPrime AND Primer.Outputs.Physical.xRunPriming;
	tonPrime.PT:= T#1s;
	tonPrime();
	Primer.Inputs.xCoating:=tonPrime.Q;
	
	tonDry.IN:= Primer.Inputs.xCoating AND Primer.Outputs.Physical.xRunDryer;
	tonDry.PT:= T#1s;
	tonDry();
	Primer.Inputs.xDryerInRun:=tonDry.Q;
	
	Primer.Inputs.Comms.xBeltEmpty:=TRUE;
	Primer.Inputs.Comms.xCommsOK:=TRUE;
	
END_PROGRAM