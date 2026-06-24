
ACTION CheckParameters:
	
	iLampsQuantity := LIMIT(1,dataLed.Parameters.iLampsQuantity,iMaxNumLamps);
	iPowerSuppliesQuantity := LIMIT(1,dataLed.Parameters.iPowerSuppliesQuantity,6);
	
	FOR iIndexCuring:=1 TO iLampsQuantity DO
		dataLed.parSw.IntensitySetPoint:=LIMIT(10, dataLed.parSw.IntensitySetPoint, 100);
		dataLed.Lamp[iIndexCuring].Parameters.xInstalled := TRUE;
	END_FOR
	
	//Assigning parameters of curing area
	IF NOT dataLed.Status.xOptimizeCuring THEN
		dataLed.Status.iCuringAreaWidth := dataLed.Parameters.iMediaWidth;
		dataLed.Status.iCuringAreaOffsetL1 := dataLed.Parameters.iMediaOffsetL1;
		dataLed.Status.iCuringAreaOffsetL2 := dataLed.Parameters.iMediaOffsetL2;
	ELSE
		//Optimize curing will be active when EHD is enabled so plc does not have to consider metal bands overlap with to not burn it.
		//Document width has to be smaller than (MediaWidth- 2*Overlap). Document width is managed by SW
		dataLed.Status.iCuringAreaWidth := dataLed.Parameters.iDocumentWidth;
		dataLed.Status.iCuringAreaOffsetL1 := dataLed.Parameters.iDocumentOffsetL1;
		dataLed.Status.iCuringAreaOffsetL2 := dataLed.Parameters.iDocumentOffsetL2;
	END_IF
	
	dataLed.Status.iCuringAreaWidth := MIN(dataLed.Status.iCuringAreaWidth, dataLed.Parameters.iMaxCuringAreaWidth);
	dataLed.Status.iCuringAreaOffsetL1 := MAX(dataLed.Status.iCuringAreaOffsetL1, dataLed.Parameters.iMaxCuringAreaOffsetL1);
	dataLed.Status.iCuringAreaOffsetL2 := MIN(dataLed.Status.iCuringAreaOffsetL2, dataLed.Parameters.iMaxCuringAreaOffsetL2);
	
	
	//This action must be executed just once.
	IF iTotalNumSlms<=0 THEN
		//To sum all slm in the curing led bar. Depends on number of lamps and their width
		FOR iIndexEnableLamps:=1 TO iLampsQuantity DO 
			dataLed.Lamp[iIndexEnableLamps].Parameters.iNumSLM := (dataLed.Lamp[iIndexEnableLamps].Parameters.iCuringLength/iSlmWidth);
			iTotalNumSlms :=  iTotalNumSlms + dataLed.Lamp[iIndexEnableLamps].Parameters.iNumSLM;
		END_FOR
		
		iTotalNumSlms :=  MIN(iTotalNumSlms, 100);
		dataLed.Status.iTotalNumSlms := iTotalNumSlms;
	END_IF

END_ACTION
