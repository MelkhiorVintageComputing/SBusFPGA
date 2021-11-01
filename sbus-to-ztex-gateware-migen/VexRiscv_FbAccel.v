// Generator : SpinalHDL v1.4.4    git head : 86bb53d7c015114a265f345ebe5da1eb68d1e828
// Component : VexRiscv
// Git hash  : 24adc7db89135956d4ef289611665b7a4ed40e1c


`define BranchCtrlEnum_defaultEncoding_type [1:0]
`define BranchCtrlEnum_defaultEncoding_INC 2'b00
`define BranchCtrlEnum_defaultEncoding_B 2'b01
`define BranchCtrlEnum_defaultEncoding_JAL 2'b10
`define BranchCtrlEnum_defaultEncoding_JALR 2'b11

`define CG6CtrlternaryEnum_defaultEncoding_type [1:0]
`define CG6CtrlternaryEnum_defaultEncoding_CTRL_CMIX 2'b00
`define CG6CtrlternaryEnum_defaultEncoding_CTRL_CMOV 2'b01
`define CG6CtrlternaryEnum_defaultEncoding_CTRL_FSR 2'b10

`define CG6CtrlminmaxEnum_defaultEncoding_type [0:0]
`define CG6CtrlminmaxEnum_defaultEncoding_CTRL_MAXU 1'b0
`define CG6CtrlminmaxEnum_defaultEncoding_CTRL_MINU 1'b1

`define CG6CtrlEnum_defaultEncoding_type [2:0]
`define CG6CtrlEnum_defaultEncoding_CTRL_SH2ADD 3'b000
`define CG6CtrlEnum_defaultEncoding_CTRL_minmax 3'b001
`define CG6CtrlEnum_defaultEncoding_CTRL_SEXTdotB 3'b010
`define CG6CtrlEnum_defaultEncoding_CTRL_ternary 3'b011
`define CG6CtrlEnum_defaultEncoding_CTRL_REV8 3'b100

`define ShiftCtrlEnum_defaultEncoding_type [1:0]
`define ShiftCtrlEnum_defaultEncoding_DISABLE_1 2'b00
`define ShiftCtrlEnum_defaultEncoding_SLL_1 2'b01
`define ShiftCtrlEnum_defaultEncoding_SRL_1 2'b10
`define ShiftCtrlEnum_defaultEncoding_SRA_1 2'b11

`define AluBitwiseCtrlEnum_defaultEncoding_type [1:0]
`define AluBitwiseCtrlEnum_defaultEncoding_XOR_1 2'b00
`define AluBitwiseCtrlEnum_defaultEncoding_OR_1 2'b01
`define AluBitwiseCtrlEnum_defaultEncoding_AND_1 2'b10

`define Src3CtrlEnum_defaultEncoding_type [0:0]
`define Src3CtrlEnum_defaultEncoding_RS 1'b0
`define Src3CtrlEnum_defaultEncoding_IMI 1'b1

`define Src2CtrlEnum_defaultEncoding_type [1:0]
`define Src2CtrlEnum_defaultEncoding_RS 2'b00
`define Src2CtrlEnum_defaultEncoding_IMI 2'b01
`define Src2CtrlEnum_defaultEncoding_IMS 2'b10
`define Src2CtrlEnum_defaultEncoding_PC 2'b11

`define AluCtrlEnum_defaultEncoding_type [1:0]
`define AluCtrlEnum_defaultEncoding_ADD_SUB 2'b00
`define AluCtrlEnum_defaultEncoding_SLT_SLTU 2'b01
`define AluCtrlEnum_defaultEncoding_BITWISE 2'b10

`define Src1CtrlEnum_defaultEncoding_type [1:0]
`define Src1CtrlEnum_defaultEncoding_RS 2'b00
`define Src1CtrlEnum_defaultEncoding_IMU 2'b01
`define Src1CtrlEnum_defaultEncoding_PC_INCREMENT 2'b10
`define Src1CtrlEnum_defaultEncoding_URS1 2'b11


