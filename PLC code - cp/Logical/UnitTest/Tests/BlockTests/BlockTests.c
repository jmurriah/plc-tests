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
#include "EFIAssert.h"
#include "LibAssert1.h"


#include <stdio.h>
#include <unistd.h>
#include <time.h>         /* clock_t, clock, CLOCKS_PER_SEC */

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
	diff_t = diff_t;
	stringAux[120] = stringAux[120];
}


_TEST test_CleanMachine(void)
{
	strcpy(txTest, "test_CleanMachine");
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
			gSimMachine.Commands.xToAuto = TRUE;
			strcpy(txStateDesc, "Going to Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Going to Cap");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( !gMachine.St.Position.xInCap );
			nextState();
			break;

		case 4:
			gSimMachine.Commands.xToManual = TRUE;
			strcpy(txStateDesc, "Going to Manual");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xManual );
			nextState();
			break;

		case 5:
			strcpy(txStateDesc, "Starting the Belt");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 2 ); //We'll wait xx scan cycles
			gMachine.commandsSw.xStart_GI = TRUE;
			TEST_BUSY_CONDITION( !gBelt.states.xRuningBelt );
			nextState();
			break;

		case 6:
			strcpy(txStateDesc, "Waiting the Belt to be empty");
			TEST_BUSY_CONDITION( !gThicknessCtrl.status.Belt.xBeltEmpty );
			gMachine.commandsSw.xStop_GI = TRUE;        
			nextState();
			break;

		case 7:
			strcpy(txStateDesc, "Stopping the belt");
			TEST_BUSY_CONDITION( gBelt.states.xRuningBelt );
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Waiting to be in Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			gMachine.commandsSw.xReset_GI = TRUE;
			TEST_ASSERT(gMachine.St.Mode.xZero);

			iTestState = 0;
			
			strcpy(txTest, "test_CleanMachine Finished!! Congrats!");
			strcpy(txStateDesc, "--");
			
			TEST_DONE;
			break;
		
		default:
			break;
	}	
	
}


_TEST test_GoDownWithTrayError(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_GoDownWithTrayError");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gFeeder.ParSw.xEnabled=FALSE;
			gPrimer.ParSw.xEnabled=FALSE;
			gDryerAnc.ParSw.xEnabled=FALSE;
			gStacker.ParSw.xEnabled=FALSE;
			gMachine.parSw.Media.rThickness = 12.0;	//10mm
			gMachine.parSw.rMarginPrint = 2.0;		//2mm >> 2mm is bars position
			gMachine.In.xConsentL1Ok = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Going to Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			strcpy(txStateDesc, "Going to Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Going to Cap");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( !gMachine.St.Position.xInCap );
			nextState();
			break;

		case 4:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			gSimMachine.Commands.xToProduction = TRUE;
			nextState();
			break;

		case 5:
			strcpy(txStateDesc, "Going to Production");
			TEST_BUSY_CONDITION( !gMachine.St.AutoMode.xProduction);
			nextState();
			break;

		case 6:
			strcpy(txStateDesc, "Waiting to move down and below risk zone");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( gBlock[1].Status.rMotorPosition > gBlock[1].parameters.Motor.rDripBarsPosition - 100);
			TEST_BUSY_CONDITION( !gThicknessCtrl.status.Belt.xBeltEmpty );
			nextState();
			break;

		case 7:
			strcpy(txStateDesc, "Waiting the tray to rebound");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			gTraySim[1].Commands.ResetOut = TRUE;
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Waiting the external order");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
			TEST_ASSERT_EQUAL_INT(BLOCKP_GOING_TO_CAP, gBlock[1].Status.PositionState);
			gMachine.commandsSw.xReset_GI = TRUE;
			nextState();
			break;
		
		case 9:
			strcpy(txStateDesc, "Waiting the alarm to be removed");
			gMachine.commandsSw.xReset_GI = TRUE;
			TEST_BUSY_CONDITION( gBlock[1].Al.xAlrTraySensor );
			TEST_BUSY_CONDITION(!gBlock[1].Status.Position.xInCap);

			iTestState = 0;
			
			strcpy(txTest, "test_GoDownWithTrayError Finished!! Congrats!");
			strcpy(txStateDesc, "--");
			
			TEST_DONE;
			break;
		
		default:
			break;
	}	
	
}

_TEST test_GoUpWithTrayError(void)
{
	if (gBlock[1].parameters.xCappingProcess)
	{
		TEST_DONE;
	}
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_GoUpWithTrayError");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gMachine.commandsSw.xReset_GI = TRUE;
			gMachine.In.xConsentL1Ok = TRUE;
			gMachine.parSw.rBeltSpeedSetPoint = 6.0; //Low speed to avoid media go out quickly
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Going to Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			gMachine.commandsSw.xReset_GI = TRUE;
			TEST_BUSY_CONDITION( gBlock[1].Al.xAlrTraySensor );			
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 2:
			strcpy(txStateDesc, "Going to Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Going to Production");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			gSimMachine.Commands.xToProduction = TRUE;
			nextState();
			break;

		case 4:
			strcpy(txStateDesc, "Going to Print Position");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( !gMachine.St.Position.xInPrint );
			nextState();
			break;
		

		case 5:
			strcpy(txStateDesc, "Waiting the belt to start");
			TEST_BUSY_CONDITION( !gBelt.states.xRuningBelt);
			gSimMachine.Commands.Media.rMediaThickness = 1; // This value is to increment to the current value
			gSimMachine.Commands.Media.xMediaPresent = TRUE;
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			gSimMachine.Signals.xProductDetectL1 = TRUE;
			nextState();
			break;

		case 6:
			strcpy(txStateDesc, "Removing the tray signal");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			gTraySim[1].Commands.ResetOut = TRUE;
			nextState();
			break;

		case 7:
			strcpy(txStateDesc, "Waiting the tray error to appear");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( endtime < TimeLast + 500 ); //We'll wait xx ms
			gSimMachine.Commands.Media.xMediaPresent = FALSE; //Remove the media before the error raises
			gSimMachine.Signals.xProductDetectL1 = FALSE;

			//The timer is 1 sec, so wait a bit longer
			endtime = clock_ms();
			TEST_BUSY_CONDITION( endtime < TimeLast + 1100 ); //We'll wait xx ms
			nextState();
			break;
		
		case 8:
			TEST_ASSERT(!gMachine.Out.xConsentL1); //No consent is desired, to empty the belt
			gMachine.parSw.rBeltSpeedSetPoint = 70.0; //Accelerate to empty belt faster
			nextState();
			break;
			
		case 9:
			strcpy(txStateDesc, "Waiting the belt to empty");
			TEST_BUSY_CONDITION( !gThicknessCtrl.status.Belt.xBeltEmpty ); //We'll wait xx ms	
			TEST_ASSERT(!gBlock[1].parameters.xMediaBelow);
			nextState();
			break;
			
		case 10:
			strcpy(txStateDesc, "Waiting the review machine status");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			TEST_ASSERT(gMachine.St.AutoMode.xStop);
			gMachine.commandsSw.xReset_GI = TRUE;
			nextState();
			break;

		case 11:
			strcpy(txStateDesc, "Removing the error");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			nextState();
			break;
			
		case 12:
			strcpy(txStateDesc, "Waiting to be in cap");			
			TEST_BUSY_CONDITION( !gBlock[1].Status.Position.xInCap);

			iTestState = 0;
			
			strcpy(txTest, "test_GoUpWithTrayError Finished!! Congrats!");
			strcpy(txStateDesc, "--");
			
			TEST_DONE;
			break;
		
		default:
			break;
	}	
	
}

_TEST test_GoToPrintInLaboratory(void)
{
	if (!gMachine.Pt.xAllowLaboratory){
		TEST_DONE;        
	}
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_GoToPrintInLaboratory");
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
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait to get the xControlledByLine configuration
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
			gMachine.commandsSw.xToLaboratory_GI = TRUE;
			strcpy(txStateDesc, "Waiting the machine to be in Laboratory");
			TEST_BUSY_CONDITION(!gMachine.St.AutoMode.xLaboratory);
			nextState();
			break;		
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			gMachine.commands.xAllToPrint = TRUE;
			if(!gBlock[1].parameters.xCappingProcess ){
				TEST_BUSY_CONDITION( gBlock[1].Status.rMotorPosition > gBlock[1].parameters.Motor.rDripBarsPosition-10);
			}
			else{
				TEST_BUSY_CONDITION( gBlock[1].Status.rMotorPosition > gBlock[1].parameters.Motor.rCappingPosition-10);
			}
			TEST_ASSERT(gBlock[1].In.xTrayOut);
			nextState();
			break;		
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState == BLOCKP_GOING_TO_PRINT );
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 );
			TEST_ASSERT(gMachine.St.Position.xInPrint || gBlock[1].Status.PositionState == BLOCKP_IN_PRINT ); //If variable is TRUE, the test is correct

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}

_TEST test_GoToPrintInProduction(void)
{
	if (gMachine.Pt.xControlledByLine){
		TEST_DONE;        
	}
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_GoToPrintInProduction");
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
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait to get the xControlledByLine configuration
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
			gSimMachine.Commands.xToProduction = TRUE;
			nextState();
			break;		
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			if(!gBlock[1].parameters.xCappingProcess ){
				TEST_BUSY_CONDITION( gBlock[1].Status.rMotorPosition > gBlock[1].parameters.Motor.rDripBarsPosition-10);
			}
			else{
				TEST_BUSY_CONDITION( gBlock[1].Status.rMotorPosition > gBlock[1].parameters.Motor.rCappingPosition-10);
			}
			TEST_ASSERT(gBlock[1].In.xTrayOut);
			nextState();
			break;		
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState == BLOCKP_GOING_TO_PRINT );
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 );
			TEST_ASSERT(gMachine.St.Position.xInPrint || gBlock[1].Status.PositionState == BLOCKP_IN_PRINT ); //If variable is TRUE, the test is correct

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}

