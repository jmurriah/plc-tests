
TYPE
	SimThickCtrlOrders_typ : 	STRUCT 
		NotActivateMediaInPos : BOOL; (*Do not activate the right behavior of activating the signal when media is detected*)
	END_STRUCT;
	SimThickCtrlCommands_typ : 	STRUCT 
		xEmptyMediaTracking : BOOL;
	END_STRUCT;
	SimThickCtrlParams_typ : 	STRUCT 
		New_Member : BOOL;
	END_STRUCT;
	SimThickCtrl_typ : 	STRUCT 
		Commands : SimThickCtrlCommands_typ;
		Orders : SimThickCtrlOrders_typ;
		Parameters : SimThickCtrlParams_typ;
	END_STRUCT;
END_TYPE
