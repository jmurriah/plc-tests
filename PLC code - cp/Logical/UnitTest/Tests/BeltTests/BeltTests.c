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
	exTimesPreFast = gMachine.St.exec.fast;
	exTimesPreSlow = gMachine.St.exec.slow;
	iTestState++;
	TimeLast = clock_ms();
	diff_t = diff_t;
	stringAux[120] = stringAux[120];
}

_TEST test_ResetMountedTile(void)
{
	strcpy(txTest, "test_ResetMountedTile");
	
	// Check txText <> than assigned, so just once
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gFeeder.ParSw.xEnabled=FALSE;
			gPrimer.ParSw.xEnabled=FALSE;
			gSarm.ParSw.xEnabled = FALSE;
			gDryerAnc.ParSw.xEnabled=FALSE;
			gStacker.ParSw.xEnabled=FALSE;
			gOverVarnish.ParSw.xEnabled = FALSE;
			gMachine.parSw.Media.rThickness = 12.0;	//10mm
			gMachine.parSw.rMarginPrint = 2.0;		//2mm >> 2mm is bars position
			gMachine.In.xConsentL1Ok = TRUE;
			gMachine.In.Buttons.xReset = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			gMachine.parSw.Media.rLength = 1600;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Going to Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			gMachine.In.Buttons.xReset = FALSE;
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Going to Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 10 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( !gBlock[1].Status.Position.xGoingToCap && !gBlock[1].Status.Position.xInCap );
			nextState();
			break;

		case 4:
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 10 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( (gPhotoCells.status.xCheckingAlignment || !gPhotoCells.status.xInPosition) && gPhotoCells.status.xInstalled ); //We'll wait xx scan cycles
			gMachine.commandsSw.xReset_GI = TRUE;
			nextState();
			break;

		case 5:
			strcpy(txStateDesc, "Sending start command");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 10 ); //We'll wait xx scan cycles
			if(!gMachine.Pt.xControlledByLine ){
				gMachine.commandsSw.xStart_GI = TRUE;
			}
			else{
				TEST_BUSY_CONDITION( gLine.Status != LINE_IDLE && gLine.Status != LINE_PAUSED ); //Waiting the line to be ready to start
				gLine.Commands.Print = TRUE;
			}
			nextState();
			break;

		case 6:
			strcpy(txStateDesc, "Starting");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 5 ); //We'll wait xx scan cycles
			nextState();
			break;

		case 7:
			strcpy(txStateDesc, "Starting the belt");
			TEST_BUSY_CONDITION( !gBelt.states.xRuningBelt );
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Raised Mounted tile alarm");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 5 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( !gThicknessCtrl.status.Belt.xBeltEmpty ); //To be sure the machine is receptive to a new mounted media signal
			if (gDing.State.xDingInstalled){
				if (gDing.Parameters.MountedDetectionType==THICKMOUNT_THICKNESS_RELATIVE){
					gDing.In.rHighDingMm = gDing.Parameters.rMediaThickness + gDing.Parameters.rOverThicknessToMounted + 1; //Raise the Alarm
				}
				else if(gDing.Parameters.MountedDetectionType==THICKMOUNT_ABSOLUTE){
					gDing.In.rHighDingMm = gDing.Parameters.rThicknessToMounted + 1; //Raise the Alarm
				}
			}
			else{
				TEST_BUSY_CONDITION(!gPhotoCells.status.xInPosition); //To active mounted alarm when photocell is positioned
				gPhotoCells.Inputs.Signals.xPhotoCells[gPhotoCells.parameters.iSensorQuantity] = TRUE;
			}
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			nextState();
			break;
		
		case 9:
			if (gDing.State.xDingInstalled){
				TEST_BUSY_CONDITION(!gDing.Alarms.xMountedTile);
			}
			else{
				TEST_BUSY_CONDITION(!gPhotoCells.Alarms.xMountedTile);
			}
			nextState();
			break;		
		
		case 10:
			TEST_BUSY_CONDITION(!gMachine.Al.Alarm.xAlarmMountedPiece);	
			if (gMachine.Pt.xControlledByLine){
				//TEST_ASSERT(!gBelt.commands.xUseSoftDeceleration); 
			}
			//Enable resetting the alarm
			if (gDing.State.xDingInstalled){
				gDing.In.rHighDingMm = 0.0; 
			}
			else{
				gPhotoCells.Inputs.Signals.xPhotoCells[gPhotoCells.parameters.iSensorQuantity] = FALSE;
			}
			nextState();
			break;
		
		case 11:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			strcpy(txStateDesc, "Reseting alarm");
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 12:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			gMachine.In.Buttons.xReset = FALSE;
			nextState();
			break;
		
		case 13:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			if (gDing.State.xDingInstalled){
				TEST_ASSERT(!gDing.Alarms.xMountedTile);
			}
			else{
				TEST_ASSERT(!gPhotoCells.Alarms.xMountedTile);
			}
			TEST_ASSERT(gThicknessCtrl.status.MediaPosition.xMountedMediaInside);
			iTestState = 0;
			
			TEST_DONE;
			break;
		
		default:
			break;
	}	
	
}

_TEST test_GreenButtonAfterPause(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_GreenButtonAfterPause");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			//Machines controlled by line do not have Green button
			if (!gMachine.Pt.xAllowLaboratory)
			{
				TEST_DONE;
				break;
			}
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
			gSimMachine.Commands.xToAuto = TRUE;
			gMachine.In.xConsentL1Ok = TRUE;
			gMachine.parSw.rBeltSpeedSetPoint = 70.0;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Going to Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;

		case 4:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			gMachine.commandsSw.xToLaboratory_GI = TRUE;
			nextState();
			break;

		case 5:
			strcpy(txStateDesc, "Going to Lab");
			TEST_BUSY_CONDITION( !gMachine.St.AutoMode.xLaboratory );
			nextState();
			break;

		case 6:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			gMachine.In.Buttons.xStart = TRUE;
			nextState();
			break;

		case 7:
			strcpy(txStateDesc, "Starting the belt");
			TEST_BUSY_CONDITION( !gBelt.states.xRuningBelt );
			TEST_ASSERT( gThicknessCtrl.status.MediaPosition.xMountedMediaInside );
			gMachine.In.Buttons.xStart = FALSE;
			nextState();
			break;

		case 8:
			strcpy(txStateDesc, "Waiting to remove xMountedMediaInside"); //From previous test
			TEST_BUSY_CONDITION( gThicknessCtrl.status.MediaPosition.xMountedMediaInside );
			gMachine.commandsSw.xPause_GI = TRUE;
			nextState();
			break;

		case 9:
			strcpy(txStateDesc, "Pausing the belt");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( gBelt.states.xRuningBelt );
			nextState();
			break;
		
		case 10:
			gMachine.In.Buttons.xStart = TRUE;
			nextState();
			break;

		case 11:
			strcpy(txStateDesc, "Pressing Start button");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
			gMachine.In.Buttons.xStart = FALSE;
			nextState();
			break;		
		
		case 12:
			TEST_BUSY_CONDITION( !gBelt.states.xRuningBelt && gMachine.St.exec.fast < exTimesPreFast + 500 ); //Wait till run the belt, but if not runs, go next and test will fail in the assert
			nextState();
			break;		

		case 13:
			iTestState = 0;
			TEST_ASSERT(gMachine.St.AutoMode.xLaboratory); //Checked the machine keeps on Laboratory
			TEST_ASSERT(gBelt.commands.xRunBelt); //Checked the order to the belt
			TEST_DONE;
			break;
		
		default:
			break;
	}	
	
}

_TEST test_PauseWithGreenButton(void)
{
	//Machines controlled by line do not enter in Pause using the green button.
	//Pause mode tests considered in LineTests
	if (!gMachine.Pt.xAllowLaboratory)
	{
		TEST_DONE;
	}
	
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_PauseWithGreenButton");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:

			strcpy(txStateDesc, "Going to Zero");
			gSimMachine.Commands.xToZero = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;

		case 1:
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			gMachine.In.xConsentL1Ok = TRUE;
			gMachine.parSw.rBeltSpeedSetPoint = 70.0;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Going to Automatic");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;

		case 4:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			nextState();
			break;

		case 5:
			gMachine.commandsSw.xToLaboratory_GI = TRUE;
			strcpy(txStateDesc, "Waiting to be in Lab");
			TEST_BUSY_CONDITION( !gMachine.St.AutoMode.xLaboratory );
			nextState();
			break;

		case 6:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
			strcpy(txStateDesc, "Pressing the button");
			gMachine.In.Buttons.xStart = TRUE;
			nextState();
			break;

		case 7:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			gMachine.In.Buttons.xStart = FALSE;
			nextState();
			break;

		case 8:
			strcpy(txStateDesc, "Waiting the belt running");
			TEST_BUSY_CONDITION( !gBelt.states.xRuningBelt );
			nextState();
			break;

		case 9:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 20 ); //We'll wait xx scan cycles
			strcpy(txStateDesc, "Pressing the button to pause the belt");
			gMachine.In.Buttons.xStart = TRUE;
			nextState();
			break;

		case 10:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			gMachine.In.Buttons.xStart = FALSE;
			nextState();
			break;

		case 11:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			iTestState = 0;
			TEST_ASSERT(!gBelt.states.xRuningBelt); //Checked the order to the belt
			TEST_DONE;
			break;
		
		default:
			break;
	}	
	
}



