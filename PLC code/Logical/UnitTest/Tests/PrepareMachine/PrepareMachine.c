/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: PrepareMachine
 * Author: Jorge Murria
 ********************************************************************
 * Prepare machine with basic test to allow proper behabior
 * and starting tasks
 ********************************************************************/

#include <bur/plctypes.h>

#ifdef _DEFAULT_INCLUDES
#include <AsDefault.h>
#endif

#include "UnitTest.h"

#include <stdio.h>
#include <unistd.h>
#include <time.h>         /* clock_t, clock, CLOCKS_PER_SEC */
#include <astime.h>

_LOCAL TIME TimeLast;
_LOCAL TIME endtime;
_LOCAL UDINT diff_t;
_LOCAL STRING stringAux[120];

#define FALSE 0
#define TRUE 1



void nextState(){
	exTimesPreFast = gMachine.St.exec.fast;
	exTimesPreSlow = gMachine.St.exec.slow;
	iTestState++;
	TimeLast = clock_ms();
}

_TEST test_CheckMachine(void)
{
	strcpy(txTest, "test_CheckMachine");
	
	// Check txText <> than assigned, so just once
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
		
	iTestState = 0;

	switch (gMachine.Pt.MachineModel)
	{
		case Type_P4_12B_L:
			TEST_ASSERT_EQUAL_INT(150, gMachine.St.iMachineModelCodeSW);
			TEST_DONE;
			break;

		case Type_P4_6B_L:
			TEST_ASSERT_EQUAL_INT(510, gMachine.St.iMachineModelCodeSW);
			TEST_DONE;
			break;

		case Type_SHLD:
			TEST_ASSERT_EQUAL_INT(3, gMachine.St.iMachineModelCodeSW);
			TEST_DONE;
			break;
		
		case Type_S1400:
			TEST_ASSERT_EQUAL_INT(14, gMachine.St.iMachineModelCodeSW);
			TEST_DONE;
			break;
		
		case Type_S1400_VAC_PWRLNK:
			TEST_ASSERT_EQUAL_INT(14, gMachine.St.iMachineModelCodeSW);
			TEST_DONE;
			break;
		
		case Type_S1400_VAC_CAN:
			TEST_ASSERT_EQUAL_INT(15, gMachine.St.iMachineModelCodeSW);
			TEST_DONE;
			break;
		
		case Type_NOZ_2_AQ:
			TEST_ASSERT_EQUAL_INT(39, gMachine.St.iMachineModelCodeSW);
			TEST_DONE;
			break;
		
		case Type_P5_OIL:
			TEST_ASSERT_EQUAL_INT(14, gMachine.St.iMachineModelCodeSW);
			TEST_DONE;
			break;
		
		case Type_P5_WTR:
			TEST_ASSERT_EQUAL_INT(14, gMachine.St.iMachineModelCodeSW);
			TEST_DONE;
			break;
		
		case Type_P4_CBK:
			TEST_ASSERT_EQUAL_INT(510, gMachine.St.iMachineModelCodeSW);
			TEST_DONE;
			break;
		
		case Type_NOZ_2_UV:
			TEST_ASSERT_EQUAL_INT(40, gMachine.St.iMachineModelCodeSW);
			TEST_DONE;
			break;
		
		case Type_NOZ_2_UV_White:
			TEST_ASSERT_EQUAL_INT(40, gMachine.St.iMachineModelCodeSW);
			TEST_DONE;
			break;	
		
		case Type_CUBE:
			TEST_ASSERT_EQUAL_INT(1101, gMachine.St.iMachineModelCodeSW);
			TEST_DONE;
			break;				

		case Type_CUBE_GULLIVER:
			TEST_ASSERT_EQUAL_INT(1102, gMachine.St.iMachineModelCodeSW);
			TEST_DONE;
			break;				

		case Type_MECANO_UV_WHITE:
			TEST_ASSERT_EQUAL_INT(60, gMachine.St.iMachineModelCodeSW);
			TEST_DONE;
			break;
		
		case Type_MECANO_UV_OPV:
			TEST_ASSERT_EQUAL_INT(60, gMachine.St.iMachineModelCodeSW);
			TEST_DONE;
			break;
		
		case Type_MECANO_UV_WHITE_OPV:
			TEST_ASSERT_EQUAL_INT(60, gMachine.St.iMachineModelCodeSW);
			TEST_DONE;
			break;

		default:
			break;
	}		
}

