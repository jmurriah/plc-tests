
ACTION Media: 

	IF gThicknessCtrl.status.xNewMediaStackEnabled THEN
		gSimMachine.Parameters.Stack.iMediaQuantityToKeepLoaded := 4;
		gSimMachine.Parameters.Stack.xLoadNewMedia := TRUE;
	END_IF
	
	
	IF EDGEPOS(gSimMachine.Commands.Media.xMediaPresent) THEN
		IF gDing.State.xDingInstalled THEN
			gDing.In.rHighDingMm := gSimMachine.Commands.Media.rMediaThickness;
			gDing.In.xDingLow:=TRUE;
			
		ELSIF gPhotoCells.status.xInstalled THEN
			gPhotoCells.Inputs.Signals.xPhotoCells[1] := TRUE;
		END_IF
		IF gThicknessCtrl.parameters.Detection.ProductDetect.xLoadMedia THEN
			gSimMachine.Signals.xProductDetectL1 := TRUE;
		END_IF
	END_IF
	
	IF EDGENEG(gSimMachine.Commands.Media.xMediaPresent) THEN
		IF gDing.State.xDingInstalled THEN
			gDing.In.rHighDingMm := 0;
			gDing.In.xDingLow:=FALSE;
			
		ELSIF gPhotoCells.status.xInstalled THEN
			gPhotoCells.Inputs.Signals.xPhotoCells[1] := FALSE;
		END_IF
		IF gThicknessCtrl.parameters.Detection.ProductDetect.xLoadMedia THEN
			gSimMachine.Signals.xProductDetectL1 := FALSE;
		END_IF
	END_IF
	
	//Boards entering the printer constantly
	iReasonToContinuousMedia.0 := gSimMachine.Commands.Media.xContinuousMediaPresent;
	iReasonToContinuousMedia.1 := gSimMachine.Commands.Media.xMediaIfFeederFeeding AND gFeeder.Status.CtrlStatus=FEEDERCTRL_FEEDING;
	iReasonToContinuousMedia.2 := gSimMachine.Commands.xStain;
	
	// Storing previous value
	IF EDGEPOS(iReasonToContinuousMedia > 0 AND gBelt.states.xRuningBelt) THEN
		gDingInputPreviousValue := gDing.In.rHighDingMm;
	END_IF
	
		
	xBeltSpeedChanged := rPrevBeltSpeed <> gBelt.states.rCurrentSpeed;
	xFormatChanged := 	rPrevBoardLength <> gMachine.parSw.Media.rLength OR
						rPrevBoardGap <> gMachine.parSw.Media.rGap;
	xStainChanged := 	rPrevStainLength <> gSimMachine.Parameters.rStainLength OR
						rPrevStainGap <> gSimMachine.Parameters.rStainGap;
	
	IF (xBeltSpeedChanged OR xFormatChanged OR xStainChanged) AND (gBelt.states.rCurrentSpeed > gc_rMinSpeedToStart) THEN
		rBeltSpeedMmMs := (gBelt.states.rCurrentSpeed/60);
		
		//Board
		tiBoardTime := REAL_TO_TIME(gMachine.parSw.Media.rLength/rBeltSpeedMmMs);
		tiGapTime := REAL_TO_TIME(gMachine.parSw.Media.rGap/rBeltSpeedMmMs);
		
		//Stain
		tiStainLength := REAL_TO_TIME(gSimMachine.Parameters.rStainLength/rBeltSpeedMmMs);
		tiStainGap := REAL_TO_TIME(gSimMachine.Parameters.rStainGap/rBeltSpeedMmMs);
	END_IF
	rPrevBeltSpeed := gBelt.states.rCurrentSpeed;
	rPrevBoardLength := gMachine.parSw.Media.rLength;
	rPrevBoardGap := gMachine.parSw.Media.rGap;
	
	//To simulate a media
	BoardsFeedMinGap.tTimeOn := tiBoardTime;
	BoardsFeedMinGap.tTimeOff := tiGapTime;
	BoardsFeedMinGap.xEnable := iReasonToContinuousMedia > 0 AND gBelt.states.xRuningBelt AND NOT gSimMachine.Commands.xStain;
	BoardsFeedMinGap();
	
	//To simulate a stain over the belt
	Stain.tTimeOn := tiStainLength;
	Stain.tTimeOff := tiStainGap;
	Stain.xEnable := gSimMachine.Commands.xStain;
	Stain();		
		
	IF iReasonToContinuousMedia > 0 AND gBelt.states.xRuningBelt THEN

		IF gDing.State.xDingInstalled THEN
			IF EDGEPOS(BoardsFeedMinGap.xOutput) THEN
				gDing.In.rHighDingMm := gDingInputPreviousValue + gSimMachine.Commands.Media.rMediaThickness;
			ELSIF EDGENEG(BoardsFeedMinGap.xOutput) THEN
				gDing.In.rHighDingMm := gDingInputPreviousValue;
			END_IF
			gDing.In.xDingLow := BoardsFeedMinGap.xOutput OR Stain.xOutput;
			IF gThicknessCtrl.parameters.Detection.ProductDetect.xLoadMedia THEN
				gSimMachine.Signals.xProductDetectL1 := BoardsFeedMinGap.xOutput OR Stain.xOutput;
			END_IF			
			
		ELSIF gPhotoCells.status.xInstalled THEN
			gPhotoCells.Inputs.Signals.xPhotoCells[1] := BoardsFeedMinGap.xOutput;
			IF gThicknessCtrl.parameters.Detection.ProductDetect.xLoadMedia THEN
				gSimMachine.Signals.xProductDetectL1 := BoardsFeedMinGap.xOutput OR Stain.xOutput;
			END_IF
		END_IF
		
		//Rush proof
		IF gSimMachine.Commands.Media.xRushProof AND EDGEPOS(BoardsFeedMinGap.xOutput) THEN
			gThicknessCtrl.Commands.xRushProof := TRUE;
			//ELSIF NOT BoardsFeedMinGap.xOutput THEN
		ELSIF EDGENEG(gSimMachine.Commands.Media.xRushProof) THEN
			gThicknessCtrl.Commands.xRushProof := FALSE;
		END_IF
	END_IF
	
	IF EDGEPOS(iReasonToContinuousMedia = 0) THEN
		gDing.In.xDingLow := FALSE;
		gPhotoCells.Inputs.Signals.xPhotoCells[1] := FALSE;
		gSimMachine.Signals.xProductDetectL1 := FALSE;
		gThicknessCtrl.Commands.xRushProof := FALSE;
	END_IF
	
	

	
	
END_ACTION
