PROGRAM _INIT

	Opv ACCESS ADR(gOverVarnish);

	Opv.Status.Comms.xModuleOk := TRUE;

END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	Opv ACCESS ADR(gOverVarnish);
	SimOpv ACCESS ADR(gSimOverVarnish);
	
	Opv.Inputs.xOPVPresent:=TRUE;
	Opv.Inputs.Comms.xRemote := TRUE;
	Opv.Inputs.xError:=SimOpv.Commands.CreateError;
	
	tonTransport.IN:= Opv.Outputs.Physical.xRunTransport;
	tonTransport.PT:= T#1s;
	tonTransport();
	Opv.Inputs.xTransportMoving:=tonTransport.Q;
	
	tonReady.IN:= Opv.Inputs.xTransportMoving AND Opv.Outputs.Physical.xPrepareToPrime;
	tonReady.PT:= T#2s;
	tonReady();
	Opv.Inputs.xReadyToPrime:=tonReady.Q;
	
	tonPrime.IN:= Opv.Inputs.xReadyToPrime AND Opv.Outputs.Physical.xRunPriming;
	tonPrime.PT:= T#1s;
	tonPrime();
	Opv.Inputs.xCoating:=tonPrime.Q;
	
	tonDry.IN:= Opv.Inputs.xCoating AND Opv.Outputs.Physical.xRunDryer;
	tonDry.PT:= T#1s;
	tonDry();
	Opv.Inputs.xDryerInRun:=tonDry.Q;
	
	Opv.Inputs.Comms.xBeltEmpty:=TRUE;
	Opv.Inputs.Comms.xCommsOK:=TRUE;
	
END_PROGRAM