_TEST test_GoToZero(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_GoToZero");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Going to Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			iTestState = 0;
			TEST_ASSERT(TRUE);
			TEST_DONE;
			break;
		
		default:
			break;
	}	
}

_TEST test_MachineLeft(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_MachineLeft");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			gMachine.parSw.xMachineDirection = TRUE;
			nextState();
			break;

		case 1:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles

			endtime = clock_ms();
			diff_t = difftime(endtime, TimeLast);
			UINT int_len;
			int_len = itoa(diff_t, &stringAux);
			strcpy(txTest, "this is the time ");
			strcat(&txTest, &stringAux);
			
			nextState();
			break;

		case 2:
			endtime = clock_ms();
			strcpy(txTest, "Waiting timer ");
			TEST_BUSY_CONDITION( endtime < TimeLast + 1 ); //We'll wait xx ms

			iTestState = 0;
			TEST_ASSERT_EQUAL_INT(gMachine.Pt.xLeftHandMachine, gMachine.parSw.xMachineDirection);
			TEST_DONE;
			break;
		
		default:
			break;
	}	
}

_TEST test_PrepareBasicConfigLeft(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_PrepareBasicConfig");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			gBlock[1].parSw.xEnableToMovements = TRUE;
			gBlock[1].parSw.xEnableToPrint = TRUE;
			gBlock[1].In.xWaterLevelSensor = TRUE;
			gBlock[1].In.xBarsIn = TRUE;

			gBlock[2].parSw.xEnableToMovements = (gMachine.Pt.CT.iNumBlocks>=2);
			gBlock[2].parSw.xEnableToPrint = (gMachine.Pt.CT.iNumBlocks>=2);
			gBlock[2].In.xWaterLevelSensor = (gMachine.Pt.CT.iNumBlocks>=2);
			gBlock[2].In.xBarsIn = TRUE;
			
			gMachine.parSw.Electronics.xRobotReadyL1 = TRUE;
			
			gMachine.parSw.rBeltSpeedSetPoint = 15.0;	// 15.0m/min
			gMachine.parSw.tiDelayConsent = SECONDS_TO_TIME(2);
			gMachine.In.xConsentL1Ok = TRUE;
			gMachine.In.xPowerSwitch = TRUE;
			
			gMachine.parSw.Safety.rMarginSafePrint = 1.1;
			gMachine.parSw.Safety.rMountedPieceOverthickness = 4.0;
			
			gMachine.parSw.Dtp.xDoubleLine = FALSE;
			
			gMachine.parSw.Clean.tiCleaningByTime = MINUTES_TO_TIME(12*60);
			gMachine.parSw.Clean.tiToCleanWhenPrinterStopped = MINUTES_TO_TIME(12*60);
			gMachine.parSw.Clean.iCleanMotorSpeedFwd = 5000;
			gMachine.parSw.Clean.iCleanMotorSpeedBwd = 5000;
			gMachine.parSw.Clean.iCleaningType = 1;
			gMachine.In.xSafetyEnabled = TRUE;
			gMachine.parSw.xAutoStartEnabled = FALSE;
			
			// Adding data for document
			gMachine.parSw.Hw.iMaxMediaLength = 9999;
			gMachine.parSw.Media.rLength = 1600;
			gMachine.parSw.Media.rWidth = 1400;
			if (gMachine.Pt.MachineModel == Type_CUBE){
				gMachine.parSw.Media.rGap = 3000;
			}
			else{
				gMachine.parSw.Media.rGap = 600;
			}
			gMachine.parSw.Media.rOffsetRegisterL1 = -700;
			gMachine.parSw.Media.rThickness = 2.0;
			
			//For machine models that detection system is defined by SW
			if (!gPhotoCells.status.xInstalled && !gDing.State.xDingInstalled){
				gMachine.parSw.Hw.xInstallnSensor = TRUE;		
			}

			gBelt.parSw.rAxisLength = 650.0;
			gBelt.parSw.rGearBox = 10.0;
			
			gDing.In.xModuleOK = TRUE;
			gDing.In.xDingChannelFault = FALSE;
			gSimMachine.Commands.Media.rMediaThickness = 2;
			
			if (gPhotoCells.parameters.MotorType == STP_STEPPER){
				gPhotoCells.parSw.rThicknessReference = 12;
			}
			else{
				gPhotoCells.parSw.rThicknessReference = -12;
			}
			
			gPhotoCells.parSw.rMechOffset = -0.2;
			gPhotoCells.status.xBackModuleOk = TRUE;
			gPhotoCells.status.xFrontModuleOk = TRUE;
			
			gIclaSim[1].Parameters.SpeedFactor = 1.0;
			gIclaSim[2].Parameters.SpeedFactor = 1.0;
			gIclaSim[3].Parameters.SpeedFactor = 1.0;
			gIclaSim[4].Parameters.SpeedFactor = 1.0;
			gIclaSim[5].Parameters.SpeedFactor = 1.0;
			gIclaSim[6].Parameters.SpeedFactor = 1.0;
			gIclaSim[7].Parameters.SpeedFactor = 1.0;
			
			gTransVacuum[1].Inputs.iPressureRaw = 16384; //This value is the equivalent to 0mbar of vacuum
			gMachine.parSw.xJamDetectEnable = TRUE;
			//gEdgeHoldDown.parSw.xEnable = TRUE;
			
			//Line Configuration just if the machine has line
			if (gMachine.Pt.xControlledByLine) {
				gLine.Inputs.UPSs[1].LoadOnBattery = FALSE;
				gFeeder.Inputs.xModelInput[0]=TRUE;
				gFeeder.ParSw.xEnabled=TRUE;
				gPrimer.Inputs.xModelInput[0]=TRUE;
				gPrimer.ParSw.xEnabled=TRUE;
				gPrimer.ParSw.xEnablePriming=TRUE;
				if (gMachine.St.HwData.xIsWater) {
					gSarm.Inputs.xModelInput[0]=FALSE;
					gSarm.Parameters.xInstalled=FALSE;
					gSarm.ParSw.xEnabled=FALSE;
					gDryerAnc.Inputs.xModelInput[0]=TRUE;
					gDryerAnc.ParSw.xEnabled=TRUE;
					gDryerAnc.Inputs.xInRemote=TRUE;
				}
				else {
					gSarm.Inputs.xModelInput[0]=TRUE;
					gSarm.Parameters.xInstalled=TRUE;
					gSarm.ParSw.xEnabled=TRUE;
					gDryerAnc.Inputs.xModelInput[0]=FALSE;
					gDryerAnc.ParSw.xEnabled=FALSE;
					gDryerAnc.Inputs.xInRemote=FALSE;
				}
				gOverVarnish.Inputs.xModelInput[0]=TRUE;
				gOverVarnish.ParSw.xEnabled=gMachine.St.HwData.xIsWater;
				gOverVarnish.ParSw.xEnablePriming=TRUE;
				gStacker.Inputs.xModelInput[0]=TRUE;
				gStacker.ParSw.xEnabled=TRUE;
			
				//Variables needed to work with line properly	
				gLine.Inputs.xPrinterPowered = TRUE;
				gLine.Inputs.xOvervoltageProtectionOk = TRUE;
			
				gSimMachine.Commands.Media.xMediaIfFeederFeeding = TRUE;
			}
			
			//Set safety
			gSimSafetyController.Commands.xSafetyToDefault = TRUE;
			
			//Curing leds
			for (iIndexPrepareCuring = 1; iIndexPrepareCuring <= gMachine.Pt.Hw.iMaxCuringLedBars; iIndexPrepareCuring++)
			{
				gCuringLed[iIndexPrepareCuring].Signals.Inputs.xFrontDoorClosed = TRUE;
				for (iIndexPsuOk = 1; iIndexPsuOk < 11; iIndexPsuOk++)
				{
					gCuringLed[iIndexPrepareCuring].Signals.Inputs.xPsuDcOk[iIndexPsuOk] = TRUE;
					gCuringLed[iIndexPrepareCuring].Signals.Inputs.xPsuAcOk[iIndexPsuOk] = TRUE;
				}
			
			}
			
			nextState();
			break;

		case 1:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			nextState();
			break;

		case 2:
			iTestState = 0;
			if (gMachine.parSw.xMachineDirection){
				TEST_ASSERT(gMachine.Pt.xLeftHandMachine);
			}
			TEST_DONE;
			break;
		
		default:
			break;
	}	
}

