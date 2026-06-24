
ACTION MpViewAlarms:
	
	AlarmsCore.Enable := TRUE;
	AlarmsCore.MpLink := ADR(gAlrCore);
	AlarmsCore();
	
	AlarmsHistory.Enable := TRUE;
	AlarmsHistory.MpLink := ADR(gAlrHist);
	AlarmsHistory();
	
END_ACTION
