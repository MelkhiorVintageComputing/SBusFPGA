EESchema Schematic File Version 4
LIBS:sbus-to-ztex-cache
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 6 6
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Connector:USB_B_Micro J4
U 1 1 60D9A6A3
P 5000 2800
F 0 "J4" H 5055 3267 50  0000 C CNN
F 1 "USB_B_Micro" H 5055 3176 50  0000 C CNN
F 2 "Connector_USB:USB_Micro-B_Molex-105017-0001" H 5150 2750 50  0001 C CNN
F 3 "https://www.molex.com/pdm_docs/sd/1050170001_sd.pdf" H 5150 2750 50  0001 C CNN
F 4 "WM1399CT-ND" H 5000 2800 50  0001 C CNN "Digi-Key_PN"
F 5 "1050170001" H 5000 2800 50  0001 C CNN "MPN"
F 6 "CONN RCPT USB2.0 MICRO B SMD R/A" H 5000 2800 50  0001 C CNN "Description"
F 7 "Molex" H 5000 2800 50  0001 C CNN "Manufacturer"
	1    5000 2800
	-1   0    0    -1  
$EndComp
$Comp
L Power_Management:TPS2041B U7
U 1 1 60D9A6AC
P 6700 2800
F 0 "U7" H 6700 3267 50  0000 C CNN
F 1 "TPS2065" H 6700 3176 50  0000 C CNN
F 2 "Package_TO_SOT_SMD:SOT-23-5" H 6700 3300 50  0001 C CNN
F 3 "" H 6650 3100 50  0001 C CNN
F 4 "TPS2065CDBVT-2" H 6700 2800 50  0001 C CNN "MPN"
F 5 "595-TPS2065CDBVT-2" H 6700 2800 50  0001 C CNN "Mouser No"
	1    6700 2800
	1    0    0    -1  
$EndComp
Text Label 7400 2800 0    50   ~ 0
VBus
Wire Wire Line
	7400 2800 7200 2800
$Comp
L power:GND #PWR0126
U 1 1 60D9A6B5
P 6700 3400
F 0 "#PWR0126" H 6700 3150 50  0001 C CNN
F 1 "GND" H 6705 3227 50  0000 C CNN
F 2 "" H 6700 3400 50  0001 C CNN
F 3 "" H 6700 3400 50  0001 C CNN
	1    6700 3400
	1    0    0    -1  
$EndComp
Wire Wire Line
	7200 2600 7400 2600
Text GLabel 7400 2600 2    50   Input ~ 0
+5V
Wire Wire Line
	6200 2600 6000 2600
Text Label 6000 2600 2    50   ~ 0
USB_FLT
Text Label 6000 3000 2    50   ~ 0
USB_EN
$Comp
L Device:R R?
U 1 1 60D9A6C2
P 6200 2450
AR Path="/5F6B165A/60D9A6C2" Ref="R?"  Part="1" 
AR Path="/5F679B53/60D9A6C2" Ref="R?"  Part="1" 
AR Path="/5F69F4EF/60D9A6C2" Ref="R?"  Part="1" 
AR Path="/60D72F2C/60D9A6C2" Ref="R19"  Part="1" 
F 0 "R19" V 6280 2450 50  0000 C CNN
F 1 "10k" V 6200 2450 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 6130 2450 50  0001 C CNN
F 3 "" H 6200 2450 50  0000 C CNN
F 4 "0603WAF1002T5E" V 6200 1850 50  0001 C CNN "MPN"
	1    6200 2450
	-1   0    0    1   
$EndComp
Connection ~ 6200 2600
Wire Wire Line
	6200 2300 6200 2100
