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

_TEST test_BeltStopWithConsentInDTP_LinesInStop(void)
{
	//If the Test makes non sense, not execute it.
	if (gMachine.Pt.xControlledByLine){
		TEST_DONE;		
	}
	strcpy(txTest, "test_BeltStopWithConsentInDTP_LinesInStop");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gMachine.parSw.Dtp.xDoubleLine = TRUE;
			gMachine.parSw.Dtp.iModeLine1 = GC_DTP_STOP;
			gMachine.parSw.Dtp.iModeLine2 = GC_DTP_STOP;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			gMachine.In.xConsentL1Ok = TRUE;
			gMachine.In.xConsentL2Ok = TRUE;
			gMachine.parSw.rBeltSpeedSetPoint = 70.0;
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
			strcpy(txStateDesc, "Going to Production");
			TEST_BUSY_CONDITION( gMachine.St.AutoMode.xProduction);
			gMachine.commandsSw.xStart_GI = FALSE;
			nextState();
			break;

		case 5:
			strcpy(txStateDesc, "Waiting to check the Belt running");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			TEST_ASSERT(!gBelt.commands.xRunBelt); //Checked the order to the belt
			TEST_ASSERT(!gMachine.Out.xConsentL1); //Checked the consent to the next machine
			TEST_ASSERT(!gMachine.Out.xConsentL2); //Checked the consent to the next machine

			iTestState = 0;
			TEST_DONE;
			break;
		
		default:
			break;
	}
}

_TEST test_BeltStopWithoutConsentInDTP_LinesInByPass(void)
{
	//If the Test makes non sense, not execute it.
	if (gMachine.Pt.xControlledByLine){
		TEST_DONE;		
	}
	strcpy(txTest, "test_BeltStopWithoutConsentInDTP_LinesInByPass");
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
			gMachine.parSw.Dtp.xDoubleLine = TRUE;
			gMachine.parSw.Dtp.iModeLine1 = GC_DTP_BYPASS;
			gMachine.parSw.Dtp.iModeLine2 = GC_DTP_BYPASS;
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			gMachine.In.xConsentL1Ok = TRUE;
			gMachine.In.xConsentL2Ok = TRUE;
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
			gMachine.commandsSw.xToByPass_GI = TRUE; //gMachine.commandsSw.xToByPass_GI = FALSE;
			TEST_BUSY_CONDITION(!gMachine.St.AutoMode.xBypass); //We'll wait xx scan cycles
			gMachine.commandsSw.xToByPass_GI = FALSE;
			TEST_BUSY_CONDITION(!gBelt.states.xRuningBelt); //We'll wait xx scan cycles
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the consent Outputs");
			TEST_BUSY_CONDITION(!gMachine.Out.xConsentL1); //Checked the conscent to the next machine
			TEST_BUSY_CONDITION(!gMachine.Out.xConsentL2); //Checked the conscent to the next machine
			gMachine.In.xConsentL1Ok = FALSE;
			gMachine.In.xConsentL2Ok = FALSE;
			nextState();
			break;

		case 6:
			strcpy(txStateDesc, "Waiting the Belt to Stop. No consent");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
			
			TEST_ASSERT(!gBelt.states.xRuningBelt); //Checked the order to the belt
			TEST_ASSERT(!gMachine.Out.xConsentL1); //Checked the conscent to the next machine
			TEST_ASSERT(!gMachine.Out.xConsentL2); //Checked the conscent to the next machine

			iTestState = 0;
			TEST_DONE;
			break;
		
		default:
			break;
	}	
	
}

_TEST test_BeltStopWithConsentInDTP_L1InByPass_L1Stopped(void)
{
	//If the Test makes non sense, not execute it.
	if (gMachine.Pt.xControlledByLine){
		TEST_DONE;		
	}
	strcpy(txTest, "test_BeltStopWithConsentInDTP_L1InByPass_L1Stopped");
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
			gMachine.parSw.Dtp.xDoubleLine = TRUE;
			gMachine.parSw.Dtp.iModeLine1 = GC_DTP_STOP;
			gMachine.parSw.Dtp.iModeLine2 = GC_DTP_BYPASS;
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			gMachine.In.xConsentL1Ok = TRUE;
			gMachine.In.xConsentL2Ok = TRUE;
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
			TEST_BUSY_CONDITION(!gBelt.states.xRuningBelt); //We'll wait xx scan cycles
			gMachine.commandsSw.xToByPass_GI = FALSE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the consent L2 Output");
			TEST_BUSY_CONDITION(!gMachine.Out.xConsentL2); //Checked the consent to the next machine
			TEST_ASSERT(!gMachine.Out.xConsentL1); //Checked the consent to the next machine
			gMachine.In.xConsentL1Ok = FALSE;
			gMachine.In.xConsentL2Ok = FALSE;

			iTestState = 0;
			TEST_DONE;
			break;

		default:
			break;
	}	
	
}

_TEST test_BeltStopWithConsentInDTP_L1InByPass_L2Stopped(void)
{
	//If the Test makes non sense, not execute it.
	if (gMachine.Pt.xControlledByLine){
		TEST_DONE;		
	}
	strcpy(txTest, "test_BeltStopWithConsentInDTP_L1InByPass_L2Stopped");
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
			gMachine.parSw.Dtp.xDoubleLine = TRUE;
			gMachine.parSw.Dtp.iModeLine1 = GC_DTP_BYPASS;
			gMachine.parSw.Dtp.iModeLine2 = GC_DTP_STOP;
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			gMachine.In.xConsentL1Ok = TRUE;
			gMachine.In.xConsentL2Ok = TRUE;
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
			TEST_BUSY_CONDITION(!gBelt.states.xRuningBelt); //We'll wait xx scan cycles
			gMachine.commandsSw.xToByPass_GI = FALSE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the consent L1 Output");
			TEST_BUSY_CONDITION(!gMachine.Out.xConsentL1); //Checked the consent to the next machine
			TEST_ASSERT(!gMachine.Out.xConsentL2); //Checked the consent to the next machine
			gMachine.In.xConsentL1Ok = FALSE;
			gMachine.In.xConsentL2Ok = FALSE;

			iTestState = 0;
			TEST_DONE;
			break;

		default:
			break;
	}	
}

_TEST test_BeltStopWithoutConsentInDTP_LinesProduction(void)
{
	//If the Test makes non sense, not execute it.
	if (gMachine.Pt.xControlledByLine){
		TEST_DONE;		
	}
	strcpy(txTest, "test_BeltStopWithoutConsentInDTP_LinesProduction");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gMachine.parSw.Dtp.xDoubleLine = TRUE;
			gMachine.parSw.Dtp.iModeLine1 = GC_DTP_RUN;
			gMachine.parSw.Dtp.iModeLine2 = GC_DTP_RUN;
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
			gMachine.In.xConsentL1Ok = TRUE;
			gMachine.In.xConsentL2Ok = TRUE;
			gMachine.In.Buttons.xReset = TRUE;
			gMachine.parSw.rBeltSpeedSetPoint = 70.0;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gMachine.In.Buttons.xReset = FALSE;
			gSimMachine.Commands.xToProduction = TRUE;
			nextState();
			break;

		case 4:
			strcpy(txStateDesc, "Waiting the machine to be in Productiong");
			TEST_BUSY_CONDITION( !gMachine.St.AutoMode.xProduction);
			gSimMachine.Commands.xToProduction = TRUE;
			nextState();
			break;

		case 5:
			strcpy(txStateDesc, "Waiting the Belt to Run");
			TEST_BUSY_CONDITION(!gBelt.commands.xRunBelt); //We'll wait xx scan cycles
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the Out consents to activate");
			TEST_BUSY_CONDITION(!gMachine.Out.xConsentL1); //Checked the consent to the next machine
			TEST_BUSY_CONDITION(!gMachine.Out.xConsentL2); //Checked the consent to the next machine
			nextState();
			break;

		case 7:
			strcpy(txStateDesc, "Removed consent in lines");
			gMachine.In.xConsentL1Ok = FALSE;
			gMachine.In.xConsentL2Ok = FALSE;
			nextState();
			break;
		
		case 8:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
			TEST_ASSERT(!gBelt.states.xRuningBelt); //Checked the order to the belt
			TEST_ASSERT(!gMachine.Out.xConsentL1); //Checked the consent to the next machine
			TEST_ASSERT(!gMachine.Out.xConsentL2); //Checked the consent to the next machine

			gMachine.parSw.Dtp.xDoubleLine = FALSE;
			gMachine.parSw.Dtp.iModeLine1 = GC_DTP_RUN;
			gMachine.parSw.Dtp.iModeLine2 = GC_DTP_RUN;

			iTestState = 0;
			TEST_DONE;
			break;

		default:
			break;
	}	
}