_TEST test_GoToManualFromZero(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_GoToManualFromZero");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Going to Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToManual = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Going to Manual");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xManual );
			nextState();
			break;

		case 4:
			iTestState = 0;
			TEST_ASSERT(TRUE);
			TEST_DONE;
			break;
		
		default:
			break;
	}	
}

_TEST test_StartInks01(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_StartInks01");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			//Activate the OK signal in all inputs and prepare parameters
			for (iIndexBlock = 1; iIndexBlock <= gMachine.Pt.CT.iNumBlocks; iIndexBlock++)
			{
				if(gBlock[iIndexBlock].parSw.xEnableToMovements){
					for (iIndex = 1; iIndex <= gBlock[iIndexBlock].parameters.Inks.iMaxBlockPrintBars; iIndex++)
					{
						gInks[iIndex].parSw.xEnabledBarToPrint = TRUE;
						gInks[iIndex].parSw.xColorLoadedInJob = TRUE;
		
						gInks[iIndex].parSw.Config.iMappingBar = iIndex;
						gInks[iIndex].parSw.xActTestMode = TRUE;
						gInks[iIndex].parSw.NegPump.rLowerLimMeniscusCritical = 0;
						gInks[iIndex].parSw.NegPump.rUpperLimMeniscusCritical = 70.0;
						gInks[iIndex].parSw.PosPump.rSetPoint = 7.0;
						gInks[iIndex].parSw.NegPump.rSetPointMeniscus = 24;
						gInks[iIndex].parSw.Temp.rSetPointTemp = 30.0;
						gInks[iIndex].parSw.tiDripTime = MILLISECONDS_TO_TIME(300*iIndex);
		
						gInksInputs[iIndex].xPrintHeadsPsuOK = TRUE;
						
						//Acknowledging whether chiller installed is related to inks system. Used later to execute some tests
						if(gInks[iIndex].parameters.InksChiller.iIndex > 0){
							iInksChillerIndex = gInks[iIndex].parameters.InksChiller.iIndex;
						}
					}
				}
			}
			
			
			//In uv machine model cases. Consider curing led bars mapping
			for (iIndexPrepareCuring = 1; iIndexPrepareCuring <= gMachine.Pt.Hw.iMaxCuringLedBars; iIndexPrepareCuring++)
			{
				if (gCuringLed[iIndexPrepareCuring].Parameters.xInstalled){
				//Checking were curing led is mapped and removing the ink bar mapped with his mapping index in previous lines
					gInks[gCuringLed[iIndexPrepareCuring].Parameters.iMappingBar].parSw.Config.iMappingBar = 0;	
					gInks[gCuringLed[iIndexPrepareCuring].Parameters.iMappingBar].parSw.xEnabledBarToPrint = FALSE;
				}		
			}
			
			//In case camera is installed, check its mapping to remove ink bar associated to that mapping previously
			if(gCamera.Parameters.xInstalled){
				gInks[gCamera.Parameters.iMappingBar].parSw.Config.iMappingBar = 0;
				gInks[gCamera.Parameters.iMappingBar].parSw.xEnabledBarToPrint = FALSE;
			}
			
			// Start inks
			for (iIndexBlock = 1; iIndexBlock <= gMachine.Pt.CT.iNumBlocks; iIndexBlock++)
			{
				if(gBlock[iIndexBlock].parSw.xEnableToMovements)
				{
					for (iIndex = 1; iIndex <= gBlock[iIndexBlock].parameters.Inks.iMaxBlockPrintBars; iIndex++)
					{
						if (gInks[iIndex].parSw.xEnabledBarToPrint){
							gInks[iIndex].ordersSw.xStartInks = TRUE;
							gInks[iIndex].ordersSw.xPowPrintHead = TRUE;
							iCheckInkStartedIndex = iIndex;
						}
					}
				}
			}
		
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Starting Inks");
			TEST_BUSY_CONDITION( (gMachine.St.exec.fast < exTimesPreFast + 50) && INKS_STARTED != gInks[iCheckInkStartedIndex].status.iInkStateSw); //We'll wait xx scan cycles
			nextState();
			break;

		case 2:
			strcpy(txStateDesc, "Waiting to stabilize");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 50 ); //We'll wait xx scan cycles
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Resetting alarms");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
			TEST_ASSERT_EQUAL_INT(INKS_STARTED, gInks[iCheckInkStartedIndex].status.iInkStateSw);
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
			
		case 4:
			strcpy(txStateDesc, "Remove reset button input");
			TEST_BUSY_CONDITION( gMachine.AlSummary.CurrentReasonStop[0]!=0 ); //We'll wait xx scan cycles
			gMachine.In.Buttons.xReset = FALSE;
			iTestState = 0;
			TEST_DONE;
			break;
		
		default:
			break;
	}	
}


