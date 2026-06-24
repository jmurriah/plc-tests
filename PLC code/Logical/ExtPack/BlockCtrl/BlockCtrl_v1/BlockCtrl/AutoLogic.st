
ACTION GoingToCap:
	
	IF xBlockPosChange THEN
		nState := 208;
	END_IF

	CASE nState OF
		
		(*STOP POSITION     --------------------------------------------------------*)
		(*STOP POSITION     --------------------------------------------------------*)
		(*STOP POSITION     --------------------------------------------------------*)

		208:
			iLastState:=nState;
			ResetKnownPositions;
			nState:= nState+1;
		
		209:
			iLastState:=nState;
			IF AxisBK.Status.ErrorID=0 THEN			
				StopMovements;
				nState:= nState+1;
			END_IF
			
		210:
			iLastState:=nState;
			IF AllDevicedStopped(ADR(Block), ADR(AxisBK), ADR(IclaBK)) THEN
				IF AxisBK.Status.PowerOn  AND AxisBK.Status.PLCopenState.StandStill THEN
					nState:= nState+1;
				END_IF
			END_IF


		211:
			iLastState:=nState;
			
			//If It is in safe place we go to next step
			IF ABS(rMotorCurrentPos-Block.parameters.Motor.rCapPosition)<0.01 THEN
				nState:= nState+3;
				//If bars are up than tray its not necessary move tray out
			ELSIF (rMotorCurrentPos > (Block.parameters.Motor.rCappingPosition - 0.05) AND Block.parameters.xCappingProcess) OR
				(rMotorCurrentPos > (Block.parameters.Motor.rDripBarsPosition + 0.01) AND NOT Block.parameters.xCappingProcess) THEN 
				MoveBarsToCapPosition;
				nState:= nState+2; //To go to CheckAbsolutMovementFinished state
			ELSE 
				//Tray Out
				Block.Out.xTrayOut:= TRUE;
				nState:= nState+1;
			END_IF

			
		212:
			iLastState:=nState;
			//Waiting the Tray to be out and ready to move
			IF Block.In.xTrayOut THEN
				MoveBarsToCapPosition;
			END_IF

		213:
			iLastState:=nState;
			
			CheckAbsolutMovementFinished;
			
			
		214:// Icla Position check
			iLastState:=nState;
			
			//If Icla is in position, jump 2 steps
			IF Block.In.xIclaSensor  THEN
				nState:= nState+2;
			//If Icla is not in position, send the order and jump 1 step to wait the move
			ELSE
				//Cleaning Motor going to stop position
				rIclaAbsPosDesired:= Block.parameters.Icla.rPositionCleanMotorBwd;
				IclaBK.Parameter.MoveAbsolute.Velocity:= INT_TO_UINT(Block.parameters.Icla.iCleanMotorSpeedBwd);
				xIclaAbsMovOrder:=TRUE;
				nState:= nState+1;
			END_IF
			
			
		215:
			iLastState:=nState;
	
			IF Block.In.xIclaSensor THEN
				xIclaAbsMovOrder:=FALSE;
				nState:= nState+1;
			END_IF
		
		216:	
			iLastState:=nState;

			//Be sure to place the tray in position
			Block.Out.xTrayIn:= TRUE;
			nState:= nState+1;
			
		217:
			iLastState:=nState;
			// Check that s not true other wise we tray in again
			IF NOT Block.In.xTrayOut AND Block.In.xTrayIn THEN
				IF Block.parameters.xCappingProcess AND Block.In.xFrontDoorClosed THEN
					MoveBarsToCappingPosition;
				ELSE
					nState:= nState+1;
				END_IF
			END_IF
		
		218:
			iLastState:=nState;
			// Check that s not true other wise we tray in again
			IF Block.parameters.xCappingProcess THEN
				CheckAbsolutMovementFinished;
			ELSE
				nState:= nState+1;
			END_IF

		219:
			iLastState:=nState;
			xInCap:= TRUE;
			nState:= 0;

	END_CASE
	

END_ACTION


