
ACTION Configuration:

	// Update ancillaries status used
	xPrimerStopped := PrimerStopped(ADR(Primer));

	//Line's ancillaries assignation//
	//Feeder
	//Parameters
	Feeder.Parameters.xSimulationMode 				:= gMachine.Pt.ConfigNameID = GC_CONFIG_SIMTEST_ID;
	Feeder.Parameters.xLineInAuto 					:= gMachine.St.Mode.xAuto;
	Feeder.Parameters.Media 						:= gMachine.parSw.Media;
	Feeder.Parameters.rBeltSpeedSetPoint 			:= MAX(1, Belt.parameters.rSetPointSpeed);
	Feeder.Parameters.iCentralOffset 				:= Feeder.ParSw.iCentralOffset;
	Feeder.Parameters.iCounterSetPointL1 			:= UDINT_TO_INT(gMachine.parSw.iNumCopies AND 16#FFFF);
	Feeder.Parameters.iCounterSetPointL2 			:= UDINT_TO_INT(SHR((gMachine.parSw.iNumCopies AND 16#F0000),16));
	IF NOT gMachine.parSw.Dtp.xDoubleLine THEN
		Feeder.Parameters.iLineConfig:= 0;
	ELSE
		Feeder.Parameters.iLineConfig:= 2;
	END_IF
	Feeder.Parameters.LineState						:= gLine.Status;
	Feeder.Parameters.LineStatusSummary				:= gLine.StatusSummary;

	
	//Commands
	Feeder.Commands.xResetAlarms := gMachine.AutoCmd.xReset OR gLine.Commands.Print;
	Feeder.Commands.xNewOrder := EDGEPOS(gMachine.St.xRobotReadyToPrint);

	
	//Primer
	//Parameters
	Primer.Parameters.xSimulationMode 				:= gMachine.Pt.ConfigNameID = GC_CONFIG_SIMTEST_ID;
	Primer.Parameters.xLineInAuto 					:= gMachine.St.Mode.xAuto;
	Primer.Parameters.Media 						:= gMachine.parSw.Media;
	Primer.Parameters.rBeltSpeedSetPoint 			:= MAX(1, Belt.parameters.rSetPointSpeed);
	Primer.Parameters.xDoubleLine 					:= gMachine.parSw.Dtp.xDoubleLine;
	Primer.Parameters.LineState						:= gLine.Status;
	Primer.Parameters.LineStatusSummary				:= gLine.StatusSummary;
	Primer.Parameters.rMediaLength 					:= gMachine.parSw.Media.rLength;
	Primer.Parameters.rSpeedSetPoint 				:= Belt.parameters.rSetPointSpeed;
	Primer.Parameters.xPreviousDeviceStopped 		:= NOT Feeder.Status.Device.xFeeding;

	//Commands
	Primer.Commands.xResetAlarms 					:= gMachine.AutoCmd.xReset;
	Primer.Commands.xEnteringMedia 					:= gFeeder.Status.Device.xFeeding;

	
	//SARM
	//Parameters
	Sarm.Parameters.xSimulationMode 				:= gMachine.Pt.ConfigNameID = GC_CONFIG_SIMTEST_ID;
	Sarm.Parameters.xLineInAuto 					:= gMachine.St.Mode.xAuto;
	Sarm.Parameters.Media 							:= gMachine.parSw.Media;
	Sarm.Parameters.xDoubleLine 					:= gMachine.parSw.Dtp.xDoubleLine;
	Sarm.Parameters.LineState						:= gLine.Status;
	Sarm.Parameters.rMediaLength 					:= gMachine.parSw.Media.rLength;
	Sarm.Parameters.rSpeedSetPoint 					:= Belt.parameters.rSetPointSpeed;

	Sarm.Parameters.xPreviousDeviceEmpty 			:= (xPrimerEmptied OR xPrimerStopped OR (NOT Feeder.Status.Device.xFeeding AND Feeder.Parameters.xInstalled AND NOT Primer.Parameters.xInstalled)) ;
	IF NOT gMachine.parSw.Dtp.xDoubleLine THEN
		Sarm.Parameters.iLineConfig:= 0;
	ELSE
		Sarm.Parameters.iLineConfig:= 2;
	END_IF
	//Commands
	Sarm.Commands.xResetAlarms 						:= gMachine.AutoCmd.xReset;
	
	
	
	//Dryer
	//Parameters
	Dryer.Parameters.xLineInAuto 					:= gMachine.St.Mode.xAuto;
	Dryer.Parameters.Hw.rDryerLength 				:= 5000.0;
	Dryer.Parameters.rSpeedSetPoint 				:= Belt.parameters.rSetPointSpeed;
	Dryer.Parameters.rMediaLength 					:= gMachine.parSw.Media.rLength;
	Dryer.Parameters.rMediaWidth 					:= gMachine.parSw.Media.rWidth;
	Dryer.Parameters.rMediaThickness 				:= gMachine.parSw.Media.rThickness;
	Dryer.Parameters.rMediaGap 						:= gMachine.parSw.Media.rGap;
	Dryer.Parameters.LineState 						:= Line.Status;
	Dryer.Parameters.rDocumentWidth 				:= gMachine.parSw.Document.rWidth;
	Dryer.Parameters.rDocumentLength 				:= gMachine.parSw.Document.rLength;
	Dryer.Parameters.rDocumentOffsetL1				:= gMachine.parSw.Document.rOffsetL1; //NOZDRYER-467
	Dryer.Parameters.rDocumentOffsetL2				:= gMachine.parSw.Document.rOffsetL2; //NOZDRYER-467
	Dryer.Parameters.xDoubleLine 					:= gMachine.parSw.Dtp.xDoubleLine;
	//Commands
	Dryer.Commands.xResetAlarms 					:= gMachine.AutoCmd.xReset;
	
	
	
	//OverPrimer
	//Parameters
	OverVarnish.Parameters.xSimulationMode 		:= gMachine.Pt.ConfigNameID = GC_CONFIG_SIMTEST_ID;
	OverVarnish.Parameters.xLineInAuto 			:= gMachine.St.Mode.xAuto;
	OverVarnish.Parameters.Media 				:= gMachine.parSw.Media;
	OverVarnish.Parameters.xDoubleLine 			:= gMachine.parSw.Dtp.xDoubleLine;
	OverVarnish.Parameters.LineState			:= gLine.Status;
	OverVarnish.Parameters.LineStatusSummary	:= gLine.StatusSummary;
	OverVarnish.Parameters.rMediaLength 		:= gMachine.parSw.Media.rLength;
	OverVarnish.Parameters.rSpeedSetPoint	:= MAX(1, Belt.parameters.rSetPointSpeed);
	OverVarnish.Parameters.xPreviousDeviceStopped := ThickCtrl.status.Belt.xBeltEmpty AND (Dryer.Status.xBeltEmpty OR NOT Dryer.ParSw.xEnabled);

	//Commands
	OverVarnish.Commands.xResetAlarms 				:= gMachine.AutoCmd.xReset;
	OverVarnish.Commands.xEnteringMedia 			:= 	gFeeder.Status.Device.xFeeding OR 
														NOT xPrimerEmptied OR
														NOT xSarmEmptied OR
														NOT ThickCtrl.status.Belt.xBeltEmpty OR
														NOT xDryerEmptied;
	
	//Stacker
	//Parameters
	Stacker.Parameters.xSimulationMode 				:= gMachine.Pt.ConfigNameID = GC_CONFIG_SIMTEST_ID;
	Stacker.Parameters.xLineInAuto 					:= gMachine.St.Mode.xAuto;
	Stacker.Parameters.Media 						:= gMachine.parSw.Media;
	Stacker.Parameters.rSpeedSetPoint	 			:= MAX(1, Belt.parameters.rSetPointSpeed);
	Stacker.Parameters.xDoubleLine 					:= gMachine.parSw.Dtp.xDoubleLine;
	Stacker.Parameters.LineState					:= gLine.Status;
	Stacker.Parameters.LineStatusSummary			:= gLine.StatusSummary;
	Stacker.Parameters.xPreviousDeviceStopped		:= 	ThickCtrl.status.Belt.xBeltEmpty AND
														(Dryer.Status.xBeltEmpty OR NOT Dryer.ParSw.xEnabled) AND
														(OverVarnish.Status.xBeltEmpty OR NOT OverVarnish.ParSw.xEnabled);

	IF Machine.St.HwData.xIsWater THEN
		Stacker.Orders.xHoldReject := gThicknessCtrl.Outputs.xHoldReject OR Line.StatusSummary.xEmptyingBelts;
	ELSE
		Stacker.Orders.xHoldReject := gThicknessCtrl.Outputs.xHoldReject;
	END_IF
	
	//Commands
	Stacker.Commands.xResetAlarms := gMachine.AutoCmd.xReset;
	
	
	//Line media limits
	DefineMediaLimits;
	
	//Line speed limits
	DefineSpeedLimits;
	
	//Line features allowed
	DefineLineFeaturesAllowed;
	
END_ACTION

ACTION DefineMediaLimits:

	iFeederMediaWidth := FeederMaxMediaWidth(ADR(Feeder), ADR(gMachine));
	iFeederMediaLength := FeederMaxMediaLength(ADR(Feeder), ADR(gMachine));
	iFeederMinMediaThickness := FeederMinMediaThickness(ADR(Feeder), ADR(gMachine));
	iFeederMaxMediaThickness := FeederMaxMediaThickness(ADR(Feeder), ADR(gMachine));
	
	iPrimerMediaWidth := PrimerMaxMediaWidth(ADR(Primer), ADR(gMachine));
	iPrimerMediaLength := PrimerMaxMediaLength(ADR(Primer), ADR(gMachine));
	iPrimerMinMediaThickness := PrimerMinMediaThickness(ADR(Primer), ADR(gMachine));
	iPrimerMaxMediaThickness := PrimerMaxMediaThickness(ADR(Primer), ADR(gMachine));
	
	iSarmMediaWidth := SarmMaxMediaWidth(ADR(Sarm), ADR(gMachine));
	iSarmMediaLength := SarmMaxMediaLength(ADR(Sarm), ADR(gMachine));
	iSarmMinMediaThickness := SarmMinMediaThickness(ADR(Sarm), ADR(gMachine));
	iSarmMaxMediaThickness := SarmMaxMediaThickness(ADR(Sarm), ADR(gMachine));
	
	iDryerMediaWidth := DryerMaxMediaWidth(ADR(Dryer), ADR(gMachine));
	iDryerMediaLength := DryerMaxMediaLength(ADR(Dryer), ADR(gMachine));
//	iDryerMinMediaThickness := DryerMinMediaThickness(ADR(Dryer), ADR(gMachine));
//	iDryerMaxMediaThickness := DryerMaxMediaThickness(ADR(Dryer), ADR(gMachine));
	
	iOvervarnishMediaWidth := OvervarnishMaxMediaWidth(ADR(OverVarnish), ADR(gMachine));
	iOvervarnishMediaLength := OvervarnishMaxMediaLength(ADR(OverVarnish), ADR(gMachine));
	iOverVarnishMinMediaThickness := OverVarnishMinMediaThickness(ADR(OverVarnish), ADR(gMachine));
	iOverVarnishMaxMediaThickness := OverVarnishMaxMediaThickness(ADR(OverVarnish), ADR(gMachine));
	
	iStackerMediaWidth := StackerMaxMediaWidth(ADR(Stacker), ADR(gMachine));
	iStackerMediaLength := StackerMaxMediaLength(ADR(Stacker), ADR(gMachine));
	iStackerMinMediaThickness := StackerMinMediaThickness(ADR(Stacker), ADR(gMachine));
	iStackerMaxMediaThickness := StackerMaxMediaThickness(ADR(Stacker), ADR(gMachine));

	gMachine.Pt.Media.iMaxMediaWidth := MIN(iFeederMediaWidth, iPrimerMediaWidth, iSarmMediaWidth, gMachine.Pt.Hw.iWidth, iDryerMediaWidth, iOvervarnishMediaWidth, iStackerMediaWidth);
	gMachine.Pt.Media.iMaxMediaLength := MIN(iFeederMediaLength, iPrimerMediaLength, iSarmMediaLength, gMachine.parSw.Hw.iMaxMediaLength, iDryerMediaLength, iOvervarnishMediaLength, iStackerMediaLength);
	gMachine.Pt.Media.rMaxMediaThickness := UINT_TO_REAL((MIN(iFeederMaxMediaThickness, iPrimerMaxMediaThickness, iSarmMaxMediaThickness, REAL_TO_UINT(gMachine.Pt.CT.rMaxTicknessMedia*10), iOverVarnishMaxMediaThickness, iStackerMaxMediaThickness)))/10;
	gMachine.Pt.Media.rMinMediaThickness := UINT_TO_REAL((MAX(iFeederMinMediaThickness, iPrimerMinMediaThickness, iSarmMinMediaThickness, REAL_TO_UINT(gMachine.Pt.CT.rMinTicknessMedia*10), iOverVarnishMinMediaThickness, iStackerMinMediaThickness)))/10;
END_ACTION

ACTION DefineSpeedLimits:
	
	rFeederMaxSpeed := FeederMaxSpeed(ADR(Feeder), ADR(gBelt));
	rPrimerMaxSpeed := PrimerMaxSpeed(ADR(Primer), ADR(gBelt));
	rSarmMaxSpeed := SarmMaxSpeed(ADR(Sarm), ADR(gBelt));
	rDryerMaxSpeed := DryerMaxSpeed(ADR(Dryer), ADR(gBelt));
	rOvervarnishMaxSpeed := OvervarnishMaxSpeed(ADR(OverVarnish), ADR(gBelt));
	rStackerMaxSpeed := StackerMaxSpeed(ADR(Stacker), ADR(gBelt));

	gLine.Parameters.Hw.rMaxSpeed := MIN(rFeederMaxSpeed, rPrimerMaxSpeed, rSarmMaxSpeed, rDryerMaxSpeed, rOvervarnishMaxSpeed, rStackerMaxSpeed);
	
	gLine.Parameters.Hw.rMaxSpeed := MIN(rLineMaxSpeed, gLine.Parameters.Hw.rMaxSpeed);

END_ACTION


ACTION DefineLineFeaturesAllowed:

	gLine.Parameters.Hw.xDoubleLineAllowed := 	(Feeder.Parameters.Hw.xDoubleLineAllowed OR NOT Feeder.ParSw.xEnabled) AND
												(Primer.Parameters.Hw.xDoubleLineAllowed OR NOT Primer.ParSw.xEnabled) AND
												(Sarm.Parameters.Hw.xDoubleLineAllowed OR NOT Sarm.ParSw.xEnabled) AND
												(Dryer.Parameters.Hw.xDoubleLineAllowed OR NOT Dryer.ParSw.xEnabled) AND
												(OverVarnish.Parameters.Hw.xDoubleLineAllowed OR NOT OverVarnish.ParSw.xEnabled) AND
												(Stacker.Parameters.Hw.xDoubleLineAllowed OR NOT Stacker.ParSw.xEnabled);
	
	
END_ACTION