_TEST test_CalibrateThicknessSensorWithoutMedia(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	
	//If the Test makes non sense, not execute it
	if (gPhotoCells.status.xInstalled){
		TEST_DONE;		
	}
	strcpy(txTest, "test_CalibrateThicknessSensorWithoutMedia");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gDing.Parameters.xDingInstalled = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Going to Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			gDing.In.xDingLow = FALSE;
			gDing.In.rHighDingMm = gDing.parSw.rCalibrationValue;
			gDing.Commands.xCalibrateThickness = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Calibrating Analog Sensor");
			TEST_BUSY_CONDITION( gDing.Commands.xCalibrateThickness );
			nextState();
			break;
		
		case 4:
			iTestState = 0;
			TEST_ASSERT(!gDing.State.xDingReferenced);
			gDing.In.rHighDingMm = 0;
			TEST_DONE;
			break;
		
		default:
			break;
	}		
}

_TEST test_CalibrateThicknessSensor(void)
{
	//If the Test makes non sense, not execute it
	if (gPhotoCells.status.xInstalled){
		TEST_DONE;		
	}
	
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	
	strcpy(txTest, "test_CalibrateThicknessSensor");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gDing.Parameters.xDingInstalled = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Going to Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			gDing.In.rHighDingMm = gDing.parSw.rCalibrationValue;
			gDing.In.xDingLow = TRUE;
			gDing.Commands.xCalibrateThickness = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Calibrating Analog Sensor");
			TEST_BUSY_CONDITION( gDing.Commands.xCalibrateThickness );
			nextState();
			break;
		
		case 4:
			iTestState = 0;
			gDing.In.rHighDingMm = 0;
			gDing.In.xDingLow = FALSE;
			TEST_ASSERT(gDing.State.xDingReferenced);
			TEST_DONE;
			break;
		
		default:
			break;
	}		
}

