
ACTION GetSystemTime: 
	
	getTime.enable := TRUE;
	getTime.pDTStructure := ADR(TimeValue);
	getTime();
	
	IF getTime.status = ERR_OK THEN
		iYear := TimeValue.year;
		brsitoa(iYear, ADR(strYear));
	END_IF
	
END_ACTION

ACTION CreateFolderYear:
	
	strcpy( ADR(FolderHandling.Data.DirName), ADR(FOLDER_SIM_REG) );
	brsstrcat( ADR(FolderHandling.Data.DirName), ADR('/'));
	brsstrcat( ADR(FolderHandling.Data.DirName), ADR(strYear));

END_ACTION

ACTION CreateFileReg:

	strcpy( ADR(Handling.Data.FileName), ADR(FOLDER_SIM_REG) );
	brsstrcat( ADR(Handling.Data.FileName), ADR('/'));
	brsstrcat( ADR(Handling.Data.FileName), ADR(strYear));
	brsstrcat( ADR(Handling.Data.FileName), ADR('/'));
			
	brsitoa(iYear, ADR(FileNameAux));
	brsstrcat( ADR(Handling.Data.FileName), ADR(FileNameAux));
	brsstrcat( ADR(Handling.Data.FileName), ADR('-'));
			
	FileNameAuxPre := '0';
	iDigits := brsitoa(TimeValue.month, ADR(FileNameAux));
	IF iDigits = 1 THEN
		brsstrcat( ADR(FileNameAuxPre), ADR(FileNameAux));
		brsstrcat( ADR(Handling.Data.FileName), ADR(FileNameAuxPre));
	ELSE
		brsstrcat( ADR(Handling.Data.FileName), ADR(FileNameAux));
	END_IF
	brsstrcat( ADR(Handling.Data.FileName), ADR('-'));
			

	FileNameAuxPre := '0';
	iDigits := brsitoa(TimeValue.day, ADR(FileNameAux));
	IF iDigits = 1 THEN
		brsstrcat( ADR(FileNameAuxPre), ADR(FileNameAux));
		brsstrcat( ADR(Handling.Data.FileName), ADR(FileNameAuxPre));
	ELSE
		brsstrcat( ADR(Handling.Data.FileName), ADR(FileNameAux));
	END_IF
	brsstrcat( ADR(Handling.Data.FileName), ADR('.'));
			
	FileNameAuxPre := '0';
	iDigits := brsitoa(TimeValue.hour, ADR(FileNameAux));
	IF iDigits = 1 THEN
		brsstrcat( ADR(FileNameAuxPre), ADR(FileNameAux));
		brsstrcat( ADR(Handling.Data.FileName), ADR(FileNameAuxPre));
	ELSE
		brsstrcat( ADR(Handling.Data.FileName), ADR(FileNameAux));
	END_IF
	brsstrcat( ADR(Handling.Data.FileName), ADR('-'));

	brsstrcat( ADR(Handling.Data.FileName), ADR('00')); //For the minutes

END_ACTION