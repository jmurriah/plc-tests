
ACTION InternalPLC:

	// PLC VARS
	IF gPLC.diCycleTime =0 THEN
		gPLC.Internal.RestartInfo(enable := TRUE);
		gPLC.diCycleTime:=gPLC.Internal.RestartInfo.cycle_time;  // Is a fix cycle time
		
		gPLC.xColdRestart:= gPLC.Internal.RestartInfo.init_reason=1;
		gPLC.xWarmRestart:= gPLC.Internal.RestartInfo.init_reason=2;
		gPLC.xDownloadRestart:= gPLC.Internal.RestartInfo.init_reason=3;
		
		gPLC.xFirst_Scan :=	gPLC.Internal.RestartInfo.init_reason=-1 OR gPLC.xColdRestart OR gPLC.xWarmRestart OR gPLC.xDownloadRestart;

		gPLC.Internal.RestartInfo(enable := FALSE);

	ELSIF gPLC.xFirst_Scan THEN
		gPLC.xFirst_Scan:= FALSE;
		gPLC.xColdRestart:= FALSE;
		gPLC.xWarmRestart:= FALSE;
		gPLC.xDownloadRestart:= FALSE;
	END_IF
		
	
	//BLINK
	gPLC.Internal.Blink_100ms.T_Blink:=T#100MS;
	gPLC.Internal.Blink_100ms();
	gPLC.xBlk_100ms:= gPLC.Internal.Blink_100ms.Out;

	gPLC.Internal.Blink_200ms.T_Blink:=T#200MS;
	gPLC.Internal.Blink_200ms();
	gPLC.xBlk_200ms:= gPLC.Internal.Blink_200ms.Out;
	
	gPLC.Internal.Blink_500ms.T_Blink:=T#500MS;
	gPLC.Internal.Blink_500ms();
	gPLC.xBlk_500ms:= gPLC.Internal.Blink_500ms.Out;
	
	gPLC.Internal.Blink_1s.T_Blink:=T#1S;
	gPLC.Internal.Blink_1s();
	gPLC.xBlk_1s:= gPLC.Internal.Blink_1s.Out;
	
	gPLC.Internal.Blink_2s.T_Blink:=T#2S;
	gPLC.Internal.Blink_2s();
	gPLC.xBlk_2s:= gPLC.Internal.Blink_2s.Out;
	
	gPLC.Internal.Blink_5s.T_Blink:=T#5S;
	gPLC.Internal.Blink_5s();
	gPLC.xBlk_5s:= gPLC.Internal.Blink_5s.Out;
	
	gPLC.Internal.Blink_10s.T_Blink:=T#10S;
	gPLC.Internal.Blink_10s();
	gPLC.xBlk_10s:= gPLC.Internal.Blink_10s.Out;
	 
	// License counter	and  Keep alive
	IF EDGEPOS(gPLC.xBlk_1s) THEN
		gMachine.St.uiLicenseCounter:= gMachine.St.uiLicenseCounter+1;
		gMachine.St.iFaultRunPlc:= gMachine.St.iFaultRunPlc+1;
	END_IF;
	
END_ACTION

ACTION resetPLC:

    // Version
	IF gMachine.commands.ResetCpu.AutorizationCode <> 'h98o76' THEN
		RETURN;
	END_IF
	
	IF EDGEPOS(gMachine.commands.ResetCpu.xExecuteReset) THEN
		statusReset := SYSreset(enable:= TRUE, mode:= 2);
	END_IF

END_ACTION

ACTION setSerialNumber:

    // If the PLC has version, return
	IF brsstrlen(ADR(gMachine.St.HwData.SerialNumber)) > 0 THEN
		RETURN;
	END_IF
	
	IF EDGEPOS(gMachine.commands.SerialNumber.xExecute) THEN
		brsstrcpy(ADR(gMachine.St.HwData.SerialNumber),ADR(gMachine.commands.SerialNumber.SerialNumber));
		gMachine.commands.SerialNumber.xExecute := FALSE;
	END_IF

END_ACTION