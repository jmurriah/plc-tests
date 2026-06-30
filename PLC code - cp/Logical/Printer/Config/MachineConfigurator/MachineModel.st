
ACTION MachineModel: 

	//Assignation of machine model just when unnasigned
	IF gMachine.In.iMachineModelCode=0 THEN
		InputsMachineModel;
	END_IF
	
	// Code To PLC.
	// From the inputs of the type of machine readed by the inputs to the Parameter of the particular Type of Machine
	MachineModelAssignation;
	
	//Assignation of the axis
	AxisAssignation;
	
	// Code To Kernel	(Tranfer the other codes)
	MachineModelCodificationToSw;

END_ACTION

ACTION MachineModelAssignation:
	
	CASE gMachine.Pt.ConfigNameID OF
		
		GC_CONFIG_2BK12BAR_ID:
			CASE gMachine.In.iMachineModelCode OF
				51: // P4 Large 1 Block		|| 51-> 0011 0011
					gMachine.Pt.MachineModel:= Type_P4_6B_L;				// 3
				15: // P4 Large 2 Block		|| 15-> 0000 1111
					gMachine.Pt.MachineModel:=Type_P4_12B_L;				// 4
				48: // P4 Short 1 Block		|| 48-> 0011 0000
					gMachine.Pt.MachineModel:=Type_P4_6B;					// 1
				11: //S1400 Without Vacuum	|| 11-> 0000 1011
					gMachine.Pt.MachineModel:=Type_P4_CBK;					// 14
				12: // P4 Short 2 Block		|| 12-> 0000 1100
					gMachine.Pt.MachineModel:=Type_P4_12B;					// 2
				52: // P4 Long 1 Block Cubik|| 11-> 0011 0100
					gMachine.Pt.MachineModel:= Type_P4_CBK;				// 12 -->P4 1 Block normal with vacuum and cubik functions
				ELSE
					gMachine.Pt.MachineModel:=NoType;

			END_CASE			

		GC_CONFIG_1BK2BAR_ID:
			CASE gMachine.In.iMachineModelCode OF
				3: // EBRO 1 Block			|| 3->  0000 0011
					gMachine.Pt.MachineModel:=Type_SHLD;					// 5
				ELSE
					gMachine.Pt.MachineModel:=NoType;

			END_CASE
			
		GC_CONFIG_BM_1BK8BAR_ID:
			CASE gMachine.In.iMachineModelCode OF
				5: //P5 Oil					|| 5->	0000 0101
					gMachine.Pt.MachineModel:=Type_P5_OIL;
				6: //P5 Water				|| 6->	0000 0110
					gMachine.Pt.MachineModel:=Type_P5_WTR;
				13: //S1400 Without Vacuum	|| 13-> 0000 1101
					gMachine.Pt.MachineModel:=Type_S1400;
				14: //S1400 With Vacuum	PWRLNK	|| 14->	0000 1110
					gMachine.Pt.MachineModel:=Type_S1400_VAC_PWRLNK;
				15: //S1400 With Vacuum	CAN		|| 14->	0000 1111
					gMachine.Pt.MachineModel:=Type_S1400_VAC_CAN;

				ELSE
					gMachine.Pt.MachineModel:=NoType;

			END_CASE
		
			
		GC_CONFIG_1BK8BAR_NOZ2_ID:
			CASE gMachine.In.iMachineModelCode OF
				40:
					gMachine.Pt.MachineModel:=Type_NOZ_2_UV;				// 15
				41:
					gMachine.Pt.MachineModel:=Type_NOZ_2_UV_White;
				
				ELSE
					gMachine.Pt.MachineModel:=NoType;
				
			END_CASE
			
		GC_CONFIG_1BK8BAR_NOZ2_AQ_ID:
			CASE gMachine.In.iMachineModelCode OF
				39:
					gMachine.Pt.MachineModel:=Type_NOZ_2_AQ;
				
				ELSE
					gMachine.Pt.MachineModel:=NoType;
				
			END_CASE
			
			
		GC_CONFIG_1BK7BAR_CUBE_ID:
			CASE gMachine.In.iMachineModelCode OF
				01:
					gMachine.Pt.MachineModel:=Type_CUBE_INSPECTION; 
				02:
					gMachine.Pt.MachineModel := Type_CUBE_GULLIVER_INSPECTION;
				04:
					gMachine.Pt.MachineModel:=Type_CUBE; 
				08:
					gMachine.Pt.MachineModel := Type_CUBE_GULLIVER;
				ELSE
					gMachine.Pt.MachineModel:=NoType;
				
			END_CASE
			
		GC_CONFIG_1BK10BAR_MECANO_ID:
			CASE gMachine.In.iMachineModelCode OF
				60:
					gMachine.Pt.MachineModel:=Type_MECANO_UV_WHITE;
				61:
					gMachine.Pt.MachineModel:=Type_MECANO_UV_OPV;
				62:
					gMachine.Pt.MachineModel:=Type_MECANO_UV_WHITE_OPV;
				
				ELSE
					gMachine.Pt.MachineModel:=NoType;
				
			END_CASE
			
			
		GC_CONFIG_SIMTEST_ID:
			CASE gMachine.In.iMachineModelCode OF
				51: // P4 Large 1 Block		|| 51-> 0011 0011
					gMachine.Pt.MachineModel:= Type_P4_6B_L;				// 3
				15: // P4 Large 2 Block		|| 15-> 0000 1111
					gMachine.Pt.MachineModel:=Type_P4_12B_L;				// 4
				48: // P4 Short 1 Block		|| 48-> 0011 0000
					gMachine.Pt.MachineModel:=Type_P4_6B;					// 1 
				12: // P4 Short 2 Block		|| 12-> 0000 0011
					gMachine.Pt.MachineModel:=Type_P4_12B;					// 2
				3: // EBRO 1 Block			|| 3->  0000 0011
					gMachine.Pt.MachineModel:=Type_SHLD;					// 5
				13: //S1400 Without Vacuum	|| 13-> 0000 1011
					gMachine.Pt.MachineModel:=Type_S1400;					// 9
				14: //S1400 With Vacuum	PWLNK
					gMachine.Pt.MachineModel:=Type_S1400_VAC_PWRLNK;
				1015: //S1400 With Vacuum CAN
					gMachine.Pt.MachineModel:=Type_S1400_VAC_PWRLNK;
				52: // P4 Long 1 Block Cubik|| 11-> 0011 0100
					gMachine.Pt.MachineModel:= Type_P4_CBK;				// 12 -->P4 1 Block normal with vacuum and cubik functions
				5: //P5 Oil					|| 5->	0000 0101
					gMachine.Pt.MachineModel:=Type_P5_OIL;					// 12
				6: //P5 Water				|| 6->	0000 0110
					gMachine.Pt.MachineModel:=Type_P5_WTR;					// 13
				11: //S1400 Without Vacuum	|| 11-> 0000 1011
					gMachine.Pt.MachineModel:=Type_P4_CBK;					// 14
				39:
					gMachine.Pt.MachineModel:=Type_NOZ_2_AQ;					// 11
				40:
					gMachine.Pt.MachineModel:=Type_NOZ_2_UV;				// 15
				41:
					gMachine.Pt.MachineModel:=Type_NOZ_2_UV_White;
				60:
					gMachine.Pt.MachineModel:=Type_MECANO_UV_WHITE;
				61:
					gMachine.Pt.MachineModel:=Type_MECANO_UV_OPV;
				62:
					gMachine.Pt.MachineModel:=Type_MECANO_UV_WHITE_OPV;

				10001:
					gMachine.Pt.MachineModel := Type_CUBE;
				10002:
					gMachine.Pt.MachineModel := Type_CUBE_GULLIVER;
				10003:
					gMachine.Pt.MachineModel := Type_CUBE_INSPECTION;
				10004:
					gMachine.Pt.MachineModel := Type_CUBE_GULLIVER_INSPECTION;	
				
					
				ELSE
					gMachine.Pt.MachineModel:=NoType;

			END_CASE
			xChangedSimMachine := simMachine_copy <> gSimMachine.Parameters.MachineType;
			simMachine_copy := gSimMachine.Parameters.MachineType;
			
		ELSE
			gMachine.Pt.MachineModel:=NoType;
			
	END_CASE

