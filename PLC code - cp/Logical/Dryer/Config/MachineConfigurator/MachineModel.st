
ACTION MachineModel: 

	//Assignation of machine model just when unnasigned
	IF gDryer.In.iMachineModelCode=0 THEN
		InputsMachineModel;
	END_IF
	
	// MachineModelAssignation 
	// From the inputs of the type of machine readed by the inputs to the Parameter of the particular Type of Machine
	CASE gDryer.Pt.ConfigNameID OF
		
		GC_CONFIG_DRYER_NOZ2_ID:
			CASE gDryer.In.iMachineModelCode OF
				03: //Dryer Nozomi 2	|| 01-> 0000 0011
					gDryer.Pt.MachineModel:=DryerType_NOZ2_NIR_ARCLAMP;
				02: //Dryer Nozomi 2	|| 01-> 0000 0010
					gDryer.Pt.MachineModel:=DryerType_NOZ2_NIR;
				ELSE
					gDryer.Pt.MachineModel:=DryerNoType;

			END_CASE;

		GC_CONFIG_SIMDRYER_NOZ2_ID:
			CASE gDryer.In.iMachineModelCode OF
				03: // Nozomi2 Dryer		|| 01-> 0000 0011
					gDryer.Pt.MachineModel:= DryerType_NOZ2_NIR_ARCLAMP;
				02: // Nozomi2 Dryer		|| 01-> 0000 0010
					gDryer.Pt.MachineModel:= DryerType_NOZ2_NIR;

				ELSE
					gDryer.Pt.MachineModel:=DryerNoType;

			END_CASE;
			xChangedSimMachine := simMachine_copy <> gSimMachine.Parameters.MachineType;
			simMachine_copy := gSimMachine.Parameters.MachineType;
			
		ELSE
			gDryer.Pt.MachineModel:=DryerNoType;
			
	END_CASE
	
	//Assignation of the axis
	AxisAssignation;
	
	// Code To Kernel	(Tranfer the other codes)  
	CASE gDryer.Pt.MachineModel OF
		DryerType_NOZ2_NIR_ARCLAMP:
			gDryer.St.iMachineModelCodeSW:=5001;

		DryerType_NOZ2_NIR:
			gDryer.St.iMachineModelCodeSW:=5002;

		ELSE
			gDryer.St.iMachineModelCodeSW:= 0;

	END_CASE;


END_ACTION

ACTION InputsMachineModel: 

	CASE gDryer.Pt.ConfigNameID OF
		
		GC_CONFIG_DRYER_NOZ2_ID:
			gDryer.In.iMachineModelCode.3:= X20DIF371_201.DInput[16];
			gDryer.In.iMachineModelCode.2:= X20DIF371_201.DInput[15];
			gDryer.In.iMachineModelCode.1:= X20DIF371_201.DInput[14];
			gDryer.In.iMachineModelCode.0:= X20DIF371_201.DInput[13];
		
	END_CASE;	
	
END_ACTION

ACTION AxisAssignation:

	IF gDryer.Pt.ConfigNameID = GC_CONFIG_SIMDRYER_NOZ2_ID THEN
		Axis_Simulation;
		RETURN;
	END_IF
	
	
	//Name of the Axis as defined in Hardware
	CASE gDryer.Pt.MachineModel OF
		
		DryerType_NOZ2_NIR,
		DryerType_NOZ2_NIR_ARCLAMP:
			Axis_DryerNoz2;
		
		ELSE
			//No machine assigned
			RETURN;

	END_CASE

END_ACTION

ACTION Axis_Simulation:


	(* Insert code here *)
    //Name of the Axis as defined in Hardware
	gAxis[1].Parameter.Init.AxisObjectName			:=	'gAxis01';	//Instance_Belt
	gAxis[2].Parameter.Init.AxisObjectName			:=	'gAxis02';	//Instance_BK1
	
	gAxisInverter[1].Parameters.Hardware.PowerLinkInterface := 'IF3';
	gAxisInverter[1].Parameters.Hardware.Node := 81;
	gAxisInverter[1].Parameters.AccelerationTime := 1;
	gAxisInverter[1].Parameters.DecelerationTime := 1;
	gAxisInverter[1].Parameters.CommsType := COMMS_POWERLINK;
	gAxisInverter[2].Parameters.Hardware.PowerLinkInterface := 'IF3';
	gAxisInverter[2].Parameters.Hardware.Node := 82;
	gAxisInverter[2].Parameters.AccelerationTime := 1;
	gAxisInverter[2].Parameters.DecelerationTime := 1;
	gAxisInverter[2].Parameters.CommsType := COMMS_POWERLINK;
	
	LoadDefaultServoConfig(ADR(gAxis[1]));
	LoadDefaultServoConfig(ADR(gAxis[2]));
		
END_ACTION

ACTION Axis_DryerNoz2:


	(* Insert code here *)
    //Name of the Axis as defined in Hardware
	gAxis[1].Parameter.Init.AxisObjectName			:=	'gAxis01';	//Instance_Belt
	gAxis[2].Parameter.Init.AxisObjectName			:=	'gAxis02';	//Instance_BK1
	
	// To choose communication protocol for VSDs while are UNDEFINED
	IF gAxisInverter[1].Parameters.CommsType = COMMS_UNDEFINED AND gAxisInverter[2].Parameters.CommsType = COMMS_UNDEFINED THEN
		IF gInverterSignalsPowerLink[1].In.ModuleOk AND gInverterSignalsPowerLink[2].In.ModuleOk THEN
			gAxisInverter[1].Parameters.CommsType := COMMS_POWERLINK;
			gAxisInverter[2].Parameters.CommsType := COMMS_POWERLINK;
		ELSIF gInverterSignalsCanOpen[1].In.ModuleOk AND gInverterSignalsCanOpen[2].In.ModuleOk THEN
			gAxisInverter[1].Parameters.CommsType := COMMS_CANOPEN;
			gAxisInverter[2].Parameters.CommsType := COMMS_CANOPEN;
		END_IF
	END_IF
	IF gAxisInverter[1].Parameters.CommsType = COMMS_POWERLINK THEN
		gAxisInverter[1].Parameters.Hardware.PowerLinkInterface := 'IF3';
		gAxisInverter[1].Parameters.Hardware.Node := 81;
		gAxisInverter[1].Parameters.AccelerationTime := 1;
		gAxisInverter[2].Parameters.Hardware.PowerLinkInterface := 'IF3';
		gAxisInverter[2].Parameters.Hardware.Node := 82;
		gAxisInverter[2].Parameters.DecelerationTime := 1;
	ELSIF gAxisInverter[1].Parameters.CommsType = COMMS_CANOPEN THEN
		gAxisInverter[1].Parameters.Hardware.Node := 81;
		gAxisInverter[1].Parameters.AccelerationTime := 1;
		gAxisInverter[1].Parameters.Hardware.PowerLinkInterface := 'IF7';
		gAxisInverter[2].Parameters.Hardware.Node := 82;
		gAxisInverter[2].Parameters.Hardware.PowerLinkInterface := 'IF7';
		gAxisInverter[2].Parameters.AccelerationTime := 1;
	END_IF
	
	LoadDefaultServoConfig(ADR(gAxis[1]));
	LoadDefaultServoConfig(ADR(gAxis[2]));
	
END_ACTION