_TEST test_TraySensorErrorWhilePrinting(void)
{
	if (gMachine.Pt.xControlledByLine){
		TEST_DONE;        
	}
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_TraySensorErrorWhilePrinting");
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
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait to get the xControlledByLine configuration
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			gSimMachine.Commands.Media.rMediaThickness = gBlock[1].parameters.Motor.rMinSafePosition;//setting the initial piece thickness
			gMachine.commandsSw.xReset_GI = TRUE;
			nextState();
			break;

		case 2:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait to get the xControlledByLine configuration
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gSimMachine.Commands.xToProduction = TRUE;
			nextState();
			break;		
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			if(!gBlock[1].parameters.xCappingProcess ){
				TEST_BUSY_CONDITION( gBlock[1].Status.rMotorPosition > gBlock[1].parameters.Motor.rDripBarsPosition-10);
			}
			else{
				TEST_BUSY_CONDITION( gBlock[1].Status.rMotorPosition > gBlock[1].parameters.Motor.rCappingPosition-10);
			}
			TEST_ASSERT(gBlock[1].In.xTrayOut);
			nextState();
			break;		
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_IN_PRINT );
			gSimMachine.Commands.Media.xMediaPresent = TRUE;
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Entering media");
			TEST_BUSY_CONDITION( !gBlock[1].parameters.xMediaBelow );
			nextState();
			break;

		case 7:
			strcpy(txStateDesc, "Unplug tray sensor");
			gTraySim[1].Commands.UnplugOutSensor = TRUE;
			TEST_BUSY_CONDITION( !gBlock[1].Status.xAlarmToEmptyBelt );
			TEST_ASSERT( gBlock[1].Status.xAlarmToEmptyBelt );
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Unplug tray sensor");
			gSimMachine.Commands.Media.xMediaPresent = FALSE;
			gTraySim[1].Commands.UnplugOutSensor = FALSE;
			TEST_BUSY_CONDITION(gBlock[1].parameters.xMediaBelow);
			TEST_BUSY_CONDITION(!gThicknessCtrl.status.Belt.xBeltEmpty);
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 100 ); //We'll wait xx scan cycles
			TEST_ASSERT( gBlock[1].Al.xAlrTraySensor );
			nextState();
			break;
			
		case 9:
			TEST_BUSY_CONDITION(gBlock[1].Status.PositionState != BLOCKP_IN_CAP);
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;
			
		case 10:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait 
			gMachine.commandsSw.xReset_GI = TRUE;
			
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}


_TEST test_GoToPrintWhileNSensorsCalibrationAreBeingChecked(void)
{
	if (gPhotoCells.parameters.AlignmentProcess == STP_ALIGNMENT_NO_REQUIRED || !gMachine.Pt.xControlledByLine){
		TEST_DONE;        
	}
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_GoToPrintWhileNSensorsCalibrationAreBeingChecked");
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
			TEST_BUSY_CONDITION( gPhotoCells.status.iSystemState!=STP_CHECK_ALIGNMENT_STEP_4 );
			nextState();
			break;		
		
		case 4:
			strcpy(txStateDesc, "Execute print order");
			gSimMachine.Commands.xToProduction = TRUE;
			nextState();
			break;		
		
		case 5:
			strcpy(txStateDesc, "Waiting the belt to start");
			TEST_BUSY_CONDITION( !gBlock[1].Status.Position.xInPrint );
			TEST_BUSY_CONDITION( !gBelt.states.xRuningBelt );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_ASSERT(gPhotoCells.status.xInPosition);

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}

_TEST test_ToNotChangeBarsPositionSetpointWhileDetectionSystemMotorIsBeingPositioned(void)
{
	if (!gPhotoCells.status.xInstalled || !gMachine.Pt.xControlledByLine){
		TEST_DONE;        
	}
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_ToNotChangeBarsPositionSetpointWhileDetectionSystemMotorIsBeingPositioned");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gMachine.parSw.Media.rThickness = 10.0;
			gSimMachine.Commands.Media.xContinuousMediaPresent = TRUE;
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
			TEST_BUSY_CONDITION( gPhotoCells.status.iSystemState!=STP_CHECK_ALIGNMENT_STEP_4 );
			nextState();
			break;		
		
		case 4:
			strcpy(txStateDesc, "Execute print order");
			gSimMachine.Commands.xToProduction = TRUE;
			nextState();
			break;		
		
		case 5:
			strcpy(txStateDesc, "Waiting the belt to start");
			TEST_BUSY_CONDITION(!gBlock[1].Status.Position.xInPrint);
			TEST_BUSY_CONDITION(!gBelt.states.xRuningBelt);
			TEST_BUSY_CONDITION(gBlock[1].Status.rMotorPosition!=(gMachine.parSw.Media.rThickness+gMachine.parSw.rMarginPrint));
			rPreviousBlockMotorPosition = gBlock[1].Status.rMotorPosition;
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Modifying media thickness");
			gMachine.parSw.Media.rThickness = 2.0;
			TEST_BUSY_CONDITION(!gPhotoCells.status.Icla.xIsMoving);
			
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Checking Bars do not move till detection system motor is positioned");
			TEST_ASSERT(rPreviousBlockMotorPosition == gBlock[1].Status.rMotorPosition);
			rPreviousBlockMotorPosition = gBlock[1].Status.rMotorPosition;
			gSimMachine.Commands.Media.xContinuousMediaPresent = FALSE;
						
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Emptying printer's belt");
			TEST_BUSY_CONDITION(!gThicknessCtrl.status.Belt.xBeltEmpty);
			
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}

_TEST test_GoToCleanBk1InLaboratory(void)
{
	if (!gMachine.Pt.xAllowLaboratory){
		TEST_DONE;        
	}
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_GoToCleanBk1InLaboratory");
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
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 );
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 );
			gSimMachine.Commands.xToAuto = TRUE;
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_IN_CAP );
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gMachine.commandsSw.xToLaboratory_GI = TRUE;
			gMachine.commandsSw.xReset_GI = TRUE;
			TEST_BUSY_CONDITION(!gMachine.St.AutoMode.xLaboratory);
			nextState();
			break;		
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			if(!gMachine.Pt.xControlledByLine ){
				gBlock[1].commands.xForceCleanNoDelay = TRUE;
			}
			else{
				gLine.Commands.Clean = TRUE;
			}
			TEST_BUSY_CONDITION( !gBlock[1].Status.Position.xCleaning);
			nextState();
			break;		
		
		case 5:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_CLEANING );
			gBlock[1].commands.xForceCleanNoDelay = FALSE; 
			nextState();
			break;
			
			
		case 6:
			strcpy(txStateDesc, "Waiting the machine to be in CAP");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_IN_CAP );
			nextState();
			break;
			
		case 7:
			strcpy(txStateDesc, "Waiting the machine to be in CAP");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			TEST_ASSERT(gBlock[1].Status.PositionState == BLOCKP_IN_CAP ); //If variable is TRUE, the test is correct

			//This 3 lines just for the last TestCase
			strcpy(txTest, "test_GoToCleanBk1InLaboratory Finished!! Congrats!");
			strcpy(txStateDesc, "--");

			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}

_TEST test_ReturnToPrintFromClean(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_ReturnToPrintFromClean");
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
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait to get the xControlledByLine configuration
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			gMachine.commandsSw.xReset_GI = TRUE;
			nextState();
			break;

		case 2:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait to get the xControlledByLine configuration
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			gMachine.commandsSw.xReset_GI = TRUE;
			nextState();
			break;
			
		case 4:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
			gSimMachine.Commands.xToProduction = TRUE;
			nextState();
			break;		
		
		case 5:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_GOING_TO_PRINT );
			nextState();
			break;
			
		case 6:
			strcpy(txStateDesc, "Preparing to print");
			if(!gBlock[1].parameters.xCappingProcess ){
				TEST_BUSY_CONDITION( gBlock[1].Status.rMotorPosition > gBlock[1].parameters.Motor.rDripBarsPosition-10);
			}
			else{
				TEST_BUSY_CONDITION( gBlock[1].Status.rMotorPosition > gBlock[1].parameters.Motor.rCappingPosition-10);
			}
			TEST_ASSERT(gBlock[1].In.xTrayOut);
			nextState();
			break;		
		
		case 7:
			strcpy(txStateDesc, "Waiting the machine to be printing");
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_IN_PRINT );
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Waiting the line to be cleaning");
			if(!gMachine.Pt.xControlledByLine ){
				gBlock[1].commands.xForceCleanNoDelay = TRUE;
			}
			else{
				gLine.Commands.Clean = TRUE;
			}
			TEST_BUSY_CONDITION( !gBlock[1].Status.Position.xCleaning);
			gBlock[1].commands.xForceCleanNoDelay = FALSE;
			nextState();
			break;
		
		case 9:
			strcpy(txStateDesc, "Returning to print");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState == BLOCKP_CLEANING );
			gMachine.commands.xAllToPrint = TRUE;
			nextState();
			break;
		
		case 10:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_GOING_TO_PRINT );
			TEST_BUSY_CONDITION( gBlock[1].Status.rMotorPosition >= gBlock[1].parameters.Motor.rDripBarsPosition );
			TEST_ASSERT(gBlock[1].In.xTrayOut);
			nextState();
			break;
		
		case 11:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState == BLOCKP_GOING_TO_PRINT );
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 );
			TEST_ASSERT(gMachine.St.Position.xInPrint || gBlock[1].Status.PositionState == BLOCKP_IN_PRINT ); //If variable is TRUE, the test is correct
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}

_TEST test_RaiseBlocksToCapFromPrinting(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_RaiseBlocksToCapFromPrinting");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToAuto = TRUE;
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Going To Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gMachine.In.Buttons.xReset = FALSE;
			nextState();
			break;

		case 2:
			gMachine.commandsSw.xToLaboratory_GI = TRUE;
			strcpy(txStateDesc, "Going To Production");
			TEST_BUSY_CONDITION( !gMachine.St.AutoMode.xLaboratory && gMachine.Pt.xAllowLaboratory);
			gMachine.commandsSw.xToLaboratory_GI = FALSE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the Block 1 to be in print position");
			gMachine.commands.xAllToPrint = TRUE;
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInPrint);
			nextState();
			break;
		
		case 4:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			gMachine.commands.xAllToCap = TRUE;
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState!=BLOCKP_GOING_TO_CAP );
			TEST_ASSERT(gBlock[1].In.xTrayOut);
			nextState();
			break;		
		
		case 5:
			strcpy(txStateDesc, "Waiting the bars to raise to Cap");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION(gBlock[1].Status.PositionState!=BLOCKP_IN_CAP);
			if (!gBlock[1].parameters.xCappingProcess) {
				TEST_ASSERT_EQUAL_REAL(gBlock[1].parameters.Motor.rCapPosition, gBlock[1].Status.rMotorPosition);		
			}
			else{
				if(gBlock[1].In.xFrontDoorClosed){
					TEST_ASSERT_EQUAL_REAL(gBlock[1].parameters.Motor.rCappingPosition, gBlock[1].Status.rMotorPosition);
					TEST_ASSERT(gBlock[1].Out.xCappingWaterPump = TRUE);
				}
				else{
					TEST_ASSERT_EQUAL_REAL(gBlock[1].parameters.Motor.rCapPosition, gBlock[1].Status.rMotorPosition);
				}
			}			
			
			iTestState = 0;
			TEST_DONE;
			break;
		
		default:
			break;
	}
}