_TEST test_ConsentInDTP_Lab(void)
{
	//If the Test makes non sense, not execute it.
	if (!gMachine.Pt.xAllowLaboratory){
		TEST_DONE;		
	}
	strcpy(txTest, "test_ConsentInDTP_Lab");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gMachine.parSw.Dtp.xDoubleLine = TRUE;
			gMachine.parSw.Dtp.iModeLine1 = GC_DTP_RUN;
			gMachine.parSw.Dtp.iModeLine2 = GC_DTP_RUN;
			gMachine.parSw.tiDelayConsent = 0;
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
			gMachine.In.xConsentL1Ok = TRUE;
			gMachine.In.xConsentL2Ok = TRUE;
			gMachine.parSw.rBeltSpeedSetPoint = 70.0;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Manual");
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gMachine.In.Buttons.xReset = FALSE;
			nextState();
			break;

		case 4:
			strcpy(txStateDesc, "Waiting to be in Lab");
			gMachine.commandsSw.xToLaboratory_GI = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.AutoMode.xLaboratory );
			gMachine.commandsSw.xToLaboratory_GI = FALSE;
			nextState();
			break;

		case 5:
			strcpy(txStateDesc, "Waiting to send start order");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			gSimMachine.Commands.xToProduction = TRUE;
			nextState();
			break;

		case 6:
			strcpy(txStateDesc, "Waiting the Belt to Run");
			TEST_BUSY_CONDITION(!gBelt.states.xRuningBelt); //We'll wait xx scan cycles
			gMachine.commandsSw.xStart_GI = FALSE;
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Waiting to wait the Out consents to activate");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			nextState();
			break;

		case 8:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			TEST_ASSERT(gBelt.states.xRuningBelt); //Checked the order to the belt
			TEST_ASSERT(!gMachine.Out.xConsentL1); //Checked the consent to the next machine
			TEST_ASSERT(!gMachine.Out.xConsentL2); //Checked the consent to the next machine

			gMachine.parSw.Dtp.xDoubleLine = FALSE;
			gMachine.parSw.tiDelayConsent = SECONDS_TO_TIME(2);
			
			iTestState = 0;
			TEST_DONE;
			break;

		default:
			break;
	}	
}

_TEST test_ConsentInDTP_Manual(void)
{
	//If the Test makes non sense, not execute it.
	if (gMachine.Pt.xControlledByLine){
		TEST_DONE;		
	}
	strcpy(txTest, "test_ConsentInDTP_Manual");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gMachine.parSw.Dtp.xDoubleLine = TRUE;
			gMachine.parSw.Dtp.iModeLine1 = GC_DTP_RUN;
			gMachine.parSw.Dtp.iModeLine2 = GC_DTP_RUN;
			gMachine.parSw.tiDelayConsent = 0;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToManual = TRUE;
			gMachine.In.xConsentL1Ok = TRUE;
			gMachine.In.xConsentL2Ok = TRUE;
			gMachine.parSw.rBeltSpeedSetPoint = 70.0;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Manual");
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xManual );
			gMachine.In.Buttons.xReset = FALSE;
			nextState();
			break;

		case 4:
			strcpy(txStateDesc, "Sending start order");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			gSimMachine.Commands.xToProduction = TRUE;
			nextState();
			break;

		case 5:
			strcpy(txStateDesc, "Waiting the Belt to Run");
			TEST_BUSY_CONDITION(!gBelt.states.xRuningBelt); //We'll wait xx scan cycles
			gMachine.commandsSw.xStart_GI = FALSE;
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting to wait the Out consents to activate");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			nextState();
			break;

		case 7:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			TEST_ASSERT(gBelt.states.xRuningBelt); //Checked the order to the belt
			TEST_ASSERT(!gMachine.Out.xConsentL1); //Checked the consent to the next machine
			TEST_ASSERT(!gMachine.Out.xConsentL2); //Checked the consent to the next machine

			gMachine.parSw.Dtp.xDoubleLine = FALSE;
			gMachine.parSw.tiDelayConsent = SECONDS_TO_TIME(2);
			
			iTestState = 0;
			
			TEST_DONE;

			break;

		default:
			break;
	}	
}

_TEST test_NoConsentInLab(void)
{
	//If the Test makes non sense, not execute it.
	if (!gMachine.Pt.xAllowLaboratory){
		TEST_DONE;		
	}
	strcpy(txTest, "test_NoConsentInLab");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gMachine.parSw.Dtp.xDoubleLine = TRUE;
			gMachine.parSw.Dtp.iModeLine1 = GC_DTP_RUN;
			gMachine.parSw.Dtp.iModeLine2 = GC_DTP_RUN;
			gMachine.parSw.tiDelayConsent = 0;
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
			gMachine.In.xConsentL1Ok = FALSE;
			gMachine.In.xConsentL2Ok = FALSE;
			gMachine.parSw.rBeltSpeedSetPoint = 70.0;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gMachine.In.Buttons.xReset = FALSE;
			nextState();
			break;

		case 4:
			strcpy(txStateDesc, "Waiting to be in Lab");
			gMachine.commandsSw.xToLaboratory_GI = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.AutoMode.xLaboratory );
			gMachine.commandsSw.xToLaboratory_GI = FALSE;
			nextState();
			break;

		case 5:
			strcpy(txStateDesc, "Waiting to send start order");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			gSimMachine.Commands.xToProduction = TRUE;
			nextState();
			break;

		case 6:
			strcpy(txStateDesc, "Waiting the Belt to Run");
			TEST_BUSY_CONDITION(!gBelt.states.xRuningBelt); //We'll wait xx scan cycles
			gMachine.commandsSw.xStart_GI = FALSE;
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Waiting to wait the Out consents to activate");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			nextState();
			break;

		case 8:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			TEST_ASSERT(gBelt.states.xRuningBelt); //Checked the order to the belt
			
			gMachine.parSw.Dtp.xDoubleLine = FALSE;
			gMachine.parSw.tiDelayConsent = SECONDS_TO_TIME(2);
			
			iTestState = 0;
			
			TEST_DONE;
			break;

		default:
			break;
	}	
}

_TEST test_RiseBarsWithNoConsent(void)
{
	//If the Test makes non sense, not execute it.
	if (gMachine.Pt.xControlledByLine){
		TEST_DONE;		
	}
	strcpy(txTest, "test_RiseBarsWithNoConsent");
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gMachine.parSw.Dtp.xDoubleLine = TRUE;
			gMachine.parSw.Dtp.iModeLine1 = GC_DTP_RUN;
			gMachine.parSw.Dtp.iModeLine2 = GC_DTP_RUN;
			gMachine.parSw.tiDelayConsent = 0;
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
			gMachine.In.xConsentL1Ok = TRUE;
			gMachine.In.xConsentL2Ok = TRUE;
			gMachine.parSw.rBeltSpeedSetPoint = 70.0;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the machine to be in Auto");
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gMachine.In.Buttons.xReset = FALSE;
			nextState();
			break;

		case 4:
			strcpy(txStateDesc, "Waiting to be in Production");
			gMachine.commandsSw.xToNormal_GI = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.AutoMode.xProduction );
			TEST_BUSY_CONDITION(!gBelt.commands.xRunBelt);
			gMachine.commandsSw.xToNormal_GI = FALSE;
			nextState();
			break;

		case 5:
			strcpy(txStateDesc, "Waiting the Out consents to activate");
			TEST_BUSY_CONDITION(!gMachine.Out.xConsentL1); //Checked the consent to the next machine
			TEST_BUSY_CONDITION(!gMachine.Out.xConsentL2); //Checked the consent to the next machine
			nextState();
			break;
		
		case 6:
			gMachine.In.xConsentL1Ok = FALSE;
			gMachine.In.xConsentL2Ok = FALSE;
			nextState();
			break;

		case 7:
			strcpy(txStateDesc, "Waiting the machine waiting consents");
			TEST_BUSY_CONDITION(gBelt.states.xRuningBelt);
			TEST_BUSY_CONDITION(gMachine.Out.xConsentL1 || gMachine.Out.xConsentL2); //Checked the consent to the next machine
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Waiting to speed up timer");
			TEST_BUSY_CONDITION(!gMachine.St.Consent.xUpWithNoConsentCountingTime); //We'll wait xx scan cycles
			gSimMachine.Commands.Consent.xRaiseUpWithNoConsent = TRUE;
			nextState();
			break;
		
		case 9:
			strcpy(txStateDesc, "Check bars go up");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( !gBlock[1].Status.Position.xInCap );
			TEST_ASSERT(gMachine.St.Consent.xUpWithNoConsent); //Checked the machine state
			gSimMachine.Commands.Consent.xRaiseUpWithNoConsent = FALSE;
			TEST_ASSERT(!gBlock[1].Status.Position.xInPrint);
			nextState();
			break;
			
		case 10:
			gMachine.In.xConsentL1Ok = TRUE;
			gMachine.In.xConsentL2Ok = TRUE;
			gMachine.parSw.tiDelayConsent = 0;
			nextState();
			break;
			
		case 11:
			strcpy(txStateDesc, "Check bars go down");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInPrint);
			TEST_BUSY_CONDITION(!gBelt.states.xRuningBelt);
			nextState();
			break;
			
		case 12:
			strcpy(txStateDesc, "WaitBars in print position");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInPrint);
			TEST_ASSERT(!gMachine.St.Consent.xUpWithNoConsent); //Checked the machine state
			
			nextState();
			break;
			
		case 13:
			strcpy(txStateDesc, "CheckBeltRuning");
			TEST_ASSERT(gBelt.commands.xRunBelt);
			
			gMachine.parSw.Dtp.xDoubleLine = FALSE;
			gMachine.parSw.tiDelayConsent = SECONDS_TO_TIME(2);
			gMachine.In.xConsentL1Ok = TRUE;
			gMachine.In.xConsentL2Ok = TRUE;
			
			iTestState = 0;
			
			strcpy(txTest, "test_ConsentTest Finished!! Congrats!");
			strcpy(txStateDesc, "--");
			
			TEST_DONE;
			break;

		default:
			break;
	}	
}

