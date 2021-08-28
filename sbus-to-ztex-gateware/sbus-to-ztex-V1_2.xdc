# !!! Constraint files are application specific !!!
# !!!          This is a template only          !!!

# on-board signals

# CLKOUT/FXCLK 
create_clock -name fxclk_in -period 20.833 [get_ports fxclk_in]
set_property PACKAGE_PIN P15 [get_ports fxclk_in]
set_property IOSTANDARD LVCMOS33 [get_ports fxclk_in]

# IFCLK 
#create_clock -name ifclk_in -period 20.833 [get_ports ifclk_in]
#set_property PACKAGE_PIN P17 [get_ports ifclk_in]
#set_property IOSTANDARD LVCMOS33 [get_ports ifclk_in]

set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 66 [current_design]  
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR No [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 2 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS true [current_design] 

#set_property PACKAGE_PIN M16 [get_ports {PB[0]}]  		;# PB0/FD0
#set_property IOSTANDARD LVCMOS33 [get_ports {PB[0]}]

#set_property PACKAGE_PIN L16 [get_ports {PB[1]}]  		;# PB1/FD1
#set_property IOSTANDARD LVCMOS33 [get_ports {PB[1]}]

#set_property PACKAGE_PIN L14 [get_ports {PB[2]}]  		;# PB2/FD2
#set_property IOSTANDARD LVCMOS33 [get_ports {PB[2]}]

#set_property PACKAGE_PIN M14 [get_ports {PB[3]}]  		;# PB3/FD3
#set_property IOSTANDARD LVCMOS33 [get_ports {PB[3]}]

#set_property PACKAGE_PIN L18 [get_ports {PB[4]}]  		;# PB4/FD4
#set_property IOSTANDARD LVCMOS33 [get_ports {PB[4]}]

#set_property PACKAGE_PIN M18 [get_ports {PB[5]}]  		;# PB5/FD5
#set_property IOSTANDARD LVCMOS33 [get_ports {PB[5]}]

#set_property PACKAGE_PIN R12 [get_ports {PB[6]}]  		;# PB6/FD6
#set_property IOSTANDARD LVCMOS33 [get_ports {PB[6]}]

#set_property PACKAGE_PIN R13 [get_ports {PB[7]}]  		;# PB7/FD7
#set_property IOSTANDARD LVCMOS33 [get_ports {PB[7]}]


#set_property PACKAGE_PIN T9 [get_ports {PD[0]}]  		;# PD0/FD8
#set_property IOSTANDARD LVCMOS33 [get_ports {PD[0]}]

#set_property PACKAGE_PIN V10 [get_ports {PD[1]}]  		;# PD1/FD9
#set_property IOSTANDARD LVCMOS33 [get_ports {PD[1]}]

#set_property PACKAGE_PIN U11 [get_ports {PD[2]}]  		;# PD2/FD10
#set_property IOSTANDARD LVCMOS33 [get_ports {PD[2]}]

#set_property PACKAGE_PIN V11 [get_ports {PD[3]}]  		;# PD3/FD11
#set_property IOSTANDARD LVCMOS33 [get_ports {PD[3]}]

#set_property PACKAGE_PIN V12 [get_ports {PD[4]}]  		;# PD4/FD12
#set_property IOSTANDARD LVCMOS33 [get_ports {PD[4]}]

#set_property PACKAGE_PIN U13 [get_ports {PD[5]}]  		;# PD5/FD13
#set_property IOSTANDARD LVCMOS33 [get_ports {PD[5]}]

#set_property PACKAGE_PIN U14 [get_ports {PD[6]}]  		;# PD6/FD14
#set_property IOSTANDARD LVCMOS33 [get_ports {PD[6]}]

#set_property PACKAGE_PIN V14 [get_ports {PD[7]}]  		;# PD7/FD15
#set_property IOSTANDARD LVCMOS33 [get_ports {PD[7]}]


#set_property PACKAGE_PIN R15 [get_ports {PA[0]}]  		;# PA0/INT0#
#set_property IOSTANDARD LVCMOS33 [get_ports {PA[0]}]

#set_property PACKAGE_PIN T15 [get_ports {PA[1]}]  		;# PA1/INT1#
#set_property IOSTANDARD LVCMOS33 [get_ports {PA[1]}]

#set_property PACKAGE_PIN T14 [get_ports {PA[2]}]  		;# PA2/SLOE
#set_property IOSTANDARD LVCMOS33 [get_ports {PA[2]}]

#set_property PACKAGE_PIN T13 [get_ports {PA[3]}]  		;# PA3/WU2
#set_property IOSTANDARD LVCMOS33 [get_ports {PA[3]}]

#set_property PACKAGE_PIN R11 [get_ports {PA[4]}]  		;# PA4/FIFOADR0
#set_property IOSTANDARD LVCMOS33 [get_ports {PA[4]}]

#set_property PACKAGE_PIN T11 [get_ports {PA[5]}]  		;# PA5/FIFOADR1
#set_property IOSTANDARD LVCMOS33 [get_ports {PA[5]}]

#set_property PACKAGE_PIN R10 [get_ports {PA[6]}]  		;# PA6/PKTEND
#set_property IOSTANDARD LVCMOS33 [get_ports {PA[6]}]

#set_property PACKAGE_PIN T10 [get_ports {PA[7]}]  		;# PA7/FLAGD/SLCS#
#set_property IOSTANDARD LVCMOS33 [get_ports {PA[7]}]


#set_property PACKAGE_PIN R17 [get_ports {PC[0]}]  		;# PC0/GPIFADR0
#set_property IOSTANDARD LVCMOS33 [get_ports {PC[0]}]

#set_property PACKAGE_PIN R18 [get_ports {PC[1]}]  		;# PC1/GPIFADR1
#set_property IOSTANDARD LVCMOS33 [get_ports {PC[1]}]

#set_property PACKAGE_PIN P18 [get_ports {PC[2]}]  		;# PC2/GPIFADR2
#set_property IOSTANDARD LVCMOS33 [get_ports {PC[2]}]

#set_property PACKAGE_PIN P14 [get_ports {PC[3]}]  		;# PC3/GPIFADR3
#set_property IOSTANDARD LVCMOS33 [get_ports {PC[3]}]

#set_property PACKAGE_PIN K18 [get_ports {FLASH_DO}]  		;# PC4/GPIFADR4
#set_property IOSTANDARD LVCMOS33 [get_ports {FLASH_DO}]

#set_property PACKAGE_PIN L13 [get_ports {FLASH_CS}]  		;# PC5/GPIFADR5
#set_property IOSTANDARD LVCMOS33 [get_ports {FLASH_CS}]

#set_property PACKAGE_PIN E9 [get_ports {FLASH_CLK}]  		;# PC6/GPIFADR6
#set_property IOSTANDARD LVCMOS33 [get_ports {FLASH_CLK}]

#set_property PACKAGE_PIN K17 [get_ports {FLASH_DI}]  		;# PC7/GPIFADR7
#set_property IOSTANDARD LVCMOS33 [get_ports {FLASH_DI}]


#set_property PACKAGE_PIN P10 [get_ports {PE[0]}]  		;# PE0/T0OUT
#set_property IOSTANDARD LVCMOS33 [get_ports {PE[0]}]

#set_property PACKAGE_PIN P7 [get_ports {PE[1]}]  		;# PE1/T1OUT
#set_property IOSTANDARD LVCMOS33 [get_ports {PE[1]}]

#set_property PACKAGE_PIN V15 [get_ports {PE[2]}]  		;# PE2/T2OUT
#set_property IOSTANDARD LVCMOS33 [get_ports {PE[2]}]

#set_property PACKAGE_PIN R16 [get_ports {PE[5]}]  		;# PE5/INT6
#set_property IOSTANDARD LVCMOS33 [get_ports {PE[5]}]

#set_property PACKAGE_PIN T16 [get_ports {PE[6]}]  		;# PE6/T2EX
#set_property IOSTANDARD LVCMOS33 [get_ports {PE[6]}]


#set_property PACKAGE_PIN V16 [get_ports {SLRD}]  		;# RDY0/SLRD
#set_property IOSTANDARD LVCMOS33 [get_ports {SLRD}]

#set_property PACKAGE_PIN U16 [get_ports {SLWR}]  		;# RDY1/SLWR
#set_property IOSTANDARD LVCMOS33 [get_ports {SLWR}]

#set_property PACKAGE_PIN V17 [get_ports {RDY2}]  		;# RDY2
#set_property IOSTANDARD LVCMOS33 [get_ports {RDY2}]

#set_property PACKAGE_PIN U17 [get_ports {RDY3}]  		;# RDY3
#set_property IOSTANDARD LVCMOS33 [get_ports {RDY3}]

#set_property PACKAGE_PIN U18 [get_ports {RDY4}]  		;# RDY4
#set_property IOSTANDARD LVCMOS33 [get_ports {RDY4}]

#set_property PACKAGE_PIN T18 [get_ports {RDY5}]  		;# RDY5
#set_property IOSTANDARD LVCMOS33 [get_ports {RDY5}]


#set_property PACKAGE_PIN N16 [get_ports {FLAGA}]  		;# CTL0/FLAGA
#set_property IOSTANDARD LVCMOS33 [get_ports {FLAGA}]

#set_property PACKAGE_PIN N15 [get_ports {FLAGB}]  		;# CTL1/FLAGB
#set_property IOSTANDARD LVCMOS33 [get_ports {FLAGB}]

#set_property PACKAGE_PIN N14 [get_ports {FLAGC}]  		;# CTL2/FLAGC
#set_property IOSTANDARD LVCMOS33 [get_ports {FLAGC}]

#set_property PACKAGE_PIN N17 [get_ports {CTL3}]  		;# CTL3
#set_property IOSTANDARD LVCMOS33 [get_ports {CTL3}]

#set_property PACKAGE_PIN M13 [get_ports {CTL4}]  		;# CTL4
#set_property IOSTANDARD LVCMOS33 [get_ports {CTL4}]


#set_property PACKAGE_PIN D10 [get_ports {INT4}]  		;# INT4
#set_property IOSTANDARD LVCMOS33 [get_ports {INT4}]

#set_property PACKAGE_PIN U12 [get_ports {INT5_N}]  		;# INT5#
#set_property IOSTANDARD LVCMOS33 [get_ports {INT5_N}]

#set_property PACKAGE_PIN M17 [get_ports {T0}]  		;# T0
#set_property IOSTANDARD LVCMOS33 [get_ports {T0}]


#set_property PACKAGE_PIN B8 [get_ports {SCL}]  		;# SCL
#set_property IOSTANDARD LVCMOS33 [get_ports {SCL}]

#set_property PACKAGE_PIN A10 [get_ports {SDA}]  		;# SDA
#set_property IOSTANDARD LVCMOS33 [get_ports {SDA}]


#set_property PACKAGE_PIN A8 [get_ports {RxD0}]  		;# RxD0
#set_property IOSTANDARD LVCMOS33 [get_ports {RxD0}]

#set_property PACKAGE_PIN A9 [get_ports {TxD0}]  		;# TxD0
#set_property IOSTANDARD LVCMOS33 [get_ports {TxD0}]


# external I/O
create_clock -name SBUS_3V3_CLK -period 40 [get_ports SBUS_3V3_CLK]
# COPY/PASTE here then fix
# * -> s
# ]s -> s earlier (ACK ; INT have no brackets)
# leading 0 in [0x (but not [0]!)
# comment out TX, RX, SD_*
# PMOD-x -> PMODx
# EER -> ERR
set_property PACKAGE_PIN K16 [get_ports {SBUS_3V3_D[1]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[1]}]
set_property PACKAGE_PIN J18 [get_ports {SBUS_3V3_D[0]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[0]}]
set_property PACKAGE_PIN K15 [get_ports {SBUS_3V3_D[3]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[3]}]
set_property PACKAGE_PIN J17 [get_ports {SBUS_3V3_D[2]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[2]}]
set_property PACKAGE_PIN J15 [get_ports {SBUS_3V3_D[5]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[5]}]
set_property PACKAGE_PIN K13 [get_ports {SBUS_3V3_D[4]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[4]}]
set_property PACKAGE_PIN H15 [get_ports {SBUS_3V3_INT2s}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_INT2s}]
set_property PACKAGE_PIN J13 [get_ports {SBUS_3V3_D[6]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[6]}]
set_property PACKAGE_PIN J14 [get_ports {SBUS_3V3_D[7]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[7]}]
set_property PACKAGE_PIN H14 [get_ports {SBUS_3V3_D[8]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[8]}]
set_property PACKAGE_PIN H17 [get_ports {SBUS_3V3_D[9]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[9]}]
set_property PACKAGE_PIN G14 [get_ports {SBUS_3V3_D[10]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[10]}]
set_property PACKAGE_PIN G17 [get_ports {SBUS_3V3_D[11]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[11]}]
set_property PACKAGE_PIN G16 [get_ports {SBUS_3V3_D[12]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[12]}]
set_property PACKAGE_PIN G18 [get_ports {SBUS_3V3_D[13]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[13]}]
set_property PACKAGE_PIN H16 [get_ports {SBUS_3V3_D[14]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[14]}]
set_property PACKAGE_PIN F18 [get_ports {SBUS_3V3_D[15]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[15]}]
set_property PACKAGE_PIN F16 [get_ports {SBUS_3V3_D[16]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[16]}]
set_property PACKAGE_PIN E18 [get_ports {SBUS_3V3_D[17]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[17]}]
set_property PACKAGE_PIN F15 [get_ports {SBUS_3V3_D[18]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[18]}]
set_property PACKAGE_PIN D18 [get_ports {SBUS_3V3_D[19]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[19]}]
set_property PACKAGE_PIN E17 [get_ports {SBUS_3V3_D[20]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[20]}]
set_property PACKAGE_PIN G13 [get_ports {SBUS_3V3_D[21]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[21]}]
set_property PACKAGE_PIN D17 [get_ports {SBUS_3V3_D[22]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[22]}]






