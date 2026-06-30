/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: BeltTests
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
	exTimesPreFast = gDryer.St.exec.fast;
	exTimesPreSlow = gDryer.St.exec.slow;
	gTestsExec.iTestState++;
	TimeLast = clock_ms();
}

_TEST test_ResetMountedTile(void)
{
	strcpy(gTestsExec.TestName, "test_ResetMountedMedia");
	switch (gTestsExec.iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gDryer.commands.xToLocal = TRUE;
			gDryer.Pt.SW.Media.rThickness = 6.0;	//10mm
			gDryer.Pt.SW.Media.rMargin = 12.0;		//2mm >> 2mm is bars position
			
			nextState();
			break;

		case 1:
			strcpy(gTestsExec.TestStateDesctiption, "Going to Zero");
			TEST_BUSY_CONDITION( !gDryer.St.Mode.xZero );
			gDryer.Pt.SW.xEnableNir = FALSE;
			gDryer.Pt.SW.xEnableArcLamp = FALSE;
			nextState();
			break;

		case 2:
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 2 ); //We'll wait xx scan cycles
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(gTestsExec.TestStateDesctiption, "Going to AutoLocal");
			TEST_BUSY_CONDITION( !gDryer.St.Mode.xAuto );
			TEST_BUSY_CONDITION( !gDryer.St.AutoLocation.xLocal );
			nextState();
			break;

		case 4:
			strcpy(gTestsExec.TestStateDesctiption, "Starting to dry");
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			gDryer.In.Sw.xStart_GI = TRUE;
			nextState();
			break;

		case 5:
			strcpy(gTestsExec.TestStateDesctiption, "Starting the belt");
			TEST_BUSY_CONDITION( !gBelt.states.xRuningBelt );
			nextState();
			break;
		
		case 6:
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			strcpy(gTestsExec.TestStateDesctiption, "Raised Mounted Media alarm");
			gBasicDetectMedia.Inputs.xMountedMedia = TRUE;
			nextState();
			break;
		
		case 7:
			TEST_BUSY_CONDITION(!gBasicDetectMedia.Alarms.xMountedMedia);
			nextState();
			break;
		
		case 8:
			//Enable resetting the alarm
			gBasicDetectMedia.Inputs.xMountedMedia = FALSE;
			nextState();
			break;
		
		case 9:
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			strcpy(gTestsExec.TestStateDesctiption, "Reseting alarm");
			gDryer.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 10:
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			gDryer.In.Buttons.xReset = FALSE;
			nextState();
			break;
		
		case 11:
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			TEST_ASSERT(!gBasicDetectMedia.Alarms.xMountedMedia);
			gTestsExec.iTestState = 0;
			
			TEST_DONE;
			break;
		
		default:
			break;
	}	
	
}

 // TEST NOZDRYER-450
