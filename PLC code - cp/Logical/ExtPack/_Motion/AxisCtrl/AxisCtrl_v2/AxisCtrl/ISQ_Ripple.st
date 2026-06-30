
ACTION ISQ_Ripple: 

//	
//		ISQ RIPPLE IDENTIFICATION READ/WRITE
//	
//
//		The Reading/Upload is started writing a 0 in iISQUploadindex, and after that, 
//	when iISQUploadindex arrives to 10, the reading is finished and all the values in
//	the variable isqRippleData
//	
//		The Writing/Download is started writing a 0 in iISQDownloadindex, and after that, 
//	when iISQDownloadindex arrives to 10, the reading is finished and all the values in
//	the variable isqRippleData
//	
//		isqRippleData MUST be declared as GLOBAL and as RETAIN
//		MC_ISQ_RippleData_typ MUST be declared in a GLOBAL scope
//		
//		This code must be in the AxisControl program, to have the references to the Axis	
//		NOTE: Do not execute this code with a Test window open
//	
//
//	
	
	
	(*------------------------------------------------------------------------
	/		READING THE PARAMS FROM THE DRIVE
	/------------------------------------------------------------------------*)
	
	xISQUploadnext:=TRUE;
	
	//IMPORTANT!!! THE FUNCTIONS MUST BE CALLED PRIOR TO THE CASE

	fbISQReadParUpload.Axis:=AxisRef;
	fbISQReadParUpload.Execute:=xISQOrderReadUpload;
	fbISQReadParUpload.ParID:= uiISQparId;
	fbISQReadParUpload.DataAddress:= udiISQdataAddres;
	fbISQReadParUpload.DataType:= ncPAR_TYP_REAL;
	fbISQReadParUpload();

	fbISQWriteParUpload.Axis:=AxisRef;
	fbISQWriteParUpload.Execute:=xISQOrderWriteUpload;
	fbISQWriteParUpload.ParID:=uiISQparId;
	fbISQWriteParUpload.DataAddress:=udiISQdataAddres;
	fbISQWriteParUpload.DataType:=ncPAR_TYP_DINT;
	fbISQWriteParUpload();
	
	IF EDGEPOS(xISQOrderReadUpload) THEN xISQOrderReadUploadCount:=xISQOrderReadUploadCount+1; END_IF
	IF EDGEPOS(xISQOrderWriteUpload) THEN xISQOrderWriteUploadCount:=xISQOrderWriteUploadCount+1; END_IF
	
	//Prepare the subindex to be ready to work
	IF iISQUploadindex >9 THEN
		iISQUploadsubindex := 0;
	ELSE
		ISQ_RippleUploadWriteIndex;
		ISQ_RippleUploadReadsingle;
	END_IF

	
	(*------------------------------------------------------------------------
	/		WRITING THE PARAMS TO THE DRIVE
	/------------------------------------------------------------------------*)
	
	xISQDownloadnext:=TRUE;
	
	//IMPORTANT!!! THE FUNCTIONS MUST BE CALLED PRIOR TO THE CASE

	fbISQWriteSingleParDownload.Axis:=AxisRef;
	fbISQWriteSingleParDownload.Execute:=xISQOrderWriteSingleDownload;
	fbISQWriteSingleParDownload.ParID:= uiISQparId;
	fbISQWriteSingleParDownload.DataAddress:= udiISQdataAddres;
	fbISQWriteSingleParDownload.DataType:= ncPAR_TYP_REAL;
	fbISQWriteSingleParDownload();

	fbISQWriteParDownload.Axis:=AxisRef;
	fbISQWriteParDownload.Execute:=xISQOrderWriteDownload;
	fbISQWriteParDownload.ParID:=uiISQparId;
	fbISQWriteParDownload.DataAddress:=udiISQdataAddres;
	fbISQWriteParDownload.DataType:=ncPAR_TYP_DINT;
	fbISQWriteParDownload();
	
	IF EDGEPOS(xISQOrderWriteSingleDownload) THEN xISQOrderWriteSingleDownloadCnt:=xISQOrderWriteSingleDownloadCnt+1; END_IF
	IF EDGEPOS(xISQOrderWriteDownload) THEN xISQOrderWriteDownloadCount:=xISQOrderWriteDownloadCount+1; END_IF
	
	//Prepare the subindex to be ready to work
	IF iISQDownloadindex >9 THEN
		iISQDownloadsubindex := 0;
	ELSE
		ISQ_RippleDownloadWriteIndex;
		ISQ_RippleDownloadWritesingle;
	END_IF	
	
