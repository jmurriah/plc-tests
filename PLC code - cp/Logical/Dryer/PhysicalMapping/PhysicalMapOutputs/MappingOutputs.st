
PROGRAM _CYCLIC
	
	CASE gDryer.Pt.MachineModel OF
		DryerType_NOZ2_NIR,
		DryerType_NOZ2_NIR_ARCLAMP:
			OutputsDryerNoz2;

	END_CASE
	
END_PROGRAM
