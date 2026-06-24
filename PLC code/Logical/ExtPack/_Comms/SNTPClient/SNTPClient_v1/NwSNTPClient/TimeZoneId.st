
ACTION TimeZoneId:
	
	CASE Time.Params.UTCTimeZone OF
		-1200: Network.Data.TimeZoneID := 5;
		-1100: Network.Data.TimeZoneID := 10;
		-1000: Network.Data.TimeZoneID := 15;
		-0900: Network.Data.TimeZoneID := 20;
		-0800: Network.Data.TimeZoneID := 25;
		-0700: IF Time.Params.DayLightSavingsTime THEN Network.Data.TimeZoneID := 35; ELSE Network.Data.TimeZoneID := 30; END_IF
		-0600: IF Time.Params.DayLightSavingsTime THEN Network.Data.TimeZoneID := 45; ELSE Network.Data.TimeZoneID := 55; END_IF
		-0500: IF Time.Params.DayLightSavingsTime THEN Network.Data.TimeZoneID := 65; ELSE Network.Data.TimeZoneID := 60; END_IF
		-0400: IF Time.Params.DayLightSavingsTime THEN Network.Data.TimeZoneID := 85; ELSE Network.Data.TimeZoneID := 80; END_IF
		-0330: Network.Data.TimeZoneID := 95;
		-0300: IF Time.Params.DayLightSavingsTime THEN Network.Data.TimeZoneID := 105; ELSE Network.Data.TimeZoneID := 110; END_IF
		-0200: Network.Data.TimeZoneID := 115;
		-0100: IF Time.Params.DayLightSavingsTime THEN Network.Data.TimeZoneID := 120; ELSE Network.Data.TimeZoneID := 125; END_IF
		0000:  IF Time.Params.DayLightSavingsTime THEN Network.Data.TimeZoneID := 130; ELSE Network.Data.TimeZoneID := 135; END_IF
		+0100: IF Time.Params.DayLightSavingsTime THEN Network.Data.TimeZoneID := 140; ELSE Network.Data.TimeZoneID := 155; END_IF
		+0200: IF Time.Params.DayLightSavingsTime THEN Network.Data.TimeZoneID := 165; ELSE Network.Data.TimeZoneID := 180; END_IF
		+0300: Network.Data.TimeZoneID := 200;
		+0330: Network.Data.TimeZoneID := 215;
		+0400: IF Time.Params.DayLightSavingsTime THEN Network.Data.TimeZoneID := 230; ELSE Network.Data.TimeZoneID := 220; END_IF
		+0430: Network.Data.TimeZoneID := 235;
		+0500: Network.Data.TimeZoneID := 240;
		+0530: Network.Data.TimeZoneID := 250;
		+0545: Network.Data.TimeZoneID := 255;
		+0600: Network.Data.TimeZoneID := 260;
		+0630: Network.Data.TimeZoneID := 280;
		+0700: Network.Data.TimeZoneID := 285;
		+0800: Network.Data.TimeZoneID := 295;
		+0900: Network.Data.TimeZoneID := 320;
		+0930: Network.Data.TimeZoneID := 335;
		+1000: IF Time.Params.DayLightSavingsTime THEN Network.Data.TimeZoneID := 350; ELSE Network.Data.TimeZoneID := 340; END_IF
		+1100: Network.Data.TimeZoneID := 365;
		+1200: IF Time.Params.DayLightSavingsTime THEN Network.Data.TimeZoneID := 370; ELSE Network.Data.TimeZoneID := 375; END_IF
		+1300: Network.Data.TimeZoneID := 380;

	END_CASE;

END_ACTION
