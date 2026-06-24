
ACTION LogWarningSize:

	stEventLogWarningSize.Source := ELOG_TYPE_GENERAL;
	stEventLogWarningSize.Severity:= ELOG_SEVERITY_WARNING;
	stEventLogWarningSize.Facility:= 0;
	stEventLogWarningSize.ErrorCode:=0;
	
	stEventLogWarningSize.Text := 'Mismatch in Media values. ';
	
	//Adding nState data to log
	strAuxEventDesc := '. Width= ';
	brsstrcat(ADR(stEventLogWarningSize.Text), ADR(strAuxEventDesc));
	brsitoa(REAL_TO_INT(gMachine.parSw.Media.rWidth), ADR(strAuxEventDesc));
	brsstrcat(ADR(stEventLogWarningSize.Text), ADR(strAuxEventDesc));
	strAuxEventDesc := '. OffsetL1= ';
	brsstrcat(ADR(stEventLogWarningSize.Text), ADR(strAuxEventDesc));
	brsitoa(REAL_TO_INT(gMachine.parSw.Media.rOffsetRegisterL1), ADR(strAuxEventDesc));
	brsstrcat(ADR(stEventLogWarningSize.Text), ADR(strAuxEventDesc));
	
	gEventLogLoader(EventData := ADR(stEventLogWarningSize));
	
END_ACTION

ACTION LogImageLoadedL1:

	stEventLogImgLoadedL1.Source := ELOG_TYPE_GENERAL;
	stEventLogImgLoadedL1.Severity:= ELOG_SEVERITY_INFO;
	stEventLogImgLoadedL1.Facility:= 0;
	stEventLogImgLoadedL1.ErrorCode:=0;
	
	stEventLogImgLoadedL1.Text := 'Image loaded L1';
		
	gEventLogLoader(EventData := ADR(stEventLogImgLoadedL1));
	
END_ACTION

ACTION LogImageUnLoadedL1:

	stEventLogImgUnLoadedL1.Source := ELOG_TYPE_GENERAL;
	stEventLogImgUnLoadedL1.Severity:= ELOG_SEVERITY_INFO;
	stEventLogImgUnLoadedL1.Facility:= 0;
	stEventLogImgUnLoadedL1.ErrorCode:=0;
	
	stEventLogImgUnLoadedL1.Text := 'Image Unloaded L1';
		
	gEventLogLoader(EventData := ADR(stEventLogImgUnLoadedL1));
	
END_ACTION

ACTION LogAlarmImageNotLoaded:

	stEventLogAlrNotLoadedImage.Source := ELOG_TYPE_GENERAL;
	stEventLogAlrNotLoadedImage.Severity:= ELOG_SEVERITY_INFO;
	stEventLogAlrNotLoadedImage.Facility:= 0;
	stEventLogAlrNotLoadedImage.ErrorCode:=0;
	
	stEventLogAlrNotLoadedImage.Text := 'Alarm Image NOT loaded';
		
	gEventLogLoader(EventData := ADR(stEventLogAlrNotLoadedImage));
	
END_ACTION

ACTION LogAlarmImageLoadedButNoInkBarRelated:

	stLogAlrImageLoadButNoBarRelated.Source := ELOG_TYPE_GENERAL;
	stLogAlrImageLoadButNoBarRelated.Severity:= ELOG_SEVERITY_INFO;
	stLogAlrImageLoadButNoBarRelated.Facility:= 0;
	stLogAlrImageLoadButNoBarRelated.ErrorCode:=0;
	
	stLogAlrImageLoadButNoBarRelated.Text := 'Alarm Image loaded but no ink bar status has color loaded';
		
	gEventLogLoader(EventData := ADR(stLogAlrImageLoadButNoBarRelated));
	
END_ACTION

ACTION LogBeltDistanceTravelledWhenMountedMedia: 
	stEventLogBeltDistanceTravelled.Source := ELOG_TYPE_DETECTION;
	stEventLogBeltDistanceTravelled.Severity:= ELOG_SEVERITY_INFO;
	stEventLogBeltDistanceTravelled.Facility:= 0;
	stEventLogBeltDistanceTravelled.ErrorCode:=0;
	stEventLogBeltDistanceTravelled.Text := 'Belt distance travelled: ';
	
	brsftoa(rBeltDistanceTravelledMm, ADR(strAuxEventDesc));
	brsstrcat(ADR(stEventLogBeltDistanceTravelled.Text), ADR(strAuxEventDesc));
	
	brsstrcat(ADR(stEventLogBeltDistanceTravelled.Text), ADR('mm at '));
	brsftoa(rBeltSpeedInit, ADR(strAuxEventDesc));
	brsstrcat(ADR(stEventLogBeltDistanceTravelled.Text), ADR(strAuxEventDesc));
	
	brsstrcat(ADR(stEventLogBeltDistanceTravelled.Text), ADR('mm/min. Decel at  '));
	brsftoa(gBelt.states.rDeceleration, ADR(strAuxEventDesc));
	brsstrcat(ADR(stEventLogBeltDistanceTravelled.Text), ADR(strAuxEventDesc));
	
	brsstrcat(ADR(stEventLogBeltDistanceTravelled.Text), ADR('mm/s2. Vacuum pressure:'));
	brsftoa(gTransVacuum[1].Status.rPressurePerc, ADR(strAuxEventDesc));
	brsstrcat(ADR(stEventLogBeltDistanceTravelled.Text), ADR(strAuxEventDesc));
	
	brsstrcat(ADR(stEventLogBeltDistanceTravelled.Text), ADR('%. Blowers DC:'));
	brsftoa(gTransVacuum[1].Status.Blower.rDutyCycle, ADR(strAuxEventDesc));
	brsstrcat(ADR(stEventLogBeltDistanceTravelled.Text), ADR(strAuxEventDesc));
	brsstrcat(ADR(stEventLogBeltDistanceTravelled.Text), ADR('%'));
	
	gEventLogLoader(EventData := ADR(stEventLogBeltDistanceTravelled));
	
END_ACTION