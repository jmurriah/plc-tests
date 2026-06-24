
ACTION GenInverterCtrl: 

(********************************************************************************
*********************************************************************************
	
	INFORMATION OF POWERLINK DEVICES
	
	EXAMPLE Program for Handling of a P74 Inverter
	Task: I74Ctrl Program

	<|> Structure to handle the axis:
	
		Name								Format		Type		Description
		---------------------------------------------------------------------------------------------------------
		dataInv.Orders.PowerOn				| BOOL		| Command	| Switches the power on
		dataInv.Commands.MovePositive		| BOOL		| Command	| Starts a movement in the positive direction
		dataInv.Commands.MoveNegative		| BOOL		| Command	| Starts a movement in the negative direction
		dataInv.Commands.Stop				| BOOL		| Command	| Stops the axis
		dataInv.Commands.Reset				| BOOL		| Command	| Acknowledges and quits all errors
		dataInv.Parameters.Velocity		| INT		| Parameter	| Set speed
		dataInv.Parameters.AccelerationTime			| UINT		| Parameter	| Set acceleration time
		dataInv.Parameters.DecelerationTime			| UINT		| Parameter	| Set deceleration time
		dataInv.Status.ActVelocity			| INT		| Status	| Actual speed
		dataInv.Status.ActCurrent			| UINT		| Status	| Actual current
		dataInv.Status.ActTorque			| UINT		| Status	| Actual torque
		dataInv.DigitalInput		| BOOL[8]	| Status	| Digital Inputs of the inverter [0...7]
		dataInv.DigitalOutput		| BOOL[3]	| Status	| Digital Outputs of the inverter [0...2]
		dataInv.AnalogInput			| INT[3]	| Status	| Analog Inputs of the inverter [0...2]
		dataInv.AnalogOutput		| UINT		| Status	| Analog Output of the inverter
		dataInv.Status.ErrorID				| UINT		| Status	| Error number
		dataInv.Status.ErrorText			| STRING[9]	| Status	| Error description
		dataInv.Status.StatusDisabled		| BOOL		| Status	| The inverter is switched off
		dataInv.Status.StatusReady			| BOOL		| Status	| The inverter is ready to perform a movement
		dataInv.Status.StatusOperation		| BOOL		| Status	| The motor is powered
		dataInv.Status.StatusErrorStop		| BOOL		| Status	| The inverter has some error


	<|> Variables that need to be mapped in the IO Mapping of the Inverter:
	
		IO Point		Format		Local Variable			Addtitional
		----------------------------------------------------------------
		ModuleOk		| BOOL		| ioMap.In.ModuleOk		| Compulsory
		ETAD_Input		| UINT		| ioMap.In.StatusWord		| Compulsory
		RFRD_Input		| INT		| ioMap.In.ActualSpeed		| Optional
		LCR_Input		| UINT		| ioMap.In.ActualCurrent	| Optional
		OTRN_Input		| UINT		| ioMap.In.ActualTorque	| Optional
		LFT_Input		| INT		| ioMap.In.ErrorID			| Optional
		CMDD_Output		| UINT		| ioMap.Out.ControlWord		| Compulsory
		LFRD_Output		| INT		| ioMap.In.SetSpeed		| Compulsory
		IL1R_Input_DI1	| BOOL		| ioMap.In.DigitalInput[0]	| Optional
		IL1R_Input_DI2	| BOOL		| ioMap.In.DigitalInput[1]	| Optional
		IL1R_Input_DI3	| BOOL		| ioMap.In.DigitalInput[2]	| Optional
		IL1R_Input_DI4	| BOOL		| ioMap.In.DigitalInput[3]	| Optional
		IL1R_Input_DI5	| BOOL		| ioMap.In.DigitalInput[4]	| Optional
		IL1R_Input_DI6	| BOOL		| ioMap.In.DigitalInput[5]	| Optional
		IL1R_Input_DAI1	| BOOL		| ioMap.In.DigitalInput[6]	| Optional
		IL1R_Input_DAI2	| BOOL		| ioMap.In.DigitalInput[7]	| Optional
		OL1R_Output_R1	| BOOL		| ioMap.In.DigitalOutput[0]| Optional
		OL1R_Output_R2	| BOOL		| ioMap.In.DigitalOutput[1]| Optional
		OL1R_Output_RDQ1| BOOL		| ioMap.In.DigitalOutput[2]| Optional
		AI1R_Input		| INT		| ioMap.In.AnalogInput[0]	| Optional
		AI2R_Input		| INT		| ioMap.In.AnalogInput[1]	| Optional		
		AI3R_Input		| INT		| ioMap.In.AnalogInput[2]	| Optional
		AO1R_Output		| UINT		| ioMap.In.AnalogOutput	| Optional
	
*********************************************************************************)

	
(********************************************************************************
*********************************************************************************

	INFORMATION OF CANOPEN DEVICES
	
	EXAMPLE Program for Handling of a X64 Inverter
	Task: I66Ctrl Program
	(c) 2010 by B&R-ES

	<|> Structure to handle the axis:
	
		Name								Format		Type		Description
		---------------------------------------------------------------------------------------------------------
		gAxisInverter01.PowerOn				| BOOL		| Command	| Switches the power on
		gAxisInverter01.MovePositive		| BOOL		| Command	| Starts a movement in the positive direction
		gAxisInverter01.MoveNegative		| BOOL		| Command	| Starts a movement in the negative direction
		gAxisInverter01.Stop				| BOOL		| Command	| Stops the axis as configured in FUN->STC->STT (Default: RMP)
		gAxisInverter01.Reset				| BOOL		| Command	| Acknowledges and quits all errors
		gAxisInverter01.ParaVelocity		| INT		| Parameter	| Set speed [rpm]
		gAxisInverter01.ParaAccTime			| UINT		| Parameter	| Set acceleration time [s]
		gAxisInverter01.ParaDecTime			| UINT		| Parameter	| Set deceleration time [s]
		gAxisInverter01.ActVelocity			| INT		| Status	| Actual speed [rpm]
		gAxisInverter01.ActCurrent			| REAL		| Status	| Actual current [A]
		gAxisInverter01.ActTorque			| REAL		| Status	| Actual torque [Nm]
		gAxisInverter01.ErrorID				| UINT		| Status	| Error number
		gAxisInverter01.ErrorText			| STRING[9]	| Status	| Error description
		gAxisInverter01.StatusDisabled		| BOOL		| Status	| The inverter is switched off
		gAxisInverter01.StatusReady			| BOOL		| Status	| The inverter is ready to perform a movement
		gAxisInverter01.StatusOperation		| BOOL		| Status	| The motor is powered
		gAxisInverter01.StatusErrorStop		| BOOL		| Status	| The inverter has some error
		gAxisInverter01.DigitalInput[0..5]	| BOOL		| Input		| Digital inputs
		gAxisInverter01.DigitalOutput		| BOOL		| Output	| Digital Output
		gAxisInverter01.AnalogInput[0..2]	| INT		| Input		| Analog inputs
		gAxisInverter01.DigitalOutput		| UINT		| Output	| Analog Output

	<|> Variables that need to be mapped in the IO Mapping of the Inverter:
	
		IO Point		Format		Local Variable			Addtitional
		----------------------------------------------------------------
		ModuleOk		| BOOL		| ioMap.ModuleOk		| Compulsory
		ETAD_Input		| UINT		| ioMap.StatusWord		| Compulsory
		RFRD_Input		| INT		| ioMap.ActualSpeed		| Compulsory
		LCR_Input		| UINT		| ioMap.ActualCurrent	| Optional
		LFT_Input		| INT		| ioMap.ErrorID			| Optional
		CMDD_Output		| UINT		| ioMap.ControlWord		| Compulsory
		LFRD_Output		| INT		| ioMap.SetSpeed		| Compulsory


	EXAMPLE Program FOR Handling OF a ABB ACS380	Task: ACS380 Program

		<|> Structure TO handle the axis:
	
		Name								Format		Type		Description
		---------------------------------------------------------------------------------------------------------
		gAxisInverter01.PowerOn				| BOOL		| Command	| Switches the power on
		gAxisInverter01.MovePositive		| BOOL		| Command	| Starts a movement in the positive direction
		gAxisInverter01.MoveNegative		| BOOL		| Command	| Starts a movement in the negative direction
		gAxisInverter01.Stop				| BOOL		| Command	| Stops the axis
		gAxisInverter01.Reset				| BOOL		| Command	| Acknowledges AND quits all errors
		gAxisInverter01.ControlMode			| UINT		| Parameter	| Chose control mode. 0 = VECTOR // 1 = SCALAR
		gAxisInverter01.ParaVelocity		| INT		| Parameter	| Set speed
		gAxisInverter01.ParaAccTime			| UINT		| Parameter	| Set acceleration time
		gAxisInverter01.ParaDecTime			| UINT		| Parameter	| Set deceleration time
		gAxisInverter01.ActVelocity			| INT		| Status	| Actual speed
		gAxisInverter01.ActCurrent			| UINT		| Status	| Actual current
		gAxisInverter01.ErrorID				| UINT		| Status	| Error number
		gAxisInverter01.ErrorText			| STRING[9]	| Status	| Error description
		gAxisInverter01.StatusDisabled		| BOOL		| Status	| The inverter is switched off
		gAxisInverter01.StatusReady			| BOOL		| Status	| The inverter is ready TO perform a movement
		gAxisInverter01.StatusOperation		| BOOL		| Status	| The motor is powered
		gAxisInverter01.StatusErrorStop		| BOOL		| Status	| The inverter has some error


		<|> Variables that need TO be mapped in the IO Mapping OF the Inverter:
	
		IO Point									Format		Local Variable			Addtitional
		-------------------------------------------------------------------------------------------------------------
		ModuleOk									| BOOL		| ioMap.ModuleOk		| Compulsory
		ABBSW_I2104									| UINT		| ioMap.StatusWord		| Compulsory
		ABBAct1_I2104								| INT		| ioMap.ActualSpeed		| Optional
		CurrentActualValue_I6078					| INT		| ioMap.ActualCurrent	| Optional
		ErrorCode_I603F								| UINT		| ioMap.ErrorID			| Optional
		ABBCW_I2101Out								| UINT		| ioMap.ControlWord		| Compulsory
		ABBRef1_I21012Out							| INT		| ioMap.SetSpeed		| Compulsory
		ABBRef1_I21013Out							| INT		| ioMap.SetFrequency	| Compulsory
		_9904_Motor_control_mode_I4060_S08Out		| UINT		| ioMap.ControlMode		| Optional
		_5004_FBA_A_ref1_type_I4032_S04Out			| UINT		| ioMap.SpeedUnit		| Compulsory
		_2312_Acceleration_time_1_I4017_S0COut		| DUINT		| ioMap.AccTimeVector	| Compulsory
		_2313_Deceleration_time_1_I4017_S0DOut		| DUINT		| ioMap.DecTimeVector	| Compulsory
		_2872_Freq_acceleration_time_1_I401C_S48Out	| DUINT		| ioMap.AccTimeScalar	| Compulsory
		_2873_Freq_deceleration_time_1_I401C_S49Out	| DUINT		| ioMap.DecTimeScalar	| Compulsory
		

		*********************************************************************************)
	
		
	(* Module Information *)
	PL_device := dataInv.Parameters.Hardware.PowerLinkInterface; 	// (* Powerlink interface *)  originally 'SL1.IF3'; 	
	HW_node := dataInv.Parameters.Hardware.Node; 					// (* Powerlink station (node number of the inverter) *) originally 2;
	
	
