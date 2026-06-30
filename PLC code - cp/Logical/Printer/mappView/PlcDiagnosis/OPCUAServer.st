
ACTION shareMachineConfiguration:
	
	CASE shareMachConf_Step OF
	
		0: // start operate
			shareMachConf_MethodOperate.Action  := UaMoa_CheckIsCalled; 
			shareMachConf_MethodOperate.MethodName := 'getMachineConfigPars';
			shareMachConf_MethodOperate.Execute := TRUE;
			shareMachConf_Step := 1;
		1: // check if method called
			shareMachConf_MethodOperate();
			IF shareMachConf_MethodOperate.Busy THEN
				shareMachConf_MethodOperate.Execute := FALSE;
			ELSE
				IF shareMachConf_MethodOperate.Done THEN
					IF shareMachConf_MethodOperate.IsCalled THEN
						shareMachConf_Step := 2; // method is called
					END_IF
					shareMachConf_MethodOperate.Execute := TRUE;
				END_IF
				IF shareMachConf_MethodOperate.Error THEN
					shareMachConf_Step := 0;
				END_IF
			END_IF
		2: // execute method code and return value
			Cards_MachinePt := gMachine.Pt;
			shareMachConf_Step := 3;
		3: // finish operate 
			shareMachConf_MethodOperate.Action  := UaMoa_Finished;
			shareMachConf_MethodOperate.MethodName := 'getMachineConfigPars';
			shareMachConf_MethodOperate.Execute := TRUE;
			shareMachConf_Step := 4;
		4: // finish method 
			shareMachConf_MethodOperate();
			IF shareMachConf_MethodOperate.Busy THEN
				shareMachConf_MethodOperate.Execute := FALSE;
			ELSE 
				IF shareMachConf_MethodOperate.Done OR shareMachConf_MethodOperate.Error THEN
					shareMachConf_Step := 0;			
				END_IF
			END_IF	
	END_CASE
	
END_ACTION


ACTION shareCardsModuleOk:
	
	CASE shareModuleOk_Step OF
	
		0: // start operate
			shareModuleOk_MethodOperate.Action  := UaMoa_CheckIsCalled; 
			shareModuleOk_MethodOperate.MethodName := 'getCardModuleOk';
			shareModuleOk_MethodOperate.Execute := TRUE;
			shareModuleOk_Step := 1;
		1: // check if method called
			shareModuleOk_MethodOperate();
			IF shareModuleOk_MethodOperate.Busy THEN
				shareModuleOk_MethodOperate.Execute := FALSE;
			ELSE
				IF shareModuleOk_MethodOperate.Done THEN
					IF shareModuleOk_MethodOperate.IsCalled THEN
						shareModuleOk_Step := 2; // method is called
					END_IF
					shareModuleOk_MethodOperate.Execute := TRUE;
				END_IF
				IF shareModuleOk_MethodOperate.Error THEN
					shareModuleOk_Step := 0;
				END_IF
			END_IF
		2: // finish operate 
			shareModuleOk_MethodOperate.Action  := UaMoa_Finished;
			shareModuleOk_MethodOperate.MethodName := 'getCardModuleOk';
			shareModuleOk_MethodOperate.Execute := TRUE;
			shareModuleOk_Step := 3;
		3: // finish method 
			shareModuleOk_MethodOperate();
			IF shareModuleOk_MethodOperate.Busy THEN
				shareModuleOk_MethodOperate.Execute := FALSE;
			ELSE 
				IF shareModuleOk_MethodOperate.Done OR shareModuleOk_MethodOperate.Error THEN
					shareModuleOk_Step := 0;			
				END_IF
			END_IF	
	END_CASE
	
END_ACTION

