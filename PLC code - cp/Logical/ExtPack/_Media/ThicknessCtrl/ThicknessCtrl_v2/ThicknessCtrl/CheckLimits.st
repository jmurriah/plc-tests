
ACTION CheckLimits: 

	dataHeigh.status.Heigh.rMediaHeigh := UINT_TO_REAL(dataHeigh.status.Heigh.iMediaHeigh) / 100;
	iMediaHeight:= dataHeigh.status.Heigh.iMediaHeigh;

	iTotalSections := LIMIT(1, dataHeigh.parameters.iSections ,TOTAL_THICKNESS_SECTIONS);

	iTotalBlocksLengh := LIMIT(100, dataHeigh.parameters.iTotalBlocksLengh, iMAXHEIGHTARRAY);
	
	iRejectLengthAdjustment := LIMIT(100, dataHeigh.parameters.Belt.iDistanceEmptyBeltIni + dataHeigh.parameters.Reject.iRejectDistance, iMAXTRACKINGARRAY);
	iHoldRejectLengthAdjustment := LIMIT(100, dataHeigh.parameters.Belt.iDistanceEmptyBeltIni + dataHeigh.parameters.Reject.iHoldRejectDistance, iMAXTRACKINGARRAY);
	iMaxTrackingPosition := MAX(iRejectLengthAdjustment, iHoldRejectLengthAdjustment);
	FOR iIndexCheck:=1 TO MAX_LAST_CHECKMEDIA DO
		IF dataHeigh.parameters.CheckMedia[iIndexCheck].xActive THEN
			iMaxTrackingPosition := MAX(iMaxTrackingPosition, dataHeigh.parameters.CheckMedia[iIndexCheck].CheckPosition + dataHeigh.parameters.CheckMedia[iIndexCheck].CheckDelayPosition);
		END_IF
	END_FOR
	
	rMinBeltSpeedToStart := MAX(dataHeigh.parameters.Belt.rMinBeltSpeedToStart, 1.0);
	
	dataHeigh.Internal.rMarginSafePrintChecked := MAX(dataHeigh.parameters.rMarginSafePrint, 1.0); //The minimum Margin Safe print is 1mm

	iProductDetectSensorPosition := MIN(dataHeigh.parameters.Detection.ProductDetect.iSensorPosition, iMAXMEDIAPRESENTARRAY);
	iArraySensorPosition := MIN(dataHeigh.parameters.Detection.Array.iSensorPosition, iMAXMEDIAPRESENTARRAY);
	iAnalogSensorPosition := MIN(dataHeigh.parameters.Detection.Analog.iSensorPosition, iMAXMEDIAPRESENTARRAY);
	iDetectionMediaSensorPosition := MIN(dataHeigh.parameters.Detection.Basic.iSensorPosition, iMAXMEDIAPRESENTARRAY);
	iMediaFilter := MIN(dataHeigh.parameters.Detection.ProductDetect.iMediaFilter, 30);

	dataHeigh.parameters.Dry.rDryExtend := LIMIT(0,dataHeigh.parameters.Dry.rDryExtend, 100);
	
	//Limits for the array used with them
	iLastPosition := MAX(iTotalBlocksLengh, dataHeigh.parameters.Cure.White.iEndWindow, dataHeigh.parameters.Cure.Color.iEndWindow);
	iLastPosition := LIMIT(1, iLastPosition, iMAXTRACKINGARRAY);
	
END_ACTION
