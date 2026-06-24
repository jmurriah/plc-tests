
ACTION ProgramsManager: 

	// This functionality is currently disabled
	RETURN;
	
	IF EDGEPOS(gMachine.Pt.ConfigNameID<>0) THEN
		AssignProgramIdentification;
		
		iSuspendInit := ST_tmp_suspend(identInitialize);
	END_IF
	
	//Manage Analog thickness execution
	IF EDGEPOS(gDing.Parameters.xDingInstalled AND NOT gPLC.xFirst_Scan) THEN

		AssignProgramIdentification;
		iResumeAnalogFast := ST_tmp_resume(identAnalogFast);
		AssignProgramIdentification;
		iResumeAnalogThick := ST_tmp_resume(identAnalogThick);
		
		nResumeAnalog := nResumeAnalog + 1;
	END_IF
	IF EDGEPOS(gPhotoCells.status.xInstalled AND NOT gDing.State.xDingInstalled AND NOT gPLC.xFirst_Scan) THEN

		AssignProgramIdentification;
		iSuspendAnalogFast := ST_tmp_suspend(identAnalogFast);
		AssignProgramIdentification;
		iSuspendAnalogThick := ST_tmp_suspend(identAnalogThick);
		
		nSuspendAnalog := nSuspendAnalog + 1;
	END_IF
	
	IF EDGEPOS(gPhotoCells.parameters.xInstall AND NOT gPLC.xFirst_Scan) THEN
		ResetResumeLaserResult;
		
		//In simulation this is not running
		IF gMachine.St.HwData.Family <> FAMILY_BRAUTOMATIONRUNTIME THEN
			AssignProgramIdentification;
			iResumeStepper2 := ST_tmp_resume(identStepper2);
			AssignProgramIdentification;
			iResumeStepper1 := ST_tmp_resume(identStepper1);
			AssignProgramIdentification;
			iResumeInitStepper := ST_tmp_resume(identInitStepper);
		END_IF
		AssignProgramIdentification;
		iResumeLaserFast := ST_tmp_resume(identLaserFast);
		AssignProgramIdentification;
		iResumeLaserCtrl := ST_tmp_resume(identLaserCtrl);
		CASE gMachine.Pt.MachineModel OF
			Type_P4_12B,
			Type_P4_12B_L,
			Type_P4_6B,
			Type_P4_CBK,
			Type_P4_6B_L:
				AssignProgramIdentification;
				iResumeAxisStepper1 := ST_tmp_resume(identAxisStepper1);
				AssignProgramIdentification;
				iResumeAxisStepper2 := ST_tmp_resume(identAxisStepper2);
		END_CASE
		nResumeLaser := nResumeLaser + 1;
	END_IF
	IF EDGEPOS(gDing.State.xDingInstalled AND NOT gPhotoCells.status.xInstalled AND NOT gPLC.xFirst_Scan) THEN
		ResetSuspendLaserResult;
		
		//In simulation this is not running
		IF gMachine.St.HwData.Family <> FAMILY_BRAUTOMATIONRUNTIME THEN
			AssignProgramIdentification;
			iSuspendStepper2 := ST_tmp_suspend(identStepper2);
			AssignProgramIdentification;
			iSuspendStepper1 := ST_tmp_suspend(identStepper1);
			AssignProgramIdentification;
			iSuspendInitStepper := ST_tmp_suspend(identInitStepper);
			AssignProgramIdentification;
		END_IF
		iSuspendLaserFast := ST_tmp_suspend(identLaserFast);
		AssignProgramIdentification;
		iSuspendLaserCtrl := ST_tmp_suspend(identLaserCtrl);
		CASE gMachine.Pt.MachineModel OF
			Type_P4_12B,
			Type_P4_12B_L,
			Type_P4_6B,
			Type_P4_CBK,
			Type_P4_6B_L:
				AssignProgramIdentification;
				iSuspendAxisStepper1 := ST_tmp_suspend(identAxisStepper1);
				AssignProgramIdentification;
				iSuspendAxisStepper2 := ST_tmp_suspend(identAxisStepper2);
		END_CASE
		nSuspendLaser := nSuspendLaser + 1;
	END_IF
	
	nProgramManager := nProgramManager + 1;
END_ACTION

ACTION ResetSuspendLaserResult: 
	iSuspendStepper2 := 10;
	iSuspendStepper1 := 10;
	iSuspendInitStepper := 10;
	iSuspendLaserFast := 10;
	iSuspendLaserCtrl := 10;
	iSuspendAxisStepper1 := 10;
	iSuspendAxisStepper2 := 10;
END_ACTION

ACTION ResetResumeLaserResult: 
	iResumeStepper2 := 10;
	iResumeStepper1 := 10;
	iResumeInitStepper := 10;
	iResumeLaserFast := 10;
	iResumeLaserCtrl := 10;
	iResumeAxisStepper1 := 10;
	iResumeAxisStepper2 := 10;
END_ACTION

ACTION AssignProgramIdentification:
	
	//Determine identificator for programs to allow working with them
	iGroup := 0; //Currently not used
	stProgramName := 'Initialize';
	ST_ident(ADR(stProgramName),iGroup,ADR(identInitialize));
	
	stProgramName := 'Analog_Fas';
	ST_ident(ADR(stProgramName),iGroup,ADR(identAnalogFast));
	stProgramName := 'AnalogThic';
	ST_ident(ADR(stProgramName),iGroup,ADR(identAnalogThick));
	
	stProgramName := 'InitSteprs';
	ST_ident(ADR(stProgramName),iGroup,ADR(identInitStepper));
	stProgramName := 'Stepper3L1';
	ST_ident(ADR(stProgramName),iGroup,ADR(identStepper1));
	stProgramName := 'Stepper3L2';
	ST_ident(ADR(stProgramName),iGroup,ADR(identStepper2));
	stProgramName := 'Stepper3L';
	ST_ident(ADR(stProgramName),iGroup,ADR(identAxisStepper1));
	stProgramName := 'Gear3L';
	ST_ident(ADR(stProgramName),iGroup,ADR(identAxisStepper2));
	stProgramName := 'nSens_Fast';
	ST_ident(ADR(stProgramName),iGroup,ADR(identLaserFast));
	stProgramName := 'nSensorCtr';
	ST_ident(ADR(stProgramName),iGroup,ADR(identLaserCtrl));
	
END_ACTION