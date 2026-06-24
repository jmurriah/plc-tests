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


void nextState(){
	exTimesPreFast = gMachine.St.exec.fast;
	exTimesPreSlow = gMachine.St.exec.slow;
	iTestState++;
	TimeLast = clock_ms();	
	diff_t = diff_t;
	stringAux[120] = stringAux[120];
}

_TEST test_TestCase(void)
{
	strcpy(txTest, "test_TestCase");
	// Check txText <> than assigned, so just once
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			
			endtime = clock_ms();
			TEST_BUSY_CONDITION( endtime < TimeLast + 500 ); //We'll wait xx ms			
			
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );

			TEST_ASSERT(gMachine.St.Mode.xZero); //If variable is TRUE, the test is correct

			//This 2 lines just for the last TestCase
			strcpy(txTest, "test_TestCase Finished!! Congrats!");
			strcpy(txStateDesc, "--");
			
			iTestState = 0;
			TEST_DONE;
			
			nextState();
			break;
		
		default:
			break;
	}
}	

_TEST test_StackReceiveUnexpectedMedia(void)
{
	if (!gThicknessCtrl.status.xNewMediaStackEnabled)
	{
		TEST_DONE;
	}
	
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_StackReceiveUnexpectedMedia");
	// Check txText <> than assigned, so just once
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gMachine.commandsSw.xReset_GI = TRUE;
			gSimMachine.Parameters.Stack.xLoadNewMedia = FALSE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Going to Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
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
			gSimMachine.Commands.Media.xContinuousMediaPresent = TRUE;
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			nextState();
			break;

		case 6:
			strcpy(txStateDesc, "Receiving media");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			nextState();
			break;

		case 7:
			strcpy(txStateDesc, "Waiting the tray error to appear");
			endtime = clock_ms();
			if (gMachine.Al.Warning.xNotLoadedImage){
				nextState();
			}
			TEST_BUSY_CONDITION( endtime < TimeLast + 10000 ); //We'll wait xx ms
			nextState();
			break;
	
		case 8:
			TEST_ASSERT(gMachine.Al.Warning.xNotLoadedImage); //Alarm raised
			nextState();
			break;
		
		case 9:
			strcpy(txStateDesc, "Removing the error");
			gMachine.commandsSw.xReset_GI = TRUE;
			nextState();
			break;
		
		case 10:
			strcpy(txStateDesc, "Waiting the error to be removed");
			TEST_BUSY_CONDITION( gMachine.Al.Warning.xNotLoadedImage );
			gMachine.commandsSw.xReset_GI = FALSE;
			nextState();
			break;

		case 11:
			gSimMachine.Parameters.Stack.xLoadNewMedia = TRUE;
			
			iTestState = 0;
		
			strcpy(txTest, "test_StackReceiveUnexpectedMedia Finished!! Congrats!");
			strcpy(txStateDesc, "--");
		
			TEST_DONE;
			nextState();
			break;
	
		default:
			break;
	}
}


_TEST test_EnteringInAutoRemotely(void)
{
	// Do not execute the test if not machine controlled remotely
	if (!gMachine.Pt.xControlledRemotely)
	{
		TEST_DONE;
	}
	
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_EnteringInAutoRemotely");
	// Check txText <> than assigned, so just once
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Going to Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			// Managing the selector
			gMachine.In.Buttons.xZero = FALSE;
			gMachine.In.Buttons.xManual = FALSE;
			gMachine.In.Buttons.xAuto = TRUE;
			
			// Raising the remot signal
			gMachine.commandsSw.xReset_GI = TRUE;

			strcpy(txStateDesc, "Going to Auto");

			nextState();
			break;

		case 3:

			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles

			TEST_ASSERT(gMachine.St.Mode.xAuto); //If variable is TRUE, the test is correct

			iTestState = 0;
			
			strcpy(txTest, "test_EnteringInAutoRemotely Finished!! Congrats!");
			strcpy(txStateDesc, "--");
			
			TEST_DONE;
			nextState();
			break;
		
		default:
			break;
	}	
}