module VexRiscv (
  output reg          iBusWishbone_CYC,
  output reg          iBusWishbone_STB,
  input               iBusWishbone_ACK,
  output              iBusWishbone_WE,
  output     [29:0]   iBusWishbone_ADR,
  input      [31:0]   iBusWishbone_DAT_MISO,
  output     [31:0]   iBusWishbone_DAT_MOSI,
  output     [3:0]    iBusWishbone_SEL,
  input               iBusWishbone_ERR,
  output     [2:0]    iBusWishbone_CTI,
  output     [1:0]    iBusWishbone_BTE,
  output              dBusWishbone_CYC,
  output              dBusWishbone_STB,
  input               dBusWishbone_ACK,
  output              dBusWishbone_WE,
  output     [29:0]   dBusWishbone_ADR,
  input      [31:0]   dBusWishbone_DAT_MISO,
  output     [31:0]   dBusWishbone_DAT_MOSI,
  output     [3:0]    dBusWishbone_SEL,
  input               dBusWishbone_ERR,
  output     [2:0]    dBusWishbone_CTI,
  output     [1:0]    dBusWishbone_BTE,
  input               clk,
  input               reset
);
  wire                _zz_185;
  wire                _zz_186;
  wire                _zz_187;
  wire                _zz_188;
  wire                _zz_189;
  wire                _zz_190;
  wire                _zz_191;
  wire                _zz_192;
  reg                 _zz_193;
  wire                _zz_194;
  wire       [31:0]   _zz_195;
  wire                _zz_196;
  wire       [31:0]   _zz_197;
  reg                 _zz_198;
  reg                 _zz_199;
  wire                _zz_200;
  wire       [31:0]   _zz_201;
  wire       [31:0]   _zz_202;
  wire                _zz_203;
  wire                _zz_204;
  wire                _zz_205;
  wire                _zz_206;
  wire                _zz_207;
  wire                _zz_208;
  wire                _zz_209;
  wire                _zz_210;
  wire       [3:0]    _zz_211;
  wire                _zz_212;
  wire                _zz_213;
  reg        [31:0]   _zz_214;
  reg        [31:0]   _zz_215;
  reg        [31:0]   _zz_216;
  reg        [31:0]   _zz_217;
  reg        [7:0]    _zz_218;
  reg        [7:0]    _zz_219;
  wire                IBusCachedPlugin_cache_io_cpu_prefetch_haltIt;
  wire       [31:0]   IBusCachedPlugin_cache_io_cpu_fetch_data;
  wire       [31:0]   IBusCachedPlugin_cache_io_cpu_fetch_physicalAddress;
  wire                IBusCachedPlugin_cache_io_cpu_decode_error;
  wire                IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling;
  wire                IBusCachedPlugin_cache_io_cpu_decode_mmuException;
  wire       [31:0]   IBusCachedPlugin_cache_io_cpu_decode_data;
  wire                IBusCachedPlugin_cache_io_cpu_decode_cacheMiss;
  wire       [31:0]   IBusCachedPlugin_cache_io_cpu_decode_physicalAddress;
  wire                IBusCachedPlugin_cache_io_mem_cmd_valid;
  wire       [31:0]   IBusCachedPlugin_cache_io_mem_cmd_payload_address;
  wire       [2:0]    IBusCachedPlugin_cache_io_mem_cmd_payload_size;
  wire                dataCache_1_io_cpu_execute_haltIt;
  wire                dataCache_1_io_cpu_execute_refilling;
  wire                dataCache_1_io_cpu_memory_isWrite;
  wire                dataCache_1_io_cpu_writeBack_haltIt;
  wire       [31:0]   dataCache_1_io_cpu_writeBack_data;
  wire                dataCache_1_io_cpu_writeBack_mmuException;
  wire                dataCache_1_io_cpu_writeBack_unalignedAccess;
  wire                dataCache_1_io_cpu_writeBack_accessError;
  wire                dataCache_1_io_cpu_writeBack_isWrite;
  wire                dataCache_1_io_cpu_writeBack_keepMemRspData;
  wire                dataCache_1_io_cpu_writeBack_exclusiveOk;
  wire                dataCache_1_io_cpu_flush_ready;
  wire                dataCache_1_io_cpu_redo;
  wire                dataCache_1_io_mem_cmd_valid;
  wire                dataCache_1_io_mem_cmd_payload_wr;
  wire                dataCache_1_io_mem_cmd_payload_uncached;
  wire       [31:0]   dataCache_1_io_mem_cmd_payload_address;
  wire       [31:0]   dataCache_1_io_mem_cmd_payload_data;
  wire       [3:0]    dataCache_1_io_mem_cmd_payload_mask;
  wire       [2:0]    dataCache_1_io_mem_cmd_payload_size;
  wire                dataCache_1_io_mem_cmd_payload_last;
  wire                _zz_220;
  wire                _zz_221;
  wire                _zz_222;
  wire                _zz_223;
  wire                _zz_224;
  wire                _zz_225;
  wire                _zz_226;
  wire                _zz_227;
  wire                _zz_228;
  wire                _zz_229;
  wire                _zz_230;
  wire                _zz_231;
  wire                _zz_232;
  wire                _zz_233;
  wire                _zz_234;
  wire                _zz_235;
  wire                _zz_236;
  wire       [1:0]    _zz_237;
  wire       [32:0]   _zz_238;
  wire       [31:0]   _zz_239;
  wire       [32:0]   _zz_240;
  wire       [2:0]    _zz_241;
  wire       [2:0]    _zz_242;
  wire       [31:0]   _zz_243;
  wire       [11:0]   _zz_244;
  wire       [31:0]   _zz_245;
  wire       [19:0]   _zz_246;
  wire       [11:0]   _zz_247;
  wire       [31:0]   _zz_248;
  wire       [31:0]   _zz_249;
  wire       [19:0]   _zz_250;
  wire       [11:0]   _zz_251;
  wire       [0:0]    _zz_252;
  wire       [2:0]    _zz_253;
  wire       [4:0]    _zz_254;
  wire       [11:0]   _zz_255;
  wire       [31:0]   _zz_256;
  wire       [31:0]   _zz_257;
  wire       [31:0]   _zz_258;
  wire       [31:0]   _zz_259;
  wire       [31:0]   _zz_260;
  wire       [31:0]   _zz_261;
  wire       [31:0]   _zz_262;
  wire       [31:0]   _zz_263;
  wire       [31:0]   _zz_264;
  wire       [31:0]   _zz_265;
  wire       [31:0]   _zz_266;
  wire       [31:0]   _zz_267;
  wire       [31:0]   _zz_268;
  wire       [19:0]   _zz_269;
  wire       [11:0]   _zz_270;
  wire       [31:0]   _zz_271;
  wire       [31:0]   _zz_272;
  wire       [31:0]   _zz_273;
  wire       [19:0]   _zz_274;
  wire       [11:0]   _zz_275;
  wire       [2:0]    _zz_276;
  wire       [27:0]   _zz_277;
  wire                _zz_278;
  wire                _zz_279;
  wire                _zz_280;
  wire       [1:0]    _zz_281;
  wire       [1:0]    _zz_282;
  wire       [0:0]    _zz_283;
  wire                _zz_284;
  wire                _zz_285;
  wire                _zz_286;
  wire       [31:0]   _zz_287;
  wire       [31:0]   _zz_288;
  wire       [31:0]   _zz_289;
  wire       [31:0]   _zz_290;
  wire                _zz_291;
  wire       [0:0]    _zz_292;
  wire       [0:0]    _zz_293;
  wire                _zz_294;
  wire       [0:0]    _zz_295;
  wire       [27:0]   _zz_296;
  wire       [31:0]   _zz_297;
  wire                _zz_298;
  wire       [0:0]    _zz_299;
  wire       [0:0]    _zz_300;
  wire                _zz_301;
  wire       [0:0]    _zz_302;
  wire       [23:0]   _zz_303;
  wire       [31:0]   _zz_304;
  wire       [31:0]   _zz_305;
  wire                _zz_306;
  wire       [0:0]    _zz_307;
  wire       [2:0]    _zz_308;
  wire       [0:0]    _zz_309;
  wire       [0:0]    _zz_310;
  wire                _zz_311;
  wire       [0:0]    _zz_312;
  wire       [19:0]   _zz_313;
  wire       [31:0]   _zz_314;
  wire                _zz_315;
  wire                _zz_316;
  wire       [31:0]   _zz_317;
  wire                _zz_318;
  wire                _zz_319;
  wire                _zz_320;
  wire       [0:0]    _zz_321;
  wire       [0:0]    _zz_322;
  wire                _zz_323;
  wire       [0:0]    _zz_324;
  wire       [16:0]   _zz_325;
  wire       [31:0]   _zz_326;
  wire       [31:0]   _zz_327;
  wire       [31:0]   _zz_328;
  wire       [0:0]    _zz_329;
  wire       [0:0]    _zz_330;
  wire                _zz_331;
  wire       [0:0]    _zz_332;
  wire       [13:0]   _zz_333;
  wire       [31:0]   _zz_334;
  wire       [31:0]   _zz_335;
  wire       [31:0]   _zz_336;
  wire                _zz_337;
  wire       [0:0]    _zz_338;
  wire       [0:0]    _zz_339;
  wire                _zz_340;
  wire       [0:0]    _zz_341;
  wire       [9:0]    _zz_342;
  wire                _zz_343;
  wire       [0:0]    _zz_344;
  wire       [1:0]    _zz_345;
  wire       [0:0]    _zz_346;
  wire       [1:0]    _zz_347;
  wire       [0:0]    _zz_348;
  wire       [0:0]    _zz_349;
  wire       [1:0]    _zz_350;
  wire       [1:0]    _zz_351;
  wire                _zz_352;
  wire       [0:0]    _zz_353;
  wire       [5:0]    _zz_354;
  wire       [31:0]   _zz_355;
  wire       [31:0]   _zz_356;
  wire       [31:0]   _zz_357;
  wire                _zz_358;
  wire                _zz_359;
  wire                _zz_360;
  wire                _zz_361;
  wire       [31:0]   _zz_362;
  wire       [31:0]   _zz_363;
  wire                _zz_364;
  wire                _zz_365;
  wire       [0:0]    _zz_366;
  wire       [0:0]    _zz_367;
  wire                _zz_368;
  wire       [0:0]    _zz_369;
  wire       [3:0]    _zz_370;
  wire       [31:0]   _zz_371;
  wire       [31:0]   _zz_372;
  wire       [31:0]   _zz_373;
  wire       [31:0]   _zz_374;
  wire       [31:0]   _zz_375;
  wire       [31:0]   _zz_376;
  wire       [31:0]   _zz_377;
  wire       [31:0]   _zz_378;
  wire       [0:0]    _zz_379;
  wire       [0:0]    _zz_380;
  wire       [0:0]    _zz_381;
  wire       [0:0]    _zz_382;
  wire                _zz_383;
  wire       [0:0]    _zz_384;
  wire       [1:0]    _zz_385;
  wire       [31:0]   _zz_386;
  wire       [31:0]   _zz_387;
  wire       [31:0]   _zz_388;
  wire                _zz_389;
  wire       [0:0]    _zz_390;
  wire       [0:0]    _zz_391;
  wire                _zz_392;
  wire       [0:0]    _zz_393;
  wire       [0:0]    _zz_394;
  wire       [0:0]    _zz_395;
  wire       [0:0]    _zz_396;
  wire                _zz_397;
  wire                _zz_398;
  wire                _zz_399;
  wire       [31:0]   execute_BRANCH_CALC;
  wire                execute_BRANCH_DO;
  wire       [31:0]   execute_CG6_FINAL_OUTPUT;
  wire       [31:0]   execute_SHIFT_RIGHT;
  wire       [31:0]   writeBack_REGFILE_WRITE_DATA_ODD;
  wire       [31:0]   memory_REGFILE_WRITE_DATA_ODD;
  wire       [31:0]   execute_REGFILE_WRITE_DATA_ODD;
  wire       [31:0]   execute_REGFILE_WRITE_DATA;
  wire       [31:0]   memory_MEMORY_STORE_DATA_RF;
  wire       [31:0]   execute_MEMORY_STORE_DATA_RF;
  wire                decode_PREDICTION_HAD_BRANCHED2;
  wire                decode_SRC2_FORCE_ZERO;
  wire       [31:0]   execute_RS3;
  wire                decode_REGFILE_WRITE_VALID_ODD;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_1;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_2;
  wire       `CG6CtrlternaryEnum_defaultEncoding_type decode_CG6Ctrlternary;
  wire       `CG6CtrlternaryEnum_defaultEncoding_type _zz_3;
  wire       `CG6CtrlternaryEnum_defaultEncoding_type _zz_4;
  wire       `CG6CtrlternaryEnum_defaultEncoding_type _zz_5;
  wire       `CG6CtrlminmaxEnum_defaultEncoding_type decode_CG6Ctrlminmax;
  wire       `CG6CtrlminmaxEnum_defaultEncoding_type _zz_6;
  wire       `CG6CtrlminmaxEnum_defaultEncoding_type _zz_7;
  wire       `CG6CtrlminmaxEnum_defaultEncoding_type _zz_8;
  wire       `CG6CtrlEnum_defaultEncoding_type decode_CG6Ctrl;
  wire       `CG6CtrlEnum_defaultEncoding_type _zz_9;
  wire       `CG6CtrlEnum_defaultEncoding_type _zz_10;
  wire       `CG6CtrlEnum_defaultEncoding_type _zz_11;
  wire                execute_IS_CG6;
  wire                decode_IS_CG6;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_12;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_13;
  wire       `ShiftCtrlEnum_defaultEncoding_type decode_SHIFT_CTRL;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_14;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_15;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_16;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type decode_ALU_BITWISE_CTRL;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_17;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_18;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_19;
  wire                decode_SRC_LESS_UNSIGNED;
  wire       `Src3CtrlEnum_defaultEncoding_type decode_SRC3_CTRL;
  wire       `Src3CtrlEnum_defaultEncoding_type _zz_20;
  wire       `Src3CtrlEnum_defaultEncoding_type _zz_21;
  wire       `Src3CtrlEnum_defaultEncoding_type _zz_22;
  wire                decode_MEMORY_MANAGMENT;
  wire                decode_MEMORY_WR;
  wire                execute_BYPASSABLE_MEMORY_STAGE;
  wire                decode_BYPASSABLE_MEMORY_STAGE;
  wire                decode_BYPASSABLE_EXECUTE_STAGE;
  wire       `Src2CtrlEnum_defaultEncoding_type decode_SRC2_CTRL;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_23;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_24;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_25;
  wire       `AluCtrlEnum_defaultEncoding_type decode_ALU_CTRL;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_26;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_27;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_28;
  wire       `Src1CtrlEnum_defaultEncoding_type decode_SRC1_CTRL;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_29;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_30;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_31;
  wire                decode_MEMORY_FORCE_CONSTISTENCY;
  wire       [31:0]   writeBack_FORMAL_PC_NEXT;
  wire       [31:0]   memory_FORMAL_PC_NEXT;
  wire       [31:0]   execute_FORMAL_PC_NEXT;
  wire       [31:0]   decode_FORMAL_PC_NEXT;
  wire       [31:0]   memory_PC;
  wire       [31:0]   memory_BRANCH_CALC;
  wire                memory_BRANCH_DO;
  wire       [31:0]   execute_PC;
  wire                execute_PREDICTION_HAD_BRANCHED2;
  wire       [31:0]   execute_RS1;
  wire                execute_BRANCH_COND_RESULT;
  wire       `BranchCtrlEnum_defaultEncoding_type execute_BRANCH_CTRL;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_32;
  wire                decode_RS3_USE;
  wire                decode_RS2_USE;
  wire                decode_RS1_USE;
  wire       [31:0]   _zz_33;
  wire                execute_REGFILE_WRITE_VALID_ODD;
  wire       [31:0]   _zz_34;
  wire                execute_REGFILE_WRITE_VALID;
  wire                execute_BYPASSABLE_EXECUTE_STAGE;
  wire       [31:0]   _zz_35;
  wire                memory_REGFILE_WRITE_VALID_ODD;
  wire                memory_REGFILE_WRITE_VALID;
  wire                memory_BYPASSABLE_MEMORY_STAGE;
  wire       [31:0]   memory_INSTRUCTION;
  wire       [31:0]   _zz_36;
  wire                writeBack_REGFILE_WRITE_VALID_ODD;
  wire                writeBack_REGFILE_WRITE_VALID;
  reg        [31:0]   decode_RS3;
  reg        [31:0]   decode_RS2;
  reg        [31:0]   decode_RS1;
  wire       [31:0]   memory_CG6_FINAL_OUTPUT;
  wire                memory_IS_CG6;
  wire       `CG6CtrlEnum_defaultEncoding_type execute_CG6Ctrl;
  wire       `CG6CtrlEnum_defaultEncoding_type _zz_37;
  wire       [31:0]   execute_SRC3;
  wire       `CG6CtrlternaryEnum_defaultEncoding_type execute_CG6Ctrlternary;
  wire       `CG6CtrlternaryEnum_defaultEncoding_type _zz_38;
  wire       `CG6CtrlminmaxEnum_defaultEncoding_type execute_CG6Ctrlminmax;
  wire       `CG6CtrlminmaxEnum_defaultEncoding_type _zz_39;
  wire       [31:0]   memory_SHIFT_RIGHT;
  reg        [31:0]   _zz_40;
  wire       `ShiftCtrlEnum_defaultEncoding_type memory_SHIFT_CTRL;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_41;
  wire       `ShiftCtrlEnum_defaultEncoding_type execute_SHIFT_CTRL;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_42;
  wire                execute_SRC_LESS_UNSIGNED;
  wire                execute_SRC2_FORCE_ZERO;
  wire                execute_SRC_USE_SUB_LESS;
  wire       `Src3CtrlEnum_defaultEncoding_type execute_SRC3_CTRL;
  wire       `Src3CtrlEnum_defaultEncoding_type _zz_43;
  wire       [31:0]   _zz_44;
  wire       `Src2CtrlEnum_defaultEncoding_type execute_SRC2_CTRL;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_45;
  wire       `Src1CtrlEnum_defaultEncoding_type execute_SRC1_CTRL;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_46;
  wire                decode_SRC_USE_SUB_LESS;
  wire                decode_SRC_ADD_ZERO;
  wire       [31:0]   execute_SRC_ADD_SUB;
  wire                execute_SRC_LESS;
  wire       `AluCtrlEnum_defaultEncoding_type execute_ALU_CTRL;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_47;
  wire       [31:0]   execute_SRC2;
  wire       [31:0]   execute_SRC1;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type execute_ALU_BITWISE_CTRL;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_48;
  wire                _zz_49;
  reg                 _zz_50;
  wire       [31:0]   _zz_51;
  wire       [31:0]   decode_INSTRUCTION_ANTICIPATED;
  reg                 decode_REGFILE_WRITE_VALID;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_52;
  wire       `CG6CtrlternaryEnum_defaultEncoding_type _zz_53;
  wire       `CG6CtrlminmaxEnum_defaultEncoding_type _zz_54;
  wire       `CG6CtrlEnum_defaultEncoding_type _zz_55;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_56;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_57;
  wire       `Src3CtrlEnum_defaultEncoding_type _zz_58;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_59;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_60;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_61;
  reg        [31:0]   _zz_62;
  wire       [31:0]   writeBack_MEMORY_STORE_DATA_RF;
  wire       [31:0]   writeBack_REGFILE_WRITE_DATA;
  wire                writeBack_MEMORY_ENABLE;
  wire       [31:0]   memory_REGFILE_WRITE_DATA;
  wire                memory_MEMORY_ENABLE;
  wire                execute_MEMORY_FORCE_CONSTISTENCY;
  wire                execute_MEMORY_MANAGMENT;
  wire       [31:0]   execute_RS2;
  wire                execute_MEMORY_WR;
  wire       [31:0]   execute_SRC_ADD;
  wire                execute_MEMORY_ENABLE;
  wire       [31:0]   execute_INSTRUCTION;
  wire                decode_MEMORY_ENABLE;
  wire                decode_FLUSH_ALL;
  reg                 IBusCachedPlugin_rsp_issueDetected_2;
  reg                 IBusCachedPlugin_rsp_issueDetected_1;
  wire       `BranchCtrlEnum_defaultEncoding_type decode_BRANCH_CTRL;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_63;
  wire       [31:0]   decode_INSTRUCTION;
  reg        [31:0]   _zz_64;
  reg        [31:0]   _zz_65;
  wire       [31:0]   decode_PC;
  wire       [31:0]   writeBack_PC;
  wire       [31:0]   writeBack_INSTRUCTION;
  reg                 decode_arbitration_haltItself;
  reg                 decode_arbitration_haltByOther;
  reg                 decode_arbitration_removeIt;
  wire                decode_arbitration_flushIt;
  reg                 decode_arbitration_flushNext;
  wire                decode_arbitration_isValid;
  wire                decode_arbitration_isStuck;
  wire                decode_arbitration_isStuckByOthers;
  wire                decode_arbitration_isFlushed;
  wire                decode_arbitration_isMoving;
  wire                decode_arbitration_isFiring;
  reg                 execute_arbitration_haltItself;
  reg                 execute_arbitration_haltByOther;
  reg                 execute_arbitration_removeIt;
  wire                execute_arbitration_flushIt;
  wire                execute_arbitration_flushNext;
  reg                 execute_arbitration_isValid;
  wire                execute_arbitration_isStuck;
  wire                execute_arbitration_isStuckByOthers;
  wire                execute_arbitration_isFlushed;
  wire                execute_arbitration_isMoving;
  wire                execute_arbitration_isFiring;
  wire                memory_arbitration_haltItself;
  wire                memory_arbitration_haltByOther;
  reg                 memory_arbitration_removeIt;
  wire                memory_arbitration_flushIt;
  reg                 memory_arbitration_flushNext;
  reg                 memory_arbitration_isValid;
  wire                memory_arbitration_isStuck;
  wire                memory_arbitration_isStuckByOthers;
  wire                memory_arbitration_isFlushed;
  wire                memory_arbitration_isMoving;
  wire                memory_arbitration_isFiring;
  reg                 writeBack_arbitration_haltItself;
  wire                writeBack_arbitration_haltByOther;
  reg                 writeBack_arbitration_removeIt;
  reg                 writeBack_arbitration_flushIt;
  reg                 writeBack_arbitration_flushNext;
  reg                 writeBack_arbitration_isValid;
  wire                writeBack_arbitration_isStuck;
  wire                writeBack_arbitration_isStuckByOthers;
  wire                writeBack_arbitration_isFlushed;
  wire                writeBack_arbitration_isMoving;
  wire                writeBack_arbitration_isFiring;
  wire       [31:0]   lastStageInstruction /* verilator public */ ;
  wire       [31:0]   lastStagePc /* verilator public */ ;
  wire                lastStageIsValid /* verilator public */ ;
  wire                lastStageIsFiring /* verilator public */ ;
  wire                IBusCachedPlugin_fetcherHalt;
  reg                 IBusCachedPlugin_incomingInstruction;
  wire                IBusCachedPlugin_predictionJumpInterface_valid;
  (* keep , syn_keep *) wire       [31:0]   IBusCachedPlugin_predictionJumpInterface_payload /* synthesis syn_keep = 1 */ ;
  reg                 IBusCachedPlugin_decodePrediction_cmd_hadBranch;
  wire                IBusCachedPlugin_decodePrediction_rsp_wasWrong;
  wire                IBusCachedPlugin_pcValids_0;
  wire                IBusCachedPlugin_pcValids_1;
  wire                IBusCachedPlugin_pcValids_2;
  wire                IBusCachedPlugin_pcValids_3;
  wire                IBusCachedPlugin_mmuBus_cmd_0_isValid;
  wire                IBusCachedPlugin_mmuBus_cmd_0_isStuck;
  wire       [31:0]   IBusCachedPlugin_mmuBus_cmd_0_virtualAddress;
  wire                IBusCachedPlugin_mmuBus_cmd_0_bypassTranslation;
  wire       [31:0]   IBusCachedPlugin_mmuBus_rsp_physicalAddress;
  wire                IBusCachedPlugin_mmuBus_rsp_isIoAccess;
  wire                IBusCachedPlugin_mmuBus_rsp_isPaging;
  wire                IBusCachedPlugin_mmuBus_rsp_allowRead;
  wire                IBusCachedPlugin_mmuBus_rsp_allowWrite;
  wire                IBusCachedPlugin_mmuBus_rsp_allowExecute;
  wire                IBusCachedPlugin_mmuBus_rsp_exception;
  wire                IBusCachedPlugin_mmuBus_rsp_refilling;
  wire                IBusCachedPlugin_mmuBus_rsp_bypassTranslation;
  wire                IBusCachedPlugin_mmuBus_end;
  wire                IBusCachedPlugin_mmuBus_busy;
  wire                dBus_cmd_valid;
  wire                dBus_cmd_ready;
  wire                dBus_cmd_payload_wr;
  wire                dBus_cmd_payload_uncached;
  wire       [31:0]   dBus_cmd_payload_address;
  wire       [31:0]   dBus_cmd_payload_data;
  wire       [3:0]    dBus_cmd_payload_mask;
  wire       [2:0]    dBus_cmd_payload_size;
  wire                dBus_cmd_payload_last;
  wire                dBus_rsp_valid;
  wire                dBus_rsp_payload_last;
  wire       [31:0]   dBus_rsp_payload_data;
  wire                dBus_rsp_payload_error;
  wire                DBusCachedPlugin_mmuBus_cmd_0_isValid;
  wire                DBusCachedPlugin_mmuBus_cmd_0_isStuck;
  wire       [31:0]   DBusCachedPlugin_mmuBus_cmd_0_virtualAddress;
  wire                DBusCachedPlugin_mmuBus_cmd_0_bypassTranslation;
  wire       [31:0]   DBusCachedPlugin_mmuBus_rsp_physicalAddress;
  wire                DBusCachedPlugin_mmuBus_rsp_isIoAccess;
  wire                DBusCachedPlugin_mmuBus_rsp_isPaging;
  wire                DBusCachedPlugin_mmuBus_rsp_allowRead;
  wire                DBusCachedPlugin_mmuBus_rsp_allowWrite;
  wire                DBusCachedPlugin_mmuBus_rsp_allowExecute;
  wire                DBusCachedPlugin_mmuBus_rsp_exception;
  wire                DBusCachedPlugin_mmuBus_rsp_refilling;
  wire                DBusCachedPlugin_mmuBus_rsp_bypassTranslation;
  wire                DBusCachedPlugin_mmuBus_end;
  wire                DBusCachedPlugin_mmuBus_busy;
  reg                 DBusCachedPlugin_redoBranch_valid;
  wire       [31:0]   DBusCachedPlugin_redoBranch_payload;
  wire                BranchPlugin_jumpInterface_valid;
  wire       [31:0]   BranchPlugin_jumpInterface_payload;
  wire                IBusCachedPlugin_externalFlush;
  wire                IBusCachedPlugin_jump_pcLoad_valid;
  wire       [31:0]   IBusCachedPlugin_jump_pcLoad_payload;
  wire       [2:0]    _zz_66;
  wire       [2:0]    _zz_67;
  wire                _zz_68;
  wire                _zz_69;
  wire                IBusCachedPlugin_fetchPc_output_valid;
  wire                IBusCachedPlugin_fetchPc_output_ready;
  wire       [31:0]   IBusCachedPlugin_fetchPc_output_payload;
  reg        [31:0]   IBusCachedPlugin_fetchPc_pcReg /* verilator public */ ;
  reg                 IBusCachedPlugin_fetchPc_correction;
  reg                 IBusCachedPlugin_fetchPc_correctionReg;
  wire                IBusCachedPlugin_fetchPc_corrected;
  reg                 IBusCachedPlugin_fetchPc_pcRegPropagate;
  reg                 IBusCachedPlugin_fetchPc_booted;
  reg                 IBusCachedPlugin_fetchPc_inc;
  reg        [31:0]   IBusCachedPlugin_fetchPc_pc;
  wire                IBusCachedPlugin_fetchPc_redo_valid;
  wire       [31:0]   IBusCachedPlugin_fetchPc_redo_payload;
  reg                 IBusCachedPlugin_fetchPc_flushed;
  reg                 IBusCachedPlugin_iBusRsp_redoFetch;
  wire                IBusCachedPlugin_iBusRsp_stages_0_input_valid;
  wire                IBusCachedPlugin_iBusRsp_stages_0_input_ready;
  wire       [31:0]   IBusCachedPlugin_iBusRsp_stages_0_input_payload;
  wire                IBusCachedPlugin_iBusRsp_stages_0_output_valid;
  wire                IBusCachedPlugin_iBusRsp_stages_0_output_ready;
  wire       [31:0]   IBusCachedPlugin_iBusRsp_stages_0_output_payload;
  reg                 IBusCachedPlugin_iBusRsp_stages_0_halt;
  wire                IBusCachedPlugin_iBusRsp_stages_1_input_valid;
  wire                IBusCachedPlugin_iBusRsp_stages_1_input_ready;
  wire       [31:0]   IBusCachedPlugin_iBusRsp_stages_1_input_payload;
  wire                IBusCachedPlugin_iBusRsp_stages_1_output_valid;
  wire                IBusCachedPlugin_iBusRsp_stages_1_output_ready;
  wire       [31:0]   IBusCachedPlugin_iBusRsp_stages_1_output_payload;
  reg                 IBusCachedPlugin_iBusRsp_stages_1_halt;
  wire                IBusCachedPlugin_iBusRsp_stages_2_input_valid;
  wire                IBusCachedPlugin_iBusRsp_stages_2_input_ready;
  wire       [31:0]   IBusCachedPlugin_iBusRsp_stages_2_input_payload;
  wire                IBusCachedPlugin_iBusRsp_stages_2_output_valid;
  wire                IBusCachedPlugin_iBusRsp_stages_2_output_ready;
  wire       [31:0]   IBusCachedPlugin_iBusRsp_stages_2_output_payload;
  reg                 IBusCachedPlugin_iBusRsp_stages_2_halt;
  wire                _zz_70;
  wire                _zz_71;
  wire                _zz_72;
  wire                IBusCachedPlugin_iBusRsp_flush;
  wire                _zz_73;
  wire                _zz_74;
  reg                 _zz_75;
  wire                _zz_76;
  reg                 _zz_77;
  reg        [31:0]   _zz_78;
  reg                 IBusCachedPlugin_iBusRsp_readyForError;
  wire                IBusCachedPlugin_iBusRsp_output_valid;
  wire                IBusCachedPlugin_iBusRsp_output_ready;
  wire       [31:0]   IBusCachedPlugin_iBusRsp_output_payload_pc;
  wire                IBusCachedPlugin_iBusRsp_output_payload_rsp_error;
  wire       [31:0]   IBusCachedPlugin_iBusRsp_output_payload_rsp_inst;
  wire                IBusCachedPlugin_iBusRsp_output_payload_isRvc;
  reg                 IBusCachedPlugin_injector_nextPcCalc_valids_0;
  reg                 IBusCachedPlugin_injector_nextPcCalc_valids_1;
  reg                 IBusCachedPlugin_injector_nextPcCalc_valids_2;
  reg                 IBusCachedPlugin_injector_nextPcCalc_valids_3;
  reg                 IBusCachedPlugin_injector_nextPcCalc_valids_4;
  wire                _zz_79;
  reg        [18:0]   _zz_80;
  wire                _zz_81;
  reg        [10:0]   _zz_82;
  wire                _zz_83;
  reg        [18:0]   _zz_84;
  reg                 _zz_85;
  wire                _zz_86;
  reg        [10:0]   _zz_87;
  wire                _zz_88;
  reg        [18:0]   _zz_89;
  wire                iBus_cmd_valid;
  wire                iBus_cmd_ready;
  reg        [31:0]   iBus_cmd_payload_address;
  wire       [2:0]    iBus_cmd_payload_size;
  wire                iBus_rsp_valid;
  wire       [31:0]   iBus_rsp_payload_data;
  wire                iBus_rsp_payload_error;
  wire       [31:0]   _zz_90;
  reg        [31:0]   IBusCachedPlugin_rspCounter;
  wire                IBusCachedPlugin_s0_tightlyCoupledHit;
  reg                 IBusCachedPlugin_s1_tightlyCoupledHit;
  reg                 IBusCachedPlugin_s2_tightlyCoupledHit;
  wire                IBusCachedPlugin_rsp_iBusRspOutputHalt;
  wire                IBusCachedPlugin_rsp_issueDetected;
  reg                 IBusCachedPlugin_rsp_redoFetch;
  wire                dataCache_1_io_mem_cmd_m2sPipe_valid;
  wire                dataCache_1_io_mem_cmd_m2sPipe_ready;
  wire                dataCache_1_io_mem_cmd_m2sPipe_payload_wr;
  wire                dataCache_1_io_mem_cmd_m2sPipe_payload_uncached;
  wire       [31:0]   dataCache_1_io_mem_cmd_m2sPipe_payload_address;
  wire       [31:0]   dataCache_1_io_mem_cmd_m2sPipe_payload_data;
  wire       [3:0]    dataCache_1_io_mem_cmd_m2sPipe_payload_mask;
  wire       [2:0]    dataCache_1_io_mem_cmd_m2sPipe_payload_size;
  wire                dataCache_1_io_mem_cmd_m2sPipe_payload_last;
  reg                 dataCache_1_io_mem_cmd_m2sPipe_rValid;
  reg                 dataCache_1_io_mem_cmd_m2sPipe_rData_wr;
  reg                 dataCache_1_io_mem_cmd_m2sPipe_rData_uncached;
  reg        [31:0]   dataCache_1_io_mem_cmd_m2sPipe_rData_address;
  reg        [31:0]   dataCache_1_io_mem_cmd_m2sPipe_rData_data;
  reg        [3:0]    dataCache_1_io_mem_cmd_m2sPipe_rData_mask;
  reg        [2:0]    dataCache_1_io_mem_cmd_m2sPipe_rData_size;
  reg                 dataCache_1_io_mem_cmd_m2sPipe_rData_last;
  wire       [31:0]   _zz_91;
  reg        [31:0]   DBusCachedPlugin_rspCounter;
  wire       [1:0]    execute_DBusCachedPlugin_size;
  reg        [31:0]   _zz_92;
  wire       [7:0]    writeBack_DBusCachedPlugin_rspSplits_0;
  wire       [7:0]    writeBack_DBusCachedPlugin_rspSplits_1;
  wire       [7:0]    writeBack_DBusCachedPlugin_rspSplits_2;
  wire       [7:0]    writeBack_DBusCachedPlugin_rspSplits_3;
  reg        [31:0]   writeBack_DBusCachedPlugin_rspShifted;
  wire       [31:0]   writeBack_DBusCachedPlugin_rspRf;
  wire                _zz_93;
  reg        [31:0]   _zz_94;
  wire                _zz_95;
  reg        [31:0]   _zz_96;
  reg        [31:0]   writeBack_DBusCachedPlugin_rspFormated;
  wire       [34:0]   _zz_97;
  wire                _zz_98;
  wire                _zz_99;
  wire                _zz_100;
  wire                _zz_101;
  wire                _zz_102;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_103;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_104;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_105;
  wire       `Src3CtrlEnum_defaultEncoding_type _zz_106;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_107;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_108;
  wire       `CG6CtrlEnum_defaultEncoding_type _zz_109;
  wire       `CG6CtrlminmaxEnum_defaultEncoding_type _zz_110;
  wire       `CG6CtrlternaryEnum_defaultEncoding_type _zz_111;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_112;
  wire       [4:0]    decode_RegFilePlugin_regFileReadAddress1;
  wire       [4:0]    decode_RegFilePlugin_regFileReadAddress2;
  wire       [4:0]    decode_RegFilePlugin_regFileReadAddress3;
  wire       [31:0]   decode_RegFilePlugin_rs1Data;
  wire       [31:0]   decode_RegFilePlugin_rs2Data;
  wire       [31:0]   decode_RegFilePlugin_rs3Data;
  wire       [4:0]    writeBack_RegFilePlugin_rdIndex;
  reg                 lastStageRegFileWrite_valid /* verilator public */ ;
  reg        [4:0]    lastStageRegFileWrite_payload_address /* verilator public */ ;
  reg        [31:0]   lastStageRegFileWrite_payload_data /* verilator public */ ;
  reg                 _zz_113;
  reg        [31:0]   execute_IntAluPlugin_bitwise;
  reg        [31:0]   _zz_114;
  reg        [31:0]   _zz_115;
  wire                _zz_116;
  reg        [19:0]   _zz_117;
  wire                _zz_118;
  reg        [19:0]   _zz_119;
  reg        [31:0]   _zz_120;
  wire                _zz_121;
  reg        [19:0]   _zz_122;
  reg        [31:0]   _zz_123;
  reg        [31:0]   execute_SrcPlugin_addSub;
  wire                execute_SrcPlugin_less;
  wire       [4:0]    execute_FullBarrelShifterPlugin_amplitude;
  reg        [31:0]   _zz_124;
  wire       [31:0]   execute_FullBarrelShifterPlugin_reversed;
  reg        [31:0]   _zz_125;
  reg        [31:0]   execute_CG6Plugin_val_minmax;
  wire       [31:0]   _zz_126;
  wire       [31:0]   _zz_127;
  wire       [31:0]   _zz_128;
  reg        [31:0]   execute_CG6Plugin_val_ternary;
  reg        [31:0]   _zz_129;
  reg                 HazardSimplePlugin_src0Hazard;
  reg                 HazardSimplePlugin_src1Hazard;
  reg                 HazardSimplePlugin_src2Hazard;
  wire                HazardSimplePlugin_writeBackWrites_valid;
  wire       [4:0]    HazardSimplePlugin_writeBackWrites_payload_address;
  wire       [31:0]   HazardSimplePlugin_writeBackWrites_payload_data;
  wire                HazardSimplePlugin_notAES;
  wire       [4:0]    HazardSimplePlugin_rdIndex;
  wire       [4:0]    HazardSimplePlugin_regFileReadAddress3;
  reg                 HazardSimplePlugin_writeBackBuffer_valid;
  reg        [4:0]    HazardSimplePlugin_writeBackBuffer_payload_address;
  reg        [31:0]   HazardSimplePlugin_writeBackBuffer_payload_data;
  wire                HazardSimplePlugin_addr0Match;
  wire                HazardSimplePlugin_addr1Match;
  wire                HazardSimplePlugin_addr2Match;
  wire                _zz_130;
  wire       [4:0]    _zz_131;
  wire       [4:0]    _zz_132;
  wire       [4:0]    _zz_133;
  wire                _zz_134;
  wire                _zz_135;
  wire                _zz_136;
  wire                _zz_137;
  wire                _zz_138;
  wire                _zz_139;
  wire                _zz_140;
  wire       [4:0]    _zz_141;
  wire       [4:0]    _zz_142;
  wire       [4:0]    _zz_143;
  wire                _zz_144;
  wire                _zz_145;
  wire                _zz_146;
  wire                _zz_147;
  wire                _zz_148;
  wire                _zz_149;
  wire                _zz_150;
  wire       [4:0]    _zz_151;
  wire       [4:0]    _zz_152;
  wire       [4:0]    _zz_153;
  wire                _zz_154;
  wire                _zz_155;
  wire                _zz_156;
  wire                _zz_157;
  wire                _zz_158;
  wire                _zz_159;
  wire                execute_BranchPlugin_eq;
  wire       [2:0]    _zz_160;
  reg                 _zz_161;
  reg                 _zz_162;
  wire                _zz_163;
  reg        [19:0]   _zz_164;
  wire                _zz_165;
  reg        [10:0]   _zz_166;
  wire                _zz_167;
  reg        [18:0]   _zz_168;
  reg                 _zz_169;
  wire                execute_BranchPlugin_missAlignedTarget;
  reg        [31:0]   execute_BranchPlugin_branch_src1;
  reg        [31:0]   execute_BranchPlugin_branch_src2;
  wire                _zz_170;
  reg        [19:0]   _zz_171;
  wire                _zz_172;
  reg        [10:0]   _zz_173;
  wire                _zz_174;
  reg        [18:0]   _zz_175;
  wire       [31:0]   execute_BranchPlugin_branchAdder;
  reg        [31:0]   decode_to_execute_PC;
  reg        [31:0]   execute_to_memory_PC;
  reg        [31:0]   memory_to_writeBack_PC;
  reg        [31:0]   decode_to_execute_INSTRUCTION;
  reg        [31:0]   execute_to_memory_INSTRUCTION;
  reg        [31:0]   memory_to_writeBack_INSTRUCTION;
  reg        [31:0]   decode_to_execute_FORMAL_PC_NEXT;
  reg        [31:0]   execute_to_memory_FORMAL_PC_NEXT;
  reg        [31:0]   memory_to_writeBack_FORMAL_PC_NEXT;
  reg                 decode_to_execute_MEMORY_FORCE_CONSTISTENCY;
  reg        `Src1CtrlEnum_defaultEncoding_type decode_to_execute_SRC1_CTRL;
  reg                 decode_to_execute_SRC_USE_SUB_LESS;
  reg                 decode_to_execute_MEMORY_ENABLE;
  reg                 execute_to_memory_MEMORY_ENABLE;
  reg                 memory_to_writeBack_MEMORY_ENABLE;
  reg        `AluCtrlEnum_defaultEncoding_type decode_to_execute_ALU_CTRL;
  reg        `Src2CtrlEnum_defaultEncoding_type decode_to_execute_SRC2_CTRL;
  reg                 decode_to_execute_REGFILE_WRITE_VALID;
  reg                 execute_to_memory_REGFILE_WRITE_VALID;
  reg                 memory_to_writeBack_REGFILE_WRITE_VALID;
  reg                 decode_to_execute_BYPASSABLE_EXECUTE_STAGE;
  reg                 decode_to_execute_BYPASSABLE_MEMORY_STAGE;
  reg                 execute_to_memory_BYPASSABLE_MEMORY_STAGE;
  reg                 decode_to_execute_MEMORY_WR;
  reg                 decode_to_execute_MEMORY_MANAGMENT;
  reg        `Src3CtrlEnum_defaultEncoding_type decode_to_execute_SRC3_CTRL;
  reg                 decode_to_execute_SRC_LESS_UNSIGNED;
  reg        `AluBitwiseCtrlEnum_defaultEncoding_type decode_to_execute_ALU_BITWISE_CTRL;
  reg        `ShiftCtrlEnum_defaultEncoding_type decode_to_execute_SHIFT_CTRL;
  reg        `ShiftCtrlEnum_defaultEncoding_type execute_to_memory_SHIFT_CTRL;
  reg                 decode_to_execute_IS_CG6;
  reg                 execute_to_memory_IS_CG6;
  reg        `CG6CtrlEnum_defaultEncoding_type decode_to_execute_CG6Ctrl;
  reg        `CG6CtrlminmaxEnum_defaultEncoding_type decode_to_execute_CG6Ctrlminmax;
  reg        `CG6CtrlternaryEnum_defaultEncoding_type decode_to_execute_CG6Ctrlternary;
  reg        `BranchCtrlEnum_defaultEncoding_type decode_to_execute_BRANCH_CTRL;
  reg                 decode_to_execute_REGFILE_WRITE_VALID_ODD;
  reg                 execute_to_memory_REGFILE_WRITE_VALID_ODD;
  reg                 memory_to_writeBack_REGFILE_WRITE_VALID_ODD;
  reg        [31:0]   decode_to_execute_RS1;
  reg        [31:0]   decode_to_execute_RS2;
  reg        [31:0]   decode_to_execute_RS3;
  reg                 decode_to_execute_SRC2_FORCE_ZERO;
  reg                 decode_to_execute_PREDICTION_HAD_BRANCHED2;
  reg        [31:0]   execute_to_memory_MEMORY_STORE_DATA_RF;
  reg        [31:0]   memory_to_writeBack_MEMORY_STORE_DATA_RF;
  reg        [31:0]   execute_to_memory_REGFILE_WRITE_DATA;
  reg        [31:0]   memory_to_writeBack_REGFILE_WRITE_DATA;
  reg        [31:0]   execute_to_memory_REGFILE_WRITE_DATA_ODD;
  reg        [31:0]   memory_to_writeBack_REGFILE_WRITE_DATA_ODD;
  reg        [31:0]   execute_to_memory_SHIFT_RIGHT;
  reg        [31:0]   execute_to_memory_CG6_FINAL_OUTPUT;
  reg                 execute_to_memory_BRANCH_DO;
  reg        [31:0]   execute_to_memory_BRANCH_CALC;
  reg        [1:0]    _zz_176;
  reg                 _zz_177;
  reg        [31:0]   iBusWishbone_DAT_MISO_regNext;
  reg        [1:0]    _zz_178;
  wire                _zz_179;
  wire                _zz_180;
  wire                _zz_181;
  wire                _zz_182;
  wire                _zz_183;
  reg                 _zz_184;
  reg        [31:0]   dBusWishbone_DAT_MISO_regNext;
  `ifndef SYNTHESIS
  reg [31:0] _zz_1_string;
  reg [31:0] _zz_2_string;
  reg [71:0] decode_CG6Ctrlternary_string;
  reg [71:0] _zz_3_string;
  reg [71:0] _zz_4_string;
  reg [71:0] _zz_5_string;
  reg [71:0] decode_CG6Ctrlminmax_string;
  reg [71:0] _zz_6_string;
  reg [71:0] _zz_7_string;
  reg [71:0] _zz_8_string;
  reg [103:0] decode_CG6Ctrl_string;
  reg [103:0] _zz_9_string;
  reg [103:0] _zz_10_string;
  reg [103:0] _zz_11_string;
  reg [71:0] _zz_12_string;
  reg [71:0] _zz_13_string;
  reg [71:0] decode_SHIFT_CTRL_string;
  reg [71:0] _zz_14_string;
  reg [71:0] _zz_15_string;
  reg [71:0] _zz_16_string;
  reg [39:0] decode_ALU_BITWISE_CTRL_string;
  reg [39:0] _zz_17_string;
  reg [39:0] _zz_18_string;
  reg [39:0] _zz_19_string;
  reg [23:0] decode_SRC3_CTRL_string;
  reg [23:0] _zz_20_string;
  reg [23:0] _zz_21_string;
  reg [23:0] _zz_22_string;
  reg [23:0] decode_SRC2_CTRL_string;
  reg [23:0] _zz_23_string;
  reg [23:0] _zz_24_string;
  reg [23:0] _zz_25_string;
  reg [63:0] decode_ALU_CTRL_string;
  reg [63:0] _zz_26_string;
  reg [63:0] _zz_27_string;
  reg [63:0] _zz_28_string;
  reg [95:0] decode_SRC1_CTRL_string;
  reg [95:0] _zz_29_string;
  reg [95:0] _zz_30_string;
  reg [95:0] _zz_31_string;
  reg [31:0] execute_BRANCH_CTRL_string;
  reg [31:0] _zz_32_string;
  reg [103:0] execute_CG6Ctrl_string;
  reg [103:0] _zz_37_string;
  reg [71:0] execute_CG6Ctrlternary_string;
  reg [71:0] _zz_38_string;
  reg [71:0] execute_CG6Ctrlminmax_string;
  reg [71:0] _zz_39_string;
  reg [71:0] memory_SHIFT_CTRL_string;
  reg [71:0] _zz_41_string;
  reg [71:0] execute_SHIFT_CTRL_string;
  reg [71:0] _zz_42_string;
  reg [23:0] execute_SRC3_CTRL_string;
  reg [23:0] _zz_43_string;
  reg [23:0] execute_SRC2_CTRL_string;
  reg [23:0] _zz_45_string;
  reg [95:0] execute_SRC1_CTRL_string;
  reg [95:0] _zz_46_string;
  reg [63:0] execute_ALU_CTRL_string;
  reg [63:0] _zz_47_string;
  reg [39:0] execute_ALU_BITWISE_CTRL_string;
  reg [39:0] _zz_48_string;
  reg [31:0] _zz_52_string;
  reg [71:0] _zz_53_string;
  reg [71:0] _zz_54_string;
  reg [103:0] _zz_55_string;
  reg [71:0] _zz_56_string;
  reg [39:0] _zz_57_string;
  reg [23:0] _zz_58_string;
  reg [23:0] _zz_59_string;
  reg [63:0] _zz_60_string;
  reg [95:0] _zz_61_string;
  reg [31:0] decode_BRANCH_CTRL_string;
  reg [31:0] _zz_63_string;
  reg [95:0] _zz_103_string;
  reg [63:0] _zz_104_string;
  reg [23:0] _zz_105_string;
  reg [23:0] _zz_106_string;
  reg [39:0] _zz_107_string;
  reg [71:0] _zz_108_string;
  reg [103:0] _zz_109_string;
  reg [71:0] _zz_110_string;
  reg [71:0] _zz_111_string;
  reg [31:0] _zz_112_string;
  reg [95:0] decode_to_execute_SRC1_CTRL_string;
  reg [63:0] decode_to_execute_ALU_CTRL_string;
  reg [23:0] decode_to_execute_SRC2_CTRL_string;
  reg [23:0] decode_to_execute_SRC3_CTRL_string;
  reg [39:0] decode_to_execute_ALU_BITWISE_CTRL_string;
  reg [71:0] decode_to_execute_SHIFT_CTRL_string;
  reg [71:0] execute_to_memory_SHIFT_CTRL_string;
  reg [103:0] decode_to_execute_CG6Ctrl_string;
  reg [71:0] decode_to_execute_CG6Ctrlminmax_string;
  reg [71:0] decode_to_execute_CG6Ctrlternary_string;
  reg [31:0] decode_to_execute_BRANCH_CTRL_string;
  `endif

  reg [31:0] RegFilePlugin_regFile [0:31] /* verilator public */ ;

  assign _zz_220 = (writeBack_arbitration_isValid && writeBack_REGFILE_WRITE_VALID);
  assign _zz_221 = 1'b1;
  assign _zz_222 = ((writeBack_arbitration_isValid && _zz_130) && writeBack_REGFILE_WRITE_VALID_ODD);
  assign _zz_223 = 1'b1;
  assign _zz_224 = (memory_arbitration_isValid && memory_REGFILE_WRITE_VALID);
  assign _zz_225 = ((memory_arbitration_isValid && _zz_140) && memory_REGFILE_WRITE_VALID_ODD);
  assign _zz_226 = (execute_arbitration_isValid && execute_REGFILE_WRITE_VALID);
  assign _zz_227 = ((execute_arbitration_isValid && _zz_150) && execute_REGFILE_WRITE_VALID_ODD);
  assign _zz_228 = ((_zz_190 && IBusCachedPlugin_cache_io_cpu_decode_cacheMiss) && (! IBusCachedPlugin_rsp_issueDetected_1));
  assign _zz_229 = ((_zz_190 && IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling) && (! IBusCachedPlugin_rsp_issueDetected));
  assign _zz_230 = (writeBack_arbitration_isValid && writeBack_REGFILE_WRITE_VALID);
  assign _zz_231 = (1'b0 || (! 1'b1));
  assign _zz_232 = (memory_arbitration_isValid && memory_REGFILE_WRITE_VALID);
  assign _zz_233 = (1'b0 || (! memory_BYPASSABLE_MEMORY_STAGE));
  assign _zz_234 = (execute_arbitration_isValid && execute_REGFILE_WRITE_VALID);
  assign _zz_235 = (1'b0 || (! execute_BYPASSABLE_EXECUTE_STAGE));
  assign _zz_236 = (iBus_cmd_valid || (_zz_176 != 2'b00));
  assign _zz_237 = writeBack_INSTRUCTION[13 : 12];
  assign _zz_238 = ($signed(_zz_240) >>> execute_FullBarrelShifterPlugin_amplitude);
  assign _zz_239 = _zz_238[31 : 0];
  assign _zz_240 = {((execute_SHIFT_CTRL == `ShiftCtrlEnum_defaultEncoding_SRA_1) && execute_FullBarrelShifterPlugin_reversed[31]),execute_FullBarrelShifterPlugin_reversed};
  assign _zz_241 = (_zz_66 - 3'b001);
  assign _zz_242 = {IBusCachedPlugin_fetchPc_inc,2'b00};
  assign _zz_243 = {29'd0, _zz_242};
  assign _zz_244 = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_245 = {{_zz_80,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz_246 = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]};
  assign _zz_247 = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_248 = {{_zz_82,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]}},1'b0};
  assign _zz_249 = {{_zz_84,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz_250 = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]};
  assign _zz_251 = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_252 = execute_SRC_LESS;
  assign _zz_253 = 3'b100;
  assign _zz_254 = execute_INSTRUCTION[19 : 15];
  assign _zz_255 = {execute_INSTRUCTION[31 : 25],execute_INSTRUCTION[11 : 7]};
  assign _zz_256 = ($signed(_zz_257) + $signed(_zz_260));
  assign _zz_257 = ($signed(_zz_258) + $signed(_zz_259));
  assign _zz_258 = execute_SRC1;
  assign _zz_259 = (execute_SRC_USE_SUB_LESS ? (~ execute_SRC2) : execute_SRC2);
  assign _zz_260 = (execute_SRC_USE_SUB_LESS ? _zz_261 : _zz_262);
  assign _zz_261 = 32'h00000001;
  assign _zz_262 = 32'h0;
  assign _zz_263 = (_zz_126 - 32'h00000020);
  assign _zz_264 = (_zz_128 >>> _zz_127);
  assign _zz_265 = (((_zz_127 == _zz_126) ? execute_SRC3 : execute_SRC1) <<< _zz_266);
  assign _zz_266 = (32'h00000020 - _zz_127);
  assign _zz_267 = (_zz_268 + execute_SRC2);
  assign _zz_268 = (execute_SRC1 <<< 2);
  assign _zz_269 = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]};
  assign _zz_270 = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]};
  assign _zz_271 = {_zz_164,execute_INSTRUCTION[31 : 20]};
  assign _zz_272 = {{_zz_166,{{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]}},1'b0};
  assign _zz_273 = {{_zz_168,{{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz_274 = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]};
  assign _zz_275 = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]};
  assign _zz_276 = 3'b100;
  assign _zz_277 = (iBus_cmd_payload_address >>> 4);
  assign _zz_278 = 1'b1;
  assign _zz_279 = 1'b1;
  assign _zz_280 = 1'b1;
  assign _zz_281 = {_zz_69,_zz_68};
  assign _zz_282 = _zz_202[1 : 0];
  assign _zz_283 = _zz_202[1 : 1];
  assign _zz_284 = decode_INSTRUCTION[31];
  assign _zz_285 = decode_INSTRUCTION[31];
  assign _zz_286 = decode_INSTRUCTION[7];
  assign _zz_287 = (decode_INSTRUCTION & 32'h0000001c);
  assign _zz_288 = 32'h00000004;
  assign _zz_289 = (decode_INSTRUCTION & 32'h00000048);
  assign _zz_290 = 32'h00000040;
  assign _zz_291 = ((decode_INSTRUCTION & 32'h00000040) == 32'h00000040);
  assign _zz_292 = ((decode_INSTRUCTION & 32'h02000000) == 32'h0);
  assign _zz_293 = 1'b0;
  assign _zz_294 = (((decode_INSTRUCTION & _zz_297) == 32'h02004000) != 1'b0);
  assign _zz_295 = (_zz_101 != 1'b0);
  assign _zz_296 = {(_zz_298 != 1'b0),{(_zz_299 != _zz_300),{_zz_301,{_zz_302,_zz_303}}}};
  assign _zz_297 = 32'h02004000;
  assign _zz_298 = ((decode_INSTRUCTION & 32'h00002000) == 32'h0);
  assign _zz_299 = ((decode_INSTRUCTION & 32'h00400020) == 32'h0);
  assign _zz_300 = 1'b0;
  assign _zz_301 = ({_zz_102,(_zz_304 == _zz_305)} != 2'b00);
  assign _zz_302 = ({_zz_102,_zz_306} != 2'b00);
  assign _zz_303 = {({_zz_307,_zz_308} != 4'b0000),{(_zz_309 != _zz_310),{_zz_311,{_zz_312,_zz_313}}}};
  assign _zz_304 = (decode_INSTRUCTION & 32'h00004000);
  assign _zz_305 = 32'h0;
  assign _zz_306 = ((decode_INSTRUCTION & 32'h20000000) == 32'h0);
  assign _zz_307 = ((decode_INSTRUCTION & _zz_314) == 32'h08004020);
  assign _zz_308 = {_zz_101,{_zz_315,_zz_316}};
  assign _zz_309 = ((decode_INSTRUCTION & _zz_317) == 32'h00005010);
  assign _zz_310 = 1'b0;
  assign _zz_311 = ({_zz_318,_zz_319} != 2'b00);
  assign _zz_312 = (_zz_320 != 1'b0);
  assign _zz_313 = {(_zz_321 != _zz_322),{_zz_323,{_zz_324,_zz_325}}};
  assign _zz_314 = 32'h08004064;
  assign _zz_315 = ((decode_INSTRUCTION & 32'h20003014) == 32'h20001010);
  assign _zz_316 = ((decode_INSTRUCTION & 32'h20004064) == 32'h20004020);
  assign _zz_317 = 32'h0c007014;
  assign _zz_318 = ((decode_INSTRUCTION & 32'h64003014) == 32'h40001010);
  assign _zz_319 = ((decode_INSTRUCTION & 32'h44007014) == 32'h00001010);
  assign _zz_320 = ((decode_INSTRUCTION & 32'h00000064) == 32'h00000024);
  assign _zz_321 = ((decode_INSTRUCTION & _zz_326) == 32'h00001000);
  assign _zz_322 = 1'b0;
  assign _zz_323 = ((_zz_327 == _zz_328) != 1'b0);
  assign _zz_324 = ({_zz_329,_zz_330} != 2'b00);
  assign _zz_325 = {1'b0,{_zz_331,{_zz_332,_zz_333}}};
  assign _zz_326 = 32'h00001000;
  assign _zz_327 = (decode_INSTRUCTION & 32'h00003000);
  assign _zz_328 = 32'h00002000;
  assign _zz_329 = ((decode_INSTRUCTION & 32'h00002010) == 32'h00002000);
  assign _zz_330 = ((decode_INSTRUCTION & 32'h00005000) == 32'h00001000);
  assign _zz_331 = (((decode_INSTRUCTION & _zz_334) == 32'h00004008) != 1'b0);
  assign _zz_332 = ((_zz_335 == _zz_336) != 1'b0);
  assign _zz_333 = {(_zz_337 != 1'b0),{(_zz_338 != _zz_339),{_zz_340,{_zz_341,_zz_342}}}};
  assign _zz_334 = 32'h00004048;
  assign _zz_335 = (decode_INSTRUCTION & 32'h00000024);
  assign _zz_336 = 32'h00000020;
  assign _zz_337 = ((decode_INSTRUCTION & 32'h00000020) == 32'h00000020);
  assign _zz_338 = _zz_100;
  assign _zz_339 = 1'b0;
  assign _zz_340 = ({_zz_98,{_zz_343,{_zz_344,_zz_345}}} != 5'h0);
  assign _zz_341 = ({_zz_100,{_zz_346,_zz_347}} != 4'b0000);
  assign _zz_342 = {({_zz_348,_zz_349} != 2'b00),{(_zz_350 != _zz_351),{_zz_352,{_zz_353,_zz_354}}}};
  assign _zz_343 = ((decode_INSTRUCTION & _zz_355) == 32'h00002010);
  assign _zz_344 = (_zz_356 == _zz_357);
  assign _zz_345 = {_zz_358,_zz_359};
  assign _zz_346 = _zz_99;
  assign _zz_347 = {_zz_360,_zz_361};
  assign _zz_348 = _zz_98;
  assign _zz_349 = (_zz_362 == _zz_363);
  assign _zz_350 = {_zz_98,_zz_364};
  assign _zz_351 = 2'b00;
  assign _zz_352 = (_zz_365 != 1'b0);
  assign _zz_353 = (_zz_366 != _zz_367);
  assign _zz_354 = {_zz_368,{_zz_369,_zz_370}};
  assign _zz_355 = 32'h00002030;
  assign _zz_356 = (decode_INSTRUCTION & 32'h08002020);
  assign _zz_357 = 32'h00002020;
  assign _zz_358 = ((decode_INSTRUCTION & _zz_371) == 32'h00000010);
  assign _zz_359 = ((decode_INSTRUCTION & _zz_372) == 32'h00000020);
  assign _zz_360 = ((decode_INSTRUCTION & _zz_373) == 32'h00000004);
  assign _zz_361 = ((decode_INSTRUCTION & _zz_374) == 32'h0);
  assign _zz_362 = (decode_INSTRUCTION & 32'h00000070);
  assign _zz_363 = 32'h00000020;
  assign _zz_364 = ((decode_INSTRUCTION & _zz_375) == 32'h0);
  assign _zz_365 = ((decode_INSTRUCTION & _zz_376) == 32'h00004010);
  assign _zz_366 = (_zz_377 == _zz_378);
  assign _zz_367 = 1'b0;
  assign _zz_368 = ({_zz_379,_zz_380} != 2'b00);
  assign _zz_369 = (_zz_381 != _zz_382);
  assign _zz_370 = {_zz_383,{_zz_384,_zz_385}};
  assign _zz_371 = 32'h00001030;
  assign _zz_372 = 32'h20001020;
  assign _zz_373 = 32'h0000000c;
  assign _zz_374 = 32'h00000028;
  assign _zz_375 = 32'h00000020;
  assign _zz_376 = 32'h00004014;
  assign _zz_377 = (decode_INSTRUCTION & 32'h00006014);
  assign _zz_378 = 32'h00002010;
  assign _zz_379 = ((decode_INSTRUCTION & _zz_386) == 32'h0);
  assign _zz_380 = ((decode_INSTRUCTION & _zz_387) == 32'h0);
  assign _zz_381 = ((decode_INSTRUCTION & _zz_388) == 32'h0);
  assign _zz_382 = 1'b0;
  assign _zz_383 = ({_zz_389,{_zz_390,_zz_391}} != 3'b000);
  assign _zz_384 = (_zz_392 != 1'b0);
  assign _zz_385 = {(_zz_393 != _zz_394),(_zz_395 != _zz_396)};
  assign _zz_386 = 32'h00000004;
  assign _zz_387 = 32'h00000018;
  assign _zz_388 = 32'h00000058;
  assign _zz_389 = ((decode_INSTRUCTION & 32'h00000044) == 32'h00000040);
  assign _zz_390 = ((decode_INSTRUCTION & 32'h00002014) == 32'h00002010);
  assign _zz_391 = ((decode_INSTRUCTION & 32'h40000034) == 32'h40000030);
  assign _zz_392 = ((decode_INSTRUCTION & 32'h00000014) == 32'h00000004);
  assign _zz_393 = ((decode_INSTRUCTION & 32'h00000044) == 32'h00000004);
  assign _zz_394 = 1'b0;
  assign _zz_395 = ((decode_INSTRUCTION & 32'h00005048) == 32'h00001008);
  assign _zz_396 = 1'b0;
  assign _zz_397 = execute_INSTRUCTION[31];
  assign _zz_398 = execute_INSTRUCTION[31];
  assign _zz_399 = execute_INSTRUCTION[7];
  always @ (posedge clk) begin
    if(_zz_278) begin
      _zz_214 <= RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress1];
    end
  end

  always @ (posedge clk) begin
    if(_zz_279) begin
      _zz_215 <= RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress2];
    end
  end

  always @ (posedge clk) begin
    if(_zz_280) begin
      _zz_216 <= RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress3];
    end
  end

  always @ (posedge clk) begin
    if(_zz_50) begin
      RegFilePlugin_regFile[lastStageRegFileWrite_payload_address] <= lastStageRegFileWrite_payload_data;
    end
  end

  InstructionCache IBusCachedPlugin_cache (
    .io_flush                                 (_zz_185                                                     ), //i
    .io_cpu_prefetch_isValid                  (_zz_186                                                     ), //i
    .io_cpu_prefetch_haltIt                   (IBusCachedPlugin_cache_io_cpu_prefetch_haltIt               ), //o
    .io_cpu_prefetch_pc                       (IBusCachedPlugin_iBusRsp_stages_0_input_payload[31:0]       ), //i
    .io_cpu_fetch_isValid                     (_zz_187                                                     ), //i
    .io_cpu_fetch_isStuck                     (_zz_188                                                     ), //i
    .io_cpu_fetch_isRemoved                   (_zz_189                                                     ), //i
    .io_cpu_fetch_pc                          (IBusCachedPlugin_iBusRsp_stages_1_input_payload[31:0]       ), //i
    .io_cpu_fetch_data                        (IBusCachedPlugin_cache_io_cpu_fetch_data[31:0]              ), //o
    .io_cpu_fetch_mmuRsp_physicalAddress      (IBusCachedPlugin_mmuBus_rsp_physicalAddress[31:0]           ), //i
    .io_cpu_fetch_mmuRsp_isIoAccess           (IBusCachedPlugin_mmuBus_rsp_isIoAccess                      ), //i
    .io_cpu_fetch_mmuRsp_isPaging             (IBusCachedPlugin_mmuBus_rsp_isPaging                        ), //i
    .io_cpu_fetch_mmuRsp_allowRead            (IBusCachedPlugin_mmuBus_rsp_allowRead                       ), //i
    .io_cpu_fetch_mmuRsp_allowWrite           (IBusCachedPlugin_mmuBus_rsp_allowWrite                      ), //i
    .io_cpu_fetch_mmuRsp_allowExecute         (IBusCachedPlugin_mmuBus_rsp_allowExecute                    ), //i
    .io_cpu_fetch_mmuRsp_exception            (IBusCachedPlugin_mmuBus_rsp_exception                       ), //i
    .io_cpu_fetch_mmuRsp_refilling            (IBusCachedPlugin_mmuBus_rsp_refilling                       ), //i
    .io_cpu_fetch_mmuRsp_bypassTranslation    (IBusCachedPlugin_mmuBus_rsp_bypassTranslation               ), //i
    .io_cpu_fetch_physicalAddress             (IBusCachedPlugin_cache_io_cpu_fetch_physicalAddress[31:0]   ), //o
    .io_cpu_decode_isValid                    (_zz_190                                                     ), //i
    .io_cpu_decode_isStuck                    (_zz_191                                                     ), //i
    .io_cpu_decode_pc                         (IBusCachedPlugin_iBusRsp_stages_2_input_payload[31:0]       ), //i
    .io_cpu_decode_physicalAddress            (IBusCachedPlugin_cache_io_cpu_decode_physicalAddress[31:0]  ), //o
    .io_cpu_decode_data                       (IBusCachedPlugin_cache_io_cpu_decode_data[31:0]             ), //o
    .io_cpu_decode_cacheMiss                  (IBusCachedPlugin_cache_io_cpu_decode_cacheMiss              ), //o
    .io_cpu_decode_error                      (IBusCachedPlugin_cache_io_cpu_decode_error                  ), //o
    .io_cpu_decode_mmuRefilling               (IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling           ), //o
    .io_cpu_decode_mmuException               (IBusCachedPlugin_cache_io_cpu_decode_mmuException           ), //o
    .io_cpu_decode_isUser                     (_zz_192                                                     ), //i
    .io_cpu_fill_valid                        (_zz_193                                                     ), //i
    .io_cpu_fill_payload                      (IBusCachedPlugin_cache_io_cpu_decode_physicalAddress[31:0]  ), //i
    .io_mem_cmd_valid                         (IBusCachedPlugin_cache_io_mem_cmd_valid                     ), //o
    .io_mem_cmd_ready                         (iBus_cmd_ready                                              ), //i
    .io_mem_cmd_payload_address               (IBusCachedPlugin_cache_io_mem_cmd_payload_address[31:0]     ), //o
    .io_mem_cmd_payload_size                  (IBusCachedPlugin_cache_io_mem_cmd_payload_size[2:0]         ), //o
    .io_mem_rsp_valid                         (iBus_rsp_valid                                              ), //i
    .io_mem_rsp_payload_data                  (iBus_rsp_payload_data[31:0]                                 ), //i
    .io_mem_rsp_payload_error                 (iBus_rsp_payload_error                                      ), //i
    .clk                                      (clk                                                         ), //i
    .reset                                    (reset                                                       )  //i
  );
  DataCache dataCache_1 (
    .io_cpu_execute_isValid                    (_zz_194                                            ), //i
    .io_cpu_execute_address                    (_zz_195[31:0]                                      ), //i
    .io_cpu_execute_haltIt                     (dataCache_1_io_cpu_execute_haltIt                  ), //o
    .io_cpu_execute_args_wr                    (execute_MEMORY_WR                                  ), //i
    .io_cpu_execute_args_size                  (execute_DBusCachedPlugin_size[1:0]                 ), //i
    .io_cpu_execute_args_totalyConsistent      (execute_MEMORY_FORCE_CONSTISTENCY                  ), //i
    .io_cpu_execute_refilling                  (dataCache_1_io_cpu_execute_refilling               ), //o
    .io_cpu_memory_isValid                     (_zz_196                                            ), //i
    .io_cpu_memory_isStuck                     (memory_arbitration_isStuck                         ), //i
    .io_cpu_memory_isWrite                     (dataCache_1_io_cpu_memory_isWrite                  ), //o
    .io_cpu_memory_address                     (_zz_197[31:0]                                      ), //i
    .io_cpu_memory_mmuRsp_physicalAddress      (DBusCachedPlugin_mmuBus_rsp_physicalAddress[31:0]  ), //i
    .io_cpu_memory_mmuRsp_isIoAccess           (_zz_198                                            ), //i
    .io_cpu_memory_mmuRsp_isPaging             (DBusCachedPlugin_mmuBus_rsp_isPaging               ), //i
    .io_cpu_memory_mmuRsp_allowRead            (DBusCachedPlugin_mmuBus_rsp_allowRead              ), //i
    .io_cpu_memory_mmuRsp_allowWrite           (DBusCachedPlugin_mmuBus_rsp_allowWrite             ), //i
    .io_cpu_memory_mmuRsp_allowExecute         (DBusCachedPlugin_mmuBus_rsp_allowExecute           ), //i
    .io_cpu_memory_mmuRsp_exception            (DBusCachedPlugin_mmuBus_rsp_exception              ), //i
    .io_cpu_memory_mmuRsp_refilling            (DBusCachedPlugin_mmuBus_rsp_refilling              ), //i
    .io_cpu_memory_mmuRsp_bypassTranslation    (DBusCachedPlugin_mmuBus_rsp_bypassTranslation      ), //i
    .io_cpu_writeBack_isValid                  (_zz_199                                            ), //i
    .io_cpu_writeBack_isStuck                  (writeBack_arbitration_isStuck                      ), //i
    .io_cpu_writeBack_isUser                   (_zz_200                                            ), //i
    .io_cpu_writeBack_haltIt                   (dataCache_1_io_cpu_writeBack_haltIt                ), //o
    .io_cpu_writeBack_isWrite                  (dataCache_1_io_cpu_writeBack_isWrite               ), //o
    .io_cpu_writeBack_storeData                (_zz_201[31:0]                                      ), //i
    .io_cpu_writeBack_data                     (dataCache_1_io_cpu_writeBack_data[31:0]            ), //o
    .io_cpu_writeBack_address                  (_zz_202[31:0]                                      ), //i
    .io_cpu_writeBack_mmuException             (dataCache_1_io_cpu_writeBack_mmuException          ), //o
    .io_cpu_writeBack_unalignedAccess          (dataCache_1_io_cpu_writeBack_unalignedAccess       ), //o
    .io_cpu_writeBack_accessError              (dataCache_1_io_cpu_writeBack_accessError           ), //o
    .io_cpu_writeBack_keepMemRspData           (dataCache_1_io_cpu_writeBack_keepMemRspData        ), //o
    .io_cpu_writeBack_fence_SW                 (_zz_203                                            ), //i
    .io_cpu_writeBack_fence_SR                 (_zz_204                                            ), //i
    .io_cpu_writeBack_fence_SO                 (_zz_205                                            ), //i
    .io_cpu_writeBack_fence_SI                 (_zz_206                                            ), //i
    .io_cpu_writeBack_fence_PW                 (_zz_207                                            ), //i
    .io_cpu_writeBack_fence_PR                 (_zz_208                                            ), //i
    .io_cpu_writeBack_fence_PO                 (_zz_209                                            ), //i
    .io_cpu_writeBack_fence_PI                 (_zz_210                                            ), //i
    .io_cpu_writeBack_fence_FM                 (_zz_211[3:0]                                       ), //i
    .io_cpu_writeBack_exclusiveOk              (dataCache_1_io_cpu_writeBack_exclusiveOk           ), //o
    .io_cpu_redo                               (dataCache_1_io_cpu_redo                            ), //o
    .io_cpu_flush_valid                        (_zz_212                                            ), //i
    .io_cpu_flush_ready                        (dataCache_1_io_cpu_flush_ready                     ), //o
    .io_mem_cmd_valid                          (dataCache_1_io_mem_cmd_valid                       ), //o
    .io_mem_cmd_ready                          (_zz_213                                            ), //i
    .io_mem_cmd_payload_wr                     (dataCache_1_io_mem_cmd_payload_wr                  ), //o
    .io_mem_cmd_payload_uncached               (dataCache_1_io_mem_cmd_payload_uncached            ), //o
    .io_mem_cmd_payload_address                (dataCache_1_io_mem_cmd_payload_address[31:0]       ), //o
    .io_mem_cmd_payload_data                   (dataCache_1_io_mem_cmd_payload_data[31:0]          ), //o
    .io_mem_cmd_payload_mask                   (dataCache_1_io_mem_cmd_payload_mask[3:0]           ), //o
    .io_mem_cmd_payload_size                   (dataCache_1_io_mem_cmd_payload_size[2:0]           ), //o
    .io_mem_cmd_payload_last                   (dataCache_1_io_mem_cmd_payload_last                ), //o
    .io_mem_rsp_valid                          (dBus_rsp_valid                                     ), //i
    .io_mem_rsp_payload_last                   (dBus_rsp_payload_last                              ), //i
    .io_mem_rsp_payload_data                   (dBus_rsp_payload_data[31:0]                        ), //i
    .io_mem_rsp_payload_error                  (dBus_rsp_payload_error                             ), //i
    .clk                                       (clk                                                ), //i
    .reset                                     (reset                                              )  //i
  );
  always @(*) begin
    case(_zz_281)
      2'b00 : begin
        _zz_217 = DBusCachedPlugin_redoBranch_payload;
      end
      2'b01 : begin
        _zz_217 = BranchPlugin_jumpInterface_payload;
      end
      default : begin
        _zz_217 = IBusCachedPlugin_predictionJumpInterface_payload;
      end
    endcase
  end

  always @(*) begin
    case(_zz_282)
      2'b00 : begin
        _zz_218 = writeBack_DBusCachedPlugin_rspSplits_0;
      end
      2'b01 : begin
        _zz_218 = writeBack_DBusCachedPlugin_rspSplits_1;
      end
      2'b10 : begin
        _zz_218 = writeBack_DBusCachedPlugin_rspSplits_2;
      end
      default : begin
        _zz_218 = writeBack_DBusCachedPlugin_rspSplits_3;
      end
    endcase
  end

  always @(*) begin
    case(_zz_283)
      1'b0 : begin
        _zz_219 = writeBack_DBusCachedPlugin_rspSplits_1;
      end
      default : begin
        _zz_219 = writeBack_DBusCachedPlugin_rspSplits_3;
      end
    endcase
  end

  `ifndef SYNTHESIS
  always @(*) begin
    case(_zz_1)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_1_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_1_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_1_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_1_string = "JALR";
      default : _zz_1_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_2)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_2_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_2_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_2_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_2_string = "JALR";
      default : _zz_2_string = "????";
    endcase
  end
  always @(*) begin
    case(decode_CG6Ctrlternary)
      `CG6CtrlternaryEnum_defaultEncoding_CTRL_CMIX : decode_CG6Ctrlternary_string = "CTRL_CMIX";
      `CG6CtrlternaryEnum_defaultEncoding_CTRL_CMOV : decode_CG6Ctrlternary_string = "CTRL_CMOV";
      `CG6CtrlternaryEnum_defaultEncoding_CTRL_FSR : decode_CG6Ctrlternary_string = "CTRL_FSR ";
      default : decode_CG6Ctrlternary_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_3)
      `CG6CtrlternaryEnum_defaultEncoding_CTRL_CMIX : _zz_3_string = "CTRL_CMIX";
      `CG6CtrlternaryEnum_defaultEncoding_CTRL_CMOV : _zz_3_string = "CTRL_CMOV";
      `CG6CtrlternaryEnum_defaultEncoding_CTRL_FSR : _zz_3_string = "CTRL_FSR ";
      default : _zz_3_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_4)
      `CG6CtrlternaryEnum_defaultEncoding_CTRL_CMIX : _zz_4_string = "CTRL_CMIX";
      `CG6CtrlternaryEnum_defaultEncoding_CTRL_CMOV : _zz_4_string = "CTRL_CMOV";
      `CG6CtrlternaryEnum_defaultEncoding_CTRL_FSR : _zz_4_string = "CTRL_FSR ";
      default : _zz_4_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_5)
      `CG6CtrlternaryEnum_defaultEncoding_CTRL_CMIX : _zz_5_string = "CTRL_CMIX";
      `CG6CtrlternaryEnum_defaultEncoding_CTRL_CMOV : _zz_5_string = "CTRL_CMOV";
      `CG6CtrlternaryEnum_defaultEncoding_CTRL_FSR : _zz_5_string = "CTRL_FSR ";
      default : _zz_5_string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_CG6Ctrlminmax)
      `CG6CtrlminmaxEnum_defaultEncoding_CTRL_MAXU : decode_CG6Ctrlminmax_string = "CTRL_MAXU";
      `CG6CtrlminmaxEnum_defaultEncoding_CTRL_MINU : decode_CG6Ctrlminmax_string = "CTRL_MINU";
      default : decode_CG6Ctrlminmax_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_6)
      `CG6CtrlminmaxEnum_defaultEncoding_CTRL_MAXU : _zz_6_string = "CTRL_MAXU";
      `CG6CtrlminmaxEnum_defaultEncoding_CTRL_MINU : _zz_6_string = "CTRL_MINU";
      default : _zz_6_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_7)
      `CG6CtrlminmaxEnum_defaultEncoding_CTRL_MAXU : _zz_7_string = "CTRL_MAXU";
      `CG6CtrlminmaxEnum_defaultEncoding_CTRL_MINU : _zz_7_string = "CTRL_MINU";
      default : _zz_7_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_8)
      `CG6CtrlminmaxEnum_defaultEncoding_CTRL_MAXU : _zz_8_string = "CTRL_MAXU";
      `CG6CtrlminmaxEnum_defaultEncoding_CTRL_MINU : _zz_8_string = "CTRL_MINU";
      default : _zz_8_string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_CG6Ctrl)
      `CG6CtrlEnum_defaultEncoding_CTRL_SH2ADD : decode_CG6Ctrl_string = "CTRL_SH2ADD  ";
      `CG6CtrlEnum_defaultEncoding_CTRL_minmax : decode_CG6Ctrl_string = "CTRL_minmax  ";
      `CG6CtrlEnum_defaultEncoding_CTRL_SEXTdotB : decode_CG6Ctrl_string = "CTRL_SEXTdotB";
      `CG6CtrlEnum_defaultEncoding_CTRL_ternary : decode_CG6Ctrl_string = "CTRL_ternary ";
      `CG6CtrlEnum_defaultEncoding_CTRL_REV8 : decode_CG6Ctrl_string = "CTRL_REV8    ";
      default : decode_CG6Ctrl_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(_zz_9)
      `CG6CtrlEnum_defaultEncoding_CTRL_SH2ADD : _zz_9_string = "CTRL_SH2ADD  ";
      `CG6CtrlEnum_defaultEncoding_CTRL_minmax : _zz_9_string = "CTRL_minmax  ";
      `CG6CtrlEnum_defaultEncoding_CTRL_SEXTdotB : _zz_9_string = "CTRL_SEXTdotB";
      `CG6CtrlEnum_defaultEncoding_CTRL_ternary : _zz_9_string = "CTRL_ternary ";
      `CG6CtrlEnum_defaultEncoding_CTRL_REV8 : _zz_9_string = "CTRL_REV8    ";
      default : _zz_9_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(_zz_10)
      `CG6CtrlEnum_defaultEncoding_CTRL_SH2ADD : _zz_10_string = "CTRL_SH2ADD  ";
      `CG6CtrlEnum_defaultEncoding_CTRL_minmax : _zz_10_string = "CTRL_minmax  ";
      `CG6CtrlEnum_defaultEncoding_CTRL_SEXTdotB : _zz_10_string = "CTRL_SEXTdotB";
      `CG6CtrlEnum_defaultEncoding_CTRL_ternary : _zz_10_string = "CTRL_ternary ";
      `CG6CtrlEnum_defaultEncoding_CTRL_REV8 : _zz_10_string = "CTRL_REV8    ";
      default : _zz_10_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(_zz_11)
      `CG6CtrlEnum_defaultEncoding_CTRL_SH2ADD : _zz_11_string = "CTRL_SH2ADD  ";
      `CG6CtrlEnum_defaultEncoding_CTRL_minmax : _zz_11_string = "CTRL_minmax  ";
      `CG6CtrlEnum_defaultEncoding_CTRL_SEXTdotB : _zz_11_string = "CTRL_SEXTdotB";
      `CG6CtrlEnum_defaultEncoding_CTRL_ternary : _zz_11_string = "CTRL_ternary ";
      `CG6CtrlEnum_defaultEncoding_CTRL_REV8 : _zz_11_string = "CTRL_REV8    ";
      default : _zz_11_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(_zz_12)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_12_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_12_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_12_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_12_string = "SRA_1    ";
      default : _zz_12_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_13)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_13_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_13_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_13_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_13_string = "SRA_1    ";
      default : _zz_13_string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : decode_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : decode_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : decode_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : decode_SHIFT_CTRL_string = "SRA_1    ";
      default : decode_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_14)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_14_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_14_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_14_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_14_string = "SRA_1    ";
      default : _zz_14_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_15)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_15_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_15_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_15_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_15_string = "SRA_1    ";
      default : _zz_15_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_16)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_16_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_16_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_16_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_16_string = "SRA_1    ";
      default : _zz_16_string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : decode_ALU_BITWISE_CTRL_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : decode_ALU_BITWISE_CTRL_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : decode_ALU_BITWISE_CTRL_string = "AND_1";
      default : decode_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_17)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_17_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_17_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_17_string = "AND_1";
      default : _zz_17_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_18)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_18_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_18_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_18_string = "AND_1";
      default : _zz_18_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_19)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_19_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_19_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_19_string = "AND_1";
      default : _zz_19_string = "?????";
    endcase
  end
  always @(*) begin
    case(decode_SRC3_CTRL)
      `Src3CtrlEnum_defaultEncoding_RS : decode_SRC3_CTRL_string = "RS ";
      `Src3CtrlEnum_defaultEncoding_IMI : decode_SRC3_CTRL_string = "IMI";
      default : decode_SRC3_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_20)
      `Src3CtrlEnum_defaultEncoding_RS : _zz_20_string = "RS ";
      `Src3CtrlEnum_defaultEncoding_IMI : _zz_20_string = "IMI";
      default : _zz_20_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_21)
      `Src3CtrlEnum_defaultEncoding_RS : _zz_21_string = "RS ";
      `Src3CtrlEnum_defaultEncoding_IMI : _zz_21_string = "IMI";
      default : _zz_21_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_22)
      `Src3CtrlEnum_defaultEncoding_RS : _zz_22_string = "RS ";
      `Src3CtrlEnum_defaultEncoding_IMI : _zz_22_string = "IMI";
      default : _zz_22_string = "???";
    endcase
  end
  always @(*) begin
    case(decode_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : decode_SRC2_CTRL_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : decode_SRC2_CTRL_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : decode_SRC2_CTRL_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : decode_SRC2_CTRL_string = "PC ";
      default : decode_SRC2_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_23)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_23_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_23_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_23_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_23_string = "PC ";
      default : _zz_23_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_24)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_24_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_24_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_24_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_24_string = "PC ";
      default : _zz_24_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_25)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_25_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_25_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_25_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_25_string = "PC ";
      default : _zz_25_string = "???";
    endcase
  end
  always @(*) begin
    case(decode_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : decode_ALU_CTRL_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : decode_ALU_CTRL_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : decode_ALU_CTRL_string = "BITWISE ";
      default : decode_ALU_CTRL_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_26)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_26_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_26_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_26_string = "BITWISE ";
      default : _zz_26_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_27)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_27_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_27_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_27_string = "BITWISE ";
      default : _zz_27_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_28)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_28_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_28_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_28_string = "BITWISE ";
      default : _zz_28_string = "????????";
    endcase
  end
  always @(*) begin
    case(decode_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : decode_SRC1_CTRL_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : decode_SRC1_CTRL_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : decode_SRC1_CTRL_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : decode_SRC1_CTRL_string = "URS1        ";
      default : decode_SRC1_CTRL_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_29)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_29_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_29_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_29_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_29_string = "URS1        ";
      default : _zz_29_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_30)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_30_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_30_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_30_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_30_string = "URS1        ";
      default : _zz_30_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_31)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_31_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_31_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_31_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_31_string = "URS1        ";
      default : _zz_31_string = "????????????";
    endcase
  end
  always @(*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : execute_BRANCH_CTRL_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : execute_BRANCH_CTRL_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : execute_BRANCH_CTRL_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : execute_BRANCH_CTRL_string = "JALR";
      default : execute_BRANCH_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_32)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_32_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_32_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_32_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_32_string = "JALR";
      default : _zz_32_string = "????";
    endcase
  end
  always @(*) begin
    case(execute_CG6Ctrl)
      `CG6CtrlEnum_defaultEncoding_CTRL_SH2ADD : execute_CG6Ctrl_string = "CTRL_SH2ADD  ";
      `CG6CtrlEnum_defaultEncoding_CTRL_minmax : execute_CG6Ctrl_string = "CTRL_minmax  ";
      `CG6CtrlEnum_defaultEncoding_CTRL_SEXTdotB : execute_CG6Ctrl_string = "CTRL_SEXTdotB";
      `CG6CtrlEnum_defaultEncoding_CTRL_ternary : execute_CG6Ctrl_string = "CTRL_ternary ";
      `CG6CtrlEnum_defaultEncoding_CTRL_REV8 : execute_CG6Ctrl_string = "CTRL_REV8    ";
      default : execute_CG6Ctrl_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(_zz_37)
      `CG6CtrlEnum_defaultEncoding_CTRL_SH2ADD : _zz_37_string = "CTRL_SH2ADD  ";
      `CG6CtrlEnum_defaultEncoding_CTRL_minmax : _zz_37_string = "CTRL_minmax  ";
      `CG6CtrlEnum_defaultEncoding_CTRL_SEXTdotB : _zz_37_string = "CTRL_SEXTdotB";
      `CG6CtrlEnum_defaultEncoding_CTRL_ternary : _zz_37_string = "CTRL_ternary ";
      `CG6CtrlEnum_defaultEncoding_CTRL_REV8 : _zz_37_string = "CTRL_REV8    ";
      default : _zz_37_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(execute_CG6Ctrlternary)
      `CG6CtrlternaryEnum_defaultEncoding_CTRL_CMIX : execute_CG6Ctrlternary_string = "CTRL_CMIX";
      `CG6CtrlternaryEnum_defaultEncoding_CTRL_CMOV : execute_CG6Ctrlternary_string = "CTRL_CMOV";
      `CG6CtrlternaryEnum_defaultEncoding_CTRL_FSR : execute_CG6Ctrlternary_string = "CTRL_FSR ";
      default : execute_CG6Ctrlternary_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_38)
      `CG6CtrlternaryEnum_defaultEncoding_CTRL_CMIX : _zz_38_string = "CTRL_CMIX";
      `CG6CtrlternaryEnum_defaultEncoding_CTRL_CMOV : _zz_38_string = "CTRL_CMOV";
      `CG6CtrlternaryEnum_defaultEncoding_CTRL_FSR : _zz_38_string = "CTRL_FSR ";
      default : _zz_38_string = "?????????";
    endcase
  end
  always @(*) begin
    case(execute_CG6Ctrlminmax)
      `CG6CtrlminmaxEnum_defaultEncoding_CTRL_MAXU : execute_CG6Ctrlminmax_string = "CTRL_MAXU";
      `CG6CtrlminmaxEnum_defaultEncoding_CTRL_MINU : execute_CG6Ctrlminmax_string = "CTRL_MINU";
      default : execute_CG6Ctrlminmax_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_39)
      `CG6CtrlminmaxEnum_defaultEncoding_CTRL_MAXU : _zz_39_string = "CTRL_MAXU";
      `CG6CtrlminmaxEnum_defaultEncoding_CTRL_MINU : _zz_39_string = "CTRL_MINU";
      default : _zz_39_string = "?????????";
    endcase
  end
  always @(*) begin
    case(memory_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : memory_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : memory_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : memory_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : memory_SHIFT_CTRL_string = "SRA_1    ";
      default : memory_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_41)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_41_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_41_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_41_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_41_string = "SRA_1    ";
      default : _zz_41_string = "?????????";
    endcase
  end
  always @(*) begin
    case(execute_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : execute_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : execute_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : execute_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : execute_SHIFT_CTRL_string = "SRA_1    ";
      default : execute_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_42)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_42_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_42_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_42_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_42_string = "SRA_1    ";
      default : _zz_42_string = "?????????";
    endcase
  end
  always @(*) begin
    case(execute_SRC3_CTRL)
      `Src3CtrlEnum_defaultEncoding_RS : execute_SRC3_CTRL_string = "RS ";
      `Src3CtrlEnum_defaultEncoding_IMI : execute_SRC3_CTRL_string = "IMI";
      default : execute_SRC3_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_43)
      `Src3CtrlEnum_defaultEncoding_RS : _zz_43_string = "RS ";
      `Src3CtrlEnum_defaultEncoding_IMI : _zz_43_string = "IMI";
      default : _zz_43_string = "???";
    endcase
  end
  always @(*) begin
    case(execute_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : execute_SRC2_CTRL_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : execute_SRC2_CTRL_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : execute_SRC2_CTRL_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : execute_SRC2_CTRL_string = "PC ";
      default : execute_SRC2_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_45)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_45_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_45_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_45_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_45_string = "PC ";
      default : _zz_45_string = "???";
    endcase
  end
  always @(*) begin
    case(execute_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : execute_SRC1_CTRL_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : execute_SRC1_CTRL_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : execute_SRC1_CTRL_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : execute_SRC1_CTRL_string = "URS1        ";
      default : execute_SRC1_CTRL_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_46)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_46_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_46_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_46_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_46_string = "URS1        ";
      default : _zz_46_string = "????????????";
    endcase
  end
  always @(*) begin
    case(execute_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : execute_ALU_CTRL_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : execute_ALU_CTRL_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : execute_ALU_CTRL_string = "BITWISE ";
      default : execute_ALU_CTRL_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_47)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_47_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_47_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_47_string = "BITWISE ";
      default : _zz_47_string = "????????";
    endcase
  end
  always @(*) begin
    case(execute_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : execute_ALU_BITWISE_CTRL_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : execute_ALU_BITWISE_CTRL_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : execute_ALU_BITWISE_CTRL_string = "AND_1";
      default : execute_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_48)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_48_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_48_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_48_string = "AND_1";
      default : _zz_48_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_52)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_52_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_52_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_52_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_52_string = "JALR";
      default : _zz_52_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_53)
      `CG6CtrlternaryEnum_defaultEncoding_CTRL_CMIX : _zz_53_string = "CTRL_CMIX";
      `CG6CtrlternaryEnum_defaultEncoding_CTRL_CMOV : _zz_53_string = "CTRL_CMOV";
      `CG6CtrlternaryEnum_defaultEncoding_CTRL_FSR : _zz_53_string = "CTRL_FSR ";
      default : _zz_53_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_54)
      `CG6CtrlminmaxEnum_defaultEncoding_CTRL_MAXU : _zz_54_string = "CTRL_MAXU";
      `CG6CtrlminmaxEnum_defaultEncoding_CTRL_MINU : _zz_54_string = "CTRL_MINU";
      default : _zz_54_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_55)
      `CG6CtrlEnum_defaultEncoding_CTRL_SH2ADD : _zz_55_string = "CTRL_SH2ADD  ";
      `CG6CtrlEnum_defaultEncoding_CTRL_minmax : _zz_55_string = "CTRL_minmax  ";
      `CG6CtrlEnum_defaultEncoding_CTRL_SEXTdotB : _zz_55_string = "CTRL_SEXTdotB";
      `CG6CtrlEnum_defaultEncoding_CTRL_ternary : _zz_55_string = "CTRL_ternary ";
      `CG6CtrlEnum_defaultEncoding_CTRL_REV8 : _zz_55_string = "CTRL_REV8    ";
      default : _zz_55_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(_zz_56)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_56_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_56_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_56_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_56_string = "SRA_1    ";
      default : _zz_56_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_57)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_57_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_57_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_57_string = "AND_1";
      default : _zz_57_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_58)
      `Src3CtrlEnum_defaultEncoding_RS : _zz_58_string = "RS ";
      `Src3CtrlEnum_defaultEncoding_IMI : _zz_58_string = "IMI";
      default : _zz_58_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_59)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_59_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_59_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_59_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_59_string = "PC ";
      default : _zz_59_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_60)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_60_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_60_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_60_string = "BITWISE ";
      default : _zz_60_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_61)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_61_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_61_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_61_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_61_string = "URS1        ";
      default : _zz_61_string = "????????????";
    endcase
  end
  always @(*) begin
    case(decode_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : decode_BRANCH_CTRL_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : decode_BRANCH_CTRL_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : decode_BRANCH_CTRL_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : decode_BRANCH_CTRL_string = "JALR";
      default : decode_BRANCH_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_63)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_63_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_63_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_63_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_63_string = "JALR";
      default : _zz_63_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_103)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_103_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_103_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_103_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_103_string = "URS1        ";
      default : _zz_103_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_104)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_104_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_104_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_104_string = "BITWISE ";
      default : _zz_104_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_105)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_105_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_105_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_105_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_105_string = "PC ";
      default : _zz_105_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_106)
      `Src3CtrlEnum_defaultEncoding_RS : _zz_106_string = "RS ";
      `Src3CtrlEnum_defaultEncoding_IMI : _zz_106_string = "IMI";
      default : _zz_106_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_107)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_107_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_107_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_107_string = "AND_1";
      default : _zz_107_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_108)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_108_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_108_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_108_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_108_string = "SRA_1    ";
      default : _zz_108_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_109)
      `CG6CtrlEnum_defaultEncoding_CTRL_SH2ADD : _zz_109_string = "CTRL_SH2ADD  ";
      `CG6CtrlEnum_defaultEncoding_CTRL_minmax : _zz_109_string = "CTRL_minmax  ";
      `CG6CtrlEnum_defaultEncoding_CTRL_SEXTdotB : _zz_109_string = "CTRL_SEXTdotB";
      `CG6CtrlEnum_defaultEncoding_CTRL_ternary : _zz_109_string = "CTRL_ternary ";
      `CG6CtrlEnum_defaultEncoding_CTRL_REV8 : _zz_109_string = "CTRL_REV8    ";
      default : _zz_109_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(_zz_110)
      `CG6CtrlminmaxEnum_defaultEncoding_CTRL_MAXU : _zz_110_string = "CTRL_MAXU";
      `CG6CtrlminmaxEnum_defaultEncoding_CTRL_MINU : _zz_110_string = "CTRL_MINU";
      default : _zz_110_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_111)
      `CG6CtrlternaryEnum_defaultEncoding_CTRL_CMIX : _zz_111_string = "CTRL_CMIX";
      `CG6CtrlternaryEnum_defaultEncoding_CTRL_CMOV : _zz_111_string = "CTRL_CMOV";
      `CG6CtrlternaryEnum_defaultEncoding_CTRL_FSR : _zz_111_string = "CTRL_FSR ";
      default : _zz_111_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_112)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_112_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_112_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_112_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_112_string = "JALR";
      default : _zz_112_string = "????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : decode_to_execute_SRC1_CTRL_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : decode_to_execute_SRC1_CTRL_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : decode_to_execute_SRC1_CTRL_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : decode_to_execute_SRC1_CTRL_string = "URS1        ";
      default : decode_to_execute_SRC1_CTRL_string = "????????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : decode_to_execute_ALU_CTRL_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : decode_to_execute_ALU_CTRL_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : decode_to_execute_ALU_CTRL_string = "BITWISE ";
      default : decode_to_execute_ALU_CTRL_string = "????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : decode_to_execute_SRC2_CTRL_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : decode_to_execute_SRC2_CTRL_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : decode_to_execute_SRC2_CTRL_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : decode_to_execute_SRC2_CTRL_string = "PC ";
      default : decode_to_execute_SRC2_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_SRC3_CTRL)
      `Src3CtrlEnum_defaultEncoding_RS : decode_to_execute_SRC3_CTRL_string = "RS ";
      `Src3CtrlEnum_defaultEncoding_IMI : decode_to_execute_SRC3_CTRL_string = "IMI";
      default : decode_to_execute_SRC3_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : decode_to_execute_ALU_BITWISE_CTRL_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : decode_to_execute_ALU_BITWISE_CTRL_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : decode_to_execute_ALU_BITWISE_CTRL_string = "AND_1";
      default : decode_to_execute_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : decode_to_execute_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : decode_to_execute_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : decode_to_execute_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : decode_to_execute_SHIFT_CTRL_string = "SRA_1    ";
      default : decode_to_execute_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(execute_to_memory_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : execute_to_memory_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : execute_to_memory_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : execute_to_memory_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : execute_to_memory_SHIFT_CTRL_string = "SRA_1    ";
      default : execute_to_memory_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_CG6Ctrl)
      `CG6CtrlEnum_defaultEncoding_CTRL_SH2ADD : decode_to_execute_CG6Ctrl_string = "CTRL_SH2ADD  ";
      `CG6CtrlEnum_defaultEncoding_CTRL_minmax : decode_to_execute_CG6Ctrl_string = "CTRL_minmax  ";
      `CG6CtrlEnum_defaultEncoding_CTRL_SEXTdotB : decode_to_execute_CG6Ctrl_string = "CTRL_SEXTdotB";
      `CG6CtrlEnum_defaultEncoding_CTRL_ternary : decode_to_execute_CG6Ctrl_string = "CTRL_ternary ";
      `CG6CtrlEnum_defaultEncoding_CTRL_REV8 : decode_to_execute_CG6Ctrl_string = "CTRL_REV8    ";
      default : decode_to_execute_CG6Ctrl_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_CG6Ctrlminmax)
      `CG6CtrlminmaxEnum_defaultEncoding_CTRL_MAXU : decode_to_execute_CG6Ctrlminmax_string = "CTRL_MAXU";
      `CG6CtrlminmaxEnum_defaultEncoding_CTRL_MINU : decode_to_execute_CG6Ctrlminmax_string = "CTRL_MINU";
      default : decode_to_execute_CG6Ctrlminmax_string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_CG6Ctrlternary)
      `CG6CtrlternaryEnum_defaultEncoding_CTRL_CMIX : decode_to_execute_CG6Ctrlternary_string = "CTRL_CMIX";
      `CG6CtrlternaryEnum_defaultEncoding_CTRL_CMOV : decode_to_execute_CG6Ctrlternary_string = "CTRL_CMOV";
      `CG6CtrlternaryEnum_defaultEncoding_CTRL_FSR : decode_to_execute_CG6Ctrlternary_string = "CTRL_FSR ";
      default : decode_to_execute_CG6Ctrlternary_string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : decode_to_execute_BRANCH_CTRL_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : decode_to_execute_BRANCH_CTRL_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : decode_to_execute_BRANCH_CTRL_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : decode_to_execute_BRANCH_CTRL_string = "JALR";
      default : decode_to_execute_BRANCH_CTRL_string = "????";
    endcase
  end
  `endif

  assign execute_BRANCH_CALC = {execute_BranchPlugin_branchAdder[31 : 1],1'b0};
  assign execute_BRANCH_DO = ((execute_PREDICTION_HAD_BRANCHED2 != execute_BRANCH_COND_RESULT) || execute_BranchPlugin_missAlignedTarget);
  assign execute_CG6_FINAL_OUTPUT = _zz_129;
  assign execute_SHIFT_RIGHT = _zz_239;
  assign writeBack_REGFILE_WRITE_DATA_ODD = memory_to_writeBack_REGFILE_WRITE_DATA_ODD;
  assign memory_REGFILE_WRITE_DATA_ODD = execute_to_memory_REGFILE_WRITE_DATA_ODD;
  assign execute_REGFILE_WRITE_DATA_ODD = 32'h0;
  assign execute_REGFILE_WRITE_DATA = _zz_114;
  assign memory_MEMORY_STORE_DATA_RF = execute_to_memory_MEMORY_STORE_DATA_RF;
  assign execute_MEMORY_STORE_DATA_RF = _zz_92;
  assign decode_PREDICTION_HAD_BRANCHED2 = IBusCachedPlugin_decodePrediction_cmd_hadBranch;
  assign decode_SRC2_FORCE_ZERO = (decode_SRC_ADD_ZERO && (! decode_SRC_USE_SUB_LESS));
  assign execute_RS3 = decode_to_execute_RS3;
  assign decode_REGFILE_WRITE_VALID_ODD = _zz_97[34];
  assign _zz_1 = _zz_2;
  assign decode_CG6Ctrlternary = _zz_3;
  assign _zz_4 = _zz_5;
  assign decode_CG6Ctrlminmax = _zz_6;
  assign _zz_7 = _zz_8;
  assign decode_CG6Ctrl = _zz_9;
  assign _zz_10 = _zz_11;
  assign execute_IS_CG6 = decode_to_execute_IS_CG6;
  assign decode_IS_CG6 = _zz_97[23];
  assign _zz_12 = _zz_13;
  assign decode_SHIFT_CTRL = _zz_14;
  assign _zz_15 = _zz_16;
  assign decode_ALU_BITWISE_CTRL = _zz_17;
  assign _zz_18 = _zz_19;
  assign decode_SRC_LESS_UNSIGNED = _zz_97[17];
  assign decode_SRC3_CTRL = _zz_20;
  assign _zz_21 = _zz_22;
  assign decode_MEMORY_MANAGMENT = _zz_97[15];
  assign decode_MEMORY_WR = _zz_97[13];
  assign execute_BYPASSABLE_MEMORY_STAGE = decode_to_execute_BYPASSABLE_MEMORY_STAGE;
  assign decode_BYPASSABLE_MEMORY_STAGE = _zz_97[12];
  assign decode_BYPASSABLE_EXECUTE_STAGE = _zz_97[11];
  assign decode_SRC2_CTRL = _zz_23;
  assign _zz_24 = _zz_25;
  assign decode_ALU_CTRL = _zz_26;
  assign _zz_27 = _zz_28;
  assign decode_SRC1_CTRL = _zz_29;
  assign _zz_30 = _zz_31;
  assign decode_MEMORY_FORCE_CONSTISTENCY = 1'b0;
  assign writeBack_FORMAL_PC_NEXT = memory_to_writeBack_FORMAL_PC_NEXT;
  assign memory_FORMAL_PC_NEXT = execute_to_memory_FORMAL_PC_NEXT;
  assign execute_FORMAL_PC_NEXT = decode_to_execute_FORMAL_PC_NEXT;
  assign decode_FORMAL_PC_NEXT = (decode_PC + 32'h00000004);
  assign memory_PC = execute_to_memory_PC;
  assign memory_BRANCH_CALC = execute_to_memory_BRANCH_CALC;
  assign memory_BRANCH_DO = execute_to_memory_BRANCH_DO;
  assign execute_PC = decode_to_execute_PC;
  assign execute_PREDICTION_HAD_BRANCHED2 = decode_to_execute_PREDICTION_HAD_BRANCHED2;
  assign execute_RS1 = decode_to_execute_RS1;
  assign execute_BRANCH_COND_RESULT = _zz_162;
  assign execute_BRANCH_CTRL = _zz_32;
  assign decode_RS3_USE = _zz_97[28];
  assign decode_RS2_USE = _zz_97[14];
  assign decode_RS1_USE = _zz_97[5];
  assign _zz_33 = execute_REGFILE_WRITE_DATA_ODD;
  assign execute_REGFILE_WRITE_VALID_ODD = decode_to_execute_REGFILE_WRITE_VALID_ODD;
  assign _zz_34 = execute_REGFILE_WRITE_DATA;
  assign execute_REGFILE_WRITE_VALID = decode_to_execute_REGFILE_WRITE_VALID;
  assign execute_BYPASSABLE_EXECUTE_STAGE = decode_to_execute_BYPASSABLE_EXECUTE_STAGE;
  assign _zz_35 = memory_REGFILE_WRITE_DATA_ODD;
  assign memory_REGFILE_WRITE_VALID_ODD = execute_to_memory_REGFILE_WRITE_VALID_ODD;
  assign memory_REGFILE_WRITE_VALID = execute_to_memory_REGFILE_WRITE_VALID;
  assign memory_BYPASSABLE_MEMORY_STAGE = execute_to_memory_BYPASSABLE_MEMORY_STAGE;
  assign memory_INSTRUCTION = execute_to_memory_INSTRUCTION;
  assign _zz_36 = writeBack_REGFILE_WRITE_DATA_ODD;
  assign writeBack_REGFILE_WRITE_VALID_ODD = memory_to_writeBack_REGFILE_WRITE_VALID_ODD;
  assign writeBack_REGFILE_WRITE_VALID = memory_to_writeBack_REGFILE_WRITE_VALID;
  always @ (*) begin
    decode_RS3 = decode_RegFilePlugin_rs3Data;
    if(HazardSimplePlugin_writeBackBuffer_valid)begin
      if(HazardSimplePlugin_addr2Match)begin
        decode_RS3 = HazardSimplePlugin_writeBackBuffer_payload_data;
      end
    end
    if(_zz_220)begin
      if(_zz_221)begin
        if(_zz_136)begin
          decode_RS3 = _zz_62;
        end
      end
    end
    if(_zz_222)begin
      if(_zz_223)begin
        if(_zz_139)begin
          decode_RS3 = _zz_36;
        end
      end
    end
    if(_zz_224)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_146)begin
          decode_RS3 = _zz_40;
        end
      end
    end
    if(_zz_225)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_149)begin
          decode_RS3 = _zz_35;
        end
      end
    end
    if(_zz_226)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_156)begin
          decode_RS3 = _zz_34;
        end
      end
    end
    if(_zz_227)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_159)begin
          decode_RS3 = _zz_33;
        end
      end
    end
  end

  always @ (*) begin
    decode_RS2 = decode_RegFilePlugin_rs2Data;
    if(HazardSimplePlugin_writeBackBuffer_valid)begin
      if(HazardSimplePlugin_addr1Match)begin
        decode_RS2 = HazardSimplePlugin_writeBackBuffer_payload_data;
      end
    end
    if(_zz_220)begin
      if(_zz_221)begin
        if(_zz_135)begin
          decode_RS2 = _zz_62;
        end
      end
    end
    if(_zz_222)begin
      if(_zz_223)begin
        if(_zz_138)begin
          decode_RS2 = _zz_36;
        end
      end
    end
    if(_zz_224)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_145)begin
          decode_RS2 = _zz_40;
        end
      end
    end
    if(_zz_225)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_148)begin
          decode_RS2 = _zz_35;
        end
      end
    end
    if(_zz_226)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_155)begin
          decode_RS2 = _zz_34;
        end
      end
    end
    if(_zz_227)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_158)begin
          decode_RS2 = _zz_33;
        end
      end
    end
  end

  always @ (*) begin
    decode_RS1 = decode_RegFilePlugin_rs1Data;
    if(HazardSimplePlugin_writeBackBuffer_valid)begin
      if(HazardSimplePlugin_addr0Match)begin
        decode_RS1 = HazardSimplePlugin_writeBackBuffer_payload_data;
      end
    end
    if(_zz_220)begin
      if(_zz_221)begin
        if(_zz_134)begin
          decode_RS1 = _zz_62;
        end
      end
    end
    if(_zz_222)begin
      if(_zz_223)begin
        if(_zz_137)begin
          decode_RS1 = _zz_36;
        end
      end
    end
    if(_zz_224)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_144)begin
          decode_RS1 = _zz_40;
        end
      end
    end
    if(_zz_225)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_147)begin
          decode_RS1 = _zz_35;
        end
      end
    end
    if(_zz_226)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_154)begin
          decode_RS1 = _zz_34;
        end
      end
    end
    if(_zz_227)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_157)begin
          decode_RS1 = _zz_33;
        end
      end
    end
  end

  assign memory_CG6_FINAL_OUTPUT = execute_to_memory_CG6_FINAL_OUTPUT;
  assign memory_IS_CG6 = execute_to_memory_IS_CG6;
  assign execute_CG6Ctrl = _zz_37;
  assign execute_SRC3 = _zz_123;
  assign execute_CG6Ctrlternary = _zz_38;
  assign execute_CG6Ctrlminmax = _zz_39;
  assign memory_SHIFT_RIGHT = execute_to_memory_SHIFT_RIGHT;
  always @ (*) begin
    _zz_40 = memory_REGFILE_WRITE_DATA;
    if(memory_arbitration_isValid)begin
      case(memory_SHIFT_CTRL)
        `ShiftCtrlEnum_defaultEncoding_SLL_1 : begin
          _zz_40 = _zz_125;
        end
        `ShiftCtrlEnum_defaultEncoding_SRL_1, `ShiftCtrlEnum_defaultEncoding_SRA_1 : begin
          _zz_40 = memory_SHIFT_RIGHT;
        end
        default : begin
        end
      endcase
    end
    if((memory_arbitration_isValid && memory_IS_CG6))begin
      _zz_40 = memory_CG6_FINAL_OUTPUT;
    end
  end

  assign memory_SHIFT_CTRL = _zz_41;
  assign execute_SHIFT_CTRL = _zz_42;
  assign execute_SRC_LESS_UNSIGNED = decode_to_execute_SRC_LESS_UNSIGNED;
  assign execute_SRC2_FORCE_ZERO = decode_to_execute_SRC2_FORCE_ZERO;
  assign execute_SRC_USE_SUB_LESS = decode_to_execute_SRC_USE_SUB_LESS;
  assign execute_SRC3_CTRL = _zz_43;
  assign _zz_44 = execute_PC;
  assign execute_SRC2_CTRL = _zz_45;
  assign execute_SRC1_CTRL = _zz_46;
  assign decode_SRC_USE_SUB_LESS = _zz_97[3];
  assign decode_SRC_ADD_ZERO = _zz_97[20];
  assign execute_SRC_ADD_SUB = execute_SrcPlugin_addSub;
  assign execute_SRC_LESS = execute_SrcPlugin_less;
  assign execute_ALU_CTRL = _zz_47;
  assign execute_SRC2 = _zz_120;
  assign execute_SRC1 = _zz_115;
  assign execute_ALU_BITWISE_CTRL = _zz_48;
  assign _zz_49 = writeBack_REGFILE_WRITE_VALID;
  always @ (*) begin
    _zz_50 = 1'b0;
    if(lastStageRegFileWrite_valid)begin
      _zz_50 = 1'b1;
    end
  end

  assign _zz_51 = writeBack_INSTRUCTION;
  assign decode_INSTRUCTION_ANTICIPATED = (decode_arbitration_isStuck ? decode_INSTRUCTION : IBusCachedPlugin_cache_io_cpu_fetch_data);
  always @ (*) begin
    decode_REGFILE_WRITE_VALID = _zz_97[10];
    if((decode_INSTRUCTION[11 : 7] == 5'h0))begin
      decode_REGFILE_WRITE_VALID = 1'b0;
    end
  end

  always @ (*) begin
    _zz_62 = writeBack_REGFILE_WRITE_DATA;
    if((writeBack_arbitration_isValid && writeBack_MEMORY_ENABLE))begin
      _zz_62 = writeBack_DBusCachedPlugin_rspFormated;
    end
  end

  assign writeBack_MEMORY_STORE_DATA_RF = memory_to_writeBack_MEMORY_STORE_DATA_RF;
  assign writeBack_REGFILE_WRITE_DATA = memory_to_writeBack_REGFILE_WRITE_DATA;
  assign writeBack_MEMORY_ENABLE = memory_to_writeBack_MEMORY_ENABLE;
  assign memory_REGFILE_WRITE_DATA = execute_to_memory_REGFILE_WRITE_DATA;
  assign memory_MEMORY_ENABLE = execute_to_memory_MEMORY_ENABLE;
  assign execute_MEMORY_FORCE_CONSTISTENCY = decode_to_execute_MEMORY_FORCE_CONSTISTENCY;
  assign execute_MEMORY_MANAGMENT = decode_to_execute_MEMORY_MANAGMENT;
  assign execute_RS2 = decode_to_execute_RS2;
  assign execute_MEMORY_WR = decode_to_execute_MEMORY_WR;
  assign execute_SRC_ADD = execute_SrcPlugin_addSub;
  assign execute_MEMORY_ENABLE = decode_to_execute_MEMORY_ENABLE;
  assign execute_INSTRUCTION = decode_to_execute_INSTRUCTION;
  assign decode_MEMORY_ENABLE = _zz_97[4];
  assign decode_FLUSH_ALL = _zz_97[0];
  always @ (*) begin
    IBusCachedPlugin_rsp_issueDetected_2 = IBusCachedPlugin_rsp_issueDetected_1;
    if(_zz_228)begin
      IBusCachedPlugin_rsp_issueDetected_2 = 1'b1;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_rsp_issueDetected_1 = IBusCachedPlugin_rsp_issueDetected;
    if(_zz_229)begin
      IBusCachedPlugin_rsp_issueDetected_1 = 1'b1;
    end
  end

  assign decode_BRANCH_CTRL = _zz_63;
  assign decode_INSTRUCTION = IBusCachedPlugin_iBusRsp_output_payload_rsp_inst;
  always @ (*) begin
    _zz_64 = memory_FORMAL_PC_NEXT;
    if(BranchPlugin_jumpInterface_valid)begin
      _zz_64 = BranchPlugin_jumpInterface_payload;
    end
  end

  always @ (*) begin
    _zz_65 = decode_FORMAL_PC_NEXT;
    if(IBusCachedPlugin_predictionJumpInterface_valid)begin
      _zz_65 = IBusCachedPlugin_predictionJumpInterface_payload;
    end
  end

  assign decode_PC = IBusCachedPlugin_iBusRsp_output_payload_pc;
  assign writeBack_PC = memory_to_writeBack_PC;
  assign writeBack_INSTRUCTION = memory_to_writeBack_INSTRUCTION;
  always @ (*) begin
    decode_arbitration_haltItself = 1'b0;
    if(((DBusCachedPlugin_mmuBus_busy && decode_arbitration_isValid) && decode_MEMORY_ENABLE))begin
      decode_arbitration_haltItself = 1'b1;
    end
  end

  always @ (*) begin
    decode_arbitration_haltByOther = 1'b0;
    if((decode_arbitration_isValid && ((HazardSimplePlugin_src0Hazard || HazardSimplePlugin_src1Hazard) || HazardSimplePlugin_src2Hazard)))begin
      decode_arbitration_haltByOther = 1'b1;
    end
  end

  always @ (*) begin
    decode_arbitration_removeIt = 1'b0;
    if(decode_arbitration_isFlushed)begin
      decode_arbitration_removeIt = 1'b1;
    end
  end

  assign decode_arbitration_flushIt = 1'b0;
  always @ (*) begin
    decode_arbitration_flushNext = 1'b0;
    if(IBusCachedPlugin_predictionJumpInterface_valid)begin
      decode_arbitration_flushNext = 1'b1;
    end
  end

  always @ (*) begin
    execute_arbitration_haltItself = 1'b0;
    if(((_zz_212 && (! dataCache_1_io_cpu_flush_ready)) || dataCache_1_io_cpu_execute_haltIt))begin
      execute_arbitration_haltItself = 1'b1;
    end
  end

  always @ (*) begin
    execute_arbitration_haltByOther = 1'b0;
    if((dataCache_1_io_cpu_execute_refilling && execute_arbitration_isValid))begin
      execute_arbitration_haltByOther = 1'b1;
    end
  end

  always @ (*) begin
    execute_arbitration_removeIt = 1'b0;
    if(execute_arbitration_isFlushed)begin
      execute_arbitration_removeIt = 1'b1;
    end
  end

  assign execute_arbitration_flushIt = 1'b0;
  assign execute_arbitration_flushNext = 1'b0;
  assign memory_arbitration_haltItself = 1'b0;
  assign memory_arbitration_haltByOther = 1'b0;
  always @ (*) begin
    memory_arbitration_removeIt = 1'b0;
    if(memory_arbitration_isFlushed)begin
      memory_arbitration_removeIt = 1'b1;
    end
  end

  assign memory_arbitration_flushIt = 1'b0;
  always @ (*) begin
    memory_arbitration_flushNext = 1'b0;
    if(BranchPlugin_jumpInterface_valid)begin
      memory_arbitration_flushNext = 1'b1;
    end
  end

  always @ (*) begin
    writeBack_arbitration_haltItself = 1'b0;
    if((_zz_199 && dataCache_1_io_cpu_writeBack_haltIt))begin
      writeBack_arbitration_haltItself = 1'b1;
    end
  end

  assign writeBack_arbitration_haltByOther = 1'b0;
  always @ (*) begin
    writeBack_arbitration_removeIt = 1'b0;
    if(writeBack_arbitration_isFlushed)begin
      writeBack_arbitration_removeIt = 1'b1;
    end
  end

  always @ (*) begin
    writeBack_arbitration_flushIt = 1'b0;
    if(DBusCachedPlugin_redoBranch_valid)begin
      writeBack_arbitration_flushIt = 1'b1;
    end
  end

  always @ (*) begin
    writeBack_arbitration_flushNext = 1'b0;
    if(DBusCachedPlugin_redoBranch_valid)begin
      writeBack_arbitration_flushNext = 1'b1;
    end
  end

  assign lastStageInstruction = writeBack_INSTRUCTION;
  assign lastStagePc = writeBack_PC;
  assign lastStageIsValid = writeBack_arbitration_isValid;
  assign lastStageIsFiring = writeBack_arbitration_isFiring;
  assign IBusCachedPlugin_fetcherHalt = 1'b0;
  always @ (*) begin
    IBusCachedPlugin_incomingInstruction = 1'b0;
    if((IBusCachedPlugin_iBusRsp_stages_1_input_valid || IBusCachedPlugin_iBusRsp_stages_2_input_valid))begin
      IBusCachedPlugin_incomingInstruction = 1'b1;
    end
  end

  assign IBusCachedPlugin_externalFlush = ({writeBack_arbitration_flushNext,{memory_arbitration_flushNext,{execute_arbitration_flushNext,decode_arbitration_flushNext}}} != 4'b0000);
  assign IBusCachedPlugin_jump_pcLoad_valid = ({BranchPlugin_jumpInterface_valid,{DBusCachedPlugin_redoBranch_valid,IBusCachedPlugin_predictionJumpInterface_valid}} != 3'b000);
  assign _zz_66 = {IBusCachedPlugin_predictionJumpInterface_valid,{BranchPlugin_jumpInterface_valid,DBusCachedPlugin_redoBranch_valid}};
  assign _zz_67 = (_zz_66 & (~ _zz_241));
  assign _zz_68 = _zz_67[1];
  assign _zz_69 = _zz_67[2];
  assign IBusCachedPlugin_jump_pcLoad_payload = _zz_217;
  always @ (*) begin
    IBusCachedPlugin_fetchPc_correction = 1'b0;
    if(IBusCachedPlugin_fetchPc_redo_valid)begin
      IBusCachedPlugin_fetchPc_correction = 1'b1;
    end
    if(IBusCachedPlugin_jump_pcLoad_valid)begin
      IBusCachedPlugin_fetchPc_correction = 1'b1;
    end
  end

  assign IBusCachedPlugin_fetchPc_corrected = (IBusCachedPlugin_fetchPc_correction || IBusCachedPlugin_fetchPc_correctionReg);
  always @ (*) begin
    IBusCachedPlugin_fetchPc_pcRegPropagate = 1'b0;
    if(IBusCachedPlugin_iBusRsp_stages_1_input_ready)begin
      IBusCachedPlugin_fetchPc_pcRegPropagate = 1'b1;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_fetchPc_pc = (IBusCachedPlugin_fetchPc_pcReg + _zz_243);
    if(IBusCachedPlugin_fetchPc_redo_valid)begin
      IBusCachedPlugin_fetchPc_pc = IBusCachedPlugin_fetchPc_redo_payload;
    end
    if(IBusCachedPlugin_jump_pcLoad_valid)begin
      IBusCachedPlugin_fetchPc_pc = IBusCachedPlugin_jump_pcLoad_payload;
    end
    IBusCachedPlugin_fetchPc_pc[0] = 1'b0;
    IBusCachedPlugin_fetchPc_pc[1] = 1'b0;
  end

  always @ (*) begin
    IBusCachedPlugin_fetchPc_flushed = 1'b0;
    if(IBusCachedPlugin_fetchPc_redo_valid)begin
      IBusCachedPlugin_fetchPc_flushed = 1'b1;
    end
    if(IBusCachedPlugin_jump_pcLoad_valid)begin
      IBusCachedPlugin_fetchPc_flushed = 1'b1;
    end
  end

  assign IBusCachedPlugin_fetchPc_output_valid = ((! IBusCachedPlugin_fetcherHalt) && IBusCachedPlugin_fetchPc_booted);
  assign IBusCachedPlugin_fetchPc_output_payload = IBusCachedPlugin_fetchPc_pc;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_redoFetch = 1'b0;
    if(IBusCachedPlugin_rsp_redoFetch)begin
      IBusCachedPlugin_iBusRsp_redoFetch = 1'b1;
    end
  end

  assign IBusCachedPlugin_iBusRsp_stages_0_input_valid = IBusCachedPlugin_fetchPc_output_valid;
  assign IBusCachedPlugin_fetchPc_output_ready = IBusCachedPlugin_iBusRsp_stages_0_input_ready;
  assign IBusCachedPlugin_iBusRsp_stages_0_input_payload = IBusCachedPlugin_fetchPc_output_payload;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_stages_0_halt = 1'b0;
    if(IBusCachedPlugin_cache_io_cpu_prefetch_haltIt)begin
      IBusCachedPlugin_iBusRsp_stages_0_halt = 1'b1;
    end
  end

  assign _zz_70 = (! IBusCachedPlugin_iBusRsp_stages_0_halt);
  assign IBusCachedPlugin_iBusRsp_stages_0_input_ready = (IBusCachedPlugin_iBusRsp_stages_0_output_ready && _zz_70);
  assign IBusCachedPlugin_iBusRsp_stages_0_output_valid = (IBusCachedPlugin_iBusRsp_stages_0_input_valid && _zz_70);
  assign IBusCachedPlugin_iBusRsp_stages_0_output_payload = IBusCachedPlugin_iBusRsp_stages_0_input_payload;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_stages_1_halt = 1'b0;
    if(IBusCachedPlugin_mmuBus_busy)begin
      IBusCachedPlugin_iBusRsp_stages_1_halt = 1'b1;
    end
  end

  assign _zz_71 = (! IBusCachedPlugin_iBusRsp_stages_1_halt);
  assign IBusCachedPlugin_iBusRsp_stages_1_input_ready = (IBusCachedPlugin_iBusRsp_stages_1_output_ready && _zz_71);
  assign IBusCachedPlugin_iBusRsp_stages_1_output_valid = (IBusCachedPlugin_iBusRsp_stages_1_input_valid && _zz_71);
  assign IBusCachedPlugin_iBusRsp_stages_1_output_payload = IBusCachedPlugin_iBusRsp_stages_1_input_payload;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_stages_2_halt = 1'b0;
    if((IBusCachedPlugin_rsp_issueDetected_2 || IBusCachedPlugin_rsp_iBusRspOutputHalt))begin
      IBusCachedPlugin_iBusRsp_stages_2_halt = 1'b1;
    end
  end

  assign _zz_72 = (! IBusCachedPlugin_iBusRsp_stages_2_halt);
  assign IBusCachedPlugin_iBusRsp_stages_2_input_ready = (IBusCachedPlugin_iBusRsp_stages_2_output_ready && _zz_72);
  assign IBusCachedPlugin_iBusRsp_stages_2_output_valid = (IBusCachedPlugin_iBusRsp_stages_2_input_valid && _zz_72);
  assign IBusCachedPlugin_iBusRsp_stages_2_output_payload = IBusCachedPlugin_iBusRsp_stages_2_input_payload;
  assign IBusCachedPlugin_fetchPc_redo_valid = IBusCachedPlugin_iBusRsp_redoFetch;
  assign IBusCachedPlugin_fetchPc_redo_payload = IBusCachedPlugin_iBusRsp_stages_2_input_payload;
  assign IBusCachedPlugin_iBusRsp_flush = ((decode_arbitration_removeIt || (decode_arbitration_flushNext && (! decode_arbitration_isStuck))) || IBusCachedPlugin_iBusRsp_redoFetch);
  assign IBusCachedPlugin_iBusRsp_stages_0_output_ready = _zz_73;
  assign _zz_73 = ((1'b0 && (! _zz_74)) || IBusCachedPlugin_iBusRsp_stages_1_input_ready);
  assign _zz_74 = _zz_75;
  assign IBusCachedPlugin_iBusRsp_stages_1_input_valid = _zz_74;
  assign IBusCachedPlugin_iBusRsp_stages_1_input_payload = IBusCachedPlugin_fetchPc_pcReg;
  assign IBusCachedPlugin_iBusRsp_stages_1_output_ready = ((1'b0 && (! _zz_76)) || IBusCachedPlugin_iBusRsp_stages_2_input_ready);
  assign _zz_76 = _zz_77;
  assign IBusCachedPlugin_iBusRsp_stages_2_input_valid = _zz_76;
  assign IBusCachedPlugin_iBusRsp_stages_2_input_payload = _zz_78;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_readyForError = 1'b1;
    if((! IBusCachedPlugin_pcValids_0))begin
      IBusCachedPlugin_iBusRsp_readyForError = 1'b0;
    end
  end

  assign IBusCachedPlugin_pcValids_0 = IBusCachedPlugin_injector_nextPcCalc_valids_1;
  assign IBusCachedPlugin_pcValids_1 = IBusCachedPlugin_injector_nextPcCalc_valids_2;
  assign IBusCachedPlugin_pcValids_2 = IBusCachedPlugin_injector_nextPcCalc_valids_3;
  assign IBusCachedPlugin_pcValids_3 = IBusCachedPlugin_injector_nextPcCalc_valids_4;
  assign IBusCachedPlugin_iBusRsp_output_ready = (! decode_arbitration_isStuck);
  assign decode_arbitration_isValid = IBusCachedPlugin_iBusRsp_output_valid;
  assign _zz_79 = _zz_244[11];
  always @ (*) begin
    _zz_80[18] = _zz_79;
    _zz_80[17] = _zz_79;
    _zz_80[16] = _zz_79;
    _zz_80[15] = _zz_79;
    _zz_80[14] = _zz_79;
    _zz_80[13] = _zz_79;
    _zz_80[12] = _zz_79;
    _zz_80[11] = _zz_79;
    _zz_80[10] = _zz_79;
    _zz_80[9] = _zz_79;
    _zz_80[8] = _zz_79;
    _zz_80[7] = _zz_79;
    _zz_80[6] = _zz_79;
    _zz_80[5] = _zz_79;
    _zz_80[4] = _zz_79;
    _zz_80[3] = _zz_79;
    _zz_80[2] = _zz_79;
    _zz_80[1] = _zz_79;
    _zz_80[0] = _zz_79;
  end

  always @ (*) begin
    IBusCachedPlugin_decodePrediction_cmd_hadBranch = ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) || ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_B) && _zz_245[31]));
    if(_zz_85)begin
      IBusCachedPlugin_decodePrediction_cmd_hadBranch = 1'b0;
    end
  end

  assign _zz_81 = _zz_246[19];
  always @ (*) begin
    _zz_82[10] = _zz_81;
    _zz_82[9] = _zz_81;
    _zz_82[8] = _zz_81;
    _zz_82[7] = _zz_81;
    _zz_82[6] = _zz_81;
    _zz_82[5] = _zz_81;
    _zz_82[4] = _zz_81;
    _zz_82[3] = _zz_81;
    _zz_82[2] = _zz_81;
    _zz_82[1] = _zz_81;
    _zz_82[0] = _zz_81;
  end

  assign _zz_83 = _zz_247[11];
  always @ (*) begin
    _zz_84[18] = _zz_83;
    _zz_84[17] = _zz_83;
    _zz_84[16] = _zz_83;
    _zz_84[15] = _zz_83;
    _zz_84[14] = _zz_83;
    _zz_84[13] = _zz_83;
    _zz_84[12] = _zz_83;
    _zz_84[11] = _zz_83;
    _zz_84[10] = _zz_83;
    _zz_84[9] = _zz_83;
    _zz_84[8] = _zz_83;
    _zz_84[7] = _zz_83;
    _zz_84[6] = _zz_83;
    _zz_84[5] = _zz_83;
    _zz_84[4] = _zz_83;
    _zz_84[3] = _zz_83;
    _zz_84[2] = _zz_83;
    _zz_84[1] = _zz_83;
    _zz_84[0] = _zz_83;
  end

  always @ (*) begin
    case(decode_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_85 = _zz_248[1];
      end
      default : begin
        _zz_85 = _zz_249[1];
      end
    endcase
  end

  assign IBusCachedPlugin_predictionJumpInterface_valid = (decode_arbitration_isValid && IBusCachedPlugin_decodePrediction_cmd_hadBranch);
  assign _zz_86 = _zz_250[19];
  always @ (*) begin
    _zz_87[10] = _zz_86;
    _zz_87[9] = _zz_86;
    _zz_87[8] = _zz_86;
    _zz_87[7] = _zz_86;
    _zz_87[6] = _zz_86;
    _zz_87[5] = _zz_86;
    _zz_87[4] = _zz_86;
    _zz_87[3] = _zz_86;
    _zz_87[2] = _zz_86;
    _zz_87[1] = _zz_86;
    _zz_87[0] = _zz_86;
  end

  assign _zz_88 = _zz_251[11];
  always @ (*) begin
    _zz_89[18] = _zz_88;
    _zz_89[17] = _zz_88;
    _zz_89[16] = _zz_88;
    _zz_89[15] = _zz_88;
    _zz_89[14] = _zz_88;
    _zz_89[13] = _zz_88;
    _zz_89[12] = _zz_88;
    _zz_89[11] = _zz_88;
    _zz_89[10] = _zz_88;
    _zz_89[9] = _zz_88;
    _zz_89[8] = _zz_88;
    _zz_89[7] = _zz_88;
    _zz_89[6] = _zz_88;
    _zz_89[5] = _zz_88;
    _zz_89[4] = _zz_88;
    _zz_89[3] = _zz_88;
    _zz_89[2] = _zz_88;
    _zz_89[1] = _zz_88;
    _zz_89[0] = _zz_88;
  end

  assign IBusCachedPlugin_predictionJumpInterface_payload = (decode_PC + ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) ? {{_zz_87,{{{_zz_284,decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]}},1'b0} : {{_zz_89,{{{_zz_285,_zz_286},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0}));
  assign iBus_cmd_valid = IBusCachedPlugin_cache_io_mem_cmd_valid;
  always @ (*) begin
    iBus_cmd_payload_address = IBusCachedPlugin_cache_io_mem_cmd_payload_address;
    iBus_cmd_payload_address = IBusCachedPlugin_cache_io_mem_cmd_payload_address;
  end

  assign iBus_cmd_payload_size = IBusCachedPlugin_cache_io_mem_cmd_payload_size;
  assign IBusCachedPlugin_s0_tightlyCoupledHit = 1'b0;
  assign _zz_186 = (IBusCachedPlugin_iBusRsp_stages_0_input_valid && (! IBusCachedPlugin_s0_tightlyCoupledHit));
  assign _zz_187 = (IBusCachedPlugin_iBusRsp_stages_1_input_valid && (! IBusCachedPlugin_s1_tightlyCoupledHit));
  assign _zz_188 = (! IBusCachedPlugin_iBusRsp_stages_1_input_ready);
  assign IBusCachedPlugin_mmuBus_cmd_0_isValid = _zz_187;
  assign IBusCachedPlugin_mmuBus_cmd_0_isStuck = (! IBusCachedPlugin_iBusRsp_stages_1_input_ready);
  assign IBusCachedPlugin_mmuBus_cmd_0_virtualAddress = IBusCachedPlugin_iBusRsp_stages_1_input_payload;
  assign IBusCachedPlugin_mmuBus_cmd_0_bypassTranslation = 1'b0;
  assign IBusCachedPlugin_mmuBus_end = (IBusCachedPlugin_iBusRsp_stages_1_input_ready || IBusCachedPlugin_externalFlush);
  assign _zz_190 = (IBusCachedPlugin_iBusRsp_stages_2_input_valid && (! IBusCachedPlugin_s2_tightlyCoupledHit));
  assign _zz_191 = (! IBusCachedPlugin_iBusRsp_stages_2_input_ready);
  assign _zz_192 = 1'b0;
  assign IBusCachedPlugin_rsp_iBusRspOutputHalt = 1'b0;
  assign IBusCachedPlugin_rsp_issueDetected = 1'b0;
  always @ (*) begin
    IBusCachedPlugin_rsp_redoFetch = 1'b0;
    if(_zz_229)begin
      IBusCachedPlugin_rsp_redoFetch = 1'b1;
    end
    if(_zz_228)begin
      IBusCachedPlugin_rsp_redoFetch = 1'b1;
    end
  end

  always @ (*) begin
    _zz_193 = (IBusCachedPlugin_rsp_redoFetch && (! IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling));
    if(_zz_228)begin
      _zz_193 = 1'b1;
    end
  end

  assign IBusCachedPlugin_iBusRsp_output_valid = IBusCachedPlugin_iBusRsp_stages_2_output_valid;
  assign IBusCachedPlugin_iBusRsp_stages_2_output_ready = IBusCachedPlugin_iBusRsp_output_ready;
  assign IBusCachedPlugin_iBusRsp_output_payload_rsp_inst = IBusCachedPlugin_cache_io_cpu_decode_data;
  assign IBusCachedPlugin_iBusRsp_output_payload_pc = IBusCachedPlugin_iBusRsp_stages_2_output_payload;
  assign _zz_185 = (decode_arbitration_isValid && decode_FLUSH_ALL);
  assign _zz_213 = ((1'b1 && (! dataCache_1_io_mem_cmd_m2sPipe_valid)) || dataCache_1_io_mem_cmd_m2sPipe_ready);
  assign dataCache_1_io_mem_cmd_m2sPipe_valid = dataCache_1_io_mem_cmd_m2sPipe_rValid;
  assign dataCache_1_io_mem_cmd_m2sPipe_payload_wr = dataCache_1_io_mem_cmd_m2sPipe_rData_wr;
  assign dataCache_1_io_mem_cmd_m2sPipe_payload_uncached = dataCache_1_io_mem_cmd_m2sPipe_rData_uncached;
  assign dataCache_1_io_mem_cmd_m2sPipe_payload_address = dataCache_1_io_mem_cmd_m2sPipe_rData_address;
  assign dataCache_1_io_mem_cmd_m2sPipe_payload_data = dataCache_1_io_mem_cmd_m2sPipe_rData_data;
  assign dataCache_1_io_mem_cmd_m2sPipe_payload_mask = dataCache_1_io_mem_cmd_m2sPipe_rData_mask;
  assign dataCache_1_io_mem_cmd_m2sPipe_payload_size = dataCache_1_io_mem_cmd_m2sPipe_rData_size;
  assign dataCache_1_io_mem_cmd_m2sPipe_payload_last = dataCache_1_io_mem_cmd_m2sPipe_rData_last;
  assign dBus_cmd_valid = dataCache_1_io_mem_cmd_m2sPipe_valid;
  assign dataCache_1_io_mem_cmd_m2sPipe_ready = dBus_cmd_ready;
  assign dBus_cmd_payload_wr = dataCache_1_io_mem_cmd_m2sPipe_payload_wr;
  assign dBus_cmd_payload_uncached = dataCache_1_io_mem_cmd_m2sPipe_payload_uncached;
  assign dBus_cmd_payload_address = dataCache_1_io_mem_cmd_m2sPipe_payload_address;
  assign dBus_cmd_payload_data = dataCache_1_io_mem_cmd_m2sPipe_payload_data;
  assign dBus_cmd_payload_mask = dataCache_1_io_mem_cmd_m2sPipe_payload_mask;
  assign dBus_cmd_payload_size = dataCache_1_io_mem_cmd_m2sPipe_payload_size;
  assign dBus_cmd_payload_last = dataCache_1_io_mem_cmd_m2sPipe_payload_last;
  assign execute_DBusCachedPlugin_size = execute_INSTRUCTION[13 : 12];
  assign _zz_194 = (execute_arbitration_isValid && execute_MEMORY_ENABLE);
  assign _zz_195 = execute_SRC_ADD;
  always @ (*) begin
    case(execute_DBusCachedPlugin_size)
      2'b00 : begin
        _zz_92 = {{{execute_RS2[7 : 0],execute_RS2[7 : 0]},execute_RS2[7 : 0]},execute_RS2[7 : 0]};
      end
      2'b01 : begin
        _zz_92 = {execute_RS2[15 : 0],execute_RS2[15 : 0]};
      end
      default : begin
        _zz_92 = execute_RS2[31 : 0];
      end
    endcase
  end

  assign _zz_212 = (execute_arbitration_isValid && execute_MEMORY_MANAGMENT);
  assign _zz_196 = (memory_arbitration_isValid && memory_MEMORY_ENABLE);
  assign _zz_197 = memory_REGFILE_WRITE_DATA;
  assign DBusCachedPlugin_mmuBus_cmd_0_isValid = _zz_196;
  assign DBusCachedPlugin_mmuBus_cmd_0_isStuck = memory_arbitration_isStuck;
  assign DBusCachedPlugin_mmuBus_cmd_0_virtualAddress = _zz_197;
  assign DBusCachedPlugin_mmuBus_cmd_0_bypassTranslation = 1'b0;
  assign DBusCachedPlugin_mmuBus_end = ((! memory_arbitration_isStuck) || memory_arbitration_removeIt);
  always @ (*) begin
    _zz_198 = DBusCachedPlugin_mmuBus_rsp_isIoAccess;
    if((1'b0 && (! dataCache_1_io_cpu_memory_isWrite)))begin
      _zz_198 = 1'b1;
    end
  end

  always @ (*) begin
    _zz_199 = (writeBack_arbitration_isValid && writeBack_MEMORY_ENABLE);
    if(writeBack_arbitration_haltByOther)begin
      _zz_199 = 1'b0;
    end
  end

  assign _zz_200 = 1'b0;
  assign _zz_202 = writeBack_REGFILE_WRITE_DATA;
  assign _zz_201[31 : 0] = writeBack_MEMORY_STORE_DATA_RF;
  always @ (*) begin
    DBusCachedPlugin_redoBranch_valid = 1'b0;
    if((writeBack_arbitration_isValid && writeBack_MEMORY_ENABLE))begin
      if(dataCache_1_io_cpu_redo)begin
        DBusCachedPlugin_redoBranch_valid = 1'b1;
      end
    end
  end

  assign DBusCachedPlugin_redoBranch_payload = writeBack_PC;
  assign writeBack_DBusCachedPlugin_rspSplits_0 = dataCache_1_io_cpu_writeBack_data[7 : 0];
  assign writeBack_DBusCachedPlugin_rspSplits_1 = dataCache_1_io_cpu_writeBack_data[15 : 8];
  assign writeBack_DBusCachedPlugin_rspSplits_2 = dataCache_1_io_cpu_writeBack_data[23 : 16];
  assign writeBack_DBusCachedPlugin_rspSplits_3 = dataCache_1_io_cpu_writeBack_data[31 : 24];
  always @ (*) begin
    writeBack_DBusCachedPlugin_rspShifted[7 : 0] = _zz_218;
    writeBack_DBusCachedPlugin_rspShifted[15 : 8] = _zz_219;
    writeBack_DBusCachedPlugin_rspShifted[23 : 16] = writeBack_DBusCachedPlugin_rspSplits_2;
    writeBack_DBusCachedPlugin_rspShifted[31 : 24] = writeBack_DBusCachedPlugin_rspSplits_3;
  end

  assign writeBack_DBusCachedPlugin_rspRf = writeBack_DBusCachedPlugin_rspShifted[31 : 0];
  assign _zz_93 = (writeBack_DBusCachedPlugin_rspRf[7] && (! writeBack_INSTRUCTION[14]));
  always @ (*) begin
    _zz_94[31] = _zz_93;
    _zz_94[30] = _zz_93;
    _zz_94[29] = _zz_93;
    _zz_94[28] = _zz_93;
    _zz_94[27] = _zz_93;
    _zz_94[26] = _zz_93;
    _zz_94[25] = _zz_93;
    _zz_94[24] = _zz_93;
    _zz_94[23] = _zz_93;
    _zz_94[22] = _zz_93;
    _zz_94[21] = _zz_93;
    _zz_94[20] = _zz_93;
    _zz_94[19] = _zz_93;
    _zz_94[18] = _zz_93;
    _zz_94[17] = _zz_93;
    _zz_94[16] = _zz_93;
    _zz_94[15] = _zz_93;
    _zz_94[14] = _zz_93;
    _zz_94[13] = _zz_93;
    _zz_94[12] = _zz_93;
    _zz_94[11] = _zz_93;
    _zz_94[10] = _zz_93;
    _zz_94[9] = _zz_93;
    _zz_94[8] = _zz_93;
    _zz_94[7 : 0] = writeBack_DBusCachedPlugin_rspRf[7 : 0];
  end

  assign _zz_95 = (writeBack_DBusCachedPlugin_rspRf[15] && (! writeBack_INSTRUCTION[14]));
  always @ (*) begin
    _zz_96[31] = _zz_95;
    _zz_96[30] = _zz_95;
    _zz_96[29] = _zz_95;
    _zz_96[28] = _zz_95;
    _zz_96[27] = _zz_95;
    _zz_96[26] = _zz_95;
    _zz_96[25] = _zz_95;
    _zz_96[24] = _zz_95;
    _zz_96[23] = _zz_95;
    _zz_96[22] = _zz_95;
    _zz_96[21] = _zz_95;
    _zz_96[20] = _zz_95;
    _zz_96[19] = _zz_95;
    _zz_96[18] = _zz_95;
    _zz_96[17] = _zz_95;
    _zz_96[16] = _zz_95;
    _zz_96[15 : 0] = writeBack_DBusCachedPlugin_rspRf[15 : 0];
  end

  always @ (*) begin
    case(_zz_237)
      2'b00 : begin
        writeBack_DBusCachedPlugin_rspFormated = _zz_94;
      end
      2'b01 : begin
        writeBack_DBusCachedPlugin_rspFormated = _zz_96;
      end
      default : begin
        writeBack_DBusCachedPlugin_rspFormated = writeBack_DBusCachedPlugin_rspRf;
      end
    endcase
  end

  assign IBusCachedPlugin_mmuBus_rsp_physicalAddress = IBusCachedPlugin_mmuBus_cmd_0_virtualAddress;
  assign IBusCachedPlugin_mmuBus_rsp_allowRead = 1'b1;
  assign IBusCachedPlugin_mmuBus_rsp_allowWrite = 1'b1;
  assign IBusCachedPlugin_mmuBus_rsp_allowExecute = 1'b1;
  assign IBusCachedPlugin_mmuBus_rsp_isIoAccess = (IBusCachedPlugin_mmuBus_rsp_physicalAddress[31 : 28] != 4'b1000);
  assign IBusCachedPlugin_mmuBus_rsp_isPaging = 1'b0;
  assign IBusCachedPlugin_mmuBus_rsp_exception = 1'b0;
  assign IBusCachedPlugin_mmuBus_rsp_refilling = 1'b0;
  assign IBusCachedPlugin_mmuBus_busy = 1'b0;
  assign DBusCachedPlugin_mmuBus_rsp_physicalAddress = DBusCachedPlugin_mmuBus_cmd_0_virtualAddress;
  assign DBusCachedPlugin_mmuBus_rsp_allowRead = 1'b1;
  assign DBusCachedPlugin_mmuBus_rsp_allowWrite = 1'b1;
  assign DBusCachedPlugin_mmuBus_rsp_allowExecute = 1'b1;
  assign DBusCachedPlugin_mmuBus_rsp_isIoAccess = (DBusCachedPlugin_mmuBus_rsp_physicalAddress[31 : 28] != 4'b1000);
  assign DBusCachedPlugin_mmuBus_rsp_isPaging = 1'b0;
  assign DBusCachedPlugin_mmuBus_rsp_exception = 1'b0;
  assign DBusCachedPlugin_mmuBus_rsp_refilling = 1'b0;
  assign DBusCachedPlugin_mmuBus_busy = 1'b0;
  assign _zz_98 = ((decode_INSTRUCTION & 32'h00000004) == 32'h00000004);
  assign _zz_99 = ((decode_INSTRUCTION & 32'h00000048) == 32'h00000048);
  assign _zz_100 = ((decode_INSTRUCTION & 32'h00000010) == 32'h00000010);
  assign _zz_101 = ((decode_INSTRUCTION & 32'h04003014) == 32'h04001010);
  assign _zz_102 = ((decode_INSTRUCTION & 32'h04000000) == 32'h04000000);
  assign _zz_97 = {1'b0,{({_zz_99,(_zz_287 == _zz_288)} != 2'b00),{((_zz_289 == _zz_290) != 1'b0),{(_zz_291 != 1'b0),{(_zz_292 != _zz_293),{_zz_294,{_zz_295,_zz_296}}}}}}};
  assign _zz_103 = _zz_97[2 : 1];
  assign _zz_61 = _zz_103;
  assign _zz_104 = _zz_97[7 : 6];
  assign _zz_60 = _zz_104;
  assign _zz_105 = _zz_97[9 : 8];
  assign _zz_59 = _zz_105;
  assign _zz_106 = _zz_97[16 : 16];
  assign _zz_58 = _zz_106;
  assign _zz_107 = _zz_97[19 : 18];
  assign _zz_57 = _zz_107;
  assign _zz_108 = _zz_97[22 : 21];
  assign _zz_56 = _zz_108;
  assign _zz_109 = _zz_97[26 : 24];
  assign _zz_55 = _zz_109;
  assign _zz_110 = _zz_97[27 : 27];
  assign _zz_54 = _zz_110;
  assign _zz_111 = _zz_97[30 : 29];
  assign _zz_53 = _zz_111;
  assign _zz_112 = _zz_97[33 : 32];
  assign _zz_52 = _zz_112;
  assign decode_RegFilePlugin_regFileReadAddress1 = decode_INSTRUCTION_ANTICIPATED[19 : 15];
  assign decode_RegFilePlugin_regFileReadAddress2 = decode_INSTRUCTION_ANTICIPATED[24 : 20];
  assign decode_RegFilePlugin_regFileReadAddress3 = ((decode_INSTRUCTION_ANTICIPATED[6 : 0] == 7'h77) ? decode_INSTRUCTION_ANTICIPATED[11 : 7] : decode_INSTRUCTION_ANTICIPATED[31 : 27]);
  assign decode_RegFilePlugin_rs1Data = _zz_214;
  assign decode_RegFilePlugin_rs2Data = _zz_215;
  assign decode_RegFilePlugin_rs3Data = _zz_216;
  assign writeBack_RegFilePlugin_rdIndex = _zz_51[11 : 7];
  always @ (*) begin
    lastStageRegFileWrite_valid = (_zz_49 && writeBack_arbitration_isFiring);
    if(_zz_113)begin
      lastStageRegFileWrite_valid = 1'b1;
    end
  end

  always @ (*) begin
    lastStageRegFileWrite_payload_address = writeBack_RegFilePlugin_rdIndex;
    if(_zz_113)begin
      lastStageRegFileWrite_payload_address = 5'h0;
    end
  end

  always @ (*) begin
    lastStageRegFileWrite_payload_data = _zz_62;
    if(_zz_113)begin
      lastStageRegFileWrite_payload_data = 32'h0;
    end
  end

  always @ (*) begin
    case(execute_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 & execute_SRC2);
      end
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 | execute_SRC2);
      end
      default : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 ^ execute_SRC2);
      end
    endcase
  end

  always @ (*) begin
    case(execute_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_BITWISE : begin
        _zz_114 = execute_IntAluPlugin_bitwise;
      end
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : begin
        _zz_114 = {31'd0, _zz_252};
      end
      default : begin
        _zz_114 = execute_SRC_ADD_SUB;
      end
    endcase
  end

  always @ (*) begin
    case(execute_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : begin
        _zz_115 = execute_RS1;
      end
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : begin
        _zz_115 = {29'd0, _zz_253};
      end
      `Src1CtrlEnum_defaultEncoding_IMU : begin
        _zz_115 = {execute_INSTRUCTION[31 : 12],12'h0};
      end
      default : begin
        _zz_115 = {27'd0, _zz_254};
      end
    endcase
  end

  assign _zz_116 = execute_INSTRUCTION[31];
  always @ (*) begin
    _zz_117[19] = _zz_116;
    _zz_117[18] = _zz_116;
    _zz_117[17] = _zz_116;
    _zz_117[16] = _zz_116;
    _zz_117[15] = _zz_116;
    _zz_117[14] = _zz_116;
    _zz_117[13] = _zz_116;
    _zz_117[12] = _zz_116;
    _zz_117[11] = _zz_116;
    _zz_117[10] = _zz_116;
    _zz_117[9] = _zz_116;
    _zz_117[8] = _zz_116;
    _zz_117[7] = _zz_116;
    _zz_117[6] = _zz_116;
    _zz_117[5] = _zz_116;
    _zz_117[4] = _zz_116;
    _zz_117[3] = _zz_116;
    _zz_117[2] = _zz_116;
    _zz_117[1] = _zz_116;
    _zz_117[0] = _zz_116;
  end

  assign _zz_118 = _zz_255[11];
  always @ (*) begin
    _zz_119[19] = _zz_118;
    _zz_119[18] = _zz_118;
    _zz_119[17] = _zz_118;
    _zz_119[16] = _zz_118;
    _zz_119[15] = _zz_118;
    _zz_119[14] = _zz_118;
    _zz_119[13] = _zz_118;
    _zz_119[12] = _zz_118;
    _zz_119[11] = _zz_118;
    _zz_119[10] = _zz_118;
    _zz_119[9] = _zz_118;
    _zz_119[8] = _zz_118;
    _zz_119[7] = _zz_118;
    _zz_119[6] = _zz_118;
    _zz_119[5] = _zz_118;
    _zz_119[4] = _zz_118;
    _zz_119[3] = _zz_118;
    _zz_119[2] = _zz_118;
    _zz_119[1] = _zz_118;
    _zz_119[0] = _zz_118;
  end

  always @ (*) begin
    case(execute_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : begin
        _zz_120 = execute_RS2;
      end
      `Src2CtrlEnum_defaultEncoding_IMI : begin
        _zz_120 = {_zz_117,execute_INSTRUCTION[31 : 20]};
      end
      `Src2CtrlEnum_defaultEncoding_IMS : begin
        _zz_120 = {_zz_119,{execute_INSTRUCTION[31 : 25],execute_INSTRUCTION[11 : 7]}};
      end
      default : begin
        _zz_120 = _zz_44;
      end
    endcase
  end

  assign _zz_121 = execute_INSTRUCTION[31];
  always @ (*) begin
    _zz_122[19] = _zz_121;
    _zz_122[18] = _zz_121;
    _zz_122[17] = _zz_121;
    _zz_122[16] = _zz_121;
    _zz_122[15] = _zz_121;
    _zz_122[14] = _zz_121;
    _zz_122[13] = _zz_121;
    _zz_122[12] = _zz_121;
    _zz_122[11] = _zz_121;
    _zz_122[10] = _zz_121;
    _zz_122[9] = _zz_121;
    _zz_122[8] = _zz_121;
    _zz_122[7] = _zz_121;
    _zz_122[6] = _zz_121;
    _zz_122[5] = _zz_121;
    _zz_122[4] = _zz_121;
    _zz_122[3] = _zz_121;
    _zz_122[2] = _zz_121;
    _zz_122[1] = _zz_121;
    _zz_122[0] = _zz_121;
  end

  always @ (*) begin
    case(execute_SRC3_CTRL)
      `Src3CtrlEnum_defaultEncoding_RS : begin
        _zz_123 = execute_RS3;
      end
      default : begin
        _zz_123 = {_zz_122,execute_INSTRUCTION[31 : 20]};
      end
    endcase
  end

  always @ (*) begin
    execute_SrcPlugin_addSub = _zz_256;
    if(execute_SRC2_FORCE_ZERO)begin
      execute_SrcPlugin_addSub = execute_SRC1;
    end
  end

  assign execute_SrcPlugin_less = ((execute_SRC1[31] == execute_SRC2[31]) ? execute_SrcPlugin_addSub[31] : (execute_SRC_LESS_UNSIGNED ? execute_SRC2[31] : execute_SRC1[31]));
  assign execute_FullBarrelShifterPlugin_amplitude = execute_SRC2[4 : 0];
  always @ (*) begin
    _zz_124[0] = execute_SRC1[31];
    _zz_124[1] = execute_SRC1[30];
    _zz_124[2] = execute_SRC1[29];
    _zz_124[3] = execute_SRC1[28];
    _zz_124[4] = execute_SRC1[27];
    _zz_124[5] = execute_SRC1[26];
    _zz_124[6] = execute_SRC1[25];
    _zz_124[7] = execute_SRC1[24];
    _zz_124[8] = execute_SRC1[23];
    _zz_124[9] = execute_SRC1[22];
    _zz_124[10] = execute_SRC1[21];
    _zz_124[11] = execute_SRC1[20];
    _zz_124[12] = execute_SRC1[19];
    _zz_124[13] = execute_SRC1[18];
    _zz_124[14] = execute_SRC1[17];
    _zz_124[15] = execute_SRC1[16];
    _zz_124[16] = execute_SRC1[15];
    _zz_124[17] = execute_SRC1[14];
    _zz_124[18] = execute_SRC1[13];
    _zz_124[19] = execute_SRC1[12];
    _zz_124[20] = execute_SRC1[11];
    _zz_124[21] = execute_SRC1[10];
    _zz_124[22] = execute_SRC1[9];
    _zz_124[23] = execute_SRC1[8];
    _zz_124[24] = execute_SRC1[7];
    _zz_124[25] = execute_SRC1[6];
    _zz_124[26] = execute_SRC1[5];
    _zz_124[27] = execute_SRC1[4];
    _zz_124[28] = execute_SRC1[3];
    _zz_124[29] = execute_SRC1[2];
    _zz_124[30] = execute_SRC1[1];
    _zz_124[31] = execute_SRC1[0];
  end

  assign execute_FullBarrelShifterPlugin_reversed = ((execute_SHIFT_CTRL == `ShiftCtrlEnum_defaultEncoding_SLL_1) ? _zz_124 : execute_SRC1);
  always @ (*) begin
    _zz_125[0] = memory_SHIFT_RIGHT[31];
    _zz_125[1] = memory_SHIFT_RIGHT[30];
    _zz_125[2] = memory_SHIFT_RIGHT[29];
    _zz_125[3] = memory_SHIFT_RIGHT[28];
    _zz_125[4] = memory_SHIFT_RIGHT[27];
    _zz_125[5] = memory_SHIFT_RIGHT[26];
    _zz_125[6] = memory_SHIFT_RIGHT[25];
    _zz_125[7] = memory_SHIFT_RIGHT[24];
    _zz_125[8] = memory_SHIFT_RIGHT[23];
    _zz_125[9] = memory_SHIFT_RIGHT[22];
    _zz_125[10] = memory_SHIFT_RIGHT[21];
    _zz_125[11] = memory_SHIFT_RIGHT[20];
    _zz_125[12] = memory_SHIFT_RIGHT[19];
    _zz_125[13] = memory_SHIFT_RIGHT[18];
    _zz_125[14] = memory_SHIFT_RIGHT[17];
    _zz_125[15] = memory_SHIFT_RIGHT[16];
    _zz_125[16] = memory_SHIFT_RIGHT[15];
    _zz_125[17] = memory_SHIFT_RIGHT[14];
    _zz_125[18] = memory_SHIFT_RIGHT[13];
    _zz_125[19] = memory_SHIFT_RIGHT[12];
    _zz_125[20] = memory_SHIFT_RIGHT[11];
    _zz_125[21] = memory_SHIFT_RIGHT[10];
    _zz_125[22] = memory_SHIFT_RIGHT[9];
    _zz_125[23] = memory_SHIFT_RIGHT[8];
    _zz_125[24] = memory_SHIFT_RIGHT[7];
    _zz_125[25] = memory_SHIFT_RIGHT[6];
    _zz_125[26] = memory_SHIFT_RIGHT[5];
    _zz_125[27] = memory_SHIFT_RIGHT[4];
    _zz_125[28] = memory_SHIFT_RIGHT[3];
    _zz_125[29] = memory_SHIFT_RIGHT[2];
    _zz_125[30] = memory_SHIFT_RIGHT[1];
    _zz_125[31] = memory_SHIFT_RIGHT[0];
  end

  always @ (*) begin
    case(execute_CG6Ctrlminmax)
      `CG6CtrlminmaxEnum_defaultEncoding_CTRL_MAXU : begin
        execute_CG6Plugin_val_minmax = ((execute_SRC2 < execute_SRC1) ? execute_SRC1 : execute_SRC2);
      end
      default : begin
        execute_CG6Plugin_val_minmax = ((execute_SRC1 < execute_SRC2) ? execute_SRC1 : execute_SRC2);
      end
    endcase
  end

  assign _zz_126 = (execute_SRC2 & 32'h0000003f);
  assign _zz_127 = ((32'h00000020 <= _zz_126) ? _zz_263 : _zz_126);
  assign _zz_128 = ((_zz_127 == _zz_126) ? execute_SRC1 : execute_SRC3);
  always @ (*) begin
    case(execute_CG6Ctrlternary)
      `CG6CtrlternaryEnum_defaultEncoding_CTRL_CMIX : begin
        execute_CG6Plugin_val_ternary = ((execute_SRC1 & execute_SRC2) | (execute_SRC3 & (~ execute_SRC2)));
      end
      `CG6CtrlternaryEnum_defaultEncoding_CTRL_CMOV : begin
        execute_CG6Plugin_val_ternary = ((execute_SRC2 != 32'h0) ? execute_SRC1 : execute_SRC3);
      end
      default : begin
        execute_CG6Plugin_val_ternary = ((_zz_127 == 32'h0) ? _zz_128 : (_zz_264 | _zz_265));
      end
    endcase
  end

  always @ (*) begin
    case(execute_CG6Ctrl)
      `CG6CtrlEnum_defaultEncoding_CTRL_SH2ADD : begin
        _zz_129 = _zz_267;
      end
      `CG6CtrlEnum_defaultEncoding_CTRL_minmax : begin
        _zz_129 = execute_CG6Plugin_val_minmax;
      end
      `CG6CtrlEnum_defaultEncoding_CTRL_SEXTdotB : begin
        _zz_129 = {(execute_SRC1[7] ? 24'hffffff : 24'h0),execute_SRC1[7 : 0]};
      end
      `CG6CtrlEnum_defaultEncoding_CTRL_ternary : begin
        _zz_129 = execute_CG6Plugin_val_ternary;
      end
      default : begin
        _zz_129 = {{{execute_SRC1[7 : 0],execute_SRC1[15 : 8]},execute_SRC1[23 : 16]},execute_SRC1[31 : 24]};
      end
    endcase
  end

  always @ (*) begin
    HazardSimplePlugin_src0Hazard = 1'b0;
    if(_zz_230)begin
      if(_zz_231)begin
        if((_zz_134 || _zz_137))begin
          HazardSimplePlugin_src0Hazard = 1'b1;
        end
      end
    end
    if(_zz_232)begin
      if(_zz_233)begin
        if((_zz_144 || _zz_147))begin
          HazardSimplePlugin_src0Hazard = 1'b1;
        end
      end
    end
    if(_zz_234)begin
      if(_zz_235)begin
        if((_zz_154 || _zz_157))begin
          HazardSimplePlugin_src0Hazard = 1'b1;
        end
      end
    end
    if((! decode_RS1_USE))begin
      HazardSimplePlugin_src0Hazard = 1'b0;
    end
  end

  always @ (*) begin
    HazardSimplePlugin_src1Hazard = 1'b0;
    if(_zz_230)begin
      if(_zz_231)begin
        if((_zz_135 || _zz_138))begin
          HazardSimplePlugin_src1Hazard = 1'b1;
        end
        if((_zz_136 || _zz_139))begin
          HazardSimplePlugin_src1Hazard = 1'b1;
        end
      end
    end
    if(_zz_232)begin
      if(_zz_233)begin
        if((_zz_145 || _zz_148))begin
          HazardSimplePlugin_src1Hazard = 1'b1;
        end
        if((_zz_146 || _zz_149))begin
          HazardSimplePlugin_src1Hazard = 1'b1;
        end
      end
    end
    if(_zz_234)begin
      if(_zz_235)begin
        if((_zz_155 || _zz_158))begin
          HazardSimplePlugin_src1Hazard = 1'b1;
        end
        if((_zz_156 || _zz_159))begin
          HazardSimplePlugin_src1Hazard = 1'b1;
        end
      end
    end
    if((! decode_RS2_USE))begin
      HazardSimplePlugin_src1Hazard = 1'b0;
    end
  end

  always @ (*) begin
    HazardSimplePlugin_src2Hazard = 1'b0;
    if((! decode_RS3_USE))begin
      HazardSimplePlugin_src2Hazard = 1'b0;
    end
  end

  assign HazardSimplePlugin_notAES = ((! ((_zz_51 & 32'h3200707f) == 32'h32000033)) && (! ((_zz_51 & 32'h3a00707f) == 32'h30000033)));
  assign HazardSimplePlugin_rdIndex = (HazardSimplePlugin_notAES ? _zz_51[11 : 7] : _zz_51[19 : 15]);
  assign HazardSimplePlugin_regFileReadAddress3 = ((decode_INSTRUCTION[6 : 0] == 7'h77) ? decode_INSTRUCTION[11 : 7] : decode_INSTRUCTION[31 : 27]);
  assign HazardSimplePlugin_writeBackWrites_valid = (_zz_49 && writeBack_arbitration_isFiring);
  assign HazardSimplePlugin_writeBackWrites_payload_address = HazardSimplePlugin_rdIndex;
  assign HazardSimplePlugin_writeBackWrites_payload_data = _zz_62;
  assign HazardSimplePlugin_addr0Match = (HazardSimplePlugin_writeBackBuffer_payload_address == decode_INSTRUCTION[19 : 15]);
  assign HazardSimplePlugin_addr1Match = (HazardSimplePlugin_writeBackBuffer_payload_address == decode_INSTRUCTION[24 : 20]);
  assign HazardSimplePlugin_addr2Match = (HazardSimplePlugin_writeBackBuffer_payload_address == HazardSimplePlugin_regFileReadAddress3);
  assign _zz_130 = ((writeBack_INSTRUCTION & 32'he400707f) == 32'ha0000077);
  assign _zz_131 = (((! ((writeBack_INSTRUCTION & 32'h3200707f) == 32'h32000033)) && (! ((writeBack_INSTRUCTION & 32'h3a00707f) == 32'h30000033))) ? writeBack_INSTRUCTION[11 : 7] : writeBack_INSTRUCTION[19 : 15]);
  assign _zz_132 = (_zz_130 ? (_zz_131 ^ 5'h01) : 5'h0);
  assign _zz_133 = ((decode_INSTRUCTION[6 : 0] == 7'h77) ? decode_INSTRUCTION[11 : 7] : decode_INSTRUCTION[31 : 27]);
  assign _zz_134 = ((_zz_131 != 5'h0) && (_zz_131 == decode_INSTRUCTION[19 : 15]));
  assign _zz_135 = ((_zz_131 != 5'h0) && (_zz_131 == decode_INSTRUCTION[24 : 20]));
  assign _zz_136 = ((_zz_131 != 5'h0) && (_zz_131 == _zz_133));
  assign _zz_137 = ((_zz_132 != 5'h0) && (_zz_132 == decode_INSTRUCTION[19 : 15]));
  assign _zz_138 = ((_zz_132 != 5'h0) && (_zz_132 == decode_INSTRUCTION[24 : 20]));
  assign _zz_139 = ((_zz_132 != 5'h0) && (_zz_132 == _zz_133));
  assign _zz_140 = ((memory_INSTRUCTION & 32'he400707f) == 32'ha0000077);
  assign _zz_141 = (((! ((memory_INSTRUCTION & 32'h3200707f) == 32'h32000033)) && (! ((memory_INSTRUCTION & 32'h3a00707f) == 32'h30000033))) ? memory_INSTRUCTION[11 : 7] : memory_INSTRUCTION[19 : 15]);
  assign _zz_142 = (_zz_140 ? (_zz_141 ^ 5'h01) : 5'h0);
  assign _zz_143 = ((decode_INSTRUCTION[6 : 0] == 7'h77) ? decode_INSTRUCTION[11 : 7] : decode_INSTRUCTION[31 : 27]);
  assign _zz_144 = ((_zz_141 != 5'h0) && (_zz_141 == decode_INSTRUCTION[19 : 15]));
  assign _zz_145 = ((_zz_141 != 5'h0) && (_zz_141 == decode_INSTRUCTION[24 : 20]));
  assign _zz_146 = ((_zz_141 != 5'h0) && (_zz_141 == _zz_143));
  assign _zz_147 = ((_zz_142 != 5'h0) && (_zz_142 == decode_INSTRUCTION[19 : 15]));
  assign _zz_148 = ((_zz_142 != 5'h0) && (_zz_142 == decode_INSTRUCTION[24 : 20]));
  assign _zz_149 = ((_zz_142 != 5'h0) && (_zz_142 == _zz_143));
  assign _zz_150 = ((execute_INSTRUCTION & 32'he400707f) == 32'ha0000077);
  assign _zz_151 = (((! ((execute_INSTRUCTION & 32'h3200707f) == 32'h32000033)) && (! ((execute_INSTRUCTION & 32'h3a00707f) == 32'h30000033))) ? execute_INSTRUCTION[11 : 7] : execute_INSTRUCTION[19 : 15]);
  assign _zz_152 = (_zz_150 ? (_zz_151 ^ 5'h01) : 5'h0);
  assign _zz_153 = ((decode_INSTRUCTION[6 : 0] == 7'h77) ? decode_INSTRUCTION[11 : 7] : decode_INSTRUCTION[31 : 27]);
  assign _zz_154 = ((_zz_151 != 5'h0) && (_zz_151 == decode_INSTRUCTION[19 : 15]));
  assign _zz_155 = ((_zz_151 != 5'h0) && (_zz_151 == decode_INSTRUCTION[24 : 20]));
  assign _zz_156 = ((_zz_151 != 5'h0) && (_zz_151 == _zz_153));
  assign _zz_157 = ((_zz_152 != 5'h0) && (_zz_152 == decode_INSTRUCTION[19 : 15]));
  assign _zz_158 = ((_zz_152 != 5'h0) && (_zz_152 == decode_INSTRUCTION[24 : 20]));
  assign _zz_159 = ((_zz_152 != 5'h0) && (_zz_152 == _zz_153));
  assign execute_BranchPlugin_eq = (execute_SRC1 == execute_SRC2);
  assign _zz_160 = execute_INSTRUCTION[14 : 12];
  always @ (*) begin
    if((_zz_160 == 3'b000)) begin
        _zz_161 = execute_BranchPlugin_eq;
    end else if((_zz_160 == 3'b001)) begin
        _zz_161 = (! execute_BranchPlugin_eq);
    end else if((((_zz_160 & 3'b101) == 3'b101))) begin
        _zz_161 = (! execute_SRC_LESS);
    end else begin
        _zz_161 = execute_SRC_LESS;
    end
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : begin
        _zz_162 = 1'b0;
      end
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_162 = 1'b1;
      end
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        _zz_162 = 1'b1;
      end
      default : begin
        _zz_162 = _zz_161;
      end
    endcase
  end

  assign _zz_163 = execute_INSTRUCTION[31];
  always @ (*) begin
    _zz_164[19] = _zz_163;
    _zz_164[18] = _zz_163;
    _zz_164[17] = _zz_163;
    _zz_164[16] = _zz_163;
    _zz_164[15] = _zz_163;
    _zz_164[14] = _zz_163;
    _zz_164[13] = _zz_163;
    _zz_164[12] = _zz_163;
    _zz_164[11] = _zz_163;
    _zz_164[10] = _zz_163;
    _zz_164[9] = _zz_163;
    _zz_164[8] = _zz_163;
    _zz_164[7] = _zz_163;
    _zz_164[6] = _zz_163;
    _zz_164[5] = _zz_163;
    _zz_164[4] = _zz_163;
    _zz_164[3] = _zz_163;
    _zz_164[2] = _zz_163;
    _zz_164[1] = _zz_163;
    _zz_164[0] = _zz_163;
  end

  assign _zz_165 = _zz_269[19];
  always @ (*) begin
    _zz_166[10] = _zz_165;
    _zz_166[9] = _zz_165;
    _zz_166[8] = _zz_165;
    _zz_166[7] = _zz_165;
    _zz_166[6] = _zz_165;
    _zz_166[5] = _zz_165;
    _zz_166[4] = _zz_165;
    _zz_166[3] = _zz_165;
    _zz_166[2] = _zz_165;
    _zz_166[1] = _zz_165;
    _zz_166[0] = _zz_165;
  end

  assign _zz_167 = _zz_270[11];
  always @ (*) begin
    _zz_168[18] = _zz_167;
    _zz_168[17] = _zz_167;
    _zz_168[16] = _zz_167;
    _zz_168[15] = _zz_167;
    _zz_168[14] = _zz_167;
    _zz_168[13] = _zz_167;
    _zz_168[12] = _zz_167;
    _zz_168[11] = _zz_167;
    _zz_168[10] = _zz_167;
    _zz_168[9] = _zz_167;
    _zz_168[8] = _zz_167;
    _zz_168[7] = _zz_167;
    _zz_168[6] = _zz_167;
    _zz_168[5] = _zz_167;
    _zz_168[4] = _zz_167;
    _zz_168[3] = _zz_167;
    _zz_168[2] = _zz_167;
    _zz_168[1] = _zz_167;
    _zz_168[0] = _zz_167;
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        _zz_169 = (_zz_271[1] ^ execute_RS1[1]);
      end
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_169 = _zz_272[1];
      end
      default : begin
        _zz_169 = _zz_273[1];
      end
    endcase
  end

  assign execute_BranchPlugin_missAlignedTarget = (execute_BRANCH_COND_RESULT && _zz_169);
  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        execute_BranchPlugin_branch_src1 = execute_RS1;
      end
      default : begin
        execute_BranchPlugin_branch_src1 = execute_PC;
      end
    endcase
  end

  assign _zz_170 = execute_INSTRUCTION[31];
  always @ (*) begin
    _zz_171[19] = _zz_170;
    _zz_171[18] = _zz_170;
    _zz_171[17] = _zz_170;
    _zz_171[16] = _zz_170;
    _zz_171[15] = _zz_170;
    _zz_171[14] = _zz_170;
    _zz_171[13] = _zz_170;
    _zz_171[12] = _zz_170;
    _zz_171[11] = _zz_170;
    _zz_171[10] = _zz_170;
    _zz_171[9] = _zz_170;
    _zz_171[8] = _zz_170;
    _zz_171[7] = _zz_170;
    _zz_171[6] = _zz_170;
    _zz_171[5] = _zz_170;
    _zz_171[4] = _zz_170;
    _zz_171[3] = _zz_170;
    _zz_171[2] = _zz_170;
    _zz_171[1] = _zz_170;
    _zz_171[0] = _zz_170;
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        execute_BranchPlugin_branch_src2 = {_zz_171,execute_INSTRUCTION[31 : 20]};
      end
      default : begin
        execute_BranchPlugin_branch_src2 = ((execute_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) ? {{_zz_173,{{{_zz_397,execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]}},1'b0} : {{_zz_175,{{{_zz_398,_zz_399},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]}},1'b0});
        if(execute_PREDICTION_HAD_BRANCHED2)begin
          execute_BranchPlugin_branch_src2 = {29'd0, _zz_276};
        end
      end
    endcase
  end

  assign _zz_172 = _zz_274[19];
  always @ (*) begin
    _zz_173[10] = _zz_172;
    _zz_173[9] = _zz_172;
    _zz_173[8] = _zz_172;
    _zz_173[7] = _zz_172;
    _zz_173[6] = _zz_172;
    _zz_173[5] = _zz_172;
    _zz_173[4] = _zz_172;
    _zz_173[3] = _zz_172;
    _zz_173[2] = _zz_172;
    _zz_173[1] = _zz_172;
    _zz_173[0] = _zz_172;
  end

  assign _zz_174 = _zz_275[11];
  always @ (*) begin
    _zz_175[18] = _zz_174;
    _zz_175[17] = _zz_174;
    _zz_175[16] = _zz_174;
    _zz_175[15] = _zz_174;
    _zz_175[14] = _zz_174;
    _zz_175[13] = _zz_174;
    _zz_175[12] = _zz_174;
    _zz_175[11] = _zz_174;
    _zz_175[10] = _zz_174;
    _zz_175[9] = _zz_174;
    _zz_175[8] = _zz_174;
    _zz_175[7] = _zz_174;
    _zz_175[6] = _zz_174;
    _zz_175[5] = _zz_174;
    _zz_175[4] = _zz_174;
    _zz_175[3] = _zz_174;
    _zz_175[2] = _zz_174;
    _zz_175[1] = _zz_174;
    _zz_175[0] = _zz_174;
  end

  assign execute_BranchPlugin_branchAdder = (execute_BranchPlugin_branch_src1 + execute_BranchPlugin_branch_src2);
  assign BranchPlugin_jumpInterface_valid = ((memory_arbitration_isValid && memory_BRANCH_DO) && (! 1'b0));
  assign BranchPlugin_jumpInterface_payload = memory_BRANCH_CALC;
  assign IBusCachedPlugin_decodePrediction_rsp_wasWrong = BranchPlugin_jumpInterface_valid;
  assign _zz_31 = decode_SRC1_CTRL;
  assign _zz_29 = _zz_61;
  assign _zz_46 = decode_to_execute_SRC1_CTRL;
  assign _zz_28 = decode_ALU_CTRL;
  assign _zz_26 = _zz_60;
  assign _zz_47 = decode_to_execute_ALU_CTRL;
  assign _zz_25 = decode_SRC2_CTRL;
  assign _zz_23 = _zz_59;
  assign _zz_45 = decode_to_execute_SRC2_CTRL;
  assign _zz_22 = decode_SRC3_CTRL;
  assign _zz_20 = _zz_58;
  assign _zz_43 = decode_to_execute_SRC3_CTRL;
  assign _zz_19 = decode_ALU_BITWISE_CTRL;
  assign _zz_17 = _zz_57;
  assign _zz_48 = decode_to_execute_ALU_BITWISE_CTRL;
  assign _zz_16 = decode_SHIFT_CTRL;
  assign _zz_13 = execute_SHIFT_CTRL;
  assign _zz_14 = _zz_56;
  assign _zz_42 = decode_to_execute_SHIFT_CTRL;
  assign _zz_41 = execute_to_memory_SHIFT_CTRL;
  assign _zz_11 = decode_CG6Ctrl;
  assign _zz_9 = _zz_55;
  assign _zz_37 = decode_to_execute_CG6Ctrl;
  assign _zz_8 = decode_CG6Ctrlminmax;
  assign _zz_6 = _zz_54;
  assign _zz_39 = decode_to_execute_CG6Ctrlminmax;
  assign _zz_5 = decode_CG6Ctrlternary;
  assign _zz_3 = _zz_53;
  assign _zz_38 = decode_to_execute_CG6Ctrlternary;
  assign _zz_2 = decode_BRANCH_CTRL;
  assign _zz_63 = _zz_52;
  assign _zz_32 = decode_to_execute_BRANCH_CTRL;
  assign decode_arbitration_isFlushed = (({writeBack_arbitration_flushNext,{memory_arbitration_flushNext,execute_arbitration_flushNext}} != 3'b000) || ({writeBack_arbitration_flushIt,{memory_arbitration_flushIt,{execute_arbitration_flushIt,decode_arbitration_flushIt}}} != 4'b0000));
  assign execute_arbitration_isFlushed = (({writeBack_arbitration_flushNext,memory_arbitration_flushNext} != 2'b00) || ({writeBack_arbitration_flushIt,{memory_arbitration_flushIt,execute_arbitration_flushIt}} != 3'b000));
  assign memory_arbitration_isFlushed = ((writeBack_arbitration_flushNext != 1'b0) || ({writeBack_arbitration_flushIt,memory_arbitration_flushIt} != 2'b00));
  assign writeBack_arbitration_isFlushed = (1'b0 || (writeBack_arbitration_flushIt != 1'b0));
  assign decode_arbitration_isStuckByOthers = (decode_arbitration_haltByOther || (((1'b0 || execute_arbitration_isStuck) || memory_arbitration_isStuck) || writeBack_arbitration_isStuck));
  assign decode_arbitration_isStuck = (decode_arbitration_haltItself || decode_arbitration_isStuckByOthers);
  assign decode_arbitration_isMoving = ((! decode_arbitration_isStuck) && (! decode_arbitration_removeIt));
  assign decode_arbitration_isFiring = ((decode_arbitration_isValid && (! decode_arbitration_isStuck)) && (! decode_arbitration_removeIt));
  assign execute_arbitration_isStuckByOthers = (execute_arbitration_haltByOther || ((1'b0 || memory_arbitration_isStuck) || writeBack_arbitration_isStuck));
  assign execute_arbitration_isStuck = (execute_arbitration_haltItself || execute_arbitration_isStuckByOthers);
  assign execute_arbitration_isMoving = ((! execute_arbitration_isStuck) && (! execute_arbitration_removeIt));
  assign execute_arbitration_isFiring = ((execute_arbitration_isValid && (! execute_arbitration_isStuck)) && (! execute_arbitration_removeIt));
  assign memory_arbitration_isStuckByOthers = (memory_arbitration_haltByOther || (1'b0 || writeBack_arbitration_isStuck));
  assign memory_arbitration_isStuck = (memory_arbitration_haltItself || memory_arbitration_isStuckByOthers);
  assign memory_arbitration_isMoving = ((! memory_arbitration_isStuck) && (! memory_arbitration_removeIt));
  assign memory_arbitration_isFiring = ((memory_arbitration_isValid && (! memory_arbitration_isStuck)) && (! memory_arbitration_removeIt));
  assign writeBack_arbitration_isStuckByOthers = (writeBack_arbitration_haltByOther || 1'b0);
  assign writeBack_arbitration_isStuck = (writeBack_arbitration_haltItself || writeBack_arbitration_isStuckByOthers);
  assign writeBack_arbitration_isMoving = ((! writeBack_arbitration_isStuck) && (! writeBack_arbitration_removeIt));
  assign writeBack_arbitration_isFiring = ((writeBack_arbitration_isValid && (! writeBack_arbitration_isStuck)) && (! writeBack_arbitration_removeIt));
  assign iBusWishbone_ADR = {_zz_277,_zz_176};
  assign iBusWishbone_CTI = ((_zz_176 == 2'b11) ? 3'b111 : 3'b010);
  assign iBusWishbone_BTE = 2'b00;
  assign iBusWishbone_SEL = 4'b1111;
  assign iBusWishbone_WE = 1'b0;
  assign iBusWishbone_DAT_MOSI = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
  always @ (*) begin
    iBusWishbone_CYC = 1'b0;
    if(_zz_236)begin
      iBusWishbone_CYC = 1'b1;
    end
  end

  always @ (*) begin
    iBusWishbone_STB = 1'b0;
    if(_zz_236)begin
      iBusWishbone_STB = 1'b1;
    end
  end

  assign iBus_cmd_ready = (iBus_cmd_valid && iBusWishbone_ACK);
  assign iBus_rsp_valid = _zz_177;
  assign iBus_rsp_payload_data = iBusWishbone_DAT_MISO_regNext;
  assign iBus_rsp_payload_error = 1'b0;
  assign _zz_183 = (dBus_cmd_payload_size == 3'b100);
  assign _zz_179 = dBus_cmd_valid;
  assign _zz_181 = dBus_cmd_payload_wr;
  assign _zz_182 = ((! _zz_183) || (_zz_178 == 2'b11));
  assign dBus_cmd_ready = (_zz_180 && (_zz_181 || _zz_182));
  assign dBusWishbone_ADR = ((_zz_183 ? {{dBus_cmd_payload_address[31 : 4],_zz_178},2'b00} : {dBus_cmd_payload_address[31 : 2],2'b00}) >>> 2);
  assign dBusWishbone_CTI = (_zz_183 ? (_zz_182 ? 3'b111 : 3'b010) : 3'b000);
  assign dBusWishbone_BTE = 2'b00;
  assign dBusWishbone_SEL = (_zz_181 ? dBus_cmd_payload_mask : 4'b1111);
  assign dBusWishbone_WE = _zz_181;
  assign dBusWishbone_DAT_MOSI = dBus_cmd_payload_data;
  assign _zz_180 = (_zz_179 && dBusWishbone_ACK);
  assign dBusWishbone_CYC = _zz_179;
  assign dBusWishbone_STB = _zz_179;
  assign dBus_rsp_valid = _zz_184;
  assign dBus_rsp_payload_data = dBusWishbone_DAT_MISO_regNext;
  assign dBus_rsp_payload_error = 1'b0;
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      IBusCachedPlugin_fetchPc_pcReg <= 32'h00410000;
      IBusCachedPlugin_fetchPc_correctionReg <= 1'b0;
      IBusCachedPlugin_fetchPc_booted <= 1'b0;
      IBusCachedPlugin_fetchPc_inc <= 1'b0;
      _zz_75 <= 1'b0;
      _zz_77 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_0 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_1 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_2 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_3 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_4 <= 1'b0;
      IBusCachedPlugin_rspCounter <= _zz_90;
      IBusCachedPlugin_rspCounter <= 32'h0;
      dataCache_1_io_mem_cmd_m2sPipe_rValid <= 1'b0;
      DBusCachedPlugin_rspCounter <= _zz_91;
      DBusCachedPlugin_rspCounter <= 32'h0;
      _zz_113 <= 1'b1;
      HazardSimplePlugin_writeBackBuffer_valid <= 1'b0;
      execute_arbitration_isValid <= 1'b0;
      memory_arbitration_isValid <= 1'b0;
      writeBack_arbitration_isValid <= 1'b0;
      _zz_176 <= 2'b00;
      _zz_177 <= 1'b0;
      _zz_178 <= 2'b00;
      _zz_184 <= 1'b0;
    end else begin
      if(IBusCachedPlugin_fetchPc_correction)begin
        IBusCachedPlugin_fetchPc_correctionReg <= 1'b1;
      end
      if((IBusCachedPlugin_fetchPc_output_valid && IBusCachedPlugin_fetchPc_output_ready))begin
        IBusCachedPlugin_fetchPc_correctionReg <= 1'b0;
      end
      IBusCachedPlugin_fetchPc_booted <= 1'b1;
      if((IBusCachedPlugin_fetchPc_correction || IBusCachedPlugin_fetchPc_pcRegPropagate))begin
        IBusCachedPlugin_fetchPc_inc <= 1'b0;
      end
      if((IBusCachedPlugin_fetchPc_output_valid && IBusCachedPlugin_fetchPc_output_ready))begin
        IBusCachedPlugin_fetchPc_inc <= 1'b1;
      end
      if(((! IBusCachedPlugin_fetchPc_output_valid) && IBusCachedPlugin_fetchPc_output_ready))begin
        IBusCachedPlugin_fetchPc_inc <= 1'b0;
      end
      if((IBusCachedPlugin_fetchPc_booted && ((IBusCachedPlugin_fetchPc_output_ready || IBusCachedPlugin_fetchPc_correction) || IBusCachedPlugin_fetchPc_pcRegPropagate)))begin
        IBusCachedPlugin_fetchPc_pcReg <= IBusCachedPlugin_fetchPc_pc;
      end
      if(IBusCachedPlugin_iBusRsp_flush)begin
        _zz_75 <= 1'b0;
      end
      if(_zz_73)begin
        _zz_75 <= (IBusCachedPlugin_iBusRsp_stages_0_output_valid && (! 1'b0));
      end
      if(IBusCachedPlugin_iBusRsp_flush)begin
        _zz_77 <= 1'b0;
      end
      if(IBusCachedPlugin_iBusRsp_stages_1_output_ready)begin
        _zz_77 <= (IBusCachedPlugin_iBusRsp_stages_1_output_valid && (! IBusCachedPlugin_iBusRsp_flush));
      end
      if(IBusCachedPlugin_fetchPc_flushed)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_0 <= 1'b0;
      end
      if((! (! IBusCachedPlugin_iBusRsp_stages_1_input_ready)))begin
        IBusCachedPlugin_injector_nextPcCalc_valids_0 <= 1'b1;
      end
      if(IBusCachedPlugin_fetchPc_flushed)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_1 <= 1'b0;
      end
      if((! (! IBusCachedPlugin_iBusRsp_stages_2_input_ready)))begin
        IBusCachedPlugin_injector_nextPcCalc_valids_1 <= IBusCachedPlugin_injector_nextPcCalc_valids_0;
      end
      if(IBusCachedPlugin_fetchPc_flushed)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_1 <= 1'b0;
      end
      if(IBusCachedPlugin_fetchPc_flushed)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_2 <= 1'b0;
      end
      if((! execute_arbitration_isStuck))begin
        IBusCachedPlugin_injector_nextPcCalc_valids_2 <= IBusCachedPlugin_injector_nextPcCalc_valids_1;
      end
      if(IBusCachedPlugin_fetchPc_flushed)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_2 <= 1'b0;
      end
      if(IBusCachedPlugin_fetchPc_flushed)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_3 <= 1'b0;
      end
      if((! memory_arbitration_isStuck))begin
        IBusCachedPlugin_injector_nextPcCalc_valids_3 <= IBusCachedPlugin_injector_nextPcCalc_valids_2;
      end
      if(IBusCachedPlugin_fetchPc_flushed)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_3 <= 1'b0;
      end
      if(IBusCachedPlugin_fetchPc_flushed)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_4 <= 1'b0;
      end
      if((! writeBack_arbitration_isStuck))begin
        IBusCachedPlugin_injector_nextPcCalc_valids_4 <= IBusCachedPlugin_injector_nextPcCalc_valids_3;
      end
      if(IBusCachedPlugin_fetchPc_flushed)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_4 <= 1'b0;
      end
      if(iBus_rsp_valid)begin
        IBusCachedPlugin_rspCounter <= (IBusCachedPlugin_rspCounter + 32'h00000001);
      end
      if(_zz_213)begin
        dataCache_1_io_mem_cmd_m2sPipe_rValid <= dataCache_1_io_mem_cmd_valid;
      end
      if(dBus_rsp_valid)begin
        DBusCachedPlugin_rspCounter <= (DBusCachedPlugin_rspCounter + 32'h00000001);
      end
      _zz_113 <= 1'b0;
      HazardSimplePlugin_writeBackBuffer_valid <= HazardSimplePlugin_writeBackWrites_valid;
      if(((! execute_arbitration_isStuck) || execute_arbitration_removeIt))begin
        execute_arbitration_isValid <= 1'b0;
      end
      if(((! decode_arbitration_isStuck) && (! decode_arbitration_removeIt)))begin
        execute_arbitration_isValid <= decode_arbitration_isValid;
      end
      if(((! memory_arbitration_isStuck) || memory_arbitration_removeIt))begin
        memory_arbitration_isValid <= 1'b0;
      end
      if(((! execute_arbitration_isStuck) && (! execute_arbitration_removeIt)))begin
        memory_arbitration_isValid <= execute_arbitration_isValid;
      end
      if(((! writeBack_arbitration_isStuck) || writeBack_arbitration_removeIt))begin
        writeBack_arbitration_isValid <= 1'b0;
      end
      if(((! memory_arbitration_isStuck) && (! memory_arbitration_removeIt)))begin
        writeBack_arbitration_isValid <= memory_arbitration_isValid;
      end
      if(_zz_236)begin
        if(iBusWishbone_ACK)begin
          _zz_176 <= (_zz_176 + 2'b01);
        end
      end
      _zz_177 <= (iBusWishbone_CYC && iBusWishbone_ACK);
      if((_zz_179 && _zz_180))begin
        _zz_178 <= (_zz_178 + 2'b01);
        if(_zz_182)begin
          _zz_178 <= 2'b00;
        end
      end
      _zz_184 <= ((_zz_179 && (! dBusWishbone_WE)) && dBusWishbone_ACK);
    end
  end

  always @ (posedge clk) begin
    if(IBusCachedPlugin_iBusRsp_stages_1_output_ready)begin
      _zz_78 <= IBusCachedPlugin_iBusRsp_stages_1_output_payload;
    end
    if(IBusCachedPlugin_iBusRsp_stages_1_input_ready)begin
      IBusCachedPlugin_s1_tightlyCoupledHit <= IBusCachedPlugin_s0_tightlyCoupledHit;
    end
    if(IBusCachedPlugin_iBusRsp_stages_2_input_ready)begin
      IBusCachedPlugin_s2_tightlyCoupledHit <= IBusCachedPlugin_s1_tightlyCoupledHit;
    end
    if(_zz_213)begin
      dataCache_1_io_mem_cmd_m2sPipe_rData_wr <= dataCache_1_io_mem_cmd_payload_wr;
      dataCache_1_io_mem_cmd_m2sPipe_rData_uncached <= dataCache_1_io_mem_cmd_payload_uncached;
      dataCache_1_io_mem_cmd_m2sPipe_rData_address <= dataCache_1_io_mem_cmd_payload_address;
      dataCache_1_io_mem_cmd_m2sPipe_rData_data <= dataCache_1_io_mem_cmd_payload_data;
      dataCache_1_io_mem_cmd_m2sPipe_rData_mask <= dataCache_1_io_mem_cmd_payload_mask;
      dataCache_1_io_mem_cmd_m2sPipe_rData_size <= dataCache_1_io_mem_cmd_payload_size;
      dataCache_1_io_mem_cmd_m2sPipe_rData_last <= dataCache_1_io_mem_cmd_payload_last;
    end
    HazardSimplePlugin_writeBackBuffer_payload_address <= HazardSimplePlugin_writeBackWrites_payload_address;
    HazardSimplePlugin_writeBackBuffer_payload_data <= HazardSimplePlugin_writeBackWrites_payload_data;
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_PC <= decode_PC;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_PC <= _zz_44;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_PC <= memory_PC;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_INSTRUCTION <= decode_INSTRUCTION;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_INSTRUCTION <= execute_INSTRUCTION;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_INSTRUCTION <= memory_INSTRUCTION;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_FORMAL_PC_NEXT <= _zz_65;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_FORMAL_PC_NEXT <= execute_FORMAL_PC_NEXT;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_FORMAL_PC_NEXT <= _zz_64;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_MEMORY_FORCE_CONSTISTENCY <= decode_MEMORY_FORCE_CONSTISTENCY;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC1_CTRL <= _zz_30;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC_USE_SUB_LESS <= decode_SRC_USE_SUB_LESS;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_MEMORY_ENABLE <= decode_MEMORY_ENABLE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MEMORY_ENABLE <= execute_MEMORY_ENABLE;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MEMORY_ENABLE <= memory_MEMORY_ENABLE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ALU_CTRL <= _zz_27;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC2_CTRL <= _zz_24;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_REGFILE_WRITE_VALID <= decode_REGFILE_WRITE_VALID;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_REGFILE_WRITE_VALID <= execute_REGFILE_WRITE_VALID;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_REGFILE_WRITE_VALID <= memory_REGFILE_WRITE_VALID;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BYPASSABLE_EXECUTE_STAGE <= decode_BYPASSABLE_EXECUTE_STAGE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BYPASSABLE_MEMORY_STAGE <= decode_BYPASSABLE_MEMORY_STAGE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_BYPASSABLE_MEMORY_STAGE <= execute_BYPASSABLE_MEMORY_STAGE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_MEMORY_WR <= decode_MEMORY_WR;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_MEMORY_MANAGMENT <= decode_MEMORY_MANAGMENT;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC3_CTRL <= _zz_21;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC_LESS_UNSIGNED <= decode_SRC_LESS_UNSIGNED;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ALU_BITWISE_CTRL <= _zz_18;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SHIFT_CTRL <= _zz_15;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_SHIFT_CTRL <= _zz_12;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_CG6 <= decode_IS_CG6;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_IS_CG6 <= execute_IS_CG6;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_CG6Ctrl <= _zz_10;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_CG6Ctrlminmax <= _zz_7;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_CG6Ctrlternary <= _zz_4;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BRANCH_CTRL <= _zz_1;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_REGFILE_WRITE_VALID_ODD <= decode_REGFILE_WRITE_VALID_ODD;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_REGFILE_WRITE_VALID_ODD <= execute_REGFILE_WRITE_VALID_ODD;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_REGFILE_WRITE_VALID_ODD <= memory_REGFILE_WRITE_VALID_ODD;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_RS1 <= decode_RS1;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_RS2 <= decode_RS2;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_RS3 <= decode_RS3;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC2_FORCE_ZERO <= decode_SRC2_FORCE_ZERO;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_PREDICTION_HAD_BRANCHED2 <= decode_PREDICTION_HAD_BRANCHED2;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MEMORY_STORE_DATA_RF <= execute_MEMORY_STORE_DATA_RF;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MEMORY_STORE_DATA_RF <= memory_MEMORY_STORE_DATA_RF;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_REGFILE_WRITE_DATA <= _zz_34;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_REGFILE_WRITE_DATA <= _zz_40;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_REGFILE_WRITE_DATA_ODD <= _zz_33;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_REGFILE_WRITE_DATA_ODD <= _zz_35;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_SHIFT_RIGHT <= execute_SHIFT_RIGHT;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_CG6_FINAL_OUTPUT <= execute_CG6_FINAL_OUTPUT;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_BRANCH_DO <= execute_BRANCH_DO;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_BRANCH_CALC <= execute_BRANCH_CALC;
    end
    iBusWishbone_DAT_MISO_regNext <= iBusWishbone_DAT_MISO;
    dBusWishbone_DAT_MISO_regNext <= dBusWishbone_DAT_MISO;
  end


endmodule

module DataCache (
  input               io_cpu_execute_isValid,
  input      [31:0]   io_cpu_execute_address,
  output reg          io_cpu_execute_haltIt,
  input               io_cpu_execute_args_wr,
  input      [1:0]    io_cpu_execute_args_size,
  input               io_cpu_execute_args_totalyConsistent,
  output              io_cpu_execute_refilling,
  input               io_cpu_memory_isValid,
  input               io_cpu_memory_isStuck,
  output              io_cpu_memory_isWrite,
  input      [31:0]   io_cpu_memory_address,
  input      [31:0]   io_cpu_memory_mmuRsp_physicalAddress,
  input               io_cpu_memory_mmuRsp_isIoAccess,
  input               io_cpu_memory_mmuRsp_isPaging,
  input               io_cpu_memory_mmuRsp_allowRead,
  input               io_cpu_memory_mmuRsp_allowWrite,
  input               io_cpu_memory_mmuRsp_allowExecute,
  input               io_cpu_memory_mmuRsp_exception,
  input               io_cpu_memory_mmuRsp_refilling,
  input               io_cpu_memory_mmuRsp_bypassTranslation,
  input               io_cpu_writeBack_isValid,
  input               io_cpu_writeBack_isStuck,
  input               io_cpu_writeBack_isUser,
  output reg          io_cpu_writeBack_haltIt,
  output              io_cpu_writeBack_isWrite,
  input      [31:0]   io_cpu_writeBack_storeData,
  output reg [31:0]   io_cpu_writeBack_data,
  input      [31:0]   io_cpu_writeBack_address,
  output              io_cpu_writeBack_mmuException,
  output              io_cpu_writeBack_unalignedAccess,
  output              io_cpu_writeBack_accessError,
  output              io_cpu_writeBack_keepMemRspData,
  input               io_cpu_writeBack_fence_SW,
  input               io_cpu_writeBack_fence_SR,
  input               io_cpu_writeBack_fence_SO,
  input               io_cpu_writeBack_fence_SI,
  input               io_cpu_writeBack_fence_PW,
  input               io_cpu_writeBack_fence_PR,
  input               io_cpu_writeBack_fence_PO,
  input               io_cpu_writeBack_fence_PI,
  input      [3:0]    io_cpu_writeBack_fence_FM,
  output              io_cpu_writeBack_exclusiveOk,
  output reg          io_cpu_redo,
  input               io_cpu_flush_valid,
  output              io_cpu_flush_ready,
  output reg          io_mem_cmd_valid,
  input               io_mem_cmd_ready,
  output reg          io_mem_cmd_payload_wr,
  output              io_mem_cmd_payload_uncached,
  output reg [31:0]   io_mem_cmd_payload_address,
  output     [31:0]   io_mem_cmd_payload_data,
  output     [3:0]    io_mem_cmd_payload_mask,
  output reg [2:0]    io_mem_cmd_payload_size,
  output              io_mem_cmd_payload_last,
  input               io_mem_rsp_valid,
  input               io_mem_rsp_payload_last,
  input      [31:0]   io_mem_rsp_payload_data,
  input               io_mem_rsp_payload_error,
  input               clk,
  input               reset
);
  reg        [26:0]   _zz_17;
  reg        [31:0]   _zz_18;
  reg        [26:0]   _zz_19;
  reg        [31:0]   _zz_20;
  wire                _zz_21;
  wire                _zz_22;
  wire                _zz_23;
  wire                _zz_24;
  wire                _zz_25;
  wire                _zz_26;
  wire       [0:0]    _zz_27;
  wire       [0:0]    _zz_28;
  wire       [1:0]    _zz_29;
  wire       [2:0]    _zz_30;
  wire       [26:0]   _zz_31;
  wire       [26:0]   _zz_32;
  reg                 _zz_1;
  reg                 _zz_2;
  reg                 _zz_3;
  reg                 _zz_4;
  wire                haltCpu;
  reg                 tagsReadCmd_valid;
  reg        [2:0]    tagsReadCmd_payload;
  reg                 tagsWriteCmd_valid;
  reg        [1:0]    tagsWriteCmd_payload_way;
  reg        [2:0]    tagsWriteCmd_payload_address;
  reg                 tagsWriteCmd_payload_data_valid;
  reg                 tagsWriteCmd_payload_data_error;
  reg        [24:0]   tagsWriteCmd_payload_data_address;
  reg                 tagsWriteLastCmd_valid;
  reg        [1:0]    tagsWriteLastCmd_payload_way;
  reg        [2:0]    tagsWriteLastCmd_payload_address;
  reg                 tagsWriteLastCmd_payload_data_valid;
  reg                 tagsWriteLastCmd_payload_data_error;
  reg        [24:0]   tagsWriteLastCmd_payload_data_address;
  reg                 dataReadCmd_valid;
  reg        [4:0]    dataReadCmd_payload;
  reg                 dataWriteCmd_valid;
  reg        [1:0]    dataWriteCmd_payload_way;
  reg        [4:0]    dataWriteCmd_payload_address;
  reg        [31:0]   dataWriteCmd_payload_data;
  reg        [3:0]    dataWriteCmd_payload_mask;
  wire                _zz_5;
  wire                ways_0_tagsReadRsp_valid;
  wire                ways_0_tagsReadRsp_error;
  wire       [24:0]   ways_0_tagsReadRsp_address;
  wire       [26:0]   _zz_6;
  wire                _zz_7;
  wire       [31:0]   ways_0_dataReadRspMem;
  wire       [31:0]   ways_0_dataReadRsp;
  wire                _zz_8;
  wire                ways_1_tagsReadRsp_valid;
  wire                ways_1_tagsReadRsp_error;
  wire       [24:0]   ways_1_tagsReadRsp_address;
  wire       [26:0]   _zz_9;
  wire                _zz_10;
  wire       [31:0]   ways_1_dataReadRspMem;
  wire       [31:0]   ways_1_dataReadRsp;
  wire                rspSync;
  wire                rspLast;
  reg                 memCmdSent;
  reg        [3:0]    _zz_11;
  wire       [3:0]    stage0_mask;
  reg        [1:0]    stage0_dataColisions;
  wire       [4:0]    _zz_12;
  wire       [3:0]    _zz_13;
  wire       [1:0]    stage0_wayInvalidate;
  wire                stage0_isAmo;
  reg                 stageA_request_wr;
  reg        [1:0]    stageA_request_size;
  reg                 stageA_request_totalyConsistent;
  reg        [3:0]    stageA_mask;
  wire                stageA_isAmo;
  wire                stageA_isLrsc;
  wire       [1:0]    stageA_wayHits;
  reg        [1:0]    stageA_wayInvalidate;
  reg        [1:0]    stage0_dataColisions_regNextWhen;
  reg        [1:0]    _zz_14;
  wire       [4:0]    _zz_15;
  wire       [3:0]    _zz_16;
  wire       [1:0]    stageA_dataColisions;
  reg                 stageB_request_wr;
  reg        [1:0]    stageB_request_size;
  reg                 stageB_request_totalyConsistent;
  reg                 stageB_mmuRspFreeze;
  reg        [31:0]   stageB_mmuRsp_physicalAddress;
  reg                 stageB_mmuRsp_isIoAccess;
  reg                 stageB_mmuRsp_isPaging;
  reg                 stageB_mmuRsp_allowRead;
  reg                 stageB_mmuRsp_allowWrite;
  reg                 stageB_mmuRsp_allowExecute;
  reg                 stageB_mmuRsp_exception;
  reg                 stageB_mmuRsp_refilling;
  reg                 stageB_mmuRsp_bypassTranslation;
  reg                 stageB_tagsReadRsp_0_valid;
  reg                 stageB_tagsReadRsp_0_error;
  reg        [24:0]   stageB_tagsReadRsp_0_address;
  reg                 stageB_tagsReadRsp_1_valid;
  reg                 stageB_tagsReadRsp_1_error;
  reg        [24:0]   stageB_tagsReadRsp_1_address;
  reg        [31:0]   stageB_dataReadRsp_0;
  reg        [31:0]   stageB_dataReadRsp_1;
  reg        [1:0]    stageB_wayInvalidate;
  wire                stageB_consistancyHazard;
  reg        [1:0]    stageB_dataColisions;
  wire                stageB_unaligned;
  reg        [1:0]    stageB_waysHitsBeforeInvalidate;
  wire       [1:0]    stageB_waysHits;
  wire                stageB_waysHit;
  wire       [31:0]   stageB_dataMux;
  reg        [3:0]    stageB_mask;
  reg                 stageB_loaderValid;
  wire       [31:0]   stageB_ioMemRspMuxed;
  reg                 stageB_flusher_waitDone;
  wire                stageB_flusher_hold;
  reg        [3:0]    stageB_flusher_counter;
  reg                 stageB_flusher_start;
  wire                stageB_isAmo;
  wire                stageB_isAmoCached;
  wire                stageB_isExternalLsrc;
  wire                stageB_isExternalAmo;
  wire       [31:0]   stageB_requestDataBypass;
  reg                 stageB_cpuWriteToCache;
  wire                stageB_badPermissions;
  wire                stageB_loadStoreFault;
  wire                stageB_bypassCache;
  reg                 loader_valid;
  reg                 loader_counter_willIncrement;
  wire                loader_counter_willClear;
  reg        [1:0]    loader_counter_valueNext;
  reg        [1:0]    loader_counter_value;
  wire                loader_counter_willOverflowIfInc;
  wire                loader_counter_willOverflow;
  reg        [1:0]    loader_waysAllocator;
  reg                 loader_error;
  wire                loader_kill;
  reg                 loader_killReg;
  wire                loader_done;
  reg                 loader_valid_regNext;
  reg [26:0] ways_0_tags [0:7];
  reg [7:0] ways_0_data_symbol0 [0:31];
  reg [7:0] ways_0_data_symbol1 [0:31];
  reg [7:0] ways_0_data_symbol2 [0:31];
  reg [7:0] ways_0_data_symbol3 [0:31];
  reg [7:0] _zz_33;
  reg [7:0] _zz_34;
  reg [7:0] _zz_35;
  reg [7:0] _zz_36;
  reg [26:0] ways_1_tags [0:7];
  reg [7:0] ways_1_data_symbol0 [0:31];
  reg [7:0] ways_1_data_symbol1 [0:31];
  reg [7:0] ways_1_data_symbol2 [0:31];
  reg [7:0] ways_1_data_symbol3 [0:31];
  reg [7:0] _zz_37;
  reg [7:0] _zz_38;
  reg [7:0] _zz_39;
  reg [7:0] _zz_40;

  assign _zz_21 = (io_cpu_execute_isValid && (! io_cpu_memory_isStuck));
  assign _zz_22 = (! stageB_flusher_counter[3]);
  assign _zz_23 = ((((stageB_consistancyHazard || stageB_mmuRsp_refilling) || io_cpu_writeBack_accessError) || io_cpu_writeBack_mmuException) || io_cpu_writeBack_unalignedAccess);
  assign _zz_24 = ((loader_valid && io_mem_rsp_valid) && rspLast);
  assign _zz_25 = (stageB_mmuRsp_isIoAccess || stageB_isExternalLsrc);
  assign _zz_26 = (stageB_waysHit || (stageB_request_wr && (! stageB_isAmoCached)));
  assign _zz_27 = 1'b1;
  assign _zz_28 = loader_counter_willIncrement;
  assign _zz_29 = {1'd0, _zz_28};
  assign _zz_30 = {loader_waysAllocator,loader_waysAllocator[1]};
  assign _zz_31 = {tagsWriteCmd_payload_data_address,{tagsWriteCmd_payload_data_error,tagsWriteCmd_payload_data_valid}};
  assign _zz_32 = {tagsWriteCmd_payload_data_address,{tagsWriteCmd_payload_data_error,tagsWriteCmd_payload_data_valid}};
  always @ (posedge clk) begin
    if(_zz_5) begin
      _zz_17 <= ways_0_tags[tagsReadCmd_payload];
    end
  end

  always @ (posedge clk) begin
    if(_zz_4) begin
      ways_0_tags[tagsWriteCmd_payload_address] <= _zz_31;
    end
  end

  always @ (*) begin
    _zz_18 = {_zz_36, _zz_35, _zz_34, _zz_33};
  end
  always @ (posedge clk) begin
    if(_zz_7) begin
      _zz_33 <= ways_0_data_symbol0[dataReadCmd_payload];
      _zz_34 <= ways_0_data_symbol1[dataReadCmd_payload];
      _zz_35 <= ways_0_data_symbol2[dataReadCmd_payload];
      _zz_36 <= ways_0_data_symbol3[dataReadCmd_payload];
    end
  end

  always @ (posedge clk) begin
    if(dataWriteCmd_payload_mask[0] && _zz_3) begin
      ways_0_data_symbol0[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[7 : 0];
    end
    if(dataWriteCmd_payload_mask[1] && _zz_3) begin
      ways_0_data_symbol1[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[15 : 8];
    end
    if(dataWriteCmd_payload_mask[2] && _zz_3) begin
      ways_0_data_symbol2[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[23 : 16];
    end
    if(dataWriteCmd_payload_mask[3] && _zz_3) begin
      ways_0_data_symbol3[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[31 : 24];
    end
  end

  always @ (posedge clk) begin
    if(_zz_8) begin
      _zz_19 <= ways_1_tags[tagsReadCmd_payload];
    end
  end

  always @ (posedge clk) begin
    if(_zz_2) begin
      ways_1_tags[tagsWriteCmd_payload_address] <= _zz_32;
    end
  end

  always @ (*) begin
    _zz_20 = {_zz_40, _zz_39, _zz_38, _zz_37};
  end
  always @ (posedge clk) begin
    if(_zz_10) begin
      _zz_37 <= ways_1_data_symbol0[dataReadCmd_payload];
      _zz_38 <= ways_1_data_symbol1[dataReadCmd_payload];
      _zz_39 <= ways_1_data_symbol2[dataReadCmd_payload];
      _zz_40 <= ways_1_data_symbol3[dataReadCmd_payload];
    end
  end

  always @ (posedge clk) begin
    if(dataWriteCmd_payload_mask[0] && _zz_1) begin
      ways_1_data_symbol0[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[7 : 0];
    end
    if(dataWriteCmd_payload_mask[1] && _zz_1) begin
      ways_1_data_symbol1[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[15 : 8];
    end
    if(dataWriteCmd_payload_mask[2] && _zz_1) begin
      ways_1_data_symbol2[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[23 : 16];
    end
    if(dataWriteCmd_payload_mask[3] && _zz_1) begin
      ways_1_data_symbol3[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[31 : 24];
    end
  end

  always @ (*) begin
    _zz_1 = 1'b0;
    if((dataWriteCmd_valid && dataWriteCmd_payload_way[1]))begin
      _zz_1 = 1'b1;
    end
  end

  always @ (*) begin
    _zz_2 = 1'b0;
    if((tagsWriteCmd_valid && tagsWriteCmd_payload_way[1]))begin
      _zz_2 = 1'b1;
    end
  end

  always @ (*) begin
    _zz_3 = 1'b0;
    if((dataWriteCmd_valid && dataWriteCmd_payload_way[0]))begin
      _zz_3 = 1'b1;
    end
  end

  always @ (*) begin
    _zz_4 = 1'b0;
    if((tagsWriteCmd_valid && tagsWriteCmd_payload_way[0]))begin
      _zz_4 = 1'b1;
    end
  end

  assign haltCpu = 1'b0;
  assign _zz_5 = (tagsReadCmd_valid && (! io_cpu_memory_isStuck));
  assign _zz_6 = _zz_17;
  assign ways_0_tagsReadRsp_valid = _zz_6[0];
  assign ways_0_tagsReadRsp_error = _zz_6[1];
  assign ways_0_tagsReadRsp_address = _zz_6[26 : 2];
  assign _zz_7 = (dataReadCmd_valid && (! io_cpu_memory_isStuck));
  assign ways_0_dataReadRspMem = _zz_18;
  assign ways_0_dataReadRsp = ways_0_dataReadRspMem[31 : 0];
  assign _zz_8 = (tagsReadCmd_valid && (! io_cpu_memory_isStuck));
  assign _zz_9 = _zz_19;
  assign ways_1_tagsReadRsp_valid = _zz_9[0];
  assign ways_1_tagsReadRsp_error = _zz_9[1];
  assign ways_1_tagsReadRsp_address = _zz_9[26 : 2];
  assign _zz_10 = (dataReadCmd_valid && (! io_cpu_memory_isStuck));
  assign ways_1_dataReadRspMem = _zz_20;
  assign ways_1_dataReadRsp = ways_1_dataReadRspMem[31 : 0];
  always @ (*) begin
    tagsReadCmd_valid = 1'b0;
    if(_zz_21)begin
      tagsReadCmd_valid = 1'b1;
    end
  end

  always @ (*) begin
    tagsReadCmd_payload = 3'bxxx;
    if(_zz_21)begin
      tagsReadCmd_payload = io_cpu_execute_address[6 : 4];
    end
  end

  always @ (*) begin
    dataReadCmd_valid = 1'b0;
    if(_zz_21)begin
      dataReadCmd_valid = 1'b1;
    end
  end

  always @ (*) begin
    dataReadCmd_payload = 5'bxxxxx;
    if(_zz_21)begin
      dataReadCmd_payload = io_cpu_execute_address[6 : 2];
    end
  end

  always @ (*) begin
    tagsWriteCmd_valid = 1'b0;
    if(_zz_22)begin
      tagsWriteCmd_valid = 1'b1;
    end
    if(_zz_23)begin
      tagsWriteCmd_valid = 1'b0;
    end
    if(loader_done)begin
      tagsWriteCmd_valid = 1'b1;
    end
  end

  always @ (*) begin
    tagsWriteCmd_payload_way = 2'bxx;
    if(_zz_22)begin
      tagsWriteCmd_payload_way = 2'b11;
    end
    if(loader_done)begin
      tagsWriteCmd_payload_way = loader_waysAllocator;
    end
  end

  always @ (*) begin
    tagsWriteCmd_payload_address = 3'bxxx;
    if(_zz_22)begin
      tagsWriteCmd_payload_address = stageB_flusher_counter[2:0];
    end
    if(loader_done)begin
      tagsWriteCmd_payload_address = stageB_mmuRsp_physicalAddress[6 : 4];
    end
  end

  always @ (*) begin
    tagsWriteCmd_payload_data_valid = 1'bx;
    if(_zz_22)begin
      tagsWriteCmd_payload_data_valid = 1'b0;
    end
    if(loader_done)begin
      tagsWriteCmd_payload_data_valid = (! (loader_kill || loader_killReg));
    end
  end

  always @ (*) begin
    tagsWriteCmd_payload_data_error = 1'bx;
    if(loader_done)begin
      tagsWriteCmd_payload_data_error = (loader_error || (io_mem_rsp_valid && io_mem_rsp_payload_error));
    end
  end

  always @ (*) begin
    tagsWriteCmd_payload_data_address = 25'bxxxxxxxxxxxxxxxxxxxxxxxxx;
    if(loader_done)begin
      tagsWriteCmd_payload_data_address = stageB_mmuRsp_physicalAddress[31 : 7];
    end
  end

  always @ (*) begin
    dataWriteCmd_valid = 1'b0;
    if(stageB_cpuWriteToCache)begin
      if((stageB_request_wr && stageB_waysHit))begin
        dataWriteCmd_valid = 1'b1;
      end
    end
    if(_zz_23)begin
      dataWriteCmd_valid = 1'b0;
    end
    if(_zz_24)begin
      dataWriteCmd_valid = 1'b1;
    end
  end

  always @ (*) begin
    dataWriteCmd_payload_way = 2'bxx;
    if(stageB_cpuWriteToCache)begin
      dataWriteCmd_payload_way = stageB_waysHits;
    end
    if(_zz_24)begin
      dataWriteCmd_payload_way = loader_waysAllocator;
    end
  end

  always @ (*) begin
    dataWriteCmd_payload_address = 5'bxxxxx;
    if(stageB_cpuWriteToCache)begin
      dataWriteCmd_payload_address = stageB_mmuRsp_physicalAddress[6 : 2];
    end
    if(_zz_24)begin
      dataWriteCmd_payload_address = {stageB_mmuRsp_physicalAddress[6 : 4],loader_counter_value};
    end
  end

  always @ (*) begin
    dataWriteCmd_payload_data = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
    if(stageB_cpuWriteToCache)begin
      dataWriteCmd_payload_data[31 : 0] = stageB_requestDataBypass;
    end
    if(_zz_24)begin
      dataWriteCmd_payload_data = io_mem_rsp_payload_data;
    end
  end

  always @ (*) begin
    dataWriteCmd_payload_mask = 4'bxxxx;
    if(stageB_cpuWriteToCache)begin
      dataWriteCmd_payload_mask = 4'b0000;
      if(_zz_27[0])begin
        dataWriteCmd_payload_mask[3 : 0] = stageB_mask;
      end
    end
    if(_zz_24)begin
      dataWriteCmd_payload_mask = 4'b1111;
    end
  end

  always @ (*) begin
    io_cpu_execute_haltIt = 1'b0;
    if(_zz_22)begin
      io_cpu_execute_haltIt = 1'b1;
    end
  end

  assign rspSync = 1'b1;
  assign rspLast = 1'b1;
  always @ (*) begin
    _zz_11 = 4'bxxxx;
    case(io_cpu_execute_args_size)
      2'b00 : begin
        _zz_11 = 4'b0001;
      end
      2'b01 : begin
        _zz_11 = 4'b0011;
      end
      2'b10 : begin
        _zz_11 = 4'b1111;
      end
      default : begin
      end
    endcase
  end

  assign stage0_mask = (_zz_11 <<< io_cpu_execute_address[1 : 0]);
  assign _zz_12 = (io_cpu_execute_address[6 : 2] >>> 0);
  assign _zz_13 = dataWriteCmd_payload_mask[3 : 0];
  always @ (*) begin
    stage0_dataColisions[0] = (((dataWriteCmd_valid && dataWriteCmd_payload_way[0]) && (dataWriteCmd_payload_address == _zz_12)) && ((stage0_mask & _zz_13) != 4'b0000));
    stage0_dataColisions[1] = (((dataWriteCmd_valid && dataWriteCmd_payload_way[1]) && (dataWriteCmd_payload_address == _zz_12)) && ((stage0_mask & _zz_13) != 4'b0000));
  end

  assign stage0_wayInvalidate = 2'b00;
  assign stage0_isAmo = 1'b0;
  assign io_cpu_memory_isWrite = stageA_request_wr;
  assign stageA_isAmo = 1'b0;
  assign stageA_isLrsc = 1'b0;
  assign stageA_wayHits = {((io_cpu_memory_mmuRsp_physicalAddress[31 : 7] == ways_1_tagsReadRsp_address) && ways_1_tagsReadRsp_valid),((io_cpu_memory_mmuRsp_physicalAddress[31 : 7] == ways_0_tagsReadRsp_address) && ways_0_tagsReadRsp_valid)};
  assign _zz_15 = (io_cpu_memory_address[6 : 2] >>> 0);
  assign _zz_16 = dataWriteCmd_payload_mask[3 : 0];
  always @ (*) begin
    _zz_14[0] = (((dataWriteCmd_valid && dataWriteCmd_payload_way[0]) && (dataWriteCmd_payload_address == _zz_15)) && ((stageA_mask & _zz_16) != 4'b0000));
    _zz_14[1] = (((dataWriteCmd_valid && dataWriteCmd_payload_way[1]) && (dataWriteCmd_payload_address == _zz_15)) && ((stageA_mask & _zz_16) != 4'b0000));
  end

  assign stageA_dataColisions = (stage0_dataColisions_regNextWhen | _zz_14);
  always @ (*) begin
    stageB_mmuRspFreeze = 1'b0;
    if((stageB_loaderValid || loader_valid))begin
      stageB_mmuRspFreeze = 1'b1;
    end
  end

  assign stageB_consistancyHazard = 1'b0;
  assign stageB_unaligned = 1'b0;
  assign stageB_waysHits = (stageB_waysHitsBeforeInvalidate & (~ stageB_wayInvalidate));
  assign stageB_waysHit = (stageB_waysHits != 2'b00);
  assign stageB_dataMux = (stageB_waysHits[0] ? stageB_dataReadRsp_0 : stageB_dataReadRsp_1);
  always @ (*) begin
    stageB_loaderValid = 1'b0;
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_isExternalAmo) begin
        if(! _zz_25) begin
          if(! _zz_26) begin
            if(io_mem_cmd_ready)begin
              stageB_loaderValid = 1'b1;
            end
          end
        end
      end
    end
    if(_zz_23)begin
      stageB_loaderValid = 1'b0;
    end
  end

  assign stageB_ioMemRspMuxed = io_mem_rsp_payload_data[31 : 0];
  always @ (*) begin
    io_cpu_writeBack_haltIt = 1'b1;
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_isExternalAmo) begin
        if(_zz_25)begin
          if(((! stageB_request_wr) ? (io_mem_rsp_valid && rspSync) : io_mem_cmd_ready))begin
            io_cpu_writeBack_haltIt = 1'b0;
          end
        end else begin
          if(_zz_26)begin
            if(((! stageB_request_wr) || io_mem_cmd_ready))begin
              io_cpu_writeBack_haltIt = 1'b0;
            end
          end
        end
      end
    end
    if(_zz_23)begin
      io_cpu_writeBack_haltIt = 1'b0;
    end
  end

  assign stageB_flusher_hold = 1'b0;
  assign io_cpu_flush_ready = (stageB_flusher_waitDone && stageB_flusher_counter[3]);
  assign stageB_isAmo = 1'b0;
  assign stageB_isAmoCached = 1'b0;
  assign stageB_isExternalLsrc = 1'b0;
  assign stageB_isExternalAmo = 1'b0;
  assign stageB_requestDataBypass = io_cpu_writeBack_storeData;
  always @ (*) begin
    stageB_cpuWriteToCache = 1'b0;
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_isExternalAmo) begin
        if(! _zz_25) begin
          if(_zz_26)begin
            stageB_cpuWriteToCache = 1'b1;
          end
        end
      end
    end
  end

  assign stageB_badPermissions = (((! stageB_mmuRsp_allowWrite) && stageB_request_wr) || ((! stageB_mmuRsp_allowRead) && ((! stageB_request_wr) || stageB_isAmo)));
  assign stageB_loadStoreFault = (io_cpu_writeBack_isValid && (stageB_mmuRsp_exception || stageB_badPermissions));
  always @ (*) begin
    io_cpu_redo = 1'b0;
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_isExternalAmo) begin
        if(! _zz_25) begin
          if(_zz_26)begin
            if((((! stageB_request_wr) || stageB_isAmoCached) && ((stageB_dataColisions & stageB_waysHits) != 2'b00)))begin
              io_cpu_redo = 1'b1;
            end
          end
        end
      end
    end
    if((io_cpu_writeBack_isValid && (stageB_mmuRsp_refilling || stageB_consistancyHazard)))begin
      io_cpu_redo = 1'b1;
    end
    if((loader_valid && (! loader_valid_regNext)))begin
      io_cpu_redo = 1'b1;
    end
  end

  assign io_cpu_writeBack_accessError = 1'b0;
  assign io_cpu_writeBack_mmuException = (stageB_loadStoreFault && 1'b0);
  assign io_cpu_writeBack_unalignedAccess = (io_cpu_writeBack_isValid && stageB_unaligned);
  assign io_cpu_writeBack_isWrite = stageB_request_wr;
  always @ (*) begin
    io_mem_cmd_valid = 1'b0;
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_isExternalAmo) begin
        if(_zz_25)begin
          io_mem_cmd_valid = (! memCmdSent);
        end else begin
          if(_zz_26)begin
            if(stageB_request_wr)begin
              io_mem_cmd_valid = 1'b1;
            end
          end else begin
            if((! memCmdSent))begin
              io_mem_cmd_valid = 1'b1;
            end
          end
        end
      end
    end
    if(_zz_23)begin
      io_mem_cmd_valid = 1'b0;
    end
  end

  always @ (*) begin
    io_mem_cmd_payload_address = stageB_mmuRsp_physicalAddress;
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_isExternalAmo) begin
        if(! _zz_25) begin
          if(! _zz_26) begin
            io_mem_cmd_payload_address[3 : 0] = 4'b0000;
          end
        end
      end
    end
  end

  assign io_mem_cmd_payload_last = 1'b1;
  always @ (*) begin
    io_mem_cmd_payload_wr = stageB_request_wr;
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_isExternalAmo) begin
        if(! _zz_25) begin
          if(! _zz_26) begin
            io_mem_cmd_payload_wr = 1'b0;
          end
        end
      end
    end
  end

  assign io_mem_cmd_payload_mask = stageB_mask;
  assign io_mem_cmd_payload_data = stageB_requestDataBypass;
  assign io_mem_cmd_payload_uncached = stageB_mmuRsp_isIoAccess;
  always @ (*) begin
    io_mem_cmd_payload_size = {1'd0, stageB_request_size};
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_isExternalAmo) begin
        if(! _zz_25) begin
          if(! _zz_26) begin
            io_mem_cmd_payload_size = 3'b100;
          end
        end
      end
    end
  end

  assign stageB_bypassCache = ((stageB_mmuRsp_isIoAccess || stageB_isExternalLsrc) || stageB_isExternalAmo);
  assign io_cpu_writeBack_keepMemRspData = 1'b0;
  always @ (*) begin
    if(stageB_bypassCache)begin
      io_cpu_writeBack_data = stageB_ioMemRspMuxed;
    end else begin
      io_cpu_writeBack_data = stageB_dataMux;
    end
  end

  always @ (*) begin
    loader_counter_willIncrement = 1'b0;
    if(_zz_24)begin
      loader_counter_willIncrement = 1'b1;
    end
  end

  assign loader_counter_willClear = 1'b0;
  assign loader_counter_willOverflowIfInc = (loader_counter_value == 2'b11);
  assign loader_counter_willOverflow = (loader_counter_willOverflowIfInc && loader_counter_willIncrement);
  always @ (*) begin
    loader_counter_valueNext = (loader_counter_value + _zz_29);
    if(loader_counter_willClear)begin
      loader_counter_valueNext = 2'b00;
    end
  end

  assign loader_kill = 1'b0;
  assign loader_done = loader_counter_willOverflow;
  assign io_cpu_execute_refilling = loader_valid;
  always @ (posedge clk) begin
    tagsWriteLastCmd_valid <= tagsWriteCmd_valid;
    tagsWriteLastCmd_payload_way <= tagsWriteCmd_payload_way;
    tagsWriteLastCmd_payload_address <= tagsWriteCmd_payload_address;
    tagsWriteLastCmd_payload_data_valid <= tagsWriteCmd_payload_data_valid;
    tagsWriteLastCmd_payload_data_error <= tagsWriteCmd_payload_data_error;
    tagsWriteLastCmd_payload_data_address <= tagsWriteCmd_payload_data_address;
    if((! io_cpu_memory_isStuck))begin
      stageA_request_wr <= io_cpu_execute_args_wr;
      stageA_request_size <= io_cpu_execute_args_size;
      stageA_request_totalyConsistent <= io_cpu_execute_args_totalyConsistent;
    end
    if((! io_cpu_memory_isStuck))begin
      stageA_mask <= stage0_mask;
    end
    if((! io_cpu_memory_isStuck))begin
      stageA_wayInvalidate <= stage0_wayInvalidate;
    end
    if((! io_cpu_memory_isStuck))begin
      stage0_dataColisions_regNextWhen <= stage0_dataColisions;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_request_wr <= stageA_request_wr;
      stageB_request_size <= stageA_request_size;
      stageB_request_totalyConsistent <= stageA_request_totalyConsistent;
    end
    if(((! io_cpu_writeBack_isStuck) && (! stageB_mmuRspFreeze)))begin
      stageB_mmuRsp_physicalAddress <= io_cpu_memory_mmuRsp_physicalAddress;
      stageB_mmuRsp_isIoAccess <= io_cpu_memory_mmuRsp_isIoAccess;
      stageB_mmuRsp_isPaging <= io_cpu_memory_mmuRsp_isPaging;
      stageB_mmuRsp_allowRead <= io_cpu_memory_mmuRsp_allowRead;
      stageB_mmuRsp_allowWrite <= io_cpu_memory_mmuRsp_allowWrite;
      stageB_mmuRsp_allowExecute <= io_cpu_memory_mmuRsp_allowExecute;
      stageB_mmuRsp_exception <= io_cpu_memory_mmuRsp_exception;
      stageB_mmuRsp_refilling <= io_cpu_memory_mmuRsp_refilling;
      stageB_mmuRsp_bypassTranslation <= io_cpu_memory_mmuRsp_bypassTranslation;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_tagsReadRsp_0_valid <= ways_0_tagsReadRsp_valid;
      stageB_tagsReadRsp_0_error <= ways_0_tagsReadRsp_error;
      stageB_tagsReadRsp_0_address <= ways_0_tagsReadRsp_address;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_tagsReadRsp_1_valid <= ways_1_tagsReadRsp_valid;
      stageB_tagsReadRsp_1_error <= ways_1_tagsReadRsp_error;
      stageB_tagsReadRsp_1_address <= ways_1_tagsReadRsp_address;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_dataReadRsp_0 <= ways_0_dataReadRsp;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_dataReadRsp_1 <= ways_1_dataReadRsp;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_wayInvalidate <= stageA_wayInvalidate;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_dataColisions <= stageA_dataColisions;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_waysHitsBeforeInvalidate <= stageA_wayHits;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_mask <= stageA_mask;
    end
    loader_valid_regNext <= loader_valid;
  end

  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      memCmdSent <= 1'b0;
      stageB_flusher_waitDone <= 1'b0;
      stageB_flusher_counter <= 4'b0000;
      stageB_flusher_start <= 1'b1;
      loader_valid <= 1'b0;
      loader_counter_value <= 2'b00;
      loader_waysAllocator <= 2'b01;
      loader_error <= 1'b0;
      loader_killReg <= 1'b0;
    end else begin
      if((io_mem_cmd_valid && io_mem_cmd_ready))begin
        memCmdSent <= 1'b1;
      end
      if((! io_cpu_writeBack_isStuck))begin
        memCmdSent <= 1'b0;
      end
      if(io_cpu_flush_ready)begin
        stageB_flusher_waitDone <= 1'b0;
      end
      if(_zz_22)begin
        if((! stageB_flusher_hold))begin
          stageB_flusher_counter <= (stageB_flusher_counter + 4'b0001);
        end
      end
      stageB_flusher_start <= (((((((! stageB_flusher_waitDone) && (! stageB_flusher_start)) && io_cpu_flush_valid) && (! io_cpu_execute_isValid)) && (! io_cpu_memory_isValid)) && (! io_cpu_writeBack_isValid)) && (! io_cpu_redo));
      if(stageB_flusher_start)begin
        stageB_flusher_waitDone <= 1'b1;
        stageB_flusher_counter <= 4'b0000;
      end
      `ifndef SYNTHESIS
        `ifdef FORMAL
          assert((! ((io_cpu_writeBack_isValid && (! io_cpu_writeBack_haltIt)) && io_cpu_writeBack_isStuck)));
        `else
          if(!(! ((io_cpu_writeBack_isValid && (! io_cpu_writeBack_haltIt)) && io_cpu_writeBack_isStuck))) begin
            $display("ERROR writeBack stuck by another plugin is not allowed");
          end
        `endif
      `endif
      if(stageB_loaderValid)begin
        loader_valid <= 1'b1;
      end
      loader_counter_value <= loader_counter_valueNext;
      if(loader_kill)begin
        loader_killReg <= 1'b1;
      end
      if(_zz_24)begin
        loader_error <= (loader_error || io_mem_rsp_payload_error);
      end
      if(loader_done)begin
        loader_valid <= 1'b0;
        loader_error <= 1'b0;
        loader_killReg <= 1'b0;
      end
      if((! loader_valid))begin
        loader_waysAllocator <= _zz_30[1:0];
      end
    end
  end


endmodule

module InstructionCache (
  input               io_flush,
  input               io_cpu_prefetch_isValid,
  output reg          io_cpu_prefetch_haltIt,
  input      [31:0]   io_cpu_prefetch_pc,
  input               io_cpu_fetch_isValid,
  input               io_cpu_fetch_isStuck,
  input               io_cpu_fetch_isRemoved,
  input      [31:0]   io_cpu_fetch_pc,
  output     [31:0]   io_cpu_fetch_data,
  input      [31:0]   io_cpu_fetch_mmuRsp_physicalAddress,
  input               io_cpu_fetch_mmuRsp_isIoAccess,
  input               io_cpu_fetch_mmuRsp_isPaging,
  input               io_cpu_fetch_mmuRsp_allowRead,
  input               io_cpu_fetch_mmuRsp_allowWrite,
  input               io_cpu_fetch_mmuRsp_allowExecute,
  input               io_cpu_fetch_mmuRsp_exception,
  input               io_cpu_fetch_mmuRsp_refilling,
  input               io_cpu_fetch_mmuRsp_bypassTranslation,
  output     [31:0]   io_cpu_fetch_physicalAddress,
  input               io_cpu_decode_isValid,
  input               io_cpu_decode_isStuck,
  input      [31:0]   io_cpu_decode_pc,
  output     [31:0]   io_cpu_decode_physicalAddress,
  output     [31:0]   io_cpu_decode_data,
  output              io_cpu_decode_cacheMiss,
  output              io_cpu_decode_error,
  output              io_cpu_decode_mmuRefilling,
  output              io_cpu_decode_mmuException,
  input               io_cpu_decode_isUser,
  input               io_cpu_fill_valid,
  input      [31:0]   io_cpu_fill_payload,
  output              io_mem_cmd_valid,
  input               io_mem_cmd_ready,
  output     [31:0]   io_mem_cmd_payload_address,
  output     [2:0]    io_mem_cmd_payload_size,
  input               io_mem_rsp_valid,
  input      [31:0]   io_mem_rsp_payload_data,
  input               io_mem_rsp_payload_error,
  input               clk,
  input               reset
);
  reg        [31:0]   _zz_9;
  reg        [26:0]   _zz_10;
  wire                _zz_11;
  wire                _zz_12;
  wire       [26:0]   _zz_13;
  reg                 _zz_1;
  reg                 _zz_2;
  reg                 lineLoader_fire;
  reg                 lineLoader_valid;
  (* keep , syn_keep *) reg        [31:0]   lineLoader_address /* synthesis syn_keep = 1 */ ;
  reg                 lineLoader_hadError;
  reg                 lineLoader_flushPending;
  reg        [3:0]    lineLoader_flushCounter;
  reg                 _zz_3;
  reg                 lineLoader_cmdSent;
  reg                 lineLoader_wayToAllocate_willIncrement;
  wire                lineLoader_wayToAllocate_willClear;
  wire                lineLoader_wayToAllocate_willOverflowIfInc;
  wire                lineLoader_wayToAllocate_willOverflow;
  (* keep , syn_keep *) reg        [1:0]    lineLoader_wordIndex /* synthesis syn_keep = 1 */ ;
  wire                lineLoader_write_tag_0_valid;
  wire       [2:0]    lineLoader_write_tag_0_payload_address;
  wire                lineLoader_write_tag_0_payload_data_valid;
  wire                lineLoader_write_tag_0_payload_data_error;
  wire       [24:0]   lineLoader_write_tag_0_payload_data_address;
  wire                lineLoader_write_data_0_valid;
  wire       [4:0]    lineLoader_write_data_0_payload_address;
  wire       [31:0]   lineLoader_write_data_0_payload_data;
  wire       [4:0]    _zz_4;
  wire                _zz_5;
  wire       [31:0]   fetchStage_read_banksValue_0_dataMem;
  wire       [31:0]   fetchStage_read_banksValue_0_data;
  wire       [2:0]    _zz_6;
  wire                _zz_7;
  wire                fetchStage_read_waysValues_0_tag_valid;
  wire                fetchStage_read_waysValues_0_tag_error;
  wire       [24:0]   fetchStage_read_waysValues_0_tag_address;
  wire       [26:0]   _zz_8;
  wire                fetchStage_hit_hits_0;
  wire                fetchStage_hit_valid;
  wire                fetchStage_hit_error;
  wire       [31:0]   fetchStage_hit_data;
  wire       [31:0]   fetchStage_hit_word;
  reg        [31:0]   io_cpu_fetch_data_regNextWhen;
  reg        [31:0]   decodeStage_mmuRsp_physicalAddress;
  reg                 decodeStage_mmuRsp_isIoAccess;
  reg                 decodeStage_mmuRsp_isPaging;
  reg                 decodeStage_mmuRsp_allowRead;
  reg                 decodeStage_mmuRsp_allowWrite;
  reg                 decodeStage_mmuRsp_allowExecute;
  reg                 decodeStage_mmuRsp_exception;
  reg                 decodeStage_mmuRsp_refilling;
  reg                 decodeStage_mmuRsp_bypassTranslation;
  reg                 decodeStage_hit_valid;
  reg                 decodeStage_hit_error;
  reg [31:0] banks_0 [0:31];
  reg [26:0] ways_0_tags [0:7];

  assign _zz_11 = (! lineLoader_flushCounter[3]);
  assign _zz_12 = (lineLoader_flushPending && (! (lineLoader_valid || io_cpu_fetch_isValid)));
  assign _zz_13 = {lineLoader_write_tag_0_payload_data_address,{lineLoader_write_tag_0_payload_data_error,lineLoader_write_tag_0_payload_data_valid}};
  always @ (posedge clk) begin
    if(_zz_1) begin
      banks_0[lineLoader_write_data_0_payload_address] <= lineLoader_write_data_0_payload_data;
    end
  end

  always @ (posedge clk) begin
    if(_zz_5) begin
      _zz_9 <= banks_0[_zz_4];
    end
  end

  always @ (posedge clk) begin
    if(_zz_2) begin
      ways_0_tags[lineLoader_write_tag_0_payload_address] <= _zz_13;
    end
  end

  always @ (posedge clk) begin
    if(_zz_7) begin
      _zz_10 <= ways_0_tags[_zz_6];
    end
  end

  always @ (*) begin
    _zz_1 = 1'b0;
    if(lineLoader_write_data_0_valid)begin
      _zz_1 = 1'b1;
    end
  end

  always @ (*) begin
    _zz_2 = 1'b0;
    if(lineLoader_write_tag_0_valid)begin
      _zz_2 = 1'b1;
    end
  end

  always @ (*) begin
    lineLoader_fire = 1'b0;
    if(io_mem_rsp_valid)begin
      if((lineLoader_wordIndex == 2'b11))begin
        lineLoader_fire = 1'b1;
      end
    end
  end

  always @ (*) begin
    io_cpu_prefetch_haltIt = (lineLoader_valid || lineLoader_flushPending);
    if(_zz_11)begin
      io_cpu_prefetch_haltIt = 1'b1;
    end
    if((! _zz_3))begin
      io_cpu_prefetch_haltIt = 1'b1;
    end
    if(io_flush)begin
      io_cpu_prefetch_haltIt = 1'b1;
    end
  end

  assign io_mem_cmd_valid = (lineLoader_valid && (! lineLoader_cmdSent));
  assign io_mem_cmd_payload_address = {lineLoader_address[31 : 4],4'b0000};
  assign io_mem_cmd_payload_size = 3'b100;
  always @ (*) begin
    lineLoader_wayToAllocate_willIncrement = 1'b0;
    if((! lineLoader_valid))begin
      lineLoader_wayToAllocate_willIncrement = 1'b1;
    end
  end

  assign lineLoader_wayToAllocate_willClear = 1'b0;
  assign lineLoader_wayToAllocate_willOverflowIfInc = 1'b1;
  assign lineLoader_wayToAllocate_willOverflow = (lineLoader_wayToAllocate_willOverflowIfInc && lineLoader_wayToAllocate_willIncrement);
  assign lineLoader_write_tag_0_valid = ((1'b1 && lineLoader_fire) || (! lineLoader_flushCounter[3]));
  assign lineLoader_write_tag_0_payload_address = (lineLoader_flushCounter[3] ? lineLoader_address[6 : 4] : lineLoader_flushCounter[2 : 0]);
  assign lineLoader_write_tag_0_payload_data_valid = lineLoader_flushCounter[3];
  assign lineLoader_write_tag_0_payload_data_error = (lineLoader_hadError || io_mem_rsp_payload_error);
  assign lineLoader_write_tag_0_payload_data_address = lineLoader_address[31 : 7];
  assign lineLoader_write_data_0_valid = (io_mem_rsp_valid && 1'b1);
  assign lineLoader_write_data_0_payload_address = {lineLoader_address[6 : 4],lineLoader_wordIndex};
  assign lineLoader_write_data_0_payload_data = io_mem_rsp_payload_data;
  assign _zz_4 = io_cpu_prefetch_pc[6 : 2];
  assign _zz_5 = (! io_cpu_fetch_isStuck);
  assign fetchStage_read_banksValue_0_dataMem = _zz_9;
  assign fetchStage_read_banksValue_0_data = fetchStage_read_banksValue_0_dataMem[31 : 0];
  assign _zz_6 = io_cpu_prefetch_pc[6 : 4];
  assign _zz_7 = (! io_cpu_fetch_isStuck);
  assign _zz_8 = _zz_10;
  assign fetchStage_read_waysValues_0_tag_valid = _zz_8[0];
  assign fetchStage_read_waysValues_0_tag_error = _zz_8[1];
  assign fetchStage_read_waysValues_0_tag_address = _zz_8[26 : 2];
  assign fetchStage_hit_hits_0 = (fetchStage_read_waysValues_0_tag_valid && (fetchStage_read_waysValues_0_tag_address == io_cpu_fetch_mmuRsp_physicalAddress[31 : 7]));
  assign fetchStage_hit_valid = (fetchStage_hit_hits_0 != 1'b0);
  assign fetchStage_hit_error = fetchStage_read_waysValues_0_tag_error;
  assign fetchStage_hit_data = fetchStage_read_banksValue_0_data;
  assign fetchStage_hit_word = fetchStage_hit_data;
  assign io_cpu_fetch_data = fetchStage_hit_word;
  assign io_cpu_decode_data = io_cpu_fetch_data_regNextWhen;
  assign io_cpu_fetch_physicalAddress = io_cpu_fetch_mmuRsp_physicalAddress;
  assign io_cpu_decode_cacheMiss = (! decodeStage_hit_valid);
  assign io_cpu_decode_error = (decodeStage_hit_error || ((! decodeStage_mmuRsp_isPaging) && (decodeStage_mmuRsp_exception || (! decodeStage_mmuRsp_allowExecute))));
  assign io_cpu_decode_mmuRefilling = decodeStage_mmuRsp_refilling;
  assign io_cpu_decode_mmuException = (((! decodeStage_mmuRsp_refilling) && decodeStage_mmuRsp_isPaging) && (decodeStage_mmuRsp_exception || (! decodeStage_mmuRsp_allowExecute)));
  assign io_cpu_decode_physicalAddress = decodeStage_mmuRsp_physicalAddress;
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      lineLoader_valid <= 1'b0;
      lineLoader_hadError <= 1'b0;
      lineLoader_flushPending <= 1'b1;
      lineLoader_cmdSent <= 1'b0;
      lineLoader_wordIndex <= 2'b00;
    end else begin
      if(lineLoader_fire)begin
        lineLoader_valid <= 1'b0;
      end
      if(lineLoader_fire)begin
        lineLoader_hadError <= 1'b0;
      end
      if(io_cpu_fill_valid)begin
        lineLoader_valid <= 1'b1;
      end
      if(io_flush)begin
        lineLoader_flushPending <= 1'b1;
      end
      if(_zz_12)begin
        lineLoader_flushPending <= 1'b0;
      end
      if((io_mem_cmd_valid && io_mem_cmd_ready))begin
        lineLoader_cmdSent <= 1'b1;
      end
      if(lineLoader_fire)begin
        lineLoader_cmdSent <= 1'b0;
      end
      if(io_mem_rsp_valid)begin
        lineLoader_wordIndex <= (lineLoader_wordIndex + 2'b01);
        if(io_mem_rsp_payload_error)begin
          lineLoader_hadError <= 1'b1;
        end
      end
    end
  end

  always @ (posedge clk) begin
    if(io_cpu_fill_valid)begin
      lineLoader_address <= io_cpu_fill_payload;
    end
    if(_zz_11)begin
      lineLoader_flushCounter <= (lineLoader_flushCounter + 4'b0001);
    end
    _zz_3 <= lineLoader_flushCounter[3];
    if(_zz_12)begin
      lineLoader_flushCounter <= 4'b0000;
    end
    if((! io_cpu_decode_isStuck))begin
      io_cpu_fetch_data_regNextWhen <= io_cpu_fetch_data;
    end
    if((! io_cpu_decode_isStuck))begin
      decodeStage_mmuRsp_physicalAddress <= io_cpu_fetch_mmuRsp_physicalAddress;
      decodeStage_mmuRsp_isIoAccess <= io_cpu_fetch_mmuRsp_isIoAccess;
      decodeStage_mmuRsp_isPaging <= io_cpu_fetch_mmuRsp_isPaging;
      decodeStage_mmuRsp_allowRead <= io_cpu_fetch_mmuRsp_allowRead;
      decodeStage_mmuRsp_allowWrite <= io_cpu_fetch_mmuRsp_allowWrite;
      decodeStage_mmuRsp_allowExecute <= io_cpu_fetch_mmuRsp_allowExecute;
      decodeStage_mmuRsp_exception <= io_cpu_fetch_mmuRsp_exception;
      decodeStage_mmuRsp_refilling <= io_cpu_fetch_mmuRsp_refilling;
      decodeStage_mmuRsp_bypassTranslation <= io_cpu_fetch_mmuRsp_bypassTranslation;
    end
    if((! io_cpu_decode_isStuck))begin
      decodeStage_hit_valid <= fetchStage_hit_valid;
    end
    if((! io_cpu_decode_isStuck))begin
      decodeStage_hit_error <= fetchStage_hit_error;
    end
  end


endmodule
