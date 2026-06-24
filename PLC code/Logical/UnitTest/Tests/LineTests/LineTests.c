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
_LOCAL INT i;
_LOCAL INT iBeltTurns;

#define FALSE 0
#define TRUE 1


void nextState(){
	exTimesPreFast = gMachine.St.exec.fast;
	exTimesPreSlow = gMachine.St.exec.slow;
	iTestState++;
	TimeLast = clock_ms();	
	diff_t = diff_t;
	stringAux[120] = stringAux[120];
}


_TEST test_PrintingLine(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_PrintingLine");
	switch (iTestState)
	{
		case 0:
			//Line Configuration
			gLine.Inputs.UPSs[1].LoadOnBattery = FALSE;
			gFeeder.Inputs.xModelInput[0]=TRUE;
			gFeeder.ParSw.xEnabled=TRUE;
			gSimMachine.Commands.Media.xMediaIfFeederFeeding = TRUE;
			gPrimer.Inputs.xModelInput[0]=TRUE;
			gPrimer.ParSw.xEnabled=TRUE;
			gPrimer.ParSw.xEnablePriming=TRUE;
			if (gMachine.St.HwData.xIsWater){
				gSarm.Inputs.xModelInput[0]=FALSE;
				gSarm.ParSw.xEnabled=FALSE;
				gDryerAnc.Inputs.xModelInput[0]=TRUE;
				gDryerAnc.ParSw.xEnabled=TRUE;
				gDryerAnc.Inputs.xInRemote=TRUE;
			}
			else {
				gSarm.Inputs.xModelInput[0]=TRUE;
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
			gStacker.Status.Comms.xModuleOk=TRUE;
			gMachine.parSw.Media.rWidth = 1200.0;
			gMachine.parSw.Media.rLength = 1200.0;
			gMachine.parSw.Media.rGap = 100.0;
			
			gMachine.parSw.Electronics.xRobotReadyL1 = TRUE;
			gSimMachine.Commands.xToZero = TRUE;
			gMachine.parSw.rBeltSpeedSetPoint = 50.0;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			TEST_BUSY_CONDITION( gLine.Status != LINE_STOPPED );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;		
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;		
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			TEST_ASSERT(gLine.Status == LINE_PRINTING); 

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}


_TEST test_CheckPreprintingPosOrderWithAncillariesEnabled(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_CheckPreprintingPosOrderWithAncillariesEnabled");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;
		
		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
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
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Pause = TRUE;
			nextState();
			break;

		case 7:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 );
			TEST_BUSY_CONDITION( gLine.Status != LINE_PAUSED );
			TEST_BUSY_CONDITION( !gLine.Orders.Preprinting );
			nextState();
			break;
	
		case 8:
			strcpy(txStateDesc, "Waiting the line to control stop");
			gLine.Commands.Print = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_PREPARING_PRINT );
			TEST_ASSERT(gLine.Orders.Preprinting); 

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}	


_TEST test_CheckPreprintingPosOrderWithAncillariesDisabled(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_CheckPreprintingPosOrderWithAncillariesDisabled");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gFeeder.ParSw.xEnabled=FALSE;
			gPrimer.ParSw.xEnabled=FALSE;
			gSarm.ParSw.xEnabled=FALSE;
			nextState();
			break;
		
		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
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
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Pause = TRUE;
			nextState();
			break;

		case 7:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 );
			TEST_BUSY_CONDITION( gLine.Status != LINE_PAUSED );
			nextState();
			break;
	
		case 8:
			strcpy(txStateDesc, "Waiting the line to control stop");
			gLine.Commands.Print = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			TEST_ASSERT(!gLine.Orders.Preprinting);
		

			gFeeder.ParSw.xEnabled=TRUE;
			gPrimer.ParSw.xEnabled=TRUE;
			gSarm.ParSw.xEnabled=TRUE;
			
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}	


_TEST test_EmptyingBeltLine(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_EmptyingBeltLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			TEST_BUSY_CONDITION( gLine.Status != LINE_STOPPED );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;		
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.EmptyBelt = TRUE;
			nextState();
			break;		
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be emptying belts");
			
			TEST_BUSY_CONDITION( gLine.Status != LINE_BELT_EMPTYING );
			TEST_ASSERT(gLine.Status == LINE_BELT_EMPTYING); 
			TEST_ASSERT(!gThicknessCtrl.Outputs.xEnableMediaSignalToCb);
			gLine.Commands.Stop = TRUE;
			nextState();
			break;
			
		case 6:
			strcpy(txStateDesc, "Waiting the machine to be empty");
			TEST_BUSY_CONDITION( gLine.Status==LINE_IDLE ); 
			
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}

/* --- Test for DELOREAN-955 Check not curing when bars in cap position --- */
_TEST test_EmptyingBeltLineWithMediaEntering(void)
{	
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_EmptyingBeltLineWithMediaEntering");
	//If the Test makes non sense, not execute it. Only check for color cure because the behaviour is the same for all
	if (!gCuringLed[iIndexColorCuringLedBar].Parameters.xInstalled ){
		iTestState = 0;
		TEST_DONE;		
	}
	
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			TEST_BUSY_CONDITION( gLine.Status != LINE_STOPPED );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;		
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gSimMachine.Commands.Media.xContinuousMediaPresent = TRUE;
			gLine.Commands.EmptyBelt = TRUE;
			nextState();
			break;		
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be emptying belts");
			TEST_BUSY_CONDITION( gLine.Status != LINE_BELT_EMPTYING );
			TEST_ASSERT(gLine.Status == LINE_BELT_EMPTYING);
			TEST_ASSERT(!gThicknessCtrl.Outputs.xEnableMediaSignalToCb);
			/*gSimMachine.Commands.Media.xContinuousMediaPresent = TRUE;*/
			nextState();
			break;
			
		case 6:
			strcpy(txStateDesc, "Check that curing leds are not curing media");
			TEST_BUSY_CONDITION(!gThicknessCtrl.status.MediaPosition.L1.Color.xMediaInLedPosition);
			if(gMachine.St.Position.xInCap){
				TEST_ASSERT(!gCuringLed[iIndexColorCuringLedBar].Commands.RunCuring && gMachine.St.Position.xInCap);
			}
			gSimMachine.Commands.Media.xContinuousMediaPresent = FALSE;
			gLine.Commands.EmptyBelt = FALSE;
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}
	/* --- End Test for DELOREAN-955 --- */

_TEST test_CleaningLine(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_CleaningLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			TEST_BUSY_CONDITION( gLine.Status != LINE_STOPPED );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;		
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Clean = TRUE;
			nextState();
			break;		
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be cleaning");
			
			TEST_BUSY_CONDITION( gLine.Status != LINE_CLEANINGPH );
			TEST_ASSERT(gLine.Status == LINE_CLEANINGPH); 

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}


_TEST test_PoweringOffLine(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_PoweringOffLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			TEST_BUSY_CONDITION( gLine.Status != LINE_STOPPED );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;		
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.OrdersSw.Shutdown = TRUE;
			nextState();
			break;		
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to power off all devices");
			TEST_BUSY_CONDITION( gLine.Status != LINE_POWERING_OFF );
			TEST_ASSERT(gLine.Status == LINE_POWERING_OFF); 
			nextState();
			break;
			
		case 6:
			strcpy(txStateDesc, "Waiting the machine to be not powered");
			TEST_BUSY_CONDITION( gLine.Status != LINE_NOT_POWERED ); 
			TEST_ASSERT(gLine.Status == LINE_NOT_POWERED); 
			gLine.OrdersSw.Shutdown = FALSE;
			nextState();
			break;
			
		case 7:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gLine.Status != LINE_STOPPED ); 
			TEST_ASSERT(gLine.Status == LINE_STOPPED); 
			
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}


_TEST test_CleaningByTilesLine(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_CleaningByTilesLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gMachine.parSw.Clean.xCleanSystemByPieces = FALSE;
			gMachine.parSw.Clean.iPiecesNumberToCleanL1 = 10;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_STOPPED );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;		
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;		
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			gMachine.parSw.Clean.xCleanSystemByPieces = TRUE;
			gSimMachine.Commands.Media.xContinuousMediaPresent = TRUE;
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the line to be pausing");
			TEST_BUSY_CONDITION( gLine.Status != LINE_PAUSING );
			gSimMachine.Commands.Media.xContinuousMediaPresent = FALSE;
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to be cleaning");
			TEST_BUSY_CONDITION( !gLine.StatusSummary.xCleaning );
			TEST_ASSERT(gThicknessCtrl.status.Belt.xBeltEmpty );
			gMachine.parSw.Clean.xCleanSystemByPieces = FALSE;
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Waiting the line to be cleaning");
			TEST_BUSY_CONDITION( gLine.Status != LINE_CLEANINGPH );
			nextState();
			break;
		
		case 9:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			TEST_ASSERT(gBelt.states.xRuningBelt);
			TEST_ASSERT(gLine.Status == LINE_PRINTING);

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}



_TEST test_ReturnToPrintFromCleanLine(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_ReturnToPrintFromCleanLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
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
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Clean = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_PAUSED );
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to be cleaning");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_CLEANED );
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Waiting the line to return printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status == LINE_PREPARING_PRINT || gLine.Status == LINE_STARTING_PRINTING ); 
			TEST_ASSERT(gLine.Status == LINE_PRINTING); 

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}


_TEST test_ReturnToPrintFromPauseLine(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_ReturnToPrintFromPauseLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
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
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gMachine.In.Buttons.xStart = TRUE;
			nextState();
			break;		
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to pause");
			TEST_BUSY_CONDITION( gLine.Status != LINE_PAUSED );
			gMachine.In.Buttons.xStart = FALSE;
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Waiting the line to return printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status == LINE_PREPARING_PRINT || gLine.Status == LINE_STARTING_PRINTING ); 
			TEST_ASSERT(gLine.Status == LINE_PRINTING); 

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}


_TEST test_ReturnToPauseFromCleanedLine(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_ReturnToPauseFromCleanedLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
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
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gMachine.In.Buttons.xStart = TRUE; //Entering pause using phyisical start button
			nextState();
			break;		
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to pause");
			TEST_BUSY_CONDITION( gLine.Status != LINE_PAUSED );
			gMachine.In.Buttons.xStart = FALSE;
			gLine.Commands.Clean = TRUE;
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Waiting the line to be cleaning");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( !gLine.StatusSummary.xCleaning ); 
			nextState();
			break;
			
		case 9:
			strcpy(txStateDesc, "Waiting the line to finish cleaning");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.StatusSummary.xCleaning ); 
			nextState();
			break;
		
		case 10:
			strcpy(txStateDesc, "Waiting the line to return pausing");
			TEST_BUSY_CONDITION( gLine.Status == LINE_PAUSING ); 
			nextState();
			break;
		
		case 11:
			strcpy(txStateDesc, "Waiting the line to be paused");
			TEST_BUSY_CONDITION( !gLine.Status == LINE_PAUSED ); 
			TEST_ASSERT(gLine.Status == LINE_PAUSED); 

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}


_TEST test_ControlStopWhilePrintingLine(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_ControlStopWhilePrintingLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
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
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			if (gEdgeHoldDown.parSw.xEnable ){
				TEST_ASSERT(gEdgeHoldDown.status.xAdjustedToMedia);
				TEST_ASSERT(!gEdgeHoldDown.parameters.xEnableMovements);
			}
			TEST_ASSERT(gTransVacuum[1].Parameters.rVacPressureSetPointPerc == gTransVacuum[1].parSw.rVacPressureSetPointPerc);
			rPreviousVacPressureSp = gTransVacuum[1].Parameters.rVacPressureSetPointPerc;
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the line to control stop");
			gLine.Commands.Stop = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_CONTROLLED_STOP );
			TEST_ASSERT(gTransVacuum[1].Parameters.rVacPressureSetPointPerc == rPreviousVacPressureSp);
			nextState();
			break;		
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( gLine.Status == LINE_CONTROLLED_STOP );
			TEST_ASSERT(gLine.Status == LINE_STOPPED);
			if (gEdgeHoldDown.parSw.xEnable ){
				TEST_ASSERT(gEdgeHoldDown.status.iSystemState==EHD_IDLE);
				TEST_ASSERT(gPairedMotors[1].Motor[1].Inputs.xMinPositionReached);
				TEST_ASSERT(gPairedMotors[1].Motor[2].Inputs.xMinPositionReached);
				TEST_ASSERT(gPairedMotors[2].Motor[1].Inputs.xMaxPositionReached);
				TEST_ASSERT(gPairedMotors[2].Motor[2].Inputs.xMaxPositionReached);
			}

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}

