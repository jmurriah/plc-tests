
PROGRAM _CYCLIC

		//If in automation runtime, do not assign physical mapping
	IF gMachine.St.HwData.Family = FAMILY_BRAUTOMATIONRUNTIME THEN
		RETURN;
	END_IF
	
	FOR iIndexBlockIn := GC_FIRST_BLOCK TO gMachine.Pt.CT.iNumBlocks DO
		// gBlockOutputs is stBlock_Inputs
		gBlock[iIndexBlockIn].In := gBlockInputs[gBlock[iIndexBlockIn].parameters.iMappingBlock];
		
	END_FOR;
	
	//////////////////////////////////////////
	// JAM INPUTS ASSIGNATION
	IF NOT gMachine.parSw.xJamDetectEnable THEN
		RETURN;
	END_IF
	
	FOR iIndexJam:=1 TO gMachine.St.iJamDevices DO

		//Reference working data to the general data
		dataJam ACCESS ADR(gJamDetect[iIndexJam]);
	
		IF dataJam.Parameters.iMappingJam > 0 AND dataJam.Parameters.iMappingJam <= MAX_LAST_JAMDEVICE THEN
			dataJam.Inputs := gJamInputs[dataJam.Parameters.iMappingJam];
		END_IF
	
	END_FOR;
	
END_PROGRAM
