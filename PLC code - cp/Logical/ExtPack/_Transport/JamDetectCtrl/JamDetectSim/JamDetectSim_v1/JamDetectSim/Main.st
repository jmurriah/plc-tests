
PROGRAM _CYCLIC
	(* Insert code here *)
	 
	JamDetectData  ACCESS ADR(gJamDetect[usiJamDetectSimIndex]);
	JamDataSim ACCESS ADR(gSimJamDetect[usiJamDetectSimIndex]);
	
	IF NOT JamDetectData.Parameters.xJamEnabled THEN
		usiJamDetectSimIndex := usiJamDetectSimIndex +1;
		RETURN;
	END_IF

	JamDetectData.Inputs.xJamCrash[1]:=JamDetectData.Parameters.xBarInstalled[1] AND NOT JamDataSim.Commands.CreateCrash[1];
	JamDetectData.Inputs.xJamCrash[2]:=JamDetectData.Parameters.xBarInstalled[2] AND NOT JamDataSim.Commands.CreateCrash[2];
	JamDetectData.Inputs.xJamCrash[3]:=JamDetectData.Parameters.xBarInstalled[3] AND NOT JamDataSim.Commands.CreateCrash[3];
	JamDetectData.Inputs.xJamCrash[4]:=JamDetectData.Parameters.xBarInstalled[4] AND NOT JamDataSim.Commands.CreateCrash[4];
	
	//Tests
	
	tonTestDelay.IN :=	(JamDetectData.Outputs.xJamTestSignal[1]  AND NOT JamDataSim.Commands.ErrorInTest[1]) OR
						(JamDetectData.Outputs.xJamTestSignal[2]  AND NOT JamDataSim.Commands.ErrorInTest[2]) OR 
						(JamDetectData.Outputs.xJamTestSignal[3]  AND NOT JamDataSim.Commands.ErrorInTest[3]) OR 
						(JamDetectData.Outputs.xJamTestSignal[4]  AND NOT JamDataSim.Commands.ErrorInTest[4]);
	tonTestDelay.PT := T#1s;
	tonTestDelay();
	JamDetectData.Inputs.xJamTestOk := tonTestDelay.Q;
	
	
	usiJamDetectSimIndex := usiJamDetectSimIndex + 1;

END_PROGRAM