(********************************************************************
	Parameter Transfer: ACC, DEC (valid for P66)
*********************************************************************)
		
	IF ioMap.In.ModuleOk AND dataInv.Parameters.CommsType = COMMS_POWERLINK THEN
		IF dataInv.Parameters.Type = INV_ABB THEN
			(* Control mode setting with the correct units *)
			ioMap.Out.ControlMode	:= dataInv.Parameters.ControlMode;
	
			IF dataInv.Parameters.ControlMode = CONTROL_MODE_VECTOR THEN
				ioMap.Out.SpeedUnit		:= 4; // 4 = Control by Speed
				ioMap.Out.AccTimeVector	:= REAL_TO_DINT(dataInv.Parameters.AccelerationTime);
				ioMap.Out.DecTimeVector	:= REAL_TO_DINT(dataInv.Parameters.DecelerationTime);	
				ioMap.Out.SetSpeed		:= UINT_TO_INT(dataInv.Parameters.Velocity) * direction;
			ELSIF dataInv.Parameters.ControlMode = CONTROL_MODE_SCALAR THEN
				ioMap.Out.SpeedUnit		:= 5; // 5 = Control by Speed
				ioMap.Out.AccTimeScalar	:= REAL_TO_DINT(dataInv.Parameters.AccelerationTime * RAMP_MAX_HZ_VALUE / (dataInv.Parameters.Velocity * 100.0));
				ioMap.Out.DecTimeScalar	:= REAL_TO_DINT(dataInv.Parameters.DecelerationTime * RAMP_MAX_HZ_VALUE / (dataInv.Parameters.Velocity * 100.0));
				ioMap.Out.SetFrequency	:= UINT_TO_INT(dataInv.Parameters.Velocity * 100) * direction;
			END_IF
			ACC_Ok := TRUE;
			DEC_Ok := TRUE;
		ELSE

			(* Acceleration *)	
			dataInv.Parameters.AccelerationTime := LIMIT(ACC_min, dataInv.Parameters.AccelerationTime, ACC_max);	(* Check value *)
			CASE stepTransferACC OF
				
				0: (* Read parameter *)
					
					EplSDORead_ACC.pDevice := ADR(PL_device);
					EplSDORead_ACC.node := HW_node;
					EplSDORead_ACC.index := 16#203C;
					EplSDORead_ACC.subindex := 16#02;
					EplSDORead_ACC.pData := ADR(AccTime_actual);
					EplSDORead_ACC.datalen := SIZEOF(AccTime_actual);
					EplSDORead_ACC.enable := TRUE;
					EplSDORead_ACC();
					IF EplSDORead_ACC.status = 0 THEN
						stepTransferACC := 1;
					ELSIF EplSDORead_ACC.status <> ERR_FUB_BUSY THEN
						invalidHwAddress := TRUE;
					END_IF
				
				1: (* Check change *)
					IF REAL_TO_UINT(dataInv.Parameters.AccelerationTime * 10) = AccTime_actual THEN
						ACC_Ok := TRUE;
					ELSE
						ACC_Ok := FALSE;
						AccTime_set := REAL_TO_UINT(dataInv.Parameters.AccelerationTime * 10);
						stepTransferACC := 2;
					END_IF
					
				2: (* Write parameter *)
					
					EplSDOWrite_ACC.pDevice := ADR(PL_device);
					EplSDOWrite_ACC.node := HW_node;
					EplSDOWrite_ACC.index := 16#203C;
					EplSDOWrite_ACC.subindex := 16#02;
					EplSDOWrite_ACC.pData := ADR(AccTime_set);
					EplSDOWrite_ACC.datalen := SIZEOF(AccTime_set);
					EplSDOWrite_ACC.enable := TRUE;
					EplSDOWrite_ACC();
					IF EplSDOWrite_ACC.status = 0 THEN
						stepTransferACC := 0;
					ELSIF EplSDOWrite_ACC.status <> ERR_FUB_BUSY THEN
						invalidHwAddress := TRUE;
					END_IF
					
			END_CASE
			
		
			(* Deceleration *)
			dataInv.Parameters.DecelerationTime := LIMIT(DEC_min, dataInv.Parameters.DecelerationTime, DEC_max);	(* Check value *)
			CASE stepTransferDEC OF
				
				0: (* Read parameter *)
					
					EplSDORead_DEC.pDevice := ADR(PL_device);
					EplSDORead_DEC.node := HW_node;
					EplSDORead_DEC.index := 16#203C;
					EplSDORead_DEC.subindex := 16#03;
					EplSDORead_DEC.pData := ADR(DecTime_actual);
					EplSDORead_DEC.datalen := SIZEOF(DecTime_actual);
					EplSDORead_DEC.enable := TRUE;
					EplSDORead_DEC();
					IF EplSDORead_DEC.status = 0 THEN
						stepTransferDEC := 1;
					ELSIF EplSDORead_DEC.status <> ERR_FUB_BUSY THEN
						invalidHwAddress := TRUE;
					END_IF
				
				1: (* Check change *)
					IF REAL_TO_UINT(dataInv.Parameters.DecelerationTime * 10) = DecTime_actual THEN
						DEC_Ok := TRUE;
					ELSE
						DEC_Ok := FALSE;
						DecTime_set := REAL_TO_UINT(dataInv.Parameters.DecelerationTime * 10);
						stepTransferDEC := 2;
					END_IF
					
				2: (* Write parameter *)
					
					EplSDOWrite_DEC.pDevice := ADR(PL_device);
					EplSDOWrite_DEC.node := HW_node;
					EplSDOWrite_DEC.index := 16#203C;
					EplSDOWrite_DEC.subindex := 16#03;
					EplSDOWrite_DEC.pData := ADR(DecTime_set);
					EplSDOWrite_DEC.datalen := SIZEOF(DecTime_set);
					EplSDOWrite_DEC.enable := TRUE;
					EplSDOWrite_DEC();
					IF EplSDOWrite_DEC.status = 0 THEN
						stepTransferDEC := 0;
					ELSIF EplSDOWrite_DEC.status <> ERR_FUB_BUSY THEN
						invalidHwAddress := TRUE;
					END_IF
					
			END_CASE
		
		END_IF;
	
	ELSIF dataInv.Parameters.CommsType = COMMS_CANOPEN THEN
		ACC_Ok := TRUE;
		DEC_Ok := TRUE;
	END_IF
	
	paramOk := ACC_Ok AND DEC_Ok;
	IF paramOk THEN
		invalidHwAddress := FALSE;
	END_IF	
	
