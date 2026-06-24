
ACTION ReviewDryActivation:

	// Limit the value configured relative to power reductions
	rSubstratePowerReduction := LIMIT(0.3 , dataHeigh.parameters.Dry.rSubstratePowerReduction, 1);
	rThermalInerciaReduction := LIMIT(0.6 , dataHeigh.parameters.Dry.rThermalInerciaReduction, 1);
	rPowerReduction := rSubstratePowerReduction * rThermalInerciaReduction;
	
	iDistanceDelay := REAL_TO_UINT(dataHeigh.parameters.Dry.rCommsDelay * dataHeigh.parameters.Belt.rBeltSpeed / 600.0);
	iDistanceWindow := REAL_TO_UINT((dataHeigh.parameters.Dry.rThermalDelay + dataHeigh.parameters.Dry.rCommsDelay) * dataHeigh.parameters.Belt.rBeltSpeed / 600.0);

	// IntensityPower for Lamps in L1
	FOR iIndexDryer := 1 TO MAX_LAST_NIR_MODULES DO
			
		DryerInfo ACCESS ADR(dataHeigh.parameters.Dry.Dryers[iIndexDryer]);
		
		iEndCuringWindow := LIMIT(1, DryerInfo.iPosition - iDistanceDelay, iMAXTRACKINGARRAY);
		// Assure the start window remains in positive values
		iStartCuringWindow := UINT_TO_INT(iEndCuringWindow) - UINT_TO_INT(iDistanceWindow);


		RevMediaTrackingEnergyInPos(ADR(MediaTrackingInsideL1),
										MediaTracking_iTotalInsideL1,
										iStartCuringWindow,
										iEndCuringWindow,
										dataHeigh.parameters.Dry.iLamps,
										dataHeigh.parameters.Dry.rLampWidth,
										dataHeigh.parameters.Dry.rLampOffset,
										dataHeigh.parameters.Dry.rDryExtend,
										dataHeigh.parameters.Dry.iMinDryValue,
										dataHeigh.status.MediaPosition.L1.NirDryer[iIndexDryer].Intensity);
	END_FOR
	
	// If simple line, assign L1 to total and return
	IF NOT dataHeigh.parameters.xDoubleLine THEN
		dataHeigh.status.Dry[1].Intensity := dataHeigh.status.MediaPosition.L1.NirDryer[1].Intensity;
		dataHeigh.status.Dry[2].Intensity := dataHeigh.status.MediaPosition.L1.NirDryer[2].Intensity;
		RETURN;
	END_IF
	
	// IntensityPower for Lamps in L2
	FOR iIndexDryer := 1 TO MAX_LAST_NIR_MODULES DO
			
		DryerInfo ACCESS ADR(dataHeigh.parameters.Dry.Dryers[iIndexDryer]);
		
		iEndCuringWindow := LIMIT(1, DryerInfo.iPosition - iDistanceDelay, iMAXTRACKINGARRAY);
		iStartCuringWindow := LIMIT(1, iEndCuringWindow - iDistanceDelay, iMAXTRACKINGARRAY);
		
		RevMediaTrackingEnergyInPos(ADR(MediaTrackingInsideL2),
										MediaTracking_iTotalInsideL2,
										iStartCuringWindow,
										iEndCuringWindow,
										dataHeigh.parameters.Dry.iLamps,
										dataHeigh.parameters.Dry.rLampWidth,
										dataHeigh.parameters.Dry.rLampOffset,
										dataHeigh.parameters.Dry.rDryExtend,
										dataHeigh.parameters.Dry.iMinDryValue,
										dataHeigh.status.MediaPosition.L2.NirDryer[iIndexDryer].Intensity);
	END_FOR	
	
	// Assigning data from each line to the Intensity status of each dryer
	FOR iIndexArray := 1 TO THICKENERGY_MAX_LAMPS DO
		dataHeigh.status.Dry[1].Intensity[iIndexArray] := REAL_TO_INT( rPowerReduction * MAX(dataHeigh.status.MediaPosition.L1.NirDryer[1].Intensity[iIndexArray], dataHeigh.status.MediaPosition.L2.NirDryer[1].Intensity[iIndexArray]) );
		dataHeigh.status.Dry[2].Intensity[iIndexArray] := REAL_TO_INT( rPowerReduction * MAX(dataHeigh.status.MediaPosition.L1.NirDryer[2].Intensity[iIndexArray], dataHeigh.status.MediaPosition.L2.NirDryer[2].Intensity[iIndexArray]) );
	END_FOR
	
END_ACTION

// Calling outside the running belt code
ACTION ReviewDryManual:

	// Temporaty while DDC dynamic is not active
	IF EDGEPOS(dataHeigh.parameters.AutoMode.xProduction) THEN
		dataHeigh.parSw.Dry.xGetMaxFromFileInfo := TRUE;
	END_IF
	
	IF EDGEPOS(dataHeigh.parSw.Dry.xGetMaxFromFileInfo) THEN
		FOR iIndexArray := 1 TO THICKENERGY_MAX_LAMPS DO
			MaxLampIntensityL1[iIndexArray] := 0;
			MaxLampIntensityL2[iIndexArray] := 0;
		END_FOR
	END_IF
	// Calculating the max of the file information
	IF dataHeigh.parSw.Dry.xGetMaxFromFileInfo THEN
		FOR iIndexArray := 1 TO THICKENERGY_MAX_LAMPS DO
			MaxLampIntensityL1[iIndexArray] := MAX(MaxLampIntensityL1[iIndexArray] , dataHeigh.status.MediaPosition.L1.NirDryer[1].Intensity[iIndexArray], dataHeigh.parameters.Dry.iMinDryValue);
			MaxLampIntensityL2[iIndexArray] := MAX(MaxLampIntensityL2[iIndexArray] , dataHeigh.status.MediaPosition.L1.NirDryer[2].Intensity[iIndexArray], dataHeigh.parameters.Dry.iMinDryValue);
		END_FOR
	END_IF
		
	IF dataHeigh.parSw.Dry.xGetMaxFromFileInfo AND (xExitingMediaL1 OR EDGEPOS(dataHeigh.status.Belt.xBeltEmpty)) THEN
		dataHeigh.parSw.Dry.ManIntensity[1].Intensity := MaxLampIntensityL1;
		dataHeigh.parSw.Dry.ManIntensity[2].Intensity := MaxLampIntensityL2;
		dataHeigh.parSw.Dry.xGetMaxFromFileInfo := FALSE;
	END_IF
		
	IF dataHeigh.parSw.Dry.xForceManIntensity THEN
		dataHeigh.status.Dry := dataHeigh.parSw.Dry.ManIntensity;
	END_IF
	
END_ACTION