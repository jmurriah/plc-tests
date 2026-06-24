
ACTION AlarmsSlow: 

	// Alarm: Platform Incoherence 
	gDryer.Al.Alarm.xAlarmPlarformInc:= (gDryer.Pt.MachineModel=DryerNoType) AND NOT gDryer.St.Mode.xZero;
	
	gDryer.Al.Alarm.xNoActionDangerCollision := FALSE;
	
	
	// Warning: Max movemets because bent tile	// Warning: Max movemets because bent tile		
	// Warning: Max movemets because bent tile	// Warning: Max movemets because bent tile		
	IF EDGEPOS (gDryer.Al.Warning.xBentMedia) THEN
		iBentMediaCounter := iBentMediaCounter + 1;
	END_IF	

	//If time without any change, decrease the count of movements
	tonDecreaseMovCount.IN := NOT gDryer.Al.Warning.xMaxMovsBentTile AND NOT gDryer.Al.Warning.xBentMedia AND NOT tonDecreaseMovCount.Q ;
	tonDecreaseMovCount.PT := T#5m;
	tonDecreaseMovCount();
	IF tonDecreaseMovCount.Q THEN
		//Safety decrease to avoid overflow
		iBentMediaCounter:= UINT_SUB(iBentMediaCounter,1);
	END_IF
	IF EDGEPOS(gDryer.Al.Warning.xMaxMovsBentTile) THEN
		iBentMediaCounter:= 0;
	END_IF

	IF 	iBentMediaCounter >= gc_diNumMaxManiobrasPDoblada THEN 
		gDryer.Al.Warning.xMaxMovsBentTile:=TRUE; 
	ELSIF  gDryer.AutoCmd.xReset THEN
		gDryer.Al.Warning.xMaxMovsBentTile:=FALSE; 
	END_IF	


	// Raising alarm of stopped media inside.
	// this is a simple way to reset the alarm. A more proper way to remove the alarm would be to
	// use a distanceVar in Thickness_Pos, but this is quite resource consuming, so this would be delayed
	IF gThicknessCtrl.status.MediaPosition.xMediaInside AND EDGENEG(gBelt.states.xRuningBelt) THEN
		gDryer.Al.Warning.xMediaStoppedInside := TRUE;
	ELSIF gThicknessCtrl.status.Belt.xBeltEmpty THEN
		gDryer.Al.Warning.xMediaStoppedInside := FALSE;
	END_IF
	
	//Sensors errors
	IF gDryer.In.Temp.xBeltSensorError THEN
		gDryer.Al.Warning.xBeltSensorError := TRUE;
	END_IF
	
	IF gDryer.In.Temp.xBoardInSensorError THEN
		gDryer.Al.Warning.xBoardInSensorError := TRUE;
	END_IF
	
	IF gDryer.In.Temp.xBoardOutSensorError THEN
		gDryer.Al.Warning.xBoardOutSensorError := TRUE;
	END_IF
	
	IF gDryer.In.Temp.xAirBlowerInputSensorError THEN
		gDryer.Al.Warning.xAirBlowerInputSensorError := TRUE;
	END_IF
	
	IF gDryer.In.Temp.xAirBlowerInputSensorError THEN
		gDryer.Al.Warning.xAirBlowerOutputSensorError := TRUE;
	END_IF
		
	//BELT ALARMS
	tonBeltOvertorque.IN := gBelt.states.rCurrentTorque > gDryer.Pt.CT.rMaxBeltTorque;
	tonBeltOvertorque.PT := t#120s;
	tonBeltOvertorque();
	IF tonBeltOvertorque.Q THEN
		gDryer.Al.Alarm.xAlrBeltOvertorque := TRUE;
	END_IF
	
	tonBeltOverTempFast.IN := gDryer.St.Temp.rBelt > gDryer.Pt.CT.rMaxBeltTempFast;
	tonBeltOverTempFast.PT := t#2s;
	tonBeltOverTempFast();	
	IF tonBeltOverTempFast.Q THEN
		gDryer.Al.Alarm.xAlrBeltOverTempFast := TRUE;
	END_IF

	tonBeltOverTempSlow.IN := gDryer.St.Temp.rBelt > gDryer.Pt.CT.rMaxBeltTempSlow;
	tonBeltOverTempSlow.PT := t#30s;
	tonBeltOverTempSlow();	
	IF tonBeltOverTempSlow.Q THEN
		gDryer.Al.Alarm.xAlrBeltOverTempSlow := TRUE;
	END_IF

	IF gJamDetect[1].Alarms.xAlrJamLowCrash THEN
		gDryer.Al.Warning.xJamLowCrash := TRUE;
	END_IF
	
	
	PsycallConfChecking;
	
END_ACTION


ACTION PsycallConfChecking:
	CASE gDryer.Pt.ConfigNameID OF
		GC_CONFIG_DRYER_NOZ2_ID:
			CASE gDryer.Pt.MachineModel OF
				DryerType_NOZ2_NIR,
				DryerType_NOZ2_NIR_ARCLAMP:
					plcCardsOK.0 := NOT X20DIF371_201.ModuleOk;
					plcCardsOK.1 := NOT X20DIF371_202.ModuleOk;
					plcCardsOK.2 := NOT X20DIF371_203.ModuleOk;
					//plcCardsOK.3 := NOT X20PS3300_204.ModuleOk;
					plcCardsOK.4 := NOT X20DOF322_205.ModuleOk;
					plcCardsOK.5 := NOT X20DOF322_206.ModuleOk;
					plcCardsOK.6 := NOT X20AI8321_207.ModuleOk;
					plcCardsOK.7 := NOT X20AO4622_208.ModuleOk;
					plcCardsOK.8 := NOT X20AT4222_209.ModuleOk;
					gDryer.Al.Alarm.xAlrWrongPhysConf := plcCardsOK>0;
										
				ELSE
					gDryer.Al.Alarm.xAlrWrongPhysConf := TRUE;
			END_CASE

		GC_CONFIG_SIMDRYER_NOZ2_ID:
			gDryer.Al.Alarm.xAlrWrongPhysConf := FALSE;
			
		ELSE
	
			gDryer.Al.Alarm.xAlrWrongPhysConf := TRUE;
	
	END_CASE
	
END_ACTION