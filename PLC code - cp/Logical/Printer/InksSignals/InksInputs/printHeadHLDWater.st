
ACTION printHeadDataSHLD_Water: 
	
	CASE dataInksInput.parSw.Config.iPrintHeadType OF
		
		lc_iPrintHeadSK1536, 
		lc_iPrintHeadSK1536W, 
		lc_iPrintHeadTtec, 
		lc_iPrintHeadTtecXL, 
		lc_iPrintHeadDimatics:
			parSHLDbase;

		lc_iPrintHeadSK1536LW:
			parSHLDWater_SK1536L;

		lc_iPrintHeadX1003, 
		lc_iPrintHeadX1003gs40, 
		lc_iPrintHeadX2001, 
		lc_iPrintHeadX2001gs40:
			parSHLDWater_Xaar;

		ELSE
			dataInksInput.status.iInkState := INKS_STOPPED; 

	END_CASE

END_ACTION


ACTION parSHLDWater_SK1536L:

	parSHLDbase;
	
	dataInksInParams.xReservoirMode := TRUE;

END_ACTION


ACTION parSHLDWater_Xaar:

	parSHLDbase;
	
END_ACTION
