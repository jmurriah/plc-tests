
(* Load initial script for PLC. VOID *)
FUNCTION PLC_Init
	
	//PLC String name creation
	plcStruct.sVersion := 'PLC v';
	brsitoa(plcStruct.iVersion0, ADR(strAux));
	brsstrcat(ADR(plcStruct.sVersion), ADR(strAux));
	strAux := '.';
	brsstrcat(ADR(plcStruct.sVersion), ADR(strAux));
	brsitoa(plcStruct.iVersion1, ADR(strAux));
	brsstrcat(ADR(plcStruct.sVersion), ADR(strAux));
	strAux := '.';
	brsstrcat(ADR(plcStruct.sVersion), ADR(strAux));
	brsitoa(plcStruct.iVersion2, ADR(strAux));
	brsstrcat(ADR(plcStruct.sVersion), ADR(strAux));
	strAux := '.';
	brsstrcat(ADR(plcStruct.sVersion), ADR(strAux));
	brsitoa(plcStruct.iVersion3, ADR(strAux));
	brsstrcat(ADR(plcStruct.sVersion), ADR(strAux));

	PLC_Init := TRUE;
	
END_FUNCTION
