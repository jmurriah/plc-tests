
(* TODO: Add your comment here *)
FUNCTION LoadPIDparam
	
	FB_Structure.Gain 				:= USER_Structure.rKp;
	FB_Structure.IntegrationTime	:= USER_Structure.rTi;
	FB_Structure.DerivativeTime 	:= USER_Structure.rKd;
	FB_Structure.FilterTime 		:= USER_Structure.rTd;

	LoadPIDparam := TRUE;
	
END_FUNCTION
