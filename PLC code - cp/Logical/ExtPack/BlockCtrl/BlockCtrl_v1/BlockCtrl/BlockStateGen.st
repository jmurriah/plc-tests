
ACTION BlockStateGen:

	// PRINT POSITION ORDER
	xOrderToPrint:=	(Block.commands.xToPrint AND Block.parSw.xEnableToPrint) OR
					(Block.commands.xToPrintLab AND Block.commands.AutoMode.xLaboratory);
	
	// CAP POSITION ORDER
	//When in capping position, bars are touching the tray and was required to be able to move out bars in auto mode when front doors is opened 
	IF Block.Status.Position.xInCap AND Block.parameters.xCappingProcess THEN
		xFrontDoorStatusChanged := (Block.In.xFrontDoorClosed <> xFrontDoorStatus) OR
									(NOT Block.In.xFrontDoorClosed AND EDGEPOS(Block.commands.Mode.xAuto));
	END_IF
	
	xCapOrder:= Block.commands.xToCap OR 
				(Block.commands.xToCapLab AND Block.commands.AutoMode.xLaboratory) OR 
				EDGENEG(Block.parSw.xEnableToPrint) OR 
				xFrontDoorStatusChanged;
	
	xFrontDoorStatus := Block.In.xFrontDoorClosed;
	
	// CLEANING CYCLE FROM SW COMMAND 
	Block.Status.xIsWaterBlock := Block.parameters.Hw.xIsWater AND Block.commands.xEnableCleaningWithWater;
	IF Block.Status.xIsWaterBlock AND xAlrToAvoidCleanWithWater THEN
		Block.Status.xEnabledToClean := FALSE;
	ELSE
		Block.Status.xEnabledToClean := TRUE;
	END_IF
	
	rsCleaning.SET:= Block.Status.xEnabledToClean AND
					(Block.commands.xStartToCleanOrder AND Block.Status.PositionState <> BLOCKP_CLEANING);
	rsCleaning.RESET1:= NOT Block.Status.xEnabledToClean OR
						EDGEPOS(Block.Status.xCleaningDone) OR
						NOT (Block.commands.Mode.xAuto);
	rsCleaning();
	xStartToCleanOrder:=rsCleaning.Q1;	
	
	//To reset manual commands when not in manual mode
	IF Block.Status.BlockState <> BLOCK_MANUAL THEN
		Block.commands.Manual := ResetManCommands;
	END_IF

	
	CASE Block.Status.BlockState OF
		
		BLOCK_STOPPED:
			AxisBK.Command.QuickStop:=FALSE;

			
		BLOCK_STOPPING:
			StopMovements;
			//Added to modify block position so for example when homing icla or bar and 
			//going TO zero, block position remained in homing even motors were stopped and Block status were "BLOCK_STOPPING"
			IF (Block.Status.PositionState=BLOCKP_HOMING_ICLA OR Block.Status.PositionState=BLOCKP_HOMING_BAR) THEN
				Block.Status.PositionState := BLOCKP_UNDEFINED;
			END_IF
				
			IF AllDevicedStopped(ADR(Block), ADR(AxisBK), ADR(IclaBK)) THEN
				Block.Status.BlockState := BLOCK_STOPPED;
			END_IF
			
			
		BLOCK_MANUAL:
			ManualMovements;
			
			IF Block.commands.xIclaHomeOrder AND NOT Block.Status.Motor.xBarsHoming THEN
				IF Block.parameters.xPrinterKeyMaintenanceActivated THEN
					Block.commands.xIclaHomeOrder:=FALSE;
				ELSE
					Block.Status.PositionState := BLOCKP_HOMING_ICLA;
				END_IF
			
			// To do home in block is mandatory to have Icla at sensor and try out
			ELSIF Block.commands.xBarHomeOrder THEN
				
				IF Block.In.xTrayIn OR NOT Block.In.xIclaSensor OR Block.parameters.xPrinterKeyMaintenanceActivated THEN
					Block.commands.xBarHomeOrder:=FALSE;
				ELSIF Block.In.xTrayOut AND Block.In.xIclaSensor AND NOT Block.Al.xAlrReferenceIncoherence THEN
					Block.Status.PositionState := BLOCKP_HOMING_BAR;					
				ELSE
					Block.commands.xBarHomeOrder:=FALSE;
				END_IF
			
			ELSIF Block.commands.xToCleanPosition AND Block.Status.PositionState = BLOCKP_IN_CAP THEN
				Block.Status.PositionState := BLOCKP_GOING_TO_CLEAN;
				//Signal reseted outside the case to avoid a memory if the movement cannot be done
				
			ELSIF Block.commands.Manual.xToPrintPosition AND NOT Block.parameters.xMediaBelow AND Block.Status.PositionState = BLOCKP_IN_CAP THEN
				Block.Status.PositionState := BLOCKP_GOING_TO_PRINT;
				//Signal reseted outside the case to avoid a memory if the movement cannot be done
				
			END_IF
			
			
		BLOCK_AUTO:
			IF xStartToCleanOrder THEN
	
				//Enable cleaning in bar to end ReverseFlow
				IF Block.Status.PositionState <> BLOCKP_CLEANING THEN
					IF 	Block.Status.PositionState = BLOCKP_GOING_TO_PRINT OR Block.Status.PositionState = BLOCKP_IN_PRINT THEN
						BlockPositionPreviousCleaning := BLOCKP_GOING_TO_PRINT;
					ELSE
						BlockPositionPreviousCleaning := BLOCKP_GOING_TO_CAP;
					END_IF
					Block.Status.PositionState := BLOCKP_CLEANING;
				END_IF

				//If receiving a Going to Cap order while cleaning, store the information
				IF xCapOrder THEN
					BlockPositionPreviousCleaning := BLOCKP_GOING_TO_CAP;
				END_IF
				
			ELSIF (xCapOrder AND Block.Status.Motor.xBarsHomed AND (Block.In.xIclaSensor OR IclaBK.Status.iDriveStatus=ICLAST_ENABLE_OPERATION)) THEN
				//I move to STOP
				Block.Status.PositionState := BLOCKP_GOING_TO_CAP;
			
			ELSIF xOrderToPrint AND NOT xInPrint AND NOT Block.AlSummary.xAlarmCritical AND NOT Block.AlSummary.xAlarmStop THEN
				//Going TO PRINT
				Block.Status.PositionState := BLOCKP_GOING_TO_PRINT;
				
			END_IF
			
			IF 	EDGEPOS(Block.Status.xCleaningDone) THEN
				//Once he cleaning has finished, go to the previous position
				Block.Status.PositionState := BlockPositionPreviousCleaning;
			END_IF
		
	END_CASE

	//Copying block's outputs to status
	Block.Status.ManualCommands := Block.Out;
	
	//Saving state history
	IF Block.Status.BlockState<>StateGenHistory[0] THEN
		ShiftArrayForward(ADR(StateGenHistory), SIZEOF(StateGenHistory), SIZEOF(StateGenHistory[0]), 1, iHistoryLines);
		StateGenHistory[0]:=Block.Status.BlockState;
	END_IF
	
END_ACTION