_TEST test_KeepBlowersOnDueToMountedMedia(void)
{
	strcpy(gTestsExec.TestName, "test_KeepBlowersOnDueToMountedMedia");
	switch (gTestsExec.iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gDryer.commands.xToLocal = TRUE;
			gDryer.Pt.SW.rBeltSpeedSetPoint = 90.0;
			gDryer.Pt.SW.Media.rThickness = 6.0;	//10mm
			gDryer.Pt.SW.Media.rMargin = 12.0;		//2mm >> 2mm is bars position
			
			nextState();
			break;

		case 1:
			strcpy(gTestsExec.TestStateDesctiption, "Going to Zero");
			TEST_BUSY_CONDITION( !gDryer.St.Mode.xZero );
			gDryer.Pt.SW.xEnableNir = TRUE;
			gDryer.Pt.SW.xEnableArcLamp = FALSE;
			nextState();
			break;

		case 2:
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 2 ); //We'll wait xx scan cycles
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(gTestsExec.TestStateDesctiption, "Going to AutoLocal");
			TEST_BUSY_CONDITION( !gDryer.St.Mode.xAuto );
			TEST_BUSY_CONDITION( !gDryer.St.AutoLocation.xLocal );
			nextState();
			break;

		case 4:
			strcpy(gTestsExec.TestStateDesctiption, "Starting to dry");
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			gDryer.In.Sw.xStart_GI = TRUE;
			nextState();
			break;

		case 5:
			strcpy(gTestsExec.TestStateDesctiption, "Starting the belt");
			TEST_BUSY_CONDITION( gDryer.St.DryerState!=DRYERMACH_DRYING );
			nextState();
			break;
		
		case 6:
			strcpy(gTestsExec.TestStateDesctiption, "Raised Mounted Media alarm");
			TEST_BUSY_CONDITION( !gThicknessCtrl.status.MediaPosition.xMediaInside );
			gBasicDetectMedia.Inputs.xMountedMedia = TRUE;
			nextState();
			break;
		
		case 7:
			TEST_BUSY_CONDITION(!gBasicDetectMedia.Alarms.xMountedMedia);
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			TEST_ASSERT(gTransVacuum[1].Commands.xRunMaxDutyCycle);
			nextState();
			break;
		
		case 8:
			//Enable resetting the alarm
			gBasicDetectMedia.Inputs.xMountedMedia = FALSE;
			gDryer.In.Sw.xStopBlowers_GI = TRUE;
			nextState();
			break;
		
		case 9:
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			strcpy(gTestsExec.TestStateDesctiption, "Reseting alarm");
			TEST_ASSERT(!gTransVacuum[1].Commands.xRunMaxDutyCycle);
			gDryer.In.Sw.xReset_GI = TRUE;
			nextState();
			break;
		
		case 10:
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			strcpy(gTestsExec.TestStateDesctiption, "Going to zero");
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;		
		
		case 11:
			TEST_BUSY_CONDITION( !gDryer.St.Mode.xZero );
			strcpy(gTestsExec.TestStateDesctiption, "Going to Zero");
			nextState();
			break;			
		
		
		case 12:
			gSimMachine.Commands.xToManual = TRUE;
			strcpy(gTestsExec.TestStateDesctiption, "Going to Manual");
			TEST_BUSY_CONDITION( !gDryer.St.Mode.xManual );
			gDryer.In.Sw.xStart_GI = TRUE;
			nextState();
			break;
			
		case 13:
			strcpy(gTestsExec.TestStateDesctiption, "Emptying belt");
			TEST_BUSY_CONDITION( gThicknessCtrl.status.MediaPosition.xMediaInside );
			gSimMachine.Commands.xToZero = TRUE;
			gDryer.Pt.SW.rBeltSpeedSetPoint = 15.0;
			gTestsExec.iTestState = 0;
			
			TEST_DONE;
			break;
		
		default:
			break;
	}	
	
}

