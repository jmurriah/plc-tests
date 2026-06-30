
ACTION ResetRouterAndCB: 

	// Reset Router		
	tof_ResetRouter.IN:=gMachine.commands.xResetRouter;
	tof_ResetRouter.PT:= T#6s;
	tof_ResetRouter();
	gMachine.commands.xResetRouter:= FALSE;

	gMachine.Out.xResetRouter:=tof_ResetRouter.Q;


	// Reset CB1/CB2 (Always together, just one button in interface)		
	tof_ResetCB1.IN:=gMachine.commands.xResetCB;
	tof_ResetCB1.PT:= T#4s;
	tof_ResetCB1();
	gMachine.commands.xResetCB:= FALSE;

	gMachine.Out.xResetCB1:=tof_ResetCB1.Q;
	gMachine.Out.xResetCB2:=tof_ResetCB1.Q;
	

END_ACTION
