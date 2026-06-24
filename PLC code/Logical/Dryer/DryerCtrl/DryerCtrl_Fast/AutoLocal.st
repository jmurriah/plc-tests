
ACTION AutoLocal: 

	//This action just for Auto Local
	IF NOT gDryer.St.Mode.xAuto OR NOT gDryer.St.AutoLocation.xLocal THEN
		RETURN;
	END_IF

	IF EDGEPOS(gDryer.In.Sw.xStart_GI) THEN
		DryerSignalsAuto.Commands.xRunTransport := TRUE;
		DryerSignalsAuto.Commands.xPrepareToDry := TRUE;
		DryerSignalsAuto.Commands.xStartDrying := TRUE;
		xStartedAutoMan := TRUE;
	END_IF
	
	IF EDGEPOS(gDryer.In.Sw.xStop_GI) OR EDGEPOS(gDryer.In.Buttons.xStop) THEN
		DryerSignalsAuto.Commands.xPrepareToDry := FALSE;
		DryerSignalsAuto.Commands.xStartDrying := FALSE;
		xStartedAutoMan := FALSE;
	END_IF
	
	IF EDGEPOS(gDryer.In.Sw.xStop_GI) AND DryerStatus = DRYERMACH_MOVING THEN
		DryerSignalsAuto.Commands.xRunTransport := FALSE;
	END_IF
	
	
	tonMovingBeltAfterStop.IN := NOT xStartedAutoMan;
	tonMovingBeltAfterStop.PT := T#30s;
	tonMovingBeltAfterStop();
	
	IF tonMovingBeltAfterStop.Q AND gThicknessCtrl.status.Belt.xBeltEmpty THEN
		DryerSignalsAuto.Commands.xRunTransport := FALSE;
		gDryer.In.Sw.xStop_GI := TRUE;
	END_IF
	
END_ACTION
