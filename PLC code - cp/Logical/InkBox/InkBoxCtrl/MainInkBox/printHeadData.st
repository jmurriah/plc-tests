
ACTION printHeadData: 
	
	IF dataInksInput.parameters.xDebugMode THEN
		dataInksInParams.parBar := gInksPermanentParBar[iIndex];
		RETURN;
	END_IF
	
	printHeadData_Nozomi2;

END_ACTION


