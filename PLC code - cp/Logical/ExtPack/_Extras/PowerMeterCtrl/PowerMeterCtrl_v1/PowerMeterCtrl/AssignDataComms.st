
ACTION AssignDataComms:
	
	
	//Active modbus slave diagnosis when module ok (cable plugged). To set to false just unplug de cable
	IF PowerMeter.Status.Comms.xModuleOk THEN
		PowerMeter.Parameters.xActiveSlaveDiagnosis := TRUE; //1: Diagnosis enabled; 0=Reset diagnosis historic
	END_IF
	
	
	////////////////
	//Read Registers
	
	//Current
	IF PowerMeter.Status.Comms.xModuleOk THEN
		PowerMeter.Inputs.Comms.EffectiveCurrentPhaseA := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[16];
		PowerMeter.Inputs.Comms.EffectiveCurrentPhaseB := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[17];
		PowerMeter.Inputs.Comms.EffectiveCurrentPhaseC := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[18];
		PowerMeter.Inputs.Comms.EffectiveCurrentNeutral := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[19];
		PowerMeter.Inputs.Comms.MaxCurrentAllPhases := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[20];
		PowerMeter.Inputs.Comms.IgEarthDefectiveCurrent := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[21];
		PowerMeter.Inputs.Comms.CurrentDifferential := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[22];
		PowerMeter.Inputs.Comms.MaxEffectiveCurrentPhaseA := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[23];
		PowerMeter.Inputs.Comms.MaxEffectiveCurrentPhaseB := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[24];
		PowerMeter.Inputs.Comms.MaxEffectiveCurrentPhaseC := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[25];
		PowerMeter.Inputs.Comms.MaxEffectiveCurrentNeutral := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[26];
		
		//Frequency
		PowerMeter.Inputs.Comms.MaxIgEarthDefectiveCurrent := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[28];
		PowerMeter.Inputs.Comms.MaxCurrentDifferential := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[29];
		
		//Voltage
		PowerMeter.Inputs.Comms.EffectiveVoltagePhasesAB := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[30];
		PowerMeter.Inputs.Comms.EffectiveVoltagePhasesBC := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[31];
		PowerMeter.Inputs.Comms.EffectiveVoltagePhasesCA := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[32];
		PowerMeter.Inputs.Comms.EffectiveVoltagePhasesAN := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[33];
		PowerMeter.Inputs.Comms.EffectiveVoltagePhasesBN := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[34];
		PowerMeter.Inputs.Comms.EffectiveVoltagePhasesCN := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[35];
		PowerMeter.Inputs.Comms.Frequency := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[36]/10;
		PowerMeter.Inputs.Comms.FrequencyMax := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[37]/10;
		
		//Power
		PowerMeter.Inputs.Comms.ActivePowerPhaseA := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[38];
		PowerMeter.Inputs.Comms.ActivePowerPhaseB := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[39];
		PowerMeter.Inputs.Comms.ActivePowerPhaseC := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[40];
		PowerMeter.Inputs.Comms.TotalActivePower := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[41];
		PowerMeter.Inputs.Comms.ApparentPowerPhaseA := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[42];
		PowerMeter.Inputs.Comms.ApparentPowerPhaseB := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[43];
		PowerMeter.Inputs.Comms.ApparentPowerPhaseC := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[44];
		PowerMeter.Inputs.Comms.TotalApparentPower := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[45];
		PowerMeter.Inputs.Comms.ReactivePowerPhaseA := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[46];
		PowerMeter.Inputs.Comms.ReactivePowerPhaseB := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[47];
		PowerMeter.Inputs.Comms.ReactivePowerPhaseC := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[48];
		PowerMeter.Inputs.Comms.TotalReactivePower := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[49];
		
		//Total Harmonic Distortion) (THD)
		PowerMeter.Inputs.Comms.THDVoltageAB := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[104];
		PowerMeter.Inputs.Comms.THDVoltageBC := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[105];
		PowerMeter.Inputs.Comms.THDVoltageCA := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[106];
		PowerMeter.Inputs.Comms.THDVoltageAN := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[107];
		PowerMeter.Inputs.Comms.THDVoltageBN := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[108];
		PowerMeter.Inputs.Comms.THDVoltageCN := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[109];
		PowerMeter.Inputs.Comms.THDCurrentA := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[110];
		PowerMeter.Inputs.Comms.THDCurrentB := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[111];
		PowerMeter.Inputs.Comms.THDCurrentC := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[112];
		PowerMeter.Inputs.Comms.TotalTHDCurrent := PowerMeter.Inputs.Comms.ReceivedDataModPowerMeter[113];
	END_IF
	
	
END_ACTION
