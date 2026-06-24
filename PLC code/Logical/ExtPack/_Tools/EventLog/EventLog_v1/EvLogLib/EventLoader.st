
(* TODO: Add your comment here *)
FUNCTION_BLOCK EventLoader

	//If not Semaphore, return
	IF SemId = 0 THEN
		RETURN;
	END_IF
	
	//Create the FIFO at init. Return while creating the FIFO
	IF NOT InitDone THEN
		Fifo.fCreate();
		IF Fifo.fCreate.status = ERR_OK THEN
			Fifo.fCreate.enable := FALSE;
			ident:=Fifo.fCreate.ident;
			InitDone:=TRUE;
		ELSIF Fifo.fCreate.status = fifoERR_FIFO_ALREADY_EXISTS THEN
			statusGetIdent:=fifoGetIdent(pFifo:= ADR('EvLog'), pIdent:=ADR(ident));
			InitDone:=TRUE;
		ELSIF Fifo.fCreate.status <> ERR_FUB_BUSY THEN
			Fifo.fCreate.enable := TRUE;
			Fifo.fCreate.pFifo := ADR('EvLog'); //Name of the FIFO
			Fifo.fCreate.size := 60 * SIZEOF(EventLog_typ); // XX elements size
			Fifo.fCreate.mode := fifoMODE_WRITE_UNTIL_FULL;
		END_IF
		RETURN;
	END_IF
	
	//If nothing to Load, return
	IF ADR(EventData) = 0 THEN
		RETURN;
	END_IF
	
	//Try to Acquire the Semaphore
	uiSemStatus := SemAcquire(SemId);
	IF uiSemStatus = semERR_NOT_FREE THEN
		RETURN;
	END_IF
	
	Fifo.fGetInfo.enable:=TRUE;
	Fifo.fGetInfo.ident := ident;
	Fifo.fGetInfo();	
	
	EventData.Status := ELOG_STATUS_QUEUED;
	EventData.pMyDir := ADR(EventData);
	
	//Add an Event to the Stack
	Fifo.fWrite.enable:=TRUE;
	Fifo.fWrite.pData := ADR(EventData);
	Fifo.fWrite.ident := ident;
	Fifo.fWrite.size := SIZEOF(EventLog_typ);
	Fifo.fWrite();
	
	pEventData:=ADR(EventData);
	
	IF Fifo.fWrite.status = ERR_OK THEN
		Fifo.fWrite.enable:=FALSE;
		//EventData.Status := ELOG_STATUS_QUEUED;
	END_IF		

	InternalEventData:=EventData;
	
	//Release the Semaphore
	SemRelease(SemId);
	
	execAdd := execAdd +1;

END_FUNCTION_BLOCK