_TEST test_RunBeltWithP4_2BK12Bar_1BlockDisabled(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_RunBeltWithP4_2BK12Bar_1BlockDisabled");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			//Do not execute if it is not a machine with 2 blocks
			if (gMachine.Pt.CT.iNumBlocks == 1 ){
				TEST_DONE;
				break;
			}
			
			strcpy(txStateDesc, "Going To Zero");
			gSimMachine.Commands.xToZero = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;

		case 1:
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			strcpy(txStateDesc, "Going To Auto");
			gSimMachine.Commands.xToAuto = TRUE;
			gMachine.In.xConsentL1Ok = TRUE;
			gMachine.parSw.rBeltSpeedSetPoint = 70.0;
			nextState();
			break;

		case 3:
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;

		case 4:
			strcpy(txStateDesc, "Waiting to Cap Position");
			TEST_BUSY_CONDITION( !gMachine.St.Position.xInCap );
			gBlock[2].parSw.xEnableToMovements = FALSE;
			nextState();
			break;

		case 5:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			gMachine.commandsSw.xToNormal_GI = TRUE;
			nextState();
			break;

		case 6:
			strcpy(txStateDesc, "Going to Production Mode");
			TEST_BUSY_CONDITION( !gMachine.St.AutoMode.xProduction );
			nextState();
			break;
		
		case 7:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			nextState();
			break;
				
		case 8:
			strcpy(txStateDesc, "Waiting the first block to be in print");
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_IN_PRINT );
			nextState();
			break;

		case 9:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			nextState();
			break;

		case 10:
			iTestState = 0;
			TEST_ASSERT(gMachine.St.AutoMode.xProduction); //Checked the machine keeps on Laboratory
			TEST_ASSERT(gMachine.St.Position.xInPrint); //Checked the position of the machine
			gBlock[2].parSw.xEnableToMovements = TRUE;
			TEST_DONE;
			break;
		
		default:
			break;
	}	
	
}

_TEST test_ExternalCleanJust1Block(void)
{
	if (gMachine.Pt.xControlledByLine)
	{
		TEST_DONE;
	}
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_ExternalCleanJust1Block");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToAuto = TRUE;
			gMachine.In.xConsentL1Ok = TRUE;
			gBlock[2].parSw.xEnableToMovements = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Going to Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;

		case 2:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			strcpy(txStateDesc, "Activating External cleaning order selector");
			gMachine.In.xExternalCleaningOrder = TRUE;
			nextState();
			break;

		case 3:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 100 ); //We'll wait xx scan cycles
			strcpy(txStateDesc, "Removing External cleaning order selector");
			gMachine.In.xExternalCleaningOrder = FALSE;
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the machine to start cleaning");
			TEST_BUSY_CONDITION( gMachine.St.Cleaning.enCleaningState == CLN_NOT_CLEANING ); //We'll wait xx scan cycles
			TEST_ASSERT( gMachine.St.Cleaning.enCleaningState!= CLN_NOT_CLEANING);
			gSimMachine.Commands.xToZero = TRUE;
			nextState(); //To register the value of time an enable a posterior waiting
			iTestState = 0;
			TEST_DONE;
			break;
		
		default:
			break;
	}	
	
}

_TEST test_RaiseBlocksWithSlowSpeed(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_RaiseBlocksWithSlowSpeed");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
			gSimMachine.Commands.xToAuto = TRUE;
			gMachine.In.xConsentL1Ok = TRUE;
			gBlock[2].parSw.xEnableToMovements = TRUE;
			gMachine.parSw.rBeltSpeedSetPoint = 10.0;
			gMachine.parSw.Safety.rMarginSafePrint = 1.0;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Going to Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;

		case 2:
			strcpy(txStateDesc, "Waiting to be in Cap");
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_IN_CAP );
			gMachine.commandsSw.xReset_GI = TRUE;
			TEST_BUSY_CONDITION( gMachine.AlSummary.xAlarmStop );
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Sending the blocks to Print");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			gSimMachine.Commands.xToProduction = TRUE;
			nextState();
			break;

		case 4:
			strcpy(txStateDesc, "Waiting the belt to run");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( !gBelt.states.xRuningBelt );
			TEST_BUSY_CONDITION( gThicknessCtrl.status.MediaPosition.xMountedMediaInside ); //[RGP] Mounted media provokes bars go to 100mm height
			TEST_BUSY_CONDITION( !gThicknessCtrl.status.Belt.xBeltEmpty );
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the blocks to to in position");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			// Been sure that at maximum height is in PreprintingPos
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_IN_PRINT || 
								gBlock[1].Status.rMotorPosition > gBlock[1].parameters.rPrePrintingPos + 0.1  ||
								!gAxis[gBlock[1].parameters.iMotorAxisIndex].Status.InPosition );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Simulating media entry");
			TEST_BUSY_CONDITION( !gThicknessCtrl.status.Belt.xBeltEmpty );
			if (gDing.State.xDingInstalled){
				gSimMachine.Commands.Media.rMediaThickness = gThicknessCtrl.status.Heigh.rMediaThicknessMargin + 1 ;	//Entering media 1mm thicker than expected
			}
			else{
				gPhotoCells.Inputs.Signals.xPhotoCells[2] = TRUE;
				gPhotoCells.Inputs.Signals.xPhotoCells[1] = TRUE;
			}
			gSimMachine.Commands.Media.xMediaPresent = TRUE;
			
			nextState();
			break;		
		
		case 7:
			strcpy(txStateDesc, "Waiting the bars to raise");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 20); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( !gAxis[gBlock[1].parameters.iMotorAxisIndex].Status.InPosition );
			#define TEST_FLOAT_PRECISION 	(0.0001f)
			if (gDing.State.xDingInstalled){
				TEST_ASSERT_EQUAL_INT(gSimMachine.Commands.Media.rMediaThickness + gMachine.parSw.Safety.rMarginSafePrint, gBlock[1].Status.rMotorPosition);
			}
			else{
				if (gThicknessCtrl.parameters.xMarginForBendTile){
					TEST_ASSERT_EQUAL_REAL(gMachine.parSw.Media.rThickness + gPhotoCells.parameters.Sensors[3].rDistanceRelativeToFirstSensor + gMachine.parSw.Safety.rMarginSafePrint, 
											gBlock[1].Status.rMotorPosition);
				}
				else{
					if(gPhotoCells.status.xSensorsPositionedRelativeToBar){
						TEST_ASSERT_EQUAL_REAL(gPhotoCells.parameters.rOffsetRelToBar + gPhotoCells.parameters.Sensors[3].rDistanceRelativeToFirstSensor + gPhotoCells.status.rOffsetToApplyToBarsPosition, 
											gBlock[1].Status.rMotorPosition);
					}	
					else{
						TEST_ASSERT_EQUAL_REAL(gMachine.parSw.Media.rThickness + gPhotoCells.parameters.Sensors[3].rDistanceRelativeToFirstSensor + gPhotoCells.parameters.rOffsetPosition, 
											gBlock[1].Status.rMotorPosition);
					}
				}
			}
			#define TEST_FLOAT_PRECISION 	(0.00001f)
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Stop simulating media");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 30 ); //We'll wait xx scan cycles
			if (gPhotoCells.status.xInstalled){
				gPhotoCells.Inputs.Signals.xPhotoCells[2] = FALSE;
				gPhotoCells.Inputs.Signals.xPhotoCells[1] = FALSE;
			}
			gSimMachine.Commands.Media.xMediaPresent = FALSE;
			
			nextState();
			break;
		
		case 9:
			strcpy(txStateDesc, "Waiting the belt to be empty");
			gSimMachine.Commands.Media.rMediaThickness = 0;	//Entering media 1mm thicker than expected
			gMachine.parSw.rBeltSpeedSetPoint = 70.0;
			TEST_BUSY_CONDITION( !gThicknessCtrl.status.Belt.xBeltEmpty); //Waiting the belt to be empty
			nextState();
			break;
		
		case 10:
			strcpy(txStateDesc, "Waiting the bars to go to position");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
			gSimMachine.Commands.Media.rMediaThickness = 2;
			iTestState = 0;
			TEST_DONE;
			break;
		
		default:
			break;
	}	
}

