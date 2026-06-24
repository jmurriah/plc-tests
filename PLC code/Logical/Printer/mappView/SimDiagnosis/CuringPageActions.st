

ACTION Curing_getIndex: 
	
	getCuringBar;
	CuringBar_VisuLamp ACCESS ADR (CuringBar_VisuBar.Lamp[ LIMIT(1,CuringBar_LampIndex,8)]);
	
END_ACTION


ACTION Curing_SVGBarInit:
	
	IF CuringBar_VisuBar.Parameters.iLampsQuantity>0 AND CuringBar_VisuBar.Status.iTotalNumSlms > 0  THEN 
		CuringBar_VisuPar.SVGMaxWidth := 1053;
		CuringBar_VisuPar.SVGMaxHeight := 60;
		CuringBar_VisuPar.MargHeight := 12;
		CuringBar_VisuPar.MargWidth := 0;
		CuringBar_VisuPar.SLMHeight := 34;
		CuringBar_VisuPar.SLMWidth := CuringBar_VisuPar.SVGMaxWidth / CuringBar_VisuBar.Status.iTotalNumSlms;
		CuringBar_VisuPar.LampIdx := 1;
		CuringBar_VisuPar.SLMIdx := 1;
		CuringBar_VisuPar.xTraslation := 0;
		CuringBar_VisuPar.ySLM := CuringBar_VisuPar.MargHeight;
		CuringBar_VisuPar.yScndMarg := CuringBar_VisuPar.MargHeight + CuringBar_VisuPar.SLMHeight;
	
	ELSE
		CuringBar_VisuPar.SVGMaxWidth := 0;
		CuringBar_VisuPar.SVGMaxHeight := 0;
		CuringBar_VisuPar.MargHeight := 0;
		CuringBar_VisuPar.MargWidth := 0 ;
		CuringBar_VisuPar.SLMHeight := 0;
		CuringBar_VisuPar.SLMWidth := 0;
		CuringBar_VisuPar.LampIdx := 0;
		CuringBar_VisuPar.SLMIdx := 0;
		CuringBar_VisuPar.xTraslation := 0;
		CuringBar_VisuPar.ySLM := 0;
		CuringBar_VisuPar.yScndMarg := 0;
	END_IF
	
END_ACTION

