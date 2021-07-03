EESchema Schematic File Version 4
LIBS:sbus-to-ztex-cache
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 4 6
Title "sbus-to-ztex blinkey stuff"
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Connector_Generic:Conn_02x06_Odd_Even J5
U 1 1 60D925D5
P 5600 1750
F 0 "J5" H 5650 2167 50  0000 C CNN
F 1 "Conn_02x06_Odd_Even" H 5650 2076 50  0000 C CNN
F 2 "For_SeeedStudio:PinSocket_2x06_P2.54mm_Horizontal_For_SeeedStudio" H 5600 1750 50  0001 C CNN
F 3 "~" H 5600 1750 50  0001 C CNN
F 4 "A2541HWR-2x6P" H 5600 1750 50  0001 C CNN "MPN"
F 5 "https://lcsc.com/product-detail/Pin-Header-Female-Header_Changjiang-Connectors-A2541HWR-2x6P_C239357.html" H 5600 1750 50  0001 C CNN "URL"
	1    5600 1750
	1    0    0    -1  
$EndComp
Wire Wire Line
	5400 1550 5900 1550
Wire Wire Line
	5900 1550 6200 1550
Connection ~ 5900 1550
Wire Wire Line
	5400 1650 5900 1650
Wire Wire Line
	5900 1650 6400 1650
Connection ~ 5900 1650
$Comp
L power:GND #PWR0116
U 1 1 60D93843
P 6400 1650
F 0 "#PWR0116" H 6400 1400 50  0001 C CNN
F 1 "GND" H 6405 1477 50  0000 C CNN
F 2 "" H 6400 1650 50  0001 C CNN
F 3 "" H 6400 1650 50  0001 C CNN
	1    6400 1650
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR0120
U 1 1 60D938E0
P 6200 1550
F 0 "#PWR0120" H 6200 1400 50  0001 C CNN
F 1 "+3V3" H 6215 1723 50  0000 C CNN
F 2 "" H 6200 1550 50  0001 C CNN
F 3 "" H 6200 1550 50  0001 C CNN
	1    6200 1550
	1    0    0    -1  
$EndComp
Text GLabel 5900 2050 2    50   Input ~ 0
PMOD-12
Text GLabel 5400 1750 0    50   Input ~ 0
PMOD-5
Text GLabel 5900 1750 2    50   Input ~ 0
PMOD-6
Text GLabel 5400 1850 0    50   Input ~ 0
PMOD-7
Text GLabel 5900 1850 2    50   Input ~ 0
PMOD-8
Text GLabel 5400 1950 0    50   Input ~ 0
PMOD-9
Text GLabel 5900 1950 2    50   Input ~ 0
PMOD-10
Text GLabel 5400 2050 0    50   Input ~ 0
PMOD-11
Wire Wire Line
	2000 1800 1850 1800
Wire Wire Line
	1850 1800 1850 2000
Wire Wire Line
	2300 1800 2700 1800
$Comp
L Device:R R3
U 1 1 60DF1D6E
P 2850 1800
AR Path="/5F6B165A/60DF1D6E" Ref="R3"  Part="1" 
AR Path="/5F67E4B9/60DF1D6E" Ref="R?"  Part="1" 
F 0 "R3" V 2930 1800 50  0000 C CNN
F 1 "549" V 2850 1800 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 2780 1800 50  0001 C CNN
F 3 "" H 2850 1800 50  0000 C CNN
F 4 "0603WAF5490T5E" V 2850 1800 50  0001 C CNN "MPN"
	1    2850 1800
	0    1    1    0   