_TEST test_RaiseBlocksWithStoppedMedia(void)
{
	//If the Test makes non sense, not execute it. When controlled by line, there is no bent alarm.
	// Belt's consent is not considered, instead there is SafetyController status which gives consent to belt and actives critical alarms
	if (gMachine.Pt.xControlledByLine){
		TEST_DONE;		
	}
	
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_RaiseBlocksWithStoppedMedia");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	diffExecFast =  gMachine.St.exec.fast - exTimesPreFast;
	switch (iTestState)
	{
		case 0:
			//Not execute this test if this functionality is not configured in the machine
			if (!gMachine.Pt.xProtectPHWithStoppedMediaBended)
			{
				TEST_DONE;
				break;
			}
			gSimMachine.Commands.xToAuto = TRUE;
			gMachine.In.Buttons.xReset = TRUE;
			gMachine.In.xConsentL1Ok = TRUE;
			gBlock[2].parSw.xEnableToMovements = TRUE;
			gSimMachine.Commands.Media.xMediaPresent = FALSE;
			gMachine.parSw.rBeltSpeedSetPoint = 15;
			gMachine.parSw.Safety.rMarginSafePrint = 1.0;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Going To Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			gMachine.In.Buttons.xReset = FALSE;
			nextState();
			break;

		case 2:
			gMachine.commandsSw.xToNormal_GI = TRUE;
			strcpy(txStateDesc, "Going To Production");
			TEST_BUSY_CONDITION( !gMachine.St.AutoMode.xProduction);
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_IN_PRINT );
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the Belt to start");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( !gBelt.states.xRuningBelt );
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Entering media");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
			//Simulate a media entering to be sure to be in real printing position in all the machines
			gSimMachine.Commands.Media.rMediaThickness = gThicknessCtrl.status.Heigh.rMediaThickness -0.5; //Media thickness to avoid raising the bars
			gSimMachine.Commands.Media.xMediaPresent = TRUE;
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Waiting the Block 1 to be in print position");
			TEST_BUSY_CONDITION( gBlock[1].Status.rMotorPosition > gMachine.parSw.Media.rThickness + gMachine.parSw.rMarginPrint );
			gSimMachine.Commands.Media.xMediaPresent = FALSE;
			nextState();
			break;
		
		case 6:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			gSimMachine.Commands.Media.rMediaThickness = gThicknessCtrl.status.Heigh.rMediaThickness -0.5; //Media thickness to avoid raising the bars
			gSimMachine.Commands.Media.xMediaPresent = TRUE;
			nextState();
			break;		
		
		case 7:
			strcpy(txStateDesc, "Simulating a new media entering the machine");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 15 ); //We'll wait xx scan cycles
			gSimMachine.Commands.Media.xMediaPresent = FALSE;
			gMachine.commandsSw.xPause_GI = TRUE;
			nextState();
			break;
		
		case 8:
			strcpy(txStateDesc, "Waiting media stopped inside to bend");
			TEST_BUSY_CONDITION( !gMachine.AutoCmd.xToSafePosition );
			nextState();
			break;
		
		case 9:
			strcpy(txStateDesc, "Waiting bars to raise");
			TEST_BUSY_CONDITION( abs(gBlock[1].Status.Motor.rActVelocity) > 0.05 );
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 200 ); //We'll wait xx scan cycles
			TEST_ASSERT_EQUAL_REAL(gBlock[1].parameters.rPrePrintingPos, gBlock[1].Status.rMotorPosition);
			gMachine.parSw.rBeltSpeedSetPoint = 70; //Increase speed

			iTestState = 0;
			TEST_DONE;
			break;
		
		default:
			break;
	}	
	
}

_TEST test_RaiseBlocksWithAlarmStop(void)
{
	if (gMachine.Pt.xControlledByLine){
		TEST_DONE;
	}
	
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_RaiseBlocksWithAlarmStop");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gMachine.In.xConsentL1Ok = TRUE;
			gBlock[2].parSw.xEnableToMovements = TRUE;
			gMachine.parSw.Safety.rMarginSafePrint = 1.0;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Going To Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Going To Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;

		case 4:
			gMachine.commandsSw.xToNormal_GI = TRUE;
			strcpy(txStateDesc, "Going To Production");
			TEST_BUSY_CONDITION( !gMachine.St.AutoMode.xProduction);
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_IN_PRINT );
			nextState();
			break;

		case 5:
			strcpy(txStateDesc, "Waiting the Belt to start");
			TEST_BUSY_CONDITION( !gBelt.states.xRuningBelt );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the Block 1 to be in print position");
			gSimMachine.Commands.Media.rMediaThickness = gThicknessCtrl.status.Heigh.rMediaThickness -0.5; //Media thickness to avoid raising the bars
			gSimMachine.Commands.Media.xMediaPresent = !gThicknessCtrl.status.MediaPosition.xMediaInside; //To avoid bars go to PrePrintPosition
			TEST_BUSY_CONDITION( gBlock[1].Status.rMotorPosition > gMachine.parSw.Media.rThickness + gMachine.parSw.rMarginPrint );
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Waiting the bars to raise to Cap");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
			
			gMachine.Al.Alarm.xAlr24Vdc = TRUE;
			nextState();
			break;
		
		
		case 8:
			strcpy(txStateDesc, "Waiting the bars to raise to Cap");
			TEST_BUSY_CONDITION( !gMachine.AlSummary.xAlarmStop ); //We'll wait xx scan cycles
			nextState();
			break;
			

		case 9:
			strcpy(txStateDesc, "Waiting the bars to raise to Cap");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION(gBlock[1].Status.PositionState!=BLOCKP_IN_CAP); //We'll wait xx scan cycles
			if (!gBlock[1].parameters.xCappingProcess) {
				TEST_ASSERT_EQUAL_REAL(gBlock[1].parameters.Motor.rCapPosition, gBlock[1].Status.rMotorPosition);		
			}
			else{
				TEST_ASSERT_EQUAL_REAL(gBlock[1].parameters.Motor.rCappingPosition, gBlock[1].Status.rMotorPosition);
				TEST_ASSERT(gBlock[1].Out.xCappingWaterPump = TRUE);
			}	
			TEST_ASSERT(!gBelt.states.xRuningBelt);
			gMachine.Al.Alarm.xAlr24Vdc = FALSE;
			
			iTestState = 0;
			TEST_DONE;
			break;
		
		default:
			break;
	}
}

_TEST test_RaiseBlocksWithBeltAlarmStop(void)
{// Generated for CUBE-885
	if (gMachine.Pt.xControlledByLine){
		TEST_DONE;
	}
	
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_RaiseBlocksWithBeltAlarmStop");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gMachine.In.xConsentL1Ok = TRUE;
			gBlock[2].parSw.xEnableToMovements = TRUE;
			gMachine.parSw.Safety.rMarginSafePrint = 1.0;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Going To Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Going To Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;

		case 4:
			gMachine.commandsSw.xToNormal_GI = TRUE;
			strcpy(txStateDesc, "Going To Production");
			TEST_BUSY_CONDITION( !gMachine.St.AutoMode.xProduction);
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_IN_PRINT );
			nextState();
			break;

		case 5:
			strcpy(txStateDesc, "Waiting the Belt to start");
			TEST_BUSY_CONDITION( !gBelt.states.xRuningBelt );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the Block 1 to be in print position");
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_IN_PRINT );
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Generating Belt Alarm");
			gBelt.Al.xAlrComDrive = TRUE;
			nextState();
			break;		
		
		case 8:
			strcpy(txStateDesc, "Waiting the bars to raise to Cap");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
			TEST_ASSERT_EQUAL_INT(gBlock[1].Status.PositionState, BLOCKP_GOING_TO_CAP); //We'll wait xx scan cycles
			TEST_ASSERT(!gBelt.states.xRuningBelt);
			gBelt.Al.xAlrComDrive = FALSE;

			iTestState = 0;
			TEST_DONE;
			break;
		
		default:
			break;
	}
}

_TEST test_GoPrintInStop(void)
{
	if (gMachine.Pt.xControlledByLine){
		TEST_DONE;		
	}
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_GoPrintInStop");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			strcpy(txStateDesc, "Going To Zero");
			gSimMachine.Commands.xToZero = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;

		case 1:
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			strcpy(txStateDesc, "Going To Auto");
			gSimMachine.Commands.xToAuto = TRUE;
			gMachine.In.xConsentL1Ok = TRUE;
			gMachine.parSw.rBeltSpeedSetPoint = 70.0;
			nextState();
			break;

		case 3:
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;

		case 4:
			strcpy(txStateDesc, "Waiting to Be Going to Cap");
			endtime = clock_ms();
			TEST_BUSY_CONDITION( endtime < TimeLast + 400 ); //We'll wait xx ms
			strcpy(txStateDesc, "Sending the order to go to Print");
			gMachine.commands.xAllToPrint = TRUE;
			nextState();
			break;

		case 5:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			nextState();
			break;

		case 6:
			TEST_ASSERT(gBlock[1].Status.PositionState==BLOCKP_GOING_TO_CAP || gBlock[1].Status.PositionState==BLOCKP_IN_CAP); //Checked if the machine doesn't go to print
			iTestState = 0;
			TEST_DONE;
			break;
		
		default:
			break;
	}	
}


