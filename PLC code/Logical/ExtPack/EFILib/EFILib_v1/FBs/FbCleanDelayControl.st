
FUNCTION_BLOCK FbCleanDelayControl
	IF  (Doble) THEN 
		
		// Calculo para linea doble
		IF T_delay_L1 > T_delay_L2 THEN		
			T_delay1:=T#0S;
			T_delay2:=T_delay_L1 - T_delay_L2;
		ELSE
			T_delay1:=T_delay_L2 - T_delay_L1;
			T_delay2:=T#0S;
		END_IF;
		
		IF ( t_Gap<=0) THEN 
	
			// No gap. Only doble line delay
			TON_1 (IN:= Start, PT:= T_delay1 );
			TON_5 (IN:= Start, PT:= T_delay2 );
				
			TON_4 (IN:= TON_1.Q, PT:= T_delay_L1);	
			TON_6 (IN:= TON_5.Q, PT:= T_delay_L2);
			
			IF TON_4.Q AND TON_6.Q THEN
				End:= TRUE;
			ELSE 
				End:= FALSE;	
			END_IF
	
			IF 	(( T_delay_L1>0) OR ( T_delay_L2>0)) AND TON_1.Q THEN
				Out_L1:= TRUE;
			ELSE
				Out_L1:= FALSE;	  
			END_IF
		 
			IF 	(( T_delay_L1>0) OR ( T_delay_L2>0)) AND TON_5.Q THEN
				Out_L2:= TRUE;
			ELSE
				Out_L2:= FALSE;	  
			END_IF
			
		ELSIF (t_Gap>0) THEN
			
			// With doble line gap	
			TON_12 (IN:= (Start), PT:= T_delay1 );
			TON_14 (IN:=( Start), PT:= T_delay2 );
				
			TON_13 (IN:= TON_12.Q, PT:= T_delay_L1);
			TON_15 (IN:= TON_14.Q, PT:= T_delay_L2);
			
			IF TON_13.Q AND TON_15.Q THEN
				End:= TRUE;
			ELSE 
				End:= FALSE;	
			END_IF
			
			TON_9 (IN:=TON_12.Q, PT:=t_Gap);
			TON_16 (IN:=TON_14.Q, PT:= t_Gap);
		
			IF TON_12.Q AND NOT TON_9.Q THEN
				Out_L1:= TRUE;
			ELSE
				Out_L1:= FALSE;		
			END_IF
			
			IF TON_14.Q AND NOT TON_16.Q THEN
				Out_L2:= TRUE;
			ELSE
				Out_L2:= FALSE;		
			END_IF
			
		END_IF
		
	//////////////////////////////////////////////////////////
	// No Gap. Only single line delay
	// Pre_Stop only activated if the value is > 0
	//Jira Reference: CRETALEGO-1011
	//////////////////////////////////////////////////////////

	ELSIF  (NOT Doble) THEN 
		TON_0 (IN:= ( (t_Gap<=0) AND Start), PT:= T_delay_L1);
		End:=TON_0.Q;
	
		IF ( t_Gap<=0) AND Start AND ( T_delay_L1>0) THEN	
			Out_L1:= TRUE;
		ELSE
			Out_L1:= FALSE;	
		END_IF
	
		//	With gap in single line
		IF ( t_Gap>0) THEN
			TON_3 (IN:= ( (t_Gap>0) AND Start), PT:= T_delay_L1);
			End:=TON_3.Q;
		END_IF
		
		TON_2 (IN:= ( t_Gap>0) AND Start, PT:= t_Gap);
	
		IF ( t_Gap>0) AND  Start AND NOT TON_2.Q THEN	
			Out_L1:= TRUE;
		ELSE
			Out_L1:= FALSE;	
		END_IF
		
	END_IF
END_FUNCTION_BLOCK
