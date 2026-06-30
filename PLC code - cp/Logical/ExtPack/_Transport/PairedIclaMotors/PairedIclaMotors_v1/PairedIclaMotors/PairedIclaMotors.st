PROGRAM _INIT
	FOR iIndexHistory:=0 TO iHistoryLines DO 
		StateHistory[iIndexHistory]:=NOT_USED;
	END_FOR
END_PROGRAM
	
PROGRAM _CYCLIC
	
	//Main data assignation
	data ACCESS ADR (gPairedMotors[iIndexPairedIclaMotors]);
	IclaMaster ACCESS ADR (gIcla[gPairedMotors[iIndexPairedIclaMotors].parameters.IndexIclaMaster]);
	IclaGear ACCESS ADR (gIcla[gPairedMotors[iIndexPairedIclaMotors].parameters.IndexIclaGear]);
	
	IndexIclaMaster:=gPairedMotors[iIndexPairedIclaMotors].parameters.IndexIclaMaster;
	IndexIclaGear:=gPairedMotors[iIndexPairedIclaMotors].parameters.IndexIclaGear;
	
	//Review limits
	iNumIclaMotors := LIMIT(1, data.parameters.iNumIclaMotors, MAX_EHD_MOTORS_PER_ADJUST_SYS);
	rPositionDesired := LIMIT(data.parameters.rMechPositionMin, data.parameters.rPositionDesired, data.parameters.rMechPositionMax);
	
	data.status.xInstalled := data.parameters.xInstalled;
	IF data.status.xInstalled THEN
		//Motors data
		FOR iIndexIclaMotor:=1 TO iNumIclaMotors DO
			//Motor parameters
			dataToMotors;
			dataFromMotors;
			
			//Conversions
			IF data.parameters.xPositionSensorInstalled THEN
				Conversions;
			END_IF
		END_FOR
	END_IF
	
	data.status.xEnabled := data.parameters.xEnabled;
	IF NOT data.status.xEnabled THEN
		
		data.Alarms:= stAlarmsReseted;
		data.AlSummary := stAlarmSummaryReseted;
		data.AlSummary.xAlarmSound:=FALSE;

		data.status.xReferenced:=FALSE;
		ResetCommands;
		
		//Prepare for the next element
		iIndexPairedIclaMotors:= iIndexPairedIclaMotors +1;
		
		RETURN;
	END_IF
	
	IclaMotors[1]:=IclaMaster;
	IclaMotors[2]:=IclaGear;

	//Resetting commands
	IF data.commands.Mode.xZero THEN
		ResetCommands;
	END_IF
	
	
	//Motors state 
	MotorsMachineState;

	
	// ALARMS
	AlarmsSummary;
	
	//Alarm Sound
	AlarmSounds;
	
	//Assigning motor data
	IclaMaster := IclaMotors[1];
	IclaGear := IclaMotors[2];
	
	//Prepare for the next element
	iIndexPairedIclaMotors:= iIndexPairedIclaMotors +1;
	
END_PROGRAM
