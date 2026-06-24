


ACTION Detect_SVG:
	
	Detect_SVGFile :='';
	
	IF Detect_PhotoCells.status.rSensorPositionAlignment <> 0 THEN

		Detect_ScaleRef:=  60 / Detect_PhotoCells.status.rSensorPositionAlignment; // %/mm
		
		//header and default objects
		Detect_SVGFile := '<svg><defs><marker id="startarrow" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto"><polygon points="10 0, 10 7, 0 3.5" fill="black" /></marker><marker id="endarrow" markerWidth="10" markerHeight="7" refX="0" refY="3.5" orient="auto" markerUnits="strokeWidth"><polygon points="0 0, 10 3.5, 0 7" fill="black" /></marker></defs><rect width="100%" height="10%" x="0%" y="90%" style="fill:#646464;stroke-width:.1%;stroke:#000"/><text x="50%" y="95%" fill="#ffffff" dominant-baseline="middle" text-anchor="middle" font-size="100%">Belt</text><rect width="40%" height="85%" x="30%" y="5%" style="fill:#ffffff;stroke-width:0.1%;stroke:#000"/><rect width="40%" height="35%" x="30%" y="0%" style="fill:#444444;stroke-width:0.1%;stroke:#000"/><rect width="15%" height="';
		
		//Piece
		Detect_SVGAux := REAL_TO_STRING(Detect_ScaleRef * Detect_PhotoCells.parameters.rMediaThickness);
		brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
		brsstrcat(ADR(Detect_SVGFile),ADR('%" x="'));
		
		IF Detect_PrintDir THEN 
			Detect_SVGAux := REAL_TO_STRING(0);
			brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
		ELSE 
			Detect_SVGAux := REAL_TO_STRING(85);
			brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
		END_IF
		
		brsstrcat(ADR(Detect_SVGFile),ADR('%" y="'));
		
		Detect_SVGAux := REAL_TO_STRING(90 - Detect_ScaleRef * Detect_PhotoCells.parameters.rMediaThickness);
		brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
		brsstrcat(ADR(Detect_SVGFile),ADR('%" style="fill:#964600;stroke-width:0.1%;stroke:#000"/>'));
		
		//Dimension arrow 
		IF Detect_ScaleRef * Detect_PhotoCells.parameters.rMediaThickness > 7 THEN 
			brsstrcat(ADR(Detect_SVGFile),ADR('<line x1="'));
			
			IF Detect_PrintDir THEN 
				Detect_SVGAux := REAL_TO_STRING(16);
			ELSE 
				Detect_SVGAux := REAL_TO_STRING(84);
			END_IF
			
			brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
			brsstrcat(ADR(Detect_SVGFile),ADR('%" y1="86.5%" x2="'));
			brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
			brsstrcat(ADR(Detect_SVGFile),ADR('%" y2="'));
			
			Detect_SVGAux := REAL_TO_STRING(93.5 - Detect_ScaleRef * Detect_PhotoCells.parameters.rMediaThickness);
			brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
			brsstrcat(ADR(Detect_SVGFile),ADR('%" stroke="#000" stroke-width="0.15%" marker-end="url(#endarrow)" marker-start="url(#startarrow)"/>'));
		END_IF
		
		
		//Dimension value
		brsstrcat(ADR(Detect_SVGFile),ADR('<text x="'));
		
		IF Detect_PrintDir THEN 
			Detect_SVGAux := REAL_TO_STRING(16.5);
		ELSE 
			Detect_SVGAux := REAL_TO_STRING(83.5);
		END_IF
	
		brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
		brsstrcat(ADR(Detect_SVGFile),ADR('%" y="'));
		
		Detect_SVGAux := REAL_TO_STRING(90 - 0.5 * Detect_ScaleRef * Detect_PhotoCells.parameters.rMediaThickness);
		brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
		brsstrcat(ADR(Detect_SVGFile),ADR('%" fill="black" dominant-baseline="middle" text-anchor="'));
		IF Detect_PrintDir THEN 
			brsstrcat(ADR(Detect_SVGFile),ADR('start'));
		ELSE 
			brsstrcat(ADR(Detect_SVGFile),ADR('end'));
		END_IF
		brsstrcat(ADR(Detect_SVGFile),ADR('" font-size="100%">Piece: '));
		Detect_SVGAux := REAL_TO_STRING(INT_TO_REAL(TRUNC(Detect_PhotoCells.parameters.rMediaThickness * 100.0)) / 100);
		
		//Detect_SVGAux := REAL_TO_STRING(INT_TO_REAL(TRUNC(Detect_PhotoCells.parameters.rMediaThickness * 10.0)) / 10);
		brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
		brsstrcat(ADR(Detect_SVGFile),ADR('mm</text></svg>'));
		
		FOR Detect_iSensorIdx := 1 TO 6 DO 
			
			//Reference points
			brsstrcat(ADR(Detect_SVGFile),ADR('<circle cx="'));
			IF Detect_PrintDir THEN 
				Detect_SVGAux := REAL_TO_STRING(71 - 6 * Detect_iSensorIdx);
			ELSE 
				Detect_SVGAux := REAL_TO_STRING(30 + 6 * Detect_iSensorIdx);
			END_IF
		
			brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
			brsstrcat(ADR(Detect_SVGFile),ADR('%" cy="'));
			Detect_SVGAux := REAL_TO_STRING(90 - Detect_ScaleRef * (Detect_PhotoCells.status.rSensorPositionAlignment + Detect_PhotoCells.parameters.Sensors[Detect_iSensorIdx].rDistanceRelativeToFirstSensor));
			brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
			brsstrcat(ADR(Detect_SVGFile),ADR('%" r="0.5%" stroke="black" stroke-width="0.1%" fill="white"/>'));
			
			//Lasers		
			brsstrcat(ADR(Detect_SVGFile),ADR('<circle cx="'));
			IF Detect_PrintDir THEN 
				Detect_SVGAux := REAL_TO_STRING(71 - 6 * Detect_iSensorIdx);
			ELSE 
				Detect_SVGAux := REAL_TO_STRING(30 + 6 * Detect_iSensorIdx);
			END_IF
			brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
			brsstrcat(ADR(Detect_SVGFile),ADR('%" cy="'));
			Detect_SVGAux := REAL_TO_STRING(90 - Detect_ScaleRef * (Detect_PhotoCells.parameters.Sensors[Detect_iSensorIdx].rDistanceToBase));
			brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
			brsstrcat(ADR(Detect_SVGFile),ADR('%" r="0.5%" stroke="'));
			
			IF  Detect_PhotoCells.parameters.Sensors[Detect_iSensorIdx].xMountedMedia THEN 
				Detect_SVGAux := 'red';
			ELSIF Detect_PhotoCells.parameters.Sensors[Detect_iSensorIdx].xMoveBarsUp THEN 
				Detect_SVGAux := 'orange';
			ELSE 
				Detect_SVGAux := 'cyan';
			END_IF
			
			brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
			brsstrcat(ADR(Detect_SVGFile),ADR('" stroke-width="0.2%" fill="'));
			
			IF Detect_PhotoCells.Inputs.Signals.xPhotoCells[Detect_iSensorIdx] THEN
				brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
				brsstrcat(ADR(Detect_SVGFile),ADR('"/>'));
			ELSE 
				brsstrcat(ADR(Detect_SVGFile),ADR('white"/>'));
			END_IF
			
			//Dimension arrow 
			IF Detect_ScaleRef * Detect_PhotoCells.parameters.Sensors[Detect_iSensorIdx].rDistanceToBase > 7 THEN 
			
				brsstrcat(ADR(Detect_SVGFile),ADR('<line x1="'));
				IF Detect_PrintDir THEN 
					Detect_SVGAux := REAL_TO_STRING(71 - 6 * Detect_iSensorIdx);
				ELSE 
					Detect_SVGAux := REAL_TO_STRING(30 + 6 * Detect_iSensorIdx);
				END_IF
				brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
				brsstrcat(ADR(Detect_SVGFile),ADR('%" y1="86.5%" x2="'));
				brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
				brsstrcat(ADR(Detect_SVGFile),ADR('%" y2="'));
				Detect_SVGAux := REAL_TO_STRING(94.5 - Detect_ScaleRef * Detect_PhotoCells.parameters.Sensors[Detect_iSensorIdx].rDistanceToBase);
				brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
				brsstrcat(ADR(Detect_SVGFile),ADR('%" stroke="#000" stroke-width="0.15%" marker-end="url(#endarrow)" marker-start="url(#startarrow)"/>'));
				
			END_IF	
			
			//Dimension value
			brsstrcat(ADR(Detect_SVGFile),ADR('<text x="'));
			IF Detect_PrintDir THEN 
				Detect_SVGAux := REAL_TO_STRING(71.5 - 6 * Detect_iSensorIdx);
			ELSE 
				Detect_SVGAux := REAL_TO_STRING(29.5 + 6 * Detect_iSensorIdx);
			END_IF
			brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
			brsstrcat(ADR(Detect_SVGFile),ADR('%" y="'));
			Detect_SVGAux := REAL_TO_STRING(90 - 0.5 * Detect_ScaleRef * Detect_PhotoCells.parameters.Sensors[Detect_iSensorIdx].rDistanceToBase);
			brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
			brsstrcat(ADR(Detect_SVGFile),ADR('%" fill="black" dominant-baseline="middle" text-anchor="'));
			IF Detect_PrintDir THEN 
				brsstrcat(ADR(Detect_SVGFile),ADR('start'));
			ELSE 
				brsstrcat(ADR(Detect_SVGFile),ADR('end'));
			END_IF
			brsstrcat(ADR(Detect_SVGFile),ADR('" font-size="90%">'));
			Detect_SVGAux := Detect_ABC[Detect_iSensorIdx]; 
			brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
			brsstrcat(ADR(Detect_SVGFile),ADR(': '));	
			Detect_SVGAux := REAL_TO_STRING(INT_TO_REAL(TRUNC(Detect_PhotoCells.parameters.Sensors[Detect_iSensorIdx].rDistanceToBase * 100.0)) / 100);
			brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
			brsstrcat(ADR(Detect_SVGFile),ADR('mm</text>'));	
			
		END_FOR
		
		//Block
		brsstrcat(ADR(Detect_SVGFile),ADR('<rect height="'));
		Detect_SVGAux := REAL_TO_STRING( LIMIT(0, 90 - Detect_ScaleRef * Block_SelBlock.Status.rMotorPosition, 90));
		brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
		brsstrcat(ADR(Detect_SVGFile),ADR('%" width="15%" x="'));
		
		IF Detect_PrintDir THEN 
			Detect_SVGAux := REAL_TO_STRING(85); 
			brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
		ELSE 
			Detect_SVGAux := REAL_TO_STRING(0);
			brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
		END_IF
		brsstrcat(ADR(Detect_SVGFile),ADR('%" y="0%" style="fill:#ff0000;stroke-width:0.1%;stroke:#000"/><text x="'));
		IF Detect_PrintDir THEN 
			Detect_SVGAux := REAL_TO_STRING(92.5);
			brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
		ELSE 
			Detect_SVGAux := REAL_TO_STRING(7.5);
			brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
		END_IF
		brsstrcat(ADR(Detect_SVGFile),ADR('%" y="20%" fill="white" dominant-baseline="middle" text-anchor="middle" font-size="100%">Block</text>'));
		
		//Dimension arrow 
		IF Detect_ScaleRef * Block_SelBlock.Status.rMotorPosition > 7 THEN  
		
			brsstrcat(ADR(Detect_SVGFile),ADR('<line x1="'));
			
			IF Detect_PrintDir THEN 
				Detect_SVGAux := REAL_TO_STRING(84);
			ELSE 
				Detect_SVGAux := REAL_TO_STRING(16);
			END_IF
			
			brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
			brsstrcat(ADR(Detect_SVGFile),ADR('%" y1="86.5%" x2="'));
			brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
			brsstrcat(ADR(Detect_SVGFile),ADR('%" y2="'));;
			Detect_SVGAux := REAL_TO_STRING(93.5 - Detect_ScaleRef * Block_SelBlock.Status.rMotorPosition);
			brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
			brsstrcat(ADR(Detect_SVGFile),ADR('%" stroke="#000" stroke-width="0.15%" marker-end="url(#endarrow)" marker-start="url(#startarrow)"/>'));
		
		END_IF 
		
		//Dimension value
		brsstrcat(ADR(Detect_SVGFile),ADR('<text x="'));
		
		IF Detect_PrintDir THEN  
			Detect_SVGAux := REAL_TO_STRING(83.5);
		ELSE
			Detect_SVGAux := REAL_TO_STRING(16.5);
		END_IF
		brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
		brsstrcat(ADR(Detect_SVGFile),ADR('%" y="'));
		Detect_SVGAux := REAL_TO_STRING( LIMIT(20, 90 - 0.5 * Detect_ScaleRef * Block_SelBlock.Status.rMotorPosition, 90));
		brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
		brsstrcat(ADR(Detect_SVGFile),ADR('%" fill="black" dominant-baseline="middle" text-anchor="'));
		IF Detect_PrintDir THEN 
			brsstrcat(ADR(Detect_SVGFile),ADR('end'));
		ELSE 
			brsstrcat(ADR(Detect_SVGFile),ADR('start'));
		END_IF
		brsstrcat(ADR(Detect_SVGFile),ADR('" font-size="100%">Block:'));
		Detect_SVGAux := REAL_TO_STRING(INT_TO_REAL(TRUNC(Block_SelBlock.Status.rMotorPosition * 100.0)) / 100);
		brsstrcat(ADR(Detect_SVGFile),ADR(Detect_SVGAux));
		brsstrcat(ADR(Detect_SVGFile),ADR('mm</text></svg>'));
	
	END_IF 
	
	Detect_SVGDetect := Detect_SVGFile;
	
	
	
END_ACTION
