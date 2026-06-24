
ACTION ManualMovements:

	IF Block.commands.xIclaHomeOrder OR Block.commands.xBarHomeOrder OR Block.commands.xReset THEN
		RETURN;
	END_IF
	
	// Excessive Motor block activated
	TON_excessiveBlockActivated.IN:= (Block.commands.Mode.xManual) AND 
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
	
	
	// Excessive Icla activated	
	TON_StoppedIclaByTimeActive.IN:= (Block.commands.Mode.xManual) AND 
									(IclaBK.Command.JogBackward OR 
									IclaBK.Command.JogForward OR 
									Block.commands.Manual.xManIclaBack OR 
									Block.commands.Manual.xManIclaForward);
	TON_StoppedIclaByTimeActive.PT:= T#3s;
	TON_StoppedIclaByTimeActive();
	xStoppedIclaByTimeActive:=TON_StoppedIclaByTimeActive.Q;
	IF xStoppedIclaByTimeActive THEN
		Block.commands.Manual.xManIclaBack := FALSE;
		Block.commands.Manual.xManIclaForward := FALSE;
	END_IF	
	
		
	// Enable Up and Down movements if AnyBarEnabled
	IF NOT xStoppedByExcessiveTimeActive THEN
		
		Block.Status.Motor.xEnableUp:= 	((Block.commands.Mode.xManual) AND NOT Block.Status.Motor.xBarsHomed) OR //Silvia: conditions for moving when the motor is not homed (issue 1283).
										(Block.Status.Motor.xBarsHomed AND (rMotorCurrentPos<=Block.parameters.Motor.rSafePosition)); // Lower than max is allowing to go up
								
		Block.Status.Motor.xEnableDown:= (Block.In.xTrayIn AND Block.In.xIclaSensor AND Block.Status.Motor.xBarsHomed AND (rMotorCurrentPos>Block.parameters.Motor.rDripBarsPosition) ) OR // <357 mm position max on venturi
										( (Block.In.xTrayIn OR Block.In.xTrayOut) AND NOT Block.In.xIclaSensor AND Block.Status.Motor.xBarsHomed AND (rMotorCurrentPos>Block.parameters.Motor.rSafePositionCleanCarrier)) OR // 335.5 mm position max on venturi
										(Block.In.xTrayOut AND Block.In.xIclaSensor AND Block.Status.Motor.xBarsHomed AND rMotorCurrentPos> Block.parameters.Motor.rMinSafePosition) OR  
										(NOT Block.Status.Motor.xBarsHomed AND Block.In.xTrayOut AND Block.In.xIclaSensor AND (NOT Block.Al.xAlrReferenceIncoherence AND Block.In.xReferenceDI)); //Silvia: issue 1283: we cannot move bars with the sensor broken.
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

	
	////////////////
	// Clean Motor
	////////////////
			
	// Moving forward
	IclaBK.Command.JogForward := Block.commands.Manual.xManIclaForward AND
								(Block.Status.Icla.rCurrentPosition<Block.parameters.Icla.rPositionCleanMotorFwd-2.0) AND
								(rMotorCurrentPos >= rSafeBarPosToCarrier)AND 
								NOT Block.commands.Manual.xManIclaBack;
	// Moving backward
	IclaBK.Command.JogBackward:= Block.commands.Manual.xManIclaBack AND 
								NOT Block.In.xIclaSensor
								AND NOT Block.commands.Manual.xManIclaForward;
							

	//////////////////
	// Tray Movements
	//////////////////
	IF Block.Status.PositionState <> BLOCKP_GOING_TO_PRINT AND Block.Status.PositionState <> BLOCKP_GOING_TO_CLEAN THEN
		//If in Manual the block is doing auto movements, allow them
		Block.Out.xTrayOut:= Block.commands.Manual.xManTrayOut AND ((Block.Status.Motor.xBarsHomed AND rMotorCurrentPos> Block.parameters.Motor.rDripBarsPosition) OR
																	NOT Block.Status.Motor.xBarsHomed);
		Block.Out.xTrayIn:= Block.commands.Manual.xManTrayIn AND Block.Status.Motor.xBarsHomed AND rMotorCurrentPos> Block.parameters.Motor.rDripBarsPosition;
	END_IF

	// Reset commnads as commandBoolEdge
	IF Block.commands.Manual.xManTrayOut AND Block.In.xTrayOut THEN
		Block.commands.Manual.xManTrayOut:= FALSE;
	END_IF
			
	IF Block.commands.Manual.xManTrayIn AND Block.In.xTrayIn THEN
		Block.commands.Manual.xManTrayIn:= FALSE;
	END_IF
	
	/////////////////
	// Cleaning Water Pump
	////////////////
	TP_WaterSpurtDesactDelay.IN := Block.commands.Manual.xManWaterSpurt AND Block.Status.xIsWaterBlock AND Block.In.xWaterLevelSensor;
	Block.commands.Manual.xManWaterSpurt:= FALSE; // Reset command afeter using it in the TP function
	TP_WaterSpurtDesactDelay.PT := T#2s;
	TP_WaterSpurtDesactDelay();

	Block.Out.xCleaningWaterPump := TP_WaterSpurtDesactDelay.Q;

	/////////////////
	// Capping water Pump
	////////////////
	TP_CappingWaterPumpDesactDelay.IN := Block.commands.Manual.xManCappingWaterPump AND Block.Status.xIsWaterBlock AND Block.In.xWaterLevelSensor;
	Block.commands.Manual.xManCappingWaterPump:= FALSE; // Reset command afeter using it in the TP function
	TP_CappingWaterPumpDesactDelay.PT := T#2s;
	TP_CappingWaterPumpDesactDelay();

	Block.Out.xCappingWaterPump:=TP_CappingWaterPumpDesactDelay.Q;

	/////////////////
	// Waste water Pump
	////////////////
	Tp_ManWastePump.IN := Block.commands.Manual.xManWastePump AND Block.parameters.xWastedInkTankProcess;
	Block.commands.Manual.xManWastePump:= FALSE; // Reset command afeter using it in the TP function
	Tp_ManWastePump.PT := T#2s;
	Tp_ManWastePump();

	Block.Out.xWastedInkTankPump:=Tp_ManWastePump.Q;
	
	
	////////////////////////////////					
	// Enable venturi in manual state. 
	Block.Out.xVenturi:= Block.commands.Manual.xManVenturi;	
	
	
	//Go to Undefined if any movement is raised during Manual
	iReasonMovingMan.0 := AxisBK.Command.Jog.ContinuousPos;
	iReasonMovingMan.1 := AxisBK.Command.Jog.ContinuousNeg;
	iReasonMovingMan.2 := IclaBK.Command.JogForward;
	iReasonMovingMan.3 := IclaBK.Command.JogBackward;
	iReasonMovingMan.4 := Block.Out.xTrayOut AND NOT (Block.Status.PositionState = BLOCKP_GOING_TO_PRINT OR Block.Status.PositionState = BLOCKP_GOING_TO_CLEAN);
	iReasonMovingMan.5 := Block.Out.xTrayIn AND NOT (Block.Status.PositionState = BLOCKP_GOING_TO_PRINT OR Block.Status.PositionState = BLOCKP_GOING_TO_CLEAN);
	IF iReasonMovingMan >0 THEN
		Block.Status.PositionState := BLOCKP_UNDEFINED;
	END_IF
	
	
	//First Home direct to enable movement of the drive			
	IF 	NOT AxisBK.Status.HomeOK AND NOT Block.Status.Motor.xBarsHoming THEN
		//AxisBK.Parameter.HomePosition:=AxisBK.Status.ActPosition;
		AxisBK.Command.HomeDirect:=TRUE;
	END_IF				
	
