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

_LOCAL UINT sensorPosition;

#define FALSE 0
#define TRUE 1


void nextState(){
	exTimesPreFast = gMachine.St.exec.fast;
	exTimesPreSlow = gMachine.St.exec.slow;
	iTestState++;
	TimeLast = clock_ms();	
}

void ResetTrackingArrays(){
	for (iIndexArray = 0; iIndexArray < THICK_MAX_UPDATE_VALUES; iIndexArray++)	{
		xTestMediaDetectionValuesL1[iIndexArray] = FALSE;
	}
	for (iIndexArray = 0; iIndexArray < iMAXTRACKINGARRAY; iIndexArray++)	{
		TestMediaTracking[iIndexArray] = FALSE;
		TestBoolMediaTracking[iIndexArray] = FALSE;
	}
	sensorPosition = 0;
}

void ResetTrackingMediaInside(){
	for (iIndexArray = 0; iIndexArray < THICK_MEDIATRACKING_MAX_MEDIA; iIndexArray++)	{
		TestMediaTrackingInside[iIndexArray].HeadPosition = 0;
		TestMediaTrackingInside[iIndexArray].TailPosition = 0;
		TestMediaTrackingInside[iIndexArray].iIndexMediaEnergy = 0;
		TestMediaTrackingInside[iIndexArray].pMediaEnery = 0;
		TestMediaTrackingInside[iIndexArray].Media = MediaConfigReseted;
	}
	for (iIndexArray = 0; iIndexArray < THICKENERGY_MAX_LAMPS; iIndexArray++)	{
		IntensityOutput[iIndexArray] = 0;
	}
	//USINT[0..THICKENERGY_MAX_PROCESS_ITEMS,0..THICKENERGY_MAX_CROSS_ITEMS]
	for (iIndexProcess = 0; iIndexProcess <= THICKENERGY_MAX_PROCESS_ITEMS; iIndexProcess++)	{
		for (iIndexCross = 0; iIndexCross <= THICKENERGY_MAX_CROSS_ITEMS; iIndexCross++)	{
			EnergyData.iPower[iIndexProcess][iIndexCross] = 0;
		}
	}
}

_TEST test_LoadMediaFromFastDataLine(void)
{
	strcpy(txTest, "test_LoadMediaFromFastDataLine");
	
//TESTS WITH NO GAP
	
	// 4 Inputs and 5 outputs (v)
	ResetTrackingArrays();
	xTestMediaDetectionValuesL1[0] = TRUE;
	xTestMediaDetectionValuesL1[1] = TRUE;
	xTestMediaDetectionValuesL1[2] = TRUE;
	xTestMediaDetectionValuesL1[3] = TRUE;
	
	LoadMediaFromFastDataLine(&xTestMediaDetectionValuesL1,4 , INDEXTRACKING_L1, 5, sensorPosition, &TestMediaTracking);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 0]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 1]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 2]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 3]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 4]); //If variable is TRUE, the test is correct
	
	LoadMediaFromFastDataBool(&xTestMediaDetectionValuesL1, 4, 5, sensorPosition, &TestBoolMediaTracking);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 0]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 1]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 2]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 3]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 4]);
	
	
	// 4 Inputs and 6 outputs (v)
	ResetTrackingArrays();
	xTestMediaDetectionValuesL1[0] = TRUE;
	xTestMediaDetectionValuesL1[1] = TRUE;
	xTestMediaDetectionValuesL1[2] = TRUE;
	xTestMediaDetectionValuesL1[3] = TRUE;
	
	LoadMediaFromFastDataLine(&xTestMediaDetectionValuesL1, 4, INDEXTRACKING_L1, 6, 0, &TestMediaTracking);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 0]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 1]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 2]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 3]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 4]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 5]); //If variable is TRUE, the test is correct
	
	LoadMediaFromFastDataBool(&xTestMediaDetectionValuesL1, 4, 6, sensorPosition, &TestBoolMediaTracking);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 0]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 1]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 2]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 3]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 4]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 5]);