_TEST test_StopWhenPrint_ReturnPrintingBeforCapPosition(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_StopWhenPrint_ReturnPrintingBeforCapPosition");
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
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait to get the xControlledByLine configuration
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
			gMachine.commandsSw.xToNormal_GI = TRUE;
			TEST_BUSY_CONDITION(!gMachine.St.AutoMode.xProduction);
			nextState();
			break;		
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			gSimMachine.Commands.xToProduction = TRUE;
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_GOING_TO_PRINT );
			if(!gBlock[1].parameters.xCappingProcess ){
				TEST_BUSY_CONDITION( gBlock[1].Status.rMotorPosition > gBlock[1].parameters.Motor.rDripBarsPosition-10);
			}
			else{
				TEST_BUSY_CONDITION( gBlock[1].Status.rMotorPosition > gBlock[1].parameters.Motor.rCappingPosition-10);
			}
			TEST_ASSERT(gBlock[1].In.xTrayOut);
			nextState();
			break;		
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_IN_PRINT );
			if (!gMachine.Pt.xControlledByLine){
				gMachine.commandsSw.xStop_GI = TRUE;        
			}
			else{
				gLine.Commands.Stop = TRUE;
			}
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the machine to be in CAP");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( gBlock[1].Status.rMotorPosition < gBlock[1].parameters.Motor.rDripBarsPosition );
			TEST_ASSERT(gBlock[1].In.xTrayOut);
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Returning to print");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			gSimMachine.Commands.xToProduction = TRUE;
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_GOING_TO_PRINT );
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_IN_PRINT );
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			TEST_ASSERT(gMachine.St.Position.xInPrint || gBlock[1].Status.PositionState == BLOCKP_IN_PRINT ); //If variable is TRUE, the test is correct
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}

_TEST test_CriticalAlarmWhilePrinting(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_CriticalAlarmWhilePrinting");
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
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait to get the xControlledByLine configuration
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
			gMachine.commandsSw.xToNormal_GI = TRUE;
			TEST_BUSY_CONDITION(!gMachine.St.AutoMode.xProduction);
			nextState();
			break;		
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			gSimMachine.Commands.xToProduction = TRUE;
			TEST_BUSY_CONDITION( gBlock[1].Status.rMotorPosition > gBlock[1].parameters.Motor.rDripBarsPosition );
			TEST_ASSERT(gBlock[1].In.xTrayOut);
			nextState();
			break;		
		
		case 5:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_IN_PRINT || !gBelt.states.xRuningBelt );
			if(gPhotoCells.status.xInstalled){
				TEST_ASSERT( gPhotoCells.status.iSystemState == STP_AUTO); //To check photocells are positioned when belt starts
			}
			gBlock[1].Al.xAlrSafetySystemInBlock = TRUE; //Creating a Critical alarm
			nextState();
			break;

		case 6:
			strcpy(txStateDesc, "Waiting the machine to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( gBlock[1].Status.BlockState != BLOCK_STOPPED );
			TEST_ASSERT(gBlock[1].Status.PositionState == BLOCKP_IN_PRINT);
			gBelt.Al.xAlrOverTorque = FALSE;
			nextState();
			break;
			
		case 7:
			strcpy(txStateDesc, "Waiting the machine to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( gMachine.AlSummary.xAlarmCritical );
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Waiting the machine to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			gMachine.In.Buttons.xReset = TRUE;
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 9:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;
		
		case 10:
			strcpy(txStateDesc, "Waiting the machine to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_GOING_TO_CAP );
			TEST_BUSY_CONDITION( gBlock[1].Status.rMotorPosition < gBlock[1].parameters.Motor.rDripBarsPosition );
			TEST_ASSERT(gBlock[1].In.xTrayOut);
			
			iTestState = 0;
			TEST_DONE;
			break;
		
		
		default:
			break;
	}
}	
_TEST test_GoToMaintenanceWhenInPrintingPositionAndCheckBarsNotMove(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_GoToMaintenanceWhenInPrintingPositionAndCheckBarsNotMove");
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
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait to get the xControlledByLine configuration
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Go to print");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gSimMachine.Commands.xToProduction = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Position.xInPrint ); //We'll wait xx scan cycles
			nextState();
			break;		

		case 4:
			strcpy(txStateDesc, "Waiting the machine to be in zero");
			TEST_BUSY_CONDITION( !gMachine.St.Position.xInPrint );
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;
	
		case 5:
			strcpy(txStateDesc, "Waiting the machine to be in manual");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 );
			gSimMachine.Commands.xToManual = TRUE;
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the line to be printing");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xManual );
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 );
			TEST_ASSERT(gBlock[1].parameters.Motor.rPrintPosition = gBlock[1].Status.rMotorPosition ); //If variable is TRUE, the test is correct

			strcpy(txTest, "BlockTests Finished!! Congrats!");
			strcpy(txStateDesc, "--");
			
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}

_TEST test_CuringLedBarJamAlarm(void)
{
	//If the Test makes non sense, not execute it.
	if (!gCuringLed[iIndexColorCuringLedBar].Parameters.xInstalled){
		iTestState = 0;
		TEST_DONE;		
	}
	
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_CuringLedBarJamAlarm");
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
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait to get the xControlledByLine configuration
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
			gMachine.commandsSw.xToNormal_GI = TRUE;
			TEST_BUSY_CONDITION(!gMachine.St.AutoMode.xProduction);
			nextState();
			break;		
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			if(!gMachine.Pt.xControlledByLine ){
			gMachine.commandsSw.xStart_GI = TRUE;
			}
			else{
			gLine.Commands.Print = TRUE;
			}
			TEST_BUSY_CONDITION( gBlock[1].Status.rMotorPosition > gBlock[1].parameters.Motor.rDripBarsPosition );
			TEST_ASSERT(gBlock[1].In.xTrayOut);
			nextState();
			break;		
		
		case 5:
			strcpy(txStateDesc, "Generating a crash");
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_IN_PRINT || !gBelt.states.xRuningBelt );
			gSimJamDetect[gJamPerCuringLed[iIndexColorCuringLedBar].iJamDevice].Commands.CreateCrash[gJamPerCuringLed[iIndexColorCuringLedBar].iJamSensor] = TRUE;
			nextState();
			break;

		case 6:
			strcpy(txStateDesc, "Waiting the set stop order");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( !gMachine.AlSummary.xAlarmStop );
			TEST_ASSERT(gJamPerCuringLed[iIndexColorCuringLedBar].xAlrJamCrash );
			nextState();
			break;
			
		case 7:
			strcpy(txStateDesc, "Waiting the machine to be stopped");
			TEST_BUSY_CONDITION( gBelt.states.xRuningBelt ); //We'll wait xx scan cycles
			TEST_ASSERT(!gBelt.states.xRuningBelt );
			gSimJamDetect[gJamPerCuringLed[iIndexColorCuringLedBar].iJamDevice].Commands.CreateCrash[gJamPerCuringLed[iIndexColorCuringLedBar].iJamSensor] = FALSE;
			gMachine.In.Buttons.xReset = TRUE;
		
			iTestState = 0;
			TEST_DONE;
			break;
		
		
		default:
			break;
	}
}	


_TEST test_CameraJamAlarm(void)
{
	//If the Test makes non sense, not execute it.
	if (!gCamera.Parameters.xInstalled){
		iTestState = 0;
		TEST_DONE;		
	}
	
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_CameraJamAlarm");
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
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait to get the xControlledByLine configuration
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
			gMachine.commandsSw.xToNormal_GI = TRUE;
			TEST_BUSY_CONDITION(!gMachine.St.AutoMode.xProduction);
			nextState();
			break;		
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			if(!gMachine.Pt.xControlledByLine ){
			gMachine.commandsSw.xStart_GI = TRUE;
			}
			else{
			gLine.Commands.Print = TRUE;
			}
			TEST_BUSY_CONDITION( gBlock[1].Status.rMotorPosition > gBlock[1].parameters.Motor.rDripBarsPosition );
			TEST_ASSERT(gBlock[1].In.xTrayOut);
			nextState();
			break;		
		
		case 5:
			strcpy(txStateDesc, "Generating a crash");
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_IN_PRINT || !gBelt.states.xRuningBelt );
			gSimJamDetect[gJamCamera.iJamDevice].Commands.CreateCrash[gJamCamera.iJamSensor] = TRUE;
			nextState();
			break;

		case 6:
			strcpy(txStateDesc, "Waiting the machine to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( !gMachine.AlSummary.xAlarmStop );
			TEST_ASSERT(gJamCamera.xAlrJamCrash );
			TEST_ASSERT(!gBelt.states.xRuningBelt );
			gSimJamDetect[gJamCamera.iJamDevice].Commands.CreateCrash[gJamCamera.iJamSensor] = FALSE;
			gMachine.In.Buttons.xReset = TRUE;
		
			iTestState = 0;
			TEST_DONE;
			break;
		
		
		default:
			break;
	}
}	

