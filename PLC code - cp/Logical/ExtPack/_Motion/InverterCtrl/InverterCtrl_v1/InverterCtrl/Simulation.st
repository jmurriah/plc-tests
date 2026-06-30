ACTION Simulation:
	
	dataInv.Status.ErrorComms := FALSE;
	(********** Reset non appliant in simulation error flags **********)
	paramOk := TRUE;
	invalidHwAddress := FALSE;
	ioMap.In.ModuleOk := TRUE;
	connectionErrorNotAck := FALSE; //Uncomment for P66/P76
	(********** Inverter state machine **********)
	CASE StepSim OF		
		STATE_NOT_READY_TO_SWITCH_ON:
			ioMap.In.StatusWord := 16#0000;
			IF ioMap.Out.ControlWord = 16#0000 THEN
				StepSim := STATE_SWITCH_ON_DISABLED;
			END_IF;				
		
		STATE_SWITCH_ON_DISABLED:
			ioMap.In.StatusWord := 16#0040;
			IF ioMap.Out.ControlWord = 16#0006 THEN
				StepSim := STATE_READY_TO_SWITCH_ON;
			END_IF;
		
		STATE_READY_TO_SWITCH_ON:
			ioMap.In.StatusWord := 16#0021;
			IF ioMap.Out.ControlWord = 16#0007 THEN
				StepSim := STATE_SWITCHED_ON;
			ELSIF ioMap.Out.ControlWord = 16#0000 OR ioMap.Out.ControlWord = 16#0002 THEN
				StepSim := STATE_SWITCH_ON_DISABLED;
			END_IF;
		
		STATE_SWITCHED_ON:
			ioMap.In.StatusWord := 16#0023;
			IF ioMap.Out.ControlWord = 16#000F THEN
				StepSim := STATE_OPERATION_ENABLED;
			ELSIF ioMap.Out.ControlWord = 16#0006 THEN
				StepSim := STATE_READY_TO_SWITCH_ON;
			ELSIF ioMap.Out.ControlWord = 16#0000 OR ioMap.Out.ControlWord = 16#0002 THEN
				StepSim := STATE_SWITCH_ON_DISABLED;
			END_IF;		
		
		STATE_OPERATION_ENABLED:
			ioMap.In.StatusWord := 16#0027;
			IF ioMap.Out.ControlWord = 16#0007 THEN
				StepSim := STATE_SWITCHED_ON;
			ELSIF ioMap.Out.ControlWord = 16#0006 THEN
				StepSim := STATE_READY_TO_SWITCH_ON;
			ELSIF ioMap.Out.ControlWord = 16#0000 OR ioMap.Out.ControlWord = 16#0002 THEN
				StepSim := STATE_SWITCH_ON_DISABLED;
			END_IF;
		
		STATE_QUICK_STOP_ACTIVE:
			ioMap.In.StatusWord := 16#0007;
			IF ioMap.Out.ControlWord = 16#0000 OR ioMap.Out.ControlWord = 16#0002 THEN
				StepSim := STATE_SWITCH_ON_DISABLED;
			END_IF;
			
		STATE_FAULT_REACTION_ACTIVE:
			ioMap.In.StatusWord := 16#000F;
			StepSim := STATE_FAULT;
		
		STATE_FAULT:
			ioMap.In.StatusWord := 16#0008;
			IF ioMap.Out.ControlWord = 16#0080 THEN
				StepSim := STATE_SWITCH_ON_DISABLED;
			END_IF;		
	END_CASE;
	(********** Movement profile **********)	
	IF StepSim = STATE_OPERATION_ENABLED THEN
		(* No decceleration parameter involved during operation *)
		SimDecceleration := 0;
		(* Acceleration and velocity calculation *)
		IF direction = 1 THEN
			IF REAL_TO_INT(SimVelocity) = UINT_TO_INT(dataInv.Parameters.Velocity) THEN
				SimAcceleration := 0;
			ELSIF REAL_TO_INT(SimVelocity) < UINT_TO_INT(dataInv.Parameters.Velocity) THEN
				SimAcceleration := UINT_TO_REAL(SimNominalSpeed) / dataInv.Parameters.AccelerationTime; (* positive acceleration in positive direction *)
				SimVelocity := LIMIT(-1*UINT_TO_REAL(SimNominalSpeed), SimInitialVelocity + SimVelocity + direction*(SimAcceleration * SimCycleTime), UINT_TO_REAL(dataInv.Parameters.Velocity));
			ELSIF REAL_TO_INT(SimVelocity) > UINT_TO_INT(dataInv.Parameters.Velocity) THEN
				SimAcceleration := -1*(UINT_TO_REAL(SimNominalSpeed) / dataInv.Parameters.AccelerationTime); (* negative acceleration in positive direction *)
				SimVelocity := LIMIT(UINT_TO_REAL(dataInv.Parameters.Velocity), SimInitialVelocity + SimVelocity + direction*(SimAcceleration * SimCycleTime), UINT_TO_REAL(SimNominalSpeed));	
			END_IF;
		ELSIF direction = -1 THEN
			IF REAL_TO_INT(SimVelocity) = direction*UINT_TO_INT(dataInv.Parameters.Velocity) THEN
				SimAcceleration := 0;
			ELSIF REAL_TO_INT(SimVelocity) > direction*UINT_TO_INT(dataInv.Parameters.Velocity) THEN
				SimAcceleration := UINT_TO_REAL(SimNominalSpeed) / dataInv.Parameters.AccelerationTime; (* positive acceleration in negative direction *)
				SimVelocity := LIMIT(-1*UINT_TO_REAL(dataInv.Parameters.Velocity), SimInitialVelocity + SimVelocity + direction*(SimAcceleration * SimCycleTime), UINT_TO_REAL(SimNominalSpeed));
			ELSIF REAL_TO_INT(SimVelocity) < direction*UINT_TO_INT(dataInv.Parameters.Velocity) THEN
				SimAcceleration := -1*(UINT_TO_REAL(SimNominalSpeed) / dataInv.Parameters.AccelerationTime); (* negative acceleration in negative direction *)
				SimVelocity := LIMIT(-1*UINT_TO_REAL(SimNominalSpeed), SimInitialVelocity + SimVelocity + direction*(SimAcceleration * SimCycleTime), -1*UINT_TO_REAL(dataInv.Parameters.Velocity));
			END_IF;
		END_IF;
		(* Limiting the velocity to the nominal speed of the motor - Optional *)
		SimVelocity := LIMIT(-1*UINT_TO_REAL(SimNominalSpeed),SimVelocity,UINT_TO_REAL(SimNominalSpeed));

	ELSE
		(* No acceleration parameter involved during stop *)
		SimAcceleration := 0;
		(* Decceleration and velocity calculation *)
		IF REAL_TO_INT(SimVelocity) = 0 THEN
			SimDecceleration := 0;
		ELSIF REAL_TO_INT(SimVelocity) > 0 THEN
			SimDecceleration := -1*(UINT_TO_INT(SimNominalSpeed) / dataInv.Parameters.DecelerationTime);
			SimVelocity := LIMIT(0,SimInitialVelocity + SimVelocity + (SimDecceleration * SimCycleTime), UINT_TO_REAL(SimNominalSpeed));
		ELSIF REAL_TO_INT(SimVelocity) < 0 THEN
			SimDecceleration := UINT_TO_INT(SimNominalSpeed) / dataInv.Parameters.DecelerationTime;
			SimVelocity := LIMIT(-1*UINT_TO_REAL(SimNominalSpeed),SimInitialVelocity + SimVelocity + (SimDecceleration * SimCycleTime),0);
		END_IF;
	END_IF;
	ioMap.In.ActualSpeed :=  REAL_TO_INT(SimVelocity);
END_ACTION