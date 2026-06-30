PROGRAM _CYCLIC
	(* Insert code here *)
	Line ACCESS ADR(gLine);
	SafetyController ACCESS ADR (gSafetyController);
	Feeder ACCESS ADR(gFeeder);	
	Primer ACCESS ADR(gPrimer);
	Sarm ACCESS ADR(gSarm);
	OverVarnish ACCESS ADR(gOverVarnish);
	Dryer ACCESS ADR(gDryerAnc);
	DryerData ACCESS ADR(gDryerRemoteData);
	Stacker ACCESS ADR(gStacker);
	Machine ACCESS ADR(gMachine);
	Belt ACCESS ADR(gBelt);
	ThickCtrl ACCESS ADR(gThicknessCtrl);
	TransVacuum ACCESS ADR(gTransVacuum);
	CuringLed ACCESS ADR(gCuringLed);
	EdgeHoldDown ACCESS ADR(gEdgeHoldDown);
	BeltClean ACCESS ADR(gBeltClean);
	
	
	//Just enter in line if gMachine controlled by line and configured the quantity of external devices
	IF NOT gMachine.Pt.xControlledByLine OR Line.Parameters.iNumExternalDevices = 0 THEN
		RETURN;
	END_IF
	
	Configuration;
	
	LineAlarms;
	
	LineAlarmsSummary;
	
	xStatusChanged := LineStatusPrevious <> Line.Status;
	IF xStatusChanged THEN xLineReady:=FALSE; iLineStatus:=0; END_IF
	
	xSubStatusChanged := iLineSubStatusPrevious<>iLineStatus;
	IF xSubStatusChanged THEN LogLineSubStatus;	END_IF
	
	LineStatusPrevious := Line.Status;
	iLineSubStatusPrevious := iLineStatus;
		
	//Inputs
	LineInputs;
	
	//External requests to line from printer (machine) or ancillaries
	LineOrders; 
	
	CASE Line.Status OF
		
		LINE_NOT_POWERED:
			xLinePoweredON:=FALSE;
			//Waiting the machine to be configured
			IF Line.Parameters.iNumExternalDevices > 0 AND NOT Line.OrdersSw.Shutdown THEN
				Line.Status:=LINE_NOT_INITIALIZED;
			END_IF
			
		
		LINE_NOT_INITIALIZED:
			//xLineReady:=FALSE;
			PowerOffLineDevices;
			IF xLinePowered AND xLinePoweredOFF THEN Line.Status:=LINE_INITIALIZING; END_IF
			
		
		LINE_POWERING_OFF:
			PowerOffLineDevices;
			IF xLinePoweredOFF THEN Line.Status:=LINE_NOT_POWERED; END_IF
			
		LINE_INITIALIZING:
			PowerUpLineDevices;
			IF xLineReady AND xLinePoweredON THEN xLineStopped:=TRUE; Line.Status:=LINE_STOPPED; END_IF
			
			
		LINE_STOPPED:
			IF gMachine.St.Mode.xAuto THEN
				IF xLineToClean THEN
					xCleanToBeExecuted := TRUE;
					Line.Status:=LINE_PREPARING_CLEANPH;
				ELSIF xLineToCleanBelt THEN
					xCleanBeltToBeExecuted := TRUE;
					Line.Status:=LINE_PREPARING_CLEANBELT;
				ELSIF xNoAlarmsActive THEN
					Line.Status:=LINE_IDLE;
				END_IF
			END_IF
				
			
		LINE_IDLE:
			xCleanToBeExecuted:=FALSE;
			xCleanBeltToBeExecuted:=FALSE;
			xPreviousIdle:=TRUE;
			
			IF Line.OrdersSw.Shutdown THEN
				Line.Status:=LINE_POWERING_OFF;
			END_IF
			
			IF xLineToPrint AND xNoAlarmsActive THEN
				Line.Status:=LINE_PREPARING_PRINT;
			ELSIF xLineToClean THEN
				xCleanToBeExecuted := TRUE;
				Line.Status:=LINE_PREPARING_CLEANPH;
			ELSIF xLineToCleanBelt AND ThickCtrl.status.Belt.xBeltEmpty THEN
				xCleanBeltToBeExecuted := TRUE;
				Line.Status:=LINE_PREPARING_CLEANBELT;
			ELSIF xLineToEmptyBelt THEN
				Line.Status:=LINE_PREPARING_EMPTYBELT;				
			END_IF
		
			
		LINE_PREPARING_EMPTYBELT:
			xLineStopped:=FALSE;
			PreparingEmptyBelt;
			IF xLineReady THEN Line.Status:=LINE_STARTING_EMPTYBELT; END_IF
		
			
		LINE_STARTING_EMPTYBELT:
			StartingEmptyBelt;
			IF xLineReady THEN Line.Status:=LINE_BELT_EMPTYING; END_IF
			
			
		LINE_BELT_EMPTYING:
			//To finish this process automatically when line is full emptied
			EmptyingBelt;
			IF xLineReady THEN Line.Status:=LINE_CONTROLLED_STOP; END_IF
			
			
		LINE_PREPARING_PRINT:
			xLineStopped:=FALSE;
			xPreviousPrinting:=FALSE;
			PreparingPrint;
			IF xLineReady THEN Line.Status:=LINE_STARTING_PRINTING; END_IF
			
			
		LINE_STARTING_PRINTING:
			StartingPrinting;
			IF xLineReady THEN Line.Status:=LINE_PRINTING; END_IF
			
			
		LINE_PRINTING:
			xPreviousIdle:=FALSE;
			IF xLineToPause OR xLineToClean OR xLineToCleanBelt THEN
				IF xLineToClean THEN
					xPreviousPrinting:=TRUE;
					xCleanToBeExecuted := TRUE;
				ELSIF xLineToCleanBelt THEN
					xPreviousPrinting:=TRUE;
					xCleanBeltToBeExecuted := TRUE;
				END_IF
				Line.Status:=LINE_PAUSING;
			END_IF
		
			
		LINE_PAUSING:
			xPreviousPausing:=FALSE;
			Pausing;
			IF xLineToClean THEN
				xCleanToBeExecuted := TRUE;
			END_IF
			
			IF xLineToPrint THEN
				Line.Status:=LINE_PREPARING_PRINT;
			ELSIF xLineReady THEN 
				Line.Status:=LINE_PAUSED;
			END_IF
			
			
		LINE_PAUSED:
			IF xLineToPrint THEN
				Line.Status:=LINE_PREPARING_PRINT;
			ELSIF xLineToClean THEN
				xCleanToBeExecuted := TRUE;
				xPreviousPausing:=TRUE;
				Line.Status:=LINE_PREPARING_CLEANPH;
			ELSIF xLineToCleanBelt THEN
				xCleanBeltToBeExecuted := TRUE;
				xPreviousPausing:=TRUE;
				Line.Status:=LINE_PREPARING_CLEANBELT;
			END_IF
		
			
		LINE_PREPARING_CLEANPH:
			PreparingCleaningPH;
			IF xLineReady THEN Line.Status:=LINE_STARTING_CLEANINGPH; END_IF
			
		
		LINE_PREPARING_CLEANBELT:
			PreparingCleaningBelt;
			IF xLineReady THEN Line.Status:=LINE_STARTING_CLEANINGBELT; END_IF


		LINE_STARTING_CLEANINGPH:
			xCleanToBeExecuted := FALSE;
			StartingCleaningPH;
			IF xLineReady THEN Line.Status:=LINE_CLEANINGPH; END_IF
			
			
		LINE_STARTING_CLEANINGBELT:
			xCleanBeltToBeExecuted := FALSE;
			StartingCleaningBelt;
			IF xLineReady THEN Line.Status:=LINE_CLEANINGBELT; END_IF
		
			
		LINE_CLEANINGPH:
			IF NOT gMachine.St.Position.xCleaning AND NOT BeltClean.Status.xCleaning THEN
				Line.Status:=LINE_CLEANED;
			END_IF
			
		
		LINE_CLEANINGBELT:
			CleaningBelt;
			IF xLineReady THEN
				Line.Status:=LINE_CLEANED;
			END_IF
			
			
		LINE_CLEANED:
			IF xPreviousPrinting THEN
				Line.Status:=LINE_PREPARING_PRINT;
			ELSIF xPreviousIdle THEN
				Line.Status:=LINE_IDLE;
			ELSIF xPreviousPausing THEN
				Line.Status:=LINE_PAUSING;
			ELSE 
				Line.Status:=LINE_STOPPED;
			END_IF
			
			
		LINE_CONTROLLED_STOP:
			xCleanBeltToBeExecuted := FALSE;
			ControlStopping;
			IF xLineReady THEN xLineStopped:=TRUE; Line.Status:=LINE_STOPPED; END_IF
		
			
		LINE_ERROR:
			Stopping;
			IF xLineReady THEN xLineStopped:=TRUE; Line.Status:=LINE_STOPPED; END_IF

	END_CASE

	StatusSw;
	IF xStatusChanged THEN LogLineSwStatus; END_IF
	
	
	//Line state summaries
	IF Line.Status<>LINE_NOT_INITIALIZED AND Line.Status<>LINE_INITIALIZING THEN
		IF NOT (xLinePowered AND xLinePoweredON) THEN
			StopAllLineDevices;
			Line.Status:=LINE_NOT_INITIALIZED;
		ELSIF (NOT xLineStopped) THEN
			IF (NOT gMachine.St.Mode.xAuto) THEN
				Line.Status:=LINE_ERROR;
			ELSIF Line.Alarms.xCriticalAlarm THEN
				Line.Status:=LINE_ERROR;		
			ELSIF Line.Alarms.xStopAlarm THEN
				Line.Status:=LINE_CONTROLLED_STOP;
			END_IF
		ELSE
			IF NOT gMachine.St.Mode.xAuto THEN
				Line.Status := LINE_STOPPED;
			END_IF
		END_IF
	END_IF
	
	
	//Store the history of the status to easy the debug
	IF Line.Status<>StateHistory[0] THEN
		FOR iIndexHistory:=iHistoryLines TO 1 BY -1 DO 
			StateHistory[iIndexHistory]:=StateHistory[iIndexHistory-1];
		END_FOR
		StateHistory[0]:=Line.Status;
	END_IF
	
	//Previous states
	xFromPause := StateHistory[1] = LINE_PAUSED;
	
	//Resetting local status variables
	IF EDGEPOS(Line.Alarms.xStopAlarm OR Line.Alarms.xCriticalAlarm) OR Line.StatusSummary.xIdle THEN
		//xPreviousIdle := FALSE;
		xPreviousPausing := FALSE;
		xPreviousPrinting := FALSE;
	END_IF
	
	//Logging commands
	IF EDGEPOS(Line.Commands.Print) THEN LogPrintCommand; END_IF
	IF EDGEPOS(Line.Commands.Pause) THEN LogPauseCommand; END_IF
	IF EDGEPOS(Line.Commands.Stop) THEN LogStopCommand; END_IF
	IF EDGEPOS(Line.Commands.Clean) THEN LogCleanCommand; END_IF
	IF EDGEPOS(Line.Commands.EmptyBelt) THEN LogEmptyBeltCommand; END_IF
	
	//Logging buttons
	IF EDGEPOS(gMachine.In.Buttons.xStart) THEN LogStartButton; END_IF
	IF EDGEPOS(gMachine.In.Buttons.xStop) THEN LogStopButton; END_IF
	
	
	Line.SubStatus := iLineStatus;
	
	//Outputs
	LineOutputs;
	
	//Line commands
	Line.Commands := ResetedLineCommands;
	
	//Line summary
	Line.StatusSummary.xStopped 		:= Line.Status=LINE_STOPPED OR Line.Status=LINE_IDLE;
	Line.StatusSummary.xErrorStopping 	:= Line.Status=LINE_ERROR;
	Line.StatusSummary.xControlStopping := Line.Status=LINE_CONTROLLED_STOP;
	Line.StatusSummary.xCleaning 		:= (Line.Status=LINE_PREPARING_CLEANPH) OR (Line.Status=LINE_STARTING_CLEANINGPH) OR (Line.Status=LINE_CLEANINGPH) OR (Line.Status=LINE_CLEANED);
	Line.StatusSummary.xCleaningBelt	:= (Line.Status=LINE_PREPARING_CLEANBELT) OR (Line.Status=LINE_STARTING_CLEANINGBELT) OR (Line.Status=LINE_CLEANINGBELT);
	Line.StatusSummary.xPausing 		:= (Line.Status=LINE_PAUSING) OR (Line.Status=LINE_PAUSED);
	Line.StatusSummary.xPrinting 		:= (Line.Status=LINE_PREPARING_PRINT) OR (Line.Status=LINE_STARTING_PRINTING) OR (Line.Status=LINE_PRINTING);
	Line.StatusSummary.xEmptyingBelts 	:= (Line.Status=LINE_PREPARING_EMPTYBELT) OR (Line.Status=LINE_STARTING_EMPTYBELT) OR (Line.Status=LINE_BELT_EMPTYING);
	Line.StatusSummary.xIdle	 		:= Line.Status=LINE_IDLE;
	
	xFeederEmptied := FeederEmptied(ADR(Feeder));
	xPrimerEmptied := PrimerEmptied(ADR(Primer));
	xSarmEmptied := SarmEmptied(ADR(Sarm));
	xPrinterEmptied := PrinterEmptied(ADR(ThickCtrl));
	xDryerEmptied := DryerEmptied(ADR(Dryer));
	xOpvEmptied := OpvEmptied(ADR(OverVarnish));
	xStackerEmptied := StackerEmptied(ADR(Stacker));	
	Line.StatusSummary.xLineEmpty := xFeederEmptied AND xPrimerEmptied AND xSarmEmptied AND xPrinterEmptied AND xDryerEmptied AND xOpvEmptied AND xStackerEmptied; //Status added to let sw know whether line is empty
	
END_PROGRAM
