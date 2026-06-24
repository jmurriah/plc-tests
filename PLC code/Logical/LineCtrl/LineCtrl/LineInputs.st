
ACTION LineInputs:
	
	tonLineNotPowered.IN:= NOT Line.Inputs.xPrinterPowered; //Line.Inputs.UPSs[1].LoadOnBattery OR Line.Inputs.UPSs[2].LoadOnBattery;
	tonLineNotPowered.PT:=T#20s;
	tonLineNotPowered();
	xLinePowered := NOT tonLineNotPowered.Q;
	
	//Start order
	tonLineStartButton(IN:=gMachine.In.Buttons.xStart, PT:=T#1s);
	
END_ACTION



