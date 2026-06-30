PROGRAM _INIT

	Stacker ACCESS ADR(gStacker);
	SimStacker ACCESS ADR(gSimStacker);

	Stacker.Status.Comms.xModuleOk := TRUE;
	Stacker.Inputs.Comms.xBeltsEmpty:=TRUE;

END_PROGRAM
	
PROGRAM _CYCLIC
	(* Insert code here *)
	Stacker ACCESS ADR(gStacker);
	SimStacker ACCESS ADR(gSimStacker);
	
	Stacker.Inputs.xStackerPresent:=TRUE;
	Stacker.Inputs.Comms.xRemote := TRUE;
	
	Stacker.Inputs.xError:=SimStacker.Commands.CreateError;
	
	tonReady.IN:= Stacker.Outputs.xPrepareToStack;
	tonReady.PT:= T#2s;
	tonReady();
	Stacker.Inputs.xReadyToStack:=tonReady.Q;
	
	tonRun.IN:= Stacker.Inputs.xReadyToStack AND Stacker.Outputs.xRun;
	tonRun.PT:= T#1s;
	tonRun();
	Stacker.Inputs.xRunning:=tonRun.Q AND NOT SimStacker.Commands.StopBelts;
		
END_PROGRAM