END_ACTION

ACTION AxisAssignation:

	IF gMachine.Pt.ConfigNameID = GC_CONFIG_SIMTEST_ID THEN
		Axis_Simulation;
		RETURN;
	END_IF
	
	
    //Name of the Axis as defined in Hardware
	CASE gMachine.Pt.MachineModel OF
		
		Type_P4_6B,
		Type_P4_6B_L,
		Type_P4_12B,
		Type_P4_12B_L:
			Axis_P4;
	
		Type_SHLD,
		Type_SHLD_L:
			Axis_Shield;
		
		
		Type_S1400,
		Type_S1400_VAC_PWRLNK,
		Type_S1400_VAC_CAN:
			Axis_S1400;
		
		Type_P5_OIL,
		Type_P5_WTR:
			Axis_P5;
			
		Type_NOZ_2_AQ:
			Axis_Nozomi2_AQ;
			
		Type_NOZ_2_UV,
		Type_NOZ_2_UV_White:
			Axis_Nozomi2;
		
		Type_CUBE,
		Type_CUBE_INSPECTION,
		Type_CUBE_GULLIVER,
		Type_CUBE_GULLIVER_INSPECTION:
			Axis_Cube;
			
		Type_MECANO_UV_WHITE,
		Type_MECANO_UV_OPV,
		Type_MECANO_UV_WHITE_OPV:
			Axis_Mecano;
			
		ELSE
			//No machine assigned
			RETURN;

	END_CASE

END_ACTION

