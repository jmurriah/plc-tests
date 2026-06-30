
ACTION DryerState: 
	
	xAnyDeviceEnabled := gNirAdphos.Status.xEnabledNir OR gArcLampGew.Status.xEnabledArcLamp;
	xNirReady := gNirAdphos.State = NIRADPEW_READY OR gNirAdphos.State = NIRADPEW_RUNNING;
	xNirDrying := gNirAdphos.State = NIRADPEW_RUNNING;
	xNirStopped := gNirAdphos.State = NIRADPEW_IDLE OR gNirAdphos.State = NIRADPEW_ERROR;

	xArcLampReady := gArcLampGew.State = ARCLGEW_READY OR gArcLampGew.State = ARCLGEW_RUNNING;
	xArcLampDrying := gArcLampGew.State = ARCLGEW_RUNNING;
	xArcLampStopped := gArcLampGew.State = ARCLGEW_IDLE OR gArcLampGew.State = ARCLGEW_ERROR;
	
	
	xAllDryersReady := (xNirReady OR NOT gNirAdphos.Status.xEnabledNir) AND
						(xArcLampReady OR NOT gArcLampGew.Status.xEnabledArcLamp);
	xAllDryersDrying := (xNirDrying OR NOT gNirAdphos.Status.xEnabledNir) AND
						(xArcLampDrying OR NOT gArcLampGew.Status.xEnabledArcLamp);
	xAllDryersStopped := (xNirStopped OR NOT gNirAdphos.Status.xEnabledNir) AND
						(xArcLampStopped OR NOT gArcLampGew.Status.xEnabledArcLamp);
	
	tonPreparingEmptyBelt.IN := DryerStatus = DRYERMACH_PREPARINGEMPTYBELT AND gTransVacuum[1].Status.State <> TRANSVAC_OFF;
	tonPreparingEmptyBelt.PT := T#10s;
	tonPreparingEmptyBelt();
	
	CASE DryerStatus OF
		
		DRYERMACH_STOPPED:
			
			ResetOrdersToAllDryersDevices;
			
			IF DryerSignalsAuto.Commands.xRunTransport THEN
				DryerStatus:=DRYERMACH_PREPARINGTOMOVE;
			ELSIF DryerSignalsAuto.Commands.xPrepareToEmptyBelt THEN
				DryerStatus := DRYERMACH_PREPARINGEMPTYBELT;
			END_IF
			
		DRYERMACH_STOPPING_TRANSPORT:
			//Actions
			xOrdersRunBeltProduction := FALSE;
			gArcLampGew.Commands.xStop := TRUE;
			gNirAdphos.Commands.xStop := TRUE;
			
			//Transition
			IF NOT gBelt.states.xRuningBelt THEN
				DryerSignalsAuto.Commands := DryerCommandsReseted;
				DryerStatus:=DRYERMACH_STOPPED;
			END_IF
			
		DRYERMACH_PREPARINGEMPTYBELT:
			IF tonPreparingEmptyBelt.Q THEN
				gDryer.St.Out.xReadyToEmptyBelt := TRUE;
			END_IF
			IF DryerSignalsAuto.Commands.xRunTransport THEN
				DryerStatus := DRYERMACH_PREPARINGTOMOVE;
				gDryer.St.Out.xReadyToEmptyBelt := FALSE;
			END_IF
			
		DRYERMACH_PREPARINGTOMOVE:
			xOrdersRunBeltProduction := TRUE;

			IF gBelt.states.xRuningBelt THEN
				DryerStatus:=DRYERMACH_MOVING;
			END_IF
		
		DRYERMACH_MOVING:
			IF xAnyDeviceEnabled AND DryerSignalsAuto.Commands.xPrepareToDry THEN
				DryerStatus:=DRYERMACH_PREPARING;
			END_IF
			
		DRYERMACH_PREPARING:
			//Actions
			IF xChangeState THEN
				gArcLampGew.Commands.xPrepare := TRUE;
				gNirAdphos.Commands.xPrepare := TRUE;
			END_IF

			IF xAllDryersReady THEN
				DryerStatus:=DRYERMACH_PREPARED;
			END_IF
			
			IF NOT DryerSignalsAuto.Commands.xPrepareToDry THEN
				DryerStatus:=DRYERMACH_STOPPING_DRYING;
			END_IF
			
		DRYERMACH_PREPARED:
			IF DryerSignalsAuto.Commands.xStartDrying THEN
				DryerStatus:=DRYERMACH_STARTING;
			END_IF

			IF NOT DryerSignalsAuto.Commands.xPrepareToDry THEN
				DryerStatus:=DRYERMACH_STOPPING_DRYING;
			END_IF
			
		DRYERMACH_STARTING:
			//Actions
			IF xChangeState THEN
				gArcLampGew.Commands.xStart := TRUE;
				gNirAdphos.Commands.xStart := TRUE;
			END_IF
			
			//Transition
			IF xAllDryersDrying THEN
				DryerStatus:=DRYERMACH_DRYING;
			END_IF
			//Transition
			IF NOT DryerSignalsAuto.Commands.xStartDrying OR NOT DryerSignalsAuto.Commands.xPrepareToDry THEN
				DryerStatus:=DRYERMACH_STOPPING_DRYING;
			END_IF
			
		DRYERMACH_DRYING:
			IF NOT DryerSignalsAuto.Commands.xStartDrying OR gDryer.Al.xAlrStopDrying THEN
				DryerStatus:=DRYERMACH_STOPPING_DRYING;
			END_IF
			
		DRYERMACH_STOPPING_DRYING:
			//Actions
			IF xChangeState THEN
				gArcLampGew.Commands.xStop := TRUE;
				gNirAdphos.Commands.xStop := TRUE;
			END_IF

			IF xAllDryersStopped THEN
				DryerStatus:=DRYERMACH_MOVING;
			END_IF
			IF DryerSignalsAuto.Commands.xStartDrying THEN
				DryerStatus:=DRYERMACH_STARTING;
			END_IF
		
	END_CASE;
	
	IF (NOT gDryer.St.AutoMode.xProduction OR NOT DryerSignalsAuto.Commands.xRunTransport) AND DryerStatus<>DRYERMACH_STOPPED AND DryerStatus<>DRYERMACH_STOPPING_TRANSPORT AND DryerStatus<>DRYERMACH_PREPARINGEMPTYBELT THEN
		DryerStatus:=DRYERMACH_STOPPING_TRANSPORT;
	END_IF
	
	xChangeState := DryerStatus <> DryerStatus_copy;
	DryerStatus_copy := DryerStatus;
	
	//Store the history of the status to easy the debug
	IF DryerStatus<>StateHistory[0] THEN
		FOR iIndexHistory:=iHistoryLines TO 1 BY -1 DO 
			StateHistory[iIndexHistory]:=StateHistory[iIndexHistory-1];
		END_FOR;
		StateHistory[0]:=DryerStatus;
		LogNewState;
	END_IF
	
	gDryer.St.DryerState := DryerStatus;
	
	gDryer.St.Out.xOnline := TRUE;
	gDryer.St.Out.xDryerPresent := TRUE;
	gDryer.St.Out.xTransportMoving := gBelt.states.xRuningBelt;
	gDryer.St.Out.xInRemote := gDryer.St.AutoLocation.xRemote;
	gDryer.St.Out.xError :=  DryerStatus = DRYERMACH_ERROR;
	gDryer.St.Out.xJamDetection := FALSE;

	ton_EmptyBelt.IN := gDryer.St.AutoLocation.xRemote AND gBelt.states.xRuningBelt AND NOT gDryerRemoteData.Parameters.xPrinterBeltRuning;
	ton_EmptyBelt.PT := T#20s;
	ton_EmptyBelt();
	gDryer.St.Out.xDrying := FALSE;
	gDryer.St.Out.xMediaPresent := FALSE;
	
	iReasonReadyToDry.0 := DryerStatus = DRYERMACH_PREPARED;
	iReasonReadyToDry.1 := DryerStatus = DRYERMACH_STARTING;
	iReasonReadyToDry.2 := DryerStatus = DRYERMACH_DRYING;
	gDryer.St.Out.xReadyToDry :=  iReasonReadyToDry > 0;
	
	gDryerLocalData.xError := gDryer.AlSummary.xAlarmCritical OR gDryer.AlSummary.xAlarmStop;
	gDryerLocalData.xDrying := DryerStatus = DRYERMACH_DRYING OR DryerStatus = DRYERMACH_STARTING;
	gDryerLocalData.xReadyToDry := gDryer.St.Out.xReadyToDry;
	gDryerLocalData.xJamDetection := gDryer.Al.Alarm.xAlrJam;
	gDryerLocalData.xTransportMoving := gBelt.states.xRuningBelt;
	gDryerLocalData.xInRemote := gDryer.St.AutoLocation.xRemote;
	gDryerLocalData.xMediaPresent := gThicknessCtrl.status.MediaPosition.xMediaBelowMachine;
	gDryerLocalData.xBeltEmpty := gThicknessCtrl.status.Belt.xBeltEmpty OR ton_EmptyBelt.Q;
	gDryerLocalData.xStopButtonPressed := gDryer.In.Buttons.xStop;
	gDryerLocalData.xReadyToEmptyBelt := gDryer.St.Out.xReadyToEmptyBelt;
	

	gDryer.St.Out.iModelVersion1 := gPLC.iVersion0;
	gDryer.St.Out.iModelVersion2 := gPLC.iVersion1;
	
END_ACTION


ACTION ResetOrdersToAllDryersDevices:
	ResetOrdersToArcLamp;
	ResetOrdersToNirAdphos;
END_ACTION

ACTION ResetOrdersToArcLamp:
	gArcLampGew.Commands.xPrepare := FALSE;
	gArcLampGew.Commands.xStart := FALSE;
	gArcLampGew.Commands.xStop := FALSE;
END_ACTION

ACTION ResetOrdersToNirAdphos:
	gNirAdphos.Commands.xPrepare := FALSE;
	gNirAdphos.Commands.xStart := FALSE;
	gNirAdphos.Commands.xStop := FALSE;
END_ACTION