Text GLabel 6250 2100 2    50   Input ~ 0
+3V3
$Comp
L Device:R R?
U 1 1 60D9A6CD
P 6100 2850
AR Path="/5F6B165A/60D9A6CD" Ref="R?"  Part="1" 
AR Path="/5F679B53/60D9A6CD" Ref="R?"  Part="1" 
AR Path="/5F69F4EF/60D9A6CD" Ref="R?"  Part="1" 
AR Path="/60D72F2C/60D9A6CD" Ref="R18"  Part="1" 
F 0 "R18" V 6180 2850 50  0000 C CNN
F 1 "10k" V 6100 2850 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 6030 2850 50  0001 C CNN
F 3 "" H 6100 2850 50  0000 C CNN
F 4 "0603WAF1002T5E" V 6100 2250 50  0001 C CNN "MPN"
	1    6100 2850
	-1   0    0    1   
$EndComp
Wire Wire Line
	6100 2700 6100 2100
Wire Wire Line
	6100 2100 6200 2100
Wire Wire Line
	6250 2100 6200 2100
Connection ~ 6200 2100
Wire Wire Line
	7200 1850 7400 1850
Text GLabel 7400 1850 2    50   Input ~ 0
+5V
$Comp
L Device:C C?
U 1 1 60D9A6E1
P 7200 2000
AR Path="/5F679B53/60D9A6E1" Ref="C?"  Part="1" 
AR Path="/5F69F4EF/60D9A6E1" Ref="C?"  Part="1" 
AR Path="/60D72F2C/60D9A6E1" Ref="C5"  Part="1" 
F 0 "C5" H 7225 2100 50  0000 L CNN
F 1 "100nF" H 7225 1900 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 7238 1850 50  0001 C CNN
F 3 "" H 7200 2000 50  0000 C CNN
F 4 "www.yageo.com" H 7200 2000 50  0001 C CNN "MNF1_URL"
F 5 "CC0603KRX7R8BB104" H 7200 2000 50  0001 C CNN "MPN"
F 6 "603-CC603KRX7R8BB104" H 7200 2000 50  0001 C CNN "Mouser"
F 7 "?" H 7200 2000 50  0001 C CNN "Digikey"
F 8 "?" H 7200 2000 50  0001 C CNN "LCSC"
F 9 "?" H 7200 2000 50  0001 C CNN "Koncar"
F 10 "TB" H 7200 2000 50  0001 C CNN "Side"
	1    7200 2000
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0127
U 1 1 60D9A6E8
P 7200 2150
F 0 "#PWR0127" H 7200 1900 50  0001 C CNN
F 1 "GND" H 7205 1977 50  0000 C CNN
F 2 "" H 7200 2150 50  0001 C CNN
F 3 "" H 7200 2150 50  0001 C CNN
	1    7200 2150
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 60D9A6EF
P 7200 2950
AR Path="/5F6B165A/60D9A6EF" Ref="R?"  Part="1" 
AR Path="/5F679B53/60D9A6EF" Ref="R?"  Part="1" 
AR Path="/5F69F4EF/60D9A6EF" Ref="R?"  Part="1" 
AR Path="/60D72F2C/60D9A6EF" Ref="R20"  Part="1" 
F 0 "R20" V 7280 2950 50  0000 C CNN
F 1 "1k" V 7200 2950 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 7130 2950 50  0001 C CNN
F 3 "" H 7200 2950 50  0000 C CNN
F 4 "0603WAF1001T5E" V 7200 2350 50  0001 C CNN "MPN"
	1    7200 2950
	-1   0    0    1   
$EndComp
Connection ~ 7200 2800
Wire Wire Line
	7200 3100 7200 3400
Wire Wire Line
	7200 3400 6700 3400
Connection ~ 6700 3400
Wire Wire Line
	4700 2900 4450 2900
Wire Wire Line
	4700 2800 4450 2800
$Comp
L Power_Protection:SN65220 U5
U 1 1 60D9A6FD
P 4250 2850
F 0 "U5" V 4296 2937 50  0000 L CNN
F 1 "SN65220" V 4205 2937 50  0000 L CNN
F 2 "Package_TO_SOT_SMD:SOT-23-6" H 4600 2700 50  0001 L CNN
F 3 "http://www.ti.com/lit/ds/symlink/sn65220.pdf" H 4250 3000 50  0001 C CNN
F 4 "SN65220DBVR" V 4250 2850 50  0001 C CNN "MPN"
	1    4250 2850
	0    1    -1   0   
