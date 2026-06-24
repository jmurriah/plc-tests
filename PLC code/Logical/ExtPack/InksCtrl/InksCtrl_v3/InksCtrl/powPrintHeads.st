
ACTION powPrintHeads: 

	inks.signals.out.xOutPowPrintHead:=inks.ordersSw.xPowPrintHead AND NOT inks.Al.xAlrPrintHeadPsuFailure AND NOT inks.Al.xAlrPrintHeadsChillerStopped;
		
END_ACTION