ACTION Axis_Simulation:

	gAxis[1].Parameter.Init.AxisObjectName			:=	'gAxis01';	//Instance_Belt
	gAxis[2].Parameter.Init.AxisObjectName			:=	'gAxis21';	//Instance_BK1
	gAxis[3].Parameter.Init.AxisObjectName			:=	'gAxis121';	//Instance_BK2
	gAxis[4].Parameter.Init.AxisObjectName			:=	'gAxisStp01';	//Instance_Front3L
	gAxis[5].Parameter.Init.AxisObjectName			:=	'gAxisStp02';	//Instance_Back3L
	gAxis[6].Parameter.Init.AxisObjectName			:=	'gAxis41';	//Instance_NonCrash1

	// Assignation of Master axis
	gAxis[5].Parameter.Init.MasterGearObjectName	:=	'gAxisStp01';	//Instance_Front3L

	LoadDefaultServoConfig(ADR(gAxis[1]));
	LoadDefaultServoConfig(ADR(gAxis[2]));
	LoadDefaultServoConfig(ADR(gAxis[3]));
	LoadDefaultStepperConfig(ADR(gAxis[4])); //These are steppers and do not have torque
	LoadDefaultStepperConfig(ADR(gAxis[5])); //These are steppers and do not have torque
	LoadDefaultServoConfig(ADR(gAxis[6]));

	//Assign comms type of inverters depending on the machine type
	CASE gMachine.Pt.MachineModel OF
		Type_S1400_VAC_PWRLNK:
			gAxisInverter[1].Parameters.CommsType := COMMS_POWERLINK;
			gAxisInverter[2].Parameters.CommsType := COMMS_POWERLINK;
			gAxisInverter[3].Parameters.CommsType := COMMS_POWERLINK;
			gAxisInverter[4].Parameters.CommsType := COMMS_POWERLINK;
		
			
		Type_NOZ_2_AQ:
			IF X20IF1072_SS3.ModuleOk THEN
				gAxisInverter[1].Parameters.CommsType := COMMS_CANOPEN;
				gAxisInverter[2].Parameters.CommsType := COMMS_CANOPEN;
				gAxisInverter[3].Parameters.CommsType := COMMS_CANOPEN;
				gAxisInverter[4].Parameters.CommsType := COMMS_CANOPEN;
			ELSE
				gAxisInverter[1].Parameters.CommsType := COMMS_POWERLINK;
				gAxisInverter[2].Parameters.CommsType := COMMS_POWERLINK;
				gAxisInverter[3].Parameters.CommsType := COMMS_POWERLINK;
				gAxisInverter[4].Parameters.CommsType := COMMS_POWERLINK;
			END_IF
			
		Type_NOZ_2_UV,
		Type_NOZ_2_UV_White:
			IF X20IF1072_SS1.ModuleOk THEN
				gAxisInverter[1].Parameters.CommsType := COMMS_CANOPEN;
				gAxisInverter[2].Parameters.CommsType := COMMS_CANOPEN;
				gAxisInverter[3].Parameters.CommsType := COMMS_CANOPEN;
				gAxisInverter[4].Parameters.CommsType := COMMS_CANOPEN;
			ELSE
				gAxisInverter[1].Parameters.CommsType := COMMS_POWERLINK;
				gAxisInverter[2].Parameters.CommsType := COMMS_POWERLINK;
				gAxisInverter[3].Parameters.CommsType := COMMS_POWERLINK;
				gAxisInverter[4].Parameters.CommsType := COMMS_POWERLINK;
			END_IF
		
		Type_CUBE,
		Type_CUBE_INSPECTION,
		Type_CUBE_GULLIVER,
		Type_CUBE_GULLIVER_INSPECTION:
			gAxisInverter[1].Parameters.CommsType := COMMS_POWERLINK;
			gAxisInverter[2].Parameters.CommsType := COMMS_POWERLINK;
			gAxisInverter[3].Parameters.CommsType := COMMS_POWERLINK;
			
		Type_MECANO_UV_WHITE,
		Type_MECANO_UV_OPV,
		Type_MECANO_UV_WHITE_OPV:
			gAxisInverter[1].Parameters.CommsType := COMMS_POWERLINK;
			gAxisInverter[2].Parameters.CommsType := COMMS_POWERLINK;
			gAxisInverter[3].Parameters.CommsType := COMMS_POWERLINK;
			gAxisInverter[4].Parameters.CommsType := COMMS_POWERLINK;
		
	END_CASE
	gAxisInverter[1].Parameters.Hardware.CpuFamily := gMachine.St.HwData.Family;
	gAxisInverter[2].Parameters.Hardware.CpuFamily := gMachine.St.HwData.Family;
	gAxisInverter[3].Parameters.Hardware.CpuFamily := gMachine.St.HwData.Family;
	gAxisInverter[4].Parameters.Hardware.CpuFamily := gMachine.St.HwData.Family;
	
	//This is the physical node of each Icla
	gIcla[1].Parameter.Node:=5;
	gIcla[1].Parameter.Network := 'IF7';
	gIcla[2].Parameter.Node:=7;
	gIcla[2].Parameter.Network := 'IF7';
	gIcla[3].Parameter.Node:=50; //Same node number than in Nozomi C18000
	gIcla[3].Parameter.Network := 'IF7';
	
END_ACTION

