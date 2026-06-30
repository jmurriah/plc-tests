
ACTION IclaSDO: 

	// COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS 
	// COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS 
	// COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS COMMS 
	
	// IMPORTANT NOTE!!  && && && && && && && && && && && && && && && && && && 
	//
	// The Index to be sent in the SDO functions is in the form 16#30xx, where xx is the index in the manual in HEX code
	//
	// IMPORTANT NOTE!!  && && && && && && && && && && && && && && && && && && 
	
	
	CANopenSDOWrite8_0.enable := xEnabledWriteComs;
	CANopenSDOWrite8_0.pDevice := ADR(Icla.Parameter.Network);
	CANopenSDOWrite8_0.node := Icla.Parameter.Node;	

	CANopenSDORead8_1.pDevice := ADR(Icla.Parameter.Network);
	CANopenSDORead8_1.node := Icla.Parameter.Node;
	
	CASE StepComs OF
		COMSILE_IDLE:
			IF Icla.Parameter.Node = 255 THEN
				//Waiting to be configured or errors removed
			ELSIF StepIcla = AXISILE_JOG OR StepIcla = AXISILE_MOVE_ABSOLUTE OR xReadSpeed THEN
				StepComs := COMSILE_READ_SPEED;
//			ELSIF StepIcla=AXISILE_ERROR THEN
//				StepComs := COMSILE_ERROR;
			ELSIF StepIcla <> AXISILE_ERROR AND StepComs = COMSILE_ERROR THEN
				StepComs := COMSILE_IDLE;
			ELSIF NOT xJogPauseSent THEN
				StepComs := COMSILE_JOG_PAUSE;
			ELSIF iPrevAcceleration <> Icla.Parameter.iAcceleration THEN
				StepComs := COMSILE_ACCELERATION;
			ELSIF iPrevVeloSlow <> Icla.Parameter.Jog.VeloSlow THEN
				StepComs := COMSILE_JOG_TRANSFER_SLOW;
			ELSIF (iPrevVeloFast <> Icla.Parameter.Jog.VeloFast) AND Icla.Command.JogFastSpeed THEN
				StepComs := COMSILE_JOG_TRANSFER_FAST;
			END_IF
		
		COMSILE_JOG_PAUSE:
			CANopenSDOWrite8_0.data0 := 0;
			CANopenSDOWrite8_0.data1 := 0;
			CANopenSDOWrite8_0.datalen := 2;
			CANopenSDOWrite8_0.index := 16#3029;
			CANopenSDOWrite8_0.subindex := 16#07;
			CANopenSDOWrite8_0.enable:=TRUE;
			CANopenSDOWrite8_0();
			
			IF CANopenSDOWrite8_0.status = ERR_OK THEN
				Icla.Command.Reset := TRUE;  //To avoid starting with the Icla in error state
				StepComs := COMSILE_IDLE;
				xJogPauseSent:=TRUE;
				CANopenSDOWrite8_0.enable:=FALSE;
			ELSIF CANopenSDOWrite8_0.status <> ERR_FUB_BUSY AND CANopenSDOWrite8_0.status <> ERR_FUB_ENABLE_FALSE THEN
				Icla.Status.Info := 'ERROR transfering Jog Pause parameter';
				CANopenSDOWrite8_0.enable:=FALSE;
			END_IF;
			
		COMSILE_ACCELERATION:
			CANopenSDOWrite8_0.data0 := UINT_TO_USINT(Icla.Parameter.iAcceleration AND 16#00FF);
			CANopenSDOWrite8_0.data1 := UINT_TO_USINT(SHR((Icla.Parameter.iAcceleration AND 16#FF00),8));
			CANopenSDOWrite8_0.data2 := 0;
			CANopenSDOWrite8_0.data3 := 0;
			CANopenSDOWrite8_0.datalen := 4;
			CANopenSDOWrite8_0.index := 16#301D;
			CANopenSDOWrite8_0.subindex := 16#1A;
			CANopenSDOWrite8_0.enable:=TRUE;
			CANopenSDOWrite8_0();
			
			IF CANopenSDOWrite8_0.status = ERR_OK THEN
				StepComs := COMSILE_IDLE;
				iPrevAcceleration := Icla.Parameter.iAcceleration;
				CANopenSDOWrite8_0.enable:=FALSE;
			ELSIF CANopenSDOWrite8_0.status <> ERR_FUB_BUSY AND CANopenSDOWrite8_0.status <> ERR_FUB_ENABLE_FALSE THEN
				Icla.Status.Info := 'ERROR transfering Acceleration parameter';
				CANopenSDOWrite8_0.enable:=FALSE;
			END_IF;
		
		COMSILE_JOG_TRANSFER_SLOW:
			CANopenSDOWrite8_0.data0 := UINT_TO_USINT(Icla.Parameter.Jog.VeloSlow AND 16#00FF);
			CANopenSDOWrite8_0.data1 := UINT_TO_USINT(SHR((Icla.Parameter.Jog.VeloSlow AND 16#FF00),8));	
			CANopenSDOWrite8_0.datalen := 2;
			CANopenSDOWrite8_0.index := 16#3029;
			CANopenSDOWrite8_0.subindex := 16#04;
			CANopenSDOWrite8_0.enable:=TRUE;
			CANopenSDOWrite8_0();
			
			IF CANopenSDOWrite8_0.status = ERR_OK THEN
				StepComs := COMSILE_IDLE;
				iPrevVeloSlow := Icla.Parameter.Jog.VeloSlow;
				CANopenSDOWrite8_0.enable:=FALSE;
			ELSIF CANopenSDOWrite8_0.status <> ERR_FUB_BUSY AND CANopenSDOWrite8_0.status <> ERR_FUB_ENABLE_FALSE THEN
				Icla.Status.Info := 'ERROR transfering Jog Slow Speed parameter';
				CANopenSDOWrite8_0.enable:=FALSE;
			END_IF;		

		COMSILE_JOG_TRANSFER_FAST:
			CANopenSDOWrite8_0.data0 := UINT_TO_USINT(Icla.Parameter.Jog.VeloFast AND 16#00FF);
			CANopenSDOWrite8_0.data1 := UINT_TO_USINT(SHR((Icla.Parameter.Jog.VeloFast AND 16#FF00),8));	
			CANopenSDOWrite8_0.datalen := 2;
			CANopenSDOWrite8_0.index := 16#3029;
			CANopenSDOWrite8_0.subindex := 16#05;
			CANopenSDOWrite8_0.enable:=TRUE;
			CANopenSDOWrite8_0();
			
			IF CANopenSDOWrite8_0.status = ERR_OK THEN
				StepComs := COMSILE_IDLE;
				iPrevVeloFast := Icla.Parameter.Jog.VeloFast;
				CANopenSDOWrite8_0.enable:=FALSE;
			ELSIF CANopenSDOWrite8_0.status <> ERR_FUB_BUSY AND CANopenSDOWrite8_0.status <> ERR_FUB_ENABLE_FALSE THEN
				Icla.Status.Info := 'ERROR transfering Jog Fast Speed parameter';
				CANopenSDOWrite8_0.enable:=FALSE;
			END_IF;		

		COMSILE_READ_SPEED:
			//Read motor speed
			CANopenSDORead8_1.index := 16#301F;
			CANopenSDORead8_1.subindex := 16#09;
			CANopenSDORead8_1.enable := NOT Icla.Command.Reset;
			CANopenSDORead8_1();
			Icla.Status.iActualVelocity := SHL(USINT_TO_UINT(CANopenSDORead8_1.data1),8) + USINT_TO_UINT(CANopenSDORead8_1.data0);
			IF StepIcla <> AXISILE_JOG AND StepIcla <> AXISILE_MOVE_ABSOLUTE THEN
				StepComs := COMSILE_IDLE;
				CANopenSDORead8_1.enable:=FALSE;
				CANopenSDORead8_1();
				//Icla.Status.iActualVelocity := 0;
			END_IF
				
		COMSILE_ERROR:
			//Read error number
			CANopenSDORead8_0.index := 16#3020;
			CANopenSDORead8_0.subindex := 16#07;
			CANopenSDORead8_0.enable := NOT Icla.Command.Reset;
			CANopenSDORead8_0();
			IF CANopenSDORead8_0.status = ERR_OK THEN
				Icla.Status.Error.ErrorNumber := SHL(USINT_TO_UINT(CANopenSDORead8_0.data1),8) + USINT_TO_UINT(CANopenSDORead8_0.data0);
				IF Icla.Status.Error.ErrorNumber=0 AND StepIcla <> AXISILE_ERROR THEN
					StepComs:=COMSILE_IDLE;
				END_IF
				//After communicating, leave the channel free to the next communication
				CANopenSDORead8_0.enable := FALSE;
				CANopenSDORead8_0();
			ELSIF CANopenSDORead8_0.status <> ERR_FUB_BUSY THEN
				StepComs:=COMSILE_IDLE;
				//After communicating, leave the channel free to the next communication
				CANopenSDORead8_0.enable := FALSE;
				CANopenSDORead8_0();
			END_IF;			
			
			IF Icla.Command.Reset AND Icla.Status.iDriveStatus <> ICLAST_ERROR THEN
				CANopenSDORead8_0.enable := FALSE;
				CANopenSDORead8_0();
			END_IF;		
		
	END_CASE;
	
	
	
	///////////////////////////////////////////////////////////////////////////////
	
	//Limitation of Icla.Parameter.writeRegister.TotalBytes. Just 2 and 4 are valid values
	Icla.Parameter.writeRegister.TotalBytes:= LIMIT(2, Icla.Parameter.writeRegister.TotalBytes, 4);
	IF Icla.Parameter.writeRegister.TotalBytes = 3 THEN Icla.Parameter.writeRegister.TotalBytes:=2; END_IF
	
	
	//If Comms are not in idle is because we are communicating
	IF StepComs <> COMSILE_IDLE THEN
		
		Icla.Status.readRegister.xDataOK:=FALSE;
		
		CANopenSDOWrite8_2.enable := FALSE;
		CANopenSDOWrite8_2();
		CANopenSDORead8_0.enable := FALSE;
		CANopenSDORead8_0();
		CANopenSDORead8_2.enable := FALSE;
		CANopenSDORead8_2();
		
		RETURN;
	END_IF
	
	
	CANopenSDOWrite8_2.enable := Icla.Parameter.writeRegister.WriteOrder AND NOT CANopenSDORead8_2.enable;
	CANopenSDOWrite8_2.pDevice := ADR(Icla.Parameter.Network);
	CANopenSDOWrite8_2.node := Icla.Parameter.Node;
	IF CANopenSDOWrite8_2.enable THEN
		//CANopenSDOWrite8_2.data0 := UINT_TO_USINT(uiValueToWrite AND 16#00FF);
		//CANopenSDOWrite8_2.data1 := UINT_TO_USINT(SHR((uiValueToWrite AND 16#FF00),8));	
		CANopenSDOWrite8_2.data0 := Icla.Parameter.writeRegister.data.data0;
		CANopenSDOWrite8_2.data1 := Icla.Parameter.writeRegister.data.data1;
		CANopenSDOWrite8_2.data2 := Icla.Parameter.writeRegister.data.data2;
		CANopenSDOWrite8_2.data3 := Icla.Parameter.writeRegister.data.data3;
		CANopenSDOWrite8_2.datalen := Icla.Parameter.writeRegister.TotalBytes;
		CANopenSDOWrite8_2.index := 16#3000 OR USINT_TO_UINT(Icla.Parameter.writeRegister.writeRegister.index);
		CANopenSDOWrite8_2.subindex := Icla.Parameter.writeRegister.writeRegister.subindex;
		Icla.Status.writeRegisterOK:=FALSE;
	END_IF
	CANopenSDOWrite8_2();

	IF CANopenSDOWrite8_2.status = ERR_OK THEN
		Icla.Parameter.writeRegister.WriteOrder:=FALSE;
		Icla.Status.writeRegisterOK:=TRUE;
	ELSIF CANopenSDOWrite8_2.status <> ERR_FUB_BUSY AND CANopenSDOWrite8_2.status <> ERR_FUB_ENABLE_FALSE THEN
		Icla.Status.Info := 'ERROR Writing Registers';
		Icla.Parameter.writeRegister.WriteOrder:=FALSE;
	END_IF;	

	
	CANopenSDORead8_2.enable := NOT CANopenSDORead8_0.enable AND NOT CANopenSDORead8_1.enable AND NOT CANopenSDOWrite8_0.enable AND NOT Icla.Parameter.writeRegister.WriteOrder;
	CANopenSDORead8_2.pDevice := ADR(Icla.Parameter.Network);
	CANopenSDORead8_2.node := Icla.Parameter.Node;
	CANopenSDORead8_2.index := 16#3000 OR USINT_TO_UINT(Icla.Parameter.readRegister.index);
	CANopenSDORead8_2.subindex := Icla.Parameter.readRegister.subindex;
	CANopenSDORead8_2();
	Icla.Status.readRegister.xBusy := CANopenSDORead8_2.status <> ERR_FUB_BUSY;
	IF CANopenSDORead8_2.status = ERR_OK THEN
		Icla.Status.readRegister.xDataOK:=TRUE;
		Icla.Status.readRegister.rawData.data0:=CANopenSDORead8_2.data0;
		Icla.Status.readRegister.rawData.data1:=CANopenSDORead8_2.data1;
		Icla.Status.readRegister.rawData.data2:=CANopenSDORead8_2.data2;
		Icla.Status.readRegister.rawData.data3:=CANopenSDORead8_2.data3;
		Icla.Status.readRegister.uiValue := SHL(USINT_TO_UINT(CANopenSDORead8_2.data1),8) + USINT_TO_UINT(CANopenSDORead8_2.data0);
		Icla.Status.readRegister.usiValue := CANopenSDORead8_2.data0;
	ELSIF CANopenSDORead8_2.status <> ERR_FUB_BUSY AND CANopenSDORead8_2.status <> ERR_FUB_ENABLE_FALSE THEN
		Icla.Status.Info := 'ERROR Reading Registers';
		Icla.Status.readRegister.xDataOK:=FALSE;
		Icla.Status.readRegister.rawData.data0:=0;
		Icla.Status.readRegister.rawData.data1:=0;
		Icla.Status.readRegister.rawData.data2:=0;
		Icla.Status.readRegister.rawData.data3:=0;
		Icla.Status.readRegister.uiValue := 0;
		Icla.Status.readRegister.usiValue := 0;
	END_IF;	
	
END_ACTION
