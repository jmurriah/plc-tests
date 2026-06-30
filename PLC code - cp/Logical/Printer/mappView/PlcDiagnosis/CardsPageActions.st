
ACTION GetInstalledCards: 

	IF Cards_iInstalledInx > 100 THEN Cards_iInstalledInx := 0; END_IF 
		
	IF gPlcCards[LIMIT(0,Cards_iInstalledInx,100)].pCard <> 0 THEN
		
		Cards_getInsPlcMap ACCESS (gPlcCards[LIMIT(0,Cards_iInstalledInx,100)].pCard);
		Cards_Installed[LIMIT(0,Cards_iInstalledInx,100)] := Cards_getInsPlcMap.ModuleOk;
		
	ELSE 
	
		Cards_Installed[LIMIT(0,Cards_iInstalledInx,100)] := 0;
	
	END_IF	
	
	Cards_iInstalledInx := Cards_iInstalledInx + 1;
	
END_ACTION

ACTION GetCardDI_1:
	
	IF gPlcCards[LIMIT(0,Cards_iDIIndex_1,100)].pCard <> 0 THEN
	
		Cards_mappDI_1 ACCESS (gPlcCards[LIMIT(0,Cards_iDIIndex_1,100)].pCard);
		Cards_aDI_1 := Cards_mappDI_1.DInput;
		
	END_IF
	
END_ACTION

ACTION GetCardDO_1:
	
	IF gPlcCards[LIMIT(0,Cards_iDOIndex_1,100)].pCard <> 0 THEN
	
		Cards_mappDO_1 ACCESS (gPlcCards[LIMIT(0,Cards_iDOIndex_1,100)].pCard);
		Cards_aDO_1 := Cards_mappDO_1.DOutput;
		
	END_IF
	
END_ACTION

ACTION GetCardAI_1:
	
	IF gPlcCards[LIMIT(0,Cards_iAIIndex_1,100)].pCard <> 0 THEN
	
		Cards_mappAI_1 ACCESS (gPlcCards[LIMIT(0,Cards_iAIIndex_1,100)].pCard);
		Cards_aAI_1 := Cards_mappAI_1.AInput;
		
	END_IF
	
END_ACTION

ACTION GetCardAO_1:
	
	IF gPlcCards[LIMIT(0,Cards_iAOIndex_1,100)].pCard <> 0 THEN
	
		Cards_mappAO_1 ACCESS (gPlcCards[LIMIT(0,Cards_iAOIndex_1,100)].pCard);
		Cards_aAO_1 := Cards_mappAO_1.AOutput;
		
	END_IF
	
END_ACTION

ACTION GetCardAT_1:
	
	IF gPlcCards[LIMIT(0,Cards_iAOIndex_1,100)].pCard <> 0 THEN
	
		Cards_mappAT_1 ACCESS (gPlcCards[LIMIT(0,Cards_iAOIndex_1,100)].pCard);
		Cards_aAT_1 := Cards_mappAT_1.TempInput;
		
	END_IF
	
END_ACTION

ACTION GetCardDI_2:
	
	IF gPlcCards[LIMIT(0,Cards_iDIIndex_2,100)].pCard <> 0 THEN
	
		Cards_mappDI_2 ACCESS (gPlcCards[LIMIT(0,Cards_iDIIndex_2,100)].pCard);
		Cards_aDI_2 := Cards_mappDI_2.DInput;
		
	END_IF
	
END_ACTION

ACTION GetCardDO_2:
	
	IF gPlcCards[LIMIT(0,Cards_iDOIndex_2,100)].pCard <> 0 THEN
	
		Cards_mappDO_2 ACCESS (gPlcCards[LIMIT(0,Cards_iDOIndex_2,100)].pCard);
		Cards_aDO_2 := Cards_mappDO_2.DOutput;
		
	END_IF
	
END_ACTION

ACTION GetCardAI_2:
	
	IF gPlcCards[LIMIT(0,Cards_iAIIndex_2,100)].pCard <> 0 THEN
	
		Cards_mappAI_2 ACCESS (gPlcCards[LIMIT(0,Cards_iAIIndex_2,100)].pCard);
		Cards_aAI_2 := Cards_mappAI_2.AInput;
		
	END_IF
	
END_ACTION

ACTION GetCardAO_2:
	
	IF gPlcCards[LIMIT(0,Cards_iAOIndex_2,100)].pCard <> 0 THEN
	
		Cards_mappAO_2 ACCESS (gPlcCards[LIMIT(0,Cards_iAOIndex_2,100)].pCard);
		Cards_aAO_2 := Cards_mappAO_2.AOutput;
		
	END_IF
	
END_ACTION

ACTION GetCardAT_2:
	
	IF gPlcCards[LIMIT(0,Cards_iAOIndex_2,100)].pCard <> 0 THEN
	
		Cards_mappAT_2 ACCESS (gPlcCards[LIMIT(0,Cards_iAOIndex_2,100)].pCard);
		Cards_aAT_2 := Cards_mappAT_2.TempInput;
		
	END_IF
	
END_ACTION