
TYPE
	CardsImgInfo : 	STRUCT 
		path : STRING[80];
		height : UINT;
		width : UINT;
	END_STRUCT;
	CardsSVGInfo : 	STRUCT 
		Mapping : PlcCardMapping;
		Data : PLCCardData;
	END_STRUCT;
	CuringBarSVGpar_typ : 	STRUCT 
		SLMHeight : REAL;
		SVGMaxWidth : REAL;
		SVGMaxHeight : REAL;
		LampIdx : UINT;
		SLMIdx : UINT;
		xTraslation : REAL;
		yScndMarg : REAL;
		ySLM : REAL;
		MargWidth : REAL;
		SLMWidth : REAL;
		MargHeight : REAL;
	END_STRUCT;
	Pages : 
		(
		UNDEF := 0,
		BlockPage := 1,
		BeltPage := 2,
		VacuumPage := 3,
		CuringPage := 4,
		DetectionPage := 5,
		AncillariesPage := 6,
		CardsPage := 7
		);
END_TYPE
