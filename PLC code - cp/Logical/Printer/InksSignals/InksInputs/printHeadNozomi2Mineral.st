
ACTION printHeadDataNozomi2_Mineral: 
	
	CASE dataInksInput.parSw.Config.iPrintHeadType OF
		
		lc_iPrintHeadSK1536, 
		lc_iPrintHeadSK1536W, 
		lc_iPrintHeadTtec, 
		lc_iPrintHeadTtecXL, 
		lc_iPrintHeadDimatics:
			parNozomi2base;

		lc_iPrintHeadSK1536L,
		lc_iPrintHeadSK1536LW:
			parNozomi2Mineral_SK1536L;

		lc_iPrintHeadX1003, 
		lc_iPrintHeadX1003gs40, 
		lc_iPrintHeadX2001, 
		lc_iPrintHeadX2001gs40:
			parNozomi2Mineral_Xaar;
			
		lc_iPrintHeadRicoh:
			parNozomi2Uv_Ricoh;

		ELSE
			dataInksInput.status.iInkState := INKS_STOPPED; 

	END_CASE

END_ACTION


ACTION baseModificationNozomi2:	
	
	dataInksInParams.parBar.xTypeTankSensorAnalog:=TRUE;
	dataInksInParams.parBar.xTypeTankSensorDigital:=FALSE;
	
END_ACTION


ACTION parNozomi2base:	
	
	printHeadBaseData;

	baseModificationNozomi2;
	
END_ACTION


ACTION parNozomi2Mineral_SK1536L:

	parBaseMineral_SK1536_L;
	
	baseModificationNozomi2;
	
END_ACTION


ACTION parNozomi2Mineral_Xaar:

	parBaseMineral_Xaar;

	baseModificationNozomi2;

END_ACTION

ACTION parNozomi2Uv_Ricoh:

	parNozomi2base;

	dataInksInParams.parBar.paramsPidMeniscus.rKp:= 0.4;
	dataInksInParams.parBar.paramsPidPositive.rKp:=0.2;
		
	dataInksInParams.parBar.rVacuumSensorSpan := 1000;
	dataInksInParams.parBar.rVacuumSensorOffset := -500;
	
	dataInksInParams.parBar.iTimeToActiveDcErrorAlarm := T#60s; //60000; //in ms
	
END_ACTION
