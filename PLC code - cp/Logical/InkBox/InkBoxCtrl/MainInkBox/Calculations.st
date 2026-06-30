
ACTION CalculatePowerPerCabinet: 

	//If the Cabinet do not exist, do nothing
	IF NOT gInkBox.Status.Cabinets[iCabinet].xExists THEN
		RETURN;
	END_IF
	
	rPowerPerCabinet := 0;
	FOR iIndex := 1 TO gInkBox.Parameters.Cabinets[iCabinet].TotalInkSystems DO
		rPowerPerCabinet := rPowerPerCabinet + (gInks[iInkIndex].status.Temp.rDutyCycleTemp/100) * gInks[iInkIndex].parameters.parBar.iPowerTempWatt;
		xaExistingInks[iInkIndex] := TRUE;
		iInkIndex := iInkIndex + 1;
	END_FOR
	gInkBox.Status.Cabinets[iCabinet].rTotalAskedPower := rPowerPerCabinet;

END_ACTION

ACTION AssignPowerPerCabinet:
	
	//If the Cabinet do not exist, do nothing
	IF NOT gInkBox.Status.Cabinets[iCabinet].xExists THEN
		gInkBox.Status.Cabinets[iCabinet].rPowerReduction := 0;
		RETURN;
	END_IF
	
	//Calculate the reduction in power per cabinet
	IF gInkBox.Status.Cabinets[iCabinet].rTotalAskedPower = 0 THEN
		rCabinetReductionTempPower := 1.0;
	ELSE
		rMaxTempPower := gInkBox.Parameters.Cabinets[iCabinet].MaxTempPowerPsu / gInkBox.Parameters.Cabinets[iCabinet].TotalInksPerPsu;
		rCabinetReductionTempPower:= rMaxTempPower / gInkBox.Status.Cabinets[iCabinet].rTotalAskedPower ;
		rCabinetReductionTempPower:= MIN(rCabinetReductionTempPower, 1.0);
	END_IF
	gInkBox.Status.Cabinets[iCabinet].rPowerReduction := rCabinetReductionTempPower;
		
	//Assign reduction to inks in cabinet
	FOR iIndex := 1 TO gInkBox.Parameters.Cabinets[iCabinet].TotalInkSystems DO
		gInks[iInkIndex].parameters.Temp.rReductionTempPower:=rCabinetReductionTempPower;
		iInkIndex := iInkIndex + 1;
	END_FOR

END_ACTION