$EndComp
Wire Wire Line
	4450 2800 4450 2250
Wire Wire Line
	4450 2900 4450 3450
$Comp
L power:GND #PWR0128
U 1 1 60D9A706
P 3850 2850
F 0 "#PWR0128" H 3850 2600 50  0001 C CNN
F 1 "GND" H 3855 2677 50  0000 C CNN
F 2 "" H 3850 2850 50  0001 C CNN
F 3 "" H 3850 2850 50  0001 C CNN
	1    3850 2850
	1    0    0    -1  
$EndComp
Wire Wire Line
	3850 2850 3950 2850
Connection ~ 3950 2850
$Comp
L Device:R R?
U 1 1 60D9A70F
P 3950 2500
AR Path="/5F6B165A/60D9A70F" Ref="R?"  Part="1" 
AR Path="/5F679B53/60D9A70F" Ref="R?"  Part="1" 
AR Path="/5F69F4EF/60D9A70F" Ref="R?"  Part="1" 
AR Path="/60D72F2C/60D9A70F" Ref="R14"  Part="1" 
F 0 "R14" V 4030 2500 50  0000 C CNN
F 1 "15k" V 3950 2500 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 3880 2500 50  0001 C CNN
F 3 "" H 3950 2500 50  0000 C CNN
F 4 "0603WAF1502T5E" V 3950 1900 50  0001 C CNN "MPN"
	1    3950 2500
	-1   0    0    1   
$EndComp
$Comp
L Device:R R?
U 1 1 60D9A717
P 3950 3200
AR Path="/5F6B165A/60D9A717" Ref="R?"  Part="1" 
AR Path="/5F679B53/60D9A717" Ref="R?"  Part="1" 
AR Path="/5F69F4EF/60D9A717" Ref="R?"  Part="1" 
AR Path="/60D72F2C/60D9A717" Ref="R15"  Part="1" 
F 0 "R15" V 4030 3200 50  0000 C CNN
F 1 "15k" V 3950 3200 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 3880 3200 50  0001 C CNN
F 3 "" H 3950 3200 50  0000 C CNN
F 4 "0603WAF1502T5E" V 3950 2600 50  0001 C CNN "MPN"
	1    3950 3200
	-1   0    0    1   
$EndComp
Wire Wire Line
	3950 3350 3950 3450
Wire Wire Line
	3950 3450 4250 3450
Wire Wire Line
	3950 2250 3950 2350
Connection ~ 4250 2250
Connection ~ 4250 3450
Connection ~ 3950 2950
Connection ~ 3950 2750
Wire Wire Line
	3950 2750 3950 2650
Wire Wire Line
	3950 2850 3950 2750
Wire Wire Line
	3950 3050 3950 2950
Wire Wire Line
	3950 2950 3950 2850
Wire Wire Line
	4450 3450 4250 3450
Wire Wire Line
	4250 2250 3950 2250
Wire Wire Line
	4450 2250 4250 2250
$Comp
L Device:R R?
U 1 1 60D9A72D
P 3700 2250
AR Path="/5F6B165A/60D9A72D" Ref="R?"  Part="1" 
AR Path="/5F679B53/60D9A72D" Ref="R?"  Part="1" 
AR Path="/5F69F4EF/60D9A72D" Ref="R?"  Part="1" 
AR Path="/60D72F2C/60D9A72D" Ref="R9"  Part="1" 
F 0 "R9" V 3780 2250 50  0000 C CNN
F 1 "27" V 3700 2250 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 3630 2250 50  0001 C CNN
F 3 "" H 3700 2250 50  0000 C CNN
F 4 "0603WAF270JT5E" V 3700 2250 50  0001 C CNN "MPN"
F 5 "ERJ-3EKF27R0V" V 3700 1650 50  0001 C CNN "MPN-ALT"
	1    3700 2250
	0    1    1    0   
