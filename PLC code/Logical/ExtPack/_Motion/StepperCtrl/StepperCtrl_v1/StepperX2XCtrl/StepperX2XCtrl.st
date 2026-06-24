
PROGRAM _CYCLIC

	//References
	pStepperCtrl ACCESS ADR(gAxisStepper[gIndexStepper]);
	

	IF NOT xInitDone THEN
		      
		// initialize general interfaces
		IF gIndexStepper = 1 THEN
			// initialize general interfaces
			pStepperCtrl.gAxis.size  := pStepperCtrl.gAxis.size;
			pStepperCtrl.HW.DrvIf_Typ := ncSDC_DRVSM16;
			strcpy( ADR(pStepperCtrl.HW.DrvIf_Name[0]), ADR('gAxisStepper[1].DrvIf') );
			pStepperCtrl.HW.DiDoIf_Typ := ncSDC_DIDO;
			strcpy( ADR(pStepperCtrl.HW.DiDoIf_Name[0]), ADR('gAxisStepper[1].DiDoIf') );
			pStepperCtrl.HW.EncIf1_Typ := ncSDC_ENC16;
			strcpy( ADR(pStepperCtrl.HW.EncIf1_Name[0]), ADR('gAxisStepper[1].EncIf1') );
		END_IF;
		
		IF gIndexStepper = 2 THEN
			// initialize general interfaces
			pStepperCtrl.gAxis.size  := pStepperCtrl.gAxis.size;
			pStepperCtrl.HW.DrvIf_Typ := ncSDC_DRVSM16; //ncSDC_DRVSERVO16; -> To Servo control
			strcpy( ADR(pStepperCtrl.HW.DrvIf_Name[0]), ADR('gAxisStepper[2].DrvIf') );
			pStepperCtrl.HW.DiDoIf_Typ := ncSDC_DIDO;
			strcpy( ADR(pStepperCtrl.HW.DiDoIf_Name[0]), ADR('gAxisStepper[2].DiDoIf') );
			pStepperCtrl.HW.EncIf1_Typ := ncSDC_ENC16;
			strcpy( ADR(pStepperCtrl.HW.EncIf1_Name[0]), ADR('gAxisStepper[2].EncIf1') );
		END_IF;
		pStepperCtrl.EncIf1.iLifeCnt := pStepperCtrl.EncIf1.iLifeCnt;  //TOREVIEW. Can we remove it???
	      
		// initialize old-value for delta step calculation 
	
		oSetPosOld := pStepperCtrl.DrvIf.oSetPos;		
		
		xInitDone := TRUE;
	END_IF 
	
	
	(* life counter emulation of digital inputs *)
	pStepperCtrl.DiDoIf.iLifeCntReference := pStepperCtrl.DiDoIf.iLifeCntReference + 1;
	pStepperCtrl.DiDoIf.iLifeCntNegHwEnd  := pStepperCtrl.DiDoIf.iLifeCntNegHwEnd  + 1;
	pStepperCtrl.DiDoIf.iLifeCntPosHwEnd  := pStepperCtrl.DiDoIf.iLifeCntPosHwEnd  + 1;
       
	(* default function model of ACOPOSmicro: convert absolute steps to delta steps - overflow save delta calculation *)
	pStepperCtrl.MotorStep0 := pStepperCtrl.DrvIf.oSetPos - oSetPosOld;
	oSetPosOld := pStepperCtrl.DrvIf.oSetPos;
	
	gIndexStepper := gIndexStepper + 1;
	
END_PROGRAM

