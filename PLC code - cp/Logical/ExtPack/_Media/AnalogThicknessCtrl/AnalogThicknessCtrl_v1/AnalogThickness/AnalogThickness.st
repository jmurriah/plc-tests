PROGRAM _CYCLIC
	
	//Main data assignation
	data ACCESS ADR (gDing);
	
	// Assigning status.xInstalled considering dynamic enable
	IF data.Parameters.xDingInstalled THEN
		IF data.Parameters.xAllowDynamicEnable THEN
			data.State.xDingInstalled:= data.Parameters.xEnable;
		ELSE
			data.State.xDingInstalled:= TRUE;
		END_IF
	ELSE
		data.State.xDingInstalled:= FALSE;
	END_IF

	//If not installed, clear alarms and exit
	IF NOT data.State.xDingInstalled THEN
		ResetAlarms;
		ResetCommands;
		data.State.xDingReferenced:=FALSE;
		RETURN;
	END_IF

	// Checking values
	gDing._Internal.rMarginSafePrintChecked := MAX(gDing.Parameters.rMarginSafePrint, 1.0); //The minimum Margin Safe print is 1mm
	
	
	// Recovering calibration data if configured
	IF data.State.xDingInstalled AND data.Parameters.xKeepHoming AND NOT xRecoveredPermanentInfo THEN
		data.State.xDingReferenced := data.State.Permanent.xDingReferenced;
		data.State.rOffsetCalibration := data.State.Permanent.rOffsetCalibration;
		xRecoveredPermanentInfo := TRUE;
	END_IF	
	
	//Reset Alarms with the reset command
	IF data.Commands.xErrorRst THEN
		ResetAlarms;
	END_IF
	
	//With Zero and the command to calibrate, the system is not calibrated
	IF data.Commands.Mode.xZero AND data.Commands.xCalibrateThickness THEN
		
		data.State.xDingReferenced:=FALSE;
		
		IF data.In.xDingLow THEN
			LogOrderReceivedOK;
			
			IF ABS(data.parSw.rCalibrationValue-data.In.rHighDingMm) < 3.0 THEN
				data.State.rOffsetCalibration:=data.parSw.rCalibrationValue-data.In.rHighDingMm;
				data.State.xDingReferenced:=TRUE;
				data.Alarms.xAlDingNoMediaToCalibrate:=FALSE;
				LogCalibrationOK;
			END_IF

		ELSE
			//If Order to calibrate and not media in the sensor, raise a Warning Alarm
			data.Alarms.xAlDingNoMediaToCalibrate:=TRUE;
			LogOrderReceivedNOK;
		END_IF
		
	END_IF
	
	//Take the command as an edge
	IF data.Commands.xCalibrateThickness THEN
		data.Commands.xCalibrateThickness:=FALSE;
	END_IF
	

	// NOTE: Keep this code until check in machine the efectiveness of the next code to avoid running through an array	
	//	arrThickness[0]:=REAL_TO_INT(data.State.rCurrentHigh*10.0);
	//	iMaxThicknessToSw:=0;
	//	FOR iIndexThickness:=VALUES_TO_GET_MAX_THICKNESS TO 1 BY -1 DO
	//		arrThickness[iIndexThickness]:= arrThickness[iIndexThickness-1];
	//		iMaxThicknessToSw:=MAX(iMaxThicknessToSw, arrThickness[iIndexThickness]);
	//	END_FOR;
	//	data.State.rCurrentThicknessStable:=INT_TO_REAL(iMaxThicknessToSw)/10.0;
	
	RTC_gettime(ADR(timeReaded));
	iModSec := timeReaded.second MOD 3;
	IF EDGEPOS(iModSec=0) THEN rMaxThicknessS0:=0; END_IF
	IF EDGEPOS(iModSec=1) THEN rMaxThicknessS1:=0; END_IF
	IF EDGEPOS(iModSec=2) THEN rMaxThicknessS2:=0; END_IF
	rMaxThicknessS0 := MAX(rMaxThicknessS0, data.State.rCurrentHigh);
	rMaxThicknessS1 := MAX(rMaxThicknessS1, data.State.rCurrentHigh);
	rMaxThicknessS2 := MAX(rMaxThicknessS2, data.State.rCurrentHigh);
	rMaxThickness := MAX(rMaxThicknessS0, rMaxThicknessS1, rMaxThicknessS2);
	data.State.rCurrentThicknessStable:=rMaxThickness;
	
	// Counter of Dinf low piece detect
	IF EDGEPOS (data.State.xDingLowPieceDetect) THEN	
		data.State.diLgLowPieceCounter:= data.State.diLgLowPieceCounter+1;
	END_IF;
	
	///////////////
	//ALARMS
	//////////////
	alarms;
	
	AlarmsSummary;
	
	AlarmSounds;
	
	data.Out.xReset := data.In.xDingChannelFault AND data.Commands.xErrorRst;
	
	// Storing current data in permanent
	data.State.Permanent.rOffsetCalibration := data.State.rOffsetCalibration;
	data.State.Permanent.xDingReferenced := data.State.xDingReferenced;
	
	///////////////////////////
	// Mounted media management. ThicknessCtrl MUST be executed in the slow cycle before this program
	IF data.State.xMountedMediaDetected AND NOT data._Internal.xMountedMediaTreated THEN
		data._Internal.xMountedMediaTreated := TRUE;
	END_IF
	IF NOT data.State.xMountedMediaDetected THEN
		data._Internal.xMountedMediaTreated := FALSE;
	END_IF
	
	///////////////////////////
	// Media To Reject management. ThicknessCtrl MUST be executed in the slow cycle before this program
	IF data.State.xMediaToRejectDetected AND NOT data._Internal.xMediaToRejectTreated THEN
		data._Internal.xMediaToRejectTreated := TRUE;
		LogRejectDetected;
	END_IF
	IF NOT data.State.xMediaToRejectDetected THEN
		data._Internal.xMediaToRejectTreated := FALSE;
	END_IF
	IF EDGENEG(data.State.xMediaToRejectDetected) THEN
		LogRejectEnded;
	END_IF
	
END_PROGRAM