ACTION Axis_P4:

	gAxis[1].Parameter.Init.AxisObjectName			:=	'gAxis01';	//Instance_Belt
	gAxis[2].Parameter.Init.AxisObjectName			:=	'gAxis21';	//Instance_BK1
	gAxis[3].Parameter.Init.AxisObjectName			:=	'gAxis121';	//Instance_BK2
	gAxis[4].Parameter.Init.AxisObjectName			:=	'gAxisStp01';	//Instance_Front3L
	gAxis[5].Parameter.Init.AxisObjectName			:=	'gAxisStp02';	//Instance_Back3L
	
	// Assignation of Master axis
	gAxis[5].Parameter.Init.MasterGearObjectName	:=	'gAxisStp01';	//Instance_Front3L

	LoadDefaultServoConfig(ADR(gAxis[1]));
	LoadDefaultServoConfig(ADR(gAxis[2]));
	LoadDefaultServoConfig(ADR(gAxis[3]));
	LoadDefaultStepperConfig(ADR(gAxis[4])); //These are steppers and do not have torque
	LoadDefaultStepperConfig(ADR(gAxis[5])); //These are steppers and do not have torque

	//This is the physical node of each Icla
	gIcla[1].Parameter.Node:=5;
	gIcla[1].Parameter.Network := 'IF7';
	gIcla[1].Parameter.xAutoresetComms := TRUE;
	gIcla[2].Parameter.Node:=7;
	gIcla[2].Parameter.Network := 'IF7';
	gIcla[2].Parameter.xAutoresetComms := TRUE;
	
END_ACTION

ACTION Axis_Shield:

	gAxis[1].Parameter.Init.AxisObjectName			:=	'gAxis01';	//Instance_Belt
	gAxis[2].Parameter.Init.AxisObjectName			:=	'gAxis21';	//Instance_BK1
	gAxis[3].Parameter.Init.AxisObjectName			:=	'gAxisStp01';	//Instance_Front3L
	gAxis[4].Parameter.Init.AxisObjectName			:=	'gAxisStp02';	//Instance_Back3L
	
	// Assignation of Master axis
	gAxis[4].Parameter.Init.MasterGearObjectName	:=	'gAxisStp01';	//Instance_Front3L

	LoadDefaultServoConfig(ADR(gAxis[1]));
	LoadDefaultServoConfig(ADR(gAxis[2]));
	LoadDefaultStepperConfig(ADR(gAxis[3])); //These are steppers and do not have torque
	LoadDefaultStepperConfig(ADR(gAxis[4])); //These are steppers and do not have torque
	
	//This is the physical node of each Icla
	gIcla[1].Parameter.Node:=5;
	gIcla[1].Parameter.Network := 'IF7';
	gIcla[1].Parameter.xAutoresetComms := TRUE;
	
END_ACTION

ACTION Axis_S1400:

	gAxis[1].Parameter.Init.AxisObjectName			:=	'gAxis01';	//Instance_Belt
	gAxis[2].Parameter.Init.AxisObjectName			:=	'gAxis21';	//Instance_BK1
	gAxis[3].Parameter.Init.AxisObjectName			:=	'gAxisStp01';	//Instance_Front3L
	gAxis[4].Parameter.Init.AxisObjectName			:=	'gAxisStp02';	//Instance_Back3L
	gAxis[5].Parameter.Init.AxisObjectName			:=	'gAxis41';	//Instance_NonCrash1
	
	// Assignation of Master axis
	gAxis[4].Parameter.Init.MasterGearObjectName	:=	'gAxisStp01';	//Instance_Front3L
	

	CASE gMachine.Pt.MachineModel OF
		Type_S1400_VAC_PWRLNK:
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
			gAxisInverter[3].Parameters.Hardware.PowerLinkInterface := 'IF3';
			gAxisInverter[3].Parameters.Hardware.Node := 83;
			gAxisInverter[3].Parameters.AccelerationTime := 1;
			gAxisInverter[3].Parameters.DecelerationTime := 1;
			gAxisInverter[3].Parameters.CommsType := COMMS_POWERLINK;
			gAxisInverter[4].Parameters.Hardware.PowerLinkInterface := 'IF3';
			gAxisInverter[4].Parameters.Hardware.Node := 84;
			gAxisInverter[4].Parameters.AccelerationTime := 1;
			gAxisInverter[4].Parameters.DecelerationTime := 1;
			gAxisInverter[4].Parameters.CommsType := COMMS_POWERLINK;
			
		Type_S1400_VAC_CAN:
			gAxisInverter[1].Parameters.CommsType := COMMS_CANOPEN;
			gAxisInverter[2].Parameters.CommsType := COMMS_CANOPEN;
			gAxisInverter[3].Parameters.CommsType := COMMS_CANOPEN;
			gAxisInverter[4].Parameters.CommsType := COMMS_CANOPEN;
		
	END_CASE
	
	gAxisInverter[1].Parameters.Hardware.CpuFamily := gMachine.St.HwData.Family;
	gAxisInverter[2].Parameters.Hardware.CpuFamily := gMachine.St.HwData.Family;
	gAxisInverter[3].Parameters.Hardware.CpuFamily := gMachine.St.HwData.Family;
	gAxisInverter[4].Parameters.Hardware.CpuFamily := gMachine.St.HwData.Family;

	LoadDefaultServoConfig(ADR(gAxis[1]));
	LoadDefaultServoConfig(ADR(gAxis[2]));
	LoadDefaultStepperConfig(ADR(gAxis[3])); //These are steppers and do not have torque
	LoadDefaultStepperConfig(ADR(gAxis[4])); //These are steppers and do not have torque
	LoadDefaultServoConfig(ADR(gAxis[5]));
	
	//This is the physical node of each Icla
	gIcla[1].Parameter.Node:=5;
	gIcla[1].Parameter.Network := 'IF7';
	gIcla[1].Parameter.xAutoresetComms := TRUE;
	
