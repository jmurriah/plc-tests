
ACTION BlockAlarms:

	// Report alrms if is enabled. It comes from 4.3.6
	IF NOT Block.Status.xEnabledMovements THEN
		// Emergency stop alarm report to SW with block disabled
		SafetyEmergencyStopAlarms;
		RETURN;
	END_IF		

	SafetyAlarms;

	ModulesElementsAlarms;

	VerticalMotorAlarms;

	CleanAlarms;	
	
	//########################## ALARMS SUMMARY ########################################
	AlarmsSummary;	
	
END_ACTION

ACTION SafetyAlarms:

	SafetyEmergencyStopAlarms;

	// Alarm: Curtain Alarm

	//[RGP]CRETALEGO-1297: Front curtain alarm always activated when conditions are TRUE. Not autoreset as previously.
	//Will be reset BY "ResetAlarms.st" when "Reset" button is pressed and conditions are no longer TRUE.
	//These lines have been moved up, before calling "T_SafetyError()", this way we can set the alarm before switching to ZERO state
	IF NOT Block.In.Safety.xCurtainEnable01 OR NOT Block.In.Safety.xCurtainEnable02 THEN
		Block.Al.xAlrFrontCurtain:= TRUE;
	END_IF

	//Alarm: Front and rear general alarm (from preventa)
	IF (NOT Block.In.Safety.xRearSafetyOK) THEN
		Block.Al.xAlrRearSafety:= TRUE;
	END_IF
	IF (NOT Block.In.Safety.xFrontSafetyOK) THEN
		Block.Al.xAlrFrontSafety:= TRUE;
	END_IF
	
	//Bars Out sensor Cube
	IF NOT Block.In.xBarsIn AND Block.Status.Motor.xBarsHomed THEN
		Block.Al.xAlrBarsOut := TRUE;
	END_IF

	//Any Upper Safety. Variable to better readin and reduce number of lines
	xAnyUpperSafety := Block.Al.xAlrFrontCurtain OR Block.Al.xAlrRearSafety OR Block.Al.xAlrFrontSafety OR Block.Al.xAlrBarsOut;

	// Safety feedback is down? Has it been validate by reset panel? 
	//Used a TOF to avoid false signal when entering in AutoMode ALX check in P4 this functionallity
	T_SafetyError.IN:=	(NOT Block.commands.Mode.xZero) AND 
						(xAnyUpperSafety OR Block.Al.xAlrEmergencyStop OR NOT Block.In.Safety.xSafetyOK) AND
						(NOT Block.commands.AutoMode.xBypass);
	
	T_SafetyError.PT:=t#150ms;
	T_SafetyError();

	IF T_SafetyError.Q THEN
		Block.Al.xAlrSafetySystemInBlock:= TRUE;
	END_IF
			
END_ACTION

ACTION SafetyEmergencyStopAlarms:

	CASE Block.parameters.Hw.SafetySignals OF
		SAFETY_ESTOP_CONNECTED:

			// Alarm: Emergency Stop Button
			IF NOT Block.In.Safety.xFrontEStopOK THEN
				Block.Al.xAlrFrontEmergencyStop := TRUE;
			END_IF

			IF NOT Block.In.Safety.xRearEStopOK THEN
				Block.Al.xAlrRearEmergencyStop:= TRUE;
			END_IF
	
			Block.Al.xAlrEmergencyStop := Block.Al.xAlrFrontEmergencyStop OR Block.Al.xAlrRearEmergencyStop;
			
		SAFETY_ESTOP_CALCULATED:

			//If we do not have Safety OK buy the upper safety is OK, it is considered and EStop button is pressed
			IF NOT Block.In.Safety.xSafetyOK AND Block.In.Safety.xFrontSafetyOK AND Block.In.Safety.xRearSafetyOK THEN
				Block.Al.xAlrLogicEmergencyStop:= TRUE;
			END_IF

			Block.Al.xAlrEmergencyStop := Block.Al.xAlrLogicEmergencyStop;
		
	END_CASE

	

