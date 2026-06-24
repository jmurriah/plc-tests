
(* TODO: Add your comment here *)
FUNCTION TIME_TO_MINUTES
	
	TIME_TO_MINUTES := REAL_TO_INT(TIME_TO_REAL(tiTimeValue)/1000/60); //Value in time are ms, and here we convert it to minutes
	
END_FUNCTION


(* TODO: Add your comment here *)
FUNCTION TIME_TO_SECONDS
	
	TIME_TO_SECONDS := TIME_TO_UDINT(tiTimeValue)/1000; //Value in time are ms, and here we convert it to seconds
	
END_FUNCTION


(* TODO: Add your comment here *)
FUNCTION TIME_TO_SECONDS_COMS
	
	TIME_TO_SECONDS_COMS := UDINT_TO_UINT(TIME_TO_UDINT(tiTimeValue)/1000); //Value in time are ms, and here we convert it to seconds
	
END_FUNCTION


(* TODO: Add your comment here *)
FUNCTION TIME_TO_MILLISECONDS
	
	TIME_TO_MILLISECONDS := TIME_TO_UDINT(tiTimeValue); //Value in time are ms, and here we convert it directly to milliseconds in UDINT
	
END_FUNCTION


(* TODO: Add your comment here *)
FUNCTION TIME_TO_MILLISECONDS_COMS
	
	TIME_TO_MILLISECONDS_COMS := TIME_TO_UINT(tiTimeValue); //Value in time are ms, and here we convert it directly to milliseconds in UINT
	
END_FUNCTION
