
FUNCTION MB_GetClient : UDINT (*Debug function. Returns pointer to MB_Client_typ*)
	VAR_INPUT
		ClientID : USINT;
	END_VAR
END_FUNCTION

FUNCTION BRSE_MB_Alloc : UDINT (*Allocate memory for internal data (configuration etc.). Returns error code or pointer.*)
	VAR_INPUT
		Unit : USINT; (*Unit (card id) to allocate. 0-254*)
		MaxCoils : UINT; (*Max 2000*)
		MaxHoldingRegisters : UINT; (*Max 2000*)
		MaxDiscreteInputs : UINT; (*Max 125*)
		MaxInputRegisters : UINT; (*Max 125*)
	END_VAR
END_FUNCTION

FUNCTION BRSE_MB_Coil : UINT
	VAR_INPUT
		Unit : USINT;
		Reference : UINT; (*Variable index (0-2000)*)
		VariableAddress : UDINT;
	END_VAR
END_FUNCTION

FUNCTION BRSE_MB_HoldingRegister : UINT
	VAR_INPUT
		Unit : USINT;
		Reference : UINT; (*Variable index (0-2000)*)
		VariableAddress : UDINT;
	END_VAR
END_FUNCTION

FUNCTION BRSE_MB_4ByteHoldingRegister : UINT
	VAR_INPUT
		Unit : USINT;
		Reference : UINT; (*Variable index (0-2000)*)
		VariableAddress : UDINT;
	END_VAR
END_FUNCTION

FUNCTION BRSE_MB_InputRegister : UINT
	VAR_INPUT
		Unit : USINT;
		Reference : UINT; (*Variable index (0-2000)*)
		VariableAddress : UDINT;
	END_VAR
END_FUNCTION

FUNCTION BRSE_MB_DiscreteInput : UINT
	VAR_INPUT
		Unit : USINT;
		Reference : UINT; (*Variable index (0-2000)*)
		VariableAddress : UDINT;
	END_VAR
END_FUNCTION

FUNCTION_BLOCK BRSE_MB_Server
	VAR_INPUT
		Unit : USINT;
		ClientFormat : USINT;
		InputBuffer : ARRAY[0..254] OF USINT;
	END_VAR
	VAR_OUTPUT
		OutputBuffer : ARRAY[0..254] OF USINT;
		Status : UINT;
		BufferLength : USINT; (*Total number of bytes in output buffer*)
	END_VAR
	VAR
		Request : BRSE_MB_Request_typ;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION MB_AllocClient : UDINT
	VAR_INPUT
		ClientID : USINT;
	END_VAR
END_FUNCTION

