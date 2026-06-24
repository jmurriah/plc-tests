(********************************************************************
 * COPYRIGHT - B&R Spain
 ********************************************************************
 * PROGRAM: AxisCtrl
 * File: AxisCtrlCyclic.st
 * Author: B&R Spain
 * Created: September 19, 2013
 * Modified: April 28, 2017
 ********************************************************************
 * Implementation of Program AxisCtrl
 ********************************************************************)

PROGRAM _INIT
    
    (* Initialization of state machines *)
    InitStep := 0;
    AxisState := AX_STATE_UNKNOWN;
	AxisErrorState := AX_ERR_STATE_WAIT;
	
	//Use vars to avoid warnings 
	xISQOrderWriteSingleDownloadCnt;
	fbISQReadParUpload;
	iISQUploadindex;
	iISQUploadsubindex;
	xISQUploadnext;
	xISQOrderWriteSingleDownload;
	iISQTimesInWriteDownload;
	xISQOrderWriteDownloadCount;
	xISQOrderWriteDownload;
	fbISQWriteParUpload;
	iISQTimesInReadDownload;
	xISQOrderReadUpload;
	uiISQparId;
	xISQOrderWriteUpload;
	xISQOrderWriteUploadCount;
	iISQTimesInWriteUpload;
	iISQTimesInReadUpload;
	fbISQWriteParDownload;
	udiISQdataAddres;
	udiISQdataValue;
	urISQdataValue;
	isqRippleDataEmpty;
	MC_ReadAmbTemp;
	MC_ReadMotorTemp;
	xISQOrderReadUploadCount;
	fbISQWriteSingleParDownload;
	iISQDownloadsubindex;
	fbISQWriteParDownload;
	xISQOrderWriteSingleDownload;
	xISQDownloadnext;
	iISQDownloadindex;
	
END_PROGRAM



