
ACTION CleanSystem: 
	
	//Variable used for all the counters of time. Counting seconds
	xEdge1sec := EDGEPOS(gPLC.xBlk_500ms);
	
	////////////////////////////////////////////////////////////////
	// Cleanning in Stop Mode
	// It doesnt work with delay and gap time 
	////////////////////////////////////////////////////////////////	
	
	IF gMachine.parSw.Clean.xEnableCleaningInStopMode AND gMachine.St.AutoMode.xStop AND xEdge1sec THEN
		uiSecondsToCleanStop := UDINT_SUB(uiSecondsToCleanStop, 1); // Value assigned after a cleaning
	END_IF
	IF EDGEPOS(uiSecondsToCleanStop = 0)  THEN
		gMachine.AutoCmd.xCleanningByTimeInStopMode:= TRUE;
	END_IF
	
	//Time for the next cleaning //Write 0 minutes to clean if cleaning is not activated 	
	IF gMachine.parSw.Clean.xEnableCleaningInStopMode THEN 
		IF tiPrevToCleanWhenPrinterStopped<>gMachine.parSw.Clean.tiToCleanWhenPrinterStopped THEN
			tiPrevToCleanWhenPrinterStopped := gMachine.parSw.Clean.tiToCleanWhenPrinterStopped;
			uiSecondsToCleanStop := TIME_TO_UDINT(MAX(gMachine.parSw.Clean.tiToCleanWhenPrinterStopped, MIN_CLEANING_STOPPED)) / 1000;
		END_IF
		gMachine.St.Cleaning.MinutesInStopForClean := uiSecondsToCleanStop / 60;
	ELSE
		gMachine.St.Cleaning.MinutesInStopForClean := 0; 
	END_IF 

	
	////////////////////////////////
	// Cleaning By pieces
	////////////////////////////////
		
	IF gMachine.parSw.Clean.xCleanSystemByPieces THEN	
		
		// Line 1
		IF  EDGEPOS (gMachine.St.ProductDetect.xProductDetectL1) AND gMachine.St.Position.xInPrint THEN
			gMachine.St.Cleaning.iPieceCounterBtwCleaningsL1:= gMachine.St.Cleaning.iPieceCounterBtwCleaningsL1+1;
		END_IF
		
		//Reset counter when setpoint is changed
		IF iPrevPiecesNumberToCleanL1<>gMachine.parSw.Clean.iPiecesNumberToCleanL1 THEN
			iPrevPiecesNumberToCleanL1 := gMachine.parSw.Clean.iPiecesNumberToCleanL1;
			gMachine.St.Cleaning.iPieceCounterBtwCleaningsL1:=0;
		END_IF
		
		//Reset counter L1
		IF gMachine.St.Cleaning.iPieceCounterBtwCleaningsL1 >= gMachine.parSw.Clean.iPiecesNumberToCleanL1 THEN
			gMachine.AutoCmd.xCleanningByPiecesL1:=TRUE; //Reset once machine is cleaning
			gMachine.St.Cleaning.iPieceCounterBtwCleaningsL1:=0;
		END_IF
		
		// Line 2
		IF  EDGEPOS (gMachine.St.ProductDetect.xProductDetectL2) AND gMachine.St.Position.xInPrint THEN
			gMachine.St.Cleaning.iPieceCounterBtwCleaningsL2:= gMachine.St.Cleaning.iPieceCounterBtwCleaningsL2+1;
		END_IF
		
		//Reset counter when setpoint is changed
		IF iPrevPiecesNumberToCleanL2<>gMachine.parSw.Clean.iPiecesNumberToCleanL2 THEN
			iPrevPiecesNumberToCleanL2 := gMachine.parSw.Clean.iPiecesNumberToCleanL2;
			gMachine.St.Cleaning.iPieceCounterBtwCleaningsL2:=0;
		END_IF
				
		//Reset counter L2
		IF gMachine.St.Cleaning.iPieceCounterBtwCleaningsL2 >= gMachine.parSw.Clean.iPiecesNumberToCleanL2 THEN
			gMachine.AutoCmd.xCleanningByPiecesL2:=TRUE; //Reset once machine is cleaning
			gMachine.St.Cleaning.iPieceCounterBtwCleaningsL2:=0;
		END_IF
			
	ELSE
		gMachine.St.Cleaning.iPieceCounterBtwCleaningsL1:=0;
		gMachine.St.Cleaning.iPieceCounterBtwCleaningsL2:=0;
	END_IF


	////////////////////////////////
	//	Cleanning Blocks by time
	////////////////////////////////
	
	IF gMachine.parSw.Clean.xCleanSystemByTime AND gMachine.St.AutoMode.xProduction AND xEdge1sec THEN
		uiSecondsToCleanProd := UDINT_SUB(uiSecondsToCleanProd, 1); // Value assigned after a cleaning
	END_IF
	IF EDGEPOS(uiSecondsToCleanProd = 0)  THEN
		gMachine.AutoCmd.xCleanningByTimeProd := TRUE;
	END_IF
	
	IF gMachine.parSw.Clean.xCleanSystemByTime THEN 
		IF tiPrevCleaningByTime<>gMachine.parSw.Clean.tiCleaningByTime THEN
			tiPrevCleaningByTime := gMachine.parSw.Clean.tiCleaningByTime;
			uiSecondsToCleanProd := TIME_TO_UDINT(MAX(gMachine.parSw.Clean.tiCleaningByTime, MIN_CLEANING_BY_TIME)) / 1000;
		END_IF
		gMachine.St.Cleaning.MinutesInProdForClean := uiSecondsToCleanProd / 60;
	ELSE
		gMachine.St.Cleaning.MinutesInProdForClean := 0; 
	END_IF
	
	gMachine.St.Cleaning.MinutesForClean := MIN(gMachine.St.Cleaning.MinutesInStopForClean, gMachine.St.Cleaning.MinutesInProdForClean);

	
	////////////////////////////////////////////////////////////////
	// Cleaning By External Order 
	// gMachine.In.xExternalCleaningOrder in Mapping Inputs
	////////////////////////////////////////////////////////////////
	
	// Reference Jira  CRETALEGO-867: Cleaning system for signal external it isn't active only pulse.
	// It is solved adding an event by edge and setting this timer to start external cleaning order
	// Safety for order external, it is just executed when Printer is in cap or production
	
	// Timer management		
	T_ExternalCleaningOrder.IN:= gMachine.In.xExternalCleaningOrder AND (gMachine.St.Cleaning.enCleaningState = CLN_NOT_CLEANING) AND gMachine.St.Mode.xAuto;
	T_ExternalCleaningOrder.PT:= T#500ms;
	T_ExternalCleaningOrder();
	IF EDGEPOS(T_ExternalCleaningOrder.Q) THEN
		gMachine.AutoCmd.xCleanningByExtOrder := TRUE;
	END_IF
	
	
	////////////////////////////////
	//	Cleaning while Time NOT Cleaned whatever the state
	////////////////////////////////
	IF gMachine.Pt.Clean.xEnabledCleanTotalTime AND xEdge1sec THEN
		uiSecondsToCleanTotal := UDINT_SUB(uiSecondsToCleanTotal, 1); // Value assigned after a cleaning
	END_IF
	IF EDGEPOS(uiSecondsToCleanTotal = 0 AND gMachine.St.Mode.xAuto AND gMachine.Pt.Clean.xEnabledCleanTotalTime)  THEN
		gMachine.AutoCmd.xCleanningByTotalTime:= TRUE;
	END_IF
	
	//Time for the next cleaning //Write 0 minutes to clean if cleaning is not activated 	
	IF gMachine.Pt.Clean.xEnabledCleanTotalTime THEN 
		gMachine.St.Cleaning.MinutesTotalTimeForClean := uiSecondsToCleanTotal / 60;
	ELSE
		gMachine.St.Cleaning.MinutesTotalTimeForClean := 0; 
	END_IF

	
	
	// Preparing gap in line (Add here all cleaning orders)	
	IF gMachine.AutoCmd.xCleanningByExtOrder OR 
		gMachine.AutoCmd.xCleanningByPiecesL1 OR
		gMachine.AutoCmd.xCleanningByPiecesL2 OR 
		gMachine.AutoCmd.xCleanningByTimeProd OR 
		gMachine.AutoCmd.xCleanningByTotalTime THEN
		
		IF gMachine.Pt.xControlledByLine THEN
			gMachine.St.Cleaning.xCleanRequestToLine := TRUE;
			
		ELSIF gMachine.Pt.xControlledRemotely THEN
			tonWaitToCleanRemote.IN := TRUE;
			tonWaitToCleanRemote.PT := T#10m;
			tonWaitToCleanRemote();
			gMachine.St.Cleaning.xCleanRequired := TRUE;
			gMachine.St.Cleaning.xCleanInminent := tonWaitToCleanRemote.ET > (tonWaitToCleanRemote.PT - T#30s); // Activate 30" before final activation
			IF tonWaitToCleanRemote.Q THEN
				gMachine.commands.xClean:=TRUE;
				tonWaitToCleanRemote(IN := FALSE); //Reset de remote timer
			END_IF

		ELSE
			gMachine.commands.xClean:=TRUE;
			
		END_IF
	END_IF
	
	
	// Delay control function
	FbCleanDelayControl_1.Start:= xOrderToGap;
	FbCleanDelayControl_1.T_delay_L1:= gMachine.parSw.Clean.tiTimeDelayToCleanL1;		
	FbCleanDelayControl_1.T_delay_L2:= gMachine.parSw.Clean.tiTimeDelayToCleanL2;			
	FbCleanDelayControl_1.Doble:= gMachine.parSw.Dtp.xDoubleLine;
	FbCleanDelayControl_1.t_Gap:= gMachine.parSw.Clean.tiTimeDelayGapToClean;
	FbCleanDelayControl_1();
	
	xDelayCleaningOk:= FbCleanDelayControl_1.End; //This signal allow start cleaning, the gap is and delay line are properly executed.
	
	// Mapping outputs to start getting gap in Lines
	gMachine.Out.xLine1ReadyToClean:= FbCleanDelayControl_1.Out_L1;
	gMachine.Out.xLine2ReadyToClean:= FbCleanDelayControl_1.Out_L2;

	////////////////////////////////////////////////////////////////
	// Cleaning blocks togheter or separate
	////////////////////////////////////////////////////////////////
	
	// A small state machine should be implemented here....
	//
	// Take care with action ControlState.st in Block Program !!!!
	//
	// Initial system cleaning
	// Configure first block
	// Prepare for next
	// Start next block
	// Finshed lastest block
	//
	// Enabled blocks for cleaning at once or at same time
	
	
	//Remove pending cleanings if not in Auto Mode
	IF NOT gMachine.St.Mode.xAuto THEN
		enCleaningState := CLN_NOT_CLEANING;
		ResetCleanOrders;
	END_IF
	
	
	CASE enCleaningState OF
		
		CLN_NOT_CLEANING:
			//Be ready to detect when each block has finished
			FOR iIndexBlock:=GC_FIRST_BLOCK TO gMachine.Pt.CT.iNumBlocks DO
				arBlockCleaningEnded[iIndexBlock]:=FALSE;
				gBlock[iIndexBlock].commands.xStartToCleanOrder:= FALSE;
			END_FOR			
			IF NOT gMachine.Pt.xControlledByLine THEN gMachine.St.xBeltRunPrevToClean := gBelt.states.xRuningBelt; END_IF
			
			//Cleaning with delay
			IF (gMachine.commands.xClean AND NOT gMachine.St.Position.xInCap AND NOT gMachine.St.AutoMode.xLaboratory) OR 
				gBlock[1].commands.xForceCleanDelay OR
				gBlock[2].commands.xForceCleanDelay THEN
				
				enCleaningState:= CLN_LINEDELAYING_GAP;
			END_IF
			
			//Cleaning without Delay
			IF ((gMachine.AutoCmd.xCleanningByTimeInStopMode OR gMachine.commands.xClean OR gMachine.AutoCmd.xCleanningByExtOrder) AND
				(gMachine.St.Position.xInCap OR gMachine.St.AutoMode.xLaboratory)) OR
				gBlock[1].commands.xForceCleanNoDelay OR
				gBlock[2].commands.xForceCleanNoDelay THEN
				
				enCleaningState:= CLN_READY_TO_CLEAN;
				
			END_IF
			xCleanSequencially:=FALSE;
			xOrderToGap:=FALSE;
			
		CLN_LINEDELAYING_GAP:
			xOrderToGap:=TRUE;
			IF xDelayCleaningOk THEN
				enCleaningState:= CLN_READY_TO_CLEAN;
			END_IF
		
		
		CLN_READY_TO_CLEAN:
			IF gBlock[1].commands.xForceCleanDelay OR gBlock[1].commands.xForceCleanNoDelay THEN
				enCleaningState:= CLN_CLEANING_JUST1_START;
			
			ELSIF gBlock[2].commands.xForceCleanDelay OR gBlock[2].commands.xForceCleanNoDelay THEN
				enCleaningState:= CLN_CLEANING_JUST2_START;
			
			ELSIF gMachine.parSw.Clean.xCleaningBlocksInSeq THEN
				enCleaningState:= CLN_CLEANING_1_START;
			
			ELSE
				enCleaningState:= CLN_CLEANING_ALL_START;
			
			END_IF
			ResetCleanOrders;
			
			
		CLN_CLEANING_ALL_START:
			// There is one printer command joined for all blocks
			xAllBlocksCleaning:=TRUE;
			FOR iIndexBlock:=GC_FIRST_BLOCK TO gMachine.Pt.CT.iNumBlocks DO
				
				//Check if the command is edge or not
				iReasonToSendCleanOrder.0 := gBlock[iIndexBlock].Status.PositionState<>BLOCKP_CLEANING;
				iReasonToSendCleanOrder.1 := gBlock[iIndexBlock].Status.xEnabledToClean;
				iReasonToSendCleanOrder.2 := gBlock[iIndexBlock].Status.xEnabledMovements;

				//Sent the order if not sended and the block is able to clean
				IF iReasonToSendCleanOrder = 2#0111 THEN
					gBlock[iIndexBlock].commands.xStartToCleanOrder:= TRUE;
					xAllBlocksCleaning:=FALSE; //If any block not cleaning, fall the signal
				END_IF

			END_FOR

			//To be sure that the order has been sent and not resent it again
			IF xAllBlocksCleaning THEN 
				enCleaningState:= CLN_CLEANING_ALL_CLEANING; 
			END_IF

					
		CLN_CLEANING_ALL_CLEANING:	
			//Check if ALL Blocks have finished
			xAllBlocksCleaningEnded:=TRUE;
			FOR iIndexBlock:=GC_FIRST_BLOCK TO gMachine.Pt.CT.iNumBlocks DO
				IF NOT gBlock[iIndexBlock].Status.xCleaningDone THEN
					xAllBlocksCleaningEnded:=FALSE;
				END_IF
			END_FOR
			
			IF xAllBlocksCleaningEnded THEN
				enCleaningState:= CLN_NOT_CLEANING; // Cleaning state in block finished
				ResetCleanOrders;
				ResetCleanCountersAndTimers;
			END_IF

			
		CLN_CLEANING_1_START:
			xCleanSequencially:=TRUE;
			iIndexBlock:=1;
			CleanBlockStart;
			
		CLN_CLEANING_1_CLEANING:
			iIndexBlock:=1;
			CleanBlockCleaning;
			
		CLN_CLEANING_BTW_BLOCKS:	
			//Timer management for cleaning between blocks
			T_BtwnCleans.IN:= TRUE;
			T_BtwnCleans.PT:= gMachine.parSw.Clean.tiBetweenCleaningBlocks;
			T_BtwnCleans();
			IF T_BtwnCleans.Q THEN
				enCleaningState:= CLN_CLEANING_2_START;
				T_BtwnCleans.IN:= FALSE; 
				T_BtwnCleans(); //This is to fall the output of the Timer and be able to count on next cycle
			END_IF
			
		CLN_CLEANING_2_START:
			iIndexBlock:=2;
			CleanBlockStart;
			
		CLN_CLEANING_2_CLEANING:
			iIndexBlock:=2;
			CleanBlockCleaning;
		
			
		CLN_CLEANING_JUST1_START:
			iIndexBlock:=1;
			CleanBlockStart;

		CLN_CLEANING_JUST1_CLEANING:
			iIndexBlock:=1;
			CleanBlockCleaning;
			
			
		CLN_CLEANING_JUST2_START:
			iIndexBlock:=2;
			CleanBlockStart;

		CLN_CLEANING_JUST2_CLEANING:
			iIndexBlock:=2;
			CleanBlockCleaning;
		
		
	END_CASE
	
	gMachine.St.Cleaning.enCleaningState := enCleaningState;
	//Return value to Sw
	CASE enCleaningState OF
		CLN_NOT_CLEANING: gMachine.St.Cleaning.iCleaningState := 1;
		CLN_LINEDELAYING_GAP: gMachine.St.Cleaning.iCleaningState := 2;
		CLN_READY_TO_CLEAN: gMachine.St.Cleaning.iCleaningState := 3;
		CLN_CLEANING_ALL_START: gMachine.St.Cleaning.iCleaningState := 4;
		CLN_CLEANING_ALL_CLEANING: gMachine.St.Cleaning.iCleaningState := 5;
		CLN_CLEANING_1_START: gMachine.St.Cleaning.iCleaningState := 6;
		CLN_CLEANING_1_CLEANING: gMachine.St.Cleaning.iCleaningState := 7;
		CLN_CLEANING_BTW_BLOCKS: gMachine.St.Cleaning.iCleaningState := 8;
		CLN_CLEANING_2_START: gMachine.St.Cleaning.iCleaningState := 9;
		CLN_CLEANING_2_CLEANING: gMachine.St.Cleaning.iCleaningState := 10;
		CLN_CLEANING_JUST1_START: gMachine.St.Cleaning.iCleaningState := 11;
		CLN_CLEANING_JUST1_CLEANING: gMachine.St.Cleaning.iCleaningState := 12;
		CLN_CLEANING_JUST2_START: gMachine.St.Cleaning.iCleaningState := 13;
		CLN_CLEANING_JUST2_CLEANING: gMachine.St.Cleaning.iCleaningState := 14;
	END_CASE
END_ACTION


ACTION CleanBlockStart:
	
	iReasonToSendCleanOrder.0 := gBlock[iIndexBlock].Status.PositionState<>BLOCKP_CLEANING;
	iReasonToSendCleanOrder.1 := gBlock[iIndexBlock].Status.xEnabledToClean;
	iReasonToSendCleanOrder.2 := gBlock[iIndexBlock].Status.xEnabledMovements;

	//Sent the order if not sended and the block is able to clean
	IF iReasonToSendCleanOrder = 2#0111 THEN
			gBlock[iIndexBlock].commands.xStartToCleanOrder:= TRUE;
					
	//If cleaning or not possible to clean, go to next step
	ELSE
		gBlock[iIndexBlock].commands.xStartToCleanOrder:= FALSE;
		IF xCleanSequencially THEN
			CASE iIndexBlock OF
				1:	enCleaningState:= CLN_CLEANING_1_CLEANING; 
				2:	enCleaningState:= CLN_CLEANING_2_CLEANING; 
			END_CASE		
		ELSE
			CASE iIndexBlock OF
				1:	enCleaningState:= CLN_CLEANING_JUST1_CLEANING; 
				2:	enCleaningState:= CLN_CLEANING_JUST2_CLEANING; 
			END_CASE
		END_IF
	END_IF
	
END_ACTION

ACTION CleanBlockCleaning:
	
	//Check if ALL Blocks have finished
	IF gBlock[iIndexBlock].Status.xCleaningDone THEN
		IF xCleanSequencially THEN
			CASE iIndexBlock OF
				1:	enCleaningState:= CLN_CLEANING_BTW_BLOCKS; 
				2:	enCleaningState:= CLN_NOT_CLEANING; ResetCleanOrders;
			END_CASE		
		ELSE
			enCleaningState:= CLN_NOT_CLEANING; 
			ResetCleanOrders; // Cleaning state in block finished
			ResetCleanCountersAndTimers;
		END_IF				
	END_IF
	
END_ACTION

ACTION ResetCleanOrders:

	//Reset Cleaning orders once the machine is cleaning
	gMachine.AutoCmd.xCleanningByTimeProd:=FALSE;
	gMachine.AutoCmd.xCleanningByTotalTime:=FALSE;
	gMachine.AutoCmd.xCleanningByExtOrder:=FALSE;
	gMachine.AutoCmd.xCleanningByPiecesL1:=FALSE;
	gMachine.AutoCmd.xCleanningByPiecesL2:=FALSE;
	gMachine.AutoCmd.xCleanningByTimeInStopMode:=FALSE;
	gBlock[1].commands.xForceCleanNoDelay:=FALSE;
	gBlock[2].commands.xForceCleanNoDelay:=FALSE;
	gBlock[1].commands.xForceCleanDelay:= FALSE;
	gBlock[2].commands.xForceCleanDelay:=FALSE;
	gMachine.St.Cleaning.xCleanRequestToLine := FALSE;
	gMachine.commands.xClean := FALSE;
	gMachine.St.Cleaning.xCleanRequired := FALSE;
	gMachine.St.Cleaning.xCleanInminent := FALSE;
	tonWaitToCleanRemote(IN := FALSE); //Reset de remote timer

END_ACTION

ACTION ResetCleanCountersAndTimers:

	iSecondsNoCleaned := 0;
	
	uiSecondsToCleanStop := TIME_TO_UDINT(MAX(gMachine.parSw.Clean.tiToCleanWhenPrinterStopped, MIN_CLEANING_STOPPED)) / 1000;
	uiSecondsToCleanProd := TIME_TO_UDINT(MAX(gMachine.parSw.Clean.tiCleaningByTime, MIN_CLEANING_BY_TIME)) / 1000;
	uiSecondsToCleanTotal := 24 * 3600; // Maximum 1 day
	
END_ACTION