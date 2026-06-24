/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: ConsentsTests
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

_LOCAL TIME TimeLast;
_LOCAL TIME endtime;
_LOCAL UDINT diff_t;
_LOCAL STRING stringAux[120];

#define FALSE 0
#define TRUE 1

_LOCAL UDINT previousTileCounter;

void nextState(){
	exTimesPreFast = gMachine.St.exec.fast;
	exTimesPreSlow = gMachine.St.exec.slow;
	iTestState++;
	TimeLast = clock_ms();
	diff_t = diff_t;
	stringAux[120] = stringAux[120];
}

_TEST test_ReturningToPrint(void)
{
	strcpy(txTest, "test_ReturningToPrint");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gFeeder.ParSw.xEnabled=FALSE;
			gPrimer.ParSw.xEnabled=FALSE;
			gDryerAnc.ParSw.xEnabled=FALSE;
			gStacker.ParSw.xEnabled=FALSE;
			gMachine.parSw.Media.rLength = 1600;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( !gMachine.St.Position.xInCap );
			gSimMachine.Commands.xToProduction = TRUE;
			nextState();
			break;

		case 4:
			strcpy(txStateDesc, "Going to Production");
			TEST_BUSY_CONDITION( !gMachine.St.AutoMode.xProduction);
			gMachine.commandsSw.xStart_GI = FALSE;
			nextState();
			break;

		case 5:
			strcpy(txStateDesc, "Waiting to be GoingToPrint");
			TEST_BUSY_CONDITION( !gMachine.St.Position.xGoingToPrint );
			TEST_BUSY_CONDITION( gBlock[1].Status.rMotorPosition > gBlock[1].parameters.Motor.rDripBarsPosition - 10);
			nextState();
			break;

		case 6:
			strcpy(txStateDesc, "Order to Clean");
			if(!gMachine.Pt.xControlledByLine ){
				gBlock[1].commands.xForceCleanNoDelay = TRUE;
			}
			else{
				gLine.Commands.Clean = TRUE;
			}
			TEST_BUSY_CONDITION( !gBlock[1].Status.Position.xCleaning);
			nextState();
			break;

		case 7:
			strcpy(txStateDesc, "Waiting to remove the signal");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			gBlock[1].commands.xForceCleanNoDelay = FALSE;
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Waiting to start cleaning");
			TEST_BUSY_CONDITION(gBlock[1].Status.Position.xCleaning); //We'll wait xx scan cycles
			nextState();
			break;
		
		case 9:
			strcpy(txStateDesc, "Waiting to finish cleaning");
			TEST_BUSY_CONDITION( gBlock[1].Status.rMotorPosition > gBlock[1].parameters.Motor.rDripBarsPosition - 10);
			nextState();
			break;
		
		
		case 10:
			endtime = clock_ms();
			TEST_BUSY_CONDITION( endtime < TimeLast + 2000 ); //We'll wait xx ms
			//TEST_ASSERT(gBlock[1].Status.Position.xGoingToPrint || gBlock[1].Status.Position.xInPrint); //If variable is TRUE, the test is correct
			TEST_ASSERT(!gBlock[1].Status.Position.xCleaning);
			nextState();
			break;
			
		case 11:
			strcpy(txStateDesc, "Check activation of waste ink pump");
			if(gBlock[1].parameters.xWastedInkTankProcess){
				TEST_ASSERT(gBlock[1].Out.xWastedInkTankPump);
			}
			
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}


