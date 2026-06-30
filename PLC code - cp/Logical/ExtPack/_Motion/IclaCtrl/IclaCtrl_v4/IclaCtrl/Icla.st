(*********************************************************************************
 * Copyright: Bernecker + Rainer
 * Author:		jorgemur
 * Created:		January 19, 2019
 * Version:		3.00.0
 * Description:	This task allows TO control an ICLA IFE motor through CANopen
				Manual movement, homing procedure, and MOVE absolute movements are
				implemented.
 *********************************************************************************)

PROGRAM _INIT
	StepIcla :=	AXISILE_INIT;
	StepComs := COMSILE_IDLE;
	xJogPauseSent:=FALSE;
	iPrevAcceleration:=2500;	//Defaul value in Icla. Just send the acceleration if it is changed by program
	iPrevVeloSlow:=300;			//Defaul value in Icla. Just send the acceleration if it is changed by program
	iPrevVeloFast:=1000;		//Defaul value in Icla. Just send the acceleration if it is changed by program
END_PROGRAM

PROGRAM _CYCLIC

	
	//IMPORTANT: When adding an ILE/ICLA motor on physical view. Copy and paste an existing one to get the device parameters required to get the motor enabled for operation
	Icla ACCESS ADR(gIcla[gIndexIcla]);
	PDO4 ACCESS ADR(gIclaNetData[gIndexIcla]);
	
	//Check drive status
	Icla.Status.iDriveStatus 		:= PDO4.TPDO4.driveStat AND 2#1111;
	Icla.Status.xReferenced 		:= PDO4.TPDO4.modeStat.5;
	Icla.Status.iActualPosition		:= PDO4.TPDO4.Act32;
	PDO4.RPDO4.driveCtrl.3 			:= Icla.Command.Reset;
	Icla.Status.xInPosition 		:= PDO4.TPDO4.driveStat.14;
	Icla.Status.xModuleOK			:= PDO4.xModuleOK;
	
	//Check communication status
	Icla.Status.Error.Communication := NOT Icla.Status.xModuleOK;
	
	//Limitation of the accepted values
	Icla.Parameter.Jog.VeloSlow 		 := LIMIT(300, Icla.Parameter.Jog.VeloSlow, 5000);
	Icla.Parameter.Jog.VeloFast 		 :=	LIMIT(300, Icla.Parameter.Jog.VeloFast, 5000);
	Icla.Parameter.MoveAbsolute.Velocity := LIMIT(300, Icla.Parameter.MoveAbsolute.Velocity, 5000);
	Icla.Parameter.iAcceleration 		 := LIMIT(1000, Icla.Parameter.iAcceleration, 10000);

	//	Start OF referencing mode action object: Write ACCESS triggers reference movement from
	//		1: LIMP
	//		2: LIMN
	//		3: REF neg. direction OF rotation
	//		4: REF pos. direction OF rotation
	//		7: Blocking movement neg. sense OF rotation
	//		8: Blocking movement pos. sense OF rotation
	//	Icla.Parameter.Home.Mode = LIMIT(0,Icla.Parameter.Home.Mode,8)
	//	IF Icla.Parameter.Home.Mode = 5 OR Icla.Parameter.Home.Mode = 6 THEN
	//		Icla.Parameter.Home.Mode = :=0;
	//	END_IF
	
	
	CASE StepIcla OF
		
		AXISILE_INIT:

			IF iPrevAcceleration = Icla.Parameter.iAcceleration AND
				iPrevVeloSlow = Icla.Parameter.Jog.VeloSlow AND
				(iPrevVeloFast = Icla.Parameter.Jog.VeloFast OR NOT Icla.Command.JogFastSpeed)AND 
				xJogPauseSent 										THEN
				StepIcla := AXISILE_WAIT_READY_TO_SWITCH_ON;
			END_IF


		AXISILE_WAIT_READY_TO_SWITCH_ON:	
			Icla.Status.Info := 'Waiting for enable input';
			//Reset commands
			Icla.Command.Home := FALSE;
			Icla.Command.MoveAbsolute := FALSE;
			Icla.Command.JogBackward := FALSE;
			Icla.Command.JogForward := FALSE;
			Icla.Command.JogFastSpeed := FALSE;
			Icla.Command.Stop := FALSE;
			Icla.Command.Reset := FALSE;
			
			//Reset mode
			PDO4.RPDO4.modeCtrl := 0;
			
			PDO4.RPDO4.driveCtrl.0 := TRUE;//Disable Power
			PDO4.RPDO4.driveCtrl.1 := FALSE;//Enable Power
			
			IF Icla.Status.iDriveStatus = 3  THEN
				PDO4.RPDO4.driveCtrl.0 := TRUE;//Disable Power
				PDO4.RPDO4.driveCtrl.1 := FALSE;//Enable Power
				//TOJMH: Review 4 & 6 or just 4 (And 6 for AXISILE_READY)
			ELSIF Icla.Status.iDriveStatus = 4 OR Icla.Status.iDriveStatus = 6 THEN
				StepIcla := AXISILE_WAIT;
				//TOJMH: Review when QuickStop appears
			ELSIF Icla.Status.iDriveStatus = 7 THEN	//Go out of state 7 (quick stop)
				Icla.Command.Reset := TRUE;
			END_IF
			
			//Toggle to send data
			PDO4.RPDO4.modeCtrl.7	:= NOT PDO4.TPDO4.modeStat.7;


		AXISILE_WAIT:
			Icla.Status.Info := 'Waiting for enable command';
			//Reset commands
			Icla.Command.Home := FALSE;
			Icla.Command.MoveAbsolute := FALSE;
			Icla.Command.JogBackward := FALSE;
			Icla.Command.JogForward := FALSE;
			Icla.Command.JogFastSpeed := FALSE;
			Icla.Command.Stop := FALSE;
			
			//Reset mode
			PDO4.RPDO4.modeCtrl := 0;
			
			IF Icla.Command.Enable THEN
				PDO4.RPDO4.driveCtrl.0 := FALSE;//Disable Power
				PDO4.RPDO4.driveCtrl.1 := TRUE;//Enable Power
			ELSE
				PDO4.RPDO4.driveCtrl.0 := TRUE;//Disable Power
				PDO4.RPDO4.driveCtrl.1 := FALSE;//Enable Power
			END_IF;
			IF Icla.Command.Enable AND Icla.Status.iDriveStatus = ICLAST_ENABLE_OPERATION  THEN
				StepIcla := AXISILE_POWER;
			ELSIF Icla.Status.iDriveStatus = 3  THEN
				StepIcla := AXISILE_WAIT_READY_TO_SWITCH_ON;
			ELSIF Icla.Status.iDriveStatus = 7 THEN	//Go out of state 7 (quick stop)
				Icla.Command.Reset := TRUE;
				Icla.Command.Enable := FALSE; //Due to issue DELOREAN-746
			END_IF;
			
			//Toggle to send data
			PDO4.RPDO4.modeCtrl.7	:= NOT PDO4.TPDO4.modeStat.7;


		AXISILE_POWER:
			Icla.Status.Info := 'Waiting for power on';
			//Reset commands

			//Reset commands
			Icla.Command.MoveAbsolute := FALSE;
			Icla.Command.Reset := FALSE;
			Icla.Command.Stop := FALSE;
			
			
			IF NOT Icla.Command.Enable THEN
				PDO4.RPDO4.driveCtrl.0 := TRUE;//Disable Power
				PDO4.RPDO4.driveCtrl.1 := FALSE;//Enable Power
				StepIcla :=AXISILE_WAIT_READY_TO_SWITCH_ON;
			END_IF;
			
			
			IF Icla.Status.xReferenced THEN		
				StepIcla := AXISILE_READY;
			END_IF
			
			IF Icla.Command.Home  THEN
				IF NOT Icla.Status.xReferenced THEN
					StepIcla := AXISILE_HOMING;
				END_IF;	
			ELSIF Icla.Command.JogBackward OR Icla.Command.JogForward THEN
				StepIcla := AXISILE_JOG;
			END_IF;
			
			//Toggle to send data
			PDO4.RPDO4.modeCtrl.7	:= NOT PDO4.TPDO4.modeStat.7;


		AXISILE_HOMING:
			
			//Reset commands
			//Icla.Command.Enable := TRUE;
			Icla.Command.Home := FALSE;
			Icla.Command.MoveAbsolute := FALSE;
			Icla.Command.JogBackward := FALSE;
			Icla.Command.JogForward := FALSE;
			Icla.Command.JogFastSpeed := FALSE;
			Icla.Command.Reset := FALSE;
			Icla.Command.Stop := FALSE;
				
			//Mode = 2, HOMING
			PDO4.RPDO4.modeCtrl.2	:= FALSE;
			PDO4.RPDO4.modeCtrl.1	:= TRUE;
			PDO4.RPDO4.modeCtrl.0	:= FALSE;
			
			//Action = 0, DIMENSION SETTING
			IF Icla.Parameter.Home.Mode = 0 THEN	//Dimension setting
				PDO4.RPDO4.modeCtrl.6	:= FALSE;
				PDO4.RPDO4.modeCtrl.5	:= FALSE;
				PDO4.RPDO4.modeCtrl.4	:= FALSE;
				PDO4.RPDO4.Ref32 		:= Icla.Parameter.Home.Position;
			ELSE
				PDO4.RPDO4.modeCtrl.6	:= FALSE;
				PDO4.RPDO4.modeCtrl.5	:= FALSE;
				PDO4.RPDO4.modeCtrl.4	:= TRUE;
				PDO4.RPDO4.Ref16 		:= Icla.Parameter.Home.Mode;
			END_IF;
			(* Start of referencing mode action object: Write ACCESS triggers reference movement from
				1: LIMP
				2: LIMN
				3: REF neg. direction OF rotation
				4: REF pos. direction OF rotation
				7: Blocking movement neg. sense OF rotation
				8: Blocking movement pos. sense OF rotation 
			*)

			//Check if Referenced is done. Prior to send data
			IF Icla.Status.xReferenced AND EDGE(PDO4.TPDO4.modeStat.7) THEN
				StepIcla := AXISILE_READY;
			END_IF; 

			//Toggle to send data
			PDO4.RPDO4.modeCtrl.7	:= NOT PDO4.TPDO4.modeStat.7;


		AXISILE_READY:
			//Reset commands
			Icla.Command.Stop := FALSE;
			Icla.Status.Info := 'Ready to perform movements';
			IF Icla.Command.JogBackward OR Icla.Command.JogForward THEN
				Icla.Status.xInPosition := FALSE;
				StepIcla := AXISILE_JOG;
				uiCountJogOrders:=uiCountJogOrders+1;
			ELSIF Icla.Command.MoveAbsolute THEN
				IF Icla.Status.iActualPosition <> Icla.Parameter.MoveAbsolute.Position THEN
					StepIcla := AXISILE_MOVE_ABSOLUTE;
				ELSE
					Icla.Command.MoveAbsolute := FALSE;
				END_IF;
				
			ELSIF NOT Icla.Command.Enable THEN
				Icla.Status.xInPosition := FALSE;
				StepIcla := AXISILE_WAIT_READY_TO_SWITCH_ON;
			ELSIF Icla.Command.Home THEN
				Icla.Status.xInPosition := FALSE;
				StepIcla := AXISILE_HOMING;
			END_IF;


		AXISILE_JOG:
			Icla.Status.Info := 'Jogging';
			//Reset commands
			//Icla.Command.Enable := TRUE;
			Icla.Command.MoveAbsolute := FALSE;
			Icla.Command.Home := FALSE;
			Icla.Command.Reset := FALSE;
			
			PDO4.RPDO4.modeCtrl := 1;	//Manual mode
			
			IF Icla.Command.JogBackward AND Icla.Command.JogForward THEN
				Icla.Command.JogBackward := FALSE;
				Icla.Command.JogForward  := FALSE;
			END_IF;
			//Jog negative
			IF Icla.Command.JogBackward THEN	
				Icla.Command.JogForward := FALSE;
				PDO4.RPDO4.Ref16.0 := FALSE;
				PDO4.RPDO4.Ref16.1 := TRUE;
				PDO4.RPDO4.Ref16.2 := Icla.Command.JogFastSpeed;
			END_IF
			//Jog positive
			IF Icla.Command.JogForward THEN	
				Icla.Command.JogBackward := FALSE;
				PDO4.RPDO4.Ref16.0 := TRUE;
				PDO4.RPDO4.Ref16.1 := FALSE;
				PDO4.RPDO4.Ref16.2 := Icla.Command.JogFastSpeed;				
			END_IF;
			IF NOT Icla.Command.JogBackward AND NOT Icla.Command.JogForward THEN
				PDO4.RPDO4.Ref16.0 := FALSE;
				PDO4.RPDO4.Ref16.1 := FALSE;
				PDO4.RPDO4.Ref16.2 := FALSE;
				IF Icla.Status.iActualVelocity=0 THEN
					StepIcla := AXISILE_WAIT_READY_TO_SWITCH_ON;
				END_IF
				iOutJogNoOrder:=iOutJogNoOrder+1;
			END_IF;
			//Send Quick-Stop command
			IF Icla.Command.Stop THEN		
				Icla.Command.JogBackward	:= FALSE;
				Icla.Command.JogForward	:= FALSE;
				PDO4.RPDO4.Ref16.0			:= FALSE;
				PDO4.RPDO4.Ref16.1			:= FALSE;
				PDO4.RPDO4.Ref16.2			:= FALSE;
				PDO4.RPDO4.driveCtrl.2		:= TRUE;//QuickStop
				StepIcla := AXISILE_WAIT_READY_TO_SWITCH_ON;
				iOutJogOrderStop:=iOutJogOrderStop+1;
			END_IF
			//Toggle to send data
			PDO4.RPDO4.modeCtrl.7	:= NOT 	PDO4.TPDO4.modeStat.7;


		AXISILE_MOVE_ABSOLUTE:
			IF Icla.Parameter.MoveAbsolute.Velocity = 0 THEN
				Icla.Status.Info := 'WARNING: set speed is 0, please change it';
			ELSE
				Icla.Status.Info := 'Moving to set position';
			END_IF;
		
			//Reset commands
			//Icla.Command.Enable := TRUE;
			Icla.Command.Home := FALSE;
			Icla.Command.JogBackward := FALSE;
			Icla.Command.JogForward := FALSE;
			Icla.Command.JogFastSpeed := FALSE;
			Icla.Command.MoveAbsolute := TRUE;

			
			//Setpoint Speed
			PDO4.RPDO4.Ref16 := Icla.Parameter.MoveAbsolute.Velocity;
			//Setpoint Position
			PDO4.RPDO4.Ref32 := Icla.Parameter.MoveAbsolute.Position;
			
			//Mode = 3, PTP
			PDO4.RPDO4.modeCtrl.2	:= FALSE;
			PDO4.RPDO4.modeCtrl.1	:= TRUE;
			PDO4.RPDO4.modeCtrl.0	:= TRUE;
		
			//Action = 0, ABSOLUTE POSITIONING
			PDO4.RPDO4.modeCtrl.6	:= FALSE;
			PDO4.RPDO4.modeCtrl.5	:= FALSE;
			PDO4.RPDO4.modeCtrl.4	:= FALSE;
			
			//Toggle to send data
			PDO4.RPDO4.modeCtrl.7	:= NOT 	PDO4.TPDO4.modeStat.7;
			
			//Rising edge in InPosition to jump to READY
			IF Icla.Status.xInPosition AND NOT xOldInPosition THEN
				StepIcla := AXISILE_WAIT;
			END_IF
			
			IF NOT Icla.Command.Enable THEN
				Icla.Status.xInPosition := FALSE;
				StepIcla := AXISILE_WAIT_READY_TO_SWITCH_ON;
			END_IF
			
			IF Icla.Command.Stop THEN		//Send Quick-Stop command
				Icla.Command.JogBackward	:= FALSE;
				Icla.Command.JogForward	:= FALSE;
				PDO4.RPDO4.Ref16.0			:= FALSE;
				PDO4.RPDO4.Ref16.1			:= FALSE;
				PDO4.RPDO4.Ref16.2			:= FALSE;
				PDO4.RPDO4.driveCtrl.2		:= TRUE;//QuickStop
				StepIcla := AXISILE_WAIT_READY_TO_SWITCH_ON;
			END_IF


		AXISILE_ERROR:

			IF Icla.Status.Info <> 'ERROR transfering Jog parameters' THEN
				Icla.Status.Info := 'ERROR';
			END_IF;
			//Reset commands
			Icla.Command.Enable := FALSE;
			Icla.Command.Home := FALSE;
			Icla.Command.MoveAbsolute := FALSE;
			Icla.Command.JogBackward := FALSE;
			Icla.Command.JogForward := FALSE;
			Icla.Command.JogFastSpeed := FALSE;
			Icla.Command.Stop := FALSE;
			
			//Reseting errors
			PDO4.RPDO4.driveCtrl.3 := Icla.Command.Reset;

			IF Icla.Command.Reset (*AND Icla.Status.iDriveStatus <> ICLAST_ERROR*) THEN
				Icla.Status.Error.Jog := FALSE;
				Icla.Status.Error.ErrorNumber := 0;
				StepIcla := AXISILE_WAIT_READY_TO_SWITCH_ON;
			END_IF
		
	END_CASE
	
	ResetComms;
	
	xReadSpeed := Icla.Status.iActualVelocity<>0; // AND NOT Icla.Status.xInError;

	IclaSDO;
	
	//ERROR handling
	IF StepIcla <> AXISILE_INIT AND (EDGEPOS(Icla.Status.iDriveStatus = ICLAST_ERROR) OR Icla.Status.Error.Communication OR Icla.Status.Error.Jog) THEN
		StepIcla := AXISILE_ERROR;
	END_IF

	Icla.Status.xInError := StepIcla = AXISILE_ERROR;
	
	//Icla state story
	IF StepIcla<>StateHistory[0] THEN
		FOR iIndexHistory:=iHistoryLines TO 1 BY -1 DO 
			StateHistory[iIndexHistory]:=StateHistory[iIndexHistory-1];
		END_FOR
		StateHistory[0]:=StepIcla;
	END_IF
	
	xOldInPosition := Icla.Status.xInPosition;	


	Icla.Status.IclaStatus:=StepIcla;
	Icla.Status.IclaSDOStep:=StepComs;
	
	// After all tasks, incr and sanity check
	gIndexIcla := gIndexIcla + 1;	

	
END_PROGRAM

