
ACTION SuctionBlower: 

	
	////////////////////////////
	// BLOWERS
	////////////////////////////
	// Reference Jira: CRETAPRINT LEGOCRETALEGO-845
	// Turbine: Suction mode in automatic it isn´t correct.	
	//
	// gui_i_iModoTurbina
	// Suction mode functionality. It can be configured by GUI with Ventrui or Turbine parameters
	// 0 estado off, 1 estado siempre On, modo 2, con base de tiempo en la desconexion.
	
	CASE gMachine.parSw.Suction.iBlowerMode OF
		
		BWMODE_OFF:
			xSuctionTurbine := FALSE;
		
		BWMODE_ON:
			xSuctionTurbine := TRUE;

		BWMODE_AUTO:
			IF NOT gMachine.Pt.xControlledByLine THEN
				tofDelaySuction.IN:=gMachine.St.Mode.xAuto AND gBelt.states.xRuningBelt;
				tofDelaySuction.PT:=gMachine.parSw.Suction.tiBlowerDelayOff;
				tofDelaySuction();
	
				xSuctionTurbine := tofDelaySuction.Q;
			
			ELSE
				//[RGP] To be discussed with controls team. I think this is a better solution for mist collector
				tofDelaySuction.IN:= (NOT gBelt.states.xRuningBelt) OR (NOT gThicknessCtrl.status.MediaPosition.xMediaInside) ;
				tofDelaySuction.PT:=gMachine.parSw.Suction.tiBlowerDelayOff;
				tofDelaySuction();
				
				rsSuction.RESET1 := tofDelaySuction.Q;
				rsSuction.SET := gThicknessCtrl.status.MediaPosition.xMediaInside;
				rsSuction();
				
				xSuctionTurbine := rsSuction.Q1;
			END_IF
	END_CASE	
	
	gMachine.Out.xSuctionTurbine := xSuctionTurbine AND NOT gMachine.In.xHoppersSoftStarterFault;
	
END_ACTION

