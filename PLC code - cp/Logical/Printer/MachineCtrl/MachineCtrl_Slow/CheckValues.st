
ACTION CheckValues: 

	// MEDIA // MEDIA // MEDIA // MEDIA // MEDIA // MEDIA // MEDIA
	// MEDIA // MEDIA // MEDIA // MEDIA // MEDIA // MEDIA // MEDIA

	IF NOT gMachine.parSw.Dtp.xDoubleLine THEN
		// Single line check
		CheckSingleLineMedia;
	END_IF
	
END_ACTION


ACTION CheckSingleLineMedia: 

	//The Maximum width is 1400, So 2*Offset + Width should always be 1400. If no, it is an error of the values from Sw
	ton_MediaValuesIncoherency.IN := 2 * gMachine.parSw.Media.rOffsetRegisterL1 + gMachine.parSw.Media.rWidth < 1395;
	ton_MediaValuesIncoherency.PT := T#200ms;
	ton_MediaValuesIncoherency();
	
	// If the values are consistent in time, raise and log the message
	IF EDGEPOS(ton_MediaValuesIncoherency.Q) THEN
		LogWarningSize;
		
		// Avoid non curing media by setting the maximum width
		//gMachine.parSw.Media.rOffsetRegisterL1 := 1;
		//gMachine.parSw.Media.rWidth := 1400;
	END_IF
	
END_ACTION
