/*!\file version_history.c */

/*!
	\page History
	\section History
	
	\par V1.00.0
		\arg First version created
		
	\par V1.00.1
		\arg Helpfile and example added. 
	
	\par V1.01.0
		\arg Helpfile updated
		\arg First release version.

	\par V1.02.0
		\arg Helpfile updated
	
	\par V1.10.0
		\arg Library dependency changed from AsString to AsBrStr.
             Add #include <AsBrStr.h>
        \arg Functions atof, ftoa, atoi and itoa are changed to brsatof, brsftoa, brsatoi, and brsitoa
             to avoid name conflict.
        \arg Functions strcat and strcpy can continue to be used from string.h
	\par V1.11.0
		\arg Library updated, changed command structure for functions. Improving usage with large data amounts.
			 Possible to set number of iterations run per scan.
			 Output directly into an output buffer has beeen added making it possible to stringify several entries in one scan.
			 
		\arg Examples replaced and simplified. Package that is imported instead of an entire project.
			 The simplification should make the javascript code and example tasks easier to understand.
			 TestProgram task added. 
	\par V1.12.0
		\arg Added support for ASCII charaters 9 -> 12. TAB, New Line, Vertical Tab and New page.
			 Have the same effect has an blank space ' '.
			 This to ease the usage of third party software like Notepad++ for editing of the JSON string.
*/   