_TEST test_ReturningToCap(void)
{
	strcpy(txTest, "test_ReturningToCap");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			endtime = clock_ms();
			TEST_BUSY_CONDITION( endtime < TimeLast + 100 ); //We'll wait xx ms			
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;

		case 4:
			strcpy(txStateDesc, "Waiting to be in Cap or GoingToCap");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( !gBlock[1].Status.Position.xGoingToCap  && !gBlock[1].Status.Position.xInCap);
			nextState();
			break;

		case 5:
			TEST_BUSY_CONDITION(!gBlock[1].Status.Position.xInCap);
			nextState();
			break;

		case 6:
			strcpy(txStateDesc, "Order to Clean");
			if(!gMachine.Pt.xControlledByLine ){
				gBlock[1].commands.xForceCleanNoDelay = TRUE;
			}
			else{
				gLine.Commands.Clean = TRUE;
			}
			TEST_BUSY_CONDITION( !gBlock[1].Status.Position.xCleaning); //We'll wait xx scan cycles
			nextState();
			break;

		case 7:
			strcpy(txStateDesc, "Waiting to remove the signal");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			gBlock[1].commands.xForceCleanNoDelay = FALSE;
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Waiting to start cleaning");
			TEST_BUSY_CONDITION( !gBlock[1].Status.Position.xCleaning); //We'll wait xx scan cycles
			nextState();
			break;
		
		case 9:
			strcpy(txStateDesc, "Waiting to finish cleaning");
			TEST_BUSY_CONDITION( gBlock[1].Status.Position.xCleaning); //We'll wait xx scan cycles
			nextState();
			break;
		
		
		case 10:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			TEST_ASSERT(gBlock[1].Status.Position.xGoingToCap || gBlock[1].Status.Position.xInCap); //If variable is TRUE, the test is correct
			
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}


_TEST test_CheckAnyCleaningModeIsEnabled(void)
{
	strcpy(txTest, "test_CheckAnyCleaningModeIsEnabled");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gMachine.parSw.Clean.xCleanSystemByPieces = FALSE;
			gMachine.parSw.Clean.xCleanSystemByTime = FALSE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting to finish cleaning");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			TEST_ASSERT(gMachine.Al.Warning.xNoCleaningModeEnabled); //If variable is TRUE, the test is correct
			
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}



