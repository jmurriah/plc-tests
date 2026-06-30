PROGRAM _INIT

	dataNir ACCESS ADR(gNirAdphos);

	dataNir.Signals.In.xSafetyOK := TRUE;
	
	dataNir.Parameters.iTotalModules:= 2;

	dataNir.Parameters.Comms.AdjPos := 0;
	dataNir.Parameters.Comms.Pstart := 0;
	dataNir.Parameters.Comms.Pend := 100;
	dataNir.Parameters.Comms.Vstart := 0;
	dataNir.Parameters.Comms.Vend := 100;

	dataNir.Parameters.Comms.Modules[1].EnableMod := TRUE;
	dataNir.Parameters.Comms.Modules[1].Adjust := 0;
	dataNir.Parameters.Comms.Modules[2].EnableMod := TRUE;
	dataNir.Parameters.Comms.Modules[2].Adjust := 0;
	
	dataNir.Status.xCommsOK := TRUE;

	iMaxTemperature := 500;
	iMinTemperature := 250;
	
END_PROGRAM


PROGRAM _CYCLIC
	(* Insert code here *)
	dataNir ACCESS ADR(gNirAdphos);
	SimNirAdphos ACCESS ADR(gSimNirAdphos);
	
	tonReady.IN := dataNir.State = NIRADPEW_RUNNING_BELT;
	tonReady.PT:= T#1s;
	tonReady();
	IF tonReady.Q THEN
		dataNir.Signals.In.xReady := TRUE;
	END_IF
	
	tonDry.IN:= dataNir.Signals.Out.xProcess;
	tonDry.PT:= T#1s;
	tonDry();
	IF tonDry.Q THEN
		dataNir.Signals.In.xInProcess := TRUE;
	END_IF

	FOR iIndexModule := 1 TO dataNir.Parameters.iTotalModules DO
		IF dataNir.Signals.Out.xPowerOn THEN
			
			rModulePowerSetPoint := dataNir.Status.rPowerSetPoint * (1 + INT_TO_REAL(dataNir.Parameters.Comms.Modules[iIndexModule].Adjust)/100);
			rModulePowerSetPoint := MIN(rModulePowerSetPoint, 100);
			
			IF dataNir.Parameters.Comms.Modules[iIndexModule].EnableMod AND rModulePower[iIndexModule]  < rModulePowerSetPoint THEN
				rModulePower[iIndexModule] := MIN(rModulePower[iIndexModule] + POWER_VARIATION, rModulePowerSetPoint);
			ELSE
				rModulePower[iIndexModule] := MAX(rModulePower[iIndexModule] - POWER_VARIATION, rModulePowerSetPoint);
			END_IF
			
			IF dataNir.Parameters.Comms.Modules[iIndexModule].EnableMod AND dataNir.Signals.In.iSurfaceTempModuleRaw[iIndexModule]  < iMaxTemperature THEN
				IF tonDelayTemp.Q THEN dataNir.Signals.In.iSurfaceTempModuleRaw[iIndexModule] := MIN(dataNir.Signals.In.iSurfaceTempModuleRaw[iIndexModule] + 1, iMaxTemperature); END_IF
			ELSE
				IF tonDelayTemp.Q THEN dataNir.Signals.In.iSurfaceTempModuleRaw[iIndexModule] := MAX(dataNir.Signals.In.iSurfaceTempModuleRaw[iIndexModule] - 1, iMinTemperature); END_IF
			END_IF
			
			//NIR Module Status
			IF dataNir.Parameters.Comms.Modules[iIndexModule].EnableMod THEN
				IF dataNir.Signals.Out.xProcess THEN
					dataNir.Status.Comms.Modules[iIndexModule].iNirStatus := 4;
				ELSE
					dataNir.Status.Comms.Modules[iIndexModule].iNirStatus := 2;
				END_IF
			ELSE
				dataNir.Status.Comms.Modules[iIndexModule].iNirStatus := 0;
			END_IF
		ELSE
			rModulePower[iIndexModule] := MAX(rModulePower[iIndexModule] - POWER_VARIATION, 0);
			IF tonDelayTemp.Q THEN dataNir.Signals.In.iSurfaceTempModuleRaw[iIndexModule] := MAX(dataNir.Signals.In.iSurfaceTempModuleRaw[iIndexModule] - 1, iMinTemperature); END_IF

			dataNir.Status.Comms.Modules[iIndexModule].iNirStatus := 0;
		END_IF	  

		dataNir.Status.Comms.Modules[iIndexModule].Power := REAL_TO_INT(rModulePower[iIndexModule]);
		dataNir.Status.Comms.Modules[iIndexModule].xPowered := dataNir.Signals.Out.xPowerOn AND dataNir.Parameters.Comms.Modules[iIndexModule].EnableMod;
	END_FOR;
	
	tonDelayTemp.IN := NOT tonDelayTemp.Q;
	IF dataNir.Signals.Out.xProcess THEN
		tonDelayTemp.PT := t#200ms;
	ELSIF dataNir.Signals.Out.xPowerOn THEN
			tonDelayTemp.PT := t#1s;
	ELSE
		tonDelayTemp.PT := t#2s;
	END_IF
	tonDelayTemp();
	
	
	tonPowerOn.IN:= dataNir.Signals.Out.xPowerOn;
	tonPowerOn.PT:= T#1s;
	tonPowerOn();
	IF tonPowerOn.Q THEN
		//dataNir.Status.Comms.xPowered := TRUE;
	END_IF

	
	iReasonBeltRunning.0 := dataNir.State = NIRADPEW_POWERED;
	iReasonBeltRunning.1 := dataNir.State = NIRADPEW_RUNNING_BELT;
	iReasonBeltRunning.2 := dataNir.State = NIRADPEW_READY;
	iReasonBeltRunning.3 := dataNir.State = NIRADPEW_STARTING;
	iReasonBeltRunning.4 := dataNir.State = NIRADPEW_RUNNING;
	
	IF iReasonBeltRunning > 0 THEN
		dataNir.Status.Comms.Speed := SimNirAdphos.Parameters.CurrentSpeed;
	ELSE
		dataNir.Status.Comms.Speed := 0;
	END_IF	
	
	IF EDGEPOS(dataNir.State = NIRADPEW_IDLE) THEN
		dataNir.Signals.In.xFault := FALSE;
		dataNir.Signals.In.xInProcess := FALSE;
		dataNir.Signals.In.xReady := FALSE;
		dataNir.Signals.In.xSafetyOK := TRUE;
		dataNir.Status.Comms := StatusCommsReseted;
	END_IF
	
	
	// It is working because comms are executed after AlarmSummary
	dataNir.Alarms.xOpcUaWriteError[1] := FALSE;
	dataNir.Alarms.xOpcUaWriteError[2] := FALSE;
	
END_PROGRAM