ACTION EnableLamps:
	//Enabling lamps to be activated depending on media width, offset register and line mode (single or 2up)
	iLampPosition := 0;
	
		IF NOT dataLed.Parameters.xDoubleLine THEN
																			
			//							FEEDER/PRIMER						//
			//																//
			//////////////////////////////////////////////////////////////////
			//User side											//Back side //
			//					  											//
			//								"N" iLampPosition				//
			//----------------------------------------------->|				//
			//[[	1 	  ]][[	...	 ]][[	...	 ]][[	...	 ]][[	 N 	 ]]	//
			//			   ||		  ||	 0	  ||		  ||			//
			//					  			 |								//										
			//					  			 |								//
			//			OffsetL1(-)<---------|--------->(+)					//
			//			////////////////////////////////////////////		//			
			//			////////////////////////////////////////////		//	
			//			////////////////////////////////////////////		//
			//			////////////////////////////////////////////		//
			//			////////////////////////////////////////////		//
			//			////////////////////////////////////////////		//
			//			////////////////////////////////////////////		//
			//			////////////////////////////////////////////		//
			//			|<-------		MediaWidth			------>|		//
			//								 								//
			//iBoardInitPos													//
			//--------->|													//
			//									iBoardFinalPosition			//
			//---------------------------------------------------->|		//	
			//////////////////////////////////////////////////////////////////
			//																//
			//							DRYER/STACKER						//																
			
		
			iBoardInitPosition := MAX(0, iCenterPosition + dataLed.Status.iCuringAreaOffsetL1);
			iBoardFinalPosition := MIN(iTotalWidth, iBoardInitPosition + dataLed.Status.iCuringAreaWidth);
			FOR iIndexEnableLamps:=1 TO iLampsQuantity DO
				iLampPosition := iLampPosition + dataLed.Lamp[iIndexEnableLamps-1].Parameters.iCuringLength;
				dataLed.Lamp[iIndexEnableLamps].Parameters.EnabledByPosition := (iBoardInitPosition < (iLampPosition + dataLed.Lamp[iIndexEnableLamps].Parameters.iCuringLength)) AND
																				(iLampPosition < iBoardFinalPosition);
			END_FOR
			
		ELSE
			//							FEEDER/PRIMER						//
			//																//
			//////////////////////////////////////////////////////////////////
			//User side											//Back side //
			//					  											//
			//								"N" iLampPosition				//
			//----------------------------------------------->|				//
			//[[	1 	  ]][[	...	 ]][[	...	 ]][[	...	 ]][[	 N 	 ]]	//
			//			   ||		  ||	0	  ||		  ||			//
			//		/////////////////		|	/////////////////			//			
			//		/////////////////		|	/////////////////			//	
			//		/////////////////		|	/////////////////			//
			//		/////////////////		|	/////////////////			//
			//		/////////////////		|	/////////////////			//
			//		/////////////////		|	/////////////////			//
			//		/////////////////		|	/////////////////			//
			//		/////////////////		|	/////////////////			//
			//		|<- MediaWidth->|		|	|<- MediaWidth->|			//
			//								|								//
			//	iRegisterOffsetL1(-)|<------|-->|iRegisterOffsetL2(+)		//
			//								|								//
			//																//
			//iBoardInitPos													//
			//----->|														//
			//								iBoardFinalPosition				//
			//-------------------------------------------------->|			//
			//								 								//
			//////////////////////////////////////////////////////////////////
			//																//
			//							DRYER/STACKER						//
			
			iBoardInitPosition := MAX(0,iCenterPosition + dataLed.Status.iCuringAreaOffsetL1);
			iBoardFinalPosition := MIN(iTotalWidth, iCenterPosition + dataLed.Status.iCuringAreaOffsetL2 + dataLed.Status.iCuringAreaWidth);
			FOR iIndexEnableLamps:=1 TO iLampsQuantity DO
				iLampPosition := iLampPosition + dataLed.Lamp[iIndexEnableLamps-1].Parameters.iCuringLength;
				dataLed.Lamp[iIndexEnableLamps].Parameters.EnabledByPosition := (iBoardInitPosition < (iLampPosition + dataLed.Lamp[iIndexEnableLamps].Parameters.iCuringLength)) AND
																				(iLampPosition<iBoardFinalPosition);
			END_FOR
			
		END_IF
	
END_ACTION

ACTION MemoBoardParameters:
	iPreviousWidth := dataLed.Status.iCuringAreaWidth;
	iPreviousOffsetRegisterL1 := dataLed.Status.iCuringAreaOffsetL1;
	iPreviousOffsetRegisterL2 := dataLed.Status.iCuringAreaOffsetL2;
END_ACTION