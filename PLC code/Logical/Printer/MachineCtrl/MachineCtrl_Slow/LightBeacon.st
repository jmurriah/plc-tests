ACTION LightBeacon: 

	// Green: Started and not any alarm	
	gMachine.Out.xGreenLight:= 	gBelt.states.xRuningBelt OR
								(NOT gBelt.states.xRuningBelt AND gMachine.St.AutoMode.xPause AND gPLC.xBlk_500ms);
	
	// Red: Started and critical alarm
	gMachine.Out.xRedLight:= 	gMachine.AlSummary.xAlarmCritical OR 
								(gMachine.AlSummary.xAlarmStop AND gPLC.xBlk_500ms) OR
								(xAnyInkCriticalAlrm AND gPLC.xBlk_2s);
	
	// Yellow: Started and stop alarm
	gMachine.Out.xYellowLight:= gMachine.AlSummary.xAnyWarning;

	////////////////////////////
	// LIGHT RESET	
	////////////////////////////
	gMachine.Out.xLightReset:= gMachine.AutoCmd.xReset;
	
		
END_ACTION

ACTION RgbLigths:
	
	//As just one color may be activated at the same time, we need to priorize color code
	ResetRgbColors;
	IF gSafetyController.Inputs.xPrinterMaintenanceKey THEN
		xRedLight := gPLC.xBlk_200ms;		
	ELSIF gSafetyController.Alarms.xCriticalAlarm THEN
		xRedLight := TRUE;
	ELSIF gMachine.AlSummary.xAlarmCritical OR gMachine.AlSummary.xAlarmStop THEN
		xYellowLight := gPLC.xBlk_1s;
	ELSIF gMachine.St.Mode.xAuto THEN
		xWhiteLight:= gMachine.St.Mode.xAuto;
	ELSIF gMachine.AlSummary.xAnyWarning THEN
		xYellowLight := TRUE;
	END_IF

	//Conversion to RGB
	gMachine.Out.xGreenLight := xYellowLight OR xGreenLight;
	gMachine.Out.xRedLight := xYellowLight OR xRedLight;
	gMachine.Out.xBlueLight := xBlueLight;
	gMachine.Out.xWhiteLight := xWhiteLight;
		
END_ACTION

ACTION ResetRgbColors:
	xGreenLight := FALSE;
	xRedLight := FALSE;
	xBlueLight := FALSE;
	xWhiteLight := FALSE;
	xYellowLight := FALSE;
END_ACTION
