(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * PROGRAM: EventLog
 * File: EventLog.st
 * Author: Bernecker + Rainer
 * Created: June, 2015
 ********************************************************************
 * Implementation OF PROGRAM EventLog
 ********************************************************************)

PROGRAM _INIT
	EventLog.Event.EnteredBy := 'UserID';
	brsstrcpy(ADR(EventLog.Event.AdditionalData), ADR('This is an information entry from the user.'));
	EventLog.Event.AdditionalDataSize := brsstrlen(ADR(EventLog.Event.AdditionalData)) + 1;
	EventLog.Event.AdditionalDataFormat := arEVENTLOG_ADDFORMAT_TEXT;
	(*See ArEventLog help for the description of the event id, facilities 0-15 are reserved for customer use.*)
	EventLog.Event.EventID := ArEventLogMakeEventID(Severity := arEVENTLOG_SEVERITY_INFO, Facility := 10, ErrorCode := 1024);
	EventLog.Commands.CreateUserLog := TRUE; //Always try to create after Init. If the logBook exists, error and keep on working
	
	//Start the Semaphore creation
	SemFifoCreate.enable := TRUE;
	SemFifoCreate.initCount := 0;  (* initial value of the semaphore *)
	SemFifoCreate.maxCount := 1;  (* maximum possible allocation of semaphore *)
	SemFifoCreate();  (* call the function*)

END_PROGRAM