FUNCTION_BLOCK MB_PollCoils
	VAR_INPUT
		ClientID : USINT;
		Enable : BOOL;
		Quantity : UINT;
		PollInterval : UDINT; (*Interval in ms between the read requests*)
		VariablesAddress : UDINT;
		StartAddress : UINT;
		Unit : USINT; (*Unit in the server*)
	END_VAR
	VAR_OUTPUT
		UpdateDone : BOOL;
		Busy : BOOL;
		Active : BOOL;
		Error : BOOL;
		ErrorID : UINT;
		Status : UINT;
	END_VAR
	VAR
		Step : UINT;
		RequestStatus : UINT;
		InternalStatus : UINT;
		RTInfo_0 : RTInfo;
		CycleTimeMs : UDINT; (*Task cycle time in ms*)
		ElapsedTime : UDINT; (*Ms since last request*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MB_PollDiscreteInputs
	VAR_INPUT
		ClientID : USINT;
		Enable : BOOL;
		Quantity : UINT;
		PollInterval : UDINT; (*Interval in ms between the read requests*)
		VariablesAddress : UDINT;
		StartAddress : UINT;
		Unit : USINT; (*Unit in the server*)
	END_VAR
	VAR_OUTPUT
		UpdateDone : BOOL;
		Busy : BOOL;
		Active : BOOL;
		Error : BOOL;
		ErrorID : UINT;
		Status : UINT;
	END_VAR
	VAR
		Step : UINT;
		RequestStatus : UINT;
		InternalStatus : UINT;
		RTInfo_0 : RTInfo;
		CycleTimeMs : UDINT; (*Task cycle time in ms*)
		ElapsedTime : UDINT; (*Ms since last request*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MB_PollHoldingRegisters
	VAR_INPUT
		ClientID : USINT;
		Enable : BOOL;
		Quantity : UINT;
		PollInterval : UDINT; (*Interval in ms between the read requests*)
		VariablesAddress : UDINT;
		StartAddress : UINT;
		Unit : USINT; (*Unit in the server*)
	END_VAR
	VAR_OUTPUT
		UpdateDone : BOOL;
		Busy : BOOL;
		Active : BOOL;
		Error : BOOL;
		ErrorID : UINT;
		Status : UINT;
	END_VAR
	VAR
		Step : UINT;
		RequestStatus : UINT;
		InternalStatus : UINT;
		RTInfo_0 : RTInfo;
		CycleTimeMs : UDINT; (*Task cycle time in ms*)
		ElapsedTime : UDINT; (*Ms since last request*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MB_Poll4ByteHoldingRegisters
	VAR_INPUT
		ClientID : USINT;
		Enable : BOOL;
		Quantity : UINT;
		PollInterval : UDINT; (*Interval in ms between the read requests*)
		VariablesAddress : UDINT;
		StartAddress : UINT;
		Unit : USINT; (*Unit in the server*)
	END_VAR
	VAR_OUTPUT
		UpdateDone : BOOL;
		Busy : BOOL;
		Active : BOOL;
		Error : BOOL;
		ErrorID : UINT;
		Status : UINT;
	END_VAR
	VAR
		Step : UINT;
		RequestStatus : UINT;
		InternalStatus : UINT;
		RTInfo_0 : RTInfo;
		CycleTimeMs : UDINT; (*Task cycle time in ms*)
		ElapsedTime : UDINT; (*Ms since last request*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MB_PollInputRegisters
	VAR_INPUT
		ClientID : USINT;
		Enable : BOOL;
		Quantity : UINT;
		PollInterval : UDINT; (*Interval in ms between the read requests*)
		VariablesAddress : UDINT;
		StartAddress : UINT;
		Unit : USINT; (*Unit in the server*)
	END_VAR
	VAR_OUTPUT
		UpdateDone : BOOL;
		Busy : BOOL;
		Active : BOOL;
		Error : BOOL;
		ErrorID : UINT;
		Status : UINT;
	END_VAR
	VAR
		Step : UINT;
		RequestStatus : UINT;
		InternalStatus : UINT;
		RTInfo_0 : RTInfo;
		CycleTimeMs : UDINT; (*Task cycle time in ms*)
		ElapsedTime : UDINT; (*Ms since last request*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MB_PushCoils
	VAR_INPUT
		ClientID : USINT;
		Enable : BOOL;
		Quantity : UINT;
		PushInterval : UDINT; (*Interval in ms between the write requests*)
		VariablesAddress : UDINT;
		StartAddress : UINT;
		Unit : USINT; (*Unit in the server*)
	END_VAR
	VAR_OUTPUT
		UpdateDone : BOOL;
		Busy : BOOL;
		Active : BOOL;
		Error : BOOL;
		ErrorID : UINT;
		Status : UINT;
	END_VAR
	VAR
		Step : UINT;
		RequestStatus : UINT;
		InternalStatus : UINT;
		RTInfo_0 : RTInfo;
		CycleTimeMs : UDINT; (*Task cycle time in ms*)
		ElapsedTime : UDINT; (*Ms since last request*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MB_PushHoldingRegisters
	VAR_INPUT
		ClientID : USINT;
		Enable : BOOL;
		Quantity : UINT;
		PushInterval : UDINT; (*Interval in ms between the write requests*)
		VariablesAddress : UDINT;
		StartAddress : UINT;
		Unit : USINT; (*Unit in the server*)
	END_VAR
	VAR_OUTPUT
		UpdateDone : BOOL;
		Busy : BOOL;
		Active : BOOL;
		Error : BOOL;
		ErrorID : UINT;
		Status : UINT;
	END_VAR
	VAR
		Step : UINT;
		RequestStatus : UINT;
		InternalStatus : UINT;
		RTInfo_0 : RTInfo;
		CycleTimeMs : UDINT; (*Task cycle time in ms*)
		ElapsedTime : UDINT; (*Ms since last request*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MB_Push4ByteHoldingRegisters
	VAR_INPUT
		ClientID : USINT;
		Enable : BOOL;
		Quantity : UINT;
		PushInterval : UDINT; (*Interval in ms between the write requests*)
		VariablesAddress : UDINT;
		StartAddress : UINT;
		Unit : USINT; (*Unit in the server*)
	END_VAR
	VAR_OUTPUT
		UpdateDone : BOOL;
		Busy : BOOL;
		Active : BOOL;
		Error : BOOL;
		ErrorID : UINT;
		Status : UINT;
	END_VAR
	VAR
		Step : UINT;
		RequestStatus : UINT;
		InternalStatus : UINT;
		RTInfo_0 : RTInfo;
		CycleTimeMs : UDINT; (*Task cycle time in ms*)
		ElapsedTime : UDINT; (*Ms since last request*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MB_ReadCoils
	VAR_INPUT
		ClientID : USINT;
		Execute : BOOL;
		Quantity : UINT;
		VariablesAddress : UDINT;
		StartAddress : UINT;
		Unit : USINT; (*Unit in the server*)
	END_VAR
	VAR_OUTPUT
		Busy : BOOL;
		Done : BOOL;
		Error : BOOL;
		ErrorID : UINT;
		Status : UINT;
	END_VAR
	VAR
		Step : UINT;
		RequestStatus : UINT;
		InternalStatus : UINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MB_ReadDiscreteInputs
	VAR_INPUT
		ClientID : USINT;
		Execute : BOOL;
		Quantity : UINT;
		VariablesAddress : UDINT;
		StartAddress : UINT;
		Unit : USINT; (*Unit in the server*)
	END_VAR
	VAR_OUTPUT
		Busy : BOOL;
		Done : BOOL;
		Error : BOOL;
		ErrorID : UINT;
		Status : UINT;
	END_VAR
	VAR
		Step : UINT;
		RequestStatus : UINT;
		InternalStatus : UINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MB_ReadHoldingRegisters
	VAR_INPUT
		ClientID : USINT;
		Execute : BOOL;
		Quantity : UINT;
		VariablesAddress : UDINT;
		StartAddress : UINT;
		Unit : USINT; (*Unit in the server*)
	END_VAR
	VAR_OUTPUT
		Busy : BOOL;
		Done : BOOL;
		Error : BOOL;
		ErrorID : UINT;
		Status : UINT;
	END_VAR
	VAR
		Step : UINT;
		RequestStatus : UINT;
		InternalStatus : UINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MB_Read4ByteHoldingRegisters
	VAR_INPUT
		ClientID : USINT;
		Execute : BOOL;
		Quantity : UINT;
		VariablesAddress : UDINT;
		StartAddress : UINT;
		Unit : USINT; (*Unit in the server*)
	END_VAR
	VAR_OUTPUT
		Busy : BOOL;
		Done : BOOL;
		Error : BOOL;
		ErrorID : UINT;
		Status : UINT;
	END_VAR
	VAR
		Step : UINT;
		RequestStatus : UINT;
		InternalStatus : UINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MB_ReadInputRegisters
	VAR_INPUT
		ClientID : USINT;
		Execute : BOOL;
		Quantity : UINT;
		VariablesAddress : UDINT;
		StartAddress : UINT;
		Unit : USINT; (*Unit in the server*)
	END_VAR
	VAR_OUTPUT
		Busy : BOOL;
		Done : BOOL;
		Error : BOOL;
		ErrorID : UINT;
		Status : UINT;
	END_VAR
	VAR
		Step : UINT;
		RequestStatus : UINT;
		InternalStatus : UINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MB_WriteCoils
	VAR_INPUT
		ClientID : USINT;
		Execute : BOOL;
		Quantity : UINT;
		VariablesAddress : UDINT;
		StartAddress : UINT;
		Unit : USINT; (*Unit in the server*)
	END_VAR
	VAR_OUTPUT
		Busy : BOOL;
		Done : BOOL;
		Error : BOOL;
		ErrorID : UINT;
		Status : UINT;
	END_VAR
	VAR
		Step : UINT;
		RequestStatus : UINT;
		InternalStatus : UINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MB_WriteHoldingRegisters
	VAR_INPUT
		ClientID : USINT;
		Execute : BOOL;
		Quantity : UINT;
		VariablesAddress : UDINT;
		StartAddress : UINT;
		Unit : USINT; (*Unit in the server*)
	END_VAR
	VAR_OUTPUT
		Busy : BOOL;
		Done : BOOL;
		Error : BOOL;
		ErrorID : UINT;
		Status : UINT;
	END_VAR
	VAR
		Step : UINT;
		RequestStatus : UINT;
		InternalStatus : UINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MB_Write4ByteHoldingRegisters
	VAR_INPUT
		ClientID : USINT;
		Execute : BOOL;
		Quantity : UINT;
		VariablesAddress : UDINT;
		StartAddress : UINT;
		Unit : USINT; (*Unit in the server*)
	END_VAR
	VAR_OUTPUT
		Busy : BOOL;
		Done : BOOL;
		Error : BOOL;
		ErrorID : UINT;
		Status : UINT;
	END_VAR
	VAR
		Step : UINT;
		RequestStatus : UINT;
		InternalStatus : UINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MB_CreateClientRequest (*This function block is used only internally and from the BRSE_MBT library (os other libraries processing the request queue)*)
	VAR_INPUT
		ClientID : USINT;
		ServerFormat : USINT;
		AdrByteBuffer : UDINT; (*Address to byte buffer where to create the request*)
		ByteBufferLen : UINT; (*Length of the byte buffer*)
	END_VAR
	VAR_OUTPUT
		RequestBufferLen : UINT; (*Length of the created modbus request. 0 means that no requests are in queue.*)
		Status : UINT; (*Error code. 0 if successful.*)
		Unit : USINT; (*Unit in the server*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MB_PutClientResponse (*This function block is used only internally and from the BRSE_MBT library (os other libraries processing the request queue)*)
	VAR_INPUT
		ClientID : USINT;
		ServerFormat : USINT;
		AdrByteBuffer : UDINT;
		ByteBufferLen : UINT;
	END_VAR
	VAR_OUTPUT
		Status : UINT;
	END_VAR
	VAR
		ResponseInfo : BRSE_MB_Request_typ;
		Step : UINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION MB_AckClientRequest : UINT (*This function is used only internally and from the BRSE_MBT library (os other libraries processing the request queue)*)
	VAR_INPUT
		ClientID : USINT;
		ReturnStatus : UINT;
	END_VAR
END_FUNCTION
