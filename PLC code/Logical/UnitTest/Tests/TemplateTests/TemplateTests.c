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
}

_TEST test_TestCase(void)
{
	strcpy(txTest, "test_TestCase");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
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
			
			break;
		
		default:
			break;
	}
}


/*
B+R UnitTest: This is generated code.
Do not edit! Do not move!
Description: UnitTest Testprogramm infrastructure (TestSet).
LastUpdated: 2020-05-26 09:47:06Z
By B+R UnitTest Helper Version: 2.0.1.59
*/
UNITTEST_FIXTURES(fixtures)
{
	new_TestFixture("test_TestCase", test_TestCase), 
};

UNITTEST_CALLER_COMPLETE_EXPLICIT(TemplateTests, "TemplateTests", 0, 0, fixtures, 0, 0, 0);

