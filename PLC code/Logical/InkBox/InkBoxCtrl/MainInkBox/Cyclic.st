PROGRAM _INIT

	VersionPLC;

	PLC_Init(ADR(gPLC));

	//Limit values for all possible Cabinets
	FOR iCabinet := 1 TO MAX_LAST_INK_CABINET DO
		gInkBox.Parameters.Cabinets[iCabinet].TotalInkSystems := MAX(2, gInkBox.Parameters.Cabinets[iCabinet].TotalInkSystems);
		gInkBox.Parameters.Cabinets[iCabinet].TotalInksPerPsu := MAX(1, gInkBox.Parameters.Cabinets[iCabinet].TotalInksPerPsu);
		gInkBox.Parameters.Cabinets[iCabinet].MaxTempPowerPsu := MAX(100, gInkBox.Parameters.Cabinets[iCabinet].MaxTempPowerPsu);
	END_FOR;

	FOR iIndex:=1 TO MAX_LAST_INK DO

		//Reference working data to the general data
		dataInksInput ACCESS ADR(gInks[iIndex]);

		IF dataInksInput.parSw.Config.iInkType <= 0 THEN
			dataInksInput.parSw.Config.iInkType:=lc_iInkMineral;
		END_IF
		IF dataInksInput.parSw.Config.iPrintHeadType <= 0 THEN
			dataInksInput.parSw.Config.iPrintHeadType:=lc_iPrintHeadSK1536;
		END_IF

		printHeadData_Nozomi2;		

		dataInksInput.parameters.Temp.iBarsWithSamePsu := 1;
		
		dataInksInput.parSw.xEnabledBarToPrint := TRUE;

		dataInksInput.parSw.Config.iMappingBar := iIndex;

		dataInksInput.parSw.NegPump.rLowerLimMeniscusCritical := -120;
		dataInksInput.parSw.NegPump.rUpperLimMeniscusCritical := 70.0;
		
//		IF dataInksInput.parSw.PosPump.rSetPoint = 0 THEN
//			dataInksInput.parSw.PosPump.rSetPoint := 7.0;
//		END_IF
//		IF dataInksInput.parSw.NegPump.rSetPointMeniscus = 0 THEN
//			dataInksInput.parSw.NegPump.rSetPointMeniscus := 24;
//		END_IF
		IF dataInksInput.parSw.tiDripTime = 0 THEN
			dataInksInput.parSw.tiDripTime := MILLISECONDS_TO_TIME(300*iIndex);
		END_IF

		dataInksInput.signals.in.xPrintHeadsPsuOK := TRUE;

	END_FOR;

END_PROGRAM

PROGRAM _CYCLIC

	InternalPLC;
	
	//At least 1 cabinet
	gInkBox.Parameters.TotalCabinets := MAX(1, gInkBox.Parameters.TotalCabinets);
	
	FOR iCabinet := 1 TO MAX_LAST_INK_CABINET DO
		rTotalInksInCabinet := USINT_TO_REAL(gInkBox.Parameters.Cabinets[iCabinet].TotalInkSystems);
		rTotalInksInCabinet := 2 * brmceil(rTotalInksInCabinet/2);
		gInkBox.Parameters.Cabinets[iCabinet].TotalInkSystems := MAX(2, REAL_TO_USINT(rTotalInksInCabinet));
		
		gInkBox.Parameters.Cabinets[iCabinet].MaxTempPowerPsu := MAX(100, gInkBox.Parameters.Cabinets[iCabinet].MaxTempPowerPsu);
		
		gInkBox.Status.Cabinets[iCabinet].xExists := iCabinet <= gInkBox.Parameters.TotalCabinets;
	END_FOR
	
	iCabinet := 1;
	iInksInCabinet := 1;
	FOR iIndex:=1 TO MAX_LAST_INK DO

		//Reference working data to the general data
		dataInksInput ACCESS ADR(gInks[iIndex]);

		//If the bar system do not exist, assign an imposible mapping bar to consider uninstalled and remove alarms
		IF iIndex > gInkBox.Status.iTotalInks THEN
			dataInksInput.parSw.Config.iMappingBar := -1;
		ELSE
			dataInksInput.parSw.Config.iMappingBar := iIndex;
		END_IF
		
		IF dataInksInput.parSw.Config.iInkType <= 0 THEN
			dataInksInput.parSw.Config.iInkType:=lc_iInkMineral;
		END_IF
		IF dataInksInput.parSw.Config.iPrintHeadType <= 0 THEN
			dataInksInput.parSw.Config.iPrintHeadType:=lc_iPrintHeadSK1536;
		END_IF

		//Assign current data to working data
		dataInksInParams := dataInksInput.parameters;

		printHeadData;

		//Assign working data to Ink parameters
		dataInksInput.parameters := dataInksInParams;
		
		dataInksInput.parameters.Temp.iBarsWithSameBlock := gInkBox.Parameters.Cabinets[iCabinet].TotalInkSystems;
		dataInksInput.parameters.Temp.iBarsWithSamePsu := gInkBox.Parameters.Cabinets[iCabinet].TotalInksPerPsu;
		
		dataInksInput.commands.xErrorRst := gInkBox.Commands.xReset;
		dataInksInput.commands.xMute := gInkBox.Commands.xMute;
		
		//Go to next Ink System
		iInksInCabinet := iInksInCabinet + 1;
		IF iInksInCabinet > gInkBox.Parameters.Cabinets[iCabinet].TotalInkSystems THEN
			iInksInCabinet := 1;
			iCabinet := iCabinet + 1;
		END_IF
		
	END_FOR

	//Calculate Power per Cabinet
	iInkIndex := 1; //Incremented just in existing cabinets
	xaExistingInks := xaExistingInksReseted;
	FOR iCabinet := 1 TO MAX_LAST_INK_CABINET DO
		CalculatePowerPerCabinet;
	END_FOR	
	gInkBox.Status.iTotalInks := iInkIndex -1;
	gInkBox.Status.ExistingInks := xaExistingInks;
	
	//Limit total InksSystems to 12

	
	//Assign max data to each InkSystem
	iInkIndex := 1;
	FOR iCabinet := 1 TO MAX_LAST_INK_CABINET DO
		AssignPowerPerCabinet;
	END_FOR		
	
	
	gInkBox.Commands := CommandsReseted;
	
END_PROGRAM
