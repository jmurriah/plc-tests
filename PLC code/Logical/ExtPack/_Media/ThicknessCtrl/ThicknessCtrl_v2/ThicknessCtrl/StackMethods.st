
ACTION StackMethods:

	IF NOT dataHeigh.status.xNewMediaStackEnabled THEN
		EnteringMediaContinuous.Media := dataHeigh.parameters.ContinuousMedia.MediaData;
	END_IF
	
	ReviewLoadNewMediaMethod;
	ReviewInsertNewMedia;
	ReviewRemoveNewMedia;
	
	ReviewLoadNewMediaEnergyMethod;
	ReviewInsertNewMediaEnMethod;
	
	ReviewLoadNewMediaEnergyContMethod;
	
	dataHeigh.status.Stack.iNewMediaLoadedL1 := Stack_iTotalNewMediaL1;
	dataHeigh.status.Stack.iNewMediaLoadedL2 := Stack_iTotalNewMediaL2;

END_ACTION


ACTION ReviewLoadNewMediaMethod:

	CASE LoadNewMedia_Step OF
		0: // Manage errors and init
			LoadNewMedia_Step := 1;
			
		1: // start operate
			LoadNewMedia_MethodOperate.Action  := UaMoa_CheckIsCalled; 
			LoadNewMedia_MethodOperate.MethodName := 'LoadNewMedia';
			LoadNewMedia_MethodOperate.Execute := TRUE;
			LoadNewMedia_Step := 2;
		2: // check if method called
			LoadNewMedia_MethodOperate();
			IF LoadNewMedia_MethodOperate.Busy THEN
				LoadNewMedia_MethodOperate.Execute := FALSE;
			ELSE
				IF LoadNewMedia_MethodOperate.Done THEN
					LoadNewMedia_ErrorID:= 0;
					IF LoadNewMedia_MethodOperate.IsCalled THEN
						LoadNewMedia_Step := 3; // method is called
					END_IF
					LoadNewMedia_MethodOperate.Execute := TRUE;
				END_IF
				IF LoadNewMedia_MethodOperate.Error THEN
					LoadNewMedia_ErrorID:= DWORD_TO_UDINT(LoadNewMedia_MethodOperate.ErrorID);
					LoadNewMedia_Step := 0;
				END_IF
			END_IF
		3: // execute method code and return value
			ExecuteLoadingNewMedia;
			LoadNewMedia_Result := LoadNewMedia_ReviewResult;
			LoadNewMedia_Step := 4;
		4: // finish operate 

			LoadNewMedia_MethodOperate.Action  := UaMoa_Finished;
			LoadNewMedia_MethodOperate.MethodName := 'LoadNewMedia';
			LoadNewMedia_MethodOperate.Execute := TRUE;
			LoadNewMedia_Step := 5;
		5: // finish method 
			LoadNewMedia_MethodOperate();
			IF LoadNewMedia_MethodOperate.Busy THEN
				LoadNewMedia_MethodOperate.Execute := FALSE;
			ELSE
				IF LoadNewMedia_MethodOperate.Done THEN
					LoadNewMedia_ErrorID:= 0;
					LoadNewMedia_Step := 1; // method is finished, wait again for call
				END_IF
				IF LoadNewMedia_MethodOperate.Error THEN
					LoadNewMedia_ErrorID:= DWORD_TO_UDINT(LoadNewMedia_MethodOperate.ErrorID);
					LoadNewMedia_Step := 0;
				END_IF
			END_IF
	END_CASE
	
END_ACTION

ACTION ExecuteLoadingNewMedia:
	
	LoadNewMedia_ReviewResult := CheckMediaToStack(LoadNewMedia_Media, 
												dataHeigh.status.xNewMediaStackEnabled, 
												dataHeigh.parameters.xDoubleLine, 
												25, 
												200, 1400, 
												200, 3000, 
												Stack_iTotalNewMediaL1 >= THICK_MEDIATRACKING_MAX_MEDIA,
												Stack_iTotalNewMediaL2 >= THICK_MEDIATRACKING_MAX_MEDIA);
	
	IF LoadNewMedia_ReviewResult <> 0 THEN
		RETURN;
	END_IF
	
	// TODO: Load the media in the FIFO to manage it
	IF LoadNewMedia_Media.iLine = 1 THEN	
		LoadNewMedia_ReviewResult := AssignLastItemInStack(
			ADR(LoadNewMedia_Media),
			ADR(NewMediaStackL1),
			Stack_iTotalNewMediaL1);
		
	ELSIF LoadNewMedia_Media.iLine = 2 THEN	
		LoadNewMedia_ReviewResult := AssignLastItemInStack(
			ADR(LoadNewMedia_Media),
			ADR(NewMediaStackL2),
			Stack_iTotalNewMediaL2);
	
	END_IF

