PROGRAM _INIT

	vData ACCESS ADR(gBasicDetectMedia);
	vData.Parameters.rDesiredHeigh := 20;
	
END_PROGRAM

PROGRAM _CYCLIC
	
	vData ACCESS ADR(gBasicDetectMedia);
	
	IF NOT vData.Parameters.xInstalled THEN
		vData.Status := StatusReseted;
		RETURN;
	END_IF
	
	IF vData.Commands.xReset THEN
		vData.Alarms := AlarmsReseted;
	END_IF
	
	vData.Status.xInstalled := vData.Parameters.xInstalled;
	vData.Status.xMediaPresent := vData.Inputs.xMediaPresentL1 OR vData.Inputs.xMediaPresentL2;
	
	//Define Alarms
	IF vData.Inputs.xMountedMedia AND vData.Parameters.xBeltMoving THEN
		vData.Alarms.xMountedMedia := TRUE;
	END_IF
	
	IF vData.Inputs.xCorrection THEN
		vData.Status.rMediaHeigh := vData.Parameters.rDesiredHeigh + vData.Parameters.rCorrection;
	ELSE
		vData.Status.rMediaHeigh := vData.Parameters.rDesiredHeigh;
	END_IF
	
	//Sound managing
	arMountedMedia		(xAlarm:= gDryer.Al.Alarm.xAlarmMountedMedia, xSilence:=gDryer.AutoCmd.xMuteAlarms);
	
	iReasonSound.0 := arMountedMedia.xAlarmSound;
	vData.AlSummary.xAlarmSound := iReasonSound > 0;
	
END_PROGRAM