_TEST test_StopWithMountedMediaBypass(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_StopWithMountedMediaBypass");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			if (!gPhotoCells.parameters.xEnableMountedAlrByPass || !gPhotoCells.parameters.xInstall)
			{
				TEST_DONE;
				break;
			}
		case 1:
			gSimMachine.Commands.xToZero = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;

		case 2:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
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
			strcpy(txStateDesc, "WaitPhotoCellsInPos");
			TEST_BUSY_CONDITION(!gPhotoCells.status.xInPosition);
			nextState();
			break;	
		
		case 6:
			strcpy(txStateDesc, "CheckStepperInByPassPosition");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 50 ); //We'll wait xx scan cycles
			TEST_ASSERT_EQUAL_REAL(gPhotoCells.status.rPositionMotor, gPhotoCells.parameters.rSensorMechPositionByPass);
			nextState();
			break;	
		
		case 7:
			gPhotoCells.Inputs.Signals.xPhotoCells[1] = TRUE;
			gPhotoCells.Inputs.Signals.xPhotoCells[2] = TRUE;
			gPhotoCells.Inputs.Signals.xPhotoCells[3] = TRUE;
			gPhotoCells.Inputs.Signals.xPhotoCells[4] = (gPhotoCells.parameters.iSensorQuantity >3);
			gPhotoCells.Inputs.Signals.xPhotoCells[5] = (gPhotoCells.parameters.iSensorQuantity >4);
			gPhotoCells.Inputs.Signals.xPhotoCells[6] = (gPhotoCells.parameters.iSensorQuantity >5);
			nextState();
			break;
		
		
		case 8:
			strcpy(txStateDesc, "Waiting the bars to raise to Cap");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
			TEST_ASSERT(!gBelt.states.xRuningBelt);
			TEST_ASSERT(gMachine.AlSummary.xAlarmStop);
			
			gPhotoCells.Inputs.Signals.xPhotoCells[1] = FALSE;
			gPhotoCells.Inputs.Signals.xPhotoCells[2] = FALSE;
			gPhotoCells.Inputs.Signals.xPhotoCells[3] = FALSE;
			gPhotoCells.Inputs.Signals.xPhotoCells[4] = FALSE;
			gPhotoCells.Inputs.Signals.xPhotoCells[5] = FALSE;
			gPhotoCells.Inputs.Signals.xPhotoCells[6] = FALSE;
			
			gMachine.In.Buttons.xReset = TRUE;
			
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}


_TEST test_StopWithNotReferenceAnalogThickness(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_StopWithNotReferenceAnalogThickness");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			if (!gDing.State.xDingInstalled)
			{
				TEST_DONE;
				break;
			}

		case 1:
			strcpy(txStateDesc, "Waiting the Belt to Start. In ByPass");
			gMachine.commandsSw.xToByPass_GI = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			TEST_BUSY_CONDITION(!gMachine.St.AutoMode.xBypass); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION(!gBelt.states.xRuningBelt); //We'll wait xx scan cycles
			nextState();
			break;

		case 2:
			strcpy(txStateDesc, "Remoe Analog Thickness Reference");
			gDing.State.xDingReferenced = FALSE;
			TEST_BUSY_CONDITION(!gDing.Alarms.xAlDingNotReferenced);
			TEST_BUSY_CONDITION(!gDing.AlSummary.xAlarmStop);
			nextState();
			break;	
		
		case 3:
			strcpy(txStateDesc, "Check Belt Stop and correct machine state");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 50 ); //We'll wait xx scan cycles
			TEST_ASSERT(!gBelt.states.xRuningBelt);
			TEST_ASSERT(gMachine.St.AutoMode.xStop);
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Recalibrate - Going to Zero");
			gSimMachine.Commands.xToZero = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;
		
		
		case 5:
			strcpy(txStateDesc, "Recalibrate - Calibrating analog sensor");
			gDing.In.xDingLow = TRUE;
			gDing.In.rHighDingMm = gDing.parSw.rCalibrationValue;
			gDing.Commands.xCalibrateThickness = TRUE;
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Calibrating Analog Sensor");
			TEST_BUSY_CONDITION( gDing.Commands.xCalibrateThickness );
			nextState();
			break;
		
		
		case 7:
			TEST_ASSERT(gDing.State.xDingReferenced);
			gDing.In.rHighDingMm = 0;
			gDing.In.xDingLow = FALSE;
			
			iTestState = 0;
			TEST_DONE;
			break;
		
		default:
			break;
	}
}

_TEST test_FilterToNotActiveNotLoadedImageAlarm(void)
{
	if (gMachine.Pt.iMediaFilter<=0)
	{
		TEST_DONE;
	}
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_FilterToNotActiveNotLoadedImageAlarm");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
			gSimMachine.Commands.xToZero = TRUE;
			gMachine.In.xConsentL1Ok = TRUE;
			gBlock[2].parSw.xEnableToMovements = TRUE;
			gMachine.parSw.rBeltSpeedSetPoint = 20.0;
			gMachine.parSw.Safety.rMarginSafePrint = 1.0;
			gSimMachine.Parameters.rStainLength = (gMachine.Pt.iMediaFilter*10 - 10);
			gSimMachine.Parameters.rStainGap = 100.0;
			gMachine.parSw.Electronics.xRobotReadyL1 = FALSE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Going to Auto");
			gSimMachine.Commands.xToAuto = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;

		case 2:
			strcpy(txStateDesc, "Waiting to be in Cap");
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_IN_CAP );
			gSimMachine.Commands.xToProduction = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the belt to run");
			TEST_BUSY_CONDITION( !gBelt.states.xRuningBelt );
			TEST_BUSY_CONDITION( gThicknessCtrl.status.MediaPosition.xMountedMediaInside ); //[RGP] Mounted media provokes bars go to 100mm height
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the blocks to to in position");
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_IN_PRINT );
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Entering media intro printer");
			gSimMachine.Commands.xStain = TRUE;
			TEST_BUSY_CONDITION( !gThicknessCtrl.status.Detection.xMediaInProductDetect);			
			nextState();
			break;		
		
		case 6:
			strcpy(txStateDesc, "Checking there is no alarm");
			TEST_BUSY_CONDITION(!gThicknessCtrl.status.Detection.xMediaInProductDetect);
			TEST_ASSERT(!gMachine.Al.Warning.xNotLoadedImage || !gMachine.Al.Alarm.xNotLoadedImage);
			gSimMachine.Commands.xStain = FALSE;
			gMachine.parSw.Electronics.xRobotReadyL1 = TRUE;
			
			iTestState = 0;
			TEST_DONE;
			break;
		
		default:
			break;
	}	
}


_TEST test_FilterForNotLoadedImageAlarm(void)
{
	if (gMachine.Pt.iMediaFilter<=0)
	{
		TEST_DONE;
	}
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_FilterForNotLoadedImageAlarm");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
			gSimMachine.Commands.xToZero = TRUE;
			gMachine.In.xConsentL1Ok = TRUE;
			gBlock[2].parSw.xEnableToMovements = TRUE;
			gMachine.parSw.rBeltSpeedSetPoint = 20.0;
			gMachine.parSw.Safety.rMarginSafePrint = 1.0;
			gMachine.parSw.Media.rLength = (gMachine.Pt.iMediaFilter*10 + 100);
			gMachine.parSw.Electronics.xRobotReadyL1 = FALSE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Going to Auto");
			gSimMachine.Commands.xToAuto = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;

		case 2:
			strcpy(txStateDesc, "Waiting to be in Cap");
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_IN_CAP );
			if(!gMachine.Pt.xControlledByLine ){
				gMachine.commandsSw.xStart_GI = TRUE;
			}
			else{
				gLine.Commands.Print = TRUE;
			}
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the belt to run");
			TEST_BUSY_CONDITION( !gBelt.states.xRuningBelt );
			TEST_BUSY_CONDITION( gThicknessCtrl.status.MediaPosition.xMountedMediaInside ); //[RGP] Mounted media provokes bars go to 100mm height
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the blocks to to in position");
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_IN_PRINT );
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Entering media intro printer");
			gSimMachine.Commands.Media.xContinuousMediaPresent = TRUE;
			TEST_BUSY_CONDITION(!gThicknessCtrl.Outputs.xMediaFiltered);
			nextState();
			break;		
		
		case 6:
			strcpy(txStateDesc, "Checking there is no alarm");
			TEST_BUSY_CONDITION(gBelt.states.xRuningBelt );
			TEST_ASSERT(!gBelt.states.xRuningBelt);
			gSimMachine.Commands.Media.xContinuousMediaPresent = FALSE;
			gMachine.parSw.Electronics.xRobotReadyL1 = TRUE;
			
			iTestState = 0;
			TEST_DONE;
			break;
		
		default:
			break;
	}	
}


