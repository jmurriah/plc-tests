
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

	gDryer.In.xConsentOk := gDryer.St.Mode.xAuto;
	
	tonDelayConsentInput.IN:= gDryer.In.xConsentOk;
	tonDelayConsentInput.PT:= T#100ms;
	tonDelayConsentInput();

	gDryer.St.xConsent:= tonDelayConsentInput.Q;

	
	///////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////

	// Pending to test
	//Consent Outputs for L1
	//Single line L1, When belt is runing is because we had consent
	xOutputConsentInSingleLineL1:=	gDryer.In.xConsentOk AND gDryer.St.AutoMode.xProdORByPass AND NOT gThicknessCtrl.status.MediaPosition.xMountedMediaInside;
	
	xOutputConsentInByPassL1 := gDryer.St.AutoMode.xBypass AND gDryer.In.xConsentOk;
	
	//Consider the delay of the output signal configured in SW
	tonDelayConsentOutL1.IN:= gBelt.states.xRuningBelt AND (xOutputConsentInSingleLineL1 OR xOutputConsentInByPassL1);// It checked in both single or dtpL1
	tonDelayConsentOutL1.PT:= gDryer.Pt.SW.tiDelayConsent;
	tonDelayConsentOutL1();
	
	gDryer.Out.xConsentL1:= tonDelayConsentOutL1.Q;
	
		
END_ACTION
