
ACTION ResetHomingBar: 

	xMotorHomeOrder := FALSE;
	Block.commands.xBarHomeOrder:=FALSE;
	iTimesStopMovWhileHoming := iTimesStopMovWhileHoming + 1;

	StopBar;
	
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

ACTION ResetEdgeCommands:

	Block.commands.xToCapLab := FALSE;
	Block.commands.xToPrintLab := FALSE;
	
END_ACTION