/* TEST DELOREAN-1116: Block tray movements when printer key maintenance is activated */
_TEST test_TrayBlockMaintenanceKey(void)
{
	
	if (!gSafetyController.Parameters.xInstalled){
		iTestState = 0;
		TEST_DONE;		
	}
	
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_TrayBlockMaintenanceKey");
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
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait to get the xControlledByLine configuration
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
			nextState();
			break;		
		
		case 4:
			strcpy(txStateDesc, "Waiting bars in cap position");
			TEST_BUSY_CONDITION(!gBlock[1].Status.Position.xInCap ); //We'll wait xx scan cycles
			nextState();
			break;
		
		case 5:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 6:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait to get the xControlledByLine configuration
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;
	
		case 7:
			strcpy(txStateDesc, "Waiting the machine to be in Manual");
			gSimMachine.Commands.xToManual = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xManual );
			gSimSafetyController.Inputs.xPrinterMaintenanceKey = TRUE;
			gBlock[1].commands.Manual.xManTrayOut = TRUE;
			nextState();
			break;
			
		case 8:
			strcpy(txStateDesc, "Check tray out manual movement with maintenance key active");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( endtime < TimeLast + 200 );
			TEST_ASSERT(!gBlock[1].Out.xTrayOut);
			gBlock[1].commands.Manual.xManTrayOut = FALSE;
			gBlock[1].commands.Manual.xManTrayIn = TRUE;
			nextState();
			break;
		
		case 9:
			strcpy(txStateDesc, "Check tray in manual movement with maintenance key active");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( endtime < TimeLast + 200 );
			TEST_ASSERT(!gBlock[1].Out.xTrayIn);
			gSimSafetyController.Commands.xSafetyToDefault = TRUE;

			iTestState = 0;
			TEST_DONE;
			break;
		
		
		default:
			break;
	}
}
/* END TEST DELOREAN-1116 */


_TEST test_ToNotExecuteHomingBlockWhileMaintenanceKeyIsActivated(void)
{
	
	if (!gSafetyController.Parameters.xInstalled){
		iTestState = 0;
		TEST_DONE;		
	}
	
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_ToNotExecuteHomingBlockWhileMaintenanceKeyIsActivated");
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
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait to get the xControlledByLine configuration
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
			nextState();
			break;		
		
		case 4:
			strcpy(txStateDesc, "Waiting bars in cap position");
			TEST_BUSY_CONDITION(!gBlock[1].Status.Position.xInCap ); //We'll wait xx scan cycles
			nextState();
			break;
		
		case 5:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 6:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait to get the xControlledByLine configuration
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;
	
		case 7:
			strcpy(txStateDesc, "Waiting the machine to be in Manual");
			gSimMachine.Commands.xToManual = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xManual );
			gBlock[1].commands.Manual.xManTrayOut = TRUE;
			gBlock[2].commands.Manual.xManTrayOut = TRUE;
			nextState();
			break;
			
		case 8:
			strcpy(txStateDesc, "Moving the tray Out to enable referencing");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( !gBlock[1].In.xTrayOut || (!gBlock[2].In.xTrayOut && gBlock[2].parameters.Hw.xExistBlock) );
			gSimSafetyController.Inputs.xPrinterMaintenanceKey = TRUE;
			nextState();
			break;
		
		case 9:
			strcpy(txStateDesc, "Set bar home order");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( endtime < TimeLast + 100 );
			gBlock[1].commands.xBarHomeOrder = TRUE;
			gBlock[2].commands.xBarHomeOrder = TRUE;
			nextState();
			break;
		
		case 10:
			strcpy(txStateDesc, "Check tray out manual movement with maintenance key active");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( endtime < TimeLast + 100 );
			TEST_ASSERT(!gBlock[1].Status.Motor.xBarsHoming);
			TEST_ASSERT(!gBlock[2].Status.Motor.xBarsHoming);
			TEST_ASSERT(!gBlock[1].commands.xBarHomeOrder);
			TEST_ASSERT(!gBlock[2].commands.xBarHomeOrder);
			nextState();
			break;
		
		case 11:
			strcpy(txStateDesc, "Check tray in manual movement with maintenance key active");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( endtime < TimeLast + 200 );
			gSimSafetyController.Commands.xSafetyToDefault = TRUE;
			gBlock[1].commands.xBarHomeOrder = FALSE;
			gBlock[2].commands.xBarHomeOrder = FALSE;
			iTestState = 0;
			TEST_DONE;
			break;
		
		
		default:
			break;
	}
}


_TEST test_ToNotExecuteHomingIclaWhileMaintenanceKeyIsActivated(void)
{
	
	if (!gSafetyController.Parameters.xInstalled){
		iTestState = 0;
		TEST_DONE;		
	}
	
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_ToNotExecuteHomingIclaWhileMaintenanceKeyIsActivated");
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
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait to get the xControlledByLine configuration
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
			nextState();
			break;		
		
		case 4:
			strcpy(txStateDesc, "Waiting bars in cap position");
			TEST_BUSY_CONDITION(!gBlock[1].Status.Position.xInCap ); //We'll wait xx scan cycles
			nextState();
			break;
		
		case 5:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 6:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait to get the xControlledByLine configuration
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;
	
		case 7:
			strcpy(txStateDesc, "Waiting the machine to be in Manual");
			gSimMachine.Commands.xToManual = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xManual );
			gSimSafetyController.Inputs.xPrinterMaintenanceKey = TRUE;
			gBlock[1].commands.xIclaHomeOrder = TRUE;
			nextState();
			break;
			
		case 8:
			strcpy(txStateDesc, "Check tray out manual movement with maintenance key active");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( endtime < TimeLast + 200 );
			TEST_ASSERT(gBlock[1].Status.PositionState != BLOCKP_HOMING_ICLA);
			gBlock[1].commands.xIclaHomeOrder = FALSE;
			nextState();
			break;
		
		case 9:
			strcpy(txStateDesc, "Check tray in manual movement with maintenance key active");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( endtime < TimeLast + 200 );
			gSimSafetyController.Commands.xSafetyToDefault = TRUE;
			
			iTestState = 0;
			TEST_DONE;
			break;
		
		
		default:
			break;
	}
}


_TEST test_InkBarJamAlarm(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_InkBarJamAlarm");
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
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait to get the xControlledByLine configuration
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
			gMachine.commandsSw.xToNormal_GI = TRUE;
			TEST_BUSY_CONDITION(!gMachine.St.AutoMode.xProduction);
			nextState();
			break;		
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to be ready");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			if(!gMachine.Pt.xControlledByLine ){
			gMachine.commandsSw.xStart_GI = TRUE;
			}
			else{
			gLine.Commands.Print = TRUE;
			}
			TEST_BUSY_CONDITION( gBlock[1].Status.rMotorPosition > gBlock[1].parameters.Motor.rDripBarsPosition );
			TEST_ASSERT(gBlock[1].In.xTrayOut);
			nextState();
			break;		
		
		case 5:
			strcpy(txStateDesc, "Generating a crash");
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_IN_PRINT || !gBelt.states.xRuningBelt );
			if(gBlock[1].parameters.iApplicationBars>2){
				gSimJamDetect[1].Commands.CreateCrash[3] = TRUE;
			}
			else{
				gSimJamDetect[1].Commands.CreateCrash[2] = TRUE;
			}
			nextState();
			break;

		case 6:
			strcpy(txStateDesc, "Waiting the machine to be stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( !gMachine.AlSummary.xAlarmStop );
			if(gBlock[1].parameters.iApplicationBars>2){
				TEST_ASSERT(gJamPerInk[3].xAlrJamCrash );
				gSimJamDetect[1].Commands.CreateCrash[3] = FALSE;
			}
			else{
				TEST_ASSERT(gJamPerInk[2].xAlrJamCrash );
				gSimJamDetect[1].Commands.CreateCrash[2] = FALSE;
			}
			TEST_ASSERT(!gBelt.states.xRuningBelt );
			
			gMachine.In.Buttons.xReset = TRUE;
		
			iTestState = 0;
			TEST_DONE;
			break;
		
		
		default:
			break;
	}
}	

_TEST test_ToCleanTest(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_ToCleanTest");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			strcpy(txStateDesc, "Order given: xToZero");
			gMachine.In.Buttons.xReset = FALSE;
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;
		
		case 1:
			strcpy(txStateDesc, "Waiting for mode:Zero");
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			nextState();
			break;
		
		case 2://going to auto so the blocks go to cap
			strcpy(txStateDesc, "Order given: xToAuto");
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;
		
		case 3:
			strcpy(txStateDesc, "Waiting for mode:Auto, position:Cap");
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;
		
		case 4: //it stays in this case
			strcpy(txStateDesc, "Waiting for mode:Zero");
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			nextState();
			break;
		
		case 5: 
			strcpy(txStateDesc, "Order given: xToManual");
			gSimMachine.Commands.xToManual = TRUE;
			nextState();
			break;
		
		
		case 6: //going to manual so the things can be moved
			strcpy(txStateDesc, "Waiting for mode:Manual");
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xManual);
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Order given: xToCleanPos.");
			gBlock[1].commands.xToCleanPosition = TRUE;
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc,"Wating for the block to stop");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 4 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION(!gAxis[gBlock[1].parameters.iMotorAxisIndex].Status.InPosition);
			nextState();
			break;
		
		case 9:
			strcpy(txStateDesc, "TestAssert: TestComplete");
			TEST_ASSERT_EQUAL_DOUBLE(gBlock[1].Status.rMotorPosition, gBlock[1].parameters.Motor.rCleanPosition);//if it stopped in the right position, successful test
			
			iTestState=0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}
_TEST test_ToPrintPosTest(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_ToPrintPosTest");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0: 
			strcpy(txStateDesc, "Order given: xToZero");
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;
		
		case 1:
			strcpy(txStateDesc, "Waiting for mode:Zero");
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			nextState();
			break;
		
		case 2://going to auto so the blocks go to cap
			strcpy(txStateDesc, "Order given: xToAuto");
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;
		
		case 3:
			strcpy(txStateDesc, "Waiting for mode:Auto, position:Cap");
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;
		
		case 4: 
			strcpy(txStateDesc, "Waiting for mode:Zero");
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			nextState();
			break;
		
		case 5: //going to manual so the things can be moved
			strcpy(txStateDesc, "Order given: xToManual");
			gSimMachine.Commands.xToManual = TRUE;
			nextState();
			break;
		
		
		case 6:
			strcpy(txStateDesc, "Waiting for mode:Manual");
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xManual);
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Order given: xToPrintPos.");
			gBlock[1].commands.Manual.xToPrintPosition = TRUE;
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc,"Wating for the block to stop");
			TEST_BUSY_CONDITION(gAxis[gBlock[1].parameters.iMotorAxisIndex].Status.InPosition);//waiting for the block to move
			nextState();
			break;
		
		case 9:
			strcpy(txStateDesc, "TestAssert: TestComplete");
			TEST_BUSY_CONDITION(!gAxis[gBlock[1].parameters.iMotorAxisIndex].Status.InPosition);//waiting for the block to stop
			#define TEST_DOUBLE_PRECISION (0.001f)
			TEST_ASSERT_EQUAL_DOUBLE(gBlock[1].parameters.rManPrintingPos, gBlock[1].Status.rMotorPosition);//if it stopped in the right position (10)
			
			iTestState=0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}