//PRINTHEAD PROTECTION tests

//------ BM NO VACUUM -------

_TEST test_NoVacPausedStoppedMediaHeatBelowPH(void)  //TEST 1: tests if, on a machine with no vacuum, with a pause input, PHs protect, and when pause is removed, they go back to print before 5min pass.
{
	//If the Test makes non sense, not execute it.
	if (gTransVacuum[1].Status.xInstalled || gMachine.Pt.xControlledByLine){
		TEST_DONE;
	}
	strcpy(txTest, "test_NoVacPausedStoppedMediaHeatBelowPH");
	switch (iTestState)
	{
		case 0://to zero
			strcpy(txStateDesc, "Startup");
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 3 );
			gSimMachine.Commands.xToZero = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;
		
		case 1://to auto, wait for cap
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;
		
		case 2://start and media order
			strcpy(txStateDesc, "Start and media present order");
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			gSimMachine.Commands.Media.rMediaThickness = gBlock[1].parameters.Motor.rMinSafePosition;//needs thickness setting to avoid going to xMinSafePos
			gMachine.parSw.Media.rThickness = gBlock[1].parameters.Motor.rMinSafePosition;//needs thickness setting to avoid going to xMinSafePos
			gMachine.commandsSw.xStart_GI = TRUE;
			nextState();
			break;
			
		case 3:			
			TEST_BUSY_CONDITION(!gBelt.states.xRuningBelt);
			gSimMachine.Commands.Media.xMediaPresent = TRUE;
			nextState();
			break;
			
		case 4:
			strcpy(txStateDesc, "Pause order");
			TEST_BUSY_CONDITION(!gThicknessCtrl.status.MediaPosition.xMediaInside);
			gMachine.commandsSw.xPause_GI = TRUE;
			nextState();
			break;
		
		case 5://pause order
			TEST_BUSY_CONDITION(gBlock[1].Status.rMotorPosition != gBlock[1].parameters.rPrePrintingPos);
			nextState();
			break;
		
		case 6://wait some time
			strcpy(txStateDesc, "Printheads should have protected");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( endtime < TimeLast + 1000);//arbitrary time, less than 5min
			nextState();
			break;
		
		case 7://for t<5min, bars should go back down
			strcpy(txStateDesc, "Given Start order");
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 3 );
			gMachine.commandsSw.xStart_GI = TRUE;
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Bars should go to print");
			TEST_BUSY_CONDITION(gBlock[1].Status.rMotorPosition == gBlock[1].parameters.rPrePrintingPos);
			nextState();
			break;
		
		case 9:
			TEST_BUSY_CONDITION(!gBelt.states.xRuningBelt);
			nextState();
		
		case 10:
			TEST_ASSERT_EQUAL_FLOAT(gBlock[1].Status.rMotorPosition, gBlock[1].parameters.Motor.rPrintPosition);
			nextState();
			break;
		
		case 11://reset some changes for following tests
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 3 );
			gSimMachine.Commands.Media.xMediaPresent = FALSE;
			nextState();
			break;
			
		case 12:
			TEST_BUSY_CONDITION(gThicknessCtrl.status.MediaPosition.xMediaInside);
			gMachine.commandsSw.xStop_GI = TRUE;
			
			iTestState = 0;
			strcpy(txStateDesc, "test completed");
			
			TEST_DONE;
			break;
		
		default:
			break;
		
	}
}

_TEST test_NoVacConsentOffStoppedMediaHeatBelowPH(void) //TEST 2: tests if, on a machine with no vacuum, with a consent removal, PHs protect, and when pause is removed, they go back to print before.
{
	//If the Test makes non sense, not execute it.
	if (gTransVacuum[1].Status.xInstalled || gMachine.Pt.xControlledByLine){
		TEST_DONE;
	}
	strcpy(txTest, "test_NoVacConsentOffStoppedMediaHeatBelowPH");
	switch (iTestState)
	{
		case 0://to zero
			strcpy(txStateDesc, "Startup");
			gSimMachine.Commands.xToZero = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;
		
		case 1://to auto, wait for cap
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;
		
		case 2://start and media order
			strcpy(txStateDesc, "Update parameters and start media");
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			gSimMachine.Commands.Media.rMediaThickness = gBlock[1].parameters.Motor.rMinSafePosition;//needs thickness setting to avoid going to xMinSafePos
			gMachine.parSw.Media.rThickness = gBlock[1].parameters.Motor.rMinSafePosition;//needs thickness setting to avoid going to xMinSafePos
			gMachine.parSw.rMarginPrint = gMachine.parSw.Safety.rMarginSafePrint;
			gMachine.commandsSw.xStart_GI = TRUE;
			nextState();
			break;
			
		case 3:
			TEST_BUSY_CONDITION(gBlock[1].parameters.Motor.rPrintPosition == 0.0);
			TEST_BUSY_CONDITION(gBlock[1].Status.rMotorPosition != gBlock[1].parameters.Motor.rPrintPosition);
			nextState();
			break;
		
		case 4:
			TEST_BUSY_CONDITION(!gBelt.states.xRuningBelt);
			gSimMachine.Commands.Media.xMediaPresent = TRUE;
			nextState();
			break;
		
		case 5://consent removal
			strcpy(txStateDesc, "Consent Removal");
			TEST_BUSY_CONDITION(!gThicknessCtrl.status.MediaPosition.xMediaInside);
			gMachine.In.xConsentL1Ok = FALSE;
			nextState();
			break;
			
		case 6:
			TEST_BUSY_CONDITION(gBlock[1].Status.rMotorPosition != gBlock[1].parameters.rPrePrintingPos);
			nextState();
			break;

		
		case 7://wait some time
			strcpy(txStateDesc, "Test if printheads have protected");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( endtime < TimeLast + 1000);//arbitrary time, less than 5min
			gMachine.In.xConsentL1Ok = TRUE;
			nextState();
			break;
		
		case 8://for t<5min, bars should go back down to print pos			
			TEST_BUSY_CONDITION(gBlock[1].Status.rMotorPosition == gBlock[1].parameters.rPrePrintingPos);
			nextState();
			break;
			
		case 9:
			TEST_BUSY_CONDITION(!gBelt.states.xRuningBelt);
			nextState();
			break;
		
		case 10://reset some changes for following tests
			TEST_BUSY_CONDITION((gBlock[1].Status.rMotorPosition)>(gBlock[1].parameters.Motor.rPrintPosition + 0.25));
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 500 );
			TEST_ASSERT_EQUAL_REAL(gBlock[1].parameters.Motor.rPrintPosition,gBlock[1].Status.rMotorPosition);
			gSimMachine.Commands.Media.xMediaPresent = FALSE;
			nextState();
			break;
		
		case 11:
			TEST_BUSY_CONDITION(gThicknessCtrl.status.MediaPosition.xMediaInside);
			gMachine.commandsSw.xStop_GI = TRUE;
			
			iTestState = 0;
			strcpy(txStateDesc, "test completed");
			
			TEST_DONE;
			break;
		
		default:
			break;
		
	}
}