END_ACTION


ACTION ISQ_RippleUploadWriteIndex: 

	iISQTimesInWriteUpload:= iISQTimesInWriteUpload +1;

	IF iISQUploadindex=0 AND iISQUploadsubindex=0 THEN
		isqRippleData:=isqRippleDataEmpty;	
		isqRippleData.xDataOK:=FALSE;
	END_IF

	IF NOT fbISQWriteParUpload.Busy AND NOT fbISQWriteParUpload.Error AND NOT fbISQWriteParUpload.Done AND iISQUploadsubindex=0 AND xISQUploadnext THEN 
		uiISQparId := 		ACP10PAR_ISQ_RIPPLE_DAT_IDX;
		udiISQdataValue := iISQUploadindex;
		udiISQdataAddres :=	ADR(udiISQdataValue);
		xISQOrderWriteUpload := TRUE; 
		xISQUploadnext:=FALSE; 
	END_IF
	
	IF fbISQWriteParUpload.Done AND xISQUploadnext THEN 
		iISQUploadsubindex:=50;
		xISQOrderWriteUpload := FALSE;
		xISQUploadnext:=FALSE;
	END_IF
	
	
END_ACTION


ACTION ISQ_RippleUploadReadsingle: 

	iISQTimesInReadUpload:= iISQTimesInReadUpload+1;

	CASE iISQUploadsubindex OF
	
		
		50:	
			IF NOT fbISQReadParUpload.Busy AND NOT fbISQReadParUpload.Done AND NOT fbISQReadParUpload.Error AND xISQUploadnext THEN 
				uiISQparId := 		ACP10PAR_ISQ_RIPPLE_DAT_F;
				udiISQdataAddres :=	ADR(urISQdataValue);
				xISQOrderReadUpload := TRUE;
				xISQUploadnext:=FALSE;
			END_IF
			IF fbISQReadParUpload.Done AND NOT fbISQReadParUpload.Busy THEN
				isqRippleData.singleData[iISQUploadindex].Freq := urISQdataValue;
				IF xISQUploadnext THEN
					iISQUploadsubindex:=iISQUploadsubindex+1;
					xISQUploadnext:=FALSE;
					xISQOrderReadUpload := FALSE;
				END_IF
			END_IF
	
		51:	
			IF NOT fbISQReadParUpload.Busy AND NOT fbISQReadParUpload.Done AND NOT fbISQReadParUpload.Error AND xISQUploadnext THEN 
				uiISQparId := 		ACP10PAR_ISQ_RIPPLE_DAT_A;
				udiISQdataAddres :=	ADR(urISQdataValue);
				xISQOrderReadUpload := TRUE;
				xISQUploadnext:=FALSE;
			END_IF
			IF fbISQReadParUpload.Done AND NOT fbISQReadParUpload.Busy THEN
				isqRippleData.singleData[iISQUploadindex].Amp := urISQdataValue;
				IF xISQUploadnext THEN
					iISQUploadsubindex:=iISQUploadsubindex+1;
					xISQUploadnext:=FALSE;
					xISQOrderReadUpload := FALSE;
				END_IF
			END_IF
			
		52:	
			IF NOT fbISQReadParUpload.Busy AND NOT fbISQReadParUpload.Done AND NOT fbISQReadParUpload.Error AND xISQUploadnext THEN 
				uiISQparId := 		ACP10PAR_ISQ_RIPPLE_DAT_PHI;
				udiISQdataAddres :=	ADR(urISQdataValue);
				xISQOrderReadUpload := TRUE;
				xISQUploadnext:=FALSE;
			END_IF
			IF fbISQReadParUpload.Done AND NOT fbISQReadParUpload.Busy THEN
				isqRippleData.singleData[iISQUploadindex].Phi := urISQdataValue;
				IF xISQUploadnext THEN
					iISQUploadsubindex:=iISQUploadsubindex+1;
					xISQUploadnext:=FALSE;
					xISQOrderReadUpload := FALSE;
				END_IF
			END_IF
			
	END_CASE
	
	IF iISQUploadsubindex=53 THEN
		iISQUploadsubindex:=0;
		iISQUploadindex:=iISQUploadindex+1;
		IF iISQUploadindex=10 THEN
			isqRippleData.xDataOK:=TRUE;
		END_IF
	END_IF
	
	
END_ACTION


