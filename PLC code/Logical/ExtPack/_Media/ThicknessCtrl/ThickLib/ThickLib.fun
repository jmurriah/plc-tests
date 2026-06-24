
{REDUND_ERROR} FUNCTION LoadMediaFromFastDataLine : BOOL (*Loading Fast data in an array to an array of tracking data. Using USINT array to load differente lines*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		newValues : REFERENCE TO ARRAY[0..THICK_MAX_UPDATE_VALUES] OF BOOL; (*Array of the new Fast values*)
		fastValues : REAL; (*Total fast values loaded in the fast array*)
		indexLine : USINT; (*Number of the bit where to store the data in the tracking array*)
		positionsToRunArray : UINT; (*The positions to run the array. Corresponds the position to load data from fast in slow. Depending on the speed of the belt*)
		sensorPosition : UINT; (*Position of the sensor to insert the new data properly*)
		valuesTracking : REFERENCE TO ARRAY[0..iMAXTRACKINGARRAY] OF USINT; (*values tracked. 1cm per position*)
	END_VAR
	VAR
		iIndexArray : UINT;
		iIndexNewMediaArray : UINT;
		bitLine : USINT;
		rValuesPerPosition : REAL;
		iFirstIndex : UINT;
		iLastIndex : UINT;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION LoadMediaFromFastDataBool : BOOL (*Loading Fast data in an array to an array of tracking data. Using BOOL array to load individual data*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		newValues : REFERENCE TO ARRAY[0..THICK_MAX_UPDATE_VALUES] OF BOOL; (*Array of the new Fast values*)
		fastValues : REAL; (*Total fast values loaded in the fast array*)
		positionsToRunArray : UINT; (*The positions to run the array. Corresponds the position to load data from fast in slow. Depending on the speed of the belt*)
		sensorPosition : UINT; (*Position of the sensor to insert the new data properly*)
		valuesTracking : REFERENCE TO ARRAY[0..iMAXTRACKINGARRAY] OF BOOL; (*values tracked. 1cm per position*)
	END_VAR
	VAR
		iIndexArray : UINT;
		iIndexNewMediaArray : UINT;
		rValuesPerPosition : REAL;
		iFirstIndex : UINT;
		iLastIndex : UINT;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION CheckFilteredMediaLine : BOOL (*Review if the values in a trackignArray is consistent. Using USINT array to load differente lines*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		valuesTracking : REFERENCE TO ARRAY[0..iMAXTRACKINGARRAY] OF USINT; (*values tracked. 1cm per position*)
		indexLine : USINT; (*Number of the bit where to store the data in the tracking array*)
		sensorPosition : UINT; (*Position of the sensor to insert the new data properly*)
		mediaFilter : UINT; (*Filter to consider data consistent*)
	END_VAR
	VAR
		iIndexArray : UINT;
		bitLine : USINT;
		xFilteredData : BOOL;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION CheckFilteredMediaBool : BOOL (*Review if the values in a trackignArray is consistent. Using BOOL array to load individual data*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		valuesTracking : REFERENCE TO ARRAY[0..iMAXTRACKINGARRAY] OF BOOL; (*values tracked. 1cm per position*)
		sensorPosition : UINT; (*Position of the sensor to insert the new data properly*)
		mediaFilter : UINT; (*Filter to consider data consistent*)
	END_VAR
	VAR
		iIndexArray : UINT;
		xFilteredData : BOOL;
	END_VAR
END_FUNCTION

FUNCTION ReviewMediaTrackingInPosition : BOOL (*Review if any element in the array is inside de window*)
	VAR_INPUT
		ArrayOfMedia : REFERENCE TO ARRAY[0..THICK_MEDIATRACKING_MAX_MEDIA] OF stThicknessCtrl_MediaPosStatus;
		TotalElementsInside : UINT; (*Total elements inside the array*)
		iStartWindow : UINT;
		iEndWindow : UINT;
		xIsWhite : BOOL;
	END_VAR
	VAR
		iIndexArray : UINT;
		xMediaInPosition : BOOL;
	END_VAR
END_FUNCTION

FUNCTION RevMediaTrackingEnergyInPos : BOOL (*Review if any element in the array is inside de window and calculate the Energy needed*)
	VAR_INPUT
		ArrayOfMedia : REFERENCE TO ARRAY[0..THICK_MEDIATRACKING_MAX_MEDIA] OF stThicknessCtrl_MediaPosStatus;
		TotalElementsInside : UINT; (*Total elements inside the array*)
		iStartWindow : INT; (*Distance in cm*)
		iEndWindow : INT; (*Distance in cm*)
		iTotalLamps : USINT;
		rLampWidth : REAL; (*Width of each lamp. Value in mm*)
		rLampOffset : REAL; (*Offset of the first lamp considering the center of the belt as 0. Positive to operator side. Value in mm*)
		rLampOverlap : REAL; (*Overlap to consider as extra width for each lamp. Value in mm*)
		iMinIntensity : INT; (*Minimum Intensity*)
	END_VAR
	VAR_IN_OUT
		iIntensity : ARRAY[0..THICKENERGY_MAX_LAMPS] OF INT; (*Data starting in index 1*)
	END_VAR
	VAR
		iIndexArray : UINT;
		Intensity : ARRAY[0..THICKENERGY_MAX_LAMPS] OF INT; (*Data starting in index 0*)
		diPosStartMedia : DINT;
		diPosEndMedia : DINT;
	END_VAR
END_FUNCTION

FUNCTION RevMediaTrackingEnergyInPosItem : BOOL (*Review if any element in the array is inside de window and calculate the Energy needed*)
	VAR_INPUT
		MediaData : REFERENCE TO stThicknessCtrl_MediaPosStatus;
		EnergyData : REFERENCE TO stThickCtrl_Energy;
		iStartWindow : INT; (*Distance in cm*)
		iEndWindow : INT; (*Distance in cm*)
		rLampWidth : REAL; (*Width of each lamp. Value in mm*)
		rLampOffset : REAL; (*Offset of the first lamp considering the center of the belt as 0. Positive to operator side. Value in mm*)
		rLampOverlap : REAL; (*Overlap to consider as extra width for each lamp. Value in mm*)
	END_VAR
	VAR_IN_OUT
		iIntensity : ARRAY[0..THICKENERGY_MAX_LAMPS] OF INT;
	END_VAR
	VAR
		iIndexCross : UINT;
		iIndexProcess : UINT;
		iIndexLamp : UINT;
		iFirstLamp : UINT; (*Starting with 0. The first lamp is index 0*)
		iLastLamp : UINT;
		rOffsetStartDocument : REAL; (*Position in mm to the center of the belt*)
		Intensity : ARRAY[0..THICKENERGY_MAX_LAMPS] OF INT;
		iLampIntensity : INT;
		iFirstCrossSection : INT;
		iLastCrossSection : INT;
		iFirstProcessSection : INT;
		iLastProcessSection : INT;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION AddMediaTrackingEvents : BOOL (*Loading Fast data in an array to an array of tracking data. Using USINT array to load differente lines*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		diBeltPosition : UDINT; (*Total Position of the belt when occurring the event*)
		EventType : stThickCtrl_TrackingEventType; (*Event Type*)
		pEventsTrackingArray : UDINT; (*Address of the array. Calling as ADR(myArray)*)
	END_VAR
	VAR
		iIndexArray : UINT;
		iIndexNewMediaArray : UINT;
		rValuesPerPosition : REAL;
		fakeElement : stThicknessCtrl_TrackingEvent;
		EventsArray : REFERENCE TO ARRAY[0..THICK_MAX_TRACKING_EVENTS] OF stThicknessCtrl_TrackingEvent;
	END_VAR
END_FUNCTION

FUNCTION CheckMediaToStack : UDINT (*Check if the Media sent to the stack is correct. If returning 0 everything is OK, if not returning the error code*)
	VAR_INPUT
		NewMedia : stThicknessCtrl_MediaConfig;
		xStackEnabled : BOOL;
		xDtpEnabled : BOOL;
		rMaxThickness : REAL;
		rMinWidth : REAL;
		rMaxWidth : REAL;
		rMinLength : REAL;
		rMaxLength : REAL;
		xStackLine1Full : BOOL;
		xStackLine2Full : BOOL;
	END_VAR
END_FUNCTION

FUNCTION CheckLineToStack : UDINT (*Check if the Line to stack is correct. If returning 0 everything is OK, if not returning the error code*)
	VAR_INPUT
		iLine : USINT;
		xStackEnabled : BOOL;
		xDtpEnabled : BOOL;
	END_VAR
END_FUNCTION

FUNCTION CheckEnabledStack : UDINT (*Check if the Line to stack is correct. If returning 0 everything is OK, if not returning the error code*)
	VAR_INPUT
		xStackEnabled : BOOL;
	END_VAR
END_FUNCTION

FUNCTION CheckItemInStack : UDINT (*INTERNAL. Check the item is in the Stack when is expected to be*)
	VAR_INPUT
		Id : DINT;
		StackArray : REFERENCE TO ARRAY[0..THICK_MEDIATRACKING_MAX_MEDIA] OF stThicknessCtrl_MediaPosStatus;
		TotalElements : UINT;
	END_VAR
	VAR_IN_OUT
		PositionFound : UINT;
	END_VAR
	VAR
		iIndex : UINT;
	END_VAR
END_FUNCTION

FUNCTION CheckNotItemInStack : UDINT (*INTERNAL. Check the item is NOT in the Stack when is expected NOT to be*)
	VAR_INPUT
		Id : DINT;
		StackArray : REFERENCE TO ARRAY[0..THICK_MEDIATRACKING_MAX_MEDIA] OF stThicknessCtrl_MediaPosStatus;
		TotalElements : UINT;
	END_VAR
	VAR_IN_OUT
		PositionFound : UINT;
	END_VAR
	VAR
		iIndex : UINT;
	END_VAR
END_FUNCTION

FUNCTION AssignItemInStack : UDINT (*INTERNAL. Assignation without any checking if the item is or is not in the array*)
	VAR_INPUT
		ItemMedia : REFERENCE TO stThicknessCtrl_MediaConfig;
		StackArray : REFERENCE TO ARRAY[0..THICK_MEDIATRACKING_MAX_MEDIA] OF stThicknessCtrl_MediaPosStatus;
		Position : UINT; (*The position to insert the element*)
		TotalElementsStack : UINT;
	END_VAR
	VAR
		ItemEnergyFake : stThickCtrl_Energy;
	END_VAR
END_FUNCTION

FUNCTION AssignItemEnergyInStack : UDINT (*INTERNAL. Assignation without any checking if the item is or is not in the array*)
	VAR_INPUT
		ItemMedia : REFERENCE TO stThicknessCtrl_MediaConfig;
		ItemEnergy : REFERENCE TO stThickCtrl_Energy;
		StackArray : REFERENCE TO ARRAY[0..THICK_MEDIATRACKING_MAX_MEDIA] OF stThicknessCtrl_MediaPosStatus;
		EnergyArray : REFERENCE TO ARRAY[0..THICK_MEDIATRACKING_MAX_MEDIA_x2] OF stThickCtrl_Energy;
		PositionStack : UINT; (*The position to insert the element*)
		PositionEnergy : USINT; (*The position to insert the element*)
	END_VAR
END_FUNCTION

FUNCTION AssignLastItemInStack : UDINT (*Check if the Line to stack is correct. If returning 0 everything is OK, if not returning the error code*)
	VAR_INPUT
		ItemMedia : REFERENCE TO stThicknessCtrl_MediaConfig;
		StackArray : REFERENCE TO ARRAY[0..THICK_MEDIATRACKING_MAX_MEDIA] OF stThicknessCtrl_MediaPosStatus;
	END_VAR
	VAR_IN_OUT
		TotalElementsStack : UINT;
	END_VAR
	VAR
		ItemEnergyFake : stThickCtrl_Energy;
		IndexEnergyFake : USINT;
	END_VAR
END_FUNCTION

FUNCTION AssignLastItemEnergyInStack : UDINT (*Check if the Line to stack is correct. If returning 0 everything is OK, if not returning the error code*)
	VAR_INPUT
		ItemMedia : REFERENCE TO stThicknessCtrl_MediaConfig;
		ItemEnergy : REFERENCE TO stThickCtrl_Energy;
		StackArray : REFERENCE TO ARRAY[0..THICK_MEDIATRACKING_MAX_MEDIA] OF stThicknessCtrl_MediaPosStatus;
		EnergyArray : REFERENCE TO ARRAY[0..THICK_MEDIATRACKING_MAX_MEDIA_x2] OF stThickCtrl_Energy;
	END_VAR
	VAR_IN_OUT
		TotalElementsStack : UINT;
		IndexEnergy : USINT;
	END_VAR
	VAR
		PositionFound : UINT;
	END_VAR
END_FUNCTION

FUNCTION InsertItemInStack : UDINT (*Check if the Line to stack is correct. If returning 0 everything is OK, if not returning the error code*)
	VAR_INPUT
		Id : DINT;
		ItemMedia : REFERENCE TO stThicknessCtrl_MediaConfig;
		StackArray : REFERENCE TO ARRAY[0..THICK_MEDIATRACKING_MAX_MEDIA] OF stThicknessCtrl_MediaPosStatus;
	END_VAR
	VAR_IN_OUT
		TotalElementsStack : UINT;
	END_VAR
	VAR
		ItemEnergyFake : stThickCtrl_Energy;
		IndexEnergyFake : USINT;
		PositionFound : UINT;
	END_VAR
END_FUNCTION

FUNCTION InsertItemEnergyInStack : UDINT (*Check if the Line to stack is correct. If returning 0 everything is OK, if not returning the error code*)
	VAR_INPUT
		Id : DINT;
		ItemMedia : REFERENCE TO stThicknessCtrl_MediaConfig;
		ItemEnergy : REFERENCE TO stThickCtrl_Energy;
		StackArray : REFERENCE TO ARRAY[0..THICK_MEDIATRACKING_MAX_MEDIA] OF stThicknessCtrl_MediaPosStatus;
		EnergyArray : REFERENCE TO ARRAY[0..THICK_MEDIATRACKING_MAX_MEDIA_x2] OF stThickCtrl_Energy;
	END_VAR
	VAR_IN_OUT
		TotalElementsStack : UINT;
		IndexEnergy : USINT;
	END_VAR
	VAR
		PositionFound : UINT;
		CheckResult : UDINT;
	END_VAR
END_FUNCTION

FUNCTION RemoveItemInStack : UDINT (*Check if the Line to stack is correct. If returning 0 everything is OK, if not returning the error code*)
	VAR_INPUT
		Id : DINT;
		StackArray : REFERENCE TO ARRAY[0..THICK_MEDIATRACKING_MAX_MEDIA] OF stThicknessCtrl_MediaPosStatus;
	END_VAR
	VAR_IN_OUT
		TotalElementsStack : UINT;
	END_VAR
	VAR
		CheckResult : UDINT;
		PositionFound : UINT;
	END_VAR
END_FUNCTION
