/********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Library: EFIAssert
 * File: EFIAssert.h
 * Author: EFI. Jorge Murria & Mihai Bront
 *
 *
 *  NOTE: If creating new custom assert librery, the folder has to be
 * included in the project in 
 * Configuration/PLC(or PC_Any)/RightButton/Properties/Build/
 * and there in Adicional Include Directories
 *
 *******************************************************************/


#include <bur/plctypes.h>
#include "UnitTest.h"

/* When this file is included the defines, makros  of the following header files should be provided as well:  */

#include "EFIAssert_REAL_ArrayAsserts.h"
#include "EFIAssert_ThresholdAssert.h"
#include "EFIAssert_GreaterThanReal.h"