_TEST test_CalibrateNLaser(void)
{
	//If the Test makes non sense, not execute it
	if (!gPhotoCells.status.xInstalled || (gPhotoCells.status.xReferenced && iTestState==0)){
		TEST_DONE;		
	}
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	
	strcpy(txTest, "test_CalibrateNLaser");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToManual = TRUE;
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Going to Manual");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xManual );
			nextState();
			break;

		case 2:
			strcpy(txStateDesc, "Waiting to gear");
			TEST_BUSY_CONDITION(gPhotoCells.status.iSystemState != STP_GEARED && gPhotoCells.status.iSystemState != STP_STANDSTILL);
			gMachine.In.Buttons.xReset = FALSE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Setting the sensors to false");
			//Remove all signals to allow reference
			for (iIndex = 0; iIndex < MAX_LAST_NSENSOR; iIndex++)
			{
				gPhotoCells.Inputs.Signals.xPhotoCells[iIndex] = FALSE;
			}	
			gPhotoCells.commandsSw.xReference = TRUE;
			nextState();
			break;

		case 4:
			strcpy(txStateDesc, "Calibrating nLaserSensor");
			TEST_BUSY_CONDITION(gPhotoCells.commandsSw.xReference);
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Going down searching Reference Sensor");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION(gPhotoCells.status.xReferenced);
			TEST_BUSY_CONDITION(!gTransVacuum[1].Status.xAtSpeed && gTransVacuum[1].Status.xInstalled);
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 );
			TEST_ASSERT(gPhotoCells.parameters.xHomingEnabled);
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting nsensor are referenced");
			TEST_BUSY_CONDITION( !gPhotoCells.status.xReferencing );
			if (gPhotoCells.status.xReferencing && !gPhotoCells.status.xReferenced && gTransVacuum[1].Parameters.xInstalled){
				TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 );
				TEST_ASSERT(gTransVacuum[1].OrdersSw.xRunManual);
				TEST_ASSERT(gTransVacuum[1].parSw.rManSetPoint == 100.0);
			}
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Going up searching Reference Sensor");
			TEST_BUSY_CONDITION( !gPhotoCells.status.xReferenced );
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			if (gPhotoCells.status.xReferencing && gPhotoCells.status.xReferenced && gTransVacuum[1].Parameters.xInstalled){
				TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 );
				TEST_ASSERT(!gTransVacuum[1].OrdersSw.xRunManual);
			}
			nextState();
			break;
			
		case 8:
			strcpy(txStateDesc, "Waiting to finish referencing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION(gPhotoCells.status.iSystemState != STP_STANDSTILL);		
			nextState();
			break;
		
		case 9:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 20 ); //We'll wait xx scan cycles
			TEST_ASSERT(gPhotoCells.status.xReferenced);
			TEST_ASSERT(!gTransVacuum[1].OrdersSw.xRunManual);
			iTestState = 0;
			TEST_DONE;
			break;
		
		default:
			break;
	}		
}