_TEST test_CleaningByTilesTwice(void)
{
	//If the Test makes non sense, not execute it.
	if (gMachine.Pt.PDSignalTpe==PDCFG_SENSOR){
			
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_CleaningByTilesTwice");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gMachine.parSw.Clean.xCleanSystemByPieces = TRUE;
			gSimMachine.Signals.xPDCarriageSignalL1 = FALSE; //To be sure to receive later the required edge
			gMachine.parSw.Clean.iPiecesNumberToCleanL1 = 10;
			gMachine.parSw.Clean.tiTimeDelayToCleanL1 = 1000;
			gMachine.parSw.Clean.tiTimeDelayGapToClean = 1000;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			endtime = clock_ms();
			TEST_BUSY_CONDITION( endtime < TimeLast + 100 ); //We'll wait xx ms			
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;

		case 4:
			strcpy(txStateDesc, "Waiting to be in Cap or GoingToCap");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( !gBlock[1].Status.Position.xGoingToCap  && !gBlock[1].Status.Position.xInCap);
			gMachine.commandsSw.xToNormal_GI = TRUE;
			nextState();
			break;

		case 5:
			strcpy(txStateDesc, "Waiting to be in Production");
			TEST_BUSY_CONDITION( !gMachine.St.AutoMode.xProduction );
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 20 ); //We'll wait xx scan cycles
			gSimMachine.Commands.xToProduction = TRUE;
			gMachine.commandsSw.xToNormal_GI = FALSE;
			nextState();
			break;
		
		case 6:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 20 ); //We'll wait xx scan cycles
			gMachine.commandsSw.xStart_GI = FALSE;
			TEST_BUSY_CONDITION( !gBelt.states.xRuningBelt );
			previousTileCounter = gMachine.Lg.udiPiecesCounterL1;
			gDing.In.xDingLow = TRUE;
			gDing.In.rHighDingMm = 5.0;
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Raising product detects when the belt running");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( endtime < TimeLast + 200 ); //We'll wait xx ms
			if(gMachine.Pt.PDSignalTpe==PDCFG_SENSOR){
				gSimMachine.Commands.Media.xContinuousMediaPresent = TRUE;
			}
			else{
				if (previousTileCounter == gMachine.Lg.udiPiecesCounterL1) {
					gSimMachine.Signals.xPDCarriageSignalL1 = TRUE;
					gSimMachine.Signals.xProductDetectL1 = TRUE;	
				}
				else {
					TimeLast = clock_ms();
					previousTileCounter = gMachine.Lg.udiPiecesCounterL1;
					gSimMachine.Signals.xPDCarriageSignalL1 = FALSE;
					gSimMachine.Signals.xProductDetectL1 = FALSE;
				}
			}
			TEST_BUSY_CONDITION( !gMachine.AutoCmd.xCleanningByPiecesL1);
			gSimMachine.Commands.Media.xContinuousMediaPresent = FALSE;
			nextState();
			break;
		case 8:
			strcpy(txStateDesc, "Waiting to start cleaning");
			gDing.In.xDingLow = FALSE;
			gDing.In.rHighDingMm = 0.0;
			TEST_BUSY_CONDITION( !gBlock[1].Status.Position.xCleaning);
			nextState();
			break;
		
		case 9:
			strcpy(txStateDesc, "Waiting to finish cleaning");
			TEST_BUSY_CONDITION( !gBlock[1].Status.Position.xInPrint); //We'll wait xx scan cycles
			gDing.In.xDingLow = TRUE;
			gDing.In.rHighDingMm = 5.0;
			nextState();
			break;
		
		case 10:
			strcpy(txStateDesc, "Raising product detects 2nd round");
			TEST_BUSY_CONDITION( !gBelt.states.xRuningBelt ); //We'll wait xx scan cycles
			endtime = clock_ms();
			TEST_BUSY_CONDITION( endtime < TimeLast + 200 ); //We'll wait xx ms
			if (previousTileCounter == gMachine.Lg.udiPiecesCounterL1) {
				gSimMachine.Signals.xPDCarriageSignalL1 = TRUE;
				gSimMachine.Signals.xProductDetectL1 = TRUE;
			}
			else {
				TimeLast = clock_ms();
				previousTileCounter = gMachine.Lg.udiPiecesCounterL1;
				gSimMachine.Signals.xPDCarriageSignalL1 = FALSE;
				gSimMachine.Signals.xProductDetectL1 = FALSE;
			}
			TEST_BUSY_CONDITION( !gMachine.AutoCmd.xCleanningByPiecesL1); //We'll wait xx scan cycles
			gSimMachine.Signals.xPDCarriageSignalL1 = FALSE;
			gSimMachine.Signals.xProductDetectL1 = FALSE;
			nextState();
			break;
		case 11:
			strcpy(txStateDesc, "Waiting to start cleaning");
			gDing.In.xDingLow = FALSE;
			gDing.In.rHighDingMm = 0.0;
			TEST_BUSY_CONDITION( !gBlock[1].Status.Position.xCleaning);
			nextState();
			break;
		
		case 12:
			strcpy(txStateDesc, "Waiting to finish cleaning");
			TEST_BUSY_CONDITION( gBlock[1].Status.Position.xCleaning); //We'll wait xx scan cycles
			nextState();
			break;
		
		case 13:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			TEST_ASSERT(gBlock[1].Status.Position.xGoingToPrint || gBlock[1].Status.Position.xInPrint); //Prior to cleaning, it was in production, in printin
			gMachine.parSw.Clean.xCleanSystemByPieces = FALSE;
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}

