
ACTION ResetRouterAndHub: 

	// Reset Router		
	tof_ResetSwitch.IN:=gDryer.commands.xResetSwitch;
	tof_ResetSwitch.PT:= T#6s;
	tof_ResetSwitch();
	gDryer.commands.xResetSwitch:= FALSE;

	gDryer.Out.xResetSwitch := tof_ResetSwitch.Q;


	// Reset Hub
	tof_ResetHub.IN:=gDryer.commands.xResetHub;
	tof_ResetHub.PT:= T#4s;
	tof_ResetHub();
	gDryer.commands.xResetHub:= FALSE;

	gDryer.Out.xResetHub := tof_ResetHub.Q;
	

	// Reset Fan Breaker
	tof_ResetFanBreaker.IN:=gDryer.commands.xResetFanBreaker;
	tof_ResetFanBreaker.PT:= T#2s;
	tof_ResetFanBreaker();
	gDryer.commands.xResetFanBreaker:= FALSE;

	gDryer.Out.xResetFanBreaker := tof_ResetFanBreaker.Q;
	
	
END_ACTION
