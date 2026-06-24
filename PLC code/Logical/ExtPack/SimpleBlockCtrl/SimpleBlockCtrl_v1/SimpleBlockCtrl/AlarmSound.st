
ACTION AlarmSound:
	
	//////////////////////////////
	// BLOCK SOUNDS
	//////////////////////////////
	
	// Reseteable alarms. Reset is input in the ars function
	// Alarms reseteable sound management. //TOJC: Pending check all alarms!
	
	ars_AlrSafetySystemInBlock.xAlarm:= Block.Al.xAlrSafetySystemInBlock AND Block.commands.StateMode<>PRINTERGEN_ZERO;
	ars_AlrSafetySystemInBlock.xSilence:= Block.commands.xMute;
	ars_AlrSafetySystemInBlock();
		
	ars_DriveAlarm.xAlarm:= (Block.Al.xAnyDriveAlarm AND Block.Status.Motor.xBarsHomed);
	ars_DriveAlarm.xSilence:= Block.commands.xMute;
	ars_DriveAlarm();
	
	ars_AlrComBarMtr.xAlarm:= Block.Al.xAlrComBarMtr;
	ars_AlrComBarMtr.xSilence:= Block.commands.xMute;
	ars_AlrComBarMtr();
	
	ars_BrokenReferSensor.xAlarm:= Block.Al.xAlrReferenceIncoherence;
	ars_BrokenReferSensor.xSilence:= Block.commands.xMute;
	ars_BrokenReferSensor();
	
	ars_EmergencyStop.xAlarm:= Block.Al.xAlrEmergencyStop;
	ars_EmergencyStop.xSilence:= Block.commands.xMute;
	ars_EmergencyStop();

	
	
	Block.AlSummary.xAlarmSound:=	ars_AlrSafetySystemInBlock.xAlarmSound OR
									ars_DriveAlarm.xAlarmSound OR 
									ars_AlrComBarMtr.xAlarmSound OR
									ars_EmergencyStop.xAlarmSound OR
									(xAnyManualMov AND gPLC.xBlk_200ms);
	
	// Block sounds while is homing
	// Sound generation for homing process
	// Sound generation: manual movements
	xAnyManualMov:=Block.Status.Motor.xBarsHoming OR
					AxisBK.Command.Jog.ContinuousPos OR
                	AxisBK.Command.Jog.ContinuousNeg;


END_ACTION
