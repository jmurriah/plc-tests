
(* This function returns if the bar determined by the index is in the current block *)
FUNCTION AllDevicedStopped
	AllDevicedStopped := NOT AxisBK.Status.PLCopenState.ContinuousMotion AND
						NOT AxisBK.Status.PLCopenState.Stopping AND
						NOT AxisBK.Status.PLCopenState.DiscreteMotion AND
						IclaBK.Status.iActualVelocity < 5 AND 
						NOT Block.Status.Icla.xHoming AND
						NOT Block.Out.xTrayIn AND
						NOT Block.Out.xTrayOut;
	
END_FUNCTION

(* This function returns TRUE if the cleaning icla motor and the block motor are homed *)
FUNCTION AllDevicedHomed
	AllDevicedHomed := Block.Status.Motor.xBarsHomed AND Block.Status.Icla.xHomed;
END_FUNCTION