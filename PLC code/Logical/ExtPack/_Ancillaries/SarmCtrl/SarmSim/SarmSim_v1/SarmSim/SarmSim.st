PROGRAM _INIT

	Sarm ACCESS ADR(gSarm);
	SimSarm ACCESS ADR(gSimSarm);

	Sarm.Status.Comms.xModuleOk := TRUE;

END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	Sarm ACCESS ADR(gSarm);
	SimSarm ACCESS ADR(gSimSarm);
	
	Sarm.Inputs.xSarmPresent := TRUE;
	Sarm.Inputs.Comms.xOnline := TRUE;
	Sarm.Inputs.Comms.xRemote := TRUE;
	Sarm.Inputs.xPowered := TRUE;
	Sarm.Inputs.xError:=SimSarm.Commands.CreateError;
	
	tonPrepare.IN:=	Sarm.Outputs.xStartTransport;
	tonPrepare.PT:= T#2s;
	tonPrepare();
	Sarm.Inputs.xRunning:=tonPrepare.Q;
	
	
	Sarm.Inputs.Comms.iVersion1 := 1;
	Sarm.Inputs.Comms.iVersion2 := 1;
	Sarm.Inputs.Comms.iVersion3 := 3;
	Sarm.Inputs.Comms.iVersion4 := 15;
	
	Sarm.Inputs.Comms.xBeltEmpty := TRUE;
	
END_PROGRAM