END_ACTION

ACTION Axis_P5:

	gAxis[1].Parameter.Init.AxisObjectName			:=	'gAxis02';	//Instance_Belt
	gAxis[2].Parameter.Init.AxisObjectName			:=	'gAxis21';	//Instance_BK1
	gAxis[3].Parameter.Init.AxisObjectName			:=	'gAxisStp01';	//Instance_Front3L
	gAxis[4].Parameter.Init.AxisObjectName			:=	'gAxisStp02';	//Instance_Back3L

	// Assignation of Master axis
	gAxis[4].Parameter.Init.MasterGearObjectName	:=	'gAxisStp01';	//Instance_Front3L

	LoadDefaultServoConfig(ADR(gAxis[1]));
	LoadDefaultServoConfig(ADR(gAxis[2]));
	LoadDefaultStepperConfig(ADR(gAxis[3])); //These are steppers and do not have torque
	LoadDefaultStepperConfig(ADR(gAxis[4])); //These are steppers and do not have torque
	
	//This is the physical node of each Icla
	gIcla[1].Parameter.Node:=5;
	gIcla[1].Parameter.Network := 'IF7';
	gIcla[1].Parameter.xAutoresetComms := TRUE;
	
END_ACTION

ACTION Axis_Nozomi2:

	gAxis[1].Parameter.Init.AxisObjectName			:=	'gAxis01';	//Instance_Belt
	gAxis[2].Parameter.Init.AxisObjectName			:=	'gAxis21';	//Instance_BK1

	LoadDefaultServoConfig(ADR(gAxis[1]));
	LoadDefaultServoConfig(ADR(gAxis[2]));

	CASE gMachine.Pt.MachineModel OF
		Type_NOZ_2_UV,
		Type_NOZ_2_UV_White:
			
			IF X20IF1072_SS1.ModuleOk THEN
				gAxisInverter[1].Parameters.CommsType := COMMS_CANOPEN;
				gAxisInverter[1].Parameters.Hardware.Node := 81;
				gAxisInverter[1].Parameters.Hardware.PowerLinkInterface := 'IF1';
				gAxisInverter[2].Parameters.CommsType := COMMS_CANOPEN;
				gAxisInverter[2].Parameters.Hardware.Node := 82;
				gAxisInverter[2].Parameters.Hardware.PowerLinkInterface := 'IF1';
				gAxisInverter[3].Parameters.CommsType := COMMS_CANOPEN;
				gAxisInverter[3].Parameters.Hardware.Node := 83;
				gAxisInverter[3].Parameters.Hardware.PowerLinkInterface := 'IF1';
				gAxisInverter[4].Parameters.CommsType := COMMS_CANOPEN;
				gAxisInverter[4].Parameters.Hardware.Node := 84;
				gAxisInverter[4].Parameters.Hardware.PowerLinkInterface := 'IF1';
			ELSE
				gAxisInverter[1].Parameters.Hardware.PowerLinkInterface := 'IF3';
				gAxisInverter[1].Parameters.Hardware.Node := 81;
				gAxisInverter[1].Parameters.AccelerationTime := 3;
				gAxisInverter[1].Parameters.DecelerationTime := 1;
				gAxisInverter[1].Parameters.CommsType := COMMS_POWERLINK;
				gAxisInverter[2].Parameters.Hardware.PowerLinkInterface := 'IF3';
				gAxisInverter[2].Parameters.Hardware.Node := 82;
				gAxisInverter[2].Parameters.AccelerationTime := gAxisInverter[1].Parameters.AccelerationTime;
				gAxisInverter[2].Parameters.DecelerationTime := gAxisInverter[1].Parameters.DecelerationTime;
				gAxisInverter[2].Parameters.CommsType := COMMS_POWERLINK;
				gAxisInverter[3].Parameters.Hardware.PowerLinkInterface := 'IF3';
				gAxisInverter[3].Parameters.Hardware.Node := 83;
				gAxisInverter[3].Parameters.AccelerationTime := gAxisInverter[1].Parameters.AccelerationTime;
				gAxisInverter[3].Parameters.DecelerationTime := gAxisInverter[1].Parameters.DecelerationTime;
				gAxisInverter[3].Parameters.CommsType := COMMS_POWERLINK;
				gAxisInverter[4].Parameters.Hardware.PowerLinkInterface := 'IF3';
				gAxisInverter[4].Parameters.Hardware.Node := 84;
				gAxisInverter[4].Parameters.AccelerationTime := gAxisInverter[1].Parameters.AccelerationTime;
				gAxisInverter[4].Parameters.DecelerationTime := gAxisInverter[1].Parameters.DecelerationTime;
				gAxisInverter[4].Parameters.CommsType := COMMS_POWERLINK;
			END_IF
		
	END_CASE
	
	gAxisInverter[1].Parameters.Hardware.CpuFamily := gMachine.St.HwData.Family;
	gAxisInverter[2].Parameters.Hardware.CpuFamily := gMachine.St.HwData.Family;
	gAxisInverter[3].Parameters.Hardware.CpuFamily := gMachine.St.HwData.Family;
	gAxisInverter[4].Parameters.Hardware.CpuFamily := gMachine.St.HwData.Family;
	
	
	//This is the physical node of each Icla
	gIcla[1].Parameter.Node:=5;
	gIcla[1].Parameter.Network := 'IF7';
	gIcla[1].Parameter.xAutoresetComms := TRUE;
	gIcla[2].Parameter.Node:=2; //50; [RGP] We had to change number node to match the node order that AS was expecting. Escalated to JNovella. No reason explained.
	gIcla[2].Parameter.Network := 'IF7';
	gIcla[2].Parameter.xAutoresetComms := TRUE;
	gIcla[3].Parameter.Node:=6;
	gIcla[3].Parameter.Network := 'IF7';
	gIcla[3].Parameter.xAutoresetComms := TRUE;
	gIcla[4].Parameter.Node:=7;
	gIcla[4].Parameter.Network := 'IF7';
	gIcla[4].Parameter.xAutoresetComms := TRUE;
	gIcla[5].Parameter.Node:=8;
	gIcla[5].Parameter.Network := 'IF7';
	gIcla[5].Parameter.xAutoresetComms := TRUE;
	gIcla[6].Parameter.Node:=9;
	gIcla[6].Parameter.Network := 'IF7';
	gIcla[6].Parameter.xAutoresetComms := TRUE;
	
