
ACTION ManualMovements:

	IF Block.commands.xBarHomeOrder OR Block.commands.xReset THEN
		RETURN;
	END_IF
	
	// Excessive Motor block activated
	TON_excessiveBlockActivated.IN:= Block.commands.Mode.xManual AND 
									(AxisBK.Command.Jog.ContinuousPos OR 
									AxisBK.Command.Jog.ContinuousNeg OR 
									Block.commands.Manual.xManBarsUp OR 
									Block.commands.Manual.xManBarsDown );
	TON_excessiveBlockActivated.PT:= T#500MS;
	TON_excessiveBlockActivated();
	xStoppedByExcessiveTimeActive:=TON_excessiveBlockActivated.Q;

	IF xStoppedByExcessiveTimeActive OR EDGEPOS(xChangeMotorSpeedUp) OR EDGEPOS(xChangeMotorSpeedDown) THEN
		Block.commands.Manual.xManBarsUp := FALSE;
		Block.commands.Manual.xManBarsDown := FALSE;
	END_IF
	
		
	// Enable Up and Down movements if AnyBarEnabled
	IF NOT xStoppedByExcessiveTimeActive THEN
		
		Block.Status.Motor.xEnableUp:= 	(Block.commands.Mode.xManual AND NOT Block.Status.Motor.xBarsHomed) OR //Silvia: conditions for moving when the motor is not homed (issue 1283).
										(Block.Status.Motor.xBarsHomed AND (rMotorCurrentPos<=Block.parameters.Motor.rSafePosition)); // Lower than max is allowing to go up
								
		Block.Status.Motor.xEnableDown:= (Block.Status.Motor.xBarsHomed ) OR // <357 mm position max on venturi
										( Block.Status.Motor.xBarsHomed ) OR // 335.5 mm position max on venturi
										(Block.Status.Motor.xBarsHomed AND rMotorCurrentPos> Block.parameters.Motor.rMinSafePosition) OR  
										(NOT Block.Status.Motor.xBarsHomed AND (NOT Block.Al.xAlrReferenceIncoherence AND Block.In.xReferenceDI)); //Silvia: issue 1283: we cannot move bars with the sensor broken.
	ELSE
		Block.Status.Motor.xEnableUp:=FALSE;
		Block.Status.Motor.xEnableDown:=FALSE;
	END_IF;

	
	////////////////
	// Block Motor
	////////////////
			
	// Moving up	
	AxisBK.Command.Jog.ContinuousPos:= Block.Status.Motor.xEnableUp AND Block.commands.Manual.xManBarsUp AND NOT Block.commands.Manual.xManBarsDown;
		
	// Moving down
	AxisBK.Command.Jog.ContinuousNeg:= Block.Status.Motor.xEnableDown AND Block.commands.Manual.xManBarsDown AND NOT Block.commands.Manual.xManBarsUp;
		
	// Change vel.
	ManualSpeedControl;


	//Go to Undefined if any movement is raised during Manual
	iReasonMovingMan.0 := AxisBK.Command.Jog.ContinuousPos;
	iReasonMovingMan.1 := AxisBK.Command.Jog.ContinuousNeg;
	IF iReasonMovingMan >0 THEN
		Block.Status.PositionState := BLOCKP_UNDEFINED;
	END_IF
	

	//First Home direct to enable movement of the drive			
	IF 	NOT AxisBK.Status.HomeOK AND NOT Block.Status.Motor.xBarsHoming THEN
		//AxisBK.Parameter.HomePosition:=AxisBK.Status.ActPosition;
		AxisBK.Command.HomeDirect:=TRUE;
	END_IF				
	
END_ACTION

ACTION HomingBar:

	IF xBlockPosChange THEN
		AxisBK.Command.QuickStop:=FALSE;				// Reset state QuickStop				
		nState := 150;
	END_IF
	
	CASE nState OF
		
		(*----------------------------------- BAR HOMING ----------------------------------------------------------*)
		(*----------------------------------- BAR HOMING ----------------------------------------------------------*)
		(*----------------------------------- BAR HOMING ----------------------------------------------------------*)

		150:
			iLastState:=nState;
			Block.Status.Motor.xBarsHomed:= FALSE;
			AxisBK.Status.HomeOK := FALSE;
			xMotorHomeOrder:= TRUE;	
			nState:=nState+1;
		
		151:
			iLastState:=nState;
			IF AxisBK.Status.HomeOK THEN
				xMotorHomeOrder:= FALSE;
				Block.commands.xBarHomeOrder:=FALSE;
				Block.Status.Motor.xBarsHomed:= TRUE;
				nState:= 0;
			END_IF		 

	END_CASE

END_ACTION

ACTION ManualSpeedControl:
	
	IF NOT Block.Status.Motor.xBarsHomed THEN
		xChangeMotorSpeedUp		:= FALSE;
		xChangeMotorSpeedDown	:= FALSE;
		RETURN;
	END_IF

	IF AxisBK.Command.Jog.ContinuousNeg THEN //DOWN
					
		xChangeMotorSpeedUp := FALSE;
					
		IF rMotorCurrentPos <= Block.parameters.Motor.rMinSafePosition + Block.parameters.Motor.rReduceSpeedDistance THEN
					
			xChangeMotorSpeedDown := TRUE;
						
		END_IF
					
	ELSIF AxisBK.Command.Jog.ContinuousPos THEN //UP
					
		xChangeMotorSpeedDown := FALSE;
					
		IF rMotorCurrentPos >= Block.parameters.Motor.rSafePosition - Block.parameters.Motor.rReduceSpeedDistance THEN

			xChangeMotorSpeedUp := TRUE;
					
		END_IF
					
	ELSIF NOT ((rMotorCurrentPos <= Block.parameters.Motor.rMinThicknessMedia + Block.parameters.Motor.rReduceSpeedDistance) OR
		(rMotorCurrentPos >= Block.parameters.Motor.rSafePosition - Block.parameters.Motor.rReduceSpeedDistance)) THEN
				
		xChangeMotorSpeedUp		:= FALSE;
		xChangeMotorSpeedDown	:= FALSE;
			
	END_IF
	
END_ACTION
