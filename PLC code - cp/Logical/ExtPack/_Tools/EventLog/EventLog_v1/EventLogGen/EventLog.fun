
FUNCTION GetSeverity : USINT (*Gets severity from EventId (bits 31-30).*)
	VAR_INPUT
		EventID : DINT;
	END_VAR
END_FUNCTION

FUNCTION GetFacility : UINT (*Gets facility from EventId (bits 27-16).*)
	VAR_INPUT
		EventID : DINT;
	END_VAR
END_FUNCTION

FUNCTION GetCode : UINT (*Gets code from EventId (bits 15-0).*)
	VAR_INPUT
		EventID : DINT;
	END_VAR
END_FUNCTION
