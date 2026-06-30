
ACTION FolderManager: 

	CASE FolderHandling.Data.Step OF		

		0:  (* link (create) a file device *)
			//			FolderHandling.Functionblock.DevLink_0.enable := 1;
			//			FolderHandling.Functionblock.DevLink_0.pDevice := ADR(FolderHandling.Data.Device);  (* name of the device, which is needed for other functionblocks *)
			//			FolderHandling.Functionblock.DevLink_0.pParam := ADR(FolderHandling.Data.Parameter);  (* devicepath *)
			//			FolderHandling.Functionblock.DevLink_0;  (* call the function*)
			//			
			//			IF FolderHandling.Functionblock.DevLink_0.status = 0 THEN  (* DevLink successful *)
			//				FolderHandling.Data.Step := 1;  (* next Step*)
			//			ELSIF FolderHandling.Functionblock.DevLink_0.status = ERR_FUB_BUSY THEN  (* DevLink not finished -> redo *)			
			//				(* Busy *)	
			//			ELSIF FolderHandling.Functionblock.DevLink_0.status = fiERR_SYSTEM THEN  (* DevLink FolderError = fiERR_SYSTEM -> detailed info with function "FileIoGetSysFolderError" *)			
			//				(* get detail FolderErrorinformation *)
			//				FolderError := FileIoGetSysFolderError();	
			//				(* Goto FolderError Step *)
			//				FolderHandling.Data.Step := 255;			
			//			ELSE  (* Goto FolderError Step *)
			//				FolderHandling.Data.Step := 255;
			//			END_IF	
		
		1:  (* Wait and comannd step *)
			IF FolderHandling.Command.bDirRead = 1 THEN
				(* read all names of files and folders into the string-array "FolderHandling.Data.FileList" *)
				FolderHandling.Data.Step := 10;  (* next Step*)  
				
			ELSIF FolderHandling.Command.bDirCreate = 1 THEN
				(* creates a new directory with the name on the variable "FolderHandling.Data.DirName" *)
				FolderHandling.Data.Step := 20;  (* next Step*)  
				
			ELSIF FolderHandling.Command.bDirCopy = 1 THEN
				(* copy a directory with the name on the variable "FolderHandling.Data.DirName" 
				   to a directory with the name on the variable "FolderHandling.Data.NewDirName"*)
				FolderHandling.Data.Step := 30;  (* next Step*)  
				
			ELSIF FolderHandling.Command.bDirRename = 1 THEN
				(* rename the directory with the name on the variable "FolderHandling.Data.DirName" 
				   to the name on the variable "FolderHandling.Data.NewDirName"*)
				FolderHandling.Data.Step := 40;  (* next Step*)  	

			ELSIF FolderHandling.Command.bDirDelete = 1 THEN
				(* delete the directory with the name on the variable "FolderHandling.Data.DirName" *)
				FolderHandling.Data.Step := 50;  (* next Step*)  	

			ELSIF FolderHandling.Command.bDevMemInfo = 1 THEN
				(* read information about your device *)
				FolderHandling.Data.Step := 60;  (* next Step*)  
															
			ELSIF FolderHandling.Command.bGetAttributes = 1 THEN
				(* read information about your device-settings *)
				FolderHandling.Data.Step := 70;  (* next Step*)  
				
			ELSIF FolderHandling.Command.bSetAttributes = 1 THEN
				(* set device settings*)
				FolderHandling.Data.Step := 80;  (* next Step*)  
			
			END_IF
		
			(***********************************************************************************************)	
		10: (* calulate the number of files and directories *)
			FolderHandling.Functionblock.DirInfo_0.enable := 1;
			FolderHandling.Functionblock.DirInfo_0.pDevice := ADR(FolderHandling.Data.Device);  (* name of the device *)
			FolderHandling.Functionblock.DirInfo_0.pPath := 0;
			FolderHandling.Functionblock.DirInfo_0;  (* call the function*)
			
			IF FolderHandling.Functionblock.DirInfo_0.status = 0 THEN  (* DirInfo successful *)
				(* FolderHandling.Functionblock.DirInfo_0.dirnum contains the number of found folders *)
				(* FolderHandling.Functionblock.DirInfo_0.filenum contains the number of found files *)
				FolderCounter := 0;  (* reset FolderCounter *)
				memset( ADR(FolderHandling.Data.FileList[0]), 0, SIZEOF(FolderHandling.Data.FileList) );  (* clear list*)
				FolderHandling.Data.Step := 11;  (* next step*)
			ELSIF FolderHandling.Functionblock.DirInfo_0.status = ERR_FUB_BUSY THEN  (* DirInfo not finished -> redo *)			
				(* Busy *)		
			ELSE  (* Goto FolderError Step *)
				FolderHandling.Data.Step := 255;
			END_IF		

			(***********************************************************************************************)	
		11: (* read information about files and folders *)
			FolderHandling.Functionblock.DirRead_0.enable := 1;
			FolderHandling.Functionblock.DirRead_0.pDevice := ADR(FolderHandling.Data.Device);  (* name of the device *)
			FolderHandling.Functionblock.DirRead_0.pPath := 0;
			FolderHandling.Functionblock.DirRead_0.option := fiBOTH;  (* read files and folders *)
			FolderHandling.Functionblock.DirRead_0.entry := FolderCounter;
			FolderHandling.Functionblock.DirRead_0.pData := ADR(ReadData);
			FolderHandling.Functionblock.DirRead_0.data_len := SIZEOF(ReadData);
			FolderHandling.Functionblock.DirRead_0;  (* call the function*)
			
			IF FolderHandling.Functionblock.DirRead_0.status = 0 THEN  (* DirRead successful *)
				(* copy found name into string-array *)
				strcpy( ADR(FolderHandling.Data.FileList[FolderCounter]), ADR(ReadData.Filename[0]) );
				(* increase FolderCounter *)
				FolderCounter := FolderCounter + 1;
				(* are all files and folders readed out? *)
				IF ( FolderCounter < (FolderHandling.Functionblock.DirInfo_0.dirnum + FolderHandling.Functionblock.DirInfo_0.filenum) ) THEN
					FolderHandling.Data.Step := 11;  (* read next element *)	
				ELSE
					FolderHandling.Data.Step := 1;  (* next step *)
					FolderHandling.Command.bDirRead := 0; (* reset command *)
				END_IF			
			ELSIF FolderHandling.Functionblock.DirRead_0.status = ERR_FUB_BUSY THEN  (* DirRead not finished -> redo *)			
				(* Busy *)		
			ELSE  (* Goto FolderError Step *)
				FolderHandling.Data.Step := 255;
			END_IF	  
		
			(***********************************************************************************************)	
		20: (* create a new folder *)
			FolderHandling.Functionblock.DirCreate_0.enable := 1;
			FolderHandling.Functionblock.DirCreate_0.pDevice := ADR(FolderHandling.Data.Device);  (* name of the device *)
			FolderHandling.Functionblock.DirCreate_0.pName := ADR(FolderHandling.Data.DirName);
			FolderHandling.Functionblock.DirCreate_0;  (* call the function*)
			
			IF FolderHandling.Functionblock.DirCreate_0.status = 0 THEN  (* DirCreate successful *)
				FolderHandling.Data.Step := 1;  (* next step *)
				FolderHandling.Command.bDirCreate := 0; (* reset command *)		
			ELSIF FolderHandling.Functionblock.DirCreate_0.status = ERR_FUB_BUSY THEN  (* DirCreate not finished -> redo *)			
				(* Busy *)		
			ELSE  (* Goto FolderError Step *)
				FolderHandling.Data.Step := 255;
			END_IF	  
	
			(***********************************************************************************************)	
		30: (* copy a folder *)
			FolderHandling.Functionblock.DirCopy_0.enable := 1;
			FolderHandling.Functionblock.DirCopy_0.pSrcDev := ADR(FolderHandling.Data.Device);  (* name of the device *)
			FolderHandling.Functionblock.DirCopy_0.pSrcDir := ADR(FolderHandling.Data.DirName);  (* source folder name *)
			FolderHandling.Functionblock.DirCopy_0.pDestDev := ADR(FolderHandling.Data.Device);  (* name of the device *)
			FolderHandling.Functionblock.DirCopy_0.pDestDir := ADR(FolderHandling.Data.NewDirName);  (* destination folder name *)
			FolderHandling.Functionblock.DirCopy_0.option := fiOVERWRITE; (* overwrite mode*)
			FolderHandling.Functionblock.DirCopy_0;  (* call the function*)
			
			IF FolderHandling.Functionblock.DirCopy_0.status = 0 THEN  (* DirCopy successful *)
				FolderHandling.Data.Step := 1;  (* next step *)
				FolderHandling.Command.bDirCopy := 0; (* reset command *)		
			ELSIF FolderHandling.Functionblock.DirCopy_0.status = ERR_FUB_BUSY THEN  (* DirCopy not finished -> redo *)			
				(* Busy *)		
			ELSE  (* Goto FolderError Step *)
				FolderHandling.Data.Step := 255;
			END_IF		

			(***********************************************************************************************)	
		40: (* rename a folder *)
			FolderHandling.Functionblock.DirRename_0.enable := 1;
			FolderHandling.Functionblock.DirRename_0.pDevice := ADR(FolderHandling.Data.Device);  (* name of the device *)
			FolderHandling.Functionblock.DirRename_0.pName:= ADR(FolderHandling.Data.DirName);  (* name of the folder *)
			FolderHandling.Functionblock.DirRename_0.pNewName := ADR(FolderHandling.Data.NewDirName);  (* new name of the folder*)
			FolderHandling.Functionblock.DirRename_0;  (* call the function*)
			
			IF FolderHandling.Functionblock.DirRename_0.status = 0 THEN  (* DirRename successful *)
				FolderHandling.Data.Step := 1;  (* next step *)
				FolderHandling.Command.bDirRename := 0; (* reset command *)		
			ELSIF FolderHandling.Functionblock.DirRename_0.status = ERR_FUB_BUSY THEN  (* DirRename not finished -> redo *)			
				(* Busy *)		
			ELSE  (* Goto FolderError Step *)
				FolderHandling.Data.Step := 255;
			END_IF	

			(***********************************************************************************************)	
		50: (* delete a folder *)
			FolderHandling.Functionblock.DirDelete_0.enable := 1;
			FolderHandling.Functionblock.DirDelete_0.pDevice := ADR(FolderHandling.Data.Device);  (* name of the device *)
			FolderHandling.Functionblock.DirDelete_0.pName:= ADR(FolderHandling.Data.DirName);  (* name of the folder *)
			FolderHandling.Functionblock.DirDelete_0;  (* call the function*)
			
			IF FolderHandling.Functionblock.DirDelete_0.status = 0 THEN  (* DirDelete successful *)
				FolderHandling.Data.Step := 1;  (* next step *)
				FolderHandling.Command.bDirDelete := 0; (* reset command *)		
			ELSIF FolderHandling.Functionblock.DirDelete_0.status = ERR_FUB_BUSY THEN  (* DirDelete not finished -> redo *)			
				(* Busy *)		
			ELSE  (* Goto FolderError Step *)
				FolderHandling.Data.Step := 255;
			END_IF			
	
			(***********************************************************************************************)	
		60: (* read information about your device *)
			FolderHandling.Functionblock.DevMemInfo_0.enable := 1;
			FolderHandling.Functionblock.DevMemInfo_0.pDevice := ADR(FolderHandling.Data.Device);  (* name of the device *)
			FolderHandling.Functionblock.DevMemInfo_0;  (* call the function*)
			
			IF FolderHandling.Functionblock.DevMemInfo_0.status = 0 THEN  (* DevMemInfo successful *)
				(* FolderHandling.Functionblock.DevMemInfo_0.memsize contains the memsize of your device *)
				(* FolderHandling.Functionblock.DevMemInfo_0.freemem contains the free memsize of your device*)
				FolderHandling.Data.Step := 1;  (* next step *)
				FolderHandling.Command.bDevMemInfo := 0; (* reset command *)		
			ELSIF FolderHandling.Functionblock.DevMemInfo_0.status = ERR_FUB_BUSY THEN  (* DevMemInfo not finished -> redo *)			
				(* Busy *)		
			ELSE  (* Goto FolderError Step *)
				FolderHandling.Data.Step := 255;
			END_IF	

			(***********************************************************************************************)	
		70: (* read information about your device settings *)
			FolderHandling.Functionblock.GetAttributes_0.enable := 1;
			FolderHandling.Functionblock.GetAttributes_0.pDevice := ADR(FolderHandling.Data.Device);  (* name of the device *)
			FolderHandling.Functionblock.GetAttributes_0.pPath := ADR(FolderHandling.Data.DirName);  (* name of the folder *)
			FolderHandling.Functionblock.GetAttributes_0;  (* call the function*)
			
			IF FolderHandling.Functionblock.GetAttributes_0.status = 0 THEN  (* GetAttributes successful *)
				(* FolderHandling.Functionblock.GetAttributes_0.attributes *)
				FolderHandling.Data.Step := 1;  (* next step *)
				FolderHandling.Command.bGetAttributes := 0; (* reset command *)		
			ELSIF FolderHandling.Functionblock.GetAttributes_0.status = ERR_FUB_BUSY THEN  (* GetAttributes not finished -> redo *)			
				(* Busy *)		
			ELSE  (* Goto FolderError Step *)
				FolderHandling.Data.Step := 255;
			END_IF	

			(***********************************************************************************************)	
		80: (* set device settings *)
			FolderHandling.Functionblock.SetAttributes_0.enable := 1;
			FolderHandling.Functionblock.SetAttributes_0.pDevice := ADR(FolderHandling.Data.Device);  (* name of the device *)
			FolderHandling.Functionblock.SetAttributes_0.pPath := ADR(FolderHandling.Data.DirName);  (* name of the folder *)
			FolderHandling.Functionblock.SetAttributes_0.attributes := fiATTR_RDONLY;  (* make device readonly *)
			FolderHandling.Functionblock.SetAttributes_0.option := fiRECURSIVE;  (* include all subfolders *)
			FolderHandling.Functionblock.SetAttributes_0;  (* call the function*)
			
			IF FolderHandling.Functionblock.SetAttributes_0.status = 0 THEN  (* GetAttributes successful *)
				(* FolderHandling.Functionblock.GetAttributes_0.attributes *)
				FolderHandling.Data.Step := 1;  (* next step *)
				FolderHandling.Command.bSetAttributes := 0; (* reset command *)		
			ELSIF FolderHandling.Functionblock.SetAttributes_0.status = ERR_FUB_BUSY THEN  (* GetAttributes not finished -> redo *)			
				(* Busy *)		
			ELSE  (* Goto FolderError Step *)
				FolderHandling.Data.Step := 255;
			END_IF	
	
			(***********************************************************************************************)	
		255:  (* Here some FolderError FolderHandling has to be implemented *)
			
			

	END_CASE
	
END_ACTION
