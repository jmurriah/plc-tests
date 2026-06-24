
FUNCTION inkStateValue : INT (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		inkState : inksStateModes;
	END_VAR
END_FUNCTION

FUNCTION stPIDParamId : REAL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		parPid : stPIDParam;
	END_VAR
END_FUNCTION

FUNCTION timeToStartPWM : BOOL (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		iItemNumber : INT;
		iTotalItems : INT;
		iTaskCycle : UINT; (*Task cycle in ms*)
	END_VAR
	VAR_IN_OUT
		iMsInCycle : UINT;
	END_VAR
END_FUNCTION

FUNCTION stPIDParamToMTPIDParameters : BOOL (*Void function to fill the value of stPIDParam in a  MTPIDParametersType*)
	VAR_INPUT
		pidParam : REFERENCE TO stPIDParam;
		MTPIDparam : REFERENCE TO MTPIDParametersType;
	END_VAR
END_FUNCTION
