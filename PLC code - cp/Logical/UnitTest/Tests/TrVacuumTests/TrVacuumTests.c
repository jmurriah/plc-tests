/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: VacuumTests
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

_TEST test_StopBlowersOutProductionByPass(void)
{
	if (!gMachine.Pt.xAllowLaboratory){
		TEST_DONE;        
	}
	strcpy(txTest, "test_StopBlowersOutProduction-ByPass");
	switch (iTestState)
	{
		case 0:
			if (!gTransVacuum[1].Status.xInstalled)
			{
				TEST_DONE;
				break;
			}
			else
			{
				nextState();
				break;
			}
		case 1:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 2:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			gTransVacuum[1].parSw.xActiveOutOfProduction = FALSE;
			gSimMachine.Commands.xToAuto = TRUE;
			gMachine.parSw.rBeltSpeedSetPoint = 70.0;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;

		case 4:
			strcpy(txStateDesc, "Waiting the Belt to Start. In ByPass");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			gMachine.commandsSw.xToByPass_GI = TRUE;
			TEST_BUSY_CONDITION(!gMachine.St.AutoMode.xBypass); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION(!gBelt.states.xRuningBelt); //We'll wait xx scan cycles
			nextState();
			break;
		case 5:
			strcpy(txStateDesc, "CheckVacuumStopState");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			TEST_ASSERT(!gTransVacuum[1].Status.Blower.rDutyCycle>0.0);
			
			iTestState = 0;
			
			TEST_DONE;
			break;
		
		default:
			break;
	}
}
		
_TEST test_StartBlowersOutProductionByPass(void)
{
	strcpy(txTest, "test_StartBlowersOutProduction-ByPass");
	switch (iTestState)
	{
		case 0:
			if (!gTransVacuum[1].Status.xInstalled)
			{
				TEST_DONE;
				break;
			}
			else
			{
				nextState();
				break;
			}
		
		case 1:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 2:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			gTransVacuum[1].parSw.xActiveOutOfProduction = TRUE;
			gSimMachine.Commands.xToAuto = TRUE;
			gMachine.parSw.rBeltSpeedSetPoint = 70.0;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;

		case 4:
			strcpy(txStateDesc, "Waiting the Belt to Start. In ByPass");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			gMachine.commandsSw.xToByPass_GI = TRUE;
			TEST_BUSY_CONDITION(!gMachine.St.AutoMode.xBypass); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION(!gBelt.states.xRuningBelt); //We'll wait xx scan cycles
			nextState();
			break;
		case 5:
			strcpy(txStateDesc, "CheckVacuumStopState");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			TEST_ASSERT(gTransVacuum[1].Status.Blower.rDutyCycle>0.0);
			
			iTestState = 0;
			
			TEST_DONE;
			break;
		
		default:
			break;
	}
}

_TEST test_StopBlowersOutProductionLab(void)
{
	//Machines controlled by line do not have laboratory mode
	if (!gTransVacuum[1].Status.xInstalled || !gMachine.Pt.xAllowLaboratory)
	{
		TEST_DONE;
	}
	
	strcpy(txTest, "test_StopBlowersOutProductionLab");
	switch (iTestState)
	{
		case 0:
			//Here was previously code. Leaved like this to avoid renaming cases
			nextState();
			break;
		case 1:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 2:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			gTransVacuum[1].parSw.xActiveOutOfProduction = FALSE;
			gSimMachine.Commands.xToAuto = TRUE;
			gMachine.parSw.rBeltSpeedSetPoint = 70.0;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;

		case 4:
			strcpy(txStateDesc, "Waiting the machine in Lab");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			gMachine.commandsSw.xToLaboratory_GI = TRUE;
			TEST_BUSY_CONDITION(!gMachine.St.AutoMode.xLaboratory); //We'll wait xx scan cycles
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "CheckVacuumStopStateStopedBelt");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			TEST_ASSERT(!gTransVacuum[1].Status.Blower.rDutyCycle>0.0);
			gMachine.commands.xRunBelt = TRUE;
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "WaitBeltStart");
			TEST_BUSY_CONDITION( gBelt.states.xRuningBelt );
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "CheckVacuumStopStateRunningBelt");
			TEST_ASSERT(!gTransVacuum[1].Status.Blower.rDutyCycle>0.0);
			
			iTestState = 0;
			
			TEST_DONE;
			break;
		
		default:
			break;
	}
}