END_ACTION

ACTION VerticalMotorAlarms:

	// Alarm: Not homed Vertical motor.
	Block.Al.xAlrBarMtrNoRef:= NOT Block.Status.Motor.xBarsHomed;
	
	// Alarm: Drive protection
	IF NOT Block.In.xDriveProtectionOK THEN
		Block.Al.xAlrDriveProtection:= TRUE;
	END_IF
	
	// Alarm: Temp Vertical Motor
	IF AxisBK.Status.ActTempMot > (AxisBK.Status.MaxTempMotor - 5.0) THEN
		Block.Al.xBarMotorTemp := TRUE;
	ELSIF AxisBK.Status.ActTempMot < (AxisBK.Status.MaxTempMotor - 7.0) THEN
		Block.Al.xBarMotorTemp := FALSE;
	END_IF

	// Alarm: Temp Vertical Driver
	IF AxisBK.Status.ActTempDrv > (AxisBK.Status.MaxTempDrv - 5.0) THEN
		Block.Al.xBarDriverTemp := TRUE;
	ELSIF AxisBK.Status.ActTempDrv < (AxisBK.Status.MaxTempDrv - 7.0) THEN
		Block.Al.xBarDriverTemp := FALSE;
	END_IF
	
	//Alarm: Comms error in Vertical motor
	// Pass codes to ennum type 32189
	IF (AxisBK.Status.ErrorID=29265) OR (AxisBK.Status.ErrorID=32189) THEN
		Block.Al.xAlrComBarMtr:= TRUE;
	END_IF
		
	// Alarm: Any drive Alarm
	TON_DelayAnyVerticalDriveAlarm.IN:= AxisBK.Status.ErrorID<>0 AND
										NOT Block.AlSummary.xAlrSafetySystemGeneral AND 
										NOT Block.commands.Mode.xZero AND
										NOT xAnyUpperSafety;
	TON_DelayAnyVerticalDriveAlarm.PT:=t#200ms;
	TON_DelayAnyVerticalDriveAlarm();
	IF TON_DelayAnyVerticalDriveAlarm.Q THEN
		ReasonErrorID := AxisBK.Status.ErrorID;
		Block.Al.xAnyVerticalDriveAlarm:= TRUE;
	END_IF
	
	
	// Alarm: Power Error
	//[RGP] Power mains: At least one phase of the power line failed
	IF AxisBK.Status.ErrorID=7215 THEN
		Block.Al.xAlBarMotorPowerOff:= TRUE;
	END_IF
	
	// Warning: Decrease clean offset.
	TOF_CleanOffsetChng.IN := rOffseCleanMtr <> rOffseCleanMtr_Copy;
	TOF_CleanOffsetChng.PT := t#10s;
	TOF_CleanOffsetChng();
	Block.Al.xAlrDecreaseCleanOffset:= TOF_CleanOffsetChng.Q;
	
	//Warning: Check Homing Sensor Broken
	IF Block.Al.xAnyVerticalDriveAlarm AND (Block.Status.PositionState = BLOCKP_HOMING_BAR) THEN
		Block.Al.xAlrCheckHomingSensor:=TRUE;
	END_IF
		
	// Warning: Vertical motor maxium lifting alarm
	IF rMotorCurrentPos >= Block.parameters.Motor.rSafePosition THEN
		Block.Al.xAlrBlockReachedMaxPosition := TRUE;
	END_IF
	
	// Warning: Reference incoherence or broken reference sensor wire
	T_DelayAlarmRef.IN:=Block.In.xReferenceDI <> AxisBK.Status.DigitalInputs.RefSwitch;
	T_DelayAlarmRef.PT:=T#500ms;
	T_DelayAlarmRef();
	
	IF T_DelayAlarmRef.Q THEN
		Block.Al.xAlrReferenceIncoherence := TRUE;
	END_IF
	
	//Critical: Controller Not Ready
	ton_ControllerReady.IN := (NOT AxisBK.Status.ControllerReady OR AxisBK.Status.ErrorID=6029 OR AxisBK.Status.ErrorID=29216) AND NOT Block.commands.Mode.xZero;	//ErrorID 6029 its for motors with breaker and ControllerReady its general
	ton_ControllerReady.PT := t#300ms;																																//ErrorID 29216 to detect just power wires disconected
	ton_ControllerReady();
	IF ton_ControllerReady.Q THEN
		Block.Al.xAlrControllerNotReady := TRUE;
	END_IF
	
	//Warning Over Torque
	TON_OvertorqueWarning.IN := ABS(AxisBK.Status.ActTorque) > (Block.Status.Motor.rOperationTorque); //AxisBK.Status.RatedTorque;
	TON_OvertorqueWarning.PT := T#10s; //T#2s;
	TON_OvertorqueWarning();
	
	IF TON_OvertorqueWarning.Q THEN
		Block.Al.xWrnOverTorq := TRUE;
	END_IF
	
	// Alarm: Over Torque
	tonOvertorqueAlarm.IN := ABS(AxisBK.Status.ActTorque) > (1.6*Block.Status.Motor.rOperationTorque); //(AxisBK.Status.RatedTorque);
	tonOvertorqueAlarm.PT := T#500ms;	//T#5s;
	tonOvertorqueAlarm();
	IF tonOvertorqueAlarm.Q THEN
		Block.Al.xAlrOverTorque := TRUE;
	END_IF
	
	
	//Alarms related to collision between bars and tray
	CASE Block.Status.PositionState OF
		BLOCKP_UNDEFINED,
		BLOCKP_IN_CAP,
		BLOCKP_IN_CLEAN,
		BLOCKP_HOMING_ICLA:
			// Do nothing

		BLOCKP_IN_PRINT:
			//Raise warning and alarm if the tray sensor is disconected while in risk position (below dripping position)
			tonDelayTraySensorError.IN := NOT Block.In.xTrayOut;
			tonDelayTraySensorError.PT := T#750ms;
			tonDelayTraySensorError();
			
			//Raise asking the machine to emptyBelt
			IF tonDelayTraySensorError.Q AND Block.parameters.xMediaBelow THEN
				Block.Status.xAlarmToEmptyBelt := TRUE;
			//Raise and stop alarm once the belt is empty	
			ELSIF tonDelayTraySensorError.Q AND NOT Block.parameters.xMediaBelow THEN
				Block.Al.xAlrTraySensor:=TRUE;
				Block.Status.xAlarmToEmptyBelt := FALSE;
			END_IF
			
		BLOCKP_GOING_TO_CAP,
		BLOCKP_GOING_TO_PRINT,
		BLOCKP_GOING_TO_CLEAN,
		BLOCKP_CLEANING,
		BLOCKP_HOMING_BAR:
			//Risk. Moving!
			xDangerCollision := NOT Block.In.xTrayOut OR NOT Block.In.xIclaSensor;
			IF NOT Block.In.xTrayOut AND 	(((rMotorCurrentPos<Block.parameters.Motor.rDripBarsPosition) AND NOT Block.parameters.xCappingProcess) OR 
												(rMotorCurrentPos<Block.parameters.Motor.rCappingPosition)) OR
				
				NOT Block.In.xIclaSensor AND (((rMotorCurrentPos<Block.parameters.Motor.rSafePositionCleanCarrier) AND NOT Block.parameters.xCappingProcess) OR 
												(rMotorCurrentPos<Block.parameters.Motor.rCappingPosition))	THEN
				
					Block.Al.xNoActionDangerCollision:=TRUE;
			END_IF
	END_CASE
	
	//Saving state where alarm was raised
	IF EDGEPOS(Block.Al.xNoActionDangerCollision) THEN
		iReasonDanger.0:=NOT Block.In.xTrayOut;
		iReasonDanger.1:=NOT Block.In.xIclaSensor;
		
		nStateDanger := nState;
		PositionStateDanger:=Block.Status.PositionState;
	END_IF
	
	//If the sensor is conected again. Remove the memory
	IF Block.In.xTrayOut THEN
		Block.Status.xAlarmToEmptyBelt := FALSE;
	END_IF	
	
	