_TEST test_KeepBlowersOnDueToJam(void)
{
	strcpy(gTestsExec.TestName, "test_KeepBlowersOnDueToJam");
	switch (gTestsExec.iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gDryer.commands.xToLocal = TRUE;
			gDryer.Pt.SW.rBeltSpeedSetPoint = 90.0;
			gDryer.Pt.SW.Media.rThickness = 6.0;	//10mm
			gDryer.Pt.SW.Media.rMargin = 12.0;		//2mm >> 2mm is bars position
			
			nextState();
			break;

		case 1:
			strcpy(gTestsExec.TestStateDesctiption, "Going to Zero");
			TEST_BUSY_CONDITION( !gDryer.St.Mode.xZero );
			gDryer.Pt.SW.xEnableNir = TRUE;
			gDryer.Pt.SW.xEnableArcLamp = FALSE;
			nextState();
			break;

		case 2:
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 2 ); //We'll wait xx scan cycles
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(gTestsExec.TestStateDesctiption, "Going to AutoLocal");
			TEST_BUSY_CONDITION( !gDryer.St.Mode.xAuto );
			TEST_BUSY_CONDITION( !gDryer.St.AutoLocation.xLocal );
			nextState();
			break;

		case 4:
			strcpy(gTestsExec.TestStateDesctiption, "Starting to dry");
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			gDryer.In.Sw.xStart_GI = TRUE;
			nextState();
			break;

		case 5:
			strcpy(gTestsExec.TestStateDesctiption, "Starting the belt");
			TEST_BUSY_CONDITION( gDryer.St.DryerState!=DRYERMACH_DRYING );
			nextState();
			break;
		
		case 6:
			strcpy(gTestsExec.TestStateDesctiption, "Raised jam alarm");
			TEST_BUSY_CONDITION( !gThicknessCtrl.status.MediaPosition.xMediaInside );
			gSimJamDetect[1].Commands.CreateCrash[1] = TRUE;
			nextState();
			break;
		
		case 7:
			TEST_BUSY_CONDITION(!gDryer.Al.Alarm.xAlrJam);
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			TEST_ASSERT(gTransVacuum[1].Commands.xRunMaxDutyCycle && gDryer.Al.Alarm.xAlrJam);
			nextState();
			break;
		
		case 8:
			//Enable resetting the alarm
			gSimJamDetect[1].Commands.CreateCrash[1] = FALSE;
			gDryer.In.Sw.xStopBlowers_GI = TRUE;
			nextState();
			break;
		
		case 9:
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			strcpy(gTestsExec.TestStateDesctiption, "Reseting alarm");
			TEST_ASSERT(!gTransVacuum[1].Commands.xRunMaxDutyCycle);
			gDryer.In.Sw.xReset_GI;
			nextState();
			break;
		
		case 10:
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			strcpy(gTestsExec.TestStateDesctiption, "Going to zero");
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;		
		
		case 11:
			TEST_BUSY_CONDITION( !gDryer.St.Mode.xZero );
			strcpy(gTestsExec.TestStateDesctiption, "Going to Zero");
			nextState();
			break;			
		
		
		case 12:
			gSimMachine.Commands.xToManual = TRUE;
			strcpy(gTestsExec.TestStateDesctiption, "Going to Manual");
			TEST_BUSY_CONDITION( !gDryer.St.Mode.xManual );
			gDryer.In.Sw.xStart_GI = TRUE;
			nextState();
			break;
			
		case 13:
			strcpy(gTestsExec.TestStateDesctiption, "Emptying belt");
			TEST_BUSY_CONDITION( gThicknessCtrl.status.MediaPosition.xMediaInside );
			gSimMachine.Commands.xToZero = TRUE;
			gDryer.Pt.SW.rBeltSpeedSetPoint = 15.0;
			gTestsExec.iTestState = 0;
			
			TEST_DONE;
			break;
		
		default:
			break;
	}	
	
}

