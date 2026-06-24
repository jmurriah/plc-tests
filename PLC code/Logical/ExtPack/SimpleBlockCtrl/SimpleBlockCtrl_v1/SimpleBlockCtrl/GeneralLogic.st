
ACTION PreviousLogic:
	
	IF NOT AxisBK.Status.HomeOK THEN
		Block.Status.Motor.xBarsHomed:= FALSE;
	END_IF

	IF Block.Status.PositionState <> BLOCKP_IN_PRINT THEN
		Block.Status.Position.xReadyToPrint := FALSE;
	END_IF
	
END_ACTION



ACTION PosteriorLogic:
	
	// Update state
	Block.Status.iBlockCaseLogicControl:=nState;
	
END_ACTION