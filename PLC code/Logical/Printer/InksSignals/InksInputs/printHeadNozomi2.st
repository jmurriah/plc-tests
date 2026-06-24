
ACTION printHeadData_Nozomi2:
	
	CASE dataInksInput.parSw.Config.iInkType OF
		lc_iInkMineral,
		lc_iInkUV:
			printHeadDataNozomi2_Mineral;
		
		lc_iInkWater:
			printHeadDataNozomi2_Water;
			
		lc_iInkSolubleSalts:
			dataInksInput.status.iInkState := INKS_STOPPED; 
			
		ELSE
			dataInksInput.status.iInkState := INKS_STOPPED; 

	END_CASE

END_ACTION


