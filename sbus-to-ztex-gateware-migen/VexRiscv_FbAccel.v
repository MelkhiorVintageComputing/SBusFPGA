// Generator : SpinalHDL v1.7.0a    git head : 150a9b9067020722818dfb17df4a23ac712a7af8
// Component : VexRiscv
// Git hash  : 8ab9a9b12e5d8881e3a895b31b6a57d076192df0

`timescale 1ns/1ps

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
  output     [27:0]   dBusWishbone_ADR,
  input      [127:0]  dBusWishbone_DAT_MISO,
  output     [127:0]  dBusWishbone_DAT_MOSI,
  output     [15:0]   dBusWishbone_SEL,
  input               dBusWishbone_ERR,
  output     [2:0]    dBusWishbone_CTI,
  output     [1:0]    dBusWishbone_BTE,
  input               clk,
  input               reset
);
  localparam ShiftCtrlEnum_DISABLE_1 = 2'd0;
  localparam ShiftCtrlEnum_SLL_1 = 2'd1;
  localparam ShiftCtrlEnum_SRL_1 = 2'd2;
  localparam ShiftCtrlEnum_SRA_1 = 2'd3;
  localparam BranchCtrlEnum_INC = 2'd0;
  localparam BranchCtrlEnum_B = 2'd1;
  localparam BranchCtrlEnum_JAL = 2'd2;
  localparam BranchCtrlEnum_JALR = 2'd3;
  localparam CG6CtrlternaryEnum_CTRL_CMIX = 2'd0;
  localparam CG6CtrlternaryEnum_CTRL_CMOV = 2'd1;
  localparam CG6CtrlternaryEnum_CTRL_FSR = 2'd2;
  localparam CG6CtrlsignextendEnum_CTRL_SEXTdotB = 1'd0;
  localparam CG6CtrlsignextendEnum_CTRL_ZEXTdotH = 1'd1;
  localparam CG6CtrlminmaxEnum_CTRL_MAXU = 1'd0;
  localparam CG6CtrlminmaxEnum_CTRL_MINU = 1'd1;
  localparam CG6CtrlEnum_CTRL_SH2ADD = 3'd0;
  localparam CG6CtrlEnum_CTRL_minmax = 3'd1;
  localparam CG6CtrlEnum_CTRL_signextend = 3'd2;
  localparam CG6CtrlEnum_CTRL_ternary = 3'd3;
  localparam CG6CtrlEnum_CTRL_REV8 = 3'd4;
  localparam AluBitwiseCtrlEnum_XOR_1 = 2'd0;
  localparam AluBitwiseCtrlEnum_OR_1 = 2'd1;
  localparam AluBitwiseCtrlEnum_AND_1 = 2'd2;
  localparam Src3CtrlEnum_RS = 1'd0;
  localparam Src3CtrlEnum_IMI = 1'd1;
  localparam Src2CtrlEnum_RS = 2'd0;
  localparam Src2CtrlEnum_IMI = 2'd1;
  localparam Src2CtrlEnum_IMS = 2'd2;
  localparam Src2CtrlEnum_PC = 2'd3;
  localparam AluCtrlEnum_ADD_SUB = 2'd0;
  localparam AluCtrlEnum_SLT_SLTU = 2'd1;
  localparam AluCtrlEnum_BITWISE = 2'd2;
  localparam Src1CtrlEnum_RS = 2'd0;
  localparam Src1CtrlEnum_IMU = 2'd1;
  localparam Src1CtrlEnum_PC_INCREMENT = 2'd2;
  localparam Src1CtrlEnum_URS1 = 2'd3;

  wire                IBusCachedPlugin_cache_io_flush;
  wire                IBusCachedPlugin_cache_io_cpu_prefetch_isValid;
  wire                IBusCachedPlugin_cache_io_cpu_fetch_isValid;
  wire                IBusCachedPlugin_cache_io_cpu_fetch_isStuck;
  wire                IBusCachedPlugin_cache_io_cpu_fetch_isRemoved;
  wire                IBusCachedPlugin_cache_io_cpu_decode_isValid;
  wire                IBusCachedPlugin_cache_io_cpu_decode_isStuck;
  reg                 IBusCachedPlugin_cache_io_cpu_fill_valid;
  wire                dataCache_1_io_cpu_execute_isValid;
  wire       [31:0]   dataCache_1_io_cpu_execute_address;
  wire       [2:0]    dataCache_1_io_cpu_execute_args_size;
  wire                dataCache_1_io_cpu_memory_isValid;
  wire       [31:0]   dataCache_1_io_cpu_memory_address;
  reg                 dataCache_1_io_cpu_memory_mmuRsp_isIoAccess;
  reg                 dataCache_1_io_cpu_writeBack_isValid;
  reg        [127:0]  dataCache_1_io_cpu_writeBack_storeData;
  wire       [31:0]   dataCache_1_io_cpu_writeBack_address;
  wire                dataCache_1_io_cpu_writeBack_fence_SW;
  wire                dataCache_1_io_cpu_writeBack_fence_SR;
  wire                dataCache_1_io_cpu_writeBack_fence_SO;
  wire                dataCache_1_io_cpu_writeBack_fence_SI;
  wire                dataCache_1_io_cpu_writeBack_fence_PW;
  wire                dataCache_1_io_cpu_writeBack_fence_PR;
  wire                dataCache_1_io_cpu_writeBack_fence_PO;
  wire                dataCache_1_io_cpu_writeBack_fence_PI;
  wire       [3:0]    dataCache_1_io_cpu_writeBack_fence_FM;
  wire                dataCache_1_io_cpu_flush_valid;
  wire                dataCache_1_io_mem_cmd_ready;
  reg        [31:0]   _zz_RegFilePlugin_regFile_port0;
  reg        [31:0]   _zz_RegFilePlugin_regFile_port1;
  reg        [31:0]   _zz_RegFilePlugin_regFile_port2;
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
  wire       [127:0]  dataCache_1_io_cpu_writeBack_data;
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
  wire       [127:0]  dataCache_1_io_mem_cmd_payload_data;
  wire       [15:0]   dataCache_1_io_mem_cmd_payload_mask;
  wire       [2:0]    dataCache_1_io_mem_cmd_payload_size;
  wire                dataCache_1_io_mem_cmd_payload_last;
  wire       [31:0]   _zz_execute_SHIFT_RIGHT;
  wire       [32:0]   _zz_execute_SHIFT_RIGHT_1;
  wire       [32:0]   _zz_execute_SHIFT_RIGHT_2;
  wire       [2:0]    _zz__zz_IBusCachedPlugin_jump_pcLoad_payload_1;
  reg        [31:0]   _zz_IBusCachedPlugin_jump_pcLoad_payload_4;
  wire       [1:0]    _zz_IBusCachedPlugin_jump_pcLoad_payload_5;
  wire       [31:0]   _zz_IBusCachedPlugin_fetchPc_pc;
  wire       [2:0]    _zz_IBusCachedPlugin_fetchPc_pc_1;
  wire       [11:0]   _zz__zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch;
  wire       [31:0]   _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch_2;
  wire       [19:0]   _zz__zz_2;
  wire       [11:0]   _zz__zz_4;
  wire       [31:0]   _zz__zz_6;
  wire       [31:0]   _zz__zz_6_1;
  wire       [19:0]   _zz__zz_IBusCachedPlugin_predictionJumpInterface_payload;
  wire       [11:0]   _zz__zz_IBusCachedPlugin_predictionJumpInterface_payload_2;
  wire                _zz_IBusCachedPlugin_predictionJumpInterface_payload_4;
  wire                _zz_IBusCachedPlugin_predictionJumpInterface_payload_5;
  wire                _zz_IBusCachedPlugin_predictionJumpInterface_payload_6;
  reg        [7:0]    _zz_writeBack_DBusCachedPlugin_rspShifted;
  wire       [3:0]    _zz_writeBack_DBusCachedPlugin_rspShifted_1;
  reg        [7:0]    _zz_writeBack_DBusCachedPlugin_rspShifted_2;
  wire       [2:0]    _zz_writeBack_DBusCachedPlugin_rspShifted_3;
  reg        [7:0]    _zz_writeBack_DBusCachedPlugin_rspShifted_4;
  wire       [1:0]    _zz_writeBack_DBusCachedPlugin_rspShifted_5;
  reg        [7:0]    _zz_writeBack_DBusCachedPlugin_rspShifted_6;
  wire       [1:0]    _zz_writeBack_DBusCachedPlugin_rspShifted_7;
  reg        [7:0]    _zz_writeBack_DBusCachedPlugin_rspShifted_8;
  wire       [0:0]    _zz_writeBack_DBusCachedPlugin_rspShifted_9;
  reg        [7:0]    _zz_writeBack_DBusCachedPlugin_rspShifted_10;
  wire       [0:0]    _zz_writeBack_DBusCachedPlugin_rspShifted_11;
  reg        [7:0]    _zz_writeBack_DBusCachedPlugin_rspShifted_12;
  wire       [0:0]    _zz_writeBack_DBusCachedPlugin_rspShifted_13;
  reg        [7:0]    _zz_writeBack_DBusCachedPlugin_rspShifted_14;
  wire       [0:0]    _zz_writeBack_DBusCachedPlugin_rspShifted_15;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_1;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_2;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_3;
  wire                _zz__zz_decode_REGFILE_WRITE_VALID_ODD_4;
  wire       [0:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_5;
  wire                _zz__zz_decode_REGFILE_WRITE_VALID_ODD_6;
  wire       [0:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_7;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_8;
  wire       [28:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_9;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_10;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_11;
  wire                _zz__zz_decode_REGFILE_WRITE_VALID_ODD_12;
  wire       [2:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_13;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_14;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_15;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_16;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_17;
  wire                _zz__zz_decode_REGFILE_WRITE_VALID_ODD_18;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_19;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_20;
  wire       [0:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_21;
  wire                _zz__zz_decode_REGFILE_WRITE_VALID_ODD_22;
  wire       [0:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_23;
  wire       [1:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_24;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_25;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_26;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_27;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_28;
  wire       [23:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_29;
  wire                _zz__zz_decode_REGFILE_WRITE_VALID_ODD_30;
  wire       [1:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_31;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_32;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_33;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_34;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_35;
  wire                _zz__zz_decode_REGFILE_WRITE_VALID_ODD_36;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_37;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_38;
  wire       [0:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_39;
  wire                _zz__zz_decode_REGFILE_WRITE_VALID_ODD_40;
  wire       [19:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_41;
  wire       [0:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_42;
  wire                _zz__zz_decode_REGFILE_WRITE_VALID_ODD_43;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_44;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_45;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_46;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_47;
  wire       [0:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_48;
  wire       [16:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_49;
  wire                _zz__zz_decode_REGFILE_WRITE_VALID_ODD_50;
  wire       [4:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_51;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_52;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_53;
  wire                _zz__zz_decode_REGFILE_WRITE_VALID_ODD_54;
  wire       [0:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_55;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_56;
  wire       [0:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_57;
  wire                _zz__zz_decode_REGFILE_WRITE_VALID_ODD_58;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_59;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_60;
  wire       [0:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_61;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_62;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_63;
  wire       [12:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_64;
  wire       [4:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_65;
  wire                _zz__zz_decode_REGFILE_WRITE_VALID_ODD_66;
  wire       [0:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_67;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_68;
  wire       [1:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_69;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_70;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_71;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_72;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_73;
  wire                _zz__zz_decode_REGFILE_WRITE_VALID_ODD_74;
  wire       [0:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_75;
  wire       [1:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_76;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_77;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_78;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_79;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_80;
  wire       [0:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_81;
  wire       [0:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_82;
  wire       [0:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_83;
  wire       [8:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_84;
  wire       [1:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_85;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_86;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_87;
  wire                _zz__zz_decode_REGFILE_WRITE_VALID_ODD_88;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_89;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_90;
  wire       [0:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_91;
  wire                _zz__zz_decode_REGFILE_WRITE_VALID_ODD_92;
  wire       [5:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_93;
  wire       [1:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_94;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_95;
  wire                _zz__zz_decode_REGFILE_WRITE_VALID_ODD_96;
  wire       [31:0]   _zz__zz_decode_REGFILE_WRITE_VALID_ODD_97;
  wire       [0:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_98;
  wire       [0:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_99;
  wire       [0:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_100;
  wire       [2:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_101;
  wire                _zz__zz_decode_REGFILE_WRITE_VALID_ODD_102;
  wire       [0:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_103;
  wire       [0:0]    _zz__zz_decode_REGFILE_WRITE_VALID_ODD_104;
  wire                _zz_RegFilePlugin_regFile_port;
  wire                _zz_decode_RegFilePlugin_rs1Data;
  wire                _zz_RegFilePlugin_regFile_port_1;
  wire                _zz_decode_RegFilePlugin_rs2Data;
  wire                _zz_RegFilePlugin_regFile_port_2;
  wire                _zz_decode_RegFilePlugin_rs3Data;
  wire       [0:0]    _zz__zz_execute_REGFILE_WRITE_DATA;
  wire       [2:0]    _zz__zz_execute_SRC1;
  wire       [4:0]    _zz__zz_execute_SRC1_1;
  wire       [11:0]   _zz__zz_execute_SRC2_3;
  wire       [31:0]   _zz_execute_SrcPlugin_addSub;
  wire       [31:0]   _zz_execute_SrcPlugin_addSub_1;
  wire       [31:0]   _zz_execute_SrcPlugin_addSub_2;
  wire       [31:0]   _zz_execute_SrcPlugin_addSub_3;
  wire       [31:0]   _zz_execute_SrcPlugin_addSub_4;
  wire       [31:0]   _zz_execute_SrcPlugin_addSub_5;
  wire       [31:0]   _zz_execute_SrcPlugin_addSub_6;
  wire       [31:0]   _zz__zz_execute_CG6Plugin_val_ternary_1;
  wire       [31:0]   _zz_execute_CG6Plugin_val_ternary_3;
  wire       [31:0]   _zz_execute_CG6Plugin_val_ternary_4;
  wire       [31:0]   _zz_execute_CG6Plugin_val_ternary_5;
  wire       [31:0]   _zz__zz_execute_CG6_FINAL_OUTPUT;
  wire       [31:0]   _zz__zz_execute_CG6_FINAL_OUTPUT_1;
  wire       [19:0]   _zz__zz_execute_BranchPlugin_missAlignedTarget_2;
  wire       [11:0]   _zz__zz_execute_BranchPlugin_missAlignedTarget_4;
  wire       [31:0]   _zz__zz_execute_BranchPlugin_missAlignedTarget_6;
  wire       [31:0]   _zz__zz_execute_BranchPlugin_missAlignedTarget_6_1;
  wire       [31:0]   _zz__zz_execute_BranchPlugin_missAlignedTarget_6_2;
  wire       [19:0]   _zz__zz_execute_BranchPlugin_branch_src2_2;
  wire       [11:0]   _zz__zz_execute_BranchPlugin_branch_src2_4;
  wire                _zz_execute_BranchPlugin_branch_src2_6;
  wire                _zz_execute_BranchPlugin_branch_src2_7;
  wire                _zz_execute_BranchPlugin_branch_src2_8;
  wire       [2:0]    _zz_execute_BranchPlugin_branch_src2_9;
  wire       [26:0]   _zz_iBusWishbone_ADR_1;
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
  wire       [1:0]    _zz_decode_to_execute_BRANCH_CTRL;
  wire       [1:0]    _zz_decode_to_execute_BRANCH_CTRL_1;
  wire       [1:0]    decode_CG6Ctrlternary;
  wire       [1:0]    _zz_decode_CG6Ctrlternary;
  wire       [1:0]    _zz_decode_to_execute_CG6Ctrlternary;
  wire       [1:0]    _zz_decode_to_execute_CG6Ctrlternary_1;
  wire       [0:0]    decode_CG6Ctrlsignextend;
  wire       [0:0]    _zz_decode_CG6Ctrlsignextend;
  wire       [0:0]    _zz_decode_to_execute_CG6Ctrlsignextend;
  wire       [0:0]    _zz_decode_to_execute_CG6Ctrlsignextend_1;
  wire       [0:0]    decode_CG6Ctrlminmax;
  wire       [0:0]    _zz_decode_CG6Ctrlminmax;
  wire       [0:0]    _zz_decode_to_execute_CG6Ctrlminmax;
  wire       [0:0]    _zz_decode_to_execute_CG6Ctrlminmax_1;
  wire       [2:0]    decode_CG6Ctrl;
  wire       [2:0]    _zz_decode_CG6Ctrl;
  wire       [2:0]    _zz_decode_to_execute_CG6Ctrl;
  wire       [2:0]    _zz_decode_to_execute_CG6Ctrl_1;
  wire                execute_IS_CG6;
  wire                decode_IS_CG6;
  wire       [1:0]    _zz_execute_to_memory_SHIFT_CTRL;
  wire       [1:0]    _zz_execute_to_memory_SHIFT_CTRL_1;
  wire       [1:0]    decode_SHIFT_CTRL;
  wire       [1:0]    _zz_decode_SHIFT_CTRL;
  wire       [1:0]    _zz_decode_to_execute_SHIFT_CTRL;
  wire       [1:0]    _zz_decode_to_execute_SHIFT_CTRL_1;
  wire       [1:0]    decode_ALU_BITWISE_CTRL;
  wire       [1:0]    _zz_decode_ALU_BITWISE_CTRL;
  wire       [1:0]    _zz_decode_to_execute_ALU_BITWISE_CTRL;
  wire       [1:0]    _zz_decode_to_execute_ALU_BITWISE_CTRL_1;
  wire                decode_SRC_LESS_UNSIGNED;
  wire       [0:0]    decode_SRC3_CTRL;
  wire       [0:0]    _zz_decode_SRC3_CTRL;
  wire       [0:0]    _zz_decode_to_execute_SRC3_CTRL;
  wire       [0:0]    _zz_decode_to_execute_SRC3_CTRL_1;
  wire                decode_MEMORY_MANAGMENT;
  wire                decode_MEMORY_WR;
  wire                execute_BYPASSABLE_MEMORY_STAGE;
  wire                decode_BYPASSABLE_MEMORY_STAGE;
  wire                decode_BYPASSABLE_EXECUTE_STAGE;
  wire       [1:0]    decode_SRC2_CTRL;
  wire       [1:0]    _zz_decode_SRC2_CTRL;
  wire       [1:0]    _zz_decode_to_execute_SRC2_CTRL;
  wire       [1:0]    _zz_decode_to_execute_SRC2_CTRL_1;
  wire       [1:0]    decode_ALU_CTRL;
  wire       [1:0]    _zz_decode_ALU_CTRL;
  wire       [1:0]    _zz_decode_to_execute_ALU_CTRL;
  wire       [1:0]    _zz_decode_to_execute_ALU_CTRL_1;
  wire       [1:0]    decode_SRC1_CTRL;
  wire       [1:0]    _zz_decode_SRC1_CTRL;
  wire       [1:0]    _zz_decode_to_execute_SRC1_CTRL;
  wire       [1:0]    _zz_decode_to_execute_SRC1_CTRL_1;
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
  wire       [1:0]    execute_BRANCH_CTRL;
  wire       [1:0]    _zz_execute_BRANCH_CTRL;
  wire                decode_RS3_USE;
  wire                decode_RS2_USE;
  wire                decode_RS1_USE;
  wire       [31:0]   _zz_decode_RS3;
  wire                execute_REGFILE_WRITE_VALID_ODD;
  wire       [31:0]   _zz_decode_RS3_1;
  wire                execute_REGFILE_WRITE_VALID;
  wire                execute_BYPASSABLE_EXECUTE_STAGE;
  wire       [31:0]   _zz_decode_RS3_2;
  wire                memory_REGFILE_WRITE_VALID_ODD;
  wire                memory_REGFILE_WRITE_VALID;
  wire                memory_BYPASSABLE_MEMORY_STAGE;
  wire       [31:0]   memory_INSTRUCTION;
  wire       [31:0]   _zz_decode_RS3_3;
  wire                writeBack_REGFILE_WRITE_VALID_ODD;
  wire                writeBack_REGFILE_WRITE_VALID;
  reg        [31:0]   decode_RS3;
  reg        [31:0]   decode_RS2;
  reg        [31:0]   decode_RS1;
  wire       [31:0]   memory_CG6_FINAL_OUTPUT;
  wire                memory_IS_CG6;
  wire       [2:0]    execute_CG6Ctrl;
  wire       [2:0]    _zz_execute_CG6Ctrl;
  wire       [31:0]   execute_SRC3;
  wire       [1:0]    execute_CG6Ctrlternary;
  wire       [1:0]    _zz_execute_CG6Ctrlternary;
  wire       [0:0]    execute_CG6Ctrlsignextend;
  wire       [0:0]    _zz_execute_CG6Ctrlsignextend;
  wire       [0:0]    execute_CG6Ctrlminmax;
  wire       [0:0]    _zz_execute_CG6Ctrlminmax;
  wire       [31:0]   memory_SHIFT_RIGHT;
  reg        [31:0]   _zz_decode_RS3_4;
  wire       [1:0]    memory_SHIFT_CTRL;
  wire       [1:0]    _zz_memory_SHIFT_CTRL;
  wire       [1:0]    execute_SHIFT_CTRL;
  wire       [1:0]    _zz_execute_SHIFT_CTRL;
  wire                execute_SRC_LESS_UNSIGNED;
  wire                execute_SRC2_FORCE_ZERO;
  wire                execute_SRC_USE_SUB_LESS;
  wire       [0:0]    execute_SRC3_CTRL;
  wire       [0:0]    _zz_execute_SRC3_CTRL;
  wire       [31:0]   _zz_execute_SRC2;
  wire       [1:0]    execute_SRC2_CTRL;
  wire       [1:0]    _zz_execute_SRC2_CTRL;
  wire       [1:0]    execute_SRC1_CTRL;
  wire       [1:0]    _zz_execute_SRC1_CTRL;
  wire                decode_SRC_USE_SUB_LESS;
  wire                decode_SRC_ADD_ZERO;
  wire       [31:0]   execute_SRC_ADD_SUB;
  wire                execute_SRC_LESS;
  wire       [1:0]    execute_ALU_CTRL;
  wire       [1:0]    _zz_execute_ALU_CTRL;
  wire       [31:0]   execute_SRC2;
  wire       [31:0]   execute_SRC1;
  wire       [1:0]    execute_ALU_BITWISE_CTRL;
  wire       [1:0]    _zz_execute_ALU_BITWISE_CTRL;
  wire                _zz_lastStageRegFileWrite_valid;
  reg                 _zz_1;
  wire       [31:0]   _zz_writeBack_RegFilePlugin_rdIndex;
  wire       [31:0]   decode_INSTRUCTION_ANTICIPATED;
  reg                 decode_REGFILE_WRITE_VALID;
  wire       [1:0]    _zz_decode_BRANCH_CTRL;
  wire       [1:0]    _zz_decode_CG6Ctrlternary_1;
  wire       [0:0]    _zz_decode_CG6Ctrlsignextend_1;
  wire       [0:0]    _zz_decode_CG6Ctrlminmax_1;
  wire       [2:0]    _zz_decode_CG6Ctrl_1;
  wire       [1:0]    _zz_decode_SHIFT_CTRL_1;
  wire       [1:0]    _zz_decode_ALU_BITWISE_CTRL_1;
  wire       [0:0]    _zz_decode_SRC3_CTRL_1;
  wire       [1:0]    _zz_decode_SRC2_CTRL_1;
  wire       [1:0]    _zz_decode_ALU_CTRL_1;
  wire       [1:0]    _zz_decode_SRC1_CTRL_1;
  reg        [31:0]   _zz_decode_RS3_5;
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
  wire       [1:0]    decode_BRANCH_CTRL;
  wire       [1:0]    _zz_decode_BRANCH_CTRL_1;
  wire       [31:0]   decode_INSTRUCTION;
  reg        [31:0]   _zz_memory_to_writeBack_FORMAL_PC_NEXT;
  reg        [31:0]   _zz_decode_to_execute_FORMAL_PC_NEXT;
  wire       [31:0]   decode_PC;
  wire       [31:0]   writeBack_PC;
  wire       [31:0]   writeBack_INSTRUCTION;
  reg                 decode_arbitration_haltItself;
  reg                 decode_arbitration_haltByOther;
  reg                 decode_arbitration_removeIt;
  wire                decode_arbitration_flushIt;
  reg                 decode_arbitration_flushNext;
  reg                 decode_arbitration_isValid;
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
  wire                IBusCachedPlugin_forceNoDecodeCond;
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
  wire       [127:0]  dBus_cmd_payload_data;
  wire       [15:0]   dBus_cmd_payload_mask;
  wire       [2:0]    dBus_cmd_payload_size;
  wire                dBus_cmd_payload_last;
  wire                dBus_rsp_valid;
  wire       [4:0]    dBus_rsp_payload_aggregated;
  wire                dBus_rsp_payload_last;
  wire       [127:0]  dBus_rsp_payload_data;
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
  wire                BranchPlugin_inDebugNoFetchFlag;
  wire                IBusCachedPlugin_externalFlush;
  wire                IBusCachedPlugin_jump_pcLoad_valid;
  wire       [31:0]   IBusCachedPlugin_jump_pcLoad_payload;
  wire       [2:0]    _zz_IBusCachedPlugin_jump_pcLoad_payload;
  wire       [2:0]    _zz_IBusCachedPlugin_jump_pcLoad_payload_1;
  wire                _zz_IBusCachedPlugin_jump_pcLoad_payload_2;
  wire                _zz_IBusCachedPlugin_jump_pcLoad_payload_3;
  wire                IBusCachedPlugin_fetchPc_output_valid;
  wire                IBusCachedPlugin_fetchPc_output_ready;
  wire       [31:0]   IBusCachedPlugin_fetchPc_output_payload;
  reg        [31:0]   IBusCachedPlugin_fetchPc_pcReg /* verilator public */ ;
  reg                 IBusCachedPlugin_fetchPc_correction;
  reg                 IBusCachedPlugin_fetchPc_correctionReg;
  wire                IBusCachedPlugin_fetchPc_output_fire;
  wire                IBusCachedPlugin_fetchPc_corrected;
  reg                 IBusCachedPlugin_fetchPc_pcRegPropagate;
  reg                 IBusCachedPlugin_fetchPc_booted;
  reg                 IBusCachedPlugin_fetchPc_inc;
  wire                when_Fetcher_l134;
  wire                IBusCachedPlugin_fetchPc_output_fire_1;
  wire                when_Fetcher_l134_1;
  reg        [31:0]   IBusCachedPlugin_fetchPc_pc;
  wire                IBusCachedPlugin_fetchPc_redo_valid;
  wire       [31:0]   IBusCachedPlugin_fetchPc_redo_payload;
  reg                 IBusCachedPlugin_fetchPc_flushed;
  wire                when_Fetcher_l161;
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
  wire                _zz_IBusCachedPlugin_iBusRsp_stages_0_input_ready;
  wire                _zz_IBusCachedPlugin_iBusRsp_stages_1_input_ready;
  wire                _zz_IBusCachedPlugin_iBusRsp_stages_2_input_ready;
  wire                IBusCachedPlugin_iBusRsp_flush;
  wire                _zz_IBusCachedPlugin_iBusRsp_stages_0_output_ready;
  wire                _zz_IBusCachedPlugin_iBusRsp_stages_0_output_ready_1;
  reg                 _zz_IBusCachedPlugin_iBusRsp_stages_0_output_ready_2;
  wire                IBusCachedPlugin_iBusRsp_stages_1_output_m2sPipe_valid;
  wire                IBusCachedPlugin_iBusRsp_stages_1_output_m2sPipe_ready;
  wire       [31:0]   IBusCachedPlugin_iBusRsp_stages_1_output_m2sPipe_payload;
  reg                 _zz_IBusCachedPlugin_iBusRsp_stages_1_output_m2sPipe_valid;
  reg        [31:0]   _zz_IBusCachedPlugin_iBusRsp_stages_1_output_m2sPipe_payload;
  reg                 IBusCachedPlugin_iBusRsp_readyForError;
  wire                IBusCachedPlugin_iBusRsp_output_valid;
  wire                IBusCachedPlugin_iBusRsp_output_ready;
  wire       [31:0]   IBusCachedPlugin_iBusRsp_output_payload_pc;
  wire                IBusCachedPlugin_iBusRsp_output_payload_rsp_error;
  wire       [31:0]   IBusCachedPlugin_iBusRsp_output_payload_rsp_inst;
  wire                IBusCachedPlugin_iBusRsp_output_payload_isRvc;
  wire                when_Fetcher_l243;
  wire                when_Fetcher_l323;
  reg                 IBusCachedPlugin_injector_nextPcCalc_valids_0;
  wire                when_Fetcher_l332;
  reg                 IBusCachedPlugin_injector_nextPcCalc_valids_1;
  wire                when_Fetcher_l332_1;
  reg                 IBusCachedPlugin_injector_nextPcCalc_valids_2;
  wire                when_Fetcher_l332_2;
  reg                 IBusCachedPlugin_injector_nextPcCalc_valids_3;
  wire                when_Fetcher_l332_3;
  reg                 IBusCachedPlugin_injector_nextPcCalc_valids_4;
  wire                when_Fetcher_l332_4;
  wire                _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch;
  reg        [18:0]   _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch_1;
  wire                _zz_2;
  reg        [10:0]   _zz_3;
  wire                _zz_4;
  reg        [18:0]   _zz_5;
  reg                 _zz_6;
  wire                _zz_IBusCachedPlugin_predictionJumpInterface_payload;
  reg        [10:0]   _zz_IBusCachedPlugin_predictionJumpInterface_payload_1;
  wire                _zz_IBusCachedPlugin_predictionJumpInterface_payload_2;
  reg        [18:0]   _zz_IBusCachedPlugin_predictionJumpInterface_payload_3;
  wire                iBus_cmd_valid;
  wire                iBus_cmd_ready;
  reg        [31:0]   iBus_cmd_payload_address;
  wire       [2:0]    iBus_cmd_payload_size;
  wire                iBus_rsp_valid;
  wire       [31:0]   iBus_rsp_payload_data;
  wire                iBus_rsp_payload_error;
  reg        [31:0]   IBusCachedPlugin_rspCounter;
  wire                IBusCachedPlugin_s0_tightlyCoupledHit;
  reg                 IBusCachedPlugin_s1_tightlyCoupledHit;
  reg                 IBusCachedPlugin_s2_tightlyCoupledHit;
  wire                IBusCachedPlugin_rsp_iBusRspOutputHalt;
  wire                IBusCachedPlugin_rsp_issueDetected;
  reg                 IBusCachedPlugin_rsp_redoFetch;
  wire                when_IBusCachedPlugin_l239;
  wire                when_IBusCachedPlugin_l250;
  wire                when_IBusCachedPlugin_l267;
  wire                dataCache_1_io_mem_cmd_s2mPipe_valid;
  wire                dataCache_1_io_mem_cmd_s2mPipe_ready;
  wire                dataCache_1_io_mem_cmd_s2mPipe_payload_wr;
  wire                dataCache_1_io_mem_cmd_s2mPipe_payload_uncached;
  wire       [31:0]   dataCache_1_io_mem_cmd_s2mPipe_payload_address;
  wire       [127:0]  dataCache_1_io_mem_cmd_s2mPipe_payload_data;
  wire       [15:0]   dataCache_1_io_mem_cmd_s2mPipe_payload_mask;
  wire       [2:0]    dataCache_1_io_mem_cmd_s2mPipe_payload_size;
  wire                dataCache_1_io_mem_cmd_s2mPipe_payload_last;
  reg                 dataCache_1_io_mem_cmd_rValid;
  reg                 dataCache_1_io_mem_cmd_rData_wr;
  reg                 dataCache_1_io_mem_cmd_rData_uncached;
  reg        [31:0]   dataCache_1_io_mem_cmd_rData_address;
  reg        [127:0]  dataCache_1_io_mem_cmd_rData_data;
  reg        [15:0]   dataCache_1_io_mem_cmd_rData_mask;
  reg        [2:0]    dataCache_1_io_mem_cmd_rData_size;
  reg                 dataCache_1_io_mem_cmd_rData_last;
  reg                 dBus_rsp_regNext_valid;
  reg        [4:0]    dBus_rsp_regNext_payload_aggregated;
  reg                 dBus_rsp_regNext_payload_last;
  reg        [127:0]  dBus_rsp_regNext_payload_data;
  reg                 dBus_rsp_regNext_payload_error;
  reg        [31:0]   DBusCachedPlugin_rspCounter;
  wire                when_DBusCachedPlugin_l307;
  wire       [1:0]    execute_DBusCachedPlugin_size;
  reg        [31:0]   _zz_execute_MEMORY_STORE_DATA_RF;
  wire                dataCache_1_io_cpu_flush_isStall;
  wire                when_DBusCachedPlugin_l347;
  wire                when_DBusCachedPlugin_l363;
  wire                when_DBusCachedPlugin_l390;
  wire                when_DBusCachedPlugin_l443;
  wire                when_DBusCachedPlugin_l463;
  wire       [7:0]    writeBack_DBusCachedPlugin_rspSplits_0;
  wire       [7:0]    writeBack_DBusCachedPlugin_rspSplits_1;
  wire       [7:0]    writeBack_DBusCachedPlugin_rspSplits_2;
  wire       [7:0]    writeBack_DBusCachedPlugin_rspSplits_3;
  wire       [7:0]    writeBack_DBusCachedPlugin_rspSplits_4;
  wire       [7:0]    writeBack_DBusCachedPlugin_rspSplits_5;
  wire       [7:0]    writeBack_DBusCachedPlugin_rspSplits_6;
  wire       [7:0]    writeBack_DBusCachedPlugin_rspSplits_7;
  wire       [7:0]    writeBack_DBusCachedPlugin_rspSplits_8;
  wire       [7:0]    writeBack_DBusCachedPlugin_rspSplits_9;
  wire       [7:0]    writeBack_DBusCachedPlugin_rspSplits_10;
  wire       [7:0]    writeBack_DBusCachedPlugin_rspSplits_11;
  wire       [7:0]    writeBack_DBusCachedPlugin_rspSplits_12;
  wire       [7:0]    writeBack_DBusCachedPlugin_rspSplits_13;
  wire       [7:0]    writeBack_DBusCachedPlugin_rspSplits_14;
  wire       [7:0]    writeBack_DBusCachedPlugin_rspSplits_15;
  reg        [127:0]  writeBack_DBusCachedPlugin_rspShifted;
  wire       [31:0]   writeBack_DBusCachedPlugin_rspRf;
  wire       [1:0]    switch_Misc_l211;
  wire                _zz_writeBack_DBusCachedPlugin_rspFormated;
  reg        [31:0]   _zz_writeBack_DBusCachedPlugin_rspFormated_1;
  wire                _zz_writeBack_DBusCachedPlugin_rspFormated_2;
  reg        [31:0]   _zz_writeBack_DBusCachedPlugin_rspFormated_3;
  reg        [31:0]   writeBack_DBusCachedPlugin_rspFormated;
  wire                when_DBusCachedPlugin_l489;
  wire       [35:0]   _zz_decode_REGFILE_WRITE_VALID_ODD;
  wire                _zz_decode_REGFILE_WRITE_VALID_ODD_1;
  wire                _zz_decode_REGFILE_WRITE_VALID_ODD_2;
  wire                _zz_decode_REGFILE_WRITE_VALID_ODD_3;
  wire                _zz_decode_REGFILE_WRITE_VALID_ODD_4;
  wire                _zz_decode_REGFILE_WRITE_VALID_ODD_5;
  wire                _zz_decode_REGFILE_WRITE_VALID_ODD_6;
  wire                _zz_decode_REGFILE_WRITE_VALID_ODD_7;
  wire                _zz_decode_REGFILE_WRITE_VALID_ODD_8;
  wire       [1:0]    _zz_decode_SRC1_CTRL_2;
  wire       [1:0]    _zz_decode_ALU_CTRL_2;
  wire       [1:0]    _zz_decode_SRC2_CTRL_2;
  wire       [0:0]    _zz_decode_SRC3_CTRL_2;
  wire       [1:0]    _zz_decode_ALU_BITWISE_CTRL_2;
  wire       [1:0]    _zz_decode_SHIFT_CTRL_2;
  wire       [2:0]    _zz_decode_CG6Ctrl_2;
  wire       [0:0]    _zz_decode_CG6Ctrlminmax_2;
  wire       [0:0]    _zz_decode_CG6Ctrlsignextend_2;
  wire       [1:0]    _zz_decode_CG6Ctrlternary_2;
  wire       [1:0]    _zz_decode_BRANCH_CTRL_2;
  wire                when_RegFilePlugin_l67;
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
  reg                 _zz_7;
  reg        [31:0]   execute_IntAluPlugin_bitwise;
  reg        [31:0]   _zz_execute_REGFILE_WRITE_DATA;
  reg        [31:0]   _zz_execute_SRC1;
  wire                _zz_execute_SRC2_1;
  reg        [19:0]   _zz_execute_SRC2_2;
  wire                _zz_execute_SRC2_3;
  reg        [19:0]   _zz_execute_SRC2_4;
  reg        [31:0]   _zz_execute_SRC2_5;
  wire                _zz_execute_SRC3;
  reg        [19:0]   _zz_execute_SRC3_1;
  reg        [31:0]   _zz_execute_SRC3_2;
  reg        [31:0]   execute_SrcPlugin_addSub;
  wire                execute_SrcPlugin_less;
  wire       [4:0]    execute_FullBarrelShifterPlugin_amplitude;
  reg        [31:0]   _zz_execute_FullBarrelShifterPlugin_reversed;
  wire       [31:0]   execute_FullBarrelShifterPlugin_reversed;
  reg        [31:0]   _zz_decode_RS3_6;
  reg        [31:0]   execute_CG6Plugin_val_minmax;
  reg        [31:0]   execute_CG6Plugin_val_signextend;
  wire       [31:0]   _zz_execute_CG6Plugin_val_ternary;
  wire       [31:0]   _zz_execute_CG6Plugin_val_ternary_1;
  wire       [31:0]   _zz_execute_CG6Plugin_val_ternary_2;
  reg        [31:0]   execute_CG6Plugin_val_ternary;
  reg        [31:0]   _zz_execute_CG6_FINAL_OUTPUT;
  wire                when_CG6_l489;
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
  wire                _zz_when_HazardSimplePlugin_l74;
  wire       [4:0]    _zz_when_HazardSimplePlugin_l59;
  wire       [4:0]    _zz_when_HazardSimplePlugin_l74_1;
  wire       [4:0]    _zz_when_HazardSimplePlugin_l65;
  wire                when_HazardSimplePlugin_l58;
  wire                when_HazardSimplePlugin_l59;
  wire                when_HazardSimplePlugin_l62;
  wire                when_HazardSimplePlugin_l65;
  wire                when_HazardSimplePlugin_l74;
  wire                when_HazardSimplePlugin_l77;
  wire                when_HazardSimplePlugin_l80;
  wire                when_HazardSimplePlugin_l56;
  wire                when_HazardSimplePlugin_l71;
  wire                when_HazardSimplePlugin_l86;
  wire                when_HazardSimplePlugin_l87;
  wire                when_HazardSimplePlugin_l88;
  wire                when_HazardSimplePlugin_l91;
  wire                when_HazardSimplePlugin_l94;
  wire                _zz_when_HazardSimplePlugin_l74_2;
  wire       [4:0]    _zz_when_HazardSimplePlugin_l59_1;
  wire       [4:0]    _zz_when_HazardSimplePlugin_l74_3;
  wire       [4:0]    _zz_when_HazardSimplePlugin_l65_1;
  wire                when_HazardSimplePlugin_l59_1;
  wire                when_HazardSimplePlugin_l62_1;
  wire                when_HazardSimplePlugin_l65_1;
  wire                when_HazardSimplePlugin_l74_1;
  wire                when_HazardSimplePlugin_l77_1;
  wire                when_HazardSimplePlugin_l80_1;
  wire                when_HazardSimplePlugin_l56_1;
  wire                when_HazardSimplePlugin_l71_1;
  wire                when_HazardSimplePlugin_l86_1;
  wire                when_HazardSimplePlugin_l87_1;
  wire                when_HazardSimplePlugin_l88_1;
  wire                when_HazardSimplePlugin_l91_1;
  wire                when_HazardSimplePlugin_l94_1;
  wire                _zz_when_HazardSimplePlugin_l74_4;
  wire       [4:0]    _zz_when_HazardSimplePlugin_l59_2;
  wire       [4:0]    _zz_when_HazardSimplePlugin_l74_5;
  wire       [4:0]    _zz_when_HazardSimplePlugin_l65_2;
  wire                when_HazardSimplePlugin_l59_2;
  wire                when_HazardSimplePlugin_l62_2;
  wire                when_HazardSimplePlugin_l65_2;
  wire                when_HazardSimplePlugin_l74_2;
  wire                when_HazardSimplePlugin_l77_2;
  wire                when_HazardSimplePlugin_l80_2;
  wire                when_HazardSimplePlugin_l56_2;
  wire                when_HazardSimplePlugin_l71_2;
  wire                when_HazardSimplePlugin_l86_2;
  wire                when_HazardSimplePlugin_l87_2;
  wire                when_HazardSimplePlugin_l88_2;
  wire                when_HazardSimplePlugin_l91_2;
  wire                when_HazardSimplePlugin_l94_2;
  wire                when_HazardSimplePlugin_l147;
  wire                when_HazardSimplePlugin_l150;
  wire                when_HazardSimplePlugin_l153;
  wire                when_HazardSimplePlugin_l158;
  wire                execute_BranchPlugin_eq;
  wire       [2:0]    switch_Misc_l211_1;
  reg                 _zz_execute_BRANCH_COND_RESULT;
  reg                 _zz_execute_BRANCH_COND_RESULT_1;
  wire                _zz_execute_BranchPlugin_missAlignedTarget;
  reg        [19:0]   _zz_execute_BranchPlugin_missAlignedTarget_1;
  wire                _zz_execute_BranchPlugin_missAlignedTarget_2;
  reg        [10:0]   _zz_execute_BranchPlugin_missAlignedTarget_3;
  wire                _zz_execute_BranchPlugin_missAlignedTarget_4;
  reg        [18:0]   _zz_execute_BranchPlugin_missAlignedTarget_5;
  reg                 _zz_execute_BranchPlugin_missAlignedTarget_6;
  wire                execute_BranchPlugin_missAlignedTarget;
  reg        [31:0]   execute_BranchPlugin_branch_src1;
  reg        [31:0]   execute_BranchPlugin_branch_src2;
  wire                _zz_execute_BranchPlugin_branch_src2;
  reg        [19:0]   _zz_execute_BranchPlugin_branch_src2_1;
  wire                _zz_execute_BranchPlugin_branch_src2_2;
  reg        [10:0]   _zz_execute_BranchPlugin_branch_src2_3;
  wire                _zz_execute_BranchPlugin_branch_src2_4;
  reg        [18:0]   _zz_execute_BranchPlugin_branch_src2_5;
  wire       [31:0]   execute_BranchPlugin_branchAdder;
  wire                when_Pipeline_l124;
  reg        [31:0]   decode_to_execute_PC;
  wire                when_Pipeline_l124_1;
  reg        [31:0]   execute_to_memory_PC;
  wire                when_Pipeline_l124_2;
  reg        [31:0]   memory_to_writeBack_PC;
  wire                when_Pipeline_l124_3;
  reg        [31:0]   decode_to_execute_INSTRUCTION;
  wire                when_Pipeline_l124_4;
  reg        [31:0]   execute_to_memory_INSTRUCTION;
  wire                when_Pipeline_l124_5;
  reg        [31:0]   memory_to_writeBack_INSTRUCTION;
  wire                when_Pipeline_l124_6;
  reg        [31:0]   decode_to_execute_FORMAL_PC_NEXT;
  wire                when_Pipeline_l124_7;
  reg        [31:0]   execute_to_memory_FORMAL_PC_NEXT;
  wire                when_Pipeline_l124_8;
  reg        [31:0]   memory_to_writeBack_FORMAL_PC_NEXT;
  wire                when_Pipeline_l124_9;
  reg                 decode_to_execute_MEMORY_FORCE_CONSTISTENCY;
  wire                when_Pipeline_l124_10;
  reg        [1:0]    decode_to_execute_SRC1_CTRL;
  wire                when_Pipeline_l124_11;
  reg                 decode_to_execute_SRC_USE_SUB_LESS;
  wire                when_Pipeline_l124_12;
  reg                 decode_to_execute_MEMORY_ENABLE;
  wire                when_Pipeline_l124_13;
  reg                 execute_to_memory_MEMORY_ENABLE;
  wire                when_Pipeline_l124_14;
  reg                 memory_to_writeBack_MEMORY_ENABLE;
  wire                when_Pipeline_l124_15;
  reg        [1:0]    decode_to_execute_ALU_CTRL;
  wire                when_Pipeline_l124_16;
  reg        [1:0]    decode_to_execute_SRC2_CTRL;
  wire                when_Pipeline_l124_17;
  reg                 decode_to_execute_REGFILE_WRITE_VALID;
  wire                when_Pipeline_l124_18;
  reg                 execute_to_memory_REGFILE_WRITE_VALID;
  wire                when_Pipeline_l124_19;
  reg                 memory_to_writeBack_REGFILE_WRITE_VALID;
  wire                when_Pipeline_l124_20;
  reg                 decode_to_execute_BYPASSABLE_EXECUTE_STAGE;
  wire                when_Pipeline_l124_21;
  reg                 decode_to_execute_BYPASSABLE_MEMORY_STAGE;
  wire                when_Pipeline_l124_22;
  reg                 execute_to_memory_BYPASSABLE_MEMORY_STAGE;
  wire                when_Pipeline_l124_23;
  reg                 decode_to_execute_MEMORY_WR;
  wire                when_Pipeline_l124_24;
  reg                 decode_to_execute_MEMORY_MANAGMENT;
  wire                when_Pipeline_l124_25;
  reg        [0:0]    decode_to_execute_SRC3_CTRL;
  wire                when_Pipeline_l124_26;
  reg                 decode_to_execute_SRC_LESS_UNSIGNED;
  wire                when_Pipeline_l124_27;
  reg        [1:0]    decode_to_execute_ALU_BITWISE_CTRL;
  wire                when_Pipeline_l124_28;
  reg        [1:0]    decode_to_execute_SHIFT_CTRL;
  wire                when_Pipeline_l124_29;
  reg        [1:0]    execute_to_memory_SHIFT_CTRL;
  wire                when_Pipeline_l124_30;
  reg                 decode_to_execute_IS_CG6;
  wire                when_Pipeline_l124_31;
  reg                 execute_to_memory_IS_CG6;
  wire                when_Pipeline_l124_32;
  reg        [2:0]    decode_to_execute_CG6Ctrl;
  wire                when_Pipeline_l124_33;
  reg        [0:0]    decode_to_execute_CG6Ctrlminmax;
  wire                when_Pipeline_l124_34;
  reg        [0:0]    decode_to_execute_CG6Ctrlsignextend;
  wire                when_Pipeline_l124_35;
  reg        [1:0]    decode_to_execute_CG6Ctrlternary;
  wire                when_Pipeline_l124_36;
  reg        [1:0]    decode_to_execute_BRANCH_CTRL;
  wire                when_Pipeline_l124_37;
  reg                 decode_to_execute_REGFILE_WRITE_VALID_ODD;
  wire                when_Pipeline_l124_38;
  reg                 execute_to_memory_REGFILE_WRITE_VALID_ODD;
  wire                when_Pipeline_l124_39;
  reg                 memory_to_writeBack_REGFILE_WRITE_VALID_ODD;
  wire                when_Pipeline_l124_40;
  reg        [31:0]   decode_to_execute_RS1;
  wire                when_Pipeline_l124_41;
  reg        [31:0]   decode_to_execute_RS2;
  wire                when_Pipeline_l124_42;
  reg        [31:0]   decode_to_execute_RS3;
  wire                when_Pipeline_l124_43;
  reg                 decode_to_execute_SRC2_FORCE_ZERO;
  wire                when_Pipeline_l124_44;
  reg                 decode_to_execute_PREDICTION_HAD_BRANCHED2;
  wire                when_Pipeline_l124_45;
  reg        [31:0]   execute_to_memory_MEMORY_STORE_DATA_RF;
  wire                when_Pipeline_l124_46;
  reg        [31:0]   memory_to_writeBack_MEMORY_STORE_DATA_RF;
  wire                when_Pipeline_l124_47;
  reg        [31:0]   execute_to_memory_REGFILE_WRITE_DATA;
  wire                when_Pipeline_l124_48;
  reg        [31:0]   memory_to_writeBack_REGFILE_WRITE_DATA;
  wire                when_Pipeline_l124_49;
  reg        [31:0]   execute_to_memory_REGFILE_WRITE_DATA_ODD;
  wire                when_Pipeline_l124_50;
  reg        [31:0]   memory_to_writeBack_REGFILE_WRITE_DATA_ODD;
  wire                when_Pipeline_l124_51;
  reg        [31:0]   execute_to_memory_SHIFT_RIGHT;
  wire                when_Pipeline_l124_52;
  reg        [31:0]   execute_to_memory_CG6_FINAL_OUTPUT;
  wire                when_Pipeline_l124_53;
  reg                 execute_to_memory_BRANCH_DO;
  wire                when_Pipeline_l124_54;
  reg        [31:0]   execute_to_memory_BRANCH_CALC;
  wire                when_Pipeline_l151;
  wire                when_Pipeline_l154;
  wire                when_Pipeline_l151_1;
  wire                when_Pipeline_l154_1;
  wire                when_Pipeline_l151_2;
  wire                when_Pipeline_l154_2;
  reg        [2:0]    _zz_iBusWishbone_ADR;
  wire                when_InstructionCache_l239;
  reg                 _zz_iBus_rsp_valid;
  reg        [31:0]   iBusWishbone_DAT_MISO_regNext;
  reg        [0:0]    _zz_dBus_cmd_ready;
  wire                _zz_dBus_cmd_ready_1;
  wire                _zz_dBus_cmd_ready_2;
  wire                _zz_dBus_cmd_ready_3;
  wire                _zz_dBus_cmd_ready_4;
  wire                _zz_dBus_cmd_ready_5;
  reg                 _zz_dBus_rsp_valid;
  reg        [127:0]  dBusWishbone_DAT_MISO_regNext;
  `ifndef SYNTHESIS
  reg [31:0] _zz_decode_to_execute_BRANCH_CTRL_string;
  reg [31:0] _zz_decode_to_execute_BRANCH_CTRL_1_string;
  reg [71:0] decode_CG6Ctrlternary_string;
  reg [71:0] _zz_decode_CG6Ctrlternary_string;
  reg [71:0] _zz_decode_to_execute_CG6Ctrlternary_string;
  reg [71:0] _zz_decode_to_execute_CG6Ctrlternary_1_string;
  reg [103:0] decode_CG6Ctrlsignextend_string;
  reg [103:0] _zz_decode_CG6Ctrlsignextend_string;
  reg [103:0] _zz_decode_to_execute_CG6Ctrlsignextend_string;
  reg [103:0] _zz_decode_to_execute_CG6Ctrlsignextend_1_string;
  reg [71:0] decode_CG6Ctrlminmax_string;
  reg [71:0] _zz_decode_CG6Ctrlminmax_string;
  reg [71:0] _zz_decode_to_execute_CG6Ctrlminmax_string;
  reg [71:0] _zz_decode_to_execute_CG6Ctrlminmax_1_string;
  reg [119:0] decode_CG6Ctrl_string;
  reg [119:0] _zz_decode_CG6Ctrl_string;
  reg [119:0] _zz_decode_to_execute_CG6Ctrl_string;
  reg [119:0] _zz_decode_to_execute_CG6Ctrl_1_string;
  reg [71:0] _zz_execute_to_memory_SHIFT_CTRL_string;
  reg [71:0] _zz_execute_to_memory_SHIFT_CTRL_1_string;
  reg [71:0] decode_SHIFT_CTRL_string;
  reg [71:0] _zz_decode_SHIFT_CTRL_string;
  reg [71:0] _zz_decode_to_execute_SHIFT_CTRL_string;
  reg [71:0] _zz_decode_to_execute_SHIFT_CTRL_1_string;
  reg [39:0] decode_ALU_BITWISE_CTRL_string;
  reg [39:0] _zz_decode_ALU_BITWISE_CTRL_string;
  reg [39:0] _zz_decode_to_execute_ALU_BITWISE_CTRL_string;
  reg [39:0] _zz_decode_to_execute_ALU_BITWISE_CTRL_1_string;
  reg [23:0] decode_SRC3_CTRL_string;
  reg [23:0] _zz_decode_SRC3_CTRL_string;
  reg [23:0] _zz_decode_to_execute_SRC3_CTRL_string;
  reg [23:0] _zz_decode_to_execute_SRC3_CTRL_1_string;
  reg [23:0] decode_SRC2_CTRL_string;
  reg [23:0] _zz_decode_SRC2_CTRL_string;
  reg [23:0] _zz_decode_to_execute_SRC2_CTRL_string;
  reg [23:0] _zz_decode_to_execute_SRC2_CTRL_1_string;
  reg [63:0] decode_ALU_CTRL_string;
  reg [63:0] _zz_decode_ALU_CTRL_string;
  reg [63:0] _zz_decode_to_execute_ALU_CTRL_string;
  reg [63:0] _zz_decode_to_execute_ALU_CTRL_1_string;
  reg [95:0] decode_SRC1_CTRL_string;
  reg [95:0] _zz_decode_SRC1_CTRL_string;
  reg [95:0] _zz_decode_to_execute_SRC1_CTRL_string;
  reg [95:0] _zz_decode_to_execute_SRC1_CTRL_1_string;
  reg [31:0] execute_BRANCH_CTRL_string;
  reg [31:0] _zz_execute_BRANCH_CTRL_string;
  reg [119:0] execute_CG6Ctrl_string;
  reg [119:0] _zz_execute_CG6Ctrl_string;
  reg [71:0] execute_CG6Ctrlternary_string;
  reg [71:0] _zz_execute_CG6Ctrlternary_string;
  reg [103:0] execute_CG6Ctrlsignextend_string;
  reg [103:0] _zz_execute_CG6Ctrlsignextend_string;
  reg [71:0] execute_CG6Ctrlminmax_string;
  reg [71:0] _zz_execute_CG6Ctrlminmax_string;
  reg [71:0] memory_SHIFT_CTRL_string;
  reg [71:0] _zz_memory_SHIFT_CTRL_string;
  reg [71:0] execute_SHIFT_CTRL_string;
  reg [71:0] _zz_execute_SHIFT_CTRL_string;
  reg [23:0] execute_SRC3_CTRL_string;
  reg [23:0] _zz_execute_SRC3_CTRL_string;
  reg [23:0] execute_SRC2_CTRL_string;
  reg [23:0] _zz_execute_SRC2_CTRL_string;
  reg [95:0] execute_SRC1_CTRL_string;
  reg [95:0] _zz_execute_SRC1_CTRL_string;
  reg [63:0] execute_ALU_CTRL_string;
  reg [63:0] _zz_execute_ALU_CTRL_string;
  reg [39:0] execute_ALU_BITWISE_CTRL_string;
  reg [39:0] _zz_execute_ALU_BITWISE_CTRL_string;
  reg [31:0] _zz_decode_BRANCH_CTRL_string;
  reg [71:0] _zz_decode_CG6Ctrlternary_1_string;
  reg [103:0] _zz_decode_CG6Ctrlsignextend_1_string;
  reg [71:0] _zz_decode_CG6Ctrlminmax_1_string;
  reg [119:0] _zz_decode_CG6Ctrl_1_string;
  reg [71:0] _zz_decode_SHIFT_CTRL_1_string;
  reg [39:0] _zz_decode_ALU_BITWISE_CTRL_1_string;
  reg [23:0] _zz_decode_SRC3_CTRL_1_string;
  reg [23:0] _zz_decode_SRC2_CTRL_1_string;
  reg [63:0] _zz_decode_ALU_CTRL_1_string;
  reg [95:0] _zz_decode_SRC1_CTRL_1_string;
  reg [31:0] decode_BRANCH_CTRL_string;
  reg [31:0] _zz_decode_BRANCH_CTRL_1_string;
  reg [95:0] _zz_decode_SRC1_CTRL_2_string;
  reg [63:0] _zz_decode_ALU_CTRL_2_string;
  reg [23:0] _zz_decode_SRC2_CTRL_2_string;
  reg [23:0] _zz_decode_SRC3_CTRL_2_string;
  reg [39:0] _zz_decode_ALU_BITWISE_CTRL_2_string;
  reg [71:0] _zz_decode_SHIFT_CTRL_2_string;
  reg [119:0] _zz_decode_CG6Ctrl_2_string;
  reg [71:0] _zz_decode_CG6Ctrlminmax_2_string;
  reg [103:0] _zz_decode_CG6Ctrlsignextend_2_string;
  reg [71:0] _zz_decode_CG6Ctrlternary_2_string;
  reg [31:0] _zz_decode_BRANCH_CTRL_2_string;
  reg [95:0] decode_to_execute_SRC1_CTRL_string;
  reg [63:0] decode_to_execute_ALU_CTRL_string;
  reg [23:0] decode_to_execute_SRC2_CTRL_string;
  reg [23:0] decode_to_execute_SRC3_CTRL_string;
  reg [39:0] decode_to_execute_ALU_BITWISE_CTRL_string;
  reg [71:0] decode_to_execute_SHIFT_CTRL_string;
  reg [71:0] execute_to_memory_SHIFT_CTRL_string;
  reg [119:0] decode_to_execute_CG6Ctrl_string;
  reg [71:0] decode_to_execute_CG6Ctrlminmax_string;
  reg [103:0] decode_to_execute_CG6Ctrlsignextend_string;
  reg [71:0] decode_to_execute_CG6Ctrlternary_string;
  reg [31:0] decode_to_execute_BRANCH_CTRL_string;
  `endif

  reg [31:0] RegFilePlugin_regFile [0:31] /* verilator public */ ;

  assign _zz_execute_SHIFT_RIGHT_1 = ($signed(_zz_execute_SHIFT_RIGHT_2) >>> execute_FullBarrelShifterPlugin_amplitude);
  assign _zz_execute_SHIFT_RIGHT = _zz_execute_SHIFT_RIGHT_1[31 : 0];
  assign _zz_execute_SHIFT_RIGHT_2 = {((execute_SHIFT_CTRL == ShiftCtrlEnum_SRA_1) && execute_FullBarrelShifterPlugin_reversed[31]),execute_FullBarrelShifterPlugin_reversed};
  assign _zz__zz_IBusCachedPlugin_jump_pcLoad_payload_1 = (_zz_IBusCachedPlugin_jump_pcLoad_payload - 3'b001);
  assign _zz_IBusCachedPlugin_fetchPc_pc_1 = {IBusCachedPlugin_fetchPc_inc,2'b00};
  assign _zz_IBusCachedPlugin_fetchPc_pc = {29'd0, _zz_IBusCachedPlugin_fetchPc_pc_1};
  assign _zz__zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch_2 = {{_zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch_1,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz__zz_2 = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]};
  assign _zz__zz_4 = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz__zz_6 = {{_zz_3,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]}},1'b0};
  assign _zz__zz_6_1 = {{_zz_5,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz__zz_IBusCachedPlugin_predictionJumpInterface_payload = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]};
  assign _zz__zz_IBusCachedPlugin_predictionJumpInterface_payload_2 = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz__zz_execute_REGFILE_WRITE_DATA = execute_SRC_LESS;
  assign _zz__zz_execute_SRC1 = 3'b100;
  assign _zz__zz_execute_SRC1_1 = execute_INSTRUCTION[19 : 15];
  assign _zz__zz_execute_SRC2_3 = {execute_INSTRUCTION[31 : 25],execute_INSTRUCTION[11 : 7]};
  assign _zz_execute_SrcPlugin_addSub = ($signed(_zz_execute_SrcPlugin_addSub_1) + $signed(_zz_execute_SrcPlugin_addSub_4));
  assign _zz_execute_SrcPlugin_addSub_1 = ($signed(_zz_execute_SrcPlugin_addSub_2) + $signed(_zz_execute_SrcPlugin_addSub_3));
  assign _zz_execute_SrcPlugin_addSub_2 = execute_SRC1;
  assign _zz_execute_SrcPlugin_addSub_3 = (execute_SRC_USE_SUB_LESS ? (~ execute_SRC2) : execute_SRC2);
  assign _zz_execute_SrcPlugin_addSub_4 = (execute_SRC_USE_SUB_LESS ? _zz_execute_SrcPlugin_addSub_5 : _zz_execute_SrcPlugin_addSub_6);
  assign _zz_execute_SrcPlugin_addSub_5 = 32'h00000001;
  assign _zz_execute_SrcPlugin_addSub_6 = 32'h0;
  assign _zz__zz_execute_CG6Plugin_val_ternary_1 = (_zz_execute_CG6Plugin_val_ternary - 32'h00000020);
  assign _zz_execute_CG6Plugin_val_ternary_3 = (_zz_execute_CG6Plugin_val_ternary_2 >>> _zz_execute_CG6Plugin_val_ternary_1);
  assign _zz_execute_CG6Plugin_val_ternary_4 = (((_zz_execute_CG6Plugin_val_ternary_1 == _zz_execute_CG6Plugin_val_ternary) ? execute_SRC3 : execute_SRC1) <<< _zz_execute_CG6Plugin_val_ternary_5);
  assign _zz_execute_CG6Plugin_val_ternary_5 = (32'h00000020 - _zz_execute_CG6Plugin_val_ternary_1);
  assign _zz__zz_execute_CG6_FINAL_OUTPUT = (_zz__zz_execute_CG6_FINAL_OUTPUT_1 + execute_SRC2);
  assign _zz__zz_execute_CG6_FINAL_OUTPUT_1 = (execute_SRC1 <<< 2);
  assign _zz__zz_execute_BranchPlugin_missAlignedTarget_2 = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]};
  assign _zz__zz_execute_BranchPlugin_missAlignedTarget_4 = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]};
  assign _zz__zz_execute_BranchPlugin_missAlignedTarget_6 = {_zz_execute_BranchPlugin_missAlignedTarget_1,execute_INSTRUCTION[31 : 20]};
  assign _zz__zz_execute_BranchPlugin_missAlignedTarget_6_1 = {{_zz_execute_BranchPlugin_missAlignedTarget_3,{{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]}},1'b0};
  assign _zz__zz_execute_BranchPlugin_missAlignedTarget_6_2 = {{_zz_execute_BranchPlugin_missAlignedTarget_5,{{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz__zz_execute_BranchPlugin_branch_src2_2 = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]};
  assign _zz__zz_execute_BranchPlugin_branch_src2_4 = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]};
  assign _zz_execute_BranchPlugin_branch_src2_9 = 3'b100;
  assign _zz_iBusWishbone_ADR_1 = (iBus_cmd_payload_address >>> 5);
  assign _zz_decode_RegFilePlugin_rs1Data = 1'b1;
  assign _zz_decode_RegFilePlugin_rs2Data = 1'b1;
  assign _zz_decode_RegFilePlugin_rs3Data = 1'b1;
  assign _zz_IBusCachedPlugin_jump_pcLoad_payload_5 = {_zz_IBusCachedPlugin_jump_pcLoad_payload_3,_zz_IBusCachedPlugin_jump_pcLoad_payload_2};
  assign _zz_writeBack_DBusCachedPlugin_rspShifted_1 = dataCache_1_io_cpu_writeBack_address[3 : 0];
  assign _zz_writeBack_DBusCachedPlugin_rspShifted_3 = dataCache_1_io_cpu_writeBack_address[3 : 1];
  assign _zz_writeBack_DBusCachedPlugin_rspShifted_5 = dataCache_1_io_cpu_writeBack_address[3 : 2];
  assign _zz_writeBack_DBusCachedPlugin_rspShifted_7 = dataCache_1_io_cpu_writeBack_address[3 : 2];
  assign _zz_writeBack_DBusCachedPlugin_rspShifted_9 = dataCache_1_io_cpu_writeBack_address[3 : 3];
  assign _zz_writeBack_DBusCachedPlugin_rspShifted_11 = dataCache_1_io_cpu_writeBack_address[3 : 3];
  assign _zz_writeBack_DBusCachedPlugin_rspShifted_13 = dataCache_1_io_cpu_writeBack_address[3 : 3];
  assign _zz_writeBack_DBusCachedPlugin_rspShifted_15 = dataCache_1_io_cpu_writeBack_address[3 : 3];
  assign _zz_IBusCachedPlugin_predictionJumpInterface_payload_4 = decode_INSTRUCTION[31];
  assign _zz_IBusCachedPlugin_predictionJumpInterface_payload_5 = decode_INSTRUCTION[31];
  assign _zz_IBusCachedPlugin_predictionJumpInterface_payload_6 = decode_INSTRUCTION[7];
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD = (decode_INSTRUCTION & 32'h0000001c);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_1 = 32'h00000004;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_2 = (decode_INSTRUCTION & 32'h00000048);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_3 = 32'h00000040;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_4 = ((decode_INSTRUCTION & 32'h02000000) == 32'h0);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_5 = ((decode_INSTRUCTION & 32'h02004000) == 32'h02004000);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_6 = (|_zz_decode_REGFILE_WRITE_VALID_ODD_7);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_7 = (|((decode_INSTRUCTION & _zz__zz_decode_REGFILE_WRITE_VALID_ODD_8) == 32'h0));
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_9 = {(|(_zz__zz_decode_REGFILE_WRITE_VALID_ODD_10 == _zz__zz_decode_REGFILE_WRITE_VALID_ODD_11)),{(|_zz__zz_decode_REGFILE_WRITE_VALID_ODD_12),{(|_zz__zz_decode_REGFILE_WRITE_VALID_ODD_13),{_zz__zz_decode_REGFILE_WRITE_VALID_ODD_18,{_zz__zz_decode_REGFILE_WRITE_VALID_ODD_21,_zz__zz_decode_REGFILE_WRITE_VALID_ODD_29}}}}};
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_8 = 32'h40000000;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_10 = (decode_INSTRUCTION & 32'h00002000);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_11 = 32'h0;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_12 = ((decode_INSTRUCTION & 32'h00400020) == 32'h0);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_13 = {_zz_decode_REGFILE_WRITE_VALID_ODD_8,{(_zz__zz_decode_REGFILE_WRITE_VALID_ODD_14 == _zz__zz_decode_REGFILE_WRITE_VALID_ODD_15),(_zz__zz_decode_REGFILE_WRITE_VALID_ODD_16 == _zz__zz_decode_REGFILE_WRITE_VALID_ODD_17)}};
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_18 = (|{(_zz__zz_decode_REGFILE_WRITE_VALID_ODD_19 == _zz__zz_decode_REGFILE_WRITE_VALID_ODD_20),_zz_decode_REGFILE_WRITE_VALID_ODD_8});
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_21 = (|{_zz__zz_decode_REGFILE_WRITE_VALID_ODD_22,{_zz__zz_decode_REGFILE_WRITE_VALID_ODD_23,_zz__zz_decode_REGFILE_WRITE_VALID_ODD_24}});
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_29 = {(|_zz__zz_decode_REGFILE_WRITE_VALID_ODD_30),{(|_zz__zz_decode_REGFILE_WRITE_VALID_ODD_31),{_zz__zz_decode_REGFILE_WRITE_VALID_ODD_36,{_zz__zz_decode_REGFILE_WRITE_VALID_ODD_39,_zz__zz_decode_REGFILE_WRITE_VALID_ODD_41}}}};
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_14 = (decode_INSTRUCTION & 32'h00004000);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_15 = 32'h0;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_16 = (decode_INSTRUCTION & 32'h22000000);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_17 = 32'h0;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_19 = (decode_INSTRUCTION & 32'h02000000);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_20 = 32'h02000000;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_22 = ((decode_INSTRUCTION & 32'h08004064) == 32'h08004020);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_23 = _zz_decode_REGFILE_WRITE_VALID_ODD_7;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_24 = {(_zz__zz_decode_REGFILE_WRITE_VALID_ODD_25 == _zz__zz_decode_REGFILE_WRITE_VALID_ODD_26),(_zz__zz_decode_REGFILE_WRITE_VALID_ODD_27 == _zz__zz_decode_REGFILE_WRITE_VALID_ODD_28)};
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_30 = ((decode_INSTRUCTION & 32'h0c007014) == 32'h00005010);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_31 = {(_zz__zz_decode_REGFILE_WRITE_VALID_ODD_32 == _zz__zz_decode_REGFILE_WRITE_VALID_ODD_33),(_zz__zz_decode_REGFILE_WRITE_VALID_ODD_34 == _zz__zz_decode_REGFILE_WRITE_VALID_ODD_35)};
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_36 = (|(_zz__zz_decode_REGFILE_WRITE_VALID_ODD_37 == _zz__zz_decode_REGFILE_WRITE_VALID_ODD_38));
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_39 = (|_zz__zz_decode_REGFILE_WRITE_VALID_ODD_40);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_41 = {(|_zz__zz_decode_REGFILE_WRITE_VALID_ODD_42),{_zz__zz_decode_REGFILE_WRITE_VALID_ODD_43,{_zz__zz_decode_REGFILE_WRITE_VALID_ODD_48,_zz__zz_decode_REGFILE_WRITE_VALID_ODD_49}}};
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_25 = (decode_INSTRUCTION & 32'h20003014);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_26 = 32'h20001010;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_27 = (decode_INSTRUCTION & 32'h20004064);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_28 = 32'h20004020;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_32 = (decode_INSTRUCTION & 32'h64003014);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_33 = 32'h40001010;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_34 = (decode_INSTRUCTION & 32'h44007014);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_35 = 32'h00001010;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_37 = (decode_INSTRUCTION & 32'h00000064);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_38 = 32'h00000024;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_40 = ((decode_INSTRUCTION & 32'h00001000) == 32'h00001000);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_42 = ((decode_INSTRUCTION & 32'h00003000) == 32'h00002000);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_43 = (|{(_zz__zz_decode_REGFILE_WRITE_VALID_ODD_44 == _zz__zz_decode_REGFILE_WRITE_VALID_ODD_45),(_zz__zz_decode_REGFILE_WRITE_VALID_ODD_46 == _zz__zz_decode_REGFILE_WRITE_VALID_ODD_47)});
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_48 = 1'b0;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_49 = {(|_zz__zz_decode_REGFILE_WRITE_VALID_ODD_50),{(|_zz__zz_decode_REGFILE_WRITE_VALID_ODD_51),{_zz__zz_decode_REGFILE_WRITE_VALID_ODD_58,{_zz__zz_decode_REGFILE_WRITE_VALID_ODD_61,_zz__zz_decode_REGFILE_WRITE_VALID_ODD_64}}}};
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_44 = (decode_INSTRUCTION & 32'h00002010);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_45 = 32'h00002000;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_46 = (decode_INSTRUCTION & 32'h00005000);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_47 = 32'h00001000;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_50 = ((decode_INSTRUCTION & 32'h00004048) == 32'h00004008);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_51 = {_zz_decode_REGFILE_WRITE_VALID_ODD_1,{(_zz__zz_decode_REGFILE_WRITE_VALID_ODD_52 == _zz__zz_decode_REGFILE_WRITE_VALID_ODD_53),{_zz__zz_decode_REGFILE_WRITE_VALID_ODD_54,{_zz__zz_decode_REGFILE_WRITE_VALID_ODD_55,_zz__zz_decode_REGFILE_WRITE_VALID_ODD_57}}}};
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_58 = (|{(_zz__zz_decode_REGFILE_WRITE_VALID_ODD_59 == _zz__zz_decode_REGFILE_WRITE_VALID_ODD_60),_zz_decode_REGFILE_WRITE_VALID_ODD_2});
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_61 = (|(_zz__zz_decode_REGFILE_WRITE_VALID_ODD_62 == _zz__zz_decode_REGFILE_WRITE_VALID_ODD_63));
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_64 = {(|_zz_decode_REGFILE_WRITE_VALID_ODD_6),{(|_zz__zz_decode_REGFILE_WRITE_VALID_ODD_65),{_zz__zz_decode_REGFILE_WRITE_VALID_ODD_74,{_zz__zz_decode_REGFILE_WRITE_VALID_ODD_81,_zz__zz_decode_REGFILE_WRITE_VALID_ODD_84}}}};
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_52 = (decode_INSTRUCTION & 32'h04000024);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_53 = 32'h04000020;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_54 = ((decode_INSTRUCTION & 32'h02000024) == 32'h02000020);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_55 = ((decode_INSTRUCTION & _zz__zz_decode_REGFILE_WRITE_VALID_ODD_56) == 32'h00000020);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_57 = _zz_decode_REGFILE_WRITE_VALID_ODD_4;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_59 = (decode_INSTRUCTION & 32'h00000040);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_60 = 32'h00000040;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_62 = (decode_INSTRUCTION & 32'h00000020);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_63 = 32'h00000020;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_65 = {_zz_decode_REGFILE_WRITE_VALID_ODD_3,{_zz__zz_decode_REGFILE_WRITE_VALID_ODD_66,{_zz__zz_decode_REGFILE_WRITE_VALID_ODD_67,_zz__zz_decode_REGFILE_WRITE_VALID_ODD_69}}};
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_74 = (|{_zz_decode_REGFILE_WRITE_VALID_ODD_6,{_zz__zz_decode_REGFILE_WRITE_VALID_ODD_75,_zz__zz_decode_REGFILE_WRITE_VALID_ODD_76}});
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_81 = (|{_zz__zz_decode_REGFILE_WRITE_VALID_ODD_82,_zz__zz_decode_REGFILE_WRITE_VALID_ODD_83});
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_84 = {(|_zz__zz_decode_REGFILE_WRITE_VALID_ODD_85),{_zz__zz_decode_REGFILE_WRITE_VALID_ODD_88,{_zz__zz_decode_REGFILE_WRITE_VALID_ODD_91,_zz__zz_decode_REGFILE_WRITE_VALID_ODD_93}}};
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_56 = 32'h08000024;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_66 = ((decode_INSTRUCTION & 32'h00002030) == 32'h00002010);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_67 = ((decode_INSTRUCTION & _zz__zz_decode_REGFILE_WRITE_VALID_ODD_68) == 32'h00002020);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_69 = {(_zz__zz_decode_REGFILE_WRITE_VALID_ODD_70 == _zz__zz_decode_REGFILE_WRITE_VALID_ODD_71),(_zz__zz_decode_REGFILE_WRITE_VALID_ODD_72 == _zz__zz_decode_REGFILE_WRITE_VALID_ODD_73)};
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_75 = _zz_decode_REGFILE_WRITE_VALID_ODD_5;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_76 = {(_zz__zz_decode_REGFILE_WRITE_VALID_ODD_77 == _zz__zz_decode_REGFILE_WRITE_VALID_ODD_78),(_zz__zz_decode_REGFILE_WRITE_VALID_ODD_79 == _zz__zz_decode_REGFILE_WRITE_VALID_ODD_80)};
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_82 = _zz_decode_REGFILE_WRITE_VALID_ODD_3;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_83 = _zz_decode_REGFILE_WRITE_VALID_ODD_4;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_85 = {_zz_decode_REGFILE_WRITE_VALID_ODD_3,(_zz__zz_decode_REGFILE_WRITE_VALID_ODD_86 == _zz__zz_decode_REGFILE_WRITE_VALID_ODD_87)};
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_88 = (|(_zz__zz_decode_REGFILE_WRITE_VALID_ODD_89 == _zz__zz_decode_REGFILE_WRITE_VALID_ODD_90));
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_91 = (|_zz__zz_decode_REGFILE_WRITE_VALID_ODD_92);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_93 = {(|_zz__zz_decode_REGFILE_WRITE_VALID_ODD_94),{_zz__zz_decode_REGFILE_WRITE_VALID_ODD_96,{_zz__zz_decode_REGFILE_WRITE_VALID_ODD_98,_zz__zz_decode_REGFILE_WRITE_VALID_ODD_101}}};
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_68 = 32'h08002020;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_70 = (decode_INSTRUCTION & 32'h00001030);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_71 = 32'h00000010;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_72 = (decode_INSTRUCTION & 32'h28001020);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_73 = 32'h00000020;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_77 = (decode_INSTRUCTION & 32'h0000000c);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_78 = 32'h00000004;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_79 = (decode_INSTRUCTION & 32'h00000028);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_80 = 32'h0;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_86 = (decode_INSTRUCTION & 32'h00000020);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_87 = 32'h0;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_89 = (decode_INSTRUCTION & 32'h00004014);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_90 = 32'h00004010;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_92 = ((decode_INSTRUCTION & 32'h00006014) == 32'h00002010);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_94 = {((decode_INSTRUCTION & _zz__zz_decode_REGFILE_WRITE_VALID_ODD_95) == 32'h0),_zz_decode_REGFILE_WRITE_VALID_ODD_2};
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_96 = (|((decode_INSTRUCTION & _zz__zz_decode_REGFILE_WRITE_VALID_ODD_97) == 32'h0));
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_98 = (|{_zz_decode_REGFILE_WRITE_VALID_ODD_1,{_zz__zz_decode_REGFILE_WRITE_VALID_ODD_99,_zz__zz_decode_REGFILE_WRITE_VALID_ODD_100}});
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_101 = {(|_zz__zz_decode_REGFILE_WRITE_VALID_ODD_102),{(|_zz__zz_decode_REGFILE_WRITE_VALID_ODD_103),(|_zz__zz_decode_REGFILE_WRITE_VALID_ODD_104)}};
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_95 = 32'h00000004;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_97 = 32'h00000058;
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_99 = ((decode_INSTRUCTION & 32'h00002014) == 32'h00002010);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_100 = ((decode_INSTRUCTION & 32'h40000034) == 32'h40000030);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_102 = ((decode_INSTRUCTION & 32'h00000014) == 32'h00000004);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_103 = ((decode_INSTRUCTION & 32'h00000044) == 32'h00000004);
  assign _zz__zz_decode_REGFILE_WRITE_VALID_ODD_104 = ((decode_INSTRUCTION & 32'h00005048) == 32'h00001008);
  assign _zz_execute_BranchPlugin_branch_src2_6 = execute_INSTRUCTION[31];
  assign _zz_execute_BranchPlugin_branch_src2_7 = execute_INSTRUCTION[31];
  assign _zz_execute_BranchPlugin_branch_src2_8 = execute_INSTRUCTION[7];
  always @(posedge clk) begin
    if(_zz_decode_RegFilePlugin_rs1Data) begin
      _zz_RegFilePlugin_regFile_port0 <= RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress1];
    end
  end

  always @(posedge clk) begin
    if(_zz_decode_RegFilePlugin_rs2Data) begin
      _zz_RegFilePlugin_regFile_port1 <= RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress2];
    end
  end

  always @(posedge clk) begin
    if(_zz_decode_RegFilePlugin_rs3Data) begin
      _zz_RegFilePlugin_regFile_port2 <= RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress3];
    end
  end

  always @(posedge clk) begin
    if(_zz_1) begin
      RegFilePlugin_regFile[lastStageRegFileWrite_payload_address] <= lastStageRegFileWrite_payload_data;
    end
  end

  InstructionCache IBusCachedPlugin_cache (
    .io_flush                              (IBusCachedPlugin_cache_io_flush                           ), //i
    .io_cpu_prefetch_isValid               (IBusCachedPlugin_cache_io_cpu_prefetch_isValid            ), //i
    .io_cpu_prefetch_haltIt                (IBusCachedPlugin_cache_io_cpu_prefetch_haltIt             ), //o
    .io_cpu_prefetch_pc                    (IBusCachedPlugin_iBusRsp_stages_0_input_payload[31:0]     ), //i
    .io_cpu_fetch_isValid                  (IBusCachedPlugin_cache_io_cpu_fetch_isValid               ), //i
    .io_cpu_fetch_isStuck                  (IBusCachedPlugin_cache_io_cpu_fetch_isStuck               ), //i
    .io_cpu_fetch_isRemoved                (IBusCachedPlugin_cache_io_cpu_fetch_isRemoved             ), //i
    .io_cpu_fetch_pc                       (IBusCachedPlugin_iBusRsp_stages_1_input_payload[31:0]     ), //i
    .io_cpu_fetch_data                     (IBusCachedPlugin_cache_io_cpu_fetch_data[31:0]            ), //o
    .io_cpu_fetch_mmuRsp_physicalAddress   (IBusCachedPlugin_mmuBus_rsp_physicalAddress[31:0]         ), //i
    .io_cpu_fetch_mmuRsp_isIoAccess        (IBusCachedPlugin_mmuBus_rsp_isIoAccess                    ), //i
    .io_cpu_fetch_mmuRsp_isPaging          (IBusCachedPlugin_mmuBus_rsp_isPaging                      ), //i
    .io_cpu_fetch_mmuRsp_allowRead         (IBusCachedPlugin_mmuBus_rsp_allowRead                     ), //i
    .io_cpu_fetch_mmuRsp_allowWrite        (IBusCachedPlugin_mmuBus_rsp_allowWrite                    ), //i
    .io_cpu_fetch_mmuRsp_allowExecute      (IBusCachedPlugin_mmuBus_rsp_allowExecute                  ), //i
    .io_cpu_fetch_mmuRsp_exception         (IBusCachedPlugin_mmuBus_rsp_exception                     ), //i
    .io_cpu_fetch_mmuRsp_refilling         (IBusCachedPlugin_mmuBus_rsp_refilling                     ), //i
    .io_cpu_fetch_mmuRsp_bypassTranslation (IBusCachedPlugin_mmuBus_rsp_bypassTranslation             ), //i
    .io_cpu_fetch_physicalAddress          (IBusCachedPlugin_cache_io_cpu_fetch_physicalAddress[31:0] ), //o
    .io_cpu_decode_isValid                 (IBusCachedPlugin_cache_io_cpu_decode_isValid              ), //i
    .io_cpu_decode_isStuck                 (IBusCachedPlugin_cache_io_cpu_decode_isStuck              ), //i
    .io_cpu_decode_pc                      (IBusCachedPlugin_iBusRsp_stages_2_input_payload[31:0]     ), //i
    .io_cpu_decode_physicalAddress         (IBusCachedPlugin_cache_io_cpu_decode_physicalAddress[31:0]), //o
    .io_cpu_decode_data                    (IBusCachedPlugin_cache_io_cpu_decode_data[31:0]           ), //o
    .io_cpu_decode_cacheMiss               (IBusCachedPlugin_cache_io_cpu_decode_cacheMiss            ), //o
    .io_cpu_decode_error                   (IBusCachedPlugin_cache_io_cpu_decode_error                ), //o
    .io_cpu_decode_mmuRefilling            (IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling         ), //o
    .io_cpu_decode_mmuException            (IBusCachedPlugin_cache_io_cpu_decode_mmuException         ), //o
    .io_cpu_decode_isUser                  (1'b0                                                      ), //i
    .io_cpu_fill_valid                     (IBusCachedPlugin_cache_io_cpu_fill_valid                  ), //i
    .io_cpu_fill_payload                   (IBusCachedPlugin_cache_io_cpu_decode_physicalAddress[31:0]), //i
    .io_mem_cmd_valid                      (IBusCachedPlugin_cache_io_mem_cmd_valid                   ), //o
    .io_mem_cmd_ready                      (iBus_cmd_ready                                            ), //i
    .io_mem_cmd_payload_address            (IBusCachedPlugin_cache_io_mem_cmd_payload_address[31:0]   ), //o
    .io_mem_cmd_payload_size               (IBusCachedPlugin_cache_io_mem_cmd_payload_size[2:0]       ), //o
    .io_mem_rsp_valid                      (iBus_rsp_valid                                            ), //i
    .io_mem_rsp_payload_data               (iBus_rsp_payload_data[31:0]                               ), //i
    .io_mem_rsp_payload_error              (iBus_rsp_payload_error                                    ), //i
    .clk                                   (clk                                                       ), //i
    .reset                                 (reset                                                     )  //i
  );
  DataCache dataCache_1 (
    .io_cpu_execute_isValid                 (dataCache_1_io_cpu_execute_isValid               ), //i
    .io_cpu_execute_address                 (dataCache_1_io_cpu_execute_address[31:0]         ), //i
    .io_cpu_execute_haltIt                  (dataCache_1_io_cpu_execute_haltIt                ), //o
    .io_cpu_execute_args_wr                 (execute_MEMORY_WR                                ), //i
    .io_cpu_execute_args_size               (dataCache_1_io_cpu_execute_args_size[2:0]        ), //i
    .io_cpu_execute_args_totalyConsistent   (execute_MEMORY_FORCE_CONSTISTENCY                ), //i
    .io_cpu_execute_refilling               (dataCache_1_io_cpu_execute_refilling             ), //o
    .io_cpu_memory_isValid                  (dataCache_1_io_cpu_memory_isValid                ), //i
    .io_cpu_memory_isStuck                  (memory_arbitration_isStuck                       ), //i
    .io_cpu_memory_isWrite                  (dataCache_1_io_cpu_memory_isWrite                ), //o
    .io_cpu_memory_address                  (dataCache_1_io_cpu_memory_address[31:0]          ), //i
    .io_cpu_memory_mmuRsp_physicalAddress   (DBusCachedPlugin_mmuBus_rsp_physicalAddress[31:0]), //i
    .io_cpu_memory_mmuRsp_isIoAccess        (dataCache_1_io_cpu_memory_mmuRsp_isIoAccess      ), //i
    .io_cpu_memory_mmuRsp_isPaging          (DBusCachedPlugin_mmuBus_rsp_isPaging             ), //i
    .io_cpu_memory_mmuRsp_allowRead         (DBusCachedPlugin_mmuBus_rsp_allowRead            ), //i
    .io_cpu_memory_mmuRsp_allowWrite        (DBusCachedPlugin_mmuBus_rsp_allowWrite           ), //i
    .io_cpu_memory_mmuRsp_allowExecute      (DBusCachedPlugin_mmuBus_rsp_allowExecute         ), //i
    .io_cpu_memory_mmuRsp_exception         (DBusCachedPlugin_mmuBus_rsp_exception            ), //i
    .io_cpu_memory_mmuRsp_refilling         (DBusCachedPlugin_mmuBus_rsp_refilling            ), //i
    .io_cpu_memory_mmuRsp_bypassTranslation (DBusCachedPlugin_mmuBus_rsp_bypassTranslation    ), //i
    .io_cpu_writeBack_isValid               (dataCache_1_io_cpu_writeBack_isValid             ), //i
    .io_cpu_writeBack_isStuck               (writeBack_arbitration_isStuck                    ), //i
    .io_cpu_writeBack_isFiring              (writeBack_arbitration_isFiring                   ), //i
    .io_cpu_writeBack_isUser                (1'b0                                             ), //i
    .io_cpu_writeBack_haltIt                (dataCache_1_io_cpu_writeBack_haltIt              ), //o
    .io_cpu_writeBack_isWrite               (dataCache_1_io_cpu_writeBack_isWrite             ), //o
    .io_cpu_writeBack_storeData             (dataCache_1_io_cpu_writeBack_storeData[127:0]    ), //i
    .io_cpu_writeBack_data                  (dataCache_1_io_cpu_writeBack_data[127:0]         ), //o
    .io_cpu_writeBack_address               (dataCache_1_io_cpu_writeBack_address[31:0]       ), //i
    .io_cpu_writeBack_mmuException          (dataCache_1_io_cpu_writeBack_mmuException        ), //o
    .io_cpu_writeBack_unalignedAccess       (dataCache_1_io_cpu_writeBack_unalignedAccess     ), //o
    .io_cpu_writeBack_accessError           (dataCache_1_io_cpu_writeBack_accessError         ), //o
    .io_cpu_writeBack_keepMemRspData        (dataCache_1_io_cpu_writeBack_keepMemRspData      ), //o
    .io_cpu_writeBack_fence_SW              (dataCache_1_io_cpu_writeBack_fence_SW            ), //i
    .io_cpu_writeBack_fence_SR              (dataCache_1_io_cpu_writeBack_fence_SR            ), //i
    .io_cpu_writeBack_fence_SO              (dataCache_1_io_cpu_writeBack_fence_SO            ), //i
    .io_cpu_writeBack_fence_SI              (dataCache_1_io_cpu_writeBack_fence_SI            ), //i
    .io_cpu_writeBack_fence_PW              (dataCache_1_io_cpu_writeBack_fence_PW            ), //i
    .io_cpu_writeBack_fence_PR              (dataCache_1_io_cpu_writeBack_fence_PR            ), //i
    .io_cpu_writeBack_fence_PO              (dataCache_1_io_cpu_writeBack_fence_PO            ), //i
    .io_cpu_writeBack_fence_PI              (dataCache_1_io_cpu_writeBack_fence_PI            ), //i
    .io_cpu_writeBack_fence_FM              (dataCache_1_io_cpu_writeBack_fence_FM[3:0]       ), //i
    .io_cpu_writeBack_exclusiveOk           (dataCache_1_io_cpu_writeBack_exclusiveOk         ), //o
    .io_cpu_redo                            (dataCache_1_io_cpu_redo                          ), //o
    .io_cpu_flush_valid                     (dataCache_1_io_cpu_flush_valid                   ), //i
    .io_cpu_flush_ready                     (dataCache_1_io_cpu_flush_ready                   ), //o
    .io_mem_cmd_valid                       (dataCache_1_io_mem_cmd_valid                     ), //o
    .io_mem_cmd_ready                       (dataCache_1_io_mem_cmd_ready                     ), //i
    .io_mem_cmd_payload_wr                  (dataCache_1_io_mem_cmd_payload_wr                ), //o
    .io_mem_cmd_payload_uncached            (dataCache_1_io_mem_cmd_payload_uncached          ), //o
    .io_mem_cmd_payload_address             (dataCache_1_io_mem_cmd_payload_address[31:0]     ), //o
    .io_mem_cmd_payload_data                (dataCache_1_io_mem_cmd_payload_data[127:0]       ), //o
    .io_mem_cmd_payload_mask                (dataCache_1_io_mem_cmd_payload_mask[15:0]        ), //o
    .io_mem_cmd_payload_size                (dataCache_1_io_mem_cmd_payload_size[2:0]         ), //o
    .io_mem_cmd_payload_last                (dataCache_1_io_mem_cmd_payload_last              ), //o
    .io_mem_rsp_valid                       (dBus_rsp_regNext_valid                           ), //i
    .io_mem_rsp_payload_aggregated          (dBus_rsp_regNext_payload_aggregated[4:0]         ), //i
    .io_mem_rsp_payload_last                (dBus_rsp_regNext_payload_last                    ), //i
    .io_mem_rsp_payload_data                (dBus_rsp_regNext_payload_data[127:0]             ), //i
    .io_mem_rsp_payload_error               (dBus_rsp_regNext_payload_error                   ), //i
    .clk                                    (clk                                              ), //i
    .reset                                  (reset                                            )  //i
  );
  always @(*) begin
    case(_zz_IBusCachedPlugin_jump_pcLoad_payload_5)
      2'b00 : _zz_IBusCachedPlugin_jump_pcLoad_payload_4 = DBusCachedPlugin_redoBranch_payload;
      2'b01 : _zz_IBusCachedPlugin_jump_pcLoad_payload_4 = BranchPlugin_jumpInterface_payload;
      default : _zz_IBusCachedPlugin_jump_pcLoad_payload_4 = IBusCachedPlugin_predictionJumpInterface_payload;
    endcase
  end

  always @(*) begin
    case(_zz_writeBack_DBusCachedPlugin_rspShifted_1)
      4'b0000 : _zz_writeBack_DBusCachedPlugin_rspShifted = writeBack_DBusCachedPlugin_rspSplits_0;
      4'b0001 : _zz_writeBack_DBusCachedPlugin_rspShifted = writeBack_DBusCachedPlugin_rspSplits_1;
      4'b0010 : _zz_writeBack_DBusCachedPlugin_rspShifted = writeBack_DBusCachedPlugin_rspSplits_2;
      4'b0011 : _zz_writeBack_DBusCachedPlugin_rspShifted = writeBack_DBusCachedPlugin_rspSplits_3;
      4'b0100 : _zz_writeBack_DBusCachedPlugin_rspShifted = writeBack_DBusCachedPlugin_rspSplits_4;
      4'b0101 : _zz_writeBack_DBusCachedPlugin_rspShifted = writeBack_DBusCachedPlugin_rspSplits_5;
      4'b0110 : _zz_writeBack_DBusCachedPlugin_rspShifted = writeBack_DBusCachedPlugin_rspSplits_6;
      4'b0111 : _zz_writeBack_DBusCachedPlugin_rspShifted = writeBack_DBusCachedPlugin_rspSplits_7;
      4'b1000 : _zz_writeBack_DBusCachedPlugin_rspShifted = writeBack_DBusCachedPlugin_rspSplits_8;
      4'b1001 : _zz_writeBack_DBusCachedPlugin_rspShifted = writeBack_DBusCachedPlugin_rspSplits_9;
      4'b1010 : _zz_writeBack_DBusCachedPlugin_rspShifted = writeBack_DBusCachedPlugin_rspSplits_10;
      4'b1011 : _zz_writeBack_DBusCachedPlugin_rspShifted = writeBack_DBusCachedPlugin_rspSplits_11;
      4'b1100 : _zz_writeBack_DBusCachedPlugin_rspShifted = writeBack_DBusCachedPlugin_rspSplits_12;
      4'b1101 : _zz_writeBack_DBusCachedPlugin_rspShifted = writeBack_DBusCachedPlugin_rspSplits_13;
      4'b1110 : _zz_writeBack_DBusCachedPlugin_rspShifted = writeBack_DBusCachedPlugin_rspSplits_14;
      default : _zz_writeBack_DBusCachedPlugin_rspShifted = writeBack_DBusCachedPlugin_rspSplits_15;
    endcase
  end

  always @(*) begin
    case(_zz_writeBack_DBusCachedPlugin_rspShifted_3)
      3'b000 : _zz_writeBack_DBusCachedPlugin_rspShifted_2 = writeBack_DBusCachedPlugin_rspSplits_1;
      3'b001 : _zz_writeBack_DBusCachedPlugin_rspShifted_2 = writeBack_DBusCachedPlugin_rspSplits_3;
      3'b010 : _zz_writeBack_DBusCachedPlugin_rspShifted_2 = writeBack_DBusCachedPlugin_rspSplits_5;
      3'b011 : _zz_writeBack_DBusCachedPlugin_rspShifted_2 = writeBack_DBusCachedPlugin_rspSplits_7;
      3'b100 : _zz_writeBack_DBusCachedPlugin_rspShifted_2 = writeBack_DBusCachedPlugin_rspSplits_9;
      3'b101 : _zz_writeBack_DBusCachedPlugin_rspShifted_2 = writeBack_DBusCachedPlugin_rspSplits_11;
      3'b110 : _zz_writeBack_DBusCachedPlugin_rspShifted_2 = writeBack_DBusCachedPlugin_rspSplits_13;
      default : _zz_writeBack_DBusCachedPlugin_rspShifted_2 = writeBack_DBusCachedPlugin_rspSplits_15;
    endcase
  end

  always @(*) begin
    case(_zz_writeBack_DBusCachedPlugin_rspShifted_5)
      2'b00 : _zz_writeBack_DBusCachedPlugin_rspShifted_4 = writeBack_DBusCachedPlugin_rspSplits_2;
      2'b01 : _zz_writeBack_DBusCachedPlugin_rspShifted_4 = writeBack_DBusCachedPlugin_rspSplits_6;
      2'b10 : _zz_writeBack_DBusCachedPlugin_rspShifted_4 = writeBack_DBusCachedPlugin_rspSplits_10;
      default : _zz_writeBack_DBusCachedPlugin_rspShifted_4 = writeBack_DBusCachedPlugin_rspSplits_14;
    endcase
  end

  always @(*) begin
    case(_zz_writeBack_DBusCachedPlugin_rspShifted_7)
      2'b00 : _zz_writeBack_DBusCachedPlugin_rspShifted_6 = writeBack_DBusCachedPlugin_rspSplits_3;
      2'b01 : _zz_writeBack_DBusCachedPlugin_rspShifted_6 = writeBack_DBusCachedPlugin_rspSplits_7;
      2'b10 : _zz_writeBack_DBusCachedPlugin_rspShifted_6 = writeBack_DBusCachedPlugin_rspSplits_11;
      default : _zz_writeBack_DBusCachedPlugin_rspShifted_6 = writeBack_DBusCachedPlugin_rspSplits_15;
    endcase
  end

  always @(*) begin
    case(_zz_writeBack_DBusCachedPlugin_rspShifted_9)
      1'b0 : _zz_writeBack_DBusCachedPlugin_rspShifted_8 = writeBack_DBusCachedPlugin_rspSplits_4;
      default : _zz_writeBack_DBusCachedPlugin_rspShifted_8 = writeBack_DBusCachedPlugin_rspSplits_12;
    endcase
  end

  always @(*) begin
    case(_zz_writeBack_DBusCachedPlugin_rspShifted_11)
      1'b0 : _zz_writeBack_DBusCachedPlugin_rspShifted_10 = writeBack_DBusCachedPlugin_rspSplits_5;
      default : _zz_writeBack_DBusCachedPlugin_rspShifted_10 = writeBack_DBusCachedPlugin_rspSplits_13;
    endcase
  end

  always @(*) begin
    case(_zz_writeBack_DBusCachedPlugin_rspShifted_13)
      1'b0 : _zz_writeBack_DBusCachedPlugin_rspShifted_12 = writeBack_DBusCachedPlugin_rspSplits_6;
      default : _zz_writeBack_DBusCachedPlugin_rspShifted_12 = writeBack_DBusCachedPlugin_rspSplits_14;
    endcase
  end

  always @(*) begin
    case(_zz_writeBack_DBusCachedPlugin_rspShifted_15)
      1'b0 : _zz_writeBack_DBusCachedPlugin_rspShifted_14 = writeBack_DBusCachedPlugin_rspSplits_7;
      default : _zz_writeBack_DBusCachedPlugin_rspShifted_14 = writeBack_DBusCachedPlugin_rspSplits_15;
    endcase
  end

  `ifndef SYNTHESIS
  always @(*) begin
    case(_zz_decode_to_execute_BRANCH_CTRL)
      BranchCtrlEnum_INC : _zz_decode_to_execute_BRANCH_CTRL_string = "INC ";
      BranchCtrlEnum_B : _zz_decode_to_execute_BRANCH_CTRL_string = "B   ";
      BranchCtrlEnum_JAL : _zz_decode_to_execute_BRANCH_CTRL_string = "JAL ";
      BranchCtrlEnum_JALR : _zz_decode_to_execute_BRANCH_CTRL_string = "JALR";
      default : _zz_decode_to_execute_BRANCH_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_to_execute_BRANCH_CTRL_1)
      BranchCtrlEnum_INC : _zz_decode_to_execute_BRANCH_CTRL_1_string = "INC ";
      BranchCtrlEnum_B : _zz_decode_to_execute_BRANCH_CTRL_1_string = "B   ";
      BranchCtrlEnum_JAL : _zz_decode_to_execute_BRANCH_CTRL_1_string = "JAL ";
      BranchCtrlEnum_JALR : _zz_decode_to_execute_BRANCH_CTRL_1_string = "JALR";
      default : _zz_decode_to_execute_BRANCH_CTRL_1_string = "????";
    endcase
  end
  always @(*) begin
    case(decode_CG6Ctrlternary)
      CG6CtrlternaryEnum_CTRL_CMIX : decode_CG6Ctrlternary_string = "CTRL_CMIX";
      CG6CtrlternaryEnum_CTRL_CMOV : decode_CG6Ctrlternary_string = "CTRL_CMOV";
      CG6CtrlternaryEnum_CTRL_FSR : decode_CG6Ctrlternary_string = "CTRL_FSR ";
      default : decode_CG6Ctrlternary_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_CG6Ctrlternary)
      CG6CtrlternaryEnum_CTRL_CMIX : _zz_decode_CG6Ctrlternary_string = "CTRL_CMIX";
      CG6CtrlternaryEnum_CTRL_CMOV : _zz_decode_CG6Ctrlternary_string = "CTRL_CMOV";
      CG6CtrlternaryEnum_CTRL_FSR : _zz_decode_CG6Ctrlternary_string = "CTRL_FSR ";
      default : _zz_decode_CG6Ctrlternary_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_to_execute_CG6Ctrlternary)
      CG6CtrlternaryEnum_CTRL_CMIX : _zz_decode_to_execute_CG6Ctrlternary_string = "CTRL_CMIX";
      CG6CtrlternaryEnum_CTRL_CMOV : _zz_decode_to_execute_CG6Ctrlternary_string = "CTRL_CMOV";
      CG6CtrlternaryEnum_CTRL_FSR : _zz_decode_to_execute_CG6Ctrlternary_string = "CTRL_FSR ";
      default : _zz_decode_to_execute_CG6Ctrlternary_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_to_execute_CG6Ctrlternary_1)
      CG6CtrlternaryEnum_CTRL_CMIX : _zz_decode_to_execute_CG6Ctrlternary_1_string = "CTRL_CMIX";
      CG6CtrlternaryEnum_CTRL_CMOV : _zz_decode_to_execute_CG6Ctrlternary_1_string = "CTRL_CMOV";
      CG6CtrlternaryEnum_CTRL_FSR : _zz_decode_to_execute_CG6Ctrlternary_1_string = "CTRL_FSR ";
      default : _zz_decode_to_execute_CG6Ctrlternary_1_string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_CG6Ctrlsignextend)
      CG6CtrlsignextendEnum_CTRL_SEXTdotB : decode_CG6Ctrlsignextend_string = "CTRL_SEXTdotB";
      CG6CtrlsignextendEnum_CTRL_ZEXTdotH : decode_CG6Ctrlsignextend_string = "CTRL_ZEXTdotH";
      default : decode_CG6Ctrlsignextend_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_CG6Ctrlsignextend)
      CG6CtrlsignextendEnum_CTRL_SEXTdotB : _zz_decode_CG6Ctrlsignextend_string = "CTRL_SEXTdotB";
      CG6CtrlsignextendEnum_CTRL_ZEXTdotH : _zz_decode_CG6Ctrlsignextend_string = "CTRL_ZEXTdotH";
      default : _zz_decode_CG6Ctrlsignextend_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_to_execute_CG6Ctrlsignextend)
      CG6CtrlsignextendEnum_CTRL_SEXTdotB : _zz_decode_to_execute_CG6Ctrlsignextend_string = "CTRL_SEXTdotB";
      CG6CtrlsignextendEnum_CTRL_ZEXTdotH : _zz_decode_to_execute_CG6Ctrlsignextend_string = "CTRL_ZEXTdotH";
      default : _zz_decode_to_execute_CG6Ctrlsignextend_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_to_execute_CG6Ctrlsignextend_1)
      CG6CtrlsignextendEnum_CTRL_SEXTdotB : _zz_decode_to_execute_CG6Ctrlsignextend_1_string = "CTRL_SEXTdotB";
      CG6CtrlsignextendEnum_CTRL_ZEXTdotH : _zz_decode_to_execute_CG6Ctrlsignextend_1_string = "CTRL_ZEXTdotH";
      default : _zz_decode_to_execute_CG6Ctrlsignextend_1_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(decode_CG6Ctrlminmax)
      CG6CtrlminmaxEnum_CTRL_MAXU : decode_CG6Ctrlminmax_string = "CTRL_MAXU";
      CG6CtrlminmaxEnum_CTRL_MINU : decode_CG6Ctrlminmax_string = "CTRL_MINU";
      default : decode_CG6Ctrlminmax_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_CG6Ctrlminmax)
      CG6CtrlminmaxEnum_CTRL_MAXU : _zz_decode_CG6Ctrlminmax_string = "CTRL_MAXU";
      CG6CtrlminmaxEnum_CTRL_MINU : _zz_decode_CG6Ctrlminmax_string = "CTRL_MINU";
      default : _zz_decode_CG6Ctrlminmax_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_to_execute_CG6Ctrlminmax)
      CG6CtrlminmaxEnum_CTRL_MAXU : _zz_decode_to_execute_CG6Ctrlminmax_string = "CTRL_MAXU";
      CG6CtrlminmaxEnum_CTRL_MINU : _zz_decode_to_execute_CG6Ctrlminmax_string = "CTRL_MINU";
      default : _zz_decode_to_execute_CG6Ctrlminmax_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_to_execute_CG6Ctrlminmax_1)
      CG6CtrlminmaxEnum_CTRL_MAXU : _zz_decode_to_execute_CG6Ctrlminmax_1_string = "CTRL_MAXU";
      CG6CtrlminmaxEnum_CTRL_MINU : _zz_decode_to_execute_CG6Ctrlminmax_1_string = "CTRL_MINU";
      default : _zz_decode_to_execute_CG6Ctrlminmax_1_string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_CG6Ctrl)
      CG6CtrlEnum_CTRL_SH2ADD : decode_CG6Ctrl_string = "CTRL_SH2ADD    ";
      CG6CtrlEnum_CTRL_minmax : decode_CG6Ctrl_string = "CTRL_minmax    ";
      CG6CtrlEnum_CTRL_signextend : decode_CG6Ctrl_string = "CTRL_signextend";
      CG6CtrlEnum_CTRL_ternary : decode_CG6Ctrl_string = "CTRL_ternary   ";
      CG6CtrlEnum_CTRL_REV8 : decode_CG6Ctrl_string = "CTRL_REV8      ";
      default : decode_CG6Ctrl_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_CG6Ctrl)
      CG6CtrlEnum_CTRL_SH2ADD : _zz_decode_CG6Ctrl_string = "CTRL_SH2ADD    ";
      CG6CtrlEnum_CTRL_minmax : _zz_decode_CG6Ctrl_string = "CTRL_minmax    ";
      CG6CtrlEnum_CTRL_signextend : _zz_decode_CG6Ctrl_string = "CTRL_signextend";
      CG6CtrlEnum_CTRL_ternary : _zz_decode_CG6Ctrl_string = "CTRL_ternary   ";
      CG6CtrlEnum_CTRL_REV8 : _zz_decode_CG6Ctrl_string = "CTRL_REV8      ";
      default : _zz_decode_CG6Ctrl_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_to_execute_CG6Ctrl)
      CG6CtrlEnum_CTRL_SH2ADD : _zz_decode_to_execute_CG6Ctrl_string = "CTRL_SH2ADD    ";
      CG6CtrlEnum_CTRL_minmax : _zz_decode_to_execute_CG6Ctrl_string = "CTRL_minmax    ";
      CG6CtrlEnum_CTRL_signextend : _zz_decode_to_execute_CG6Ctrl_string = "CTRL_signextend";
      CG6CtrlEnum_CTRL_ternary : _zz_decode_to_execute_CG6Ctrl_string = "CTRL_ternary   ";
      CG6CtrlEnum_CTRL_REV8 : _zz_decode_to_execute_CG6Ctrl_string = "CTRL_REV8      ";
      default : _zz_decode_to_execute_CG6Ctrl_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_to_execute_CG6Ctrl_1)
      CG6CtrlEnum_CTRL_SH2ADD : _zz_decode_to_execute_CG6Ctrl_1_string = "CTRL_SH2ADD    ";
      CG6CtrlEnum_CTRL_minmax : _zz_decode_to_execute_CG6Ctrl_1_string = "CTRL_minmax    ";
      CG6CtrlEnum_CTRL_signextend : _zz_decode_to_execute_CG6Ctrl_1_string = "CTRL_signextend";
      CG6CtrlEnum_CTRL_ternary : _zz_decode_to_execute_CG6Ctrl_1_string = "CTRL_ternary   ";
      CG6CtrlEnum_CTRL_REV8 : _zz_decode_to_execute_CG6Ctrl_1_string = "CTRL_REV8      ";
      default : _zz_decode_to_execute_CG6Ctrl_1_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(_zz_execute_to_memory_SHIFT_CTRL)
      ShiftCtrlEnum_DISABLE_1 : _zz_execute_to_memory_SHIFT_CTRL_string = "DISABLE_1";
      ShiftCtrlEnum_SLL_1 : _zz_execute_to_memory_SHIFT_CTRL_string = "SLL_1    ";
      ShiftCtrlEnum_SRL_1 : _zz_execute_to_memory_SHIFT_CTRL_string = "SRL_1    ";
      ShiftCtrlEnum_SRA_1 : _zz_execute_to_memory_SHIFT_CTRL_string = "SRA_1    ";
      default : _zz_execute_to_memory_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_execute_to_memory_SHIFT_CTRL_1)
      ShiftCtrlEnum_DISABLE_1 : _zz_execute_to_memory_SHIFT_CTRL_1_string = "DISABLE_1";
      ShiftCtrlEnum_SLL_1 : _zz_execute_to_memory_SHIFT_CTRL_1_string = "SLL_1    ";
      ShiftCtrlEnum_SRL_1 : _zz_execute_to_memory_SHIFT_CTRL_1_string = "SRL_1    ";
      ShiftCtrlEnum_SRA_1 : _zz_execute_to_memory_SHIFT_CTRL_1_string = "SRA_1    ";
      default : _zz_execute_to_memory_SHIFT_CTRL_1_string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_SHIFT_CTRL)
      ShiftCtrlEnum_DISABLE_1 : decode_SHIFT_CTRL_string = "DISABLE_1";
      ShiftCtrlEnum_SLL_1 : decode_SHIFT_CTRL_string = "SLL_1    ";
      ShiftCtrlEnum_SRL_1 : decode_SHIFT_CTRL_string = "SRL_1    ";
      ShiftCtrlEnum_SRA_1 : decode_SHIFT_CTRL_string = "SRA_1    ";
      default : decode_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_SHIFT_CTRL)
      ShiftCtrlEnum_DISABLE_1 : _zz_decode_SHIFT_CTRL_string = "DISABLE_1";
      ShiftCtrlEnum_SLL_1 : _zz_decode_SHIFT_CTRL_string = "SLL_1    ";
      ShiftCtrlEnum_SRL_1 : _zz_decode_SHIFT_CTRL_string = "SRL_1    ";
      ShiftCtrlEnum_SRA_1 : _zz_decode_SHIFT_CTRL_string = "SRA_1    ";
      default : _zz_decode_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_to_execute_SHIFT_CTRL)
      ShiftCtrlEnum_DISABLE_1 : _zz_decode_to_execute_SHIFT_CTRL_string = "DISABLE_1";
      ShiftCtrlEnum_SLL_1 : _zz_decode_to_execute_SHIFT_CTRL_string = "SLL_1    ";
      ShiftCtrlEnum_SRL_1 : _zz_decode_to_execute_SHIFT_CTRL_string = "SRL_1    ";
      ShiftCtrlEnum_SRA_1 : _zz_decode_to_execute_SHIFT_CTRL_string = "SRA_1    ";
      default : _zz_decode_to_execute_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_to_execute_SHIFT_CTRL_1)
      ShiftCtrlEnum_DISABLE_1 : _zz_decode_to_execute_SHIFT_CTRL_1_string = "DISABLE_1";
      ShiftCtrlEnum_SLL_1 : _zz_decode_to_execute_SHIFT_CTRL_1_string = "SLL_1    ";
      ShiftCtrlEnum_SRL_1 : _zz_decode_to_execute_SHIFT_CTRL_1_string = "SRL_1    ";
      ShiftCtrlEnum_SRA_1 : _zz_decode_to_execute_SHIFT_CTRL_1_string = "SRA_1    ";
      default : _zz_decode_to_execute_SHIFT_CTRL_1_string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_ALU_BITWISE_CTRL)
      AluBitwiseCtrlEnum_XOR_1 : decode_ALU_BITWISE_CTRL_string = "XOR_1";
      AluBitwiseCtrlEnum_OR_1 : decode_ALU_BITWISE_CTRL_string = "OR_1 ";
      AluBitwiseCtrlEnum_AND_1 : decode_ALU_BITWISE_CTRL_string = "AND_1";
      default : decode_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_ALU_BITWISE_CTRL)
      AluBitwiseCtrlEnum_XOR_1 : _zz_decode_ALU_BITWISE_CTRL_string = "XOR_1";
      AluBitwiseCtrlEnum_OR_1 : _zz_decode_ALU_BITWISE_CTRL_string = "OR_1 ";
      AluBitwiseCtrlEnum_AND_1 : _zz_decode_ALU_BITWISE_CTRL_string = "AND_1";
      default : _zz_decode_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_to_execute_ALU_BITWISE_CTRL)
      AluBitwiseCtrlEnum_XOR_1 : _zz_decode_to_execute_ALU_BITWISE_CTRL_string = "XOR_1";
      AluBitwiseCtrlEnum_OR_1 : _zz_decode_to_execute_ALU_BITWISE_CTRL_string = "OR_1 ";
      AluBitwiseCtrlEnum_AND_1 : _zz_decode_to_execute_ALU_BITWISE_CTRL_string = "AND_1";
      default : _zz_decode_to_execute_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_to_execute_ALU_BITWISE_CTRL_1)
      AluBitwiseCtrlEnum_XOR_1 : _zz_decode_to_execute_ALU_BITWISE_CTRL_1_string = "XOR_1";
      AluBitwiseCtrlEnum_OR_1 : _zz_decode_to_execute_ALU_BITWISE_CTRL_1_string = "OR_1 ";
      AluBitwiseCtrlEnum_AND_1 : _zz_decode_to_execute_ALU_BITWISE_CTRL_1_string = "AND_1";
      default : _zz_decode_to_execute_ALU_BITWISE_CTRL_1_string = "?????";
    endcase
  end
  always @(*) begin
    case(decode_SRC3_CTRL)
      Src3CtrlEnum_RS : decode_SRC3_CTRL_string = "RS ";
      Src3CtrlEnum_IMI : decode_SRC3_CTRL_string = "IMI";
      default : decode_SRC3_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_decode_SRC3_CTRL)
      Src3CtrlEnum_RS : _zz_decode_SRC3_CTRL_string = "RS ";
      Src3CtrlEnum_IMI : _zz_decode_SRC3_CTRL_string = "IMI";
      default : _zz_decode_SRC3_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_decode_to_execute_SRC3_CTRL)
      Src3CtrlEnum_RS : _zz_decode_to_execute_SRC3_CTRL_string = "RS ";
      Src3CtrlEnum_IMI : _zz_decode_to_execute_SRC3_CTRL_string = "IMI";
      default : _zz_decode_to_execute_SRC3_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_decode_to_execute_SRC3_CTRL_1)
      Src3CtrlEnum_RS : _zz_decode_to_execute_SRC3_CTRL_1_string = "RS ";
      Src3CtrlEnum_IMI : _zz_decode_to_execute_SRC3_CTRL_1_string = "IMI";
      default : _zz_decode_to_execute_SRC3_CTRL_1_string = "???";
    endcase
  end
  always @(*) begin
    case(decode_SRC2_CTRL)
      Src2CtrlEnum_RS : decode_SRC2_CTRL_string = "RS ";
      Src2CtrlEnum_IMI : decode_SRC2_CTRL_string = "IMI";
      Src2CtrlEnum_IMS : decode_SRC2_CTRL_string = "IMS";
      Src2CtrlEnum_PC : decode_SRC2_CTRL_string = "PC ";
      default : decode_SRC2_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_decode_SRC2_CTRL)
      Src2CtrlEnum_RS : _zz_decode_SRC2_CTRL_string = "RS ";
      Src2CtrlEnum_IMI : _zz_decode_SRC2_CTRL_string = "IMI";
      Src2CtrlEnum_IMS : _zz_decode_SRC2_CTRL_string = "IMS";
      Src2CtrlEnum_PC : _zz_decode_SRC2_CTRL_string = "PC ";
      default : _zz_decode_SRC2_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_decode_to_execute_SRC2_CTRL)
      Src2CtrlEnum_RS : _zz_decode_to_execute_SRC2_CTRL_string = "RS ";
      Src2CtrlEnum_IMI : _zz_decode_to_execute_SRC2_CTRL_string = "IMI";
      Src2CtrlEnum_IMS : _zz_decode_to_execute_SRC2_CTRL_string = "IMS";
      Src2CtrlEnum_PC : _zz_decode_to_execute_SRC2_CTRL_string = "PC ";
      default : _zz_decode_to_execute_SRC2_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_decode_to_execute_SRC2_CTRL_1)
      Src2CtrlEnum_RS : _zz_decode_to_execute_SRC2_CTRL_1_string = "RS ";
      Src2CtrlEnum_IMI : _zz_decode_to_execute_SRC2_CTRL_1_string = "IMI";
      Src2CtrlEnum_IMS : _zz_decode_to_execute_SRC2_CTRL_1_string = "IMS";
      Src2CtrlEnum_PC : _zz_decode_to_execute_SRC2_CTRL_1_string = "PC ";
      default : _zz_decode_to_execute_SRC2_CTRL_1_string = "???";
    endcase
  end
  always @(*) begin
    case(decode_ALU_CTRL)
      AluCtrlEnum_ADD_SUB : decode_ALU_CTRL_string = "ADD_SUB ";
      AluCtrlEnum_SLT_SLTU : decode_ALU_CTRL_string = "SLT_SLTU";
      AluCtrlEnum_BITWISE : decode_ALU_CTRL_string = "BITWISE ";
      default : decode_ALU_CTRL_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_ALU_CTRL)
      AluCtrlEnum_ADD_SUB : _zz_decode_ALU_CTRL_string = "ADD_SUB ";
      AluCtrlEnum_SLT_SLTU : _zz_decode_ALU_CTRL_string = "SLT_SLTU";
      AluCtrlEnum_BITWISE : _zz_decode_ALU_CTRL_string = "BITWISE ";
      default : _zz_decode_ALU_CTRL_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_to_execute_ALU_CTRL)
      AluCtrlEnum_ADD_SUB : _zz_decode_to_execute_ALU_CTRL_string = "ADD_SUB ";
      AluCtrlEnum_SLT_SLTU : _zz_decode_to_execute_ALU_CTRL_string = "SLT_SLTU";
      AluCtrlEnum_BITWISE : _zz_decode_to_execute_ALU_CTRL_string = "BITWISE ";
      default : _zz_decode_to_execute_ALU_CTRL_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_to_execute_ALU_CTRL_1)
      AluCtrlEnum_ADD_SUB : _zz_decode_to_execute_ALU_CTRL_1_string = "ADD_SUB ";
      AluCtrlEnum_SLT_SLTU : _zz_decode_to_execute_ALU_CTRL_1_string = "SLT_SLTU";
      AluCtrlEnum_BITWISE : _zz_decode_to_execute_ALU_CTRL_1_string = "BITWISE ";
      default : _zz_decode_to_execute_ALU_CTRL_1_string = "????????";
    endcase
  end
  always @(*) begin
    case(decode_SRC1_CTRL)
      Src1CtrlEnum_RS : decode_SRC1_CTRL_string = "RS          ";
      Src1CtrlEnum_IMU : decode_SRC1_CTRL_string = "IMU         ";
      Src1CtrlEnum_PC_INCREMENT : decode_SRC1_CTRL_string = "PC_INCREMENT";
      Src1CtrlEnum_URS1 : decode_SRC1_CTRL_string = "URS1        ";
      default : decode_SRC1_CTRL_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_SRC1_CTRL)
      Src1CtrlEnum_RS : _zz_decode_SRC1_CTRL_string = "RS          ";
      Src1CtrlEnum_IMU : _zz_decode_SRC1_CTRL_string = "IMU         ";
      Src1CtrlEnum_PC_INCREMENT : _zz_decode_SRC1_CTRL_string = "PC_INCREMENT";
      Src1CtrlEnum_URS1 : _zz_decode_SRC1_CTRL_string = "URS1        ";
      default : _zz_decode_SRC1_CTRL_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_to_execute_SRC1_CTRL)
      Src1CtrlEnum_RS : _zz_decode_to_execute_SRC1_CTRL_string = "RS          ";
      Src1CtrlEnum_IMU : _zz_decode_to_execute_SRC1_CTRL_string = "IMU         ";
      Src1CtrlEnum_PC_INCREMENT : _zz_decode_to_execute_SRC1_CTRL_string = "PC_INCREMENT";
      Src1CtrlEnum_URS1 : _zz_decode_to_execute_SRC1_CTRL_string = "URS1        ";
      default : _zz_decode_to_execute_SRC1_CTRL_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_to_execute_SRC1_CTRL_1)
      Src1CtrlEnum_RS : _zz_decode_to_execute_SRC1_CTRL_1_string = "RS          ";
      Src1CtrlEnum_IMU : _zz_decode_to_execute_SRC1_CTRL_1_string = "IMU         ";
      Src1CtrlEnum_PC_INCREMENT : _zz_decode_to_execute_SRC1_CTRL_1_string = "PC_INCREMENT";
      Src1CtrlEnum_URS1 : _zz_decode_to_execute_SRC1_CTRL_1_string = "URS1        ";
      default : _zz_decode_to_execute_SRC1_CTRL_1_string = "????????????";
    endcase
  end
  always @(*) begin
    case(execute_BRANCH_CTRL)
      BranchCtrlEnum_INC : execute_BRANCH_CTRL_string = "INC ";
      BranchCtrlEnum_B : execute_BRANCH_CTRL_string = "B   ";
      BranchCtrlEnum_JAL : execute_BRANCH_CTRL_string = "JAL ";
      BranchCtrlEnum_JALR : execute_BRANCH_CTRL_string = "JALR";
      default : execute_BRANCH_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_execute_BRANCH_CTRL)
      BranchCtrlEnum_INC : _zz_execute_BRANCH_CTRL_string = "INC ";
      BranchCtrlEnum_B : _zz_execute_BRANCH_CTRL_string = "B   ";
      BranchCtrlEnum_JAL : _zz_execute_BRANCH_CTRL_string = "JAL ";
      BranchCtrlEnum_JALR : _zz_execute_BRANCH_CTRL_string = "JALR";
      default : _zz_execute_BRANCH_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(execute_CG6Ctrl)
      CG6CtrlEnum_CTRL_SH2ADD : execute_CG6Ctrl_string = "CTRL_SH2ADD    ";
      CG6CtrlEnum_CTRL_minmax : execute_CG6Ctrl_string = "CTRL_minmax    ";
      CG6CtrlEnum_CTRL_signextend : execute_CG6Ctrl_string = "CTRL_signextend";
      CG6CtrlEnum_CTRL_ternary : execute_CG6Ctrl_string = "CTRL_ternary   ";
      CG6CtrlEnum_CTRL_REV8 : execute_CG6Ctrl_string = "CTRL_REV8      ";
      default : execute_CG6Ctrl_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(_zz_execute_CG6Ctrl)
      CG6CtrlEnum_CTRL_SH2ADD : _zz_execute_CG6Ctrl_string = "CTRL_SH2ADD    ";
      CG6CtrlEnum_CTRL_minmax : _zz_execute_CG6Ctrl_string = "CTRL_minmax    ";
      CG6CtrlEnum_CTRL_signextend : _zz_execute_CG6Ctrl_string = "CTRL_signextend";
      CG6CtrlEnum_CTRL_ternary : _zz_execute_CG6Ctrl_string = "CTRL_ternary   ";
      CG6CtrlEnum_CTRL_REV8 : _zz_execute_CG6Ctrl_string = "CTRL_REV8      ";
      default : _zz_execute_CG6Ctrl_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(execute_CG6Ctrlternary)
      CG6CtrlternaryEnum_CTRL_CMIX : execute_CG6Ctrlternary_string = "CTRL_CMIX";
      CG6CtrlternaryEnum_CTRL_CMOV : execute_CG6Ctrlternary_string = "CTRL_CMOV";
      CG6CtrlternaryEnum_CTRL_FSR : execute_CG6Ctrlternary_string = "CTRL_FSR ";
      default : execute_CG6Ctrlternary_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_execute_CG6Ctrlternary)
      CG6CtrlternaryEnum_CTRL_CMIX : _zz_execute_CG6Ctrlternary_string = "CTRL_CMIX";
      CG6CtrlternaryEnum_CTRL_CMOV : _zz_execute_CG6Ctrlternary_string = "CTRL_CMOV";
      CG6CtrlternaryEnum_CTRL_FSR : _zz_execute_CG6Ctrlternary_string = "CTRL_FSR ";
      default : _zz_execute_CG6Ctrlternary_string = "?????????";
    endcase
  end
  always @(*) begin
    case(execute_CG6Ctrlsignextend)
      CG6CtrlsignextendEnum_CTRL_SEXTdotB : execute_CG6Ctrlsignextend_string = "CTRL_SEXTdotB";
      CG6CtrlsignextendEnum_CTRL_ZEXTdotH : execute_CG6Ctrlsignextend_string = "CTRL_ZEXTdotH";
      default : execute_CG6Ctrlsignextend_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(_zz_execute_CG6Ctrlsignextend)
      CG6CtrlsignextendEnum_CTRL_SEXTdotB : _zz_execute_CG6Ctrlsignextend_string = "CTRL_SEXTdotB";
      CG6CtrlsignextendEnum_CTRL_ZEXTdotH : _zz_execute_CG6Ctrlsignextend_string = "CTRL_ZEXTdotH";
      default : _zz_execute_CG6Ctrlsignextend_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(execute_CG6Ctrlminmax)
      CG6CtrlminmaxEnum_CTRL_MAXU : execute_CG6Ctrlminmax_string = "CTRL_MAXU";
      CG6CtrlminmaxEnum_CTRL_MINU : execute_CG6Ctrlminmax_string = "CTRL_MINU";
      default : execute_CG6Ctrlminmax_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_execute_CG6Ctrlminmax)
      CG6CtrlminmaxEnum_CTRL_MAXU : _zz_execute_CG6Ctrlminmax_string = "CTRL_MAXU";
      CG6CtrlminmaxEnum_CTRL_MINU : _zz_execute_CG6Ctrlminmax_string = "CTRL_MINU";
      default : _zz_execute_CG6Ctrlminmax_string = "?????????";
    endcase
  end
  always @(*) begin
    case(memory_SHIFT_CTRL)
      ShiftCtrlEnum_DISABLE_1 : memory_SHIFT_CTRL_string = "DISABLE_1";
      ShiftCtrlEnum_SLL_1 : memory_SHIFT_CTRL_string = "SLL_1    ";
      ShiftCtrlEnum_SRL_1 : memory_SHIFT_CTRL_string = "SRL_1    ";
      ShiftCtrlEnum_SRA_1 : memory_SHIFT_CTRL_string = "SRA_1    ";
      default : memory_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_memory_SHIFT_CTRL)
      ShiftCtrlEnum_DISABLE_1 : _zz_memory_SHIFT_CTRL_string = "DISABLE_1";
      ShiftCtrlEnum_SLL_1 : _zz_memory_SHIFT_CTRL_string = "SLL_1    ";
      ShiftCtrlEnum_SRL_1 : _zz_memory_SHIFT_CTRL_string = "SRL_1    ";
      ShiftCtrlEnum_SRA_1 : _zz_memory_SHIFT_CTRL_string = "SRA_1    ";
      default : _zz_memory_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(execute_SHIFT_CTRL)
      ShiftCtrlEnum_DISABLE_1 : execute_SHIFT_CTRL_string = "DISABLE_1";
      ShiftCtrlEnum_SLL_1 : execute_SHIFT_CTRL_string = "SLL_1    ";
      ShiftCtrlEnum_SRL_1 : execute_SHIFT_CTRL_string = "SRL_1    ";
      ShiftCtrlEnum_SRA_1 : execute_SHIFT_CTRL_string = "SRA_1    ";
      default : execute_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_execute_SHIFT_CTRL)
      ShiftCtrlEnum_DISABLE_1 : _zz_execute_SHIFT_CTRL_string = "DISABLE_1";
      ShiftCtrlEnum_SLL_1 : _zz_execute_SHIFT_CTRL_string = "SLL_1    ";
      ShiftCtrlEnum_SRL_1 : _zz_execute_SHIFT_CTRL_string = "SRL_1    ";
      ShiftCtrlEnum_SRA_1 : _zz_execute_SHIFT_CTRL_string = "SRA_1    ";
      default : _zz_execute_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(execute_SRC3_CTRL)
      Src3CtrlEnum_RS : execute_SRC3_CTRL_string = "RS ";
      Src3CtrlEnum_IMI : execute_SRC3_CTRL_string = "IMI";
      default : execute_SRC3_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_execute_SRC3_CTRL)
      Src3CtrlEnum_RS : _zz_execute_SRC3_CTRL_string = "RS ";
      Src3CtrlEnum_IMI : _zz_execute_SRC3_CTRL_string = "IMI";
      default : _zz_execute_SRC3_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(execute_SRC2_CTRL)
      Src2CtrlEnum_RS : execute_SRC2_CTRL_string = "RS ";
      Src2CtrlEnum_IMI : execute_SRC2_CTRL_string = "IMI";
      Src2CtrlEnum_IMS : execute_SRC2_CTRL_string = "IMS";
      Src2CtrlEnum_PC : execute_SRC2_CTRL_string = "PC ";
      default : execute_SRC2_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_execute_SRC2_CTRL)
      Src2CtrlEnum_RS : _zz_execute_SRC2_CTRL_string = "RS ";
      Src2CtrlEnum_IMI : _zz_execute_SRC2_CTRL_string = "IMI";
      Src2CtrlEnum_IMS : _zz_execute_SRC2_CTRL_string = "IMS";
      Src2CtrlEnum_PC : _zz_execute_SRC2_CTRL_string = "PC ";
      default : _zz_execute_SRC2_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(execute_SRC1_CTRL)
      Src1CtrlEnum_RS : execute_SRC1_CTRL_string = "RS          ";
      Src1CtrlEnum_IMU : execute_SRC1_CTRL_string = "IMU         ";
      Src1CtrlEnum_PC_INCREMENT : execute_SRC1_CTRL_string = "PC_INCREMENT";
      Src1CtrlEnum_URS1 : execute_SRC1_CTRL_string = "URS1        ";
      default : execute_SRC1_CTRL_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_execute_SRC1_CTRL)
      Src1CtrlEnum_RS : _zz_execute_SRC1_CTRL_string = "RS          ";
      Src1CtrlEnum_IMU : _zz_execute_SRC1_CTRL_string = "IMU         ";
      Src1CtrlEnum_PC_INCREMENT : _zz_execute_SRC1_CTRL_string = "PC_INCREMENT";
      Src1CtrlEnum_URS1 : _zz_execute_SRC1_CTRL_string = "URS1        ";
      default : _zz_execute_SRC1_CTRL_string = "????????????";
    endcase
  end
  always @(*) begin
    case(execute_ALU_CTRL)
      AluCtrlEnum_ADD_SUB : execute_ALU_CTRL_string = "ADD_SUB ";
      AluCtrlEnum_SLT_SLTU : execute_ALU_CTRL_string = "SLT_SLTU";
      AluCtrlEnum_BITWISE : execute_ALU_CTRL_string = "BITWISE ";
      default : execute_ALU_CTRL_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_execute_ALU_CTRL)
      AluCtrlEnum_ADD_SUB : _zz_execute_ALU_CTRL_string = "ADD_SUB ";
      AluCtrlEnum_SLT_SLTU : _zz_execute_ALU_CTRL_string = "SLT_SLTU";
      AluCtrlEnum_BITWISE : _zz_execute_ALU_CTRL_string = "BITWISE ";
      default : _zz_execute_ALU_CTRL_string = "????????";
    endcase
  end
  always @(*) begin
    case(execute_ALU_BITWISE_CTRL)
      AluBitwiseCtrlEnum_XOR_1 : execute_ALU_BITWISE_CTRL_string = "XOR_1";
      AluBitwiseCtrlEnum_OR_1 : execute_ALU_BITWISE_CTRL_string = "OR_1 ";
      AluBitwiseCtrlEnum_AND_1 : execute_ALU_BITWISE_CTRL_string = "AND_1";
      default : execute_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_execute_ALU_BITWISE_CTRL)
      AluBitwiseCtrlEnum_XOR_1 : _zz_execute_ALU_BITWISE_CTRL_string = "XOR_1";
      AluBitwiseCtrlEnum_OR_1 : _zz_execute_ALU_BITWISE_CTRL_string = "OR_1 ";
      AluBitwiseCtrlEnum_AND_1 : _zz_execute_ALU_BITWISE_CTRL_string = "AND_1";
      default : _zz_execute_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_BRANCH_CTRL)
      BranchCtrlEnum_INC : _zz_decode_BRANCH_CTRL_string = "INC ";
      BranchCtrlEnum_B : _zz_decode_BRANCH_CTRL_string = "B   ";
      BranchCtrlEnum_JAL : _zz_decode_BRANCH_CTRL_string = "JAL ";
      BranchCtrlEnum_JALR : _zz_decode_BRANCH_CTRL_string = "JALR";
      default : _zz_decode_BRANCH_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_CG6Ctrlternary_1)
      CG6CtrlternaryEnum_CTRL_CMIX : _zz_decode_CG6Ctrlternary_1_string = "CTRL_CMIX";
      CG6CtrlternaryEnum_CTRL_CMOV : _zz_decode_CG6Ctrlternary_1_string = "CTRL_CMOV";
      CG6CtrlternaryEnum_CTRL_FSR : _zz_decode_CG6Ctrlternary_1_string = "CTRL_FSR ";
      default : _zz_decode_CG6Ctrlternary_1_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_CG6Ctrlsignextend_1)
      CG6CtrlsignextendEnum_CTRL_SEXTdotB : _zz_decode_CG6Ctrlsignextend_1_string = "CTRL_SEXTdotB";
      CG6CtrlsignextendEnum_CTRL_ZEXTdotH : _zz_decode_CG6Ctrlsignextend_1_string = "CTRL_ZEXTdotH";
      default : _zz_decode_CG6Ctrlsignextend_1_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_CG6Ctrlminmax_1)
      CG6CtrlminmaxEnum_CTRL_MAXU : _zz_decode_CG6Ctrlminmax_1_string = "CTRL_MAXU";
      CG6CtrlminmaxEnum_CTRL_MINU : _zz_decode_CG6Ctrlminmax_1_string = "CTRL_MINU";
      default : _zz_decode_CG6Ctrlminmax_1_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_CG6Ctrl_1)
      CG6CtrlEnum_CTRL_SH2ADD : _zz_decode_CG6Ctrl_1_string = "CTRL_SH2ADD    ";
      CG6CtrlEnum_CTRL_minmax : _zz_decode_CG6Ctrl_1_string = "CTRL_minmax    ";
      CG6CtrlEnum_CTRL_signextend : _zz_decode_CG6Ctrl_1_string = "CTRL_signextend";
      CG6CtrlEnum_CTRL_ternary : _zz_decode_CG6Ctrl_1_string = "CTRL_ternary   ";
      CG6CtrlEnum_CTRL_REV8 : _zz_decode_CG6Ctrl_1_string = "CTRL_REV8      ";
      default : _zz_decode_CG6Ctrl_1_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_SHIFT_CTRL_1)
      ShiftCtrlEnum_DISABLE_1 : _zz_decode_SHIFT_CTRL_1_string = "DISABLE_1";
      ShiftCtrlEnum_SLL_1 : _zz_decode_SHIFT_CTRL_1_string = "SLL_1    ";
      ShiftCtrlEnum_SRL_1 : _zz_decode_SHIFT_CTRL_1_string = "SRL_1    ";
      ShiftCtrlEnum_SRA_1 : _zz_decode_SHIFT_CTRL_1_string = "SRA_1    ";
      default : _zz_decode_SHIFT_CTRL_1_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_ALU_BITWISE_CTRL_1)
      AluBitwiseCtrlEnum_XOR_1 : _zz_decode_ALU_BITWISE_CTRL_1_string = "XOR_1";
      AluBitwiseCtrlEnum_OR_1 : _zz_decode_ALU_BITWISE_CTRL_1_string = "OR_1 ";
      AluBitwiseCtrlEnum_AND_1 : _zz_decode_ALU_BITWISE_CTRL_1_string = "AND_1";
      default : _zz_decode_ALU_BITWISE_CTRL_1_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_SRC3_CTRL_1)
      Src3CtrlEnum_RS : _zz_decode_SRC3_CTRL_1_string = "RS ";
      Src3CtrlEnum_IMI : _zz_decode_SRC3_CTRL_1_string = "IMI";
      default : _zz_decode_SRC3_CTRL_1_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_decode_SRC2_CTRL_1)
      Src2CtrlEnum_RS : _zz_decode_SRC2_CTRL_1_string = "RS ";
      Src2CtrlEnum_IMI : _zz_decode_SRC2_CTRL_1_string = "IMI";
      Src2CtrlEnum_IMS : _zz_decode_SRC2_CTRL_1_string = "IMS";
      Src2CtrlEnum_PC : _zz_decode_SRC2_CTRL_1_string = "PC ";
      default : _zz_decode_SRC2_CTRL_1_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_decode_ALU_CTRL_1)
      AluCtrlEnum_ADD_SUB : _zz_decode_ALU_CTRL_1_string = "ADD_SUB ";
      AluCtrlEnum_SLT_SLTU : _zz_decode_ALU_CTRL_1_string = "SLT_SLTU";
      AluCtrlEnum_BITWISE : _zz_decode_ALU_CTRL_1_string = "BITWISE ";
      default : _zz_decode_ALU_CTRL_1_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_SRC1_CTRL_1)
      Src1CtrlEnum_RS : _zz_decode_SRC1_CTRL_1_string = "RS          ";
      Src1CtrlEnum_IMU : _zz_decode_SRC1_CTRL_1_string = "IMU         ";
      Src1CtrlEnum_PC_INCREMENT : _zz_decode_SRC1_CTRL_1_string = "PC_INCREMENT";
      Src1CtrlEnum_URS1 : _zz_decode_SRC1_CTRL_1_string = "URS1        ";
      default : _zz_decode_SRC1_CTRL_1_string = "????????????";
    endcase
  end
  always @(*) begin
    case(decode_BRANCH_CTRL)
      BranchCtrlEnum_INC : decode_BRANCH_CTRL_string = "INC ";
      BranchCtrlEnum_B : decode_BRANCH_CTRL_string = "B   ";
      BranchCtrlEnum_JAL : decode_BRANCH_CTRL_string = "JAL ";
      BranchCtrlEnum_JALR : decode_BRANCH_CTRL_string = "JALR";
      default : decode_BRANCH_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_BRANCH_CTRL_1)
      BranchCtrlEnum_INC : _zz_decode_BRANCH_CTRL_1_string = "INC ";
      BranchCtrlEnum_B : _zz_decode_BRANCH_CTRL_1_string = "B   ";
      BranchCtrlEnum_JAL : _zz_decode_BRANCH_CTRL_1_string = "JAL ";
      BranchCtrlEnum_JALR : _zz_decode_BRANCH_CTRL_1_string = "JALR";
      default : _zz_decode_BRANCH_CTRL_1_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_SRC1_CTRL_2)
      Src1CtrlEnum_RS : _zz_decode_SRC1_CTRL_2_string = "RS          ";
      Src1CtrlEnum_IMU : _zz_decode_SRC1_CTRL_2_string = "IMU         ";
      Src1CtrlEnum_PC_INCREMENT : _zz_decode_SRC1_CTRL_2_string = "PC_INCREMENT";
      Src1CtrlEnum_URS1 : _zz_decode_SRC1_CTRL_2_string = "URS1        ";
      default : _zz_decode_SRC1_CTRL_2_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_ALU_CTRL_2)
      AluCtrlEnum_ADD_SUB : _zz_decode_ALU_CTRL_2_string = "ADD_SUB ";
      AluCtrlEnum_SLT_SLTU : _zz_decode_ALU_CTRL_2_string = "SLT_SLTU";
      AluCtrlEnum_BITWISE : _zz_decode_ALU_CTRL_2_string = "BITWISE ";
      default : _zz_decode_ALU_CTRL_2_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_SRC2_CTRL_2)
      Src2CtrlEnum_RS : _zz_decode_SRC2_CTRL_2_string = "RS ";
      Src2CtrlEnum_IMI : _zz_decode_SRC2_CTRL_2_string = "IMI";
      Src2CtrlEnum_IMS : _zz_decode_SRC2_CTRL_2_string = "IMS";
      Src2CtrlEnum_PC : _zz_decode_SRC2_CTRL_2_string = "PC ";
      default : _zz_decode_SRC2_CTRL_2_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_decode_SRC3_CTRL_2)
      Src3CtrlEnum_RS : _zz_decode_SRC3_CTRL_2_string = "RS ";
      Src3CtrlEnum_IMI : _zz_decode_SRC3_CTRL_2_string = "IMI";
      default : _zz_decode_SRC3_CTRL_2_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_decode_ALU_BITWISE_CTRL_2)
      AluBitwiseCtrlEnum_XOR_1 : _zz_decode_ALU_BITWISE_CTRL_2_string = "XOR_1";
      AluBitwiseCtrlEnum_OR_1 : _zz_decode_ALU_BITWISE_CTRL_2_string = "OR_1 ";
      AluBitwiseCtrlEnum_AND_1 : _zz_decode_ALU_BITWISE_CTRL_2_string = "AND_1";
      default : _zz_decode_ALU_BITWISE_CTRL_2_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_SHIFT_CTRL_2)
      ShiftCtrlEnum_DISABLE_1 : _zz_decode_SHIFT_CTRL_2_string = "DISABLE_1";
      ShiftCtrlEnum_SLL_1 : _zz_decode_SHIFT_CTRL_2_string = "SLL_1    ";
      ShiftCtrlEnum_SRL_1 : _zz_decode_SHIFT_CTRL_2_string = "SRL_1    ";
      ShiftCtrlEnum_SRA_1 : _zz_decode_SHIFT_CTRL_2_string = "SRA_1    ";
      default : _zz_decode_SHIFT_CTRL_2_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_CG6Ctrl_2)
      CG6CtrlEnum_CTRL_SH2ADD : _zz_decode_CG6Ctrl_2_string = "CTRL_SH2ADD    ";
      CG6CtrlEnum_CTRL_minmax : _zz_decode_CG6Ctrl_2_string = "CTRL_minmax    ";
      CG6CtrlEnum_CTRL_signextend : _zz_decode_CG6Ctrl_2_string = "CTRL_signextend";
      CG6CtrlEnum_CTRL_ternary : _zz_decode_CG6Ctrl_2_string = "CTRL_ternary   ";
      CG6CtrlEnum_CTRL_REV8 : _zz_decode_CG6Ctrl_2_string = "CTRL_REV8      ";
      default : _zz_decode_CG6Ctrl_2_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_CG6Ctrlminmax_2)
      CG6CtrlminmaxEnum_CTRL_MAXU : _zz_decode_CG6Ctrlminmax_2_string = "CTRL_MAXU";
      CG6CtrlminmaxEnum_CTRL_MINU : _zz_decode_CG6Ctrlminmax_2_string = "CTRL_MINU";
      default : _zz_decode_CG6Ctrlminmax_2_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_CG6Ctrlsignextend_2)
      CG6CtrlsignextendEnum_CTRL_SEXTdotB : _zz_decode_CG6Ctrlsignextend_2_string = "CTRL_SEXTdotB";
      CG6CtrlsignextendEnum_CTRL_ZEXTdotH : _zz_decode_CG6Ctrlsignextend_2_string = "CTRL_ZEXTdotH";
      default : _zz_decode_CG6Ctrlsignextend_2_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_CG6Ctrlternary_2)
      CG6CtrlternaryEnum_CTRL_CMIX : _zz_decode_CG6Ctrlternary_2_string = "CTRL_CMIX";
      CG6CtrlternaryEnum_CTRL_CMOV : _zz_decode_CG6Ctrlternary_2_string = "CTRL_CMOV";
      CG6CtrlternaryEnum_CTRL_FSR : _zz_decode_CG6Ctrlternary_2_string = "CTRL_FSR ";
      default : _zz_decode_CG6Ctrlternary_2_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_decode_BRANCH_CTRL_2)
      BranchCtrlEnum_INC : _zz_decode_BRANCH_CTRL_2_string = "INC ";
      BranchCtrlEnum_B : _zz_decode_BRANCH_CTRL_2_string = "B   ";
      BranchCtrlEnum_JAL : _zz_decode_BRANCH_CTRL_2_string = "JAL ";
      BranchCtrlEnum_JALR : _zz_decode_BRANCH_CTRL_2_string = "JALR";
      default : _zz_decode_BRANCH_CTRL_2_string = "????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_SRC1_CTRL)
      Src1CtrlEnum_RS : decode_to_execute_SRC1_CTRL_string = "RS          ";
      Src1CtrlEnum_IMU : decode_to_execute_SRC1_CTRL_string = "IMU         ";
      Src1CtrlEnum_PC_INCREMENT : decode_to_execute_SRC1_CTRL_string = "PC_INCREMENT";
      Src1CtrlEnum_URS1 : decode_to_execute_SRC1_CTRL_string = "URS1        ";
      default : decode_to_execute_SRC1_CTRL_string = "????????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_ALU_CTRL)
      AluCtrlEnum_ADD_SUB : decode_to_execute_ALU_CTRL_string = "ADD_SUB ";
      AluCtrlEnum_SLT_SLTU : decode_to_execute_ALU_CTRL_string = "SLT_SLTU";
      AluCtrlEnum_BITWISE : decode_to_execute_ALU_CTRL_string = "BITWISE ";
      default : decode_to_execute_ALU_CTRL_string = "????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_SRC2_CTRL)
      Src2CtrlEnum_RS : decode_to_execute_SRC2_CTRL_string = "RS ";
      Src2CtrlEnum_IMI : decode_to_execute_SRC2_CTRL_string = "IMI";
      Src2CtrlEnum_IMS : decode_to_execute_SRC2_CTRL_string = "IMS";
      Src2CtrlEnum_PC : decode_to_execute_SRC2_CTRL_string = "PC ";
      default : decode_to_execute_SRC2_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_SRC3_CTRL)
      Src3CtrlEnum_RS : decode_to_execute_SRC3_CTRL_string = "RS ";
      Src3CtrlEnum_IMI : decode_to_execute_SRC3_CTRL_string = "IMI";
      default : decode_to_execute_SRC3_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_ALU_BITWISE_CTRL)
      AluBitwiseCtrlEnum_XOR_1 : decode_to_execute_ALU_BITWISE_CTRL_string = "XOR_1";
      AluBitwiseCtrlEnum_OR_1 : decode_to_execute_ALU_BITWISE_CTRL_string = "OR_1 ";
      AluBitwiseCtrlEnum_AND_1 : decode_to_execute_ALU_BITWISE_CTRL_string = "AND_1";
      default : decode_to_execute_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_SHIFT_CTRL)
      ShiftCtrlEnum_DISABLE_1 : decode_to_execute_SHIFT_CTRL_string = "DISABLE_1";
      ShiftCtrlEnum_SLL_1 : decode_to_execute_SHIFT_CTRL_string = "SLL_1    ";
      ShiftCtrlEnum_SRL_1 : decode_to_execute_SHIFT_CTRL_string = "SRL_1    ";
      ShiftCtrlEnum_SRA_1 : decode_to_execute_SHIFT_CTRL_string = "SRA_1    ";
      default : decode_to_execute_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(execute_to_memory_SHIFT_CTRL)
      ShiftCtrlEnum_DISABLE_1 : execute_to_memory_SHIFT_CTRL_string = "DISABLE_1";
      ShiftCtrlEnum_SLL_1 : execute_to_memory_SHIFT_CTRL_string = "SLL_1    ";
      ShiftCtrlEnum_SRL_1 : execute_to_memory_SHIFT_CTRL_string = "SRL_1    ";
      ShiftCtrlEnum_SRA_1 : execute_to_memory_SHIFT_CTRL_string = "SRA_1    ";
      default : execute_to_memory_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_CG6Ctrl)
      CG6CtrlEnum_CTRL_SH2ADD : decode_to_execute_CG6Ctrl_string = "CTRL_SH2ADD    ";
      CG6CtrlEnum_CTRL_minmax : decode_to_execute_CG6Ctrl_string = "CTRL_minmax    ";
      CG6CtrlEnum_CTRL_signextend : decode_to_execute_CG6Ctrl_string = "CTRL_signextend";
      CG6CtrlEnum_CTRL_ternary : decode_to_execute_CG6Ctrl_string = "CTRL_ternary   ";
      CG6CtrlEnum_CTRL_REV8 : decode_to_execute_CG6Ctrl_string = "CTRL_REV8      ";
      default : decode_to_execute_CG6Ctrl_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_CG6Ctrlminmax)
      CG6CtrlminmaxEnum_CTRL_MAXU : decode_to_execute_CG6Ctrlminmax_string = "CTRL_MAXU";
      CG6CtrlminmaxEnum_CTRL_MINU : decode_to_execute_CG6Ctrlminmax_string = "CTRL_MINU";
      default : decode_to_execute_CG6Ctrlminmax_string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_CG6Ctrlsignextend)
      CG6CtrlsignextendEnum_CTRL_SEXTdotB : decode_to_execute_CG6Ctrlsignextend_string = "CTRL_SEXTdotB";
      CG6CtrlsignextendEnum_CTRL_ZEXTdotH : decode_to_execute_CG6Ctrlsignextend_string = "CTRL_ZEXTdotH";
      default : decode_to_execute_CG6Ctrlsignextend_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_CG6Ctrlternary)
      CG6CtrlternaryEnum_CTRL_CMIX : decode_to_execute_CG6Ctrlternary_string = "CTRL_CMIX";
      CG6CtrlternaryEnum_CTRL_CMOV : decode_to_execute_CG6Ctrlternary_string = "CTRL_CMOV";
      CG6CtrlternaryEnum_CTRL_FSR : decode_to_execute_CG6Ctrlternary_string = "CTRL_FSR ";
      default : decode_to_execute_CG6Ctrlternary_string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_BRANCH_CTRL)
      BranchCtrlEnum_INC : decode_to_execute_BRANCH_CTRL_string = "INC ";
      BranchCtrlEnum_B : decode_to_execute_BRANCH_CTRL_string = "B   ";
      BranchCtrlEnum_JAL : decode_to_execute_BRANCH_CTRL_string = "JAL ";
      BranchCtrlEnum_JALR : decode_to_execute_BRANCH_CTRL_string = "JALR";
      default : decode_to_execute_BRANCH_CTRL_string = "????";
    endcase
  end
  `endif

  assign execute_BRANCH_CALC = {execute_BranchPlugin_branchAdder[31 : 1],1'b0};
  assign execute_BRANCH_DO = ((execute_PREDICTION_HAD_BRANCHED2 != execute_BRANCH_COND_RESULT) || execute_BranchPlugin_missAlignedTarget);
  assign execute_CG6_FINAL_OUTPUT = _zz_execute_CG6_FINAL_OUTPUT;
  assign execute_SHIFT_RIGHT = _zz_execute_SHIFT_RIGHT;
  assign writeBack_REGFILE_WRITE_DATA_ODD = memory_to_writeBack_REGFILE_WRITE_DATA_ODD;
  assign memory_REGFILE_WRITE_DATA_ODD = execute_to_memory_REGFILE_WRITE_DATA_ODD;
  assign execute_REGFILE_WRITE_DATA_ODD = 32'h0;
  assign execute_REGFILE_WRITE_DATA = _zz_execute_REGFILE_WRITE_DATA;
  assign memory_MEMORY_STORE_DATA_RF = execute_to_memory_MEMORY_STORE_DATA_RF;
  assign execute_MEMORY_STORE_DATA_RF = _zz_execute_MEMORY_STORE_DATA_RF;
  assign decode_PREDICTION_HAD_BRANCHED2 = IBusCachedPlugin_decodePrediction_cmd_hadBranch;
  assign decode_SRC2_FORCE_ZERO = (decode_SRC_ADD_ZERO && (! decode_SRC_USE_SUB_LESS));
  assign execute_RS3 = decode_to_execute_RS3;
  assign decode_REGFILE_WRITE_VALID_ODD = _zz_decode_REGFILE_WRITE_VALID_ODD[35];
  assign _zz_decode_to_execute_BRANCH_CTRL = _zz_decode_to_execute_BRANCH_CTRL_1;
  assign decode_CG6Ctrlternary = _zz_decode_CG6Ctrlternary;
  assign _zz_decode_to_execute_CG6Ctrlternary = _zz_decode_to_execute_CG6Ctrlternary_1;
  assign decode_CG6Ctrlsignextend = _zz_decode_CG6Ctrlsignextend;
  assign _zz_decode_to_execute_CG6Ctrlsignextend = _zz_decode_to_execute_CG6Ctrlsignextend_1;
  assign decode_CG6Ctrlminmax = _zz_decode_CG6Ctrlminmax;
  assign _zz_decode_to_execute_CG6Ctrlminmax = _zz_decode_to_execute_CG6Ctrlminmax_1;
  assign decode_CG6Ctrl = _zz_decode_CG6Ctrl;
  assign _zz_decode_to_execute_CG6Ctrl = _zz_decode_to_execute_CG6Ctrl_1;
  assign execute_IS_CG6 = decode_to_execute_IS_CG6;
  assign decode_IS_CG6 = _zz_decode_REGFILE_WRITE_VALID_ODD[24];
  assign _zz_execute_to_memory_SHIFT_CTRL = _zz_execute_to_memory_SHIFT_CTRL_1;
  assign decode_SHIFT_CTRL = _zz_decode_SHIFT_CTRL;
  assign _zz_decode_to_execute_SHIFT_CTRL = _zz_decode_to_execute_SHIFT_CTRL_1;
  assign decode_ALU_BITWISE_CTRL = _zz_decode_ALU_BITWISE_CTRL;
  assign _zz_decode_to_execute_ALU_BITWISE_CTRL = _zz_decode_to_execute_ALU_BITWISE_CTRL_1;
  assign decode_SRC_LESS_UNSIGNED = _zz_decode_REGFILE_WRITE_VALID_ODD[18];
  assign decode_SRC3_CTRL = _zz_decode_SRC3_CTRL;
  assign _zz_decode_to_execute_SRC3_CTRL = _zz_decode_to_execute_SRC3_CTRL_1;
  assign decode_MEMORY_MANAGMENT = _zz_decode_REGFILE_WRITE_VALID_ODD[16];
  assign decode_MEMORY_WR = _zz_decode_REGFILE_WRITE_VALID_ODD[13];
  assign execute_BYPASSABLE_MEMORY_STAGE = decode_to_execute_BYPASSABLE_MEMORY_STAGE;
  assign decode_BYPASSABLE_MEMORY_STAGE = _zz_decode_REGFILE_WRITE_VALID_ODD[12];
  assign decode_BYPASSABLE_EXECUTE_STAGE = _zz_decode_REGFILE_WRITE_VALID_ODD[11];
  assign decode_SRC2_CTRL = _zz_decode_SRC2_CTRL;
  assign _zz_decode_to_execute_SRC2_CTRL = _zz_decode_to_execute_SRC2_CTRL_1;
  assign decode_ALU_CTRL = _zz_decode_ALU_CTRL;
  assign _zz_decode_to_execute_ALU_CTRL = _zz_decode_to_execute_ALU_CTRL_1;
  assign decode_SRC1_CTRL = _zz_decode_SRC1_CTRL;
  assign _zz_decode_to_execute_SRC1_CTRL = _zz_decode_to_execute_SRC1_CTRL_1;
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
  assign execute_BRANCH_COND_RESULT = _zz_execute_BRANCH_COND_RESULT_1;
  assign execute_BRANCH_CTRL = _zz_execute_BRANCH_CTRL;
  assign decode_RS3_USE = _zz_decode_REGFILE_WRITE_VALID_ODD[30];
  assign decode_RS2_USE = _zz_decode_REGFILE_WRITE_VALID_ODD[15];
  assign decode_RS1_USE = _zz_decode_REGFILE_WRITE_VALID_ODD[5];
  assign _zz_decode_RS3 = execute_REGFILE_WRITE_DATA_ODD;
  assign execute_REGFILE_WRITE_VALID_ODD = decode_to_execute_REGFILE_WRITE_VALID_ODD;
  assign _zz_decode_RS3_1 = execute_REGFILE_WRITE_DATA;
  assign execute_REGFILE_WRITE_VALID = decode_to_execute_REGFILE_WRITE_VALID;
  assign execute_BYPASSABLE_EXECUTE_STAGE = decode_to_execute_BYPASSABLE_EXECUTE_STAGE;
  assign _zz_decode_RS3_2 = memory_REGFILE_WRITE_DATA_ODD;
  assign memory_REGFILE_WRITE_VALID_ODD = execute_to_memory_REGFILE_WRITE_VALID_ODD;
  assign memory_REGFILE_WRITE_VALID = execute_to_memory_REGFILE_WRITE_VALID;
  assign memory_BYPASSABLE_MEMORY_STAGE = execute_to_memory_BYPASSABLE_MEMORY_STAGE;
  assign memory_INSTRUCTION = execute_to_memory_INSTRUCTION;
  assign _zz_decode_RS3_3 = writeBack_REGFILE_WRITE_DATA_ODD;
  assign writeBack_REGFILE_WRITE_VALID_ODD = memory_to_writeBack_REGFILE_WRITE_VALID_ODD;
  assign writeBack_REGFILE_WRITE_VALID = memory_to_writeBack_REGFILE_WRITE_VALID;
  always @(*) begin
    decode_RS3 = decode_RegFilePlugin_rs3Data;
    if(HazardSimplePlugin_writeBackBuffer_valid) begin
      if(HazardSimplePlugin_addr2Match) begin
        decode_RS3 = HazardSimplePlugin_writeBackBuffer_payload_data;
      end
    end
    if(when_HazardSimplePlugin_l56) begin
      if(when_HazardSimplePlugin_l58) begin
        if(when_HazardSimplePlugin_l65) begin
          decode_RS3 = _zz_decode_RS3_5;
        end
      end
    end
    if(when_HazardSimplePlugin_l71) begin
      if(when_HazardSimplePlugin_l58) begin
        if(when_HazardSimplePlugin_l80) begin
          decode_RS3 = _zz_decode_RS3_3;
        end
      end
    end
    if(when_HazardSimplePlugin_l56_1) begin
      if(memory_BYPASSABLE_MEMORY_STAGE) begin
        if(when_HazardSimplePlugin_l65_1) begin
          decode_RS3 = _zz_decode_RS3_4;
        end
      end
    end
    if(when_HazardSimplePlugin_l71_1) begin
      if(memory_BYPASSABLE_MEMORY_STAGE) begin
        if(when_HazardSimplePlugin_l80_1) begin
          decode_RS3 = _zz_decode_RS3_2;
        end
      end
    end
    if(when_HazardSimplePlugin_l56_2) begin
      if(execute_BYPASSABLE_EXECUTE_STAGE) begin
        if(when_HazardSimplePlugin_l65_2) begin
          decode_RS3 = _zz_decode_RS3_1;
        end
      end
    end
    if(when_HazardSimplePlugin_l71_2) begin
      if(execute_BYPASSABLE_EXECUTE_STAGE) begin
        if(when_HazardSimplePlugin_l80_2) begin
          decode_RS3 = _zz_decode_RS3;
        end
      end
    end
  end

  always @(*) begin
    decode_RS2 = decode_RegFilePlugin_rs2Data;
    if(HazardSimplePlugin_writeBackBuffer_valid) begin
      if(HazardSimplePlugin_addr1Match) begin
        decode_RS2 = HazardSimplePlugin_writeBackBuffer_payload_data;
      end
    end
    if(when_HazardSimplePlugin_l56) begin
      if(when_HazardSimplePlugin_l58) begin
        if(when_HazardSimplePlugin_l62) begin
          decode_RS2 = _zz_decode_RS3_5;
        end
      end
    end
    if(when_HazardSimplePlugin_l71) begin
      if(when_HazardSimplePlugin_l58) begin
        if(when_HazardSimplePlugin_l77) begin
          decode_RS2 = _zz_decode_RS3_3;
        end
      end
    end
    if(when_HazardSimplePlugin_l56_1) begin
      if(memory_BYPASSABLE_MEMORY_STAGE) begin
        if(when_HazardSimplePlugin_l62_1) begin
          decode_RS2 = _zz_decode_RS3_4;
        end
      end
    end
    if(when_HazardSimplePlugin_l71_1) begin
      if(memory_BYPASSABLE_MEMORY_STAGE) begin
        if(when_HazardSimplePlugin_l77_1) begin
          decode_RS2 = _zz_decode_RS3_2;
        end
      end
    end
    if(when_HazardSimplePlugin_l56_2) begin
      if(execute_BYPASSABLE_EXECUTE_STAGE) begin
        if(when_HazardSimplePlugin_l62_2) begin
          decode_RS2 = _zz_decode_RS3_1;
        end
      end
    end
    if(when_HazardSimplePlugin_l71_2) begin
      if(execute_BYPASSABLE_EXECUTE_STAGE) begin
        if(when_HazardSimplePlugin_l77_2) begin
          decode_RS2 = _zz_decode_RS3;
        end
      end
    end
  end

  always @(*) begin
    decode_RS1 = decode_RegFilePlugin_rs1Data;
    if(HazardSimplePlugin_writeBackBuffer_valid) begin
      if(HazardSimplePlugin_addr0Match) begin
        decode_RS1 = HazardSimplePlugin_writeBackBuffer_payload_data;
      end
    end
    if(when_HazardSimplePlugin_l56) begin
      if(when_HazardSimplePlugin_l58) begin
        if(when_HazardSimplePlugin_l59) begin
          decode_RS1 = _zz_decode_RS3_5;
        end
      end
    end
    if(when_HazardSimplePlugin_l71) begin
      if(when_HazardSimplePlugin_l58) begin
        if(when_HazardSimplePlugin_l74) begin
          decode_RS1 = _zz_decode_RS3_3;
        end
      end
    end
    if(when_HazardSimplePlugin_l56_1) begin
      if(memory_BYPASSABLE_MEMORY_STAGE) begin
        if(when_HazardSimplePlugin_l59_1) begin
          decode_RS1 = _zz_decode_RS3_4;
        end
      end
    end
    if(when_HazardSimplePlugin_l71_1) begin
      if(memory_BYPASSABLE_MEMORY_STAGE) begin
        if(when_HazardSimplePlugin_l74_1) begin
          decode_RS1 = _zz_decode_RS3_2;
        end
      end
    end
    if(when_HazardSimplePlugin_l56_2) begin
      if(execute_BYPASSABLE_EXECUTE_STAGE) begin
        if(when_HazardSimplePlugin_l59_2) begin
          decode_RS1 = _zz_decode_RS3_1;
        end
      end
    end
    if(when_HazardSimplePlugin_l71_2) begin
      if(execute_BYPASSABLE_EXECUTE_STAGE) begin
        if(when_HazardSimplePlugin_l74_2) begin
          decode_RS1 = _zz_decode_RS3;
        end
      end
    end
  end

  assign memory_CG6_FINAL_OUTPUT = execute_to_memory_CG6_FINAL_OUTPUT;
  assign memory_IS_CG6 = execute_to_memory_IS_CG6;
  assign execute_CG6Ctrl = _zz_execute_CG6Ctrl;
  assign execute_SRC3 = _zz_execute_SRC3_2;
  assign execute_CG6Ctrlternary = _zz_execute_CG6Ctrlternary;
  assign execute_CG6Ctrlsignextend = _zz_execute_CG6Ctrlsignextend;
  assign execute_CG6Ctrlminmax = _zz_execute_CG6Ctrlminmax;
  assign memory_SHIFT_RIGHT = execute_to_memory_SHIFT_RIGHT;
  always @(*) begin
    _zz_decode_RS3_4 = memory_REGFILE_WRITE_DATA;
    if(memory_arbitration_isValid) begin
      case(memory_SHIFT_CTRL)
        ShiftCtrlEnum_SLL_1 : begin
          _zz_decode_RS3_4 = _zz_decode_RS3_6;
        end
        ShiftCtrlEnum_SRL_1, ShiftCtrlEnum_SRA_1 : begin
          _zz_decode_RS3_4 = memory_SHIFT_RIGHT;
        end
        default : begin
        end
      endcase
    end
    if(when_CG6_l489) begin
      _zz_decode_RS3_4 = memory_CG6_FINAL_OUTPUT;
    end
  end

  assign memory_SHIFT_CTRL = _zz_memory_SHIFT_CTRL;
  assign execute_SHIFT_CTRL = _zz_execute_SHIFT_CTRL;
  assign execute_SRC_LESS_UNSIGNED = decode_to_execute_SRC_LESS_UNSIGNED;
  assign execute_SRC2_FORCE_ZERO = decode_to_execute_SRC2_FORCE_ZERO;
  assign execute_SRC_USE_SUB_LESS = decode_to_execute_SRC_USE_SUB_LESS;
  assign execute_SRC3_CTRL = _zz_execute_SRC3_CTRL;
  assign _zz_execute_SRC2 = execute_PC;
  assign execute_SRC2_CTRL = _zz_execute_SRC2_CTRL;
  assign execute_SRC1_CTRL = _zz_execute_SRC1_CTRL;
  assign decode_SRC_USE_SUB_LESS = _zz_decode_REGFILE_WRITE_VALID_ODD[3];
  assign decode_SRC_ADD_ZERO = _zz_decode_REGFILE_WRITE_VALID_ODD[21];
  assign execute_SRC_ADD_SUB = execute_SrcPlugin_addSub;
  assign execute_SRC_LESS = execute_SrcPlugin_less;
  assign execute_ALU_CTRL = _zz_execute_ALU_CTRL;
  assign execute_SRC2 = _zz_execute_SRC2_5;
  assign execute_SRC1 = _zz_execute_SRC1;
  assign execute_ALU_BITWISE_CTRL = _zz_execute_ALU_BITWISE_CTRL;
  assign _zz_lastStageRegFileWrite_valid = writeBack_REGFILE_WRITE_VALID;
  always @(*) begin
    _zz_1 = 1'b0;
    if(lastStageRegFileWrite_valid) begin
      _zz_1 = 1'b1;
    end
  end

  assign _zz_writeBack_RegFilePlugin_rdIndex = writeBack_INSTRUCTION;
  assign decode_INSTRUCTION_ANTICIPATED = (decode_arbitration_isStuck ? decode_INSTRUCTION : IBusCachedPlugin_cache_io_cpu_fetch_data);
  always @(*) begin
    decode_REGFILE_WRITE_VALID = _zz_decode_REGFILE_WRITE_VALID_ODD[10];
    if(when_RegFilePlugin_l67) begin
      decode_REGFILE_WRITE_VALID = 1'b0;
    end
  end

  always @(*) begin
    _zz_decode_RS3_5 = writeBack_REGFILE_WRITE_DATA;
    if(when_DBusCachedPlugin_l489) begin
      _zz_decode_RS3_5 = writeBack_DBusCachedPlugin_rspFormated;
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
  assign decode_MEMORY_ENABLE = _zz_decode_REGFILE_WRITE_VALID_ODD[4];
  assign decode_FLUSH_ALL = _zz_decode_REGFILE_WRITE_VALID_ODD[0];
  always @(*) begin
    IBusCachedPlugin_rsp_issueDetected_2 = IBusCachedPlugin_rsp_issueDetected_1;
    if(when_IBusCachedPlugin_l250) begin
      IBusCachedPlugin_rsp_issueDetected_2 = 1'b1;
    end
  end

  always @(*) begin
    IBusCachedPlugin_rsp_issueDetected_1 = IBusCachedPlugin_rsp_issueDetected;
    if(when_IBusCachedPlugin_l239) begin
      IBusCachedPlugin_rsp_issueDetected_1 = 1'b1;
    end
  end

  assign decode_BRANCH_CTRL = _zz_decode_BRANCH_CTRL_1;
  assign decode_INSTRUCTION = IBusCachedPlugin_iBusRsp_output_payload_rsp_inst;
  always @(*) begin
    _zz_memory_to_writeBack_FORMAL_PC_NEXT = memory_FORMAL_PC_NEXT;
    if(BranchPlugin_jumpInterface_valid) begin
      _zz_memory_to_writeBack_FORMAL_PC_NEXT = BranchPlugin_jumpInterface_payload;
    end
  end

  always @(*) begin
    _zz_decode_to_execute_FORMAL_PC_NEXT = decode_FORMAL_PC_NEXT;
    if(IBusCachedPlugin_predictionJumpInterface_valid) begin
      _zz_decode_to_execute_FORMAL_PC_NEXT = IBusCachedPlugin_predictionJumpInterface_payload;
    end
  end

  assign decode_PC = IBusCachedPlugin_iBusRsp_output_payload_pc;
  assign writeBack_PC = memory_to_writeBack_PC;
  assign writeBack_INSTRUCTION = memory_to_writeBack_INSTRUCTION;
  always @(*) begin
    decode_arbitration_haltItself = 1'b0;
    if(when_DBusCachedPlugin_l307) begin
      decode_arbitration_haltItself = 1'b1;
    end
  end

  always @(*) begin
    decode_arbitration_haltByOther = 1'b0;
    if(when_HazardSimplePlugin_l158) begin
      decode_arbitration_haltByOther = 1'b1;
    end
  end

  always @(*) begin
    decode_arbitration_removeIt = 1'b0;
    if(decode_arbitration_isFlushed) begin
      decode_arbitration_removeIt = 1'b1;
    end
  end

  assign decode_arbitration_flushIt = 1'b0;
  always @(*) begin
    decode_arbitration_flushNext = 1'b0;
    if(IBusCachedPlugin_predictionJumpInterface_valid) begin
      decode_arbitration_flushNext = 1'b1;
    end
  end

  always @(*) begin
    execute_arbitration_haltItself = 1'b0;
    if(when_DBusCachedPlugin_l347) begin
      execute_arbitration_haltItself = 1'b1;
    end
  end

  always @(*) begin
    execute_arbitration_haltByOther = 1'b0;
    if(when_DBusCachedPlugin_l363) begin
      execute_arbitration_haltByOther = 1'b1;
    end
  end

  always @(*) begin
    execute_arbitration_removeIt = 1'b0;
    if(execute_arbitration_isFlushed) begin
      execute_arbitration_removeIt = 1'b1;
    end
  end

  assign execute_arbitration_flushIt = 1'b0;
  assign execute_arbitration_flushNext = 1'b0;
  assign memory_arbitration_haltItself = 1'b0;
  assign memory_arbitration_haltByOther = 1'b0;
  always @(*) begin
    memory_arbitration_removeIt = 1'b0;
    if(memory_arbitration_isFlushed) begin
      memory_arbitration_removeIt = 1'b1;
    end
  end

  assign memory_arbitration_flushIt = 1'b0;
  always @(*) begin
    memory_arbitration_flushNext = 1'b0;
    if(BranchPlugin_jumpInterface_valid) begin
      memory_arbitration_flushNext = 1'b1;
    end
  end

  always @(*) begin
    writeBack_arbitration_haltItself = 1'b0;
    if(when_DBusCachedPlugin_l463) begin
      writeBack_arbitration_haltItself = 1'b1;
    end
  end

  assign writeBack_arbitration_haltByOther = 1'b0;
  always @(*) begin
    writeBack_arbitration_removeIt = 1'b0;
    if(writeBack_arbitration_isFlushed) begin
      writeBack_arbitration_removeIt = 1'b1;
    end
  end

  always @(*) begin
    writeBack_arbitration_flushIt = 1'b0;
    if(DBusCachedPlugin_redoBranch_valid) begin
      writeBack_arbitration_flushIt = 1'b1;
    end
  end

  always @(*) begin
    writeBack_arbitration_flushNext = 1'b0;
    if(DBusCachedPlugin_redoBranch_valid) begin
      writeBack_arbitration_flushNext = 1'b1;
    end
  end

  assign lastStageInstruction = writeBack_INSTRUCTION;
  assign lastStagePc = writeBack_PC;
  assign lastStageIsValid = writeBack_arbitration_isValid;
  assign lastStageIsFiring = writeBack_arbitration_isFiring;
  assign IBusCachedPlugin_fetcherHalt = 1'b0;
  assign IBusCachedPlugin_forceNoDecodeCond = 1'b0;
  always @(*) begin
    IBusCachedPlugin_incomingInstruction = 1'b0;
    if(when_Fetcher_l243) begin
      IBusCachedPlugin_incomingInstruction = 1'b1;
    end
  end

  assign BranchPlugin_inDebugNoFetchFlag = 1'b0;
  assign IBusCachedPlugin_externalFlush = ({writeBack_arbitration_flushNext,{memory_arbitration_flushNext,{execute_arbitration_flushNext,decode_arbitration_flushNext}}} != 4'b0000);
  assign IBusCachedPlugin_jump_pcLoad_valid = ({BranchPlugin_jumpInterface_valid,{DBusCachedPlugin_redoBranch_valid,IBusCachedPlugin_predictionJumpInterface_valid}} != 3'b000);
  assign _zz_IBusCachedPlugin_jump_pcLoad_payload = {IBusCachedPlugin_predictionJumpInterface_valid,{BranchPlugin_jumpInterface_valid,DBusCachedPlugin_redoBranch_valid}};
  assign _zz_IBusCachedPlugin_jump_pcLoad_payload_1 = (_zz_IBusCachedPlugin_jump_pcLoad_payload & (~ _zz__zz_IBusCachedPlugin_jump_pcLoad_payload_1));
  assign _zz_IBusCachedPlugin_jump_pcLoad_payload_2 = _zz_IBusCachedPlugin_jump_pcLoad_payload_1[1];
  assign _zz_IBusCachedPlugin_jump_pcLoad_payload_3 = _zz_IBusCachedPlugin_jump_pcLoad_payload_1[2];
  assign IBusCachedPlugin_jump_pcLoad_payload = _zz_IBusCachedPlugin_jump_pcLoad_payload_4;
  always @(*) begin
    IBusCachedPlugin_fetchPc_correction = 1'b0;
    if(IBusCachedPlugin_fetchPc_redo_valid) begin
      IBusCachedPlugin_fetchPc_correction = 1'b1;
    end
    if(IBusCachedPlugin_jump_pcLoad_valid) begin
      IBusCachedPlugin_fetchPc_correction = 1'b1;
    end
  end

  assign IBusCachedPlugin_fetchPc_output_fire = (IBusCachedPlugin_fetchPc_output_valid && IBusCachedPlugin_fetchPc_output_ready);
  assign IBusCachedPlugin_fetchPc_corrected = (IBusCachedPlugin_fetchPc_correction || IBusCachedPlugin_fetchPc_correctionReg);
  always @(*) begin
    IBusCachedPlugin_fetchPc_pcRegPropagate = 1'b0;
    if(IBusCachedPlugin_iBusRsp_stages_1_input_ready) begin
      IBusCachedPlugin_fetchPc_pcRegPropagate = 1'b1;
    end
  end

  assign when_Fetcher_l134 = (IBusCachedPlugin_fetchPc_correction || IBusCachedPlugin_fetchPc_pcRegPropagate);
  assign IBusCachedPlugin_fetchPc_output_fire_1 = (IBusCachedPlugin_fetchPc_output_valid && IBusCachedPlugin_fetchPc_output_ready);
  assign when_Fetcher_l134_1 = ((! IBusCachedPlugin_fetchPc_output_valid) && IBusCachedPlugin_fetchPc_output_ready);
  always @(*) begin
    IBusCachedPlugin_fetchPc_pc = (IBusCachedPlugin_fetchPc_pcReg + _zz_IBusCachedPlugin_fetchPc_pc);
    if(IBusCachedPlugin_fetchPc_redo_valid) begin
      IBusCachedPlugin_fetchPc_pc = IBusCachedPlugin_fetchPc_redo_payload;
    end
    if(IBusCachedPlugin_jump_pcLoad_valid) begin
      IBusCachedPlugin_fetchPc_pc = IBusCachedPlugin_jump_pcLoad_payload;
    end
    IBusCachedPlugin_fetchPc_pc[0] = 1'b0;
    IBusCachedPlugin_fetchPc_pc[1] = 1'b0;
  end

  always @(*) begin
    IBusCachedPlugin_fetchPc_flushed = 1'b0;
    if(IBusCachedPlugin_fetchPc_redo_valid) begin
      IBusCachedPlugin_fetchPc_flushed = 1'b1;
    end
    if(IBusCachedPlugin_jump_pcLoad_valid) begin
      IBusCachedPlugin_fetchPc_flushed = 1'b1;
    end
  end

  assign when_Fetcher_l161 = (IBusCachedPlugin_fetchPc_booted && ((IBusCachedPlugin_fetchPc_output_ready || IBusCachedPlugin_fetchPc_correction) || IBusCachedPlugin_fetchPc_pcRegPropagate));
  assign IBusCachedPlugin_fetchPc_output_valid = ((! IBusCachedPlugin_fetcherHalt) && IBusCachedPlugin_fetchPc_booted);
  assign IBusCachedPlugin_fetchPc_output_payload = IBusCachedPlugin_fetchPc_pc;
  always @(*) begin
    IBusCachedPlugin_iBusRsp_redoFetch = 1'b0;
    if(IBusCachedPlugin_rsp_redoFetch) begin
      IBusCachedPlugin_iBusRsp_redoFetch = 1'b1;
    end
  end

  assign IBusCachedPlugin_iBusRsp_stages_0_input_valid = IBusCachedPlugin_fetchPc_output_valid;
  assign IBusCachedPlugin_fetchPc_output_ready = IBusCachedPlugin_iBusRsp_stages_0_input_ready;
  assign IBusCachedPlugin_iBusRsp_stages_0_input_payload = IBusCachedPlugin_fetchPc_output_payload;
  always @(*) begin
    IBusCachedPlugin_iBusRsp_stages_0_halt = 1'b0;
    if(IBusCachedPlugin_cache_io_cpu_prefetch_haltIt) begin
      IBusCachedPlugin_iBusRsp_stages_0_halt = 1'b1;
    end
  end

  assign _zz_IBusCachedPlugin_iBusRsp_stages_0_input_ready = (! IBusCachedPlugin_iBusRsp_stages_0_halt);
  assign IBusCachedPlugin_iBusRsp_stages_0_input_ready = (IBusCachedPlugin_iBusRsp_stages_0_output_ready && _zz_IBusCachedPlugin_iBusRsp_stages_0_input_ready);
  assign IBusCachedPlugin_iBusRsp_stages_0_output_valid = (IBusCachedPlugin_iBusRsp_stages_0_input_valid && _zz_IBusCachedPlugin_iBusRsp_stages_0_input_ready);
  assign IBusCachedPlugin_iBusRsp_stages_0_output_payload = IBusCachedPlugin_iBusRsp_stages_0_input_payload;
  always @(*) begin
    IBusCachedPlugin_iBusRsp_stages_1_halt = 1'b0;
    if(IBusCachedPlugin_mmuBus_busy) begin
      IBusCachedPlugin_iBusRsp_stages_1_halt = 1'b1;
    end
  end

  assign _zz_IBusCachedPlugin_iBusRsp_stages_1_input_ready = (! IBusCachedPlugin_iBusRsp_stages_1_halt);
  assign IBusCachedPlugin_iBusRsp_stages_1_input_ready = (IBusCachedPlugin_iBusRsp_stages_1_output_ready && _zz_IBusCachedPlugin_iBusRsp_stages_1_input_ready);
  assign IBusCachedPlugin_iBusRsp_stages_1_output_valid = (IBusCachedPlugin_iBusRsp_stages_1_input_valid && _zz_IBusCachedPlugin_iBusRsp_stages_1_input_ready);
  assign IBusCachedPlugin_iBusRsp_stages_1_output_payload = IBusCachedPlugin_iBusRsp_stages_1_input_payload;
  always @(*) begin
    IBusCachedPlugin_iBusRsp_stages_2_halt = 1'b0;
    if(when_IBusCachedPlugin_l267) begin
      IBusCachedPlugin_iBusRsp_stages_2_halt = 1'b1;
    end
  end

  assign _zz_IBusCachedPlugin_iBusRsp_stages_2_input_ready = (! IBusCachedPlugin_iBusRsp_stages_2_halt);
  assign IBusCachedPlugin_iBusRsp_stages_2_input_ready = (IBusCachedPlugin_iBusRsp_stages_2_output_ready && _zz_IBusCachedPlugin_iBusRsp_stages_2_input_ready);
  assign IBusCachedPlugin_iBusRsp_stages_2_output_valid = (IBusCachedPlugin_iBusRsp_stages_2_input_valid && _zz_IBusCachedPlugin_iBusRsp_stages_2_input_ready);
  assign IBusCachedPlugin_iBusRsp_stages_2_output_payload = IBusCachedPlugin_iBusRsp_stages_2_input_payload;
  assign IBusCachedPlugin_fetchPc_redo_valid = IBusCachedPlugin_iBusRsp_redoFetch;
  assign IBusCachedPlugin_fetchPc_redo_payload = IBusCachedPlugin_iBusRsp_stages_2_input_payload;
  assign IBusCachedPlugin_iBusRsp_flush = ((decode_arbitration_removeIt || (decode_arbitration_flushNext && (! decode_arbitration_isStuck))) || IBusCachedPlugin_iBusRsp_redoFetch);
  assign IBusCachedPlugin_iBusRsp_stages_0_output_ready = _zz_IBusCachedPlugin_iBusRsp_stages_0_output_ready;
  assign _zz_IBusCachedPlugin_iBusRsp_stages_0_output_ready = ((1'b0 && (! _zz_IBusCachedPlugin_iBusRsp_stages_0_output_ready_1)) || IBusCachedPlugin_iBusRsp_stages_1_input_ready);
  assign _zz_IBusCachedPlugin_iBusRsp_stages_0_output_ready_1 = _zz_IBusCachedPlugin_iBusRsp_stages_0_output_ready_2;
  assign IBusCachedPlugin_iBusRsp_stages_1_input_valid = _zz_IBusCachedPlugin_iBusRsp_stages_0_output_ready_1;
  assign IBusCachedPlugin_iBusRsp_stages_1_input_payload = IBusCachedPlugin_fetchPc_pcReg;
  assign IBusCachedPlugin_iBusRsp_stages_1_output_ready = ((1'b0 && (! IBusCachedPlugin_iBusRsp_stages_1_output_m2sPipe_valid)) || IBusCachedPlugin_iBusRsp_stages_1_output_m2sPipe_ready);
  assign IBusCachedPlugin_iBusRsp_stages_1_output_m2sPipe_valid = _zz_IBusCachedPlugin_iBusRsp_stages_1_output_m2sPipe_valid;
  assign IBusCachedPlugin_iBusRsp_stages_1_output_m2sPipe_payload = _zz_IBusCachedPlugin_iBusRsp_stages_1_output_m2sPipe_payload;
  assign IBusCachedPlugin_iBusRsp_stages_2_input_valid = IBusCachedPlugin_iBusRsp_stages_1_output_m2sPipe_valid;
  assign IBusCachedPlugin_iBusRsp_stages_1_output_m2sPipe_ready = IBusCachedPlugin_iBusRsp_stages_2_input_ready;
  assign IBusCachedPlugin_iBusRsp_stages_2_input_payload = IBusCachedPlugin_iBusRsp_stages_1_output_m2sPipe_payload;
  always @(*) begin
    IBusCachedPlugin_iBusRsp_readyForError = 1'b1;
    if(when_Fetcher_l323) begin
      IBusCachedPlugin_iBusRsp_readyForError = 1'b0;
    end
  end

  assign when_Fetcher_l243 = (IBusCachedPlugin_iBusRsp_stages_1_input_valid || IBusCachedPlugin_iBusRsp_stages_2_input_valid);
  assign when_Fetcher_l323 = (! IBusCachedPlugin_pcValids_0);
  assign when_Fetcher_l332 = (! (! IBusCachedPlugin_iBusRsp_stages_1_input_ready));
  assign when_Fetcher_l332_1 = (! (! IBusCachedPlugin_iBusRsp_stages_2_input_ready));
  assign when_Fetcher_l332_2 = (! execute_arbitration_isStuck);
  assign when_Fetcher_l332_3 = (! memory_arbitration_isStuck);
  assign when_Fetcher_l332_4 = (! writeBack_arbitration_isStuck);
  assign IBusCachedPlugin_pcValids_0 = IBusCachedPlugin_injector_nextPcCalc_valids_1;
  assign IBusCachedPlugin_pcValids_1 = IBusCachedPlugin_injector_nextPcCalc_valids_2;
  assign IBusCachedPlugin_pcValids_2 = IBusCachedPlugin_injector_nextPcCalc_valids_3;
  assign IBusCachedPlugin_pcValids_3 = IBusCachedPlugin_injector_nextPcCalc_valids_4;
  assign IBusCachedPlugin_iBusRsp_output_ready = (! decode_arbitration_isStuck);
  always @(*) begin
    decode_arbitration_isValid = IBusCachedPlugin_iBusRsp_output_valid;
    if(IBusCachedPlugin_forceNoDecodeCond) begin
      decode_arbitration_isValid = 1'b0;
    end
  end

  assign _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch = _zz__zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch[11];
  always @(*) begin
    _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch_1[18] = _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch;
    _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch_1[17] = _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch;
    _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch_1[16] = _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch;
    _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch_1[15] = _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch;
    _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch_1[14] = _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch;
    _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch_1[13] = _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch;
    _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch_1[12] = _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch;
    _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch_1[11] = _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch;
    _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch_1[10] = _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch;
    _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch_1[9] = _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch;
    _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch_1[8] = _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch;
    _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch_1[7] = _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch;
    _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch_1[6] = _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch;
    _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch_1[5] = _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch;
    _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch_1[4] = _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch;
    _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch_1[3] = _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch;
    _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch_1[2] = _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch;
    _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch_1[1] = _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch;
    _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch_1[0] = _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch;
  end

  always @(*) begin
    IBusCachedPlugin_decodePrediction_cmd_hadBranch = ((decode_BRANCH_CTRL == BranchCtrlEnum_JAL) || ((decode_BRANCH_CTRL == BranchCtrlEnum_B) && _zz_IBusCachedPlugin_decodePrediction_cmd_hadBranch_2[31]));
    if(_zz_6) begin
      IBusCachedPlugin_decodePrediction_cmd_hadBranch = 1'b0;
    end
  end

  assign _zz_2 = _zz__zz_2[19];
  always @(*) begin
    _zz_3[10] = _zz_2;
    _zz_3[9] = _zz_2;
    _zz_3[8] = _zz_2;
    _zz_3[7] = _zz_2;
    _zz_3[6] = _zz_2;
    _zz_3[5] = _zz_2;
    _zz_3[4] = _zz_2;
    _zz_3[3] = _zz_2;
    _zz_3[2] = _zz_2;
    _zz_3[1] = _zz_2;
    _zz_3[0] = _zz_2;
  end

  assign _zz_4 = _zz__zz_4[11];
  always @(*) begin
    _zz_5[18] = _zz_4;
    _zz_5[17] = _zz_4;
    _zz_5[16] = _zz_4;
    _zz_5[15] = _zz_4;
    _zz_5[14] = _zz_4;
    _zz_5[13] = _zz_4;
    _zz_5[12] = _zz_4;
    _zz_5[11] = _zz_4;
    _zz_5[10] = _zz_4;
    _zz_5[9] = _zz_4;
    _zz_5[8] = _zz_4;
    _zz_5[7] = _zz_4;
    _zz_5[6] = _zz_4;
    _zz_5[5] = _zz_4;
    _zz_5[4] = _zz_4;
    _zz_5[3] = _zz_4;
    _zz_5[2] = _zz_4;
    _zz_5[1] = _zz_4;
    _zz_5[0] = _zz_4;
  end

  always @(*) begin
    case(decode_BRANCH_CTRL)
      BranchCtrlEnum_JAL : begin
        _zz_6 = _zz__zz_6[1];
      end
      default : begin
        _zz_6 = _zz__zz_6_1[1];
      end
    endcase
  end

  assign IBusCachedPlugin_predictionJumpInterface_valid = (decode_arbitration_isValid && IBusCachedPlugin_decodePrediction_cmd_hadBranch);
  assign _zz_IBusCachedPlugin_predictionJumpInterface_payload = _zz__zz_IBusCachedPlugin_predictionJumpInterface_payload[19];
  always @(*) begin
    _zz_IBusCachedPlugin_predictionJumpInterface_payload_1[10] = _zz_IBusCachedPlugin_predictionJumpInterface_payload;
    _zz_IBusCachedPlugin_predictionJumpInterface_payload_1[9] = _zz_IBusCachedPlugin_predictionJumpInterface_payload;
    _zz_IBusCachedPlugin_predictionJumpInterface_payload_1[8] = _zz_IBusCachedPlugin_predictionJumpInterface_payload;
    _zz_IBusCachedPlugin_predictionJumpInterface_payload_1[7] = _zz_IBusCachedPlugin_predictionJumpInterface_payload;
    _zz_IBusCachedPlugin_predictionJumpInterface_payload_1[6] = _zz_IBusCachedPlugin_predictionJumpInterface_payload;
    _zz_IBusCachedPlugin_predictionJumpInterface_payload_1[5] = _zz_IBusCachedPlugin_predictionJumpInterface_payload;
    _zz_IBusCachedPlugin_predictionJumpInterface_payload_1[4] = _zz_IBusCachedPlugin_predictionJumpInterface_payload;
    _zz_IBusCachedPlugin_predictionJumpInterface_payload_1[3] = _zz_IBusCachedPlugin_predictionJumpInterface_payload;
    _zz_IBusCachedPlugin_predictionJumpInterface_payload_1[2] = _zz_IBusCachedPlugin_predictionJumpInterface_payload;
    _zz_IBusCachedPlugin_predictionJumpInterface_payload_1[1] = _zz_IBusCachedPlugin_predictionJumpInterface_payload;
    _zz_IBusCachedPlugin_predictionJumpInterface_payload_1[0] = _zz_IBusCachedPlugin_predictionJumpInterface_payload;
  end

  assign _zz_IBusCachedPlugin_predictionJumpInterface_payload_2 = _zz__zz_IBusCachedPlugin_predictionJumpInterface_payload_2[11];
  always @(*) begin
    _zz_IBusCachedPlugin_predictionJumpInterface_payload_3[18] = _zz_IBusCachedPlugin_predictionJumpInterface_payload_2;
    _zz_IBusCachedPlugin_predictionJumpInterface_payload_3[17] = _zz_IBusCachedPlugin_predictionJumpInterface_payload_2;
    _zz_IBusCachedPlugin_predictionJumpInterface_payload_3[16] = _zz_IBusCachedPlugin_predictionJumpInterface_payload_2;
    _zz_IBusCachedPlugin_predictionJumpInterface_payload_3[15] = _zz_IBusCachedPlugin_predictionJumpInterface_payload_2;
    _zz_IBusCachedPlugin_predictionJumpInterface_payload_3[14] = _zz_IBusCachedPlugin_predictionJumpInterface_payload_2;
    _zz_IBusCachedPlugin_predictionJumpInterface_payload_3[13] = _zz_IBusCachedPlugin_predictionJumpInterface_payload_2;
    _zz_IBusCachedPlugin_predictionJumpInterface_payload_3[12] = _zz_IBusCachedPlugin_predictionJumpInterface_payload_2;
    _zz_IBusCachedPlugin_predictionJumpInterface_payload_3[11] = _zz_IBusCachedPlugin_predictionJumpInterface_payload_2;
    _zz_IBusCachedPlugin_predictionJumpInterface_payload_3[10] = _zz_IBusCachedPlugin_predictionJumpInterface_payload_2;
    _zz_IBusCachedPlugin_predictionJumpInterface_payload_3[9] = _zz_IBusCachedPlugin_predictionJumpInterface_payload_2;
    _zz_IBusCachedPlugin_predictionJumpInterface_payload_3[8] = _zz_IBusCachedPlugin_predictionJumpInterface_payload_2;
    _zz_IBusCachedPlugin_predictionJumpInterface_payload_3[7] = _zz_IBusCachedPlugin_predictionJumpInterface_payload_2;
    _zz_IBusCachedPlugin_predictionJumpInterface_payload_3[6] = _zz_IBusCachedPlugin_predictionJumpInterface_payload_2;
    _zz_IBusCachedPlugin_predictionJumpInterface_payload_3[5] = _zz_IBusCachedPlugin_predictionJumpInterface_payload_2;
    _zz_IBusCachedPlugin_predictionJumpInterface_payload_3[4] = _zz_IBusCachedPlugin_predictionJumpInterface_payload_2;
    _zz_IBusCachedPlugin_predictionJumpInterface_payload_3[3] = _zz_IBusCachedPlugin_predictionJumpInterface_payload_2;
    _zz_IBusCachedPlugin_predictionJumpInterface_payload_3[2] = _zz_IBusCachedPlugin_predictionJumpInterface_payload_2;
    _zz_IBusCachedPlugin_predictionJumpInterface_payload_3[1] = _zz_IBusCachedPlugin_predictionJumpInterface_payload_2;
    _zz_IBusCachedPlugin_predictionJumpInterface_payload_3[0] = _zz_IBusCachedPlugin_predictionJumpInterface_payload_2;
  end

  assign IBusCachedPlugin_predictionJumpInterface_payload = (decode_PC + ((decode_BRANCH_CTRL == BranchCtrlEnum_JAL) ? {{_zz_IBusCachedPlugin_predictionJumpInterface_payload_1,{{{_zz_IBusCachedPlugin_predictionJumpInterface_payload_4,decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]}},1'b0} : {{_zz_IBusCachedPlugin_predictionJumpInterface_payload_3,{{{_zz_IBusCachedPlugin_predictionJumpInterface_payload_5,_zz_IBusCachedPlugin_predictionJumpInterface_payload_6},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0}));
  assign iBus_cmd_valid = IBusCachedPlugin_cache_io_mem_cmd_valid;
  always @(*) begin
    iBus_cmd_payload_address = IBusCachedPlugin_cache_io_mem_cmd_payload_address;
    iBus_cmd_payload_address = IBusCachedPlugin_cache_io_mem_cmd_payload_address;
  end

  assign iBus_cmd_payload_size = IBusCachedPlugin_cache_io_mem_cmd_payload_size;
  assign IBusCachedPlugin_s0_tightlyCoupledHit = 1'b0;
  assign IBusCachedPlugin_cache_io_cpu_prefetch_isValid = (IBusCachedPlugin_iBusRsp_stages_0_input_valid && (! IBusCachedPlugin_s0_tightlyCoupledHit));
  assign IBusCachedPlugin_cache_io_cpu_fetch_isValid = (IBusCachedPlugin_iBusRsp_stages_1_input_valid && (! IBusCachedPlugin_s1_tightlyCoupledHit));
  assign IBusCachedPlugin_cache_io_cpu_fetch_isStuck = (! IBusCachedPlugin_iBusRsp_stages_1_input_ready);
  assign IBusCachedPlugin_mmuBus_cmd_0_isValid = IBusCachedPlugin_cache_io_cpu_fetch_isValid;
  assign IBusCachedPlugin_mmuBus_cmd_0_isStuck = (! IBusCachedPlugin_iBusRsp_stages_1_input_ready);
  assign IBusCachedPlugin_mmuBus_cmd_0_virtualAddress = IBusCachedPlugin_iBusRsp_stages_1_input_payload;
  assign IBusCachedPlugin_mmuBus_cmd_0_bypassTranslation = 1'b0;
  assign IBusCachedPlugin_mmuBus_end = (IBusCachedPlugin_iBusRsp_stages_1_input_ready || IBusCachedPlugin_externalFlush);
  assign IBusCachedPlugin_cache_io_cpu_decode_isValid = (IBusCachedPlugin_iBusRsp_stages_2_input_valid && (! IBusCachedPlugin_s2_tightlyCoupledHit));
  assign IBusCachedPlugin_cache_io_cpu_decode_isStuck = (! IBusCachedPlugin_iBusRsp_stages_2_input_ready);
  assign IBusCachedPlugin_rsp_iBusRspOutputHalt = 1'b0;
  assign IBusCachedPlugin_rsp_issueDetected = 1'b0;
  always @(*) begin
    IBusCachedPlugin_rsp_redoFetch = 1'b0;
    if(when_IBusCachedPlugin_l239) begin
      IBusCachedPlugin_rsp_redoFetch = 1'b1;
    end
    if(when_IBusCachedPlugin_l250) begin
      IBusCachedPlugin_rsp_redoFetch = 1'b1;
    end
  end

  always @(*) begin
    IBusCachedPlugin_cache_io_cpu_fill_valid = (IBusCachedPlugin_rsp_redoFetch && (! IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling));
    if(when_IBusCachedPlugin_l250) begin
      IBusCachedPlugin_cache_io_cpu_fill_valid = 1'b1;
    end
  end

  assign when_IBusCachedPlugin_l239 = ((IBusCachedPlugin_cache_io_cpu_decode_isValid && IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling) && (! IBusCachedPlugin_rsp_issueDetected));
  assign when_IBusCachedPlugin_l250 = ((IBusCachedPlugin_cache_io_cpu_decode_isValid && IBusCachedPlugin_cache_io_cpu_decode_cacheMiss) && (! IBusCachedPlugin_rsp_issueDetected_1));
  assign when_IBusCachedPlugin_l267 = (IBusCachedPlugin_rsp_issueDetected_2 || IBusCachedPlugin_rsp_iBusRspOutputHalt);
  assign IBusCachedPlugin_iBusRsp_output_valid = IBusCachedPlugin_iBusRsp_stages_2_output_valid;
  assign IBusCachedPlugin_iBusRsp_stages_2_output_ready = IBusCachedPlugin_iBusRsp_output_ready;
  assign IBusCachedPlugin_iBusRsp_output_payload_rsp_inst = IBusCachedPlugin_cache_io_cpu_decode_data;
  assign IBusCachedPlugin_iBusRsp_output_payload_pc = IBusCachedPlugin_iBusRsp_stages_2_output_payload;
  assign IBusCachedPlugin_cache_io_flush = (decode_arbitration_isValid && decode_FLUSH_ALL);
  assign dataCache_1_io_mem_cmd_ready = (! dataCache_1_io_mem_cmd_rValid);
  assign dataCache_1_io_mem_cmd_s2mPipe_valid = (dataCache_1_io_mem_cmd_valid || dataCache_1_io_mem_cmd_rValid);
  assign dataCache_1_io_mem_cmd_s2mPipe_payload_wr = (dataCache_1_io_mem_cmd_rValid ? dataCache_1_io_mem_cmd_rData_wr : dataCache_1_io_mem_cmd_payload_wr);
  assign dataCache_1_io_mem_cmd_s2mPipe_payload_uncached = (dataCache_1_io_mem_cmd_rValid ? dataCache_1_io_mem_cmd_rData_uncached : dataCache_1_io_mem_cmd_payload_uncached);
  assign dataCache_1_io_mem_cmd_s2mPipe_payload_address = (dataCache_1_io_mem_cmd_rValid ? dataCache_1_io_mem_cmd_rData_address : dataCache_1_io_mem_cmd_payload_address);
  assign dataCache_1_io_mem_cmd_s2mPipe_payload_data = (dataCache_1_io_mem_cmd_rValid ? dataCache_1_io_mem_cmd_rData_data : dataCache_1_io_mem_cmd_payload_data);
  assign dataCache_1_io_mem_cmd_s2mPipe_payload_mask = (dataCache_1_io_mem_cmd_rValid ? dataCache_1_io_mem_cmd_rData_mask : dataCache_1_io_mem_cmd_payload_mask);
  assign dataCache_1_io_mem_cmd_s2mPipe_payload_size = (dataCache_1_io_mem_cmd_rValid ? dataCache_1_io_mem_cmd_rData_size : dataCache_1_io_mem_cmd_payload_size);
  assign dataCache_1_io_mem_cmd_s2mPipe_payload_last = (dataCache_1_io_mem_cmd_rValid ? dataCache_1_io_mem_cmd_rData_last : dataCache_1_io_mem_cmd_payload_last);
  assign dBus_cmd_valid = dataCache_1_io_mem_cmd_s2mPipe_valid;
  assign dataCache_1_io_mem_cmd_s2mPipe_ready = dBus_cmd_ready;
  assign dBus_cmd_payload_wr = dataCache_1_io_mem_cmd_s2mPipe_payload_wr;
  assign dBus_cmd_payload_uncached = dataCache_1_io_mem_cmd_s2mPipe_payload_uncached;
  assign dBus_cmd_payload_address = dataCache_1_io_mem_cmd_s2mPipe_payload_address;
  assign dBus_cmd_payload_data = dataCache_1_io_mem_cmd_s2mPipe_payload_data;
  assign dBus_cmd_payload_mask = dataCache_1_io_mem_cmd_s2mPipe_payload_mask;
  assign dBus_cmd_payload_size = dataCache_1_io_mem_cmd_s2mPipe_payload_size;
  assign dBus_cmd_payload_last = dataCache_1_io_mem_cmd_s2mPipe_payload_last;
  assign when_DBusCachedPlugin_l307 = ((DBusCachedPlugin_mmuBus_busy && decode_arbitration_isValid) && decode_MEMORY_ENABLE);
  assign execute_DBusCachedPlugin_size = execute_INSTRUCTION[13 : 12];
  assign dataCache_1_io_cpu_execute_isValid = (execute_arbitration_isValid && execute_MEMORY_ENABLE);
  assign dataCache_1_io_cpu_execute_address = execute_SRC_ADD;
  always @(*) begin
    case(execute_DBusCachedPlugin_size)
      2'b00 : begin
        _zz_execute_MEMORY_STORE_DATA_RF = {{{execute_RS2[7 : 0],execute_RS2[7 : 0]},execute_RS2[7 : 0]},execute_RS2[7 : 0]};
      end
      2'b01 : begin
        _zz_execute_MEMORY_STORE_DATA_RF = {execute_RS2[15 : 0],execute_RS2[15 : 0]};
      end
      default : begin
        _zz_execute_MEMORY_STORE_DATA_RF = execute_RS2[31 : 0];
      end
    endcase
  end

  assign dataCache_1_io_cpu_execute_args_size = {1'd0, execute_DBusCachedPlugin_size};
  assign dataCache_1_io_cpu_flush_valid = (execute_arbitration_isValid && execute_MEMORY_MANAGMENT);
  assign dataCache_1_io_cpu_flush_isStall = (dataCache_1_io_cpu_flush_valid && (! dataCache_1_io_cpu_flush_ready));
  assign when_DBusCachedPlugin_l347 = (dataCache_1_io_cpu_flush_isStall || dataCache_1_io_cpu_execute_haltIt);
  assign when_DBusCachedPlugin_l363 = (dataCache_1_io_cpu_execute_refilling && execute_arbitration_isValid);
  assign dataCache_1_io_cpu_memory_isValid = (memory_arbitration_isValid && memory_MEMORY_ENABLE);
  assign dataCache_1_io_cpu_memory_address = memory_REGFILE_WRITE_DATA;
  assign DBusCachedPlugin_mmuBus_cmd_0_isValid = dataCache_1_io_cpu_memory_isValid;
  assign DBusCachedPlugin_mmuBus_cmd_0_isStuck = memory_arbitration_isStuck;
  assign DBusCachedPlugin_mmuBus_cmd_0_virtualAddress = dataCache_1_io_cpu_memory_address;
  assign DBusCachedPlugin_mmuBus_cmd_0_bypassTranslation = 1'b0;
  assign DBusCachedPlugin_mmuBus_end = ((! memory_arbitration_isStuck) || memory_arbitration_removeIt);
  always @(*) begin
    dataCache_1_io_cpu_memory_mmuRsp_isIoAccess = DBusCachedPlugin_mmuBus_rsp_isIoAccess;
    if(when_DBusCachedPlugin_l390) begin
      dataCache_1_io_cpu_memory_mmuRsp_isIoAccess = 1'b1;
    end
  end

  assign when_DBusCachedPlugin_l390 = (1'b0 && (! dataCache_1_io_cpu_memory_isWrite));
  always @(*) begin
    dataCache_1_io_cpu_writeBack_isValid = (writeBack_arbitration_isValid && writeBack_MEMORY_ENABLE);
    if(writeBack_arbitration_haltByOther) begin
      dataCache_1_io_cpu_writeBack_isValid = 1'b0;
    end
  end

  assign dataCache_1_io_cpu_writeBack_address = writeBack_REGFILE_WRITE_DATA;
  always @(*) begin
    dataCache_1_io_cpu_writeBack_storeData[31 : 0] = writeBack_MEMORY_STORE_DATA_RF;
    dataCache_1_io_cpu_writeBack_storeData[63 : 32] = writeBack_MEMORY_STORE_DATA_RF;
    dataCache_1_io_cpu_writeBack_storeData[95 : 64] = writeBack_MEMORY_STORE_DATA_RF;
    dataCache_1_io_cpu_writeBack_storeData[127 : 96] = writeBack_MEMORY_STORE_DATA_RF;
  end

  always @(*) begin
    DBusCachedPlugin_redoBranch_valid = 1'b0;
    if(when_DBusCachedPlugin_l443) begin
      if(dataCache_1_io_cpu_redo) begin
        DBusCachedPlugin_redoBranch_valid = 1'b1;
      end
    end
  end

  assign DBusCachedPlugin_redoBranch_payload = writeBack_PC;
  assign when_DBusCachedPlugin_l443 = (writeBack_arbitration_isValid && writeBack_MEMORY_ENABLE);
  assign when_DBusCachedPlugin_l463 = (dataCache_1_io_cpu_writeBack_isValid && dataCache_1_io_cpu_writeBack_haltIt);
  assign writeBack_DBusCachedPlugin_rspSplits_0 = dataCache_1_io_cpu_writeBack_data[7 : 0];
  assign writeBack_DBusCachedPlugin_rspSplits_1 = dataCache_1_io_cpu_writeBack_data[15 : 8];
  assign writeBack_DBusCachedPlugin_rspSplits_2 = dataCache_1_io_cpu_writeBack_data[23 : 16];
  assign writeBack_DBusCachedPlugin_rspSplits_3 = dataCache_1_io_cpu_writeBack_data[31 : 24];
  assign writeBack_DBusCachedPlugin_rspSplits_4 = dataCache_1_io_cpu_writeBack_data[39 : 32];
  assign writeBack_DBusCachedPlugin_rspSplits_5 = dataCache_1_io_cpu_writeBack_data[47 : 40];
  assign writeBack_DBusCachedPlugin_rspSplits_6 = dataCache_1_io_cpu_writeBack_data[55 : 48];
  assign writeBack_DBusCachedPlugin_rspSplits_7 = dataCache_1_io_cpu_writeBack_data[63 : 56];
  assign writeBack_DBusCachedPlugin_rspSplits_8 = dataCache_1_io_cpu_writeBack_data[71 : 64];
  assign writeBack_DBusCachedPlugin_rspSplits_9 = dataCache_1_io_cpu_writeBack_data[79 : 72];
  assign writeBack_DBusCachedPlugin_rspSplits_10 = dataCache_1_io_cpu_writeBack_data[87 : 80];
  assign writeBack_DBusCachedPlugin_rspSplits_11 = dataCache_1_io_cpu_writeBack_data[95 : 88];
  assign writeBack_DBusCachedPlugin_rspSplits_12 = dataCache_1_io_cpu_writeBack_data[103 : 96];
  assign writeBack_DBusCachedPlugin_rspSplits_13 = dataCache_1_io_cpu_writeBack_data[111 : 104];
  assign writeBack_DBusCachedPlugin_rspSplits_14 = dataCache_1_io_cpu_writeBack_data[119 : 112];
  assign writeBack_DBusCachedPlugin_rspSplits_15 = dataCache_1_io_cpu_writeBack_data[127 : 120];
  always @(*) begin
    writeBack_DBusCachedPlugin_rspShifted[7 : 0] = _zz_writeBack_DBusCachedPlugin_rspShifted;
    writeBack_DBusCachedPlugin_rspShifted[15 : 8] = _zz_writeBack_DBusCachedPlugin_rspShifted_2;
    writeBack_DBusCachedPlugin_rspShifted[23 : 16] = _zz_writeBack_DBusCachedPlugin_rspShifted_4;
    writeBack_DBusCachedPlugin_rspShifted[31 : 24] = _zz_writeBack_DBusCachedPlugin_rspShifted_6;
    writeBack_DBusCachedPlugin_rspShifted[39 : 32] = _zz_writeBack_DBusCachedPlugin_rspShifted_8;
    writeBack_DBusCachedPlugin_rspShifted[47 : 40] = _zz_writeBack_DBusCachedPlugin_rspShifted_10;
    writeBack_DBusCachedPlugin_rspShifted[55 : 48] = _zz_writeBack_DBusCachedPlugin_rspShifted_12;
    writeBack_DBusCachedPlugin_rspShifted[63 : 56] = _zz_writeBack_DBusCachedPlugin_rspShifted_14;
    writeBack_DBusCachedPlugin_rspShifted[71 : 64] = writeBack_DBusCachedPlugin_rspSplits_8;
    writeBack_DBusCachedPlugin_rspShifted[79 : 72] = writeBack_DBusCachedPlugin_rspSplits_9;
    writeBack_DBusCachedPlugin_rspShifted[87 : 80] = writeBack_DBusCachedPlugin_rspSplits_10;
    writeBack_DBusCachedPlugin_rspShifted[95 : 88] = writeBack_DBusCachedPlugin_rspSplits_11;
    writeBack_DBusCachedPlugin_rspShifted[103 : 96] = writeBack_DBusCachedPlugin_rspSplits_12;
    writeBack_DBusCachedPlugin_rspShifted[111 : 104] = writeBack_DBusCachedPlugin_rspSplits_13;
    writeBack_DBusCachedPlugin_rspShifted[119 : 112] = writeBack_DBusCachedPlugin_rspSplits_14;
    writeBack_DBusCachedPlugin_rspShifted[127 : 120] = writeBack_DBusCachedPlugin_rspSplits_15;
  end

  assign writeBack_DBusCachedPlugin_rspRf = writeBack_DBusCachedPlugin_rspShifted[31 : 0];
  assign switch_Misc_l211 = writeBack_INSTRUCTION[13 : 12];
  assign _zz_writeBack_DBusCachedPlugin_rspFormated = (writeBack_DBusCachedPlugin_rspRf[7] && (! writeBack_INSTRUCTION[14]));
  always @(*) begin
    _zz_writeBack_DBusCachedPlugin_rspFormated_1[31] = _zz_writeBack_DBusCachedPlugin_rspFormated;
    _zz_writeBack_DBusCachedPlugin_rspFormated_1[30] = _zz_writeBack_DBusCachedPlugin_rspFormated;
    _zz_writeBack_DBusCachedPlugin_rspFormated_1[29] = _zz_writeBack_DBusCachedPlugin_rspFormated;
    _zz_writeBack_DBusCachedPlugin_rspFormated_1[28] = _zz_writeBack_DBusCachedPlugin_rspFormated;
    _zz_writeBack_DBusCachedPlugin_rspFormated_1[27] = _zz_writeBack_DBusCachedPlugin_rspFormated;
    _zz_writeBack_DBusCachedPlugin_rspFormated_1[26] = _zz_writeBack_DBusCachedPlugin_rspFormated;
    _zz_writeBack_DBusCachedPlugin_rspFormated_1[25] = _zz_writeBack_DBusCachedPlugin_rspFormated;
    _zz_writeBack_DBusCachedPlugin_rspFormated_1[24] = _zz_writeBack_DBusCachedPlugin_rspFormated;
    _zz_writeBack_DBusCachedPlugin_rspFormated_1[23] = _zz_writeBack_DBusCachedPlugin_rspFormated;
    _zz_writeBack_DBusCachedPlugin_rspFormated_1[22] = _zz_writeBack_DBusCachedPlugin_rspFormated;
    _zz_writeBack_DBusCachedPlugin_rspFormated_1[21] = _zz_writeBack_DBusCachedPlugin_rspFormated;
    _zz_writeBack_DBusCachedPlugin_rspFormated_1[20] = _zz_writeBack_DBusCachedPlugin_rspFormated;
    _zz_writeBack_DBusCachedPlugin_rspFormated_1[19] = _zz_writeBack_DBusCachedPlugin_rspFormated;
    _zz_writeBack_DBusCachedPlugin_rspFormated_1[18] = _zz_writeBack_DBusCachedPlugin_rspFormated;
    _zz_writeBack_DBusCachedPlugin_rspFormated_1[17] = _zz_writeBack_DBusCachedPlugin_rspFormated;
    _zz_writeBack_DBusCachedPlugin_rspFormated_1[16] = _zz_writeBack_DBusCachedPlugin_rspFormated;
    _zz_writeBack_DBusCachedPlugin_rspFormated_1[15] = _zz_writeBack_DBusCachedPlugin_rspFormated;
    _zz_writeBack_DBusCachedPlugin_rspFormated_1[14] = _zz_writeBack_DBusCachedPlugin_rspFormated;
    _zz_writeBack_DBusCachedPlugin_rspFormated_1[13] = _zz_writeBack_DBusCachedPlugin_rspFormated;
    _zz_writeBack_DBusCachedPlugin_rspFormated_1[12] = _zz_writeBack_DBusCachedPlugin_rspFormated;
    _zz_writeBack_DBusCachedPlugin_rspFormated_1[11] = _zz_writeBack_DBusCachedPlugin_rspFormated;
    _zz_writeBack_DBusCachedPlugin_rspFormated_1[10] = _zz_writeBack_DBusCachedPlugin_rspFormated;
    _zz_writeBack_DBusCachedPlugin_rspFormated_1[9] = _zz_writeBack_DBusCachedPlugin_rspFormated;
    _zz_writeBack_DBusCachedPlugin_rspFormated_1[8] = _zz_writeBack_DBusCachedPlugin_rspFormated;
    _zz_writeBack_DBusCachedPlugin_rspFormated_1[7 : 0] = writeBack_DBusCachedPlugin_rspRf[7 : 0];
  end

  assign _zz_writeBack_DBusCachedPlugin_rspFormated_2 = (writeBack_DBusCachedPlugin_rspRf[15] && (! writeBack_INSTRUCTION[14]));
  always @(*) begin
    _zz_writeBack_DBusCachedPlugin_rspFormated_3[31] = _zz_writeBack_DBusCachedPlugin_rspFormated_2;
    _zz_writeBack_DBusCachedPlugin_rspFormated_3[30] = _zz_writeBack_DBusCachedPlugin_rspFormated_2;
    _zz_writeBack_DBusCachedPlugin_rspFormated_3[29] = _zz_writeBack_DBusCachedPlugin_rspFormated_2;
    _zz_writeBack_DBusCachedPlugin_rspFormated_3[28] = _zz_writeBack_DBusCachedPlugin_rspFormated_2;
    _zz_writeBack_DBusCachedPlugin_rspFormated_3[27] = _zz_writeBack_DBusCachedPlugin_rspFormated_2;
    _zz_writeBack_DBusCachedPlugin_rspFormated_3[26] = _zz_writeBack_DBusCachedPlugin_rspFormated_2;
    _zz_writeBack_DBusCachedPlugin_rspFormated_3[25] = _zz_writeBack_DBusCachedPlugin_rspFormated_2;
    _zz_writeBack_DBusCachedPlugin_rspFormated_3[24] = _zz_writeBack_DBusCachedPlugin_rspFormated_2;
    _zz_writeBack_DBusCachedPlugin_rspFormated_3[23] = _zz_writeBack_DBusCachedPlugin_rspFormated_2;
    _zz_writeBack_DBusCachedPlugin_rspFormated_3[22] = _zz_writeBack_DBusCachedPlugin_rspFormated_2;
    _zz_writeBack_DBusCachedPlugin_rspFormated_3[21] = _zz_writeBack_DBusCachedPlugin_rspFormated_2;
    _zz_writeBack_DBusCachedPlugin_rspFormated_3[20] = _zz_writeBack_DBusCachedPlugin_rspFormated_2;
    _zz_writeBack_DBusCachedPlugin_rspFormated_3[19] = _zz_writeBack_DBusCachedPlugin_rspFormated_2;
    _zz_writeBack_DBusCachedPlugin_rspFormated_3[18] = _zz_writeBack_DBusCachedPlugin_rspFormated_2;
    _zz_writeBack_DBusCachedPlugin_rspFormated_3[17] = _zz_writeBack_DBusCachedPlugin_rspFormated_2;
    _zz_writeBack_DBusCachedPlugin_rspFormated_3[16] = _zz_writeBack_DBusCachedPlugin_rspFormated_2;
    _zz_writeBack_DBusCachedPlugin_rspFormated_3[15 : 0] = writeBack_DBusCachedPlugin_rspRf[15 : 0];
  end

  always @(*) begin
    case(switch_Misc_l211)
      2'b00 : begin
        writeBack_DBusCachedPlugin_rspFormated = _zz_writeBack_DBusCachedPlugin_rspFormated_1;
      end
      2'b01 : begin
        writeBack_DBusCachedPlugin_rspFormated = _zz_writeBack_DBusCachedPlugin_rspFormated_3;
      end
      default : begin
        writeBack_DBusCachedPlugin_rspFormated = writeBack_DBusCachedPlugin_rspRf;
      end
    endcase
  end

  assign when_DBusCachedPlugin_l489 = (writeBack_arbitration_isValid && writeBack_MEMORY_ENABLE);
  assign IBusCachedPlugin_mmuBus_rsp_physicalAddress = IBusCachedPlugin_mmuBus_cmd_0_virtualAddress;
  assign IBusCachedPlugin_mmuBus_rsp_allowRead = 1'b1;
  assign IBusCachedPlugin_mmuBus_rsp_allowWrite = 1'b1;
  assign IBusCachedPlugin_mmuBus_rsp_allowExecute = 1'b1;
  assign IBusCachedPlugin_mmuBus_rsp_isIoAccess = (((IBusCachedPlugin_mmuBus_rsp_physicalAddress[31 : 28] != 4'b1000) && (IBusCachedPlugin_mmuBus_rsp_physicalAddress[31 : 16] != 16'h0041)) && (IBusCachedPlugin_mmuBus_rsp_physicalAddress[31 : 16] != 16'h0042));
  assign IBusCachedPlugin_mmuBus_rsp_isPaging = 1'b0;
  assign IBusCachedPlugin_mmuBus_rsp_exception = 1'b0;
  assign IBusCachedPlugin_mmuBus_rsp_refilling = 1'b0;
  assign IBusCachedPlugin_mmuBus_busy = 1'b0;
  assign DBusCachedPlugin_mmuBus_rsp_physicalAddress = DBusCachedPlugin_mmuBus_cmd_0_virtualAddress;
  assign DBusCachedPlugin_mmuBus_rsp_allowRead = 1'b1;
  assign DBusCachedPlugin_mmuBus_rsp_allowWrite = 1'b1;
  assign DBusCachedPlugin_mmuBus_rsp_allowExecute = 1'b1;
  assign DBusCachedPlugin_mmuBus_rsp_isIoAccess = (((DBusCachedPlugin_mmuBus_rsp_physicalAddress[31 : 28] != 4'b1000) && (DBusCachedPlugin_mmuBus_rsp_physicalAddress[31 : 16] != 16'h0041)) && (DBusCachedPlugin_mmuBus_rsp_physicalAddress[31 : 16] != 16'h0042));
  assign DBusCachedPlugin_mmuBus_rsp_isPaging = 1'b0;
  assign DBusCachedPlugin_mmuBus_rsp_exception = 1'b0;
  assign DBusCachedPlugin_mmuBus_rsp_refilling = 1'b0;
  assign DBusCachedPlugin_mmuBus_busy = 1'b0;
  assign _zz_decode_REGFILE_WRITE_VALID_ODD_1 = ((decode_INSTRUCTION & 32'h00000044) == 32'h00000040);
  assign _zz_decode_REGFILE_WRITE_VALID_ODD_2 = ((decode_INSTRUCTION & 32'h00000018) == 32'h0);
  assign _zz_decode_REGFILE_WRITE_VALID_ODD_3 = ((decode_INSTRUCTION & 32'h00000004) == 32'h00000004);
  assign _zz_decode_REGFILE_WRITE_VALID_ODD_4 = ((decode_INSTRUCTION & 32'h00000070) == 32'h00000020);
  assign _zz_decode_REGFILE_WRITE_VALID_ODD_5 = ((decode_INSTRUCTION & 32'h00000048) == 32'h00000048);
  assign _zz_decode_REGFILE_WRITE_VALID_ODD_6 = ((decode_INSTRUCTION & 32'h00000010) == 32'h00000010);
  assign _zz_decode_REGFILE_WRITE_VALID_ODD_7 = ((decode_INSTRUCTION & 32'h04003014) == 32'h04001010);
  assign _zz_decode_REGFILE_WRITE_VALID_ODD_8 = ((decode_INSTRUCTION & 32'h04000000) == 32'h04000000);
  assign _zz_decode_REGFILE_WRITE_VALID_ODD = {1'b0,{(|{_zz_decode_REGFILE_WRITE_VALID_ODD_5,(_zz__zz_decode_REGFILE_WRITE_VALID_ODD == _zz__zz_decode_REGFILE_WRITE_VALID_ODD_1)}),{(|(_zz__zz_decode_REGFILE_WRITE_VALID_ODD_2 == _zz__zz_decode_REGFILE_WRITE_VALID_ODD_3)),{(|_zz__zz_decode_REGFILE_WRITE_VALID_ODD_4),{(|_zz__zz_decode_REGFILE_WRITE_VALID_ODD_5),{_zz__zz_decode_REGFILE_WRITE_VALID_ODD_6,{_zz__zz_decode_REGFILE_WRITE_VALID_ODD_7,_zz__zz_decode_REGFILE_WRITE_VALID_ODD_9}}}}}}};
  assign _zz_decode_SRC1_CTRL_2 = _zz_decode_REGFILE_WRITE_VALID_ODD[2 : 1];
  assign _zz_decode_SRC1_CTRL_1 = _zz_decode_SRC1_CTRL_2;
  assign _zz_decode_ALU_CTRL_2 = _zz_decode_REGFILE_WRITE_VALID_ODD[7 : 6];
  assign _zz_decode_ALU_CTRL_1 = _zz_decode_ALU_CTRL_2;
  assign _zz_decode_SRC2_CTRL_2 = _zz_decode_REGFILE_WRITE_VALID_ODD[9 : 8];
  assign _zz_decode_SRC2_CTRL_1 = _zz_decode_SRC2_CTRL_2;
  assign _zz_decode_SRC3_CTRL_2 = _zz_decode_REGFILE_WRITE_VALID_ODD[17 : 17];
  assign _zz_decode_SRC3_CTRL_1 = _zz_decode_SRC3_CTRL_2;
  assign _zz_decode_ALU_BITWISE_CTRL_2 = _zz_decode_REGFILE_WRITE_VALID_ODD[20 : 19];
  assign _zz_decode_ALU_BITWISE_CTRL_1 = _zz_decode_ALU_BITWISE_CTRL_2;
  assign _zz_decode_SHIFT_CTRL_2 = _zz_decode_REGFILE_WRITE_VALID_ODD[23 : 22];
  assign _zz_decode_SHIFT_CTRL_1 = _zz_decode_SHIFT_CTRL_2;
  assign _zz_decode_CG6Ctrl_2 = _zz_decode_REGFILE_WRITE_VALID_ODD[27 : 25];
  assign _zz_decode_CG6Ctrl_1 = _zz_decode_CG6Ctrl_2;
  assign _zz_decode_CG6Ctrlminmax_2 = _zz_decode_REGFILE_WRITE_VALID_ODD[28 : 28];
  assign _zz_decode_CG6Ctrlminmax_1 = _zz_decode_CG6Ctrlminmax_2;
  assign _zz_decode_CG6Ctrlsignextend_2 = _zz_decode_REGFILE_WRITE_VALID_ODD[29 : 29];
  assign _zz_decode_CG6Ctrlsignextend_1 = _zz_decode_CG6Ctrlsignextend_2;
  assign _zz_decode_CG6Ctrlternary_2 = _zz_decode_REGFILE_WRITE_VALID_ODD[32 : 31];
  assign _zz_decode_CG6Ctrlternary_1 = _zz_decode_CG6Ctrlternary_2;
  assign _zz_decode_BRANCH_CTRL_2 = _zz_decode_REGFILE_WRITE_VALID_ODD[34 : 33];
  assign _zz_decode_BRANCH_CTRL = _zz_decode_BRANCH_CTRL_2;
  assign when_RegFilePlugin_l67 = (decode_INSTRUCTION[11 : 7] == 5'h0);
  assign decode_RegFilePlugin_regFileReadAddress1 = decode_INSTRUCTION_ANTICIPATED[19 : 15];
  assign decode_RegFilePlugin_regFileReadAddress2 = decode_INSTRUCTION_ANTICIPATED[24 : 20];
  assign decode_RegFilePlugin_regFileReadAddress3 = ((decode_INSTRUCTION_ANTICIPATED[6 : 0] == 7'h77) ? decode_INSTRUCTION_ANTICIPATED[11 : 7] : decode_INSTRUCTION_ANTICIPATED[31 : 27]);
  assign decode_RegFilePlugin_rs1Data = _zz_RegFilePlugin_regFile_port0;
  assign decode_RegFilePlugin_rs2Data = _zz_RegFilePlugin_regFile_port1;
  assign decode_RegFilePlugin_rs3Data = _zz_RegFilePlugin_regFile_port2;
  assign writeBack_RegFilePlugin_rdIndex = _zz_writeBack_RegFilePlugin_rdIndex[11 : 7];
  always @(*) begin
    lastStageRegFileWrite_valid = (_zz_lastStageRegFileWrite_valid && writeBack_arbitration_isFiring);
    if(_zz_7) begin
      lastStageRegFileWrite_valid = 1'b1;
    end
  end

  always @(*) begin
    lastStageRegFileWrite_payload_address = writeBack_RegFilePlugin_rdIndex;
    if(_zz_7) begin
      lastStageRegFileWrite_payload_address = 5'h0;
    end
  end

  always @(*) begin
    lastStageRegFileWrite_payload_data = _zz_decode_RS3_5;
    if(_zz_7) begin
      lastStageRegFileWrite_payload_data = 32'h0;
    end
  end

  always @(*) begin
    case(execute_ALU_BITWISE_CTRL)
      AluBitwiseCtrlEnum_AND_1 : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 & execute_SRC2);
      end
      AluBitwiseCtrlEnum_OR_1 : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 | execute_SRC2);
      end
      default : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 ^ execute_SRC2);
      end
    endcase
  end

  always @(*) begin
    case(execute_ALU_CTRL)
      AluCtrlEnum_BITWISE : begin
        _zz_execute_REGFILE_WRITE_DATA = execute_IntAluPlugin_bitwise;
      end
      AluCtrlEnum_SLT_SLTU : begin
        _zz_execute_REGFILE_WRITE_DATA = {31'd0, _zz__zz_execute_REGFILE_WRITE_DATA};
      end
      default : begin
        _zz_execute_REGFILE_WRITE_DATA = execute_SRC_ADD_SUB;
      end
    endcase
  end

  always @(*) begin
    case(execute_SRC1_CTRL)
      Src1CtrlEnum_RS : begin
        _zz_execute_SRC1 = execute_RS1;
      end
      Src1CtrlEnum_PC_INCREMENT : begin
        _zz_execute_SRC1 = {29'd0, _zz__zz_execute_SRC1};
      end
      Src1CtrlEnum_IMU : begin
        _zz_execute_SRC1 = {execute_INSTRUCTION[31 : 12],12'h0};
      end
      default : begin
        _zz_execute_SRC1 = {27'd0, _zz__zz_execute_SRC1_1};
      end
    endcase
  end

  assign _zz_execute_SRC2_1 = execute_INSTRUCTION[31];
  always @(*) begin
    _zz_execute_SRC2_2[19] = _zz_execute_SRC2_1;
    _zz_execute_SRC2_2[18] = _zz_execute_SRC2_1;
    _zz_execute_SRC2_2[17] = _zz_execute_SRC2_1;
    _zz_execute_SRC2_2[16] = _zz_execute_SRC2_1;
    _zz_execute_SRC2_2[15] = _zz_execute_SRC2_1;
    _zz_execute_SRC2_2[14] = _zz_execute_SRC2_1;
    _zz_execute_SRC2_2[13] = _zz_execute_SRC2_1;
    _zz_execute_SRC2_2[12] = _zz_execute_SRC2_1;
    _zz_execute_SRC2_2[11] = _zz_execute_SRC2_1;
    _zz_execute_SRC2_2[10] = _zz_execute_SRC2_1;
    _zz_execute_SRC2_2[9] = _zz_execute_SRC2_1;
    _zz_execute_SRC2_2[8] = _zz_execute_SRC2_1;
    _zz_execute_SRC2_2[7] = _zz_execute_SRC2_1;
    _zz_execute_SRC2_2[6] = _zz_execute_SRC2_1;
    _zz_execute_SRC2_2[5] = _zz_execute_SRC2_1;
    _zz_execute_SRC2_2[4] = _zz_execute_SRC2_1;
    _zz_execute_SRC2_2[3] = _zz_execute_SRC2_1;
    _zz_execute_SRC2_2[2] = _zz_execute_SRC2_1;
    _zz_execute_SRC2_2[1] = _zz_execute_SRC2_1;
    _zz_execute_SRC2_2[0] = _zz_execute_SRC2_1;
  end

  assign _zz_execute_SRC2_3 = _zz__zz_execute_SRC2_3[11];
  always @(*) begin
    _zz_execute_SRC2_4[19] = _zz_execute_SRC2_3;
    _zz_execute_SRC2_4[18] = _zz_execute_SRC2_3;
    _zz_execute_SRC2_4[17] = _zz_execute_SRC2_3;
    _zz_execute_SRC2_4[16] = _zz_execute_SRC2_3;
    _zz_execute_SRC2_4[15] = _zz_execute_SRC2_3;
    _zz_execute_SRC2_4[14] = _zz_execute_SRC2_3;
    _zz_execute_SRC2_4[13] = _zz_execute_SRC2_3;
    _zz_execute_SRC2_4[12] = _zz_execute_SRC2_3;
    _zz_execute_SRC2_4[11] = _zz_execute_SRC2_3;
    _zz_execute_SRC2_4[10] = _zz_execute_SRC2_3;
    _zz_execute_SRC2_4[9] = _zz_execute_SRC2_3;
    _zz_execute_SRC2_4[8] = _zz_execute_SRC2_3;
    _zz_execute_SRC2_4[7] = _zz_execute_SRC2_3;
    _zz_execute_SRC2_4[6] = _zz_execute_SRC2_3;
    _zz_execute_SRC2_4[5] = _zz_execute_SRC2_3;
    _zz_execute_SRC2_4[4] = _zz_execute_SRC2_3;
    _zz_execute_SRC2_4[3] = _zz_execute_SRC2_3;
    _zz_execute_SRC2_4[2] = _zz_execute_SRC2_3;
    _zz_execute_SRC2_4[1] = _zz_execute_SRC2_3;
    _zz_execute_SRC2_4[0] = _zz_execute_SRC2_3;
  end

  always @(*) begin
    case(execute_SRC2_CTRL)
      Src2CtrlEnum_RS : begin
        _zz_execute_SRC2_5 = execute_RS2;
      end
      Src2CtrlEnum_IMI : begin
        _zz_execute_SRC2_5 = {_zz_execute_SRC2_2,execute_INSTRUCTION[31 : 20]};
      end
      Src2CtrlEnum_IMS : begin
        _zz_execute_SRC2_5 = {_zz_execute_SRC2_4,{execute_INSTRUCTION[31 : 25],execute_INSTRUCTION[11 : 7]}};
      end
      default : begin
        _zz_execute_SRC2_5 = _zz_execute_SRC2;
      end
    endcase
  end

  assign _zz_execute_SRC3 = execute_INSTRUCTION[31];
  always @(*) begin
    _zz_execute_SRC3_1[19] = _zz_execute_SRC3;
    _zz_execute_SRC3_1[18] = _zz_execute_SRC3;
    _zz_execute_SRC3_1[17] = _zz_execute_SRC3;
    _zz_execute_SRC3_1[16] = _zz_execute_SRC3;
    _zz_execute_SRC3_1[15] = _zz_execute_SRC3;
    _zz_execute_SRC3_1[14] = _zz_execute_SRC3;
    _zz_execute_SRC3_1[13] = _zz_execute_SRC3;
    _zz_execute_SRC3_1[12] = _zz_execute_SRC3;
    _zz_execute_SRC3_1[11] = _zz_execute_SRC3;
    _zz_execute_SRC3_1[10] = _zz_execute_SRC3;
    _zz_execute_SRC3_1[9] = _zz_execute_SRC3;
    _zz_execute_SRC3_1[8] = _zz_execute_SRC3;
    _zz_execute_SRC3_1[7] = _zz_execute_SRC3;
    _zz_execute_SRC3_1[6] = _zz_execute_SRC3;
    _zz_execute_SRC3_1[5] = _zz_execute_SRC3;
    _zz_execute_SRC3_1[4] = _zz_execute_SRC3;
    _zz_execute_SRC3_1[3] = _zz_execute_SRC3;
    _zz_execute_SRC3_1[2] = _zz_execute_SRC3;
    _zz_execute_SRC3_1[1] = _zz_execute_SRC3;
    _zz_execute_SRC3_1[0] = _zz_execute_SRC3;
  end

  always @(*) begin
    case(execute_SRC3_CTRL)
      Src3CtrlEnum_RS : begin
        _zz_execute_SRC3_2 = execute_RS3;
      end
      default : begin
        _zz_execute_SRC3_2 = {_zz_execute_SRC3_1,execute_INSTRUCTION[31 : 20]};
      end
    endcase
  end

  always @(*) begin
    execute_SrcPlugin_addSub = _zz_execute_SrcPlugin_addSub;
    if(execute_SRC2_FORCE_ZERO) begin
      execute_SrcPlugin_addSub = execute_SRC1;
    end
  end

  assign execute_SrcPlugin_less = ((execute_SRC1[31] == execute_SRC2[31]) ? execute_SrcPlugin_addSub[31] : (execute_SRC_LESS_UNSIGNED ? execute_SRC2[31] : execute_SRC1[31]));
  assign execute_FullBarrelShifterPlugin_amplitude = execute_SRC2[4 : 0];
  always @(*) begin
    _zz_execute_FullBarrelShifterPlugin_reversed[0] = execute_SRC1[31];
    _zz_execute_FullBarrelShifterPlugin_reversed[1] = execute_SRC1[30];
    _zz_execute_FullBarrelShifterPlugin_reversed[2] = execute_SRC1[29];
    _zz_execute_FullBarrelShifterPlugin_reversed[3] = execute_SRC1[28];
    _zz_execute_FullBarrelShifterPlugin_reversed[4] = execute_SRC1[27];
    _zz_execute_FullBarrelShifterPlugin_reversed[5] = execute_SRC1[26];
    _zz_execute_FullBarrelShifterPlugin_reversed[6] = execute_SRC1[25];
    _zz_execute_FullBarrelShifterPlugin_reversed[7] = execute_SRC1[24];
    _zz_execute_FullBarrelShifterPlugin_reversed[8] = execute_SRC1[23];
    _zz_execute_FullBarrelShifterPlugin_reversed[9] = execute_SRC1[22];
    _zz_execute_FullBarrelShifterPlugin_reversed[10] = execute_SRC1[21];
    _zz_execute_FullBarrelShifterPlugin_reversed[11] = execute_SRC1[20];
    _zz_execute_FullBarrelShifterPlugin_reversed[12] = execute_SRC1[19];
    _zz_execute_FullBarrelShifterPlugin_reversed[13] = execute_SRC1[18];
    _zz_execute_FullBarrelShifterPlugin_reversed[14] = execute_SRC1[17];
    _zz_execute_FullBarrelShifterPlugin_reversed[15] = execute_SRC1[16];
    _zz_execute_FullBarrelShifterPlugin_reversed[16] = execute_SRC1[15];
    _zz_execute_FullBarrelShifterPlugin_reversed[17] = execute_SRC1[14];
    _zz_execute_FullBarrelShifterPlugin_reversed[18] = execute_SRC1[13];
    _zz_execute_FullBarrelShifterPlugin_reversed[19] = execute_SRC1[12];
    _zz_execute_FullBarrelShifterPlugin_reversed[20] = execute_SRC1[11];
    _zz_execute_FullBarrelShifterPlugin_reversed[21] = execute_SRC1[10];
    _zz_execute_FullBarrelShifterPlugin_reversed[22] = execute_SRC1[9];
    _zz_execute_FullBarrelShifterPlugin_reversed[23] = execute_SRC1[8];
    _zz_execute_FullBarrelShifterPlugin_reversed[24] = execute_SRC1[7];
    _zz_execute_FullBarrelShifterPlugin_reversed[25] = execute_SRC1[6];
    _zz_execute_FullBarrelShifterPlugin_reversed[26] = execute_SRC1[5];
    _zz_execute_FullBarrelShifterPlugin_reversed[27] = execute_SRC1[4];
    _zz_execute_FullBarrelShifterPlugin_reversed[28] = execute_SRC1[3];
    _zz_execute_FullBarrelShifterPlugin_reversed[29] = execute_SRC1[2];
    _zz_execute_FullBarrelShifterPlugin_reversed[30] = execute_SRC1[1];
    _zz_execute_FullBarrelShifterPlugin_reversed[31] = execute_SRC1[0];
  end

  assign execute_FullBarrelShifterPlugin_reversed = ((execute_SHIFT_CTRL == ShiftCtrlEnum_SLL_1) ? _zz_execute_FullBarrelShifterPlugin_reversed : execute_SRC1);
  always @(*) begin
    _zz_decode_RS3_6[0] = memory_SHIFT_RIGHT[31];
    _zz_decode_RS3_6[1] = memory_SHIFT_RIGHT[30];
    _zz_decode_RS3_6[2] = memory_SHIFT_RIGHT[29];
    _zz_decode_RS3_6[3] = memory_SHIFT_RIGHT[28];
    _zz_decode_RS3_6[4] = memory_SHIFT_RIGHT[27];
    _zz_decode_RS3_6[5] = memory_SHIFT_RIGHT[26];
    _zz_decode_RS3_6[6] = memory_SHIFT_RIGHT[25];
    _zz_decode_RS3_6[7] = memory_SHIFT_RIGHT[24];
    _zz_decode_RS3_6[8] = memory_SHIFT_RIGHT[23];
    _zz_decode_RS3_6[9] = memory_SHIFT_RIGHT[22];
    _zz_decode_RS3_6[10] = memory_SHIFT_RIGHT[21];
    _zz_decode_RS3_6[11] = memory_SHIFT_RIGHT[20];
    _zz_decode_RS3_6[12] = memory_SHIFT_RIGHT[19];
    _zz_decode_RS3_6[13] = memory_SHIFT_RIGHT[18];
    _zz_decode_RS3_6[14] = memory_SHIFT_RIGHT[17];
    _zz_decode_RS3_6[15] = memory_SHIFT_RIGHT[16];
    _zz_decode_RS3_6[16] = memory_SHIFT_RIGHT[15];
    _zz_decode_RS3_6[17] = memory_SHIFT_RIGHT[14];
    _zz_decode_RS3_6[18] = memory_SHIFT_RIGHT[13];
    _zz_decode_RS3_6[19] = memory_SHIFT_RIGHT[12];
    _zz_decode_RS3_6[20] = memory_SHIFT_RIGHT[11];
    _zz_decode_RS3_6[21] = memory_SHIFT_RIGHT[10];
    _zz_decode_RS3_6[22] = memory_SHIFT_RIGHT[9];
    _zz_decode_RS3_6[23] = memory_SHIFT_RIGHT[8];
    _zz_decode_RS3_6[24] = memory_SHIFT_RIGHT[7];
    _zz_decode_RS3_6[25] = memory_SHIFT_RIGHT[6];
    _zz_decode_RS3_6[26] = memory_SHIFT_RIGHT[5];
    _zz_decode_RS3_6[27] = memory_SHIFT_RIGHT[4];
    _zz_decode_RS3_6[28] = memory_SHIFT_RIGHT[3];
    _zz_decode_RS3_6[29] = memory_SHIFT_RIGHT[2];
    _zz_decode_RS3_6[30] = memory_SHIFT_RIGHT[1];
    _zz_decode_RS3_6[31] = memory_SHIFT_RIGHT[0];
  end

  always @(*) begin
    case(execute_CG6Ctrlminmax)
      CG6CtrlminmaxEnum_CTRL_MAXU : begin
        execute_CG6Plugin_val_minmax = ((execute_SRC2 < execute_SRC1) ? execute_SRC1 : execute_SRC2);
      end
      default : begin
        execute_CG6Plugin_val_minmax = ((execute_SRC1 < execute_SRC2) ? execute_SRC1 : execute_SRC2);
      end
    endcase
  end

  always @(*) begin
    case(execute_CG6Ctrlsignextend)
      CG6CtrlsignextendEnum_CTRL_SEXTdotB : begin
        execute_CG6Plugin_val_signextend = {(execute_SRC1[7] ? 24'hffffff : 24'h0),execute_SRC1[7 : 0]};
      end
      default : begin
        execute_CG6Plugin_val_signextend = {16'h0,execute_SRC1[15 : 0]};
      end
    endcase
  end

  assign _zz_execute_CG6Plugin_val_ternary = (execute_SRC2 & 32'h0000003f);
  assign _zz_execute_CG6Plugin_val_ternary_1 = ((32'h00000020 <= _zz_execute_CG6Plugin_val_ternary) ? _zz__zz_execute_CG6Plugin_val_ternary_1 : _zz_execute_CG6Plugin_val_ternary);
  assign _zz_execute_CG6Plugin_val_ternary_2 = ((_zz_execute_CG6Plugin_val_ternary_1 == _zz_execute_CG6Plugin_val_ternary) ? execute_SRC1 : execute_SRC3);
  always @(*) begin
    case(execute_CG6Ctrlternary)
      CG6CtrlternaryEnum_CTRL_CMIX : begin
        execute_CG6Plugin_val_ternary = ((execute_SRC1 & execute_SRC2) | (execute_SRC3 & (~ execute_SRC2)));
      end
      CG6CtrlternaryEnum_CTRL_CMOV : begin
        execute_CG6Plugin_val_ternary = ((execute_SRC2 != 32'h0) ? execute_SRC1 : execute_SRC3);
      end
      default : begin
        execute_CG6Plugin_val_ternary = ((_zz_execute_CG6Plugin_val_ternary_1 == 32'h0) ? _zz_execute_CG6Plugin_val_ternary_2 : (_zz_execute_CG6Plugin_val_ternary_3 | _zz_execute_CG6Plugin_val_ternary_4));
      end
    endcase
  end

  always @(*) begin
    case(execute_CG6Ctrl)
      CG6CtrlEnum_CTRL_SH2ADD : begin
        _zz_execute_CG6_FINAL_OUTPUT = _zz__zz_execute_CG6_FINAL_OUTPUT;
      end
      CG6CtrlEnum_CTRL_minmax : begin
        _zz_execute_CG6_FINAL_OUTPUT = execute_CG6Plugin_val_minmax;
      end
      CG6CtrlEnum_CTRL_signextend : begin
        _zz_execute_CG6_FINAL_OUTPUT = execute_CG6Plugin_val_signextend;
      end
      CG6CtrlEnum_CTRL_ternary : begin
        _zz_execute_CG6_FINAL_OUTPUT = execute_CG6Plugin_val_ternary;
      end
      default : begin
        _zz_execute_CG6_FINAL_OUTPUT = {{{execute_SRC1[7 : 0],execute_SRC1[15 : 8]},execute_SRC1[23 : 16]},execute_SRC1[31 : 24]};
      end
    endcase
  end

  assign when_CG6_l489 = (memory_arbitration_isValid && memory_IS_CG6);
  always @(*) begin
    HazardSimplePlugin_src0Hazard = 1'b0;
    if(when_HazardSimplePlugin_l86) begin
      if(when_HazardSimplePlugin_l87) begin
        if(when_HazardSimplePlugin_l88) begin
          HazardSimplePlugin_src0Hazard = 1'b1;
        end
      end
    end
    if(when_HazardSimplePlugin_l86_1) begin
      if(when_HazardSimplePlugin_l87_1) begin
        if(when_HazardSimplePlugin_l88_1) begin
          HazardSimplePlugin_src0Hazard = 1'b1;
        end
      end
    end
    if(when_HazardSimplePlugin_l86_2) begin
      if(when_HazardSimplePlugin_l87_2) begin
        if(when_HazardSimplePlugin_l88_2) begin
          HazardSimplePlugin_src0Hazard = 1'b1;
        end
      end
    end
    if(when_HazardSimplePlugin_l147) begin
      HazardSimplePlugin_src0Hazard = 1'b0;
    end
  end

  always @(*) begin
    HazardSimplePlugin_src1Hazard = 1'b0;
    if(when_HazardSimplePlugin_l86) begin
      if(when_HazardSimplePlugin_l87) begin
        if(when_HazardSimplePlugin_l91) begin
          HazardSimplePlugin_src1Hazard = 1'b1;
        end
        if(when_HazardSimplePlugin_l94) begin
          HazardSimplePlugin_src1Hazard = 1'b1;
        end
      end
    end
    if(when_HazardSimplePlugin_l86_1) begin
      if(when_HazardSimplePlugin_l87_1) begin
        if(when_HazardSimplePlugin_l91_1) begin
          HazardSimplePlugin_src1Hazard = 1'b1;
        end
        if(when_HazardSimplePlugin_l94_1) begin
          HazardSimplePlugin_src1Hazard = 1'b1;
        end
      end
    end
    if(when_HazardSimplePlugin_l86_2) begin
      if(when_HazardSimplePlugin_l87_2) begin
        if(when_HazardSimplePlugin_l91_2) begin
          HazardSimplePlugin_src1Hazard = 1'b1;
        end
        if(when_HazardSimplePlugin_l94_2) begin
          HazardSimplePlugin_src1Hazard = 1'b1;
        end
      end
    end
    if(when_HazardSimplePlugin_l150) begin
      HazardSimplePlugin_src1Hazard = 1'b0;
    end
  end

  always @(*) begin
    HazardSimplePlugin_src2Hazard = 1'b0;
    if(when_HazardSimplePlugin_l153) begin
      HazardSimplePlugin_src2Hazard = 1'b0;
    end
  end

  assign HazardSimplePlugin_notAES = ((! ((_zz_writeBack_RegFilePlugin_rdIndex & 32'h3200707f) == 32'h32000033)) && (! ((_zz_writeBack_RegFilePlugin_rdIndex & 32'h3a00707f) == 32'h30000033)));
  assign HazardSimplePlugin_rdIndex = (HazardSimplePlugin_notAES ? _zz_writeBack_RegFilePlugin_rdIndex[11 : 7] : _zz_writeBack_RegFilePlugin_rdIndex[19 : 15]);
  assign HazardSimplePlugin_regFileReadAddress3 = ((decode_INSTRUCTION[6 : 0] == 7'h77) ? decode_INSTRUCTION[11 : 7] : decode_INSTRUCTION[31 : 27]);
  assign HazardSimplePlugin_writeBackWrites_valid = (_zz_lastStageRegFileWrite_valid && writeBack_arbitration_isFiring);
  assign HazardSimplePlugin_writeBackWrites_payload_address = HazardSimplePlugin_rdIndex;
  assign HazardSimplePlugin_writeBackWrites_payload_data = _zz_decode_RS3_5;
  assign HazardSimplePlugin_addr0Match = (HazardSimplePlugin_writeBackBuffer_payload_address == decode_INSTRUCTION[19 : 15]);
  assign HazardSimplePlugin_addr1Match = (HazardSimplePlugin_writeBackBuffer_payload_address == decode_INSTRUCTION[24 : 20]);
  assign HazardSimplePlugin_addr2Match = (HazardSimplePlugin_writeBackBuffer_payload_address == HazardSimplePlugin_regFileReadAddress3);
  assign _zz_when_HazardSimplePlugin_l74 = ((writeBack_INSTRUCTION & 32'he400707f) == 32'ha0000077);
  assign _zz_when_HazardSimplePlugin_l59 = (((! ((writeBack_INSTRUCTION & 32'h3200707f) == 32'h32000033)) && (! ((writeBack_INSTRUCTION & 32'h3a00707f) == 32'h30000033))) ? writeBack_INSTRUCTION[11 : 7] : writeBack_INSTRUCTION[19 : 15]);
  assign _zz_when_HazardSimplePlugin_l74_1 = (_zz_when_HazardSimplePlugin_l74 ? (_zz_when_HazardSimplePlugin_l59 ^ 5'h01) : 5'h0);
  assign _zz_when_HazardSimplePlugin_l65 = ((decode_INSTRUCTION[6 : 0] == 7'h77) ? decode_INSTRUCTION[11 : 7] : decode_INSTRUCTION[31 : 27]);
  assign when_HazardSimplePlugin_l58 = 1'b1;
  assign when_HazardSimplePlugin_l59 = ((_zz_when_HazardSimplePlugin_l59 != 5'h0) && (_zz_when_HazardSimplePlugin_l59 == decode_INSTRUCTION[19 : 15]));
  assign when_HazardSimplePlugin_l62 = ((_zz_when_HazardSimplePlugin_l59 != 5'h0) && (_zz_when_HazardSimplePlugin_l59 == decode_INSTRUCTION[24 : 20]));
  assign when_HazardSimplePlugin_l65 = ((_zz_when_HazardSimplePlugin_l59 != 5'h0) && (_zz_when_HazardSimplePlugin_l59 == _zz_when_HazardSimplePlugin_l65));
  assign when_HazardSimplePlugin_l74 = ((_zz_when_HazardSimplePlugin_l74_1 != 5'h0) && (_zz_when_HazardSimplePlugin_l74_1 == decode_INSTRUCTION[19 : 15]));
  assign when_HazardSimplePlugin_l77 = ((_zz_when_HazardSimplePlugin_l74_1 != 5'h0) && (_zz_when_HazardSimplePlugin_l74_1 == decode_INSTRUCTION[24 : 20]));
  assign when_HazardSimplePlugin_l80 = ((_zz_when_HazardSimplePlugin_l74_1 != 5'h0) && (_zz_when_HazardSimplePlugin_l74_1 == _zz_when_HazardSimplePlugin_l65));
  assign when_HazardSimplePlugin_l56 = (writeBack_arbitration_isValid && writeBack_REGFILE_WRITE_VALID);
  assign when_HazardSimplePlugin_l71 = ((writeBack_arbitration_isValid && _zz_when_HazardSimplePlugin_l74) && writeBack_REGFILE_WRITE_VALID_ODD);
  assign when_HazardSimplePlugin_l86 = (writeBack_arbitration_isValid && writeBack_REGFILE_WRITE_VALID);
  assign when_HazardSimplePlugin_l87 = (1'b0 || (! when_HazardSimplePlugin_l58));
  assign when_HazardSimplePlugin_l88 = (when_HazardSimplePlugin_l59 || when_HazardSimplePlugin_l74);
  assign when_HazardSimplePlugin_l91 = (when_HazardSimplePlugin_l62 || when_HazardSimplePlugin_l77);
  assign when_HazardSimplePlugin_l94 = (when_HazardSimplePlugin_l65 || when_HazardSimplePlugin_l80);
  assign _zz_when_HazardSimplePlugin_l74_2 = ((memory_INSTRUCTION & 32'he400707f) == 32'ha0000077);
  assign _zz_when_HazardSimplePlugin_l59_1 = (((! ((memory_INSTRUCTION & 32'h3200707f) == 32'h32000033)) && (! ((memory_INSTRUCTION & 32'h3a00707f) == 32'h30000033))) ? memory_INSTRUCTION[11 : 7] : memory_INSTRUCTION[19 : 15]);
  assign _zz_when_HazardSimplePlugin_l74_3 = (_zz_when_HazardSimplePlugin_l74_2 ? (_zz_when_HazardSimplePlugin_l59_1 ^ 5'h01) : 5'h0);
  assign _zz_when_HazardSimplePlugin_l65_1 = ((decode_INSTRUCTION[6 : 0] == 7'h77) ? decode_INSTRUCTION[11 : 7] : decode_INSTRUCTION[31 : 27]);
  assign when_HazardSimplePlugin_l59_1 = ((_zz_when_HazardSimplePlugin_l59_1 != 5'h0) && (_zz_when_HazardSimplePlugin_l59_1 == decode_INSTRUCTION[19 : 15]));
  assign when_HazardSimplePlugin_l62_1 = ((_zz_when_HazardSimplePlugin_l59_1 != 5'h0) && (_zz_when_HazardSimplePlugin_l59_1 == decode_INSTRUCTION[24 : 20]));
  assign when_HazardSimplePlugin_l65_1 = ((_zz_when_HazardSimplePlugin_l59_1 != 5'h0) && (_zz_when_HazardSimplePlugin_l59_1 == _zz_when_HazardSimplePlugin_l65_1));
  assign when_HazardSimplePlugin_l74_1 = ((_zz_when_HazardSimplePlugin_l74_3 != 5'h0) && (_zz_when_HazardSimplePlugin_l74_3 == decode_INSTRUCTION[19 : 15]));
  assign when_HazardSimplePlugin_l77_1 = ((_zz_when_HazardSimplePlugin_l74_3 != 5'h0) && (_zz_when_HazardSimplePlugin_l74_3 == decode_INSTRUCTION[24 : 20]));
  assign when_HazardSimplePlugin_l80_1 = ((_zz_when_HazardSimplePlugin_l74_3 != 5'h0) && (_zz_when_HazardSimplePlugin_l74_3 == _zz_when_HazardSimplePlugin_l65_1));
  assign when_HazardSimplePlugin_l56_1 = (memory_arbitration_isValid && memory_REGFILE_WRITE_VALID);
  assign when_HazardSimplePlugin_l71_1 = ((memory_arbitration_isValid && _zz_when_HazardSimplePlugin_l74_2) && memory_REGFILE_WRITE_VALID_ODD);
  assign when_HazardSimplePlugin_l86_1 = (memory_arbitration_isValid && memory_REGFILE_WRITE_VALID);
  assign when_HazardSimplePlugin_l87_1 = (1'b0 || (! memory_BYPASSABLE_MEMORY_STAGE));
  assign when_HazardSimplePlugin_l88_1 = (when_HazardSimplePlugin_l59_1 || when_HazardSimplePlugin_l74_1);
  assign when_HazardSimplePlugin_l91_1 = (when_HazardSimplePlugin_l62_1 || when_HazardSimplePlugin_l77_1);
  assign when_HazardSimplePlugin_l94_1 = (when_HazardSimplePlugin_l65_1 || when_HazardSimplePlugin_l80_1);
  assign _zz_when_HazardSimplePlugin_l74_4 = ((execute_INSTRUCTION & 32'he400707f) == 32'ha0000077);
  assign _zz_when_HazardSimplePlugin_l59_2 = (((! ((execute_INSTRUCTION & 32'h3200707f) == 32'h32000033)) && (! ((execute_INSTRUCTION & 32'h3a00707f) == 32'h30000033))) ? execute_INSTRUCTION[11 : 7] : execute_INSTRUCTION[19 : 15]);
  assign _zz_when_HazardSimplePlugin_l74_5 = (_zz_when_HazardSimplePlugin_l74_4 ? (_zz_when_HazardSimplePlugin_l59_2 ^ 5'h01) : 5'h0);
  assign _zz_when_HazardSimplePlugin_l65_2 = ((decode_INSTRUCTION[6 : 0] == 7'h77) ? decode_INSTRUCTION[11 : 7] : decode_INSTRUCTION[31 : 27]);
  assign when_HazardSimplePlugin_l59_2 = ((_zz_when_HazardSimplePlugin_l59_2 != 5'h0) && (_zz_when_HazardSimplePlugin_l59_2 == decode_INSTRUCTION[19 : 15]));
  assign when_HazardSimplePlugin_l62_2 = ((_zz_when_HazardSimplePlugin_l59_2 != 5'h0) && (_zz_when_HazardSimplePlugin_l59_2 == decode_INSTRUCTION[24 : 20]));
  assign when_HazardSimplePlugin_l65_2 = ((_zz_when_HazardSimplePlugin_l59_2 != 5'h0) && (_zz_when_HazardSimplePlugin_l59_2 == _zz_when_HazardSimplePlugin_l65_2));
  assign when_HazardSimplePlugin_l74_2 = ((_zz_when_HazardSimplePlugin_l74_5 != 5'h0) && (_zz_when_HazardSimplePlugin_l74_5 == decode_INSTRUCTION[19 : 15]));
  assign when_HazardSimplePlugin_l77_2 = ((_zz_when_HazardSimplePlugin_l74_5 != 5'h0) && (_zz_when_HazardSimplePlugin_l74_5 == decode_INSTRUCTION[24 : 20]));
  assign when_HazardSimplePlugin_l80_2 = ((_zz_when_HazardSimplePlugin_l74_5 != 5'h0) && (_zz_when_HazardSimplePlugin_l74_5 == _zz_when_HazardSimplePlugin_l65_2));
  assign when_HazardSimplePlugin_l56_2 = (execute_arbitration_isValid && execute_REGFILE_WRITE_VALID);
  assign when_HazardSimplePlugin_l71_2 = ((execute_arbitration_isValid && _zz_when_HazardSimplePlugin_l74_4) && execute_REGFILE_WRITE_VALID_ODD);
  assign when_HazardSimplePlugin_l86_2 = (execute_arbitration_isValid && execute_REGFILE_WRITE_VALID);
  assign when_HazardSimplePlugin_l87_2 = (1'b0 || (! execute_BYPASSABLE_EXECUTE_STAGE));
  assign when_HazardSimplePlugin_l88_2 = (when_HazardSimplePlugin_l59_2 || when_HazardSimplePlugin_l74_2);
  assign when_HazardSimplePlugin_l91_2 = (when_HazardSimplePlugin_l62_2 || when_HazardSimplePlugin_l77_2);
  assign when_HazardSimplePlugin_l94_2 = (when_HazardSimplePlugin_l65_2 || when_HazardSimplePlugin_l80_2);
  assign when_HazardSimplePlugin_l147 = (! decode_RS1_USE);
  assign when_HazardSimplePlugin_l150 = (! decode_RS2_USE);
  assign when_HazardSimplePlugin_l153 = (! decode_RS3_USE);
  assign when_HazardSimplePlugin_l158 = (decode_arbitration_isValid && ((HazardSimplePlugin_src0Hazard || HazardSimplePlugin_src1Hazard) || HazardSimplePlugin_src2Hazard));
  assign execute_BranchPlugin_eq = (execute_SRC1 == execute_SRC2);
  assign switch_Misc_l211_1 = execute_INSTRUCTION[14 : 12];
  always @(*) begin
    casez(switch_Misc_l211_1)
      3'b000 : begin
        _zz_execute_BRANCH_COND_RESULT = execute_BranchPlugin_eq;
      end
      3'b001 : begin
        _zz_execute_BRANCH_COND_RESULT = (! execute_BranchPlugin_eq);
      end
      3'b1?1 : begin
        _zz_execute_BRANCH_COND_RESULT = (! execute_SRC_LESS);
      end
      default : begin
        _zz_execute_BRANCH_COND_RESULT = execute_SRC_LESS;
      end
    endcase
  end

  always @(*) begin
    case(execute_BRANCH_CTRL)
      BranchCtrlEnum_INC : begin
        _zz_execute_BRANCH_COND_RESULT_1 = 1'b0;
      end
      BranchCtrlEnum_JAL : begin
        _zz_execute_BRANCH_COND_RESULT_1 = 1'b1;
      end
      BranchCtrlEnum_JALR : begin
        _zz_execute_BRANCH_COND_RESULT_1 = 1'b1;
      end
      default : begin
        _zz_execute_BRANCH_COND_RESULT_1 = _zz_execute_BRANCH_COND_RESULT;
      end
    endcase
  end

  assign _zz_execute_BranchPlugin_missAlignedTarget = execute_INSTRUCTION[31];
  always @(*) begin
    _zz_execute_BranchPlugin_missAlignedTarget_1[19] = _zz_execute_BranchPlugin_missAlignedTarget;
    _zz_execute_BranchPlugin_missAlignedTarget_1[18] = _zz_execute_BranchPlugin_missAlignedTarget;
    _zz_execute_BranchPlugin_missAlignedTarget_1[17] = _zz_execute_BranchPlugin_missAlignedTarget;
    _zz_execute_BranchPlugin_missAlignedTarget_1[16] = _zz_execute_BranchPlugin_missAlignedTarget;
    _zz_execute_BranchPlugin_missAlignedTarget_1[15] = _zz_execute_BranchPlugin_missAlignedTarget;
    _zz_execute_BranchPlugin_missAlignedTarget_1[14] = _zz_execute_BranchPlugin_missAlignedTarget;
    _zz_execute_BranchPlugin_missAlignedTarget_1[13] = _zz_execute_BranchPlugin_missAlignedTarget;
    _zz_execute_BranchPlugin_missAlignedTarget_1[12] = _zz_execute_BranchPlugin_missAlignedTarget;
    _zz_execute_BranchPlugin_missAlignedTarget_1[11] = _zz_execute_BranchPlugin_missAlignedTarget;
    _zz_execute_BranchPlugin_missAlignedTarget_1[10] = _zz_execute_BranchPlugin_missAlignedTarget;
    _zz_execute_BranchPlugin_missAlignedTarget_1[9] = _zz_execute_BranchPlugin_missAlignedTarget;
    _zz_execute_BranchPlugin_missAlignedTarget_1[8] = _zz_execute_BranchPlugin_missAlignedTarget;
    _zz_execute_BranchPlugin_missAlignedTarget_1[7] = _zz_execute_BranchPlugin_missAlignedTarget;
    _zz_execute_BranchPlugin_missAlignedTarget_1[6] = _zz_execute_BranchPlugin_missAlignedTarget;
    _zz_execute_BranchPlugin_missAlignedTarget_1[5] = _zz_execute_BranchPlugin_missAlignedTarget;
    _zz_execute_BranchPlugin_missAlignedTarget_1[4] = _zz_execute_BranchPlugin_missAlignedTarget;
    _zz_execute_BranchPlugin_missAlignedTarget_1[3] = _zz_execute_BranchPlugin_missAlignedTarget;
    _zz_execute_BranchPlugin_missAlignedTarget_1[2] = _zz_execute_BranchPlugin_missAlignedTarget;
    _zz_execute_BranchPlugin_missAlignedTarget_1[1] = _zz_execute_BranchPlugin_missAlignedTarget;
    _zz_execute_BranchPlugin_missAlignedTarget_1[0] = _zz_execute_BranchPlugin_missAlignedTarget;
  end

  assign _zz_execute_BranchPlugin_missAlignedTarget_2 = _zz__zz_execute_BranchPlugin_missAlignedTarget_2[19];
  always @(*) begin
    _zz_execute_BranchPlugin_missAlignedTarget_3[10] = _zz_execute_BranchPlugin_missAlignedTarget_2;
    _zz_execute_BranchPlugin_missAlignedTarget_3[9] = _zz_execute_BranchPlugin_missAlignedTarget_2;
    _zz_execute_BranchPlugin_missAlignedTarget_3[8] = _zz_execute_BranchPlugin_missAlignedTarget_2;
    _zz_execute_BranchPlugin_missAlignedTarget_3[7] = _zz_execute_BranchPlugin_missAlignedTarget_2;
    _zz_execute_BranchPlugin_missAlignedTarget_3[6] = _zz_execute_BranchPlugin_missAlignedTarget_2;
    _zz_execute_BranchPlugin_missAlignedTarget_3[5] = _zz_execute_BranchPlugin_missAlignedTarget_2;
    _zz_execute_BranchPlugin_missAlignedTarget_3[4] = _zz_execute_BranchPlugin_missAlignedTarget_2;
    _zz_execute_BranchPlugin_missAlignedTarget_3[3] = _zz_execute_BranchPlugin_missAlignedTarget_2;
    _zz_execute_BranchPlugin_missAlignedTarget_3[2] = _zz_execute_BranchPlugin_missAlignedTarget_2;
    _zz_execute_BranchPlugin_missAlignedTarget_3[1] = _zz_execute_BranchPlugin_missAlignedTarget_2;
    _zz_execute_BranchPlugin_missAlignedTarget_3[0] = _zz_execute_BranchPlugin_missAlignedTarget_2;
  end

  assign _zz_execute_BranchPlugin_missAlignedTarget_4 = _zz__zz_execute_BranchPlugin_missAlignedTarget_4[11];
  always @(*) begin
    _zz_execute_BranchPlugin_missAlignedTarget_5[18] = _zz_execute_BranchPlugin_missAlignedTarget_4;
    _zz_execute_BranchPlugin_missAlignedTarget_5[17] = _zz_execute_BranchPlugin_missAlignedTarget_4;
    _zz_execute_BranchPlugin_missAlignedTarget_5[16] = _zz_execute_BranchPlugin_missAlignedTarget_4;
    _zz_execute_BranchPlugin_missAlignedTarget_5[15] = _zz_execute_BranchPlugin_missAlignedTarget_4;
    _zz_execute_BranchPlugin_missAlignedTarget_5[14] = _zz_execute_BranchPlugin_missAlignedTarget_4;
    _zz_execute_BranchPlugin_missAlignedTarget_5[13] = _zz_execute_BranchPlugin_missAlignedTarget_4;
    _zz_execute_BranchPlugin_missAlignedTarget_5[12] = _zz_execute_BranchPlugin_missAlignedTarget_4;
    _zz_execute_BranchPlugin_missAlignedTarget_5[11] = _zz_execute_BranchPlugin_missAlignedTarget_4;
    _zz_execute_BranchPlugin_missAlignedTarget_5[10] = _zz_execute_BranchPlugin_missAlignedTarget_4;
    _zz_execute_BranchPlugin_missAlignedTarget_5[9] = _zz_execute_BranchPlugin_missAlignedTarget_4;
    _zz_execute_BranchPlugin_missAlignedTarget_5[8] = _zz_execute_BranchPlugin_missAlignedTarget_4;
    _zz_execute_BranchPlugin_missAlignedTarget_5[7] = _zz_execute_BranchPlugin_missAlignedTarget_4;
    _zz_execute_BranchPlugin_missAlignedTarget_5[6] = _zz_execute_BranchPlugin_missAlignedTarget_4;
    _zz_execute_BranchPlugin_missAlignedTarget_5[5] = _zz_execute_BranchPlugin_missAlignedTarget_4;
    _zz_execute_BranchPlugin_missAlignedTarget_5[4] = _zz_execute_BranchPlugin_missAlignedTarget_4;
    _zz_execute_BranchPlugin_missAlignedTarget_5[3] = _zz_execute_BranchPlugin_missAlignedTarget_4;
    _zz_execute_BranchPlugin_missAlignedTarget_5[2] = _zz_execute_BranchPlugin_missAlignedTarget_4;
    _zz_execute_BranchPlugin_missAlignedTarget_5[1] = _zz_execute_BranchPlugin_missAlignedTarget_4;
    _zz_execute_BranchPlugin_missAlignedTarget_5[0] = _zz_execute_BranchPlugin_missAlignedTarget_4;
  end

  always @(*) begin
    case(execute_BRANCH_CTRL)
      BranchCtrlEnum_JALR : begin
        _zz_execute_BranchPlugin_missAlignedTarget_6 = (_zz__zz_execute_BranchPlugin_missAlignedTarget_6[1] ^ execute_RS1[1]);
      end
      BranchCtrlEnum_JAL : begin
        _zz_execute_BranchPlugin_missAlignedTarget_6 = _zz__zz_execute_BranchPlugin_missAlignedTarget_6_1[1];
      end
      default : begin
        _zz_execute_BranchPlugin_missAlignedTarget_6 = _zz__zz_execute_BranchPlugin_missAlignedTarget_6_2[1];
      end
    endcase
  end

  assign execute_BranchPlugin_missAlignedTarget = (execute_BRANCH_COND_RESULT && _zz_execute_BranchPlugin_missAlignedTarget_6);
  always @(*) begin
    case(execute_BRANCH_CTRL)
      BranchCtrlEnum_JALR : begin
        execute_BranchPlugin_branch_src1 = execute_RS1;
      end
      default : begin
        execute_BranchPlugin_branch_src1 = execute_PC;
      end
    endcase
  end

  assign _zz_execute_BranchPlugin_branch_src2 = execute_INSTRUCTION[31];
  always @(*) begin
    _zz_execute_BranchPlugin_branch_src2_1[19] = _zz_execute_BranchPlugin_branch_src2;
    _zz_execute_BranchPlugin_branch_src2_1[18] = _zz_execute_BranchPlugin_branch_src2;
    _zz_execute_BranchPlugin_branch_src2_1[17] = _zz_execute_BranchPlugin_branch_src2;
    _zz_execute_BranchPlugin_branch_src2_1[16] = _zz_execute_BranchPlugin_branch_src2;
    _zz_execute_BranchPlugin_branch_src2_1[15] = _zz_execute_BranchPlugin_branch_src2;
    _zz_execute_BranchPlugin_branch_src2_1[14] = _zz_execute_BranchPlugin_branch_src2;
    _zz_execute_BranchPlugin_branch_src2_1[13] = _zz_execute_BranchPlugin_branch_src2;
    _zz_execute_BranchPlugin_branch_src2_1[12] = _zz_execute_BranchPlugin_branch_src2;
    _zz_execute_BranchPlugin_branch_src2_1[11] = _zz_execute_BranchPlugin_branch_src2;
    _zz_execute_BranchPlugin_branch_src2_1[10] = _zz_execute_BranchPlugin_branch_src2;
    _zz_execute_BranchPlugin_branch_src2_1[9] = _zz_execute_BranchPlugin_branch_src2;
    _zz_execute_BranchPlugin_branch_src2_1[8] = _zz_execute_BranchPlugin_branch_src2;
    _zz_execute_BranchPlugin_branch_src2_1[7] = _zz_execute_BranchPlugin_branch_src2;
    _zz_execute_BranchPlugin_branch_src2_1[6] = _zz_execute_BranchPlugin_branch_src2;
    _zz_execute_BranchPlugin_branch_src2_1[5] = _zz_execute_BranchPlugin_branch_src2;
    _zz_execute_BranchPlugin_branch_src2_1[4] = _zz_execute_BranchPlugin_branch_src2;
    _zz_execute_BranchPlugin_branch_src2_1[3] = _zz_execute_BranchPlugin_branch_src2;
    _zz_execute_BranchPlugin_branch_src2_1[2] = _zz_execute_BranchPlugin_branch_src2;
    _zz_execute_BranchPlugin_branch_src2_1[1] = _zz_execute_BranchPlugin_branch_src2;
    _zz_execute_BranchPlugin_branch_src2_1[0] = _zz_execute_BranchPlugin_branch_src2;
  end

  always @(*) begin
    case(execute_BRANCH_CTRL)
      BranchCtrlEnum_JALR : begin
        execute_BranchPlugin_branch_src2 = {_zz_execute_BranchPlugin_branch_src2_1,execute_INSTRUCTION[31 : 20]};
      end
      default : begin
        execute_BranchPlugin_branch_src2 = ((execute_BRANCH_CTRL == BranchCtrlEnum_JAL) ? {{_zz_execute_BranchPlugin_branch_src2_3,{{{_zz_execute_BranchPlugin_branch_src2_6,execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]}},1'b0} : {{_zz_execute_BranchPlugin_branch_src2_5,{{{_zz_execute_BranchPlugin_branch_src2_7,_zz_execute_BranchPlugin_branch_src2_8},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]}},1'b0});
        if(execute_PREDICTION_HAD_BRANCHED2) begin
          execute_BranchPlugin_branch_src2 = {29'd0, _zz_execute_BranchPlugin_branch_src2_9};
        end
      end
    endcase
  end

  assign _zz_execute_BranchPlugin_branch_src2_2 = _zz__zz_execute_BranchPlugin_branch_src2_2[19];
  always @(*) begin
    _zz_execute_BranchPlugin_branch_src2_3[10] = _zz_execute_BranchPlugin_branch_src2_2;
    _zz_execute_BranchPlugin_branch_src2_3[9] = _zz_execute_BranchPlugin_branch_src2_2;
    _zz_execute_BranchPlugin_branch_src2_3[8] = _zz_execute_BranchPlugin_branch_src2_2;
    _zz_execute_BranchPlugin_branch_src2_3[7] = _zz_execute_BranchPlugin_branch_src2_2;
    _zz_execute_BranchPlugin_branch_src2_3[6] = _zz_execute_BranchPlugin_branch_src2_2;
    _zz_execute_BranchPlugin_branch_src2_3[5] = _zz_execute_BranchPlugin_branch_src2_2;
    _zz_execute_BranchPlugin_branch_src2_3[4] = _zz_execute_BranchPlugin_branch_src2_2;
    _zz_execute_BranchPlugin_branch_src2_3[3] = _zz_execute_BranchPlugin_branch_src2_2;
    _zz_execute_BranchPlugin_branch_src2_3[2] = _zz_execute_BranchPlugin_branch_src2_2;
    _zz_execute_BranchPlugin_branch_src2_3[1] = _zz_execute_BranchPlugin_branch_src2_2;
    _zz_execute_BranchPlugin_branch_src2_3[0] = _zz_execute_BranchPlugin_branch_src2_2;
  end

  assign _zz_execute_BranchPlugin_branch_src2_4 = _zz__zz_execute_BranchPlugin_branch_src2_4[11];
  always @(*) begin
    _zz_execute_BranchPlugin_branch_src2_5[18] = _zz_execute_BranchPlugin_branch_src2_4;
    _zz_execute_BranchPlugin_branch_src2_5[17] = _zz_execute_BranchPlugin_branch_src2_4;
    _zz_execute_BranchPlugin_branch_src2_5[16] = _zz_execute_BranchPlugin_branch_src2_4;
    _zz_execute_BranchPlugin_branch_src2_5[15] = _zz_execute_BranchPlugin_branch_src2_4;
    _zz_execute_BranchPlugin_branch_src2_5[14] = _zz_execute_BranchPlugin_branch_src2_4;
    _zz_execute_BranchPlugin_branch_src2_5[13] = _zz_execute_BranchPlugin_branch_src2_4;
    _zz_execute_BranchPlugin_branch_src2_5[12] = _zz_execute_BranchPlugin_branch_src2_4;
    _zz_execute_BranchPlugin_branch_src2_5[11] = _zz_execute_BranchPlugin_branch_src2_4;
    _zz_execute_BranchPlugin_branch_src2_5[10] = _zz_execute_BranchPlugin_branch_src2_4;
    _zz_execute_BranchPlugin_branch_src2_5[9] = _zz_execute_BranchPlugin_branch_src2_4;
    _zz_execute_BranchPlugin_branch_src2_5[8] = _zz_execute_BranchPlugin_branch_src2_4;
    _zz_execute_BranchPlugin_branch_src2_5[7] = _zz_execute_BranchPlugin_branch_src2_4;
    _zz_execute_BranchPlugin_branch_src2_5[6] = _zz_execute_BranchPlugin_branch_src2_4;
    _zz_execute_BranchPlugin_branch_src2_5[5] = _zz_execute_BranchPlugin_branch_src2_4;
    _zz_execute_BranchPlugin_branch_src2_5[4] = _zz_execute_BranchPlugin_branch_src2_4;
    _zz_execute_BranchPlugin_branch_src2_5[3] = _zz_execute_BranchPlugin_branch_src2_4;
    _zz_execute_BranchPlugin_branch_src2_5[2] = _zz_execute_BranchPlugin_branch_src2_4;
    _zz_execute_BranchPlugin_branch_src2_5[1] = _zz_execute_BranchPlugin_branch_src2_4;
    _zz_execute_BranchPlugin_branch_src2_5[0] = _zz_execute_BranchPlugin_branch_src2_4;
  end

  assign execute_BranchPlugin_branchAdder = (execute_BranchPlugin_branch_src1 + execute_BranchPlugin_branch_src2);
  assign BranchPlugin_jumpInterface_valid = ((memory_arbitration_isValid && memory_BRANCH_DO) && (! 1'b0));
  assign BranchPlugin_jumpInterface_payload = memory_BRANCH_CALC;
  assign IBusCachedPlugin_decodePrediction_rsp_wasWrong = BranchPlugin_jumpInterface_valid;
  assign when_Pipeline_l124 = (! execute_arbitration_isStuck);
  assign when_Pipeline_l124_1 = (! memory_arbitration_isStuck);
  assign when_Pipeline_l124_2 = (! writeBack_arbitration_isStuck);
  assign when_Pipeline_l124_3 = (! execute_arbitration_isStuck);
  assign when_Pipeline_l124_4 = (! memory_arbitration_isStuck);
  assign when_Pipeline_l124_5 = (! writeBack_arbitration_isStuck);
  assign when_Pipeline_l124_6 = (! execute_arbitration_isStuck);
  assign when_Pipeline_l124_7 = (! memory_arbitration_isStuck);
  assign when_Pipeline_l124_8 = (! writeBack_arbitration_isStuck);
  assign when_Pipeline_l124_9 = (! execute_arbitration_isStuck);
  assign _zz_decode_to_execute_SRC1_CTRL_1 = decode_SRC1_CTRL;
  assign _zz_decode_SRC1_CTRL = _zz_decode_SRC1_CTRL_1;
  assign when_Pipeline_l124_10 = (! execute_arbitration_isStuck);
  assign _zz_execute_SRC1_CTRL = decode_to_execute_SRC1_CTRL;
  assign when_Pipeline_l124_11 = (! execute_arbitration_isStuck);
  assign when_Pipeline_l124_12 = (! execute_arbitration_isStuck);
  assign when_Pipeline_l124_13 = (! memory_arbitration_isStuck);
  assign when_Pipeline_l124_14 = (! writeBack_arbitration_isStuck);
  assign _zz_decode_to_execute_ALU_CTRL_1 = decode_ALU_CTRL;
  assign _zz_decode_ALU_CTRL = _zz_decode_ALU_CTRL_1;
  assign when_Pipeline_l124_15 = (! execute_arbitration_isStuck);
  assign _zz_execute_ALU_CTRL = decode_to_execute_ALU_CTRL;
  assign _zz_decode_to_execute_SRC2_CTRL_1 = decode_SRC2_CTRL;
  assign _zz_decode_SRC2_CTRL = _zz_decode_SRC2_CTRL_1;
  assign when_Pipeline_l124_16 = (! execute_arbitration_isStuck);
  assign _zz_execute_SRC2_CTRL = decode_to_execute_SRC2_CTRL;
  assign when_Pipeline_l124_17 = (! execute_arbitration_isStuck);
  assign when_Pipeline_l124_18 = (! memory_arbitration_isStuck);
  assign when_Pipeline_l124_19 = (! writeBack_arbitration_isStuck);
  assign when_Pipeline_l124_20 = (! execute_arbitration_isStuck);
  assign when_Pipeline_l124_21 = (! execute_arbitration_isStuck);
  assign when_Pipeline_l124_22 = (! memory_arbitration_isStuck);
  assign when_Pipeline_l124_23 = (! execute_arbitration_isStuck);
  assign when_Pipeline_l124_24 = (! execute_arbitration_isStuck);
  assign _zz_decode_to_execute_SRC3_CTRL_1 = decode_SRC3_CTRL;
  assign _zz_decode_SRC3_CTRL = _zz_decode_SRC3_CTRL_1;
  assign when_Pipeline_l124_25 = (! execute_arbitration_isStuck);
  assign _zz_execute_SRC3_CTRL = decode_to_execute_SRC3_CTRL;
  assign when_Pipeline_l124_26 = (! execute_arbitration_isStuck);
  assign _zz_decode_to_execute_ALU_BITWISE_CTRL_1 = decode_ALU_BITWISE_CTRL;
  assign _zz_decode_ALU_BITWISE_CTRL = _zz_decode_ALU_BITWISE_CTRL_1;
  assign when_Pipeline_l124_27 = (! execute_arbitration_isStuck);
  assign _zz_execute_ALU_BITWISE_CTRL = decode_to_execute_ALU_BITWISE_CTRL;
  assign _zz_decode_to_execute_SHIFT_CTRL_1 = decode_SHIFT_CTRL;
  assign _zz_execute_to_memory_SHIFT_CTRL_1 = execute_SHIFT_CTRL;
  assign _zz_decode_SHIFT_CTRL = _zz_decode_SHIFT_CTRL_1;
  assign when_Pipeline_l124_28 = (! execute_arbitration_isStuck);
  assign _zz_execute_SHIFT_CTRL = decode_to_execute_SHIFT_CTRL;
  assign when_Pipeline_l124_29 = (! memory_arbitration_isStuck);
  assign _zz_memory_SHIFT_CTRL = execute_to_memory_SHIFT_CTRL;
  assign when_Pipeline_l124_30 = (! execute_arbitration_isStuck);
  assign when_Pipeline_l124_31 = (! memory_arbitration_isStuck);
  assign _zz_decode_to_execute_CG6Ctrl_1 = decode_CG6Ctrl;
  assign _zz_decode_CG6Ctrl = _zz_decode_CG6Ctrl_1;
  assign when_Pipeline_l124_32 = (! execute_arbitration_isStuck);
  assign _zz_execute_CG6Ctrl = decode_to_execute_CG6Ctrl;
  assign _zz_decode_to_execute_CG6Ctrlminmax_1 = decode_CG6Ctrlminmax;
  assign _zz_decode_CG6Ctrlminmax = _zz_decode_CG6Ctrlminmax_1;
  assign when_Pipeline_l124_33 = (! execute_arbitration_isStuck);
  assign _zz_execute_CG6Ctrlminmax = decode_to_execute_CG6Ctrlminmax;
  assign _zz_decode_to_execute_CG6Ctrlsignextend_1 = decode_CG6Ctrlsignextend;
  assign _zz_decode_CG6Ctrlsignextend = _zz_decode_CG6Ctrlsignextend_1;
  assign when_Pipeline_l124_34 = (! execute_arbitration_isStuck);
  assign _zz_execute_CG6Ctrlsignextend = decode_to_execute_CG6Ctrlsignextend;
  assign _zz_decode_to_execute_CG6Ctrlternary_1 = decode_CG6Ctrlternary;
  assign _zz_decode_CG6Ctrlternary = _zz_decode_CG6Ctrlternary_1;
  assign when_Pipeline_l124_35 = (! execute_arbitration_isStuck);
  assign _zz_execute_CG6Ctrlternary = decode_to_execute_CG6Ctrlternary;
  assign _zz_decode_to_execute_BRANCH_CTRL_1 = decode_BRANCH_CTRL;
  assign _zz_decode_BRANCH_CTRL_1 = _zz_decode_BRANCH_CTRL;
  assign when_Pipeline_l124_36 = (! execute_arbitration_isStuck);
  assign _zz_execute_BRANCH_CTRL = decode_to_execute_BRANCH_CTRL;
  assign when_Pipeline_l124_37 = (! execute_arbitration_isStuck);
  assign when_Pipeline_l124_38 = (! memory_arbitration_isStuck);
  assign when_Pipeline_l124_39 = (! writeBack_arbitration_isStuck);
  assign when_Pipeline_l124_40 = (! execute_arbitration_isStuck);
  assign when_Pipeline_l124_41 = (! execute_arbitration_isStuck);
  assign when_Pipeline_l124_42 = (! execute_arbitration_isStuck);
  assign when_Pipeline_l124_43 = (! execute_arbitration_isStuck);
  assign when_Pipeline_l124_44 = (! execute_arbitration_isStuck);
  assign when_Pipeline_l124_45 = (! memory_arbitration_isStuck);
  assign when_Pipeline_l124_46 = (! writeBack_arbitration_isStuck);
  assign when_Pipeline_l124_47 = (! memory_arbitration_isStuck);
  assign when_Pipeline_l124_48 = (! writeBack_arbitration_isStuck);
  assign when_Pipeline_l124_49 = (! memory_arbitration_isStuck);
  assign when_Pipeline_l124_50 = (! writeBack_arbitration_isStuck);
  assign when_Pipeline_l124_51 = (! memory_arbitration_isStuck);
  assign when_Pipeline_l124_52 = (! memory_arbitration_isStuck);
  assign when_Pipeline_l124_53 = (! memory_arbitration_isStuck);
  assign when_Pipeline_l124_54 = (! memory_arbitration_isStuck);
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
  assign when_Pipeline_l151 = ((! execute_arbitration_isStuck) || execute_arbitration_removeIt);
  assign when_Pipeline_l154 = ((! decode_arbitration_isStuck) && (! decode_arbitration_removeIt));
  assign when_Pipeline_l151_1 = ((! memory_arbitration_isStuck) || memory_arbitration_removeIt);
  assign when_Pipeline_l154_1 = ((! execute_arbitration_isStuck) && (! execute_arbitration_removeIt));
  assign when_Pipeline_l151_2 = ((! writeBack_arbitration_isStuck) || writeBack_arbitration_removeIt);
  assign when_Pipeline_l154_2 = ((! memory_arbitration_isStuck) && (! memory_arbitration_removeIt));
  assign iBusWishbone_ADR = {_zz_iBusWishbone_ADR_1,_zz_iBusWishbone_ADR};
  assign iBusWishbone_CTI = ((_zz_iBusWishbone_ADR == 3'b111) ? 3'b111 : 3'b010);
  assign iBusWishbone_BTE = 2'b00;
  assign iBusWishbone_SEL = 4'b1111;
  assign iBusWishbone_WE = 1'b0;
  assign iBusWishbone_DAT_MOSI = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
  always @(*) begin
    iBusWishbone_CYC = 1'b0;
    if(when_InstructionCache_l239) begin
      iBusWishbone_CYC = 1'b1;
    end
  end

  always @(*) begin
    iBusWishbone_STB = 1'b0;
    if(when_InstructionCache_l239) begin
      iBusWishbone_STB = 1'b1;
    end
  end

  assign when_InstructionCache_l239 = (iBus_cmd_valid || (_zz_iBusWishbone_ADR != 3'b000));
  assign iBus_cmd_ready = (iBus_cmd_valid && iBusWishbone_ACK);
  assign iBus_rsp_valid = _zz_iBus_rsp_valid;
  assign iBus_rsp_payload_data = iBusWishbone_DAT_MISO_regNext;
  assign iBus_rsp_payload_error = 1'b0;
  assign _zz_dBus_cmd_ready_5 = (dBus_cmd_payload_size == 3'b101);
  assign _zz_dBus_cmd_ready_1 = dBus_cmd_valid;
  assign _zz_dBus_cmd_ready_3 = dBus_cmd_payload_wr;
  assign _zz_dBus_cmd_ready_4 = ((! _zz_dBus_cmd_ready_5) || (_zz_dBus_cmd_ready == 1'b1));
  assign dBus_cmd_ready = (_zz_dBus_cmd_ready_2 && (_zz_dBus_cmd_ready_3 || _zz_dBus_cmd_ready_4));
  assign dBusWishbone_ADR = ((_zz_dBus_cmd_ready_5 ? {{dBus_cmd_payload_address[31 : 5],_zz_dBus_cmd_ready},4'b0000} : {dBus_cmd_payload_address[31 : 4],4'b0000}) >>> 4);
  assign dBusWishbone_CTI = (_zz_dBus_cmd_ready_5 ? (_zz_dBus_cmd_ready_4 ? 3'b111 : 3'b010) : 3'b000);
  assign dBusWishbone_BTE = 2'b00;
  assign dBusWishbone_SEL = (_zz_dBus_cmd_ready_3 ? dBus_cmd_payload_mask : 16'hffff);
  assign dBusWishbone_WE = _zz_dBus_cmd_ready_3;
  assign dBusWishbone_DAT_MOSI = dBus_cmd_payload_data;
  assign _zz_dBus_cmd_ready_2 = (_zz_dBus_cmd_ready_1 && dBusWishbone_ACK);
  assign dBusWishbone_CYC = _zz_dBus_cmd_ready_1;
  assign dBusWishbone_STB = _zz_dBus_cmd_ready_1;
  assign dBus_rsp_valid = _zz_dBus_rsp_valid;
  assign dBus_rsp_payload_data = dBusWishbone_DAT_MISO_regNext;
  assign dBus_rsp_payload_error = 1'b0;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      IBusCachedPlugin_fetchPc_pcReg <= 32'h00410000;
      IBusCachedPlugin_fetchPc_correctionReg <= 1'b0;
      IBusCachedPlugin_fetchPc_booted <= 1'b0;
      IBusCachedPlugin_fetchPc_inc <= 1'b0;
      _zz_IBusCachedPlugin_iBusRsp_stages_0_output_ready_2 <= 1'b0;
      _zz_IBusCachedPlugin_iBusRsp_stages_1_output_m2sPipe_valid <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_0 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_1 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_2 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_3 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_4 <= 1'b0;
      IBusCachedPlugin_rspCounter <= 32'h0;
      dataCache_1_io_mem_cmd_rValid <= 1'b0;
      dBus_rsp_regNext_valid <= 1'b0;
      DBusCachedPlugin_rspCounter <= 32'h0;
      _zz_7 <= 1'b1;
      HazardSimplePlugin_writeBackBuffer_valid <= 1'b0;
      execute_arbitration_isValid <= 1'b0;
      memory_arbitration_isValid <= 1'b0;
      writeBack_arbitration_isValid <= 1'b0;
      _zz_iBusWishbone_ADR <= 3'b000;
      _zz_iBus_rsp_valid <= 1'b0;
      _zz_dBus_cmd_ready <= 1'b0;
      _zz_dBus_rsp_valid <= 1'b0;
    end else begin
      if(IBusCachedPlugin_fetchPc_correction) begin
        IBusCachedPlugin_fetchPc_correctionReg <= 1'b1;
      end
      if(IBusCachedPlugin_fetchPc_output_fire) begin
        IBusCachedPlugin_fetchPc_correctionReg <= 1'b0;
      end
      IBusCachedPlugin_fetchPc_booted <= 1'b1;
      if(when_Fetcher_l134) begin
        IBusCachedPlugin_fetchPc_inc <= 1'b0;
      end
      if(IBusCachedPlugin_fetchPc_output_fire_1) begin
        IBusCachedPlugin_fetchPc_inc <= 1'b1;
      end
      if(when_Fetcher_l134_1) begin
        IBusCachedPlugin_fetchPc_inc <= 1'b0;
      end
      if(when_Fetcher_l161) begin
        IBusCachedPlugin_fetchPc_pcReg <= IBusCachedPlugin_fetchPc_pc;
      end
      if(IBusCachedPlugin_iBusRsp_flush) begin
        _zz_IBusCachedPlugin_iBusRsp_stages_0_output_ready_2 <= 1'b0;
      end
      if(_zz_IBusCachedPlugin_iBusRsp_stages_0_output_ready) begin
        _zz_IBusCachedPlugin_iBusRsp_stages_0_output_ready_2 <= (IBusCachedPlugin_iBusRsp_stages_0_output_valid && (! 1'b0));
      end
      if(IBusCachedPlugin_iBusRsp_flush) begin
        _zz_IBusCachedPlugin_iBusRsp_stages_1_output_m2sPipe_valid <= 1'b0;
      end
      if(IBusCachedPlugin_iBusRsp_stages_1_output_ready) begin
        _zz_IBusCachedPlugin_iBusRsp_stages_1_output_m2sPipe_valid <= (IBusCachedPlugin_iBusRsp_stages_1_output_valid && (! IBusCachedPlugin_iBusRsp_flush));
      end
      if(IBusCachedPlugin_fetchPc_flushed) begin
        IBusCachedPlugin_injector_nextPcCalc_valids_0 <= 1'b0;
      end
      if(when_Fetcher_l332) begin
        IBusCachedPlugin_injector_nextPcCalc_valids_0 <= 1'b1;
      end
      if(IBusCachedPlugin_fetchPc_flushed) begin
        IBusCachedPlugin_injector_nextPcCalc_valids_1 <= 1'b0;
      end
      if(when_Fetcher_l332_1) begin
        IBusCachedPlugin_injector_nextPcCalc_valids_1 <= IBusCachedPlugin_injector_nextPcCalc_valids_0;
      end
      if(IBusCachedPlugin_fetchPc_flushed) begin
        IBusCachedPlugin_injector_nextPcCalc_valids_1 <= 1'b0;
      end
      if(IBusCachedPlugin_fetchPc_flushed) begin
        IBusCachedPlugin_injector_nextPcCalc_valids_2 <= 1'b0;
      end
      if(when_Fetcher_l332_2) begin
        IBusCachedPlugin_injector_nextPcCalc_valids_2 <= IBusCachedPlugin_injector_nextPcCalc_valids_1;
      end
      if(IBusCachedPlugin_fetchPc_flushed) begin
        IBusCachedPlugin_injector_nextPcCalc_valids_2 <= 1'b0;
      end
      if(IBusCachedPlugin_fetchPc_flushed) begin
        IBusCachedPlugin_injector_nextPcCalc_valids_3 <= 1'b0;
      end
      if(when_Fetcher_l332_3) begin
        IBusCachedPlugin_injector_nextPcCalc_valids_3 <= IBusCachedPlugin_injector_nextPcCalc_valids_2;
      end
      if(IBusCachedPlugin_fetchPc_flushed) begin
        IBusCachedPlugin_injector_nextPcCalc_valids_3 <= 1'b0;
      end
      if(IBusCachedPlugin_fetchPc_flushed) begin
        IBusCachedPlugin_injector_nextPcCalc_valids_4 <= 1'b0;
      end
      if(when_Fetcher_l332_4) begin
        IBusCachedPlugin_injector_nextPcCalc_valids_4 <= IBusCachedPlugin_injector_nextPcCalc_valids_3;
      end
      if(IBusCachedPlugin_fetchPc_flushed) begin
        IBusCachedPlugin_injector_nextPcCalc_valids_4 <= 1'b0;
      end
      if(iBus_rsp_valid) begin
        IBusCachedPlugin_rspCounter <= (IBusCachedPlugin_rspCounter + 32'h00000001);
      end
      if(dataCache_1_io_mem_cmd_valid) begin
        dataCache_1_io_mem_cmd_rValid <= 1'b1;
      end
      if(dataCache_1_io_mem_cmd_s2mPipe_ready) begin
        dataCache_1_io_mem_cmd_rValid <= 1'b0;
      end
      dBus_rsp_regNext_valid <= dBus_rsp_valid;
      if(dBus_rsp_valid) begin
        DBusCachedPlugin_rspCounter <= (DBusCachedPlugin_rspCounter + 32'h00000001);
      end
      _zz_7 <= 1'b0;
      HazardSimplePlugin_writeBackBuffer_valid <= HazardSimplePlugin_writeBackWrites_valid;
      if(when_Pipeline_l151) begin
        execute_arbitration_isValid <= 1'b0;
      end
      if(when_Pipeline_l154) begin
        execute_arbitration_isValid <= decode_arbitration_isValid;
      end
      if(when_Pipeline_l151_1) begin
        memory_arbitration_isValid <= 1'b0;
      end
      if(when_Pipeline_l154_1) begin
        memory_arbitration_isValid <= execute_arbitration_isValid;
      end
      if(when_Pipeline_l151_2) begin
        writeBack_arbitration_isValid <= 1'b0;
      end
      if(when_Pipeline_l154_2) begin
        writeBack_arbitration_isValid <= memory_arbitration_isValid;
      end
      if(when_InstructionCache_l239) begin
        if(iBusWishbone_ACK) begin
          _zz_iBusWishbone_ADR <= (_zz_iBusWishbone_ADR + 3'b001);
        end
      end
      _zz_iBus_rsp_valid <= (iBusWishbone_CYC && iBusWishbone_ACK);
      if((_zz_dBus_cmd_ready_1 && _zz_dBus_cmd_ready_2)) begin
        _zz_dBus_cmd_ready <= (_zz_dBus_cmd_ready + 1'b1);
        if(_zz_dBus_cmd_ready_4) begin
          _zz_dBus_cmd_ready <= 1'b0;
        end
      end
      _zz_dBus_rsp_valid <= ((_zz_dBus_cmd_ready_1 && (! dBusWishbone_WE)) && dBusWishbone_ACK);
    end
  end

  always @(posedge clk) begin
    if(IBusCachedPlugin_iBusRsp_stages_1_output_ready) begin
      _zz_IBusCachedPlugin_iBusRsp_stages_1_output_m2sPipe_payload <= IBusCachedPlugin_iBusRsp_stages_1_output_payload;
    end
    if(IBusCachedPlugin_iBusRsp_stages_1_input_ready) begin
      IBusCachedPlugin_s1_tightlyCoupledHit <= IBusCachedPlugin_s0_tightlyCoupledHit;
    end
    if(IBusCachedPlugin_iBusRsp_stages_2_input_ready) begin
      IBusCachedPlugin_s2_tightlyCoupledHit <= IBusCachedPlugin_s1_tightlyCoupledHit;
    end
    if(dataCache_1_io_mem_cmd_ready) begin
      dataCache_1_io_mem_cmd_rData_wr <= dataCache_1_io_mem_cmd_payload_wr;
      dataCache_1_io_mem_cmd_rData_uncached <= dataCache_1_io_mem_cmd_payload_uncached;
      dataCache_1_io_mem_cmd_rData_address <= dataCache_1_io_mem_cmd_payload_address;
      dataCache_1_io_mem_cmd_rData_data <= dataCache_1_io_mem_cmd_payload_data;
      dataCache_1_io_mem_cmd_rData_mask <= dataCache_1_io_mem_cmd_payload_mask;
      dataCache_1_io_mem_cmd_rData_size <= dataCache_1_io_mem_cmd_payload_size;
      dataCache_1_io_mem_cmd_rData_last <= dataCache_1_io_mem_cmd_payload_last;
    end
    dBus_rsp_regNext_payload_aggregated <= dBus_rsp_payload_aggregated;
    dBus_rsp_regNext_payload_last <= dBus_rsp_payload_last;
    dBus_rsp_regNext_payload_data <= dBus_rsp_payload_data;
    dBus_rsp_regNext_payload_error <= dBus_rsp_payload_error;
    HazardSimplePlugin_writeBackBuffer_payload_address <= HazardSimplePlugin_writeBackWrites_payload_address;
    HazardSimplePlugin_writeBackBuffer_payload_data <= HazardSimplePlugin_writeBackWrites_payload_data;
    if(when_Pipeline_l124) begin
      decode_to_execute_PC <= decode_PC;
    end
    if(when_Pipeline_l124_1) begin
      execute_to_memory_PC <= _zz_execute_SRC2;
    end
    if(when_Pipeline_l124_2) begin
      memory_to_writeBack_PC <= memory_PC;
    end
    if(when_Pipeline_l124_3) begin
      decode_to_execute_INSTRUCTION <= decode_INSTRUCTION;
    end
    if(when_Pipeline_l124_4) begin
      execute_to_memory_INSTRUCTION <= execute_INSTRUCTION;
    end
    if(when_Pipeline_l124_5) begin
      memory_to_writeBack_INSTRUCTION <= memory_INSTRUCTION;
    end
    if(when_Pipeline_l124_6) begin
      decode_to_execute_FORMAL_PC_NEXT <= _zz_decode_to_execute_FORMAL_PC_NEXT;
    end
    if(when_Pipeline_l124_7) begin
      execute_to_memory_FORMAL_PC_NEXT <= execute_FORMAL_PC_NEXT;
    end
    if(when_Pipeline_l124_8) begin
      memory_to_writeBack_FORMAL_PC_NEXT <= _zz_memory_to_writeBack_FORMAL_PC_NEXT;
    end
    if(when_Pipeline_l124_9) begin
      decode_to_execute_MEMORY_FORCE_CONSTISTENCY <= decode_MEMORY_FORCE_CONSTISTENCY;
    end
    if(when_Pipeline_l124_10) begin
      decode_to_execute_SRC1_CTRL <= _zz_decode_to_execute_SRC1_CTRL;
    end
    if(when_Pipeline_l124_11) begin
      decode_to_execute_SRC_USE_SUB_LESS <= decode_SRC_USE_SUB_LESS;
    end
    if(when_Pipeline_l124_12) begin
      decode_to_execute_MEMORY_ENABLE <= decode_MEMORY_ENABLE;
    end
    if(when_Pipeline_l124_13) begin
      execute_to_memory_MEMORY_ENABLE <= execute_MEMORY_ENABLE;
    end
    if(when_Pipeline_l124_14) begin
      memory_to_writeBack_MEMORY_ENABLE <= memory_MEMORY_ENABLE;
    end
    if(when_Pipeline_l124_15) begin
      decode_to_execute_ALU_CTRL <= _zz_decode_to_execute_ALU_CTRL;
    end
    if(when_Pipeline_l124_16) begin
      decode_to_execute_SRC2_CTRL <= _zz_decode_to_execute_SRC2_CTRL;
    end
    if(when_Pipeline_l124_17) begin
      decode_to_execute_REGFILE_WRITE_VALID <= decode_REGFILE_WRITE_VALID;
    end
    if(when_Pipeline_l124_18) begin
      execute_to_memory_REGFILE_WRITE_VALID <= execute_REGFILE_WRITE_VALID;
    end
    if(when_Pipeline_l124_19) begin
      memory_to_writeBack_REGFILE_WRITE_VALID <= memory_REGFILE_WRITE_VALID;
    end
    if(when_Pipeline_l124_20) begin
      decode_to_execute_BYPASSABLE_EXECUTE_STAGE <= decode_BYPASSABLE_EXECUTE_STAGE;
    end
    if(when_Pipeline_l124_21) begin
      decode_to_execute_BYPASSABLE_MEMORY_STAGE <= decode_BYPASSABLE_MEMORY_STAGE;
    end
    if(when_Pipeline_l124_22) begin
      execute_to_memory_BYPASSABLE_MEMORY_STAGE <= execute_BYPASSABLE_MEMORY_STAGE;
    end
    if(when_Pipeline_l124_23) begin
      decode_to_execute_MEMORY_WR <= decode_MEMORY_WR;
    end
    if(when_Pipeline_l124_24) begin
      decode_to_execute_MEMORY_MANAGMENT <= decode_MEMORY_MANAGMENT;
    end
    if(when_Pipeline_l124_25) begin
      decode_to_execute_SRC3_CTRL <= _zz_decode_to_execute_SRC3_CTRL;
    end
    if(when_Pipeline_l124_26) begin
      decode_to_execute_SRC_LESS_UNSIGNED <= decode_SRC_LESS_UNSIGNED;
    end
    if(when_Pipeline_l124_27) begin
      decode_to_execute_ALU_BITWISE_CTRL <= _zz_decode_to_execute_ALU_BITWISE_CTRL;
    end
    if(when_Pipeline_l124_28) begin
      decode_to_execute_SHIFT_CTRL <= _zz_decode_to_execute_SHIFT_CTRL;
    end
    if(when_Pipeline_l124_29) begin
      execute_to_memory_SHIFT_CTRL <= _zz_execute_to_memory_SHIFT_CTRL;
    end
    if(when_Pipeline_l124_30) begin
      decode_to_execute_IS_CG6 <= decode_IS_CG6;
    end
    if(when_Pipeline_l124_31) begin
      execute_to_memory_IS_CG6 <= execute_IS_CG6;
    end
    if(when_Pipeline_l124_32) begin
      decode_to_execute_CG6Ctrl <= _zz_decode_to_execute_CG6Ctrl;
    end
    if(when_Pipeline_l124_33) begin
      decode_to_execute_CG6Ctrlminmax <= _zz_decode_to_execute_CG6Ctrlminmax;
    end
    if(when_Pipeline_l124_34) begin
      decode_to_execute_CG6Ctrlsignextend <= _zz_decode_to_execute_CG6Ctrlsignextend;
    end
    if(when_Pipeline_l124_35) begin
      decode_to_execute_CG6Ctrlternary <= _zz_decode_to_execute_CG6Ctrlternary;
    end
    if(when_Pipeline_l124_36) begin
      decode_to_execute_BRANCH_CTRL <= _zz_decode_to_execute_BRANCH_CTRL;
    end
    if(when_Pipeline_l124_37) begin
      decode_to_execute_REGFILE_WRITE_VALID_ODD <= decode_REGFILE_WRITE_VALID_ODD;
    end
    if(when_Pipeline_l124_38) begin
      execute_to_memory_REGFILE_WRITE_VALID_ODD <= execute_REGFILE_WRITE_VALID_ODD;
    end
    if(when_Pipeline_l124_39) begin
      memory_to_writeBack_REGFILE_WRITE_VALID_ODD <= memory_REGFILE_WRITE_VALID_ODD;
    end
    if(when_Pipeline_l124_40) begin
      decode_to_execute_RS1 <= decode_RS1;
    end
    if(when_Pipeline_l124_41) begin
      decode_to_execute_RS2 <= decode_RS2;
    end
    if(when_Pipeline_l124_42) begin
      decode_to_execute_RS3 <= decode_RS3;
    end
    if(when_Pipeline_l124_43) begin
      decode_to_execute_SRC2_FORCE_ZERO <= decode_SRC2_FORCE_ZERO;
    end
    if(when_Pipeline_l124_44) begin
      decode_to_execute_PREDICTION_HAD_BRANCHED2 <= decode_PREDICTION_HAD_BRANCHED2;
    end
    if(when_Pipeline_l124_45) begin
      execute_to_memory_MEMORY_STORE_DATA_RF <= execute_MEMORY_STORE_DATA_RF;
    end
    if(when_Pipeline_l124_46) begin
      memory_to_writeBack_MEMORY_STORE_DATA_RF <= memory_MEMORY_STORE_DATA_RF;
    end
    if(when_Pipeline_l124_47) begin
      execute_to_memory_REGFILE_WRITE_DATA <= _zz_decode_RS3_1;
    end
    if(when_Pipeline_l124_48) begin
      memory_to_writeBack_REGFILE_WRITE_DATA <= _zz_decode_RS3_4;
    end
    if(when_Pipeline_l124_49) begin
      execute_to_memory_REGFILE_WRITE_DATA_ODD <= _zz_decode_RS3;
    end
    if(when_Pipeline_l124_50) begin
      memory_to_writeBack_REGFILE_WRITE_DATA_ODD <= _zz_decode_RS3_2;
    end
    if(when_Pipeline_l124_51) begin
      execute_to_memory_SHIFT_RIGHT <= execute_SHIFT_RIGHT;
    end
    if(when_Pipeline_l124_52) begin
      execute_to_memory_CG6_FINAL_OUTPUT <= execute_CG6_FINAL_OUTPUT;
    end
    if(when_Pipeline_l124_53) begin
      execute_to_memory_BRANCH_DO <= execute_BRANCH_DO;
    end
    if(when_Pipeline_l124_54) begin
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
  input      [2:0]    io_cpu_execute_args_size,
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
  input               io_cpu_writeBack_isFiring,
  input               io_cpu_writeBack_isUser,
  output reg          io_cpu_writeBack_haltIt,
  output              io_cpu_writeBack_isWrite,
  input      [127:0]  io_cpu_writeBack_storeData,
  output reg [127:0]  io_cpu_writeBack_data,
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
  output     [127:0]  io_mem_cmd_payload_data,
  output     [15:0]   io_mem_cmd_payload_mask,
  output reg [2:0]    io_mem_cmd_payload_size,
  output              io_mem_cmd_payload_last,
  input               io_mem_rsp_valid,
  input      [4:0]    io_mem_rsp_payload_aggregated,
  input               io_mem_rsp_payload_last,
  input      [127:0]  io_mem_rsp_payload_data,
  input               io_mem_rsp_payload_error,
  input               clk,
  input               reset
);

  reg        [25:0]   _zz_ways_0_tags_port0;
  reg        [127:0]  _zz_ways_0_data_port0;
  reg        [25:0]   _zz_ways_1_tags_port0;
  reg        [127:0]  _zz_ways_1_data_port0;
  wire       [25:0]   _zz_ways_0_tags_port;
  wire       [25:0]   _zz_ways_1_tags_port;
  wire       [0:0]    _zz_when;
  wire       [2:0]    _zz_loader_waysAllocator;
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
  reg        [23:0]   tagsWriteCmd_payload_data_address;
  reg                 tagsWriteLastCmd_valid;
  reg        [1:0]    tagsWriteLastCmd_payload_way;
  reg        [2:0]    tagsWriteLastCmd_payload_address;
  reg                 tagsWriteLastCmd_payload_data_valid;
  reg                 tagsWriteLastCmd_payload_data_error;
  reg        [23:0]   tagsWriteLastCmd_payload_data_address;
  reg                 dataReadCmd_valid;
  reg        [3:0]    dataReadCmd_payload;
  reg                 dataWriteCmd_valid;
  reg        [1:0]    dataWriteCmd_payload_way;
  reg        [3:0]    dataWriteCmd_payload_address;
  reg        [127:0]  dataWriteCmd_payload_data;
  reg        [15:0]   dataWriteCmd_payload_mask;
  wire                _zz_ways_0_tagsReadRsp_valid;
  wire                ways_0_tagsReadRsp_valid;
  wire                ways_0_tagsReadRsp_error;
  wire       [23:0]   ways_0_tagsReadRsp_address;
  wire       [25:0]   _zz_ways_0_tagsReadRsp_valid_1;
  wire                _zz_ways_0_dataReadRspMem;
  wire       [127:0]  ways_0_dataReadRspMem;
  wire       [127:0]  ways_0_dataReadRsp;
  wire                when_DataCache_l636;
  wire                when_DataCache_l639;
  wire                _zz_ways_1_tagsReadRsp_valid;
  wire                ways_1_tagsReadRsp_valid;
  wire                ways_1_tagsReadRsp_error;
  wire       [23:0]   ways_1_tagsReadRsp_address;
  wire       [25:0]   _zz_ways_1_tagsReadRsp_valid_1;
  wire                _zz_ways_1_dataReadRspMem;
  wire       [127:0]  ways_1_dataReadRspMem;
  wire       [127:0]  ways_1_dataReadRsp;
  wire                when_DataCache_l636_1;
  wire                when_DataCache_l639_1;
  wire                when_DataCache_l658;
  wire                rspSync;
  wire                rspLast;
  reg                 memCmdSent;
  wire                io_mem_cmd_fire;
  wire                when_DataCache_l680;
  reg        [15:0]   _zz_stage0_mask;
  wire       [15:0]   stage0_mask;
  reg        [1:0]    stage0_dataColisions;
  wire       [3:0]    _zz_stage0_dataColisions;
  wire       [15:0]   _zz_stage0_dataColisions_1;
  wire       [1:0]    stage0_wayInvalidate;
  wire                stage0_isAmo;
  wire                when_DataCache_l765;
  reg                 stageA_request_wr;
  reg        [2:0]    stageA_request_size;
  reg                 stageA_request_totalyConsistent;
  wire                when_DataCache_l765_1;
  reg        [15:0]   stageA_mask;
  wire                stageA_isAmo;
  wire                stageA_isLrsc;
  wire       [1:0]    stageA_wayHits;
  wire                when_DataCache_l765_2;
  reg        [1:0]    stageA_wayInvalidate;
  wire                when_DataCache_l765_3;
  reg        [1:0]    stage0_dataColisions_regNextWhen;
  reg        [1:0]    _zz_stageA_dataColisions;
  wire       [3:0]    _zz_stageA_dataColisions_1;
  wire       [15:0]   _zz_stageA_dataColisions_2;
  wire       [1:0]    stageA_dataColisions;
  wire                when_DataCache_l816;
  reg                 stageB_request_wr;
  reg        [2:0]    stageB_request_size;
  reg                 stageB_request_totalyConsistent;
  reg                 stageB_mmuRspFreeze;
  wire                when_DataCache_l818;
  reg        [31:0]   stageB_mmuRsp_physicalAddress;
  reg                 stageB_mmuRsp_isIoAccess;
  reg                 stageB_mmuRsp_isPaging;
  reg                 stageB_mmuRsp_allowRead;
  reg                 stageB_mmuRsp_allowWrite;
  reg                 stageB_mmuRsp_allowExecute;
  reg                 stageB_mmuRsp_exception;
  reg                 stageB_mmuRsp_refilling;
  reg                 stageB_mmuRsp_bypassTranslation;
  wire                when_DataCache_l815;
  reg                 stageB_tagsReadRsp_0_valid;
  reg                 stageB_tagsReadRsp_0_error;
  reg        [23:0]   stageB_tagsReadRsp_0_address;
  wire                when_DataCache_l815_1;
  reg                 stageB_tagsReadRsp_1_valid;
  reg                 stageB_tagsReadRsp_1_error;
  reg        [23:0]   stageB_tagsReadRsp_1_address;
  wire                when_DataCache_l815_2;
  reg        [127:0]  stageB_dataReadRsp_0;
  wire                when_DataCache_l815_3;
  reg        [127:0]  stageB_dataReadRsp_1;
  wire                when_DataCache_l814;
  reg        [1:0]    stageB_wayInvalidate;
  wire                stageB_consistancyHazard;
  wire                when_DataCache_l814_1;
  reg        [1:0]    stageB_dataColisions;
  wire                stageB_unaligned;
  wire                when_DataCache_l814_2;
  reg        [1:0]    stageB_waysHitsBeforeInvalidate;
  wire       [1:0]    stageB_waysHits;
  wire                stageB_waysHit;
  wire       [127:0]  stageB_dataMux;
  wire                when_DataCache_l814_3;
  reg        [15:0]   stageB_mask;
  reg                 stageB_loaderValid;
  wire       [127:0]  stageB_ioMemRspMuxed;
  reg                 stageB_flusher_waitDone;
  wire                stageB_flusher_hold;
  reg        [3:0]    stageB_flusher_counter;
  wire                when_DataCache_l844;
  wire                when_DataCache_l850;
  reg                 stageB_flusher_start;
  wire                stageB_isAmo;
  wire                stageB_isAmoCached;
  wire                stageB_isExternalLsrc;
  wire                stageB_isExternalAmo;
  wire       [127:0]  stageB_requestDataBypass;
  reg                 stageB_cpuWriteToCache;
  wire                when_DataCache_l914;
  wire                stageB_badPermissions;
  wire                stageB_loadStoreFault;
  wire                stageB_bypassCache;
  wire                when_DataCache_l983;
  wire                when_DataCache_l992;
  wire                when_DataCache_l997;
  wire                when_DataCache_l1008;
  wire                when_DataCache_l1020;
  wire                when_DataCache_l979;
  wire                when_DataCache_l1054;
  wire                when_DataCache_l1063;
  reg                 loader_valid;
  reg                 loader_counter_willIncrement;
  wire                loader_counter_willClear;
  reg        [0:0]    loader_counter_valueNext;
  reg        [0:0]    loader_counter_value;
  wire                loader_counter_willOverflowIfInc;
  wire                loader_counter_willOverflow;
  reg        [1:0]    loader_waysAllocator;
  reg                 loader_error;
  wire                loader_kill;
  reg                 loader_killReg;
  wire                when_DataCache_l1078;
  wire                loader_done;
  wire                when_DataCache_l1106;
  reg                 loader_valid_regNext;
  wire                when_DataCache_l1110;
  wire                when_DataCache_l1113;
  reg [25:0] ways_0_tags [0:7];
  reg [7:0] ways_0_data_symbol0 [0:15];
  reg [7:0] ways_0_data_symbol1 [0:15];
  reg [7:0] ways_0_data_symbol2 [0:15];
  reg [7:0] ways_0_data_symbol3 [0:15];
  reg [7:0] ways_0_data_symbol4 [0:15];
  reg [7:0] ways_0_data_symbol5 [0:15];
  reg [7:0] ways_0_data_symbol6 [0:15];
  reg [7:0] ways_0_data_symbol7 [0:15];
  reg [7:0] ways_0_data_symbol8 [0:15];
  reg [7:0] ways_0_data_symbol9 [0:15];
  reg [7:0] ways_0_data_symbol10 [0:15];
  reg [7:0] ways_0_data_symbol11 [0:15];
  reg [7:0] ways_0_data_symbol12 [0:15];
  reg [7:0] ways_0_data_symbol13 [0:15];
  reg [7:0] ways_0_data_symbol14 [0:15];
  reg [7:0] ways_0_data_symbol15 [0:15];
  reg [7:0] _zz_ways_0_datasymbol_read;
  reg [7:0] _zz_ways_0_datasymbol_read_1;
  reg [7:0] _zz_ways_0_datasymbol_read_2;
  reg [7:0] _zz_ways_0_datasymbol_read_3;
  reg [7:0] _zz_ways_0_datasymbol_read_4;
  reg [7:0] _zz_ways_0_datasymbol_read_5;
  reg [7:0] _zz_ways_0_datasymbol_read_6;
  reg [7:0] _zz_ways_0_datasymbol_read_7;
  reg [7:0] _zz_ways_0_datasymbol_read_8;
  reg [7:0] _zz_ways_0_datasymbol_read_9;
  reg [7:0] _zz_ways_0_datasymbol_read_10;
  reg [7:0] _zz_ways_0_datasymbol_read_11;
  reg [7:0] _zz_ways_0_datasymbol_read_12;
  reg [7:0] _zz_ways_0_datasymbol_read_13;
  reg [7:0] _zz_ways_0_datasymbol_read_14;
  reg [7:0] _zz_ways_0_datasymbol_read_15;
  reg [25:0] ways_1_tags [0:7];
  reg [7:0] ways_1_data_symbol0 [0:15];
  reg [7:0] ways_1_data_symbol1 [0:15];
  reg [7:0] ways_1_data_symbol2 [0:15];
  reg [7:0] ways_1_data_symbol3 [0:15];
  reg [7:0] ways_1_data_symbol4 [0:15];
  reg [7:0] ways_1_data_symbol5 [0:15];
  reg [7:0] ways_1_data_symbol6 [0:15];
  reg [7:0] ways_1_data_symbol7 [0:15];
  reg [7:0] ways_1_data_symbol8 [0:15];
  reg [7:0] ways_1_data_symbol9 [0:15];
  reg [7:0] ways_1_data_symbol10 [0:15];
  reg [7:0] ways_1_data_symbol11 [0:15];
  reg [7:0] ways_1_data_symbol12 [0:15];
  reg [7:0] ways_1_data_symbol13 [0:15];
  reg [7:0] ways_1_data_symbol14 [0:15];
  reg [7:0] ways_1_data_symbol15 [0:15];
  reg [7:0] _zz_ways_1_datasymbol_read;
  reg [7:0] _zz_ways_1_datasymbol_read_1;
  reg [7:0] _zz_ways_1_datasymbol_read_2;
  reg [7:0] _zz_ways_1_datasymbol_read_3;
  reg [7:0] _zz_ways_1_datasymbol_read_4;
  reg [7:0] _zz_ways_1_datasymbol_read_5;
  reg [7:0] _zz_ways_1_datasymbol_read_6;
  reg [7:0] _zz_ways_1_datasymbol_read_7;
  reg [7:0] _zz_ways_1_datasymbol_read_8;
  reg [7:0] _zz_ways_1_datasymbol_read_9;
  reg [7:0] _zz_ways_1_datasymbol_read_10;
  reg [7:0] _zz_ways_1_datasymbol_read_11;
  reg [7:0] _zz_ways_1_datasymbol_read_12;
  reg [7:0] _zz_ways_1_datasymbol_read_13;
  reg [7:0] _zz_ways_1_datasymbol_read_14;
  reg [7:0] _zz_ways_1_datasymbol_read_15;

  assign _zz_when = 1'b1;
  assign _zz_loader_waysAllocator = {loader_waysAllocator,loader_waysAllocator[1]};
  assign _zz_ways_0_tags_port = {tagsWriteCmd_payload_data_address,{tagsWriteCmd_payload_data_error,tagsWriteCmd_payload_data_valid}};
  assign _zz_ways_1_tags_port = {tagsWriteCmd_payload_data_address,{tagsWriteCmd_payload_data_error,tagsWriteCmd_payload_data_valid}};
  always @(posedge clk) begin
    if(_zz_ways_0_tagsReadRsp_valid) begin
      _zz_ways_0_tags_port0 <= ways_0_tags[tagsReadCmd_payload];
    end
  end

  always @(posedge clk) begin
    if(_zz_4) begin
      ways_0_tags[tagsWriteCmd_payload_address] <= _zz_ways_0_tags_port;
    end
  end

  always @(*) begin
    _zz_ways_0_data_port0 = {_zz_ways_0_datasymbol_read_15, _zz_ways_0_datasymbol_read_14, _zz_ways_0_datasymbol_read_13, _zz_ways_0_datasymbol_read_12, _zz_ways_0_datasymbol_read_11, _zz_ways_0_datasymbol_read_10, _zz_ways_0_datasymbol_read_9, _zz_ways_0_datasymbol_read_8, _zz_ways_0_datasymbol_read_7, _zz_ways_0_datasymbol_read_6, _zz_ways_0_datasymbol_read_5, _zz_ways_0_datasymbol_read_4, _zz_ways_0_datasymbol_read_3, _zz_ways_0_datasymbol_read_2, _zz_ways_0_datasymbol_read_1, _zz_ways_0_datasymbol_read};
  end
  always @(posedge clk) begin
    if(_zz_ways_0_dataReadRspMem) begin
      _zz_ways_0_datasymbol_read <= ways_0_data_symbol0[dataReadCmd_payload];
      _zz_ways_0_datasymbol_read_1 <= ways_0_data_symbol1[dataReadCmd_payload];
      _zz_ways_0_datasymbol_read_2 <= ways_0_data_symbol2[dataReadCmd_payload];
      _zz_ways_0_datasymbol_read_3 <= ways_0_data_symbol3[dataReadCmd_payload];
      _zz_ways_0_datasymbol_read_4 <= ways_0_data_symbol4[dataReadCmd_payload];
      _zz_ways_0_datasymbol_read_5 <= ways_0_data_symbol5[dataReadCmd_payload];
      _zz_ways_0_datasymbol_read_6 <= ways_0_data_symbol6[dataReadCmd_payload];
      _zz_ways_0_datasymbol_read_7 <= ways_0_data_symbol7[dataReadCmd_payload];
      _zz_ways_0_datasymbol_read_8 <= ways_0_data_symbol8[dataReadCmd_payload];
      _zz_ways_0_datasymbol_read_9 <= ways_0_data_symbol9[dataReadCmd_payload];
      _zz_ways_0_datasymbol_read_10 <= ways_0_data_symbol10[dataReadCmd_payload];
      _zz_ways_0_datasymbol_read_11 <= ways_0_data_symbol11[dataReadCmd_payload];
      _zz_ways_0_datasymbol_read_12 <= ways_0_data_symbol12[dataReadCmd_payload];
      _zz_ways_0_datasymbol_read_13 <= ways_0_data_symbol13[dataReadCmd_payload];
      _zz_ways_0_datasymbol_read_14 <= ways_0_data_symbol14[dataReadCmd_payload];
      _zz_ways_0_datasymbol_read_15 <= ways_0_data_symbol15[dataReadCmd_payload];
    end
  end

  always @(posedge clk) begin
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
    if(dataWriteCmd_payload_mask[4] && _zz_3) begin
      ways_0_data_symbol4[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[39 : 32];
    end
    if(dataWriteCmd_payload_mask[5] && _zz_3) begin
      ways_0_data_symbol5[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[47 : 40];
    end
    if(dataWriteCmd_payload_mask[6] && _zz_3) begin
      ways_0_data_symbol6[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[55 : 48];
    end
    if(dataWriteCmd_payload_mask[7] && _zz_3) begin
      ways_0_data_symbol7[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[63 : 56];
    end
    if(dataWriteCmd_payload_mask[8] && _zz_3) begin
      ways_0_data_symbol8[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[71 : 64];
    end
    if(dataWriteCmd_payload_mask[9] && _zz_3) begin
      ways_0_data_symbol9[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[79 : 72];
    end
    if(dataWriteCmd_payload_mask[10] && _zz_3) begin
      ways_0_data_symbol10[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[87 : 80];
    end
    if(dataWriteCmd_payload_mask[11] && _zz_3) begin
      ways_0_data_symbol11[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[95 : 88];
    end
    if(dataWriteCmd_payload_mask[12] && _zz_3) begin
      ways_0_data_symbol12[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[103 : 96];
    end
    if(dataWriteCmd_payload_mask[13] && _zz_3) begin
      ways_0_data_symbol13[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[111 : 104];
    end
    if(dataWriteCmd_payload_mask[14] && _zz_3) begin
      ways_0_data_symbol14[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[119 : 112];
    end
    if(dataWriteCmd_payload_mask[15] && _zz_3) begin
      ways_0_data_symbol15[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[127 : 120];
    end
  end

  always @(posedge clk) begin
    if(_zz_ways_1_tagsReadRsp_valid) begin
      _zz_ways_1_tags_port0 <= ways_1_tags[tagsReadCmd_payload];
    end
  end

  always @(posedge clk) begin
    if(_zz_2) begin
      ways_1_tags[tagsWriteCmd_payload_address] <= _zz_ways_1_tags_port;
    end
  end

  always @(*) begin
    _zz_ways_1_data_port0 = {_zz_ways_1_datasymbol_read_15, _zz_ways_1_datasymbol_read_14, _zz_ways_1_datasymbol_read_13, _zz_ways_1_datasymbol_read_12, _zz_ways_1_datasymbol_read_11, _zz_ways_1_datasymbol_read_10, _zz_ways_1_datasymbol_read_9, _zz_ways_1_datasymbol_read_8, _zz_ways_1_datasymbol_read_7, _zz_ways_1_datasymbol_read_6, _zz_ways_1_datasymbol_read_5, _zz_ways_1_datasymbol_read_4, _zz_ways_1_datasymbol_read_3, _zz_ways_1_datasymbol_read_2, _zz_ways_1_datasymbol_read_1, _zz_ways_1_datasymbol_read};
  end
  always @(posedge clk) begin
    if(_zz_ways_1_dataReadRspMem) begin
      _zz_ways_1_datasymbol_read <= ways_1_data_symbol0[dataReadCmd_payload];
      _zz_ways_1_datasymbol_read_1 <= ways_1_data_symbol1[dataReadCmd_payload];
      _zz_ways_1_datasymbol_read_2 <= ways_1_data_symbol2[dataReadCmd_payload];
      _zz_ways_1_datasymbol_read_3 <= ways_1_data_symbol3[dataReadCmd_payload];
      _zz_ways_1_datasymbol_read_4 <= ways_1_data_symbol4[dataReadCmd_payload];
      _zz_ways_1_datasymbol_read_5 <= ways_1_data_symbol5[dataReadCmd_payload];
      _zz_ways_1_datasymbol_read_6 <= ways_1_data_symbol6[dataReadCmd_payload];
      _zz_ways_1_datasymbol_read_7 <= ways_1_data_symbol7[dataReadCmd_payload];
      _zz_ways_1_datasymbol_read_8 <= ways_1_data_symbol8[dataReadCmd_payload];
      _zz_ways_1_datasymbol_read_9 <= ways_1_data_symbol9[dataReadCmd_payload];
      _zz_ways_1_datasymbol_read_10 <= ways_1_data_symbol10[dataReadCmd_payload];
      _zz_ways_1_datasymbol_read_11 <= ways_1_data_symbol11[dataReadCmd_payload];
      _zz_ways_1_datasymbol_read_12 <= ways_1_data_symbol12[dataReadCmd_payload];
      _zz_ways_1_datasymbol_read_13 <= ways_1_data_symbol13[dataReadCmd_payload];
      _zz_ways_1_datasymbol_read_14 <= ways_1_data_symbol14[dataReadCmd_payload];
      _zz_ways_1_datasymbol_read_15 <= ways_1_data_symbol15[dataReadCmd_payload];
    end
  end

  always @(posedge clk) begin
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
    if(dataWriteCmd_payload_mask[4] && _zz_1) begin
      ways_1_data_symbol4[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[39 : 32];
    end
    if(dataWriteCmd_payload_mask[5] && _zz_1) begin
      ways_1_data_symbol5[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[47 : 40];
    end
    if(dataWriteCmd_payload_mask[6] && _zz_1) begin
      ways_1_data_symbol6[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[55 : 48];
    end
    if(dataWriteCmd_payload_mask[7] && _zz_1) begin
      ways_1_data_symbol7[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[63 : 56];
    end
    if(dataWriteCmd_payload_mask[8] && _zz_1) begin
      ways_1_data_symbol8[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[71 : 64];
    end
    if(dataWriteCmd_payload_mask[9] && _zz_1) begin
      ways_1_data_symbol9[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[79 : 72];
    end
    if(dataWriteCmd_payload_mask[10] && _zz_1) begin
      ways_1_data_symbol10[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[87 : 80];
    end
    if(dataWriteCmd_payload_mask[11] && _zz_1) begin
      ways_1_data_symbol11[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[95 : 88];
    end
    if(dataWriteCmd_payload_mask[12] && _zz_1) begin
      ways_1_data_symbol12[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[103 : 96];
    end
    if(dataWriteCmd_payload_mask[13] && _zz_1) begin
      ways_1_data_symbol13[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[111 : 104];
    end
    if(dataWriteCmd_payload_mask[14] && _zz_1) begin
      ways_1_data_symbol14[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[119 : 112];
    end
    if(dataWriteCmd_payload_mask[15] && _zz_1) begin
      ways_1_data_symbol15[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[127 : 120];
    end
  end

  always @(*) begin
    _zz_1 = 1'b0;
    if(when_DataCache_l639_1) begin
      _zz_1 = 1'b1;
    end
  end

  always @(*) begin
    _zz_2 = 1'b0;
    if(when_DataCache_l636_1) begin
      _zz_2 = 1'b1;
    end
  end

  always @(*) begin
    _zz_3 = 1'b0;
    if(when_DataCache_l639) begin
      _zz_3 = 1'b1;
    end
  end

  always @(*) begin
    _zz_4 = 1'b0;
    if(when_DataCache_l636) begin
      _zz_4 = 1'b1;
    end
  end

  assign haltCpu = 1'b0;
  assign _zz_ways_0_tagsReadRsp_valid = (tagsReadCmd_valid && (! io_cpu_memory_isStuck));
  assign _zz_ways_0_tagsReadRsp_valid_1 = _zz_ways_0_tags_port0;
  assign ways_0_tagsReadRsp_valid = _zz_ways_0_tagsReadRsp_valid_1[0];
  assign ways_0_tagsReadRsp_error = _zz_ways_0_tagsReadRsp_valid_1[1];
  assign ways_0_tagsReadRsp_address = _zz_ways_0_tagsReadRsp_valid_1[25 : 2];
  assign _zz_ways_0_dataReadRspMem = (dataReadCmd_valid && (! io_cpu_memory_isStuck));
  assign ways_0_dataReadRspMem = _zz_ways_0_data_port0;
  assign ways_0_dataReadRsp = ways_0_dataReadRspMem[127 : 0];
  assign when_DataCache_l636 = (tagsWriteCmd_valid && tagsWriteCmd_payload_way[0]);
  assign when_DataCache_l639 = (dataWriteCmd_valid && dataWriteCmd_payload_way[0]);
  assign _zz_ways_1_tagsReadRsp_valid = (tagsReadCmd_valid && (! io_cpu_memory_isStuck));
  assign _zz_ways_1_tagsReadRsp_valid_1 = _zz_ways_1_tags_port0;
  assign ways_1_tagsReadRsp_valid = _zz_ways_1_tagsReadRsp_valid_1[0];
  assign ways_1_tagsReadRsp_error = _zz_ways_1_tagsReadRsp_valid_1[1];
  assign ways_1_tagsReadRsp_address = _zz_ways_1_tagsReadRsp_valid_1[25 : 2];
  assign _zz_ways_1_dataReadRspMem = (dataReadCmd_valid && (! io_cpu_memory_isStuck));
  assign ways_1_dataReadRspMem = _zz_ways_1_data_port0;
  assign ways_1_dataReadRsp = ways_1_dataReadRspMem[127 : 0];
  assign when_DataCache_l636_1 = (tagsWriteCmd_valid && tagsWriteCmd_payload_way[1]);
  assign when_DataCache_l639_1 = (dataWriteCmd_valid && dataWriteCmd_payload_way[1]);
  always @(*) begin
    tagsReadCmd_valid = 1'b0;
    if(when_DataCache_l658) begin
      tagsReadCmd_valid = 1'b1;
    end
  end

  always @(*) begin
    tagsReadCmd_payload = 3'bxxx;
    if(when_DataCache_l658) begin
      tagsReadCmd_payload = io_cpu_execute_address[7 : 5];
    end
  end

  always @(*) begin
    dataReadCmd_valid = 1'b0;
    if(when_DataCache_l658) begin
      dataReadCmd_valid = 1'b1;
    end
  end

  always @(*) begin
    dataReadCmd_payload = 4'bxxxx;
    if(when_DataCache_l658) begin
      dataReadCmd_payload = io_cpu_execute_address[7 : 4];
    end
  end

  always @(*) begin
    tagsWriteCmd_valid = 1'b0;
    if(when_DataCache_l844) begin
      tagsWriteCmd_valid = 1'b1;
    end
    if(when_DataCache_l1054) begin
      tagsWriteCmd_valid = 1'b0;
    end
    if(loader_done) begin
      tagsWriteCmd_valid = 1'b1;
    end
  end

  always @(*) begin
    tagsWriteCmd_payload_way = 2'bxx;
    if(when_DataCache_l844) begin
      tagsWriteCmd_payload_way = 2'b11;
    end
    if(loader_done) begin
      tagsWriteCmd_payload_way = loader_waysAllocator;
    end
  end

  always @(*) begin
    tagsWriteCmd_payload_address = 3'bxxx;
    if(when_DataCache_l844) begin
      tagsWriteCmd_payload_address = stageB_flusher_counter[2:0];
    end
    if(loader_done) begin
      tagsWriteCmd_payload_address = stageB_mmuRsp_physicalAddress[7 : 5];
    end
  end

  always @(*) begin
    tagsWriteCmd_payload_data_valid = 1'bx;
    if(when_DataCache_l844) begin
      tagsWriteCmd_payload_data_valid = 1'b0;
    end
    if(loader_done) begin
      tagsWriteCmd_payload_data_valid = (! (loader_kill || loader_killReg));
    end
  end

  always @(*) begin
    tagsWriteCmd_payload_data_error = 1'bx;
    if(loader_done) begin
      tagsWriteCmd_payload_data_error = (loader_error || (io_mem_rsp_valid && io_mem_rsp_payload_error));
    end
  end

  always @(*) begin
    tagsWriteCmd_payload_data_address = 24'bxxxxxxxxxxxxxxxxxxxxxxxx;
    if(loader_done) begin
      tagsWriteCmd_payload_data_address = stageB_mmuRsp_physicalAddress[31 : 8];
    end
  end

  always @(*) begin
    dataWriteCmd_valid = 1'b0;
    if(stageB_cpuWriteToCache) begin
      if(when_DataCache_l914) begin
        dataWriteCmd_valid = 1'b1;
      end
    end
    if(when_DataCache_l1054) begin
      dataWriteCmd_valid = 1'b0;
    end
    if(when_DataCache_l1078) begin
      dataWriteCmd_valid = 1'b1;
    end
  end

  always @(*) begin
    dataWriteCmd_payload_way = 2'bxx;
    if(stageB_cpuWriteToCache) begin
      dataWriteCmd_payload_way = stageB_waysHits;
    end
    if(when_DataCache_l1078) begin
      dataWriteCmd_payload_way = loader_waysAllocator;
    end
  end

  always @(*) begin
    dataWriteCmd_payload_address = 4'bxxxx;
    if(stageB_cpuWriteToCache) begin
      dataWriteCmd_payload_address = stageB_mmuRsp_physicalAddress[7 : 4];
    end
    if(when_DataCache_l1078) begin
      dataWriteCmd_payload_address = {stageB_mmuRsp_physicalAddress[7 : 5],loader_counter_value};
    end
  end

  always @(*) begin
    dataWriteCmd_payload_data = 128'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
    if(stageB_cpuWriteToCache) begin
      dataWriteCmd_payload_data[127 : 0] = stageB_requestDataBypass;
    end
    if(when_DataCache_l1078) begin
      dataWriteCmd_payload_data = io_mem_rsp_payload_data;
    end
  end

  always @(*) begin
    dataWriteCmd_payload_mask = 16'bxxxxxxxxxxxxxxxx;
    if(stageB_cpuWriteToCache) begin
      dataWriteCmd_payload_mask = 16'h0;
      if(_zz_when[0]) begin
        dataWriteCmd_payload_mask[15 : 0] = stageB_mask;
      end
    end
    if(when_DataCache_l1078) begin
      dataWriteCmd_payload_mask = 16'hffff;
    end
  end

  assign when_DataCache_l658 = (io_cpu_execute_isValid && (! io_cpu_memory_isStuck));
  always @(*) begin
    io_cpu_execute_haltIt = 1'b0;
    if(when_DataCache_l844) begin
      io_cpu_execute_haltIt = 1'b1;
    end
  end

  assign rspSync = 1'b1;
  assign rspLast = 1'b1;
  assign io_mem_cmd_fire = (io_mem_cmd_valid && io_mem_cmd_ready);
  assign when_DataCache_l680 = (! io_cpu_writeBack_isStuck);
  always @(*) begin
    _zz_stage0_mask = 16'bxxxxxxxxxxxxxxxx;
    case(io_cpu_execute_args_size)
      3'b000 : begin
        _zz_stage0_mask = 16'h0001;
      end
      3'b001 : begin
        _zz_stage0_mask = 16'h0003;
      end
      3'b010 : begin
        _zz_stage0_mask = 16'h000f;
      end
      3'b011 : begin
        _zz_stage0_mask = 16'h00ff;
      end
      3'b100 : begin
        _zz_stage0_mask = 16'hffff;
      end
      default : begin
      end
    endcase
  end

  assign stage0_mask = (_zz_stage0_mask <<< io_cpu_execute_address[3 : 0]);
  assign _zz_stage0_dataColisions = (io_cpu_execute_address[7 : 4] >>> 0);
  assign _zz_stage0_dataColisions_1 = dataWriteCmd_payload_mask[15 : 0];
  always @(*) begin
    stage0_dataColisions[0] = (((dataWriteCmd_valid && dataWriteCmd_payload_way[0]) && (dataWriteCmd_payload_address == _zz_stage0_dataColisions)) && ((stage0_mask & _zz_stage0_dataColisions_1) != 16'h0));
    stage0_dataColisions[1] = (((dataWriteCmd_valid && dataWriteCmd_payload_way[1]) && (dataWriteCmd_payload_address == _zz_stage0_dataColisions)) && ((stage0_mask & _zz_stage0_dataColisions_1) != 16'h0));
  end

  assign stage0_wayInvalidate = 2'b00;
  assign stage0_isAmo = 1'b0;
  assign when_DataCache_l765 = (! io_cpu_memory_isStuck);
  assign when_DataCache_l765_1 = (! io_cpu_memory_isStuck);
  assign io_cpu_memory_isWrite = stageA_request_wr;
  assign stageA_isAmo = 1'b0;
  assign stageA_isLrsc = 1'b0;
  assign stageA_wayHits = {((io_cpu_memory_mmuRsp_physicalAddress[31 : 8] == ways_1_tagsReadRsp_address) && ways_1_tagsReadRsp_valid),((io_cpu_memory_mmuRsp_physicalAddress[31 : 8] == ways_0_tagsReadRsp_address) && ways_0_tagsReadRsp_valid)};
  assign when_DataCache_l765_2 = (! io_cpu_memory_isStuck);
  assign when_DataCache_l765_3 = (! io_cpu_memory_isStuck);
  assign _zz_stageA_dataColisions_1 = (io_cpu_memory_address[7 : 4] >>> 0);
  assign _zz_stageA_dataColisions_2 = dataWriteCmd_payload_mask[15 : 0];
  always @(*) begin
    _zz_stageA_dataColisions[0] = (((dataWriteCmd_valid && dataWriteCmd_payload_way[0]) && (dataWriteCmd_payload_address == _zz_stageA_dataColisions_1)) && ((stageA_mask & _zz_stageA_dataColisions_2) != 16'h0));
    _zz_stageA_dataColisions[1] = (((dataWriteCmd_valid && dataWriteCmd_payload_way[1]) && (dataWriteCmd_payload_address == _zz_stageA_dataColisions_1)) && ((stageA_mask & _zz_stageA_dataColisions_2) != 16'h0));
  end

  assign stageA_dataColisions = (stage0_dataColisions_regNextWhen | _zz_stageA_dataColisions);
  assign when_DataCache_l816 = (! io_cpu_writeBack_isStuck);
  always @(*) begin
    stageB_mmuRspFreeze = 1'b0;
    if(when_DataCache_l1113) begin
      stageB_mmuRspFreeze = 1'b1;
    end
  end

  assign when_DataCache_l818 = ((! io_cpu_writeBack_isStuck) && (! stageB_mmuRspFreeze));
  assign when_DataCache_l815 = (! io_cpu_writeBack_isStuck);
  assign when_DataCache_l815_1 = (! io_cpu_writeBack_isStuck);
  assign when_DataCache_l815_2 = (! io_cpu_writeBack_isStuck);
  assign when_DataCache_l815_3 = (! io_cpu_writeBack_isStuck);
  assign when_DataCache_l814 = (! io_cpu_writeBack_isStuck);
  assign stageB_consistancyHazard = 1'b0;
  assign when_DataCache_l814_1 = (! io_cpu_writeBack_isStuck);
  assign stageB_unaligned = 1'b0;
  assign when_DataCache_l814_2 = (! io_cpu_writeBack_isStuck);
  assign stageB_waysHits = (stageB_waysHitsBeforeInvalidate & (~ stageB_wayInvalidate));
  assign stageB_waysHit = (|stageB_waysHits);
  assign stageB_dataMux = (stageB_waysHits[0] ? stageB_dataReadRsp_0 : stageB_dataReadRsp_1);
  assign when_DataCache_l814_3 = (! io_cpu_writeBack_isStuck);
  always @(*) begin
    stageB_loaderValid = 1'b0;
    if(io_cpu_writeBack_isValid) begin
      if(!stageB_isExternalAmo) begin
        if(!when_DataCache_l979) begin
          if(!when_DataCache_l992) begin
            if(io_mem_cmd_ready) begin
              stageB_loaderValid = 1'b1;
            end
          end
        end
      end
    end
    if(when_DataCache_l1054) begin
      stageB_loaderValid = 1'b0;
    end
  end

  assign stageB_ioMemRspMuxed = io_mem_rsp_payload_data[127 : 0];
  always @(*) begin
    io_cpu_writeBack_haltIt = 1'b1;
    if(io_cpu_writeBack_isValid) begin
      if(!stageB_isExternalAmo) begin
        if(when_DataCache_l979) begin
          if(when_DataCache_l983) begin
            io_cpu_writeBack_haltIt = 1'b0;
          end
        end else begin
          if(when_DataCache_l992) begin
            if(when_DataCache_l997) begin
              io_cpu_writeBack_haltIt = 1'b0;
            end
          end
        end
      end
    end
    if(when_DataCache_l1054) begin
      io_cpu_writeBack_haltIt = 1'b0;
    end
  end

  assign stageB_flusher_hold = 1'b0;
  assign when_DataCache_l844 = (! stageB_flusher_counter[3]);
  assign when_DataCache_l850 = (! stageB_flusher_hold);
  assign io_cpu_flush_ready = (stageB_flusher_waitDone && stageB_flusher_counter[3]);
  assign stageB_isAmo = 1'b0;
  assign stageB_isAmoCached = 1'b0;
  assign stageB_isExternalLsrc = 1'b0;
  assign stageB_isExternalAmo = 1'b0;
  assign stageB_requestDataBypass = io_cpu_writeBack_storeData;
  always @(*) begin
    stageB_cpuWriteToCache = 1'b0;
    if(io_cpu_writeBack_isValid) begin
      if(!stageB_isExternalAmo) begin
        if(!when_DataCache_l979) begin
          if(when_DataCache_l992) begin
            stageB_cpuWriteToCache = 1'b1;
          end
        end
      end
    end
  end

  assign when_DataCache_l914 = (stageB_request_wr && stageB_waysHit);
  assign stageB_badPermissions = (((! stageB_mmuRsp_allowWrite) && stageB_request_wr) || ((! stageB_mmuRsp_allowRead) && ((! stageB_request_wr) || stageB_isAmo)));
  assign stageB_loadStoreFault = (io_cpu_writeBack_isValid && (stageB_mmuRsp_exception || stageB_badPermissions));
  always @(*) begin
    io_cpu_redo = 1'b0;
    if(io_cpu_writeBack_isValid) begin
      if(!stageB_isExternalAmo) begin
        if(!when_DataCache_l979) begin
          if(when_DataCache_l992) begin
            if(when_DataCache_l1008) begin
              io_cpu_redo = 1'b1;
            end
          end
        end
      end
    end
    if(when_DataCache_l1063) begin
      io_cpu_redo = 1'b1;
    end
    if(when_DataCache_l1110) begin
      io_cpu_redo = 1'b1;
    end
  end

  assign io_cpu_writeBack_accessError = 1'b0;
  assign io_cpu_writeBack_mmuException = (stageB_loadStoreFault && 1'b0);
  assign io_cpu_writeBack_unalignedAccess = (io_cpu_writeBack_isValid && stageB_unaligned);
  assign io_cpu_writeBack_isWrite = stageB_request_wr;
  always @(*) begin
    io_mem_cmd_valid = 1'b0;
    if(io_cpu_writeBack_isValid) begin
      if(!stageB_isExternalAmo) begin
        if(when_DataCache_l979) begin
          io_mem_cmd_valid = (! memCmdSent);
        end else begin
          if(when_DataCache_l992) begin
            if(stageB_request_wr) begin
              io_mem_cmd_valid = 1'b1;
            end
          end else begin
            if(when_DataCache_l1020) begin
              io_mem_cmd_valid = 1'b1;
            end
          end
        end
      end
    end
    if(when_DataCache_l1054) begin
      io_mem_cmd_valid = 1'b0;
    end
  end

  always @(*) begin
    io_mem_cmd_payload_address = stageB_mmuRsp_physicalAddress;
    if(io_cpu_writeBack_isValid) begin
      if(!stageB_isExternalAmo) begin
        if(!when_DataCache_l979) begin
          if(!when_DataCache_l992) begin
            io_mem_cmd_payload_address[4 : 0] = 5'h0;
          end
        end
      end
    end
  end

  assign io_mem_cmd_payload_last = 1'b1;
  always @(*) begin
    io_mem_cmd_payload_wr = stageB_request_wr;
    if(io_cpu_writeBack_isValid) begin
      if(!stageB_isExternalAmo) begin
        if(!when_DataCache_l979) begin
          if(!when_DataCache_l992) begin
            io_mem_cmd_payload_wr = 1'b0;
          end
        end
      end
    end
  end

  assign io_mem_cmd_payload_mask = stageB_mask;
  assign io_mem_cmd_payload_data = stageB_requestDataBypass;
  assign io_mem_cmd_payload_uncached = stageB_mmuRsp_isIoAccess;
  always @(*) begin
    io_mem_cmd_payload_size = stageB_request_size;
    if(io_cpu_writeBack_isValid) begin
      if(!stageB_isExternalAmo) begin
        if(!when_DataCache_l979) begin
          if(!when_DataCache_l992) begin
            io_mem_cmd_payload_size = 3'b101;
          end
        end
      end
    end
  end

  assign stageB_bypassCache = ((stageB_mmuRsp_isIoAccess || stageB_isExternalLsrc) || stageB_isExternalAmo);
  assign io_cpu_writeBack_keepMemRspData = 1'b0;
  assign when_DataCache_l983 = ((! stageB_request_wr) ? (io_mem_rsp_valid && rspSync) : io_mem_cmd_ready);
  assign when_DataCache_l992 = (stageB_waysHit || (stageB_request_wr && (! stageB_isAmoCached)));
  assign when_DataCache_l997 = ((! stageB_request_wr) || io_mem_cmd_ready);
  assign when_DataCache_l1008 = (((! stageB_request_wr) || stageB_isAmoCached) && ((stageB_dataColisions & stageB_waysHits) != 2'b00));
  assign when_DataCache_l1020 = (! memCmdSent);
  assign when_DataCache_l979 = (stageB_mmuRsp_isIoAccess || stageB_isExternalLsrc);
  always @(*) begin
    if(stageB_bypassCache) begin
      io_cpu_writeBack_data = stageB_ioMemRspMuxed;
    end else begin
      io_cpu_writeBack_data = stageB_dataMux;
    end
  end

  assign when_DataCache_l1054 = ((((stageB_consistancyHazard || stageB_mmuRsp_refilling) || io_cpu_writeBack_accessError) || io_cpu_writeBack_mmuException) || io_cpu_writeBack_unalignedAccess);
  assign when_DataCache_l1063 = (io_cpu_writeBack_isValid && (stageB_mmuRsp_refilling || stageB_consistancyHazard));
  always @(*) begin
    loader_counter_willIncrement = 1'b0;
    if(when_DataCache_l1078) begin
      loader_counter_willIncrement = 1'b1;
    end
  end

  assign loader_counter_willClear = 1'b0;
  assign loader_counter_willOverflowIfInc = (loader_counter_value == 1'b1);
  assign loader_counter_willOverflow = (loader_counter_willOverflowIfInc && loader_counter_willIncrement);
  always @(*) begin
    loader_counter_valueNext = (loader_counter_value + loader_counter_willIncrement);
    if(loader_counter_willClear) begin
      loader_counter_valueNext = 1'b0;
    end
  end

  assign loader_kill = 1'b0;
  assign when_DataCache_l1078 = ((loader_valid && io_mem_rsp_valid) && rspLast);
  assign loader_done = loader_counter_willOverflow;
  assign when_DataCache_l1106 = (! loader_valid);
  assign when_DataCache_l1110 = (loader_valid && (! loader_valid_regNext));
  assign io_cpu_execute_refilling = loader_valid;
  assign when_DataCache_l1113 = (stageB_loaderValid || loader_valid);
  always @(posedge clk) begin
    tagsWriteLastCmd_valid <= tagsWriteCmd_valid;
    tagsWriteLastCmd_payload_way <= tagsWriteCmd_payload_way;
    tagsWriteLastCmd_payload_address <= tagsWriteCmd_payload_address;
    tagsWriteLastCmd_payload_data_valid <= tagsWriteCmd_payload_data_valid;
    tagsWriteLastCmd_payload_data_error <= tagsWriteCmd_payload_data_error;
    tagsWriteLastCmd_payload_data_address <= tagsWriteCmd_payload_data_address;
    if(when_DataCache_l765) begin
      stageA_request_wr <= io_cpu_execute_args_wr;
      stageA_request_size <= io_cpu_execute_args_size;
      stageA_request_totalyConsistent <= io_cpu_execute_args_totalyConsistent;
    end
    if(when_DataCache_l765_1) begin
      stageA_mask <= stage0_mask;
    end
    if(when_DataCache_l765_2) begin
      stageA_wayInvalidate <= stage0_wayInvalidate;
    end
    if(when_DataCache_l765_3) begin
      stage0_dataColisions_regNextWhen <= stage0_dataColisions;
    end
    if(when_DataCache_l816) begin
      stageB_request_wr <= stageA_request_wr;
      stageB_request_size <= stageA_request_size;
      stageB_request_totalyConsistent <= stageA_request_totalyConsistent;
    end
    if(when_DataCache_l818) begin
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
    if(when_DataCache_l815) begin
      stageB_tagsReadRsp_0_valid <= ways_0_tagsReadRsp_valid;
      stageB_tagsReadRsp_0_error <= ways_0_tagsReadRsp_error;
      stageB_tagsReadRsp_0_address <= ways_0_tagsReadRsp_address;
    end
    if(when_DataCache_l815_1) begin
      stageB_tagsReadRsp_1_valid <= ways_1_tagsReadRsp_valid;
      stageB_tagsReadRsp_1_error <= ways_1_tagsReadRsp_error;
      stageB_tagsReadRsp_1_address <= ways_1_tagsReadRsp_address;
    end
    if(when_DataCache_l815_2) begin
      stageB_dataReadRsp_0 <= ways_0_dataReadRsp;
    end
    if(when_DataCache_l815_3) begin
      stageB_dataReadRsp_1 <= ways_1_dataReadRsp;
    end
    if(when_DataCache_l814) begin
      stageB_wayInvalidate <= stageA_wayInvalidate;
    end
    if(when_DataCache_l814_1) begin
      stageB_dataColisions <= stageA_dataColisions;
    end
    if(when_DataCache_l814_2) begin
      stageB_waysHitsBeforeInvalidate <= stageA_wayHits;
    end
    if(when_DataCache_l814_3) begin
      stageB_mask <= stageA_mask;
    end
    loader_valid_regNext <= loader_valid;
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      memCmdSent <= 1'b0;
      stageB_flusher_waitDone <= 1'b0;
      stageB_flusher_counter <= 4'b0000;
      stageB_flusher_start <= 1'b1;
      loader_valid <= 1'b0;
      loader_counter_value <= 1'b0;
      loader_waysAllocator <= 2'b01;
      loader_error <= 1'b0;
      loader_killReg <= 1'b0;
    end else begin
      if(io_mem_cmd_fire) begin
        memCmdSent <= 1'b1;
      end
      if(when_DataCache_l680) begin
        memCmdSent <= 1'b0;
      end
      if(io_cpu_flush_ready) begin
        stageB_flusher_waitDone <= 1'b0;
      end
      if(when_DataCache_l844) begin
        if(when_DataCache_l850) begin
          stageB_flusher_counter <= (stageB_flusher_counter + 4'b0001);
        end
      end
      stageB_flusher_start <= (((((((! stageB_flusher_waitDone) && (! stageB_flusher_start)) && io_cpu_flush_valid) && (! io_cpu_execute_isValid)) && (! io_cpu_memory_isValid)) && (! io_cpu_writeBack_isValid)) && (! io_cpu_redo));
      if(stageB_flusher_start) begin
        stageB_flusher_waitDone <= 1'b1;
        stageB_flusher_counter <= 4'b0000;
      end
      `ifndef SYNTHESIS
        `ifdef FORMAL
          assert((! ((io_cpu_writeBack_isValid && (! io_cpu_writeBack_haltIt)) && io_cpu_writeBack_isStuck))); // DataCache.scala:L1065
        `else
          if(!(! ((io_cpu_writeBack_isValid && (! io_cpu_writeBack_haltIt)) && io_cpu_writeBack_isStuck))) begin
            $display("ERROR writeBack stuck by another plugin is not allowed"); // DataCache.scala:L1065
          end
        `endif
      `endif
      if(stageB_loaderValid) begin
        loader_valid <= 1'b1;
      end
      loader_counter_value <= loader_counter_valueNext;
      if(loader_kill) begin
        loader_killReg <= 1'b1;
      end
      if(when_DataCache_l1078) begin
        loader_error <= (loader_error || io_mem_rsp_payload_error);
      end
      if(loader_done) begin
        loader_valid <= 1'b0;
        loader_error <= 1'b0;
        loader_killReg <= 1'b0;
      end
      if(when_DataCache_l1106) begin
        loader_waysAllocator <= _zz_loader_waysAllocator[1:0];
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

  reg        [31:0]   _zz_banks_0_port1;
  reg        [24:0]   _zz_ways_0_tags_port1;
  wire       [24:0]   _zz_ways_0_tags_port;
  reg                 _zz_1;
  reg                 _zz_2;
  reg                 lineLoader_fire;
  reg                 lineLoader_valid;
  (* keep , syn_keep *) reg        [31:0]   lineLoader_address /* synthesis syn_keep = 1 */ ;
  reg                 lineLoader_hadError;
  reg                 lineLoader_flushPending;
  reg        [4:0]    lineLoader_flushCounter;
  wire                when_InstructionCache_l338;
  reg                 _zz_when_InstructionCache_l342;
  wire                when_InstructionCache_l342;
  wire                when_InstructionCache_l351;
  reg                 lineLoader_cmdSent;
  wire                io_mem_cmd_fire;
  wire                when_Utils_l513;
  reg                 lineLoader_wayToAllocate_willIncrement;
  wire                lineLoader_wayToAllocate_willClear;
  wire                lineLoader_wayToAllocate_willOverflowIfInc;
  wire                lineLoader_wayToAllocate_willOverflow;
  (* keep , syn_keep *) reg        [2:0]    lineLoader_wordIndex /* synthesis syn_keep = 1 */ ;
  wire                lineLoader_write_tag_0_valid;
  wire       [3:0]    lineLoader_write_tag_0_payload_address;
  wire                lineLoader_write_tag_0_payload_data_valid;
  wire                lineLoader_write_tag_0_payload_data_error;
  wire       [22:0]   lineLoader_write_tag_0_payload_data_address;
  wire                lineLoader_write_data_0_valid;
  wire       [6:0]    lineLoader_write_data_0_payload_address;
  wire       [31:0]   lineLoader_write_data_0_payload_data;
  wire                when_InstructionCache_l401;
  wire       [6:0]    _zz_fetchStage_read_banksValue_0_dataMem;
  wire                _zz_fetchStage_read_banksValue_0_dataMem_1;
  wire       [31:0]   fetchStage_read_banksValue_0_dataMem;
  wire       [31:0]   fetchStage_read_banksValue_0_data;
  wire       [3:0]    _zz_fetchStage_read_waysValues_0_tag_valid;
  wire                _zz_fetchStage_read_waysValues_0_tag_valid_1;
  wire                fetchStage_read_waysValues_0_tag_valid;
  wire                fetchStage_read_waysValues_0_tag_error;
  wire       [22:0]   fetchStage_read_waysValues_0_tag_address;
  wire       [24:0]   _zz_fetchStage_read_waysValues_0_tag_valid_2;
  wire                fetchStage_hit_hits_0;
  wire                fetchStage_hit_valid;
  wire                fetchStage_hit_error;
  wire       [31:0]   fetchStage_hit_data;
  wire       [31:0]   fetchStage_hit_word;
  wire                when_InstructionCache_l435;
  reg        [31:0]   io_cpu_fetch_data_regNextWhen;
  wire                when_InstructionCache_l459;
  reg        [31:0]   decodeStage_mmuRsp_physicalAddress;
  reg                 decodeStage_mmuRsp_isIoAccess;
  reg                 decodeStage_mmuRsp_isPaging;
  reg                 decodeStage_mmuRsp_allowRead;
  reg                 decodeStage_mmuRsp_allowWrite;
  reg                 decodeStage_mmuRsp_allowExecute;
  reg                 decodeStage_mmuRsp_exception;
  reg                 decodeStage_mmuRsp_refilling;
  reg                 decodeStage_mmuRsp_bypassTranslation;
  wire                when_InstructionCache_l459_1;
  reg                 decodeStage_hit_valid;
  wire                when_InstructionCache_l459_2;
  reg                 decodeStage_hit_error;
  reg [31:0] banks_0 [0:127];
  reg [24:0] ways_0_tags [0:15];

  assign _zz_ways_0_tags_port = {lineLoader_write_tag_0_payload_data_address,{lineLoader_write_tag_0_payload_data_error,lineLoader_write_tag_0_payload_data_valid}};
  always @(posedge clk) begin
    if(_zz_1) begin
      banks_0[lineLoader_write_data_0_payload_address] <= lineLoader_write_data_0_payload_data;
    end
  end

  always @(posedge clk) begin
    if(_zz_fetchStage_read_banksValue_0_dataMem_1) begin
      _zz_banks_0_port1 <= banks_0[_zz_fetchStage_read_banksValue_0_dataMem];
    end
  end

  always @(posedge clk) begin
    if(_zz_2) begin
      ways_0_tags[lineLoader_write_tag_0_payload_address] <= _zz_ways_0_tags_port;
    end
  end

  always @(posedge clk) begin
    if(_zz_fetchStage_read_waysValues_0_tag_valid_1) begin
      _zz_ways_0_tags_port1 <= ways_0_tags[_zz_fetchStage_read_waysValues_0_tag_valid];
    end
  end

  always @(*) begin
    _zz_1 = 1'b0;
    if(lineLoader_write_data_0_valid) begin
      _zz_1 = 1'b1;
    end
  end

  always @(*) begin
    _zz_2 = 1'b0;
    if(lineLoader_write_tag_0_valid) begin
      _zz_2 = 1'b1;
    end
  end

  always @(*) begin
    lineLoader_fire = 1'b0;
    if(io_mem_rsp_valid) begin
      if(when_InstructionCache_l401) begin
        lineLoader_fire = 1'b1;
      end
    end
  end

  always @(*) begin
    io_cpu_prefetch_haltIt = (lineLoader_valid || lineLoader_flushPending);
    if(when_InstructionCache_l338) begin
      io_cpu_prefetch_haltIt = 1'b1;
    end
    if(when_InstructionCache_l342) begin
      io_cpu_prefetch_haltIt = 1'b1;
    end
    if(io_flush) begin
      io_cpu_prefetch_haltIt = 1'b1;
    end
  end

  assign when_InstructionCache_l338 = (! lineLoader_flushCounter[4]);
  assign when_InstructionCache_l342 = (! _zz_when_InstructionCache_l342);
  assign when_InstructionCache_l351 = (lineLoader_flushPending && (! (lineLoader_valid || io_cpu_fetch_isValid)));
  assign io_mem_cmd_fire = (io_mem_cmd_valid && io_mem_cmd_ready);
  assign io_mem_cmd_valid = (lineLoader_valid && (! lineLoader_cmdSent));
  assign io_mem_cmd_payload_address = {lineLoader_address[31 : 5],5'h0};
  assign io_mem_cmd_payload_size = 3'b101;
  assign when_Utils_l513 = (! lineLoader_valid);
  always @(*) begin
    lineLoader_wayToAllocate_willIncrement = 1'b0;
    if(when_Utils_l513) begin
      lineLoader_wayToAllocate_willIncrement = 1'b1;
    end
  end

  assign lineLoader_wayToAllocate_willClear = 1'b0;
  assign lineLoader_wayToAllocate_willOverflowIfInc = 1'b1;
  assign lineLoader_wayToAllocate_willOverflow = (lineLoader_wayToAllocate_willOverflowIfInc && lineLoader_wayToAllocate_willIncrement);
  assign lineLoader_write_tag_0_valid = ((1'b1 && lineLoader_fire) || (! lineLoader_flushCounter[4]));
  assign lineLoader_write_tag_0_payload_address = (lineLoader_flushCounter[4] ? lineLoader_address[8 : 5] : lineLoader_flushCounter[3 : 0]);
  assign lineLoader_write_tag_0_payload_data_valid = lineLoader_flushCounter[4];
  assign lineLoader_write_tag_0_payload_data_error = (lineLoader_hadError || io_mem_rsp_payload_error);
  assign lineLoader_write_tag_0_payload_data_address = lineLoader_address[31 : 9];
  assign lineLoader_write_data_0_valid = (io_mem_rsp_valid && 1'b1);
  assign lineLoader_write_data_0_payload_address = {lineLoader_address[8 : 5],lineLoader_wordIndex};
  assign lineLoader_write_data_0_payload_data = io_mem_rsp_payload_data;
  assign when_InstructionCache_l401 = (lineLoader_wordIndex == 3'b111);
  assign _zz_fetchStage_read_banksValue_0_dataMem = io_cpu_prefetch_pc[8 : 2];
  assign _zz_fetchStage_read_banksValue_0_dataMem_1 = (! io_cpu_fetch_isStuck);
  assign fetchStage_read_banksValue_0_dataMem = _zz_banks_0_port1;
  assign fetchStage_read_banksValue_0_data = fetchStage_read_banksValue_0_dataMem[31 : 0];
  assign _zz_fetchStage_read_waysValues_0_tag_valid = io_cpu_prefetch_pc[8 : 5];
  assign _zz_fetchStage_read_waysValues_0_tag_valid_1 = (! io_cpu_fetch_isStuck);
  assign _zz_fetchStage_read_waysValues_0_tag_valid_2 = _zz_ways_0_tags_port1;
  assign fetchStage_read_waysValues_0_tag_valid = _zz_fetchStage_read_waysValues_0_tag_valid_2[0];
  assign fetchStage_read_waysValues_0_tag_error = _zz_fetchStage_read_waysValues_0_tag_valid_2[1];
  assign fetchStage_read_waysValues_0_tag_address = _zz_fetchStage_read_waysValues_0_tag_valid_2[24 : 2];
  assign fetchStage_hit_hits_0 = (fetchStage_read_waysValues_0_tag_valid && (fetchStage_read_waysValues_0_tag_address == io_cpu_fetch_mmuRsp_physicalAddress[31 : 9]));
  assign fetchStage_hit_valid = (|fetchStage_hit_hits_0);
  assign fetchStage_hit_error = fetchStage_read_waysValues_0_tag_error;
  assign fetchStage_hit_data = fetchStage_read_banksValue_0_data;
  assign fetchStage_hit_word = fetchStage_hit_data;
  assign io_cpu_fetch_data = fetchStage_hit_word;
  assign when_InstructionCache_l435 = (! io_cpu_decode_isStuck);
  assign io_cpu_decode_data = io_cpu_fetch_data_regNextWhen;
  assign io_cpu_fetch_physicalAddress = io_cpu_fetch_mmuRsp_physicalAddress;
  assign when_InstructionCache_l459 = (! io_cpu_decode_isStuck);
  assign when_InstructionCache_l459_1 = (! io_cpu_decode_isStuck);
  assign when_InstructionCache_l459_2 = (! io_cpu_decode_isStuck);
  assign io_cpu_decode_cacheMiss = (! decodeStage_hit_valid);
  assign io_cpu_decode_error = (decodeStage_hit_error || ((! decodeStage_mmuRsp_isPaging) && (decodeStage_mmuRsp_exception || (! decodeStage_mmuRsp_allowExecute))));
  assign io_cpu_decode_mmuRefilling = decodeStage_mmuRsp_refilling;
  assign io_cpu_decode_mmuException = (((! decodeStage_mmuRsp_refilling) && decodeStage_mmuRsp_isPaging) && (decodeStage_mmuRsp_exception || (! decodeStage_mmuRsp_allowExecute)));
  assign io_cpu_decode_physicalAddress = decodeStage_mmuRsp_physicalAddress;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      lineLoader_valid <= 1'b0;
      lineLoader_hadError <= 1'b0;
      lineLoader_flushPending <= 1'b1;
      lineLoader_cmdSent <= 1'b0;
      lineLoader_wordIndex <= 3'b000;
    end else begin
      if(lineLoader_fire) begin
        lineLoader_valid <= 1'b0;
      end
      if(lineLoader_fire) begin
        lineLoader_hadError <= 1'b0;
      end
      if(io_cpu_fill_valid) begin
        lineLoader_valid <= 1'b1;
      end
      if(io_flush) begin
        lineLoader_flushPending <= 1'b1;
      end
      if(when_InstructionCache_l351) begin
        lineLoader_flushPending <= 1'b0;
      end
      if(io_mem_cmd_fire) begin
        lineLoader_cmdSent <= 1'b1;
      end
      if(lineLoader_fire) begin
        lineLoader_cmdSent <= 1'b0;
      end
      if(io_mem_rsp_valid) begin
        lineLoader_wordIndex <= (lineLoader_wordIndex + 3'b001);
        if(io_mem_rsp_payload_error) begin
          lineLoader_hadError <= 1'b1;
        end
      end
    end
  end

  always @(posedge clk) begin
    if(io_cpu_fill_valid) begin
      lineLoader_address <= io_cpu_fill_payload;
    end
    if(when_InstructionCache_l338) begin
      lineLoader_flushCounter <= (lineLoader_flushCounter + 5'h01);
    end
    _zz_when_InstructionCache_l342 <= lineLoader_flushCounter[4];
    if(when_InstructionCache_l351) begin
      lineLoader_flushCounter <= 5'h0;
    end
    if(when_InstructionCache_l435) begin
      io_cpu_fetch_data_regNextWhen <= io_cpu_fetch_data;
    end
    if(when_InstructionCache_l459) begin
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
    if(when_InstructionCache_l459_1) begin
      decodeStage_hit_valid <= fetchStage_hit_valid;
    end
    if(when_InstructionCache_l459_2) begin
      decodeStage_hit_error <= fetchStage_hit_error;
    end
  end


endmodule