END_ACTION


ACTION ReviewInsertNewMedia:

	CASE InsertNewMedia_Step OF
		0: // Manage errors and init
			InsertNewMedia_Step := 1;
			
		1: // start operate
			InsertNewMedia_MethodOperate.Action  := UaMoa_CheckIsCalled; 
			InsertNewMedia_MethodOperate.MethodName := 'InsertNewMedia';
			InsertNewMedia_MethodOperate.Execute := TRUE;
			InsertNewMedia_Step := 2;
		2: // check if method called
			InsertNewMedia_MethodOperate();
			IF InsertNewMedia_MethodOperate.Busy THEN
				InsertNewMedia_MethodOperate.Execute := FALSE;
			ELSE
				IF InsertNewMedia_MethodOperate.Done THEN
					InsertNewMedia_ErrorID:= 0;
					IF InsertNewMedia_MethodOperate.IsCalled THEN
						InsertNewMedia_Step := 3; // method is called
					END_IF
					InsertNewMedia_MethodOperate.Execute := TRUE;
				END_IF
				IF InsertNewMedia_MethodOperate.Error THEN
					InsertNewMedia_ErrorID:= DWORD_TO_UDINT(InsertNewMedia_MethodOperate.ErrorID);
					InsertNewMedia_Step := 0;
				END_IF
			END_IF
		3: // execute method code and return value
			ExecuteInsertNewMedia;
			InsertNewMedia_Result := InsertNewMedia_ReviewResult;
			InsertNewMedia_Step := 4;
		4: // finish operate 

			InsertNewMedia_MethodOperate.Action  := UaMoa_Finished;
			InsertNewMedia_MethodOperate.MethodName := 'InsertNewMedia';
			InsertNewMedia_MethodOperate.Execute := TRUE;
			InsertNewMedia_Step := 5;
		5: // finish method 
			InsertNewMedia_MethodOperate();
			IF InsertNewMedia_MethodOperate.Busy THEN
				InsertNewMedia_MethodOperate.Execute := FALSE;
			ELSE
				IF InsertNewMedia_MethodOperate.Done THEN
					InsertNewMedia_ErrorID:= 0;
					InsertNewMedia_Step := 1; // method is finished, wait again for call
				END_IF
				IF InsertNewMedia_MethodOperate.Error THEN
					InsertNewMedia_ErrorID:= DWORD_TO_UDINT(InsertNewMedia_MethodOperate.ErrorID);
					InsertNewMedia_Step := 0;
				END_IF
			END_IF
	END_CASE
	
END_ACTION

ACTION ExecuteInsertNewMedia:
	
	InsertNewMedia_ReviewResult := CheckMediaToStack(InsertNewMedia_Media, 
												dataHeigh.status.xNewMediaStackEnabled, 
												dataHeigh.parameters.xDoubleLine, 
												25, 
												200, 1400, 
												200, 3000, 
												Stack_iTotalNewMediaL1 >= THICK_MEDIATRACKING_MAX_MEDIA,
												Stack_iTotalNewMediaL2 >= THICK_MEDIATRACKING_MAX_MEDIA);
	
	IF InsertNewMedia_ReviewResult <> 0 THEN
		RETURN;
	END_IF
	
	// Load the media in the FIFO to manage it.
	// If an error occurs, the error is stored to return it in the method
	IF InsertNewMedia_Media.iLine = 1 THEN	
		InsertNewMedia_ReviewResult := InsertItemInStack(
			InsertNewMedia_Id,
			ADR(InsertNewMedia_Media),
			ADR(NewMediaStackL1),
			//InsertNewMedia_Position,
			Stack_iTotalNewMediaL1
		);
	ELSIF InsertNewMedia_Media.iLine = 2 THEN	
		InsertNewMedia_ReviewResult := InsertItemInStack(
			InsertNewMedia_Id,
			ADR(InsertNewMedia_Media),
			ADR(NewMediaStackL2),
			//InsertNewMedia_Position,
			Stack_iTotalNewMediaL2
		);
	END_IF

