
{REDUND_ERROR} FUNCTION CuringSystemsStarted : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		CuringLed : REFERENCE TO CuringLed_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION CuringSystemsReady : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		CuringLed : REFERENCE TO CuringLed_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION PrinterBeltStopped : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Belt : REFERENCE TO stBelt;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION PrinterBeltStarted : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Belt : REFERENCE TO stBelt;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION DryerReady : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Dryer : REFERENCE TO DryerAnc_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION FeederReady : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Feeder : REFERENCE TO Feeder_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION PrimerReady : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Primer : REFERENCE TO Primer_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION SarmStopped : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Sarm : REFERENCE TO Sarm_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION SarmStarted : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Sarm : REFERENCE TO Sarm_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION SarmReady : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Sarm : REFERENCE TO Sarm_typ;
	END_VAR
END_FUNCTION

FUNCTION EhdAdjusted : BOOL
	VAR_INPUT
		EdgeHoldDown : REFERENCE TO EdgeHoldDown_typ;
	END_VAR
END_FUNCTION

FUNCTION EhdReady : BOOL
	VAR_INPUT
		EdgeHoldDown : REFERENCE TO EdgeHoldDown_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION StackerReady : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Stacker : REFERENCE TO Stacker_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION BarPositionCleaning : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Machine : REFERENCE TO StGeneral;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION BarPositionCapped : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Machine : REFERENCE TO StGeneral;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION JobReady : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Machine : REFERENCE TO StGeneral;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION BarPositionReady : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Machine : REFERENCE TO StGeneral;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION DryerStarted : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Dryer : REFERENCE TO DryerAnc_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION FeederStarted : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Feeder : REFERENCE TO Feeder_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION PrimerStarted : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Primer : REFERENCE TO Primer_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION StackerStarted : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Stacker : REFERENCE TO Stacker_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION ThicknessSensorReady : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		ThickCtrl : REFERENCE TO stThicknessCtrl_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION DryerPaused : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Dryer : REFERENCE TO DryerAnc_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION PrimerPaused : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Primer : REFERENCE TO Primer_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION FeederPaused : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Feeder : REFERENCE TO Feeder_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION DryerStopped : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Dryer : REFERENCE TO DryerAnc_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION FeederStopped : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Feeder : REFERENCE TO Feeder_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION PrimerStopped : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Primer : REFERENCE TO Primer_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION StackerStopped : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Stacker : REFERENCE TO Stacker_typ;
	END_VAR
END_FUNCTION

FUNCTION EhdStopped : BOOL
	VAR_INPUT
		EdgeHoldDown : REFERENCE TO EdgeHoldDown_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION FeederNotFeeding : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Feeder : REFERENCE TO Feeder_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION OpvReady : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		OverVarnish : REFERENCE TO Opv_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION OpvStarted : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		OverVarnish : REFERENCE TO Opv_typ;
	END_VAR
END_FUNCTION

FUNCTION SarmPaused : BOOL
	VAR_INPUT
		Sarm : REFERENCE TO Sarm_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION OpvPaused : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		OverVarnish : REFERENCE TO Opv_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION OpvStopped : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		OverVarnish : REFERENCE TO Opv_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION FeederEmptied : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Feeder : REFERENCE TO Feeder_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION StackerEmptied : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Stacker : REFERENCE TO Stacker_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION OpvEmptied : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		OverVarnish : REFERENCE TO Opv_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION DryerEmptied : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Dryer : REFERENCE TO DryerAnc_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION PrinterEmptied : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		ThickCtrl : REFERENCE TO stThicknessCtrl_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION PrimerEmptied : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Primer : REFERENCE TO Primer_typ;
	END_VAR
END_FUNCTION

