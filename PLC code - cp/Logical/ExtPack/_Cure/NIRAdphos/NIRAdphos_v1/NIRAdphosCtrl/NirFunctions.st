
(* Return Enum from INT value from comms 
NIRAdphos_ModuleState
 NIRADPM_OFF				0
 NIRADPM_STARTUP			1
 NIRADPM_READY				2
 NIRADPM_STANDBY			3
 NIRADPM_PROCESS			4
 NIRADPM_SHUTDOWN			5

*)
FUNCTION ModuleStatus
	CASE StatusValue OF
		0: ModuleStatus := NIRADPM_OFF;
		1: ModuleStatus := NIRADPM_STARTUP;
		2: ModuleStatus := NIRADPM_READY;
		3: ModuleStatus := NIRADPM_STANDBY;
		4: ModuleStatus := NIRADPM_PROCESS;
		5: ModuleStatus := NIRADPM_SHUTDOWN;
		ELSE ModuleStatus := NIRADPM_UNDEFINED;
	END_CASE
END_FUNCTION