END_ACTION


ACTION ReviewRemoveNewMedia:

	CASE RemoveNewMedia_Step OF
		0: // Manage errors and init
			RemoveNewMedia_Step := 1;
			
		1: // start operate
			RemoveNewMedia_MethodOperate.Action  := UaMoa_CheckIsCalled; 
			RemoveNewMedia_MethodOperate.MethodName := 'RemoveNewMedia';
			RemoveNewMedia_MethodOperate.Execute := TRUE;
			RemoveNewMedia_Step := 2;
		2: // check if method called
			RemoveNewMedia_MethodOperate();
			IF RemoveNewMedia_MethodOperate.Busy THEN
				RemoveNewMedia_MethodOperate.Execute := FALSE;
			ELSE
				IF RemoveNewMedia_MethodOperate.Done THEN
					RemoveNewMedia_ErrorID:= 0;
					IF RemoveNewMedia_MethodOperate.IsCalled THEN
						RemoveNewMedia_Step := 3; // method is called
					END_IF
					RemoveNewMedia_MethodOperate.Execute := TRUE;
				END_IF
				IF RemoveNewMedia_MethodOperate.Error THEN
					RemoveNewMedia_ErrorID:= DWORD_TO_UDINT(RemoveNewMedia_MethodOperate.ErrorID);
					RemoveNewMedia_Step := 0;
				END_IF
			END_IF
		3: // execute method code and return value
			ExecuteRemoveNewMedia;
			RemoveNewMedia_Result := RemoveNewMedia_ReviewResult;
			RemoveNewMedia_Step := 4;
		4: // finish operate 

			RemoveNewMedia_MethodOperate.Action  := UaMoa_Finished;
			RemoveNewMedia_MethodOperate.MethodName := 'RemoveNewMedia';
			RemoveNewMedia_MethodOperate.Execute := TRUE;
			RemoveNewMedia_Step := 5;
		5: // finish method 
			RemoveNewMedia_MethodOperate();
			IF RemoveNewMedia_MethodOperate.Busy THEN
				RemoveNewMedia_MethodOperate.Execute := FALSE;
			ELSE
				IF RemoveNewMedia_MethodOperate.Done THEN
					RemoveNewMedia_ErrorID:= 0;
					RemoveNewMedia_Step := 1; // method is finished, wait again for call
				END_IF
				IF RemoveNewMedia_MethodOperate.Error THEN
					RemoveNewMedia_ErrorID:= DWORD_TO_UDINT(RemoveNewMedia_MethodOperate.ErrorID);
					RemoveNewMedia_Step := 0;
				END_IF
			END_IF
	END_CASE
	
END_ACTION

ACTION ExecuteRemoveNewMedia:
	
	RemoveNewMedia_ReviewResult := CheckLineToStack(RemoveNewMedia_Line, 
												dataHeigh.status.xNewMediaStackEnabled, 
												dataHeigh.parameters.xDoubleLine);
	
	IF RemoveNewMedia_ReviewResult <> 0 THEN
		RETURN;
	END_IF
	
	// TODO: Load the media in the FIFO to manage it
	IF RemoveNewMedia_Line = 1 THEN
		RemoveNewMedia_ReviewResult := RemoveItemInStack(RemoveNewMedia_Id, ADR(NewMediaStackL1), Stack_iTotalNewMediaL1);
	ELSIF RemoveNewMedia_Line = 2 THEN
		RemoveNewMedia_ReviewResult := RemoveItemInStack(RemoveNewMedia_Id, ADR(NewMediaStackL2), Stack_iTotalNewMediaL2);
	END_IF

END_ACTION


