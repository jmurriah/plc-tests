
PROGRAM _CYCLIC
	(* Insert code here *)
	
	Block ACCESS ADR(gBlock[iBlockSimIndex]);
	MotorBlock  ACCESS ADR (gAxis[Block.parameters.iMotorAxisIndex]);
	IclaBK ACCESS ADR (gIcla[Block.parameters.iIclaAxisIndex]);	
	SimBlock ACCESS ADR (gSimBlock[iBlockSimIndex]);	
	
	
	//If the motor is not defined, it is considered there is no real block and return to avoid attach null pointer
	IF Block.parameters.iMotorAxisIndex = 0 THEN
		iBlockSimIndex:= iBlockSimIndex + 1;
		RETURN;
	END_IF
	
	
	//Enabling homing the icla
	IF Block.Status.Icla.xHomed THEN
		Block.In.xIclaSensor:=IclaBK.Status.iActualPosition<=0;
	END_IF
	
	//Automate referencing the sensor
	IF Block.Status.iBlockCaseLogicControl = 112 THEN
		Block.In.xIclaSensor:=FALSE;
	END_IF
	IF Block.Status.iBlockCaseLogicControl = 114  AND NOT SimBlock.Commands.DelayHomingIcla THEN
		Block.In.xIclaSensor:=TRUE;
	END_IF
	
	//Managing the Sensor signal with the position of hte Icla
	IF Block.commands.Mode.xAuto THEN
		Block.In.xIclaSensor:=IclaBK.Status.iActualPosition<=0;
	END_IF
	
	//Capping flow meter sensor
	IF Block.parameters.xCappingProcess THEN
		Block.In.xCappingWaterFlowmeter := TRUE;
	ELSE
		Block.In.xCappingWaterFlowmeter := FALSE;
	END_IF
	
	
	//Managing the homing of the Elevation motor
	IF EDGEPOS(MotorBlock.Status.PLCopenState.Homing AND NOT SimBlock.Commands.DelayHomingBar ) THEN		
		iRefSignalState:=1;
		TimesExcecHoming:=TimesExcecHoming+1;
	END_IF
		
	StatusNcAccess := ncaccess(ncACP10MAN, ADR(MotorBlock.Parameter.Init.AxisObjectName), ADR(AxisRef));			
	
	fbWriteRefSignal.Axis := AxisRef;
	fbWriteRefSignal.ParID := ACP10PAR_VAR_I4_0;
	fbWriteRefSignal.DataType := ncPAR_TYP_DINT;
	fbWriteRefSignal.DataAddress := ADR(uiValueRef);
	
	CASE iRefSignalState OF
		0:
			fbWriteRefSignal.Execute := FALSE;
		1:
			//IF EDGEPOS(iRefSignalState=2) THEN fbWriteRefSignal.Execute := TRUE; END_IF
			IF NOT fbWriteRefSignal.Done AND NOT fbWriteRefSignal.Busy THEN 
				fbWriteRefSignal.Execute := TRUE; 
			END_IF
			uiValueRef:=1;
			IF fbWriteRefSignal.Done THEN
				fbWriteRefSignal.Execute := FALSE;
				iRefSignalState:=2;
			END_IF
			IF fbWriteRefSignal.Error THEN
				fbWriteRefSignal.Execute := FALSE;
			END_IF
		
		2:
			//IF EDGEPOS(iRefSignalState=2) THEN fbWriteRefSignal.Execute := TRUE; END_IF
			IF NOT fbWriteRefSignal.Done AND NOT fbWriteRefSignal.Busy THEN 
				fbWriteRefSignal.Execute := TRUE; 
			END_IF
			uiValueRef:=0;
			IF fbWriteRefSignal.Done THEN
				fbWriteRefSignal.Execute := FALSE;
				iRefSignalState:=3;
			END_IF
	
		3:
			//IF EDGEPOS(iRefSignalState=2) THEN fbWriteRefSignal.Execute := TRUE; END_IF
			IF NOT fbWriteRefSignal.Done AND NOT fbWriteRefSignal.Busy THEN 
				fbWriteRefSignal.Execute := TRUE; 
			END_IF
			uiValueRef:=1;
			IF fbWriteRefSignal.Done THEN
				fbWriteRefSignal.Execute := FALSE;
				iRefSignalState:=0;
			END_IF
	
	END_CASE
	
	fbWriteRefSignal();	
	
	
	
	iBlockSimIndex:= iBlockSimIndex + 1;
	
END_PROGRAM
