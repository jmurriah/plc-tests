
(* TODO: Add your comment here *)

FUNCTION FeederEmptied
	FeederEmptied:=NOT Feeder.ParSw.xEnabled OR NOT Feeder.Parameters.xInstalled OR Feeder.Status.CtrlStatus<>FEEDERCTRL_FEEDING;
END_FUNCTION

FUNCTION PrimerEmptied
	PrimerEmptied:=NOT Primer.ParSw.xEnabled OR NOT Primer.Parameters.xInstalled OR Primer.Status.xBeltEmpty;
END_FUNCTION

FUNCTION PrinterEmptied
	PrinterEmptied:= ThickCtrl.status.Belt.xBeltEmpty;
END_FUNCTION

FUNCTION DryerEmptied
	DryerEmptied:=NOT Dryer.ParSw.xEnabled OR NOT Dryer.Parameters.xInstalled OR Dryer.Status.xBeltEmpty;
END_FUNCTION

FUNCTION OpvEmptied
	OpvEmptied:=NOT OverVarnish.ParSw.xEnabled OR NOT OverVarnish.Parameters.xInstalled OR OverVarnish.Status.xBeltEmpty;
END_FUNCTION

FUNCTION StackerEmptied
	StackerEmptied:=NOT Stacker.ParSw.xEnabled OR NOT Stacker.Parameters.xInstalled OR (Stacker.Inputs.Comms.xBeltsEmpty AND NOT Stacker.Inputs.Comms.xStackExit) OR Stacker.Status.xBeltEmpty;
END_FUNCTION

FUNCTION SarmEmptied
	SarmEmptied:=NOT Sarm.ParSw.xEnabled OR NOT Sarm.Parameters.xInstalled OR Sarm.Status.xBeltEmpty;
END_FUNCTION