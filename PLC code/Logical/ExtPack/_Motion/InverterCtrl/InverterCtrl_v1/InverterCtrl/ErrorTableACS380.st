(*************************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 *************************************************************************
 * Program: ACS380Ctrl
 * File: ErrorTable.st
 * Author: canyisc
 * Created: April 24, 2019
 *************************************************************************
 * ERRORS and WARNINGS OF program ABB ACS380
 *************************************************************************
 *************************************************************************
 * Version | Date			| Author 	| Description
 * ----------------------------------------------------------------------
 * V1.00.0 | 17-April-2019 	| canyisc	| Adapted TO ABB ACS380 inverter
 ************************************************************************)

(*Writes the error table*)
ACTION ErrorTableACS380:
	
	
	// ----------------------------------------------------------------------------------------
	// 								FAULT MESSAGES
	// ----------------------------------------------------------------------------------------
	
	Error[0].ErrorID	:= 16#1080;
	Error[0].ErrorText	:= 'Err 1080: Backup/Restore timeout';
	
	Error[1].ErrorID	:= 16#1081;
	Error[1].ErrorText	:= 'Err 1081: Rating ID fault';
	
	Error[2].ErrorID	:= 16#2281;
	Error[2].ErrorText	:= 'Err 2281: Calibration';
	
	Error[3].ErrorID	:= 16#2310;
	Error[3].ErrorText	:= 'Err 2310: Overcurrent';
	
	Error[4].ErrorID	:= 16#2330;
	Error[4].ErrorText	:= 'Err 2330: Earth leakage';
	
	Error[5].ErrorID	:= 16#2340;
	Error[5].ErrorText	:= 'Err 2340: Short circuit';
	
	Error[6].ErrorID	:= 16#2381;
	Error[6].ErrorText	:= 'Err 2381: IGBT overload';
	
	Error[7].ErrorID	:= 16#3130;
	Error[7].ErrorText	:= 'Err 3130: Input phase loss';
	
	Error[8].ErrorID	:= 16#3181;
	Error[8].ErrorText	:= 'Err 3181: Cross connection';
	
	Error[9].ErrorID	:= 16#3210;
	Error[9].ErrorText	:= 'Err 3210: DC link overvoltage';
	
	Error[10].ErrorID	:= 16#3220;
	Error[10].ErrorText	:= 'Err 3220: DC link undervoltage';
	
	Error[11].ErrorID	:= 16#3385;
	Error[11].ErrorText	:= 'Err 3385: Autophasing';
	
	Error[12].ErrorID	:= 16#3381;
	Error[12].ErrorText	:= 'Err 3381: Output phase loss';
	
	Error[13].ErrorID	:= 16#4110;
	Error[13].ErrorText	:= 'Err 4110: Control board temperature';
	
	Error[14].ErrorID	:= 16#4210;
	Error[14].ErrorText	:= 'Err 4210: IGBT overtemperature';
	
	Error[15].ErrorID	:= 16#4290;
	Error[15].ErrorText	:= 'Err 4290: Cooling';
	
	Error[16].ErrorID	:= 16#42F1;
	Error[16].ErrorText	:= 'Err 42F1: IGBT temperature';
	
	Error[17].ErrorID	:= 16#4310;
	Error[17].ErrorText	:= 'Err 4310: Excess temperature';
	
	Error[18].ErrorID	:= 16#4380;
	Error[18].ErrorText	:= 'Err : Excess temperature difference';
	
	Error[19].ErrorID	:= 16#4981;
	Error[19].ErrorText	:= 'Err 4380: External temperature 1';
	
	Error[20].ErrorID	:= 16#4982;
	Error[20].ErrorText	:= 'Err 4982: External temperature 2';
	
	Error[21].ErrorID	:= 16#5090;
	Error[21].ErrorText	:= 'Err 5090: STO hardware failure';
	
	Error[22].ErrorID	:= 16#5091;
	Error[22].ErrorText	:= 'Err 5091: Safe torque off';
	
	Error[23].ErrorID	:= 16#5092;
	Error[23].ErrorText	:= 'Err 5092: PU logic error';
	
	Error[24].ErrorID	:= 16#5093;
	Error[24].ErrorText	:= 'Err 5093: Rating ID mismatch';
	
	Error[25].ErrorID	:= 16#5094;
	Error[25].ErrorText	:= 'Err 5094: Measurement circuit temperature';
	
	Error[26].ErrorID	:= 16#5098;
	Error[26].ErrorText	:= 'Err 5098: I/O communication loss';
	
	Error[27].ErrorID	:= 16#50A0;
	Error[27].ErrorText	:= 'Err 50A0: Fan';
	
	Error[28].ErrorID	:= 16#5681;
	Error[28].ErrorText	:= 'Err 5681: PU communication';
	
	Error[29].ErrorID	:= 16#5682;
	Error[29].ErrorText	:= 'Err 5682: Power unit lost';
	
	Error[30].ErrorID	:= 16#5690;
	Error[30].ErrorText	:= 'Err 5690: PU communication internal';
	
	Error[31].ErrorID	:= 16#5691;
	Error[31].ErrorText	:= 'Err 5691: Measurement circuit ADC';
	
	Error[32].ErrorID	:= 16#5692;
	Error[32].ErrorText	:= 'Err 5692: PU board powerfail';
	
	Error[33].ErrorID	:= 16#5693;
	Error[33].ErrorText	:= 'Err 5693: Measurement circuit DFF';
	
	Error[34].ErrorID	:= 16#5696;
	Error[34].ErrorText	:= 'Err 5696: PU state feedback';
	
	Error[35].ErrorID	:= 16#5697;
	Error[35].ErrorText	:= 'Err 5697: Charging feedback';
	
	Error[36].ErrorID	:= 16#6181;
	Error[36].ErrorText	:= 'Err 6181: FPGA version incompatible';
	
	Error[37].ErrorID	:= 16#6200;
	Error[37].ErrorText	:= 'Err 6200: Checksum mismatch';
	
	Error[38].ErrorID	:= 16#6306;
	Error[38].ErrorText	:= 'Err 6306: FBA A mapping file';
	
	Error[39].ErrorID	:= 16#6481;
	Error[39].ErrorText	:= 'Err 6481: Task overload';

	Error[40].ErrorID	:= 16#6487;
	Error[40].ErrorText	:= 'Err 6487: Stack overflow';
	
	Error[41].ErrorID	:= 16#64A1;
	Error[41].ErrorText	:= 'Err 64A1: Internal file load';
	
	Error[42].ErrorID	:= 16#64A6;
	Error[42].ErrorText	:= 'Err 64A6: Adaptive program file incompatible OR corrupted';
	
	Error[43].ErrorID	:= 16#64B2;
	Error[43].ErrorText	:= 'Err 64B2: User set fault';
	
	Error[44].ErrorID	:= 16#64E1;
	Error[44].ErrorText	:= 'Err 64E1: Kernel overload';
	
	Error[45].ErrorID	:= 16#6581;
	Error[45].ErrorText	:= 'Err 6581: Parameter system';
	
	Error[46].ErrorID	:= 16#65A1;
	Error[46].ErrorText	:= 'Err 65A1: FBA A parameter conflict';
	
	Error[47].ErrorID	:= 16#6681;
	Error[47].ErrorText	:= 'Err 6681: EFB comm loss';
	
	Error[48].ErrorID	:= 16#6682;
	Error[48].ErrorText	:= 'Err 6682: EFB config file';
	
	Error[49].ErrorID	:= 16#6683;
	Error[49].ErrorText	:= 'Err 6683: EFB invalid parameterization';
	
	Error[50].ErrorID	:= 16#6684;
	Error[50].ErrorText	:= 'Err 6684: EFB load fault';
	
	Error[51].ErrorID	:= 16#6685;
	Error[51].ErrorText	:= 'Err 6685: EFB fault 2';
	
	Error[52].ErrorID	:= 16#6686;
	Error[52].ErrorText	:= 'Err 6686: EFB fault 3';
	
	Error[53].ErrorID	:= 16#6882;
	Error[53].ErrorText	:= 'Err 6882: Text 32-bit table overflow';
	
	Error[54].ErrorID	:= 16#6885;
	Error[54].ErrorText	:= 'Err 6885: Text file overflow';
	
	Error[55].ErrorID	:= 16#7081;
	Error[55].ErrorText	:= 'Err 7081: Control panel loss';
	
	Error[56].ErrorID	:= 16#7082;
	Error[56].ErrorText	:= 'Err 7082: I/O module comm loss';
	
	Error[57].ErrorID	:= 16#7086;
	Error[57].ErrorText	:= 'Err 7086: I/O module AI Over voltage';
	
	Error[58].ErrorID	:= 16#71A2;
	Error[58].ErrorText	:= 'Err 71A2: Mechanical brake closing failed';
	
	Error[59].ErrorID	:= 16#71A3;
	Error[59].ErrorText	:= 'Err 71A3: Mechanical brake opening failed';
	
	Error[60].ErrorID	:= 16#71A5;
	Error[60].ErrorText	:= 'Err 71A5: Mechanical brake opening NOT allowed';
	
	Error[61].ErrorID	:= 16#7121;
	Error[61].ErrorText	:= 'Err 7121: Motor stall';
	
	Error[62].ErrorID	:= 16#7181;
	Error[62].ErrorText	:= 'Err 7181: Brake resistor';
	
	Error[63].ErrorID	:= 16#7183;
	Error[63].ErrorText	:= 'Err 7183: BR excess temperature';
	
	Error[64].ErrorID	:= 16#7184;
	Error[64].ErrorText	:= 'Err 7184: Brake resistor wiring';
	
	Error[65].ErrorID	:= 16#7191;
	Error[65].ErrorText	:= 'Err 7191: BC short circuit';
	
	Error[66].ErrorID	:= 16#7192;
	Error[66].ErrorText	:= 'Err 7192: BC IGBT excess temperature';
	
	Error[67].ErrorID	:= 16#7301;
	Error[67].ErrorText	:= 'Err 7301: Motor speed feedback';
	
	Error[68].ErrorID	:= 16#7310;
	Error[68].ErrorText	:= 'Err 7310: Overspeed';
	
	Error[69].ErrorID	:= 16#7381;
	Error[69].ErrorText	:= 'Err 7381: Encoder';
	
	Error[70].ErrorID	:= 16#73F0;
	Error[70].ErrorText	:= 'Err 73F0: Overfrequency';
	
	Error[71].ErrorID	:= 16#73B0;
	Error[71].ErrorText	:= 'Err 73B0: Emergency ramp failed';
	
	Error[72].ErrorID	:= 16#7510;
	Error[72].ErrorText	:= 'Err 7510: FBA A communication';
	
	Error[73].ErrorID	:= 16#8001;
	Error[73].ErrorText	:= 'Err 8001: ULC underload fault';
	
	Error[74].ErrorID	:= 16#8002;
	Error[74].ErrorText	:= 'Err 8002: ULC overload fault';
	
	Error[75].ErrorID	:= 16#80A0;
	Error[75].ErrorText	:= 'Err 80A0: AI supervision';
	
	Error[76].ErrorID	:= 16#80B0;
	Error[76].ErrorText	:= 'Err 80B0: Signal supervision';
	
	Error[77].ErrorID	:= 16#80B1;
	Error[77].ErrorText	:= 'Err 80B1: Signal supervision';
	
	Error[78].ErrorID	:= 16#80B2;
	Error[78].ErrorText	:= 'Err 80B2: Signal supervision';
	
	Error[79].ErrorID	:= 16#80B3;
	Error[79].ErrorText	:= 'Err 80B3: Signal supervision';
	
	Error[80].ErrorID	:= 16#80B4;
	Error[80].ErrorText	:= 'Err 80B4: Signal supervision';
	
	Error[81].ErrorID	:= 16#80B5;
	Error[81].ErrorText	:= 'Err 80B5: Signal supervision';
	
	Error[82].ErrorID	:= 16#9081;
	Error[82].ErrorText	:= 'Err 9081: External fault 1';
	
	Error[83].ErrorID	:= 16#9082;
	Error[83].ErrorText	:= 'Err 9082: External fault 2';
	
	Error[84].ErrorID	:= 16#9083;
	Error[84].ErrorText	:= 'Err 9083: External fault 3';
	
	Error[85].ErrorID	:= 16#9084;
	Error[85].ErrorText	:= 'Err 9084: External fault 4';
	
	Error[86].ErrorID	:= 16#9085;
	Error[86].ErrorText	:= 'Err 9085: External fault 5';
	
	Error[87].ErrorID	:= 16#FA81;
	Error[87].ErrorText	:= 'Err FA81: Safe torque off 1';
	
	Error[88].ErrorID	:= 16#FA82;
	Error[88].ErrorText	:= 'Err FA82: Safe torque off 2';
	
	Error[89].ErrorID	:= 16#FF61;
	Error[89].ErrorText	:= 'Err FF61: ID run';
	
	Error[90].ErrorID	:= 16#FF81;
	Error[90].ErrorText	:= 'Err FF81: FB A force trip';
	
	Error[91].ErrorID	:= 16#FF8E;
	Error[91].ErrorText	:= 'Err FF8E: EFB force trip';
	
	Error[92].ErrorID	:= 16#D100;
	Error[92].ErrorText	:= 'Err D100: Torque prove';
	
	Error[93].ErrorID	:= 16#D101;
	Error[93].ErrorText	:= 'Err D101: Brake slip';
	
	Error[94].ErrorID	:= 16#D102;
	Error[94].ErrorText	:= 'Err D102: Brake safe closure';
	
	Error[95].ErrorID	:= 16#D105;
	Error[95].ErrorText	:= 'Err D105: Speed match';
	
	Error[96].ErrorID	:= 16#D108;
	Error[96].ErrorText	:= 'Err D108: Stop limits I/O error';
	
	Error[97].ErrorID	:= 16#D10A;
	Error[97].ErrorText	:= 'Err D10A: Brake not selected';
	
	// ----------------------------------------------------------------------------------------
	// 								WARNING MESSAGES
	// ----------------------------------------------------------------------------------------
	
	Error[100].ErrorID		:= 16#64FF;
	Error[100].ErrorText	:= 'Warn 64FF: Fault reset';
	
	Error[101].ErrorID		:= 16#A2A1;
	Error[101].ErrorText	:= 'Warn A2A1: Current calibration';
	
	Error[102].ErrorID		:= 16#A2B1;
	Error[102].ErrorText	:= 'Warn A2B1: Overcurrent';
	
	Error[103].ErrorID		:= 16#A2B3;
	Error[103].ErrorText	:= 'Warn A2B3: Earth leakage';
	
	Error[104].ErrorID		:= 16#A2B4;
	Error[104].ErrorText	:= 'Warn A2B4: Short circuit';
	
	Error[105].ErrorID		:= 16#A2B2;
	Error[105].ErrorText	:= 'Warn A2B2: IGBT overload';
	
	Error[106].ErrorID		:= 16#A3A1;
	Error[106].ErrorText	:= 'Warn A3A1: DC link overvoltage';
	
	Error[107].ErrorID		:= 16#A3A2;
	Error[107].ErrorText	:= 'Warn A3A2: DC link undervoltage';
	
	Error[108].ErrorID		:= 16#A3AA;
	Error[108].ErrorText	:= 'Warn A3AA: DC not charged';
	
	Error[109].ErrorID		:= 16#A490;
	Error[109].ErrorText	:= 'Warn A490: Incorrect temperature sensor setup';
	
	Error[110].ErrorID		:= 16#A491;
	Error[110].ErrorText	:= 'Warn A491: External temperature 1';
	
	Error[111].ErrorID		:= 16#A492;
	Error[111].ErrorText	:= 'Warn A492: External temperature 2';
	
	Error[112].ErrorID		:= 16#A4A1;
	Error[112].ErrorText	:= 'Warn A4A1: IGBT overtemperature';
	
	Error[113].ErrorID		:= 16#A4A1;
	Error[113].ErrorText	:= 'Warn A4A1: Cooling';
	
	Error[114].ErrorID		:= 16#A4B0;
	Error[114].ErrorText	:= 'Warn A4B0: Excess temperature';
	
	Error[115].ErrorID		:= 16#A4B1;
	Error[115].ErrorText	:= 'Warn A4B1: Excess temperature difference';
	
	Error[116].ErrorID		:= 16#A4F6;
	Error[116].ErrorText	:= 'Warn A4F6: IGBT temperature';
	
	Error[117].ErrorID		:= 16#A580;
	Error[117].ErrorText	:= 'Warn A580: PU communication';
	
	Error[118].ErrorID		:= 16#A591;
	Error[118].ErrorText	:= 'Warn A591: Drive HW initialization';
	
	Error[119].ErrorID		:= 16#A5A0;
	Error[119].ErrorText	:= 'Warn A5A0: Safe torque off';
	
	Error[120].ErrorID		:= 16#A5EA;
	Error[120].ErrorText	:= 'Warn A5EA: Measurement circuit temperature';
	
	Error[121].ErrorID		:= 16#A5EB;
	Error[121].ErrorText	:= 'Warn A5EB: PU board powerfail';
	
	Error[122].ErrorID		:= 16#A5EC;
	Error[122].ErrorText	:= 'Warn A5EC: PU communication internal';
	
	Error[123].ErrorID		:= 16#A5ED;
	Error[123].ErrorText	:= 'Warn A5ED: Measurement circuit ADC';
	
	Error[124].ErrorID		:= 16#A5EE;
	Error[124].ErrorText	:= 'Warn A5EE: Measurement circuit DFF';
	
	Error[125].ErrorID		:= 16#A5EF;
	Error[125].ErrorText	:= 'Warn A5EF: PU state feedback';
	
	Error[126].ErrorID		:= 16#A5F0;
	Error[126].ErrorText	:= 'Warn A5F0: Charging feedback';
	
	Error[127].ErrorID		:= 16#A686;
	Error[127].ErrorText	:= 'Warn A686: Checksum mismatch';
	
	Error[128].ErrorID		:= 16#A687;
	Error[128].ErrorText	:= 'Warn A687: Checksum configuration';
	
	Error[129].ErrorID		:= 16#A6A4;
	Error[129].ErrorText	:= 'Warn A6A4: Motor nominal value';
	
	Error[130].ErrorID		:= 16#A6A5;
	Error[130].ErrorText	:= 'Warn A6A5: No motor data';
	
	Error[131].ErrorID		:= 16#A6A6;
	Error[131].ErrorText	:= 'Warn A6A6: Voltage category unselected';
	
	Error[132].ErrorID		:= 16#A6B0;
	Error[132].ErrorText	:= 'Warn A6B0: User lock is open';
	
	Error[133].ErrorID		:= 16#A6D1;
	Error[133].ErrorText	:= 'Warn A6D1: FBA A parameter conflict';
	
	Error[134].ErrorID		:= 16#A6E5;
	Error[134].ErrorText	:= 'Warn A6E5: AI parametrization';
	
	Error[135].ErrorID		:= 16#A6E6;
	Error[135].ErrorText	:= 'Warn A6E6: ULC configuration';
	
	Error[136].ErrorID		:= 16#A7A1;
	Error[136].ErrorText	:= 'Warn A7A1: Mechanical brake closing failed';
	
	Error[137].ErrorID		:= 16#A7A5;
	Error[137].ErrorText	:= 'Warn A7A5: Mechanical brake opening NOT allowed';
	
	Error[138].ErrorID		:= 16#A7B0;
	Error[138].ErrorText	:= 'Warn A7B0: Motor speed feedback';
	
	Error[139].ErrorID		:= 16#A780;
	Error[139].ErrorText	:= 'Warn A780: Motor stall';
	
	Error[140].ErrorID		:= 16#A791;
	Error[140].ErrorText	:= 'Warn A791: Brake resistor';
	
	Error[141].ErrorID		:= 16#A793;
	Error[141].ErrorText	:= 'Warn A793: BR excess temperature';
	
	Error[142].ErrorID		:= 16#A794;
	Error[142].ErrorText	:= 'Warn A794: BR data';
	
	Error[143].ErrorID		:= 16#A79C;
	Error[143].ErrorText	:= 'Warn A79C: BC IGBT excess temperature';
	
	Error[144].ErrorID		:= 16#A7AB;
	Error[144].ErrorText	:= 'Warn A7AB: Extension I/O configuration failure';
	
	Error[145].ErrorID		:= 16#A7C1;
	Error[145].ErrorText	:= 'Warn A7C1: FBA A communication';
	
	Error[146].ErrorID		:= 16#A7CE;
	Error[146].ErrorText	:= 'Warn A7CE: EFB comm loss';
	
	Error[147].ErrorID		:= 16#A7E1;
	Error[147].ErrorText	:= 'Warn A7E1: Encoder';
	
	Error[148].ErrorID		:= 16#A7EE;
	Error[148].ErrorText	:= 'Warn A7EE: Panel loss';
	
	Error[149].ErrorID		:= 16#A71C;
	Error[149].ErrorText	:= 'Warn A71C: I/O Module internal error';
	
	Error[150].ErrorID		:= 16#A8A0;
	Error[150].ErrorText	:= 'Warn A8A0: AI supervision';
	
	Error[151].ErrorID		:= 16#A8A1;
	Error[151].ErrorText	:= 'Warn A8A1: RO life warning';
	
	Error[152].ErrorID		:= 16#A8A2;
	Error[152].ErrorText	:= 'Warn A8A2: RO toggle warning';
	
	Error[153].ErrorID		:= 16#A8B0;
	Error[153].ErrorText	:= 'Warn A8B0: Signal supervision';
	
	Error[154].ErrorID		:= 16#A8B1;
	Error[154].ErrorText	:= 'Warn A8B1: Signal supervision';
	
	Error[155].ErrorID		:= 16#A8B2;
	Error[155].ErrorText	:= 'Warn A8B2: Signal supervision';
	
	Error[156].ErrorID		:= 16#A8B3;
	Error[156].ErrorText	:= 'Warn A8B3: Signal supervision';
	
	Error[157].ErrorID		:= 16#A8B4;
	Error[157].ErrorText	:= 'Warn A8B4: Signal supervision';
	
	Error[158].ErrorID		:= 16#A8B5;
	Error[158].ErrorText	:= 'Warn A8B5: Signal supervision';
	
	Error[159].ErrorID		:= 16#A8C0;
	Error[159].ErrorText	:= 'Warn A8C0: ULC invalid speed table';
	
	Error[160].ErrorID		:= 16#A8C1;
	Error[160].ErrorText	:= 'Warn A8C1: ULC overload warning';
	
	Error[161].ErrorID		:= 16#A8C4;
	Error[161].ErrorText	:= 'Warn A8C4: ULC underload warning';
	
	Error[162].ErrorID		:= 16#A8C5;
	Error[162].ErrorText	:= 'Warn A8C5: ULC invalid underload table';
	
	Error[163].ErrorID		:= 16#A8C6;
	Error[163].ErrorText	:= 'Warn A8C6: ULC invalid overload table';
	
	Error[164].ErrorID		:= 16#A8C8;
	Error[164].ErrorText	:= 'Warn A8C8: ULC invalid frequency table';
	
	Error[165].ErrorID		:= 16#A981;
	Error[165].ErrorText	:= 'Warn A981: External warning 1';
	
	Error[166].ErrorID		:= 16#A982;
	Error[166].ErrorText	:= 'Warn A982: External warning 2';
	
	Error[167].ErrorID		:= 16#A983;
	Error[167].ErrorText	:= 'Warn A983: External warning 3';
	
	Error[168].ErrorID		:= 16#A984;
	Error[168].ErrorText	:= 'Warn A984: External warning 4';
	
	Error[169].ErrorID		:= 16#A985;
	Error[169].ErrorText	:= 'Warn A985: External warning 5';
	
	Error[170].ErrorID		:= 16#AF88;
	Error[170].ErrorText	:= 'Warn AF88: Season configuration warning';
	
	Error[171].ErrorID		:= 16#AF8C;
	Error[171].ErrorText	:= 'Warn AF8C: Process PID sleep mode';
	
	Error[172].ErrorID		:= 16#AFAA;
	Error[172].ErrorText	:= 'Warn AFAA: Autoreset';
	
	Error[173].ErrorID		:= 16#AFE1;
	Error[173].ErrorText	:= 'Warn AFE1: Emergency stop (off2)';
	
	Error[174].ErrorID		:= 16#AFE2;
	Error[174].ErrorText	:= 'Warn AFE2: Emergency stop (off1 OR off3)';
	
	Error[175].ErrorID		:= 16#AFEA;
	Error[175].ErrorText	:= 'Warn AFEA: Enable start signal missing';
	
	Error[176].ErrorID		:= 16#AFE9;
	Error[176].ErrorText	:= 'Warn AFE9: Start delay';
	
	Error[177].ErrorID		:= 16#AFEB;
	Error[177].ErrorText	:= 'Warn AFEB: Run enable missing';
	
	Error[178].ErrorID		:= 16#AFEC;
	Error[178].ErrorText	:= 'Warn AFEC: External power signal missing';
	
	Error[179].ErrorID		:= 16#AFED;
	Error[179].ErrorText	:= 'Warn AFED: Enable to rotate';
	
	Error[180].ErrorID		:= 16#AFF6;
	Error[180].ErrorText	:= 'Warn AFF6: Identification run';
	
	Error[181].ErrorID		:= 16#AFF7;
	Error[181].ErrorText	:= 'Warn AFF7: Autophasing';
	
	Error[182].ErrorID		:= 16#B5A0;
	Error[182].ErrorText	:= 'Warn B5A0: STO event';
	
	Error[183].ErrorID		:= 16#B686;
	Error[183].ErrorText	:= 'Warn B686: Checksum mismatch';
	
	Error[184].ErrorID		:= 16#D200;
	Error[184].ErrorText	:= 'Warn D200: Brake slip at standstill2';
	
	Error[185].ErrorID		:= 16#D201;
	Error[185].ErrorText	:= 'Warn D201: Forward slow down LIMIT';
	
	Error[186].ErrorID		:= 16#D202;
	Error[186].ErrorText	:= 'Warn D202: Reverse slow down LIMIT';
	
	Error[187].ErrorID		:= 16#D205;
	Error[187].ErrorText	:= 'Warn D205: Forward stop limit';
	
	Error[188].ErrorID		:= 16#D206;
	Error[188].ErrorText	:= 'Warn D206: Reverse stop limit';
	
	Error[189].ErrorID		:= 16#D208;
	Error[189].ErrorText	:= 'Warn D208: Joystick reference check';
	
	Error[190].ErrorID		:= 16#D209;
	Error[190].ErrorText	:= 'Warn D209: Joystick zero position';
	
	Error[191].ErrorID		:= 16#D20A;
	Error[191].ErrorText	:= 'Warn D20A: Fast stop';
	
	Error[192].ErrorID		:= 16#D20B;
	Error[192].ErrorText	:= 'Warn D20B: Power on acknowledge';
	
	// ----------------------------------------------------------------------------------------
	// 								NO ERROR MESSAGE
	// ----------------------------------------------------------------------------------------
	
	Error[199].ErrorID		:= 16#0000;
	Error[199].ErrorText	:= '';
	
END_ACTION
