/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: PrePrepare
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

_TEST test_PrePrepareBasic(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_PrePrepareBasic");
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

			gMachine.parSw.Safety.rMarginSafePrint = 1.1;
			gMachine.parSw.Safety.rMountedPieceOverthickness = 4.0;
			
			gMachine.parSw.Dtp.xDoubleLine = FALSE;
			
			gMachine.parSw.Clean.tiCleaningByTime = MINUTES_TO_TIME(12*60);
			gMachine.parSw.Clean.tiToCleanWhenPrinterStopped = MINUTES_TO_TIME(12*60);
			gMachine.parSw.Clean.iCleanMotorSpeedFwd = 5000;
			gMachine.parSw.Clean.iCleanMotorSpeedBwd = 5000;
			gMachine.parSw.Clean.iCleaningType = 1;
			
			// Adding data for document
			gMachine.parSw.Media.rLength = 1600;
			gMachine.parSw.Media.rWidth = 1400;
			gMachine.parSw.Media.rGap = 600;
			gMachine.parSw.Media.rOffsetRegisterL1 = -700;
			
			//For machine models that detection system is defined by SW
			if (!gPhotoCells.status.xInstalled && !gDing.State.xDingInstalled){
				gMachine.parSw.Hw.xInstallnSensor = TRUE;		
			}

			gBelt.parSw.rAxisLength = 650.0;
			gBelt.parSw.rGearBox = 10.0;
			
			gDing.In.xModuleOK = TRUE;
			gDing.In.xDingChannelFault = FALSE;
			
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
				gSarm.Inputs.xModelInput[0]=TRUE;
				gSarm.ParSw.xEnabled=TRUE;
				gOverVarnish.Inputs.xModelInput[0]=TRUE;
				gOverVarnish.ParSw.xEnabled=gMachine.St.HwData.xIsWater;
				gOverVarnish.ParSw.xEnablePriming=TRUE;
				gDryerAnc.Inputs.xModelInput[0]=TRUE;
				gDryerAnc.ParSw.xEnabled=TRUE;
				gDryerAnc.Inputs.xInRemote=TRUE;
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
			iTestState = 0;
			TEST_DONE;
			break;
		
		default:
			break;
	}	
}


_TEST test_PrePrepareInks(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_PrePrepareInks");
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
						gInks[iIndex].parSw.PosPump.rSetPoint = 9.0;
						gInks[iIndex].parSw.NegPump.rSetPointMeniscus = 24;
						gInks[iIndex].parSw.Temp.rSetPointTemp = 30.0;
						gInks[iIndex].parSw.tiDripTime = MILLISECONDS_TO_TIME(300*iIndex);
		
						gInksInputs[iIndex].xPrintHeadsPsuOK = TRUE;
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
		
			nextState();
			break;

		case 1:
			strcpy(txTest, "test_PrePrepareInks Finished!! Congrats!");
			strcpy(txStateDesc, "--");
			
			iTestState = 0;
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
LastUpdated: 2023-06-20 10:08:36Z
By B+R UnitTest Helper Version: 2.0.1.59
*/
UNITTEST_FIXTURES(fixtures)
{
	new_TestFixture("test_PrePrepareBasic", test_PrePrepareBasic), 
	new_TestFixture("test_PrePrepareInks", test_PrePrepareInks), 
};

UNITTEST_CALLER_COMPLETE_EXPLICIT(PrePrepare, "PrePrepare", 0, 0, fixtures, 0, 0, 0);