/* --- Test for DELOREAN-2123 Cleaning belt process stopping behaviour --- */
_TEST test_CleanBeltStop(void)
{
	//If the Test makes non sense, not execute it.
	if (!gMachine.Pt.Clean.xCleanBeltForUv || !gMachine.Pt.xControlledByLine){
		//This 2 lines just for the last TestCase
		strcpy(txTest, "test_CleanBeltForUv Finished!! Congrats!");
		strcpy(txStateDesc, "--");
			
		iTestState = 0;
		TEST_DONE;		
	}	
	
	strcpy(txTest, "test_CleanBeltStop");
	switch (iTestState)
	{
		case 0:
			gMachine.parSw.CleanBelt.iBeltTurns = 1;
			gSimMachine.Commands.xToZero = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx ms			
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;

		case 4:
			strcpy(txStateDesc, "Waiting to be in idle to send clean bealt order");
			TEST_BUSY_CONDITION (gLine.Status != LINE_IDLE);
			gMachine.commandsSw.xCleanBelt = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Check belt clean process is being executed");
			TEST_BUSY_CONDITION(gMachine.St.CleaningBelt.enState != CLN_BELT_CLEAN_CLOKWISE);
			gMachine.In.Buttons.xStop = TRUE;
			nextState();
			break;
			
		case 6:
			strcpy(txStateDesc, "Check belt cleaning stops");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			gMachine.In.Buttons.xStop = FALSE;
			endtime = clock_ms();
			TEST_BUSY_CONDITION( gMachine.St.CleaningBelt.enState != CLN_BELT_ERROR);// && endtime < TimeLast + 1000);
			TEST_ASSERT( gMachine.St.CleaningBelt.enState == CLN_BELT_ERROR );			
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Check belt cleaning grafcet status goes back to ready");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( gMachine.St.CleaningBelt.enState != CLN_BELT_READY_TO_CLEAN);// && endtime < TimeLast + 2000);
			TEST_ASSERT( gMachine.St.CleaningBelt.enState == CLN_BELT_READY_TO_CLEAN );			

			//This 2 lines just for the last TestCase
			strcpy(txTest, "test_CleaningTests Finished!! Congrats!");
			strcpy(txStateDesc, "--");
			
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}
/* --- End test for DELOREAN-2123 --- */

_TEST test_StopBelWhenMediaDetectInClean(void)
{
	strcpy(txTest, "test_StopBelWhenMediaDetectInClean");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gMachine.parSw.Clean.xCleanSystemByPieces = TRUE;
			gSimMachine.Signals.xPDCarriageSignalL1 = FALSE; //To be sure to receive later the required edge
			gMachine.parSw.Clean.iPiecesNumberToCleanL1 = 10;
			gMachine.parSw.Clean.tiTimeDelayToCleanL1 = 1000;
			gMachine.parSw.Clean.tiTimeDelayGapToClean = 1000;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			endtime = clock_ms();
			TEST_BUSY_CONDITION( endtime < TimeLast + 100 ); //We'll wait xx ms			
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;

		case 4:
			strcpy(txStateDesc, "Waiting to be in Cap or GoingToCap");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( !gBlock[1].Status.Position.xGoingToCap  && !gBlock[1].Status.Position.xInCap);
			gMachine.commandsSw.xToNormal_GI = TRUE;
			nextState();
			break;

		case 5:
			strcpy(txStateDesc, "Waiting to be in Production");
			TEST_BUSY_CONDITION( !gMachine.St.AutoMode.xProduction );
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 20 ); //We'll wait xx scan cycles
			gSimMachine.Commands.xToProduction = TRUE;
			gMachine.commandsSw.xToNormal_GI = FALSE;
			nextState();
			break;
		
		case 6:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 20 ); //We'll wait xx scan cycles
			gMachine.commandsSw.xStart_GI = FALSE;
			TEST_BUSY_CONDITION( !gBelt.states.xRuningBelt );
			previousTileCounter = gMachine.Lg.udiPiecesCounterL1;
			gDing.In.xDingLow = TRUE;
			gDing.In.rHighDingMm = 5.0;
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Raising product detects when the belt running");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( endtime < TimeLast + 200 ); //We'll wait xx ms
			if(gMachine.Pt.PDSignalTpe==PDCFG_SENSOR){
				gSimMachine.Commands.Media.xContinuousMediaPresent = TRUE;
			}
			else{
				if (previousTileCounter == gMachine.Lg.udiPiecesCounterL1) {
					gSimMachine.Signals.xPDCarriageSignalL1 = TRUE;
					gSimMachine.Signals.xProductDetectL1 = TRUE;	
				}
				else {
					TimeLast = clock_ms();
					previousTileCounter = gMachine.Lg.udiPiecesCounterL1;
					gSimMachine.Signals.xPDCarriageSignalL1 = FALSE;
					gSimMachine.Signals.xProductDetectL1 = FALSE;
				}
			}
			TEST_BUSY_CONDITION( !gMachine.AutoCmd.xCleanningByPiecesL1);
			gSimMachine.Commands.Media.xContinuousMediaPresent = FALSE;
			nextState();
			break;
		case 8:
			strcpy(txStateDesc, "Waiting to start cleaning");
			gDing.In.xDingLow = FALSE;
			gDing.In.rHighDingMm = 0.0;
			gPhotoCells.Inputs.Signals.xPhotoCells[1] = FALSE;
			TEST_BUSY_CONDITION( !gBlock[1].Status.Position.xCleaning);
			nextState();
			break;
		
		case 9: 
			strcpy(txStateDesc, "Detect Media In");
			if (gDing.State.xDingInstalled){
				gDing.In.xDingLow = TRUE;
				gDing.In.rHighDingMm = 5.0;
			}
			else{
				gPhotoCells.Inputs.Signals.xPhotoCells[1] = TRUE;
			}
			nextState();
			break;
		
		case 10:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
			TEST_ASSERT(!gBelt.states.xRuningBelt); //Prior to cleaning, it was in production, in printing
			nextState();
			break;
		
		case 11:
			strcpy(txStateDesc, "Waiting to finish cleaning");
			TEST_BUSY_CONDITION( gBlock[1].Status.Position.xCleaning); //We'll wait xx scan cycles
			gMachine.parSw.Clean.xCleanSystemByPieces = FALSE;
			gDing.In.xDingLow = FALSE;
			gPhotoCells.Inputs.Signals.xPhotoCells[1] = FALSE;
			//This 2 lines just for the last TestCase
			strcpy(txTest, "test_CleaningTests Finished!! Congrats!");
			strcpy(txStateDesc, "--");
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
		
