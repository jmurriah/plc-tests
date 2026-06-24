
ACTION LoadSectionsInformation: 

	FOR iIndexSection:=1 TO iTotalSections DO
		IF (NOT dataHeigh.status.MediaPosition.xMountedMediaInside) THEN
			//Assign the Max
			dataHeigh.status.Heigh.rMaxHeigh[iIndexSection] := UINT_TO_REAL(iMaxHeigh[iIndexSection])/100;
		
		ELSIF dataHeigh.Commands.xAllowToSetMountedMediaHeigh THEN
			dataHeigh.status.Heigh.rMaxHeigh[iIndexSection] := dataHeigh.parameters.rMountedMediaHeigh;
		END_IF
		
		//Increase signal
		//If the condition is OK, raise the signal
		IF iLastMaxHeigh[iIndexSection] < iMaxHeigh[iIndexSection] THEN
			dataHeigh.status.Heigh.xIncreasedHeigh[iIndexSection] := TRUE;
			iCountIncrease[iIndexSection]:=8; //The cycles to have the signal of the increased enabled (to use it in slow programs)
		END_IF
		//Deactivate the signal once the counter arrives
		IF iCountIncrease[iIndexSection]=0 THEN
			dataHeigh.status.Heigh.xIncreasedHeigh[iIndexSection] := FALSE;
		END_IF
		//Reduce the counter related to increase
		IF iCountIncrease[iIndexSection]>0 THEN
			iCountIncrease[iIndexSection] := iCountIncrease[iIndexSection] -1;
		END_IF		
		
		//dataHeigh.status.Heigh.xIncreasedHeigh[iIndexSection] := iLastMaxHeigh[iIndexSection] < iMaxHeigh[iIndexSection];
		iLastMaxHeigh[iIndexSection] := iMaxHeigh[iIndexSection];
	END_FOR
	
END_ACTION
