
FUNCTION FeederMaxMediaWidth
	IF Feeder.ParSw.xEnabled THEN FeederMaxMediaWidth:= Feeder.Parameters.Hw.iMaxMediaWidth; ELSE FeederMaxMediaWidth:= Machine.Pt.Hw.iWidth; END_IF
END_FUNCTION

FUNCTION FeederMaxMediaLength
	IF Feeder.ParSw.xEnabled THEN FeederMaxMediaLength:= Feeder.Parameters.Hw.iMaxMediaLength; ELSE FeederMaxMediaLength:= Machine.parSw.Hw.iMaxMediaLength; END_IF
END_FUNCTION

FUNCTION FeederMaxMediaThickness
	IF Feeder.ParSw.xEnabled THEN FeederMaxMediaThickness:= Feeder.Parameters.Hw.iMaxMediaThickness; ELSE FeederMaxMediaThickness:= REAL_TO_UINT(Machine.Pt.CT.rMaxTicknessMedia*10); END_IF
END_FUNCTION

FUNCTION FeederMinMediaThickness
	IF Feeder.ParSw.xEnabled THEN FeederMinMediaThickness:= Feeder.Parameters.Hw.iMinMediaThickness; ELSE FeederMinMediaThickness:= REAL_TO_UINT(Machine.Pt.CT.rMinTicknessMedia*10); END_IF
END_FUNCTION

FUNCTION FeederMaxSpeed
	IF Feeder.Parameters.xInstalled THEN FeederMaxSpeed:= Feeder.Parameters.Hw.rMaxSpeed; ELSE FeederMaxSpeed:= Belt.states.Hw.rMaxSpeed; END_IF
END_FUNCTION

FUNCTION PrimerMaxMediaWidth
	IF Primer.ParSw.xEnabled THEN PrimerMaxMediaWidth:= Primer.Parameters.Hw.iMaxMediaWidth; ELSE PrimerMaxMediaWidth:= Machine.Pt.Hw.iWidth; END_IF
END_FUNCTION

FUNCTION PrimerMaxMediaLength
	IF Primer.ParSw.xEnabled THEN PrimerMaxMediaLength:= Primer.Parameters.Hw.iMaxMediaLength; ELSE PrimerMaxMediaLength:= Machine.parSw.Hw.iMaxMediaLength; END_IF
END_FUNCTION

FUNCTION PrimerMaxMediaThickness
	IF Primer.ParSw.xEnabled THEN PrimerMaxMediaThickness:= Primer.Parameters.Hw.iMaxMediaThickness; ELSE PrimerMaxMediaThickness:= REAL_TO_UINT(Machine.Pt.CT.rMaxTicknessMedia*10); END_IF
END_FUNCTION

FUNCTION PrimerMinMediaThickness
	IF Primer.ParSw.xEnabled THEN PrimerMinMediaThickness:= Primer.Parameters.Hw.iMinMediaThickness; ELSE PrimerMinMediaThickness:= REAL_TO_UINT(Machine.Pt.CT.rMinTicknessMedia*10); END_IF
END_FUNCTION

FUNCTION PrimerMaxSpeed
	IF Primer.Parameters.xInstalled THEN PrimerMaxSpeed:= Primer.Parameters.Hw.rMaxSpeed; ELSE PrimerMaxSpeed:= Belt.states.Hw.rMaxSpeed; END_IF
END_FUNCTION

FUNCTION DryerMaxMediaWidth
	IF Dryer.ParSw.xEnabled THEN DryerMaxMediaWidth:= Dryer.Parameters.Hw.iMaxMediaWidth; ELSE DryerMaxMediaWidth:= Machine.Pt.Hw.iWidth; END_IF
END_FUNCTION

FUNCTION DryerMaxMediaLength
	IF Dryer.ParSw.xEnabled THEN DryerMaxMediaLength:= Dryer.Parameters.Hw.iMaxMediaLength; ELSE DryerMaxMediaLength:= Machine.parSw.Hw.iMaxMediaLength; END_IF
END_FUNCTION

//FUNCTION DryerMaxMediaThickness
//	IF Dryer.ParSw.xEnabled THEN DryerMaxMediaThickness:= Dryer.Parameters.Hw.iMaxMediaThickness; ELSE DryerMaxMediaThickness:= Machine.Pt.CT.rMaxTicknessMedia*10; END_IF
//END_FUNCTION
//
//FUNCTION DryerMinMediaThickness
//	IF Dryer.ParSw.xEnabled THEN DryerMinMediaThickness:= Dryer.Parameters.Hw.iMinMediaThickness; ELSE DryerMinMediaThickness:= Machine.Pt.CT.rMinTicknessMedia*10; END_IF
//END_FUNCTION

FUNCTION DryerMaxSpeed
	IF Dryer.Parameters.xInstalled THEN DryerMaxSpeed:= Dryer.Parameters.Hw.rMaxSpeed; ELSE DryerMaxSpeed:= Belt.states.Hw.rMaxSpeed; END_IF
END_FUNCTION