$EndComp
$Comp
L Device:LED_ALT D1
U 1 1 60DF1D7F
P 2150 1800
AR Path="/5F6B165A/60DF1D7F" Ref="D1"  Part="1" 
AR Path="/5F67E4B9/60DF1D7F" Ref="D?"  Part="1" 
F 0 "D1" H 2150 1900 50  0000 C CNN
F 1 "RED" H 1800 1800 50  0000 R CNN
F 2 "LED_SMD:LED_0805_2012Metric" H 2150 1800 50  0001 C CNN
F 3 "https://optoelectronics.liteon.com/upload/download/DS-22-99-0150/LTST-C170KRKT.pdf" H 2150 1800 50  0001 C CNN
F 4 "www.liteon.com" H 2150 1800 60  0001 C CNN "MNF1_URL"
F 5 "LTST-C170KRKT" H 2150 1800 60  0001 C CNN "MPN"
F 6 "859-LTST-C170KRKT" H 2150 1800 60  0001 C CNN "Mouser"
F 7 "743-IN-S85ATR" H 2150 1800 50  0001 C CNN "Mouse_r2"
F 8 "160-1415-1-ND" H 2150 1800 50  0001 C CNN "Digikey"
F 9 "C94868" H 2150 1800 50  0001 C CNN "LCSC"
F 10 "0.0195$" H 2150 1800 50  0001 C CNN "price400_LCSC"
F 11 "FV007" H 2150 1800 50  0001 C CNN "Koncar"
F 12 "TB" H 2150 1800 50  0001 C CNN "Side"
	1    2150 1800
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0134
U 1 1 60DF1D86
P 1850 2000
F 0 "#PWR0134" H 1850 1750 50  0001 C CNN
F 1 "GND" H 1855 1827 50  0000 C CNN
F 2 "" H 1850 2000 50  0001 C CNN
F 3 "" H 1850 2000 50  0001 C CNN
	1    1850 2000
	1    0    0    -1  
$EndComp
Text GLabel 3000 1800 2    60   Input ~ 12
LED0
Wire Wire Line
	2000 2400 1850 2400
Wire Wire Line
	1850 2400 1850 2600
Wire Wire Line
	2300 2400 2700 2400
$Comp
L Device:R R4
U 1 1 60DF1E35
P 2850 2400
AR Path="/5F6B165A/60DF1E35" Ref="R4"  Part="1" 
AR Path="/5F67E4B9/60DF1E35" Ref="R?"  Part="1" 
F 0 "R4" V 2930 2400 50  0000 C CNN
F 1 "549" V 2850 2400 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 2780 2400 50  0001 C CNN
F 3 "" H 2850 2400 50  0000 C CNN
F 4 "0603WAF5490T5E" V 2850 2400 50  0001 C CNN "MPN"
	1    2850 2400
	0    1    1    0   
$EndComp
$Comp
L Device:LED_ALT D2
U 1 1 60DF1E46
P 2150 2400
AR Path="/5F6B165A/60DF1E46" Ref="D2"  Part="1" 
AR Path="/5F67E4B9/60DF1E46" Ref="D?"  Part="1" 
F 0 "D2" H 2150 2500 50  0000 C CNN
F 1 "RED" H 1800 2400 50  0000 R CNN
F 2 "LED_SMD:LED_0805_2012Metric" H 2150 2400 50  0001 C CNN
F 3 "https://optoelectronics.liteon.com/upload/download/DS-22-99-0150/LTST-C170KRKT.pdf" H 2150 2400 50  0001 C CNN
F 4 "www.liteon.com" H 2150 2400 60  0001 C CNN "MNF1_URL"
F 5 "LTST-C170KRKT" H 2150 2400 60  0001 C CNN "MPN"
F 6 "859-LTST-C170KRKT" H 2150 2400 60  0001 C CNN "Mouser"
F 7 "743-IN-S85ATR" H 2150 2400 50  0001 C CNN "Mouse_r2"
F 8 "160-1415-1-ND" H 2150 2400 50  0001 C CNN "Digikey"
F 9 "C94868" H 2150 2400 50  0001 C CNN "LCSC"
F 10 "0.0195$" H 2150 2400 50  0001 C CNN "price400_LCSC"
F 11 "FV007" H 2150 2400 50  0001 C CNN "Koncar"
F 12 "TB" H 2150 2400 50  0001 C CNN "Side"
	1    2150 2400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0135
