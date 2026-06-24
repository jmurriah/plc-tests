ACTION Conversions:
	
	//There are two distance sensor per motor
	
	//y = mx + b
	//y = distance measured (mm)
	//x = value read by sensor
	//b = value of distance at minimum analogic value read (4mA) = 100mm
	//sensor maximum measure distance is 600
	
	//y(x)=0.0183x + 58 //Practical. (RawUnits)
	
	//Front sensor
	data.Motor[iIndexIclaMotor].rMeasuredPositionFrontSide := (data.Motor[iIndexIclaMotor].Inputs.iMeasuredPositionFrontSide*rSlopeAnalogSensor + rInterceptAnalogSensor);
	
	//Back sensor	
	data.Motor[iIndexIclaMotor].rMeasuredPositionBackSide := (data.Motor[iIndexIclaMotor].Inputs.iMeasuredPositionBackSide*rSlopeAnalogSensor + rInterceptAnalogSensor);
	
	//Distance between metal bands/straps
	rMeasuredDistanceMetalStraps[iIndexIclaMotor] := 	data.Motor[iIndexIclaMotor].rMeasuredPositionFrontSide + 
														data.Motor[iIndexIclaMotor].rMeasuredPositionBackSide +
														data.Motor[iIndexIclaMotor].rDistanceBetweenSensors;
	
	IF ABS(data.Motor[iIndexIclaMotor].rMeasuredDistanceMetalStraps - rMeasuredDistanceMetalStraps[iIndexIclaMotor])> rAnalogSensorTolerance THEN
		data.Motor[iIndexIclaMotor].rMeasuredDistanceMetalStraps := rMeasuredDistanceMetalStraps[iIndexIclaMotor];
	END_IF
	
END_ACTION


