PROGRAM _INIT

	Feeder ACCESS ADR(gFeeder);
	SimFeeder ACCESS ADR(gSimFeeder);

	Feeder.Status.Comms.xModuleOk := TRUE;

END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	Feeder ACCESS ADR(gFeeder);
	SimFeeder ACCESS ADR(gSimFeeder);
	
	Feeder.Inputs.xFeederPresent:=TRUE;
	Feeder.Inputs.xOnline:=TRUE;
	Feeder.Inputs.Comms.xRemote := TRUE;
	Feeder.Inputs.xError:=SimFeeder.Commands.CreateError;
	
	tonPrepare.IN:=	Feeder.Outputs.Physical.xPrepareToFeed;
	tonPrepare.PT:= T#2s;
	tonPrepare();
	Feeder.Inputs.xReadyToFeed:=tonPrepare.Q;
	
	tonFeed.IN:= Feeder.Inputs.xReadyToFeed AND Feeder.Outputs.Physical.xStartFeeding;
	tonFeed.PT:= T#1s;
	tonFeed();
	Feeder.Inputs.xFeeding:=tonFeed.Q;
	
	Feeder.Inputs.Comms.iVersion1 := 1;
	Feeder.Inputs.Comms.iVersion2 := 1;
	Feeder.Inputs.Comms.iVersion3 := 3;
	Feeder.Inputs.Comms.iVersion4 := 15;
	
END_PROGRAM