_TEST test_MediaIncoherenceAlarm(void)
{
	if (gMachine.Pt.iMediaFilter<=0 || !gThicknessCtrl.parameters.Detection.Array.xEnableSensorIncoherAlarm)
	{
		TEST_DONE;
	}
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_MediaIncoherenceAlarm");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
			gSimMachine.Commands.xToZero = TRUE;
			gMachine.In.xConsentL1Ok = TRUE;
			gBlock[2].parSw.xEnableToMovements = TRUE;
			gMachine.parSw.rBeltSpeedSetPoint = 20.0;
			gMachine.parSw.Safety.rMarginSafePrint = 1.0;
			gSimMachine.Parameters.rStainLength = (gMachine.Pt.iMediaFilter*10 + 500);
			gSimMachine.Parameters.rStainGap = 100.0;
			gMachine.parSw.Media.rLength = 1600;
			gMachine.parSw.Electronics.xRobotReadyL1 = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Going to Auto");
			gSimMachine.Commands.xToAuto = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;

		case 2:
			strcpy(txStateDesc, "Waiting to be in Cap");
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_IN_CAP );
			if(!gMachine.Pt.xControlledByLine ){
				gMachine.commandsSw.xStart_GI = TRUE;
			}
			else{
				gLine.Commands.Print = TRUE;
			}
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the belt to run");
			TEST_BUSY_CONDITION( !gBelt.states.xRuningBelt );
			TEST_BUSY_CONDITION( gThicknessCtrl.status.MediaPosition.xMountedMediaInside ); //[RGP] Mounted media provokes bars go to 100mm height
			TEST_BUSY_CONDITION( gThicknessCtrl.status.MediaPosition.xMediaInside );
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the blocks to to in position");
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_IN_PRINT );
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Entering media into printer");
			gSimMachine.Commands.xStain = TRUE;
			TEST_BUSY_CONDITION(!gThicknessCtrl.Outputs.xMediaFiltered);
			nextState();
			break;		
		
		case 6:
			strcpy(txStateDesc, "Checking there is no alarm");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
			TEST_ASSERT(gMachine.Al.Warning.xMediaIncoherenceDetectedL1);
			gSimMachine.Commands.xStain = FALSE;
			gMachine.In.Buttons.xReset = TRUE;
			
			iTestState = 0;
			TEST_DONE;
			break;
		
		default:
			break;
	}	
}


_TEST test_NoStopInBypassWhenUpperSafetyActivated(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_NoStopInBypassWhenUpperSafetyActivated");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			if (!gPhotoCells.parameters.xEnableMountedAlrByPass || !gPhotoCells.parameters.xInstall || gMachine.Pt.xControlledByLine)
			{	
				//This 2 lines just for the last TestCase
				strcpy(txTest, "test_BeltTest Finished!! Congrats!");
				strcpy(txStateDesc, "--");
						
				TEST_DONE;
				break;
			}
		
		case 1:
			gSimMachine.Commands.xToZero = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;

		case 2:
			strcpy(txStateDesc, "Waiting the machine to be in Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
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
			strcpy(txStateDesc, "Waiting the Belt to Start in ByPass");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			gMachine.commandsSw.xToByPass_GI = TRUE;
			TEST_BUSY_CONDITION(!gMachine.St.AutoMode.xBypass); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION(!gBelt.states.xRuningBelt); //We'll wait xx scan cycles
			nextState();
			break;

		case 5:
			strcpy(txStateDesc, "To active light curtain alarm");
			gBlock[1].Al.xAlrFrontCurtain = TRUE;
			nextState();
			break;		
		
		case 6:
			strcpy(txStateDesc, "Waiting the bars to raise to Cap");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 100 ); //We'll wait xx scan cycles
			TEST_ASSERT(gBelt.states.xRuningBelt);
			gBlock[1].Al.xAlrFrontCurtain = FALSE;
			
			iTestState = 0;
			TEST_DONE;
			
			break;
		
		default:
			break;
	}
}


_TEST test_StopWithWrongDingPosition(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_StopWithWrongDingPosition");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	// This test is to test the stop with the alarm gMachine.Al.Alarm.xAlrDingWrongPosition := TRUE; 
	switch (iTestState)
	{
		case 0:
			if (!gDing.State.xDingInstalled || !gDing.Parameters.xRaiseDigitalIncoherency)
			{
				//This 2 lines just for the last TestCase
				strcpy(txTest, "test_BeltTest Finished!! Congrats!");
				strcpy(txStateDesc, "--");
			
				TEST_DONE;
				break;
			}

		case 1:
			strcpy(txStateDesc, "Going To Auto");
			gSimMachine.Commands.xToAuto = TRUE;
			gMachine.In.xConsentL1Ok = TRUE;
			gMachine.parSw.rBeltSpeedSetPoint = 70.0;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;
		case 2:
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;
		
		case 3:
			strcpy(txStateDesc, "Sending the order to go to Print");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 200 ); //We'll wait xx scan cycles
			gMachine.AutoCmd.xStart = TRUE;
			nextState();
			break;	
		
		case 4:
			strcpy(txStateDesc, "Going To Production");
			gMachine.commandsSw.xToNormal_GI = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.AutoMode.xProduction);
			nextState();
			break;

		case 5:
			strcpy(txStateDesc, "Wait Sar Belt and Bars in Print");
			TEST_BUSY_CONDITION( !gBelt.states.xRuningBelt);
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_IN_PRINT );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Send InstantShoot");
			gMachine.parSw.Shot.xShotLine1 = TRUE;
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 100 ); //We'll wait xx scan cycles
			gSimMachine.Signals.xPDCarriageSignalL1 = TRUE;
			gSimMachine.Signals.xProductDetectL1 = TRUE;
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Check alarm with InstantShoot");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 100 ); //We'll wait xx scan cycles
			TEST_ASSERT(gBlock[1].Status.PositionState == BLOCKP_IN_PRINT); //Checked if the machine doesn't stop
			nextState();
			break;

		case 8:
			
			strcpy(txStateDesc, "Remove Carriage Signal");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 100 ); //We'll wait xx scan cycles
			gSimMachine.Signals.xPDCarriageSignalL1 = FALSE;
			gSimMachine.Signals.xProductDetectL1 = FALSE;
			nextState();
			break;
		
		case 9:
			strcpy(txStateDesc, "Restart Machine");
			gMachine.In.Buttons.xReset = TRUE;
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 100 ); //We'll wait xx scan cycles
			gMachine.AutoCmd.xStart = TRUE;
			nextState();
			break;
		
		case 10:
			strcpy(txStateDesc, "Wait Instant Shoot Removed");
			TEST_BUSY_CONDITION(gMachine.parSw.Shot.xShotLine1 == TRUE);
			nextState();
			break;
		
			
		case 11:
			strcpy(txStateDesc, "Activate PD signal");
			gSimMachine.Signals.xPDCarriageSignalL1 = TRUE;
			gSimMachine.Signals.xProductDetectL1 = TRUE;
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 100 ); //We'll wait xx scan cycles
			nextState();
			break;
			
		case 12:
			strcpy(txStateDesc, "Check machine stop");
			TEST_ASSERT(gBlock[1].Status.PositionState == BLOCKP_GOING_TO_CAP); //Checked if the machine doesn't stop
			gSimMachine.Signals.xPDCarriageSignalL1 = FALSE;
			gSimMachine.Signals.xProductDetectL1 = FALSE;
			
			iTestState = 0;
			TEST_DONE;

			break;
		
		default:
			break;
	}
}

