
PROGRAM _INIT
	
	//Cards
	
	Cards_infoInit;
	
	
END_PROGRAM

PROGRAM _CYCLIC
	
	initComms;
	getMethodHandles;
	getMachineConfiguration;
	
	CASE PageSelected OF
		
		BlockPage:
			
			getBlock;
		
		BeltPage:
			
		
		VacuumPage:
			
			getTransV;
		
		CuringPage:
			
			Curing_getIndex;
			Curing_SVGBarInit;
			Curing_SVGBarGenerator;
			
		DetectionPage:
			
			getPhotoCells;
			Detect_SVG;
			
		AncillariesPage:
			
			
		CardsPage:
			
			getModuleOk;
			Card_RacksSVG;
			Card_CardsSVG;
		
	END_CASE

END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

