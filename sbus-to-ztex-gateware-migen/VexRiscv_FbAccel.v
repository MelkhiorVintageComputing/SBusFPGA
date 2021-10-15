// Generator : SpinalHDL v1.4.4    git head : 86bb53d7c015114a265f345ebe5da1eb68d1e828
// Component : VexRiscv
// Git hash  : 24adc7db89135956d4ef289611665b7a4ed40e1c


`define BranchCtrlEnum_defaultEncoding_type [1:0]
`define BranchCtrlEnum_defaultEncoding_INC 2'b00
`define BranchCtrlEnum_defaultEncoding_B 2'b01
`define BranchCtrlEnum_defaultEncoding_JAL 2'b10
`define BranchCtrlEnum_defaultEncoding_JALR 2'b11

`define BitManipZbbCtrlsignextendEnum_defaultEncoding_type [1:0]
`define BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotB 2'b00
`define BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotH 2'b01
`define BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_ZEXTdotH 2'b10

`define BitManipZbbCtrlcountzeroesEnum_defaultEncoding_type [0:0]
`define BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CLTZ 1'b0
`define BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CPOP 1'b1

`define BitManipZbbCtrlminmaxEnum_defaultEncoding_type [1:0]
`define BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAX 2'b00
`define BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAXU 2'b01
`define BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MIN 2'b10
`define BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MINU 2'b11

`define BitManipZbbCtrlrotationEnum_defaultEncoding_type [0:0]
`define BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROL 1'b0
`define BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROR 1'b1

`define BitManipZbbCtrlbitwiseEnum_defaultEncoding_type [1:0]
`define BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ANDN 2'b00
`define BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ORN 2'b01
`define BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_XNOR 2'b10

`define BitManipZbbCtrlgrevorcEnum_defaultEncoding_type [0:0]
`define BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_ORCdotB 1'b0
`define BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_REV8 1'b1

`define BitManipZbbCtrlEnum_defaultEncoding_type [2:0]
`define BitManipZbbCtrlEnum_defaultEncoding_CTRL_grevorc 3'b000
`define BitManipZbbCtrlEnum_defaultEncoding_CTRL_bitwise 3'b001
`define BitManipZbbCtrlEnum_defaultEncoding_CTRL_rotation 3'b010
`define BitManipZbbCtrlEnum_defaultEncoding_CTRL_minmax 3'b011
`define BitManipZbbCtrlEnum_defaultEncoding_CTRL_countzeroes 3'b100
`define BitManipZbbCtrlEnum_defaultEncoding_CTRL_signextend 3'b101