ACTION shareDI_1:
	
	CASE shareDI_1_Step OF
	
		0: // start operate
			shareDI_1_MethodOperate.Action  := UaMoa_CheckIsCalled; 
			shareDI_1_MethodOperate.MethodName := 'getDigitalInputs_1';
			shareDI_1_MethodOperate.Execute := TRUE;
			shareDI_1_Step := 1;
		1: // check if method called
			shareDI_1_MethodOperate();
			IF shareDI_1_MethodOperate.Busy THEN
				shareDI_1_MethodOperate.Execute := FALSE;
			ELSE
				IF shareDI_1_MethodOperate.Done THEN
					IF shareDI_1_MethodOperate.IsCalled THEN
						shareDI_1_Step := 2; // method is called
					END_IF
					shareDI_1_MethodOperate.Execute := TRUE;
				END_IF
				IF shareDI_1_MethodOperate.Error THEN
					shareDI_1_Step := 0;
				END_IF
			END_IF
		2: // execute method code and return value
			GetCardDI_1;
			shareDI_1_Step := 3;
		3: // finish operate 
			shareDI_1_MethodOperate.Action  := UaMoa_Finished;
			shareDI_1_MethodOperate.MethodName := 'getDigitalInputs_1';
			shareDI_1_MethodOperate.Execute := TRUE;
			shareDI_1_Step := 4;
		4: // finish method 
			shareDI_1_MethodOperate();
			IF shareDI_1_MethodOperate.Busy THEN
				shareDI_1_MethodOperate.Execute := FALSE;
			ELSE 
				IF shareDI_1_MethodOperate.Done OR shareDI_1_MethodOperate.Error THEN
					shareDI_1_Step := 0;			
				END_IF
			END_IF	
	END_CASE
	
END_ACTION

ACTION shareDO_1:
	
	CASE shareDO_1_Step OF
	
		0: // start operate
			shareDO_1_MethodOperate.Action  := UaMoa_CheckIsCalled; 
			shareDO_1_MethodOperate.MethodName := 'getDigitalOutputs_1';
			shareDO_1_MethodOperate.Execute := TRUE;
			shareDO_1_Step := 1;
		1: // check if method called
			shareDO_1_MethodOperate();
			IF shareDO_1_MethodOperate.Busy THEN
				shareDO_1_MethodOperate.Execute := FALSE;
			ELSE
				IF shareDO_1_MethodOperate.Done THEN
					IF shareDO_1_MethodOperate.IsCalled THEN
						shareDO_1_Step := 2; // method is called
					END_IF
					shareDO_1_MethodOperate.Execute := TRUE;
				END_IF
				IF shareDO_1_MethodOperate.Error THEN
					shareDO_1_Step := 0;
				END_IF
			END_IF
		2: // execute method code and return value
			GetCardDO_1;
			shareDO_1_Step := 3;
		3: // finish operate 
			shareDO_1_MethodOperate.Action  := UaMoa_Finished;
			shareDO_1_MethodOperate.MethodName := 'getDigitalOutputs_1';
			shareDO_1_MethodOperate.Execute := TRUE;
			shareDO_1_Step := 4;
		4: // finish method 
			shareDO_1_MethodOperate();
			IF shareDO_1_MethodOperate.Busy THEN
				shareDO_1_MethodOperate.Execute := FALSE;
			ELSE 
				IF shareDO_1_MethodOperate.Done OR shareDO_1_MethodOperate.Error THEN
					shareDO_1_Step := 0;			
				END_IF
			END_IF	
	END_CASE
	
END_ACTION

ACTION shareAI_1:
	
	CASE shareAI_1_Step OF
	
		0: // start operate
			shareAI_1_MethodOperate.Action  := UaMoa_CheckIsCalled; 
			shareAI_1_MethodOperate.MethodName := 'getAnalogInputs_1';
			shareAI_1_MethodOperate.Execute := TRUE;
			shareAI_1_Step := 1;
		1: // check if method called
			shareAI_1_MethodOperate();
			IF shareAI_1_MethodOperate.Busy THEN
				shareAI_1_MethodOperate.Execute := FALSE;
			ELSE
				IF shareAI_1_MethodOperate.Done THEN
					IF shareAI_1_MethodOperate.IsCalled THEN
						shareAI_1_Step := 2; // method is called
					END_IF
					shareAI_1_MethodOperate.Execute := TRUE;
				END_IF
				IF shareAI_1_MethodOperate.Error THEN
					shareAI_1_Step := 0;
				END_IF
			END_IF
		2: // execute method code and return value
			GetCardAI_1;
			shareAI_1_Step := 3;
		3: // finish operate 
			shareAI_1_MethodOperate.Action  := UaMoa_Finished;
			shareAI_1_MethodOperate.MethodName := 'getAnalogInputs_1';
			shareAI_1_MethodOperate.Execute := TRUE;
			shareAI_1_Step := 4;
		4: // finish method 
			shareAI_1_MethodOperate();
			IF shareAI_1_MethodOperate.Busy THEN
				shareAI_1_MethodOperate.Execute := FALSE;
			ELSE 
				IF shareAI_1_MethodOperate.Done OR shareAI_1_MethodOperate.Error THEN
					shareAI_1_Step := 0;			
				END_IF
			END_IF	
	END_CASE
	
