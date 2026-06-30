
ACTION Status: 

	CASE Dryer.Status.DeviceStatus OF
		DRYER_TURNED_OFF:
			IF Dryer.Inputs.xInRemote THEN
				Dryer.Status.DeviceStatus:=DRYER_INIT;
			END_IF
			
		DRYER_INIT:
			IF Dryer.Outputs.xRunTransport OR Dryer.Outputs.xPrepareToDry THEN
				Dryer.Status.DeviceStatus:=DRYER_PREPARING;
			END_IF
			
		DRYER_PREPARING:
			IF Dryer.Inputs.xTransportMoving THEN
				Dryer.Status.DeviceStatus:=DRYER_BELTRUNNING;
			ELSIF NOT Dryer.Outputs.xRunTransport AND NOT Dryer.Outputs.xPrepareToDry THEN
				Dryer.Status.DeviceStatus:=DRYER_INIT;
			END_IF
		
		DRYER_BELTRUNNING:
			IF Dryer.Inputs.xReadyToDry THEN
				Dryer.Status.DeviceStatus:=DRYER_READY;
			ELSIF NOT Dryer.Inputs.xTransportMoving THEN
				Dryer.Status.DeviceStatus:=DRYER_INIT;
			END_IF		
			
		DRYER_READY:
			IF Dryer.Inputs.xDrying THEN
				Dryer.Status.DeviceStatus:=DRYER_DRYING;
			ELSIF NOT Dryer.Inputs.xReadyToDry THEN
				Dryer.Status.DeviceStatus:=DRYER_INIT;
			END_IF
			
		DRYER_DRYING:
			IF NOT Dryer.Inputs.xDrying THEN
				Dryer.Status.DeviceStatus:=DRYER_INIT;
			END_IF
			
		DRYER_FAULTED:
			IF NOT Dryer.Inputs.xError THEN
				Dryer.Status.DeviceStatus:=DRYER_INIT;
			END_IF

	END_CASE
	
	IF NOT Dryer.Inputs.xCommsOK THEN
		Dryer.Status.DeviceStatus:=DRYER_TURNED_OFF;
	END_IF
	IF Dryer.Status.DeviceStatus <> DRYER_TURNED_OFF AND Dryer.Inputs.xError THEN
		Dryer.Status.DeviceStatus:=DRYER_FAULTED;
	END_IF
	
	UpdateStatus;	
	
	//Empty belt status
	tiTimeToEmpty := REAL_TO_TIME(60 * (Dryer.Parameters.Hw.rDryerLength + Dryer.Parameters.rMediaLength) / Dryer.Parameters.rSpeedSetPoint);
	tonEmptyBelt.IN := Dryer.Inputs.xTransportMoving;
	tonEmptyBelt.PT := tiTimeToEmpty;
	tonEmptyBelt();
	IF Dryer.Inputs.xCommsOK THEN
		Dryer.Status.xBeltEmpty := Dryer.Inputs.xBeltEmpty AND (tonEmptyBelt.Q OR NOT Dryer.Inputs.xTransportMoving);
	ELSE
		Dryer.Status.xBeltEmpty := (tonEmptyBelt.Q OR NOT Dryer.Inputs.xTransportMoving);
	END_IF
	
END_ACTION

ACTION UpdateStatus: 

	Dryer.Status.Device.xTurnedOff 		:=	Dryer.Status.DeviceStatus=DRYER_TURNED_OFF;
	Dryer.Status.Device.xInit 			:=	Dryer.Status.DeviceStatus=DRYER_INIT;
	Dryer.Status.Device.xPreparing 		:=	Dryer.Status.DeviceStatus=DRYER_PREPARING;
	Dryer.Status.Device.xBeltRunning 	:=	Dryer.Status.DeviceStatus=DRYER_BELTRUNNING;
	Dryer.Status.Device.xReadyToDry 	:=	Dryer.Status.DeviceStatus=DRYER_READY;
	Dryer.Status.Device.xDrying 		:=	Dryer.Status.DeviceStatus=DRYER_DRYING;
	Dryer.Status.Device.xFaulted 		:=	Dryer.Status.DeviceStatus=DRYER_FAULTED;

END_ACTION