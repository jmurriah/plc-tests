PROGRAM _INIT
	pressureSim.AnalogType := ANALOGSIM_EXPONENTIAL_POS;
	pressureSim.rInitialValue := 16384;
	//pressureSim.rNewPresentValue := 16384;
	pressureSim.rMinValue := 10900;
	pressureSim.rMaxValue := 16384;
	
	rAParam := 5;	//Fixed change
	rBParam := 0.010;	//Change with DC

END_PROGRAM

PROGRAM _CYCLIC

	transVacc ACCESS ADR(gTransVacuum[iTransVacummSimIndex]);

	pressureSim.rA := rAParam * transVacc.Parameters.rMaxSystemVacuum;
	pressureSim.rB := rBParam * transVacc.Parameters.rMaxSystemVacuum;
	
	pressureSim.rActionControl := transVacc.Status.Blower.rDutyCycle;
	//pressureSim.xUseNewValue := EDGEPOS(transVacc.Status.State<>TRANSVAC_OFF);
	pressureSim();
	transVacc.Inputs.iPressureRaw:=REAL_TO_INT(pressureSim.rPresentValue);
	
	tofNoVacc.IN := transVacc.Status.rVacPressure > 0.0;
	tofNoVacc.PT := t#100ms;
	tofNoVacc();
	transVacc.Inputs.xJointSystemPressure	:= tofNoVacc.Q;
	transVacc.Inputs.xVaccAirFlow	:= tofNoVacc.Q;
	
	//Increase the index for simulating the next item
	iTransVacummSimIndex := iTransVacummSimIndex +1;
		
END_PROGRAM
