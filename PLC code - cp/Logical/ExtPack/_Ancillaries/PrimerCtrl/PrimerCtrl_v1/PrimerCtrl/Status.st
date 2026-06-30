
ACTION Status: 

	CASE Primer.Status.DeviceStatus OF
		PRIMER_TURNED_OFF:
			IF Primer.Inputs.xPrimerPresent THEN
				Primer.Status.DeviceStatus:=PRIMER_INIT;
			END_IF
			
		PRIMER_INIT:
			IF NOT Primer.Inputs.xPrimerPresent THEN
				Primer.Status.DeviceStatus:=PRIMER_TURNED_OFF;
			ELSIF Primer.Outputs.Physical.xPrepareToPrime OR Primer.Outputs.Physical.xRunTransport THEN
				Primer.Status.DeviceStatus:=PRIMER_PREPARING;
			END_IF
			
		
		PRIMER_PREPARING:
			IF Primer.Inputs.xTransportMoving THEN
				Primer.Status.DeviceStatus:=PRIMER_BELT_RUNNING;
			ELSIF NOT Primer.Outputs.Physical.xPrepareToPrime AND NOT Primer.Outputs.Physical.xRunTransport THEN
				Primer.Status.DeviceStatus:=PRIMER_INIT;
			END_IF
			
		PRIMER_BELT_RUNNING:
			IF NOT Primer.Inputs.xTransportMoving THEN
				Primer.Status.DeviceStatus:=PRIMER_INIT;
			END_IF
			IF Primer.Inputs.xReadyToPrime THEN
				Primer.Status.DeviceStatus:=PRIMER_READY;
			END_IF
			
		PRIMER_READY:
			IF NOT Primer.Inputs.xReadyToPrime THEN
				Primer.Status.DeviceStatus:=PRIMER_BELT_RUNNING;
			END_IF
			IF Primer.Inputs.xCoating THEN
				Primer.Status.DeviceStatus:=PRIMER_PRIMING;
			END_IF
			
		PRIMER_PRIMING:
			IF NOT Primer.Inputs.xCoating THEN
				Primer.Status.DeviceStatus:=PRIMER_READY;
			END_IF
			IF Primer.Inputs.xDryerInRun THEN
				Primer.Status.DeviceStatus:=PRIMER_DRYING;
			END_IF
			
		PRIMER_DRYING:
			IF NOT Primer.Inputs.xDryerInRun THEN
				Primer.Status.DeviceStatus:=PRIMER_PRIMING;
			END_IF
			
		PRIMER_FAULTED:
			IF NOT Primer.Inputs.xError THEN
				Primer.Status.DeviceStatus:=PRIMER_TURNED_OFF;
			END_IF

	END_CASE
	
	IF NOT Primer.Inputs.xPrimerPresent THEN
		Primer.Status.DeviceStatus:=PRIMER_TURNED_OFF;
	END_IF
	IF Primer.Status.DeviceStatus <> PRIMER_TURNED_OFF AND Primer.Inputs.xError THEN
		Primer.Status.DeviceStatus:=PRIMER_FAULTED;
	END_IF
	
	UpdateStatus;
	
	//Empty belt status
	tiTimeToEmpty := REAL_TO_TIME(60 * (Primer.Parameters.Hw.rPrimerLength + Primer.Parameters.rMediaLength) / Primer.Parameters.rSpeedSetPoint);
	tonEmptyBelt.IN := Primer.Inputs.xTransportMoving;
	tonEmptyBelt.PT := tiTimeToEmpty;
	tonEmptyBelt();
	IF Primer.Status.Comms.xModuleOk THEN
		Primer.Status.xBeltEmpty := Primer.Inputs.Comms.xBeltEmpty AND (tonEmptyBelt.Q OR NOT Primer.Inputs.xTransportMoving);
	ELSE
		Primer.Status.xBeltEmpty := (tonEmptyBelt.Q OR NOT Primer.Inputs.xTransportMoving);
	END_IF
	
END_ACTION

ACTION UpdateStatus: 

	Primer.Status.Device.xTurnedOff 	:=	Primer.Status.DeviceStatus=PRIMER_TURNED_OFF;
	Primer.Status.Device.xInit			:=	Primer.Status.DeviceStatus=PRIMER_INIT;
	Primer.Status.Device.xPreparing 	:=	Primer.Status.DeviceStatus=PRIMER_PREPARING;
	Primer.Status.Device.xReady			:=	Primer.Status.DeviceStatus=PRIMER_READY;
	Primer.Status.Device.xPriming 		:=	Primer.Status.DeviceStatus=PRIMER_PRIMING;
	Primer.Status.Device.xFaulted 		:=	Primer.Status.DeviceStatus=PRIMER_FAULTED;

END_ACTION