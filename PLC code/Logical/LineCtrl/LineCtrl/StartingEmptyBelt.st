
ACTION StartingEmptyBelt:

	IF xStatusChanged THEN
		iLineStatus:=210;
	END_IF
	
	CASE iLineStatus OF
		210:
			Stacker.Commands.xStart:=TRUE;
			iLineStatus:=iLineStatus+1;
		
		211:
			xStackerStarted:=StackerStarted(ADR(Stacker));
			IF xStackerStarted THEN
				OverVarnish.Commands.xStart:=TRUE;
				iLineStatus:=iLineStatus+1;
			END_IF
			
		212:
			xOverVarnishStarted:=OpvStarted(ADR(OverVarnish));
			IF xOverVarnishStarted THEN
				Dryer.Commands.xStart:=TRUE;
				iLineStatus:=iLineStatus+1;
			END_IF
			
		213:
			xDryerStarted:=DryerStarted(ADR(Dryer));
			xThicknessSensorReady := ThicknessSensorReady(ADR(ThickCtrl));
			IF xThicknessSensorReady AND xDryerStarted THEN
				gMachine.commands.xRunBelt := TRUE;
				iLineStatus:=iLineStatus+1;
			END_IF
		
		214:
			xPrinterBeltStarted:= PrinterBeltStarted(ADR(Belt));
			IF xPrinterBeltStarted THEN
				Sarm.Commands.xStart:=TRUE;
				iLineStatus:=iLineStatus+1;
			END_IF
			
		215:
			xSarmStarted := SarmStarted(ADR(Sarm));
			IF xSarmStarted THEN
				Primer.Commands.xPrepare:=TRUE;
				iLineStatus:=iLineStatus+1;
			END_IF
		
		216:
			xPrimerReady:=PrimerReady(ADR(Primer));
			IF xPrimerReady THEN
				Feeder.Commands.xPrepare:=TRUE;
				iLineStatus:=iLineStatus+1;
			END_IF
		
		217:
			xFeederReady:=FeederReady(ADR(Feeder));
			IF xFeederReady THEN
				xLineReady:=TRUE;
			END_IF
		

	END_CASE
	
END_ACTION