U 1 1 60DF1E4D
P 1850 2600
F 0 "#PWR0135" H 1850 2350 50  0001 C CNN
F 1 "GND" H 1855 2427 50  0000 C CNN
F 2 "" H 1850 2600 50  0001 C CNN
F 3 "" H 1850 2600 50  0001 C CNN
	1    1850 2600
	1    0    0    -1  
$EndComp
Text GLabel 3000 2400 2    60   Input ~ 12
LED1
$Comp
L Connector:Conn_01x03_Male J6
U 1 1 60E1E49E
P 4400 4750
F 0 "J6" H 4506 5028 50  0000 C CNN
F 1 "Conn_01x03_Male" H 4506 4937 50  0000 C CNN
F 2 "Connector_Molex:Molex_KK-254_AE-6410-03A_1x03_P2.54mm_Vertical" H 4400 4750 50  0001 C CNN
F 3 "~" H 4400 4750 50  0001 C CNN
F 4 "22-27-2031" H 4400 4750 50  0001 C CNN "MPN-ALT"
F 5 "Molex" H 4400 4750 50  0001 C CNN "Manufacturer-ALT"
F 6 "https://www.mouser.fr/ProductDetail/Molex/22-27-2031?qs=%2Fha2pyFadugXOaGYK9vaczm7nZ04txhJn3OGcnGWT3U=" H 4400 4750 50  0001 C CNN "URL-ALT"
F 7 "640456-3" H 4400 4750 50  0001 C CNN "MPN"
F 8 "TE Connectivity" H 4400 4750 50  0001 C CNN "Manufacturer"
	1    4400 4750
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0136
U 1 1 60E1EC2C
P 4600 4650
F 0 "#PWR0136" H 4600 4400 50  0001 C CNN
F 1 "GND" V 4605 4522 50  0000 R CNN
F 2 "" H 4600 4650 50  0001 C CNN
F 3 "" H 4600 4650 50  0001 C CNN
	1    4600 4650
	0    -1   -1   0   
$EndComp
$Comp
L power:+5V #PWR0137
U 1 1 60E1ED6C
P 4600 4750
F 0 "#PWR0137" H 4600 4600 50  0001 C CNN
F 1 "+5V" V 4615 4878 50  0000 L CNN
F 2 "" H 4600 4750 50  0001 C CNN
F 3 "" H 4600 4750 50  0001 C CNN
	1    4600 4750
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR0138
U 1 1 60E1FA97
P 4600 4850
F 0 "#PWR0138" H 4600 4600 50  0001 C CNN
F 1 "GND" V 4605 4722 50  0000 R CNN
F 2 "" H 4600 4850 50  0001 C CNN
F 3 "" H 4600 4850 50  0001 C CNN
	1    4600 4850
	0    -1   -1   0   
$EndComp
$Comp
L Device:C C?
U 1 1 60E24715
P 5150 4800
AR Path="/5F69F4EF/60E24715" Ref="C?"  Part="1" 
AR Path="/5F6B165A/60E24715" Ref="C6"  Part="1" 
F 0 "C6" H 5175 4900 50  0000 L CNN
F 1 "47uF" H 5175 4700 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 5188 4650 50  0001 C CNN
F 3 "" H 5150 4800 50  0000 C CNN
F 4 "GRM21BR60J476ME15L" H 5150 4800 50  0001 C CNN "MPN"
	1    5150 4800
	1    0    0    -1  
$EndComp
Wire Wire Line
	4600 4750 5150 4750
Wire Wire Line
	5150 4750 5150 4650
Connection ~ 4600 4750
Wire Wire Line
	4600 4850 5150 4850
Wire Wire Line
	5150 4850 5150 4950
Connection ~ 4600 4850
$EndSCHEMATC
