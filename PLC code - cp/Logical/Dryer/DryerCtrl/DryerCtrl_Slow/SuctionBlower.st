
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

	
	CASE gDryer.Pt.SW.Suction.iBlowerMode OF
		
		BWMODE_OFF:
			gDryer.Out.xSuctionTurbine:= FALSE;
		
		BWMODE_ON:
			gDryer.Out.xSuctionTurbine:= TRUE;

		BWMODE_AUTO:
			tofDelaySuction.IN:=gDryer.St.Mode.xAuto AND gBelt.states.xRuningBelt;
			tofDelaySuction.PT:=gDryer.Pt.SW.Suction.tiBlowerDelayOff;
			tofDelaySuction();

			gDryer.Out.xSuctionTurbine:= tofDelaySuction.Q;

	END_CASE;
	
	
	
END_ACTION