//TESTS WITH ONLY ONE GAP
	
	// 4 Inputs and 6 outputs 1 gap
	ResetTrackingArrays();
	xTestMediaDetectionValuesL1[0] = TRUE;
	xTestMediaDetectionValuesL1[1] = FALSE;
	xTestMediaDetectionValuesL1[2] = TRUE;
	xTestMediaDetectionValuesL1[3] = TRUE;
	
	LoadMediaFromFastDataLine(&xTestMediaDetectionValuesL1, 4, INDEXTRACKING_L1, 6, 0, &TestMediaTracking);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 0]);
			TEST_ASSERT(!TestMediaTracking[sensorPosition + 1]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 2]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 3]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 4]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 5]); //If variable is TRUE, the test is correct	
	
	LoadMediaFromFastDataBool(&xTestMediaDetectionValuesL1, 4, 6, sensorPosition, &TestBoolMediaTracking);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 0]);
			TEST_ASSERT(!TestBoolMediaTracking[sensorPosition + 1]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 2]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 3]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 4]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 5]); //If variable is TRUE, the test is correct	

	
	// 3 Inputs and 7 outputs 1 gap
	ResetTrackingArrays();
	xTestMediaDetectionValuesL1[0] = TRUE;
	xTestMediaDetectionValuesL1[1] = FALSE;
	xTestMediaDetectionValuesL1[2] = TRUE;
	LoadMediaFromFastDataLine(&xTestMediaDetectionValuesL1, 3, INDEXTRACKING_L1, 7, sensorPosition, &TestMediaTracking);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 0]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 1]);
			TEST_ASSERT(!TestMediaTracking[sensorPosition + 2]);
			TEST_ASSERT(!TestMediaTracking[sensorPosition + 3]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 4]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 5]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 6]); //If a 0 appears somewhere, the test is correct
	
	LoadMediaFromFastDataBool(&xTestMediaDetectionValuesL1, 3, 7, sensorPosition, &TestBoolMediaTracking);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 0]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 1]);
			TEST_ASSERT(!TestBoolMediaTracking[sensorPosition + 2]);
			TEST_ASSERT(!TestBoolMediaTracking[sensorPosition + 3]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 4]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 5]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 6]); //If a 0 appears somewhere, the test is correct
	
	
	// 6 Inputs and 4 outputs 1 gap
	ResetTrackingArrays();
	xTestMediaDetectionValuesL1[0] = TRUE;
	xTestMediaDetectionValuesL1[1] = FALSE;
	xTestMediaDetectionValuesL1[2] = TRUE;
	xTestMediaDetectionValuesL1[3] = TRUE;
	xTestMediaDetectionValuesL1[4] = TRUE;
	xTestMediaDetectionValuesL1[5] = TRUE;
	
	LoadMediaFromFastDataLine(&xTestMediaDetectionValuesL1, 6, INDEXTRACKING_L1, 4, 0, &TestMediaTracking);
			TEST_ASSERT(!TestMediaTracking[sensorPosition + 0]);
			TEST_ASSERT(!TestMediaTracking[sensorPosition + 1]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 2]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 3]);
	
	LoadMediaFromFastDataBool(&xTestMediaDetectionValuesL1, 6, 4, sensorPosition, &TestBoolMediaTracking);
			TEST_ASSERT(!TestBoolMediaTracking[sensorPosition + 0]);
			TEST_ASSERT(!TestBoolMediaTracking[sensorPosition + 1]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 2]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 3]);
	
	
	// 7 Inputs and 3 outputs
	ResetTrackingArrays();
	xTestMediaDetectionValuesL1[0] = TRUE;
	xTestMediaDetectionValuesL1[1] = TRUE;
	xTestMediaDetectionValuesL1[2] = TRUE;
	xTestMediaDetectionValuesL1[3] = TRUE;
	xTestMediaDetectionValuesL1[4] = FALSE;
	xTestMediaDetectionValuesL1[5] = TRUE;	
	xTestMediaDetectionValuesL1[6] = TRUE;
	
	LoadMediaFromFastDataLine(&xTestMediaDetectionValuesL1, 7, INDEXTRACKING_L1, 3, sensorPosition, &TestMediaTracking);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 0]);
			TEST_ASSERT(!TestMediaTracking[sensorPosition + 1]);
			TEST_ASSERT(!TestMediaTracking[sensorPosition + 2]); //If a 0 appears somewhere, the test is correct
	
	LoadMediaFromFastDataBool(&xTestMediaDetectionValuesL1, 7, 3, sensorPosition, &TestBoolMediaTracking);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 0]);
			TEST_ASSERT(!TestBoolMediaTracking[sensorPosition + 1]);
			TEST_ASSERT(!TestBoolMediaTracking[sensorPosition + 2]); //If a 0 appears somewhere, the test is correct
	

	// 10 Inputs and 2 outputs
	ResetTrackingArrays();
	xTestMediaDetectionValuesL1[0] = TRUE;
	xTestMediaDetectionValuesL1[1] = TRUE;
	xTestMediaDetectionValuesL1[2] = TRUE;
	xTestMediaDetectionValuesL1[3] = TRUE;
	xTestMediaDetectionValuesL1[4] = TRUE;
	xTestMediaDetectionValuesL1[5] = TRUE;	
	xTestMediaDetectionValuesL1[6] = TRUE;
	xTestMediaDetectionValuesL1[7] = FALSE;
	xTestMediaDetectionValuesL1[8] = TRUE;
	xTestMediaDetectionValuesL1[9] = TRUE;
	
	LoadMediaFromFastDataLine(&xTestMediaDetectionValuesL1, 10, INDEXTRACKING_L1, 2, sensorPosition, &TestMediaTracking);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 0]);
			TEST_ASSERT(!TestMediaTracking[sensorPosition + 1]); //If a 0 appears somewhere, the test is correct 

	LoadMediaFromFastDataBool(&xTestMediaDetectionValuesL1, 10, 2, sensorPosition, &TestBoolMediaTracking);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 0]);
			TEST_ASSERT(!TestBoolMediaTracking[sensorPosition + 1]); //If a 0 appears somewhere, the test is correct 
	
	
	// 2 Inputs and 10 outputs
	ResetTrackingArrays();
	xTestMediaDetectionValuesL1[0] = TRUE;
	xTestMediaDetectionValuesL1[1] = FALSE;
	
	LoadMediaFromFastDataLine(&xTestMediaDetectionValuesL1, 2, INDEXTRACKING_L1, 10, sensorPosition, &TestMediaTracking);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 0]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 1]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 2]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 3]);
			TEST_ASSERT(!TestMediaTracking[sensorPosition + 4]);
			TEST_ASSERT(!TestMediaTracking[sensorPosition + 5]);
			TEST_ASSERT(!TestMediaTracking[sensorPosition + 6]);
			TEST_ASSERT(!TestMediaTracking[sensorPosition + 7]);
			TEST_ASSERT(!TestMediaTracking[sensorPosition + 8]);
			TEST_ASSERT(!TestMediaTracking[sensorPosition + 9] ); //If a 0 appears somewhere, the test is correct 
	
	LoadMediaFromFastDataBool(&xTestMediaDetectionValuesL1, 2, 10, sensorPosition, &TestBoolMediaTracking);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 0]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 1]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 2]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 3]);
			TEST_ASSERT(!TestBoolMediaTracking[sensorPosition + 4]);
			TEST_ASSERT(!TestBoolMediaTracking[sensorPosition + 5]);
			TEST_ASSERT(!TestBoolMediaTracking[sensorPosition + 6]);
			TEST_ASSERT(!TestBoolMediaTracking[sensorPosition + 7]);
			TEST_ASSERT(!TestBoolMediaTracking[sensorPosition + 8]);
			TEST_ASSERT(!TestBoolMediaTracking[sensorPosition + 9] ); //If a 0 appears somewhere, the test is correct 
	
	
	// 2 Inputs and 1 outputs
	ResetTrackingArrays();
	xTestMediaDetectionValuesL1[0] = TRUE;
	xTestMediaDetectionValuesL1[1] = FALSE;
	
	LoadMediaFromFastDataLine(&xTestMediaDetectionValuesL1, 2, INDEXTRACKING_L1, 1, sensorPosition, &TestMediaTracking);
	TEST_ASSERT(!TestMediaTracking[sensorPosition + 0] ); //If a 0 appears somewhere, the test is correct 
	LoadMediaFromFastDataBool(&xTestMediaDetectionValuesL1, 2, 1, sensorPosition, &TestBoolMediaTracking);
	TEST_ASSERT(!TestBoolMediaTracking[sensorPosition + 0] ); //If a 0 appears somewhere, the test is correct 
	
	
	// 5 inputs to 9 outputs
	ResetTrackingArrays();
	xTestMediaDetectionValuesL1[0] = TRUE;
	xTestMediaDetectionValuesL1[1] = FALSE;
	xTestMediaDetectionValuesL1[2] = TRUE;
	xTestMediaDetectionValuesL1[3] = TRUE;
	xTestMediaDetectionValuesL1[4] = TRUE;
	
	LoadMediaFromFastDataLine(&xTestMediaDetectionValuesL1, 5, INDEXTRACKING_L1, 9, sensorPosition, &TestMediaTracking);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 0]);
			TEST_ASSERT(!TestMediaTracking[sensorPosition + 1]);
			TEST_ASSERT(!TestMediaTracking[sensorPosition + 2]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 3]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 4]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 5]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 6]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 7]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 8] ); //If a 0 appears somewhere, the test is correct
	
	LoadMediaFromFastDataBool(&xTestMediaDetectionValuesL1, 5, 9, sensorPosition, &TestBoolMediaTracking);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 0]);
			TEST_ASSERT(!TestBoolMediaTracking[sensorPosition + 1]);
			TEST_ASSERT(!TestBoolMediaTracking[sensorPosition + 2]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 3]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 4]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 5]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 6]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 7]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 8] ); //If a 0 appears somewhere, the test is correct
	
	
	//9 inputs to 5 outputs
	ResetTrackingArrays();
	xTestMediaDetectionValuesL1[0] = TRUE;
	xTestMediaDetectionValuesL1[1] = TRUE;
	xTestMediaDetectionValuesL1[2] = TRUE;
	xTestMediaDetectionValuesL1[3] = TRUE;
	xTestMediaDetectionValuesL1[4] = FALSE;
	xTestMediaDetectionValuesL1[5] = TRUE;	
	xTestMediaDetectionValuesL1[6] = TRUE;
	xTestMediaDetectionValuesL1[7] = TRUE;
	xTestMediaDetectionValuesL1[8] = TRUE;
	
	LoadMediaFromFastDataLine(&xTestMediaDetectionValuesL1, 9, INDEXTRACKING_L1, 5, sensorPosition, &TestMediaTracking);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 0]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 1]);
			TEST_ASSERT(!TestMediaTracking[sensorPosition + 2]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 3]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 4]); //If a 0 appears somewhere, the test is correct
	
	LoadMediaFromFastDataBool(&xTestMediaDetectionValuesL1, 9, 5, sensorPosition, &TestBoolMediaTracking);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 0]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 1]);
			TEST_ASSERT(!TestBoolMediaTracking[sensorPosition + 2]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 3]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 4]); //If a 0 appears somewhere, the test is correct

	
	
	//7 inputs to 6 outputs
	ResetTrackingArrays();
	xTestMediaDetectionValuesL1[0] = TRUE;
	xTestMediaDetectionValuesL1[1] = TRUE;
	xTestMediaDetectionValuesL1[2] = TRUE;
	xTestMediaDetectionValuesL1[3] = TRUE;
	xTestMediaDetectionValuesL1[4] = FALSE;
	xTestMediaDetectionValuesL1[5] = TRUE;	
	xTestMediaDetectionValuesL1[6] = TRUE;
	
	LoadMediaFromFastDataLine(&xTestMediaDetectionValuesL1, 7, INDEXTRACKING_L1, 6, sensorPosition, &TestMediaTracking);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 0]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 1]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 2]);
			TEST_ASSERT(!TestMediaTracking[sensorPosition + 3]);
			TEST_ASSERT(!TestMediaTracking[sensorPosition + 4]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 5]); //If variable is TRUE, the test is correct
	
	LoadMediaFromFastDataBool(&xTestMediaDetectionValuesL1, 7, 6, sensorPosition, &TestBoolMediaTracking);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 0]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 1]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 2]);
			TEST_ASSERT(!TestBoolMediaTracking[sensorPosition + 3]);
			TEST_ASSERT(!TestBoolMediaTracking[sensorPosition + 4]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 5]); //If variable is TRUE, the test is correct
	
	
	
	//6 inputs to 7 outputs
	ResetTrackingArrays();
	xTestMediaDetectionValuesL1[0] = TRUE;
	xTestMediaDetectionValuesL1[1] = TRUE;
	xTestMediaDetectionValuesL1[2] = FALSE;
	xTestMediaDetectionValuesL1[3] = TRUE;
	xTestMediaDetectionValuesL1[4] = TRUE;
	xTestMediaDetectionValuesL1[5] = TRUE;	
	
	LoadMediaFromFastDataLine(&xTestMediaDetectionValuesL1, 6, INDEXTRACKING_L1, 7, sensorPosition, &TestMediaTracking);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 0]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 1]);
			TEST_ASSERT(!TestMediaTracking[sensorPosition + 2]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 3]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 4]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 5]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 6]); //If variable is TRUE, the test is correct
	
	LoadMediaFromFastDataBool(&xTestMediaDetectionValuesL1, 6, 7, sensorPosition, &TestBoolMediaTracking);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 0]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 1]);
			TEST_ASSERT(!TestBoolMediaTracking[sensorPosition + 2]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 3]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 4]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 5]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 6]); //If variable is TRUE, the test is correct
	
	
	
	
	//10 to 1 (limit case)
	ResetTrackingArrays();
	xTestMediaDetectionValuesL1[0] = TRUE;
	xTestMediaDetectionValuesL1[1] = TRUE;
	xTestMediaDetectionValuesL1[2] = TRUE;
	xTestMediaDetectionValuesL1[3] = TRUE;
	xTestMediaDetectionValuesL1[4] = FALSE;
	xTestMediaDetectionValuesL1[5] = TRUE;	
	xTestMediaDetectionValuesL1[6] = TRUE;
	xTestMediaDetectionValuesL1[7] = TRUE;
	xTestMediaDetectionValuesL1[8] = TRUE;
	xTestMediaDetectionValuesL1[9] = TRUE;
	
	LoadMediaFromFastDataLine(&xTestMediaDetectionValuesL1, 10, INDEXTRACKING_L1, 1, sensorPosition, &TestMediaTracking);
			TEST_ASSERT(!TestMediaTracking[sensorPosition + 0]);//a 0 must appear 
	LoadMediaFromFastDataBool(&xTestMediaDetectionValuesL1, 10, 1, sensorPosition, &TestBoolMediaTracking);
			TEST_ASSERT(!TestBoolMediaTracking[sensorPosition + 0]);//a 0 must appear
	
	
	
	//10 to 3 with one gap
	ResetTrackingArrays();
	xTestMediaDetectionValuesL1[0] = TRUE;
	xTestMediaDetectionValuesL1[1] = TRUE;
	xTestMediaDetectionValuesL1[2] = TRUE;
	xTestMediaDetectionValuesL1[3] = TRUE;
	xTestMediaDetectionValuesL1[4] = TRUE;
	xTestMediaDetectionValuesL1[5] = TRUE;	
	xTestMediaDetectionValuesL1[6] = TRUE;
	xTestMediaDetectionValuesL1[7] = FALSE;
	xTestMediaDetectionValuesL1[8] = TRUE;
	xTestMediaDetectionValuesL1[9] = TRUE;
	
	LoadMediaFromFastDataLine(&xTestMediaDetectionValuesL1, 10, INDEXTRACKING_L1, 3, sensorPosition, &TestMediaTracking);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 0]);
			TEST_ASSERT(TestMediaTracking[sensorPosition + 1]);
			TEST_ASSERT(!TestMediaTracking[sensorPosition + 2]);//a 0 must appear 
	
	LoadMediaFromFastDataBool(&xTestMediaDetectionValuesL1, 10, 3, sensorPosition, &TestBoolMediaTracking);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 0]);
			TEST_ASSERT(TestBoolMediaTracking[sensorPosition + 1]);
			TEST_ASSERT(!TestBoolMediaTracking[sensorPosition + 2]);//a 0 must appear
	
	
	//This 2 lines just for the last TestCase
	strcpy(txTest, "test_TestCase Finished!! Congrats!");
	strcpy(txStateDesc, "--");
	TEST_DONE;
}