_TEST test_StartBlowersOutProductionLab(void)
{
	//Machines controlled by line do not have laboratory mode
	if (!gTransVacuum[1].Status.xInstalled || !gMachine.Pt.xAllowLaboratory)
	{
		strcpy(txTest, "test_TrVacuum Finished!! Congrats!");
		strcpy(txStateDesc, "--");
		TEST_DONE;
	}
	
	strcpy(txTest, "test_StartBlowersOutProductionLabLab");
	switch (iTestState)
	{
		case 0:
			//Here was previously code. Leaved like this to avoid renaming cases
			nextState();
			break;
		case 1:
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;

		case 2:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			gTransVacuum[1].parSw.xActiveOutOfProduction = TRUE;
			gSimMachine.Commands.xToAuto = TRUE;
			gMachine.parSw.rBeltSpeedSetPoint = 70.0;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;

		case 4:
			strcpy(txStateDesc, "Waiting the machine in Lab");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			gMachine.commandsSw.xToLaboratory_GI = TRUE;
			TEST_BUSY_CONDITION(!gMachine.St.AutoMode.xLaboratory); //We'll wait xx scan cycles
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "CheckVacuumStopStateStopedBelt");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
			TEST_ASSERT(!gTransVacuum[1].Status.Blower.rDutyCycle>0.0);
			gSimMachine.Commands.xToProduction = TRUE;
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "WaitBeltStart");
			TEST_BUSY_CONDITION(!gBelt.states.xRuningBelt );
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "CheckVacuumStopStateRunningBelt");
			TEST_ASSERT(gTransVacuum[1].Status.Blower.rDutyCycle>0.0);
			
			iTestState = 0;
			
			strcpy(txTest, "test_TrVacuum Finished!! Congrats!");
			strcpy(txStateDesc, "--");
			
			TEST_DONE;
			break;
		
		default:
			break;
	}
}


_TEST test_StopBlowersWhenGoingOutOfManual(void)
{
	strcpy(txTest, "test_StopBlowersWhenGoingOutOfManual");
	switch (iTestState)
	{
		case 0:
			if (!gTransVacuum[1].Status.xInstalled)
			{
				TEST_DONE;
				break;
			}
			else
			{
				nextState();
				break;
			}
		
		case 1:
			gSimMachine.Commands.xToManual = TRUE;
			gTransVacuum[1].parSw.rManSetPoint = 50.0;
			nextState();
			break;

		case 2:
			strcpy(txStateDesc, "Waiting the machine to be in manual");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xManual );
			gTransVacuum[1].OrdersSw.xRunManual = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the blowers to be running");
			TEST_BUSY_CONDITION( !gTransVacuum[1].Status.xStartedMan );
			TEST_BUSY_CONDITION( gTransVacuum[1].Status.Blower.rDutyCycle<gTransVacuum[1].parSw.rManSetPoint );
			nextState();
			break;

		case 4:
			strcpy(txStateDesc, "Waiting the Belt to Start. In ByPass");
			gSimMachine.Commands.xToZero = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "CheckVacuumStopState");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			TEST_ASSERT(!gTransVacuum[1].Status.xStartedMan);
			
			iTestState = 0;
			
			TEST_DONE;
			break;
		
		default:
			break;
	}
}