_TEST test_ControlStopDueToSwCriticalConditionWhilePrintingLine(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_ControlStopDueToSwCriticalConditionWhilePrintingLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
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
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the line to control stop");
			gMachine.parSw.UI.xCriticalCondition = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_CONTROLLED_STOP ); 
			gMachine.parSw.UI.xCriticalCondition = FALSE;
			nextState();
			break;		
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( gLine.Status == LINE_CONTROLLED_STOP ); 
			TEST_ASSERT(gLine.Status == LINE_STOPPED); 

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}
	

_TEST test_PauseDueToFeederErrorWhilePrintingLine(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_PauseDueToFeederErrorWhilePrintingLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
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
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the line to pause");
			gSimFeeder.Commands.CreateError = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_PAUSING ); 
			gSimFeeder.Commands.CreateError = FALSE;
			nextState();
			break;	
			
		case 7:
			strcpy(txStateDesc, "Waiting the line to be paused");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status == LINE_PAUSING ); 
			TEST_ASSERT(gLine.Status == LINE_PAUSED);
			TEST_ASSERT(gFeeder.Alarms.xCriticalAlarm);
			nextState();
			break;		
		
		case 8:
			strcpy(txStateDesc, "Sending to print");
			gLine.Commands.Print = TRUE;
			TEST_BUSY_CONDITION( gFeeder.Alarms.xCriticalAlarm ); 
			TEST_ASSERT(!gFeeder.Alarms.xCriticalAlarm);
			TEST_ASSERT(gLine.Status == LINE_PREPARING_PRINT);

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}


_TEST test_GoingToPauseWhenPrintCommandIsReceivedWhileFeederIsInErrorLine(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_GoingToPauseWhenPrintCommandIsReceivedWhileFeederIsInErrorLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
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
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the line to pause");
			gSimFeeder.Commands.CreateError = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_PAUSING ); 
			nextState();
			break;	
			
		case 7:
			strcpy(txStateDesc, "Waiting the line to be paused");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status == LINE_PAUSING ); 
			TEST_ASSERT(gLine.Status == LINE_PAUSED);
			nextState();
			break;		
		
		case 8:
			strcpy(txStateDesc, "Sending to print");
			gLine.Commands.Print = TRUE;
			TEST_BUSY_CONDITION(gLine.Status == LINE_PAUSED);
			TEST_ASSERT(gLine.StatusSummary.xPrinting);
			nextState();
			break;
			
		case 9:
			strcpy(txStateDesc, "Waiting the line to be paused again");
			TEST_BUSY_CONDITION(gLine.StatusSummary.xPrinting);
			TEST_ASSERT(gLine.StatusSummary.xPausing);
			TEST_ASSERT(gFeeder.Alarms.xCriticalAlarm);
			gSimFeeder.Commands.CreateError = FALSE;

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}


_TEST test_ControlStopWhilePrepareToPrintLine(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_ControlStopWhilePrepareToPrintLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PREPARING_PRINT );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the line to control stop");
			gLine.Commands.Stop = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_CONTROLLED_STOP ); 
			nextState();
			break;		
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( gLine.Status == LINE_CONTROLLED_STOP ); 
			TEST_ASSERT(gLine.Status == LINE_STOPPED); 

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}	



_TEST test_ControlStopWhileStartingPrintingLine(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_ControlStopWhileStartingPrintingLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
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
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_STARTING_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the line to control stop");
			gLine.Commands.Stop = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_CONTROLLED_STOP ); 
			TEST_ASSERT(gTransVacuum[1].Parameters.rVacPressureSetPointPerc == rPreviousVacPressureSp);
			nextState();
			break;		
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( gLine.Status == LINE_CONTROLLED_STOP ); 
			TEST_ASSERT(gLine.Status == LINE_STOPPED); 

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}	
	

_TEST test_ControlStopWhilePausingLine(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_ControlStopWhilePausingLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;
		
		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
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
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Pause = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_PAUSING ); 
			nextState();
			break;

		case 7:
			strcpy(txStateDesc, "Waiting the line to control stop");
			gLine.Commands.Stop = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_CONTROLLED_STOP ); 
			nextState();
			break;		
		
		case 8:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( gLine.Status == LINE_CONTROLLED_STOP ); 
			TEST_ASSERT(gLine.Status == LINE_STOPPED); 

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}	


_TEST test_CleanCommandSentWhilePausingLine(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_CleanCommandSentWhilePausingLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;
		
		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
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
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 );
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 8);
			gLine.Commands.Pause = TRUE;
			TEST_BUSY_CONDITION(gLine.Status != LINE_PAUSING);
			gLine.Commands.Clean = TRUE;
			nextState();
			break;

		case 7:
			strcpy(txStateDesc, "Waiting the line to be paused");
			TEST_BUSY_CONDITION(gLine.Status != LINE_PAUSED);
			nextState();
			break;		
		
		case 8:
			strcpy(txStateDesc, "Waiting the line to be cleaning printheads");
			TEST_BUSY_CONDITION(gLine.Status == LINE_PAUSED);
			TEST_ASSERT(gLine.StatusSummary.xCleaning);
			nextState();
			break;
			
		case 9:
			strcpy(txStateDesc, "Waiting the line to come back to paused");
			TEST_BUSY_CONDITION(gLine.StatusSummary.xCleaning);
			TEST_ASSERT(gLine.StatusSummary.xPausing);

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}	


_TEST test_ControlStopWhilePausedLine(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_ControlStopWhilePausedLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;
		
		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
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
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Pause = TRUE;
			nextState();
			break;

		case 7:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PAUSED ); 
			TEST_ASSERT(gTransVacuum[1].Parameters.rVacPressureSetPointPerc < gTransVacuum[1].parSw.rVacPressureSetPointPerc);
			rPreviousVacPressureSp = gTransVacuum[1].Parameters.rVacPressureSetPointPerc;
			nextState();
			break;
	
		case 8:
			strcpy(txStateDesc, "Waiting the line to control stop");
			gLine.Commands.Stop = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_CONTROLLED_STOP ); 
			nextState();
			break;		
		
		case 9:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( gLine.Status == LINE_CONTROLLED_STOP ); 
			TEST_ASSERT(gLine.Status == LINE_STOPPED); 

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}	


_TEST test_ControlStopWhileBeltEmptyingLine(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_ControlStopWhileBeltEmptyingLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gMachine.parSw.rBeltSpeedSetPoint = gMachine.Pt.rBeltSpeedWhileEmptyBelt + 20.0;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
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
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;

		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			if (gCuringLed[iIndexColorCuringLedBar].Status.xInstalled){
				TEST_BUSY_CONDITION( !gCuringLed[iIndexColorCuringLedBar].Status.xEmitting );
			}
			nextState();
			break;
		
		case 6:
			gSimMachine.Commands.xToZero = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;
		
		case 7:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 8:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 9:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.EmptyBelt = TRUE;
			nextState();
			break;
		
		case 10:
			strcpy(txStateDesc, "Waiting the line to be emptying belts");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_BELT_EMPTYING );
			TEST_ASSERT(gBelt.parameters.rSetPointSpeed == gMachine.Pt.rBeltSpeedWhileEmptyBelt);
			TEST_ASSERT(gBelt.parameters.rSetPointSpeed != gMachine.parSw.rBeltSpeedSetPoint);
			TEST_ASSERT(gTransVacuum[1].Parameters.rVacPressureSetPointPerc > gTransVacuum[1].parSw.rVacPressureSetPointPerc);
			rPreviousVacPressureSp = gTransVacuum[1].Parameters.rVacPressureSetPointPerc;
			nextState();
			break;
		
		case 11:
			strcpy(txStateDesc, "Waiting the line to control stop");
			gLine.Commands.Stop = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_CONTROLLED_STOP );
			TEST_ASSERT(gTransVacuum[1].Parameters.rVacPressureSetPointPerc == rPreviousVacPressureSp);
			nextState();
			break;		
		
		case 12:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( gLine.Status == LINE_CONTROLLED_STOP );
			TEST_ASSERT(gLine.Status == LINE_STOPPED);
			nextState();
			break;

		case 13:
			strcpy(txStateDesc, "Waiting the line to be idle");
			TEST_BUSY_CONDITION( gLine.Status != LINE_IDLE );
			nextState();
			break;
		
		case 14:
			strcpy(txStateDesc, "Waiting the Clean order signal");
			
			iTestState = 0;
			TEST_DONE;

			break;
		
		default:
			break;
	}
}
	

_TEST test_ControlStopWhilePrepareToEmptyBeltLine(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_ControlStopWhilePrepareToEmptyBeltLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
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
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.EmptyBelt = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_PREPARING_EMPTYBELT );
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to control stop");
			gLine.Commands.Stop = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_CONTROLLED_STOP ); 
			nextState();
			break;		
		
		case 6:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( gLine.Status == LINE_CONTROLLED_STOP ); 
			TEST_ASSERT(gLine.Status == LINE_STOPPED); 

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}	



_TEST test_ControlStopWhileStartingEmptyBeltLine(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_ControlStopWhileStartingEmptyBeltLine");
	switch (iTestState)
	{
		case 0:
			gFeeder.ParSw.xEnabled=FALSE; //Disabling feeder to not active virtual media in SimMachine
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
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
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.EmptyBelt = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to start empty belt");
			TEST_BUSY_CONDITION( gLine.Status != LINE_STARTING_EMPTYBELT );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the line to control stop");
			TEST_BUSY_CONDITION( gLine.Status != LINE_CONTROLLED_STOP );
			nextState();
			break;		
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( gLine.Status == LINE_CONTROLLED_STOP );
			TEST_ASSERT(gLine.Status == LINE_STOPPED);
			gFeeder.ParSw.xEnabled=TRUE; //Enabling feeder again to use it in next tests
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}	


_TEST test_ControlStopWhileCleaningLine(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_ControlStopWhileCleaningLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
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
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Clean = TRUE;
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to be emptying belts");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_CLEANINGPH );
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Waiting the line to control stop");
			gLine.Commands.Stop = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_CONTROLLED_STOP );
			nextState();
			break;		
		
		case 9:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( gLine.Status == LINE_CONTROLLED_STOP );
			TEST_ASSERT(gLine.Status == LINE_STOPPED);

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}
	

_TEST test_ControlStopWhilePrepareToCleanLine(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_ControlStopWhilePrepareToCleanLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
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
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Clean = TRUE;
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to prepare to clean");
			TEST_BUSY_CONDITION( gLine.Status != LINE_PREPARING_CLEANPH );
			gLine.Commands.Stop = TRUE;
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Waiting the line to control stop");
			TEST_BUSY_CONDITION( gLine.Status != LINE_CONTROLLED_STOP ); 
			nextState();
			break;		
		
		case 9:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( gLine.Status == LINE_CONTROLLED_STOP );
			TEST_ASSERT(gLine.Status == LINE_STOPPED);
			nextState();
			break;
		
		case 10:
			strcpy(txStateDesc, "Waiting the machine to be start cleaning");
			gSimMachine.Commands.xToAuto = TRUE;
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			TEST_BUSY_CONDITION( gLine.Status != LINE_STARTING_CLEANINGPH );
			iTestState = 0;
			TEST_DONE;
		
		default:
			break;
	}
}	



