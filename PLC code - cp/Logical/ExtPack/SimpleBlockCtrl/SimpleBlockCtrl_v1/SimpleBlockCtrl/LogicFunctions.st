
(* This function returns if the bar determined by the index is in the current block *)
FUNCTION AllDevicedStopped
	AllDevicedStopped := NOT AxisBK.Status.PLCopenState.ContinuousMotion AND
						NOT AxisBK.Status.PLCopenState.Stopping AND
						NOT AxisBK.Status.PLCopenState.DiscreteMotion;
	
END_FUNCTION
