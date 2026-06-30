
(* TODO: Add your comment here *)
FUNCTION Mmin_TO_DriveUnitsRatio
	
	//Protection of values to avoid infinite values
	rDiameter := MAX(rDiameter, 10);
	IF rGearBox = 0 THEN rGearBox:=1; END_IF
	
	Mmin_TO_DriveUnitsRatio:=(60 * rDiameter) / (1000 * rGearBox * rUnitsPerTurn);

END_FUNCTION
