
ACTION JamSensorsAssignation: 

	IF NOT gMachine.parSw.xJamDetectEnable THEN
		RETURN;
	END_IF
	
	//Enable the jam sensor if a bar is installed in its position

	//Run the Jam devices
	FOR iIndexJamDevice := 1 TO gMachine.St.iJamDevices DO
		
		//Run the Jam sensors per device
		FOR iIndexJamSensor := 1 TO gMachine.Pt.CT.iNumSensorsPerJamDevice DO
			
			//Run the Inks to review if there is any of them with the same Mapping
			xIsBarInstalled := FALSE;
			CheckInkBarInJamPosition;
			gJamDetect[iIndexJamDevice].Parameters.xBarInstalled[iIndexJamSensor]:= xIsBarInstalled;
			
			//Run the curing led bars
			IF NOT xIsBarInstalled THEN
				CheckCuringBarInJamPosition;
				gJamDetect[iIndexJamDevice].Parameters.xBarInstalled[iIndexJamSensor]:= xIsBarInstalled;
				
				IF NOT xIsBarInstalled THEN
					CheckCameraInJamPosition;
					gJamDetect[iIndexJamDevice].Parameters.xBarInstalled[iIndexJamSensor]:= xIsBarInstalled;
				END_IF
				
			END_IF
			
		END_FOR
		
	END_FOR
	
END_ACTION


ACTION CheckInkBarInJamPosition: 

	FOR iIndexInks :=1 TO MAX_LAST_INK DO
		
		//If there is a Match, mark it and return to avoid extra loops
		IF  gInks[iIndexInks].parSw.Config.iMappingBar = gJamDetect[iIndexJamDevice].Parameters.iMappingBarPos[iIndexJamSensor] AND 
			gInks[iIndexInks].parSw.Config.iMappingBar > 0 THEN
				
			xIsBarInstalled := TRUE;
			
			gJamPerInk[iIndexInks].iJamDevice := iIndexJamDevice;
			gJamPerInk[iIndexInks].iJamSensor := iIndexJamSensor;
			
			RETURN;
		END_IF
				
	END_FOR

END_ACTION


ACTION CheckCuringBarInJamPosition: 

	FOR iIndexCuringLedLamps :=1 TO MAX_LAST_CURING_LED DO
			
		//If there is a Match, mark it and return to avoid extra loops
		IF  gCuringLed[iIndexCuringLedLamps].Parameters.iMappingBar = gJamDetect[iIndexJamDevice].Parameters.iMappingBarPos[iIndexJamSensor] AND 
			gCuringLed[iIndexCuringLedLamps].Parameters.xInstalled THEN
				
			xIsBarInstalled := TRUE;

			gJamPerCuringLed[iIndexCuringLedLamps].iJamDevice := iIndexJamDevice;
			gJamPerCuringLed[iIndexCuringLedLamps].iJamSensor := iIndexJamSensor;

			RETURN;
		END_IF

	END_FOR
	
END_ACTION


ACTION CheckCameraInJamPosition: 
			
	IF  gCamera.Parameters.iMappingBar = gJamDetect[iIndexJamDevice].Parameters.iMappingBarPos[iIndexJamSensor] AND 
		gCamera.Parameters.xInstalled THEN
				
		xIsBarInstalled := TRUE;
		
		gJamCamera.iJamDevice := iIndexJamDevice;
		gJamCamera.iJamSensor := iIndexJamSensor;
		
	END_IF
				
END_ACTION