_TEST test_ReferenceManualMotors(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_ReferenceManualMotors");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToManual = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Going to Manual");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xManual );
			nextState();
			break;

		case 2:
			strcpy(txStateDesc, "Executing icla home order");
			gBlock[1].commands.xIclaHomeOrder = TRUE;
			gBlock[2].commands.xIclaHomeOrder = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Referencing Iclas");
			TEST_BUSY_CONDITION( !gBlock[1].Status.Icla.xHomed || (!gBlock[2].Status.Icla.xHomed && gBlock[2].parameters.Hw.xExistBlock) );
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Executing tray out order");
			gBlock[1].commands.Manual.xManTrayOut = TRUE;
			gBlock[2].commands.Manual.xManTrayOut = TRUE;
			nextState();
			break;

		case 5:
			strcpy(txStateDesc, "Moving the tray Out to enable referencing");
			TEST_BUSY_CONDITION( !gBlock[1].In.xTrayOut || (!gBlock[2].In.xTrayOut && gBlock[2].parameters.Hw.xExistBlock) );
			nextState();
			break;

		case 6:
			strcpy(txStateDesc, "Executing bar home order");
			gBlock[1].commands.xBarHomeOrder = TRUE;
			gBlock[2].commands.xBarHomeOrder = TRUE;
			nextState();
			break;

		case 7:
			strcpy(txStateDesc, "Referencing vertical motors");
			TEST_BUSY_CONDITION( !gBlock[1].Status.Motor.xBarsHomed || (!gBlock[2].Status.Motor.xBarsHomed && gBlock[2].parameters.Hw.xExistBlock) );
			nextState();
			break;

		
		case 8:
			iTestState = 0;
			TEST_ASSERT(TRUE);

			strcpy(txTest, "test_PrepareMachine Finished!! Congrats!");
			strcpy(txStateDesc, "--");

			TEST_DONE;
			break;
		
		default:
			break;
	}		
}