FUNCTION OvervarnishMaxMediaWidth
	IF OverVarnish.ParSw.xEnabled THEN OvervarnishMaxMediaWidth:= OverVarnish.Parameters.Hw.iMaxMediaWidth; ELSE OvervarnishMaxMediaWidth:= Machine.Pt.Hw.iWidth; END_IF
END_FUNCTION

FUNCTION OvervarnishMaxMediaLength
	IF OverVarnish.ParSw.xEnabled THEN OvervarnishMaxMediaLength:= OverVarnish.Parameters.Hw.iMaxMediaLength; ELSE OvervarnishMaxMediaLength:= Machine.parSw.Hw.iMaxMediaLength; END_IF
END_FUNCTION

FUNCTION OverVarnishMaxMediaThickness
	IF OverVarnish.ParSw.xEnabled THEN OverVarnishMaxMediaThickness:= OverVarnish.Parameters.Hw.iMaxMediaThickness; ELSE OverVarnishMaxMediaThickness:= REAL_TO_UINT(Machine.Pt.CT.rMaxTicknessMedia*10); END_IF
END_FUNCTION

FUNCTION OverVarnishMinMediaThickness
	IF OverVarnish.ParSw.xEnabled THEN OverVarnishMinMediaThickness:= OverVarnish.Parameters.Hw.iMinMediaThickness; ELSE OverVarnishMinMediaThickness:= REAL_TO_UINT(Machine.Pt.CT.rMinTicknessMedia*10); END_IF
END_FUNCTION

FUNCTION OvervarnishMaxSpeed
	IF OverVarnish.Parameters.xInstalled THEN OvervarnishMaxSpeed:= OverVarnish.Parameters.Hw.rMaxSpeed; ELSE OvervarnishMaxSpeed:= Belt.states.Hw.rMaxSpeed; END_IF
END_FUNCTION

FUNCTION StackerMaxMediaWidth
	IF Stacker.ParSw.xEnabled THEN StackerMaxMediaWidth:= Stacker.Parameters.Hw.iMaxMediaWidth; ELSE StackerMaxMediaWidth:= Machine.Pt.Hw.iWidth; END_IF
END_FUNCTION

FUNCTION StackerMaxMediaLength
	IF Stacker.ParSw.xEnabled THEN StackerMaxMediaLength:= Stacker.Parameters.Hw.iMaxMediaLength; ELSE StackerMaxMediaLength:= Machine.parSw.Hw.iMaxMediaLength; END_IF
END_FUNCTION

FUNCTION StackerMaxMediaThickness
	IF Stacker.ParSw.xEnabled THEN StackerMaxMediaThickness:= Stacker.Parameters.Hw.iMaxMediaThickness; ELSE StackerMaxMediaThickness:= REAL_TO_UINT(Machine.Pt.CT.rMaxTicknessMedia*10); END_IF
END_FUNCTION

FUNCTION StackerMinMediaThickness
	IF Stacker.ParSw.xEnabled THEN StackerMinMediaThickness:= Stacker.Parameters.Hw.iMinMediaThickness; ELSE StackerMinMediaThickness:= REAL_TO_UINT(Machine.Pt.CT.rMinTicknessMedia*10); END_IF
END_FUNCTION

FUNCTION StackerMaxSpeed
	IF Stacker.Parameters.xInstalled THEN StackerMaxSpeed:= Stacker.Parameters.Hw.rMaxSpeed; ELSE StackerMaxSpeed:= Belt.states.Hw.rMaxSpeed; END_IF
END_FUNCTION

FUNCTION SarmMaxMediaWidth
	IF Sarm.ParSw.xEnabled THEN SarmMaxMediaWidth:= Sarm.Parameters.Hw.iMaxMediaWidth; ELSE SarmMaxMediaWidth:= Machine.Pt.Hw.iWidth; END_IF
END_FUNCTION

FUNCTION SarmMaxMediaLength
	IF Sarm.ParSw.xEnabled THEN SarmMaxMediaLength:= Sarm.Parameters.Hw.iMaxMediaLength; ELSE SarmMaxMediaLength:= Machine.parSw.Hw.iMaxMediaLength; END_IF
END_FUNCTION

FUNCTION SarmMaxMediaThickness
	IF Sarm.ParSw.xEnabled THEN SarmMaxMediaThickness:= Sarm.Parameters.Hw.iMaxMediaThickness; ELSE SarmMaxMediaThickness:= REAL_TO_UINT(Machine.Pt.CT.rMaxTicknessMedia*10); END_IF
END_FUNCTION

FUNCTION SarmMinMediaThickness
	IF Sarm.ParSw.xEnabled THEN SarmMinMediaThickness:= Sarm.Parameters.Hw.iMinMediaThickness; ELSE SarmMinMediaThickness:= REAL_TO_UINT(Machine.Pt.CT.rMinTicknessMedia*10); END_IF
END_FUNCTION

FUNCTION SarmMaxSpeed
	IF Sarm.Parameters.xInstalled THEN SarmMaxSpeed:= Sarm.Parameters.Hw.rMaxSpeed; ELSE SarmMaxSpeed:= Belt.states.Hw.rMaxSpeed; END_IF
END_FUNCTION