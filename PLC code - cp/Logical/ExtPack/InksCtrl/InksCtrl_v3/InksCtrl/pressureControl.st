
ACTION pressureControl:

	IF inks.parameters.StartUp.xActive THEN
		rMeniscusSp := inks._Internal.Startup.rSetPointMeniscus;
	ELSE
		rMeniscusSp := inks.parSw.NegPump.rSetPointMeniscus;
	END_IF

	xReservoirParamsNeeded := xPressureReservoirStable OR (xReservoirModeActivated AND  mode9); //INKS_STOPPING

	parPidMeniscus:=stPIDParamId(parBar.paramsPidMeniscus);
	xUpdatePidMeniscus:= parPidMeniscusCopy <> parPidMeniscus;
	parPidMeniscusCopy:=parPidMeniscus;
	IF xUpdatePidMeniscus THEN 
		iQuantityUpdatePidMeniscus:=iQuantityUpdatePidMeniscus+1;	
	END_IF;	
	IF xUpdatePidMeniscus OR EDGE(xReservoirParamsNeeded) THEN 
		IF NOT xReservoirParamsNeeded THEN
			//Standart values
			stPIDParamToMTPIDParameters(ADR(parBar.paramsPidMeniscus), ADR(pidParMeniscus));
		ELSE
			stPIDParamToMTPIDParameters(ADR(parBar.paramsPidMeniscusReservoir), ADR(pidParMeniscus));
		END_IF	
	END_IF;
	
	parPidPos:=stPIDParamId(parBar.paramsPidPositive);
	xUpdatePidPos:= parPidPosCopy <> parPidPos;
	parPidPosCopy:=parPidPos;
	IF xUpdatePidPos THEN 
		iQuantityUpdatePidPos:=iQuantityUpdatePidPos+1;	
	END_IF;	
	IF xUpdatePidPos OR EDGE(xReservoirParamsNeeded) THEN 
		IF NOT xReservoirParamsNeeded THEN
			//Standart values	
			stPIDParamToMTPIDParameters(ADR(parBar.paramsPidPositive), ADR(pidParPresPos));
		ELSE
			stPIDParamToMTPIDParameters(ADR(parBar.paramsPidPositiveReservoir), ADR(pidParPresPos));
		END_IF	
	END_IF;	
	
	
	TON_ExecutionDelay(IN:=TRUE, PT:= T#100MS);
	
	//timer to change the management of the filling pump.
	//Issue 1813: Modification in the change filling control condition, now if the difference between Sp and real meniscus is equal to zero, we change to PID control, too.
	//
	TON_ChangeFillingControl(	IN:=( mode3 AND NOT inks.parameters.Priming.xSystemNeedsPriming AND (rMeniscusError <  LC_MAX_MENISCUS_TO_STARTED)) AND
									( mode3 AND NOT inks.parameters.Priming.xSystemNeedsPriming AND (rMeniscusError >= LC_MIN_MENISCUS_TO_STARTED)) ,
								PT:= T#0.1S);
	IF NOT mode3 THEN
		xGoToStarted := FALSE;
	ELSIF TON_ChangeFillingControl.Q THEN
		xGoToStarted := TRUE;
	END_IF

	IF mode3 AND NOT xPrimingStabilized AND 
		( inks.status.PosPump.rDutyCycleFilling > inks.parameters.PosPump.rDCThresholdPriming) AND 
		( (rSPfillingPump <> rSP_PressurePos_PID) OR (rMeniscusSp <> rSP_Meniscus_PID) ) THEN	
					
		xPrimingStabilized:=TRUE;
	END_IF
	
	
	
	//Modify the Positive SetPoint during starting
	pressPosAcceleration;

	//**********************************************************************************
	//It changes SP maniscus when is detected differential pressure lower than 20mbars
	//**********************************************************************************
	IF NOT xDrippingOrder THEN
		
		IF inks.parameters.Priming.xSystemNeedsPriming THEN

			IF mode4 THEN //Inks Started

				// Timer management	for controlling changes in meniscus SP
				TON_ChangeSPstarting(IN:= ( xPrimingStabilized AND (NOT TON_ChangeSPstarting.Q) ), PT:= T#300MS);
				xUpdateSpPriming:= TON_ChangeSPstarting.Q AND inks.status.Temp.rTemp > (rSPtemp-4);
				
				rPressurePos:= ABS (inks.status.rVacuum1-rSP_PressurePos_PID);
				IF xUpdateSpPriming AND ( rPressurePos < inks.parameters.Priming.rThresholdPressure ) AND (rSPfillingPump <> rSP_PressurePos_PID)  THEN
					// rSPfillingPump is POS PRESSURE SP from GUI 

					// rSP_PressurePos_PID current positive pressure sensor
					IF (rSPfillingPump < rSP_PressurePos_PID) THEN 
						//Decrease Pos and Meniscus SPs
						rSP_PosPrimStabilizing := rSP_PosPrimStabilizing - 1;
					ELSE
						//Decrease Pos and Meniscus SPs
						rSP_PosPrimStabilizing := rSP_PosPrimStabilizing + 1;
					END_IF
				END_IF
				
				rPressureMen:= ABS (inks.status.rMeniscus-rSP_Meniscus_PID);			
				IF xUpdateSpPriming AND ( rPressureMen < inks.parameters.Priming.rThresholdPressure ) AND  (rMeniscusSp <> rSP_Meniscus_PID) AND (rSPfillingPump = rSP_PressurePos_PID) THEN
				
					IF (rMeniscusSp < rSP_Meniscus_PID) THEN
						//Decrease Pos and Meniscus SPs
						rSP_NegPrimStabilizing := rSP_NegPrimStabilizing - 1;
					ELSE
						//Decrease Pos and Meniscus SPs
						rSP_NegPrimStabilizing := rSP_NegPrimStabilizing + 1;					
					END_IF
				END_IF
				
				//Update de SetPoints of the PID
				rSP_Meniscus_PID:=rSP_NegPrimStabilizing;
				rSP_PressurePos_PID:=rSP_PosPrimStabilizing;
				
			END_IF
			
		ELSE	// THIS IS THE CASE WITHOUT THE PRIMING, THE STANDART BEHAVIOR
						
			IF xStateReverseFlow THEN

				IF (inks.status.rDeltaPressure <= 20.0) THEN
					rSP_PressurePos_PID := -15.0;
					rSP_Meniscus_PID := 25.0;
				ELSE
					inks.status.startChangeSPInDelta:=TRUE;
				END_IF
				
			ELSE
				rSP_PressurePos_PID:= rSPfillingPump;
				rSP_Meniscus_PID:=rMeniscusSp;
			END_IF
		
			// Timer management	
			TON_ChangeSPInDelta(IN:=inks.status.startChangeSPInDelta, PT:= SECONDS_TO_TIME(inks.parameters.iTimeChangeSPInRev));
			IF TON_ChangeSPInDelta.Q THEN
				rSP_PressurePos_PID:= rSPfillingPump;
				rSP_Meniscus_PID:=rMeniscusSp;
				inks.status.startChangeSPInDelta:=FALSE;
			END_IF
			
		END_IF

	ELSE //The ink System has DRIP ORDER

		rSP_Meniscus_PID:=SETPOINT_MENISCUS_DRIP;
		rSP_PressurePos_PID:= -SETPOINT_MENISCUS_DRIP + rSPfillingPump + rMeniscusSp;
		xPrimingStabilized:=FALSE;
		
	END_IF

	
	//VACUUM - NEGATIVE - VACUUM - NEGATIVE - VACUUM - NEGATIVE - VACUUM - NEGATIVE - VACUUM - NEGATIVE - 
	//VACUUM - NEGATIVE - VACUUM - NEGATIVE - VACUUM - NEGATIVE - VACUUM - NEGATIVE - VACUUM - NEGATIVE - 

	//negative pump management.
	iReasonEnableNegPID.0 := mode3;
	iReasonEnableNegPID.1 := mode4;
	iReasonEnableNegPID.2 := mode5;
	iReasonEnableNegPID.3 := mode6;
	iReasonEnableNegPID.4 := mode9;
	xEnableNegPID := iReasonEnableNegPID > 0;
	
	xHoldMeniscus := (inks.status.iDirection = INKSDIR_REVERSE AND NOT TON_StabSolPid1Neg.Q) OR
					(	NOT TON_StabSolPid2Neg.Q AND
					mode4 AND //INKS_STARTED
					xStateReverseFlow);

	//**********************************************************************************
	// PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID 
	//**********************************************************************************
	fb_PID_Pres(Enable:=xEnableNegPID AND TON_ExecutionDelay.Q,
						PIDParameters:=pidParMeniscus,
						HoldOut:= xHoldMeniscus,
						MinOut:=0.0,
						MaxOut:=100.0, 
						Update:= xUpdatePidMeniscus,
						SetValue:=rSP_Meniscus_PID,
						ActValue:=rMeniscusPV
						);
	rOrderBNegative:=fb_PID_Pres.Out;

	
	
	//POSITIVE - POSITIVE - POSITIVE - POSITIVE - POSITIVE - POSITIVE - POSITIVE - POSITIVE - POSITIVE - POSITIVE - 
	//POSITIVE - POSITIVE - POSITIVE - POSITIVE - POSITIVE - POSITIVE - POSITIVE - POSITIVE - POSITIVE - POSITIVE - 
	
	//filling pump management.
	iReasonEnablePosPID.0 := mode3 AND inks.parameters.Priming.xSystemNeedsPriming;
	iReasonEnablePosPID.1 := mode4;
	iReasonEnablePosPID.2 := mode5;
	iReasonEnablePosPID.3 := mode6;
	iReasonEnablePosPID.4 := mode9;
	xEnablePosPID := iReasonEnablePosPID > 0;
	
	xHoldPos:= (inks.status.iDirection = INKSDIR_REVERSE AND NOT TON_StabSolPid1Pos.Q) OR
				(NOT TON_StabSolPid2Pos.Q AND
				mode4 AND //INKS_STARTED
				xStateReverseFlow	);
	
	//**********************************************************************************
	// PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID PID 
	//**********************************************************************************
	fb_PID_PresFilling(Enable:=xEnablePosPID AND TON_ExecutionDelay.Q,
						PIDParameters:=pidParPresPos,
						HoldOut:= xHoldPos,
						MinOut:=0.0,
						MaxOut:=100.0, 
						Update:= xUpdatePidPos,
						SetValue:=rSP_PressurePos_PID,
						ActValue:=rPressureCollectorPos1
						);
	rOrderBPositive:=fb_PID_PresFilling.Out;


	//Define the pump outputs depending on the state

	IF mode3 THEN
		IF inks.parameters.Priming.xSystemNeedsPriming THEN
			rSP_Meniscus_PID	:= inks.parameters.NegPump.rSetPointPrimingStarting;
			rSP_PressurePos_PID	:= inks.parameters.PosPump.rSetPointPrimingStarting;
			inks.status.PosPump.rDutyCycleFilling:=rOrderBPositive;
			
			//Prepare the initial value for Stabilization stage
			rSP_PosPrimStabilizing:=inks.parameters.PosPump.rSetPointPrimingStarting;
			rSP_NegPrimStabilizing:=inks.parameters.NegPump.rSetPointPrimingStarting;
		ELSE
			rSetPointFillingPump:=parBar.rSPfillingPumpStarting;
			inks.status.PosPump.rDutyCycleFilling:=rOrderBPositiveStart;
		END_IF
		inks.status.NegPump.rDutyCycleNegative:=rOrderBNegative;
	END_IF	
	
	IF NOT mode10 AND (mode4 OR mode5 OR mode6) THEN
		inks.status.PosPump.rDutyCycleFilling:=rOrderBPositive;
		inks.status.NegPump.rDutyCycleNegative:=rOrderBNegative;
	END_IF 
	
	IF mode13 THEN
		inks.status.NegPump.rDutyCycleNegative:=inks.parameters.NegPump.rDCPriming;
		inks.status.PosPump.rDutyCycleFilling:=inks.parameters.PosPump.rDCPriming;		
	END_IF
	
	IF mode10 THEN //InksManifoldCleaning
		inks.status.PosPump.rDutyCycleFilling:=inks.parSw.PosPump.rSetPointManual;
		inks.status.NegPump.rDutyCycleNegative:=inks.parSw.NegPump.rSetPointManual;
	END_IF
	
	//Sanity checks
	IF mode1 THEN //Inks Stopped
		inks.status.PosPump.rDutyCycleFilling:=0;
		inks.status.NegPump.rDutyCycleNegative:=0;
		xPrimingStabilized:=FALSE;
	END_IF

END_ACTION
