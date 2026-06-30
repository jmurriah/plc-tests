
ACTION AlarmSound:
	
	//////////////////////////////
	// BLOCK SOUNDS
	//////////////////////////////
	
	// Block sounds while is homing
	// Sound generation for homing process
	// Sound generation: manual movements
	xAnyManualMov	:=	Block.Status.Motor.xBarsHoming OR
						AxisBK.Command.Jog.ContinuousPos OR
						AxisBK.Command.Jog.ContinuousNeg OR
						IclaBK.Command.JogForward OR
						IclaBK.Command.JogBackward;
	
	// Reseteable alarms. Reset is input in the ars function
	// Alarms reseteable sound management.
	ars_AlrStop.xAlarm:= Block.AlSummary.xAlarmStop;
	ars_AlrStop.xSilence:= Block.commands.xMute;
	ars_AlrStop();
		
	ars_AlrCritical.xAlarm:= Block.AlSummary.xAlarmCritical;
	ars_AlrCritical.xSilence:= Block.commands.xMute;
	ars_AlrCritical();
	
	ars_AlrWarning.xAlarm:= Block.AlSummary.xAnyWarning;
	ars_AlrWarning.xSilence:= Block.commands.xMute;
	ars_AlrWarning();	
	
	//reasonSound.0 := ars_AlrWarning.xAlarmSound;  //[RGP] I think warnings shouldnt sound
	reasonSound.1 := ars_AlrStop.xAlarmSound;
	reasonSound.2 := ars_AlrCritical.xAlarmSound;
	reasonSound.3 := (xAnyManualMov AND gPLC.xBlk_200ms); 
	
	
	Block.AlSummary.xAlarmSound := reasonSound>0;
	
	
	


END_ACTION
