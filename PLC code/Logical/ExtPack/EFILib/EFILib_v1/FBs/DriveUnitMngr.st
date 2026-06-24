
(* Funtion Block to Manage Drive Units from and to the Drive *)
FUNCTION_BLOCK DriveUnitMngr

(*	PositionDesired	REAL	VAR_INPUT
	pulsesDevice	DINT	VAR_INPUT
	TransmissionData	MC_DriveUnitManager	VAR_INPUT
	pulsesPositionDesired	DINT		VAR_OUTPUT
	PositionDevice	REAL		VAR_OUTPUT
	TransDataCopy	MC_DriveUnitManager	
	mmToPulses	REA	VAR

*)

	//RETURN if the FB is not configured
	IF TransmissionData.TransmissionType = TRANS_UNDEFINED THEN
		RETURN;
	END_IF
	
	CASE TransmissionData.TransmissionType OF
		
		TRANS_SCREW_PITCH:
			IF 	TransDataCopy.ScrewPitch.GearBox <> TransmissionData.ScrewPitch.GearBox OR
				TransDataCopy.ScrewPitch.Pitch <> TransmissionData.ScrewPitch.Pitch OR
				TransDataCopy.ScrewPitch.PulsesPerTurn <> TransmissionData.ScrewPitch.PulsesPerTurn
																					THEN
					TransmissionData.ScrewPitch.PulsesPerTurn := MAX(TransmissionData.ScrewPitch.PulsesPerTurn, 2);
					TransmissionData.ScrewPitch.Pitch := MAX(TransmissionData.ScrewPitch.Pitch, 2);
					IF TransmissionData.ScrewPitch.GearBox=0 THEN TransmissionData.ScrewPitch.GearBox:=1; END_IF
					
					mmToTurn := TransmissionData.ScrewPitch.GearBox/TransmissionData.ScrewPitch.Pitch;
					mmToPulses:=UDINT_TO_REAL(TransmissionData.ScrewPitch.PulsesPerTurn)*mmToTurn;
				
					//Initialize the value of the copys to be sure to recalculate after a parameters update
					pulsesDeviceCopy:=1.0E-10;
					PositionDesiredCopy:=1.0E-10;
					HomePositionDesiredCopy:=1.0E-10;
					JogSpeedDesiredCopy:=1.0E-10;
					SpeedDesiredCopy:=1.0E-10;
					AccelerationDesiredCopy:=1.0E-10;
					DecelerationDesiredCopy:=1.0E-10;
					pulsesSpeedDeviceCopy:=1.0E-10;
					RevMinSpeedDeviceCopy:=1.0E-10;
					pulsesAccelerationDeviceCopy:=1.0E-10;
					pulsesDecelerationDeviceCopy:=1.0E-10;
				
			END_IF			

		TRANS_LINEAL_DIAMETER:
			IF 	TransDataCopy.LinealDiameter.GearBox <> TransmissionData.LinealDiameter.GearBox OR
				TransDataCopy.LinealDiameter.Diameter <> TransmissionData.LinealDiameter.Diameter OR
				TransDataCopy.LinealDiameter.PulsesPerTurn <> TransmissionData.LinealDiameter.PulsesPerTurn
																					THEN
					TransmissionData.LinealDiameter.PulsesPerTurn:= MAX(TransmissionData.LinealDiameter.PulsesPerTurn, 2);
					TransmissionData.LinealDiameter.Diameter:= MAX(TransmissionData.LinealDiameter.Diameter, 2);
					IF TransmissionData.LinealDiameter.GearBox=0 THEN TransmissionData.LinealDiameter.GearBox:=1; END_IF
					
					mmToTurn := TransmissionData.LinealDiameter.GearBox/(brmPI*TransmissionData.LinealDiameter.Diameter);				
					mmToPulses:=UDINT_TO_REAL(TransmissionData.LinealDiameter.PulsesPerTurn)*mmToTurn;
					
				
					//Initialize the value of the copys to be sure to recalculate after a parameters update
					pulsesDeviceCopy:=1.0E-10;
					PositionDesiredCopy:=1.0E-10;
					HomePositionDesiredCopy:=1.0E-10;
					JogSpeedDesiredCopy:=1.0E-10;
					SpeedDesiredCopy:=1.0E-10;
					AccelerationDesiredCopy:=1.0E-10;
					DecelerationDesiredCopy:=1.0E-10;
					pulsesSpeedDeviceCopy:=1.0E-10;
					RevMinSpeedDeviceCopy:=1.0E-10;
					pulsesAccelerationDeviceCopy:=1.0E-10;
					pulsesDecelerationDeviceCopy:=1.0E-10;

			END_IF
		
				
		TRANS_LINEAL_PERIMETER:
			IF 	TransDataCopy.LinealPerimeter.GearBox <> TransmissionData.LinealPerimeter.GearBox OR
				TransDataCopy.LinealPerimeter.Perimeter <> TransmissionData.LinealPerimeter.Perimeter OR
				TransDataCopy.LinealPerimeter.PulsesPerTurn <> TransmissionData.LinealPerimeter.PulsesPerTurn
																					THEN
					TransmissionData.LinealPerimeter.PulsesPerTurn:= MAX(TransmissionData.LinealPerimeter.PulsesPerTurn, 2);
					TransmissionData.LinealPerimeter.Perimeter:= MAX(TransmissionData.LinealPerimeter.Perimeter, 2);
					IF TransmissionData.LinealPerimeter.GearBox=0 THEN TransmissionData.LinealPerimeter.GearBox:=1; END_IF
					
					mmToTurn := TransmissionData.LinealPerimeter.GearBox/TransmissionData.LinealPerimeter.Perimeter;
					mmToPulses:=UDINT_TO_REAL(TransmissionData.LinealPerimeter.PulsesPerTurn)*mmToTurn;
					
				
					//Initialize the value of the copys to be sure to recalculate after a parameters update
					pulsesDeviceCopy:=1.0E-10;
					PositionDesiredCopy:=1.0E-10;
					HomePositionDesiredCopy:=1.0E-10;
					JogSpeedDesiredCopy:=1.0E-10;
					SpeedDesiredCopy:=1.0E-10;
					AccelerationDesiredCopy:=1.0E-10;
					DecelerationDesiredCopy:=1.0E-10;
					pulsesSpeedDeviceCopy:=1.0E-10;
					RevMinSpeedDeviceCopy:=1.0E-10;
					pulsesAccelerationDeviceCopy:=1.0E-10;
					pulsesDecelerationDeviceCopy:=1.0E-10;

			END_IF
			

	END_CASE;

	//To avoid NotaNumber messages
	IF mmToPulses=0 THEN
		RETURN;
	END_IF
	
	CASE Calculation OF
		CALC_POS_MM:
			IF pulsesDevice<>pulsesDeviceCopy OR mmToPulsesCopy<>mmToPulses THEN
				PositionDevice:=pulsesDevice/mmToPulses;
				pulsesDeviceCopy:=pulsesDevice;
			END_IF;

		CALC_POS_PULSES:
			IF PositionDesired<>PositionDesiredCopy OR mmToPulsesCopy<>mmToPulses THEN
				pulsesPositionDesired:=PositionDesired*mmToPulses;
				PositionDesiredCopy:=PositionDesired;
			END_IF;
			
		CALC_HOMEPOS_PULSES:
			IF HomePositionDesired<>HomePositionDesiredCopy OR mmToPulsesCopy<>mmToPulses THEN
				pulsesHomePositionDesired:=HomePositionDesired*mmToPulses;
				HomePositionDesiredCopy:=HomePositionDesired;
			END_IF;
			
		CALC_JOGSPEED_PULSES:
			IF JogSpeedDesired<>JogSpeedDesiredCopy OR mmToPulsesCopy<>mmToPulses THEN
				pulsesJogSpeedDesired:=JogSpeedDesired*mmToPulses;
				JogSpeedDesiredCopy:=JogSpeedDesired;
			END_IF;
	
		CALC_SPEED_PULSES:
			IF SpeedDesired<>SpeedDesiredCopy OR mmToPulsesCopy<>mmToPulses THEN
				pulsesSpeedDesired:=SpeedDesired*mmToPulses;
				SpeedDesiredCopy:=SpeedDesired;
			END_IF;
	
		CALC_ACC_PULSES:
			IF AccelerationDesired<>AccelerationDesiredCopy OR mmToPulsesCopy<>mmToPulses THEN
				pulsesAccelerationDesired:=AccelerationDesired*mmToPulses;
				AccelerationDesiredCopy:=AccelerationDesired;
			END_IF;
	
		CALC_ACC_MM:
			IF PulsesAccelerationDevice<>pulsesAccelerationDeviceCopy OR mmToPulsesCopy<>mmToPulses THEN
				mmAcceleration:=PulsesAccelerationDevice/mmToPulses;
				pulsesAccelerationDeviceCopy:=PulsesAccelerationDevice;
			END_IF
			
		CALC_DEC_PULSES:
			IF DecelerationDesired<>DecelerationDesiredCopy OR mmToPulsesCopy<>mmToPulses THEN
				pulsesDecelerationDesired:=DecelerationDesired*mmToPulses;
				DecelerationDesiredCopy:=DecelerationDesired;
			END_IF;
			
		CALC_DEC_MM:
			IF PulsesDecelerationDevice<>pulsesDecelerationDeviceCopy OR mmToPulsesCopy<>mmToPulses THEN
				mmDeceleration:=PulsesDecelerationDevice/mmToPulses;
				pulsesDecelerationDeviceCopy:=PulsesDecelerationDevice;
			END_IF
	
		CALC_SPEED_MMIN_PULSES:
			IF SpeedMminDesired<>SpeedMminDesiredCopy OR mmToPulsesCopy<>mmToPulses THEN
				pulsesSpeedDesired:=SpeedMminDesired*mmToPulses*1000/60; //Converting m/min to mm/s
				SpeedDesiredCopy:=SpeedDesired;
			END_IF;
	
		CALC_SPEED_MMIN:
			IF PulsesSpeedDevice<>pulsesSpeedDeviceCopy OR mmToPulsesCopy<>mmToPulses THEN
				SpeedMminDevice :=PulsesSpeedDevice*60/1000/mmToPulses;
				pulsesSpeedDeviceCopy:=PulsesSpeedDevice;
			END_IF;

		CALC_SPEED_MM:
			IF PulsesSpeedDevice<>pulsesSpeedDeviceCopy OR mmToPulsesCopy<>mmToPulses THEN
				SpeedDevice :=PulsesSpeedDevice/mmToPulses;
				pulsesSpeedDeviceCopy:=PulsesSpeedDevice;
			END_IF;
		
		CALC_SPEED_REVMIN_MMIN:
			IF RevMinSpeedDevice<>RevMinSpeedDeviceCopy OR mmToPulsesCopy<>mmToPulses THEN
				SpeedRpmToMmin :=RevMinSpeedDevice/mmToTurn/1000; //1000 to convert mm in meters
				RevMinSpeedDeviceCopy:=RevMinSpeedDevice;
			END_IF
	
	END_CASE
	
	TransDataCopy:=TransmissionData;
	mmToPulsesCopy:=mmToPulses;
	
END_FUNCTION_BLOCK
