ACTION CommsManager:
	
	//To disable functions and open again when a READ command seems to be on hold to much time
	tonOpenPort.IN:= (dataLed.Comms.Device.step = FRM_READ);
	tonOpenPort.PT := T#10s;
	tonOpenPort();
	
	dataLed.Comms.Command.Open := tonOpenPort.Q;
	
	IF dataLed.Comms.Command.Open THEN																(*command for sender activation*)
		DisableFunctions;
		dataLed.Comms.Device.step := FRM_OPEN;
				
	ELSIF dataLed.Comms.Command.Close THEN															(*command for sender activation*)
		DisableFunctions;
		dataLed.Comms.Device.step := FRM_CLOSE;
	END_IF
	
	
	CASE dataLed.Comms.Device.step OF
		
		FRM_WAIT:
			IF dataLed.Comms.Command.Send THEN													(*command for sender activation*)
				dataLed.Comms.Device.step := FRM_OPEN;
			ELSIF dataLed.Comms.Command.Receive THEN											(*command for sender activation*)
				dataLed.Comms.Device.step := FRM_READ;
			END_IF
			
		
		FRM_OPEN:
			DisableFunctions;
			
			(*Parameters for FRM_xopen()*)
			dataLed.Comms.Device.FRM_xopen_0.enable := TRUE;
			
			dataLed.Comms.Device.FRM_xopen_0.device := ADR(dataLed.Comms.Device.DeviceName);
			dataLed.Comms.Device.FRM_xopen_0.mode := ADR('/PHY=RS485 /BD=57600 /DB=8 /PA=N /SB=1'); (*Modestring --> specifies the seria operation mode*)
			dataLed.Comms.Device.FRM_xopen_0.config := ADR(dataLed.Comms.Device.xopenConfig);		(*Additional Parameters, optional*)
				
			(*Additional Parameters for FRM_xopen()*)
			dataLed.Comms.Device.xopenConfig.idle := 10;											//Idle time between two characters
			dataLed.Comms.Device.xopenConfig.delimc := 0;											//activate two delimeters
			dataLed.Comms.Device.xopenConfig.delim[0] := 0; 										//CR - carridge return -> dec 13
			dataLed.Comms.Device.xopenConfig.delim[1] := 0; 										//LF - line feed -> dec 10
			dataLed.Comms.Device.xopenConfig.tx_cnt := 1;											//number of transmit buffers
			dataLed.Comms.Device.xopenConfig.rx_cnt := 1; 											//number of receive buffers
			dataLed.Comms.Device.xopenConfig.tx_len := 80; 											//length of transmit buffers
			dataLed.Comms.Device.xopenConfig.rx_len := 800; 										//lenght of receive buffers
			dataLed.Comms.Device.xopenConfig.argc := 0;												//activate additional options
			dataLed.Comms.Device.xopenConfig.argv := 0;												//parameters for additional options (check help)
			dataLed.Comms.Device.FRM_xopen_0();														//call the FRM_xopen() function
			
			xCommsOpened := dataLed.Comms.Device.FRM_xopen_0.status = 0;
			xOpeningComms := dataLed.Comms.Device.FRM_xopen_0.status = BUSY;
			
			IF dataLed.Comms.Device.FRM_xopen_0.status <> ERR_FUB_BUSY AND dataLed.Comms.Device.FRM_xopen_0.status <> ERR_FUB_ENABLE_FALSE THEN
				IF dataLed.Comms.Device.FRM_xopen_0.status = ERR_OK THEN
					dataLed.Comms.Device.step := FRM_CLEAR_BUFFER;
				ELSE
					dataLed.Comms.Device.step := FRM_ERROR;
				END_IF			
			END_IF
			
		
		(*aquire sendbuffer for FRM_WRITE*)
		FRM_CLEAR_BUFFER:	
			dataLed.Comms.Device.FRM_gbuf_0.enable := TRUE;
			dataLed.Comms.Device.FRM_gbuf_0.ident := dataLed.Comms.Device.FRM_xopen_0.ident;
			dataLed.Comms.Device.FRM_gbuf_0();																	(*call the FRM_gbuf() function*)
			
			xBufferCleared := dataLed.Comms.Device.FRM_gbuf_0.status = 0;
			xClearingBuffer := dataLed.Comms.Device.FRM_gbuf_0.status = BUSY;
			
			IF dataLed.Comms.Device.FRM_gbuf_0.status <> ERR_FUB_BUSY AND dataLed.Comms.Device.FRM_gbuf_0.status <> ERR_FUB_ENABLE_FALSE THEN
				IF dataLed.Comms.Device.FRM_gbuf_0.status = ERR_OK THEN
					memset(dataLed.Comms.Device.FRM_gbuf_0.buffer,0,dataLed.Comms.Device.FRM_gbuf_0.buflng);		//clear sendbuffer
					dataLed.Comms.Device.step := FRM_PREPARE_SENDDATA;
				ELSE
					dataLed.Comms.Device.step := FRM_ERROR;
				END_IF			
			END_IF
			
			
		(*prepare senddata, copy data to sendbuffer*)
		FRM_PREPARE_SENDDATA:
			send_data := dataLed.Comms.Device.send_data;
			strcat(ADR(send_data),ADR('$R$L'));
			strcpy(dataLed.Comms.Device.FRM_gbuf_0.buffer,ADR(send_data));					(*copy senddata to sendbuffer*)
			
			dataLed.Comms.Device.step := FRM_WRITE;																(*--> next step*)
	
			
		(*write data to interface*)
		FRM_WRITE:	
			(*Parameters for FRM_write()*)
			dataLed.Comms.Device.FRM_write_0.enable := TRUE;
			dataLed.Comms.Device.FRM_write_0.ident := dataLed.Comms.Device.FRM_xopen_0.ident;					(*ident from FRM_xopen()*)
			dataLed.Comms.Device.FRM_write_0.buffer := dataLed.Comms.Device.FRM_gbuf_0.buffer;					(*sendbuffer*)
			dataLed.Comms.Device.FRM_write_0.buflng := strlen(ADR(send_data));								(*net length of senddata*)
   			
			dataLed.Comms.Device.FRM_write_0();																	(*call the FRM_write() function*)

			xBufferSent := dataLed.Comms.Device.FRM_write_0.status = 0;
			xSendingBuffer := dataLed.Comms.Device.FRM_write_0.status = BUSY;
			
			IF dataLed.Comms.Device.FRM_write_0.status <> ERR_FUB_BUSY AND dataLed.Comms.Device.FRM_write_0.status <> ERR_FUB_ENABLE_FALSE THEN
				IF dataLed.Comms.Device.FRM_write_0.status = ERR_OK THEN
					dataLed.Comms.Device.step := FRM_RELEASE_SEND_BUFFER;
				ELSE
					dataLed.Comms.Device.step := FRM_ERROR;
				END_IF			
			END_IF			
		
			
		(*release sendbuffer in case of no successful write operation*)
		FRM_RELEASE_SEND_BUFFER:	
			dataLed.Comms.Device.FRM_robuf_0.enable := TRUE;
			dataLed.Comms.Device.FRM_robuf_0.buffer := dataLed.Comms.Device.FRM_gbuf_0.buffer;					(*sendbuffer*)
			dataLed.Comms.Device.FRM_robuf_0.buflng := dataLed.Comms.Device.FRM_gbuf_0.buflng;					(*buffer length*)
			dataLed.Comms.Device.FRM_robuf_0.ident := dataLed.Comms.Device.FRM_xopen_0.ident;					(*ident open*)
			dataLed.Comms.Device.FRM_robuf_0();																	(*call the FRM_robuf() function*)
		
			xBufferSendReleased := dataLed.Comms.Device.FRM_robuf_0.status = 0;
			xReleasingSendBuffer := dataLed.Comms.Device.FRM_robuf_0.status = BUSY;
			
			IF dataLed.Comms.Device.FRM_robuf_0.status <> ERR_FUB_BUSY AND dataLed.Comms.Device.FRM_robuf_0.status <> ERR_FUB_ENABLE_FALSE THEN
				IF dataLed.Comms.Device.FRM_robuf_0.status = ERR_OK THEN
					dataLed.Comms.Device.step := FRM_READ;
				ELSE
					dataLed.Comms.Device.step := FRM_ERROR;
				END_IF			
			END_IF
			


		(*read data from serial interface*)
		FRM_READ:	
			dataLed.Comms.Device.FRM_read_0.enable := TRUE;
			dataLed.Comms.Device.FRM_read_0.ident := dataLed.Comms.Device.FRM_xopen_0.ident;
			dataLed.Comms.Device.FRM_read_0();																	(*call the FRM_read() function*)
			
			xBufferRead := dataLed.Comms.Device.FRM_read_0.status = 0;
			xReadBufferNoInput := dataLed.Comms.Device.FRM_read_0.status = frmERR_NOINPUT;
			xReadBufferInputError := dataLed.Comms.Device.FRM_read_0.status = frmERR_INPUTERROR;
			
			IF dataLed.Comms.Device.FRM_read_0.status <> ERR_FUB_BUSY AND dataLed.Comms.Device.FRM_read_0.status <> ERR_FUB_ENABLE_FALSE THEN
				IF dataLed.Comms.Device.FRM_read_0.status = ERR_OK THEN
					dataLed.Comms.Device.step := FRM_COPY_RD_DATA;
				ELSIF  dataLed.Comms.Device.FRM_read_0.status = frmERR_NOINPUT THEN
					dataLed.Comms.Device.step := FRM_READ;
				ELSIF dataLed.Comms.Device.FRM_read_0.status = frmERR_INPUTERROR THEN
					dataLed.Comms.Device.step := FRM_RELEASE_READ_BUFFER;
				ELSE
					dataLed.Comms.Device.step := FRM_ERROR;
				END_IF			
			END_IF
			
		
		(*copy data out of the receive buffer*)	
		FRM_COPY_RD_DATA: 
			memset(ADR(dataLed.Comms.Device.receive_data),0,SIZEOF(dataLed.Comms.Device.receive_data));										(*clear read_data buffer*)
			memcpy(ADR(dataLed.Comms.Device.receive_data),dataLed.Comms.Device.FRM_read_0.buffer,dataLed.Comms.Device.FRM_read_0.buflng);   (*copy and evaluate read data*)
			dataLed.Comms.Device.step := FRM_RELEASE_READ_BUFFER;																			(*release read buffer*)
			
			
		(*release readbuffer*)	
		FRM_RELEASE_READ_BUFFER:	
			(*Parameters for FRM_rbuf()*)
			dataLed.Comms.Device.FRM_rbuf_0.enable := TRUE;
			dataLed.Comms.Device.FRM_rbuf_0.ident := dataLed.Comms.Device.FRM_xopen_0.ident;					(*ident from FRM_xopen()*)
			dataLed.Comms.Device.FRM_rbuf_0.buffer := dataLed.Comms.Device.FRM_read_0.buffer;					(*read buffer*)
			dataLed.Comms.Device.FRM_rbuf_0.buflng := dataLed.Comms.Device.FRM_read_0.buflng;					(*length of sendbuffer*)
			dataLed.Comms.Device.FRM_rbuf_0();																	(*call the FRM_rbuf() function*)
			
			xBufferReadReleased := dataLed.Comms.Device.FRM_rbuf_0.status = 0;
			xReleasingReadBuffer := dataLed.Comms.Device.FRM_rbuf_0.status = BUSY;
			xBufferReadInvalid := dataLed.Comms.Device.FRM_rbuf_0.status = frmERR_INVALIDBUFFER;

			IF dataLed.Comms.Device.FRM_rbuf_0.status <> ERR_FUB_BUSY AND dataLed.Comms.Device.FRM_rbuf_0.status <> ERR_FUB_ENABLE_FALSE THEN
				IF dataLed.Comms.Device.FRM_rbuf_0.status = ERR_OK THEN
					dataLed.Comms.Device.step := FRM_CLOSE;
				ELSIF dataLed.Comms.Device.FRM_rbuf_0.status = frmERR_INVALIDBUFFER THEN
					dataLed.Comms.Device.step := FRM_READ;
				ELSE
					dataLed.Comms.Device.step := FRM_ERROR;
				END_IF				
			END_IF
			

		(*close the interface*)
		FRM_CLOSE:
			DisableFunctions;
			
			dataLed.Comms.Device.FRM_close_0.enable := TRUE;
			dataLed.Comms.Device.FRM_close_0.ident := dataLed.Comms.Device.FRM_xopen_0.ident;	(*ident from FRM_xopen()*)			
			dataLed.Comms.Device.FRM_close_0();													(*call the FRM_close() function*)
			
			xCommsClosed := dataLed.Comms.Device.FRM_close_0.status = 0;
			xClosingComms := dataLed.Comms.Device.FRM_close_0.status = BUSY;
			
			IF dataLed.Comms.Device.FRM_close_0.status <> ERR_FUB_BUSY AND dataLed.Comms.Device.FRM_close_0.status <> ERR_FUB_ENABLE_FALSE THEN
				IF dataLed.Comms.Device.FRM_close_0.status = ERR_OK THEN
					dataLed.Comms.Device.step := FRM_WAIT;
				ELSE
					dataLed.Comms.Device.step := FRM_ERROR;
				END_IF			
			END_IF
		
		
		(*error handling*)
		FRM_ERROR:			
			DisableFunctions;
			dataLed.Comms.Device.step := FRM_WAIT;  (*not implementet yet, check help for error codes*)
		
	END_CASE
	
	
	//Store the history OF the error code TO easy the debug
	IF dataLed.Comms.Device.step<>StateHistory[0] THEN
		FOR iIndexHistory:=iHistoryLines TO 1 BY -1 DO 
			StateHistory[iIndexHistory]:=StateHistory[iIndexHistory-1];
		END_FOR
		StateHistory[0]:=dataLed.Comms.Device.step;
	END_IF
	
	
	//Comms commands
	dataLed.Comms.Command := CommsCommandsReset;
	
END_ACTION

ACTION DisableFunctions:
	dataLed.Comms.Device.FRM_close_0.enable := FALSE;
	dataLed.Comms.Device.FRM_gbuf_0.enable := FALSE;
	dataLed.Comms.Device.FRM_rbuf_0.enable := FALSE;
	dataLed.Comms.Device.FRM_read_0.enable := FALSE;
	dataLed.Comms.Device.FRM_robuf_0.enable := FALSE;
	dataLed.Comms.Device.FRM_write_0.enable := FALSE;
	dataLed.Comms.Device.FRM_xopen_0.enable := FALSE;
END_ACTION