
ACTION Status: 

	CASE Feeder.Status.DeviceStatus OF
		FEEDER_TURNED_OFF:
			IF Feeder.Inputs.xFeederPresent AND Feeder.Inputs.xOnline THEN
				Feeder.Status.DeviceStatus:=FEEDER_INIT;
			END_IF
			
		FEEDER_INIT:
			IF Feeder.Outputs.Physical.xPrepareToFeed THEN
				Feeder.Status.DeviceStatus:=FEEDER_PREPARING;
			END_IF
			
		FEEDER_PREPARING:
			IF Feeder.Inputs.xReadyToFeed THEN
				Feeder.Status.DeviceStatus:=FEEDER_READY;
			ELSIF NOT Feeder.Outputs.Physical.xPrepareToFeed THEN
				Feeder.Status.DeviceStatus:=FEEDER_INIT;
			END_IF
			
		FEEDER_READY:
			IF Feeder.Inputs.xFeeding THEN
				Feeder.Status.DeviceStatus:=FEEDER_FEEDING;
			ELSIF NOT Feeder.Inputs.xReadyToFeed THEN
				Feeder.Status.DeviceStatus:=FEEDER_INIT;
			END_IF
			
		FEEDER_FEEDING:
			IF NOT Feeder.Inputs.xFeeding THEN
				Feeder.Status.DeviceStatus:=FEEDER_INIT;
			END_IF
			
		FEEDER_FAULTED:
			IF NOT Feeder.Inputs.xError THEN
				Feeder.Status.DeviceStatus:=FEEDER_TURNED_OFF;
			END_IF

	END_CASE
	
	IF NOT Feeder.Inputs.xFeederPresent THEN
		Feeder.Status.DeviceStatus:=FEEDER_TURNED_OFF;
	END_IF
	IF Feeder.Status.DeviceStatus <> FEEDER_TURNED_OFF AND Feeder.Inputs.xError THEN
		Feeder.Status.DeviceStatus:=FEEDER_FAULTED;
	END_IF
	
	UpdateStatus;

END_ACTION

ACTION UpdateStatus: 

	Feeder.Status.Device.xTurnedOff 	:=	Feeder.Status.DeviceStatus=FEEDER_TURNED_OFF;
	Feeder.Status.Device.xInit 			:=	Feeder.Status.DeviceStatus=FEEDER_INIT;
	Feeder.Status.Device.xPreparing 	:=	Feeder.Status.DeviceStatus=FEEDER_PREPARING;
	Feeder.Status.Device.xReadyToFeed	:=	Feeder.Status.DeviceStatus=FEEDER_READY;
	Feeder.Status.Device.xFeeding 		:=	Feeder.Status.DeviceStatus=FEEDER_FEEDING;
	Feeder.Status.Device.xFaulted 		:=	Feeder.Status.DeviceStatus=FEEDER_FAULTED;

END_ACTION
