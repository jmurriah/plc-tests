PROGRAM _INIT
	RTInfo_0(enable :=TRUE );
	rPeriode:= UDINT_TO_REAL (RTInfo_0.cycle_time)/1000;  // Cycle time in microseconds
	iPeriode := REAL_TO_UINT(rPeriode);
END_PROGRAM


PROGRAM _CYCLIC

	//Reference working data to the general data
	inks ACCESS ADR(gInks[gIndexInks]);
	parBar ACCESS ADR(inks.parameters.parBar);

	inks.status.xBarInstalled:=inks.parSw.Config.iMappingBar >= 1 AND inks.parSw.Config.iMappingBar <= MAX_LAST_INK ;

	//IMPORTANT: In printHeadData MUST be referenced the parBar (in Permanent Variable)
	IF NOT inks.status.xBarInstalled THEN
		inks.Al:=resetedAlarms;
		inks.AlSummary:=resetedAlarmsSummary;
		inks.status:=resetedStatus;
		inks.signals.out:=resetedOut;
		gIndexInks := gIndexInks + 1; //Point to the next Bar
		RETURN;
	END_IF
	
	//Reset all alarms if error reset received
	IF inks.commands.xErrorRst THEN
		inks.Al:=resetedAlarms;
	END_IF
	
	safetyPre;
	
	inkLevel;
	controlMode;
	conversionsPre;
	calculations;
	dripControl;

	startUp;
	
	reservoirMode;

	pressureControl;
	tempControl;
	solenoids;

	conversionsPost;
	powPrintHeads;
	alarms;
	alarmsSummary;
	alarmsSound;

	
	iTimesExecuted:=iTimesExecuted+1;

	gIndexInks := gIndexInks + 1; //Point to the next Bar
	
END_PROGRAM

