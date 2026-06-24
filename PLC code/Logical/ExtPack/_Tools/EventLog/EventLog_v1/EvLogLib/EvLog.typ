
TYPE
	EventLogSeverity_enum : 
		(
		ELOG_SEVERITY_INFO,
		ELOG_SEVERITY_WARNING,
		ELOG_SEVERITY_ERROR,
		ELOG_SEVERITY_SUCCESS
		);
	EventLogStatus_enum : 
		(
		ELOG_STATUS_CREATED,
		ELOG_STATUS_QUEUED,
		ELOG_STATUS_LOGGING,
		ELOG_STATUS_LOGGED
		);
	EventLogCreatedBy_enum : 
		(
		ELOG_TYPE_GENERAL,
		ELOG_TYPE_BAR,
		ELOG_TYPE_BLOCK,
		ELOG_TYPE_SIMPLEBLOCK,
		ELOG_TYPE_BELT,
		ELOG_TYPE_LED,
		ELOG_TYPE_TRANS_VACUUM,
		ELOG_TYPE_NONCRASH,
		ELOG_TYPE_NIR,
		ELOG_TYPE_ARCLAMP,
		ELOG_TYPE_DETECTION,
		ELOG_TYPE_EHD,
		ELOG_TYPE_PAIRED_ICLA
		);
	EventLogStatus_typ : 	STRUCT 
		Location : USINT;
		Source : BOOL;
		xQueued : BOOL;
	END_STRUCT;
	EventLog_typ : 	STRUCT 
		Severity : EventLogSeverity_enum := ELOG_SEVERITY_INFO; (*Severity of the last event (read).*)
		Facility : UINT; (*Facility of the last event (read).*)
		ErrorCode : UINT; (*Error number of the event- set when the read event is no event id event (read).*)
		Source : EventLogCreatedBy_enum := ELOG_TYPE_GENERAL;
		Status : EventLogStatus_enum := ELOG_STATUS_CREATED;
		Text : STRING[129];
		pMyDir : UDINT;
	END_STRUCT;
	EventLogFifoFB : 	STRUCT 
		fDelete : fifoDelete;
		fWrite : fifoWrite;
		fRead : fifoRead;
		fGetInfo : fifoGetInfo;
		fCreate : fifoCreate;
	END_STRUCT;
	GenEventLog_typ : 	STRUCT  (*Event handling.*)
		Commands : EventLog_Commands_typ; (*Event handling user commands.*)
		Data : EventLog_Data_typ; (*Event handling data for state machine.*)
		Status : EventLog_Status_typ; (*Event handling event description.*)
		Event : EventLog_Event_typ; (*Event handling event description.*)
		FunctionBlocks : EventLog_FunctionBlocks_typ; (*Event handling used functionblocks.*)
	END_STRUCT;
	EventLog_Commands_typ : 	STRUCT 
		CreateUserLog : BOOL; (*Creates the user logbook "EFIEvLog" in USERROM.*)
		DeleteUserLog : BOOL; (*Deletes the user logbook "EFIEvLog".*)
		WriteUserEvent : BOOL; (*Writes a user event into the user logbook "EFIEvLog". *)
		ReadLatestEvent : BOOL; (*Reads the latest event of the user logbook "EFIEvLog".*)
		ReadPreviousEvent : BOOL; (*Reads the previous event (of the given record id) of the user logbook "UserEvLog".*)
	END_STRUCT;
	EventLog_Status_typ : 	STRUCT 
		execWriteEvent : UDINT; (*Status information for STEP_ERROR.*)
		execCreateLog : UDINT; (*Status information for STEP_ERROR.*)
	END_STRUCT;
	EventLog_Data_typ : 	STRUCT 
		Step : EventLogSteps; (*Current step. STEP_ERROR must be manually reset (STEP_WAIT_FOR_INPUT).*)
		Ident : ArEventLogIdentType; (*Ident of the logbook "EFIEvLog".*)
		StatusID : DINT; (*Status information for STEP_ERROR.*)
		GetIdentOkNextStep : EventLogSteps; (*Internal helper for state machine.*)
		GetIdentFailNextStep : EventLogSteps; (*Internal helper for state machine.*)
	END_STRUCT;
	EventLog_Event_typ : 	STRUCT 
		Severity : USINT; (*Severity of the last event (read).*)
		Customer : BOOL; (*Customer bit of the last event (read).*)
		Facility : UINT; (*Facility of the last event (read).*)
		Code : UINT; (*Code of the last event (read).*)
		EventID : DINT; (*EventID for write event (write - is not set by reading an event).*)
		ErrorCode : UINT; (*Error number of the event- set when the read event is no event id event (read).*)
		ErrorNumber : UDINT; (*Error number of the event- set when the read event is no event id event (read).*)
		EnteredBy : STRING[36]; (*User/object identification (read/write - optional).*)
		OriginID : ArEventLogRecordIDType; (*Record id of the origin record (read/write - optional).*)
		RecordID : ArEventLogRecordIDType; (*Record id of the event to read (read - set automatically).*)
		TimeStamp : ArEventLogTimeStampType;
		Status : EventLogStatus_enum;
		AdditionalDataSize : UDINT; (*Size of the additional data (read/write - optional)*)
		AdditionalDataFormat : USINT; (*Format of the additional data (read/write)*)
		AdditionalData : ARRAY[0..128]OF USINT; (*Additional data (read/write)*)
	END_STRUCT;
	EventLog_FunctionBlocks_typ : 	STRUCT 
		ArEventLogCreate_0 : ArEventLogCreate;
		ArEventLogDelete_0 : ArEventLogDelete;
		ArEventLogGetIdent_0 : ArEventLogGetIdent;
		ArEventLogGetLatestRecordID_0 : ArEventLogGetLatestRecordID;
		ArEventLogGetPreviousRecordID_0 : ArEventLogGetPreviousRecordID;
		ArEventLogWrite_0 : ArEventLogWrite;
		ArEventLogRead_0 : ArEventLogRead;
		ArEventLogReadErrorNumber_0 : ArEventLogReadErrorNumber;
		ArEventLogReadAddData_0 : ArEventLogReadAddData;
		ArEventLogReadObjectID_0 : ArEventLogReadObjectID;
	END_STRUCT;
	EventLogSteps : 
		(
		STEP_WAIT_FOR_INPUT := 0,
		STEP_CREATE_LOGBOOK := 1,
		STEP_DELETE_LOGBOOK := 2,
		STEP_GET_LOGBOOK_IDENT := 3,
		STEP_WRITE_EVENT := 4,
		STEP_READ_EVENT := 5,
		STEP_READ_ERROR_NUMBER := 6,
		STEP_READ_ADDITIONAL_DATA := 7,
		STEP_READ_OBJECT_ID := 8,
		STEP_GET_LATEST_RECORD_ID := 9,
		STEP_GET_PREVIOUS_RECORD_ID := 10,
		STEP_ERROR := 255
		);
END_TYPE