_TEST test_InksFailNotEnabledToPrint(void) //this test is about inks
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_InksFailNotEnabledToPrint");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0: 
			strcpy(txStateDesc, "Going to ZERO");
			gSimMachine.Commands.xToZero = TRUE;
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			
			nextState();
			break;
		
		case 1:
			strcpy(txStateDesc, "Disabling BarToPrint");
			for (iIndex = 1; iIndex <= gBlock[1].parameters.Inks.iMaxMachinePrintBars; iIndex++)
			{
				gMachine.parSw.Electronics.xRobotReadyL1 = FALSE;
				gInks[iIndex].parSw.xEnabledBarToPrint = FALSE;
				gInks[iIndex].parSw.xColorLoadedInJob = FALSE;
				gInks[iIndex].ordersSw.xStartInks = FALSE;
			}
			
			nextState();
			break;
			
		case 2:
			strcpy(txStateDesc, "Going to auto");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 );
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;
			
		case 3:
			strcpy(txStateDesc, "Giving reset order");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 );
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 4:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 );
			gMachine.In.Buttons.xReset = FALSE;
		
		case 5:
			strcpy(txStateDesc, "Waiting for CAP pos.");
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xAuto);
			TEST_BUSY_CONDITION(!gBlock[1].Status.Position.xInCap);
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Going to ByPass"); //this is necessary in order for the xAlarmEnableWithoutBarsOn alarm to activate
			gMachine.commandsSw.xToByPass_GI = TRUE;
			
			nextState();
			break;
			
		case 7:
			TEST_BUSY_CONDITION(!gMachine.St.AutoMode.xBypass);
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Starting Machine");
			gMachine.commandsSw.xStart_GI = TRUE;
			nextState();
			break;
			
		case 9:
			strcpy(txStateDesc, "Waiting running belt");
			TEST_BUSY_CONDITION(!gBelt.states.xRuningBelt);
			nextState();
			break;
		
		case 10:
			endtime=clock_ms();
			TEST_BUSY_CONDITION(endtime < TimeLast + 200);
			nextState();
			break;
		
		case 11:
			strcpy(txStateDesc, "Activating inks alarm");
			for (iIndex = 1; iIndex <= gBlock[1].parameters.Inks.iMaxMachinePrintBars; iIndex++)
			{
				gInks[iIndex].Al.xAlrNoRecircStop = TRUE;
			}
			
			nextState();
			break;
		
		case 12:
			strcpy(txStateDesc, "Machine shouldn't stop");
			TEST_ASSERT(!gMachine.St.AutoMode.xStop);
			nextState();
			break;
			
		case 13:
			strcpy(txStateDesc, "Returning machine to initial state");
			if(!gMachine.Pt.xControlledByLine){
				gMachine.commandsSw.xStop_GI = TRUE;
			}
			else{
				gLine.Commands.Stop = TRUE;
			}
			nextState();
			break;
			
		case 14:
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			
			gSimMachine.Commands.xToZero = TRUE;
			for (iIndex = 1; iIndex <= gBlock[1].parameters.Inks.iMaxMachinePrintBars; iIndex++)
			{
				gMachine.parSw.Electronics.xRobotReadyL1 = TRUE;
				gInks[iIndex].Al.xAlrNoRecircStop = FALSE;
				gInks[iIndex].parSw.xEnabledBarToPrint = TRUE;
				gInks[iIndex].parSw.xColorLoadedInJob = TRUE;
				gInks[iIndex].ordersSw.xStartInks = TRUE;
			}	
			nextState();
			break;
			
		case 15:
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
			
		case 16:
			gMachine.In.Buttons.xReset = FALSE;
			
			iTestState = 0;
			TEST_DONE;
			break;
		
		default: 
			break;
	}
} 

_TEST test_InksFailEnabledToPrint(void) //this test is about inks
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_InksFailEnabledToPrint");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0: 
			strcpy(txStateDesc, "Going to zero");
			gSimMachine.Commands.xToZero = TRUE;
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			
			nextState();
			break;
		
		case 1:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 );
			strcpy(txStateDesc, "Going to auto");
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;
		
		case 2:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 );
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
			
		case 3:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 );
			gMachine.In.Buttons.xReset = FALSE;
			nextState();
			break;
		
		case 4:			
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 );
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xAuto);
			nextState();
			break;
		
		case 5:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 );
			strcpy(txStateDesc, "Waiting for block to be in CAP");
			TEST_BUSY_CONDITION(!gBlock[1].Status.Position.xInCap);
			nextState();
			break;
			
		case 6:
			strcpy(txStateDesc, "Start order");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 );
			if (gMachine.Pt.xControlledByLine){
			gLine.Commands.Print = TRUE;
			}
			else{
			gMachine.commandsSw.xStart_GI = TRUE;
			}
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Waiting for running belt");
			TEST_BUSY_CONDITION(!gBelt.states.xRuningBelt);
			endtime=clock_ms();
			TEST_BUSY_CONDITION(endtime < TimeLast + 200);
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Activating ink alarm");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 );
			for(iIndex = 1; iIndex<gBlock[1].parameters.Inks.iMaxMachinePrintBars; iIndex++){
				gInks[iIndex].Al.xAlrNoRecircStop = TRUE;
			}
			nextState();
			break;
			
		case 9:
			TEST_BUSY_CONDITION(!gBlock[1].Status.Position.xInCap);
			nextState();
			break;
		
		case 10:
			strcpy(txStateDesc, "Machine should have stopped");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 );
			TEST_ASSERT(gMachine.St.AutoMode.xStop);
			nextState();
			break;
		
		case 11://returning to initial conditions
			strcpy(txStateDesc, "Removing alarm");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 );
			for(iIndex = 1; iIndex<gBlock[1].parameters.Inks.iMaxMachinePrintBars; iIndex++){
				gInks[iIndex].Al.xAlrNoRecircStop = FALSE;
			}
			nextState();
			break;
			
		case 12:
			strcpy(txStateDesc, "Going to zero and reseting");
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;
			
		case 13:
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 14:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 );
			gMachine.In.Buttons.xReset = FALSE;
			nextState();
			break;
		
		case 15:
			strcpy(txStateDesc, "Waiting for alarm removal");
			TEST_BUSY_CONDITION(gMachine.AlSummary.xAlarmStop);
			nextState();
			break;
		
		case 16:
			strcpy(txStateDesc, "Going to auto");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 );
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;
			
		case 17:
			strcpy(txStateDesc, "Waiting for block to be in CAP");
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xAuto);
			TEST_BUSY_CONDITION(!gBlock[1].Status.Position.xInCap);
		
			nextState();
			break;
		
		case 18:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 );
			if (gMachine.Pt.xControlledByLine){
				gLine.Commands.Print = TRUE;
			}
			else{
				gMachine.commandsSw.xStart_GI = TRUE;
			}
			nextState();
			break;
		
		case 19:
			strcpy(txStateDesc, "Starting Machine");
			TEST_BUSY_CONDITION(!gBlock[1].Status.Position.xInPrint);
			nextState();
			break;
		
		case 20:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 );
			endtime=clock_ms();
			TEST_BUSY_CONDITION(endtime < TimeLast + 5000);//waiting for a few seconds
			nextState();
			break;
		
		case 21://checking if it returned to initial conditions
			strcpy(txStateDesc, "Awaiting for belt to run");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 );
			TEST_BUSY_CONDITION(!gBelt.states.xRuningBelt); 
			TEST_ASSERT(gBelt.states.xRuningBelt);
			nextState();
			break;
		
		case 22:
			strcpy(txStateDesc, "Stopping order");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 );
			if(!gMachine.Pt.xControlledByLine){
				gMachine.commandsSw.xStop_GI = TRUE;
			}
			else{
				gLine.Commands.Stop = TRUE;
			}
			nextState();
			break;
			
		case 23:
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			
			strcpy(txTest, "BlockTests Finished!! Congrats!");
			strcpy(txStateDesc, "--");
			
			iTestState=0;
			TEST_DONE;
			
			break;
			
		default:
			break;
	}
}

/* --- Test for DELOREAN-645 To not activate alarm when modifying media thickness on the fly --- */
_TEST test_NoBentAlarmThcChgOTFly(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_NoBentAlarmThcChgOTFly");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			strcpy(txStateDesc, "Order given: xToZero");
			gMachine.parSw.Media.rThickness = 0.5;
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;
		
		case 1:
			strcpy(txStateDesc, "Waiting for mode:Zero");
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			nextState();
			break;
		
		case 2://going to auto so the blocks go to cap
			strcpy(txStateDesc, "Order given: xToAuto");
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;
		
		case 3:
			strcpy(txStateDesc, "Waiting for mode:Auto, position:Cap");
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			if (gMachine.Pt.xControlledByLine){
				gLine.Commands.Print = TRUE;
			}
			else{
				gMachine.commandsSw.xStart_GI = TRUE;
			}
			nextState();
			break;
			
		case 4:
			strcpy(txStateDesc, "Going to print");
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInPrint);
			gSimMachine.Commands.Media.xContinuousMediaPresent = TRUE;
			nextState();
			break;
			
		case 5:
			strcpy(txStateDesc, "Modifying thickness on the fly");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( endtime < TimeLast + 10000 ); //We'll wait xx scan cycles
			gMachine.parSw.Media.rThickness = 2.0;
			nextState();
			break;
			
		case 6:
			strcpy(txStateDesc, "Checking not alarm active");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			TEST_ASSERT(!gMachine.Al.Warning.xBentTile);
			gSimMachine.Commands.Media.xContinuousMediaPresent = FALSE;
			gMachine.parSw.Media.rThickness = 0.5;
			
			iTestState = 0;
			TEST_DONE;
			break;
		
		default:
			break;
	}
}
/* --- End test for DELOREAN-645 --- */

