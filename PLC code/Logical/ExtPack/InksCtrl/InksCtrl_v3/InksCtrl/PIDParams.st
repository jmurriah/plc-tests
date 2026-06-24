
(* TODO: Add your comment here *)
FUNCTION stPIDParamId
	stPIDParamId:=parPid.rKd + 11 * parPid.rKp + 13 * parPid.rTd + 17 * parPid.rTi;
END_FUNCTION


FUNCTION stPIDParamToMTPIDParameters
	
//	pidParMeniscus.Gain 			:= parBar.paramsPidMeniscus.rKp;
//	pidParMeniscus.IntegrationTime 	:= parBar.paramsPidMeniscus.rTi;
//	pidParMeniscus.DerivativeTime 	:= parBar.paramsPidMeniscus.rKd;
//	pidParMeniscus.FilterTime 		:= parBar.paramsPidMeniscus.rTd;
	
	MTPIDparam.Gain 			:= pidParam.rKp;
	MTPIDparam.IntegrationTime 	:= pidParam.rTi;
	MTPIDparam.DerivativeTime 	:= pidParam.rKd;
	MTPIDparam.FilterTime 		:= pidParam.rTd;
	
	stPIDParamToMTPIDParameters := TRUE;

END_FUNCTION