ACTION Precalculations:
	
	//To acknowledge whether media thickess has changed
	xMediaThicknessModified := 	rPrevMediaThickness <> gMachine.parSw.Media.rThickness;
	
	tonEnterSafety.IN := gMachine.In.xSafetyEnabled;
	tonEnterSafety.PT := T#1000ms;
	tonEnterSafety();
	xEdgeSafety := EDGEPOS(tonEnterSafety.Q);

	xBeltMovingPreviousToStop := gBelt.commands.xRunBelt;
	
END_ACTION


