
ACTION inkLevel: 
	
	IF tonInkLevelAboveMinimum.Q THEN
		inks.status.Tank.xMinLevel := TRUE;
	END_IF
	IF tonInkLevelBelowMinimum.Q THEN
		inks.status.Tank.xMinLevel := FALSE;
	END_IF
	
	IF tonInkLevelAboveMinimum.Q THEN
		inks.status.Tank.xCloseToMinLevel := TRUE;
	END_IF
	IF tonInkLevelBelowCloseMinimum.Q THEN
		inks.status.Tank.xCloseToMinLevel := FALSE;
	END_IF
	
	IF tonInkLevelAboveMaximum.Q THEN
		inks.status.Tank.xMaxLevel := TRUE;
	END_IF
	IF tonInkLevelBelowMaximum.Q THEN
		inks.status.Tank.xMaxLevel := FALSE;
	END_IF	
	
	//0=Empty ; 1=Min; 2=Full; 3=Non valid level
	IF parBar.xTypeTankSensorDigital THEN

		tonInkLevelAboveMaximum(IN:= inks.signals.in.xMaxLevel, PT:=T#35s);
		tonInkLevelBelowMaximum(IN:= NOT inks.signals.in.xMaxLevel, PT:=T#1m);

		tonInkLevelBelowCloseMinimum(IN:= NOT inks.signals.in.xMinLevel, PT:=T#10s);

		tonInkLevelAboveMinimum(IN:= inks.signals.in.xMinLevel, PT:=T#35s);
		tonInkLevelBelowMinimum(IN:= NOT inks.signals.in.xMinLevel, PT:=T#1m);

		IF NOT inks.status.Tank.xMinLevel AND NOT inks.status.Tank.xMaxLevel THEN inks.status.Tank.iStatusTankDigital := 0; END_IF
		IF inks.status.Tank.xMinLevel AND NOT inks.status.Tank.xMaxLevel THEN 	inks.status.Tank.iStatusTankDigital := 1; END_IF
		IF inks.status.Tank.xMinLevel AND inks.status.Tank.xMaxLevel THEN 		inks.status.Tank.iStatusTankDigital := 2; END_IF
		IF NOT inks.status.Tank.xMinLevel AND inks.status.Tank.xMaxLevel THEN 	inks.status.Tank.iStatusTankDigital := 3; END_IF
	
	ELSE
		inks.status.Tank.iStatusTankDigital := 3;
		
		tonInkLevelAboveMaximum(IN:= inks.status.Tank.iDipositLevel>42, PT:=T#10s);
		tonInkLevelBelowMaximum(IN:= inks.status.Tank.iDipositLevel<40, PT:=T#10s);
		
		// Ink level can have 1% of change by bars movement, so 7% with 4% is more robust
		tonInkLevelBelowCloseMinimum(IN:= inks.status.Tank.iDipositLevel<=7, PT:=T#10s);
		
		tonInkLevelAboveMinimum(IN:= inks.status.Tank.iDipositLevel>9, PT:=T#10s);
		tonInkLevelBelowMinimum(IN:= inks.status.Tank.iDipositLevel<4, PT:=T#10s);
	END_IF

	
	//NOTE: When implement xTypeTankSensorAnalog, reset xMinLevel and xMaxLevel from Digital
	
END_ACTION