set_property PACKAGE_PIN F13 [get_ports {SBUS_3V3_D[23]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[23]}]
set_property PACKAGE_PIN F14 [get_ports {SBUS_3V3_D[24]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[24]}]
set_property PACKAGE_PIN E16 [get_ports {SBUS_3V3_D[25]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[25]}]
set_property PACKAGE_PIN E15 [get_ports {SBUS_3V3_D[26]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[26]}]
set_property PACKAGE_PIN C17 [get_ports {SBUS_3V3_D[27]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[27]}]
set_property PACKAGE_PIN C16 [get_ports {SBUS_3V3_D[28]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[28]}]
set_property PACKAGE_PIN A18 [get_ports {SBUS_3V3_D[29]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[29]}]
set_property PACKAGE_PIN B18 [get_ports {SBUS_3V3_D[30]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[30]}]
set_property PACKAGE_PIN C15 [get_ports {SBUS_3V3_D[31]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_D[31]}]
set_property PACKAGE_PIN D15 [get_ports {SBUS_3V3_CLK}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_CLK}]
set_property PACKAGE_PIN B17 [get_ports {SBUS_3V3_PA[1]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_PA[1]}]
set_property PACKAGE_PIN B16 [get_ports {SBUS_3V3_PA[0]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_PA[0]}]
set_property PACKAGE_PIN C14 [get_ports {SBUS_3V3_PA[3]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_PA[3]}]
set_property PACKAGE_PIN D14 [get_ports {SBUS_3V3_PA[2]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_PA[2]}]
set_property PACKAGE_PIN D13 [get_ports {SBUS_3V3_ERRs}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_ERRs}]
set_property PACKAGE_PIN D12 [get_ports {SBUS_3V3_PA[4]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_PA[4]}]
set_property PACKAGE_PIN A16 [get_ports {SBUS_3V3_PA[5]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_PA[5]}]
set_property PACKAGE_PIN A15 [get_ports {SBUS_3V3_PA[6]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_PA[6]}]
set_property PACKAGE_PIN B14 [get_ports {SBUS_3V3_PA[7]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_PA[7]}]
set_property PACKAGE_PIN B13 [get_ports {SBUS_3V3_PA[8]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_PA[8]}]
set_property PACKAGE_PIN B12 [get_ports {SBUS_3V3_PA[9]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_PA[9]}]
set_property PACKAGE_PIN C12 [get_ports {SBUS_3V3_PA[10]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_PA[10]}]
set_property PACKAGE_PIN A14 [get_ports {SBUS_3V3_PA[11]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_PA[11]}]
set_property PACKAGE_PIN A13 [get_ports {SBUS_3V3_PA[12]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_PA[12]}]
set_property PACKAGE_PIN B11 [get_ports {SBUS_3V3_PA[13]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_PA[13]}]
set_property PACKAGE_PIN A11 [get_ports {SBUS_3V3_PA[14]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_PA[14]}]








