TESTBENCHES_FILES=\
	sbus_fsm_TB_write_leds_word.vhd \
	sbus_fsm_TB_write_leds_byte.vhd \
	sbus_fsm_TB_read_prom_word.vhd \
	sbus_fsm_TB_read_prom_burst4.vhd \
	sbus_fsm_TB_read_prom_byte.vhd \
	sbus_fsm_TB_read_prom_hword.vhd \
	sbus_fsm_TB_do_gcm.vhd

CPP=cpp -P

all: $(TESTBENCHES_FILES)

sbus_fsm_TB_write_leds_word.vhd: sbus_fsm_TB.vhd.cpp
	$(CPP) -DWRITE_LEDS_WORD $< -o $@

sbus_fsm_TB_write_leds_byte.vhd: sbus_fsm_TB.vhd.cpp
	$(CPP) -DWRITE_LEDS_BYTE $< -o $@

sbus_fsm_TB_read_prom_word.vhd: sbus_fsm_TB.vhd.cpp
	$(CPP) -DREAD_PROM_WORD $< -o $@

sbus_fsm_TB_read_prom_burst4.vhd: sbus_fsm_TB.vhd.cpp
	$(CPP) -DREAD_PROM_BURST4 $< -o $@

sbus_fsm_TB_read_prom_byte.vhd: sbus_fsm_TB.vhd.cpp
	$(CPP) -DREAD_PROM_BYTE $< -o $@

sbus_fsm_TB_read_prom_hword.vhd: sbus_fsm_TB.vhd.cpp
	$(CPP) -DREAD_PROM_HWORD $< -o $@

sbus_fsm_TB_do_gcm.vhd: sbus_fsm_TB.vhd.cpp
	$(CPP) -DDO_GCM $< -o $@
