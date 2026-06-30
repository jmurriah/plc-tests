
TYPE
	stThicknessCtrl_MediaPosStatus : 	STRUCT 
		Media : stThicknessCtrl_MediaConfig;
		HeadPosition : UDINT; (*Position of the head of the media in cm*)
		TailPosition : UDINT; (*Position of the tail of the media in cm*)
		iIndexMediaEnergy : USINT; (*Index of the MediaEnergy information in the fixed cells*)
		pMediaEnery : UDINT; (*Pointer to the MediaEnergy information. It is in fixed cells in an array*)
	END_STRUCT;
	stThickCtrl_EnergyMedia : 	STRUCT  (*THIS STRUCTURE IS USED IN OPCUA METHODS. MODIFY IT NEEDS TO UPDATE SOFTWARE CODE!!!!!!    >>>Data coming directly from Energy Communications*)
		MediaData : stThicknessCtrl_MediaConfig;
		Energy : stThickCtrl_Energy;
	END_STRUCT;
	stThickCtrl_Energy : 	STRUCT  (*/// Data coming directly from Energy Communications*)
		iPower : ARRAY[0..THICKENERGY_MAX_PROCESS_ITEMS,0..THICKENERGY_MAX_CROSS_ITEMS]OF USINT; (*The Energy needs the media to be cured. Led or Dry*)
	END_STRUCT;
	stThicknessCtrl_MediaConfig : 	STRUCT  (*THIS STRUCTURE IS USED IN OPCUA METHODS. MODIFY IT NEEDS TO UPDATE SOFTWARE CODE!!!!!!*)
		id : DINT; (*Identificator of the board*)
		iLine : USINT; (*Line where the media will arrive to the printer [1, 2, ..]*)
		xHasClear : BOOL; (*The media document has opv ink*)
		xHasWhite : BOOL; (*The media document has white color*)
		rThickness : REAL; (*Media thickness to print from gui in mm*)
		rMargin : REAL; (*Printing Margin from the real media thickness in mm*)
		rWidth : REAL; (*Media width in mm. Cross direction*)
		rLength : REAL; (*Media length in mm. Process direction*)
		rCrossOffset : REAL; (*Document offset position in mm. From the center of the belt*)
		rDocWidth : REAL; (*Document width in mm. Cross direction*)
		rDocLength : REAL; (*Document length in mm. Process direction*)
		rDocCrossOffset : REAL; (*Document offset position in mm. From the center of the belt*)
		rDocProcessOffset : REAL; (*Document offset position in mm from head of substrate. From the head of the substrate. Positive through inside the substrate*)
	END_STRUCT;
	stThickCtrl_TrackingEventType : 
		(
		HEAD_UNDEFINED,
		HEAD_DETECTED,
		TAIL_DETECTED,
		START_REJECTING_ALL,
		END_REJECTING_ALL,
		START_HOLDREJEC,
		END_HOLDREJECT
		);
	stThicknessCtrl_TrackingEvent : 	STRUCT  (*For now just a copy of ALL parameters*)
		diBeltPosition : UDINT := 0; (*Value of the belt position when detecting the event*)
		diDistanceToPrevious : UDINT := 0; (*Value of the belt position difference with the previous one. Wrong values with events not in cero (as HoldReject)*)
		Event : stThickCtrl_TrackingEventType := HEAD_UNDEFINED;
	END_STRUCT;
	ThicknessMountedDetectionType : 
		(
		THICKMOUNT_UNDEFINED,
		THICKMOUNT_THICKNESS_RELATIVE,
		THICKMOUNT_ABSOLUTE
		);
END_TYPE
