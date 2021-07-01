EESchema Schematic File Version 4
LIBS:sbus-to-ztex-cache
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 3 6
Title "sbus-to-ztex B2B connector"
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L ztex_AB:ZTEX_AB JAB1
U 1 1 5F676E85
P 1800 2650
AR Path="/5F676E85" Ref="JAB1"  Part="1" 
AR Path="/5F67E4B9/5F676E85" Ref="JAB1"  Part="1" 
F 0 "JAB1" H 1825 4375 50  0000 C CNN
F 1 "ZTEX_AB-ztex_AB" H 1825 4284 50  0000 C CNN
F 2 "For_SeeedStudio:PinHeader_2x32_P2.54mm_Vertical_For_SeeedStudio" H 1800 2650 50  0001 C CNN
F 3 "" H 1800 2650 50  0001 C CNN
F 4 "10-89-7642" H 1800 2650 50  0001 C CNN "MPN"
F 5 "https://www2.mouser.com/ProductDetail/Molex/10-89-7642?qs=%2Fha2pyFadugCxzQFZUdvioDcljDVidgd4vXrOFuSRYM%3D" H 1800 2650 50  0001 C CNN "URL"
	1    1800 2650
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0160
U 1 1 5F677F4B
P 2400 1000
F 0 "#PWR0160" H 2400 850 50  0001 C CNN
F 1 "+5V" H 2415 1173 50  0000 C CNN
F 2 "" H 2400 1000 50  0001 C CNN
F 3 "" H 2400 1000 50  0001 C CNN
	1    2400 1000
	1    0    0    -1  
$EndComp
Text Notes 9950 6500 0    50   ~ 0
Clock capable inputs (MRCC and SRCC, MRCC are multi-domain)\nFor 2.13:\nB9 G16~IO_L13N_T2_MRCC_15 G16\nB10 H16~IO_L13P_T2_MRCC_15 H16\nB11 F16~IO_L14N_T2_SRCC_15 F16\nB12 F15~IO_L14P_T2_SRCC_15 F15\nA19 E16~IO_L11N_T1_SRCC_15 E16\nB19 E15~IO_L11P_T1_SRCC_15 E15\nA22 C15~IO_L12N_T1_MRCC_15 C15\nB22 D15~IO_L12P_T1_MRCC_15 D15\nD8 T5~IO_L12P_T1_MRCC_34 T5\nD9 T4~IO_L12N_T1_MRCC_34 T4\nD14 T3~IO_L11N_T1_SRCC_34 T3\nD15 R3~IO_L11P_T1_SRCC_34 R3\nD19 P5~IO_L13N_T2_MRCC_34 P5\nD20 N5~IO_L13P_T2_MRCC_34 N5\nD21 P4~IO_L14P_T2_SRCC_34 P4\nD22 P3~IO_L14N_T2_SRCC_34 P3\n\nUnfortunately various 2.1x modules have different clock assignment. B22 hsould be a P-side MRCC for 2.14 (perhaps 2.18), but is a n-side SRCC on 2.16 so not usable there.
Text GLabel 4100 3250 2    60   Input ~ 0
SBUS_3V3_CLK
Wire Wire Line
	1450 2550 1450 2750
Wire Wire Line
	7150 2650 7150 2850
Wire Wire Line
	7150 2850 6700 2850