_TEST test_NoVacKeepPausedStoppedMediaHeatBelowPH(void) //TEST 3: tests if, on a machine with no vacuum, with a pause input, PHs protect, then there is no pause removal in more than 5min, then pause off and machine should go to print + safety(3mm)
{
	//If the Test makes non sense, not execute it.
	if (!gMachine.Pt.xProtectPHWithStoppedMediaBended){
		TEST_DONE;
	}
	strcpy(txTest, "test_NoVacKeepPausedStoppedMediaHeatBelowPH");
	switch (iTestState)
	{
		case 0://to zero
			strcpy(txStateDesc, "Startup");
			gSimMachine.Commands.xToZero = TRUE;
			gMachine.Pt.tiTimeToRaiseBars = 30000;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;
		
		case 1://to auto, wait for cap
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;
		
		case 2://media parameters update
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			gSimMachine.Commands.Media.rMediaThickness = gBlock[1].parameters.Motor.rMinSafePosition;//needs thickness setting to avoid going to xMinSafePos
			gMachine.parSw.Media.rThickness = gBlock[1].parameters.Motor.rMinSafePosition;//needs thickness setting to avoid going to xMinSafePos
			gMachine.parSw.rMarginPrint = gMachine.parSw.Safety.rMarginSafePrint;//set margins to print so we don't have issues with thicknesses
			nextState();
			break;
			
		case 3://start and media order
			strcpy(txStateDesc, "Start and media present order");
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 3 );
			gMachine.commandsSw.xStart_GI = TRUE;
			gSimMachine.Commands.Media.xMediaPresent= TRUE;
			nextState();
			break;
		
		case 4://pause order
			strcpy(txStateDesc, "Pause order");
			TEST_BUSY_CONDITION(!gThicknessCtrl.status.MediaPosition.xMediaInside);
			gMachine.commandsSw.xPause_GI = TRUE;
			nextState();
			break;
		
		case 5:
			TEST_BUSY_CONDITION(!gMachine.St.AutoMode.xPause);
			nextState();
			break;
		
		case 6://wait some time
			strcpy(txStateDesc, "Waiting for 5min timer");
			TEST_BUSY_CONDITION(!gMachine.St.xProtectBendedWithPause);//arbitrary time, less than 5min
			nextState();
			break;
		
		case 7://for t>5min, bars should go back down with start order
			strcpy(txStateDesc, "Test assert: goes back to Print Position + rSafetyMarginToHeight");
			gMachine.commandsSw.xStart_GI = TRUE;
			nextState();
			break;
			
		case 8:
			TEST_BUSY_CONDITION(!gBelt.states.xRuningBelt);
			nextState();
			break;
			
		case 9:
			if((gMachine.parSw.Media.rThickness + gMachine.parSw.rMarginPrint + gThicknessCtrl.parameters.rSafetyMarginToHeight)==(gBlock[1].Status.Motor.rMotorAbsPosDesired)){
				TEST_BUSY_CONDITION((gMachine.parSw.Media.rThickness + gMachine.parSw.rMarginPrint + gThicknessCtrl.parameters.rSafetyMarginToHeight)!=gBlock[1].Status.rMotorPosition);
				TEST_ASSERT_EQUAL_REAL((gMachine.parSw.Media.rThickness + gMachine.parSw.rMarginPrint + gThicknessCtrl.parameters.rSafetyMarginToHeight),gBlock[1].Status.rMotorPosition);
			}
			nextState();
			break;
		
		case 10:
			strcpy(txStateDesc, "Machine goes back to print");
			TEST_BUSY_CONDITION(gBlock[1].Status.rMotorPosition > (gMachine.parSw.Media.rThickness + gMachine.parSw.rMarginPrint));//this line is for waiting for the rPrintPosition to recalculate, otherwise the value might be incorrect
			nextState();
			break;
		
		case 11://reset some changes for following tests
			strcpy(txStateDesc, "Returning to init. conditions");
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 3 );
			gSimMachine.Commands.Media.xMediaPresent = FALSE;
			nextState();
			break;
		
		case 12:
			TEST_BUSY_CONDITION(gThicknessCtrl.status.MediaPosition.xMediaInside);
			gMachine.commandsSw.xStop_GI = TRUE;
			
			iTestState = 0;
			strcpy(txStateDesc, "test completed");
			
			TEST_DONE;
			break;
		
		default:
			break;
		
	}
}

_TEST test_NoVacKeepConsentOffStoppedMediaHeatBelowPH(void) //TEST 4: tests if, on a machine with no vacuum, with a consent removal, PHs protect,there is no consent return in more than 5min, then consent return and machine should go back to print + safety(3mm).
{
	//If the Test makes non sense, not execute it.
	if (!gMachine.Pt.xProtectPHWithStoppedMediaBended){
		TEST_DONE;		
	}
	strcpy(txTest, "test_NoVacKeepConsentOffStoppedMediaHeatBelowPH");
	switch (iTestState)
	{
		case 0://to zero
			strcpy(txStateDesc, "Startup");
			gSimMachine.Commands.xToZero = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;
		
		case 1://to auto, wait for cap
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;
		
		case 2://media parameters update
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			gSimMachine.Commands.Media.rMediaThickness = gBlock[1].parameters.Motor.rMinSafePosition;//needs thickness setting to avoid going to xMinSafePos
			gMachine.parSw.Media.rThickness = gBlock[1].parameters.Motor.rMinSafePosition;//needs thickness setting to avoid going to xMinSafePos
			gMachine.parSw.rMarginPrint = gMachine.parSw.Safety.rMarginSafePrint;//set margins to print so we don't have issues with thicknesses
			nextState();
			break;
			
		case 3://start and media order
			strcpy(txStateDesc, "Start and media present order");
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 3 );
			gMachine.commandsSw.xStart_GI = TRUE;
			gSimMachine.Commands.Media.xMediaPresent = TRUE;
			nextState();
			break;
		
		case 4://pause order
			strcpy(txStateDesc, "Consent removal");
			TEST_BUSY_CONDITION(!gThicknessCtrl.status.MediaPosition.xMediaInside);
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInPrint);
			gMachine.In.xConsentL1Ok = FALSE;
			nextState();
			break;
			
		case 5:
			TEST_BUSY_CONDITION(gBlock[1].Status.rMotorPosition < gBlock[1].parameters.rPrePrintingPos);
			nextState();
			break;
		
		case 6://for t<5min, bars should go back down
			strcpy(txStateDesc, "Test assert: goes back to Print Position + rSafetyMarginToHeight");
			TEST_BUSY_CONDITION(!gMachine.St.Consent.xUpWithNoConsent);
			nextState();
			break;
			
		case 7:
			TEST_BUSY_CONDITION(gMachine.St.Position.xInPrint);
			TEST_BUSY_CONDITION(gMachine.St.Position.xGoingToCap);
			TEST_ASSERT(gMachine.St.Position.xInCap);
			nextState();
			break;
		
		case 8:
			gMachine.In.xConsentL1Ok = TRUE;
			TEST_BUSY_CONDITION(gMachine.St.Position.xInCap);
			TEST_BUSY_CONDITION(!gBelt.states.xRuningBelt);
			nextState();
			break;
			
		case 9:
			TEST_ASSERT_EQUAL_REAL((gMachine.parSw.Media.rThickness + gMachine.parSw.rMarginPrint + gThicknessCtrl.parameters.rSafetyMarginToHeight),gBlock[1].Status.rMotorPosition);//checks that it goes to "print + rSafetyMarginToHeight"
			nextState();
			break;
		
		case 10:
			strcpy(txStateDesc, "Test assert: goes back to Print Position");
			TEST_BUSY_CONDITION(gBlock[1].Status.rMotorPosition > (gMachine.parSw.Media.rThickness + gMachine.parSw.rMarginPrint + 2));//this line is for waiting for the rPrintPosition to recalculate, otherwise the value might be incorrect
			nextState();
			break;
		
		case 11://reset some changes for following tests
			strcpy(txStateDesc, "Returning to init. values");
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 3 );
			gSimMachine.Commands.Media.xMediaPresent = FALSE;
			nextState();
			break;
			
		case 12:
			TEST_BUSY_CONDITION(gThicknessCtrl.status.MediaPosition.xMediaInside);
			gMachine.commandsSw.xStop_GI = TRUE;
			
			iTestState = 0;
			strcpy(txStateDesc, "test completed");
			
			TEST_DONE;
			break;
		
		default:
			break;
	}
}

_TEST test_NoVacNoMediaNoConsent(void) //TEST 5:with no media inside remove consent, bars have to go to cap (>5min), return consent, bars have to go to print again
{
	//If the Test makes non sense, not execute it.
	if (gTransVacuum[1].Status.xInstalled || gMachine.Pt.xControlledByLine){
		TEST_DONE;		
	}
	strcpy(txTest, "test_NoVacNoMediaNoConsent");
	switch (iTestState)
	{
		case 0://to zero
			strcpy(txStateDesc, "Startup");
			gSimMachine.Commands.xToZero = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;
		
		case 1://to auto, wait for cap
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;
			
		case 2:
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			gSimMachine.Commands.Media.rMediaThickness = gBlock[1].parameters.Motor.rMinSafePosition;//needs thickness setting to avoid going to xMinSafePos
			gMachine.parSw.Media.rThickness = gBlock[1].parameters.Motor.rMinSafePosition;//needs thickness setting to avoid going to xMinSafePos
			gMachine.parSw.rMarginPrint = gMachine.parSw.Safety.rMarginSafePrint;//set margins to print so we don't have issues with thicknesses
			nextState();
			break;
			
		case 3://print position calculation
			strcpy(txStateDesc, "Start without media");
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 3 );
			gMachine.commandsSw.xStart_GI = TRUE;
			nextState();
			break;
			
		case 4:
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInPrint);
			gSimMachine.Commands.Media.xMediaPresent = TRUE;
			nextState();
			break;
			
		case 5:
			TEST_BUSY_CONDITION(gBlock[1].parameters.Motor.rPrintPosition == 0);
			gSimMachine.Commands.Media.xMediaPresent = FALSE;
			nextState();
			break;
		
		case 6://pause order
			strcpy(txStateDesc, "Consent removal");
			TEST_BUSY_CONDITION(gThicknessCtrl.status.MediaPosition.xMediaInside);
			gMachine.In.xConsentL1Ok = FALSE;
			nextState();
			break;

		
		case 7://for t>5min, bars should go back down
			strcpy(txStateDesc, "Test assert: goes back to Print Position + 3mm");
			TEST_BUSY_CONDITION(!gMachine.St.Consent.xUpWithNoConsent);
			nextState();
			break;
			
		case 8:
			TEST_BUSY_CONDITION(gMachine.St.Position.xInPrint);
			nextState();
			break;
			
		case 9:
			TEST_BUSY_CONDITION(gMachine.St.Position.xGoingToCap);
			TEST_ASSERT(gMachine.St.Position.xInCap);
			nextState();
			break;
		
		case 10:
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 3 );
			gMachine.In.xConsentL1Ok = TRUE;
			nextState();
			break;
			
		case 11:
			TEST_BUSY_CONDITION(gMachine.St.Position.xInCap);
			TEST_BUSY_CONDITION(!gBelt.states.xRuningBelt);
			TEST_ASSERT(gBlock[1].Status.rMotorPosition == gBlock[1].parameters.Motor.rPrintPosition);
			nextState();
			break;
		
		case 12://reset some changes for following tests
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 3 );
			gSimMachine.Commands.Media.xMediaPresent = FALSE;
			nextState();
			break;
			
		case 13:
			TEST_BUSY_CONDITION(gThicknessCtrl.status.MediaPosition.xMediaInside);
			gMachine.commandsSw.xStop_GI = TRUE;
			nextState();
			break;
			
		case 14:
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			
			iTestState = 0;
			
			//This 2 lines just for the last TestCase
			strcpy(txTest, "ConsentTests Finished!! Congrats!");
			strcpy(txStateDesc, "--");
			
			TEST_DONE;
			break;
		
		default:
			break;
		
	}
}

