
ACTION Pausing:

	IF xStatusChanged THEN
		ton_PrinterBeltInputEmpty.IN := FALSE;
		iLineStatus:=330;
	END_IF
	
	ton_PrinterBeltInputEmpty();
	
	CASE iLineStatus OF
		330:
			Feeder.Commands.xPause:=TRUE;
			xFeederPaused := FeederPaused(ADR(Feeder)) OR FeederStopped(ADR(Feeder));
			IF xFeederPaused THEN
				iLineStatus:=iLineStatus+1;
			END_IF
		
		331:
			Primer.Commands.xPause:=TRUE;
			xPrimerPaused := PrimerPaused(ADR(Primer));
			IF xPrimerPaused THEN
				iLineStatus:=iLineStatus+1;
			END_IF
		
		332:
			Sarm.Commands.xPause:=TRUE;
			xSarmPaused := SarmPaused(ADR(Sarm));
			IF xSarmPaused THEN
				iLineStatus:=iLineStatus+1;
			END_IF
			
		333:
			//Timer
			tiTimeToEmpty := REAL_TO_TIME(60 * (gMachine.Pt.CT.rDistanceBeltInitToPd) / Belt.parameters.rSetPointSpeed); //Belt.parameters.rSetPointSpeed minimum value is 5m/min, cannot be 0.
			ton_PrinterBeltInputEmpty.IN := TRUE;
			ton_PrinterBeltInputEmpty.PT := tiTimeToEmpty;
			
			xPrinterBeltInputEmpty := ton_PrinterBeltInputEmpty.Q;
			IF xPrinterBeltInputEmpty AND xPrinterEmptied THEN
				Dryer.Commands.xPause:=TRUE;
				OverVarnish.Commands.xPause:=TRUE;
				iLineStatus:=iLineStatus+1;
			END_IF
			
		334:
			xDryerPaused := DryerPaused(ADR(Dryer));
			IF xDryerPaused  THEN
				iLineStatus:=iLineStatus+1;
			END_IF
			
		335:
			xOverVarnishPaused := OpvPaused(ADR(OverVarnish));
			IF xOverVarnishPaused THEN
				xLineReady:=TRUE;
			END_IF

	END_CASE
	
END_ACTION

