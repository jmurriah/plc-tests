
ACTION Configuration: 

	CASE Sarm.Status.SarmType OF
		SARMTY_V1:
			// Initial values from OMM-00218_Nozomi_18000+_LED_SARM_Reference_Guide_E1 Document
			Sarm.Parameters.Hw.iMaxMediaWidth := 1800;
			Sarm.Parameters.Hw.iMaxMediaLength := 3200;
			Sarm.Parameters.Hw.iMinMediaThickness := 2;
			Sarm.Parameters.Hw.iMaxMediaThickness := 350;
			Sarm.Parameters.Hw.rSarmLength 	:= 3500;
			Sarm.Parameters.Hw.xDoubleLineAllowed := FALSE;
	END_CASE
	
END_ACTION

