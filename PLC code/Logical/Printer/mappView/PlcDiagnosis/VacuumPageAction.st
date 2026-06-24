
ACTION Vacuum_getIndex: 
	
	Vacuum_TVSelected ACCESS ADR (gTransVacuum[LIMIT(1, Vacuum_iTVIdx,2)]);
	Vacuum_BlowerSelected ACCESS ADR (gAxisInverter[LIMIT(1, Vacuum_iBlowerIdx,4)]);

END_ACTION
