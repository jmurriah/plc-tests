
ACTION AlarmsSlow: 

	gMachine.St.Blocks.xAnyBarAndBlockReadyToPrint	:= 	(gBlock[1].parSw.xEnableToPrint AND gBlock[1].Status.iBarsReadyToPrint>0) OR
														(gBlock[2].parSw.xEnableToPrint AND gBlock[2].Status.iBarsReadyToPrint>0);
	
	// Alarm: Not Bars Enabled. It cannot be removed because is stopping printer if you want print and there is not bar recirculationg
	gMachine.Al.Alarm.xAlarmEnableWithoutBarsOn := 	gMachine.St.Mode.xAuto AND 
													NOT gMachine.St.AutoMode.xBypass AND 
													NOT gMachine.St.AutoMode.xLaboratory AND
													NOT gMachine.St.Blocks.xAnyBarAndBlockReadyToPrint;

	// Alarm: Platform Incoherence 
	gMachine.Al.Alarm.xAlarmPlarformInc:= (gMachine.Pt.MachineModel=NoType) AND NOT gMachine.St.Mode.xZero;
	
	//Alarm: Thickness detection system no selected or selected more than one
	gMachine.Al.Alarm.xAlrThicknSystemNotSelected := NOT gPhotoCells.status.xInstalled AND NOT gDing.State.xDingInstalled;
	
	
	//**********
	//UPS Alarms
	//**********	 

	// Warning: SAI System Fault 
	gMachine.Al.Warning.xSAIFault:= gMachine.In.UPSs[1].xSystemFault OR gMachine.In.UPSs[2].xSystemFault;

	// Warning: SAI ByPass
	gMachine.Al.Warning.xSAIBypass:= 	gMachine.In.UPSs[1].xByPass OR
										gMachine.In.UPSs[2].xByPass OR
										gLine.Inputs.UPSs[1].xByPass OR
										gLine.Inputs.UPSs[2].xByPass;

	// Warning: SAI Low Bat
	gMachine.Al.Warning.xSAILowBat:= 	gMachine.In.UPSs[1].xLowBattery OR
										gMachine.In.UPSs[2].xLowBattery OR
										gLine.Inputs.UPSs[1].xLowBattery OR
										gLine.Inputs.UPSs[2].xLowBattery;
	
	// Alarm: SAI VAC Fault
	tonUpsPowerFault.IN:=	gMachine.In.UPSs[1].xPowerFault OR
							gMachine.In.UPSs[2].xPowerFault OR
							gLine.Inputs.UPSs[1].xPowerFault OR
							gLine.Inputs.UPSs[2].xPowerFault;
	
	tonUpsPowerFault.PT:=t#20s;
	tonUpsPowerFault();
	IF tonUpsPowerFault.Q THEN gMachine.Al.Alarm.xAlarmSAIPowerFault := TRUE; END_IF;
		
	gMachine.Al.Alarm.xNoPowered := NOT gMachine.In.xPowerSwitch;
	
	//Alarm: Colision Danger, no action
	gMachine.Al.Alarm.xNoActionDangerCollision := gBlock[1].Al.xNoActionDangerCollision OR gBlock[2].Al.xNoActionDangerCollision;
	
	//Critical Ink alarm summary
	xAnyInkCriticalAlrm:=FALSE;
	//To acknowledge if any ink bar is loaded in job. There have been several cases where "gMachine.St.xRobotReadyToPrint" is active but no ink bar's status "ColorLoadedInJob" is active
	xAnyBarLoadedInJob:=FALSE;
	FOR iIndex:=1 TO MAX_LAST_INK BY 1 DO
		IF gInks[iIndex].AlSummary.xAlarmCritical THEN xAnyInkCriticalAlrm := TRUE; END_IF
		IF gInks[iIndex].status.xColorLoadedInJob THEN xAnyBarLoadedInJob := TRUE; END_IF
	END_FOR
	
	//////// WARNING xNotLoadedImage
	IF gMachine.parSw.Dtp.xDoubleLine THEN
		IF NOT gThicknessCtrl.status.xNewMediaStackEnabled THEN
			gMachine.St.xRobotReadyToPrint := (gMachine.parSw.Dtp.iModeLine1=GC_DTP_RUN AND gMachine.parSw.Electronics.xRobotReadyL1) OR (gMachine.parSw.Dtp.iModeLine2=GC_DTP_RUN AND gMachine.parSw.Electronics.xRobotReadyL2);
		ELSE
			gMachine.St.xRobotReadyToPrint :=	(gMachine.parSw.Dtp.iModeLine1=GC_DTP_RUN AND gMachine.parSw.Electronics.xRobotReadyL1 AND gThicknessCtrl.status.Stack.iNewMediaLoadedL1 > 0) OR 
												(gMachine.parSw.Dtp.iModeLine2=GC_DTP_RUN AND gMachine.parSw.Electronics.xRobotReadyL2 AND gThicknessCtrl.status.Stack.iNewMediaLoadedL2 > 0) ;
		END_IF
	ELSE
		IF NOT gThicknessCtrl.status.xNewMediaStackEnabled THEN
			gMachine.St.xRobotReadyToPrint := gMachine.parSw.Electronics.xRobotReadyL1;
		ELSE
			gMachine.St.xRobotReadyToPrint := gMachine.parSw.Electronics.xRobotReadyL1 AND gThicknessCtrl.status.Stack.iNewMediaLoadedL1 > 0;
		END_IF
	END_IF
	
	IF EDGEPOS(gMachine.parSw.Electronics.xRobotReadyL1) THEN
		LogImageLoadedL1;
	ELSIF EDGENEG(gMachine.parSw.Electronics.xRobotReadyL1) THEN
		LogImageUnLoadedL1;
	END_IF
	
	
	//RAISING THE ALARM
	//[RGP] gMachine.St.xMediaDetected variable replaced by "MediaFiltered" to avoid to active "ImageNotLoaded" alarm when belt is not cleaned
	IF gMachine.St.AutoMode.xProdORLab AND gThicknessCtrl.Outputs.xMediaFiltered AND gBelt.states.xRuningBelt AND NOT gLine.StatusSummary.xEmptyingBelts THEN
		IF NOT gMachine.St.xRobotReadyToPrint THEN
			IF gMachine.Pt.xJobNotReadyIsCritical THEN
				gMachine.Al.Alarm.xNotLoadedImage:= TRUE;
			ELSE
				gMachine.Al.Warning.xNotLoadedImage:= TRUE;
			END_IF
			
		ELSE
			//Due to issue CUBE-1197
			IF NOT xAnyBarLoadedInJob THEN
				gMachine.Al.Warning.xImageLoadedButNoInkBarRelated:= TRUE;
			END_IF
		END_IF
	END_IF
	
	//IF State is not RUN, remove alarm
	IF (gMachine.St.AutoMode.xProdORLab AND gMachine.parSw.Dtp.iModeLine1<>GC_DTP_RUN AND gMachine.parSw.Dtp.iModeLine2<>GC_DTP_RUN) THEN
		gMachine.Al.Warning.xNotLoadedImage:= FALSE;
	END_IF
	
	//IF Robot is OK or not in Production or Laboratory , remove alarm 
	IF gMachine.St.xRobotReadyToPrint OR (NOT gMachine.St.AutoMode.xProdORLab AND gMachine.Pt.xControlledByLine) THEN
		gMachine.Al.Warning.xNotLoadedImage:= FALSE;
	END_IF			

	IF EDGEPOS(gMachine.Al.Warning.xNotLoadedImage) THEN
		LogAlarmImageNotLoaded;
	END_IF
	
	IF EDGEPOS(gMachine.Al.Warning.xImageLoadedButNoInkBarRelated) THEN
		LogAlarmImageLoadedButNoInkBarRelated;
	END_IF
	
	
	// Warning: Max movemets because bent tile	// Warning: Max movemets because bent tile		
	// Warning: Max movemets because bent tile	// Warning: Max movemets because bent tile		
	IF EDGEPOS (gMachine.Al.Warning.xBentTile) THEN
		iBentTilesCounter := iBentTilesCounter + 1;
	END_IF	

	//If time without any change, decrease the count of movements
	tonDecreaseMovCount.IN := NOT gMachine.Al.Warning.xMaxMovsBentTile AND NOT gMachine.Al.Warning.xBentTile AND NOT tonDecreaseMovCount.Q ;
	tonDecreaseMovCount.PT := T#5m;
	tonDecreaseMovCount();
	IF tonDecreaseMovCount.Q THEN
		//Safety decrease to avoid overflow
		iBentTilesCounter:= UINT_SUB(iBentTilesCounter,1);
	END_IF
	IF EDGEPOS(gMachine.Al.Warning.xMaxMovsBentTile) THEN
		iBentTilesCounter:= 0;
	END_IF

	IF iBentTilesCounter >= gc_diNumMaxManiobrasPDoblada THEN 
		gMachine.Al.Warning.xMaxMovsBentTile:=TRUE; 
	ELSIF  gMachine.AutoCmd.xReset THEN
		gMachine.Al.Warning.xMaxMovsBentTile:=FALSE; 
	END_IF
	

	// Warning: External Cleaning Activate
	IF gMachine.St.Mode.xAuto AND gMachine.AutoCmd.xCleanningByExtOrder AND NOT gMachine.St.AutoMode.xLaboratory THEN
		gMachine.Al.Warning.xExternalCleanActive:= TRUE;
		
	ELSIF NOT gMachine.St.Mode.xAuto OR (gMachine.St.Cleaning.enCleaningState = CLN_NOT_CLEANING) THEN
		gMachine.Al.Warning.xExternalCleanActive:= FALSE;
	END_IF	

	
	// PC Cabinet Cooling Sensor Alarm
	tonPCCabinetAlrm.IN:= gMachine.In.xCoolingPCSensorAlrm;
	tonPCCabinetAlrm.PT:= T#30S;
	tonPCCabinetAlrm();
	gMachine.Al.Warning.xPCCabineSensAlrm := tonPCCabinetAlrm.Q;


	// Alarm Air1
	T_AlarmAir1.IN:= NOT gMachine.In.xAirSupply AND gBlockInputs[1].xSiUnitModuleOk;
	T_AlarmAir1.PT:= gc_tiTesperaAlarmaAire;
	T_AlarmAir1();
	gMachine.Al.Alarm.xAlarmAir1:= T_AlarmAir1.Q;
	
	
	//Alarm: Heater Tank Power Supply Failure
	IF NOT gMachine.In.xTankHeaterPsuOK AND gMachine.St.Blocks.xAnyTankHeaterEnabled THEN
		gMachine.Al.Alarm.xHeaterTankPsu:= TRUE;
		FOR iIndexInks := 1 TO MAX_LAST_INK BY 1 DO gInks[iIndexInks].Al.xAlrHeaterTankPsu := TRUE; END_FOR
	END_IF

	// Raising alarm of stopped media inside.
	// this is a simple way to reset the alarm. A more proper way to remove the alarm would be to
	// use a distanceVar in Thickness_Pos, but this is quite resource consuming, so this would be delayed
	IF gThicknessCtrl.status.MediaPosition.xMediaInside AND NOT gBelt.states.xRuningBelt AND EDGEPOS(gMachine.AutoCmd.xToSafePosition) THEN
		gMachine.Al.Warning.xMediaStoppedInside := TRUE;
	ELSIF gThicknessCtrl.status.Belt.xBeltEmpty THEN
		gMachine.Al.Warning.xMediaStoppedInside := FALSE;
	END_IF
	
	
	// Alarm: xUpNotConsent	
	gMachine.Al.Warning.xUpNotConsent:= gMachine.St.Consent.xUpWithNoConsent;
	
	// Warning: PBF card Not OK
	gMachine.Al.Warning.xPbfCardNotOK := gMachine.St.xWorkingAsPBF AND NOT gMachine.In.xPbfCardOK;
	
	PsycallConfChecking;
	
	// Warnings: Uv belt cleaning related
	IF gMachine.Pt.Clean.xCleanBeltForUv THEN
		gMachine.Al.Warning.xCleanBeltRelayFaulted := gMachine.In.CleanBelt.xError;
		gMachine.Al.Warning.xCleanCylinderNotInHighPosition := gMachine.In.CleanBelt.xHighPosition;
		gMachine.Al.Warning.xCleanBeltSystemNotInPosition := gMachine.In.CleanBelt.xOpenGuide;
		gMachine.Al.Warning.xBeltCleanRequired := (tiSumTimeToCleanBelt>=gMachine.parSw.CleanBelt.tiCleaningBeltByTime);
	ELSE
		gMachine.Al.Warning.xCleanBeltRelayFaulted := FALSE;
		gMachine.Al.Warning.xCleanCylinderNotInHighPosition := FALSE;
		gMachine.Al.Warning.xCleanBeltSystemNotInPosition:= FALSE;
		gMachine.Al.Warning.xBeltCleanRequired := FALSE;
	END_IF
	
	//
	IF NOT gMachine.parSw.Clean.xCleanSystemByPieces AND NOT gMachine.parSw.Clean.xCleanSystemByTime THEN
		gMachine.Al.Warning.xNoCleaningModeEnabled:=TRUE;
	ELSE
		gMachine.Al.Warning.xNoCleaningModeEnabled:=FALSE;
	END_IF
	
	//Hoopers Powered.Warning
	IF gMachine.In.xHoppersSoftStarterFault AND xSuctionTurbine THEN 
		gMachine.Al.Warning.xAlrHoopersSoftStarterFault := TRUE; 
	END_IF
	
	//Overvoltage
	IF gMachine.In.xOvervoltage THEN 
		gMachine.Al.Warning.xOvervoltage := TRUE; 
	END_IF
	
	//Antistatic device
	IF gMachine.In.AntiStatic.xIonLevelAlarm AND gMachine.Out.xAntiStaticPOn THEN
		gMachine.Al.Warning.xIonAntiStatic := TRUE;
	END_IF
	IF gMachine.In.AntiStatic.xGenAlarm AND gMachine.Out.xAntiStaticPOn THEN
		gMachine.Al.Warning.xErrorAntiStatic := TRUE;
	END_IF
	
	tonWasteInkTankMaxLevelReached.IN := gMachine.In.xWasteInkTankMaxLevelReached;
	tonWasteInkTankMaxLevelReached.PT := T#500ms;
	tonWasteInkTankMaxLevelReached();
	IF tonWasteInkTankMaxLevelReached.Q THEN
		gMachine.Al.Warning.xWasteInkTankMaxLevelReached := TRUE;
	END_IF

	// NOZOMITWO-2599 Media limitations not updated when enabling ancillaries
	IF gMachine.parSw.Media.rThickness > gMachine.Pt.Media.rMaxMediaThickness OR gMachine.parSw.Media.rThickness < gMachine.Pt.Media.rMinMediaThickness THEN
		gMachine.Al.Alarm.xAlrThickOutLimits := TRUE;
	END_IF
	IF gMachine.parSw.Media.rLength > gMachine.Pt.Media.iMaxMediaLength OR gMachine.parSw.Media.rLength < gMachine.Pt.Media.iMinMediaLength THEN
		gMachine.Al.Alarm.xAlrLengthOutLimits := TRUE;
	END_IF
	IF gMachine.parSw.Media.rWidth > gMachine.Pt.Media.iMaxMediaWidth OR gMachine.parSw.Media.rWidth < gMachine.Pt.Media.iMinMediaLength THEN
		gMachine.Al.Alarm.xAlrWidthOutLimits := TRUE;
	END_IF
	
	
	//Alarms comms with kernel
	AlarmKernelPLCCommsCounter;
	