_TEST test_ControlStopWhileStartingCleaningLine(void)
{
	if (!gMachine.Pt.xControlledByLine){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_ControlStopWhileStartingCleaningLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
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
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_IDLE );
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Clean = TRUE;
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to start empty belt");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_STARTING_CLEANINGPH );
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Waiting the line to control stop");
			gLine.Commands.Stop = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_CONTROLLED_STOP );
			nextState();
			break;		
		
		case 9:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( gLine.Status == LINE_CONTROLLED_STOP );
			TEST_ASSERT(gLine.Status == LINE_STOPPED);

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}	


_TEST test_CriticalAlarmWhilePrintingLine(void)
{
	if (!gMachine.Pt.xControlledByLine){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_CriticalAlarmWhilePrintingLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( gLine.Status !=  LINE_IDLE );
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to start printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the line to stop");
			gMachine.In.xPowerSwitch=FALSE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_ERROR);
			TEST_ASSERT(gMachine.Al.Alarm.xNoPowered);
			TEST_ASSERT(gMachine.AlSummary.xAlarmCritical);
			gMachine.In.xPowerSwitch=TRUE;
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to control stop");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gMachine.In.Buttons.xReset = TRUE;
			gSimMachine.Commands.xToZero = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			gSimMachine.Commands.xToAuto = TRUE;
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;		
		
		case 8:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_IDLE );
			TEST_ASSERT(gLine.Status == LINE_IDLE);

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}

_TEST test_CriticalAlarmDueToEhdJamAlarm(void)
{
	if (!gEdgeHoldDown.parameters.xInstalled || TRUE){
		TEST_DONE;		
	}
	
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_CriticalAlarmDueToEhdJamAlarm");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( gLine.Status !=  LINE_IDLE );
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to start printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the line to stop");
			gEdgeHoldDown.Alarms.xJam = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_ERROR);
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to control stop");
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gSimMachine.Commands.xToZero = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			gSimMachine.Commands.xToAuto = TRUE;
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;		
		
		case 8:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_IDLE );
			TEST_ASSERT(gLine.Status == LINE_IDLE);

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}	


_TEST test_EhdGoesToResetPositionWhenDisabled(void)
{
	if (!gEdgeHoldDown.parameters.xInstalled || TRUE){
		TEST_DONE;		
	}
	
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_EhdGoesToResetPositionWhenDisabled");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( gLine.Status !=  LINE_IDLE );
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to start printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Going to zero state");
			gSimMachine.Commands.xToZero = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;
			
		case 7:
			strcpy(txStateDesc, "Entering auto again");
			//gEdgeHoldDown.parSw.xEnable = FALSE;
			gSimMachine.Commands.xToAuto = TRUE;
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			TEST_ASSERT(gEdgeHoldDown.status.xEnabled);
			if(gCuringLed[iIndexColorCuringLedBar].Status.xInstalled){
				TEST_ASSERT(gCuringLed[iIndexColorCuringLedBar].Parameters.xCureByStretch);
				TEST_ASSERT(gCuringLed[iIndexColorCuringLedBar].Parameters.xOptimizeCuring);
			}
			nextState();
			break;		
		
		case 8:
			strcpy(txStateDesc, "Waiting the ehd to go to reset position");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 );
			TEST_BUSY_CONDITION( gLine.Status != LINE_IDLE );
			TEST_BUSY_CONDITION( !gEdgeHoldDown.status.xInRestingPosition );
			nextState();
			break;
				
		case 9:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gEdgeHoldDown.status.iSystemState!=EHD_STOPPED );
			TEST_ASSERT(!gEdgeHoldDown.status.xEnabled);
			TEST_BUSY_CONDITION( gCuringLed[iIndexColorCuringLedBar].Parameters.xCureByStretch );
			if(gCuringLed[iIndexColorCuringLedBar].Status.xInstalled && !gMachine.parSw.Curing.xCureByStretch){
				TEST_ASSERT(!gCuringLed[iIndexColorCuringLedBar].Parameters.xCureByStretch);
			}
			//gEdgeHoldDown.parSw.xEnable = TRUE;

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}	



_TEST test_JobNotLoadedWhilePrintingLine(void)
{	
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_JobNotLoadedWhilePrintingLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( gLine.Status !=  LINE_IDLE );
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to start printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			gSimMachine.Commands.Media.xContinuousMediaPresent = TRUE;
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the line to stop");
			gMachine.parSw.Electronics.xRobotReadyL1 =FALSE;
			TEST_BUSY_CONDITION(gLine.Status != LINE_ERROR && gLine.Status != LINE_STOPPED);
			TEST_ASSERT(gMachine.Al.Alarm.xNotLoadedImage);
			gSimMachine.Commands.Media.xContinuousMediaPresent = FALSE;
			gMachine.parSw.Electronics.xRobotReadyL1 =TRUE;
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to control stop");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gMachine.In.Buttons.xReset = TRUE;
			gSimMachine.Commands.xToZero = TRUE;
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			gSimMachine.Commands.xToAuto = TRUE;
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;		
		
		case 8:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_IDLE );
			TEST_ASSERT(gLine.Status == LINE_IDLE);

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}


_TEST test_JobNotLoadedWhilePrintingAndLineIsEmpty(void)
{
	
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_JobNotLoadedWhilePrintingAndLineIsEmpty");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gSimMachine.Commands.Media.xMediaIfFeederFeeding = FALSE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( gLine.Status !=  LINE_IDLE );
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to start printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the line to stop");
			TEST_BUSY_CONDITION( !gThicknessCtrl.status.Belt.xBeltEmpty );
			gMachine.parSw.Electronics.xRobotReadyL1=FALSE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_PAUSED);
			TEST_ASSERT(gLine.Status == LINE_PAUSED);
			if (gEdgeHoldDown.parSw.xEnable ){
				TEST_BUSY_CONDITION(!gEdgeHoldDown.parameters.xEnableMovements); 
				TEST_ASSERT(gEdgeHoldDown.parameters.xEnableMovements);
				TEST_ASSERT(gBlock[1].commands.xForcePreprintingPos);
			}
			gMachine.parSw.Electronics.xRobotReadyL1 =TRUE;
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to control stop");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gMachine.In.Buttons.xReset = TRUE;
			gSimMachine.Commands.xToZero = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			gSimMachine.Commands.xToAuto = TRUE;
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;		
		
		case 8:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_IDLE );
			TEST_ASSERT(gLine.Status == LINE_IDLE);
			if (gEdgeHoldDown.parSw.xEnable ){
				TEST_ASSERT(gEdgeHoldDown.status.iSystemState==EHD_IDLE);		
			}

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}



_TEST test_CriticalAlarmDueToDryerNotInRemoteWhilePrintingLine(void)
{
	if (!gMachine.Pt.xControlledByLine || !gDryerAnc.Parameters.xInstalled ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_CriticalAlarmDueToDryerNotInRemoteWhilePrintingLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( gLine.Status !=  LINE_IDLE );
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to start printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the line to stop");
			gDryerAnc.Inputs.xInRemote=FALSE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_ERROR );
			gDryerAnc.Inputs.xInRemote=TRUE;
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to control stop");
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gSimMachine.Commands.xToZero = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			gSimMachine.Commands.xToAuto = TRUE;
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;		
		
		case 8:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_IDLE );
			TEST_ASSERT(gLine.Status == LINE_IDLE);

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}


_TEST test_CriticalAlarmDueDryerStopButtonPressed(void)
{
	if (!gMachine.Pt.xControlledByLine || !gDryerAnc.Parameters.xInstalled ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_CriticalAlarmDueDryerStopButtonPressed");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( gLine.Status !=  LINE_IDLE );
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to start printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Pressing dryer stop button");
			gDryerAnc.Inputs.xStopButtonPressed=TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_ERROR );
			gDryerAnc.Inputs.xStopButtonPressed=FALSE;
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to control stop");
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gSimMachine.Commands.xToZero = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			gSimMachine.Commands.xToAuto = TRUE;
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;		
		
		case 8:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_IDLE );
			TEST_ASSERT(gLine.Status == LINE_IDLE);

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}



_TEST test_CriticalAlarmDueToStackerErrorWhilePrintingLine(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_CriticalAlarmDueToStackerErrorWhilePrintingLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( gLine.Status !=  LINE_IDLE );
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to start printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the line to stop");
			gSimStacker.Commands.CreateError = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_ERROR );
			gSimStacker.Commands.CreateError = FALSE;
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to control stop");
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gSimMachine.Commands.xToZero = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			gSimMachine.Commands.xToAuto = TRUE;
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;		
		
		case 8:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_IDLE );
			TEST_ASSERT(gLine.Status == LINE_IDLE);

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}		


_TEST test_CriticalAlarmDueToStackerStopsBeltsWhilePrintingLine(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_CriticalAlarmDueToStackerStopsBeltsWhilePrintingLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( gLine.Status !=  LINE_IDLE );
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to start printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the line to stop");
			gSimStacker.Commands.StopBelts = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_ERROR );
			gSimStacker.Commands.StopBelts = FALSE;
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to control stop");
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gSimMachine.Commands.xToZero = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			gSimMachine.Commands.xToAuto = TRUE;
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;		
		
		case 8:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_IDLE );
			TEST_ASSERT(gLine.Status == LINE_IDLE);

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}		


_TEST test_CriticalAlarmDueToOpvErrorWhilePrintingLine(void)
{
	if (!gMachine.St.HwData.xIsWater)
	{
		TEST_DONE;
	}
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_CriticalAlarmDueToOpvErrorWhilePrintingLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( gLine.Status !=  LINE_IDLE );
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to start printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the line to stop");
			gSimOverVarnish.Commands.CreateError = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_ERROR );
			gSimOverVarnish.Commands.CreateError = FALSE;
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to control stop");
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gSimMachine.Commands.xToZero = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			gSimMachine.Commands.xToAuto = TRUE;
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;		
		
		case 8:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_IDLE );
			TEST_ASSERT(gLine.Status == LINE_IDLE);

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}		



_TEST test_OutOfAutoWhilePrintingLine(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_OutOfAutoWhilePrintingLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
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
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to start printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the line to be in error state");
			gSimMachine.Commands.xToAuto = FALSE;
			gSimMachine.Commands.xToZero = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_STOPPED );
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_ASSERT(gLine.Status == LINE_STOPPED);

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}	



_TEST test_BarsComeBackToCapAfterZeroModeWhilePrintingLine(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_BarsComeBackToCapAfterZeroModeWhilePrintingLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
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
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to start printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the line to be in error state");
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_STOPPED );
			nextState();
			break;
			
		case 8:
			strcpy(txStateDesc, "Setting automatic mode");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gSimMachine.Commands.xToAuto = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 9:
			strcpy(txStateDesc, "Waiting the line to exit from print position");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gMachine.St.Position.xInPrint );
			nextState();
			break;
			
		case 10:
			strcpy(txStateDesc, "Waiting the bars to be in cap position");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( !gMachine.St.Position.xInCap );
			nextState();
			break;
		
		case 11:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			//If the Test makes non sense, not execute it
			if (!gBlock[1].parameters.xCappingProcess || !gBlock[1].In.xFrontDoorClosed){
				TEST_ASSERT(gMachine.St.Position.xInCap);
			
				//This 3 lines just for the last TestCase
				strcpy(txTest, "test_BarsComeBackToCapAfterZeroModeWhilePrintingLine Finished!! Congrats!");
				strcpy(txStateDesc, "--");
			
				iTestState = 0;
				TEST_DONE;		
			}
			else
			{
				TEST_BUSY_CONDITION( gBlock[1].Status.rMotorPosition != (gBlock[1].parameters.Motor.rCappingPosition) );
				TEST_ASSERT(gBlock[1].Out.xCappingWaterPump);
			
				iTestState = 0;
				TEST_DONE;
			
				break;
			}
			
	
		default:
			break;
	}
}	