//---- machines with vacuum ----

_TEST test_HasVacNoMediaToPreprint(void) // (WRONG) TEST 6: In a machine with vacuum, the bars  must protect (preprint) if no media inside for over a specific period (1min) and when media starts entering again bars go back to print.; 
{
	//If the Test makes non sense, not execute it.
	if (!gTransVacuum[1].Status.xInstalled || gMachine.Pt.xControlledByLine){
		TEST_DONE;		
	}
	strcpy(txTest, "test_HasVacNoMediaToPreprint");
	switch (iTestState)
	{
		case 0://to zero
			strcpy(txStateDesc, "Startup");
			gSimMachine.Commands.xToZero = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;
		
		case 1://to auto, wait for cap
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;
			
		case 2:
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			gSimMachine.Commands.Media.rMediaThickness = gBlock[1].parameters.Motor.rMinSafePosition;//needs thickness setting to avoid going to xMinSafePos
			gMachine.parSw.Media.rThickness = gBlock[1].parameters.Motor.rMinSafePosition;//needs thickness setting to avoid going to xMinSafePos
			gMachine.parSw.rMarginPrint = gMachine.parSw.Safety.rMarginSafePrint;//set margins to print so we don't have issues with thicknesses
			nextState();
			break;
			
		case 3://recalculating print
			strcpy(txStateDesc, "Start to recalculate print");
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 3 );
			gMachine.commandsSw.xStart_GI = TRUE;
			nextState();
			break;
			
		case 4:
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInPrint);
			gSimMachine.Commands.Media.xMediaPresent = TRUE;
			nextState();
			break;
			
		case 5:
			TEST_BUSY_CONDITION(gBlock[1].parameters.Motor.rPrintPosition == 0);
			gSimMachine.Commands.Media.xMediaPresent = FALSE; //these last three conditions are for calculating a print position, otherwise, it will be 0.0 and the machine will go to min. safe position
			gMachine.commandsSw.xStop_GI = TRUE;
			nextState();
			break;
		
		case 6://starting again with no media
			strcpy(txStateDesc, "Actual start");
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			gMachine.commandsSw.xStart_GI = TRUE;
			nextState();
			break;

		case 7://wait some time
			strcpy(txStateDesc, "Waiting for timer");
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInPrint);
			nextState();
			break;
		
		case 8:
			endtime = clock_ms();
			TEST_BUSY_CONDITION(endtime < TimeLast + 1000);//arbitrary time, less than 5min
			nextState();
			break;
		
		case 9://bars should be in preprint
			strcpy(txStateDesc, "Test assert: goes to preprint");
			TEST_BUSY_CONDITION(gBlock[1].Status.rMotorPosition != gBlock[1].parameters.rPrePrintingPos);
			nextState();
			break;
			
		case 10:
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 5 );
			TEST_ASSERT(gBlock[1].Status.rMotorPosition == gBlock[1].parameters.rPrePrintingPos);
			nextState();
			break;
		
		case 11://media inside order
			strcpy(txStateDesc, "Giving media order");
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 3 );
			gSimMachine.Commands.Media.xMediaPresent = TRUE;
			nextState();
			break;
		
		case 12://reset some changes for following tests
			TEST_BUSY_CONDITION(gBlock[1].Status.rMotorPosition > gBlock[1].parameters.Motor.rPrintPosition);
			TEST_ASSERT(gBlock[1].Status.rMotorPosition == gBlock[1].parameters.Motor.rPrintPosition);
			nextState();
			break;
			
		case 13:
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 3 );
			gSimMachine.Commands.Media.xMediaPresent = FALSE;
			gMachine.commandsSw.xStop_GI = TRUE;
			
			iTestState = 0;
			strcpy(txStateDesc, "test completed");
			
			TEST_DONE;
			break;
		
		default:
			break;
		
	}
}

_TEST test_HasVacNoMediaPause(void) //TEST 7: In a machine with vacuum, the bars  must protect (preprint) if no media inside and pause is pressed, and vacuum should stop; 
{
	//If the Test makes non sense, not execute it.
	if (!gTransVacuum[1].Status.xInstalled || gMachine.Pt.xControlledByLine){
		TEST_DONE;		
	}
	strcpy(txTest, "test_HasVacNoMediaPause");
	switch (iTestState)
	{
		case 0://to zero
			strcpy(txStateDesc, "Startup");
			gSimMachine.Commands.xToZero = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;
		
		case 1://to auto, wait for cap
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;
			
		case 2:
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			gSimMachine.Commands.Media.rMediaThickness = gBlock[1].parameters.Motor.rMinSafePosition;//needs thickness setting to avoid going to xMinSafePos
			gMachine.parSw.Media.rThickness = gBlock[1].parameters.Motor.rMinSafePosition;//needs thickness setting to avoid going to xMinSafePos
			gMachine.parSw.rMarginPrint = gMachine.parSw.Safety.rMarginSafePrint;//set margins to print so we don't have issues with thicknesses
			nextState();
			break;
			
		case 3://recalculating print
			strcpy(txStateDesc, "Start to recalculate print");
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 3 );
			gMachine.commandsSw.xStart_GI = TRUE;
			nextState();
			break;
			
		case 4:
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInPrint);
			gSimMachine.Commands.Media.xMediaPresent = TRUE;
			nextState();
			break;
			
		case 5:
			TEST_BUSY_CONDITION(gBlock[1].parameters.Motor.rPrintPosition == 0);
			gSimMachine.Commands.Media.xMediaPresent = FALSE; //these last three conditions are for calculating a print position, otherwise, it will be 0.0 and the machine will go to min. safe position
			nextState();
			break;
			
		case 6:
			TEST_BUSY_CONDITION(gThicknessCtrl.status.MediaPosition.xMediaInside);
			gMachine.commandsSw.xStop_GI = TRUE;
			nextState();
			break;
		
		case 7://starting again with no media
			strcpy(txStateDesc, "Actual start");
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			gMachine.commandsSw.xStart_GI = TRUE;
			nextState();
			break;

		case 8://wait some time
			strcpy(txStateDesc, "Waiting for timer");
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInPrint);
			TEST_BUSY_CONDITION(!gBelt.states.xRuningBelt);
			nextState();
			break;
		
		case 9:
			endtime = clock_ms();
			TEST_BUSY_CONDITION(endtime < TimeLast + 1000);//arbitrary time, less than 20s
			gMachine.commandsSw.xPause_GI = TRUE;
			nextState();
			break;
		
		case 10://bars should be in preprint
			strcpy(txStateDesc, "Test assert: goes to preprint");
			TEST_BUSY_CONDITION(gMachine.St.exec.slow < exTimesPreSlow + 4 );
			TEST_BUSY_CONDITION(gBlock[1].Status.rMotorPosition != gBlock[1].parameters.rPrePrintingPos);
			TEST_ASSERT(!gTransVacuum[1].Status.Blower.xMoving);
			nextState();
			break;
		
		case 11://media inside order
			strcpy(txStateDesc, "Test blowers after restart");
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 3 );
			gMachine.commandsSw.xStart_GI = TRUE;
			nextState();
			break;
		
		case 12://reset some changes for following tests and test assert
			TEST_BUSY_CONDITION(!gBelt.states.xRuningBelt);
			TEST_ASSERT(gTransVacuum[1].Status.Blower.rDutyCycle > 0.0);
			
			gSimMachine.Commands.Media.xMediaPresent = FALSE;
			gMachine.commandsSw.xStop_GI = TRUE;
			
			iTestState = 0;
			strcpy(txStateDesc, "test completed");
			
			TEST_DONE;
			break;
		
		default:
			break;
		
	}
}

