
PROGRAM _INIT
	
	URLHost := '127.0.0.1';
	
	Initialization;
	
	//Call variables to avoid unusefull warnings
	GlobalIO; 
	DeviceComms;
	Dryer;
	InkBox;
	Motion;
	
END_PROGRAM

PROGRAM _CYCLIC
	
	MachineModelCode;
	
	General;
	
	UPS;
	
	Tests;
	
	LogTests;
	
	//Definition of the machine at the end of the code
	IF simMachineTypeEnumCopy<>gSimMachine.Parameters.MachineType THEN
		simMachineType := DINT_TO_INT(gSimMachine.Parameters.MachineType);
		IF simMachineTypeEnumCopy <> SIM_MACHINE_REAL THEN
			xNeedToRestartCPU := TRUE;
		END_IF
	END_IF
	IF simMachineType<>simMachineTypeCopy THEN
		gSimMachine.Parameters.MachineType := simMachineType;
	END_IF

	simMachineTypeCopy := simMachineType;
	simMachineTypeEnumCopy := gSimMachine.Parameters.MachineType;
	
	//Restart CPU if needed. Done with timer to allow other programs to use the new model and save it before restart
	tonRestart.IN := xNeedToRestartCPU;
	tonRestart.PT := T#300ms;
	tonRestart();
	IF tonRestart.Q THEN
		statusReset := SYSreset(enable:= TRUE, mode:= 2);
	END_IF
	
END_PROGRAM

PROGRAM _EXIT
	gEventLogManager; //Just here to be able to watch this var
END_PROGRAM