_TEST test_RevMediaTrackingEnergyInPos(void)
{
	strcpy(txTest, "test_RevMediaTrackingEnergyInPos");
	
	//Dry just in one side. Image displaced
	ResetTrackingMediaInside();
	TestMediaTrackingInside[0].HeadPosition = 2;
	TestMediaTrackingInside[0].TailPosition = 0;
	TestMediaTrackingInside[0].pMediaEnery = &EnergyData;
	
	EnergyData.iPower[0][0] = 100;
	
	RevMediaTrackingEnergyInPos(&TestMediaTrackingInside, 1,
		1, 2,
		48, 1400.0/48.0, -1400.0/2, 0,
		0, IntensityOutput);	
	TEST_ASSERT(IntensityOutput[24] == 100);
	
	//Dry just in one side. Image centered
	ResetTrackingMediaInside();
	TestMediaTrackingInside[0].HeadPosition = 2;
	TestMediaTrackingInside[0].TailPosition = 0;
	TestMediaTrackingInside[0].pMediaEnery = &EnergyData;
	TestMediaTrackingInside[0].Media.rLength = 100;
	TestMediaTrackingInside[0].Media.rWidth = 1400;
	TestMediaTrackingInside[0].Media.rCrossOffset = -700;
	TestMediaTrackingInside[0].Media.rDocLength = 100;
	TestMediaTrackingInside[0].Media.rDocWidth = 1400;
	TestMediaTrackingInside[0].Media.rDocCrossOffset = -700;
	
	EnergyData.iPower[0][0] = 100;
	
	RevMediaTrackingEnergyInPos(&TestMediaTrackingInside, 1,
		1, 2,
		48, 1400.0/48.0, -1400.0/2, 0,
		0, IntensityOutput);	
	TEST_ASSERT(IntensityOutput[48] == 100);

	
	//Dry just in one side. Image centered
	ResetTrackingMediaInside();
	TestMediaTrackingInside[0].HeadPosition = 2;
	TestMediaTrackingInside[0].TailPosition = 0;
	TestMediaTrackingInside[0].pMediaEnery = &EnergyData;
	TestMediaTrackingInside[0].Media.rLength = 100;
	TestMediaTrackingInside[0].Media.rWidth = 1400;
	TestMediaTrackingInside[0].Media.rCrossOffset = -700;
	TestMediaTrackingInside[0].Media.rDocLength = 100;
	TestMediaTrackingInside[0].Media.rDocWidth = 1400;
	TestMediaTrackingInside[0].Media.rDocCrossOffset = -700;
	
	EnergyData.iPower[0][139] = 100;
	
	RevMediaTrackingEnergyInPos(&TestMediaTrackingInside, 1,
		1, 2,
		48, 1400.0/48.0, -1400.0/2, 0,
		0, IntensityOutput);	
	TEST_ASSERT(IntensityOutput[1] == 100);
	

	//Dry in the center. Image centered. Without overlap
	ResetTrackingMediaInside();
	TestMediaTrackingInside[0].HeadPosition = 2;
	TestMediaTrackingInside[0].TailPosition = 0;
	TestMediaTrackingInside[0].pMediaEnery = &EnergyData;
	TestMediaTrackingInside[0].Media.rLength = 100;
	TestMediaTrackingInside[0].Media.rWidth = 1400;
	TestMediaTrackingInside[0].Media.rCrossOffset = -700;
	TestMediaTrackingInside[0].Media.rDocLength = 100;
	TestMediaTrackingInside[0].Media.rDocWidth = 1400;
	TestMediaTrackingInside[0].Media.rDocCrossOffset = -700;
	
	EnergyData.iPower[0][69] = 100;
	EnergyData.iPower[0][70] = 100;
	EnergyData.iPower[0][71] = 100;
	
	RevMediaTrackingEnergyInPos(&TestMediaTrackingInside, 1,
		1, 2,
		48, 1400.0/48.0, -1400.0/2, 0,
		0, IntensityOutput);	
	TEST_ASSERT(IntensityOutput[23] == 0);
	TEST_ASSERT(IntensityOutput[24] == 100);
	TEST_ASSERT(IntensityOutput[25] == 100);
	TEST_ASSERT(IntensityOutput[26] == 0);


	//Dry in the center. Image centered. WITH overlap
	ResetTrackingMediaInside();
	TestMediaTrackingInside[0].HeadPosition = 2;
	TestMediaTrackingInside[0].TailPosition = 0;
	TestMediaTrackingInside[0].pMediaEnery = &EnergyData;
	TestMediaTrackingInside[0].Media.rLength = 100;
	TestMediaTrackingInside[0].Media.rWidth = 1400;
	TestMediaTrackingInside[0].Media.rCrossOffset = -700;
	TestMediaTrackingInside[0].Media.rDocLength = 100;
	TestMediaTrackingInside[0].Media.rDocWidth = 1400;
	TestMediaTrackingInside[0].Media.rDocCrossOffset = -700;
	
	EnergyData.iPower[0][69] = 100;
	EnergyData.iPower[0][70] = 100;
	EnergyData.iPower[0][71] = 100;
	
	RevMediaTrackingEnergyInPos(&TestMediaTrackingInside, 1,
		1, 2,
		48, 1400.0/48.0, -1400.0/2, 10,
		0, IntensityOutput);	
	TEST_ASSERT(IntensityOutput[22] == 0);
	TEST_ASSERT(IntensityOutput[23] == 100);
	TEST_ASSERT(IntensityOutput[24] == 100);
	TEST_ASSERT(IntensityOutput[25] == 100);
	TEST_ASSERT(IntensityOutput[26] == 0);

	
	//Dry in the center. Image centered. Without overlap. SAW
	ResetTrackingMediaInside();
	TestMediaTrackingInside[0].HeadPosition = 2;
	TestMediaTrackingInside[0].TailPosition = 0;
	TestMediaTrackingInside[0].pMediaEnery = &EnergyData;
	TestMediaTrackingInside[0].Media.rLength = 100;
	TestMediaTrackingInside[0].Media.rWidth = 1400;
	TestMediaTrackingInside[0].Media.rCrossOffset = -700;
	TestMediaTrackingInside[0].Media.rDocLength = 100;
	TestMediaTrackingInside[0].Media.rDocWidth = 1400;
	TestMediaTrackingInside[0].Media.rDocCrossOffset = -700;
	
	EnergyData.iPower[0][57] = 40;
	EnergyData.iPower[0][58] = 45;
	EnergyData.iPower[0][59] = 50;
	EnergyData.iPower[0][60] = 55;
	EnergyData.iPower[0][61] = 60;
	EnergyData.iPower[0][62] = 65;
	EnergyData.iPower[0][63] = 70;
	EnergyData.iPower[0][64] = 75;
	EnergyData.iPower[0][65] = 80;
	EnergyData.iPower[0][66] = 85;
	EnergyData.iPower[0][67] = 90;
	EnergyData.iPower[0][68] = 95;
	EnergyData.iPower[0][69] = 100;
	EnergyData.iPower[0][70] = 100;
	EnergyData.iPower[0][71] = 95;
	EnergyData.iPower[0][72] = 90;
	EnergyData.iPower[0][73] = 85;
	EnergyData.iPower[0][74] = 80;
	EnergyData.iPower[0][75] = 75;
	EnergyData.iPower[0][76] = 70;
	EnergyData.iPower[0][77] = 65;
	EnergyData.iPower[0][78] = 60;
	EnergyData.iPower[0][79] = 55;
	EnergyData.iPower[0][80] = 50;
	EnergyData.iPower[0][81] = 45;
	EnergyData.iPower[0][82] = 40;
	
	RevMediaTrackingEnergyInPos(&TestMediaTrackingInside, 1,
		1, 2,
		48, 1400.0/48.0, -1400.0/2, 0,
		0, IntensityOutput);	
	TEST_ASSERT(IntensityOutput[19] == 0);
	TEST_ASSERT(IntensityOutput[20] == 45);
	TEST_ASSERT(IntensityOutput[21] == 60);
	TEST_ASSERT(IntensityOutput[22] == 75);
	TEST_ASSERT(IntensityOutput[23] == 90);
	TEST_ASSERT(IntensityOutput[24] == 100);
	TEST_ASSERT(IntensityOutput[25] == 100);
	TEST_ASSERT(IntensityOutput[26] == 90);
	TEST_ASSERT(IntensityOutput[27] == 75);
	TEST_ASSERT(IntensityOutput[28] == 60);
	TEST_ASSERT(IntensityOutput[29] == 45);
	TEST_ASSERT(IntensityOutput[30] == 0);


	//Dry in the center. Image centered. WITH overlap. SAW
	ResetTrackingMediaInside();
	TestMediaTrackingInside[0].HeadPosition = 2;
	TestMediaTrackingInside[0].TailPosition = 0;
	TestMediaTrackingInside[0].pMediaEnery = &EnergyData;
	TestMediaTrackingInside[0].Media.rLength = 100;
	TestMediaTrackingInside[0].Media.rWidth = 1400;
	TestMediaTrackingInside[0].Media.rCrossOffset = -700;
	TestMediaTrackingInside[0].Media.rDocLength = 100;
	TestMediaTrackingInside[0].Media.rDocWidth = 1400;
	TestMediaTrackingInside[0].Media.rDocCrossOffset = -700;
	
	EnergyData.iPower[0][57] = 40;
	EnergyData.iPower[0][58] = 45;
	EnergyData.iPower[0][59] = 50;
	EnergyData.iPower[0][60] = 55;
	EnergyData.iPower[0][61] = 60;
	EnergyData.iPower[0][62] = 65;
	EnergyData.iPower[0][63] = 70;
	EnergyData.iPower[0][64] = 75;
	EnergyData.iPower[0][65] = 80;
	EnergyData.iPower[0][66] = 85;
	EnergyData.iPower[0][67] = 90;
	EnergyData.iPower[0][68] = 95;
	EnergyData.iPower[0][69] = 100;
	EnergyData.iPower[0][70] = 100;
	EnergyData.iPower[0][71] = 95;
	EnergyData.iPower[0][72] = 90;
	EnergyData.iPower[0][73] = 85;
	EnergyData.iPower[0][74] = 80;
	EnergyData.iPower[0][75] = 75;
	EnergyData.iPower[0][76] = 70;
	EnergyData.iPower[0][77] = 65;
	EnergyData.iPower[0][78] = 60;
	EnergyData.iPower[0][79] = 55;
	EnergyData.iPower[0][80] = 50;
	EnergyData.iPower[0][81] = 45;
	EnergyData.iPower[0][82] = 40;
	
	RevMediaTrackingEnergyInPos(&TestMediaTrackingInside, 1,
		1, 2,
		48, 1400.0/48.0, -1400.0/2, 10,
		0, IntensityOutput);	
	TEST_ASSERT(IntensityOutput[19] == 0);
	TEST_ASSERT(IntensityOutput[20] == 50);
	TEST_ASSERT(IntensityOutput[21] == 65);
	TEST_ASSERT(IntensityOutput[22] == 80);
	TEST_ASSERT(IntensityOutput[23] == 95);
	TEST_ASSERT(IntensityOutput[24] == 100);
	TEST_ASSERT(IntensityOutput[25] == 100);
	TEST_ASSERT(IntensityOutput[26] == 95);
	TEST_ASSERT(IntensityOutput[27] == 80);
	TEST_ASSERT(IntensityOutput[28] == 65);
	TEST_ASSERT(IntensityOutput[29] == 50);
	TEST_ASSERT(IntensityOutput[30] == 0);
	
	
	//Dry just minimum
	ResetTrackingMediaInside();
	TestMediaTrackingInside[0].HeadPosition = 2;
	TestMediaTrackingInside[0].TailPosition = 0;
	TestMediaTrackingInside[0].pMediaEnery = &EnergyData;
	TestMediaTrackingInside[0].Media.rLength = 100;
	TestMediaTrackingInside[0].Media.rWidth = 1400;
	TestMediaTrackingInside[0].Media.rCrossOffset = -700;
	TestMediaTrackingInside[0].Media.rDocLength = 100;
	TestMediaTrackingInside[0].Media.rDocWidth = 1400;
	TestMediaTrackingInside[0].Media.rDocCrossOffset = -700;
	
	EnergyData.iPower[0][0] = 0;
	
	RevMediaTrackingEnergyInPos(&TestMediaTrackingInside, 1,
		1, 2,
		48, 1400.0/48.0, -1400.0/2, 0,
		15, IntensityOutput);	
	TEST_ASSERT(IntensityOutput[1] == 15);
	TEST_ASSERT(IntensityOutput[48] == 15);
	
	
	//Dry just in one side. Image centered. Image delayed
	ResetTrackingMediaInside();
	TestMediaTrackingInside[0].HeadPosition = 10;
	TestMediaTrackingInside[0].TailPosition = 0;
	TestMediaTrackingInside[0].pMediaEnery = &EnergyData;
	TestMediaTrackingInside[0].Media.rLength = 1500;
	TestMediaTrackingInside[0].Media.rWidth = 1400;
	TestMediaTrackingInside[0].Media.rCrossOffset = -700;
	TestMediaTrackingInside[0].Media.rDocLength = 1500;
	TestMediaTrackingInside[0].Media.rDocWidth = 1400;
	TestMediaTrackingInside[0].Media.rDocCrossOffset = -700;
	
	// 29 = 29position * 5cm = 145cm (cofigured 150cm)
	EnergyData.iPower[29][0] = 100;
	
	RevMediaTrackingEnergyInPos(&TestMediaTrackingInside, 1,
		-150, 1,
		48, 1400.0/48.0, -1400.0/2, 0,
		0, &IntensityOutput);	
	TEST_ASSERT(IntensityOutput[48] == 100);	
	
	TEST_DONE;
}

