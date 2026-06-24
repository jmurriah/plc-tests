
ACTION ResetAlarms: 
	data.Alarms := stThickAlarmsReseted;
	data.AlSummary := stAlarmsSummaryReseted;
END_ACTION

ACTION ResetCommands: 
	data.Commands:=CommandsReseted;
END_ACTION