//		case 12:
//			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
//			TEST_ASSERT(gBlock[1].Status.Position.xGoingToPrint || gBlock[1].Status.Position.xInPrint); //Prior to cleaning, it was in production, in printing			
//			gMachine.parSw.Clean.xCleanSystemByPieces = FALSE;
//			//This 2 lines just for the last TestCase
//			strcpy(txTest, "test_CleaningTests Finished!! Congrats!");
//			strcpy(txStateDesc, "--");
//			iTestState = 0;
//			TEST_DONE;
			
//			break;
		
//		default:
//			break;

	}
}

_TEST test_StopVenturiWhenCloseToEnd(void)
{
	strcpy(txTest, "test_StopVenturiWhenCloseToEnd");
	switch (iTestState)
	{
		case 0:
			strcpy(txStateDesc, "Preparing test conditions...");
			gSimMachine.Commands.xToZero = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;
		
		case 1:
			TEST_BUSY_CONDITION (!gMachine.St.Mode.xZero);
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;
		
		case 2:
			TEST_BUSY_CONDITION (!gMachine.St.Mode.xAuto);
			TEST_BUSY_CONDITION( !gBlock[1].Status.Position.xInCap);
			nextState();
			break;
		
		case 3:
			strcpy(txStateDesc, "Giving clean order...");
			TEST_BUSY_CONDITION ( gMachine.St.exec.fast < exTimesPreFast + 20 ); 
			gMachine.commands.xClean = TRUE;
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting for clean procss...");
			TEST_BUSY_CONDITION (!gBlock[1].Status.Position.xCleaning);
			TEST_BUSY_CONDITION (!gBlock[1].Status.Icla.xIsMoving);
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Venturi should turn on");
			TEST_BUSY_CONDITION ( gBlock[1].Status.Icla.rCurrentPosition <= gBlock[1].parameters.Icla.rLastHeadPosition);
			nextState();
			break;
			
		case 6:
			TEST_BUSY_CONDITION ( gBlock[1].Status.Icla.rCurrentPosition >= (gBlock[1].parameters.Icla.rLastHeadPosition));
			nextState();
			break;
			
		case 7:
			TEST_BUSY_CONDITION(gMachine.St.exec.slow < exTimesPreSlow +3);
			TEST_ASSERT(gBlock[1].Out.xVenturi);
			nextState();
			break;
			
		case 8:
			strcpy(txStateDesc, "Venturi should turn off");
			TEST_BUSY_CONDITION ( gBlock[1].Status.Icla.rCurrentPosition >= gBlock[1].parameters.Icla.rFirstHeadPosition);
			nextState();
			break;
			
		case 9:
			TEST_BUSY_CONDITION ( gMachine.St.exec.slow < exTimesPreSlow + 3); 
			TEST_ASSERT (!gBlock[1].Out.xVenturi);
			nextState();
			break;
		
		case 10:
			strcpy(txTest, "Waiting stop cleaning...");
			TEST_BUSY_CONDITION(gMachine.St.Cleaning.enCleaningState != CLN_NOT_CLEANING);
			TEST_BUSY_CONDITION(!gBlock[1].Status.Position.xInCap);
			nextState();
		
		case 11:
			strcpy(txTest, "test_CleaningTests finished");
			strcpy(txStateDesc, "--");
			iTestState = 0;
			TEST_DONE;
			break;
		
		default:
			break;
			
	}
}


