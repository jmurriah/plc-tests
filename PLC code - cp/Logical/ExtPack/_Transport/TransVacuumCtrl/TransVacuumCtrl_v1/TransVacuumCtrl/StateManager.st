
ACTION StateManager: 

//	TRANSVAC_OFF				Blower turned Off
//	TRANSVAC_WAITING			The blower running at StartUp Duty cycle. IDLE state in previous programs
//	TRANSVAC_CONTROLLING		Pressure beeing controlled BY PID
//	TRANSVAC_MAN				
	
	// Order not in production
	iReasonOutOfProduction.0 := dataVacc.parSw.xActiveOutOfProduction AND dataVacc.Parameters.AutoMode.xBypass;

	//Memorice first start in laboratory mode. This line is needed before the memory is uesd
	IF xRunBlowerAuto THEN xLabStartedBlowers := dataVacc.Parameters.AutoMode.xLaboratory; ELSE xLabStartedBlowers := FALSE; END_IF
	iReasonOutOfProduction.1 := dataVacc.parSw.xActiveOutOfProduction AND dataVacc.Parameters.AutoMode.xLaboratory AND
								(dataVacc.Parameters.xBeltRunning OR xLabStartedBlowers);

	iReasonOutOfProduction.2 := dataVacc.Commands.xRunByLine;
	iReasonOutOfProduction.3 := dataVacc.Commands.xRunByRemote;
	
	xRunOutOfProduction := iReasonOutOfProduction > 0;
	
	////////////////Auto Order
	iReasonRunAuto.0 := dataVacc.Commands.xRunProduction AND dataVacc.Parameters.AutoMode.xProduction;
	iReasonRunAuto.1 := dataVacc.Parameters.Mode.xAuto AND xRunOutOfProduction;
	iReasonRunAuto.2 := dataVacc.Commands.xRunJamRecovery AND dataVacc.Parameters.AutoMode.xJamRecovery;
	xRunBlowerAuto := iReasonRunAuto > 0;

	////////////////Manual order
	xRunBlowerMan := dataVacc.Parameters.Mode.xManual AND dataVacc.OrdersSw.xRunManual; //To avoid blowers starts again after restoring STOs if blowers were running when STOs were switched off
	
	
	CASE StatusCtrl OF
		
		TRANSVAC_OFF:
			IF NOT tofNotStartAfterEStop.Q THEN
				IF EDGEPOS(xRunBlowerMan) THEN
					StatusCtrl:=TRANSVAC_MAN;
				END_IF
				
				IF xRunBlowerAuto AND (dataVacc.parSw.rVacPressureSetPointPerc>=dataVacc.Parameters.rMinVacPressureSetPointPerc) THEN
					IF dataVacc.Parameters.xStartUpEnable THEN
						StatusCtrl:=TRANSVAC_WAITING;
					ELSE
						StatusCtrl:=TRANSVAC_CONTROLLING;
					END_IF
				END_IF
			END_IF
			
		TRANSVAC_WAITING:
			IF rVacPressurePerc > dataVacc.Parameters.rVacPressureSetPointPerc THEN
				StatusCtrl:=TRANSVAC_CONTROLLING;
			END_IF
			IF dataVacc.Commands.xRunMaxDutyCycle THEN
				StatusCtrl:=TRANSVAC_MAXIMUM;
			END_IF
			
			GoToOffIfNotAutoOrSP;
			
		TRANSVAC_CONTROLLING:
			IF dataVacc.Parameters.xStartUpEnable AND (dataVacc.Status.Blower.rDutyCycle > dataVacc.Parameters.rStartUpDutyCycle) THEN
				StatusCtrl:=TRANSVAC_WAITING;
			END_IF	
			IF dataVacc.Commands.xRunMaxDutyCycle THEN
				StatusCtrl:=TRANSVAC_MAXIMUM;
			END_IF
			
			GoToOffIfNotAutoOrSP;
			
		TRANSVAC_MAXIMUM:
			IF xRunBlowerAuto THEN
				StatusCtrl:=TRANSVAC_CONTROLLING;
			ELSIF NOT dataVacc.Commands.xRunMaxDutyCycle AND NOT xRunBlowerAuto THEN
				StatusCtrl:=TRANSVAC_OFF;
			END_IF

		TRANSVAC_MAN:
			IF NOT xRunBlowerMan THEN
				StatusCtrl:=TRANSVAC_OFF;
				dataVacc.Status.xStartedMan := FALSE;
			END_IF

	END_CASE
	
	//In Zero, always stop blowers
	IF dataVacc.Parameters.Mode.xZero OR dataVacc.Parameters.xExternalSafetyStop THEN
		StatusCtrl:=TRANSVAC_OFF;
		ResetCommands;
	END_IF
	
	// Timer to be sure not start the blowers after 6 seconds after recovering from a Safety Signal
	tofNotStartAfterEStop.IN := EDGENEG(dataVacc.Parameters.xExternalSafetyStop);
	tofNotStartAfterEStop.PT := T#0s;
	tofNotStartAfterEStop();
	
	//Just with the status of manual
	dataVacc.Status.xStartedMan := StatusCtrl = TRANSVAC_MAN;

	
END_ACTION

ACTION GoToOffIfNotAutoOrSP:
	
	TON_StopBlowersDly.IN:= NOT xRunBlowerAuto OR (dataVacc.Parameters.rMinVacPressureSetPointPerc > dataVacc.parSw.rVacPressureSetPointPerc);
	TON_StopBlowersDly.PT:= t#200ms;
	TON_StopBlowersDly();
	
	
	IF TON_StopBlowersDly.Q THEN
		StatusCtrl:=TRANSVAC_OFF;
	END_IF

END_ACTION

ACTION ResetCommands:
	IF NOT dataVacc.Commands.xReset THEN
		dataVacc.Commands := CommandsReseted;
	ELSE
		dataVacc.Commands := CommandsReseted;
		dataVacc.Commands.xReset := TRUE;
	END_IF
END_ACTION
