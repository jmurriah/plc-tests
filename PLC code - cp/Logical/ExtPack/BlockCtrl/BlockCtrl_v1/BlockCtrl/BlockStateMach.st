
ACTION BlockStateMach: 
	
	CASE Block.commands.StateMode OF
		
		PRINTERGEN_ZERO:
			//When entering in Zero, go to Stopping
			IF MachineStatePrevious<>PRINTERGEN_ZERO THEN
				Block.Status.BlockState := BLOCK_STOPPING;
				
				//Reset cleaning order and status if going to 0 while cleaning
				IF Block.Status.PositionState = BLOCKP_CLEANING THEN
					ResetCleanCycle;
				END_IF
				
				//If the block is not in a clear position, go to undefined
				IF Block.Status.PositionState <> BLOCKP_IN_CAP AND Block.Status.PositionState <> BLOCKP_IN_PRINT THEN
					Block.Status.PositionState := BLOCKP_UNDEFINED;
				END_IF
				nState :=0;
			END_IF
		
		PRINTERGEN_STARTUP:
			IF Block.Status.BlockState = BLOCK_STOPPED AND NOT Block.Status.Motor.xBarsHomed THEN
				Block.Status.BlockState := BLOCK_MANUAL;
			END_IF
			IF Block.Status.Motor.xBarsHomed THEN
				Block.Status.BlockState := BLOCK_AUTO;
			END_IF
			
			
		PRINTERGEN_MANUAL:
			IF Block.Status.BlockState = BLOCK_STOPPED THEN
				Block.Status.BlockState := BLOCK_MANUAL;
			END_IF
		
		PRINTERGEN_AUTO:
			
			IF Block.Status.BlockState = BLOCK_STOPPED AND AllDevicedHomed(ADR(Block)) THEN
				Block.Status.BlockState := BLOCK_AUTO;
			END_IF

	END_CASE
		
END_ACTION
