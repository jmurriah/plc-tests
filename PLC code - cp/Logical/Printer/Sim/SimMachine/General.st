
ACTION General: 

	FOR iSimIndex:=1 TO MAX_LAST_BLOCK DO
		gTraySim[iSimIndex].Commands.ToIn:=gBlock[iSimIndex].Out.xTrayIn;
		gTraySim[iSimIndex].Commands.ToOut:=gBlock[iSimIndex].Out.xTrayOut;
		gBlock[iSimIndex].In.xTrayIn:=gTraySim[iSimIndex].State.InPosition;
		gBlock[iSimIndex].In.xTrayOut:=gTraySim[iSimIndex].State.OutPosition;
	END_FOR;	
	
	//Signal from the selector
	IF EDGEPOS(gMachine.In.Buttons.xManual) THEN
		gMachine.In.Buttons.xZero:=FALSE;
		gMachine.In.Buttons.xAuto:=FALSE;
	END_IF
	IF EDGEPOS(gMachine.In.Buttons.xZero) THEN
		gMachine.In.Buttons.xManual:=FALSE;
		gMachine.In.Buttons.xAuto:=FALSE;
	END_IF
	IF EDGEPOS(gMachine.In.Buttons.xAuto) THEN
		gMachine.In.Buttons.xManual:=FALSE;
		gMachine.In.Buttons.xZero:=FALSE;
	END_IF
	
	IF EDGEPOS(gSimMachine.Commands.xToZero) THEN
		gMachine.In.Buttons.xZero:=TRUE;
		gMachine.In.Buttons.xManual:=FALSE;
		gMachine.In.Buttons.xAuto:=FALSE;
		
		simEventLog.Source := ELOG_TYPE_GENERAL;
		simEventLog.Severity:= ELOG_SEVERITY_INFO;
		simEventLog.Facility:= 0;
		simEventLog.ErrorCode:=0;
		simEventLog.Text := 'Machine going to Zero in Simulation';
		gEventLogLoader(EventData:=ADR(simEventLog));
	
	END_IF
	IF gSimMachine.Commands.xToZero AND gMachine.St.Mode.xZero THEN
		gSimMachine.Commands.xToZero:=FALSE;
	END_IF

	IF EDGEPOS(gSimMachine.Commands.xToManual) AND gMachine.St.Mode.xManual THEN
		gSimMachine.Commands.xToManual:=FALSE;
	END_IF
	IF EDGEPOS(gSimMachine.Commands.xToManual) THEN
		gMachine.In.Buttons.xZero:=FALSE;
		gMachine.In.Buttons.xManual:=TRUE;
		gMachine.In.Buttons.xAuto:=FALSE;
		gMachine.In.Buttons.xReset:=TRUE;
	END_IF
	IF gSimMachine.Commands.xToManual AND gMachine.St.Mode.xManual THEN
		gSimMachine.Commands.xToManual:=FALSE;
		gMachine.In.Buttons.xReset:=FALSE;
	END_IF
	
	IF EDGEPOS(gSimMachine.Commands.xToAuto) AND gMachine.St.Mode.xAuto THEN
		gSimMachine.Commands.xToAuto:=FALSE;
	END_IF
	IF EDGEPOS(gSimMachine.Commands.xToAuto) THEN
		gMachine.In.Buttons.xZero:=FALSE;
		gMachine.In.Buttons.xManual:=FALSE;
		gMachine.In.Buttons.xAuto:=TRUE;
		gMachine.In.Buttons.xReset:=TRUE;
	END_IF
	IF gSimMachine.Commands.xToAuto AND gMachine.St.Mode.xAuto THEN
		gSimMachine.Commands.xToAuto:=FALSE;
		gMachine.In.Buttons.xReset:=FALSE;
	END_IF

	IF gSimMachine.Commands.xToProduction THEN
		IF gMachine.Pt.xControlledByLine THEN
			gLine.Commands.Print := TRUE;
		ELSE
			gMachine.commandsSw.xStart_GI := TRUE;
		END_IF
	END_IF
	gSimMachine.Commands.xToProduction := FALSE;
	
	IF gMachine.Pt.CT.iNumBlocks >= 2 THEN
		ctrlBlock2:=0;
		xBlockExists2:=TRUE;
	ELSE
		ctrlBlock2:=1;
		xBlockExists2:=FALSE;
	END_IF
	
	//Consent. Doing it more robust. Just allowing this command to speed up simulation
	IF EDGEPOS(gSimMachine.Commands.Consent.xRaiseUpWithNoConsent AND gMachine.St.Consent.xUpWithNoConsentCountingTime) THEN
		gMachine.St.Consent.xUpWithNoConsent := TRUE;
	END_IF
	
	// Sim feedback clean belt UV position
	IF gMachine.commands.CleanBelt.xPistonFlojet THEN
		gMachine.In.CleanBelt.xLowPosition := FALSE;
		gMachine.In.CleanBelt.xHighPosition := TRUE;
	ELSE
		gMachine.In.CleanBelt.xLowPosition := TRUE;
		gMachine.In.CleanBelt.xHighPosition := FALSE;
	END_IF
	
END_ACTION