END_ACTION

ACTION ModulesElementsAlarms:

	// Alarm: Differential NOK
	IF NOT Block.In.xDifferentialOK THEN
		Block.Al.xAlrDif:= TRUE;
	END_IF
	
	// Alarm: TempPowerSupply
	IF Block.parameters.Hw.iNumHeaterPSU>0 THEN
		Block.Al.xAlrTempPowerSupply:= FALSE;
		FOR iIndexPsu:=1 TO Block.parameters.Hw.iNumHeaterPSU DO
			IF NOT Block.In.xHeaterDcOkPsu[iIndexPsu] OR NOT Block.In.xHeaterAcOkPsu[iIndexPsu] THEN
				Block.Al.xAlrTempPowerSupply:= TRUE;
			END_IF
		END_FOR
		
		IF NOT Block.In.xHeaterDcOkBusBar1 OR NOT Block.In.xHeaterDcOkBusBar2 THEN
			Block.Al.xAlrTempPowerSupply:= TRUE;
		END_IF
	END_IF
	
	// Logging the exact signal that raises the Heaters Power supply alarm
	IF EDGENEG(Block.In.xHeaterDcOkBusBar1) THEN LogErrorxHeaterDcOkBusBar1; END_IF
	IF EDGENEG(Block.In.xHeaterDcOkBusBar2) THEN LogErrorxHeaterDcOkBusBar2; END_IF
	IF EDGENEG(Block.In.xHeaterDcOkPsu[1]) THEN LogErrorxHeaterDcOkPsu1; END_IF
	IF EDGENEG(Block.In.xHeaterDcOkPsu[2]) THEN LogErrorxHeaterDcOkPsu2; END_IF
	IF EDGENEG(Block.In.xHeaterDcOkPsu[3]) THEN LogErrorxHeaterDcOkPsu3; END_IF
	IF EDGENEG(Block.In.xHeaterAcOkPsu[1]) THEN LogErrorxHeaterAcOkPsu1; END_IF
	IF EDGENEG(Block.In.xHeaterAcOkPsu[2]) THEN LogErrorxHeaterAcOkPsu2; END_IF
	IF EDGENEG(Block.In.xHeaterAcOkPsu[3]) THEN LogErrorxHeaterAcOkPsu3; END_IF
	
	// Alarm: PrintHead PowerSupply
	IF Block.parameters.Hw.iNumPrintheadsPSU>0 THEN
		Block.Al.xAlrPHPowerSupply:= FALSE;
		FOR iIndexPsu:=1 TO Block.parameters.Hw.iNumPrintheadsPSU DO
			IF NOT Block.In.xPrintHeadPSU[iIndexPsu] THEN
				Block.Al.xAlrPHPowerSupply:= TRUE;
			END_IF
		END_FOR
	END_IF
		
	
	// Alarm: Module Temp 01	
	Block.Al.xModuleTemp01:= NOT Block.In.xModuleTemp01Ok;
		
	// Alarm: Module Temp 02
	Block.Al.xModuleTemp02:= NOT Block.In.xModuleTemp02Ok;
			
	// Alarm: Module Temp 03
	Block.Al.xModuleTemp03:= NOT Block.In.xModuleTemp03Ok AND Block.parameters.Inks.xTankHeatEnabled1;
	
	// Alarm: Module Temp 04
	Block.Al.xModuleTemp04:= NOT Block.In.xModuleTemp04Ok AND Block.parameters.Inks.xTankHeatEnabled2;
		
	
	(*SI UNIT ALARMS*)
	//Alarm venturi
	IF NOT Block.In.xAirVenturiOK AND Block.In.xSiUnitModuleOk THEN
		Block.Al.xAlAirVenturi:= TRUE;
	END_IF
	
	// Alarm: Coms error SI Unit
	IF NOT Block.In.xSiUnitModuleOk  THEN
		Block.Al.xAlrComSiUnit:= TRUE;
		Block.Al.xSiUnitPowerOff:=TRUE;
	END_IF
	
