
ACTION EndComms: 
	
	IF tonCommand.Q	THEN
		dataArcLamp.Status.CommsStatus := ARCLG_IDLE;
		dataArcLamp.Commands.InternalComms := CommsCmdReseted;
	END_IF
	
END_ACTION
