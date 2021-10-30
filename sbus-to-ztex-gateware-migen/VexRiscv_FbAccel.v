// Generator : SpinalHDL v1.4.4    git head : 86bb53d7c015114a265f345ebe5da1eb68d1e828
// Component : VexRiscv
// Git hash  : 24adc7db89135956d4ef289611665b7a4ed40e1c


`define BranchCtrlEnum_defaultEncoding_type [1:0]
`define BranchCtrlEnum_defaultEncoding_INC 2'b00
`define BranchCtrlEnum_defaultEncoding_B 2'b01
`define BranchCtrlEnum_defaultEncoding_JAL 2'b10
`define BranchCtrlEnum_defaultEncoding_JALR 2'b11

`define BitManipZbtCtrlternaryEnum_defaultEncoding_type [1:0]
`define BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_CMIX 2'b00
`define BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_CMOV 2'b01
`define BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_FSL 2'b10
`define BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_FSR 2'b11

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
  wire                _zz_270;
  wire                _zz_271;
  wire                _zz_272;
  wire                _zz_273;
  wire                _zz_274;
  wire                _zz_275;
  wire                _zz_276;
  wire                _zz_277;
  reg                 _zz_278;
  wire                _zz_279;
  wire       [31:0]   _zz_280;
  wire                _zz_281;
  wire       [31:0]   _zz_282;
  reg                 _zz_283;
  reg                 _zz_284;
  wire                _zz_285;
  wire       [31:0]   _zz_286;
  wire       [31:0]   _zz_287;
  wire                _zz_288;
  wire                _zz_289;
  wire                _zz_290;
  wire                _zz_291;
  wire                _zz_292;
  wire                _zz_293;
  wire                _zz_294;
  wire                _zz_295;
  wire       [3:0]    _zz_296;
  wire                _zz_297;
  wire                _zz_298;
  reg        [31:0]   _zz_299;
  reg        [31:0]   _zz_300;
  reg        [31:0]   _zz_301;
  reg        [31:0]   _zz_302;
  reg        [7:0]    _zz_303;
  reg        [7:0]    _zz_304;
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
  wire                _zz_305;
  wire                _zz_306;
  wire                _zz_307;
  wire                _zz_308;
  wire                _zz_309;
  wire                _zz_310;
  wire                _zz_311;
  wire                _zz_312;
  wire                _zz_313;
  wire                _zz_314;
  wire                _zz_315;
  wire                _zz_316;
  wire                _zz_317;
  wire                _zz_318;
  wire                _zz_319;
  wire                _zz_320;
  wire                _zz_321;
  wire       [1:0]    _zz_322;
  wire       [2:0]    _zz_323;
  wire       [32:0]   _zz_324;
  wire       [31:0]   _zz_325;
  wire       [32:0]   _zz_326;
  wire       [2:0]    _zz_327;
  wire       [2:0]    _zz_328;
  wire       [31:0]   _zz_329;
  wire       [11:0]   _zz_330;
  wire       [31:0]   _zz_331;
  wire       [19:0]   _zz_332;
  wire       [11:0]   _zz_333;
  wire       [31:0]   _zz_334;
  wire       [31:0]   _zz_335;
  wire       [19:0]   _zz_336;
  wire       [11:0]   _zz_337;
  wire       [0:0]    _zz_338;
  wire       [2:0]    _zz_339;
  wire       [4:0]    _zz_340;
  wire       [11:0]   _zz_341;
  wire       [31:0]   _zz_342;
  wire       [31:0]   _zz_343;
  wire       [31:0]   _zz_344;
  wire       [31:0]   _zz_345;
  wire       [31:0]   _zz_346;
  wire       [31:0]   _zz_347;
  wire       [31:0]   _zz_348;
  wire       [31:0]   _zz_349;
  wire       [31:0]   _zz_350;
  wire       [31:0]   _zz_351;
  wire       [31:0]   _zz_352;
  wire       [31:0]   _zz_353;
  wire       [31:0]   _zz_354;
  wire       [31:0]   _zz_355;
  wire       [31:0]   _zz_356;
  wire       [31:0]   _zz_357;
  wire       [31:0]   _zz_358;
  wire       [31:0]   _zz_359;
  wire       [31:0]   _zz_360;
  wire       [31:0]   _zz_361;
  wire       [31:0]   _zz_362;
  wire       [31:0]   _zz_363;
  wire       [31:0]   _zz_364;
  wire       [31:0]   _zz_365;
  wire       [31:0]   _zz_366;
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
  wire       [5:0]    _zz_381;
  wire       [5:0]    _zz_382;
  wire       [5:0]    _zz_383;
  wire       [5:0]    _zz_384;
  wire       [5:0]    _zz_385;
  wire       [5:0]    _zz_386;
  wire       [5:0]    _zz_387;
  wire       [5:0]    _zz_388;
  wire       [5:0]    _zz_389;
  wire       [5:0]    _zz_390;
  wire       [5:0]    _zz_391;
  wire       [5:0]    _zz_392;
  wire       [5:0]    _zz_393;
  wire       [5:0]    _zz_394;
  wire       [5:0]    _zz_395;
  wire       [5:0]    _zz_396;
  wire       [5:0]    _zz_397;
  wire       [5:0]    _zz_398;
  wire       [5:0]    _zz_399;
  wire       [0:0]    _zz_400;
  wire       [5:0]    _zz_401;
  wire       [0:0]    _zz_402;
  wire       [5:0]    _zz_403;
  wire       [0:0]    _zz_404;
  wire       [5:0]    _zz_405;
  wire       [0:0]    _zz_406;
  wire       [5:0]    _zz_407;
  wire       [0:0]    _zz_408;
  wire       [5:0]    _zz_409;
  wire       [0:0]    _zz_410;
  wire       [5:0]    _zz_411;
  wire       [0:0]    _zz_412;
  wire       [5:0]    _zz_413;
  wire       [0:0]    _zz_414;
  wire       [5:0]    _zz_415;
  wire       [0:0]    _zz_416;
  wire       [5:0]    _zz_417;
  wire       [0:0]    _zz_418;
  wire       [5:0]    _zz_419;
  wire       [0:0]    _zz_420;
  wire       [5:0]    _zz_421;
  wire       [0:0]    _zz_422;
  wire       [5:0]    _zz_423;
  wire       [0:0]    _zz_424;
  wire       [5:0]    _zz_425;
  wire       [0:0]    _zz_426;
  wire       [5:0]    _zz_427;
  wire       [0:0]    _zz_428;
  wire       [5:0]    _zz_429;
  wire       [0:0]    _zz_430;
  wire       [5:0]    _zz_431;
  wire       [0:0]    _zz_432;
  wire       [5:0]    _zz_433;
  wire       [0:0]    _zz_434;
  wire       [5:0]    _zz_435;
  wire       [0:0]    _zz_436;
  wire       [5:0]    _zz_437;
  wire       [0:0]    _zz_438;
  wire       [5:0]    _zz_439;
  wire       [0:0]    _zz_440;
  wire       [5:0]    _zz_441;
  wire       [0:0]    _zz_442;
  wire       [5:0]    _zz_443;
  wire       [0:0]    _zz_444;
  wire       [5:0]    _zz_445;
  wire       [0:0]    _zz_446;
  wire       [5:0]    _zz_447;
  wire       [0:0]    _zz_448;
  wire       [5:0]    _zz_449;
  wire       [0:0]    _zz_450;
  wire       [5:0]    _zz_451;
  wire       [0:0]    _zz_452;
  wire       [5:0]    _zz_453;
  wire       [0:0]    _zz_454;
  wire       [5:0]    _zz_455;
  wire       [0:0]    _zz_456;
  wire       [5:0]    _zz_457;
  wire       [0:0]    _zz_458;
  wire       [5:0]    _zz_459;
  wire       [0:0]    _zz_460;
  wire       [5:0]    _zz_461;
  wire       [0:0]    _zz_462;
  wire       [5:0]    _zz_463;
  wire       [31:0]   _zz_464;
  wire       [31:0]   _zz_465;
  wire       [31:0]   _zz_466;
  wire       [31:0]   _zz_467;
  wire       [31:0]   _zz_468;
  wire       [31:0]   _zz_469;
  wire       [31:0]   _zz_470;
  wire       [31:0]   _zz_471;
  wire       [19:0]   _zz_472;
  wire       [11:0]   _zz_473;
  wire       [31:0]   _zz_474;
  wire       [31:0]   _zz_475;
  wire       [31:0]   _zz_476;
  wire       [19:0]   _zz_477;
  wire       [11:0]   _zz_478;
  wire       [2:0]    _zz_479;
  wire       [27:0]   _zz_480;
  wire                _zz_481;
  wire                _zz_482;
  wire                _zz_483;
  wire       [1:0]    _zz_484;
  wire       [1:0]    _zz_485;
  wire       [0:0]    _zz_486;
  wire                _zz_487;
  wire                _zz_488;
  wire                _zz_489;
  wire       [31:0]   _zz_490;
  wire       [31:0]   _zz_491;
  wire       [31:0]   _zz_492;
  wire       [31:0]   _zz_493;
  wire                _zz_494;
  wire       [1:0]    _zz_495;
  wire       [1:0]    _zz_496;
  wire                _zz_497;
  wire       [0:0]    _zz_498;
  wire       [39:0]   _zz_499;
  wire       [31:0]   _zz_500;
  wire       [0:0]    _zz_501;
  wire       [0:0]    _zz_502;
  wire                _zz_503;
  wire       [0:0]    _zz_504;
  wire       [35:0]   _zz_505;
  wire       [31:0]   _zz_506;
  wire       [31:0]   _zz_507;
  wire       [31:0]   _zz_508;
  wire       [0:0]    _zz_509;
  wire       [0:0]    _zz_510;
  wire                _zz_511;
  wire       [0:0]    _zz_512;
  wire       [31:0]   _zz_513;
  wire       [31:0]   _zz_514;
  wire       [31:0]   _zz_515;
  wire       [0:0]    _zz_516;
  wire       [0:0]    _zz_517;
  wire       [2:0]    _zz_518;
  wire       [2:0]    _zz_519;
  wire                _zz_520;
  wire       [0:0]    _zz_521;
  wire       [25:0]   _zz_522;
  wire       [31:0]   _zz_523;
  wire       [31:0]   _zz_524;
  wire       [31:0]   _zz_525;
  wire       [31:0]   _zz_526;
  wire                _zz_527;
  wire                _zz_528;
  wire                _zz_529;
  wire                _zz_530;
  wire       [0:0]    _zz_531;
  wire       [3:0]    _zz_532;
  wire       [0:0]    _zz_533;
  wire       [0:0]    _zz_534;
  wire                _zz_535;
  wire       [0:0]    _zz_536;
  wire       [22:0]   _zz_537;
  wire       [31:0]   _zz_538;
  wire       [31:0]   _zz_539;
  wire       [31:0]   _zz_540;
  wire       [31:0]   _zz_541;
  wire       [31:0]   _zz_542;
  wire       [31:0]   _zz_543;
  wire                _zz_544;
  wire       [0:0]    _zz_545;
  wire       [1:0]    _zz_546;
  wire       [31:0]   _zz_547;
  wire       [31:0]   _zz_548;
  wire       [0:0]    _zz_549;
  wire       [0:0]    _zz_550;
  wire                _zz_551;
  wire       [0:0]    _zz_552;
  wire       [20:0]   _zz_553;
  wire       [31:0]   _zz_554;
  wire       [31:0]   _zz_555;
  wire       [31:0]   _zz_556;
  wire       [31:0]   _zz_557;
  wire       [31:0]   _zz_558;
  wire       [31:0]   _zz_559;
  wire       [31:0]   _zz_560;
  wire       [31:0]   _zz_561;
  wire       [0:0]    _zz_562;
  wire       [0:0]    _zz_563;
  wire       [0:0]    _zz_564;
  wire       [0:0]    _zz_565;
  wire                _zz_566;
  wire       [0:0]    _zz_567;
  wire       [17:0]   _zz_568;
  wire       [31:0]   _zz_569;
  wire       [31:0]   _zz_570;
  wire       [31:0]   _zz_571;
  wire       [1:0]    _zz_572;
  wire       [1:0]    _zz_573;
  wire                _zz_574;
  wire       [0:0]    _zz_575;
  wire       [14:0]   _zz_576;
  wire       [31:0]   _zz_577;
  wire       [31:0]   _zz_578;
  wire       [31:0]   _zz_579;
  wire       [31:0]   _zz_580;
  wire       [0:0]    _zz_581;
  wire       [3:0]    _zz_582;
  wire       [0:0]    _zz_583;
  wire       [0:0]    _zz_584;
  wire                _zz_585;
  wire       [0:0]    _zz_586;
  wire       [10:0]   _zz_587;
  wire       [31:0]   _zz_588;
  wire       [31:0]   _zz_589;
  wire                _zz_590;
  wire       [0:0]    _zz_591;
  wire       [0:0]    _zz_592;
  wire       [31:0]   _zz_593;
  wire       [0:0]    _zz_594;
  wire       [4:0]    _zz_595;
  wire       [3:0]    _zz_596;
  wire       [3:0]    _zz_597;
  wire                _zz_598;
  wire       [0:0]    _zz_599;
  wire       [7:0]    _zz_600;
  wire       [31:0]   _zz_601;
  wire       [31:0]   _zz_602;
  wire       [31:0]   _zz_603;
  wire                _zz_604;
  wire       [0:0]    _zz_605;
  wire       [1:0]    _zz_606;
  wire       [0:0]    _zz_607;
  wire       [0:0]    _zz_608;
  wire       [0:0]    _zz_609;
  wire       [0:0]    _zz_610;
  wire       [0:0]    _zz_611;
  wire       [0:0]    _zz_612;
  wire                _zz_613;
  wire       [0:0]    _zz_614;
  wire       [4:0]    _zz_615;
  wire       [31:0]   _zz_616;
  wire       [31:0]   _zz_617;
  wire       [31:0]   _zz_618;
  wire                _zz_619;
  wire                _zz_620;
  wire       [31:0]   _zz_621;
  wire       [31:0]   _zz_622;
  wire       [31:0]   _zz_623;
  wire       [31:0]   _zz_624;
  wire       [31:0]   _zz_625;
  wire       [31:0]   _zz_626;
  wire                _zz_627;
  wire       [1:0]    _zz_628;
  wire       [1:0]    _zz_629;
  wire                _zz_630;
  wire       [0:0]    _zz_631;
  wire       [2:0]    _zz_632;
  wire       [31:0]   _zz_633;
  wire       [31:0]   _zz_634;
  wire       [31:0]   _zz_635;
  wire       [31:0]   _zz_636;
  wire       [31:0]   _zz_637;
  wire       [31:0]   _zz_638;
  wire       [0:0]    _zz_639;
  wire       [1:0]    _zz_640;
  wire       [0:0]    _zz_641;
  wire       [0:0]    _zz_642;
  wire                _zz_643;
  wire                _zz_644;
  wire       [21:0]   _zz_645;
  wire       [0:0]    _zz_646;
  wire                _zz_647;
  wire       [10:0]   _zz_648;
  wire       [0:0]    _zz_649;
  wire                _zz_650;
  wire                _zz_651;
  wire                _zz_652;
  wire                _zz_653;
  wire                _zz_654;
  wire                _zz_655;
  wire                _zz_656;
  wire                _zz_657;
  wire                _zz_658;
  wire                _zz_659;
  wire                _zz_660;
  wire                _zz_661;
  wire       [31:0]   execute_BRANCH_CALC;
  wire                execute_BRANCH_DO;
  wire       [31:0]   execute_BitManipZbt_FINAL_OUTPUT;
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
  wire       `BitManipZbtCtrlternaryEnum_defaultEncoding_type decode_BitManipZbtCtrlternary;
  wire       `BitManipZbtCtrlternaryEnum_defaultEncoding_type _zz_3;
  wire       `BitManipZbtCtrlternaryEnum_defaultEncoding_type _zz_4;
  wire       `BitManipZbtCtrlternaryEnum_defaultEncoding_type _zz_5;
  wire                execute_IS_BitManipZbt;
  wire                decode_IS_BitManipZbt;
  wire       `BitManipZbbCtrlsignextendEnum_defaultEncoding_type decode_BitManipZbbCtrlsignextend;
  wire       `BitManipZbbCtrlsignextendEnum_defaultEncoding_type _zz_6;
  wire       `BitManipZbbCtrlsignextendEnum_defaultEncoding_type _zz_7;
  wire       `BitManipZbbCtrlsignextendEnum_defaultEncoding_type _zz_8;
  wire       `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_type decode_BitManipZbbCtrlcountzeroes;
  wire       `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_type _zz_9;
  wire       `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_type _zz_10;
  wire       `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_type _zz_11;
  wire       `BitManipZbbCtrlminmaxEnum_defaultEncoding_type decode_BitManipZbbCtrlminmax;
  wire       `BitManipZbbCtrlminmaxEnum_defaultEncoding_type _zz_12;
  wire       `BitManipZbbCtrlminmaxEnum_defaultEncoding_type _zz_13;
  wire       `BitManipZbbCtrlminmaxEnum_defaultEncoding_type _zz_14;
  wire       `BitManipZbbCtrlrotationEnum_defaultEncoding_type decode_BitManipZbbCtrlrotation;
  wire       `BitManipZbbCtrlrotationEnum_defaultEncoding_type _zz_15;
  wire       `BitManipZbbCtrlrotationEnum_defaultEncoding_type _zz_16;
  wire       `BitManipZbbCtrlrotationEnum_defaultEncoding_type _zz_17;
  wire       `BitManipZbbCtrlbitwiseEnum_defaultEncoding_type decode_BitManipZbbCtrlbitwise;
  wire       `BitManipZbbCtrlbitwiseEnum_defaultEncoding_type _zz_18;
  wire       `BitManipZbbCtrlbitwiseEnum_defaultEncoding_type _zz_19;
  wire       `BitManipZbbCtrlbitwiseEnum_defaultEncoding_type _zz_20;
  wire       `BitManipZbbCtrlgrevorcEnum_defaultEncoding_type decode_BitManipZbbCtrlgrevorc;
  wire       `BitManipZbbCtrlgrevorcEnum_defaultEncoding_type _zz_21;
  wire       `BitManipZbbCtrlgrevorcEnum_defaultEncoding_type _zz_22;
  wire       `BitManipZbbCtrlgrevorcEnum_defaultEncoding_type _zz_23;
  wire       `BitManipZbbCtrlEnum_defaultEncoding_type decode_BitManipZbbCtrl;
  wire       `BitManipZbbCtrlEnum_defaultEncoding_type _zz_24;
  wire       `BitManipZbbCtrlEnum_defaultEncoding_type _zz_25;
  wire       `BitManipZbbCtrlEnum_defaultEncoding_type _zz_26;
  wire                execute_IS_BitManipZbb;
  wire                decode_IS_BitManipZbb;
  wire       `BitManipZbaCtrlsh_addEnum_defaultEncoding_type decode_BitManipZbaCtrlsh_add;
  wire       `BitManipZbaCtrlsh_addEnum_defaultEncoding_type _zz_27;
  wire       `BitManipZbaCtrlsh_addEnum_defaultEncoding_type _zz_28;
  wire       `BitManipZbaCtrlsh_addEnum_defaultEncoding_type _zz_29;
  wire                execute_IS_BitManipZba;
  wire                decode_IS_BitManipZba;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_30;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_31;
  wire       `ShiftCtrlEnum_defaultEncoding_type decode_SHIFT_CTRL;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_32;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_33;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_34;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type decode_ALU_BITWISE_CTRL;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_35;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_36;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_37;
  wire                decode_SRC_LESS_UNSIGNED;
  wire       `Src3CtrlEnum_defaultEncoding_type decode_SRC3_CTRL;
  wire       `Src3CtrlEnum_defaultEncoding_type _zz_38;
  wire       `Src3CtrlEnum_defaultEncoding_type _zz_39;
  wire       `Src3CtrlEnum_defaultEncoding_type _zz_40;
  wire                decode_MEMORY_MANAGMENT;
  wire                decode_MEMORY_WR;
  wire                execute_BYPASSABLE_MEMORY_STAGE;
  wire                decode_BYPASSABLE_MEMORY_STAGE;
  wire                decode_BYPASSABLE_EXECUTE_STAGE;
  wire       `Src2CtrlEnum_defaultEncoding_type decode_SRC2_CTRL;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_41;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_42;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_43;
  wire       `AluCtrlEnum_defaultEncoding_type decode_ALU_CTRL;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_44;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_45;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_46;
  wire       `Src1CtrlEnum_defaultEncoding_type decode_SRC1_CTRL;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_47;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_48;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_49;
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
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_50;
  wire                decode_RS3_USE;
  wire                decode_RS2_USE;
  wire                decode_RS1_USE;
  wire       [31:0]   _zz_51;
  wire                execute_REGFILE_WRITE_VALID_ODD;
  wire       [31:0]   _zz_52;
  wire                execute_REGFILE_WRITE_VALID;
  wire                execute_BYPASSABLE_EXECUTE_STAGE;
  wire       [31:0]   _zz_53;
  wire                memory_REGFILE_WRITE_VALID_ODD;
  wire                memory_REGFILE_WRITE_VALID;
  wire                memory_BYPASSABLE_MEMORY_STAGE;
  wire       [31:0]   memory_INSTRUCTION;
  wire       [31:0]   _zz_54;
  wire                writeBack_REGFILE_WRITE_VALID_ODD;
  wire                writeBack_REGFILE_WRITE_VALID;
  reg        [31:0]   decode_RS3;
  reg        [31:0]   decode_RS2;
  reg        [31:0]   decode_RS1;
  wire       [31:0]   memory_BitManipZbt_FINAL_OUTPUT;
  wire                memory_IS_BitManipZbt;
  wire       [31:0]   execute_SRC3;
  wire       `BitManipZbtCtrlternaryEnum_defaultEncoding_type execute_BitManipZbtCtrlternary;
  wire       `BitManipZbtCtrlternaryEnum_defaultEncoding_type _zz_55;
  wire       [31:0]   memory_BitManipZbb_FINAL_OUTPUT;
  wire                memory_IS_BitManipZbb;
  wire       `BitManipZbbCtrlEnum_defaultEncoding_type execute_BitManipZbbCtrl;
  wire       `BitManipZbbCtrlEnum_defaultEncoding_type _zz_56;
  wire       `BitManipZbbCtrlsignextendEnum_defaultEncoding_type execute_BitManipZbbCtrlsignextend;
  wire       `BitManipZbbCtrlsignextendEnum_defaultEncoding_type _zz_57;
  wire       `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_type execute_BitManipZbbCtrlcountzeroes;
  wire       `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_type _zz_58;
  wire       `BitManipZbbCtrlminmaxEnum_defaultEncoding_type execute_BitManipZbbCtrlminmax;
  wire       `BitManipZbbCtrlminmaxEnum_defaultEncoding_type _zz_59;
  reg        [31:0]   _zz_60;
  reg        [31:0]   _zz_61;
  reg        [31:0]   _zz_62;
  reg        [31:0]   _zz_63;
  reg        [31:0]   _zz_64;
  reg        [31:0]   _zz_65;
  reg        [31:0]   _zz_66;
  reg        [31:0]   _zz_67;
  reg        [31:0]   _zz_68;
  reg        [31:0]   _zz_69;
  wire       `BitManipZbbCtrlrotationEnum_defaultEncoding_type execute_BitManipZbbCtrlrotation;
  wire       `BitManipZbbCtrlrotationEnum_defaultEncoding_type _zz_70;
  wire       `BitManipZbbCtrlbitwiseEnum_defaultEncoding_type execute_BitManipZbbCtrlbitwise;
  wire       `BitManipZbbCtrlbitwiseEnum_defaultEncoding_type _zz_71;
  wire       `BitManipZbbCtrlgrevorcEnum_defaultEncoding_type execute_BitManipZbbCtrlgrevorc;
  wire       `BitManipZbbCtrlgrevorcEnum_defaultEncoding_type _zz_72;
  wire       [31:0]   memory_BitManipZba_FINAL_OUTPUT;
  wire                memory_IS_BitManipZba;
  wire       `BitManipZbaCtrlsh_addEnum_defaultEncoding_type execute_BitManipZbaCtrlsh_add;
  wire       `BitManipZbaCtrlsh_addEnum_defaultEncoding_type _zz_73;
  wire       [31:0]   memory_SHIFT_RIGHT;
  reg        [31:0]   _zz_74;
  wire       `ShiftCtrlEnum_defaultEncoding_type memory_SHIFT_CTRL;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_75;
  wire       `ShiftCtrlEnum_defaultEncoding_type execute_SHIFT_CTRL;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_76;
  wire                execute_SRC_LESS_UNSIGNED;
  wire                execute_SRC2_FORCE_ZERO;
  wire                execute_SRC_USE_SUB_LESS;
  wire       `Src3CtrlEnum_defaultEncoding_type execute_SRC3_CTRL;
  wire       `Src3CtrlEnum_defaultEncoding_type _zz_77;
  wire       [31:0]   _zz_78;
  wire       `Src2CtrlEnum_defaultEncoding_type execute_SRC2_CTRL;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_79;
  wire       `Src1CtrlEnum_defaultEncoding_type execute_SRC1_CTRL;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_80;
  wire                decode_SRC_USE_SUB_LESS;
  wire                decode_SRC_ADD_ZERO;
  wire       [31:0]   execute_SRC_ADD_SUB;
  wire                execute_SRC_LESS;
  wire       `AluCtrlEnum_defaultEncoding_type execute_ALU_CTRL;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_81;
  wire       [31:0]   execute_SRC2;
  wire       [31:0]   execute_SRC1;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type execute_ALU_BITWISE_CTRL;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_82;
  wire                _zz_83;
  reg                 _zz_84;
  wire       [31:0]   _zz_85;
  wire       [31:0]   decode_INSTRUCTION_ANTICIPATED;
  reg                 decode_REGFILE_WRITE_VALID;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_86;
  wire       `BitManipZbtCtrlternaryEnum_defaultEncoding_type _zz_87;
  wire       `BitManipZbbCtrlsignextendEnum_defaultEncoding_type _zz_88;
  wire       `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_type _zz_89;
  wire       `BitManipZbbCtrlminmaxEnum_defaultEncoding_type _zz_90;
  wire       `BitManipZbbCtrlrotationEnum_defaultEncoding_type _zz_91;
  wire       `BitManipZbbCtrlbitwiseEnum_defaultEncoding_type _zz_92;
  wire       `BitManipZbbCtrlgrevorcEnum_defaultEncoding_type _zz_93;
  wire       `BitManipZbbCtrlEnum_defaultEncoding_type _zz_94;
  wire       `BitManipZbaCtrlsh_addEnum_defaultEncoding_type _zz_95;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_96;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_97;
  wire       `Src3CtrlEnum_defaultEncoding_type _zz_98;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_99;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_100;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_101;
  reg        [31:0]   _zz_102;
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
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_103;
  wire       [31:0]   decode_INSTRUCTION;
  reg        [31:0]   _zz_104;
  reg        [31:0]   _zz_105;
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
  wire       [2:0]    _zz_106;
  wire       [2:0]    _zz_107;
  wire                _zz_108;
  wire                _zz_109;
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
  wire                _zz_110;
  wire                _zz_111;
  wire                _zz_112;
  wire                IBusCachedPlugin_iBusRsp_flush;
  wire                _zz_113;
  wire                _zz_114;
  reg                 _zz_115;
  wire                _zz_116;
  reg                 _zz_117;
  reg        [31:0]   _zz_118;
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
  wire                _zz_119;
  reg        [18:0]   _zz_120;
  wire                _zz_121;
  reg        [10:0]   _zz_122;
  wire                _zz_123;
  reg        [18:0]   _zz_124;
  reg                 _zz_125;
  wire                _zz_126;
  reg        [10:0]   _zz_127;
  wire                _zz_128;
  reg        [18:0]   _zz_129;
  wire                iBus_cmd_valid;
  wire                iBus_cmd_ready;
  reg        [31:0]   iBus_cmd_payload_address;
  wire       [2:0]    iBus_cmd_payload_size;
  wire                iBus_rsp_valid;
  wire       [31:0]   iBus_rsp_payload_data;
  wire                iBus_rsp_payload_error;
  wire       [31:0]   _zz_130;
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
  wire       [31:0]   _zz_131;
  reg        [31:0]   DBusCachedPlugin_rspCounter;
  wire       [1:0]    execute_DBusCachedPlugin_size;
  reg        [31:0]   _zz_132;
  wire       [7:0]    writeBack_DBusCachedPlugin_rspSplits_0;
  wire       [7:0]    writeBack_DBusCachedPlugin_rspSplits_1;
  wire       [7:0]    writeBack_DBusCachedPlugin_rspSplits_2;
  wire       [7:0]    writeBack_DBusCachedPlugin_rspSplits_3;
  reg        [31:0]   writeBack_DBusCachedPlugin_rspShifted;
  wire       [31:0]   writeBack_DBusCachedPlugin_rspRf;
  wire                _zz_133;
  reg        [31:0]   _zz_134;
  wire                _zz_135;
  reg        [31:0]   _zz_136;
  reg        [31:0]   writeBack_DBusCachedPlugin_rspFormated;
  wire       [46:0]   _zz_137;
  wire                _zz_138;
  wire                _zz_139;
  wire                _zz_140;
  wire                _zz_141;
  wire                _zz_142;
  wire                _zz_143;
  wire                _zz_144;
  wire                _zz_145;
  wire                _zz_146;
  wire                _zz_147;
  wire                _zz_148;
  wire       `Src1CtrlEnum_defaultEncoding_type _zz_149;
  wire       `AluCtrlEnum_defaultEncoding_type _zz_150;
  wire       `Src2CtrlEnum_defaultEncoding_type _zz_151;
  wire       `Src3CtrlEnum_defaultEncoding_type _zz_152;
  wire       `AluBitwiseCtrlEnum_defaultEncoding_type _zz_153;
  wire       `ShiftCtrlEnum_defaultEncoding_type _zz_154;
  wire       `BitManipZbaCtrlsh_addEnum_defaultEncoding_type _zz_155;
  wire       `BitManipZbbCtrlEnum_defaultEncoding_type _zz_156;
  wire       `BitManipZbbCtrlgrevorcEnum_defaultEncoding_type _zz_157;
  wire       `BitManipZbbCtrlbitwiseEnum_defaultEncoding_type _zz_158;
  wire       `BitManipZbbCtrlrotationEnum_defaultEncoding_type _zz_159;
  wire       `BitManipZbbCtrlminmaxEnum_defaultEncoding_type _zz_160;
  wire       `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_type _zz_161;
  wire       `BitManipZbbCtrlsignextendEnum_defaultEncoding_type _zz_162;
  wire       `BitManipZbtCtrlternaryEnum_defaultEncoding_type _zz_163;
  wire       `BranchCtrlEnum_defaultEncoding_type _zz_164;
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
  reg                 _zz_165;
  reg        [31:0]   execute_IntAluPlugin_bitwise;
  reg        [31:0]   _zz_166;
  reg        [31:0]   _zz_167;
  wire                _zz_168;
  reg        [19:0]   _zz_169;
  wire                _zz_170;
  reg        [19:0]   _zz_171;
  reg        [31:0]   _zz_172;
  wire                _zz_173;
  reg        [19:0]   _zz_174;
  reg        [31:0]   _zz_175;
  reg        [31:0]   execute_SrcPlugin_addSub;
  wire                execute_SrcPlugin_less;
  wire       [4:0]    execute_FullBarrelShifterPlugin_amplitude;
  reg        [31:0]   _zz_176;
  wire       [31:0]   execute_FullBarrelShifterPlugin_reversed;
  reg        [31:0]   _zz_177;
  reg        [31:0]   execute_BitManipZbaPlugin_val_sh_add;
  wire       [31:0]   _zz_178;
  wire       [31:0]   _zz_179;
  reg        [31:0]   execute_BitManipZbbPlugin_val_grevorc;
  reg        [31:0]   execute_BitManipZbbPlugin_val_bitwise;
  wire       [4:0]    _zz_180;
  wire       [31:0]   _zz_181;
  wire       [4:0]    _zz_182;
  wire       [31:0]   _zz_183;
  reg        [31:0]   execute_BitManipZbbPlugin_val_rotation;
  reg        [31:0]   execute_BitManipZbbPlugin_val_minmax;
  wire       [31:0]   _zz_184;
  wire       [3:0]    _zz_185;
  wire       [2:0]    _zz_186;
  wire       [3:0]    _zz_187;
  wire       [2:0]    _zz_188;
  wire       [3:0]    _zz_189;
  wire       [2:0]    _zz_190;
  wire       [3:0]    _zz_191;
  wire       [2:0]    _zz_192;
  wire       [3:0]    _zz_193;
  wire       [2:0]    _zz_194;
  wire       [3:0]    _zz_195;
  wire       [2:0]    _zz_196;
  wire       [3:0]    _zz_197;
  wire       [2:0]    _zz_198;
  wire       [3:0]    _zz_199;
  wire       [2:0]    _zz_200;
  wire       [7:0]    _zz_201;
  wire                _zz_202;
  wire                _zz_203;
  wire                _zz_204;
  wire                _zz_205;
  wire       [3:0]    _zz_206;
  reg        [1:0]    _zz_207;
  reg        [31:0]   execute_BitManipZbbPlugin_val_countzeroes;
  reg        [31:0]   execute_BitManipZbbPlugin_val_signextend;
  reg        [31:0]   _zz_208;
  wire       [31:0]   _zz_209;
  wire       [31:0]   _zz_210;
  wire       [31:0]   _zz_211;
  wire       [31:0]   _zz_212;
  wire       [31:0]   _zz_213;
  wire       [31:0]   _zz_214;
  reg        [31:0]   execute_BitManipZbtPlugin_val_ternary;
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
  wire                _zz_215;
  wire       [4:0]    _zz_216;
  wire       [4:0]    _zz_217;
  wire       [4:0]    _zz_218;
  wire                _zz_219;
  wire                _zz_220;
  wire                _zz_221;
  wire                _zz_222;
  wire                _zz_223;
  wire                _zz_224;
  wire                _zz_225;
  wire       [4:0]    _zz_226;
  wire       [4:0]    _zz_227;
  wire       [4:0]    _zz_228;
  wire                _zz_229;
  wire                _zz_230;
  wire                _zz_231;
  wire                _zz_232;
  wire                _zz_233;
  wire                _zz_234;
  wire                _zz_235;
  wire       [4:0]    _zz_236;
  wire       [4:0]    _zz_237;
  wire       [4:0]    _zz_238;
  wire                _zz_239;
  wire                _zz_240;
  wire                _zz_241;
  wire                _zz_242;
  wire                _zz_243;
  wire                _zz_244;
  wire                execute_BranchPlugin_eq;
  wire       [2:0]    _zz_245;
  reg                 _zz_246;
  reg                 _zz_247;
  wire                _zz_248;
  reg        [19:0]   _zz_249;
  wire                _zz_250;
  reg        [10:0]   _zz_251;
  wire                _zz_252;
  reg        [18:0]   _zz_253;
  reg                 _zz_254;
  wire                execute_BranchPlugin_missAlignedTarget;
  reg        [31:0]   execute_BranchPlugin_branch_src1;
  reg        [31:0]   execute_BranchPlugin_branch_src2;
  wire                _zz_255;
  reg        [19:0]   _zz_256;
  wire                _zz_257;
  reg        [10:0]   _zz_258;
  wire                _zz_259;
  reg        [18:0]   _zz_260;
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
  reg                 decode_to_execute_IS_BitManipZbt;
  reg                 execute_to_memory_IS_BitManipZbt;
  reg        `BitManipZbtCtrlternaryEnum_defaultEncoding_type decode_to_execute_BitManipZbtCtrlternary;
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
  reg        [31:0]   execute_to_memory_BitManipZbt_FINAL_OUTPUT;
  reg                 execute_to_memory_BRANCH_DO;
  reg        [31:0]   execute_to_memory_BRANCH_CALC;
  reg        [1:0]    _zz_261;
  reg                 _zz_262;
  reg        [31:0]   iBusWishbone_DAT_MISO_regNext;
  reg        [1:0]    _zz_263;
  wire                _zz_264;
  wire                _zz_265;
  wire                _zz_266;
  wire                _zz_267;
  wire                _zz_268;
  reg                 _zz_269;
  reg        [31:0]   dBusWishbone_DAT_MISO_regNext;
  `ifndef SYNTHESIS
  reg [31:0] _zz_1_string;
  reg [31:0] _zz_2_string;
  reg [71:0] decode_BitManipZbtCtrlternary_string;
  reg [71:0] _zz_3_string;
  reg [71:0] _zz_4_string;
  reg [71:0] _zz_5_string;
  reg [103:0] decode_BitManipZbbCtrlsignextend_string;
  reg [103:0] _zz_6_string;
  reg [103:0] _zz_7_string;
  reg [103:0] _zz_8_string;
  reg [71:0] decode_BitManipZbbCtrlcountzeroes_string;
  reg [71:0] _zz_9_string;
  reg [71:0] _zz_10_string;
  reg [71:0] _zz_11_string;
  reg [71:0] decode_BitManipZbbCtrlminmax_string;
  reg [71:0] _zz_12_string;
  reg [71:0] _zz_13_string;
  reg [71:0] _zz_14_string;
  reg [63:0] decode_BitManipZbbCtrlrotation_string;
  reg [63:0] _zz_15_string;
  reg [63:0] _zz_16_string;
  reg [63:0] _zz_17_string;
  reg [71:0] decode_BitManipZbbCtrlbitwise_string;
  reg [71:0] _zz_18_string;
  reg [71:0] _zz_19_string;
  reg [71:0] _zz_20_string;
  reg [95:0] decode_BitManipZbbCtrlgrevorc_string;
  reg [95:0] _zz_21_string;
  reg [95:0] _zz_22_string;
  reg [95:0] _zz_23_string;
  reg [127:0] decode_BitManipZbbCtrl_string;
  reg [127:0] _zz_24_string;
  reg [127:0] _zz_25_string;
  reg [127:0] _zz_26_string;
  reg [87:0] decode_BitManipZbaCtrlsh_add_string;
  reg [87:0] _zz_27_string;
  reg [87:0] _zz_28_string;
  reg [87:0] _zz_29_string;
  reg [71:0] _zz_30_string;
  reg [71:0] _zz_31_string;
  reg [71:0] decode_SHIFT_CTRL_string;
  reg [71:0] _zz_32_string;
  reg [71:0] _zz_33_string;
  reg [71:0] _zz_34_string;
  reg [39:0] decode_ALU_BITWISE_CTRL_string;
  reg [39:0] _zz_35_string;
  reg [39:0] _zz_36_string;
  reg [39:0] _zz_37_string;
  reg [23:0] decode_SRC3_CTRL_string;
  reg [23:0] _zz_38_string;
  reg [23:0] _zz_39_string;
  reg [23:0] _zz_40_string;
  reg [23:0] decode_SRC2_CTRL_string;
  reg [23:0] _zz_41_string;
  reg [23:0] _zz_42_string;
  reg [23:0] _zz_43_string;
  reg [63:0] decode_ALU_CTRL_string;
  reg [63:0] _zz_44_string;
  reg [63:0] _zz_45_string;
  reg [63:0] _zz_46_string;
  reg [95:0] decode_SRC1_CTRL_string;
  reg [95:0] _zz_47_string;
  reg [95:0] _zz_48_string;
  reg [95:0] _zz_49_string;
  reg [31:0] execute_BRANCH_CTRL_string;
  reg [31:0] _zz_50_string;
  reg [71:0] execute_BitManipZbtCtrlternary_string;
  reg [71:0] _zz_55_string;
  reg [127:0] execute_BitManipZbbCtrl_string;
  reg [127:0] _zz_56_string;
  reg [103:0] execute_BitManipZbbCtrlsignextend_string;
  reg [103:0] _zz_57_string;
  reg [71:0] execute_BitManipZbbCtrlcountzeroes_string;
  reg [71:0] _zz_58_string;
  reg [71:0] execute_BitManipZbbCtrlminmax_string;
  reg [71:0] _zz_59_string;
  reg [63:0] execute_BitManipZbbCtrlrotation_string;
  reg [63:0] _zz_70_string;
  reg [71:0] execute_BitManipZbbCtrlbitwise_string;
  reg [71:0] _zz_71_string;
  reg [95:0] execute_BitManipZbbCtrlgrevorc_string;
  reg [95:0] _zz_72_string;
  reg [87:0] execute_BitManipZbaCtrlsh_add_string;
  reg [87:0] _zz_73_string;
  reg [71:0] memory_SHIFT_CTRL_string;
  reg [71:0] _zz_75_string;
  reg [71:0] execute_SHIFT_CTRL_string;
  reg [71:0] _zz_76_string;
  reg [23:0] execute_SRC3_CTRL_string;
  reg [23:0] _zz_77_string;
  reg [23:0] execute_SRC2_CTRL_string;
  reg [23:0] _zz_79_string;
  reg [95:0] execute_SRC1_CTRL_string;
  reg [95:0] _zz_80_string;
  reg [63:0] execute_ALU_CTRL_string;
  reg [63:0] _zz_81_string;
  reg [39:0] execute_ALU_BITWISE_CTRL_string;
  reg [39:0] _zz_82_string;
  reg [31:0] _zz_86_string;
  reg [71:0] _zz_87_string;
  reg [103:0] _zz_88_string;
  reg [71:0] _zz_89_string;
  reg [71:0] _zz_90_string;
  reg [63:0] _zz_91_string;
  reg [71:0] _zz_92_string;
  reg [95:0] _zz_93_string;
  reg [127:0] _zz_94_string;
  reg [87:0] _zz_95_string;
  reg [71:0] _zz_96_string;
  reg [39:0] _zz_97_string;
  reg [23:0] _zz_98_string;
  reg [23:0] _zz_99_string;
  reg [63:0] _zz_100_string;
  reg [95:0] _zz_101_string;
  reg [31:0] decode_BRANCH_CTRL_string;
  reg [31:0] _zz_103_string;
  reg [95:0] _zz_149_string;
  reg [63:0] _zz_150_string;
  reg [23:0] _zz_151_string;
  reg [23:0] _zz_152_string;
  reg [39:0] _zz_153_string;
  reg [71:0] _zz_154_string;
  reg [87:0] _zz_155_string;
  reg [127:0] _zz_156_string;
  reg [95:0] _zz_157_string;
  reg [71:0] _zz_158_string;
  reg [63:0] _zz_159_string;
  reg [71:0] _zz_160_string;
  reg [71:0] _zz_161_string;
  reg [103:0] _zz_162_string;
  reg [71:0] _zz_163_string;
  reg [31:0] _zz_164_string;
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
  reg [71:0] decode_to_execute_BitManipZbtCtrlternary_string;
  reg [31:0] decode_to_execute_BRANCH_CTRL_string;
  `endif

  reg [31:0] RegFilePlugin_regFile [0:31] /* verilator public */ ;

  assign _zz_305 = (writeBack_arbitration_isValid && writeBack_REGFILE_WRITE_VALID);
  assign _zz_306 = 1'b1;
  assign _zz_307 = ((writeBack_arbitration_isValid && _zz_215) && writeBack_REGFILE_WRITE_VALID_ODD);
  assign _zz_308 = 1'b1;
  assign _zz_309 = (memory_arbitration_isValid && memory_REGFILE_WRITE_VALID);
  assign _zz_310 = ((memory_arbitration_isValid && _zz_225) && memory_REGFILE_WRITE_VALID_ODD);
  assign _zz_311 = (execute_arbitration_isValid && execute_REGFILE_WRITE_VALID);
  assign _zz_312 = ((execute_arbitration_isValid && _zz_235) && execute_REGFILE_WRITE_VALID_ODD);
  assign _zz_313 = ((_zz_275 && IBusCachedPlugin_cache_io_cpu_decode_cacheMiss) && (! IBusCachedPlugin_rsp_issueDetected_1));
  assign _zz_314 = ((_zz_275 && IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling) && (! IBusCachedPlugin_rsp_issueDetected));
  assign _zz_315 = (writeBack_arbitration_isValid && writeBack_REGFILE_WRITE_VALID);
  assign _zz_316 = (1'b0 || (! 1'b1));
  assign _zz_317 = (memory_arbitration_isValid && memory_REGFILE_WRITE_VALID);
  assign _zz_318 = (1'b0 || (! memory_BYPASSABLE_MEMORY_STAGE));
  assign _zz_319 = (execute_arbitration_isValid && execute_REGFILE_WRITE_VALID);
  assign _zz_320 = (1'b0 || (! execute_BYPASSABLE_EXECUTE_STAGE));
  assign _zz_321 = (iBus_cmd_valid || (_zz_261 != 2'b00));
  assign _zz_322 = writeBack_INSTRUCTION[13 : 12];
  assign _zz_323 = _zz_206[2 : 0];
  assign _zz_324 = ($signed(_zz_326) >>> execute_FullBarrelShifterPlugin_amplitude);
  assign _zz_325 = _zz_324[31 : 0];
  assign _zz_326 = {((execute_SHIFT_CTRL == `ShiftCtrlEnum_defaultEncoding_SRA_1) && execute_FullBarrelShifterPlugin_reversed[31]),execute_FullBarrelShifterPlugin_reversed};
  assign _zz_327 = (_zz_106 - 3'b001);
  assign _zz_328 = {IBusCachedPlugin_fetchPc_inc,2'b00};
  assign _zz_329 = {29'd0, _zz_328};
  assign _zz_330 = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_331 = {{_zz_120,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz_332 = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]};
  assign _zz_333 = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_334 = {{_zz_122,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]}},1'b0};
  assign _zz_335 = {{_zz_124,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz_336 = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]};
  assign _zz_337 = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_338 = execute_SRC_LESS;
  assign _zz_339 = 3'b100;
  assign _zz_340 = execute_INSTRUCTION[19 : 15];
  assign _zz_341 = {execute_INSTRUCTION[31 : 25],execute_INSTRUCTION[11 : 7]};
  assign _zz_342 = ($signed(_zz_343) + $signed(_zz_346));
  assign _zz_343 = ($signed(_zz_344) + $signed(_zz_345));
  assign _zz_344 = execute_SRC1;
  assign _zz_345 = (execute_SRC_USE_SUB_LESS ? (~ execute_SRC2) : execute_SRC2);
  assign _zz_346 = (execute_SRC_USE_SUB_LESS ? _zz_347 : _zz_348);
  assign _zz_347 = 32'h00000001;
  assign _zz_348 = 32'h0;
  assign _zz_349 = (_zz_350 + execute_SRC2);
  assign _zz_350 = (execute_SRC1 <<< 1);
  assign _zz_351 = (_zz_352 + execute_SRC2);
  assign _zz_352 = (execute_SRC1 <<< 2);
  assign _zz_353 = (_zz_354 + execute_SRC2);
  assign _zz_354 = (execute_SRC1 <<< 3);
  assign _zz_355 = ((execute_SRC1 & 32'h55555555) <<< 1);
  assign _zz_356 = ((execute_SRC1 & 32'haaaaaaaa) >>> 1);
  assign _zz_357 = ((_zz_178 & 32'h33333333) <<< 2);
  assign _zz_358 = ((_zz_178 & 32'hcccccccc) >>> 2);
  assign _zz_359 = ((_zz_179 & 32'h0f0f0f0f) <<< 4);
  assign _zz_360 = ((_zz_179 & 32'hf0f0f0f0) >>> 4);
  assign _zz_361 = (execute_SRC2 & 32'h0000001f);
  assign _zz_362 = (execute_SRC2 & 32'h0000001f);
  assign _zz_363 = execute_SRC2;
  assign _zz_364 = execute_SRC1;
  assign _zz_365 = execute_SRC1;
  assign _zz_366 = execute_SRC2;
  assign _zz_367 = (_zz_206[3] ? 6'h20 : {{1'b0,_zz_206[2 : 0]},_zz_207[1 : 0]});
  assign _zz_368 = _zz_369;
  assign _zz_369 = (_zz_370 + _zz_463);
  assign _zz_370 = (_zz_371 + _zz_461);
  assign _zz_371 = (_zz_372 + _zz_459);
  assign _zz_372 = (_zz_373 + _zz_457);
  assign _zz_373 = (_zz_374 + _zz_455);
  assign _zz_374 = (_zz_375 + _zz_453);
  assign _zz_375 = (_zz_376 + _zz_451);
  assign _zz_376 = (_zz_377 + _zz_449);
  assign _zz_377 = (_zz_378 + _zz_447);
  assign _zz_378 = (_zz_379 + _zz_445);
  assign _zz_379 = (_zz_380 + _zz_443);
  assign _zz_380 = (_zz_381 + _zz_441);
  assign _zz_381 = (_zz_382 + _zz_439);
  assign _zz_382 = (_zz_383 + _zz_437);
  assign _zz_383 = (_zz_384 + _zz_435);
  assign _zz_384 = (_zz_385 + _zz_433);
  assign _zz_385 = (_zz_386 + _zz_431);
  assign _zz_386 = (_zz_387 + _zz_429);
  assign _zz_387 = (_zz_388 + _zz_427);
  assign _zz_388 = (_zz_389 + _zz_425);
  assign _zz_389 = (_zz_390 + _zz_423);
  assign _zz_390 = (_zz_391 + _zz_421);
  assign _zz_391 = (_zz_392 + _zz_419);
  assign _zz_392 = (_zz_393 + _zz_417);
  assign _zz_393 = (_zz_394 + _zz_415);
  assign _zz_394 = (_zz_395 + _zz_413);
  assign _zz_395 = (_zz_396 + _zz_411);
  assign _zz_396 = (_zz_397 + _zz_409);
  assign _zz_397 = (_zz_398 + _zz_407);
  assign _zz_398 = (_zz_399 + _zz_405);
  assign _zz_399 = (_zz_401 + _zz_403);
  assign _zz_400 = execute_SRC1[0];
  assign _zz_401 = {5'd0, _zz_400};
  assign _zz_402 = execute_SRC1[1];
  assign _zz_403 = {5'd0, _zz_402};
  assign _zz_404 = execute_SRC1[2];
  assign _zz_405 = {5'd0, _zz_404};
  assign _zz_406 = execute_SRC1[3];
  assign _zz_407 = {5'd0, _zz_406};
  assign _zz_408 = execute_SRC1[4];
  assign _zz_409 = {5'd0, _zz_408};
  assign _zz_410 = execute_SRC1[5];
  assign _zz_411 = {5'd0, _zz_410};
  assign _zz_412 = execute_SRC1[6];
  assign _zz_413 = {5'd0, _zz_412};
  assign _zz_414 = execute_SRC1[7];
  assign _zz_415 = {5'd0, _zz_414};
  assign _zz_416 = execute_SRC1[8];
  assign _zz_417 = {5'd0, _zz_416};
  assign _zz_418 = execute_SRC1[9];
  assign _zz_419 = {5'd0, _zz_418};
  assign _zz_420 = execute_SRC1[10];
  assign _zz_421 = {5'd0, _zz_420};
  assign _zz_422 = execute_SRC1[11];
  assign _zz_423 = {5'd0, _zz_422};
  assign _zz_424 = execute_SRC1[12];
  assign _zz_425 = {5'd0, _zz_424};
  assign _zz_426 = execute_SRC1[13];
  assign _zz_427 = {5'd0, _zz_426};
  assign _zz_428 = execute_SRC1[14];
  assign _zz_429 = {5'd0, _zz_428};
  assign _zz_430 = execute_SRC1[15];
  assign _zz_431 = {5'd0, _zz_430};
  assign _zz_432 = execute_SRC1[16];
  assign _zz_433 = {5'd0, _zz_432};
  assign _zz_434 = execute_SRC1[17];
  assign _zz_435 = {5'd0, _zz_434};
  assign _zz_436 = execute_SRC1[18];
  assign _zz_437 = {5'd0, _zz_436};
  assign _zz_438 = execute_SRC1[19];
  assign _zz_439 = {5'd0, _zz_438};
  assign _zz_440 = execute_SRC1[20];
  assign _zz_441 = {5'd0, _zz_440};
  assign _zz_442 = execute_SRC1[21];
  assign _zz_443 = {5'd0, _zz_442};
  assign _zz_444 = execute_SRC1[22];
  assign _zz_445 = {5'd0, _zz_444};
  assign _zz_446 = execute_SRC1[23];
  assign _zz_447 = {5'd0, _zz_446};
  assign _zz_448 = execute_SRC1[24];
  assign _zz_449 = {5'd0, _zz_448};
  assign _zz_450 = execute_SRC1[25];
  assign _zz_451 = {5'd0, _zz_450};
  assign _zz_452 = execute_SRC1[26];
  assign _zz_453 = {5'd0, _zz_452};
  assign _zz_454 = execute_SRC1[27];
  assign _zz_455 = {5'd0, _zz_454};
  assign _zz_456 = execute_SRC1[28];
  assign _zz_457 = {5'd0, _zz_456};
  assign _zz_458 = execute_SRC1[29];
  assign _zz_459 = {5'd0, _zz_458};
  assign _zz_460 = execute_SRC1[30];
  assign _zz_461 = {5'd0, _zz_460};
  assign _zz_462 = execute_SRC1[31];
  assign _zz_463 = {5'd0, _zz_462};
  assign _zz_464 = (_zz_209 - 32'h00000020);
  assign _zz_465 = (_zz_212 - 32'h00000020);
  assign _zz_466 = (_zz_211 <<< _zz_210);
  assign _zz_467 = (((_zz_210 == _zz_209) ? execute_SRC3 : execute_SRC1) >>> _zz_468);
  assign _zz_468 = (32'h00000020 - _zz_210);
  assign _zz_469 = (_zz_214 >>> _zz_213);
  assign _zz_470 = (((_zz_213 == _zz_212) ? execute_SRC3 : execute_SRC1) <<< _zz_471);
  assign _zz_471 = (32'h00000020 - _zz_213);
  assign _zz_472 = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]};
  assign _zz_473 = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]};
  assign _zz_474 = {_zz_249,execute_INSTRUCTION[31 : 20]};
  assign _zz_475 = {{_zz_251,{{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]}},1'b0};
  assign _zz_476 = {{_zz_253,{{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz_477 = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]};
  assign _zz_478 = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]};
  assign _zz_479 = 3'b100;
  assign _zz_480 = (iBus_cmd_payload_address >>> 4);
  assign _zz_481 = 1'b1;
  assign _zz_482 = 1'b1;
  assign _zz_483 = 1'b1;
  assign _zz_484 = {_zz_109,_zz_108};
  assign _zz_485 = _zz_287[1 : 0];
  assign _zz_486 = _zz_287[1 : 1];
  assign _zz_487 = decode_INSTRUCTION[31];
  assign _zz_488 = decode_INSTRUCTION[31];
  assign _zz_489 = decode_INSTRUCTION[7];
  assign _zz_490 = (decode_INSTRUCTION & 32'h0000001c);
  assign _zz_491 = 32'h00000004;
  assign _zz_492 = (decode_INSTRUCTION & 32'h00000048);
  assign _zz_493 = 32'h00000040;
  assign _zz_494 = ((decode_INSTRUCTION & 32'h00000040) == 32'h00000040);
  assign _zz_495 = {((decode_INSTRUCTION & _zz_500) == 32'h0),_zz_139};
  assign _zz_496 = 2'b00;
  assign _zz_497 = (_zz_147 != 1'b0);
  assign _zz_498 = (_zz_148 != 1'b0);
  assign _zz_499 = {(_zz_148 != 1'b0),{(_zz_501 != _zz_502),{_zz_503,{_zz_504,_zz_505}}}};
  assign _zz_500 = 32'h02000000;
  assign _zz_501 = ((decode_INSTRUCTION & 32'h40000000) == 32'h0);
  assign _zz_502 = 1'b0;
  assign _zz_503 = (((decode_INSTRUCTION & _zz_506) == 32'h00100000) != 1'b0);
  assign _zz_504 = ((_zz_507 == _zz_508) != 1'b0);
  assign _zz_505 = {(_zz_146 != 1'b0),{(_zz_509 != _zz_510),{_zz_511,{_zz_512,_zz_513}}}};
  assign _zz_506 = 32'h00100000;
  assign _zz_507 = (decode_INSTRUCTION & 32'h00200000);
  assign _zz_508 = 32'h00200000;
  assign _zz_509 = _zz_145;
  assign _zz_510 = 1'b0;
  assign _zz_511 = (_zz_147 != 1'b0);
  assign _zz_512 = (_zz_146 != 1'b0);
  assign _zz_513 = {(_zz_144 != 1'b0),{((_zz_514 == _zz_515) != 1'b0),{({_zz_516,_zz_517} != 2'b00),{(_zz_518 != _zz_519),{_zz_520,{_zz_521,_zz_522}}}}}};
  assign _zz_514 = (decode_INSTRUCTION & 32'h00400000);
  assign _zz_515 = 32'h0;
  assign _zz_516 = ((decode_INSTRUCTION & _zz_523) == 32'h0);
  assign _zz_517 = ((decode_INSTRUCTION & _zz_524) == 32'h0);
  assign _zz_518 = {(_zz_525 == _zz_526),{_zz_527,_zz_528}};
  assign _zz_519 = 3'b000;
  assign _zz_520 = ({_zz_529,_zz_530} != 2'b00);
  assign _zz_521 = ({_zz_531,_zz_532} != 5'h0);
  assign _zz_522 = {(_zz_533 != _zz_534),{_zz_535,{_zz_536,_zz_537}}};
  assign _zz_523 = 32'h00004020;
  assign _zz_524 = 32'h62000000;
  assign _zz_525 = (decode_INSTRUCTION & 32'h02000000);
  assign _zz_526 = 32'h02000000;
  assign _zz_527 = ((decode_INSTRUCTION & _zz_538) == 32'h20000020);
  assign _zz_528 = ((decode_INSTRUCTION & _zz_539) == 32'h00004000);
  assign _zz_529 = ((decode_INSTRUCTION & _zz_540) == 32'h0);
  assign _zz_530 = ((decode_INSTRUCTION & _zz_541) == 32'h00400000);
  assign _zz_531 = (_zz_542 == _zz_543);
  assign _zz_532 = {_zz_544,{_zz_545,_zz_546}};
  assign _zz_533 = (_zz_547 == _zz_548);
  assign _zz_534 = 1'b0;
  assign _zz_535 = (_zz_146 != 1'b0);
  assign _zz_536 = (_zz_549 != _zz_550);
  assign _zz_537 = {_zz_551,{_zz_552,_zz_553}};
  assign _zz_538 = 32'h20000020;
  assign _zz_539 = 32'h08004020;
  assign _zz_540 = 32'h20000000;
  assign _zz_541 = 32'h00404020;
  assign _zz_542 = (decode_INSTRUCTION & 32'h40006064);
  assign _zz_543 = 32'h40006020;
  assign _zz_544 = ((decode_INSTRUCTION & 32'h24003014) == 32'h20001010);
  assign _zz_545 = ((decode_INSTRUCTION & _zz_554) == 32'h40004020);
  assign _zz_546 = {(_zz_555 == _zz_556),(_zz_557 == _zz_558)};
  assign _zz_547 = (decode_INSTRUCTION & 32'h00006000);
  assign _zz_548 = 32'h00006000;
  assign _zz_549 = ((decode_INSTRUCTION & _zz_559) == 32'h20000030);
  assign _zz_550 = 1'b0;
  assign _zz_551 = ((_zz_560 == _zz_561) != 1'b0);
  assign _zz_552 = ({_zz_562,_zz_563} != 2'b00);
  assign _zz_553 = {(_zz_564 != _zz_565),{_zz_566,{_zz_567,_zz_568}}};
  assign _zz_554 = 32'h40005064;
  assign _zz_555 = (decode_INSTRUCTION & 32'h0c004064);
  assign _zz_556 = 32'h08004020;
  assign _zz_557 = (decode_INSTRUCTION & 32'hf8003034);
  assign _zz_558 = 32'h60001010;
  assign _zz_559 = 32'h64000034;
  assign _zz_560 = (decode_INSTRUCTION & 32'h2c007014);
  assign _zz_561 = 32'h00005010;
  assign _zz_562 = ((decode_INSTRUCTION & _zz_569) == 32'h40001010);
  assign _zz_563 = ((decode_INSTRUCTION & _zz_570) == 32'h00001010);
  assign _zz_564 = ((decode_INSTRUCTION & _zz_571) == 32'h00000024);
  assign _zz_565 = 1'b0;
  assign _zz_566 = (_zz_145 != 1'b0);
  assign _zz_567 = (_zz_144 != 1'b0);
  assign _zz_568 = {(_zz_572 != _zz_573),{_zz_574,{_zz_575,_zz_576}}};
  assign _zz_569 = 32'h64003014;
  assign _zz_570 = 32'h44007014;
  assign _zz_571 = 32'h00000064;
  assign _zz_572 = {((decode_INSTRUCTION & _zz_577) == 32'h00002000),((decode_INSTRUCTION & _zz_578) == 32'h00001000)};
  assign _zz_573 = 2'b00;
  assign _zz_574 = 1'b0;
  assign _zz_575 = ((_zz_579 == _zz_580) != 1'b0);
  assign _zz_576 = {({_zz_581,_zz_582} != 5'h0),{(_zz_583 != _zz_584),{_zz_585,{_zz_586,_zz_587}}}};
  assign _zz_577 = 32'h00002010;
  assign _zz_578 = 32'h00005000;
  assign _zz_579 = (decode_INSTRUCTION & 32'h00004048);
  assign _zz_580 = 32'h00004008;
  assign _zz_581 = _zz_138;
  assign _zz_582 = {(_zz_588 == _zz_589),{_zz_590,{_zz_591,_zz_592}}};
  assign _zz_583 = ((decode_INSTRUCTION & _zz_593) == 32'h00000020);
  assign _zz_584 = 1'b0;
  assign _zz_585 = (_zz_143 != 1'b0);
  assign _zz_586 = ({_zz_594,_zz_595} != 6'h0);
  assign _zz_587 = {(_zz_596 != _zz_597),{_zz_598,{_zz_599,_zz_600}}};
  assign _zz_588 = (decode_INSTRUCTION & 32'h04000024);
  assign _zz_589 = 32'h04000020;
  assign _zz_590 = ((decode_INSTRUCTION & 32'h02000024) == 32'h02000020);
  assign _zz_591 = ((decode_INSTRUCTION & _zz_601) == 32'h00000020);
  assign _zz_592 = _zz_141;
  assign _zz_593 = 32'h00000020;
  assign _zz_594 = _zz_140;
  assign _zz_595 = {(_zz_602 == _zz_603),{_zz_604,{_zz_605,_zz_606}}};
  assign _zz_596 = {_zz_143,{_zz_142,{_zz_607,_zz_608}}};
  assign _zz_597 = 4'b0000;
  assign _zz_598 = ({_zz_140,_zz_141} != 2'b00);
  assign _zz_599 = ({_zz_609,_zz_610} != 2'b00);
  assign _zz_600 = {(_zz_611 != _zz_612),{_zz_613,{_zz_614,_zz_615}}};
  assign _zz_601 = 32'h08000024;
  assign _zz_602 = (decode_INSTRUCTION & 32'h00002030);
  assign _zz_603 = 32'h00002010;
  assign _zz_604 = ((decode_INSTRUCTION & _zz_616) == 32'h00000010);
  assign _zz_605 = (_zz_617 == _zz_618);
  assign _zz_606 = {_zz_619,_zz_620};
  assign _zz_607 = (_zz_621 == _zz_622);
  assign _zz_608 = (_zz_623 == _zz_624);
  assign _zz_609 = _zz_140;
  assign _zz_610 = _zz_139;
  assign _zz_611 = (_zz_625 == _zz_626);
  assign _zz_612 = 1'b0;
  assign _zz_613 = (_zz_627 != 1'b0);
  assign _zz_614 = (_zz_628 != _zz_629);
  assign _zz_615 = {_zz_630,{_zz_631,_zz_632}};
  assign _zz_616 = 32'h00001030;
  assign _zz_617 = (decode_INSTRUCTION & 32'h20005020);
  assign _zz_618 = 32'h00000020;
  assign _zz_619 = ((decode_INSTRUCTION & 32'h68002020) == 32'h00002020);
  assign _zz_620 = ((decode_INSTRUCTION & 32'h68001020) == 32'h00000020);
  assign _zz_621 = (decode_INSTRUCTION & 32'h0000000c);
  assign _zz_622 = 32'h00000004;
  assign _zz_623 = (decode_INSTRUCTION & 32'h00000028);
  assign _zz_624 = 32'h0;
  assign _zz_625 = (decode_INSTRUCTION & 32'h00004014);
  assign _zz_626 = 32'h00004010;
  assign _zz_627 = ((decode_INSTRUCTION & 32'h00006014) == 32'h00002010);
  assign _zz_628 = {(_zz_633 == _zz_634),(_zz_635 == _zz_636)};
  assign _zz_629 = 2'b00;
  assign _zz_630 = ((_zz_637 == _zz_638) != 1'b0);
  assign _zz_631 = ({_zz_639,_zz_640} != 3'b000);
  assign _zz_632 = {(_zz_641 != _zz_642),{_zz_643,_zz_644}};
  assign _zz_633 = (decode_INSTRUCTION & 32'h00000004);
  assign _zz_634 = 32'h0;
  assign _zz_635 = (decode_INSTRUCTION & 32'h00000018);
  assign _zz_636 = 32'h0;
  assign _zz_637 = (decode_INSTRUCTION & 32'h00000058);
  assign _zz_638 = 32'h0;
  assign _zz_639 = _zz_138;
  assign _zz_640 = {((decode_INSTRUCTION & 32'h00002014) == 32'h00002010),((decode_INSTRUCTION & 32'h40000034) == 32'h40000030)};
  assign _zz_641 = ((decode_INSTRUCTION & 32'h00000014) == 32'h00000004);
  assign _zz_642 = 1'b0;
  assign _zz_643 = (((decode_INSTRUCTION & 32'h00000044) == 32'h00000004) != 1'b0);
  assign _zz_644 = (((decode_INSTRUCTION & 32'h00005048) == 32'h00001008) != 1'b0);
  assign _zz_645 = {{{{{{{{{{{_zz_648,_zz_649},_zz_650},execute_SRC1[13]},execute_SRC1[14]},execute_SRC1[15]},execute_SRC1[16]},execute_SRC1[17]},execute_SRC1[18]},execute_SRC1[19]},execute_SRC1[20]},execute_SRC1[21]};
  assign _zz_646 = execute_SRC1[22];
  assign _zz_647 = execute_SRC1[23];
  assign _zz_648 = {{{{{{{{{{_zz_651,_zz_652},execute_SRC1[2]},execute_SRC1[3]},execute_SRC1[4]},execute_SRC1[5]},execute_SRC1[6]},execute_SRC1[7]},execute_SRC1[8]},execute_SRC1[9]},execute_SRC1[10]};
  assign _zz_649 = execute_SRC1[11];
  assign _zz_650 = execute_SRC1[12];
  assign _zz_651 = execute_SRC1[0];
  assign _zz_652 = execute_SRC1[1];
  assign _zz_653 = (! (_zz_201[6] && _zz_201[7]));
  assign _zz_654 = (_zz_201[5] && (! _zz_201[6]));
  assign _zz_655 = (_zz_201[0] && _zz_201[2]);
  assign _zz_656 = _zz_201[4];
  assign _zz_657 = (! (_zz_201[1] && _zz_201[3]));
  assign _zz_658 = (! (_zz_201[1] && (! _zz_201[2])));
  assign _zz_659 = execute_INSTRUCTION[31];
  assign _zz_660 = execute_INSTRUCTION[31];
  assign _zz_661 = execute_INSTRUCTION[7];
  always @ (posedge clk) begin
    if(_zz_481) begin
      _zz_299 <= RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress1];
    end
  end

  always @ (posedge clk) begin
    if(_zz_482) begin
      _zz_300 <= RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress2];
    end
  end

  always @ (posedge clk) begin
    if(_zz_483) begin
      _zz_301 <= RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress3];
    end
  end

  always @ (posedge clk) begin
    if(_zz_84) begin
      RegFilePlugin_regFile[lastStageRegFileWrite_payload_address] <= lastStageRegFileWrite_payload_data;
    end
  end

  InstructionCache IBusCachedPlugin_cache (
    .io_flush                                 (_zz_270                                                     ), //i
    .io_cpu_prefetch_isValid                  (_zz_271                                                     ), //i
    .io_cpu_prefetch_haltIt                   (IBusCachedPlugin_cache_io_cpu_prefetch_haltIt               ), //o
    .io_cpu_prefetch_pc                       (IBusCachedPlugin_iBusRsp_stages_0_input_payload[31:0]       ), //i
    .io_cpu_fetch_isValid                     (_zz_272                                                     ), //i
    .io_cpu_fetch_isStuck                     (_zz_273                                                     ), //i
    .io_cpu_fetch_isRemoved                   (_zz_274                                                     ), //i
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
    .io_cpu_decode_isValid                    (_zz_275                                                     ), //i
    .io_cpu_decode_isStuck                    (_zz_276                                                     ), //i
    .io_cpu_decode_pc                         (IBusCachedPlugin_iBusRsp_stages_2_input_payload[31:0]       ), //i
    .io_cpu_decode_physicalAddress            (IBusCachedPlugin_cache_io_cpu_decode_physicalAddress[31:0]  ), //o
    .io_cpu_decode_data                       (IBusCachedPlugin_cache_io_cpu_decode_data[31:0]             ), //o
    .io_cpu_decode_cacheMiss                  (IBusCachedPlugin_cache_io_cpu_decode_cacheMiss              ), //o
    .io_cpu_decode_error                      (IBusCachedPlugin_cache_io_cpu_decode_error                  ), //o
    .io_cpu_decode_mmuRefilling               (IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling           ), //o
    .io_cpu_decode_mmuException               (IBusCachedPlugin_cache_io_cpu_decode_mmuException           ), //o
    .io_cpu_decode_isUser                     (_zz_277                                                     ), //i
    .io_cpu_fill_valid                        (_zz_278                                                     ), //i
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
    .io_cpu_execute_isValid                    (_zz_279                                            ), //i
    .io_cpu_execute_address                    (_zz_280[31:0]                                      ), //i
    .io_cpu_execute_haltIt                     (dataCache_1_io_cpu_execute_haltIt                  ), //o
    .io_cpu_execute_args_wr                    (execute_MEMORY_WR                                  ), //i
    .io_cpu_execute_args_size                  (execute_DBusCachedPlugin_size[1:0]                 ), //i
    .io_cpu_execute_args_totalyConsistent      (execute_MEMORY_FORCE_CONSTISTENCY                  ), //i
    .io_cpu_execute_refilling                  (dataCache_1_io_cpu_execute_refilling               ), //o
    .io_cpu_memory_isValid                     (_zz_281                                            ), //i
    .io_cpu_memory_isStuck                     (memory_arbitration_isStuck                         ), //i
    .io_cpu_memory_isWrite                     (dataCache_1_io_cpu_memory_isWrite                  ), //o
    .io_cpu_memory_address                     (_zz_282[31:0]                                      ), //i
    .io_cpu_memory_mmuRsp_physicalAddress      (DBusCachedPlugin_mmuBus_rsp_physicalAddress[31:0]  ), //i
    .io_cpu_memory_mmuRsp_isIoAccess           (_zz_283                                            ), //i
    .io_cpu_memory_mmuRsp_isPaging             (DBusCachedPlugin_mmuBus_rsp_isPaging               ), //i
    .io_cpu_memory_mmuRsp_allowRead            (DBusCachedPlugin_mmuBus_rsp_allowRead              ), //i
    .io_cpu_memory_mmuRsp_allowWrite           (DBusCachedPlugin_mmuBus_rsp_allowWrite             ), //i
    .io_cpu_memory_mmuRsp_allowExecute         (DBusCachedPlugin_mmuBus_rsp_allowExecute           ), //i
    .io_cpu_memory_mmuRsp_exception            (DBusCachedPlugin_mmuBus_rsp_exception              ), //i
    .io_cpu_memory_mmuRsp_refilling            (DBusCachedPlugin_mmuBus_rsp_refilling              ), //i
    .io_cpu_memory_mmuRsp_bypassTranslation    (DBusCachedPlugin_mmuBus_rsp_bypassTranslation      ), //i
    .io_cpu_writeBack_isValid                  (_zz_284                                            ), //i
    .io_cpu_writeBack_isStuck                  (writeBack_arbitration_isStuck                      ), //i
    .io_cpu_writeBack_isUser                   (_zz_285                                            ), //i
    .io_cpu_writeBack_haltIt                   (dataCache_1_io_cpu_writeBack_haltIt                ), //o
    .io_cpu_writeBack_isWrite                  (dataCache_1_io_cpu_writeBack_isWrite               ), //o
    .io_cpu_writeBack_storeData                (_zz_286[31:0]                                      ), //i
    .io_cpu_writeBack_data                     (dataCache_1_io_cpu_writeBack_data[31:0]            ), //o
    .io_cpu_writeBack_address                  (_zz_287[31:0]                                      ), //i
    .io_cpu_writeBack_mmuException             (dataCache_1_io_cpu_writeBack_mmuException          ), //o
    .io_cpu_writeBack_unalignedAccess          (dataCache_1_io_cpu_writeBack_unalignedAccess       ), //o
    .io_cpu_writeBack_accessError              (dataCache_1_io_cpu_writeBack_accessError           ), //o
    .io_cpu_writeBack_keepMemRspData           (dataCache_1_io_cpu_writeBack_keepMemRspData        ), //o
    .io_cpu_writeBack_fence_SW                 (_zz_288                                            ), //i
    .io_cpu_writeBack_fence_SR                 (_zz_289                                            ), //i
    .io_cpu_writeBack_fence_SO                 (_zz_290                                            ), //i
    .io_cpu_writeBack_fence_SI                 (_zz_291                                            ), //i
    .io_cpu_writeBack_fence_PW                 (_zz_292                                            ), //i
    .io_cpu_writeBack_fence_PR                 (_zz_293                                            ), //i
    .io_cpu_writeBack_fence_PO                 (_zz_294                                            ), //i
    .io_cpu_writeBack_fence_PI                 (_zz_295                                            ), //i
    .io_cpu_writeBack_fence_FM                 (_zz_296[3:0]                                       ), //i
    .io_cpu_writeBack_exclusiveOk              (dataCache_1_io_cpu_writeBack_exclusiveOk           ), //o
    .io_cpu_redo                               (dataCache_1_io_cpu_redo                            ), //o
    .io_cpu_flush_valid                        (_zz_297                                            ), //i
    .io_cpu_flush_ready                        (dataCache_1_io_cpu_flush_ready                     ), //o
    .io_mem_cmd_valid                          (dataCache_1_io_mem_cmd_valid                       ), //o
    .io_mem_cmd_ready                          (_zz_298                                            ), //i
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
    case(_zz_484)
      2'b00 : begin
        _zz_302 = DBusCachedPlugin_redoBranch_payload;
      end
      2'b01 : begin
        _zz_302 = BranchPlugin_jumpInterface_payload;
      end
      default : begin
        _zz_302 = IBusCachedPlugin_predictionJumpInterface_payload;
      end
    endcase
  end

  always @(*) begin
    case(_zz_485)
      2'b00 : begin
        _zz_303 = writeBack_DBusCachedPlugin_rspSplits_0;
      end
      2'b01 : begin
        _zz_303 = writeBack_DBusCachedPlugin_rspSplits_1;
      end
      2'b10 : begin
        _zz_303 = writeBack_DBusCachedPlugin_rspSplits_2;
      end
      default : begin
        _zz_303 = writeBack_DBusCachedPlugin_rspSplits_3;
      end
    endcase
  end

  always @(*) begin
    case(_zz_486)
      1'b0 : begin
        _zz_304 = writeBack_DBusCachedPlugin_rspSplits_1;
      end
      default : begin
        _zz_304 = writeBack_DBusCachedPlugin_rspSplits_3;
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
    case(decode_BitManipZbtCtrlternary)
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_CMIX : decode_BitManipZbtCtrlternary_string = "CTRL_CMIX";
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_CMOV : decode_BitManipZbtCtrlternary_string = "CTRL_CMOV";
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_FSL : decode_BitManipZbtCtrlternary_string = "CTRL_FSL ";
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_FSR : decode_BitManipZbtCtrlternary_string = "CTRL_FSR ";
      default : decode_BitManipZbtCtrlternary_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_3)
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_CMIX : _zz_3_string = "CTRL_CMIX";
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_CMOV : _zz_3_string = "CTRL_CMOV";
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_FSL : _zz_3_string = "CTRL_FSL ";
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_FSR : _zz_3_string = "CTRL_FSR ";
      default : _zz_3_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_4)
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_CMIX : _zz_4_string = "CTRL_CMIX";
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_CMOV : _zz_4_string = "CTRL_CMOV";
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_FSL : _zz_4_string = "CTRL_FSL ";
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_FSR : _zz_4_string = "CTRL_FSR ";
      default : _zz_4_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_5)
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_CMIX : _zz_5_string = "CTRL_CMIX";
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_CMOV : _zz_5_string = "CTRL_CMOV";
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_FSL : _zz_5_string = "CTRL_FSL ";
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_FSR : _zz_5_string = "CTRL_FSR ";
      default : _zz_5_string = "?????????";
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
    case(_zz_6)
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotB : _zz_6_string = "CTRL_SEXTdotB";
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotH : _zz_6_string = "CTRL_SEXTdotH";
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_ZEXTdotH : _zz_6_string = "CTRL_ZEXTdotH";
      default : _zz_6_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(_zz_7)
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotB : _zz_7_string = "CTRL_SEXTdotB";
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotH : _zz_7_string = "CTRL_SEXTdotH";
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_ZEXTdotH : _zz_7_string = "CTRL_ZEXTdotH";
      default : _zz_7_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(_zz_8)
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotB : _zz_8_string = "CTRL_SEXTdotB";
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotH : _zz_8_string = "CTRL_SEXTdotH";
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_ZEXTdotH : _zz_8_string = "CTRL_ZEXTdotH";
      default : _zz_8_string = "?????????????";
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
    case(_zz_9)
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CLTZ : _zz_9_string = "CTRL_CLTZ";
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CPOP : _zz_9_string = "CTRL_CPOP";
      default : _zz_9_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_10)
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CLTZ : _zz_10_string = "CTRL_CLTZ";
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CPOP : _zz_10_string = "CTRL_CPOP";
      default : _zz_10_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_11)
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CLTZ : _zz_11_string = "CTRL_CLTZ";
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CPOP : _zz_11_string = "CTRL_CPOP";
      default : _zz_11_string = "?????????";
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
    case(_zz_12)
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAX : _zz_12_string = "CTRL_MAX ";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAXU : _zz_12_string = "CTRL_MAXU";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MIN : _zz_12_string = "CTRL_MIN ";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MINU : _zz_12_string = "CTRL_MINU";
      default : _zz_12_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_13)
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAX : _zz_13_string = "CTRL_MAX ";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAXU : _zz_13_string = "CTRL_MAXU";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MIN : _zz_13_string = "CTRL_MIN ";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MINU : _zz_13_string = "CTRL_MINU";
      default : _zz_13_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_14)
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAX : _zz_14_string = "CTRL_MAX ";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAXU : _zz_14_string = "CTRL_MAXU";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MIN : _zz_14_string = "CTRL_MIN ";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MINU : _zz_14_string = "CTRL_MINU";
      default : _zz_14_string = "?????????";
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
    case(_zz_15)
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROL : _zz_15_string = "CTRL_ROL";
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROR : _zz_15_string = "CTRL_ROR";
      default : _zz_15_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_16)
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROL : _zz_16_string = "CTRL_ROL";
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROR : _zz_16_string = "CTRL_ROR";
      default : _zz_16_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_17)
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROL : _zz_17_string = "CTRL_ROL";
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROR : _zz_17_string = "CTRL_ROR";
      default : _zz_17_string = "????????";
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
    case(_zz_18)
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ANDN : _zz_18_string = "CTRL_ANDN";
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ORN : _zz_18_string = "CTRL_ORN ";
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_XNOR : _zz_18_string = "CTRL_XNOR";
      default : _zz_18_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_19)
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ANDN : _zz_19_string = "CTRL_ANDN";
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ORN : _zz_19_string = "CTRL_ORN ";
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_XNOR : _zz_19_string = "CTRL_XNOR";
      default : _zz_19_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_20)
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ANDN : _zz_20_string = "CTRL_ANDN";
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ORN : _zz_20_string = "CTRL_ORN ";
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_XNOR : _zz_20_string = "CTRL_XNOR";
      default : _zz_20_string = "?????????";
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
    case(_zz_21)
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_ORCdotB : _zz_21_string = "CTRL_ORCdotB";
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_REV8 : _zz_21_string = "CTRL_REV8   ";
      default : _zz_21_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_22)
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_ORCdotB : _zz_22_string = "CTRL_ORCdotB";
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_REV8 : _zz_22_string = "CTRL_REV8   ";
      default : _zz_22_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_23)
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_ORCdotB : _zz_23_string = "CTRL_ORCdotB";
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_REV8 : _zz_23_string = "CTRL_REV8   ";
      default : _zz_23_string = "????????????";
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
    case(_zz_24)
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_grevorc : _zz_24_string = "CTRL_grevorc    ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_bitwise : _zz_24_string = "CTRL_bitwise    ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_rotation : _zz_24_string = "CTRL_rotation   ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_minmax : _zz_24_string = "CTRL_minmax     ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_countzeroes : _zz_24_string = "CTRL_countzeroes";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_signextend : _zz_24_string = "CTRL_signextend ";
      default : _zz_24_string = "????????????????";
    endcase
  end
  always @(*) begin
    case(_zz_25)
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_grevorc : _zz_25_string = "CTRL_grevorc    ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_bitwise : _zz_25_string = "CTRL_bitwise    ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_rotation : _zz_25_string = "CTRL_rotation   ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_minmax : _zz_25_string = "CTRL_minmax     ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_countzeroes : _zz_25_string = "CTRL_countzeroes";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_signextend : _zz_25_string = "CTRL_signextend ";
      default : _zz_25_string = "????????????????";
    endcase
  end
  always @(*) begin
    case(_zz_26)
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_grevorc : _zz_26_string = "CTRL_grevorc    ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_bitwise : _zz_26_string = "CTRL_bitwise    ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_rotation : _zz_26_string = "CTRL_rotation   ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_minmax : _zz_26_string = "CTRL_minmax     ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_countzeroes : _zz_26_string = "CTRL_countzeroes";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_signextend : _zz_26_string = "CTRL_signextend ";
      default : _zz_26_string = "????????????????";
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
    case(_zz_27)
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH1ADD : _zz_27_string = "CTRL_SH1ADD";
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH2ADD : _zz_27_string = "CTRL_SH2ADD";
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH3ADD : _zz_27_string = "CTRL_SH3ADD";
      default : _zz_27_string = "???????????";
    endcase
  end
  always @(*) begin
    case(_zz_28)
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH1ADD : _zz_28_string = "CTRL_SH1ADD";
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH2ADD : _zz_28_string = "CTRL_SH2ADD";
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH3ADD : _zz_28_string = "CTRL_SH3ADD";
      default : _zz_28_string = "???????????";
    endcase
  end
  always @(*) begin
    case(_zz_29)
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH1ADD : _zz_29_string = "CTRL_SH1ADD";
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH2ADD : _zz_29_string = "CTRL_SH2ADD";
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH3ADD : _zz_29_string = "CTRL_SH3ADD";
      default : _zz_29_string = "???????????";
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
    case(decode_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : decode_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : decode_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : decode_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : decode_SHIFT_CTRL_string = "SRA_1    ";
      default : decode_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_32)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_32_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_32_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_32_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_32_string = "SRA_1    ";
      default : _zz_32_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_33)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_33_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_33_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_33_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_33_string = "SRA_1    ";
      default : _zz_33_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_34)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_34_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_34_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_34_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_34_string = "SRA_1    ";
      default : _zz_34_string = "?????????";
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
    case(_zz_35)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_35_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_35_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_35_string = "AND_1";
      default : _zz_35_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_36)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_36_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_36_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_36_string = "AND_1";
      default : _zz_36_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_37)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_37_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_37_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_37_string = "AND_1";
      default : _zz_37_string = "?????";
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
    case(_zz_38)
      `Src3CtrlEnum_defaultEncoding_RS : _zz_38_string = "RS ";
      `Src3CtrlEnum_defaultEncoding_IMI : _zz_38_string = "IMI";
      default : _zz_38_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_39)
      `Src3CtrlEnum_defaultEncoding_RS : _zz_39_string = "RS ";
      `Src3CtrlEnum_defaultEncoding_IMI : _zz_39_string = "IMI";
      default : _zz_39_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_40)
      `Src3CtrlEnum_defaultEncoding_RS : _zz_40_string = "RS ";
      `Src3CtrlEnum_defaultEncoding_IMI : _zz_40_string = "IMI";
      default : _zz_40_string = "???";
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
    case(_zz_41)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_41_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_41_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_41_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_41_string = "PC ";
      default : _zz_41_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_42)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_42_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_42_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_42_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_42_string = "PC ";
      default : _zz_42_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_43)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_43_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_43_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_43_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_43_string = "PC ";
      default : _zz_43_string = "???";
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
    case(_zz_44)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_44_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_44_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_44_string = "BITWISE ";
      default : _zz_44_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_45)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_45_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_45_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_45_string = "BITWISE ";
      default : _zz_45_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_46)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_46_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_46_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_46_string = "BITWISE ";
      default : _zz_46_string = "????????";
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
    case(_zz_47)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_47_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_47_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_47_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_47_string = "URS1        ";
      default : _zz_47_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_48)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_48_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_48_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_48_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_48_string = "URS1        ";
      default : _zz_48_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_49)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_49_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_49_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_49_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_49_string = "URS1        ";
      default : _zz_49_string = "????????????";
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
    case(_zz_50)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_50_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_50_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_50_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_50_string = "JALR";
      default : _zz_50_string = "????";
    endcase
  end
  always @(*) begin
    case(execute_BitManipZbtCtrlternary)
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_CMIX : execute_BitManipZbtCtrlternary_string = "CTRL_CMIX";
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_CMOV : execute_BitManipZbtCtrlternary_string = "CTRL_CMOV";
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_FSL : execute_BitManipZbtCtrlternary_string = "CTRL_FSL ";
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_FSR : execute_BitManipZbtCtrlternary_string = "CTRL_FSR ";
      default : execute_BitManipZbtCtrlternary_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_55)
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_CMIX : _zz_55_string = "CTRL_CMIX";
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_CMOV : _zz_55_string = "CTRL_CMOV";
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_FSL : _zz_55_string = "CTRL_FSL ";
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_FSR : _zz_55_string = "CTRL_FSR ";
      default : _zz_55_string = "?????????";
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
    case(_zz_56)
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_grevorc : _zz_56_string = "CTRL_grevorc    ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_bitwise : _zz_56_string = "CTRL_bitwise    ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_rotation : _zz_56_string = "CTRL_rotation   ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_minmax : _zz_56_string = "CTRL_minmax     ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_countzeroes : _zz_56_string = "CTRL_countzeroes";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_signextend : _zz_56_string = "CTRL_signextend ";
      default : _zz_56_string = "????????????????";
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
    case(_zz_57)
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotB : _zz_57_string = "CTRL_SEXTdotB";
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotH : _zz_57_string = "CTRL_SEXTdotH";
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_ZEXTdotH : _zz_57_string = "CTRL_ZEXTdotH";
      default : _zz_57_string = "?????????????";
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
    case(_zz_58)
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CLTZ : _zz_58_string = "CTRL_CLTZ";
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CPOP : _zz_58_string = "CTRL_CPOP";
      default : _zz_58_string = "?????????";
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
    case(_zz_59)
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAX : _zz_59_string = "CTRL_MAX ";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAXU : _zz_59_string = "CTRL_MAXU";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MIN : _zz_59_string = "CTRL_MIN ";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MINU : _zz_59_string = "CTRL_MINU";
      default : _zz_59_string = "?????????";
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
    case(_zz_70)
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROL : _zz_70_string = "CTRL_ROL";
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROR : _zz_70_string = "CTRL_ROR";
      default : _zz_70_string = "????????";
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
    case(_zz_71)
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ANDN : _zz_71_string = "CTRL_ANDN";
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ORN : _zz_71_string = "CTRL_ORN ";
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_XNOR : _zz_71_string = "CTRL_XNOR";
      default : _zz_71_string = "?????????";
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
    case(_zz_72)
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_ORCdotB : _zz_72_string = "CTRL_ORCdotB";
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_REV8 : _zz_72_string = "CTRL_REV8   ";
      default : _zz_72_string = "????????????";
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
    case(_zz_73)
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH1ADD : _zz_73_string = "CTRL_SH1ADD";
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH2ADD : _zz_73_string = "CTRL_SH2ADD";
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH3ADD : _zz_73_string = "CTRL_SH3ADD";
      default : _zz_73_string = "???????????";
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
    case(_zz_75)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_75_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_75_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_75_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_75_string = "SRA_1    ";
      default : _zz_75_string = "?????????";
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
    case(_zz_76)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_76_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_76_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_76_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_76_string = "SRA_1    ";
      default : _zz_76_string = "?????????";
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
    case(_zz_77)
      `Src3CtrlEnum_defaultEncoding_RS : _zz_77_string = "RS ";
      `Src3CtrlEnum_defaultEncoding_IMI : _zz_77_string = "IMI";
      default : _zz_77_string = "???";
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
    case(_zz_79)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_79_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_79_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_79_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_79_string = "PC ";
      default : _zz_79_string = "???";
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
    case(_zz_80)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_80_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_80_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_80_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_80_string = "URS1        ";
      default : _zz_80_string = "????????????";
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
    case(_zz_81)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_81_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_81_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_81_string = "BITWISE ";
      default : _zz_81_string = "????????";
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
    case(_zz_82)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_82_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_82_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_82_string = "AND_1";
      default : _zz_82_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_86)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_86_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_86_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_86_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_86_string = "JALR";
      default : _zz_86_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_87)
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_CMIX : _zz_87_string = "CTRL_CMIX";
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_CMOV : _zz_87_string = "CTRL_CMOV";
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_FSL : _zz_87_string = "CTRL_FSL ";
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_FSR : _zz_87_string = "CTRL_FSR ";
      default : _zz_87_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_88)
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotB : _zz_88_string = "CTRL_SEXTdotB";
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotH : _zz_88_string = "CTRL_SEXTdotH";
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_ZEXTdotH : _zz_88_string = "CTRL_ZEXTdotH";
      default : _zz_88_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(_zz_89)
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CLTZ : _zz_89_string = "CTRL_CLTZ";
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CPOP : _zz_89_string = "CTRL_CPOP";
      default : _zz_89_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_90)
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAX : _zz_90_string = "CTRL_MAX ";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAXU : _zz_90_string = "CTRL_MAXU";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MIN : _zz_90_string = "CTRL_MIN ";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MINU : _zz_90_string = "CTRL_MINU";
      default : _zz_90_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_91)
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROL : _zz_91_string = "CTRL_ROL";
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROR : _zz_91_string = "CTRL_ROR";
      default : _zz_91_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_92)
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ANDN : _zz_92_string = "CTRL_ANDN";
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ORN : _zz_92_string = "CTRL_ORN ";
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_XNOR : _zz_92_string = "CTRL_XNOR";
      default : _zz_92_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_93)
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_ORCdotB : _zz_93_string = "CTRL_ORCdotB";
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_REV8 : _zz_93_string = "CTRL_REV8   ";
      default : _zz_93_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_94)
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_grevorc : _zz_94_string = "CTRL_grevorc    ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_bitwise : _zz_94_string = "CTRL_bitwise    ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_rotation : _zz_94_string = "CTRL_rotation   ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_minmax : _zz_94_string = "CTRL_minmax     ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_countzeroes : _zz_94_string = "CTRL_countzeroes";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_signextend : _zz_94_string = "CTRL_signextend ";
      default : _zz_94_string = "????????????????";
    endcase
  end
  always @(*) begin
    case(_zz_95)
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH1ADD : _zz_95_string = "CTRL_SH1ADD";
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH2ADD : _zz_95_string = "CTRL_SH2ADD";
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH3ADD : _zz_95_string = "CTRL_SH3ADD";
      default : _zz_95_string = "???????????";
    endcase
  end
  always @(*) begin
    case(_zz_96)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_96_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_96_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_96_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_96_string = "SRA_1    ";
      default : _zz_96_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_97)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_97_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_97_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_97_string = "AND_1";
      default : _zz_97_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_98)
      `Src3CtrlEnum_defaultEncoding_RS : _zz_98_string = "RS ";
      `Src3CtrlEnum_defaultEncoding_IMI : _zz_98_string = "IMI";
      default : _zz_98_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_99)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_99_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_99_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_99_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_99_string = "PC ";
      default : _zz_99_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_100)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_100_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_100_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_100_string = "BITWISE ";
      default : _zz_100_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_101)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_101_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_101_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_101_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_101_string = "URS1        ";
      default : _zz_101_string = "????????????";
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
    case(_zz_103)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_103_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_103_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_103_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_103_string = "JALR";
      default : _zz_103_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_149)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_149_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_149_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_149_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_149_string = "URS1        ";
      default : _zz_149_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_150)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_150_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_150_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_150_string = "BITWISE ";
      default : _zz_150_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_151)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_151_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_151_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_151_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_151_string = "PC ";
      default : _zz_151_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_152)
      `Src3CtrlEnum_defaultEncoding_RS : _zz_152_string = "RS ";
      `Src3CtrlEnum_defaultEncoding_IMI : _zz_152_string = "IMI";
      default : _zz_152_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_153)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_153_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_153_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_153_string = "AND_1";
      default : _zz_153_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_154)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_154_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_154_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_154_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_154_string = "SRA_1    ";
      default : _zz_154_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_155)
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH1ADD : _zz_155_string = "CTRL_SH1ADD";
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH2ADD : _zz_155_string = "CTRL_SH2ADD";
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH3ADD : _zz_155_string = "CTRL_SH3ADD";
      default : _zz_155_string = "???????????";
    endcase
  end
  always @(*) begin
    case(_zz_156)
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_grevorc : _zz_156_string = "CTRL_grevorc    ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_bitwise : _zz_156_string = "CTRL_bitwise    ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_rotation : _zz_156_string = "CTRL_rotation   ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_minmax : _zz_156_string = "CTRL_minmax     ";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_countzeroes : _zz_156_string = "CTRL_countzeroes";
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_signextend : _zz_156_string = "CTRL_signextend ";
      default : _zz_156_string = "????????????????";
    endcase
  end
  always @(*) begin
    case(_zz_157)
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_ORCdotB : _zz_157_string = "CTRL_ORCdotB";
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_REV8 : _zz_157_string = "CTRL_REV8   ";
      default : _zz_157_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_158)
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ANDN : _zz_158_string = "CTRL_ANDN";
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_ORN : _zz_158_string = "CTRL_ORN ";
      `BitManipZbbCtrlbitwiseEnum_defaultEncoding_CTRL_XNOR : _zz_158_string = "CTRL_XNOR";
      default : _zz_158_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_159)
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROL : _zz_159_string = "CTRL_ROL";
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROR : _zz_159_string = "CTRL_ROR";
      default : _zz_159_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_160)
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAX : _zz_160_string = "CTRL_MAX ";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAXU : _zz_160_string = "CTRL_MAXU";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MIN : _zz_160_string = "CTRL_MIN ";
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MINU : _zz_160_string = "CTRL_MINU";
      default : _zz_160_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_161)
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CLTZ : _zz_161_string = "CTRL_CLTZ";
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CPOP : _zz_161_string = "CTRL_CPOP";
      default : _zz_161_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_162)
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotB : _zz_162_string = "CTRL_SEXTdotB";
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_SEXTdotH : _zz_162_string = "CTRL_SEXTdotH";
      `BitManipZbbCtrlsignextendEnum_defaultEncoding_CTRL_ZEXTdotH : _zz_162_string = "CTRL_ZEXTdotH";
      default : _zz_162_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(_zz_163)
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_CMIX : _zz_163_string = "CTRL_CMIX";
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_CMOV : _zz_163_string = "CTRL_CMOV";
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_FSL : _zz_163_string = "CTRL_FSL ";
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_FSR : _zz_163_string = "CTRL_FSR ";
      default : _zz_163_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_164)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_164_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_164_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_164_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_164_string = "JALR";
      default : _zz_164_string = "????";
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
    case(decode_to_execute_BitManipZbtCtrlternary)
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_CMIX : decode_to_execute_BitManipZbtCtrlternary_string = "CTRL_CMIX";
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_CMOV : decode_to_execute_BitManipZbtCtrlternary_string = "CTRL_CMOV";
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_FSL : decode_to_execute_BitManipZbtCtrlternary_string = "CTRL_FSL ";
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_FSR : decode_to_execute_BitManipZbtCtrlternary_string = "CTRL_FSR ";
      default : decode_to_execute_BitManipZbtCtrlternary_string = "?????????";
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
  assign execute_BitManipZbt_FINAL_OUTPUT = execute_BitManipZbtPlugin_val_ternary;
  assign execute_BitManipZbb_FINAL_OUTPUT = _zz_208;
  assign execute_BitManipZba_FINAL_OUTPUT = execute_BitManipZbaPlugin_val_sh_add;
  assign execute_SHIFT_RIGHT = _zz_325;
  assign writeBack_REGFILE_WRITE_DATA_ODD = memory_to_writeBack_REGFILE_WRITE_DATA_ODD;
  assign memory_REGFILE_WRITE_DATA_ODD = execute_to_memory_REGFILE_WRITE_DATA_ODD;
  assign execute_REGFILE_WRITE_DATA_ODD = 32'h0;
  assign execute_REGFILE_WRITE_DATA = _zz_166;
  assign memory_MEMORY_STORE_DATA_RF = execute_to_memory_MEMORY_STORE_DATA_RF;
  assign execute_MEMORY_STORE_DATA_RF = _zz_132;
  assign decode_PREDICTION_HAD_BRANCHED2 = IBusCachedPlugin_decodePrediction_cmd_hadBranch;
  assign decode_SRC2_FORCE_ZERO = (decode_SRC_ADD_ZERO && (! decode_SRC_USE_SUB_LESS));
  assign execute_RS3 = decode_to_execute_RS3;
  assign decode_REGFILE_WRITE_VALID_ODD = _zz_137[46];
  assign _zz_1 = _zz_2;
  assign decode_BitManipZbtCtrlternary = _zz_3;
  assign _zz_4 = _zz_5;
  assign execute_IS_BitManipZbt = decode_to_execute_IS_BitManipZbt;
  assign decode_IS_BitManipZbt = _zz_137[40];
  assign decode_BitManipZbbCtrlsignextend = _zz_6;
  assign _zz_7 = _zz_8;
  assign decode_BitManipZbbCtrlcountzeroes = _zz_9;
  assign _zz_10 = _zz_11;
  assign decode_BitManipZbbCtrlminmax = _zz_12;
  assign _zz_13 = _zz_14;
  assign decode_BitManipZbbCtrlrotation = _zz_15;
  assign _zz_16 = _zz_17;
  assign decode_BitManipZbbCtrlbitwise = _zz_18;
  assign _zz_19 = _zz_20;
  assign decode_BitManipZbbCtrlgrevorc = _zz_21;
  assign _zz_22 = _zz_23;
  assign decode_BitManipZbbCtrl = _zz_24;
  assign _zz_25 = _zz_26;
  assign execute_IS_BitManipZbb = decode_to_execute_IS_BitManipZbb;
  assign decode_IS_BitManipZbb = _zz_137[26];
  assign decode_BitManipZbaCtrlsh_add = _zz_27;
  assign _zz_28 = _zz_29;
  assign execute_IS_BitManipZba = decode_to_execute_IS_BitManipZba;
  assign decode_IS_BitManipZba = _zz_137[23];
  assign _zz_30 = _zz_31;
  assign decode_SHIFT_CTRL = _zz_32;
  assign _zz_33 = _zz_34;
  assign decode_ALU_BITWISE_CTRL = _zz_35;
  assign _zz_36 = _zz_37;
  assign decode_SRC_LESS_UNSIGNED = _zz_137[17];
  assign decode_SRC3_CTRL = _zz_38;
  assign _zz_39 = _zz_40;
  assign decode_MEMORY_MANAGMENT = _zz_137[15];
  assign decode_MEMORY_WR = _zz_137[13];
  assign execute_BYPASSABLE_MEMORY_STAGE = decode_to_execute_BYPASSABLE_MEMORY_STAGE;
  assign decode_BYPASSABLE_MEMORY_STAGE = _zz_137[12];
  assign decode_BYPASSABLE_EXECUTE_STAGE = _zz_137[11];
  assign decode_SRC2_CTRL = _zz_41;
  assign _zz_42 = _zz_43;
  assign decode_ALU_CTRL = _zz_44;
  assign _zz_45 = _zz_46;
  assign decode_SRC1_CTRL = _zz_47;
  assign _zz_48 = _zz_49;
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
  assign execute_BRANCH_COND_RESULT = _zz_247;
  assign execute_BRANCH_CTRL = _zz_50;
  assign decode_RS3_USE = _zz_137[39];
  assign decode_RS2_USE = _zz_137[14];
  assign decode_RS1_USE = _zz_137[5];
  assign _zz_51 = execute_REGFILE_WRITE_DATA_ODD;
  assign execute_REGFILE_WRITE_VALID_ODD = decode_to_execute_REGFILE_WRITE_VALID_ODD;
  assign _zz_52 = execute_REGFILE_WRITE_DATA;
  assign execute_REGFILE_WRITE_VALID = decode_to_execute_REGFILE_WRITE_VALID;
  assign execute_BYPASSABLE_EXECUTE_STAGE = decode_to_execute_BYPASSABLE_EXECUTE_STAGE;
  assign _zz_53 = memory_REGFILE_WRITE_DATA_ODD;
  assign memory_REGFILE_WRITE_VALID_ODD = execute_to_memory_REGFILE_WRITE_VALID_ODD;
  assign memory_REGFILE_WRITE_VALID = execute_to_memory_REGFILE_WRITE_VALID;
  assign memory_BYPASSABLE_MEMORY_STAGE = execute_to_memory_BYPASSABLE_MEMORY_STAGE;
  assign memory_INSTRUCTION = execute_to_memory_INSTRUCTION;
  assign _zz_54 = writeBack_REGFILE_WRITE_DATA_ODD;
  assign writeBack_REGFILE_WRITE_VALID_ODD = memory_to_writeBack_REGFILE_WRITE_VALID_ODD;
  assign writeBack_REGFILE_WRITE_VALID = memory_to_writeBack_REGFILE_WRITE_VALID;
  always @ (*) begin
    decode_RS3 = decode_RegFilePlugin_rs3Data;
    if(HazardSimplePlugin_writeBackBuffer_valid)begin
      if(HazardSimplePlugin_addr2Match)begin
        decode_RS3 = HazardSimplePlugin_writeBackBuffer_payload_data;
      end
    end
    if(_zz_305)begin
      if(_zz_306)begin
        if(_zz_221)begin
          decode_RS3 = _zz_102;
        end
      end
    end
    if(_zz_307)begin
      if(_zz_308)begin
        if(_zz_224)begin
          decode_RS3 = _zz_54;
        end
      end
    end
    if(_zz_309)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_231)begin
          decode_RS3 = _zz_74;
        end
      end
    end
    if(_zz_310)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_234)begin
          decode_RS3 = _zz_53;
        end
      end
    end
    if(_zz_311)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_241)begin
          decode_RS3 = _zz_52;
        end
      end
    end
    if(_zz_312)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_244)begin
          decode_RS3 = _zz_51;
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
    if(_zz_305)begin
      if(_zz_306)begin
        if(_zz_220)begin
          decode_RS2 = _zz_102;
        end
      end
    end
    if(_zz_307)begin
      if(_zz_308)begin
        if(_zz_223)begin
          decode_RS2 = _zz_54;
        end
      end
    end
    if(_zz_309)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_230)begin
          decode_RS2 = _zz_74;
        end
      end
    end
    if(_zz_310)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_233)begin
          decode_RS2 = _zz_53;
        end
      end
    end
    if(_zz_311)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_240)begin
          decode_RS2 = _zz_52;
        end
      end
    end
    if(_zz_312)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_243)begin
          decode_RS2 = _zz_51;
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
    if(_zz_305)begin
      if(_zz_306)begin
        if(_zz_219)begin
          decode_RS1 = _zz_102;
        end
      end
    end
    if(_zz_307)begin
      if(_zz_308)begin
        if(_zz_222)begin
          decode_RS1 = _zz_54;
        end
      end
    end
    if(_zz_309)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_229)begin
          decode_RS1 = _zz_74;
        end
      end
    end
    if(_zz_310)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_232)begin
          decode_RS1 = _zz_53;
        end
      end
    end
    if(_zz_311)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_239)begin
          decode_RS1 = _zz_52;
        end
      end
    end
    if(_zz_312)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_242)begin
          decode_RS1 = _zz_51;
        end
      end
    end
  end

  assign memory_BitManipZbt_FINAL_OUTPUT = execute_to_memory_BitManipZbt_FINAL_OUTPUT;
  assign memory_IS_BitManipZbt = execute_to_memory_IS_BitManipZbt;
  assign execute_SRC3 = _zz_175;
  assign execute_BitManipZbtCtrlternary = _zz_55;
  assign memory_BitManipZbb_FINAL_OUTPUT = execute_to_memory_BitManipZbb_FINAL_OUTPUT;
  assign memory_IS_BitManipZbb = execute_to_memory_IS_BitManipZbb;
  assign execute_BitManipZbbCtrl = _zz_56;
  assign execute_BitManipZbbCtrlsignextend = _zz_57;
  assign execute_BitManipZbbCtrlcountzeroes = _zz_58;
  assign execute_BitManipZbbCtrlminmax = _zz_59;
  always @ (*) begin
    _zz_60 = _zz_61;
    _zz_60 = (_zz_182[4] ? {_zz_61[15 : 0],_zz_61[31 : 16]} : _zz_61);
  end

  always @ (*) begin
    _zz_61 = _zz_62;
    _zz_61 = (_zz_182[3] ? {_zz_62[7 : 0],_zz_62[31 : 8]} : _zz_62);
  end

  always @ (*) begin
    _zz_62 = _zz_63;
    _zz_62 = (_zz_182[2] ? {_zz_63[3 : 0],_zz_63[31 : 4]} : _zz_63);
  end

  always @ (*) begin
    _zz_63 = _zz_64;
    _zz_63 = (_zz_182[1] ? {_zz_64[1 : 0],_zz_64[31 : 2]} : _zz_64);
  end

  always @ (*) begin
    _zz_64 = _zz_183;
    _zz_64 = (_zz_182[0] ? {_zz_183[0 : 0],_zz_183[31 : 1]} : _zz_183);
  end

  always @ (*) begin
    _zz_65 = _zz_66;
    _zz_65 = (_zz_180[4] ? {_zz_66[15 : 0],_zz_66[31 : 16]} : _zz_66);
  end

  always @ (*) begin
    _zz_66 = _zz_67;
    _zz_66 = (_zz_180[3] ? {_zz_67[23 : 0],_zz_67[31 : 24]} : _zz_67);
  end

  always @ (*) begin
    _zz_67 = _zz_68;
    _zz_67 = (_zz_180[2] ? {_zz_68[27 : 0],_zz_68[31 : 28]} : _zz_68);
  end

  always @ (*) begin
    _zz_68 = _zz_69;
    _zz_68 = (_zz_180[1] ? {_zz_69[29 : 0],_zz_69[31 : 30]} : _zz_69);
  end

  always @ (*) begin
    _zz_69 = _zz_181;
    _zz_69 = (_zz_180[0] ? {_zz_181[30 : 0],_zz_181[31 : 31]} : _zz_181);
  end

  assign execute_BitManipZbbCtrlrotation = _zz_70;
  assign execute_BitManipZbbCtrlbitwise = _zz_71;
  assign execute_BitManipZbbCtrlgrevorc = _zz_72;
  assign memory_BitManipZba_FINAL_OUTPUT = execute_to_memory_BitManipZba_FINAL_OUTPUT;
  assign memory_IS_BitManipZba = execute_to_memory_IS_BitManipZba;
  assign execute_BitManipZbaCtrlsh_add = _zz_73;
  assign memory_SHIFT_RIGHT = execute_to_memory_SHIFT_RIGHT;
  always @ (*) begin
    _zz_74 = memory_REGFILE_WRITE_DATA;
    if(memory_arbitration_isValid)begin
      case(memory_SHIFT_CTRL)
        `ShiftCtrlEnum_defaultEncoding_SLL_1 : begin
          _zz_74 = _zz_177;
        end
        `ShiftCtrlEnum_defaultEncoding_SRL_1, `ShiftCtrlEnum_defaultEncoding_SRA_1 : begin
          _zz_74 = memory_SHIFT_RIGHT;
        end
        default : begin
        end
      endcase
    end
    if((memory_arbitration_isValid && memory_IS_BitManipZba))begin
      _zz_74 = memory_BitManipZba_FINAL_OUTPUT;
    end
    if((memory_arbitration_isValid && memory_IS_BitManipZbb))begin
      _zz_74 = memory_BitManipZbb_FINAL_OUTPUT;
    end
    if((memory_arbitration_isValid && memory_IS_BitManipZbt))begin
      _zz_74 = memory_BitManipZbt_FINAL_OUTPUT;
    end
  end

  assign memory_SHIFT_CTRL = _zz_75;
  assign execute_SHIFT_CTRL = _zz_76;
  assign execute_SRC_LESS_UNSIGNED = decode_to_execute_SRC_LESS_UNSIGNED;
  assign execute_SRC2_FORCE_ZERO = decode_to_execute_SRC2_FORCE_ZERO;
  assign execute_SRC_USE_SUB_LESS = decode_to_execute_SRC_USE_SUB_LESS;
  assign execute_SRC3_CTRL = _zz_77;
  assign _zz_78 = execute_PC;
  assign execute_SRC2_CTRL = _zz_79;
  assign execute_SRC1_CTRL = _zz_80;
  assign decode_SRC_USE_SUB_LESS = _zz_137[3];
  assign decode_SRC_ADD_ZERO = _zz_137[20];
  assign execute_SRC_ADD_SUB = execute_SrcPlugin_addSub;
  assign execute_SRC_LESS = execute_SrcPlugin_less;
  assign execute_ALU_CTRL = _zz_81;
  assign execute_SRC2 = _zz_172;
  assign execute_SRC1 = _zz_167;
  assign execute_ALU_BITWISE_CTRL = _zz_82;
  assign _zz_83 = writeBack_REGFILE_WRITE_VALID;
  always @ (*) begin
    _zz_84 = 1'b0;
    if(lastStageRegFileWrite_valid)begin
      _zz_84 = 1'b1;
    end
  end

  assign _zz_85 = writeBack_INSTRUCTION;
  assign decode_INSTRUCTION_ANTICIPATED = (decode_arbitration_isStuck ? decode_INSTRUCTION : IBusCachedPlugin_cache_io_cpu_fetch_data);
  always @ (*) begin
    decode_REGFILE_WRITE_VALID = _zz_137[10];
    if((decode_INSTRUCTION[11 : 7] == 5'h0))begin
      decode_REGFILE_WRITE_VALID = 1'b0;
    end
  end

  always @ (*) begin
    _zz_102 = writeBack_REGFILE_WRITE_DATA;
    if((writeBack_arbitration_isValid && writeBack_MEMORY_ENABLE))begin
      _zz_102 = writeBack_DBusCachedPlugin_rspFormated;
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
  assign decode_MEMORY_ENABLE = _zz_137[4];
  assign decode_FLUSH_ALL = _zz_137[0];
  always @ (*) begin
    IBusCachedPlugin_rsp_issueDetected_2 = IBusCachedPlugin_rsp_issueDetected_1;
    if(_zz_313)begin
      IBusCachedPlugin_rsp_issueDetected_2 = 1'b1;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_rsp_issueDetected_1 = IBusCachedPlugin_rsp_issueDetected;
    if(_zz_314)begin
      IBusCachedPlugin_rsp_issueDetected_1 = 1'b1;
    end
  end

  assign decode_BRANCH_CTRL = _zz_103;
  assign decode_INSTRUCTION = IBusCachedPlugin_iBusRsp_output_payload_rsp_inst;
  always @ (*) begin
    _zz_104 = memory_FORMAL_PC_NEXT;
    if(BranchPlugin_jumpInterface_valid)begin
      _zz_104 = BranchPlugin_jumpInterface_payload;
    end
  end

  always @ (*) begin
    _zz_105 = decode_FORMAL_PC_NEXT;
    if(IBusCachedPlugin_predictionJumpInterface_valid)begin
      _zz_105 = IBusCachedPlugin_predictionJumpInterface_payload;
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
    if(((_zz_297 && (! dataCache_1_io_cpu_flush_ready)) || dataCache_1_io_cpu_execute_haltIt))begin
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
    if((_zz_284 && dataCache_1_io_cpu_writeBack_haltIt))begin
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
  assign _zz_106 = {IBusCachedPlugin_predictionJumpInterface_valid,{BranchPlugin_jumpInterface_valid,DBusCachedPlugin_redoBranch_valid}};
  assign _zz_107 = (_zz_106 & (~ _zz_327));
  assign _zz_108 = _zz_107[1];
  assign _zz_109 = _zz_107[2];
  assign IBusCachedPlugin_jump_pcLoad_payload = _zz_302;
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
    IBusCachedPlugin_fetchPc_pc = (IBusCachedPlugin_fetchPc_pcReg + _zz_329);
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

  assign _zz_110 = (! IBusCachedPlugin_iBusRsp_stages_0_halt);
  assign IBusCachedPlugin_iBusRsp_stages_0_input_ready = (IBusCachedPlugin_iBusRsp_stages_0_output_ready && _zz_110);
  assign IBusCachedPlugin_iBusRsp_stages_0_output_valid = (IBusCachedPlugin_iBusRsp_stages_0_input_valid && _zz_110);
  assign IBusCachedPlugin_iBusRsp_stages_0_output_payload = IBusCachedPlugin_iBusRsp_stages_0_input_payload;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_stages_1_halt = 1'b0;
    if(IBusCachedPlugin_mmuBus_busy)begin
      IBusCachedPlugin_iBusRsp_stages_1_halt = 1'b1;
    end
  end

  assign _zz_111 = (! IBusCachedPlugin_iBusRsp_stages_1_halt);
  assign IBusCachedPlugin_iBusRsp_stages_1_input_ready = (IBusCachedPlugin_iBusRsp_stages_1_output_ready && _zz_111);
  assign IBusCachedPlugin_iBusRsp_stages_1_output_valid = (IBusCachedPlugin_iBusRsp_stages_1_input_valid && _zz_111);
  assign IBusCachedPlugin_iBusRsp_stages_1_output_payload = IBusCachedPlugin_iBusRsp_stages_1_input_payload;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_stages_2_halt = 1'b0;
    if((IBusCachedPlugin_rsp_issueDetected_2 || IBusCachedPlugin_rsp_iBusRspOutputHalt))begin
      IBusCachedPlugin_iBusRsp_stages_2_halt = 1'b1;
    end
  end

  assign _zz_112 = (! IBusCachedPlugin_iBusRsp_stages_2_halt);
  assign IBusCachedPlugin_iBusRsp_stages_2_input_ready = (IBusCachedPlugin_iBusRsp_stages_2_output_ready && _zz_112);
  assign IBusCachedPlugin_iBusRsp_stages_2_output_valid = (IBusCachedPlugin_iBusRsp_stages_2_input_valid && _zz_112);
  assign IBusCachedPlugin_iBusRsp_stages_2_output_payload = IBusCachedPlugin_iBusRsp_stages_2_input_payload;
  assign IBusCachedPlugin_fetchPc_redo_valid = IBusCachedPlugin_iBusRsp_redoFetch;
  assign IBusCachedPlugin_fetchPc_redo_payload = IBusCachedPlugin_iBusRsp_stages_2_input_payload;
  assign IBusCachedPlugin_iBusRsp_flush = ((decode_arbitration_removeIt || (decode_arbitration_flushNext && (! decode_arbitration_isStuck))) || IBusCachedPlugin_iBusRsp_redoFetch);
  assign IBusCachedPlugin_iBusRsp_stages_0_output_ready = _zz_113;
  assign _zz_113 = ((1'b0 && (! _zz_114)) || IBusCachedPlugin_iBusRsp_stages_1_input_ready);
  assign _zz_114 = _zz_115;
  assign IBusCachedPlugin_iBusRsp_stages_1_input_valid = _zz_114;
  assign IBusCachedPlugin_iBusRsp_stages_1_input_payload = IBusCachedPlugin_fetchPc_pcReg;
  assign IBusCachedPlugin_iBusRsp_stages_1_output_ready = ((1'b0 && (! _zz_116)) || IBusCachedPlugin_iBusRsp_stages_2_input_ready);
  assign _zz_116 = _zz_117;
  assign IBusCachedPlugin_iBusRsp_stages_2_input_valid = _zz_116;
  assign IBusCachedPlugin_iBusRsp_stages_2_input_payload = _zz_118;
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
  assign _zz_119 = _zz_330[11];
  always @ (*) begin
    _zz_120[18] = _zz_119;
    _zz_120[17] = _zz_119;
    _zz_120[16] = _zz_119;
    _zz_120[15] = _zz_119;
    _zz_120[14] = _zz_119;
    _zz_120[13] = _zz_119;
    _zz_120[12] = _zz_119;
    _zz_120[11] = _zz_119;
    _zz_120[10] = _zz_119;
    _zz_120[9] = _zz_119;
    _zz_120[8] = _zz_119;
    _zz_120[7] = _zz_119;
    _zz_120[6] = _zz_119;
    _zz_120[5] = _zz_119;
    _zz_120[4] = _zz_119;
    _zz_120[3] = _zz_119;
    _zz_120[2] = _zz_119;
    _zz_120[1] = _zz_119;
    _zz_120[0] = _zz_119;
  end

  always @ (*) begin
    IBusCachedPlugin_decodePrediction_cmd_hadBranch = ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) || ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_B) && _zz_331[31]));
    if(_zz_125)begin
      IBusCachedPlugin_decodePrediction_cmd_hadBranch = 1'b0;
    end
  end

  assign _zz_121 = _zz_332[19];
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

  assign _zz_123 = _zz_333[11];
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

  always @ (*) begin
    case(decode_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_125 = _zz_334[1];
      end
      default : begin
        _zz_125 = _zz_335[1];
      end
    endcase
  end

  assign IBusCachedPlugin_predictionJumpInterface_valid = (decode_arbitration_isValid && IBusCachedPlugin_decodePrediction_cmd_hadBranch);
  assign _zz_126 = _zz_336[19];
  always @ (*) begin
    _zz_127[10] = _zz_126;
    _zz_127[9] = _zz_126;
    _zz_127[8] = _zz_126;
    _zz_127[7] = _zz_126;
    _zz_127[6] = _zz_126;
    _zz_127[5] = _zz_126;
    _zz_127[4] = _zz_126;
    _zz_127[3] = _zz_126;
    _zz_127[2] = _zz_126;
    _zz_127[1] = _zz_126;
    _zz_127[0] = _zz_126;
  end

  assign _zz_128 = _zz_337[11];
  always @ (*) begin
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
    _zz_129[7] = _zz_128;
    _zz_129[6] = _zz_128;
    _zz_129[5] = _zz_128;
    _zz_129[4] = _zz_128;
    _zz_129[3] = _zz_128;
    _zz_129[2] = _zz_128;
    _zz_129[1] = _zz_128;
    _zz_129[0] = _zz_128;
  end

  assign IBusCachedPlugin_predictionJumpInterface_payload = (decode_PC + ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) ? {{_zz_127,{{{_zz_487,decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]}},1'b0} : {{_zz_129,{{{_zz_488,_zz_489},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0}));
  assign iBus_cmd_valid = IBusCachedPlugin_cache_io_mem_cmd_valid;
  always @ (*) begin
    iBus_cmd_payload_address = IBusCachedPlugin_cache_io_mem_cmd_payload_address;
    iBus_cmd_payload_address = IBusCachedPlugin_cache_io_mem_cmd_payload_address;
  end

  assign iBus_cmd_payload_size = IBusCachedPlugin_cache_io_mem_cmd_payload_size;
  assign IBusCachedPlugin_s0_tightlyCoupledHit = 1'b0;
  assign _zz_271 = (IBusCachedPlugin_iBusRsp_stages_0_input_valid && (! IBusCachedPlugin_s0_tightlyCoupledHit));
  assign _zz_272 = (IBusCachedPlugin_iBusRsp_stages_1_input_valid && (! IBusCachedPlugin_s1_tightlyCoupledHit));
  assign _zz_273 = (! IBusCachedPlugin_iBusRsp_stages_1_input_ready);
  assign IBusCachedPlugin_mmuBus_cmd_0_isValid = _zz_272;
  assign IBusCachedPlugin_mmuBus_cmd_0_isStuck = (! IBusCachedPlugin_iBusRsp_stages_1_input_ready);
  assign IBusCachedPlugin_mmuBus_cmd_0_virtualAddress = IBusCachedPlugin_iBusRsp_stages_1_input_payload;
  assign IBusCachedPlugin_mmuBus_cmd_0_bypassTranslation = 1'b0;
  assign IBusCachedPlugin_mmuBus_end = (IBusCachedPlugin_iBusRsp_stages_1_input_ready || IBusCachedPlugin_externalFlush);
  assign _zz_275 = (IBusCachedPlugin_iBusRsp_stages_2_input_valid && (! IBusCachedPlugin_s2_tightlyCoupledHit));
  assign _zz_276 = (! IBusCachedPlugin_iBusRsp_stages_2_input_ready);
  assign _zz_277 = 1'b0;
  assign IBusCachedPlugin_rsp_iBusRspOutputHalt = 1'b0;
  assign IBusCachedPlugin_rsp_issueDetected = 1'b0;
  always @ (*) begin
    IBusCachedPlugin_rsp_redoFetch = 1'b0;
    if(_zz_314)begin
      IBusCachedPlugin_rsp_redoFetch = 1'b1;
    end
    if(_zz_313)begin
      IBusCachedPlugin_rsp_redoFetch = 1'b1;
    end
  end

  always @ (*) begin
    _zz_278 = (IBusCachedPlugin_rsp_redoFetch && (! IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling));
    if(_zz_313)begin
      _zz_278 = 1'b1;
    end
  end

  assign IBusCachedPlugin_iBusRsp_output_valid = IBusCachedPlugin_iBusRsp_stages_2_output_valid;
  assign IBusCachedPlugin_iBusRsp_stages_2_output_ready = IBusCachedPlugin_iBusRsp_output_ready;
  assign IBusCachedPlugin_iBusRsp_output_payload_rsp_inst = IBusCachedPlugin_cache_io_cpu_decode_data;
  assign IBusCachedPlugin_iBusRsp_output_payload_pc = IBusCachedPlugin_iBusRsp_stages_2_output_payload;
  assign _zz_270 = (decode_arbitration_isValid && decode_FLUSH_ALL);
  assign _zz_298 = ((1'b1 && (! dataCache_1_io_mem_cmd_m2sPipe_valid)) || dataCache_1_io_mem_cmd_m2sPipe_ready);
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
  assign _zz_279 = (execute_arbitration_isValid && execute_MEMORY_ENABLE);
  assign _zz_280 = execute_SRC_ADD;
  always @ (*) begin
    case(execute_DBusCachedPlugin_size)
      2'b00 : begin
        _zz_132 = {{{execute_RS2[7 : 0],execute_RS2[7 : 0]},execute_RS2[7 : 0]},execute_RS2[7 : 0]};
      end
      2'b01 : begin
        _zz_132 = {execute_RS2[15 : 0],execute_RS2[15 : 0]};
      end
      default : begin
        _zz_132 = execute_RS2[31 : 0];
      end
    endcase
  end

  assign _zz_297 = (execute_arbitration_isValid && execute_MEMORY_MANAGMENT);
  assign _zz_281 = (memory_arbitration_isValid && memory_MEMORY_ENABLE);
  assign _zz_282 = memory_REGFILE_WRITE_DATA;
  assign DBusCachedPlugin_mmuBus_cmd_0_isValid = _zz_281;
  assign DBusCachedPlugin_mmuBus_cmd_0_isStuck = memory_arbitration_isStuck;
  assign DBusCachedPlugin_mmuBus_cmd_0_virtualAddress = _zz_282;
  assign DBusCachedPlugin_mmuBus_cmd_0_bypassTranslation = 1'b0;
  assign DBusCachedPlugin_mmuBus_end = ((! memory_arbitration_isStuck) || memory_arbitration_removeIt);
  always @ (*) begin
    _zz_283 = DBusCachedPlugin_mmuBus_rsp_isIoAccess;
    if((1'b0 && (! dataCache_1_io_cpu_memory_isWrite)))begin
      _zz_283 = 1'b1;
    end
  end

  always @ (*) begin
    _zz_284 = (writeBack_arbitration_isValid && writeBack_MEMORY_ENABLE);
    if(writeBack_arbitration_haltByOther)begin
      _zz_284 = 1'b0;
    end
  end

  assign _zz_285 = 1'b0;
  assign _zz_287 = writeBack_REGFILE_WRITE_DATA;
  assign _zz_286[31 : 0] = writeBack_MEMORY_STORE_DATA_RF;
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
    writeBack_DBusCachedPlugin_rspShifted[7 : 0] = _zz_303;
    writeBack_DBusCachedPlugin_rspShifted[15 : 8] = _zz_304;
    writeBack_DBusCachedPlugin_rspShifted[23 : 16] = writeBack_DBusCachedPlugin_rspSplits_2;
    writeBack_DBusCachedPlugin_rspShifted[31 : 24] = writeBack_DBusCachedPlugin_rspSplits_3;
  end

  assign writeBack_DBusCachedPlugin_rspRf = writeBack_DBusCachedPlugin_rspShifted[31 : 0];
  assign _zz_133 = (writeBack_DBusCachedPlugin_rspRf[7] && (! writeBack_INSTRUCTION[14]));
  always @ (*) begin
    _zz_134[31] = _zz_133;
    _zz_134[30] = _zz_133;
    _zz_134[29] = _zz_133;
    _zz_134[28] = _zz_133;
    _zz_134[27] = _zz_133;
    _zz_134[26] = _zz_133;
    _zz_134[25] = _zz_133;
    _zz_134[24] = _zz_133;
    _zz_134[23] = _zz_133;
    _zz_134[22] = _zz_133;
    _zz_134[21] = _zz_133;
    _zz_134[20] = _zz_133;
    _zz_134[19] = _zz_133;
    _zz_134[18] = _zz_133;
    _zz_134[17] = _zz_133;
    _zz_134[16] = _zz_133;
    _zz_134[15] = _zz_133;
    _zz_134[14] = _zz_133;
    _zz_134[13] = _zz_133;
    _zz_134[12] = _zz_133;
    _zz_134[11] = _zz_133;
    _zz_134[10] = _zz_133;
    _zz_134[9] = _zz_133;
    _zz_134[8] = _zz_133;
    _zz_134[7 : 0] = writeBack_DBusCachedPlugin_rspRf[7 : 0];
  end

  assign _zz_135 = (writeBack_DBusCachedPlugin_rspRf[15] && (! writeBack_INSTRUCTION[14]));
  always @ (*) begin
    _zz_136[31] = _zz_135;
    _zz_136[30] = _zz_135;
    _zz_136[29] = _zz_135;
    _zz_136[28] = _zz_135;
    _zz_136[27] = _zz_135;
    _zz_136[26] = _zz_135;
    _zz_136[25] = _zz_135;
    _zz_136[24] = _zz_135;
    _zz_136[23] = _zz_135;
    _zz_136[22] = _zz_135;
    _zz_136[21] = _zz_135;
    _zz_136[20] = _zz_135;
    _zz_136[19] = _zz_135;
    _zz_136[18] = _zz_135;
    _zz_136[17] = _zz_135;
    _zz_136[16] = _zz_135;
    _zz_136[15 : 0] = writeBack_DBusCachedPlugin_rspRf[15 : 0];
  end

  always @ (*) begin
    case(_zz_322)
      2'b00 : begin
        writeBack_DBusCachedPlugin_rspFormated = _zz_134;
      end
      2'b01 : begin
        writeBack_DBusCachedPlugin_rspFormated = _zz_136;
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
  assign _zz_138 = ((decode_INSTRUCTION & 32'h00000044) == 32'h00000040);
  assign _zz_139 = ((decode_INSTRUCTION & 32'h00000020) == 32'h0);
  assign _zz_140 = ((decode_INSTRUCTION & 32'h00000004) == 32'h00000004);
  assign _zz_141 = ((decode_INSTRUCTION & 32'h00000070) == 32'h00000020);
  assign _zz_142 = ((decode_INSTRUCTION & 32'h00000048) == 32'h00000048);
  assign _zz_143 = ((decode_INSTRUCTION & 32'h00000010) == 32'h00000010);
  assign _zz_144 = ((decode_INSTRUCTION & 32'h00003000) == 32'h00002000);
  assign _zz_145 = ((decode_INSTRUCTION & 32'h00001000) == 32'h00001000);
  assign _zz_146 = ((decode_INSTRUCTION & 32'h00002000) == 32'h0);
  assign _zz_147 = ((decode_INSTRUCTION & 32'h00004000) == 32'h00004000);
  assign _zz_148 = ((decode_INSTRUCTION & 32'h04003014) == 32'h04001010);
  assign _zz_137 = {1'b0,{({_zz_142,(_zz_490 == _zz_491)} != 2'b00),{((_zz_492 == _zz_493) != 1'b0),{(_zz_494 != 1'b0),{(_zz_495 != _zz_496),{_zz_497,{_zz_498,_zz_499}}}}}}};
  assign _zz_149 = _zz_137[2 : 1];
  assign _zz_101 = _zz_149;
  assign _zz_150 = _zz_137[7 : 6];
  assign _zz_100 = _zz_150;
  assign _zz_151 = _zz_137[9 : 8];
  assign _zz_99 = _zz_151;
  assign _zz_152 = _zz_137[16 : 16];
  assign _zz_98 = _zz_152;
  assign _zz_153 = _zz_137[19 : 18];
  assign _zz_97 = _zz_153;
  assign _zz_154 = _zz_137[22 : 21];
  assign _zz_96 = _zz_154;
  assign _zz_155 = _zz_137[25 : 24];
  assign _zz_95 = _zz_155;
  assign _zz_156 = _zz_137[29 : 27];
  assign _zz_94 = _zz_156;
  assign _zz_157 = _zz_137[30 : 30];
  assign _zz_93 = _zz_157;
  assign _zz_158 = _zz_137[32 : 31];
  assign _zz_92 = _zz_158;
  assign _zz_159 = _zz_137[33 : 33];
  assign _zz_91 = _zz_159;
  assign _zz_160 = _zz_137[35 : 34];
  assign _zz_90 = _zz_160;
  assign _zz_161 = _zz_137[36 : 36];
  assign _zz_89 = _zz_161;
  assign _zz_162 = _zz_137[38 : 37];
  assign _zz_88 = _zz_162;
  assign _zz_163 = _zz_137[42 : 41];
  assign _zz_87 = _zz_163;
  assign _zz_164 = _zz_137[45 : 44];
  assign _zz_86 = _zz_164;
  assign decode_RegFilePlugin_regFileReadAddress1 = decode_INSTRUCTION_ANTICIPATED[19 : 15];
  assign decode_RegFilePlugin_regFileReadAddress2 = decode_INSTRUCTION_ANTICIPATED[24 : 20];
  assign decode_RegFilePlugin_regFileReadAddress3 = ((decode_INSTRUCTION_ANTICIPATED[6 : 0] == 7'h77) ? decode_INSTRUCTION_ANTICIPATED[11 : 7] : decode_INSTRUCTION_ANTICIPATED[31 : 27]);
  assign decode_RegFilePlugin_rs1Data = _zz_299;
  assign decode_RegFilePlugin_rs2Data = _zz_300;
  assign decode_RegFilePlugin_rs3Data = _zz_301;
  assign writeBack_RegFilePlugin_rdIndex = _zz_85[11 : 7];
  always @ (*) begin
    lastStageRegFileWrite_valid = (_zz_83 && writeBack_arbitration_isFiring);
    if(_zz_165)begin
      lastStageRegFileWrite_valid = 1'b1;
    end
  end

  always @ (*) begin
    lastStageRegFileWrite_payload_address = writeBack_RegFilePlugin_rdIndex;
    if(_zz_165)begin
      lastStageRegFileWrite_payload_address = 5'h0;
    end
  end

  always @ (*) begin
    lastStageRegFileWrite_payload_data = _zz_102;
    if(_zz_165)begin
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
        _zz_166 = execute_IntAluPlugin_bitwise;
      end
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : begin
        _zz_166 = {31'd0, _zz_338};
      end
      default : begin
        _zz_166 = execute_SRC_ADD_SUB;
      end
    endcase
  end

  always @ (*) begin
    case(execute_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : begin
        _zz_167 = execute_RS1;
      end
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : begin
        _zz_167 = {29'd0, _zz_339};
      end
      `Src1CtrlEnum_defaultEncoding_IMU : begin
        _zz_167 = {execute_INSTRUCTION[31 : 12],12'h0};
      end
      default : begin
        _zz_167 = {27'd0, _zz_340};
      end
    endcase
  end

  assign _zz_168 = execute_INSTRUCTION[31];
  always @ (*) begin
    _zz_169[19] = _zz_168;
    _zz_169[18] = _zz_168;
    _zz_169[17] = _zz_168;
    _zz_169[16] = _zz_168;
    _zz_169[15] = _zz_168;
    _zz_169[14] = _zz_168;
    _zz_169[13] = _zz_168;
    _zz_169[12] = _zz_168;
    _zz_169[11] = _zz_168;
    _zz_169[10] = _zz_168;
    _zz_169[9] = _zz_168;
    _zz_169[8] = _zz_168;
    _zz_169[7] = _zz_168;
    _zz_169[6] = _zz_168;
    _zz_169[5] = _zz_168;
    _zz_169[4] = _zz_168;
    _zz_169[3] = _zz_168;
    _zz_169[2] = _zz_168;
    _zz_169[1] = _zz_168;
    _zz_169[0] = _zz_168;
  end

  assign _zz_170 = _zz_341[11];
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
    case(execute_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : begin
        _zz_172 = execute_RS2;
      end
      `Src2CtrlEnum_defaultEncoding_IMI : begin
        _zz_172 = {_zz_169,execute_INSTRUCTION[31 : 20]};
      end
      `Src2CtrlEnum_defaultEncoding_IMS : begin
        _zz_172 = {_zz_171,{execute_INSTRUCTION[31 : 25],execute_INSTRUCTION[11 : 7]}};
      end
      default : begin
        _zz_172 = _zz_78;
      end
    endcase
  end

  assign _zz_173 = execute_INSTRUCTION[31];
  always @ (*) begin
    _zz_174[19] = _zz_173;
    _zz_174[18] = _zz_173;
    _zz_174[17] = _zz_173;
    _zz_174[16] = _zz_173;
    _zz_174[15] = _zz_173;
    _zz_174[14] = _zz_173;
    _zz_174[13] = _zz_173;
    _zz_174[12] = _zz_173;
    _zz_174[11] = _zz_173;
    _zz_174[10] = _zz_173;
    _zz_174[9] = _zz_173;
    _zz_174[8] = _zz_173;
    _zz_174[7] = _zz_173;
    _zz_174[6] = _zz_173;
    _zz_174[5] = _zz_173;
    _zz_174[4] = _zz_173;
    _zz_174[3] = _zz_173;
    _zz_174[2] = _zz_173;
    _zz_174[1] = _zz_173;
    _zz_174[0] = _zz_173;
  end

  always @ (*) begin
    case(execute_SRC3_CTRL)
      `Src3CtrlEnum_defaultEncoding_RS : begin
        _zz_175 = execute_RS3;
      end
      default : begin
        _zz_175 = {_zz_174,execute_INSTRUCTION[31 : 20]};
      end
    endcase
  end

  always @ (*) begin
    execute_SrcPlugin_addSub = _zz_342;
    if(execute_SRC2_FORCE_ZERO)begin
      execute_SrcPlugin_addSub = execute_SRC1;
    end
  end

  assign execute_SrcPlugin_less = ((execute_SRC1[31] == execute_SRC2[31]) ? execute_SrcPlugin_addSub[31] : (execute_SRC_LESS_UNSIGNED ? execute_SRC2[31] : execute_SRC1[31]));
  assign execute_FullBarrelShifterPlugin_amplitude = execute_SRC2[4 : 0];
  always @ (*) begin
    _zz_176[0] = execute_SRC1[31];
    _zz_176[1] = execute_SRC1[30];
    _zz_176[2] = execute_SRC1[29];
    _zz_176[3] = execute_SRC1[28];
    _zz_176[4] = execute_SRC1[27];
    _zz_176[5] = execute_SRC1[26];
    _zz_176[6] = execute_SRC1[25];
    _zz_176[7] = execute_SRC1[24];
    _zz_176[8] = execute_SRC1[23];
    _zz_176[9] = execute_SRC1[22];
    _zz_176[10] = execute_SRC1[21];
    _zz_176[11] = execute_SRC1[20];
    _zz_176[12] = execute_SRC1[19];
    _zz_176[13] = execute_SRC1[18];
    _zz_176[14] = execute_SRC1[17];
    _zz_176[15] = execute_SRC1[16];
    _zz_176[16] = execute_SRC1[15];
    _zz_176[17] = execute_SRC1[14];
    _zz_176[18] = execute_SRC1[13];
    _zz_176[19] = execute_SRC1[12];
    _zz_176[20] = execute_SRC1[11];
    _zz_176[21] = execute_SRC1[10];
    _zz_176[22] = execute_SRC1[9];
    _zz_176[23] = execute_SRC1[8];
    _zz_176[24] = execute_SRC1[7];
    _zz_176[25] = execute_SRC1[6];
    _zz_176[26] = execute_SRC1[5];
    _zz_176[27] = execute_SRC1[4];
    _zz_176[28] = execute_SRC1[3];
    _zz_176[29] = execute_SRC1[2];
    _zz_176[30] = execute_SRC1[1];
    _zz_176[31] = execute_SRC1[0];
  end

  assign execute_FullBarrelShifterPlugin_reversed = ((execute_SHIFT_CTRL == `ShiftCtrlEnum_defaultEncoding_SLL_1) ? _zz_176 : execute_SRC1);
  always @ (*) begin
    _zz_177[0] = memory_SHIFT_RIGHT[31];
    _zz_177[1] = memory_SHIFT_RIGHT[30];
    _zz_177[2] = memory_SHIFT_RIGHT[29];
    _zz_177[3] = memory_SHIFT_RIGHT[28];
    _zz_177[4] = memory_SHIFT_RIGHT[27];
    _zz_177[5] = memory_SHIFT_RIGHT[26];
    _zz_177[6] = memory_SHIFT_RIGHT[25];
    _zz_177[7] = memory_SHIFT_RIGHT[24];
    _zz_177[8] = memory_SHIFT_RIGHT[23];
    _zz_177[9] = memory_SHIFT_RIGHT[22];
    _zz_177[10] = memory_SHIFT_RIGHT[21];
    _zz_177[11] = memory_SHIFT_RIGHT[20];
    _zz_177[12] = memory_SHIFT_RIGHT[19];
    _zz_177[13] = memory_SHIFT_RIGHT[18];
    _zz_177[14] = memory_SHIFT_RIGHT[17];
    _zz_177[15] = memory_SHIFT_RIGHT[16];
    _zz_177[16] = memory_SHIFT_RIGHT[15];
    _zz_177[17] = memory_SHIFT_RIGHT[14];
    _zz_177[18] = memory_SHIFT_RIGHT[13];
    _zz_177[19] = memory_SHIFT_RIGHT[12];
    _zz_177[20] = memory_SHIFT_RIGHT[11];
    _zz_177[21] = memory_SHIFT_RIGHT[10];
    _zz_177[22] = memory_SHIFT_RIGHT[9];
    _zz_177[23] = memory_SHIFT_RIGHT[8];
    _zz_177[24] = memory_SHIFT_RIGHT[7];
    _zz_177[25] = memory_SHIFT_RIGHT[6];
    _zz_177[26] = memory_SHIFT_RIGHT[5];
    _zz_177[27] = memory_SHIFT_RIGHT[4];
    _zz_177[28] = memory_SHIFT_RIGHT[3];
    _zz_177[29] = memory_SHIFT_RIGHT[2];
    _zz_177[30] = memory_SHIFT_RIGHT[1];
    _zz_177[31] = memory_SHIFT_RIGHT[0];
  end

  always @ (*) begin
    case(execute_BitManipZbaCtrlsh_add)
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH1ADD : begin
        execute_BitManipZbaPlugin_val_sh_add = _zz_349;
      end
      `BitManipZbaCtrlsh_addEnum_defaultEncoding_CTRL_SH2ADD : begin
        execute_BitManipZbaPlugin_val_sh_add = _zz_351;
      end
      default : begin
        execute_BitManipZbaPlugin_val_sh_add = _zz_353;
      end
    endcase
  end

  assign _zz_178 = ((execute_SRC1 | _zz_355) | _zz_356);
  assign _zz_179 = ((_zz_178 | _zz_357) | _zz_358);
  always @ (*) begin
    case(execute_BitManipZbbCtrlgrevorc)
      `BitManipZbbCtrlgrevorcEnum_defaultEncoding_CTRL_ORCdotB : begin
        execute_BitManipZbbPlugin_val_grevorc = ((_zz_179 | _zz_359) | _zz_360);
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

  assign _zz_180 = _zz_361[4 : 0];
  assign _zz_181 = execute_SRC1;
  assign _zz_182 = _zz_362[4 : 0];
  assign _zz_183 = execute_SRC1;
  always @ (*) begin
    case(execute_BitManipZbbCtrlrotation)
      `BitManipZbbCtrlrotationEnum_defaultEncoding_CTRL_ROL : begin
        execute_BitManipZbbPlugin_val_rotation = _zz_65;
      end
      default : begin
        execute_BitManipZbbPlugin_val_rotation = _zz_60;
      end
    endcase
  end

  always @ (*) begin
    case(execute_BitManipZbbCtrlminmax)
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAX : begin
        execute_BitManipZbbPlugin_val_minmax = (($signed(_zz_363) < $signed(_zz_364)) ? execute_SRC1 : execute_SRC2);
      end
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MAXU : begin
        execute_BitManipZbbPlugin_val_minmax = ((execute_SRC2 < execute_SRC1) ? execute_SRC1 : execute_SRC2);
      end
      `BitManipZbbCtrlminmaxEnum_defaultEncoding_CTRL_MIN : begin
        execute_BitManipZbbPlugin_val_minmax = (($signed(_zz_365) < $signed(_zz_366)) ? execute_SRC1 : execute_SRC2);
      end
      default : begin
        execute_BitManipZbbPlugin_val_minmax = ((execute_SRC1 < execute_SRC2) ? execute_SRC1 : execute_SRC2);
      end
    endcase
  end

  assign _zz_184 = ((execute_INSTRUCTION[20] == 1'b1) ? {{{{{{{{{{_zz_645,_zz_646},_zz_647},execute_SRC1[24]},execute_SRC1[25]},execute_SRC1[26]},execute_SRC1[27]},execute_SRC1[28]},execute_SRC1[29]},execute_SRC1[30]},execute_SRC1[31]} : execute_SRC1);
  assign _zz_185 = _zz_184[31 : 28];
  assign _zz_186 = {{(! (((_zz_185[0] || _zz_185[1]) || _zz_185[2]) || _zz_185[3])),(! (_zz_185[2] || _zz_185[3]))},(! (_zz_185[3] || (_zz_185[1] && (! _zz_185[2]))))};
  assign _zz_187 = _zz_184[27 : 24];
  assign _zz_188 = {{(! (((_zz_187[0] || _zz_187[1]) || _zz_187[2]) || _zz_187[3])),(! (_zz_187[2] || _zz_187[3]))},(! (_zz_187[3] || (_zz_187[1] && (! _zz_187[2]))))};
  assign _zz_189 = _zz_184[23 : 20];
  assign _zz_190 = {{(! (((_zz_189[0] || _zz_189[1]) || _zz_189[2]) || _zz_189[3])),(! (_zz_189[2] || _zz_189[3]))},(! (_zz_189[3] || (_zz_189[1] && (! _zz_189[2]))))};
  assign _zz_191 = _zz_184[19 : 16];
  assign _zz_192 = {{(! (((_zz_191[0] || _zz_191[1]) || _zz_191[2]) || _zz_191[3])),(! (_zz_191[2] || _zz_191[3]))},(! (_zz_191[3] || (_zz_191[1] && (! _zz_191[2]))))};
  assign _zz_193 = _zz_184[15 : 12];
  assign _zz_194 = {{(! (((_zz_193[0] || _zz_193[1]) || _zz_193[2]) || _zz_193[3])),(! (_zz_193[2] || _zz_193[3]))},(! (_zz_193[3] || (_zz_193[1] && (! _zz_193[2]))))};
  assign _zz_195 = _zz_184[11 : 8];
  assign _zz_196 = {{(! (((_zz_195[0] || _zz_195[1]) || _zz_195[2]) || _zz_195[3])),(! (_zz_195[2] || _zz_195[3]))},(! (_zz_195[3] || (_zz_195[1] && (! _zz_195[2]))))};
  assign _zz_197 = _zz_184[7 : 4];
  assign _zz_198 = {{(! (((_zz_197[0] || _zz_197[1]) || _zz_197[2]) || _zz_197[3])),(! (_zz_197[2] || _zz_197[3]))},(! (_zz_197[3] || (_zz_197[1] && (! _zz_197[2]))))};
  assign _zz_199 = _zz_184[3 : 0];
  assign _zz_200 = {{(! (((_zz_199[0] || _zz_199[1]) || _zz_199[2]) || _zz_199[3])),(! (_zz_199[2] || _zz_199[3]))},(! (_zz_199[3] || (_zz_199[1] && (! _zz_199[2]))))};
  assign _zz_201 = {{{{{{{_zz_200[2],_zz_198[2]},_zz_196[2]},_zz_194[2]},_zz_192[2]},_zz_190[2]},_zz_188[2]},_zz_186[2]};
  assign _zz_202 = (! (_zz_201[0] && _zz_201[1]));
  assign _zz_203 = (! (_zz_201[2] && _zz_201[3]));
  assign _zz_204 = (! (_zz_201[4] && _zz_201[5]));
  assign _zz_205 = (! (_zz_202 || _zz_203));
  assign _zz_206 = {{{(_zz_205 && (! (_zz_204 || _zz_653))),_zz_205},(! (_zz_202 || ((! _zz_203) && _zz_204)))},(! ((! ((! _zz_654) && (_zz_655 && _zz_656))) && (! ((_zz_657 && _zz_658) && _zz_201[0]))))};
  always @ (*) begin
    case(_zz_323)
      3'b000 : begin
        _zz_207 = _zz_186[1 : 0];
      end
      3'b001 : begin
        _zz_207 = _zz_188[1 : 0];
      end
      3'b010 : begin
        _zz_207 = _zz_190[1 : 0];
      end
      3'b011 : begin
        _zz_207 = _zz_192[1 : 0];
      end
      3'b100 : begin
        _zz_207 = _zz_194[1 : 0];
      end
      3'b101 : begin
        _zz_207 = _zz_196[1 : 0];
      end
      3'b110 : begin
        _zz_207 = _zz_198[1 : 0];
      end
      default : begin
        _zz_207 = _zz_200[1 : 0];
      end
    endcase
  end

  always @ (*) begin
    case(execute_BitManipZbbCtrlcountzeroes)
      `BitManipZbbCtrlcountzeroesEnum_defaultEncoding_CTRL_CLTZ : begin
        execute_BitManipZbbPlugin_val_countzeroes = {26'd0, _zz_367};
      end
      default : begin
        execute_BitManipZbbPlugin_val_countzeroes = {26'd0, _zz_368};
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
        _zz_208 = execute_BitManipZbbPlugin_val_grevorc;
      end
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_bitwise : begin
        _zz_208 = execute_BitManipZbbPlugin_val_bitwise;
      end
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_rotation : begin
        _zz_208 = execute_BitManipZbbPlugin_val_rotation;
      end
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_minmax : begin
        _zz_208 = execute_BitManipZbbPlugin_val_minmax;
      end
      `BitManipZbbCtrlEnum_defaultEncoding_CTRL_countzeroes : begin
        _zz_208 = execute_BitManipZbbPlugin_val_countzeroes;
      end
      default : begin
        _zz_208 = execute_BitManipZbbPlugin_val_signextend;
      end
    endcase
  end

  assign _zz_209 = (execute_SRC2 & 32'h0000003f);
  assign _zz_210 = ((32'h00000020 <= _zz_209) ? _zz_464 : _zz_209);
  assign _zz_211 = ((_zz_210 == _zz_209) ? execute_SRC1 : execute_SRC3);
  assign _zz_212 = (execute_SRC2 & 32'h0000003f);
  assign _zz_213 = ((32'h00000020 <= _zz_212) ? _zz_465 : _zz_212);
  assign _zz_214 = ((_zz_213 == _zz_212) ? execute_SRC1 : execute_SRC3);
  always @ (*) begin
    case(execute_BitManipZbtCtrlternary)
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_CMIX : begin
        execute_BitManipZbtPlugin_val_ternary = ((execute_SRC1 & execute_SRC2) | (execute_SRC3 & (~ execute_SRC2)));
      end
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_CMOV : begin
        execute_BitManipZbtPlugin_val_ternary = ((execute_SRC2 != 32'h0) ? execute_SRC1 : execute_SRC3);
      end
      `BitManipZbtCtrlternaryEnum_defaultEncoding_CTRL_FSL : begin
        execute_BitManipZbtPlugin_val_ternary = ((_zz_210 == 32'h0) ? _zz_211 : (_zz_466 | _zz_467));
      end
      default : begin
        execute_BitManipZbtPlugin_val_ternary = ((_zz_213 == 32'h0) ? _zz_214 : (_zz_469 | _zz_470));
      end
    endcase
  end

  always @ (*) begin
    HazardSimplePlugin_src0Hazard = 1'b0;
    if(_zz_315)begin
      if(_zz_316)begin
        if((_zz_219 || _zz_222))begin
          HazardSimplePlugin_src0Hazard = 1'b1;
        end
      end
    end
    if(_zz_317)begin
      if(_zz_318)begin
        if((_zz_229 || _zz_232))begin
          HazardSimplePlugin_src0Hazard = 1'b1;
        end
      end
    end
    if(_zz_319)begin
      if(_zz_320)begin
        if((_zz_239 || _zz_242))begin
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
    if(_zz_315)begin
      if(_zz_316)begin
        if((_zz_220 || _zz_223))begin
          HazardSimplePlugin_src1Hazard = 1'b1;
        end
        if((_zz_221 || _zz_224))begin
          HazardSimplePlugin_src1Hazard = 1'b1;
        end
      end
    end
    if(_zz_317)begin
      if(_zz_318)begin
        if((_zz_230 || _zz_233))begin
          HazardSimplePlugin_src1Hazard = 1'b1;
        end
        if((_zz_231 || _zz_234))begin
          HazardSimplePlugin_src1Hazard = 1'b1;
        end
      end
    end
    if(_zz_319)begin
      if(_zz_320)begin
        if((_zz_240 || _zz_243))begin
          HazardSimplePlugin_src1Hazard = 1'b1;
        end
        if((_zz_241 || _zz_244))begin
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

  assign HazardSimplePlugin_notAES = ((! ((_zz_85 & 32'h3200707f) == 32'h32000033)) && (! ((_zz_85 & 32'h3a00707f) == 32'h30000033)));
  assign HazardSimplePlugin_rdIndex = (HazardSimplePlugin_notAES ? _zz_85[11 : 7] : _zz_85[19 : 15]);
  assign HazardSimplePlugin_regFileReadAddress3 = ((decode_INSTRUCTION[6 : 0] == 7'h77) ? decode_INSTRUCTION[11 : 7] : decode_INSTRUCTION[31 : 27]);
  assign HazardSimplePlugin_writeBackWrites_valid = (_zz_83 && writeBack_arbitration_isFiring);
  assign HazardSimplePlugin_writeBackWrites_payload_address = HazardSimplePlugin_rdIndex;
  assign HazardSimplePlugin_writeBackWrites_payload_data = _zz_102;
  assign HazardSimplePlugin_addr0Match = (HazardSimplePlugin_writeBackBuffer_payload_address == decode_INSTRUCTION[19 : 15]);
  assign HazardSimplePlugin_addr1Match = (HazardSimplePlugin_writeBackBuffer_payload_address == decode_INSTRUCTION[24 : 20]);
  assign HazardSimplePlugin_addr2Match = (HazardSimplePlugin_writeBackBuffer_payload_address == HazardSimplePlugin_regFileReadAddress3);
  assign _zz_215 = ((writeBack_INSTRUCTION & 32'he400707f) == 32'ha0000077);
  assign _zz_216 = (((! ((writeBack_INSTRUCTION & 32'h3200707f) == 32'h32000033)) && (! ((writeBack_INSTRUCTION & 32'h3a00707f) == 32'h30000033))) ? writeBack_INSTRUCTION[11 : 7] : writeBack_INSTRUCTION[19 : 15]);
  assign _zz_217 = (_zz_215 ? (_zz_216 ^ 5'h01) : 5'h0);
  assign _zz_218 = ((decode_INSTRUCTION[6 : 0] == 7'h77) ? decode_INSTRUCTION[11 : 7] : decode_INSTRUCTION[31 : 27]);
  assign _zz_219 = ((_zz_216 != 5'h0) && (_zz_216 == decode_INSTRUCTION[19 : 15]));
  assign _zz_220 = ((_zz_216 != 5'h0) && (_zz_216 == decode_INSTRUCTION[24 : 20]));
  assign _zz_221 = ((_zz_216 != 5'h0) && (_zz_216 == _zz_218));
  assign _zz_222 = ((_zz_217 != 5'h0) && (_zz_217 == decode_INSTRUCTION[19 : 15]));
  assign _zz_223 = ((_zz_217 != 5'h0) && (_zz_217 == decode_INSTRUCTION[24 : 20]));
  assign _zz_224 = ((_zz_217 != 5'h0) && (_zz_217 == _zz_218));
  assign _zz_225 = ((memory_INSTRUCTION & 32'he400707f) == 32'ha0000077);
  assign _zz_226 = (((! ((memory_INSTRUCTION & 32'h3200707f) == 32'h32000033)) && (! ((memory_INSTRUCTION & 32'h3a00707f) == 32'h30000033))) ? memory_INSTRUCTION[11 : 7] : memory_INSTRUCTION[19 : 15]);
  assign _zz_227 = (_zz_225 ? (_zz_226 ^ 5'h01) : 5'h0);
  assign _zz_228 = ((decode_INSTRUCTION[6 : 0] == 7'h77) ? decode_INSTRUCTION[11 : 7] : decode_INSTRUCTION[31 : 27]);
  assign _zz_229 = ((_zz_226 != 5'h0) && (_zz_226 == decode_INSTRUCTION[19 : 15]));
  assign _zz_230 = ((_zz_226 != 5'h0) && (_zz_226 == decode_INSTRUCTION[24 : 20]));
  assign _zz_231 = ((_zz_226 != 5'h0) && (_zz_226 == _zz_228));
  assign _zz_232 = ((_zz_227 != 5'h0) && (_zz_227 == decode_INSTRUCTION[19 : 15]));
  assign _zz_233 = ((_zz_227 != 5'h0) && (_zz_227 == decode_INSTRUCTION[24 : 20]));
  assign _zz_234 = ((_zz_227 != 5'h0) && (_zz_227 == _zz_228));
  assign _zz_235 = ((execute_INSTRUCTION & 32'he400707f) == 32'ha0000077);
  assign _zz_236 = (((! ((execute_INSTRUCTION & 32'h3200707f) == 32'h32000033)) && (! ((execute_INSTRUCTION & 32'h3a00707f) == 32'h30000033))) ? execute_INSTRUCTION[11 : 7] : execute_INSTRUCTION[19 : 15]);
  assign _zz_237 = (_zz_235 ? (_zz_236 ^ 5'h01) : 5'h0);
  assign _zz_238 = ((decode_INSTRUCTION[6 : 0] == 7'h77) ? decode_INSTRUCTION[11 : 7] : decode_INSTRUCTION[31 : 27]);
  assign _zz_239 = ((_zz_236 != 5'h0) && (_zz_236 == decode_INSTRUCTION[19 : 15]));
  assign _zz_240 = ((_zz_236 != 5'h0) && (_zz_236 == decode_INSTRUCTION[24 : 20]));
  assign _zz_241 = ((_zz_236 != 5'h0) && (_zz_236 == _zz_238));
  assign _zz_242 = ((_zz_237 != 5'h0) && (_zz_237 == decode_INSTRUCTION[19 : 15]));
  assign _zz_243 = ((_zz_237 != 5'h0) && (_zz_237 == decode_INSTRUCTION[24 : 20]));
  assign _zz_244 = ((_zz_237 != 5'h0) && (_zz_237 == _zz_238));
  assign execute_BranchPlugin_eq = (execute_SRC1 == execute_SRC2);
  assign _zz_245 = execute_INSTRUCTION[14 : 12];
  always @ (*) begin
    if((_zz_245 == 3'b000)) begin
        _zz_246 = execute_BranchPlugin_eq;
    end else if((_zz_245 == 3'b001)) begin
        _zz_246 = (! execute_BranchPlugin_eq);
    end else if((((_zz_245 & 3'b101) == 3'b101))) begin
        _zz_246 = (! execute_SRC_LESS);
    end else begin
        _zz_246 = execute_SRC_LESS;
    end
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : begin
        _zz_247 = 1'b0;
      end
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_247 = 1'b1;
      end
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        _zz_247 = 1'b1;
      end
      default : begin
        _zz_247 = _zz_246;
      end
    endcase
  end

  assign _zz_248 = execute_INSTRUCTION[31];
  always @ (*) begin
    _zz_249[19] = _zz_248;
    _zz_249[18] = _zz_248;
    _zz_249[17] = _zz_248;
    _zz_249[16] = _zz_248;
    _zz_249[15] = _zz_248;
    _zz_249[14] = _zz_248;
    _zz_249[13] = _zz_248;
    _zz_249[12] = _zz_248;
    _zz_249[11] = _zz_248;
    _zz_249[10] = _zz_248;
    _zz_249[9] = _zz_248;
    _zz_249[8] = _zz_248;
    _zz_249[7] = _zz_248;
    _zz_249[6] = _zz_248;
    _zz_249[5] = _zz_248;
    _zz_249[4] = _zz_248;
    _zz_249[3] = _zz_248;
    _zz_249[2] = _zz_248;
    _zz_249[1] = _zz_248;
    _zz_249[0] = _zz_248;
  end

  assign _zz_250 = _zz_472[19];
  always @ (*) begin
    _zz_251[10] = _zz_250;
    _zz_251[9] = _zz_250;
    _zz_251[8] = _zz_250;
    _zz_251[7] = _zz_250;
    _zz_251[6] = _zz_250;
    _zz_251[5] = _zz_250;
    _zz_251[4] = _zz_250;
    _zz_251[3] = _zz_250;
    _zz_251[2] = _zz_250;
    _zz_251[1] = _zz_250;
    _zz_251[0] = _zz_250;
  end

  assign _zz_252 = _zz_473[11];
  always @ (*) begin
    _zz_253[18] = _zz_252;
    _zz_253[17] = _zz_252;
    _zz_253[16] = _zz_252;
    _zz_253[15] = _zz_252;
    _zz_253[14] = _zz_252;
    _zz_253[13] = _zz_252;
    _zz_253[12] = _zz_252;
    _zz_253[11] = _zz_252;
    _zz_253[10] = _zz_252;
    _zz_253[9] = _zz_252;
    _zz_253[8] = _zz_252;
    _zz_253[7] = _zz_252;
    _zz_253[6] = _zz_252;
    _zz_253[5] = _zz_252;
    _zz_253[4] = _zz_252;
    _zz_253[3] = _zz_252;
    _zz_253[2] = _zz_252;
    _zz_253[1] = _zz_252;
    _zz_253[0] = _zz_252;
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        _zz_254 = (_zz_474[1] ^ execute_RS1[1]);
      end
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_254 = _zz_475[1];
      end
      default : begin
        _zz_254 = _zz_476[1];
      end
    endcase
  end

  assign execute_BranchPlugin_missAlignedTarget = (execute_BRANCH_COND_RESULT && _zz_254);
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

  assign _zz_255 = execute_INSTRUCTION[31];
  always @ (*) begin
    _zz_256[19] = _zz_255;
    _zz_256[18] = _zz_255;
    _zz_256[17] = _zz_255;
    _zz_256[16] = _zz_255;
    _zz_256[15] = _zz_255;
    _zz_256[14] = _zz_255;
    _zz_256[13] = _zz_255;
    _zz_256[12] = _zz_255;
    _zz_256[11] = _zz_255;
    _zz_256[10] = _zz_255;
    _zz_256[9] = _zz_255;
    _zz_256[8] = _zz_255;
    _zz_256[7] = _zz_255;
    _zz_256[6] = _zz_255;
    _zz_256[5] = _zz_255;
    _zz_256[4] = _zz_255;
    _zz_256[3] = _zz_255;
    _zz_256[2] = _zz_255;
    _zz_256[1] = _zz_255;
    _zz_256[0] = _zz_255;
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        execute_BranchPlugin_branch_src2 = {_zz_256,execute_INSTRUCTION[31 : 20]};
      end
      default : begin
        execute_BranchPlugin_branch_src2 = ((execute_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) ? {{_zz_258,{{{_zz_659,execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]}},1'b0} : {{_zz_260,{{{_zz_660,_zz_661},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]}},1'b0});
        if(execute_PREDICTION_HAD_BRANCHED2)begin
          execute_BranchPlugin_branch_src2 = {29'd0, _zz_479};
        end
      end
    endcase
  end

  assign _zz_257 = _zz_477[19];
  always @ (*) begin
    _zz_258[10] = _zz_257;
    _zz_258[9] = _zz_257;
    _zz_258[8] = _zz_257;
    _zz_258[7] = _zz_257;
    _zz_258[6] = _zz_257;
    _zz_258[5] = _zz_257;
    _zz_258[4] = _zz_257;
    _zz_258[3] = _zz_257;
    _zz_258[2] = _zz_257;
    _zz_258[1] = _zz_257;
    _zz_258[0] = _zz_257;
  end

  assign _zz_259 = _zz_478[11];
  always @ (*) begin
    _zz_260[18] = _zz_259;
    _zz_260[17] = _zz_259;
    _zz_260[16] = _zz_259;
    _zz_260[15] = _zz_259;
    _zz_260[14] = _zz_259;
    _zz_260[13] = _zz_259;
    _zz_260[12] = _zz_259;
    _zz_260[11] = _zz_259;
    _zz_260[10] = _zz_259;
    _zz_260[9] = _zz_259;
    _zz_260[8] = _zz_259;
    _zz_260[7] = _zz_259;
    _zz_260[6] = _zz_259;
    _zz_260[5] = _zz_259;
    _zz_260[4] = _zz_259;
    _zz_260[3] = _zz_259;
    _zz_260[2] = _zz_259;
    _zz_260[1] = _zz_259;
    _zz_260[0] = _zz_259;
  end

  assign execute_BranchPlugin_branchAdder = (execute_BranchPlugin_branch_src1 + execute_BranchPlugin_branch_src2);
  assign BranchPlugin_jumpInterface_valid = ((memory_arbitration_isValid && memory_BRANCH_DO) && (! 1'b0));
  assign BranchPlugin_jumpInterface_payload = memory_BRANCH_CALC;
  assign IBusCachedPlugin_decodePrediction_rsp_wasWrong = BranchPlugin_jumpInterface_valid;
  assign _zz_49 = decode_SRC1_CTRL;
  assign _zz_47 = _zz_101;
  assign _zz_80 = decode_to_execute_SRC1_CTRL;
  assign _zz_46 = decode_ALU_CTRL;
  assign _zz_44 = _zz_100;
  assign _zz_81 = decode_to_execute_ALU_CTRL;
  assign _zz_43 = decode_SRC2_CTRL;
  assign _zz_41 = _zz_99;
  assign _zz_79 = decode_to_execute_SRC2_CTRL;
  assign _zz_40 = decode_SRC3_CTRL;
  assign _zz_38 = _zz_98;
  assign _zz_77 = decode_to_execute_SRC3_CTRL;
  assign _zz_37 = decode_ALU_BITWISE_CTRL;
  assign _zz_35 = _zz_97;
  assign _zz_82 = decode_to_execute_ALU_BITWISE_CTRL;
  assign _zz_34 = decode_SHIFT_CTRL;
  assign _zz_31 = execute_SHIFT_CTRL;
  assign _zz_32 = _zz_96;
  assign _zz_76 = decode_to_execute_SHIFT_CTRL;
  assign _zz_75 = execute_to_memory_SHIFT_CTRL;
  assign _zz_29 = decode_BitManipZbaCtrlsh_add;
  assign _zz_27 = _zz_95;
  assign _zz_73 = decode_to_execute_BitManipZbaCtrlsh_add;
  assign _zz_26 = decode_BitManipZbbCtrl;
  assign _zz_24 = _zz_94;
  assign _zz_56 = decode_to_execute_BitManipZbbCtrl;
  assign _zz_23 = decode_BitManipZbbCtrlgrevorc;
  assign _zz_21 = _zz_93;
  assign _zz_72 = decode_to_execute_BitManipZbbCtrlgrevorc;
  assign _zz_20 = decode_BitManipZbbCtrlbitwise;
  assign _zz_18 = _zz_92;
  assign _zz_71 = decode_to_execute_BitManipZbbCtrlbitwise;
  assign _zz_17 = decode_BitManipZbbCtrlrotation;
  assign _zz_15 = _zz_91;
  assign _zz_70 = decode_to_execute_BitManipZbbCtrlrotation;
  assign _zz_14 = decode_BitManipZbbCtrlminmax;
  assign _zz_12 = _zz_90;
  assign _zz_59 = decode_to_execute_BitManipZbbCtrlminmax;
  assign _zz_11 = decode_BitManipZbbCtrlcountzeroes;
  assign _zz_9 = _zz_89;
  assign _zz_58 = decode_to_execute_BitManipZbbCtrlcountzeroes;
  assign _zz_8 = decode_BitManipZbbCtrlsignextend;
  assign _zz_6 = _zz_88;
  assign _zz_57 = decode_to_execute_BitManipZbbCtrlsignextend;
  assign _zz_5 = decode_BitManipZbtCtrlternary;
  assign _zz_3 = _zz_87;
  assign _zz_55 = decode_to_execute_BitManipZbtCtrlternary;
  assign _zz_2 = decode_BRANCH_CTRL;
  assign _zz_103 = _zz_86;
  assign _zz_50 = decode_to_execute_BRANCH_CTRL;
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
  assign iBusWishbone_ADR = {_zz_480,_zz_261};
  assign iBusWishbone_CTI = ((_zz_261 == 2'b11) ? 3'b111 : 3'b010);
  assign iBusWishbone_BTE = 2'b00;
  assign iBusWishbone_SEL = 4'b1111;
  assign iBusWishbone_WE = 1'b0;
  assign iBusWishbone_DAT_MOSI = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
  always @ (*) begin
    iBusWishbone_CYC = 1'b0;
    if(_zz_321)begin
      iBusWishbone_CYC = 1'b1;
    end
  end

  always @ (*) begin
    iBusWishbone_STB = 1'b0;
    if(_zz_321)begin
      iBusWishbone_STB = 1'b1;
    end
  end

  assign iBus_cmd_ready = (iBus_cmd_valid && iBusWishbone_ACK);
  assign iBus_rsp_valid = _zz_262;
  assign iBus_rsp_payload_data = iBusWishbone_DAT_MISO_regNext;
  assign iBus_rsp_payload_error = 1'b0;
  assign _zz_268 = (dBus_cmd_payload_size == 3'b100);
  assign _zz_264 = dBus_cmd_valid;
  assign _zz_266 = dBus_cmd_payload_wr;
  assign _zz_267 = ((! _zz_268) || (_zz_263 == 2'b11));
  assign dBus_cmd_ready = (_zz_265 && (_zz_266 || _zz_267));
  assign dBusWishbone_ADR = ((_zz_268 ? {{dBus_cmd_payload_address[31 : 4],_zz_263},2'b00} : {dBus_cmd_payload_address[31 : 2],2'b00}) >>> 2);
  assign dBusWishbone_CTI = (_zz_268 ? (_zz_267 ? 3'b111 : 3'b010) : 3'b000);
  assign dBusWishbone_BTE = 2'b00;
  assign dBusWishbone_SEL = (_zz_266 ? dBus_cmd_payload_mask : 4'b1111);
  assign dBusWishbone_WE = _zz_266;
  assign dBusWishbone_DAT_MOSI = dBus_cmd_payload_data;
  assign _zz_265 = (_zz_264 && dBusWishbone_ACK);
  assign dBusWishbone_CYC = _zz_264;
  assign dBusWishbone_STB = _zz_264;
  assign dBus_rsp_valid = _zz_269;
  assign dBus_rsp_payload_data = dBusWishbone_DAT_MISO_regNext;
  assign dBus_rsp_payload_error = 1'b0;
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      IBusCachedPlugin_fetchPc_pcReg <= 32'h00410000;
      IBusCachedPlugin_fetchPc_correctionReg <= 1'b0;
      IBusCachedPlugin_fetchPc_booted <= 1'b0;
      IBusCachedPlugin_fetchPc_inc <= 1'b0;
      _zz_115 <= 1'b0;
      _zz_117 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_0 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_1 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_2 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_3 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_4 <= 1'b0;
      IBusCachedPlugin_rspCounter <= _zz_130;
      IBusCachedPlugin_rspCounter <= 32'h0;
      dataCache_1_io_mem_cmd_m2sPipe_rValid <= 1'b0;
      DBusCachedPlugin_rspCounter <= _zz_131;
      DBusCachedPlugin_rspCounter <= 32'h0;
      _zz_165 <= 1'b1;
      HazardSimplePlugin_writeBackBuffer_valid <= 1'b0;
      execute_arbitration_isValid <= 1'b0;
      memory_arbitration_isValid <= 1'b0;
      writeBack_arbitration_isValid <= 1'b0;
      _zz_261 <= 2'b00;
      _zz_262 <= 1'b0;
      _zz_263 <= 2'b00;
      _zz_269 <= 1'b0;
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
        _zz_115 <= 1'b0;
      end
      if(_zz_113)begin
        _zz_115 <= (IBusCachedPlugin_iBusRsp_stages_0_output_valid && (! 1'b0));
      end
      if(IBusCachedPlugin_iBusRsp_flush)begin
        _zz_117 <= 1'b0;
      end
      if(IBusCachedPlugin_iBusRsp_stages_1_output_ready)begin
        _zz_117 <= (IBusCachedPlugin_iBusRsp_stages_1_output_valid && (! IBusCachedPlugin_iBusRsp_flush));
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
      if(_zz_298)begin
        dataCache_1_io_mem_cmd_m2sPipe_rValid <= dataCache_1_io_mem_cmd_valid;
      end
      if(dBus_rsp_valid)begin
        DBusCachedPlugin_rspCounter <= (DBusCachedPlugin_rspCounter + 32'h00000001);
      end
      _zz_165 <= 1'b0;
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
      if(_zz_321)begin
        if(iBusWishbone_ACK)begin
          _zz_261 <= (_zz_261 + 2'b01);
        end
      end
      _zz_262 <= (iBusWishbone_CYC && iBusWishbone_ACK);
      if((_zz_264 && _zz_265))begin
        _zz_263 <= (_zz_263 + 2'b01);
        if(_zz_267)begin
          _zz_263 <= 2'b00;
        end
      end
      _zz_269 <= ((_zz_264 && (! dBusWishbone_WE)) && dBusWishbone_ACK);
    end
  end

  always @ (posedge clk) begin
    if(IBusCachedPlugin_iBusRsp_stages_1_output_ready)begin
      _zz_118 <= IBusCachedPlugin_iBusRsp_stages_1_output_payload;
    end
    if(IBusCachedPlugin_iBusRsp_stages_1_input_ready)begin
      IBusCachedPlugin_s1_tightlyCoupledHit <= IBusCachedPlugin_s0_tightlyCoupledHit;
    end
    if(IBusCachedPlugin_iBusRsp_stages_2_input_ready)begin
      IBusCachedPlugin_s2_tightlyCoupledHit <= IBusCachedPlugin_s1_tightlyCoupledHit;
    end
    if(_zz_298)begin
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
      execute_to_memory_PC <= _zz_78;
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
      decode_to_execute_FORMAL_PC_NEXT <= _zz_105;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_FORMAL_PC_NEXT <= execute_FORMAL_PC_NEXT;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_FORMAL_PC_NEXT <= _zz_104;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_MEMORY_FORCE_CONSTISTENCY <= decode_MEMORY_FORCE_CONSTISTENCY;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC1_CTRL <= _zz_48;
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
      decode_to_execute_ALU_CTRL <= _zz_45;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC2_CTRL <= _zz_42;
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
      decode_to_execute_SRC3_CTRL <= _zz_39;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC_LESS_UNSIGNED <= decode_SRC_LESS_UNSIGNED;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ALU_BITWISE_CTRL <= _zz_36;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SHIFT_CTRL <= _zz_33;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_SHIFT_CTRL <= _zz_30;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_BitManipZba <= decode_IS_BitManipZba;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_IS_BitManipZba <= execute_IS_BitManipZba;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BitManipZbaCtrlsh_add <= _zz_28;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_BitManipZbb <= decode_IS_BitManipZbb;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_IS_BitManipZbb <= execute_IS_BitManipZbb;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BitManipZbbCtrl <= _zz_25;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BitManipZbbCtrlgrevorc <= _zz_22;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BitManipZbbCtrlbitwise <= _zz_19;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BitManipZbbCtrlrotation <= _zz_16;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BitManipZbbCtrlminmax <= _zz_13;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BitManipZbbCtrlcountzeroes <= _zz_10;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BitManipZbbCtrlsignextend <= _zz_7;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_BitManipZbt <= decode_IS_BitManipZbt;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_IS_BitManipZbt <= execute_IS_BitManipZbt;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BitManipZbtCtrlternary <= _zz_4;
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
      execute_to_memory_REGFILE_WRITE_DATA <= _zz_52;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_REGFILE_WRITE_DATA <= _zz_74;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_REGFILE_WRITE_DATA_ODD <= _zz_51;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_REGFILE_WRITE_DATA_ODD <= _zz_53;
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
      execute_to_memory_BitManipZbt_FINAL_OUTPUT <= execute_BitManipZbt_FINAL_OUTPUT;
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