_TEST test_ShiftArrayForwardOffset(void)
{
	strcpy(txTest, "test_ShiftArrayForwardOffset");
	
	// Assign data
	for (iIndexArray = 0; iIndexArray < iMAXTRACKINGARRAY; iIndexArray++)	{
		TestMediaTracking[iIndexArray] = iIndexArray;
	}

	TestMediaTracking[0] = TestMediaTracking[1000]; //Copying the value of a large index to later comparing 
	ShiftArrayOffset(&TestMediaTracking, sizeof(TestMediaTracking), sizeof(TestMediaTracking[0]), 1, 3, iMAXTRACKINGARRAY-3);

	TEST_ASSERT_EQUAL_INT(TestMediaTracking[1], TestMediaTracking[3]);
	TEST_ASSERT_EQUAL_INT(TestMediaTracking[1000 + 3 - 1], TestMediaTracking[0]);
	
	ResetTrackingMediaInside();
	MediaData = MediaConfigReseted;
	MediaData.id = 1;
	MediaData.iLine = 1;
	MediaData.rCrossOffset = -700;
	MediaData.rDocCrossOffset = -600;
	MediaData.rDocLength = 1500;
	MediaData.rDocProcessOffset = 0;
	MediaData.rDocWidth = 1200;
	MediaData.rLength = 1500;
	MediaData.rThickness = 2;
	MediaData.rWidth = 1400;
	
	Stack_iTotalNewMedia = 0;
	EnergyRack_iIndex = 1;
			
	udResult = AssignLastItemEnergyInStack(
		&MediaData,
		&EnergyData,
		&NewMediaStack,
		&MediaEnergyRack,
		&Stack_iTotalNewMedia,
		&EnergyRack_iIndex
		);

	TEST_ASSERT_EQUAL_INT(0 , udResult);	
	TEST_ASSERT_EQUAL_INT(1 , Stack_iTotalNewMedia);
	
	
	MediaData = MediaConfigReseted;
	MediaData.id = 2;
	MediaData.iLine = 1;
	MediaData.rCrossOffset = -700;
	MediaData.rDocCrossOffset = -600;
	MediaData.rDocLength = 1500;
	MediaData.rDocProcessOffset = 0;
	MediaData.rDocWidth = 1200;
	MediaData.rLength = 1500;
	MediaData.rThickness = 2;
	MediaData.rWidth = 1400;

	udResult = AssignLastItemEnergyInStack(
		&MediaData,
		&EnergyData,
		&NewMediaStack,
		&MediaEnergyRack,
		&Stack_iTotalNewMedia,
		&EnergyRack_iIndex
		);
	
	TEST_ASSERT_EQUAL_INT(0 , udResult);	
	TEST_ASSERT_EQUAL_INT(2 , Stack_iTotalNewMedia);

	// Error trying to insert a media with the same Id	
	udResult = CheckNotItemInStack(
		MediaData.id, 
		&NewMediaStack, 
		Stack_iTotalNewMedia, 
		&Stack_iTotalNewMediaPos);
	TEST_ASSERT_EQUAL_INT(1520 , udResult); //Extected an error because the Id.2 is already in the list
	
	
	// Function to insert
	MediaData = MediaConfigReseted;
	MediaData.id = 3;
	MediaData.iLine = 1;
	MediaData.rCrossOffset = -700;
	MediaData.rDocCrossOffset = -600;
	MediaData.rDocLength = 1500;
	MediaData.rDocProcessOffset = 0;
	MediaData.rDocWidth = 1200;
	MediaData.rLength = 1500;
	MediaData.rThickness = 2;
	MediaData.rWidth = 1400;	
	
	// Check the position of the Id=1
	udResult = CheckItemInStack(
		1,
		&NewMediaStack,
		&Stack_iTotalNewMedia,
		&Stack_iTotalNewMediaPos
		);
	TEST_ASSERT_EQUAL_INT(0, udResult); // Everything went OK
	TEST_ASSERT_EQUAL_INT(0, Stack_iTotalNewMediaPos); // Everything went OK
	
	udResult = InsertItemEnergyInStack(
		1,
		&MediaData,
		&EnergyData,
		&NewMediaStack,
		&MediaEnergyRack,
		&Stack_iTotalNewMedia,
		&EnergyRack_iIndex
		);
	TEST_ASSERT_EQUAL_INT(0, udResult); // Everything went OK
	TEST_ASSERT_EQUAL_INT(3, NewMediaStack[1].Media.id); // The Third media is in the second position

	
	// Function to remove
	udResult = RemoveItemInStack(
		1,
		&NewMediaStack,
		&Stack_iTotalNewMedia);
	TEST_ASSERT_EQUAL_INT(0, udResult); // Everything went OK
	TEST_ASSERT_EQUAL_INT(2, NewMediaStack[1].Media.id); // The second media is in the second position again
	

	udResult = RemoveItemInStack(
		-1,
		&NewMediaStack,
		&Stack_iTotalNewMedia);
	TEST_ASSERT_EQUAL_INT(0, udResult); // Everything went OK
	TEST_ASSERT_EQUAL_INT(0, Stack_iTotalNewMedia); // The list is emptyed
	TEST_ASSERT_EQUAL_INT(0, NewMediaStack[0].Media.id); // The list is emptyed
	
	
	// Assign data
	for (iIndexArray = 0; iIndexArray < iMAXTRACKINGARRAY; iIndexArray++)	{
		TestMediaTracking[iIndexArray] = 0;
	}
	
	
	//This 2 lines just for the last TestCase
	strcpy(txTest, "test_FunctionTests Finished!! Congrats!");
	strcpy(txStateDesc, "--");
	TEST_DONE;	
}


/*
B+R UnitTest: This is generated code.
Do not edit! Do not move!
Description: UnitTest Testprogramm infrastructure (TestSet).
LastUpdated: 2024-03-07 09:14:50Z
By B+R UnitTest Helper Version: 2.0.1.59
*/
UNITTEST_FIXTURES(fixtures)
{
	new_TestFixture("test_LoadMediaFromFastDataLine", test_LoadMediaFromFastDataLine), 
	new_TestFixture("test_RevMediaTrackingEnergyInPos", test_RevMediaTrackingEnergyInPos), 
	new_TestFixture("test_ShiftArrayForwardOffset", test_ShiftArrayForwardOffset), 
};

UNITTEST_CALLER_COMPLETE_EXPLICIT(FunctionsTests, "FunctionsTests", 0, 0, fixtures, 0, 0, 0);

