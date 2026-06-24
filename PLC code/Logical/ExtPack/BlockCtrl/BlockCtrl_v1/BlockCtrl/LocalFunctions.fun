
{REDUND_ERROR} FUNCTION InkBarInBlock : BOOL (*This function returns if the bar determined by the index is in the current block*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		InkIndex : USINT;
		inksArr : REFERENCE TO ARRAY[0..12] OF stInks;
		Block : REFERENCE TO StBlock;
		gIndexBlock : USINT;
	END_VAR
END_FUNCTION

FUNCTION AllDevicedHomed : BOOL
	VAR_INPUT
		Block : REFERENCE TO StBlock;
	END_VAR
END_FUNCTION

FUNCTION AllDevicedStopped : BOOL
	VAR_INPUT
		Block : REFERENCE TO StBlock;
		AxisBK : REFERENCE TO AxisCtrl_typ;
		IclaBK : REFERENCE TO stIcla;
	END_VAR
END_FUNCTION
