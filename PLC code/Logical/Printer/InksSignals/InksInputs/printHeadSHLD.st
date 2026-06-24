
ACTION printHeadData_SHLD:
	
	CASE dataInksInput.parSw.Config.iInkType OF
		
		lc_iInkMineral:
			
			printHeadDataSHLD_Mineral;
			
		lc_iInkWater:

			printHeadDataSHLD_Water;
			
		lc_iInkSolubleSalts, lc_iInkUV:
			
			dataInksInput.status.iInkState := INKS_STOPPED; 
			
		ELSE
			dataInksInput.status.iInkState := INKS_STOPPED; 

	END_CASE

END_ACTION


