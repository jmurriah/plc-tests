
(* TODO: Add your comment here *)
FUNCTION inkStateValue
	
	CASE inkState OF
		INKS_STOPPED:
			inkStateValue:= 1;
		
		INKS_STARTING:
			inkStateValue:= 3;
		
		INKS_STARTED:
			inkStateValue:= 4;
		
		INKS_MANUAL_REVERSEFLOW:
			inkStateValue:= 5;
		
		INKS_AUTO_REVERSEFLOW:
			inkStateValue:= 6;
		
		INKS_STOPPING:
			inkStateValue:= 9;
		
		INKS_RUNNING_MANUAL:
			inkStateValue:= 10;
			
		ELSE
			inkStateValue:= 255;
	
	END_CASE;

END_FUNCTION

(*
INKS_STOPPED					1	 	 	 	252
INKS_DRAINAGE				2	 	 	 	253
INKS_STARTING				3	 	 	 	254
INKS_STARTED					4	 	 	 	255
INKS_MANUAL_REVERSEFLOW		5	 	 	 	256
INKS_AUTO_REVERSEFLOW	6	 	 	 	257
INKS_STOPPING				9	 	 	 	260
INKS_RUNNING_MANUAL		10	 	 	 	261
INKS_UNDEFINED				255	 	 	 	262
*)