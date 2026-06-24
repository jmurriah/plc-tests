
ACTION printHeadData_P4:

	
	CASE dataInksInput.parSw.Config.iInkType OF
		lc_iInkMineral,
		lc_iInkWater:
			printHeadData_P4_Mineral;
			
		lc_iInkSolubleSalts, lc_iInkUV:
			dataInksInput.status.iInkState := INKS_STOPPED; 
			
		ELSE
			dataInksInput.status.iInkState := INKS_STOPPED; 

	END_CASE

END_ACTION


