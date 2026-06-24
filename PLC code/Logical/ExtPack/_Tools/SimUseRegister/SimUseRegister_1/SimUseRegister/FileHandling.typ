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
		FileCreate_0 : FileCreate; (*Functionblock FileCreate()*)
		FileClose_0 : FileClose; (*Functionblock FileClose()*)
		FileOpen_0 : FileOpen; (*Functionblock FileOpen()*)
		FileWrite_0 : FileWrite; (*Functionblock FileWrite()*)
		FileRead_0 : FileRead; (*Functionblock FileRead()*)
		FileReadEx_0 : FileReadEx; (*Functionblock FileReadEx()*)
		FileCopy_0 : FileCopy; (*Functionblock FileCopy()*)
		FileRename_0 : FileRename; (*Functionblock FileRename()*)
		FileDelete_0 : FileDelete; (*Functionblock FileDelete()*)
	END_STRUCT;
	FileHandling_Data_typ : 	STRUCT 
		FileName : STRING[100]; (*filename for command bCreateFile, bDeleteFile, bWriteFile, bReadFile, bReadExFile, bCopyFile, bRenameFile*)
		NewFileName : STRING[100]; (*new filename for command bCopyFile and bRenameFile*)
		Device : STRING[100]; (*device name*)
		Parameter : STRING[100]; (*parameterstring for FUB DevLink()*)
		WriteData : STRING[80]; (*data for command bWriteFile*)
		ReadData : STRING[80]; (*readed data from command bReadFile and bReadExFile*)
		Step : USINT; (*step variable (255 = error step)*)
	END_STRUCT;
	FileHandling_Command_typ : 	STRUCT 
		bCreateFile : BOOL; (*Command: create new file*)
		bWriteFile : BOOL; (*Command: write data into file*)
		bReadFile : BOOL; (*Command: read data from file*)
		bReadExFile : BOOL; (*Command: read data from file*)
		bRenameFile : BOOL; (*Command: rename file*)
		bCopyFile : BOOL; (*Command: create a copy of a file*)
		bDeleteFile : BOOL; (*Command: detete a file*)
	END_STRUCT;
	FileHandling_typ : 	STRUCT 
		Command : FileHandling_Command_typ; (*Command structure*)
		Data : FileHandling_Data_typ; (*Data structure*)
		Functionblock : FileHandling_Functionblock_typ; (*FUB structure*)
	END_STRUCT;
END_TYPE
