
PROGRAM _INIT
	 
	X20AT4222_209.TempInput[1]:=123;
	X20AT4222_209.TempInput[2]:=234;
	X20AT4222_209.TempInput[3]:=456;
	X20AT4222_209.TempInput[4]:=567;

	//This is to assure raise alarms started with TRUE
	MpViewAlarms;
	Alarms;
	
END_PROGRAM

PROGRAM _CYCLIC

	MpViewAlarms;
	
	Alarms;
	
	IF EDGEPOS(xTest) THEN
		myValue := MpAlarmXSet(gAlrCore, 'Dryer.Alarm.BeltAnyDriveAlarm');
	ELSIF EDGENEG(xTest) THEN
		myValue := MpAlarmXReset(gAlrCore, 'Dryer.Alarm.BeltAnyDriveAlarm');
		myValueAck := MpAlarmXAcknowledge(gAlrCore, 'Dryer.Alarm.BeltAnyDriveAlarm');
	END_IF

	IF EDGEPOS(xTest2) THEN
		myValue2 := MpAlarmXSet(gAlrCore, 'Alarm2');
	ELSIF EDGENEG(xTest2) THEN
		myValue2 := MpAlarmXReset(gAlrCore, 'Alarm2');
		myValueAck2 := MpAlarmXAcknowledge(gAlrCore, 'Alarm2');
	END_IF
	
	xNone := MpAlarmXCheckState(gAlrCore, 'Dryer.Alarm.BeltAnyDriveAlarm', mpALARMX_STATE_NONE);
	xActive := MpAlarmXCheckState(gAlrCore, 'Dryer.Alarm.BeltAnyDriveAlarm', mpALARMX_STATE_ACTIVE);
	xInactive := MpAlarmXCheckState(gAlrCore, 'Dryer.Alarm.BeltAnyDriveAlarm', mpALARMX_STATE_INACTIVE);
	xAck := MpAlarmXCheckState(gAlrCore, 'Dryer.Alarm.BeltAnyDriveAlarm', mpALARMX_STATE_ACKNOWLEDGED);
	xUnAck := MpAlarmXCheckState(gAlrCore, 'Dryer.Alarm.BeltAnyDriveAlarm', mpALARMX_STATE_UNACKNOWLEDGED);
	
	gDryer.St.HMI.xDryerStopped := gDryer.St.DryerState = DRYERMACH_STOPPED;
	gDryer.St.HMI.xDryerLocalStopped := gDryer.St.DryerState = DRYERMACH_STOPPED AND gDryer.St.AutoLocation.xLocalORManual;
	gDryer.St.HMI.xShowThickness := gDryer.Pt.MachineModel = DryerType_NOZ2_NIR_ARCLAMP;
	gDryer.St.HMI.xShowEnableNIR := gDryer.St.DryerState =DRYERMACH_STOPPED AND
									gDryer.St.AutoLocation.xLocalORManual AND
									gNirAdphos.Status.xAnyModuleEnabled;
	
	//Simulate media in AutoLocal
	IF gDryer.St.Mode.xAuto AND gDryer.St.AutoLocation.xLocal THEN
		//Starting system
		IF EDGEPOS(gDryer.St.DryerState = DRYERMACH_DRYING) THEN
			xSimulateMedia := TRUE;
		ELSIF EDGENEG(gDryer.St.DryerState = DRYERMACH_DRYING) THEN
			xSimulateMedia := FALSE;
		END_IF
	ELSE
		xSimulateMedia := FALSE;
	END_IF
	tonSimMedia.IN := xSimulateMedia AND NOT tonSimMedia.Q;
	tonSimMedia.PT := T#500ms;
	tonSimMedia();
	IF EDGEPOS(tonSimMedia.Q) THEN
		gDryer.St.HMI.xVirtualMedia := NOT gDryer.St.HMI.xVirtualMedia;
	END_IF
	IF NOT gDryer.St.Mode.xAuto OR NOT gDryer.St.AutoLocation.xLocal THEN
		gDryer.St.HMI.xVirtualMedia := FALSE;
	END_IF
	
END_PROGRAM

PROGRAM _EXIT
	
	//Cards of the Dryer
	X20DIF371_201;
	X20DIF371_202;
	X20DIF371_203;
	X20DOF322_205;
	X20DOF322_206;
	X20AI8321_207;
	X20AO4622_208;
	X20AT4222_209;

END_PROGRAM

