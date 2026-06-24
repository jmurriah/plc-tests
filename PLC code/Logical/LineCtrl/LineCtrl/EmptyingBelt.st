
ACTION EmptyingBelt:

	IF xStatusChanged THEN
		ton_PrinterBeltInputEmpty.IN := FALSE;
		iLineStatus:=220;
	END_IF
	
	//DELOREAN-830:To lift bars up when there are no printed boards below bars, so no more curing is required
	IF (NOT ThickCtrl.status.MediaPosition.xMediaBelowMachine) THEN gMachine.commands.xAllToCap:=TRUE; END_IF

	ton_PrinterBeltInputEmpty();
	
	CASE iLineStatus OF
		220:
			IF xFeederEmptied THEN
				Feeder.Commands.xStop := TRUE;
				iLineStatus:=iLineStatus+1;
			END_IF
			
		221:
			IF xPrimerEmptied THEN
				Primer.Commands.xControlStop:=TRUE;
				iLineStatus:=iLineStatus+1;
			END_IF
			
		222:
			IF xSarmEmptied THEN
				Sarm.Commands.xControlStop := TRUE;
				iLineStatus:=iLineStatus+1;
			END_IF
	
		223:	
			//Timer
			tiTimeToEmpty := REAL_TO_TIME(60 * (UINT_TO_REAL (gThicknessCtrl.parameters.Belt.iBeltPerimeterLength * 5)) / Belt.parameters.rSetPointSpeed); //Belt.parameters.rSetPointSpeed minimum value is 5m/min, cannot be 0.
			ton_PrinterBeltInputEmpty.IN := TRUE;
			ton_PrinterBeltInputEmpty.PT := tiTimeToEmpty;
			
			xPrinterBeltInputEmpty := ton_PrinterBeltInputEmpty.Q;
			IF xPrinterEmptied AND xPrinterBeltInputEmpty THEN
				iLineStatus:=iLineStatus+1;
			END_IF	
			
		224:			
			IF xDryerEmptied THEN
				iLineStatus:=iLineStatus+1;
			END_IF
			
		225:			
			IF xOpvEmptied THEN
				iLineStatus:=iLineStatus+1;
			END_IF
			
		226:			
			IF xStackerEmptied THEN
				xLineReady:=TRUE;
			END_IF

	END_CASE
	
END_ACTION
