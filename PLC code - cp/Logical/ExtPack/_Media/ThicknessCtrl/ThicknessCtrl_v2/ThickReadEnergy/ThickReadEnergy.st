(********************************************************************
 * COPYRIGHT -- EFI
 ********************************************************************
 * Program: ThickReadEnergy from Original BR& LibFileIO1_ST
 * File: ThickReadEnergy.st
 * Author: EFI
 * Created: February 24, 2023
 ********************************************************************
 * Implementation of program Handling
 ********************************************************************)

PROGRAM _INIT
	
	(* device name for different function blocks needed (choose yourself) *)
	strcpy( ADR(Handling.Data.Device), ADR('LOCAL_DEV') );
	(* perameter string, layout see in the online help by function block "devlink" *)
	strcpy( ADR(Handling.Data.Parameter), ADR('"/DEVICE=C:/EnergyData') );
	
	(* predefine filenames *)
	strcpy( ADR(Handling.Data.FileName), ADR('TestHex.bin'));
		
END_PROGRAM

(******************************************)
(* cyclic program                         *)
(******************************************)
PROGRAM _CYCLIC

	// Conexion with gThicknessCtrl
	IF EDGEPOS(gThicknessCtrl.parSw.Dry.xReadFile) THEN
		Handling.Command.bReadExFile := TRUE;
	ELSIF EDGENEG(Handling.Command.bReadExFile) THEN
		gThicknessCtrl.parSw.Dry.xReadFile := FALSE;
	END_IF
	gThicknessCtrl.status.iReadEnergyFileStep := Handling.Data.Step;
	
	CASE Handling.Data.Step OF		

		0:  (* link (create) a file device *)
			Handling.Functionblock.DevLink_0.enable := 1;
			Handling.Functionblock.DevLink_0.pDevice := ADR(Handling.Data.Device);  (* name of the device, which is needed for other functionblocks *)
			Handling.Functionblock.DevLink_0.pParam := ADR(Handling.Data.Parameter);  (* devicepath *)
			Handling.Functionblock.DevLink_0;  (* call the function*)
			
			IF Handling.Functionblock.DevLink_0.status = 0 THEN  (* DevLink successful *)
				Handling.Data.Step := 1;  (* next Step*)
			ELSIF Handling.Functionblock.DevLink_0.status = ERR_FUB_BUSY THEN  (* DevLink not finished -> redo *)			
				(* Busy *)	
			ELSIF Handling.Functionblock.DevLink_0.status = fiERR_SYSTEM THEN  (* DevLink error = fiERR_SYSTEM -> detailed info with function "FileIoGetSysError" *)			
				(* get detail errorinformation *)
				Error := FileIoGetSysError();	
				(* Goto Error Step *)
				Handling.Data.Step := 255;			
			ELSE  (* Goto Error Step *)
				Handling.Data.Step := 255;
			END_IF	
		
		1:  (* Wait and comannd step *)
			IF Handling.Command.bReadExFile = 1 THEN
				(* read data to variable "Handling.Data.ReadData" 
				   from the file with the name of the variable "Handling.Data.FileName" *)
				Handling.Data.Step := 40;  (* next Step*)  	
			
			END_IF


		(***********************************************************************************************)	
		40:	(* open file for read access *)
			Handling.Functionblock.FileOpen_0.enable := 1;
			Handling.Functionblock.FileOpen_0.pDevice := ADR(Handling.Data.Device);  (* name of the linked device *)
			Handling.Functionblock.FileOpen_0.pFile :=  ADR(Handling.Data.FileName);  (* name of the file *)
			Handling.Functionblock.FileOpen_0.mode := fiREAD_ONLY;  (* read access *)
			Handling.Functionblock.FileOpen_0;  (* call the function*)

			IF Handling.Functionblock.FileOpen_0.status = 0 THEN  (* FileOpen successful *)
				Handling.Data.Step := 41;  (* next Step*)
			ELSIF Handling.Functionblock.FileOpen_0.status = ERR_FUB_BUSY THEN  (* FileOpen not finished -> redo *)			
				(* Busy *)	
			ELSE  (* Goto Error Step *)
				Handling.Data.Step := 255;
			END_IF	

		41: (* read data from file *)
			Handling.Functionblock.FileReadEx_0.enable := 1;
			Handling.Functionblock.FileReadEx_0.ident := Handling.Functionblock.FileOpen_0.ident;  (* ident of the previous "FileOpen" *)
			Handling.Functionblock.FileReadEx_0.offset := 0;  (* start at the beginning of the file *)
			Handling.Functionblock.FileReadEx_0.pDest := ADR(Handling.Data.ReadDataHex);  (* adress of the destination of reaaded datas *)
			Handling.Functionblock.FileReadEx_0.len := SIZEOF( Handling.Data.ReadDataHex);  (* lenght of data, which should be readed *)			
			Handling.Functionblock.FileReadEx_0;  (* call the function*)

			IF Handling.Functionblock.FileReadEx_0.status = 0 THEN  (* FileReadEx successful *)
				(* Handling.Functionblock.FileReadEx_0.bytesread includes the lenght of the readed data *)
				Handling.Data.Step := 42;  (* next Step*)
			ELSIF Handling.Functionblock.FileReadEx_0.status = ERR_FUB_BUSY THEN  (* FileReadEx not finished -> redo *)			
				(* Busy *)	
			ELSE  (* Goto Error Step *)
				Handling.Data.Step := 255;
			END_IF	

		42:	 (* close file, because of limited number of available file handles on the system *)
			Handling.Functionblock.FileClose_0.enable := 1;
			Handling.Functionblock.FileClose_0.ident := Handling.Functionblock.FileOpen_0.ident; (* ident for FileCreate-functionblock*)
			Handling.Functionblock.FileClose_0;  (* call the function*)
			
			IF Handling.Functionblock.FileClose_0.status = 0 THEN  (* FileClose successful *)
				Handling.Data.Step := 1;  (* next Step*)
				Handling.Command.bReadExFile := 0;  (* clear command *)
				
				// Assgination to gThicknessCtrl
				gThicknessCtrl.parameters.ContinuousMedia.Energy.iPower := Handling.Data.ReadDataHex;
				
				Handling.Command.bReadExFile := FALSE;  (* clear command *)
				
			ELSIF Handling.Functionblock.FileClose_0.status = ERR_FUB_BUSY THEN  (* FileClose not finished -> redo *)			
				(* Busy *)	
			ELSE  (* Goto Error Step *)
				Handling.Data.Step := 255;
			END_IF	
			


		(***********************************************************************************************)	
		255:  (* Here some error Handling has to be implemented *)
			
			

	END_CASE



END_PROGRAM