END_ACTION

ACTION Axis_Nozomi2_AQ:

	gAxis[1].Parameter.Init.AxisObjectName			:=	'gAxis01';	//Instance_Belt
	gAxis[2].Parameter.Init.AxisObjectName			:=	'gAxis21';	//Instance_BK1

	LoadDefaultServoConfig(ADR(gAxis[1]));
	LoadDefaultServoConfig(ADR(gAxis[2]));

	CASE gMachine.Pt.MachineModel OF
		Type_NOZ_2_AQ:
			
			IF X20IF1072_SS3.ModuleOk THEN
				gAxisInverter[1].Parameters.CommsType := COMMS_CANOPEN;
				gAxisInverter[1].Parameters.Hardware.Node := 81;
				gAxisInverter[1].Parameters.Hardware.PowerLinkInterface := 'SS3.IF1';
				gAxisInverter[2].Parameters.CommsType := COMMS_CANOPEN;
				gAxisInverter[2].Parameters.Hardware.Node := 82;
				gAxisInverter[2].Parameters.Hardware.PowerLinkInterface := 'SS3.IF1';
				gAxisInverter[3].Parameters.CommsType := COMMS_CANOPEN;
				gAxisInverter[3].Parameters.Hardware.Node := 83;
				gAxisInverter[3].Parameters.Hardware.PowerLinkInterface := 'SS3.IF1';
				gAxisInverter[4].Parameters.CommsType := COMMS_CANOPEN;
				gAxisInverter[4].Parameters.Hardware.Node := 84;
				gAxisInverter[4].Parameters.Hardware.PowerLinkInterface := 'SS3.IF1';
			ELSE
				gAxisInverter[1].Parameters.Hardware.PowerLinkInterface := 'IF3';
				gAxisInverter[1].Parameters.Hardware.Node := 81;
				gAxisInverter[1].Parameters.AccelerationTime := 3;
				gAxisInverter[1].Parameters.DecelerationTime := 1;
				gAxisInverter[1].Parameters.CommsType := COMMS_POWERLINK;
				gAxisInverter[2].Parameters.Hardware.PowerLinkInterface := 'IF3';
				gAxisInverter[2].Parameters.Hardware.Node := 82;
				gAxisInverter[2].Parameters.AccelerationTime := gAxisInverter[1].Parameters.AccelerationTime;
				gAxisInverter[2].Parameters.DecelerationTime := gAxisInverter[1].Parameters.DecelerationTime;
				gAxisInverter[2].Parameters.CommsType := COMMS_POWERLINK;
				gAxisInverter[3].Parameters.Hardware.PowerLinkInterface := 'IF3';
				gAxisInverter[3].Parameters.Hardware.Node := 83;
				gAxisInverter[3].Parameters.AccelerationTime := gAxisInverter[1].Parameters.AccelerationTime;
				gAxisInverter[3].Parameters.DecelerationTime := gAxisInverter[1].Parameters.DecelerationTime;
				gAxisInverter[3].Parameters.CommsType := COMMS_POWERLINK;
				gAxisInverter[4].Parameters.Hardware.PowerLinkInterface := 'IF3';
				gAxisInverter[4].Parameters.Hardware.Node := 84;
				gAxisInverter[4].Parameters.AccelerationTime := gAxisInverter[1].Parameters.AccelerationTime;
				gAxisInverter[4].Parameters.DecelerationTime := gAxisInverter[1].Parameters.DecelerationTime;
				gAxisInverter[4].Parameters.CommsType := COMMS_POWERLINK;
			END_IF
		
	END_CASE
	
	gAxisInverter[1].Parameters.Hardware.CpuFamily := gMachine.St.HwData.Family;
	gAxisInverter[2].Parameters.Hardware.CpuFamily := gMachine.St.HwData.Family;
	gAxisInverter[3].Parameters.Hardware.CpuFamily := gMachine.St.HwData.Family;
	gAxisInverter[4].Parameters.Hardware.CpuFamily := gMachine.St.HwData.Family;
	
	
	//This is the physical node of each Icla
	gIcla[1].Parameter.Node:=5;
	gIcla[1].Parameter.Network := 'SS2.IF1';
	gIcla[1].Parameter.xAutoresetComms := TRUE;
	gIcla[2].Parameter.Node:=2; //50; [RGP] We had to change number node to match the node order that AS was expecting. Escalated to JNovella. No reason explained.
	gIcla[2].Parameter.Network := 'SS2.IF1';
	gIcla[2].Parameter.xAutoresetComms := TRUE;
	gIcla[3].Parameter.Node:=6;
	gIcla[3].Parameter.Network := 'SS2.IF1';
	gIcla[3].Parameter.xAutoresetComms := TRUE;
	gIcla[4].Parameter.Node:=7;
	gIcla[4].Parameter.Network := 'SS2.IF1';
	gIcla[4].Parameter.xAutoresetComms := TRUE;
	gIcla[5].Parameter.Node:=8;
	gIcla[5].Parameter.Network := 'SS2.IF1';
	gIcla[5].Parameter.xAutoresetComms := TRUE;
	gIcla[6].Parameter.Node:=9;
	gIcla[6].Parameter.Network := 'SS2.IF1';
	gIcla[6].Parameter.xAutoresetComms := TRUE;
	
