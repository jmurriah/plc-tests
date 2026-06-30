
ACTION InputsP4:
	
(* CABINET 01 *)
	
    // X1 PLC		
	gMachine.In.xConsentL1Ok:= X1.DInput[1];
	gMachine.In.xConsentL2Ok:= X1.DInput[2];

	
	gMachine.In.xExternalCleaningOrder := X1.DInput[3];
	
	//Reserve01.DInput[1]:=X1.DInput[4];	
	//Reserve01.AInput[1]:= X1.AInput[1];
	//Reserve01.AInput[2]:= X1.AInput[2];	
		
	// X2 PLC	
	//Reserve01.DInput[1]:= X2.DInput[1];	
	//Reserve01.DInput[1]:= X2.DInput[2];
	//Reserve01.DInput[1]:= X2.DInput[3];
	//Reserve01.DInput[1]:= X2.DInput[4];
	gBelt.parameters.xDriveProtectionOK:= X2.DInput[5];
	//Reserve01.DInput[1]:= X2.DInput[6];
	//Reserve01.DInput[1]:= X2.DInput[7];
	//Reserve01.DInput[1]:= X2.DInput[8];
	//Reserve01.DInput[1]:= X2.DInput[9];

	
	// X3 PLC assignation to Laser detection
	gDing.In.xDingLow:= X3.DInput[5] AND gDing.State.xDingInstalled;					
	gDing.In.xDingHigh:= X3.DInput[6] AND gDing.State.xDingInstalled;	
	gDing.In.xModuleOK := X20AI2636_005.ModuleOk;
	gDing.In.xDingChannelFault := X20AI2636_005.DInput[1];

	// X2 PLC assignation to Photocell detection // FAST DETECTION
	// Those variables are not mapped. Are fast and assigned with pointer
	//gPhotoCells.Inputs.Signals.xPhotoCells[1] := NOT X2.DInput[11];	//It comes when X2 fast input
	//gPhotoCells.Inputs.Signals.xPhotoCells[2] := NOT X2.DInput[12];	// TRUE is not detecting tile
	//gPhotoCells.Inputs.Signals.xPhotoCells[3] := NOT X2.DInput[13];	
	
	
	// X20DIF371_001
	gBlockInputs[1].xWaterLevelSensor	:=FALSE;
	gBlockInputs[1].xWaterPresureSensor :=FALSE;
	gBlockInputs[2].xWaterLevelSensor	:=FALSE;
	gBlockInputs[2].xWaterPresureSensor :=FALSE;
	
		
	// X20DIF371_002	
	gMachine.In.UPSs[1].xPowerFault 	:= NOT X20DIF371_002.DInput[1];
	gMachine.In.UPSs[1].xByPass 		:= NOT X20DIF371_002.DInput[2];
	gMachine.In.UPSs[1].xLowBattery 		:= NOT X20DIF371_002.DInput[3];
	gMachine.In.UPSs[1].xSystemFault 	:= NOT X20DIF371_002.DInput[4];
	gMachine.In.UPSs[2].xPowerFault		:= NOT X20DIF371_002.DInput[5];
	gMachine.In.UPSs[2].xByPass			:= NOT X20DIF371_002.DInput[6];
	gMachine.In.UPSs[2].xLowBattery			:= NOT X20DIF371_002.DInput[7];
	gMachine.In.UPSs[2].xSystemFault	:= NOT X20DIF371_002.DInput[8];	
	//Reserve01.DInput[1]				:= X20DIF371_002.DInput[9];	
	gMachine.In.xPC1Ok				:= X20DIF371_002.DInput[10];
	gMachine.In.xPC2Ok				:= X20DIF371_002.DInput[11];
	gMachine.In.Buttons.xStart				:= X20DIF371_002.DInput[12];
	gMachine.In.Buttons.xStop				:= NOT X20DIF371_002.DInput[13];
	gMachine.In.Buttons.xAuto				:= X20DIF371_002.DInput[14];
	gMachine.In.Buttons.xManual				:= X20DIF371_002.DInput[15];
	//Reserve01.DInput[1]				:= X20DIF371_002.DInput[16];


	// X20DIF371_003										   (*scheme*)
	gMachine.In.Buttons.xZero:= NOT X20DIF371_003.DInput[1];	       (*DI0*) 

	// gMachine.In.iMachineModelCode assigned in an specific Action

	//Reserve01.DInput[1]:= X20DIF371_003.DInput[8];
	//Reserve01.DInput[1]:= X20DIF371_003.DInput[9];
	//Reserve01.DInput[1]:= X20DIF371_003.DInput[10];
	//Reserve01.DInput[1]:= X20DIF371_003.DInput[11];
	//Reserve01.DInput[1]:= X20DIF371_003.DInput[12];
	//Reserve01.DInput[1]:= X20DIF371_003.DInput[13];
	//Reserve01.DInput[1]:= X20DIF371_003.DInput[14];
	//Reserve01.DInput[1]:= X20DIF371_003.DInput[15];
	gMachine.In.xTankHeaterPsuOK:= X20DIF371_003.DInput[16];


	// X20AI2636_005
	//NOTE: This code is in IN_Thickness program, to be sure to have it ready prior to work with it
	

	// Reset and Mute with the same digital signal
	T_Reset.IN := X20DIF371_002.DInput[16];
	T_Reset.PT := t#250ms;
	T_Reset();
	
	T_Mute.IN := X20DIF371_002.DInput[16];
	T_Mute.PT := t#100ms;
	T_Mute();
	
	gMachine.In.Buttons.xReset:= T_Reset.Q;
	gMachine.In.Buttons.xMute:= T_Mute.Q;

	// Transport enable with Released transport from Emegency Stops
	gMachine.In.xSafetyEnabled:= X20SLX402_006.DInput[10];
	
	// X20SM1436
	gPhotoCells.status.xBackModuleOk := X20SM1436_007.ModuleOk;
	gPhotoCells.status.xFrontModuleOk := X20SM1436_008.ModuleOk;

	// X20DIF371_030 pseudoSync/SYNC
	gMachine.In.xPbfCardOK := X20DIF371_030.ModuleOk;
	gMachine.In.iRelieve1.0:=X20DIF371_030.DInput[1];
	gMachine.In.iRelieve1.1:=X20DIF371_030.DInput[2];
	gMachine.In.iRelieve1.2:=X20DIF371_030.DInput[3];
	gMachine.In.iRelieve1.3:=X20DIF371_030.DInput[4];
	gMachine.In.iRelieve1.4:=X20DIF371_030.DInput[5];
	gMachine.In.iRelieve1.5:=X20DIF371_030.DInput[6];
	gMachine.In.iRelieve1.6:=X20DIF371_030.DInput[7];
	gMachine.In.iRelieve1.7:=X20DIF371_030.DInput[8];
	gMachine.In.iRelieve1.8:=X20DIF371_030.DInput[9];
	gMachine.In.iRelieve1.9 := FALSE;
	gMachine.In.iRelieve1.10:= FALSE;
	gMachine.In.iRelieve1.11:= FALSE;
	gMachine.In.iRelieve1.12:= FALSE;
	gMachine.In.iRelieve1.13:= FALSE;
	gMachine.In.iRelieve1.14:= FALSE;
	gMachine.In.iRelieve1.15:= FALSE;	
	//Reserve01.DInput[1] := X20DIF371_030.DInput[10];
	//Reserve01.DInput[1] := X20DIF371_030.DInput[11];
	//Reserve01.DInput[1] := X20DIF371_030.DInput[12];
	//Reserve01.DInput[1] := X20DIF371_030.DInput[13];
	//Reserve01.DInput[1] := X20DIF371_030.DInput[14];
	//Reserve01.DInput[1] := X20DIF371_030.DInput[15];
	//Reserve01.DInput[1] := X20DIF371_030.DInput[16];
	
	
	// X20DIF371_101		(*  BAR A *) 	(*  BAR F *)
	gInksInputs[6].xMinLevel:= X20DIF371_101.DInput[1];
	gInksInputs[6].xMaxLevel:= X20DIF371_101.DInput[2];
	gInksInputs[5].xMinLevel:= X20DIF371_101.DInput[3];
	gInksInputs[5].xMaxLevel:= X20DIF371_101.DInput[4];
	gInksInputs[4].xMinLevel:= X20DIF371_101.DInput[5];
	gInksInputs[4].xMaxLevel:= X20DIF371_101.DInput[6];
	gInksInputs[3].xMinLevel:= X20DIF371_101.DInput[7];
	gInksInputs[3].xMaxLevel:= X20DIF371_101.DInput[8];
	gInksInputs[2].xMinLevel:= X20DIF371_101.DInput[9];
	gInksInputs[2].xMaxLevel:= X20DIF371_101.DInput[10];
	gInksInputs[1].xMinLevel:= X20DIF371_101.DInput[11];
	gInksInputs[1].xMaxLevel:= X20DIF371_101.DInput[12];
	gInksInputs[6].xOverpressure		:= NOT X20DIF371_101.DInput[13];
	gInksInputs[5].xOverpressure		:= NOT X20DIF371_101.DInput[14];
	gInksInputs[4].xOverpressure		:= NOT X20DIF371_101.DInput[15];
	gInksInputs[3].xOverpressure		:= NOT X20DIF371_101.DInput[16];
	
	// X20DIF371_102		
	gInksInputs[2].xOverpressure		:= NOT X20DIF371_102.DInput[1];
	gInksInputs[1].xOverpressure		:= NOT X20DIF371_102.DInput[2];
	gBlockInputs[1].xDifferentialOK := X20DIF371_102.DInput[3];
	gBlockInputs[1].xDriveProtectionOK:= X20DIF371_102.DInput[4];
	gInksInputs[6].xPrintHeadsPsuOK		:= NOT X20DIF371_102.DInput[5];	
	gInksInputs[5].xPrintHeadsPsuOK		:= NOT X20DIF371_102.DInput[6];	
	gInksInputs[4].xPrintHeadsPsuOK		:= NOT X20DIF371_102.DInput[7];
	gInksInputs[3].xPrintHeadsPsuOK		:= NOT X20DIF371_102.DInput[8];	
	gInksInputs[2].xPrintHeadsPsuOK		:= NOT X20DIF371_102.DInput[9];	
	gInksInputs[1].xPrintHeadsPsuOK		:= NOT X20DIF371_102.DInput[10];
	gInksInputs[6].xKlixonTriggered  	:= X20DIF371_102.DInput[11];
	gInksInputs[5].xKlixonTriggered  	:= X20DIF371_102.DInput[12];
	gInksInputs[4].xKlixonTriggered  	:= X20DIF371_102.DInput[13];
	gInksInputs[3].xKlixonTriggered  	:= X20DIF371_102.DInput[14];
	gInksInputs[2].xKlixonTriggered  	:= X20DIF371_102.DInput[15];
	gInksInputs[1].xKlixonTriggered  	:= X20DIF371_102.DInput[16];

		
	// X20DIF371_103		
	gBlockInputs[1].xWaterLevelSensor:= X20DIF371_103.DInput[1];
	gBlockInputs[1].xWaterPresureSensor:= X20DIF371_103.DInput[2];
	//Reserve01.DInput[1]:= X20DIF371_103.DInput[3];
	//Reserve01.DInput[1]:= X20DIF371_103.DInput[4];
	//Reserve01.DInput[1]:= X20DIF371_103.DInput[5];
	//Reserve01.DInput[1]:= X20DIF371_103.DInput[6];
	gBlockInputs[1].xHeaterDcOkBusBar1:= NOT X20DIF371_103.DInput[7];
	gBlockInputs[1].xReferenceDI:= X20DIF371_103.DInput[8];
	//Reserve01.DInput[1]:= X20DIF371_103.DInput[9];
	//Reserve01.DInput[1]:= X20DIF371_103.DInput[10];
	//Reserve01.DInput[1]:= X20DIF371_103.DInput[11];
	//Reserve01.DInput[1]:= X20DIF371_103.DInput[12];
	//Reserve01.DInput[1]:= X20DIF371_103.DInput[13];
	IF gBlock[1].parameters.iMappingBlock = 1 THEN
		gMachine.In.ProductDetect.pPDCarriageSignalL1 := ADR(X20DIF371_103.DInput[14]);
		gMachine.In.ProductDetect.pPDCarriageSignalL2 := ADR(X20DIF371_103.DInput[15]);
	END_IF
	//Reserve01.DInput[1]:= X20DIF371_103.DInput[16];
	

	// X20DC4395_104
	gInksInputs[6].iTachNegative		:= X20DC4395_104.CountInput[1];
	gInksInputs[4].iTachNegative		:= X20DC4395_104.CountInput[2];
	gInksInputs[2].iTachNegative		:= X20DC4395_104.CountInput[3];
	//Reserve01.DInput[1]:= X20DC4395_104.DInput[4];
	gInksInputs[5].iTachNegative		:= X20DC4395_104.CountInput[5];
	gInksInputs[3].iTachNegative		:= X20DC4395_104.CountInput[6];
	gInksInputs[1].iTachNegative		:= X20DC4395_104.CountInput[7];
	//Reserve01.DInput[1]:= X20DC4395_104.DInput[8];
		
	
	//  X20DC4395_105	(*  BAR A *) (*  BAR B *) (*  BAR C *) (*  BAR D *) (*  BAR E *) (*  BAR F *)
	gInksInputs[6].iTachFilling			:= X20DC4395_105.CountInput[1];
	gInksInputs[4].iTachFilling			:= X20DC4395_105.CountInput[2];
	gInksInputs[2].iTachFilling			:= X20DC4395_105.CountInput[3];
	//Reserve01.DInput[1]:= X20DC4395_105.DInput[4];
	gInksInputs[5].iTachFilling			:= X20DC4395_105.CountInput[5];
	gInksInputs[3].iTachFilling			:= X20DC4395_105.CountInput[6];
	gInksInputs[1].iTachFilling			:= X20DC4395_105.CountInput[7];
	//Reserve01.DInput[1]:= X20DC4395_105.DInput[8];

	
	// X20AI8321_109		(*  BAR A *) (*  BAR B *) (*  BAR C *) (*  BAR D *)
	gInksInputs[6].iVacuum1Raw			:= X20AI8321_109.AInput[1];
	gInksInputs[6].xVacuum1SensorError 	:= StatusAnalogInputBroken( X20AI8321_109.ModuleOk, X20AI8321_109.Status01, X20AI8321_109.Status02, 1);
	gInksInputs[6].iVacuum2Raw			:= X20AI8321_109.AInput[2];	
	gInksInputs[6].xVacuum2SensorError 	:= StatusAnalogInputBroken( X20AI8321_109.ModuleOk, X20AI8321_109.Status01, X20AI8321_109.Status02, 2);
	gInksInputs[5].iVacuum1Raw			:= X20AI8321_109.AInput[3];
	gInksInputs[5].xVacuum1SensorError 	:= StatusAnalogInputBroken( X20AI8321_109.ModuleOk, X20AI8321_109.Status01, X20AI8321_109.Status02, 3);
	gInksInputs[5].iVacuum2Raw			:= X20AI8321_109.AInput[4];
	gInksInputs[5].xVacuum2SensorError 	:= StatusAnalogInputBroken( X20AI8321_109.ModuleOk, X20AI8321_109.Status01, X20AI8321_109.Status02, 4);
	gInksInputs[4].iVacuum1Raw			:= X20AI8321_109.AInput[5];
	gInksInputs[4].xVacuum1SensorError 	:= StatusAnalogInputBroken( X20AI8321_109.ModuleOk, X20AI8321_109.Status01, X20AI8321_109.Status02, 5);
	gInksInputs[4].iVacuum2Raw			:= X20AI8321_109.AInput[6];
	gInksInputs[4].xVacuum2SensorError 	:= StatusAnalogInputBroken( X20AI8321_109.ModuleOk, X20AI8321_109.Status01, X20AI8321_109.Status02, 6);
	gInksInputs[3].iVacuum1Raw			:= X20AI8321_109.AInput[7];
	gInksInputs[3].xVacuum1SensorError 	:= StatusAnalogInputBroken( X20AI8321_109.ModuleOk, X20AI8321_109.Status01, X20AI8321_109.Status02, 7);
	gInksInputs[3].iVacuum2Raw			:= X20AI8321_109.AInput[8];
	gInksInputs[3].xVacuum2SensorError 	:= StatusAnalogInputBroken( X20AI8321_109.ModuleOk, X20AI8321_109.Status01, X20AI8321_109.Status02, 8);

	// X20AI8321_110		(*  BAR E *) 	(*  BAR F *)
	gInksInputs[2].iVacuum1Raw			:= X20AI8321_110.AInput[1];
	gInksInputs[2].xVacuum1SensorError 	:= StatusAnalogInputBroken( X20AI8321_110.ModuleOk, X20AI8321_110.Status01, X20AI8321_110.Status02, 1);
	gInksInputs[2].iVacuum2Raw			:= X20AI8321_110.AInput[2];
	gInksInputs[2].xVacuum2SensorError 	:= StatusAnalogInputBroken( X20AI8321_110.ModuleOk, X20AI8321_110.Status01, X20AI8321_110.Status02, 2);
	gInksInputs[1].iVacuum1Raw			:= X20AI8321_110.AInput[3];
	gInksInputs[1].xVacuum1SensorError 	:= StatusAnalogInputBroken( X20AI8321_110.ModuleOk, X20AI8321_110.Status01, X20AI8321_110.Status02, 3);
	gInksInputs[1].iVacuum2Raw			:= X20AI8321_110.AInput[4];
	gInksInputs[1].xVacuum2SensorError 	:= StatusAnalogInputBroken( X20AI8321_110.ModuleOk, X20AI8321_110.Status01, X20AI8321_110.Status02, 4);
	//Reserve01.AInput[1]:= X20AI8321_110.AInput[5];
	//Reserve01.AInput[1]:= X20AI8321_110.AInput[6];
	//Reserve01.AInput[1]:= X20AI8321_110.AInput[7];
	//Reserve01.AInput[1]:= X20AI8321_110.AInput[8];
	
	
	// X20AT4222_114		(*  BAR A *) (*  BAR B *) (*  BAR C *) (*  BAR D *)  (*  BAR E *)  (*  BAR F *)
	
	gBlockInputs[1].xModuleTemp01Ok		:= X20AT4222_114.ModuleOk; 
	gInksInputs[6].iTemperatureRaw  	:= X20AT4222_114.TempInput[1];
	gInksInputs[6].xTempSensorError		:= StatusTemperatureInput(X20AT4222_114.Status01, 1);
	gInksInputs[5].iTemperatureRaw  	:= X20AT4222_114.TempInput[2];
	gInksInputs[5].xTempSensorError		:= StatusTemperatureInput(X20AT4222_114.Status01, 2);
	gInksInputs[4].iTemperatureRaw  	:= X20AT4222_114.TempInput[3];
	gInksInputs[4].xTempSensorError		:= StatusTemperatureInput(X20AT4222_114.Status01, 3);
	gInksInputs[3].iTemperatureRaw  	:= X20AT4222_114.TempInput[4];
	gInksInputs[3].xTempSensorError		:= StatusTemperatureInput(X20AT4222_114.Status01, 4);
	
	// X20AT4222_115	
	gBlockInputs[1].xModuleTemp02Ok			:= X20AT4222_115.ModuleOk; 
	gInksInputs[2].iTemperatureRaw  		:= X20AT4222_115.TempInput[1];
	gInksInputs[2].xTempSensorError			:= StatusTemperatureInput(X20AT4222_115.Status01, 1);
	gInksInputs[1].iTemperatureRaw  		:= X20AT4222_115.TempInput[2];
	gInksInputs[1].xTempSensorError			:= StatusTemperatureInput(X20AT4222_115.Status01, 2);
	gInksInputs[6].iTemperatureTankRaw			:= X20AT4222_115.TempInput[3];
	gInksInputs[6].xTempTankSensorError	:= StatusTemperatureInput(X20AT4222_115.Status01, 3);
	gInksInputs[5].iTemperatureTankRaw			:= X20AT4222_115.TempInput[4];
	gInksInputs[5].xTempTankSensorError	:= StatusTemperatureInput(X20AT4222_115.Status01, 4);	
	
	// X20AT4222_116
	gBlockInputs[1].xModuleTemp03Ok			:= X20AT4222_116.ModuleOk; 
	gInksInputs[4].iTemperatureTankRaw			:= X20AT4222_116.TempInput[1];
	gInksInputs[4].xTempTankSensorError	:= StatusTemperatureInput(X20AT4222_116.Status01, 1);
	gInksInputs[3].iTemperatureTankRaw			:= X20AT4222_116.TempInput[2];
	gInksInputs[3].xTempTankSensorError	:= StatusTemperatureInput(X20AT4222_116.Status01, 2);
	gInksInputs[2].iTemperatureTankRaw			:= X20AT4222_116.TempInput[3];
	gInksInputs[2].xTempTankSensorError	:= StatusTemperatureInput(X20AT4222_116.Status01, 3);
	gInksInputs[1].iTemperatureTankRaw			:= X20AT4222_116.TempInput[4];
	gInksInputs[1].xTempTankSensorError	:= StatusTemperatureInput(X20AT4222_116.Status01, 4);
	
	// X20SI8110_117
	gBlockInputs[1].Safety.xRearEStopOK:=X20SI8110_117.DInput[1];
	gBlockInputs[1].Safety.xFrontEStopOK:=X20SI8110_117.DInput[3];	
	gBlockInputs[1].Safety.xCurtainEnable01:=X20SI8110_117.DInput[5];
	gBlockInputs[1].Safety.xRearSafetyOK:=X20SI8110_117.DInput[6];
	gBlockInputs[1].Safety.xCurtainEnable02:=X20SI8110_117.DInput[7];
	
	// X20SO8110_118
	gBlockInputs[1].Safety.xSafetyOK:=X20SO2110_118.DInput[1];
	
	// SI UNIT BK1	
	gBlockInputs[1].xSiUnitModuleOk:=SiUnitBK1.ModuleOk;  // Filter if it's necesary
	gMachine.In.xAirSupply:= SiUnitBK1.Input01_08.0;
	gBlockInputs[1].xAirVenturiOK:= SiUnitBK1.Input01_08.1;
	gBlockInputs[1].xTrayOut:= SiUnitBK1.Input01_08.2; // Out: Tray in safe position to move bars to print
	gBlockInputs[1].xIclaSensor:= SiUnitBK1.Input01_08.3;   
	gBlockInputs[1].xBarsIn := TRUE;

	
	(* CABINET 03 *)
	
	// X20DIF371_201 		(*  BAR G *) 	(*  BAR L *)
	gInksInputs[12].xMinLevel:= X20DIF371_201.DInput[1];
	gInksInputs[12].xMaxLevel:= X20DIF371_201.DInput[2];
	gInksInputs[11].xMinLevel:= X20DIF371_201.DInput[3];
	gInksInputs[11].xMaxLevel:= X20DIF371_201.DInput[4];
	gInksInputs[10].xMinLevel:= X20DIF371_201.DInput[5];
	gInksInputs[10].xMaxLevel:= X20DIF371_201.DInput[6];
	gInksInputs[9].xMinLevel:=  X20DIF371_201.DInput[7];
	gInksInputs[9].xMaxLevel:=  X20DIF371_201.DInput[8];
	gInksInputs[8].xMinLevel:=  X20DIF371_201.DInput[9];
	gInksInputs[8].xMaxLevel:=  X20DIF371_201.DInput[10];
	gInksInputs[7].xMinLevel:=  X20DIF371_201.DInput[11];
	gInksInputs[7].xMaxLevel:=  X20DIF371_201.DInput[12];
	gInksInputs[12].xOverpressure := NOT X20DIF371_201.DInput[13];
	gInksInputs[11].xOverpressure := NOT X20DIF371_201.DInput[14];
	gInksInputs[10].xOverpressure := NOT X20DIF371_201.DInput[15];
	gInksInputs[9].xOverpressure  := NOT X20DIF371_201.DInput[16];

	// X20DIF371_202		
	gInksInputs[8].xOverpressure := NOT X20DIF371_202.DInput[1];
	gInksInputs[7].xOverpressure := NOT X20DIF371_202.DInput[2];
	gBlockInputs[2].xDifferentialOK:= X20DIF371_202.DInput[3];
	gBlockInputs[2].xDriveProtectionOK:= X20DIF371_202.DInput[4];
	gInksInputs[12].xPrintHeadsPsuOK	:= NOT X20DIF371_202.DInput[5];
	gInksInputs[11].xPrintHeadsPsuOK	:= NOT X20DIF371_202.DInput[6];
	gInksInputs[10].xPrintHeadsPsuOK	:= NOT X20DIF371_202.DInput[7];
	gInksInputs[9].xPrintHeadsPsuOK		:= NOT X20DIF371_202.DInput[8];
	gInksInputs[8].xPrintHeadsPsuOK		:= NOT X20DIF371_202.DInput[9];
	gInksInputs[7].xPrintHeadsPsuOK		:= NOT X20DIF371_202.DInput[10];
	gInksInputs[12].xKlixonTriggered  	:= X20DIF371_202.DInput[11];
	gInksInputs[11].xKlixonTriggered  	:= X20DIF371_202.DInput[12];
	gInksInputs[10].xKlixonTriggered  	:= X20DIF371_202.DInput[13];
	gInksInputs[9].xKlixonTriggered  	:= X20DIF371_202.DInput[14];
	gInksInputs[8].xKlixonTriggered  	:= X20DIF371_202.DInput[15];
	gInksInputs[7].xKlixonTriggered  	:= X20DIF371_202.DInput[16];
	
	// X20DIF371_203		
	//Reserve01.DInput[1]:= X20DIF371_203.DInput[1];
	//Reserve01.DInput[1]:= X20DIF371_203.DInput[2];
	//Reserve01.DInput[1]:= X20DIF371_203.DInput[3];
	//Reserve01.DInput[1]:= X20DIF371_203.DInput[4];
	//Reserve01.DInput[1]:= X20DIF371_203.DInput[5];
	//Reserve01.DInput[1]:= X20DIF371_203.DInput[6];
	gBlockInputs[2].xHeaterDcOkBusBar1:= NOT X20DIF371_203.DInput[7];
	gBlockInputs[2].xReferenceDI:= X20DIF371_203.DInput[8];
	//Reserve01.DInput[1]:= X20DIF371_203.DInput[9];
	//Reserve01.DInput[1]:= X20DIF371_203.DInput[10];
	//Reserve01.DInput[1]:= X20DIF371_203.DInput[11];
	//Reserve01.DInput[1]:= X20DIF371_203.DInput[12];
	//Reserve01.DInput[1]:= X20DIF371_203.DInput[13];
	IF gBlock[1].parameters.iMappingBlock = 2 THEN
		gMachine.In.ProductDetect.pPDCarriageSignalL1 := ADR(X20DIF371_203.DInput[14]);
		gMachine.In.ProductDetect.pPDCarriageSignalL2 := ADR(X20DIF371_203.DInput[15]);
	END_IF
	//Reserve01.DInput[1]:= X20DIF371_203.DInput[16];

	// X20DC4395_204
	gInksInputs[12].iTachNegative		:= X20DC4395_204.CountInput[1];
	gInksInputs[10].iTachNegative		:= X20DC4395_204.CountInput[2];
	gInksInputs[8].iTachNegative		:= X20DC4395_204.CountInput[3];
	//Reserve01.DInput[1]:= X20DC4395_204.DInput[4];
	gInksInputs[11].iTachNegative		:= X20DC4395_204.CountInput[5];
	gInksInputs[9].iTachNegative		:= X20DC4395_204.CountInput[6];
	gInksInputs[7].iTachNegative		:= X20DC4395_204.CountInput[7];
	//Reserve01.DInput[1]:= X20DC4395_204.DInput[8];
		
	
	//  X20DC4395_205	(*  BAR G *) (*  BAR H *) (*  BAR I *) (*  BAR J *) (*  BAR K *) (*  BAR L *)
	gInksInputs[12].iTachFilling		:= X20DC4395_205.CountInput[1];
	gInksInputs[10].iTachFilling		:= X20DC4395_205.CountInput[2];
	gInksInputs[8].iTachFilling			:= X20DC4395_205.CountInput[3];
	//Reserve01.DInput[1]:= X20DC4395_205.DInput[4];
	gInksInputs[11].iTachFilling		:= X20DC4395_205.CountInput[5];
	gInksInputs[9].iTachFilling			:= X20DC4395_205.CountInput[6];
	gInksInputs[7].iTachFilling			:= X20DC4395_205.CountInput[7];
	//Reserve01.DInput[1]:= X20DC4395_205.DInput[8];	


	// X20AI8321_209	(*  BAR G *) (*  BAR H *) (*  BAR I *) (*  BAR J *)
	gInksInputs[12].iVacuum1Raw      	:= X20AI8321_209.AInput[1];
	gInksInputs[12].xVacuum1SensorError := StatusAnalogInputBroken( X20AI8321_209.ModuleOk, X20AI8321_209.Status01, X20AI8321_209.Status02, 1);
	gInksInputs[12].iVacuum2Raw      	:= X20AI8321_209.AInput[2];
	gInksInputs[12].xVacuum2SensorError := StatusAnalogInputBroken( X20AI8321_209.ModuleOk, X20AI8321_209.Status01, X20AI8321_209.Status02, 2);
	gInksInputs[11].iVacuum1Raw      	:= X20AI8321_209.AInput[3];
	gInksInputs[11].xVacuum1SensorError := StatusAnalogInputBroken( X20AI8321_209.ModuleOk, X20AI8321_209.Status01, X20AI8321_209.Status02, 3);
	gInksInputs[11].iVacuum2Raw      	:= X20AI8321_209.AInput[4];
	gInksInputs[11].xVacuum2SensorError := StatusAnalogInputBroken( X20AI8321_209.ModuleOk, X20AI8321_209.Status01, X20AI8321_209.Status02, 4);
	gInksInputs[10].iVacuum1Raw      	:= X20AI8321_209.AInput[5];
	gInksInputs[10].xVacuum1SensorError := StatusAnalogInputBroken( X20AI8321_209.ModuleOk, X20AI8321_209.Status01, X20AI8321_209.Status02, 5);
	gInksInputs[10].iVacuum2Raw      	:= X20AI8321_209.AInput[6];
	gInksInputs[10].xVacuum2SensorError := StatusAnalogInputBroken( X20AI8321_209.ModuleOk, X20AI8321_209.Status01, X20AI8321_209.Status02, 6);
	gInksInputs[9].iVacuum1Raw      	:= X20AI8321_209.AInput[7];
	gInksInputs[9].xVacuum1SensorError  := StatusAnalogInputBroken( X20AI8321_209.ModuleOk, X20AI8321_209.Status01, X20AI8321_209.Status02, 7);
	gInksInputs[9].iVacuum2Raw      	:= X20AI8321_209.AInput[8];
	gInksInputs[9].xVacuum2SensorError  := StatusAnalogInputBroken( X20AI8321_209.ModuleOk, X20AI8321_209.Status01, X20AI8321_209.Status02, 8);

	
	// X20AI8321_210 		(*  BAR K *)  (*  BAR L *)
	gInksInputs[8].iVacuum1Raw      	:= X20AI8321_210.AInput[1];	
	gInksInputs[8].xVacuum1SensorError  := StatusAnalogInputBroken( X20AI8321_210.ModuleOk, X20AI8321_210.Status01, X20AI8321_210.Status02, 1);
	gInksInputs[8].iVacuum2Raw      	:= X20AI8321_210.AInput[2];
	gInksInputs[8].xVacuum2SensorError  := StatusAnalogInputBroken( X20AI8321_210.ModuleOk, X20AI8321_210.Status01, X20AI8321_210.Status02, 2);
	gInksInputs[7].iVacuum1Raw      	:= X20AI8321_210.AInput[3];
	gInksInputs[7].xVacuum1SensorError  := StatusAnalogInputBroken( X20AI8321_210.ModuleOk, X20AI8321_210.Status01, X20AI8321_210.Status02, 3);
	gInksInputs[7].iVacuum2Raw      	:= X20AI8321_210.AInput[4];	
	gInksInputs[7].xVacuum2SensorError  := StatusAnalogInputBroken( X20AI8321_210.ModuleOk, X20AI8321_210.Status01, X20AI8321_210.Status02, 4);
	
	// X20AT4222_214		 (*  BAR G *)  (*  BAR H *)  (*  BAR I *)  (*  BAR J *)
	gBlockInputs[2].xModuleTemp01Ok		:= X20AT4222_214.ModuleOk; 
	gInksInputs[12].iTemperatureRaw  	:= X20AT4222_214.TempInput[1];
	gInksInputs[12].xTempSensorError	:= StatusTemperatureInput(X20AT4222_214.Status01, 1);
	gInksInputs[11].iTemperatureRaw  	:= X20AT4222_214.TempInput[2];
	gInksInputs[11].xTempSensorError	:= StatusTemperatureInput(X20AT4222_214.Status01, 2);
	gInksInputs[10].iTemperatureRaw  	:= X20AT4222_214.TempInput[3];
	gInksInputs[10].xTempSensorError	:= StatusTemperatureInput(X20AT4222_214.Status01, 3);
	gInksInputs[9].iTemperatureRaw  	:= X20AT4222_214.TempInput[4];
	gInksInputs[9].xTempSensorError		:= StatusTemperatureInput(X20AT4222_214.Status01, 4);
	
	// X20AT4222_215 		(*  BAR K *)  (*  BAR L *)
	gBlockInputs[2].xModuleTemp02Ok			:= X20AT4222_215.ModuleOk; 
	gInksInputs[8].iTemperatureRaw  		:= X20AT4222_215.TempInput[1];
	gInksInputs[8].xTempSensorError			:= StatusTemperatureInput(X20AT4222_215.Status01, 1);
	gInksInputs[7].iTemperatureRaw  		:= X20AT4222_215.TempInput[2];
	gInksInputs[7].xTempSensorError			:= StatusTemperatureInput(X20AT4222_215.Status01, 2);
	gInksInputs[12].iTemperatureTankRaw		:= X20AT4222_215.TempInput[3];
	gInksInputs[12].xTempTankSensorError	:= StatusTemperatureInput(X20AT4222_215.Status01, 3);
	gInksInputs[11].iTemperatureTankRaw		:= X20AT4222_215.TempInput[4];
	gInksInputs[11].xTempTankSensorError	:= StatusTemperatureInput(X20AT4222_215.Status01, 4);
	
	// X20AT4222_216
	gBlockInputs[2].xModuleTemp03Ok			:= X20AT4222_216.ModuleOk; 
	gInksInputs[10].iTemperatureTankRaw		:= X20AT4222_216.TempInput[1];
	gInksInputs[10].xTempTankSensorError	:= StatusTemperatureInput(X20AT4222_216.Status01, 1);
	gInksInputs[9].iTemperatureTankRaw			:= X20AT4222_216.TempInput[2];
	gInksInputs[9].xTempTankSensorError	:= StatusTemperatureInput(X20AT4222_216.Status01, 2);
	gInksInputs[8].iTemperatureTankRaw			:= X20AT4222_216.TempInput[3];
	gInksInputs[8].xTempTankSensorError	:= StatusTemperatureInput(X20AT4222_216.Status01, 3);
	gInksInputs[7].iTemperatureTankRaw			:= X20AT4222_216.TempInput[4];
	gInksInputs[7].xTempTankSensorError	:= StatusTemperatureInput(X20AT4222_216.Status01, 4);
	
	// X20SI8110_217
	gBlockInputs[2].Safety.xRearEStopOK:=X20SI8110_217.DInput[1];
	gBlockInputs[2].Safety.xFrontEStopOK:=X20SI8110_217.DInput[3];
	gBlockInputs[2].Safety.xCurtainEnable01:=X20SI8110_217.DInput[5];
	gBlockInputs[2].Safety.xRearSafetyOK:=X20SI8110_217.DInput[6];
	gBlockInputs[2].Safety.xCurtainEnable02:=X20SI8110_217.DInput[7];
	
	gBlockInputs[2].Safety.xSafetyOK:=X20SO2110_218.DInput[1];
	
	// SI UNIT BK2
	gBlockInputs[2].xSiUnitModuleOk:= SiUnitBK2.ModuleOk;  // Filter if it's necesary
	////Reserve01.DInput[1]:= SiUnitBK2.Input01_08.0;
	gBlockInputs[2].xAirVenturiOK:= SiUnitBK2.Input01_08.1;
	gBlockInputs[2].xTrayOut:=  SiUnitBK2.Input01_08.2;   //Out: Tray in safe position to move bars to print
	gBlockInputs[2].xIclaSensor:= SiUnitBK2.Input01_08.3;    
	
	//Signals Forced by Configuration

	gMachine.In.x24Vdc				:= TRUE;
	
	FOR iIndexBlock := 1 TO gMachine.Pt.CT.iNumBlocks DO
		
		gBlockInputs[iIndexBlock].Safety.xFrontSafetyOK	:= TRUE;
		
		gBlockInputs[iIndexBlock].xHeaterDcOkBusBar2 := TRUE;		
		gBlockInputs[iIndexBlock].xModuleTemp04Ok := TRUE;
		
		gBlock[iIndexBlock].parameters.Hw.iNumPrintheadsPSU := 0;
		gBlock[iIndexBlock].parameters.Hw.iNumHeaterPSU := 0;
		
	END_FOR
		
END_ACTION