_TEST test_CleanBeltForUv(void)
{
	//If the Test makes non sense, not execute it.
	if (!gMachine.Pt.Clean.xCleanBeltForUv){
		//This 2 lines just for the last TestCase
		strcpy(txTest, "test_CleanBeltForUv Finished!! Congrats!");
		strcpy(txStateDesc, "--");
			
		iTestState = 0;
		TEST_DONE;		
	}	
	
	strcpy(txTest, "test_CleanBeltForUv");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gMachine.parSw.CleanBelt.tiCleaningBeltByTime = 60000; //1 minute
			gMachine.parSw.CleanBelt.xCleanBeltByTime = TRUE;
			gMachine.parSw.CleanBelt.iBeltSpeed = gMachine.parSw.rBeltSpeedSetPoint + 5.0;
			gMachine.parSw.CleanBelt.iBeltTurns = 2;
			gMachine.In.CleanBelt.xOpenGuide = FALSE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx ms			
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;

		case 4:
			strcpy(txStateDesc, "Waiting to be in Cap or GoingToCap");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( !gBlock[1].Status.Position.xGoingToCap  && !gBlock[1].Status.Position.xInCap);
			gMachine.commandsSw.xToNormal_GI = TRUE;
			nextState();
			break;

		case 5:
			strcpy(txStateDesc, "Waiting to be in Production");
			TEST_BUSY_CONDITION( !gMachine.St.AutoMode.xProduction );
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 20 ); //We'll wait xx scan cycles
			gSimMachine.Commands.xToProduction = TRUE;
			TEST_BUSY_CONDITION( !gBelt.states.xRuningBelt );
			nextState();
			break;
		
		case 6:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 20 ); //We'll wait xx scan cycles
			endtime = clock_ms();
			TEST_BUSY_CONDITION( endtime <= TimeLast + gMachine.parSw.CleanBelt.tiCleaningBeltByTime*2 ); //We'll wait xx ms	
			nextState();
			break;


		case 7:
			strcpy(txStateDesc, "Waiting to be in Production");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 20 ); //We'll wait xx scan cycles
			if(!gMachine.Pt.xControlledByLine ){
				gMachine.commandsSw.xStop_GI = TRUE;
			}
			else{
				gLine.Commands.Stop = TRUE;
			}
			nextState();
			break;

		case 8:
			strcpy(txStateDesc, "Waiting to be ready to clean");
			TEST_BUSY_CONDITION(gBelt.states.xRuningBelt);
			if(!gMachine.Pt.xControlledByLine ){
			TEST_BUSY_CONDITION(!gMachine.St.AutoMode.xStop);
			}
			else{
			TEST_BUSY_CONDITION(!gLine.StatusSummary.xIdle);
			}
			TEST_BUSY_CONDITION(!gMachine.St.CleaningBelt.xCleanRequired); //We'll wait xx scan cycles
			TEST_ASSERT(gMachine.St.CleaningBelt.xCleanRequired);
			nextState();
			break;
		
		
		/* Test to check disable belt clean motor neumatic movements if cleaning system is out DELOREAN-1606 */
		case 9:
			strcpy(txStateDesc, "Send clean belt order");
			gMachine.commandsSw.xCleanBelt = TRUE;
			TEST_BUSY_CONDITION(!gMachine.AutoCmd.xCleanBelt); //We'll wait xx scan cycles
			TEST_ASSERT(gMachine.AutoCmd.xCleanBelt);
			nextState();
			break;
		
		case 10:
			strcpy(txStateDesc, "Check belt clean process is being executed");
			TEST_BUSY_CONDITION(!gMachine.St.CleaningBelt.xCleaningProcessOnGoing); //We'll wait xx scan cycles
			gMachine.commandsSw.xCleanBelt = FALSE;
			TEST_ASSERT(gMachine.St.CleaningBelt.xCleaningProcessOnGoing);
			TEST_ASSERT(gBelt.parameters.rSetPointSpeed=gMachine.parSw.CleanBelt.iBeltSpeed);
			nextState();
			break;
		
		/* Test to check delay on swaping clean belt motor direction DELOREAN-1607 */
		case 11:
			strcpy(txStateDesc, "Check belt clean motor moves forward");
			TEST_BUSY_CONDITION(!gMachine.commands.CleanBelt.xCleanBeltMoveFwd);
			TEST_ASSERT(gMachine.commands.CleanBelt.xCleanBeltMoveFwd );
			TEST_ASSERT(!gMachine.commands.CleanBelt.xCleanBeltMoveBwd );
			nextState();
			break;
			
		case 12:
			strcpy(txStateDesc, "Check belt clean motor stops");
			TEST_BUSY_CONDITION(gMachine.commands.CleanBelt.xCleanBeltMoveFwd);
			TEST_ASSERT(!gMachine.commands.CleanBelt.xCleanBeltMoveFwd );
			TEST_ASSERT(!gMachine.commands.CleanBelt.xCleanBeltMoveBwd );			
			nextState();
			break;
		
		case 13:
			strcpy(txStateDesc, "Check belt clean motor moves backward");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( endtime < TimeLast + 4000 );
			TEST_ASSERT(gMachine.commands.CleanBelt.xCleanBeltMoveFwd );
			TEST_ASSERT(!gMachine.commands.CleanBelt.xCleanBeltMoveBwd );			
			nextState();
			break;
		
		case 14:
			strcpy(txStateDesc, "Check belt clean motor stops");
			TEST_BUSY_CONDITION(gMachine.commands.CleanBelt.xCleanBeltMoveFwd);
			TEST_ASSERT(!gMachine.commands.CleanBelt.xCleanBeltMoveFwd );
			TEST_ASSERT(!gMachine.commands.CleanBelt.xCleanBeltMoveBwd );			
			nextState();
			break;
		
		case 15:
			strcpy(txStateDesc, "Check belt clean motor moves backward");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( endtime < TimeLast + gMachine.St.CleaningBelt.TimeDelaySwapDirBeltCleanMotor + 250 );
			TEST_ASSERT(!gMachine.commands.CleanBelt.xCleanBeltMoveFwd );
			TEST_ASSERT(gMachine.commands.CleanBelt.xCleanBeltMoveBwd );			
			nextState();
			break;
		
		case 16:
			strcpy(txStateDesc, "Check belt is stopped");
			TEST_BUSY_CONDITION(gMachine.St.CleaningBelt.xCleaningProcessOnGoing);
			TEST_ASSERT(!gMachine.commands.xRunBelt); //If variable is TRUE, the test is correct
			gMachine.parSw.CleanBelt.xCleanBeltByTime = FALSE;

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}


