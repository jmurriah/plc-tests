
ACTION JamVibrationConfiguration: 

	IF NOT gMachine.parSw.xJamDetectEnable THEN
		gMachine.St.iJamDevices := 0;
		RETURN;
	END_IF		

	//Just writing the fixed configuration once per each 5s
	IF NOT (EDGEPOS(gPLC.xBlk_5s) OR gPLC.xFirst_Scan OR xChangedSimMachine) THEN
		RETURN;
	END_IF
	
	
	//Cleand the array if the machine model is changed
	IF MachineModelCopy <> gMachine.Pt.MachineModel THEN
		gJamDetect := gJamDetectReseted;
	END_IF
	
	//Main calculations
	IF NOT gCamera.Parameters.xInstalled THEN
		iBarsWithJamDevice := gBlock[1].parameters.iApplicationBars;
	ELSE
		iBarsWithJamDevice := gBlock[1].parameters.iApplicationBars + 1;
	END_IF
	
	iJamDevicesPerBlock :=  REAL_TO_USINT(brmceil(USINT_TO_REAL(iBarsWithJamDevice) / USINT_TO_REAL(gMachine.Pt.CT.iNumSensorsPerJamDevice)));
	gMachine.St.iJamDevices := iJamDevicesPerBlock * gMachine.Pt.CT.iNumBlocks; //[RGP] To review how to approach this calculation so with camera this is not correct
	
	IF gMachine.Pt.xLeftHandMachine THEN

		iFirstJamDevice := 1;
		iFirstJamSensor := 1;
		iJamSensorItem := 1;
		
		FOR iBlockIndex:=GC_FIRST_BLOCK TO gMachine.Pt.CT.iNumBlocks DO
	 
			iJamSensorInBlock := 1;
			
			FOR iJamDeviceIndex:=iFirstJamDevice TO iFirstJamDevice + iJamDevicesPerBlock - 1 DO
				gJamDetect[iJamDeviceIndex].Parameters.iBlock := iBlockIndex;
				gJamDetect[iJamDeviceIndex].Parameters.iMappingJam  := iJamDeviceIndex;
				gJamDetect[iJamDeviceIndex].Parameters.iSensorsQuantity := gMachine.Pt.CT.iNumSensorsPerJamDevice;

				(** Low jam detection DELOREAN-2694 **)
				gJamDetect[iJamDeviceIndex].Parameters.iLowJamCheckDuration[0] := T#1m;
				gJamDetect[iJamDeviceIndex].Parameters.iLowJamTimes[0] := 3;
				gJamDetect[iJamDeviceIndex].Parameters.iLowJamCheckDuration[1] := T#30m;
				gJamDetect[iJamDeviceIndex].Parameters.iLowJamTimes[1] := 10;


				JamSensorMappingLeftAssignation;
				iFirstJamSensor := iFirstJamSensor + gMachine.Pt.CT.iNumSensorsPerJamDevice;
				
			END_FOR
			iFirstJamDevice := iFirstJamDevice + iJamDevicesPerBlock;
			
		END_FOR;

	ELSE
		
		iFirstJamDevice := 1;
		iFirstJamSensor := 1;
		iJamSensorItem := 1;
		
		FOR iBlockIndex:=GC_FIRST_BLOCK TO gMachine.Pt.CT.iNumBlocks DO
	 
			iJamSensorInBlock := 1;
			iJamDeviceInBlock := 1;
			
			FOR iJamDeviceIndex:=iFirstJamDevice TO iFirstJamDevice + iJamDevicesPerBlock - 1 DO
				gJamDetect[iJamDeviceIndex].Parameters.iBlock := iBlockIndex;
				gJamDetect[iJamDeviceIndex].Parameters.iMappingJam  := (gMachine.Pt.CT.iNumBlocks * iJamDevicesPerBlock ) - (iBlockIndex * iJamDevicesPerBlock) + iJamDeviceInBlock;
				gJamDetect[iJamDeviceIndex].Parameters.iSensorsQuantity := gMachine.Pt.CT.iNumSensorsPerJamDevice;
				
				JamSensorMappingRightAssignation;
				
				iJamDeviceInBlock := iJamDeviceInBlock + 1;
				iFirstJamSensor := iFirstJamSensor + gMachine.Pt.CT.iNumSensorsPerJamDevice;
			END_FOR;

			iFirstJamDevice := iFirstJamDevice + iJamDevicesPerBlock;
			
		END_FOR;		

	END_IF				
	
	JamSensorsAssignation;
	
END_ACTION

ACTION JamSensorMappingLeftAssignation: 

	FOR iJamSensorIndex:=1 TO gMachine.Pt.CT.iNumSensorsPerJamDevice DO
		gJamDetect[iJamDeviceIndex].Parameters.iMappingBarPos[iJamSensorIndex] := iJamSensorItem;

		iJamSensorItem := iJamSensorItem + 1;
		iJamSensorInBlock := iJamSensorInBlock + 1;
		
		//If the maximum of bars in the block is achieved, return
		IF iJamSensorInBlock > iBarsWithJamDevice THEN
			RETURN;
		END_IF

	END_FOR;				
	
END_ACTION


ACTION JamSensorMappingRightAssignation: 

	FOR iJamSensorIndex:=1 TO gMachine.Pt.CT.iNumSensorsPerJamDevice DO
		gJamDetect[iJamDeviceIndex].Parameters.iMappingBarPos[iJamSensorIndex] := (gMachine.Pt.CT.iNumBlocks - iBlockIndex) * iBarsWithJamDevice + iJamSensorInBlock;

		iJamSensorItem := iJamSensorItem + 1;
		iJamSensorInBlock := iJamSensorInBlock + 1;
		
		//If the maximum of bars in the block is achieved, return
		IF iJamSensorInBlock > iBarsWithJamDevice THEN
			RETURN;
		END_IF

	END_FOR;				
	
END_ACTION
