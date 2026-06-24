
ACTION PreviousLogic:

	//With the Sensor, always remove the alarm
	IF Block.In.xIclaSensor THEN
		Block.Al.xNoActionDangerCollision:=FALSE;
	END_IF	
	
		
	tonWaitingSensor.IN := nState=212 OR nState=215 OR nState=235 OR nState=269;
	tonWaitingSensor.PT := T#3s;
	tonWaitingSensor();
	
	IF NOT AxisBK.Status.HomeOK THEN
		Block.Status.Motor.xBarsHomed:= FALSE;
	END_IF

	// Safety Tray Out
	IF EDGEPOS(Block.In.xTrayOut AND Block.Out.xTrayOut) THEN
		Block.Out.xTrayOut:= FALSE;
	END_IF
	// Safety Tray In	
	IF EDGEPOS(Block.In.xTrayIn AND Block.Out.xTrayIn) THEN
		Block.Out.xTrayIn:= FALSE;
	END_IF
	
	//To wait some time to empty the water tray for capping
	TON_WaitToMoveTrayOut.IN := NOT Block.Out.xCappingWaterPump AND (nState=234);
	TON_WaitToMoveTrayOut.PT := T#5S;
	TON_WaitToMoveTrayOut();

	// Capping water pump
	IF (Block.Status.PositionState <> BLOCKP_IN_CAP) THEN
		Ton_CappingPump.IN := FALSE;
	ELSIF (Block.In.xTrayIn AND Block.parameters.xCappingProcess) THEN
		Ton_CappingPump.IN := TRUE;
	END_IF
	Ton_CappingPump.PT := T#150s;
	Ton_CappingPump();
	Block.Out.xCappingWaterPump := Ton_CappingPump.IN AND NOT Ton_CappingPump.Q;
	
	iReasonRunWastedInkPump.0 := EDGEPOS (Block.In.xTrayIn AND Block.parameters.xWastedInkTankProcess);
	iReasonRunWastedInkPump.1 := EDGEPOS (Block.Status.xCleaningDone AND Block.parameters.xWastedInkTankProcess);
	
	IF iReasonRunWastedInkPump > 0 THEN
		xStartWastedInkPump := TRUE;
	END_IF
	
	// Wasted ink tank
	Ton_WastedInkTankPump.IN := xStartWastedInkPump;
	Ton_WastedInkTankPump.PT := T#200s;
	Ton_WastedInkTankPump();
	Block.Out.xWastedInkTankPump := xStartWastedInkPump := Ton_WastedInkTankPump.IN AND NOT Ton_WastedInkTankPump.Q;
	
	IF Block.Status.PositionState <> BLOCKP_IN_PRINT THEN
		Block.Status.Position.xReadyToPrint := FALSE;
	END_IF
	
END_ACTION



ACTION PosteriorLogic:

	//Remove the other order when receiving a pulse. https://jira.efi.com/browse/CRETALEGO-1375
	IF EDGEPOS(Block.Out.xTrayOut) THEN Block.Out.xTrayIn:= FALSE; END_IF
	IF EDGEPOS(Block.Out.xTrayIn) THEN Block.Out.xTrayOut:= FALSE; END_IF
	
	// Update state
	Block.Status.iBlockCaseLogicControl:=nState;
	Block.Status.Icla.iIclaState:=IclaBK.Status.iDriveStatus;
	
	//NOZOMITWO-1116: Block tray movements when printer key maintenance is activated
	IF Block.parameters.xPrinterKeyMaintenanceActivated THEN
		Block.commands.Manual.xManTrayIn:= FALSE; //CUBE-963. Remove order if the movement is been blocked
		Block.commands.Manual.xManTrayOut:= FALSE; //CUBE-963. Remove order if the movement is been blocked
		Block.Out.xTrayIn:= FALSE;
		Block.Out.xTrayOut:= FALSE;
	END_IF
	
END_ACTION