Text GLabel 4100 1350 2    60   Input ~ 0
SBUS_3V3_D[00]
Text GLabel 1600 1350 0    60   Input ~ 0
SBUS_3V3_D[01]
Text GLabel 4100 1450 2    60   Input ~ 0
SBUS_3V3_D[02]
Text GLabel 1600 1450 0    60   Input ~ 0
SBUS_3V3_D[03]
Text GLabel 4100 1550 2    60   Input ~ 0
SBUS_3V3_D[04]
Text GLabel 1600 1550 0    60   Input ~ 0
SBUS_3V3_D[05]
Text GLabel 4100 1650 2    60   Input ~ 0
SBUS_3V3_D[06]
Text GLabel 1600 1750 0    60   Input ~ 0
SBUS_3V3_D[07]
Text GLabel 1600 2150 0    60   Input ~ 0
SBUS_3V3_D[15]
Text GLabel 4100 2050 2    60   Input ~ 0
SBUS_3V3_D[14]
Text GLabel 1600 2050 0    60   Input ~ 0
SBUS_3V3_D[13]
Text GLabel 4100 1950 2    60   Input ~ 0
SBUS_3V3_D[12]
Text GLabel 1600 1850 0    60   Input ~ 0
SBUS_3V3_D[09]
Text GLabel 4100 1750 2    60   Input ~ 0
SBUS_3V3_D[08]
Text GLabel 1600 1950 0    60   Input ~ 0
SBUS_3V3_D[11]
Text GLabel 4100 1850 2    60   Input ~ 0
SBUS_3V3_D[10]
Text GLabel 4100 2150 2    60   Input ~ 0
SBUS_3V3_D[16]
Text GLabel 1600 2250 0    60   Input ~ 0
SBUS_3V3_D[17]
Text GLabel 4100 2250 2    60   Input ~ 0
SBUS_3V3_D[18]
Text GLabel 1600 2350 0    60   Input ~ 0
SBUS_3V3_D[19]
Text GLabel 4100 2350 2    60   Input ~ 0
SBUS_3V3_D[20]
Text GLabel 1600 2450 0    60   Input ~ 0
SBUS_3V3_D[21]
Text GLabel 4100 2450 2    60   Input ~ 0
SBUS_3V3_D[22]
Text GLabel 1600 2850 0    60   Input ~ 0
SBUS_3V3_D[23]
Text GLabel 1600 3250 0    60   Input ~ 0
SBUS_3V3_D[31]
Text GLabel 4100 3150 2    60   Input ~ 0
SBUS_3V3_D[30]
Text GLabel 1600 3150 0    60   Input ~ 0
SBUS_3V3_D[29]
Text GLabel 4100 3050 2    60   Input ~ 0
SBUS_3V3_D[28]
Text GLabel 1600 3050 0    60   Input ~ 0
SBUS_3V3_D[27]
Text GLabel 4100 2950 2    60   Input ~ 0
SBUS_3V3_D[26]
Text GLabel 1600 2950 0    60   Input ~ 0
SBUS_3V3_D[25]
Text GLabel 4100 2850 2    60   Input ~ 0
SBUS_3V3_D[24]
Text GLabel 6650 5700 2    60   Input ~ 0
SBUS_3V3_INT[7]*
Text GLabel 6300 5850 0    60   Input ~ 0
SBUS_3V3_INT[6]*
Text GLabel 6300 5950 0    60   Input ~ 0
SBUS_3V3_INT[5]*
Text GLabel 9900 3050 2    60   Input ~ 0
SBUS_3V3_INT[4]*
Text GLabel 9900 2550 2    60   Input ~ 0
SBUS_3V3_INT[3]*
Text GLabel 1600 1650 0    60   Input ~ 0
SBUS_3V3_INT[2]*
Text GLabel 7400 2250 0    60   Input ~ 0
SBUS_3V3_INT[1]*
Text GLabel 4100 3350 2    60   Input ~ 0
SBUS_3V3_PA[00]
Text GLabel 1600 3350 0    60   Input ~ 0
SBUS_3V3_PA[01]
Text GLabel 4100 3450 2    60   Input ~ 0
SBUS_3V3_PA[02]
Text GLabel 1600 3450 0    60   Input ~ 0
SBUS_3V3_PA[03]
Text GLabel 4100 3550 2    60   Input ~ 0
SBUS_3V3_PA[04]
Text GLabel 1600 3650 0    60   Input ~ 0
SBUS_3V3_PA[05]
Text GLabel 4100 3650 2    60   Input ~ 0
SBUS_3V3_PA[06]
Text GLabel 1600 3750 0    60   Input ~ 0
SBUS_3V3_PA[07]
Text GLabel 7400 3450 0    60   Input ~ 0
SBUS_3V3_PA[15]
Text GLabel 4100 4050 2    60   Input ~ 0
SBUS_3V3_PA[14]
Text GLabel 1600 4050 0    60   Input ~ 0
SBUS_3V3_PA[13]
Text GLabel 4100 3950 2    60   Input ~ 0
SBUS_3V3_PA[12]
Text GLabel 1600 3950 0    60   Input ~ 0
SBUS_3V3_PA[11]
Text GLabel 4100 3850 2    60   Input ~ 0
SBUS_3V3_PA[10]
Text GLabel 1600 3850 0    60   Input ~ 0
SBUS_3V3_PA[09]
Text GLabel 4100 3750 2    60   Input ~ 0
SBUS_3V3_PA[08]
Text GLabel 9900 3550 2    60   Input ~ 0
SBUS_3V3_PA[16]
Text GLabel 7400 3550 0    60   Input ~ 0
SBUS_3V3_PA[17]
Text GLabel 9900 3650 2    60   Input ~ 0
SBUS_3V3_PA[18]
Text GLabel 7400 3650 0    60   Input ~ 0
SBUS_3V3_PA[19]
Text GLabel 9900 3750 2    60   Input ~ 0
SBUS_3V3_PA[20]
Text GLabel 7400 3750 0    60   Input ~ 0
SBUS_3V3_PA[21]
Text GLabel 9900 3850 2    60   Input ~ 0
SBUS_3V3_PA[22]
Text GLabel 7400 3850 0    60   Input ~ 0
SBUS_3V3_PA[23]
Text GLabel 7400 2450 0    60   Input ~ 0
SBUS_3V3_RST*
Text GLabel 7400 4050 0    60   Input ~ 0
SBUS_3V3_PA[27]
Text GLabel 9900 4050 2    60   Input ~ 0
SBUS_3V3_PA[26]
Text GLabel 7400 3950 0    60   Input ~ 0
SBUS_3V3_PA[25]
Text GLabel 9900 3950 2    60   Input ~ 0
SBUS_3V3_PA[24]
Text GLabel 5550 6450 2    60   Input ~ 0
SBUS_3V3_DP
Text GLabel 7400 2050 0    60   Input ~ 0
SBUS_3V3_SIZ[0]
Text GLabel 9900 2150 2    60   Input ~ 0
SBUS_3V3_SIZ[1]
Text GLabel 9900 2250 2    60   Input ~ 0
SBUS_3V3_SIZ[2]
Text GLabel 7400 2150 0    60   Input ~ 0
SBUS_3V3_BR*
Text GLabel 7400 2550 0    60   Input ~ 0
SBUS_3V3_SEL*
Text GLabel 7400 1950 0    60   Input ~ 0
SBUS_3V3_BG*
Text GLabel 9900 1950 2    60   Input ~ 0
SBUS_3V3_AS*
Text GLabel 7400 3350 0    60   Input ~ 0
SBUS_3V3_ACK[2]*
Text GLabel 7400 3150 0    60   Input ~ 0
SBUS_3V3_ACK[1]*
Text GLabel 7400 3050 0    60   Input ~ 0
SBUS_3V3_ACK[0]*
Text GLabel 7400 2950 0    60   Input ~ 0
SBUS_3V3_PPRD
Text GLabel 7400 2350 0    60   Input ~ 0
SBUS_3V3_EER*
Wire Wire Line
	1800 5850 1650 5850