ACTION GoingToPrint:

	IF xBlockPosChange THEN
		nState := 230;
	END_IF
	

	CASE nState OF
		
		(*PRINT POSITION    --------------------------------------------------------*)
		(*PRINT POSITION    --------------------------------------------------------*)
		(*PRINT POSITION    --------------------------------------------------------*)

		230:
			iLastState:=nState;
			
			ResetKnownPositions;
			
			nState:= nState+1;
			
		231:
			iLastState:=nState;
			IF AxisBK.Status.ErrorID=0 THEN
				StopMovements;
				nState:= nState+1;
			END_IF
			
		232:
			iLastState:=nState;
			IF AllDevicedStopped(ADR(Block), ADR(AxisBK), ADR(IclaBK)) THEN
				IF AxisBK.Status.PowerOn AND AxisBK.Status.PLCopenState.StandStill THEN
					nState:= nState+1;
				END_IF
			END_IF

		233:
			iLastState:=nState;
			// Checking icla position (Could it produce crashes?)
			IF Block.In.xIclaSensor THEN
				xIclaAbsMovOrder:= FALSE;
				IF (NOT Block.parameters.xCappingProcess) THEN
					nState:= nState+1;
				ELSE
					IF ABS(rMotorCurrentPos-Block.parameters.Motor.rCappingPosition)<0.01 THEN
						MoveBarsAboveCappingPosition;
					ELSE
						nState:= nState+1;
					END_IF
				END_IF
			END_IF

			
		234:	
			iLastState:=nState;
			
			//Tray out to allow go down
			xWaitToMoveTrayOut := (TON_WaitToMoveTrayOut.Q OR NOT Block.parameters.xCappingProcess);
			IF xWaitToMoveTrayOut THEN
				IF (NOT Block.In.xTrayOut) THEN
					Block.Out.xTrayOut:= TRUE;
				END_IF
				nState:= nState+1;
			END_IF
			
		235:
			iLastState:=nState;
			//Tray out to allow go down
			ton_TrayOut(IN:=Block.In.xTrayOut, PT:=T#2S);
			IF ton_TrayOut.Q  THEN
				nState:= nState+1;
			END_IF
			
		236:
			iLastState:=nState;
			//Going to print
			MoveBarsToPrintingPosition;

		237:
			iLastState:=nState;
			
			IF ABS(rMotorCurrentPos-rMotorAbsPosDesired)<0.01 THEN
				xInPrint:= TRUE;
				nState:= 0;
			END_IF	 

	END_CASE
		
END_ACTION


ACTION Cleaning:

	IF xBlockPosChange THEN
		nState := 250;
	END_IF

	// Drip Control Time established by user	
	TON_DRIPPING.IN:= Block.commands.xDripControl;
	TON_DRIPPING.PT:= tiDripTimeMax;
	TON_DRIPPING ();
	xFinishedDrippingOrderByBlock:=TON_DRIPPING.Q;
	IF xFinishedDrippingOrderByBlock THEN
		Block.commands.xDripControl:= FALSE;
	END_IF


	//Delay after Drip state
	tonStabInksAfterDrip.IN:=(nState=258);
	tonStabInksAfterDrip.PT:=T#3S;
	tonStabInksAfterDrip();	
	

	CASE nState OF
		
		(*CLEANING CYCLE    --------------------------------------------------------*)
		(*CLEANING CYCLE     --------------------------------------------------------*)
		(*CLEANING CYCLE    --------------------------------------------------------*)

		250:
			iLastState:=nState;
			
			Block.commands.xStartToCleanOrder:=FALSE;
			Block.commands.xInksOrderCleaning:= TRUE;
			xCloseReliefValve := TRUE; //To force closing the relief valve when ReservoirMode and not cleaning reverseflow
			Block.Status.xCleaningDone:=FALSE;

			ResetKnownPositions;
			
			nState:= nState+1;
			
		251:
			iLastState:=nState;
			IF AxisBK.Status.ErrorID=0 THEN
				StopMovements;
				nState:= nState+1;
			END_IF
			
		252:
			iLastState:=nState;
			IF AllDevicedStopped(ADR(Block), ADR(AxisBK), ADR(IclaBK)) THEN
				IF AxisBK.Status.PowerOn AND AxisBK.Status.PLCopenState.StandStill THEN
					nState:= nState+1;
				END_IF
			END_IF		
		
		253:	
			iLastState:=nState;
			//Going Icla To Stop Position
			nState:=nState+1;
	
		254:
			iLastState:=nState; //the bars go to the drip position.
			// Check Icla Pos because it goes down
			IF Block.In.xIclaSensor THEN
				rMotorAbsPosDesired:= Block.parameters.Motor.rDripBarsPosition;
				MoveAbsolute;
				nState:= nState+1;
			END_IF
	
		255:
			iLastState:=nState; //the bars go to the drip position.
			// Waiting For Drip Pos Done	
			IF ABS(rMotorCurrentPos-rMotorAbsPosDesired)<0.01 THEN
				//Disable cleaning in bar to end ReverseFlow
				Block.commands.xInksOrderCleaning:= FALSE;
				nState:= nState+1;
			END_IF
		
		256:
			iLastState:=nState;
			//Tray In
			IF NOT Block.In.xTrayIn THEN
				Block.Out.xTrayIn:= TRUE;
			ELSE 
				Block.commands.xDripControl:= TRUE;
				nState:= nState+1;
			END_IF
		
		257:	
			iLastState:=nState;
			//Waiting to DripControl End
			IF	NOT Block.commands.xDripControl THEN
				xCloseReliefValve := FALSE;
				nState:= nState+1;
			END_IF
			
		258:
			iLastState:=nState;
			//Waiting to stabilize Inks
			IF tonStabInksAfterDrip.Q THEN
				nState:= nState + 1;
			END_IF

		259:
			iLastState:=nState;
			//Going To Water Spurt Clean position. Do not protect TrayOut sensor because the bar is over the dripping position
			rMotorAbsPosDesired:= Block.parameters.Motor.rWaterSpurtPosition;
			MoveAbsolute;
			nState:= nState+1;

		260:
			iLastState:=nState;
			//Going To Water Spurt Clean position
			IF ABS(rMotorCurrentPos-rMotorAbsPosDesired)<0.01THEN
				nState:= nState+1;
			END_IF
	
		261:
			iLastState:=nState;
			//Cleaning motor moving forward
			rIclaAbsPosDesired:= Block.parameters.Icla.rPositionCleanMotorFwd;
			IclaBK.Parameter.MoveAbsolute.Velocity:= Block.parameters.Icla.iCleanMotorSpeedFwd;
			
			xIclaAbsMovOrder:=TRUE;
			nState:= nState+1;
						
		262:
			iLastState:=nState;
			//Start water pump activation by position of Icla.
			IF rIclaCurrentPos> Block.parameters.Icla.rFirstHeadPosition THEN
				Block.Out.xCleaningWaterPump:= Block.Status.xIsWaterBlock;
			END_IF			
					
			IF DINT_TO_REAL(IclaBK.Status.iActualPosition) - Block.parameters.Icla.rMinPrintHeadPos > -0.1 THEN
				xIclaAbsMovOrder:= FALSE;
			END_IF
			
			IF rIclaCurrentPos> Block.parameters.Icla.rLastHeadPosition OR rIclaCurrentPos > Block.parameters.Icla.rPositionCleanMotorFwd - 8.15 THEN
				nState:= nState+1;
			END_IF
			
		263:
			iLastState:=nState;
			//Stop Water Pump and Change Icla Velocity
			IclaBK.Parameter.MoveAbsolute.Velocity:=500;
			Block.Out.xCleaningWaterPump:= FALSE;
			
			IF IclaBK.Status.xInPosition THEN
				nState:= nState+1;
			END_IF

		264:		
			iLastState:=nState;
			//Wait 3s to depresure water circuit and move Bars to Clean Position
			TON_WaitDepresWater();
			TON_WaitDepresWater.IN:=Block.Status.xIsWaterBlock;
			TON_WaitDepresWater.PT:= T#3s;
			
			IF NOT Block.Status.xIsWaterBlock OR TON_WaitDepresWater.Q THEN 
				TON_WaitDepresWater.IN := FALSE;
				MoveBarsToCleanPosition;
			END_IF
			
		265:	
			CheckAbsolutMovementFinished;
			
		266:
			iLastState:=nState;
			//Cleaning Motor going to stop position
			xIclaAbsMovOrder:= TRUE;
			rIclaAbsPosDesired:= Block.parameters.Icla.rPositionCleanMotorBwd; 
			IclaBK.Parameter.MoveAbsolute.Velocity:=Block.parameters.Icla.iCleanMotorSpeedBwd;
			
			nState:= nState+1;
		
		267:
			iLastState:=nState;
			//Start Vacum & Wait Finish Movements
			IF rIclaCurrentPos <= Block.parameters.Icla.rLastHeadPosition THEN
				Block.Out.xVenturi:= Block.parameters.uiCleaningType = 1 OR Block.parameters.uiCleaningType = 2;
			END_IF
			//Stop Venturi
			IF (rIclaCurrentPos <= Block.parameters.Icla.rFirstHeadPosition) THEN
				Block.Out.xVenturi:= FALSE;
			END_IF
			//Remove the xIclaAbsMovOrder to be recepctive for a new positive edge
			IF rIclaCurrentPos <= 70.0  THEN 
				xIclaAbsMovOrder:=FALSE; 
			END_IF
				
			//Go to next state to apply the change in Speed
			IF rIclaCurrentPos <= 50.0  THEN
				nState:= nState+1;
			END_IF
		
		268:
			iLastState:=nState;
			//Change the speed to end the movement
			rIclaAbsPosDesired:= Block.parameters.Icla.rPositionCleanMotorBwd;
			IclaBK.Parameter.MoveAbsolute.Velocity:=500;
			xIclaAbsMovOrder:= TRUE;
			nState:= nState+1;

		269:
			iLastState:=nState;
			//Stop Venturi. If First position is close to 0, stop the venlturi after change speed
			IF (rIclaCurrentPos <= Block.parameters.Icla.rFirstHeadPosition) THEN
				Block.Out.xVenturi:= FALSE;
			END_IF
			//Stopping movement
			IF Block.In.xIclaSensor AND IclaBK.Status.iActualPosition <= 0 THEN
				xIclaAbsMovOrder:= FALSE;
				//Finished cleaning cycle
				Block.Status.xCleaningDone:= TRUE;
				nState:= 0;
			END_IF

	END_CASE	
	
END_ACTION


ACTION MoveAbsolute:
	//Evaluate which speed must be applied
	IF (rMotorCurrentPos>rMotorAbsPosDesired) THEN
		Block.parameters.Motor.rDriveAutoSpeed := Block.parameters.Motor.rAutoSpeedMoveDown; 
	ELSE
		//DELOREAN-3070: To set a high speed setpoint for block's motor speed to move up while in printing position 
		IF Block.parameters.Motor.xFastSpeedAllowed AND Block.Status.Position.xInPrint THEN
			Block.parameters.Motor.rDriveAutoSpeed := Block.parameters.Motor.rAutoSpeedMoveUpFast;
		ELSE
			Block.parameters.Motor.rDriveAutoSpeed := Block.parameters.Motor.rAutoSpeedMoveUp;
		END_IF
	END_IF
	//Set absolute movement order
	xMotorAbsMovOrder := TRUE;
END_ACTION

ACTION MoveBarsToCleanPosition:
	//Created an action because this code is called from 2 different places
	rMotorAbsPosDesired:= Block.parameters.Motor.rCleanPosition + rOffseCleanMtr;
	MoveAbsolute;
	nState:= nState+1;
END_ACTION

ACTION MoveBarsToCapPosition:
	//Created an action because this code is called from 2 different places
	rMotorAbsPosDesired:= Block.parameters.Motor.rCapPosition;
	MoveAbsolute;
	nState:= nState+1;				
END_ACTION

ACTION MoveBarsToCappingPosition:
	//Created an action because this code is called from 2 different places
	rMotorAbsPosDesired:= Block.parameters.Motor.rCappingPosition;
	MoveAbsolute;
	nState:= nState+1;				
END_ACTION

ACTION MoveBarsAboveCappingPosition:
	//Created an action because this code is called from 2 different places
	rMotorAbsPosDesired:= Block.parameters.Motor.rCappingPosition + rMoveAboveCapping;
	MoveAbsolute;
	nState:= nState+1;				
END_ACTION

ACTION MoveBarsToPrintingPosition:
	//Created an action because this code is called from 2 different places
	rMotorAbsPosDesired:= rCalcPosDesPrint;
	MoveAbsolute;
	nState:= nState+1;				
END_ACTION

ACTION CheckAbsolutMovementFinished:				
	IF ABS(rMotorCurrentPos-rMotorAbsPosDesired)<0.01 THEN
		nState:= nState+1;
	END_IF
END_ACTION