END_ACTION

ACTION AlarmKernelPLCCommsCounter:

		// Alarm: Com PC-PLC
	T_AlarmComPcPlc.IN:= gMachine.parSw.iFaultComPcPlc=iFaultPcPlcAux;
	T_AlarmComPcPlc.PT:= T#45S;	//This is changed to 45secs 
	T_AlarmComPcPlc();
	
	IF EDGEPOS (T_AlarmComPcPlc.Q) THEN	
		gMachine.Al.Alarm.xAlarmComPcPLC:= TRUE;	
	END_IF;
	
	IF (gMachine.parSw.iFaultComPcPlc<>iFaultPcPlcAux) THEN	
		iFaultPcPlcAux:= gMachine.parSw.iFaultComPcPlc;	
	END_IF;

END_ACTION

ACTION PsycallConfChecking:
	CASE gMachine.Pt.ConfigNameID OF
		GC_CONFIG_2BK12BAR_ID:
			PhysicalConfCheckingWithCardsArray;


		GC_CONFIG_1BK2BAR_ID:
			CASE gMachine.Pt.MachineModel OF
				Type_SHLD,
				Type_SHLD_L:							// SHIELD 1 Block 2 Bars
					plcCardsOK[0].0 := NOT X20DIF371_001.ModuleOk;
					plcCardsOK[0].1 := NOT X20DIF371_002.ModuleOk;
					plcCardsOK[0].2 := NOT X20DIF371_003.ModuleOk;
					plcCardsOK[0].3 := NOT X20DIF371_004.ModuleOk;
					plcCardsOK[0].4 := NOT X20DOF322_005.ModuleOk;
					plcCardsOK[0].5 := NOT X20DOF322_006.ModuleOk;
					plcCardsOK[0].6 := NOT X20AI4322_008.ModuleOk;
					plcCardsOK[0].7 := NOT X20AO4622_009.ModuleOk;
					plcCardsOK[0].8 := NOT X20AT4222_010.ModuleOk;
					plcCardsOK[0].9 :=	NOT gPhotoCells.status.xBackModuleOk;
					plcCardsOK[0].10 := NOT gPhotoCells.status.xFrontModuleOk;
						
						gMachine.Al.Alarm.xAlrWrongPhysConf := plcCardsOK[0]<>0;
						
				ELSE
					gMachine.Al.Alarm.xAlrWrongPhysConf := TRUE;

			END_CASE

			
		GC_CONFIG_BM_1BK8BAR_ID:
			CASE gMachine.Pt.MachineModel OF
				Type_S1400,
				Type_P5_OIL,
				Type_P5_WTR:										//S1400 Without vacuunm
					plcCardsOK[0].0 := NOT X20DIF371_001.ModuleOk; 
					plcCardsOK[0].1 := NOT X20DIF371_002.ModuleOk; 
					plcCardsOK[0].2 := NOT X20DIF371_003.ModuleOk;
					plcCardsOK[0].3 := NOT X20DIF371_004.ModuleOk; 
					plcCardsOK[0].4 := NOT X20DIF371_005.ModuleOk; 
					plcCardsOK[0].5 := NOT X20DIF371_006.ModuleOk;
					plcCardsOK[0].6 := NOT X20DI9372_008.ModuleOk; 
					plcCardsOK[0].7 := NOT X20DOF322_009.ModuleOk; 
					plcCardsOK[0].8 := NOT X20DOF322_010.ModuleOk;
					plcCardsOK[0].9 := NOT X20DOF322_011.ModuleOk; 
					plcCardsOK[0].10 := NOT X20DOF322_012.ModuleOk; 
					plcCardsOK[0].11 := NOT X20DOF322_013.ModuleOk;
					plcCardsOK[0].12 := NOT X20AI8321_015.ModuleOk; 
					plcCardsOK[0].13 := NOT X20AI8321_016.ModuleOk; 
					plcCardsOK[0].14 := NOT X20AO4622_017.ModuleOk;
					plcCardsOK[0].15 := NOT X20AO4622_018.ModuleOk; 
					plcCardsOK[0].16 := NOT X20AO4622_019.ModuleOk; 
					plcCardsOK[0].17:= NOT X20AO4622_020.ModuleOk;
					plcCardsOK[0].18 := NOT X20AT4222_022.ModuleOk; 
					plcCardsOK[0].19 := NOT X20AT4222_023.ModuleOk; 
					
				Type_S1400_VAC_PWRLNK,
				Type_S1400_VAC_CAN:							//S1400 With Vacuum
					plcCardsOK[0].0 := NOT X20DIF371_001.ModuleOk;
					plcCardsOK[0].1 := NOT X20DIF371_002.ModuleOk;
					plcCardsOK[0].2 := NOT X20DIF371_003.ModuleOk;
					plcCardsOK[0].3 := NOT X20DIF371_004.ModuleOk;
					plcCardsOK[0].4 := NOT X20DIF371_005.ModuleOk;
					plcCardsOK[0].5 := NOT X20DIF371_006.ModuleOk;
					plcCardsOK[0].6 := NOT X20DI9372_008.ModuleOk;
					plcCardsOK[0].7 := NOT X20DOF322_009.ModuleOk;
					plcCardsOK[0].8 := NOT X20DOF322_010.ModuleOk;
					plcCardsOK[0].9 := NOT X20DOF322_011.ModuleOk;
					plcCardsOK[0].10 := NOT X20DOF322_012.ModuleOk;
					plcCardsOK[0].11 := NOT X20DOF322_013.ModuleOk;
					plcCardsOK[0].12 := NOT X20AI8321_015.ModuleOk;
					plcCardsOK[0].13 := NOT X20AI8321_016.ModuleOk;
					plcCardsOK[0].14 := NOT X20AO4622_017.ModuleOk;
					plcCardsOK[0].15 := NOT X20AO4622_018.ModuleOk;
					plcCardsOK[0].16 := NOT X20AO4622_019.ModuleOk;
					plcCardsOK[0].17 := NOT X20AO4622_020.ModuleOk;
					plcCardsOK[0].18 := NOT X20AT4222_022.ModuleOk;
					plcCardsOK[0].19 := NOT X20AT4222_023.ModuleOk;
					plcCardsOK[0].20 := NOT X20DIF371_024.ModuleOk;
					plcCardsOK[0].21 := NOT X20AI8321_025.ModuleOk;
					plcCardsOK[0].22 := NOT X20AI2636_100.ModuleOk;
					
					gMachine.Al.Alarm.xAlrWrongPhysConf := plcCardsOK[0]<>0;
				ELSE
					gMachine.Al.Alarm.xAlrWrongPhysConf := TRUE;
			END_CASE
	
		GC_CONFIG_1BK8BAR_NOZ2_ID,
		GC_CONFIG_1BK8BAR_NOZ2_AQ_ID:
			CASE gMachine.Pt.MachineModel OF
				Type_NOZ_2_AQ:
				
					//Printer
					plcCardsOK[0].0 := NOT X20DIF371_101.ModuleOk; 
					plcCardsOK[0].1 := NOT X20DIF371_102.ModuleOk; 
					plcCardsOK[0].2 := NOT X20DIF371_103.ModuleOk;
					plcCardsOK[0].3 := NOT X20DIF371_104.ModuleOk; 
					plcCardsOK[0].4 := NOT X20DIF371_105.ModuleOk; 
					//plcCardsOK[0].5 := NOT X20PS3300_106.ModuleOk;
					plcCardsOK[0].6 := NOT X20DI9372_107.ModuleOk; 
					plcCardsOK[0].7 := NOT X20DOF322_108.ModuleOk; 
					plcCardsOK[0].8 := NOT X20DOF322_109.ModuleOk;
					plcCardsOK[0].9 := NOT X20DOF322_110.ModuleOk; 
					plcCardsOK[0].10 := NOT X20AI8321_111.ModuleOk; 
					plcCardsOK[0].11 := NOT X20AI8321_112.ModuleOk;
					plcCardsOK[0].12 := NOT X20AI8321_113.ModuleOk; 
					//plcCardsOK[0].13 := NOT X20PS3300_114.ModuleOk; 
					plcCardsOK[0].14 := NOT X20AO4622_115.ModuleOk;
					plcCardsOK[0].15 := NOT X20AO4622_116.ModuleOk; 
					plcCardsOK[0].16 := NOT X20AO4622_117.ModuleOk; 
					plcCardsOK[0].17:= NOT X20AT4222_118.ModuleOk;
					plcCardsOK[0].18 := NOT X20AT4222_119.ModuleOk; 
					
					
					//PDC
					plcCardsOK[1].0 := NOT Pdc_X20DIF371_002.ModuleOk;
					plcCardsOK[1].1 := NOT Pdc_X20DIF371_003.ModuleOk;
					plcCardsOK[1].2 := NOT Pdc_X20DIF371_004.ModuleOk;
					plcCardsOK[1].3 := NOT Pdc_X20DIF371_005.ModuleOk;
					plcCardsOK[1].4 := NOT Pdc_X20DIF371_006.ModuleOk;
					plcCardsOK[1].5 := NOT X20PS3300_007.ModuleOk;
					plcCardsOK[1].6 := NOT Pdc_X20DOF322_008.ModuleOk;
					plcCardsOK[1].7 := NOT Pdc_X20DOF322_009.ModuleOk;
					plcCardsOK[1].8 := NOT Pdc_X20DOF322_010.ModuleOk;
			
					gMachine.Al.Alarm.xAlrWrongPhysConf := plcCardsOK[0]<>0 OR plcCardsOK[1]<>0;
				
					
				Type_NOZ_2_UV,
				Type_NOZ_2_UV_White:
				
					//Printer
					plcCardsOK[0].0 := NOT X20DIF371_101.ModuleOk; 
					plcCardsOK[0].1 := NOT X20DIF371_102.ModuleOk; 
					plcCardsOK[0].2 := NOT X20DIF371_103.ModuleOk;
					plcCardsOK[0].3 := NOT X20DIF371_104.ModuleOk; 
					plcCardsOK[0].4 := NOT X20DIF371_105.ModuleOk; 
					plcCardsOK[0].5 := NOT X20PS3300_106.ModuleOk;
					plcCardsOK[0].6 := NOT X20DI9372_107.ModuleOk; 
					plcCardsOK[0].7 := NOT X20DOF322_108.ModuleOk; 
					plcCardsOK[0].8 := NOT X20DOF322_109.ModuleOk;
					plcCardsOK[0].9 := NOT X20DOF322_110.ModuleOk; 
					plcCardsOK[0].10 := NOT X20AI8321_111.ModuleOk; 
					plcCardsOK[0].11 := NOT X20AI8321_112.ModuleOk;
					plcCardsOK[0].12 := NOT X20AI8321_113.ModuleOk; 
					plcCardsOK[0].13 := NOT X20PS3300_114.ModuleOk; 
					plcCardsOK[0].14 := NOT X20AO4622_115.ModuleOk;
					plcCardsOK[0].15 := NOT X20AO4622_116.ModuleOk; 
					plcCardsOK[0].16 := NOT X20AO4622_117.ModuleOk; 
					plcCardsOK[0].17:= NOT X20AT4222_118.ModuleOk;
					plcCardsOK[0].18 := NOT X20AT4222_119.ModuleOk;
					//plcCardsOK[0].19 := NOT X20CS1030_150.ModuleOk;
					//plcCardsOK[0].20 := NOT X20CS1030_151.ModuleOk;
					plcCardsOK[0].21 := NOT X20PS3300_152.ModuleOk;
					plcCardsOK[0].22 := NOT X20DIF371_153.ModuleOk;
					plcCardsOK[0].23 := NOT X20DIF371_154.ModuleOk;
					plcCardsOK[0].24 := NOT X20DOF322_155.ModuleOk;
					plcCardsOK[0].25 := NOT X20AI8221_156.ModuleOk;
					plcCardsOK[0].26 := NOT X20AO4622_157.ModuleOk;
					plcCardsOK[0].27 := NOT X20AO4622_158.ModuleOk;
					
					
					//PDC
					plcCardsOK[1].0 := NOT Pdc_X20DIF371_002.ModuleOk;
					plcCardsOK[1].1 := NOT Pdc_X20DIF371_003.ModuleOk;
					plcCardsOK[1].2 := NOT Pdc_X20DIF371_004.ModuleOk;
					plcCardsOK[1].3 := NOT Pdc_X20DIF371_005.ModuleOk;
					plcCardsOK[1].4 := NOT Pdc_X20DIF371_006.ModuleOk;
					plcCardsOK[1].5 := NOT X20PS3300_007.ModuleOk;
					plcCardsOK[1].6 := NOT Pdc_X20DOF322_008.ModuleOk;
					plcCardsOK[1].7 := NOT Pdc_X20DOF322_009.ModuleOk;
					plcCardsOK[1].8 := NOT Pdc_X20DOF322_010.ModuleOk;
					plcCardsOK[1].9 := NOT Pdc_X20DIF371_020.ModuleOk;
					plcCardsOK[1].10 := NOT Pdc_X20DIF371_021.ModuleOk;
					plcCardsOK[1].11 := NOT X20PS3300_022.ModuleOk;
					plcCardsOK[1].12 := NOT Pdc_X20DOF322_023.ModuleOk;
			
					gMachine.Al.Alarm.xAlrWrongPhysConf := plcCardsOK[0]<>0 OR plcCardsOK[1]<>0;
				
				ELSE
					gMachine.Al.Alarm.xAlrWrongPhysConf := TRUE;
					
			END_CASE
			
		GC_CONFIG_1BK7BAR_CUBE_ID:
			plcCardsOK[0].0 := NOT X20DIF371_101.ModuleOk; 
			plcCardsOK[0].1 := NOT X20DIF371_102.ModuleOk; 
			plcCardsOK[0].2 := NOT X20DIF371_103.ModuleOk;
			plcCardsOK[0].3 := NOT X20DIF371_104.ModuleOk; 
			plcCardsOK[0].4 := NOT X20PS3300_106.ModuleOk;
			plcCardsOK[0].5 := NOT X20DOF322_108.ModuleOk;
			plcCardsOK[0].6 := NOT X20DOF322_109.ModuleOk;
			plcCardsOK[0].7 := NOT X20AI8321_111.ModuleOk; 
			plcCardsOK[0].8 := NOT X20AI8321_112.ModuleOk;
			plcCardsOK[0].9 := NOT X20AI8321_113.ModuleOk; 
			plcCardsOK[0].10 := NOT X20PS3300_114.ModuleOk; 
			plcCardsOK[0].11 := NOT X20AO4622_115.ModuleOk;
			plcCardsOK[0].12 := NOT X20AO4622_116.ModuleOk;
			plcCardsOK[0].13 := NOT X20AO4622_117.ModuleOk;
			plcCardsOK[0].14 := NOT X20AO4622_118.ModuleOk;
			plcCardsOK[0].15 := NOT X20AT4222_119.ModuleOk;
			plcCardsOK[0].16 := NOT X20AT4222_120.ModuleOk;
			plcCardsOK[0].17 := NOT X20CS1030_121.ModuleOk;
			//plcCardsOK[0].18 := NOT X20DI9372_140.ModuleOk; 	
					
			//PDC
			plcCardsOK[1].1 := NOT Pdc_X20DIF371_002.ModuleOk;
			plcCardsOK[1].2 := NOT Pdc_X20DIF371_003.ModuleOk;
			plcCardsOK[1].3 := NOT Pdc_X20DIF371_004.ModuleOk;
			plcCardsOK[1].4 := NOT Pdc_X20DOF322_005.ModuleOk;
			plcCardsOK[1].5 := NOT X20PS3300_006.ModuleOk;
			plcCardsOK[1].6 := NOT Pdc_X20DOF322_007.ModuleOk;
			plcCardsOK[1].7 := NOT Pdc_X20DOF322_008.ModuleOk;
			plcCardsOK[1].8 := NOT Pdc_X20DIF371_030.ModuleOk;
			plcCardsOK[1].9 := NOT Pdc_X20AI2636_050.ModuleOk;
	
			
			gMachine.Al.Alarm.xAlrWrongPhysConf := plcCardsOK[0]<>0 OR plcCardsOK[1]<>0;
			
			
		GC_CONFIG_1BK10BAR_MECANO_ID:
			plcCardsOK[0].0 := NOT X20DIF371_101.ModuleOk; 
			plcCardsOK[0].1 := NOT X20DIF371_102.ModuleOk; 
			plcCardsOK[0].2 := NOT X20DIF371_103.ModuleOk;
			plcCardsOK[0].3 := NOT X20DIF371_104.ModuleOk; 
			plcCardsOK[0].4 := NOT X20DIF371_105.ModuleOk;
			plcCardsOK[0].5 := NOT X20DIF371_106.ModuleOk;
			plcCardsOK[0].6 := NOT X20PS3300_107.ModuleOk;
			plcCardsOK[0].7 := NOT X20DOF322_108.ModuleOk; 
			plcCardsOK[0].8 := NOT X20DOF322_109.ModuleOk;
			plcCardsOK[0].9 := NOT X20DOF322_110.ModuleOk; 
			plcCardsOK[0].10 := NOT X20AI8321_111.ModuleOk; 
			plcCardsOK[0].11 := NOT X20AI8321_112.ModuleOk;
			plcCardsOK[0].12 := NOT X20AI8321_113.ModuleOk;
			plcCardsOK[0].13 := NOT X20AI8321_114.ModuleOk;
			plcCardsOK[0].14 := NOT X20PS3300_115.ModuleOk;
			plcCardsOK[0].15 := NOT X20AO4622_116.ModuleOk;
			plcCardsOK[0].16 := NOT X20AO4622_117.ModuleOk;
			plcCardsOK[0].17 := NOT X20AO4622_118.ModuleOk;
			plcCardsOK[0].18 := NOT X20AO4622_119.ModuleOk; 
			plcCardsOK[0].19:= NOT X20AT4222_120.ModuleOk;
			plcCardsOK[0].20 := NOT X20AT4222_121.ModuleOk;
			plcCardsOK[0].21 := NOT X20PS3300_150.ModuleOk;
			plcCardsOK[0].22 := NOT X20DIF371_151.ModuleOk;
			plcCardsOK[0].23 := NOT X20DIF371_152.ModuleOk;
			plcCardsOK[0].24 := NOT X20DIF371_153.ModuleOk;
			plcCardsOK[0].25 := NOT X20DIF371_154.ModuleOk;
			plcCardsOK[0].26 := NOT X20DOF322_155.ModuleOk;
			plcCardsOK[0].27 := NOT X20DOF322_156.ModuleOk;
			plcCardsOK[0].28 := NOT X20PS3300_157.ModuleOk;
			plcCardsOK[0].29 := NOT X20AO4622_158.ModuleOk;
			plcCardsOK[0].30 := NOT X20AO4622_159.ModuleOk;
			plcCardsOK[0].31 := NOT X20AO4622_160.ModuleOk;
			plcCardsOK[1].0 := NOT X20AO4622_161.ModuleOk;
			plcCardsOK[1].1 := NOT X20CS1030_162.ModuleOk;
