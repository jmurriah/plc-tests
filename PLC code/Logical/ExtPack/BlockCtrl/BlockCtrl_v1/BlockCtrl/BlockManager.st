PROGRAM _INIT
	FOR iIndexHistory:=0  TO iHistoryLines DO 
		StateGenHistory[iIndexHistory]:=BLOCK_STOPPED;
		StatePosHistory[iIndexHistory]:=BLOCKP_UNDEFINED;
	END_FOR
END_PROGRAM

(*
PROGRAM _INIT
  
	//Define a transmision data to do the first calculations and be receptive to next calculations	
	MotorDriveUnit.TransmissionData:=Block.parameters.Motor.DriveUnit;
	
	//Acceleration and deceleration
	MotorDriveUnit.AccelerationDesired := 10;
	MotorDriveUnit.Calculation := CALC_ACC_PULSES;
	MotorDriveUnit();

	MotorDriveUnit.DecelerationDesired := 10;
	MotorDriveUnit.Calculation := CALC_DEC_PULSES;
	MotorDriveUnit();	

END_PROGRAM
*)

PROGRAM _CYCLIC
	
	// Block Reference
	Block ACCESS ADR(gBlock[gIndexBlock]);
	AxisBK ACCESS ADR (gAxis[Block.parameters.iMotorAxisIndex]);
	IclaBK ACCESS ADR (gIcla[Block.parameters.iIclaAxisIndex]);
	
	
	
	//If the Block doesn't exist, remove alarms and exit. Extra condition to avoid a divided by 0 error at start
	IF NOT Block.parameters.Hw.xExistBlock OR Block.parameters.Inks.iMaxBlockPrintBars = 0 THEN
		ResetAlarms;
		ResetBlockCommands;
		gIndexBlock := gIndexBlock + 1;
		RETURN;
	END_IF
	
	Inputs;
	
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
		gIndexBlock := gIndexBlock + 1;
		RETURN;
	END_IF	
	
	GetInkSystemsData;
	
	ControlState;

	BlockStatesCtrl;

	AssignDataToInksSystem;
	
	InputParamsMotors;	

	//Managment of the valves unit of the block. Reset if needed
	ValvesUnit;
	
	//Copy of variables to check changes
	rOffseCleanMtr_Copy:=rOffseCleanMtr;
	
	ResetEdgeCommands;

	//Increased exec times number to be checked outside
	Block.Status.execTimes := Block.Status.execTimes + 1;
	
	// Index added
	gIndexBlock := gIndexBlock + 1;

END_PROGRAM
