
PROGRAM _CYCLIC
	(* Insert code here *)
	
	gInksConstants.tiDripTimeMin:=0;
	gInksConstants.tiDripTimeMax:=INKS_DRIP_TIME_MAX;
	
	// Assing inputs. FAST and all times
	FOR iIndexInksIn:=1 TO MAX_LAST_INK DO

		//Reference working data to the general data
		dataInksInput ACCESS ADR(gInks[iIndexInksIn]);
	
		IF dataInksInput.parSw.Config.iMappingBar >= 1 AND dataInksInput.parSw.Config.iMappingBar <= MAX_LAST_INK THEN
			dataInksInput.signals.in := gInksInputs[dataInksInput.parSw.Config.iMappingBar];
		END_IF		
		
		dataInksInput.commands.xMute:=gMachine.AutoCmd.xMuteAlarms;
		dataInksInput.commands.xErrorRst:=gMachine.AutoCmd.xReset;		
		
	END_FOR

	//Assign printHead data. This will be slower to avoid resources. One Ink System each scan cycle
	InksDataAssignation;
	
	//To allow watch the variable in the watch window
	gInksInputs; 
	
	// Copy InkValued to debug to easy finding new values
	FOR iIndexInksIn:=1 TO MAX_LAST_INK DO

		//Reference working data to the general data
		dataInksInput ACCESS ADR(gInks[iIndexInksIn]);
		
		// If entering in DebugMode and the values of gInksPermanentParBar are empty (with paramsPidMeniscus.rKp = 0, impossible) copy values from current to Permanent
		IF copyInkParamsToDebug[iIndexInksIn] OR (dataInksInput.parameters.xDebugMode AND NOT inksDebugMode_copy[iIndexInksIn] AND gInksPermanentParBar[iIndexInksIn].paramsPidMeniscus.rKp = 0 ) THEN
			gInksPermanentParBar[iIndexInksIn] := dataInksInput.parameters.parBar;
			copyInkParamsToDebug[iIndexInksIn] := FALSE;
		END_IF
		
		inksDebugMode_copy[iIndexInksIn] := dataInksInput.parameters.xDebugMode;
		
	END_FOR
	
END_PROGRAM