//			IF gMachine.Pt.MachineModel<>Type_MECANO_UV_OPV THEN 
//				plcCardsOK[1].2 := NOT X20CS1030_180.ModuleOk;
//			END_IF
//			IF gMachine.Pt.MachineModel<>Type_MECANO_UV_WHITE THEN 
//				plcCardsOK[1].3 := NOT X20CS1030_181.ModuleOk;
//			END_IF
					
					
			//PDC
			plcCardsOK[1].4 := NOT Pdc_X20DIF371_002.ModuleOk;
			plcCardsOK[1].5 := NOT Pdc_X20DIF371_003.ModuleOk;
			plcCardsOK[1].6 := NOT Pdc_X20DIF371_004.ModuleOk;
			plcCardsOK[1].7 := NOT Pdc_X20DIF371_005.ModuleOk;
			plcCardsOK[1].8 := NOT Pdc_X20DIF371_006.ModuleOk;
			plcCardsOK[1].9 := NOT Pdc_X20DIF371_007.ModuleOk;
			plcCardsOK[1].10 := NOT X20PS3300_008.ModuleOk;
			plcCardsOK[1].11 := NOT Pdc_X20DOF322_009.ModuleOk;
			plcCardsOK[1].12 := NOT Pdc_X20DOF322_010.ModuleOk;
			plcCardsOK[1].13 := NOT Pdc_X20DOF322_011.ModuleOk;
			plcCardsOK[1].14 := NOT X20PS3300_020.ModuleOk;
			plcCardsOK[1].15 := NOT Pdc_X20DIF371_021.ModuleOk;
			plcCardsOK[1].16 := NOT Pdc_X20DIF371_022.ModuleOk;
			plcCardsOK[1].17 := NOT Pdc_X20DIF371_023.ModuleOk;
			plcCardsOK[1].18 := NOT Pdc_X20DIF371_024.ModuleOk;
			plcCardsOK[1].19 := NOT Pdc_X20DOF322_025.ModuleOk;
			
			gMachine.Al.Alarm.xAlrWrongPhysConf := plcCardsOK[0]<>0 OR plcCardsOK[1]<>0;
		
		GC_CONFIG_SIMTEST_ID:
			gMachine.Al.Alarm.xAlrWrongPhysConf := FALSE;
			
		ELSE
	
			gMachine.Al.Alarm.xAlrWrongPhysConf := TRUE;
	
	END_CASE
	
