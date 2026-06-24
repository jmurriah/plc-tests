
(* TODO: Add your comment here *)
FUNCTION_BLOCK GetCalcVelocity
	
(* Escribe la velocidad en RPM en la variable interna *)
	IF xEn THEN
		IF xValid THEN
			rValor:=ABS(DINT_TO_REAL(diVelocidad_RPM));
		END_IF;
	ELSE
		rValor:=0.0;
	END_IF;

	(* Convierte de UM/Seg a M/MIN *)
	rm_rpm:= (((UINT_TO_REAL(uiEje)/10.0) / (UINT_TO_REAL(uiReductor))));
	iVel_lin:=REAL_TO_UINT((((rValor/1000) * rm_rpm)/1000)*600);

	
	
	
END_FUNCTION_BLOCK