_TEST test_KeepBlowersOnDueToEStop(void)
{
	strcpy(gTestsExec.TestName, "test_KeepBlowersOnDueToEStop");
	switch (gTestsExec.iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gDryer.commands.xToLocal = TRUE;
			gDryer.Pt.SW.rBeltSpeedSetPoint = 90.0;
			gDryer.Pt.SW.Media.rThickness = 6.0;	//10mm
			gDryer.Pt.SW.Media.rMargin = 12.0;		//2mm >> 2mm is bars position
			
			nextState();
			break;

		case 1:
			strcpy(gTestsExec.TestStateDesctiption, "Going to Zero");
			TEST_BUSY_CONDITION( !gDryer.St.Mode.xZero );
			gDryer.Pt.SW.xEnableNir = TRUE;
			gDryer.Pt.SW.xEnableArcLamp = FALSE;
			nextState();
			break;

		case 2:
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 2 ); //We'll wait xx scan cycles
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(gTestsExec.TestStateDesctiption, "Going to AutoLocal");
			TEST_BUSY_CONDITION( !gDryer.St.Mode.xAuto );
			TEST_BUSY_CONDITION( !gDryer.St.AutoLocation.xLocal );
			nextState();
			break;

		case 4:
			strcpy(gTestsExec.TestStateDesctiption, "Starting to dry");
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			gDryer.In.Sw.xStart_GI = TRUE;
			nextState();
			break;

		case 5:
			strcpy(gTestsExec.TestStateDesctiption, "Starting the belt");
			TEST_BUSY_CONDITION( gDryer.St.DryerState!=DRYERMACH_DRYING );
			nextState();
			break;
		
		case 6:
			strcpy(gTestsExec.TestStateDesctiption, "Raised Emergency stop alarm");
			TEST_BUSY_CONDITION( !gThicknessCtrl.status.MediaPosition.xMediaInside );
			gDryer.In.Safety.xEStopFrontOK = FALSE;
			nextState();
			break;
		
		case 7:
			TEST_BUSY_CONDITION(!gDryer.Al.xAlrSafetySystemEStop);
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			TEST_ASSERT(gTransVacuum[1].Commands.xRunMaxDutyCycle);
			nextState();
			break;
		
		case 8:
			//Enable resetting the alarm
			gDryer.In.Safety.xEStopFrontOK = TRUE;
			gDryer.In.Sw.xStopBlowers_GI = TRUE;
			nextState();
			break;
		
		case 9:
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			strcpy(gTestsExec.TestStateDesctiption, "Reseting alarm");
			TEST_ASSERT(!gTransVacuum[1].Commands.xRunMaxDutyCycle);
			gDryer.In.Sw.xReset_GI = TRUE;
			nextState();
			break;
		
		case 10:
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			strcpy(gTestsExec.TestStateDesctiption, "Going to zero");
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;		
		
		case 11:
			TEST_BUSY_CONDITION( !gDryer.St.Mode.xZero );
			strcpy(gTestsExec.TestStateDesctiption, "Going to Zero");
			nextState();
			break;			
		
		
		case 12:
			gSimMachine.Commands.xToManual = TRUE;
			strcpy(gTestsExec.TestStateDesctiption, "Going to Manual");
			TEST_BUSY_CONDITION( !gDryer.St.Mode.xManual );
			gDryer.In.Sw.xStart_GI = TRUE;
			nextState();
			break;
			
		case 13:
			strcpy(gTestsExec.TestStateDesctiption, "Emptying belt");
			TEST_BUSY_CONDITION( gThicknessCtrl.status.MediaPosition.xMediaInside );
			gSimMachine.Commands.xToZero = TRUE;
			gDryer.Pt.SW.rBeltSpeedSetPoint = 15.0;
			gTestsExec.iTestState = 0;
			
			TEST_DONE;
			break;
		
		default:
			break;
	}	
	
}