END_ACTION

ACTION PhysicalConfCheckingWithCardsArray:
	
	// If not assigned, just skip the code
	IF gPlcCards[iIndexPhysicalConf].pCard = 0 THEN
		RETURN;
	END_IF
	
	cardPlcConfCheck ACCESS gPlcCards[iIndexPhysicalConf].pCard;
	
	// If the cards is not OK, ckeck if it is needed
	IF NOT cardPlcConfCheck.ModuleOk THEN
		RaisePhysicalConfAlarmIfRequired;
	END_IF
	
	// Go to next card
	iIndexPhysicalConf := iIndexPhysicalConf + 1;
	IF gPlcCards[iIndexPhysicalConf].Type = CARD_UNDEFINED THEN
		iIndexPhysicalConf := 0;
	END_IF

END_ACTION

ACTION RaisePhysicalConfAlarmIfRequired:

	FOR iIndexRequirement := 0 TO MAX_LAST_REQUIRED_FUNCTION_CARD DO
		CASE gPlcCards[iIndexPhysicalConf].RequiredForFunctions[iIndexRequirement] OF
			CARDREQUIRED_UNDEFINED:
				//Do nothing
					
			CARDREQUIRED_ALWAYS:
				gMachine.Al.Alarm.xAlrWrongPhysConf := TRUE;
					
			CARDREQUIRED_ANALOG_THICK:
				IF gDing.State.xDingInstalled THEN
					gMachine.Al.Alarm.xAlrWrongPhysConf := TRUE;
				END_IF
					
			CARDREQUIRED_SENSOR_THICK:
				IF gPhotoCells.status.xInstalled THEN
					gMachine.Al.Alarm.xAlrWrongPhysConf := TRUE;
				END_IF
					
			CARDREQUIRED_VACUUM:
				IF gTransVacuum[1].Status.xInstalled THEN
					gMachine.Al.Alarm.xAlrWrongPhysConf := TRUE;
				END_IF
					
			CARDREQUIRED_LED_WHITE:
				IF gCuringLed[iIndexWhiteCuringLedBar].Status.xInstalled THEN
					gMachine.Al.Alarm.xAlrWrongPhysConf := TRUE;
				END_IF
					
			CARDREQUIRED_LED_COLOR:
				IF gCuringLed[iIndexColorCuringLedBar].Status.xInstalled THEN
					gMachine.Al.Alarm.xAlrWrongPhysConf := TRUE;
				END_IF
					
			CARDREQUIRED_HEATED_TANKS:
				IF gMachine.St.Blocks.xAnyTankHeaterEnabled THEN
					gMachine.Al.Alarm.xAlrWrongPhysConf := TRUE;
				END_IF

		END_CASE

	END_FOR
	
END_ACTION