// Test CheckMediaNOK. CheckMedia active and not Media at exit
_TEST test_CheckMediaNOK(void)
{
	if (!gThicknessCtrl.parameters.CheckMedia[1].xActive)
	{
		iTestState = 0;
		TEST_DONE;		
	}
	
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_CheckMediaNOK");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			gMachine.parSw.rBeltSpeedSetPoint = 70.0;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Going To Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Going To Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;

		case 4:
			gSimMachine.Commands.xToProduction = TRUE;
			strcpy(txStateDesc, "Going To Production");
			TEST_BUSY_CONDITION( !gMachine.St.AutoMode.xProduction);
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_IN_PRINT );
			nextState();
			break;

		case 5:
			strcpy(txStateDesc, "Waiting the Belt to start");
			TEST_BUSY_CONDITION( !gBelt.states.xRuningBelt );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Waiting the Block 1 to be in print position");
			TEST_BUSY_CONDITION( !gThicknessCtrl.status.Belt.xBeltEmpty );
			gSimThickCtrl.Orders.NotActivateMediaInPos = TRUE;
			gSimMachine.Commands.Media.rMediaThickness = gThicknessCtrl.status.Heigh.rMediaThickness -0.5; //Media thickness to avoid raising the bars
			gSimMachine.Commands.Media.xMediaPresent = !gThicknessCtrl.status.MediaPosition.xMediaInside; //To avoid bars go to PrePrintPosition
			TEST_BUSY_CONDITION( gBlock[1].Status.rMotorPosition > gMachine.parSw.Media.rThickness + gMachine.parSw.rMarginPrint );
			gSimMachine.Commands.Media.xMediaPresent = FALSE;
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Waiting to send clean new board");
			TEST_BUSY_CONDITION( gThicknessCtrl.status.MediaPosition.xMediaInside ); //We'll wait xx scan cycles
			gSimMachine.Commands.Media.rMediaThickness = gMachine.parSw.Media.rThickness -0.5; //Media thickness to avoid raising the bars
			gMachine.parSw.rBeltSpeedSetPoint = 70.0;
			gSimMachine.Commands.Media.xMediaPresent = TRUE;
			nextState();
			break;		
		
		case 8:
			strcpy(txStateDesc, "Waiting the bars to raise to Cap");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			nextState();
			break;		
		
		case 9:
			strcpy(txStateDesc, "Waiting the media to be inside");
			TEST_BUSY_CONDITION( !gThicknessCtrl.status.MediaPosition.xMediaInside );
			nextState();
			break;		

		case 10:
			strcpy(txStateDesc, "Assure a media long enough is inside");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 20 ); //We'll wait xx scan cycles
			gSimMachine.Commands.Media.xMediaPresent = FALSE;
			nextState();
			break;		

		case 11:
			endtime = clock_ms();
			TEST_BUSY_CONDITION( endtime < TimeLast + 6000 && !gThicknessCtrl.Alarms.CheckMedia[1] ); //We'll wait xx ms to the alarm to raise
			TEST_ASSERT(gThicknessCtrl.Alarms.CheckMedia[1]);
			gSimThickCtrl.Orders.NotActivateMediaInPos = FALSE;
			gMachine.commandsSw.xReset_GI = TRUE;
			
			iTestState = 0;
			TEST_DONE;
			break;
		
		default:
			break;
	}
}


_TEST test_nSensorBarPositionCalculation(void)
{
	if (!gPhotoCells.status.xInstalled || (gPhotoCells.parameters.iSensorQuantity<=3) || gPhotoCells.status.xSensorsPositionedRelativeToBar)
	{	
		iTestState = 0;
		TEST_DONE;
	}
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_nSensorBarPositionCalculation");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
			gSimMachine.Commands.xToZero = TRUE;
			gMachine.In.xConsentL1Ok = TRUE;
			gBlock[2].parSw.xEnableToMovements = TRUE;
			gMachine.parSw.rBeltSpeedSetPoint = 50.0;
			gMachine.parSw.Media.rThickness = 2.0;
			gMachine.parSw.rMarginPrint = (gPhotoCells.parameters.Sensors[2].rDistanceRelativeToFirstSensor - gPhotoCells.parameters.rOffsetPosition);
			gMachine.parSw.Electronics.xRobotReadyL1 = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Going to Auto");
			gSimMachine.Commands.xToAuto = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;

		case 2:
			strcpy(txStateDesc, "Waiting to be in Cap");
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_IN_CAP );
			if(!gMachine.Pt.xControlledByLine ){
				gMachine.commandsSw.xStart_GI = TRUE;
			}
			else{
				gLine.Commands.Print = TRUE;
			}
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the belt to run");
			TEST_BUSY_CONDITION( !gBelt.states.xRuningBelt );
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_IN_PRINT );
			TEST_BUSY_CONDITION( gThicknessCtrl.status.MediaPosition.xMediaInside );
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the blocks to to in position");
			gSimMachine.Commands.Media.xContinuousMediaPresent = TRUE;
			TEST_BUSY_CONDITION( !gThicknessCtrl.status.MediaPosition.xMediaInside );
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Checking bars positioned properly when photocell 2 is detecting");
			TEST_BUSY_CONDITION( gBlock[1].Status.rMotorPosition != (gPhotoCells.parameters.rMediaThickness + gMachine.parSw.rMarginPrint));
			TEST_BUSY_CONDITION( gBlock[1].commands.xForcePreprintingPos );
			TEST_BUSY_CONDITION( !gAxis[gBlock[1].parameters.iMotorAxisIndex].Status.InPosition );
			gPhotoCells.Inputs.Signals.xPhotoCells[2] = TRUE;
			nextState();
			break;		

		case 6:
			strcpy(txStateDesc, "Reviewing position after sensor 2");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 5 ); //We'll wait xx scan cycle
			TEST_ASSERT_EQUAL_INT(gMachine.parSw.Media.rThickness + gPhotoCells.parameters.Sensors[3].rDistanceRelativeToFirstSensor + gPhotoCells.parameters.rOffsetPosition, 
				gBlock[1].Status.rMotorPosition);
			nextState();
			break;		
		
		case 7:
			strcpy(txStateDesc, "Checking bars positioned properly when photocells 3 and 2 are detecting");
			gPhotoCells.Inputs.Signals.xPhotoCells[3] = TRUE;
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 5 ); //We'll wait xx scan cycle
			TEST_BUSY_CONDITION( !gAxis[gBlock[1].parameters.iMotorAxisIndex].Status.InPosition );
			TEST_ASSERT_EQUAL_DOUBLE(gPhotoCells.parameters.rMediaThickness + gPhotoCells.parameters.Sensors[4].rDistanceRelativeToFirstSensor + gPhotoCells.parameters.rOffsetPosition, 
				gBlock[1].Status.rMotorPosition);
			gSimMachine.Commands.Media.xContinuousMediaPresent = FALSE;
			gPhotoCells.Inputs.Signals.xPhotoCells[2] = FALSE;
			gPhotoCells.Inputs.Signals.xPhotoCells[3] = FALSE;
			gMachine.In.Buttons.xReset = TRUE;
			iTestState = 0;
			TEST_DONE;
			break;
		
		default:
			break;
	}	
}

_TEST test_nSensorDetectionIncoherence(void)
{
	if (!gPhotoCells.status.xSensorsSeparatedInProcessDir)
	{	
		iTestState = 0;
		TEST_DONE;
	}
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_nSensorDetectionIncoherence");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
			gSimMachine.Commands.xToZero = TRUE;
			gMachine.In.xConsentL1Ok = TRUE;
			gBlock[2].parSw.xEnableToMovements = TRUE;
			gMachine.parSw.rBeltSpeedSetPoint = 50.0;
			gMachine.parSw.Media.rThickness = 2.0;
			gMachine.parSw.rMarginPrint = (gPhotoCells.parameters.Sensors[2].rDistanceRelativeToFirstSensor - gPhotoCells.parameters.rOffsetPosition);
			gMachine.parSw.Electronics.xRobotReadyL1 = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Going to Auto");
			gSimMachine.Commands.xToAuto = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;

		case 2:
			strcpy(txStateDesc, "Waiting to be in Cap");
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_IN_CAP );
			if(!gMachine.Pt.xControlledByLine ){
				gMachine.commandsSw.xStart_GI = TRUE;
			}
			else{
				gLine.Commands.Print = TRUE;
			}
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the belt to run");
			TEST_BUSY_CONDITION( !gBelt.states.xRuningBelt );
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_IN_PRINT );
			TEST_BUSY_CONDITION( gThicknessCtrl.status.MediaPosition.xMediaInside );
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Checking bars positioned properly when photocell 2 is detecting");
			TEST_BUSY_CONDITION( gBlock[1].Status.rMotorPosition != (gPhotoCells.parameters.rMediaThickness + gMachine.parSw.rMarginPrint));
			TEST_BUSY_CONDITION( gBlock[1].commands.xForcePreprintingPos );
			TEST_BUSY_CONDITION( !gAxis[gBlock[1].parameters.iMotorAxisIndex].Status.InPosition );
			gPhotoCells.Inputs.Signals.xPhotoCells[2] = FALSE;
			gPhotoCells.Inputs.Signals.xPhotoCells[3] = TRUE;
			nextState();
			break;		
		
		case 5:
			strcpy(txStateDesc, "Checking bars positioned properly when photocells 3 and 2 are detecting");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 5 ); //We'll wait xx scan cycle
			TEST_ASSERT(gPhotoCells.Alarms.xPhotoCellsDetectionIncoherence[3]);
			gPhotoCells.Inputs.Signals.xPhotoCells[2] = FALSE;
			gPhotoCells.Inputs.Signals.xPhotoCells[3] = FALSE;
			gMachine.In.Buttons.xReset = TRUE;
			iTestState = 0;
			TEST_DONE;
			break;
		
		default:
			break;
	}	
}

