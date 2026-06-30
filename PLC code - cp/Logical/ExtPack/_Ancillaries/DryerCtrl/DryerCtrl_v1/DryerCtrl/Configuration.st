
ACTION Configuration: 

	CASE Dryer.Status.DryerType OF
		DRYERTY_EFI:
			Dryer.Parameters.Hw.iMaxMediaWidth := 1800;
			Dryer.Parameters.Hw.iMaxMediaLength := 3000;
			Dryer.Parameters.Hw.rDryerLength := 5000.0;
			Dryer.Parameters.Hw.xDoubleLineAllowed := TRUE;
			
	END_CASE
	
END_ACTION