END_ACTION

ACTION shareAO_1:
	
	CASE shareAO_1_Step OF
	
		0: // start operate
			shareAO_1_MethodOperate.Action  := UaMoa_CheckIsCalled; 
			shareAO_1_MethodOperate.MethodName := 'getAnalogOutputs_1';
			shareAO_1_MethodOperate.Execute := TRUE;
			shareAO_1_Step := 1;
		1: // check if method called
			shareAO_1_MethodOperate();
			IF shareAO_1_MethodOperate.Busy THEN
				shareAO_1_MethodOperate.Execute := FALSE;
			ELSE
				IF shareAO_1_MethodOperate.Done THEN
					IF shareAO_1_MethodOperate.IsCalled THEN
						shareAO_1_Step := 2; // method is called
					END_IF
					shareAO_1_MethodOperate.Execute := TRUE;
				END_IF
				IF shareAO_1_MethodOperate.Error THEN
					shareAO_1_Step := 0;
				END_IF
			END_IF
		2: // execute method code and return value
			GetCardAO_1;
			shareAO_1_Step := 3;
		3: // finish operate 
			shareAO_1_MethodOperate.Action  := UaMoa_Finished;
			shareAO_1_MethodOperate.MethodName := 'getAnalogOutputs_1';
			shareAO_1_MethodOperate.Execute := TRUE;
			shareAO_1_Step := 4;
		4: // finish method 
			shareAO_1_MethodOperate();
			IF shareAO_1_MethodOperate.Busy THEN
				shareAO_1_MethodOperate.Execute := FALSE;
			ELSE 
				IF shareAO_1_MethodOperate.Done OR shareAO_1_MethodOperate.Error THEN
					shareAO_1_Step := 0;			
				END_IF
			END_IF	
	END_CASE
	
END_ACTION

ACTION shareAT_1:
	
	CASE shareAT_1_Step OF
	
		0: // start operate
			shareAT_1_MethodOperate.Action  := UaMoa_CheckIsCalled; 
			shareAT_1_MethodOperate.MethodName := 'getTemp_1';
			shareAT_1_MethodOperate.Execute := TRUE;
			shareAT_1_Step := 1;
		1: // check if method called
			shareAT_1_MethodOperate();
			IF shareAT_1_MethodOperate.Busy THEN
				shareAT_1_MethodOperate.Execute := FALSE;
			ELSE
				IF shareAT_1_MethodOperate.Done THEN
					IF shareAT_1_MethodOperate.IsCalled THEN
						shareAT_1_Step := 2; // method is called
					END_IF
					shareAT_1_MethodOperate.Execute := TRUE;
				END_IF
				IF shareAT_1_MethodOperate.Error THEN
					shareAT_1_Step := 0;
				END_IF
			END_IF
		2: // execute method code and return value
			GetCardAT_1;
			shareAT_1_Step := 3;
		3: // finish operate 
			shareAT_1_MethodOperate.Action  := UaMoa_Finished;
			shareAT_1_MethodOperate.MethodName := 'getTemp_1';
			shareAT_1_MethodOperate.Execute := TRUE;
			shareAT_1_Step := 4;
		4: // finish method 
			shareAT_1_MethodOperate();
			IF shareAT_1_MethodOperate.Busy THEN
				shareAT_1_MethodOperate.Execute := FALSE;
			ELSE 
				IF shareAT_1_MethodOperate.Done OR shareAT_1_MethodOperate.Error THEN
					shareAT_1_Step := 0;			
				END_IF
			END_IF	
	END_CASE
	
