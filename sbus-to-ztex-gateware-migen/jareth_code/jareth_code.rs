#![recursion_limit="768"]

extern crate jareth_as;
use jareth_as::*;

fn main() -> std::io::Result<()> {
    let mcode = assemble_jareth!(
	// 0..0 $DST / $DST / $SRC in %0
	// 0..0 $DST / $SRC / $DST in %1
	// size in %2
	// pattern in %3
	// -----
	// size & 7 in %5
	// size rounded down in %6
	// input in %7
	// output in %8
	// 0 in %15
         start:
				resm %15
				setadr %15, %0
				load256inc %7, ^0
				load256inc %8, ^1
				// slow
				setma %15, %0, #16
				// slow
				setmq %15, %1, #16
				and %5, %2, #15
				sub32v %6, %2, %5
				brz32 done, %6
		loop:
			psa %18, %7
			psa %19, %8
				psa* %8, %7
			psa %20, %8
				store128inc %15, ^2, %8
				sub32v %6, %6, #16
				brz32 last, %6
				loadh128inc %7, ^0, %7
				loadh128inc %8, ^1, %8
				brz32 loop, #0
		last:
				// FIXME: not if Q is aligned
				loadh128inc %8, ^1, %8
				store128inc %15, ^2, %8
		done:
				getadr %3
				getm %2
				fin
				fin
	);
	
    let mcode_scroll256 = assemble_jareth!(
	// x..x / $DST / $SRC in %0, aligned on 128 bits ; $DST < $SRC
	// x..x / X size in %2, multiple of 256 bits (32 bytes)
	// x..x / Y size in %3, arbitrary
	// x..x / dst_stride / src_stride in %4 (screen width)
	// -----
	// live X count in %5
	// // live Y count in %3
	// data in %7
	// 0/scrap in %15
         start:
				// reset masks (probably not necessary with the starred-instruction)
				// resm %15
		loop_y:
				// set source and destination addresses for current Y, X=first
				setadr %15, %0
				psa %5, %2
		loop_x:
				// load from SRC w/ post-increment
				load256inc %7, ^0
				// store to DST w/ post-increment
				store256inc %15, ^1, %7
				// sub 32 (#5 is 32...) from live X count
				sub32v %5, %5, #5
				// if X count is not 0, keep looping
				brnz32 loop_x, %5

				// decrement Y count
				sub32v %3, %3, #1
				// if 0, finished
				brz32 done, %3
				// add strides to initial addresses
				add32v %0, %0, %4
				// loop to do next line
				brz32 loop_y, #0
		done:
				fin
				fin
	);
	
    let mcode_scroll128 = assemble_jareth!(
	// x..x / $DST / $SRC in %0, aligned on 128 bits ; $DST < $SRC
	// x..x / X size in %2, multiple of 128 bits (16 bytes)
	// x..x / Y size in %3, arbitrary
	// x..x / dst_stride / src_stride in %4 (screen width)
	// -----
	// live X count in %5
	// // live Y count in %3
	// data in %7
	// 0/scrap in %15
         start:
				// reset masks (probably not necessary with the starred-instruction)
				// resm %15
		loop_y:
				// set source and destination addresses for current Y, X=first
				setadr %15, %0
				psa %5, %2
		loop_x:
				// load from SRC w/ post-increment
				load128inc %7, ^0
				// store to DST w/ post-increment
				store128inc %15, ^1, %7
				// sub 16 (#16 is 16) from live X count
				sub32v %5, %5, #16
				// if X count is not 0, keep looping
				brnz32 loop_x, %5

				// decrement Y count
				sub32v %3, %3, #1
				// if 0, finished
				brz32 done, %3
				// add strides to initial addresses
				add32v %0, %0, %4
				// loop to do next line
				brz32 loop_y, #0
		done:
				fin
				fin
	);
	
    let mcode_fill128 = assemble_jareth!(
	// x..x / $DST in %0, aligned on 128 bits
	// 128-bits pattern in %1
	// x..x / X size in %2, multiple of 128 bits (16 bytes)
	// x..x / Y size in %3, arbitrary
	// x..x / dst_stride in %4 (screen width)
	// -----
	// live X count in %5
	// // live Y count in %3
	// data in %7
	// 0/scrap in %15
         start:
				// reset masks (probably not necessary with the starred-instruction)
				// resm %15
		loop_y:
				// set source and destination addresses for current Y, X=first
				setadr %15, %0
				psa %5, %2
		loop_x:
				// store to DST w/ post-increment
				store128inc %15, ^0, %1
				// sub 16 (#16 is 16) from live X count
				sub32v %5, %5, #16
				// if X count is not 0, keep looping
				brnz32 loop_x, %5

				// decrement Y count
				sub32v %3, %3, #1
				// if 0, finished
				brz32 done, %3
				// add strides to initial addresses
				add32v %0, %0, %4
				// loop to do next line
				brz32 loop_y, #0
		done:
				fin
				fin
	);
	
    let mcode_fill256 = assemble_jareth!(
	// x..x / $DST in %0, aligned on 128 bits
	// 128-bits pattern in %1
	// x..x / X size in %2, multiple of 128 bits (16 bytes)
	// x..x / Y size in %3, arbitrary
	// x..x / dst_stride in %4 (screen width)
	// -----
	// live X count in %5
	// // live Y count in %3
	// data in %7
	// 0/scrap in %15
         start:
				// reset masks (probably not necessary with the starred-instruction)
				resm %15
				// compute X leftovers (modulo 32 -> #6 is 31)
				and %6, %2, #6
				// set the leftovers mask (offset is 0 as we are aligned)
				setmq %15, #0, %6
		loop_y:
				// set source and destination addresses for current Y, X=first
				setadr %15, %0
				// then the rounded value in X
				sub32v %5, %2, %6
		loop_x:
				// store to DST w/ post-increment
				store256inc %15, ^0, %1
				// sub 16 (#5 is 32) from live X count
				sub32v %5, %5, #5
				// if X count is not 0, keep looping
				brnz32 loop_x, %5

				// decrement Y count
				sub32v %3, %3, #1
				// if 0, finished
				brz32 done, %3
				// add strides to initial addresses
				add32v %0, %0, %4
				// loop to do next line
				brz32 loop_y, #0
		done:
				fin
				fin
	);

    let mcode_fill = assemble_jareth!(
	// x..x / $DST in %0, 128 bits
	// 128-bits pattern in %1 [assumed to be alignement-homogneous]
	// x..x / X size in %2
	// x..x / Y size in %3,
	// x..x / dst_stride in %4 (screen width?)
	// -----
	// main loop:
	// live X count in %5
	// leftover X in %6
	// // live Y count in %3
	// data in %7
	// masked data in %7
	// 0/scrap in %15
	// -----
	// header loop:
	// live Y count in %5
	// $DST in %6
	// data in %7
	// 0/scrap in %15
	

        start:
				// if number of line or element in line is 0, exit early
				brz32 done256, %2
				brz32 done256, %3
				// reset masks
				resm %15
				// if $DST is aligned on 128 bits, jump to aligned loop
				brz4 start256, %0

				// do the first column
		startX:
				// set alignement; we shift by the addr offset, and we mask whatever data is needed in the first 32 bytes
				setmq %15, %0, %2
				// copy Y
				psa %5, %3
				// copy $DST
				psa %6, %0
		loopX_y:
				// setadr
				setadr %15, %6
				// load old data
				load256 %7, ^0
				// insert pattern
				psa* %7, %1
				// rewrite data
				store256 %15, ^0, %7
				// increment copied $DST by stride
				add32v %6, %6, %4
				// decrement copied Y count
				sub32v %5, %5, #1
				// if not zero, continue
				brnz32 loopX_y, %5

		loopX_done:
				// how much did we do (#6 is 31, #5 is 32)
				and %5, %0, #6
				// compute 32-(x&31)
				sub32v %5, #5, %5
				// compute the proper value
				min32v %5, %5, %2
				// add that to the address, which will now be aligned
				add32v %0, %0, %5
				// remove from X, as we have done it
				sub32v %2, %2, %5
				// fall through the aligned loop if not 0
				brz32 done256, %2

		start256:
				// compute X leftovers (modulo 32 -> #6 is 31)
				and %6, %2, #6
				// set the leftovers mask (offset is 0 as we are aligned)
				setmq %15, #0, %6
				
		loop256_y:
				// set source and destination addresses for current Y
				setadr %15, %0
				// then the rounded value in X
				sub32v %5, %2, %6
				// already 0, bypass aligned stuff
				brz32 loop256_x_end, %5
				
		loop256_x:
				// store to DST w/ post-increment
				store256inc %15, ^0, %1
				// sub 32 (#5 is 32) from live rounded X count
				sub32v %5, %5, #5
				// if X count is not 0, keep looping
				brnz32 loop256_x, %5
				// check for line leftovers
		loop256_x_end:
				brz4 done256_x, %6

				// load old data
				load256 %7, ^0
				// insert pattern
				psa* %7, %1
				// rewrite data
				store256 %15, ^0, %7
				
		done256_x:
				// decrement Y count
				sub32v %3, %3, #1
				// if 0, finished
				brz32 done256, %3
				
				// add strides to initial addresses
				add32v %0, %0, %4
				// loop256 to do next line
				brz32 loop256_y, #0
				
		done256:		
				fin
				fin
	);
	
    let mcode_fillrop = assemble_jareth!(
	// x..x / $DST in %0, 128 bits
	// 128-bits pattern in %1 [assumed to be alignement-homogneous]
	// x..x / X size in %2
	// x..x / Y size in %3,
	// x..x / dst_stride in %4 (screen width?)
	// x..x / rop / planemask in %5 [assumed to be alignement-homogenous]
	// -----
	// main loop:
	// live X count in %8
	// leftover X in %6
	// // live Y count in %3
	// data in %7
	// masked data in %7
	// 0/scrap in %15
	// -----
	// header loop:
	// live Y count in %8
	// $DST in %6
	// data in %7
	// 0/scrap in %15
	

        start:
				// if number of line or element in line is 0, exit early
				brz32 done256, %2
				brz32 done256, %3
				// reset masks
				resm %15
				// set planemask / rop
				srop %15, %5
				// if $DST is aligned on 128 bits, jump to aligned loop
				brz4 start256, %0

				// do the first column(s)
		startX:
				// set alignement; we shift by the addr offset, and we mask whatever data is needed in the first 32 bytes
				setmq %15, %0, %2
				// copy Y
				psa %8, %3
				// copy $DST
				psa %6, %0
		loopX_y:
				// setadr
				setadr %15, %6
				// load old data
				load256 %7, ^0
				// rop & insert
				rop32v* %7, %7, %1
				// rewrite data
				store256 %15, ^0, %7
				// increment copied $DST by stride
				add32v %6, %6, %4
				// decrement copied Y count
				sub32v %8, %8, #1
				// if not zero, continue
				brnz32 loopX_y, %8

		loopX_done:
				// how much did we do (#6 is 31, #5 is 32)
				and %8, %0, #6
				// compute 32-(x&31) - upper bound
				sub32v %8, #5, %8
				// compute the proper value
				min32v %8, %8, %2
				// add that to the address, which will now be aligned if there's stuff left to do
				add32v %0, %0, %8
				// remove from X, as we have done it
				sub32v %2, %2, %8
				// fall through the aligned loop if not 0, otherwise done
				brz32 done256, %2

		start256:
				// compute X leftovers (modulo 32 -> #6 is 31)
				and %6, %2, #6
				// set the leftovers mask (offset is 0 as we are aligned)
				setmq %15, #0, %6
				
		loop256_y:
				// set source and destination addresses for current Y
				setadr %15, %0
				// then the rounded value in X
				sub32v %8, %2, %6
				// already 0, bypass aligned stuff
				brz32 loop256_x_end, %8
				
		loop256_x:
				// load  data
				load256 %7, ^0
				// rop
				rop32v %7, %7, %1
				// store to DST w/ post-increment
				store256inc %15, ^0, %7
				// sub 32 (#5 is 32) from live rounded X count
				sub32v %8, %8, #5
				// if X count is not 0, keep looping
				brnz32 loop256_x, %8
				// check for line leftovers
		loop256_x_end:
				brz4 done256_x, %6

				// load old data
				load256 %7, ^0
				// insert pattern
				rop32v* %7, %7, %1
				// rewrite data
				store256 %15, ^0, %7
				
		done256_x:
				// decrement Y count
				sub32v %3, %3, #1
				// if 0, finished
				brz32 done256, %3
				
				// add strides to initial addresses
				add32v %0, %0, %4
				// loop256 to do next line
				brz32 loop256_y, #0
				
		done256:		
				fin
				fin
	);

    let mut pos;

	pos = 0;
	println!("test code:");
    while pos < mcode.len() {
		  print!("0x{:08x},", mcode[pos]);
		  pos = pos + 1;
    }
	println!("");
	println!("-> {}", mcode.len());

	pos = 0;
	println!("scroll256:");
    while pos < mcode_scroll256.len() {
		  print!("0x{:08x},", mcode_scroll256[pos]);
		  pos = pos + 1;
    }
	println!("");
	println!("-> {}", mcode_scroll256.len());

	pos = 0;
	println!("scroll128:");
    while pos < mcode_scroll128.len() {
		  print!("0x{:08x},", mcode_scroll128[pos]);
		  pos = pos + 1;
    }
	println!("");
	println!("-> {}", mcode_scroll128.len());

	pos = 0;
	println!("fill128:");
    while pos < mcode_fill128.len() {
		  print!("0x{:08x},", mcode_fill128[pos]);
		  pos = pos + 1;
    }
	println!("");
	println!("-> {}", mcode_fill128.len());

	pos = 0;
	println!("fill256:");
    while pos < mcode_fill256.len() {
		  print!("0x{:08x},", mcode_fill256[pos]);
		  pos = pos + 1;
    }
	println!("");
	println!("-> {}", mcode_fill256.len());

	pos = 0;
	println!("fill:");
    while pos < mcode_fill.len() {
		  print!("0x{:08x},", mcode_fill[pos]);
		  pos = pos + 1;
    }
	println!("");
	println!("-> {}", mcode_fill.len());

	pos = 0;
	println!("fillrop:");
    while pos < mcode_fillrop.len() {
		  print!("0x{:08x},", mcode_fillrop[pos]);
		  pos = pos + 1;
    }
	println!("");
	println!("-> {}", mcode_fillrop.len());

	Ok(())
}
