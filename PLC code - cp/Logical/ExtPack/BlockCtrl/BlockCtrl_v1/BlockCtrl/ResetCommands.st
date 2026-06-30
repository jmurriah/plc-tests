ACTION ResetBlockCommands:
	Block.commands := stBlockCommandsReseted;
END_ACTION
	
ACTION ResetHomingBar: 

	xMotorHomeOrder := FALSE;
	Block.commands.xBarHomeOrder:=FALSE;
	iTimesStopMovWhileHoming := iTimesStopMovWhileHoming + 1;

	StopBar;
	
END_ACTION

ACTION ResetHomingIcla: 

	//Delete motor orders
	Block.commands.xIclaHomeOrder:=FALSE;
	Block.commands.xIclaHomeOrderInterrupt:=FALSE;
	IclaBK.Command.Home := FALSE;

	StopIcla;
	
END_ACTION

ACTION ResetCleanCycle: 

	Block.commands.Manual.xManIclaBack:=FALSE;
	Block.commands.xDripControl:=FALSE; 
	Block.commands.xInksOrderCleaning:= FALSE;
	xCloseReliefValve := FALSE;

	Block.Status.xCleaningDone:=TRUE; //Esto es para que deje de estar en limpieza
	IF BlockPositionPrevious = BLOCKP_CLEANING THEN
		xCleanInterrupt:=TRUE;
	END_IF
	
	//Stop motors movement and signals
	StopMovements;
	
END_ACTION

ACTION StopBar: 

	AxisBK.Command.Jog.ContinuousNeg:= FALSE;
	AxisBK.Command.Jog.ContinuousPos:= FALSE;
	IF AxisBK.Status.PLCopenState.ContinuousMotion OR AxisBK.Status.PLCopenState.DiscreteMotion THEN
		AxisBK.Command.Move.Halt:=TRUE;	
	ELSIF AxisBK.Status.PLCopenState.Homing THEN
		AxisBK.Command.QuickStop:=TRUE;
	ELSIF NOT AxisBK.Status.PLCopenState.Homing THEN
		AxisBK.Command.QuickStop:=FALSE;
	END_IF
	
END_ACTION

ACTION StopIcla:

	xIclaAbsMovOrder:= FALSE;
	IclaBK.Command.JogFastSpeed:= FALSE;
	IclaBK.Command.JogForward := FALSE;
	IclaBK.Command.JogBackward:= FALSE;
	IF IclaBK.Status.IclaStatus = AXISILE_MOVE_ABSOLUTE OR IclaBK.Status.IclaStatus = AXISILE_JOG THEN
		IclaBK.Command.Stop := TRUE;
	END_IF
	
END_ACTION

ACTION ResetEdgeCommands:

	IF Block.Status.Position.xGoingToCap OR Block.Status.Position.xInCap THEN
		Block.commands.xToCap := FALSE;
	END_IF
	IF Block.Status.Position.xGoingToPrint OR Block.Status.Position.xInPrint THEN
		Block.commands.xToPrint := FALSE;
	END_IF
	Block.commands.xToCapLab := FALSE;
	Block.commands.xToPrintLab := FALSE;
	Block.commands.xToCleanPosition := FALSE;
	Block.commands.Manual.xToPrintPosition := FALSE;
	
END_ACTION
