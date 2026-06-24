
PROGRAM _CYCLIC
	
	// Assigning dataChillConfig to determine the Configuration of the Chilled and the Chiller Type
	dataChill ACCESS ADR (gChiller[iIndexChiller]);
	
	
	// Currently we do not have any confirmation the chiller is installed
	dataChill.St.xInstalled := dataChill.Parameters.xInstalled;
	
	dataChill.St.xEnabled := dataChill.parSw.xEnable OR dataChill.Parameters.xEnable;
	
	IF NOT dataChill.St.xInstalled OR NOT dataChill.St.xEnabled THEN
		ResetAlarms;
		iIndexChiller:= iIndexChiller +1;
		RETURN;
	END_IF	
	
	
	Conversions;
	StateCtrl;
	alarms;
	alarmsSound;
	alarmsSummary;
	
	
	iIndexChiller := iIndexChiller + 1;
	
END_PROGRAM
