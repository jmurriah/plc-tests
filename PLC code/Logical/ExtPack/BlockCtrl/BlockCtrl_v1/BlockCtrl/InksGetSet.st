
ACTION GetInkSystemsData: 

	// Vars initialization
	//
	tiDripTimeMax:=0;	
	Block.Status.iBarsReadyToPrint:= 0;
	rPowerTempTotalBlock:=0;		
	
	//Running for ALL the bars of the machine. Just will enter for the ones in the block
	FOR iIndexInks:=1 TO Block.parameters.Inks.iMaxMachinePrintBars BY 1 DO

		//To analyze if the PrintBar is from the current block
		IF InkBarInBlock(iIndexInks, ADR(gInks), ADR(Block), gIndexBlock) THEN

			IF gInks[iIndexInks].status.iInkState <> INKS_STOPPED THEN
				
				// Drip Time Max Calculate for TON_DRIPPING is configured for dripping process
				tiDripTimeMax:=MAX(tiDripTimeMax, gInks[iIndexInks].parSw.tiDripTime);
	
				// Important: It gives info to block
				IF gInks[iIndexInks].status.xEnabledBarToPrint THEN	
					Block.Status.iBarsReadyToPrint:= Block.Status.iBarsReadyToPrint + 1;
				END_IF
			
			END_IF
			
			//Calculate power factor reduction
			rPowerTempTotalBlock:= rPowerTempTotalBlock + (gInks[iIndexInks].status.Temp.rDutyCycleTemp/100) * UINT_TO_REAL(gInks[iIndexInks].parameters.parBar.iPowerTempWatt);
			
		END_IF
		
	END_FOR;	
	
END_ACTION

ACTION AssignDataToInksSystem: 

	// Pending to have 3000 in constants per Block, It is max PSU Power installed in the block
	IF rPowerTempTotalBlock = 0 THEN
		rBlockReductionTempPower := 1.0;
	ELSE
		rBlockReductionTempPower:= UINT_TO_REAL(Block.parameters.Inks.iMaxPSUwattsForBars) / rPowerTempTotalBlock ;
		rBlockReductionTempPower:= MIN(rBlockReductionTempPower, 1.0);
	END_IF
	
	//Assignation of ink variables
	FOR iIndexInks:=1 TO Block.parameters.Inks.iMaxMachinePrintBars BY 1 DO
		
		//To analyze if the PrintBar is from the current block
		IF InkBarInBlock(iIndexInks, ADR(gInks), ADR(Block), gIndexBlock) THEN
			
			gInks[iIndexInks].commands.xOrderCleaning:= Block.commands.xInksOrderCleaning;
			gInks[iIndexInks].commands.xOrderDrip:= Block.commands.xDripControl AND (gInks[iIndexInks].parSw.tiDripTime>0);
			gInks[iIndexInks].commands.xCloseReliefValve := xCloseReliefValve;
			
			gInks[iIndexInks].parameters.tiDripTimeMax:= tiDripTimeMax;
			gInks[iIndexInks].parameters.Temp.rReductionTempPower:=rBlockReductionTempPower;
			//It allows to work in automatic reverse when block is capped and is configured the command xOnReverseCapped/Idle in the GUI
			gInks[iIndexInks].parameters.xBlockInCap := xInCap;
			//Send to ink sistem when the block is in print position to check the correct ink state to print
			gInks[iIndexInks].parameters.xBlockInPrint := xInPrint;
			
			//Assigning MaxPrintBarsPerBlock to determine when the printbar can use the PSU to heat the Ink
			gInks[iIndexInks].parameters.Temp.iBarsWithSameBlock:= Block.parameters.Inks.iMaxBlockPrintBars;
			
		END_IF
			
	END_FOR;
	
END_ACTION