PROGRAM _CYCLIC
    
    (************************************************************************************)
    (* GETS REFERENCES TO STRUCTURES                                                    *)
    (* ATTENTION: This must be the first part in the cyclic PROGRAM                     *)
    (************************************************************************************)

	References;
    
 
	(************************************************************************************)
	(* INITIALIZATION SEQUENCE (Default parameters, ncaccess, Init endless position...) *)
	(************************************************************************************)

	InitSequence;

	
	(************************************************************************************)
	(* WORKAROUND: some AR versions don't copy pointer's addresses when transferring in *)
	(* copy mode (e.g. AR F4.03)                                                        *)
	(************************************************************************************)
    
	IF AxisRefDone THEN
		pACP10AXIS ACCESS AxisRef;
		pACP10VAXIS ACCESS AxisRef;
	END_IF
    

	(************************************************************************************)
	(* WAITING FOR THE AXIS TO BE REFERENCED. IF NOT INITIALIZED, EXIT PROGRAM          *)
	(************************************************************************************)
	IF NOT AxisRefDone THEN
		gIndexAxisCtrl := gIndexAxisCtrl + 1; //To avoid stopping all Axis with an error in one axis
		RETURN;
	END_IF

	
	(************************************************************************************)
	(* FBK CALLS for reading status. EXACTLY ONE PER CYCLE                              *)
	(************************************************************************************)
	(* PLCopen FBKs are onlly called once the axis has beed referenced with the ncaccess *)
    
	(************************ MC_READAXISERROR **********************)
	MC_ReadAxisError_0.Axis := AxisRef;
	MC_ReadAxisError_0.Enable := NOT(MC_ReadAxisError_0.Error);
	MC_ReadAxisError_0.DataAddress := ADR(ErrorTextFB);
	MC_ReadAxisError_0.DataLength := SIZEOF(ErrorText);
	(* Axis error table defined in the axis Parameter table is loaded if not specified *)
	//MC_ReadAxisError_0.DataObjectName := 'acp10etxen';
	MC_ReadAxisError_0();
       
	(************************ MC_READSTATUS *************************)
	MC_ReadStatus_0.Axis := AxisRef;
	MC_ReadStatus_0.Enable := NOT(MC_ReadStatus_0.Error);
	MC_ReadStatus_0();
       
	(********************MC_BR_READDRIVESTATUS***********************)
	MC_BR_ReadDriveStatus_0.Axis := AxisRef;
	MC_BR_ReadDriveStatus_0.Enable := NOT(MC_BR_ReadDriveStatus_0.Error);
	MC_BR_ReadDriveStatus_0.AdrDriveStatus := ADR(DriveStatusFB);
	MC_BR_ReadDriveStatus_0();
       
	(******************** MC_READACTUALPOSITION *********************)
	MC_ReadActualPosition_0.Axis := AxisRef;
	MC_ReadActualPosition_0.Enable := NOT(MC_ReadActualPosition_0.Error);
	MC_ReadActualPosition_0();
       
	(******************** MC_READACTUALVELOCITY *********************)
	MC_ReadActualVelocity_0.Axis := AxisRef;
	MC_ReadActualVelocity_0.Enable := NOT(MC_ReadActualVelocity_0.Error);
	MC_ReadActualVelocity_0();

	(******************** MC_READACTUATORQUE *********************)
	MC_ReadActualTorque_0.Axis := AxisRef;
	MC_ReadActualTorque_0.Enable := NOT(MC_ReadActualTorque_0.Error) AND NOT pAxisCtrl.Parameter.Coms.DisableReadingTorque;
	MC_ReadActualTorque_0();
	
	(******************** MC_READACTUALTEMPERATURE DRIVER*********************)
	MC_BR_CyclicRead_10.Axis		:= AxisRef;
	MC_BR_CyclicRead_10.Execute		:= NOT pAxisCtrl.Parameter.Coms.DisableReadingTemp AND gPLC.xBlk_5s;
	MC_BR_CyclicRead_10.ParID		:= ACP10PAR_TEMP_JUNCTION;
	MC_BR_CyclicRead_10.DataAddress	:= ADR(pAxisCtrl.Status.ActTempDrv);
	MC_BR_CyclicRead_10.DataType 	:= ncPAR_TYP_REAL;
	MC_BR_CyclicRead_10();
	
	(******************** MC_READACTUALTEMPERATUREMAX DRIVER*********************)
	MC_BR_ReadParID_11.Axis			:= AxisRef;
	MC_BR_ReadParID_11.Execute		:= pAxisCtrl.Status.MaxTempDrv<=0.0 AND NOT pAxisCtrl.Parameter.Coms.DisableReadingTemp AND InitDone;
	MC_BR_ReadParID_11.ParID		:= ACP10PAR_TEMP_JUNCTION_LIM;
	MC_BR_ReadParID_11.DataAddress	:= ADR(pAxisCtrl.Status.MaxTempDrv);
	MC_BR_ReadParID_11.DataType 	:= ncPAR_TYP_REAL;
	MC_BR_ReadParID_11();
	
	(******************** MC_READACTUALTEMPERATURE MOTOR*********************)
	MC_BR_CyclicRead_20.Axis		:= AxisRef;
	MC_BR_CyclicRead_20.Execute		:= NOT pAxisCtrl.Parameter.Coms.DisableReadingTemp AND gPLC.xBlk_5s;
	MC_BR_CyclicRead_20.ParID		:= ACP10PAR_TEMP_MOTOR;
	MC_BR_CyclicRead_20.DataAddress	:= ADR(pAxisCtrl.Status.ActTempMot);
	MC_BR_CyclicRead_20.DataType 	:= ncPAR_TYP_REAL;
	MC_BR_CyclicRead_20();
	
	(******************** MC_READACTUALTEMPERATUREMAX MOTOR*********************)
	MC_BR_ReadParID_21.Axis			:= AxisRef;
	MC_BR_ReadParID_21.Execute		:= pAxisCtrl.Status.MaxTempMotor<=0.0 AND NOT pAxisCtrl.Parameter.Coms.DisableReadingTemp AND InitDone;
	MC_BR_ReadParID_21.ParID		:= ACP10PAR_MOTOR_WIND_TEMP_MAX;
	MC_BR_ReadParID_21.DataAddress	:= ADR(pAxisCtrl.Status.MaxTempMotor);
	MC_BR_ReadParID_21.DataType 	:= ncPAR_TYP_REAL;
	MC_BR_ReadParID_21();
	
	(******************** MC_READSPEEDMAX MOTOR*********************)
	MC_BR_ReadParID_51.Axis			:= AxisRef;
	MC_BR_ReadParID_51.Execute		:= pAxisCtrl.Status.MaxSpeed<=0.0 AND InitDone;
	MC_BR_ReadParID_51.ParID		:= ACP10PAR_MOTOR_SPEED_MAX;
	MC_BR_ReadParID_51.DataAddress	:= ADR(pAxisCtrl.Status.MaxSpeed); //RPM
	MC_BR_ReadParID_51.DataType 	:= ncPAR_TYP_REAL;
	MC_BR_ReadParID_51();
	
	(******************** MC_READACTUALACCELERATIONPOSMAX MOTOR*********************)
	MC_BR_ReadParID_913.Axis		:= AxisRef;
	MC_BR_ReadParID_913.Execute		:= gPLC.xFirst_Scan OR (pAxisCtrl.Status.MaxAccelerationPos <= 0.0);
	MC_BR_ReadParID_913.ParID		:= ACP10PAR_AXLIM_A1_POS;
	MC_BR_ReadParID_913.DataAddress	:= ADR(pAxisCtrl.Status.MaxAccelerationPos);
	MC_BR_ReadParID_913.DataType 	:= ncPAR_TYP_REAL;
	MC_BR_ReadParID_913();
	
	(******************** MC_READACTUALDECELERATIONPOSMAX MOTOR*********************)
	MC_BR_ReadParID_914.Axis		:= AxisRef;
	MC_BR_ReadParID_914.Execute		:= gPLC.xFirst_Scan OR (pAxisCtrl.Status.MaxDecelerationPos <= 0.0);
	MC_BR_ReadParID_914.ParID		:= ACP10PAR_AXLIM_A2_POS;
	MC_BR_ReadParID_914.DataAddress	:= ADR(pAxisCtrl.Status.MaxDecelerationPos);
	MC_BR_ReadParID_914.DataType 	:= ncPAR_TYP_REAL;
	MC_BR_ReadParID_914();
	
	(******************** MC_READACTUALACCELERATIONNEGMAX MOTOR*********************)
	MC_BR_ReadParID_915.Axis		:= AxisRef;
	MC_BR_ReadParID_915.Execute		:= gPLC.xFirst_Scan OR (pAxisCtrl.Status.MaxAccelerationNeg <= 0.0);
	MC_BR_ReadParID_915.ParID		:= ACP10PAR_AXLIM_A1_NEG;
	MC_BR_ReadParID_915.DataAddress	:= ADR(pAxisCtrl.Status.MaxAccelerationNeg);
	MC_BR_ReadParID_915.DataType 	:= ncPAR_TYP_REAL;
	MC_BR_ReadParID_915();
	
	(******************** MC_READACTUALACCELERATIONNEGMAX MOTOR*********************)
	MC_BR_ReadParID_916.Axis		:= AxisRef;
	MC_BR_ReadParID_916.Execute		:= gPLC.xFirst_Scan OR (pAxisCtrl.Status.MaxDecelerationNeg <= 0.0);
	MC_BR_ReadParID_916.ParID		:= ACP10PAR_AXLIM_A2_NEG;
	MC_BR_ReadParID_916.DataAddress	:= ADR(pAxisCtrl.Status.MaxDecelerationNeg);
	MC_BR_ReadParID_916.DataType 	:= ncPAR_TYP_REAL;
	MC_BR_ReadParID_916();

  	(******************** MC_READACTUALCURRENT *********************)  
	MC_BR_ReadParID_214.Axis			:= AxisRef;
	MC_BR_ReadParID_214.Execute			:= NOT pAxisCtrl.Parameter.Coms.DisableReadingCurrent AND InitDone AND gPLC.xBlk_100ms;
	MC_BR_ReadParID_214.ParID			:= ACP10PAR_ICTRL_ISQ_ACT;
	MC_BR_ReadParID_214.DataAddress		:= ADR(rActualCurrent);
	MC_BR_ReadParID_214.DataType 		:= ncPAR_TYP_REAL;
	MC_BR_ReadParID_214();
	pAxisCtrl.Status.ActCurrent := MAX(rActualCurrent, 0);
	
	(******************** MC_READLAGERROR*********************)  
	MC_BR_ReadParID_112.Axis := AxisRef;
	MC_BR_ReadParID_112.Execute := ((NOT MC_BR_ReadParID_214.Error) AND (NOT MC_BR_ReadParID_214.Busy) AND NOT pAxisCtrl.Parameter.Coms.DisableReadingLagError);
	MC_BR_ReadParID_112.ParID := ACP10PAR_PCTRL_LAG_ERROR;
	MC_BR_ReadParID_112.DataAddress := ADR(gAxis[gIndexAxisCtrl].Status.ActLagError);
	MC_BR_ReadParID_112.DataType := ncPAR_TYP_REAL;
	MC_BR_ReadParID_112();

	(******************** MC_READ_RATED_TORQUE *********************)  
	MC_BR_ReadParID_53.Axis := AxisRef;
	MC_BR_ReadParID_53.Execute :=  pAxisCtrl.Status.RatedTorque<=0.0 AND pAxisCtrl.Parameter.Coms.ReadRatedTorque AND InitDone;
	MC_BR_ReadParID_53.ParID := ACP10PAR_MOTOR_TORQ_RATED;
	MC_BR_ReadParID_53.DataAddress := ADR(pAxisCtrl.Status.RatedTorque);
	MC_BR_ReadParID_53.DataType := ncPAR_TYP_REAL;
	MC_BR_ReadParID_53();
	
	(******************** MC_READ_PEAK_TORQUE *********************)  
	MC_BR_ReadParID_54.Axis := AxisRef;
	MC_BR_ReadParID_54.Execute :=  pAxisCtrl.Status.MaxTorque<=0.0 AND pAxisCtrl.Parameter.Coms.ReadMaxTorque AND InitDone;
	MC_BR_ReadParID_54.ParID := ACP10PAR_MOTOR_TORQ_MAX;
	MC_BR_ReadParID_54.DataAddress := ADR(pAxisCtrl.Status.MaxTorque);
	MC_BR_ReadParID_54.DataType := ncPAR_TYP_REAL;
	MC_BR_ReadParID_54();
	
	//This is to avoid state changes in machine state when reset is been done. New reset refused 
	IF MC_Reset_0.Busy THEN pAxisCtrl.Command.Reset := FALSE; END_IF
    
	pAxisCtrl.Status.MaxTempMotor	:= LIMIT(0, pAxisCtrl.Status.MaxTempMotor,200);
	pAxisCtrl.Status.MaxTempDrv 	:= LIMIT(0, pAxisCtrl.Status.MaxTempDrv,200);

	
	(************************************************************************************)
	(* COMMAND INCOHERENCE CHECK (Optional)                                             *)
	(************************************************************************************)
	(* If more than one motion command is commanded at the same time, which make no     *)
	(* sense, all motion commands will be aborted.                                      *)
	(* If this behaviour is not desired, the following section can be commented out.    *)
	(************************************************************************************)
    
	iActualCommandsCounter := 0;
	iCommandsError := 0;
	IF pAxisCtrl.Command.HomeDirect     THEN iActualCommandsCounter := iActualCommandsCounter + 1; iCommandsError := iCommandsError OR 16#001; END_IF
	IF pAxisCtrl.Command.HomeAbsEncoder THEN iActualCommandsCounter := iActualCommandsCounter + 1; iCommandsError := iCommandsError OR 16#002; END_IF
	IF pAxisCtrl.Command.Home           THEN iActualCommandsCounter := iActualCommandsCounter + 1; iCommandsError := iCommandsError OR 16#004; END_IF
	IF pAxisCtrl.Command.Move.Absolute  THEN iActualCommandsCounter := iActualCommandsCounter + 1; iCommandsError := iCommandsError OR 16#008; END_IF
	IF pAxisCtrl.Command.Move.Additive  THEN iActualCommandsCounter := iActualCommandsCounter + 1; iCommandsError := iCommandsError OR 16#010; END_IF
	IF pAxisCtrl.Command.Move.Velocity  THEN iActualCommandsCounter := iActualCommandsCounter + 1; iCommandsError := iCommandsError OR 16#020; END_IF
	IF pAxisCtrl.Command.Move.GearIn    THEN iActualCommandsCounter := iActualCommandsCounter + 1; iCommandsError := iCommandsError OR 16#040; END_IF
	IF pAxisCtrl.Command.Move.GearOut   THEN iActualCommandsCounter := iActualCommandsCounter + 1; iCommandsError := iCommandsError OR 16#080; END_IF
	IF pAxisCtrl.Command.Move.Halt      THEN iActualCommandsCounter := iActualCommandsCounter + 1; iCommandsError := iCommandsError OR 16#100; END_IF
	IF pAxisCtrl.Command.Reset          THEN iActualCommandsCounter := iActualCommandsCounter + 1; iCommandsError := iCommandsError OR 16#200; END_IF
	IF iActualCommandsCounter > 1 THEN
		ResetMotionCommands;
		(* In order not to get an error message, the following section can be commented out *)
		ErrorID := 50000;
		ErrorSource := ERR_SRC_TASK;
		ClearErrorTexts;
		ErrorText[0] := 'Two or more incoherent commands recived at the same time';
		ErrorText[1] := 'Check application code and timing. Cmds:';
		brsitoa(iCommandsError, ADR(ErrorAux));
		brsstrcat(ADR(ErrorText[1]), ADR(ErrorAux));
		AxisErrorState := AX_ERR_STATE_APP_ERROR;
		(* If desired, the following section can be uncommented to stop the axis as well *)
		//QuickStop;
		//AxisState := AX_STATE_UNKNOWN;
	END_IF
    
    
    
	(************************************************************************************)
	(* MAIN SEQUENCE                                                                    *)
	(************************************************************************************)
    
	(********* RISING TRIGGERS FOR THE STEP BY STEP JOGGING *********)
	R_TRIG_JogStepByStepPos(CLK := pAxisCtrl.Command.Jog.StepByStepPos);
	R_TRIG_JogStepByStepNeg(CLK := pAxisCtrl.Command.Jog.StepByStepNeg);
    
	CASE AxisState OF
        
        
		(********************************* SWITCHED OFF *********************************)
		AX_STATE_DISABLED: (* STATE: Switched off *)
            
			(* Waits until initialization is complete *)
			IF InitDone THEN
				IF (pAxisCtrl.Command.Power = TRUE) THEN
					(* A TON can be used here to avoid switching wearable components too many times *)
					PowerOn;
					AxisState := AX_STATE_SWITCHING_ON;
				ELSIF pAxisCtrl.Command.HomeAbsEncoder THEN
					HomeAbsEncoder;
					pAxisCtrl.Command.HomeAbsEncoder := FALSE;
					AxisState := AX_STATE_HOMING_NO_POWER;
				ELSIF pAxisCtrl.Command.HomeDirect THEN
					HomeDirect;
					pAxisCtrl.Command.HomeDirect := FALSE;
					AxisState := AX_STATE_HOMING_NO_POWER;
				ELSIF pAxisCtrl.Command.Home THEN
					Home;
					pAxisCtrl.Command.Home := FALSE;
					AxisState := AX_STATE_HOMING_NO_POWER;
				END_IF
			END_IF
            
            
			(******************************* HOMING NO POWER ********************************)
		AX_STATE_HOMING_NO_POWER:
            
			(* Checks if home is done *)
			IF MC_Home_0.Done THEN
				MC_Home_0.Execute := FALSE;
				HomeValid := TRUE;
				AxisState := AX_STATE_DISABLED;
			END_IF
            
			(* Checks if error occurred *)
			IF MC_Home_0.Error OR MC_Home_0.CommandAborted THEN
				MC_Home_0.Execute := FALSE;
				AxisState := AX_STATE_DISABLED;
			END_IF
            
            
			(********************************* SWITCHING OFF ********************************)
		AX_STATE_SWITCHING_OFF:
            
			(* Waits until power is off *)
			IF NOT(MC_Power_0.Status) THEN
				AxisState := AX_STATE_DISABLED;
			END_IF
        
			(* Checks if error occurred *)
			IF MC_Power_0.Error THEN
				PowerOn;
				AxisState := AX_STATE_UNKNOWN;
			END_IF
            
            
			(********************************* SWITCHING ON *********************************)
		AX_STATE_SWITCHING_ON:
            
			(* It should be allowed to switch off *)
            
			(* Checks if axis is powered *)
			IF MC_Power_0.Status THEN
				AxisState := AX_STATE_STANDSTILL;
			END_IF
            
			(* Checks if error occurred *)
			IF MC_Power_0.Error THEN
				PowerOff;
				AxisState := AX_STATE_UNKNOWN;
			END_IF
            
            
			(********************************** STANDSTILL **********************************)
		AX_STATE_STANDSTILL: (* STATE: Waiting for commands *)
            
			(* Checks if a movement is requested *)
			IF NOT(pAxisCtrl.Command.Power) THEN
				PowerOff;
				AxisState := AX_STATE_SWITCHING_OFF;
			ELSIF pAxisCtrl.Command.QuickStop THEN
				QuickStop;
				(* QuickStop is never reset by application *)
				AxisState := AX_STATE_STOPPING;
			ELSIF pAxisCtrl.Command.HomeDirect THEN
				HomeDirect;
				pAxisCtrl.Command.HomeDirect := FALSE;
				AxisState := AX_STATE_HOMING;
			ELSIF pAxisCtrl.Command.HomeAbsEncoder THEN
				HomeAbsEncoder;
				pAxisCtrl.Command.HomeAbsEncoder := FALSE;
				AxisState := AX_STATE_HOMING;
			ELSIF pAxisCtrl.Command.Home THEN
				Home;
				pAxisCtrl.Command.Home := FALSE;
				AxisState := AX_STATE_HOMING;
			ELSIF pAxisCtrl.Command.Move.Halt THEN
				(* Axis cannot be halted if it is in standstill *)
				pAxisCtrl.Command.Move.Halt := FALSE;
			ELSIF pAxisCtrl.Command.Move.Absolute THEN
				MoveAbsolute_0;
				pAxisCtrl.Command.Move.Absolute := FALSE;
				AxisState := AX_STATE_MOVING_ABSOLUTE_0;
			ELSIF pAxisCtrl.Command.Move.Additive THEN
				MoveAdditive_0;
				pAxisCtrl.Command.Move.Additive := FALSE;
				AxisState := AX_STATE_MOVING_ADDITIVE_0;
			ELSIF pAxisCtrl.Command.Move.Velocity THEN
				MoveVelocity_0;
				pAxisCtrl.Command.Move.Velocity := FALSE;
				AxisState := AX_STATE_MOVING_VELOCITY_0;
			ELSIF pAxisCtrl.Command.Move.GearIn THEN
				MoveGearIn_0;
				pAxisCtrl.Command.Move.GearIn := FALSE;
				AxisState := AX_STATE_MOVING_GEAR_0;
			ELSIF pAxisCtrl.Command.Jog.ContinuousPos AND
				NOT(pAxisCtrl.Command.Jog.ContinuousNeg) AND
				NOT(pAxisCtrl.Command.Jog.StepByStepPos) AND
				NOT(pAxisCtrl.Command.Jog.StepByStepNeg) THEN
				MoveManualContinuousPos;
				AxisState := AX_STATE_JOGGING_POS;
			ELSIF pAxisCtrl.Command.Jog.ContinuousNeg AND
				NOT(pAxisCtrl.Command.Jog.ContinuousPos) AND
				NOT(pAxisCtrl.Command.Jog.StepByStepPos) AND
				NOT(pAxisCtrl.Command.Jog.StepByStepNeg) THEN
				MoveManualContinuousNeg;
				AxisState := AX_STATE_JOGGING_NEG;
			ELSIF R_TRIG_JogStepByStepPos.Q AND
				NOT(pAxisCtrl.Command.Jog.StepByStepNeg) AND
				NOT(pAxisCtrl.Command.Jog.ContinuousPos) AND
				NOT(pAxisCtrl.Command.Jog.ContinuousNeg) THEN
				MoveManualStepByStepPos;
				AxisState := AX_STATE_JOGGING_SS_POS;
			ELSIF R_TRIG_JogStepByStepNeg.Q AND
				NOT(pAxisCtrl.Command.Jog.StepByStepPos) AND
				NOT(pAxisCtrl.Command.Jog.ContinuousPos) AND
				NOT(pAxisCtrl.Command.Jog.ContinuousNeg) THEN
				MoveManualStepByStepNeg;
				AxisState := AX_STATE_JOGGING_SS_NEG;
			ELSE
				(* Invalid command *)
			END_IF
            
            
			(************************************ HOMING ************************************)
		AX_STATE_HOMING:
            
			(* It could be interesting to implement some timeout or distance limit *)
            
			(* Checks if home is done *)
			IF MC_Home_0.Done THEN
				MC_Home_0.Execute := FALSE;
				HomeValid := TRUE;
				AxisState := AX_STATE_STANDSTILL;
			END_IF
            
			(* Checks if movement should be aborted *)
			IF NOT(pAxisCtrl.Command.Power) THEN
				MC_Home_0.Execute := FALSE;
				PowerOff;
				AxisState := AX_STATE_SWITCHING_OFF;
			ELSIF pAxisCtrl.Command.QuickStop THEN
				QuickStop;
				(* QuickStop is never reset by application *)
				MC_Home_0.Execute := FALSE;
				AxisState := AX_STATE_STOPPING;
			END_IF
            
			(* Checks if error occurred *)
			IF MC_Home_0.Error OR MC_Home_0.CommandAborted THEN
				MC_Home_0.Execute := FALSE;
				AxisState := AX_STATE_UNKNOWN;
			END_IF
            
            
			(******************************* JOGGING POSITIVE *******************************)
		AX_STATE_JOGGING_POS:
            
			(* Checks if movement should be aborted *)
			IF NOT(pAxisCtrl.Command.Power) THEN
				MC_MoveVelocity_0.Execute := FALSE;
				PowerOff;
				AxisState := AX_STATE_SWITCHING_OFF;
			ELSIF pAxisCtrl.Command.QuickStop THEN
				QuickStop;
				(* QuickStop is never reset by application *)
				MC_MoveVelocity_0.Execute := FALSE;
				AxisState := AX_STATE_STOPPING;
			ELSIF pAxisCtrl.Command.Jog.ContinuousPos AND
				NOT(pAxisCtrl.Command.Jog.ContinuousNeg) AND
				NOT(pAxisCtrl.Command.Jog.StepByStepPos) AND
				NOT(pAxisCtrl.Command.Jog.StepByStepNeg) THEN
				(* Continues jogging *)
			ELSE
				MC_MoveVelocity_0.Execute := FALSE;
				MoveManualStop;
				AxisState := AX_STATE_HALTING_JOG;
			END_IF
            
			(* Checks if error occurred *)
			IF MC_MoveVelocity_0.Error OR MC_MoveVelocity_0.CommandAborted THEN
				MC_MoveVelocity_0.Execute := FALSE;
				AxisState := AX_STATE_UNKNOWN;
			END_IF
            
            
			(******************************* JOGGING NEGATIVE *******************************)
		AX_STATE_JOGGING_NEG:
            
			(* Checks if movement should be aborted *)
			IF NOT(pAxisCtrl.Command.Power) THEN
				MC_MoveVelocity_1.Execute := FALSE;
				PowerOff;
				AxisState := AX_STATE_SWITCHING_OFF;
			ELSIF pAxisCtrl.Command.QuickStop THEN
				QuickStop;
				(* QuickStop is never reset by application *)
				MC_MoveVelocity_1.Execute := FALSE;
				AxisState := AX_STATE_STOPPING;
			ELSIF pAxisCtrl.Command.Jog.ContinuousNeg AND
				NOT(pAxisCtrl.Command.Jog.ContinuousPos) AND
				NOT(pAxisCtrl.Command.Jog.StepByStepPos) AND
				NOT(pAxisCtrl.Command.Jog.StepByStepNeg) THEN
				(* Continues jogging *)
			ELSE
				MC_MoveVelocity_1.Execute := FALSE;
				MoveManualStop;
				AxisState := AX_STATE_HALTING_JOG;
			END_IF
            
			(* Checks if error occurred *)
			IF MC_MoveVelocity_1.Error OR MC_MoveVelocity_1.CommandAborted THEN
				MC_MoveVelocity_1.Execute := FALSE;
				AxisState := AX_STATE_UNKNOWN;
			END_IF
            
            
			(************************ JOGGING POSITIVE STEP BY STEP *************************)
		AX_STATE_JOGGING_SS_POS:
            
			(* Checks if movement finished *)
			IF MC_MoveAdditive_0.Done THEN
				MC_MoveAdditive_0.Execute := FALSE;
				InPosition := TRUE;
				AxisState := AX_STATE_JOG_SS_HALTED;
			END_IF
            
			(* Checks if movement should be aborted *)
			IF NOT(pAxisCtrl.Command.Power) THEN
				MC_MoveAdditive_0.Execute := FALSE;
				PowerOff;
				AxisState := AX_STATE_SWITCHING_OFF;
			ELSIF pAxisCtrl.Command.QuickStop THEN
				QuickStop;
				(* QuickStop is never reset by application *)
				MC_MoveAdditive_0.Execute := FALSE;
				AxisState := AX_STATE_STOPPING;
			ELSIF pAxisCtrl.Command.Jog.StepByStepPos AND
				NOT(pAxisCtrl.Command.Jog.StepByStepNeg) AND
				NOT(pAxisCtrl.Command.Jog.ContinuousPos) AND
				NOT(pAxisCtrl.Command.Jog.ContinuousNeg) THEN
				(* Continues jogging *)
			ELSE
				MC_MoveAdditive_0.Execute := FALSE;
				IF MC_MoveAdditive_0.Done THEN
					AxisState := AX_STATE_STANDSTILL;
				ELSE
					MoveManualStop;
					AxisState := AX_STATE_HALTING_JOG;
				END_IF
			END_IF
            
			(* Checks if error occurred *)
			IF MC_MoveAdditive_0.Error OR MC_MoveAdditive_0.CommandAborted THEN
				MC_MoveAdditive_0.Execute := FALSE;
				AxisState := AX_STATE_UNKNOWN;
			END_IF
            
            
			(************************ JOGGING NEGATIVE STEP BY STEP *************************)
		AX_STATE_JOGGING_SS_NEG:
            
			(* Checks if movement finished *)
			IF MC_MoveAdditive_1.Done THEN
				MC_MoveAdditive_1.Execute := FALSE;
				InPosition := TRUE;
				AxisState := AX_STATE_JOG_SS_HALTED;
			END_IF
            
			(* Checks if movement should be aborted *)
			IF NOT(pAxisCtrl.Command.Power) THEN
				MC_MoveAdditive_1.Execute := FALSE;
				PowerOff;
				AxisState := AX_STATE_SWITCHING_OFF;
			ELSIF pAxisCtrl.Command.QuickStop THEN
				QuickStop;
				(* QuickStop is never reset by application *)
				MC_MoveAdditive_1.Execute := FALSE;
				AxisState := AX_STATE_STOPPING;
			ELSIF pAxisCtrl.Command.Jog.StepByStepNeg AND
				NOT(pAxisCtrl.Command.Jog.StepByStepPos) AND
				NOT(pAxisCtrl.Command.Jog.ContinuousPos) AND
				NOT(pAxisCtrl.Command.Jog.ContinuousNeg) THEN
				(* Continues jogging *)
			ELSE
				MC_MoveAdditive_1.Execute := FALSE;
				IF MC_MoveAdditive_1.Done THEN
					AxisState := AX_STATE_STANDSTILL;
				ELSE
					MoveManualStop;
					AxisState := AX_STATE_HALTING_JOG;
				END_IF
			END_IF
            
			(* Checks if error occurred *)
			IF MC_MoveAdditive_1.Error OR MC_MoveAdditive_1.CommandAborted THEN
				MC_MoveAdditive_1.Execute := FALSE;
				AxisState := AX_STATE_UNKNOWN;
			END_IF
            
            
			(*************************** JOG STEP BY STEP HALTED ****************************)
		AX_STATE_JOG_SS_HALTED:
        
			(* Checks if movement should be aborted *)
			IF NOT(pAxisCtrl.Command.Power) THEN
				MC_MoveAdditive_1.Execute := FALSE;
				PowerOff;
				AxisState := AX_STATE_SWITCHING_OFF;
			ELSIF pAxisCtrl.Command.QuickStop THEN
				QuickStop;
				(* QuickStop is never reset by application *)
				MC_MoveAdditive_1.Execute := FALSE;
				AxisState := AX_STATE_STOPPING;
			ELSIF NOT(pAxisCtrl.Command.Jog.StepByStepNeg) AND
				NOT(pAxisCtrl.Command.Jog.StepByStepPos) THEN
				AxisState := AX_STATE_STANDSTILL;
			ELSE
				(* Continues halted *)
			END_IF
            
            
			(********************************* HALTING JOG **********************************)
		AX_STATE_HALTING_JOG:
            
			(* Checks if movement has finished *)
			IF MC_Halt_0.Done THEN
				MC_Halt_0.Execute := FALSE;
				AxisState := AX_STATE_STANDSTILL;
			END_IF
            
			(* Checks if movement should be aborted *)
			IF NOT(pAxisCtrl.Command.Power) THEN
				MC_Halt_0.Execute := FALSE;
				PowerOff;
				AxisState := AX_STATE_SWITCHING_OFF;
			ELSIF pAxisCtrl.Command.QuickStop THEN
				QuickStop;
				(* QuickStop is never reset by application *)
				MC_Halt_0.Execute := FALSE;
				AxisState := AX_STATE_STOPPING;
			ELSIF pAxisCtrl.Command.Jog.ContinuousPos AND
				NOT(pAxisCtrl.Command.Jog.ContinuousNeg) AND
				NOT(pAxisCtrl.Command.Jog.StepByStepPos) AND
				NOT(pAxisCtrl.Command.Jog.StepByStepNeg) THEN
				MC_Halt_0.Execute := FALSE;
				MoveManualContinuousPos;
				AxisState := AX_STATE_JOGGING_POS;
			ELSIF pAxisCtrl.Command.Jog.ContinuousNeg AND
				NOT(pAxisCtrl.Command.Jog.ContinuousPos) AND
				NOT(pAxisCtrl.Command.Jog.StepByStepPos) AND
				NOT(pAxisCtrl.Command.Jog.StepByStepNeg) THEN
				MC_Halt_0.Execute := FALSE;
				MoveManualContinuousNeg;
				AxisState := AX_STATE_JOGGING_NEG;
			ELSIF R_TRIG_JogStepByStepPos.Q AND
				NOT(pAxisCtrl.Command.Jog.StepByStepNeg) AND
				NOT(pAxisCtrl.Command.Jog.ContinuousPos) AND
				NOT(pAxisCtrl.Command.Jog.ContinuousNeg) THEN
				MC_Halt_0.Execute := FALSE;
				MoveManualStepByStepPos;
				AxisState := AX_STATE_JOGGING_SS_POS;
			ELSIF R_TRIG_JogStepByStepNeg.Q AND
				NOT(pAxisCtrl.Command.Jog.StepByStepPos) AND
				NOT(pAxisCtrl.Command.Jog.ContinuousPos) AND
				NOT(pAxisCtrl.Command.Jog.ContinuousNeg) THEN
				MC_Halt_0.Execute := FALSE;
				MoveManualStepByStepNeg;
				AxisState := AX_STATE_JOGGING_SS_NEG;
			END_IF
            
			(* Checks if error occurred *)
			IF MC_Halt_0.Error OR MC_Halt_0.CommandAborted THEN
				MC_Halt_0.Execute := FALSE;
				AxisState := AX_STATE_UNKNOWN;
			END_IF
            
            
			(******************************* MOVING ABSOLUTE ********************************)
		AX_STATE_MOVING_ABSOLUTE_0:
            
			(* Checks if movement has finished *)
			IF MC_MoveAbsolute_0.Done THEN
				MC_MoveAbsolute_0.Execute := FALSE;
				InPosition := TRUE;
				AxisState := AX_STATE_STANDSTILL;
			END_IF
            
			(* Checks if movement should be aborted *)
			IF NOT(pAxisCtrl.Command.Power) THEN
				MC_MoveAbsolute_0.Execute := FALSE;
				PowerOff;
				AxisState := AX_STATE_SWITCHING_OFF;
			ELSIF pAxisCtrl.Command.QuickStop THEN
				QuickStop;
				(* QuickStop is never reset by application *)
				MC_MoveAbsolute_0.Execute := FALSE;
				AxisState := AX_STATE_STOPPING;
			ELSIF pAxisCtrl.Command.Move.Halt THEN
				MoveHalt_0;
				pAxisCtrl.Command.Move.Halt := FALSE;
				MC_MoveAbsolute_0.Execute := FALSE;
				AxisState := AX_STATE_HALTING_0;
			ELSIF pAxisCtrl.Command.Move.Absolute THEN
				MoveAbsolute_1;
				pAxisCtrl.Command.Move.Absolute := FALSE;
				MC_MoveAbsolute_0.Execute := FALSE;
				AxisState := AX_STATE_MOVING_ABSOLUTE_1;
			ELSIF pAxisCtrl.Command.Move.Additive THEN
				MoveAdditive_0;
				pAxisCtrl.Command.Move.Additive := FALSE;
				MC_MoveAbsolute_0.Execute := FALSE;
				AxisState := AX_STATE_MOVING_ADDITIVE_0;
			ELSIF pAxisCtrl.Command.Move.Velocity THEN
				MoveVelocity_0;
				pAxisCtrl.Command.Move.Velocity := FALSE;
				MC_MoveAbsolute_0.Execute := FALSE;
				AxisState := AX_STATE_MOVING_VELOCITY_0;
			ELSIF pAxisCtrl.Command.Move.GearIn THEN
				MoveGearIn_0;
				pAxisCtrl.Command.Move.GearIn := FALSE;
				MC_MoveAbsolute_0.Execute := FALSE;
				AxisState := AX_STATE_MOVING_GEAR_0;
			END_IF
            
			(* Checks if error occurred *)
			IF MC_MoveAbsolute_0.Error OR MC_MoveAbsolute_0.CommandAborted THEN
				MC_MoveAbsolute_0.Execute := FALSE;
				AxisState := AX_STATE_UNKNOWN;
			END_IF
            
            
		AX_STATE_MOVING_ABSOLUTE_1:
            
			(* Checks if movement has finished *)
			IF MC_MoveAbsolute_1.Done THEN
				MC_MoveAbsolute_1.Execute := FALSE;
				InPosition := TRUE;
				AxisState := AX_STATE_STANDSTILL;
			END_IF
            
			(* Checks if movement should be aborted *)
			IF NOT(pAxisCtrl.Command.Power) THEN
				MC_MoveAbsolute_1.Execute := FALSE;
				PowerOff;
				AxisState := AX_STATE_SWITCHING_OFF;
			ELSIF pAxisCtrl.Command.QuickStop THEN
				QuickStop;
				(* QuickStop is never reset by application *)
				MC_MoveAbsolute_1.Execute := FALSE;
				AxisState := AX_STATE_STOPPING;
			ELSIF pAxisCtrl.Command.Move.Halt THEN
				MoveHalt_0;
				pAxisCtrl.Command.Move.Halt := FALSE;
				MC_MoveAbsolute_1.Execute := FALSE;
				AxisState := AX_STATE_HALTING_0;
			ELSIF pAxisCtrl.Command.Move.Absolute THEN
				MoveAbsolute_0;
				pAxisCtrl.Command.Move.Absolute := FALSE;
				MC_MoveAbsolute_1.Execute := FALSE;
				AxisState := AX_STATE_MOVING_ABSOLUTE_0;
			ELSIF pAxisCtrl.Command.Move.Additive THEN
				MoveAdditive_0;
				pAxisCtrl.Command.Move.Additive := FALSE;
				MC_MoveAbsolute_1.Execute := FALSE;
				AxisState := AX_STATE_MOVING_ADDITIVE_0;
			ELSIF pAxisCtrl.Command.Move.Velocity THEN
				MoveVelocity_0;
				pAxisCtrl.Command.Move.Velocity := FALSE;
				MC_MoveAbsolute_1.Execute := FALSE;
				AxisState := AX_STATE_MOVING_VELOCITY_0;
			ELSIF pAxisCtrl.Command.Move.GearIn THEN
				MoveGearIn_0;
				pAxisCtrl.Command.Move.GearIn := FALSE;
				MC_MoveAbsolute_1.Execute := FALSE;
				AxisState := AX_STATE_MOVING_GEAR_0;
			END_IF
            
			(* Checks if error occurred *)
			IF MC_MoveAbsolute_1.Error OR MC_MoveAbsolute_1.CommandAborted THEN
				MC_MoveAbsolute_1.Execute := FALSE;
				AxisState := AX_STATE_UNKNOWN;
			END_IF
            
            
			(******************************* MOVING ADDITIVE ********************************)
		AX_STATE_MOVING_ADDITIVE_0:
            
			(* Checks if movement has finished *)
			IF MC_MoveAdditive_0.Done THEN
				MC_MoveAdditive_0.Execute := FALSE;
				InPosition := TRUE;
				AxisState := AX_STATE_STANDSTILL;
			END_IF
            
			(* Checks if movement should be aborted *)
			IF NOT(pAxisCtrl.Command.Power) THEN
				MC_MoveAdditive_0.Execute := FALSE;
				PowerOff;
				AxisState := AX_STATE_SWITCHING_OFF;
			ELSIF pAxisCtrl.Command.QuickStop THEN
				QuickStop;
				(* QuickStop is never reset by application *)
				MC_MoveAdditive_0.Execute := FALSE;
				AxisState := AX_STATE_STOPPING;
			ELSIF pAxisCtrl.Command.Move.Halt THEN
				MoveHalt_0;
				pAxisCtrl.Command.Move.Halt := FALSE;
				MC_MoveAdditive_0.Execute := FALSE;
				AxisState := AX_STATE_HALTING_0;
			ELSIF pAxisCtrl.Command.Move.Absolute THEN
				MoveAbsolute_0;
				pAxisCtrl.Command.Move.Absolute := FALSE;
				MC_MoveAdditive_0.Execute := FALSE;
				AxisState := AX_STATE_MOVING_ABSOLUTE_0;
			ELSIF pAxisCtrl.Command.Move.Additive THEN
				MoveAdditive_1;
				pAxisCtrl.Command.Move.Additive := FALSE;
				MC_MoveAdditive_0.Execute := FALSE;
				AxisState := AX_STATE_MOVING_ADDITIVE_1;
			ELSIF pAxisCtrl.Command.Move.Velocity THEN
				MoveVelocity_0;
				pAxisCtrl.Command.Move.Velocity := FALSE;
				MC_MoveAdditive_0.Execute := FALSE;
				AxisState := AX_STATE_MOVING_VELOCITY_0;
			ELSIF pAxisCtrl.Command.Move.GearIn THEN
				MoveGearIn_0;
				pAxisCtrl.Command.Move.GearIn := FALSE;
				MC_MoveAdditive_0.Execute := FALSE;
				AxisState := AX_STATE_MOVING_GEAR_0;
			END_IF
            
			(* Checks if error occurred *)
			IF MC_MoveAdditive_0.Error OR MC_MoveAdditive_0.CommandAborted THEN
				MC_MoveAdditive_0.Execute := FALSE;
				AxisState := AX_STATE_UNKNOWN;
			END_IF
            
            
		AX_STATE_MOVING_ADDITIVE_1:
            
			(* Checks if movement has finished *)
			IF MC_MoveAdditive_1.Done THEN
				MC_MoveAdditive_1.Execute := FALSE;
				InPosition := TRUE;
				AxisState := AX_STATE_STANDSTILL;
			END_IF
            
			(* Checks if movement should be aborted *)
			IF NOT(pAxisCtrl.Command.Power) THEN
				MC_MoveAdditive_1.Execute := FALSE;
				PowerOff;
				AxisState := AX_STATE_SWITCHING_OFF;
			ELSIF pAxisCtrl.Command.QuickStop THEN
				QuickStop;
				(* QuickStop is never reset by application *)
				MC_MoveAdditive_1.Execute := FALSE;
				AxisState := AX_STATE_STOPPING;
			ELSIF pAxisCtrl.Command.Move.Halt THEN
				MoveHalt_0;
				pAxisCtrl.Command.Move.Halt := FALSE;
				MC_MoveAdditive_1.Execute := FALSE;
				AxisState := AX_STATE_HALTING_0;
			ELSIF pAxisCtrl.Command.Move.Absolute THEN
				MoveAbsolute_0;
				pAxisCtrl.Command.Move.Absolute := FALSE;
				MC_MoveAdditive_1.Execute := FALSE;
				AxisState := AX_STATE_MOVING_ABSOLUTE_0;
			ELSIF pAxisCtrl.Command.Move.Additive THEN
				MoveAdditive_0;
				pAxisCtrl.Command.Move.Additive := FALSE;
				MC_MoveAdditive_1.Execute := FALSE;
				AxisState := AX_STATE_MOVING_ADDITIVE_0;
			ELSIF pAxisCtrl.Command.Move.Velocity THEN
				MoveVelocity_0;
				pAxisCtrl.Command.Move.Velocity := FALSE;
				MC_MoveAdditive_1.Execute := FALSE;
				AxisState := AX_STATE_MOVING_VELOCITY_0;
			ELSIF pAxisCtrl.Command.Move.GearIn THEN
				MoveGearIn_0;
				pAxisCtrl.Command.Move.GearIn := FALSE;
				MC_MoveAdditive_1.Execute := FALSE;
				AxisState := AX_STATE_MOVING_GEAR_0;
			END_IF
            
			(* Checks if error occurred *)
			IF MC_MoveAdditive_1.Error OR MC_MoveAdditive_1.CommandAborted THEN
				MC_MoveAdditive_1.Execute := FALSE;
				AxisState := AX_STATE_UNKNOWN;
			END_IF
            
            
			(****************************** MOVING CONTINUOUS *******************************)
		AX_STATE_MOVING_VELOCITY_0:
            
			(* Checks if movement should be aborted *)
			IF NOT(pAxisCtrl.Command.Power) THEN
				MC_MoveVelocity_0.Execute := FALSE;
				PowerOff;
				AxisState := AX_STATE_SWITCHING_OFF;
			ELSIF pAxisCtrl.Command.QuickStop THEN
				QuickStop;
				(* QuickStop is never reset by application *)
				MC_MoveVelocity_0.Execute := FALSE;
				AxisState := AX_STATE_STOPPING;
			ELSIF pAxisCtrl.Command.Move.Halt THEN
				MoveHalt_0;
				pAxisCtrl.Command.Move.Halt := FALSE;
				MC_MoveVelocity_0.Execute := FALSE;
				AxisState := AX_STATE_HALTING_0;
			ELSIF pAxisCtrl.Command.Move.Absolute THEN
				MoveAbsolute_0;
				pAxisCtrl.Command.Move.Absolute := FALSE;
				MC_MoveVelocity_0.Execute := FALSE;
				AxisState := AX_STATE_MOVING_ABSOLUTE_0;
			ELSIF pAxisCtrl.Command.Move.Additive THEN
				MoveAdditive_0;
				pAxisCtrl.Command.Move.Additive := FALSE;
				MC_MoveVelocity_0.Execute := FALSE;
				AxisState := AX_STATE_MOVING_ADDITIVE_0;
			ELSIF pAxisCtrl.Command.Move.Velocity THEN
				MoveVelocity_1;
				pAxisCtrl.Command.Move.Velocity := FALSE;
				MC_MoveVelocity_0.Execute := FALSE;
				AxisState := AX_STATE_MOVING_VELOCITY_1;
			ELSIF pAxisCtrl.Command.Move.GearIn THEN
				MoveGearIn_0;
				pAxisCtrl.Command.Move.GearIn := FALSE;
				MC_MoveVelocity_0.Execute := FALSE;
				AxisState := AX_STATE_MOVING_GEAR_0;
			END_IF
            
			(* Checks if error occurred *)
			IF MC_MoveVelocity_0.Error OR MC_MoveVelocity_0.CommandAborted THEN
				MC_MoveVelocity_0.Execute := FALSE;
				AxisState := AX_STATE_UNKNOWN;
			END_IF
            
            
		AX_STATE_MOVING_VELOCITY_1:
            
			(* Checks if movement should be aborted *)
			IF NOT(pAxisCtrl.Command.Power) THEN
				MC_MoveVelocity_1.Execute := FALSE;
				PowerOff;
				AxisState := AX_STATE_SWITCHING_OFF;
			ELSIF pAxisCtrl.Command.QuickStop THEN
				QuickStop;
				(* QuickStop is never reset by application *)
				MC_MoveVelocity_1.Execute := FALSE;
				AxisState := AX_STATE_STOPPING;
			ELSIF pAxisCtrl.Command.Move.Halt THEN
				MoveHalt_0;
				pAxisCtrl.Command.Move.Halt := FALSE;
				MC_MoveVelocity_1.Execute := FALSE;
				AxisState := AX_STATE_HALTING_0;
			ELSIF pAxisCtrl.Command.Move.Absolute THEN
				MoveAbsolute_0;
				pAxisCtrl.Command.Move.Absolute := FALSE;
				MC_MoveVelocity_1.Execute := FALSE;
				AxisState := AX_STATE_MOVING_ABSOLUTE_0;
			ELSIF pAxisCtrl.Command.Move.Additive THEN
				MoveAdditive_0;
				pAxisCtrl.Command.Move.Additive := FALSE;
				MC_MoveVelocity_1.Execute := FALSE;
				AxisState := AX_STATE_MOVING_ADDITIVE_0;
			ELSIF pAxisCtrl.Command.Move.Velocity THEN
				MoveVelocity_0;
				pAxisCtrl.Command.Move.Velocity := FALSE;
				MC_MoveVelocity_1.Execute := FALSE;
				AxisState := AX_STATE_MOVING_VELOCITY_0;
			ELSIF pAxisCtrl.Command.Move.GearIn THEN
				MoveGearIn_0;
				pAxisCtrl.Command.Move.GearIn := FALSE;
				MC_MoveVelocity_1.Execute := FALSE;
				AxisState := AX_STATE_MOVING_GEAR_0;
			END_IF
            
			(* Checks if error occurred *)
			IF MC_MoveVelocity_1.Error OR MC_MoveVelocity_1.CommandAborted THEN
				MC_MoveVelocity_1.Execute := FALSE;
				AxisState := AX_STATE_UNKNOWN;
			END_IF
            

			(****************************** MOVING GEARED *******************************)
		AX_STATE_MOVING_GEAR_0:
            
			(* Checks if axis has finished gearing *)
			IF MC_GearIn_0.InGear THEN
				InGear := TRUE;
			END_IF
            
			(* Checks if movement should be aborted *)
			IF NOT(pAxisCtrl.Command.Power) THEN
				MC_GearIn_0.Execute := FALSE;
				PowerOff;
				AxisState := AX_STATE_SWITCHING_OFF;
			ELSIF pAxisCtrl.Command.QuickStop THEN
				QuickStop;
				(* QuickStop is never reset by application *)
				MC_GearIn_0.Execute := FALSE;
				AxisState := AX_STATE_STOPPING;
			ELSIF pAxisCtrl.Command.Move.Halt THEN
				MoveHalt_0;
				pAxisCtrl.Command.Move.Halt := FALSE;
				MC_GearIn_0.Execute := FALSE;
				AxisState := AX_STATE_HALTING_0;
			ELSIF pAxisCtrl.Command.Move.Absolute THEN
				MoveAbsolute_0;
				pAxisCtrl.Command.Move.Absolute := FALSE;
				MC_GearIn_0.Execute := FALSE;
				AxisState := AX_STATE_MOVING_ABSOLUTE_0;
			ELSIF pAxisCtrl.Command.Move.Additive THEN
				MoveAdditive_0;
				pAxisCtrl.Command.Move.Additive := FALSE;
				MC_GearIn_0.Execute := FALSE;
				AxisState := AX_STATE_MOVING_ADDITIVE_0;
			ELSIF pAxisCtrl.Command.Move.Velocity THEN
				MoveVelocity_0;
				pAxisCtrl.Command.Move.Velocity := FALSE;
				MC_GearIn_0.Execute := FALSE;
				AxisState := AX_STATE_MOVING_VELOCITY_0;
			ELSIF pAxisCtrl.Command.Move.GearIn THEN
				MoveGearIn_1;
				pAxisCtrl.Command.Move.GearIn := FALSE;
				MC_GearIn_0.Execute := FALSE;
				AxisState := AX_STATE_MOVING_GEAR_1;
			ELSIF pAxisCtrl.Command.Move.GearOut THEN
				MoveGearOut_x;
				pAxisCtrl.Command.Move.GearOut := FALSE;
				MC_GearIn_0.Execute := FALSE;
				AxisState := AX_STATE_MOVING_VELOCITY_0;
			END_IF
            
			(* Checks if error occurred *)
			IF MC_GearIn_0.Error OR MC_GearIn_0.CommandAborted THEN
				InGear := FALSE;
				MC_GearIn_0.Execute := FALSE;
				AxisState := AX_STATE_UNKNOWN;
			END_IF
            
            
		AX_STATE_MOVING_GEAR_1:
            
			(* Checks if axis has finished gearing *)
			IF MC_GearIn_1.InGear THEN
				InGear := TRUE;
			END_IF
            
			(* Checks if movement should be aborted *)
			IF NOT(pAxisCtrl.Command.Power) THEN
				MC_GearIn_1.Execute := FALSE;
				PowerOff;
				AxisState := AX_STATE_SWITCHING_OFF;
			ELSIF pAxisCtrl.Command.QuickStop THEN
				QuickStop;
				(* QuickStop is never reset by application *)
				MC_GearIn_1.Execute := FALSE;
				AxisState := AX_STATE_STOPPING;
			ELSIF pAxisCtrl.Command.Move.Halt THEN
				MoveHalt_0;
				pAxisCtrl.Command.Move.Halt := FALSE;
				MC_GearIn_1.Execute := FALSE;
				AxisState := AX_STATE_HALTING_0;
			ELSIF pAxisCtrl.Command.Move.Absolute THEN
				MoveAbsolute_0;
				pAxisCtrl.Command.Move.Absolute := FALSE;
				MC_GearIn_1.Execute := FALSE;
				AxisState := AX_STATE_MOVING_ABSOLUTE_0;
			ELSIF pAxisCtrl.Command.Move.Additive THEN
				MoveAdditive_0;
				pAxisCtrl.Command.Move.Additive := FALSE;
				MC_GearIn_1.Execute := FALSE;
				AxisState := AX_STATE_MOVING_ADDITIVE_0;
			ELSIF pAxisCtrl.Command.Move.Velocity THEN
				MoveVelocity_0;
				pAxisCtrl.Command.Move.Velocity := FALSE;
				MC_GearIn_1.Execute := FALSE;
				AxisState := AX_STATE_MOVING_VELOCITY_0;
			ELSIF pAxisCtrl.Command.Move.GearIn THEN
				MoveGearIn_0;
				pAxisCtrl.Command.Move.GearIn := FALSE;
				MC_GearIn_1.Execute := FALSE;
				AxisState := AX_STATE_MOVING_GEAR_0;
			ELSIF pAxisCtrl.Command.Move.GearOut THEN
				MoveGearOut_x;
				pAxisCtrl.Command.Move.GearOut := FALSE;
				MC_GearIn_1.Execute := FALSE;
				AxisState := AX_STATE_MOVING_VELOCITY_0;
			END_IF
            
			(* Checks if error occurred *)
			IF MC_GearIn_1.Error OR MC_GearIn_1.CommandAborted THEN
				InGear := FALSE;
				MC_GearIn_1.Execute := FALSE;
				AxisState := AX_STATE_UNKNOWN;
			END_IF
            
 			
		(******************************* HALTING MOVEMENT *******************************)
		AX_STATE_HALTING_0:
            
			(* Checks if movement has finished *)
			IF MC_Halt_0.Done THEN
				MC_Halt_0.Execute := FALSE;
				InPosition := TRUE;
				AxisState := AX_STATE_STANDSTILL;
			END_IF
            
			(* Checks if movement should be aborted *)
			IF NOT(pAxisCtrl.Command.Power) THEN
				MC_Halt_0.Execute := FALSE;
				PowerOff;
				AxisState := AX_STATE_SWITCHING_OFF;
			ELSIF pAxisCtrl.Command.QuickStop THEN
				QuickStop;
				(* QuickStop is never reset by application *)
				MC_Halt_0.Execute := FALSE;
				AxisState := AX_STATE_STOPPING;
			ELSIF pAxisCtrl.Command.Move.Halt THEN
				MoveHalt_1;
				pAxisCtrl.Command.Move.Halt := FALSE;
				MC_Halt_0.Execute := FALSE;
				AxisState := AX_STATE_HALTING_1;
			ELSIF pAxisCtrl.Command.Move.Absolute THEN
				MoveAbsolute_0;
				pAxisCtrl.Command.Move.Absolute := FALSE;
				MC_Halt_0.Execute := FALSE;
				AxisState := AX_STATE_MOVING_ABSOLUTE_0;
			ELSIF pAxisCtrl.Command.Move.Additive THEN
				MoveAdditive_0;
				pAxisCtrl.Command.Move.Additive := FALSE;
				MC_Halt_0.Execute := FALSE;
				AxisState := AX_STATE_MOVING_ADDITIVE_0;
			ELSIF pAxisCtrl.Command.Move.Velocity THEN
				MoveVelocity_0;
				pAxisCtrl.Command.Move.Velocity := FALSE;
				MC_Halt_0.Execute := FALSE;
				AxisState := AX_STATE_MOVING_VELOCITY_0;
			ELSIF pAxisCtrl.Command.Move.GearIn THEN
				MoveGearIn_0;
				pAxisCtrl.Command.Move.GearIn := FALSE;
				MC_Halt_0.Execute := FALSE;
				AxisState := AX_STATE_MOVING_GEAR_0;
			END_IF
            
			(* Checks if error occurred *)
			IF MC_Halt_0.Error OR MC_Halt_0.CommandAborted THEN
				MC_Halt_0.Execute := FALSE;
				AxisState := AX_STATE_UNKNOWN;
			END_IF
            
            
		AX_STATE_HALTING_1:
            
			(* Checks if movement has finished *)
			IF MC_Halt_1.Done THEN
				MC_Halt_1.Execute := FALSE;
				InPosition := TRUE;
				AxisState := AX_STATE_STANDSTILL;
			END_IF
            
			(* Checks if movement should be aborted *)
			IF NOT(pAxisCtrl.Command.Power) THEN
				MC_Halt_1.Execute := FALSE;
				PowerOff;
				AxisState := AX_STATE_SWITCHING_OFF;
			ELSIF pAxisCtrl.Command.QuickStop THEN
				QuickStop;
				(* QuickStop is never reset by application *)
				MC_Halt_1.Execute := FALSE;
				AxisState := AX_STATE_STOPPING;
			ELSIF pAxisCtrl.Command.Move.Halt THEN
				MoveHalt_0;
				pAxisCtrl.Command.Move.Halt := FALSE;
				MC_Halt_1.Execute := FALSE;
				AxisState := AX_STATE_HALTING_0;
			ELSIF pAxisCtrl.Command.Move.Absolute THEN
				MoveAbsolute_0;
				pAxisCtrl.Command.Move.Absolute := FALSE;
				MC_Halt_1.Execute := FALSE;
				AxisState := AX_STATE_MOVING_ABSOLUTE_0;
			ELSIF pAxisCtrl.Command.Move.Additive THEN
				MoveAdditive_0;
				pAxisCtrl.Command.Move.Additive := FALSE;
				MC_Halt_1.Execute := FALSE;
				AxisState := AX_STATE_MOVING_ADDITIVE_0;
			ELSIF pAxisCtrl.Command.Move.Velocity THEN
				MoveVelocity_0;
				pAxisCtrl.Command.Move.Velocity := FALSE;
				MC_Halt_1.Execute := FALSE;
				AxisState := AX_STATE_MOVING_VELOCITY_0;
			ELSIF pAxisCtrl.Command.Move.GearIn THEN
				MoveGearIn_0;
				pAxisCtrl.Command.Move.GearIn := FALSE;
				MC_Halt_1.Execute := FALSE;
				AxisState := AX_STATE_MOVING_GEAR_0;
			END_IF
            
			(* Checks if error occurred *)
			IF MC_Halt_1.Error OR MC_Halt_1.CommandAborted THEN
				MC_Halt_1.Execute := FALSE;
				AxisState := AX_STATE_UNKNOWN;
			END_IF
            
            
			(****************************** STOPPING MOVEMENT *******************************)
		AX_STATE_STOPPING:
            
			(* Checks if stop has finished *)
			IF (MC_Stop_0.Done = TRUE) AND NOT(pAxisCtrl.Command.QuickStop) THEN
				MC_Stop_0.Execute := FALSE;
				AxisState := AX_STATE_STANDSTILL;
			END_IF
            
			(* Checks if movement should be aborted *)
			IF NOT(pAxisCtrl.Command.Power) THEN
				MC_Stop_0.Execute := FALSE;
				PowerOff;
				AxisState := AX_STATE_SWITCHING_OFF;
			END_IF
            
			(* Checks if error occurred *)
			IF MC_Stop_0.Error OR MC_Stop_0.CommandAborted THEN
				MC_Stop_0.Execute := FALSE;
				AxisState := AX_STATE_UNKNOWN;
			END_IF
            
            
			(********************************************************************************)
			(*********************** STATES WHOSE CAUSE IS NOT KNOWN ************************)
		AX_STATE_UNKNOWN:
            
			(* PLCopen state is not known *)
			(* The state supervisor will assign the proper AX_STATE_UK_x when possible *)
        
        
		AX_STATE_UK_DISABLED:
            
			(* If the axis has come to disabled by an unknown reason, take it as normal *)
			(* Waits until initialization is complete *)
			IF InitDone THEN
				IF (pAxisCtrl.Command.Power = TRUE) THEN
					(* A TON can be used here to avoid switching wearable components too many times *)
					PowerOn;
					AxisState := AX_STATE_SWITCHING_ON;
				ELSIF pAxisCtrl.Command.HomeAbsEncoder THEN
					HomeAbsEncoder;
					pAxisCtrl.Command.HomeAbsEncoder := FALSE;
					AxisState := AX_STATE_HOMING_NO_POWER;
				ELSIF pAxisCtrl.Command.HomeDirect THEN
					HomeDirect;
					pAxisCtrl.Command.HomeDirect := FALSE;
					AxisState := AX_STATE_HOMING_NO_POWER;
				END_IF
			END_IF
            
            
		AX_STATE_UK_STANDSTILL:
            
			(* If the axis has come to standstill by an unknown reason, take it as normal *)
			(* Checks if a movement is requested *)
			IF NOT(pAxisCtrl.Command.Power) THEN
				PowerOff;
				AxisState := AX_STATE_SWITCHING_OFF;
			ELSIF pAxisCtrl.Command.QuickStop THEN
				QuickStop;
				(* QuickStop is never reset by application *)
				AxisState := AX_STATE_STOPPING;
			ELSIF pAxisCtrl.Command.HomeDirect THEN
				HomeDirect;
				pAxisCtrl.Command.HomeDirect := FALSE;
				AxisState := AX_STATE_HOMING;
			ELSIF pAxisCtrl.Command.HomeAbsEncoder THEN
				HomeAbsEncoder;
				pAxisCtrl.Command.HomeAbsEncoder := FALSE;
				AxisState := AX_STATE_HOMING;
			ELSIF pAxisCtrl.Command.Home THEN
				Home;
				pAxisCtrl.Command.Home := FALSE;
				AxisState := AX_STATE_HOMING;
			ELSIF pAxisCtrl.Command.Move.Halt THEN
				(* Axis cannot be halted if it is in standstill *)
				pAxisCtrl.Command.Move.Halt := FALSE;
			ELSIF pAxisCtrl.Command.Move.Absolute THEN
				MoveAbsolute_0;
				pAxisCtrl.Command.Move.Absolute := FALSE;
				AxisState := AX_STATE_MOVING_ABSOLUTE_0;
			ELSIF pAxisCtrl.Command.Move.Additive THEN
				MoveAdditive_0;
				pAxisCtrl.Command.Move.Additive := FALSE;
				AxisState := AX_STATE_MOVING_ADDITIVE_0;
			ELSIF pAxisCtrl.Command.Move.Velocity THEN
				MoveVelocity_0;
				pAxisCtrl.Command.Move.Velocity := FALSE;
				AxisState := AX_STATE_MOVING_VELOCITY_0;
			ELSIF pAxisCtrl.Command.Move.GearIn THEN
				MoveGearIn_0;
				pAxisCtrl.Command.Move.GearIn := FALSE;
				AxisState := AX_STATE_MOVING_GEAR_0;
			ELSIF pAxisCtrl.Command.Jog.ContinuousPos AND
				NOT(pAxisCtrl.Command.Jog.ContinuousNeg) AND
				NOT(pAxisCtrl.Command.Jog.StepByStepPos) AND
				NOT(pAxisCtrl.Command.Jog.StepByStepNeg) THEN
				MoveManualContinuousPos;
				AxisState := AX_STATE_JOGGING_POS;
			ELSIF pAxisCtrl.Command.Jog.ContinuousNeg AND
				NOT(pAxisCtrl.Command.Jog.ContinuousPos) AND
				NOT(pAxisCtrl.Command.Jog.StepByStepPos) AND
				NOT(pAxisCtrl.Command.Jog.StepByStepNeg) THEN
				MoveManualContinuousNeg;
				AxisState := AX_STATE_JOGGING_NEG;
			ELSIF R_TRIG_JogStepByStepPos.Q AND
				NOT(pAxisCtrl.Command.Jog.StepByStepNeg) AND
				NOT(pAxisCtrl.Command.Jog.ContinuousPos) AND
				NOT(pAxisCtrl.Command.Jog.ContinuousNeg) THEN
				MoveManualStepByStepPos;
				AxisState := AX_STATE_JOGGING_SS_POS;
			ELSIF R_TRIG_JogStepByStepNeg.Q AND
				NOT(pAxisCtrl.Command.Jog.StepByStepPos) AND
				NOT(pAxisCtrl.Command.Jog.ContinuousPos) AND
				NOT(pAxisCtrl.Command.Jog.ContinuousNeg) THEN
				MoveManualStepByStepNeg;
				AxisState := AX_STATE_JOGGING_SS_NEG;
			ELSE
				(* Invalid command *)
			END_IF
            
            
		AX_STATE_UK_HOMING:
            
			(* If the axis is performing a home by an unknown reason, allow it to stop *)
			(* Checks if movement should be aborted *)
			IF NOT(pAxisCtrl.Command.Power) THEN
				PowerOff;
				AxisState := AX_STATE_SWITCHING_OFF;
			ELSIF pAxisCtrl.Command.QuickStop THEN
				QuickStop;
				(* QuickStop is never reset by application *)
				AxisState := AX_STATE_STOPPING;
			END_IF
            
            
		AX_STATE_UK_STOPPING:
            
			(* If the axis is stopping by unknown reason, allow to switch it off *)
			(* Checks if movement should be aborted *)
			IF NOT(pAxisCtrl.Command.Power) THEN
				PowerOff;
				AxisState := AX_STATE_SWITCHING_OFF;
			END_IF
            
            
			AX_STATE_UK_DISCRETE_MOTION, AX_STATE_UK_CONTINUOUS_MOTION,
		AX_STATE_UK_SYNCHRONIZED_MOTION: 
            
			(* If the axis has come into motion by an unknown reason, allow it to be aborted *)
			(* Checks if movement should be aborted *)
			IF NOT(pAxisCtrl.Command.Power) THEN
				PowerOff;
				AxisState := AX_STATE_SWITCHING_OFF;
			ELSIF pAxisCtrl.Command.QuickStop THEN
				QuickStop;
				(* QuickStop is never reset by application *)
				AxisState := AX_STATE_STOPPING;
			ELSIF pAxisCtrl.Command.Move.Halt THEN
				MoveHalt_0;
				pAxisCtrl.Command.Move.Halt := FALSE;
				AxisState := AX_STATE_HALTING_0;
			ELSIF pAxisCtrl.Command.Move.Absolute THEN
				MoveAbsolute_0;
				pAxisCtrl.Command.Move.Absolute := FALSE;
				AxisState := AX_STATE_MOVING_ABSOLUTE_0;
			ELSIF pAxisCtrl.Command.Move.Additive THEN
				MoveAdditive_0;
				pAxisCtrl.Command.Move.Additive := FALSE;
				AxisState := AX_STATE_MOVING_ADDITIVE_0;
			ELSIF pAxisCtrl.Command.Move.Velocity THEN
				MoveVelocity_0;
				pAxisCtrl.Command.Move.Velocity := FALSE;
				AxisState := AX_STATE_MOVING_VELOCITY_0;
			ELSIF pAxisCtrl.Command.Move.GearIn THEN
				MoveGearIn_0;
				pAxisCtrl.Command.Move.GearIn := FALSE;
				AxisState := AX_STATE_MOVING_GEAR_0;
			END_IF
            
            
			(********************************** ERROR_STOP **********************************)
		AX_STATE_UK_ERROR_STOP: (* Whenever the axis is in error stop, the reason is not known *)
            
			(* If the axis must be disabled, allow to switch it off *)
			IF NOT(pAxisCtrl.Command.Power) THEN
				PowerOff;
			END_IF
			(* If the axis has come to error stop by an unknown reason, allow a reset *)
			IF pAxisCtrl.Command.Reset AND NOT MC_Reset_0.Busy THEN
				Reset;
				pAxisCtrl.Command.Reset := FALSE;
				AxisState := AX_STATE_UNKNOWN;
			END_IF
            
	END_CASE
    
    
    
	(************************************************************************************)
	(* INVALID COMMAND ABORTION (Optional)                                              *)
	(************************************************************************************)
	(* Any command which cannot be processed at the time it is recived will be aborted. *)
	(* If this behaviour is not desired, the following section can be commented out.    *)
	(************************************************************************************)
    
	iActualCommandsCounter := 0;
	IF pAxisCtrl.Command.HomeDirect     THEN iActualCommandsCounter := iActualCommandsCounter + 1; ErrorFB := 'MC_Home';          END_IF
	IF pAxisCtrl.Command.HomeAbsEncoder THEN iActualCommandsCounter := iActualCommandsCounter + 1; ErrorFB := 'MC_Home';          END_IF
	IF pAxisCtrl.Command.Home           THEN iActualCommandsCounter := iActualCommandsCounter + 1; ErrorFB := 'MC_Home';          END_IF
	IF pAxisCtrl.Command.Move.Absolute  THEN iActualCommandsCounter := iActualCommandsCounter + 1; ErrorFB := 'MC_MoveAbolute';   END_IF
	IF pAxisCtrl.Command.Move.Additive  THEN iActualCommandsCounter := iActualCommandsCounter + 1; ErrorFB := 'MC_MoveAdditive';  END_IF
	IF pAxisCtrl.Command.Move.Velocity  THEN iActualCommandsCounter := iActualCommandsCounter + 1; ErrorFB := 'MC_MoveVelocity';  END_IF
	IF pAxisCtrl.Command.Move.GearIn    THEN iActualCommandsCounter := iActualCommandsCounter + 1; ErrorFB := 'MC_GearIn';        END_IF
	IF pAxisCtrl.Command.Move.GearOut   THEN iActualCommandsCounter := iActualCommandsCounter + 1; ErrorFB := 'MC_GearOut';       END_IF
	IF pAxisCtrl.Command.Move.Halt      THEN iActualCommandsCounter := iActualCommandsCounter + 1; ErrorFB := 'MC_Halt';          END_IF
	//We do not want to reset if we are OK, for example in StandStill
	//IF pAxisCtrl.Command.Reset          THEN iActualCommandsCounter := iActualCommandsCounter + 1; ErrorFB := 'MC_Reset';         END_IF
	IF iActualCommandsCounter > 0 THEN
		ResetMotionCommands;
		(* In order not to get an error message, the following section can be commented out *)
		ErrorID := 29207;
		ErrorSource := ERR_SRC_TASK;
		ClearErrorTexts;
		ErrorText[0] := 'This command is currently not allowed';
		ErrorText[1] := CONCAT('PLCopen_FB: ', ErrorFB);
		ErrorText[2] := 'Check application code and timing';
		AxisErrorState := AX_ERR_STATE_APP_ERROR;
		(* If desired, the following section can be uncommented to stop the axis as well *)
		//QuickStop;
		//AxisState := AX_STATE_UNKNOWN;
	END_IF
    
    
    
	(************************************************************************************)
	(* PLCopen STATE SUPERVISOR                                                         *)
	(************************************************************************************)
	(* Whenever an agent outside this program (e.g. the Test Window) would perform a    *)
	(* command that would cause a state change or whenever an unexpected error would    *)
	(* occur, this state supervisor would find the resulting axis state.                *)
	(************************************************************************************)
    
	StateSupervisor;
    
    
    
	(************************************************************************************)
	(* ERROR HANDLING                                                                   *)
	(************************************************************************************)
    
	CASE AxisErrorState OF
        
		(****************************** WAIT FOR ERRORS *********************************)
		AX_ERR_STATE_WAIT: (* STATE: Waits for errors *)
            
			(* Checks if there is an axis-error (ACP10 >= V2.26.0 ckecks PLCOpen errors as well) *)
			IF ((MC_ReadAxisError_0.AxisErrorCount > 0) AND (MC_ReadAxisError_0.Valid = TRUE)) THEN
				AxisErrorState := AX_ERR_STATE_AXIS_ERROR;
			ELSIF MC_ReadAxisError_0.Error THEN
				(* The error texts are manually assigned because the FB does not work in this case *)
				ErrorID := MC_ReadAxisError_0.ErrorID;
				ErrorSource := ERR_SRC_TASK;
				ClearErrorTexts;
				ErrorText[2] := 'PLCopen_FB: MC_ReadAxisError';
				IF MC_ReadAxisError_0.ErrorID = 29489 THEN
					ErrorText[0] := 'Internal values of the axis structure are invalid';
					ErrorText[1] := 'A restart of the PLC is necessary';
				ELSIF MC_ReadAxisError_0.ErrorID = 29200 THEN
					ErrorText[0] := 'The axis object is invalid';
					ErrorText[1] := 'Check that the axis name is correctly defined';
				ELSE
					ErrorText[0] := 'Not able to determine error text';
					ErrorText[1] := 'Check Error Text Table';
				END_IF
				AxisErrorState := AX_ERR_STATE_APP_ERROR;
			ELSE (* If there is no error *)
				pAxisCtrl.Command.ErrorAcknowledge := FALSE; (* The acknowledge command is reset *)
			END_IF
            
			(***************************** APPLICATION ERROR ********************************)
		AX_ERR_STATE_APP_ERROR: (* STATE: Non-axis Error occurred *)
            
			(* Acknowledges error *)
			IF pAxisCtrl.Command.ErrorAcknowledge THEN
				pAxisCtrl.Command.ErrorAcknowledge := FALSE;
				ErrorID := 0;
				ErrorSource := ERR_SRC_NO_ERROR;
				ClearErrorTexts;
				AxisErrorState := AX_ERR_STATE_WAIT;
			END_IF
            
			(******************************** AXIS-ERROR ************************************)
		AX_ERR_STATE_AXIS_ERROR: (* STATE: Axis Error *)
            
			IF MC_ReadAxisError_0.Valid THEN
				(* Copies the error information to the ctrl structure *)
				IF (MC_ReadAxisError_0.AxisErrorCount > 0) THEN
					ErrorID := MC_ReadAxisError_0.AxisErrorID;
					IF (ErrorID >= 29000) AND (ErrorID <= 29999) THEN
						ErrorSource := ERR_SRC_PLC_OPEN;
					ELSE
						ErrorSource := ERR_SRC_ACP10;
					END_IF
					ErrorText := ErrorTextFB;
					(* Acknowledges axis error *)
					IF MC_ReadAxisError_0.Acknowledge = FALSE THEN
						IF pAxisCtrl.Command.ErrorAcknowledge THEN
							pAxisCtrl.Command.ErrorAcknowledge := FALSE;
							MC_ReadAxisError_0.Acknowledge := TRUE;
							(* If there is an EnDat encoder error, reset it *)
							IF (ErrorID = 39010) OR (ErrorID = 39024) THEN
								(* If configured, make the permanent encoder data invalid bacause the multiturn position could be wrong *)
								IF AdrEncoderData <> 0 THEN
									(* If no battery buffered encoder is used, the following line can be commented out, so that the absolute position is not lost *)
									memset(AdrEncoderData, 0, SIZEOF(MC_ENDLESS_POSITION));
								END_IF
								AxisErrorState := AX_ERR_STATE_ENCODER_RESET;
							END_IF
						END_IF
					ELSE
						MC_ReadAxisError_0.Acknowledge := FALSE;
					END_IF
					(* If there are no more errors *)
				ELSE
					ErrorID := 0;
					ErrorSource := ERR_SRC_NO_ERROR;
					ClearErrorTexts;
					AxisErrorState := AX_ERR_STATE_WAIT;
					(* In case it is necessary, the axis is reset as well, to mantain backwards compatibility *)
					IF MC_ReadStatus_0.Errorstop THEN
						Reset;
						AxisState := AX_STATE_UNKNOWN;
					END_IF
				END_IF
			END_IF
            
			(******************************** ENCODER-RESET ************************************)
		AX_ERR_STATE_ENCODER_RESET: (* STATE: Reset Encoder Error *)
            
			MC_BR_WriteParIDText_EncReset.ParID := ACP10PAR_ENCOD_CMD;
			MC_BR_WriteParIDText_EncReset.DataText := '1';
			MC_BR_WriteParIDText_EncReset.Execute := TRUE;
			IF MC_BR_WriteParIDText_EncReset.Done OR MC_BR_WriteParIDText_EncReset.Error THEN
				MC_BR_WriteParIDText_EncReset.Execute := FALSE;
				AxisErrorState := AX_ERR_STATE_AXIS_ERROR;
			END_IF
            
	END_CASE
    
    
	IF pAxisCtrl.Command.ErrorAcknowledge AND MC_ReadAxisError_0.ErrorID=6023 THEN
		MC_ReadAxisError_0.Acknowledge := TRUE;
		pAxisCtrl.Command.ErrorAcknowledge := FALSE;
	END_IF
	
	
    
	(************************************************************************************)
	(* FBK CALLS for axis handling. EXACTLY ONE PER CYCLE                               *)
	(************************************************************************************)
    
	(* PLCopen FBKs are onlly called once the axis has beed referenced with the ncaccess *)
	IF AxisRefDone THEN
        
		(************************** MC_POWER ****************************)
		PowerStatusOld := MC_Power_0.Status;
		MC_Power_0.Axis := AxisRef;
		MC_Power_0();
        
		(************************** MC_HOME *****************************)
		MC_Home_0.Axis := AxisRef;
		MC_Home_0();
        
		(********************** MC_MOVEABSOLUTE *************************)
		MC_MoveAbsolute_0.Axis := AxisRef;
		MC_MoveAbsolute_0();
        
		MC_MoveAbsolute_1.Axis := AxisRef;
		MC_MoveAbsolute_1();
        
		(********************** MC_MOVEADDITIVE *************************)
		MC_MoveAdditive_0.Axis := AxisRef;
		MC_MoveAdditive_0();
        
		MC_MoveAdditive_1.Axis := AxisRef;
		MC_MoveAdditive_1();
        
		(********************** MC_MOVEVELOCITY *************************)
		MC_MoveVelocity_0.Axis := AxisRef;
		MC_MoveVelocity_0();
        
		MC_MoveVelocity_1.Axis := AxisRef;
		MC_MoveVelocity_1();
        
		(********************** MC_GEARIN *************************)
		MC_GearIn_0.Slave := AxisRef;
		MC_GearIn_0.Master := MasterRef;
		MC_GearIn_0();
        
		MC_GearIn_1.Slave := AxisRef;
		MC_GearIn_1.Master := MasterRef;
		MC_GearIn_1();
        
		(********************** MC_GEAROUT *************************)
		MC_GearOut_x.Slave := AxisRef;
		MC_GearOut_x();
		
		(************************** MC_HALT *****************************)
		MC_Halt_0.Axis := AxisRef;
		MC_Halt_0();
        
		MC_Halt_1.Axis := AxisRef;
		MC_Halt_1();
        
		(************************** MC_STOP *****************************)
		MC_Stop_0.Axis := AxisRef;
		MC_Stop_0();
        
		(************************** MC_RESET ****************************)
		MC_Reset_0.Axis := AxisRef;
		MC_Reset_0();
		IF MC_Reset_0.Error OR MC_Reset_0.Done THEN
			MC_Reset_0.Execute := FALSE;
		END_IF
        
		(*********************** MC_SETOVERRIDE *************************)
		MC_SetOverride_0.Axis := AxisRef;
		MC_SetOverride_0.Enable := NOT(MC_SetOverride_0.Error) AND MC_ReadStatus_0.Valid AND
									(MC_ReadStatus_0.DiscreteMotion OR MC_ReadStatus_0.ContinuousMotion);
		pAxisCtrl.Parameter.Override.Speed 			:= LIMIT(0.01, pAxisCtrl.Parameter.Override.Speed,  2);
		pAxisCtrl.Parameter.Override.Acceleration 	:= LIMIT(0.01, pAxisCtrl.Parameter.Override.Acceleration, 2);
		MC_SetOverride_0.VelFactor := pAxisCtrl.Parameter.Override.Speed;
		MC_SetOverride_0.AccFactor := pAxisCtrl.Parameter.Override.Acceleration;
		MC_SetOverride_0();
        
		(***************** MC_BR_INITENDLESSPOSITION ********************)
		MC_BR_InitEndlessPosition_0.Axis := AxisRef;
		MC_BR_InitEndlessPosition_0();
        
		(***************** MC_BR_WRITEPARIDTEXT ********************)
		MC_BR_WriteParIDText_EncReset.Axis := AxisRef;
		MC_BR_WriteParIDText_EncReset();
        
		(* Example: transfer a cam profile to the ACOPOS ************************************)
		(******************* To enable the FB call, add an ')' after the following asterisk *
		MC_BR_DownloadCamProfileObj_0.Axis := AxisRef;
		MC_BR_DownloadCamProfileObj_0();
		(************************************************************************************)
        
	END_IF
    
    
    
	(************************************************************************************)
	(* PROVIDES STATUS                                                                  *)
	(************************************************************************************)
    
	(* PLCopen State *)
	IF MC_ReadStatus_0.Valid THEN
		(* Provide consistent information for virtual axis as if it were not virtual *)
		IF AxisIsVirtual THEN
			pAxisCtrl.Status.PLCopenState.Disabled          := MC_ReadStatus_0.Disabled OR MC_ReadStatus_0.StandStill AND NOT(pAxisCtrl.Command.Power);
			pAxisCtrl.Status.PLCopenState.StandStill        := MC_ReadStatus_0.StandStill AND pAxisCtrl.Command.Power;
		ELSE
			pAxisCtrl.Status.PLCopenState.Disabled          := MC_ReadStatus_0.Disabled;
			pAxisCtrl.Status.PLCopenState.StandStill        := MC_ReadStatus_0.StandStill;
		END_IF
		pAxisCtrl.Status.PLCopenState.Stopping              := MC_ReadStatus_0.Stopping;
		pAxisCtrl.Status.PLCopenState.Homing                := MC_ReadStatus_0.Homing;
		pAxisCtrl.Status.PLCopenState.DiscreteMotion        := MC_ReadStatus_0.DiscreteMotion;
		pAxisCtrl.Status.PLCopenState.ContinuousMotion      := MC_ReadStatus_0.ContinuousMotion;
		pAxisCtrl.Status.PLCopenState.SynchronizedMotion    := MC_ReadStatus_0.SynchronizedMotion;
		pAxisCtrl.Status.PLCopenState.ErrorStop             := MC_ReadStatus_0.Errorstop;
	END_IF
    
	(* Actual Position *)
	IF HomeValid AND DriveStatusFB.HomingOk THEN
		IF MC_ReadActualPosition_0.Valid THEN
			pAxisCtrl.Status.ActPosition := MC_ReadActualPosition_0.Position;
		END_IF
	ELSE
		(* To avoid confusions, shows NaN if the actual position cannot be trusted *)
		memcpy(ADR(pAxisCtrl.Status.ActPosition), ADR(NAN_VALUE_UDINT), SIZEOF(pAxisCtrl.Status.ActPosition));
	END_IF
    
	(* Actual Speed *)
	IF MC_ReadActualVelocity_0.Valid THEN
		pAxisCtrl.Status.ActVelocity := MC_ReadActualVelocity_0.Velocity;
	END_IF

	(* Actual Torque *)
	IF MC_ReadActualTorque_0.Valid THEN
		pAxisCtrl.Status.ActTorque := MC_ReadActualTorque_0.Torque;
	END_IF

	(* Error Information *)
	IF AxisRefDone AND (MasterRefDone OR NOT MasterUsed) THEN
		pAxisCtrl.Status.ErrorID := ErrorID;
		pAxisCtrl.Status.ErrorSource := ErrorSource;
		pAxisCtrl.Status.ErrorText := ErrorText;
	ELSE
		pAxisCtrl.Status.ErrorID := InitErrorID;
		pAxisCtrl.Status.ErrorSource := InitErrorSource;
		pAxisCtrl.Status.ErrorText := InitErrorText;
	END_IF
    
	(* Additional Information *)
	pAxisCtrl.Status.InitDone := InitDone AND DriveStatusFB.NetworkInit;
	pAxisCtrl.Status.PowerOn := PowerStatusOld;
	pAxisCtrl.Status.HomeOK := HomeValid AND DriveStatusFB.HomingOk;
	pAxisCtrl.Status.InPosition := InPosition;
    pAxisCtrl.Status.InGear := InGear;	
	pAxisCtrl.Status.ControllerReady := DriveStatusFB.ControllerReady;
    
	(* Digital input status *)
	pAxisCtrl.Status.DigitalInputs.Enable           := DriveStatusFB.DriveEnable;
	pAxisCtrl.Status.DigitalInputs.NegLimSwitch     := DriveStatusFB.NegHWSwitch;
	pAxisCtrl.Status.DigitalInputs.PosLimSwitch     := DriveStatusFB.PosHWSwitch;
	pAxisCtrl.Status.DigitalInputs.RefSwitch        := DriveStatusFB.HomeSwitch;
	pAxisCtrl.Status.DigitalInputs.Trigger1         := DriveStatusFB.Trigger1;
	pAxisCtrl.Status.DigitalInputs.Trigger2         := DriveStatusFB.Trigger2;
	
	// After all tasks, incr and sanity check
	gIndexAxisCtrl := gIndexAxisCtrl + 1;
	
END_PROGRAM
