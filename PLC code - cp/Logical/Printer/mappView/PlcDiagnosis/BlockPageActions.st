
ACTION Block_getIndex: 

	Block_SelBlock ACCESS ADR(gBlock[LIMIT(1,Block_iBlockIdx,2)]);
	Block_SelBlockInp ACCESS ADR(gBlockInputs[LIMIT(1,Block_iBlockIdx,2)]);
	
	IF Block_iBlockIdx = 1 THEN
		
		FOR Block_iSlotIdx := 1 TO MAX_LAST_INK DO
			
			IF Block_iSlotIdx1 = gInks[Block_iSlotIdx].parSw.Config.iMappingBar THEN 
				
				Block_SelInk ACCESS ADR(gInks[Block_iSlotIdx]);
				EXIT;
				
			END_IF
		
		END_FOR
		
	ELSIF Block_iBlockIdx = 2 THEN 
		
		FOR Block_iSlotIdx := 1 TO MAX_LAST_INK DO
			
			IF (Block_iSlotIdx2 + gBlock[1].parameters.Inks.iMaxBlockPrintBars) = gInks[Block_iSlotIdx].parSw.Config.iMappingBar THEN 
				
				Block_SelInk ACCESS ADR(gInks[Block_iSlotIdx]);
				EXIT;
				
			END_IF
		
		END_FOR
		
	END_IF
	
END_ACTION

ACTION Block_getSlots: 

	FOR Block_iGetSlotIdx := 1 TO gBlock[1].parameters.Inks.iMaxBlockPrintBars DO
		
		FOR Block_iSlotIdx := 1 TO MAX_LAST_INK DO
		
			IF Block_iGetSlotIdx = gInks[Block_iSlotIdx].parSw.Config.iMappingBar THEN
				
				Block_SlotB1[LIMIT(1,Block_iGetSlotIdx,MAX_LAST_INK)] := TRUE;
				EXIT;
				
			ELSE 
				
				Block_SlotB1[LIMIT(1,Block_iGetSlotIdx,MAX_LAST_INK)] := FALSE;
				
			END_IF
		
		END_FOR
	
	END_FOR 
	
	FOR Block_iGetSlotIdx :=  1 TO MAX_LAST_INK  DO
		
		FOR Block_iSlotIdx := 1 TO MAX_LAST_INK DO
		
			IF gInks[Block_iSlotIdx].parSw.Config.iMappingBar = Block_iGetSlotIdx + gBlock[1].parameters.Inks.iMaxBlockPrintBars THEN
				
				Block_SlotB2[LIMIT(1,Block_iGetSlotIdx ,MAX_LAST_INK)] := TRUE;
				EXIT;
				
			ELSE 
				
				Block_SlotB2[LIMIT(1,Block_iGetSlotIdx, MAX_LAST_INK)] := FALSE;
				
			END_IF
		
		END_FOR
	
	END_FOR 
	
END_ACTION