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
F 2 "Connector_PinSocket_2.54mm:PinSocket_2x06_P2.54mm_Horizontal" H 5600 1750 50  0001 C CNN
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
$EndSCHEMATC