END_ACTION

ACTION shareDI_2:
	
	CASE shareDI_2_Step OF
	
		0: // start operate
			shareDI_2_MethodOperate.Action  := UaMoa_CheckIsCalled; 
			shareDI_2_MethodOperate.MethodName := 'getDigitalInputs_2';
			shareDI_2_MethodOperate.Execute := TRUE;
			shareDI_2_Step := 1;
		1: // check if method called
			shareDI_2_MethodOperate();
			IF shareDI_2_MethodOperate.Busy THEN
				shareDI_2_MethodOperate.Execute := FALSE;
			ELSE
				IF shareDI_2_MethodOperate.Done THEN
					IF shareDI_2_MethodOperate.IsCalled THEN
						shareDI_2_Step := 2; // method is called
					END_IF
					shareDI_2_MethodOperate.Execute := TRUE;
				END_IF
				IF shareDI_2_MethodOperate.Error THEN
					shareDI_2_Step := 0;
				END_IF
			END_IF
		2: // execute method code and return value
			GetCardDI_2;
			shareDI_2_Step := 3;
		3: // finish operate 
			shareDI_2_MethodOperate.Action  := UaMoa_Finished;
			shareDI_2_MethodOperate.MethodName := 'getDigitalInputs_2';
			shareDI_2_MethodOperate.Execute := TRUE;
			shareDI_2_Step := 4;
		4: // finish method 
			shareDI_2_MethodOperate();
			IF shareDI_2_MethodOperate.Busy THEN
				shareDI_2_MethodOperate.Execute := FALSE;
			ELSE 
				IF shareDI_2_MethodOperate.Done OR shareDI_2_MethodOperate.Error THEN
					shareDI_2_Step := 0;			
				END_IF
			END_IF	
	END_CASE
	
END_ACTION

ACTION shareDO_2:
	
	CASE shareDO_2_Step OF
	
		0: // start operate
			shareDO_2_MethodOperate.Action  := UaMoa_CheckIsCalled; 
			shareDO_2_MethodOperate.MethodName := 'getDigitalOutputs_2';
			shareDO_2_MethodOperate.Execute := TRUE;
			shareDO_2_Step := 1;
		1: // check if method called
			shareDO_2_MethodOperate();
			IF shareDO_2_MethodOperate.Busy THEN
				shareDO_2_MethodOperate.Execute := FALSE;
			ELSE
				IF shareDO_2_MethodOperate.Done THEN
					IF shareDO_2_MethodOperate.IsCalled THEN
						shareDO_2_Step := 2; // method is called
					END_IF
					shareDO_2_MethodOperate.Execute := TRUE;
				END_IF
				IF shareDO_2_MethodOperate.Error THEN
					shareDO_2_Step := 0;
				END_IF
			END_IF
		2: // execute method code and return value
			GetCardDO_2;
			shareDO_2_Step := 3;
		3: // finish operate 
			shareDO_2_MethodOperate.Action  := UaMoa_Finished;
			shareDO_2_MethodOperate.MethodName := 'getDigitalOutputs_2';
			shareDO_2_MethodOperate.Execute := TRUE;
			shareDO_2_Step := 4;
		4: // finish method 
			shareDO_2_MethodOperate();
			IF shareDO_2_MethodOperate.Busy THEN
				shareDO_2_MethodOperate.Execute := FALSE;
			ELSE 
				IF shareDO_2_MethodOperate.Done OR shareDO_2_MethodOperate.Error THEN
					shareDO_2_Step := 0;			
				END_IF
			END_IF	
	END_CASE
	
END_ACTION