END_ACTION


ACTION HomingIcla:

	IF xBlockPosChange THEN
		Block.commands.xIclaHomeOrderInterrupt:=FALSE;
		nState := 110;
	END_IF
	
	CASE nState OF
		
		(*----------------------------------- ICLA HOMING ----------------------------------------------------------*)
		(*----------------------------------- ICLA HOMING ----------------------------------------------------------*)
		(*----------------------------------- ICLA HOMING ----------------------------------------------------------*)

		110:		
			iLastState:=nState;
			// Homing Reference before movements to asure that Icla is refrenced
			Block.Status.Icla.xHomed :=FALSE;
			IF NOT IclaBK.Status.xReferenced THEN
				//It is a Home Direct adn doesnt need wait for nothing
				// IclaBK.Status.xReferenced is done when home ok
				//In CASE first connection OF the Icla TO the machine. Internally it is NOT homed
				IclaBK.Command.Home:= TRUE;
			ELSE
				nState:= nState+1;	 // Finished actions for order reference Icla before any movement
			END_IF
			
		111:
			// If Icla In Sensor, go out
			iLastState:=nState;
			IF Block.In.xIclaSensor THEN
				nState:= nState+1;		//Going to forward movement
			ELSE
				nState:= nState+2; 		//Going to backward movement
			END_IF

		112:
			//Starting forward movement IN ABSOLUTE
			iLastState:=nState;
			IclaBK.Command.JogForward:=TRUE;
			//Stop movement when not IclaIndSensor
			IF NOT Block.In.xIclaSensor THEN
				IclaBK.Command.JogForward:=FALSE;
				nState:= nState+1;		
			END_IF
			
		113:
			iLastState:=nState;
			//Starting backward movement when the Icla is stopped
			IF NOT Block.Status.Icla.xIsMoving THEN
				IclaBK.Command.JogBackward:=TRUE;
				nState:= nState+1;	
			END_IF

		114:
			iLastState:=nState;
			// Gone back to sensor and when it arrived we have to stop movements as mandatory
			IF Block.In.xIclaSensor THEN
				IclaBK.Command.JogBackward:=FALSE;
				nState:= nState+1;
			END_IF

		115: 
			iLastState:=nState;
			// Homing Done, with double check of cleaning carriage sensor
			IF NOT Block.Status.Icla.xIsMoving THEN
				nState:= nState+1;
			END_IF	

		116: 
			iLastState:=nState;
			// Homing Done, with double check of cleaning carriage sensor
			IclaBK.Command.Home:= TRUE;
			IF (IclaBK.Status.xReferenced) THEN
				// Homing Done, with double check of cleaning carriage sensor
				Block.commands.xIclaHomeOrder:=FALSE;
				Block.Status.Icla.xHomed :=TRUE;
				nState:= 0;	
				// Finished actions for order homing
			END_IF

	END_CASE
	
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

