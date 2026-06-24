
ACTION Status: 

	CASE Stacker.Status.DeviceStatus OF
		STACKER_TURNED_OFF:
			IF Stacker.Inputs.xStackerPresent THEN
				Stacker.Status.DeviceStatus:=STACKER_INIT;
			END_IF
		
		STACKER_INIT:
			xBeltsAreStopped:=FALSE;
			IF Stacker.Outputs.xPrepareToStack THEN
				Stacker.Status.DeviceStatus:=STACKER_PREPARING;
			END_IF
			
		STACKER_PREPARING:
			IF Stacker.Inputs.xReadyToStack THEN
				Stacker.Status.DeviceStatus:=STACKER_READY;
			ELSIF NOT Stacker.Outputs.xPrepareToStack THEN
				Stacker.Status.DeviceStatus:=STACKER_INIT;
			END_IF
			
		STACKER_READY:
			IF Stacker.Inputs.xRunning THEN
				Stacker.Status.DeviceStatus:=STACKER_WORKING;
			ELSIF NOT Stacker.Inputs.xReadyToStack THEN
				Stacker.Status.DeviceStatus:=STACKER_INIT;
			END_IF
			
		STACKER_WORKING:
			IF NOT Stacker.Inputs.xRunning THEN
				IF Stacker.Outputs.xRun THEN
					//CapsCases: Stacker stops sometimes due to faulty signal wiring on pdc side. To set faulted state when this occurs so line will stop.
					xBeltsAreStopped:=TRUE;
					Stacker.Status.DeviceStatus:=STACKER_FAULTED;
				ELSE
					Stacker.Status.DeviceStatus:=STACKER_READY;
				END_IF
			END_IF
			
		STACKER_FAULTED:
			IF NOT Stacker.Inputs.xError THEN
				Stacker.Status.DeviceStatus:=STACKER_INIT;
			END_IF

	END_CASE
	
	IF NOT Stacker.Inputs.xStackerPresent THEN
		Stacker.Status.DeviceStatus:=STACKER_TURNED_OFF;
	END_IF
	IF Stacker.Status.DeviceStatus <> STACKER_TURNED_OFF AND Stacker.Inputs.xError THEN
		Stacker.Status.DeviceStatus:=STACKER_FAULTED;
	END_IF
	
	UpdateStatus;	
	
	//Empty belt status
	tiTimeToEmpty := REAL_TO_TIME(60 * (Stacker.Parameters.Hw.rStackerLength + Stacker.Parameters.rMediaLength) / Stacker.Parameters.rSpeedSetPoint);
	tonEmptyBelt.IN := Stacker.Inputs.xRunning;
	tonEmptyBelt.PT := tiTimeToEmpty;
	tonEmptyBelt();
	IF Stacker.Status.Comms.xModuleOk THEN
		Stacker.Status.xBeltEmpty := Stacker.Inputs.Comms.xBeltsEmpty AND NOT Stacker.Inputs.Comms.xStackExit AND (tonEmptyBelt.Q OR NOT Stacker.Inputs.xRunning);
	ELSE
		Stacker.Status.xBeltEmpty := (tonEmptyBelt.Q OR NOT Stacker.Inputs.xRunning);
	END_IF
	
END_ACTION

ACTION UpdateStatus: 

	Stacker.Status.Device.xTurnedOff 	:=	Stacker.Status.DeviceStatus=STACKER_TURNED_OFF;
	Stacker.Status.Device.xInit 		:=	Stacker.Status.DeviceStatus=STACKER_INIT;
	Stacker.Status.Device.xPreparing 	:=	Stacker.Status.DeviceStatus=STACKER_PREPARING;
	Stacker.Status.Device.xReadyToStack	:=	Stacker.Status.DeviceStatus=STACKER_READY;
	Stacker.Status.Device.xStacking 	:=	Stacker.Status.DeviceStatus=STACKER_WORKING;
	Stacker.Status.Device.xFaulted 		:=	Stacker.Status.DeviceStatus=STACKER_FAULTED;

END_ACTION