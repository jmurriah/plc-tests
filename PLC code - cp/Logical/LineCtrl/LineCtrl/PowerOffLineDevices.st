
ACTION PowerOffLineDevices:
	
	IF xStatusChanged THEN
		iLineStatus:=100;
		iIndexPower:=0;
		xLinePoweredOFF:=FALSE;
	END_IF

	CASE iLineStatus OF
		100:
			ton_DelayPowerOff.IN := TRUE;
			ton_DelayPowerOff.PT := t#3s;
			ton_DelayPowerOff();
			
			IF iIndexPower<=Line.Parameters.iNumExternalDevices THEN
				
				IF Line.Parameters.ExternalDevices[iIndexPower].xIsEngine THEN
					Line.Outputs.ExternalDevices[iIndexPower].xClose:=FALSE;
					
					IF ton_DelayPowerOff.Q THEN
						//Reset the output
						Line.Outputs.ExternalDevices[iIndexPower].xOpen:=FALSE;
						
						//Reset timer
						ResetPowerOffTimerAndNext;
					END_IF
				
				ELSE
					//Reset the outputs
					Line.Outputs.ExternalDevices[iIndexPower].xOpen:=FALSE;
					Line.Outputs.ExternalDevices[iIndexPower].xClose:=FALSE;
					
					ResetPowerOffTimerAndNext;
				END_IF
			
			ELSE
				iLineStatus:=iLineStatus+1;
			END_IF
						
		101:
			xLinePoweredOFF:=TRUE;
		
	END_CASE
		
END_ACTION

ACTION ResetPowerOffTimerAndNext:
	
	//Reset timer
	ton_DelayPowerOff(IN:=FALSE);
	iIndexPower:=iIndexPower+1;
	
END_ACTION