ACTION shareAI_2:
	
	CASE shareAI_2_Step OF
	
		0: // start operate
			shareAI_2_MethodOperate.Action  := UaMoa_CheckIsCalled; 
			shareAI_2_MethodOperate.MethodName := 'getAnalogInputs_2';
			shareAI_2_MethodOperate.Execute := TRUE;
			shareAI_2_Step := 1;
		1: // check if method called
			shareAI_2_MethodOperate();
			IF shareAI_2_MethodOperate.Busy THEN
				shareAI_2_MethodOperate.Execute := FALSE;
			ELSE
				IF shareAI_2_MethodOperate.Done THEN
					IF shareAI_2_MethodOperate.IsCalled THEN
						shareAI_2_Step := 2; // method is called
					END_IF
					shareAI_2_MethodOperate.Execute := TRUE;
				END_IF
				IF shareAI_2_MethodOperate.Error THEN
					shareAI_2_Step := 0;
				END_IF
			END_IF
		2: // execute method code and return value
			GetCardAI_2;
			shareAI_2_Step := 3;
		3: // finish operate 
			shareAI_2_MethodOperate.Action  := UaMoa_Finished;
			shareAI_2_MethodOperate.MethodName := 'getAnalogInputs_2';
			shareAI_2_MethodOperate.Execute := TRUE;
			shareAI_2_Step := 4;
		4: // finish method 
			shareAI_2_MethodOperate();
			IF shareAI_2_MethodOperate.Busy THEN
				shareAI_2_MethodOperate.Execute := FALSE;
			ELSE 
				IF shareAI_2_MethodOperate.Done OR shareAI_2_MethodOperate.Error THEN
					shareAI_2_Step := 0;			
				END_IF
			END_IF	
	END_CASE
	
END_ACTION

ACTION shareAO_2:
	
	CASE shareAO_2_Step OF
	
		0: // start operate
			shareAO_2_MethodOperate.Action  := UaMoa_CheckIsCalled; 
			shareAO_2_MethodOperate.MethodName := 'getAnalogOutputs_2';
			shareAO_2_MethodOperate.Execute := TRUE;
			shareAO_2_Step := 1;
		1: // check if method called
			shareAO_2_MethodOperate();
			IF shareAO_2_MethodOperate.Busy THEN
				shareAO_2_MethodOperate.Execute := FALSE;
			ELSE
				IF shareAO_2_MethodOperate.Done THEN
					IF shareAO_2_MethodOperate.IsCalled THEN
						shareAO_2_Step := 2; // method is called
					END_IF
					shareAO_2_MethodOperate.Execute := TRUE;
				END_IF
				IF shareAO_2_MethodOperate.Error THEN
					shareAO_2_Step := 0;
				END_IF
			END_IF
		2: // execute method code and return value
			GetCardAO_2;
			shareAO_2_Step := 3;
		3: // finish operate 
			shareAO_2_MethodOperate.Action  := UaMoa_Finished;
			shareAO_2_MethodOperate.MethodName := 'getAnalogOutputs_2';
			shareAO_2_MethodOperate.Execute := TRUE;
			shareAO_2_Step := 4;
		4: // finish method 
			shareAO_2_MethodOperate();
			IF shareAO_2_MethodOperate.Busy THEN
				shareAO_2_MethodOperate.Execute := FALSE;
			ELSE 
				IF shareAO_2_MethodOperate.Done OR shareAO_2_MethodOperate.Error THEN
					shareAO_2_Step := 0;			
				END_IF
			END_IF	
	END_CASE
	
END_ACTION

ACTION shareAT_2:
	
	CASE shareAT_2_Step OF
	
		0: // start operate
			shareAT_2_MethodOperate.Action  := UaMoa_CheckIsCalled; 
			shareAT_2_MethodOperate.MethodName := 'getTemp_2';
			shareAT_2_MethodOperate.Execute := TRUE;
			shareAT_2_Step := 1;
		1: // check if method called
			shareAT_2_MethodOperate();
			IF shareAT_2_MethodOperate.Busy THEN
				shareAT_2_MethodOperate.Execute := FALSE;
			ELSE
				IF shareAT_2_MethodOperate.Done THEN
					IF shareAT_2_MethodOperate.IsCalled THEN
						shareAT_2_Step := 2; // method is called
					END_IF
					shareAT_2_MethodOperate.Execute := TRUE;
				END_IF
				IF shareAT_2_MethodOperate.Error THEN
					shareAT_2_Step := 0;
				END_IF
			END_IF
		2: // execute method code and return value
			GetCardAT_2;
			shareAT_2_Step := 3;
		3: // finish operate 
			shareAT_2_MethodOperate.Action  := UaMoa_Finished;
			shareAT_2_MethodOperate.MethodName := 'getTemp_2';
			shareAT_2_MethodOperate.Execute := TRUE;
			shareAT_2_Step := 4;
		4: // finish method 
			shareAT_2_MethodOperate();
			IF shareAT_2_MethodOperate.Busy THEN
				shareAT_2_MethodOperate.Execute := FALSE;
			ELSE 
				IF shareAT_2_MethodOperate.Done OR shareAT_2_MethodOperate.Error THEN
					shareAT_2_Step := 0;			
				END_IF
			END_IF	
	END_CASE
