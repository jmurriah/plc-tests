
(* TODO: Add your comment here *)

FUNCTION DryerPaused
	DryerPaused:=NOT Dryer.ParSw.xEnabled OR NOT Dryer.Parameters.xInstalled OR Dryer.Status.CtrlStatus=DRYERCTRL_PAUSED OR Dryer.Status.CtrlStatus=DRYERCTRL_MOVING;
END_FUNCTION

FUNCTION PrimerPaused
	PrimerPaused:=NOT Primer.ParSw.xEnabled OR NOT Primer.Parameters.xInstalled OR Primer.Status.CtrlStatus=PRIMERCTRL_PAUSED;
END_FUNCTION

FUNCTION FeederPaused
	FeederPaused:=NOT Feeder.ParSw.xEnabled OR NOT Feeder.Parameters.xInstalled OR Feeder.Status.CtrlStatus=FEEDERCTRL_PAUSED;
END_FUNCTION

FUNCTION OpvPaused
	OpvPaused:=NOT OverVarnish.ParSw.xEnabled OR NOT OverVarnish.Parameters.xInstalled OR OverVarnish.Status.CtrlStatus=OPVCTRL_PAUSED;
END_FUNCTION

FUNCTION SarmPaused
	SarmPaused:=NOT Sarm.ParSw.xEnabled OR NOT Sarm.Parameters.xInstalled OR Sarm.Status.CtrlStatus=SARMCTRL_PAUSED;
END_FUNCTION