_TEST test_BarsComeBackToCapAfterZeroModeWhileCleaningLine(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_BarsComeBackToCapAfterZeroModeWhileCleaningLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
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
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Clean = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to start printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_CLEANINGPH );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the line to be in error state");
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_STOPPED );
			nextState();
			break;
			
		case 8:
			strcpy(txStateDesc, "Setting automatic mode");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gSimMachine.Commands.xToAuto = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 9:
			strcpy(txStateDesc, "Waiting the line to exit from clean position");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gMachine.St.Position.xCleaning );
			nextState();
			break;
			
		case 10:
			strcpy(txStateDesc, "Waiting the bars to be in cap position");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( !gMachine.St.Position.xInCap );
			nextState();
			break;
		
		case 11:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			//If the Test makes non sense, not execute it
			if (!gBlock[1].parameters.xCappingProcess || !gBlock[1].In.xFrontDoorClosed){
				TEST_ASSERT(gMachine.St.Position.xInCap);
			
				//This 3 lines just for the last TestCase
				strcpy(txTest, "test_BarsComeBackToCapAfterZeroModeWhilePrintingLine Finished!! Congrats!");
				strcpy(txStateDesc, "--");
			
				iTestState = 0;
				TEST_DONE;		
			}
			else
			{
				TEST_BUSY_CONDITION( gBlock[1].Status.rMotorPosition != (gBlock[1].parameters.Motor.rCappingPosition) );
				TEST_ASSERT(gBlock[1].Out.xCappingWaterPump);
			
				iTestState = 0;
				TEST_DONE;
			
				break;
			}
			
		
		default:
			break;
	}
}	


_TEST test_PowerOffDevicesWhenVoltageFault(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_PowerOffDevicesWhenVoltageFault");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gLine.Inputs.xPrinterPowered = FALSE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_NOT_INITIALIZED );
			nextState();
			break;

		case 2:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Inputs.xPrinterPowered = TRUE;
			TEST_BUSY_CONDITION(gLine.Status != LINE_INITIALIZING);
			nextState();
			break;

		/* --- Test for NOZOMITWO-799 add a delay in the feeder main switch to avoid errors during the PLC reboot --- */
		case 3:
			strcpy(txStateDesc, "Checking delay power on feeder");
			endtime = clock_ms();
			TEST_BUSY_CONDITION ( endtime < TimeLast + gLine.Parameters.ExternalDevices[1].tiDelay);
			TEST_ASSERT (gLine.Outputs.ExternalDevices[2].xClose == FALSE);
			nextState();
			break;
		/* --- End test for NOZOMITWO-799 --- */

		case 4:
			strcpy(txStateDesc, "Waiting the line to switch on all devices");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION(gLine.Outputs.ExternalDevices[gLine.Parameters.iNumExternalDevices].xClose == FALSE);
			TEST_BUSY_CONDITION(gLine.Status != LINE_STOPPED);
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Inputs.xPrinterPowered = FALSE;
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the line to execute poweroff action");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_NOT_INITIALIZED );
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to switch off all devices");
			TEST_BUSY_CONDITION(gLine.Outputs.ExternalDevices[gLine.Parameters.iNumExternalDevices].xClose == TRUE);
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Waiting the line to be initializing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Inputs.xPrinterPowered = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_INITIALIZING );
			nextState();
			break;
			
		case 9:
			strcpy(txStateDesc, "Waiting the line to switch on all devices");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION(gLine.Outputs.ExternalDevices[gLine.Parameters.iNumExternalDevices].xClose == FALSE);
			TEST_BUSY_CONDITION(gLine.Status != LINE_STOPPED);
			nextState();
			break;
		
		case 10:
			strcpy(txStateDesc, "Waiting the line to be in stopped state");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_ASSERT(gLine.Status == LINE_STOPPED);

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}


_TEST test_RejectBeltEmptyingLine(void)
{
	//If the Test makes non sense, not execute it.
	if (!gThicknessCtrl.parameters.Reject.xRejectTracking){
		TEST_DONE;		
	}
	
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_RejectBeltEmptyingLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gFeeder.ParSw.xEnabled=FALSE; //Disabling feeder to not active virtual media in SimMachine
			gMachine.parSw.rBeltSpeedSetPoint = 50.0;
			
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
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
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to start printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Entering media intro printer");
			gSimMachine.Commands.Media.xContinuousMediaPresent = TRUE;
			TEST_BUSY_CONDITION(gThicknessCtrl.status.Belt.xBeltEmpty);
			nextState();
			break;
			
		case 7: 
			strcpy(txStateDesc, "Active critical alarm");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 1000 ); 
			gMachine.AlSummary.xAlarmCritical=TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_ERROR );
			gMachine.AlSummary.xAlarmCritical=FALSE;
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Waiting the line to control stop");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gMachine.In.Buttons.xReset = TRUE;
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;		
		
		case 9:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_IDLE );
			nextState();
			break;
		
		case 10:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.EmptyBelt = TRUE;
			gStacker.Inputs.Comms.xBeltsEmpty=FALSE;
			nextState();
			break;
		
		case 11:
			strcpy(txStateDesc, "Waiting the line to be emptying belts and removing ContinuousMediaPresent signal");
			TEST_BUSY_CONDITION( gLine.Status != LINE_BELT_EMPTYING );
			gSimMachine.Commands.Media.xContinuousMediaPresent = FALSE;
			nextState();
			break;
		
		case 12:
			strcpy(txStateDesc, "Waiting the HoldReject to activate");
			TEST_BUSY_CONDITION(!gStacker.Orders.xHoldReject); 
			gStacker.Inputs.Comms.xBeltsEmpty=TRUE;
			nextState();
			break;
		
		case 13:
			strcpy(txStateDesc, "Waiting the line to control stop");
			TEST_BUSY_CONDITION( gLine.Status != LINE_CONTROLLED_STOP ); 
			nextState();
			break;		
		
		case 14:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status == LINE_CONTROLLED_STOP );
			TEST_ASSERT(gThicknessCtrl.status.Belt.xBeltEmpty && gStacker.Inputs.Comms.xBeltsEmpty);
			if(gDryerAnc.Parameters.xInstalled){
				TEST_ASSERT(gDryerAnc.Inputs.xBeltEmpty);
			}
			gFeeder.ParSw.xEnabled=TRUE; //Enabling feeder again to use it in next tests

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}

_TEST test_RejectBeltEmptyingLineWhenPrinterIsEmpty(void)
{
	//If the Test makes non sense, not execute it.
	if (!gThicknessCtrl.parameters.Reject.xRejectTracking){
		TEST_DONE;		
	}
	
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_RejectBeltEmptyingLineWhenPrinterIsEmpty");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gFeeder.ParSw.xEnabled=FALSE; //Disabling feeder to not active virtual media in SimMachine
			gSimMachine.Commands.Media.xContinuousMediaPresent = FALSE;
			gMachine.parSw.rBeltSpeedSetPoint = 50.0;
			
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
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
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to start printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Checking line is empty");
			TEST_BUSY_CONDITION(!gPrimer.Inputs.Comms.xBeltEmpty);
			TEST_BUSY_CONDITION(!gThicknessCtrl.status.Belt.xBeltEmpty);
			nextState();
			break;
			
		case 7: 
			strcpy(txStateDesc, "Active critical alarm");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 1000 ); 
			gMachine.AlSummary.xAlarmCritical=TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_ERROR );
			gMachine.AlSummary.xAlarmCritical=FALSE;
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Waiting the line to control stop");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gMachine.In.Buttons.xReset = TRUE;
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;		
		
		case 9:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_IDLE );
			nextState();
			break;
		
		case 10:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.EmptyBelt = TRUE;
			nextState();
			break;
		
		case 11:
			strcpy(txStateDesc, "Waiting the line to be emptying belts");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_BELT_EMPTYING );
			if (!gThicknessCtrl.status.MediaPosition.xMediaBelowMachine){
				TEST_ASSERT(gBlock[1].parameters.Motor.rPrintPosition<gThicknessCtrl.parameters.rMountedMediaHeigh);		
			}
			nextState();
			break;
		
		case 12:
			strcpy(txStateDesc, "Reject active because printer is already empty");
			TEST_BUSY_CONDITION( !gThicknessCtrl.Outputs.xHoldReject ); 
			TEST_ASSERT(gThicknessCtrl.Outputs.xHoldReject);
			nextState();
			break;
		
		case 13:
			strcpy(txStateDesc, "Waiting the line to control stop");
			gLine.Commands.Stop = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_CONTROLLED_STOP ); 
			nextState();
			break;		
		
		case 14:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gLine.Status == LINE_CONTROLLED_STOP );
			TEST_ASSERT(gThicknessCtrl.status.Belt.xBeltEmpty && gStacker.Inputs.Comms.xBeltsEmpty);
			if(gDryerAnc.Parameters.xInstalled){
				TEST_ASSERT(gDryerAnc.Inputs.xBeltEmpty);
			}
			gFeeder.ParSw.xEnabled=TRUE;

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}

_TEST test_RushProof(void)
{
	//If the Test makes non sense, not execute it.
	if (!gThicknessCtrl.parameters.Reject.xRejectTracking){
		TEST_DONE;		
	}
	
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_RushProof");
	switch (iTestState)
	{
		case 0:
			gMachine.parSw.rBeltSpeedSetPoint = 20.0;
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			TEST_BUSY_CONDITION( gLine.Status != LINE_STOPPED );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;		
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_PREPARING_PRINT );
			nextState();
			break;		
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			gSimMachine.Commands.Media.xContinuousMediaPresent = TRUE;
			
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gThicknessCtrl.status.Belt.xBeltEmpty );
			//gThicknessCtrl.Commands.xRushProof = TRUE;
			gMachine.commandsSw.xRushProof= TRUE;
			nextState();
			break;
		
		case 7:
			TEST_BUSY_CONDITION(!gThicknessCtrl.Outputs.xReject && !gThicknessCtrl.Outputs.xHoldReject);
			TEST_ASSERT(gThicknessCtrl.Outputs.xReject || gThicknessCtrl.Outputs.xHoldReject); 
			gThicknessCtrl.Commands.xRushProof = FALSE;
			gSimMachine.Commands.Media.xContinuousMediaPresent = FALSE;
			
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}


_TEST test_RejectBecauseOfFifthSensorLine(void)
{
	//If the Test makes non sense, not execute it.
	if (!gThicknessCtrl.parameters.Reject.xRejectTracking){
		TEST_DONE;		
	}
	
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_RejectBecauseOfFifthSensorLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gMachine.parSw.rBeltSpeedSetPoint = 50.0;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_STOPPED );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;		
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;		
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			gSimMachine.Commands.Media.xContinuousMediaPresent = TRUE;
			
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gThicknessCtrl.status.Belt.xBeltEmpty );
			gPhotoCells.Inputs.Signals.xPhotoCells[5] = TRUE;
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to reject a board");
			TEST_BUSY_CONDITION(gThicknessCtrl.parameters.xBlockInProperPrintingPosition);
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10000 ); 
			TEST_ASSERT(!gThicknessCtrl.Outputs.xEnableMediaSignalToCb);
			TEST_BUSY_CONDITION(!gThicknessCtrl.Outputs.xReject && !gThicknessCtrl.Outputs.xHoldReject);
			TEST_ASSERT(gThicknessCtrl.Outputs.xReject || gThicknessCtrl.Outputs.xHoldReject); 
			gPhotoCells.Inputs.Signals.xPhotoCells[5] = FALSE;
			gSimMachine.Commands.Media.xContinuousMediaPresent = FALSE;
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Stopping");
			gLine.Commands.Stop = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_CONTROLLED_STOP );
			nextState();
			break;
		
		case 9:
			strcpy(txStateDesc, "Waiting the line to be idle");
			TEST_BUSY_CONDITION( gLine.Status != LINE_IDLE );
			
			nextState();
			break;
		
		case 10:
			strcpy(txStateDesc, "Waiting the Clean order signal");
			
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}


