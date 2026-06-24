
	(* From Icla datasheet
	
	Motor.Status.DriveStatu = 4 -> Ready TO Switch On off Passive operating state,
	motor without current
	Motor.Status.DriveStatu = 6  -> Operation Enable on Active operating state, current
	available TO motor
	Motor.Status.DriveStatu = 7 -> Quick Stop active on Fault state, power stage
	remains enabled
	Motor.Status.DriveStatu = 9 -> Fault off Fault state, power stage is
	disabled
	
	The field drivectrl in the object: PDO4.RPDO4.driveCtrl
	Bit no. Value Meaning
	0 01h Disable
	1 02h Enable
	2 04h Quick Stop
	3 08h Fault Reset
	4 10h Quick Stop release
	
	R_PDO4 provides three fields FOR these purposes:
	• modeCtrl Starting AND changing operating modes
	• "Ref16" AND "Ref32" Operating mode-dependent reference values
	The specified values FOR these three fields are NOT taken over BY the product
	UNTIL modeCtrl, bit 7 (ModeToggle) changes

	IF the product was originally in operating state 9, it will switch TO operating
	state 4 after the "Fault Reset". You THEN have TO transmit a "0 -> 1" EDGE
	in drivectrl, bit 1 "Enable", in order TO enable the power stage.
	
	drivectrl:
	Bit 0: Power stage Disable Triggered when 0 changes TO 1 Triggered at write ACCESS IF bit value = 1
	Bit 1: Power stage Enable
	Bit 2: Quickstop
	Bit 3: Fault Reset
	Bit 4: Quickstop Release
	*)