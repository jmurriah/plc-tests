
ACTION BlockStatesCtrl: 

	//Desired print position is max value because rPrintPosition comes form belt algorithm corecction based on matrix at LC_Band.st. It gives rPrintPosition calculated by matrix
	IF Block.commands.StateMode = PRINTERGEN_AUTO THEN
		rCalcPosDesPrint:= MAX (Block.parameters.Motor.rPrintPosition + Block.parSw.rOffsetPrintMotor,
							Block.parameters.Motor.rMinSafePosition + Block.parSw.rOffsetPrintMotor);	
	ELSIF (Block.commands.StateMode = PRINTERGEN_MANUAL) AND Block.commands.Manual.xToPrintPosition THEN
		rCalcPosDesPrint:= Block.parameters.rManPrintingPos;
	END_IF
		
	//If PreprintingPosition is forced, recalculate the desired position
	IF Block.commands.xForcePreprintingPos THEN
		rCalcPosDesPrint:= MAX (rCalcPosDesPrint, Block.parameters.rPrePrintingPos);
	END_IF
		
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
	//	BLOCKP_IN_CLEAN:
	//	BLOCKP_CLEANING:
	//	BLOCKP_GOING_TO_CAP:
	//	BLOCKP_GOING_TO_PRINT:	
	//	BLOCKP_GOING_TO_CLEAN:
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

	Block.Out.xTrayOut:=FALSE;
	Block.Out.xTrayIn:=FALSE;
	Block.Out.xVenturi:=FALSE;
	Block.Out.xCleaningWaterPump:=FALSE;
	Block.Out.xCappingWaterPump:=FALSE;
	Block.Out.xWastedInkTankPump:=FALSE;
	
	StopBar;
	StopIcla;
	
END_ACTION

ACTION RegisterCyclesInPosState:

	//BlockStates to SW and times in each position
	CASE Block.Status.PositionState OF		
		BLOCKP_UNDEFINED:		Block.Status.iBlockState:= 0; iTimesStateBlockUndefined := iTimesStateBlockUndefined+1;
		BLOCKP_HOMING_BAR:		Block.Status.iBlockState:= 0; iTimesStateBlockHomingBar := iTimesStateBlockHomingBar+1;
		BLOCKP_HOMING_ICLA:		Block.Status.iBlockState:= 0; iTimesStateBlockHomingIcla := iTimesStateBlockHomingIcla+1;
		BLOCKP_IN_CAP:			Block.Status.iBlockState:= 1; iTimesStateBlockInCap := iTimesStateBlockInCap+1;
		BLOCKP_IN_PRINT:		Block.Status.iBlockState:= 2; iTimesStateBlockPrinting := iTimesStateBlockPrinting+1;
		BLOCKP_CLEANING:		Block.Status.iBlockState:= 3; iTimesStateBlockCleaning := iTimesStateBlockCleaning+1;
		BLOCKP_GOING_TO_CAP:	Block.Status.iBlockState:= 4; iTimesStateBlockGoingToCap := iTimesStateBlockGoingToCap+1;
		BLOCKP_GOING_TO_PRINT:	Block.Status.iBlockState:= 5; iTimesStateBlockGoingToPrint := iTimesStateBlockGoingToPrint+1;
	END_CASE

END_ACTION

ACTION DefineBoolPositionStatus:

	Block.Status.Position.xUndefined	:= 	Block.Status.PositionState = BLOCKP_UNDEFINED;
	Block.Status.Position.xInCap    	:=	Block.Status.PositionState = BLOCKP_IN_CAP;
	Block.Status.Position.xInPrint 		:=	Block.Status.PositionState = BLOCKP_IN_PRINT;
	Block.Status.Position.xInClean 		:=	Block.Status.PositionState = BLOCKP_IN_CLEAN;
	Block.Status.Position.xCleaning 	:= 	Block.Status.PositionState = BLOCKP_CLEANING;
	Block.Status.Position.xGoingToCap	:=	Block.Status.PositionState = BLOCKP_GOING_TO_CAP;
	Block.Status.Position.xGoingToPrint :=	Block.Status.PositionState = BLOCKP_GOING_TO_PRINT;
	Block.Status.Position.xGoingToClean :=	Block.Status.PositionState = BLOCKP_GOING_TO_CLEAN;	

END_ACTION

ACTION ResetKnownPositions:

	xInCap:= FALSE; 
	xInPrint:= FALSE;
	xInClean:= FALSE;

END_ACTION

ACTION LogOrders:

	IF  Block.Status.PositionState = BLOCKP_GOING_TO_CAP AND BlockPositionPrevious <> BLOCKP_GOING_TO_CAP THEN
		LogToCapOrder;
	END_IF
	IF Block.Status.PositionState = BLOCKP_GOING_TO_PRINT AND BlockPositionPrevious <> BLOCKP_GOING_TO_PRINT THEN
		LogToPrintOrder;
	END_IF
	IF Block.Status.PositionState = BLOCKP_CLEANING AND BlockPositionPrevious <> BLOCKP_CLEANING THEN
		LogToCleanOrder;
	END_IF
	
END_ACTION
