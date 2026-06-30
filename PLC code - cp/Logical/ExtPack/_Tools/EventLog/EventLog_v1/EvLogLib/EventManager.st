
(* TODO: Add your comment here *)
FUNCTION_BLOCK EventManager

	//If not Semaphore, return
	IF SemId = 0 THEN
		RETURN;
	END_IF
	
	//Create the FIFO at init. Return while creating the FIFO
	IF NOT Init THEN
		Fifo.fCreate();
		IF Fifo.fCreate.status = ERR_OK THEN
			Fifo.fCreate.enable := FALSE;
			ident:=Fifo.fCreate.ident;
			Init:=TRUE;
		ELSIF Fifo.fCreate.status = fifoERR_FIFO_ALREADY_EXISTS THEN
			statusGetIdent:=fifoGetIdent(pFifo:= ADR('EvLog'), pIdent:=ADR(ident));
			Init:=TRUE;
		ELSIF Fifo.fCreate.status <> ERR_FUB_BUSY THEN
			Fifo.fCreate.enable := TRUE;
			Fifo.fCreate.pFifo := ADR('EvLog'); //Name of the FIFO
			Fifo.fCreate.size := 60 * SIZEOF(EventLog_typ); // XX elements size
			Fifo.fCreate.mode := fifoMODE_WRITE_UNTIL_FULL;
		END_IF
		RETURN;
	END_IF
	
//	//If EventLog is not configured do not execute code
//	IF ADR(EventLog)=0 THEN
//		Busy := FALSE;
//		RETURN;
//	END_IF

	
	//Take the information about the Stack, to review if there are item to extrack
	Fifo.fGetInfo.enable:=TRUE;
	Fifo.fGetInfo.ident := ident;
	Fifo.fGetInfo();
	
		
	IF xLoggingEvent THEN
		
		//Review when the Event has been logged
		IF EventLog.Event.Status = ELOG_STATUS_LOGGED THEN
			EventDataRead.Status := ELOG_STATUS_LOGGED;
			xLoggingEvent:=FALSE;
		
		//If the Event has not been logged, return to avoid reading another Event and crash the CPU ;-)
		ELSE
			execLogging := execLogging +1;
			RETURN;
		END_IF
		
	END_IF

	IF Fifo.fGetInfo.fifoUsed >0 THEN
	
		//Try to Acquire the Semaphore
		uiSemStatus := SemAcquire(SemId);
		IF uiSemStatus = semERR_NOT_FREE THEN
			RETURN;
		END_IF
		
		//Take the information about the Stack, to review if there are item to extrack
		//Read information about the Stack
		Fifo.fRead.enable := TRUE;
		Fifo.fRead.ident := ident;
		Fifo.fRead.size := SIZEOF(EventLog_typ);
		Fifo.fRead.pData := ADR(InternalEventData);
		Fifo.fRead();

		pEventData:=ADR(InternalEventData);
		EventDataRead ACCESS InternalEventData.pMyDir;
		EventDataRead.Status := ELOG_STATUS_LOGGING;
		
		//Text too long protection
		IF brsstrlen(ADR(EventDataRead.Text)) > 125 THEN 
			brsstrcpy(ADR(EventLog.Event.AdditionalData), ADR('Text too long. Protected to avoid CPU to service'));
		ELSE
			brsstrcpy(ADR(EventLog.Event.AdditionalData), ADR(EventDataRead.Text));
		END_IF
		
		EventLog.Event.AdditionalDataSize := brsstrlen(ADR(EventLog.Event.AdditionalData)) + 1;
		EventLog.Event.AdditionalDataFormat := arEVENTLOG_ADDFORMAT_TEXT;
		
		EventLog.Event.Severity := GetSeverity(EventDataRead.Severity);
		EventLog.Event.Facility := EventDataRead.Facility;
		EventLog.Event.ErrorCode := EventDataRead.ErrorCode;
		
		//EventLog.Event.EnteredBy := 'TheGroup'; 
		GetGroupName( GenEventLog:=ADR(EventLog), EventLog:=ADR(EventDataRead));
		EventLog.Commands.WriteUserEvent:= TRUE;

		xLoggingEvent:=TRUE;
		
		//Release the Semaphore
		SemRelease(SemId);

		execEventData := execEventData + 1;
				
	END_IF
	
	execReview := execReview +1;

END_FUNCTION_BLOCK

FUNCTION GetGroupName
	
	CASE EventLog.Source OF
	
		ELOG_TYPE_GENERAL:
			GenEventLog.Event.EnteredBy := 'General';
		ELOG_TYPE_BAR:
			GenEventLog.Event.EnteredBy := 'Bars';
		ELOG_TYPE_BLOCK:
			GenEventLog.Event.EnteredBy := 'Blocks';
		ELOG_TYPE_SIMPLEBLOCK:
			GenEventLog.Event.EnteredBy := 'Simple Blocks';
		ELOG_TYPE_BELT:
			GenEventLog.Event.EnteredBy := 'Belt';
		ELOG_TYPE_LED:
			GenEventLog.Event.EnteredBy := 'CuringLeds';
		ELOG_TYPE_TRANS_VACUUM:
			GenEventLog.Event.EnteredBy := 'Tr. Vacuum';
		ELOG_TYPE_NONCRASH:
			GenEventLog.Event.EnteredBy := 'Non Crash';
		ELOG_TYPE_NIR:
			GenEventLog.Event.EnteredBy := 'NIR';
		ELOG_TYPE_ARCLAMP:
			GenEventLog.Event.EnteredBy := 'Arc Lamp';
		ELOG_TYPE_DETECTION:
			GenEventLog.Event.EnteredBy := 'Detection';
		ELOG_TYPE_EHD:
			GenEventLog.Event.EnteredBy := 'EHD';
		ELOG_TYPE_PAIRED_ICLA:
			GenEventLog.Event.EnteredBy := 'Pair Icla';
		
	END_CASE
	GetGroupName := TRUE; //Return value to avoid warning
	
END_FUNCTION

FUNCTION GetSeverity
	
	CASE Severity OF
	
		ELOG_SEVERITY_INFO:
			GetSeverity := arEVENTLOG_SEVERITY_INFO;
		ELOG_SEVERITY_WARNING:
			GetSeverity := arEVENTLOG_SEVERITY_WARNING;
		ELOG_SEVERITY_ERROR:
			GetSeverity := arEVENTLOG_SEVERITY_ERROR;
		ELOG_SEVERITY_SUCCESS:
			GetSeverity := arEVENTLOG_SEVERITY_SUCCESS;

	END_CASE

END_FUNCTION