_TEST test_Beeping1sec(void)
{
	// Do not execute the test if not machine controlled remotely
	if (!gMachine.Pt.xControlledRemotely)
	{
		TEST_DONE;
	}

	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_Beeping1sec");
	// Check txText <> than assigned, so just once
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting to be in Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
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
			nextState();
			break;

		case 5:
			strcpy(txStateDesc, "Waiting the belt to receive order to start");
			TEST_BUSY_CONDITION( !gBelt.commands.xRunBelt);
			nextState();
			break;

		case 6:
			strcpy(txStateDesc, "Waiting time to check Belt started");
			endtime = clock_ms();
			// Wait 1.5sec to review the status of the belt
			TEST_BUSY_CONDITION( endtime < TimeLast + 1500 ); //We'll wait xx ms
			TEST_ASSERT(gBelt.states.xRuningBelt); //Alarm raised
			nextState();
			break;

		case 7:
			iTestState = 0;
		
			strcpy(txTest, "test_Beeping1sec Finished!! Congrats!");
			strcpy(txStateDesc, "--");
		
			TEST_DONE;
			nextState();
			break;
	
		default:
			break;
	}	
}


_TEST test_EnteringAndJogJamRecovery(void)
{
	// Do not execute the test if not jam recovery allowed
	if (!gMachine.Pt.xAllowJamRecovery)
	{
		TEST_DONE;
	}

	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_EnteringAndJogJamRecovery");
	// Check txText <> than assigned, so just once
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting to be in Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 2:
			strcpy(txStateDesc, "Going to Auto");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); //We'll wait xx scan cycles			
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gMachine.commandsSw.xToJamRecovery = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Going to Jam Recovery");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( !gMachine.St.AutoMode.xJamRecovery );
			nextState();
			break;

		case 4:
			strcpy(txStateDesc, "Waiting to Be ready to jog");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( !gMachine.St.Remote.xReadyToJogInJamRecovery );
			gMachine.In.xRemoteJog = TRUE;
			nextState();
			break;

		case 5:
			strcpy(txStateDesc, "Waiting the belt to start");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( !gBelt.states.xRuningBelt);
			TEST_ASSERT( gBelt.states.xRuningBelt); //(gBelt.states.rCurrentSpeed > 1 );
			gMachine.In.xRemoteJog = FALSE;
			nextState();
			break;

		case 6:
			strcpy(txStateDesc, "Waiting to stop the Belt");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			TEST_ASSERT( !gBelt.states.xRuningBelt );
			nextState();
			break;

		case 7:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 8:
			strcpy(txStateDesc, "Waiting to be in Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );

			iTestState = 0;
		
			strcpy(txTest, "test_EnteringAndJogJamRecovery Finished!! Congrats!");
			strcpy(txStateDesc, "--");
		
			TEST_DONE;
			nextState();
			break;
	
		default:
			break;
	}	
}


_TEST test_NotJogIfNotJamRecovery(void)
{
	// Do not execute the test if not jam recovery allowed
	if (!gMachine.Pt.xAllowJamRecovery)
	{
		TEST_DONE;
	}

	TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_NotJogIfNotJamRecovery");
	// Check txText <> than assigned, so just once
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting to be in Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 2:
			strcpy(txStateDesc, "Going to Auto");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); //We'll wait xx scan cycles			
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Activating the jog");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 3 ); //We'll wait xx scan cycles
			gMachine.In.xRemoteJog = TRUE;
			nextState();
			break;

		case 4:
			strcpy(txStateDesc, "Waiting the belt to start");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			TEST_ASSERT( gBelt.states.rCurrentSpeed < 0.1 );
			gMachine.In.xRemoteJog = FALSE;
			nextState();
			break;

		case 5:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 6:
			strcpy(txStateDesc, "Waiting to be in Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );

			iTestState = 0;
		
			strcpy(txTest, "test_NotJogIfNotJamRecovery Finished!! Congrats!");
			strcpy(txStateDesc, "--");
		
			TEST_DONE;
			nextState();
			break;
	
		default:
			break;
	}	
}


/*
B+R UnitTest: This is generated code.
Do not edit! Do not move!
Description: UnitTest Testprogramm infrastructure (TestSet).
LastUpdated: 2023-05-22 09:37:32Z
By B+R UnitTest Helper Version: 2.0.1.59
*/
UNITTEST_FIXTURES(fixtures)
{
	new_TestFixture("test_TestCase", test_TestCase), 
	new_TestFixture("test_StackReceiveUnexpectedMedia", test_StackReceiveUnexpectedMedia), 
	new_TestFixture("test_EnteringInAutoRemotely", test_EnteringInAutoRemotely), 
	new_TestFixture("test_Beeping1sec", test_Beeping1sec), 
	new_TestFixture("test_EnteringAndJogJamRecovery", test_EnteringAndJogJamRecovery), 
	new_TestFixture("test_NotJogIfNotJamRecovery", test_NotJogIfNotJamRecovery), 
};

UNITTEST_CALLER_COMPLETE_EXPLICIT(Cube, "Cube", 0, 0, fixtures, 0, 0, 0);

