(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: FolderHandling
 * File: FolderHandling.typ
 * Author: Bernecker + Rainer
 * Created: April 17, 2009
 ********************************************************************
 * Local data types of program FolderHandling
 ********************************************************************)

TYPE
	DirHandling_Functionblock_typ : 	STRUCT 
		DevLink_0 : REFERENCE TO DevLink; (*Functionblock DevLink()*)
		DirInfo_0 : DirInfo; (*Functionblock DirInfo()*)
		DirRead_0 : DirRead; (*Functionblock DirRead()*)
		DirCreate_0 : DirCreate; (*Functionblock DirCreate()*)
		DirCopy_0 : DirCopy; (*Functionblock DirCopy()*)
		DirRename_0 : DirRename; (*Functionblock DirReaname()*)
		DirDelete_0 : DirDelete; (*Functionblock DirDelete()*)
		DevMemInfo_0 : DevMemInfo; (*Functionblock DevMemInfo()*)
		GetAttributes_0 : GetAttributes; (*Functionblock GetAttributes ()*)
		SetAttributes_0 : SetAttributes; (*Functionblock SetAttributes()*)
	END_STRUCT;
	DirHandling_Data_typ : 	STRUCT 
		DirName : STRING[100]; (*folder name for command bDirInfo, bDirRead, bDirCreate, bDirCopy, bDirRename, bDevMemiInfo, bGetAttributes, bSetAttributes*)
		NewDirName : STRING[100]; (*new folder name for command bdirCopy and bDirRename*)
		Device : {REDUND_UNREPLICABLE} STRING[100]; (*device name*)
		Parameter : {REDUND_UNREPLICABLE} STRING[100]; (*parameterstring for FUB DevLink()*)
		FileList : ARRAY[0..12]OF STRING[100]; (*list of files ond folders found with FUB DirRead()*)
		Step : USINT; (*step variable (255 = error step)*)
	END_STRUCT;
	DirHandling_Command_typ : 	STRUCT 
		bDirRead : BOOL; (*Command: read names of file and folders*)
		bDirCreate : BOOL; (*Command: create new folder*)
		bDirRename : BOOL; (*Command: rename folder*)
		bDirCopy : BOOL; (*Command: copy a folder*)
		bDirDelete : BOOL; (*Command: delete folder*)
		bDevMemInfo : BOOL; (*Command: read information about the device*)
		bGetAttributes : BOOL; (*Command: read folder attributes*)
		bSetAttributes : BOOL; (*Command: set folder attributes*)
	END_STRUCT;
	DirHandling_typ : 	STRUCT 
		Command : DirHandling_Command_typ; (*Command structure*)
		Data : DirHandling_Data_typ; (*Data structure*)
		Functionblock : DirHandling_Functionblock_typ; (*FUB structure*)
	END_STRUCT;
END_TYPE
