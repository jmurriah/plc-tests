
ACTION BlockStatesCtrl: 

	//Desired print position is max value because rPrintPosition comes form belt algorithm corecction based on matrix at LC_Band.st. It gives rPrintPosition calculated by matrix
	rCalcPosDesPrint:= MAX (Block.parameters.Motor.rPrintPosition + Block.parSw.rOffsetPrintMotor,
							Block.parameters.Motor.rMinSafePosition + Block.parSw.rOffsetPrintMotor);	
	
		
	//Manage Block.Status.BlockState depending on the MachineMode
	//	PRINTERGEN_ZERO:
	//	PRINTERGEN_MANUAL:
	//	PRINTERGEN_AUTO:	
	BlockStateMach;
	
	//Manage the General State of the BLOCK
	//	BLOCK_STOPPED:
	//	BLOCK_STOPPING:
	//	BLOCK_MANUAL:
	//	BLOCK_AUTO:	
	BlockStateGen;
	
	//Manage the current position of the Block
	//	BLOCKP_UNDEFINED:
	//	BLOCKP_HOMING_ICLA:
	//	BLOCKP_HOMING_BAR:
	//	BLOCKP_IN_CAP:
	//	BLOCKP_IN_PRINT:
	//	BLOCKP_GOING_TO_CAP:
	//	BLOCKP_GOING_TO_PRINT:	
	PreviousLogic;
	BlockStatePos;
	PosteriorLogic;
	
	LogOrders;
	DefineBoolPositionStatus;
	RegisterCyclesInPosState;
	
	BlockStatePrevious := Block.Status.BlockState;
	MachineStatePrevious :=  Block.commands.StateMode;

END_ACTION

ACTION StopMovements:

	StopBar;
	
END_ACTION

ACTION RegisterCyclesInPosState:

	//BlockStates to SW and times in each position
	CASE Block.Status.PositionState OF		
		BLOCKP_UNDEFINED:		Block.Status.iBlockState:= 0; iTimesStateBlockUndefined := iTimesStateBlockUndefined+1;
		BLOCKP_HOMING_BAR:		Block.Status.iBlockState:= 0; iTimesStateBlockHomingBar := iTimesStateBlockHomingBar+1;
		BLOCKP_IN_CAP:			Block.Status.iBlockState:= 1; iTimesStateBlockInCap := iTimesStateBlockInCap+1;
		BLOCKP_IN_PRINT:		Block.Status.iBlockState:= 2; iTimesStateBlockPrinting := iTimesStateBlockPrinting+1;
		BLOCKP_GOING_TO_CAP:	Block.Status.iBlockState:= 4; iTimesStateBlockGoingToCap := iTimesStateBlockGoingToCap+1;
		BLOCKP_GOING_TO_PRINT:	Block.Status.iBlockState:= 5; iTimesStateBlockGoingToPrint := iTimesStateBlockGoingToPrint+1;
	END_CASE

END_ACTION

ACTION DefineBoolPositionStatus:

	Block.Status.Position.xUndefined	:= 	Block.Status.PositionState = BLOCKP_UNDEFINED;
	Block.Status.Position.xInCap    	:=	Block.Status.PositionState = BLOCKP_IN_CAP;
	Block.Status.Position.xInPrint 		:=	Block.Status.PositionState = BLOCKP_IN_PRINT;
	Block.Status.Position.xGoingToCap	:=	Block.Status.PositionState = BLOCKP_GOING_TO_CAP;
	Block.Status.Position.xGoingToPrint :=	Block.Status.PositionState = BLOCKP_GOING_TO_PRINT;

END_ACTION

ACTION ResetKnownPositions:

	xInCap:= FALSE; 
	xInPrint:= FALSE;

END_ACTION

ACTION LogOrders:

	IF  Block.Status.PositionState = BLOCKP_GOING_TO_CAP AND BlockPositionPrevious <> BLOCKP_GOING_TO_CAP THEN
		LogToCapOrder;
	END_IF
	IF Block.Status.PositionState = BLOCKP_GOING_TO_PRINT AND BlockPositionPrevious <> BLOCKP_GOING_TO_PRINT THEN
		LogToPrintOrder;
	END_IF
	
END_ACTION
