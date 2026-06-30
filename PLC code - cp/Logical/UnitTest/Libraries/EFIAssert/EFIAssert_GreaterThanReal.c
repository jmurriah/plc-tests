#include <bur/plctypes.h>

#include "asbrstr.h"
#include "EFIAssert_GreaterThanReal.h"


#define TRUE 1
#define FALSE 0

/* Returns TRUE if assert passed; FALSE otherwise
	function variables
	threshold: minimum accepted value
	actual: test value
	line: location information
	file: location information
*/

BOOL efi_assertGreaterThanReal_REAL (const REAL threshold, const REAL actual, const long line, const char *file){
	STRING buffer[100];
	STRING numbuf[16];
	
	//conditions
	if(threshold < actual){
		//passed assert
		addPassed("", line, file);
		return TRUE;
	}
	else{
		//failed assert
		
		//error message
		brsstrcpy((unsigned long) buffer, (unsigned long) "Limit of ");
		brsftoa((float)threshold, (unsigned long) numbuf);
		brsstrcat((unsigned long) buffer, (unsigned long) numbuf);
		brsstrcat((unsigned long) buffer, (unsigned long) " was exceded. Actual was ");
		
		brsftoa((float)actual, (unsigned long) numbuf);
		brsstrcat((unsigned long) buffer, (unsigned long) numbuf);
		brsstrcat((unsigned long) buffer, (unsigned long) ".");
		
		//failure report
		addFailure(buffer, line, file);
		return FALSE;
		
	}
};