_TEST test_HasVacWithMediaPause(void) //TEST 8: In a machine with vacuum, the bars  must protect (preprint) if media inside and pause is pressed, and vacuum must persist; 
{
	//If the Test makes non sense, not execute it.
	if (!gTransVacuum[1].Status.xInstalled || gMachine.Pt.xControlledByLine){
		TEST_DONE;		
	}
	strcpy(txTest, "test_HasVacWithMediaPause");
	switch (iTestState)
	{
		case 0://to zero
			strcpy(txStateDesc, "Startup");
			gSimMachine.Commands.xToZero = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;
		
		case 1://to auto, wait for cap
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;
			
		case 2:
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			gSimMachine.Commands.Media.rMediaThickness = gBlock[1].parameters.Motor.rMinSafePosition;//needs thickness setting to avoid going to xMinSafePos
			gMachine.parSw.Media.rThickness = gBlock[1].parameters.Motor.rMinSafePosition;//needs thickness setting to avoid going to xMinSafePos
			gMachine.parSw.rMarginPrint = gMachine.parSw.Safety.rMarginSafePrint;//set margins to print so we don't have issues with thicknesses
			nextState();
			break;
			
		case 3://recalculating print
			strcpy(txStateDesc, "Start and let recalculate print");
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 3 );
			gMachine.commandsSw.xStart_GI = TRUE;
			nextState();
			break;
			
		case 4:
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInPrint);
			gSimMachine.Commands.Media.xMediaPresent = TRUE;
			nextState();
			break;
			
		case 5:
			TEST_BUSY_CONDITION(!gThicknessCtrl.status.MediaPosition.xMediaInside);
			gMachine.commandsSw.xPause_GI = TRUE;
			nextState();
			break;
		
		case 6:
			TEST_BUSY_CONDITION(!gMachine.AutoCmd.xToSafePosition);//tonDelatToSafePos
			nextState();
			break;
		
		case 7://bars should be in preprint
			strcpy(txStateDesc, "Test assert: goes to preprint");
			TEST_BUSY_CONDITION(gBlock[1].Status.rMotorPosition != gBlock[1].parameters.rPrePrintingPos);
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 5 );
			TEST_ASSERT(gTransVacuum[1].Status.Blower.rDutyCycle > 0);
			nextState();
			break;
		
		case 8://media inside order
			strcpy(txStateDesc, "Test blowers after restart");
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 3 );
			gMachine.commandsSw.xStart_GI = TRUE;
			nextState();
			break;
			
		case 9:
			TEST_BUSY_CONDITION(gBlock[1].Status.rMotorPosition > gBlock[1].parameters.Motor.rPrintPosition);
			nextState();
			break;
		
		case 10://reset some changes for following tests and test assert
			TEST_ASSERT(gTransVacuum[1].Status.Blower.rDutyCycle > 0);
			
			gSimMachine.Commands.Media.xMediaPresent = FALSE;
			gMachine.commandsSw.xStop_GI = TRUE;
			
			iTestState = 0;
			strcpy(txStateDesc, "test completed");
			
			TEST_DONE;
			break;
		
		default:
			break;
		
	}
}

_TEST test_HasVacWithMediaConsentRemoval(void) //TEST 9: In a machine with vacuum, the bars  must protect (preprint) if media inside and consent is removed, and vacuum must persist; 
{
	//If the Test makes non sense, not execute it.
	if (!gTransVacuum[1].Status.xInstalled || gMachine.Pt.xControlledByLine){
		TEST_DONE;		
	}
	strcpy(txTest, "test_HasVacWithMediaConsentRemoval");
	switch (iTestState)
	{
		case 0://to zero
			strcpy(txStateDesc, "Startup");
			gSimMachine.Commands.xToZero = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;
		
		case 1://to auto, wait for cap
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;
			
		case 2:
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			gSimMachine.Commands.Media.rMediaThickness = gBlock[1].parameters.Motor.rMinSafePosition;//needs thickness setting to avoid going to xMinSafePos
			gMachine.parSw.Media.rThickness = gBlock[1].parameters.Motor.rMinSafePosition;//needs thickness setting to avoid going to xMinSafePos
			gMachine.parSw.rMarginPrint = gMachine.parSw.Safety.rMarginSafePrint;//set margins to print so we don't have issues with thicknesses
			nextState();
			break;
			
		case 3://recalculating print
			strcpy(txStateDesc, "Start to recalculate print");
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 3 );
			gMachine.commandsSw.xStart_GI = TRUE;
			nextState();
			break;
			
		case 4:
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInPrint);
			gSimMachine.Commands.Media.xMediaPresent = TRUE;
			nextState();
			break;
			
		case 5:
			TEST_BUSY_CONDITION(!gThicknessCtrl.status.MediaPosition.xMediaInside);
			gMachine.In.xConsentL1Ok = FALSE;
			nextState();
			break;
		
		case 6:
			TEST_BUSY_CONDITION(!gMachine.AutoCmd.xToSafePosition);//tonDelatToSafePos
			nextState();
			break;
		
		case 7://bars should be in preprint
			strcpy(txStateDesc, "Test assert: goes to preprint");
			TEST_BUSY_CONDITION(gBlock[1].Status.rMotorPosition != gBlock[1].parameters.rPrePrintingPos);
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 5 );
			TEST_ASSERT(gTransVacuum[1].Status.Blower.rDutyCycle > 0);
			nextState();
			break;
		
		case 8://media inside order
			strcpy(txStateDesc, "Testing if blowers turn on");
			endtime = clock_ms();			
			TEST_BUSY_CONDITION(endtime < TimeLast + 1000) //arbitrary time, less than 5m
			gMachine.In.xConsentL1Ok = TRUE;
			nextState();
			break;
			
		case 9:
			TEST_BUSY_CONDITION(gBlock[1].Status.rMotorPosition > gBlock[1].parameters.Motor.rPrintPosition);
			nextState();
			break;
		
		case 10://reset some changes for following tests and test assert
			TEST_ASSERT(gTransVacuum[1].Status.Blower.rDutyCycle > 0);
			
			gSimMachine.Commands.Media.xMediaPresent = FALSE;
			gMachine.commandsSw.xStop_GI = TRUE;
				
			iTestState = 0;
			strcpy(txStateDesc, "test completed");
				
			TEST_DONE;
			break;
		
		default:
			break;
		
	}
}

_TEST test_HasVacWithMediaKeepConsentOff(void) //TEST 10: In a machine with vacuum, the bars  must protect (preprint and cap over 5min) if media inside and consent is removed, and vacuum must persist; 
{
	//If the Test makes non sense, not execute it.
	if (!gTransVacuum[1].Status.xInstalled || gMachine.Pt.xControlledByLine){
		TEST_DONE;		
	}
	strcpy(txTest, "test_HasVacWithMediaKeepConsentOff");
	switch (iTestState)
	{
		case 0://to zero
			strcpy(txStateDesc, "Startup");
			gSimMachine.Commands.xToZero = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;
		
		case 1://to auto, wait for cap
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;
			
		case 2:
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			gSimMachine.Commands.Media.rMediaThickness = gBlock[1].parameters.Motor.rMinSafePosition;//needs thickness setting to avoid going to xMinSafePos
			gMachine.parSw.Media.rThickness = gBlock[1].parameters.Motor.rMinSafePosition;//needs thickness setting to avoid going to xMinSafePos
			gMachine.parSw.rMarginPrint = gMachine.parSw.Safety.rMarginSafePrint;//set margins to print so we don't have issues with thicknesses
			nextState();
			break;
			
		case 3://recalculating print
			strcpy(txStateDesc, "Start and let recalculate print");
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 3 );
			gMachine.commandsSw.xStart_GI = TRUE;
			nextState();
			break;
			
		case 4:
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInPrint);
			gSimMachine.Commands.Media.xMediaPresent = TRUE;
			gMachine.In.xConsentL1Ok = FALSE;
			nextState();
			break;
		
		case 5:
			TEST_BUSY_CONDITION(!gThicknessCtrl.status.MediaPosition.xMediaInside);
			TEST_BUSY_CONDITION(!gMachine.AutoCmd.xToSafePosition);//tonDelatToSafePos
			nextState();
			break;
		
		case 6:
			TEST_BUSY_CONDITION(!gMachine.St.Consent.xUpWithNoConsent);
			nextState();
			break;
		
		case 7://bars should be in preprint
			strcpy(txStateDesc, "Test assert: goes to preprint and blowers off");
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			TEST_ASSERT(gTransVacuum[1].Status.Blower.rDutyCycle > 0);
			nextState();
			break;
		
		case 8://media inside order
			strcpy(txStateDesc, "Give consent back and test for blowers");
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 3 );
			gMachine.In.xConsentL1Ok = TRUE;
			nextState();
			break;
			
		case 9:
			TEST_BUSY_CONDITION(gBlock[1].Status.rMotorPosition > gBlock[1].parameters.Motor.rPrintPosition);
			nextState();
			break;
		
		case 10://reset some changes for following tests and test assert
			TEST_ASSERT(gTransVacuum[1].Status.Blower.rDutyCycle > 0);
			
			gSimMachine.Commands.Media.xMediaPresent = FALSE;
			gMachine.commandsSw.xStop_GI = TRUE;
				
			iTestState = 0;
			strcpy(txStateDesc, "test completed");
				
			TEST_DONE;
			break;
		
		default:
			break;
		
	}
}

