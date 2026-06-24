
PROGRAM _CYCLIC
	
	// Block Reference
	Block ACCESS ADR(gSimpleBlock[gIndexSimpleBlock]);
	AxisBK ACCESS ADR (gAxis[Block.parameters.iMotorAxisIndex]);
	
	
	//If the Block doesn't exist, remove alarms and exit. Extra condition to avoid a divided by 0 error at start
	IF NOT Block.parameters.Hw.xExistBlock THEN
		ResetAlarms;
		gIndexSimpleBlock := gIndexSimpleBlock + 1;
		RETURN;
	END_IF
	
	//Limit the value of parameters configured
	BlockParameters;
	
	IF Block.parSw.xEnableToMovements THEN 
		Block.Status.xEnabledMovements:= TRUE;
	ELSIF NOT Block.parSw.xEnableToMovements AND (xInCap OR NOT Block.Status.Motor.xBarsHomed) THEN
		Block.Status.xEnabledMovements:= FALSE;
	END_IF	

	IF Block.commands.xReset THEN
		ResetAlarms;
	END_IF
	
	BlockAlarms;
	AlarmSound;
			
	IF (NOT Block.Status.xEnabledMovements) THEN
		gIndexSimpleBlock := gIndexSimpleBlock + 1;
		RETURN;
	END_IF	
	
	ControlState;

	BlockStatesCtrl;

	InputParamsMotors;	

	ResetEdgeCommands;

	//Increased exec times number to be checked outside
	Block.Status.execTimes := Block.Status.execTimes + 1;
	
	// Index added
	gIndexSimpleBlock := gIndexSimpleBlock + 1;
	

END_PROGRAM