ACTION ReviewLoadNewMediaEnergyMethod:

	CASE LoadNewMediaEnergy_Step OF
		0: // Manage errors and init
			LoadNewMediaEnergy_Step := 1;
			
		1: // start operate
			LoadNewMediaEnergy_MethodOperate.Action  := UaMoa_CheckIsCalled; 
			LoadNewMediaEnergy_MethodOperate.MethodName := 'LoadNewMediaEnergy';
			LoadNewMediaEnergy_MethodOperate.Execute := TRUE;
			LoadNewMediaEnergy_Step := 2;
		2: // check if method called
			LoadNewMediaEnergy_MethodOperate();
			IF LoadNewMediaEnergy_MethodOperate.Busy THEN
				LoadNewMediaEnergy_MethodOperate.Execute := FALSE;
			ELSE
				IF LoadNewMediaEnergy_MethodOperate.Done THEN
					LoadNewMediaEnergy_ErrorID:= 0;
					IF LoadNewMediaEnergy_MethodOperate.IsCalled THEN
						LoadNewMediaEnergy_Step := 3; // method is called
					END_IF
					LoadNewMediaEnergy_MethodOperate.Execute := TRUE;
				END_IF
				IF LoadNewMediaEnergy_MethodOperate.Error THEN
					LoadNewMediaEnergy_ErrorID:= DWORD_TO_UDINT(LoadNewMediaEnergy_MethodOperate.ErrorID);
					LoadNewMediaEnergy_Step := 0;
				END_IF
			END_IF
		3: // execute method code and return value
			ExecuteLoadingNewMediaEnergy;
			LoadNewMediaEnergy_Result := LoadNewMediaEnergy_ReviewResult;
			LoadNewMediaEnergy_Step := 4;
		4: // finish operate 

			LoadNewMediaEnergy_MethodOperate.Action  := UaMoa_Finished;
			LoadNewMediaEnergy_MethodOperate.MethodName := 'LoadNewMediaEnergy';
			LoadNewMediaEnergy_MethodOperate.Execute := TRUE;
			LoadNewMediaEnergy_Step := 5;
		5: // finish method 
			LoadNewMediaEnergy_MethodOperate();
			IF LoadNewMediaEnergy_MethodOperate.Busy THEN
				LoadNewMediaEnergy_MethodOperate.Execute := FALSE;
			ELSE
				IF LoadNewMediaEnergy_MethodOperate.Done THEN
					LoadNewMediaEnergy_ErrorID:= 0;
					LoadNewMediaEnergy_Step := 1; // method is finished, wait again for call
				END_IF
				IF LoadNewMediaEnergy_MethodOperate.Error THEN
					LoadNewMediaEnergy_ErrorID:= DWORD_TO_UDINT(LoadNewMediaEnergy_MethodOperate.ErrorID);
					LoadNewMediaEnergy_Step := 0;
				END_IF
			END_IF
	END_CASE
	
END_ACTION

ACTION ExecuteLoadingNewMediaEnergy:
	
	LoadNewMediaEnergy_ReviewResult := CheckMediaToStack(LoadNewMediaEnergy_Media.MediaData, 
												dataHeigh.parameters.Dry.xDryStack, 
												dataHeigh.parameters.xDoubleLine, 
												25, 
												200, 1400, 
												200, 3000, 
												Stack_iTotalNewMediaL1 >= THICK_MEDIATRACKING_MAX_MEDIA,
												Stack_iTotalNewMediaL2 >= THICK_MEDIATRACKING_MAX_MEDIA);
	
	IF LoadNewMediaEnergy_ReviewResult <> 0 THEN
		RETURN;
	END_IF
	
	// TODO: Check the final dimensions of the media
	
	// Load the media in the FIFO to manage it
	IF LoadNewMediaEnergy_Media.MediaData.iLine = 1 THEN	
		LoadNewMediaEnergy_ReviewResult := AssignLastItemEnergyInStack(
			ADR(LoadNewMediaEnergy_Media.MediaData),
			ADR(LoadNewMediaEnergy_Media.Energy),
			ADR(NewMediaStackL1),
			ADR(MediaEnergyRackL1),
			Stack_iTotalNewMediaL1,
			EnergyRack_iIndexL1);
		
	ELSIF LoadNewMediaEnergy_Media.MediaData.iLine = 2 THEN	
		LoadNewMediaEnergy_ReviewResult := AssignLastItemEnergyInStack(
			ADR(LoadNewMediaEnergy_Media.MediaData),
			ADR(LoadNewMediaEnergy_Media.Energy),
			ADR(NewMediaStackL2),
			ADR(MediaEnergyRackL2),
			Stack_iTotalNewMediaL2,
			EnergyRack_iIndexL2);
	
	END_IF
	
END_ACTION


