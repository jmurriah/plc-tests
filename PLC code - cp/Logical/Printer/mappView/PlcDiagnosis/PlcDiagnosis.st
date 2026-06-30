
PROGRAM _INIT
	

END_PROGRAM

PROGRAM _CYCLIC	
	
	//OPC-UA SERVER
	GetInstalledCards;
	shareMachineConfiguration;	
	shareCardsModuleOk;
	shareDI_1;
	shareDO_1;
	shareAI_1;
	shareAO_1;
	shareAT_1;
	shareDI_2;
	shareDO_2;
	shareAI_2;
	shareAO_2;
	shareAT_2;
	sharePhotoCells;
	shareCuringBar;
	shareBlock;
	shareTransVacuum;
	
	//Belt 
	
	Belt_Tracking;
	
	//Cards
	
	
	//Vacuum
	
	Vacuum_getIndex;
	
	//Block
	
	Block_getIndex;
	Block_getSlots;
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

