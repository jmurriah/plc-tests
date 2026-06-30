
(* Shift the values of the array some positions forward. Protected to not go beyond the array. UINT *)
FUNCTION ShiftArrayForward
	
	ShiftArrayForward := ShiftArrayOffset(pArray, ArraySize, ElementSize, 0, DestinationPosition, ElementsToMove);
      
END_FUNCTION

(* Shift the values of the array some positions forward. Protected to not go beyond the array. UINT *)
FUNCTION ShiftArrayBackward
	
(* ------ List of possible status ---------------------
	0:		Shift OK
	1:		Shift Done but limited
	50000:	Zero elements to move selected
	50001:	Source position outside array bounds
	50002:	Array pointer not assigned
-------------------------------------------------------*)
      
    //Check if an element has to be moved - If not status 50000 is reported
	IF ElementsToMove = 0 THEN
		ShiftArrayBackward := 50000;
		RETURN;
	END_IF
	
	//Check if the source position is in the array boundaries - If not status 50001 is reported
	ElementsInArray := ArraySize / ElementSize;
	IF SourcePosition >= ElementsInArray THEN
		ShiftArrayBackward := 50001;
		RETURN;
	END_IF

	// Check if pointer of array is assigned
	IF pArray = 0 THEN
		ShiftArrayBackward := 50002;
		RETURN;
	END_IF

	//Check if the movement goes outside the array and limit it to the maximum size of the array - Status 0 is reported
	
	IF ElementsInArray - SourcePosition < ElementsToMove THEN
		brsmemmove(pArray, pArray+ElementSize*SourcePosition, (ElementsInArray-SourcePosition)*ElementSize);
		ShiftArrayBackward := 1;
	ELSE
		brsmemmove(pArray, pArray+ElementSize*SourcePosition, ElementsToMove*ElementSize);
		ShiftArrayBackward := 0;
	END_IF
      
END_FUNCTION

(* Shift the values of the array some positions forward. Protected to not go beyond the array. UINT *)
FUNCTION ShiftArrayOffset
	
(* ------ List of possible status ---------------------
	0:		Shift OK
	1:		Shift Done but limited
	50000:	Zero elements to move selected
	50001:	Destination position outside array bounds
	50002:	Array pointer not assigned
	50003:	Source and destination are the same
-------------------------------------------------------*)
      
    //Check if an element has to be moved - If not status 50000 is reported
	IF ElementsToMove = 0 THEN
		ShiftArrayOffset := 50000;
		RETURN;
	END_IF
	
	//Check if the destination position is in the array boundaries - If not status 50001 is reported
	ElementsInArray := ArraySize / ElementSize;
	IF DestinationPosition >= ElementsInArray THEN
		ShiftArrayOffset := 50001;
		RETURN;
	END_IF

	// Check if pointer of array is assigned
	IF pArray = 0 THEN
		ShiftArrayOffset := 50002;
		RETURN;
	END_IF
	
	// Check if source and Destination position
	IF SourcePosition = DestinationPosition THEN
		ShiftArrayOffset := 50003;
		RETURN;
	END_IF	

	//Check if the movement goes outside the array and limit it to the maximum size of the array - Status 0 is reported
	IF ElementsInArray - DestinationPosition < ElementsToMove THEN
		brsmemmove(pArray+ElementSize*DestinationPosition, pArray+ElementSize*SourcePosition, (ElementsInArray-DestinationPosition)*ElementSize);
		ShiftArrayOffset := 1;
	ELSE
		brsmemmove(pArray+ElementSize*DestinationPosition, pArray+ElementSize*SourcePosition, ElementsToMove*ElementSize);
		ShiftArrayOffset := 0;
	END_IF
      
END_FUNCTION


(* Shift the values of the array some positions forward. Protected to not go beyond the array. UINT *)
FUNCTION CleanEndArray
	
(* ------ List of possible status ---------------------
	0:		Clean OK
	1:		Shift Done but limited
	//50000:	Zero elements to move selected
	50001:	Total elements greater than the maximum allowed
	50002:	Array pointer not assigned
	50003:	No space at the end of the array
-------------------------------------------------------*)
     
	// Check if pointer of array is assigned
	IF pArray = 0 THEN
		CleanEndArray := 50002;
		RETURN;
	END_IF
	
	// If no elements, clean all the array
	IF TotalElements = 0 THEN
		brsmemset(pArray, 0, ArraySize);
		CleanEndArray := 0;
		RETURN;
	END_IF
	
	//Check if the destination position is in the array boundaries - If not status 50001 is reported
	MaxElementsInArray := ArraySize / ElementSize;
	IF TotalElements > MaxElementsInArray THEN
		CleanEndArray := 50001;
		RETURN;
	END_IF

	ElementsToClean := MaxElementsInArray - TotalElements;

	// If the elements is the same as the maximum, no space to clean
	IF ElementsToClean = 0 THEN
		CleanEndArray := 50003;
		RETURN;
	END_IF
	
	brsmemset(pArray + ElementSize*TotalElements, 0, ElementSize*ElementsToClean);
	CleanEndArray := 0;
	      
END_FUNCTION
