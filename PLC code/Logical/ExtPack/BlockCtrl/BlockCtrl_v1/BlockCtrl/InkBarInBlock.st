
(* This function returns if the bar determined by the index is in the current block *)
FUNCTION InkBarInBlock
	InkBarInBlock := inksArr[InkIndex].parSw.Config.iMappingBar > 0 AND 
					(
					(Block.parameters.xLeftHandMachine AND INT_TO_USINT((INT_TO_USINT(inksArr[InkIndex].parSw.Config.iMappingBar)-1) / Block.parameters.Inks.iMaxBlockPrintBars ) = gIndexBlock - 1)	OR 
					(Block.parameters.xRightHandMachine AND INT_TO_USINT((INT_TO_USINT(inksArr[InkIndex].parSw.Config.iMappingBar)-1) / Block.parameters.Inks.iMaxBlockPrintBars ) = Block.parameters.iLastBlock - gIndexBlock)
					);
	
END_FUNCTION
