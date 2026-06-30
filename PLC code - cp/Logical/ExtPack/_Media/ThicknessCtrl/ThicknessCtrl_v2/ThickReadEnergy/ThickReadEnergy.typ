(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: FileHandling
 * File: FileHandling.typ
 * Author: Bernecker + Rainer
 * Created: April 16, 2009
 ********************************************************************
 * Local data types of program FileHandling
 ********************************************************************)

TYPE
	FileHandling_Functionblock_typ : 	STRUCT 
		DevLink_0 : DevLink; (*Functionblock DevLink()*)
		FileClose_0 : FileClose; (*Functionblock FileClose()*)
		FileOpen_0 : FileOpen; (*Functionblock FileOpen()*)
		FileReadEx_0 : FileReadEx; (*Functionblock FileReadEx()*)
	END_STRUCT;
	FileHandling_Data_typ : 	STRUCT 
		FileName : STRING[32]; (*filename for command bCreateFile, bDeleteFile, bWriteFile, bReadFile, bReadExFile, bCopyFile, bRenameFile*)
		Device : STRING[32]; (*device name*)
		Parameter : STRING[80]; (*parameterstring for FUB DevLink()*)
		ReadDataHex : ARRAY[0..THICKENERGY_MAX_PROCESS_ITEMS,0..THICKENERGY_MAX_CROSS_ITEMS]OF USINT; (*readed data from command bReadFile and bReadExFile*)
		Step : USINT; (*step variable (255 = error step)*)
	END_STRUCT;
	FileHandling_Command_typ : 	STRUCT 
		bReadExFile : BOOL; (*Command: read data from file*)
	END_STRUCT;
	FileHandling_typ : 	STRUCT 
		Command : FileHandling_Command_typ; (*Command structure*)
		Data : FileHandling_Data_typ; (*Data structure*)
		Functionblock : FileHandling_Functionblock_typ; (*FUB structure*)
	END_STRUCT;
END_TYPE
