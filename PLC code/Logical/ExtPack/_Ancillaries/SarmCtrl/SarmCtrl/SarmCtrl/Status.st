
ACTION Status: 

	CASE Sarm.Status.DeviceStatus OF
		Sarm_TURNED_OFF:
			IF Sarm.Inputs.xPowered THEN
				Sarm.Status.DeviceStatus:=Sarm_INIT;
			END_IF
			
		Sarm_INIT:
			IF Sarm.Outputs.xStartTransport THEN
				Sarm.Status.DeviceStatus:=Sarm_PREPARING;
			END_IF
			
		Sarm_PREPARING:
			IF Sarm.Inputs.xRunning THEN
				Sarm.Status.DeviceStatus:=Sarm_READY;
			ELSIF NOT Sarm.Outputs.xStartTransport THEN
				Sarm.Status.DeviceStatus:=Sarm_INIT;
			END_IF
			
		Sarm_READY:
			IF NOT Sarm.Inputs.xRunning THEN
				Sarm.Status.DeviceStatus:=Sarm_INIT;
			END_IF
			
		Sarm_FAULTED:
			IF NOT Sarm.Inputs.xError THEN
				Sarm.Status.DeviceStatus:=Sarm_TURNED_OFF;
			END_IF

	END_CASE
	
	IF NOT Sarm.Inputs.xPowered THEN
		Sarm.Status.DeviceStatus:=Sarm_TURNED_OFF;
	END_IF
	IF Sarm.Status.DeviceStatus <> Sarm_TURNED_OFF AND Sarm.Inputs.xError THEN
		Sarm.Status.DeviceStatus:=Sarm_FAULTED;
	END_IF
	
	UpdateStatus;

	//Empty belt status
	tiTimeToEmpty := REAL_TO_TIME(60 * (Sarm.Parameters.Hw.rSarmLength + Sarm.Parameters.rMediaLength) / Sarm.Parameters.rSpeedSetPoint);
	tonEmptyBelt.IN := Sarm.Inputs.xRunning;
	tonEmptyBelt.PT := tiTimeToEmpty;
	tonEmptyBelt();
	IF Sarm.Status.Comms.xModuleOk THEN
		Sarm.Status.xBeltEmpty:=Sarm.Inputs.Comms.xBeltEmpty AND (tonEmptyBelt.Q OR NOT Sarm.Inputs.xRunning);
	ELSE	
		Sarm.Status.xBeltEmpty := (tonEmptyBelt.Q OR NOT Sarm.Inputs.xRunning);
	END_IF
	
END_ACTION

ACTION UpdateStatus: 

	Sarm.Status.Device.xTurnedOff 	:=	Sarm.Status.DeviceStatus=Sarm_TURNED_OFF;
	Sarm.Status.Device.xInit 		:=	Sarm.Status.DeviceStatus=Sarm_INIT;
	Sarm.Status.Device.xPreparing 	:=	Sarm.Status.DeviceStatus=Sarm_PREPARING;
	Sarm.Status.Device.xReady		:=	Sarm.Status.DeviceStatus=Sarm_READY;
	Sarm.Status.Device.xFaulted 	:=	Sarm.Status.DeviceStatus=Sarm_FAULTED;

END_ACTION
