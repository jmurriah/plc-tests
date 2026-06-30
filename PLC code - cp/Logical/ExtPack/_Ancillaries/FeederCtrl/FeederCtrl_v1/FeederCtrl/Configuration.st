
ACTION Configuration: 

	CASE Feeder.Status.FeederType OF
		FEEDERTY_BOTTOM_14:
			Feeder.Parameters.Hw.iMaxMediaWidth := 1400;
			Feeder.Parameters.Hw.iMaxMediaLength := 3000;
			Feeder.Parameters.Hw.iMinMediaThickness := 8;
			Feeder.Parameters.Hw.iMaxMediaThickness := 160;
			Feeder.Parameters.Hw.xOffsetAvailable := FALSE;
			Feeder.Parameters.Hw.xDoubleLineAllowed := FALSE;
					
		FEEDERTY_BOTTOM_18:
			Feeder.Parameters.Hw.iMaxMediaWidth := 1800;
			Feeder.Parameters.Hw.iMaxMediaLength := 3000;
			Feeder.Parameters.Hw.iMinMediaThickness := 8;
			Feeder.Parameters.Hw.iMaxMediaThickness := 160;
			Feeder.Parameters.Hw.xOffsetAvailable := TRUE;
			Feeder.Parameters.Hw.iMaxOffset := 15;
			Feeder.Parameters.Hw.iMinOffset := -15;
			Feeder.Parameters.Hw.xDoubleLineAllowed := TRUE;
		
		FEEDERTY_TOP:
			Feeder.Parameters.Hw.iMaxMediaWidth := 1800;
			Feeder.Parameters.Hw.iMaxMediaLength := 3200;
			Feeder.Parameters.Hw.iMinMediaThickness := 2;
			Feeder.Parameters.Hw.iMaxMediaThickness := 350;
			Feeder.Parameters.Hw.xOffsetAvailable := FALSE;
			Feeder.Parameters.Hw.xDoubleLineAllowed := TRUE;
			
	END_CASE
	
END_ACTION

