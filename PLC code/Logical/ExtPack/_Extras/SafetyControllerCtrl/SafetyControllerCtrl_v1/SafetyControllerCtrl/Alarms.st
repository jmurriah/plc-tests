
ACTION Alarms:

	//Reset Alarms with an external order to reset
	IF SafetyController.Commands.xReset THEN
		ResetAlarms;
	END_IF
	
	//Saving modbus slave status when comms error raises
	IF EDGEPOS (SafetyController.Alarms.xCommsError) THEN
		ModSlaveState := SafetyController.Status.Comms.ModSlaveState;
		LastError := SafetyController.Status.Comms.LastError;
		LastErrorBlockNum := SafetyController.Status.Comms.LastErrorBlockNum;
	END_IF
	
	//Alarms related to comms
	IF SafetyController.Status.Comms.xModuleOk THEN
		
		CASE SafetyController.Status.Type OF
			//Cube machine
			SAFETYCONTROLLERTY_CUBE:
				
				SafetyController.Alarms.xAlrPrinterRearDoorSwitch := NOT SafetyController.Inputs.xPrinterRearDoorSwitch AND NOT SafetyController.Inputs.xPrinterMaintenanceKey;
				SafetyController.Alarms.xAlrHmiSwitch := NOT SafetyController.Inputs.xHmiSwitch;
				SafetyController.Alarms.xAlrPrinterFrontDoorSwitch := NOT SafetyController.Inputs.xPrinterFrontDoorSwitch AND NOT SafetyController.Inputs.xPrinterMaintenanceKey;
				SafetyController.Alarms.xAlrPrinterFanDoorSwitch := NOT SafetyController.Inputs.xFanDoorSwitch;
			
				SafetyController.Alarms.xAlrPrinterEStops := 	NOT SafetyController.Inputs.xPrinterBacksideEstop OR
																NOT SafetyController.Inputs.xPrinterFrontsideEstop;
				
				SafetyController.Alarms.xAlrPrinter := 	SafetyController.Alarms.xAlrPrinterRearDoorSwitch OR
														SafetyController.Alarms.xAlrHmiSwitch OR
														SafetyController.Alarms.xAlrPrinterFrontDoorSwitch OR
														SafetyController.Alarms.xAlrPrinterFanDoorSwitch OR
														SafetyController.Alarms.xAlrPrinterEStops;
				
				SafetyController.Alarms.xAlrPrinterDoorLockKeyActivated := SafetyController.Inputs.xPrinterMaintenanceKey;
				
				SafetyController.Alarms.xAlrFeeder := NOT SafetyController.Inputs.xX5Consent;
				
				SafetyController.Alarms.xAlrPrinterFrontEstop :=  NOT SafetyController.Inputs.xPrinterFrontsideEstop;
				SafetyController.Alarms.xAlrPrinterRearEstop := NOT SafetyController.Inputs.xPrinterBacksideEstop;
				
				
			SAFETYCONTROLLERTY_DEFAULT,
			SAFETYCONTROLLERTY_CUBE_ALPHA,
			SAFETYCONTROLLERTY_SD,
			SAFETYCONTROLLERTY_MECANO:
				tonAlarmFeeder.IN := NOT SafetyController.Inputs.xFeederEstop;
				tonAlarmFeeder.PT := T#3s;
				tonAlarmFeeder();
				SafetyController.Alarms.xAlrFeeder := tonAlarmFeeder.Q;
			
				tonAlarmPrimer.IN := NOT SafetyController.Inputs.xPrimerEstop;
				tonAlarmPrimer.PT := T#3s;
				tonAlarmPrimer();
				SafetyController.Alarms.xAlrPrimer := tonAlarmPrimer.Q;
			
				SafetyController.Alarms.xAlrPrinter := 	NOT SafetyController.Inputs.xPrinterLightCurtain OR
														NOT SafetyController.Inputs.xPrinterDoorLock OR
														NOT SafetyController.Inputs.xPrinterBacksideEstop OR
														NOT SafetyController.Inputs.xPrinterFrontsideEstop;
			
				SafetyController.Alarms.xAlrPrinterEStops := 	NOT SafetyController.Inputs.xPrinterBacksideEstop OR
																NOT SafetyController.Inputs.xPrinterFrontsideEstop;
				
				tonAlarmOverVarnish.IN := NOT SafetyController.Inputs.xOvervarnishEstop;
				tonAlarmOverVarnish.PT := T#3s;
				tonAlarmOverVarnish();
				SafetyController.Alarms.xAlrOverVarnish := tonAlarmOverVarnish.Q;
			
				tonAlarmStacker.IN := NOT SafetyController.Inputs.xStackerEstop;
				tonAlarmStacker.PT := T#3s;
				tonAlarmStacker();
				SafetyController.Alarms.xAlrStacker := tonAlarmStacker.Q;
				
				IF SafetyController.Status.Type = SAFETYCONTROLLERTY_SD OR SafetyController.Status.Type = SAFETYCONTROLLERTY_MECANO THEN
					tonAlarmSarm.IN := NOT SafetyController.Inputs.xSarmEstop;
					tonAlarmSarm.PT := T#3s;
					tonAlarmSarm();
					SafetyController.Alarms.xAlrSarm := tonAlarmSarm.Q;
				END_IF
			
				
				IF NOT gMachine.St.Mode.xZero THEN
					SafetyController.Alarms.xAlrPrinterDoorLock := NOT SafetyController.Inputs.xPrinterDoorLock;
					//SafetyController.Alarms.xAlrPrinterLightCurtain := NOT SafetyController.Inputs.xPrinterLightCurtain;
				END_IF
				
				SafetyController.Alarms.xAlrPrinterDoorLockKeyActivated := SafetyController.Inputs.xPrinterMaintenanceKey;
				IF SafetyController.Status.Type <> SAFETYCONTROLLERTY_CUBE_ALPHA THEN
					SafetyController.Alarms.xAlrBlowersEnclosureSwitchOff := NOT SafetyController.Inputs.xPrinterBlowersSwitch;
				END_IF

			SAFETYCONTROLLERTY_NOZ2_AQ:
				tonAlarmFeeder.IN := NOT SafetyController.Inputs.xFeederEstop;
				tonAlarmFeeder.PT := T#3s;
				tonAlarmFeeder();
				SafetyController.Alarms.xAlrFeeder := tonAlarmFeeder.Q;
			
				tonAlarmPrimer.IN := NOT SafetyController.Inputs.xPrimerEstop;
				tonAlarmPrimer.PT := T#3s;
				tonAlarmPrimer();
				SafetyController.Alarms.xAlrPrimer := tonAlarmPrimer.Q;
			
				SafetyController.Alarms.xAlrPrinter := 	NOT SafetyController.Inputs.xPrinterLightCurtain OR
														NOT SafetyController.Inputs.xPrinterDoorLock OR
														NOT SafetyController.Inputs.xPrinterBacksideEstop OR
														NOT SafetyController.Inputs.xPrinterFrontsideEstop;
			
				SafetyController.Alarms.xAlrPrinterEStops := 	NOT SafetyController.Inputs.xPrinterBacksideEstop OR
																NOT SafetyController.Inputs.xPrinterFrontsideEstop;
				
				tonAlarmDryer.IN := NOT SafetyController.Inputs.xDryerBacksideEstop OR NOT SafetyController.Inputs.xDryerFrontsideEstop;
				tonAlarmDryer.PT := T#3s;											
				tonAlarmDryer();
				SafetyController.Alarms.xAlrDryer := tonAlarmDryer.Q;
				
				tonAlarmOverVarnish.IN := NOT SafetyController.Inputs.xOvervarnishEstop;
				tonAlarmOverVarnish.PT := T#3s;
				tonAlarmOverVarnish();
				SafetyController.Alarms.xAlrOverVarnish := tonAlarmOverVarnish.Q;
			
				tonAlarmStacker.IN := NOT SafetyController.Inputs.xStackerEstop;
				tonAlarmStacker.PT := T#3s;
				tonAlarmStacker();
				SafetyController.Alarms.xAlrStacker := tonAlarmStacker.Q;	
				
				IF NOT gMachine.St.Mode.xZero THEN
					SafetyController.Alarms.xAlrPrinterDoorLock := NOT SafetyController.Inputs.xPrinterDoorLock;
					//SafetyController.Alarms.xAlrPrinterLightCurtain := NOT SafetyController.Inputs.xPrinterLightCurtain;
				END_IF
				
				SafetyController.Alarms.xAlrPrinterDoorLockKeyActivated := SafetyController.Inputs.xPrinterMaintenanceKey;
				SafetyController.Alarms.xAlrBlowersEnclosureSwitchOff := NOT SafetyController.Inputs.xPrinterBlowersSwitch;

		END_CASE
	END_IF
	
	
	//Alarm related to comms
	ton_CommsError.IN := NOT SafetyController.Orders.xDisableReadBlock AND NOT SafetyController.Status.Comms.xModuleOk;
	ton_CommsError.PT := T#200ms;
	ton_CommsError();
	IF ton_CommsError.Q THEN SafetyController.Alarms.xCommsError := TRUE; END_IF

	iReasonCritical.0 := SafetyController.Alarms.xAlrFeeder;
	iReasonCritical.1 := SafetyController.Alarms.xAlrPrimer;
	iReasonCritical.2 := SafetyController.Alarms.xAlrPrinter;
	iReasonCritical.3 := SafetyController.Alarms.xAlrDryer;
	iReasonCritical.4 := SafetyController.Alarms.xAlrOverVarnish;
	iReasonCritical.5 := SafetyController.Alarms.xAlrStacker;
	iReasonCritical.6 := SafetyController.Alarms.xCommsError;
	
	IF iReasonCritical>0 THEN
		SafetyController.Alarms.xCriticalAlarm := TRUE ;
	END_IF
	
END_ACTION


ACTION ResetAlarms:
	SafetyController.Alarms := AlarmsReseted;
END_ACTION