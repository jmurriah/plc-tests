
FUNCTION AddMediaTrackingEvents
	
	// Moving the array to the right
	ShiftArrayForward(pEventsTrackingArray, SIZEOF(fakeElement) * THICK_MAX_TRACKING_EVENTS, SIZEOF(fakeElement), 1, THICK_MAX_TRACKING_EVENTS-1);
	
	EventsArray ACCESS(pEventsTrackingArray);
	EventsArray[0].diBeltPosition := diBeltPosition;
	EventsArray[0].diDistanceToPrevious := diBeltPosition - EventsArray[1].diBeltPosition;
	EventsArray[0].Event := EventType;
	
	AddMediaTrackingEvents := TRUE;
	
END_FUNCTION