set_property PACKAGE_PIN U9 [get_ports {RX}]
set_property IOSTANDARD LVTTL [get_ports {RX}]
set_property PACKAGE_PIN V9 [get_ports {TX}]
set_property IOSTANDARD LVTTL [get_ports {TX}]
set_property PACKAGE_PIN U8 [get_ports {USBH0_D+}]
set_property IOSTANDARD LVTTL [get_ports {USBH0_D+}]
set_property PACKAGE_PIN V7 [get_ports {SD_D2}]
set_property IOSTANDARD LVTTL [get_ports {SD_D2}]
set_property PACKAGE_PIN U7 [get_ports {USBH0_D-}]
set_property IOSTANDARD LVTTL [get_ports {USBH0_D-}]
set_property PACKAGE_PIN V6 [get_ports {SD_D3}]
set_property IOSTANDARD LVTTL [get_ports {SD_D3}]
set_property PACKAGE_PIN U6 [get_ports {PMOD12}]
set_property IOSTANDARD LVTTL [get_ports {PMOD12}]
set_property PACKAGE_PIN V5 [get_ports {SD_D0}]
set_property IOSTANDARD LVTTL [get_ports {SD_D0}]
set_property PACKAGE_PIN T8 [get_ports {PMOD11}]
set_property IOSTANDARD LVTTL [get_ports {PMOD11}]
set_property PACKAGE_PIN V4 [get_ports {SD_D1}]
set_property IOSTANDARD LVTTL [get_ports {SD_D1}]
set_property PACKAGE_PIN R8 [get_ports {SD_CLK}]
set_property IOSTANDARD LVTTL [get_ports {SD_CLK}]
set_property PACKAGE_PIN T5 [get_ports {SD_CMD}]
set_property IOSTANDARD LVTTL [get_ports {SD_CMD}]
set_property PACKAGE_PIN R7 [get_ports {SBUS_3V3_BGs}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_BGs}]
set_property PACKAGE_PIN T4 [get_ports {SBUS_3V3_ASs}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_ASs}]
set_property PACKAGE_PIN T6 [get_ports {SBUS_3V3_SIZ[0]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_SIZ[0]}]
set_property PACKAGE_PIN U4 [get_ports {PMOD8}]
set_property IOSTANDARD LVTTL [get_ports {PMOD8}]
set_property PACKAGE_PIN R6 [get_ports {SBUS_3V3_BRs}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_BRs}]
set_property PACKAGE_PIN U3 [get_ports {SBUS_3V3_SIZ[1]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_SIZ[1]}]
set_property PACKAGE_PIN R5 [get_ports {SBUS_3V3_INT1s}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_INT1s}]
set_property PACKAGE_PIN V1 [get_ports {SBUS_3V3_SIZ[2]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_SIZ[2]}]
set_property PACKAGE_PIN V2 [get_ports {SBUS_3V3_INT6s}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_INT6s}]
set_property PACKAGE_PIN U1 [get_ports {SBUS_DATA_OE_LED}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_DATA_OE_LED}]
set_property PACKAGE_PIN U2 [get_ports {SBUS_3V3_RSTs}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_RSTs}]
set_property PACKAGE_PIN T3 [get_ports {PMOD6}]
set_property IOSTANDARD LVTTL [get_ports {PMOD6}]
set_property PACKAGE_PIN K6 [get_ports {SBUS_3V3_SELs}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_SELs}]
set_property PACKAGE_PIN R3 [get_ports {SBUS_3V3_INT3s}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_INT3s}]