ACTION ReviewInsertNewMediaEnMethod:

	CASE InsertNewMediaEn_Step OF
		0: // Manage errors and init
			InsertNewMediaEn_Step := 1;
			
		1: // start operate
			InsertNewMediaEn_MethodOperate.Action  := UaMoa_CheckIsCalled; 
			InsertNewMediaEn_MethodOperate.MethodName := 'InsertNewMediaEnergy';
			InsertNewMediaEn_MethodOperate.Execute := TRUE;
			InsertNewMediaEn_Step := 2;
		2: // check if method called
			InsertNewMediaEn_MethodOperate();
			IF InsertNewMediaEn_MethodOperate.Busy THEN
				InsertNewMediaEn_MethodOperate.Execute := FALSE;
			ELSE
				IF InsertNewMediaEn_MethodOperate.Done THEN
					InsertNewMediaEn_ErrorID:= 0;
					IF InsertNewMediaEn_MethodOperate.IsCalled THEN
						InsertNewMediaEn_Step := 3; // method is called
					END_IF
					InsertNewMediaEn_MethodOperate.Execute := TRUE;
				END_IF
				IF InsertNewMediaEn_MethodOperate.Error THEN
					InsertNewMediaEn_ErrorID:= DWORD_TO_UDINT(InsertNewMediaEn_MethodOperate.ErrorID);
					InsertNewMediaEn_Step := 0;
				END_IF
			END_IF
		3: // execute method code and return value
			ExecuteInsertNewMediaEn;
			InsertNewMediaEn_Result := InsertNewMediaEn_ReviewResult;
			InsertNewMediaEn_Step := 4;
		4: // finish operate 

			InsertNewMediaEn_MethodOperate.Action  := UaMoa_Finished;
			InsertNewMediaEn_MethodOperate.MethodName := 'InsertNewMediaEnergy';
			InsertNewMediaEn_MethodOperate.Execute := TRUE;
			InsertNewMediaEn_Step := 5;
		5: // finish method 
			InsertNewMediaEn_MethodOperate();
			IF InsertNewMediaEn_MethodOperate.Busy THEN
				InsertNewMediaEn_MethodOperate.Execute := FALSE;
			ELSE
				IF InsertNewMediaEn_MethodOperate.Done THEN
					InsertNewMediaEn_ErrorID:= 0;
					InsertNewMediaEn_Step := 1; // method is finished, wait again for call
				END_IF
				IF InsertNewMediaEn_MethodOperate.Error THEN
					InsertNewMediaEn_ErrorID:= DWORD_TO_UDINT(InsertNewMediaEn_MethodOperate.ErrorID);
					InsertNewMediaEn_Step := 0;
				END_IF
			END_IF
	END_CASE
	
END_ACTION

ACTION ExecuteInsertNewMediaEn:
	
	InsertNewMediaEn_ReviewResult := CheckMediaToStack(InsertNewMediaEn_Media.MediaData, 
													dataHeigh.parameters.Dry.xDryStack, 
													dataHeigh.parameters.xDoubleLine, 
													25, 
													200, 1400, 
													200, 3000, 
													Stack_iTotalNewMediaL1 >= THICK_MEDIATRACKING_MAX_MEDIA,
													Stack_iTotalNewMediaL2 >= THICK_MEDIATRACKING_MAX_MEDIA);
	
	IF InsertNewMediaEn_ReviewResult <> 0 THEN
		RETURN;
	END_IF

	// TODO: Load the media in the FIFO to manage it
	IF InsertNewMediaEn_Media.MediaData.iLine = 1 THEN
		// Addign new media to after a defined position
		InsertNewMediaEn_ReviewResult := InsertItemEnergyInStack(
			InsertNewMediaEn_Id,
			ADR(InsertNewMediaEn_Media.MediaData),
			ADR(InsertNewMediaEn_Media.Energy),
			ADR(NewMediaStackL1),
			ADR(MediaEnergyRackL1),
			Stack_iTotalNewMediaL1,
			EnergyRack_iIndexL1);
		
	ELSIF InsertNewMediaEn_Media.MediaData.iLine = 2 THEN
		// Addign new media to after a defined position
		InsertNewMediaEn_ReviewResult := InsertItemEnergyInStack(
			InsertNewMediaEn_Id,
			ADR(InsertNewMediaEn_Media.MediaData),
			ADR(InsertNewMediaEn_Media.Energy),
			ADR(NewMediaStackL2),
			ADR(MediaEnergyRackL2),
			Stack_iTotalNewMediaL2,
			EnergyRack_iIndexL2);

	END_IF
	
