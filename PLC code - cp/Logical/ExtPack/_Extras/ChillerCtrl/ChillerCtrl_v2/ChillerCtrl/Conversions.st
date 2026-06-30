
ACTION Conversions:
	
	CASE dataChill.Parameters.SystemType OF
		
		CHILLERSYS_DIRECT:

			
		CHILLERSYS_WATERMANIFOLD:
			dataChill.St.WaterManifold.rEnviromentTemp := INT_TO_REAL(dataChill.In.WaterManifold.iEnvironmentTempRaw)/10.0;
			dataChill.St.WaterManifold.rManifoldTemp := INT_TO_REAL(dataChill.In.WaterManifold.iWaterManifoldTempRaw)/10.0;
		
	END_CASE
	
END_ACTION