END_ACTION

ACTION sharePhotoCells:
	
	CASE sharePhotoCells_Step OF
	
		0: // start operate
			sharePhotoCells_MethodOperate.Action  := UaMoa_CheckIsCalled; 
			sharePhotoCells_MethodOperate.MethodName := 'getPhotoCells';
			sharePhotoCells_MethodOperate.Execute := TRUE;
			sharePhotoCells_Step := 1;
		1: // check if method called
			sharePhotoCells_MethodOperate();
			IF sharePhotoCells_MethodOperate.Busy THEN
				sharePhotoCells_MethodOperate.Execute := FALSE;
			ELSE
				IF sharePhotoCells_MethodOperate.Done THEN
					IF sharePhotoCells_MethodOperate.IsCalled THEN
						sharePhotoCells_Step := 2; // method is called
					END_IF
					sharePhotoCells_MethodOperate.Execute := TRUE;
				END_IF
				IF sharePhotoCells_MethodOperate.Error THEN
					sharePhotoCells_Step := 0;
				END_IF
			END_IF
		2: // execute method code and return value
			
			gPhotoCells.commands.xStartCount := Detect_xStartCount;
			Detection_PhotoCells := gPhotoCells;
			Detection_PrintDir := gMachine.Pt.xLeftHandMachine;
			sharePhotoCells_Step := 3;
		3: // finish operate 
			sharePhotoCells_MethodOperate.Action  := UaMoa_Finished;
			sharePhotoCells_MethodOperate.MethodName := 'getPhotoCells';
			sharePhotoCells_MethodOperate.Execute := TRUE;
			sharePhotoCells_Step := 4;
		4: // finish method 
			sharePhotoCells_MethodOperate();
			IF sharePhotoCells_MethodOperate.Busy THEN
				sharePhotoCells_MethodOperate.Execute := FALSE;
			ELSE 
				IF sharePhotoCells_MethodOperate.Done OR sharePhotoCells_MethodOperate.Error THEN
					sharePhotoCells_Step := 0;			
				END_IF
			END_IF	
	END_CASE
	
END_ACTION

ACTION shareCuringBar:
	
	CASE shareCuringBar_Step OF
	
		0: // start operate
			shareCuringBar_MethodOperate.Action  := UaMoa_CheckIsCalled; 
			shareCuringBar_MethodOperate.MethodName := 'getCuringBar';
			shareCuringBar_MethodOperate.Execute := TRUE;
			shareCuringBar_Step := 1;
		1: // check if method called
			shareCuringBar_MethodOperate();
			IF shareCuringBar_MethodOperate.Busy THEN
				shareCuringBar_MethodOperate.Execute := FALSE;
			ELSE
				IF shareCuringBar_MethodOperate.Done THEN
					IF shareCuringBar_MethodOperate.IsCalled THEN
						shareCuringBar_Step := 2; // method is called
					END_IF
					shareCuringBar_MethodOperate.Execute := TRUE;
				END_IF
				IF shareCuringBar_MethodOperate.Error THEN
					shareCuringBar_Step := 0;
				END_IF
			END_IF
		2: // execute method code and return value
			CuringBar_VisuBar ACCESS ADR (gCuringLed[ LIMIT(1,CuringBar_BarIndex,2)]);
			shareCuringBar_Step := 3;
		3: // finish operate 
			shareCuringBar_MethodOperate.Action  := UaMoa_Finished;
			shareCuringBar_MethodOperate.MethodName := 'getCuringBar';
			shareCuringBar_MethodOperate.Execute := TRUE;
			shareCuringBar_Step := 4;
		4: // finish method 
			shareCuringBar_MethodOperate();
			IF shareCuringBar_MethodOperate.Busy THEN
				shareCuringBar_MethodOperate.Execute := FALSE;
			ELSE 
				IF shareCuringBar_MethodOperate.Done OR shareCuringBar_MethodOperate.Error THEN
					shareCuringBar_Step := 0;			
				END_IF
			END_IF	
	END_CASE
	