(********************************************************************
	Simulation
*********************************************************************)	

	IF dataInv.Parameters.Hardware.CpuFamily = FAMILY_BRAUTOMATIONRUNTIME OR xForceSim THEN
		Simulation;
	END_IF;
	
(********************************************************************
	Control Handling
*********************************************************************)	
	
	(* Gets the status from the drive *)
	IF ioMap.In.ModuleOk AND (ioMap.In.StatusWord <> 0) AND NOT(connectionErrorNotAck) THEN
		IF ((ioMap.In.StatusWord AND 16#006F) = 16#0000) THEN
			axisStep := STATE_NOT_READY_TO_SWITCH_ON;
		ELSIF ((ioMap.In.StatusWord AND 16#004F) = 16#0040) THEN
			axisStep := STATE_SWITCH_ON_DISABLED;
		ELSIF ((ioMap.In.StatusWord AND 16#006F) = 16#0021) THEN
			axisStep := STATE_READY_TO_SWITCH_ON;
		ELSIF ((ioMap.In.StatusWord AND 16#006F) = 16#0023) THEN
			axisStep := STATE_SWITCHED_ON;
		ELSIF ((ioMap.In.StatusWord AND 16#006F) = 16#0027) THEN
			axisStep := STATE_OPERATION_ENABLED;
		ELSIF ((ioMap.In.StatusWord AND 16#006F) = 16#0007) THEN
			axisStep := STATE_QUICK_STOP_ACTIVE;
		ELSIF ((ioMap.In.StatusWord AND 16#004F) = 16#000F) THEN
			axisStep := STATE_FAULT_REACTION_ACTIVE;
		ELSIF ((ioMap.In.StatusWord AND 16#004F) = 16#0008) THEN
			axisStep := STATE_FAULT;
		ELSE 	(* Connection error or drive malfunction *)
			axisStep := STATE_ERROR;
		END_IF
	ELSE
		IF dataInv.Parameters.CommsType = COMMS_POWERLINK THEN
			ACC_Ok := FALSE;	(* The parameter might have changed *)
			stepTransferACC := 0;	(* Read parameter *)
			DEC_Ok := FALSE;	(* The parameter might have changed *)
			stepTransferDEC := 0;	(* Read parameter *)
			connectionErrorNotAck := TRUE;
		END_IF
		axisStep := STATE_ERROR;
		
	END_IF
	
	
	IF axisStep <> STATE_FAULT THEN
		IF axisStep <> STATE_ERROR THEN
			dataInv.Commands.Reset := FALSE;
		END_IF
		resetCount := 0;
	END_IF
	
	
	(* State machine *)
	CASE axisStep OF

(**************************** NOT READY ****************************)	
		STATE_NOT_READY_TO_SWITCH_ON:
		
			IF dataInv.Parameters.Type = INV_ABB THEN
				ioMap.Out.ControlWord := 16#0406;
			ELSE
				ioMap.Out.ControlWord := 16#0000;
			END_IF


(***************************** DISABLED ****************************)		
		STATE_SWITCH_ON_DISABLED:
			IF dataInv.Parameters.Type = INV_ABB THEN
				ioMap.Out.ControlWord := 16#0406;
			ELSE
				ioMap.Out.ControlWord := 16#0006;
			END_IF
		
		
(****************************** READY ******************************)		
		STATE_READY_TO_SWITCH_ON:

			IF (dataInv.Orders.PowerOn) THEN
				IF dataInv.Parameters.Type = INV_ABB THEN
					ioMap.Out.ControlWord := 16#0407;
				ELSE
					ioMap.Out.ControlWord := 16#0007;
				END_IF
			END_IF


(*************************** SWITCHED ON ***************************)		
		STATE_SWITCHED_ON:
			
			IF NOT(dataInv.Orders.PowerOn) THEN
				IF dataInv.Parameters.Type = INV_ABB THEN
					ioMap.Out.ControlWord := 16#0406;
				ELSE
					ioMap.Out.ControlWord := 16#0006;
				END_IF
			ELSIF paramOk THEN
				IF dataInv.Commands.Stop THEN
					direction := 0;
					IF dataInv.Parameters.Type = INV_ABB THEN
						ioMap.Out.ControlWord := 16#0477;
					ELSE
						ioMap.Out.ControlWord := 16#0007;
					END_IF
					dataInv.Commands.MovePositive := FALSE;
					dataInv.Commands.MoveNegative := FALSE;
					dataInv.Commands.Stop := FALSE;
					uiTimesCommandStop := uiTimesCommandStop + 1;
				ELSIF dataInv.Commands.MovePositive THEN
					direction := 1;
					IF dataInv.Parameters.Type = INV_ABB THEN
						ioMap.Out.ControlWord := 16#047F;
					ELSE
						ioMap.Out.ControlWord := 16#000F;
					END_IF
					dataInv.Commands.MovePositive := FALSE;
					uiTimesCommandPositive := uiTimesCommandPositive + 1;
				ELSIF dataInv.Commands.MoveNegative THEN
					direction := -1;
					IF dataInv.Parameters.Type = INV_ABB THEN
						ioMap.Out.ControlWord := 16#047F;
					ELSE
						ioMap.Out.ControlWord := 16#000F;
					END_IF
					dataInv.Commands.MoveNegative := FALSE;
					uiTimesCommandNegative := uiTimesCommandNegative + 1;
				END_IF
			END_IF
			
			
(************************ OPERATION_ENABLED ************************)			
		STATE_OPERATION_ENABLED:
			
			IF NOT(dataInv.Orders.PowerOn) THEN
				IF dataInv.Parameters.Type = INV_ABB THEN
					ioMap.Out.ControlWord := 16#0406;
				ELSE
					ioMap.Out.ControlWord := 16#0006;
				END_IF
				dataInv.Commands.MovePositive := FALSE;
				dataInv.Commands.MoveNegative := FALSE;
				dataInv.Commands.Stop := FALSE;
			ELSIF dataInv.Commands.Stop THEN
				direction := 0;
				IF dataInv.Parameters.Type = INV_ABB THEN
					ioMap.Out.ControlWord := 16#0477;
				ELSE
					ioMap.Out.ControlWord := 16#0007; //In CanOpen: ioMap.Out.ControlWord := 16#100F;	(* Stops the axis as configured in FUN->STC->STT (Default: RMP) *)
				END_IF;
				dataInv.Commands.MovePositive := FALSE;
				dataInv.Commands.MoveNegative := FALSE;
				dataInv.Commands.Stop := FALSE;
				uiTimesCommandStop := uiTimesCommandStop + 1;
			ELSIF dataInv.Commands.MovePositive THEN
				direction := 1;
				IF dataInv.Parameters.Type = INV_ABB THEN
					ioMap.Out.ControlWord := 16#047F;
				ELSE
					ioMap.Out.ControlWord := 16#000F;
				END_IF
				dataInv.Commands.MovePositive := FALSE;
				uiTimesCommandPositive := uiTimesCommandPositive + 1;
			ELSIF dataInv.Commands.MoveNegative THEN
				direction := -1;
				IF dataInv.Parameters.Type = INV_ABB THEN
					ioMap.Out.ControlWord := 16#047F;
				ELSE
					ioMap.Out.ControlWord := 16#000F;
				END_IF
				dataInv.Commands.MoveNegative := FALSE;
				uiTimesCommandNegative := uiTimesCommandNegative + 1;
			END_IF

			(* Needed to be compatible with the logical state machine *)
			IF direction = 0 THEN	(* If a stop has been requested *)
				IF ioMap.In.ActualSpeed = 0 THEN	(* If axis is in standstill *)
					ioMap.Out.ControlWord := 16#0007;	(* Returns the inverter to STATE_SWITCHED_ON *)
				END_IF
			END_IF
			

(************************ QUICK STOP ACTIVE ************************)		
		STATE_QUICK_STOP_ACTIVE:
			
			ioMap.Out.ControlWord := 16#0000;


(************************** FAULT REACTION *************************)			
		STATE_FAULT_REACTION_ACTIVE:
		
			(* Wait until STATE_FAULT *)
		

(********************** ERROR AND ACKNOWLEDGE **********************)		
		STATE_FAULT:
		
			IF (dataInv.Commands.Reset) THEN
				ioMap.Out.ControlWord := 16#0080;
				resetCount := 1;
				partialCount := 0;
				dataInv.Commands.Reset := FALSE;
			END_IF
			(* Makes a period-increasing Flip-Flop to ensure that the inverter gets a pos. edge *)
			IF resetCount > 0 THEN
				IF partialCount >= resetCount THEN
					ioMap.Out.ControlWord := ioMap.Out.ControlWord XOR 16#0080;
					resetCount := resetCount + 2;
					partialCount := 0;
				ELSE
					partialCount := partialCount + 1;
				END_IF
				IF resetCount >= 24 THEN
					resetCount := 1;
					partialCount := 0;
				END_IF
			END_IF
			
	
(************************* CONNECTION ERROR ************************)		
		STATE_ERROR:
			IF dataInv.Parameters.Type = INV_ABB THEN
				ioMap.Out.ControlWord := 16#0000;
			END_IF
			IF (dataInv.Commands.Reset) THEN
				connectionErrorNotAck := FALSE;
				dataInv.Commands.Reset := FALSE;
			END_IF
			
	END_CASE

(********************************************************************
	Speed and Direction Handling
*********************************************************************)
	
	(* Sets the speed *)
	ioMap.Out.SetSpeed := UINT_TO_INT(dataInv.Parameters.Velocity) * direction;
	
(*****************************************************************
	Status Handling
******************************************************************)	
	
	(* Reports the drive state *)
	dataInv.Status.ErrorComms			:= NOT ioMap.In.ModuleOk;
	dataInv.Status.StatusDisabled		:= (axisStep = STATE_NOT_READY_TO_SWITCH_ON) OR (axisStep = STATE_SWITCH_ON_DISABLED) OR (axisStep = STATE_READY_TO_SWITCH_ON);
	dataInv.Status.StatusReady			:= (axisStep = STATE_SWITCHED_ON);
	dataInv.Status.StatusOperation		:= (axisStep = STATE_OPERATION_ENABLED) OR (axisStep = STATE_QUICK_STOP_ACTIVE);
	dataInv.Status.StatusErrorStop		:= (axisStep = STATE_FAULT) OR (axisStep = STATE_FAULT_REACTION_ACTIVE) OR (axisStep = STATE_ERROR);
	dataInv.Status.ReadyForOrders		:=  dataInv.Orders.PowerOn AND ((axisStep = STATE_SWITCHED_ON AND paramOk) OR (axisStep = STATE_OPERATION_ENABLED)); //Adding dataInv.Orders.PowerOn and paramOk here because is when we are really ready to receive orders
	
	(* Reports errors *)
	IF dataInv.Parameters.Type = INV_ABB THEN
		ErrMessage_FUB.CurrentErrID		:= ioMap.In.ErrorID;
	
		IF axisStep = STATE_FAULT THEN
			dataInv.Status.ErrorID 		:= INT_TO_UINT(ioMap.In.ErrorID);
			dataInv.Status.ErrorText 	:= ErrMessage_FUB.CurrentErrMessage;
			ErrMessage_FUB.NewID		:= TRUE;
		ELSIF axisStep = STATE_ERROR THEN
			dataInv.Status.ErrorID 		:= 7510;
			dataInv.Status.ErrorText 	:= 'Communication error';
			ioMap.Out.Reset				:= dataInv.Commands.Reset;
		ELSE
			dataInv.Status.ErrorID	 	:= 0;
			dataInv.Status.ErrorText 	:= '';
			ioMap.Out.Reset				:= 0;
			dataInv.Commands.Reset		:= 0;
		END_IF
		(* Error message *)
		ErrMessage_FUB();
		
	ELSE
		IF axisStep = STATE_FAULT THEN
			dataInv.Status.ErrorID := INT_TO_UINT(ioMap.In.ErrorID);
			dataInv.Status.ErrorText := ERROR_TEXT[LIMIT(0, dataInv.Status.ErrorID, 109)];
		ELSIF axisStep = STATE_ERROR THEN
			dataInv.Status.ErrorID := 50034;
			dataInv.Status.ErrorText := 'SLF1/COF';
		ELSIF invalidHwAddress THEN
			dataInv.Status.ErrorID := 51000;
			dataInv.Status.ErrorText := 'Invalid HW Address';
		ELSE
			dataInv.Status.ErrorID := 0;
			dataInv.Status.ErrorText := '';
		END_IF
	END_IF
	(* Reports the actual speed *)
	dataInv.Status.ActVelocity := ioMap.In.ActualSpeed;
	dataInv.Status.xAtSpeed := ABS(ABS(dataInv.Status.ActVelocity)-dataInv.Parameters.Velocity)<(dataInv.Parameters.Velocity/100);
	
	(* Reports the actual current *)
	IF dataInv.Parameters.Type = INV_ABB THEN
		dataInv.Status.ActCurrent := INT_TO_REAL(ioMap.In.ActualCurrentABB)/ 1000;
	ELSE
		dataInv.Status.ActCurrent := UINT_TO_REAL(ioMap.In.ActualCurrent)/ 10;
	END_IF
	(* Reports the actual Torque *)
	dataInv.Status.ActTorque := INT_TO_REAL(ioMap.In.ActualTorque)/10;
	
	//In CanOpen, acceleration and deceleration by PDO
	IF dataInv.Parameters.CommsType = COMMS_CANOPEN THEN

		(* Acceleration *)
		dataInv.Parameters.AccelerationTime := LIMIT(ACC_min, dataInv.Parameters.AccelerationTime, ACC_max); (* Check value *)
		ioMap.Out.Acceleration := REAL_TO_UINT(dataInv.Parameters.AccelerationTime * 10);
	
		(* Deceleration *)
		dataInv.Parameters.DecelerationTime := LIMIT(DEC_min, dataInv.Parameters.DecelerationTime, DEC_max); (* Check value *)
		ioMap.Out.Deceleration := REAL_TO_UINT(dataInv.Parameters.DecelerationTime * 10);
		
	END_IF
	
	IF dataInv.Parameters.CommsType = COMMS_POWERLINK THEN
	
		(* Reports the state of the digital inputs*)
		dataInv.DigitalInput[0] := ioMap.In.DigitalInput[0];
		dataInv.DigitalInput[1] := ioMap.In.DigitalInput[1];
		dataInv.DigitalInput[2] := ioMap.In.DigitalInput[2];
		dataInv.DigitalInput[3] := ioMap.In.DigitalInput[3];
		dataInv.DigitalInput[4] := ioMap.In.DigitalInput[4];
		dataInv.DigitalInput[5] := ioMap.In.DigitalInput[5];
		dataInv.DigitalInput[6] := ioMap.In.DigitalInput[6];
		dataInv.DigitalInput[7] := ioMap.In.DigitalInput[7];
		
		(* Reports the state of the digital outputs*)
		ioMap.Out.DigitalOutput[0] := dataInv.DigitalOutput[0];
		ioMap.Out.DigitalOutput[1] := dataInv.DigitalOutput[1];
		ioMap.Out.DigitalOutput[2] := dataInv.DigitalOutput[2];
		
		(* Reports the state of the digital outputs*)
		ioMap.Out.AnalogOutput := dataInv.AnalogOutput;
	
	ELSIF dataInv.Parameters.CommsType = COMMS_CANOPEN THEN

		(* Reports the state of the digital inputs*)
		dataInv.DigitalInput[0] := ioMap.In.DigitalInputs.0;
		dataInv.DigitalInput[1] := ioMap.In.DigitalInputs.1;
		dataInv.DigitalInput[2] := ioMap.In.DigitalInputs.2;
		dataInv.DigitalInput[3] := ioMap.In.DigitalInputs.3;
		dataInv.DigitalInput[4] := ioMap.In.DigitalInputs.4;
		dataInv.DigitalInput[5] := ioMap.In.DigitalInputs.5;
	
		(* Reports the state of the digital outputs*)
		ioMap.Out.DigitalOutputs.0 := dataInv.DigitalOutput[0]; //RELAY
		ioMap.Out.DigitalOutputs.1 := dataInv.DigitalOutput[1]; //RELAY
		ioMap.Out.DigitalOutputs.8 := dataInv.DigitalOutput[2];
		
		(* Reports the state of the digital outputs*)
		ioMap.Out.AnalogOutputSigned := dataInv.AnalogOutput;
		
	END_IF
	
	(* Reports the state of the digital inputs*)
	dataInv.AnalogInput := ioMap.In.AnalogInput;	
	
//	//Get CANOpen state
//	CanGetState.enable := TRUE;
//	CanGetState.node := dataInv.Parameters.Hardware.Node;
//	CanGetState.pDevice := ADR('SS1.IF1');
//	CanGetState();

END_ACTION

