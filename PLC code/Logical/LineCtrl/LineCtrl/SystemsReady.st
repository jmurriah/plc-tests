
(* TODO: Add your comment here *)
FUNCTION CuringSystemsReady
	//TODO: Implement
	CuringSystemsReady:= CuringLed.Status.State = CURINGLED_READY OR NOT CuringLed.Parameters.xEnabled;
END_FUNCTION

(* Return if the bars are in Position ready to print *)
FUNCTION JobReady
	JobReady := Machine.St.xRobotReadyToPrint ;
END_FUNCTION

(* Return if the bars are in Position ready to print *)
FUNCTION BarPositionReady
	BarPositionReady := Machine.St.Position.xInPrint;
END_FUNCTION

(* Return if the bars are in Position ready to print *)
FUNCTION BarPositionCapped
	BarPositionCapped := Machine.St.Position.xInCap;
END_FUNCTION

(* Return if the bars are in Position ready to print *)
FUNCTION BarPositionCleaning
	BarPositionCleaning := Machine.St.Position.xCleaning;
END_FUNCTION

(* TODO: Add your comment here *)
FUNCTION FeederReady
	FeederReady:= NOT Feeder.ParSw.xEnabled OR NOT Feeder.Parameters.xInstalled OR Feeder.Status.CtrlStatus = FEEDERCTRL_PREPARED OR Feeder.Status.CtrlStatus = FEEDERCTRL_PAUSED;
END_FUNCTION

(* TODO: Add your comment here *)
FUNCTION PrimerReady
	PrimerReady:= NOT Primer.ParSw.xEnabled OR NOT Primer.Parameters.xInstalled OR Primer.Status.CtrlStatus = PRIMERCTRL_PREPARED OR Primer.Status.CtrlStatus = PRIMERCTRL_PAUSED;
END_FUNCTION

(* TODO: Add your comment here *)
FUNCTION SarmReady
	SarmReady:= NOT Sarm.ParSw.xEnabled OR NOT Sarm.Parameters.xInstalled OR Sarm.Status.CtrlStatus = SARMCTRL_STOPPED;
END_FUNCTION

(* TODO: Add your comment here *)
FUNCTION DryerReady
	DryerReady:= NOT Dryer.ParSw.xEnabled OR NOT Dryer.Parameters.xInstalled OR Dryer.Status.CtrlStatus = DRYERCTRL_PREPARED OR Dryer.Status.CtrlStatus = DRYERCTRL_PAUSED OR Dryer.Status.CtrlStatus = DRYERCTRL_DRYING OR (Dryer.Status.CtrlStatus = DRYERCTRL_MOVING AND NOT (Dryer.ParSw.xEnableArcLamp OR Dryer.ParSw.xEnableNIR));
END_FUNCTION

(* TODO: Add your comment here *)
FUNCTION OpvReady
	OpvReady:= NOT OverVarnish.ParSw.xEnabled OR NOT OverVarnish.Parameters.xInstalled OR OverVarnish.Status.CtrlStatus = OPVCTRL_PREPARED OR OverVarnish.Status.CtrlStatus = OPVCTRL_PAUSED;
END_FUNCTION

(* TODO: Add your comment here *)
FUNCTION StackerReady
	StackerReady:=NOT Stacker.ParSw.xEnabled OR NOT Stacker.Parameters.xInstalled OR Stacker.Status.CtrlStatus = STACKERCTRL_PREPARED OR Stacker.Status.CtrlStatus = STACKERCTRL_WORKING;
END_FUNCTION

(* TODO: Add your comment here *)
FUNCTION EhdReady
	EhdReady:= NOT EdgeHoldDown.parSw.xEnable OR NOT EdgeHoldDown.parameters.xInstalled OR EdgeHoldDown.status.xInRestingPosition;
END_FUNCTION

FUNCTION EhdAdjusted
	EhdAdjusted:= NOT EdgeHoldDown.parSw.xEnable OR NOT EdgeHoldDown.parameters.xInstalled OR EdgeHoldDown.status.xAdjustedToMedia;
END_FUNCTION