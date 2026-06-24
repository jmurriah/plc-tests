
ACTION CleanBeltUv: 
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// General conditions to clean belt	when machine is in AUTOMATIC OR MANUAL MODES
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	//Delay falling the tray to be sure no water is poured inside the machine
	tofCleaningTrayBelt.IN:=gBelt.states.xRuningBelt;
	tofCleaningTrayBelt.PT:=T#200MS;
	tofCleaningTrayBelt();
	
	IF gBelt.states.xRuningBelt AND gMachine.parSw.CleanBelt.xCleanBeltByTime AND gMachine.St.Position.xInPrint THEN
		IF EDGEPOS(gPLC.xBlk_500ms) THEN
			tiSumTimeToCleanBelt:=tiSumTimeToCleanBelt + INT_TO_TIME(1000); //Time in seconds
		END_IF
	END_IF
	
	xCleanBeltOrder := gMachine.AutoCmd.xCleanBelt;
	xSwapBrushesMovementDirection := gThicknessCtrl.status.Belt.iBeltTurns>=gMachine.parSw.CleanBelt.iBeltTurns;
	xStopBrushes := (2*gMachine.parSw.CleanBelt.iBeltTurns)=gThicknessCtrl.status.Belt.iBeltTurns;
	
	xReadyToCleanBelt := NOT gBelt.states.xRuningBelt AND ((gMachine.St.AutoMode.xStop AND NOT gMachine.Pt.xControlledByLine) OR
															gLine.StatusSummary.xIdle);
	
	//Cleaning process states
	CASE enCleanBeltUvStep OF
		
		//Out of automatic mode
		CLN_BELT_NOT_READY:
			gMachine.commands.xRunBelt := FALSE;
			xCleanBeltMoveFwd := FALSE;
			xCleanBeltMoveBwd := FALSE;
			IF xReadyToCleanBelt AND NOT gMachine.In.CleanBelt.xOpenGuide THEN
				enCleanBeltUvStep := CLN_BELT_READY_TO_CLEAN;
			END_IF
			
		//Machine in auto and stopped
		CLN_BELT_READY_TO_CLEAN:
			IF xCleanBeltOrder THEN
				enCleanBeltUvStep := CLN_BELT_CLEANING_START;
			END_IF
			
		//Run belt
		CLN_BELT_CLEANING_START:
			gMachine.commands.xRunBelt := TRUE;
			IF gBelt.states.xRuningBelt THEN
				enCleanBeltUvStep := CLN_BELT_CLEAN_CLOKWISE;
			END_IF
		
		//Run brushes clockwise
		CLN_BELT_CLEAN_CLOKWISE:
			xCleanBeltMoveFwd := TRUE;
			IF xSwapBrushesMovementDirection THEN
				xCleanBeltMoveFwd := FALSE;
				enCleanBeltUvStep := CLN_BELT_CLEAN_COUNTERCLOCKWISE;
			END_IF
		
		//Run brushes counterclockwise
		CLN_BELT_CLEAN_COUNTERCLOCKWISE:
			xCleanBeltMoveBwd := TRUE;
			IF xStopBrushes THEN
				xCleanBeltMoveBwd := FALSE;
				enCleanBeltUvStep := CLN_BELT_CLEANED;
			END_IF
		
		//Stop belt
		CLN_BELT_CLEANED:
			tiSumTimeToCleanBelt:=0;
			gMachine.commands.xRunBelt := FALSE;
			IF NOT gBelt.states.xRuningBelt THEN
				enCleanBeltUvStep := CLN_BELT_NOT_READY;
			END_IF
		
		//Process error
		CLN_BELT_ERROR:
			gMachine.commands.xRunBelt := FALSE;
			xCleanBeltMoveFwd := FALSE;
			xCleanBeltMoveBwd := FALSE;
			IF iReasonStopCleanBeltProcess=0 THEN
				enCleanBeltUvStep := CLN_BELT_NOT_READY;
			END_IF
	END_CASE
	
	//To
	iReasonStopCleanBeltProcess.0 := gMachine.AlSummary.xAlarmStop;
	iReasonStopCleanBeltProcess.1 := gMachine.AlSummary.xAlarmCritical;
	iReasonStopCleanBeltProcess.2 := NOT gMachine.St.Mode.xAuto;
	iReasonStopCleanBeltProcess.3 := gMachine.In.Buttons.xStop;
	IF iReasonStopCleanBeltProcess>0 THEN
		enCleanBeltUvStep := CLN_BELT_ERROR;
		
