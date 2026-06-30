
ACTION printHeadData_P4_Mineral: 
	
	CASE dataInksInput.parSw.Config.iPrintHeadType OF
		
		lc_iPrintHeadSK1536, 
		lc_iPrintHeadSK1536W, 
		lc_iPrintHeadTtec, 
		lc_iPrintHeadTtecXL, 
		lc_iPrintHeadDimatics:
			printHeadBaseData;
	
		lc_iPrintHeadSK1536L,
		lc_iPrintHeadSK1536LW:
			parBaseMineral_SK1536_L;
		
		lc_iPrintHeadX1003, 
		lc_iPrintHeadX1003gs40, 
		lc_iPrintHeadX2001, 
		lc_iPrintHeadX2001gs40:
			parBaseMineral_Xaar;

		ELSE
			dataInksInput.status.iInkState := INKS_STOPPED; 

	END_CASE
		
END_ACTION
