(********************************************************************
 * COPYRIGHT - B&R Spain
 ********************************************************************
 * Program: AxisCtrl
 * File: References.st
 * Author: B&R Spain
 * Created: September 19, 2013
 ********************************************************************
 * Implementation of program AxisCtrl
 ********************************************************************
 * Gets the references to the structures. EFI Implementation
 ********************************************************************) 

ACTION References:
	
	//Get the reference to the axisControlData object AxisCtrl_typ
	pAxisCtrl 		ACCESS ADR(gAxis[gIndexAxisCtrl]);
	isqRippleData	ACCESS ADR(gISQRippleData[gIndexAxisCtrl]);
	
	(* Gets the reference to the encoder data. If the HomeAbsEncoder is not needed, it can be commented out *)
	IF pAxisCtrl.Parameter.Init.xEnabledPermEncData THEN
		AdrEncoderData := ADR(gAxisPermanEncData[gIndexAxisCtrl]); (* The permanent variable must have MC_ENDLESS_POSITION type *)
	END_IF
	
END_ACTION