ACTION ISQ_RippleDownloadWriteIndex: 

	iISQTimesInWriteDownload:= iISQTimesInWriteDownload +1;

	IF iISQDownloadindex=0 AND iISQDownloadsubindex=0 THEN
		//isqRippleData:=isqRippleDataEmpty;	
		//isqRippleData.xDataOK:=FALSE;
	END_IF

	IF NOT fbISQWriteParDownload.Busy AND NOT fbISQWriteParDownload.Error AND NOT fbISQWriteParDownload.Done AND iISQDownloadsubindex=0 AND xISQDownloadnext THEN 
		uiISQparId := 		ACP10PAR_ISQ_RIPPLE_DAT_IDX;
		udiISQdataValue := iISQDownloadindex;
		udiISQdataAddres :=	ADR(udiISQdataValue);
		xISQOrderWriteDownload := TRUE; 
		xISQDownloadnext:=FALSE; 
	END_IF
	
	IF fbISQWriteParDownload.Done AND xISQDownloadnext THEN 
		iISQDownloadsubindex:=50;
		xISQOrderWriteDownload := FALSE;
		xISQDownloadnext:=FALSE;
	END_IF
	
	
END_ACTION


ACTION ISQ_RippleDownloadWritesingle: 

	iISQTimesInReadDownload:= iISQTimesInReadDownload+1;

	CASE iISQDownloadsubindex OF
	
		
		50:	
			IF NOT fbISQWriteSingleParDownload.Busy AND NOT fbISQWriteSingleParDownload.Done AND NOT fbISQWriteSingleParDownload.Error AND xISQDownloadnext THEN 
				uiISQparId := 		ACP10PAR_ISQ_RIPPLE_DAT_F;
				urISQdataValue:= isqRippleData.singleData[iISQDownloadindex].Freq;
				udiISQdataAddres :=	ADR(urISQdataValue);
				xISQOrderWriteSingleDownload := TRUE;
				xISQDownloadnext:=FALSE;
			END_IF
			IF fbISQWriteSingleParDownload.Done AND NOT fbISQWriteSingleParDownload.Busy THEN
				IF xISQDownloadnext THEN
					iISQDownloadsubindex:=iISQDownloadsubindex+1;
					xISQDownloadnext:=FALSE;
					xISQOrderWriteSingleDownload := FALSE;
				END_IF
			END_IF
	
		51:	
			IF NOT fbISQWriteSingleParDownload.Busy AND NOT fbISQWriteSingleParDownload.Done AND NOT fbISQWriteSingleParDownload.Error AND xISQDownloadnext THEN 
				uiISQparId := 		ACP10PAR_ISQ_RIPPLE_DAT_A;
				urISQdataValue:= isqRippleData.singleData[iISQDownloadindex].Amp;
				udiISQdataAddres :=	ADR(urISQdataValue);
				xISQOrderWriteSingleDownload := TRUE;
				xISQDownloadnext:=FALSE;
			END_IF
			IF fbISQWriteSingleParDownload.Done AND NOT fbISQWriteSingleParDownload.Busy THEN
				IF xISQDownloadnext THEN
					iISQDownloadsubindex:=iISQDownloadsubindex+1;
					xISQDownloadnext:=FALSE;
					xISQOrderWriteSingleDownload := FALSE;
				END_IF
			END_IF
			
		52:	
			IF NOT fbISQWriteSingleParDownload.Busy AND NOT fbISQWriteSingleParDownload.Done AND NOT fbISQWriteSingleParDownload.Error AND xISQDownloadnext THEN 
				uiISQparId := 		ACP10PAR_ISQ_RIPPLE_DAT_PHI;
				urISQdataValue:= isqRippleData.singleData[iISQDownloadindex].Phi;
				udiISQdataAddres :=	ADR(urISQdataValue);
				xISQOrderWriteSingleDownload := TRUE;
				xISQDownloadnext:=FALSE;
			END_IF
			IF fbISQWriteSingleParDownload.Done AND NOT fbISQWriteSingleParDownload.Busy THEN
				IF xISQDownloadnext THEN
					iISQDownloadsubindex:=iISQDownloadsubindex+1;
					xISQDownloadnext:=FALSE;
					xISQOrderWriteSingleDownload := FALSE;
				END_IF
			END_IF
			
	END_CASE
	
	IF iISQDownloadsubindex=53 THEN
		iISQDownloadsubindex:=0;
		iISQDownloadindex:=iISQDownloadindex+1;
		IF iISQDownloadindex=10 THEN
			isqRippleData.xDataOK:=TRUE;
		END_IF
	END_IF
	
	
END_ACTION
