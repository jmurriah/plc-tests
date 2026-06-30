
ACTION LogRejectingEnded: 
	stEventLogEndRejecting.Source := ELOG_TYPE_DETECTION;
	stEventLogEndRejecting.Severity:= ELOG_SEVERITY_INFO;
	stEventLogEndRejecting.Facility:= 0;
	stEventLogEndRejecting.ErrorCode:=0;
	stEventLogEndRejecting.Text := 'ThickCtrl. End Rejected Media Inside';
	gEventLogLoader(EventData := ADR(stEventLogEndRejecting));
END_ACTION

ACTION LogRushProof: 
	stEventLogRushProof.Source := ELOG_TYPE_DETECTION;
	stEventLogRushProof.Severity:= ELOG_SEVERITY_INFO;
	stEventLogRushProof.Facility:= 0;
	stEventLogRushProof.ErrorCode:=0;
	stEventLogRushProof.Text := 'gThicknessCtrl.Commands.xRushProof received. Rush proof counter: ';
	// Adding counter number to log message
	brsitoa(iRushProofCounter, ADR(strAuxEventDesc));
	brsstrcat(ADR(stEventLogRushProof.Text), ADR(strAuxEventDesc));
	
	gEventLogLoader(EventData := ADR(stEventLogRushProof));
END_ACTION