//	ELSIF NOT xReadyToCleanBelt THEN
//		enCleanBeltUvStep := CLN_BELT_NOT_READY;
	END_IF
	
	
	//Store the history of the status to easy the debug
	IF enCleanBeltUvStep<>StateHistory[0] THEN
		FOR iIndexHistory:=iHistoryLines TO 1 BY -1 DO 
			StateHistory[iIndexHistory]:=StateHistory[iIndexHistory-1];
		END_FOR;
		StateHistory[0]:=enCleanBeltUvStep;
	END_IF
	
	
	tiTimeToCleanBelt:= LIMIT(0, (gMachine.parSw.CleanBelt.tiCleaningBeltByTime-tiSumTimeToCleanBelt), gMachine.parSw.CleanBelt.tiCleaningBeltByTime); //Time in ms
	gMachine.St.CleaningBelt.iTimeToCleanBelt := TIME_TO_INT(tiTimeToCleanBelt/(60*1000)); //Time in minutes
	gMachine.St.CleaningBelt.enState := enCleanBeltUvStep;
	gMachine.St.CleaningBelt.xCleaningProcessOnGoing := enCleanBeltUvStep=CLN_BELT_CLEANING_START OR
														enCleanBeltUvStep=CLN_BELT_CLEAN_CLOKWISE OR
														enCleanBeltUvStep=CLN_BELT_CLEAN_COUNTERCLOCKWISE OR
														enCleanBeltUvStep=CLN_BELT_CLEANED;
	
	//This variable will be read by Sw to show a pop up asking for a belt cleaning
	gMachine.St.CleaningBelt.xCleanRequired := (tiSumTimeToCleanBelt>=gMachine.parSw.CleanBelt.tiCleaningBeltByTime) AND
												enCleanBeltUvStep=CLN_BELT_READY_TO_CLEAN AND
												xReadyToCleanBelt AND
												gMachine.parSw.CleanBelt.xCleanBeltByTime;
	
	//If the belt is not running, it is not possible to clean it
	IF NOT gBelt.states.xRuningBelt THEN
		gMachine.commands.CleanBelt.xCleanBeltResetRelay := gMachine.AutoCmd.xReset AND gMachine.In.CleanBelt.xError;
		gMachine.commands.CleanBelt := ResetCleanBeltCommands;
		xCleanBeltOrder := FALSE;
		RETURN;
	END_IF	
				
	
	//////////////////////
	// OUTPUT management
	//////////////////////	
	//Clean belt
	xEnableCleanBeltMotorMovement := 	NOT gMachine.In.CleanBelt.xOpenGuide AND
										gMachine.In.CleanBelt.xHighPosition AND
										NOT tp_ToSwapCleanBeltMtrDirection.Q;
	
	//Pneumatic
	gMachine.commands.CleanBelt.xPistonFlojet := 	tofCleaningTrayBelt.Q AND
													NOT gMachine.In.CleanBelt.xOpenGuide AND
													gMachine.St.CleaningBelt.xCleaningProcessOnGoing;
		
	//Motor
	tp_ToSwapCleanBeltMtrDirection.IN:= EDGEPOS(xCleanBeltMoveFwd) OR EDGEPOS(xCleanBeltMoveBwd);
	tp_ToSwapCleanBeltMtrDirection.PT := gMachine.St.CleaningBelt.TimeDelaySwapDirBeltCleanMotor := t#2s;
	tp_ToSwapCleanBeltMtrDirection();
		
	gMachine.commands.CleanBelt.xCleanBeltMoveFwd := 	xCleanBeltMoveFwd AND
														xEnableCleanBeltMotorMovement;
	
	gMachine.commands.CleanBelt.xCleanBeltMoveBwd := 	xCleanBeltMoveBwd AND
														xEnableCleanBeltMotorMovement;
		
END_ACTION