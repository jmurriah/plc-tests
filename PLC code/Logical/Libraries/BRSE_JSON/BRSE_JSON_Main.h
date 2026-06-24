/*! \file BRSE_JSON_Main.h */
/*!
	\mainpage BRSE_JSON
	
	\section Introduction
	\brief This library provides the ability to use JSON to write and read variables using normal ASCII string communication.
		
	This library can extract the members and their values within a structure variable into a JavaScriptObjectNotification string format, 
	and parse the JSON-string back into a structure - eg. set the values of the structure members from the string information. 
	
	See also <a href="http://www.json.org">http://www.json.org</a> for the JSON syntax. 
	
	Useful for Javascript web pages or Java-written clients, or simply for storing structure data in a compact ASCII format.
	
	\section Usage
	The library contains two function blocks \ref JSON_Parse and \ref JSON_Stringify.
	
	\ref JSON_Parse takes a JSON string created by \ref JSON_Stringify and interprets it.
	It searches for the variables and updates their values on the PLC.
	
	\ref JSON_Stringify takes an address to a string containing a variable or structure name and creates a JSON string.
	The JSON string contains all the necessary data about the structure or variable so that a parser can reconstruct it.
	It uses a basic JSON structure: {name:content}
	
	An example of a string is the following:
	
	{"PV_var1":[{"Outer1":[{"Middle2":"1234","Middle1":[{"Inner1":"90","Inner2":"22","Inner3":"33"}]}]"Outer2":"567"}]}
	
	The JSON string describes the following structure:
	 	- PV_var1 \n
		- Outer1 \n
			- Middle2 1234 \n
			- Middle1 \n
				- Inner1 90 \n
				- Inner2 22 \n
				- Inner3 33 \n
		- Outer2 567

	
	\section Downloads
	There is an example package included.\n 
	Please import into project via Add Existing Package.\n
	In the package there is an html javascript file. Please only run it in Internet Explorer. \n
	The example shows an basic "monitor" mode implementation using an webservice together with BRSE_JSON. \n
	<a href="y:\Application\Libraries\BRSE_JSON\Documentation\WEB_Interface.zip">WEB_interface</a><br><br>
	There is also a smaller test program just for testing the basic functionality.
	<a href="y:\Application\Libraries\BRSE_JSON\Documentation\TestProgram.zip">TestProgram</a><br><br>
	*/

#include "BRSE_JSON.h"
#include <string.h> /*this will override the asstring functions*/
