
PROGRAM _CYCLIC
	(* Insert code here *)
	 
	FOR iIndexInksOut:=1 TO MAX_LAST_INK DO

		//Reference working data to the general data
		dataInksOut ACCESS ADR(gInks[iIndexInksOut]);
	
		IF dataInksOut.parSw.Config.iMappingBar >= 1 AND dataInksOut.parSw.Config.iMappingBar <= MAX_LAST_INK THEN
			gInksOutputs[dataInksOut.parSw.Config.iMappingBar]:= dataInksOut.signals.out;
		END_IF		

	END_FOR;
	
	
	// ####################################################################
	// ####################################################################
	//  Reset bar outputs if do not have any logical bar mapped
	// ####################################################################
	
	// Reset the index if the index is not valid
	IF iIndexPhysicalInksSlow = 0 OR iIndexPhysicalInksSlow > MAX_LAST_INK THEN 
		//Resetart index
		iIndexPhysicalInksSlow := 1;
		iIndexInksSlow := 1;
	END_IF
	IF iIndexInksSlow = 0 OR iIndexInksSlow > MAX_LAST_INK THEN iIndexInksSlow := 1; END_IF
	
	//If the physical bar has a logical bar in that position, go to next physical bar and reset logical index bar
	IF iIndexPhysicalInksSlow = INT_TO_USINT(gInks[iIndexInksSlow].parSw.Config.iMappingBar) THEN
		iIndexPhysicalInksSlow := iIndexPhysicalInksSlow + 1;
		iIndexInksSlow := 1;
	ELSE
		iIndexInksSlow := iIndexInksSlow + 1;		
	END_IF
	
	//If there is no logical bar with the mapping of the physical position, reset the outputs
	IF iIndexInksSlow > MAX_LAST_INK THEN
		
		//Reset the outputs to avoid keeping the outputs active
		gInksOutputs[iIndexPhysicalInksSlow] := inksOutputsReseted;
		
		//Go to next physical and reset logical index bar
		iIndexPhysicalInksSlow := iIndexPhysicalInksSlow + 1;	
		iIndexInksSlow := 1;
	END_IF
	
END_PROGRAM
