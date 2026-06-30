
(* Time in ms to run a distance in mm with speed in m/min. TIME *)
FUNCTION TimeFromMmAndMmin
	
	IF rSpeed = 0 THEN
		TimeFromMmAndMmin := T#24d; //Value close to the maximum
	END_IF
	
	TimeFromMmAndMmin := REAL_TO_TIME(rDistance * 60 / rSpeed);
      
END_FUNCTION