_TEST test_RejectBecauseOfFourthSensorLine(void)
{
	//If the Test makes non sense, not execute it.
	if (!gThicknessCtrl.parameters.Reject.xRejectTracking){
		TEST_DONE;		
	}
	
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_RejectBecauseOfFourthSensorLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gMachine.parSw.rBeltSpeedSetPoint = 50.0;
			gPhotoCells.parSw.Sensors[4].xToRejectMedia = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			TEST_BUSY_CONDITION( gLine.Status != LINE_STOPPED );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;		
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;		
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			gSimMachine.Commands.Media.xContinuousMediaPresent = TRUE;
			
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gThicknessCtrl.status.Belt.xBeltEmpty );
			gPhotoCells.Inputs.Signals.xPhotoCells[4] = TRUE;
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to reject a board");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 20 ); 
			TEST_BUSY_CONDITION(!gThicknessCtrl.Outputs.xReject && !gThicknessCtrl.Outputs.xHoldReject);
			TEST_ASSERT(gThicknessCtrl.Outputs.xReject || gThicknessCtrl.Outputs.xHoldReject); 
			gPhotoCells.Inputs.Signals.xPhotoCells[4] = FALSE;
			gSimMachine.Commands.Media.xContinuousMediaPresent = FALSE;
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Stopping");
			gLine.Commands.Stop = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_CONTROLLED_STOP );
			nextState();
			break;
		
		case 9:
			strcpy(txStateDesc, "Waiting the line to be idle");
			TEST_BUSY_CONDITION( gLine.Status != LINE_IDLE );
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			
			gPhotoCells.parSw.Sensors[4].xToRejectMedia = FALSE;
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}



_TEST test_WhiteCuringLedActivation(void)
{
	
	if (!gCuringLed[iIndexWhiteCuringLedBar].Status.xInstalled){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_WhiteCuringLedActivation");
	switch (iTestState)
	{
		case 0:
			gMachine.parSw.Media.rWidth = 1200.0;
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			TEST_BUSY_CONDITION( gLine.Status != LINE_STOPPED );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;		
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gInks[8].parSw.xColorLoadedInJob = TRUE;
			gLine.Commands.Print = TRUE;
			nextState();
			break;		
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			gSimMachine.Commands.Media.xContinuousMediaPresent = TRUE;
			
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gThicknessCtrl.status.Belt.xBeltEmpty );
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Waiting the led to be curing");
			TEST_BUSY_CONDITION(!gCuringLed[iIndexWhiteCuringLedBar].Status.xEmitting);
			TEST_ASSERT(gCuringLed[iIndexWhiteCuringLedBar].Status.xEmitting);  
			gSimMachine.Commands.Media.xContinuousMediaPresent = FALSE;
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Waiting the led to stop curing");
			TEST_BUSY_CONDITION(gCuringLed[iIndexWhiteCuringLedBar].Status.xEmitting);
			TEST_ASSERT(!gCuringLed[iIndexWhiteCuringLedBar].Status.xEmitting); 
			gInks[8].parSw.xColorLoadedInJob = FALSE;
			
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}

_TEST test_ColorCuringLedActivation(void)
{
	//If the Test makes non sense, not execute it.
	if (!gCuringLed[iIndexColorCuringLedBar].Parameters.xInstalled){
		iTestState = 0;
		TEST_DONE;		
	}
	
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_ColorCuringLedActivation");
	switch (iTestState)
	{
		case 0:
			gMachine.parSw.Media.rWidth = 1200.0;
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			TEST_BUSY_CONDITION( gLine.Status != LINE_STOPPED );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gMachine.In.Buttons.xReset = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;		
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;		
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			gSimMachine.Commands.Media.xContinuousMediaPresent = TRUE;
			
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gThicknessCtrl.status.Belt.xBeltEmpty );
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Waiting the led to be curing");
			TEST_BUSY_CONDITION(!gCuringLed[iIndexColorCuringLedBar].Status.xEmitting);
			TEST_ASSERT(gCuringLed[iIndexColorCuringLedBar].Status.xEmitting);  
			gSimMachine.Commands.Media.xContinuousMediaPresent = FALSE;
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Waiting the led to stop curing");
			TEST_BUSY_CONDITION(gCuringLed[iIndexColorCuringLedBar].Status.xEmitting);
			TEST_ASSERT(!gCuringLed[iIndexColorCuringLedBar].Status.xEmitting); 
			
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}


_TEST test_CuringLedOptimization(void)
{
	//If the Test makes non sense, not execute it.
	if (gMachine.Pt.CT.iNumCuringLeds==0){
		iTestState = 0;
		TEST_DONE;		
	}
	
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_CuringLedOptimization");
	switch (iTestState)
	{
		case 0:
			gMachine.parSw.Media.rWidth = 1200.0;
			gMachine.parSw.Document.rWidth = gMachine.parSw.Media.rWidth - 200.0;
			gMachine.parSw.Curing.xOptimizeCuring = TRUE;
			gEdgeHoldDown.parSw.xEnable=FALSE;
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;
		
		case 1:
			strcpy(txStateDesc, "To check curing led parameters saved are document's parameters");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gSimMachine.Commands.xToAuto = TRUE;
			TEST_BUSY_CONDITION( gEdgeHoldDown.status.xEnabled );
			nextState();
			break;

		case 2:
			TEST_BUSY_CONDITION( !gCuringLed[iIndexColorCuringLedBar].Status.xOptimizeCuring );
			TEST_ASSERT(gCuringLed[iIndexColorCuringLedBar].Status.iCuringAreaWidth == gCuringLed[iIndexColorCuringLedBar].Parameters.iDocumentWidth);
			gMachine.parSw.Curing.xOptimizeCuring = FALSE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_BUSY_CONDITION( gCuringLed[iIndexColorCuringLedBar].Status.xOptimizeCuring );
			TEST_ASSERT(gCuringLed[iIndexColorCuringLedBar].Status.iCuringAreaWidth == gCuringLed[iIndexColorCuringLedBar].Parameters.iMediaWidth);
			//gEdgeHoldDown.parSw.xEnable=TRUE;
			
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}



_TEST test_CuringLedSwitchedOffDueToSafetyCriticalAlarm(void)
{
	//If the Test makes non sense, not execute it.
	if (!gCuringLed[iIndexColorCuringLedBar].Parameters.xInstalled){
		iTestState = 0;
		TEST_DONE;		
	}
	
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_CuringLedSwitchedOffDueToSafetyCriticalAlarm");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			TEST_BUSY_CONDITION( gLine.Status != LINE_STOPPED );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;		
		
		case 4:
			strcpy(txStateDesc, "Generating safety critical alarm");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gSimSafetyController.Inputs.xPrinterFrontsideEstop = FALSE;
			nextState();
			break;		
		
		case 5:
			strcpy(txStateDesc, "Checking curing led status is OFF");
			TEST_BUSY_CONDITION( !gSafetyController.Alarms.xCriticalAlarm );
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_ASSERT(gCuringLed[iIndexColorCuringLedBar].Status.State == CURINGLED_OFF); 
			TEST_ASSERT(gChiller[gCuringLed[iIndexColorCuringLedBar].Parameters.iChillerIndex].Out.xStart);
			nextState();
			break;
			
		case 6:
			strcpy(txStateDesc, "Checking chiller is not powered off");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			TEST_ASSERT(gChiller[gCuringLed[iIndexColorCuringLedBar].Parameters.iChillerIndex].Out.xStart);
			gSimSafetyController.Commands.xSafetyToDefault = TRUE;
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Checking safety critical alarm is not reset even though emergency button has been released again");
			TEST_BUSY_CONDITION( !gSimSafetyController.Inputs.xPrinterFrontsideEstop );
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 20 ); 
			TEST_ASSERT(gSafetyController.Alarms.xCriticalAlarm);
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Checking safety critical alarm is reset");
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 20 ); 
			TEST_ASSERT(!gSafetyController.Alarms.xCriticalAlarm);
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}

/* --- Test DELOREAN-124 Cure by Speed function from UI --- */
_TEST test_CureBySpeed(void)
{
	//If the Test makes non sense, not execute it.
	if (gMachine.Pt.CT.iNumCuringLeds==0){
		iTestState = 0;
		TEST_DONE;		
	}
	
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_CureBySpeed");
	switch (iTestState)
	{
		case 0:
			gMachine.parSw.Media.rWidth = 1200.0;
			gCuringLed[iIndexColorCuringLedBar].parSw.IntensitySetPoint = 100;
			gMachine.parSw.Media.rLength = 1200.0;
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			TEST_BUSY_CONDITION( gLine.Status != LINE_STOPPED );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			gMachine.parSw.Curing.xCureBySpeed = FALSE;
			gMachine.parSw.rBeltSpeedSetPoint = 50.0;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto with CureBySpeed disabled");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gMachine.In.Buttons.xReset = TRUE;
			
			nextState();
			break;		
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;		
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			gSimMachine.Commands.Media.xContinuousMediaPresent = TRUE;
			
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gThicknessCtrl.status.Belt.xBeltEmpty );
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Waiting the led to be curing");
			TEST_BUSY_CONDITION(!gCuringLed[iIndexColorCuringLedBar].Status.xEmitting);
			TEST_ASSERT(gCuringLed[iIndexColorCuringLedBar].Status.xEmitting);
			nextState();
			break;
			
		case 8:
			strcpy(txStateDesc, "Check curing led intensity without CuredBySpeed");
			for (i=1;i<=gCuringLed[iIndexColorCuringLedBar].Parameters.iLampsQuantity;i++){
				TEST_ASSERT(gCuringLed[iIndexColorCuringLedBar].Lamp[i].Outputs.IntensityLampApplied == gCuringLed[iIndexColorCuringLedBar].parSw.IntensitySetPoint);
			}
			gMachine.parSw.Curing.xCureBySpeed = TRUE;
			nextState();
			break;
		
		case 9:
			strcpy(txStateDesc, "Waiting some scan cycles");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			nextState();
			break;			
					
		case 10:
			/* Only checks that the CuringBySpeed feature is modifying the Intensitiy set by UI, try to avoid working with intensity calculations that could deprecate the test in the future */
			strcpy(txStateDesc, "Check curing led intensity with CureBySpeed");
			TEST_ASSERT(gCuringLed[iIndexColorCuringLedBar].Lamp[1].Outputs.IntensityLampApplied != gCuringLed[iIndexColorCuringLedBar].parSw.IntensitySetPoint);
			gSimMachine.Commands.Media.xContinuousMediaPresent = FALSE;
			nextState();
			break;
		
		case 11:
			strcpy(txStateDesc, "Waiting the led to stop curing");
			TEST_BUSY_CONDITION(gCuringLed[iIndexColorCuringLedBar].Status.xEmitting);
			TEST_ASSERT(!gCuringLed[iIndexColorCuringLedBar].Status.xEmitting); 
			gMachine.parSw.Curing.xCureBySpeed = FALSE;
			gMachine.parSw.rBeltSpeedSetPoint = 15.0;
			gLine.Commands.Stop = TRUE;
			
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}
/* --- End Test DELOREAN-124 --- */

