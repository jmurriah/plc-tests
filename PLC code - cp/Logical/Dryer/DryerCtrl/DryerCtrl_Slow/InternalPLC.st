
ACTION versionPLC:

    // Version
	gPLC.iVersion0:= 1;
	gPLC.iVersion1:= 67;	// Refactoring
	gPLC.iVersion2:= 394; 	// Updated ExtPack
	gPLC.iVersion3:= 187;

END_ACTION

	
ACTION InternalPLC:

	// PLC VARS
	IF gPLC.diCycleTime =0 THEN
		RTInfo_0(enable := TRUE);
		gPLC.diCycleTime:=RTInfo_0.cycle_time;  // Is a fix cycle time
		gPLC.xFirst_Scan:= RTInfo_0.init_reason=-1 OR RTInfo_0.init_reason=1 OR RTInfo_0.init_reason=2 OR RTInfo_0.init_reason=3;
		gPLC.xColdRestart:= RTInfo_0.init_reason=1;
		gPLC.xWarmRestart:= RTInfo_0.init_reason=2;
		gPLC.xDownloadRestart:= RTInfo_0.init_reason=3;

	ELSIF gPLC.xFirst_Scan THEN
		gPLC.xFirst_Scan:= FALSE;
		gPLC.xColdRestart:= FALSE;
		gPLC.xWarmRestart:= FALSE;
		gPLC.xDownloadRestart:= FALSE;
	END_IF
		
	
	//BLINK
	Blink_100ms.T_Blink:=T#100MS;
	Blink_100ms();
	gPLC.xBlk_100ms:= Blink_100ms.Out;

	Blink_200ms.T_Blink:=T#200MS;
	Blink_200ms();
	gPLC.xBlk_200ms:= Blink_200ms.Out;
	
	Blink_500ms.T_Blink:=T#500MS;
	Blink_500ms();
	gPLC.xBlk_500ms:= Blink_500ms.Out;
	
	Blink_1s.T_Blink:=T#1S;
	Blink_1s();
	gPLC.xBlk_1s:= Blink_1s.Out;
	
	Blink_2s.T_Blink:=T#2S;
	Blink_2s();
	gPLC.xBlk_2s:= Blink_2s.Out;
	
	Blink_5s.T_Blink:=T#5S;
	Blink_5s();
	gPLC.xBlk_5s:= Blink_5s.Out;
	 
	// License counter	and  Keep alive
	IF EDGEPOS(gPLC.xBlk_1s) THEN
		gDryer.St.uiLicenseCounter:= gDryer.St.uiLicenseCounter+1;
	END_IF;
	
	//Setting Serial Name of the PLC
	setSerialNumber;
	
END_ACTION

ACTION setSerialNumber:

    // If the PLC has version, return
	IF brsstrlen(ADR(gDryer.St.HwData.SerialNumber)) > 0 THEN
		RETURN;
	END_IF
	
	IF EDGEPOS(gDryer.commands.SerialNumber.xExecute) THEN
		brsstrcpy(ADR(gDryer.St.HwData.SerialNumber),ADR(gDryer.commands.SerialNumber.SerialNumber));
		gDryer.commands.SerialNumber.xExecute := FALSE;
	END_IF

END_ACTION
