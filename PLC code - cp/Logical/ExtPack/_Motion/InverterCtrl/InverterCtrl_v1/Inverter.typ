
TYPE
	AxisP66_Commands_typ : 	STRUCT  (*Control structure for ACOPOSinverter*)
		MovePositive : BOOL; (*Starts a movement in the positive direction*)
		MoveNegative : BOOL; (*Starts a movement in the negative direction*)
		Stop : BOOL; (*Stops the movement*)
		Reset : BOOL; (*Acknowledges and quits all errors*)
	END_STRUCT;
	AxisP66_Orders_typ : 	STRUCT  (*Control structure for ACOPOSinverter*)
		PowerOn : BOOL; (*Switches the power on*)
	END_STRUCT;
	AxisP66_ParametersHardware_typ : 	STRUCT 
		CpuFamily : USINT;
		PowerLinkInterface : STRING[39]; (*Physical address of the Powerlink IF. For instance, 'SL1.IF3'*)
		Node : USINT; (*Inverter's Powerlink node*)
	END_STRUCT;
	AxisP66_Parameters_typ : 	STRUCT 
		CommsType : CommsNetworkType_enum;
		Hardware : AxisP66_ParametersHardware_typ;
		Velocity : UINT := 200; (*[rpm]. Value of 200 by default in B&R code*)
		AccelerationTime : REAL := 3; (*[s]. Value of 3 by default in B&R code*)
		Type : InvType_enum;
		ControlMode : UINT := 0; (*Chose control mode: 1-Escalar, 0-Vectorial*)
		DecelerationTime : REAL := 3; (*[s]. Value of 3 by default in B&R code*)
	END_STRUCT;
	AxisP66_StatusHw_typ : 	STRUCT 
		SerialNumber : UDINT;
		ModuleID : UDINT;
		HwVariant : UDINT;
		FwVersion : UDINT;
		ACPiSerialNumber : UDINT;
		ACPiModuleID : UDINT;
	END_STRUCT;
	AxisP66_Status_typ : 	STRUCT 
		xAtSpeed : BOOL;
		ActVelocity : INT; (*[rpm]*)
		ActCurrent : REAL; (*[A]*)
		ActTorque : REAL; (*[Nm]*)
		ErrorID : UINT; (*Error number*)
		ErrorText : STRING[19]; (*Error description*)
		ErrorComms : BOOL; (*The comunication with the inverter is not working*)
		StatusDisabled : BOOL; (*The inverter is switched off*)
		StatusReady : BOOL; (*The inverter is ready to perform a movement*)
		StatusOperation : BOOL; (*The motor is powered*)
		StatusErrorStop : BOOL; (*The inverter has some error*)
		ReadyForOrders : BOOL; (*Powered OR Enabled*)
	END_STRUCT;
	AxisP66_ElecSignals_Out_typ : 	STRUCT 
		xSpare : BOOL;
	END_STRUCT;
	AxisP66_ElecSignals_In_typ : 	STRUCT 
		xBreakerOK : BOOL; (*EFI Signal: Circuit breaker protection OK*)
	END_STRUCT;
	AxisP66_ElecSignals_typ : 	STRUCT 
		In : AxisP66_ElecSignals_In_typ;
		Out : AxisP66_ElecSignals_Out_typ;
	END_STRUCT;
	AxisP66_Signals_In_typ : 	STRUCT 
		Hw : AxisP66_StatusHw_typ;
		Inputs : USINT;
		ModuleOk : BOOL; (*ModuleOk **)
		StatusWord : UINT; (*ETAD_Input **)
		ActualSpeed : INT; (*RFRD_Input [rpm] (encoderless estimation)*)
		ActualCurrent : UINT; (*LCR_Input (0.1A)*)
		ActualCurrentABB : INT; (*LCR_Input (0.001A)*)
		ActualTorque : INT; (*OTRN_Input (0.1Nm)*)
		ErrorID : UINT; (*LFT_Input*)
		DigitalInputs : UINT; (*Digital inputs in CanOpen. Reading an integer*)
		DigitalInput : ARRAY[0..7]OF BOOL; (*Digital inputs in Powerlink. Reading individually*)
		AnalogInput : ARRAY[0..2]OF INT;
		xBreakerOK : BOOL; (*EFI Signal: Circuit breaker protection OK*)
	END_STRUCT;
	AxisP66_Signals_Out_typ : 	STRUCT 
		ControlWord : UINT; (*CMDD_Output **)
		DigitalOutputs : UINT; (*Digital inputs in CanOpen. Writing an integer*)
		DigitalOutput : ARRAY[0..2]OF BOOL; (*Digital inputs in Powerlink. Writing individually*)
		AnalogOutput : UINT;
		AnalogOutputSigned : INT; (*In CanOpen, Analog Output is INT not UINT*)
		SetSpeed : INT; (*LFRD_Output **)
		Acceleration : UINT; (*Just for CanOpen. In Powerlink sent by FunctionBlock*)
		Deceleration : UINT; (*Just for CanOpen. In Powerlink sent by FunctionBlock*)
		SetFrequency : INT;
		ControlMode : UINT; (*ControlMode_Output*)
		SpeedUnit : UINT; (*Velocity unit depending on the control mode.*)
		AccTimeVector : DINT;
		DecTimeVector : DINT;
		AccTimeScalar : DINT;
		DecTimeScalar : DINT;
		Reset : UINT;
	END_STRUCT;
	AxisP66_Signals_typ : 	STRUCT  (* * -> Compulsory*)
		In : AxisP66_Signals_In_typ;
		Out : AxisP66_Signals_Out_typ;
	END_STRUCT;
	AxisP66_typ : 	STRUCT  (*Control structure for ACOPOSinverter P66 & P67*)
		Commands : AxisP66_Commands_typ;
		Orders : AxisP66_Orders_typ;
		Parameters : AxisP66_Parameters_typ;
		Status : AxisP66_Status_typ;
		ElecSignals : AxisP66_ElecSignals_typ;
		DigitalInput : ARRAY[0..7]OF BOOL;
		DigitalOutput : ARRAY[0..2]OF BOOL;
		AnalogInput : ARRAY[0..2]OF INT;
		AnalogOutput : UINT;
	END_STRUCT;
END_TYPE
