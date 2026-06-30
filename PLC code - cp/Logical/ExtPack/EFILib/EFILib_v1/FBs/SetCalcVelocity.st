
(* TODO: Add your comment here *)
FUNCTION_BLOCK SetCalcVelocity
	
	xChange:= FALSE;
	IF xEnMov THEN	
		rSpeedInUnits := rSpeed / Mmin_TO_DriveUnitsRatio(rDiameter:=rAxisDiamter, rGearBox:=rReduction, rUnitsPerTurn:=rUnitsAtTheLoad); 
	END_IF;
		
	// Trigger if change SP to a different value. Remove the activation of xChange when removing xEnMov input signal
	IF rSpeedInUnits <> rLastSpeedInUnits OR EDGEPOS(xEnMov) THEN
		xChange:= TRUE;
		rLastSpeedInUnits:=rSpeedInUnits;
	END_IF;
	
	
END_FUNCTION_BLOCK
