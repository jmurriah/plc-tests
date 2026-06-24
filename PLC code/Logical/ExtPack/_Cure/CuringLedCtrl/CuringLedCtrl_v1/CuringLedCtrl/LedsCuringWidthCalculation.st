ACTION StretchesCalculation:	
	
	//Disabling all curing led bar's SLMs
	FOR iIndexEnableSlm:=0 TO iTotalNumSlms DO
		xCuringLedSlms[iIndexEnableSlm] := FALSE;
	END_FOR
	
	//DELOREAN-1778: To set printer's center
	iTotalWidth := iTotalNumSlms*iSlmWidth;
	iCenterPosition := REAL_TO_INT(iTotalWidth/2);
	
END_ACTION

ACTION SingleLineCalculation:
	//To caculate first SLM of the total curing led bar SLMs 
	rFirstCuringBarSlmL1 := INT_TO_REAL(iCenterPosition + dataLed.Status.iCuringAreaOffsetL1)/iSlmWidth;
	pInteger := ADR(rInteger);
	rMantissa := modf(rFirstCuringBarSlmL1, pInteger);
	
	iFirstCuringBarSlmL1 := REAL_TO_UINT(rFirstCuringBarSlmL1);
	IF rMantissa = 0.0 THEN iFirstCuringBarSlmL1 := iFirstCuringBarSlmL1 + 1; END_IF
	

	//To caculate last SLM of the total curing led bar SLMs
	rLastCuringBarSlmL1 := (UINT_TO_REAL(iCenterPosition + dataLed.Status.iCuringAreaOffsetL1 + dataLed.Status.iCuringAreaWidth)/INT_TO_REAL(iSlmWidth));
	pInteger := ADR(rInteger);
	rMantissa := modf(rLastCuringBarSlmL1, pInteger);
	
	iLastCuringBarSlmL1 := REAL_TO_UINT(rInteger);
	IF rMantissa > 0.0 THEN iLastCuringBarSlmL1 := iLastCuringBarSlmL1 + 1; END_IF
	iLastCuringBarSlmL1 := LIMIT(iFirstCuringBarSlmL1, iLastCuringBarSlmL1, iTotalNumSlms);
	
	//Activating curing led bar's SLMs
	FOR iIndexEnableSlm:=iFirstCuringBarSlmL1 TO iLastCuringBarSlmL1 DO
		xCuringLedSlms[iIndexEnableSlm] := TRUE;
	END_FOR
	
	//To enable lamps stretches
	iLastLampSLM := 0;
	FOR iIndexEnableLamps:=1 TO iLampsQuantity DO
		iNumLampSLM := dataLed.Lamp[iIndexEnableLamps].Parameters.iNumSLM; //Number of lamp's SLMs
		
		//Lamp's first SLM of array "xCuringLedSlms" which considers all SLM in the curing led bar
		iFirstLampSLM := iLastLampSLM + 1;
		iLastLampSLM := iLastLampSLM + dataLed.Lamp[iIndexEnableLamps].Parameters.iNumSLM;

		dataLed.Lamp[iIndexEnableLamps].Parameters.iFirstSlm := iFirstLampSLM;
		dataLed.Lamp[iIndexEnableLamps].Parameters.iLastSlm := iLastLampSLM;

		dataLed.Lamp[iIndexEnableLamps].Parameters.xFullActive := TRUE;
				
		
		//Calculating slm mirrored to indexSlm. So xCuringLedSlms starts counting from user side to drive side. But lamps are mechanically assemblied in a reverse way, here an image to understand:
		
		//xCuringLedSlms[x]	  1						  14  15					  28  29					  42  43					  56
		//Lamp's slm index	  14					   1  14					   1  14					   1  14					   1
							//							//							//							//							//
		//FRONT/USER SIDE//	//			1				//			2				//			3				//			4				//		//REAR/WALKWAY SIDE//
							//							//							//							//							//
							//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		FOR iIndexEnableSlm:=1 TO iNumLampSLM DO					
			iMirrorSlm := iLastLampSLM - iIndexEnableSlm + 1;
			dataLed.Lamp[iIndexEnableLamps].Parameters.xSlmEnable[iIndexEnableSlm] := xCuringLedSlms[iMirrorSlm];
			
			IF (NOT dataLed.Lamp[iIndexEnableLamps].Parameters.xSlmEnable[iIndexEnableSlm]) THEN
				dataLed.Lamp[iIndexEnableLamps].Parameters.xFullActive := FALSE;
			END_IF
		END_FOR
	END_FOR
	
	
END_ACTION

