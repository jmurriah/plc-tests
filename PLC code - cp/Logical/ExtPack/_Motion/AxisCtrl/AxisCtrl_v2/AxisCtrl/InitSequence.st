(********************************************************************
 * COPYRIGHT - B&R Spain
 ********************************************************************
 * PROGRAM: AxisCtrlTRUE
 * File: InitSequence.st
 * Author: B&R Spain
 * Created: September 19, 2013
 * Modified: February 17, 2016
 ********************************************************************
 * Implementation of action InitSequence
 ********************************************************************)

ACTION InitSequence:
	
	IF EDGEPOS( NOT DriveStatusFB.NetworkInit) THEN
		InitStep := 0;
		InitDone := FALSE;
		MC_BR_WriteParID_30(Axis := AxisRef, Execute := FALSE);
		MC_BR_WriteParID_31(Axis := AxisRef, Execute := FALSE);
		MC_BR_WriteParID_32(Axis := AxisRef, Execute := FALSE);
		MC_BR_WriteParID_33(Axis := AxisRef, Execute := FALSE);
		MC_BR_WriteParID_34(Axis := AxisRef, Execute := FALSE);
		MC_BR_WriteParID_35(Axis := AxisRef, Execute := FALSE);
		MC_BR_WriteParID_36(Axis := AxisRef, Execute := FALSE);
		MC_BR_WriteParID_37(Axis := AxisRef, Execute := FALSE);
		MC_BR_WriteParID_38(Axis := AxisRef, Execute := FALSE);
		MC_BR_WriteParID_39(Axis := AxisRef, Execute := FALSE);
		MC_BR_WriteParID_40(Axis := AxisRef, Execute := FALSE);
		MC_BR_WriteParID_41(Axis := AxisRef, Execute := FALSE);
		MC_BR_WriteParID_42(Axis := AxisRef, Execute := FALSE);
		MC_BR_WriteParID_43(Axis := AxisRef, Execute := FALSE);
		MC_BR_WriteParID_44(Axis := AxisRef, Execute := FALSE);
		MC_BR_WriteParID_45(Axis := AxisRef, Execute := FALSE);
	END_IF;
	
    CASE InitStep OF
        
        0: (* Set default parameters *)

			pAxisCtrl.Parameter.Override.Speed           := 1.0;    		(* multiplication factor for override velocity *)
			pAxisCtrl.Parameter.Override.Acceleration    := 1.0;     		(* multiplication factor for override acceleration *)

			
            InitStep := 10;
            
        10: (* Get ACP10 axis reference *)
            
			//StatusNcAccess := ncaccess(ncACP10MAN, ADR(AxisName), ADR(AxisRef));  //This is the original code
			AxisName:=pAxisCtrl.Parameter.Init.AxisObjectName;
			StatusNcAccess := ncaccess(ncACP10MAN, ADR(AxisName), ADR(AxisRef));			
            IF StatusNcAccess = 0 THEN
                AxisRefDone := TRUE;
                InitErrorID := 0;
                InitErrorSource := ERR_SRC_NO_ERROR;
                InitErrorText[0] := '';
                InitErrorText[1] := '';
                InitStep := 11;
            ELSE
                InitErrorID := 29200;
                InitErrorSource := ERR_SRC_TASK;
                InitErrorText[0] := 'The axis object is invalid';
                InitErrorText[1] := 'AxisName in the References.st file must match the one in the NC mapping';
            END_IF
            
        11: (* Determine if axis is real or virtual *)
            
            pACP10AXIS ACCESS AxisRef;
            pACP10VAXIS ACCESS AxisRef;
            IF pACP10AXIS.nc_obj_inf.nc_obj_typ = ncAXIS THEN
                AxisIsVirtual := FALSE;
            ELSIF pACP10VAXIS.nc_obj_inf.nc_obj_typ = ncV_AXIS THEN
                AxisIsVirtual := TRUE;
            END_IF
			InitStep := 12;
            
		12: (* Get ACP10 master axis reference *)
            
			MasterName:=pAxisCtrl.Parameter.Init.MasterGearObjectName;
			IF MasterName <> '' THEN
				StatusNcAccess := ncaccess(ncACP10MAN, ADR(MasterName), ADR(MasterRef));
				MasterUsed := TRUE;
				IF StatusNcAccess = 0 THEN
					MasterRefDone := TRUE;
					InitErrorID := 0;
					InitErrorSource := ERR_SRC_NO_ERROR;
					InitErrorText[0] := '';
					InitErrorText[1] := '';
					InitStep := 20;
				ELSE
					InitErrorID := 29200;
					InitErrorSource := ERR_SRC_TASK;
					InitErrorText[0] := 'The axis object is invalid';
					InitErrorText[1] := 'MasterName in the References.st file must match the one in the NC mapping';
				END_IF
			ELSE (* If master axis is not specified, the EngageToMaster command will not be available *)
				MasterUsed := FALSE;
				InitStep := 20;
			END_IF
            
        20: (* Init endless position (for MC_HOME_RESTORE_POS mode) *)
            
            IF AdrEncoderData <> 0 THEN
                IF MC_ReadStatus_0.Disabled OR MC_ReadStatus_0.StandStill THEN
                    MC_BR_InitEndlessPosition_0.Execute := TRUE;
                    MC_BR_InitEndlessPosition_0.DataAddress := AdrEncoderData;
                    InitStep := 21;
                END_IF
            ELSIF DriveStatusFB.NetworkInit THEN (* If the address is not specified, the step is skipped and the MC_HOME_RESTORE_POS is not available *)
                InitStep := 30;
            END_IF
        21:             
            IF MC_BR_InitEndlessPosition_0.Done THEN
                MC_BR_InitEndlessPosition_0.Execute := FALSE;
                InitStep := 30;
            END_IF
            IF MC_BR_InitEndlessPosition_0.Error THEN
                MC_BR_InitEndlessPosition_0.Execute := FALSE;
                InitStep := 20;
            END_IF

			// ########################### SEND VELOCITY PARAMETERS ###########################	
		30:	
			IF pAxisCtrl.Parameter.Init.xSendVelParams THEN

				MC_BR_WriteParID_30(Axis := AxisRef, Execute := TRUE, ParID := ACP10PAR_AXLIM_V_POS, DataAddress := ADR(pAxisCtrl.Parameter.Init.rLimitVelPos), DataType := ncPAR_TYP_REAL);
				IF MC_BR_WriteParID_30.Done THEN
					InitStep := 31;
				END_IF
				
			ELSE
				InitStep := 31;				
			END_IF
		
		31:
			IF pAxisCtrl.Parameter.Init.xSendVelParams THEN

				MC_BR_WriteParID_31(Axis := AxisRef, Execute := TRUE, ParID := ACP10PAR_AXLIM_V_NEG, DataAddress := ADR(pAxisCtrl.Parameter.Init.rLimitVelNeg), DataType := ncPAR_TYP_REAL);
			
				IF MC_BR_WriteParID_31.Done THEN
					InitStep := 32;
				END_IF				
			
			ELSE
				InitStep := 32;
			END_IF

			
		// ########################### SEND ACCELERATION PARAMETERS ###########################	
		32:
			IF pAxisCtrl.Parameter.Init.xSendAccParams THEN			

				MC_BR_WriteParID_32(Axis := AxisRef, Execute := TRUE, ParID := ACP10PAR_AXLIM_A1_POS, DataAddress := ADR(pAxisCtrl.Parameter.Init.rLimitAccPos), DataType := ncPAR_TYP_REAL);
				
				IF MC_BR_WriteParID_32.Done THEN
					InitStep := 33;
				END_IF	
			ELSE
				InitStep := 33;
			END_IF
			
		33:
			IF pAxisCtrl.Parameter.Init.xSendAccParams THEN			
			
				MC_BR_WriteParID_33(Axis := AxisRef, Execute := TRUE, ParID := ACP10PAR_AXLIM_A2_POS, DataAddress := ADR(pAxisCtrl.Parameter.Init.rLimitAccPos), DataType := ncPAR_TYP_REAL);
				
				IF MC_BR_WriteParID_33.Done THEN
					InitStep := 34;
				END_IF				

			ELSE
				InitStep := 34;
			END_IF
			
		34:
			IF pAxisCtrl.Parameter.Init.xSendAccParams THEN				
				
				MC_BR_WriteParID_34(Axis := AxisRef, Execute := TRUE, ParID := ACP10PAR_AXLIM_A1_NEG, DataAddress := ADR(pAxisCtrl.Parameter.Init.rLimitAccNeg), DataType := ncPAR_TYP_REAL);
				
				IF MC_BR_WriteParID_34.Done THEN
					InitStep := 35;
				END_IF	

			ELSE
				InitStep := 35;
			END_IF
								
		35:
			IF pAxisCtrl.Parameter.Init.xSendAccParams THEN	
				
				MC_BR_WriteParID_35(Axis := AxisRef, Execute := TRUE, ParID := ACP10PAR_AXLIM_A2_NEG, DataAddress := ADR(pAxisCtrl.Parameter.Init.rLimitAccNeg), DataType := ncPAR_TYP_REAL);
				
				IF MC_BR_WriteParID_35.Done THEN
					InitStep := 36;
				END_IF	
		
			ELSE
				InitStep := 36;
			END_IF
							
			// ########################### SEND EMERGENCY STOP PARAMETERS ###########################	
		36:
			IF pAxisCtrl.Parameter.Init.xSendAccEmergStopParams THEN	
			
				MC_BR_WriteParID_36(Axis := AxisRef, Execute := TRUE, ParID := ACP10PAR_LIM_A_SET_STOP, DataAddress := ADR(pAxisCtrl.Parameter.Init.rLimitAccStop), DataType := ncPAR_TYP_REAL);
				
				IF MC_BR_WriteParID_36.Done THEN
					InitStep := 37;
				END_IF	

			ELSE
				InitStep := 37;
			END_IF

			
			
			// ########################### SEND TORQUE PARAMETERS ###########################		
		37:
			IF pAxisCtrl.Parameter.Init.xSendTorqueParams THEN				

				MC_BR_WriteParID_37(Axis := AxisRef, Execute := TRUE, ParID := ACP10PAR_LIM_T1_POS, DataAddress := ADR(pAxisCtrl.Parameter.Init.rLimitTorquePos), DataType := ncPAR_TYP_REAL);
				
				IF MC_BR_WriteParID_37.Done THEN
					InitStep := 38;
				END_IF	
		
			ELSE
				InitStep := 38;
			END_IF
		
		38:
			IF pAxisCtrl.Parameter.Init.xSendTorqueParams THEN		
				
				MC_BR_WriteParID_38(Axis := AxisRef, Execute := TRUE, ParID := ACP10PAR_LIM_T1_NEG, DataAddress := ADR(pAxisCtrl.Parameter.Init.rLimitTorqueNeg), DataType := ncPAR_TYP_REAL);
				
				IF MC_BR_WriteParID_38.Done THEN
					InitStep := 39;
				END_IF	

			ELSE
				InitStep := 39;
			END_IF
			
		39:
			IF pAxisCtrl.Parameter.Init.xSendTorqueParams THEN		
						
				MC_BR_WriteParID_39(Axis := AxisRef, Execute := TRUE, ParID := ACP10PAR_LIM_T2_POS, DataAddress := ADR(pAxisCtrl.Parameter.Init.rLimitTorquePos), DataType := ncPAR_TYP_REAL);
				
				IF MC_BR_WriteParID_39.Done THEN
					InitStep := 40;
				END_IF

			ELSE
				InitStep := 40;
			END_IF		
		40:
			IF pAxisCtrl.Parameter.Init.xSendSwEndParams THEN		
			
				MC_BR_WriteParID_40(Axis := AxisRef, Execute := TRUE, ParID := ACP10PAR_LIM_T2_NEG, DataAddress := ADR(pAxisCtrl.Parameter.Init.rLimitTorqueNeg), DataType := ncPAR_TYP_REAL);
				
				IF MC_BR_WriteParID_40.Done THEN
					InitStep := 41;
				END_IF

			ELSE
				InitStep := 41;
			END_IF			

			// ########################### SEND SOFWARE END PARAMETERS ###########################	
		41:
			IF pAxisCtrl.Parameter.Init.xSendSwEndParams THEN		
			
				MC_BR_WriteParID_41(Axis := AxisRef, Execute := TRUE, ParID := ACP10PAR_AXLIM_POS_SW_END, DataAddress := ADR(pAxisCtrl.Parameter.Init.diLimitPosSwEnd), DataType := ncPAR_TYP_DINT);
				
				IF MC_BR_WriteParID_41.Done THEN
					InitStep := 42;
				END_IF

			ELSE
				InitStep := 42;
			END_IF			
			
		42:
			IF pAxisCtrl.Parameter.Init.xSendTorqueParams THEN		
			
				MC_BR_WriteParID_42(Axis := AxisRef, Execute := TRUE, ParID := ACP10PAR_AXLIM_NEG_SW_END, DataAddress := ADR(pAxisCtrl.Parameter.Init.diLimitNegSwEnd), DataType := ncPAR_TYP_DINT);
				
				IF MC_BR_WriteParID_42.Done THEN
					InitStep := 43;
				END_IF

			ELSE
				InitStep := 43;
			END_IF			
			
			// ########################### SEND HOMING PARAMETERS ###########################	
		43:
			IF pAxisCtrl.Parameter.Init.xSendHomingParams THEN		
			
				MC_BR_WriteParID_43(Axis := AxisRef, Execute := TRUE, ParID := ACP10PAR_HOMING_V_SWITCH, DataAddress := ADR(pAxisCtrl.Parameter.Init.rHomingVSwitch), DataType := ncPAR_TYP_REAL);
				
				IF MC_BR_WriteParID_43.Done THEN
					InitStep := 44;
				END_IF

			ELSE
				InitStep := 44;
			END_IF	
			
		44:
			IF pAxisCtrl.Parameter.Init.xSendHomingParams THEN		
			
				MC_BR_WriteParID_44(Axis := AxisRef, Execute := TRUE, ParID := ACP10PAR_HOMING_V_TRIGGER, DataAddress := ADR(pAxisCtrl.Parameter.Init.rHomingVTrigger), DataType := ncPAR_TYP_REAL);
				
				IF MC_BR_WriteParID_44.Done THEN
					InitStep := 45;
				END_IF

			ELSE
				InitStep := 45;
			END_IF	
			
		45:
			IF pAxisCtrl.Parameter.Init.xSendHomingParams THEN		
			
				MC_BR_WriteParID_45(Axis := AxisRef, Execute := TRUE, ParID := ACP10PAR_HOMING_A, DataAddress := ADR(pAxisCtrl.Parameter.Init.rHomingAcc), DataType := ncPAR_TYP_REAL);
				
				IF MC_BR_WriteParID_45.Done THEN
					InitStep := 46;
				END_IF

			ELSE
				InitStep := 46;
			END_IF	
			
			
			
			
        46: (* Add here more initialization steps if needed... (e.g. transfer cam to ACOPOS) *)
            
            (* When all the initializations are done, set the following flag *)
			InitDone := TRUE;

            
        99: (* Example: transfer a cam profile to the ACOPOS ************************************)
            (* To enable it, do the following steps                                             *)
            (* TODO: Define a cam profile in the Logical View and assign it to the PLC          *)
            (* TODO: Declare the corresponding variables                                        *)
            (* TODO: Add the corresponding FB call at the end OF the cyclic                     *)
            (* TODO: Remember to set the InitDone flag only after all init steps are done       *)
            (*************************************** and add a ')' after the following asterisk *
            MC_BR_DownloadCamProfileObj_0.Execute := TRUE;
            MC_BR_DownloadCamProfileObj_0.DataObjectName := 'CamProfile';
            MC_BR_DownloadCamProfileObj_0.Index := 1;
            MC_BR_DownloadCamProfileObj_0.Periodic := FALSE;
            InitStep := 41;
        41: 
            IF MC_BR_DownloadCamProfileObj_0.Done THEN
                MC_BR_DownloadCamProfileObj_0.Execute := FALSE;
                InitStep := 50;
            END_IF
            IF MC_BR_DownloadCamProfileObj_0.Error THEN
                MC_BR_DownloadCamProfileObj_0.Execute := FALSE;
                InitStep := 40;
            END_IF
            (************************************************************************************)
            
            
        (************************************************************************************)
        (* In case a minimum or specific ACP10 version would be necessary, this shows how   *)
        (* to detect the ACP10 version from the program:                                    *)
        (* pAxisACP10.sw_version.nc_manager = 16#ABCD <-> ACP10 VA.BC.D                     *)
        (* e.g. 16#2260 <-> V2.26.0                                                         *)
        (* Note that pAxisACP10 must be a pointer to ACP10AXIS_typ or ACP10VAXIS_typ depen- *)
        (* ding on whether the axis is real or virtual.                                     *)
        (************************************************************************************)
            
    END_CASE
    
END_ACTION