_TEST test_HasVacNoMediaKeepConsentOff(void) //TEST 11: In a machine with vacuum, the bars  must protect (preprint and cap over 5min) if media inside and consent is removed, and vacuum must persist; 
{
	//If the Test makes non sense, not execute it.
	if (!gTransVacuum[1].Status.xInstalled || gMachine.Pt.xControlledByLine){
		TEST_DONE;		
	}
	strcpy(txTest, "test_HasVacNoMediaKeepConsentOff");
	switch (iTestState)
	{
		case 0://to zero
			strcpy(txStateDesc, "Startup");
			gSimMachine.Commands.xToZero = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;
		
		case 1://to auto, wait for cap
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;
		
		case 2:
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			gSimMachine.Commands.Media.rMediaThickness = gBlock[1].parameters.Motor.rMinSafePosition;//needs thickness setting to avoid going to xMinSafePos
			gMachine.parSw.Media.rThickness = gBlock[1].parameters.Motor.rMinSafePosition;//needs thickness setting to avoid going to xMinSafePos
			gMachine.parSw.rMarginPrint = gMachine.parSw.Safety.rMarginSafePrint;//set margins to print so we don't have issues with thicknesses
			nextState();
			break;
			
		case 3://recalculating print
			strcpy(txStateDesc, "Start to recalculate print");
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 3 );
			gMachine.commandsSw.xStart_GI = TRUE;
			nextState();
			break;
			
		case 4:
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInPrint);
			gSimMachine.Commands.Media.xMediaPresent = TRUE;
			nextState();
			break;
		
		case 5:
			TEST_BUSY_CONDITION(gBlock[1].parameters.Motor.rPrintPosition == 0);
			gSimMachine.Commands.Media.xMediaPresent = FALSE; //these last three conditions are for calculating a print position, otherwise, it will be 0.0 and the machine will go to min. safe position
			nextState();
			break;
		
		case 6:
			TEST_BUSY_CONDITION(gThicknessCtrl.status.MediaPosition.xMediaInside);
			gMachine.commandsSw.xStop_GI = TRUE;
			nextState();
			break;
		
		case 7://starting again with no media
			strcpy(txStateDesc, "Actual start");
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			gMachine.commandsSw.xStart_GI = TRUE;
			nextState();
			break;

		case 8://wait some time
			strcpy(txStateDesc, "Waiting for timer");
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInPrint);
			nextState();
			break;
		
		case 9:
			endtime = clock_ms();
			TEST_BUSY_CONDITION(endtime < TimeLast + 1000);//arbitrary time, less than 20s
			gMachine.In.xConsentL1Ok = FALSE;
			gMachine.In.xConsentL2Ok = FALSE;
			nextState();
			break;
		
		case 10://bars should be in preprint
			strcpy(txStateDesc, "Test assert: goes to preprint");
			TEST_BUSY_CONDITION(!gMachine.St.Consent.xUpWithNoConsent);
			nextState();
			break;
			
		case 11:
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 3 );
			TEST_ASSERT(!gTransVacuum[1].Status.Blower.xMoving);
			nextState();
			break;
		
		case 12://media inside order
			strcpy(txStateDesc, "Giving media order");
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 3 );
			gMachine.In.xConsentL1Ok = TRUE;
			nextState();
			break;
		
		case 13://reset some changes for following tests and test assert
			TEST_BUSY_CONDITION(!gBelt.states.xRuningBelt);
			TEST_ASSERT(gTransVacuum[1].Status.Blower.rDutyCycle > 0);
			
			gSimMachine.Commands.Media.xMediaPresent = FALSE;
			gMachine.commandsSw.xStop_GI = TRUE;
			
			
			iTestState = 0;
			
			//This 2 lines just for the last TestCase
			strcpy(txTest, "ConsentTests Finished!! Congrats!");
			strcpy(txStateDesc, "--");
			
			TEST_DONE;
			break;
		
		default:
			break;
		
	}
}

_TEST test_HasVacWithMediaMediaStops(void)//TEST 12: if media stops comming, the bars should stay in PrintPosition for a minute to avoid them going up and down repetedly
{ 
	//If the Test makes non sense, not execute it.
	if (!gTransVacuum[1].Status.xInstalled || gMachine.Pt.xControlledByLine){
		TEST_DONE;		
	}
	strcpy(txTest, "test_HasVacWithMediaMediaStops");
	switch (iTestState)
	{
		case 0://to zero
			strcpy(txStateDesc, "Startup");
			gSimMachine.Commands.xToZero = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;
		
		case 1://to auto, wait for cap
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;
		
		case 2:
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			gSimMachine.Commands.Media.rMediaThickness = gBlock[1].parameters.Motor.rMinSafePosition;//needs thickness setting to avoid going to xMinSafePos
			gMachine.parSw.Media.rThickness = gBlock[1].parameters.Motor.rMinSafePosition;//needs thickness setting to avoid going to xMinSafePos
			gMachine.parSw.rMarginPrint = gMachine.parSw.Safety.rMarginSafePrint;//set margins to print so we don't have issues with thicknesses
			nextState();
			break;
			
		case 3://recalculating print
			strcpy(txStateDesc, "Start to recalculate print");
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 3 );
			gMachine.commandsSw.xStart_GI = TRUE;
			nextState();
			break;
			
		case 4:
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInPrint);
			gSimMachine.Commands.Media.xMediaPresent = TRUE;
			nextState();
			break;
		
		case 5:
			TEST_BUSY_CONDITION(!gThicknessCtrl.status.MediaPosition.xMediaInside);
			gSimMachine.Commands.Media.xMediaPresent = FALSE;
			nextState();
			break;
		
		case 6:
			endtime = clock_ms();
			TEST_BUSY_CONDITION(endtime > TimeLast + 50000);
			TEST_BUSY_CONDITION(gThicknessCtrl.status.MediaPosition.xMediaInside); //timer under 1min
			nextState();
			break;
		
		case 7://bars should be in preprint
			strcpy(txStateDesc, "Test assert: stays in print");
			TEST_ASSERT(gBlock[1].Status.rMotorPosition == gBlock[1].parameters.Motor.rPrintPosition);
			nextState();
			break;
		
		case 8://media inside order
			strcpy(txStateDesc, "Giving media order");
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 3 );
			gSimMachine.Commands.Media.xMediaPresent = TRUE;
			nextState();
			break;
		
		case 9://reset some changes for following tests and test assert
			TEST_BUSY_CONDITION(!gThicknessCtrl.status.MediaPosition.xMediaInside); 
			TEST_ASSERT(gBlock[1].Status.rMotorPosition == gBlock[1].parameters.Motor.rPrintPosition);
			
			gSimMachine.Commands.Media.xMediaPresent = FALSE;
			gMachine.commandsSw.xStop_GI = TRUE;
				
			iTestState = 0;
			
			//This 2 lines just for the last TestCase
			strcpy(txTest, "ConsentTests Finished!! Congrats!");
			strcpy(txStateDesc, "--");
				
			TEST_DONE;
			break;
		
		default:
			break;
		
	}
}

//-------- NOZOMI 2 --------

_TEST test_Noz2NoMediaToPreprint(void) // (WRONG) TEST 13: On NOZOMI2 the bars  must protect (preprint) if no media inside for over a specific period (1min) and when media starts entering again bars go back to print.; 
{
	//If the Test makes non sense, not execute it.
	if (TRUE){//(!(gTransVacuum[1].Status.xInstalled && gMachine.Pt.xControlledByLine)){ //for now, NOZ2 is the only machine that acomplishes the conditions
		TEST_DONE;
	}
	strcpy(txTest, "test_Noz2NoMediaToPreprint");
	switch (iTestState)
	{
		case 0://to zero
			strcpy(txStateDesc, "Startup");
			gSimMachine.Commands.xToZero = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;
		
		case 1://to auto, wait for cap
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;
			
		case 2:
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			gFeeder.ParSw.xEnabled=TRUE;
			gPrimer.ParSw.xEnabled=TRUE;
			gDryerAnc.ParSw.xEnabled=TRUE;
			gStacker.ParSw.xEnabled=TRUE;
			gSimMachine.Commands.Media.rMediaThickness = gBlock[1].parameters.Motor.rMinSafePosition;//needs thickness setting to avoid going to xMinSafePos
			gMachine.parSw.Media.rThickness = gBlock[1].parameters.Motor.rMinSafePosition;//needs thickness setting to avoid going to xMinSafePos
			gMachine.parSw.rMarginPrint = gMachine.parSw.Safety.rMarginSafePrint;//set margins to print so we don't have issues with thicknesses
			gSimMachine.Commands.Media.xMediaIfFeederFeeding = FALSE;
			nextState();
			break;
			
		case 3://recalculating print
			strcpy(txStateDesc, "Start to recalculate print");
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 3 );
			gLine.Commands.Print = TRUE;
			nextState();
			break;
			
		case 4:
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInPrint);
			TEST_BUSY_CONDITION(gLine.Status != LINE_PRINTING);
			gSimMachine.Commands.Media.xMediaPresent = TRUE;
			nextState();
			break;
			
		case 5:
			TEST_BUSY_CONDITION(gBlock[1].parameters.Motor.rPrintPosition == 0);
			gSimMachine.Commands.Media.xMediaPresent = FALSE; //these last three conditions are for calculating a print position, otherwise, it will be 0.0 and the machine will go to min. safe position
			gLine.Commands.Stop = TRUE;
			nextState();
			break;
		
		case 6://starting again with no media
			strcpy(txStateDesc, "Actual start");
			TEST_BUSY_CONDITION(gLine.Status != LINE_CONTROLLED_STOP);
			nextState();
			break;
		
		case 7:
			TEST_BUSY_CONDITION(gLine.Status != LINE_IDLE);
			gLine.Commands.Print = TRUE;
			nextState();
			break;

		case 8://wait some time
			strcpy(txStateDesc, "Waiting for timer");
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInPrint);
			nextState();
			break;
		
		case 9:
			endtime = clock_ms();
			TEST_BUSY_CONDITION(endtime < TimeLast + 1000);//arbitrary time, less than 5min
			gFeeder.Commands.xStop = TRUE;
			nextState();
			break;
		
		case 10://bars should be in preprint
			strcpy(txStateDesc, "Test assert: goes to preprint");
			TEST_BUSY_CONDITION(gBlock[1].Status.rMotorPosition != gBlock[1].parameters.rPrePrintingPos);
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 5 );
			TEST_ASSERT(gBlock[1].Status.rMotorPosition == gBlock[1].parameters.rPrePrintingPos);
			nextState();
			break;
		
		case 11://media inside order
			strcpy(txStateDesc, "Giving media order");
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 3 );
			gSimMachine.Commands.Media.xMediaPresent = TRUE;
			nextState();
			break;
		
		case 12://reset some changes for following tests
			strcpy(txStateDesc, "Returning to init. conditions");
			TEST_BUSY_CONDITION(gBlock[1].Status.rMotorPosition > gBlock[1].parameters.Motor.rPrintPosition);
			TEST_ASSERT(gBlock[1].Status.rMotorPosition == gBlock[1].parameters.Motor.rPrintPosition);
			
			gSimMachine.Commands.Media.xMediaPresent = FALSE;
			gLine.Commands.Stop = TRUE;
			gSimMachine.Commands.Media.xMediaIfFeederFeeding = TRUE;
			
			iTestState = 0;
			strcpy(txStateDesc, "test completed");
			
			TEST_DONE;
			break;
		
		default:
			break;
		
	}
}