Wire Wire Line
	1650 5850 1650 6050
Wire Wire Line
	2100 5850 2500 5850
$Comp
L Device:R R?
U 1 1 5F6BAF48
P 2650 5850
AR Path="/5F6B165A/5F6BAF48" Ref="R?"  Part="1" 
AR Path="/5F67E4B9/5F6BAF48" Ref="ROE1"  Part="1" 
F 0 "ROE1" V 2730 5850 50  0000 C CNN
F 1 "549" V 2650 5850 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 2580 5850 50  0001 C CNN
F 3 "" H 2650 5850 50  0000 C CNN
F 4 "0603WAF5490T5E" V 2650 5850 50  0001 C CNN "MPN"
	1    2650 5850
	0    1    1    0   
$EndComp
Text Label 2150 5850 0    60   ~ 0
DATA_OE_LED
$Comp
L Device:LED_ALT D?
U 1 1 5F6BAF59
P 1950 5850
AR Path="/5F6B165A/5F6BAF59" Ref="D?"  Part="1" 
AR Path="/5F67E4B9/5F6BAF59" Ref="DOE1"  Part="1" 
F 0 "DOE1" H 1950 5950 50  0000 C CNN
F 1 "RED" H 1600 5850 50  0000 R CNN
F 2 "LED_SMD:LED_0805_2012Metric" H 1950 5850 50  0001 C CNN
F 3 "https://optoelectronics.liteon.com/upload/download/DS-22-99-0150/LTST-C170KRKT.pdf" H 1950 5850 50  0001 C CNN
F 4 "www.liteon.com" H 1950 5850 60  0001 C CNN "MNF1_URL"
F 5 "LTST-C170KRKT" H 1950 5850 60  0001 C CNN "MPN"
F 6 "859-LTST-C170KRKT" H 1950 5850 60  0001 C CNN "Mouser"
F 7 "743-IN-S85ATR" H 1950 5850 50  0001 C CNN "Mouse_r2"
F 8 "160-1415-1-ND" H 1950 5850 50  0001 C CNN "Digikey"
F 9 "C94868" H 1950 5850 50  0001 C CNN "LCSC"
F 10 "0.0195$" H 1950 5850 50  0001 C CNN "price400_LCSC"
F 11 "FV007" H 1950 5850 50  0001 C CNN "Koncar"
F 12 "TB" H 1950 5850 50  0001 C CNN "Side"
	1    1950 5850
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0103
U 1 1 5F693C4E
P 1650 6050
F 0 "#PWR0103" H 1650 5800 50  0001 C CNN
F 1 "GND" H 1655 5877 50  0000 C CNN
F 2 "" H 1650 6050 50  0001 C CNN
F 3 "" H 1650 6050 50  0001 C CNN
	1    1650 6050
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x06_Male J1
U 1 1 5F69129B
P 9250 850
F 0 "J1" H 9356 1228 50  0000 C CNN
F 1 "Conn_01x06_Male" H 9356 1137 50  0000 C CNN
F 2 "For_SeeedStudio:PinHeader_1x06_P2.54mm_Horizontal_For_SeeedStudio" H 9250 850 50  0001 C CNN
F 3 "~" H 9250 850 50  0001 C CNN
F 4 "22-28-8060" H 9250 850 50  0001 C CNN "MPN-ALT"
F 5 "PZ254R-11-06P" H 9250 850 50  0001 C CNN "MPN"
F 6 "https://www2.mouser.com/ProductDetail/Molex/22-28-8060?qs=4XSMV6Twtb2rYD%2F%2F316gfQ==" H 9250 850 50  0001 C CNN "URL-ALT"
	1    9250 850 
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0163
U 1 1 5F6913A1
P 9950 650
F 0 "#PWR0163" H 9950 400 50  0001 C CNN
F 1 "GND" H 9955 477 50  0000 C CNN
F 2 "" H 9950 650 50  0001 C CNN
F 3 "" H 9950 650 50  0001 C CNN
	1    9950 650 
	1    0    0    -1  
