
//ncAbsMov := ncHALT_OK;

PROGRAM _CYCLIC
	
	Icla ACCESS ADR(gIcla[iIclaSimIndex]);
	IclaSim ACCESS ADR(gIclaSim[iIclaSimIndex]);
	
	IF NOT Icla.Command.Enable THEN
		ncAbsMov := ncHALT_OK;
		Icla.Status.iActualVelocity := 0;
		Icla.Status.IclaStatus:= AXISILE_WAIT;
		iIclaSimIndex := iIclaSimIndex + 1;
		RETURN;
	END_IF
	
	//Home the Icla
	IF EDGEPOS(Icla.Command.Home) THEN
		Icla.Status.xReferenced:=TRUE;
		Icla.Status.iActualPosition:=Icla.Parameter.Home.Position;
		rActPosition := DINT_TO_REAL(Icla.Status.iActualPosition);
		Icla.Command.Home:=FALSE;
	END_IF
	
	IF Icla.Command.JogBackward AND Icla.Command.JogForward THEN
		Icla.Command.JogBackward:=FALSE;
		Icla.Command.JogForward:=FALSE;
	END_IF
	
	
	//Defining the advance in each direction and the stop
	rMsFromLastExec := TIME_TO_REAL(clock_ms()-tiLastExec);

	IF Icla.Command.JogBackward THEN
		IF Icla.Command.JogFastSpeed THEN
			//Define the advance. The minimum advance will be 1. The speed is defined in revs per minute
			rAdvance := IclaSim.Parameters.SpeedFactor * UINT_TO_REAL(Icla.Parameter.Jog.VeloFast)*rMsFromLastExec/1000;
		ELSE
			//Define the advance. The minimum advance will be 1. The speed is defined in revs per minute
			rAdvance := IclaSim.Parameters.SpeedFactor * UINT_TO_REAL(Icla.Parameter.Jog.VeloSlow)*rMsFromLastExec/1000;
		END_IF
		rActPosition := rActPosition - rAdvance;
		Icla.Status.iActualPosition := REAL_TO_DINT(rActPosition);
	END_IF

	IF Icla.Command.JogForward THEN
		IF Icla.Command.JogFastSpeed THEN
			//Define the advance. The minimum advance will be 1. The speed is defined in revs per minute
			rAdvance := IclaSim.Parameters.SpeedFactor * UINT_TO_REAL(Icla.Parameter.Jog.VeloFast)*rMsFromLastExec/1000;
		ELSE
			//Define the advance. The minimum advance will be 1. The speed is defined in revs per minute
			rAdvance := IclaSim.Parameters.SpeedFactor * UINT_TO_REAL(Icla.Parameter.Jog.VeloSlow)*rMsFromLastExec/1000;
		END_IF
		rActPosition := rActPosition + rAdvance;
		Icla.Status.iActualPosition := REAL_TO_DINT(rActPosition);
	END_IF

	//Basic Moving Absolute code

	IF ncAbsMov = ncPOS_MOVE THEN
		rSpeed := rSpeed + UINT_TO_REAL(Icla.Parameter.iAcceleration)*rMsFromLastExec/1000;
		rSpeed := MIN(rSpeed, UINT_TO_REAL(Icla.Parameter.MoveAbsolute.Velocity)); //Speed limitation
		rAdvance := IclaSim.Parameters.SpeedFactor * rSpeed *rMsFromLastExec/1000;
		rActPosition := rActPosition + rAdvance;
		Icla.Status.iActualPosition := REAL_TO_DINT(rActPosition);
		Icla.Status.IclaStatus:= AXISILE_MOVE_ABSOLUTE;
		IF Icla.Status.iActualPosition > Icla.Parameter.MoveAbsolute.Position THEN
			//xMovingAbs:=FALSE;
			//xIsMovingAbs:=FALSE;
			Icla.Command.MoveAbsolute:=FALSE;
			ncAbsMov := ncHALT_OK;
			rSpeed := 0;
		END_IF
	END_IF

	IF ncAbsMov = ncNEG_MOVE THEN
		rSpeed := rSpeed + UINT_TO_REAL(Icla.Parameter.iAcceleration)*rMsFromLastExec/1000;
		rSpeed := MIN(rSpeed, UINT_TO_REAL(Icla.Parameter.MoveAbsolute.Velocity)); //Speed limitation
		rAdvance := IclaSim.Parameters.SpeedFactor * rSpeed *rMsFromLastExec/1000;
		rActPosition := rActPosition - rAdvance;
		Icla.Status.iActualPosition := REAL_TO_DINT(rActPosition);
		Icla.Status.IclaStatus:= AXISILE_MOVE_ABSOLUTE;
		IF Icla.Status.iActualPosition < Icla.Parameter.MoveAbsolute.Position THEN
			Icla.Command.MoveAbsolute:=FALSE;
			ncAbsMov := ncHALT_OK;
			rSpeed := 0;
		END_IF
	END_IF		
	
	//Start Absolute movement
	IF EDGEPOS(Icla.Command.MoveAbsolute) THEN 
		iAbsoluteMovementOrders := iAbsoluteMovementOrders + 1;
		//Defining starting direction of the movement
		IF Icla.Parameter.MoveAbsolute.Position > Icla.Status.iActualPosition + 1 THEN //Adding safety to avoid loop
			ncAbsMov := ncPOS_MOVE;
		ELSIF Icla.Parameter.MoveAbsolute.Position < Icla.Status.iActualPosition -1 THEN //Adding safety to avoid loop
			ncAbsMov := ncNEG_MOVE;
		ELSE
			Icla.Command.MoveAbsolute:=FALSE;
		END_IF
	END_IF
	IF (ncAbsMov = ncPOS_MOVE OR ncAbsMov = ncNEG_MOVE) AND Icla.Command.Stop THEN
		ncAbsMov := ncHALT_OK;
		Icla.Command.MoveAbsolute:=FALSE;
		Icla.Command.Stop:=FALSE;
		rSpeed := 0;
	END_IF
	
	//Return the speed depending on the state
	IF Icla.Command.JogForward THEN
		Icla.Status.IclaStatus:= AXISILE_JOG;
		IF Icla.Command.JogFastSpeed THEN
			Icla.Status.iActualVelocity := Icla.Parameter.Jog.VeloFast;
		ELSE
			Icla.Status.iActualVelocity := Icla.Parameter.Jog.VeloSlow;
		END_IF
	ELSIF Icla.Command.JogBackward THEN
		Icla.Status.IclaStatus:= AXISILE_JOG;
		IF Icla.Command.JogFastSpeed THEN
			Icla.Status.iActualVelocity := -Icla.Parameter.Jog.VeloFast;
		ELSE
			Icla.Status.iActualVelocity := -Icla.Parameter.Jog.VeloSlow;
		END_IF
	ELSIF (ncAbsMov = ncPOS_MOVE OR ncAbsMov = ncNEG_MOVE) THEN
		Icla.Status.IclaStatus:= AXISILE_MOVE_ABSOLUTE;
		Icla.Status.iActualVelocity:=Icla.Parameter.MoveAbsolute.Velocity;
	ELSE
		Icla.Status.IclaStatus:= AXISILE_READY;
		Icla.Status.iActualVelocity:=0;
	END_IF
	
	Icla.Status.xInPosition:= NOT Icla.Command.JogBackward AND NOT Icla.Command.JogForward AND (ncAbsMov = ncHALT_OK);
	
	Icla.Status.xModuleOK:=TRUE;
	
	IF Icla.Status.IclaStatus <> AXISILE_ERROR THEN
		Icla.Status.iDriveStatus := ICLAST_ENABLE_OPERATION;
	END_IF
	
	tiLastExec := clock_ms();
	
	iIclaSimIndex := iIclaSimIndex + 1;
	
END_PROGRAM