/* --- Test for DELOREAN-971 To not stop when low nitrogen alarm triggers while cleaning is being performed --- */
_TEST test_NoStopCleanWithNitrLow(void)
{
	//If the Test makes non sense, not execute it. Only checks color curing bar, the code is the same for both bars.
	if (!gCuringLed[iIndexColorCuringLedBar].Parameters.xInstalled){
		
		iTestState = 0;
		TEST_DONE;		
	}
	
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_NoStopCleanWithNitrLow");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			strcpy(txStateDesc, "Order given: xToZero");
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;
		
		case 1:
			strcpy(txStateDesc, "Waiting for mode:Zero");
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			nextState();
			break;
		
		case 2://going to auto so the blocks go to cap
			strcpy(txStateDesc, "Order given: xToAuto");
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;
		
		case 3:
			strcpy(txStateDesc, "Waiting for mode:Auto, position:Cap");
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			if (gMachine.Pt.xControlledByLine){
				gLine.Commands.Print = TRUE;
			}
			else{
				gMachine.commandsSw.xStart_GI = TRUE;
			}
			nextState();
			break;
			
		case 4:
			strcpy(txStateDesc, "Going to print");
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInPrint);
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Going to clean");
			if (!gMachine.Pt.xControlledByLine){
				//gBlock[1].commands.xForceCleanNoDelay = TRUE;
				gMachine.commands.xClean = TRUE;
			}
			else{
				gLine.Commands.Clean = TRUE;
			}
			if (!gMachine.Pt.xControlledByLine){
				TEST_BUSY_CONDITION( !gBlock[1].Status.Position.xCleaning);
			}
			else{
				TEST_BUSY_CONDITION( gLine.Status != LINE_CLEANINGPH);
			}
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting to start cleaning");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 12 ); //We'll wait xx scan cycles
			if (!gMachine.Pt.xControlledByLine){
				TEST_ASSERT ( gMachine.St.Position.xCleaning);
			}
			else{
				TEST_ASSERT ( gLine.Status == LINE_CLEANINGPH);
			}
			gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xN2LowFlow = TRUE;
			nextState();
			break;
			
		case 7:
			strcpy(txStateDesc, "Check cleaning is still being performed");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( endtime < TimeLast + 15000 ); //We'll wait xx scan cycles
			gCuringLed[iIndexColorCuringLedBar].Signals.Inputs.xN2LowFlow = FALSE;
			if (!gMachine.Pt.xControlledByLine){
				TEST_ASSERT ( gMachine.St.Position.xCleaning);
			}
			else{
				TEST_ASSERT ( gLine.Status == LINE_CLEANINGPH);
			}
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Wait till cleaning is finished");
			endtime = clock_ms();
			if (!gMachine.Pt.xControlledByLine){
				TEST_BUSY_CONDITION ( !gMachine.St.Position.xInPrint && endtime < TimeLast + 60000);
			}
			else{
				TEST_BUSY_CONDITION ( gLine.Status != LINE_PRINTING && endtime < TimeLast + 60000);
			}
			
			nextState();
			break;
			
		case 9:
			strcpy(txStateDesc, "Checking machine is back to print");
			if (!gMachine.Pt.xControlledByLine){
				TEST_ASSERT ( gMachine.St.Position.xInPrint);
			}
			else{
				TEST_ASSERT ( gLine.Status == LINE_PRINTING);
			}
			
			iTestState = 0;
			TEST_DONE;
			break;
		
		default:
			break;
	}
}
/* --- End test for DELOREAN-971 --- */

/* --- Test for DELOREAN-990 To move bars to print position at the start if there are not ancillaries --- */
_TEST test_NoFeederBarsPos(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_NoFeederBarsPos");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			strcpy(txStateDesc, "Order given: xToZero");
			gSimMachine.Commands.xToZero = TRUE;
			gFeeder.ParSw.xEnabled=FALSE;
			gDing.In.rHighDingMm = 0;
			gMachine.parSw.Media.rThickness = 4.0;
			nextState();
			break;
		
		case 1:
			strcpy(txStateDesc, "Waiting for mode:Zero");
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			nextState();
			break;
		
		case 2:
			strcpy(txStateDesc, "Order given: xToAuto");
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;
		
		case 3:
			strcpy(txStateDesc, "Waiting for mode:Auto, position:Cap");
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			if (gMachine.Pt.xControlledByLine){
				gLine.Commands.Print = TRUE;
			}
			else{
				gMachine.commandsSw.xStart_GI = TRUE;
			}
			nextState();
			break;
			
		case 4:
			strcpy(txStateDesc, "Waiting empty height array");
			TEST_BUSY_CONDITION(gThicknessCtrl.status.Heigh.rMaxHeigh[1] != gThicknessCtrl.status.Heigh.rMediaThicknessMargin);
			nextState();
			break;
			
		case 5:
			strcpy(txStateDesc, "Checking bars position in print");
			TEST_BUSY_CONDITION(gBlock[1].Status.rMotorPosition != gThicknessCtrl.status.Heigh.rMediaThicknessMargin + gBlock[1].parSw.rOffsetPrintMotor);
			TEST_ASSERT (abs(gBlock[1].Status.rMotorPosition - (gBlock[1].parameters.Motor.rPrintPosition + gBlock[1].parSw.rOffsetPrintMotor)) < 0.001 );
			nextState();
			break;
		
		case 6:
			gSimMachine.Commands.xToZero = TRUE;
			if (gMachine.Pt.xControlledByLine){
				gFeeder.ParSw.xEnabled=TRUE;
			}

			gFeeder.ParSw.xEnabled=TRUE;			
			
			iTestState = 0;
			TEST_DONE;
			break;
		
		default:
			break;
	}
}
/* --- End test for DELOREAN-990 --- */

/* --- Test for DELOREAN-1455 Only active pneumatic air block manager alarms bound to the ok feedback signal--- */
_TEST test_PneuBlockAls(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_PneuBlockAls");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		// xSiUnitModuleOk akarm check cases 0 to 7
		case 0:
			strcpy(txStateDesc, "Order given: xToZero");
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;
		
		case 1:
			strcpy(txStateDesc, "Waiting for mode:Zero");
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			nextState();
			break;
		
		case 2:
			strcpy(txStateDesc, "Order given: xToAuto");
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;
		
		case 3:
			strcpy(txStateDesc, "Waiting for mode:Auto, position:Cap");
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 12 ); //We'll wait xx scan cycles
			if (gMachine.Pt.xControlledByLine){
				gLine.Commands.Print = TRUE;
			}
			else{
				gMachine.commandsSw.xStart_GI = TRUE;
			}
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Checking bars position in print");
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInPrint);
			gBlockInputs[1].xSiUnitModuleOk = FALSE;
			gBlock[1].In.xSiUnitModuleOk = gBlockInputs[1].xSiUnitModuleOk;;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Checking alarm due to SiUnitModule");
			endtime = clock_ms();
			TEST_BUSY_CONDITION(endtime < TimeLast + 5000);
			//TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			TEST_ASSERT(gBlock[1].Al.xSiUnitPowerOff && gBlock[1].Al.xAlrComSiUnit);
			TEST_ASSERT(gMachine.AlSummary.CurrentReasonStop > 0);
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Checking going to stop");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 12 ); //We'll wait xx scan cycles
			if (gMachine.Pt.xControlledByLine){
			TEST_ASSERT(gLine.Status == LINE_CONTROLLED_STOP || gLine.Status == LINE_STOPPED);
			}
			else{
			TEST_ASSERT(gMachine.St.AutoMode.xStop);
			}
			gMachine.In.xAirSupply = FALSE;
			gBlock[1].In.xIclaSensor = FALSE;
			gBlock[1].In.xAirVenturiOK = FALSE;
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Checking alarms related to SiUnitModule do not trigger");
			endtime = clock_ms();
			TEST_BUSY_CONDITION(endtime < TimeLast + 5000);
			TEST_ASSERT(!gMachine.Al.Alarm.xAlarmAir1);
			TEST_ASSERT(!gBlock[1].Al.xAlrCleanSensor);
			TEST_ASSERT(!gBlock[1].Al.xAlAirVenturi);
			gBlockInputs[1].xSiUnitModuleOk = TRUE;
			gBlock[1].In.xSiUnitModuleOk = gBlockInputs[1].xSiUnitModuleOk;
			gMachine.In.xAirSupply = TRUE;
			gBlock[1].In.xIclaSensor = TRUE;
			gBlock[1].In.xAirVenturiOK = TRUE;
			nextState();
			break;
			
		// xAirSupply alarm check cases 8 to 14
		case 8:
			strcpy(txStateDesc, "Order given: xToZero");
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;
		
		case 9:
			strcpy(txStateDesc, "Waiting for mode:Zero");
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 12 ); //We'll wait xx scan cycles
			nextState();
			break;
		
		case 10:
			strcpy(txStateDesc, "Order given: xToAuto");
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;
		
		case 11:
			strcpy(txStateDesc, "Waiting for mode:Auto, position:Cap");
			if (gMachine.Pt.xControlledByLine){
				TEST_BUSY_CONDITION(gLine.Status != LINE_IDLE);
				gLine.Commands.Print = TRUE;
			}
			else{
				TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
				gMachine.commandsSw.xStart_GI = TRUE;
			}
			nextState();
			break;	
		
		case 12:
			strcpy(txStateDesc, "Checking bars position in print");
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInPrint);
			gMachine.In.xAirSupply = FALSE;
			nextState();
			break;
			
		case 13:
			strcpy(txStateDesc, "Checking AirSupply alarm triggers");
			endtime = clock_ms();
			TEST_BUSY_CONDITION(endtime < TimeLast + gc_tiTesperaAlarmaAire + 200);
			TEST_ASSERT(gMachine.Al.Alarm.xAlarmAir1);
			TEST_ASSERT(gMachine.AlSummary.CurrentReasonStop > 0);
			nextState();
			break;
		
		case 14:
			strcpy(txStateDesc, "Checking going to stop");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 12 ); //We'll wait xx scan cycles
			if (gMachine.Pt.xControlledByLine){
				TEST_ASSERT(gLine.Status == LINE_CONTROLLED_STOP || gLine.Status == LINE_STOPPED);
			}
			else{
				TEST_ASSERT(gMachine.St.AutoMode.xStop);
			}
			gMachine.In.xAirSupply = TRUE;
			nextState();
			break;
			
		// AirVenturi alarm check cases 15 to 23
		case 15:
			strcpy(txStateDesc, "Order given: xToZero");
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;
		
		case 16:
			strcpy(txStateDesc, "Waiting for mode:Zero");
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			nextState();
			break;
		
		case 17:
			strcpy(txStateDesc, "Order given: xToAuto");
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;
		
		case 18:
			strcpy(txStateDesc, "Waiting for mode:Auto, position:Cap");
			gMachine.commandsSw.xReset_GI = TRUE;
			if (gMachine.Pt.xControlledByLine){
				TEST_BUSY_CONDITION(gLine.Status != LINE_IDLE);
				gLine.Commands.Print = TRUE;
			}
			else{
				TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
				gMachine.commandsSw.xStart_GI = TRUE;
			}
			nextState();
			break;	
		
		case 19:
			strcpy(txStateDesc, "Checking bars position in print");
			if (gMachine.Pt.xControlledByLine){
				TEST_BUSY_CONDITION(gLine.Status != LINE_PRINTING);
				gLine.Commands.Clean = TRUE;
			}
			else{
				TEST_BUSY_CONDITION(!gMachine.St.Position.xInPrint);
				gBlock[1].commands.xForceCleanNoDelay = TRUE;
			}
			nextState();
			break;
			
		case 20:
			strcpy(txStateDesc, "Perform cleaning and trigger alarm");
			if (gMachine.Pt.xControlledByLine){
				TEST_BUSY_CONDITION(gLine.Status != LINE_CLEANINGPH);
			}
			else{
				TEST_BUSY_CONDITION(!gMachine.St.Position.xCleaning);
			}
			gBlock[1].In.xAirVenturiOK = FALSE;
			nextState();
			break;
			
		case 21:
			strcpy(txStateDesc, "Checking Clean Sensor alarm triggers");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycle
			TEST_ASSERT(gBlock[1].Al.xAlAirVenturi);
			TEST_ASSERT(gMachine.AlSummary.CurrentReasonStop > 0);
			nextState();
			break;
		
		case 22:
			strcpy(txStateDesc, "Checking going to stop");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			if (gMachine.Pt.xControlledByLine){
				TEST_ASSERT(gLine.Status == LINE_CONTROLLED_STOP || gLine.Status == LINE_STOPPED);
			}
			else{
				TEST_ASSERT(gMachine.St.AutoMode.xStop);
			}
			gBlock[1].In.xAirVenturiOK = TRUE;
			nextState();
			break;
			
		case 23:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles			
			gSimMachine.Commands.xToZero = TRUE;
			gMachine.commandsSw.xReset_GI = TRUE;
			
			iTestState = 0;
			TEST_DONE;
			break;
		
		default:
			break;
	}
}
/* --- End test for DELOREAN-1455 --- */

