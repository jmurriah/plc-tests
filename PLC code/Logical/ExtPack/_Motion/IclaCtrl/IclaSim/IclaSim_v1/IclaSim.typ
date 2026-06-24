
TYPE
	stIclaParameters : 	STRUCT 
		SpeedFactor : REAL := 1.0; (*The modification of the speed configured to speed up simulations*)
	END_STRUCT;
	stIclaSim : 	STRUCT 
		Parameters : stIclaParameters;
	END_STRUCT;
END_TYPE
