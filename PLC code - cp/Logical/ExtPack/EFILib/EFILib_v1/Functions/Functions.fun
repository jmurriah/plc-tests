
FUNCTION ComandBool : BOOL (*To be used with vars that remotely set or reset with an order of 1 or 0*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_IN_OUT
		In : BOOL; (*The BOOL var set/reset by the command*)
		Com : INT; (*Command. 1 to set and 0 to reset. After a command, the function sets it to -1*)
	END_VAR
END_FUNCTION

FUNCTION ComandBoolEdge0 : BOOL (*To be used with vars that with an order of 1 are set to TRUE during one comms cycle*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_IN_OUT
		In : BOOL; (*The BOOL var set/reset by the command*)
		Com : INT; (*Command. 1 to set and 0 to reset. After a command, the function sets it to -1*)
	END_VAR
END_FUNCTION

FUNCTION ComandBoolReset : BOOL (*To be used with vars that remotely RESET with an order of 1*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_IN_OUT
		In : BOOL; (*The BOOL var set/reset by the command*)
		Com : INT; (*Command. 1 to set and 0 to reset. After a command, the function sets it to -1*)
	END_VAR
END_FUNCTION

FUNCTION SAFE_UINTDIFF : UINT (*Return the diff of the values of a counte. Takes care about the overflow of the value*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		uiLastValue : UINT;
		uiPrevValue : UINT;
	END_VAR
END_FUNCTION

FUNCTION DintTransfer : BOOL (*Return the value of and DINT splitted in 2 INT values*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		In : DINT; (*DINT to split*)
	END_VAR
	VAR_IN_OUT
		LSint : INT; (*Less significant INT*)
		MSint : INT; (*Most significant INT*)
	END_VAR
END_FUNCTION

FUNCTION StatusAnalogInput : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		xModuleOK : BOOL;
		iStatus01 : USINT;
		iStatus02 : USINT;
		iInputNumber : USINT;
	END_VAR
	VAR
		iStatusInput : USINT;
	END_VAR
END_FUNCTION

FUNCTION StatusTemperatureInput : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		iStatusTempInput01 : USINT;
		iTemperatureInputNumber : USINT;
	END_VAR
	VAR
		iStatusTemperatureInput : USINT;
	END_VAR
END_FUNCTION

FUNCTION StatusAnalogInputBroken : BOOL (*TODO: Add your comment here*) (*$GROUP=Functions,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		xModuleOK : BOOL;
		iStatus01 : USINT;
		iStatus02 : USINT;
		iInputNumber : USINT;
	END_VAR
	VAR
		iStatusInput : USINT;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION UDINTFromComms : UDINT (*Assignation of a UDINT Double value from an array*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		indexLSB : UINT;
		comsArray : REFERENCE TO ARRAY[0..9999] OF INT;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION UDINTToComms : BOOL (*Insert a UDINT value in an array for comms*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		value : UDINT;
		indexLSB : UINT;
		comsArray : REFERENCE TO ARRAY[0..9999] OF INT;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION Mmin_TO_DriveUnitsRatio : REAL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		rDiameter : REAL; (*Value in mm*)
		rGearBox : REAL; (*GearBox ratio (x:1)*)
		rUnitsPerTurn : REAL; (*Units per turn*)
	END_VAR
END_FUNCTION

FUNCTION UINT_SUB : UINT (*UINT substraction. If the result in negative, returns a Cero*)
	VAR_INPUT
		Minuend : UINT; (*Minuend of the substraction*)
		Subtrahend : UINT; (*Subtrahend of the substration*)
	END_VAR
END_FUNCTION

FUNCTION UDINT_SUB : UDINT (*UINT substraction. If the result in negative, returns a Cero*)
	VAR_INPUT
		Minuend : UDINT; (*Minuend of the substraction*)
		Subtrahend : UDINT; (*Subtrahend of the substration*)
	END_VAR
END_FUNCTION

FUNCTION LoadPIDparam : BOOL (*Load the data of the USER structure stPIDParam into the FB structure MTPIDParametersType. VOID*)
	VAR_INPUT
		FB_Structure : REFERENCE TO MTPIDParametersType; (*Structure of the FunctionBlock*)
		USER_Structure : REFERENCE TO stPIDParam; (*Structure of the USER*)
	END_VAR
END_FUNCTION

FUNCTION PLC_Init : BOOL (*Load initial script for PLC. VOID*)
	VAR_INPUT
		plcStruct : REFERENCE TO StPLC; (*StPLC structure*)
	END_VAR
	VAR
		strAux : STRING[80];
	END_VAR
END_FUNCTION

FUNCTION ShiftArrayForward : UINT (*Shift the values of the array some positions forward. Protected to not go beyond the array*)
	VAR_INPUT
		pArray : UDINT; (*Address of the array. Calling as ADR(myArray)*)
		ArraySize : UDINT; (*Address of the array. Calling as SIZEOF(myArray)*)
		ElementSize : UDINT; (*Address of the array. Calling as SIZEOF(myArray[0])*)
		DestinationPosition : UDINT; (*Position where to move the first element of the array*)
		ElementsToMove : UDINT; (*Quantity of elements to move the array*)
	END_VAR
	VAR
		ElementsInArray : UDINT; (*Size of memory to move*)
	END_VAR
END_FUNCTION

FUNCTION ShiftArrayBackward : UINT (*Shift the values of the array some positions backwards. Protected to not go beyond the array*)
	VAR_INPUT
		pArray : UDINT; (*Address of the array. Calling as ADR(myArray)*)
		ArraySize : UDINT; (*Address of the array. Calling as SIZEOF(myArray)*)
		ElementSize : UDINT; (*Address of the array. Calling as SIZEOF(myArray[0])*)
		SourcePosition : UDINT; (*Position to be moved to the first element of the array*)
		ElementsToMove : UDINT; (*Quantity of elements to move the array*)
	END_VAR
	VAR
		ElementsInArray : UDINT; (*Size of memory to move*)
	END_VAR
END_FUNCTION

FUNCTION ShiftArrayOffset : UINT (*Shift the values of the array some positions forward. Protected to not go beyond the array*)
	VAR_INPUT
		pArray : UDINT; (*Address of the array. Calling as ADR(myArray)*)
		ArraySize : UDINT; (*Address of the array. Calling as SIZEOF(myArray)*)
		ElementSize : UDINT; (*Address of the array. Calling as SIZEOF(myArray[0])*)
		SourcePosition : UDINT; (*Position where to move the first element of the array*)
		DestinationPosition : UDINT; (*Position where to move the first element of the array*)
		ElementsToMove : UDINT; (*Quantity of elements to move the array*)
	END_VAR
	VAR
		ElementsInArray : UDINT; (*Size of memory to move*)
	END_VAR
END_FUNCTION

FUNCTION CleanEndArray : UINT (*Write 0 to end of an array to clean of not considered values. Protected to not go beyond the array*)
	VAR_INPUT
		pArray : UDINT; (*Address of the array. Calling as ADR(myArray)*)
		ArraySize : UDINT; (*Address of the array. Calling as SIZEOF(myArray)*)
		ElementSize : UDINT; (*Address of the array. Calling as SIZEOF(myArray[0])*)
		TotalElements : UDINT; (*Position where to move the first element of the array*)
	END_VAR
	VAR
		ElementsToClean : UDINT; (*Quantity of elements to move the array*)
		MaxElementsInArray : UDINT; (*Size of memory to move*)
	END_VAR
END_FUNCTION

FUNCTION TimeFromMmAndMmin : TIME (*Time in ms to run a distance in mm with speed in m/min*)
	VAR_INPUT
		rDistance : REAL; (*Distance in mm*)
		rSpeed : REAL; (*Speed in m/min*)
	END_VAR
END_FUNCTION