/* --- Test DELOREAN-962 Auto power on the curing bars after some delay --- */
_TEST test_AutoPowerOnCuringBars(void)
{
	//If the Test makes non sense, not execute it.
	if (gMachine.Pt.CT.iNumCuringLeds==0){
		
		iTestState = 0;
		TEST_DONE;		
	}
	
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_AutoPowerOnCuringBars");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 );
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			TEST_BUSY_CONDITION( gLine.Status != LINE_STOPPED );
			nextState();
			break;
		
		case 2:
			strcpy(txStateDesc, "Power OFF the curing bars");
			for (iIndexPrepareCuring = 1; iIndexPrepareCuring <= gMachine.Pt.Hw.iMaxCuringLedBars; iIndexPrepareCuring++)
			{
				gCuringLed[iIndexPrepareCuring].Signals.Outputs.xPowerOnLamps = FALSE;
			}

			TEST_BUSY_CONDITION( gCuringLed[iIndexWhiteCuringLedBar].Signals.Outputs.xPowerOnLamps || gCuringLed[iIndexColorCuringLedBar].Signals.Outputs.xPowerOnLamps || gCuringLed[iIndexPrimerCuringLedBar].Signals.Outputs.xPowerOnLamps);
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Check curing bars are power off");
			TEST_ASSERT( !gCuringLed[iIndexWhiteCuringLedBar].Signals.Outputs.xPowerOnLamps);
			TEST_ASSERT( !gCuringLed[iIndexColorCuringLedBar].Signals.Outputs.xPowerOnLamps); 
			TEST_ASSERT( !gCuringLed[iIndexPrimerCuringLedBar].Signals.Outputs.xPowerOnLamps);
			nextState();
			break;

		case 4:
			strcpy(txStateDesc, "Check after some seconds curing bars are power on again");
			// if after more than 30 seconds the curing bars continue powered off, then the test fails
			if (TimeLast + 30000 < clock_ms()){
				for (iIndexPrepareCuring = 1; iIndexPrepareCuring <= gMachine.Pt.Hw.iMaxCuringLedBars; iIndexPrepareCuring++)
				{
					if(gCuringLed[iIndexPrepareCuring].Parameters.xEnabled){
						TEST_ASSERT( gCuringLed[iIndexPrepareCuring].Signals.Outputs.xPowerOnLamps);
					}
				}
			
				iTestState = 0;
				TEST_DONE;
				break;
			}
			TEST_BUSY_CONDITION( !gCuringLed[iIndexColorCuringLedBar].Signals.Outputs.xPowerOnLamps);
			
			for (iIndexPrepareCuring = 1; iIndexPrepareCuring <= gMachine.Pt.Hw.iMaxCuringLedBars; iIndexPrepareCuring++)
			{
				if(gCuringLed[iIndexPrepareCuring].Parameters.xEnabled){
					TEST_ASSERT( gCuringLed[iIndexPrepareCuring].Signals.Outputs.xPowerOnLamps);
				}
			}
			endtime = clock_ms();
			//TEST_ASSERT( endtime > TimeLast + 2000); //minimum time powered off
			
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}
/* --- End Test DELOREAN-962 --- */

/* --- Test DELOREAN-478 Check Low/High flow nitrogen alarm behaviour --- */
_TEST test_CuringBarsNitrogenAl(void)
{
	//If the Test makes non sense, not execute it. Only check for CuringLed bar 2 because the behaviour is the same in all curing bars
	if (gMachine.Pt.CT.iNumCuringLeds==0){
		
		iTestState = 0;
		TEST_DONE;		
	}
	
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_CuringBarsNitrogenAl");
	switch (iTestState)
	{
		case 0:
			gMachine.parSw.Media.rWidth = 1200.0;
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			TEST_BUSY_CONDITION( gLine.Status != LINE_STOPPED );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;		
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 4 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;		
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		/* --- Test for DELOREAN-1817 Nitrogen flow alarms only active if the job contains white color --- */
		// This test will only being executed if the machine config has color curing bar + white curing bar installed
		case 6:
			if (!gCuringLed[iIndexWhiteCuringLedBar].Parameters.xInstalled){
				iTestState = 9;
				break;
			}
			else {
				gInks[8].parSw.xColorLoadedInJob = FALSE;
				gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xN2HighFlow = TRUE;
				TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 4 ); 
				nextState();
				break;
			}
		
		case 7:
			strcpy(txStateDesc, "Checking high nitrogen flow on white curing bar doesn't trigger warning alarm with white disabled");
			TEST_ASSERT(!gCuringLed[iIndexWhiteCuringLedBar].Alarms.xN2HighFlow && !gCuringLed[iIndexWhiteCuringLedBar].Parameters.xEnabled);
			gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xN2HighFlow = FALSE;
			gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xN2LowFlow = TRUE;
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Checking low nitrogen flow on white curing bar doesn't trigger stop alarm with white disabled");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( endtime < TimeLast + 5000 ); //We'll wait 5 seconds
			TEST_ASSERT(!gCuringLed[iIndexWhiteCuringLedBar].Alarms.xN2LowFlow && !gCuringLed[iIndexWhiteCuringLedBar].Parameters.xEnabled);
			TEST_ASSERT(gLine.Status != LINE_CONTROLLED_STOP );
			gCuringLed[iIndexWhiteCuringLedBar].Signals.Inputs.xN2LowFlow = FALSE;
			nextState();
			break;

		/* --- End Test DELOREAN-1817 --- */

		case 9:
			strcpy(txStateDesc, "Waiting nitrogen flow active ");
			TEST_BUSY_CONDITION(!gCuringLed[iIndexColorCuringLedBar].Commands.xRunNitrogenFlow);
			gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xN2HighFlow = TRUE;
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 4 ); 
			nextState();
			break;

		case 10:
			strcpy(txStateDesc, "Checking high nitrogen flow triggers warning alarm ");
			TEST_ASSERT(gCuringLed[iIndexColorCuringLedBar].Alarms.xN2HighFlow);
			gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xN2HighFlow = FALSE;
			gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xN2LowFlow = TRUE;
			nextState();
			break;
			
		case 11:
			strcpy(txStateDesc, "Checking low nitrogen flow triggers stop alarm ");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( endtime < TimeLast + 5000 ); //We'll wait 5 seconds
			TEST_ASSERT(gCuringLed[iIndexColorCuringLedBar].Alarms.xN2LowFlow);
			TEST_ASSERT(gCuringLed[iIndexColorCuringLedBar].AlSummary.iReasonStop[0] == 1);
			TEST_ASSERT(gLine.Status == LINE_STOPPED || gLine.Status == LINE_CONTROLLED_STOP );
			gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xN2LowFlow = FALSE;
			nextState();
			break;
			
		case 12:
			TEST_BUSY_CONDITION( gLine.Status != LINE_STOPPED);
			gMachine.In.Buttons.xReset = TRUE;
			
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}
/* --- End Test DELOREAN-478 --- */

/* --- Test DELOREAN-803 Auto power on the curing bars after deactivate curing by stretch to enable all the lamps --- */
_TEST test_EnableLampsAfterDisableCureByStretch(void)
{
	//If the Test makes non sense, not execute it. Only check for CuringLed bar 2 because the behaviour is the same in all curing bars
	if (!gCuringLed[iIndexColorCuringLedBar].Parameters.xInstalled || gEdgeHoldDown.status.xEnabled){
		
		iTestState = 0;
		TEST_DONE;		
	}
	
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_EnableLampsAfterDisableCureByStretch");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			TEST_BUSY_CONDITION( gLine.Status != LINE_STOPPED );
			nextState();
			break;
		
		case 2:
			strcpy(txStateDesc, "Enabling and disabling cure by stretch");
			gMachine.parSw.Curing.xCureByStretch = TRUE;
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gMachine.parSw.Curing.xCureByStretch = FALSE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Check curing bars are power off");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 4 ); 
			TEST_ASSERT( !gCuringLed[iIndexColorCuringLedBar].Signals.Outputs.xPowerOnLamps);
			nextState();
			break;

		case 4:
			strcpy(txStateDesc, "Check after some seconds curing bars are power on again");
			// if after more than 30 seconds the curing bars continue powered off, then the test fails
			if (TimeLast + 30000 < clock_ms()){
				TEST_ASSERT(gCuringLed[iIndexColorCuringLedBar].Signals.Outputs.xPowerOnLamps);
				iTestState = 0;
				TEST_DONE;
				break;
			}
			TEST_BUSY_CONDITION( !gCuringLed[iIndexColorCuringLedBar].Signals.Outputs.xPowerOnLamps);
			endtime = clock_ms();
			TEST_ASSERT( gCuringLed[iIndexColorCuringLedBar].Signals.Outputs.xPowerOnLamps);
			TEST_ASSERT( endtime > TimeLast + 2000); //minimum time powered off
			
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}
/* --- End Test DELOREAN-803 --- */

_TEST test_CuringLedActivationFiltered(void)
{
	//If the Test makes non sense, not execute it.
	if (gMachine.Pt.CT.iNumCuringLeds==0){
			
		iTestState = 0;
		TEST_DONE;		
	}
	
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_CuringLedActivationFiltered");
	switch (iTestState)
	{
		case 0:
			gMachine.parSw.Media.rWidth = 1200.0;
			gMachine.parSw.Media.rLength = (gMachine.Pt.iMediaFilter*10 - 10);
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			TEST_BUSY_CONDITION( gLine.Status != LINE_STOPPED );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Emptying belt");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); 
			gLine.Commands.EmptyBelt = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting belt empty");
			TEST_BUSY_CONDITION( !gThicknessCtrl.status.Belt.xBeltEmpty ); 
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gLine.Status != LINE_IDLE ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;		
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			gSimMachine.Commands.Media.xContinuousMediaPresent = TRUE;			
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Waiting media enters in printer");
			TEST_BUSY_CONDITION(!gSimMachine.Signals.xProductDetectL1);
			iBeltTurns = gThicknessCtrl.status.Belt.iBeltTurns;
			nextState();
			break;
		
		case 9:
			strcpy(txStateDesc, "Checking curing lamps don't cure media");
			if (gCuringLed[iIndexColorCuringLedBar].Status.xEmitting){
				TEST_ASSERT(!gCuringLed[iIndexColorCuringLedBar].Status.xEmitting);
				nextState();
				break;
			}
			endtime = clock_ms();
			TEST_BUSY_CONDITION( gThicknessCtrl.status.Belt.iBeltTurns > (iBeltTurns+1) ); //We'll wait belt to make two turns after very first pd signal
			TEST_ASSERT(!gCuringLed[iIndexColorCuringLedBar].Status.xEmitting);
			gSimMachine.Commands.Media.xContinuousMediaPresent = FALSE;
			nextState();
			break;
			
		case 10:
			gLine.Commands.Stop = TRUE;
			gMachine.parSw.Media.rLength = 1200.0; //Return the value to a correct one
			
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}

/* --- Test NOZOMITWO-1687 Check starting order of the line ancillaries and printer when emptying belt --- */
_TEST test_StartOrderEmptyBelt(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_StartOrderEmptyBelt");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 );
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			TEST_BUSY_CONDITION( gLine.Status != LINE_STOPPED );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;		
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 20 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_IDLE );
			gLine.Commands.EmptyBelt = TRUE;
			nextState();
			break;		
		
		case 5:
			strcpy(txStateDesc, "Checking: 1- Stacker");
			endtime = clock_ms();
			if (gStacker.ParSw.xEnabled){
				TEST_BUSY_CONDITION( gStacker.Status.CtrlStatus != STACKERCTRL_PREPARED && endtime < TimeLast + 60000);
				TEST_ASSERT( gStacker.Status.CtrlStatus == STACKERCTRL_PREPARED && gOverVarnish.Status.CtrlStatus == OPVCTRL_STOPPED && 
					!gBelt.states.xRuningBelt && gSarm.Status.CtrlStatus == SARMCTRL_STOPPED &&
					gPrimer.Status.CtrlStatus == PRIMERCTRL_STOPPED && gFeeder.Status.CtrlStatus == FEEDERCTRL_STOPPED);
			}
			if(gDryerAnc.Parameters.xInstalled){
				TEST_ASSERT(gDryerAnc.Status.CtrlStatus == DRYERCTRL_STOPPED);
			}
			nextState();
			break;
			
		case 6:
			strcpy(txStateDesc, "Checking: 2- OPV");
			endtime = clock_ms();
			if (gOverVarnish.ParSw.xEnabled){
				TEST_BUSY_CONDITION( gOverVarnish.Status.CtrlStatus != OPVCTRL_PREPARED && endtime < TimeLast + 60000);
				TEST_ASSERT(gOverVarnish.Status.CtrlStatus == OPVCTRL_PREPARED &&
					!gBelt.states.xRuningBelt && gSarm.Status.CtrlStatus == SARMCTRL_STOPPED && gPrimer.Status.CtrlStatus == PRIMERCTRL_STOPPED &&
					gFeeder.Status.CtrlStatus == FEEDERCTRL_STOPPED);
			}
			if(gDryerAnc.Parameters.xInstalled){
				TEST_ASSERT(gDryerAnc.Status.CtrlStatus == DRYERCTRL_STOPPED);
			}
			nextState();
			break;
			
		case 7:
			strcpy(txStateDesc, "Checking: 3- Dryer");
			endtime = clock_ms();
			if (gDryerAnc.ParSw.xEnabled){
				TEST_BUSY_CONDITION( gDryerAnc.Status.CtrlStatus != DRYERCTRL_MOVING && endtime < TimeLast + 60000);
				TEST_ASSERT(gDryerAnc.Status.CtrlStatus == DRYERCTRL_MOVING && !gBelt.states.xRuningBelt && gSarm.Status.CtrlStatus == SARMCTRL_STOPPED &&
				gPrimer.Status.CtrlStatus == PRIMERCTRL_STOPPED && gFeeder.Status.CtrlStatus == FEEDERCTRL_STOPPED);
			}
			nextState();
			break;
			
		case 8:
			strcpy(txStateDesc, "Checking: 4- Printer");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( !gBelt.states.xRuningBelt && endtime < TimeLast + 60000);
			TEST_ASSERT(gBelt.states.xRuningBelt && gSarm.Status.CtrlStatus == SARMCTRL_STOPPED && gPrimer.Status.CtrlStatus == PRIMERCTRL_STOPPED &&
				gFeeder.Status.CtrlStatus == FEEDERCTRL_STOPPED);
			nextState();
			break;
		
		case 9:
			strcpy(txStateDesc, "Checking: 5- Sarm");
			endtime = clock_ms();
			if (gSarm.ParSw.xEnabled){
				TEST_BUSY_CONDITION( gSarm.Status.CtrlStatus != SARMCTRL_STARTING && endtime < TimeLast + 60000);
				TEST_ASSERT(gSarm.Status.CtrlStatus == SARMCTRL_STARTING && gPrimer.Status.CtrlStatus == PRIMERCTRL_STOPPED && 
					gFeeder.Status.CtrlStatus == FEEDERCTRL_STOPPED);
			}
			nextState();
			break;
			
		case 10:
			strcpy(txStateDesc, "Checking: 6- Primer");
			endtime = clock_ms();
			if (gPrimer.ParSw.xEnabled ){
				TEST_BUSY_CONDITION( gPrimer.Status.CtrlStatus != PRIMERCTRL_PREPARED && endtime < TimeLast + 60000);
				TEST_ASSERT(gPrimer.Status.CtrlStatus == PRIMERCTRL_PREPARED && gFeeder.Status.CtrlStatus == FEEDERCTRL_STOPPED);
			}
			nextState();
			break;
			
		case 11:
			strcpy(txStateDesc, "Checking: 7- Feeder");
			endtime = clock_ms();
			if (gFeeder.ParSw.xEnabled ){
				TEST_BUSY_CONDITION( gFeeder.Status.CtrlStatus != FEEDERCTRL_PREPARED && endtime < TimeLast + 60000);
				TEST_ASSERT(gFeeder.Status.CtrlStatus == FEEDERCTRL_PREPARED);
			}
			nextState();
			break;
			
		case 12:
			strcpy(txStateDesc, "Waiting to line idle");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( gLine.Status != LINE_IDLE && endtime < TimeLast + 60000);
			
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}
/* --- End Test NOZOMITWO-1687 --- */


