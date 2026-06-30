
PROGRAM _INIT
	 
	//This is to assure raise alarms started with TRUE
	MpViewAlarms;
	Alarms;
	
	iInkHMI_copy := 0;
END_PROGRAM

PROGRAM _CYCLIC

	// Pointer assignation and avoid out of range. 1 is the default one
	IF iInkHMI >= 1 AND iInkHMI <= MAX_LAST_INK THEN
		dataInksHMI ACCESS ADR(gInks[iInkHMI]);

		// Take the string value when changing system
		IF iInkHMI <> iInkHMI_copy THEN
			brsitoa(INT_TO_DINT(dataInksHMI.parSw.Config.iInkType), ADR(strInkType));
			brsitoa(INT_TO_DINT(dataInksHMI.parSw.Config.iPrintHeadType), ADR(strPrintHeadType));
		END_IF

		// Update value
		dataInksHMI.parSw.Config.iInkType := DINT_TO_INT(brsatoi(ADR(strInkType)));
		dataInksHMI.parSw.Config.iPrintHeadType := DINT_TO_INT(brsatoi(ADR(strPrintHeadType)));

		iInkHMI_copy := iInkHMI;
	ELSE
		iInkHMI := 1;
	END_IF
	
	
	MpViewAlarms;
	
	Alarms;
	
END_PROGRAM

PROGRAM _EXIT
	
	//Cards of the Ink Box
	X20DIF371_101;
	X20AI4322_102;
	X20AT2222_103;
	X20DOF322_104;
	X20AO4622_105;

	X20DIF371_201;
	X20AI4322_202;
	X20AT2222_203;
	X20DOF322_204;
	X20AO4622_205;

	X20DIF371_301;
	X20AI4322_302;
	X20AT2222_303;
	X20DOF322_304;
	X20AO4622_305;
	
END_PROGRAM