$EndComp
Wire Wire Line
	9450 650  9950 650 
Wire Wire Line
	9450 950  7150 950 
Wire Wire Line
	7150 950  7150 1350
Text Label 9450 1050 0    50   ~ 0
TX
Text Label 9450 950  0    50   ~ 0
RX
Text GLabel 9900 1450 2    60   Input ~ 0
SD_D2
Text GLabel 9900 1550 2    60   Input ~ 0
SD_D3
Text GLabel 9900 1850 2    60   Input ~ 0
SD_CMD
Text GLabel 7400 1850 0    60   Input ~ 0
SD_CLK
Text GLabel 9900 1650 2    60   Input ~ 0
SD_D0
Text GLabel 9900 1750 2    60   Input ~ 0
SD_D1
$Comp
L ztex_CD:ZTEX_CD JCD1
U 1 1 5F676F65
P 7600 2650
AR Path="/5F676F65" Ref="JCD1"  Part="1" 
AR Path="/5F67E4B9/5F676F65" Ref="JCD1"  Part="1" 
F 0 "JCD1" H 7650 4375 50  0000 C CNN
F 1 "ZTEX_CD-ztex_CD" H 7650 4284 50  0000 C CNN
F 2 "For_SeeedStudio:PinHeader_2x32_P2.54mm_Vertical_For_SeeedStudio" H 7600 2650 50  0001 C CNN
F 3 "" H 7600 2650 50  0001 C CNN
F 4 "10-89-7642" H 7600 2650 50  0001 C CNN "MPN"
F 5 "https://www2.mouser.com/ProductDetail/Molex/10-89-7642?qs=%2Fha2pyFadugCxzQFZUdvioDcljDVidgd4vXrOFuSRYM%3D" H 7600 2650 50  0001 C CNN "URL"
	1    7600 2650
	1    0    0    -1  
