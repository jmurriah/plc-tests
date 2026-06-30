
ACTION Doors: 

	// AND REASONS
	iReasonReleaseDoors.0 := gDryer.St.Mode.xZero;
	iReasonReleaseDoors.1 := gNirAdphos.Status.rSurfaceTempModule[1] < 40 OR gDryer.In.xOpenDoorsKey;
	iReasonReleaseDoors.2 := gNirAdphos.Status.rSurfaceTempModule[2] < 40 OR gDryer.In.xOpenDoorsKey;
	xReleaseDoors := iReasonReleaseDoors >= 2#00111;
	
	// AND REASONS
	iReasonLockDoors.0 := gDryer.St.Mode.xAuto;
	xLockDoors := iReasonLockDoors >= 2#00001;
	
	IF xReleaseDoors (*AND gDryer.commands.xUnlockDoors*) THEN
		gDryer.Out.xLockFrontDoor := FALSE;
		gDryer.Out.xLockRearDoor := FALSE;
	END_IF

	IF xLockDoors THEN
		gDryer.Out.xLockFrontDoor := TRUE;
		gDryer.Out.xLockRearDoor := TRUE;
	END_IF

	//Just as an edge command
	gDryer.commands.xUnlockDoors := FALSE;
	
END_ACTION