FUNCTION SarmEmptied : BOOL
	VAR_INPUT
		Sarm : REFERENCE TO Sarm_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION DryerMaxSpeed : REAL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Dryer : REFERENCE TO DryerAnc_typ;
		Belt : REFERENCE TO stBelt;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION DryerMaxMediaLength : UINT (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Dryer : REFERENCE TO DryerAnc_typ;
		Machine : REFERENCE TO StGeneral;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION DryerMaxMediaWidth : UINT (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Dryer : REFERENCE TO DryerAnc_typ;
		Machine : REFERENCE TO StGeneral;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION FeederMaxSpeed : REAL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Feeder : REFERENCE TO Feeder_typ;
		Belt : REFERENCE TO stBelt;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION FeederMaxMediaThickness : UINT (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Feeder : REFERENCE TO Feeder_typ;
		Machine : REFERENCE TO StGeneral;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION FeederMinMediaThickness : UINT (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Feeder : REFERENCE TO Feeder_typ;
		Machine : REFERENCE TO StGeneral;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION FeederMaxMediaLength : UINT (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Feeder : REFERENCE TO Feeder_typ;
		Machine : REFERENCE TO StGeneral;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION FeederMaxMediaWidth : UINT (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Feeder : REFERENCE TO Feeder_typ;
		Machine : REFERENCE TO StGeneral;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION PrimerMaxSpeed : REAL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Primer : REFERENCE TO Primer_typ;
		Belt : REFERENCE TO stBelt;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION PrimerMinMediaThickness : UINT (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Primer : REFERENCE TO Primer_typ;
		Machine : REFERENCE TO StGeneral;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION PrimerMaxMediaThickness : UINT (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Primer : REFERENCE TO Primer_typ;
		Machine : REFERENCE TO StGeneral;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION PrimerMaxMediaLength : UINT (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Primer : REFERENCE TO Primer_typ;
		Machine : REFERENCE TO StGeneral;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION PrimerMaxMediaWidth : UINT (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Primer : REFERENCE TO Primer_typ;
		Machine : REFERENCE TO StGeneral;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION OvervarnishMaxSpeed : REAL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		OverVarnish : REFERENCE TO Opv_typ;
		Belt : REFERENCE TO stBelt;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION OvervarnishMaxMediaLength : UINT (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		OverVarnish : REFERENCE TO Opv_typ;
		Machine : REFERENCE TO StGeneral;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION OverVarnishMaxMediaThickness : UINT (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		OverVarnish : REFERENCE TO Opv_typ;
		Machine : REFERENCE TO StGeneral;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION OverVarnishMinMediaThickness : UINT (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		OverVarnish : REFERENCE TO Opv_typ;
		Machine : REFERENCE TO StGeneral;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION OvervarnishMaxMediaWidth : UINT (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		OverVarnish : REFERENCE TO Opv_typ;
		Machine : REFERENCE TO StGeneral;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION StackerMaxSpeed : REAL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Stacker : REFERENCE TO Stacker_typ;
		Belt : REFERENCE TO stBelt;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION StackerMaxMediaLength : UINT (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Stacker : REFERENCE TO Stacker_typ;
		Machine : REFERENCE TO StGeneral;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION StackerMaxMediaThickness : UINT (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Stacker : REFERENCE TO Stacker_typ;
		Machine : REFERENCE TO StGeneral;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION StackerMinMediaThickness : UINT (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Stacker : REFERENCE TO Stacker_typ;
		Machine : REFERENCE TO StGeneral;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION StackerMaxMediaWidth : UINT (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Stacker : REFERENCE TO Stacker_typ;
		Machine : REFERENCE TO StGeneral;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION SarmMaxSpeed : REAL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Sarm : REFERENCE TO Sarm_typ;
		Belt : REFERENCE TO stBelt;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION SarmMaxMediaThickness : UINT (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Sarm : REFERENCE TO Sarm_typ;
		Machine : REFERENCE TO StGeneral;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION SarmMinMediaThickness : UINT (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Sarm : REFERENCE TO Sarm_typ;
		Machine : REFERENCE TO StGeneral;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION SarmMaxMediaLength : UINT (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Sarm : REFERENCE TO Sarm_typ;
		Machine : REFERENCE TO StGeneral;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION SarmMaxMediaWidth : UINT (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Sarm : REFERENCE TO Sarm_typ;
		Machine : REFERENCE TO StGeneral;
	END_VAR
END_FUNCTION
