EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 9 9
Title "sbus-to-ztex blinkey stuff"
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text GLabel 7150 3500 0    50   Input ~ 0
PMOD-56-
Text GLabel 7150 3600 0    50   Input ~ 0
PMOD-78-
Text GLabel 7150 3700 0    50   Input ~ 0
PMOD-910-
Text GLabel 7150 3800 0    50   Input ~ 0
PMOD-1112-
Text GLabel 7650 3800 2    50   Input ~ 0
PMOD-1112+
Text GLabel 7650 3500 2    50   Input ~ 0
PMOD-56+
Text GLabel 7650 3600 2    50   Input ~ 0
PMOD-78+
Text GLabel 7650 3700 2    50   Input ~ 0
PMOD-910+
$Comp
L power:GND #PWR0103
U 1 1 634673C0
P 8150 3400
F 0 "#PWR0103" H 8150 3150 50  0001 C CNN
F 1 "GND" H 8155 3227 50  0000 C CNN
F 2 "" H 8150 3400 50  0001 C CNN
F 3 "" H 8150 3400 50  0001 C CNN
	1    8150 3400
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR0135
U 1 1 634673C6
P 7950 3300
F 0 "#PWR0135" H 7950 3150 50  0001 C CNN
F 1 "+3V3" H 7965 3473 50  0000 C CNN
F 2 "" H 7950 3300 50  0001 C CNN
F 3 "" H 7950 3300 50  0001 C CNN
	1    7950 3300
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 634673D3
P 8150 3250
AR Path="/5F679B53/634673D3" Ref="C?"  Part="1" 
AR Path="/5F6B165A/634673D3" Ref="C?"  Part="1" 
AR Path="/61631F14/634673D3" Ref="C?"  Part="1" 
AR Path="/62CC4C0A/634673D3" Ref="C15"  Part="1" 
AR Path="/64C195EA/634673D3" Ref="C15"  Part="1" 
AR Path="/64DE57E5/634673D3" Ref="C21"  Part="1" 
AR Path="/65E2A490/634673D3" Ref="C15"  Part="1" 
AR Path="/65499504/634673D3" Ref="C1"  Part="1" 
F 0 "C1" H 8175 3350 50  0000 L CNN
F 1 "100nF" H 8175 3150 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric" H 8188 3100 50  0001 C CNN
F 3 "" H 8150 3250 50  0000 C CNN
F 4 "" H 8150 3250 50  0001 C CNN "MNF1_URL"
F 5 "CL05B104KO5NNNC" H 8150 3250 50  0001 C CNN "MPN"
F 6 "" H 8150 3250 50  0001 C CNN "Mouser"
F 7 "" H 8150 3250 50  0001 C CNN "Digikey"
F 8 "" H 8150 3250 50  0001 C CNN "LCSC"
F 9 "" H 8150 3250 50  0001 C CNN "Koncar"
F 10 "" H 8150 3250 50  0001 C CNN "Side"
F 11 "" H 3000 6050 50  0001 C CNN "URL"
	1    8150 3250
	1    0    0    -1  
$EndComp
Wire Wire Line
	7950 3300 8050 3300
Wire Wire Line
	8050 3300 8050 3100
Wire Wire Line
	8050 3100 8150 3100
Text GLabel 7725 4550 2    50   Input ~ 0
PMOD-1314+
Text GLabel 7725 4650 2    50   Input ~ 0
PMOD-1516+
Text GLabel 7075 4550 0    50   Input ~ 0
PMOD-1314-
Text GLabel 7075 4650 0    50   Input ~ 0
PMOD-1516-
Text Notes 7275 4700 0    50   ~ 0
Extra Pins
Connection ~ 7950 3300
Connection ~ 8150 3400
$Comp
L Connector_Generic:Conn_02x06_Odd_Even J1
U 1 1 63467144
P 7350 3500
F 0 "J1" H 7400 4017 50  0000 C CNN
F 1 "A2541HWR-2x6P (Pmod 2x6 F R)" H 7400 3926 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_2x06_P2.54mm_Horizontal" H 7350 3500 50  0001 C CNN
F 3 "~" H 7350 3500 50  0001 C CNN
F 4 "A2541HWR-2x6P" H 7350 3500 50  0001 C CNN "MPN-ALT"
F 5 "DW254W-22-12-85" H 7350 3500 50  0001 C CNN "MPN"
	1    7350 3500
	1    0    0    -1  
$EndComp
Wire Wire Line
	7650 3300 7950 3300
Wire Wire Line
	7650 3400 8150 3400
Wire Wire Line
	7650 3300 7150 3300
Connection ~ 7650 3300
Wire Wire Line
	7150 3400 7650 3400
Connection ~ 7650 3400
$EndSCHEMATC