_TEST test_ReferenceEhd(void)
{
	if (!gEdgeHoldDown.parameters.xInstalled || TRUE){
		TEST_DONE;		
	}
	
	strcpy(txTest, "test_ReferenceEhd");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Going to Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;
		
		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Going to auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;

		case 4:
			TEST_BUSY_CONDITION( !gMachine.St.Position.xInCap );
			nextState();
			break;
		
		case 5:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 6:
			strcpy(txStateDesc, "Going to Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 7:
			gSimMachine.Commands.xToManual = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xManual );
			nextState();
			break;
		
		case 8:
			TEST_BUSY_CONDITION( gEdgeHoldDown.status.iSystemState!= EHD_MANUAL );
			TEST_BUSY_CONDITION( gPairedMotors[1].status.iSystemState != STANDSTILL );
			TEST_BUSY_CONDITION( gPairedMotors[2].status.iSystemState != STANDSTILL );
			gEdgeHoldDown.commandsSw.xReference = TRUE;
			nextState();
			break;
		
		case 9:
			strcpy(txStateDesc, "Referencing EHD motors");
			TEST_BUSY_CONDITION( !gEdgeHoldDown.status.xReferenced );
			TEST_ASSERT(gEdgeHoldDown.status.xReferenced);
			TEST_ASSERT(gPairedMotors[1].Motor[1].rPositionMotor==gPairedMotors[1].Motor[2].rPositionMotor);
			TEST_ASSERT(gPairedMotors[1].Motor[1].rPositionMotor==gPairedMotors[1].parameters.rMechPositionMin);
			TEST_ASSERT(gPairedMotors[2].Motor[1].rPositionMotor==gPairedMotors[2].Motor[2].rPositionMotor);
			TEST_ASSERT(gPairedMotors[2].Motor[1].rPositionMotor==gPairedMotors[2].parameters.rMechPositionMin);
			strcpy(txStateDesc, "Disabling ehd");
			gEdgeHoldDown.parSw.xEnable=FALSE;
			gSimMachine.Commands.xToZero = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			
			nextState();
			break;
		
		case 10:
			strcpy(txStateDesc, "Setting ehd to resting position when disabled");
			gSimMachine.Commands.xToAuto = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			TEST_BUSY_CONDITION(gEdgeHoldDown.status.xEnabled);
			TEST_ASSERT(!gEdgeHoldDown.status.xEnabled);
			
			nextState();
			break;
	
		case 11:
			iTestState = 0;

			strcpy(txTest, "test_PrepareMachine Finished!! Congrats!");
			strcpy(txStateDesc, "--");

			TEST_DONE;
			break;
		
		default:
			break;
	}		
}


/*
B+R UnitTest: This is generated code.
Do not edit! Do not move!
Description: UnitTest Testprogramm infrastructure (TestSet).
LastUpdated: 2023-05-16 08:14:57Z
By B+R UnitTest Helper Version: 2.0.1.59
*/
UNITTEST_FIXTURES(fixtures)
{
	new_TestFixture("test_CheckMachine", test_CheckMachine), 
	new_TestFixture("test_GoToZero", test_GoToZero), 
	new_TestFixture("test_MachineLeft", test_MachineLeft), 
	new_TestFixture("test_PrepareBasicConfigLeft", test_PrepareBasicConfigLeft), 
	new_TestFixture("test_GoToManualFromZero", test_GoToManualFromZero), 
	new_TestFixture("test_StartInks01", test_StartInks01), 
	new_TestFixture("test_CalibrateThicknessSensorWithoutMedia", test_CalibrateThicknessSensorWithoutMedia), 
	new_TestFixture("test_CalibrateThicknessSensor", test_CalibrateThicknessSensor), 
	new_TestFixture("test_CalibrateNLaser", test_CalibrateNLaser), 
	new_TestFixture("test_ReferenceManualMotors", test_ReferenceManualMotors), 
	new_TestFixture("test_ReferenceEhd", test_ReferenceEhd), 
};

UNITTEST_CALLER_COMPLETE_EXPLICIT(PrepareMachine, "PrepareMachine", 0, 0, fixtures, 0, 0, 0);

