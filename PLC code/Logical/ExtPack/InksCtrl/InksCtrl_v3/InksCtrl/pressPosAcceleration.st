
ACTION pressPosAcceleration: 

	blink1s(T_Blink:= T#250ms);
	
	IF NOT EDGEPOS(blink1s.Out) THEN
		RETURN;
	END_IF
	
	IF rSetPointFillingPump < rOrderBPositiveStart THEN
		(*UP*)
		IF rOrderBPositiveStart - rSetPointFillingPump <= parBar.rAccelerationFillingPump THEN
			rOrderBPositiveStart := rSetPointFillingPump;
		ELSE
			rOrderBPositiveStart := rOrderBPositiveStart - parBar.rAccelerationFillingPump;
		END_IF;
	ELSIF rSetPointFillingPump > rOrderBPositiveStart THEN
		(*DOWN*)
		IF rSetPointFillingPump - rOrderBPositiveStart <= parBar.rAccelerationFillingPump THEN
			rOrderBPositiveStart := rSetPointFillingPump;
		ELSE
			rOrderBPositiveStart := rOrderBPositiveStart + parBar.rAccelerationFillingPump;
		END_IF;
	END_IF;
	
	IF mode1 THEN //INKS_STOPPED
		rOrderBPositiveStart:=0.0;
	END_IF	
	
END_ACTION
