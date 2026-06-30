
FUNCTION GetSeverity : USINT
	VAR_INPUT
		Severity : EventLogSeverity_enum;
	END_VAR
END_FUNCTION

FUNCTION GetGroupName : BOOL
	VAR_INPUT
		GenEventLog : REFERENCE TO GenEventLog_typ;
		EventLog : REFERENCE TO EventLog_typ;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION_BLOCK EventLoader (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		EventData : REFERENCE TO EventLog_typ;
		SemId : UDINT; (*Semaphore identifier*)
	END_VAR
	VAR_OUTPUT
		InitDone : BOOL := FALSE; (*0*)
	END_VAR
	VAR
		execAdd : UDINT; (*0*)
		statusGetIdent : UDINT := 0; (*0*)
		ident : UDINT := 0; (*0*)
		pEventData : UDINT;
		Fifo : EventLogFifoFB; (*0*)
		InternalEventData : {REDUND_UNREPLICABLE} EventLog_typ;
		uiSemStatus : UINT;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK EventManager (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		EventLog : REFERENCE TO GenEventLog_typ;
		SemId : UDINT; (*Semaphore identifier*)
	END_VAR
	VAR
		workEventData : REFERENCE TO EventLog_typ; (*The eventData to work with the program to write*)
		execReview : UDINT; (*0*)
		execEventData : UDINT; (*0*)
		execLogging : UDINT; (*0*)
		statusGetIdent : UDINT := 0; (*0*)
		ident : UDINT := 0; (*0*)
		xLoggingEvent : BOOL := FALSE; (*0*)
		Init : BOOL := FALSE; (*0*)
		Fifo : EventLogFifoFB; (*0*)
		pEventData : UDINT;
		EventDataRead : REFERENCE TO EventLog_typ;
		InternalEventData : {REDUND_UNREPLICABLE} EventLog_typ;
		uiSemStatus : UINT;
	END_VAR
END_FUNCTION_BLOCK