_TEST test_KeepBlowersOnDueToCheckMediaFail(void)
{
	strcpy(gTestsExec.TestName, "test_KeepBlowersOnDueToCheckMediaFail");
	switch (gTestsExec.iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gDryer.commands.xToLocal = TRUE;
			gThicknessCtrl.parameters.CheckMedia[1].xActive = TRUE;
			gDryer.Pt.SW.rBeltSpeedSetPoint = 90.0;
			gDryer.Pt.SW.Media.rThickness = 6.0;	//10mm
			gDryer.Pt.SW.Media.rMargin = 12.0;		//2mm >> 2mm is bars position
			
			nextState();
			break;

		case 1:
			strcpy(gTestsExec.TestStateDesctiption, "Going to Zero");
			TEST_BUSY_CONDITION( !gDryer.St.Mode.xZero );
			gDryer.Pt.SW.xEnableNir = TRUE;
			gDryer.Pt.SW.xEnableArcLamp = FALSE;
			nextState();
			break;

		case 2:
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 2 ); //We'll wait xx scan cycles
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(gTestsExec.TestStateDesctiption, "Going to AutoLocal");
			TEST_BUSY_CONDITION( !gDryer.St.Mode.xAuto );
			TEST_BUSY_CONDITION( !gDryer.St.AutoLocation.xLocal );
			nextState();
			break;

		case 4:
			strcpy(gTestsExec.TestStateDesctiption, "Starting to dry");
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			gDryer.In.Sw.xStart_GI = TRUE;
			nextState();
			break;

		case 5:
			strcpy(gTestsExec.TestStateDesctiption, "Starting the belt");
			TEST_BUSY_CONDITION( gDryer.St.DryerState!=DRYERMACH_DRYING );
			nextState();
			break;
		
		case 6:
			strcpy(gTestsExec.TestStateDesctiption, "Raised check media at exit alarm");
			TEST_BUSY_CONDITION( !gThicknessCtrl.status.MediaPosition.xMediaInside );
			gThicknessCtrl.Inputs.CheckMedia[1].xCheckFail = FALSE;
			gThicknessCtrl.Inputs.CheckMedia[1].xCheckFail = FALSE;
			nextState();
			break;
		
		case 7:
			gThicknessCtrl.Inputs.CheckMedia[1].xCheckFail = FALSE;
			gThicknessCtrl.Inputs.CheckMedia[1].xCheckFail = FALSE;
			TEST_BUSY_CONDITION(!gThicknessCtrl.Alarms.CheckMedia[1]);
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			TEST_ASSERT(gTransVacuum[1].Commands.xRunMaxDutyCycle);
			nextState();
			break;
		
		case 8:
			//Enable resetting the alarm
			gThicknessCtrl.Inputs.CheckMedia[1].xCheckFail = TRUE;
			gThicknessCtrl.Inputs.CheckMedia[1].xCheckFail = TRUE;
			gDryer.In.Sw.xStopBlowers_GI = TRUE;
			nextState();
			break;
		
		case 9:
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			strcpy(gTestsExec.TestStateDesctiption, "Reseting alarm");
			TEST_ASSERT(!gTransVacuum[1].Commands.xRunMaxDutyCycle);
			gDryer.In.Sw.xReset_GI = TRUE;
			nextState();
			break;
		
		case 10:
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			strcpy(gTestsExec.TestStateDesctiption, "Going to zero");
			gSimMachine.Commands.xToZero = TRUE;
			nextState();
			break;		
		
		case 11:
			TEST_BUSY_CONDITION( !gDryer.St.Mode.xZero );
			strcpy(gTestsExec.TestStateDesctiption, "Going to Zero");
			nextState();
			break;			
		
		
		case 12:
			gSimMachine.Commands.xToManual = TRUE;
			strcpy(gTestsExec.TestStateDesctiption, "Going to Manual");
			TEST_BUSY_CONDITION( !gDryer.St.Mode.xManual );
			gDryer.In.Sw.xStart_GI = TRUE;
			nextState();
			break;
			
		case 13:
			strcpy(gTestsExec.TestStateDesctiption, "Emptying belt");
			TEST_BUSY_CONDITION( gThicknessCtrl.status.MediaPosition.xMediaInside );
			gSimMachine.Commands.xToZero = TRUE;
			gDryer.Pt.SW.rBeltSpeedSetPoint = 15.0;
			gThicknessCtrl.parameters.CheckMedia[1].xActive = FALSE;
			gTestsExec.iTestState = 0;
			
			TEST_DONE;
			break;
		
		default:
			break;
	}	
	
}
// END TEST NOZDRYER-450

