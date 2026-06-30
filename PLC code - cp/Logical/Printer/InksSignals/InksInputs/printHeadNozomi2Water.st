
ACTION printHeadDataNozomi2_Water: 
	
	CASE dataInksInput.parSw.Config.iPrintHeadType OF
		
		lc_iPrintHeadSK1536, 
		lc_iPrintHeadSK1536W, 
		lc_iPrintHeadTtec, 
		lc_iPrintHeadTtecXL, 
		lc_iPrintHeadDimatics:
			parNozomi2base;

		lc_iPrintHeadSK1536L,
		lc_iPrintHeadSK1536LW:
			parNozomi2Water_SK1536L;

		lc_iPrintHeadX1003, 
		lc_iPrintHeadX1003gs40, 
		lc_iPrintHeadX2001, 
		lc_iPrintHeadX2001gs40:
			parNozomi2Water_Xaar;
			
		lc_iPrintHeadKatana:
			parNozomi2Water_Katana;
			
		lc_iPrintHeadRicoh:
			parNozomi2Water_Ricoh;

		ELSE
			dataInksInput.status.iInkState := INKS_STOPPED; 

	END_CASE

END_ACTION


ACTION parNozomi2Water_SK1536L:

	parBaseMineral_SK1536_L;

	baseModificationNozomi2;
	
END_ACTION


ACTION parNozomi2Water_Xaar:

	parBaseMineral_Xaar;

	baseModificationNozomi2;

END_ACTION

ACTION parNozomi2Water_Katana:

	parNozomi2base;

	dataInksInParams.parBar.paramsPidMeniscus.rKp:= 1.5; //0.1;
	dataInksInParams.parBar.paramsPidPositive.rKp:=0.8; //0.05;
		
	dataInksInParams.parBar.rVacuumSensorSpan := 1000;
	dataInksInParams.parBar.rVacuumSensorOffset := -500;
	
	dataInksInParams.parBar.iTimeToActiveDcErrorAlarm := T#60s; //60000; //in ms
	
END_ACTION

ACTION parNozomi2Water_Ricoh:

	parNozomi2base;

	dataInksInParams.parBar.paramsPidMeniscus.rKp:= 0.4;
	dataInksInParams.parBar.paramsPidPositive.rKp:=0.2;
		
	dataInksInParams.parBar.rVacuumSensorSpan := 1000;
	dataInksInParams.parBar.rVacuumSensorOffset := -500;
	
	dataInksInParams.parBar.iTimeToActiveDcErrorAlarm := T#60s; //60000; //in ms
	
END_ACTION