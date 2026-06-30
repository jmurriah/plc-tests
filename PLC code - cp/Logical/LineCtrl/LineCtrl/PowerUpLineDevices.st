
ACTION PowerUpLineDevices:
	
	IF xStatusChanged THEN
		iLineStatus:=110;
		iIndexPower:=0;
	END_IF

	CASE iLineStatus OF
		
		110:
			//Timer
			ton_DelayPowerOn.IN := TRUE;
			ton_DelayPowerOn.PT:= Line.Parameters.ExternalDevices[iIndexPower].tiDelay;
			ton_DelayPowerOn();
			
			IF Line.Parameters.ExternalDevices[iIndexPower].xIsEngine THEN
				//Activate the first output signal
				Line.Outputs.ExternalDevices[iIndexPower].xOpen:=TRUE;
				
				IF ton_DelayPowerOn.Q THEN
					//Activate second signal when motorized contactor is loaded
					Line.Outputs.ExternalDevices[iIndexPower].xClose:=TRUE;
					
					//Go to next
					ResetPowerOnTimerAndNext;
				END_IF
			
			ELSE
				IF ton_DelayPowerOn.Q THEN 
					//Activate both outputs if it is not Motorized contactor
					Line.Outputs.ExternalDevices[iIndexPower].xClose:=TRUE;
					Line.Outputs.ExternalDevices[iIndexPower].xOpen:=TRUE;

					//Go to next
					ResetPowerOnTimerAndNext;
				END_IF
			END_IF
			iLastIndexPower := iIndexPower;
						
		111:
			
			IF iIndexPower<=Line.Parameters.iNumExternalDevices THEN
				//If the Index is not the last one, repeate the timer to activate next one
				iLineStatus:=110;
			ELSE
				iLineStatus:=iLineStatus+1;
			END_IF
			
		112:
			xLinePoweredON := TRUE;
			xLineReady:=TRUE;
		
	END_CASE
	
END_ACTION

ACTION ResetPowerOnTimerAndNext:
	
	//Reset timer
	ton_DelayPowerOn(IN:=FALSE);
	iIndexPower:=iIndexPower+1;
	iLineStatus:=iLineStatus+1;
	
END_ACTION
