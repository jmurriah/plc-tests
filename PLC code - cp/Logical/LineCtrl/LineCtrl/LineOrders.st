
ACTION LineOrders:
	
	//Line to clean orders
	IF gMachine.St.Cleaning.xCleanRequestToLine THEN
		xCleanRequestToLine := TRUE;
	ELSE
		xCleanRequestToLine := FALSE;
	END_IF
	
	
	iReasonLineToClean.0 := Line.Commands.Clean;
	iReasonLineToClean.1 := xCleanRequestToLine;
	iReasonLineToClean.2 := xCleanToBeExecuted;
	
	xLineToClean := iReasonLineToClean>0;
	
	iReasonLineToCleanBelt.0 := BeltClean.Status.xCleanRequested;
	iReasonLineToCleanBelt.1 := xCleanBeltToBeExecuted;
	
	xLineToCleanBelt := iReasonLineToCleanBelt >0 AND gBeltClean.Status.State <> BCLEAN_FAULT;
	
	IF EdgeHoldDown.status.xEnabled AND (rEhdBarsHeighSp <> EdgeHoldDown.parameters.rBarsHeighSp) THEN
		xEhdRequestToPause := TRUE;
		
	ELSIF EDGENEG(Line.StatusSummary.xPausing) THEN
		xEhdRequestToPause := FALSE;
	END_IF
	
	//Line to pause orders
	iReasonLineToPause.0 := Line.Commands.Pause;
	iReasonLineToPause.1 := gMachine.In.Buttons.xStart;
	iReasonLineToPause.2 := Feeder.Alarms.xCriticalAlarm;
	iReasonLineToPause.3 := NOT gMachine.St.xRobotReadyToPrint AND NOT gCamera.OrdersSw.xCalibration;
	iReasonLineToPause.4 := EDGEPOS(xEhdRequestToPause);
	
	//Saving previous ehd heigh setpoint
	rEhdBarsHeighSp := EdgeHoldDown.parameters.rBarsHeighSp;
	
	//Line to print orders
	iReasonLineToPrint.0 := Line.Commands.Print;
	iReasonLineToPrint.1 := gMachine.In.Buttons.xStart AND gMachine.St.xRobotReadyToPrint AND Line.Status=LINE_PAUSED;
	iReasonLineToPrint.2 := xEhdRequestToPause AND (EdgeHoldDown.parameters.rBlockPosition>=EdgeHoldDown.status.rBlockPrePrintingPosition) AND Line.Status=LINE_PAUSED; //NOZOMITWO-2420
	
	//[RGP]DELOREAN-972
	//User request to print
	iReasonRequestLineToPrint.0 := tonLineStartButton.Q AND gMachine.parSw.UI.xStartPrintButtonActive;
	xLineRequestToPrintToSw:=iReasonRequestLineToPrint>0;
	
	
	//Empty belt
	iReasonLineToEmptyBelt.0 := Line.Commands.EmptyBelt;
	
	
	//To manage that these internal orders are not active at the same time
	IF iReasonLineToPause>0 AND Line.StatusSummary.xPrinting THEN
		xLineToPause := TRUE;
		
	ELSIF iReasonLineToPrint>0 THEN
		xLineToPrint := TRUE;
	
	ELSIF iReasonLineToEmptyBelt>0 THEN
		xLineToEmptyBelt := TRUE;
		
	ELSE
		xLineToPause := FALSE;
		xLineToPrint := FALSE;
		xLineToEmptyBelt := FALSE;
	END_IF
	
	//EHD
	//To send ehd to resting position when entering idle. So maybe controlled stop has not been executed properly
	IF EDGEPOS(Line.StatusSummary.xIdle) THEN
		EdgeHoldDown.orders.xResetPosition := TRUE;
	ELSIF EdgeHoldDown.status.xInRestingPosition THEN
		EdgeHoldDown.orders.xResetPosition := FALSE;
	END_IF

	//Primer NOZOMITWO-2264
	Primer.Orders.xEnablePriming := NOT Line.StatusSummary.xEmptyingBelts OR NOT Machine.St.HwData.xIsWater;
	
	//OPV NOZOMITWO-2264
	OverVarnish.Orders.xEnablePriming := NOT Line.StatusSummary.xEmptyingBelts OR NOT Machine.St.HwData.xIsWater;
	
	//Preprinting position
	ton_FeederEmpty(IN:=(NOT Feeder.Status.Device.xFeeding), PT:=T#20S);
	ton_PrimerBeltEmpty(IN:=((Primer.Inputs.Comms.xBeltEmpty OR NOT Primer.ParSw.xEnabled OR NOT Primer.Parameters.xInstalled) AND Belt.states.xRuningBelt), PT:=T#20S);
	ton_SarmBeltEmpty(IN:=((Sarm.Status.xBeltEmpty OR NOT Sarm.ParSw.xEnabled OR NOT Sarm.Parameters.xInstalled) AND Belt.states.xRuningBelt), PT:=T#20S);
	
	IF NOT Feeder.ParSw.xEnabled AND NOT Primer.ParSw.xEnabled AND NOT Sarm.ParSw.xEnabled THEN
		//No ancillaries installed before the printer are enabled in remote mode
		Line.Orders.Preprinting := FALSE;
	
	ELSE
		Line.Orders.Preprinting := 	ton_FeederEmpty.Q AND
									ton_PrimerBeltEmpty.Q AND
									ton_SarmBeltEmpty.Q AND
									(ThickCtrl.status.Belt.xBeltEmpty AND Belt.states.xRuningBelt);
	END_IF
	

	//SafetyController.Orders.xDisableReadBlock := NOT (gPLC.Internal.Blink_2s.Out AND gPLC.Internal.Blink_1s.Out);
	Feeder.Orders.xDisableReadBlock := NOT (gPLC.Internal.Blink_2s.Out AND gPLC.Internal.Blink_1s.Out) OR NOT Feeder.ParSw.xEnabled;
	Primer.Orders.xDisableReadBlock := NOT (NOT gPLC.Internal.Blink_2s.Out AND gPLC.Internal.Blink_1s.Out) OR NOT Primer.ParSw.xEnabled;
	Sarm.Orders.xDisableReadBlock := NOT (NOT gPLC.Internal.Blink_2s.Out AND gPLC.Internal.Blink_1s.Out) OR NOT Sarm.ParSw.xEnabled;
	OverVarnish.Orders.xDisableReadBlock := NOT (gPLC.Internal.Blink_2s.Out AND NOT gPLC.Internal.Blink_1s.Out) OR NOT OverVarnish.ParSw.xEnabled;
	Stacker.Orders.xDisableReadBlock := NOT (NOT gPLC.Internal.Blink_2s.Out AND NOT gPLC.Internal.Blink_1s.Out) OR NOT Stacker.ParSw.xEnabled;
	
END_ACTION



