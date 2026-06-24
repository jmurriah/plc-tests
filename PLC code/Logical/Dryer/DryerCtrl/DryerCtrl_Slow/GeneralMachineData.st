ACTION GeneralMachineData:
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// BELT PARAMS      BELT PARAMS      BELT PARAMS      BELT PARAMS      BELT PARAMS      BELT PARAMS      BELT PARAMS
	// BELT PARAMS      BELT PARAMS      BELT PARAMS      BELT PARAMS      BELT PARAMS      BELT PARAMS      BELT PARAMS
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// Cleaning Belt limits cannot be lower than 1
	// Cleaning Belt parameters. Clean Belt disabled/enabled after delay
	tiCleaningBeltByTime	:= MINUTES_TO_TIME(gDryer.Pt.SW.CleanBelt.iCleaningBeltByTime);
	iSPTilesToCleanBelt		:= MAX (gDryer.Pt.SW.CleanBelt.iSPTilesToCleanBelt, MIN_TILES_FOR_CLEANING_BELT);	
	
	////////// Belt Limits //////////////////////////////////	
	//[RGP] Sending speed setpoint to gBelt. Not assigned directly from SW so maybe in the future SpeedSetpoint need to be used outside BeltPackage/BeltManager.
	//As done in previous lines by limiting maximum belt speed. //Not been able to have a Zero value in the SetPointSpeed
	gBelt.parameters.rSetPointSpeed := LIMIT(5.0, gDryer.Pt.SW.rBeltSpeedSetPoint, gDryer.Pt.SW.Safety.rMaxBeltSpeedSetPoint);
	
	// It gets belt direction following if machine configuration is left or right
	gBelt.parameters.Direction:= NOT gDryer.Pt.SW.xMachineDirection;

	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// MODEL
	////////////////////////////////////////////////////////////////////////////////////////////////////////////

	// Jetting Gap limits
	gDryer.Pt.SW.Media.rMargin:= LIMIT(gDryer.Pt.CT.rMinMargin,gDryer.Pt.SW.Media.rMargin,gDryer.Pt.CT.rMaxMargin);

	// Piece Tickness	
	gDryer.Pt.SW.Media.rThickness:= LIMIT(gDryer.Pt.CT.rMinThicknessMedia,gDryer.Pt.SW.Media.rThickness,gDryer.Pt.CT.rMaxThicknessMedia);


	// Counters of shots printed by PD or by simulation
	//Counting out of any FOR. Makes no sense
	IF EDGEPOS (gDryer.St.xProductDetectL1) THEN 
		gDryer.Lg.udiPiecesCounterL1:= gDryer.Lg.udiPiecesCounterL1+1;	
	END_IF

	IF EDGEPOS (gDryer.St.xProductDetectL2) THEN
		gDryer.Lg.udiPiecesCounterL2:= gDryer.Lg.udiPiecesCounterL2+1;
	END_IF	
	
	// Machine conversions
	gDryer.Lg.udiDifCounters:=0;
	

END_ACTION