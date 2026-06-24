
(* TODO: Add your comment here *)
FUNCTION_BLOCK BlinkOnOff
	TON_1(IN := xEnable AND NOT TON_2.Q, PT := tTimeOn );
	TON_2(IN := TON_1.Q, PT := tTimeOff );
	xOutput:= xEnable AND NOT TON_1.Q AND NOT TON_2.Q;
END_FUNCTION_BLOCK
