
ACTION BlockStateMach: 
	
	CASE Block.commands.StateMode OF
		
		PRINTERGEN_ZERO:
			//When entering in Zero, go to Stopping
			IF MachineStatePrevious<>PRINTERGEN_ZERO THEN
				Block.Status.BlockState := BLOCK_STOPPING;
				//If the block is not in a clear position, go to undefined
				IF Block.Status.PositionState = BLOCKP_GOING_TO_CAP OR 
					Block.Status.PositionState = BLOCKP_GOING_TO_PRINT 	THEN

					Block.Status.PositionState := BLOCKP_UNDEFINED;
					
				END_IF
				nState :=0;
			END_IF
		
		PRINTERGEN_MANUAL:
			IF Block.Status.BlockState = BLOCK_STOPPED THEN
				Block.Status.BlockState := BLOCK_MANUAL;
			END_IF
		
		PRINTERGEN_AUTO:
			IF Block.Status.BlockState = BLOCK_STOPPED THEN
				Block.Status.BlockState := BLOCK_AUTO;
			END_IF

	END_CASE
		
END_ACTION
