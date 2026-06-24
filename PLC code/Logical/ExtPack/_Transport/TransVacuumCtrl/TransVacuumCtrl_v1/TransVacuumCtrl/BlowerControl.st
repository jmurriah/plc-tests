
ACTION BlowerControl: 

	IF NOT Blower.Status.StatusOperation THEN
		xAllBlowersRunning := FALSE;
	END_IF
	
	IF NOT Blower.Status.xAtSpeed THEN
		xAllBlowersAtSpeed := FALSE;
	END_IF
	
	//Define maximum DutyCycle if in Maximum mode
	IF StatusCtrl = TRANSVAC_MAXIMUM THEN
		dataVacc.Status.Blower.rDutyCycle := 100;
	END_IF

	//TODO: Need to change units. Order from PID in % and command in rpm
	Blower.Parameters.Velocity := REAL_TO_UINT(dataVacc.Status.Blower.rDutyCycle * dataVacc.Parameters.rMaxSpeed / 100);
	
	xEnteringPowerOn := NOT dataVacc.Parameters.Mode.xZero AND NOT Blower.Orders.PowerOn;
	Blower.Orders.PowerOn := NOT dataVacc.Parameters.Mode.xZero;

	ConditionStart := Blower.Status.ReadyForOrders AND StatusCtrl <> TRANSVAC_OFF;

	IF ConditionStart AND NOT ConditionStart_copy  THEN
		//TOREVIEW: Command should be an edge
		IF BlowerDirection = MOTOR_POSITIVE THEN
			Blower.Commands.MovePositive := TRUE;
		ELSIF BlowerDirection = MOTOR_NEGATIVE THEN
			Blower.Commands.MoveNegative := TRUE;
		END_IF			
	END_IF
	
	IF StatusCtrl = TRANSVAC_OFF AND StatusCtrl_copy<> TRANSVAC_OFF THEN
		Blower.Commands.Stop := TRUE;
	END_IF

	IF dataVacc.Commands.xReset OR xEnteringPowerOn THEN
		Blower.Commands.Reset := TRUE;
	END_IF
	
END_ACTION