$EndComp
$Comp
L Device:R R?
U 1 1 60D9A735
P 3700 3450
AR Path="/5F6B165A/60D9A735" Ref="R?"  Part="1" 
AR Path="/5F679B53/60D9A735" Ref="R?"  Part="1" 
AR Path="/5F69F4EF/60D9A735" Ref="R?"  Part="1" 
AR Path="/60D72F2C/60D9A735" Ref="R10"  Part="1" 
F 0 "R10" V 3780 3450 50  0000 C CNN
F 1 "27" V 3700 3450 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 3630 3450 50  0001 C CNN
F 3 "" H 3700 3450 50  0000 C CNN
F 4 "0603WAF270JT5E" V 3700 3450 50  0001 C CNN "MPN"
F 5 "ERJ-3EKF27R0V" V 3700 2850 50  0001 C CNN "MPN-ALT"
	1    3700 3450
	0    1    1    0   
$EndComp
Wire Wire Line
	3850 3450 3950 3450
Connection ~ 3950 3450
Wire Wire Line
	3850 2250 3950 2250
Connection ~ 3950 2250
Text Label 4950 1450 2    50   ~ 0
VBus
Wire Wire Line
	4700 3000 4700 3200
Wire Wire Line
	4700 3200 5000 3200
Wire Wire Line
	5000 3200 5100 3200
Connection ~ 5000 3200
$Comp
L power:GND #PWR0129
U 1 1 60D9A747
P 5000 3200
F 0 "#PWR0129" H 5000 2950 50  0001 C CNN
F 1 "GND" H 5005 3027 50  0000 C CNN
F 2 "" H 5000 3200 50  0001 C CNN
F 3 "" H 5000 3200 50  0001 C CNN
	1    5000 3200
	1    0    0    -1  
$EndComp
Wire Wire Line
	4700 1850 4700 2600
Wire Wire Line
	4700 1850 4950 1850
$Comp
L Device:CP C3
U 1 1 60D9A750
P 4950 2000
F 0 "C3" H 5068 2046 50  0000 L CNN
F 1 "CP" H 5068 1955 50  0000 L CNN
F 2 "Capacitor_SMD:C_1206_3216Metric" H 4988 1850 50  0001 C CNN
F 3 "~" H 4950 2000 50  0001 C CNN
F 4 "GRM31CR60J157ME11L" H 4950 2000 50  0001 C CNN "MPN"
	1    4950 2000
	1    0    0    -1  
$EndComp
$Comp
L Device:Ferrite_Bead_Small FB1
U 1 1 60D9A758
P 4950 1750
F 0 "FB1" H 5050 1796 50  0000 L CNN
F 1 "Ferrite_Bead_Small" H 5050 1705 50  0000 L CNN
F 2 "Inductor_SMD:L_0805_2012Metric" V 4880 1750 50  0001 C CNN
F 3 "~" H 4950 1750 50  0001 C CNN
F 4 "742792022" H 4950 1750 50  0001 C CNN "MPN-ALT"
F 5 "PZ2012U221-2R0TF" H 4950 1750 50  0001 C CNN "MPN"
	1    4950 1750
	1    0    0    -1  
$EndComp
Connection ~ 4950 1850
Wire Wire Line
	4950 1650 4950 1450
$Comp
L power:GND #PWR0130
U 1 1 60D9A761
P 4950 2150
F 0 "#PWR0130" H 4950 1900 50  0001 C CNN
F 1 "GND" H 4955 1977 50  0000 C CNN
F 2 "" H 4950 2150 50  0001 C CNN
F 3 "" H 4950 2150 50  0001 C CNN
	1    4950 2150
	1    0    0    -1  
$EndComp
Wire Wire Line
	6000 3000 6100 3000
Connection ~ 6100 3000
Wire Wire Line
	6100 3000 6200 3000
Text GLabel 3550 2250 0    50   Input ~ 0
USBH0_D+
Text GLabel 3550 3450 0    50   Input ~ 0
USBH0_D-
Text Label 4700 2050 2    50   ~ 0
VBus_USB0
Text Notes 5050 4200 0    50   ~ 0
From Dolu1990's USB pmod
$EndSCHEMATC
