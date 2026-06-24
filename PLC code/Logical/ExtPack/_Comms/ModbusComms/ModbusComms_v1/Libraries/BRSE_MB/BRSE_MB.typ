
TYPE
	BRSE_MB_ServerUnit_typ : 	STRUCT 
		pDiscreteInputs : UDINT; (*address to array of variable addresses, dynamically allocated*)
		pCoils : UDINT;
		pInputRegisters : UDINT;
		pHoldingRegisters : UDINT;
		MaxCoils : UINT; (*(Sizes need to be saved for error handling purposes)*)
		MaxHoldingRegisters : UINT;
		MaxDiscreteInputs : UINT;
		MaxInputRegisters : UINT;
	END_STRUCT;
	BRSE_MB_ServerCfg_typ : 	STRUCT 
		Unit : ARRAY[0..255] OF BRSE_MB_ServerUnit_typ;
	END_STRUCT;
	BRSE_MB_Request_typ : 	STRUCT 
		Unit : USINT; (*Unit in server*)
		Type : USINT; (*Modbus function code*)
		StartAddr : UINT; (*Reference, where to begin reading/writing*)
		Quantity : UINT; (*Number of items to be read/written*)
	END_STRUCT;
	MB_ClientStruct_typ : 	STRUCT 
		pClients : ARRAY[0..255] OF UDINT; (*Clients[ClientID] holds the address to an instance of MB_Client_typ (i.e. the request queue) of that ClientID*)
	END_STRUCT;
	MB_ClientQueueItem_typ : 	STRUCT 
		Request : BRSE_MB_Request_typ;
		VariableAddr : UDINT; (*Address where to begin reading/writing variables*)
		StatusAddr : UDINT; (*Address of the status register, where to tell when request has been executed and/or error code.*)
	END_STRUCT;
	MB_Client_typ : 	STRUCT 
		Queue : ARRAY[0..MB_QUEUE_SIZE] OF MB_ClientQueueItem_typ;
		IndexExec : UINT; (*Next request in queue to be executed*)
		IndexInsert : UINT; (*Where to insert the next queued request*)
		Lock : BOOL;
	END_STRUCT;
END_TYPE
