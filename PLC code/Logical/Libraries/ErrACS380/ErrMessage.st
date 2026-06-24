
(*<$Description$> Takes the error list and the current error ID and gives back the message associated </$Description$>*)
FUNCTION_BLOCK ErrMessage
	
	CASE Internal.Step OF
		// -----------------------------------------------------------------
		0: 		(* DISABLED *)
			
			Status	:= DISABLED;
			
			IF Enable THEN
				Internal.Step	:= 1;
			END_IF
			
			
		// -----------------------------------------------------------------
		1:		(* WAITING *)
			
			Status	:= STATUS_OK;
			
			IF NewID THEN
				NewID			:= FALSE;
				Internal.Step	:= 2;
			END_IF
			
			
		// -----------------------------------------------------------------
		2: 		(* BUSY *)
			
			Status	:= ACS380_BUSY;
			
			FOR Internal.Counter := 0 TO MAX_ERR_LIST DO
				
				IF ErrList[Internal.Counter].ErrorID = CurrentErrID THEN
					
					CurrentErrMessage		:= ErrList[Internal.Counter].ErrorText;
					Internal.ErrNotFound	:= FALSE;
					Internal.Step			:= 3;
					EXIT;
					
				ELSE
					
					Internal.ErrNotFound	:= TRUE;
					
				END_IF
				
			END_FOR
			
			IF Internal.ErrNotFound THEN
				Internal.StatusError	:= TRUE;
				Internal.Step			:= 9;
			END_IF
		
		// -----------------------------------------------------------------
		3:		(* DONE *)
			
			Status	:= DONE;
		
			IF NewID THEN
				NewID			:= FALSE;
				Internal.Step	:= 2;
			END_IF
			
		// -----------------------------------------------------------------
		9:	(* ERROR *)
		
			Status	:= ERR;
		
			IF NewID THEN
				NewID			:= FALSE;
				Internal.Step	:= 2;
			END_IF
		
			
	END_CASE
	
	
	
END_FUNCTION_BLOCK
