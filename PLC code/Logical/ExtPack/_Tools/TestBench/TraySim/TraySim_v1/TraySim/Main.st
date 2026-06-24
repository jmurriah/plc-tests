
PROGRAM _CYCLIC
	(* Insert code here *)
	 
	trayData  ACCESS ADR(gTraySim[iTraySimIndex]);

	//Remove both orders if two different orders at the same time
	IF trayData.Commands.ToIn AND trayData.Commands.ToOut THEN 
		trayData.Commands.ToIn := FALSE;
		trayData.Commands.ToOut := FALSE;
	END_IF
	
	IF EDGEPOS(trayData.Commands.ToIn) THEN xReboundedIn := FALSE; END_IF
	ton_ToIn.IN:= trayData.Commands.ToIn AND NOT xReboundedIn;
	ton_ToIn.PT := t#1s;
	ton_ToIn();
	
	ton_ReboundIn.IN := trayData.State.InPosition AND trayData.Commands.ReboundToIn;
	ton_ReboundIn.PT := t#500ms;
	ton_ReboundIn();
	
	IF EDGEPOS(trayData.Commands.ToOut) THEN xReboundedOut := FALSE; END_IF
	ton_ToOut.IN:= trayData.Commands.ToOut AND NOT xReboundedOut;
	ton_ToOut.PT := t#1s;
	ton_ToOut();

	ton_ReboundOut.IN := trayData.State.OutPosition AND trayData.Commands.ReboundToOut;
	ton_ReboundOut.PT := t#500ms;
	ton_ReboundOut();

	//In sensor
	IF NOT trayData.Commands.UnplugInSensor THEN
		IF ton_ToIn.Q THEN
			trayData.State.InPosition := TRUE;
		ELSIF trayData.Commands.ToOut THEN
			trayData.State.InPosition := FALSE;
		ELSIF ton_ReboundIn.Q THEN
			xReboundedIn := TRUE;
			trayData.State.InPosition := FALSE;
		END_IF
	ELSE
		trayData.State.InPosition := FALSE;
	END_IF
	
	IF trayData.Commands.ResetIn THEN
		trayData.Commands.ResetIn := FALSE;
		trayData.State.InPosition := FALSE;
	END_IF
	
	//Out sensor
	IF NOT trayData.Commands.UnplugOutSensor THEN
		IF ton_ToOut.Q THEN
			trayData.State.OutPosition := TRUE;
		ELSIF trayData.Commands.ToIn THEN
			trayData.State.OutPosition := FALSE;
		ELSIF ton_ReboundOut.Q THEN
			xReboundedOut := TRUE;
			trayData.State.OutPosition := FALSE;
		END_IF
	ELSE
		trayData.State.OutPosition := FALSE;
	END_IF
	
	IF trayData.Commands.ResetOut THEN
		trayData.Commands.ResetOut := FALSE;
		trayData.State.OutPosition := FALSE;
	END_IF
	
	iTraySimIndex := iTraySimIndex + 1;

END_PROGRAM