ACTION Curing_SVGBarGenerator:
	
	IF CuringBar_VisuBar.Parameters.iLampsQuantity > 0 AND CuringBar_VisuBar.Status.iTotalNumSlms > 0 THEN
		
		// Initialize the SVG with a maximum size of the widget Paper
		CuringBar_SVGFile := '<svg width="1053" height="60">';
	
		FOR CuringBar_VisuPar.LampIdx := 1 TO CuringBar_VisuBar.Parameters.iLampsQuantity DO
			// Build the Lamp margins:
			
			CuringBar_VisuPar.MargWidth := CuringBar_VisuPar.SLMWidth * CuringBar_VisuBar.Lamp[CuringBar_VisuPar.LampIdx].Parameters.iNumSLM;
			
			//Top Margin
			brsstrcat(ADR(CuringBar_SVGFile),ADR('<rect id="lampTopMarg'));
			CuringBar_SVGAux := UINT_TO_STRING(CuringBar_VisuPar.LampIdx);
			brsstrcat(ADR(CuringBar_SVGFile),ADR(CuringBar_SVGAux));
			brsstrcat(ADR(CuringBar_SVGFile),ADR('" width="'));
			CuringBar_SVGAux := REAL_TO_STRING(CuringBar_VisuPar.MargWidth);
			brsstrcat(ADR(CuringBar_SVGFile),ADR(CuringBar_SVGAux));
			brsstrcat(ADR(CuringBar_SVGFile),ADR('" height="'));
			CuringBar_SVGAux := REAL_TO_STRING(CuringBar_VisuPar.MargHeight);
			brsstrcat(ADR(CuringBar_SVGFile),ADR(CuringBar_SVGAux));
			brsstrcat(ADR(CuringBar_SVGFile),ADR('" x="'));
			CuringBar_SVGAux := REAL_TO_STRING(CuringBar_VisuPar.xTraslation);
			brsstrcat(ADR(CuringBar_SVGFile),ADR(CuringBar_SVGAux));
			brsstrcat(ADR(CuringBar_SVGFile),ADR('" y = "0'));
			brsstrcat(ADR(CuringBar_SVGFile), ADR('" style="fill:rgb(105, 105, 105);stroke-width:0.5;stroke:rgb(0,0,0)" />'));
			
			//Down margin
			brsstrcat(ADR(CuringBar_SVGFile),ADR('<rect id="lampDownMarg'));
			CuringBar_SVGAux := UINT_TO_STRING(CuringBar_VisuPar.LampIdx);
			brsstrcat(ADR(CuringBar_SVGFile),ADR(CuringBar_SVGAux));
			brsstrcat(ADR(CuringBar_SVGFile),ADR('" width="'));
			CuringBar_SVGAux := REAL_TO_STRING(CuringBar_VisuPar.MargWidth);
			brsstrcat(ADR(CuringBar_SVGFile),ADR(CuringBar_SVGAux));
			brsstrcat(ADR(CuringBar_SVGFile),ADR('" height="'));
			CuringBar_SVGAux := REAL_TO_STRING(CuringBar_VisuPar.MargHeight);
			brsstrcat(ADR(CuringBar_SVGFile),ADR(CuringBar_SVGAux));
			brsstrcat(ADR(CuringBar_SVGFile),ADR('" x="'));
			CuringBar_SVGAux := REAL_TO_STRING(CuringBar_VisuPar.xTraslation);
			brsstrcat(ADR(CuringBar_SVGFile),ADR(CuringBar_SVGAux));
			brsstrcat(ADR(CuringBar_SVGFile),ADR('" y = "'));
			CuringBar_SVGAux := REAL_TO_STRING(CuringBar_VisuPar.yScndMarg);
			brsstrcat(ADR(CuringBar_SVGFile),ADR(CuringBar_SVGAux));
			brsstrcat(ADR(CuringBar_SVGFile), ADR('" style="fill:rgb(105, 105, 105);stroke-width:0.5;stroke:rgb(0,0,0)" /> />'));
			
			FOR CuringBar_VisuPar.SLMIdx := 0 TO CuringBar_VisuBar.Lamp[CuringBar_VisuPar.LampIdx].Parameters.iNumSLM - 1 DO
				
				brsstrcat(ADR(CuringBar_SVGFile),ADR('<rect id="lamp'));
				CuringBar_SVGAux := UINT_TO_STRING(CuringBar_VisuPar.LampIdx);
				brsstrcat(ADR(CuringBar_SVGFile),ADR(CuringBar_SVGAux));
				brsstrcat(ADR(CuringBar_SVGFile),ADR('SLM'));
				CuringBar_SVGAux := UINT_TO_STRING(CuringBar_VisuPar.SLMIdx);
				brsstrcat(ADR(CuringBar_SVGFile),ADR(CuringBar_SVGAux));
				brsstrcat(ADR(CuringBar_SVGFile),ADR('" width="'));
				CuringBar_SVGAux := REAL_TO_STRING(CuringBar_VisuPar.SLMWidth);
				brsstrcat(ADR(CuringBar_SVGFile),ADR(CuringBar_SVGAux));
				brsstrcat(ADR(CuringBar_SVGFile),ADR('" height="'));
				CuringBar_SVGAux := REAL_TO_STRING(CuringBar_VisuPar.SLMHeight);
				brsstrcat(ADR(CuringBar_SVGFile),ADR(CuringBar_SVGAux));
				brsstrcat(ADR(CuringBar_SVGFile),ADR('" x="'));
				CuringBar_SVGAux := REAL_TO_STRING(CuringBar_VisuPar.xTraslation);
				brsstrcat(ADR(CuringBar_SVGFile),ADR(CuringBar_SVGAux));
				brsstrcat(ADR(CuringBar_SVGFile),ADR('" y = "'));
				CuringBar_SVGAux := REAL_TO_STRING(CuringBar_VisuPar.ySLM);
				brsstrcat(ADR(CuringBar_SVGFile),ADR(CuringBar_SVGAux));
				
				IF CuringBar_VisuBar.Lamp[CuringBar_VisuPar.LampIdx].Parameters.xSlmEnable[CuringBar_VisuBar.Lamp[CuringBar_VisuPar.LampIdx].Parameters.iNumSLM - CuringBar_VisuPar.SLMIdx] <> CuringBar_VisuBar.Lamp[CuringBar_VisuPar.LampIdx].Outputs.xSlmStatus[CuringBar_VisuBar.Lamp[CuringBar_VisuPar.LampIdx].Parameters.iNumSLM - CuringBar_VisuPar.SLMIdx] THEN
			
					brsstrcat(ADR(CuringBar_SVGFile), ADR('" style="fill:rgb(255,100,100);stroke-width:0.5;stroke: rgb(0,0,0)" /> />'));
				
				ELSE
					IF CuringBar_VisuBar.Lamp[CuringBar_VisuPar.LampIdx].Parameters.xSlmEnable[CuringBar_VisuBar.Lamp[CuringBar_VisuPar.LampIdx].Parameters.iNumSLM - CuringBar_VisuPar.SLMIdx]=1 THEN
						
						brsstrcat(ADR(CuringBar_SVGFile), ADR('" style="fill:rgb(255,60,255);stroke-width:0.5;stroke: rgb(0,0,0)" /> />'));
					
					ELSE
					
						brsstrcat(ADR(CuringBar_SVGFile), ADR('" style="fill:rgb(255,255,70);stroke-width:0.5;stroke: rgb(0,0,0)" /> />'));
					
					END_IF
			
				END_IF
				
				CuringBar_VisuPar.xTraslation := CuringBar_VisuPar.xTraslation + CuringBar_VisuPar.SLMWidth;
				
			END_FOR 
		
		END_FOR 	
		
		// Close the svg
		brsstrcat(ADR(CuringBar_SVGFile), ADR('</svg>'));

	END_IF	
	CuringBar_SVGCuringBar := CuringBar_SVGFile;
	
END_ACTION
