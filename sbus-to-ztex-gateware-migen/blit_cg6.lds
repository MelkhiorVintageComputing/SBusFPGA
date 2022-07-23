OUTPUT_ARCH( "riscv" )
SECTIONS
{
  . = 0x00410000;
  .text : { *(.text) }
}
