
PROGRAM _INIT

END_PROGRAM

PROGRAM _CYCLIC

	// Moved from init to cyclic. This cannot be in init because sim is executed before ThicknessCtrl and the assignement is done in ThicknessCtrl INIT
	xMediaTracking ACCESS gThicknessCtrl.Internal.pMediaTracking;
	iDistanceWorkEmptyBelt ACCESS gThicknessCtrl.Internal.pDistanceWorkEmptyBelt;
	
	IF NOT gSimThickCtrl.Orders.NotActivateMediaInPos THEN
		gThicknessCtrl.Inputs.CheckMedia[1].xCheckFail := xMediaTracking[gThicknessCtrl.parameters.CheckMedia[1].CheckPosition] > 0;
		gThicknessCtrl.Inputs.CheckMedia[2].xCheckFail := xMediaTracking[gThicknessCtrl.parameters.CheckMedia[2].CheckPosition] > 0;
	ELSE
		gThicknessCtrl.Inputs.CheckMedia[1].xCheckFail := FALSE;
		gThicknessCtrl.Inputs.CheckMedia[2].xCheckFail := FALSE;
	END_IF
	
	// Related to NOZOMITWO-2388 
	IF gSimThickCtrl.Commands.xEmptyMediaTracking THEN 
		FOR iIndexMediaTrack := 0 TO iMAXTRACKINGARRAY DO
			xMediaTracking[iIndexMediaTrack] := 0;
			iDistanceWorkEmptyBelt := 0;
		END_FOR
		gSimThickCtrl.Commands.xEmptyMediaTracking := FALSE;
	END_IF
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

