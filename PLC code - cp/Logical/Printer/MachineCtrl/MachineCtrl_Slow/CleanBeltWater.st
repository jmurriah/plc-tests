
ACTION CleanBeltWater:
	
	//To review if gBeltClean package will be used without line
	
	gBeltClean.Parameters.Mode := gMachine.St.Mode;
	gBeltClean.Parameters.rBeltSpeed := gBelt.states.rCurrentSpeed;
	gBeltClean.Parameters.xBeltRunning := gBelt.states.xRuningBelt;
	gBeltClean.Parameters.xBeltEmpty := gThicknessCtrl.status.Belt.xBeltEmpty;
	gMachine.St.CleaningBelt.xCleaningProcessOnGoing := gBeltClean.Status.xCleaning;
	IF gMachine.commands.CleanBelt.xStart AND gBeltClean.Status.xCleanRequested THEN 
		gBeltClean.Commands.xAcceptRequest := TRUE;
	END_IF
	gBeltClean.Inputs.xEnteringMedia := EDGEPOS (gMachine.St.ProductDetect.xProductDetectL1);
	gBeltClean.Commands.xMute := gMachine.AutoCmd.xMuteAlarms;
	gBeltClean.Commands.xReset := gMachine.AutoCmd.xReset;
	gMachine.commands.CleanBelt := ResetCleanBeltCommands;
	gMachine.parSw.CleanBelt.iBeltSpeed := REAL_TO_UINT(gBeltClean.ParSw.rCleanBeltSpeed);
	
	//outputs
	gMachine.commands.CleanBelt.xPistonFlojet := gBeltClean.Outputs.xRiseCleaningSystem;
	gMachine.commands.CleanBelt.xCleanBeltPump := gBeltClean.Outputs.xPumpOn;
	//gBeltClean.Outputs.xAirTurbineOn Directly on Outputs
	//gBeltClean.Outputs.xAirTurbineVSDReset Directly on Outputs

END_ACTION
