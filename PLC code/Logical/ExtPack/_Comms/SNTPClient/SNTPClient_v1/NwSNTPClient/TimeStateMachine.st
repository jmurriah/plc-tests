
ACTION TimeStateMachine: 

	//Getting the TimeZoneId
	TimeZoneId;
	IF Network.Data.TimeZoneID<>TimeZoneId_copy THEN
		xNeedToResedTimeZoneId := TRUE;
		TimeZoneId_copy := Network.Data.TimeZoneID;
	END_IF
	
	CASE Time.State OF
		
		TIME_NOT_INITIALIZED:
			IF EDGEPOS(gPLC.xBlk_5s) THEN
				Network.Command.bCfgSetTimeZone := TRUE;
				Time.State := TIME_SETTING_TIMEZONE;
			END_IF
					  
		TIME_SETTING_TIMEZONE:
			IF Network.Data.Step = 0 THEN
				Network.Command.bCfgSetSntpClient := TRUE;
				xNeedToResedTimeZoneId := FALSE;
				Time.Status.TimeUpdated := FALSE;
				Time.State := TIME_SETTING_CLIENT;
			END_IF
				
		TIME_SETTING_CLIENT:
			IF Network.Data.Step = 0 THEN
				IF Time.Params.DayLightSavingsTime THEN
					Network.Command.bGetTimeData := TRUE;
					Time.State := TIME_GETTING_TIMEDATA;
				ELSE
					Network.Command.bCfgGetSntpcData := TRUE;
					Time.State := TIME_RECEIVING_DATA;
				END_IF
			END_IF
		
		TIME_GETTING_TIMEDATA:
			IF Network.Data.Step = 0 THEN
				Network.Command.bCfgGetSntpcData := TRUE;
				Time.State := TIME_RECEIVING_DATA;
			END_IF
			
		TIME_RECEIVING_DATA:
			IF Network.Data.Step = 0 THEN
				Time.Status.TimeUpdated := TRUE;
				Time.State := TIME_IDLE;
			END_IF
			
		TIME_IDLE:
			//Modifyint ZoneId after changing the TimeZone
			IF xNeedToResedTimeZoneId THEN
				Network.Command.bCfgSetTimeZone := TRUE;
				Time.State := TIME_SETTING_TIMEZONE;
			END_IF

	END_CASE;
	
	//Defining value to Sw
	CASE Time.State OF
		TIME_NOT_INITIALIZED: Time.Status.SwState := 0;
		TIME_SETTING_TIMEZONE: Time.Status.SwState := 1;
		TIME_SETTING_CLIENT: Time.Status.SwState := 2;
		TIME_GETTING_TIMEDATA: Time.Status.SwState := 3;
		TIME_RECEIVING_DATA: Time.Status.SwState := 4;
		TIME_IDLE: Time.Status.SwState := 5;
	END_CASE;

END_ACTION
