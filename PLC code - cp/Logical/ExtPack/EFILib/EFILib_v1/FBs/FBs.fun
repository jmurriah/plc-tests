
FUNCTION_BLOCK AutoResetSound
	VAR_INPUT
		xAlarm : BOOL;
		xSilence : BOOL;
	END_VAR
	VAR_OUTPUT
		xAlarmSound : BOOL;
	END_VAR
	VAR
		fbRiseUpAlarm : R_TRIG;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK FbCleanDelayControl
	VAR_INPUT
		T_delay_L1 : TIME; (*	// Line 1 TIME delay  *)
		T_delay_L2 : TIME; (*	// Line 2 TIME delay *)
		Start : BOOL; (*//Sequence start*)
		Doble : BOOL; (*//Doble line*)
		t_Gap : TIME; (*//Gap TIME*)
	END_VAR
	VAR_OUTPUT
		End : BOOL; (*//Delay end*)
		Out_L1 : BOOL; (*//Stop output line 1*)
		Out_L2 : BOOL; (*	//Stop output line 2*)
	END_VAR
	VAR
		T_delay1 : TIME;
		T_delay2 : TIME;
		TON_1 : TON;
		TON_5 : TON;
		TON_4 : TON;
		TON_6 : TON;
		TON_12 : TON;
		TON_14 : TON;
		TON_13 : TON;
		TON_15 : TON;
		TON_9 : TON;
		TON_16 : TON;
		TON_0 : TON;
		TON_3 : TON;
		TON_2 : TON;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MotorSpeedCalculation (*Motor Speed calculation*)
	VAR_INPUT
		xEnable : BOOL;
		iSpSpeed : INT; (*Speed in meter per minute*)
		uiReductor : UINT := 1; (*Reductor ratio*)
		uiRolllerPerimeter : UINT := 10; (*Perimeter belt roller, Length roller in mm*)
		xPrinterDirection : BOOL; (* 0=Right,1= Left*)
		rUnitsAtTheLoad : REAL; (*1 rev motor are 1000 Units at the load*)
	END_VAR
	VAR_OUTPUT
		xChange : BOOL;
		rSpeedMotor : REAL; (*Output speed in mXmin*)
	END_VAR
	VAR
		Aux : REAL;
		m_rpm : REAL := 1;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK SetCalcVelocity (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		xEnMov : BOOL;
		rSpeed : REAL; (*Speed in m/min*)
		rReduction : REAL := 0.0; (*GearBox ratio*)
		rAxisDiamter : REAL := 0.0; (*Length of a turn in mm*)
		rUnitsAtTheLoad : REAL; (*Units configured in the drive for 1 turn*)
	END_VAR
	VAR_OUTPUT
		xChange : BOOL; (*Signal of change in the speed setpint*)
		rSpeedInUnits : REAL;
	END_VAR
	VAR
		rLastSpeedInUnits : REAL := 0; (*Initilialize is important!!!!!!!!!!!!!!!*)
		zzEdge00000 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK GetCalcVelocity (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		xEn : BOOL; (*	// Enable lectura*)
		xValid : BOOL; (*	// Recepción de la velocidad del motor ok*)
		diVelocidad_RPM : DINT; (*// Valor leido en RPM*)
		uiReductor : UINT; (*// Relacion del reductor con tres decimales*)
		uiEje : UINT; (*	// Recorrido de una vuelta de eje en mm*)
	END_VAR
	VAR_OUTPUT
		iVel_lin : DINT; (*// Velocidad en metros/min*)
	END_VAR
	VAR
		rValor : REAL;
		rm_rpm : REAL;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK Blink
	VAR_INPUT
		T_Blink : TIME;
	END_VAR
	VAR_OUTPUT
		Out : BOOL;
	END_VAR
	VAR
		T_OFF : TON;
		T_ON : TON;
		VAR1 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK ComandBoolT (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_IN_OUT
		In : BOOL; (*//Valor de entrada*)
		Com : INT; (*//Para poner el comando a -1*)
	END_VAR
	VAR
		Contador : INT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK BlinkOnOff (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		xEnable : BOOL;
		tTimeOn : TIME;
		tTimeOff : TIME;
	END_VAR
	VAR_OUTPUT
		xOutput : BOOL;
	END_VAR
	VAR
		TON_1 : TON;
		TON_2 : TON;
	END_VAR
END_FUNCTION_BLOCK
(*Pending TO implememnt
FUNCTION_BLOCK InterfaceNetworkCommands It sends commands by CanOpen Interface to reset node
	VAR_INPUT
		xEnable : BOOL := FALSE; Enable action in this FB
		xModuleOk : BOOL := TRUE; It sets state of the module to check
		arrayInterfaceNetwork : STRING[3] := 'IF7'; This var contains the interface network type. Interface Network types forType of network:RS232 interface (IF1), Ethernet interface (IF2), POWERLINK interface (IF3), USB interfaces (IF4 and IF5) and CAN bus interface (IF7)
		iIdNode : UINT := 180; Node Identifier
		command : UINT := 3; commnad coRESET_NODE by default is reset node as enum defined in AsCanOpen
	END_VAR
	VAR_OUTPUT
		statusNode : BOOL := TRUE; ERROR or OK state
	END_VAR
END_FUNCTION_BLOCK*)
(*Function to simulate an analog process and be able to run programs in Simulation
PVnext := PVprevious - A + B * ActionControl*)

FUNCTION_BLOCK SimAnalogProcess
	VAR_INPUT
		AnalogType : AnalogProcessSimType_enum := ANALOGSIM_LINEAR_NEG;
		rA : REAL; (*Behavior Constant. Fixed desdent of PV without control action*)
		rB : REAL; (*Behavior Constant. Increment of PV with control action*)
		rMaxValue : REAL;
		rMinValue : REAL;
		rInitialValue : REAL;
		rActionControl : REAL;
		rNewPresentValue : REAL;
		xUseNewValue : BOOL := FALSE;
	END_VAR
	VAR_OUTPUT
		rPresentValue : REAL;
	END_VAR
	VAR
		xStarted : BOOL := FALSE;
		rSignalPerct : REAL; (*Current signal percentaje in the limits*)
		zzEdge00000 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK DriveUnitMngr (*Funtion Block to Manage Drive Units from and to the Drive*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Calculation : MD_CalculationType;
		JogSpeedDesired : {REDUND_UNREPLICABLE} REAL; (*Value in mm/s of the desired position*)
		SpeedMminDesired : {REDUND_UNREPLICABLE} REAL; (*Value in m/min of the desired Speed*)
		SpeedDesired : {REDUND_UNREPLICABLE} REAL; (*Value in mm/s of the desired Speed*)
		AccelerationDesired : {REDUND_UNREPLICABLE} REAL; (*Value in mm/s^2 of the desired Acceleration*)
		DecelerationDesired : {REDUND_UNREPLICABLE} REAL; (*Value in mm/s^2 of the desired Acceleration*)
		HomePositionDesired : {REDUND_UNREPLICABLE} REAL; (*Value in mm of the desired position*)
		PositionDesired : {REDUND_UNREPLICABLE} REAL; (*Value in mm of the desired position*)
		PulsesAccelerationDevice : {REDUND_UNREPLICABLE} REAL; (*Acceleration in pulses/s2*)
		PulsesDecelerationDevice : {REDUND_UNREPLICABLE} REAL; (*Deceleration in pulses/s2*)
		PulsesSpeedDevice : {REDUND_UNREPLICABLE} REAL; (*Current speed in pulses/s*)
		RevMinSpeedDevice : {REDUND_UNREPLICABLE} REAL; (*Current speed in rev/min*)
		pulsesDevice : {REDUND_UNREPLICABLE} REAL; (*Current position in pulses *)
		TransmissionData : MC_DriveUnitManager; (*Transmission data*)
	END_VAR
	VAR_OUTPUT
		pulsesJogSpeedDesired : REAL; (*Value in pulses/s of the desired speed*)
		pulsesSpeedDesired : REAL; (*Value in pulses/s of the desired speed*)
		pulsesAccelerationDesired : REAL; (*Value in pulses/s^2 of the desired acceleration*)
		pulsesDecelerationDesired : REAL; (*Value in pulses/s^2 of the desired acceleration*)
		pulsesHomePositionDesired : REAL; (*Value in pulses of the desired position*)
		pulsesPositionDesired : REAL; (*Value in pulses of the desired position*)
		mmAcceleration : REAL; (*Value in mm/s^2 of the desired acceleration*)
		mmDeceleration : REAL; (*Value in mm/s^2 of the desired acceleration*)
		SpeedDevice : REAL; (*Current Speed in mm/s*)
		SpeedRpmToMmin : REAL; (*Current Speed in m/min*)
		SpeedMminDevice : REAL; (*Current Speed in m/min*)
		PositionDevice : REAL; (*Current position in mm*)
		mmToPulses : REAL := 1.0;
		mmToTurn : REAL := 1.0;
	END_VAR
	VAR
		JogSpeedDesiredCopy : REAL := -1; (*Value in mm of the desired speed. Initialized to a value not allowed to force a first execution*)
		SpeedMminDesiredCopy : REAL := -1; (*Value in m/min of the desired speed. Initialized to a value not allowed to force a first execution*)
		SpeedDesiredCopy : REAL := -1; (*Value in mm/2 of the desired speed. Initialized to a value not allowed to force a first execution*)
		AccelerationDesiredCopy : REAL := -1; (*Value in mm/s^2 of the desired acceleration. Initialized to a value not allowed to force a first execution*)
		DecelerationDesiredCopy : REAL := -1; (*Value in mm/s^2 of the desired acceleration. Initialized to a value not allowed to force a first execution*)
		HomePositionDesiredCopy : REAL := -1; (*Value in mm of the desired position. Initialized to a value not allowed to force a first execution*)
		PositionDesiredCopy : REAL := -1; (*Value in mm of the desired position. Initialized to a value not allowed to force a first execution*)
		pulsesAccelerationDeviceCopy : REAL := -1; (*Acceleration in pulses*)
		pulsesDecelerationDeviceCopy : REAL := -1; (*Deceleration in pulses*)
		pulsesSpeedDeviceCopy : REAL := -1; (*Current speed in pulses/s. Initialized to a value not allowed to force a first execution*)
		RevMinSpeedDeviceCopy : REAL := -1; (*Current speed in rev/min*)
		pulsesDeviceCopy : REAL := -1; (*Current position in pulses. Initialized to a value not allowed to force a first execution*)
		mmToPulsesCopy : REAL := -1; (*Initialized to a value not allowed to force a first execution*)
		TransDataCopy : MC_DriveUnitManager;
	END_VAR
END_FUNCTION_BLOCK
