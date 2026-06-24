(********************************************************************
 * COPYRIGHT -- EFI
 ********************************************************************
 * Program: SimUseRegister
 * File: SimUseRegister.st
 * Author: Jorge Murria
 * Created: February 03, 2022
 ********************************************************************
 * Implementation of program SimUseRegister
 ********************************************************************)

(******************************************)
(* init program                           *)
(******************************************)
PROGRAM _INIT
	
	(* device name for different function blocks needed (choose yourself) *)
	strcpy( ADR(Handling.Data.Device), ADR('LOCAL_DEVICE') );
	(* perameter string, layout see in the online help by function block "devlink" *)
	strcpy( ADR(Handling.Data.Parameter), ADR('"/DEVICE=C:/BrAutomation') );
	
	//Connect Both Handlers
	FolderHandling.Data.Device := Handling.Data.Device;
	FolderHandling.Data.Parameter := Handling.Data.Parameter;
	
	
END_PROGRAM

(******************************************)
(* cyclic program                         *)
(******************************************)
PROGRAM _CYCLIC

	GetSystemTime;
	
	//To avoid start the process with wrong data
	IF iYear = 0 THEN
		RETURN;
	END_IF
	
	
	CASE SimRegState OF
		SIMR_STOPPED:
			SimRegState := SIMR_IDLE;
			
			
		SIMR_IDLE:
			SimRegState := SIMR_CREATE_MAIN;
			
			
		SIMR_CREATE_MAIN:
			strcpy( ADR(FolderHandling.Data.DirName), ADR(FOLDER_SIM_REG) );
			
			FolderHandling.Command.bDirCreate := TRUE;
			SimRegState := SIMR_CREATING_MAIN;
			
			
		SIMR_CREATING_MAIN:
			xFunctionEnded := FolderHandling.Functionblock.DirCreate_0.status = ERR_OK OR FolderHandling.Functionblock.DirCreate_0.status = fiERR_DIR_ALREADY_EXIST;
			xStepManaged := FolderHandling.Data.Step = 1 OR FolderHandling.Data.Step = 255;
			IF  xFunctionEnded AND xStepManaged THEN
				FolderHandling.Data.Step := 1; //If the folder exists, remove the error
				SimRegState := SIMR_CREATE_YEAR;
			END_IF
			
			
		SIMR_CREATE_YEAR:
			CreateFolderYear;

			FolderHandling.Command.bDirCreate := TRUE;
			SimRegState := SIMR_CREATING_YEAR;

		
		SIMR_CREATING_YEAR:
			xFunctionEnded := FolderHandling.Functionblock.DirCreate_0.status = ERR_OK OR FolderHandling.Functionblock.DirCreate_0.status = fiERR_DIR_ALREADY_EXIST;
			xStepManaged := FolderHandling.Data.Step = 1 OR FolderHandling.Data.Step = 255;
			IF  xFunctionEnded AND xStepManaged THEN
				FolderHandling.Data.Step := 1; //If the folder exists, remove the error
				SimRegState := SIMR_CREATE_FILEREG;
			END_IF
			
			
		SIMR_CREATE_FILEREG:
			CreateFileReg;
			lastHour := TimeValue.hour;
			
			Handling.Command.bCreateFile := TRUE;
			SimRegState := SIMR_CREATING_FILEREG;
			
		
		SIMR_CREATING_FILEREG:
			xFunctionEnded := Handling.Functionblock.FileCreate_0.status = ERR_OK OR Handling.Functionblock.FileCreate_0.status = fiERR_EXIST;
			xStepManaged := Handling.Data.Step = 1 OR Handling.Data.Step = 255;
			IF  xFunctionEnded AND xStepManaged THEN
				Handling.Data.Step := 1; //If the folder exists, remove the error
				SimRegState := SIMR_IDLE_MAIN;
			END_IF
			
			
		SIMR_IDLE_MAIN:
			//Every new our, Register and write a new file
			IF lastHour <> TimeValue.hour THEN
				SimRegState := SIMR_CREATE_YEAR;
			END_IF
		
	END_CASE;
	

	FileManager;
	
	FolderManager;
	
	
	
END_PROGRAM
