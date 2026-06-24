
(* TODO: Add your comment here *)
FUNCTION FeederStarted
	FeederStarted:= NOT Feeder.ParSw.xEnabled OR NOT Feeder.Parameters.xInstalled OR Feeder.Status.CtrlStatus = FEEDERCTRL_STARTING OR Feeder.Status.CtrlStatus = FEEDERCTRL_FEEDING;
END_FUNCTION

(* TODO: Add your comment here *)
FUNCTION PrimerStarted
	PrimerStarted:= NOT Primer.ParSw.xEnabled OR NOT Primer.Parameters.xInstalled OR Primer.Status.CtrlStatus = PRIMERCTRL_WORKING;
END_FUNCTION

(* TODO: Add your comment here *)
FUNCTION SarmStarted
	SarmStarted:= NOT Sarm.ParSw.xEnabled OR NOT Sarm.Parameters.xInstalled OR Sarm.Status.CtrlStatus = SARMCTRL_RUNNING;
END_FUNCTION

(* TODO: Add your comment here *)
FUNCTION DryerStarted
	DryerStarted:= NOT Dryer.ParSw.xEnabled OR NOT Dryer.Parameters.xInstalled OR Dryer.Status.CtrlStatus = DRYERCTRL_DRYING OR (Dryer.Status.CtrlStatus = DRYERCTRL_MOVING AND NOT (Dryer.ParSw.xEnableArcLamp OR Dryer.ParSw.xEnableNIR));
END_FUNCTION

(* TODO: Add your comment here *)
FUNCTION OpvStarted
	OpvStarted:= NOT OverVarnish.ParSw.xEnabled OR NOT OverVarnish.Parameters.xInstalled OR OverVarnish.Status.CtrlStatus = OPVCTRL_WORKING;
END_FUNCTION

(* TODO: Add your comment here *)
FUNCTION StackerStarted
	StackerStarted:=NOT Stacker.ParSw.xEnabled OR NOT Stacker.Parameters.xInstalled OR Stacker.Status.CtrlStatus = STACKERCTRL_WORKING;
END_FUNCTION

(* TODO: Add your comment here *)
FUNCTION ThicknessSensorReady
	ThicknessSensorReady := ThickCtrl.status.DetectionSystem.xInPosition;
END_FUNCTION

(* TODO: Add your comment here *)
FUNCTION PrinterBeltStarted
	PrinterBeltStarted:=Belt.states.xRuningBelt;
END_FUNCTION

(* TODO: Add your comment here *)
FUNCTION CuringSystemsStarted
	//TODO: Implement
	CuringSystemsStarted:= CuringLed.Status.State = CURINGLED_EMITTING;
END_FUNCTION