END_ACTION

ACTION CleanAlarms:

	
	// Warning: Alarms of no action allowed due to colision warning.
	Block.Al.xAlrNoTrayInServoNoHomed:=(NOT AxisBK.Status.HomeOK) AND Block.commands.Manual.xManTrayIn;
	
	// Warning: clean interrupt
	Block.Al.xAlCleanInterrupt:= xCleanInterrupt;
	
	
	
	// ICLA		ICLA		ICLA		ICLA		ICLA		ICLA		ICLA		ICLA		
	// ICLA		ICLA		ICLA		ICLA		ICLA		ICLA		ICLA		ICLA		

	//Alarm: Comms error in cleaning motor
	T_AlrComsCleanMotor.IN:= NOT IclaBK.Status.xModuleOK;
	T_AlrComsCleanMotor.PT:= T#2S;
	T_AlrComsCleanMotor();	
	
	IF T_AlrComsCleanMotor.Q THEN
		Block.Al.xAlrComCleanMtr:= TRUE;
	END_IF
	
	//Alarm: Not homed cleaning motor.
	Block.Al.xAlrCleanMtrNoRef:= NOT Block.Status.Icla.xHomed;
			
	// From Icla error table 011Ah 282 4 Inputs of the STO safety function have different levels (>1s). Reset done executing ResetAlarms in Machine program
	// If the connector is removed while moving is error 281, error 282 is STO at different level
	IF (IclaBK.Status.Error.ErrorNumber = 281 OR IclaBK.Status.Error.ErrorNumber = 282) THEN
		Block.Al.xAlrEnabCleanMtrDiffLvL:= TRUE;
	END_IF
	
	// Alarm: Any clean motor alarm
	T_IclaError.IN :=	(IclaBK.Status.Error.ErrorNumber<>0 OR IclaBK.Status.iDriveStatus = ICLAST_SWITCH_ON_DISABLED OR IclaBK.Status.iDriveStatus = ICLAST_ERROR) AND
						Block.In.Safety.xSafetyOK AND
						NOT Block.AlSummary.xAlrSafetySystemGeneral AND //This variable must not be required so we already check "Block.In.Safety.xSafetyOK"
						NOT Block.commands.Mode.xZero AND
						NOT xAnyUpperSafety; //This variable must not be required so we already check "Block.In.Safety.xSafetyOK"
	T_IclaError.PT := t#250ms;
	T_IclaError();
	IF T_IclaError.Q THEN
		Block.Al.xAlrCleanMotor:= TRUE;
	END_IF
	
	Block.Al.xCleanMotorControllerNotReady := IclaBK.Status.iDriveStatus = ICLAST_SWITCH_ON_DISABLED AND Block.In.Safety.xSafetyOK AND NOT Block.commands.Mode.xZero;
	
	// Alarm: Clean Sensor
	T_AlCleanSensor.IN:= Block.Status.Icla.xHomed AND (NOT Block.In.xIclaSensor) AND (rIclaCurrentPos<=0) AND Block.In.xSiUnitModuleOk;
	T_AlCleanSensor.PT:= t#2500ms;
	T_AlCleanSensor();
	IF T_AlCleanSensor.Q THEN
		Block.Al.xAlrCleanSensor:= TRUE;
	END_IF
	
	// TRAY ALARMS		TRAY ALARMS		TRAY ALARMS		TRAY ALARMS		TRAY ALARMS		TRAY ALARMS		TRAY ALARMS		TRAY ALARMS		
	// TRAY ALARMS		TRAY ALARMS		TRAY ALARMS		TRAY ALARMS		TRAY ALARMS		TRAY ALARMS		TRAY ALARMS		TRAY ALARMS		

	
	TNotPrinterZero.IN:=NOT (Block.commands.Mode.xZero);
	TNotPrinterZero.PT:=T#500ms;
	TNotPrinterZero();
	
	
	//This is to avoid alarms in Zero mode when manually moving the tray
	IF TNotPrinterZero.Q THEN
		TON_AlrTrayIn(IN := Block.Out.xTrayIn, PT:= Block.parameters.tiTimeWaitTrayInAlarm);
		TON_AlrTrayOut(IN := Block.Out.xTrayOut, PT:= Block.parameters.tiTimeWaitTrayOutAlarm);
	END_IF 

	// Alr tray sensor IN
	IF TON_AlrTrayIn.Q AND (NOT Block.In.xTrayIn) THEN
		Block.Al.xAlrTraySensor:=TRUE;
	END_IF
	// Alr tray sensor OUT
	IF TON_AlrTrayOut.Q AND (NOT Block.In.xTrayOut) THEN
		Block.Al.xAlrTraySensor:=TRUE;
	END_IF
		
	//Alarm clean motor ERROR POSITION// issue 1269
	T_DelayIncoherCleanMtr.IN :=	((nState=233 AND NOT Block.In.xIclaSensor) OR 
									(rIclaCurrentPos>LIMITPOSINCOHERCLEANMOTOR AND Block.In.xIclaSensor));
	T_DelayIncoherCleanMtr.PT:= T#500MS;
	T_DelayIncoherCleanMtr();
	
	IF T_DelayIncoherCleanMtr.Q THEN
		Block.Al.xAlrIncoherPositCleanMtr:= TRUE;
	END_IF
	//Poner aquí la gestion de las alarmas y, si eso, sacar la habilitación fuera, ya que no es su sitio
	//Secuencia - Alarmas de tanque y bomba - Sirena - Hab/Deshab - parada a mitad de proceso - ....
	 
	
	//If Machine are Water enable water alarms
	IF Block.Status.xIsWaterBlock THEN

		//Water tank empty alarm	
		IF NOT Block.In.xWaterLevelSensor THEN
			Block.Al.xAlrEmptyWaterTank:=TRUE;
		END_IF

		//Water Presure and broken presure sensor alarms
		T_AlrNoPressureWhenWaterPumpIsOn.IN:=Block.Out.xCleaningWaterPump AND Block.In.xWaterPresureSensor;
		T_AlrNoPressureWhenWaterPumpIsOn.PT:=T#5S;
		T_AlrNoPressureWhenWaterPumpIsOn();
		IF T_AlrNoPressureWhenWaterPumpIsOn.Q THEN
			Block.Al.xAlrWaterPumpPresure:=TRUE;
		END_IF
		
		//Broquen wire or pressure switch not work alarm
		IF NOT Block.In.xWaterPresureSensor AND NOT Block.Out.xCleaningWaterPump AND NOT nState=264 THEN
			Block.Al.xAlrWtrPresSensBroken := TRUE;
		END_IF
		
		//Capping water Alarms:
		//Water flowmeter and WaterTankEmpty
		IF Block.parameters.xCappingProcess  THEN

			//Water tank empty alarm
			IF NOT Block.In.xCappingWaterLevelSensor THEN
				Block.Al.xAlrCappingWaterTankEmpty:=TRUE;
			END_IF
		
			//Water recirculation alarm
			TON_AlrCappingWaterNotRecirc.IN:=(Block.Out.xCappingWaterPump AND NOT Block.In.xCappingWaterFlowmeter);
			TON_AlrCappingWaterNotRecirc.PT:=T#3S;
			TON_AlrCappingWaterNotRecirc();
		
			IF TON_AlrCappingWaterNotRecirc.Q THEN										
				//Block.Al.xAlrCappingWaterNotRecirc:=TRUE;
			END_IF
		END_IF		
		
	END_IF

	xAlrToAvoidCleanWithWater := Block.Al.xAlrEmptyWaterTank OR Block.Al.xAlrWaterPumpPresure OR Block.Al.xAlrWtrPresSensBroken;
	
END_ACTION