_TEST test_Noz2HasVacWithMediaMediaStops(void)//TEST 14: if media stops comming on NOZOMI2, the bars should stay in PrintPosition for a minute to avoid them going up and down repetedly
{ 
	//If the Test makes non sense, not execute it.
	if (TRUE){//(!(gTransVacuum[1].Status.xInstalled && gMachine.Pt.xControlledByLine)){
		TEST_DONE;		
	}
	strcpy(txTest, "test_Noz2HasVacWithMediaMediaStops");
	switch (iTestState)
	{
		case 0://to zero
			strcpy(txStateDesc, "Startup");
			gSimMachine.Commands.xToZero = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;
		
		case 1://to auto, wait for cap, preparation of some variables
			TEST_BUSY_CONDITION(!gMachine.St.Mode.xZero);
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;
			
		case 2:
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInCap);
			gSimMachine.Commands.Media.xMediaIfFeederFeeding = FALSE;
			gSimMachine.Commands.Media.rMediaThickness = gBlock[1].parameters.Motor.rMinSafePosition;//needs thickness setting to avoid going to xMinSafePos
			gMachine.parSw.Media.rThickness = gBlock[1].parameters.Motor.rMinSafePosition;//needs thickness setting to avoid going to xMinSafePos
			gMachine.parSw.rMarginPrint = gMachine.parSw.Safety.rMarginSafePrint;//set margins to print so we don't have issues with thicknesses
			nextState();
			break;
			
		case 3://recalculating print
			strcpy(txStateDesc, "Start to recalculate print");
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 3 );
			gLine.Commands.Print = TRUE;
			nextState();
			break;
			
		case 4:
			TEST_BUSY_CONDITION(!gMachine.St.Position.xInPrint);
			TEST_BUSY_CONDITION(gLine.Status != LINE_PRINTING);
			gSimMachine.Commands.Media.xMediaPresent = TRUE;
			nextState();
			break;
		
		case 5:
			TEST_BUSY_CONDITION(!gThicknessCtrl.status.MediaPosition.xMediaInside);
			nextState();
			break;
		
		case 6:
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 3 );
			gSimMachine.Commands.Media.xMediaPresent = FALSE;
			nextState();
			break;
		
		case 7:
			endtime = clock_ms();
			TEST_BUSY_CONDITION(endtime > TimeLast + 50000);
			nextState();
			break;
		
		case 8://bars should be in preprint
			strcpy(txStateDesc, "Test assert: stays in print");
			TEST_BUSY_CONDITION(gThicknessCtrl.status.MediaPosition.xMediaInside); //timer under 1min
			TEST_ASSERT(gBlock[1].Status.rMotorPosition == gBlock[1].parameters.Motor.rPrintPosition);
			nextState();
			break;
		
		case 9://media inside order
			strcpy(txStateDesc, "Giving media order");
			TEST_BUSY_CONDITION(gMachine.St.exec.fast < exTimesPreFast + 3 );
			gSimMachine.Commands.Media.xMediaPresent = TRUE;
			nextState();
			break;
		
		case 10://reset some changes for following tests and test assert
			strcpy(txStateDesc, "Returning to init.conditions");
			TEST_BUSY_CONDITION(!gThicknessCtrl.status.MediaPosition.xMediaInside); 
			TEST_ASSERT(gBlock[1].Status.rMotorPosition == gBlock[1].parameters.Motor.rPrintPosition);
			
			gSimMachine.Commands.Media.xMediaPresent = FALSE;
			nextState();
			break;
			
		case 11: 
			TEST_BUSY_CONDITION(gThicknessCtrl.status.MediaPosition.xMediaInside);
			gLine.Commands.Stop = TRUE;
			gSimMachine.Commands.Media.xMediaIfFeederFeeding = TRUE;
				
			iTestState = 0;
			
			//This 2 lines just for the last TestCase
			strcpy(txTest, "ConsentTests Finished!! Congrats!");
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
LastUpdated: 2023-04-26 08:42:15Z
By B+R UnitTest Helper Version: 2.0.1.59
*/
UNITTEST_FIXTURES(fixtures)
{
	new_TestFixture("test_BeltStopWithConsentInDTP_LinesInStop", test_BeltStopWithConsentInDTP_LinesInStop), 
	new_TestFixture("test_BeltStopWithoutConsentInDTP_LinesInByPass", test_BeltStopWithoutConsentInDTP_LinesInByPass), 
	new_TestFixture("test_BeltStopWithConsentInDTP_L1InByPass_L1Stopped", test_BeltStopWithConsentInDTP_L1InByPass_L1Stopped), 
	new_TestFixture("test_BeltStopWithConsentInDTP_L1InByPass_L2Stopped", test_BeltStopWithConsentInDTP_L1InByPass_L2Stopped), 
	new_TestFixture("test_BeltStopWithoutConsentInDTP_LinesProduction", test_BeltStopWithoutConsentInDTP_LinesProduction), 
	new_TestFixture("test_ConsentInDTP_Lab", test_ConsentInDTP_Lab), 
	new_TestFixture("test_ConsentInDTP_Manual", test_ConsentInDTP_Manual), 
	new_TestFixture("test_NoConsentInLab", test_NoConsentInLab), 
	new_TestFixture("test_RiseBarsWithNoConsent", test_RiseBarsWithNoConsent), 
	new_TestFixture("test_NoVacPausedStoppedMediaHeatBelowPH", test_NoVacPausedStoppedMediaHeatBelowPH), 
	new_TestFixture("test_NoVacConsentOffStoppedMediaHeatBelowPH", test_NoVacConsentOffStoppedMediaHeatBelowPH), 
	new_TestFixture("test_NoVacKeepPausedStoppedMediaHeatBelowPH", test_NoVacKeepPausedStoppedMediaHeatBelowPH), 
	new_TestFixture("test_NoVacKeepConsentOffStoppedMediaHeatBelowPH", test_NoVacKeepConsentOffStoppedMediaHeatBelowPH), 
	new_TestFixture("test_NoVacNoMediaNoConsent", test_NoVacNoMediaNoConsent), 
	new_TestFixture("test_HasVacNoMediaToPreprint", test_HasVacNoMediaToPreprint), 
	new_TestFixture("test_HasVacNoMediaPause", test_HasVacNoMediaPause), 
	new_TestFixture("test_HasVacWithMediaPause", test_HasVacWithMediaPause), 
	new_TestFixture("test_HasVacWithMediaConsentRemoval", test_HasVacWithMediaConsentRemoval), 
	new_TestFixture("test_HasVacWithMediaKeepConsentOff", test_HasVacWithMediaKeepConsentOff), 
	new_TestFixture("test_HasVacNoMediaKeepConsentOff", test_HasVacNoMediaKeepConsentOff), 
	new_TestFixture("test_HasVacWithMediaMediaStops", test_HasVacWithMediaMediaStops), 
	new_TestFixture("test_Noz2NoMediaToPreprint", test_Noz2NoMediaToPreprint), 
	new_TestFixture("test_Noz2HasVacWithMediaMediaStops", test_Noz2HasVacWithMediaMediaStops), 
};

UNITTEST_CALLER_COMPLETE_EXPLICIT(ConsentTests, "ConsentTests", 0, 0, fixtures, 0, 0, 0);