_TEST test_StopWithBeltOvertorque(void)
{
	if (!gSimpleBlock[1].parameters.Hw.xExistBlock){
		iTestState = 0;
		TEST_DONE;		
	}

	strcpy(gTestsExec.TestName, "test_StopWithBeltOvertorque");
	switch (gTestsExec.iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gDryer.commands.xToLocal = TRUE;
			gDryer.Pt.SW.Media.rThickness = 6.0;	//10mm
			gDryer.Pt.SW.Media.rMargin = 12.0;		//2mm >> 2mm is bars position
			
			nextState();
			break;

		case 1:
			strcpy(gTestsExec.TestStateDesctiption, "Going to Zero");
			TEST_BUSY_CONDITION( !gDryer.St.Mode.xZero );
			gDryer.Pt.SW.xEnableNir = FALSE;
			gDryer.Pt.SW.xEnableArcLamp = FALSE;
			nextState();
			break;

		case 2:
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 2 ); //We'll wait xx scan cycles
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(gTestsExec.TestStateDesctiption, "Going to AutoLocal");
			TEST_BUSY_CONDITION( !gDryer.St.Mode.xAuto );
			TEST_BUSY_CONDITION( !gDryer.St.AutoLocation.xLocal );
			nextState();
			break;

		case 4:
			strcpy(gTestsExec.TestStateDesctiption, "Starting to dry");
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			gDryer.In.Sw.xStart_GI = TRUE;
			nextState();
			break;

		case 5:
			strcpy(gTestsExec.TestStateDesctiption, "Starting the belt");
			TEST_BUSY_CONDITION( !gBelt.states.xRuningBelt );
			nextState();
			break;
		
		case 6:
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			strcpy(gTestsExec.TestStateDesctiption, "Raised Overtoque alarm");
			gDryer.Al.Alarm.xAlrBeltOvertorque = TRUE;
			nextState();
			break;
		
		case 7:
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			strcpy(gTestsExec.TestStateDesctiption, "Checink state");
			TEST_ASSERT(gDryer.St.AutoMode.xStop); //Check alarm stop
			TEST_ASSERT(gSimpleBlock[1].Status.Position.xGoingToCap || gSimpleBlock[1].Status.Position.xInCap); //Check returnin to cap or in cap
			nextState();
			break;
		
		case 8:
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			strcpy(gTestsExec.TestStateDesctiption, "Reseting alarm");
			gDryer.In.Sw.xReset_GI = TRUE;
			nextState();
			break;
		
		case 9:
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles

			gDryer.In.Buttons.xReset = FALSE;
			gTestsExec.iTestState = 0;
			
			TEST_DONE;
			break;
		
		default:
			break;
	}	
	
}

