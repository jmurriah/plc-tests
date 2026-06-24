
ACTION printHeadDataSHLD_Mineral: 
	
	
	
	CASE dataInksInput.parSw.Config.iPrintHeadType OF
		
		lc_iPrintHeadSK1536, 
		lc_iPrintHeadSK1536W, 
		lc_iPrintHeadTtec, 
		lc_iPrintHeadTtecXL, 
		lc_iPrintHeadDimatics:
			
			parSHLDbase;

			
		lc_iPrintHeadSK1536L:
			
			parSHLDMineral_SK1536L;

			
		lc_iPrintHeadX1003, 
		lc_iPrintHeadX1003gs40, 
		lc_iPrintHeadX2001, 
		lc_iPrintHeadX2001gs40:
		
			parSHLDMineral_Xaar;

			
		ELSE
			
			dataInksInput.status.iInkState := INKS_STOPPED; 

	END_CASE
		

END_ACTION


ACTION parSHLDbase:	
	
	printHeadBaseData;
	
	//Initial PID TEMPERATURE values defined by default in SHILED
	dataInksInParams.parBar.paramsPidTemp.rKp:=3.1;
	dataInksInParams.parBar.paramsPidTemp.rTi:=285.0;
	dataInksInParams.parBar.paramsPidTemp.rKd:=50.0;
	
	//Initial PID accelerator temperature params SHLD
	dataInksInParams.Temp.rk4Temp := 6.0;
	
	dataInksInParams.parBar.rAccelerationFillingPump:=2.0;

END_ACTION


ACTION parSHLDMineral_SK1536L:

	parSHLDbase;
	
	// PID MENISCUS values defined for SEIKO1536L in SHLD
	dataInksInParams.parBar.paramsPidMeniscus.rKp:=2.25;
	dataInksInParams.parBar.paramsPidMeniscus.rTi:=15;
	dataInksInParams.parBar.paramsPidMeniscus.rKd:=0.01;
	dataInksInParams.parBar.paramsPidMeniscus.rTd:=100;
	
	//Initial PID POSITIVE values defined for SEIKO1536L in SHLD
	dataInksInParams.parBar.paramsPidPositive.rKp:=0.4;
	dataInksInParams.parBar.paramsPidPositive.rTi:=7;
	dataInksInParams.parBar.paramsPidPositive.rKd:=0.01;
	dataInksInParams.parBar.paramsPidPositive.rTd:=100;

	dataInksInParams.xReservoirMode := TRUE;

END_ACTION


ACTION parSHLDMineral_Xaar:

	parSHLDbase;

	//Initial PID TEMPERATURE values defined by default in SHLD	
	dataInksInParams.parBar.paramsPidTemp.rKp:=1.5;
	dataInksInParams.parBar.paramsPidTemp.rTi:=50;
	dataInksInParams.parBar.paramsPidTemp.rKd:=40.0;
	dataInksInParams.parBar.paramsPidTemp.rTd:=30.0;
	
END_ACTION
