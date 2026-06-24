
ACTION Outputs: 

	//	Digital signals activated in the machine state
	
	// 100m/min correspond to 10v
	data.Signals.Out.iBeltSpeed:=REAL_TO_INT(data.Parameters.rBeltSpeed * 32766 / 133.0 ); //10V correspond to 32766units
	data.Parameters.Comms.WebWidth := data.Parameters.MediaWidth + MAX(data.Parameters.iExtraDryingWidh, 0);
	
	
	iReasonToStop.0 := data.Alarms.xAnyJam;
	iReasonToStop.1 := data.Commands.xExternalSafetyStop;
	iReasonToStop.2 := CurrentState = NIRADPEW_RUNNING AND NOT data.Parameters.xBeltRunning;
	data.Signals.Out.xSafetyStop := iReasonToStop=0; //FALSE to Stop	
	
	iReasonToProcess.0 := CurrentState = NIRADPEW_STARTING;
	iReasonToProcess.1 := CurrentState = NIRADPEW_RUNNING;
	data.Signals.Out.xProcess := iReasonToProcess > 0 AND data.Commands.xMediaInside;
	
	tonWatchdog.IN:= NOT tonWatchdog.Q;
	tonWatchdog.PT:= T#1s;
	tonWatchdog();
	IF tonWatchdog.Q THEN
		data.Signals.Out.xWatchDog := NOT data.Signals.Out.xWatchDog;
	END_IF
	
	AdjustMinIntensityDDC;
	
	ApplyLampsExtendNir1;
	ApplyLampsExtendNir2;
	
END_ACTION

ACTION AdjustMinIntensityDDC:

	IF NOT data.Status.xEnabledDDC THEN
		RETURN;
	END_IF
	
	// Protecting for 0 values
	IF data.Status.rPowerSetPoint > 0.1 THEN
		data.Status.iMinPower := MIN(REAL_TO_INT(data.Parameters.DDC.rMinIntensityPercentage / (data.Status.rPowerSetPoint/100.0)), 100);
	ELSE
		data.Status.iMinPower := 0;
	END_IF

END_ACTION

ACTION ApplyLampsExtendNir1:

	IF data.Parameters.DDC.pIntensityNir1 = 0 THEN RETURN; END_IF

	// Assigning data to enable send it to the NIR
	Intensity_Nir1 ACCESS data.Parameters.DDC.pIntensityNir1;

	IF Intensity_Nir1[10] <= 20 THEN
		RETURN;
	END_IF
	
	IntensityExtend_Nir1 := IntensityReseted_Nir1;
	
	FOR iIndex_Nir1:=1 TO MIN(THICKENERGY_MAX_LAMPS, data.Parameters.DDC.iLamps) DO
		FOR iIndexExtend_Nir1:= SINT_TO_USINT(MAX(0, USINT_TO_SINT(iIndex_Nir1 - data.Parameters.DDC.iLampsExtend))) TO MIN(THICKENERGY_MAX_LAMPS, iIndex_Nir1 + data.Parameters.DDC.iLampsExtend) DO
			IntensityExtend_Nir1[iIndex_Nir1] := MAX(IntensityExtend_Nir1[iIndex_Nir1], Intensity_Nir1[iIndexExtend_Nir1]);
		END_FOR
	END_FOR
	
	// Assigning data to the final array
	FOR iIndex_Nir1:=1 TO MIN(THICKENERGY_MAX_LAMPS, data.Parameters.DDC.iLamps) DO
		Intensity_Nir1[iIndex_Nir1] := IntensityExtend_Nir1[iIndex_Nir1];
	END_FOR

END_ACTION

ACTION ApplyLampsExtendNir2:

	IF data.Parameters.DDC.pIntensityNir2 = 0 THEN RETURN; END_IF

	// Assigning data to enable send it to the NIR
	Intensity_Nir2 ACCESS data.Parameters.DDC.pIntensityNir2;

	IF Intensity_Nir2[10] <= 20 THEN
		RETURN;
	END_IF
	
	IntensityExtend_Nir2 := IntensityReseted_Nir2;
	
	FOR iIndex_Nir2:=1 TO MIN(THICKENERGY_MAX_LAMPS, data.Parameters.DDC.iLamps) DO
		FOR iIndexExtend_Nir2:= SINT_TO_USINT(MAX(0, USINT_TO_SINT(iIndex_Nir2 - data.Parameters.DDC.iLampsExtend))) TO MIN(THICKENERGY_MAX_LAMPS, iIndex_Nir2 + data.Parameters.DDC.iLampsExtend) DO
			IntensityExtend_Nir2[iIndex_Nir2] := MAX(IntensityExtend_Nir2[iIndex_Nir2], Intensity_Nir2[iIndexExtend_Nir2]);
		END_FOR
	END_FOR
	
	// Assigning data to the final array
	FOR iIndex_Nir2:=1 TO MIN(THICKENERGY_MAX_LAMPS, data.Parameters.DDC.iLamps) DO
		Intensity_Nir2[iIndex_Nir2] := IntensityExtend_Nir2[iIndex_Nir2];
	END_FOR

END_ACTION