PROGRAM _CYCLIC
	
	//Wait to create the semaphore
	IF SemIdent = 0 THEN
		IF SemFifoCreate.status = ERR_OK THEN  //SemCreate successful
			SemIdent := SemFifoCreate.ident;  //copy semaphore-ident the a local variable
			SemFifoCreate(enable := FALSE);

			SemRelease( SemIdent );  //release the allocated semaphore
			gEventLogLoader(SemId := SemIdent); //Send the information to the loader
			gEventLogManager(SemId := SemIdent); //Sent the information to the manager
		ELSE
			SemFifoCreate();
			RETURN;
		END_IF
	END_IF

	//Initialize gEventLogLoader
	IF NOT gEventLogLoader.InitDone THEN
		gEventLogLoader();
	END_IF
				
	//If EventLogManager is not been executed by adding an event, execute it
	gEventLogManager(EventLog := ADR(EventLog));
	
	CASE EventLog.Data.Step OF
		(*Waits for user input (command).*)
		STEP_WAIT_FOR_INPUT:
			IF EventLog.Commands.CreateUserLog THEN
				EventLog.Commands.CreateUserLog := FALSE;
				EventLog.Data.Step := STEP_GET_LOGBOOK_IDENT;
				EventLog.Data.GetIdentFailNextStep := STEP_CREATE_LOGBOOK;
				EventLog.Data.GetIdentOkNextStep := STEP_WAIT_FOR_INPUT;
				EventLog.Status.execCreateLog:=EventLog.Status.execCreateLog+1;
			ELSIF EventLog.Commands.DeleteUserLog THEN
				EventLog.Commands.DeleteUserLog := FALSE;
				EventLog.Data.Step := STEP_GET_LOGBOOK_IDENT;
				EventLog.Data.GetIdentFailNextStep := STEP_ERROR;
				EventLog.Data.GetIdentOkNextStep := STEP_DELETE_LOGBOOK;
			ELSIF EventLog.Commands.WriteUserEvent THEN
				EventLog.Commands.WriteUserEvent := FALSE;
				EventLog.Data.Step := STEP_GET_LOGBOOK_IDENT;
				EventLog.Data.GetIdentFailNextStep := STEP_ERROR;
				EventLog.Data.GetIdentOkNextStep := STEP_WRITE_EVENT;
				
				EventLog.Status.execWriteEvent:=EventLog.Status.execWriteEvent+1;
				EventLog.Event.Status := ELOG_STATUS_LOGGING;
			
			ELSIF EventLog.Commands.ReadLatestEvent THEN
				EventLog.Commands.ReadLatestEvent := FALSE;
				EventLog.Data.Step := STEP_GET_LOGBOOK_IDENT;
				EventLog.Data.GetIdentFailNextStep := STEP_ERROR;
				EventLog.Data.GetIdentOkNextStep := STEP_GET_LATEST_RECORD_ID;
			ELSIF EventLog.Commands.ReadPreviousEvent THEN
				EventLog.Commands.ReadPreviousEvent := FALSE;
				EventLog.Data.Step := STEP_GET_LOGBOOK_IDENT;
				EventLog.Data.GetIdentFailNextStep := STEP_ERROR;
				EventLog.Data.GetIdentOkNextStep := STEP_GET_PREVIOUS_RECORD_ID;
			END_IF
		
		(*Gets the ident of the user logbook "EFIEvLog".*)
		STEP_GET_LOGBOOK_IDENT:
			IF EventLog.FunctionBlocks.ArEventLogGetIdent_0.Done THEN
				EventLog.FunctionBlocks.ArEventLogGetIdent_0.Execute := FALSE;
				EventLog.Data.Ident := EventLog.FunctionBlocks.ArEventLogGetIdent_0.Ident;
				EventLog.Data.StatusID := ERR_OK;
				EventLog.Data.Step := EventLog.Data.GetIdentOkNextStep;
			ELSIF EventLog.FunctionBlocks.ArEventLogGetIdent_0.Error THEN
				EventLog.FunctionBlocks.ArEventLogGetIdent_0.Execute := FALSE;
				EventLog.Data.StatusID := EventLog.FunctionBlocks.ArEventLogGetIdent_0.StatusID;
				EventLog.Data.Step := EventLog.Data.GetIdentFailNextStep;
			ELSE
				(*Execute the FB only if the ident isn't already set.*)
				IF EventLog.Data.Ident = 0 THEN
					EventLog.FunctionBlocks.ArEventLogGetIdent_0.Name := 'EFIEvLog';
					EventLog.FunctionBlocks.ArEventLogGetIdent_0.Execute := TRUE;
				ELSE
					EventLog.Data.StatusID := ERR_OK;
					EventLog.Data.Step := EventLog.Data.GetIdentOkNextStep;	
				END_IF
			END_IF
		
		(*Creates the user logbook "EFIEvLog".*)
		STEP_CREATE_LOGBOOK:
			IF EventLog.FunctionBlocks.ArEventLogCreate_0.Done THEN
				EventLog.FunctionBlocks.ArEventLogCreate_0.Execute := FALSE;
				EventLog.Data.Ident := EventLog.FunctionBlocks.ArEventLogCreate_0.Ident;
				EventLog.Data.StatusID := ERR_OK;
				EventLog.Data.Step := STEP_WAIT_FOR_INPUT;
			ELSIF EventLog.FunctionBlocks.ArEventLogCreate_0.Error THEN
				EventLog.FunctionBlocks.ArEventLogCreate_0.Execute := FALSE;
				EventLog.Data.StatusID := EventLog.FunctionBlocks.ArEventLogCreate_0.StatusID;
				EventLog.Data.Step := STEP_ERROR;
			ELSE
				EventLog.FunctionBlocks.ArEventLogCreate_0.Name := 'EFIEvLog';
				EventLog.FunctionBlocks.ArEventLogCreate_0.Size := 4096000;
				EventLog.FunctionBlocks.ArEventLogCreate_0.Persistence := arEVENTLOG_PERSISTENCE_PERSIST;
				EventLog.FunctionBlocks.ArEventLogCreate_0.Info := 0;
				EventLog.FunctionBlocks.ArEventLogCreate_0.Execute := TRUE;
			END_IF
	
		(*Deletes the user logbook "EFIEvLog".*)
		STEP_DELETE_LOGBOOK:
			IF EventLog.FunctionBlocks.ArEventLogDelete_0.Done THEN
				EventLog.FunctionBlocks.ArEventLogDelete_0.Execute := FALSE;
				EventLog.Data.Ident := 0;
				EventLog.Data.StatusID := ERR_OK;
				EventLog.Data.Step := STEP_WAIT_FOR_INPUT;
			ELSIF EventLog.FunctionBlocks.ArEventLogDelete_0.Error THEN
				EventLog.FunctionBlocks.ArEventLogDelete_0.Execute := FALSE;
				EventLog.Data.StatusID := EventLog.FunctionBlocks.ArEventLogDelete_0.StatusID;
				EventLog.Data.Step := STEP_ERROR;
			ELSE
				EventLog.FunctionBlocks.ArEventLogDelete_0.Ident := EventLog.Data.Ident;
				EventLog.FunctionBlocks.ArEventLogDelete_0.Execute := TRUE;
			END_IF
		
		(*Writes the event set in EventLog.Event to the user logbook "EFIEvLog".*)
		STEP_WRITE_EVENT:
			IF EventLog.FunctionBlocks.ArEventLogWrite_0.Done THEN
				EventLog.FunctionBlocks.ArEventLogWrite_0.Execute := FALSE;
				EventLog.Data.StatusID := ERR_OK;
				EventLog.Data.Step := STEP_WAIT_FOR_INPUT;
				EventLog.Event.Status := ELOG_STATUS_LOGGED;
			ELSIF EventLog.FunctionBlocks.ArEventLogWrite_0.Error THEN
				EventLog.FunctionBlocks.ArEventLogWrite_0.Execute := FALSE;
				EventLog.Data.StatusID := EventLog.FunctionBlocks.ArEventLogWrite_0.StatusID;
				EventLog.Data.Step := STEP_ERROR;
			ELSE
				EventLog.FunctionBlocks.ArEventLogWrite_0.Ident := EventLog.Data.Ident;
				EventLog.Event.EventID := ArEventLogMakeEventID(Severity := EventLog.Event.Severity, Facility := EventLog.Event.Facility, ErrorCode := EventLog.Event.ErrorCode);
				EventLog.FunctionBlocks.ArEventLogWrite_0.EventID := EventLog.Event.EventID;
				EventLog.FunctionBlocks.ArEventLogWrite_0.TimeStamp := 0; (*System timestamp.*)
				EventLog.FunctionBlocks.ArEventLogWrite_0.ObjectID := EventLog.Event.EnteredBy;
				EventLog.FunctionBlocks.ArEventLogWrite_0.OriginRecordID := EventLog.Event.OriginID;
				EventLog.FunctionBlocks.ArEventLogWrite_0.AddDataFormat := EventLog.Event.AdditionalDataFormat;
				EventLog.FunctionBlocks.ArEventLogWrite_0.AddDataSize := EventLog.Event.AdditionalDataSize;
				EventLog.FunctionBlocks.ArEventLogWrite_0.AddData := ADR(EventLog.Event.AdditionalData);
				EventLog.FunctionBlocks.ArEventLogWrite_0.Execute := TRUE;
			END_IF
		
		(*Gets the id of the latest record in the user logbook "EFIEvLog".*)
		STEP_GET_LATEST_RECORD_ID:
			IF EventLog.FunctionBlocks.ArEventLogGetLatestRecordID_0.Done THEN
				EventLog.FunctionBlocks.ArEventLogGetLatestRecordID_0.Execute := FALSE;
				EventLog.Event.RecordID := EventLog.FunctionBlocks.ArEventLogGetLatestRecordID_0.RecordID;
				EventLog.Data.StatusID := ERR_OK;
				EventLog.Data.Step := STEP_READ_EVENT;
			ELSIF EventLog.FunctionBlocks.ArEventLogGetLatestRecordID_0.Error THEN
				EventLog.FunctionBlocks.ArEventLogGetLatestRecordID_0.Execute := FALSE;
				EventLog.Data.StatusID := EventLog.FunctionBlocks.ArEventLogGetLatestRecordID_0.StatusID;
				EventLog.Data.Step := STEP_ERROR;
			ELSE
				EventLog.FunctionBlocks.ArEventLogGetLatestRecordID_0.Ident := EventLog.Data.Ident;
				EventLog.FunctionBlocks.ArEventLogGetLatestRecordID_0.Execute := TRUE;
			END_IF
		
		(*Gets the id of the previous record of the given record id (EventLog.Event.RecordID).*)
		STEP_GET_PREVIOUS_RECORD_ID:
			IF EventLog.FunctionBlocks.ArEventLogGetPreviousRecordID_0.Done THEN
				EventLog.FunctionBlocks.ArEventLogGetPreviousRecordID_0.Execute := FALSE;
				EventLog.Event.RecordID := EventLog.FunctionBlocks.ArEventLogGetPreviousRecordID_0.PrevRecordID;
				EventLog.Data.StatusID := ERR_OK;
				EventLog.Data.Step := STEP_READ_EVENT;
			ELSIF EventLog.FunctionBlocks.ArEventLogGetPreviousRecordID_0.Error THEN
				EventLog.FunctionBlocks.ArEventLogGetPreviousRecordID_0.Execute := FALSE;
				EventLog.Data.StatusID := EventLog.FunctionBlocks.ArEventLogGetPreviousRecordID_0.StatusID;
				EventLog.Data.Step := STEP_ERROR;
			ELSE
				EventLog.FunctionBlocks.ArEventLogGetPreviousRecordID_0.Ident := EventLog.Data.Ident;
				EventLog.FunctionBlocks.ArEventLogGetPreviousRecordID_0.RecordID := EventLog.Event.RecordID;
				EventLog.FunctionBlocks.ArEventLogGetPreviousRecordID_0.Execute := TRUE;
			END_IF
	
		(*Reads the event with the given record id from the to user logbook "EFIEvLog".*)
		STEP_READ_EVENT:
			IF EventLog.FunctionBlocks.ArEventLogRead_0.Done THEN
				EventLog.FunctionBlocks.ArEventLogRead_0.Execute := FALSE;
				EventLog.Event.AdditionalDataFormat := EventLog.FunctionBlocks.ArEventLogRead_0.AddDataFormat;
				EventLog.Event.AdditionalDataSize := EventLog.FunctionBlocks.ArEventLogRead_0.AddDataSize;
				EventLog.Event.TimeStamp := EventLog.FunctionBlocks.ArEventLogRead_0.TimeStamp;
				EventLog.Event.OriginID := EventLog.FunctionBlocks.ArEventLogRead_0.OriginRecordID;
				EventLog.Data.StatusID := ERR_OK;
				EventLog.Event.ErrorNumber := 0;
				EventLog.Event.Customer := ArEventLogIsCustomerArea(EventID := EventLog.FunctionBlocks.ArEventLogRead_0.EventID);
				EventLog.Event.Severity := GetSeverity(EventID := EventLog.FunctionBlocks.ArEventLogRead_0.EventID);
				EventLog.Event.Code := GetCode(EventID := EventLog.FunctionBlocks.ArEventLogRead_0.EventID);
				EventLog.Event.Facility := GetFacility(EventID := EventLog.FunctionBlocks.ArEventLogRead_0.EventID);	
				IF EventLog.FunctionBlocks.ArEventLogRead_0.StatusID = arEVENTLOG_WRN_NO_EVENTID THEN
					(*The given record id is not an event id record. Invoke ArEventLogReadErrorNumber to read the error number and the severity.*)
					EventLog.Data.Step := STEP_READ_ERROR_NUMBER;
				ELSIF EventLog.Event.AdditionalDataSize > 0 THEN
					EventLog.Data.Step := STEP_READ_ADDITIONAL_DATA;
				ELSE
					EventLog.Data.Step := STEP_READ_OBJECT_ID;
				END_IF			
			ELSIF EventLog.FunctionBlocks.ArEventLogRead_0.Error THEN
				EventLog.FunctionBlocks.ArEventLogRead_0.Execute := FALSE;
				EventLog.Data.StatusID := EventLog.FunctionBlocks.ArEventLogRead_0.StatusID;
				EventLog.Data.Step := STEP_ERROR;
			ELSE
				EventLog.FunctionBlocks.ArEventLogRead_0.Ident := EventLog.Data.Ident;
				EventLog.FunctionBlocks.ArEventLogRead_0.RecordID := EventLog.Event.RecordID;
				EventLog.FunctionBlocks.ArEventLogRead_0.Execute := TRUE;
			END_IF
		
		(*Reads the error number event with the given record id from the user logbook "EFIEvLog".*)
		STEP_READ_ERROR_NUMBER:
			IF EventLog.FunctionBlocks.ArEventLogReadErrorNumber_0.Done THEN
				EventLog.FunctionBlocks.ArEventLogReadErrorNumber_0.Execute := FALSE;
				EventLog.Event.ErrorNumber := EventLog.FunctionBlocks.ArEventLogReadErrorNumber_0.ErrorNumber;
				EventLog.Event.Severity := EventLog.FunctionBlocks.ArEventLogReadErrorNumber_0.Severity;
				EventLog.Data.StatusID := ERR_OK;
				IF EventLog.Event.AdditionalDataSize > 0 THEN
					EventLog.Data.Step := STEP_READ_ADDITIONAL_DATA;
				ELSE
					EventLog.Data.Step := STEP_READ_OBJECT_ID;
				END_IF
			ELSIF EventLog.FunctionBlocks.ArEventLogReadErrorNumber_0.Error THEN
				EventLog.FunctionBlocks.ArEventLogReadErrorNumber_0.Execute := FALSE;
				EventLog.Data.StatusID := EventLog.FunctionBlocks.ArEventLogReadErrorNumber_0.StatusID;
				EventLog.Data.Step := STEP_ERROR;
			ELSE
				EventLog.FunctionBlocks.ArEventLogReadErrorNumber_0.Ident := EventLog.Data.Ident;
				EventLog.FunctionBlocks.ArEventLogReadErrorNumber_0.RecordID := EventLog.Event.RecordID;
				EventLog.FunctionBlocks.ArEventLogReadErrorNumber_0.Execute := TRUE;
			END_IF

		(*Reads the additional data of the event with the given record id from the user logbook "EFIEvLog".*)
		STEP_READ_ADDITIONAL_DATA:
			IF EventLog.FunctionBlocks.ArEventLogReadAddData_0.Done THEN
				EventLog.FunctionBlocks.ArEventLogReadAddData_0.Execute := FALSE;
				EventLog.Event.AdditionalDataSize := EventLog.FunctionBlocks.ArEventLogReadAddData_0.AddDataSize;
				EventLog.Data.StatusID := ERR_OK;
				EventLog.Data.Step := STEP_READ_OBJECT_ID;
			ELSIF EventLog.FunctionBlocks.ArEventLogReadAddData_0.Error THEN
				EventLog.FunctionBlocks.ArEventLogReadAddData_0.Execute := FALSE;
				EventLog.Data.StatusID := EventLog.FunctionBlocks.ArEventLogReadAddData_0.StatusID;
				EventLog.Data.Step := STEP_ERROR;
			ELSE
				EventLog.FunctionBlocks.ArEventLogReadAddData_0.Ident := EventLog.Data.Ident;
				EventLog.FunctionBlocks.ArEventLogReadAddData_0.RecordID := EventLog.Event.RecordID;
				EventLog.FunctionBlocks.ArEventLogReadAddData_0.BytesToRead := SIZEOF(EventLog.Event.AdditionalData);
				EventLog.FunctionBlocks.ArEventLogReadAddData_0.AddData := ADR(EventLog.Event.AdditionalData);
				EventLog.FunctionBlocks.ArEventLogReadAddData_0.Execute := TRUE;
			END_IF

		(*Reads the object id of the event with the given record id from the user logbook "EFIEvLog".*)
		STEP_READ_OBJECT_ID:
			IF EventLog.FunctionBlocks.ArEventLogReadObjectID_0.Done THEN
				EventLog.FunctionBlocks.ArEventLogReadObjectID_0.Execute := FALSE;
				EventLog.Event.EnteredBy := EventLog.FunctionBlocks.ArEventLogReadObjectID_0.ObjectID;
				EventLog.Data.StatusID := ERR_OK;
				EventLog.Data.Step := STEP_WAIT_FOR_INPUT;
			ELSIF EventLog.FunctionBlocks.ArEventLogReadObjectID_0.Error THEN
				EventLog.FunctionBlocks.ArEventLogReadObjectID_0.Execute := FALSE;
				EventLog.Data.StatusID := EventLog.FunctionBlocks.ArEventLogReadObjectID_0.StatusID;
				EventLog.Data.Step := STEP_ERROR;
			ELSE
				EventLog.FunctionBlocks.ArEventLogReadObjectID_0.Ident := EventLog.Data.Ident;
				EventLog.FunctionBlocks.ArEventLogReadObjectID_0.RecordID := EventLog.Event.RecordID;
				EventLog.FunctionBlocks.ArEventLogReadObjectID_0.Execute := TRUE;
			END_IF
		
		STEP_ERROR:
		(*Do some error handling here.*)
	END_CASE
	
	EventLog.FunctionBlocks.ArEventLogCreate_0;
	EventLog.FunctionBlocks.ArEventLogDelete_0;
	EventLog.FunctionBlocks.ArEventLogWrite_0;
	EventLog.FunctionBlocks.ArEventLogGetIdent_0;
	EventLog.FunctionBlocks.ArEventLogGetLatestRecordID_0;
	EventLog.FunctionBlocks.ArEventLogGetPreviousRecordID_0;
	EventLog.FunctionBlocks.ArEventLogReadAddData_0;
	EventLog.FunctionBlocks.ArEventLogReadErrorNumber_0;
	EventLog.FunctionBlocks.ArEventLogReadObjectID_0;
	EventLog.FunctionBlocks.ArEventLogRead_0;
END_PROGRAM

(*See ArEventLog help for the description of the event id format!*)

(*Gets severity from EventId (bits 31-30).*)
FUNCTION GetSeverity
	IF ArEventLogIsError(EventID := EventID) THEN
		GetSeverity := arEVENTLOG_SEVERITY_ERROR;
	ELSIF ArEventLogIsWarning(EventID := EventID) THEN
		GetSeverity := arEVENTLOG_SEVERITY_WARNING;
	ELSIF ArEventLogIsInformation(EventID := EventID) THEN
		GetSeverity := arEVENTLOG_SEVERITY_INFO;
	ELSIF ArEventLogIsSuccess(EventID := EventID) THEN
		GetSeverity := arEVENTLOG_SEVERITY_SUCCESS;
	END_IF
END_FUNCTION

(*Gets code from EventId (bits 15-0).*)
FUNCTION GetCode
	GetCode := DINT_TO_UINT(EventID);
END_FUNCTION

(*Gets facility from EventId (bits 27-16).*)
FUNCTION GetFacility
	GetFacility := DINT_TO_UINT(SHR(EventID, 16) AND 16#0FFF);
END_FUNCTION