/* --- Test for DELOREAN-1031 Check jam detection is always active in Noz2 machine models --- */
_TEST test_Noz2Jam(void)
{
	//If the Test makes non sense, not execute it. Only checks for Noz2.
	if (gMachine.Pt.MachineModel != Type_NOZ_2_AQ && gMachine.Pt.MachineModel != Type_NOZ_2_UV && gMachine.Pt.MachineModel != Type_NOZ_2_UV_White){
		
		iTestState = 0;
		TEST_DONE;		
	}
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_Noz2Jam");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			gMachine.parSw.xJamDetectEnable = FALSE;
			nextState();
			break;
			
		case 1:
			strcpy(txStateDesc, "Check jam detect enable");
			endtime =clock_ms();
			TEST_BUSY_CONDITION( !gMachine.parSw.xJamDetectEnable && endtime < TimeLast + 50000 );
			TEST_ASSERT(gMachine.parSw.xJamDetectEnable);
			
			iTestState = 0;
			TEST_DONE;
			break;
		
		default:
			break;
	}
}
/* --- End test for DELOREAN-1031 --- */

/* --- Test for DELOREAN-2070 Check ink tanks level alarm when using analog sensor --- */
_TEST test_InkTanksAl(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_InkTanksAl");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			strcpy(txStateDesc, "Order given: xToZero");
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;
		
		case 1:
			strcpy(txStateDesc, "Waiting for mode:Zero");
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			nextState();
			break;
		
		case 2:
			strcpy(txStateDesc, "Order given: xToAuto");
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;
			
		case 3:
			strcpy(txStateDesc, "Waiting to finish auto");
			gMachine.commandsSw.xReset_GI = TRUE;
			if (gMachine.Pt.xControlledByLine){
				TEST_BUSY_CONDITION(gLine.Status != LINE_IDLE);
				gLine.Commands.Print = TRUE;
			}
			else{
				TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
				gMachine.commandsSw.xStart_GI = TRUE;
			}
			nextState();
			break;
		
		case 4:
			for (iIndexBlock = 1; iIndexBlock <= gMachine.Pt.CT.iNumBlocks; iIndexBlock++){
				if(gBlock[iIndexBlock].parSw.xEnableToMovements){
					for (iIndex = 1; iIndex <= gBlock[iIndexBlock].parameters.Inks.iMaxBlockPrintBars; iIndex++){
						if (gInks[iIndex].parameters.parBar.xTypeTankSensorAnalog && gInks[iIndex].status.xBarInstalled){
							strcpy(txStateDesc, "Set tank Block_");
							itoa(iIndexBlock, stringAux);
							strcat(txStateDesc, stringAux);
							strcat(txStateDesc, " Bar_");
							itoa(iIndex, stringAux);
							strcat(txStateDesc, stringAux);
							strcat(txStateDesc, " ink level to 39%");
							gInks[iIndex].parSw.xActTestMode = FALSE;
							gSimInks[iIndex].Parameters.TankValuePercent = 39;
						}
					}
				}
			}
			nextState();
			break;

		case 5:
			strcpy(txStateDesc, "Waiting time delay alarm");
			endtime = clock_ms();
			TEST_BUSY_CONDITION(endtime < TimeLast + 15000);
			nextState();
			break;
			
		case 6:
			for (iIndexBlock = 1; iIndexBlock <= gMachine.Pt.CT.iNumBlocks; iIndexBlock++){
				if(gBlock[iIndexBlock].parSw.xEnableToMovements){
					for (iIndex = 1; iIndex <= gBlock[iIndexBlock].parameters.Inks.iMaxBlockPrintBars; iIndex++){
						if (gInks[iIndex].parameters.parBar.xTypeTankSensorAnalog && gInks[iIndex].status.xBarInstalled ){
							strcpy(txStateDesc, "Check warning alarm to fill tank for Block_");
							itoa(iIndexBlock, stringAux);
							strcat(txStateDesc, stringAux);
							strcat(txStateDesc, " Bar_");
							itoa(iIndex, stringAux);
							strcat(txStateDesc, stringAux);
							TEST_ASSERT(gInks[iIndex].Al.xAlrTankToFillIn && !gInks[iIndex].AlSummary.xAlarmStop);
							gSimInks[iIndex].Parameters.TankValuePercent = 46;
						}
					}
				}
			}
			nextState();
			break;
			
		case 7:
			strcpy(txStateDesc, "Waiting time delay alarm reset");
			endtime = clock_ms();
			TEST_BUSY_CONDITION(endtime < TimeLast + 15000);
			nextState();
			break;
			
		case 8:
			for (iIndexBlock = 1; iIndexBlock <= gMachine.Pt.CT.iNumBlocks; iIndexBlock++){
				if(gBlock[iIndexBlock].parSw.xEnableToMovements){
					for (iIndex = 1; iIndex <= gBlock[iIndexBlock].parameters.Inks.iMaxBlockPrintBars; iIndex++){
						if (gInks[iIndex].parameters.parBar.xTypeTankSensorAnalog && gInks[iIndex].status.xBarInstalled ){
							strcpy(txStateDesc, "Check warning alarm auto resets for Block_");
							itoa(iIndexBlock, stringAux);
							strcat(txStateDesc, stringAux);
							strcat(txStateDesc, " Bar_");
							itoa(iIndex, stringAux);
							strcat(txStateDesc, stringAux);
							strcat(txStateDesc, " if tank volume > 45%");
							TEST_ASSERT(!gInks[iIndex].Al.xAlrTankToFillIn && !gInks[iIndex].AlSummary.xAlarmStop);
							gInks[iIndex].parSw.xActTestMode = TRUE;
							gSimInks[iIndex].Parameters.TankValuePercent = 50;
						}
					}
				}
			}
	
			iTestState = 0;
			TEST_DONE;
			break;
		
		default:
			break;
	}
			
}
/* --- End test for DELOREAN-2070 --- */

/* --- Test for DELOREAN-1961 Different ink temperature set point if maintenance mode active --- */
_TEST test_MaintenanceModeInk(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_MaintenanceModeInk");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			strcpy(txStateDesc, "Order given: xToZero");
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;
		
		case 1:
			strcpy(txStateDesc, "Waiting for mode:Zero");
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			nextState();
			break;

		case 2:
			for (iIndexBlock = 1; iIndexBlock <= gMachine.Pt.CT.iNumBlocks; iIndexBlock++){
				if(gBlock[iIndexBlock].parSw.xEnableToMovements){
					for (iIndex = 1; iIndex <= gBlock[iIndexBlock].parameters.Inks.iMaxBlockPrintBars; iIndex++){
						if (gInks[iIndex].status.xBarInstalled){
							strcpy(txStateDesc, "Set Block_");
							itoa(iIndexBlock, stringAux);
							strcat(txStateDesc, stringAux);
							strcat(txStateDesc, " Bar_");
							itoa(iIndex, stringAux);
							strcat(txStateDesc, stringAux);
							strcat(txStateDesc, " Set point maintenance = 20 C");
							gInks[iIndex].parSw.Temp.rSetPointTempMaintenance = 20.0;
							gInks[iIndex].parSw.xActMaintenanceMode = TRUE;
						}
					}
				}
			}
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Wait for temperature preset changes ");
			endtime = clock_ms();
			TEST_BUSY_CONDITION(endtime < TimeLast + 40000);
			nextState();
			break;
			
		case 4:
			for (iIndexBlock = 1; iIndexBlock <= gMachine.Pt.CT.iNumBlocks; iIndexBlock++){
				if(gBlock[iIndexBlock].parSw.xEnableToMovements){
					for (iIndex = 1; iIndex <= gBlock[iIndexBlock].parameters.Inks.iMaxBlockPrintBars; iIndex++){
						if (gInks[iIndex].status.xBarInstalled ){
							strcpy(txStateDesc, "Check warning alarm maintenance and ink raw temperature for Block_");
							itoa(iIndexBlock, stringAux);
							strcat(txStateDesc, stringAux);
							strcat(txStateDesc, " Bar_");
							itoa(iIndex, stringAux);
							strcat(txStateDesc, stringAux);
							TEST_ASSERT(gInks[iIndex].Al.xAlrMaintenanceModeActive && (gInks[iIndex].signals.in.iTemperatureRaw - gInks[iIndex].parSw.Temp.rSetPointTempMaintenance*10) < 20.0 );
							gInks[iIndex].parSw.xActMaintenanceMode = FALSE;
						}
					}
				}
			}
		
			iTestState = 0;
			TEST_DONE;
		
			break;
		
		default:
			break;
	}
			
}
/* --- End test for DELOREAN-1031 --- */


