
ACTION InksDataAssignation: 

	//Execute once every 500ms
	IF NOT EDGE(gPLC.xBlk_100ms) THEN
		RETURN;
	END_IF
	
	//Starting index at the beginnig OR after all ink system
	IF iIndexInksSlow = 0 OR iIndexInksSlow > MAX_LAST_INK THEN
		iIndexInksSlow := 1;
	END_IF

	//Reference working data to the general data
	dataInksInput ACCESS ADR(gInks[iIndexInksSlow]);
	
	// To avoid not working in simulation because of not Kernel working
	IF gMachine.Pt.ConfigNameID = GC_CONFIG_SIMTEST_ID	THEN
		IF dataInksInput.parSw.Config.iInkType <= 0 THEN
			dataInksInput.parSw.Config.iInkType:=lc_iInkMineral;
		END_IF
		IF dataInksInput.parSw.Config.iPrintHeadType <= 0 THEN
			dataInksInput.parSw.Config.iPrintHeadType:=lc_iPrintHeadSK1536;
		END_IF
	END_IF

	//Assign current data to working data
	dataInksInParams := dataInksInput.parameters;
	
	//Assign parameters data to working data
	printHeadData;
	
	//Assign working data to Ink parameters
	dataInksInput.parameters := dataInksInParams;

	dataInksInput.parameters.Temp.iBarsWithSamePsu:= gBlock[1].parameters.Inks.iMaxBlockPrintBars+1;	
	
	// ENDING THE SLOW LOOP
	iIndexInksSlow := iIndexInksSlow + 1;
		
END_ACTION
