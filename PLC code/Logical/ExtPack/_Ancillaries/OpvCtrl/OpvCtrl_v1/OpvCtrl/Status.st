
ACTION Status: 

	CASE OverVarnish.Status.DeviceStatus OF
		OPV_TURNED_OFF:
			IF OverVarnish.Inputs.xOPVPresent THEN
				OverVarnish.Status.DeviceStatus:=OPV_INIT;
			END_IF
			
		OPV_INIT:
			IF NOT OverVarnish.Inputs.xOPVPresent THEN
				OverVarnish.Status.DeviceStatus:=OPV_TURNED_OFF;
			ELSIF OverVarnish.Outputs.Physical.xPrepareToPrime OR OverVarnish.Outputs.Physical.xRunTransport THEN
				OverVarnish.Status.DeviceStatus:=OPV_PREPARING;
			END_IF
			
		OPV_PREPARING:
			IF OverVarnish.Inputs.xTransportMoving THEN
				OverVarnish.Status.DeviceStatus:=OPV_BELT_RUNNING;
			ELSIF NOT OverVarnish.Outputs.Physical.xPrepareToPrime AND NOT OverVarnish.Outputs.Physical.xRunTransport THEN
				OverVarnish.Status.DeviceStatus:=OPV_INIT;
			END_IF
			
		OPV_BELT_RUNNING:
			IF NOT OverVarnish.Inputs.xTransportMoving THEN
				OverVarnish.Status.DeviceStatus:=OPV_INIT;
			END_IF
			IF OverVarnish.Inputs.xReadyToPrime THEN
				OverVarnish.Status.DeviceStatus:=OPV_READY;
			END_IF
			
		OPV_READY:
			IF NOT OverVarnish.Inputs.xReadyToPrime THEN
				OverVarnish.Status.DeviceStatus:=OPV_BELT_RUNNING;
			END_IF
			IF OverVarnish.Inputs.xCoating THEN
				OverVarnish.Status.DeviceStatus:=OPV_PRIMING;
			END_IF
			
		OPV_PRIMING:
			IF NOT OverVarnish.Inputs.xCoating THEN
				OverVarnish.Status.DeviceStatus:=OPV_READY;
			END_IF
			IF OverVarnish.Inputs.xDryerInRun THEN
				OverVarnish.Status.DeviceStatus:=OPV_DRYING;
			END_IF
			
		OPV_DRYING:
			IF NOT OverVarnish.Inputs.xDryerInRun THEN
				OverVarnish.Status.DeviceStatus:=OPV_PRIMING;
			END_IF
			
		OPV_FAULTED:
			IF NOT OverVarnish.Inputs.xError THEN
				OverVarnish.Status.DeviceStatus:=OPV_TURNED_OFF;
			END_IF

	END_CASE
	
	IF NOT OverVarnish.Inputs.xOPVPresent THEN
		OverVarnish.Status.DeviceStatus:=OPV_TURNED_OFF;
	END_IF
	IF OverVarnish.Status.DeviceStatus <> OPV_TURNED_OFF AND OverVarnish.Inputs.xError THEN
		OverVarnish.Status.DeviceStatus:=OPV_FAULTED;
	END_IF
	
	UpdateStatus;	
	
	//Empty belt status
	tiTimeToEmpty := REAL_TO_TIME(60 * (OverVarnish.Parameters.Hw.rOPVLength + OverVarnish.Parameters.rMediaLength) / OverVarnish.Parameters.rSpeedSetPoint);
	tonEmptyBelt.IN := OverVarnish.Inputs.xTransportMoving;
	tonEmptyBelt.PT := tiTimeToEmpty;
	tonEmptyBelt();
	IF OverVarnish.Status.Comms.xModuleOk THEN
		OverVarnish.Status.xBeltEmpty := OverVarnish.Inputs.Comms.xBeltEmpty AND (tonEmptyBelt.Q OR NOT OverVarnish.Inputs.xTransportMoving);
	ELSE
		OverVarnish.Status.xBeltEmpty := (tonEmptyBelt.Q OR NOT OverVarnish.Inputs.xTransportMoving);
	END_IF
	
END_ACTION

ACTION UpdateStatus: 

	OverVarnish.Status.Device.xTurnedOff 	:=	OverVarnish.Status.DeviceStatus=OPV_TURNED_OFF;
	OverVarnish.Status.Device.xInit			:=	OverVarnish.Status.DeviceStatus=OPV_INIT;
	OverVarnish.Status.Device.xPreparing 	:=	OverVarnish.Status.DeviceStatus=OPV_PREPARING;
	OverVarnish.Status.Device.xReady		:=	OverVarnish.Status.DeviceStatus=OPV_READY;
	OverVarnish.Status.Device.xPriming 		:=	OverVarnish.Status.DeviceStatus=OPV_PRIMING;
	OverVarnish.Status.Device.xFaulted 		:=	OverVarnish.Status.DeviceStatus=OPV_FAULTED;

END_ACTION