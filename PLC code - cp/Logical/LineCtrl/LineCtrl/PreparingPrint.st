
ACTION PreparingPrint:
	
	IF xStatusChanged THEN
		iLineStatus:=300;
	END_IF


	CASE iLineStatus OF

		300:
			Stacker.Commands.xPrepare:=TRUE;
			//[RGP] Giving this order just when preparing to print. So media widht must not change while in printing position when EHD is active. Sw must secure that
			//The workflow would be: unload job, line goes to pause, bars go up a little bit over metal bands, then when going to print again, this order will be
			//activated again and ehd system will be adjusted to new media parameters.
			EdgeHoldDown.orders.xAdjustToMedia := TRUE;
			
			xStackerReady := StackerReady(ADR(Stacker));
			IF xStackerReady THEN
				Stacker.Commands.xStart:=TRUE;
				OverVarnish.Commands.xPrepare:=TRUE;
				iLineStatus:=iLineStatus+1;
			END_IF
			
		301:
			xEhdAdjusted := EhdAdjusted(ADR(EdgeHoldDown));
			IF xEhdAdjusted THEN
				EdgeHoldDown.orders.xAdjustToMedia := FALSE;
				Machine.commandsSw.xToNormal_GI := TRUE;
				iLineStatus:=iLineStatus+1;
			END_IF
			
		302:
			IF Machine.St.AutoMode.xProduction AND NOT gOverVarnish.ParSw.xEnablePriming THEN
				Machine.commandsSw.xToNormal_GI := FALSE; //TOREVIEW: This should be an internal command, not something coming from Comms
				Machine.commands.xAllToPrint:=TRUE;
				iLineStatus:=iLineStatus+1;
			ELSIF Machine.St.AutoMode.xProduction AND gOverVarnish.ParSw.xEnablePriming THEN
				iLineStatus:=iLineStatus+1;
			END_IF
			
		303:
			xOverVarnishReady := OpvReady(ADR(OverVarnish));
			IF xOverVarnishReady THEN
				OverVarnish.Commands.xStart := TRUE;
				IF Dryer.ParSw.xEnableNIR THEN 
					Dryer.Commands.xPrepare:=TRUE;
				ELSE
					Dryer.Commands.xStartTransport:=TRUE;
				END_IF
				IF Machine.St.AutoMode.xProduction AND gOverVarnish.ParSw.xEnablePriming THEN
					Machine.commandsSw.xToNormal_GI := FALSE; //TOREVIEW: This should be an internal command, not something coming from Comms
					Machine.commands.xAllToPrint:=TRUE;
				END_IF
				iLineStatus:=iLineStatus+1;
			END_IF
			
		304:	
			xBarsInPrintingPosition := BarPositionReady(ADR(Machine));
			//DELOREAN-1670: To check feeder ready in same step where Prepare order is being activated
			IF xBarsInPrintingPosition THEN
				iLineStatus:=iLineStatus+1;
			END_IF
			
		305:
			xOverVarnishReady := OpvReady(ADR(OverVarnish));
			xOverVarnishStarted := OpvStarted(ADR(OverVarnish));
			xDryerReady := DryerReady(ADR(Dryer));
			xStackerReady := StackerReady(ADR(Stacker));
			IF xDryerReady AND (xOverVarnishReady OR xOverVarnishStarted) AND xStackerReady THEN
				xLineReady:=TRUE;
			END_IF
		
		
	END_CASE

END_ACTION