ACTION GoingToClean:

	IF xBlockPosChange THEN
		AxisBK.Command.QuickStop:=FALSE;				// Reset state QuickStop				
		nState := 190;
	END_IF
	
	CASE nState OF
		
		(*----------------------------------- GOING TO CLEAN ------------------------------------------------------*)
		(*----------------------------------- GOING TO CLEAN ------------------------------------------------------*)
		(*----------------------------------- GOING TO CLEAN ------------------------------------------------------*)

		190:
			iLastState:=nState;

			ResetKnownPositions;
			
			MoveBarsToCleanPosition;
			
			
		191:
			iLastState:=nState;
			
			CheckAbsolutMovementFinished;
			
			
		192:
			iLastState:=nState;
			xInClean:= TRUE;
			nState:= 0;

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
					
		IF  (rMotorCurrentPos <= Block.parameters.Motor.rDripBarsPosition + Block.parameters.Motor.rReduceSpeedDistance AND Block.In.xTrayIn) OR
			(rMotorCurrentPos <= Block.parameters.Motor.rSafePositionCleanCarrier + Block.parameters.Motor.rReduceSpeedDistance AND NOT Block.In.xIclaSensor) OR
			rMotorCurrentPos <= Block.parameters.Motor.rMinSafePosition + Block.parameters.Motor.rReduceSpeedDistance THEN
					
			xChangeMotorSpeedDown := TRUE;
						
		END_IF
					
	ELSIF AxisBK.Command.Jog.ContinuousPos THEN //UP
					
		xChangeMotorSpeedDown := FALSE;
					
		IF rMotorCurrentPos >= Block.parameters.Motor.rSafePosition - Block.parameters.Motor.rReduceSpeedDistance THEN

			xChangeMotorSpeedUp := TRUE;
					
		END_IF
					
	ELSIF NOT ((rMotorCurrentPos <= Block.parameters.Motor.rDripBarsPosition + Block.parameters.Motor.rReduceSpeedDistance OR
		rMotorCurrentPos <= Block.parameters.Motor.rSafePositionCleanCarrier + Block.parameters.Motor.rReduceSpeedDistance OR
		rMotorCurrentPos <= Block.parameters.Motor.rMinThicknessMedia + Block.parameters.Motor.rReduceSpeedDistance) OR
		(rMotorCurrentPos >= Block.parameters.Motor.rSafePosition - Block.parameters.Motor.rReduceSpeedDistance)) THEN
				
		xChangeMotorSpeedUp		:= FALSE;
		xChangeMotorSpeedDown	:= FALSE;
			
	END_IF
	
END_ACTION
