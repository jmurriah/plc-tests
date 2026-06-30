// It sets speed motor when enable is true otherewise SpeedMotor is Zero
FUNCTION_BLOCK MotorSpeedCalculation
	
	xChange := FALSE;
	
	// Enable function 
	IF xEnable THEN	
		// Conversion from mm/MIN a UM/seg
		m_rpm:= (((UINT_TO_REAL(uiRolllerPerimeter)/10.0)/ (UINT_TO_REAL(uiReductor)))); //	(mm/rev)
		rSpeedMotor := (((INT_TO_REAL((iSpSpeed))/60)/m_rpm) * 100 * rUnitsAtTheLoad ); //  (cm/seg : mm/rev)*100== (rev/seg)*1000000 == UM/seg
		IF xPrinterDirection = TRUE THEN
			rSpeedMotor:=-rSpeedMotor;
		END_IF;
	ELSE
		rSpeedMotor := 0;
	END_IF;
	// Trigger if change SP 
	IF xChange = FALSE THEN
		IF Aux <> rSpeedMotor THEN
			xChange := TRUE;
			Aux := rSpeedMotor;
		END_IF;
	ELSE
	END_IF;
	
END_FUNCTION_BLOCK