/* --- Test DELOREAN-2508 Feeder central offset --- */
_TEST test_FeederTypeOffset(void)
{
	if (!gMachine.Pt.xControlledByLine ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_FeederTypeOffset");
	switch (iTestState)
	{
		case 0:
			gFeeder.ParSw.xEnabled=TRUE;
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 );
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			TEST_BUSY_CONDITION( gLine.Status != LINE_STOPPED );
			gFeeder.Inputs.xModelInput[0] = TRUE;
			gFeeder.Inputs.xModelInput[1] = FALSE;
			gFeeder.Inputs.xModelInput[2] = FALSE;
			nextState();
			break;

		case 2:
			strcpy(txStateDesc, "Check feeder bottom 1.4 hw values");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 400 ); 
			TEST_ASSERT(gFeeder.Parameters.Hw.iMaxMediaWidth == 1400 && gFeeder.Parameters.Hw.iMaxMediaLength == 3000 && gFeeder.Parameters.Hw.xOffsetAvailable == FALSE);
			gFeeder.Inputs.xModelInput[0] = FALSE;
			gFeeder.Inputs.xModelInput[1] = TRUE;
			gFeeder.Inputs.xModelInput[2] = FALSE;
			
			nextState();
			break;		
		
		case 3:
			strcpy(txStateDesc, "Check feeder bottom 1.8 hw values");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 400 ); 
			TEST_ASSERT(gFeeder.Parameters.Hw.iMaxMediaWidth == 1800 && gFeeder.Parameters.Hw.iMaxMediaLength == 3000 && gFeeder.Parameters.Hw.xOffsetAvailable == TRUE &&
				gFeeder.Parameters.Hw.iMaxOffset == 15 && gFeeder.Parameters.Hw.iMinOffset == -15);
			gFeeder.Inputs.xModelInput[0] = TRUE;
			gFeeder.Inputs.xModelInput[1] = TRUE;
			gFeeder.Inputs.xModelInput[2] = FALSE;
			nextState();
			break;		
		
		case 4:
			strcpy(txStateDesc, "Check feeder top hw values");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 400 ); 
			TEST_ASSERT(gFeeder.Parameters.Hw.iMaxMediaWidth == 1800 && gFeeder.Parameters.Hw.iMaxMediaLength == 3200 && gFeeder.Parameters.Hw.xOffsetAvailable == FALSE);
			gFeeder.Inputs.xModelInput[0] = TRUE;
			gFeeder.Inputs.xModelInput[1] = FALSE;
			gFeeder.Inputs.xModelInput[2] = FALSE;
			
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}
/* --- End Test DELOREAN-2508 --- */

/* --- Tests NOZOMITWO-1912 Water clean belt system --- */

_TEST test_CleaningBeltLine(void)
{
	if (!gMachine.Pt.xControlledByLine || !gMachine.Pt.Clean.xCleanBeltWater ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_CleaningBeltLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			TEST_BUSY_CONDITION( gLine.Status != LINE_STOPPED );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;		
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");	
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;

		case 6:
			strcpy(txStateDesc, "Waiting the machine to be empty");
			TEST_BUSY_CONDITION( !gThicknessCtrl.status.Belt.xBeltEmpty );
			gLine.Commands.Stop = TRUE;
			nextState();
			break;
		
		
		case 7:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gBeltClean.Status.State == BCLEAN_FAULT || gLine.Status != LINE_IDLE ); 
			gBeltClean.CommandsSw.xClean = TRUE;
			nextState();
			break;		
		
		case 8:
			strcpy(txStateDesc, "Waiting the line to be cleaning");
			
			TEST_BUSY_CONDITION( gLine.Status != LINE_CLEANINGBELT );
			TEST_ASSERT(gLine.Status == LINE_CLEANINGBELT);

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}

_TEST test_CleaningBeltByPiecesLine(void)
{
	if (!gMachine.Pt.xControlledByLine || !gMachine.Pt.Clean.xCleanBeltWater ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_CleaningBeltByPiecesLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gBeltClean.ParSw.xEnabledByPieces = FALSE;
			gBeltClean.ParSw.iPiecesToClean = 5;
			gMachine.parSw.rBeltSpeedSetPoint = 50.0;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			TEST_BUSY_CONDITION( gLine.Status != LINE_STOPPED );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( gBeltClean.Status.State == BCLEAN_FAULT );
			nextState();
			break;		
		
		case 5:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); 
			nextState();
			break;	
		
		case 6:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( gBeltClean.Status.State == BCLEAN_FAULT );
			nextState();
			break;	
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to be printing");
			gLine.Commands.Print = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			gBeltClean.ParSw.xEnabledByPieces = TRUE;
			gSimMachine.Commands.Media.xContinuousMediaPresent = TRUE;
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Waiting the line to be pausing");
			TEST_BUSY_CONDITION( gLine.Status != LINE_PAUSING );
			gSimMachine.Commands.Media.xContinuousMediaPresent = FALSE;
			nextState();
			break;
		
		case 9:
			strcpy(txStateDesc, "Waiting the line to be cleaning");
			TEST_BUSY_CONDITION( gLine.Status != LINE_CLEANINGBELT );
			nextState();
			break;

		case 10:
			strcpy(txStateDesc, "Waiting the line to be cleaning");
			TEST_BUSY_CONDITION( !gLine.StatusSummary.xCleaning );
			TEST_ASSERT(gThicknessCtrl.status.Belt.xBeltEmpty );
			nextState();
			break;
		
		case 11:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			gBeltClean.ParSw.xEnabledByPieces = FALSE;
			TEST_ASSERT(gBelt.states.xRuningBelt);
			TEST_ASSERT(gLine.Status == LINE_PRINTING);
			gMachine.parSw.rBeltSpeedSetPoint = 15.0;

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}


_TEST test_ControlStopWhileCleaningBeltLine(void)
{
	if (!gMachine.Pt.xControlledByLine || !gMachine.Pt.Clean.xCleanBeltWater ){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_ControlStopWhileCleaningBeltLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
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
			gMachine.In.Buttons.xReset = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			TEST_BUSY_CONDITION( gBeltClean.Status.State == BCLEAN_FAULT );
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); 
			gBeltClean.CommandsSw.xClean = TRUE;
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to be emptying belts");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_CLEANINGBELT );
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Waiting the line to control stop");
			gLine.Commands.Stop = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_CONTROLLED_STOP );
			nextState();
			break;		
		
		case 9:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); 
			TEST_BUSY_CONDITION( gLine.Status == LINE_CONTROLLED_STOP );
			TEST_ASSERT(gLine.Status == LINE_STOPPED);
			gMachine.In.Buttons.xReset = TRUE;

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}


_TEST test_ControlStopWhilePrepareToCleanBeltLine(void)
{
	if (!gMachine.Pt.xControlledByLine || !gMachine.Pt.Clean.xCleanBeltWater){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_ControlStopWhilePrepareToCleanBeltLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 );
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( gBeltClean.Status.State == BCLEAN_FAULT );
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); 
			gBeltClean.CommandsSw.xClean = TRUE;
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to prepare to clean");
			TEST_BUSY_CONDITION( gLine.Status != LINE_PREPARING_CLEANBELT );
			gLine.Commands.Stop = TRUE;
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Waiting the line to control stop");
			TEST_BUSY_CONDITION( gLine.Status != LINE_CONTROLLED_STOP ); 
			nextState();
			break;		
		
		case 9:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); 
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( gLine.Status == LINE_CONTROLLED_STOP);
			TEST_ASSERT(gLine.Status == LINE_STOPPED);

			iTestState = 0;
			TEST_DONE;
		
		default:
			break;
	}
}	

_TEST test_ControlStopWhileStartingCleaningBeltLine(void)
{
	if (!gMachine.Pt.xControlledByLine || !gMachine.Pt.Clean.xCleanBeltWater){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_ControlStopWhileStartingCleaningBeltLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
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
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( gBeltClean.Status.State == BCLEAN_FAULT );
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_IDLE );
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( gBeltClean.Status.State == BCLEAN_FAULT );
			nextState();
			break;		
		
		case 7:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); 
			gBeltClean.CommandsSw.xClean = TRUE;
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Waiting the line to start cleaning belt");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_STARTING_CLEANINGBELT );
			nextState();
			break;
		
		case 9:
			strcpy(txStateDesc, "Waiting the line to control stop");
			gLine.Commands.Stop = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_CONTROLLED_STOP );
			nextState();
			break;		
		
		case 10:
			strcpy(txStateDesc, "Waiting the line to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); 
			TEST_BUSY_CONDITION( gLine.Status == LINE_CONTROLLED_STOP );
			TEST_ASSERT(gLine.Status == LINE_STOPPED);
			gMachine.In.Buttons.xReset = TRUE;

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}	

