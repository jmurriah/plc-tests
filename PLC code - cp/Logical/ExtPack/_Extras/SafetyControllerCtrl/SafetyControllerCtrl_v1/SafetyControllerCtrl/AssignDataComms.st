
ACTION AssignDataComms:
	
	//Active modbus slave diagnosis when module ok (cable plugged). To set to false just unplug de cable
	IF SafetyController.Status.Comms.xModuleOk THEN
		SafetyController.Parameters.xActiveSlaveDiagnosis := TRUE; //1: Diagnosis enabled; 0=Reset diagnosis historic
	END_IF
	
	
	//Pre bits treatment
	
	//Write Registers
	
	//Read Registers
	IF SafetyController.Status.Comms.xModuleOk THEN
		
		SafetyController.Inputs.Comms.FieldbusProbeStatus := DataFromSafety[11];
		
		IF NOT SafetyController.Parameters.xSimulationMode THEN
			//Software version
			SafetyController.Status.Version.0 := SafetyController.Inputs.Comms.FieldbusProbeStatus.0;
			SafetyController.Status.Version.1 := SafetyController.Inputs.Comms.FieldbusProbeStatus.1;
			SafetyController.Status.Version.2 := SafetyController.Inputs.Comms.FieldbusProbeStatus.2;
		END_IF
		
		CASE gMachine.Pt.ConfigNameID OF
			GC_CONFIG_1BK8BAR_NOZ2_ID:
				CASE SafetyController.Status.Version OF
					1: SafetyController.Status.Type := SAFETYCONTROLLERTY_DEFAULT;
					2: SafetyController.Status.Type := SAFETYCONTROLLERTY_DEFAULT;
					3: SafetyController.Status.Type := SAFETYCONTROLLERTY_CUBE_ALPHA;
					4: SafetyController.Status.Type := SAFETYCONTROLLERTY_SD;
						
					ELSE SafetyController.Status.Type := SAFETYCONTROLLERTY_UNDEFINED;
				END_CASE
				
			GC_CONFIG_1BK8BAR_NOZ2_AQ_ID:
				CASE SafetyController.Status.Version OF
					1: SafetyController.Status.Type := SAFETYCONTROLLERTY_NOZ2_AQ;
						
					ELSE SafetyController.Status.Type := SAFETYCONTROLLERTY_UNDEFINED;
				END_CASE
				
			GC_CONFIG_1BK7BAR_CUBE_ID:
				//To uncomment this code when first release that supports CUBE will be launched. So we will be sure safety controller version matches properly
				CASE SafetyController.Status.Version OF
					1: SafetyController.Status.Type := SAFETYCONTROLLERTY_CUBE;
						
					ELSE SafetyController.Status.Type := SAFETYCONTROLLERTY_UNDEFINED;
				END_CASE
							
			GC_CONFIG_1BK10BAR_MECANO_ID:
				//To uncomment this code when first release that supports CUBE will be launched. So we will be sure safety controller version matches properly
				CASE SafetyController.Status.Version OF
					1: SafetyController.Status.Type := SAFETYCONTROLLERTY_MECANO;
						
					ELSE SafetyController.Status.Type := SAFETYCONTROLLERTY_UNDEFINED;
				END_CASE
			
			GC_CONFIG_SIMTEST_ID:
				CASE gMachine.Pt.MachineModel OF
					Type_NOZ_2_AQ:
						SafetyController.Status.Type := SAFETYCONTROLLERTY_NOZ2_AQ;

					Type_NOZ_2_UV,
					Type_NOZ_2_UV_White: 
						SafetyController.Status.Type := SAFETYCONTROLLERTY_DEFAULT;
					
					Type_CUBE,
					Type_CUBE_INSPECTION,
					Type_CUBE_GULLIVER,
					Type_CUBE_GULLIVER_INSPECTION: 
						SafetyController.Status.Type := SAFETYCONTROLLERTY_CUBE;
						
					Type_MECANO_UV_WHITE,
					Type_MECANO_UV_OPV,
					Type_MECANO_UV_WHITE_OPV:	
						SafetyController.Status.Type := SAFETYCONTROLLERTY_MECANO;
						
					ELSE SafetyController.Status.Type := SAFETYCONTROLLERTY_UNDEFINED;
				END_CASE
			
		END_CASE
		
		IF NOT SafetyController.Parameters.xSimulationMode THEN
			CASE SafetyController.Status.Type OF
				//Cube machine
				SAFETYCONTROLLERTY_CUBE:
					SafetyController.Inputs.Comms.SystemStatus := UINT_TO_USINT(DataFromSafety[0] AND 16#00FF);
					SafetyController.Inputs.Comms.ExpansionModule[0] := UINT_TO_USINT(DataFromSafety[1] AND 16#00FF); 			// CP0802
					SafetyController.Inputs.Comms.ExpansionModule[1] := UINT_TO_USINT(SHR((DataFromSafety[1] AND 16#FF00),8)); 	//DI16-0
					SafetyController.Inputs.Comms.ExpansionModule[2] := UINT_TO_USINT(DataFromSafety[2] AND 16#00FF);			//R04-0
					
					
					//Fieldbus probe
					//Inputs
					SafetyController.Inputs.xPrinterRearDoorSwitch := SafetyController.Inputs.Comms.FieldbusProbeStatus.3;
					SafetyController.Inputs.xPrinterMaintenanceKey := SafetyController.Inputs.Comms.FieldbusProbeStatus.4;
					SafetyController.Inputs.xHmiSwitch := SafetyController.Inputs.Comms.FieldbusProbeStatus.5;
					SafetyController.Inputs.xPrinterFrontDoorSwitch := SafetyController.Inputs.Comms.FieldbusProbeStatus.6;
					SafetyController.Inputs.xPrinterBacksideEstop := SafetyController.Inputs.Comms.FieldbusProbeStatus.7;
					SafetyController.Inputs.xPrinterFrontsideEstop := SafetyController.Inputs.Comms.FieldbusProbeStatus.8;
					SafetyController.Inputs.xX5Consent := SafetyController.Inputs.Comms.FieldbusProbeStatus.9;
					SafetyController.Inputs.xFanDoorSwitch := SafetyController.Inputs.Comms.FieldbusProbeStatus.12;
					
					//Outputs				
					SafetyController.Outputs.xEnablePrinter1 := SafetyController.Inputs.Comms.FieldbusProbeStatus.11; //Revisar por qué esta asignación no funciona bien
					SafetyController.Outputs.xPrinterToX5 := SafetyController.Inputs.Comms.FieldbusProbeStatus.11;
					
				SAFETYCONTROLLERTY_DEFAULT,
				SAFETYCONTROLLERTY_CUBE_ALPHA,
				SAFETYCONTROLLERTY_SD:
					SafetyController.Inputs.Comms.SystemStatus := UINT_TO_USINT(DataFromSafety[0] AND 16#00FF);
					SafetyController.Inputs.Comms.ExpansionModule[0] := UINT_TO_USINT(DataFromSafety[1] AND 16#00FF);			// CP0802
					SafetyController.Inputs.Comms.ExpansionModule[1] := UINT_TO_USINT(SHR((DataFromSafety[1] AND 16#FF00),8));	//MX0802
					SafetyController.Inputs.Comms.ExpansionModule[2] := UINT_TO_USINT(DataFromSafety[2] AND 16#00FF);			//DI16-0
					SafetyController.Inputs.Comms.ExpansionModule[3] := UINT_TO_USINT(SHR((DataFromSafety[2] AND 16#FF00),8));	//DI16-1
					SafetyController.Inputs.Comms.ExpansionModule[4] := UINT_TO_USINT(DataFromSafety[3] AND 16#00FF);			//R04-0
					SafetyController.Inputs.Comms.ExpansionModule[5] := UINT_TO_USINT(SHR((DataFromSafety[3] AND 16#FF00),8));	//R04-1
					SafetyController.Inputs.Comms.ExpansionModule[6] := UINT_TO_USINT(DataFromSafety[4] AND 16#00FF);			//R04-2
				
					//SafetyController.Inputs.Comms.FieldbusProbeStatus := DataFromSafety[11];
					SafetyController.Inputs.Comms.OSSDStatus := DataFromSafety[13];
					SafetyController.Inputs.Comms.DiagnosticCode := DataFromSafety[14];
			
					
					//Post bit treatment
					//Fieldbus: Currently there is no need to acknowledge fiedlbus inputs set in SoSafe program so info coming from inputs is enough
					
					//Modules physical inputs
					//Ancillaries
					SafetyController.Inputs.xFeederEstop			:= SafetyController.Inputs.Comms.FieldbusProbeStatus.8; //SafetyController.Inputs.Comms.ExpansionModule[1].0;
					SafetyController.Inputs.xPrimerEstop 			:= SafetyController.Inputs.Comms.FieldbusProbeStatus.9; //SafetyController.Inputs.Comms.ExpansionModule[1].2;
					SafetyController.Inputs.xOvervarnishEstop 		:= SafetyController.Inputs.Comms.FieldbusProbeStatus.14; //SafetyController.Inputs.Comms.ExpansionModule[2].4;
					SafetyController.Inputs.xStackerEstop 			:= SafetyController.Inputs.Comms.FieldbusProbeStatus.15; //SafetyController.Inputs.Comms.ExpansionModule[2].0;
					SafetyController.Inputs.xSarmEstop				:= SafetyController.Inputs.Comms.FieldbusProbeStatus.7;
					
					//Dryer
					SafetyController.Inputs.xDryerBacksideEstop 	:= SafetyController.Inputs.Comms.FieldbusProbeStatus.12; //SafetyController.Inputs.Comms.ExpansionModule[1].4;
					SafetyController.Inputs.xDryerFrontsideEstop 	:= SafetyController.Inputs.Comms.FieldbusProbeStatus.13; //SafetyController.Inputs.Comms.ExpansionModule[1].6;
					SafetyController.Inputs.xDryerFrontDoorSwitch1	:= SafetyController.Inputs.Comms.FieldbusProbeStatus.3; //SafetyController.Inputs.Comms.ExpansionModule[2].6;
					SafetyController.Inputs.xDryerFrontDoorSwitch2	:= SafetyController.Inputs.Comms.FieldbusProbeStatus.4; //SafetyController.Inputs.Comms.ExpansionModule[3].4;
					SafetyController.Inputs.xDryerBackDoorSwitch1	:= SafetyController.Inputs.Comms.FieldbusProbeStatus.5; //SafetyController.Inputs.Comms.ExpansionModule[3].6;
					SafetyController.Inputs.xDryerBackDoorSwitch2	:= SafetyController.Inputs.Comms.FieldbusProbeStatus.6; //SafetyController.Inputs.Comms.ExpansionModule[4].0;
					SafetyController.Inputs.xDryerMaintenanceKey	:= SafetyController.Inputs.Comms.ExpansionModule[4].3;
					SafetyController.Inputs.xDryerBlowersEnable		:= SafetyController.Inputs.Comms.ExpansionModule[2].3;
					
					//Printer
					SafetyController.Inputs.xPrinterMaintenanceKey 	:= SafetyController.Inputs.Comms.ExpansionModule[4].2;
					SafetyController.Inputs.xPrinterBlowersEnable	:= SafetyController.Inputs.Comms.ExpansionModule[2].2;
					SafetyController.Inputs.xPrinterBlowersSwitch	:= TRUE; //SafetyController.Inputs.Comms.FieldbusProbeStatus.2;
					SafetyController.Inputs.xPrinterLightCurtain 	:= SafetyController.Inputs.Comms.ExpansionModule[0].0;
					SafetyController.Inputs.xPrinterDoorLock 		:= SafetyController.Inputs.Comms.ExpansionModule[0].2;
					SafetyController.Inputs.xPrinterBacksideEstop 	:= SafetyController.Inputs.Comms.FieldbusProbeStatus.10;
					SafetyController.Inputs.xPrinterFrontsideEstop 	:= SafetyController.Inputs.Comms.FieldbusProbeStatus.11;
					
					//OSSD Outputs
					SafetyController.Outputs.xEnablePrinter1 := SafetyController.Inputs.Comms.OSSDStatus.0;
					//SafetyController.Outputs.xEnablePrinter2 := SafetyController.Inputs.Comms.OSSDStatus.1;
					SafetyController.Outputs.xEnablePrinterBlowers1 := SafetyController.Inputs.Comms.OSSDStatus.1;
					//SafetyController.Outputs.xEnablePrinterBlowers2	:= SafetyController.Inputs.Comms.OSSDStatus.3;
					SafetyController.Outputs.xEnableDryer1	:= SafetyController.Inputs.Comms.OSSDStatus.2;
					//SafetyController.Outputs.xEnableDryer2	:= SafetyController.Inputs.Comms.OSSDStatus.5;
			
					
				SAFETYCONTROLLERTY_MECANO:
					SafetyController.Inputs.Comms.SystemStatus := UINT_TO_USINT(DataFromSafety[0] AND 16#00FF);
					SafetyController.Inputs.Comms.ExpansionModule[0] := UINT_TO_USINT(DataFromSafety[1] AND 16#00FF);			// CP0802
					SafetyController.Inputs.Comms.ExpansionModule[1] := UINT_TO_USINT(SHR((DataFromSafety[1] AND 16#FF00),8));	//MX0802
					SafetyController.Inputs.Comms.ExpansionModule[2] := UINT_TO_USINT(DataFromSafety[2] AND 16#00FF);			//DI16-0
					SafetyController.Inputs.Comms.ExpansionModule[3] := UINT_TO_USINT(SHR((DataFromSafety[2] AND 16#FF00),8));	//DI16-1
					SafetyController.Inputs.Comms.ExpansionModule[4] := UINT_TO_USINT(DataFromSafety[3] AND 16#00FF);			//R04-0
					SafetyController.Inputs.Comms.ExpansionModule[5] := UINT_TO_USINT(SHR((DataFromSafety[3] AND 16#FF00),8));	//R04-1
					SafetyController.Inputs.Comms.ExpansionModule[6] := UINT_TO_USINT(DataFromSafety[4] AND 16#00FF);			//R04-2
				
					//SafetyController.Inputs.Comms.FieldbusProbeStatus := DataFromSafety[11];
					SafetyController.Inputs.Comms.OSSDStatus := DataFromSafety[13];
					SafetyController.Inputs.Comms.DiagnosticCode := DataFromSafety[14];
			
					
					//Post bit treatment				
					//Modules physical inputs
					//Ancillaries
					SafetyController.Inputs.xFeederEstop			:= SafetyController.Inputs.Comms.FieldbusProbeStatus.8;
					SafetyController.Inputs.xPrimerEstop 			:= SafetyController.Inputs.Comms.FieldbusProbeStatus.9;
					SafetyController.Inputs.xOvervarnishEstop 		:= SafetyController.Inputs.Comms.FieldbusProbeStatus.14;
					SafetyController.Inputs.xStackerEstop 			:= SafetyController.Inputs.Comms.FieldbusProbeStatus.15;
					SafetyController.Inputs.xSarmEstop				:= SafetyController.Inputs.Comms.FieldbusProbeStatus.7;
					
					//Printer
					SafetyController.Inputs.xPrinterMaintenanceKey 	:= SafetyController.Inputs.Comms.FieldbusProbeStatus.5;
					SafetyController.Inputs.xPrinterBlowersEnable	:= SafetyController.Inputs.Comms.ExpansionModule[2].2;
					SafetyController.Inputs.xPrinterBlowersSwitch	:= SafetyController.Inputs.Comms.FieldbusProbeStatus.6;
					SafetyController.Inputs.xPrinterLightCurtain 	:= SafetyController.Inputs.Comms.FieldbusProbeStatus.3;
					SafetyController.Inputs.xPrinterDoorLock 		:= SafetyController.Inputs.Comms.FieldbusProbeStatus.4;
					SafetyController.Inputs.xPrinterBacksideEstop 	:= SafetyController.Inputs.Comms.FieldbusProbeStatus.10;
					SafetyController.Inputs.xPrinterFrontsideEstop 	:= SafetyController.Inputs.Comms.FieldbusProbeStatus.11;
					
					//OSSD Outputs
					SafetyController.Outputs.xEnablePrinter1 		:= SafetyController.Inputs.Comms.OSSDStatus.0;
					SafetyController.Outputs.xEnablePrinterBlowers1 := SafetyController.Inputs.Comms.OSSDStatus.1;


				SAFETYCONTROLLERTY_NOZ2_AQ:
					SafetyController.Inputs.Comms.SystemStatus := UINT_TO_USINT(DataFromSafety[0] AND 16#00FF);
					SafetyController.Inputs.Comms.ExpansionModule[0] := UINT_TO_USINT(DataFromSafety[1] AND 16#00FF);			// CP0802
					SafetyController.Inputs.Comms.ExpansionModule[1] := UINT_TO_USINT(SHR((DataFromSafety[1] AND 16#FF00),8));	//MX0802
					SafetyController.Inputs.Comms.ExpansionModule[2] := UINT_TO_USINT(DataFromSafety[2] AND 16#00FF);			//DI16-0
					SafetyController.Inputs.Comms.ExpansionModule[3] := UINT_TO_USINT(SHR((DataFromSafety[2] AND 16#FF00),8));	//DI16-1
					SafetyController.Inputs.Comms.ExpansionModule[4] := UINT_TO_USINT(DataFromSafety[3] AND 16#00FF);			//R04-0
					SafetyController.Inputs.Comms.ExpansionModule[5] := UINT_TO_USINT(SHR((DataFromSafety[3] AND 16#FF00),8));	//R04-1
					SafetyController.Inputs.Comms.ExpansionModule[6] := UINT_TO_USINT(DataFromSafety[4] AND 16#00FF);			//R04-2
				
					SafetyController.Inputs.Comms.OSSDStatus := DataFromSafety[13];
					SafetyController.Inputs.Comms.DiagnosticCode := DataFromSafety[14];
			
					
					//Post bit treatment
					//Fieldbus: Currently there is no need to acknowledge fiedlbus inputs set in SoSafe program so info coming from inputs is enough
					
					//Modules physical inputs
					//Ancillaries
					SafetyController.Inputs.xFeederEstop			:= SafetyController.Inputs.Comms.FieldbusProbeStatus.8; //SafetyController.Inputs.Comms.ExpansionModule[1].0;
					SafetyController.Inputs.xPrimerEstop 			:= SafetyController.Inputs.Comms.FieldbusProbeStatus.9; //SafetyController.Inputs.Comms.ExpansionModule[1].2;
					SafetyController.Inputs.xOvervarnishEstop 		:= SafetyController.Inputs.Comms.FieldbusProbeStatus.14; //SafetyController.Inputs.Comms.ExpansionModule[2].4;
					SafetyController.Inputs.xStackerEstop 			:= SafetyController.Inputs.Comms.FieldbusProbeStatus.15; //SafetyController.Inputs.Comms.ExpansionModule[2].0;
					
					//Dryer
					SafetyController.Inputs.xDryerBacksideEstop 	:= SafetyController.Inputs.Comms.FieldbusProbeStatus.12; //SafetyController.Inputs.Comms.ExpansionModule[1].4;
					SafetyController.Inputs.xDryerFrontsideEstop 	:= SafetyController.Inputs.Comms.FieldbusProbeStatus.13; //SafetyController.Inputs.Comms.ExpansionModule[1].6;
					SafetyController.Inputs.xDryerFrontDoorSwitch1	:= SafetyController.Inputs.Comms.FieldbusProbeStatus.3; //SafetyController.Inputs.Comms.ExpansionModule[2].6;
					SafetyController.Inputs.xDryerFrontDoorSwitch2	:= SafetyController.Inputs.Comms.FieldbusProbeStatus.4; //SafetyController.Inputs.Comms.ExpansionModule[3].4;
					SafetyController.Inputs.xDryerBackDoorSwitch1	:= SafetyController.Inputs.Comms.FieldbusProbeStatus.5; //SafetyController.Inputs.Comms.ExpansionModule[3].6;
					SafetyController.Inputs.xDryerBackDoorSwitch2	:= SafetyController.Inputs.Comms.FieldbusProbeStatus.6; //SafetyController.Inputs.Comms.ExpansionModule[4].0;
					SafetyController.Inputs.xDryerMaintenanceKey	:= SafetyController.Inputs.Comms.ExpansionModule[4].3;
					SafetyController.Inputs.xDryerBlowersEnable		:= SafetyController.Inputs.Comms.ExpansionModule[2].3;
					
					//Printer
					SafetyController.Inputs.xPrinterMaintenanceKey 	:= SafetyController.Inputs.Comms.ExpansionModule[4].2;
					SafetyController.Inputs.xPrinterBlowersEnable	:= SafetyController.Inputs.Comms.ExpansionModule[2].2;
					SafetyController.Inputs.xPrinterBlowersSwitch	:= TRUE;
					SafetyController.Inputs.xPrinterLightCurtain 	:= SafetyController.Inputs.Comms.ExpansionModule[0].0;
					SafetyController.Inputs.xPrinterDoorLock 		:= SafetyController.Inputs.Comms.ExpansionModule[0].2;
					SafetyController.Inputs.xPrinterBacksideEstop 	:= SafetyController.Inputs.Comms.FieldbusProbeStatus.10;
					SafetyController.Inputs.xPrinterFrontsideEstop 	:= SafetyController.Inputs.Comms.FieldbusProbeStatus.11;
					
					//OSSD Outputs
					SafetyController.Outputs.xEnablePrinter1 := SafetyController.Inputs.Comms.OSSDStatus.0;
					SafetyController.Outputs.xEnablePrinterBlowers1 := SafetyController.Inputs.Comms.OSSDStatus.1;
					SafetyController.Outputs.xEnableDryer1	:= SafetyController.Inputs.Comms.OSSDStatus.2;
					
				ELSE
					SafetyController.Inputs := ResetSafetyInputs;
					SafetyController.Outputs := ResetSafetyOutputs;
				
			END_CASE
		END_IF
	END_IF

	
END_ACTION
