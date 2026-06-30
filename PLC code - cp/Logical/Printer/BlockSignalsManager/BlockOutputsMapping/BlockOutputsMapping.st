
PROGRAM _CYCLIC
	
	FOR iIndexBlock:=GC_FIRST_BLOCK TO gMachine.Pt.CT.iNumBlocks DO
		// gBlockOutputs is stBlock_Outputs: Used for mapping physical outputs block to logical block
		gBlockOutputs[gBlock[iIndexBlock].parameters.iMappingBlock]:= gBlock[iIndexBlock].Out;

	END_FOR;
	
	//////////////////////////////////////////
	// JAM OUTPUTS ASSIGNATION
	IF NOT gMachine.parSw.xJamDetectEnable THEN
		RETURN;
	END_IF
	
	FOR iIndexJam:=1 TO gMachine.St.iJamDevices DO

		//Reference working data to the general data
		dataJam ACCESS ADR(gJamDetect[iIndexJam]);
	
		IF dataJam.Parameters.iMappingJam > 0 AND dataJam.Parameters.iMappingJam <= MAX_LAST_JAMDEVICE THEN
			gJamOutputs[dataJam.Parameters.iMappingJam] := dataJam.Outputs;
		END_IF

	END_FOR;
	
END_PROGRAM