$EndComp
Text GLabel 2800 5850 2    60   Input ~ 12
SBUS_DATA_OE_LED
Text Notes 5500 5550 0    50   ~ 0
Unconnected,\nsee SBus page
Text GLabel 9900 2950 2    60   Input ~ 12
SBUS_OE
Text GLabel 9900 2350 2    60   Input ~ 12
SBUS_DATA_OE_LED
$Comp
L Connector_Generic:Conn_02x07_Odd_Even J3
U 1 1 5F749BE1
P 3150 7250
F 0 "J3" H 3200 7767 50  0000 C CNN
F 1 "Conn_02x07_Odd_Even" H 3200 7676 50  0000 C CNN
F 2 "For_SeeedStudio:PinHeader_2x07_P2.00mm_Horizontal_For_SeeedStudio" H 3150 7250 50  0001 C CNN
F 3 "https://www.molex.com/pdm_docs/sd/878331420_sd.pdf" H 3150 7250 50  0001 C CNN
F 4 "87833-1420" H 3150 7250 50  0001 C CNN "MPN"
F 5 "A2005WR-N-2X7P-B" H 3150 7250 50  0001 C CNN "MPN-ALT"
F 6 "https://www2.mouser.com/ProductDetail/Molex/87833-1420?qs=%2Fha2pyFadujYFYCIYI1IvFCvLi7no9WQYzIL%2FpYxKhg%3D" H 3150 7250 50  0001 C CNN "URL"
	1    3150 7250
	1    0    0    -1  
$EndComp
Text HLabel 9900 4150 2    50   Input ~ 0
JTAG_TMS
Text HLabel 7400 4150 0    50   Input ~ 0
JTAG_TDO
Text HLabel 1600 4150 0    50   Input ~ 0
JTAG_TDI
Text HLabel 4100 4150 2    50   Input ~ 0
JTAG_TCK
Text HLabel 1600 4250 0    50   Input ~ 0
JTAG_VIO
Text HLabel 3450 7350 2    50   Input ~ 0
JTAG_TDI
Text HLabel 3450 7250 2    50   Input ~ 0
JTAG_TDO
Text HLabel 3450 7150 2    50   Input ~ 0
JTAG_TCK
Text HLabel 3450 7050 2    50   Input ~ 0
JTAG_TMS
Text HLabel 3450 6950 2    50   Input ~ 0
JTAG_VIO
Wire Wire Line
	2950 6950 2950 7050
