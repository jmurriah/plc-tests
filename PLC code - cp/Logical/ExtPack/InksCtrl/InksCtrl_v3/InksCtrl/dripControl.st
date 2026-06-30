
ACTION dripControl: 

	//  The bar waits an OrderDrip while any of the bars in the same block has to drip.
	// Each bar delays the start of the dripping taking into account its dripping time and the MaxDripTime
	// The Block is the responsible of removing the OrderDrip with a timer of the MaxDripTime of its bars
	
	// Just in case of Drip time is upper to 0 then It sends drip order to pressure control. Jira 784
	tonDrip.IN := inks.status.xInksRunning AND inks.commands.xOrderDrip AND TON_TimeAfterCloseReliefValve.Q AND (inks.status.tiDriptime>0);
	tonDrip.PT := tiDripTimeMax - tiDripTime; //Using the internal vars. Cheched the limits in ConversionsPre
	tonDrip();
	xDrippingOrder := tonDrip.Q;
	
	inks.status.xDripping := xDrippingOrder;
	
END_ACTION
