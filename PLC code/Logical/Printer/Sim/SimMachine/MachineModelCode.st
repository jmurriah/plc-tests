
ACTION MachineModelCode: 

	//Define the inputs of the Machine depending the machine to Simulate
	CASE gSimMachine.Parameters.MachineType OF
		SIM_MACHINE_2B12BAR:
			gMachine.In.iMachineModelCode:=15;
		SIM_MACHINE_1B6BAR:
			gMachine.In.iMachineModelCode:=51;
		SIM_MACHINE_1B2BAR:
			gMachine.In.iMachineModelCode:=3;
//		SIM_MACHINE_S1400:
//			gMachine.In.iMachineModelCode:=13;
		SIM_MACHINE_S1400_VAC_PWRLNK:
			gMachine.In.iMachineModelCode:=14;
		SIM_MACHINE_S1400_VAC_CAN:
			gMachine.In.iMachineModelCode:=1015;
		SIM_MACHINE_NZ2:
			gMachine.In.iMachineModelCode:=39;
		SIM_MACHINE_NZ2_UV:
			gMachine.In.iMachineModelCode:=40;
		SIM_MACHINE_NZ2_UV_WHITE:
			gMachine.In.iMachineModelCode:=41;
		SIM_MACHINE_CUBE:
			gMachine.In.iMachineModelCode:=10001;
		SIM_MACHINE_CUBE_GULLIVER:
			gMachine.In.iMachineModelCode:=10002;
//		SIM_MACHINE_P5_OIL:
//			gMachine.In.iMachineModelCode:=5;
		SIM_MACHINE_P5_WAT:
			gMachine.In.iMachineModelCode:=6;
		SIM_MACHINE_P4_CBK:
			gMachine.In.iMachineModelCode:=11;
		SIM_MACHINE_MECANO_UV_WHITE:
			gMachine.In.iMachineModelCode:=60;
		SIM_MACHINE_MECANO_UV_OPV:
			gMachine.In.iMachineModelCode:=61;
		SIM_MACHINE_MECANO_UV_WHITE_OPV:
			gMachine.In.iMachineModelCode:=62;
	END_CASE
	
	//To show or not the second card block layout in diagnostic screen
	CASE  simMachineType OF
		SIM_MACHINE_REAL:
			xShowSecondLayout := FALSE;
		
		SIM_MACHINE_2B12BAR:
			
			xShowSecondLayout	:= TRUE;
			xShowThirdLayout	:= TRUE;
			stConfigToShow_Lyout1 := 'P4_PDC_content';
			stConfigToShow_Lyout2 := 'P4_Block1_content';
			stConfigToShow_Lyout3 := 'P4_Block2_content';
			
		SIM_MACHINE_1B6BAR:
			xShowSecondLayout	:= TRUE;
			xShowThirdLayout	:= FALSE;
			stConfigToShow_Lyout1 := 'P4_PDC_content';
			stConfigToShow_Lyout2 := 'P4_Block1_content';
			
		SIM_MACHINE_P5_WAT:
			xShowSecondLayout := FALSE;
			xShowThirdLayout	:= FALSE;
			stConfigToShow_Lyout1 := 'P5_S1400_content';
			//stConfigToShow_Lyout2 := 'P4_Block1_content';
		
		SIM_MACHINE_1B2BAR:
			xShowSecondLayout := FALSE;
			xShowThirdLayout	:= FALSE;
			stConfigToShow_Lyout1 := 'SHIELD_Cards_content';
			
		SIM_MACHINE_S1400_VAC_PWRLNK,
		SIM_MACHINE_S1400_VAC_CAN:
			xShowSecondLayout := FALSE;
			xShowThirdLayout	:= FALSE;
			stConfigToShow_Lyout1 := 'P5_S1400_content';
	
		SIM_MACHINE_NZ2,
		SIM_MACHINE_NZ2_UV,
		SIM_MACHINE_NZ2_UV_WHITE:
			xShowSecondLayout := TRUE;
			xShowThirdLayout	:= FALSE;
			stConfigToShow_Lyout1 := 'NZ2_PDC_content';
			stConfigToShow_Lyout2 := 'NZ2_Printer_content';

	ELSE
			xShowSecondLayout	:= FALSE;
			xShowThirdLayout	:= FALSE;
	END_CASE
	
END_ACTION
