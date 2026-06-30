
ACTION ControlStopping:
	
	IF xStatusChanged THEN
		ton_PrinterBeltInputEmpty.IN := FALSE;
		iLineStatus:=500;
	END_IF
	
	ton_PrinterBeltInputEmpty();
	
	CASE iLineStatus OF
		
		500:
			gMachine.commands.xClean:=FALSE;
			
			IF gMachine.AlSummary.xAlarmStop THEN
				Feeder.Commands.xStop:=TRUE; 
				Primer.Commands.xStop:=TRUE;
				Sarm.Commands.xStop:=TRUE;
				gMachine.commands.xStop:=TRUE;
				gMachine.commands.xRunBelt:=FALSE; //This shouldnt be required, Why stop command does not stop the belt?
				StopCuringSystems;
				StopBlowers;
				iLineStatus:=506;
			
			ELSIF Sarm.Alarms.xCriticalAlarm THEN
				Feeder.Commands.xStop:=TRUE; 
				Primer.Commands.xStop:=TRUE;
				Sarm.Commands.xStop:=TRUE;
				iLineStatus:=504;
				
			ELSIF Primer.Alarms.xCriticalAlarm THEN
				Feeder.Commands.xStop:=TRUE; 
				Primer.Commands.xStop:=TRUE;
				
				iLineStatus:=503;
			ELSE
				iLineStatus:=iLineStatus+1;
			END_IF
			
		
		501:
			Feeder.Commands.xStop:=TRUE;
			iLineStatus:=iLineStatus+1;
		
		502:
			xFeederNotFeeding := FeederNotFeeding(ADR(Feeder));
			IF xFeederNotFeeding THEN
				Primer.Commands.xControlStop:=TRUE;
				iLineStatus:=iLineStatus+1;
			END_IF

			IF gMachine.AlSummary.xAlarmStop THEN
				Feeder.Commands.xStop:=TRUE; 
				Primer.Commands.xStop:=TRUE;
				Sarm.Commands.xStop:=TRUE;
				gMachine.commands.xStop:=TRUE;
				gMachine.commands.xRunBelt:=FALSE; //This shouldnt be required, Why stop command does not stop the belt?
				StopCuringSystems;
				StopBlowers;
				iLineStatus:=506;
			
			ELSIF Sarm.Alarms.xCriticalAlarm THEN
				Feeder.Commands.xStop:=TRUE; 
				Primer.Commands.xStop:=TRUE;
				Sarm.Commands.xStop:=TRUE;
				iLineStatus:=504;
				
			ELSIF Primer.Alarms.xCriticalAlarm THEN
				Feeder.Commands.xStop:=TRUE; 
				Primer.Commands.xStop:=TRUE;
				
				iLineStatus:=503;
			END_IF
			
		503:
			xPrimerStopped := PrimerStopped(ADR(Primer));
			IF xPrimerStopped THEN
				Sarm.Commands.xControlStop:=TRUE;
				iLineStatus:=iLineStatus+1;
			END_IF

			IF gMachine.AlSummary.xAlarmStop THEN
				Feeder.Commands.xStop:=TRUE; 
				Primer.Commands.xStop:=TRUE;
				Sarm.Commands.xStop:=TRUE;
				gMachine.commands.xStop:=TRUE;
				gMachine.commands.xRunBelt:=FALSE; //This shouldnt be required, Why stop command does not stop the belt?
				StopCuringSystems;
				StopBlowers;
				iLineStatus:=506;
			
			ELSIF Sarm.Alarms.xCriticalAlarm THEN
				Feeder.Commands.xStop:=TRUE; 
				Primer.Commands.xStop:=TRUE;
				Sarm.Commands.xStop:=TRUE;
				iLineStatus:=504;
			END_IF
			
		504:
			xSarmStopped := SarmStopped(ADR(Sarm));
			IF xSarmStopped THEN
				iLineStatus:=iLineStatus+1;
			END_IF

			IF gMachine.AlSummary.xAlarmStop THEN
				Feeder.Commands.xStop:=TRUE; 
				Primer.Commands.xStop:=TRUE;
				Sarm.Commands.xStop:=TRUE;
				gMachine.commands.xStop:=TRUE;
				gMachine.commands.xRunBelt:=FALSE; //This shouldnt be required, Why stop command does not stop the belt?
				StopCuringSystems;
				StopBlowers;
				iLineStatus:=506;
			END_IF
		
		505:
			//Timer
			tiTimeToEmpty := REAL_TO_TIME(60 * (gMachine.Pt.CT.rDistanceBeltInitToPd) / Belt.parameters.rSetPointSpeed); //Belt.parameters.rSetPointSpeed minimum value is 5m/min, cannot be 0.
			ton_PrinterBeltInputEmpty.IN := TRUE;
			ton_PrinterBeltInputEmpty.PT := tiTimeToEmpty;
			
			xPrinterBeltInputEmpty := ton_PrinterBeltInputEmpty.Q;
			
			xPrinterBeltStopped:= PrinterBeltStopped(ADR(Belt));
			IF (xPrinterBeltInputEmpty OR xFromPause) AND (xPrinterEmptied OR xPrinterBeltStopped) THEN
				StopCuringSystems;
				StopBlowers;
				
				EdgeHoldDown.commands.xStop := TRUE;
				
				iLineStatus:=iLineStatus+1;
			END_IF

			IF gMachine.AlSummary.xAlarmStop THEN
				Feeder.Commands.xStop:=TRUE; 
				Primer.Commands.xStop:=TRUE;
				Sarm.Commands.xStop:=TRUE;
				gMachine.commands.xStop:=TRUE;
				gMachine.commands.xRunBelt:=FALSE; //This shouldnt be required, Why stop command does not stop the belt?
				StopCuringSystems;
				StopBlowers;
				iLineStatus:=506;
			END_IF
			
		506:
			xEhdStopped := EhdStopped(ADR(EdgeHoldDown));
			IF xEhdStopped AND xDryerEmptied AND xOpvEmptied THEN
				gMachine.commands.xStop:=TRUE;
				gMachine.commands.xRunBelt:=FALSE;
			
				EdgeHoldDown.orders.xAdjustToMedia:=FALSE;
				EdgeHoldDown.orders.xResetPosition:=TRUE;
				
				Dryer.Commands.xControlStop:=TRUE;
				iLineStatus:=iLineStatus+1;
			END_IF
			
		507:
			xDryerStopped := DryerStopped(ADR(Dryer));
			IF xDryerStopped THEN
				OverVarnish.Commands.xControlStop:=TRUE;
				iLineStatus:=iLineStatus+1;
			END_IF
			
		508:
			xOverVarnishStopped := OpvStopped(ADR(OverVarnish));
			IF xOverVarnishStopped THEN
				Stacker.Commands.xControlStop:=TRUE;
				iLineStatus:=iLineStatus+1;
			END_IF
			
		509:
			xBarsInCapPosition := BarPositionCapped(ADR(Machine));
			xEhdReady := EhdReady(ADR(EdgeHoldDown));
			IF xEhdReady AND xBarsInCapPosition THEN
				iLineStatus:=iLineStatus+1;
			END_IF
		
		510:
			xStackerStopped := StackerStopped(ADR(Stacker));
			IF xStackerStopped THEN
				xLineReady:=TRUE;
			END_IF
		
	END_CASE

	
END_ACTION


ACTION StopCuringSystems:

END_ACTION


ACTION StopBlowers:
	FOR iIndexTransVacuum:=1 TO MAX_LAST_TRANS_VACUUM DO
		TransVacuum[iIndexTransVacuum].Commands.xRunByLine := FALSE;
	END_FOR
END_ACTION