ACTION DoubleLineCalculation:
	
	///////////		L1		///////////
	rFirstCuringBarSlmL1 := INT_TO_REAL(iCenterPosition + dataLed.Status.iCuringAreaOffsetL1)/iSlmWidth;
	iFirstCuringBarSlmL1 := REAL_TO_UINT(rFirstCuringBarSlmL1) + 1;

	//To caculate last SLM of the total curing led bar SLMs
	rLastCuringBarSlmL1 := (UINT_TO_REAL(iCenterPosition + dataLed.Status.iCuringAreaOffsetL1 + dataLed.Status.iCuringAreaWidth)/INT_TO_REAL(iSlmWidth));
	pInteger := ADR(rInteger);
	rMantissa := modf(rLastCuringBarSlmL1, pInteger);
	
	iLastCuringBarSlmL1 := REAL_TO_UINT(rInteger);
	IF rMantissa > 0.0 THEN iLastCuringBarSlmL1 := iLastCuringBarSlmL1 + 1; END_IF
	iLastCuringBarSlmL1 := LIMIT(iFirstCuringBarSlmL1, iLastCuringBarSlmL1, REAL_TO_UINT(iTotalNumSlms/2));
	
	//Activating curing led bar's SLMs
	FOR iIndexEnableSlm:=iFirstCuringBarSlmL1 TO iLastCuringBarSlmL1 DO
		xCuringLedSlms[iIndexEnableSlm] := TRUE;
	END_FOR
	
	
	///////////		L2		///////////
	//To caculate first SLM of the total curing led bar SLMs
	rFirstCuringBarSlmL2 := (UINT_TO_REAL(iCenterPosition + dataLed.Status.iCuringAreaOffsetL2)/INT_TO_REAL(iSlmWidth));
	pInteger := ADR(rInteger);
	rMantissa := modf(rFirstCuringBarSlmL2, pInteger);
	
	iFirstCuringBarSlmL2 := REAL_TO_UINT(rInteger);
	IF rMantissa > 0.0 THEN iFirstCuringBarSlmL2 := iFirstCuringBarSlmL2 + 1; END_IF
	iFirstCuringBarSlmL2 := LIMIT(iLastCuringBarSlmL1, iFirstCuringBarSlmL2, iTotalNumSlms);
	
	//To caculate last SLM of the total curing led bar SLMs
	rLastCuringBarSlmL2 := (INT_TO_REAL(iCenterPosition + dataLed.Status.iCuringAreaOffsetL2 + dataLed.Status.iCuringAreaWidth)/INT_TO_REAL(iSlmWidth));
	pInteger := ADR(rInteger);
	rMantissa := modf(rLastCuringBarSlmL2, pInteger);
	
	iLastCuringBarSlmL2 := REAL_TO_UINT(rInteger);
	IF rMantissa > 0.0 THEN iLastCuringBarSlmL2 := iLastCuringBarSlmL2 + 1; END_IF
	iLastCuringBarSlmL2 := LIMIT(iFirstCuringBarSlmL2, iLastCuringBarSlmL2, iTotalNumSlms);
	
	FOR iIndexEnableSlm:=iFirstCuringBarSlmL2 TO iLastCuringBarSlmL2 DO
		xCuringLedSlms[iIndexEnableSlm] := TRUE;
	END_FOR
	
	
	
	///////////		To enable lamps stretches		///////////
	iLastLampSLM := 0;
	FOR iIndexEnableLamps:=1 TO iLampsQuantity DO
		iNumLampSLM := dataLed.Lamp[iIndexEnableLamps].Parameters.iNumSLM; //Number of lamp's SLMs
		
		//Lamp's first SLM of array "xCuringLedSlms" which considers all SLM in the curing led bar
		iFirstLampSLM := iLastLampSLM + 1;
		iLastLampSLM := iLastLampSLM + dataLed.Lamp[iIndexEnableLamps].Parameters.iNumSLM;
		
		dataLed.Lamp[iIndexEnableLamps].Parameters.xFullActive := TRUE;
		
		
		//Calculating slm mirrored to indexSlm. So xCuringLedSlms starts counting from user side to drive side. But lamps are mechanically assemblied in a reverse way, here an image to understand:
		
		//xCuringLedSlms[x]	  1						  14  15					  28  29					  42  43					  56
		//Lamp's slm index	  14					   1  14					   1  14					   1  14					   1
							//							//							//							//							//
		//FRONT/USER SIDE//	//			1				//			2				//			3				//			4				//		//REAR/WALKWAY SIDE//
							//							//							//							//							//
							//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		FOR iIndexEnableSlm:=1 TO iNumLampSLM DO
			iMirrorSlm := iLastLampSLM - iIndexEnableSlm + 1;
			dataLed.Lamp[iIndexEnableLamps].Parameters.xSlmEnable[iIndexEnableSlm] := xCuringLedSlms[iMirrorSlm];
			
			IF (NOT dataLed.Lamp[iIndexEnableLamps].Parameters.xSlmEnable[iIndexEnableSlm]) THEN
				dataLed.Lamp[iIndexEnableLamps].Parameters.xFullActive := FALSE;
			END_IF
		END_FOR
	END_FOR
	
END_ACTION