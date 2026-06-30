ACTION LightBeacon: 

	
	// Red: Safety related alarm
	iReasonRedLight.0 := gDryer.AlSummary.xAlrSafetySystemGeneral;
	gDryer.Out.xRedLight := iReasonRedLight>0;
	
	// Yellow Blinking: stop or critical alarm
	iReasonBlinkYellowLight.0 := gDryer.AlSummary.xAlarmCritical;
	iReasonBlinkYellowLight.1 := gDryer.AlSummary.xAlarmStop;
	// Yellow Solid: warning
	iReasonSolidYellowLight.0 := gDryer.AlSummary.xAnyWarning;
	
	IF (iReasonBlinkYellowLight > 0) THEN
		gDryer.Out.xYellowLight := gPLC.xBlk_1s;
	ELSIF (iReasonSolidYellowLight > 0) THEN
		gDryer.Out.xYellowLight := TRUE;
	ELSE
		gDryer.Out.xYellowLight := FALSE;
	END_IF
	
	// Blue: Any alarm may be reset
	iReasonBlueLight.0 := (NOT gDryer.AlSummary.xAlarmCritical) AND (gDryer.AlSummary.iReasonCritical > 0);
	iReasonBlueLight.1 := (NOT gDryer.AlSummary.xAlarmStop) AND (gDryer.AlSummary.iReasonStop[0] > 0);
	iReasonBlueLight.2 := (NOT gDryer.Al.xAlrStopDrying) AND (gDryer.Al.iReasonStopDrying > 0);
	gDryer.Out.xBlueLight := iReasonBlueLight > 0;

	// White: Automatic and remote mode	
	iReasonWhiteLight.0 := gDryer.St.AutoLocation.xRemote; //NOZDRYER-381
	gDryer.Out.xWhiteLight := iReasonWhiteLight > 0;

	////////////////////////////
	// LIGHT RESET	
	////////////////////////////
	gDryer.Out.xLightReset:= gDryer.AutoCmd.xReset;
	
		
END_ACTION
