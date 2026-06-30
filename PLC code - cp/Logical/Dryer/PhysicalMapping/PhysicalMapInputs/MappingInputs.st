
PROGRAM _CYCLIC
	
	//If in automation runtime, do not assign physical mapping
	IF gDryer.St.HwData.Family = FAMILY_BRAUTOMATIONRUNTIME THEN
		RETURN;
	END_IF

	CASE gDryer.Pt.MachineModel OF
		DryerType_NOZ2_NIR,
		DryerType_NOZ2_NIR_ARCLAMP:
			InputsDryerNoz2;
		
	END_CASE

END_PROGRAM
