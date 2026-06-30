(*********************************************************************
* Drive Unit Manager
*********************************************************************)

TYPE
	MD_CalculationType : 
		(
		CALC_HOMEPOS_PULSES,
		CALC_HOMEPOS_MM, (*Position in mm*)
		CALC_JOGSPEED_PULSES,
		CALC_JOGSPEED_MM, (*JogSpeed in mm/s*)
		CALC_SPEED_MMIN_PULSES,
		CALC_SPEED_MMIN, (*Speed in m/min*)
		CALC_SPEED_PULSES,
		CALC_SPEED_MM, (*Speed in mm/s*)
		CALC_SPEED_REVMIN_MMIN,
		CALC_POS_PULSES,
		CALC_POS_MM, (*Position in mm*)
		CALC_ACC_PULSES,
		CALC_ACC_MM, (*Acceleration in mm/s^2*)
		CALC_DEC_PULSES,
		CALC_DEC_MM (*Deceleration in mm/s^2*)
		);
	MD_TransmissionType : 
		(
		TRANS_UNDEFINED,
		TRANS_SCREW_PITCH,
		TRANS_LINEAL_DIAMETER,
		TRANS_LINEAL_PERIMETER
		);
	MC_TransLinealDiameter_typ : 	STRUCT 
		PulsesPerTurn : UDINT; (*Units considered by the drive for 1 turn*)
		GearBox : REAL; (*Reduction :1*)
		Diameter : REAL; (*Diameter in mm*)
	END_STRUCT;
	MC_TransLinealPerimeter_typ : 	STRUCT 
		PulsesPerTurn : UDINT; (*Units considered by the drive for 1 turn*)
		GearBox : REAL; (*Reduction :1*)
		Perimeter : REAL; (*Perimeter in mm*)
	END_STRUCT;
	MC_TransScrewPitch_typ : 	STRUCT 
		PulsesPerTurn : UDINT; (*Units considered by the drive for 1 turn*)
		GearBox : REAL; (*Reduction :1*)
		Pitch : REAL; (*Pitch in mm*)
	END_STRUCT;
	MC_DriveUnitManager : 	STRUCT 
		TransmissionType : MD_TransmissionType := TRANS_UNDEFINED; (*Used to avoid problems if DriveUnit is executed but not configured*)
		LinealDiameter : MC_TransLinealDiameter_typ;
		LinealPerimeter : MC_TransLinealPerimeter_typ;
		ScrewPitch : MC_TransScrewPitch_typ;
	END_STRUCT;
	AnalogProcessSimType_enum : 
		(
		ANALOGSIM_LINEAR_POS, (*If no action, the signal raises*)
		ANALOGSIM_LINEAR_NEG, (*If no action, the signal goes down*)
		ANALOGSIM_EXPONENTIAL_POS, (*If no action, the signal raises*)
		ANALOGSIM_EXPONENTIAL_NEG (*If no action, the signal goes down*)
		);
END_TYPE
