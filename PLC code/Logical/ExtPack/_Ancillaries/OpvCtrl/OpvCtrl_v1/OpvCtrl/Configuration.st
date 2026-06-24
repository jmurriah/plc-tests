
ACTION Configuration: 

	CASE OverVarnish.Status.OpvType OF
		OPVTY_GIARDINA:
			OverVarnish.Parameters.Hw.iMaxMediaWidth := 1800;
			OverVarnish.Parameters.Hw.iMaxMediaLength := 3000;
			OverVarnish.Parameters.Hw.rOPVLength := 3000;
			OverVarnish.Parameters.Hw.iMinMediaThickness := 8;
			OverVarnish.Parameters.Hw.iMaxMediaThickness := 160;
			OverVarnish.Parameters.Hw.xDoubleLineAllowed := TRUE;
					
		OPVTY_DMS:
			OverVarnish.Parameters.Hw.iMaxMediaWidth := 1800;
			OverVarnish.Parameters.Hw.iMaxMediaLength := 3000;
			OverVarnish.Parameters.Hw.rOPVLength := 3000;
			OverVarnish.Parameters.Hw.iMinMediaThickness := 1;
			OverVarnish.Parameters.Hw.iMaxMediaThickness := 150;
			OverVarnish.Parameters.Hw.xDoubleLineAllowed := TRUE;
		
		OPVTY_TECLIGHTING:
			OverVarnish.Parameters.Hw.iMaxMediaWidth := 1800;
			OverVarnish.Parameters.Hw.iMaxMediaLength := 3200;
			OverVarnish.Parameters.Hw.rOPVLength := 2500;
			OverVarnish.Parameters.Hw.iMinMediaThickness := 3;
			OverVarnish.Parameters.Hw.iMaxMediaThickness := 120;
			OverVarnish.Parameters.Hw.xDoubleLineAllowed := FALSE;
			
	END_CASE
	
END_ACTION

