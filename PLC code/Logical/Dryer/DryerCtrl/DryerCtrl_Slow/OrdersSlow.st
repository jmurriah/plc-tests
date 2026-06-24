
ACTION OrdersSlow: 

	gThicknessCtrl.parameters.ContinuousMedia.MediaData.iLine := 1;
	gThicknessCtrl.parameters.ContinuousMedia.MediaData.rWidth := gDryer.Pt.SW.Media.rWidth;
	gThicknessCtrl.parameters.ContinuousMedia.MediaData.rLength := gDryer.Pt.SW.Media.rLength;
	gThicknessCtrl.parameters.ContinuousMedia.MediaData.rCrossOffset := gDryer.Pt.SW.Media.rCrossOffset;
	gThicknessCtrl.parameters.ContinuousMedia.MediaData.rDocWidth := gDryer.Pt.SW.Media.rDocWidth;
	gThicknessCtrl.parameters.ContinuousMedia.MediaData.rDocLength := gDryer.Pt.SW.Media.rDocLength;
	gThicknessCtrl.parameters.ContinuousMedia.MediaData.rDocCrossOffset := gDryer.Pt.SW.Media.rDocCrossOffset;
	
	IF gDryer.St.AutoLocation.xRemote THEN
		gThicknessCtrl.parameters.CheckMedia[1].xActive := gDryerRemoteData.Parameters.xPrinterBeltRuning AND NOT gDryerRemoteData.Parameters.xLineEmptyingBelt; //NOZOMITWO-2447
		gThicknessCtrl.parameters.CheckMedia[2].xActive := gDryerRemoteData.Parameters.xPrinterBeltRuning AND NOT gDryerRemoteData.Parameters.xLineEmptyingBelt AND gDryer.Pt.SW.xDoubleLine; //NOZOMITWO-2447
	ELSE
		gThicknessCtrl.parameters.CheckMedia[1].xActive := TRUE;								//NOZOMITWO-2424
		gThicknessCtrl.parameters.CheckMedia[2].xActive := gDryer.Pt.SW.xDoubleLine;			//NOZOMITWO-2424
	END_IF
	
	IF NOT gDryer.St.AutoLocation.xRemote THEN
		gDryer.Pt.SW.Media.rCrossOffset := (-1) * gDryer.Pt.SW.Media.rWidth / 2;
		gDryer.Pt.SW.Media.rDocLength := gDryer.Pt.SW.Media.rLength;
		gDryer.Pt.SW.Media.rDocWidth := gDryer.Pt.SW.Media.rWidth;
		gDryer.Pt.SW.Media.rDocCrossOffset := gDryer.Pt.SW.Media.rCrossOffset;
	END_IF	
	
	ThermalInertia;
	
	IF gThicknessCtrl.parameters.Dry.iMinDryValue <= 0 THEN
		gThicknessCtrl.parameters.Dry.iMinDryValue := 8;
	END_IF
	
END_ACTION



ACTION ThermalInertia: 

	/////////////////////////////////////////////////////////////////
	///// THERMAL INERTIA	THERMAL INERTIA		THERMAL INERTIA	/////
	/////////////////////////////////////////////////////////////////
	
	// Check initial data
	IF gDryer.Pt.ThermalInertia.iBoardsToStartReducing = 0 OR
		gDryer.Pt.ThermalInertia.iBoardsToMaxPowerReduction = 0 OR
		gDryer.Pt.ThermalInertia.iBoardsToStartReducing >= gDryer.Pt.ThermalInertia.iBoardsToMaxPowerReduction OR
		gDryer.Pt.ThermalInertia.rMaxPowerReduction > 1 THEN
		
				rThermalInerciaReduction := 1;
				gThicknessCtrl.parameters.Dry.rThermalInerciaReduction := rThermalInerciaReduction;
				RETURN;
	END_IF
	
	// Initial data and step calculation
	IF NOT gNirAdphos.Signals.Out.xProcess THEN
		rThermalInerciaReduction := 1;
		rThermalInerciaStepReduction := (1- gDryer.Pt.ThermalInertia.rMaxPowerReduction)/(gDryer.Pt.ThermalInertia.iBoardsToMaxPowerReduction - gDryer.Pt.ThermalInertia.iBoardsToStartReducing);
		iBoardsAtStartDryingL1 := gThicknessCtrl.status.Detection.iBoardsFromStartL1;
	END_IF

	iBoardsFromStartL1 := gThicknessCtrl.status.Detection.iBoardsFromStartL1 - iBoardsAtStartDryingL1;
	
	IF iBoardsFromStartL1 > gDryer.Pt.ThermalInertia.iBoardsToStartReducing AND iBoardsFromStartL1 <= gDryer.Pt.ThermalInertia.iBoardsToMaxPowerReduction THEN
		rThermalInerciaReduction := 1 - rThermalInerciaStepReduction * (iBoardsFromStartL1 - gDryer.Pt.ThermalInertia.iBoardsToStartReducing);
	ELSIF iBoardsFromStartL1 > gDryer.Pt.ThermalInertia.iBoardsToMaxPowerReduction THEN
		rThermalInerciaReduction := gDryer.Pt.ThermalInertia.rMaxPowerReduction;
	END_IF
	
	gThicknessCtrl.parameters.Dry.rThermalInerciaReduction := rThermalInerciaReduction;
	
END_ACTION
