(*********************************************************************************
 * Copyright: Bernecker + Rainer
 * Author:    gimeneza
 * Created:   June 15, 2017/4:14 PM 
 *********************************************************************************)

TYPE
	stIcla_Error : 	STRUCT 
		Jog : BOOL;
		Communication : BOOL;
		ErrorNumber : UINT;
	END_STRUCT;
	stIcla_Jog : 	STRUCT 
		VeloSlow : UINT := 300; (*Rev/min Limited from 300 to 5000. 300 is the default value in Icla*)
		VeloFast : UINT := 1000; (*Rev/min Limited from 300 to 5000. 1000 is the default value in Icla*)
	END_STRUCT;
	stIcla_MoveAbsolute : 	STRUCT 
		Position : DINT;
		Velocity : UINT;
	END_STRUCT;
	stIcla_Homing : 	STRUCT 
		Position : DINT;
		Mode : USINT;
	END_STRUCT;
	stIcla_Commands : 	STRUCT 
		Enable : BOOL;
		Home : BOOL; (*EDGE to Home the drive. Reseted when starting Home process*)
		MoveAbsolute : BOOL;
		JogForward : BOOL;
		JogBackward : BOOL;
		JogFastSpeed : BOOL;
		Stop : BOOL; (*EDGE*)
		Reset : BOOL; (*EDGE*)
	END_STRUCT;
	stIcla_RegistersValueArray : 	STRUCT 
		data0 : USINT; (*data of the register. USINT*)
		data1 : USINT; (*data of the register. USINT*)
		data2 : USINT; (*data of the register. USINT*)
		data3 : USINT; (*data of the register. USINT*)
	END_STRUCT;
	stIcla_RegistersValue : 	STRUCT 
		usiValue : USINT; (*Value of data0, just for USINT data. 8 bits*)
		uiValue : UINT; (*Value of data0 & data1, just for UINT data. 16bits*)
		xDataOK : BOOL; (*Data in values is correct*)
		xBusy : BOOL; (*The registers are beeing read*)
		rawData : stIcla_RegistersValueArray; (*raw USINT data array from communication function*)
	END_STRUCT;
	stIcla_Register : 	STRUCT 
		index : USINT := 1; (*Index of the register to read. 1:2 by default is Firmware version*)
		subindex : USINT := 2; (*Subindex of the register to read. 1:2 by default is Firmware version*)
	END_STRUCT;
	stIcla_WriteRegister : 	STRUCT 
		WriteOrder : BOOL;
		TotalBytes : USINT := 2; (*Quantity of bytes to send Just 2 and 4 are valid values*)
		data : stIcla_RegistersValueArray := (0); (*Bytes of Data to send*)
		writeRegister : stIcla_Register; (*Register to write the data in the Icla while the comms are in idle*)
	END_STRUCT;
	stIcla_Parameters : 	STRUCT 
		Home : stIcla_Homing;
		MoveAbsolute : stIcla_MoveAbsolute;
		Jog : stIcla_Jog;
		Node : USINT := 255; (*255 is the maximum value of USINT. It means the node is still not configured *)
		Network : STRING[7]; (*The Position of the network*)
		iAcceleration : UINT := 2500; (*Acceleration of the Icla revolutions min^-1/sec. Limited to 1000 and 10000 by the Icla itself. 2500 is the default value*)
		xAutoresetComms : BOOL; (*Send NMT message if not communicating to restore communication with an Icla*)
		readRegister : stIcla_Register; (*Read registers from the Icla while the comms are in idle*)
		writeRegister : stIcla_WriteRegister; (*Read registers from the Icla while the comms are in idle*)
	END_STRUCT;
	stIcla_Status : 	STRUCT 
		xModuleOK : BOOL;
		xIsHoming : BOOL;
		xReferenced : BOOL;
		xInError : BOOL;
		xInPosition : BOOL; (*Edge*)
		iActualPosition : DINT;
		iActualVelocity : INT;
		iDriveStatus : UINT;
		Error : stIcla_Error;
		Info : STRING[80];
		IclaStatus : stepAXISILE_enum;
		IclaSDOStep : stepCOMSILE_enum;
		readRegister : stIcla_RegistersValue;
		writeRegisterOK : BOOL;
	END_STRUCT;
	stIcla : 	STRUCT 
		Command : stIcla_Commands;
		Parameter : stIcla_Parameters;
		Status : stIcla_Status;
	END_STRUCT;
	TPDO4_typ : 	STRUCT 
		modeStat : USINT;
		driveStat : UINT;
		Act8 : SINT;
		Act32 : DINT;
	END_STRUCT;
	RPDO4_typ : 	STRUCT 
		driveCtrl : USINT;
		modeCtrl : USINT;
		ModuleOK : BOOL;
		Ref16 : INT;
		Ref32 : DINT;
	END_STRUCT;
	IclaNetData_typ : 	STRUCT 
		RPDO4 : RPDO4_typ;
		TPDO4 : TPDO4_typ;
		xModuleOK : BOOL;
	END_STRUCT;
	stepAXISILE_enum : 
		(
		AXISILE_INIT,
		AXISILE_WAIT_READY_TO_SWITCH_ON,
		AXISILE_DOWNLOAD,
		AXISILE_CONFIRM,
		AXISILE_ACKN,
		AXISILE_UNLOCK,
		AXISILE_WAIT,
		AXISILE_POWER,
		AXISILE_HOMING,
		AXISILE_READY,
		AXISILE_JOG,
		AXISILE_MOVE_ABSOLUTE,
		AXISILE_ERROR
		);
	stepCOMSILE_enum : 
		(
		COMSILE_IDLE,
		COMSILE_ACCELERATION,
		COMSILE_JOG_PAUSE,
		COMSILE_JOG_TRANSFER_SLOW,
		COMSILE_JOG_TRANSFER_FAST,
		COMSILE_READ_SPEED,
		COMSILE_ERROR
		);
END_TYPE
