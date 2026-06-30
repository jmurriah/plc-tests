
ACTION solenoids: 

	xAuxSolenoidDirect:=inks.status.iDirection = INKSDIR_DIRECT OR
						(inks.status.iDirection = INKSDIR_REVERSE AND NOT TON_Stab2.Q) OR
						(inks.status.iDirection = INKSDIR_STOP AND NOT TON_CloseSole.Q);

					
	xAuxSolenoidReverse:=(inks.status.iDirection = INKSDIR_DIRECT AND NOT TON_Stab1.Q) OR
						inks.status.iDirection = INKSDIR_REVERSE OR
						(inks.status.iDirection = INKSDIR_STOP AND NOT TON_CloseSole.Q);

		
	IF inks.status.iDirection = INKSDIR_STOP THEN
		AuxiliarSolenoid := FALSE;
	ELSIF inks.status.iDirection = INKSDIR_DIRECT OR inks.status.iDirection = INKSDIR_REVERSE THEN
		AuxiliarSolenoid := TRUE;
	END_IF					
		

	inks.signals.out.xSolenoid1:= xAuxSolenoidDirect AND AuxiliarSolenoid ;
	inks.signals.out.xSolenoid4:= xAuxSolenoidDirect;

	inks.signals.out.xSolenoid2:= xAuxSolenoidReverse;
	inks.signals.out.xSolenoid3:= xAuxSolenoidReverse AND AuxiliarSolenoid ;

	iStabSoleW:=parBar.iStabSole;
	iDisablePidW:=parBar.iDesahPid;
	iCloseSoleW:=parBar.iCloseSole;

	IF iStabSoleW < 200 THEN iStabSoleW := 200; END_IF
	IF iDisablePidW < 250 THEN iDisablePidW := 250; END_IF

	TON_Stab1(	IN:= inks.status.iDirection = INKSDIR_DIRECT,
				PT:= INT_TO_TIME(iStabSoleW));

	TON_Stab2(	IN:= inks.status.iDirection = INKSDIR_REVERSE,
				PT:= INT_TO_TIME(iStabSoleW));

	TON_CloseSole(	IN:= inks.status.iDirection = INKSDIR_STOP,
					PT:= INT_TO_TIME(iCloseSoleW));

	TON_StabSolPid1Neg(IN:= inks.status.iDirection = INKSDIR_REVERSE,
						PT:= INT_TO_TIME(iDisablePidW) );	//This value [3] is to have less time Hold the negative pump

	TON_StabSolPid1Pos(IN:= TON_StabSolPid1Neg.IN,
						PT:= INT_TO_TIME(iDisablePidW));
					
	TON_StabSolPid2Neg(IN:= mode4 AND //INKS_STARTED
							(iInkPreviousState = INKS_AUTO_REVERSEFLOW OR iInkPreviousState = INKS_MANUAL_REVERSEFLOW),
						PT:= INT_TO_TIME(iDisablePidW) );  //This value [3] is to have less time Hold the negative pump

	TON_StabSolPid2Pos(IN:= TON_StabSolPid2Neg.IN,
						PT:= INT_TO_TIME(iDisablePidW));
					
END_ACTION