`define BitManipZbaCtrlsh_addEnum_defaultEncoding_type [1:0]
`define BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH1ADD 2'b00
`define BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH2ADD 2'b01
`define BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH3ADD 2'b10

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
  wire                _zz_252;
  wire                _zz_253;
  wire                _zz_254;
  wire                _zz_255;
  wire                _zz_256;
  wire                _zz_257;
  wire                _zz_258;
  wire                _zz_259;
  reg                 _zz_260;
  wire                _zz_261;
  wire       [31:0]   _zz_262;
  wire                _zz_263;
  wire       [31:0]   _zz_264;
  reg                 _zz_265;
  reg                 _zz_266;
  wire                _zz_267;
  wire       [31:0]   _zz_268;
  wire       [31:0]   _zz_269;
  wire                _zz_270;
  wire                _zz_271;
  wire                _zz_272;
  wire                _zz_273;
  wire                _zz_274;
  wire                _zz_275;
  wire                _zz_276;
  wire                _zz_277;
  wire       [3:0]    _zz_278;
  wire                _zz_279;
  reg        [31:0]   _zz_280;
  reg        [31:0]   _zz_281;
  reg        [31:0]   _zz_282;
  reg        [31:0]   _zz_283;
  reg        [7:0]    _zz_284;
  reg        [7:0]    _zz_285;
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
  wire                _zz_286;
  wire                _zz_287;
  wire                _zz_288;
  wire                _zz_289;
  wire                _zz_290;
  wire                _zz_291;
  wire                _zz_292;
  wire                _zz_293;
  wire                _zz_294;
  wire                _zz_295;
  wire                _zz_296;
  wire                _zz_297;
  wire                _zz_298;
  wire                _zz_299;
  wire                _zz_300;
  wire                _zz_301;
  wire                _zz_302;
  wire       [1:0]    _zz_303;
  wire       [2:0]    _zz_304;
  wire       [32:0]   _zz_305;
  wire       [31:0]   _zz_306;
  wire       [32:0]   _zz_307;
  wire       [2:0]    _zz_308;
  wire       [2:0]    _zz_309;
  wire       [31:0]   _zz_310;
  wire       [11:0]   _zz_311;
  wire       [31:0]   _zz_312;
  wire       [19:0]   _zz_313;
  wire       [11:0]   _zz_314;
  wire       [31:0]   _zz_315;
  wire       [31:0]   _zz_316;
  wire       [19:0]   _zz_317;
  wire       [11:0]   _zz_318;
  wire       [0:0]    _zz_319;
  wire       [2:0]    _zz_320;
  wire       [4:0]    _zz_321;
  wire       [11:0]   _zz_322;
  wire       [31:0]   _zz_323;
  wire       [31:0]   _zz_324;
  wire       [31:0]   _zz_325;
  wire       [31:0]   _zz_326;
  wire       [31:0]   _zz_327;
  wire       [31:0]   _zz_328;
  wire       [31:0]   _zz_329;
  wire       [31:0]   _zz_330;
  wire       [31:0]   _zz_331;
  wire       [31:0]   _zz_332;
  wire       [31:0]   _zz_333;
  wire       [31:0]   _zz_334;
  wire       [31:0]   _zz_335;
  wire       [31:0]   _zz_336;
  wire       [31:0]   _zz_337;
  wire       [31:0]   _zz_338;
  wire       [31:0]   _zz_339;
  wire       [31:0]   _zz_340;
  wire       [31:0]   _zz_341;
  wire       [31:0]   _zz_342;
  wire       [31:0]   _zz_343;
  wire       [31:0]   _zz_344;
  wire       [31:0]   _zz_345;
  wire       [31:0]   _zz_346;
  wire       [31:0]   _zz_347;
  wire       [5:0]    _zz_348;
  wire       [5:0]    _zz_349;
  wire       [5:0]    _zz_350;
  wire       [5:0]    _zz_351;
  wire       [5:0]    _zz_352;
  wire       [5:0]    _zz_353;
  wire       [5:0]    _zz_354;
  wire       [5:0]    _zz_355;
  wire       [5:0]    _zz_356;
  wire       [5:0]    _zz_357;
  wire       [5:0]    _zz_358;
  wire       [5:0]    _zz_359;
  wire       [5:0]    _zz_360;
  wire       [5:0]    _zz_361;
  wire       [5:0]    _zz_362;
  wire       [5:0]    _zz_363;
  wire       [5:0]    _zz_364;
  wire       [5:0]    _zz_365;
  wire       [5:0]    _zz_366;
  wire       [5:0]    _zz_367;
  wire       [5:0]    _zz_368;
  wire       [5:0]    _zz_369;
  wire       [5:0]    _zz_370;
  wire       [5:0]    _zz_371;
  wire       [5:0]    _zz_372;
  wire       [5:0]    _zz_373;
  wire       [5:0]    _zz_374;
  wire       [5:0]    _zz_375;
  wire       [5:0]    _zz_376;
  wire       [5:0]    _zz_377;
  wire       [5:0]    _zz_378;
  wire       [5:0]    _zz_379;
  wire       [5:0]    _zz_380;
  wire       [0:0]    _zz_381;
  wire       [5:0]    _zz_382;
  wire       [0:0]    _zz_383;
  wire       [5:0]    _zz_384;
  wire       [0:0]    _zz_385;
  wire       [5:0]    _zz_386;
  wire       [0:0]    _zz_387;
  wire       [5:0]    _zz_388;
  wire       [0:0]    _zz_389;
  wire       [5:0]    _zz_390;
  wire       [0:0]    _zz_391;
  wire       [5:0]    _zz_392;
  wire       [0:0]    _zz_393;
  wire       [5:0]    _zz_394;
  wire       [0:0]    _zz_395;
  wire       [5:0]    _zz_396;
  wire       [0:0]    _zz_397;
  wire       [5:0]    _zz_398;
  wire       [0:0]    _zz_399;
  wire       [5:0]    _zz_400;
  wire       [0:0]    _zz_401;
  wire       [5:0]    _zz_402;
  wire       [0:0]    _zz_403;
  wire       [5:0]    _zz_404;
  wire       [0:0]    _zz_405;
  wire       [5:0]    _zz_406;
  wire       [0:0]    _zz_407;
  wire       [5:0]    _zz_408;
  wire       [0:0]    _zz_409;
  wire       [5:0]    _zz_410;
  wire       [0:0]    _zz_411;
  wire       [5:0]    _zz_412;
  wire       [0:0]    _zz_413;
  wire       [5:0]    _zz_414;
  wire       [0:0]    _zz_415;
  wire       [5:0]    _zz_416;
  wire       [0:0]    _zz_417;
  wire       [5:0]    _zz_418;
  wire       [0:0]    _zz_419;
  wire       [5:0]    _zz_420;
  wire       [0:0]    _zz_421;
  wire       [5:0]    _zz_422;
  wire       [0:0]    _zz_423;
  wire       [5:0]    _zz_424;
  wire       [0:0]    _zz_425;
  wire       [5:0]    _zz_426;
  wire       [0:0]    _zz_427;
  wire       [5:0]    _zz_428;
  wire       [0:0]    _zz_429;
  wire       [5:0]    _zz_430;
  wire       [0:0]    _zz_431;
  wire       [5:0]    _zz_432;
  wire       [0:0]    _zz_433;
  wire       [5:0]    _zz_434;
  wire       [0:0]    _zz_435;
  wire       [5:0]    _zz_436;
  wire       [0:0]    _zz_437;
  wire       [5:0]    _zz_438;
  wire       [0:0]    _zz_439;
  wire       [5:0]    _zz_440;
  wire       [0:0]    _zz_441;
  wire       [5:0]    _zz_442;
  wire       [0:0]    _zz_443;
  wire       [5:0]    _zz_444;
  wire       [19:0]   _zz_445;
  wire       [11:0]   _zz_446;
  wire       [31:0]   _zz_447;
  wire       [31:0]   _zz_448;
  wire       [31:0]   _zz_449;
  wire       [19:0]   _zz_450;
  wire       [11:0]   _zz_451;
  wire       [2:0]    _zz_452;
  wire       [27:0]   _zz_453;
  wire                _zz_454;
  wire                _zz_455;
  wire                _zz_456;
  wire       [1:0]    _zz_457;
  wire       [1:0]    _zz_458;
  wire       [0:0]    _zz_459;
  wire                _zz_460;
  wire                _zz_461;
  wire                _zz_462;
  wire                _zz_463;
  wire                _zz_464;
  wire       [0:0]    _zz_465;
  wire       [0:0]    _zz_466;
  wire                _zz_467;
  wire       [0:0]    _zz_468;
  wire       [36:0]   _zz_469;
  wire       [31:0]   _zz_470;
  wire       [31:0]   _zz_471;
  wire       [31:0]   _zz_472;
  wire                _zz_473;
  wire       [0:0]    _zz_474;
  wire       [0:0]    _zz_475;
  wire                _zz_476;
  wire       [0:0]    _zz_477;
  wire       [32:0]   _zz_478;
  wire       [31:0]   _zz_479;
  wire       [0:0]    _zz_480;
  wire       [0:0]    _zz_481;
  wire                _zz_482;
  wire       [0:0]    _zz_483;
  wire       [27:0]   _zz_484;
  wire       [31:0]   _zz_485;
  wire       [31:0]   _zz_486;
  wire       [31:0]   _zz_487;
  wire       [31:0]   _zz_488;
  wire                _zz_489;
  wire       [0:0]    _zz_490;
  wire       [0:0]    _zz_491;
  wire       [0:0]    _zz_492;
  wire       [0:0]    _zz_493;
  wire       [3:0]    _zz_494;
  wire       [3:0]    _zz_495;
  wire                _zz_496;
  wire       [0:0]    _zz_497;
  wire       [23:0]   _zz_498;
  wire       [31:0]   _zz_499;
  wire       [31:0]   _zz_500;
  wire       [31:0]   _zz_501;
  wire       [31:0]   _zz_502;
  wire       [31:0]   _zz_503;
  wire       [31:0]   _zz_504;
  wire       [31:0]   _zz_505;
  wire       [31:0]   _zz_506;
  wire       [31:0]   _zz_507;
  wire                _zz_508;
  wire       [0:0]    _zz_509;
  wire       [1:0]    _zz_510;
  wire                _zz_511;
  wire       [0:0]    _zz_512;
  wire       [0:0]    _zz_513;
  wire                _zz_514;
  wire       [0:0]    _zz_515;
  wire       [21:0]   _zz_516;
  wire       [31:0]   _zz_517;
  wire       [31:0]   _zz_518;
  wire       [31:0]   _zz_519;
  wire       [31:0]   _zz_520;
  wire       [31:0]   _zz_521;
  wire       [31:0]   _zz_522;
  wire       [31:0]   _zz_523;
  wire                _zz_524;
  wire       [1:0]    _zz_525;
  wire       [1:0]    _zz_526;
  wire                _zz_527;
  wire       [0:0]    _zz_528;
  wire       [18:0]   _zz_529;
  wire       [31:0]   _zz_530;
  wire       [31:0]   _zz_531;
  wire       [31:0]   _zz_532;
  wire       [31:0]   _zz_533;
  wire       [31:0]   _zz_534;
  wire       [31:0]   _zz_535;
  wire       [0:0]    _zz_536;
  wire       [0:0]    _zz_537;
  wire                _zz_538;
  wire       [0:0]    _zz_539;
  wire       [15:0]   _zz_540;
  wire       [31:0]   _zz_541;
  wire       [31:0]   _zz_542;
  wire       [31:0]   _zz_543;
  wire       [31:0]   _zz_544;
  wire       [0:0]    _zz_545;
  wire       [2:0]    _zz_546;
  wire       [0:0]    _zz_547;
  wire       [0:0]    _zz_548;
  wire                _zz_549;
  wire       [0:0]    _zz_550;
  wire       [10:0]   _zz_551;
  wire       [31:0]   _zz_552;
  wire       [31:0]   _zz_553;
  wire                _zz_554;
  wire       [31:0]   _zz_555;
  wire       [0:0]    _zz_556;
  wire       [4:0]    _zz_557;
  wire       [3:0]    _zz_558;
  wire       [3:0]    _zz_559;
  wire                _zz_560;
  wire       [0:0]    _zz_561;
  wire       [7:0]    _zz_562;
  wire       [31:0]   _zz_563;
  wire       [31:0]   _zz_564;
  wire                _zz_565;
  wire       [0:0]    _zz_566;
  wire       [1:0]    _zz_567;
  wire       [0:0]    _zz_568;
  wire       [0:0]    _zz_569;
  wire       [0:0]    _zz_570;
  wire       [0:0]    _zz_571;
  wire       [0:0]    _zz_572;
  wire       [0:0]    _zz_573;
  wire                _zz_574;
  wire       [0:0]    _zz_575;
  wire       [4:0]    _zz_576;
  wire       [31:0]   _zz_577;
  wire       [31:0]   _zz_578;
  wire       [31:0]   _zz_579;
  wire                _zz_580;
  wire                _zz_581;
  wire       [31:0]   _zz_582;
  wire       [31:0]   _zz_583;
  wire       [31:0]   _zz_584;
  wire       [31:0]   _zz_585;
  wire       [31:0]   _zz_586;
  wire       [31:0]   _zz_587;
  wire       [31:0]   _zz_588;
  wire       [31:0]   _zz_589;
  wire                _zz_590;
  wire       [1:0]    _zz_591;
  wire       [1:0]    _zz_592;
  wire                _zz_593;
  wire       [0:0]    _zz_594;
  wire       [2:0]    _zz_595;
  wire       [31:0]   _zz_596;
  wire       [31:0]   _zz_597;
  wire       [31:0]   _zz_598;
  wire       [31:0]   _zz_599;
  wire       [31:0]   _zz_600;
  wire       [31:0]   _zz_601;
  wire       [0:0]    _zz_602;
  wire       [1:0]    _zz_603;
  wire       [0:0]    _zz_604;
  wire       [0:0]    _zz_605;
  wire                _zz_606;
  wire                _zz_607;
  wire       [21:0]   _zz_608;
  wire       [0:0]    _zz_609;
  wire                _zz_610;
  wire       [10:0]   _zz_611;
  wire       [0:0]    _zz_612;
  wire                _zz_613;
  wire                _zz_614;
  wire                _zz_615;
  wire                _zz_616;
  wire                _zz_617;
  wire                _zz_618;
  wire                _zz_619;
  wire                _zz_620;
  wire                _zz_621;
  wire                _zz_622;
  wire                _zz_623;
  wire                _zz_624;
  wire       [31:0]   execute_BRANCH_CALC;
  wire                execute_BRANCH_DO;
  wire       [31:0]   execute_BitManipZbb_FINAL_OUTPUT;
  wire       [31:0]   execute_BitManipZba_FINAL_OUTPUT;
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
  wire       `BitManipZbbCtrlsignextendEnum_defaultEncoding_type decode_BitManipZbbCtrlsignextend;
  wire       `BitManipZbbCtrlsignextendEnum_defaultEncoding_type _zz_3;
  wire       `BitManipZbbCtrlsignextendEnum_defaultEncoding_type _zz_4;
  wire       `BitManipZbbCtrlsignextendEnum_defaultEncoding_type _zz_5;
  wire       `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_type decode_BitManipZbbCtrlcountzeroes;
  wire       `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_type _zz_6;
  wire       `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_type _zz_7;
  wire       `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_type _zz_8;
  wire       `BitManipZbbCtrlminmaxEnum_defaultEncoding_type decode_BitManipZbbCtrlminmax;
  wire       `BitManipZbbCtrlminmaxEnum_defaultEncoding_type _zz_9;
  wire       `BitManipZbbCtrlminmaxEnum_defaultEncoding_type _zz_10;
  wire       `BitManipZbbCtrlminmaxEnum_defaultEncoding_type _zz_11;
  wire       `BitManipZbbCtrlrotationEnum_defaultEncoding_type decode_BitManipZbbCtrlrotation;
  wire       `BitManipZbbCtrlrotationEnum_defaultEncoding_type _zz_12;
  wire       `BitManipZbbCtrlrotationEnum_defaultEncoding_type _zz_13;
  wire       `BitManipZbbCtrlrotationEnum_defaultEncoding_type _zz_14;
  wire       `BitManipZbbCtrlbitwiseEnum_defaultEncoding_type decode_BitManipZbbCtrlbitwise;
  wire       `BitManipZbbCtrlbitwiseEnum_defaultEncoding_type _zz_15;
  wire       `BitManipZbbCtrlbitwiseEnum_defaultEncoding_type _zz_16;
  wire       `BitManipZbbCtrlbitwiseEnum_defaultEncoding_type _zz_17;
  wire       `BitManipZbbCtrlgrevorcEnum_defaultEncoding_type decode_BitManipZbbCtrlgrevorc;
  wire       `BitManipZbbCtrlgrevorcEnum_defaultEncoding_type _zz_18;
  wire       `BitManipZbbCtrlgrevorcEnum_defaultEncoding_type _zz_19;
  wire       `BitManipZbbCtrlgrevorcEnum_defaultEncoding_type _zz_20;
  wire       `BitManipZbbCtrlEnum_defaultEncoding_type decode_BitManipZbbCtrl;
  wire       `BitManipZbbCtrlEnum_defaultEncoding_type _zz_21;
  wire       `BitManipZbbCtrlEnum_defaultEncoding_type _zz_22;
  wire       `BitManipZbbCtrlEnum_defaultEncoding_type _zz_23;
  wire                execute_IS_BitManipZbb;
  wire                decode_IS_BitManipZbb;
  wire       `BitManipZbaCtrlsh_addEnum_defaultEncoding_type decode_BitManipZbaCtrlsh_add;
  wire       `BitManipZbaCtrlsh_addEnum_defaultEncoding_type _zz_24;
  wire       `BitManipZbaCtrlsh_addEnum_defaultEncoding_type _zz_25;
  wire       `BitManipZbaCtrlsh_addEnum_defaultEncoding_type _zz_26;
  wire                execute_IS_BitManipZba;
  wire                decode_IS_BitManipZba;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_27;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_28;
  wire       `ShiftCtrlEnum_defaultEncoding_type decode_SHIFT_CTRL;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_29;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_30;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_31;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type decode_ALU_BITWISE_CTRL;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_32;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_33;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_34;
  wire                decode_SRC_LESS_UNSIGNED;
  wire       `Src3CtrlEnum_defaultEncoding_type decode_SRC3_CTRL;
  wire       `Src3CtrlEnum_defaultEncoding_type _zz_35;
  wire       `Src3CtrlEnum_defaultEncoding_type _zz_36;
  wire       `Src3CtrlEnum_defaultEncoding_type _zz_37;
  wire                decode_MEMORY_MANAGMENT;
  wire                decode_MEMORY_WR;
  wire                execute_BYPASSABLE_MEMORY_STAGE;
  wire                decode_BYPASSABLE_MEMORY_STAGE;
  wire                decode_BYPASSABLE_EXECUTE_STAGE;
  wire       `Src2CtrlEnum_defaultEncoding_type decode_SRC2_CTRL;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_38;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_39;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_40;
  wire       `AluCtrlEnum_defaultEncoding_type decode_ALU_CTRL;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_41;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_42;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_43;
  wire       `Src1CtrlEnum_defaultEncoding_type decode_SRC1_CTRL;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_44;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_45;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_46;
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
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_47;
  wire                decode_RS3_USE;
  wire                decode_RS2_USE;
  wire                decode_RS1_USE;
  wire       [31:0]   _zz_48;
  wire                execute_REGFILE_WRITE_VALID_ODD;
  wire       [31:0]   _zz_49;
  wire                execute_REGFILE_WRITE_VALID;
  wire                execute_BYPASSABLE_EXECUTE_STAGE;
  wire       [31:0]   _zz_50;
  wire                memory_REGFILE_WRITE_VALID_ODD;
  wire                memory_REGFILE_WRITE_VALID;
  wire                memory_BYPASSABLE_MEMORY_STAGE;
  wire       [31:0]   memory_INSTRUCTION;
  wire       [31:0]   _zz_51;
  wire                writeBack_REGFILE_WRITE_VALID_ODD;
  wire                writeBack_REGFILE_WRITE_VALID;
  reg        [31:0]   decode_RS3;
  reg        [31:0]   decode_RS2;
  reg        [31:0]   decode_RS1;
  wire       [31:0]   memory_BitManipZbb_FINAL_OUTPUT;
  wire                memory_IS_BitManipZbb;
  wire       `BitManipZbbCtrlEnum_defaultEncoding_type execute_BitManipZbbCtrl;
  wire       `BitManipZbbCtrlEnum_defaultEncoding_type _zz_52;
  wire       `BitManipZbbCtrlsignextendEnum_defaultEncoding_type execute_BitManipZbbCtrlsignextend;
  wire       `BitManipZbbCtrlsignextendEnum_defaultEncoding_type _zz_53;
  wire       `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_type execute_BitManipZbbCtrlcountzeroes;
  wire       `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_type _zz_54;
  wire       `BitManipZbbCtrlminmaxEnum_defaultEncoding_type execute_BitManipZbbCtrlminmax;
  wire       `BitManipZbbCtrlminmaxEnum_defaultEncoding_type _zz_55;
  reg        [31:0]   _zz_56;
  reg        [31:0]   _zz_57;
  reg        [31:0]   _zz_58;
  reg        [31:0]   _zz_59;
  reg        [31:0]   _zz_60;
  reg        [31:0]   _zz_61;
  reg        [31:0]   _zz_62;
  reg        [31:0]   _zz_63;
  reg        [31:0]   _zz_64;
  reg        [31:0]   _zz_65;
  wire       `BitManipZbbCtrlrotationEnum_defaultEncoding_type execute_BitManipZbbCtrlrotation;
  wire       `BitManipZbbCtrlrotationEnum_defaultEncoding_type _zz_66;
  wire       `BitManipZbbCtrlbitwiseEnum_defaultEncoding_type execute_BitManipZbbCtrlbitwise;
  wire       `BitManipZbbCtrlbitwiseEnum_defaultEncoding_type _zz_67;
  wire       `BitManipZbbCtrlgrevorcEnum_defaultEncoding_type execute_BitManipZbbCtrlgrevorc;
  wire       `BitManipZbbCtrlgrevorcEnum_defaultEncoding_type _zz_68;
  wire       [31:0]   memory_BitManipZba_FINAL_OUTPUT;
  wire                memory_IS_BitManipZba;
  wire       `BitManipZbaCtrlsh_addEnum_defaultEncoding_type execute_BitManipZbaCtrlsh_add;
  wire       `BitManipZbaCtrlsh_addEnum_defaultEncoding_type _zz_69;
  wire       [31:0]   memory_SHIFT_RIGHT;
  reg        [31:0]   _zz_70;
  wire       `ShiftCtrlEnum_defaultEncoding_type memory_SHIFT_CTRL;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_71;
  wire       `ShiftCtrlEnum_defaultEncoding_type execute_SHIFT_CTRL;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_72;
  wire                execute_SRC_LESS_UNSIGNED;
  wire                execute_SRC2_FORCE_ZERO;
  wire                execute_SRC_USE_SUB_LESS;
  wire       `Src3CtrlEnum_defaultEncoding_type execute_SRC3_CTRL;
  wire       `Src3CtrlEnum_defaultEncoding_type _zz_73;
  wire       [31:0]   _zz_74;
  wire       `Src2CtrlEnum_defaultEncoding_type execute_SRC2_CTRL;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_75;
  wire       `Src1CtrlEnum_defaultEncoding_type execute_SRC1_CTRL;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_76;
  wire                decode_SRC_USE_SUB_LESS;
  wire                decode_SRC_ADD_ZERO;
  wire       [31:0]   execute_SRC_ADD_SUB;
  wire                execute_SRC_LESS;
  wire       `AluCtrlEnum_defaultEncoding_type execute_ALU_CTRL;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_77;
  wire       [31:0]   execute_SRC2;
  wire       [31:0]   execute_SRC1;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type execute_ALU_BITWISE_CTRL;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_78;
  wire                _zz_79;
  reg                 _zz_80;
  wire       [31:0]   _zz_81;
  wire       [31:0]   decode_INSTRUCTION_ANTICIPATED;
  reg                 decode_REGFILE_WRITE_VALID;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_82;
  wire       `BitManipZbbCtrlsignextendEnum_defaultEncoding_type _zz_83;
  wire       `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_type _zz_84;
  wire       `BitManipZbbCtrlminmaxEnum_defaultEncoding_type _zz_85;
  wire       `BitManipZbbCtrlrotationEnum_defaultEncoding_type _zz_86;
  wire       `BitManipZbbCtrlbitwiseEnum_defaultEncoding_type _zz_87;
  wire       `BitManipZbbCtrlgrevorcEnum_defaultEncoding_type _zz_88;
  wire       `BitManipZbbCtrlEnum_defaultEncoding_type _zz_89;
  wire       `BitManipZbaCtrlsh_addEnum_defaultEncoding_type _zz_90;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_91;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_92;
  wire       `Src3CtrlEnum_defaultEncoding_type _zz_93;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_94;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_95;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_96;
  reg        [31:0]   _zz_97;
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
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_98;
  wire       [31:0]   decode_INSTRUCTION;
  reg        [31:0]   _zz_99;
  reg        [31:0]   _zz_100;
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
  wire       [2:0]    dBus_rsp_payload_aggregated;
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
  wire       [2:0]    _zz_101;
  wire       [2:0]    _zz_102;
  wire                _zz_103;
  wire                _zz_104;
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
  wire                _zz_105;
  wire                _zz_106;
  wire                _zz_107;
  wire                IBusCachedPlugin_iBusRsp_flush;
  wire                _zz_108;
  wire                _zz_109;
  reg                 _zz_110;
  wire                _zz_111;
  reg                 _zz_112;
  reg        [31:0]   _zz_113;
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
  wire                _zz_114;
  reg        [18:0]   _zz_115;
  wire                _zz_116;
  reg        [10:0]   _zz_117;
  wire                _zz_118;
  reg        [18:0]   _zz_119;
  reg                 _zz_120;
  wire                _zz_121;
  reg        [10:0]   _zz_122;
  wire                _zz_123;
  reg        [18:0]   _zz_124;
  wire                iBus_cmd_valid;
  wire                iBus_cmd_ready;
  reg        [31:0]   iBus_cmd_payload_address;
  wire       [2:0]    iBus_cmd_payload_size;
  wire                iBus_rsp_valid;
  wire       [31:0]   iBus_rsp_payload_data;
  wire                iBus_rsp_payload_error;
  wire       [31:0]   _zz_125;
  reg        [31:0]   IBusCachedPlugin_rspCounter;
  wire                IBusCachedPlugin_s0_tightlyCoupledHit;
  reg                 IBusCachedPlugin_s1_tightlyCoupledHit;
  reg                 IBusCachedPlugin_s2_tightlyCoupledHit;
  wire                IBusCachedPlugin_rsp_iBusRspOutputHalt;
  wire                IBusCachedPlugin_rsp_issueDetected;
  reg                 IBusCachedPlugin_rsp_redoFetch;
  wire       [31:0]   _zz_126;
  reg        [31:0]   DBusCachedPlugin_rspCounter;
  wire       [1:0]    execute_DBusCachedPlugin_size;
  reg        [31:0]   _zz_127;
  wire       [7:0]    writeBack_DBusCachedPlugin_rspSplits_0;
  wire       [7:0]    writeBack_DBusCachedPlugin_rspSplits_1;
  wire       [7:0]    writeBack_DBusCachedPlugin_rspSplits_2;
  wire       [7:0]    writeBack_DBusCachedPlugin_rspSplits_3;
  reg        [31:0]   writeBack_DBusCachedPlugin_rspShifted;
  wire       [31:0]   writeBack_DBusCachedPlugin_rspRf;
  wire                _zz_128;
  reg        [31:0]   _zz_129;
  wire                _zz_130;
  reg        [31:0]   _zz_131;
  reg        [31:0]   writeBack_DBusCachedPlugin_rspFormated;
  wire       [43:0]   _zz_132;
  wire                _zz_133;
  wire                _zz_134;
  wire                _zz_135;
  wire                _zz_136;
  wire                _zz_137;
  wire                _zz_138;
  wire                _zz_139;
  wire                _zz_140;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_141;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_142;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_143;
  wire       `Src3CtrlEnum_defaultEncoding_type _zz_144;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_145;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_146;
  wire       `BitManipZbaCtrlsh_addEnum_defaultEncoding_type _zz_147;
  wire       `BitManipZbbCtrlEnum_defaultEncoding_type _zz_148;
  wire       `BitManipZbbCtrlgrevorcEnum_defaultEncoding_type _zz_149;
  wire       `BitManipZbbCtrlbitwiseEnum_defaultEncoding_type _zz_150;
  wire       `BitManipZbbCtrlrotationEnum_defaultEncoding_type _zz_151;
  wire       `BitManipZbbCtrlminmaxEnum_defaultEncoding_type _zz_152;
  wire       `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_type _zz_153;
  wire       `BitManipZbbCtrlsignextendEnum_defaultEncoding_type _zz_154;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_155;
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
  reg                 _zz_156;
  reg        [31:0]   execute_IntAluPlugin_bitwise;
  reg        [31:0]   _zz_157;
  reg        [31:0]   _zz_158;
  wire                _zz_159;
  reg        [19:0]   _zz_160;
  wire                _zz_161;
  reg        [19:0]   _zz_162;
  reg        [31:0]   _zz_163;
  reg        [31:0]   execute_SrcPlugin_addSub;
  wire                execute_SrcPlugin_less;
  wire       [4:0]    execute_FullBarrelShifterPlugin_amplitude;
  reg        [31:0]   _zz_164;
  wire       [31:0]   execute_FullBarrelShifterPlugin_reversed;
  reg        [31:0]   _zz_165;
  reg        [31:0]   execute_BitManipZbaPlugin_val_sh_add;
  wire       [31:0]   _zz_166;
  wire       [31:0]   _zz_167;
  reg        [31:0]   execute_BitManipZbbPlugin_val_grevorc;
  reg        [31:0]   execute_BitManipZbbPlugin_val_bitwise;
  wire       [4:0]    _zz_168;
  wire       [31:0]   _zz_169;
  wire       [4:0]    _zz_170;
  wire       [31:0]   _zz_171;
  reg        [31:0]   execute_BitManipZbbPlugin_val_rotation;
  reg        [31:0]   execute_BitManipZbbPlugin_val_minmax;
  wire       [31:0]   _zz_172;
  wire       [3:0]    _zz_173;
  wire       [2:0]    _zz_174;
  wire       [3:0]    _zz_175;
  wire       [2:0]    _zz_176;
  wire       [3:0]    _zz_177;
  wire       [2:0]    _zz_178;
  wire       [3:0]    _zz_179;
  wire       [2:0]    _zz_180;
  wire       [3:0]    _zz_181;
  wire       [2:0]    _zz_182;
  wire       [3:0]    _zz_183;
  wire       [2:0]    _zz_184;
  wire       [3:0]    _zz_185;
  wire       [2:0]    _zz_186;
  wire       [3:0]    _zz_187;
  wire       [2:0]    _zz_188;
  wire       [7:0]    _zz_189;
  wire                _zz_190;
  wire                _zz_191;
  wire                _zz_192;
  wire                _zz_193;
  wire       [3:0]    _zz_194;
  reg        [1:0]    _zz_195;
  reg        [31:0]   execute_BitManipZbbPlugin_val_countzeroes;
  reg        [31:0]   execute_BitManipZbbPlugin_val_signextend;
  reg        [31:0]   _zz_196;
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
  wire                _zz_197;
  wire       [4:0]    _zz_198;
  wire       [4:0]    _zz_199;
  wire       [4:0]    _zz_200;
  wire                _zz_201;
  wire                _zz_202;
  wire                _zz_203;
  wire                _zz_204;
  wire                _zz_205;
  wire                _zz_206;
  wire                _zz_207;
  wire       [4:0]    _zz_208;
  wire       [4:0]    _zz_209;
  wire       [4:0]    _zz_210;
  wire                _zz_211;
  wire                _zz_212;
  wire                _zz_213;
  wire                _zz_214;
  wire                _zz_215;
  wire                _zz_216;
  wire                _zz_217;
  wire       [4:0]    _zz_218;
  wire       [4:0]    _zz_219;
  wire       [4:0]    _zz_220;
  wire                _zz_221;
  wire                _zz_222;
  wire                _zz_223;
  wire                _zz_224;
  wire                _zz_225;
  wire                _zz_226;
  wire                execute_BranchPlugin_eq;
  wire       [2:0]    _zz_227;
  reg                 _zz_228;
  reg                 _zz_229;
  wire                _zz_230;
  reg        [19:0]   _zz_231;
  wire                _zz_232;
  reg        [10:0]   _zz_233;
  wire                _zz_234;
  reg        [18:0]   _zz_235;
  reg                 _zz_236;
  wire                execute_BranchPlugin_missAlignedTarget;
  reg        [31:0]   execute_BranchPlugin_branch_src1;
  reg        [31:0]   execute_BranchPlugin_branch_src2;
  wire                _zz_237;
  reg        [19:0]   _zz_238;
  wire                _zz_239;
  reg        [10:0]   _zz_240;
  wire                _zz_241;
  reg        [18:0]   _zz_242;
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
  reg                 decode_to_execute_IS_BitManipZba;
  reg                 execute_to_memory_IS_BitManipZba;
  reg        `BitManipZbaCtrlsh_addEnum_defaultEncoding_type decode_to_execute_BitManipZbaCtrlsh_add;
  reg                 decode_to_execute_IS_BitManipZbb;
  reg                 execute_to_memory_IS_BitManipZbb;
  reg        `BitManipZbbCtrlEnum_defaultEncoding_type decode_to_execute_BitManipZbbCtrl;
  reg        `BitManipZbbCtrlgrevorcEnum_defaultEncoding_type decode_to_execute_BitManipZbbCtrlgrevorc;
  reg        `BitManipZbbCtrlbitwiseEnum_defaultEncoding_type decode_to_execute_BitManipZbbCtrlbitwise;
  reg        `BitManipZbbCtrlrotationEnum_defaultEncoding_type decode_to_execute_BitManipZbbCtrlrotation;
  reg        `BitManipZbbCtrlminmaxEnum_defaultEncoding_type decode_to_execute_BitManipZbbCtrlminmax;
  reg        `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_type decode_to_execute_BitManipZbbCtrlcountzeroes;
  reg        `BitManipZbbCtrlsignextendEnum_defaultEncoding_type decode_to_execute_BitManipZbbCtrlsignextend;
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
  reg        [31:0]   execute_to_memory_BitManipZba_FINAL_OUTPUT;
  reg        [31:0]   execute_to_memory_BitManipZbb_FINAL_OUTPUT;
  reg                 execute_to_memory_BRANCH_DO;
  reg        [31:0]   execute_to_memory_BRANCH_CALC;
  reg        [1:0]    _zz_243;
  reg                 _zz_244;
  reg        [31:0]   iBusWishbone_DAT_MISO_regNext;
  reg        [1:0]    _zz_245;
  wire                _zz_246;
  wire                _zz_247;
  wire                _zz_248;
  wire                _zz_249;
  wire                _zz_250;
  reg                 _zz_251;
  reg        [31:0]   dBusWishbone_DAT_MISO_regNext;
  `ifndef SYNTHESIS
  reg [31:0] _zz_1_string;
  reg [31:0] _zz_2_string;
  reg [103:0] decode_BitManipZbbCtrlsignextend_string;
  reg [103:0] _zz_3_string;
  reg [103:0] _zz_4_string;
  reg [103:0] _zz_5_string;
  reg [71:0] decode_BitManipZbbCtrlcountzeroes_string;
  reg [71:0] _zz_6_string;
  reg [71:0] _zz_7_string;
  reg [71:0] _zz_8_string;
  reg [71:0] decode_BitManipZbbCtrlminmax_string;
  reg [71:0] _zz_9_string;
  reg [71:0] _zz_10_string;
  reg [71:0] _zz_11_string;
  reg [63:0] decode_BitManipZbbCtrlrotation_string;
  reg [63:0] _zz_12_string;
  reg [63:0] _zz_13_string;
  reg [63:0] _zz_14_string;
  reg [71:0] decode_BitManipZbbCtrlbitwise_string;
  reg [71:0] _zz_15_string;
  reg [71:0] _zz_16_string;
  reg [71:0] _zz_17_string;
  reg [95:0] decode_BitManipZbbCtrlgrevorc_string;
  reg [95:0] _zz_18_string;
  reg [95:0] _zz_19_string;
  reg [95:0] _zz_20_string;
  reg [127:0] decode_BitManipZbbCtrl_string;
  reg [127:0] _zz_21_string;
  reg [127:0] _zz_22_string;
  reg [127:0] _zz_23_string;
  reg [87:0] decode_BitManipZbaCtrlsh_add_string;
  reg [87:0] _zz_24_string;
  reg [87:0] _zz_25_string;
  reg [87:0] _zz_26_string;
  reg [71:0] _zz_27_string;
  reg [71:0] _zz_28_string;
  reg [71:0] decode_SHIFT_CTRL_string;
  reg [71:0] _zz_29_string;
  reg [71:0] _zz_30_string;
  reg [71:0] _zz_31_string;
  reg [39:0] decode_ALU_BITWISE_CTRL_string;
  reg [39:0] _zz_32_string;
  reg [39:0] _zz_33_string;
  reg [39:0] _zz_34_string;
  reg [23:0] decode_SRC3_CTRL_string;
  reg [23:0] _zz_35_string;
  reg [23:0] _zz_36_string;
  reg [23:0] _zz_37_string;
  reg [23:0] decode_SRC2_CTRL_string;
  reg [23:0] _zz_38_string;
  reg [23:0] _zz_39_string;
  reg [23:0] _zz_40_string;
  reg [63:0] decode_ALU_CTRL_string;
  reg [63:0] _zz_41_string;
  reg [63:0] _zz_42_string;
  reg [63:0] _zz_43_string;
  reg [95:0] decode_SRC1_CTRL_string;
  reg [95:0] _zz_44_string;
  reg [95:0] _zz_45_string;
  reg [95:0] _zz_46_string;
  reg [31:0] execute_BRANCH_CTRL_string;
  reg [31:0] _zz_47_string;
  reg [127:0] execute_BitManipZbbCtrl_string;
  reg [127:0] _zz_52_string;
  reg [103:0] execute_BitManipZbbCtrlsignextend_string;
  reg [103:0] _zz_53_string;
  reg [71:0] execute_BitManipZbbCtrlcountzeroes_string;
  reg [71:0] _zz_54_string;
  reg [71:0] execute_BitManipZbbCtrlminmax_string;
  reg [71:0] _zz_55_string;
  reg [63:0] execute_BitManipZbbCtrlrotation_string;
  reg [63:0] _zz_66_string;
  reg [71:0] execute_BitManipZbbCtrlbitwise_string;
  reg [71:0] _zz_67_string;
  reg [95:0] execute_BitManipZbbCtrlgrevorc_string;
  reg [95:0] _zz_68_string;
  reg [87:0] execute_BitManipZbaCtrlsh_add_string;
  reg [87:0] _zz_69_string;
  reg [71:0] memory_SHIFT_CTRL_string;
  reg [71:0] _zz_71_string;
  reg [71:0] execute_SHIFT_CTRL_string;
  reg [71:0] _zz_72_string;
  reg [23:0] execute_SRC3_CTRL_string;
  reg [23:0] _zz_73_string;
  reg [23:0] execute_SRC2_CTRL_string;
  reg [23:0] _zz_75_string;
  reg [95:0] execute_SRC1_CTRL_string;
  reg [95:0] _zz_76_string;
  reg [63:0] execute_ALU_CTRL_string;
  reg [63:0] _zz_77_string;
  reg [39:0] execute_ALU_BITWISE_CTRL_string;
  reg [39:0] _zz_78_string;
  reg [31:0] _zz_82_string;
  reg [103:0] _zz_83_string;
  reg [71:0] _zz_84_string;
  reg [71:0] _zz_85_string;
  reg [63:0] _zz_86_string;
  reg [71:0] _zz_87_string;
  reg [95:0] _zz_88_string;
  reg [127:0] _zz_89_string;
  reg [87:0] _zz_90_string;
  reg [71:0] _zz_91_string;
  reg [39:0] _zz_92_string;
  reg [23:0] _zz_93_string;
  reg [23:0] _zz_94_string;
  reg [63:0] _zz_95_string;
  reg [95:0] _zz_96_string;
  reg [31:0] decode_BRANCH_CTRL_string;
  reg [31:0] _zz_98_string;
  reg [95:0] _zz_141_string;
  reg [63:0] _zz_142_string;
  reg [23:0] _zz_143_string;
  reg [23:0] _zz_144_string;
  reg [39:0] _zz_145_string;
  reg [71:0] _zz_146_string;
  reg [87:0] _zz_147_string;
  reg [127:0] _zz_148_string;
  reg [95:0] _zz_149_string;
  reg [71:0] _zz_150_string;
  reg [63:0] _zz_151_string;
  reg [71:0] _zz_152_string;
  reg [71:0] _zz_153_string;
  reg [103:0] _zz_154_string;
  reg [31:0] _zz_155_string;
  reg [95:0] decode_to_execute_SRC1_CTRL_string;
  reg [63:0] decode_to_execute_ALU_CTRL_string;
  reg [23:0] decode_to_execute_SRC2_CTRL_string;
  reg [23:0] decode_to_execute_SRC3_CTRL_string;
  reg [39:0] decode_to_execute_ALU_BITWISE_CTRL_string;
  reg [71:0] decode_to_execute_SHIFT_CTRL_string;
  reg [71:0] execute_to_memory_SHIFT_CTRL_string;
  reg [87:0] decode_to_execute_BitManipZbaCtrlsh_add_string;
  reg [127:0] decode_to_execute_BitManipZbbCtrl_string;
  reg [95:0] decode_to_execute_BitManipZbbCtrlgrevorc_string;
  reg [71:0] decode_to_execute_BitManipZbbCtrlbitwise_string;
  reg [63:0] decode_to_execute_BitManipZbbCtrlrotation_string;
  reg [71:0] decode_to_execute_BitManipZbbCtrlminmax_string;
  reg [71:0] decode_to_execute_BitManipZbbCtrlcountzeroes_string;
  reg [103:0] decode_to_execute_BitManipZbbCtrlsignextend_string;
  reg [31:0] decode_to_execute_BRANCH_CTRL_string;
  `endif

  reg [31:0] RegFilePlugin_regFile [0:31] /* verilator public */ ;

  assign _zz_286 = (writeBack_arbitration_isValid && writeBack_REGFILE_WRITE_VALID);
  assign _zz_287 = 1'b1;
  assign _zz_288 = ((writeBack_arbitration_isValid && _zz_197) && writeBack_REGFILE_WRITE_VALID_ODD);
  assign _zz_289 = 1'b1;
  assign _zz_290 = (memory_arbitration_isValid && memory_REGFILE_WRITE_VALID);
  assign _zz_291 = ((memory_arbitration_isValid && _zz_207) && memory_REGFILE_WRITE_VALID_ODD);
  assign _zz_292 = (execute_arbitration_isValid && execute_REGFILE_WRITE_VALID);
  assign _zz_293 = ((execute_arbitration_isValid && _zz_217) && execute_REGFILE_WRITE_VALID_ODD);
  assign _zz_294 = ((_zz_257 && IBusCachedPlugin_cache_io_cpu_decode_cacheMiss) && (! IBusCachedPlugin_rsp_issueDetected_1));
  assign _zz_295 = ((_zz_257 && IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling) && (! IBusCachedPlugin_rsp_issueDetected));
  assign _zz_296 = (writeBack_arbitration_isValid && writeBack_REGFILE_WRITE_VALID);
  assign _zz_297 = (1'b0 || (! 1'b1));
  assign _zz_298 = (memory_arbitration_isValid && memory_REGFILE_WRITE_VALID);
  assign _zz_299 = (1'b0 || (! memory_BYPASSABLE_MEMORY_STAGE));
  assign _zz_300 = (execute_arbitration_isValid && execute_REGFILE_WRITE_VALID);
  assign _zz_301 = (1'b0 || (! execute_BYPASSABLE_EXECUTE_STAGE));
  assign _zz_302 = (iBus_cmd_valid || (_zz_243 != 2'b00));
  assign _zz_303 = writeBack_INSTRUCTION[13 : 12];
  assign _zz_304 = _zz_194[2 : 0];
  assign _zz_305 = ($signed(_zz_307) >>> execute_FullBarrelShifterPlugin_amplitude);
  assign _zz_306 = _zz_305[31 : 0];
  assign _zz_307 = {((execute_SHIFT_CTRL == `ShiftCtrlEnum_defaultEncoding_SRA_1) && execute_FullBarrelShifterPlugin_reversed[31]),execute_FullBarrelShifterPlugin_reversed};
  assign _zz_308 = (_zz_101 - 3'b001);
  assign _zz_309 = {IBusCachedPlugin_fetchPc_inc,2'b00};
  assign _zz_310 = {29'd0, _zz_309};
  assign _zz_311 = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_312 = {{_zz_115,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz_313 = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]};
  assign _zz_314 = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_315 = {{_zz_117,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]}},1'b0};
  assign _zz_316 = {{_zz_119,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz_317 = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]};
  assign _zz_318 = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_319 = execute_SRC_LESS;
  assign _zz_320 = 3'b100;
  assign _zz_321 = execute_INSTRUCTION[19 : 15];
  assign _zz_322 = {execute_INSTRUCTION[31 : 25],execute_INSTRUCTION[11 : 7]};
  assign _zz_323 = ($signed(_zz_324) + $signed(_zz_327));
  assign _zz_324 = ($signed(_zz_325) + $signed(_zz_326));
  assign _zz_325 = execute_SRC1;
  assign _zz_326 = (execute_SRC_USE_SUB_LESS ? (~ execute_SRC2) : execute_SRC2);
  assign _zz_327 = (execute_SRC_USE_SUB_LESS ? _zz_328 : _zz_329);
  assign _zz_328 = 32'h00000001;
  assign _zz_329 = 32'h0;
  assign _zz_330 = (_zz_331 + execute_SRC2);
  assign _zz_331 = (execute_SRC1 <<< 1);
  assign _zz_332 = (_zz_333 + execute_SRC2);
  assign _zz_333 = (execute_SRC1 <<< 2);
  assign _zz_334 = (_zz_335 + execute_SRC2);
  assign _zz_335 = (execute_SRC1 <<< 3);
  assign _zz_336 = ((execute_SRC1 & 32'h55555555) <<< 1);
  assign _zz_337 = ((execute_SRC1 & 32'haaaaaaaa) >>> 1);
  assign _zz_338 = ((_zz_166 & 32'h33333333) <<< 2);
  assign _zz_339 = ((_zz_166 & 32'hcccccccc) >>> 2);
  assign _zz_340 = ((_zz_167 & 32'h0f0f0f0f) <<< 4);
  assign _zz_341 = ((_zz_167 & 32'hf0f0f0f0) >>> 4);
  assign _zz_342 = (execute_SRC2 & 32'h0000001f);
  assign _zz_343 = (execute_SRC2 & 32'h0000001f);
  assign _zz_344 = execute_SRC2;
  assign _zz_345 = execute_SRC1;
  assign _zz_346 = execute_SRC1;
  assign _zz_347 = execute_SRC2;
  assign _zz_348 = (_zz_194[3] ? 6'h20 : {{1'b0,_zz_194[2 : 0]},_zz_195[1 : 0]});
  assign _zz_349 = _zz_350;
  assign _zz_350 = (_zz_351 + _zz_444);
  assign _zz_351 = (_zz_352 + _zz_442);
  assign _zz_352 = (_zz_353 + _zz_440);
  assign _zz_353 = (_zz_354 + _zz_438);
  assign _zz_354 = (_zz_355 + _zz_436);
  assign _zz_355 = (_zz_356 + _zz_434);
  assign _zz_356 = (_zz_357 + _zz_432);
  assign _zz_357 = (_zz_358 + _zz_430);
  assign _zz_358 = (_zz_359 + _zz_428);
  assign _zz_359 = (_zz_360 + _zz_426);
  assign _zz_360 = (_zz_361 + _zz_424);
  assign _zz_361 = (_zz_362 + _zz_422);
  assign _zz_362 = (_zz_363 + _zz_420);
  assign _zz_363 = (_zz_364 + _zz_418);
  assign _zz_364 = (_zz_365 + _zz_416);
  assign _zz_365 = (_zz_366 + _zz_414);
  assign _zz_366 = (_zz_367 + _zz_412);
  assign _zz_367 = (_zz_368 + _zz_410);
  assign _zz_368 = (_zz_369 + _zz_408);
  assign _zz_369 = (_zz_370 + _zz_406);
  assign _zz_370 = (_zz_371 + _zz_404);
  assign _zz_371 = (_zz_372 + _zz_402);
  assign _zz_372 = (_zz_373 + _zz_400);
  assign _zz_373 = (_zz_374 + _zz_398);
  assign _zz_374 = (_zz_375 + _zz_396);
  assign _zz_375 = (_zz_376 + _zz_394);
  assign _zz_376 = (_zz_377 + _zz_392);
  assign _zz_377 = (_zz_378 + _zz_390);
  assign _zz_378 = (_zz_379 + _zz_388);
  assign _zz_379 = (_zz_380 + _zz_386);
  assign _zz_380 = (_zz_382 + _zz_384);
  assign _zz_381 = execute_SRC1[0];
  assign _zz_382 = {5'd0, _zz_381};
  assign _zz_383 = execute_SRC1[1];
  assign _zz_384 = {5'd0, _zz_383};
  assign _zz_385 = execute_SRC1[2];
  assign _zz_386 = {5'd0, _zz_385};
  assign _zz_387 = execute_SRC1[3];
  assign _zz_388 = {5'd0, _zz_387};
  assign _zz_389 = execute_SRC1[4];
  assign _zz_390 = {5'd0, _zz_389};
  assign _zz_391 = execute_SRC1[5];
  assign _zz_392 = {5'd0, _zz_391};
  assign _zz_393 = execute_SRC1[6];
  assign _zz_394 = {5'd0, _zz_393};
  assign _zz_395 = execute_SRC1[7];
  assign _zz_396 = {5'd0, _zz_395};
  assign _zz_397 = execute_SRC1[8];
  assign _zz_398 = {5'd0, _zz_397};
  assign _zz_399 = execute_SRC1[9];
  assign _zz_400 = {5'd0, _zz_399};
  assign _zz_401 = execute_SRC1[10];
  assign _zz_402 = {5'd0, _zz_401};
  assign _zz_403 = execute_SRC1[11];
  assign _zz_404 = {5'd0, _zz_403};
  assign _zz_405 = execute_SRC1[12];
  assign _zz_406 = {5'd0, _zz_405};
  assign _zz_407 = execute_SRC1[13];
  assign _zz_408 = {5'd0, _zz_407};
  assign _zz_409 = execute_SRC1[14];
  assign _zz_410 = {5'd0, _zz_409};
  assign _zz_411 = execute_SRC1[15];
  assign _zz_412 = {5'd0, _zz_411};
  assign _zz_413 = execute_SRC1[16];
  assign _zz_414 = {5'd0, _zz_413};
  assign _zz_415 = execute_SRC1[17];
  assign _zz_416 = {5'd0, _zz_415};
  assign _zz_417 = execute_SRC1[18];
  assign _zz_418 = {5'd0, _zz_417};
  assign _zz_419 = execute_SRC1[19];
  assign _zz_420 = {5'd0, _zz_419};
  assign _zz_421 = execute_SRC1[20];
  assign _zz_422 = {5'd0, _zz_421};
  assign _zz_423 = execute_SRC1[21];
  assign _zz_424 = {5'd0, _zz_423};
  assign _zz_425 = execute_SRC1[22];
  assign _zz_426 = {5'd0, _zz_425};
  assign _zz_427 = execute_SRC1[23];
  assign _zz_428 = {5'd0, _zz_427};
  assign _zz_429 = execute_SRC1[24];
  assign _zz_430 = {5'd0, _zz_429};
  assign _zz_431 = execute_SRC1[25];
  assign _zz_432 = {5'd0, _zz_431};
  assign _zz_433 = execute_SRC1[26];
  assign _zz_434 = {5'd0, _zz_433};
  assign _zz_435 = execute_SRC1[27];
  assign _zz_436 = {5'd0, _zz_435};
  assign _zz_437 = execute_SRC1[28];
  assign _zz_438 = {5'd0, _zz_437};
  assign _zz_439 = execute_SRC1[29];
  assign _zz_440 = {5'd0, _zz_439};
  assign _zz_441 = execute_SRC1[30];
  assign _zz_442 = {5'd0, _zz_441};
  assign _zz_443 = execute_SRC1[31];
  assign _zz_444 = {5'd0, _zz_443};
  assign _zz_445 = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]};
  assign _zz_446 = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]};
  assign _zz_447 = {_zz_231,execute_INSTRUCTION[31 : 20]};
  assign _zz_448 = {{_zz_233,{{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]}},1'b0};
  assign _zz_449 = {{_zz_235,{{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz_450 = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]};
  assign _zz_451 = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]};
  assign _zz_452 = 3'b100;
  assign _zz_453 = (iBus_cmd_payload_address >>> 4);
  assign _zz_454 = 1'b1;
  assign _zz_455 = 1'b1;
  assign _zz_456 = 1'b1;
  assign _zz_457 = {_zz_104,_zz_103};
  assign _zz_458 = _zz_269[1 : 0];
  assign _zz_459 = _zz_269[1 : 1];
  assign _zz_460 = decode_INSTRUCTION[31];
  assign _zz_461 = decode_INSTRUCTION[31];
  assign _zz_462 = decode_INSTRUCTION[7];
  assign _zz_463 = ((decode_INSTRUCTION & 32'h0000001c) == 32'h00000004);
  assign _zz_464 = ((decode_INSTRUCTION & 32'h00000048) == 32'h00000040);
  assign _zz_465 = ((decode_INSTRUCTION & 32'h00000040) == 32'h00000040);
  assign _zz_466 = 1'b0;
  assign _zz_467 = (((decode_INSTRUCTION & _zz_470) == 32'h0) != 1'b0);
  assign _zz_468 = ((_zz_471 == _zz_472) != 1'b0);
  assign _zz_469 = {(_zz_473 != 1'b0),{(_zz_474 != _zz_475),{_zz_476,{_zz_477,_zz_478}}}};
  assign _zz_470 = 32'h40000000;
  assign _zz_471 = (decode_INSTRUCTION & 32'h00100000);
  assign _zz_472 = 32'h00100000;
  assign _zz_473 = ((decode_INSTRUCTION & 32'h00200000) == 32'h00200000);
  assign _zz_474 = _zz_140;
  assign _zz_475 = 1'b0;
  assign _zz_476 = (_zz_139 != 1'b0);
  assign _zz_477 = (((decode_INSTRUCTION & _zz_479) == 32'h00004000) != 1'b0);
  assign _zz_478 = {(_zz_140 != 1'b0),{(_zz_138 != 1'b0),{(_zz_480 != _zz_481),{_zz_482,{_zz_483,_zz_484}}}}};
  assign _zz_479 = 32'h00004000;
  assign _zz_480 = ((decode_INSTRUCTION & 32'h00400000) == 32'h0);
  assign _zz_481 = 1'b0;
  assign _zz_482 = ({(_zz_485 == _zz_486),(_zz_487 == _zz_488)} != 2'b00);
  assign _zz_483 = ({_zz_489,{_zz_490,_zz_491}} != 3'b000);
  assign _zz_484 = {({_zz_492,_zz_493} != 2'b00),{(_zz_494 != _zz_495),{_zz_496,{_zz_497,_zz_498}}}};
  assign _zz_485 = (decode_INSTRUCTION & 32'h00004020);
  assign _zz_486 = 32'h0;
  assign _zz_487 = (decode_INSTRUCTION & 32'h62000000);
  assign _zz_488 = 32'h0;
  assign _zz_489 = ((decode_INSTRUCTION & _zz_499) == 32'h02000000);
  assign _zz_490 = (_zz_500 == _zz_501);
  assign _zz_491 = (_zz_502 == _zz_503);
  assign _zz_492 = (_zz_504 == _zz_505);
  assign _zz_493 = (_zz_506 == _zz_507);
  assign _zz_494 = {_zz_508,{_zz_509,_zz_510}};
  assign _zz_495 = 4'b0000;
  assign _zz_496 = (_zz_511 != 1'b0);
  assign _zz_497 = (_zz_512 != _zz_513);
  assign _zz_498 = {_zz_514,{_zz_515,_zz_516}};
  assign _zz_499 = 32'h02000000;
  assign _zz_500 = (decode_INSTRUCTION & 32'h20000020);
  assign _zz_501 = 32'h20000020;
  assign _zz_502 = (decode_INSTRUCTION & 32'h08004020);
  assign _zz_503 = 32'h00004000;
  assign _zz_504 = (decode_INSTRUCTION & 32'h20000000);
  assign _zz_505 = 32'h0;
  assign _zz_506 = (decode_INSTRUCTION & 32'h00404020);
  assign _zz_507 = 32'h00400000;
  assign _zz_508 = ((decode_INSTRUCTION & 32'h08004064) == 32'h08004020);
  assign _zz_509 = ((decode_INSTRUCTION & _zz_517) == 32'h20001010);
  assign _zz_510 = {(_zz_518 == _zz_519),(_zz_520 == _zz_521)};
  assign _zz_511 = ((decode_INSTRUCTION & 32'h00006000) == 32'h00006000);
  assign _zz_512 = _zz_140;
  assign _zz_513 = 1'b0;
  assign _zz_514 = ((_zz_522 == _zz_523) != 1'b0);
  assign _zz_515 = (_zz_524 != 1'b0);
  assign _zz_516 = {(_zz_525 != _zz_526),{_zz_527,{_zz_528,_zz_529}}};
  assign _zz_517 = 32'h20003014;
  assign _zz_518 = (decode_INSTRUCTION & 32'h40006064);
  assign _zz_519 = 32'h40006020;
  assign _zz_520 = (decode_INSTRUCTION & 32'h40005064);
  assign _zz_521 = 32'h40004020;
  assign _zz_522 = (decode_INSTRUCTION & 32'h60000034);
  assign _zz_523 = 32'h20000030;
  assign _zz_524 = ((decode_INSTRUCTION & 32'h28007014) == 32'h00005010);
  assign _zz_525 = {(_zz_530 == _zz_531),(_zz_532 == _zz_533)};
  assign _zz_526 = 2'b00;
  assign _zz_527 = ((_zz_534 == _zz_535) != 1'b0);
  assign _zz_528 = (_zz_139 != 1'b0);
  assign _zz_529 = {(_zz_536 != _zz_537),{_zz_538,{_zz_539,_zz_540}}};
  assign _zz_530 = (decode_INSTRUCTION & 32'h60003014);
  assign _zz_531 = 32'h40001010;
  assign _zz_532 = (decode_INSTRUCTION & 32'h40007014);
  assign _zz_533 = 32'h00001010;
  assign _zz_534 = (decode_INSTRUCTION & 32'h00000064);
  assign _zz_535 = 32'h00000024;
  assign _zz_536 = _zz_138;
  assign _zz_537 = 1'b0;
  assign _zz_538 = ({((decode_INSTRUCTION & _zz_541) == 32'h00002000),((decode_INSTRUCTION & _zz_542) == 32'h00001000)} != 2'b00);
  assign _zz_539 = 1'b0;
  assign _zz_540 = {((_zz_543 == _zz_544) != 1'b0),{({_zz_545,_zz_546} != 4'b0000),{(_zz_547 != _zz_548),{_zz_549,{_zz_550,_zz_551}}}}};
  assign _zz_541 = 32'h00002010;
  assign _zz_542 = 32'h00005000;
  assign _zz_543 = (decode_INSTRUCTION & 32'h00004048);
  assign _zz_544 = 32'h00004008;
  assign _zz_545 = _zz_133;
  assign _zz_546 = {(_zz_552 == _zz_553),{_zz_554,_zz_135}};
  assign _zz_547 = ((decode_INSTRUCTION & _zz_555) == 32'h00000020);
  assign _zz_548 = 1'b0;
  assign _zz_549 = (_zz_137 != 1'b0);
  assign _zz_550 = ({_zz_556,_zz_557} != 6'h0);
  assign _zz_551 = {(_zz_558 != _zz_559),{_zz_560,{_zz_561,_zz_562}}};
  assign _zz_552 = (decode_INSTRUCTION & 32'h02000024);
  assign _zz_553 = 32'h02000020;
  assign _zz_554 = ((decode_INSTRUCTION & 32'h08000024) == 32'h00000020);
  assign _zz_555 = 32'h00000020;
  assign _zz_556 = _zz_134;
  assign _zz_557 = {(_zz_563 == _zz_564),{_zz_565,{_zz_566,_zz_567}}};
  assign _zz_558 = {_zz_137,{_zz_136,{_zz_568,_zz_569}}};
  assign _zz_559 = 4'b0000;
  assign _zz_560 = ({_zz_134,_zz_135} != 2'b00);
  assign _zz_561 = ({_zz_570,_zz_571} != 2'b00);
  assign _zz_562 = {(_zz_572 != _zz_573),{_zz_574,{_zz_575,_zz_576}}};
  assign _zz_563 = (decode_INSTRUCTION & 32'h00002030);
  assign _zz_564 = 32'h00002010;
  assign _zz_565 = ((decode_INSTRUCTION & _zz_577) == 32'h00000010);
  assign _zz_566 = (_zz_578 == _zz_579);
  assign _zz_567 = {_zz_580,_zz_581};
  assign _zz_568 = (_zz_582 == _zz_583);
  assign _zz_569 = (_zz_584 == _zz_585);
  assign _zz_570 = _zz_134;
  assign _zz_571 = (_zz_586 == _zz_587);
  assign _zz_572 = (_zz_588 == _zz_589);
  assign _zz_573 = 1'b0;
  assign _zz_574 = (_zz_590 != 1'b0);
  assign _zz_575 = (_zz_591 != _zz_592);
  assign _zz_576 = {_zz_593,{_zz_594,_zz_595}};
  assign _zz_577 = 32'h00001030;
  assign _zz_578 = (decode_INSTRUCTION & 32'h20005020);
  assign _zz_579 = 32'h00000020;
  assign _zz_580 = ((decode_INSTRUCTION & 32'h68002020) == 32'h00002020);
  assign _zz_581 = ((decode_INSTRUCTION & 32'h68001020) == 32'h00000020);
  assign _zz_582 = (decode_INSTRUCTION & 32'h0000000c);
  assign _zz_583 = 32'h00000004;
  assign _zz_584 = (decode_INSTRUCTION & 32'h00000028);
  assign _zz_585 = 32'h0;
  assign _zz_586 = (decode_INSTRUCTION & 32'h00000020);
  assign _zz_587 = 32'h0;
  assign _zz_588 = (decode_INSTRUCTION & 32'h00004014);
  assign _zz_589 = 32'h00004010;
  assign _zz_590 = ((decode_INSTRUCTION & 32'h00006014) == 32'h00002010);
  assign _zz_591 = {(_zz_596 == _zz_597),(_zz_598 == _zz_599)};
  assign _zz_592 = 2'b00;
  assign _zz_593 = ((_zz_600 == _zz_601) != 1'b0);
  assign _zz_594 = ({_zz_602,_zz_603} != 3'b000);
  assign _zz_595 = {(_zz_604 != _zz_605),{_zz_606,_zz_607}};
  assign _zz_596 = (decode_INSTRUCTION & 32'h00000004);
  assign _zz_597 = 32'h0;
  assign _zz_598 = (decode_INSTRUCTION & 32'h00000018);
  assign _zz_599 = 32'h0;
  assign _zz_600 = (decode_INSTRUCTION & 32'h00000058);
  assign _zz_601 = 32'h0;
  assign _zz_602 = _zz_133;
  assign _zz_603 = {((decode_INSTRUCTION & 32'h00002014) == 32'h00002010),((decode_INSTRUCTION & 32'h40000034) == 32'h40000030)};
  assign _zz_604 = ((decode_INSTRUCTION & 32'h00000014) == 32'h00000004);
  assign _zz_605 = 1'b0;
  assign _zz_606 = (((decode_INSTRUCTION & 32'h00000044) == 32'h00000004) != 1'b0);
  assign _zz_607 = (((decode_INSTRUCTION & 32'h00005048) == 32'h00001008) != 1'b0);
  assign _zz_608 = {{{{{{{{{{{_zz_611,_zz_612},_zz_613},execute_SRC1[13]},execute_SRC1[14]},execute_SRC1[15]},execute_SRC1[16]},execute_SRC1[17]},execute_SRC1[18]},execute_SRC1[19]},execute_SRC1[20]},execute_SRC1[21]};
  assign _zz_609 = execute_SRC1[22];
  assign _zz_610 = execute_SRC1[23];
  assign _zz_611 = {{{{{{{{{{_zz_614,_zz_615},execute_SRC1[2]},execute_SRC1[3]},execute_SRC1[4]},execute_SRC1[5]},execute_SRC1[6]},execute_SRC1[7]},execute_SRC1[8]},execute_SRC1[9]},execute_SRC1[10]};
  assign _zz_612 = execute_SRC1[11];
  assign _zz_613 = execute_SRC1[12];
  assign _zz_614 = execute_SRC1[0];
  assign _zz_615 = execute_SRC1[1];
  assign _zz_616 = (! (_zz_189[6] && _zz_189[7]));
  assign _zz_617 = (_zz_189[5] && (! _zz_189[6]));
  assign _zz_618 = (_zz_189[0] && _zz_189[2]);
  assign _zz_619 = _zz_189[4];
  assign _zz_620 = (! (_zz_189[1] && _zz_189[3]));
  assign _zz_621 = (! (_zz_189[1] && (! _zz_189[2])));
  assign _zz_622 = execute_INSTRUCTION[31];
  assign _zz_623 = execute_INSTRUCTION[31];
  assign _zz_624 = execute_INSTRUCTION[7];
  always @ (posedge clk) begin
    if(_zz_454) begin
      _zz_280 <= RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress1];
    end
  end

  always @ (posedge clk) begin
    if(_zz_455) begin
      _zz_281 <= RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress2];
    end
  end

  always @ (posedge clk) begin
    if(_zz_456) begin
      _zz_282 <= RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress3];
    end
  end

  always @ (posedge clk) begin
    if(_zz_80) begin
      RegFilePlugin_regFile[lastStageRegFileWrite_payload_address] <= lastStageRegFileWrite_payload_data;
    end
  end

  InstructionCache IBusCachedPlugin_cache (
    .io_flush                                 (_zz_252                                                     ), //i
    .io_cpu_prefetch_isValid                  (_zz_253                                                     ), //i
    .io_cpu_prefetch_haltIt                   (IBusCachedPlugin_cache_io_cpu_prefetch_haltIt               ), //o
    .io_cpu_prefetch_pc                       (IBusCachedPlugin_iBusRsp_stages_0_input_payload[31:0]       ), //i
    .io_cpu_fetch_isValid                     (_zz_254                                                     ), //i
    .io_cpu_fetch_isStuck                     (_zz_255                                                     ), //i
    .io_cpu_fetch_isRemoved                   (_zz_256                                                     ), //i
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
    .io_cpu_decode_isValid                    (_zz_257                                                     ), //i
    .io_cpu_decode_isStuck                    (_zz_258                                                     ), //i
    .io_cpu_decode_pc                         (IBusCachedPlugin_iBusRsp_stages_2_input_payload[31:0]       ), //i
    .io_cpu_decode_physicalAddress            (IBusCachedPlugin_cache_io_cpu_decode_physicalAddress[31:0]  ), //o
    .io_cpu_decode_data                       (IBusCachedPlugin_cache_io_cpu_decode_data[31:0]             ), //o
    .io_cpu_decode_cacheMiss                  (IBusCachedPlugin_cache_io_cpu_decode_cacheMiss              ), //o
    .io_cpu_decode_error                      (IBusCachedPlugin_cache_io_cpu_decode_error                  ), //o
    .io_cpu_decode_mmuRefilling               (IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling           ), //o
    .io_cpu_decode_mmuException               (IBusCachedPlugin_cache_io_cpu_decode_mmuException           ), //o
    .io_cpu_decode_isUser                     (_zz_259                                                     ), //i
    .io_cpu_fill_valid                        (_zz_260                                                     ), //i
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
    .io_cpu_execute_isValid                    (_zz_261                                            ), //i
    .io_cpu_execute_address                    (_zz_262[31:0]                                      ), //i
    .io_cpu_execute_haltIt                     (dataCache_1_io_cpu_execute_haltIt                  ), //o
    .io_cpu_execute_args_wr                    (execute_MEMORY_WR                                  ), //i
    .io_cpu_execute_args_size                  (execute_DBusCachedPlugin_size[1:0]                 ), //i
    .io_cpu_execute_args_totalyConsistent      (execute_MEMORY_FORCE_CONSTISTENCY                  ), //i
    .io_cpu_execute_refilling                  (dataCache_1_io_cpu_execute_refilling               ), //o
    .io_cpu_memory_isValid                     (_zz_263                                            ), //i
    .io_cpu_memory_isStuck                     (memory_arbitration_isStuck                         ), //i
    .io_cpu_memory_isWrite                     (dataCache_1_io_cpu_memory_isWrite                  ), //o
    .io_cpu_memory_address                     (_zz_264[31:0]                                      ), //i
    .io_cpu_memory_mmuRsp_physicalAddress      (DBusCachedPlugin_mmuBus_rsp_physicalAddress[31:0]  ), //i
    .io_cpu_memory_mmuRsp_isIoAccess           (_zz_265                                            ), //i
    .io_cpu_memory_mmuRsp_isPaging             (DBusCachedPlugin_mmuBus_rsp_isPaging               ), //i
    .io_cpu_memory_mmuRsp_allowRead            (DBusCachedPlugin_mmuBus_rsp_allowRead              ), //i
    .io_cpu_memory_mmuRsp_allowWrite           (DBusCachedPlugin_mmuBus_rsp_allowWrite             ), //i
    .io_cpu_memory_mmuRsp_allowExecute         (DBusCachedPlugin_mmuBus_rsp_allowExecute           ), //i
    .io_cpu_memory_mmuRsp_exception            (DBusCachedPlugin_mmuBus_rsp_exception              ), //i
    .io_cpu_memory_mmuRsp_refilling            (DBusCachedPlugin_mmuBus_rsp_refilling              ), //i
    .io_cpu_memory_mmuRsp_bypassTranslation    (DBusCachedPlugin_mmuBus_rsp_bypassTranslation      ), //i
    .io_cpu_writeBack_isValid                  (_zz_266                                            ), //i
    .io_cpu_writeBack_isStuck                  (writeBack_arbitration_isStuck                      ), //i
    .io_cpu_writeBack_isUser                   (_zz_267                                            ), //i
    .io_cpu_writeBack_haltIt                   (dataCache_1_io_cpu_writeBack_haltIt                ), //o
    .io_cpu_writeBack_isWrite                  (dataCache_1_io_cpu_writeBack_isWrite               ), //o
    .io_cpu_writeBack_storeData                (_zz_268[31:0]                                      ), //i
    .io_cpu_writeBack_data                     (dataCache_1_io_cpu_writeBack_data[31:0]            ), //o
    .io_cpu_writeBack_address                  (_zz_269[31:0]                                      ), //i
    .io_cpu_writeBack_mmuException             (dataCache_1_io_cpu_writeBack_mmuException          ), //o
    .io_cpu_writeBack_unalignedAccess          (dataCache_1_io_cpu_writeBack_unalignedAccess       ), //o
    .io_cpu_writeBack_accessError              (dataCache_1_io_cpu_writeBack_accessError           ), //o
    .io_cpu_writeBack_keepMemRspData           (dataCache_1_io_cpu_writeBack_keepMemRspData        ), //o
    .io_cpu_writeBack_fence_SW                 (_zz_270                                            ), //i
    .io_cpu_writeBack_fence_SR                 (_zz_271                                            ), //i
    .io_cpu_writeBack_fence_SO                 (_zz_272                                            ), //i
    .io_cpu_writeBack_fence_SI                 (_zz_273                                            ), //i
    .io_cpu_writeBack_fence_PW                 (_zz_274                                            ), //i
    .io_cpu_writeBack_fence_PR                 (_zz_275                                            ), //i
    .io_cpu_writeBack_fence_PO                 (_zz_276                                            ), //i
    .io_cpu_writeBack_fence_PI                 (_zz_277                                            ), //i
    .io_cpu_writeBack_fence_FM                 (_zz_278[3:0]                                       ), //i
    .io_cpu_writeBack_exclusiveOk              (dataCache_1_io_cpu_writeBack_exclusiveOk           ), //o
    .io_cpu_redo                               (dataCache_1_io_cpu_redo                            ), //o
    .io_cpu_flush_valid                        (_zz_279                                            ), //i
    .io_cpu_flush_ready                        (dataCache_1_io_cpu_flush_ready                     ), //o
    .io_mem_cmd_valid                          (dataCache_1_io_mem_cmd_valid                       ), //o
    .io_mem_cmd_ready                          (dBus_cmd_ready                                     ), //i
    .io_mem_cmd_payload_wr                     (dataCache_1_io_mem_cmd_payload_wr                  ), //o
    .io_mem_cmd_payload_uncached               (dataCache_1_io_mem_cmd_payload_uncached            ), //o
    .io_mem_cmd_payload_address                (dataCache_1_io_mem_cmd_payload_address[31:0]       ), //o
    .io_mem_cmd_payload_data                   (dataCache_1_io_mem_cmd_payload_data[31:0]          ), //o
    .io_mem_cmd_payload_mask                   (dataCache_1_io_mem_cmd_payload_mask[3:0]           ), //o
    .io_mem_cmd_payload_size                   (dataCache_1_io_mem_cmd_payload_size[2:0]           ), //o
    .io_mem_cmd_payload_last                   (dataCache_1_io_mem_cmd_payload_last                ), //o
    .io_mem_rsp_valid                          (dBus_rsp_valid                                     ), //i
    .io_mem_rsp_payload_aggregated             (dBus_rsp_payload_aggregated[2:0]                   ), //i
    .io_mem_rsp_payload_last                   (dBus_rsp_payload_last                              ), //i
    .io_mem_rsp_payload_data                   (dBus_rsp_payload_data[31:0]                        ), //i
    .io_mem_rsp_payload_error                  (dBus_rsp_payload_error                             ), //i
    .clk                                       (clk                                                ), //i
    .reset                                     (reset                                              )  //i
  );
  always @(*) begin
    case(_zz_457)
      2'b00 : begin
        _zz_283 = DBusCachedPlugin_redoBranch_payload;
      end
      2'b01 : begin
        _zz_283 = BranchPlugin_jumpInterface_payload;
      end
      default : begin
        _zz_283 = IBusCachedPlugin_predictionJumpInterface_payload;
      end
    endcase
  end

  always @(*) begin
    case(_zz_458)
      2'b00 : begin
        _zz_284 = writeBack_DBusCachedPlugin_rspSplits_0;
      end
      2'b01 : begin
        _zz_284 = writeBack_DBusCachedPlugin_rspSplits_1;
      end
      2'b10 : begin
        _zz_284 = writeBack_DBusCachedPlugin_rspSplits_2;
      end
      default : begin
        _zz_284 = writeBack_DBusCachedPlugin_rspSplits_3;
      end
    endcase
  end

  always @(*) begin
    case(_zz_459)
      1'b0 : begin
        _zz_285 = writeBack_DBusCachedPlugin_rspSplits_1;
      end
      default : begin
        _zz_285 = writeBack_DBusCachedPlugin_rspSplits_3;
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
    case(decode_BitManipZbbCtrlsignextend)
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotB : decode_BitManipZbbCtrlsignextend_string = "CTRL_SEXTdotB";
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotH : decode_BitManipZbbCtrlsignextend_string = "CTRL_SEXTdotH";
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_ZEXTdotH : decode_BitManipZbbCtrlsignextend_string = "CTRL_ZEXTdotH";
      default : decode_BitManipZbbCtrlsignextend_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(_zz_3)
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotB : _zz_3_string = "CTRL_SEXTdotB";
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotH : _zz_3_string = "CTRL_SEXTdotH";
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_ZEXTdotH : _zz_3_string = "CTRL_ZEXTdotH";
      default : _zz_3_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(_zz_4)
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotB : _zz_4_string = "CTRL_SEXTdotB";
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotH : _zz_4_string = "CTRL_SEXTdotH";
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_ZEXTdotH : _zz_4_string = "CTRL_ZEXTdotH";
      default : _zz_4_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(_zz_5)
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotB : _zz_5_string = "CTRL_SEXTdotB";
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotH : _zz_5_string = "CTRL_SEXTdotH";
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_ZEXTdotH : _zz_5_string = "CTRL_ZEXTdotH";
      default : _zz_5_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(decode_BitManipZbbCtrlcountzeroes)
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CLTZ : decode_BitManipZbbCtrlcountzeroes_string = "CTRL_CLTZ";
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CPOP : decode_BitManipZbbCtrlcountzeroes_string = "CTRL_CPOP";
      default : decode_BitManipZbbCtrlcountzeroes_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_6)
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CLTZ : _zz_6_string = "CTRL_CLTZ";
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CPOP : _zz_6_string = "CTRL_CPOP";
      default : _zz_6_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_7)
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CLTZ : _zz_7_string = "CTRL_CLTZ";
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CPOP : _zz_7_string = "CTRL_CPOP";
      default : _zz_7_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_8)
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CLTZ : _zz_8_string = "CTRL_CLTZ";
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CPOP : _zz_8_string = "CTRL_CPOP";
      default : _zz_8_string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_BitManipZbbCtrlminmax)
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAX : decode_BitManipZbbCtrlminmax_string = "CTRL_MAX ";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAXU : decode_BitManipZbbCtrlminmax_string = "CTRL_MAXU";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MIN : decode_BitManipZbbCtrlminmax_string = "CTRL_MIN ";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MINU : decode_BitManipZbbCtrlminmax_string = "CTRL_MINU";
      default : decode_BitManipZbbCtrlminmax_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_9)
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAX : _zz_9_string = "CTRL_MAX ";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAXU : _zz_9_string = "CTRL_MAXU";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MIN : _zz_9_string = "CTRL_MIN ";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MINU : _zz_9_string = "CTRL_MINU";
      default : _zz_9_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_10)
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAX : _zz_10_string = "CTRL_MAX ";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAXU : _zz_10_string = "CTRL_MAXU";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MIN : _zz_10_string = "CTRL_MIN ";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MINU : _zz_10_string = "CTRL_MINU";
      default : _zz_10_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_11)
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAX : _zz_11_string = "CTRL_MAX ";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAXU : _zz_11_string = "CTRL_MAXU";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MIN : _zz_11_string = "CTRL_MIN ";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MINU : _zz_11_string = "CTRL_MINU";
      default : _zz_11_string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_BitManipZbbCtrlrotation)
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROL : decode_BitManipZbbCtrlrotation_string = "CTRL_ROL";
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROR : decode_BitManipZbbCtrlrotation_string = "CTRL_ROR";
      default : decode_BitManipZbbCtrlrotation_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_12)
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROL : _zz_12_string = "CTRL_ROL";
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROR : _zz_12_string = "CTRL_ROR";
      default : _zz_12_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_13)
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROL : _zz_13_string = "CTRL_ROL";
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROR : _zz_13_string = "CTRL_ROR";
      default : _zz_13_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_14)
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROL : _zz_14_string = "CTRL_ROL";
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROR : _zz_14_string = "CTRL_ROR";
      default : _zz_14_string = "????????";
    endcase
  end
  always @(*) begin
    case(decode_BitManipZbbCtrlbitwise)
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ANDN : decode_BitManipZbbCtrlbitwise_string = "CTRL_ANDN";
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ORN : decode_BitManipZbbCtrlbitwise_string = "CTRL_ORN ";
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_XNOR : decode_BitManipZbbCtrlbitwise_string = "CTRL_XNOR";
      default : decode_BitManipZbbCtrlbitwise_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_15)
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ANDN : _zz_15_string = "CTRL_ANDN";
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ORN : _zz_15_string = "CTRL_ORN ";
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_XNOR : _zz_15_string = "CTRL_XNOR";
      default : _zz_15_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_16)
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ANDN : _zz_16_string = "CTRL_ANDN";
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ORN : _zz_16_string = "CTRL_ORN ";
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_XNOR : _zz_16_string = "CTRL_XNOR";
      default : _zz_16_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_17)
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ANDN : _zz_17_string = "CTRL_ANDN";
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ORN : _zz_17_string = "CTRL_ORN ";
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_XNOR : _zz_17_string = "CTRL_XNOR";
      default : _zz_17_string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_BitManipZbbCtrlgrevorc)
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_ORCdotB : decode_BitManipZbbCtrlgrevorc_string = "CTRL_ORCdotB";
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_REV8 : decode_BitManipZbbCtrlgrevorc_string = "CTRL_REV8   ";
      default : decode_BitManipZbbCtrlgrevorc_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_18)
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_ORCdotB : _zz_18_string = "CTRL_ORCdotB";
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_REV8 : _zz_18_string = "CTRL_REV8   ";
      default : _zz_18_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_19)
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_ORCdotB : _zz_19_string = "CTRL_ORCdotB";
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_REV8 : _zz_19_string = "CTRL_REV8   ";
      default : _zz_19_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_20)
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_ORCdotB : _zz_20_string = "CTRL_ORCdotB";
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_REV8 : _zz_20_string = "CTRL_REV8   ";
      default : _zz_20_string = "????????????";
    endcase
  end
  always @(*) begin
    case(decode_BitManipZbbCtrl)
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_grevorc : decode_BitManipZbbCtrl_string = "CTRL_grevorc    ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_bitwise : decode_BitManipZbbCtrl_string = "CTRL_bitwise    ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_rotation : decode_BitManipZbbCtrl_string = "CTRL_rotation   ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_minmax : decode_BitManipZbbCtrl_string = "CTRL_minmax     ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_countzeroes : decode_BitManipZbbCtrl_string = "CTRL_countzeroes";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_signextend : decode_BitManipZbbCtrl_string = "CTRL_signextend ";
      default : decode_BitManipZbbCtrl_string = "????????????????";
    endcase
  end
  always @(*) begin
    case(_zz_21)
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_grevorc : _zz_21_string = "CTRL_grevorc    ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_bitwise : _zz_21_string = "CTRL_bitwise    ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_rotation : _zz_21_string = "CTRL_rotation   ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_minmax : _zz_21_string = "CTRL_minmax     ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_countzeroes : _zz_21_string = "CTRL_countzeroes";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_signextend : _zz_21_string = "CTRL_signextend ";
      default : _zz_21_string = "????????????????";
    endcase
  end
  always @(*) begin
    case(_zz_22)
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_grevorc : _zz_22_string = "CTRL_grevorc    ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_bitwise : _zz_22_string = "CTRL_bitwise    ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_rotation : _zz_22_string = "CTRL_rotation   ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_minmax : _zz_22_string = "CTRL_minmax     ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_countzeroes : _zz_22_string = "CTRL_countzeroes";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_signextend : _zz_22_string = "CTRL_signextend ";
      default : _zz_22_string = "????????????????";
    endcase
  end
  always @(*) begin
    case(_zz_23)
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_grevorc : _zz_23_string = "CTRL_grevorc    ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_bitwise : _zz_23_string = "CTRL_bitwise    ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_rotation : _zz_23_string = "CTRL_rotation   ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_minmax : _zz_23_string = "CTRL_minmax     ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_countzeroes : _zz_23_string = "CTRL_countzeroes";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_signextend : _zz_23_string = "CTRL_signextend ";
      default : _zz_23_string = "????????????????";
    endcase
  end
  always @(*) begin
    case(decode_BitManipZbaCtrlsh_add)
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH1ADD : decode_BitManipZbaCtrlsh_add_string = "CTRL_SH1ADD";
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH2ADD : decode_BitManipZbaCtrlsh_add_string = "CTRL_SH2ADD";
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH3ADD : decode_BitManipZbaCtrlsh_add_string = "CTRL_SH3ADD";
      default : decode_BitManipZbaCtrlsh_add_string = "???????????";
    endcase
  end
  always @(*) begin
    case(_zz_24)
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH1ADD : _zz_24_string = "CTRL_SH1ADD";
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH2ADD : _zz_24_string = "CTRL_SH2ADD";
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH3ADD : _zz_24_string = "CTRL_SH3ADD";
      default : _zz_24_string = "???????????";
    endcase
  end
  always @(*) begin
    case(_zz_25)
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH1ADD : _zz_25_string = "CTRL_SH1ADD";
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH2ADD : _zz_25_string = "CTRL_SH2ADD";
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH3ADD : _zz_25_string = "CTRL_SH3ADD";
      default : _zz_25_string = "???????????";
    endcase
  end
  always @(*) begin
    case(_zz_26)
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH1ADD : _zz_26_string = "CTRL_SH1ADD";
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH2ADD : _zz_26_string = "CTRL_SH2ADD";
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH3ADD : _zz_26_string = "CTRL_SH3ADD";
      default : _zz_26_string = "???????????";
    endcase
  end
  always @(*) begin
    case(_zz_27)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_27_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_27_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_27_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_27_string = "SRA_1    ";
      default : _zz_27_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_28)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_28_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_28_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_28_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_28_string = "SRA_1    ";
      default : _zz_28_string = "?????????";
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
    case(_zz_29)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_29_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_29_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_29_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_29_string = "SRA_1    ";
      default : _zz_29_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_30)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_30_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_30_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_30_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_30_string = "SRA_1    ";
      default : _zz_30_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_31)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_31_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_31_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_31_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_31_string = "SRA_1    ";
      default : _zz_31_string = "?????????";
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
    case(_zz_32)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_32_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_32_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_32_string = "AND_1";
      default : _zz_32_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_33)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_33_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_33_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_33_string = "AND_1";
      default : _zz_33_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_34)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_34_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_34_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_34_string = "AND_1";
      default : _zz_34_string = "?????";
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
    case(_zz_35)
      `Src3CtrlEnum_defaultEncoding_RS : _zz_35_string = "RS ";
      `Src3CtrlEnum_defaultEncoding_IMI : _zz_35_string = "IMI";
      default : _zz_35_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_36)
      `Src3CtrlEnum_defaultEncoding_RS : _zz_36_string = "RS ";
      `Src3CtrlEnum_defaultEncoding_IMI : _zz_36_string = "IMI";
      default : _zz_36_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_37)
      `Src3CtrlEnum_defaultEncoding_RS : _zz_37_string = "RS ";
      `Src3CtrlEnum_defaultEncoding_IMI : _zz_37_string = "IMI";
      default : _zz_37_string = "???";
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
    case(_zz_38)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_38_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_38_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_38_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_38_string = "PC ";
      default : _zz_38_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_39)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_39_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_39_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_39_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_39_string = "PC ";
      default : _zz_39_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_40)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_40_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_40_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_40_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_40_string = "PC ";
      default : _zz_40_string = "???";
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
    case(_zz_41)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_41_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_41_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_41_string = "BITWISE ";
      default : _zz_41_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_42)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_42_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_42_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_42_string = "BITWISE ";
      default : _zz_42_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_43)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_43_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_43_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_43_string = "BITWISE ";
      default : _zz_43_string = "????????";
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
    case(_zz_44)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_44_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_44_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_44_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_44_string = "URS1        ";
      default : _zz_44_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_45)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_45_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_45_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_45_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_45_string = "URS1        ";
      default : _zz_45_string = "????????????";
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
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : execute_BRANCH_CTRL_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : execute_BRANCH_CTRL_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : execute_BRANCH_CTRL_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : execute_BRANCH_CTRL_string = "JALR";
      default : execute_BRANCH_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_47)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_47_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_47_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_47_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_47_string = "JALR";
      default : _zz_47_string = "????";
    endcase
  end
  always @(*) begin
    case(execute_BitManipZbbCtrl)
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_grevorc : execute_BitManipZbbCtrl_string = "CTRL_grevorc    ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_bitwise : execute_BitManipZbbCtrl_string = "CTRL_bitwise    ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_rotation : execute_BitManipZbbCtrl_string = "CTRL_rotation   ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_minmax : execute_BitManipZbbCtrl_string = "CTRL_minmax     ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_countzeroes : execute_BitManipZbbCtrl_string = "CTRL_countzeroes";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_signextend : execute_BitManipZbbCtrl_string = "CTRL_signextend ";
      default : execute_BitManipZbbCtrl_string = "????????????????";
    endcase
  end
  always @(*) begin
    case(_zz_52)
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_grevorc : _zz_52_string = "CTRL_grevorc    ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_bitwise : _zz_52_string = "CTRL_bitwise    ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_rotation : _zz_52_string = "CTRL_rotation   ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_minmax : _zz_52_string = "CTRL_minmax     ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_countzeroes : _zz_52_string = "CTRL_countzeroes";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_signextend : _zz_52_string = "CTRL_signextend ";
      default : _zz_52_string = "????????????????";
    endcase
  end
  always @(*) begin
    case(execute_BitManipZbbCtrlsignextend)
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotB : execute_BitManipZbbCtrlsignextend_string = "CTRL_SEXTdotB";
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotH : execute_BitManipZbbCtrlsignextend_string = "CTRL_SEXTdotH";
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_ZEXTdotH : execute_BitManipZbbCtrlsignextend_string = "CTRL_ZEXTdotH";
      default : execute_BitManipZbbCtrlsignextend_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(_zz_53)
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotB : _zz_53_string = "CTRL_SEXTdotB";
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotH : _zz_53_string = "CTRL_SEXTdotH";
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_ZEXTdotH : _zz_53_string = "CTRL_ZEXTdotH";
      default : _zz_53_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(execute_BitManipZbbCtrlcountzeroes)
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CLTZ : execute_BitManipZbbCtrlcountzeroes_string = "CTRL_CLTZ";
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CPOP : execute_BitManipZbbCtrlcountzeroes_string = "CTRL_CPOP";
      default : execute_BitManipZbbCtrlcountzeroes_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_54)
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CLTZ : _zz_54_string = "CTRL_CLTZ";
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CPOP : _zz_54_string = "CTRL_CPOP";
      default : _zz_54_string = "?????????";
    endcase
  end
  always @(*) begin
    case(execute_BitManipZbbCtrlminmax)
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAX : execute_BitManipZbbCtrlminmax_string = "CTRL_MAX ";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAXU : execute_BitManipZbbCtrlminmax_string = "CTRL_MAXU";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MIN : execute_BitManipZbbCtrlminmax_string = "CTRL_MIN ";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MINU : execute_BitManipZbbCtrlminmax_string = "CTRL_MINU";
      default : execute_BitManipZbbCtrlminmax_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_55)
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAX : _zz_55_string = "CTRL_MAX ";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAXU : _zz_55_string = "CTRL_MAXU";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MIN : _zz_55_string = "CTRL_MIN ";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MINU : _zz_55_string = "CTRL_MINU";
      default : _zz_55_string = "?????????";
    endcase
  end
  always @(*) begin
    case(execute_BitManipZbbCtrlrotation)
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROL : execute_BitManipZbbCtrlrotation_string = "CTRL_ROL";
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROR : execute_BitManipZbbCtrlrotation_string = "CTRL_ROR";
      default : execute_BitManipZbbCtrlrotation_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_66)
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROL : _zz_66_string = "CTRL_ROL";
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROR : _zz_66_string = "CTRL_ROR";
      default : _zz_66_string = "????????";
    endcase
  end
  always @(*) begin
    case(execute_BitManipZbbCtrlbitwise)
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ANDN : execute_BitManipZbbCtrlbitwise_string = "CTRL_ANDN";
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ORN : execute_BitManipZbbCtrlbitwise_string = "CTRL_ORN ";
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_XNOR : execute_BitManipZbbCtrlbitwise_string = "CTRL_XNOR";
      default : execute_BitManipZbbCtrlbitwise_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_67)
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ANDN : _zz_67_string = "CTRL_ANDN";
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ORN : _zz_67_string = "CTRL_ORN ";
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_XNOR : _zz_67_string = "CTRL_XNOR";
      default : _zz_67_string = "?????????";
    endcase
  end
  always @(*) begin
    case(execute_BitManipZbbCtrlgrevorc)
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_ORCdotB : execute_BitManipZbbCtrlgrevorc_string = "CTRL_ORCdotB";
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_REV8 : execute_BitManipZbbCtrlgrevorc_string = "CTRL_REV8   ";
      default : execute_BitManipZbbCtrlgrevorc_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_68)
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_ORCdotB : _zz_68_string = "CTRL_ORCdotB";
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_REV8 : _zz_68_string = "CTRL_REV8   ";
      default : _zz_68_string = "????????????";
    endcase
  end
  always @(*) begin
    case(execute_BitManipZbaCtrlsh_add)
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH1ADD : execute_BitManipZbaCtrlsh_add_string = "CTRL_SH1ADD";
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH2ADD : execute_BitManipZbaCtrlsh_add_string = "CTRL_SH2ADD";
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH3ADD : execute_BitManipZbaCtrlsh_add_string = "CTRL_SH3ADD";
      default : execute_BitManipZbaCtrlsh_add_string = "???????????";
    endcase
  end
  always @(*) begin
    case(_zz_69)
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH1ADD : _zz_69_string = "CTRL_SH1ADD";
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH2ADD : _zz_69_string = "CTRL_SH2ADD";
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH3ADD : _zz_69_string = "CTRL_SH3ADD";
      default : _zz_69_string = "???????????";
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
    case(_zz_71)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_71_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_71_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_71_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_71_string = "SRA_1    ";
      default : _zz_71_string = "?????????";
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
    case(_zz_72)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_72_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_72_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_72_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_72_string = "SRA_1    ";
      default : _zz_72_string = "?????????";
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
    case(_zz_73)
      `Src3CtrlEnum_defaultEncoding_RS : _zz_73_string = "RS ";
      `Src3CtrlEnum_defaultEncoding_IMI : _zz_73_string = "IMI";
      default : _zz_73_string = "???";
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
    case(_zz_75)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_75_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_75_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_75_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_75_string = "PC ";
      default : _zz_75_string = "???";
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
    case(_zz_76)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_76_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_76_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_76_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_76_string = "URS1        ";
      default : _zz_76_string = "????????????";
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
    case(_zz_77)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_77_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_77_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_77_string = "BITWISE ";
      default : _zz_77_string = "????????";
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
    case(_zz_78)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_78_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_78_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_78_string = "AND_1";
      default : _zz_78_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_82)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_82_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_82_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_82_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_82_string = "JALR";
      default : _zz_82_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_83)
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotB : _zz_83_string = "CTRL_SEXTdotB";
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotH : _zz_83_string = "CTRL_SEXTdotH";
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_ZEXTdotH : _zz_83_string = "CTRL_ZEXTdotH";
      default : _zz_83_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(_zz_84)
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CLTZ : _zz_84_string = "CTRL_CLTZ";
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CPOP : _zz_84_string = "CTRL_CPOP";
      default : _zz_84_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_85)
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAX : _zz_85_string = "CTRL_MAX ";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAXU : _zz_85_string = "CTRL_MAXU";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MIN : _zz_85_string = "CTRL_MIN ";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MINU : _zz_85_string = "CTRL_MINU";
      default : _zz_85_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_86)
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROL : _zz_86_string = "CTRL_ROL";
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROR : _zz_86_string = "CTRL_ROR";
      default : _zz_86_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_87)
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ANDN : _zz_87_string = "CTRL_ANDN";
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ORN : _zz_87_string = "CTRL_ORN ";
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_XNOR : _zz_87_string = "CTRL_XNOR";
      default : _zz_87_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_88)
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_ORCdotB : _zz_88_string = "CTRL_ORCdotB";
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_REV8 : _zz_88_string = "CTRL_REV8   ";
      default : _zz_88_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_89)
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_grevorc : _zz_89_string = "CTRL_grevorc    ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_bitwise : _zz_89_string = "CTRL_bitwise    ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_rotation : _zz_89_string = "CTRL_rotation   ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_minmax : _zz_89_string = "CTRL_minmax     ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_countzeroes : _zz_89_string = "CTRL_countzeroes";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_signextend : _zz_89_string = "CTRL_signextend ";
      default : _zz_89_string = "????????????????";
    endcase
  end
  always @(*) begin
    case(_zz_90)
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH1ADD : _zz_90_string = "CTRL_SH1ADD";
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH2ADD : _zz_90_string = "CTRL_SH2ADD";
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH3ADD : _zz_90_string = "CTRL_SH3ADD";
      default : _zz_90_string = "???????????";
    endcase
  end
  always @(*) begin
    case(_zz_91)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_91_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_91_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_91_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_91_string = "SRA_1    ";
      default : _zz_91_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_92)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_92_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_92_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_92_string = "AND_1";
      default : _zz_92_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_93)
      `Src3CtrlEnum_defaultEncoding_RS : _zz_93_string = "RS ";
      `Src3CtrlEnum_defaultEncoding_IMI : _zz_93_string = "IMI";
      default : _zz_93_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_94)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_94_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_94_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_94_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_94_string = "PC ";
      default : _zz_94_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_95)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_95_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_95_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_95_string = "BITWISE ";
      default : _zz_95_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_96)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_96_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_96_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_96_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_96_string = "URS1        ";
      default : _zz_96_string = "????????????";
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
    case(_zz_98)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_98_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_98_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_98_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_98_string = "JALR";
      default : _zz_98_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_141)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_141_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_141_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_141_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_141_string = "URS1        ";
      default : _zz_141_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_142)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_142_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_142_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_142_string = "BITWISE ";
      default : _zz_142_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_143)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_143_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_143_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_143_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_143_string = "PC ";
      default : _zz_143_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_144)
      `Src3CtrlEnum_defaultEncoding_RS : _zz_144_string = "RS ";
      `Src3CtrlEnum_defaultEncoding_IMI : _zz_144_string = "IMI";
      default : _zz_144_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_145)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_145_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_145_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_145_string = "AND_1";
      default : _zz_145_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_146)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_146_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_146_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_146_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_146_string = "SRA_1    ";
      default : _zz_146_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_147)
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH1ADD : _zz_147_string = "CTRL_SH1ADD";
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH2ADD : _zz_147_string = "CTRL_SH2ADD";
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH3ADD : _zz_147_string = "CTRL_SH3ADD";
      default : _zz_147_string = "???????????";
    endcase
  end
  always @(*) begin
    case(_zz_148)
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_grevorc : _zz_148_string = "CTRL_grevorc    ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_bitwise : _zz_148_string = "CTRL_bitwise    ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_rotation : _zz_148_string = "CTRL_rotation   ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_minmax : _zz_148_string = "CTRL_minmax     ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_countzeroes : _zz_148_string = "CTRL_countzeroes";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_signextend : _zz_148_string = "CTRL_signextend ";
      default : _zz_148_string = "????????????????";
    endcase
  end
  always @(*) begin
    case(_zz_149)
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_ORCdotB : _zz_149_string = "CTRL_ORCdotB";
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_REV8 : _zz_149_string = "CTRL_REV8   ";
      default : _zz_149_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_150)
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ANDN : _zz_150_string = "CTRL_ANDN";
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ORN : _zz_150_string = "CTRL_ORN ";
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_XNOR : _zz_150_string = "CTRL_XNOR";
      default : _zz_150_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_151)
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROL : _zz_151_string = "CTRL_ROL";
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROR : _zz_151_string = "CTRL_ROR";
      default : _zz_151_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_152)
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAX : _zz_152_string = "CTRL_MAX ";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAXU : _zz_152_string = "CTRL_MAXU";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MIN : _zz_152_string = "CTRL_MIN ";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MINU : _zz_152_string = "CTRL_MINU";
      default : _zz_152_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_153)
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CLTZ : _zz_153_string = "CTRL_CLTZ";
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CPOP : _zz_153_string = "CTRL_CPOP";
      default : _zz_153_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_154)
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotB : _zz_154_string = "CTRL_SEXTdotB";
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotH : _zz_154_string = "CTRL_SEXTdotH";
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_ZEXTdotH : _zz_154_string = "CTRL_ZEXTdotH";
      default : _zz_154_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(_zz_155)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_155_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_155_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_155_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_155_string = "JALR";
      default : _zz_155_string = "????";
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
    case(decode_to_execute_BitManipZbaCtrlsh_add)
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH1ADD : decode_to_execute_BitManipZbaCtrlsh_add_string = "CTRL_SH1ADD";
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH2ADD : decode_to_execute_BitManipZbaCtrlsh_add_string = "CTRL_SH2ADD";
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH3ADD : decode_to_execute_BitManipZbaCtrlsh_add_string = "CTRL_SH3ADD";
      default : decode_to_execute_BitManipZbaCtrlsh_add_string = "???????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_BitManipZbbCtrl)
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_grevorc : decode_to_execute_BitManipZbbCtrl_string = "CTRL_grevorc    ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_bitwise : decode_to_execute_BitManipZbbCtrl_string = "CTRL_bitwise    ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_rotation : decode_to_execute_BitManipZbbCtrl_string = "CTRL_rotation   ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_minmax : decode_to_execute_BitManipZbbCtrl_string = "CTRL_minmax     ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_countzeroes : decode_to_execute_BitManipZbbCtrl_string = "CTRL_countzeroes";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_signextend : decode_to_execute_BitManipZbbCtrl_string = "CTRL_signextend ";
      default : decode_to_execute_BitManipZbbCtrl_string = "????????????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_BitManipZbbCtrlgrevorc)
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_ORCdotB : decode_to_execute_BitManipZbbCtrlgrevorc_string = "CTRL_ORCdotB";
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_REV8 : decode_to_execute_BitManipZbbCtrlgrevorc_string = "CTRL_REV8   ";
      default : decode_to_execute_BitManipZbbCtrlgrevorc_string = "????????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_BitManipZbbCtrlbitwise)
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ANDN : decode_to_execute_BitManipZbbCtrlbitwise_string = "CTRL_ANDN";
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ORN : decode_to_execute_BitManipZbbCtrlbitwise_string = "CTRL_ORN ";
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_XNOR : decode_to_execute_BitManipZbbCtrlbitwise_string = "CTRL_XNOR";
      default : decode_to_execute_BitManipZbbCtrlbitwise_string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_BitManipZbbCtrlrotation)
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROL : decode_to_execute_BitManipZbbCtrlrotation_string = "CTRL_ROL";
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROR : decode_to_execute_BitManipZbbCtrlrotation_string = "CTRL_ROR";
      default : decode_to_execute_BitManipZbbCtrlrotation_string = "????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_BitManipZbbCtrlminmax)
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAX : decode_to_execute_BitManipZbbCtrlminmax_string = "CTRL_MAX ";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAXU : decode_to_execute_BitManipZbbCtrlminmax_string = "CTRL_MAXU";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MIN : decode_to_execute_BitManipZbbCtrlminmax_string = "CTRL_MIN ";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MINU : decode_to_execute_BitManipZbbCtrlminmax_string = "CTRL_MINU";
      default : decode_to_execute_BitManipZbbCtrlminmax_string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_BitManipZbbCtrlcountzeroes)
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CLTZ : decode_to_execute_BitManipZbbCtrlcountzeroes_string = "CTRL_CLTZ";
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CPOP : decode_to_execute_BitManipZbbCtrlcountzeroes_string = "CTRL_CPOP";
      default : decode_to_execute_BitManipZbbCtrlcountzeroes_string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_BitManipZbbCtrlsignextend)
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotB : decode_to_execute_BitManipZbbCtrlsignextend_string = "CTRL_SEXTdotB";
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotH : decode_to_execute_BitManipZbbCtrlsignextend_string = "CTRL_SEXTdotH";
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_ZEXTdotH : decode_to_execute_BitManipZbbCtrlsignextend_string = "CTRL_ZEXTdotH";
      default : decode_to_execute_BitManipZbbCtrlsignextend_string = "?????????????";
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
  assign execute_BitManipZbb_FINAL_OUTPUT = _zz_196;
  assign execute_BitManipZba_FINAL_OUTPUT = execute_BitManipZbaPlugin_val_sh_add;
  assign execute_SHIFT_RIGHT = _zz_306;
  assign writeBack_REGFILE_WRITE_DATA_ODD = memory_to_writeBack_REGFILE_WRITE_DATA_ODD;
  assign memory_REGFILE_WRITE_DATA_ODD = execute_to_memory_REGFILE_WRITE_DATA_ODD;
  assign execute_REGFILE_WRITE_DATA_ODD = 32'h0;
  assign execute_REGFILE_WRITE_DATA = _zz_157;
  assign memory_MEMORY_STORE_DATA_RF = execute_to_memory_MEMORY_STORE_DATA_RF;
  assign execute_MEMORY_STORE_DATA_RF = _zz_127;
  assign decode_PREDICTION_HAD_BRANCHED2 = IBusCachedPlugin_decodePrediction_cmd_hadBranch;
  assign decode_SRC2_FORCE_ZERO = (decode_SRC_ADD_ZERO && (! decode_SRC_USE_SUB_LESS));
  assign execute_RS3 = decode_to_execute_RS3;
  assign decode_REGFILE_WRITE_VALID_ODD = _zz_132[43];
  assign _zz_1 = _zz_2;
  assign decode_BitManipZbbCtrlsignextend = _zz_3;
  assign _zz_4 = _zz_5;
  assign decode_BitManipZbbCtrlcountzeroes = _zz_6;
  assign _zz_7 = _zz_8;
  assign decode_BitManipZbbCtrlminmax = _zz_9;
  assign _zz_10 = _zz_11;
  assign decode_BitManipZbbCtrlrotation = _zz_12;
  assign _zz_13 = _zz_14;
  assign decode_BitManipZbbCtrlbitwise = _zz_15;
  assign _zz_16 = _zz_17;
  assign decode_BitManipZbbCtrlgrevorc = _zz_18;
  assign _zz_19 = _zz_20;
  assign decode_BitManipZbbCtrl = _zz_21;
  assign _zz_22 = _zz_23;
  assign execute_IS_BitManipZbb = decode_to_execute_IS_BitManipZbb;
  assign decode_IS_BitManipZbb = _zz_132[26];
  assign decode_BitManipZbaCtrlsh_add = _zz_24;
  assign _zz_25 = _zz_26;
  assign execute_IS_BitManipZba = decode_to_execute_IS_BitManipZba;
  assign decode_IS_BitManipZba = _zz_132[23];
  assign _zz_27 = _zz_28;
  assign decode_SHIFT_CTRL = _zz_29;
  assign _zz_30 = _zz_31;
  assign decode_ALU_BITWISE_CTRL = _zz_32;
  assign _zz_33 = _zz_34;
  assign decode_SRC_LESS_UNSIGNED = _zz_132[17];
  assign decode_SRC3_CTRL = _zz_35;
  assign _zz_36 = _zz_37;
  assign decode_MEMORY_MANAGMENT = _zz_132[15];
  assign decode_MEMORY_WR = _zz_132[13];
  assign execute_BYPASSABLE_MEMORY_STAGE = decode_to_execute_BYPASSABLE_MEMORY_STAGE;
  assign decode_BYPASSABLE_MEMORY_STAGE = _zz_132[12];
  assign decode_BYPASSABLE_EXECUTE_STAGE = _zz_132[11];
  assign decode_SRC2_CTRL = _zz_38;
  assign _zz_39 = _zz_40;
  assign decode_ALU_CTRL = _zz_41;
  assign _zz_42 = _zz_43;
  assign decode_SRC1_CTRL = _zz_44;
  assign _zz_45 = _zz_46;
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
  assign execute_BRANCH_COND_RESULT = _zz_229;
  assign execute_BRANCH_CTRL = _zz_47;
  assign decode_RS3_USE = _zz_132[42];
  assign decode_RS2_USE = _zz_132[14];
  assign decode_RS1_USE = _zz_132[5];
  assign _zz_48 = execute_REGFILE_WRITE_DATA_ODD;
  assign execute_REGFILE_WRITE_VALID_ODD = decode_to_execute_REGFILE_WRITE_VALID_ODD;
  assign _zz_49 = execute_REGFILE_WRITE_DATA;
  assign execute_REGFILE_WRITE_VALID = decode_to_execute_REGFILE_WRITE_VALID;
  assign execute_BYPASSABLE_EXECUTE_STAGE = decode_to_execute_BYPASSABLE_EXECUTE_STAGE;
  assign _zz_50 = memory_REGFILE_WRITE_DATA_ODD;
  assign memory_REGFILE_WRITE_VALID_ODD = execute_to_memory_REGFILE_WRITE_VALID_ODD;
  assign memory_REGFILE_WRITE_VALID = execute_to_memory_REGFILE_WRITE_VALID;
  assign memory_BYPASSABLE_MEMORY_STAGE = execute_to_memory_BYPASSABLE_MEMORY_STAGE;
  assign memory_INSTRUCTION = execute_to_memory_INSTRUCTION;
  assign _zz_51 = writeBack_REGFILE_WRITE_DATA_ODD;
  assign writeBack_REGFILE_WRITE_VALID_ODD = memory_to_writeBack_REGFILE_WRITE_VALID_ODD;
  assign writeBack_REGFILE_WRITE_VALID = memory_to_writeBack_REGFILE_WRITE_VALID;
  always @ (*) begin
    decode_RS3 = decode_RegFilePlugin_rs3Data;
    if(HazardSimplePlugin_writeBackBuffer_valid)begin
      if(HazardSimplePlugin_addr2Match)begin
        decode_RS3 = HazardSimplePlugin_writeBackBuffer_payload_data;
      end
    end
    if(_zz_286)begin
      if(_zz_287)begin
        if(_zz_203)begin
          decode_RS3 = _zz_97;
        end
      end
    end
    if(_zz_288)begin
      if(_zz_289)begin
        if(_zz_206)begin
          decode_RS3 = _zz_51;
        end
      end
    end
    if(_zz_290)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_213)begin
          decode_RS3 = _zz_70;
        end
      end
    end
    if(_zz_291)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_216)begin
          decode_RS3 = _zz_50;
        end
      end
    end
    if(_zz_292)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_223)begin
          decode_RS3 = _zz_49;
        end
      end
    end
    if(_zz_293)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_226)begin
          decode_RS3 = _zz_48;
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
    if(_zz_286)begin
      if(_zz_287)begin
        if(_zz_202)begin
          decode_RS2 = _zz_97;
        end
      end
    end
    if(_zz_288)begin
      if(_zz_289)begin
        if(_zz_205)begin
          decode_RS2 = _zz_51;
        end
      end
    end
    if(_zz_290)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_212)begin
          decode_RS2 = _zz_70;
        end
      end
    end
    if(_zz_291)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_215)begin
          decode_RS2 = _zz_50;
        end
      end
    end
    if(_zz_292)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_222)begin
          decode_RS2 = _zz_49;
        end
      end
    end
    if(_zz_293)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_225)begin
          decode_RS2 = _zz_48;
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
    if(_zz_286)begin
      if(_zz_287)begin
        if(_zz_201)begin
          decode_RS1 = _zz_97;
        end
      end
    end
    if(_zz_288)begin
      if(_zz_289)begin
        if(_zz_204)begin
          decode_RS1 = _zz_51;
        end
      end
    end
    if(_zz_290)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_211)begin
          decode_RS1 = _zz_70;
        end
      end
    end
    if(_zz_291)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_214)begin
          decode_RS1 = _zz_50;
        end
      end
    end
    if(_zz_292)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_221)begin
          decode_RS1 = _zz_49;
        end
      end
    end
    if(_zz_293)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_224)begin
          decode_RS1 = _zz_48;
        end
      end
    end
  end

  assign memory_BitManipZbb_FINAL_OUTPUT = execute_to_memory_BitManipZbb_FINAL_OUTPUT;
  assign memory_IS_BitManipZbb = execute_to_memory_IS_BitManipZbb;
  assign execute_BitManipZbbCtrl = _zz_52;
  assign execute_BitManipZbbCtrlsignextend = _zz_53;
  assign execute_BitManipZbbCtrlcountzeroes = _zz_54;
  assign execute_BitManipZbbCtrlminmax = _zz_55;
  always @ (*) begin
    _zz_56 = _zz_57;
    _zz_56 = (_zz_170[4] ? {_zz_57[15 : 0],_zz_57[31 : 16]} : _zz_57);
  end

  always @ (*) begin
    _zz_57 = _zz_58;
    _zz_57 = (_zz_170[3] ? {_zz_58[7 : 0],_zz_58[31 : 8]} : _zz_58);
  end

  always @ (*) begin
    _zz_58 = _zz_59;
    _zz_58 = (_zz_170[2] ? {_zz_59[3 : 0],_zz_59[31 : 4]} : _zz_59);
  end

  always @ (*) begin
    _zz_59 = _zz_60;
    _zz_59 = (_zz_170[1] ? {_zz_60[1 : 0],_zz_60[31 : 2]} : _zz_60);
  end

  always @ (*) begin
    _zz_60 = _zz_171;
    _zz_60 = (_zz_170[0] ? {_zz_171[0 : 0],_zz_171[31 : 1]} : _zz_171);
  end

  always @ (*) begin
    _zz_61 = _zz_62;
    _zz_61 = (_zz_168[4] ? {_zz_62[15 : 0],_zz_62[31 : 16]} : _zz_62);
  end

  always @ (*) begin
    _zz_62 = _zz_63;
    _zz_62 = (_zz_168[3] ? {_zz_63[23 : 0],_zz_63[31 : 24]} : _zz_63);
  end

  always @ (*) begin
    _zz_63 = _zz_64;
    _zz_63 = (_zz_168[2] ? {_zz_64[27 : 0],_zz_64[31 : 28]} : _zz_64);
  end

  always @ (*) begin
    _zz_64 = _zz_65;
    _zz_64 = (_zz_168[1] ? {_zz_65[29 : 0],_zz_65[31 : 30]} : _zz_65);
  end

  always @ (*) begin
    _zz_65 = _zz_169;
    _zz_65 = (_zz_168[0] ? {_zz_169[30 : 0],_zz_169[31 : 31]} : _zz_169);
  end

  assign execute_BitManipZbbCtrlrotation = _zz_66;
  assign execute_BitManipZbbCtrlbitwise = _zz_67;
  assign execute_BitManipZbbCtrlgrevorc = _zz_68;
  assign memory_BitManipZba_FINAL_OUTPUT = execute_to_memory_BitManipZba_FINAL_OUTPUT;
  assign memory_IS_BitManipZba = execute_to_memory_IS_BitManipZba;
  assign execute_BitManipZbaCtrlsh_add = _zz_69;
  assign memory_SHIFT_RIGHT = execute_to_memory_SHIFT_RIGHT;
  always @ (*) begin
    _zz_70 = memory_REGFILE_WRITE_DATA;
    if(memory_arbitration_isValid)begin
      case(memory_SHIFT_CTRL)
        `ShiftCtrlEnum_defaultEncoding_SLL_1 : begin
          _zz_70 = _zz_165;
        end
        `ShiftCtrlEnum_defaultEncoding_SRL_1, `ShiftCtrlEnum_defaultEncoding_SRA_1 : begin
          _zz_70 = memory_SHIFT_RIGHT;
        end
        default : begin
        end
      endcase
    end
    if((memory_arbitration_isValid && memory_IS_BitManipZba))begin
      _zz_70 = memory_BitManipZba_FINAL_OUTPUT;
    end
    if((memory_arbitration_isValid && memory_IS_BitManipZbb))begin
      _zz_70 = memory_BitManipZbb_FINAL_OUTPUT;
    end
  end

  assign memory_SHIFT_CTRL = _zz_71;
  assign execute_SHIFT_CTRL = _zz_72;
  assign execute_SRC_LESS_UNSIGNED = decode_to_execute_SRC_LESS_UNSIGNED;
  assign execute_SRC2_FORCE_ZERO = decode_to_execute_SRC2_FORCE_ZERO;
  assign execute_SRC_USE_SUB_LESS = decode_to_execute_SRC_USE_SUB_LESS;
  assign execute_SRC3_CTRL = _zz_73;
  assign _zz_74 = execute_PC;
  assign execute_SRC2_CTRL = _zz_75;
  assign execute_SRC1_CTRL = _zz_76;
  assign decode_SRC_USE_SUB_LESS = _zz_132[3];
  assign decode_SRC_ADD_ZERO = _zz_132[20];
  assign execute_SRC_ADD_SUB = execute_SrcPlugin_addSub;
  assign execute_SRC_LESS = execute_SrcPlugin_less;
  assign execute_ALU_CTRL = _zz_77;
  assign execute_SRC2 = _zz_163;
  assign execute_SRC1 = _zz_158;
  assign execute_ALU_BITWISE_CTRL = _zz_78;
  assign _zz_79 = writeBack_REGFILE_WRITE_VALID;
  always @ (*) begin
    _zz_80 = 1'b0;
    if(lastStageRegFileWrite_valid)begin
      _zz_80 = 1'b1;
    end
  end

  assign _zz_81 = writeBack_INSTRUCTION;
  assign decode_INSTRUCTION_ANTICIPATED = (decode_arbitration_isStuck ? decode_INSTRUCTION : IBusCachedPlugin_cache_io_cpu_fetch_data);
  always @ (*) begin
    decode_REGFILE_WRITE_VALID = _zz_132[10];
    if((decode_INSTRUCTION[11 : 7] == 5'h0))begin
      decode_REGFILE_WRITE_VALID = 1'b0;
    end
  end

  always @ (*) begin
    _zz_97 = writeBack_REGFILE_WRITE_DATA;
    if((writeBack_arbitration_isValid && writeBack_MEMORY_ENABLE))begin
      _zz_97 = writeBack_DBusCachedPlugin_rspFormated;
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
  assign decode_MEMORY_ENABLE = _zz_132[4];
  assign decode_FLUSH_ALL = _zz_132[0];
  always @ (*) begin
    IBusCachedPlugin_rsp_issueDetected_2 = IBusCachedPlugin_rsp_issueDetected_1;
    if(_zz_294)begin
      IBusCachedPlugin_rsp_issueDetected_2 = 1'b1;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_rsp_issueDetected_1 = IBusCachedPlugin_rsp_issueDetected;
    if(_zz_295)begin
      IBusCachedPlugin_rsp_issueDetected_1 = 1'b1;
    end
  end

  assign decode_BRANCH_CTRL = _zz_98;
  assign decode_INSTRUCTION = IBusCachedPlugin_iBusRsp_output_payload_rsp_inst;
  always @ (*) begin
    _zz_99 = memory_FORMAL_PC_NEXT;
    if(BranchPlugin_jumpInterface_valid)begin
      _zz_99 = BranchPlugin_jumpInterface_payload;
    end
  end

  always @ (*) begin
    _zz_100 = decode_FORMAL_PC_NEXT;
    if(IBusCachedPlugin_predictionJumpInterface_valid)begin
      _zz_100 = IBusCachedPlugin_predictionJumpInterface_payload;
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
    if(((_zz_279 && (! dataCache_1_io_cpu_flush_ready)) || dataCache_1_io_cpu_execute_haltIt))begin
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
    if((_zz_266 && dataCache_1_io_cpu_writeBack_haltIt))begin
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
  assign _zz_101 = {IBusCachedPlugin_predictionJumpInterface_valid,{BranchPlugin_jumpInterface_valid,DBusCachedPlugin_redoBranch_valid}};
  assign _zz_102 = (_zz_101 & (~ _zz_308));
  assign _zz_103 = _zz_102[1];
  assign _zz_104 = _zz_102[2];
  assign IBusCachedPlugin_jump_pcLoad_payload = _zz_283;
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
    IBusCachedPlugin_fetchPc_pc = (IBusCachedPlugin_fetchPc_pcReg + _zz_310);
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

  assign _zz_105 = (! IBusCachedPlugin_iBusRsp_stages_0_halt);
  assign IBusCachedPlugin_iBusRsp_stages_0_input_ready = (IBusCachedPlugin_iBusRsp_stages_0_output_ready && _zz_105);
  assign IBusCachedPlugin_iBusRsp_stages_0_output_valid = (IBusCachedPlugin_iBusRsp_stages_0_input_valid && _zz_105);
  assign IBusCachedPlugin_iBusRsp_stages_0_output_payload = IBusCachedPlugin_iBusRsp_stages_0_input_payload;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_stages_1_halt = 1'b0;
    if(IBusCachedPlugin_mmuBus_busy)begin
      IBusCachedPlugin_iBusRsp_stages_1_halt = 1'b1;
    end
  end

  assign _zz_106 = (! IBusCachedPlugin_iBusRsp_stages_1_halt);
  assign IBusCachedPlugin_iBusRsp_stages_1_input_ready = (IBusCachedPlugin_iBusRsp_stages_1_output_ready && _zz_106);
  assign IBusCachedPlugin_iBusRsp_stages_1_output_valid = (IBusCachedPlugin_iBusRsp_stages_1_input_valid && _zz_106);
  assign IBusCachedPlugin_iBusRsp_stages_1_output_payload = IBusCachedPlugin_iBusRsp_stages_1_input_payload;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_stages_2_halt = 1'b0;
    if((IBusCachedPlugin_rsp_issueDetected_2 || IBusCachedPlugin_rsp_iBusRspOutputHalt))begin
      IBusCachedPlugin_iBusRsp_stages_2_halt = 1'b1;
    end
  end

  assign _zz_107 = (! IBusCachedPlugin_iBusRsp_stages_2_halt);
  assign IBusCachedPlugin_iBusRsp_stages_2_input_ready = (IBusCachedPlugin_iBusRsp_stages_2_output_ready && _zz_107);
  assign IBusCachedPlugin_iBusRsp_stages_2_output_valid = (IBusCachedPlugin_iBusRsp_stages_2_input_valid && _zz_107);
  assign IBusCachedPlugin_iBusRsp_stages_2_output_payload = IBusCachedPlugin_iBusRsp_stages_2_input_payload;
  assign IBusCachedPlugin_fetchPc_redo_valid = IBusCachedPlugin_iBusRsp_redoFetch;
  assign IBusCachedPlugin_fetchPc_redo_payload = IBusCachedPlugin_iBusRsp_stages_2_input_payload;
  assign IBusCachedPlugin_iBusRsp_flush = ((decode_arbitration_removeIt || (decode_arbitration_flushNext && (! decode_arbitration_isStuck))) || IBusCachedPlugin_iBusRsp_redoFetch);
  assign IBusCachedPlugin_iBusRsp_stages_0_output_ready = _zz_108;
  assign _zz_108 = ((1'b0 && (! _zz_109)) || IBusCachedPlugin_iBusRsp_stages_1_input_ready);
  assign _zz_109 = _zz_110;
  assign IBusCachedPlugin_iBusRsp_stages_1_input_valid = _zz_109;
  assign IBusCachedPlugin_iBusRsp_stages_1_input_payload = IBusCachedPlugin_fetchPc_pcReg;
  assign IBusCachedPlugin_iBusRsp_stages_1_output_ready = ((1'b0 && (! _zz_111)) || IBusCachedPlugin_iBusRsp_stages_2_input_ready);
  assign _zz_111 = _zz_112;
  assign IBusCachedPlugin_iBusRsp_stages_2_input_valid = _zz_111;
  assign IBusCachedPlugin_iBusRsp_stages_2_input_payload = _zz_113;
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
  assign _zz_114 = _zz_311[11];
  always @ (*) begin
    _zz_115[18] = _zz_114;
    _zz_115[17] = _zz_114;
    _zz_115[16] = _zz_114;
    _zz_115[15] = _zz_114;
    _zz_115[14] = _zz_114;
    _zz_115[13] = _zz_114;
    _zz_115[12] = _zz_114;
    _zz_115[11] = _zz_114;
    _zz_115[10] = _zz_114;
    _zz_115[9] = _zz_114;
    _zz_115[8] = _zz_114;
    _zz_115[7] = _zz_114;
    _zz_115[6] = _zz_114;
    _zz_115[5] = _zz_114;
    _zz_115[4] = _zz_114;
    _zz_115[3] = _zz_114;
    _zz_115[2] = _zz_114;
    _zz_115[1] = _zz_114;
    _zz_115[0] = _zz_114;
  end

  always @ (*) begin
    IBusCachedPlugin_decodePrediction_cmd_hadBranch = ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) || ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_B) && _zz_312[31]));
    if(_zz_120)begin
      IBusCachedPlugin_decodePrediction_cmd_hadBranch = 1'b0;
    end
  end

  assign _zz_116 = _zz_313[19];
  always @ (*) begin
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

  assign _zz_118 = _zz_314[11];
  always @ (*) begin
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
    case(decode_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_120 = _zz_315[1];
      end
      default : begin
        _zz_120 = _zz_316[1];
      end
    endcase
  end

  assign IBusCachedPlugin_predictionJumpInterface_valid = (decode_arbitration_isValid && IBusCachedPlugin_decodePrediction_cmd_hadBranch);
  assign _zz_121 = _zz_317[19];
  always @ (*) begin
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

  assign _zz_123 = _zz_318[11];
  always @ (*) begin
    _zz_124[18] = _zz_123;
    _zz_124[17] = _zz_123;
    _zz_124[16] = _zz_123;
    _zz_124[15] = _zz_123;
    _zz_124[14] = _zz_123;
    _zz_124[13] = _zz_123;
    _zz_124[12] = _zz_123;
    _zz_124[11] = _zz_123;
    _zz_124[10] = _zz_123;
    _zz_124[9] = _zz_123;
    _zz_124[8] = _zz_123;
    _zz_124[7] = _zz_123;
    _zz_124[6] = _zz_123;
    _zz_124[5] = _zz_123;
    _zz_124[4] = _zz_123;
    _zz_124[3] = _zz_123;
    _zz_124[2] = _zz_123;
    _zz_124[1] = _zz_123;
    _zz_124[0] = _zz_123;
  end

  assign IBusCachedPlugin_predictionJumpInterface_payload = (decode_PC + ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) ? {{_zz_122,{{{_zz_460,decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]}},1'b0} : {{_zz_124,{{{_zz_461,_zz_462},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0}));
  assign iBus_cmd_valid = IBusCachedPlugin_cache_io_mem_cmd_valid;
  always @ (*) begin
    iBus_cmd_payload_address = IBusCachedPlugin_cache_io_mem_cmd_payload_address;
    iBus_cmd_payload_address = IBusCachedPlugin_cache_io_mem_cmd_payload_address;
  end

  assign iBus_cmd_payload_size = IBusCachedPlugin_cache_io_mem_cmd_payload_size;
  assign IBusCachedPlugin_s0_tightlyCoupledHit = 1'b0;
  assign _zz_253 = (IBusCachedPlugin_iBusRsp_stages_0_input_valid && (! IBusCachedPlugin_s0_tightlyCoupledHit));
  assign _zz_254 = (IBusCachedPlugin_iBusRsp_stages_1_input_valid && (! IBusCachedPlugin_s1_tightlyCoupledHit));
  assign _zz_255 = (! IBusCachedPlugin_iBusRsp_stages_1_input_ready);
  assign IBusCachedPlugin_mmuBus_cmd_0_isValid = _zz_254;
  assign IBusCachedPlugin_mmuBus_cmd_0_isStuck = (! IBusCachedPlugin_iBusRsp_stages_1_input_ready);
  assign IBusCachedPlugin_mmuBus_cmd_0_virtualAddress = IBusCachedPlugin_iBusRsp_stages_1_input_payload;
  assign IBusCachedPlugin_mmuBus_cmd_0_bypassTranslation = 1'b0;
  assign IBusCachedPlugin_mmuBus_end = (IBusCachedPlugin_iBusRsp_stages_1_input_ready || IBusCachedPlugin_externalFlush);
  assign _zz_257 = (IBusCachedPlugin_iBusRsp_stages_2_input_valid && (! IBusCachedPlugin_s2_tightlyCoupledHit));
  assign _zz_258 = (! IBusCachedPlugin_iBusRsp_stages_2_input_ready);
  assign _zz_259 = 1'b0;
  assign IBusCachedPlugin_rsp_iBusRspOutputHalt = 1'b0;
  assign IBusCachedPlugin_rsp_issueDetected = 1'b0;
  always @ (*) begin
    IBusCachedPlugin_rsp_redoFetch = 1'b0;
    if(_zz_295)begin
      IBusCachedPlugin_rsp_redoFetch = 1'b1;
    end
    if(_zz_294)begin
      IBusCachedPlugin_rsp_redoFetch = 1'b1;
    end
  end

  always @ (*) begin
    _zz_260 = (IBusCachedPlugin_rsp_redoFetch && (! IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling));
    if(_zz_294)begin
      _zz_260 = 1'b1;
    end
  end

  assign IBusCachedPlugin_iBusRsp_output_valid = IBusCachedPlugin_iBusRsp_stages_2_output_valid;
  assign IBusCachedPlugin_iBusRsp_stages_2_output_ready = IBusCachedPlugin_iBusRsp_output_ready;
  assign IBusCachedPlugin_iBusRsp_output_payload_rsp_inst = IBusCachedPlugin_cache_io_cpu_decode_data;
  assign IBusCachedPlugin_iBusRsp_output_payload_pc = IBusCachedPlugin_iBusRsp_stages_2_output_payload;
  assign _zz_252 = (decode_arbitration_isValid && decode_FLUSH_ALL);
  assign dBus_cmd_valid = dataCache_1_io_mem_cmd_valid;
  assign dBus_cmd_payload_wr = dataCache_1_io_mem_cmd_payload_wr;
  assign dBus_cmd_payload_uncached = dataCache_1_io_mem_cmd_payload_uncached;
  assign dBus_cmd_payload_address = dataCache_1_io_mem_cmd_payload_address;
  assign dBus_cmd_payload_data = dataCache_1_io_mem_cmd_payload_data;
  assign dBus_cmd_payload_mask = dataCache_1_io_mem_cmd_payload_mask;
  assign dBus_cmd_payload_size = dataCache_1_io_mem_cmd_payload_size;
  assign dBus_cmd_payload_last = dataCache_1_io_mem_cmd_payload_last;
  assign execute_DBusCachedPlugin_size = execute_INSTRUCTION[13 : 12];
  assign _zz_261 = (execute_arbitration_isValid && execute_MEMORY_ENABLE);
  assign _zz_262 = execute_SRC_ADD;
  always @ (*) begin
    case(execute_DBusCachedPlugin_size)
      2'b00 : begin
        _zz_127 = {{{execute_RS2[7 : 0],execute_RS2[7 : 0]},execute_RS2[7 : 0]},execute_RS2[7 : 0]};
      end
      2'b01 : begin
        _zz_127 = {execute_RS2[15 : 0],execute_RS2[15 : 0]};
      end
      default : begin
        _zz_127 = execute_RS2[31 : 0];
      end
    endcase
  end

  assign _zz_279 = (execute_arbitration_isValid && execute_MEMORY_MANAGMENT);
  assign _zz_263 = (memory_arbitration_isValid && memory_MEMORY_ENABLE);
  assign _zz_264 = memory_REGFILE_WRITE_DATA;
  assign DBusCachedPlugin_mmuBus_cmd_0_isValid = _zz_263;
  assign DBusCachedPlugin_mmuBus_cmd_0_isStuck = memory_arbitration_isStuck;
  assign DBusCachedPlugin_mmuBus_cmd_0_virtualAddress = _zz_264;
  assign DBusCachedPlugin_mmuBus_cmd_0_bypassTranslation = 1'b0;
  assign DBusCachedPlugin_mmuBus_end = ((! memory_arbitration_isStuck) || memory_arbitration_removeIt);
  always @ (*) begin
    _zz_265 = DBusCachedPlugin_mmuBus_rsp_isIoAccess;
    if((1'b0 && (! dataCache_1_io_cpu_memory_isWrite)))begin
      _zz_265 = 1'b1;
    end
  end

  always @ (*) begin
    _zz_266 = (writeBack_arbitration_isValid && writeBack_MEMORY_ENABLE);
    if(writeBack_arbitration_haltByOther)begin
      _zz_266 = 1'b0;
    end
  end

  assign _zz_267 = 1'b0;
  assign _zz_269 = writeBack_REGFILE_WRITE_DATA;
  assign _zz_268[31 : 0] = writeBack_MEMORY_STORE_DATA_RF;
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
    writeBack_DBusCachedPlugin_rspShifted[7 : 0] = _zz_284;
    writeBack_DBusCachedPlugin_rspShifted[15 : 8] = _zz_285;
    writeBack_DBusCachedPlugin_rspShifted[23 : 16] = writeBack_DBusCachedPlugin_rspSplits_2;
    writeBack_DBusCachedPlugin_rspShifted[31 : 24] = writeBack_DBusCachedPlugin_rspSplits_3;
  end

  assign writeBack_DBusCachedPlugin_rspRf = writeBack_DBusCachedPlugin_rspShifted[31 : 0];
  assign _zz_128 = (writeBack_DBusCachedPlugin_rspRf[7] && (! writeBack_INSTRUCTION[14]));
  always @ (*) begin
    _zz_129[31] = _zz_128;
    _zz_129[30] = _zz_128;
    _zz_129[29] = _zz_128;
    _zz_129[28] = _zz_128;
    _zz_129[27] = _zz_128;
    _zz_129[26] = _zz_128;
    _zz_129[25] = _zz_128;
    _zz_129[24] = _zz_128;
    _zz_129[23] = _zz_128;
    _zz_129[22] = _zz_128;
    _zz_129[21] = _zz_128;
    _zz_129[20] = _zz_128;
    _zz_129[19] = _zz_128;
    _zz_129[18] = _zz_128;
    _zz_129[17] = _zz_128;
    _zz_129[16] = _zz_128;
    _zz_129[15] = _zz_128;
    _zz_129[14] = _zz_128;
    _zz_129[13] = _zz_128;
    _zz_129[12] = _zz_128;
    _zz_129[11] = _zz_128;
    _zz_129[10] = _zz_128;
    _zz_129[9] = _zz_128;
    _zz_129[8] = _zz_128;
    _zz_129[7 : 0] = writeBack_DBusCachedPlugin_rspRf[7 : 0];
  end

  assign _zz_130 = (writeBack_DBusCachedPlugin_rspRf[15] && (! writeBack_INSTRUCTION[14]));
  always @ (*) begin
    _zz_131[31] = _zz_130;
    _zz_131[30] = _zz_130;
    _zz_131[29] = _zz_130;
    _zz_131[28] = _zz_130;
    _zz_131[27] = _zz_130;
    _zz_131[26] = _zz_130;
    _zz_131[25] = _zz_130;
    _zz_131[24] = _zz_130;
    _zz_131[23] = _zz_130;
    _zz_131[22] = _zz_130;
    _zz_131[21] = _zz_130;
    _zz_131[20] = _zz_130;
    _zz_131[19] = _zz_130;
    _zz_131[18] = _zz_130;
    _zz_131[17] = _zz_130;
    _zz_131[16] = _zz_130;
    _zz_131[15 : 0] = writeBack_DBusCachedPlugin_rspRf[15 : 0];
  end

  always @ (*) begin
    case(_zz_303)
      2'b00 : begin
        writeBack_DBusCachedPlugin_rspFormated = _zz_129;
      end
      2'b01 : begin
        writeBack_DBusCachedPlugin_rspFormated = _zz_131;
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
  assign IBusCachedPlugin_mmuBus_rsp_isIoAccess = (((IBusCachedPlugin_mmuBus_rsp_physicalAddress[31 : 20] == 12'h007) || (IBusCachedPlugin_mmuBus_rsp_physicalAddress[31 : 20] == 12'h8fe)) || (IBusCachedPlugin_mmuBus_rsp_physicalAddress[31 : 20] == 12'h8ff));
  assign IBusCachedPlugin_mmuBus_rsp_isPaging = 1'b0;
  assign IBusCachedPlugin_mmuBus_rsp_exception = 1'b0;
  assign IBusCachedPlugin_mmuBus_rsp_refilling = 1'b0;
  assign IBusCachedPlugin_mmuBus_busy = 1'b0;
  assign DBusCachedPlugin_mmuBus_rsp_physicalAddress = DBusCachedPlugin_mmuBus_cmd_0_virtualAddress;
  assign DBusCachedPlugin_mmuBus_rsp_allowRead = 1'b1;
  assign DBusCachedPlugin_mmuBus_rsp_allowWrite = 1'b1;
  assign DBusCachedPlugin_mmuBus_rsp_allowExecute = 1'b1;
  assign DBusCachedPlugin_mmuBus_rsp_isIoAccess = (((DBusCachedPlugin_mmuBus_rsp_physicalAddress[31 : 20] == 12'h007) || (DBusCachedPlugin_mmuBus_rsp_physicalAddress[31 : 20] == 12'h8fe)) || (DBusCachedPlugin_mmuBus_rsp_physicalAddress[31 : 20] == 12'h8ff));
  assign DBusCachedPlugin_mmuBus_rsp_isPaging = 1'b0;
  assign DBusCachedPlugin_mmuBus_rsp_exception = 1'b0;
  assign DBusCachedPlugin_mmuBus_rsp_refilling = 1'b0;
  assign DBusCachedPlugin_mmuBus_busy = 1'b0;
  assign _zz_133 = ((decode_INSTRUCTION & 32'h00000044) == 32'h00000040);
  assign _zz_134 = ((decode_INSTRUCTION & 32'h00000004) == 32'h00000004);
  assign _zz_135 = ((decode_INSTRUCTION & 32'h00000070) == 32'h00000020);
  assign _zz_136 = ((decode_INSTRUCTION & 32'h00000048) == 32'h00000048);
  assign _zz_137 = ((decode_INSTRUCTION & 32'h00000010) == 32'h00000010);
  assign _zz_138 = ((decode_INSTRUCTION & 32'h00003000) == 32'h00002000);
  assign _zz_139 = ((decode_INSTRUCTION & 32'h00001000) == 32'h00001000);
  assign _zz_140 = ((decode_INSTRUCTION & 32'h00002000) == 32'h0);
  assign _zz_132 = {1'b0,{1'b0,{({_zz_136,_zz_463} != 2'b00),{(_zz_464 != 1'b0),{(_zz_465 != _zz_466),{_zz_467,{_zz_468,_zz_469}}}}}}};
  assign _zz_141 = _zz_132[2 : 1];
  assign _zz_96 = _zz_141;
  assign _zz_142 = _zz_132[7 : 6];
  assign _zz_95 = _zz_142;
  assign _zz_143 = _zz_132[9 : 8];
  assign _zz_94 = _zz_143;
  assign _zz_144 = _zz_132[16 : 16];
  assign _zz_93 = _zz_144;
  assign _zz_145 = _zz_132[19 : 18];
  assign _zz_92 = _zz_145;
  assign _zz_146 = _zz_132[22 : 21];
  assign _zz_91 = _zz_146;
  assign _zz_147 = _zz_132[25 : 24];
  assign _zz_90 = _zz_147;
  assign _zz_148 = _zz_132[29 : 27];
  assign _zz_89 = _zz_148;
  assign _zz_149 = _zz_132[30 : 30];
  assign _zz_88 = _zz_149;
  assign _zz_150 = _zz_132[32 : 31];
  assign _zz_87 = _zz_150;
  assign _zz_151 = _zz_132[33 : 33];
  assign _zz_86 = _zz_151;
  assign _zz_152 = _zz_132[35 : 34];
  assign _zz_85 = _zz_152;
  assign _zz_153 = _zz_132[36 : 36];
  assign _zz_84 = _zz_153;
  assign _zz_154 = _zz_132[38 : 37];
  assign _zz_83 = _zz_154;
  assign _zz_155 = _zz_132[41 : 40];
  assign _zz_82 = _zz_155;
  assign decode_RegFilePlugin_regFileReadAddress1 = decode_INSTRUCTION_ANTICIPATED[19 : 15];
  assign decode_RegFilePlugin_regFileReadAddress2 = decode_INSTRUCTION_ANTICIPATED[24 : 20];
  assign decode_RegFilePlugin_regFileReadAddress3 = ((decode_INSTRUCTION_ANTICIPATED[6 : 0] == 7'h77) ? decode_INSTRUCTION_ANTICIPATED[11 : 7] : decode_INSTRUCTION_ANTICIPATED[31 : 27]);
  assign decode_RegFilePlugin_rs1Data = _zz_280;
  assign decode_RegFilePlugin_rs2Data = _zz_281;
  assign decode_RegFilePlugin_rs3Data = _zz_282;
  assign writeBack_RegFilePlugin_rdIndex = _zz_81[11 : 7];
  always @ (*) begin
    lastStageRegFileWrite_valid = (_zz_79 && writeBack_arbitration_isFiring);
    if(_zz_156)begin
      lastStageRegFileWrite_valid = 1'b1;
    end
  end

  always @ (*) begin
    lastStageRegFileWrite_payload_address = writeBack_RegFilePlugin_rdIndex;
    if(_zz_156)begin
      lastStageRegFileWrite_payload_address = 5'h0;
    end
  end

  always @ (*) begin
    lastStageRegFileWrite_payload_data = _zz_97;
    if(_zz_156)begin
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
        _zz_157 = execute_IntAluPlugin_bitwise;
      end
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : begin
        _zz_157 = {31'd0, _zz_319};
      end
      default : begin
        _zz_157 = execute_SRC_ADD_SUB;
      end
    endcase
  end

  always @ (*) begin
    case(execute_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : begin
        _zz_158 = execute_RS1;
      end
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : begin
        _zz_158 = {29'd0, _zz_320};
      end
      `Src1CtrlEnum_defaultEncoding_IMU : begin
        _zz_158 = {execute_INSTRUCTION[31 : 12],12'h0};
      end
      default : begin
        _zz_158 = {27'd0, _zz_321};
      end
    endcase
  end

  assign _zz_159 = execute_INSTRUCTION[31];
  always @ (*) begin
    _zz_160[19] = _zz_159;
    _zz_160[18] = _zz_159;
    _zz_160[17] = _zz_159;
    _zz_160[16] = _zz_159;
    _zz_160[15] = _zz_159;
    _zz_160[14] = _zz_159;
    _zz_160[13] = _zz_159;
    _zz_160[12] = _zz_159;
    _zz_160[11] = _zz_159;
    _zz_160[10] = _zz_159;
    _zz_160[9] = _zz_159;
    _zz_160[8] = _zz_159;
    _zz_160[7] = _zz_159;
    _zz_160[6] = _zz_159;
    _zz_160[5] = _zz_159;
    _zz_160[4] = _zz_159;
    _zz_160[3] = _zz_159;
    _zz_160[2] = _zz_159;
    _zz_160[1] = _zz_159;
    _zz_160[0] = _zz_159;
  end

  assign _zz_161 = _zz_322[11];
  always @ (*) begin
    _zz_162[19] = _zz_161;
    _zz_162[18] = _zz_161;
    _zz_162[17] = _zz_161;
    _zz_162[16] = _zz_161;
    _zz_162[15] = _zz_161;
    _zz_162[14] = _zz_161;
    _zz_162[13] = _zz_161;
    _zz_162[12] = _zz_161;
    _zz_162[11] = _zz_161;
    _zz_162[10] = _zz_161;
    _zz_162[9] = _zz_161;
    _zz_162[8] = _zz_161;
    _zz_162[7] = _zz_161;
    _zz_162[6] = _zz_161;
    _zz_162[5] = _zz_161;
    _zz_162[4] = _zz_161;
    _zz_162[3] = _zz_161;
    _zz_162[2] = _zz_161;
    _zz_162[1] = _zz_161;
    _zz_162[0] = _zz_161;
  end

  always @ (*) begin
    case(execute_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : begin
        _zz_163 = execute_RS2;
      end
      `Src2CtrlEnum_defaultEncoding_IMI : begin
        _zz_163 = {_zz_160,execute_INSTRUCTION[31 : 20]};
      end
      `Src2CtrlEnum_defaultEncoding_IMS : begin
        _zz_163 = {_zz_162,{execute_INSTRUCTION[31 : 25],execute_INSTRUCTION[11 : 7]}};
      end
      default : begin
        _zz_163 = _zz_74;
      end
    endcase
  end

  always @ (*) begin
    execute_SrcPlugin_addSub = _zz_323;
    if(execute_SRC2_FORCE_ZERO)begin
      execute_SrcPlugin_addSub = execute_SRC1;
    end
  end

  assign execute_SrcPlugin_less = ((execute_SRC1[31] == execute_SRC2[31]) ? execute_SrcPlugin_addSub[31] : (execute_SRC_LESS_UNSIGNED ? execute_SRC2[31] : execute_SRC1[31]));
  assign execute_FullBarrelShifterPlugin_amplitude = execute_SRC2[4 : 0];
  always @ (*) begin
    _zz_164[0] = execute_SRC1[31];
    _zz_164[1] = execute_SRC1[30];
    _zz_164[2] = execute_SRC1[29];
    _zz_164[3] = execute_SRC1[28];
    _zz_164[4] = execute_SRC1[27];
    _zz_164[5] = execute_SRC1[26];
    _zz_164[6] = execute_SRC1[25];
    _zz_164[7] = execute_SRC1[24];
    _zz_164[8] = execute_SRC1[23];
    _zz_164[9] = execute_SRC1[22];
    _zz_164[10] = execute_SRC1[21];
    _zz_164[11] = execute_SRC1[20];
    _zz_164[12] = execute_SRC1[19];
    _zz_164[13] = execute_SRC1[18];
    _zz_164[14] = execute_SRC1[17];
    _zz_164[15] = execute_SRC1[16];
    _zz_164[16] = execute_SRC1[15];
    _zz_164[17] = execute_SRC1[14];
    _zz_164[18] = execute_SRC1[13];
    _zz_164[19] = execute_SRC1[12];
    _zz_164[20] = execute_SRC1[11];
    _zz_164[21] = execute_SRC1[10];
    _zz_164[22] = execute_SRC1[9];
    _zz_164[23] = execute_SRC1[8];
    _zz_164[24] = execute_SRC1[7];
    _zz_164[25] = execute_SRC1[6];
    _zz_164[26] = execute_SRC1[5];
    _zz_164[27] = execute_SRC1[4];
    _zz_164[28] = execute_SRC1[3];
    _zz_164[29] = execute_SRC1[2];
    _zz_164[30] = execute_SRC1[1];
    _zz_164[31] = execute_SRC1[0];
  end

  assign execute_FullBarrelShifterPlugin_reversed = ((execute_SHIFT_CTRL == `ShiftCtrlEnum_defaultEncoding_SLL_1) ? _zz_164 : execute_SRC1);
  always @ (*) begin
    _zz_165[0] = memory_SHIFT_RIGHT[31];
    _zz_165[1] = memory_SHIFT_RIGHT[30];
    _zz_165[2] = memory_SHIFT_RIGHT[29];
    _zz_165[3] = memory_SHIFT_RIGHT[28];
    _zz_165[4] = memory_SHIFT_RIGHT[27];
    _zz_165[5] = memory_SHIFT_RIGHT[26];
    _zz_165[6] = memory_SHIFT_RIGHT[25];
    _zz_165[7] = memory_SHIFT_RIGHT[24];
    _zz_165[8] = memory_SHIFT_RIGHT[23];
    _zz_165[9] = memory_SHIFT_RIGHT[22];
    _zz_165[10] = memory_SHIFT_RIGHT[21];
    _zz_165[11] = memory_SHIFT_RIGHT[20];
    _zz_165[12] = memory_SHIFT_RIGHT[19];
    _zz_165[13] = memory_SHIFT_RIGHT[18];
    _zz_165[14] = memory_SHIFT_RIGHT[17];
    _zz_165[15] = memory_SHIFT_RIGHT[16];
    _zz_165[16] = memory_SHIFT_RIGHT[15];
    _zz_165[17] = memory_SHIFT_RIGHT[14];
    _zz_165[18] = memory_SHIFT_RIGHT[13];
    _zz_165[19] = memory_SHIFT_RIGHT[12];
    _zz_165[20] = memory_SHIFT_RIGHT[11];
    _zz_165[21] = memory_SHIFT_RIGHT[10];
    _zz_165[22] = memory_SHIFT_RIGHT[9];
    _zz_165[23] = memory_SHIFT_RIGHT[8];
    _zz_165[24] = memory_SHIFT_RIGHT[7];
    _zz_165[25] = memory_SHIFT_RIGHT[6];
    _zz_165[26] = memory_SHIFT_RIGHT[5];
    _zz_165[27] = memory_SHIFT_RIGHT[4];
    _zz_165[28] = memory_SHIFT_RIGHT[3];
    _zz_165[29] = memory_SHIFT_RIGHT[2];
    _zz_165[30] = memory_SHIFT_RIGHT[1];
    _zz_165[31] = memory_SHIFT_RIGHT[0];
  end

  always @ (*) begin
    case(execute_BitManipZbaCtrlsh_add)
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH1ADD : begin
        execute_BitManipZbaPlugin_val_sh_add = _zz_330;
      end
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH2ADD : begin
        execute_BitManipZbaPlugin_val_sh_add = _zz_332;
      end
      default : begin
        execute_BitManipZbaPlugin_val_sh_add = _zz_334;
      end
    endcase
  end

  assign _zz_166 = ((execute_SRC1 | _zz_336) | _zz_337);
  assign _zz_167 = ((_zz_166 | _zz_338) | _zz_339);
  always @ (*) begin
    case(execute_BitManipZbbCtrlgrevorc)
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_ORCdotB : begin
        execute_BitManipZbbPlugin_val_grevorc = ((_zz_167 | _zz_340) | _zz_341);
      end
      default : begin
        execute_BitManipZbbPlugin_val_grevorc = {{{execute_SRC1[7 : 0],execute_SRC1[15 : 8]},execute_SRC1[23 : 16]},execute_SRC1[31 : 24]};
      end
    endcase
  end

  always @ (*) begin
    case(execute_BitManipZbbCtrlbitwise)
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ANDN : begin
        execute_BitManipZbbPlugin_val_bitwise = (execute_SRC1 & (~ execute_SRC2));
      end
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ORN : begin
        execute_BitManipZbbPlugin_val_bitwise = (execute_SRC1 | (~ execute_SRC2));
      end
      default : begin
        execute_BitManipZbbPlugin_val_bitwise = (execute_SRC1 ^ (~ execute_SRC2));
      end
    endcase
  end

  assign _zz_168 = _zz_342[4 : 0];
  assign _zz_169 = execute_SRC1;
  assign _zz_170 = _zz_343[4 : 0];
  assign _zz_171 = execute_SRC1;
  always @ (*) begin
    case(execute_BitManipZbbCtrlrotation)
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROL : begin
        execute_BitManipZbbPlugin_val_rotation = _zz_61;
      end
      default : begin
        execute_BitManipZbbPlugin_val_rotation = _zz_56;
      end
    endcase
  end

  always @ (*) begin
    case(execute_BitManipZbbCtrlminmax)
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAX : begin
        execute_BitManipZbbPlugin_val_minmax = (($signed(_zz_344) < $signed(_zz_345)) ? execute_SRC1 : execute_SRC2);
      end
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAXU : begin
        execute_BitManipZbbPlugin_val_minmax = ((execute_SRC2 < execute_SRC1) ? execute_SRC1 : execute_SRC2);
      end
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MIN : begin
        execute_BitManipZbbPlugin_val_minmax = (($signed(_zz_346) < $signed(_zz_347)) ? execute_SRC1 : execute_SRC2);
      end
      default : begin
        execute_BitManipZbbPlugin_val_minmax = ((execute_SRC1 < execute_SRC2) ? execute_SRC1 : execute_SRC2);
      end
    endcase
  end

  assign _zz_172 = ((execute_INSTRUCTION[20] == 1'b1) ? {{{{{{{{{{_zz_608,_zz_609},_zz_610},execute_SRC1[24]},execute_SRC1[25]},execute_SRC1[26]},execute_SRC1[27]},execute_SRC1[28]},execute_SRC1[29]},execute_SRC1[30]},execute_SRC1[31]} : execute_SRC1);
  assign _zz_173 = _zz_172[31 : 28];
  assign _zz_174 = {{(! (((_zz_173[0] || _zz_173[1]) || _zz_173[2]) || _zz_173[3])),(! (_zz_173[2] || _zz_173[3]))},(! (_zz_173[3] || (_zz_173[1] && (! _zz_173[2]))))};
  assign _zz_175 = _zz_172[27 : 24];
  assign _zz_176 = {{(! (((_zz_175[0] || _zz_175[1]) || _zz_175[2]) || _zz_175[3])),(! (_zz_175[2] || _zz_175[3]))},(! (_zz_175[3] || (_zz_175[1] && (! _zz_175[2]))))};
  assign _zz_177 = _zz_172[23 : 20];
  assign _zz_178 = {{(! (((_zz_177[0] || _zz_177[1]) || _zz_177[2]) || _zz_177[3])),(! (_zz_177[2] || _zz_177[3]))},(! (_zz_177[3] || (_zz_177[1] && (! _zz_177[2]))))};
  assign _zz_179 = _zz_172[19 : 16];
  assign _zz_180 = {{(! (((_zz_179[0] || _zz_179[1]) || _zz_179[2]) || _zz_179[3])),(! (_zz_179[2] || _zz_179[3]))},(! (_zz_179[3] || (_zz_179[1] && (! _zz_179[2]))))};
  assign _zz_181 = _zz_172[15 : 12];
  assign _zz_182 = {{(! (((_zz_181[0] || _zz_181[1]) || _zz_181[2]) || _zz_181[3])),(! (_zz_181[2] || _zz_181[3]))},(! (_zz_181[3] || (_zz_181[1] && (! _zz_181[2]))))};
  assign _zz_183 = _zz_172[11 : 8];
  assign _zz_184 = {{(! (((_zz_183[0] || _zz_183[1]) || _zz_183[2]) || _zz_183[3])),(! (_zz_183[2] || _zz_183[3]))},(! (_zz_183[3] || (_zz_183[1] && (! _zz_183[2]))))};
  assign _zz_185 = _zz_172[7 : 4];
  assign _zz_186 = {{(! (((_zz_185[0] || _zz_185[1]) || _zz_185[2]) || _zz_185[3])),(! (_zz_185[2] || _zz_185[3]))},(! (_zz_185[3] || (_zz_185[1] && (! _zz_185[2]))))};
  assign _zz_187 = _zz_172[3 : 0];
  assign _zz_188 = {{(! (((_zz_187[0] || _zz_187[1]) || _zz_187[2]) || _zz_187[3])),(! (_zz_187[2] || _zz_187[3]))},(! (_zz_187[3] || (_zz_187[1] && (! _zz_187[2]))))};
  assign _zz_189 = {{{{{{{_zz_188[2],_zz_186[2]},_zz_184[2]},_zz_182[2]},_zz_180[2]},_zz_178[2]},_zz_176[2]},_zz_174[2]};
  assign _zz_190 = (! (_zz_189[0] && _zz_189[1]));
  assign _zz_191 = (! (_zz_189[2] && _zz_189[3]));
  assign _zz_192 = (! (_zz_189[4] && _zz_189[5]));
  assign _zz_193 = (! (_zz_190 || _zz_191));
  assign _zz_194 = {{{(_zz_193 && (! (_zz_192 || _zz_616))),_zz_193},(! (_zz_190 || ((! _zz_191) && _zz_192)))},(! ((! ((! _zz_617) && (_zz_618 && _zz_619))) && (! ((_zz_620 && _zz_621) && _zz_189[0]))))};
  always @ (*) begin
    case(_zz_304)
      3'b000 : begin
        _zz_195 = _zz_174[1 : 0];
      end
      3'b001 : begin
        _zz_195 = _zz_176[1 : 0];
      end
      3'b010 : begin
        _zz_195 = _zz_178[1 : 0];
      end
      3'b011 : begin
        _zz_195 = _zz_180[1 : 0];
      end
      3'b100 : begin
        _zz_195 = _zz_182[1 : 0];
      end
      3'b101 : begin
        _zz_195 = _zz_184[1 : 0];
      end
      3'b110 : begin
        _zz_195 = _zz_186[1 : 0];
      end
      default : begin
        _zz_195 = _zz_188[1 : 0];
      end
    endcase
  end

  always @ (*) begin
    case(execute_BitManipZbbCtrlcountzeroes)
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CLTZ : begin
        execute_BitManipZbbPlugin_val_countzeroes = {26'd0, _zz_348};
      end
      default : begin
        execute_BitManipZbbPlugin_val_countzeroes = {26'd0, _zz_349};
      end
    endcase
  end

  always @ (*) begin
    case(execute_BitManipZbbCtrlsignextend)
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotB : begin
        execute_BitManipZbbPlugin_val_signextend = {(execute_SRC1[7] ? 24'hffffff : 24'h0),execute_SRC1[7 : 0]};
      end
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotH : begin
        execute_BitManipZbbPlugin_val_signextend = {(execute_SRC1[15] ? 16'hffff : 16'h0),execute_SRC1[15 : 0]};
      end
      default : begin
        execute_BitManipZbbPlugin_val_signextend = {16'h0,execute_SRC1[15 : 0]};
      end
    endcase
  end

  always @ (*) begin
    case(execute_BitManipZbbCtrl)
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_grevorc : begin
        _zz_196 = execute_BitManipZbbPlugin_val_grevorc;
      end
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_bitwise : begin
        _zz_196 = execute_BitManipZbbPlugin_val_bitwise;
      end
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_rotation : begin
        _zz_196 = execute_BitManipZbbPlugin_val_rotation;
      end
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_minmax : begin
        _zz_196 = execute_BitManipZbbPlugin_val_minmax;
      end
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_countzeroes : begin
        _zz_196 = execute_BitManipZbbPlugin_val_countzeroes;
      end
      default : begin
        _zz_196 = execute_BitManipZbbPlugin_val_signextend;
      end
    endcase
  end

  always @ (*) begin
    HazardSimplePlugin_src0Hazard = 1'b0;
    if(_zz_296)begin
      if(_zz_297)begin
        if((_zz_201 || _zz_204))begin
          HazardSimplePlugin_src0Hazard = 1'b1;
        end
      end
    end
    if(_zz_298)begin
      if(_zz_299)begin
        if((_zz_211 || _zz_214))begin
          HazardSimplePlugin_src0Hazard = 1'b1;
        end
      end
    end
    if(_zz_300)begin
      if(_zz_301)begin
        if((_zz_221 || _zz_224))begin
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
    if(_zz_296)begin
      if(_zz_297)begin
        if((_zz_202 || _zz_205))begin
          HazardSimplePlugin_src1Hazard = 1'b1;
        end
        if((_zz_203 || _zz_206))begin
          HazardSimplePlugin_src1Hazard = 1'b1;
        end
      end
    end
    if(_zz_298)begin
      if(_zz_299)begin
        if((_zz_212 || _zz_215))begin
          HazardSimplePlugin_src1Hazard = 1'b1;
        end
        if((_zz_213 || _zz_216))begin
          HazardSimplePlugin_src1Hazard = 1'b1;
        end
      end
    end
    if(_zz_300)begin
      if(_zz_301)begin
        if((_zz_222 || _zz_225))begin
          HazardSimplePlugin_src1Hazard = 1'b1;
        end
        if((_zz_223 || _zz_226))begin
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

  assign HazardSimplePlugin_notAES = ((! ((_zz_81 & 32'h3200707f) == 32'h32000033)) && (! ((_zz_81 & 32'h3a00707f) == 32'h30000033)));
  assign HazardSimplePlugin_rdIndex = (HazardSimplePlugin_notAES ? _zz_81[11 : 7] : _zz_81[19 : 15]);
  assign HazardSimplePlugin_regFileReadAddress3 = ((decode_INSTRUCTION[6 : 0] == 7'h77) ? decode_INSTRUCTION[11 : 7] : decode_INSTRUCTION[31 : 27]);
  assign HazardSimplePlugin_writeBackWrites_valid = (_zz_79 && writeBack_arbitration_isFiring);
  assign HazardSimplePlugin_writeBackWrites_payload_address = HazardSimplePlugin_rdIndex;
  assign HazardSimplePlugin_writeBackWrites_payload_data = _zz_97;
  assign HazardSimplePlugin_addr0Match = (HazardSimplePlugin_writeBackBuffer_payload_address == decode_INSTRUCTION[19 : 15]);
  assign HazardSimplePlugin_addr1Match = (HazardSimplePlugin_writeBackBuffer_payload_address == decode_INSTRUCTION[24 : 20]);
  assign HazardSimplePlugin_addr2Match = (HazardSimplePlugin_writeBackBuffer_payload_address == HazardSimplePlugin_regFileReadAddress3);
  assign _zz_197 = ((writeBack_INSTRUCTION & 32'he400707f) == 32'ha0000077);
  assign _zz_198 = (((! ((writeBack_INSTRUCTION & 32'h3200707f) == 32'h32000033)) && (! ((writeBack_INSTRUCTION & 32'h3a00707f) == 32'h30000033))) ? writeBack_INSTRUCTION[11 : 7] : writeBack_INSTRUCTION[19 : 15]);
  assign _zz_199 = (_zz_197 ? (_zz_198 ^ 5'h01) : 5'h0);
  assign _zz_200 = ((decode_INSTRUCTION[6 : 0] == 7'h77) ? decode_INSTRUCTION[11 : 7] : decode_INSTRUCTION[31 : 27]);
  assign _zz_201 = ((_zz_198 != 5'h0) && (_zz_198 == decode_INSTRUCTION[19 : 15]));
  assign _zz_202 = ((_zz_198 != 5'h0) && (_zz_198 == decode_INSTRUCTION[24 : 20]));
  assign _zz_203 = ((_zz_198 != 5'h0) && (_zz_198 == _zz_200));
  assign _zz_204 = ((_zz_199 != 5'h0) && (_zz_199 == decode_INSTRUCTION[19 : 15]));
  assign _zz_205 = ((_zz_199 != 5'h0) && (_zz_199 == decode_INSTRUCTION[24 : 20]));
  assign _zz_206 = ((_zz_199 != 5'h0) && (_zz_199 == _zz_200));
  assign _zz_207 = ((memory_INSTRUCTION & 32'he400707f) == 32'ha0000077);
  assign _zz_208 = (((! ((memory_INSTRUCTION & 32'h3200707f) == 32'h32000033)) && (! ((memory_INSTRUCTION & 32'h3a00707f) == 32'h30000033))) ? memory_INSTRUCTION[11 : 7] : memory_INSTRUCTION[19 : 15]);
  assign _zz_209 = (_zz_207 ? (_zz_208 ^ 5'h01) : 5'h0);
  assign _zz_210 = ((decode_INSTRUCTION[6 : 0] == 7'h77) ? decode_INSTRUCTION[11 : 7] : decode_INSTRUCTION[31 : 27]);
  assign _zz_211 = ((_zz_208 != 5'h0) && (_zz_208 == decode_INSTRUCTION[19 : 15]));
  assign _zz_212 = ((_zz_208 != 5'h0) && (_zz_208 == decode_INSTRUCTION[24 : 20]));
  assign _zz_213 = ((_zz_208 != 5'h0) && (_zz_208 == _zz_210));
  assign _zz_214 = ((_zz_209 != 5'h0) && (_zz_209 == decode_INSTRUCTION[19 : 15]));
  assign _zz_215 = ((_zz_209 != 5'h0) && (_zz_209 == decode_INSTRUCTION[24 : 20]));
  assign _zz_216 = ((_zz_209 != 5'h0) && (_zz_209 == _zz_210));
  assign _zz_217 = ((execute_INSTRUCTION & 32'he400707f) == 32'ha0000077);
  assign _zz_218 = (((! ((execute_INSTRUCTION & 32'h3200707f) == 32'h32000033)) && (! ((execute_INSTRUCTION & 32'h3a00707f) == 32'h30000033))) ? execute_INSTRUCTION[11 : 7] : execute_INSTRUCTION[19 : 15]);
  assign _zz_219 = (_zz_217 ? (_zz_218 ^ 5'h01) : 5'h0);
  assign _zz_220 = ((decode_INSTRUCTION[6 : 0] == 7'h77) ? decode_INSTRUCTION[11 : 7] : decode_INSTRUCTION[31 : 27]);
  assign _zz_221 = ((_zz_218 != 5'h0) && (_zz_218 == decode_INSTRUCTION[19 : 15]));
  assign _zz_222 = ((_zz_218 != 5'h0) && (_zz_218 == decode_INSTRUCTION[24 : 20]));
  assign _zz_223 = ((_zz_218 != 5'h0) && (_zz_218 == _zz_220));
  assign _zz_224 = ((_zz_219 != 5'h0) && (_zz_219 == decode_INSTRUCTION[19 : 15]));
  assign _zz_225 = ((_zz_219 != 5'h0) && (_zz_219 == decode_INSTRUCTION[24 : 20]));
  assign _zz_226 = ((_zz_219 != 5'h0) && (_zz_219 == _zz_220));
  assign execute_BranchPlugin_eq = (execute_SRC1 == execute_SRC2);
  assign _zz_227 = execute_INSTRUCTION[14 : 12];
  always @ (*) begin
    if((_zz_227 == 3'b000)) begin
        _zz_228 = execute_BranchPlugin_eq;
    end else if((_zz_227 == 3'b001)) begin
        _zz_228 = (! execute_BranchPlugin_eq);
    end else if((((_zz_227 & 3'b101) == 3'b101))) begin
        _zz_228 = (! execute_SRC_LESS);
    end else begin
        _zz_228 = execute_SRC_LESS;
    end
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : begin
        _zz_229 = 1'b0;
      end
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_229 = 1'b1;
      end
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        _zz_229 = 1'b1;
      end
      default : begin
        _zz_229 = _zz_228;
      end
    endcase
  end

  assign _zz_230 = execute_INSTRUCTION[31];
  always @ (*) begin
    _zz_231[19] = _zz_230;
    _zz_231[18] = _zz_230;
    _zz_231[17] = _zz_230;
    _zz_231[16] = _zz_230;
    _zz_231[15] = _zz_230;
    _zz_231[14] = _zz_230;
    _zz_231[13] = _zz_230;
    _zz_231[12] = _zz_230;
    _zz_231[11] = _zz_230;
    _zz_231[10] = _zz_230;
    _zz_231[9] = _zz_230;
    _zz_231[8] = _zz_230;
    _zz_231[7] = _zz_230;
    _zz_231[6] = _zz_230;
    _zz_231[5] = _zz_230;
    _zz_231[4] = _zz_230;
    _zz_231[3] = _zz_230;
    _zz_231[2] = _zz_230;
    _zz_231[1] = _zz_230;
    _zz_231[0] = _zz_230;
  end

  assign _zz_232 = _zz_445[19];
  always @ (*) begin
    _zz_233[10] = _zz_232;
    _zz_233[9] = _zz_232;
    _zz_233[8] = _zz_232;
    _zz_233[7] = _zz_232;
    _zz_233[6] = _zz_232;
    _zz_233[5] = _zz_232;
    _zz_233[4] = _zz_232;
    _zz_233[3] = _zz_232;
    _zz_233[2] = _zz_232;
    _zz_233[1] = _zz_232;
    _zz_233[0] = _zz_232;
  end

  assign _zz_234 = _zz_446[11];
  always @ (*) begin
    _zz_235[18] = _zz_234;
    _zz_235[17] = _zz_234;
    _zz_235[16] = _zz_234;
    _zz_235[15] = _zz_234;
    _zz_235[14] = _zz_234;
    _zz_235[13] = _zz_234;
    _zz_235[12] = _zz_234;
    _zz_235[11] = _zz_234;
    _zz_235[10] = _zz_234;
    _zz_235[9] = _zz_234;
    _zz_235[8] = _zz_234;
    _zz_235[7] = _zz_234;
    _zz_235[6] = _zz_234;
    _zz_235[5] = _zz_234;
    _zz_235[4] = _zz_234;
    _zz_235[3] = _zz_234;
    _zz_235[2] = _zz_234;
    _zz_235[1] = _zz_234;
    _zz_235[0] = _zz_234;
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        _zz_236 = (_zz_447[1] ^ execute_RS1[1]);
      end
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_236 = _zz_448[1];
      end
      default : begin
        _zz_236 = _zz_449[1];
      end
    endcase
  end

  assign execute_BranchPlugin_missAlignedTarget = (execute_BRANCH_COND_RESULT && _zz_236);
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

  assign _zz_237 = execute_INSTRUCTION[31];
  always @ (*) begin
    _zz_238[19] = _zz_237;
    _zz_238[18] = _zz_237;
    _zz_238[17] = _zz_237;
    _zz_238[16] = _zz_237;
    _zz_238[15] = _zz_237;
    _zz_238[14] = _zz_237;
    _zz_238[13] = _zz_237;
    _zz_238[12] = _zz_237;
    _zz_238[11] = _zz_237;
    _zz_238[10] = _zz_237;
    _zz_238[9] = _zz_237;
    _zz_238[8] = _zz_237;
    _zz_238[7] = _zz_237;
    _zz_238[6] = _zz_237;
    _zz_238[5] = _zz_237;
    _zz_238[4] = _zz_237;
    _zz_238[3] = _zz_237;
    _zz_238[2] = _zz_237;
    _zz_238[1] = _zz_237;
    _zz_238[0] = _zz_237;
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        execute_BranchPlugin_branch_src2 = {_zz_238,execute_INSTRUCTION[31 : 20]};
      end
      default : begin
        execute_BranchPlugin_branch_src2 = ((execute_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) ? {{_zz_240,{{{_zz_622,execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]}},1'b0} : {{_zz_242,{{{_zz_623,_zz_624},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]}},1'b0});
        if(execute_PREDICTION_HAD_BRANCHED2)begin
          execute_BranchPlugin_branch_src2 = {29'd0, _zz_452};
        end
      end
    endcase
  end

  assign _zz_239 = _zz_450[19];
  always @ (*) begin
    _zz_240[10] = _zz_239;
    _zz_240[9] = _zz_239;
    _zz_240[8] = _zz_239;
    _zz_240[7] = _zz_239;
    _zz_240[6] = _zz_239;
    _zz_240[5] = _zz_239;
    _zz_240[4] = _zz_239;
    _zz_240[3] = _zz_239;
    _zz_240[2] = _zz_239;
    _zz_240[1] = _zz_239;
    _zz_240[0] = _zz_239;
  end

  assign _zz_241 = _zz_451[11];
  always @ (*) begin
    _zz_242[18] = _zz_241;
    _zz_242[17] = _zz_241;
    _zz_242[16] = _zz_241;
    _zz_242[15] = _zz_241;
    _zz_242[14] = _zz_241;
    _zz_242[13] = _zz_241;
    _zz_242[12] = _zz_241;
    _zz_242[11] = _zz_241;
    _zz_242[10] = _zz_241;
    _zz_242[9] = _zz_241;
    _zz_242[8] = _zz_241;
    _zz_242[7] = _zz_241;
    _zz_242[6] = _zz_241;
    _zz_242[5] = _zz_241;
    _zz_242[4] = _zz_241;
    _zz_242[3] = _zz_241;
    _zz_242[2] = _zz_241;
    _zz_242[1] = _zz_241;
    _zz_242[0] = _zz_241;
  end

  assign execute_BranchPlugin_branchAdder = (execute_BranchPlugin_branch_src1 + execute_BranchPlugin_branch_src2);
  assign BranchPlugin_jumpInterface_valid = ((memory_arbitration_isValid && memory_BRANCH_DO) && (! 1'b0));
  assign BranchPlugin_jumpInterface_payload = memory_BRANCH_CALC;
  assign IBusCachedPlugin_decodePrediction_rsp_wasWrong = BranchPlugin_jumpInterface_valid;
  assign _zz_46 = decode_SRC1_CTRL;
  assign _zz_44 = _zz_96;
  assign _zz_76 = decode_to_execute_SRC1_CTRL;
  assign _zz_43 = decode_ALU_CTRL;
  assign _zz_41 = _zz_95;
  assign _zz_77 = decode_to_execute_ALU_CTRL;
  assign _zz_40 = decode_SRC2_CTRL;
  assign _zz_38 = _zz_94;
  assign _zz_75 = decode_to_execute_SRC2_CTRL;
  assign _zz_37 = decode_SRC3_CTRL;
  assign _zz_35 = _zz_93;
  assign _zz_73 = decode_to_execute_SRC3_CTRL;
  assign _zz_34 = decode_ALU_BITWISE_CTRL;
  assign _zz_32 = _zz_92;
  assign _zz_78 = decode_to_execute_ALU_BITWISE_CTRL;
  assign _zz_31 = decode_SHIFT_CTRL;
  assign _zz_28 = execute_SHIFT_CTRL;
  assign _zz_29 = _zz_91;
  assign _zz_72 = decode_to_execute_SHIFT_CTRL;
  assign _zz_71 = execute_to_memory_SHIFT_CTRL;
  assign _zz_26 = decode_BitManipZbaCtrlsh_add;
  assign _zz_24 = _zz_90;
  assign _zz_69 = decode_to_execute_BitManipZbaCtrlsh_add;
  assign _zz_23 = decode_BitManipZbbCtrl;
  assign _zz_21 = _zz_89;
  assign _zz_52 = decode_to_execute_BitManipZbbCtrl;
  assign _zz_20 = decode_BitManipZbbCtrlgrevorc;
  assign _zz_18 = _zz_88;
  assign _zz_68 = decode_to_execute_BitManipZbbCtrlgrevorc;
  assign _zz_17 = decode_BitManipZbbCtrlbitwise;
  assign _zz_15 = _zz_87;
  assign _zz_67 = decode_to_execute_BitManipZbbCtrlbitwise;
  assign _zz_14 = decode_BitManipZbbCtrlrotation;
  assign _zz_12 = _zz_86;
  assign _zz_66 = decode_to_execute_BitManipZbbCtrlrotation;
  assign _zz_11 = decode_BitManipZbbCtrlminmax;
  assign _zz_9 = _zz_85;
  assign _zz_55 = decode_to_execute_BitManipZbbCtrlminmax;
  assign _zz_8 = decode_BitManipZbbCtrlcountzeroes;
  assign _zz_6 = _zz_84;
  assign _zz_54 = decode_to_execute_BitManipZbbCtrlcountzeroes;
  assign _zz_5 = decode_BitManipZbbCtrlsignextend;
  assign _zz_3 = _zz_83;
  assign _zz_53 = decode_to_execute_BitManipZbbCtrlsignextend;
  assign _zz_2 = decode_BRANCH_CTRL;
  assign _zz_98 = _zz_82;
  assign _zz_47 = decode_to_execute_BRANCH_CTRL;
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
  assign iBusWishbone_ADR = {_zz_453,_zz_243};
  assign iBusWishbone_CTI = ((_zz_243 == 2'b11) ? 3'b111 : 3'b010);
  assign iBusWishbone_BTE = 2'b00;
  assign iBusWishbone_SEL = 4'b1111;
  assign iBusWishbone_WE = 1'b0;
  assign iBusWishbone_DAT_MOSI = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
  always @ (*) begin
    iBusWishbone_CYC = 1'b0;
    if(_zz_302)begin
      iBusWishbone_CYC = 1'b1;
    end
  end

  always @ (*) begin
    iBusWishbone_STB = 1'b0;
    if(_zz_302)begin
      iBusWishbone_STB = 1'b1;
    end
  end

  assign iBus_cmd_ready = (iBus_cmd_valid && iBusWishbone_ACK);
  assign iBus_rsp_valid = _zz_244;
  assign iBus_rsp_payload_data = iBusWishbone_DAT_MISO_regNext;
  assign iBus_rsp_payload_error = 1'b0;
  assign _zz_250 = (dBus_cmd_payload_size == 3'b100);
  assign _zz_246 = dBus_cmd_valid;
  assign _zz_248 = dBus_cmd_payload_wr;
  assign _zz_249 = ((! _zz_250) || (_zz_245 == 2'b11));
  assign dBus_cmd_ready = (_zz_247 && (_zz_248 || _zz_249));
  assign dBusWishbone_ADR = ((_zz_250 ? {{dBus_cmd_payload_address[31 : 4],_zz_245},2'b00} : {dBus_cmd_payload_address[31 : 2],2'b00}) >>> 2);
  assign dBusWishbone_CTI = (_zz_250 ? (_zz_249 ? 3'b111 : 3'b010) : 3'b000);
  assign dBusWishbone_BTE = 2'b00;
  assign dBusWishbone_SEL = (_zz_248 ? dBus_cmd_payload_mask : 4'b1111);
  assign dBusWishbone_WE = _zz_248;
  assign dBusWishbone_DAT_MOSI = dBus_cmd_payload_data;
  assign _zz_247 = (_zz_246 && dBusWishbone_ACK);
  assign dBusWishbone_CYC = _zz_246;
  assign dBusWishbone_STB = _zz_246;
  assign dBus_rsp_valid = _zz_251;
  assign dBus_rsp_payload_data = dBusWishbone_DAT_MISO_regNext;
  assign dBus_rsp_payload_error = 1'b0;
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      IBusCachedPlugin_fetchPc_pcReg <= 32'h00410000;
      IBusCachedPlugin_fetchPc_correctionReg <= 1'b0;
      IBusCachedPlugin_fetchPc_booted <= 1'b0;
      IBusCachedPlugin_fetchPc_inc <= 1'b0;
      _zz_110 <= 1'b0;
      _zz_112 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_0 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_1 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_2 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_3 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_4 <= 1'b0;
      IBusCachedPlugin_rspCounter <= _zz_125;
      IBusCachedPlugin_rspCounter <= 32'h0;
      DBusCachedPlugin_rspCounter <= _zz_126;
      DBusCachedPlugin_rspCounter <= 32'h0;
      _zz_156 <= 1'b1;
      HazardSimplePlugin_writeBackBuffer_valid <= 1'b0;
      execute_arbitration_isValid <= 1'b0;
      memory_arbitration_isValid <= 1'b0;
      writeBack_arbitration_isValid <= 1'b0;
      _zz_243 <= 2'b00;
      _zz_244 <= 1'b0;
      _zz_245 <= 2'b00;
      _zz_251 <= 1'b0;
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
        _zz_110 <= 1'b0;
      end
      if(_zz_108)begin
        _zz_110 <= (IBusCachedPlugin_iBusRsp_stages_0_output_valid && (! 1'b0));
      end
      if(IBusCachedPlugin_iBusRsp_flush)begin
        _zz_112 <= 1'b0;
      end
      if(IBusCachedPlugin_iBusRsp_stages_1_output_ready)begin
        _zz_112 <= (IBusCachedPlugin_iBusRsp_stages_1_output_valid && (! IBusCachedPlugin_iBusRsp_flush));
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
      if(dBus_rsp_valid)begin
        DBusCachedPlugin_rspCounter <= (DBusCachedPlugin_rspCounter + 32'h00000001);
      end
      _zz_156 <= 1'b0;
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
      if(_zz_302)begin
        if(iBusWishbone_ACK)begin
          _zz_243 <= (_zz_243 + 2'b01);
        end
      end
      _zz_244 <= (iBusWishbone_CYC && iBusWishbone_ACK);
      if((_zz_246 && _zz_247))begin
        _zz_245 <= (_zz_245 + 2'b01);
        if(_zz_249)begin
          _zz_245 <= 2'b00;
        end
      end
      _zz_251 <= ((_zz_246 && (! dBusWishbone_WE)) && dBusWishbone_ACK);
    end
  end

  always @ (posedge clk) begin
    if(IBusCachedPlugin_iBusRsp_stages_1_output_ready)begin
      _zz_113 <= IBusCachedPlugin_iBusRsp_stages_1_output_payload;
    end
    if(IBusCachedPlugin_iBusRsp_stages_1_input_ready)begin
      IBusCachedPlugin_s1_tightlyCoupledHit <= IBusCachedPlugin_s0_tightlyCoupledHit;
    end
    if(IBusCachedPlugin_iBusRsp_stages_2_input_ready)begin
      IBusCachedPlugin_s2_tightlyCoupledHit <= IBusCachedPlugin_s1_tightlyCoupledHit;
    end
    HazardSimplePlugin_writeBackBuffer_payload_address <= HazardSimplePlugin_writeBackWrites_payload_address;
    HazardSimplePlugin_writeBackBuffer_payload_data <= HazardSimplePlugin_writeBackWrites_payload_data;
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_PC <= decode_PC;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_PC <= _zz_74;
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
      decode_to_execute_FORMAL_PC_NEXT <= _zz_100;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_FORMAL_PC_NEXT <= execute_FORMAL_PC_NEXT;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_FORMAL_PC_NEXT <= _zz_99;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_MEMORY_FORCE_CONSTISTENCY <= decode_MEMORY_FORCE_CONSTISTENCY;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC1_CTRL <= _zz_45;
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
      decode_to_execute_ALU_CTRL <= _zz_42;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC2_CTRL <= _zz_39;
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
      decode_to_execute_SRC3_CTRL <= _zz_36;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC_LESS_UNSIGNED <= decode_SRC_LESS_UNSIGNED;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ALU_BITWISE_CTRL <= _zz_33;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SHIFT_CTRL <= _zz_30;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_SHIFT_CTRL <= _zz_27;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_BitManipZba <= decode_IS_BitManipZba;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_IS_BitManipZba <= execute_IS_BitManipZba;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BitManipZbaCtrlsh_add <= _zz_25;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_BitManipZbb <= decode_IS_BitManipZbb;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_IS_BitManipZbb <= execute_IS_BitManipZbb;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BitManipZbbCtrl <= _zz_22;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BitManipZbbCtrlgrevorc <= _zz_19;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BitManipZbbCtrlbitwise <= _zz_16;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BitManipZbbCtrlrotation <= _zz_13;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BitManipZbbCtrlminmax <= _zz_10;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BitManipZbbCtrlcountzeroes <= _zz_7;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BitManipZbbCtrlsignextend <= _zz_4;
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
      execute_to_memory_REGFILE_WRITE_DATA <= _zz_49;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_REGFILE_WRITE_DATA <= _zz_70;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_REGFILE_WRITE_DATA_ODD <= _zz_48;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_REGFILE_WRITE_DATA_ODD <= _zz_50;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_SHIFT_RIGHT <= execute_SHIFT_RIGHT;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_BitManipZba_FINAL_OUTPUT <= execute_BitManipZba_FINAL_OUTPUT;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_BitManipZbb_FINAL_OUTPUT <= execute_BitManipZbb_FINAL_OUTPUT;
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
  input      [2:0]    io_mem_rsp_payload_aggregated,
  input               io_mem_rsp_payload_last,
  input      [31:0]   io_mem_rsp_payload_data,
  input               io_mem_rsp_payload_error,
  input               clk,
  input               reset
);
  reg        [26:0]   _zz_8;
  reg        [31:0]   _zz_9;
  wire                _zz_10;
  wire                _zz_11;
  wire                _zz_12;
  wire                _zz_13;
  wire                _zz_14;
  wire                _zz_15;
  wire       [4:0]    _zz_16;
  wire       [4:0]    _zz_17;
  wire       [0:0]    _zz_18;
  wire       [0:0]    _zz_19;
  wire       [1:0]    _zz_20;
  wire       [1:0]    _zz_21;
  wire       [26:0]   _zz_22;
  reg                 _zz_1;
  reg                 _zz_2;
  wire                haltCpu;
  reg                 tagsReadCmd_valid;
  reg        [2:0]    tagsReadCmd_payload;
  reg                 tagsWriteCmd_valid;
  reg        [0:0]    tagsWriteCmd_payload_way;
  reg        [2:0]    tagsWriteCmd_payload_address;
  reg                 tagsWriteCmd_payload_data_valid;
  reg                 tagsWriteCmd_payload_data_error;
  reg        [24:0]   tagsWriteCmd_payload_data_address;
  reg                 tagsWriteLastCmd_valid;
  reg        [0:0]    tagsWriteLastCmd_payload_way;
  reg        [2:0]    tagsWriteLastCmd_payload_address;
  reg                 tagsWriteLastCmd_payload_data_valid;
  reg                 tagsWriteLastCmd_payload_data_error;
  reg        [24:0]   tagsWriteLastCmd_payload_data_address;
  reg                 dataReadCmd_valid;
  reg        [4:0]    dataReadCmd_payload;
  reg                 dataWriteCmd_valid;
  reg        [0:0]    dataWriteCmd_payload_way;
  reg        [4:0]    dataWriteCmd_payload_address;
  reg        [31:0]   dataWriteCmd_payload_data;
  reg        [3:0]    dataWriteCmd_payload_mask;
  wire                _zz_3;
  wire                ways_0_tagsReadRsp_valid;
  wire                ways_0_tagsReadRsp_error;
  wire       [24:0]   ways_0_tagsReadRsp_address;
  wire       [26:0]   _zz_4;
  wire                _zz_5;
  wire       [31:0]   ways_0_dataReadRspMem;
  wire       [31:0]   ways_0_dataReadRsp;
  wire                rspSync;
  wire                rspLast;
  reg                 memCmdSent;
  reg        [3:0]    _zz_6;
  wire       [3:0]    stage0_mask;
  wire       [0:0]    stage0_dataColisions;
  wire       [0:0]    stage0_wayInvalidate;
  wire                stage0_isAmo;
  reg                 stageA_request_wr;
  reg        [1:0]    stageA_request_size;
  reg                 stageA_request_totalyConsistent;
  reg        [3:0]    stageA_mask;
  wire                stageA_isAmo;
  wire                stageA_isLrsc;
  wire       [0:0]    stageA_wayHits;
  reg        [0:0]    stageA_wayInvalidate;
  reg        [0:0]    stage0_dataColisions_regNextWhen;
  wire       [0:0]    _zz_7;
  wire       [0:0]    stageA_dataColisions;
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
  reg        [31:0]   stageB_dataReadRsp_0;
  reg        [0:0]    stageB_wayInvalidate;
  wire                stageB_consistancyHazard;
  reg        [0:0]    stageB_dataColisions;
  wire                stageB_unaligned;
  reg        [0:0]    stageB_waysHitsBeforeInvalidate;
  wire       [0:0]    stageB_waysHits;
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
  reg        [0:0]    loader_waysAllocator;
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
  reg [7:0] _zz_23;
  reg [7:0] _zz_24;
  reg [7:0] _zz_25;
  reg [7:0] _zz_26;

  assign _zz_10 = (io_cpu_execute_isValid && (! io_cpu_memory_isStuck));
  assign _zz_11 = (! stageB_flusher_counter[3]);
  assign _zz_12 = ((((stageB_consistancyHazard || stageB_mmuRsp_refilling) || io_cpu_writeBack_accessError) || io_cpu_writeBack_mmuException) || io_cpu_writeBack_unalignedAccess);
  assign _zz_13 = ((loader_valid && io_mem_rsp_valid) && rspLast);
  assign _zz_14 = (stageB_mmuRsp_isIoAccess || stageB_isExternalLsrc);
  assign _zz_15 = (stageB_waysHit || (stageB_request_wr && (! stageB_isAmoCached)));
  assign _zz_16 = (io_cpu_execute_address[6 : 2] >>> 0);
  assign _zz_17 = (io_cpu_memory_address[6 : 2] >>> 0);
  assign _zz_18 = 1'b1;
  assign _zz_19 = loader_counter_willIncrement;
  assign _zz_20 = {1'd0, _zz_19};
  assign _zz_21 = {loader_waysAllocator,loader_waysAllocator[0]};
  assign _zz_22 = {tagsWriteCmd_payload_data_address,{tagsWriteCmd_payload_data_error,tagsWriteCmd_payload_data_valid}};
  always @ (posedge clk) begin
    if(_zz_3) begin
      _zz_8 <= ways_0_tags[tagsReadCmd_payload];
    end
  end

  always @ (posedge clk) begin
    if(_zz_2) begin
      ways_0_tags[tagsWriteCmd_payload_address] <= _zz_22;
    end
  end

  always @ (*) begin
    _zz_9 = {_zz_26, _zz_25, _zz_24, _zz_23};
  end
  always @ (posedge clk) begin
    if(_zz_5) begin
      _zz_23 <= ways_0_data_symbol0[dataReadCmd_payload];
      _zz_24 <= ways_0_data_symbol1[dataReadCmd_payload];
      _zz_25 <= ways_0_data_symbol2[dataReadCmd_payload];
      _zz_26 <= ways_0_data_symbol3[dataReadCmd_payload];
    end
  end

  always @ (posedge clk) begin
    if(dataWriteCmd_payload_mask[0] && _zz_1) begin
      ways_0_data_symbol0[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[7 : 0];
    end
    if(dataWriteCmd_payload_mask[1] && _zz_1) begin
      ways_0_data_symbol1[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[15 : 8];
    end
    if(dataWriteCmd_payload_mask[2] && _zz_1) begin
      ways_0_data_symbol2[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[23 : 16];
    end
    if(dataWriteCmd_payload_mask[3] && _zz_1) begin
      ways_0_data_symbol3[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[31 : 24];
    end
  end

  always @ (*) begin
    _zz_1 = 1'b0;
    if((dataWriteCmd_valid && dataWriteCmd_payload_way[0]))begin
      _zz_1 = 1'b1;
    end
  end

  always @ (*) begin
    _zz_2 = 1'b0;
    if((tagsWriteCmd_valid && tagsWriteCmd_payload_way[0]))begin
      _zz_2 = 1'b1;
    end
  end

  assign haltCpu = 1'b0;
  assign _zz_3 = (tagsReadCmd_valid && (! io_cpu_memory_isStuck));
  assign _zz_4 = _zz_8;
  assign ways_0_tagsReadRsp_valid = _zz_4[0];
  assign ways_0_tagsReadRsp_error = _zz_4[1];
  assign ways_0_tagsReadRsp_address = _zz_4[26 : 2];
  assign _zz_5 = (dataReadCmd_valid && (! io_cpu_memory_isStuck));
  assign ways_0_dataReadRspMem = _zz_9;
  assign ways_0_dataReadRsp = ways_0_dataReadRspMem[31 : 0];
  always @ (*) begin
    tagsReadCmd_valid = 1'b0;
    if(_zz_10)begin
      tagsReadCmd_valid = 1'b1;
    end
  end

  always @ (*) begin
    tagsReadCmd_payload = 3'bxxx;
    if(_zz_10)begin
      tagsReadCmd_payload = io_cpu_execute_address[6 : 4];
    end
  end

  always @ (*) begin
    dataReadCmd_valid = 1'b0;
    if(_zz_10)begin
      dataReadCmd_valid = 1'b1;
    end
  end

  always @ (*) begin
    dataReadCmd_payload = 5'bxxxxx;
    if(_zz_10)begin
      dataReadCmd_payload = io_cpu_execute_address[6 : 2];
    end
  end

  always @ (*) begin
    tagsWriteCmd_valid = 1'b0;
    if(_zz_11)begin
      tagsWriteCmd_valid = 1'b1;
    end
    if(_zz_12)begin
      tagsWriteCmd_valid = 1'b0;
    end
    if(loader_done)begin
      tagsWriteCmd_valid = 1'b1;
    end
  end

  always @ (*) begin
    tagsWriteCmd_payload_way = 1'bx;
    if(_zz_11)begin
      tagsWriteCmd_payload_way = 1'b1;
    end
    if(loader_done)begin
      tagsWriteCmd_payload_way = loader_waysAllocator;
    end
  end

  always @ (*) begin
    tagsWriteCmd_payload_address = 3'bxxx;
    if(_zz_11)begin
      tagsWriteCmd_payload_address = stageB_flusher_counter[2:0];
    end
    if(loader_done)begin
      tagsWriteCmd_payload_address = stageB_mmuRsp_physicalAddress[6 : 4];
    end
  end

  always @ (*) begin
    tagsWriteCmd_payload_data_valid = 1'bx;
    if(_zz_11)begin
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
    if(_zz_12)begin
      dataWriteCmd_valid = 1'b0;
    end
    if(_zz_13)begin
      dataWriteCmd_valid = 1'b1;
    end
  end

  always @ (*) begin
    dataWriteCmd_payload_way = 1'bx;
    if(stageB_cpuWriteToCache)begin
      dataWriteCmd_payload_way = stageB_waysHits;
    end
    if(_zz_13)begin
      dataWriteCmd_payload_way = loader_waysAllocator;
    end
  end

  always @ (*) begin
    dataWriteCmd_payload_address = 5'bxxxxx;
    if(stageB_cpuWriteToCache)begin
      dataWriteCmd_payload_address = stageB_mmuRsp_physicalAddress[6 : 2];
    end
    if(_zz_13)begin
      dataWriteCmd_payload_address = {stageB_mmuRsp_physicalAddress[6 : 4],loader_counter_value};
    end
  end

  always @ (*) begin
    dataWriteCmd_payload_data = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
    if(stageB_cpuWriteToCache)begin
      dataWriteCmd_payload_data[31 : 0] = stageB_requestDataBypass;
    end
    if(_zz_13)begin
      dataWriteCmd_payload_data = io_mem_rsp_payload_data;
    end
  end

  always @ (*) begin
    dataWriteCmd_payload_mask = 4'bxxxx;
    if(stageB_cpuWriteToCache)begin
      dataWriteCmd_payload_mask = 4'b0000;
      if(_zz_18[0])begin
        dataWriteCmd_payload_mask[3 : 0] = stageB_mask;
      end
    end
    if(_zz_13)begin
      dataWriteCmd_payload_mask = 4'b1111;
    end
  end

  always @ (*) begin
    io_cpu_execute_haltIt = 1'b0;
    if(_zz_11)begin
      io_cpu_execute_haltIt = 1'b1;
    end
  end

  assign rspSync = 1'b1;
  assign rspLast = 1'b1;
  always @ (*) begin
    _zz_6 = 4'bxxxx;
    case(io_cpu_execute_args_size)
      2'b00 : begin
        _zz_6 = 4'b0001;
      end
      2'b01 : begin
        _zz_6 = 4'b0011;
      end
      2'b10 : begin
        _zz_6 = 4'b1111;
      end
      default : begin
      end
    endcase
  end

  assign stage0_mask = (_zz_6 <<< io_cpu_execute_address[1 : 0]);
  assign stage0_dataColisions[0] = (((dataWriteCmd_valid && dataWriteCmd_payload_way[0]) && (dataWriteCmd_payload_address == _zz_16)) && ((stage0_mask & dataWriteCmd_payload_mask[3 : 0]) != 4'b0000));
  assign stage0_wayInvalidate = 1'b0;
  assign stage0_isAmo = 1'b0;
  assign io_cpu_memory_isWrite = stageA_request_wr;
  assign stageA_isAmo = 1'b0;
  assign stageA_isLrsc = 1'b0;
  assign stageA_wayHits = ((io_cpu_memory_mmuRsp_physicalAddress[31 : 7] == ways_0_tagsReadRsp_address) && ways_0_tagsReadRsp_valid);
  assign _zz_7[0] = (((dataWriteCmd_valid && dataWriteCmd_payload_way[0]) && (dataWriteCmd_payload_address == _zz_17)) && ((stageA_mask & dataWriteCmd_payload_mask[3 : 0]) != 4'b0000));
  assign stageA_dataColisions = (stage0_dataColisions_regNextWhen | _zz_7);
  always @ (*) begin
    stageB_mmuRspFreeze = 1'b0;
    if((stageB_loaderValid || loader_valid))begin
      stageB_mmuRspFreeze = 1'b1;
    end
  end

  assign stageB_consistancyHazard = 1'b0;
  assign stageB_unaligned = 1'b0;
  assign stageB_waysHits = (stageB_waysHitsBeforeInvalidate & (~ stageB_wayInvalidate));
  assign stageB_waysHit = (stageB_waysHits != 1'b0);
  assign stageB_dataMux = stageB_dataReadRsp_0;
  always @ (*) begin
    stageB_loaderValid = 1'b0;
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_isExternalAmo) begin
        if(! _zz_14) begin
          if(! _zz_15) begin
            if(io_mem_cmd_ready)begin
              stageB_loaderValid = 1'b1;
            end
          end
        end
      end
    end
    if(_zz_12)begin
      stageB_loaderValid = 1'b0;
    end
  end

  assign stageB_ioMemRspMuxed = io_mem_rsp_payload_data[31 : 0];
  always @ (*) begin
    io_cpu_writeBack_haltIt = 1'b1;
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_isExternalAmo) begin
        if(_zz_14)begin
          if(((! stageB_request_wr) ? (io_mem_rsp_valid && rspSync) : io_mem_cmd_ready))begin
            io_cpu_writeBack_haltIt = 1'b0;
          end
        end else begin
          if(_zz_15)begin
            if(((! stageB_request_wr) || io_mem_cmd_ready))begin
              io_cpu_writeBack_haltIt = 1'b0;
            end
          end
        end
      end
    end
    if(_zz_12)begin
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
        if(! _zz_14) begin
          if(_zz_15)begin
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
        if(! _zz_14) begin
          if(_zz_15)begin
            if((((! stageB_request_wr) || stageB_isAmoCached) && ((stageB_dataColisions & stageB_waysHits) != 1'b0)))begin
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
        if(_zz_14)begin
          io_mem_cmd_valid = (! memCmdSent);
        end else begin
          if(_zz_15)begin
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
    if(_zz_12)begin
      io_mem_cmd_valid = 1'b0;
    end
  end

  always @ (*) begin
    io_mem_cmd_payload_address = stageB_mmuRsp_physicalAddress;
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_isExternalAmo) begin
        if(! _zz_14) begin
          if(! _zz_15) begin
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
        if(! _zz_14) begin
          if(! _zz_15) begin
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
        if(! _zz_14) begin
          if(! _zz_15) begin
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
    if(_zz_13)begin
      loader_counter_willIncrement = 1'b1;
    end
  end

  assign loader_counter_willClear = 1'b0;
  assign loader_counter_willOverflowIfInc = (loader_counter_value == 2'b11);
  assign loader_counter_willOverflow = (loader_counter_willOverflowIfInc && loader_counter_willIncrement);
  always @ (*) begin
    loader_counter_valueNext = (loader_counter_value + _zz_20);
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
      stageB_dataReadRsp_0 <= ways_0_dataReadRsp;
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
      loader_waysAllocator <= 1'b1;
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
      if(_zz_11)begin
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
      if(_zz_13)begin
        loader_error <= (loader_error || io_mem_rsp_payload_error);
      end
      if(loader_done)begin
        loader_valid <= 1'b0;
        loader_error <= 1'b0;
        loader_killReg <= 1'b0;
      end
      if((! loader_valid))begin
        loader_waysAllocator <= _zz_21[0:0];
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