_TEST test_StopBlowersWithAlarmLaboratory(void)
{
	strcpy(txTest, "test_StopBlowersWithAlarmLaboratory");
	switch (iTestState)
	{
		case 0:
			strcpy(txStateDesc, "Checking the blowers are installed");
			if ((!gTransVacuum[1].Status.xInstalled) || (!gMachine.Pt.xAllowLaboratory)){
			TEST_DONE;
			break;
			}
			
			else{
			strcpy(txStateDesc, "Going to ZERO");			
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;
			}
		
		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			gTransVacuum[1].parSw.xActiveOutOfProduction = TRUE;
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;
		
		case 2:
			strcpy(txStateDesc, "Waiting the machine to be in Auto and CAP");
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xAuto);
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			gMachine.commandsSw.xToLaboratory_GI = TRUE;
			nextState();
			break;
		
		case 3:
			strcpy(txStateDesc, "TEST 1: Laboratory");
			endtime = clock_ms();
			TEST_BUSY_CONDITION(endtime < TimeLast + 1000);
			nextState();
			break;
			
		case 4:
			strcpy(txStateDesc, "Waiting for LABORATORY mode");
			TEST_BUSY_CONDITION(!gMachine.St.AutoMode.xLaboratory);
			
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Giving xStart command");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			gMachine.commandsSw.xStart_GI = TRUE;
			nextState();
			break;
		
		case 6: //checking if the machine reaches the positions it has to
			strcpy(txStateDesc, "Waiting for the start process to complete");
			TEST_BUSY_CONDITION(!gMachine.St.AutoMode.xProdORLab);//averiguar cuales son las variables a comprobar
			TEST_BUSY_CONDITION(!gBelt.states.xRuningBelt);
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "BlowersStartInAOP"); 
			endtime=clock_ms();
			TEST_BUSY_CONDITION(endtime < TimeLast + 50);
			TEST_ASSERT(gTransVacuum[1].Status.Blower.rDutyCycle > 0);//de momento la condición no se cumple, revisar
			
			nextState();
			break;
		
		case 8:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			gTransVacuum[1].parSw.xActiveOutOfProduction = FALSE;
			nextState();
			break;
			
		case 9:
			TEST_BUSY_CONDITION(gTransVacuum[1].parSw.xActiveOutOfProduction);
			nextState();
			break;
		
		case 10:
			endtime=clock_ms();
			TEST_BUSY_CONDITION(endtime < TimeLast + 5000);
			TEST_ASSERT(!gTransVacuum[1].Status.Blower.xMoving);
			nextState();
			break;
	
		case 11:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			gTransVacuum[1].parSw.xActiveOutOfProduction = TRUE;
			gMachine.commandsSw.xStart_GI = TRUE;
			nextState();
			break;
			
		case 12:
			TEST_BUSY_CONDITION(!gMachine.commandsSw.xStart_GI);
			TEST_BUSY_CONDITION(!gTransVacuum[1].parSw.xActiveOutOfProduction);
			nextState();
			break;
		
		case 13:
			endtime=clock_ms();
			TEST_BUSY_CONDITION(endtime < TimeLast + 5000);
			TEST_ASSERT(gTransVacuum[1].Status.Blower.xMoving);
			nextState();
			break;
		
		case 14:
			strcpy(txStateDesc, "Testing alarm to stop");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			gTransVacuum[1].Alarms.xAlrBlowersAnyCB = TRUE;
			nextState();
			break;
			
		case 15:
			TEST_BUSY_CONDITION(!gTransVacuum[1].Alarms.xAlrBlowersAnyCB);
			nextState();
			break;
		
		case 16:
			strcpy(txStateDesc, "BlowerStoppedW/Alarm");
			endtime=clock_ms();
			TEST_BUSY_CONDITION(endtime < TimeLast + 5000);
			TEST_ASSERT(!gTransVacuum[1].Status.Blower.xMoving);
			nextState();
			break;
			
		case 17: //stopping machine and returning to initial values
			strcpy(txStateDesc, "Returning to initial state");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			gTransVacuum[1].Alarms.xAlrBlowersAnyCB = FALSE;
			gMachine.commandsSw.xStop_GI = TRUE;
			nextState();
			break;
			
		case 18:
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			gMachine.commandsSw.xReset_GI = TRUE;
			iTestState=0;			
			
			TEST_DONE;
			break;
		
		default:
			break;
					
	}
}
_TEST test_StopBlowersWithAlarmByPass(void)
{
	strcpy(txTest, "test_StopBlowersWithAlarmByPass");
	switch (iTestState)
	{
		case 0:
			strcpy(txStateDesc, "Checking the blowers are installed");
			if (!gTransVacuum[1].Status.xInstalled){
			TEST_DONE;
			break;
			}
			
			else{
			strcpy(txStateDesc, "Going to ZERO");			
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;
			}
		
		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			gTransVacuum[1].parSw.xActiveOutOfProduction = TRUE;
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;
		
		case 2:
			strcpy(txStateDesc, "Waiting the machine to be in Auto and CAP");
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xAuto);
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			gMachine.commandsSw.xReset_GI = TRUE;
			nextState();
			break;
		
		case 3:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			gMachine.commandsSw.xToByPass_GI = TRUE;
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "TEST 2: ByPass");
			endtime = clock_ms();
			TEST_BUSY_CONDITION(endtime < TimeLast + 1000);
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Giving xStart command");
			TEST_BUSY_CONDITION(!gMachine.St.AutoMode.xBypass); //We'll wait xx scan cycles
			gMachine.commandsSw.xStart_GI = TRUE;
			nextState();
			break;
		
		case 6: //checking if the machine reaches the positions it has to
			strcpy(txStateDesc, "Waiting for the start process to complete");
			TEST_BUSY_CONDITION(!gMachine.St.AutoMode.xProdORByPass);//averiguar cuales son las variables a comprobar
			TEST_BUSY_CONDITION(!gBelt.states.xRuningBelt);
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "BlowersStartInAOP"); 
			endtime=clock_ms();
			TEST_BUSY_CONDITION(endtime < TimeLast + 50);
			TEST_ASSERT(gTransVacuum[1].Status.Blower.rDutyCycle > 0);//de momento la condición no se cumple, revisar
			gTransVacuum[1].parSw.xActiveOutOfProduction = FALSE;
			nextState();
			break;
			
		case 8:
			TEST_BUSY_CONDITION(gTransVacuum[1].parSw.xActiveOutOfProduction);
			nextState();
			break;
		
		case 9:
			endtime=clock_ms();
			TEST_BUSY_CONDITION(endtime < TimeLast + 5000);
			//If the blowers are started by another functionality, do not consider the test Failed
			TEST_ASSERT(!gTransVacuum[1].Status.Blower.xMoving || gTransVacuum[1].Commands.xRunByLine || gTransVacuum[1].Commands.xRunByRemote);
			nextState();
			break;
	
		case 10:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			gTransVacuum[1].parSw.xActiveOutOfProduction = TRUE;
			gMachine.commandsSw.xStart_GI = TRUE;
			nextState();
			break;
			
		case 11:
			TEST_BUSY_CONDITION(!gMachine.commandsSw.xStart_GI);
			TEST_BUSY_CONDITION(!gTransVacuum[1].parSw.xActiveOutOfProduction);
			nextState();
			break;
		
		case 12:
			endtime=clock_ms();
			TEST_BUSY_CONDITION(endtime < TimeLast + 5000);
			TEST_ASSERT(gTransVacuum[1].Status.Blower.xMoving);
			nextState();
			break;
		
		case 13:
			strcpy(txStateDesc, "Testing alarm to stop");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			gTransVacuum[1].Alarms.xAlrBlowersAnyCB = TRUE;
			nextState();
			break;
		
		case 14:
			strcpy(txStateDesc, "BlowerStoppedW/Alarm");
			TEST_BUSY_CONDITION(!gTransVacuum[1].Alarms.xAlrBlowersAnyCB);
			nextState();
			break;
			
		case 15:
			endtime=clock_ms();
			TEST_BUSY_CONDITION(endtime < TimeLast + 5000);
			TEST_ASSERT(!gTransVacuum[1].Status.Blower.xMoving);
			nextState();
			break;	
		
		case 16:
			strcpy(txStateDesc, "Returning to initial state");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			gTransVacuum[1].Alarms.xAlrBlowersAnyCB = FALSE;
			gMachine.commandsSw.xStop_GI = TRUE;
			nextState();
			break;
			
		case 17:
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			gMachine.commandsSw.xReset_GI = TRUE;
			iTestState=0;			
			
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
LastUpdated: 2023-04-26 09:55:10Z
By B+R UnitTest Helper Version: 2.0.1.59
*/
UNITTEST_FIXTURES(fixtures)
{
	new_TestFixture("test_StopBlowersOutProductionByPass", test_StopBlowersOutProductionByPass), 
	new_TestFixture("test_StartBlowersOutProductionByPass", test_StartBlowersOutProductionByPass), 
	new_TestFixture("test_StopBlowersOutProductionLab", test_StopBlowersOutProductionLab), 
	new_TestFixture("test_StartBlowersOutProductionLab", test_StartBlowersOutProductionLab), 
	new_TestFixture("test_StopBlowersWhenGoingOutOfManual", test_StopBlowersWhenGoingOutOfManual), 
	new_TestFixture("test_StopBlowersWithAlarmLaboratory", test_StopBlowersWithAlarmLaboratory), 
	new_TestFixture("test_StopBlowersWithAlarmByPass", test_StopBlowersWithAlarmByPass), 
};

UNITTEST_CALLER_COMPLETE_EXPLICIT(TrVacuumTests, "TrVacuumTests", 0, 0, fixtures, 0, 0, 0);