_TEST test_PerformJamTest(void) //Test for NOZDRYER-460
{
	strcpy(gTestsExec.TestName, "test_PerformJamTest");
	switch (gTestsExec.iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gDryer.commands.xToLocal = TRUE;
			gDryer.Pt.SW.Media.rThickness = 6.0;	//10mm
			gDryer.Pt.SW.Media.rMargin = 12.0;		//2mm >> 2mm is bars position
			
			nextState();
			break;

		case 1:
			strcpy(gTestsExec.TestStateDesctiption, "Going to Zero");
			TEST_BUSY_CONDITION( !gDryer.St.Mode.xZero );
			gDryer.Pt.SW.xEnableNir = FALSE;
			gDryer.Pt.SW.xEnableArcLamp = FALSE;
			nextState();
			break;

		case 2:
			TEST_BUSY_CONDITION( gJamDetect[1].Status != JAMVIB_NOT_INIT ); //We'll wait xx scan cycles
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(gTestsExec.TestStateDesctiption, "Going to AutoLocal");
			TEST_BUSY_CONDITION( !gDryer.St.Mode.xAuto );
			nextState();
			break;

		case 4:
			strcpy(gTestsExec.TestStateDesctiption, "Jam 1 test signal activation");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( !gJamDetect[1].Outputs.xJamTestSignal[1] && endtime < TimeLast + 5000);
			TEST_ASSERT(gJamDetect[1].Outputs.xJamTestSignal[1]);
			nextState();
			break;

		case 5:
			strcpy(gTestsExec.TestStateDesctiption, "Check test jam sensor 1 ok");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( !gJamDetect[1].Inputs.xJamTestOk && endtime < TimeLast + 5000);
			TEST_ASSERT(gJamDetect[1].Inputs.xJamTestOk);
			nextState();
			break;
		
		case 6:
			TEST_BUSY_CONDITION( gJamDetect[1].Outputs.xJamTestSignal[1]);
			nextState();
			break;
		
		case 7:
			strcpy(gTestsExec.TestStateDesctiption, "Jam 2 test signal activation");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( !gJamDetect[1].Outputs.xJamTestSignal[2] && endtime < TimeLast + 5000);
			TEST_ASSERT(gJamDetect[1].Outputs.xJamTestSignal[2]);
			nextState();
			break;

		case 8:
			strcpy(gTestsExec.TestStateDesctiption, "Check test jam sensor 2 ok");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( !gJamDetect[1].Inputs.xJamTestOk && endtime < TimeLast + 5000);
			TEST_ASSERT(gJamDetect[1].Inputs.xJamTestOk);
			nextState();
			break;
		
		case 9:
			TEST_BUSY_CONDITION( gJamDetect[1].Outputs.xJamTestSignal[2]);
			nextState();
			break;
		
		case 10:
			strcpy(gTestsExec.TestStateDesctiption, "Jam 3 test signal activation");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( !gJamDetect[1].Outputs.xJamTestSignal[3] && endtime < TimeLast + 5000);
			TEST_ASSERT(gJamDetect[1].Outputs.xJamTestSignal[3]);
			nextState();
			break;

		case 11:
			strcpy(gTestsExec.TestStateDesctiption, "Check test jam sensor 3 ok");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( !gJamDetect[1].Inputs.xJamTestOk && endtime < TimeLast + 5000);
			TEST_ASSERT(gJamDetect[1].Inputs.xJamTestOk);
			nextState();
			break;
		
		case 12:
			TEST_BUSY_CONDITION( gJamDetect[1].Outputs.xJamTestSignal[3]);
			nextState();
			break;
		
		case 13:
			strcpy(gTestsExec.TestStateDesctiption, "Jam 4 test signal activation");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( !gJamDetect[1].Outputs.xJamTestSignal[4] && endtime < TimeLast + 5000);
			TEST_ASSERT(gJamDetect[1].Outputs.xJamTestSignal[4]);
			nextState();
			break;

		case 14:
			strcpy(gTestsExec.TestStateDesctiption, "Check test jam sensor 4 ok");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( !gJamDetect[1].Inputs.xJamTestOk && endtime < TimeLast + 5000);
			TEST_ASSERT(gJamDetect[1].Inputs.xJamTestOk);
			nextState();
			break;
		
		case 15:
			TEST_BUSY_CONDITION( gJamDetect[1].Outputs.xJamTestSignal[4]);
			nextState();
			break;
			
		case 16:
			strcpy(gTestsExec.TestStateDesctiption, "Check no alarm from jam test");
			TEST_ASSERT( !gJamDetect[1].Alarms.xAlrJamTest[1] || gJamDetect[1].Alarms.xAlrJamTest[2] || gJamDetect[1].Alarms.xAlrJamTest[3] || gJamDetect[1].Alarms.xAlrJamTest[4]);

			gTestsExec.iTestState = 0;
			
			TEST_DONE;
			break;
		
		default:
			break;
	}	
	
}