_TEST test_AutoSpeedFastActiveForBlockMotorWhilePrinting(void)
{
	if (!gPhotoCells.status.xInstalled || (!gBlock[1].parameters.Motor.xFastSpeedAllowed))
	{	
		iTestState = 0;
		TEST_DONE;
	}
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_AutoSpeedFastActiveForBlockMotorWhilePrinting");
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
			gSimMachine.Commands.xToZero = TRUE;
			gMachine.In.xConsentL1Ok = TRUE;
			gBlock[2].parSw.xEnableToMovements = TRUE;
			gMachine.parSw.rBeltSpeedSetPoint = 50.0;
			gMachine.parSw.Media.rThickness = 2.0;
			gMachine.parSw.rMarginPrint = (gPhotoCells.parameters.Sensors[2].rDistanceRelativeToFirstSensor - gPhotoCells.parameters.rOffsetPosition);
			gMachine.parSw.Electronics.xRobotReadyL1 = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Going to Auto");
			gSimMachine.Commands.xToAuto = TRUE;
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;

		case 2:
			strcpy(txStateDesc, "Waiting to be in Cap");
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_IN_CAP );
			if(!gMachine.Pt.xControlledByLine ){
				gMachine.commandsSw.xStart_GI = TRUE;
			}
			else{
				gLine.Commands.Print = TRUE;
			}
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Waiting the belt to run");
			TEST_BUSY_CONDITION( !gBelt.states.xRuningBelt );
			TEST_BUSY_CONDITION( gBlock[1].Status.PositionState != BLOCKP_IN_PRINT );
			TEST_BUSY_CONDITION( gThicknessCtrl.status.MediaPosition.xMediaInside );
			nextState();
			break;
		
		case 4:
			strcpy(txStateDesc, "Waiting the blocks to to in position");
			gSimMachine.Commands.Media.xContinuousMediaPresent = TRUE;
			TEST_BUSY_CONDITION( !gThicknessCtrl.status.MediaPosition.xMediaInside );
			nextState();
			break;
		
		case 5:
			strcpy(txStateDesc, "Checking bars positioned properly when photocell 2 is detecting");
			TEST_BUSY_CONDITION( gBlock[1].Status.rMotorPosition != (gPhotoCells.parameters.rMediaThickness + gMachine.parSw.rMarginPrint));
			TEST_BUSY_CONDITION( gBlock[1].commands.xForcePreprintingPos );
			TEST_BUSY_CONDITION( !gAxis[gBlock[1].parameters.iMotorAxisIndex].Status.InPosition );
			gPhotoCells.Inputs.Signals.xPhotoCells[2] = TRUE;
			TEST_ASSERT_EQUAL_INT(gMachine.parSw.Media.rThickness + gPhotoCells.parameters.Sensors[3].rDistanceRelativeToFirstSensor + gPhotoCells.parameters.rOffsetPosition, 
				gBlock[1].Status.rMotorPosition);
			nextState();
			break;		
		
		case 6:
			strcpy(txStateDesc, "Photocell 3 detecting");
			gPhotoCells.Inputs.Signals.xPhotoCells[3] = TRUE;
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 10 ); //We'll wait xx scan cycles
			TEST_ASSERT(gBlock[1].parameters.Motor.rDriveAutoSpeed == gBlock[1].parameters.Motor.rAutoSpeedMoveUpFast);
			gSimMachine.Commands.Media.xContinuousMediaPresent = FALSE;
			gPhotoCells.Inputs.Signals.xPhotoCells[2] = FALSE;
			gPhotoCells.Inputs.Signals.xPhotoCells[3] = FALSE;
			gMachine.In.Buttons.xReset = TRUE;
			iTestState = 0;
			TEST_DONE;
			break;
		
		default:
			break;
	}	
}



