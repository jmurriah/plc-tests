
FUNCTION AssignItemInStack
	
	AssignItemInStack := AssignItemEnergyInStack(ADR(ItemMedia), ADR(ItemEnergyFake), ADR(StackArray), 0, Position, 0);
	
END_FUNCTION


FUNCTION AssignItemEnergyInStack
	
	// Manage Energy information
	IF ADR(EnergyArray) > 0 THEN
		EnergyArray[PositionEnergy] := ItemEnergy;
		StackArray[PositionStack].iIndexMediaEnergy := PositionEnergy;
		StackArray[PositionStack].pMediaEnery := ADR(EnergyArray[PositionEnergy]);
	ELSE
		StackArray[PositionStack].iIndexMediaEnergy := 0;
		StackArray[PositionStack].pMediaEnery := 0;
	END_IF

	// Manage Media information
	StackArray[PositionStack].Media := ItemMedia;

	AssignItemEnergyInStack := 0;

END_FUNCTION


FUNCTION AssignLastItemInStack
	
	AssignLastItemInStack := AssignLastItemEnergyInStack(ADR(ItemMedia), ADR(ItemEnergyFake), ADR(StackArray), 0, TotalElementsStack, IndexEnergyFake);	

END_FUNCTION


FUNCTION AssignLastItemEnergyInStack

	// Check if the item NOT inside the array
	AssignLastItemEnergyInStack := CheckNotItemInStack(ItemMedia.id, ADR(StackArray), TotalElementsStack, PositionFound);
	IF AssignLastItemEnergyInStack <> 0 THEN
		RETURN;
	END_IF
	
	AssignLastItemEnergyInStack := AssignItemEnergyInStack(ADR(ItemMedia), ADR(ItemEnergy), ADR(StackArray), ADR(EnergyArray), TotalElementsStack, IndexEnergy);
	
	// Manage Energy index
	IF ADR(EnergyArray) > 0 THEN
		IndexEnergy := IndexEnergy + 1;
		IF IndexEnergy > THICK_MEDIATRACKING_MAX_MEDIA_x2 THEN
			IndexEnergy := 0;
		END_IF
	END_IF

	// Manage Stack index
	TotalElementsStack := TotalElementsStack + 1;
	
END_FUNCTION


FUNCTION InsertItemInStack
	
	InsertItemInStack := InsertItemEnergyInStack(Id, ADR(ItemMedia), ADR(ItemEnergyFake), ADR(StackArray), 0, TotalElementsStack, IndexEnergyFake);

END_FUNCTION


FUNCTION InsertItemEnergyInStack
	
	// Check if the item inside the array
	CheckResult := CheckItemInStack(Id, ADR(StackArray), TotalElementsStack, PositionFound);
	IF CheckResult <> 0 THEN
		InsertItemEnergyInStack := CheckResult;
		RETURN;
	END_IF
	
	// Check if the item NOT inside the array
	CheckResult := CheckNotItemInStack(ItemMedia.id, ADR(StackArray), TotalElementsStack, PositionFound);
	IF CheckResult <> 0 THEN
		InsertItemEnergyInStack := CheckResult;
		RETURN;
	END_IF
		
	
	//Make space in Stack
	ShiftArrayOffset(ADR(StackArray), SIZEOF(StackArray), SIZEOF(StackArray[0]), PositionFound+1, PositionFound+2, TotalElementsStack - PositionFound -1);
	
	//Assing information
	AssignItemEnergyInStack(ADR(ItemMedia), ADR(ItemEnergy), ADR(StackArray), ADR(EnergyArray), PositionFound+1, IndexEnergy);
	
	// Manage Energy index
	IF ADR(EnergyArray) > 0 THEN
		IndexEnergy := IndexEnergy + 1;
		IF IndexEnergy > THICK_MEDIATRACKING_MAX_MEDIA_x2 THEN
			IndexEnergy := 0;
		END_IF
	END_IF

	// Manage Stack index
	TotalElementsStack := TotalElementsStack + 1;

	InsertItemEnergyInStack := 0;

END_FUNCTION


FUNCTION RemoveItemInStack
	
	// Directly remove everything if asked
	IF Id = -1 THEN
		// Clean all the array
		brsmemset(ADR(StackArray), 0, SIZEOF(StackArray));
		TotalElementsStack := 0;
		RemoveItemInStack := 0;
		RETURN;
	END_IF
		
	// Check if the item inside the array
	CheckResult := CheckItemInStack(Id, ADR(StackArray), TotalElementsStack, PositionFound);
	IF CheckResult <> 0 THEN
		RemoveItemInStack := CheckResult;
		RETURN;
	END_IF
	
	//Make space in Stack
	ShiftArrayOffset(ADR(StackArray), SIZEOF(StackArray), SIZEOF(StackArray[0]), PositionFound+1, PositionFound, TotalElementsStack - PositionFound -1);
	
	// Manage Stack index
	TotalElementsStack := TotalElementsStack - 1;

	// Clean values from end
	RemoveItemInStack := CleanEndArray(ADR(StackArray), SIZEOF(StackArray), SIZEOF(StackArray[0]), TotalElementsStack);
	IF RemoveItemInStack <> 0 THEN
		RETURN;
	END_IF

	RemoveItemInStack := 0;

END_FUNCTION