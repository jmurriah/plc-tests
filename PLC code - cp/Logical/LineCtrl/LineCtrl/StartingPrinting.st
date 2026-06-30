
ACTION StartingPrinting:

	IF xStatusChanged THEN
		iLineStatus:=310;
	END_IF
	
	CASE iLineStatus OF
		310:
			Dryer.Commands.xStart:=TRUE;
			iLineStatus:=iLineStatus+1;
		
		311:
			xStackerStarted:=StackerStarted(ADR(Stacker));
			xOverVarnishStarted:=OpvStarted(ADR(OverVarnish));
			xDryerStarted:=DryerStarted(ADR(Dryer));
			xJobReady := JobReady(ADR(Machine));
			
			xThicknessSensorReady := ThicknessSensorReady(ADR(ThickCtrl));
			IF xThicknessSensorReady AND xDryerStarted AND xOverVarnishStarted AND xStackerStarted THEN
				//[RGP] To avoid to start printer's belt before job is loaded. This occurs when there is no feeder and user prints samples by entering boards from printer's entry
				IF Feeder.ParSw.xEnabled OR (NOT Feeder.ParSw.xEnabled AND xJobReady) THEN  
					gMachine.commands.xRunBelt:=TRUE;
				END_IF
				iLineStatus:=iLineStatus+1;
			END_IF
		
		312:
			xPrinterBeltStarted:= PrinterBeltStarted(ADR(Belt));
			xCuringSystemReady := CuringSystemsReady(ADR(CuringLed[1])) AND CuringSystemsReady(ADR(CuringLed[2]));
			xJobReady := JobReady(ADR(Machine));
			
			IF xPrinterBeltStarted AND xCuringSystemReady AND xJobReady THEN
				Sarm.Commands.xStart := TRUE;
				Primer.Commands.xPrepare:=TRUE;
				iLineStatus:=iLineStatus+1;
			END_IF
			
		313:
			xSarmReady := SarmReady(ADR(Sarm));
			xSarmStarted:=SarmStarted(ADR(Sarm));
			xPrimerReady := PrimerReady(ADR(Primer));
			IF xPrimerReady AND (xSarmReady OR xSarmStarted) THEN
				Primer.Commands.xStart := TRUE;
				iLineStatus:=iLineStatus+1;
			END_IF
		314:
			xPrimerStarted:=PrimerStarted(ADR(Primer));
			xSarmStarted:=SarmStarted(ADR(Sarm));
			IF xPrimerStarted AND xSarmStarted THEN
				Feeder.Commands.xPrepare:=TRUE;
				iLineStatus:=iLineStatus+1;
			END_IF
			
		315:
			IF NOT xLineToPause THEN
				xFeederReady := FeederReady(ADR(Feeder));
				IF xFeederReady THEN
					Feeder.Commands.xStart:=TRUE;
					iLineStatus:=iLineStatus+1;			
				END_IF
			ELSE
				xLineReady:=TRUE;
			END_IF
			
		316:
			IF NOT xLineToPause THEN
				xFeederStarted:=FeederStarted(ADR(Feeder));
				IF xFeederStarted THEN
					xLineReady:=TRUE;
				END_IF
			ELSE
				xLineReady:=TRUE;
			END_IF
		

	END_CASE
	
END_ACTION


