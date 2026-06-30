
(* TODO: Add your comment here *)
FUNCTION FeederStopped
	FeederStopped:=NOT Feeder.ParSw.xEnabled OR NOT Feeder.Parameters.xInstalled OR Feeder.Status.CtrlStatus=FEEDERCTRL_STOPPED;
END_FUNCTION

FUNCTION PrimerStopped
	PrimerStopped:=NOT Primer.ParSw.xEnabled OR NOT Primer.Parameters.xInstalled OR Primer.Status.CtrlStatus=PRIMERCTRL_STOPPED;
END_FUNCTION

FUNCTION SarmStopped
	SarmStopped:=NOT Sarm.ParSw.xEnabled OR NOT Sarm.Parameters.xInstalled OR Sarm.Status.CtrlStatus=SARMCTRL_STOPPED;
END_FUNCTION

FUNCTION DryerStopped
	DryerStopped:=NOT Dryer.ParSw.xEnabled OR NOT Dryer.Parameters.xInstalled OR Dryer.Status.CtrlStatus=DRYERCTRL_STOPPED;
END_FUNCTION

FUNCTION OpvStopped
	OpvStopped:=NOT OverVarnish.ParSw.xEnabled OR NOT OverVarnish.Parameters.xInstalled OR OverVarnish.Status.CtrlStatus=OPVCTRL_STOPPED;
END_FUNCTION

FUNCTION StackerStopped
	StackerStopped:=NOT Stacker.ParSw.xEnabled OR NOT Stacker.Parameters.xInstalled OR Stacker.Status.CtrlStatus=STACKERCTRL_STOPPED;
END_FUNCTION

FUNCTION FeederNotFeeding
	FeederNotFeeding:=NOT Feeder.ParSw.xEnabled OR NOT Feeder.Parameters.xInstalled OR Feeder.Status.CtrlStatus=FEEDERCTRL_PAUSED OR Feeder.Status.CtrlStatus=FEEDERCTRL_STOPPED;
END_FUNCTION

FUNCTION PrinterBeltStopped
	PrinterBeltStopped:= NOT Belt.states.xRuningBelt;
END_FUNCTION

FUNCTION EhdStopped
	EhdStopped:=NOT EdgeHoldDown.parSw.xEnable OR NOT EdgeHoldDown.parameters.xInstalled OR NOT EdgeHoldDown.status.xMoving;
END_FUNCTION