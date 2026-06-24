


ACTION PowerCtrl:
	
	// If alarm Sai PowerOff and Keep Pcs Cms
	T_OnPcs.IN:= NOT gMachine.Al.Alarm.xAlarmSAIPowerOff;
	T_OnPcs.PT:= T#5S;
	T_OnPcs();
			
	xOnPcs:= T_OnPcs.Q AND gMachine.parSw.PCs.xKeepPcsOn;

	
	// Starting PC1
	T_WaitPC1.IN:= xOnPcs AND NOT gMachine.In.xPC1Ok AND NOT T_OnPC1.Q;
	T_WaitPC1.PT:= T#3S;
	T_WaitPC1();
	
	T_OnPC1.IN:=T_WaitPC1.Q; 
	T_OnPC1.PT:= T#500MS;
	T_OnPC1();
	
	gMachine.Out.xPC1Start:= T_WaitPC1.Q;
			

	// Starting PC2
	T_WaitPC2.IN:= xOnPcs AND NOT gMachine.In.xPC2Ok AND NOT T_OnPC2.Q;
	T_WaitPC2.PT:= T#3S;
	T_WaitPC2();
	
	T_OnPC2.IN:=T_WaitPC2.Q; 
	T_OnPC2.PT:= T#500MS;
	T_OnPC2();
	
	gMachine.Out.xPC2Start:= T_WaitPC2.Q;
	
		
END_ACTION


