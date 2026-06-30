
ACTION FileManager: 

	CASE Handling.Data.Step OF		

		0:  (* link (create) a file device *)
			Handling.Functionblock.DevLink_0.enable := 1;
			Handling.Functionblock.DevLink_0.pDevice := ADR(Handling.Data.Device);  (* name of the device, which is needed for other functionblocks *)
			Handling.Functionblock.DevLink_0.pParam := ADR(Handling.Data.Parameter);  (* devicepath *)
			Handling.Functionblock.DevLink_0;  (* call the function*)
			
			IF Handling.Functionblock.DevLink_0.status = 0 THEN  (* DevLink successful *)
				Handling.Data.Step := 1;  (* next Step*)
				FolderHandling.Data.Step := 1;  (* next Step*)
			ELSIF Handling.Functionblock.DevLink_0.status = ERR_FUB_BUSY THEN  (* DevLink not finished -> redo *)			
				(* Busy *)	
			ELSIF Handling.Functionblock.DevLink_0.status = fiERR_SYSTEM THEN  (* DevLink error = fiERR_SYSTEM -> detailed info with function "FileIoGetSysError" *)			
				(* get detail errorinformation *)
				Error := FileIoGetSysError();	
				(* Goto Error Step *)
				Handling.Data.Step := 255;			

				FolderError := FileIoGetSysError();	
				FolderHandling.Data.Step := 255;			
			ELSE  (* Goto Error Step *)
				Handling.Data.Step := 255;
				FolderHandling.Data.Step := 255;
			END_IF	
		
		1:  (* Wait and comannd step *)
			IF Handling.Command.bCreateFile = 1 THEN
				(* Create a new file with the name from the variable "Handling.Data.FileName" *)
				Handling.Data.Step := 10;  (* next Step*)  	
		
			ELSIF Handling.Command.bWriteFile = 1 THEN
				(* writes the data from variable "Handling.Data.WriteData" 
				   in the file with the name from the variable "Handling.Data.FileName" *)
				Handling.Data.Step := 20;  (* next Step*)  
				
			ELSIF Handling.Command.bReadFile = 1 THEN
				(* read data to variable "Handling.Data.ReadData" 
				   from the file with the name of the variable "Handling.Data.FileName" *)
				Handling.Data.Step := 30;  (* next Step*)  
				
			ELSIF Handling.Command.bReadExFile = 1 THEN
				(* read data to variable "Handling.Data.ReadData" 
				   from the file with the name of the variable "Handling.Data.FileName" *)
				Handling.Data.Step := 40;  (* next Step*)  	

			ELSIF Handling.Command.bCopyFile = 1 THEN
				(* creates a copy with the name from the variable "Handling.Data.NewFileName"
				   from the file with the name from the variable "Handling.Data.FileName" *)
				Handling.Data.Step := 50;  (* next Step*)  	

			ELSIF Handling.Command.bRenameFile = 1 THEN
				(* renames the the file with the name from the variable "Handling.Data.FileName"
				   to the name from the variable "Handling.Data.NewFileName" *)
				Handling.Data.Step := 60;  (* next Step*)  
															
			ELSIF Handling.Command.bDeleteFile = 1 THEN
				(* deletes the file with the name from the variable "Handling.Data.FileName" *)
				Handling.Data.Step := 70;  (* next Step*)  
			
			END_IF
		
			(***********************************************************************************************)	
		10:  (* create a new File with the selected name  *)
			Handling.Functionblock.FileCreate_0.enable := 1;
			Handling.Functionblock.FileCreate_0.pDevice := ADR(Handling.Data.Device);  (* name of the linked device *)
			Handling.Functionblock.FileCreate_0.pFile := ADR(Handling.Data.FileName);  (* name of the file *)
			Handling.Functionblock.FileCreate_0;  (* call the function*)
			
			IF Handling.Functionblock.FileCreate_0.status = 0 THEN  (* FileCreate successful *)
				Handling.Data.Step := 11;  (* next Step*)
			ELSIF Handling.Functionblock.FileCreate_0.status = ERR_FUB_BUSY THEN  (* FileCreate not finished -> redo *)			
				(* Busy *)	
			ELSE  (* Goto Error Step *)
				Handling.Data.Step := 255;
			END_IF	
			
		11:	 (* close file, because of limited number of available file handles on the system *)
			Handling.Functionblock.FileClose_0.enable := 1;
			Handling.Functionblock.FileClose_0.ident := Handling.Functionblock.FileCreate_0.ident; (* ident for FileCreate-functionblock*)
			Handling.Functionblock.FileClose_0;  (* call the function*)
			
			IF Handling.Functionblock.FileClose_0.status = 0 THEN  (* FileClose successful *)
				Handling.Data.Step := 1;  (* next Step*)
				Handling.Command.bCreateFile := 0;  (* clear command *)
			ELSIF Handling.Functionblock.FileClose_0.status = ERR_FUB_BUSY THEN  (* FileClose not finished -> redo *)			
				(* Busy *)	
			ELSE  (* Goto Error Step *)
				Handling.Data.Step := 255;
			END_IF	

			(***********************************************************************************************)	
		20:	(* open file for write access *)
			Handling.Functionblock.FileOpen_0.enable := 1;
			Handling.Functionblock.FileOpen_0.pDevice := ADR(Handling.Data.Device);  (* name of the linked device *)
			Handling.Functionblock.FileOpen_0.pFile :=  ADR(Handling.Data.FileName);  (* name of the file *)
			Handling.Functionblock.FileOpen_0.mode := fiWRITE_ONLY; (* write access *)
			Handling.Functionblock.FileOpen_0;  (* call the function*)

			IF Handling.Functionblock.FileOpen_0.status = 0 THEN  (* FileOpen successful *)
				Handling.Data.Step := 21;  (* next Step*)
			ELSIF Handling.Functionblock.FileOpen_0.status = ERR_FUB_BUSY THEN  (* FileOpen not finished -> redo *)			
				(* Busy *)	
			ELSE  (* Goto Error Step *)
				Handling.Data.Step := 255;
			END_IF	

		21: (* write data into file *)
			Handling.Functionblock.FileWrite_0.enable := 1;
			Handling.Functionblock.FileWrite_0.ident := Handling.Functionblock.FileOpen_0.ident;
			Handling.Functionblock.FileWrite_0.offset := 0; (* start at the beginning of the file *)
			Handling.Functionblock.FileWrite_0.pSrc := ADR(Handling.Data.WriteData);
			Handling.Functionblock.FileWrite_0.len := strlen( ADR(Handling.Data.WriteData) );
			Handling.Functionblock.FileWrite_0;  (* call the function*)

			IF Handling.Functionblock.FileWrite_0.status = 0 THEN  (* FileWrite successful *)
				Handling.Data.Step := 22;  (* next Step*)
			ELSIF Handling.Functionblock.FileWrite_0.status = ERR_FUB_BUSY THEN  (* FileWrite not finished -> redo *)			
				(* Busy *)	
			ELSE  (* Goto Error Step *)
				Handling.Data.Step := 255;
			END_IF	

		22:	 (* close file, because of limited number of available file handles on the system *)
			Handling.Functionblock.FileClose_0.enable := 1;
			Handling.Functionblock.FileClose_0.ident := Handling.Functionblock.FileOpen_0.ident; (* ident for FileCreate-functionblock*)
			Handling.Functionblock.FileClose_0;  (* call the function*)
			
			IF Handling.Functionblock.FileClose_0.status = 0 THEN  (* FileClose successful *)
				Handling.Data.Step := 1;  (* next Step*)
				Handling.Command.bWriteFile := 0;  (* clear command *)
			ELSIF Handling.Functionblock.FileClose_0.status = ERR_FUB_BUSY THEN  (* FileClose not finished -> redo *)			
				(* Busy *)	
			ELSE  (* Goto Error Step *)
				Handling.Data.Step := 255;
			END_IF	

			(***********************************************************************************************)	
		30:	(* open file for read access *)
			Handling.Functionblock.FileOpen_0.enable := 1;
			Handling.Functionblock.FileOpen_0.pDevice := ADR(Handling.Data.Device);  (* name of the linked device *)
			Handling.Functionblock.FileOpen_0.pFile :=  ADR(Handling.Data.FileName);  (* name of the file *)
			Handling.Functionblock.FileOpen_0.mode := fiREAD_ONLY;  (* read access *)
			Handling.Functionblock.FileOpen_0;  (* call the function*)

			IF Handling.Functionblock.FileOpen_0.status = 0 THEN  (* FileOpen successful *)
				Handling.Data.Step := 31;  (* next Step*)
			ELSIF Handling.Functionblock.FileOpen_0.status = ERR_FUB_BUSY THEN  (* FileOpen not finished -> redo *)			
				(* Busy *)	
			ELSE  (* Goto Error Step *)
				Handling.Data.Step := 255;
			END_IF	

		31: (* read data from file *)
			Handling.Functionblock.FileRead_0.enable := 1;
			Handling.Functionblock.FileRead_0.ident := Handling.Functionblock.FileOpen_0.ident;  (* ident of the previous "FileOpen" *)
			Handling.Functionblock.FileRead_0.offset := 0;  (* start at the beginning of the file *)
			Handling.Functionblock.FileRead_0.pDest := ADR(Handling.Data.ReadData);  (* adress of the destination of reaaded datas *)
			Handling.Functionblock.FileRead_0.len := SIZEOF( Handling.Data.ReadData );  (* lenght of data, which should be readed *)			
			Handling.Functionblock.FileRead_0;  (* call the function*)

			IF Handling.Functionblock.FileRead_0.status = 0 THEN  (* FileRead successful *)
				Handling.Data.Step := 32;  (* next Step*)
			ELSIF Handling.Functionblock.FileRead_0.status = ERR_FUB_BUSY THEN  (* FileRead not finished -> redo *)			
				(* Busy *)	
			ELSE  (* Goto Error Step *)
				Handling.Data.Step := 255;
			END_IF	

		32:	 (* close file, because of limited number of available file handles on the system *)
			Handling.Functionblock.FileClose_0.enable := 1;
			Handling.Functionblock.FileClose_0.ident := Handling.Functionblock.FileOpen_0.ident; (* ident for FileCreate-functionblock*)
			Handling.Functionblock.FileClose_0;  (* call the function*)
			
			IF Handling.Functionblock.FileClose_0.status = 0 THEN  (* FileClose successful *)
				Handling.Data.Step := 1;  (* next Step*)
				Handling.Command.bReadFile := 0;  (* clear command *)
			ELSIF Handling.Functionblock.FileClose_0.status = ERR_FUB_BUSY THEN  (* FileClose not finished -> redo *)			
				(* Busy *)	
			ELSE  (* Goto Error Step *)
				Handling.Data.Step := 255;
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
			Handling.Functionblock.FileReadEx_0.pDest := ADR(Handling.Data.ReadData);  (* adress of the destination of reaaded datas *)
			Handling.Functionblock.FileReadEx_0.len := SIZEOF( Handling.Data.ReadData );  (* lenght of data, which should be readed *)			
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
			ELSIF Handling.Functionblock.FileClose_0.status = ERR_FUB_BUSY THEN  (* FileClose not finished -> redo *)			
				(* Busy *)	
			ELSE  (* Goto Error Step *)
				Handling.Data.Step := 255;
			END_IF	
			
			(***********************************************************************************************)	
		50: (* copy a file *)
		
			Handling.Functionblock.FileCopy_0.enable := 1;
			Handling.Functionblock.FileCopy_0.option := fiOVERWRITE;  (* overwrite existing file *)
			Handling.Functionblock.FileCopy_0.pSrcDev := ADR(Handling.Data.Device);  (* name of a linked device *)
			Handling.Functionblock.FileCopy_0.pSrc := ADR(Handling.Data.FileName);  (* name of the source file *)
			Handling.Functionblock.FileCopy_0.pDestDev := ADR(Handling.Data.Device);  (* name of a linked device *)
			Handling.Functionblock.FileCopy_0.pDest := ADR(Handling.Data.NewFileName);  (* name of the new file*)
			Handling.Functionblock.FileCopy_0;  (* call the function*)
			
			IF Handling.Functionblock.FileCopy_0.status = 0 THEN  (* FileCopy successful *)
				Handling.Data.Step := 1;  (* next Step*)
				Handling.Command.bCopyFile := 0;  (* clear command *)
			ELSIF Handling.Functionblock.FileCopy_0.status = ERR_FUB_BUSY THEN  (* FileCopy not finished -> redo *)			
				(* Busy *)	
			ELSE  (* Goto Error Step *)
				Handling.Data.Step := 255;
			END_IF

			(***********************************************************************************************)	
		60: (* rename a file *)
		
			Handling.Functionblock.FileRename_0.enable := 1;
			Handling.Functionblock.FileRename_0.pDevice := ADR(Handling.Data.Device);  (* name of the linked device *)
			Handling.Functionblock.FileRename_0.pName := ADR(Handling.Data.FileName);  (* actual file name *)
			Handling.Functionblock.FileRename_0.pNewName := ADR(Handling.Data.NewFileName);  (* new file name *)
			Handling.Functionblock.FileRename_0;  (* call the function*)
			
			IF Handling.Functionblock.FileRename_0.status = 0 THEN  (* FileRename successful *)
				Handling.Data.Step := 1;  (* next Step*)
				Handling.Command.bRenameFile := 0;  (* clear command *)
			ELSIF Handling.Functionblock.FileRename_0.status = ERR_FUB_BUSY THEN  (* FileRename not finished -> redo *)			
				(* Busy *)	
			ELSE  (* Goto Error Step *)
				Handling.Data.Step := 255;
			END_IF

			(***********************************************************************************************)	
		70: (* delete a file *)
		
			Handling.Functionblock.FileDelete_0.enable := 1;
			Handling.Functionblock.FileDelete_0.pDevice := ADR(Handling.Data.Device);  (* name of a linked device *)
			Handling.Functionblock.FileDelete_0.pName := ADR(Handling.Data.FileName);  (* name of the source file *)
			Handling.Functionblock.FileDelete_0;  (* call the function*)
			
			IF Handling.Functionblock.FileDelete_0.status = 0 THEN  (* FileRename successful *)
				Handling.Data.Step := 1;  (* next Step*)
				Handling.Command.bDeleteFile := 0;  (* clear command *)
			ELSIF Handling.Functionblock.FileDelete_0.status = ERR_FUB_BUSY THEN  (* FileRename not finished -> redo *)			
				(* Busy *)	
			ELSE  (* Goto Error Step *)
				Handling.Data.Step := 255;
			END_IF

			(***********************************************************************************************)	
		255:  (* Here some error Handling has to be implemented *)
			
			

	END_CASE

END_ACTION
