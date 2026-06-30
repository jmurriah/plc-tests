
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
			IF AllDevicedStopped(ADR(Block), ADR(AxisBK)) THEN
				IF AxisBK.Status.PowerOn  AND AxisBK.Status.PLCopenState.StandStill THEN
					nState:= nState+1;
				END_IF
			END_IF


		211:
			iLastState:=nState;
			
			// If It is in safe place we go to next step
			IF ABS(rMotorCurrentPos-Block.parameters.Motor.rCapPosition)<0.01 THEN
				nState:= nState+3;
			ELSE 
				nState:= nState+1;
			END_IF

			// Here Alarm risk colision when Icarriage is not in sensor?
			
		212:
			iLastState:=nState;
			MoveBarsToCapPosition; //Directly nState:= nState+1;

		213:
			iLastState:=nState;
			CheckAbsolutMovementFinished; //If Finished, nState:= nState+1;
			
		214:
			iLastState:=nState;
			xInCap:= TRUE;
			nState:= 0;

	END_CASE
	

END_ACTION


ACTION GoingToPrint:

	IF xBlockPosChange THEN
		nState := 217;
	END_IF
	

	CASE nState OF
		
		(*PRINT POSITION    --------------------------------------------------------*)
		(*PRINT POSITION    --------------------------------------------------------*)
		(*PRINT POSITION    --------------------------------------------------------*)

		217:
			iLastState:=nState;
			
			ResetKnownPositions;
			
			nState:= nState+1;
			
		218:
			iLastState:=nState;
			IF AxisBK.Status.ErrorID=0 THEN
				StopMovements;
				nState:= nState+1;
			END_IF
			
		219:
			iLastState:=nState;
			IF AllDevicedStopped(ADR(Block), ADR(AxisBK)) THEN
				IF AxisBK.Status.PowerOn AND AxisBK.Status.PLCopenState.StandStill THEN
					nState:= nState+1;
				END_IF
			END_IF
			
		220:
			iLastState:=nState;
			//Going to print
			rMotorAbsPosDesired:= rCalcPosDesPrint;
			xMotorAbsMovOrder:= TRUE;
			
			nState:= nState+1;

		221:
			iLastState:=nState;
			
			IF ABS(rMotorCurrentPos-rMotorAbsPosDesired)<0.01 THEN
				xInPrint:= TRUE;
				nState:= 0;
			END_IF	 

	END_CASE
		
END_ACTION

ACTION MoveBarsToCapPosition:
	//Created an action because this code is called from 2 different places
	rMotorAbsPosDesired:= Block.parameters.Motor.rCapPosition;
	xMotorAbsMovOrder:= TRUE;
	nState:= nState+1;
						
END_ACTION

ACTION CheckAbsolutMovementFinished:
						
	IF ABS(rMotorCurrentPos-rMotorAbsPosDesired)<0.01 THEN
		nState:= nState+1;
	END_IF

END_ACTION