_TEST test_RemoteEmptyBelt(void) //Test for NOZDRYER-443
{
	strcpy(gTestsExec.TestName, "test_RemoteEmptyBelt");
	switch (gTestsExec.iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gDryer.commands.xToLocal = TRUE;
			gDryer.Pt.SW.Media.rThickness = 6.0;	//10mm
			gDryer.Pt.SW.Media.rMargin = 12.0;		//2mm >> 2mm is bars position
			
			nextState();
			break;

		case 1:
			strcpy(gTestsExec.TestStateDesctiption, "Going to Zero");
			TEST_BUSY_CONDITION( !gDryer.St.Mode.xZero );
			nextState();
			break;
			
		case 2:
			strcpy(gTestsExec.TestStateDesctiption, "Going to AutoRemote");
			TEST_BUSY_CONDITION( gDryer.St.exec.fast < exTimesPreFast + 2 );
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(gTestsExec.TestStateDesctiption, "Going to AutoRemote");
			TEST_BUSY_CONDITION( !gDryer.St.Mode.xAuto );
			gDryer.commands.xToRemote = TRUE;
			nextState();
			break;
		
		case 4:
			strcpy(gTestsExec.TestStateDesctiption, "Going to AutoRemote");
			TEST_BUSY_CONDITION( !gDryer.St.AutoLocation.xRemote );
			gDryerRemoteData.Parameters.xEnableNir = TRUE;
			gDryerRemoteData.Commands.xPrepareToEmptyBelt = TRUE;
			gDryerRemoteData.Parameters.xLineEmptyingBelt = TRUE;
			nextState();
			break;

		case 5:
			strcpy(gTestsExec.TestStateDesctiption, "Prepare empty belt, vacuum active before moving transport");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( gDryer.St.DryerState != DRYERMACH_PREPARINGEMPTYBELT && endtime < TimeLast + 1000);
			TEST_ASSERT(gTransVacuum[1].Status.State == TRANSVAC_CONTROLLING || gTransVacuum[1].Status.State == TRANSVAC_MAXIMUM);
			nextState();
			break;
		
		case 6:
			strcpy(gTestsExec.TestStateDesctiption, "Move transport");
			TEST_BUSY_CONDITION( !gDryerLocalData.xReadyToEmptyBelt);
			gDryerRemoteData.Commands.xRunTransport = TRUE;
			gDryerRemoteData.Commands.xPrepareToEmptyBelt = FALSE;
			nextState();
			break;
			
		case 7:
			strcpy(gTestsExec.TestStateDesctiption, "Prepare drying");
			TEST_BUSY_CONDITION( gDryer.St.DryerState != DRYERMACH_MOVING);
			gDryerRemoteData.Commands.xPrepareToDry = TRUE;
			nextState();
			break;
			
		case 8:
			strcpy(gTestsExec.TestStateDesctiption, "Dry");
			TEST_BUSY_CONDITION( gDryer.St.DryerState != DRYERMACH_PREPARED);
			gDryerRemoteData.Commands.xStartDrying = TRUE;
			gDryerRemoteData.Commands.xPrepareToDry = FALSE;
			nextState();
			break;
			
		case 9:
			strcpy(gTestsExec.TestStateDesctiption, "Check drying power");
			TEST_ASSERT ( gNirAdphos.Status.rPowerSetPoint < 11 && gNirAdphos.Status.rPowerSetPoint > 9);
			gDryerRemoteData.Parameters.xLineEmptyingBelt = FALSE;
			gDryerRemoteData.Commands.xStartDrying = FALSE;
			gDryerRemoteData.Parameters.xEnableNir = FALSE;
			gDryerRemoteData.Commands.xRunTransport = FALSE;
			gSimMachine.Commands.xToZero = TRUE;
			gDryer.commands.xToLocal = TRUE;
				
			strcpy(gTestsExec.TestName, "test_BeltTests Finished!! Congrats!");
			strcpy(gTestsExec.TestStateDesctiption, "--");

			gTestsExec.iTestState = 0;
			
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
LastUpdated: 2022-08-25 14:32:32Z
By B+R UnitTest Helper Version: 2.0.1.59
*/
UNITTEST_FIXTURES(fixtures)
{
	new_TestFixture("test_ResetMountedTile", test_ResetMountedTile), 
	new_TestFixture("test_KeepBlowersOnDueToMountedMedia", test_KeepBlowersOnDueToMountedMedia), 
	new_TestFixture("test_KeepBlowersOnDueToJam", test_KeepBlowersOnDueToJam),
	new_TestFixture("test_KeepBlowersOnDueToEStop", test_KeepBlowersOnDueToEStop),
	new_TestFixture("test_KeepBlowersOnDueToCheckMediaFail", test_KeepBlowersOnDueToJam),
	new_TestFixture("test_StopWithBeltOvertorque", test_StopWithBeltOvertorque), 
	new_TestFixture("test_PerformJamTest", test_PerformJamTest),
	new_TestFixture("test_RemoteEmptyBelt", test_RemoteEmptyBelt),
};

UNITTEST_CALLER_COMPLETE_EXPLICIT(BeltTests, "BeltTests", 0, 0, fixtures, 0, 0, 0);

