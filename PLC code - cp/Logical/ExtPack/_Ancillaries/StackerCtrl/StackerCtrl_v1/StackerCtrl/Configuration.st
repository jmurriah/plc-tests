
ACTION Configuration: 

	rMediaThickness := MAX(0, Stacker.Parameters.Media.rThickness);
	
	CASE Stacker.Status.StackerType OF
				
		STACKERTY_FULL_S:
			
			Stacker.Parameters.Hw.rStackerLength := 15000;
			
			//Media
			Stacker.Parameters.Hw.iMaxMediaWidth := 1800;
			Stacker.Parameters.Hw.iMaxMediaLength := 3000;
			Stacker.Parameters.Hw.iMinMediaThickness := 10;
			Stacker.Parameters.Hw.iMaxMediaThickness := 120;
			Stacker.Parameters.Hw.xDoubleLineAllowed := TRUE;
			
			//Stack
			Stacker.Parameters.Hw.iMinStackHeight := REAL_TO_UINT(iMinStackBoards*rMediaThickness);
			Stacker.Parameters.Hw.iMaxStackHeight := 1800;
			
			Stacker.Parameters.Hw.iMinStackBoards := 15;
			Stacker.Parameters.Hw.iMaxStackBoards := REAL_TO_UINT(UINT_TO_REAL(Stacker.Parameters.Hw.iMaxStackHeight)/rMediaThickness);
			
			//Reject
			Stacker.Parameters.Hw.xThereIsReject := TRUE;
			Stacker.Parameters.Hw.xRejectEjectionAvailable := TRUE;
			Stacker.Parameters.Hw.iRejectAdjustmentDistance := 12;
			Stacker.Parameters.Hw.iDistanceToReject := 230; //Measured in SN3 while debugging
					
		STACKERTY_BUNDLE_S:
			
			Stacker.Parameters.Hw.rStackerLength := 10000;
			
			//Media
			Stacker.Parameters.Hw.iMaxMediaWidth := 1670;
			Stacker.Parameters.Hw.iMaxMediaLength := 2440;
			Stacker.Parameters.Hw.iMinMediaThickness := 8;
			Stacker.Parameters.Hw.iMaxMediaThickness := 160;
			Stacker.Parameters.Hw.xDoubleLineAllowed := TRUE;
						
			//Stack
			Stacker.Parameters.Hw.iMinStackHeight := REAL_TO_UINT(iMinStackBoards*rMediaThickness);
			Stacker.Parameters.Hw.iMaxStackHeight := 300;
			Stacker.Parameters.Hw.iMinStackBoards := 15;
			Stacker.Parameters.Hw.iMaxStackBoards := REAL_TO_UINT(UINT_TO_REAL(Stacker.Parameters.Hw.iMaxStackHeight)/rMediaThickness);
			
			//Reject
			Stacker.Parameters.Hw.xThereIsReject := TRUE;
			Stacker.Parameters.Hw.xRejectEjectionAvailable := FALSE;			
			Stacker.Parameters.Hw.iRejectAdjustmentDistance := 0;
			Stacker.Parameters.Hw.iDistanceToReject := 0; //TBD: Pending to debug in bundle stacker
			
	END_CASE
	
END_ACTION

