
PROGRAM _CYCLIC
	(* Insert code here *)
	
	Block ACCESS ADR(gSimpleBlock[iSimpleBlockSimIndex]);
	MotorBlock  ACCESS ADR (gAxis[Block.parameters.iMotorAxisIndex]);
	SimBlock ACCESS ADR (gSimSimpleBlock[iSimpleBlockSimIndex]);	
	
	
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
	
	
	
	iSimpleBlockSimIndex:= iSimpleBlockSimIndex + 1;
	
END_PROGRAM
