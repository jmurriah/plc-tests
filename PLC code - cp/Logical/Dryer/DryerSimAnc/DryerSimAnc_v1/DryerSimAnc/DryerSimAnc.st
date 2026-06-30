PROGRAM _CYCLIC
	(* Insert code here *)
	Dryer ACCESS ADR(gDryerAnc);
	SimDryer ACCESS ADR(gSimDryerAnc);
	
	Dryer.Inputs.xError:=SimDryer.Commands.CreateError;
	
	tonTransport.IN:= Dryer.Outputs.xRunTransport;
	tonTransport.PT:= T#1s;
	tonTransport();
	Dryer.Inputs.xTransportMoving:=tonTransport.Q;
	
	tonReady.IN:= Dryer.Inputs.xTransportMoving AND Dryer.Outputs.xPrepareToDry;
	tonReady.PT:= T#2s;
	tonReady();
	Dryer.Inputs.xReadyToDry:=tonReady.Q;
	
	tonDry.IN:= Dryer.Inputs.xReadyToDry AND Dryer.Outputs.xStartDrying;
	tonDry.PT:= T#1s;
	tonDry();
	Dryer.Inputs.xDrying:=tonDry.Q;
	
	Dryer.Inputs.xBeltEmpty:=TRUE;
	Dryer.Inputs.xCommsOK:=TRUE;
END_PROGRAM