END_ACTION


ACTION ReviewLoadNewMediaEnergyContMethod:

	CASE LoadNewMediaEnergyCont_Step OF
		0: // Manage errors and init
			LoadNewMediaEnergyCont_Step := 1;
			
		1: // start operate
			LoadNewMediaEnergyCont_MethodOp.Action  := UaMoa_CheckIsCalled; 
			LoadNewMediaEnergyCont_MethodOp.MethodName := 'LoadNewMediaEnergyCont';
			LoadNewMediaEnergyCont_MethodOp.Execute := TRUE;
			LoadNewMediaEnergyCont_Step := 2;
		2: // check if method called
			LoadNewMediaEnergyCont_MethodOp();
			IF LoadNewMediaEnergyCont_MethodOp.Busy THEN
				LoadNewMediaEnergyCont_MethodOp.Execute := FALSE;
			ELSE
				IF LoadNewMediaEnergyCont_MethodOp.Done THEN
					LoadNewMediaEnergyCont_ErrorID:= 0;
					IF LoadNewMediaEnergyCont_MethodOp.IsCalled THEN
						LoadNewMediaEnergyCont_Step := 3; // method is called
					END_IF
					LoadNewMediaEnergyCont_MethodOp.Execute := TRUE;
				END_IF
				IF LoadNewMediaEnergyCont_MethodOp.Error THEN
					LoadNewMediaEnergyCont_ErrorID:= DWORD_TO_UDINT(LoadNewMediaEnergyCont_MethodOp.ErrorID);
					LoadNewMediaEnergyCont_Step := 0;
				END_IF
			END_IF
		3: // execute method code and return value
			ExecuteLoadingNewMediaEnergyCont;
			LoadNewMediaEnergyCont_Result := LoadNewMediaEnergyCont_ReviewRes;
			LoadNewMediaEnergyCont_Step := 4;
		4: // finish operate 

			LoadNewMediaEnergyCont_MethodOp.Action  := UaMoa_Finished;
			LoadNewMediaEnergyCont_MethodOp.MethodName := 'LoadNewMediaEnergyCont';
			LoadNewMediaEnergyCont_MethodOp.Execute := TRUE;
			LoadNewMediaEnergyCont_Step := 5;
		5: // finish method 
			LoadNewMediaEnergyCont_MethodOp();
			IF LoadNewMediaEnergyCont_MethodOp.Busy THEN
				LoadNewMediaEnergyCont_MethodOp.Execute := FALSE;
			ELSE
				IF LoadNewMediaEnergyCont_MethodOp.Done THEN
					LoadNewMediaEnergyCont_ErrorID:= 0;
					LoadNewMediaEnergyCont_Step := 1; // method is finished, wait again for call
				END_IF
				IF LoadNewMediaEnergyCont_MethodOp.Error THEN
					LoadNewMediaEnergyCont_ErrorID:= DWORD_TO_UDINT(LoadNewMediaEnergyCont_MethodOp.ErrorID);
					LoadNewMediaEnergyCont_Step := 0;
				END_IF
			END_IF
	END_CASE
	
END_ACTION

ACTION ExecuteLoadingNewMediaEnergyCont:
	
	LoadNewMediaEnergyCont_ReviewRes := CheckMediaToStack(LoadNewMediaEnergyCont_Media.MediaData, 
													TRUE, 
													dataHeigh.parameters.xDoubleLine, 
													25, 
													200, 1400, 
													200, 3000, 
													Stack_iTotalNewMediaL1 >= THICK_MEDIATRACKING_MAX_MEDIA,
													Stack_iTotalNewMediaL2 >= THICK_MEDIATRACKING_MAX_MEDIA);
	
	IF LoadNewMediaEnergyCont_ReviewRes <> 0 THEN
		RETURN;
	END_IF
	
	// TODO: Check the final dimensions of the media
	dataHeigh.parameters.ContinuousMedia := LoadNewMediaEnergyCont_Media;
	IF dataHeigh.parameters.pExtContMedia > 0 THEN
		ExternalMediaConfig ACCESS dataHeigh.parameters.pExtContMedia;
		ExternalMediaConfig := dataHeigh.parameters.ContinuousMedia.MediaData;
	END_IF
	
END_ACTION



