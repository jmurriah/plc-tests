
ACTION PreparingEmptyBelt:
	
	IF xStatusChanged THEN
		iLineStatus:=200;
	END_IF
	
	ton_StackerCleanBelts.IN:=Stacker.Outputs.xCleanBelts;
	ton_StackerCleanBelts.PT:=T#2S;
	ton_StackerCleanBelts();

	CASE iLineStatus OF
		200:
			StartBlowers;
			IF ton_StackerCleanBelts.Q OR NOT Stacker.ParSw.xEnabled THEN
				IF (gMachine.St.HwData.xIsWater OR NOT ThickCtrl.status.MediaPosition.xMediaBelowMachine) THEN
					gMachine.commands.xAllToCap := TRUE;
					Stacker.Commands.xPrepare := TRUE;
					
					xBarsInCapPosition := BarPositionCapped(ADR(Machine));
					IF xBarsInCapPosition THEN iLineStatus:=iLineStatus+1; END_IF
					
				ELSE
					gMachine.commandsSw.xToNormal_GI := TRUE;
					IF gMachine.St.AutoMode.xProduction THEN
						gMachine.commandsSw.xToNormal_GI := FALSE; //TOREVIEW: This should be an internal command, not something coming from Comms
						gMachine.commands.xAllToPrint:=TRUE;
						Stacker.Commands.xPrepare := TRUE;
						
						xBarsInPrintingPosition := BarPositionReady(ADR(Machine));
						IF xBarsInPrintingPosition THEN iLineStatus:=iLineStatus+1; END_IF
					END_IF
				END_IF
			END_IF
			
		
		201:
			//Waiting stacker and evaluate which next object must be prepared
			xStackerReady := StackerReady(ADR(Stacker));
			IF xStackerReady THEN
				iLineStatus:=iLineStatus+1;
			END_IF
		
		
		202:
			OverVarnish.Commands.xPrepare:=TRUE;
			xOverVarnishReady:=OpvReady(ADR(OverVarnish));
			IF xOverVarnishReady THEN
				iLineStatus:=iLineStatus+1;
			END_IF
			
			
		203:
			IF (Dryer.ParSw.xEnableArcLamp OR Dryer.ParSw.xEnableNIR) THEN 
				Dryer.Commands.xBelEmpty := TRUE;
			ELSE
				Dryer.Commands.xStartTransport:=TRUE;
			END_IF
			iLineStatus:=iLineStatus+1;
			
			
		204:
			IF Dryer.Status.CtrlStatus = DRYERCTRL_MOVING AND (Dryer.ParSw.xEnableArcLamp OR Dryer.ParSw.xEnableNIR) THEN
				Dryer.Commands.xPrepare:=TRUE;
			END_IF
			xDryerReady := DryerReady(ADR(Dryer));
			IF xDryerReady THEN xLineReady:=TRUE; END_IF
				
	END_CASE
	
	
END_ACTION

ACTION StartBlowers:
	FOR iIndexTransVacuum:=1 TO MAX_LAST_TRANS_VACUUM DO
		TransVacuum[iIndexTransVacuum].Commands.xRunByLine := TRUE;
	END_FOR
END_ACTION

