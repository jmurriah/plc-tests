
	(* From efi Cretaprint Almazora Castellon
	
	
(*	
View of the machine from the Operator side

>>>>>> LeftHandMachine 					RightHandMachine <<<<<<<<		
(BK_A #1 >> BK_B #2)		LOGICAL			(BK_A #2 << BK_B #1) 
					              

Vertical:	#2 									Vertical:	#3
IclaNode: 	#5									IclaNode: 	#7	
IclaIndex:	#1									IclaIndex:	#2
	
	          ################-################
	          ################-################
	          ################-################
	          ################-################
	##########################-###########################
	##########################-###########################
	    ######################-#######################
	    ######################-#######################
	    ######################-#######################
	    ######################-#######################
	
	BLOCK A [1-physical]				BLOCK B [2-physical]
	
*)	




//Determine machine direction
	// RIGHT: gMachine.parSw.xMachineDirection is 0 or FALSE
	// LEFT:  gMachine.parSw.xMachineDirection is 1 or TRUE
	gMachine.Pt.xLeftHandMachine := gMachine.parSw.xMachineDirection;
	gMachine.Pt.xRightHandMachine:= NOT gMachine.Pt.xLeftHandMachine;


	
	 // P4 Config : iFirstBlock :=1  and iLastBlock :=2 
	
	
	
	
	
	
	
	*)