END_ACTION

ACTION shareBlock:
	
	CASE shareBlock_Step OF
	
		0: // start operate
			shareBlock_MethodOperate.Action  := UaMoa_CheckIsCalled; 
			shareBlock_MethodOperate.MethodName := 'getBlock';
			shareBlock_MethodOperate.Execute := TRUE;
			shareBlock_Step := 1;
		1: // check if method called
			shareBlock_MethodOperate();
			IF shareBlock_MethodOperate.Busy THEN
				shareBlock_MethodOperate.Execute := FALSE;
			ELSE
				IF shareBlock_MethodOperate.Done THEN
					IF shareBlock_MethodOperate.IsCalled THEN
						shareBlock_Step := 2; // method is called
					END_IF
					shareBlock_MethodOperate.Execute := TRUE;
				END_IF
				IF shareBlock_MethodOperate.Error THEN
					shareBlock_Step := 0;
				END_IF
			END_IF
		2: // execute method code and return value
			Block_getIndex;
			shareBlock_Step := 3;
		3: // finish operate 
			shareBlock_MethodOperate.Action  := UaMoa_Finished;
			shareBlock_MethodOperate.MethodName := 'getBlock';
			shareBlock_MethodOperate.Execute := TRUE;
			shareBlock_Step := 4;
		4: // finish method 
			shareBlock_MethodOperate();
			IF shareBlock_MethodOperate.Busy THEN
				shareBlock_MethodOperate.Execute := FALSE;
			ELSE 
				IF shareBlock_MethodOperate.Done OR shareBlock_MethodOperate.Error THEN
					shareBlock_Step := 0;			
				END_IF
			END_IF	
	END_CASE
	
END_ACTION

ACTION shareTransVacuum:
	
	CASE shareTransVacuum_Step OF
	
		0: // start operate
			shareTransVacuum_MethodOperate.Action  := UaMoa_CheckIsCalled; 
			shareTransVacuum_MethodOperate.MethodName := 'getTransVacuum';
			shareTransVacuum_MethodOperate.Execute := TRUE;
			shareTransVacuum_Step := 1;
		1: // check if method called
			shareTransVacuum_MethodOperate();
			IF shareTransVacuum_MethodOperate.Busy THEN
				shareTransVacuum_MethodOperate.Execute := FALSE;
			ELSE
				IF shareTransVacuum_MethodOperate.Done THEN
					IF shareTransVacuum_MethodOperate.IsCalled THEN
						shareTransVacuum_Step := 2; // method is called
					END_IF
					shareTransVacuum_MethodOperate.Execute := TRUE;
				END_IF
				IF shareTransVacuum_MethodOperate.Error THEN
					shareTransVacuum_Step := 0;
				END_IF
			END_IF
		2: // execute method code and return value
			Vacuum_getIndex;
			shareTransVacuum_Step := 3;
		3: // finish operate 
			shareTransVacuum_MethodOperate.Action  := UaMoa_Finished;
			shareTransVacuum_MethodOperate.MethodName := 'getTransVacuum';
			shareTransVacuum_MethodOperate.Execute := TRUE;
			shareTransVacuum_Step := 4;
		4: // finish method 
			shareTransVacuum_MethodOperate();
			IF shareTransVacuum_MethodOperate.Busy THEN
				shareTransVacuum_MethodOperate.Execute := FALSE;
			ELSE 
				IF shareTransVacuum_MethodOperate.Done OR shareTransVacuum_MethodOperate.Error THEN
					shareTransVacuum_Step := 0;			
				END_IF
			END_IF	
	END_CASE
	
END_ACTION