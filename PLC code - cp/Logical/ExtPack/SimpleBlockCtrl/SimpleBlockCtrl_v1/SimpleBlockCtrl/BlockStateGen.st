
ACTION BlockStateGen:

	// PRINT POSITION ORDER
	xOrderToPrint:=	(Block.commands.xToPrint AND Block.parSw.xEnableToPrint) OR
					(Block.commands.xToPrintLab AND Block.commands.AutoMode.xLaboratory);
	
	// CAP POSITION ORDER
	xCapOrder:= Block.commands.xToCap OR 
				(Block.commands.xToCapLab AND Block.commands.AutoMode.xLaboratory) OR 
				EDGENEG(Block.parSw.xEnableToPrint);

	
	CASE Block.Status.BlockState OF
		
		BLOCK_STOPPED:
			AxisBK.Command.QuickStop:=FALSE;

			
		BLOCK_STOPPING:
			StopMovements;
			IF AllDevicedStopped(ADR(Block), ADR(AxisBK)) THEN
				Block.Status.BlockState := BLOCK_STOPPED;
			END_IF
			
			
		BLOCK_MANUAL:
			ManualMovements;
			
			// To do home in block is mandatory to have Icla at sensor and try out
			IF Block.commands.xBarHomeOrder THEN

				Block.Status.PositionState := BLOCKP_HOMING_BAR;
			
			END_IF
			
			
		BLOCK_AUTO:

			IF (xCapOrder AND NOT xInCap AND Block.Status.Motor.xBarsHomed) THEN
				//I movoe to STOP
				Block.Status.PositionState := BLOCKP_GOING_TO_CAP;
			
			ELSIF xOrderToPrint AND NOT xInPrint AND NOT Block.AlSummary.xAlarmCritical AND NOT Block.AlSummary.xAlarmStop THEN
				//Going TO PRINT
				Block.Status.PositionState := BLOCKP_GOING_TO_PRINT;
				
			END_IF
			
	END_CASE

	
END_ACTION
