
ACTION Configuration: 

	CASE Primer.Status.PrimerType OF
		PRIMERTY_GIARDINA:
			Primer.Parameters.Hw.iMaxMediaWidth := 1800;
			Primer.Parameters.Hw.iMaxMediaLength := 3000;
			Primer.Parameters.Hw.rPrimerLength := 3000;
			Primer.Parameters.Hw.iMinMediaThickness := 8;
			Primer.Parameters.Hw.iMaxMediaThickness := 160;
			Primer.Parameters.Hw.xDoubleLineAllowed := TRUE;
					
		PRIMERTY_DMS:
			Primer.Parameters.Hw.iMaxMediaWidth := 1800;
			Primer.Parameters.Hw.iMaxMediaLength := 3000;
			Primer.Parameters.Hw.rPrimerLength := 3000;
			Primer.Parameters.Hw.iMinMediaThickness := 10;
			Primer.Parameters.Hw.iMaxMediaThickness := 150;
			Primer.Parameters.Hw.xDoubleLineAllowed := TRUE;
		
		PRIMERTY_TECLIGHTNING:
			Primer.Parameters.Hw.iMaxMediaWidth := 1800;
			Primer.Parameters.Hw.iMaxMediaLength := 3200;
			Primer.Parameters.Hw.rPrimerLength := 3000;
			Primer.Parameters.Hw.iMinMediaThickness := 3;
			Primer.Parameters.Hw.iMaxMediaThickness := 120;
			Primer.Parameters.Hw.xDoubleLineAllowed := FALSE;
			
	END_CASE
	
END_ACTION