/* --- Test for DELOREAN-1410 Chiller control and warnings --- */
_TEST test_ChillerInksAl(void)
{
	if (!gChiller[iInksChillerIndex].St.xInstalled || !gChiller[iInksChillerIndex].St.xEnabled ){
		iTestState = 0;
				
		TEST_DONE;		
	}
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_ChillerInksAl");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			strcpy(txStateDesc, "Order given: xToZero");
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;
		
		case 1:
			strcpy(txStateDesc, "Waiting for mode:Zero");
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			gMachine.commandsSw.xReset_GI = TRUE;
			nextState();
			break;

		case 2:
			strcpy(txStateDesc, "Check no stop alarm active");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); //We'll wait xx scan cycles
			TEST_ASSERT(!gMachine.AlSummary.xAlarmStop);
			gSimChiller[1].Commands.GenerateAlarm = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Chiller in alarm ");
			endtime = clock_ms();
			TEST_BUSY_CONDITION(endtime < TimeLast + 42000); // 10sec to consider Chiller in FAULT + 30sec to raise the alarm in the inks
			TEST_ASSERT(gMachine.AlSummary.xAlarmStop);
			nextState();
			break;
			
		case 4:
			strcpy(txStateDesc, "Check stop alarm ");
			gSimChiller[1].Commands.GenerateAlarm = FALSE;			
		
			iTestState = 0;
			TEST_DONE;
		
			break;
		
		default:
			break;
	}
			
}
/* --- Test for NOZOMITWO-2263 --- */

_TEST test_NotBlockInAutoIfNotHomed(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_NotBlockInAutoIfNotHomed");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			strcpy(txStateDesc, "Order given: xToZero");
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;
		
		case 1:
			strcpy(txStateDesc, "Waiting for mode:Zero");
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			gMachine.commandsSw.xReset_GI = TRUE;
			nextState();
			break;

		case 2:
			strcpy(txStateDesc, "Set block bars home status to FALSE");
			gBlock[1].Status.Motor.xBarsHomed = FALSE;
			nextState();
			break;
		
		case 3:
			strcpy(txStateDesc, "Order given: xToAuto");
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting for mode:Auto");
			gMachine.commandsSw.xReset_GI = TRUE;
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xAuto);
			nextState();
			break;	

		case 5:
			strcpy(txStateDesc, "Check block is not in auto ");
			if (TEST_ASSERT(gBlock[1].Status.BlockState != BLOCK_AUTO)){
				gSimMachine.Commands.xToManual = TRUE;
				nextState();
				break;
			}
			iTestState = 9;
			break;
			
		case 6:
			strcpy(txStateDesc, "Homing bars again Order given: xToManual ");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xManual );
			gBlock[1].commands.Manual.xManTrayOut = TRUE;
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Homing bars again Order given: xToManual ");
			TEST_BUSY_CONDITION( !gBlock[1].In.xTrayOut );
			gBlock[1].commands.xBarHomeOrder = TRUE;
			nextState();
			break;
			
		case 8:
			strcpy(txStateDesc, "Waiting homing ");
			TEST_BUSY_CONDITION( !gBlock[1].Status.Motor.xBarsHomed );
			nextState();
			break;
		
		case 9:

			iTestState = 0;
			TEST_DONE;
		
			break;
		
		default:
			break;
	}
			
}


_TEST test_RemoveTrayMovementMemoryWithKey(void)
{ // Related to https://jira.efi.com/browse/CUBE-963
	
	if (!gSafetyController.Parameters.xInstalled ){
		iTestState = 0;
		
		//This 2 lines just for the last TestCase
		strcpy(txTest, "BlockTests Finished!! Congrats!");
		strcpy(txStateDesc, "--");
		
		TEST_DONE;		
	}
	
	strcpy(txTest, "test_RemoveTrayMovementMemoryWithKey");
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
			gSimMachine.Commands.xToAuto = TRUE;
			strcpy(txStateDesc, "Going to Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Going to Cap");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( !gMachine.St.Position.xInCap );
			nextState();
			break;

		case 4:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 5:
			strcpy(txStateDesc, "Going to Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;
		
		case 6:
			gSimMachine.Commands.xToManual = TRUE;
			strcpy(txStateDesc, "Going to Manual");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xManual );
			nextState();
			break;

		case 7:
			strcpy(txStateDesc, "Activating the Key");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 2 ); //We'll wait xx scan cycles
			gSimSafetyController.Inputs.xPrinterMaintenanceKey = TRUE;
			nextState();
			break;

		case 8:
			strcpy(txStateDesc, "Send the order to move tray out");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 5 ); //We'll wait xx scan cycles
			gBlock[1].commands.Manual.xManTrayOut = TRUE;        
			nextState();
			break;

		case 9:
			strcpy(txStateDesc, "Checking NOT movement");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 20 ); //We'll wait xx scan cycles
			TEST_ASSERT( gBlock[1].In.xTrayIn );
			nextState();
			break;
		
		case 10:
			strcpy(txStateDesc, "Remove Key");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 5 ); //We'll wait xx scan cycles
			gSimSafetyController.Inputs.xPrinterMaintenanceKey = FALSE;
			nextState();
			break;
		
		case 11:
			strcpy(txStateDesc, "Checking NOT movement");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 20 ); //We'll wait xx scan cycles
			TEST_ASSERT( gBlock[1].In.xTrayIn );
			nextState();
			break;
		
		case 12:

			iTestState = 0;
			
			//This 2 lines just for the last TestCase
			strcpy(txTest, "BlockTests Finished!! Congrats!");
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
LastUpdated: 2024-03-01 15:54:59Z
By B+R UnitTest Helper Version: 2.0.1.59
*/
UNITTEST_FIXTURES(fixtures)
{
	new_TestFixture("test_CleanMachine", test_CleanMachine), 
	new_TestFixture("test_GoDownWithTrayError", test_GoDownWithTrayError), 
	new_TestFixture("test_GoUpWithTrayError", test_GoUpWithTrayError), 
	new_TestFixture("test_GoToPrintInLaboratory", test_GoToPrintInLaboratory), 
	new_TestFixture("test_GoToPrintInProduction", test_GoToPrintInProduction), 
	new_TestFixture("test_TraySensorErrorWhilePrinting", test_TraySensorErrorWhilePrinting), 
	new_TestFixture("test_GoToPrintWhileNSensorsCalibrationAreBeingChecked", test_GoToPrintWhileNSensorsCalibrationAreBeingChecked), 
	new_TestFixture("test_ToNotChangeBarsPositionSetpointWhileDetectionSystemMotorIsBeingPositioned", test_ToNotChangeBarsPositionSetpointWhileDetectionSystemMotorIsBeingPositioned), 
	new_TestFixture("test_GoToCleanBk1InLaboratory", test_GoToCleanBk1InLaboratory), 
	new_TestFixture("test_ReturnToPrintFromClean", test_ReturnToPrintFromClean), 
	new_TestFixture("test_RaiseBlocksToCapFromPrinting", test_RaiseBlocksToCapFromPrinting), 
	new_TestFixture("test_StopWhenPrint_ReturnPrintingBeforCapPosition", test_StopWhenPrint_ReturnPrintingBeforCapPosition), 
	new_TestFixture("test_CriticalAlarmWhilePrinting", test_CriticalAlarmWhilePrinting), 
	new_TestFixture("test_GoToMaintenanceWhenInPrintingPositionAndCheckBarsNotMove", test_GoToMaintenanceWhenInPrintingPositionAndCheckBarsNotMove), 
	new_TestFixture("test_CuringLedBarJamAlarm", test_CuringLedBarJamAlarm), 
	new_TestFixture("test_CameraJamAlarm", test_CameraJamAlarm), 
	new_TestFixture("test_TrayBlockMaintenanceKey", test_TrayBlockMaintenanceKey), 
	new_TestFixture("test_ToNotExecuteHomingBlockWhileMaintenanceKeyIsActivated", test_ToNotExecuteHomingBlockWhileMaintenanceKeyIsActivated), 
	new_TestFixture("test_ToNotExecuteHomingIclaWhileMaintenanceKeyIsActivated", test_ToNotExecuteHomingIclaWhileMaintenanceKeyIsActivated), 
	new_TestFixture("test_InkBarJamAlarm", test_InkBarJamAlarm), 
	new_TestFixture("test_ToCleanTest", test_ToCleanTest), 
	new_TestFixture("test_ToPrintPosTest", test_ToPrintPosTest), 
	new_TestFixture("test_InksFailNotEnabledToPrint", test_InksFailNotEnabledToPrint), 
	new_TestFixture("test_InksFailEnabledToPrint", test_InksFailEnabledToPrint), 
	new_TestFixture("test_NoBentAlarmThcChgOTFly", test_NoBentAlarmThcChgOTFly), 
	new_TestFixture("test_NoStopCleanWithNitrLow", test_NoStopCleanWithNitrLow), 
	new_TestFixture("test_NoFeederBarsPos", test_NoFeederBarsPos), 
	new_TestFixture("test_PneuBlockAls", test_PneuBlockAls), 
	new_TestFixture("test_Noz2Jam", test_Noz2Jam), 
	new_TestFixture("test_InkTanksAl", test_InkTanksAl), 
	new_TestFixture("test_MaintenanceModeInk", test_MaintenanceModeInk), 
	new_TestFixture("test_ChillerInksAl", test_ChillerInksAl), 
	new_TestFixture("test_NotBlockInAutoIfNotHomed", test_NotBlockInAutoIfNotHomed), 
	new_TestFixture("test_RemoveTrayMovementMemoryWithKey", test_RemoveTrayMovementMemoryWithKey), 
};

UNITTEST_CALLER_COMPLETE_EXPLICIT(BlockTests, "BlockTests", 0, 0, fixtures, 0, 0, 0);

