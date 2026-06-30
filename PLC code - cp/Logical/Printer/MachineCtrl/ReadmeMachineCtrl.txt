
	(* From efi Cretaprint Almazora Castellon
	
	Machine Control is a manager of printers and based on two cyclic tasks.
	At first step, we have implemented on this case a slow cyclic task for belt cleaning, block cleaning, instant print shots, CB&Router resets, light beacon, buzzer sounds.
	All of them, are implemented using sequancial actions considered by main task named Machine_Ctrl_Slow. 
	An important point is showed in GeneralMachineData.st 
	It is an action where are all implemented all data that printer needs to be configured as logical for printing, from now on all parameters have to be paremeters defined by printer 
	
	At the second part is Machine_Ctrl_Fast.st
	Machine_Ctrl_Fast cyclic task has more priority than Machine_Ctrl_Slow
	In thi cyclic task, we have to implement status of the printer, ie, Machine status: PRINTING, CLEANING, CAP... Also Alarms, orders, status, Heigh Detection
	
	
	
	*)