set_property PACKAGE_PIN N6 [get_ports {SBUS_3V3_PPRD}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_PPRD}]
set_property PACKAGE_PIN P5 [get_ports {SBUS_OE}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_OE}]
set_property PACKAGE_PIN M6 [get_ports {SBUS_3V3_ACKs[0]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_ACKs[0]}]
set_property PACKAGE_PIN N5 [get_ports {SBUS_3V3_INT4s}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_INT4s}]
set_property PACKAGE_PIN L6 [get_ports {SBUS_3V3_ACKs[1]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_ACKs[1]}]
set_property PACKAGE_PIN P4 [get_ports {PMOD10}]
set_property IOSTANDARD LVTTL [get_ports {PMOD10}]
set_property PACKAGE_PIN L5 [get_ports {SBUS_3V3_INT5s}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_INT5s}]
set_property PACKAGE_PIN P3 [get_ports {PMOD9}]
set_property IOSTANDARD LVTTL [get_ports {PMOD9}]
set_property PACKAGE_PIN N4 [get_ports {SBUS_3V3_ACKs[2]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_ACKs[2]}]
set_property PACKAGE_PIN T1 [get_ports {PMOD7}]
set_property IOSTANDARD LVTTL [get_ports {PMOD7}]
set_property PACKAGE_PIN M4 [get_ports {SBUS_3V3_PA[15]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_PA[15]}]
set_property PACKAGE_PIN R1 [get_ports {PMOD5}]
set_property IOSTANDARD LVTTL [get_ports {PMOD5}]
set_property PACKAGE_PIN M3 [get_ports {SBUS_3V3_PA[17]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_PA[17]}]
set_property PACKAGE_PIN R2 [get_ports {SBUS_3V3_PA[16]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_PA[16]}]
set_property PACKAGE_PIN M2 [get_ports {SBUS_3V3_PA[19]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_PA[19]}]
set_property PACKAGE_PIN P2 [get_ports {SBUS_3V3_PA[18]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_PA[18]}]
set_property PACKAGE_PIN K5 [get_ports {SBUS_3V3_PA[21]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_PA[21]}]
set_property PACKAGE_PIN N2 [get_ports {SBUS_3V3_PA[20]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_PA[20]}]
set_property PACKAGE_PIN L4 [get_ports {SBUS_3V3_PA[23]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_PA[23]}]
set_property PACKAGE_PIN N1 [get_ports {SBUS_3V3_PA[22]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_PA[22]}]
set_property PACKAGE_PIN L3 [get_ports {SBUS_3V3_PA[25]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_PA[25]}]
set_property PACKAGE_PIN M1 [get_ports {SBUS_3V3_PA[24]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_PA[24]}]
set_property PACKAGE_PIN K3 [get_ports {SBUS_3V3_PA[27]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_PA[27]}]
set_property PACKAGE_PIN L1 [get_ports {SBUS_3V3_PA[26]}]
set_property IOSTANDARD LVTTL [get_ports {SBUS_3V3_PA[26]}]
