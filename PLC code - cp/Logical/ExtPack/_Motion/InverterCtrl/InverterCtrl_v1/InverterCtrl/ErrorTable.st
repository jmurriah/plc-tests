(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: I66Ctrl
 * File: ErrorTable.st
 * Author: tresensa
 * Created: May 09, 2014
 ********************************************************************
 * Implementation of program InvCtrl
 ********************************************************************) 

(*Writes the error table*)
ACTION ErrorTable: 
	
	ERROR_TEXT[0] := 'NOF';
	//ERROR_TEXT[1] := 'InF'; // Not in the table.
	ERROR_TEXT[2] := 'EEF1';
	ERROR_TEXT[3] := 'CFF';
	ERROR_TEXT[4] := 'CFI';
	ERROR_TEXT[5] := 'SLF1';
	ERROR_TEXT[6] := 'ILF';
	ERROR_TEXT[7] := 'CnF';
	ERROR_TEXT[8] := 'EPF1';
	ERROR_TEXT[9] := 'OCF';
	ERROR_TEXT[10] := 'CrF';
	ERROR_TEXT[11] := 'SRF'; // Originally: SRF.
	
	ERROR_TEXT[16] := 'OHF';
	ERROR_TEXT[17] := 'OLF';
	ERROR_TEXT[18] := 'ObF';
	ERROR_TEXT[19] := 'OSF';
	ERROR_TEXT[20] := 'OPF1';
	ERROR_TEXT[21] := 'PHF';
	ERROR_TEXT[22] := 'USF';
	ERROR_TEXT[23] := 'SCF1';
	ERROR_TEXT[24] := 'SOF';
	ERROR_TEXT[25] := 'tnF';
	ERROR_TEXT[26] := 'InF1';
	ERROR_TEXT[27] := 'InF2';
	ERROR_TEXT[28] := 'InF3';
	ERROR_TEXT[29] := 'InF4';
	ERROR_TEXT[30] := 'EEF2';
	//ERROR_TEXT[31] := 'SCF2'; // Not in the table.
	ERROR_TEXT[32] := 'SCF3';
	ERROR_TEXT[33] := 'OPF2';
	ERROR_TEXT[34] := 'COF';
	ERROR_TEXT[35] := 'bLF';
	
	ERROR_TEXT[38] := 'EPF2';

	ERROR_TEXT[41] := 'brF';
	ERROR_TEXT[42] := 'SLF2';
	//ERROR_TEXT[43] := 'ECF'; // Not in the table.
	ERROR_TEXT[44] := 'SSF';
	ERROR_TEXT[45] := 'SLF3';
	//ERROR_TEXT[46] := 'PrF'; // Not in the table.
	
	ERROR_TEXT[49] := 'PtFL';
	ERROR_TEXT[50] := 'OtFL';
	ERROR_TEXT[51] := 'InF9';
	ERROR_TEXT[52] := 'InFA';
	ERROR_TEXT[53] := 'InFb';
	ERROR_TEXT[54] := 'tJF';
	ERROR_TEXT[55] := 'SCF4';
	ERROR_TEXT[56] := 'SCF5';
	//ERROR_TEXT[57] := 'SrF'; // Not in the table.
	ERROR_TEXT[58] := 'FCF1';
	ERROR_TEXT[59] := 'FCF2';
	
	//ERROR_TEXT[61] := 'AI2F'; // Not in the table.
	
	ERROR_TEXT[64] := 'LCF';
	
	//ERROR_TEXT[66] := 'dCF'; // Not in the table.
	ERROR_TEXT[67] := 'HdF';
	ERROR_TEXT[68] := 'InF6';
	ERROR_TEXT[69] := 'InFE';
	
	ERROR_TEXT[71] := 'LFF3';
	
	ERROR_TEXT[73] := 'HCF';
	
	ERROR_TEXT[76] := 'dLF';
	ERROR_TEXT[77] := 'CFI2';
	
	ERROR_TEXT[99] := 'CSF';
	ERROR_TEXT[100] := 'ULF';
	ERROR_TEXT[101] := 'OLF'; // Originally: OLC.
	
	ERROR_TEXT[105] := 'ASF';
	
	ERROR_TEXT[107] := 'SAFF';
	//ERROR_TEXT[108] := 'FbE'; // Not in the table.
	//ERROR_TEXT[109] := 'FbES'; // Not in the table.
	
END_ACTION