// This test is only for BM - To allow extract pieces using the belt if mounted media detected (due to the high weight of the media)
_TEST test_MountedTileAutoReset(void)
{
	TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
	strcpy(txTest, "test_MountedTileAutoReset");
	if (gMachine.Pt.xControlledByLine){
		iTestState = 0;
		//This 2 lines just for the last TestCase
		strcpy(txTest, "test_BeltTest Finished!! Congrats!");
		strcpy(txStateDesc, "--");
		
		TEST_DONE;        
	}
	if (strcmp(&txTest, &gSimMachine.Commands.LogTests.Text) != 0){
		strcpy(gSimMachine.Commands.LogTests.Text, txTest); gSimMachine.Commands.LogTests.xCommand = TRUE;		
	}
	switch (iTestState)
	{
		case 0:
			gSimMachine.Commands.xToZero = TRUE;
			gMachine.parSw.Media.rThickness = 12.0;	//10mm
			gMachine.parSw.rMarginPrint = 2.0;		//2mm >> 2mm is bars position
			gMachine.In.xConsentL1Ok = TRUE;
			gSimThickCtrl.Commands.xEmptyMediaTracking = TRUE;
			nextState();
			break;

		case 1:
			strcpy(txStateDesc, "Going to Zero");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xZero );
			nextState();
			break;

		case 2:
			gSimMachine.Commands.xToAuto = TRUE;
			nextState();
			break;

		case 3:
			strcpy(txStateDesc, "Going to Auto");
			TEST_BUSY_CONDITION( !gMachine.St.Mode.xAuto );
			nextState();
			break;

		case 4:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( !gBlock[1].Status.Position.xGoingToCap && !gBlock[1].Status.Position.xInCap ); //We'll wait xx scan cycles
			gMachine.commandsSw.xStart_GI = TRUE;
			nextState();
			break;

		case 5:
			strcpy(txStateDesc, "Starting the belt");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( !gBelt.states.xRuningBelt );
			nextState();
			break;
		
		case 6:
			strcpy(txStateDesc, "Raised Mounted tile alarm");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( !gThicknessCtrl.status.Belt.xBeltEmpty ); //To be sure the machine is receptive to a new mounted media signal

			if (gDing.State.xDingInstalled){
				if (gDing.Parameters.MountedDetectionType==THICKMOUNT_THICKNESS_RELATIVE){
					gDing.In.rHighDingMm = gDing.Parameters.rMediaThickness + gDing.Parameters.rOverThicknessToMounted + 1; //Raise the Alarm
				}
				else if(gDing.Parameters.MountedDetectionType==THICKMOUNT_ABSOLUTE){
					gDing.In.rHighDingMm = gDing.Parameters.rThicknessToMounted + 1; //Raise the Alarm
				}
			}
			else{
				TEST_BUSY_CONDITION(!gPhotoCells.status.xInPosition); //To active mounted alarm when photocell is positioned
				gPhotoCells.Inputs.Signals.xPhotoCells[1] = TRUE;
				gPhotoCells.Inputs.Signals.xPhotoCells[2] = TRUE;
				gPhotoCells.Inputs.Signals.xPhotoCells[3] = TRUE;
				gPhotoCells.Inputs.Signals.xPhotoCells[4] = (gPhotoCells.parameters.iSensorQuantity >3);
				gPhotoCells.Inputs.Signals.xPhotoCells[5] = (gPhotoCells.parameters.iSensorQuantity >4);
				gPhotoCells.Inputs.Signals.xPhotoCells[6] = (gPhotoCells.parameters.iSensorQuantity >5);
			}
			nextState();
			break;
		
		case 7:
			strcpy(txStateDesc, "Check alarm");
			TEST_BUSY_CONDITION( gMachine.St.exec.slow < exTimesPreSlow + 5 ); //We'll wait xx scan cycles
			TEST_ASSERT(gMachine.Al.Alarm.xAlarmMountedPiece);
			TEST_ASSERT(gMachine.St.AutoMode.xStop);
			if(gPhotoCells.status.xInstalled){
				gPhotoCells.Inputs.Signals.xPhotoCells[1] = FALSE;
				gPhotoCells.Inputs.Signals.xPhotoCells[2] = FALSE;
				gPhotoCells.Inputs.Signals.xPhotoCells[3] = FALSE;
				gPhotoCells.Inputs.Signals.xPhotoCells[4] = FALSE;
				gPhotoCells.Inputs.Signals.xPhotoCells[5] = FALSE;
				gPhotoCells.Inputs.Signals.xPhotoCells[6] = FALSE;
			}
			else{
				gDing.In.rHighDingMm = 0.0; //Remove the Alarm
			}
			nextState();
			break;
		
		case 8:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			strcpy(txStateDesc, "Reseting alarm");
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 9:
			TEST_BUSY_CONDITION(gMachine.Al.Alarm.xAlarmMountedPiece); //We'll wait xx scan cycles
			gMachine.In.Buttons.xReset = FALSE;
			nextState();
			break;
		
		case 10:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			gMachine.commandsSw.xStart_GI = TRUE;
			nextState();
			break;
		
		case 11:
			strcpy(txStateDesc, "Starting the belt");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( !gBelt.states.xRuningBelt );
			nextState();
			break;
		
		case 12:
			strcpy(txStateDesc, "Remove Mounted Media");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 500 ); //We'll wait xx scan cycles
			
			if (gDing.State.xDingInstalled){
				gDing.In.rHighDingMm = 0.0; //Remove the Alarm
			}
			else{
				TEST_BUSY_CONDITION(!gPhotoCells.status.xInPosition); //To active mounted alarm when photocell is positioned
				gPhotoCells.Inputs.Signals.xPhotoCells[gPhotoCells.parameters.iSensorQuantity] = FALSE;
			}
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			nextState();
			break;
		
		case 13:
			strcpy(txStateDesc, "Wait Mounted Media Outside");
			TEST_BUSY_CONDITION( gThicknessCtrl.status.MediaPosition.xMountedMediaInside ); //We'll wait xx scan cycles
			nextState();
			break;
		
		case 14:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			if (gDing.State.xDingInstalled){
			TEST_ASSERT(!gDing.Alarms.xMountedTile);
			}
			else{
			TEST_ASSERT(!gPhotoCells.Alarms.xMountedTile);
			}
			nextState();
			break;
			
		case 15:
			strcpy(txStateDesc, "Raised Mounted tile alarm");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			
			if (gDing.State.xDingInstalled){
				if (gDing.Parameters.MountedDetectionType==THICKMOUNT_THICKNESS_RELATIVE){
					gDing.In.rHighDingMm = gDing.Parameters.rMediaThickness + gDing.Parameters.rOverThicknessToMounted + 1; //Raise the Alarm
				}
				else if(gDing.Parameters.MountedDetectionType==THICKMOUNT_ABSOLUTE){
					gDing.In.rHighDingMm = gDing.Parameters.rThicknessToMounted + 1; //Raise the Alarm
				}
			}
			else{
				TEST_BUSY_CONDITION(!gPhotoCells.status.xInPosition); //To active mounted alarm when photocell is positioned
				gPhotoCells.Inputs.Signals.xPhotoCells[1] = TRUE;
				gPhotoCells.Inputs.Signals.xPhotoCells[2] = TRUE;
				gPhotoCells.Inputs.Signals.xPhotoCells[3] = TRUE;
				gPhotoCells.Inputs.Signals.xPhotoCells[4] = (gPhotoCells.parameters.iSensorQuantity >3);
				gPhotoCells.Inputs.Signals.xPhotoCells[5] = (gPhotoCells.parameters.iSensorQuantity >4);
				gPhotoCells.Inputs.Signals.xPhotoCells[6] = (gPhotoCells.parameters.iSensorQuantity >5);
			}
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			nextState();
			break;
			
		case 16:
			strcpy(txStateDesc, "Check alarm stop");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 10 ); //We'll wait xx scan cycles
			TEST_ASSERT(gMachine.Al.Alarm.xAlarmMountedPiece);
			TEST_ASSERT(gMachine.St.AutoMode.xStop);
			
			if(gPhotoCells.status.xInstalled){
				gPhotoCells.Inputs.Signals.xPhotoCells[1] = FALSE;
				gPhotoCells.Inputs.Signals.xPhotoCells[2] = FALSE;
				gPhotoCells.Inputs.Signals.xPhotoCells[3] = FALSE;
				gPhotoCells.Inputs.Signals.xPhotoCells[4] = FALSE;
				gPhotoCells.Inputs.Signals.xPhotoCells[5] = FALSE;
				gPhotoCells.Inputs.Signals.xPhotoCells[6] = FALSE;
			}
			nextState();
			break;
		
		case 17:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 3 ); //We'll wait xx scan cycles
			strcpy(txStateDesc, "Reseting alarm");
			gMachine.In.Buttons.xReset = TRUE;
			nextState();
			break;
		
		case 18:
			TEST_BUSY_CONDITION(gMachine.Al.Alarm.xAlarmMountedPiece); //We'll wait xx scan cycles
			gMachine.In.Buttons.xReset = FALSE;
			nextState();
			break;
		
		case 19:
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			gMachine.commandsSw.xStart_GI = TRUE;
			nextState();
			break;
		
		case 20:
			strcpy(txStateDesc, "Starting the belt");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 5 ); //We'll wait xx scan cycles
			TEST_BUSY_CONDITION( !gBelt.states.xRuningBelt );
			nextState();
			break;
		
		case 21:
			strcpy(txStateDesc, "Remove Mounted Media");
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 100 ); //We'll wait xx scan cycles
			
			if (gDing.State.xDingInstalled){
				gDing.In.rHighDingMm = 0.0; //Raise the Alarm
			}
			else{
				TEST_BUSY_CONDITION(!gPhotoCells.status.xInPosition); //To active mounted alarm when photocell is positioned
				gPhotoCells.Inputs.Signals.xPhotoCells[gPhotoCells.parameters.iSensorQuantity] = FALSE;
			}
			TEST_BUSY_CONDITION( gMachine.St.exec.fast < exTimesPreFast + 8 ); //We'll wait xx scan cycles
			nextState();
			break;
			
		case 22:
			strcpy(txStateDesc, "Wait Mounted Media Outside");
			TEST_BUSY_CONDITION( gThicknessCtrl.status.MediaPosition.xMountedMediaInside ); //We'll wait xx scan cycles
			gMachine.parSw.Media.rThickness = 2.0;
			gMachine.parSw.rMarginPrint = 2.0;
			iTestState = 0;
			
			//This 2 lines just for the last TestCase
			strcpy(txTest, "test_BeltTest Finished!! Congrats!");
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
LastUpdated: 2024-01-26 13:09:16Z
By B+R UnitTest Helper Version: 2.0.1.59
*/
UNITTEST_FIXTURES(fixtures)
{
	new_TestFixture("test_ResetMountedTile", test_ResetMountedTile), 
	new_TestFixture("test_GreenButtonAfterPause", test_GreenButtonAfterPause), 
	new_TestFixture("test_PauseWithGreenButton", test_PauseWithGreenButton), 
	new_TestFixture("test_RunBeltWithP4_2BK12Bar_1BlockDisabled", test_RunBeltWithP4_2BK12Bar_1BlockDisabled), 
	new_TestFixture("test_ExternalCleanJust1Block", test_ExternalCleanJust1Block), 
	new_TestFixture("test_RaiseBlocksWithSlowSpeed", test_RaiseBlocksWithSlowSpeed), 
	new_TestFixture("test_RaiseBlocksWithStoppedMedia", test_RaiseBlocksWithStoppedMedia), 
	new_TestFixture("test_RaiseBlocksWithAlarmStop", test_RaiseBlocksWithAlarmStop), 
	new_TestFixture("test_RaiseBlocksWithBeltAlarmStop", test_RaiseBlocksWithBeltAlarmStop), 
	new_TestFixture("test_GoPrintInStop", test_GoPrintInStop), 
	new_TestFixture("test_StopWithMountedMediaBypass", test_StopWithMountedMediaBypass), 
	new_TestFixture("test_StopWithNotReferenceAnalogThickness", test_StopWithNotReferenceAnalogThickness), 
	new_TestFixture("test_FilterToNotActiveNotLoadedImageAlarm", test_FilterToNotActiveNotLoadedImageAlarm), 
	new_TestFixture("test_FilterForNotLoadedImageAlarm", test_FilterForNotLoadedImageAlarm), 
	new_TestFixture("test_MediaIncoherenceAlarm", test_MediaIncoherenceAlarm), 
	new_TestFixture("test_NoStopInBypassWhenUpperSafetyActivated", test_NoStopInBypassWhenUpperSafetyActivated), 
	new_TestFixture("test_StopWithWrongDingPosition", test_StopWithWrongDingPosition), 
	new_TestFixture("test_CheckMediaNOK", test_CheckMediaNOK), 
	new_TestFixture("test_nSensorBarPositionCalculation", test_nSensorBarPositionCalculation), 
	new_TestFixture("test_nSensorDetectionIncoherence", test_nSensorDetectionIncoherence), 
	new_TestFixture("test_AutoSpeedFastActiveForBlockMotorWhilePrinting", test_AutoSpeedFastActiveForBlockMotorWhilePrinting), 
	new_TestFixture("test_MountedTileAutoReset", test_MountedTileAutoReset), 
};

UNITTEST_CALLER_COMPLETE_EXPLICIT(BeltTests, "BeltTests", 0, 0, fixtures, 0, 0, 0);