Connection ~ 2950 7050
Wire Wire Line
	2950 7050 2950 7150
Connection ~ 2950 7150
Wire Wire Line
	2950 7150 2950 7250
Connection ~ 2950 7250
Wire Wire Line
	2950 7250 2950 7350
Connection ~ 2950 7350
Wire Wire Line
	2950 7350 2950 7450
Connection ~ 2950 7450
$Comp
L power:GND #PWR0121
U 1 1 5F755CF4
P 2700 7550
F 0 "#PWR0121" H 2700 7300 50  0001 C CNN
F 1 "GND" H 2705 7377 50  0000 C CNN
F 2 "" H 2700 7550 50  0001 C CNN
F 3 "" H 2700 7550 50  0001 C CNN
	1    2700 7550
	1    0    0    -1  
$EndComp
Wire Wire Line
	2950 7450 2700 7450
Wire Wire Line
	2700 7450 2700 7550
Text Notes 2850 7650 0    50   ~ 0
PGND
Text Notes 3500 7600 0    50   ~ 0
HALT
Text Notes 3500 7500 0    50   ~ 0
NC
Wire Wire Line
	2950 7550 2950 7450
Wire Wire Line
	7150 2650 7400 2650
Wire Wire Line
	7150 1350 7400 1350
Wire Wire Line
	1450 2550 1600 2550
Wire Wire Line
	1450 2750 1600 2750
Wire Wire Line
	500  2650 1600 2650
Wire Wire Line
	1600 1250 4100 1250
Wire Wire Line
	1600 1250 500  1250
Wire Wire Line
	500  1250 500  2650
Connection ~ 1600 1250
Connection ~ 500  2650
Wire Wire Line
	500  4450 4100 4450
Wire Wire Line
	4100 4450 4100 4250
Wire Wire Line
	500  2650 500  4450
Wire Wire Line
	4100 4450 5800 4450
Wire Wire Line
	7400 4250 7400 4450
Connection ~ 4100 4450
Wire Wire Line
	7400 4450 9900 4450
Wire Wire Line
	9900 4450 9900 4250
Connection ~ 7400 4450
Wire Wire Line
	7400 2750 5800 2750
Connection ~ 5800 4450
Wire Wire Line
	5800 4450 7400 4450
$Comp
L power:GND #PWR0117
U 1 1 5F8F4D66
P 5800 4450
F 0 "#PWR0117" H 5800 4200 50  0001 C CNN
F 1 "GND" H 5805 4277 50  0000 C CNN
F 2 "" H 5800 4450 50  0001 C CNN
F 3 "" H 5800 4450 50  0001 C CNN
	1    5800 4450
	1    0    0    -1  
$EndComp
Wire Wire Line
	4100 2650 5800 2650
Wire Wire Line
	5800 2650 5800 2750
Connection ~ 5800 2750
Wire Wire Line
	5800 2750 5800 4450
Wire Wire Line
	7400 1250 5800 1250
Wire Wire Line
	5800 1250 5800 2650
Connection ~ 5800 2650
Wire Wire Line
	4100 1250 5800 1250
Connection ~ 4100 1250
Connection ~ 5800 1250
Wire Wire Line
	9900 1250 11000 1250
Connection ~ 9900 4450
Wire Wire Line
	4100 2550 2900 2550
Connection ~ 1600 2550
Wire Wire Line
	1600 2750 2900 2750
Connection ~ 1600 2750
Wire Wire Line
	4100 1150 4100 1000
Wire Wire Line
	4100 1000 2400 1000
