
TYPE
	ThicknessCtrl_RejectBoardEdge : 
		(
		REJECT_FRONT,
		REJECT_REAR
		);
	stThicknessCtrl_ouputs_typ : 	STRUCT  (*For now just a copy of ALL parameters*)
		xHoldReject : BOOL; (*While signal is active, reject remains activated*)
		xReject : BOOL; (*Signal for stacker to reject a single board*)
		xEnableMediaSignalToCb : BOOL;
		xMediaFiltered : BOOL; (*Signal active when detection system detects a real media*)
	END_STRUCT;
	stThicknessCtrl_CheckMediaInput : 	STRUCT 
		xCheckFail : BOOL; (*Media is not detected when it sould be*)
	END_STRUCT;
	stThicknessCtrl_inputs_typ : 	STRUCT  (*For now just a copy of ALL parameters*)
		xVirtualMedia : BOOL; (*Virtual Media Present a the entrance of the machine (Instant or Continuous print)*)
		CheckMedia : ARRAY[0..MAX_LAST_CHECKMEDIA]OF stThicknessCtrl_CheckMediaInput;
	END_STRUCT;
	stThickCtrl_StackStatus_typ : 	STRUCT  (*For now just a copy of ALL parameters*)
		iInsideMediaL1 : USINT; (*Total media below the blocks*)
		iInsideMediaL2 : USINT; (*Total media below the blocks*)
		iNewMediaLoadedL1 : UINT; (*Total new media loaded*)
		iNewMediaLoadedL2 : UINT; (*Total new media loaded*)
	END_STRUCT;
	stThickCtrl_HeighStatus_typ : 	STRUCT  (*For now just a copy of ALL parameters*)
		iMediaHeigh : UINT; (*Value measured of the media heigh in mm (max 650mm, resolution 0.01)*)
		rMediaHeigh : REAL; (*Value measured of the media heigh in mm (max 650mm)*)
		rMediaThickness : REAL; (*Value of the expected Thickness value depending on the configuration of the machine. ContinuousMedia or from Stack*)
		rMediaThicknessMargin : REAL; (*Value of the expected Thickness+Margin value depending on the configuration of the machine. ContinuousMedia or from Stack*)
		xIncreasedHeigh : ARRAY[0..TOTAL_THICKNESS_SECTIONS]OF BOOL;
		rMaxHeigh : ARRAY[0..TOTAL_THICKNESS_SECTIONS]OF REAL; (*Valuen in mm  NOTE: Element 0 is not used*)
	END_STRUCT;
	stThickCtrl_RejectStatus_typ : 	STRUCT  (*For now just a copy of ALL parameters*)
		xRejecting : BOOL; (*Active when reject is activated. This signal is a 2 secons pulse to allow see it*)
		iBoardsRejected : UINT; (*Counter of boards rejected by stacker*)
		iTimesInRejection : UINT; (*Counter of boards rejected*)
		iTimesInRejectionToday : UINT; (*Counter of boards rejected*)
	END_STRUCT;
	stThickCtrl_DetSystemStatus_typ : 	STRUCT  (*For now just a copy of ALL parameters*)
		xInPosition : BOOL; (*Active when device used for thicknessctrl is positioned for printing*)
	END_STRUCT;
	stThickCtrl_BeltStatus_typ : 	STRUCT  (*For now just a copy of ALL parameters*)
		xBeltEmpty : BOOL;
		iBeltTurns : UINT;
		rBeltPositionMmInit : REAL;
		rBeltPositionMmFinal : REAL;
		rBeltSpeed : REAL;
	END_STRUCT;
	stThickCtrl_DryerIntensityStatus : 	STRUCT 
		Intensity : ARRAY[0..THICKENERGY_MAX_LAMPS]OF INT; (*Data starting in index 1*)
	END_STRUCT;
	stThickCtrl_DryerMediaStatus : 	STRUCT 
		xMediaInPosition : BOOL;
		Intensity : ARRAY[0..THICKENERGY_MAX_LAMPS]OF INT; (*Data starting in index 1*)
	END_STRUCT;
	stThickCtrl_LedLineMediaStatus : 	STRUCT 
		xMediaInLedPosition : BOOL;
		Media : stThicknessCtrl_MediaConfig;
	END_STRUCT;
	stThickCtrl_LineMediaStatus : 	STRUCT 
		White : stThickCtrl_LedLineMediaStatus;
		Color : stThickCtrl_LedLineMediaStatus;
		Primer : stThickCtrl_LedLineMediaStatus;
		NirDryer : ARRAY[0..MAX_LAST_NIR_MODULES]OF stThickCtrl_DryerMediaStatus;
		InsideMedia : ARRAY[0..THICK_MEDIATRACKING_MAX_MEDIA]OF stThicknessCtrl_MediaPosStatus;
		iBoardsBelowBlock : UINT; (*Counter of boards that are below the printer properly detected by productDetect*)
		xDetectionSystemIncoherence : BOOL; (*There is no media detection consistensy between PD an the array sensor*)
	END_STRUCT;
	stThickCtrl_MediaPositionStatus : 	STRUCT  (*For now just a copy of ALL parameters*)
		xMediaAtPrinterExit : BOOL; (*There is media at the end of printer's belt*)
		xMediaInside : BOOL; (*Some media has passed the first sensor and still not exited*)
		xTrackingEmpty : BOOL; (*Some media has passed the first sensor and still not exited the tracking distance*)
		xMountedMediaInside : BOOL;
		xVirtualMediaInside : BOOL; (*Some Virtual media has passed the first sensor and still not exited*)
		xMediaToRejectInside : BOOL; (*Media to be rejected has beed detected and it is below the machine*)
		xMediaBelowMachine : BOOL; (*There is media below the machine (not considered the distance between the sensor and the first block)*)
		xMediaInWarpSensorPosition : BOOL;
		L1 : stThickCtrl_LineMediaStatus;
		L2 : stThickCtrl_LineMediaStatus;
		iBoardsBelowBlock : UINT; (*Counter of boards that are below the printer properly detected by productDetect*)
	END_STRUCT;
	stThickCtrl_DetectionStatus_typ : 	STRUCT  (*For now just a copy of ALL parameters*)
		xMediaInProductDetect : BOOL;
		xMediaToRejectDetected : BOOL; (*Media to be rejected is beed detected now*)
		xFilteredProductDetectMediaL1 : BOOL;
		xFilteredProductDetectMediaL2 : BOOL;
		xFilteredAnalogSensorMedia : BOOL;
		xFilteredArraySensorMedia : BOOL;
		xFilteredBasicDetectionMedia : BOOL;
		iBoardsFromStartL1 : UDINT; (*Detected boards since belt is started. Reseted when belt starts again. Needed media tracking enable to use it*)
		iBoardsFromStartL2 : UDINT; (*Detected boards since belt is started. Reseted when belt starts again. Needed media tracking enable to use it*)
		iTotalBoardsL1 : UDINT; (*Detected boards since PLC is started. Needed media tracking enable to use it*)
		iTotalBoardsL2 : UDINT; (*Detected boards since PLC is started. Needed media tracking enable to use it*)
	END_STRUCT;
	stThicknessCtrl_status_typ : 	STRUCT  (*For now just a copy of ALL parameters*)
		Detection : stThickCtrl_DetectionStatus_typ;
		MediaPosition : stThickCtrl_MediaPositionStatus;
		Belt : stThickCtrl_BeltStatus_typ;
		DetectionSystem : stThickCtrl_DetSystemStatus_typ;
		Dry : ARRAY[0..MAX_LAST_NIR_MODULES]OF stThickCtrl_DryerIntensityStatus;
		Reject : stThickCtrl_RejectStatus_typ;
		Heigh : stThickCtrl_HeighStatus_typ;
		Stack : stThickCtrl_StackStatus_typ;
		iReadEnergyFileStep : USINT; (*1: Idle, 255:Error*)
		xNewMediaStackEnabled : BOOL; (*New Media Stack functionality enabled in the PLC*)
		xMediaTrackingEnabled : BOOL; (*Media Tracking functionality enabled in the PLC*)
	END_STRUCT;
	ThicknessCtrl_PositionSect_typ : 	STRUCT  (*Structure to define the position to detect if there is media below*)
		iPosition : UINT; (*Value in cm from the sensor*)
	END_STRUCT;
	stThicknessCtrl_Section_typ : 	STRUCT 
		iEnd : UINT;
		iStart : UINT;
		xEnabled : BOOL := FALSE;
	END_STRUCT;
	stThicknessCtrl_BeltParams : 	STRUCT 
		iBeltPerimeterLength : UINT; (*Perimeter of belt. Value in cm*)
		rMinBeltSpeedToStart : REAL; (*Value of the Speed in m/min*)
		iDistanceEmptyBeltIni : INT; (*Distance in cm from thickness media sensor detector to the end of the belt. This distance is mechanical. Not related with Reject*)
		rBeltSpeed : REAL; (*Current Belt Speed in m/min*)
	END_STRUCT;
	stThicknessCtrl_RejectParams : 	STRUCT 
		iHoldRejectDistance : INT; (*Distance between end of printer's belt and stacker's hold reject position in cm. If negative, the reject signal is given with the media inside the printer*)
		iRejectDistance : INT; (*Distance between end of printer's belt and stacker's reject sheet position in cm. If negative, the reject signal is given with the media inside the printer*)
		RejectBoardEdge : ThicknessCtrl_RejectBoardEdge; (*Reject the boards with the FrontEdge or with the RearEdge*)
		xRejectTracking : BOOL; (*Reject feature active and reject array has to be evaluated*)
		xLoadMediaFromProductDetect : BOOL; (*Source of the media data*)
	END_STRUCT;
	stThickCtrl_SecDetectionParams : 	STRUCT 
		iMediaFilter : UINT;
		iSensorPosition : UINT; (*Position of the sensor in X direction in cm*)
		xLoadMedia : BOOL; (*Source of the media data*)
		xEnableMediaTracking : BOOL; (*Track the data of the sensor in the present media array*)
		xEnableSensorIncoherAlarm : BOOL; (*Enable the sensor incoherenci alarm, reviewing the sensor array in detection when arriving media to ProductDetect*)
	END_STRUCT;
	stThickCtrl_DetectionPrDetPar : 	STRUCT 
		iMediaFilter : UINT;
		iSensorPosition : UINT; (*Position of the sensor in X direction in cm*)
		xLoadMedia : BOOL; (*Source of the media data*)
		xFixedSensor : BOOL; (*Active if the sensor is fixed and reads properly always*)
		pMediaInProductDetectL1 : {REDUND_UNREPLICABLE} UDINT; (*Pointer to MediaInProductDetect*)
		pMediaInProductDetectL2 : {REDUND_UNREPLICABLE} UDINT; (*Pointer to MediaInProductDetect*)
	END_STRUCT;
	stThicknessCtrl_DetectionParams : 	STRUCT 
		ProductDetect : stThickCtrl_DetectionPrDetPar;
		Array : stThickCtrl_SecDetectionParams;
		Analog : stThickCtrl_SecDetectionParams;
		Basic : stThickCtrl_SecDetectionParams;
		xEnabledStack : BOOL; (*Use the stack for considering the new media is entering the machine. If disabled, new media taken from continuous media*)
	END_STRUCT;
	stThicknessCtrl_NirDryerParams : 	STRUCT 
		iPosition : UINT; (*Center position of the Dryer*)
	END_STRUCT;
	stThicknessCtrl_CureLampParams : 	STRUCT 
		iStartWindow : UINT; (*Initial position of curing window in cm*)
		iEndWindow : UINT; (*End position of curing window in cm*)
		xEnabled : BOOL; (*Enabled to cure*)
	END_STRUCT;
	stThicknessCtrl_CureParams : 	STRUCT 
		xEnableTracking : BOOL; (*Cure feature active and reject array has to be evaluated. OLD ARRAY IMPLEMENTATION*)
		xEnableMediaTracking : BOOL; (*Cure MediaTracking is activated and has to be evaluated*)
		White : stThicknessCtrl_CureLampParams;
		Color : stThicknessCtrl_CureLampParams;
		Primer : stThicknessCtrl_CureLampParams;
	END_STRUCT;
	stThicknessCtrl_NirDryParams : 	STRUCT 
		xDryStack : BOOL; (*Use the stack for considering the new media is entering the machine. If disabled, new media taken from continuous media*)
		xEnableMediaTracking : BOOL; (*Dry tracking is activated and has to be evaluated*)
		rCommsDelay : REAL; (*Comms delay in ms*)
		rThermalDelay : REAL; (*Thermal delay in ms*)
		rSubstratePowerReduction : REAL := 1.0; (*Substrate power reduction. From 1.0 (default) to 0.3 is allowed*)
		rThermalInerciaReduction : REAL := 1.0; (*Thermal Inercia Power reduction. From 1.0 (default) to 0.8 is allowed*)
		iMinDryValue : INT; (*Minimum value to consider when no media is detected. To avoid sending 0 and the change is too big*)
		iLamps : USINT; (*Total quantity of Lamps in the machine*)
		rLampWidth : REAL := 30; (*Width of each lamp. Value in mm*)
		rLampOffset : REAL := 700; (*Offset of the LAST  lamp considering the center of the belt as 0. Positive to operator side. Value in mm*)
		rDryExtend : REAL := 0; (*Extra width to consider for each lamp in each side to check the image to dry. Value in mm*)
		Dryers : ARRAY[0..MAX_LAST_NIR_MODULES]OF stThicknessCtrl_NirDryerParams;
	END_STRUCT;
	stThicknessCtrl_CheckMediaParams : 	STRUCT 
		xActive : BOOL; (*Activate CheckMedia. If media should be there but there is not, raise a signa to define an alarm*)
		xCheckGap : BOOL; (*Activate Checking the gap after the Media. This should just be activated if the machine ALWAYS have a quite big gap between media*)
		CheckPosition : UINT; (*Position of the sensor to check the media should be there. Value in cm*)
		CheckDelayPosition : UINT; (*Positions of the sensor to wait to be inside the board. Value in cm*)
		iSensorFilter : REAL; (*Distance with the signal activated/deactivated to consider the value of the sensor has changed. Value in mm*)
	END_STRUCT;
	stThicknessCtrl_params_typ : 	STRUCT 
		AutoMode : stEFI_MachineAutoModes; (*Machine modes operate in automatic mode*)
		Mode : StGeneral_States_Mode; (*Machine general modes (manual, zero, automatic)*)
		iTotalBlocksLengh : UINT; (*Value in cm*)
		Detection : stThicknessCtrl_DetectionParams;
		Cure : stThicknessCtrl_CureParams;
		Dry : stThicknessCtrl_NirDryParams;
		CheckMedia : ARRAY[0..MAX_LAST_CHECKMEDIA]OF stThicknessCtrl_CheckMediaParams; (*CheckMedia to detect jams. 0 not used*)
		Belt : stThicknessCtrl_BeltParams;
		xDoubleLine : BOOL; (*Double line active*)
		sections : ARRAY[0..TOTAL_THICKNESS_SECTIONS]OF stThicknessCtrl_Section_typ;
		iSections : USINT := 1; (*Total quantity of sections used in the machine*)
		Reject : stThicknessCtrl_RejectParams;
		xBlockInProperPrintingPosition : BOOL; (*While block is not in proper position, PD signals going TO CBs are disabled and the boards are rejected*)
		ContinuousMedia : stThickCtrl_EnergyMedia;
		pExtContMedia : UDINT; (*Pointer to stThicknessCtrl_MediaConfig*)
		rMarginSafePrint : REAL; (*Coming from Sw. Fix offset to bent tile. The heads go to the thickness measured + this value. Value in mm*)
		xMarginForBendTile : BOOL; (*To apply margin safe print when photocells installed*)
		rSafetyMarginToHeight : REAL; (*Margin Height  to add to current value in Height array with  commands.xAddSafetyMarginToHeight. Value in mm*)
		rMountedMediaHeigh : REAL; (*Heigh to assign to the rHeigh array when a mounted media is detected*)
		iDistanceFromArrayToPd : UINT; (*Distance from sensor used as reference in array sensor assembly to product detect in process direction*)
		xBlockInPrint : BOOL; (*Block in position state BLOCKP_IN_PRINT*)
	END_STRUCT;
	stThicknessCtrl_paraSw : 	STRUCT 
		Dry : stThicknessCtrl_paraSwDry;
	END_STRUCT;
	stThicknessCtrl_paraSwDry : 	STRUCT 
		xForceManIntensity : BOOL;
		xReadFile : BOOL; (*Read file from FTP server*)
		xGetMaxFromFileInfo : BOOL; (*When RaiseEdge, clean max data and with RaiseEdge of EmptyBelt, copy max to parSw.Dry.Intensity*)
		ManIntensity : ARRAY[0..MAX_LAST_NIR_MODULES]OF stThickCtrl_DryerIntensityStatus;
	END_STRUCT;
	stThicknessCtrl_Commands_typ : 	STRUCT 
		UpdateAllMatrix : BOOL; (*Order to update all the position array just with an edge*)
		xResetMediaBelow : BOOL; (*Reset counters of media below the machine*)
		xRushProof : BOOL; (*Signal from SW to reject media present at the entrance of the machine*)
		xCameraDefectDetected : BOOL; (*Signal from camera to reject media*)
		xAllowToSetMountedMediaHeigh : BOOL; (*Command to let bars to be raised to predefined mounted media heigh position when mounted media alarm*)
		xAddSafetyMarginToHeight : BOOL; (*Command to add the Safety Margin to current Height in the array*)
		xErrorRst : BOOL; (*Order to reset Alarms*)
		xMute : BOOL; (*Mute Order*)
		xReviewIncoherenceArrayAndPd : BOOL;
	END_STRUCT;
	stThicknessCtrl_Orders_typ : 	STRUCT 
		xDiscardAllMedia : BOOL; (*Order to discard all media below printer*)
	END_STRUCT;
	stThicknessCtrl_Alarms_typ : 	STRUCT 
		xNoThicknessInstalled : BOOL; (*No Thickness System Installed or Selected in SW*)
		CheckMedia : ARRAY[0..MAX_LAST_CHECKMEDIA]OF BOOL; (*0 is not used. Summary of the head and tail alarms*)
		CheckMediaHead : ARRAY[0..MAX_LAST_CHECKMEDIA]OF BOOL; (*0 is not used*)
		CheckMediaTail : ARRAY[0..MAX_LAST_CHECKMEDIA]OF BOOL; (*0 is not used*)
	END_STRUCT;
	stThicknessCtrl_Internal_typ : 	STRUCT 
		ProductDetectValuesL1 : ARRAY[0..THICK_MAX_UPDATE_VALUES]OF BOOL; (*Values of the digital signal. 0 is not used*)
		ProductDetectValuesL2 : ARRAY[0..THICK_MAX_UPDATE_VALUES]OF BOOL; (*Values of the digital signal. 0 is not used*)
		MediaArraySensorValues : ARRAY[0..THICK_MAX_UPDATE_VALUES]OF BOOL; (*Values of the digital signal. 0 is not used*)
		MediaAnalogValues : ARRAY[0..THICK_MAX_UPDATE_VALUES]OF BOOL; (*Values of the digital signal. 0 is not used*)
		MediaDetectionValues : ARRAY[0..THICK_MAX_UPDATE_VALUES]OF BOOL; (*Values of the digital signal. 0 is not used*)
		MediaDetectionValuesL1 : ARRAY[0..THICK_MAX_UPDATE_VALUES]OF BOOL; (*Values of the digital signal. 0 is not used*)
		MediaDetectionValuesL2 : ARRAY[0..THICK_MAX_UPDATE_VALUES]OF BOOL; (*Values of the digital signal. 0 is not used*)
		ArrayHeightValues : ARRAY[0..THICK_MAX_UPDATE_VALUES]OF UINT; (*Values of the Thickness Detection signal. 0 is not used*)
		AnalogHeightValues : ARRAY[0..THICK_MAX_UPDATE_VALUES]OF UINT; (*Values of the Thickness Detection signal. 0 is not used*)
		CheckMediaFilteredSensors : ARRAY[0..MAX_LAST_CHECKMEDIA]OF BOOL; (*Filtered signal of the CheckMedia Inputs. 0 not used*)
		rCycleSlow : REAL;
		rCycleFast : REAL;
		iFastValues : UINT; (*Quantity of values read by the fast section of the code each time the slow section is executed*)
		rFastValues : REAL; (*Quantity of values read by the fast section of the code each time the slow section is executed*)
		xMediaToRejectTreated : BOOL;
		rMarginSafePrintChecked : REAL; (*Fix offset to bent tile. The heads go to the thickness measured + this value. Value in mm. Checked minimum value*)
		pMediaTracking : UDINT; (*Pointer to xMediaTracking >> USINT[0..iMAXTRACKINGARRAY]*)
		pDistanceWorkEmptyBelt : UDINT; (*Pointer to iDistanceWorkEmptyBelt*)
		iTotalBoards : UDINT; (*Total boards managed*)
	END_STRUCT;
	stThicknessCtrl_typ : 	STRUCT 
		Commands : stThicknessCtrl_Commands_typ;
		Orders : stThicknessCtrl_Orders_typ;
		Inputs : stThicknessCtrl_inputs_typ;
		status : stThicknessCtrl_status_typ;
		parameters : stThicknessCtrl_params_typ;
		parSw : stThicknessCtrl_paraSw;
		Outputs : stThicknessCtrl_ouputs_typ;
		Internal : stThicknessCtrl_Internal_typ;
		Alarms : stThicknessCtrl_Alarms_typ;
		AlSummary : stEFI_AlarmSummary;
	END_STRUCT;
END_TYPE
