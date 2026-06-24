PROGRAM _INIT

END_PROGRAM

PROGRAM _CYCLIC

	nonCrash ACCESS ADR(gNonCrash[iNonCrashSimIndex]);
	nonCrashSim ACCESS ADR(gSimNonCrash[iNonCrashSimIndex]);

	IF nonCrashSim.Commands.xRaiseAlrComsDrive THEN
		nonCrash.Alarms.xAlrComsDrive := TRUE;
	END_IF
	
	IF nonCrashSim.Commands.xRaiseAlrDiffContact THEN
		nonCrash.Alarms.xAlrDiffContact := TRUE;
	END_IF
	
	IF nonCrashSim.Commands.xRaiseAlrDriveError THEN
		nonCrash.Alarms.xAlrDriveError := TRUE;
	END_IF
	
	IF nonCrashSim.Commands.xRaiseAlrOvertorque THEN
		nonCrash.Alarms.xAlrOvertorque := TRUE;
	END_IF
	
	IF nonCrashSim.Commands.xRaiseControllerNotReady THEN
		nonCrash.Alarms.xControllerNotReady := TRUE;
	END_IF
	
	//Increase the index for simulating the next item
	iNonCrashSimIndex := iNonCrashSimIndex +1;
		
END_PROGRAM