END_ACTION

ACTION Axis_Cube:

	gAxis[1].Parameter.Init.AxisObjectName			:=	'gAxis01';	//Instance_Belt
	gAxis[2].Parameter.Init.AxisObjectName			:=	'gAxis21';	//Instance_BK1

	LoadDefaultServoConfig(ADR(gAxis[1]));
	LoadDefaultServoConfig(ADR(gAxis[2]));

	CASE gMachine.Pt.MachineModel OF
		Type_CUBE,
		Type_CUBE_INSPECTION,
		Type_CUBE_GULLIVER,
		Type_CUBE_GULLIVER_INSPECTION:
			
			gAxisInverter[1].Parameters.Hardware.PowerLinkInterface := 'IF3';
			gAxisInverter[1].Parameters.Hardware.Node := 81;
			gAxisInverter[1].Parameters.AccelerationTime := 0;
			gAxisInverter[1].Parameters.DecelerationTime := 0;
			gAxisInverter[1].Parameters.CommsType := COMMS_POWERLINK;
			gAxisInverter[1].Parameters.Type := INV_ABB;
			gAxisInverter[1].Parameters.ControlMode := 0;
			gAxisInverter[2].Parameters.Hardware.PowerLinkInterface := 'IF3';
			gAxisInverter[2].Parameters.Hardware.Node := 82;
			gAxisInverter[2].Parameters.AccelerationTime := 0;
			gAxisInverter[2].Parameters.DecelerationTime := 0;
			gAxisInverter[2].Parameters.CommsType := COMMS_POWERLINK;
			gAxisInverter[2].Parameters.Type := INV_ABB;
			gAxisInverter[2].Parameters.ControlMode := 0;
			
			gAxisInverter[3].Parameters.Hardware.PowerLinkInterface := 'IF3';
			gAxisInverter[3].Parameters.Hardware.Node := 91;
			gAxisInverter[3].Parameters.AccelerationTime := 0;
			gAxisInverter[3].Parameters.DecelerationTime := 0;
			gAxisInverter[3].Parameters.CommsType := COMMS_POWERLINK;
			gAxisInverter[3].Parameters.Type := INV_ABB;
			gAxisInverter[3].Parameters.ControlMode := 0;
		
	END_CASE
	
	gAxisInverter[1].Parameters.Hardware.CpuFamily := gMachine.St.HwData.Family;
	gAxisInverter[2].Parameters.Hardware.CpuFamily := gMachine.St.HwData.Family;
	gAxisInverter[3].Parameters.Hardware.CpuFamily := gMachine.St.HwData.Family;
	
	
	//This is the physical node of each Icla
	gIcla[1].Parameter.Node:=5;
	gIcla[1].Parameter.Network := 'SS2.IF1';
	gIcla[1].Parameter.xAutoresetComms := TRUE;
	
END_ACTION