Wire Wire Line
	2400 1000 1600 1000
Wire Wire Line
	1600 1000 1600 1150
Connection ~ 2400 1000
Wire Wire Line
	2900 2550 2900 2750
Connection ~ 2900 2550
Wire Wire Line
	2900 2550 1600 2550
Connection ~ 2900 2750
Wire Wire Line
	2900 2750 4100 2750
Wire Wire Line
	9900 2850 8550 2850
Wire Wire Line
	7400 2850 7150 2850
Connection ~ 7400 2850
Connection ~ 7150 2850
Wire Wire Line
	7400 2650 8550 2650
Connection ~ 7400 2650
Wire Wire Line
	9900 2750 11000 2750
Wire Wire Line
	8550 2650 8550 2850
Connection ~ 8550 2650
Wire Wire Line
	8550 2650 9900 2650
Connection ~ 8550 2850
Wire Wire Line
	8550 2850 7400 2850
Wire Wire Line
	4100 2550 6250 2550
Wire Wire Line
	6250 2550 6250 2700
Wire Wire Line
	6250 2700 6700 2700
Connection ~ 4100 2550
Wire Wire Line
	6700 2700 6700 2850
$Comp
L power:+3V3 #PWR0119
U 1 1 5F90D7B8
P 6250 2550
F 0 "#PWR0119" H 6250 2400 50  0001 C CNN
F 1 "+3V3" H 6265 2723 50  0000 C CNN
F 2 "" H 6250 2550 50  0001 C CNN
F 3 "" H 6250 2550 50  0001 C CNN
	1    6250 2550
	1    0    0    -1  
$EndComp
Connection ~ 6250 2550
Wire Wire Line
	11000 1250 11000 2750
Connection ~ 11000 2750
Wire Wire Line
	11000 2750 11000 4450
Wire Wire Line
	11000 4450 9900 4450
$Comp
L power:GND #PWR0122
U 1 1 5F912C94
P 11000 4450
F 0 "#PWR0122" H 11000 4200 50  0001 C CNN
F 1 "GND" H 11005 4277 50  0000 C CNN
F 2 "" H 11000 4450 50  0001 C CNN
F 3 "" H 11000 4450 50  0001 C CNN
	1    11000 4450
	1    0    0    -1  
$EndComp
Connection ~ 11000 4450
$Comp
L power:GND #PWR0123
U 1 1 5F912D7C
P 500 4450
F 0 "#PWR0123" H 500 4200 50  0001 C CNN
F 1 "GND" H 505 4277 50  0000 C CNN
F 2 "" H 500 4450 50  0001 C CNN
F 3 "" H 500 4450 50  0001 C CNN
	1    500  4450
	1    0    0    -1  
$EndComp
Connection ~ 500  4450
Wire Wire Line
	10200 1050 10200 1350
Wire Wire Line
	10200 1350 9900 1350
Wire Wire Line
	9450 1050 10200 1050
Text GLabel 7400 1450 0    50   Input ~ 0
USBH0_D+
Text GLabel 7400 1550 0    50   Input ~ 0
USBH0_D-
Text GLabel 7400 1650 0    50   Input ~ 0
PMOD-12
Text GLabel 9900 3450 2    50   Input ~ 0
PMOD-5
Text GLabel 9900 2450 2    50   Input ~ 0
PMOD-6
Text GLabel 9900 3350 2    50   Input ~ 0
PMOD-7
Text GLabel 9900 2050 2    50   Input ~ 0
PMOD-8
Text GLabel 9900 3250 2    50   Input ~ 0
PMOD-9
Text GLabel 9900 3150 2    50   Input ~ 0
PMOD-10
Text GLabel 7400 1750 0    50   Input ~ 0
PMOD-11
Text GLabel 1600 3550 0    60   Input ~ 12
LED0
Text GLabel 7400 3250 0    60   Input ~ 12
LED1
$EndSCHEMATC
