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
	exTimesPreFast = gDryer.St.exec.fast;
	exTimesPreSlow = gDryer.St.exec.slow;
	gTestsExec.iTestState++;
	TimeLast = clock_ms();
}

_TEST test_GoToZero(void)
{
	strcpy(gTestsExec.TestName, "test_GoToZero");
	switch (gTestsExec.iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(gTestsExec.TestStateDesctiption, "Going to Zero");
			TEST_BUSY_CONDITION( !gDryer.St.Mode.xZero );
			nextState();
			break;

		case 2:
			gTestsExec.iTestState = 0;
			TEST_ASSERT(TRUE);
			TEST_DONE;
			break;
		
		default:
			break;
	}	
}

_TEST test_PrepareBasicConfig(void)
{
	strcpy(gTestsExec.TestName, "test_PrepareBasicConfig");
	switch (gTestsExec.iTestState)
	{
		case 0:

			gDryer.Pt.SW.rBeltSpeedSetPoint = 15.0;	// 15.0m/min
			gDryer.Pt.SW.tiDelayConsent = SECONDS_TO_TIME(2);
			gDryer.In.xConsentOk = TRUE;

			gDryer.Pt.SW.Safety.rMaxBeltSpeedSetPoint = 70.0;
			gDryer.Pt.SW.Safety.rMarginSafePrint = 1.1;
			
			gBelt.parSw.rAxisLength = 650.0;
			gBelt.parSw.rGearBox = 35.0;
			
			gDryer.Pt.SW.xEnableNir = TRUE;
			
			gTransVacuum[1].Inputs.iPressureRaw = 16384; //This value is the equivalent to 0mbar of vacuum
			
			nextState();
			break;

		case 1:
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			nextState();
			break;

		case 2:
			gTestsExec.iTestState = 0;
			TEST_ASSERT(gDryer.Pt.xLeftHandMachine);
			TEST_DONE;
			break;
		
		default:
			break;
	}	
}

_TEST test_GoToManualFromZero(void)
{
	strcpy(gTestsExec.TestName, "test_GoToManualFromZero");
	switch (gTestsExec.iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 1:
			strcpy(gTestsExec.TestStateDesctiption, "Going to Zero");
			TEST_BUSY_CONDITION( !gDryer.St.Mode.xZero );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToManual = TRUE;
			nextState();
			break;

		case 3:
			strcpy(gTestsExec.TestStateDesctiption, "Going to Manual");
			TEST_BUSY_CONDITION( !gDryer.St.Mode.xManual );
			nextState();
			break;

		case 4:
			strcpy(gTestsExec.TestName, "test_PrepareMachine Finished!! Congrats!");
			strcpy(gTestsExec.TestStateDesctiption, "--");

			gTestsExec.iTestState = 0;
			TEST_ASSERT(TRUE);

			TEST_DONE;
			break;
		
		default:
			break;
	}	
}


_TEST test_ReferenceManualMotors(void)
{
	if (gDryer.Pt.MachineModel != DryerType_NOZ2_NIR_ARCLAMP){
		iTestState = 0;
		TEST_DONE;		
	}
	strcpy(gTestsExec.TestName, "test_ReferenceManualMotors");
	switch (gTestsExec.iTestState)
	{
		case 0:
			gSimMachine.Commands.xToManual = TRUE;
			nextState();
			break;

		case 1:
			strcpy(gTestsExec.TestStateDesctiption, "Going to Manual");
			TEST_BUSY_CONDITION( !gDryer.St.Mode.xManual );
			nextState();
			break;

		case 2:
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			gSimpleBlock[1].commands.xBarHomeOrder = TRUE;
			nextState();
			break;

		case 3:
			strcpy(gTestsExec.TestStateDesctiption, "Referencing vertical motors");
			TEST_BUSY_CONDITION( !gSimpleBlock[1].Status.Motor.xBarsHomed );
			nextState();
			break;

		case 4:
			gTestsExec.iTestState = 0;
			TEST_ASSERT(TRUE);

			strcpy(gTestsExec.TestName, "test_PrepareMachine Finished!! Congrats!");
			strcpy(gTestsExec.TestStateDesctiption, "--");

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
LastUpdated: 2021-05-20 08:42:32Z
By B+R UnitTest Helper Version: 2.0.1.59
*/
UNITTEST_FIXTURES(fixtures)
{
	new_TestFixture("test_GoToZero", test_GoToZero), 
	new_TestFixture("test_PrepareBasicConfig", test_PrepareBasicConfig), 
	new_TestFixture("test_GoToManualFromZero", test_GoToManualFromZero), 
	new_TestFixture("test_ReferenceManualMotors", test_ReferenceManualMotors), 
};

UNITTEST_CALLER_COMPLETE_EXPLICIT(PrepareDryer, "PrepareDryer", 0, 0, fixtures, 0, 0, 0);

