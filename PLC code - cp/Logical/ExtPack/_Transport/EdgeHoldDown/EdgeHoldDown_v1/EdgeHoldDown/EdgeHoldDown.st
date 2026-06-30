PROGRAM _INIT
	FOR iIndexHistory:=0 TO iHistoryLines DO 
		StateHistory[iIndexHistory]:=EHD_STOPPED;
	END_FOR
END_PROGRAM
	
PROGRAM _CYCLIC

	//////////////////////////////
	////// ASSIGN LOCAL VARS //////
	//////////////////////////////
	
	//Main data assignation
	data ACCESS ADR (gEdgeHoldDown);
	AdjustmentSystem ACCESS ADR (gPairedMotors);

	data.status.xInstalled := data.parameters.xInstalled;
	
	IF EDGEPOS(data.parSw.xEnable) THEN
		data.status.xEnabled:=TRUE;
		
	//EHD may be disabled whether is positioned over the belt guide (Resting position)
	ELSIF ((NOT data.parSw.xEnable AND data.commands.Mode.xAuto) OR EDGEPOS(NOT data.parSw.xEnable)) AND data.status.xInRestingPosition THEN
		data.status.xEnabled := FALSE;
	END_IF
	
	Configuration;
	
	data.parameters.iAdjustmentSystemsNumber := LIMIT(1, data.parameters.iAdjustmentSystemsNumber, MAX_EHD_ADJUST_SYSTEMS);
	data.parameters.xEnableMovements := ((AdjustmentSystem[1].Motor[1].rPositionMotor + iSafetyOffset) < data.parameters.rBlockPosition); //Review how to set this condition when more than one block is installed 
	
	IF NOT data.status.xInstalled OR NOT data.status.xEnabled THEN
		data.Alarms:= stAlarmsReseted;
		data.AlSummary := stEhdAlarmSummaryReseted;
		data.AlSummary.xAlarmSound:=FALSE;
		
		data.status.iSystemState:= EHD_STOPPED;
		data.status.xReferenced:=FALSE;
		ResetSwOrders;
		RETURN;
	END_IF
		
	
	//Reset alarms
	IF data.commands.xErrorRst THEN data.Alarms:= stAlarmsReseted; END_IF
	
	//States manager
	MachineState;
	
	
	//Alarms
	AlarmsSummary;

	
	///////////////////////
	//Alarm Sound
	AlarmSounds;
	
	//Resetting commands coming from sw
	data.commandsSw := ResetCommandsSw;
	
END_PROGRAM
