
ACTION ConsentsLine:	
		(*	
		View OF the machine from the Operator side
		
		>>>>>> LeftHandMachine 					RightHandMachine <<<<<<<<		
		(BK_A #1 >> BK_B #2)		LOGICAL			(BK_A #2 << BK_B #1) 
							              
		
			
			          ################-################
		L2	          ################-################     L2
		------        ################-################   -------
		L1	          ################-################     L1
			##########################-###########################
			##########################-###########################
			    ######################-#######################
			    ######################-#######################
			    ######################-#######################
			    ######################-#######################
			
			BLOCK A [1-physical]				BLOCK B [2-physical]
	
		
		*)	

	///////////////////////////////////////////////////
	// Consents depending if double or simple line
	//////////////////////////////////////////////////
	xDoubleLineConsent:= 	( gMachine.parSw.Dtp.iModeLine1=GC_DTP_STOP OR gMachine.In.xConsentL1Ok ) AND
							( gMachine.parSw.Dtp.iModeLine2=GC_DTP_STOP OR gMachine.In.xConsentL2Ok ) AND
							( gMachine.parSw.Dtp.iModeLine1<>GC_DTP_STOP OR gMachine.parSw.Dtp.iModeLine2<>GC_DTP_STOP);

	tonDelayConsentInput.IN:= 	(NOT gMachine.parSw.Dtp.xDoubleLine AND gMachine.In.xConsentL1Ok ) OR
								(gMachine.parSw.Dtp.xDoubleLine AND xDoubleLineConsent );
	tonDelayConsentInput.PT:= T#500ms;
	tonDelayConsentInput();

	gMachine.St.Consent.xConsent:= tonDelayConsentInput.Q;
	
	
	//Raise Bars without consent
	xAvoidRaiseBarsNotConsent := gMachine.Al.Alarm.xAlarmNotInPrintPosition OR gMachine.Al.Warning.xNotLoadedImage;
	tonUpBarsNoConsent.IN :=	gMachine.St.AutoMode.xProduction AND NOT xAvoidRaiseBarsNotConsent AND NOT gMachine.St.Consent.xConsent;
	tonUpBarsNoConsent.PT:= T#5m;
	tonUpBarsNoConsent();
	gMachine.St.Consent.xUpWithNoConsentCountingTime := tonUpBarsNoConsent.IN;
	
	//Split the assignation to allow an external assignation from simulation to avoid waiting 5min 
	IF EDGEPOS(tonUpBarsNoConsent.Q) THEN
		gMachine.St.Consent.xUpWithNoConsent := TRUE;
	END_IF
	IF NOT gMachine.St.AutoMode.xProduction OR EDGEPOS(gMachine.St.Position.xInPrint) THEN
		gMachine.St.Consent.xUpWithNoConsent := FALSE;
	END_IF
	
	IF gMachine.St.Consent.xUpWithNoConsent OR gMachine.St.xProtectBendedWithPause THEN
		gMachine.St.Consent.xOrderToEmpyBelt := TRUE;
	ELSIF NOT gThicknessCtrl.status.MediaPosition.xMediaInside THEN
		gMachine.St.Consent.xOrderToEmpyBelt := FALSE;
	END_IF
	
	///////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////

	// Pending to test
	//Consent Outputs for L1
	//Single line L1, When belt is runing is because we had consent
	xOutputConsentInSingleLineL1:=	NOT gMachine.parSw.Dtp.xDoubleLine AND
									gMachine.In.xConsentL1Ok AND 
									gMachine.St.AutoMode.xProdORByPass AND
									NOT gThicknessCtrl.status.MediaPosition.xMountedMediaInside AND 
									NOT gMachine.St.Blocks.xBlockAlarmToEmpyBelt AND
									NOT gMachine.St.Consent.xOrderToEmpyBelt;
	
	xOutputConsentInByPassL1 := gMachine.St.AutoMode.xBypass AND 
								gMachine.In.xConsentL1Ok AND 
								(NOT gMachine.parSw.Dtp.xDoubleLine OR (gMachine.parSw.Dtp.xDoubleLine AND gMachine.parSw.Dtp.iModeLine1<>GC_DTP_STOP)) ;
	xOutputConsentInByPassL2 := gMachine.St.AutoMode.xBypass AND
								gMachine.In.xConsentL2Ok AND
								gMachine.parSw.Dtp.xDoubleLine AND gMachine.parSw.Dtp.iModeLine2<>GC_DTP_STOP ;
	
	xOutputConsentInDTPL1:=	gMachine.St.AutoMode.xProdORByPass AND 
							NOT gMachine.St.Blocks.xBlockAlarmToEmpyBelt AND
							(gMachine.parSw.Dtp.xDoubleLine AND gMachine.parSw.Dtp.iModeLine1<>GC_DTP_STOP);
	xOutputConsentInDTPL2:=	gMachine.St.AutoMode.xProdORByPass AND 
							NOT gMachine.St.Blocks.xBlockAlarmToEmpyBelt AND
							(gMachine.parSw.Dtp.xDoubleLine AND gMachine.parSw.Dtp.iModeLine2<>GC_DTP_STOP);
	
	//Consider the delay of the output signal configured in SW
	tonDelayConsentOutL1.IN:= gBelt.states.xRuningBelt AND (xOutputConsentInSingleLineL1 OR xOutputConsentInDTPL1 OR xOutputConsentInByPassL1);// It checked in both single or dtpL1
	tonDelayConsentOutL1.PT:= gMachine.parSw.tiDelayConsent;
	tonDelayConsentOutL1();
	tonDelayConsentOutL2.IN:= gBelt.states.xRuningBelt AND (xOutputConsentInDTPL2 OR xOutputConsentInByPassL2);
	tonDelayConsentOutL2.PT:= gMachine.parSw.tiDelayConsent;
	tonDelayConsentOutL2();
	
	gMachine.Out.xConsentL1:= tonDelayConsentOutL1.Q;
	gMachine.Out.xConsentL2:= tonDelayConsentOutL2.Q;
	
	
	////////////////////////////
	// COMPENSERS
	////////////////////////////
	gMachine.Out.xCompenserLine1:= gMachine.commands.xCompenserLine1;
	gMachine.Out.xCompenserLine2:= gMachine.commands.xCompenserLine2;
	
END_ACTION
