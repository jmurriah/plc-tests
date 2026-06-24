
ACTION StatusSw: 
	CASE Line.Status OF
		LINE_NOT_POWERED: Line.StatusSw:= 999;
		LINE_POWERING_OFF: Line.StatusSw:= 60;
		LINE_ERROR:	Line.StatusSw:= 2;
		LINE_PREPARING_EMPTYBELT: Line.StatusSw:= 20;
		LINE_PREPARING_PRINT: Line.StatusSw:= 30;
		LINE_PREPARING_CLEANPH: Line.StatusSw:= 40;
		LINE_PREPARING_CLEANBELT: Line.StatusSw:= 70;
		LINE_STARTING_PRINTING: Line.StatusSw:= 31;
		LINE_STARTING_CLEANINGPH: Line.StatusSw:= 41;
		LINE_STARTING_CLEANINGBELT: Line.StatusSw:= 71;
		LINE_BELT_EMPTYING:	Line.StatusSw:= 22;
		LINE_CLEANED:	Line.StatusSw:= 43;
		LINE_STARTING_EMPTYBELT: Line.StatusSw:= 21;
		LINE_IDLE:	Line.StatusSw:= 11;
		LINE_PRINTING:	Line.StatusSw:= 32;
		LINE_PAUSING:	Line.StatusSw:= 33;
		LINE_PAUSED:	Line.StatusSw:= 34;
		LINE_CLEANINGPH:	Line.StatusSw:= 42;
		LINE_CLEANINGBELT:	Line.StatusSw:= 72;
		LINE_CONTROLLED_STOP:	Line.StatusSw:= 50;
		LINE_STOPPED:	Line.StatusSw:= 10;
		LINE_NOT_INITIALIZED:	Line.StatusSw:= 0;
		LINE_INITIALIZING:	Line.StatusSw:= 5;
	END_CASE
	
END_ACTION