ACTION Axis_Mecano:

	gAxis[1].Parameter.Init.AxisObjectName			:=	'gAxis01';	//Instance_Belt
	gAxis[2].Parameter.Init.AxisObjectName			:=	'gAxis21';	//Instance_BK1

	LoadDefaultServoConfig(ADR(gAxis[1]));
	LoadDefaultServoConfig(ADR(gAxis[2]));
	
	gAxisInverter[1].Parameters.Hardware.PowerLinkInterface := 'IF3';
	gAxisInverter[1].Parameters.Hardware.Node := 81;
	gAxisInverter[1].Parameters.AccelerationTime := 0;
	gAxisInverter[1].Parameters.DecelerationTime := 0;
	gAxisInverter[1].Parameters.CommsType := COMMS_POWERLINK;
	gAxisInverter[1].Parameters.Type := INV_ABB;
	gAxisInverter[1].Parameters.ControlMode := 0;
	gAxisInverter[2].Parameters.Hardware.PowerLinkInterface := 'IF3';
	gAxisInverter[2].Parameters.Hardware.Node := 82;
	gAxisInverter[2].Parameters.AccelerationTime := 0;
	gAxisInverter[2].Parameters.DecelerationTime := 0;
	gAxisInverter[2].Parameters.CommsType := COMMS_POWERLINK;
	gAxisInverter[2].Parameters.Type := INV_ABB;
	gAxisInverter[2].Parameters.ControlMode := 0;
	gAxisInverter[3].Parameters.Hardware.PowerLinkInterface := 'IF3';
	gAxisInverter[3].Parameters.Hardware.Node := 83;
	gAxisInverter[3].Parameters.AccelerationTime := 0;
	gAxisInverter[3].Parameters.DecelerationTime := 0;
	gAxisInverter[3].Parameters.CommsType := COMMS_POWERLINK;
	gAxisInverter[3].Parameters.Type := INV_ABB;
	gAxisInverter[3].Parameters.ControlMode := 0;
	gAxisInverter[4].Parameters.Hardware.PowerLinkInterface := 'IF3';
	gAxisInverter[4].Parameters.Hardware.Node := 84;
	gAxisInverter[4].Parameters.AccelerationTime := 0;
	gAxisInverter[4].Parameters.DecelerationTime := 0;
	gAxisInverter[4].Parameters.CommsType := COMMS_POWERLINK;
	gAxisInverter[4].Parameters.Type := INV_ABB;
	gAxisInverter[4].Parameters.ControlMode := 0;
	
	gAxisInverter[1].Parameters.Hardware.CpuFamily := gMachine.St.HwData.Family;
	gAxisInverter[2].Parameters.Hardware.CpuFamily := gMachine.St.HwData.Family;
	gAxisInverter[3].Parameters.Hardware.CpuFamily := gMachine.St.HwData.Family;
	gAxisInverter[4].Parameters.Hardware.CpuFamily := gMachine.St.HwData.Family;
	
	
	//This is the physical node of each Icla
	gIcla[1].Parameter.Node:=5;
	gIcla[1].Parameter.Network := 'SS2.IF1';
	gIcla[1].Parameter.xAutoresetComms := TRUE;
	gIcla[2].Parameter.Node:=2; //50; [RGP] We had to change number node to match the node order that AS was expecting. Escalated to JNovella. No reason explained.
	gIcla[2].Parameter.Network := 'SS2.IF1';
	gIcla[2].Parameter.xAutoresetComms := TRUE;
	gIcla[3].Parameter.Node:=6;
	gIcla[3].Parameter.Network := 'SS2.IF1';
	gIcla[3].Parameter.xAutoresetComms := TRUE;
	gIcla[4].Parameter.Node:=7;
	gIcla[4].Parameter.Network := 'SS2.IF1';
	gIcla[4].Parameter.xAutoresetComms := TRUE;
	gIcla[5].Parameter.Node:=8;
	gIcla[5].Parameter.Network := 'SS2.IF1';
	gIcla[5].Parameter.xAutoresetComms := TRUE;
	gIcla[6].Parameter.Node:=9;
	gIcla[6].Parameter.Network := 'SS2.IF1';
	gIcla[6].Parameter.xAutoresetComms := TRUE;
	
	
END_ACTION

ACTION MachineModelCodificationToSw:

	CASE gMachine.Pt.MachineModel OF
		Type_P4_12B:
			gMachine.St.iMachineModelCodeSW:=120;
		
		Type_P4_12B_L:
			gMachine.St.iMachineModelCodeSW:=150;
		
		Type_P4_6B:
			gMachine.St.iMachineModelCodeSW:=480;
		
		Type_P4_CBK,
		Type_P4_6B_L:
			gMachine.St.iMachineModelCodeSW:=510;
		
		Type_SHLD:
			gMachine.St.iMachineModelCodeSW:=3;
		
		Type_SHLD_L:
			gMachine.St.iMachineModelCodeSW:=5;
		
		Type_NOZ_2_AQ:
			gMachine.St.iMachineModelCodeSW:=39;
		
		Type_NOZ_2_UV,
		Type_NOZ_2_UV_White:
			gMachine.St.iMachineModelCodeSW:=40;
		
		Type_S1400,
		Type_S1400_VAC_PWRLNK,
		Type_S1400_VAC_CAN,
		Type_P5_OIL, 
		Type_P5_WTR:
			gMachine.St.iMachineModelCodeSW:=14;
			
		Type_CUBE:
			gMachine.St.iMachineModelCodeSW:=1101;
			
		Type_CUBE_GULLIVER:
			gMachine.St.iMachineModelCodeSW:=1102;
		Type_CUBE_INSPECTION:
			gMachine.St.iMachineModelCodeSW:=1103;
			
		Type_CUBE_GULLIVER_INSPECTION:
			gMachine.St.iMachineModelCodeSW:=1104;
		

		Type_MECANO_UV_WHITE,
		Type_MECANO_UV_OPV,
		Type_MECANO_UV_WHITE_OPV:
			gMachine.St.iMachineModelCodeSW:=60;
			
		ELSE
			gMachine.St.iMachineModelCodeSW:= 0;

	END_CASE
	
END_ACTION