
ACTION Stopping:

	IF xStatusChanged THEN
		iLineStatus:=650;
	END_IF
	
	CASE iLineStatus OF
		650:
			StopAllLineDevices;
			iLineStatus:=iLineStatus+1;
		
		651:
			xFeederStopped:=FeederStopped(ADR(Feeder));
			xPrimerStopped:=PrimerStopped(ADR(Primer));
			xSarmStopped := SarmStopped(ADR(Sarm));
			xDryerStopped:=DryerStopped(ADR(Dryer));
			xOverVarnishStopped:=OpvStopped(ADR(OverVarnish));
			xStackerStopped:=StackerStopped(ADR(Stacker));
			xEhdStopped := EhdStopped(ADR(EdgeHoldDown));
			IF xFeederStopped AND xPrimerStopped AND xDryerStopped AND xStackerStopped AND xOverVarnishStopped AND xEhdStopped AND xSarmStopped THEN
				xLineReady:=TRUE;
			END_IF
			
	
	END_CASE
	
END_ACTION

ACTION StopAllLineDevices:
	Feeder.Commands.xStop:=TRUE; 
	Primer.Commands.xStop:=TRUE;
	Sarm.Commands.xStop:=TRUE;
	Dryer.Commands.xStop:=TRUE;
	OverVarnish.Commands.xStop:=TRUE;
	Stacker.Commands.xStop:=TRUE;
	gMachine.commands.xStop:=TRUE;
	gMachine.commands.xClean:=FALSE;
	gMachine.commands.CleanBelt.xStart := FALSE;
	gMachine.St.xAbortJobRequest:=TRUE;
	gMachine.commands.xRunBelt:=FALSE; //This shouldnt be required, Why stop command does not stop the belt?
	EdgeHoldDown.orders.xAdjustToMedia:=FALSE;
	EdgeHoldDown.orders.xResetPosition:=FALSE;
	EdgeHoldDown.commands.xStop:=TRUE;
	StopCuringSystems;
	StopBlowers;
END_ACTION
