#include <bur/plctypes.h>


#include <bur/plctypes.h>
#include "UnitTest.h"

#ifdef __cplusplus
extern "C"
{
#endif

// Dummies for smartedit
#ifdef _SMART_EDIT_DUMMY_
	/* This asserts checks (actual < threshold) */
	BOOL EFI_ASSERT_GREATER_THAN_REAL(REAL threshold, REAL actual);
#endif

// Prototypes
	BOOL efi_assertGreaterThanReal_REAL (const REAL threshold,const REAL actual, const long line, const char *file);

// Macros
#define EFI_ASSERT_GREATER_THAN_REAL(threshold, actual) 	\
	efi_assertGreaterThanReal_REAL(threshold, actual, (unsigned long) __LINE__, __FILE__)


#ifdef __cplusplus
};
#endif