//DELOREAN-1606
_TEST test_CleanBeltForUvIsNotExecutedWhenGuideIsOpened(void)
{
	//If the Test makes non sense, not execute it.
	if (!gMachine.Pt.Clean.xCleanBeltForUv){
		//This 2 lines just for the last TestCase
		strcpy(txTest, "test_CleanBeltForUvIsNotExecutedWhenGuideIsOpened Finished!! Congrats!");
		strcpy(txStateDesc, "--");
			
		iTestState = 0;
		TEST_DONE;		
	}	
	
	strcpy(txTest, "test_CleanBeltForUvIsNotExecutedWhenGuideIsOpened");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gMachine.parSw.CleanBelt.tiCleaningBeltByTime = 60000; //1 minute
			gMachine.parSw.CleanBelt.xCleanBeltByTime = TRUE;
			gMachine.parSw.CleanBelt.iBeltSpeed = gMachine.parSw.rBeltSpeedSetPoint + 5.0;
			gMachine.parSw.CleanBelt.iBeltTurns = 2;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx ms			
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;

		case 4:
			strcpy(txStateDesc, "Waiting to be in Cap or GoingToCap");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( !gBlock[1].Status.Position.xGoingToCap  && !gBlock[1].Status.Position.xInCap);
			gMachine.commandsSw.xToNormal_GI = TRUE;
			nextState();
			break;

		case 5:
			strcpy(txStateDesc, "Waiting to be in Production");
			TEST_BUSY_CONDITION( !gMachine.St.AutoMode.xProduction );
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 20 ); //We'll wait xx scan cycles
			gSimMachine.Commands.xToProduction = TRUE;
			TEST_BUSY_CONDITION( !gBelt.states.xRuningBelt );
			nextState();
			break;
		
		case 6:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 20 ); //We'll wait xx scan cycles
			endtime = clock_ms();
			TEST_BUSY_CONDITION( endtime <= TimeLast + gMachine.parSw.CleanBelt.tiCleaningBeltByTime*2 ); //We'll wait xx ms	
			nextState();
			break;


		case 7:
			strcpy(txStateDesc, "Waiting to be in Production");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 20 ); //We'll wait xx scan cycles
			if(!gMachine.Pt.xControlledByLine ){
				gMachine.commandsSw.xStop_GI = TRUE;
			}
			else{
				gLine.Commands.Stop = TRUE;
			}
			gMachine.In.CleanBelt.xOpenGuide = TRUE;
			nextState();
			break;

		
		case 8:
			strcpy(txStateDesc, "Waiting to be ready to clean");
			TEST_BUSY_CONDITION(gBelt.states.xRuningBelt);
			if(!gMachine.Pt.xControlledByLine ){
				TEST_BUSY_CONDITION(!gMachine.St.AutoMode.xStop);
			}
			else{
				TEST_BUSY_CONDITION(!gLine.StatusSummary.xIdle);
			}
			//			TEST_BUSY_CONDITION(!gMachine.St.CleaningBelt.xCleanRequired);
			nextState();
			break;
		
		case 9:
			strcpy(txStateDesc, "Send clean belt order with blockage of clean belt motor position");
			gMachine.commandsSw.xCleanBelt = TRUE;
			TEST_BUSY_CONDITION(!gMachine.AutoCmd.xCleanBelt); //We'll wait xx scan cycles
			nextState();
			break;
		
		case 10:
			strcpy(txStateDesc, "Check if alarm is displayed and clean motor moved");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 );
			TEST_ASSERT(gMachine.Al.Warning.xCleanBeltSystemNotInPosition);
			TEST_ASSERT(!gMachine.commands.CleanBelt.xPistonFlojet);
			TEST_ASSERT(!gMachine.St.CleaningBelt.xCleanRequired);
			gMachine.In.CleanBelt.xOpenGuide = FALSE;
			nextState();
			break;		
		
		
		case 11:
			strcpy(txStateDesc, "Check belt is stopped");
			TEST_BUSY_CONDITION(!gMachine.St.CleaningBelt.xCleaningProcessOnGoing);
			TEST_ASSERT(gMachine.commands.xRunBelt);
			gMachine.parSw.CleanBelt.xCleanBeltByTime = FALSE;
			
			strcpy(txTest, "CleaningTests Finished!! Congrats!");
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
LastUpdated: 2023-05-22 13:38:39Z
By B+R UnitTest Helper Version: 2.0.1.59
*/
UNITTEST_FIXTURES(fixtures)
{
	new_TestFixture("test_ReturningToPrint", test_ReturningToPrint), 
	new_TestFixture("test_ReturningToCap", test_ReturningToCap), 
	new_TestFixture("test_CheckAnyCleaningModeIsEnabled", test_CheckAnyCleaningModeIsEnabled), 
	new_TestFixture("test_CleaningByTilesTwice", test_CleaningByTilesTwice), 
	new_TestFixture("test_CleanBeltStop", test_CleanBeltStop), 
	new_TestFixture("test_StopBelWhenMediaDetectInClean", test_StopBelWhenMediaDetectInClean), 
	new_TestFixture("test_StopVenturiWhenCloseToEnd", test_StopVenturiWhenCloseToEnd), 
	new_TestFixture("test_CleanBeltForUv", test_CleanBeltForUv), 
	new_TestFixture("test_CleanBeltForUvIsNotExecutedWhenGuideIsOpened", test_CleanBeltForUvIsNotExecutedWhenGuideIsOpened), 
};

UNITTEST_CALLER_COMPLETE_EXPLICIT(CleaningTests, "CleaningTests", 0, 0, fixtures, 0, 0, 0);

