
ACTION EndComms: 
	
	IF tonCommand.Q	THEN
		dataNir.Status.CommsStatus := ARCLG_IDLE;
		dataNir.Commands.InternalComms := CommsCmdReseted;
	END_IF
	
END_ACTION