_TEST test_ReturnToPauseFromCleanedBeltLine(void)
{
	if (!gMachine.Pt.xControlledByLine || !gMachine.Pt.Clean.xCleanBeltWater){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_ReturnToPauseFromCleanedBeltLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); 
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
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( gBeltClean.Status.State == BCLEAN_FAULT );
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); 
			gMachine.In.Buttons.xStart = TRUE; //Entering pause using phyisical start button
			nextState();
			break;		
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to pause");
			TEST_BUSY_CONDITION( gLine.Status != LINE_PAUSED );
			gMachine.In.Buttons.xStart = FALSE;
			gBeltClean.CommandsSw.xClean = TRUE;
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Waiting the line to be cleaning");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); 
			TEST_BUSY_CONDITION( !gLine.StatusSummary.xCleaning ); 
			nextState();
			break;
			
		case 9:
			strcpy(txStateDesc, "Waiting the line to finish cleaning");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); 
			TEST_BUSY_CONDITION( gLine.StatusSummary.xCleaning ); 
			nextState();
			break;
		
		case 10:
			strcpy(txStateDesc, "Waiting the line to return pausing");
			TEST_BUSY_CONDITION( gLine.Status == LINE_PAUSING ); 
			nextState();
			break;
		
		case 11:
			strcpy(txStateDesc, "Waiting the line to be paused");
			TEST_BUSY_CONDITION( !gLine.Status == LINE_PAUSED ); 
			TEST_ASSERT(gLine.Status == LINE_PAUSED);

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}

_TEST test_ReturnToPrintFromCleanBeltLine(void)
{
	if (!gMachine.Pt.xControlledByLine || !gMachine.Pt.Clean.xCleanBeltWater){
		
		//This 2 lines just for the last TestCase
		strcpy(txTest, "test_LineTests Finished!! Congrats!");
		strcpy(txStateDesc, "--");
		
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(txTest, "test_ReturnToPrintFromCleanBeltLine");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); 
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
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( gBeltClean.Status.State == BCLEAN_FAULT );
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); 
			gLine.Commands.Print = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gLine.Status != LINE_PRINTING );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); 
			gBeltClean.CommandsSw.xClean = TRUE;
			TEST_BUSY_CONDITION( gLine.Status != LINE_PAUSED );
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Waiting the line to be cleaning");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); 
			TEST_BUSY_CONDITION( gLine.Status != LINE_CLEANED );
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Waiting the line to return printing");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); 
			TEST_BUSY_CONDITION( gLine.Status == LINE_PREPARING_PRINT || gLine.Status == LINE_STARTING_PRINTING ); 
			TEST_ASSERT(gLine.Status == LINE_PRINTING);
			gSimMachine.Commands.xToZero = TRUE;
						
			//This 2 lines just for the last TestCase
			strcpy(txTest, "test_LineTests Finished!! Congrats!");
			strcpy(txStateDesc, "--");
			
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}
/*--- End tests for NOZOMITWO-1912 ---*/

/*
B+R UnitTest: This is generated code.
Do not edit! Do not move!
Description: UnitTest Testprogramm infrastructure (TestSet).
LastUpdated: 2024-07-31 10:51:26Z
By B+R UnitTest Helper Version: 2.0.1.59
*/
UNITTEST_FIXTURES(fixtures)
{
	new_TestFixture("test_PrintingLine", test_PrintingLine), 
	new_TestFixture("test_CheckPreprintingPosOrderWithAncillariesEnabled", test_CheckPreprintingPosOrderWithAncillariesEnabled), 
	new_TestFixture("test_CheckPreprintingPosOrderWithAncillariesDisabled", test_CheckPreprintingPosOrderWithAncillariesDisabled), 
	new_TestFixture("test_EmptyingBeltLine", test_EmptyingBeltLine), 
	new_TestFixture("test_EmptyingBeltLineWithMediaEntering", test_EmptyingBeltLineWithMediaEntering), 
	new_TestFixture("test_CleaningLine", test_CleaningLine), 
	new_TestFixture("test_PoweringOffLine", test_PoweringOffLine), 
	new_TestFixture("test_CleaningByTilesLine", test_CleaningByTilesLine), 
	new_TestFixture("test_ReturnToPrintFromCleanLine", test_ReturnToPrintFromCleanLine), 
	new_TestFixture("test_ReturnToPrintFromPauseLine", test_ReturnToPrintFromPauseLine), 
	new_TestFixture("test_ReturnToPauseFromCleanedLine", test_ReturnToPauseFromCleanedLine), 
	new_TestFixture("test_ControlStopWhilePrintingLine", test_ControlStopWhilePrintingLine), 
	new_TestFixture("test_ControlStopDueToSwCriticalConditionWhilePrintingLine", test_ControlStopDueToSwCriticalConditionWhilePrintingLine), 
	new_TestFixture("test_PauseDueToFeederErrorWhilePrintingLine", test_PauseDueToFeederErrorWhilePrintingLine),
	new_TestFixture("test_GoingToPauseWhenPrintCommandIsReceivedWhileFeederIsInErrorLine", test_GoingToPauseWhenPrintCommandIsReceivedWhileFeederIsInErrorLine),
	new_TestFixture("test_ControlStopWhilePrepareToPrintLine", test_ControlStopWhilePrepareToPrintLine), 
	new_TestFixture("test_ControlStopWhileStartingPrintingLine", test_ControlStopWhileStartingPrintingLine), 
	new_TestFixture("test_ControlStopWhilePausingLine", test_ControlStopWhilePausingLine), 
	new_TestFixture("test_CleanCommandSentWhilePausingLine", test_CleanCommandSentWhilePausingLine), 
	new_TestFixture("test_ControlStopWhilePausedLine", test_ControlStopWhilePausedLine), 
	new_TestFixture("test_ControlStopWhileBeltEmptyingLine", test_ControlStopWhileBeltEmptyingLine), 
	new_TestFixture("test_ControlStopWhilePrepareToEmptyBeltLine", test_ControlStopWhilePrepareToEmptyBeltLine), 
	new_TestFixture("test_ControlStopWhileStartingEmptyBeltLine", test_ControlStopWhileStartingEmptyBeltLine), 
	new_TestFixture("test_ControlStopWhileCleaningLine", test_ControlStopWhileCleaningLine), 
	new_TestFixture("test_ControlStopWhilePrepareToCleanLine", test_ControlStopWhilePrepareToCleanLine), 
	new_TestFixture("test_ControlStopWhileStartingCleaningLine", test_ControlStopWhileStartingCleaningLine), 
	new_TestFixture("test_CriticalAlarmWhilePrintingLine", test_CriticalAlarmWhilePrintingLine), 
	new_TestFixture("test_CriticalAlarmDueToEhdJamAlarm", test_CriticalAlarmDueToEhdJamAlarm), 
	new_TestFixture("test_EhdGoesToResetPositionWhenDisabled", test_EhdGoesToResetPositionWhenDisabled), 
	new_TestFixture("test_JobNotLoadedWhilePrintingLine", test_JobNotLoadedWhilePrintingLine), 
	new_TestFixture("test_JobNotLoadedWhilePrintingAndLineIsEmpty", test_JobNotLoadedWhilePrintingAndLineIsEmpty), 
	new_TestFixture("test_CriticalAlarmDueToDryerNotInRemoteWhilePrintingLine", test_CriticalAlarmDueToDryerNotInRemoteWhilePrintingLine), 
	new_TestFixture("test_CriticalAlarmDueDryerStopButtonPressed", test_CriticalAlarmDueDryerStopButtonPressed), 
	new_TestFixture("test_CriticalAlarmDueToStackerErrorWhilePrintingLine", test_CriticalAlarmDueToStackerErrorWhilePrintingLine), 
	new_TestFixture("test_CriticalAlarmDueToStackerStopsBeltsWhilePrintingLine", test_CriticalAlarmDueToStackerStopsBeltsWhilePrintingLine), 
	new_TestFixture("test_CriticalAlarmDueToOpvErrorWhilePrintingLine", test_CriticalAlarmDueToOpvErrorWhilePrintingLine), 
	new_TestFixture("test_OutOfAutoWhilePrintingLine", test_OutOfAutoWhilePrintingLine), 
	new_TestFixture("test_BarsComeBackToCapAfterZeroModeWhilePrintingLine", test_BarsComeBackToCapAfterZeroModeWhilePrintingLine), 
	new_TestFixture("test_BarsComeBackToCapAfterZeroModeWhileCleaningLine", test_BarsComeBackToCapAfterZeroModeWhileCleaningLine), 
	new_TestFixture("test_PowerOffDevicesWhenVoltageFault", test_PowerOffDevicesWhenVoltageFault), 
	new_TestFixture("test_RejectBeltEmptyingLine", test_RejectBeltEmptyingLine), 
	new_TestFixture("test_RejectBeltEmptyingLineWhenPrinterIsEmpty", test_RejectBeltEmptyingLineWhenPrinterIsEmpty), 
	new_TestFixture("test_RushProof", test_RushProof), 
	new_TestFixture("test_RejectBecauseOfFifthSensorLine", test_RejectBecauseOfFifthSensorLine), 
	new_TestFixture("test_RejectBecauseOfFourthSensorLine", test_RejectBecauseOfFourthSensorLine), 
	new_TestFixture("test_WhiteCuringLedActivation", test_WhiteCuringLedActivation), 
	new_TestFixture("test_ColorCuringLedActivation", test_ColorCuringLedActivation), 
	new_TestFixture("test_CuringLedOptimization", test_CuringLedOptimization), 
	new_TestFixture("test_CuringLedSwitchedOffDueToSafetyCriticalAlarm", test_CuringLedSwitchedOffDueToSafetyCriticalAlarm), 
	new_TestFixture("test_CureBySpeed", test_CureBySpeed), 
	new_TestFixture("test_AutoPowerOnCuringBars", test_AutoPowerOnCuringBars), 
	new_TestFixture("test_CuringBarsNitrogenAl", test_CuringBarsNitrogenAl), 
	new_TestFixture("test_EnableLampsAfterDisableCureByStretch", test_EnableLampsAfterDisableCureByStretch), 
	new_TestFixture("test_CuringLedActivationFiltered", test_CuringLedActivationFiltered), 
	new_TestFixture("test_StartOrderEmptyBelt", test_StartOrderEmptyBelt), 
	new_TestFixture("test_FeederTypeOffset", test_FeederTypeOffset), 
	new_TestFixture("test_CleaningBeltLine", test_CleaningBeltLine), 
	new_TestFixture("test_CleaningBeltByPiecesLine", test_CleaningBeltByPiecesLine), 
	new_TestFixture("test_ControlStopWhileCleaningBeltLine", test_ControlStopWhileCleaningBeltLine), 
	new_TestFixture("test_ControlStopWhilePrepareToCleanBeltLine", test_ControlStopWhilePrepareToCleanBeltLine), 
	new_TestFixture("test_ControlStopWhileStartingCleaningBeltLine", test_ControlStopWhileStartingCleaningBeltLine), 
	new_TestFixture("test_ReturnToPauseFromCleanedBeltLine", test_ReturnToPauseFromCleanedBeltLine), 
	new_TestFixture("test_ReturnToPrintFromCleanBeltLine", test_ReturnToPrintFromCleanBeltLine), 
};

UNITTEST_CALLER_COMPLETE_EXPLICIT(LineTests, "LineTests", 0, 0, fixtures, 0, 0, 0);

